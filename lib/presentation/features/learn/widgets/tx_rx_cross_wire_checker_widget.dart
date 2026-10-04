import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive wiring checker contrasting the classic beginner UART trap (TX-to-TX straight)
/// with proper cross-connected full-duplex wiring (TX-to-RX and RX-to-TX) and 5V-to-3.3V
/// resistor divider protection.
class TxRxCrossWireCheckerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const TxRxCrossWireCheckerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<TxRxCrossWireCheckerWidget> createState() =>
      _TxRxCrossWireCheckerWidgetState();
}

class _TxRxCrossWireCheckerWidgetState
    extends State<TxRxCrossWireCheckerWidget> {
  // Wiring configuration: false = Straight (Trap), true = Crossed (Correct)
  bool _isCrossed = false;

  // Resistor voltage divider: false = Direct 5V wire, true = 1k/2k Divider installed
  bool _hasVoltageDivider = false;

  // Active testing animation
  bool _isTesting = false;
  Timer? _testTimer;
  double _packetProgress = 0.0;
  bool _hasCompleted = false;

  @override
  void dispose() {
    _testTimer?.cancel();
    super.dispose();
  }

  void _testConnection() {
    setState(() {
      _isTesting = true;
      _packetProgress = 0.0;
    });

    _testTimer?.cancel();
    _testTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (!mounted) return;
      setState(() {
        _packetProgress += 0.05;
        if (_packetProgress >= 1.0) {
          timer.cancel();
          _isTesting = false;
          _checkCompletion();
        }
      });
    });
  }

  void _checkCompletion() {
    if (_isCrossed && _hasVoltageDivider && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'TX / RX Cross-Wire & Level Shifter Checker';

    final isSuccess = _isCrossed && _hasVoltageDivider;
    final isDanger = _isCrossed && !_hasVoltageDivider;

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
                        'WIRING VERIFIED',
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
            'The #1 serial beginner mistake is connecting TX to TX and RX to RX. '
            'Transmitters must speak into receivers! Plus, 5V Arduino signals will overheat 3.3V Bluetooth radios unless stepped down.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Controls Bar
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
                // Wiring topology toggle
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Wiring Topology:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ChoiceChip(
                      key: const Key('wire_straight_button'),
                      label: const Text('Straight (TX-TX / RX-RX)',
                          style: TextStyle(fontSize: 11)),
                      selected: !_isCrossed,
                      selectedColor: AppColors.danger,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _isCrossed = false;
                            _isTesting = false;
                          });
                        }
                      },
                    ),
                    ChoiceChip(
                      key: const Key('wire_crossed_button'),
                      label: const Text('Crossed (TX->RX / RX->TX)',
                          style: TextStyle(fontSize: 11)),
                      selected: _isCrossed,
                      selectedColor: AppColors.success,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _isCrossed = true;
                            _isTesting = false;
                          });
                          _checkCompletion();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Resistor divider toggle
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Level Shifter:',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FilterChip(
                      key: const Key('toggle_divider_button'),
                      label: Text(
                        _hasVoltageDivider
                            ? '1kΩ / 2kΩ Divider Active (3.3V Safe)'
                            : 'Direct 5V Wire (No Divider)',
                        style: TextStyle(
                          fontSize: 11,
                          color: _hasVoltageDivider
                              ? Colors.black
                              : AppColors.energyAmber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: _hasVoltageDivider,
                      selectedColor: AppColors.energyAmber,
                      backgroundColor: AppColors.surfaceDark,
                      onSelected: (val) {
                        setState(() {
                          _hasVoltageDivider = val;
                          _isTesting = false;
                        });
                        _checkCompletion();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Schematic Breadboard Diagram
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSuccess
                    ? AppColors.success
                    : (isDanger ? AppColors.energyAmber : AppColors.danger),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Device: Arduino Uno
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00878F).withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF00878F)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Arduino Uno',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const Text(
                          'ATmega328P (5V Logic)',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPinLabel(
                            'Pin 11 (TX)', '5.0V', AppColors.energyAmber),
                        const SizedBox(height: 4),
                        _buildPinLabel(
                            'Pin 10 (RX)', 'TTL In', AppColors.accentCyan),
                        const SizedBox(height: 4),
                        _buildPinLabel('GND', '0V', Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Middle Center: Voltage Divider Node
                Expanded(
                  flex: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    decoration: BoxDecoration(
                      color: _hasVoltageDivider
                          ? AppColors.energyAmber.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _hasVoltageDivider
                            ? AppColors.energyAmber
                            : Colors.white24,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasVoltageDivider
                              ? Icons.shield_outlined
                              : Icons.warning_amber_rounded,
                          size: 16,
                          color: _hasVoltageDivider
                              ? AppColors.energyAmber
                              : Colors.white38,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _hasVoltageDivider
                              ? '1kΩ+2kΩ\n5V➔3.3V'
                              : 'Direct Wire\n5.0V Raw',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _hasVoltageDivider
                                ? AppColors.energyAmber
                                : Colors.white54,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_isTesting)
                          isSuccess
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.energyAmber,
                                      size: 11 + (3 * _packetProgress),
                                    ),
                                    Icon(
                                      Icons.arrow_back,
                                      color: AppColors.accentCyan,
                                      size: 11 + (3 * (1.0 - _packetProgress)),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.danger,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: const Text(
                                    'CONFLICT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),

                // Right Device: HC-05 Bluetooth Module
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF3B82F6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'HC-05 BT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const Text(
                          'BC417 (3.3V)',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPinLabel(
                            'RXD (In)',
                            '3.3V Max',
                            _isCrossed
                                ? AppColors.energyAmber
                                : AppColors.danger),
                        const SizedBox(height: 4),
                        _buildPinLabel(
                            'TXD (Out)', '3.3V Out', AppColors.accentCyan),
                        const SizedBox(height: 4),
                        _buildPinLabel('GND', 'Common 0V', Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Diagnostic Status Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSuccess
                  ? AppColors.success.withValues(alpha: 0.15)
                  : (isDanger
                      ? AppColors.energyAmber.withValues(alpha: 0.15)
                      : AppColors.danger.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSuccess
                    ? AppColors.success
                    : (isDanger ? AppColors.energyAmber : AppColors.danger),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSuccess
                      ? Icons.check_circle
                      : (isDanger ? Icons.warning_rounded : Icons.cancel),
                  color: isSuccess
                      ? AppColors.success
                      : (isDanger ? AppColors.energyAmber : AppColors.danger),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSuccess
                            ? 'PERFECT DUPLEX TELEMETRY (CROSS-CONNECTED + 3.3V CLAMPED)'
                            : (isDanger
                                ? 'OVERVOLTAGE ALERT: 5.0V INTO 3.3V RADIO PIN'
                                : 'BUS CONTENTION: STRAIGHT TX-TO-TX TRAP'),
                        style: TextStyle(
                          color: isSuccess
                              ? AppColors.success
                              : (isDanger
                                  ? AppColors.energyAmber
                                  : AppColors.danger),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isSuccess
                            ? 'Uno Pin 11 (TX) drives 5V ➔ stepped down to 3.3V by 1k/2k divider ➔ safe HC-05 RXD. '
                                'Module TXD outputs 3.3V ➔ directly triggers Uno Pin 10 (RX) because Uno considers >3.0V as HIGH logic!'
                            : (isDanger
                                ? 'The data lines are properly crossed, but Uno TX is pushing raw 5.0V directly into the HC-05 RXD pin! '
                                    'This causes thermal degradation and will permanently burn out the 3.3V transceiver IC. Add the 1k/2k divider!'
                                : 'Both TX pins are push-pull output drivers trying to push voltage against one another! '
                                    'Neither receiver listens to anything. Swap data wires so Transmitter connects to Receiver!'),
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
          const SizedBox(height: 14),

          // Test Button
          ElevatedButton.icon(
            key: const Key('test_connection_button'),
            onPressed: _testConnection,
            icon: Icon(_isTesting ? Icons.hourglass_top : Icons.play_arrow,
                size: 18),
            label: Text(_isTesting
                ? 'Testing Bidirectional Telemetry...'
                : 'Transmit Test Packet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuccess
                  ? AppColors.success
                  : (_isCrossed
                      ? AppColors.energyAmber
                      : AppColors.primaryViolet),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinLabel(String pinName, String voltage, Color badgeColor) {
    return Row(
      children: [
        Expanded(
          child: Text(
            pinName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: badgeColor, width: 0.8),
          ),
          child: Text(
            voltage,
            style: TextStyle(
              color: badgeColor,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
