import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';
import 'package:moto_slot/modules/auth/presentation/cubit/auth_cubit.dart';

class AppSignOutDialog {
  static Future<void> showAsDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
        backgroundColor: AppColors.surface,
        title: Text(
          context.l10n.signOutConfirmTitle,
          style: AppTypography.headlineMedium.copyWith(color: AppColors.navy),
          textAlign: TextAlign.center,
        ),
        content: Text(
          context.l10n.signOutMessage,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedAppButton(
                  text: context.l10n.cancel,
                  color: AppColors.navy,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NavyButton(
                  text: context.l10n.signOut,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.read<AuthCubit>().signOut();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> showAsBottomSheet(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.signOutConfirmTitle,
              style: AppTypography.headlineMedium.copyWith(color: AppColors.navy),
            ),
            AppSpacing.verticalMd,
            Text(
              context.l10n.signOutMessage,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalLg,
            NavyButton(
              text: context.l10n.signOut,
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthCubit>().signOut();
              },
            ),
            AppSpacing.verticalSm,
            GhostButton(
              text: context.l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
