import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';

class ReceiptPendingReviewScreen extends StatelessWidget {
  final Booking booking;

  const ReceiptPendingReviewScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          context.l10n.receiptPendingReview,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Amber clock icon
              FadeInWidget(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.warning.withValues(alpha: 0.2),
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                      ),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.warning,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalLg,
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  context.l10n.receiptPendingReview,
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              FadeInWidget(
                delay: const Duration(milliseconds: 150),
                child: Text(
                  context.l10n.receiptPendingReviewMessage,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              // Detail rows
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(context.l10n.lesson,
                        context.l10n.minLesson(booking.durationMinutes)),
                    const SizedBox(height: 10),
                    _buildDetailRow(context.l10n.date,
                        AppDateUtils.formatDate(booking.startTime)),
                    const SizedBox(height: 10),
                    _buildDetailRow(
                        context.l10n.time,
                        AppDateUtils.formatTimeRange(
                            booking.startTime, booking.endTime)),
                    if (booking.instructorName != null) ...[
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          context.l10n.instructor, booking.instructorName!),
                    ],
                    if (booking.location != null) ...[
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          context.l10n.location, booking.location!),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Booking reference card
              FadeInWidget(
                delay: const Duration(milliseconds: 250),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${context.l10n.bookingReference}: ',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        booking.bookingReference,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
                child: OutlinedAppButton(
                  text: context.l10n.backToHome,
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

  Widget _buildDetailRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style:
            AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
