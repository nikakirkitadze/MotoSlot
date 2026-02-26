# MotoSlot - Motorcycle Driving Academy Booking Platform

A production-ready Flutter booking platform for motorcycle driving academies with **Admin** and **User** roles, powered by Firebase.

## Quick Start

### Prerequisites
- Flutter 3.11+ / Dart 3.11+
- Firebase CLI (`npm install -g firebase-tools`)
- A Firebase project (Blaze plan for Cloud Functions)
- Android Studio or Xcode

### 1. Firebase Setup

```bash
# Login to Firebase
firebase login

# Initialize Firebase in the project
cd firebase/
firebase init

# Select: Firestore, Functions, Emulators
# Use existing project or create new one

# Deploy Firestore rules and indexes
firebase deploy --only firestore

# Deploy Cloud Functions
cd functions/
npm install
cd ..
firebase deploy --only functions
```

### 2. Add Firebase Config Files

- **Android**: Download `google-services.json` from Firebase Console, place in `android/app/`
- **iOS**: Download `GoogleService-Info.plist` from Firebase Console, place in `ios/Runner/`

### 3. Create Admin User

Using Firebase Console or a script:

```javascript
// In Firebase Console > Firestore > users collection, create:
{
  "id": "<firebase-auth-uid>",
  "email": "admin@motoslot.ge",
  "fullName": "Admin User",
  "phone": "+995555000000",
  "role": "admin",
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

Create the auth user via Firebase Console > Authentication > Add User.

### 4. Run the App

```bash
flutter pub get
flutter run
```

### 5. Quick Test Path

1. **Create Admin**: Set up admin user in Firebase (see step 3)
2. **Login as Admin**: Use admin credentials
3. **Configure Availability**: Settings tab > set working days, times, duration
4. **Generate Slots**: Settings tab > select date range > Generate Slots
5. **Register as User**: Sign out > Register with new account
6. **Book a Lesson**: Select date > Pick slot > Pay & Confirm
7. **Admin Manual Book**: Login as admin > Calendar > Manual Book > Search user > Select slot > Create

---

## Architecture Notes

### Module Structure

```
lib/
├── app/                    # App bootstrap, router, theme
│   ├── router.dart         # GoRouter configuration
│   └── theme.dart          # Material theme + brand colors
├── core/                   # Shared infrastructure
│   ├── constants/          # App-wide constants
│   ├── errors/             # Exception + Failure classes
│   ├── network/            # Dio API client
│   ├── storage/            # Secure storage service
│   ├── utils/              # Date utils, validators, enums
│   └── widgets/            # Reusable UI components
├── di/                     # Dependency injection (GetIt)
│   └── injection.dart
└── modules/                # Feature modules
    ├── auth/               # Authentication
    ├── booking/            # Slots + Bookings (user)
    ├── calendar/           # Calendar views
    ├── payments/           # Payment processing
    ├── notifications/      # Local push notifications
    ├── admin/              # Admin features
    └── profile/            # User profile (extensible)
```

Each module follows clean architecture:
```
module/
├── data/
│   ├── repository/         # Data access (Firestore, API)
│   └── dto/                # Data transfer objects
├── domain/
│   └── model/              # Business models (Equatable)
└── presentation/
    ├── cubit/              # State management (Cubit + State)
    └── view/               # UI screens
```

### State Flow (Cubit Pattern)

```
View -> Cubit.method() -> Repository -> Firebase/API
                 |
         emit(NewState)
                 |
   BlocBuilder/BlocListener -> UI Update
```

Every state includes:
- `StateStatus` enum: `initial | loading | success | failure`
- `errorMessage` for user-friendly error display
- Immutable state with `copyWith` pattern

### Cubits

| Cubit | Responsibility |
|-------|---------------|
| `AuthCubit` | Login, register, password reset, session management |
| `UserSlotsCubit` | Fetch available slots, date selection |
| `BookingCubit` | Create pending booking, handle payment, confirm/cancel |
| `AdminAvailabilityCubit` | Configure working hours, generate slots, block dates |
| `AdminBookingsCubit` | Manual booking, reschedule, cancel, complete |
| `NotificationsCubit` | Schedule local reminders (24h + 1h before) |
| `PaymentCubit` | Create payment intent, verify payment |

### Slot Locking Strategy

```
User taps "Pay & Confirm"
    |
1. Create Pending Booking (status: pending_payment, expiresAt: now + 10min)
2. Lock Slot atomically via Firestore Transaction
   - Check slot.status == "available" (or expired lock)
   - Set status = "locked", lockedByUserId, lockExpiresAt
3. Create Payment Intent (Cloud Function)
   - Returns bank payment URL
4. Open WebView -> Bank Payment Page
5. Bank redirects to motoslot://payment-result?status=...
6. Verify Payment (Cloud Function)
   - On success: booking -> confirmed, slot -> booked
   - On failure: booking -> expired, slot -> available
7. Scheduled Cloud Function runs every 5 min
   - Expires stale pending_payment bookings past TTL
   - Releases locked slots with expired locks
```

**No double-booking guarantee**: Firestore transactions ensure atomic read-check-write on slot status.

### Payment Verification

```
Flutter App                    Cloud Functions              Bank (TBC/BOG)
    |                               |                           |
    |-- createPaymentIntent() ----->|                           |
    |                               |-- Lock slot (transaction) |
    |                               |-- Create payment record   |
    |   <-- { paymentUrl } ---------|                           |
    |                               |                           |
    |-- Open WebView(paymentUrl) -------------------------------->|
    |                               |                           |
    |   <-- Redirect to motoslot://payment-result ---------------|
    |                               |                           |
    |-- verifyPayment() ----------->|                           |
    |                               |-- Verify with bank API -->|
    |                               |   <-- verification -------|
    |                               |-- Update booking/slot     |
    |   <-- { payment } ------------|                           |
```

### All Times in UTC

- Firestore stores all `DateTime` in UTC ISO 8601
- Flutter displays using `DateTime.toLocal()` (device timezone)
- Calendar UI works with local dates for selection
- Asia/Tbilisi timezone used for notification scheduling

---

## Data Schema

### Users
```json
{
  "id": "uid",
  "email": "user@example.com",
  "fullName": "John Doe",
  "phone": "+995555123456",
  "role": "user | admin",
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": null
}
```

### Slots
```json
{
  "id": "uuid",
  "startTime": "2026-03-15T09:00:00.000Z",
  "endTime": "2026-03-15T10:00:00.000Z",
  "durationMinutes": 60,
  "status": "available | locked | booked | blocked",
  "bookedByUserId": null,
  "bookingId": null,
  "lockedByUserId": null,
  "lockExpiresAt": null,
  "instructorName": "Giorgi",
  "location": "Tbilisi Training Ground",
  "createdAt": "2026-01-01T00:00:00.000Z"
}
```

### Bookings
```json
{
  "id": "uuid",
  "slotId": "slot-uuid",
  "userId": "user-uid",
  "userFullName": "John Doe",
  "userPhone": "+995555123456",
  "userEmail": "user@example.com",
  "startTime": "2026-03-15T09:00:00.000Z",
  "endTime": "2026-03-15T10:00:00.000Z",
  "durationMinutes": 60,
  "status": "pending_payment | confirmed | cancelled | completed | expired",
  "paymentId": null,
  "amount": 50.0,
  "instructorName": "Giorgi",
  "location": "Tbilisi Training Ground",
  "contactPhone": "+995555000000",
  "cancellationReason": null,
  "isManualBooking": false,
  "createdAt": "2026-03-14T10:00:00.000Z",
  "confirmedAt": null,
  "cancelledAt": null,
  "completedAt": null,
  "expiresAt": "2026-03-14T10:10:00.000Z"
}
```

### Payments
```json
{
  "id": "uuid",
  "bookingId": "booking-uuid",
  "userId": "user-uid",
  "amount": 50.0,
  "currency": "GEL",
  "status": "pending | processing | success | failed | cancelled",
  "provider": "tbc | bog",
  "transactionId": "TBC-abc123",
  "paymentUrl": "https://...",
  "errorMessage": null,
  "createdAt": "2026-03-14T10:00:00.000Z",
  "completedAt": null
}
```

### Availability Config
```json
{
  "id": "uuid",
  "workingDays": [1, 2, 3, 4, 5],
  "startTime": "09:00",
  "endTime": "18:00",
  "lessonDurationMinutes": 60,
  "bufferMinutes": 15,
  "blockedDates": ["2026-03-20T00:00:00.000Z"],
  "instructorName": "Giorgi",
  "location": "Tbilisi Training Ground",
  "createdAt": "2026-01-01T00:00:00.000Z",
  "updatedAt": null
}
```

---

## Cloud Functions API

| Function | Type | Description |
|----------|------|-------------|
| `createPaymentIntent` | Callable | Creates payment, locks slot, returns bank URL |
| `verifyPayment` | Callable | Verifies with bank, confirms booking |
| `createManualBooking` | Callable | Admin manual booking + SMS (atomic) |
| `sendBookingSms` | Callable | Sends SMS notification |
| `expireStaleBookings` | Scheduled | Every 5 min: expires pending bookings, releases locks |

---

## Environment / Secrets

### Firebase Functions Config
```bash
firebase functions:config:set \
  tbc.merchant_id="YOUR_TBC_MERCHANT_ID" \
  tbc.secret_key="YOUR_TBC_SECRET" \
  bog.merchant_id="YOUR_BOG_MERCHANT_ID" \
  bog.secret_key="YOUR_BOG_SECRET" \
  sms.api_key="YOUR_SMS_API_KEY" \
  sms.sender="MotoSlot"
```

### Payment Providers

The payment module uses a provider abstraction:
- `PaymentProvider.tbc` - TBC Bank iPay
- `PaymentProvider.bog` - Bank of Georgia iPay

Both follow redirect-based flow:
1. Backend creates payment order via bank API
2. Returns redirect URL
3. App opens WebView
4. Bank processes payment
5. Redirects to `motoslot://payment-result?status=...&transactionId=...`
6. App calls backend to verify

Currently configured with sandbox simulation. Replace the payment helper functions in `firebase/functions/index.js` with real bank API calls.

### SMS Providers

SMS integration is abstracted in `sendBookingSms()` Cloud Function. Uncomment the provider you use:
- **Twilio**: International, reliable
- **smsoffice.ge**: Georgian local provider
- **Magti/Geocell**: Georgian carriers

---

## Package IDs

| Platform | Identifier |
|----------|-----------|
| Android | `ge.motoslot.app` |
| iOS | `ge.motoslot.app` |
| Deep Link | `motoslot://payment-result` |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.11+, Dart 3.11+ |
| State | flutter_bloc (Cubit pattern) |
| Navigation | go_router |
| Backend | Firebase (Auth, Firestore, Cloud Functions) |
| Calendar | table_calendar |
| Notifications | flutter_local_notifications |
| Payments | WebView redirect + Cloud Functions verification |
| DI | get_it |
| Storage | flutter_secure_storage |
