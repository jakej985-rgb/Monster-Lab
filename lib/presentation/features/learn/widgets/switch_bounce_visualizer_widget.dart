import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// High-speed microsecond oscilloscope demonstrating mechanical contact switch bounce
/// and software debounce delay stabilization.
class SwitchBounceVisualizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SwitchBounceVisualizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SwitchBounceVisualizerWidget> createState() =>
      _SwitchBounceVisualizerWidgetState();
}

class _SwitchBounceVisualizerWidgetState
    extends State<SwitchBounceVisualizerWidget> {
  // false = raw contact bounce, true = software debounced
  bool _isDebounceEnabled = false;
  double _debounceMs = 25.0;

  int _totalPhysicalPresses = 0;
  int _registeredCpuTriggers = 0;
  bool _isCurrentlyAnimating = false;
  List<double> _waveformPoints = [];

  bool _hasTestedRaw = false;
  bool _hasTestedDebounced = false;
  bool _hasCompleted = false;

  void _pressButton() {
    if (_isCurrentlyAnimating) return;
    setState(() {
      _isCurrentlyAnimating = true;
      _totalPhysicalPresses++;

      if (!_isDebounceEnabled) {
        // Raw: 6 to 9 false triggers per push due to contact chatter
        const bounces = 7;
        _registeredCpuTriggers += bounces;
        _hasTestedRaw = true;
        _waveformPoints = [
          5.0, 5.0, // Initial unpressed 5V
          0.0, 5.0, 0.0, 5.0, 0.0, 5.0, 0.0, 4.0, 0.0, // Chattering bounces
          0.0, 0.0, 0.0, 0.0, // Settled closed 0V
        ];
      } else {
        // Debounced: exactly 1 registered trigger
        _registeredCpuTriggers += 1;
        _hasTestedDebounced = true;
        _waveformPoints = [
          5.0, 5.0, // Initial 5V
          5.0, 5.0, // Ignored during debounce window
          0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, // Clean stabilized 0V
        ];
      }

      _checkCompletion();
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isCurrentlyAnimating = false;
        });
      }
    });
  }

  void _toggleDebounceMode() {
    setState(() {
      _isDebounceEnabled = !_isDebounceEnabled;
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_hasTestedRaw && _hasTestedDebounced && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Switch Bounce Visualizer: Microsecond Oscilloscope';

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
              if (_hasCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'DEBOUNCE MASTERED',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'When two metal leaves inside a mechanical switch collide, they vibrate and bounce elastically for 1–15 milliseconds. '
            'Because the 16MHz Arduino executes an instruction every 62.5ns, it counts every single microsecond bounce!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Control row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('switch_bounce_press_button'),
                  onPressed: _pressButton,
                  icon: const Icon(Icons.touch_app, size: 20),
                  label: Text(_isCurrentlyAnimating
                      ? 'Closing Contacts...'
                      : 'Press Tactile Button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.energyAmber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('toggle_debounce_mode'),
                  onPressed: _toggleDebounceMode,
                  icon: Icon(
                    _isDebounceEnabled
                        ? Icons.filter_alt
                        : Icons.filter_alt_off,
                    color: _isDebounceEnabled
                        ? AppColors.success
                        : AppColors.danger,
                    size: 20,
                  ),
                  label: Text(
                    _isDebounceEnabled ? 'Debounce: ON' : 'Debounce: OFF',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: _isDebounceEnabled
                          ? AppColors.success
                          : AppColors.danger,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Slider for debounce delay
          if (_isDebounceEnabled) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Software Debounce Window:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                Text(
                  '${_debounceMs.toInt()} ms',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ],
            ),
            Slider(
              key: const Key('debounce_slider'),
              value: _debounceMs,
              min: 5,
              max: 50,
              divisions: 9,
              activeColor: AppColors.accentCyan,
              onChanged: (val) {
                setState(() {
                  _debounceMs = val;
                });
              },
            ),
          ],
          const SizedBox(height: 8),

          // Oscilloscope Screen
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isDebounceEnabled
                    ? AppColors.success.withValues(alpha: 0.5)
                    : AppColors.danger.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _isDebounceEnabled
                            ? 'DSO: CLEAN TRANSITION'
                            : 'DSO: CONTACT CHATTER',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 0.6,
                          fontFamily: 'monospace',
                          color: _isDebounceEnabled
                              ? AppColors.success
                              : AppColors.danger,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '500 µs/div',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Simulated Waveform Display
                SizedBox(
                  height: 70,
                  child: CustomPaint(
                    painter: _OscilloscopePainter(
                      points: _waveformPoints,
                      isDebounced: _isDebounceEnabled,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Comparison Counters
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCounterBadge(
                          label: 'Clicks',
                          value: '$_totalPhysicalPresses',
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: _buildCounterBadge(
                          label: 'CPU Triggers',
                          value: '$_registeredCpuTriggers',
                          color: _isDebounceEnabled
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                      ),
                      Expanded(
                        child: _buildCounterBadge(
                          label: 'Glitch Ratio',
                          value: _totalPhysicalPresses == 0
                              ? '0x'
                              : '${(_registeredCpuTriggers / _totalPhysicalPresses).toStringAsFixed(1)}x',
                          color: _isDebounceEnabled
                              ? AppColors.success
                              : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Analysis banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (_isDebounceEnabled ? AppColors.success : AppColors.danger)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    (_isDebounceEnabled ? AppColors.success : AppColors.danger)
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _isDebounceEnabled
                  ? 'Debounce Active: After the first falling edge, subsequent spikes within the ${_debounceMs.toInt()}ms window are ignored. Single physical click = exactly 1 event!'
                  : 'Debounce Inactive: Each microsecond bounce triggers your sketch code. A counter or toggle will randomly flip 5–10 times on a single press!',
              style: TextStyle(
                fontSize: 11,
                color:
                    _isDebounceEnabled ? AppColors.success : AppColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterBadge({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondaryDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _OscilloscopePainter extends CustomPainter {
  final List<double> points;
  final bool isDebounced;

  _OscilloscopePainter({
    required this.points,
    required this.isDebounced,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0;

    // Grid lines
    for (double x = 0; x < size.width; x += size.width / 6) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (points.isEmpty) {
      // Idle line at 5V (top)
      final idlePaint = Paint()
        ..color = isDebounced ? AppColors.accentCyan : AppColors.danger
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(0, size.height * 0.2),
        Offset(size.width, size.height * 0.2),
        idlePaint,
      );
      return;
    }

    final wavePaint = Paint()
      ..color = isDebounced ? AppColors.accentCyan : AppColors.danger
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      // 5V -> top (0.2 height), 0V -> bottom (0.8 height)
      final y = size.height * (0.8 - (points[i] / 5.0) * 0.6);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        // Square wave step
        final prevY = size.height * (0.8 - (points[i - 1] / 5.0) * 0.6);
        path.lineTo(x, prevY);
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _OscilloscopePainter oldDelegate) => true;
}
