import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class BoardLandmark {
  final String id;
  final String label;
  final String hint;
  final IconData icon;

  const BoardLandmark({
    required this.id,
    required this.label,
    required this.hint,
    required this.icon,
  });

  factory BoardLandmark.fromJson(Map<String, dynamic> json) {
    IconData resolveIcon(String id) {
      switch (id) {
        case 'usb':
          return Icons.usb;
        case 'dc_jack':
          return Icons.power;
        case 'digital_pins':
          return Icons.pin;
        case 'analog_pins':
          return Icons.show_chart;
        case 'power_5v':
          return Icons.bolt;
        case 'gnd':
          return Icons.arrow_downward;
        case 'reset':
          return Icons.restart_alt;
        case 'builtin_led':
          return Icons.lightbulb;
        default:
          return Icons.place;
      }
    }

    final id = json['id'] as String? ?? 'landmark';
    return BoardLandmark(
      id: id,
      label: json['label'] as String? ?? 'Landmark',
      hint: json['hint'] as String? ?? '',
      icon: resolveIcon(id),
    );
  }
}

class BoardLabelDragDropWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const BoardLabelDragDropWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<BoardLabelDragDropWidget> createState() =>
      _BoardLabelDragDropWidgetState();
}

class _BoardLabelDragDropWidgetState extends State<BoardLabelDragDropWidget> {
  late List<BoardLandmark> _landmarks;
  final Map<String, String> _placedMatches = {}; // landmarkId -> label
  String? _selectedBadgeId;
  bool _isAllComplete = false;

  @override
  void initState() {
    super.initState();
    _initLandmarks();
  }

  void _initLandmarks() {
    if (widget.config != null && widget.config!['targets'] is List) {
      final list = widget.config!['targets'] as List;
      _landmarks = list
          .whereType<Map<String, dynamic>>()
          .map((item) => BoardLandmark.fromJson(item))
          .toList();
    } else {
      _landmarks = const [
        BoardLandmark(
          id: 'usb',
          label: 'USB Connection',
          hint: 'Silver port that links to PC for flashing code & 5V power',
          icon: Icons.usb,
        ),
        BoardLandmark(
          id: 'dc_jack',
          label: 'DC Power Barrel Jack',
          hint: 'Black round port for external 9V battery or wall adapter',
          icon: Icons.power,
        ),
        BoardLandmark(
          id: 'digital_pins',
          label: 'Digital Pins (0–13)',
          hint: 'Top header pins sending & receiving binary HIGH/LOW',
          icon: Icons.pin,
        ),
        BoardLandmark(
          id: 'analog_pins',
          label: 'Analog Pins (A0–A5)',
          hint: 'Bottom right pins reading smooth variable voltages',
          icon: Icons.show_chart,
        ),
        BoardLandmark(
          id: 'power_5v',
          label: '5V Power Pin',
          hint: 'Positive power supply pin for chips and breadboards',
          icon: Icons.bolt,
        ),
        BoardLandmark(
          id: 'gnd',
          label: 'GND (Ground) Pins',
          hint: 'Essential 0V reference and return path for current',
          icon: Icons.arrow_downward,
        ),
        BoardLandmark(
          id: 'reset',
          label: 'Reset Button',
          hint: 'Small push button that restarts sketch from setup()',
          icon: Icons.restart_alt,
        ),
        BoardLandmark(
          id: 'builtin_led',
          label: 'Built-in LED (Pin 13)',
          hint: 'Tiny surface-mount amber LED on the board itself',
          icon: Icons.lightbulb,
        ),
      ];
    }
  }

  void _handleMatch(String landmarkId, String badgeId) {
    if (landmarkId == badgeId) {
      setState(() {
        _placedMatches[landmarkId] = badgeId;
        _selectedBadgeId = null;
        if (_placedMatches.length == _landmarks.length) {
          _isAllComplete = true;
        }
      });
      if (_placedMatches.length == _landmarks.length) {
        widget.onComplete?.call();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Try again! Read the hint on the slot.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.energyAmber,
          duration: Duration(milliseconds: 1400),
        ),
      );
    }
  }

  void _reset() {
    setState(() {
      _placedMatches.clear();
      _selectedBadgeId = null;
      _isAllComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Hardware Mission: Board Landmarks Match';

    // Badges that haven't been placed yet
    final unplaced =
        _landmarks.where((l) => !_placedMatches.containsKey(l.id)).toList();

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
                  color: AppColors.primaryViolet.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.developer_board,
                  color: AppColors.primaryViolet,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryViolet,
                  ),
                ),
              ),
              if (_isAllComplete)
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
                        'ALL FOUND',
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
            _isAllComplete
                ? 'Mission Complete! You identified all 8 key landmarks on the Arduino Uno.'
                : 'Tap a label badge below, then tap its matching board target slot (or drag onto target).',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Landmarks Identified: ${_placedMatches.length} / ${_landmarks.length}',
                style: const TextStyle(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (!_isAllComplete && _selectedBadgeId != null)
                Text(
                  'Selected: ${_landmarks.firstWhere((l) => l.id == _selectedBadgeId).label}',
                  style: const TextStyle(
                    color: AppColors.energyAmber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _placedMatches.length / _landmarks.length,
              backgroundColor: const Color(0xFF1E293B),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryViolet),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),

          // Target Slots List
          ..._landmarks.map((landmark) {
            final isMatched = _placedMatches.containsKey(landmark.id);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DragTarget<String>(
                onWillAcceptWithDetails: (details) => !isMatched,
                onAcceptWithDetails: (details) {
                  _handleMatch(landmark.id, details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovering = candidateData.isNotEmpty;

                  return InkWell(
                    onTap: () {
                      if (!isMatched && _selectedBadgeId != null) {
                        _handleMatch(landmark.id, _selectedBadgeId!);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMatched
                            ? AppColors.success.withValues(alpha: 0.15)
                            : isHovering
                                ? AppColors.accentCyan.withValues(alpha: 0.2)
                                : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isMatched
                              ? AppColors.success
                              : isHovering
                                  ? AppColors.accentCyan
                                  : const Color(0xFF334155),
                          width: isMatched || isHovering ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isMatched ? Icons.check_circle : landmark.icon,
                            color: isMatched
                                ? AppColors.success
                                : AppColors.accentCyan,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isMatched
                                      ? '✓ ${landmark.label}'
                                      : 'Target: ${landmark.hint}',
                                  style: TextStyle(
                                    color: isMatched
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: isMatched
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isMatched)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: const Color(0xFF475569)),
                              ),
                              child: const Text(
                                'Tap to Match',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 14),

          // Label Badges Tray (Available for dragging or tapping)
          if (!_isAllComplete) ...[
            const Text(
              'Label Badges Tray:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: unplaced.map((badge) {
                final isSelected = _selectedBadgeId == badge.id;

                final badgeContent = Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.energyAmber
                        : const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.energyGold
                          : AppColors.accentCyan,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        badge.icon,
                        size: 16,
                        color: isSelected ? Colors.black87 : Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        badge.label,
                        style: TextStyle(
                          color: isSelected ? Colors.black87 : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );

                return Draggable<String>(
                  data: badge.id,
                  feedback: Material(
                    color: Colors.transparent,
                    child: badgeContent,
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: badgeContent,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedBadgeId = isSelected ? null : badge.id;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: badgeContent,
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            OutlinedButton.icon(
              onPressed: _reset,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryViolet,
                side: const BorderSide(color: AppColors.primaryViolet),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Mission'),
            ),
          ],
        ],
      ),
    );
  }
}
