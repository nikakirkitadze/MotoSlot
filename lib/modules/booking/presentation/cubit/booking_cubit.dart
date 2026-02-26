import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/data/repository/booking_repository.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/payments/data/repository/payment_repository.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;
  final PaymentRepository _paymentRepository;
  static const _uuid = Uuid();

  BookingCubit({
    required BookingRepository bookingRepository,
    required PaymentRepository paymentRepository,
  })  : _bookingRepository = bookingRepository,
        _paymentRepository = paymentRepository,
        super(const BookingState());

  void selectSlot(TimeSlot slot) {
    emit(state.copyWith(selectedSlot: slot, clearError: true));
  }

  /// Step 1: Create pending booking + lock slot
  Future<void> createPendingBooking({
    required TimeSlot slot,
    required String userId,
    required String userFullName,
    required String userPhone,
    required String userEmail,
    required double amount,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));

    try {
      final bookingId = _uuid.v4();
      final expiresAt = DateTime.now()
          .toUtc()
          .add(const Duration(minutes: AppConstants.paymentTimeoutMinutes));

      final booking = Booking(
        id: bookingId,
        slotId: slot.id,
        userId: userId,
        userFullName: userFullName,
        userPhone: userPhone,
        userEmail: userEmail,
        startTime: slot.startTime,
        endTime: slot.endTime,
        durationMinutes: slot.durationMinutes,
        status: BookingStatus.pendingPayment,
        amount: amount,
        instructorName: slot.instructorName,
        location: slot.location,
        createdAt: DateTime.now().toUtc(),
        expiresAt: expiresAt,
      );

      final created = await _bookingRepository.createPendingBooking(booking);

      emit(state.copyWith(
        status: StateStatus.success,
        currentBooking: created,
        selectedSlot: slot,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'failedToCreateBooking',
      ));
    }
  }

  /// Step 2: Initiate payment
  Future<void> initiatePayment({
    required PaymentProvider provider,
  }) async {
    if (state.currentBooking == null) return;

    emit(state.copyWith(
      isPaymentInProgress: true,
      clearError: true,
    ));

    try {
      final payment = await _paymentRepository.createPaymentIntent(
        bookingId: state.currentBooking!.id,
        userId: state.currentBooking!.userId,
        amount: state.currentBooking!.amount ?? 0,
        provider: provider,
      );

      emit(state.copyWith(
        currentPayment: payment,
        paymentUrl: payment.paymentUrl,
        isPaymentInProgress: true,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        isPaymentInProgress: false,
        errorMessage: e.message,
      ));
    }
  }

  /// Step 3: Handle payment result from deep link
  Future<void> handlePaymentResult({
    required String transactionId,
    required bool isSuccess,
  }) async {
    if (state.currentPayment == null || state.currentBooking == null) return;

    emit(state.copyWith(
      status: StateStatus.loading,
      clearPaymentUrl: true,
    ));

    try {
      if (isSuccess) {
        // Verify on backend
        final verifiedPayment = await _paymentRepository.verifyPayment(
          paymentId: state.currentPayment!.id,
          transactionId: transactionId,
        );

        if (verifiedPayment.isSuccess) {
          final confirmedBooking = await _bookingRepository.confirmBooking(
            bookingId: state.currentBooking!.id,
            paymentId: verifiedPayment.id,
          );

          emit(state.copyWith(
            status: StateStatus.success,
            currentBooking: confirmedBooking,
            currentPayment: verifiedPayment,
            isPaymentInProgress: false,
          ));
        } else {
          await _handlePaymentFailure('paymentVerificationFailed');
        }
      } else {
        await _handlePaymentFailure('paymentNotCompleted');
      }
    } catch (e) {
      await _handlePaymentFailure('paymentVerificationError');
    }
  }

  Future<void> _handlePaymentFailure(String message) async {
    if (state.currentBooking != null) {
      await _bookingRepository.cancelBooking(
        bookingId: state.currentBooking!.id,
      );
    }

    emit(state.copyWith(
      status: StateStatus.failure,
      errorMessage: message,
      isPaymentInProgress: false,
      clearBooking: true,
      clearPayment: true,
    ));
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      await _bookingRepository.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );
      await loadUserBookings(state.userBookings.first.userId);
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> loadUserBookings(String userId) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final bookings = await _bookingRepository.getUserBookings(userId);
      emit(state.copyWith(
        status: StateStatus.success,
        userBookings: bookings,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  void clearCurrentBooking() {
    emit(state.copyWith(
      clearBooking: true,
      clearPayment: true,
      clearPaymentUrl: true,
      isPaymentInProgress: false,
    ));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
