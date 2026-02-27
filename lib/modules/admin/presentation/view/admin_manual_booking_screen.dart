import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_state.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_state.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';

class AdminManualBookingScreen extends StatefulWidget {
  const AdminManualBookingScreen({super.key});

  @override
  State<AdminManualBookingScreen> createState() =>
      _AdminManualBookingScreenState();
}

class _AdminManualBookingScreenState
    extends State<AdminManualBookingScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instructorController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  TimeSlot? _selectedSlot;
  DateTime _selectedDate = DateTime.now();
  bool _configPrefilled = false;

  @override
  void initState() {
    super.initState();
    _tryPrefillFromConfig();
    context.read<AdminBookingsCubit>().loadAvailableSlots(_selectedDate);
  }

  void _tryPrefillFromConfig() {
    final config = context.read<AdminAvailabilityCubit>().state.config;
    if (config != null && !_configPrefilled) {
      _configPrefilled = true;
      _instructorController.text = config.instructorName ?? '';
      _locationController.text = config.location ?? '';
      _contactPhoneController.text = config.contactPhone ?? '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _instructorController.dispose();
    _locationController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminAvailabilityCubit, AdminAvailabilityState>(
      listener: (context, availState) {
        if (availState.config != null && !_configPrefilled) {
          _tryPrefillFromConfig();
        }
      },
      child: BlocConsumer<AdminBookingsCubit, AdminBookingsState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizeMessage(context, state.successMessage!)),
                backgroundColor: AppColors.success,
              ),
            );
            context.read<AdminBookingsCubit>().clearMessages();
            context.pop();
          }
          if (state.status == StateStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizeMessage(context, state.errorMessage!)),
                backgroundColor: AppColors.error,
              ),
            );
            context.read<AdminBookingsCubit>().clearMessages();
          }
        },
        builder: (context, state) {
          return AppScaffold(
            hasBackButton: true,
            body: AppLoadingOverlay(
              isLoading: state.isLoading,
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.verticalSm,
                    Text(
                      context.l10n.manualBooking,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.verticalMd,
                    // Step 1: Student info
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('1', context.l10n.studentInfo.replaceFirst('1. ', '')),
                          AppSpacing.verticalMd,
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  hint: context.l10n.firstName,
                                  controller: _firstNameController,
                                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppTextField(
                                  hint: context.l10n.lastName,
                                  controller: _lastNameController,
                                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.verticalMd,
                          AppTextField(
                            label: context.l10n.phoneNumber,
                            hint: context.l10n.phoneHint,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.verticalMd,
                    // Step 2: Select date & slot
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('2', context.l10n.selectSlot.replaceFirst('2. ', '')),
                          AppSpacing.verticalMd,
                          InkWell(
                            onTap: () => _pickDate(context),
                            borderRadius: AppRadius.borderRadiusMd,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today_rounded, size: 20),
                                suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                                border: OutlineInputBorder(borderRadius: AppRadius.borderRadiusMd),
                              ),
                              child: Text(AppDateUtils.formatDate(_selectedDate),
                                  style: AppTypography.bodyLarge),
                            ),
                          ),
                          AppSpacing.verticalMd,
                          if (state.availableSlots.isEmpty)
                            Text(
                              context.l10n.noSlotsForDate,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textHint),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: state.availableSlots.map((slot) {
                                final isSelected = _selectedSlot?.id == slot.id;
                                return ChoiceChip(
                                  label: Text(
                                    AppDateUtils.formatTimeRange(slot.startTime, slot.endTime),
                                    style: AppTypography.labelMedium.copyWith(
                                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: AppColors.primaryLight,
                                  backgroundColor: AppColors.surfaceVariant,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusSm),
                                  onSelected: (_) {
                                    setState(() => _selectedSlot = slot);
                                  },
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                    AppSpacing.verticalMd,
                    // Step 3: Booking details
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('3', context.l10n.bookingDetailsStep.replaceFirst('3. ', '')),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.autoFilledFromSettings,
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
                          ),
                          AppSpacing.verticalMd,
                          AppTextField(
                            label: context.l10n.instructorName,
                            hint: context.l10n.enterInstructorName,
                            controller: _instructorController,
                            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                          ),
                          AppSpacing.verticalMd,
                          AppTextField(
                            label: context.l10n.location,
                            hint: context.l10n.enterLessonLocation,
                            controller: _locationController,
                            prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
                          ),
                          AppSpacing.verticalMd,
                          AppTextField(
                            label: context.l10n.contactPhone,
                            hint: context.l10n.contactPhoneBookingHint,
                            controller: _contactPhoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.verticalLg,
                    PrimaryButton(
                      text: context.l10n.createBookingAndSendSms,
                      onPressed: _canSubmit() ? _onSubmit : null,
                      icon: Icons.check_rounded,
                    ),
                    AppSpacing.verticalLg,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String number, String title) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$number. ',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: title,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  bool _canSubmit() {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _selectedSlot != null;
  }

  void _onSubmit() {
    if (!_canSubmit()) return;

    final fullName =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

    context.read<AdminBookingsCubit>().createManualBooking(
          slotId: _selectedSlot!.id,
          userFullName: fullName,
          userPhone: _phoneController.text.trim(),
          slot: _selectedSlot!,
          instructorName: _instructorController.text.isNotEmpty
              ? _instructorController.text
              : null,
          location: _locationController.text.isNotEmpty
              ? _locationController.text
              : null,
          contactPhone: _contactPhoneController.text.isNotEmpty
              ? _contactPhoneController.text
              : null,
        );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final initial = _selectedDate.isBefore(now) ? now : _selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedSlot = null;
      });
      if (mounted) {
        context.read<AdminBookingsCubit>().loadAvailableSlots(picked);
      }
    }
  }
}
