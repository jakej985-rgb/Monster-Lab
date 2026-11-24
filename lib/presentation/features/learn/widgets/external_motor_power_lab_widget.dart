import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive electrical isolation bench demonstrating why high-current motors (1-2A stall)
/// must be powered by an external supply with a shared Common Ground, rather than overloading
/// the Arduino's onboard 5V linear regulator and causing brownout resets.
class ExternalMotorPowerLabWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const ExternalMotorPowerLabWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<ExternalMotorPowerLabWidget> createState() =>
      _ExternalMotorPowerLabWidgetState();
}

class _ExternalMotorPowerLabWidgetState
    extends State<ExternalMotorPowerLabWidget> {
  // Power configuration:
  // 0: Arduino 5V Pin (Risky)
  // 1: External 9V Battery + Common GND (Proper Engineering)
  // 2: External 9V Battery WITHOUT Common GND (Floating Ground Bug)
  int _powerConfig = 1;

  // Motor mechanical load:
  // 0: No-Load Idle (150 mA)
  // 1: Heavy Running Load (650 mA)
  // 2: Full Rotor Stall (1500 mA = 1.5 A)
  int _motorLoad = 0;

  bool _testedBrownout = false;
  bool _testedStableIsolated = true;
  bool _hasCompleted = false;

  void _setConfig(int config) {
    setState(() {
      _powerConfig = config;
      if (_powerConfig == 0 && _motorLoad >= 1) {
        _testedBrownout = true;
      }
      if (_powerConfig == 1) {
        _testedStableIsolated = true;
      }
      _checkCompletion();
    });
  }

  void _setLoad(int load) {
    setState(() {
      _motorLoad = load;
      if (_powerConfig == 0 && _motorLoad >= 1) {
        _testedBrownout = true;
      }
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_testedBrownout && _testedStableIsolated && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  // Calculate electrical parameters based on state
  double get _arduino5VRailVoltage {
    if (_powerConfig == 0) {
      // Powered from Arduino regulator
      if (_motorLoad == 0) return 4.85;
      if (_motorLoad == 1) return 4.10; // Marginal / brownout threshold
      return 3.15; // Severe collapse!
    } else {
      // External power supply
      return 5.00; // Completely isolated & steady
    }
  }

  double get _regulatorTempCelsius {
    if (_powerConfig == 0) {
      if (_motorLoad == 0) return 38.0;
      if (_motorLoad == 1) return 78.0;
      return 115.0; // Thermal shutdown trip
    } else {
      return 26.0; // Cold & safe
    }
  }

  int get _motorCurrentMa {
    if (_powerConfig == 2) return 0; // Floating ground prevents switching
    if (_motorLoad == 0) return 150;
    if (_motorLoad == 1) return 650;
    return 1500;
  }

  bool get _isBrownout =>
      _powerConfig == 0 && _motorLoad >= 1 && _arduino5VRailVoltage < 4.3;

  bool get _isFloatingGnd => _powerConfig == 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'External Motor Power & Common Ground Isolation Bench';

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
                        'POWER ISOLATED',
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
            'Microcontrollers are delicate logic devices, while DC motors consume heavy surge currents. '
            'Powering motors from the Uno 5V pin collapses the rail voltage causing brownout resets. '
            'Always provide a dedicated battery with a shared Common Ground!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Power Configuration Toolbar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColors.surfaceContainerDark, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Power architecture selector
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Power Config:',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ChoiceChip(
                            key: const Key('config_external_power'),
                            label: const Text(
                                'External 9V + Common GND (Engineered)',
                                style: TextStyle(fontSize: 11)),
                            selected: _powerConfig == 1,
                            selectedColor: AppColors.success,
                            backgroundColor: AppColors.surfaceDark,
                            onSelected: (v) {
                              if (v) _setConfig(1);
                            },
                          ),
                          ChoiceChip(
                            key: const Key('config_arduino_power'),
                            label: const Text('Arduino 5V Pin (Risky)',
                                style: TextStyle(fontSize: 11)),
                            selected: _powerConfig == 0,
                            selectedColor: AppColors.danger,
                            backgroundColor: AppColors.surfaceDark,
                            onSelected: (v) {
                              if (v) _setConfig(0);
                            },
                          ),
                          ChoiceChip(
                            key: const Key('config_missing_gnd'),
                            label: const Text('External 9V (NO Common GND)',
                                style: TextStyle(fontSize: 11)),
                            selected: _powerConfig == 2,
                            selectedColor: AppColors.energyAmber,
                            backgroundColor: AppColors.surfaceDark,
                            onSelected: (v) {
                              if (v) _setConfig(2);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Mechanical Load Selector
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Motor Load:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ChoiceChip(
                      key: const Key('load_idle_button'),
                      label: const Text('Idle (150mA)',
                          style: TextStyle(fontSize: 11)),
                      selected: _motorLoad == 0,
                      selectedColor: AppColors.primaryViolet,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) _setLoad(0);
                      },
                    ),
                    ChoiceChip(
                      key: const Key('load_heavy_button'),
                      label: const Text('Heavy (650mA)',
                          style: TextStyle(fontSize: 11)),
                      selected: _motorLoad == 1,
                      selectedColor: AppColors.primaryViolet,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) _setLoad(1);
                      },
                    ),
                    ChoiceChip(
                      key: const Key('load_stall_button'),
                      label: const Text('Stall (1500mA)',
                          style: TextStyle(fontSize: 11)),
                      selected: _motorLoad == 2,
                      selectedColor: AppColors.danger,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (v) {
                        if (v) _setLoad(2);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Virtual Instrumentation Readout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isBrownout
                    ? AppColors.danger
                    : (_isFloatingGnd
                        ? AppColors.energyAmber
                        : AppColors.success),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMeter(
                    label: 'MCU 5V Rail',
                    value: '${_arduino5VRailVoltage.toStringAsFixed(2)} V',
                    color: _isBrownout ? AppColors.danger : AppColors.success,
                    subtext: _isBrownout ? 'BROWNOUT CRASH' : 'STABLE',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMeter(
                    label: 'Motor Surge',
                    value: '$_motorCurrentMa mA',
                    color: _motorLoad == 2
                        ? AppColors.danger
                        : AppColors.energyAmber,
                    subtext: _motorLoad == 2 ? 'STALL TORQUE' : 'OPERATING',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildMeter(
                    label: 'Regulator Temp',
                    value: '${_regulatorTempCelsius.toStringAsFixed(0)} °C',
                    color: _regulatorTempCelsius > 80
                        ? AppColors.danger
                        : AppColors.syntaxFunction,
                    subtext: _regulatorTempCelsius > 80
                        ? 'OVERHEATING'
                        : 'ROOM TEMP',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Diagnostic Summary Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isBrownout
                  ? AppColors.danger.withValues(alpha: 0.15)
                  : (_isFloatingGnd
                      ? AppColors.energyAmber.withValues(alpha: 0.15)
                      : AppColors.success.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _isBrownout
                    ? AppColors.danger
                    : (_isFloatingGnd
                        ? AppColors.energyAmber
                        : AppColors.success),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _isBrownout
                      ? Icons.error
                      : (_isFloatingGnd
                          ? Icons.warning_amber_rounded
                          : Icons.verified),
                  color: _isBrownout
                      ? AppColors.danger
                      : (_isFloatingGnd
                          ? AppColors.energyAmber
                          : AppColors.success),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isBrownout
                            ? 'CRITICAL BROWNOUT RESET & THERMAL SHUTDOWN'
                            : (_isFloatingGnd
                                ? 'FLOATING GROUND REFERENCE: SIGNALS UNRELIABLE'
                                : 'PERFECT POWER ISOLATION & COMMON GROUND REFERENCE'),
                        style: TextStyle(
                          color: _isBrownout
                              ? AppColors.danger
                              : (_isFloatingGnd
                                  ? AppColors.energyAmber
                                  : AppColors.success),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isBrownout
                            ? 'The motor is pulling up to 1.5A from the Arduino 5V onboard linear regulator (rated for only 400mA). '
                                'The 5V rail collapses below 4.3V, causing the ATmega328P to reboot in a continuous reset loop while the regulator overheats to ${_regulatorTempCelsius.toStringAsFixed(0)}°C!'
                            : (_isFloatingGnd
                                ? 'The external battery powers the motor, but the battery negative (-) is NOT connected to Arduino GND! '
                                    'Without a common 0V ground reference, the L293D input pins cannot measure voltage relative to Arduino pins, and control fails.'
                                : 'The external 9V battery supplies all high-current surges (up to 1.5A stall) to the motor coils. '
                                    'The shared Common Ground provides a clean 0V reference for PWM control signals without disturbing the Arduino 5.00V rail!'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeter({
    required String label,
    required String value,
    required Color color,
    required String subtext,
  }) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 9.5,
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color, width: 0.8),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              subtext,
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
