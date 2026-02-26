import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moto_slot/app/theme.dart';
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
            const Divider(height: 1),
            Expanded(child: _buildSlotList(state)),
          ],
        );
      },
    );
  }

  Widget _buildCalendar(UserSlotsState state) {
    final slotsByDay = state.slotsByDay;

    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 90)),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: CalendarFormat.twoWeeks,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        markerDecoration: const BoxDecoration(
          color: AppTheme.slotAvailable,
          shape: BoxShape.circle,
        ),
        markerSize: 6,
        markersMaxCount: 1,
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
    );
  }

  Widget _buildSlotList(UserSlotsState state) {
    if (state.isLoading) {
      return AppLoading(message: context.l10n.loadingAvailableSlots);
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
        icon: Icons.event_busy,
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<UserSlotsCubit>().refreshSlots(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: slotsForDay.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                context.l10n.availableOn(AppDateUtils.formatDate(selectedDate)),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          return _buildSlotCard(slotsForDay[index - 1]);
        },
      ),
    );
  }

  Widget _buildSlotCard(TimeSlot slot) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/slot-details', extra: slot),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.slotAvailable,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppDateUtils.formatTimeRange(
                        slot.startTime,
                        slot.endTime,
                      ),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.minLesson(slot.durationMinutes),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (slot.location != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: AppTheme.textHint),
                          const SizedBox(width: 4),
                          Text(
                            slot.location!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              StatusBadge(label: context.l10n.slotStatusAvailable, color: AppTheme.slotAvailable),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppTheme.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
