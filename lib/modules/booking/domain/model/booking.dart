import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';

class Booking extends Equatable {
  final String id;
  final String slotId;
  final String userId;
  final String userFullName;
  final String userPhone;
  final String userEmail;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final BookingStatus status;
  final String? paymentId;
  final double? amount;
  final String? instructorName;
  final String? location;
  final String? contactPhone;
  final String? cancellationReason;
  final bool isManualBooking;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final DateTime? completedAt;
  final DateTime? expiresAt;

  const Booking({
    required this.id,
    required this.slotId,
    required this.userId,
    required this.userFullName,
    required this.userPhone,
    required this.userEmail,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.status,
    this.paymentId,
    this.amount,
    this.instructorName,
    this.location,
    this.contactPhone,
    this.cancellationReason,
    this.isManualBooking = false,
    required this.createdAt,
    this.confirmedAt,
    this.cancelledAt,
    this.completedAt,
    this.expiresAt,
  });

  bool get isPending => status == BookingStatus.pendingPayment;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCancelled => status == BookingStatus.cancelled;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isExpired => status == BookingStatus.expired;

  String get bookingReference => 'MS-${id.substring(0, 8).toUpperCase()}';

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      slotId: json['slotId'] as String,
      userId: json['userId'] as String,
      userFullName: json['userFullName'] as String,
      userPhone: json['userPhone'] as String,
      userEmail: json['userEmail'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      status: BookingStatus.fromValue(json['status'] as String),
      paymentId: json['paymentId'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      instructorName: json['instructorName'] as String?,
      location: json['location'] as String?,
      contactPhone: json['contactPhone'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      isManualBooking: json['isManualBooking'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'] as String)
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slotId': slotId,
      'userId': userId,
      'userFullName': userFullName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status.value,
      'paymentId': paymentId,
      'amount': amount,
      'instructorName': instructorName,
      'location': location,
      'contactPhone': contactPhone,
      'cancellationReason': cancellationReason,
      'isManualBooking': isManualBooking,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  Booking copyWith({
    String? id,
    String? slotId,
    String? userId,
    String? userFullName,
    String? userPhone,
    String? userEmail,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    BookingStatus? status,
    String? paymentId,
    double? amount,
    String? instructorName,
    String? location,
    String? contactPhone,
    String? cancellationReason,
    bool? isManualBooking,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? cancelledAt,
    DateTime? completedAt,
    DateTime? expiresAt,
  }) {
    return Booking(
      id: id ?? this.id,
      slotId: slotId ?? this.slotId,
      userId: userId ?? this.userId,
      userFullName: userFullName ?? this.userFullName,
      userPhone: userPhone ?? this.userPhone,
      userEmail: userEmail ?? this.userEmail,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      paymentId: paymentId ?? this.paymentId,
      amount: amount ?? this.amount,
      instructorName: instructorName ?? this.instructorName,
      location: location ?? this.location,
      contactPhone: contactPhone ?? this.contactPhone,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      isManualBooking: isManualBooking ?? this.isManualBooking,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      completedAt: completedAt ?? this.completedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  List<Object?> get props => [
        id, slotId, userId, userFullName, userPhone, userEmail,
        startTime, endTime, durationMinutes, status, paymentId,
        amount, instructorName, location, contactPhone,
        cancellationReason, isManualBooking, createdAt,
        confirmedAt, cancelledAt, completedAt, expiresAt,
      ];
}
