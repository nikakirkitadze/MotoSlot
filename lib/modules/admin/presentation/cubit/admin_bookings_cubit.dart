import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/admin/data/repository/admin_repository.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_state.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/di/injection.dart';
import 'package:moto_slot/modules/booking/data/repository/slot_repository.dart';

class AdminBookingsCubit extends Cubit<AdminBookingsState> {
  final AdminRepository _adminRepository;

  AdminBookingsCubit({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(const AdminBookingsState());

  Future<void> loadBookings({
    BookingStatus? status,
    DateTime? date,
  }) async {
    emit(state.copyWith(
      status: StateStatus.loading,
      clearError: true,
      filterStatus: status,
      filterDate: date,
    ));
    try {
      final bookings = await _adminRepository.getFilteredBookings(
        status: status,
        date: date,
      );
      emit(state.copyWith(
        status: StateStatus.success,
        bookings: bookings,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> loadAvailableSlots(DateTime date) async {
    try {
      final slotRepo = getIt<SlotRepository>();
      final slots = await slotRepo.getSlotsForDay(date);
      emit(state.copyWith(availableSlots: slots));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'failedToLoadSlotsError:$e',
      ));
    }
  }

  Future<void> createManualBooking({
    required String slotId,
    required String userFullName,
    required String userPhone,
    required TimeSlot slot,
    String? instructorName,
    String? location,
    String? contactPhone,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      await _adminRepository.createManualBooking(
        slotId: slotId,
        userFullName: userFullName,
        userPhone: userPhone,
        slot: slot,
        instructorName: instructorName,
        location: location,
        contactPhone: contactPhone,
      );
      emit(state.copyWith(
        status: StateStatus.success,
        successMessage: 'bookingCreatedSmsSent:$userPhone',
      ));
      await loadBookings();
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> cancelBooking(String bookingId, String slotId) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      await _adminRepository.cancelBooking(bookingId, slotId);
      emit(state.copyWith(
        successMessage: 'bookingCancelled',
      ));
      await loadBookings(
        status: state.filterStatus,
        date: state.filterDate,
      );
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> completeBooking(String bookingId) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      await _adminRepository.completeBooking(bookingId);
      emit(state.copyWith(
        successMessage: 'bookingMarkedCompleted',
      ));
      await loadBookings(
        status: state.filterStatus,
        date: state.filterDate,
      );
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  void setFilter({BookingStatus? status, DateTime? date}) {
    loadBookings(status: status, date: date);
  }

  void clearFilter() {
    emit(state.copyWith(clearFilter: true));
    loadBookings();
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
