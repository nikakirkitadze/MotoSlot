import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/utils/enum_l10n.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_state.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  BookingStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<AdminBookingsCubit>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
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
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const AppLoadingIndicator();
              }

              if (state.bookings.isEmpty) {
                return AppEmptyState(
                  title: context.l10n.noBookingsFound,
                  subtitle: context.l10n.noBookingsFoundSubtitle,
                  icon: Icons.search_off_rounded,
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async =>
                    context.read<AdminBookingsCubit>().loadBookings(
                          status: _selectedFilter,
                        ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) => StaggeredItem(
                    index: index,
                    child: _buildBookingTile(state.bookings[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          _buildFilterChip(context.l10n.all, null),
          const SizedBox(width: 8),
          ...BookingStatus.values.map(
            (status) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(status.localizedLabel(context), status),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, BookingStatus? status) {
    final isSelected = _selectedFilter == status;
    return FilterChip(
      label: Text(label, style: AppTypography.labelMedium.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      )),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedFilter = status);
        context.read<AdminBookingsCubit>().setFilter(status: status);
      },
      selectedColor: AppColors.primaryLight,
      checkmarkColor: AppColors.primary,
      backgroundColor: AppColors.surfaceVariant,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusSm),
    );
  }

  Widget _buildBookingTile(Booking booking) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        onTap: () => context.push('/admin/booking-detail', extra: booking),
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
                const Icon(Icons.person_outline_rounded,
                    size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(booking.userFullName, style: AppTypography.titleSmall),
                const SizedBox(width: 14),
                const Icon(Icons.phone_outlined,
                    size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(booking.userPhone, style: AppTypography.bodySmall),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 15, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  AppDateUtils.formatDateTime(booking.startTime),
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
            if (booking.isManualBooking) ...[
              const SizedBox(height: 8),
              AppBadge(
                label: context.l10n.manualBooking,
                color: AppColors.warning,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
