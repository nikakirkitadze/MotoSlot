import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.bookingDetails),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    StatusBadge.fromBookingStatus(booking.status, context),
                    const SizedBox(height: 12),
                    Text(
                      booking.bookingReference,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Details card
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
                        context.l10n.minutesFull(booking.durationMinutes)),
                    if (booking.instructorName != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, Icons.person_outline, context.l10n.instructor,
                          booking.instructorName!),
                    ],
                    if (booking.location != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, Icons.location_on_outlined,
                          context.l10n.location, booking.location!),
                    ],
                    if (booking.contactPhone != null) ...[
                      const Divider(height: 20),
                      _buildRow(context, Icons.phone_outlined, context.l10n.contact,
                          booking.contactPhone!),
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
            if (booking.isConfirmed &&
                booking.startTime.isAfter(DateTime.now().toUtc())) ...[
              const SizedBox(height: 24),
              AppButton(
                text: context.l10n.cancelBooking,
                onPressed: () => _showCancelDialog(context),
                backgroundColor: AppTheme.errorColor,
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

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.cancelBookingConfirmTitle),
        content: Text(context.l10n.cancelBookingConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.keepBooking),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BookingCubit>().cancelBooking(booking.id);
              context.go('/home');
            },
            child: Text(context.l10n.cancelBooking,
                style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
