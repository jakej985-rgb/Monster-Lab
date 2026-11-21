import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class ClassificationItem {
  final String id;
  final String name;
  final String type; // 'input' or 'output'
  final String reason;
  final IconData icon;

  const ClassificationItem({
    required this.id,
    required this.name,
    required this.type,
    required this.reason,
    required this.icon,
  });

  factory ClassificationItem.fromJson(Map<String, dynamic> json) {
    IconData resolveIcon(String? name) {
      switch (name) {
        case 'smart_button':
        case 'button':
          return Icons.smart_button;
        case 'radar':
        case 'ultrasonic':
          return Icons.radar;
        case 'lightbulb':
        case 'led':
          return Icons.lightbulb;
        case 'volume_up':
        case 'buzzer':
          return Icons.volume_up;
        case 'tune':
        case 'potentiometer':
          return Icons.tune;
        case 'pin':
        case 'display':
          return Icons.pin;
        case 'precision_manufacturing':
        case 'motor':
        case 'servo':
          return Icons.precision_manufacturing;
        case 'mic':
        case 'sound':
          return Icons.mic;
        default:
          return Icons.extension;
      }
    }

    return ClassificationItem(
      id: json['id'] as String? ?? 'item',
      name: json['name'] as String? ?? 'Component',
      type: (json['type'] as String? ?? 'input').toLowerCase(),
      reason: json['reason'] as String? ?? '',
      icon: resolveIcon(json['icon'] as String?),
    );
  }
}

class InputOutputClassificationWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const InputOutputClassificationWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<InputOutputClassificationWidget> createState() =>
      _InputOutputClassificationWidgetState();
}

class _InputOutputClassificationWidgetState
    extends State<InputOutputClassificationWidget> {
  late List<ClassificationItem> _items;
  int _currentIndex = 0;
  bool? _isCorrect;
  int _correctCount = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  void _initItems() {
    if (widget.config != null && widget.config!['items'] is List) {
      final list = widget.config!['items'] as List;
      _items = list
          .whereType<Map<String, dynamic>>()
          .map((item) => ClassificationItem.fromJson(item))
          .toList();
    } else {
      _items = const [
        ClassificationItem(
          id: 'button',
          name: 'Pushbutton',
          type: 'input',
          reason:
              'Senses your physical touch and sends a signal into the Arduino.',
          icon: Icons.smart_button,
        ),
        ClassificationItem(
          id: 'ultrasonic',
          name: 'Ultrasonic Distance Sensor',
          type: 'input',
          reason:
              'Measures sound bounce distance and sends numbers to the Arduino.',
          icon: Icons.radar,
        ),
        ClassificationItem(
          id: 'led',
          name: 'LED Light',
          type: 'output',
          reason:
              'Arduino turns it ON or OFF to shine light and communicate with you.',
          icon: Icons.lightbulb,
        ),
        ClassificationItem(
          id: 'buzzer',
          name: 'Piezo Buzzer',
          type: 'output',
          reason:
              'Arduino sends electrical pulses to vibrate the disc and create sound.',
          icon: Icons.volume_up,
        ),
        ClassificationItem(
          id: 'potentiometer',
          name: 'Potentiometer Knob',
          type: 'input',
          reason:
              'Turning the knob sends variable voltage into an analog input pin.',
          icon: Icons.tune,
        ),
        ClassificationItem(
          id: 'display',
          name: '4-Digit Segment Display',
          type: 'output',
          reason:
              'Arduino commands specific segments to light up to display numbers.',
          icon: Icons.pin,
        ),
        ClassificationItem(
          id: 'motor',
          name: 'Servo Motor',
          type: 'output',
          reason:
              'Arduino sends timed pulses to rotate the motor shaft to a precise angle.',
          icon: Icons.precision_manufacturing,
        ),
        ClassificationItem(
          id: 'sound',
          name: 'Microphone Sound Sensor',
          type: 'input',
          reason:
              'Converts acoustic vibrations into electrical readings for the brain.',
          icon: Icons.mic,
        ),
      ];
    }
  }

  void _handleGuess(String guessType) {
    if (_isFinished) return;
    final currentItem = _items[_currentIndex];
    final correct = currentItem.type == guessType;

    setState(() {
      _isCorrect = correct;
      if (correct) {
        _correctCount++;
      }
    });

    if (correct && _currentIndex == _items.length - 1) {
      setState(() {
        _isFinished = true;
      });
      widget.onComplete?.call();
    }
  }

  void _nextItem() {
    if (_currentIndex < _items.length - 1) {
      setState(() {
        _currentIndex++;
        _isCorrect = null;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
      widget.onComplete?.call();
    }
  }

  void _reset() {
    setState(() {
      _currentIndex = 0;
      _isCorrect = null;
      _correctCount = 0;
      _isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final title = widget.config?['title'] as String? ??
        'Think Like a Robot: Input vs. Output';

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
                  color: AppColors.energyAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.category,
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
                    color: isDark
                        ? AppColors.energyAmber
                        : AppColors.textAmberOnLight,
                  ),
                ),
              ),
              if (_isFinished)
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
                        'CLASSIFIED',
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

          if (!_isFinished) ...[
            // Progress Bar
            Row(
              children: [
                Text(
                  'Component ${_currentIndex + 1} of ${_items.length}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Score: $_correctCount/${_items.length}',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.accentCyan
                        : AppColors.textCyanOnLight,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentIndex + 1) / _items.length,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.energyAmber),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),

            // Active Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isCorrect == null
                      ? const Color(0xFF334155)
                      : _isCorrect!
                          ? AppColors.success
                          : AppColors.danger,
                  width: _isCorrect == null ? 1 : 2,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.energyAmber),
                    ),
                    child: Icon(
                      _items[_currentIndex].icon,
                      size: 36,
                      color: AppColors.energyAmber,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _items[_currentIndex].name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Does this give information TO the Arduino (Input), or perform an action for the world (Output)?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Feedback Banner (if answered)
            if (_isCorrect != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isCorrect!
                      ? AppColors.success.withValues(alpha: 0.15)
                      : AppColors.danger.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _isCorrect! ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _isCorrect! ? Icons.check_circle : Icons.error_outline,
                      color: _isCorrect! ? AppColors.success : AppColors.danger,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isCorrect!
                                ? 'CORRECT! ${_items[_currentIndex].type.toUpperCase()}'
                                : 'NOT QUITE! ${_items[_currentIndex].name} is an ${_items[_currentIndex].type.toUpperCase()}',
                            style: TextStyle(
                              color: _isCorrect!
                                  ? AppColors.success
                                  : AppColors.danger,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _items[_currentIndex].reason,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Action Buttons
            if (_isCorrect == null || !_isCorrect!) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleGuess('input'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0984E3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_downward, size: 20),
                      label: const Text(
                        'INPUT\n(Sense Info)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _handleGuess('output'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C5CE7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_upward, size: 20),
                      label: const Text(
                        'OUTPUT\n(Perform Action)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _nextItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: Text(
                  _currentIndex < _items.length - 1
                      ? 'Next Component ➔'
                      : 'Complete Classification ➔',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ] else ...[
            // Finished Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.military_tech,
                    size: 48,
                    color: AppColors.energyAmber,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sensory Mastery Achieved!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You correctly categorized all ${_items.length} components. You now understand how robot brains perceive reality and manipulate physical mechanisms.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentCyan,
                      side: const BorderSide(color: AppColors.accentCyan),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Play Again'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
