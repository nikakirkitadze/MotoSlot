import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:moto_slot/core/errors/app_exception.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/admin/data/repository/admin_repository.dart';
import 'package:moto_slot/modules/admin/domain/model/availability_config.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_state.dart';

class AdminAvailabilityCubit extends Cubit<AdminAvailabilityState> {
  final AdminRepository _adminRepository;
  static const _uuid = Uuid();

  AdminAvailabilityCubit({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(AdminAvailabilityState(selectedDate: DateTime.now()));

  Future<void> loadConfig() async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final config = await _adminRepository.getAvailabilityConfig();
      emit(state.copyWith(
        status: StateStatus.success,
        config: config,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> saveConfig({
    required List<int> workingDays,
    required String startTime,
    required String endTime,
    required int lessonDurationMinutes,
    required int bufferMinutes,
    String? instructorName,
    String? location,
    String? contactPhone,
  }) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final config = AvailabilityConfig(
        id: state.config?.id ?? _uuid.v4(),
        workingDays: workingDays,
        startTime: startTime,
        endTime: endTime,
        lessonDurationMinutes: lessonDurationMinutes,
        bufferMinutes: bufferMinutes,
        blockedDates: state.config?.blockedDates ?? [],
        instructorName: instructorName,
        location: location,
        contactPhone: contactPhone,
        createdAt: state.config?.createdAt ?? DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      final saved = await _adminRepository.saveAvailabilityConfig(config);
      emit(state.copyWith(
        status: StateStatus.success,
        config: saved,
        successMessage: 'settingsSaved',
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> generateSlots({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    if (state.config == null) {
      emit(state.copyWith(
        errorMessage: 'configureSettingsFirst',
      ));
      return;
    }

    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      final slots = await _adminRepository.generateSlots(
        config: state.config!,
        fromDate: fromDate,
        toDate: toDate,
      );

      emit(state.copyWith(
        status: StateStatus.success,
        generatedSlots: slots,
        successMessage: 'slotsGenerated:${slots.length}',
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> blockDate(DateTime date) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      await _adminRepository.blockDate(date);
      await loadConfig();
      emit(state.copyWith(
        successMessage: 'dateBlocked',
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> unblockDate(DateTime date) async {
    emit(state.copyWith(status: StateStatus.loading, clearError: true));
    try {
      await _adminRepository.unblockDate(date);
      await loadConfig();
      emit(state.copyWith(
        successMessage: 'dateUnblocked',
      ));
    } on AppException catch (e) {
      emit(state.copyWith(
        status: StateStatus.failure,
        errorMessage: e.message,
      ));
    }
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
