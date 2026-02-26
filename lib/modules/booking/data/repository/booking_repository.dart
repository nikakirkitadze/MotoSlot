import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class BookingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  BookingRepository({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _functions = functions;

  CollectionReference<Map<String, dynamic>> get _bookingsRef =>
      _firestore.collection(AppConstants.bookingsCollection);

  Future<Booking> createPendingBooking(Booking booking) async {
    try {
      await _bookingsRef.doc(booking.id).set(booking.toJson());
      return booking;
    } catch (e) {
      throw BookingException(
        message: 'Failed to create booking.',
        originalError: e,
      );
    }
  }

  Future<Booking> confirmBooking({
    required String bookingId,
    required String paymentId,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      await _bookingsRef.doc(bookingId).update({
        'status': BookingStatus.confirmed.value,
        'paymentId': paymentId,
        'confirmedAt': now.toIso8601String(),
      });

      final doc = await _bookingsRef.doc(bookingId).get();
      return Booking.fromJson(doc.data()!);
    } catch (e) {
      throw BookingException(
        message: 'Failed to confirm booking.',
        originalError: e,
      );
    }
  }

  Future<void> cancelBooking({
    required String bookingId,
    String? reason,
  }) async {
    try {
      await _bookingsRef.doc(bookingId).update({
        'status': BookingStatus.cancelled.value,
        'cancellationReason': reason,
        'cancelledAt': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (e) {
      throw BookingException(
        message: 'Failed to cancel booking.',
        originalError: e,
      );
    }
  }

  Future<void> expireBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).update({
      'status': BookingStatus.expired.value,
    });
  }

  Future<void> completeBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).update({
      'status': BookingStatus.completed.value,
      'completedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<Booking?> getBookingById(String bookingId) async {
    final doc = await _bookingsRef.doc(bookingId).get();
    if (!doc.exists || doc.data() == null) return null;
    return Booking.fromJson(doc.data()!);
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final snapshot = await _bookingsRef
          .where('userId', isEqualTo: userId)
          .orderBy('startTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Booking.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw BookingException(
        message: 'Failed to fetch your bookings.',
        originalError: e,
      );
    }
  }

  Future<List<Booking>> getAllBookings({
    DateTime? fromDate,
    DateTime? toDate,
    BookingStatus? status,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _bookingsRef;

      if (fromDate != null) {
        query = query.where('startTime',
            isGreaterThanOrEqualTo: fromDate.toUtc().toIso8601String());
      }
      if (toDate != null) {
        query = query.where('startTime',
            isLessThanOrEqualTo: toDate.toUtc().toIso8601String());
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status.value);
      }

      query = query.orderBy('startTime', descending: true);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Booking.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw BookingException(
        message: 'Failed to fetch bookings.',
        originalError: e,
      );
    }
  }

  Future<List<Booking>> getBookingsForDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getAllBookings(fromDate: startOfDay, toDate: endOfDay);
  }

  Future<Booking> createManualBooking({
    required Booking booking,
  }) async {
    try {
      // Use Cloud Function for atomic manual booking + SMS
      final result = await _functions
          .httpsCallable('createManualBooking')
          .call(booking.toJson());

      return Booking.fromJson(
        Map<String, dynamic>.from(result.data as Map),
      );
    } catch (e) {
      // Fallback to direct Firestore write
      final manualBooking = booking.copyWith(
        status: BookingStatus.confirmed,
        isManualBooking: true,
        confirmedAt: DateTime.now().toUtc(),
      );
      await _bookingsRef.doc(manualBooking.id).set(manualBooking.toJson());
      return manualBooking;
    }
  }

  Future<void> rescheduleBooking({
    required String bookingId,
    required String newSlotId,
    required DateTime newStartTime,
    required DateTime newEndTime,
  }) async {
    await _bookingsRef.doc(bookingId).update({
      'slotId': newSlotId,
      'startTime': newStartTime.toUtc().toIso8601String(),
      'endTime': newEndTime.toUtc().toIso8601String(),
    });
  }
}
