import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_state.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  void _loadBookings() {
    final userId = context.read<AuthCubit>().state.user?.id;
    if (userId != null) {
      context.read<BookingCubit>().loadUserBookings(userId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textHint,
          indicatorColor: AppTheme.primaryColor,
          tabs: [
            Tab(text: context.l10n.upcoming),
            Tab(text: context.l10n.past),
          ],
        ),
        Expanded(
          child: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state.isLoading) {
                return AppLoading(message: context.l10n.loadingBookings);
              }

              if (state.status == StateStatus.failure) {
                return AppErrorWidget(
                  message: state.errorMessage ?? context.l10n.failedToLoadBookings,
                  onRetry: _loadBookings,
                );
              }

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingList(state.upcomingBookings, isUpcoming: true),
                  _buildBookingList(state.pastBookings, isUpcoming: false),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingList(List<Booking> bookings, {required bool isUpcoming}) {
    if (bookings.isEmpty) {
      return AppEmptyState(
        title: isUpcoming ? context.l10n.noUpcomingBookings : context.l10n.noPastBookings,
        subtitle: isUpcoming
            ? context.l10n.noUpcomingBookingsSubtitle
            : context.l10n.noPastBookingsSubtitle,
        icon: isUpcoming ? Icons.event_available : Icons.history,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) =>
            _buildBookingCard(bookings[index]),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/booking-details', extra: booking),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingReference,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                  ),
                  StatusBadge.fromBookingStatus(booking.status, context),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    AppDateUtils.formatDate(booking.startTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    AppDateUtils.formatTimeRange(
                      booking.startTime,
                      booking.endTime,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              if (booking.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      booking.location!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
