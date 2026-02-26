import 'package:flutter/widgets.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';

String localizeMessage(BuildContext context, String message) {
  final l10n = context.l10n;

  // Handle parameterized messages with "key:param" format
  if (message.startsWith('bookingCreatedSmsSent:')) {
    final phone = message.substring('bookingCreatedSmsSent:'.length);
    return l10n.bookingCreatedSmsSent(phone);
  }

  if (message.startsWith('slotsGenerated:')) {
    final count = message.substring('slotsGenerated:'.length);
    return l10n.slotsGenerated(int.parse(count));
  }

  if (message.startsWith('failedToLoadSlotsError:')) {
    final error = message.substring('failedToLoadSlotsError:'.length);
    return l10n.failedToLoadSlotsError(error);
  }

  // Handle simple key-based messages
  final Map<String, String> messageMap = {
    'settingsSaved': l10n.settingsSaved,
    'configureSettingsFirst': l10n.configureSettingsFirst,
    'dateBlocked': l10n.dateBlocked,
    'dateUnblocked': l10n.dateUnblocked,
    'bookingCancelled': l10n.bookingCancelled,
    'bookingMarkedCompleted': l10n.bookingMarkedCompleted,
    'failedToCreateBooking': l10n.failedToCreateBooking,
    'failedToLoadBookings': l10n.failedToLoadBookings,
    'failedToLoadSlots': l10n.failedToLoadSlots,
    'failedToLoadAvailableSlots': l10n.failedToLoadAvailableSlots,
    'registrationFailed': l10n.registrationFailed,
    'resetEmailFailed': l10n.resetEmailFailed,
    'paymentVerificationFailed': l10n.paymentVerificationFailed,
    'paymentNotCompleted': l10n.paymentNotCompleted,
    'paymentVerificationError': l10n.paymentVerificationError,
    'unexpectedError': l10n.unexpectedError,
  };

  return messageMap[message] ?? message;
}
