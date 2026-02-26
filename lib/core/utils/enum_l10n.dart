import 'package:flutter/widgets.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/core/utils/enums.dart';

extension BookingStatusL10n on BookingStatus {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case BookingStatus.pendingPayment:
        return context.l10n.bookingStatusPendingPayment;
      case BookingStatus.confirmed:
        return context.l10n.bookingStatusConfirmed;
      case BookingStatus.cancelled:
        return context.l10n.bookingStatusCancelled;
      case BookingStatus.completed:
        return context.l10n.bookingStatusCompleted;
      case BookingStatus.expired:
        return context.l10n.bookingStatusExpired;
    }
  }
}

extension SlotStatusL10n on SlotStatus {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case SlotStatus.available:
        return context.l10n.slotStatusAvailable;
      case SlotStatus.locked:
        return context.l10n.slotStatusLocked;
      case SlotStatus.booked:
        return context.l10n.slotStatusBooked;
      case SlotStatus.blocked:
        return context.l10n.slotStatusBlocked;
    }
  }
}

extension PaymentStatusL10n on PaymentStatus {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case PaymentStatus.pending:
        return context.l10n.paymentStatusPending;
      case PaymentStatus.processing:
        return context.l10n.paymentStatusProcessing;
      case PaymentStatus.success:
        return context.l10n.paymentStatusSuccess;
      case PaymentStatus.failed:
        return context.l10n.paymentStatusFailed;
      case PaymentStatus.cancelled:
        return context.l10n.paymentStatusCancelled;
    }
  }
}

extension PaymentProviderL10n on PaymentProvider {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case PaymentProvider.tbc:
        return context.l10n.paymentProviderTbc;
      case PaymentProvider.bog:
        return context.l10n.paymentProviderBog;
    }
  }
}

extension DayOfWeekL10n on DayOfWeek {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case DayOfWeek.monday:
        return context.l10n.dayMonday;
      case DayOfWeek.tuesday:
        return context.l10n.dayTuesday;
      case DayOfWeek.wednesday:
        return context.l10n.dayWednesday;
      case DayOfWeek.thursday:
        return context.l10n.dayThursday;
      case DayOfWeek.friday:
        return context.l10n.dayFriday;
      case DayOfWeek.saturday:
        return context.l10n.daySaturday;
      case DayOfWeek.sunday:
        return context.l10n.daySunday;
    }
  }
}
