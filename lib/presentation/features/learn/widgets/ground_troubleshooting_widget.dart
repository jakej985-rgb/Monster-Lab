import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class GroundScenario {
  final String id;
  final String name;
  final String status;
  final String description;
  final int currentMa;
  final String ledState; // 'on', 'off', 'flicker', 'danger'
  final Color statusColor;

  const GroundScenario({
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.currentMa,
    required this.ledState,
    required this.statusColor,
  });
}

class GroundTroubleshootingWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const GroundTroubleshootingWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<GroundTroubleshootingWidget> createState() =>
      _GroundTroubleshootingWidgetState();
}

class _GroundTroubleshootingWidgetState
    extends State<GroundTroubleshootingWidget> {
  static const List<GroundScenario> _scenarios = [
    GroundScenario(
      id: 'complete',
      name: '1. Complete Circuit',
      status: 'Normal & Healthy',
      description:
          'Electricity leaves 5V, passes through the LED and current-limiting resistor, and returns safely through GND to close the loop.',
      currentMa: 18,
      ledState: 'on',
      statusColor: AppColors.success,
    ),
    GroundScenario(
      id: 'missing_gnd',
      name: '2. Missing Ground (Open)',
      status: 'Broken Return Path',
      description:
          'The GND wire fell out! Electrons cannot flow because there is nowhere for them to return. The LED stays 100% dark.',
      currentMa: 0,
      ledState: 'off',
      statusColor: AppColors.energyAmber,
    ),
    GroundScenario(
      id: 'loose_gnd',
      name: '3. Loose / Flaky Ground',
      status: 'High Resistance Intermittent',
      description:
          'A wire is loosely wobbling in the breadboard clip. Resistance jumps wildly, causing the LED to flicker and sensors to output ghost data.',
      currentMa: 4,
      ledState: 'flicker',
      statusColor: Color(0xFFFFA502),
    ),
    GroundScenario(
      id: 'short_circuit',
      name: '4. Short Circuit (Direct Bridge)',
      status: 'SAFETY ALERT: Overcurrent',
      description:
          'DANGER: 5V was wired directly to GND with NO resistor or component! Massive current rushes through, heating up wires and triggering computer USB port shutdown.',
      currentMa: 850,
      ledState: 'danger',
      statusColor: AppColors.danger,
    ),
  ];

  int _selectedIndex = 0;
  final Set<int> _exploredIndices = {0};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Circuit Diagnostics: Power & Ground Loop';
    final scenario = _scenarios[_selectedIndex];
    final isAllExplored = _exploredIndices.length == _scenarios.length;

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
                  color: scenario.statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.electric_bolt,
                  color: scenario.statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scenario.statusColor,
                  ),
                ),
              ),
              if (isAllExplored)
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
                        'TESTED',
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
            'Ground (GND) is NOT an electrical drain where electricity disappears. It is the essential return highway. Test the 4 ground conditions below:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // Scenario Selection Tabs (Responsive Wrap - No side scrolling)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_scenarios.length, (index) {
              final sc = _scenarios[index];
              final isSelected = index == _selectedIndex;

              return ChoiceChip(
                label: Text(sc.name),
                selected: isSelected,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedIndex = index;
                      _exploredIndices.add(index);
                    });
                    if (_exploredIndices.length == _scenarios.length) {
                      widget.onComplete?.call();
                    }
                  }
                },
                selectedColor: sc.statusColor.withValues(alpha: 0.25),
                backgroundColor: const Color(0xFF1E293B),
                side: BorderSide(
                  color: isSelected ? sc.statusColor : const Color(0xFF334155),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Circuit Visualizer Bench
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: scenario.statusColor.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Top Live Telemetry
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STATUS: ${scenario.status.toUpperCase()}',
                      style: TextStyle(
                        color: scenario.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: scenario.statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: scenario.statusColor),
                      ),
                      child: Text(
                        'Current: ${scenario.currentMa} mA',
                        style: TextStyle(
                          color: scenario.statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Circuit Path Schematic Diagram
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Power 5V Rail
                    _buildRailNode(
                        '5V RAIL', AppColors.wirePower5V, Icons.power),
                    const Icon(Icons.arrow_forward,
                        color: Colors.white38, size: 16),

                    // Resistor
                    _buildComponentBox(
                        '220Ω Resistor', Icons.straighten, Colors.amber),
                    const Icon(Icons.arrow_forward,
                        color: Colors.white38, size: 16),

                    // LED
                    _buildLedNode(scenario.ledState, scenario.statusColor),
                    const Icon(Icons.arrow_forward,
                        color: Colors.white38, size: 16),

                    // GND Rail
                    _buildRailNode(
                      scenario.id == 'missing_gnd' ? 'BROKEN GND' : 'GND RAIL',
                      scenario.id == 'missing_gnd'
                          ? Colors.grey
                          : const Color(0xFF2ED573),
                      scenario.id == 'missing_gnd'
                          ? Icons.link_off
                          : Icons.arrow_downward,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description Callout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    scenario.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Ground Safety Tip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x1A00CEC9),
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                left: BorderSide(color: AppColors.accentCyan, width: 4),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.tips_and_updates,
                    color: AppColors.accentCyan, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lab Golden Rule: When building breadboard circuits, always connect the blue (-) rail to Arduino GND first. Every sensor must share this common ground reference!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.35,
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

  Widget _buildRailNode(String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildComponentBox(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF475569)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildLedNode(String ledState, Color color) {
    Color ledColor;
    List<BoxShadow>? shadows;

    if (ledState == 'on') {
      ledColor = const Color(0xFF00E676);
      shadows = [
        const BoxShadow(
          color: Color(0xFF00E676),
          blurRadius: 16,
          spreadRadius: 3,
        ),
      ];
    } else if (ledState == 'danger') {
      ledColor = AppColors.danger;
      shadows = [
        const BoxShadow(
          color: AppColors.danger,
          blurRadius: 16,
          spreadRadius: 3,
        ),
      ];
    } else if (ledState == 'flicker') {
      ledColor = AppColors.energyAmber;
      shadows = [
        const BoxShadow(
          color: AppColors.energyAmber,
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    } else {
      ledColor = const Color(0xFF334155);
      shadows = null;
    }

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ledColor,
            boxShadow: shadows,
            border: Border.all(color: Colors.white30),
          ),
          child: const Icon(Icons.lightbulb, color: Colors.white, size: 18),
        ),
        const SizedBox(height: 4),
        const Text(
          'LED',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
