import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/payments/domain/model/payment.dart';

class BookingState extends Equatable {
  final StateStatus status;
  final List<Booking> userBookings;
  final Booking? currentBooking;
  final TimeSlot? selectedSlot;
  final Payment? currentPayment;
  final String? paymentUrl;
  final String? errorMessage;
  final bool isPaymentInProgress;

  const BookingState({
    this.status = StateStatus.initial,
    this.userBookings = const [],
    this.currentBooking,
    this.selectedSlot,
    this.currentPayment,
    this.paymentUrl,
    this.errorMessage,
    this.isPaymentInProgress = false,
  });

  bool get isLoading => status == StateStatus.loading;

  List<Booking> get upcomingBookings => userBookings
      .where((b) =>
          b.isConfirmed && b.startTime.isAfter(DateTime.now().toUtc()))
      .toList();

  List<Booking> get pastBookings => userBookings
      .where((b) =>
          b.isCompleted || b.startTime.isBefore(DateTime.now().toUtc()))
      .toList();

  BookingState copyWith({
    StateStatus? status,
    List<Booking>? userBookings,
    Booking? currentBooking,
    TimeSlot? selectedSlot,
    Payment? currentPayment,
    String? paymentUrl,
    String? errorMessage,
    bool? isPaymentInProgress,
    bool clearError = false,
    bool clearBooking = false,
    bool clearPayment = false,
    bool clearPaymentUrl = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      userBookings: userBookings ?? this.userBookings,
      currentBooking:
          clearBooking ? null : (currentBooking ?? this.currentBooking),
      selectedSlot: selectedSlot ?? this.selectedSlot,
      currentPayment:
          clearPayment ? null : (currentPayment ?? this.currentPayment),
      paymentUrl:
          clearPaymentUrl ? null : (paymentUrl ?? this.paymentUrl),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isPaymentInProgress:
          isPaymentInProgress ?? this.isPaymentInProgress,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userBookings,
        currentBooking,
        selectedSlot,
        currentPayment,
        paymentUrl,
        errorMessage,
        isPaymentInProgress,
      ];
}
