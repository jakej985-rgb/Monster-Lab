import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MonsterCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double borderRadius;
  final Border? border;
  final String? semanticLabel;
  final bool mergeSemantics;

  const MonsterCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.color,
    this.borderRadius = 16.0,
    this.border,
    this.semanticLabel,
    this.mergeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardTheme.color ?? AppColors.surfaceLight;

    Widget card = Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: const [
          BoxShadow(
            color: Color(0x146C5CE7),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );

    if (mergeSemantics) {
      card = MergeSemantics(child: card);
    }

    if (semanticLabel != null) {
      card = Semantics(
        label: semanticLabel,
        button: onTap != null,
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }
}
