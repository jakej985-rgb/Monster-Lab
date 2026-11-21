import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/models/code_experiment_model.dart';
import '../../../shared/widgets/monster_card.dart';
import 'arduino_syntax_highlighter.dart';

class GuidedCodeLabWidget extends StatefulWidget {
  final CodePreset preset;

  const GuidedCodeLabWidget({
    super.key,
    required this.preset,
  });

  @override
  State<GuidedCodeLabWidget> createState() => _GuidedCodeLabWidgetState();
}

class _GuidedCodeLabWidgetState extends State<GuidedCodeLabWidget> {
  late Map<String, int> _variableValues;
  Timer? _blinkTimer;
  bool _ledLit = false;
  CompilerErrorSample? _selectedError;

  @override
  void initState() {
    super.initState();
    _initVariables();
    _startLedSimulation();
  }

  @override
  void didUpdateWidget(covariant GuidedCodeLabWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preset.id != widget.preset.id) {
      _initVariables();
      _startLedSimulation();
    }
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  void _initVariables() {
    _variableValues = {
      for (final v in widget.preset.variables) v.name: v.currentValue,
    };
    _selectedError = null;
  }

  void _startLedSimulation() {
    _blinkTimer?.cancel();
    final delayMs = _variableValues['blinkDelay'] ?? 1000;
    _blinkTimer = Timer.periodic(Duration(milliseconds: delayMs), (_) {
      if (mounted) {
        setState(() => _ledLit = !_ledLit);
      }
    });
  }

  void _updateVariable(String name, int val) {
    setState(() {
      _variableValues[name] = val;
    });
    _startLedSimulation();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final renderedCode = widget.preset.renderCode(_variableValues);
    final delay = _variableValues['blinkDelay'] ?? 1000;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Description Card
        MonsterCard(
          color: AppColors.accentCyan.withValues(alpha: 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.preset.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentCyanDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.preset.description,
                style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Live Simulated Hardware Effect Preview Card
        MonsterCard(
          child: Row(
            children: [
              // Blinking LED indicator
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _ledLit
                      ? AppColors.energyAmber
                      : colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  boxShadow: _ledLit
                      ? [
                          BoxShadow(
                            color: AppColors.energyAmber.withValues(alpha: 0.6),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: _ledLit ? Colors.white : colorScheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Pin 13 LED State: ${_ledLit ? "HIGH (ON)" : "LOW (OFF)"}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Cycle interval: $delay ms (${(1000.0 / delay).toStringAsFixed(1)} Hz blink frequency)',
                      style: TextStyle(
                          fontSize: 12, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Interactive Variable Sliders
        for (final v in widget.preset.variables) ...[
          MonsterCard(
            color: colorScheme.surfaceContainerLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adjust ${v.label}:',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryViolet.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_variableValues[v.name]} ${v.unit}',
                        key: const Key('variable_value_label'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryViolet,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                Slider(
                  key: const Key('blink_delay_slider'),
                  value: (_variableValues[v.name] ?? v.currentValue).toDouble(),
                  min: v.minValue.toDouble(),
                  max: v.maxValue.toDouble(),
                  divisions: (v.maxValue - v.minValue) ~/ v.step,
                  onChanged: (newVal) =>
                      _updateVariable(v.name, newVal.toInt()),
                ),
                Text(
                  v.description,
                  style: TextStyle(
                      fontSize: 12, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Syntax-Highlighted Code Viewer Window
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E), // Dark IDE theme
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.code, color: AppColors.accentCyan, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'sketch.ino (Arduino C++)',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Ready to Compile',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 20),
              SelectableText.rich(
                TextSpan(
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white70,
                  ),
                  children: ArduinoSyntaxHighlighter.highlight(renderedCode),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Compiler Error Decoder Section
        const Text(
          'Kid-Friendly Compiler Error Decoder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Understand what cryptic C++ error messages actually mean and how to fix them.',
          style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.preset.errorSamples.map((sample) {
            final isSelected = _selectedError?.id == sample.id;
            return ChoiceChip(
              key: Key('error_sample_chip_${sample.id}'),
              label: Text(sample.title),
              selected: isSelected,
              onSelected: (val) {
                setState(() => _selectedError = val ? sample : null);
              },
            );
          }).toList(),
        ),

        if (_selectedError != null) ...[
          const SizedBox(height: 12),
          _buildErrorDecoderCard(_selectedError!),
        ],
      ],
    );
  }

  Widget _buildErrorDecoderCard(CompilerErrorSample sample) {
    final colorScheme = Theme.of(context).colorScheme;
    return MonsterCard(
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report, color: AppColors.danger, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  sample.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Raw compiler output snippet
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1E24),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              sample.rawCompilerOutput,
              style: const TextStyle(
                color: Color(0xFFFF7675),
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Plain English Kid Explanation
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: AppColors.accentCyan.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.translate,
                    size: 18, color: AppColors.accentCyanDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 13,
                          height: 1.3),
                      children: [
                        const TextSpan(
                          text: 'What this means in plain English: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentCyanDark),
                        ),
                        TextSpan(text: sample.kidExplanation),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Comparison: Buggy vs Fixed
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Buggy Code ❌',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.danger.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        sample.buggyCode,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fixed Code ✅',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        sample.fixedCode,
                        style: const TextStyle(
                            fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // The Science breakdown
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.science,
                    size: 18, color: AppColors.primaryViolet),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 12,
                          height: 1.3),
                      children: [
                        const TextSpan(
                          text: 'The Science: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryViolet),
                        ),
                        TextSpan(text: sample.theScience),
                      ],
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
}
