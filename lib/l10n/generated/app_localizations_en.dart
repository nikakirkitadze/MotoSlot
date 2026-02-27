// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MotoSlot';

  @override
  String get appTagline => 'Motorcycle Driving Academy';

  @override
  String get signOut => 'Sign Out';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get select => 'Select';

  @override
  String get today => 'Today';

  @override
  String get all => 'All';

  @override
  String get none => 'None';

  @override
  String get loading => 'Loading...';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String gelCurrency(String amount) {
    return '$amount GEL';
  }

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String minutesFull(int count) {
    return '$count minutes';
  }

  @override
  String minLesson(int count) {
    return '$count min lesson';
  }

  @override
  String get welcomeToMotoSlot => 'Welcome to MotoSlot';

  @override
  String get signInSubtitle => 'Sign in to manage your lessons';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinMotoSlot => 'Join MotoSlot';

  @override
  String get createAccountSubtitle =>
      'Create an account to book your motorcycle lessons';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneHint => '+995 XXX XXX XXX';

  @override
  String get createPassword => 'Create a password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get forgotPasswordTitle => 'Forgot your password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get emailAddressHint => 'Enter your email address';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailSent => 'Email sent!';

  @override
  String get checkInboxForReset =>
      'Check your inbox for a password reset link.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get signOutConfirmTitle => 'Sign Out';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get resetEmailFailed => 'Failed to send reset email.';

  @override
  String get validatorEmailRequired => 'Email is required';

  @override
  String get validatorEmailInvalid => 'Please enter a valid email address';

  @override
  String get validatorPasswordRequired => 'Password is required';

  @override
  String get validatorPasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get validatorNameRequired => 'Name is required';

  @override
  String get validatorNameMinLength => 'Name must be at least 2 characters';

  @override
  String get validatorPhoneRequired => 'Phone number is required';

  @override
  String get validatorPhoneInvalid => 'Please enter a valid phone number';

  @override
  String validatorFieldRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String get validatorConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get validatorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get book => 'Book';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get loadingBookings => 'Loading bookings...';

  @override
  String get failedToLoadBookings => 'Failed to load bookings';

  @override
  String get noUpcomingBookings => 'No upcoming bookings';

  @override
  String get noUpcomingBookingsSubtitle =>
      'Book your first lesson from the calendar';

  @override
  String get noPastBookings => 'No past bookings';

  @override
  String get noPastBookingsSubtitle =>
      'Your completed lessons will appear here';

  @override
  String get loadingAvailableSlots => 'Loading available slots...';

  @override
  String get failedToLoadSlots => 'Failed to load slots';

  @override
  String get noAvailableSlots => 'No available slots';

  @override
  String get noAvailableSlotsSubtitle => 'Try selecting a different date';

  @override
  String availableOn(String date) {
    return 'Available on $date';
  }

  @override
  String get slotDetails => 'Slot Details';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get duration => 'Duration';

  @override
  String get instructor => 'Instructor';

  @override
  String get location => 'Location';

  @override
  String get lessonFee => 'Lesson Fee';

  @override
  String get payAndConfirmBooking => 'Pay & Confirm Booking';

  @override
  String get slotHeldDuringPayment =>
      'Your slot will be held for 10 minutes during payment.';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get lessonDetails => 'Lesson Details';

  @override
  String get contact => 'Contact';

  @override
  String get amount => 'Amount';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get cancelBookingConfirmTitle => 'Cancel Booking?';

  @override
  String get cancelBookingConfirmMessage =>
      'Are you sure you want to cancel this booking? This action cannot be undone.';

  @override
  String get keepBooking => 'Keep Booking';

  @override
  String get failedToCreateBooking => 'Failed to create booking.';

  @override
  String get failedToLoadAvailableSlots => 'Failed to load available slots.';

  @override
  String get bookingConfirmed => 'Booking Confirmed!';

  @override
  String get bookingConfirmedSubtitle =>
      'Your motorcycle lesson has been booked successfully.';

  @override
  String get bookingReference => 'Booking Reference';

  @override
  String get amountPaid => 'Amount Paid';

  @override
  String get reminderNotice =>
      'You will receive reminders 24 hours and 1 hour before your lesson.';

  @override
  String get viewMyBookings => 'View My Bookings';

  @override
  String get bookAnotherLesson => 'Book Another Lesson';

  @override
  String get payment => 'Payment';

  @override
  String get amountDue => 'Amount Due';

  @override
  String refLabel(String reference) {
    return 'Ref: $reference';
  }

  @override
  String get selectPaymentMethod => 'Select Payment Method';

  @override
  String get tbcBank => 'TBC Bank';

  @override
  String get payWithTbcCard => 'Pay with TBC Bank card';

  @override
  String get bankOfGeorgia => 'Bank of Georgia';

  @override
  String get payWithBogCard => 'Pay with BOG card';

  @override
  String get processingPayment => 'Processing payment...';

  @override
  String get paymentRedirectNotice =>
      'You will be redirected to the bank\'s secure payment page. Your slot is held for 10 minutes.';

  @override
  String get cancelPaymentTitle => 'Cancel Payment?';

  @override
  String get cancelPaymentMessage =>
      'Your booking will be cancelled and the slot will be released.';

  @override
  String get continuePayment => 'Continue Payment';

  @override
  String get securePayment => 'Secure Payment';

  @override
  String get loadingPaymentPage => 'Loading payment page...';

  @override
  String get paymentVerificationFailed => 'Payment verification failed.';

  @override
  String get paymentNotCompleted => 'Payment was not completed.';

  @override
  String get paymentVerificationError => 'Payment verification error.';

  @override
  String get admin => 'ADMIN';

  @override
  String get calendar => 'Calendar';

  @override
  String get bookings => 'Bookings';

  @override
  String get settings => 'Settings';

  @override
  String get manualBook => 'Manual Book';

  @override
  String get blockDate => 'Block Date';

  @override
  String get unblockDate => 'Unblock Date';

  @override
  String get noBookingsForDay => 'No bookings for this day';

  @override
  String get noBookingsForDaySubtitle =>
      'Bookings will appear here when users book slots';

  @override
  String get noBookingsFound => 'No bookings found';

  @override
  String get noBookingsFoundSubtitle => 'Try adjusting the filter';

  @override
  String get manualBooking => 'Manual Booking';

  @override
  String get userInformation => 'User Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get cancelBookingAdminMessage =>
      'This will release the slot and notify the user.';

  @override
  String get keep => 'Keep';

  @override
  String get studentInfo => '1. Student Info';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'First name';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Last name';

  @override
  String get selectSlot => '2. Select Slot';

  @override
  String get noSlotsForDate => 'No available slots for selected date.';

  @override
  String get bookingDetailsStep => '3. Booking Details';

  @override
  String get autoFilledFromSettings =>
      'Auto-filled from your settings. Edit if needed.';

  @override
  String get instructorName => 'Instructor Name';

  @override
  String get instructorNameHint => 'Default instructor name';

  @override
  String get enterInstructorName => 'Enter instructor name';

  @override
  String get defaultLocation => 'Default Location';

  @override
  String get defaultLocationHint => 'Training ground address';

  @override
  String get enterLessonLocation => 'Enter lesson location';

  @override
  String get contactPhone => 'Contact Phone';

  @override
  String get contactPhoneHint => 'Phone number sent to students';

  @override
  String get contactPhoneBookingHint => 'Contact phone number';

  @override
  String get createBookingAndSendSms => 'Create Booking & Send SMS';

  @override
  String get availabilitySettings => 'Availability Settings';

  @override
  String get workingDays => 'Working Days';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get lessonDuration => 'Lesson Duration';

  @override
  String get bufferBetweenLessons => 'Buffer Between Lessons';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get generateSlots => 'Generate Slots';

  @override
  String get generateSlotsSubtitle =>
      'Generate bookable slots based on your availability settings.';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get settingsSaved => 'Availability settings saved.';

  @override
  String get configureSettingsFirst =>
      'Please configure availability settings first.';

  @override
  String slotsGenerated(int count) {
    return '$count slots generated.';
  }

  @override
  String get dateBlocked => 'Date blocked successfully.';

  @override
  String get dateUnblocked => 'Date unblocked.';

  @override
  String bookingCreatedSmsSent(String phone) {
    return 'Booking created and SMS sent to $phone.';
  }

  @override
  String get bookingCancelled => 'Booking cancelled.';

  @override
  String get bookingMarkedCompleted => 'Booking marked as completed.';

  @override
  String failedToLoadSlotsError(String error) {
    return 'Failed to load slots: $error';
  }

  @override
  String get bookingStatusPendingPayment => 'Pending Payment';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusExpired => 'Expired';

  @override
  String get slotStatusAvailable => 'Available';

  @override
  String get slotStatusLocked => 'Locked';

  @override
  String get slotStatusBooked => 'Booked';

  @override
  String get slotStatusBlocked => 'Blocked';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentStatusProcessing => 'Processing';

  @override
  String get paymentStatusSuccess => 'Success';

  @override
  String get paymentStatusFailed => 'Failed';

  @override
  String get paymentStatusCancelled => 'Cancelled';

  @override
  String get paymentProviderTbc => 'TBC Bank';

  @override
  String get paymentProviderBog => 'Bank of Georgia';

  @override
  String get dayMonday => 'Monday';

  @override
  String get dayTuesday => 'Tuesday';

  @override
  String get dayWednesday => 'Wednesday';

  @override
  String get dayThursday => 'Thursday';

  @override
  String get dayFriday => 'Friday';

  @override
  String get daySaturday => 'Saturday';

  @override
  String get daySunday => 'Sunday';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get georgian => 'Georgian';

  @override
  String get logIn => 'Log In';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get signUp => 'Sign Up';

  @override
  String get scheduleLesson => 'Schedule Lesson';

  @override
  String availableSlotsFor(String date) {
    return 'Available Slots for $date';
  }

  @override
  String get bookNow => 'Book Now';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get selectTimeSlot => 'Select Time Slot';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get continueToPayment => 'Continue to Payment';

  @override
  String get bookingPaymentSummary => 'Booking Payment Summary';

  @override
  String get payNow => 'Pay Now';

  @override
  String get bookingConfirmation => 'Booking Confirmation';

  @override
  String get bookingSuccessful => 'Booking Successful!';

  @override
  String get lesson => 'Lesson';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get adminAnalyticsDashboard => 'Admin Analytics Dashboard';

  @override
  String get totalBookings => 'Total Bookings';

  @override
  String get revenue => 'Revenue';

  @override
  String get activeUsers => 'Active Users';

  @override
  String get thisMonth => 'this month';

  @override
  String get filter => 'Filter';

  @override
  String get upcomingLessons => 'Upcoming Lessons';

  @override
  String get seeAll => 'See All';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get users => 'Users';

  @override
  String get noBookingsYet => 'No Bookings Yet';

  @override
  String get noBookingsYetSubtitle =>
      'Your motorcycle lesson bookings will appear here once scheduled.';

  @override
  String get signOutMessage =>
      'Are you sure you want to sign out? You will need to sign in again to manage your bookings.';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get pending => 'Pending';

  @override
  String get secureSSLEncrypted => 'Secure SSL Encrypted';

  @override
  String get termsAgreement =>
      'By tapping Pay Now, you agree to our Terms & Conditions.';
}
