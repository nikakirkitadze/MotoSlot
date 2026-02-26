import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class AdminBookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const AdminBookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking.bookingReference),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    StatusBadge.fromBookingStatus(booking.status, context),
                    const SizedBox(height: 8),
                    if (booking.isManualBooking)
                      Text(
                        context.l10n.manualBooking,
                        style: const TextStyle(
                          color: AppTheme.warningColor,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // User info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.userInformation,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildRow(context, Icons.person_outline, context.l10n.name,
                        booking.userFullName),
                    const Divider(height: 20),
                    _buildRow(context, Icons.email_outlined, context.l10n.email,
                        booking.userEmail),
                    const Divider(height: 20),
                    _buildRow(context, Icons.phone_outlined, context.l10n.phone,
                        booking.userPhone),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lesson info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.lessonDetails,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    _buildRow(context, Icons.calendar_today, context.l10n.date,
                        AppDateUtils.formatDate(booking.startTime)),
                    const Divider(height: 20),
                    _buildRow(
                      context,
                      Icons.access_time,
                      context.l10n.time,
                      AppDateUtils.formatTimeRange(
                        booking.startTime,
                        booking.endTime,
                      ),
                    ),
                    const Divider(height: 20),
                    _buildRow(context, Icons.timer_outlined, context.l10n.duration,
                        context.l10n.minutesShort(booking.durationMinutes)),
                    if (booking.instructorName != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, Icons.school, context.l10n.instructor,
                          booking.instructorName!),
                    ],
                    if (booking.location != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, Icons.location_on_outlined,
                          context.l10n.location, booking.location!),
                    ],
                    if (booking.amount != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, Icons.payment, context.l10n.amount,
                          context.l10n.gelCurrency(booking.amount!.toStringAsFixed(2))),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Actions
            if (booking.isConfirmed) ...[
              AppButton(
                text: context.l10n.markAsCompleted,
                onPressed: () => _completeBooking(context),
                backgroundColor: AppTheme.successColor,
                icon: Icons.check_circle,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: context.l10n.cancelBooking,
                onPressed: () => _cancelBooking(context),
                backgroundColor: AppTheme.errorColor,
                icon: Icons.cancel,
              ),
            ],
            if (booking.isPending) ...[
              AppButton(
                text: context.l10n.cancelBooking,
                onPressed: () => _cancelBooking(context),
                backgroundColor: AppTheme.errorColor,
                icon: Icons.cancel,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
        ),
      ],
    );
  }

  void _cancelBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.cancelBookingConfirmTitle),
        content: Text(context.l10n.cancelBookingAdminMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.keep),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminBookingsCubit>().cancelBooking(
                    booking.id,
                    booking.slotId,
                  );
              context.pop();
            },
            child: Text(context.l10n.cancel,
                style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  void _completeBooking(BuildContext context) {
    context.read<AdminBookingsCubit>().completeBooking(booking.id);
    context.pop();
  }
}
