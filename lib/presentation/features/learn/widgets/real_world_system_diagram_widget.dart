import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class SystemExample {
  final String id;
  final String name;
  final IconData icon;
  final String sensorName;
  final String sensorRole;
  final String decisionRule;
  final String actuatorName;
  final String actuatorAction;
  final String triggerButtonText;
  final String simulationEvent;

  const SystemExample({
    required this.id,
    required this.name,
    required this.icon,
    required this.sensorName,
    required this.sensorRole,
    required this.decisionRule,
    required this.actuatorName,
    required this.actuatorAction,
    required this.triggerButtonText,
    required this.simulationEvent,
  });
}

class RealWorldSystemDiagramWidget extends StatefulWidget {
  final Map<String, dynamic>? config;
  final VoidCallback? onComplete;

  const RealWorldSystemDiagramWidget({
    super.key,
    this.config,
    this.onComplete,
  });

  @override
  State<RealWorldSystemDiagramWidget> createState() =>
      _RealWorldSystemDiagramWidgetState();
}

class _RealWorldSystemDiagramWidgetState
    extends State<RealWorldSystemDiagramWidget> {
  static const List<SystemExample> _systems = [
    SystemExample(
      id: 'vacuum',
      name: 'Robot Vacuum',
      icon: Icons.cleaning_services,
      sensorName: 'Ultrasonic Sensor',
      sensorRole: 'Measures sound bounce distance to obstacles',
      decisionRule: 'if (distance < 20cm) {\n  reverseAndTurnLeft();\n}',
      actuatorName: 'H-Bridge Motor Driver',
      actuatorAction: 'Spins right wheel backward to evade obstacle',
      triggerButtonText: 'Simulate Wall 15cm Ahead',
      simulationEvent:
          'Obstacle detected 15cm ahead! Arduino orders motor driver to reverse right wheel and steer clear.',
    ),
    SystemExample(
      id: 'door',
      name: 'Automatic Sliding Door',
      icon: Icons.sensor_door,
      sensorName: 'PIR Motion Sensor',
      sensorRole: 'Detects infrared heat radiation from approaching person',
      decisionRule: 'if (motion == DETECTED) {\n  openDoorServo();\n}',
      actuatorName: 'Door Mechanism Motor',
      actuatorAction: 'Slides glass door open and holds for 5 seconds',
      triggerButtonText: 'Simulate Person Approaching',
      simulationEvent:
          'Person detected at entrance! Controller triggers motor to slide glass door open smoothly.',
    ),
    SystemExample(
      id: 'alarm',
      name: 'Security Alarm',
      icon: Icons.security,
      sensorName: 'Laser Tripwire Sensor',
      sensorRole: 'Monitors continuous light beam across doorway',
      decisionRule: 'if (beamBroken == TRUE) {\n  triggerAlarmSiren();\n}',
      actuatorName: 'Piezo Buzzer & Strobe',
      actuatorAction: 'Emits 100dB sound wave and flashes warning strobe',
      triggerButtonText: 'Simulate Tripwire Beam Break',
      simulationEvent:
          'Laser beam interrupted! Program instantly commands buzzer pin HIGH to sound emergency siren.',
    ),
  ];

  int _selectedSystemIndex = 0;
  bool _isEventTriggered = false;
  final Set<int> _triggeredSystems = {};

  void _triggerEvent() {
    setState(() {
      _isEventTriggered = true;
      _triggeredSystems.add(_selectedSystemIndex);
    });
    if (_triggeredSystems.length == _systems.length) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.config?['title'] as String? ??
        'Real-World Automation: Input ➔ Logic ➔ Output';
    final currentSys = _systems[_selectedSystemIndex];
    final allSystemsTested = _triggeredSystems.length == _systems.length;

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
                  Icons.hub,
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
              if (allSystemsTested)
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
                        'ALL TESTED',
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
            'The same three-part pattern powers real autonomous devices worldwide. Choose a machine below and test its automated response:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),

          // System Selection Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_systems.length, (index) {
                final sys = _systems[index];
                final isSelected = index == _selectedSystemIndex;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(
                      sys.icon,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    label: Text(sys.name),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedSystemIndex = index;
                          _isEventTriggered = false;
                        });
                      }
                    },
                    selectedColor:
                        AppColors.primaryViolet.withValues(alpha: 0.4),
                    backgroundColor: const Color(0xFF1E293B),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryViolet
                          : const Color(0xFF334155),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // 3-Stage Pipeline Diagram for this System
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isEventTriggered
                    ? AppColors.accentCyan
                    : const Color(0xFF334155),
              ),
            ),
            child: Column(
              children: [
                // Input Block
                _buildSystemStage(
                  title: 'INPUT: ${currentSys.sensorName}',
                  detail: currentSys.sensorRole,
                  icon: Icons.sensors,
                  accentColor: AppColors.energyAmber,
                  isTriggered: _isEventTriggered,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(Icons.arrow_downward,
                      color: Colors.white24, size: 16),
                ),

                // Decision Block
                _buildSystemStage(
                  title: 'DECISION: Microcontroller Program',
                  detail: currentSys.decisionRule,
                  icon: Icons.code,
                  accentColor: AppColors.primaryViolet,
                  isTriggered: _isEventTriggered,
                  isCode: true,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(Icons.arrow_downward,
                      color: Colors.white24, size: 16),
                ),

                // Output Block
                _buildSystemStage(
                  title: 'OUTPUT: ${currentSys.actuatorName}',
                  detail: currentSys.actuatorAction,
                  icon: Icons.precision_manufacturing,
                  accentColor: const Color(0xFF00E676),
                  isTriggered: _isEventTriggered,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Simulation Trigger Button
          ElevatedButton.icon(
            onPressed: _triggerEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.touch_app, size: 20),
            label: Text(
              currentSys.triggerButtonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          if (_isEventTriggered) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF00E676)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: Color(0xFF00E676), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentSys.simulationEvent,
                      style: const TextStyle(
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
        ],
      ),
    );
  }

  Widget _buildSystemStage({
    required String title,
    required String detail,
    required IconData icon,
    required Color accentColor,
    required bool isTriggered,
    bool isCode = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isTriggered
            ? accentColor.withValues(alpha: 0.15)
            : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTriggered ? accentColor : const Color(0xFF334155),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontFamily: isCode ? 'monospace' : null,
                    height: 1.3,
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
