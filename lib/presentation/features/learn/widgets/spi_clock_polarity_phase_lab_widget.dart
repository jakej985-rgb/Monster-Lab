import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive visualizer for SPI Modes 0, 1, 2, 3 illustrating Clock Polarity (CPOL)
/// idle levels and Clock Phase (CPHA) sample edge timings.
class SpiClockPolarityPhaseLabWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const SpiClockPolarityPhaseLabWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<SpiClockPolarityPhaseLabWidget> createState() =>
      _SpiClockPolarityPhaseLabWidgetState();
}

class _SpiClockPolarityPhaseLabWidgetState
    extends State<SpiClockPolarityPhaseLabWidget> {
  // 0: Mode 0 (CPOL=0, CPHA=0)
  // 1: Mode 1 (CPOL=0, CPHA=1)
  // 2: Mode 2 (CPOL=1, CPHA=0)
  // 3: Mode 3 (CPOL=1, CPHA=1)
  int _selectedMode = 0;
  final Set<int> _testedModes = {0};
  bool _hasCompleted = false;

  void _selectMode(int mode) {
    setState(() {
      _selectedMode = mode;
      _testedModes.add(mode);

      if (_testedModes.length >= 2 && !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  int get _cpol => (_selectedMode == 2 || _selectedMode == 3) ? 1 : 0;
  int get _cpha => (_selectedMode == 1 || _selectedMode == 3) ? 1 : 0;

  String get _sampleEdge {
    if (_cpol == 0) {
      return _cpha == 0 ? 'Rising (Leading Edge)' : 'Falling (Trailing Edge)';
    } else {
      return _cpha == 0 ? 'Falling (Leading Edge)' : 'Rising (Trailing Edge)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'SPI Clock Polarity (CPOL) & Phase (CPHA) Lab';

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
                        'MODES MASTERED',
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
            'Different SPI chips require specific clock timing. CPOL sets the SCK idle voltage, '
            'and CPHA defines whether data is sampled on the first (leading) or second (trailing) clock transition.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Mode Selector
          Row(
            children: [
              Expanded(
                child: _buildModeTab(
                  key: const Key('spi_mode_0_button'),
                  title: 'Mode 0',
                  subtitle: '0, 0 (Default)',
                  modeIndex: 0,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildModeTab(
                  key: const Key('spi_mode_1_button'),
                  title: 'Mode 1',
                  subtitle: '0, 1',
                  modeIndex: 1,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildModeTab(
                  key: const Key('spi_mode_2_button'),
                  title: 'Mode 2',
                  subtitle: '1, 0',
                  modeIndex: 2,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildModeTab(
                  key: const Key('spi_mode_3_button'),
                  title: 'Mode 3',
                  subtitle: '1, 1',
                  modeIndex: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Waveform Display
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.energyGold.withValues(alpha: 0.4),
              ),
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
                    Text(
                      'SCK & DATA TIMING: SPI_MODE$_selectedMode',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: AppColors.energyGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.accentCyan,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '= Sample Instant',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'monospace',
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Oscilloscope Canvas
                SizedBox(
                  height: 90,
                  child: CustomPaint(
                    painter: _SpiModeWaveformPainter(
                      cpol: _cpol,
                      cpha: _cpha,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Parameter Telemetry Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildParamColumn(
                      'CPOL (Polarity)',
                      '$_cpol (${_cpol == 0 ? 'Idle LOW' : 'Idle HIGH'})',
                      AppColors.energyAmber,
                    ),
                    _buildParamColumn(
                      'CPHA (Phase)',
                      '$_cpha (${_cpha == 0 ? 'Leading' : 'Trailing'})',
                      AppColors.accentCyan,
                    ),
                    _buildParamColumn(
                      'Sample Edge',
                      _sampleEdge,
                      AppColors.success,
                    ),
                  ],
                ),
                const Divider(height: 16, color: Colors.white12),
                Row(
                  children: [
                    const Icon(Icons.terminal,
                        color: AppColors.energyGold, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Arduino SPISettings(4000000, MSBFIRST, SPI_MODE$_selectedMode);',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppColors.energyGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab({
    required Key key,
    required String title,
    required String subtitle,
    required int modeIndex,
  }) {
    final isSelected = _selectedMode == modeIndex;
    return InkWell(
      key: key,
      onTap: () => _selectMode(modeIndex),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.energyGold.withValues(alpha: 0.25)
              : AppColors.surfaceContainerDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.energyGold : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: isSelected ? AppColors.energyGold : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: isSelected
                    ? AppColors.energyGold
                    : AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParamColumn(String label, String value, Color color) {
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
            fontSize: 11,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SpiModeWaveformPainter extends CustomPainter {
  final int cpol;
  final int cpha;

  _SpiModeWaveformPainter({required this.cpol, required this.cpha});

  @override
  void paint(Canvas canvas, Size size) {
    final sckPaint = Paint()
      ..color = AppColors.energyGold
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dataPaint = Paint()
      ..color = AppColors.wireSPI
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final samplePointPaint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.fill;

    final period = size.width / 4;
    final sckPath = Path();
    final dataPath = Path();

    // SCK Y levels (top half: 10 to 45)
    final sckIdleY = cpol == 0 ? 40.0 : 15.0;
    final sckActiveY = cpol == 0 ? 15.0 : 40.0;

    // Draw SCK pulses
    sckPath.moveTo(0, sckIdleY);
    for (int i = 0; i < 4; i++) {
      final xStart = i * period;
      final xMid = xStart + period * 0.5;
      final xEnd = (i + 1) * period;

      sckPath.lineTo(xStart + period * 0.1, sckIdleY);
      sckPath.lineTo(xStart + period * 0.1, sckActiveY);
      sckPath.lineTo(xMid + period * 0.1, sckActiveY);
      sckPath.lineTo(xMid + period * 0.1, sckIdleY);
      sckPath.lineTo(xEnd, sckIdleY);

      // Sample dots:
      // If cpha == 0: sample on leading edge (xStart + period * 0.1)
      // If cpha == 1: sample on trailing edge (xMid + period * 0.1)
      final sampleX = cpha == 0 ? xStart + period * 0.1 : xMid + period * 0.1;
      canvas.drawCircle(Offset(sampleX, 28), 4.0, samplePointPaint);
    }
    canvas.drawPath(sckPath, sckPaint);

    // Data Y levels (bottom half: 55 to 80)
    dataPath.moveTo(0, 70);
    for (int i = 0; i < 4; i++) {
      final xStart = i * period;
      final xEnd = (i + 1) * period;
      final y = (i % 2 == 0) ? 60.0 : 80.0;
      dataPath.lineTo(xStart + 5, y);
      dataPath.lineTo(xEnd - 5, y);
    }
    canvas.drawPath(dataPath, dataPaint);
  }

  @override
  bool shouldRepaint(covariant _SpiModeWaveformPainter oldDelegate) =>
      oldDelegate.cpol != cpol || oldDelegate.cpha != cpha;
}
