import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppTheme.successColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.bookingConfirmed,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.successColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.bookingConfirmedSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildDetailRow(context, context.l10n.bookingReference,
                          booking.bookingReference),
                      const Divider(height: 24),
                      _buildDetailRow(context, context.l10n.date,
                          AppDateUtils.formatDate(booking.startTime)),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        context.l10n.time,
                        AppDateUtils.formatTimeRange(
                          booking.startTime,
                          booking.endTime,
                        ),
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(context, context.l10n.duration,
                          context.l10n.minutesFull(booking.durationMinutes)),
                      if (booking.instructorName != null) ...[
                        const Divider(height: 24),
                        _buildDetailRow(
                            context, context.l10n.instructor, booking.instructorName!),
                      ],
                      if (booking.location != null) ...[
                        const Divider(height: 24),
                        _buildDetailRow(
                            context, context.l10n.location, booking.location!),
                      ],
                      if (booking.amount != null) ...[
                        const Divider(height: 24),
                        _buildDetailRow(context, context.l10n.amountPaid,
                            context.l10n.gelCurrency(booking.amount!.toStringAsFixed(2))),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active_outlined,
                        color: AppTheme.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.reminderNotice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.primaryDark,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppButton(
                text: context.l10n.viewMyBookings,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: context.l10n.bookAnotherLesson,
                onPressed: () => context.go('/home'),
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
