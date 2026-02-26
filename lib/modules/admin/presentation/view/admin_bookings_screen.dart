import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
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
                    backgroundColor: AppTheme.successColor,
                  ),
                );
                context.read<AdminBookingsCubit>().clearMessages();
              }
            },
            builder: (context, state) {
              if (state.isLoading) {
                return const AppLoading();
              }

              if (state.bookings.isEmpty) {
                return AppEmptyState(
                  title: context.l10n.noBookingsFound,
                  subtitle: context.l10n.noBookingsFoundSubtitle,
                  icon: Icons.search_off,
                );
              }

              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<AdminBookingsCubit>().loadBookings(
                          status: _selectedFilter,
                        ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) =>
                      _buildBookingTile(state.bookings[index]),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _selectedFilter = status);
        context.read<AdminBookingsCubit>().setFilter(status: status);
      },
      selectedColor: AppTheme.primaryLight,
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildBookingTile(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/admin/booking-detail', extra: booking),
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
                  const Icon(Icons.person_outline,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(booking.userFullName,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: 16),
                  const Icon(Icons.phone_outlined,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(booking.userPhone,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    AppDateUtils.formatDateTime(booking.startTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              if (booking.isManualBooking) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    context.l10n.manualBooking,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.warningColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
