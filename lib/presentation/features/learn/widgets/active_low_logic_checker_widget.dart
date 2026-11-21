import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive button bench testing active-low inverted logic:
/// if (digitalRead(buttonPin) == LOW)
class ActiveLowLogicCheckerWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const ActiveLowLogicCheckerWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<ActiveLowLogicCheckerWidget> createState() =>
      _ActiveLowLogicCheckerWidgetState();
}

class _ActiveLowLogicCheckerWidgetState
    extends State<ActiveLowLogicCheckerWidget> {
  // true = Active-Low (Standard INPUT_PULLUP), false = Active-High (External pull-down)
  bool _isActiveLow = true;
  bool _isButtonPressed = false;

  bool _hasTriggeredActiveLow = false;
  bool _hasCompleted = false;

  void _pressButton() {
    setState(() {
      _isButtonPressed = !_isButtonPressed;
      if (_isButtonPressed) {
        final triggersLed = _isActiveLow; // in active low, pressed triggers
        if (triggersLed) {
          _hasTriggeredActiveLow = true;
        }
      }
      _checkCompletion();
    });
  }

  void _toggleLogicMode() {
    setState(() {
      _isActiveLow = !_isActiveLow;
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_hasTriggeredActiveLow && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  bool get _isLedOn {
    if (_isActiveLow) {
      // Active Low: pressed (LOW) triggers LED HIGH
      return _isButtonPressed;
    } else {
      // In active high: pressed (HIGH) triggers LED HIGH
      return _isButtonPressed;
    }
  }

  double get _pinVoltage {
    if (_isActiveLow) {
      return _isButtonPressed ? 0.0 : 5.0;
    } else {
      return _isButtonPressed ? 5.0 : 0.0;
    }
  }

  String get _digitalReadValue {
    if (_isActiveLow) {
      return _isButtonPressed ? 'LOW' : 'HIGH';
    } else {
      return _isButtonPressed ? 'HIGH' : 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Active-Low Logic Checker: if (digitalRead(pin) == LOW)';

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
                        'LOGIC VERIFIED',
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
            'With INPUT_PULLUP, unpressed reads HIGH (+5V) and pressed reads LOW (0V). '
            'Always evaluate if (digitalRead(pin) == LOW) to detect physical presses!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Action row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('active_low_press_button'),
                  onPressed: _pressButton,
                  icon: Icon(
                    _isButtonPressed
                        ? Icons.radio_button_checked
                        : Icons.touch_app,
                    color: Colors.black,
                  ),
                  label: Text(
                    _isButtonPressed
                        ? 'Release Button (Open)'
                        : 'Press Button (To GND)',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonPressed
                        ? AppColors.energyAmber
                        : AppColors.accentCyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('toggle_logic_mode'),
                  onPressed: _toggleLogicMode,
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: Text(
                    _isActiveLow ? 'Mode: Active-Low' : 'Mode: Active-High',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: _isActiveLow
                          ? AppColors.accentCyan
                          : AppColors.energyAmber,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Code Evaluation & Execution Visualizer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '// Real-Time C++ Code Execution Branch:',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: AppColors.syntaxComment,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCodeLine(
                  code:
                      'int buttonState = digitalRead(buttonPin); // => $_digitalReadValue',
                  isTargetBranch: false,
                ),
                const SizedBox(height: 4),
                _buildCodeLine(
                  code: _isActiveLow
                      ? 'if (buttonState == LOW) {'
                      : 'if (buttonState == HIGH) {',
                  isTargetBranch: false,
                ),
                _buildCodeLine(
                  code:
                      '  digitalWrite(LED_BUILTIN, HIGH); // ACTION: Turn LED ON',
                  isTargetBranch: _isLedOn,
                  indent: 16,
                  accentColor: AppColors.energyAmber,
                ),
                _buildCodeLine(
                  code: '} else {',
                  isTargetBranch: false,
                ),
                _buildCodeLine(
                  code:
                      '  digitalWrite(LED_BUILTIN, LOW);  // IDLE: Turn LED OFF',
                  isTargetBranch: !_isLedOn,
                  indent: 16,
                  accentColor: AppColors.textSecondaryDark,
                ),
                _buildCodeLine(
                  code: '}',
                  isTargetBranch: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hardware Indicator Bench
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Row(
              children: [
                // Pin Voltage
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Pin D2',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondaryDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_pinVoltage.toStringAsFixed(1)} V',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _pinVoltage == 0.0
                              ? AppColors.energyAmber
                              : AppColors.accentCyan,
                        ),
                      ),
                    ],
                  ),
                ),

                // Digital read
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'digitalRead',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondaryDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _digitalReadValue,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _digitalReadValue == 'LOW'
                              ? AppColors.energyAmber
                              : AppColors.accentCyan,
                        ),
                      ),
                    ],
                  ),
                ),

                // LED status
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Pin 13 LED',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondaryDark),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: _isLedOn
                                ? AppColors.energyAmber
                                : Colors.white24,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _isLedOn ? 'LIT (HIGH)' : 'OFF (LOW)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: _isLedOn
                                    ? AppColors.energyAmber
                                    : Colors.white54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

  Widget _buildCodeLine({
    required String code,
    required bool isTargetBranch,
    double indent = 0,
    Color accentColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.only(left: indent, top: 2, bottom: 2, right: 6),
      decoration: BoxDecoration(
        color: isTargetBranch
            ? accentColor.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          fontWeight: isTargetBranch ? FontWeight.bold : FontWeight.normal,
          color: isTargetBranch ? accentColor : Colors.white70,
        ),
      ),
    );
  }
}
