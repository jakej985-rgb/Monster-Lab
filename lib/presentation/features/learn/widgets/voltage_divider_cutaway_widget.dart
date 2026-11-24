import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive voltage divider and rotary potentiometer cutaway simulator.
/// Demonstrates the horseshoe carbon track, movable wiper arm contact,
/// resistance split (R1 and R2), and voltage division formula V_out = V_in * (R2 / (R1 + R2)).
class VoltageDividerCutawayWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const VoltageDividerCutawayWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<VoltageDividerCutawayWidget> createState() =>
      _VoltageDividerCutawayWidgetState();
}

class _VoltageDividerCutawayWidgetState
    extends State<VoltageDividerCutawayWidget> {
  double _wiperRatio = 0.5; // 0.0 (GND) to 1.0 (5V)
  static const double _vIn = 5.0; // Uno 5V
  static const double _totalResistanceKohm = 10.0; // 10k pot

  bool _hasExploredMin = false;
  bool _hasExploredMid = false;
  bool _hasExploredMax = false;
  bool _hasCompleted = false;

  double get _r2Kohm => _wiperRatio * _totalResistanceKohm; // GND to wiper
  double get _r1Kohm =>
      (1.0 - _wiperRatio) * _totalResistanceKohm; // 5V to wiper
  double get _vOut => _vIn * _wiperRatio;

  void _checkCompletion() {
    if (_wiperRatio <= 0.05) _hasExploredMin = true;
    if (_wiperRatio >= 0.45 && _wiperRatio <= 0.55) _hasExploredMid = true;
    if (_wiperRatio >= 0.95) _hasExploredMax = true;

    if (_hasExploredMin &&
        _hasExploredMid &&
        _hasExploredMax &&
        !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setRatio(double ratio) {
    setState(() {
      _wiperRatio = ratio.clamp(0.0, 1.0);
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    _hasExploredMid = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Potentiometer Internal Cutaway & Voltage Divider Math';

    final vOut = _vOut;
    final r1 = _r1Kohm;
    final r2 = _r2Kohm;

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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.speed,
                        color: AppColors.accentCyan, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${vOut.toStringAsFixed(2)} V',
                      style: const TextStyle(
                        color: AppColors.accentCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'A 10kΩ potentiometer divides voltage mechanically. Turning the knob sweeps the center wiper across '
            'a resistive carbon track, partitioning it into two resistances: R1 and R2.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Visual Cutaway Display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                // Horseshoe Carbon Track & Wiper Visual
                Center(
                  child: SizedBox(
                    width: 260,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Horseshoe resistive track (Curved Arc simulation)
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade800,
                              width: 18,
                            ),
                          ),
                        ),

                        // Resistance to GND (R2) on left
                        Positioned(
                          left: 10,
                          child: Text(
                            'R2 (${r2.toStringAsFixed(1)} kΩ)',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.accentCyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Resistance to 5V (R1) on right
                        Positioned(
                          right: 10,
                          child: Text(
                            'R1 (${r1.toStringAsFixed(1)} kΩ)',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.wirePower5V,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Rotary center hub & Wiper Contact Arm
                        Transform.rotate(
                          angle: -2.2 +
                              (_wiperRatio *
                                  4.4), // sweep ~250 degrees from Pin 1 (GND) to Pin 3 (5V)
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: AppColors.energyAmber,
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.energyAmber,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Center(
                                  child: Icon(Icons.rotate_right,
                                      size: 16, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom Terminals representation
                        Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildTerminalTag(
                                label: 'Pin 1: GND',
                                color: AppColors.wireGround,
                              ),
                              const SizedBox(width: 12),
                              _buildTerminalTag(
                                label: 'Pin 2: Wiper (A0)',
                                color: AppColors.energyAmber,
                              ),
                              const SizedBox(width: 12),
                              _buildTerminalTag(
                                label: 'Pin 3: 5V',
                                color: AppColors.wirePower5V,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                    height: 24, color: AppColors.surfaceContainerDark),

                // Math Equation Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'V_out = V_in × [ R2 / (R1 + R2) ]',
                            style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'V_out = 5.0V × [ ${r2.toStringAsFixed(2)}k / (${r1.toStringAsFixed(2)}k + ${r2.toStringAsFixed(2)}k) ] = ${vOut.toStringAsFixed(2)} V',
                        style: const TextStyle(
                          color: AppColors.accentCyan,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Rotary Knob Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Turn Wiper Knob:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${(_wiperRatio * 100).round()}% (Angle: ${(_wiperRatio * 270).round()}°)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.energyAmber,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('voltage_divider_knob_slider'),
            value: _wiperRatio,
            min: 0.0,
            max: 1.0,
            divisions: 100,
            activeColor: AppColors.accentCyan,
            onChanged: (val) => _setRatio(val),
          ),
          const SizedBox(height: 8),

          // Preset checkpoints
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('knob_preset_min'),
                label: const Text('0% (0.00 V / GND)'),
                backgroundColor: _wiperRatio == 0.0
                    ? AppColors.wireGround.withValues(alpha: 0.5)
                    : null,
                onPressed: () => _setRatio(0.0),
              ),
              ActionChip(
                key: const Key('knob_preset_mid'),
                label: const Text('50% (2.50 V / Midpoint)'),
                backgroundColor: _wiperRatio == 0.5
                    ? AppColors.accentCyan.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _setRatio(0.5),
              ),
              ActionChip(
                key: const Key('knob_preset_max'),
                label: const Text('100% (5.00 V / 5V Rail)'),
                backgroundColor: _wiperRatio == 1.0
                    ? AppColors.wirePower5V.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _setRatio(1.0),
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
                      'Voltage Divider Math Mastered! You verified the full span from 0V to 5V.',
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

  Widget _buildTerminalTag({
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
