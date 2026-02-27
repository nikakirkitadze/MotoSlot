import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
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
      child: AppScaffold(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => _showCancelDialog(context),
        ),
        title: context.l10n.payment,
        body: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalSm,
              FadeInWidget(
                child: AppCard(
                  child: Column(
                    children: [
                      Text(
                        context.l10n.amountDue,
                        style: AppTypography.bodyMedium,
                      ),
                      AppSpacing.verticalSm,
                      Text(
                        context.l10n.gelCurrency(
                            booking.amount?.toStringAsFixed(2) ?? '0.00'),
                        style: AppTypography.displayLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      AppSpacing.verticalSm,
                      Text(
                        context.l10n.refLabel(booking.bookingReference),
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalLg,
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  context.l10n.selectPaymentMethod,
                  style: AppTypography.titleLarge,
                ),
              ),
              AppSpacing.verticalMd,
              FadeInWidget(
                delay: const Duration(milliseconds: 150),
                child: _buildPaymentOption(
                  context,
                  provider: PaymentProvider.tbc,
                  title: context.l10n.tbcBank,
                  subtitle: context.l10n.payWithTbcCard,
                  icon: Icons.account_balance_rounded,
                ),
              ),
              AppSpacing.verticalSm,
              FadeInWidget(
                delay: const Duration(milliseconds: 200),
                child: _buildPaymentOption(
                  context,
                  provider: PaymentProvider.bog,
                  title: context.l10n.bankOfGeorgia,
                  subtitle: context.l10n.payWithBogCard,
                  icon: Icons.account_balance_rounded,
                ),
              ),
              const Spacer(),
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state.isPaymentInProgress) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: AppLoadingIndicator(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Text(
                context.l10n.paymentRedirectNotice,
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalMd,
            ],
          ),
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
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
        title: Text(context.l10n.cancelPaymentTitle, style: AppTypography.headlineSmall),
        content: Text(context.l10n.cancelPaymentMessage, style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.continuePayment),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BookingCubit>().cancelBooking(booking.id);
              context.go('/home');
            },
            child: Text(context.l10n.cancel,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
