import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/monster_card.dart';

class BoardInspectorWidget extends StatefulWidget {
  const BoardInspectorWidget({super.key});

  @override
  State<BoardInspectorWidget> createState() => _BoardInspectorWidgetState();
}

class BoardComponentHotspot {
  final String id;
  final String title;
  final String category;
  final String description;
  final String analogy;
  final IconData icon;

  const BoardComponentHotspot({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.analogy,
    required this.icon,
  });
}

class _BoardInspectorWidgetState extends State<BoardInspectorWidget> {
  static const List<BoardComponentHotspot> _hotspots = [
    BoardComponentHotspot(
      id: 'usb',
      title: 'USB Type-B Port',
      category: 'Power & Data',
      description:
          'Connects your computer to the board to flash code and supply 5V DC power.',
      analogy:
          'Like an umbilical cord that gives both energy and thoughts to the board!',
      icon: Icons.usb,
    ),
    BoardComponentHotspot(
      id: 'chip',
      title: 'ATmega328P Microcontroller',
      category: 'Processor Brain',
      description:
          'The black silicon chip that stores your compiled code and executes 16 million instructions per second.',
      analogy: 'The central brain of the monster!',
      icon: Icons.memory,
    ),
    BoardComponentHotspot(
      id: 'power_pins',
      title: '5V, 3.3V & Ground Pins',
      category: 'Power Rails',
      description:
          'Supplies regulated 5V and 3.3V to sensors. GND is the essential return path for all electricity.',
      analogy: 'The heart and veins pumping electric life into your circuits!',
      icon: Icons.bolt,
    ),
    BoardComponentHotspot(
      id: 'led_13',
      title: 'Pin 13 Built-in LED',
      category: 'Built-in Output',
      description:
          'A surface-mount amber LED wired internally to Digital Pin 13.',
      analogy:
          'The robot\'s blinking eye that works without any extra breadboard wires!',
      icon: Icons.lightbulb,
    ),
    BoardComponentHotspot(
      id: 'analog_pins',
      title: 'Analog Input Pins (A0-A5)',
      category: 'Sensory Inputs',
      description:
          'Reads variable voltages from 0V to 5V and converts them into numbers from 0 to 1023.',
      analogy:
          'The sensory nerves measuring smooth physical changes like temperature or volume!',
      icon: Icons.sensors,
    ),
    BoardComponentHotspot(
      id: 'pwm_pins',
      title: 'Digital & PWM Pins (~)',
      category: 'Commands & Speed',
      description:
          'Pins 3, 5, 6, 9, 10, 11 marked with ~ can simulate analog fading using Pulse Width Modulation.',
      analogy:
          'The hands of the robot: can switch ON/OFF or dim lights like a dimmer knob!',
      icon: Icons.waves,
    ),
  ];

  late BoardComponentHotspot _selected;

  @override
  void initState() {
    super.initState();
    _selected = _hotspots.first;
  }

  @override
  Widget build(BuildContext context) {
    return MonsterCard(
      color: AppColors.backgroundLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.touch_app, color: AppColors.primaryViolet),
              SizedBox(width: 8),
              Text(
                'Interactive Board Inspector',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap any section of the Arduino Uno to discover what it does:',
            style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
          ),
          const SizedBox(height: 14),

          // Tappable Chip Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _hotspots.map((h) {
              final isSelected = h.id == _selected.id;
              return ChoiceChip(
                label: Text(h.title,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal)),
                selected: isSelected,
                avatar: Icon(h.icon,
                    size: 16,
                    color: isSelected ? Colors.white : AppColors.primaryViolet),
                selectedColor: AppColors.primaryViolet,
                labelStyle: TextStyle(
                    color:
                        isSelected ? Colors.white : AppColors.textPrimaryLight),
                onSelected: (sel) {
                  if (sel) setState(() => _selected = h);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Selected Hotspot Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.primaryViolet.withValues(alpha: 0.3),
                  width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.primaryViolet.withValues(alpha: 0.15),
                      child: Icon(_selected.icon,
                          color: AppColors.primaryViolet, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selected.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            _selected.category,
                            style: const TextStyle(
                                color: AppColors.primaryViolet,
                                fontWeight: FontWeight.w600,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _selected.description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.energyAmber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.psychology,
                          color: AppColors.energyAmber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selected.analogy,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A4A00),
                          ),
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
}
