import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class DecisionSimulatorWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const DecisionSimulatorWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<DecisionSimulatorWidget> createState() =>
      _DecisionSimulatorWidgetState();
}

class _DecisionSimulatorWidgetState extends State<DecisionSimulatorWidget> {
  bool _isButtonPressed = false;
  bool _hasInteracted = false;

  void _toggleButton() {
    setState(() {
      _isButtonPressed = !_isButtonPressed;
      _hasInteracted = true;
    });
    if (_hasInteracted) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Interactive Brain: Condition ➔ Decision ➔ Action';

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
                  color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Color(0xFF00E676),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00E676),
                  ),
                ),
              ),
              if (_hasInteracted)
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
                        'SIMULATED',
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
            'The brain does not guess; it follows logic. Press the tactile button below to see the three-part pipeline execute live!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Interactive Tactile Button Trigger
          Center(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isButtonPressed = true),
              onTapUp: (_) => setState(() {
                _isButtonPressed = false;
                _hasInteracted = true;
                widget.onComplete?.call();
              }),
              onTapCancel: () => setState(() => _isButtonPressed = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: _isButtonPressed
                      ? AppColors.energyAmber
                      : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isButtonPressed
                        ? AppColors.energyGold
                        : AppColors.energyAmber,
                    width: 2,
                  ),
                  boxShadow: _isButtonPressed
                      ? [
                          const BoxShadow(
                            color: AppColors.energyAmber,
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          const BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isButtonPressed
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _isButtonPressed
                          ? Colors.black87
                          : AppColors.energyAmber,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isButtonPressed
                          ? 'BUTTON PRESSED (HIGH)'
                          : 'HOLD TO PRESS BUTTON',
                      style: TextStyle(
                        color: _isButtonPressed ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _toggleButton,
              icon: Icon(
                _isButtonPressed ? Icons.lock_open : Icons.lock,
                size: 16,
                color: AppColors.accentCyan,
              ),
              label: Text(
                _isButtonPressed ? 'Unlock Button' : 'Toggle Lock (Hands-Free)',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Pipeline Visualization: 3 Stages
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isButtonPressed
                    ? const Color(0xFF00E676)
                    : const Color(0xFF334155),
              ),
            ),
            child: Column(
              children: [
                // Stage 1: Input
                _buildStageRow(
                  stage: '1. INPUT',
                  description: _isButtonPressed
                      ? 'Button contact closed ➔ Pin 2 receives 5.0V (HIGH)'
                      : 'Button released ➔ Pin 2 pulled to 0.0V (LOW)',
                  isActive: _isButtonPressed,
                  activeColor: AppColors.energyAmber,
                  icon: Icons.smart_button,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(Icons.arrow_downward,
                      color: Colors.white24, size: 16),
                ),

                // Stage 2: Decision / Program Code
                _buildStageRow(
                  stage: '2. DECISION',
                  description: _isButtonPressed
                      ? 'if (button == HIGH) evaluates to TRUE!'
                      : 'if (button == HIGH) evaluates to FALSE.',
                  isActive: true,
                  activeColor: AppColors.primaryViolet,
                  icon: Icons.code,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(Icons.arrow_downward,
                      color: Colors.white24, size: 16),
                ),

                // Stage 3: Action
                _buildStageRow(
                  stage: '3. ACTION',
                  description: _isButtonPressed
                      ? 'Executes: digitalWrite(13, HIGH); ➔ Pin 13 = 5V'
                      : 'Executes: digitalWrite(13, LOW); ➔ Pin 13 = 0V',
                  isActive: _isButtonPressed,
                  activeColor: const Color(0xFF00E676),
                  icon: Icons.lightbulb,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Output Indicator Bench
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isButtonPressed
                    ? const Color(0xFF00E676)
                    : const Color(0xFF475569),
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isButtonPressed
                        ? const Color(0xFF00E676)
                        : const Color(0xFF334155),
                    boxShadow: _isButtonPressed
                        ? [
                            const BoxShadow(
                              color: Color(0xFF00E676),
                              blurRadius: 16,
                              spreadRadius: 3,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    Icons.lightbulb,
                    color: _isButtonPressed ? Colors.black87 : Colors.white30,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isButtonPressed
                            ? 'Built-in LED: SHINING BRIGHT!'
                            : 'Built-in LED: OFF (Waiting for trigger)',
                        style: TextStyle(
                          color: _isButtonPressed
                              ? const Color(0xFF00E676)
                              : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isButtonPressed
                            ? 'The brain sensed the press, ran the code, and activated the output.'
                            : 'Release button to turn LED off. Microcontrollers act instantly in microseconds.',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
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

  Widget _buildStageRow({
    required String stage,
    required String description,
    required bool isActive,
    required Color activeColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.15)
            : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? activeColor : const Color(0xFF334155),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : Colors.white38,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            stage,
            style: TextStyle(
              color: isActive ? activeColor : Colors.white60,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white60,
                fontSize: 12,
                fontFamily:
                    stage.contains('DECISION') || stage.contains('ACTION')
                        ? 'monospace'
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
