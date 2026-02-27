import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const SizedBox(height: 48),
              FadeInWidget(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 44,
                  ),
                ),
              ),
              AppSpacing.verticalLg,
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  context.l10n.bookingConfirmed,
                  style: AppTypography.headlineLarge.copyWith(color: AppColors.success),
                ),
              ),
              AppSpacing.verticalSm,
              FadeInWidget(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  context.l10n.bookingConfirmedSubtitle,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.verticalXl,
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: AppCard(
                  child: Column(
                    children: [
                      _buildDetailRow(context, context.l10n.bookingReference,
                          booking.bookingReference),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildDetailRow(context, context.l10n.date,
                          AppDateUtils.formatDate(booking.startTime)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildDetailRow(
                        context,
                        context.l10n.time,
                        AppDateUtils.formatTimeRange(booking.startTime, booking.endTime),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildDetailRow(context, context.l10n.duration,
                          context.l10n.minutesFull(booking.durationMinutes)),
                      if (booking.instructorName != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),
                        _buildDetailRow(
                            context, context.l10n.instructor, booking.instructorName!),
                      ],
                      if (booking.location != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),
                        _buildDetailRow(
                            context, context.l10n.location, booking.location!),
                      ],
                      if (booking.amount != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),
                        _buildDetailRow(context, context.l10n.amountPaid,
                            context.l10n.gelCurrency(booking.amount!.toStringAsFixed(2))),
                      ],
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalMd,
              FadeInWidget(
                delay: const Duration(milliseconds: 250),
                child: Container(
                  padding: AppSpacing.paddingAllMd,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.4),
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_outlined,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.reminderNotice,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalXl,
              FadeInWidget(
                delay: const Duration(milliseconds: 300),
                child: PrimaryButton(
                  text: context.l10n.viewMyBookings,
                  onPressed: () => context.go('/home'),
                ),
              ),
              AppSpacing.verticalSm,
              FadeInWidget(
                delay: const Duration(milliseconds: 350),
                child: SecondaryButton(
                  text: context.l10n.bookAnotherLesson,
                  onPressed: () => context.go('/home'),
                ),
              ),
              AppSpacing.verticalLg,
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
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.titleMedium),
      ],
    );
  }
}
