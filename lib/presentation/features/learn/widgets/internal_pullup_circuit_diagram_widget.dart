import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

/// Interactive schematic toggle illustrating the ATmega328P internal 20kΩ pullup resistor,
/// active-low inverted logic, and current paths.
class InternalPullupCircuitDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const InternalPullupCircuitDiagramWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<InternalPullupCircuitDiagramWidget> createState() =>
      _InternalPullupCircuitDiagramWidgetState();
}

class _InternalPullupCircuitDiagramWidgetState
    extends State<InternalPullupCircuitDiagramWidget> {
  // true = pinMode(2, INPUT_PULLUP), false = pinMode(2, INPUT)
  bool _isPullupEnabled = true;
  // true = button contacts closed to GND, false = open/released
  bool _isButtonPressed = false;

  bool _hasPressedInPullup = false;
  bool _hasCompleted = false;

  void _togglePullupMode() {
    setState(() {
      _isPullupEnabled = !_isPullupEnabled;
      _checkCompletion();
    });
  }

  void _toggleButtonState() {
    setState(() {
      _isButtonPressed = !_isButtonPressed;
      if (_isButtonPressed && _isPullupEnabled) {
        _hasPressedInPullup = true;
      }
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_hasPressedInPullup && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  double get _pinVoltage {
    if (_isButtonPressed) return 0.0;
    if (_isPullupEnabled) return 5.0;
    return 2.5; // floating
  }

  String get _digitalReadState {
    if (_isButtonPressed) return 'LOW (0)';
    if (_isPullupEnabled) return 'HIGH (1)';
    return 'FLOATING (?)';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Internal Pull-Up Circuit & Active-Low Architecture';

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
                        'ACTIVE-LOW VERIFIED',
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
            'The ATmega328P has built-in ~20kΩ to 50kΩ pull-up resistors inside the silicon chip. '
            'Activating pinMode(pin, INPUT_PULLUP) eliminates external breadboard resistors!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Controls
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 450;
              final buttons = [
                ElevatedButton.icon(
                  key: const Key('toggle_pullup_button'),
                  onPressed: _togglePullupMode,
                  icon: Icon(
                    _isPullupEnabled ? Icons.toggle_on : Icons.toggle_off,
                    color: _isPullupEnabled
                        ? AppColors.accentCyan
                        : AppColors.textSecondaryDark,
                    size: 24,
                  ),
                  label: Text(
                    _isPullupEnabled
                        ? 'pinMode: INPUT_PULLUP'
                        : 'pinMode: INPUT',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPullupEnabled
                        ? AppColors.primaryViolet.withValues(alpha: 0.4)
                        : AppColors.surfaceContainerDark,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: _isPullupEnabled
                          ? AppColors.accentCyan
                          : Colors.white24,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  key: const Key('toggle_pushbutton'),
                  onPressed: _toggleButtonState,
                  icon: Icon(
                    _isButtonPressed
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color:
                        _isButtonPressed ? AppColors.energyAmber : Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    _isButtonPressed
                        ? 'Button: PRESSED (Closed to GND)'
                        : 'Button: RELEASED (Open)',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonPressed
                        ? AppColors.energyAmber.withValues(alpha: 0.3)
                        : AppColors.surfaceContainerDark,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: _isButtonPressed
                          ? AppColors.energyAmber
                          : Colors.white24,
                    ),
                  ),
                ),
              ];

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buttons[0],
                    const SizedBox(height: 8),
                    buttons[1],
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: buttons[0]),
                  const SizedBox(width: 10),
                  Expanded(child: buttons[1]),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Schematic Visualizer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top header of schematic
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _buildChipBadge(
                          'ATmega328P Silicon', AppColors.primaryViolet),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: _buildChipBadge(
                          'External Breadboard', AppColors.accentCyan),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Schematic Layout
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 540),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Silicon side
                        SizedBox(
                          width: 250,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isPullupEnabled
                                    ? AppColors.accentCyan
                                        .withValues(alpha: 0.5)
                                    : Colors.white12,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.bolt,
                                        color: AppColors.wirePower5V, size: 16),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '+5V VCC Internal Rail',
                                        style: TextStyle(
                                          color: AppColors.wirePower5V,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _isPullupEnabled
                                        ? AppColors.accentCyan
                                            .withValues(alpha: 0.2)
                                        : Colors.black26,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _isPullupEnabled
                                            ? Icons.link
                                            : Icons.link_off,
                                        color: _isPullupEnabled
                                            ? AppColors.accentCyan
                                            : Colors.white38,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          _isPullupEnabled
                                              ? 'Internal 20kΩ Resistor [ENGAGED]'
                                              : 'Internal Resistor [DISCONNECTED]',
                                          style: TextStyle(
                                            color: _isPullupEnabled
                                                ? AppColors.accentCyan
                                                : Colors.white38,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Schmitt Trigger Buffer ➔ CPU',
                                  style: TextStyle(
                                    color: AppColors.textSecondaryDark,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Pin D2 Connector
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.energyAmber
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border:
                                      Border.all(color: AppColors.energyAmber),
                                ),
                                child: const Text(
                                  'Pin D2',
                                  style: TextStyle(
                                    color: AppColors.energyAmber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const Icon(Icons.swap_horiz,
                                  color: Colors.white38, size: 20),
                            ],
                          ),
                        ),

                        // External switch side
                        SizedBox(
                          width: 240,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isButtonPressed
                                    ? AppColors.energyAmber
                                        .withValues(alpha: 0.5)
                                    : Colors.white12,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _isButtonPressed
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: _isButtonPressed
                                          ? AppColors.energyAmber
                                          : Colors.white60,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        _isButtonPressed
                                            ? 'Contacts Closed'
                                            : 'Contacts Open',
                                        style: TextStyle(
                                          color: _isButtonPressed
                                              ? AppColors.energyAmber
                                              : Colors.white70,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Row(
                                  children: [
                                    Icon(Icons.arrow_downward,
                                        color: AppColors.wireGround, size: 14),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        'GND Bus Rail (0.0 V)',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_isButtonPressed && _isPullupEnabled)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Current: 5V / 20kΩ = 0.25mA harmless drain',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 9,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Telemetry Readout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildTelemetryColumn(
                    label: 'Pin 2 Voltage',
                    value: '${_pinVoltage.toStringAsFixed(1)} V',
                    color: _isButtonPressed
                        ? AppColors.energyAmber
                        : (_isPullupEnabled
                            ? AppColors.accentCyan
                            : AppColors.danger),
                  ),
                ),
                Expanded(
                  child: _buildTelemetryColumn(
                    label: 'digitalRead(2)',
                    value: _digitalReadState,
                    color: _isButtonPressed
                        ? AppColors.energyAmber
                        : (_isPullupEnabled
                            ? AppColors.accentCyan
                            : AppColors.danger),
                  ),
                ),
                Expanded(
                  child: _buildTelemetryColumn(
                    label: 'Active-Low Meaning',
                    value: _isButtonPressed
                        ? 'ACTIVE (PRESSED)'
                        : 'IDLE (RELEASED)',
                    color:
                        _isButtonPressed ? AppColors.success : Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipBadge(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTelemetryColumn({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: color,
          ),
        ),
      ],
    );
  }
}
