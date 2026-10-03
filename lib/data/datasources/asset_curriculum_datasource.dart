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

  /// Initial curriculum foundation lessons (Lessons 1 through 12)
  List<Lesson> getBaselineLessons() {
    return const [
      Lesson(
        id: 'lesson_01',
        title: 'What is Arduino and how does it work?',
        summary:
            'Meet the brain of your robot! Discover microcontrollers, inputs, and outputs.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 18,
        prerequisites: [],
        componentIds: [],
        steps: [
          LessonStep(
            stepId: 'l01_s01',
            title: 'Meet the Monster Brain',
            type: StepType.story,
            markdownContent:
                'Welcome to Monster Lab! The Arduino Uno is a microcontroller board—a tiny, rugged computer designed to interact directly with hardware in the physical world.',
          ),
          LessonStep(
            stepId: 'l01_s02',
            title: 'Inputs vs Outputs & The Decision Engine',
            type: StepType.visualExplanation,
            interactiveWidgetType: 'boardInspector',
            markdownContent:
                'A microcontroller reads Inputs (sensors and buttons) and commands Outputs (LEDs, buzzers, and motors).',
          ),
          LessonStep(
            stepId: 'l01_s03',
            title: 'Pin Tour: Power and Ground',
            type: StepType.physicalTask,
            markdownContent:
                'Locate 5V and GND. Electricity flows from 5V through your circuit and returns to GND!',
          ),
          LessonStep(
            stepId: 'l01_s04',
            title: 'Board Identification Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent:
                'What role does Ground (GND) play in an electrical circuit?',
            interactiveConfig: {
              'question': 'What is Ground (GND)?',
              'options': [
                'A battery that provides unlimited power',
                'The return path for electric current to complete the circuit',
                'A sensor that measures dirt depth',
              ],
              'correctIndex': 1,
            },
          ),
        ],
        xpReward: 50,
      ),
      Lesson(
        id: 'lesson_02',
        title: 'Setting Up Your Monster Lab Station',
        summary:
            'Install the Arduino IDE, connect your board via USB, and verify serial communication link.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 18,
        prerequisites: ['lesson_01'],
        componentIds: ['comp_uno'],
        steps: [
          LessonStep(
            stepId: 'l02_s01',
            title: 'The Arduino IDE Workbench',
            type: StepType.story,
            markdownContent:
                'To give commands to your Monster, write code in the Arduino IDE on your computer.',
          ),
          LessonStep(
            stepId: 'l02_s02',
            title: 'USB Cable Connection',
            type: StepType.physicalTask,
            markdownContent:
                'Plug the blue USB cable into your Arduino and your computer. Watch for the green ON LED.',
          ),
          LessonStep(
            stepId: 'l02_s03',
            title: 'Configuration Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent: 'How does your computer talk to the Arduino Uno?',
            interactiveConfig: {
              'question': 'How does your computer communicate with the board?',
              'options': [
                'Through the USB cable using a virtual COM port',
                'Using an infrared remote',
                'By sound waves from the computer speakers',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 50,
      ),
      Lesson(
        id: 'lesson_03',
        title: 'Installing Libraries: Supercharging Code',
        summary:
            'Understand open-source modular libraries and how to install them with the Library Manager.',
        tier: DifficultyTier.builder,
        estimatedMinutes: 18,
        prerequisites: ['lesson_02'],
        componentIds: ['comp_uno', 'comp_07'],
        steps: [
          LessonStep(
            stepId: 'l03_s01',
            title: 'What is a Library?',
            type: StepType.story,
            markdownContent:
                'Libraries add pre-written functions so you can use LCDs and sensors easily.',
          ),
          LessonStep(
            stepId: 'l03_s02',
            title: 'Using the Library Manager',
            type: StepType.visualExplanation,
            markdownContent:
                'The Arduino IDE includes a built-in package repository under Tools > Manage Libraries.',
          ),
          LessonStep(
            stepId: 'l03_s03',
            title: 'Inspecting the I2C LCD Backpack',
            type: StepType.physicalTask,
            markdownContent:
                'Examine the 4 interface pins on your 16x2 LCD backpack: GND, VCC, SDA, and SCL.',
          ),
          LessonStep(
            stepId: 'l03_s04',
            title: 'Annotated Walkthrough: LiquidCrystal_I2C',
            type: StepType.codeExperiment,
            markdownContent:
                'LiquidCrystal_I2C lcd(0x27, 16, 2); creates the display object instance.',
          ),
          LessonStep(
            stepId: 'l03_s05',
            title: 'Library Quiz',
            type: StepType.quizCheckpoint,
            markdownContent: 'Why do roboticists use libraries?',
            interactiveConfig: {
              'question': 'What is the primary benefit of libraries?',
              'options': [
                'They speed up code by writing complex hardware protocols for you',
                'They replace the need for physical wires',
                'They make the Arduino heavier',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 60,
      ),
      Lesson(
        id: 'lesson_04',
        title: 'Basics of the Arduino IDE: Setup and Loop',
        summary:
            'Explore sketch anatomy: the one-time setup() routine and the infinite loop(). Learn Verify and Upload.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 18,
        prerequisites: ['lesson_02'],
        componentIds: ['comp_uno'],
        steps: [
          LessonStep(
            stepId: 'l04_s01',
            title: 'The Two Heartbeats: setup() and loop()',
            type: StepType.story,
            markdownContent:
                'Every sketch has two main parts: setup() runs once, loop() repeats forever!',
          ),
          LessonStep(
            stepId: 'l04_s02',
            title: 'Serial Monitor Diagnostics',
            type: StepType.codeExperiment,
            markdownContent:
                'Serial.begin(9600); opens the hardware UART link to print debug logs.',
          ),
          LessonStep(
            stepId: 'l04_s03',
            title: 'Execution Cycle Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent: 'How many times does setup() execute?',
            interactiveConfig: {
              'question': 'How many times does setup() execute?',
              'options': [
                'Exactly once when the board powers on or resets',
                'Continuously in an infinite loop',
                'Only when a button is pressed',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 60,
      ),
      Lesson(
        id: 'lesson_05',
        title: 'Blink: Your First Physical Circuit',
        summary:
            'Take control of physical photons! Toggle digital outputs with digitalWrite() and master delay() timing.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 20,
        prerequisites: ['lesson_04'],
        componentIds: ['comp_uno'],
        steps: [
          LessonStep(
            stepId: 'l05_s01',
            title: 'Digital HIGH vs LOW & Push-Pull Drivers',
            type: StepType.story,
            markdownContent:
                'HIGH sends 5 Volts (LED on). LOW sends 0 Volts (LED off).',
          ),
          LessonStep(
            stepId: 'l05_s02',
            title: 'The Built-In LED (Pin 13 L)',
            type: StepType.physicalTask,
            markdownContent:
                'Inspect the tiny amber LED labeled L next to digital pin 13.',
          ),
          LessonStep(
            stepId: 'l05_s03',
            title: 'The Blink Code',
            type: StepType.codeExperiment,
            interactiveWidgetType: 'blinkSimulator',
            markdownContent:
                'Control Pin 13 LED with pinMode(13, OUTPUT) and digitalWrite(13, HIGH).',
          ),
          LessonStep(
            stepId: 'l05_s04',
            title: 'Timing Challenge',
            type: StepType.quizCheckpoint,
            markdownContent: 'What does delay(500) do?',
            interactiveConfig: {
              'question': 'What is delay(500)?',
              'options': [
                'Waits for half a second (500 milliseconds)',
                'Waits for 500 seconds',
                'Increases voltage by 500 millivolts',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 75,
      ),
      Lesson(
        id: 'lesson_06',
        title: 'Potentiometer: Reading Analog Signals',
        summary:
            'Convert physical rotation into digital numbers! Discover the 10-bit Analog to Digital Converter (ADC).',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 20,
        prerequisites: ['lesson_05'],
        componentIds: ['comp_uno', 'comp_breadboard', 'comp_20'],
        steps: [
          LessonStep(
            stepId: 'l06_s01',
            title: 'Analog vs Digital Signals',
            type: StepType.story,
            markdownContent:
                'Turn a physical knob to send smooth analog numbers from 0 to 1023.',
          ),
          LessonStep(
            stepId: 'l06_s02',
            title: 'The Voltage Divider Knob',
            type: StepType.visualExplanation,
            markdownContent:
                'A potentiometer outputs a continuous voltage fraction between 0V and 5V.',
          ),
          LessonStep(
            stepId: 'l06_s03',
            title: 'ADC Math (0 to 1023)',
            type: StepType.codeExperiment,
            interactiveWidgetType: 'potentiometerSimulator',
            markdownContent:
                'int rawValue = analogRead(A0); converts voltage into a 10-bit count.',
          ),
          LessonStep(
            stepId: 'l06_s04',
            title: 'Analog Perception Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent: 'What is the range of analogRead()?',
            interactiveConfig: {
              'question': 'What is the range of analogRead()?',
              'options': [
                '0 to 1023',
                '0 to 255',
                '-512 to +512',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 80,
      ),
      Lesson(
        id: 'lesson_07',
        title: 'RGB LED: Mixing Colors with PWM',
        summary:
            'Harness Pulse Width Modulation (PWM) and additive color physics to generate millions of custom hues.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 20,
        prerequisites: ['lesson_05'],
        componentIds: ['comp_uno', 'comp_breadboard'],
        steps: [
          LessonStep(
            stepId: 'l07_s01',
            title: 'Additive Optics & PWM',
            type: StepType.story,
            markdownContent:
                'Mix Red, Green, and Blue light using Pulse Width Modulation (PWM).',
          ),
          LessonStep(
            stepId: 'l07_s02',
            title: 'analogWrite() Color Studio',
            type: StepType.codeExperiment,
            interactiveWidgetType: 'rgbMixer',
            markdownContent:
                'analogWrite(pin, value); switches the digital pin hundreds of times per second.',
          ),
          LessonStep(
            stepId: 'l07_s03',
            title: 'Color Mixing Quiz',
            type: StepType.quizCheckpoint,
            markdownContent: 'What color is produced by Red + Green light?',
            interactiveConfig: {
              'question': 'Red + Green light makes what color?',
              'options': [
                'Yellow',
                'Cyan',
                'Magenta',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 90,
      ),
      Lesson(
        id: 'lesson_08',
        title: 'Digital Inputs: Pushbuttons & Internal Pullups',
        summary:
            'Detect physical button presses and master the internal pullup resistor to prevent floating pins.',
        tier: DifficultyTier.rookie,
        estimatedMinutes: 18,
        prerequisites: ['lesson_05'],
        componentIds: ['comp_uno', 'comp_breadboard'],
        steps: [
          LessonStep(
            stepId: 'l08_s01',
            title: 'Floating Inputs and Electromagnetic Interference',
            type: StepType.story,
            markdownContent:
                'Unconnected CMOS input pins act like antennas, picking up stray electromagnetic noise.',
          ),
          LessonStep(
            stepId: 'l08_s02',
            title: 'INPUT_PULLUP and Inverted Logic',
            type: StepType.codeExperiment,
            markdownContent:
                'pinMode(buttonPin, INPUT_PULLUP); enables the internal 20k-50k ohm pullup resistor.',
          ),
          LessonStep(
            stepId: 'l08_s03',
            title: 'Digital Input Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent:
                'What state is read when a pullup button is pressed to GND?',
            interactiveConfig: {
              'question':
                  'What state does digitalRead() return when an INPUT_PULLUP button is pressed?',
              'options': [
                'LOW (0V)',
                'HIGH (5V)',
                'Floating',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 70,
      ),
      Lesson(
        id: 'lesson_09',
        title: 'The I2C Communication Bus',
        summary:
            'Network multiple sensors and displays over two shared wires using the Inter-Integrated Circuit protocol.',
        tier: DifficultyTier.builder,
        estimatedMinutes: 20,
        prerequisites: ['lesson_03', 'lesson_04'],
        componentIds: ['comp_uno', 'comp_07', 'comp_10'],
        steps: [
          LessonStep(
            stepId: 'l09_s01',
            title: 'The Shared 2-Wire Highway: SDA and SCL',
            type: StepType.story,
            markdownContent:
                'I2C networks up to 127 devices using just two wires: SDA (data) and SCL (clock).',
          ),
          LessonStep(
            stepId: 'l09_s02',
            title: 'Addressing and Bus Collisions',
            type: StepType.visualExplanation,
            markdownContent:
                'Every I2C peripheral has a unique 7-bit hexadecimal address like 0x27 or 0x68.',
          ),
          LessonStep(
            stepId: 'l09_s03',
            title: 'I2C Bus Protocol Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent:
                'How many signal wires does I2C use for communication?',
            interactiveConfig: {
              'question':
                  'How many signal wires does I2C require (excluding power and ground)?',
              'options': [
                '2 wires (SDA and SCL)',
                '4 wires (MOSI, MISO, SCK, SS)',
                '8 parallel wires',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 80,
      ),
      Lesson(
        id: 'lesson_10',
        title: 'The High-Speed SPI Protocol',
        summary:
            'Stream data at megahertz clock speeds using 4-wire Serial Peripheral Interface.',
        tier: DifficultyTier.engineer,
        estimatedMinutes: 20,
        prerequisites: ['lesson_09'],
        componentIds: ['comp_uno', 'comp_15', 'comp_23'],
        steps: [
          LessonStep(
            stepId: 'l10_s01',
            title: 'Synchronous Full-Duplex Speed',
            type: StepType.story,
            markdownContent:
                'SPI uses 4 dedicated lines (MOSI, MISO, SCK, SS) to achieve clock speeds up to 10+ MHz.',
          ),
          LessonStep(
            stepId: 'l10_s02',
            title: 'Chip Select (SS) Bus Arbitration',
            type: StepType.visualExplanation,
            markdownContent:
                'The Master controller pulls a specific peripheral Slave Select (SS) LOW to talk to it.',
          ),
          LessonStep(
            stepId: 'l10_s03',
            title: 'SPI Protocol Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent: 'What line selects which SPI device is active?',
            interactiveConfig: {
              'question':
                  'Which SPI line activates a specific peripheral device?',
              'options': [
                'SS / CS (Slave Select / Chip Select pulled LOW)',
                'MOSI',
                'MISO',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 90,
      ),
      Lesson(
        id: 'lesson_11',
        title: 'Serial UART & Wireless Communication',
        summary:
            'Master universal asynchronous reception and transmission to control robots wirelessly.',
        tier: DifficultyTier.engineer,
        estimatedMinutes: 20,
        prerequisites: ['lesson_04'],
        componentIds: ['comp_uno', 'comp_29'],
        steps: [
          LessonStep(
            stepId: 'l11_s01',
            title: 'Asynchronous Point-to-Point Links',
            type: StepType.story,
            markdownContent:
                'UART communicates without a clock wire by agreeing on a shared Baud Rate.',
          ),
          LessonStep(
            stepId: 'l11_s02',
            title: 'The Crossover Rule: TX to RX',
            type: StepType.visualExplanation,
            markdownContent:
                'Always cross lines: the transmitter TX connects to the receiver RX of the other device.',
          ),
          LessonStep(
            stepId: 'l11_s03',
            title: 'UART Protocol Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent:
                'How should TX and RX be connected between two devices?',
            interactiveConfig: {
              'question':
                  'How must UART transmit and receive pins be connected?',
              'options': [
                'TX connects to RX and RX connects to TX (crossover)',
                'TX to TX and RX to RX',
                'Both to Ground',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 90,
      ),
      Lesson(
        id: 'lesson_12',
        title: 'PWM & Motor Physics',
        summary:
            'Tame electromagnetic inductance! Drive DC motors and servos with PWM and H-bridge drivers.',
        tier: DifficultyTier.engineer,
        estimatedMinutes: 22,
        prerequisites: ['lesson_06', 'lesson_07'],
        componentIds: ['comp_uno', 'comp_33', 'comp_36', 'comp_l293d'],
        steps: [
          LessonStep(
            stepId: 'l12_s01',
            title: 'Inductive Kickback and Flyback Protection',
            type: StepType.story,
            markdownContent:
                'Motor coils collapse their magnetic fields when switched off, creating destructive back-EMF voltage spikes.',
          ),
          LessonStep(
            stepId: 'l12_s02',
            title: 'H-Bridge Direction Control and Shoot-Through',
            type: StepType.codeExperiment,
            markdownContent:
                'An H-bridge motor driver (like L293D) routes current in either direction without short circuits.',
          ),
          LessonStep(
            stepId: 'l12_s03',
            title: 'Motor Physics Checkpoint',
            type: StepType.quizCheckpoint,
            markdownContent:
                'Why must you use a flyback diode with an inductive motor?',
            interactiveConfig: {
              'question':
                  'Why is a flyback diode required across DC motor terminals?',
              'options': [
                'To safely clamp high-voltage inductive kickback spikes',
                'To make the motor run in reverse',
                'To amplify the motor speed',
              ],
              'correctIndex': 0,
            },
          ),
        ],
        xpReward: 100,
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
