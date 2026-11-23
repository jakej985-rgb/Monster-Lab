import 'dart:async';
import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive demonstration of high-impedance floating input pins vs pullup/pulldown resistors.
class FloatingPinSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const FloatingPinSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<FloatingPinSimulatorWidget> createState() =>
      _FloatingPinSimulatorWidgetState();
}

class _FloatingPinSimulatorWidgetState
    extends State<FloatingPinSimulatorWidget> {
  // 0: Floating, 1: Pull-Up (5V), 2: Pull-Down (GND)
  int _pinMode = 0;
  bool _handNearby = false;
  final List<int> _bitStream = [0, 1, 0, 1, 1, 0, 0, 1];
  double _currentVoltage = 2.4;
  int _currentBit = 1;
  int _noiseGlitchCounter = 0;

  Timer? _timer;
  final Set<int> _testedModes = {0};
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _startSimulationTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSimulationTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) return;
      setState(() {
        if (_pinMode == 0) {
          // Floating pin: pick up stray environmental 60Hz and RF noise
          final randomOffset = (math.Random().nextDouble() - 0.5) * 2.8;
          final proximityBias = _handNearby ? 1.5 : 0.0;
          _currentVoltage =
              (2.5 + randomOffset + proximityBias).clamp(0.2, 4.8);
          // CMOS threshold ~ 2.5V
          _currentBit = _currentVoltage >= 2.5 ? 1 : 0;
          _noiseGlitchCounter++;
        } else if (_pinMode == 1) {
          // Pull-Up: solid 5.0V
          _currentVoltage = 5.0;
          _currentBit = 1;
        } else {
          // Pull-Down: solid 0.0V
          _currentVoltage = 0.0;
          _currentBit = 0;
        }

        _bitStream.add(_currentBit);
        if (_bitStream.length > 16) {
          _bitStream.removeAt(0);
        }
      });
    });
  }

  void _selectMode(int mode) {
    setState(() {
      _pinMode = mode;
      _testedModes.add(mode);

      if (_testedModes.contains(0) &&
          (_testedModes.contains(1) || _testedModes.contains(2)) &&
          !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  void _toggleHandProximity() {
    setState(() {
      _handNearby = !_handNearby;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Floating Pin Simulator: Antenna Effect';

    final isFloating = _pinMode == 0;
    final isPullUp = _pinMode == 1;

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
                        'PIN STABILIZED',
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
            'An unconnected digital input has an internal impedance over 100 MΩ. '
            'Without a pull resistor, it acts as an antenna picking up stray electromagnetic radiation!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Mode Selector
          Row(
            children: [
              Expanded(
                child: _buildModeButton(
                  key: const Key('pin_mode_floating'),
                  title: 'Floating (None)',
                  subtitle: 'High Impedance',
                  isSelected: _pinMode == 0,
                  accentColor: AppColors.danger,
                  onTap: () => _selectMode(0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeButton(
                  key: const Key('pin_mode_pullup'),
                  title: 'Pull-Up (5V)',
                  subtitle: '20kΩ to VCC',
                  isSelected: _pinMode == 1,
                  accentColor: AppColors.accentCyan,
                  onTap: () => _selectMode(1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModeButton(
                  key: const Key('pin_mode_pulldown'),
                  title: 'Pull-Down (GND)',
                  subtitle: '10kΩ to 0V',
                  isSelected: _pinMode == 2,
                  accentColor: AppColors.energyAmber,
                  onTap: () => _selectMode(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Live Oscilloscope & Pin Telemetry Bench
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isFloating
                    ? AppColors.danger.withValues(alpha: 0.6)
                    : AppColors.success.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            isFloating
                                ? Icons.wifi_tethering_error
                                : Icons.verified,
                            color: isFloating
                                ? AppColors.danger
                                : AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              isFloating
                                  ? 'STATE: FLOATING ANTENNA'
                                  : (isPullUp
                                      ? 'STATE: PULLED HIGH (+5V)'
                                      : 'STATE: PULLED LOW (GND)'),
                              style: TextStyle(
                                color: isFloating
                                    ? AppColors.danger
                                    : AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentVoltage.toStringAsFixed(2)} V',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bitstream Visualization
                const Text(
                  'digitalRead(2) Live Bit Stream (Last 16 Cycles):',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _bitStream.map((bit) {
                    final isHigh = bit == 1;
                    return Container(
                      width: 15,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isHigh
                            ? AppColors.accentCyan.withValues(alpha: 0.3)
                            : AppColors.surfaceContainerDark,
                        border: Border.all(
                          color: isHigh
                              ? AppColors.accentCyan
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$bit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isHigh ? AppColors.accentCyan : Colors.white60,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Stray noise test button
                ElevatedButton(
                  key: const Key('induce_noise_button'),
                  onPressed: _toggleHandProximity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _handNearby
                        ? AppColors.energyAmber.withValues(alpha: 0.3)
                        : AppColors.surfaceContainerDark,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color:
                          _handNearby ? AppColors.energyAmber : Colors.white24,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _handNearby ? Icons.pan_tool : Icons.pan_tool_outlined,
                        color:
                            _handNearby ? AppColors.energyAmber : Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _handNearby
                              ? 'Hand Near Pin: High Electrostatic Noise!'
                              : 'Wave Hand Near Jumper Wire (Inject Stray EM Noise)',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Diagnostic explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isFloating ? AppColors.danger : AppColors.success)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (isFloating ? AppColors.danger : AppColors.success)
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isFloating ? Icons.warning_amber : Icons.lightbulb_outline,
                  color: isFloating ? AppColors.danger : AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isFloating
                        ? 'Glitch Count: $_noiseGlitchCounter. Because the pin floats freely, surrounding AC power lines and radio waves induce tiny voltages that cross the ~2.5V threshold, generating random ghost presses!'
                        : (isPullUp
                            ? 'The internal 20kΩ pull-up resistor safely drains stray electrons to +5V, holding the pin firmly at logic HIGH (1) until a switch physically shorts it to GND.'
                            : 'The external 10kΩ pull-down resistor securely ties the pin to 0V (GND), holding logic LOW (0) until a switch injects +5V.'),
                    style: TextStyle(
                      fontSize: 12,
                      color: isFloating
                          ? AppColors.danger
                          : AppColors.textPrimaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required Key key,
    required String title,
    required String subtitle,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.25)
              : AppColors.surfaceContainerDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? accentColor : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? accentColor : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? accentColor : AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
