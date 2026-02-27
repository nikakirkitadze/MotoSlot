import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasBackButton: true,
      title: context.l10n.bookingDetails,
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.verticalSm,
            // Status header
            FadeInWidget(
              child: AppCard(
                child: Column(
                  children: [
                    AppBadge.fromBookingStatus(booking.status, context),
                    AppSpacing.verticalSm,
                    Text(
                      booking.bookingReference,
                      style: AppTypography.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalMd,
            // Details card
            FadeInWidget(
              delay: const Duration(milliseconds: 100),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.lessonDetails, style: AppTypography.titleLarge),
                    AppSpacing.verticalMd,
                    _buildRow(context, Icons.calendar_today_rounded, context.l10n.date,
                        AppDateUtils.formatDate(booking.startTime)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: AppColors.divider),
                    ),
                    _buildRow(context, Icons.access_time_rounded, context.l10n.time,
                        AppDateUtils.formatTimeRange(booking.startTime, booking.endTime)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: AppColors.divider),
                    ),
                    _buildRow(context, Icons.timer_outlined, context.l10n.duration,
                        context.l10n.minutesFull(booking.durationMinutes)),
                    if (booking.instructorName != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildRow(context, Icons.person_outline_rounded,
                          context.l10n.instructor, booking.instructorName!),
                    ],
                    if (booking.location != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildRow(context, Icons.location_on_outlined,
                          context.l10n.location, booking.location!),
                    ],
                    if (booking.contactPhone != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildRow(context, Icons.phone_outlined,
                          context.l10n.contact, booking.contactPhone!),
                    ],
                    if (booking.amount != null) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildRow(context, Icons.payment_rounded, context.l10n.amount,
                          context.l10n.gelCurrency(booking.amount!.toStringAsFixed(2))),
                    ],
                  ],
                ),
              ),
            ),
            if (booking.isConfirmed &&
                booking.startTime.isAfter(DateTime.now().toUtc())) ...[
              AppSpacing.verticalLg,
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: PrimaryButton(
                  text: context.l10n.cancelBooking,
                  onPressed: () => _showCancelDialog(context),
                  icon: Icons.cancel_outlined,
                ),
              ),
            ],
            AppSpacing.verticalLg,
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
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppRadius.borderRadiusSm,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall),
              Text(value, style: AppTypography.titleMedium),
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
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
        title: Text(context.l10n.cancelBookingConfirmTitle, style: AppTypography.headlineSmall),
        content: Text(context.l10n.cancelBookingConfirmMessage, style: AppTypography.bodyMedium),
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
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
