import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ka.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ka'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MotoSlot'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle Driving Academy'**
  String get appTagline;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @gelCurrency.
  ///
  /// In en, this message translates to:
  /// **'{amount} GEL'**
  String gelCurrency(String amount);

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesShort(int count);

  /// No description provided for @minutesFull.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesFull(int count);

  /// No description provided for @minLesson.
  ///
  /// In en, this message translates to:
  /// **'{count} min lesson'**
  String minLesson(int count);

  /// No description provided for @welcomeToMotoSlot.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MotoSlot'**
  String get welcomeToMotoSlot;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your lessons'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinMotoSlot.
  ///
  /// In en, this message translates to:
  /// **'Join MotoSlot'**
  String get joinMotoSlot;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to book your motorcycle lessons'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+995 XXX XXX XXX'**
  String get phoneHint;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailAddressHint;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email sent!'**
  String get emailSent;

  /// No description provided for @checkInboxForReset.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox for a password reset link.'**
  String get checkInboxForReset;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmMessage;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @resetEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email.'**
  String get resetEmailFailed;

  /// No description provided for @validatorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validatorEmailRequired;

  /// No description provided for @validatorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validatorEmailInvalid;

  /// No description provided for @validatorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validatorPasswordRequired;

  /// No description provided for @validatorPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validatorPasswordMinLength;

  /// No description provided for @validatorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validatorNameRequired;

  /// No description provided for @validatorNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get validatorNameMinLength;

  /// No description provided for @validatorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validatorPhoneRequired;

  /// No description provided for @validatorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validatorPhoneInvalid;

  /// No description provided for @validatorFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String validatorFieldRequired(String fieldName);

  /// No description provided for @validatorConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get validatorConfirmPasswordRequired;

  /// No description provided for @validatorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validatorPasswordsDoNotMatch;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @loadingBookings.
  ///
  /// In en, this message translates to:
  /// **'Loading bookings...'**
  String get loadingBookings;

  /// No description provided for @failedToLoadBookings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load bookings'**
  String get failedToLoadBookings;

  /// No description provided for @noUpcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'No upcoming bookings'**
  String get noUpcomingBookings;

  /// No description provided for @noUpcomingBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book your first lesson from the calendar'**
  String get noUpcomingBookingsSubtitle;

  /// No description provided for @noPastBookings.
  ///
  /// In en, this message translates to:
  /// **'No past bookings'**
  String get noPastBookings;

  /// No description provided for @noPastBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your completed lessons will appear here'**
  String get noPastBookingsSubtitle;

  /// No description provided for @loadingAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'Loading available slots...'**
  String get loadingAvailableSlots;

  /// No description provided for @failedToLoadSlots.
  ///
  /// In en, this message translates to:
  /// **'Failed to load slots'**
  String get failedToLoadSlots;

  /// No description provided for @noAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'No available slots'**
  String get noAvailableSlots;

  /// No description provided for @noAvailableSlotsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different date'**
  String get noAvailableSlotsSubtitle;

  /// No description provided for @availableOn.
  ///
  /// In en, this message translates to:
  /// **'Available on {date}'**
  String availableOn(String date);

  /// No description provided for @slotDetails.
  ///
  /// In en, this message translates to:
  /// **'Slot Details'**
  String get slotDetails;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @lessonFee.
  ///
  /// In en, this message translates to:
  /// **'Lesson Fee'**
  String get lessonFee;

  /// No description provided for @payAndConfirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Pay & Confirm Booking'**
  String get payAndConfirmBooking;

  /// No description provided for @slotHeldDuringPayment.
  ///
  /// In en, this message translates to:
  /// **'Your slot will be held for 10 minutes during payment.'**
  String get slotHeldDuringPayment;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @lessonDetails.
  ///
  /// In en, this message translates to:
  /// **'Lesson Details'**
  String get lessonDetails;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking?'**
  String get cancelBookingConfirmTitle;

  /// No description provided for @cancelBookingConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking? This action cannot be undone.'**
  String get cancelBookingConfirmMessage;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep Booking'**
  String get keepBooking;

  /// No description provided for @failedToCreateBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to create booking.'**
  String get failedToCreateBooking;

  /// No description provided for @failedToLoadAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'Failed to load available slots.'**
  String get failedToLoadAvailableSlots;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @bookingConfirmedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your motorcycle lesson has been booked successfully.'**
  String get bookingConfirmedSubtitle;

  /// No description provided for @bookingReference.
  ///
  /// In en, this message translates to:
  /// **'Booking Reference'**
  String get bookingReference;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaid;

  /// No description provided for @reminderNotice.
  ///
  /// In en, this message translates to:
  /// **'You will receive reminders 24 hours and 1 hour before your lesson.'**
  String get reminderNotice;

  /// No description provided for @viewMyBookings.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get viewMyBookings;

  /// No description provided for @bookAnotherLesson.
  ///
  /// In en, this message translates to:
  /// **'Book Another Lesson'**
  String get bookAnotherLesson;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get amountDue;

  /// No description provided for @refLabel.
  ///
  /// In en, this message translates to:
  /// **'Ref: {reference}'**
  String refLabel(String reference);

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @tbcBank.
  ///
  /// In en, this message translates to:
  /// **'TBC Bank'**
  String get tbcBank;

  /// No description provided for @payWithTbcCard.
  ///
  /// In en, this message translates to:
  /// **'Pay with TBC Bank card'**
  String get payWithTbcCard;

  /// No description provided for @bankOfGeorgia.
  ///
  /// In en, this message translates to:
  /// **'Bank of Georgia'**
  String get bankOfGeorgia;

  /// No description provided for @payWithBogCard.
  ///
  /// In en, this message translates to:
  /// **'Pay with BOG card'**
  String get payWithBogCard;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processingPayment;

  /// No description provided for @paymentRedirectNotice.
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to the bank\'s secure payment page. Your slot is held for 10 minutes.'**
  String get paymentRedirectNotice;

  /// No description provided for @cancelPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Payment?'**
  String get cancelPaymentTitle;

  /// No description provided for @cancelPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'Your booking will be cancelled and the slot will be released.'**
  String get cancelPaymentMessage;

  /// No description provided for @continuePayment.
  ///
  /// In en, this message translates to:
  /// **'Continue Payment'**
  String get continuePayment;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Payment'**
  String get securePayment;

  /// No description provided for @loadingPaymentPage.
  ///
  /// In en, this message translates to:
  /// **'Loading payment page...'**
  String get loadingPaymentPage;

  /// No description provided for @paymentVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment verification failed.'**
  String get paymentVerificationFailed;

  /// No description provided for @paymentNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Payment was not completed.'**
  String get paymentNotCompleted;

  /// No description provided for @paymentVerificationError.
  ///
  /// In en, this message translates to:
  /// **'Payment verification error.'**
  String get paymentVerificationError;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get admin;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @manualBook.
  ///
  /// In en, this message translates to:
  /// **'Manual Book'**
  String get manualBook;

  /// No description provided for @blockDate.
  ///
  /// In en, this message translates to:
  /// **'Block Date'**
  String get blockDate;

  /// No description provided for @unblockDate.
  ///
  /// In en, this message translates to:
  /// **'Unblock Date'**
  String get unblockDate;

  /// No description provided for @noBookingsForDay.
  ///
  /// In en, this message translates to:
  /// **'No bookings for this day'**
  String get noBookingsForDay;

  /// No description provided for @noBookingsForDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings will appear here when users book slots'**
  String get noBookingsForDaySubtitle;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// No description provided for @noBookingsFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the filter'**
  String get noBookingsFoundSubtitle;

  /// No description provided for @manualBooking.
  ///
  /// In en, this message translates to:
  /// **'Manual Booking'**
  String get manualBooking;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @cancelBookingAdminMessage.
  ///
  /// In en, this message translates to:
  /// **'This will release the slot and notify the user.'**
  String get cancelBookingAdminMessage;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @studentInfo.
  ///
  /// In en, this message translates to:
  /// **'1. Student Info'**
  String get studentInfo;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @selectSlot.
  ///
  /// In en, this message translates to:
  /// **'2. Select Slot'**
  String get selectSlot;

  /// No description provided for @noSlotsForDate.
  ///
  /// In en, this message translates to:
  /// **'No available slots for selected date.'**
  String get noSlotsForDate;

  /// No description provided for @bookingDetailsStep.
  ///
  /// In en, this message translates to:
  /// **'3. Booking Details'**
  String get bookingDetailsStep;

  /// No description provided for @autoFilledFromSettings.
  ///
  /// In en, this message translates to:
  /// **'Auto-filled from your settings. Edit if needed.'**
  String get autoFilledFromSettings;

  /// No description provided for @instructorName.
  ///
  /// In en, this message translates to:
  /// **'Instructor Name'**
  String get instructorName;

  /// No description provided for @instructorNameHint.
  ///
  /// In en, this message translates to:
  /// **'Default instructor name'**
  String get instructorNameHint;

  /// No description provided for @enterInstructorName.
  ///
  /// In en, this message translates to:
  /// **'Enter instructor name'**
  String get enterInstructorName;

  /// No description provided for @defaultLocation.
  ///
  /// In en, this message translates to:
  /// **'Default Location'**
  String get defaultLocation;

  /// No description provided for @defaultLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Training ground address'**
  String get defaultLocationHint;

  /// No description provided for @enterLessonLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter lesson location'**
  String get enterLessonLocation;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Contact Phone'**
  String get contactPhone;

  /// No description provided for @contactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number sent to students'**
  String get contactPhoneHint;

  /// No description provided for @contactPhoneBookingHint.
  ///
  /// In en, this message translates to:
  /// **'Contact phone number'**
  String get contactPhoneBookingHint;

  /// No description provided for @createBookingAndSendSms.
  ///
  /// In en, this message translates to:
  /// **'Create Booking & Send SMS'**
  String get createBookingAndSendSms;

  /// No description provided for @availabilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Availability Settings'**
  String get availabilitySettings;

  /// No description provided for @workingDays.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get workingDays;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @lessonDuration.
  ///
  /// In en, this message translates to:
  /// **'Lesson Duration'**
  String get lessonDuration;

  /// No description provided for @bufferBetweenLessons.
  ///
  /// In en, this message translates to:
  /// **'Buffer Between Lessons'**
  String get bufferBetweenLessons;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @generateSlots.
  ///
  /// In en, this message translates to:
  /// **'Generate Slots'**
  String get generateSlots;

  /// No description provided for @generateSlotsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate bookable slots based on your availability settings.'**
  String get generateSlotsSubtitle;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Availability settings saved.'**
  String get settingsSaved;

  /// No description provided for @configureSettingsFirst.
  ///
  /// In en, this message translates to:
  /// **'Please configure availability settings first.'**
  String get configureSettingsFirst;

  /// No description provided for @slotsGenerated.
  ///
  /// In en, this message translates to:
  /// **'{count} slots generated.'**
  String slotsGenerated(int count);

  /// No description provided for @dateBlocked.
  ///
  /// In en, this message translates to:
  /// **'Date blocked successfully.'**
  String get dateBlocked;

  /// No description provided for @dateUnblocked.
  ///
  /// In en, this message translates to:
  /// **'Date unblocked.'**
  String get dateUnblocked;

  /// No description provided for @bookingCreatedSmsSent.
  ///
  /// In en, this message translates to:
  /// **'Booking created and SMS sent to {phone}.'**
  String bookingCreatedSmsSent(String phone);

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingCancelled;

  /// No description provided for @bookingMarkedCompleted.
  ///
  /// In en, this message translates to:
  /// **'Booking marked as completed.'**
  String get bookingMarkedCompleted;

  /// No description provided for @failedToLoadSlotsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load slots: {error}'**
  String failedToLoadSlotsError(String error);

  /// No description provided for @bookingStatusPendingPayment.
  ///
  /// In en, this message translates to:
  /// **'Pending Payment'**
  String get bookingStatusPendingPayment;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get bookingStatusExpired;

  /// No description provided for @slotStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get slotStatusAvailable;

  /// No description provided for @slotStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get slotStatusLocked;

  /// No description provided for @slotStatusBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get slotStatusBooked;

  /// No description provided for @slotStatusBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get slotStatusBlocked;

  /// No description provided for @paymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get paymentStatusProcessing;

  /// No description provided for @paymentStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get paymentStatusSuccess;

  /// No description provided for @paymentStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get paymentStatusFailed;

  /// No description provided for @paymentStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get paymentStatusCancelled;

  /// No description provided for @paymentProviderTbc.
  ///
  /// In en, this message translates to:
  /// **'TBC Bank'**
  String get paymentProviderTbc;

  /// No description provided for @paymentProviderBog.
  ///
  /// In en, this message translates to:
  /// **'Bank of Georgia'**
  String get paymentProviderBog;

  /// No description provided for @dayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get dayMonday;

  /// No description provided for @dayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get dayTuesday;

  /// No description provided for @dayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get dayWednesday;

  /// No description provided for @dayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get dayThursday;

  /// No description provided for @dayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get dayFriday;

  /// No description provided for @daySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get daySaturday;

  /// No description provided for @daySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get daySunday;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @georgian.
  ///
  /// In en, this message translates to:
  /// **'Georgian'**
  String get georgian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ka'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ka':
      return AppLocalizationsKa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
