import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/modules/admin/presentation/cubit/admin_bookings_cubit.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class AdminBookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const AdminBookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasBackButton: true,
      title: booking.bookingReference,
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.verticalSm,
            // Status
            FadeInWidget(
              child: AppCard(
                child: Column(
                  children: [
                    AppBadge.fromBookingStatus(booking.status, context),
                    if (booking.isManualBooking) ...[
                      AppSpacing.verticalSm,
                      AppBadge(
                        label: context.l10n.manualBooking,
                        color: AppColors.warning,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            AppSpacing.verticalMd,
            // User info
            FadeInWidget(
              delay: const Duration(milliseconds: 100),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.userInformation, style: AppTypography.titleLarge),
                    AppSpacing.verticalMd,
                    _buildRow(context, Icons.person_outline_rounded, context.l10n.name,
                        booking.userFullName),
                    _divider(),
                    _buildRow(context, Icons.email_outlined, context.l10n.email,
                        booking.userEmail),
                    _divider(),
                    _buildRow(context, Icons.phone_outlined, context.l10n.phone,
                        booking.userPhone),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalMd,
            // Lesson info
            FadeInWidget(
              delay: const Duration(milliseconds: 150),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.lessonDetails, style: AppTypography.titleLarge),
                    AppSpacing.verticalMd,
                    _buildRow(context, Icons.calendar_today_rounded, context.l10n.date,
                        AppDateUtils.formatDate(booking.startTime)),
                    _divider(),
                    _buildRow(context, Icons.access_time_rounded, context.l10n.time,
                        AppDateUtils.formatTimeRange(booking.startTime, booking.endTime)),
                    _divider(),
                    _buildRow(context, Icons.timer_outlined, context.l10n.duration,
                        context.l10n.minutesShort(booking.durationMinutes)),
                    if (booking.instructorName != null) ...[
                      _divider(),
                      _buildRow(context, Icons.school_rounded, context.l10n.instructor,
                          booking.instructorName!),
                    ],
                    if (booking.location != null) ...[
                      _divider(),
                      _buildRow(context, Icons.location_on_outlined,
                          context.l10n.location, booking.location!),
                    ],
                    if (booking.amount != null) ...[
                      _divider(),
                      _buildRow(context, Icons.payment_rounded, context.l10n.amount,
                          context.l10n.gelCurrency(booking.amount!.toStringAsFixed(2))),
                    ],
                  ],
                ),
              ),
            ),
            AppSpacing.verticalLg,
            // Actions
            if (booking.isConfirmed) ...[
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: PrimaryButton(
                  text: context.l10n.markAsCompleted,
                  onPressed: () => _completeBooking(context),
                  icon: Icons.check_circle_rounded,
                ),
              ),
              AppSpacing.verticalSm,
              FadeInWidget(
                delay: const Duration(milliseconds: 250),
                child: SecondaryButton(
                  text: context.l10n.cancelBooking,
                  onPressed: () => _cancelBooking(context),
                  icon: Icons.cancel_rounded,
                ),
              ),
            ],
            if (booking.isPending) ...[
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: PrimaryButton(
                  text: context.l10n.cancelBooking,
                  onPressed: () => _cancelBooking(context),
                  icon: Icons.cancel_rounded,
                ),
              ),
            ],
            AppSpacing.verticalLg,
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: AppColors.divider),
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

  void _cancelBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
        title: Text(context.l10n.cancelBookingConfirmTitle, style: AppTypography.headlineSmall),
        content: Text(context.l10n.cancelBookingAdminMessage, style: AppTypography.bodyMedium),
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
                style: TextStyle(color: AppColors.error)),
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
