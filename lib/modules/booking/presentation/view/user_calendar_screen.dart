import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/user_slots_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/user_slots_state.dart';

class UserCalendarScreen extends StatefulWidget {
  const UserCalendarScreen({super.key});

  @override
  State<UserCalendarScreen> createState() => _UserCalendarScreenState();
}

class _UserCalendarScreenState extends State<UserCalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    context.read<UserSlotsCubit>().loadAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSlotsCubit, UserSlotsState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildCalendar(state),
            Expanded(child: _buildSlotList(state)),
          ],
        );
      },
    );
  }

  Widget _buildCalendar(UserSlotsState state) {
    final slotsByDay = state.slotsByDay;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.twoWeeks,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTypography.titleLarge,
          leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
          rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
          headerPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTypography.labelSmall,
          weekendStyle: AppTypography.labelSmall,
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          cellMargin: const EdgeInsets.all(4),
          defaultTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          weekendTextStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppRadius.borderRadiusSm,
          ),
          todayTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.borderRadiusSm,
          ),
          selectedTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
          markerDecoration: BoxDecoration(
            color: AppColors.slotAvailable,
            shape: BoxShape.circle,
          ),
          markerSize: 5,
          markersMaxCount: 1,
          markerMargin: const EdgeInsets.only(top: 2),
        ),
        eventLoader: (day) {
          final normalizedDay = DateTime(day.year, day.month, day.day);
          return slotsByDay[normalizedDay] ?? [];
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          context.read<UserSlotsCubit>().selectDate(selectedDay);
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildSlotList(UserSlotsState state) {
    if (state.isLoading) {
      return const AppLoadingIndicator();
    }

    if (state.status == StateStatus.failure) {
      return AppErrorWidget(
        message: state.errorMessage ?? context.l10n.failedToLoadSlots,
        onRetry: () => context.read<UserSlotsCubit>().refreshSlots(),
      );
    }

    final selectedDate = _selectedDay ?? DateTime.now();
    final slotsForDay = state.slots.where((slot) {
      final slotLocal = slot.startTime.toLocal();
      return AppDateUtils.isSameDay(slotLocal, selectedDate);
    }).toList();

    if (slotsForDay.isEmpty) {
      return AppEmptyState(
        title: context.l10n.noAvailableSlots,
        subtitle: context.l10n.noAvailableSlotsSubtitle,
        icon: Icons.event_busy_rounded,
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<UserSlotsCubit>().refreshSlots(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: slotsForDay.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 4),
              child: Text(
                context.l10n.availableOn(AppDateUtils.formatDate(selectedDate)),
                style: AppTypography.titleMedium,
              ),
            );
          }
          return StaggeredItem(
            index: index - 1,
            child: _buildSlotCard(slotsForDay[index - 1]),
          );
        },
      ),
    );
  }

  Widget _buildSlotCard(TimeSlot slot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => context.push('/slot-details', extra: slot),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.slotAvailable,
                borderRadius: AppRadius.borderRadiusFull,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppDateUtils.formatTimeRange(slot.startTime, slot.endTime),
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.minLesson(slot.durationMinutes),
                    style: AppTypography.bodySmall,
                  ),
                  if (slot.location != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text(slot.location!, style: AppTypography.bodySmall),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            AppBadge(
              label: context.l10n.slotStatusAvailable,
              color: AppColors.slotAvailable,
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}
