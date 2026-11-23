import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive 50Hz (20ms frame) Servo PWM pulse generator.
/// Demonstrates how pulse width modulation from 1.0ms (0°) to 1.5ms (90°) to 2.0ms (180°)
/// controls physical robotic servo motor position.
class ServoPulseWidthModulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const ServoPulseWidthModulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<ServoPulseWidthModulatorWidget> createState() =>
      _ServoPulseWidthModulatorWidgetState();
}

class _ServoPulseWidthModulatorWidgetState
    extends State<ServoPulseWidthModulatorWidget> {
  // Pulse width in milliseconds: 1.0 ms to 2.0 ms
  double _pulseWidthMs = 1.5;

  final Set<double> _testedAngles = {90.0};
  bool _hasCompleted = false;

  // Convert pulse width (1.0..2.0ms) to angle (0°..180°)
  double get _angleDegrees => ((_pulseWidthMs - 1.0) / 1.0) * 180.0;

  // Duty cycle percentage for 20ms period
  double get _dutyCyclePercent => (_pulseWidthMs / 20.0) * 100.0;

  void _setPulseWidth(double widthMs) {
    setState(() {
      _pulseWidthMs = widthMs.clamp(1.0, 2.0);
      _testedAngles.add((_angleDegrees / 45.0).round() * 45.0);
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_testedAngles.length >= 2 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        '50Hz Servo Pulse Width Modulator (1.0ms – 2.0ms)';

    final angle = _angleDegrees.round();
    final duty = _dutyCyclePercent.toStringAsFixed(1);

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
                        'SERVO PWM MASTERED',
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
          const SizedBox(height: 6),
          Text(
            'Hobby servos operate on a strict 50Hz (20ms period) signal. '
            'The horn angle is encoded NOT by DC voltage, but by the duration of the HIGH pulse: '
            '1.0ms = 0°, 1.5ms = 90° (Neutral), and 2.0ms = 180°!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Servo Horn Visualizer & Protractor
          Container(
            height: 190,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.primaryViolet.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                // Virtual Servo Body & Rotating Horn (Left)
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Protractor Arc Dial
                      CustomPaint(
                        size: const Size(180, 160),
                        painter: _ServoProtractorPainter(),
                      ),

                      // SG90 Blue Body Housing
                      Positioned(
                        bottom: 12,
                        child: Container(
                          width: 80,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E40AF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF60A5FA)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'SG90 SERVO\n50Hz (5V)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Rotating Horn
                      Positioned(
                        bottom: 34,
                        child: Transform.rotate(
                          angle: (_angleDegrees - 90) * (math.pi / 180.0),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 14,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.danger,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(bottom: 2),
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Angle & Telemetry Readout (Right)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTelemetryItem(
                            'Horn Angle',
                            '$angle°',
                            AppColors.accentCyan,
                          ),
                          const SizedBox(height: 6),
                          _buildTelemetryItem(
                            'Pulse Width',
                            '${_pulseWidthMs.toStringAsFixed(2)} ms',
                            AppColors.energyAmber,
                          ),
                          const SizedBox(height: 6),
                          _buildTelemetryItem(
                            'Duty Cycle',
                            '$duty%',
                            AppColors.syntaxFunction,
                          ),
                          const SizedBox(height: 6),
                          _buildTelemetryItem(
                            'Code Syntax',
                            'servo.write($angle);',
                            AppColors.syntaxString,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Pulse Width Waveform Oscilloscope (20ms Period)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF070B14),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.waves,
                            size: 14, color: AppColors.accentCyan),
                        SizedBox(width: 4),
                        Text(
                          '50Hz PWM (20ms Frame)',
                          style: TextStyle(
                            color: AppColors.accentCyan,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'HIGH: ${_pulseWidthMs.toStringAsFixed(2)}ms | LOW: ${(20.0 - _pulseWidthMs).toStringAsFixed(2)}ms',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Graphic representation of 20ms frame
                Row(
                  children: [
                    // Active HIGH pulse
                    Expanded(
                      flex: (_pulseWidthMs * 100).round(),
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${_pulseWidthMs.toStringAsFixed(2)}ms HIGH',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Idle LOW remainder
                    Expanded(
                      flex: ((20.0 - _pulseWidthMs) * 100).round(),
                      child: Container(
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Quick Presets Toolbar
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('preset_0_deg'),
                  onPressed: () => _setPulseWidth(1.0),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        angle == 0 ? AppColors.accentCyan : Colors.white70,
                    side: BorderSide(
                        color:
                            angle == 0 ? AppColors.accentCyan : Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('0° (1.0ms)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  key: const Key('preset_90_deg'),
                  onPressed: () => _setPulseWidth(1.5),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        angle == 90 ? AppColors.accentCyan : Colors.white70,
                    side: BorderSide(
                        color: angle == 90
                            ? AppColors.accentCyan
                            : Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('90° (1.5ms)'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  key: const Key('preset_180_deg'),
                  onPressed: () => _setPulseWidth(2.0),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        angle == 180 ? AppColors.accentCyan : Colors.white70,
                    side: BorderSide(
                        color: angle == 180
                            ? AppColors.accentCyan
                            : Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('180° (2.0ms)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Fine Control Slider
          Row(
            children: [
              const Text(
                '1.0ms',
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
              Expanded(
                child: Slider(
                  key: const Key('pulse_width_slider'),
                  value: _pulseWidthMs,
                  min: 1.0,
                  max: 2.0,
                  divisions: 20,
                  activeColor: AppColors.accentCyan,
                  inactiveColor: Colors.white12,
                  onChanged: _setPulseWidth,
                ),
              ),
              const Text(
                '2.0ms',
                style: TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              const TextStyle(color: AppColors.textSecondaryDark, fontSize: 9),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class _ServoProtractorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width / 2.2;

    final arcPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw arc from 0° (PI) to 180° (0)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      arcPaint,
    );

    // Tick marks for 0°, 45°, 90°, 135°, 180°
    final tickPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.5;

    for (int deg = 0; deg <= 180; deg += 45) {
      final rad = (180 - deg) * (math.pi / 180.0);
      final p1 = Offset(
        center.dx + (radius - 8) * math.cos(rad),
        center.dy - (radius - 8) * math.sin(rad),
      );
      final p2 = Offset(
        center.dx + radius * math.cos(rad),
        center.dy - radius * math.sin(rad),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
