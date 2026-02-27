import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/app_colors.dart';
import 'package:moto_slot/core/design_system/app_radius.dart';
import 'package:moto_slot/core/design_system/app_shadows.dart';
import 'package:moto_slot/core/design_system/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool hasBorder;
  final bool hasShadow;
  final Color? color;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.hasBorder = true,
    this.hasShadow = true,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? AppSpacing.paddingAllMd,
        decoration: BoxDecoration(
          color: color ?? AppColors.surface,
          borderRadius: borderRadius ?? AppRadius.borderRadiusLg,
          border: hasBorder ? Border.all(color: AppColors.border) : null,
          boxShadow: hasShadow ? AppShadows.sm : null,
        ),
        child: child,
      ),
    );
  }
}
