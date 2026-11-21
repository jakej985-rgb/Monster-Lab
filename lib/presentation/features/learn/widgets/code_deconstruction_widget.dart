import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class CodeToken {
  final String text;
  final String type;
  final String role;
  final String detail;
  final Color color;

  const CodeToken({
    required this.text,
    required this.type,
    required this.role,
    required this.detail,
    required this.color,
  });
}

class CodeDeconstructionWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const CodeDeconstructionWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<CodeDeconstructionWidget> createState() =>
      _CodeDeconstructionWidgetState();
}

class _CodeDeconstructionWidgetState extends State<CodeDeconstructionWidget> {
  static const List<CodeToken> _tokens = [
    CodeToken(
      text: 'digitalWrite',
      type: 'Function Name',
      role: 'Hardware Action Verb',
      detail:
          'A built-in Arduino core function. It commands a specific digital pin to output either 5 Volts (HIGH) or 0 Volts (LOW).',
      color: AppColors.syntaxFunction,
    ),
    CodeToken(
      text: '(',
      type: 'Open Parenthesis',
      role: 'Parameter Opener',
      detail:
          'Contains the parameters (arguments) we give to the function: Which pin? And what state?',
      color: Colors.white70,
    ),
    CodeToken(
      text: '13',
      type: 'Integer Constant',
      role: 'Target Pin Number',
      detail:
          'The digital pin number on the board. Digital Pin 13 is connected internally to the Arduino Uno built-in LED!',
      color: AppColors.energyAmber,
    ),
    CodeToken(
      text: ',',
      type: 'Comma Separator',
      role: 'Argument Separator',
      detail:
          'Separates the first argument (pin 13) from the second argument (the voltage state).',
      color: Colors.white70,
    ),
    CodeToken(
      text: 'HIGH',
      type: 'State Constant',
      role: 'Output Voltage Level',
      detail:
          'Commands the microcontroller to connect Pin 13 to the positive +5V power rail, turning on the attached component.',
      color: AppColors.syntaxConstant,
    ),
    CodeToken(
      text: ')',
      type: 'Close Parenthesis',
      role: 'Parameter Closer',
      detail: 'Closes the parameter list for this function call.',
      color: Colors.white70,
    ),
    CodeToken(
      text: ';',
      type: 'Semicolon',
      role: 'Statement Terminator',
      detail:
          'Marks the end of an instruction in C++. It tells the compiler: "This thought is finished; execute it!"',
      color: AppColors.syntaxKeyword,
    ),
  ];

  int _selectedTokenIndex = 0;
  final Set<int> _inspectedTokens = {0};

  // Prediction state
  int? _predictionChoice; // 0 = Turn ON, 1 = Turn OFF, 2 = Blink
  bool _simulationRan = false;

  void _runSimulation() {
    setState(() {
      _simulationRan = true;
    });
    if (_predictionChoice == 0) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Code Anatomy: Deconstructing digitalWrite';
    final token = _tokens[_selectedTokenIndex];
    final allTokensInspected = _inspectedTokens.length == _tokens.length;

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
                  color: AppColors.syntaxFunction.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.data_object,
                  color: AppColors.syntaxFunction,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.syntaxFunction,
                  ),
                ),
              ),
              if (allTokensInspected &&
                  _simulationRan &&
                  _predictionChoice == 0)
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
                        'DECONSTRUCTED',
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
            'Never blindly copy code. Tap each token chip below to inspect its job in C++, then test your prediction!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Code Chips Interactive Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 8,
              children: List.generate(_tokens.length, (index) {
                final t = _tokens[index];
                final isSelected = index == _selectedTokenIndex;
                final isInspected = _inspectedTokens.contains(index);

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTokenIndex = index;
                      _inspectedTokens.add(index);
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? t.color.withValues(alpha: 0.25)
                          : (isInspected
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF161E2E)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? t.color : Colors.white24,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      t.text,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: t.color,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Token Details Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: token.color.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOKEN: ${token.text}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: token.color,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: token.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        token.type,
                        style: TextStyle(
                          color: token.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Role: ${token.role}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  token.detail,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Prediction & Execution Simulation
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.energyAmber),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.quiz, color: AppColors.energyAmber, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Prediction Challenge',
                      style: TextStyle(
                        color: AppColors.energyAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'If pin 13 is connected to the built-in LED, what do you predict this instruction will do?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(3, (index) {
                  final options = [
                    'Command the LED ON (+5V continuous)',
                    'Command the LED OFF (0V)',
                    'Make the LED flash like a strobe'
                  ];

                  final isSelected = _predictionChoice == index;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _predictionChoice = index;
                          _simulationRan = false;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.energyAmber.withValues(alpha: 0.2)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.energyAmber
                                : const Color(0xFF334155),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? AppColors.energyAmber
                                  : Colors.white54,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                options[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
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
                ElevatedButton.icon(
                  onPressed: _predictionChoice != null ? _runSimulation : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.energyAmber,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.play_circle, size: 20),
                  label: const Text(
                    'Simulate Instruction ➔',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (_simulationRan) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _predictionChoice == 0
                          ? AppColors.success.withValues(alpha: 0.15)
                          : AppColors.danger.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _predictionChoice == 0
                            ? AppColors.success
                            : AppColors.danger,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _predictionChoice == 0
                                ? const Color(0xFF00E676)
                                : const Color(0xFF334155),
                            boxShadow: _predictionChoice == 0
                                ? [
                                    const BoxShadow(
                                      color: Color(0xFF00E676),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.lightbulb,
                            color: _predictionChoice == 0
                                ? Colors.black87
                                : Colors.white38,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _predictionChoice == 0
                                ? 'Prediction Verified! digitalWrite(13, HIGH) powers the Pin 13 LED ON.'
                                : 'Notice the simulated LED! HIGH commands +5V, which turns the LED ON, not off or flashing.',
                            style: TextStyle(
                              color: _predictionChoice == 0
                                  ? AppColors.success
                                  : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
