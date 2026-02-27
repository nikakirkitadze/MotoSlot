import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_state.dart';

class SlotDetailsScreen extends StatelessWidget {
  final TimeSlot slot;
  static const double _lessonPrice = 50.0;

  const SlotDetailsScreen({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.status == StateStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.errorMessage!)),
              backgroundColor: AppColors.error,
            ),
          );
          context.read<BookingCubit>().clearError();
        }
        if (state.currentBooking != null && state.currentBooking!.isPending) {
          context.push('/payment', extra: state.currentBooking);
        }
      },
      child: AppScaffold(
        hasBackButton: true,
        title: context.l10n.slotDetails,
        body: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalSm,
              FadeInWidget(
                child: AppCard(
                  child: Column(
                    children: [
                      _buildInfoRow(
                        context,
                        icon: Icons.calendar_today_rounded,
                        label: context.l10n.date,
                        value: AppDateUtils.formatDate(slot.startTime),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildInfoRow(
                        context,
                        icon: Icons.access_time_rounded,
                        label: context.l10n.time,
                        value: AppDateUtils.formatTimeRange(slot.startTime, slot.endTime),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: AppColors.divider),
                      ),
                      _buildInfoRow(
                        context,
                        icon: Icons.timer_outlined,
                        label: context.l10n.duration,
                        value: context.l10n.minutesFull(slot.durationMinutes),
                      ),
                      if (slot.instructorName != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),
                        _buildInfoRow(
                          context,
                          icon: Icons.person_outline_rounded,
                          label: context.l10n.instructor,
                          value: slot.instructorName!,
                        ),
                      ],
                      if (slot.location != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: AppColors.divider),
                        ),
                        _buildInfoRow(
                          context,
                          icon: Icons.location_on_outlined,
                          label: context.l10n.location,
                          value: slot.location!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalMd,
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.l10n.lessonFee, style: AppTypography.titleLarge),
                      Text(
                        context.l10n.gelCurrency(_lessonPrice.toStringAsFixed(2)),
                        style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.verticalLg,
              FadeInWidget(
                delay: const Duration(milliseconds: 150),
                child: BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    return NavyButton(
                      text: context.l10n.continueToPayment,
                      onPressed: () => _onBookSlot(context),
                      isLoading: state.isLoading,
                      icon: Icons.payment_rounded,
                    );
                  },
                ),
              ),
              AppSpacing.verticalSm,
              Text(
                context.l10n.slotHeldDuringPayment,
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalLg,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.bodySmall),
            Text(value, style: AppTypography.titleMedium),
          ],
        ),
      ],
    );
  }

  void _onBookSlot(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState.user == null) return;

    context.read<BookingCubit>().createPendingBooking(
          slot: slot,
          userId: authState.user!.id,
          userFullName: authState.user!.fullName,
          userPhone: authState.user!.phone,
          userEmail: authState.user!.email,
          amount: _lessonPrice,
        );
  }
}
