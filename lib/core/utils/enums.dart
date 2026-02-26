enum StateStatus { initial, loading, success, failure }

enum UserRole { admin, user }

enum BookingStatus {
  pendingPayment('pending_payment', 'Pending Payment'),
  confirmed('confirmed', 'Confirmed'),
  cancelled('cancelled', 'Cancelled'),
  completed('completed', 'Completed'),
  expired('expired', 'Expired');

  final String value;
  final String label;
  const BookingStatus(this.value, this.label);

  static BookingStatus fromValue(String value) {
    return BookingStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BookingStatus.pendingPayment,
    );
  }
}

enum SlotStatus {
  available('available', 'Available'),
  locked('locked', 'Locked'),
  booked('booked', 'Booked'),
  blocked('blocked', 'Blocked');

  final String value;
  final String label;
  const SlotStatus(this.value, this.label);

  static SlotStatus fromValue(String value) {
    return SlotStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SlotStatus.available,
    );
  }
}

enum PaymentStatus {
  pending('pending', 'Pending'),
  processing('processing', 'Processing'),
  success('success', 'Success'),
  failed('failed', 'Failed'),
  cancelled('cancelled', 'Cancelled');

  final String value;
  final String label;
  const PaymentStatus(this.value, this.label);

  static PaymentStatus fromValue(String value) {
    return PaymentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}

enum PaymentProvider {
  tbc('tbc', 'TBC Bank'),
  bog('bog', 'Bank of Georgia');

  final String value;
  final String label;
  const PaymentProvider(this.value, this.label);
}

enum DayOfWeek {
  monday(1, 'Monday'),
  tuesday(2, 'Tuesday'),
  wednesday(3, 'Wednesday'),
  thursday(4, 'Thursday'),
  friday(5, 'Friday'),
  saturday(6, 'Saturday'),
  sunday(7, 'Sunday');

  final int value;
  final String label;
  const DayOfWeek(this.value, this.label);
}
