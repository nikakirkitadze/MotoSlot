import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';

class BookingState extends Equatable {
  final StateStatus status;
  final List<Booking> userBookings;
  final Booking? currentBooking;
  final TimeSlot? selectedSlot;
  final String? errorMessage;

  const BookingState({
    this.status = StateStatus.initial,
    this.userBookings = const [],
    this.currentBooking,
    this.selectedSlot,
    this.errorMessage,
  });

  bool get isLoading => status == StateStatus.loading;

  List<Booking> get upcomingBookings => userBookings
      .where((b) =>
          (b.isConfirmed || b.isPendingReview) &&
          b.startTime.isAfter(DateTime.now().toUtc()))
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
    String? errorMessage,
    bool clearError = false,
    bool clearBooking = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      userBookings: userBookings ?? this.userBookings,
      currentBooking:
          clearBooking ? null : (currentBooking ?? this.currentBooking),
      selectedSlot: selectedSlot ?? this.selectedSlot,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        userBookings,
        currentBooking,
        selectedSlot,
        errorMessage,
      ];
}
