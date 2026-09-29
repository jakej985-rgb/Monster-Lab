import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum WiringPinType {
  power5V,
  ground,
  digital,
  analog,
  componentLeg;

  Color get defaultColor {
    switch (this) {
      case WiringPinType.power5V:
        return AppColors.wirePower5V;
      case WiringPinType.ground:
        return AppColors.wireGround;
      case WiringPinType.digital:
        return AppColors.wireDigital;
      case WiringPinType.analog:
        return AppColors.wireAnalog;
      case WiringPinType.componentLeg:
        return AppColors.primaryViolet;
    }
  }
}

class WiringPin {
  final String id;
  final String label;
  final String componentId;
  final WiringPinType type;
  final double x; // Relative X coordinate (0.0 - 1.0)
  final double y; // Relative Y coordinate (0.0 - 1.0)

  const WiringPin({
    required this.id,
    required this.label,
    required this.componentId,
    required this.type,
    required this.x,
    required this.y,
  });
}

class PlacedComponent {
  final String id;
  final String name;
  final IconData icon;
  final List<WiringPin> pins;

  const PlacedComponent({
    required this.id,
    required this.name,
    required this.icon,
    required this.pins,
  });
}

class JumperWire {
  final String id;
  final String fromPinId;
  final String toPinId;
  final Color color;

  const JumperWire({
    required this.id,
    required this.fromPinId,
    required this.toPinId,
    required this.color,
  });

  bool connects(String pinA, String pinB) {
    return (fromPinId == pinA && toPinId == pinB) ||
        (fromPinId == pinB && toPinId == pinA);
  }
}

class WiringValidationResult {
  final bool isValid;
  final bool shortCircuitDetected;
  final bool reversedPolarityDetected;
  final bool missingResistorDetected;
  final String title;
  final String message;
  final String educationalTip;

  const WiringValidationResult({
    required this.isValid,
    this.shortCircuitDetected = false,
    this.reversedPolarityDetected = false,
    this.missingResistorDetected = false,
    required this.title,
    required this.message,
    required this.educationalTip,
  });

  factory WiringValidationResult.success({
    required String title,
    required String message,
    required String educationalTip,
  }) {
    return WiringValidationResult(
      isValid: true,
      title: title,
      message: message,
      educationalTip: educationalTip,
    );
  }

  factory WiringValidationResult.glitch({
    required String title,
    required String message,
    required String educationalTip,
    bool isShort = false,
    bool isReversed = false,
    bool isMissingResistor = false,
  }) {
    return WiringValidationResult(
      isValid: false,
      shortCircuitDetected: isShort,
      reversedPolarityDetected: isReversed,
      missingResistorDetected: isMissingResistor,
      title: title,
      message: message,
      educationalTip: educationalTip,
    );
  }
}

class CircuitPreset {
  final String id;
  final String title;
  final String description;
  final List<WiringPin> unoPins;
  final List<PlacedComponent> components;
  final WiringValidationResult Function(List<JumperWire> wires) validator;

  const CircuitPreset({
    required this.id,
    required this.title,
    required this.description,
    required this.unoPins,
    required this.components,
    required this.validator,
  });

  List<WiringPin> get allPins => [
        ...unoPins,
        for (final c in components) ...c.pins,
      ];

  WiringPin? findPin(String id) {
    for (final p in allPins) {
      if (p.id == id) return p;
    }
    return null;
  }
}

abstract class CircuitPresets {
  // 1. Blink Circuit Preset (Uno + 220Ω Resistor + LED)
  static final CircuitPreset blinkLed = CircuitPreset(
    id: 'preset_blink',
    title: 'Lesson 5: Blink LED Circuit',
    description:
        'Connect Arduino digital Pin 13 through a 220Ω protective resistor into the long leg (anode) of the red LED, and return the short leg (cathode) to GND.',
    unoPins: const [
      WiringPin(
          id: 'uno_5v',
          label: '5V',
          componentId: 'uno',
          type: WiringPinType.power5V,
          x: 0.12,
          y: 0.28),
      WiringPin(
          id: 'uno_gnd',
          label: 'GND',
          componentId: 'uno',
          type: WiringPinType.ground,
          x: 0.12,
          y: 0.44),
      WiringPin(
          id: 'uno_d13',
          label: 'D13',
          componentId: 'uno',
          type: WiringPinType.digital,
          x: 0.12,
          y: 0.62),
    ],
    components: const [
      PlacedComponent(
        id: 'comp_resistor',
        name: '220Ω Resistor',
        icon: Icons.linear_scale,
        pins: [
          WiringPin(
              id: 'res_leg1',
              label: 'R1',
              componentId: 'comp_resistor',
              type: WiringPinType.componentLeg,
              x: 0.46,
              y: 0.38),
          WiringPin(
              id: 'res_leg2',
              label: 'R2',
              componentId: 'comp_resistor',
              type: WiringPinType.componentLeg,
              x: 0.62,
              y: 0.38),
        ],
      ),
      PlacedComponent(
        id: 'comp_led',
        name: 'Red LED',
        icon: Icons.lightbulb,
        pins: [
          WiringPin(
              id: 'led_anode',
              label: 'Anode (+)',
              componentId: 'comp_led',
              type: WiringPinType.componentLeg,
              x: 0.74,
              y: 0.38),
          WiringPin(
              id: 'led_cathode',
              label: 'Cathode (-)',
              componentId: 'comp_led',
              type: WiringPinType.componentLeg,
              x: 0.88,
              y: 0.38),
        ],
      ),
    ],
    validator: (wires) {
      // Check 1: Dead short circuit (5V connected directly to GND)
      final hasShort = wires.any((w) =>
          w.connects('uno_5v', 'uno_gnd') || w.connects('uno_d13', 'uno_gnd'));
      if (hasShort) {
        return WiringValidationResult.glitch(
          title: 'Critical Glitch: Direct Short Circuit!',
          message:
              'A jumper wire directly links Power (5V or D13) to Ground (GND) with zero electrical resistance.',
          educationalTip:
              'Without a resistor or load, thousands of milliamperes rush through the board, triggering the Arduino polyfuse thermal shutdown.',
          isShort: true,
        );
      }

      // Check 2: Direct connection to LED without resistor
      final directLed = wires.any((w) =>
          w.connects('uno_d13', 'led_anode') ||
          w.connects('uno_5v', 'led_anode'));
      if (directLed) {
        return WiringValidationResult.glitch(
          title: 'Circuit Warning: Missing Current Limiter!',
          message:
              'The LED is wired directly to the Arduino output pin without a 220Ω resistor.',
          educationalTip:
              'LEDs have almost zero internal resistance. Connecting directly to 5V pushes excessive current, burning out the LED filament.',
          isMissingResistor: true,
        );
      }

      // Check 3: Reversed polarity (Cathode connected to power, Anode to GND)
      final reversed = wires.any((w) =>
          w.connects('uno_gnd', 'led_anode') ||
          w.connects('res_leg2', 'led_cathode'));
      if (reversed) {
        return WiringValidationResult.glitch(
          title: 'Wiring Error: Reversed LED Polarity!',
          message:
              'The LED short leg (Cathode) is facing the positive power signal.',
          educationalTip:
              'LED stands for Light Emitting Diode—a one-way electrical valve! Current can only enter the longer Anode leg and exit the flat-side Cathode.',
          isReversed: true,
        );
      }

      // Check 4: Correct closed loop
      final d13ToRes = wires.any((w) =>
          w.connects('uno_d13', 'res_leg1') ||
          w.connects('uno_d13', 'res_leg2'));
      final resToLed = wires.any((w) =>
          w.connects('res_leg1', 'led_anode') ||
          w.connects('res_leg2', 'led_anode'));
      final ledToGnd = wires.any((w) => w.connects('led_cathode', 'uno_gnd'));

      if (d13ToRes && resToLed && ledToGnd && wires.length == 3) {
        return WiringValidationResult.success(
          title: 'Circuit Verified: Perfect Closed Loop!',
          message:
              'Pin 13 flows safely through the 220Ω resistor into LED Anode and returns to GND.',
          educationalTip:
              'When Arduino executes digitalWrite(13, HIGH), 5V pushes current through the closed circuit, lighting the LED safely!',
        );
      }

      return WiringValidationResult.glitch(
        title: 'Circuit Incomplete (${wires.length}/3 Wires)',
        message:
            'A complete electrical circuit must form an uninterrupted closed loop.',
        educationalTip:
            'Need guidance? Connect: 1) Arduino D13 to Resistor R1, 2) Resistor R2 to LED Anode (+), 3) LED Cathode (-) to Arduino GND.',
      );
    },
  );

  // 2. Ultrasonic Sonar Sensor Preset
  static final CircuitPreset ultrasonicSonar = CircuitPreset(
    id: 'preset_sonar',
    title: 'Project 1: Ultrasonic Sonar Wiring',
    description:
        'Connect HC-SR04 VCC to 5V, GND to GND, TRIG pin to Digital Pin 9, and ECHO pin to Digital Pin 10.',
    unoPins: const [
      WiringPin(
          id: 'uno_5v',
          label: '5V',
          componentId: 'uno',
          type: WiringPinType.power5V,
          x: 0.12,
          y: 0.24),
      WiringPin(
          id: 'uno_gnd',
          label: 'GND',
          componentId: 'uno',
          type: WiringPinType.ground,
          x: 0.12,
          y: 0.40),
      WiringPin(
          id: 'uno_d9',
          label: 'D9 (Trig)',
          componentId: 'uno',
          type: WiringPinType.digital,
          x: 0.12,
          y: 0.58),
      WiringPin(
          id: 'uno_d10',
          label: 'D10 (Echo)',
          componentId: 'uno',
          type: WiringPinType.digital,
          x: 0.12,
          y: 0.74),
    ],
    components: const [
      PlacedComponent(
        id: 'comp_sonar',
        name: 'HC-SR04 Sonar',
        icon: Icons.radar,
        pins: [
          WiringPin(
              id: 'sonar_vcc',
              label: 'VCC',
              componentId: 'comp_sonar',
              type: WiringPinType.power5V,
              x: 0.55,
              y: 0.24),
          WiringPin(
              id: 'sonar_trig',
              label: 'TRIG',
              componentId: 'comp_sonar',
              type: WiringPinType.digital,
              x: 0.55,
              y: 0.40),
          WiringPin(
              id: 'sonar_echo',
              label: 'ECHO',
              componentId: 'comp_sonar',
              type: WiringPinType.digital,
              x: 0.55,
              y: 0.58),
          WiringPin(
              id: 'sonar_gnd',
              label: 'GND',
              componentId: 'comp_sonar',
              type: WiringPinType.ground,
              x: 0.55,
              y: 0.74),
        ],
      ),
    ],
    validator: (wires) {
      if (wires.any((w) => w.connects('uno_5v', 'uno_gnd'))) {
        return WiringValidationResult.glitch(
          title: 'Direct Short Circuit!',
          message: '5V and GND rails are directly connected.',
          educationalTip: 'Ensure 5V only goes to VCC and GND goes to GND.',
          isShort: true,
        );
      }

      final vccOk = wires.any((w) => w.connects('uno_5v', 'sonar_vcc'));
      final gndOk = wires.any((w) => w.connects('uno_gnd', 'sonar_gnd'));
      final trigOk = wires.any((w) => w.connects('uno_d9', 'sonar_trig'));
      final echoOk = wires.any((w) => w.connects('uno_d10', 'sonar_echo'));

      if (vccOk && gndOk && trigOk && echoOk && wires.length == 4) {
        return WiringValidationResult.success(
          title: 'Sonar Sensor Online!',
          message:
              'All 4 pins correctly wired for ultrasonic sound pulse transmission and echo reception.',
          educationalTip:
              'The sensor emits 40kHz ultrasonic sound waves on TRIG and measures high-precision flight time on ECHO!',
        );
      }

      // Check pin swap (Trig on D10, Echo on D9)
      if (wires.any((w) => w.connects('uno_d9', 'sonar_echo')) &&
          wires.any((w) => w.connects('uno_d10', 'sonar_trig'))) {
        return WiringValidationResult.glitch(
          title: 'Signal Trap: TRIG and ECHO Swapped!',
          message:
              'Trigger and Echo lines are reversed on digital pins 9 and 10.',
          educationalTip:
              'Arduino software expects TRIG on Pin 9 to emit the sound blast, and Pin 10 to listen for the bouncing echo.',
        );
      }

      return WiringValidationResult.glitch(
        title: 'Sonar Wiring Incomplete (${wires.length}/4 Wires)',
        message:
            'HC-SR04 requires 2 power lines (VCC/GND) and 2 digital communication lines (TRIG/ECHO).',
        educationalTip:
            'Connect: 1) 5V to VCC, 2) GND to GND, 3) D9 to TRIG, 4) D10 to ECHO.',
      );
    },
  );

  static final List<CircuitPreset> all = [
    blinkLed,
    ultrasonicSonar,
  ];

  static CircuitPreset findById(String id) {
    return all.firstWhere((p) => p.id == id, orElse: () => blinkLed);
  }
}
