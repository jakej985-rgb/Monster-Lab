import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Animated SCL (Clock) and SDA (Data) oscilloscope demonstrating the I2C protocol:
/// START condition, 7-bit address, R/W bit, target ACK, and STOP condition.
class I2cBusTimingDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const I2cBusTimingDiagramWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<I2cBusTimingDiagramWidget> createState() =>
      _I2cBusTimingDiagramWidgetState();
}

class _I2cBusTimingDiagramWidgetState extends State<I2cBusTimingDiagramWidget> {
  // Current step in the I2C transaction
  // 0: Idle, 1: START, 2-8: 7 Address bits (0x27 -> 0,1,0,0,1,1,1), 9: R/W (0), 10: ACK (0), 11: STOP
  int _currentStep = 0;
  bool _isPlaying = false;
  Timer? _playTimer;
  bool _hasCompleted = false;

  final List<String> _stepNames = [
    'IDLE: Bus Released',
    'START: SDA pulled LOW while SCL is HIGH',
    'ADDR Bit 6: 0',
    'ADDR Bit 5: 1',
    'ADDR Bit 4: 0',
    'ADDR Bit 3: 0',
    'ADDR Bit 2: 1',
    'ADDR Bit 1: 1',
    'ADDR Bit 0: 1 (Address 0x27)',
    'R/W Bit: 0 (Master Write)',
    'ACK Pulse: Slave pulls SDA LOW',
    'STOP: SDA rises HIGH while SCL is HIGH',
  ];

  final List<String> _stepDescriptions = [
    'Both SDA and SCL are pulled HIGH to +5V by the 4.7kΩ pull-up resistors.',
    'START condition: Master initiates transaction by pulling SDA LOW while SCL remains HIGH. Every slave wakes up!',
    'Address Bit 6 (0): SCL pulses HIGH while SDA is held LOW.',
    'Address Bit 5 (1): SCL pulses HIGH while SDA is held HIGH.',
    'Address Bit 4 (0): SCL pulses HIGH while SDA is held LOW.',
    'Address Bit 3 (0): SCL pulses HIGH while SDA is held LOW.',
    'Address Bit 2 (1): SCL pulses HIGH while SDA is held HIGH.',
    'Address Bit 1 (1): SCL pulses HIGH while SDA is held HIGH.',
    'Address Bit 0 (1): Address matches 0x27 (the 16x2 LCD display)!',
    'R/W Bit: 0 indicates Write (Master sending commands to peripheral).',
    'ACK: On clock pulse 9, Master releases SDA; the LCD chip pulls SDA LOW to acknowledge receipt!',
    'STOP condition: Master releases SCL HIGH, then releases SDA HIGH, returning bus to IDLE.',
  ];

  @override
  void dispose() {
    _playTimer?.cancel();
    super.dispose();
  }

  void _stepForward() {
    setState(() {
      if (_currentStep < _stepNames.length - 1) {
        _currentStep++;
      } else {
        _currentStep = 0;
      }
      _checkCompletion();
    });
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playTimer?.cancel();
        _playTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
          if (!mounted) return;
          setState(() {
            if (_currentStep < _stepNames.length - 1) {
              _currentStep++;
            } else {
              _currentStep = 0;
            }
            _checkCompletion();
          });
        });
      } else {
        _playTimer?.cancel();
      }
    });
  }

  void _reset() {
    setState(() {
      _playTimer?.cancel();
      _isPlaying = false;
      _currentStep = 0;
    });
  }

  void _checkCompletion() {
    if (_currentStep == _stepNames.length - 1 && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'I2C Bus Timing Diagram: START, Address, ACK & STOP';

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
                        'TIMING MASTERED',
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
            'Golden Rule of I2C: Data (SDA) can only change when Clock (SCL) is LOW. '
            'Changes on SDA while SCL is HIGH are strictly reserved for START and STOP conditions!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Controls
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('i2c_step_button'),
                  onPressed: _stepForward,
                  icon: const Icon(Icons.skip_next, size: 18),
                  label: const Text('Next Phase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('i2c_play_button'),
                  onPressed: _togglePlay,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 18),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const Key('i2c_reset_button'),
                onPressed: _reset,
                icon: const Icon(Icons.refresh, color: Colors.white60),
                tooltip: 'Reset to IDLE',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dual-Trace Oscilloscope
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.wireI2C.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'LOGIC ANALYZER CAPTURE (100 kHz)',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          color: AppColors.wireI2C,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Step ${_currentStep + 1} / ${_stepNames.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Oscilloscope Traces
                SizedBox(
                  height: 110,
                  child: CustomPaint(
                    painter: _I2cTracePainter(currentStep: _currentStep),
                  ),
                ),
                const SizedBox(height: 8),

                // Signal legends
                const Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timeline,
                            color: AppColors.energyGold, size: 14),
                        SizedBox(width: 4),
                        Text('SCL (Pin A5: Clock)',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.energyGold)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.show_chart,
                            color: AppColors.accentCyan, size: 14),
                        SizedBox(width: 4),
                        Text('SDA (Pin A4: Data)',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.accentCyan)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Active Phase Explanatory Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerDark,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.accentCyan.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _stepNames[_currentStep],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.accentCyan,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _stepDescriptions[_currentStep],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _I2cTracePainter extends CustomPainter {
  final int currentStep;

  _I2cTracePainter({required this.currentStep});

  @override
  void paint(Canvas canvas, Size size) {
    final sclPaint = Paint()
      ..color = AppColors.energyGold
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final sdaPaint = Paint()
      ..color = AppColors.accentCyan
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    const totalSteps = 12;
    final stepWidth = size.width / totalSteps;

    // Highlight current column
    canvas.drawRect(
      Rect.fromLTWH(currentStep * stepWidth, 0, stepWidth, size.height),
      highlightPaint,
    );

    // SCL Lane: top half (0 to 50)
    // High = y: 15, Low = y: 40
    final sclPath = Path();
    // SDA Lane: bottom half (60 to 110)
    // High = y: 70, Low = y: 100
    final sdaPath = Path();

    // Trace coordinate values per step
    // 0: Idle (SCL: 1, SDA: 1)
    // 1: START (SCL: 1, SDA: falls to 0)
    // 2-8: Bits (0, 1, 0, 0, 1, 1, 1)
    // 9: R/W (0)
    // 10: ACK (0)
    // 11: STOP (SCL: 1, SDA: rises to 1)
    final sdaStates = [1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1];

    for (int i = 0; i < totalSteps; i++) {
      final xStart = i * stepWidth;
      final xEnd = (i + 1) * stepWidth;
      final xMid = xStart + stepWidth * 0.5;

      // SCL wave
      if (i == 0 || i == 1 || i == 11) {
        // High during idle, start, stop
        if (i == 0) {
          sclPath.moveTo(xStart, 15);
        }
        sclPath.lineTo(xEnd, 15);
      } else {
        // Clock pulses: low at edges, high in middle
        sclPath.lineTo(xStart, 40);
        sclPath.lineTo(xStart + 3, 15);
        sclPath.lineTo(xEnd - 3, 15);
        sclPath.lineTo(xEnd, 40);
      }

      // SDA wave
      final isHigh = sdaStates[i] == 1;
      final targetY = isHigh ? 70.0 : 100.0;
      if (i == 0) {
        sdaPath.moveTo(xStart, 70);
      }
      if (i == 1) {
        // Falling edge inside high SCL
        sdaPath.lineTo(xMid, 70);
        sdaPath.lineTo(xMid + 4, 100);
        sdaPath.lineTo(xEnd, 100);
      } else if (i == 11) {
        // Rising edge inside high SCL
        sdaPath.lineTo(xMid, 100);
        sdaPath.lineTo(xMid + 4, 70);
        sdaPath.lineTo(xEnd, 70);
      } else {
        sdaPath.lineTo(xEnd, targetY);
      }
    }

    canvas.drawPath(sclPath, sclPaint);
    canvas.drawPath(sdaPath, sdaPaint);

    // Current position pointer marker
    final markerPaint = Paint()..color = AppColors.energyAmber;
    canvas.drawCircle(
      Offset((currentStep + 0.5) * stepWidth, 4),
      3.5,
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _I2cTracePainter oldDelegate) =>
      oldDelegate.currentStep != currentStep;
}
