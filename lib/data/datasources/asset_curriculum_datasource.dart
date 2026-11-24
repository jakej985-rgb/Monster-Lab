import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/lesson_model.dart';
import '../../domain/models/component_model.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/challenge_model.dart';
import '../../domain/models/course_model.dart';

class AssetCurriculumDataSource {
  final AssetBundle _assetBundle;

  AssetCurriculumDataSource([AssetBundle? assetBundle])
      : _assetBundle = assetBundle ?? rootBundle;

  Future<Map<String, dynamic>?> loadManifest() async {
    try {
      final data =
          await _assetBundle.loadString('assets/curriculum/manifest.json');
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static List<CourseModel>? _cachedBaselineCourses;

  List<CourseModel> getBaselineCourses() {
    return _cachedBaselineCourses ??= [
      const CourseModel(
        id: 'lesson_01',
        title: 'Lesson 1 — Arduino Fundamentals',
        summary:
            'Discover the brain of your robot! Learn what microcontrollers do, explore the pins, and understand how power flows.',
        lessonIds: [
          'l01_01',
          'l01_02',
          'l01_03',
          'l01_04',
          'l01_05',
          'l01_06',
          'l01_07',
          'l01_08',
          'l01_09',
          'l01_10',
          'l01_11',
          'l01_12',
          'l01_13',
          'l01_14',
          'l01_15',
          'l01_16',
          'l01_17',
          'l01_18'
        ],
        prerequisites: [],
        xpReward: 100,
        estimatedMinutes: 108,
      ),
      const CourseModel(
        id: 'coding_foundations',
        title: 'Coding Foundations',
        summary:
            'Learn the core programming concepts required for Monster Lab.',
        lessonIds: [
          'cf_01',
          'cf_02',
          'cf_03',
          'cf_04',
          'cf_05',
          'cf_06',
          'cf_07',
          'cf_08'
        ],
        isOptional: true,
        placementLessonId: 'cf_08',
        prerequisites: ['lesson_01'],
        xpReward: 100,
        estimatedMinutes: 90,
      ),
      const CourseModel(
        id: 'lesson_2a',
        title: 'Lesson 2A — Meet Monster Lab',
        summary:
            'Learn how Monster Lab works — the Learn Lab, Parts Lab, Build Lab, Code Lab, Challenges, XP, and safe hardware workflow — before diving into real builds.',
        lessonIds: [
          'l2a_01',
          'l2a_02',
          'l2a_03',
          'l2a_04',
          'l2a_05',
          'l2a_06',
          'l2a_07',
          'l2a_08'
        ],
        prerequisites: ['lesson_01'],
        xpReward: 75,
        estimatedMinutes: 15,
      ),
      const CourseModel(
        id: 'lesson_2b',
        title: 'Lesson 2B — Arduino IDE Walkthrough',
        summary:
            'Set up your Arduino IDE, understand compilation, learn board and port selection, master setup() and loop(), and upload your first sketch safely.',
        lessonIds: [
          'l2b_01',
          'l2b_02',
          'l2b_03',
          'l2b_04',
          'l2b_05',
          'l2b_06',
          'l2b_07',
          'l2b_08'
        ],
        prerequisites: ['lesson_2a'],
        xpReward: 75,
        estimatedMinutes: 20,
      ),
      const CourseModel(
        id: 'lesson_03',
        title: 'Lesson 3 — Libraries: Power Up Your Code',
        summary:
            'Supercharge your robot with pre-built software libraries! Learn how to import code, control complex displays with simple commands, and avoid reinventing the wheel.',
        lessonIds: [
          'l03_01',
          'l03_02',
          'l03_03',
          'l03_04',
          'l03_05',
          'l03_06',
          'l03_07',
          'l03_08',
          'l03_09'
        ],
        prerequisites: ['lesson_2b'],
        xpReward: 100,
        estimatedMinutes: 45,
      ),
      const CourseModel(
        id: 'lesson_04',
        title: 'Lesson 4 — PWM & RGB LEDs: Colors and Brightness',
        summary:
            'Paint with light! Discover how Pulse Width Modulation fakes analog voltage to dim LEDs and mix millions of colors with RGB diodes.',
        lessonIds: [
          'l04_01',
          'l04_02',
          'l04_03',
          'l04_04',
          'l04_05',
          'l04_06',
          'l04_07',
          'l04_08',
          'l04_09',
          'l04_10'
        ],
        prerequisites: ['lesson_03'],
        xpReward: 100,
        estimatedMinutes: 50,
      ),
      const CourseModel(
        id: 'lesson_05',
        title: 'Lesson 5 — Switches, Buttons & Potentiometers: Physical Inputs',
        summary:
            'Give your monster robot hands and eyes! Connect pushbuttons, slider switches, and rotating knobs to control your hardware world.',
        lessonIds: [
          'l05_01',
          'l05_02',
          'l05_03',
          'l05_04',
          'l05_05',
          'l05_06',
          'l05_07',
          'l05_08',
          'l05_09',
          'l05_10',
          'l05_11',
          'l05_12',
          'l05_13',
          'l05_14',
          'l05_15',
          'l05_16'
        ],
        prerequisites: ['lesson_04'],
        xpReward: 150,
        estimatedMinutes: 80,
      ),
      const CourseModel(
        id: 'lesson_06',
        title: 'Lesson 6 — Circuits, Breadboards & First Builds',
        summary:
            'Learn hands-on breadboard prototyping, circuit fundamentals, voltage dividers, and how to build reliable electronic hardware.',
        lessonIds: [
          'l06_01',
          'l06_02',
          'l06_03',
          'l06_04',
          'l06_05',
          'l06_06',
          'l06_07',
          'l06_08',
          'l06_09',
          'l06_10',
          'l06_11'
        ],
        prerequisites: ['lesson_05'],
        xpReward: 100,
        estimatedMinutes: 55,
      ),
      const CourseModel(
        id: 'lesson_07',
        title: 'Lesson 7 — Sensors & Reading the Real World',
        summary:
            'Turn environmental signals into numbers! Read light, ultrasonic distance, temperature, and touch to give your robot senses.',
        lessonIds: [
          'l07_01',
          'l07_02',
          'l07_03',
          'l07_04',
          'l07_05',
          'l07_06',
          'l07_07',
          'l07_08',
          'l07_09',
          'l07_10',
          'l07_11'
        ],
        prerequisites: ['lesson_06'],
        xpReward: 100,
        estimatedMinutes: 55,
      ),
      const CourseModel(
        id: 'lesson_08',
        title: 'Lesson 8 — I2C & Connected Devices',
        summary:
            'Connect multiple smart sensors and displays using only two communication wires: Serial Clock (SCL) and Serial Data (SDA).',
        lessonIds: [
          'l08_01',
          'l08_02',
          'l08_03',
          'l08_04',
          'l08_05',
          'l08_06',
          'l08_07',
          'l08_08',
          'l08_09',
          'l08_10'
        ],
        prerequisites: ['lesson_07'],
        xpReward: 100,
        estimatedMinutes: 50,
      ),
    ];
  }

  static List<Lesson>? _cachedBaselineLessons;

  /// Compact emergency fallback used only when the bundled curriculum assets
  /// cannot be loaded. The full curriculum in `assets/curriculum/` remains the
  /// source of truth; this keeps Course 1 navigable without embedding a second
  /// 700 KB copy of the production content in the binary.
  List<Lesson> getBaselineLessons() {
    return _cachedBaselineLessons ??=
        (jsonDecode(_baselineLessonsJson) as List<dynamic>).map((e) {
      final map = Map<String, dynamic>.from(e as Map<String, dynamic>);
      map['isPlaceholder'] = true;
      return Lesson.fromJson(map);
    }).toList();
  }

  static const List<String> _baselineLessonTitles = [
    'What Is Arduino?',
    'Your First Circuit',
    'Inputs and Outputs',
    'Reading a Button',
    'Breadboard Basics',
    'LEDs and Resistors',
    'Analog Signals',
    'Sensors and the Real World',
    'Libraries and Code',
    'Serial Communication',
    'Motors and Movement',
    'Your First Robot Build',
  ];

  /// Initial baseline components (representing the 38 peripherals)
  List<ComponentModel> getBaselineComponents() {
    return const [
      ComponentModel(
        id: 'comp_01',
        peripheralNumber: 1,
        name: 'Ultrasonic Sensor',
        partNumber: 'HC-SR04',
        category: 'sensor',
        description:
            'Sends out ultrasonic sound waves and measures echo bounce time to calculate distance.',
        realWorldAnalogy: 'Echolocation like a bat or submarine sonar!',
        voltage: OperatingVoltage.v5,
        pinout: [
          PinDefinition(
              pinName: 'VCC', type: PinType.power, description: '5V Power'),
          PinDefinition(
              pinName: 'TRIG',
              type: PinType.digitalOut,
              description: 'Trigger pulse'),
          PinDefinition(
              pinName: 'ECHO',
              type: PinType.digitalIn,
              description: 'Echo receive'),
          PinDefinition(
              pinName: 'GND', type: PinType.ground, description: 'Ground'),
        ],
        datasheetRef: 'hc-sr04_ultrasonic_module_user_guidejohn .pdf',
        safety: SafetyClassification(
          level: SafetyLevel.safe,
          hazards: [],
          requiresParentUnlock: false,
        ),
        projectIds: ['proj_01', 'proj_11'],
        primaryImage: 'assets/images/components/comp_01.webp',
        detailImages: ['assets/images/components/comp_01_detail.webp'],
        imageDescription: 'Hardware photo of Ultrasonic Sensor',
      ),
      ComponentModel(
        id: 'comp_20',
        peripheralNumber: 20,
        name: 'Potentiometer',
        partNumber: '10K Rotary',
        category: 'passive',
        description:
            'A variable resistor dial that outputs an analog voltage between 0V and 5V.',
        realWorldAnalogy: 'A volume dial on a music stereo!',
        voltage: OperatingVoltage.v5,
        pinout: [
          PinDefinition(
              pinName: 'Pin 1', type: PinType.power, description: '5V Power'),
          PinDefinition(
              pinName: 'Pin 2',
              type: PinType.analogIn,
              description: 'Wiper Signal to A0'),
          PinDefinition(
              pinName: 'Pin 3', type: PinType.ground, description: 'Ground'),
        ],
        datasheetRef: 'Potentiometers.pdf',
        safety: SafetyClassification(
          level: SafetyLevel.safe,
          hazards: [],
          requiresParentUnlock: false,
        ),
        projectIds: ['proj_08'],
        primaryImage: 'assets/images/components/comp_20.webp',
        detailImages: ['assets/images/components/comp_20_detail.webp'],
        imageDescription: 'Hardware photo of Potentiometer',
      ),
      ComponentModel(
        id: 'comp_37',
        peripheralNumber: 37,
        name: 'Laser Diode Module',
        partNumber: 'KY-008',
        category: 'actuator',
        description:
            'Emits a 650nm red coherent laser beam. Used in automated sentry turrets.',
        realWorldAnalogy: 'A pinpoint laser pointer beam!',
        voltage: OperatingVoltage.v5,
        pinout: [
          PinDefinition(
              pinName: 'S',
              type: PinType.digitalOut,
              description: 'Signal trigger'),
          PinDefinition(
              pinName: '-', type: PinType.ground, description: 'Ground'),
        ],
        datasheetRef: 'Button.pdf',
        safety: SafetyClassification(
          level: SafetyLevel.restrictedAdultSupervision,
          hazards: [
            'Direct ocular laser exposure risk',
            'Class 2/3R radiation'
          ],
          childSafeAlternative: 'Replace with 5mm high-brightness Red LED',
          requiresParentUnlock: true,
        ),
        projectIds: ['proj_11'],
        primaryImage: 'assets/images/components/comp_37.webp',
        detailImages: ['assets/images/components/comp_37_detail.webp'],
        imageDescription: 'Hardware photo of Laser Diode Module',
      ),
      ComponentModel(
        id: 'comp_uno',
        peripheralNumber: 39,
        name: 'Arduino Uno R3',
        partNumber: 'ATmega328P',
        category: 'microcontroller',
        description:
            'The flagship central brain of Monster Lab. Features 14 digital I/O pins, 6 analog inputs, a 16MHz clock, and a USB interface.',
        realWorldAnalogy: 'The central brain of a robot or smart device.',
        voltage: OperatingVoltage.v5,
        pinout: [
          PinDefinition(
              pinName: 'D0/RX',
              type: PinType.uart,
              description: 'Serial Receive'),
          PinDefinition(
              pinName: 'D1/TX',
              type: PinType.uart,
              description: 'Serial Transmit'),
          PinDefinition(
              pinName: 'D13',
              type: PinType.digitalOut,
              description: 'Built-in LED'),
          PinDefinition(
              pinName: '5V', type: PinType.power, description: '5V Power'),
          PinDefinition(
              pinName: 'GND', type: PinType.ground, description: 'Ground'),
        ],
        datasheetRef: 'ATmega328P.pdf',
        safety: SafetyClassification(
          level: SafetyLevel.safe,
          hazards: [],
          requiresParentUnlock: false,
        ),
        projectIds: ['proj_01'],
        primaryImage: 'assets/images/components/comp_uno.webp',
        detailImages: ['assets/images/components/comp_uno_detail.webp'],
        imageDescription: 'Hardware photo of Arduino Uno R3',
      ),
      ComponentModel(
        id: 'comp_breadboard',
        peripheralNumber: 42,
        name: '830-Point Solderless Breadboard',
        partNumber: 'MB-102',
        category: 'prototyping',
        description:
            'A solderless prototyping board featuring twin power distribution rails and 630 tie-point component grid.',
        realWorldAnalogy:
            'A reusable circuit highway for connecting components without soldering.',
        voltage: OperatingVoltage.v5,
        pinout: [
          PinDefinition(
              pinName: 'Power (+)',
              type: PinType.power,
              description: 'Power Rail'),
          PinDefinition(
              pinName: 'Ground (-)',
              type: PinType.ground,
              description: 'Ground Rail'),
        ],
        datasheetRef: 'Breadboard.pdf',
        safety: SafetyClassification(
          level: SafetyLevel.safe,
          hazards: [],
          requiresParentUnlock: false,
        ),
        projectIds: ['proj_01'],
        primaryImage: 'assets/images/components/comp_breadboard.webp',
        detailImages: ['assets/images/components/comp_breadboard_detail.webp'],
        imageDescription: 'Hardware photo of Solderless Breadboard',
      ),
    ];
  }

  /// Initial baseline projects (representing the 14 projects)
  List<ProjectModel> getBaselineProjects() {
    return const [
      ProjectModel(
        id: 'proj_01',
        title: 'Intruder Alarm MONSTER',
        tagline:
            'Detect intruders approaching your room using ultrasonic radar!',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 30,
        requiredComponents: ['comp_01', 'comp_34'],
        prerequisiteLessons: [
          'lesson_01',
          'lesson_02',
          'lesson_04',
          'lesson_05'
        ],
        phases: [
          BuildPhase(
            phaseNumber: 1,
            phaseTitle: 'Gather Components',
            type: PhaseType.gatherParts,
            instructions:
                'Collect your Arduino Uno, HC-SR04 Ultrasonic sensor, active buzzer, and jumper wires.',
          ),
          BuildPhase(
            phaseNumber: 2,
            phaseTitle: 'Breadboard Wiring',
            type: PhaseType.breadboardWiring,
            instructions:
                'Connect VCC to 5V, GND to GND, TRIG to D9, and ECHO to D10.',
            inoSketchPath:
                'Projects/Intruder Alarm MONSTER/Code/Final_Code/Final_Code.ino',
          ),
        ],
        xpReward: 250,
        badgeRewardId: 'badge_intruder_patrol',
      ),
    ];
  }

  /// Initial baseline challenges
  List<ChallengeModel> getBaselineChallenges() {
    return const [
      ChallengeModel(
        id: 'chal_01',
        title: 'Identify the Sensor',
        type: ChallengeType.identifyPart,
        difficulty: DifficultyTier.rookie,
        prompt:
            'Which sensor uses high-frequency sound pulses to measure distance?',
        challengeData: {
          'options': [
            'HC-SR04 Ultrasonic',
            'Photoresistor',
            'Potentiometer',
            'Tilt Switch'
          ],
          'correctIndex': 0,
        },
        hint: 'Think about how bats navigate in the dark!',
        xpAward: 50,
      ),
    ];
  }
}
