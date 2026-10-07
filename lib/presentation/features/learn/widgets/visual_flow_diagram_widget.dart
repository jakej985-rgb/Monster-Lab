import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class FlowNodeData {
  final String id;
  final String label;
  final IconData icon;
  final String role;
  final String example;
  final Color accentColor;

  const FlowNodeData({
    required this.id,
    required this.label,
    required this.icon,
    required this.role,
    required this.example,
    this.accentColor = AppColors.accentCyan,
  });

  factory FlowNodeData.fromJson(Map<String, dynamic> json) {
    IconData resolveIcon(String? name) {
      switch (name) {
        case 'sensors':
        case 'sensor':
          return Icons.sensors;
        case 'memory':
        case 'microcontroller':
          return Icons.memory;
        case 'code':
        case 'program':
          return Icons.code;
        case 'lightbulb':
        case 'output':
          return Icons.lightbulb;
        case 'volume_up':
          return Icons.volume_up;
        case 'precision_manufacturing':
          return Icons.precision_manufacturing;
        default:
          return Icons.device_hub;
      }
    }

    return FlowNodeData(
      id: json['id'] as String? ?? 'node',
      label: json['label'] as String? ?? 'Node',
      icon: resolveIcon(json['icon'] as String?),
      role: json['role'] as String? ?? '',
      example: json['example'] as String? ?? '',
      accentColor: json['color'] != null
          ? Color(int.parse(json['color'].toString().replaceFirst('#', '0xFF')))
          : AppColors.accentCyan,
    );
  }
}

class VisualFlowDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const VisualFlowDiagramWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<VisualFlowDiagramWidget> createState() =>
      _VisualFlowDiagramWidgetState();
}

class _VisualFlowDiagramWidgetState extends State<VisualFlowDiagramWidget>
    with SingleTickerProviderStateMixin {
  late List<FlowNodeData> _nodes;
  late int _selectedNodeIndex;
  late AnimationController _pulseController;
  int _activePulseIndex = -1;
  bool _hasCompletedPulse = false;

  @override
  void initState() {
    super.initState();
    _initNodes();
    _selectedNodeIndex = 0;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _pulseController.addListener(() {
      final step = (_pulseController.value * _nodes.length).floor();
      if (step != _activePulseIndex && step < _nodes.length) {
        setState(() {
          _activePulseIndex = step;
          _selectedNodeIndex = step;
        });
      }
    });

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _activePulseIndex = -1;
          _hasCompletedPulse = true;
        });
        widget.onComplete?.call();
      }
    });
  }

  void _initNodes() {
    if (widget.config != null && widget.config!['nodes'] is List) {
      final list = widget.config!['nodes'] as List;
      _nodes = list
          .whereType<Map<String, dynamic>>()
          .map((item) => FlowNodeData.fromJson(item))
          .toList();
    } else {
      _nodes = const [
        FlowNodeData(
          id: 'sensor',
          label: '1. SENSE\n(Sensor / Input)',
          icon: Icons.sensors,
          role:
              'Measures physical reality (light, sound, distance, or a button press) and converts it into voltage.',
          example: 'Pushbutton, Ultrasonic Distance Sensor, Potentiometer Knob',
          accentColor: AppColors.energyAmber,
        ),
        FlowNodeData(
          id: 'arduino',
          label: '2. TRANSMIT\n(Arduino Pins)',
          icon: Icons.memory,
          role:
              'Reads the electrical voltage on input pins and sends the numbers into CPU memory.',
          example: 'Digital Pins 0–13 (HIGH/LOW) or Analog Pins A0–A5 (0–1023)',
          accentColor: AppColors.accentCyan,
        ),
        FlowNodeData(
          id: 'program',
          label: '3. DECIDE\n(Program Logic)',
          icon: Icons.code,
          role:
              'Your C++ sketch evaluates conditions: if (sensor == pressed) then trigger action!',
          example: 'if (distance < 20) { stopRobot(); }',
          accentColor: AppColors.primaryViolet,
        ),
        FlowNodeData(
          id: 'output',
          label: '4. ACT\n(Actuator / Output)',
          icon: Icons.lightbulb,
          role:
              'Arduino commands an output pin HIGH (+5V) to power a component and change the world.',
          example: 'LED shines bright, Piezo buzzer beeps, Servo motor rotates',
          accentColor: Color(0xFF00E676),
        ),
      ];
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerPulse() {
    _pulseController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedNode = _nodes[_selectedNodeIndex];
    final title = widget.config?['title'] as String? ??
        'Interactive Signal Flow: Sense → Decide → Act';

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
                  color: AppColors.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.alt_route,
                  color: AppColors.accentCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
              if (_hasCompletedPulse)
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
                        'FLOW TESTED',
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
            'Tap any stage below to inspect how information travels, or press "Test Signal Pulse" to watch the robot think in real time!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Flow Nodes Strip (Adaptive: Vertical on mobile, Horizontal on wide screens)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 500;

              if (isNarrow) {
                return Column(
                  children: List.generate(_nodes.length, (index) {
                    final node = _nodes[index];
                    final isSelected = index == _selectedNodeIndex;
                    final isPulsing = index == _activePulseIndex;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedNodeIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isPulsing
                                  ? node.accentColor.withValues(alpha: 0.35)
                                  : isSelected
                                      ? node.accentColor.withValues(alpha: 0.2)
                                      : const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isPulsing || isSelected
                                    ? node.accentColor
                                    : const Color(0xFF334155),
                                width: isPulsing ? 2.5 : (isSelected ? 2 : 1),
                              ),
                              boxShadow: isPulsing
                                  ? [
                                      BoxShadow(
                                        color: node.accentColor
                                            .withValues(alpha: 0.6),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  node.icon,
                                  color: isSelected || isPulsing
                                      ? node.accentColor
                                      : Colors.white70,
                                  size: 28,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    node.label,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected || isPulsing
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected || isPulsing
                                          ? Colors.white
                                          : Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index < _nodes.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Icon(
                              Icons.arrow_downward,
                              color: _activePulseIndex == index
                                  ? AppColors.energyAmber
                                  : Colors.white24,
                              size: 20,
                            ),
                          ),
                      ],
                    );
                  }),
                );
              }

              return Wrap(
                spacing: 6,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.generate(_nodes.length, (index) {
                  final node = _nodes[index];
                  final isSelected = index == _selectedNodeIndex;
                  final isPulsing = index == _activePulseIndex;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedNodeIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 120,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isPulsing
                                ? node.accentColor.withValues(alpha: 0.35)
                                : isSelected
                                    ? node.accentColor.withValues(alpha: 0.2)
                                    : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isPulsing || isSelected
                                  ? node.accentColor
                                  : const Color(0xFF334155),
                              width: isPulsing ? 2.5 : (isSelected ? 2 : 1),
                            ),
                            boxShadow: isPulsing
                                ? [
                                    BoxShadow(
                                      color: node.accentColor
                                          .withValues(alpha: 0.6),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                node.icon,
                                color: isSelected || isPulsing
                                    ? node.accentColor
                                    : Colors.white70,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                node.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected || isPulsing
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected || isPulsing
                                      ? Colors.white
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index < _nodes.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.arrow_forward,
                            color: _activePulseIndex == index
                                ? AppColors.energyAmber
                                : Colors.white24,
                            size: 18,
                          ),
                        ),
                    ],
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 16),

          // Detail Card for Selected Node
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedNode.accentColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(selectedNode.icon,
                        color: selectedNode.accentColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      selectedNode.label.replaceAll('\n', ' - '),
                      style: TextStyle(
                        color: selectedNode.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  selectedNode.role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Examples: ',
                        style: TextStyle(
                          color: AppColors.energyAmber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          selectedNode.example,
                          style: const TextStyle(
                            color: Colors.white70,
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

          // Test Pulse Button
          ElevatedButton.icon(
            onPressed: _pulseController.isAnimating ? null : _triggerPulse,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryViolet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: Icon(
              _pulseController.isAnimating
                  ? Icons.hourglass_top
                  : Icons.play_arrow,
              size: 20,
            ),
            label: Text(
              _pulseController.isAnimating
                  ? 'Transmitting Signal...'
                  : 'Test Signal Pulse ➔',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
