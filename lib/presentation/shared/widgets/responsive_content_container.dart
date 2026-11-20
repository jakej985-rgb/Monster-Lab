import 'package:flutter/material.dart';

/// A layout container that bounds content width on desktop and tablet screens,
/// centering it cleanly and preventing oversized edge-to-edge stretching.
class ResponsiveContentContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContentContainer({
    super.key,
    required this.child,
    this.maxWidth = 1080.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
