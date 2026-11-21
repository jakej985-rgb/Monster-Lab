import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Circuit schematic and waveform visualizer demonstrating open-drain bus architecture
/// and why 4.7kΩ pull-up resistors to +5V are strictly required on SDA and SCL lines.
class I2cPullupCheckerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const I2cPullupCheckerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<I2cPullupCheckerWidget> createState() => _I2cPullupCheckerWidgetState();
}

class _I2cPullupCheckerWidgetState extends State<I2cPullupCheckerWidget> {
  // 0: Proper 4.7kΩ, 1: Missing (None), 2: Weak 100kΩ
  int _selectedPullupMode = 0;
  final Set<int> _testedModes = {0};
  bool _hasCompleted = false;

  void _selectMode(int mode) {
    setState(() {
      _selectedPullupMode = mode;
      _testedModes.add(mode);

      if (_testedModes.contains(0) &&
          _testedModes.contains(1) &&
          !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'I2C Open-Drain Architecture & Pull-Up Checker';

    final isProper = _selectedPullupMode == 0;
    final isMissing = _selectedPullupMode == 1;

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
                        'OPEN-DRAIN MASTERED',
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
            'I2C uses "open-drain" pins: chips can ONLY pull the line down to 0V (GND). '
            'External pull-up resistors are required to restore the line back to +5V when released!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Pull-up Selection Buttons
          Row(
            children: [
              Expanded(
                child: _buildPullupOption(
                  key: const Key('pullup_select_proper'),
                  title: '4.7kΩ (Standard)',
                  subtitle: 'Crisp Rise Time',
                  modeIndex: 0,
                  accentColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPullupOption(
                  key: const Key('pullup_select_missing'),
                  title: 'None (Missing)',
                  subtitle: 'Bus Floats at 0V',
                  modeIndex: 1,
                  accentColor: AppColors.danger,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPullupOption(
                  key: const Key('pullup_select_weak'),
                  title: '100kΩ (Too Weak)',
                  subtitle: 'Sluggish RC Curve',
                  modeIndex: 2,
                  accentColor: AppColors.energyAmber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Open-Drain Circuit & Waveform Visualizer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isProper
                    ? AppColors.success.withValues(alpha: 0.5)
                    : (isMissing ? AppColors.danger : AppColors.energyAmber),
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
                        isProper
                            ? 'WAVEFORM: CRISP SQUARE WAVE'
                            : (isMissing
                                ? 'WAVEFORM: BUS DEAD (0.4V)'
                                : 'WAVEFORM: DISTORTED RC CURVE'),
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'monospace',
                          color: isProper
                              ? AppColors.success
                              : (isMissing
                                  ? AppColors.danger
                                  : AppColors.energyAmber),
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isProper ? '400 kHz OK' : 'BUS FAULT',
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Waveform Canvas
                SizedBox(
                  height: 70,
                  child: CustomPaint(
                    painter: _PullupWaveformPainter(mode: _selectedPullupMode),
                  ),
                ),
                const SizedBox(height: 12),

                // Schematic Flow
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSchematicBox(
                          '+5V Rail',
                          'Supply',
                          AppColors.wirePower5V,
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white38, size: 14),
                      Expanded(
                        child: _buildSchematicBox(
                          isMissing
                              ? 'Open (None)'
                              : (isProper ? '4.7kΩ' : '100kΩ Weak'),
                          'Resistance',
                          isProper
                              ? AppColors.success
                              : (isMissing
                                  ? AppColors.danger
                                  : AppColors.energyAmber),
                        ),
                      ),
                      const Icon(Icons.arrow_forward,
                          color: Colors.white38, size: 14),
                      Expanded(
                        child: _buildSchematicBox(
                          'SDA/SCL',
                          isProper
                              ? '5.0V / 0V'
                              : (isMissing ? 'Floating' : 'Rounded'),
                          AppColors.wireI2C,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Diagnostic Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isProper
                      ? AppColors.success
                      : (isMissing ? AppColors.danger : AppColors.energyAmber))
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (isProper
                        ? AppColors.success
                        : (isMissing
                            ? AppColors.danger
                            : AppColors.energyAmber))
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              isProper
                  ? 'Standard 4.7kΩ: Bus quickly charges the parasitic capacitance of wires, delivering fast rise times suitable for both 100 kHz standard and 400 kHz fast mode.'
                  : (isMissing
                      ? 'Fatal Error: Without pull-up resistors, when the N-FET releases the bus, there is no voltage source to pull it up to 5V! The line remains at 0V, causing the Arduino Wire library to hang indefinitely in an infinite while-loop waiting for clock pulses.'
                      : 'Weak 100kΩ Resistor: Current through 100kΩ is too small to quickly charge wire capacitance (RC time constant is too high). High-frequency clock pulses look like rounded shark fins, causing bit errors at 400 kHz.'),
              style: TextStyle(
                fontSize: 11,
                color: isProper
                    ? AppColors.success
                    : (isMissing ? AppColors.danger : AppColors.energyAmber),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPullupOption({
    required Key key,
    required String title,
    required String subtitle,
    required int modeIndex,
    required Color accentColor,
  }) {
    final isSelected = _selectedPullupMode == modeIndex;
    return InkWell(
      key: key,
      onTap: () => _selectMode(modeIndex),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.25)
              : AppColors.surfaceContainerDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? accentColor : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? accentColor : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? accentColor : AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchematicBox(String top, String bottom, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          top,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          bottom,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.textSecondaryDark,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _PullupWaveformPainter extends CustomPainter {
  final int mode; // 0: Proper, 1: Missing, 2: Weak

  _PullupWaveformPainter({required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += size.width / 6) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += size.height / 2) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final wavePaint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final period = size.width / 4;

    if (mode == 0) {
      // Crisp square wave
      wavePaint.color = AppColors.success;
      for (int i = 0; i < 4; i++) {
        final x0 = i * period;
        final x1 = x0 + period * 0.5;
        final x2 = (i + 1) * period;

        if (i == 0) path.moveTo(x0, size.height * 0.8);
        // Low to High sharp step
        path.lineTo(x0 + 4, size.height * 0.2);
        path.lineTo(x1, size.height * 0.2);
        // High to Low step
        path.lineTo(x1, size.height * 0.8);
        path.lineTo(x2, size.height * 0.8);
      }
    } else if (mode == 1) {
      // Missing pull-up: flat line near bottom
      wavePaint.color = AppColors.danger;
      path.moveTo(0, size.height * 0.85);
      path.lineTo(size.width, size.height * 0.85);
    } else {
      // Weak 100kΩ: sluggish RC exponential curve
      wavePaint.color = AppColors.energyAmber;
      for (int i = 0; i < 4; i++) {
        final x0 = i * period;
        final x1 = x0 + period * 0.5;
        final x2 = (i + 1) * period;

        if (i == 0) path.moveTo(x0, size.height * 0.8);
        // Sluggish curved rise
        path.quadraticBezierTo(
          x0 + period * 0.35,
          size.height * 0.45,
          x1,
          size.height * 0.25,
        );
        // Sharp pull down by N-FET
        path.lineTo(x1, size.height * 0.8);
        path.lineTo(x2, size.height * 0.8);
      }
    }

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _PullupWaveformPainter oldDelegate) =>
      oldDelegate.mode != mode;
}
