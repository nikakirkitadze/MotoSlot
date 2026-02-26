import 'package:equatable/equatable.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/admin/domain/model/availability_config.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';

class AdminAvailabilityState extends Equatable {
  final StateStatus status;
  final AvailabilityConfig? config;
  final List<TimeSlot> generatedSlots;
  final List<TimeSlot> allSlots;
  final DateTime selectedDate;
  final String? errorMessage;
  final String? successMessage;

  const AdminAvailabilityState({
    this.status = StateStatus.initial,
    this.config,
    this.generatedSlots = const [],
    this.allSlots = const [],
    required this.selectedDate,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => status == StateStatus.loading;
  bool get hasConfig => config != null;

  AdminAvailabilityState copyWith({
    StateStatus? status,
    AvailabilityConfig? config,
    List<TimeSlot>? generatedSlots,
    List<TimeSlot>? allSlots,
    DateTime? selectedDate,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AdminAvailabilityState(
      status: status ?? this.status,
      config: config ?? this.config,
      generatedSlots: generatedSlots ?? this.generatedSlots,
      allSlots: allSlots ?? this.allSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status, config, generatedSlots, allSlots,
        selectedDate, errorMessage, successMessage,
      ];
}
