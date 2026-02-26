import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moto_slot/app/theme.dart';
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
        const Divider(height: 1),
        _buildActionBar(context),
        Expanded(child: _buildDayView()),
      ],
    );
  }

  Widget _buildCalendar() {
    return BlocBuilder<AdminAvailabilityCubit, AdminAvailabilityState>(
      builder: (context, state) {
        final blockedDates = state.config?.blockedDates ?? [];

        return TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 30)),
          lastDay: DateTime.now().add(const Duration(days: 180)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
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
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: AppTheme.errorColor,
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
        );
      },
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            _selectedDay != null
                ? AppDateUtils.formatDate(_selectedDay!)
                : context.l10n.today,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => context.push('/admin/manual-booking'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(context.l10n.manualBook),
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
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
                    const Icon(Icons.block, size: 18, color: AppTheme.errorColor),
                    const SizedBox(width: 8),
                    Text(context.l10n.blockDate),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'unblock',
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 18, color: AppTheme.successColor),
                    const SizedBox(width: 8),
                    Text(context.l10n.unblockDate),
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
          return AppLoading(message: context.l10n.loading);
        }

        if (state.bookings.isEmpty) {
          return AppEmptyState(
            title: context.l10n.noBookingsForDay,
            subtitle: context.l10n.noBookingsForDaySubtitle,
            icon: Icons.event_note,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.bookings.length,
          itemBuilder: (context, index) {
            final booking = state.bookings[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => context.push('/admin/booking-detail',
                    extra: booking),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 56,
                        decoration: BoxDecoration(
                          color: booking.isConfirmed
                              ? AppTheme.slotBooked
                              : booking.isPending
                                  ? AppTheme.warningColor
                                  : AppTheme.textHint,
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
                                booking.startTime,
                                booking.endTime,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking.userFullName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              booking.userPhone,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StatusBadge.fromBookingStatus(booking.status, context),
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
