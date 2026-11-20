import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Application theme configurations for Light Lab and Dark Lab modes.
abstract final class AppTheme {
  static ThemeData buildTheme(
      {required bool isDark, String preset = 'default'}) {
    final isMint = (preset == 'mint');
    final primaryColor = isMint
        ? (isDark ? AppColors.mintGreen : AppColors.mintGreenDark)
        : AppColors.primaryViolet;
    final backgroundColor = isMint
        ? (isDark
            ? AppColors.mintBackgroundDark
            : AppColors.mintBackgroundLight)
        : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight);
    final surfaceColor = isMint
        ? (isDark ? AppColors.mintSurfaceDark : AppColors.mintSurfaceLight)
        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final borderColor =
        isDark ? AppColors.mintBorderDark : AppColors.mintBorderLight;

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: AppColors.accentCyan,
            onSecondary: Colors.black,
            surface: surfaceColor,
            onSurface: AppColors.textPrimaryDark,
            error: AppColors.danger,
            onError: Colors.white,
          )
        : ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            secondary: AppColors.accentCyan,
            onSecondary: AppColors.textPrimaryLight,
            surface: surfaceColor,
            onSurface: AppColors.textPrimaryLight,
            error: AppColors.danger,
            onError: Colors.white,
          );

    final textTheme =
        isDark ? AppTypography.darkTextTheme : AppTypography.lightTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: colorScheme,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 1,
        shadowColor: const Color(0x0F000000),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: borderColor, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(96, 38),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14),
          elevation: 1,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          minimumSize: const Size(96, 38),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(true),
        thickness: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered) ? 8.0 : 6.0,
        ),
        radius: const Radius.circular(3),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return isDark ? const Color(0xFF6B7280) : const Color(0xFF4B5563);
          }
          if (states.contains(WidgetState.hovered)) {
            return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
          }
          return (isDark ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF))
              .withValues(alpha: 0.6);
        }),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(surfaceColor),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(3),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: borderColor, width: 1),
            ),
          ),
        ),
      ),
      menuBarTheme: MenuBarThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor:
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: IconThemeData(color: primaryColor),
        unselectedIconTheme: IconThemeData(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight),
        selectedLabelTextStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          fontSize: 12,
        ),
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        elevation: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get lightTheme => buildTheme(isDark: false);
  static ThemeData get darkTheme => buildTheme(isDark: true);
}
