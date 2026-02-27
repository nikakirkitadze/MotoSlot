import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
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
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppRadius.borderRadiusMd,
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textHint,
            labelStyle: AppTypography.titleMedium,
            unselectedLabelStyle: AppTypography.bodyMedium,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.borderRadiusMd,
              boxShadow: AppShadows.sm,
            ),
            indicatorPadding: const EdgeInsets.all(3),
            dividerHeight: 0,
            tabs: [
              Tab(text: context.l10n.upcoming),
              Tab(text: context.l10n.past),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const AppLoadingIndicator();
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
        icon: isUpcoming ? Icons.event_available_rounded : Icons.history_rounded,
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _loadBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: bookings.length,
        itemBuilder: (context, index) => StaggeredItem(
          index: index,
          child: _buildBookingCard(bookings[index]),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => context.push('/booking-details', extra: booking),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.bookingReference,
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                ),
                AppBadge.fromBookingStatus(booking.status, context),
              ],
            ),
            AppSpacing.verticalSm,
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  AppDateUtils.formatDate(booking.startTime),
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(width: 14),
                const Icon(Icons.access_time_rounded,
                    size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  AppDateUtils.formatTimeRange(booking.startTime, booking.endTime),
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            if (booking.location != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 15, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(booking.location!, style: AppTypography.bodySmall),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
