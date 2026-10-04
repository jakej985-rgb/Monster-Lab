import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

enum NoiseFilterMode { floating, grounded, rawPot, smoothedEma }

/// Interactive floating analog input noise and software filtering laboratory.
/// Demonstrates high-impedance CMOS antenna behavior (picking up 60Hz mains EMI)
/// versus reference grounding and Exponential Moving Average (EMA) software smoothing.
class AnalogReadNoiseFilterWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const AnalogReadNoiseFilterWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<AnalogReadNoiseFilterWidget> createState() =>
      _AnalogReadNoiseFilterWidgetState();
}

class _AnalogReadNoiseFilterWidgetState
    extends State<AnalogReadNoiseFilterWidget> {
  NoiseFilterMode _mode = NoiseFilterMode.floating;
  final Set<NoiseFilterMode> _inspectedModes = {};
  bool _hasCompleted = false;

  final Random _rng = Random(42);

  List<int> _generateSamples(NoiseFilterMode mode) {
    final list = <int>[];
    switch (mode) {
      case NoiseFilterMode.floating:
        // Wild 60Hz sinusoid + erratic random spikes
        for (int i = 0; i < 24; i++) {
          final sine = sin(i * 0.8) * 280.0;
          final noise = (_rng.nextDouble() - 0.5) * 350.0;
          final val = (512.0 + sine + noise).round().clamp(15, 1010);
          list.add(val);
        }
        break;
      case NoiseFilterMode.grounded:
        // Rock-solid 0 counts
        for (int i = 0; i < 24; i++) {
          list.add(0);
        }
        break;
      case NoiseFilterMode.rawPot:
        // Midpoint 512 ± 4 counts of thermal noise
        for (int i = 0; i < 24; i++) {
          final noise = _rng.nextInt(9) - 4;
          list.add((512 + noise).clamp(0, 1023));
        }
        break;
      case NoiseFilterMode.smoothedEma:
        // Running average smooth curve
        double ema = 512.0;
        for (int i = 0; i < 24; i++) {
          final raw = 512.0 + (_rng.nextInt(11) - 5);
          ema = (0.2 * raw) + (0.8 * ema);
          list.add(ema.round());
        }
        break;
    }
    return list;
  }

  void _selectMode(NoiseFilterMode mode) {
    setState(() {
      _mode = mode;
      _inspectedModes.add(mode);
      if (_inspectedModes.length >= 3 && !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _inspectedModes.add(_mode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Floating Analog Input Noise & Digital Filtering Lab';

    final samples = _generateSamples(_mode);
    final latestVal = samples.last;
    final latestVolt = (latestVal * 5.0) / 1023.0;

    // Variance estimation
    final mean = samples.reduce((a, b) => a + b) / samples.length;
    final variance =
        samples.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
            samples.length;
    final stdDev = sqrt(variance);

    final isFloating = _mode == NoiseFilterMode.floating;
    final isGrounded = _mode == NoiseFilterMode.grounded;
    final isSmoothed = _mode == NoiseFilterMode.smoothedEma;

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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isFloating
                      ? AppColors.danger.withValues(alpha: 0.2)
                      : isSmoothed || isGrounded
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.energyAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFloating
                        ? AppColors.danger
                        : isSmoothed || isGrounded
                            ? AppColors.success
                            : AppColors.energyAmber,
                  ),
                ),
                child: Text(
                  isFloating
                      ? 'ERRATIC NOISE (Jitter: ±${stdDev.round()})'
                      : isGrounded
                          ? 'GND ZERO (0.00V)'
                          : isSmoothed
                              ? 'SMOOTHED (EMA FILTER)'
                              : 'RAW SENSOR (±${stdDev.round()})',
                  style: TextStyle(
                    color: isFloating
                        ? AppColors.danger
                        : isSmoothed || isGrounded
                            ? AppColors.success
                            : AppColors.energyAmber,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'Because the ATmega328P ADC has an input impedance exceeding 100 MΩ, an unconnected analog pin '
            'acts like an antenna, picking up 60Hz electromagnetic mains hum and static electricity!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Oscilloscope Waveform Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFloating
                    ? AppColors.danger.withValues(alpha: 0.5)
                    : AppColors.surfaceContainerDark,
              ),
            ),
            child: Column(
              children: [
                // Live stats header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live A0 Reading: $latestVal (${latestVolt.toStringAsFixed(2)} V)',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Noise StdDev: σ = ${stdDev.toStringAsFixed(1)} counts',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isFloating
                            ? AppColors.danger
                            : AppColors.accentCyan,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Oscilloscope Screen
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: _WaveformPainter(
                      samples: samples,
                      lineColor: isFloating
                          ? AppColors.danger
                          : isSmoothed
                              ? AppColors.success
                              : AppColors.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Diagnostic Explanation Banner
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isFloating
                            ? Icons.wifi_tethering_error
                            : isGrounded
                                ? Icons.electric_bolt
                                : isSmoothed
                                    ? Icons.filter_alt
                                    : Icons.analytics,
                        color: isFloating
                            ? AppColors.danger
                            : isSmoothed
                                ? AppColors.success
                                : AppColors.accentCyan,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isFloating
                              ? 'FLOATING PIN TRAP: Without an electrical connection, Pin A0 drifts unpredictably. Never leave unused sensing pins floating in production firmware!'
                              : isGrounded
                                  ? 'TIED TO GND: Directly connected to the 0V reference. Reading stays locked at count 0 with 0 mV variance.'
                                  : isSmoothed
                                      ? 'DIGITAL FILTER: Running Exponential Moving Average (EMA: val = 0.2*raw + 0.8*prev) removes thermal jitter, yielding stable robotic control.'
                                      : 'RAW POTENTIOMETER: Small ±4 count thermal noise exists naturally on physical resistors before software averaging.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Mode Selection Chips
          const Text(
            'Select Signal Condition to Test:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('noise_filter_mode_floating'),
                label: const Text('1. Floating Pin (Antenna Noise)'),
                backgroundColor: _mode == NoiseFilterMode.floating
                    ? AppColors.danger.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.danger),
                onPressed: () => _selectMode(NoiseFilterMode.floating),
              ),
              ActionChip(
                key: const Key('noise_filter_mode_ground'),
                label: const Text('2. Tied to GND (0V Stable)'),
                backgroundColor: _mode == NoiseFilterMode.grounded
                    ? AppColors.accentCyan.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _selectMode(NoiseFilterMode.grounded),
              ),
              ActionChip(
                key: const Key('noise_filter_mode_pot'),
                label: const Text('3. Raw 10k Potentiometer'),
                backgroundColor: _mode == NoiseFilterMode.rawPot
                    ? AppColors.energyAmber.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _selectMode(NoiseFilterMode.rawPot),
              ),
              ActionChip(
                key: const Key('noise_filter_mode_smoothed'),
                label: const Text('4. Filtered EMA Software'),
                backgroundColor: _mode == NoiseFilterMode.smoothedEma
                    ? AppColors.success.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.success),
                onPressed: () => _selectMode(NoiseFilterMode.smoothedEma),
              ),
            ],
          ),

          if (_hasCompleted) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Analog Noise & Filtering Mastery Verified! Tested ${_inspectedModes.length} input states.',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<int> samples;
  final Color lineColor;

  _WaveformPainter({required this.samples, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade900
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (int i = 1; i <= 4; i++) {
      final y = (size.height / 5) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (samples.length < 2) return;

    final path = Path();
    final dx = size.width / (samples.length - 1);

    for (int i = 0; i < samples.length; i++) {
      final normY = 1.0 - (samples[i] / 1023.0).clamp(0.0, 1.0);
      final x = i * dx;
      final y = normY * (size.height - 10) + 5;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final wavePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, wavePaint);

    // Draw sample dots
    final dotPaint = Paint()..color = Colors.white;
    for (int i = 0; i < samples.length; i++) {
      final normY = 1.0 - (samples[i] / 1023.0).clamp(0.0, 1.0);
      final x = i * dx;
      final y = normY * (size.height - 10) + 5;
      canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) => true;
}
