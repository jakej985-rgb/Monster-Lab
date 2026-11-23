import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

enum PinAssignment { vcc5V, analogA0, gnd, disconnected }

/// Interactive 3-pin potentiometer wiring inspector and short-circuit checker.
/// Demonstrates the importance of wiring the center wiper to A0 and outer pins
/// across 5V and GND, highlighting the dead short circuit catastrophe if the wiper
/// is wired directly to GND or 5V while an outer pin connects to the opposing rail.
class WiperPinoutCheckerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const WiperPinoutCheckerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<WiperPinoutCheckerWidget> createState() =>
      _WiperPinoutCheckerWidgetState();
}

class _WiperPinoutCheckerWidgetState extends State<WiperPinoutCheckerWidget> {
  PinAssignment _pin1 = PinAssignment.vcc5V; // Outer pin
  PinAssignment _pin2 = PinAssignment.analogA0; // Center Wiper
  PinAssignment _pin3 = PinAssignment.gnd; // Outer pin

  bool _hasVerifiedCorrect = false;
  bool _hasCompleted = false;

  bool get _isCorrect {
    return _pin2 == PinAssignment.analogA0 &&
        ((_pin1 == PinAssignment.vcc5V && _pin3 == PinAssignment.gnd) ||
            (_pin1 == PinAssignment.gnd && _pin3 == PinAssignment.vcc5V));
  }

  bool get _isDeadShort {
    // If wiper is directly tied to GND and an outer pin is 5V (or vice versa)
    final hasVccAndGnd =
        (_pin1 == PinAssignment.vcc5V && _pin2 == PinAssignment.gnd) ||
            (_pin1 == PinAssignment.gnd && _pin2 == PinAssignment.vcc5V) ||
            (_pin3 == PinAssignment.vcc5V && _pin2 == PinAssignment.gnd) ||
            (_pin3 == PinAssignment.gnd && _pin2 == PinAssignment.vcc5V);
    return hasVccAndGnd;
  }

  bool get _isFloating {
    return _pin2 == PinAssignment.disconnected ||
        (_pin1 != PinAssignment.analogA0 &&
            _pin2 != PinAssignment.analogA0 &&
            _pin3 != PinAssignment.analogA0);
  }

  void _verifyWiring() {
    setState(() {
      if (_isCorrect) {
        _hasVerifiedCorrect = true;
      }

      if (_hasVerifiedCorrect && !_hasCompleted) {
        _hasCompleted = true;
        widget.onComplete?.call();
      }
    });
  }

  void _applyPreset({
    required PinAssignment p1,
    required PinAssignment p2,
    required PinAssignment p3,
  }) {
    setState(() {
      _pin1 = p1;
      _pin2 = p2;
      _pin3 = p3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Potentiometer 3-Pin Wiring & Short-Circuit Inspector';

    final isCorrect = _isCorrect;
    final isDeadShort = _isDeadShort;
    final isFloating = _isFloating;

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
                  color: isCorrect
                      ? AppColors.success.withValues(alpha: 0.2)
                      : isDeadShort
                          ? AppColors.danger.withValues(alpha: 0.2)
                          : AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect
                        ? AppColors.success
                        : isDeadShort
                            ? AppColors.danger
                            : AppColors.warning,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle
                          : isDeadShort
                              ? Icons.dangerous
                              : Icons.warning,
                      color: isCorrect
                          ? AppColors.success
                          : isDeadShort
                              ? AppColors.danger
                              : AppColors.warning,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCorrect
                          ? 'SAFE & FUNCTIONAL'
                          : isDeadShort
                              ? 'DEAD SHORT HAZARD!'
                              : 'WIRING FAULT',
                      style: TextStyle(
                        color: isCorrect
                            ? AppColors.success
                            : isDeadShort
                                ? AppColors.danger
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
            'The middle pin of a standard rotary potentiometer is the movable wiper. '
            'Wiring the center wiper to GND while an outer leg is on 5V creates a catastrophic zero-ohm short circuit '
            'when the knob is turned to the end of its travel!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Visual Wiring Diagram
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCorrect
                    ? AppColors.success.withValues(alpha: 0.5)
                    : isDeadShort
                        ? AppColors.danger
                        : AppColors.surfaceContainerDark,
              ),
            ),
            child: Column(
              children: [
                // Diagram of 3 Pins
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPinCard(
                      label: 'Pin 1 (Outer Leg)',
                      assignment: _pin1,
                      isWiper: false,
                    ),
                    _buildPinCard(
                      label: 'Pin 2 (Center Wiper)',
                      assignment: _pin2,
                      isWiper: true,
                    ),
                    _buildPinCard(
                      label: 'Pin 3 (Outer Leg)',
                      assignment: _pin3,
                      isWiper: false,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Diagnostic Result Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCorrect
                          ? AppColors.success.withValues(alpha: 0.5)
                          : isDeadShort
                              ? AppColors.danger
                              : AppColors.surfaceContainerDark,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect
                            ? Icons.verified
                            : isDeadShort
                                ? Icons.warning
                                : Icons.info,
                        color: isCorrect
                            ? AppColors.success
                            : isDeadShort
                                ? AppColors.danger
                                : AppColors.energyAmber,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isCorrect
                              ? 'PERFECT: Center wiper routes the divided voltage safely to Analog Pin A0. '
                                  'Total track resistance remains constant at 10kΩ across 5V and GND, consuming only 0.5 mA of quiescent current.'
                              : isDeadShort
                                  ? 'CATASTROPHIC DEAD SHORT: The wiper is wired to power or ground! When the knob rotates to zero resistance, '
                                      'it connects 5V directly to GND through 0.0 Ω, triggering USB port overcurrent shutdown or melting breadboard plastic!'
                                  : isFloating
                                      ? 'FLOATING INPUT: The wiper is not connected to A0. Pin A0 will float like an antenna, picking up 60Hz ambient noise!'
                                      : 'INCORRECT PINOUT: Outer pins and wiper must be properly paired.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDeadShort
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
          ),
          const SizedBox(height: 16),

          // Preset Buttons
          const Text(
            'Preset Wiring Configurations:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                key: const Key('wiper_wire_correct_preset'),
                label: const Text('Correct Wiring (Wiper ➔ A0)'),
                backgroundColor:
                    isCorrect ? AppColors.success.withValues(alpha: 0.3) : null,
                side: const BorderSide(color: AppColors.success),
                onPressed: () => _applyPreset(
                  p1: PinAssignment.vcc5V,
                  p2: PinAssignment.analogA0,
                  p3: PinAssignment.gnd,
                ),
              ),
              ActionChip(
                key: const Key('wiper_wire_short_preset'),
                label: const Text('Dead Short Trap (Wiper ➔ GND)'),
                backgroundColor: isDeadShort
                    ? AppColors.danger.withValues(alpha: 0.3)
                    : null,
                side: const BorderSide(color: AppColors.danger),
                onPressed: () => _applyPreset(
                  p1: PinAssignment.vcc5V,
                  p2: PinAssignment.gnd,
                  p3: PinAssignment.analogA0,
                ),
              ),
              ActionChip(
                key: const Key('wiper_wire_floating_preset'),
                label: const Text('Floating Wiper Trap'),
                backgroundColor: isFloating
                    ? AppColors.warning.withValues(alpha: 0.3)
                    : null,
                onPressed: () => _applyPreset(
                  p1: PinAssignment.vcc5V,
                  p2: PinAssignment.disconnected,
                  p3: PinAssignment.gnd,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            key: const Key('wiper_verify_button'),
            onPressed: _verifyWiring,
            icon: const Icon(Icons.security_update_good),
            label: const Text('Verify Circuit Safety'),
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
                      'Potentiometer Pinout Mastery Verified! Always ensure the center wiper connects to Analog In A0.',
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

  Widget _buildPinCard({
    required String label,
    required PinAssignment assignment,
    required bool isWiper,
  }) {
    Color badgeColor;
    String text;

    switch (assignment) {
      case PinAssignment.vcc5V:
        badgeColor = AppColors.wirePower5V;
        text = '5V Rail';
        break;
      case PinAssignment.analogA0:
        badgeColor = AppColors.wireAnalog;
        text = 'Uno A0 (Signal)';
        break;
      case PinAssignment.gnd:
        badgeColor = AppColors.wireGround;
        text = 'GND Rail';
        break;
      case PinAssignment.disconnected:
        badgeColor = Colors.grey;
        text = 'Disconnected';
        break;
    }

    return Container(
      width: 95,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWiper ? AppColors.energyAmber : Colors.grey.shade700,
          width: isWiper ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isWiper ? Icons.tune : Icons.settings_ethernet,
            size: 20,
            color: isWiper ? AppColors.energyAmber : Colors.white70,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
