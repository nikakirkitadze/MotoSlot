import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/design_system.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? action;
  final Widget? customIllustration;

  const AppEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.action,
    this.customIllustration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customIllustration != null)
              customIllustration!
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 40,
                  color: AppColors.primary.withValues(alpha: 0.6),
                ),
              ),
            AppSpacing.verticalLg,
            Text(
              title,
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.verticalSm,
              Text(
                subtitle!,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              AppSpacing.verticalLg,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Calendar + helmet illustration for booking empty states
class BookingEmptyIllustration extends StatelessWidget {
  const BookingEmptyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 80,
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
          Positioned(
            bottom: 0,
            child: Icon(
              Icons.sports_motorsports_outlined,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
