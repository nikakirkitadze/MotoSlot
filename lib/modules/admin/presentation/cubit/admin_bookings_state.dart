import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';

class AdminBookingsState extends Equatable {
  final StateStatus status;
  final List<Booking> bookings;
  final List<TimeSlot> availableSlots;
  final BookingStatus? filterStatus;
  final DateTime? filterDate;
  final String? errorMessage;
  final String? successMessage;

  const AdminBookingsState({
    this.status = StateStatus.initial,
    this.bookings = const [],
    this.availableSlots = const [],
    this.filterStatus,
    this.filterDate,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == StateStatus.loading;

  AdminBookingsState copyWith({
    StateStatus? status,
    List<Booking>? bookings,
    List<TimeSlot>? availableSlots,
    BookingStatus? filterStatus,
    DateTime? filterDate,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearFilter = false,
  }) {
    return AdminBookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      availableSlots: availableSlots ?? this.availableSlots,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      filterDate: clearFilter ? null : (filterDate ?? this.filterDate),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status, bookings, availableSlots,
        filterStatus, filterDate, errorMessage, successMessage,
      ];
}
