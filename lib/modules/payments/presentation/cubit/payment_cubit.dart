import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/payments/data/repository/payment_repository.dart';
import 'package:moto_slot/modules/payments/presentation/cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentCubit({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository,
        super(const PaymentState());

  Future<void> createPaymentIntent({
    required String bookingId,
    required String userId,
    required double amount,
    required PaymentProvider provider,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final payment = await _paymentRepository.createPaymentIntent(
        bookingId: bookingId,
        userId: userId,
        amount: amount,
        provider: provider,
      );

      emit(state.copyWith(
        status: StateStatus.success,
        payment: payment,
        paymentUrl: payment.paymentUrl,
      ));
    } on PaymentException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    emit(state.copyWith(isVerifying: true, clearError: true));
    try {
      final payment = await _paymentRepository.verifyPayment(
        paymentId: paymentId,
        transactionId: transactionId,
      );

      emit(state.copyWith(
        status: StateStatus.success,
        payment: payment,
        isVerifying: false,
      ));
    } on PaymentException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
        isVerifying: false,
      ));
    }
  }

  void clearState() {
    emit(const PaymentState());
  }
}
