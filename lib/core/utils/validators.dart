import 'package:flutter/material.dart';
import 'package:moto_slot/l10n/generated/app_localizations.dart';

class Validators {
  Validators._();

  static String? Function(String?) emailValidator(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return l10n.validatorEmailRequired;
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return l10n.validatorEmailInvalid;
      }
      return null;
    };
  }

  static String? Function(String?) passwordValidator(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return (String? value) {
      if (value == null || value.isEmpty) return l10n.validatorPasswordRequired;
      if (value.length < 6) return l10n.validatorPasswordMinLength;
      return null;
    };
  }

  static String? Function(String?) nameValidator(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return (String? value) {
      if (value == null || value.trim().isEmpty) return l10n.validatorNameRequired;
      if (value.trim().length < 2) return l10n.validatorNameMinLength;
      return null;
    };
  }

  static String? Function(String?) phoneValidator(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return (String? value) {
      if (value == null || value.trim().isEmpty) return l10n.validatorPhoneRequired;
      final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
      if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
        return l10n.validatorPhoneInvalid;
      }
      return null;
    };
  }

  static String? Function(String?) confirmPasswordValidator(
      BuildContext context, String password) {
    final l10n = AppLocalizations.of(context);
    return (String? value) {
      if (value == null || value.isEmpty) {
        return l10n.validatorConfirmPasswordRequired;
      }
      if (value != password) return l10n.validatorPasswordsDoNotMatch;
      return null;
    };
  }
}
