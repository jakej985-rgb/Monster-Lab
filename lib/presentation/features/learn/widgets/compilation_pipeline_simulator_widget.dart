import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class CompileStage {
  final String title;
  final String tool;
  final String description;
  final String artifact;
  final IconData icon;
  final Color color;

  const CompileStage({
    required this.title,
    required this.tool,
    required this.description,
    required this.artifact,
    required this.icon,
    required this.color,
  });
}

class CompilationPipelineSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const CompilationPipelineSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<CompilationPipelineSimulatorWidget> createState() =>
      _CompilationPipelineSimulatorWidgetState();
}

class _CompilationPipelineSimulatorWidgetState
    extends State<CompilationPipelineSimulatorWidget> {
  static const List<CompileStage> _stages = [
    CompileStage(
      title: '1. Human Source Code',
      tool: 'Arduino IDE Editor',
      description:
          'You write human-readable C++ instructions with setup() and loop().',
      artifact:
          'void setup() {\n  pinMode(13, OUTPUT);\n  digitalWrite(13, HIGH);\n}',
      icon: Icons.edit_note,
      color: AppColors.accentCyan,
    ),
    CompileStage(
      title: '2. Syntax Verification',
      tool: 'C++ Lexer & Parser',
      description:
          'Checks grammar, matches curly braces { }, and ensures semicolons ; are present.',
      artifact:
          'Status: 0 Syntax Errors found. Types & function signatures verified.',
      icon: Icons.fact_check,
      color: AppColors.energyAmber,
    ),
    CompileStage(
      title: '3. Machine Compilation',
      tool: 'avr-gcc Compiler',
      description:
          'Translates human code into raw hexadecimal machine instructions (opcodes) that ATmega328P silicon can run.',
      artifact:
          ':100000000C9434000C9449000C9449000C94490040\n:100010000C9449000C9449000C9449000C94490018\nBinary size: 924 bytes (2% of Flash)',
      icon: Icons.memory,
      color: AppColors.primaryViolet,
    ),
    CompileStage(
      title: '4. USB Flash Upload',
      tool: 'avrdude Flasher',
      description:
          'Transmits the compiled hex bytes over USB serial packets to the Arduino bootloader.',
      artifact:
          'Writing | ################################## | 100% 0.18s\navrdude: 924 bytes of flash verified',
      icon: Icons.usb,
      color: Color(0xFF00E676),
    ),
    CompileStage(
      title: '5. Microcontroller Boot',
      tool: 'ATmega328P Hardware',
      description:
          'Microcontroller writes bytes into non-volatile Flash ROM, executes setup(), and begins your sketch!',
      artifact:
          'Microcontroller running at 16 MHz. Built-in LED on Pin 13 is lit!',
      icon: Icons.rocket_launch,
      color: Color(0xFF00CEC9),
    ),
  ];

  int _currentStageIndex = 0;
  bool _isAutoCompiling = false;
  bool _hasCompleted = false;

  void _stepForward() {
    if (_currentStageIndex < _stages.length - 1) {
      setState(() {
        _currentStageIndex++;
      });
      if (_currentStageIndex == _stages.length - 1) {
        setState(() {
          _hasCompleted = true;
        });
        widget.onComplete?.call();
      }
    }
  }

  Future<void> _runFullPipeline() async {
    if (_isAutoCompiling) return;
    setState(() {
      _isAutoCompiling = true;
      _currentStageIndex = 0;
    });

    for (int i = 0; i < _stages.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      setState(() {
        _currentStageIndex = i;
      });
    }

    setState(() {
      _isAutoCompiling = false;
      _hasCompleted = true;
    });
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Compilation & Upload Pipeline: Code ➔ Hex ➔ Silicon';
    final stage = _stages[_currentStageIndex];

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
                  color: stage.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.precision_manufacturing,
                  color: stage.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: stage.color,
                  ),
                ),
              ),
              if (_hasCompleted)
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
                        'COMPILED',
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
            'The computer does NOT send your English words to the chip. It translates your C++ instructions into binary numbers. Walk through the 5 phases below:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // Progress Nodes (Responsive Wrap - No side scrolling)
          Wrap(
            spacing: 6,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: List.generate(_stages.length, (index) {
              final s = _stages[index];
              final isPassed = index <= _currentStageIndex;
              final isCurrent = index == _currentStageIndex;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _isAutoCompiling
                        ? null
                        : () {
                            setState(() {
                              _currentStageIndex = index;
                            });
                            if (index == _stages.length - 1) {
                              setState(() {
                                _hasCompleted = true;
                              });
                              widget.onComplete?.call();
                            }
                          },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? s.color.withValues(alpha: 0.25)
                            : (isPassed
                                ? const Color(0xFF1E293B)
                                : const Color(0xFF0F172A)),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent
                              ? s.color
                              : (isPassed
                                  ? Colors.white38
                                  : const Color(0xFF334155)),
                          width: isCurrent ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            s.icon,
                            size: 16,
                            color: isCurrent ? s.color : Colors.white60,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Step ${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrent ? Colors.white : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < _stages.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: index < _currentStageIndex
                            ? AppColors.accentCyan
                            : Colors.white24,
                      ),
                    ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),

          // Active Stage Visual Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: stage.color.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(stage.icon, color: stage.color, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          stage.title,
                          style: TextStyle(
                            color: stage.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: stage.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        stage.tool,
                        style: TextStyle(
                          color: stage.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stage.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),

                // Artifact Box
                const Text(
                  'Artifact Output:',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Text(
                    stage.artifact,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: AppColors.syntaxString,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Control Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isAutoCompiling ? null : _runFullPipeline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryViolet,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    _isAutoCompiling ? Icons.hourglass_top : Icons.play_arrow,
                    size: 18,
                  ),
                  label: Text(
                    _isAutoCompiling
                        ? 'Simulating Pipeline...'
                        : 'Simulate Verify & Upload ➔',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed:
                    _isAutoCompiling || _currentStageIndex >= _stages.length - 1
                        ? null
                        : _stepForward,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentCyan,
                  side: const BorderSide(color: AppColors.accentCyan),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Next Step ➔'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
