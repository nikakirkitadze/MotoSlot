// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appName => 'MotoSlot';

  @override
  String get appTagline => 'მოტოციკლის მართვის აკადემია';

  @override
  String get signOut => 'გასვლა';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get retry => 'თავიდან ცდა';

  @override
  String get select => 'არჩევა';

  @override
  String get today => 'დღეს';

  @override
  String get all => 'ყველა';

  @override
  String get none => 'არცერთი';

  @override
  String get loading => 'იტვირთება...';

  @override
  String get unexpectedError => 'მოულოდნელი შეცდომა მოხდა.';

  @override
  String gelCurrency(String amount) {
    return '$amount ₾';
  }

  @override
  String minutesShort(int count) {
    return '$count წთ';
  }

  @override
  String minutesFull(int count) {
    return '$count წუთი';
  }

  @override
  String minLesson(int count) {
    return '$count წთ გაკვეთილი';
  }

  @override
  String get welcomeToMotoSlot => 'კეთილი იყოს თქვენი მობრძანება MotoSlot-ში';

  @override
  String get signInSubtitle => 'შედით თქვენი გაკვეთილების სამართავად';

  @override
  String get email => 'ელ. ფოსტა';

  @override
  String get emailHint => 'შეიყვანეთ ელ. ფოსტა';

  @override
  String get signIn => 'შესვლა';

  @override
  String get fullName => 'სრული სახელი';

  @override
  String get fullNameHint => 'შეიყვანეთ სრული სახელი';

  @override
  String get phoneNumber => 'ტელეფონის ნომერი';

  @override
  String get phoneHint => '+995 XXX XXX XXX';

  @override
  String get emailAddressHint => 'შეიყვანეთ ელ. ფოსტის მისამართი';

  @override
  String get backToLogin => 'შესვლაზე დაბრუნება';

  @override
  String get signOutConfirmTitle => 'გასვლა';

  @override
  String get signOutConfirmMessage => 'დარწმუნებული ხართ, რომ გსურთ გასვლა?';

  @override
  String get sendSignInLink => 'შესვლის ბმულის გაგზავნა';

  @override
  String get orContinueWith => 'ან გააგრძელეთ';

  @override
  String get continueWithApple => 'Apple-ით გაგრძელება';

  @override
  String get continueWithGoogle => 'Google-ით გაგრძელება';

  @override
  String get checkYourEmail => 'შეამოწმეთ ელ. ფოსტა';

  @override
  String get emailLinkSentMessage =>
      'ჩვენ გამოვაგზავნეთ შესვლის ბმული თქვენს ელ. ფოსტაზე. შესასვლელად დააჭირეთ ბმულს წერილში.';

  @override
  String get completeYourProfile => 'შეავსეთ პროფილი';

  @override
  String get completeProfileSubtitle =>
      'მოგვიყევით ცოტა თქვენს შესახებ დასაწყებად.';

  @override
  String get optional => 'არასავალდებულო';

  @override
  String get continueText => 'გაგრძელება';

  @override
  String get validatorEmailRequired => 'ელ. ფოსტა აუცილებელია';

  @override
  String get validatorEmailInvalid =>
      'გთხოვთ, შეიყვანოთ სწორი ელ. ფოსტის მისამართი';

  @override
  String get validatorNameRequired => 'სახელი აუცილებელია';

  @override
  String get validatorNameMinLength => 'სახელი უნდა იყოს მინიმუმ 2 სიმბოლო';

  @override
  String get validatorPhoneRequired => 'ტელეფონის ნომერი აუცილებელია';

  @override
  String get validatorPhoneInvalid =>
      'გთხოვთ, შეიყვანოთ სწორი ტელეფონის ნომერი';

  @override
  String validatorFieldRequired(String fieldName) {
    return '$fieldName აუცილებელია';
  }

  @override
  String get book => 'ჯავშანი';

  @override
  String get myBookings => 'ჩემი ჯავშნები';

  @override
  String get upcoming => 'მომავალი';

  @override
  String get past => 'წარსული';

  @override
  String get loadingBookings => 'ჯავშნები იტვირთება...';

  @override
  String get failedToLoadBookings => 'ჯავშნების ჩატვირთვა ვერ მოხერხდა';

  @override
  String get noUpcomingBookings => 'მომავალი ჯავშნები არ არის';

  @override
  String get noUpcomingBookingsSubtitle =>
      'დაჯავშნეთ პირველი გაკვეთილი კალენდრიდან';

  @override
  String get noPastBookings => 'წარსული ჯავშნები არ არის';

  @override
  String get noPastBookingsSubtitle => 'დასრულებული გაკვეთილები აქ გამოჩნდება';

  @override
  String get loadingAvailableSlots => 'ხელმისაწვდომი სლოტები იტვირთება...';

  @override
  String get failedToLoadSlots => 'სლოტების ჩატვირთვა ვერ მოხერხდა';

  @override
  String get noAvailableSlots => 'ხელმისაწვდომი სლოტები არ არის';

  @override
  String get noAvailableSlotsSubtitle => 'სცადეთ სხვა თარიღის არჩევა';

  @override
  String availableOn(String date) {
    return 'ხელმისაწვდომია $date-ზე';
  }

  @override
  String get slotDetails => 'სლოტის დეტალები';

  @override
  String get date => 'თარიღი';

  @override
  String get time => 'დრო';

  @override
  String get duration => 'ხანგრძლივობა';

  @override
  String get instructor => 'ინსტრუქტორი';

  @override
  String get location => 'მისამართი';

  @override
  String get lessonFee => 'გაკვეთილის ღირებულება';

  @override
  String get payAndConfirmBooking => 'გადახდა და ჯავშნის დადასტურება';

  @override
  String get slotHeldDuringPayment =>
      'თქვენი სლოტი დაცულია 10 წუთის განმავლობაში გადახდის პროცესში.';

  @override
  String get bookingDetails => 'ჯავშნის დეტალები';

  @override
  String get lessonDetails => 'გაკვეთილის დეტალები';

  @override
  String get contact => 'კონტაქტი';

  @override
  String get amount => 'თანხა';

  @override
  String get cancelBooking => 'ჯავშნის გაუქმება';

  @override
  String get cancelBookingConfirmTitle => 'გაუქმდეს ჯავშანი?';

  @override
  String get cancelBookingConfirmMessage =>
      'დარწმუნებული ხართ, რომ გსურთ ამ ჯავშნის გაუქმება? ეს მოქმედება შეუქცევადია.';

  @override
  String get keepBooking => 'ჯავშნის შენარჩუნება';

  @override
  String get failedToCreateBooking => 'ჯავშნის შექმნა ვერ მოხერხდა.';

  @override
  String get failedToLoadAvailableSlots =>
      'ხელმისაწვდომი სლოტების ჩატვირთვა ვერ მოხერხდა.';

  @override
  String get bookingConfirmed => 'ჯავშანი დადასტურებულია!';

  @override
  String get bookingConfirmedSubtitle =>
      'თქვენი მოტოციკლის გაკვეთილი წარმატებით დაიჯავშნა.';

  @override
  String get bookingReference => 'ჯავშნის ნომერი';

  @override
  String get amountPaid => 'გადახდილი თანხა';

  @override
  String get reminderNotice =>
      'თქვენ მიიღებთ შეხსენებას 24 საათით და 1 საათით ადრე გაკვეთილამდე.';

  @override
  String get viewMyBookings => 'ჩემი ჯავშნების ნახვა';

  @override
  String get bookAnotherLesson => 'სხვა გაკვეთილის დაჯავშნა';

  @override
  String get payment => 'გადახდა';

  @override
  String get amountDue => 'გადასახდელი თანხა';

  @override
  String refLabel(String reference) {
    return 'მითითება: $reference';
  }

  @override
  String get selectPaymentMethod => 'აირჩიეთ გადახდის მეთოდი';

  @override
  String get tbcBank => 'თიბისი ბანკი';

  @override
  String get payWithTbcCard => 'გადაიხადეთ თიბისი ბანკის ბარათით';

  @override
  String get bankOfGeorgia => 'საქართველოს ბანკი';

  @override
  String get payWithBogCard => 'გადაიხადეთ BOG ბარათით';

  @override
  String get processingPayment => 'გადახდა მუშავდება...';

  @override
  String get paymentRedirectNotice =>
      'თქვენ გადამისამართდებით ბანკის უსაფრთხო გადახდის გვერდზე. თქვენი სლოტი დაცულია 10 წუთის განმავლობაში.';

  @override
  String get cancelPaymentTitle => 'გადახდის გაუქმება?';

  @override
  String get cancelPaymentMessage =>
      'თქვენი ჯავშანი გაუქმდება და სლოტი გათავისუფლდება.';

  @override
  String get continuePayment => 'გადახდის გაგრძელება';

  @override
  String get securePayment => 'უსაფრთხო გადახდა';

  @override
  String get loadingPaymentPage => 'გადახდის გვერდი იტვირთება...';

  @override
  String get paymentVerificationFailed => 'გადახდის ვერიფიკაცია ვერ მოხერხდა.';

  @override
  String get paymentNotCompleted => 'გადახდა არ დასრულებულა.';

  @override
  String get paymentVerificationError => 'გადახდის ვერიფიკაციის შეცდომა.';

  @override
  String get admin => 'ADMIN';

  @override
  String get calendar => 'კალენდარი';

  @override
  String get bookings => 'ჯავშნები';

  @override
  String get settings => 'პარამეტრები';

  @override
  String get manualBook => 'ხელით ჯავშანი';

  @override
  String get blockDate => 'თარიღის დაბლოკვა';

  @override
  String get unblockDate => 'თარიღის განბლოკვა';

  @override
  String get noBookingsForDay => 'ჯავშნები ამ დღეს არ არის';

  @override
  String get noBookingsForDaySubtitle =>
      'ჯავშნები აქ გამოჩნდება, როცა მომხმარებლები სლოტებს დაჯავშნავენ';

  @override
  String get noBookingsFound => 'ჯავშნები ვერ მოიძებნა';

  @override
  String get noBookingsFoundSubtitle => 'სცადეთ ფილტრის შეცვლა';

  @override
  String get manualBooking => 'ხელით ჯავშანი';

  @override
  String get userInformation => 'მომხმარებლის ინფორმაცია';

  @override
  String get name => 'სახელი';

  @override
  String get phone => 'ტელეფონი';

  @override
  String get markAsCompleted => 'დასრულებულად მონიშვნა';

  @override
  String get cancelBookingAdminMessage =>
      'სლოტი გათავისუფლდება და მომხმარებელს ეცნობება.';

  @override
  String get keep => 'შენარჩუნება';

  @override
  String get studentInfo => '1. სტუდენტის ინფო';

  @override
  String get firstName => 'სახელი';

  @override
  String get firstNameHint => 'სახელი';

  @override
  String get lastName => 'გვარი';

  @override
  String get lastNameHint => 'გვარი';

  @override
  String get selectSlot => '2. სლოტის არჩევა';

  @override
  String get noSlotsForDate => 'არჩეულ თარიღზე ხელმისაწვდომი სლოტები არ არის.';

  @override
  String get bookingDetailsStep => '3. ჯავშნის დეტალები';

  @override
  String get autoFilledFromSettings =>
      'ავტომატურად შევსებულია პარამეტრებიდან. საჭიროების შემთხვევაში შეცვალეთ.';

  @override
  String get instructorName => 'ინსტრუქტორის სახელი';

  @override
  String get instructorNameHint => 'ინსტრუქტორის სახელი';

  @override
  String get enterInstructorName => 'შეიყვანეთ ინსტრუქტორის სახელი';

  @override
  String get defaultLocation => 'მისამართი';

  @override
  String get defaultLocationHint => 'სავარჯიშო მოედნის მისამართი';

  @override
  String get enterLessonLocation => 'შეიყვანეთ გაკვეთილის მისამართი';

  @override
  String get contactPhone => 'საკონტაქტო ტელეფონი';

  @override
  String get contactPhoneHint => 'ტელეფონის ნომერი სტუდენტებისთვის';

  @override
  String get contactPhoneBookingHint => 'საკონტაქტო ტელეფონის ნომერი';

  @override
  String get createBookingAndSendSms => 'ჯავშნის შექმნა და SMS-ის გაგზავნა';

  @override
  String get availabilitySettings => 'ხელმისაწვდომობის პარამეტრები';

  @override
  String get workingDays => 'სამუშაო დღეები';

  @override
  String get startTime => 'დაწყების დრო';

  @override
  String get endTime => 'დასრულების დრო';

  @override
  String get lessonDuration => 'გაკვეთილის ხანგრძლივობა';

  @override
  String get bufferBetweenLessons => 'შესვენება გაკვეთილებს შორის';

  @override
  String get saveSettings => 'პარამეტრების შენახვა';

  @override
  String get generateSlots => 'სლოტების გენერაცია';

  @override
  String get generateSlotsSubtitle =>
      'სლოტების გენერაცია ხელმისაწვდომობის პარამეტრების მიხედვით.';

  @override
  String get from => 'საიდან';

  @override
  String get to => 'სადამდე';

  @override
  String get settingsSaved => 'ხელმისაწვდომობის პარამეტრები შენახულია.';

  @override
  String get configureSettingsFirst =>
      'გთხოვთ, ჯერ დააკონფიგურიროთ ხელმისაწვდომობის პარამეტრები.';

  @override
  String slotsGenerated(int count) {
    return '$count სლოტი შეიქმნა.';
  }

  @override
  String get dateBlocked => 'თარიღი წარმატებით დაიბლოკა.';

  @override
  String get dateUnblocked => 'თარიღი განიბლოკა.';

  @override
  String bookingCreatedSmsSent(String phone) {
    return 'ჯავშანი შეიქმნა და SMS გაეგზავნა $phone-ზე.';
  }

  @override
  String get bookingCancelled => 'ჯავშანი გაუქმებულია.';

  @override
  String get bookingMarkedCompleted => 'ჯავშანი დასრულებულად მოინიშნა.';

  @override
  String failedToLoadSlotsError(String error) {
    return 'სლოტების ჩატვირთვა ვერ მოხერხდა: $error';
  }

  @override
  String get bookingStatusPendingPayment => 'გადახდის მოლოდინში';

  @override
  String get bookingStatusConfirmed => 'დადასტურებული';

  @override
  String get bookingStatusCancelled => 'გაუქმებული';

  @override
  String get bookingStatusCompleted => 'დასრულებული';

  @override
  String get bookingStatusExpired => 'ვადაგასული';

  @override
  String get slotStatusAvailable => 'ხელმისაწვდომი';

  @override
  String get slotStatusLocked => 'დაბლოკილი';

  @override
  String get slotStatusBooked => 'დაჯავშნილი';

  @override
  String get slotStatusBlocked => 'შეზღუდული';

  @override
  String get paymentStatusPending => 'მოლოდინში';

  @override
  String get paymentStatusProcessing => 'მუშავდება';

  @override
  String get paymentStatusSuccess => 'წარმატებული';

  @override
  String get paymentStatusFailed => 'წარუმატებელი';

  @override
  String get paymentStatusCancelled => 'გაუქმებული';

  @override
  String get dayMonday => 'ორშაბათი';

  @override
  String get dayTuesday => 'სამშაბათი';

  @override
  String get dayWednesday => 'ოთხშაბათი';

  @override
  String get dayThursday => 'ხუთშაბათი';

  @override
  String get dayFriday => 'პარასკევი';

  @override
  String get daySaturday => 'შაბათი';

  @override
  String get daySunday => 'კვირა';

  @override
  String get language => 'ენა';

  @override
  String get english => 'English';

  @override
  String get georgian => 'ქართული';

  @override
  String get logIn => 'შესვლა';

  @override
  String get emailAddress => 'ელ. ფოსტის მისამართი';

  @override
  String get scheduleLesson => 'გაკვეთილის დაგეგმვა';

  @override
  String availableSlotsFor(String date) {
    return 'ხელმისაწვდომი სლოტები $date-ისთვის';
  }

  @override
  String get bookNow => 'დაჯავშნე';

  @override
  String get confirmBooking => 'ჯავშნის დადასტურება';

  @override
  String get selectTimeSlot => 'აირჩიეთ დრო';

  @override
  String get morning => 'დილა';

  @override
  String get afternoon => 'შუადღე';

  @override
  String get continueToPayment => 'გადახდაზე გადასვლა';

  @override
  String get bookingPaymentSummary => 'ჯავშნის გადახდის შეჯამება';

  @override
  String get payNow => 'გადაიხადე';

  @override
  String get bookingConfirmation => 'ჯავშნის დადასტურება';

  @override
  String get bookingSuccessful => 'ჯავშანი წარმატებულია!';

  @override
  String get lesson => 'გაკვეთილი';

  @override
  String get backToHome => 'მთავარზე დაბრუნება';

  @override
  String get adminAnalyticsDashboard => 'ადმინ ანალიტიკის დაფა';

  @override
  String get totalBookings => 'სულ ჯავშნები';

  @override
  String get revenue => 'შემოსავალი';

  @override
  String get activeUsers => 'აქტიური მომხმარებლები';

  @override
  String get thisMonth => 'ამ თვეში';

  @override
  String get filter => 'ფილტრი';

  @override
  String get upcomingLessons => 'მომავალი გაკვეთილები';

  @override
  String get seeAll => 'ყველას ნახვა';

  @override
  String get dashboard => 'მთავარი';

  @override
  String get users => 'მომხმარებლები';

  @override
  String get noBookingsYet => 'ჯავშნები ჯერ არ არის';

  @override
  String get noBookingsYetSubtitle =>
      'თქვენი მოტოციკლის გაკვეთილების ჯავშნები აქ გამოჩნდება დაგეგმვის შემდეგ.';

  @override
  String get signOutMessage =>
      'დარწმუნებული ხართ, რომ გსურთ გასვლა? ჯავშნების სამართავად ხელახლა შესვლა დაგჭირდებათ.';

  @override
  String get confirmed => 'დადასტურებული';

  @override
  String get pending => 'მოლოდინში';

  @override
  String get secureSSLEncrypted => 'დაცული SSL დაშიფვრა';

  @override
  String get termsAgreement =>
      'გადახდაზე დაჭერით თქვენ ეთანხმებით ჩვენს წესებსა და პირობებს.';

  @override
  String get bookingStatusPendingReview => 'განხილვის მოლოდინში';

  @override
  String get paymentStatusReceiptUploaded => 'ქვითარი ატვირთულია';

  @override
  String get paymentStatusReceiptRejected => 'ქვითარი უარყოფილია';

  @override
  String get paymentProviderReceipt => 'საბანკო გადარიცხვის ქვითარი';

  @override
  String get receiptUpload => 'ქვითრის ატვირთვა';

  @override
  String get receiptUploadTitle => 'გადახდის ქვითარი';

  @override
  String receiptUploadInstructions(String amount) {
    return 'გადარიცხეთ $amount ₾ და ატვირთეთ ბანკის გადარიცხვის სკრინშოტი.';
  }

  @override
  String get receiptUploadInstructionsSubtitle =>
      'ჩვენ ავტომატურად გადავამოწმებთ თქვენს გადახდას.';

  @override
  String get takePhoto => 'ფოტოს გადაღება';

  @override
  String get takePhotoDescription => 'გადაიღეთ ქვითრის ფოტო';

  @override
  String get chooseFromGallery => 'გალერიიდან არჩევა';

  @override
  String get chooseFromGalleryDescription => 'აირჩიეთ სკრინშოტი გალერიიდან';

  @override
  String get takePhotoOrChoose => 'გადაიღეთ ფოტო ან აირჩიეთ გალერიიდან';

  @override
  String get changeImage => 'სურათის შეცვლა';

  @override
  String get submitReceipt => 'ქვითრის გაგზავნა';

  @override
  String get analyzingReceipt => 'ქვითარი მოწმდება...';

  @override
  String get uploadingReceipt => 'ქვითარი იტვირთება...';

  @override
  String get slotHeldDuringUpload =>
      'თქვენი სლოტი დაცულია 10 წუთის განმავლობაში ქვითრის გაგზავნის პროცესში.';

  @override
  String get receiptPendingReview => 'ქვითარი განხილვის პროცესშია';

  @override
  String get receiptPendingReviewMessage =>
      'თქვენი ქვითარი გაგზავნილია და ელოდება ადმინისტრატორის ვერიფიკაციას. შეტყობინება მიიღებთ განხილვის შემდეგ.';

  @override
  String get receiptAutoApproved => 'ქვითარი წარმატებით გადამოწმდა!';

  @override
  String get receiptValidationFailed =>
      'ქვითრის გადამოწმება ვერ მოხერხდა. გთხოვთ, სცადოთ უფრო მკაფიო სურათით.';

  @override
  String get failedToPickImage =>
      'სურათის არჩევა ვერ მოხერხდა. გთხოვთ, სცადოთ ხელახლა.';

  @override
  String get receiptReview => 'ქვითრის განხილვა';

  @override
  String get approveReceipt => 'ქვითრის დამტკიცება';

  @override
  String get approveReceiptConfirmMessage =>
      'დარწმუნებული ხართ, რომ გსურთ ქვითრის დამტკიცება და ჯავშნის დადასტურება?';

  @override
  String get rejectReceipt => 'ქვითრის უარყოფა';

  @override
  String get rejectReceiptConfirmMessage =>
      'დარწმუნებული ხართ, რომ გსურთ ქვითრის უარყოფა? ჯავშანი გაუქმდება.';

  @override
  String get receiptApproved =>
      'ქვითარი დამტკიცებულია. ჯავშანი დადასტურებულია.';

  @override
  String get receiptRejected => 'ქვითარი უარყოფილია. ჯავშანი გაუქმებულია.';

  @override
  String get rejectionReasonHint => 'შეიყვანეთ ქვითრის უარყოფის მიზეზი';

  @override
  String get adminNoteHint => 'დამატებითი შენიშვნა (არასავალდებულო)';

  @override
  String get approve => 'დამტკიცება';

  @override
  String get reject => 'უარყოფა';
}
