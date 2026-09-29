import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class PotentiometerSimulatorWidget extends StatefulWidget {
  final int initialValue;

  const PotentiometerSimulatorWidget({super.key, this.initialValue = 512});

  @override
  State<PotentiometerSimulatorWidget> createState() =>
      _PotentiometerSimulatorWidgetState();
}

class _PotentiometerSimulatorWidgetState
    extends State<PotentiometerSimulatorWidget> {
  late int _adcValue;

  @override
  void initState() {
    super.initState();
    _adcValue = widget.initialValue;
  }

  double get _voltage => (_adcValue / 1023.0) * 5.0;

  @override
  Widget build(BuildContext context) {
    return MonsterCard(
      color: AppColors.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, color: AppColors.accentCyan),
              SizedBox(width: 8),
              Text(
                '10-Bit ADC Potentiometer Dial',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Analog Meter & Dial Display
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _adcValue / 1023.0,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.accentCyan),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_adcValue',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          '${_voltage.toStringAsFixed(2)} Volts',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentCyanDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Physical Position: ${((_adcValue / 1023.0) * 100).round()}% Turned',
                  style: const TextStyle(
                      color: AppColors.textSecondaryLight, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Knob Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Turn Knob (0V to 5V):',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                'analogRead(A0) == $_adcValue',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentCyanDark,
                ),
              ),
            ],
          ),
          Slider(
            value: _adcValue.toDouble(),
            min: 0,
            max: 1023,
            divisions: 1023,
            activeColor: AppColors.accentCyan,
            label: '$_adcValue',
            onChanged: (val) {
              setState(() => _adcValue = val.round());
            },
          ),
          const SizedBox(height: 8),

          // Virtual Serial Monitor Output
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.terminal,
                        color: AppColors.syntaxFunction, size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Serial Monitor (9600 baud):',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: AppColors.syntaxConstant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '> analogRead(A0) -> $_adcValue\n'
                  '> Voltage: ${_voltage.toStringAsFixed(2)}V (ADC 10-bit range: 0-1023)',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: AppColors.syntaxString,
                    height: 1.4,
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
