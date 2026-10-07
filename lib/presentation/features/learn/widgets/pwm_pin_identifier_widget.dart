import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class UnoPinInfo {
  final int pinNumber;
  final bool hasPwm;
  final String timerName;
  final int? frequencyHz;
  final String description;

  const UnoPinInfo({
    required this.pinNumber,
    required this.hasPwm,
    required this.timerName,
    this.frequencyHz,
    required this.description,
  });
}

/// Interactive Arduino Uno PWM pinout identifier and timer frequency inspector.
/// Highlights PWM pins with tildes (~: 3, 5, 6, 9, 10, 11), hardware timers
/// (Timer0 @ 980Hz, Timer1 @ 490Hz, Timer2 @ 490Hz), and non-PWM threshold trap pins.
class PwmPinIdentifierWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const PwmPinIdentifierWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<PwmPinIdentifierWidget> createState() => _PwmPinIdentifierWidgetState();
}

class _PwmPinIdentifierWidgetState extends State<PwmPinIdentifierWidget> {
  static const List<UnoPinInfo> _pins = [
    UnoPinInfo(
      pinNumber: 0,
      hasPwm: false,
      timerName: 'None (UART RX)',
      description:
          'Standard Digital I/O and Serial RX. Calling analogWrite(0, val) only produces binary ON/OFF.',
    ),
    UnoPinInfo(
      pinNumber: 1,
      hasPwm: false,
      timerName: 'None (UART TX)',
      description:
          'Standard Digital I/O and Serial TX. No hardware PWM timer connection.',
    ),
    UnoPinInfo(
      pinNumber: 2,
      hasPwm: false,
      timerName: 'None (External INT0)',
      description:
          'Standard Digital I/O and hardware interrupt. No PWM capability.',
    ),
    UnoPinInfo(
      pinNumber: 3,
      hasPwm: true,
      timerName: 'Timer2 (8-bit)',
      frequencyHz: 490,
      description:
          'PWM Pin (~3): Driven by 8-bit Timer2 at 490 Hz base carrier frequency.',
    ),
    UnoPinInfo(
      pinNumber: 4,
      hasPwm: false,
      timerName: 'None',
      description: 'Standard Digital I/O only. No hardware PWM timer.',
    ),
    UnoPinInfo(
      pinNumber: 5,
      hasPwm: true,
      timerName: 'Timer0 (8-bit)',
      frequencyHz: 980,
      description:
          'PWM Pin (~5): Driven by Timer0 at 980 Hz (double speed!). Timer0 also drives millis() and delay().',
    ),
    UnoPinInfo(
      pinNumber: 6,
      hasPwm: true,
      timerName: 'Timer0 (8-bit)',
      frequencyHz: 980,
      description:
          'PWM Pin (~6): Driven by Timer0 at 980 Hz (double speed!). Ideal for fast motor control.',
    ),
    UnoPinInfo(
      pinNumber: 7,
      hasPwm: false,
      timerName: 'None',
      description: 'Standard Digital I/O only. No hardware PWM timer.',
    ),
    UnoPinInfo(
      pinNumber: 8,
      hasPwm: false,
      timerName: 'None',
      description:
          'Standard Digital I/O only. Common trap: analogWrite(8, 128) outputs binary 5V, not 50% PWM!',
    ),
    UnoPinInfo(
      pinNumber: 9,
      hasPwm: true,
      timerName: 'Timer1 (16-bit)',
      frequencyHz: 490,
      description:
          'PWM Pin (~9): Driven by the precision 16-bit Timer1 peripheral at 490 Hz.',
    ),
    UnoPinInfo(
      pinNumber: 10,
      hasPwm: true,
      timerName: 'Timer1 (16-bit)',
      frequencyHz: 490,
      description:
          'PWM Pin (~10): Driven by Timer1 at 490 Hz. Also serves as SPI Chip Select (SS).',
    ),
    UnoPinInfo(
      pinNumber: 11,
      hasPwm: true,
      timerName: 'Timer2 (8-bit)',
      frequencyHz: 490,
      description:
          'PWM Pin (~11): Driven by Timer2 at 490 Hz. Also serves as SPI MOSI.',
    ),
    UnoPinInfo(
      pinNumber: 12,
      hasPwm: false,
      timerName: 'None (SPI MISO)',
      description: 'Standard Digital I/O only. No hardware PWM timer.',
    ),
    UnoPinInfo(
      pinNumber: 13,
      hasPwm: false,
      timerName: 'None (Built-in LED / SCK)',
      description:
          'Standard Digital I/O wired to on-board "L" LED. Does NOT support hardware PWM!',
    ),
  ];

  int _selectedPin = 9;
  final Set<int> _inspectedPwmPins = {};
  bool _hasCompleted = false;

  static const List<int> _allPwmPins = [3, 5, 6, 9, 10, 11];

  void _inspectPin(int pinNum) {
    setState(() {
      _selectedPin = pinNum;
      if (_allPwmPins.contains(pinNum)) {
        _inspectedPwmPins.add(pinNum);
      }
      _checkCompletion();
    });
  }

  void _checkCompletion() {
    if (_inspectedPwmPins.length >= _allPwmPins.length && !_hasCompleted) {
      _hasCompleted = true;
      widget.onComplete?.call();
    }
  }

  void _checkAllPwmPins() {
    setState(() {
      _inspectedPwmPins.addAll(_allPwmPins);
      _checkCompletion();
    });
  }

  @override
  void initState() {
    super.initState();
    _inspectedPwmPins.add(9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Uno PWM Pin Identifier (~ Tilde) & Timer Map';

    final active = _pins.firstWhere((p) => p.pinNumber == _selectedPin);
    final allFound = _inspectedPwmPins.length >= _allPwmPins.length;

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
                  color: allFound
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.primaryViolet.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        allFound ? AppColors.success : AppColors.primaryViolet,
                  ),
                ),
                child: Text(
                  'PWM PINS: ${_inspectedPwmPins.length} / ${_allPwmPins.length} FOUND',
                  style: TextStyle(
                    color: allFound ? AppColors.success : AppColors.accentCyan,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            'Only 6 of the Uno\'s 14 digital pins support PWM. Look for the tilde symbol (~) next to pins 3, 5, 6, 9, 10, and 11. '
            'Pins 5 and 6 run at 980 Hz (Timer0), while pins 3, 9, 10, and 11 run at 490 Hz.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 16),

          // Uno Pin Header Visual Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceContainerDark),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.developer_board,
                        size: 16, color: AppColors.accentCyan),
                    SizedBox(width: 6),
                    Text(
                      'Arduino Uno Digital Pin Header (Pins 13 down to 0):',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Digital Pin Sockets (Responsive Wrap - No side scrolling)
                Wrap(
                  spacing: 4,
                  runSpacing: 6,
                  children: [
                    for (int i = 13; i >= 0; i--) _buildPinSocket(i),
                  ],
                ),
                const Divider(
                    height: 24, color: AppColors.surfaceContainerDark),

                // Selected Pin Technical Breakdown
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active.hasPwm
                          ? AppColors.accentCyan
                          : Colors.grey.shade800,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Digital Pin ${active.pinNumber}${active.hasPwm ? " (~)" : ""}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: active.hasPwm
                                      ? AppColors.accentCyan
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: active.hasPwm
                                      ? AppColors.success.withValues(alpha: 0.3)
                                      : Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  active.hasPwm ? 'PWM CAPABLE' : 'NO PWM',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: active.hasPwm
                                        ? AppColors.success
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (active.frequencyHz != null)
                            Text(
                              '${active.frequencyHz} Hz',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                color: AppColors.energyAmber,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Hardware Timer: ${active.timerName}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryDark,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        active.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Shortcut button to check all
          ElevatedButton.icon(
            key: const Key('pwm_check_all_button'),
            onPressed: _checkAllPwmPins,
            icon: const Icon(Icons.playlist_add_check),
            label: const Text(
                'Highlight All 6 PWM Pins (~3, ~5, ~6, ~9, ~10, ~11)'),
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
                      'Uno PWM Hardware Map Mastered! All 6 PWM pins identified with timer frequencies.',
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

  Widget _buildPinSocket(int pinNum) {
    final info = _pins.firstWhere((p) => p.pinNumber == pinNum);
    final isSelected = _selectedPin == pinNum;
    final isPwm = info.hasPwm;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        key: Key('pwm_pin_$pinNum'),
        onTap: () => _inspectPin(pinNum),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 38,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryViolet
                : isPwm
                    ? AppColors.accentCyanDark.withValues(alpha: 0.3)
                    : AppColors.surfaceContainerDark,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected
                  ? Colors.white
                  : isPwm
                      ? AppColors.accentCyan
                      : Colors.grey.shade700,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                isPwm ? '~$pinNum' : '$pinNum',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: isSelected
                      ? Colors.white
                      : isPwm
                          ? AppColors.accentCyan
                          : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPwm ? AppColors.accentCyan : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
