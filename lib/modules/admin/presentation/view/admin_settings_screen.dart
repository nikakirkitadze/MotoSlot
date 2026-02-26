import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/constants/app_constants.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/locale_cubit.dart';
import 'package:moto_slot/core/locale/locale_state.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/utils/enum_l10n.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_state.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _instructorController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _startTimeController = TextEditingController(text: '09:00');
  final _endTimeController = TextEditingController(text: '18:00');
  int _lessonDuration = 60;
  int _bufferMinutes = 15;
  final Set<int> _workingDays = {1, 2, 3, 4, 5}; // Mon-Fri

  DateTime? _generateFromDate;
  DateTime? _generateToDate;

  @override
  void initState() {
    super.initState();
    _loadExistingConfig();
  }

  void _loadExistingConfig() {
    final config =
        context.read<AdminAvailabilityCubit>().state.config;
    if (config != null) {
      _instructorController.text = config.instructorName ?? '';
      _locationController.text = config.location ?? '';
      _contactPhoneController.text = config.contactPhone ?? '';
      _startTimeController.text = config.startTime;
      _endTimeController.text = config.endTime;
      _lessonDuration = config.lessonDurationMinutes;
      _bufferMinutes = config.bufferMinutes;
      setState(() {
        _workingDays.clear();
        _workingDays.addAll(config.workingDays);
      });
    }
  }

  @override
  void dispose() {
    _instructorController.dispose();
    _locationController.dispose();
    _contactPhoneController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminAvailabilityCubit, AdminAvailabilityState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.successMessage!)),
              backgroundColor: AppTheme.successColor,
            ),
          );
          context.read<AdminAvailabilityCubit>().clearMessages();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.errorMessage!)),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          context.read<AdminAvailabilityCubit>().clearMessages();
        }
      },
      builder: (context, state) {
        return AppLoadingOverlay(
          isLoading: state.isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Language toggle
                Text(context.l10n.language,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                BlocBuilder<LocaleCubit, LocaleState>(
                  builder: (context, localeState) {
                    return SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'ka',
                          label: Text(context.l10n.georgian),
                        ),
                        ButtonSegment(
                          value: 'en',
                          label: Text(context.l10n.english),
                        ),
                      ],
                      selected: {localeState.locale.languageCode},
                      onSelectionChanged: (selected) {
                        context.read<LocaleCubit>().setLocale(
                              Locale(selected.first),
                            );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Text(context.l10n.availabilitySettings,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 24),
                // Working days
                Text(context.l10n.workingDays,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: DayOfWeek.values.map((day) {
                    return FilterChip(
                      label: Text(day.localizedLabel(context).substring(0, 3)),
                      selected: _workingDays.contains(day.value),
                      selectedColor: AppTheme.primaryLight,
                      checkmarkColor: AppTheme.primaryColor,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _workingDays.add(day.value);
                          } else {
                            _workingDays.remove(day.value);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Time range
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: context.l10n.startTime,
                        hint: '09:00',
                        controller: _startTimeController,
                        prefixIcon:
                            const Icon(Icons.access_time, size: 20),
                        onSubmitted: (_) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AppTextField(
                        label: context.l10n.endTime,
                        hint: '18:00',
                        controller: _endTimeController,
                        prefixIcon:
                            const Icon(Icons.access_time, size: 20),
                        onSubmitted: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Lesson duration
                Text(context.l10n.lessonDuration,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: AppConstants.lessonDurations.map((duration) {
                    return ChoiceChip(
                      label: Text(context.l10n.minutesShort(duration)),
                      selected: _lessonDuration == duration,
                      selectedColor: AppTheme.primaryLight,
                      onSelected: (_) {
                        setState(() => _lessonDuration = duration);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Buffer time
                Text(context.l10n.bufferBetweenLessons,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [0, 10, 15, 20, 30].map((mins) {
                    return ChoiceChip(
                      label: Text(mins == 0
                          ? context.l10n.none
                          : context.l10n.minutesShort(mins)),
                      selected: _bufferMinutes == mins,
                      selectedColor: AppTheme.primaryLight,
                      onSelected: (_) {
                        setState(() => _bufferMinutes = mins);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Instructor and location
                AppTextField(
                  label: context.l10n.instructorName,
                  hint: context.l10n.instructorNameHint,
                  controller: _instructorController,
                  prefixIcon:
                      const Icon(Icons.person_outline, size: 20),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: context.l10n.defaultLocation,
                  hint: context.l10n.defaultLocationHint,
                  controller: _locationController,
                  prefixIcon:
                      const Icon(Icons.location_on_outlined, size: 20),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: context.l10n.contactPhone,
                  hint: context.l10n.contactPhoneHint,
                  controller: _contactPhoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon:
                      const Icon(Icons.phone_outlined, size: 20),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: context.l10n.saveSettings,
                  onPressed: _onSaveSettings,
                  icon: Icons.save,
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),
                // Generate slots
                Text(context.l10n.generateSlots,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  context.l10n.generateSlotsSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(true),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: context.l10n.from,
                            prefixIcon:
                                const Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(_generateFromDate != null
                              ? '${_generateFromDate!.day}/${_generateFromDate!.month}/${_generateFromDate!.year}'
                              : context.l10n.select),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: context.l10n.to,
                            prefixIcon:
                                const Icon(Icons.calendar_today, size: 18),
                          ),
                          child: Text(_generateToDate != null
                              ? '${_generateToDate!.day}/${_generateToDate!.month}/${_generateToDate!.year}'
                              : context.l10n.select),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: context.l10n.generateSlots,
                  onPressed: _generateFromDate != null &&
                          _generateToDate != null
                      ? _onGenerateSlots
                      : null,
                  icon: Icons.auto_awesome,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSaveSettings() {
    context.read<AdminAvailabilityCubit>().saveConfig(
          workingDays: _workingDays.toList()..sort(),
          startTime: _startTimeController.text,
          endTime: _endTimeController.text,
          lessonDurationMinutes: _lessonDuration,
          bufferMinutes: _bufferMinutes,
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

  void _onGenerateSlots() {
    if (_generateFromDate == null || _generateToDate == null) return;
    context.read<AdminAvailabilityCubit>().generateSlots(
          fromDate: _generateFromDate!,
          toDate: _generateToDate!,
        );
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _generateFromDate = picked;
        } else {
          _generateToDate = picked;
        }
      });
    }
  }
}
