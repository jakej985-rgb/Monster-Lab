import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// 4-transistor H-Bridge schematic visualizer (L293D / discrete H-bridge).
/// Demonstrates diagonal conduction pairs (Q1+Q4 = Forward, Q3+Q2 = Reverse),
/// dynamic regenerative braking, and shoot-through short-circuit protection.
class HBridgeDirectionSwitchWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const HBridgeDirectionSwitchWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<HBridgeDirectionSwitchWidget> createState() =>
      _HBridgeDirectionSwitchWidgetState();
}

class _HBridgeDirectionSwitchWidgetState
    extends State<HBridgeDirectionSwitchWidget>
    with SingleTickerProviderStateMixin {
  // Transistor states: Q1 (High-Left), Q2 (Low-Left), Q3 (High-Right), Q4 (Low-Right)
  bool _q1 = true;
  bool _q2 = false;
  bool _q3 = false;
  bool _q4 = true;

  late AnimationController _rotationController;
  final Set<String> _testedModes = {'forward'};
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  bool get _isShootThrough => (_q1 && _q2) || (_q3 && _q4);

  bool get _isForward => _q1 && _q4 && !_q2 && !_q3;

  bool get _isReverse => _q3 && _q2 && !_q1 && !_q4;

  bool get _isBraked =>
      ((_q2 && _q4) || (_q1 && _q3)) &&
      !_isShootThrough &&
      !_isForward &&
      !_isReverse;

  bool get _isCoast => !_q1 && !_q2 && !_q3 && !_q4;

  void _setMode(String mode) {
    setState(() {
      _testedModes.add(mode);
      switch (mode) {
        case 'forward':
          _q1 = true;
          _q2 = false;
          _q3 = false;
          _q4 = true;
          break;
        case 'reverse':
          _q1 = false;
          _q2 = true;
          _q3 = true;
          _q4 = false;
          break;
        case 'brake':
          _q1 = false;
          _q2 = true;
          _q3 = false;
          _q4 = true;
          break;
        case 'coast':
          _q1 = false;
          _q2 = false;
          _q3 = false;
          _q4 = false;
          break;
        case 'shoot_through':
          _q1 = true;
          _q2 = true; // Catastrophic short on left leg!
          _q3 = false;
          _q4 = false;
          break;
      }
      if (_isForward || _isReverse) {
        if (!_rotationController.isAnimating) {
          _rotationController.repeat();
        }
      } else {
        _rotationController.stop();
      }
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_testedModes.contains('forward') &&
        _testedModes.contains('reverse') &&
        (_testedModes.contains('shoot_through') ||
            _testedModes.contains('brake')) &&
        !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        '4-Transistor H-Bridge & Shoot-Through Lab';

    final isShootThrough = _isShootThrough;
    final isForward = _isForward;
    final isReverse = _isReverse;
    final isBraked = _isBraked;

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
                        'H-BRIDGE MASTERED',
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
            'The H-Bridge uses 4 transistors configured in an "H" topology to apply current in either direction across a DC motor. '
            'Diagonal pairs control spin; turning both switches on the same leg ON causes a catastrophic shoot-through short circuit!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 14),

          // Preset Controls Toolbar
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChoiceChip(
                key: const Key('hbridge_forward_btn'),
                avatar: const Icon(Icons.rotate_right,
                    size: 14, color: Colors.white),
                label: const Text('Forward (Q1+Q4)',
                    style: TextStyle(fontSize: 11)),
                selected: isForward,
                selectedColor: AppColors.success,
                backgroundColor: AppColors.surfaceDark,
                onSelected: (val) => _setMode('forward'),
              ),
              ChoiceChip(
                key: const Key('hbridge_reverse_btn'),
                avatar: const Icon(Icons.rotate_left,
                    size: 14, color: Colors.white),
                label: const Text('Reverse (Q3+Q2)',
                    style: TextStyle(fontSize: 11)),
                selected: isReverse,
                selectedColor: AppColors.accentCyanDark,
                backgroundColor: AppColors.surfaceDark,
                onSelected: (val) => _setMode('reverse'),
              ),
              ChoiceChip(
                key: const Key('hbridge_brake_btn'),
                avatar: const Icon(Icons.stop_circle_outlined,
                    size: 14, color: Colors.white),
                label: const Text('Dynamic Brake (Q2+Q4)',
                    style: TextStyle(fontSize: 11)),
                selected: isBraked,
                selectedColor: AppColors.energyAmber,
                backgroundColor: AppColors.surfaceDark,
                onSelected: (val) => _setMode('brake'),
              ),
              ChoiceChip(
                key: const Key('hbridge_coast_btn'),
                avatar: const Icon(Icons.pause, size: 14, color: Colors.white),
                label: const Text('Coast (All OFF)',
                    style: TextStyle(fontSize: 11)),
                selected: _isCoast,
                selectedColor: Colors.grey.shade700,
                backgroundColor: AppColors.surfaceDark,
                onSelected: (val) => _setMode('coast'),
              ),
              ChoiceChip(
                key: const Key('hbridge_shoot_through_btn'),
                avatar: const Icon(Icons.bolt, size: 14, color: Colors.white),
                label: const Text('Simulate Shoot-Through!',
                    style: TextStyle(fontSize: 11)),
                selected: isShootThrough,
                selectedColor: AppColors.danger,
                backgroundColor: AppColors.surfaceDark,
                onSelected: (val) => _setMode('shoot_through'),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Schematic "H" Diagram
          Container(
            height: 260,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isShootThrough
                    ? AppColors.danger
                    : (isForward
                        ? AppColors.success
                        : (isReverse ? AppColors.accentCyan : Colors.white24)),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // +12V High-Side Rail (Top)
                Positioned(
                  top: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.danger, width: 1),
                    ),
                    child: const Text(
                      '+12V HIGH-SIDE POWER RAIL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),

                // Ground Low-Side Rail (Bottom)
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: const Text(
                      '0V GROUND (GND) RETURN RAIL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ),

                // Q1 (Top Left)
                Positioned(
                  top: 35,
                  left: 10,
                  child: _buildTransistorSwitch('Q1 (High-Left)', _q1, (val) {
                    setState(() {
                      _q1 = val;
                      _checkCompletion();
                    });
                  }),
                ),

                // Q3 (Top Right)
                Positioned(
                  top: 35,
                  right: 10,
                  child: _buildTransistorSwitch('Q3 (High-Right)', _q3, (val) {
                    setState(() {
                      _q3 = val;
                      _checkCompletion();
                    });
                  }),
                ),

                // Center Motor M
                Positioned(
                  top: 75,
                  left: 0,
                  right: 0,
                  bottom: 75,
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isShootThrough
                            ? AppColors.danger.withValues(alpha: 0.3)
                            : (isForward || isReverse
                                ? AppColors.accentCyan.withValues(alpha: 0.15)
                                : Colors.black38),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isShootThrough
                              ? AppColors.danger
                              : (isForward || isReverse
                                  ? AppColors.accentCyan
                                  : Colors.white24),
                          width: 2,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isShootThrough)
                              const Icon(Icons.warning,
                                  color: AppColors.danger, size: 24)
                            else if (isForward || isReverse)
                              RotationTransition(
                                turns: isReverse
                                    ? Tween(begin: 1.0, end: 0.0)
                                        .animate(_rotationController)
                                    : _rotationController,
                                child: const Icon(
                                  Icons.settings,
                                  color: AppColors.accentCyan,
                                  size: 24,
                                ),
                              )
                            else
                              const Icon(Icons.settings,
                                  color: Colors.white38, size: 24),
                            const SizedBox(height: 2),
                            Text(
                              isShootThrough
                                  ? 'SHORT!'
                                  : (isForward
                                      ? 'FORWARD ↻'
                                      : (isReverse
                                          ? 'REVERSE ↺'
                                          : (isBraked ? 'BRAKED' : 'STOP'))),
                              style: TextStyle(
                                color: isShootThrough
                                    ? AppColors.danger
                                    : (isForward || isReverse
                                        ? Colors.white
                                        : Colors.white54),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Q2 (Bottom Left)
                Positioned(
                  bottom: 35,
                  left: 10,
                  child: _buildTransistorSwitch('Q2 (Low-Left)', _q2, (val) {
                    setState(() {
                      _q2 = val;
                      _checkCompletion();
                    });
                  }),
                ),

                // Q4 (Bottom Right)
                Positioned(
                  bottom: 35,
                  right: 10,
                  child: _buildTransistorSwitch('Q4 (Low-Right)', _q4, (val) {
                    setState(() {
                      _q4 = val;
                      _checkCompletion();
                    });
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Diagnostic Status Bar
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isShootThrough
                  ? AppColors.danger.withValues(alpha: 0.2)
                  : (isForward
                      ? AppColors.success.withValues(alpha: 0.15)
                      : (isReverse
                          ? AppColors.accentCyan.withValues(alpha: 0.15)
                          : Colors.black26)),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isShootThrough
                    ? AppColors.danger
                    : (isForward
                        ? AppColors.success
                        : (isReverse ? AppColors.accentCyan : Colors.white24)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isShootThrough
                      ? Icons.dangerous
                      : (isForward || isReverse
                          ? Icons.check_circle
                          : Icons.info_outline),
                  color: isShootThrough
                      ? AppColors.danger
                      : (isForward
                          ? AppColors.success
                          : (isReverse
                              ? AppColors.accentCyan
                              : Colors.white54)),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isShootThrough
                        ? 'CATASTROPHIC SHOOT-THROUGH SHORT CIRCUIT! +12V is shorted directly to GND through the same leg with zero resistance! Transistors explode without dead-time protection.'
                        : (isForward
                            ? 'FORWARD CONDUCTION: Q1 & Q4 are ON. Current flows +12V ➔ Q1 ➔ Motor (Left-to-Right) ➔ Q4 ➔ GND. Motor spins clockwise!'
                            : (isReverse
                                ? 'REVERSE CONDUCTION: Q3 & Q2 are ON. Current flows +12V ➔ Q3 ➔ Motor (Right-to-Left) ➔ Q2 ➔ GND. Motor spins counter-clockwise!'
                                : (isBraked
                                    ? 'DYNAMIC BRAKING: Both low-side transistors Q2 & Q4 are ON. Motor terminals are shorted together; back-EMF brakes the rotor rapidly.'
                                    : 'COAST / HIGH-IMPEDANCE: All 4 switches are OFF. Motor freely glides to a stop with natural friction.'))),
                    style: TextStyle(
                      color: isShootThrough
                          ? AppColors.danger
                          : (isForward
                              ? AppColors.success
                              : (isReverse
                                  ? AppColors.accentCyan
                                  : Colors.white70)),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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

  Widget _buildTransistorSwitch(
      String label, bool isOn, ValueChanged<bool> onChanged) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isOn
            ? AppColors.syntaxFunction.withValues(alpha: 0.15)
            : Colors.black45,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isOn ? AppColors.syntaxFunction : Colors.white24,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isOn ? Colors.white : Colors.white60,
              fontSize: 8.5,
              fontWeight: isOn ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 28,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: isOn,
                onChanged: onChanged,
                activeThumbColor: AppColors.syntaxFunction,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
