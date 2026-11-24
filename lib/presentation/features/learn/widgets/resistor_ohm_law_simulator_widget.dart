import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive Ohm's Law and current-limiting resistor simulator.
/// Demonstrates I = (V_supply - V_f) / R, LED forward voltage drop (2.0V),
/// safe illumination currents (10-20mA), and catastrophic blowout (< 100Ω).
class ResistorOhmLawSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const ResistorOhmLawSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<ResistorOhmLawSimulatorWidget> createState() =>
      _ResistorOhmLawSimulatorWidgetState();
}

class _ResistorOhmLawSimulatorWidgetState
    extends State<ResistorOhmLawSimulatorWidget> {
  double _resistorOhms = 220.0;
  bool _hasExploredBurnout = false;
  bool _hasExploredSafe = false;
  bool _hasCompleted = false;

  static const double _vSupply = 5.0; // Uno 5V rail
  static const double _vForward = 2.0; // Typical LED drop
  static const double _vResistor = _vSupply - _vForward; // 3.0V drop

  // Calculated current in mA. If R == 0, modeled as dead short (200mA+).
  double get _currentMa {
    if (_resistorOhms <= 0) return 250.0; // Saturated short circuit
    return (_vResistor / _resistorOhms) * 1000.0;
  }

  bool get _isBurnout => _resistorOhms < 100.0;
  bool get _isSafe => _resistorOhms >= 150.0 && _resistorOhms <= 1000.0;

  void _checkCompletion() {
    if (_isBurnout) _hasExploredBurnout = true;
    if (_isSafe) _hasExploredSafe = true;

    if (_hasExploredBurnout && _hasExploredSafe && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _setResistor(double ohms) {
    setState(() {
      _resistorOhms = ohms;
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    if (_isSafe) _hasExploredSafe = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        "Ohm's Law & Current-Limiting Simulator";

    final current = _currentMa;
    final isBurnout = _isBurnout;
    final isSafe = _isSafe;

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
                  color: isBurnout
                      ? AppColors.danger.withValues(alpha: 0.2)
                      : isSafe
                          ? AppColors.success.withValues(alpha: 0.2)
                          : AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isBurnout
                        ? AppColors.danger
                        : isSafe
                            ? AppColors.success
                            : AppColors.warning,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isBurnout
                          ? Icons.warning_amber
                          : isSafe
                              ? Icons.check_circle
                              : Icons.brightness_medium,
                      color: isBurnout
                          ? AppColors.danger
                          : isSafe
                              ? AppColors.success
                              : AppColors.warning,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isBurnout
                          ? 'BURNOUT BLOWOUT!'
                          : isSafe
                              ? 'OPTIMAL CURRENT'
                              : 'LOW CURRENT (DIM)',
                      style: TextStyle(
                        color: isBurnout
                            ? AppColors.danger
                            : isSafe
                                ? AppColors.success
                                : AppColors.warning,
                        fontSize: 11,
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
            "Ohm's Law: I = (V_supply - V_forward) / R. An Arduino output pin is rated for a continuous maximum of 20 mA. "
            "Without a series resistor of at least 150Ω, excessive current burns out the semiconductor die!",
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Simulation Visual Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isBurnout
                    ? AppColors.danger
                    : isSafe
                        ? AppColors.success
                        : AppColors.surfaceContainerDark,
              ),
            ),
            child: Column(
              children: [
                // Circuit Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Power Supply
                    _buildMetricCol(
                      label: 'V_supply',
                      value: '${_vSupply.toStringAsFixed(1)} V',
                      color: AppColors.wirePower5V,
                      icon: Icons.power,
                    ),
                    const Text('−',
                        style: TextStyle(
                            fontSize: 20, color: AppColors.textSecondaryDark)),
                    // LED Forward Drop
                    _buildMetricCol(
                      label: 'V_forward (LED)',
                      value: '${_vForward.toStringAsFixed(1)} V',
                      color: AppColors.energyAmber,
                      icon: Icons.lightbulb,
                    ),
                    const Text('=',
                        style: TextStyle(
                            fontSize: 20, color: AppColors.textSecondaryDark)),
                    // Voltage Drop Across Resistor
                    _buildMetricCol(
                      label: 'ΔV on Resistor',
                      value: '${_vResistor.toStringAsFixed(1)} V',
                      color: AppColors.accentCyan,
                      icon: Icons.compress,
                    ),
                  ],
                ),
                const Divider(
                    height: 24, color: AppColors.surfaceContainerDark),

                // Live Result Banner
                Row(
                  children: [
                    // Visual LED / Burnout Indicator
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: isBurnout
                            ? Colors.black
                            : isSafe
                                ? AppColors.energyAmber.withValues(alpha: 0.25)
                                : AppColors.surfaceContainerDark,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isBurnout
                              ? AppColors.danger
                              : isSafe
                                  ? AppColors.energyAmber
                                  : AppColors.textSecondaryDark,
                          width: 2,
                        ),
                        boxShadow: isSafe
                            ? [
                                BoxShadow(
                                  color: AppColors.energyAmber
                                      .withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          isBurnout
                              ? Icons.local_fire_department
                              : Icons.lightbulb,
                          size: 36,
                          color: isBurnout
                              ? AppColors.danger
                              : isSafe
                                  ? AppColors.energyAmber
                                  : AppColors.textSecondaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Metrics breakdown
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Resistor: ${_resistorOhms.round()} Ω',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Current: ${current >= 150 ? "> 150" : current.toStringAsFixed(1)} mA',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isBurnout
                                      ? AppColors.danger
                                      : isSafe
                                          ? AppColors.success
                                          : AppColors.warning,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isBurnout
                                ? 'FATAL: Pin rated for max 20mA! Drawing ${current.toStringAsFixed(0)}mA will permanently fuse ATmega328P output FETs!'
                                : isSafe
                                    ? 'SAFE: ${current.toStringAsFixed(1)} mA is within 10-20mA optimal band. Bright, reliable operation.'
                                    : 'FAINT: ${current.toStringAsFixed(1)} mA is very weak. LED will glow dimly.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isBurnout
                                  ? AppColors.danger
                                  : isSafe
                                      ? AppColors.success
                                      : AppColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Slider control
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Adjust Resistor:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${_resistorOhms.round()} Ω',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.accentCyan,
                ),
              ),
            ],
          ),
          Slider(
            key: const Key('resistor_slider'),
            value: _resistorOhms.clamp(0.0, 10000.0),
            min: 0.0,
            max: 10000.0,
            divisions: 500,
            activeColor: isBurnout
                ? AppColors.danger
                : isSafe
                    ? AppColors.accentCyan
                    : AppColors.warning,
            onChanged: (val) => _setResistor(val),
          ),
          const SizedBox(height: 8),

          // Presets buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('resistor_preset_0'),
                label: const Text('0 Ω (None / Short)'),
                backgroundColor: _resistorOhms == 0
                    ? AppColors.danger.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.danger),
                onPressed: () => _setResistor(0),
              ),
              ActionChip(
                key: const Key('resistor_preset_100'),
                label: const Text('100 Ω (Boundary)'),
                backgroundColor: _resistorOhms == 100
                    ? AppColors.warning.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _setResistor(100),
              ),
              ActionChip(
                key: const Key('resistor_preset_220'),
                label: const Text('220 Ω (Standard)'),
                backgroundColor: _resistorOhms == 220
                    ? AppColors.success.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.success),
                onPressed: () => _setResistor(220),
              ),
              ActionChip(
                key: const Key('resistor_preset_330'),
                label: const Text('330 Ω (Standard)'),
                backgroundColor: _resistorOhms == 330
                    ? AppColors.success.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.success),
                onPressed: () => _setResistor(330),
              ),
              ActionChip(
                key: const Key('resistor_preset_1k'),
                label: const Text('1 kΩ'),
                backgroundColor: _resistorOhms == 1000
                    ? AppColors.accentCyan.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _setResistor(1000),
              ),
              ActionChip(
                key: const Key('resistor_preset_10k'),
                label: const Text('10 kΩ (Very Dim)'),
                onPressed: () => _setResistor(10000),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            key: const Key('resistor_test_button'),
            onPressed: () {
              _checkCompletion();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBurnout
                        ? 'Explored burnout hazard! Always use a resistor >= 150Ω!'
                        : 'Tested ${_resistorOhms.round()}Ω: ${current.toStringAsFixed(1)} mA current.',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.speed),
            label: const Text('Verify Current Limits'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
              foregroundColor: Colors.white,
            ),
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
                      "Ohm's Law Mastered! You tested both safe operating current and burnout risk.",
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
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
