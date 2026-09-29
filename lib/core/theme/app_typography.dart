import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography hierarchy for Monster Lab matching theme_tokens.json
abstract final class AppTypography {
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 34,
      height: 42 / 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: AppColors.textPrimaryLight,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: AppColors.textPrimaryLight,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.textPrimaryLight,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      height: 24 / 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.textPrimaryLight,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.textPrimaryLight,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.textSecondaryLight,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      height: 22 / 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      color: AppColors.textPrimaryLight,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      height: 18 / 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textSecondaryLight,
    ),
  );

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 34,
      height: 42 / 34,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: AppColors.textPrimaryDark,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: AppColors.textPrimaryDark,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.textPrimaryDark,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      height: 24 / 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: AppColors.textPrimaryDark,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: AppColors.textSecondaryDark,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      height: 22 / 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      color: AppColors.textPrimaryDark,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      height: 18 / 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textSecondaryDark,
    ),
  );

  static const TextStyle codeLarge = TextStyle(
    fontFamily: 'monospace',
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimaryDark,
  );

  static const TextStyle codeMedium = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimaryDark,
  );
}
