import 'package:flutter/material.dart';
import 'package:moto_slot/core/design_system/design_system.dart';

enum AppLogoVariant { iconWithText, iconWithMS }

class AppLogo extends StatelessWidget {
  final AppLogoVariant variant;
  final double iconSize;

  const AppLogo({
    super.key,
    required this.variant,
    this.iconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppLogoVariant.iconWithText => _buildIconWithText(),
      AppLogoVariant.iconWithMS => _buildIconWithMS(),
    };
  }

  Widget _buildIconWithText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.sports_motorsports_outlined,
          size: iconSize,
          color: AppColors.navy,
        ),
        const SizedBox(width: 8),
        Text(
          'MotoSlot',
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildIconWithMS() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.sports_motorsports,
              size: iconSize * 1.5,
              color: AppColors.primary,
            ),
            Positioned(
              bottom: iconSize * 0.15,
              child: Text(
                'MS',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: iconSize * 0.28,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
