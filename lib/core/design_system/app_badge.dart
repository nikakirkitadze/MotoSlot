import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/app_colors.dart';
import 'package:moto_slot/core/design_system/app_radius.dart';
import 'package:moto_slot/core/design_system/app_typography.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/utils/enum_l10n.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? backgroundColor;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.backgroundColor,
  });

  factory AppBadge.fromBookingStatus(BookingStatus status, BuildContext context) {
    final color = _bookingStatusColor(status);
    return AppBadge(
      label: status.localizedLabel(context),
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
    );
  }

  factory AppBadge.fromSlotStatus(SlotStatus status, BuildContext context) {
    final color = _slotStatusColor(status);
    return AppBadge(
      label: status.localizedLabel(context),
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
    );
  }

  static Color _bookingStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pendingPayment:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.completed:
        return AppColors.primary;
      case BookingStatus.expired:
        return AppColors.textHint;
    }
  }

  static Color _slotStatusColor(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return AppColors.slotAvailable;
      case SlotStatus.locked:
        return AppColors.slotLocked;
      case SlotStatus.booked:
        return AppColors.slotBooked;
      case SlotStatus.blocked:
        return AppColors.slotBlocked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderRadiusFull,
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
