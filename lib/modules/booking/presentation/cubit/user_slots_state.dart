import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';

class UserSlotsState extends Equatable {
  final StateStatus status;
  final List<TimeSlot> slots;
  final DateTime selectedDate;
  final String? errorMessage;

  const UserSlotsState({
    this.status = StateStatus.initial,
    this.slots = const [],
    required this.selectedDate,
    this.errorMessage,
  });

  bool get isLoading => status == StateStatus.loading;
  bool get hasSlots => slots.isNotEmpty;

  List<TimeSlot> get availableSlots =>
      slots.where((s) => s.isAvailable).toList();

  Map<DateTime, List<TimeSlot>> get slotsByDay {
    final map = <DateTime, List<TimeSlot>>{};
    for (final slot in slots) {
      final day = DateTime(
        slot.startTime.toLocal().year,
        slot.startTime.toLocal().month,
        slot.startTime.toLocal().day,
      );
      map.putIfAbsent(day, () => []).add(slot);
    }
    return map;
  }

  UserSlotsState copyWith({
    StateStatus? status,
    List<TimeSlot>? slots,
    DateTime? selectedDate,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserSlotsState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, slots, selectedDate, errorMessage];
}
