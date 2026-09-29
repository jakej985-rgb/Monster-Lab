import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum MonsterButtonVariant { primary, secondary }

class MonsterButton extends StatelessWidget {
  final String label;
  final String? semanticLabel;
  final VoidCallback? onPressed;
  final MonsterButtonVariant variant;
  final IconData? icon;
  final double minHeight;

  const MonsterButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
    this.variant = MonsterButtonVariant.primary,
    this.icon,
    this.minHeight = 52.0, // Kid-friendly minimum touch target
  });

  const MonsterButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
    this.icon,
    this.minHeight = 48.0,
  }) : variant = MonsterButtonVariant.secondary;

  @override
  Widget build(BuildContext context) {
    Widget button;
    if (variant == MonsterButtonVariant.secondary) {
      button = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(120, minHeight),
          side: const BorderSide(color: AppColors.primaryViolet, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: _buildContent(AppColors.primaryViolet),
      );
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryViolet,
          foregroundColor: Colors.white,
          minimumSize: Size(120, minHeight),
          elevation: 3,
          shadowColor: AppColors.primaryVioletDark.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: _buildContent(Colors.white),
      );
    }

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel ?? label,
      child: button,
    );
  }

  Widget _buildContent(Color textColor) {
    if (icon == null) {
      return Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: textColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
