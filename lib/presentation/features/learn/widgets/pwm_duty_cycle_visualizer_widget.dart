import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive 490Hz PWM duty cycle oscilloscope simulator.
/// Demonstrates 8-bit analogWrite(0–255) values, period T (~2.04 ms),
/// high-time vs low-time pulse durations, and perceived LED photon flux.
class PwmDutyCycleVisualizerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const PwmDutyCycleVisualizerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<PwmDutyCycleVisualizerWidget> createState() =>
      _PwmDutyCycleVisualizerWidgetState();
}

class _PwmDutyCycleVisualizerWidgetState
    extends State<PwmDutyCycleVisualizerWidget> {
  double _pwmValue = 127.0; // 0 to 255
  final Set<int> _testedPresets = {};
  bool _hasCompleted = false;

  static const double _frequencyHz = 490.0;
  static const double _periodMs = (1.0 / _frequencyHz) * 1000.0; // ~2.0408 ms

  double get _dutyCyclePct => (_pwmValue / 255.0) * 100.0;
  double get _tHighMs => (_dutyCyclePct / 100.0) * _periodMs;
  double get _tLowMs => _periodMs - _tHighMs;
  double get _vAverage => 5.0 * (_dutyCyclePct / 100.0);

  void _checkCompletion() {
    _testedPresets.add((_pwmValue / 60).round());
    if (_testedPresets.length >= 3 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setValue(double val) {
    setState(() {
      _pwmValue = val.clamp(0.0, 255.0);
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    _checkCompletion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        '490 Hz PWM Duty Cycle & Oscilloscope Simulator';

    final pwm = _pwmValue.round();
    final duty = _dutyCyclePct;
    final tHigh = _tHighMs;
    final tLow = _tLowMs;
    final vAvg = _vAverage;

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
                  color: AppColors.accentCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentCyan),
                ),
                child: Text(
                  '${duty.toStringAsFixed(0)}% DUTY CYCLE',
                  style: const TextStyle(
                    color: AppColors.accentCyan,
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
            'The ATmega328P cannot produce true variable voltages on digital pins. Instead, it pulses at 490 Hz. '
            'The ratio of ON time to total cycle time (duty cycle) determines average voltage and perceived brightness.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Oscilloscope Screen Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                // Oscilloscope Screen
                Container(
                  height: 110,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: CustomPaint(
                    size: const Size(double.infinity, 110),
                    painter: _PwmWavePainter(
                      dutyCycleRatio: duty / 100.0,
                      waveColor: AppColors.accentCyan,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Oscilloscope Metrics Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricCol(
                      label: 'Period (T)',
                      value: '${_periodMs.toStringAsFixed(2)} ms',
                      color: Colors.white,
                    ),
                    _buildMetricCol(
                      label: 'T_HIGH (5V)',
                      value: '${tHigh.toStringAsFixed(2)} ms',
                      color: AppColors.accentCyan,
                    ),
                    _buildMetricCol(
                      label: 'T_LOW (0V)',
                      value: '${tLow.toStringAsFixed(2)} ms',
                      color: AppColors.textSecondaryDark,
                    ),
                    _buildMetricCol(
                      label: 'V_Average',
                      value: '${vAvg.toStringAsFixed(2)} V',
                      color: AppColors.energyAmber,
                    ),
                  ],
                ),
                const Divider(
                    height: 20, color: AppColors.surfaceContainerDark),

                // Simulated LED Glow Preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.energyAmber
                            .withValues(alpha: (duty / 100.0).clamp(0.05, 1.0)),
                        boxShadow: duty > 5
                            ? [
                                BoxShadow(
                                  color: AppColors.energyAmber
                                      .withValues(alpha: (duty / 100.0) * 0.7),
                                  blurRadius: 14,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: const Center(
                        child: Icon(Icons.lightbulb,
                            size: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Perceived LED Brightness: ${duty.round()}% (analogWrite: $pwm / 255)',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider for PWM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Adjust analogWrite() Value:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '$pwm (8-bit count)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('pwm_duty_slider'),
            value: _pwmValue,
            min: 0.0,
            max: 255.0,
            divisions: 255,
            activeColor: AppColors.accentCyan,
            onChanged: (val) => _setValue(val),
          ),
          const SizedBox(height: 8),

          // Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('pwm_preset_0'),
                label: const Text('0 (0% OFF)'),
                onPressed: () => _setValue(0),
              ),
              ActionChip(
                key: const Key('pwm_preset_64'),
                label: const Text('64 (25% Quarter)'),
                onPressed: () => _setValue(64),
              ),
              ActionChip(
                key: const Key('pwm_preset_127'),
                label: const Text('127 (50% Half)'),
                onPressed: () => _setValue(127),
              ),
              ActionChip(
                key: const Key('pwm_preset_191'),
                label: const Text('191 (75% Three-Quarter)'),
                onPressed: () => _setValue(191),
              ),
              ActionChip(
                key: const Key('pwm_preset_255'),
                label: const Text('255 (100% Full)'),
                onPressed: () => _setValue(255),
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
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'PWM Duty Cycle Mastery Verified! You explored square wave timing and average voltage scaling.',
                      style: TextStyle(
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

  Widget _buildMetricCol({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _PwmWavePainter extends CustomPainter {
  final double dutyCycleRatio;
  final Color waveColor;

  _PwmWavePainter({
    required this.dutyCycleRatio,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background Grid
    final gridPaint = Paint()
      ..color = Colors.grey.shade900
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(0, size.height * 0.2),
        Offset(size.width, size.height * 0.2), gridPaint);
    canvas.drawLine(Offset(0, size.height * 0.8),
        Offset(size.width, size.height * 0.8), gridPaint);

    final yHigh = size.height * 0.2;
    final yLow = size.height * 0.8;

    const numCycles = 3;
    final cycleWidth = size.width / numCycles;

    final path = Path();
    path.moveTo(0, dutyCycleRatio > 0 ? yHigh : yLow);

    for (int i = 0; i < numCycles; i++) {
      final startX = i * cycleWidth;
      final highWidth = cycleWidth * dutyCycleRatio;

      if (dutyCycleRatio >= 1.0) {
        path.lineTo(startX + cycleWidth, yHigh);
      } else if (dutyCycleRatio <= 0.0) {
        path.lineTo(startX + cycleWidth, yLow);
      } else {
        path.lineTo(startX + highWidth, yHigh);
        path.lineTo(startX + highWidth, yLow);
        path.lineTo(startX + cycleWidth, yLow);
        if (i < numCycles - 1) {
          path.lineTo(startX + cycleWidth, yHigh);
        }
      }
    }

    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(path, wavePaint);

    // Draw reference labels 5V and 0V
    final tp5V = TextPainter(
      text: const TextSpan(
        text: '5V',
        style: TextStyle(color: Colors.white38, fontSize: 8),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp5V.paint(canvas, Offset(4, yHigh - 12));

    final tp0V = TextPainter(
      text: const TextSpan(
        text: '0V',
        style: TextStyle(color: Colors.white38, fontSize: 8),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp0V.paint(canvas, Offset(4, yLow + 2));
  }

  @override
  bool shouldRepaint(covariant _PwmWavePainter oldDelegate) =>
      oldDelegate.dutyCycleRatio != dutyCycleRatio;
}
