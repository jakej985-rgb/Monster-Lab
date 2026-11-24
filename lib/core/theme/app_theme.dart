import 'package:material_ui/material_ui.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Application theme configurations for Light Lab and Dark Lab modes.
abstract final class AppTheme {
  static ThemeData buildTheme(
      {required bool isDark,
      String preset = 'default',
      bool highContrast = false}) {
    final isMint = (preset == 'mint');
    final primaryColor = highContrast
        ? (isMint
            ? (isDark ? const Color(0xFF9BE36D) : const Color(0xFF2D5A16))
            : (isDark ? const Color(0xFFB9B1FF) : AppColors.primaryVioletDark))
        : (isMint
            ? (isDark ? AppColors.mintGreen : AppColors.mintGreenDark)
            : AppColors.primaryViolet);
    final secondaryColor = highContrast
        ? (isDark ? const Color(0xFF7FF5F1) : const Color(0xFF00635F))
        : AppColors.accentCyan;
    final errorColor = highContrast
        ? (isDark ? const Color(0xFFFF8A80) : const Color(0xFFB00020))
        : AppColors.danger;
    final onPrimaryColor = _onColor(primaryColor);
    final onSecondaryColor = _onColor(secondaryColor);
    final onErrorColor = _onColor(errorColor);
    final backgroundColor = highContrast
        ? (isDark ? Colors.black : Colors.white)
        : (isMint
            ? (isDark
                ? AppColors.mintBackgroundDark
                : AppColors.mintBackgroundLight)
            : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight));
    final surfaceColor = highContrast
        ? (isDark ? const Color(0xFF0A0A0A) : Colors.white)
        : (isMint
            ? (isDark ? AppColors.mintSurfaceDark : AppColors.mintSurfaceLight)
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight));
    final borderColor = highContrast
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? AppColors.mintBorderDark : AppColors.mintBorderLight);
    final onSurfaceColor = highContrast
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    final baseScheme = isDark
        ? ColorScheme.dark(
            primary: primaryColor,
            onPrimary: onPrimaryColor,
            secondary: secondaryColor,
            onSecondary: onSecondaryColor,
            surface: surfaceColor,
            onSurface: onSurfaceColor,
            error: errorColor,
            onError: onErrorColor,
          )
        : ColorScheme.light(
            primary: primaryColor,
            onPrimary: onPrimaryColor,
            secondary: secondaryColor,
            onSecondary: onSecondaryColor,
            surface: surfaceColor,
            onSurface: onSurfaceColor,
            error: errorColor,
            onError: onErrorColor,
          );
    final colorScheme = baseScheme.copyWith(
      onSurfaceVariant: highContrast
          ? (isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1F1F1F))
          : null,
      outline: highContrast ? borderColor : null,
      outlineVariant: highContrast
          ? (isDark ? const Color(0xFFC8C8C8) : const Color(0xFF3D3D3D))
          : null,
      surfaceContainerLow: highContrast
          ? (isDark ? const Color(0xFF141414) : const Color(0xFFFAFAFA))
          : null,
      surfaceContainerHighest: highContrast
          ? (isDark ? const Color(0xFF242424) : const Color(0xFFECECEC))
          : null,
    );

    final baseTextTheme =
        isDark ? AppTypography.darkTextTheme : AppTypography.lightTextTheme;
    final textTheme = highContrast
        ? baseTextTheme.apply(
            bodyColor: colorScheme.onSurface,
            displayColor: colorScheme.onSurface,
          )
        : baseTextTheme;

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
          side: BorderSide(
            color: borderColor,
            width: highContrast ? 1.5 : 1,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: highContrast ? colorScheme.outlineVariant : null,
        thickness: highContrast ? 1.5 : null,
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: colorScheme.onPrimary,
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
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: IconThemeData(color: primaryColor),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
        indicatorColor: primaryColor.withValues(alpha: 0.15),
        elevation: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  /// Picks black or white based on whichever yields the stronger WCAG contrast.
  static Color _onColor(Color background) {
    final luminance = background.computeLuminance();
    final blackContrast = (luminance + 0.05) / 0.05;
    final whiteContrast = 1.05 / (luminance + 0.05);
    return blackContrast >= whiteContrast ? Colors.black : Colors.white;
  }

  static ThemeData get lightTheme => buildTheme(isDark: false);
  static ThemeData get darkTheme => buildTheme(isDark: true);
}
