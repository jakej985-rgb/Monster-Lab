import 'package:flutter/material.dart';
import 'full_screen_image_viewer.dart';

class ExpandableLessonImage extends StatelessWidget {
  final String assetPath;
  final String semanticsLabel;
  final String? caption;
  final bool allowExpand;

  const ExpandableLessonImage({
    super.key,
    required this.assetPath,
    required this.semanticsLabel,
    this.caption,
    this.allowExpand = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = LayoutBuilder(
      builder: (context, constraints) {
        return Image.asset(
          assetPath,
          fit: BoxFit.fitWidth,
          width: constraints.maxWidth,
        );
      },
    );

    Widget content = Stack(
      children: [
        imageWidget,
        if (allowExpand)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.fullscreen, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Tap to expand',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    content = Semantics(
      label: semanticsLabel,
      child: GestureDetector(
        onTap: allowExpand
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImageViewer(
                      assetPath: assetPath,
                      semanticsLabel: semanticsLabel,
                      caption: caption,
                    ),
                  ),
                );
              }
            : null,
        child: content,
      ),
    );

    if (caption != null && caption!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          const SizedBox(height: 8),
          Text(
            caption!,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return content;
  }
}
