const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { v4: uuidv4 } = require("uuid");
const axios = require("axios");

initializeApp();
const db = getFirestore();

// ─── Configuration ───
// Set these in Firebase environment config:
// firebase functions:config:set tbc.merchant_id="xxx" tbc.secret_key="xxx"
// firebase functions:config:set bog.merchant_id="xxx" bog.secret_key="xxx"
// firebase functions:config:set sms.api_key="xxx" sms.sender="MotoSlot"
// firebase functions:config:set app.base_url="https://motoslot.page.link"

const PAYMENT_TIMEOUT_MINUTES = 10;
const COLLECTIONS = {
  USERS: "users",
  SLOTS: "slots",
  BOOKINGS: "bookings",
  PAYMENTS: "payments",
  AVAILABILITY: "availability",
};

// ─── Create Payment Intent ───
// Called by the Flutter app when user taps "Pay & Confirm"
exports.createPaymentIntent = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be logged in.");
  }

  const { bookingId, userId, amount, currency, provider, callbackUrl } =
    request.data;

  if (!bookingId || !userId || !amount || !provider) {
    throw new HttpsError("invalid-argument", "Missing required fields.");
  }

  const paymentId = uuidv4();
  const now = new Date();

  // Create payment record
  const payment = {
    id: paymentId,
    bookingId,
    userId,
    amount,
    currency: currency || "GEL",
    status: "pending",
    provider,
    createdAt: now.toISOString(),
    completedAt: null,
    transactionId: null,
    errorMessage: null,
  };

  // Lock the slot atomically
  const bookingRef = db.collection(COLLECTIONS.BOOKINGS).doc(bookingId);
  const bookingDoc = await bookingRef.get();

  if (!bookingDoc.exists) {
    throw new HttpsError("not-found", "Booking not found.");
  }

  const booking = bookingDoc.data();
  const slotRef = db.collection(COLLECTIONS.SLOTS).doc(booking.slotId);

  await db.runTransaction(async (transaction) => {
    const slotDoc = await transaction.get(slotRef);
    if (!slotDoc.exists) {
      throw new HttpsError("not-found", "Slot not found.");
    }

    const slot = slotDoc.data();
    if (slot.status !== "available" && slot.status !== "locked") {
      throw new HttpsError(
        "failed-precondition",
        "Slot is no longer available."
      );
    }

    // If locked by someone else and not expired
    if (
      slot.status === "locked" &&
      slot.lockedByUserId !== userId &&
      new Date(slot.lockExpiresAt) > now
    ) {
      throw new HttpsError(
        "failed-precondition",
        "Slot is locked by another user."
      );
    }

    const lockExpiry = new Date(
      now.getTime() + PAYMENT_TIMEOUT_MINUTES * 60 * 1000
    );

    transaction.update(slotRef, {
      status: "locked",
      lockedByUserId: userId,
      lockExpiresAt: lockExpiry.toISOString(),
    });
  });

  // Generate payment URL (bank-specific)
  // In production, this would call TBC/BOG API to create a payment session
  let paymentUrl;

  if (provider === "tbc") {
    paymentUrl = await createTbcPayment(paymentId, amount, callbackUrl);
  } else if (provider === "bog") {
    paymentUrl = await createBogPayment(paymentId, amount, callbackUrl);
  }

  payment.paymentUrl = paymentUrl;

  // Save payment record
  await db.collection(COLLECTIONS.PAYMENTS).doc(paymentId).set(payment);

  return payment;
});

// ─── Verify Payment ───
// Called after payment redirect to verify with bank
exports.verifyPayment = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be logged in.");
  }

  const { paymentId, transactionId } = request.data;

  if (!paymentId) {
    throw new HttpsError("invalid-argument", "Payment ID required.");
  }

  const paymentRef = db.collection(COLLECTIONS.PAYMENTS).doc(paymentId);
  const paymentDoc = await paymentRef.get();

  if (!paymentDoc.exists) {
    throw new HttpsError("not-found", "Payment not found.");
  }

  const payment = paymentDoc.data();

  // In production: verify with bank API
  // const bankVerification = await verifyWithBank(payment.provider, transactionId);
  // For now, simulate success if transactionId is provided
  const isVerified = transactionId && transactionId.length > 0;

  if (isVerified) {
    const now = new Date();

    // Update payment
    await paymentRef.update({
      status: "success",
      transactionId,
      completedAt: now.toISOString(),
    });

    // Update booking to confirmed
    const bookingRef = db
      .collection(COLLECTIONS.BOOKINGS)
      .doc(payment.bookingId);
    await bookingRef.update({
      status: "confirmed",
      paymentId,
      confirmedAt: now.toISOString(),
    });

    // Update slot to booked
    const bookingDoc = await bookingRef.get();
    const booking = bookingDoc.data();
    await db.collection(COLLECTIONS.SLOTS).doc(booking.slotId).update({
      status: "booked",
      bookedByUserId: payment.userId,
      bookingId: payment.bookingId,
      lockedByUserId: null,
      lockExpiresAt: null,
    });

    return {
      ...payment,
      status: "success",
      transactionId,
      completedAt: now.toISOString(),
    };
  } else {
    // Payment failed
    await paymentRef.update({
      status: "failed",
      errorMessage: "Payment verification failed.",
    });

    // Release slot
    const bookingDoc = await db
      .collection(COLLECTIONS.BOOKINGS)
      .doc(payment.bookingId)
      .get();
    if (bookingDoc.exists) {
      const booking = bookingDoc.data();
      await db.collection(COLLECTIONS.SLOTS).doc(booking.slotId).update({
        status: "available",
        lockedByUserId: null,
        lockExpiresAt: null,
      });

      // Mark booking as expired
      await db
        .collection(COLLECTIONS.BOOKINGS)
        .doc(payment.bookingId)
        .update({
          status: "expired",
        });
    }

    return { ...payment, status: "failed" };
  }
});

// ─── Create Manual Booking (Admin) ───
exports.createManualBooking = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be logged in.");
  }

  // Verify admin role
  const userDoc = await db
    .collection(COLLECTIONS.USERS)
    .doc(request.auth.uid)
    .get();
  if (!userDoc.exists || userDoc.data().role !== "admin") {
    throw new HttpsError("permission-denied", "Admin access required.");
  }

  const bookingData = request.data;
  const now = new Date();

  const booking = {
    ...bookingData,
    status: "confirmed",
    isManualBooking: true,
    confirmedAt: now.toISOString(),
    createdAt: now.toISOString(),
  };

  // Atomic: create booking + mark slot as booked
  const batch = db.batch();

  batch.set(
    db.collection(COLLECTIONS.BOOKINGS).doc(booking.id),
    booking
  );

  batch.update(db.collection(COLLECTIONS.SLOTS).doc(booking.slotId), {
    status: "booked",
    bookedByUserId: booking.userId,
    bookingId: booking.id,
  });

  await batch.commit();

  // Send SMS
  try {
    await sendBookingSms({
      phone: booking.userPhone,
      bookingRef: `MS-${booking.id.substring(0, 8).toUpperCase()}`,
      dateTime: booking.startTime,
      location: booking.location || "TBD",
      instructorName: booking.instructorName || "",
      contactPhone: booking.contactPhone || "",
    });
  } catch (smsError) {
    console.error("SMS sending failed:", smsError);
    // Don't fail the booking due to SMS error
  }

  return booking;
});

// ─── Send Booking SMS ───
exports.sendBookingSms = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Must be logged in.");
  }

  await sendBookingSms(request.data);
  return { success: true };
});

// ─── Expire Stale Bookings (Scheduled) ───
// Runs every 5 minutes to clean up expired pending bookings
exports.expireStaleBookings = onSchedule(
  { schedule: "every 5 minutes", timeZone: "Asia/Tbilisi" },
  async () => {
    const now = new Date();

    // Find pending bookings that have expired
    const expiredBookings = await db
      .collection(COLLECTIONS.BOOKINGS)
      .where("status", "==", "pending_payment")
      .where("expiresAt", "<=", now.toISOString())
      .get();

    const batch = db.batch();
    let count = 0;

    for (const doc of expiredBookings.docs) {
      const booking = doc.data();

      // Mark booking as expired
      batch.update(doc.ref, { status: "expired" });

      // Release slot
      const slotRef = db.collection(COLLECTIONS.SLOTS).doc(booking.slotId);
      batch.update(slotRef, {
        status: "available",
        lockedByUserId: null,
        lockExpiresAt: null,
        bookedByUserId: null,
        bookingId: null,
      });

      count++;
    }

    // Also release locked slots with expired locks
    const expiredLocks = await db
      .collection(COLLECTIONS.SLOTS)
      .where("status", "==", "locked")
      .where("lockExpiresAt", "<=", now.toISOString())
      .get();

    for (const doc of expiredLocks.docs) {
      batch.update(doc.ref, {
        status: "available",
        lockedByUserId: null,
        lockExpiresAt: null,
      });
      count++;
    }

    if (count > 0) {
      await batch.commit();
      console.log(`Expired ${count} stale bookings/locks.`);
    }
  }
);

// ─── Helper: SMS Service ───
async function sendBookingSms(data) {
  const { phone, bookingRef, dateTime, location, instructorName, contactPhone } =
    data;

  // Format the date for display
  const lessonDate = new Date(dateTime);
  const formattedDate = lessonDate.toLocaleDateString("ka-GE", {
    year: "numeric",
    month: "long",
    day: "numeric",
    timeZone: "Asia/Tbilisi",
  });
  const formattedTime = lessonDate.toLocaleTimeString("ka-GE", {
    hour: "2-digit",
    minute: "2-digit",
    timeZone: "Asia/Tbilisi",
  });

  const message =
    `MotoSlot - Lesson Booked!\n` +
    `Ref: ${bookingRef}\n` +
    `Date: ${formattedDate}\n` +
    `Time: ${formattedTime}\n` +
    `Location: ${location}\n` +
    (instructorName ? `Instructor: ${instructorName}\n` : "") +
    (contactPhone ? `Contact: ${contactPhone}\n` : "") +
    `See you there!`;

  // SMS provider integration
  // Replace with your actual SMS provider (e.g., Twilio, Magti, Geocell)
  //
  // Example with Twilio:
  // const twilio = require('twilio')(process.env.TWILIO_SID, process.env.TWILIO_TOKEN);
  // await twilio.messages.create({
  //   body: message,
  //   from: process.env.TWILIO_PHONE,
  //   to: phone,
  // });
  //
  // Example with a Georgian SMS provider (e.g., smsoffice.ge):
  // await axios.post('https://smsoffice.ge/api/v2/send', {
  //   key: process.env.SMS_API_KEY,
  //   destination: phone,
  //   sender: 'MotoSlot',
  //   content: message,
  // });

  console.log(`SMS to ${phone}: ${message}`);
  return { success: true, message };
}

// ─── Helper: TBC Payment ───
async function createTbcPayment(paymentId, amount, callbackUrl) {
  // TBC Bank iPay Integration
  // Documentation: https://developers.tbcbank.ge/
  //
  // In production:
  // 1. POST to TBC API to create payment order
  // 2. Receive payment URL
  // 3. Redirect user to that URL
  //
  // const response = await axios.post('https://api.tbcbank.ge/v1/tpay/payments', {
  //   amount: { currency: 'GEL', total: amount },
  //   returnurl: `${callbackUrl}?paymentId=${paymentId}&status=success`,
  //   failurl: `${callbackUrl}?paymentId=${paymentId}&status=fail`,
  //   merchant_paymentid: paymentId,
  // }, {
  //   headers: {
  //     'Authorization': `Bearer ${process.env.TBC_API_KEY}`,
  //     'Content-Type': 'application/json',
  //   }
  // });
  // return response.data.links.redirect;

  // Sandbox simulation URL
  return `${callbackUrl}?paymentId=${paymentId}&transactionId=TBC-${paymentId.substring(0, 8)}&status=success`;
}

// ─── Helper: BOG Payment ───
async function createBogPayment(paymentId, amount, callbackUrl) {
  // Bank of Georgia Payment Integration
  // Documentation: https://developer.bog.ge/
  //
  // In production:
  // 1. POST to BOG API to create payment order
  // 2. Receive redirect URL
  //
  // const response = await axios.post('https://ipay.ge/opay/api/v1/checkout/orders', {
  //   intent: 'AUTHORIZE',
  //   items: [{ amount: amount, description: 'MotoSlot Lesson Booking' }],
  //   redirect_url: `${callbackUrl}?paymentId=${paymentId}&status=success`,
  //   fail_redirect_url: `${callbackUrl}?paymentId=${paymentId}&status=fail`,
  //   shop_order_id: paymentId,
  // }, {
  //   headers: {
  //     'Authorization': `Bearer ${process.env.BOG_API_KEY}`,
  //     'Content-Type': 'application/json',
  //   }
  // });
  // return response.data.links[1].href;

  // Sandbox simulation URL
  return `${callbackUrl}?paymentId=${paymentId}&transactionId=BOG-${paymentId.substring(0, 8)}&status=success`;
}
