import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class InteractiveTroubleshootingWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const InteractiveTroubleshootingWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<InteractiveTroubleshootingWidget> createState() =>
      _InteractiveTroubleshootingWidgetState();
}

class _InteractiveTroubleshootingWidgetState
    extends State<InteractiveTroubleshootingWidget> {
  int _currentWirePin = 12; // Start on wrong pin 12
  bool _isRepaired = false;
  int?
      _diagnosisChoice; // 0 = code wrong, 1 = wire mismatch (correct), 2 = dead board

  void _moveWireToPin13() {
    setState(() {
      _currentWirePin = 13;
      _isRepaired = true;
    });
    widget.onComplete?.call();
  }

  void _reset() {
    setState(() {
      _currentWirePin = 12;
      _isRepaired = false;
      _diagnosisChoice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Troubleshooting Lab: The Silent LED';

    return MonsterCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.build_circle,
                  color: AppColors.energyAmber,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.energyAmber,
                  ),
                ),
              ),
              if (_isRepaired)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        'BUG FIXED',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'A learner cries: "My code uploaded, but my LED will not turn on!" Practice the 4-step diagnostic triage to find and fix the glitch.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Side-by-side inspection: Code vs Hardware
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    _isRepaired ? AppColors.success : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tab Labels
                const Row(
                  children: [
                    Icon(Icons.terminal,
                        color: AppColors.syntaxFunction, size: 16),
                    SizedBox(width: 6),
                    Text(
                      '1. Uploaded Arduino Sketch',
                      style: TextStyle(
                        color: AppColors.syntaxFunction,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                            text: 'void setup() {\n  pinMode(',
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: '13',
                            style: TextStyle(
                              color: AppColors.energyAmber,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: ', OUTPUT);\n  digitalWrite(',
                            style: TextStyle(color: Colors.white)),
                        TextSpan(
                            text: '13',
                            style: TextStyle(
                              color: AppColors.energyAmber,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text:
                                ', HIGH); // Command Pin 13 ON\n}\nvoid loop() {}',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Hardware Inspection Row
                Row(
                  children: [
                    const Icon(Icons.memory,
                        color: AppColors.accentCyan, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      '2. Board Header Pins Inspection',
                      style: TextStyle(
                        color: AppColors.accentCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _currentWirePin == 13
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.danger.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _currentWirePin == 13
                            ? 'WIRE IN PIN 13 (MATCH!)'
                            : 'WIRE IN PIN 12 (MISMATCH!)',
                        style: TextStyle(
                          color: _currentWirePin == 13
                              ? AppColors.success
                              : AppColors.danger,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Pin Header Visualizer
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF475569)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPinHeaderSlot(pinNum: 10, hasWire: false),
                      _buildPinHeaderSlot(pinNum: 11, hasWire: false),
                      _buildPinHeaderSlot(
                          pinNum: 12, hasWire: _currentWirePin == 12),
                      _buildPinHeaderSlot(
                          pinNum: 13, hasWire: _currentWirePin == 13),
                      _buildPinHeaderSlot(
                          pinNum: 0, label: 'GND', hasWire: true, isGnd: true),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // LED Status Bar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isRepaired
                        ? const Color(0xFF00E676).withValues(alpha: 0.15)
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isRepaired
                          ? const Color(0xFF00E676)
                          : const Color(0xFF334155),
                    ),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRepaired
                              ? const Color(0xFF00E676)
                              : const Color(0xFF334155),
                          boxShadow: _isRepaired
                              ? [
                                  const BoxShadow(
                                    color: Color(0xFF00E676),
                                    blurRadius: 14,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: _isRepaired ? Colors.black87 : Colors.white24,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isRepaired
                              ? 'LED IS LIT! 5V flows from Pin 13 into the anode.'
                              : 'LED is dark. Pin 12 has 0V because code commanded Pin 13.',
                          style: TextStyle(
                            color: _isRepaired
                                ? const Color(0xFF00E676)
                                : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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

          // Triage Diagnostic Question
          if (!_isRepaired) ...[
            const Text(
              'Diagnostic Triage: What is causing the problem?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(3, (index) {
              final labels = [
                'The code has a syntax compilation error',
                'Pin Mismatch: Code commands Pin 13, but the jumper wire is plugged into Pin 12!',
                'The Arduino microcontroller is burned out and broken'
              ];

              final isSelected = _diagnosisChoice == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _diagnosisChoice = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (index == 1
                              ? AppColors.success.withValues(alpha: 0.2)
                              : AppColors.danger.withValues(alpha: 0.2))
                          : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? (index == 1
                                ? AppColors.success
                                : AppColors.danger)
                            : const Color(0xFF334155),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? (index == 1 ? Icons.check_circle : Icons.cancel)
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? (index == 1
                                  ? AppColors.success
                                  : AppColors.danger)
                              : Colors.white54,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),

            // Action: Fix Wire
            ElevatedButton.icon(
              onPressed: _diagnosisChoice == 1 ? _moveWireToPin13 : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.cable, size: 20),
              label: const Text(
                'Move Wire from Pin 12 ➔ Pin 13',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success),
              ),
              child: Column(
                children: [
                  const Text(
                    'Troubleshooting Lesson Mastered!',
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Always compare your code pin numbers against your physical jumper wires. 90% of beginner electronics bugs are simple pin mismatches!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentCyan,
                      side: const BorderSide(color: AppColors.accentCyan),
                    ),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPinHeaderSlot({
    required int pinNum,
    String? label,
    required bool hasWire,
    bool isGnd = false,
  }) {
    final displayLabel = label ?? 'Pin $pinNum';
    final wireColor = isGnd ? Colors.grey : AppColors.wirePower5V;

    return Column(
      children: [
        Text(
          displayLabel,
          style: TextStyle(
            color: hasWire
                ? (isGnd ? Colors.white70 : AppColors.energyAmber)
                : Colors.white38,
            fontSize: 11,
            fontWeight: hasWire ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: hasWire ? wireColor : const Color(0xFF334155),
              width: hasWire ? 2 : 1,
            ),
          ),
          child: Center(
            child: hasWire
                ? Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: wireColor,
                    ),
                  )
                : Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E293B),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hasWire ? (isGnd ? 'Black Wire' : 'Red Wire') : 'Empty',
          style: TextStyle(
            color: hasWire ? wireColor : Colors.white30,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
