import 'package:flutter/material.dart';
import 'package:moto_slot/app/theme.dart';
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
        return AppTheme.warningColor;
      case BookingStatus.confirmed:
        return AppTheme.successColor;
      case BookingStatus.cancelled:
        return AppTheme.errorColor;
      case BookingStatus.completed:
        return AppTheme.primaryColor;
      case BookingStatus.expired:
        return AppTheme.textHint;
    }
  }

  static Color _slotStatusColor(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return AppTheme.slotAvailable;
      case SlotStatus.locked:
        return AppTheme.slotLocked;
      case SlotStatus.booked:
        return AppTheme.slotBooked;
      case SlotStatus.blocked:
        return AppTheme.slotBlocked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
