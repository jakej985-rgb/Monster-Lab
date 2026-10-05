import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String assetPath;
  final String semanticsLabel;
  final String? caption;

  const FullScreenImageViewer({
    super.key,
    required this.assetPath,
    required this.semanticsLabel,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Semantics(
          label: semanticsLabel,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              if (caption != null && caption!.isNotEmpty)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Text(
                    caption!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
