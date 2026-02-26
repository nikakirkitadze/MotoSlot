import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/payments/domain/model/payment.dart';

class PaymentState extends Equatable {
  final StateStatus status;
  final Payment? payment;
  final String? paymentUrl;
  final String? errorMessage;
  final bool isVerifying;

  const PaymentState({
    this.status = StateStatus.initial,
    this.payment,
    this.paymentUrl,
    this.errorMessage,
    this.isVerifying = false,
  });

  bool get isLoading => status == StateStatus.loading;

  PaymentState copyWith({
    StateStatus? status,
    Payment? payment,
    String? paymentUrl,
    String? errorMessage,
    bool? isVerifying,
    bool clearError = false,
    bool clearPaymentUrl = false,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
      paymentUrl:
          clearPaymentUrl ? null : (paymentUrl ?? this.paymentUrl),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isVerifying: isVerifying ?? this.isVerifying,
    );
  }

  @override
  List<Object?> get props => [status, payment, paymentUrl, errorMessage, isVerifying];
}
