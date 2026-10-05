import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// TODO: Agent 1 will add this provider
import '../../shared/providers.dart';

/// Wraps a lesson screen widget and applies immersive mode when enabled.
/// Restores system UI on dispose.
class ImmersiveLessonController extends ConsumerStatefulWidget {
  final Widget child;

  const ImmersiveLessonController({super.key, required this.child});

  @override
  ConsumerState<ImmersiveLessonController> createState() =>
      _ImmersiveLessonControllerState();
}

class _ImmersiveLessonControllerState
    extends ConsumerState<ImmersiveLessonController>
    with WidgetsBindingObserver {
  bool _immersiveActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyMode());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Always restore system UI when leaving a lesson
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _applyMode();
    }
  }

  void _applyMode() {
    // Read the current settings value
    final settings = ref.read(settingsNotifierProvider);
    if (settings.immersiveLessonMode) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      _immersiveActive = true;
    } else {
      // Normal mode — keep system UI, still use edge-to-edge for proper insets
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      _immersiveActive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for settings changes while in the lesson
    ref.listen(settingsNotifierProvider, (previous, next) {
      if (previous?.immersiveLessonMode != next.immersiveLessonMode) {
        _applyMode();
      }
    });
    return widget.child;
  }
}
