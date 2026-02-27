import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_availability_state.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_state.dart';

class AdminCalendarScreen extends StatefulWidget {
  const AdminCalendarScreen({super.key});

  @override
  State<AdminCalendarScreen> createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends State<AdminCalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    context.read<AdminAvailabilityCubit>().loadConfig();
    context.read<AdminBookingsCubit>().loadBookings(date: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendar(),
        _buildActionBar(context),
        Expanded(child: _buildDayView()),
      ],
    );
  }

  Widget _buildCalendar() {
    return BlocBuilder<AdminAvailabilityCubit, AdminAvailabilityState>(
      builder: (context, state) {
        final blockedDates = state.config?.blockedDates ?? [];

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(color: AppColors.border),
          ),
          child: TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 180)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
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
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isBlocked = blockedDates.any((d) =>
                    d.year == day.year &&
                    d.month == day.month &&
                    d.day == day.day);
                if (isBlocked) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: AppRadius.borderRadiusSm,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.error,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              context.read<AdminBookingsCubit>().loadBookings(date: selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        );
      },
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            _selectedDay != null
                ? AppDateUtils.formatDate(_selectedDay!)
                : context.l10n.today,
            style: AppTypography.titleLarge,
          ),
          const Spacer(),
          GhostButton(
            text: context.l10n.manualBook,
            icon: Icons.add_rounded,
            onPressed: () => context.push('/admin/manual-booking'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
            onSelected: (value) {
              if (value == 'block') {
                _blockSelectedDate();
              } else if (value == 'unblock') {
                _unblockSelectedDate();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    const Icon(Icons.block_rounded, size: 18, color: AppColors.error),
                    const SizedBox(width: 10),
                    Text(context.l10n.blockDate, style: AppTypography.bodyLarge),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'unblock',
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        size: 18, color: AppColors.success),
                    const SizedBox(width: 10),
                    Text(context.l10n.unblockDate, style: AppTypography.bodyLarge),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    return BlocBuilder<AdminBookingsCubit, AdminBookingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const AppLoadingIndicator();
        }

        if (state.bookings.isEmpty) {
          return AppEmptyState(
            title: context.l10n.noBookingsForDay,
            subtitle: context.l10n.noBookingsForDaySubtitle,
            icon: Icons.event_note_rounded,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: state.bookings.length,
          itemBuilder: (context, index) {
            final booking = state.bookings[index];
            return StaggeredItem(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  onTap: () => context.push('/admin/booking-detail', extra: booking),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 48,
                        decoration: BoxDecoration(
                          color: booking.isConfirmed
                              ? AppColors.slotBooked
                              : booking.isPending
                                  ? AppColors.warning
                                  : AppColors.textHint,
                          borderRadius: AppRadius.borderRadiusFull,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppDateUtils.formatTimeRange(booking.startTime, booking.endTime),
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(height: 3),
                            Text(booking.userFullName, style: AppTypography.bodyMedium),
                            Text(booking.userPhone, style: AppTypography.bodySmall),
                          ],
                        ),
                      ),
                      AppBadge.fromBookingStatus(booking.status, context),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _blockSelectedDate() {
    if (_selectedDay == null) return;
    context.read<AdminAvailabilityCubit>().blockDate(_selectedDay!);
  }

  void _unblockSelectedDate() {
    if (_selectedDay == null) return;
    context.read<AdminAvailabilityCubit>().unblockDate(_selectedDay!);
  }
}
