import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/data/repository/slot_repository.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/user_slots_state.dart';

class UserSlotsCubit extends Cubit<UserSlotsState> {
  final SlotRepository _slotRepository;

  UserSlotsCubit({required SlotRepository slotRepository})
      : _slotRepository = slotRepository,
        super(UserSlotsState(selectedDate: DateTime.now()));

  Future<void> loadAvailableSlots({DateTime? date}) async {
    final selectedDate = date ?? state.selectedDate;
    emit(state.copyWith(
      status: StateStatus.loading,
      selectedDate: selectedDate,
      clearError: true,
    ));

    try {
      // Load slots for 30 days from the selected date
      final fromDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final toDate = fromDate.add(const Duration(days: 30));

      final slots = await _slotRepository.getAvailableSlots(
        fromDate: fromDate,
        toDate: toDate,
      );

      emit(state.copyWith(
        status: StateStatus.success,
        slots: slots,
        selectedDate: selectedDate,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: 'failedToLoadAvailableSlots',
      ));
    }
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<void> refreshSlots() => loadAvailableSlots();
}
