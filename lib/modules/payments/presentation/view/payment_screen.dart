import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
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
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.payment),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _showCancelDialog(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.amountDue,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.gelCurrency(
                            booking.amount?.toStringAsFixed(2) ?? '0.00'),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.refLabel(booking.bookingReference),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                context.l10n.selectPaymentMethod,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildPaymentOption(
                context,
                provider: PaymentProvider.tbc,
                title: context.l10n.tbcBank,
                subtitle: context.l10n.payWithTbcCard,
                icon: Icons.account_balance,
              ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                context,
                provider: PaymentProvider.bog,
                title: context.l10n.bankOfGeorgia,
                subtitle: context.l10n.payWithBogCard,
                icon: Icons.account_balance,
              ),
              const Spacer(),
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  if (state.isPaymentInProgress) {
                    return AppLoading(message: context.l10n.processingPayment);
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.paymentRedirectNotice,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
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
    return Card(
      child: InkWell(
        onTap: () {
          context.read<BookingCubit>().initiatePayment(provider: provider);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textHint),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.cancelPaymentTitle),
        content: Text(context.l10n.cancelPaymentMessage),
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
                style: const TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
