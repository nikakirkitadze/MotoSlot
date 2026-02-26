import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';

class Payment extends Equatable {
  final String id;
  final String bookingId;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentProvider provider;
  final String? transactionId;
  final String? paymentUrl;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Payment({
    required this.id,
    required this.bookingId,
    required this.userId,
    required this.amount,
    this.currency = 'GEL',
    required this.status,
    required this.provider,
    this.transactionId,
    this.paymentUrl,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  bool get isSuccess => status == PaymentStatus.success;
  bool get isPending => status == PaymentStatus.pending;
  bool get isFailed => status == PaymentStatus.failed;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'GEL',
      status: PaymentStatus.fromValue(json['status'] as String),
      provider: json['provider'] == 'bog'
          ? PaymentProvider.bog
          : PaymentProvider.tbc,
      transactionId: json['transactionId'] as String?,
      paymentUrl: json['paymentUrl'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status.value,
      'provider': provider.value,
      'transactionId': transactionId,
      'paymentUrl': paymentUrl,
      'errorMessage': errorMessage,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  Payment copyWith({
    String? id,
    String? bookingId,
    String? userId,
    double? amount,
    String? currency,
    PaymentStatus? status,
    PaymentProvider? provider,
    String? transactionId,
    String? paymentUrl,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      transactionId: transactionId ?? this.transactionId,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, bookingId, userId, amount, currency, status, provider,
        transactionId, paymentUrl, errorMessage, createdAt, completedAt,
      ];
}
