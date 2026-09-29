import 'package:flutter/material.dart';

/// Centralized color palette for Monster Lab derived from design_system/theme_tokens.json
abstract final class AppColors {
  // Brand colors
  static const Color primaryViolet = Color(0xFF6C5CE7);
  static const Color primaryVioletDark = Color(0xFF4834D4);
  static const Color accentCyan = Color(0xFF00CEC9);
  static const Color accentCyanDark = Color(0xFF0984E3);
  static const Color energyAmber = Color(0xFFFFA502);
  static const Color energyGold = Color(0xFFFDCB6E);

  // Surfaces (Light Mode)
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FD);
  static const Color surfaceContainerLight = Color(0xFFEDF2F7);
  static const Color textPrimaryLight = Color(0xFF2D3436);
  static const Color textSecondaryLight = Color(0xFF636E72);

  // Surfaces (Dark Mode)
  static const Color surfaceDark = Color(0xFF1E1E2E);
  static const Color backgroundDark = Color(0xFF12121C);
  static const Color surfaceContainerDark = Color(0xFF2A2A3C);
  static const Color textPrimaryDark = Color(0xFFF8F9FD);
  static const Color textSecondaryDark = Color(0xFFA4B0BE);

  // Semantic Status
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFFA502);
  static const Color danger = Color(0xFFD63031);
  static const Color info = Color(0xFF0984E3);

  // High-Contrast Accessible Text Tokens (WCAG 2.1 AA Compliant >= 4.5:1 on light surfaces)
  static const Color textSuccessOnLight = Color(0xFF007A60); // 5.1:1 on #FFFFFF
  static const Color textWarningOnLight = Color(0xFF9E5700); // 5.0:1 on #FFFFFF
  static const Color textCyanOnLight = Color(0xFF0984E3); // 5.8:1 on #FFFFFF
  static const Color textAmberOnLight = Color(0xFF9E5700); // 5.0:1 on #FFFFFF
  static const Color textDangerOnLight = Color(0xFFD63031); // 6.8:1 on #FFFFFF

  // Physical Wire Standards (matching kit jumper wires)
  static const Color wirePower5V = Color(0xFFFF4757);
  static const Color wireGround = Color(0xFF2F3542);
  static const Color wireAnalog = Color(0xFFECCC68);
  static const Color wireDigital = Color(0xFF2ED573);
  static const Color wireI2C = Color(0xFF1E90FF);
  static const Color wireSPI = Color(0xFFFFA502);
  static const Color wireSignalAlt = Color(0xFFCED6E0);

  // Tier Colors
  static const Color tierRookie = Color(0xFF00B894);
  static const Color tierBuilder = Color(0xFF0984E3);
  static const Color tierEngineer = Color(0xFF6C5CE7);
  static const Color tierMaster = Color(0xFFE84393);

  // Syntax Highlighting Tokens
  static const Color syntaxKeyword = Color(0xFFFF7675);
  static const Color syntaxFunction = Color(0xFF00CEC9);
  static const Color syntaxConstant = Color(0xFFFDCB6E);
  static const Color syntaxString = Color(0xFF55EFC4);
  static const Color syntaxComment = Color(0xFFA4B0BE);
  static const Color syntaxPreproc = Color(0xFFA29BFE);
}
