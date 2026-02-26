import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
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
    final config =
        context.read<AdminAvailabilityCubit>().state.config;
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
                backgroundColor: AppTheme.successColor,
              ),
            );
            context.read<AdminBookingsCubit>().clearMessages();
            context.pop();
          }
          if (state.status == StateStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizeMessage(context, state.errorMessage!)),
                backgroundColor: AppTheme.errorColor,
              ),
            );
            context.read<AdminBookingsCubit>().clearMessages();
          }
        },
        builder: (context, state) {
          return Scaffold(
          appBar: AppBar(title: Text(context.l10n.manualBooking)),
          body: AppLoadingOverlay(
            isLoading: state.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step 1: Student info
                  Text(context.l10n.studentInfo,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: context.l10n.firstName,
                          hint: context.l10n.firstNameHint,
                          controller: _firstNameController,
                          prefixIcon:
                              const Icon(Icons.person_outline, size: 20),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: context.l10n.lastName,
                          hint: context.l10n.lastNameHint,
                          controller: _lastNameController,
                          prefixIcon:
                              const Icon(Icons.person_outline, size: 20),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: context.l10n.phoneNumber,
                    hint: context.l10n.phoneHint,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  // Step 2: Select date & slot
                  Text(context.l10n.selectSlot,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _pickDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today, size: 20),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      child: Text(AppDateUtils.formatDate(_selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.availableSlots.isEmpty)
                    Text(
                      context.l10n.noSlotsForDate,
                      style: const TextStyle(color: AppTheme.textHint),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.availableSlots.map((slot) {
                        final isSelected = _selectedSlot?.id == slot.id;
                        return ChoiceChip(
                          label: Text(AppDateUtils.formatTimeRange(
                            slot.startTime,
                            slot.endTime,
                          )),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryLight,
                          onSelected: (_) {
                            setState(() => _selectedSlot = slot);
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 24),
                  // Step 3: Booking details (auto-filled from preferences)
                  Text(context.l10n.bookingDetailsStep,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.autoFilledFromSettings,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textHint,
                        ),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: context.l10n.instructorName,
                    hint: context.l10n.enterInstructorName,
                    controller: _instructorController,
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: context.l10n.location,
                    hint: context.l10n.enterLessonLocation,
                    controller: _locationController,
                    prefixIcon:
                        const Icon(Icons.location_on_outlined, size: 20),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: context.l10n.contactPhone,
                    hint: context.l10n.contactPhoneBookingHint,
                    controller: _contactPhoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    text: context.l10n.createBookingAndSendSms,
                    onPressed: _canSubmit() ? _onSubmit : null,
                    icon: Icons.check,
                  ),
                ],
              ),
            ),
          ),
          );
        },
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
