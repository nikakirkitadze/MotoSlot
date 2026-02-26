class AppConstants {
  AppConstants._();

  static const String appName = 'MotoSlot';
  static const String deepLinkScheme = 'motoslot';
  static const String deepLinkHost = 'payment-result';
  static const String tbilisiTimezone = 'Asia/Tbilisi';

  // Booking
  static const int paymentTimeoutMinutes = 10;
  static const int reminderHoursBefore = 24;
  static const int reminderMinutesBefore = 60;

  // Default lesson durations
  static const List<int> lessonDurations = [60, 90, 120];
  static const int defaultBufferMinutes = 15;

  // Firestore collections
  static const String usersCollection = 'users';
  static const String slotsCollection = 'slots';
  static const String bookingsCollection = 'bookings';
  static const String availabilityCollection = 'availability';
  static const String paymentsCollection = 'payments';

  // Booking statuses
  static const String statusPendingPayment = 'pending_payment';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  static const String statusCompleted = 'completed';
  static const String statusExpired = 'expired';
}
