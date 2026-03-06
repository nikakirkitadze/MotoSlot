import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_slot/core/design_system/design_system.dart';
import 'package:moto_slot/core/locale/l10n_extension.dart';

class EmailLinkSentScreen extends StatelessWidget {
  const EmailLinkSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasBackButton: true,
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 48),
            FadeInWidget(
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    size: 40,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
            AppSpacing.verticalLg,
            FadeInWidget(
              delay: const Duration(milliseconds: 100),
              child: Text(
                context.l10n.checkYourEmail,
                style: AppTypography.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.verticalSm,
            FadeInWidget(
              delay: const Duration(milliseconds: 150),
              child: Text(
                context.l10n.emailLinkSentMessage,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            AppSpacing.verticalXl,
            FadeInWidget(
              delay: const Duration(milliseconds: 200),
              child: PrimaryButton(
                text: context.l10n.backToLogin,
                onPressed: () => context.go('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
