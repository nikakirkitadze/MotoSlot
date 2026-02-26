import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/app/theme.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/locale/cubit_l10n.dart';
import 'package:moto_slot/core/utils/date_utils.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/widgets/widgets.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_slot/modules/booking/domain/model/time_slot.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_cubit.dart';
import 'package:moto_slot/modules/booking/presentation/cubit/booking_state.dart';

class SlotDetailsScreen extends StatelessWidget {
  final TimeSlot slot;
  static const double _lessonPrice = 50.0; // GEL

  const SlotDetailsScreen({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.status == StateStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizeMessage(context, state.errorMessage!)),
              backgroundColor: AppTheme.errorColor,
            ),
          );
          context.read<BookingCubit>().clearError();
        }
        if (state.currentBooking != null &&
            state.currentBooking!.isPending) {
          context.push('/payment', extra: state.currentBooking);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.slotDetails)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoCard(context),
              const SizedBox(height: 24),
              _buildPriceCard(context),
              const SizedBox(height: 32),
              BlocBuilder<BookingCubit, BookingState>(
                builder: (context, state) {
                  return AppButton(
                    text: context.l10n.payAndConfirmBooking,
                    onPressed: () => _onBookSlot(context),
                    isLoading: state.isLoading,
                    icon: Icons.payment,
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.slotHeldDuringPayment,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(
              context,
              icon: Icons.calendar_today,
              label: context.l10n.date,
              value: AppDateUtils.formatDate(slot.startTime),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              icon: Icons.access_time,
              label: context.l10n.time,
              value: AppDateUtils.formatTimeRange(
                slot.startTime,
                slot.endTime,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              icon: Icons.timer_outlined,
              label: context.l10n.duration,
              value: context.l10n.minutesFull(slot.durationMinutes),
            ),
            if (slot.instructorName != null) ...[
              const Divider(height: 24),
              _buildInfoRow(
                context,
                icon: Icons.person_outline,
                label: context.l10n.instructor,
                value: slot.instructorName!,
              ),
            ],
            if (slot.location != null) ...[
              const Divider(height: 24),
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
    );
  }

  Widget _buildPriceCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.lessonFee,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              context.l10n.gelCurrency(_lessonPrice.toStringAsFixed(2)),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
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
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall,
            ),
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
