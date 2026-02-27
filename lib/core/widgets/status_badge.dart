import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/utils/enums.dart';
import 'package:moto_slot/core/utils/enum_l10n.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
  });

  factory StatusBadge.fromBookingStatus(BookingStatus status, BuildContext context) {
    return StatusBadge(
      label: status.localizedLabel(context),
      color: _bookingStatusColor(status),
    );
  }

  factory StatusBadge.fromSlotStatus(SlotStatus status, BuildContext context) {
    return StatusBadge(
      label: status.localizedLabel(context),
      color: _slotStatusColor(status),
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
        color: color.withValues(alpha: 0.1),
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
