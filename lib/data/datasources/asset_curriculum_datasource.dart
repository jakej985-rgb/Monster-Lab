import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/lesson_model.dart';
import '../../domain/models/component_model.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/challenge_model.dart';

class AssetCurriculumDataSource {
  final AssetBundle _assetBundle;

  AssetCurriculumDataSource([AssetBundle? assetBundle])
      : _assetBundle = assetBundle ?? rootBundle;

  Future<Map<String, dynamic>?> loadManifest() async {
    try {
      final data = await _assetBundle
          .loadString('assets/curriculum/curriculum_manifest.json');
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Initial curriculum foundation lessons (audit Lessons 1 through 7)
  List<Lesson> getBaselineLessons() {
    return const [
      Lesson(
        id: 'lesson_01',
        title: 'What is Arduino and how does it work?',
        summary:
            'Meet the brain of your robot! Discover microcontrollers, inputs, and outputs.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 10,
        prerequisites: [],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Welcome to the Lab',
            type: StepType.story,
            markdownContent:
                'An Arduino is a tiny computer that can listen to sensors and control motors or lights!',
          ),
          LessonStep(
            stepId: 'step_2',
            title: 'Board Anatomy',
            type: StepType.visualExplanation,
            markdownContent:
                'Notice the USB port, power barrel, reset button, and numbered pin sockets.',
          ),
          LessonStep(
            stepId: 'step_3',
            title: 'Board Identification Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent: 'Can you spot the USB connector?',
          ),
        ],
        xpReward: 50,
      ),
      Lesson(
        id: 'lesson_02',
        title: 'Installing the Arduino IDE',
        summary:
            'Set up your software laboratory and connect your computer to the board.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: ['lesson_01'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Download and Drivers',
            type: StepType.story,
            markdownContent:
                'Install the Arduino IDE and verify the CH340G USB communication driver.',
          ),
        ],
        xpReward: 50,
      ),
      Lesson(
        id: 'lesson_03',
        title: 'Installing Libraries',
        summary:
            'Learn how open-source libraries give your robot superpowers in seconds.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 10,
        prerequisites: ['lesson_02'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Extending Arduino',
            type: StepType.story,
            markdownContent:
                'Libraries add pre-written functions so you can use LCDs and Servos easily.',
          ),
        ],
        xpReward: 50,
      ),
      Lesson(
        id: 'lesson_04',
        title: 'Basics of the Arduino IDE',
        summary:
            'Explore setup(), loop(), verify, upload, and the Serial Monitor window.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: ['lesson_02'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Code Anatomy',
            type: StepType.story,
            markdownContent:
                'Every sketch has two main parts: setup() runs once, loop() repeats forever!',
          ),
        ],
        xpReward: 75,
      ),
      Lesson(
        id: 'lesson_05',
        title: 'Blink: Your First Project',
        summary:
            'Send electricity through pin 13 to flash your first light on and off!',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: ['lesson_04'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Digital High and Low',
            type: StepType.codeExperiment,
            markdownContent:
                'HIGH sends 5 Volts (LED on). LOW sends 0 Volts (LED off).',
          ),
        ],
        xpReward: 100,
      ),
      Lesson(
        id: 'lesson_06',
        title: 'Potentiometer Readings',
        summary:
            'Turn a physical knob to send smooth analog numbers from 0 to 1023.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 15,
        prerequisites: ['lesson_05'],
        componentIds: ['comp_20'],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Analog Voltage Divider',
            type: StepType.interactiveWiring,
            markdownContent:
                'Connect 5V, GND, and the center wiper pin to analog input A0.',
          ),
        ],
        xpReward: 100,
      ),
      Lesson(
        id: 'lesson_07',
        title: 'Simple RGB LEDs',
        summary:
            'Mix Red, Green, and Blue light using Pulse Width Modulation (PWM).',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 20,
        prerequisites: ['lesson_05'],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'step_1',
            title: 'Color Synthesis',
            type: StepType.codeExperiment,
            markdownContent:
                'Use analogWrite(pin, 0..255) to mix custom rainbow colors!',
          ),
        ],
        xpReward: 120,
      ),
    ];
  }

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
