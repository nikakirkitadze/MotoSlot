import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moto_slot/core/design_system/app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get _base => GoogleFonts.inter();

  // Display
  static TextStyle get displayLarge =>
      _base.copyWith(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2);

  static TextStyle get displayMedium =>
      _base.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.2);

  // Headings
  static TextStyle get headlineLarge =>
      _base.copyWith(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3);

  static TextStyle get headlineMedium =>
      _base.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.3);

  static TextStyle get headlineSmall =>
      _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);

  // Title
  static TextStyle get titleLarge =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);

  static TextStyle get titleMedium =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);

  static TextStyle get titleSmall =>
      _base.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary, height: 1.4);

  // Body
  static TextStyle get bodyLarge =>
      _base.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5);

  static TextStyle get bodyMedium =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);

  static TextStyle get bodySmall =>
      _base.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5);

  // Label
  static TextStyle get labelLarge =>
      _base.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4);

  static TextStyle get labelMedium =>
      _base.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4);

  static TextStyle get labelSmall =>
      _base.copyWith(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textHint, height: 1.4);

  // Button
  static TextStyle get button =>
      _base.copyWith(fontSize: 15, fontWeight: FontWeight.w600, height: 1.2);

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
