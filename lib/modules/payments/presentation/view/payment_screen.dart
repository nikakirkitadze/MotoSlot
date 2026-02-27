import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/booking/domain/model/booking.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_state.dart';

class PaymentScreen extends StatelessWidget {
  final Booking booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.currentBooking?.isConfirmed == true) {
          context.go('/booking-confirmation', extra: state.currentBooking);
        }
        if (state.status == StateStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.errorMessage!)),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: () => _showCancelDialog(context),
                    ),
                    Expanded(
                      child: Text(
                        context.l10n.bookingPaymentSummary,
                        style: AppTypography.headlineMedium.copyWith(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Blue gradient section with booking details card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.borderRadiusLg,
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            boxShadow: AppShadows.md,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.bookingDetails,
                                style: AppTypography.headlineMedium.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildIconDetailRow(
                                Icons.sports_motorsports_outlined,
                                context.l10n.lesson,
                                context.l10n.minLesson(booking.durationMinutes),
                              ),
                              const SizedBox(height: 12),
                              _buildIconDetailRow(
                                Icons.calendar_today_rounded,
                                context.l10n.date,
                                AppDateUtils.formatDate(booking.startTime),
                              ),
                              const SizedBox(height: 12),
                              _buildIconDetailRow(
                                Icons.access_time_rounded,
                                context.l10n.time,
                                AppDateUtils.formatTimeRange(booking.startTime, booking.endTime),
                              ),
                              if (booking.location != null) ...[
                                const SizedBox(height: 12),
                                _buildIconDetailRow(
                                  Icons.location_on_outlined,
                                  context.l10n.location,
                                  booking.location!,
                                ),
                              ],
                              const SizedBox(height: 16),
                              // Student info
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: AppRadius.borderRadiusMd,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person_outline_rounded,
                                        size: 20, color: AppColors.primary),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        booking.userFullName,
                                        style: AppTypography.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Fee section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildFeeRow(
                            context.l10n.lessonFee,
                            context.l10n.gelCurrency(
                                booking.amount?.toStringAsFixed(2) ?? '0.00'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: AppColors.divider),
                          ),
                          _buildFeeRow(
                            'Total',
                            context.l10n.gelCurrency(
                                booking.amount?.toStringAsFixed(2) ?? '0.00'),
                            isBold: true,
                          ),
                          const SizedBox(height: 20),
                          // Secure payment badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: AppRadius.borderRadiusFull,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.lock_outline_rounded,
                                    size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.l10n.securePayment,
                                      style: AppTypography.labelMedium.copyWith(
                                        color: AppColors.navy,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      context.l10n.secureSSLEncrypted,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom section
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: [
                    Text(
                      context.l10n.termsAgreement,
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<BookingCubit, BookingState>(
                      builder: (context, state) {
                        return NavyButton(
                          text: context.l10n.payNow,
                          onPressed: () => _showPaymentMethodSheet(context),
                          isLoading: state.isPaymentInProgress,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: AppTypography.bodyMedium,
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String value, {bool isBold = false}) {
    final style = isBold
        ? AppTypography.headlineMedium.copyWith(color: AppColors.navy)
        : AppTypography.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }

  void _showPaymentMethodSheet(BuildContext context) {
    AppBottomSheet.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.selectPaymentMethod,
              style: AppTypography.headlineMedium.copyWith(color: AppColors.navy),
            ),
            AppSpacing.verticalLg,
            _buildPaymentOption(
              context,
              provider: PaymentProvider.tbc,
              title: context.l10n.tbcBank,
              subtitle: context.l10n.payWithTbcCard,
              icon: Icons.account_balance_rounded,
            ),
            AppSpacing.verticalSm,
            _buildPaymentOption(
              context,
              provider: PaymentProvider.bog,
              title: context.l10n.bankOfGeorgia,
              subtitle: context.l10n.payWithBogCard,
              icon: Icons.account_balance_rounded,
            ),
            AppSpacing.verticalMd,
            Text(
              context.l10n.paymentRedirectNotice,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentProvider provider,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return AppCard(
      onTap: () {
        Navigator.of(context).pop();
        context.read<BookingCubit>().initiatePayment(provider: provider);
      },
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
        backgroundColor: AppColors.surface,
        title: Text(
          context.l10n.cancelPaymentTitle,
          style: AppTypography.headlineMedium.copyWith(color: AppColors.navy),
          textAlign: TextAlign.center,
        ),
        content: Text(
          context.l10n.cancelPaymentMessage,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedAppButton(
                  text: context.l10n.continuePayment,
                  color: AppColors.navy,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NavyButton(
                  text: context.l10n.cancel,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.read<BookingCubit>().cancelBooking(booking.id);
                    context.go('/home');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
