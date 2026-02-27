import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/app_colors.dart';
import 'package:moto_slot/core/design_system/app_spacing.dart';
import 'package:moto_slot/core/design_system/app_typography.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool hasBackButton;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.leading,
    this.actions,
    this.floatingActionButton,
    this.backgroundColor,
    this.hasBackButton = false,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null || leading != null || actions != null || hasBackButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                child: Row(
                  children: [
                    if (hasBackButton)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      )
                    else if (leading != null)
                      leading!
                    else
                      AppSpacing.horizontalMd,
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: AppTypography.headlineMedium,
                        ),
                      )
                    else
                      const Spacer(),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
