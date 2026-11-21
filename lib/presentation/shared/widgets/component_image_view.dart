import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ComponentImageView extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String category;
  final String? semanticLabel;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const ComponentImageView({
    super.key,
    this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.category = 'sensor',
    this.semanticLabel,
    this.borderRadius,
    this.backgroundColor,
  });

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'microcontroller':
        return Icons.developer_board;
      case 'sensor':
        return Icons.sensors;
      case 'actuator':
        return Icons.precision_manufacturing;
      case 'display':
        return Icons.tv;
      case 'communication':
        return Icons.wifi;
      case 'switch':
        return Icons.toggle_on;
      case 'passive':
        return Icons.tune;
      default:
        return Icons.memory;
    }
  }

  static Color getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case 'microcontroller':
        return AppColors.primaryViolet;
      case 'sensor':
        return AppColors.accentCyan;
      case 'actuator':
        return AppColors.success;
      case 'display':
        return AppColors.primaryViolet;
      case 'communication':
        return AppColors.energyAmber;
      case 'switch':
        return AppColors.warning;
      case 'passive':
        return colorScheme.onSurfaceVariant;
      default:
        return AppColors.primaryViolet;
    }
  }

  Widget _buildFallback(BuildContext context, [double? iconSize]) {
    final catColor = getCategoryColor(category, Theme.of(context).colorScheme);
    final size = iconSize ??
        ((width != null && height != null)
            ? (width! < height! ? width! * 0.5 : height! * 0.5)
            : 32.0);

    return Center(
      child: Icon(
        getCategoryIcon(category),
        size: size,
        color: catColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveBg = backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    Widget content;
    final path = imagePath;
    if (path != null && path.trim().isNotEmpty) {
      content = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        excludeFromSemantics: true,
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    } else {
      content = _buildFallback(context);
    }

    return Semantics(
      label: semanticLabel ?? 'Component image',
      image: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: effectiveRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: content,
      ),
    );
  }
}
