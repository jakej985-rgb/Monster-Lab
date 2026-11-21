import 'dart:async';

import 'package:flutter/services.dart';

/// Plays lightweight system feedback sounds when sound effects are enabled.
///
/// Platform sound support varies; unsupported platforms simply no-op.
class SoundEffectsService {
  final bool enabled;

  const SoundEffectsService({required this.enabled});

  void success() => _play(SystemSoundType.click);

  void error() => _play(SystemSoundType.alert);

  void _play(SystemSoundType type) {
    if (!enabled) return;
    SystemSound.play(type).ignore();
  }
}
