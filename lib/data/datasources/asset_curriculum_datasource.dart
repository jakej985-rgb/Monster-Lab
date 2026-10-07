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
      final data = await _assetBundle
          .loadString('assets/curriculum/curriculum_manifest.json');
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static List<CourseModel>? _cachedBaselineCourses;

  List<CourseModel> getBaselineCourses() {
    return _cachedBaselineCourses ??= [
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
        placementLessonId: 'cf_01',
        prerequisites: [],
        xpReward: 500,
        estimatedMinutes: 60,
      ),
      const CourseModel(
        id: 'lesson_2a',
        title: 'Course 2A: Basic Sensors',
        summary: 'Explore basic analog and digital sensors.',
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
        xpReward: 600,
        estimatedMinutes: 90,
      ),
      const CourseModel(
        id: 'lesson_2b',
        title: 'Course 2B: Actuators',
        summary: 'Control physical movement with servos and motors.',
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
        xpReward: 600,
        estimatedMinutes: 90,
      ),
    ];
  }

  static List<Lesson>? _cachedBaselineLessons;

  /// Initial curriculum foundation lessons (Lessons 1 through 12, expanded 12–14 steps)
  List<Lesson> getBaselineLessons() {
    return _cachedBaselineLessons ??=
        (jsonDecode(_baselineLessonsJson) as List<dynamic>)
            .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
            .toList();
  }

  static const String _baselineLessonsJson = r'''[
  {
    "id": "lesson_01",
    "title": "What is Arduino & How Does It Work?",
    "summary": "Discover the brain of your robot! Learn what microcontrollers do, explore the pins, and understand how power flows.",
    "tier": "rookie",
    "estimatedMinutes": 18,
    "prerequisites": [],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s01",
        "title": "Meet the Monster Brain",
        "type": "story",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "A robot needs a brain! The **Arduino Uno** is a small microcontroller development board that reads information from the physical world and commands electronic mechanisms.\n\nIt can read a pushbutton, measure distance with an ultrasonic sensor, turn an LED on or off, control a motor through a driver chip, and talk to other smart devices.\n\nThe Arduino does not magically know what to do. A **program** tells it what to look for and what decisions to make.\n\n```\nSensor (Input) \u2794 Arduino Uno \u2794 Program Decision \u2794 Actuator (Output)\n```\n\nTest the interactive signal flow below to watch how information moves through the brain!"
      },
      {
        "stepId": "l01_s02",
        "title": "What Is a Microcontroller? Architecture & Vocabulary",
        "type": "story",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "A **microcontroller** is a self-contained computer on a single chip, built specifically to interact with electrical hardware. Unlike a desktop computer with a monitor and keyboard, a microcontroller lives inside devices.\n\nIt contains:\n- **CPU (Processor)**: Executes your code instructions up to 16 million times per second (16 MHz).\n- **Flash Memory**: Stores your compiled sketch even when power is turned off.\n- **RAM**: Holds temporary variables and sensor readings while running.\n- **GPIO Pins**: General Purpose Input/Output connections that wire into circuits.\n\n### Core Vocabulary\n- **Microcontroller**: A compact computer engineered to control physical electronics.\n- **Program (Sketch)**: Step-by-step instructions that tell the controller what logic to execute.\n- **Input**: Sensory data flowing **into** the controller from the world.\n- **Output**: A physical voltage or command sent **out** to control hardware."
      },
      {
        "stepId": "l01_s03",
        "title": "Inputs vs Outputs: Think Like a Robot",
        "type": "story",
        "interactiveWidgetType": "inputOutputClassification",
        "markdownContent": "Robots interact with reality through two fundamental types of hardware:\n\n### 1. Inputs (The Senses)\nSensors collect data from the environment and send electrical signals into the Arduino:\n- **Pushbutton**: Senses physical finger touch\n- **Ultrasonic Sensor**: Measures distance by bouncing sound waves\n- **Potentiometer**: Reads the angle of a rotating knob\n- **Light Sensor (LDR)**: Measures environmental room brightness\n\n### 2. Outputs (The Muscles & Voices)\nActuators receive voltage commands from the Arduino to change the physical world:\n- **LED**: Shines colored light\n- **Piezo Buzzer**: Vibrates to create beeps and musical tones\n- **4-Digit Display**: Shows numbers and scores\n- **Servo Motor**: Moves arms and steers robot wheels\n\n### Classification Mission\nClassify each hardware component in the mission below as an **Input** or **Output**!"
      },
      {
        "stepId": "l01_s04",
        "title": "Digital vs Analog Signals & Prediction",
        "type": "visualExplanation",
        "interactiveWidgetType": "arduinoBoardInspector",
        "markdownContent": "Electronics communicate using two distinct types of electrical signals:\n\n### 1. Digital Signals (Binary)\nDigital signals have only **two discrete states**:\n- **HIGH**: +5.0 Volts (ON / TRUE / Binary 1)\n- **LOW**: 0.0 Volts (OFF / FALSE / Binary 0)\nLike a simple light switch, a digital pin is either fully powered or off.\n\n### 2. Analog Signals (Continuous)\nAnalog signals can represent **any smooth value** across a continuous range between 0.0V and 5.0V.\nThe Arduino uses an internal **Analog-to-Digital Converter (ADC)** on pins A0\u2013A5 to convert voltage into an integer from **0 to 1023**.\n\nExplore both signal modes below and test your prediction on potentiometer behavior!"
      },
      {
        "stepId": "l01_s05",
        "title": "Meet the Arduino Uno: Physical Hardware Mission",
        "type": "physicalTask",
        "interactiveWidgetType": "boardLabelDragDrop",
        "markdownContent": "Take your Arduino Uno development board in your hands. Look closely at the surface-mount components, pin headers, and silk-screen labels.\n\n### Key Board Landmarks to Identify:\n1. **USB Type-B Port**: Connects to your PC for code uploading and delivers 5V DC power.\n2. **DC Barrel Jack**: External power input (accepts 7V\u201312V from battery pack or wall adapter).\n3. **Digital Pins 0\u201313**: Top header pins for binary inputs and outputs (pins with `~` support PWM).\n4. **Analog Pins A0\u2013A5**: Bottom right header reading continuous sensory voltages.\n5. **Power Rails (5V & 3.3V)**: Regulated power sources for sensors and breadboard circuits.\n6. **GND (Ground)**: The 0V reference potential and return path for all electricity.\n7. **Reset Button**: Restarts your program from the very beginning of `setup()`.\n8. **Built-in LED**: Amber test LED connected internally to Digital Pin 13.\n\nDrag and match each label badge to its corresponding landmark below!"
      },
      {
        "stepId": "l01_s06",
        "title": "Why Power and Ground Matter: Complete Circuits",
        "type": "story",
        "interactiveWidgetType": "groundTroubleshooting",
        "markdownContent": "Electricity can only do work when it flows in an **unbroken, closed loop**.\n\nIn every electronic circuit:\n1. Energy leaves the positive power supply (+5V).\n2. It travels through wires and components (resistors, LEDs, sensors).\n3. It returns safely to **Ground (GND)**.\n\n```\n+5V Power Rail \u2794 Current-Limiting Resistor \u2794 LED Anode \u2794 GND Return Rail\n```\n\n> **The Ground Invariant**: GND is not a trash bin where electricity disappears! It is the zero-volt reference and the return highway for electron current. If the GND wire is loose or disconnected, the circuit opens, current drops to 0 mA, and nothing works.\n\nTest the 4 circuit conditions below to observe normal, open, loose, and shorted ground connections."
      },
      {
        "stepId": "l01_s07",
        "title": "How the Robot Brain Makes Decisions",
        "type": "story",
        "interactiveWidgetType": "decisionSimulator",
        "markdownContent": "The microcontroller brain doesn't guess what to do\u2014it processes a clear logic sequence:\n\n```\nCondition (Input) \u2794 Decision (Code Logic) \u2794 Action (Output)\n```\n\n### The 3-Step Decision Pipeline:\n1. **Input**: A finger pushes the button, closing the contacts and delivering 5V to Pin 2.\n2. **Decision**: The microcontroller runs code: `if (digitalRead(2) == HIGH)`. The condition evaluates to **TRUE**.\n3. **Action**: The program commands the output: `digitalWrite(13, HIGH);`, powering on the Pin 13 LED!\n\nPress and hold the virtual tactile button below to watch the decision pipeline evaluate live."
      },
      {
        "stepId": "l01_s08",
        "title": "Your First Instruction: Deconstructing digitalWrite",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "Before writing whole sketches, let's deconstruct the most famous instruction in robotics:\n\n```cpp\ndigitalWrite(13, HIGH);\n```\n\n### What Each Token Means:\n- `digitalWrite`: The function name. Commands a digital pin to output voltage.\n- `(` and `)`: Parentheses containing the arguments.\n- `13`: The pin number. Digital Pin 13 is connected to the onboard amber LED.\n- `,`: Comma separating the target pin from the state.\n- `HIGH`: The output state. Connects Pin 13 to +5 Volts.\n- `;`: The semicolon. Every instruction in C++ terminates with a semicolon, like a period.\n\nTap each code token below to inspect its job, then predict and simulate its hardware execution!"
      },
      {
        "stepId": "l01_s09",
        "title": "Trust but Verify: Scientific Engineering Method",
        "type": "story",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "Great robotics engineers never blindly upload code from the internet. They use the **Scientific Engineering Method**:\n\n```\nRead Code \u2794 Predict Outcome \u2794 Upload \u2794 Observe \u2794 Verify \u2794 Change & Test\n```\n\nBefore uploading any sketch to an Arduino board, always ask:\n1. Which pin number does this code command?\n2. Is my physical jumper wire plugged into that exact pin?\n3. What do the constants and delays mean?\n4. What physical motion or light do I predict will happen?\n\nPractice this habit below: Predict what happens when `HIGH` is replaced with `LOW`!"
      },
      {
        "stepId": "l01_s10",
        "title": "Real-World Systems: Obstacle Avoidance & Robot Vacuums",
        "type": "visualExplanation",
        "interactiveWidgetType": "realWorldSystemDiagram",
        "markdownContent": "The simple **Input \u2794 Decision \u2794 Output** pattern you just learned is the foundation of modern automation:\n\n- **Robot Vacuums**: Ultrasonic sensor measures distance to wall \u2794 if distance < 20cm \u2794 reverse right wheel to steer away.\n- **Automatic Supermarket Doors**: Motion sensor detects approaching customer \u2794 if motion detected \u2794 slide glass doors open for 5 seconds.\n- **Security Intruder Alarms**: Laser tripwire monitors doorway \u2794 if beam broken \u2794 blast siren and flash strobe lights.\n\nSelect each automated system below and simulate how it reacts to environmental triggers!"
      },
      {
        "stepId": "l01_s11",
        "title": "Troubleshooting Challenge: The Silent LED",
        "type": "story",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "A fellow robotics student calls you over in frustration: *\"I uploaded my sketch, but my LED refuses to light up!\"*\n\nInstead of randomly moving wires or rewriting code, follow the **4-Step Diagnostic Triage**:\n1. **Check Power**: Is the green ON LED lit on the Arduino?\n2. **Check Code**: What pin number is commanded `HIGH` in `digitalWrite`?\n3. **Check Physical Wiring**: Which header pin is the physical jumper wire actually plugged into?\n4. **Identify Mismatch**: Compare code pin vs physical pin!\n\nInspect the test bench below, find the pin mismatch bug, and fix the circuit!"
      },
      {
        "stepId": "l01_s12",
        "title": "Final Review & Self-Reflection",
        "type": "story",
        "interactiveWidgetType": "miniQuiz",
        "markdownContent": "Congratulations on completing your first robotics investigation! Let's review the fundamental principles:\n\n- The **Arduino Uno** is a microcontroller development board powered by the **ATmega328P chip**.\n- **Inputs** collect sensory data; **Outputs** perform physical work in the world.\n- **Digital signals** are strictly binary (0V or 5V); **Analog signals** represent smooth continuous ranges (0\u20131023 ADC).\n- Circuits require an unbroken loop: current flows from **+5V**, through components, and returns safely through **GND**.\n- Code instructions like `digitalWrite(pin, state);` command specific pins, so physical wiring must match code exactly.\n\nComplete the 4-question self-reflection check below before tackling the final Knowledge Check!"
      },
      {
        "stepId": "l01_s13",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of microcontrollers, signal types, power paths, and code prediction with this 8-question knowledge check.",
        "interactiveConfig": {
          "question": "What is GND used for in a typical circuit?",
          "options": [
            "Unlimited power",
            "A common reference and return path",
            "Storing the program"
          ],
          "correctIndex": 1,
          "explanation": "Ground (GND) is the 0V reference potential and essential return path for electric current.",
          "questions": [
            {
              "question": "What is a microcontroller?",
              "options": [
                "A small computer designed to control electronics",
                "A battery",
                "A mechanical switch"
              ],
              "correctIndex": 0,
              "explanation": "A microcontroller is a specialized chip combining CPU, memory, and IO peripherals to control hardware."
            },
            {
              "question": "A distance sensor sends information to Arduino. Is it an input or output?",
              "options": [
                "Input",
                "Output",
                "Power supply"
              ],
              "correctIndex": 0,
              "explanation": "Distance sensors gather environmental telemetry and feed data into the Arduino, making them inputs."
            },
            {
              "question": "An LED controlled by Arduino is an example of what?",
              "options": [
                "Input",
                "Output",
                "Ground"
              ],
              "correctIndex": 1,
              "explanation": "LEDs produce visual illumination based on controller pin voltages, making them outputs."
            },
            {
              "question": "What is GND used for in a typical circuit?",
              "options": [
                "Unlimited power",
                "A common reference and return path",
                "Storing the program"
              ],
              "correctIndex": 1,
              "explanation": "Ground (GND) is the 0V reference potential and essential return path for electric current."
            },
            {
              "question": "What does HIGH represent in a simple digital output?",
              "options": [
                "The output's high/on state (+5V)",
                "A program error",
                "A sensor failure"
              ],
              "correctIndex": 0,
              "explanation": "In 5V digital logic, HIGH commands the output transistor to connect to the positive 5V supply rail."
            },
            {
              "question": "What does \"13\" mean in \"digitalWrite(13, HIGH);\"?",
              "options": [
                "The pin being controlled",
                "The amount of memory",
                "The Arduino speed"
              ],
              "correctIndex": 0,
              "explanation": "The first parameter of digitalWrite specifies the target hardware pin on the ATmega328P header."
            },
            {
              "question": "A potentiometer produces a changing voltage as it turns. Is this digital or analog information?",
              "options": [
                "Analog",
                "Digital only",
                "Neither"
              ],
              "correctIndex": 0,
              "explanation": "Potentiometers output a continuously variable voltage division ratio between 0V and 5V."
            },
            {
              "question": "Why should you understand code before uploading it?",
              "options": [
                "So you can predict behavior and troubleshoot problems",
                "Arduino refuses copied code",
                "Every program must be memorized"
              ],
              "correctIndex": 0,
              "explanation": "Systematic programmers analyze pin assignments and logic to predict behavior before applying electrical power."
            }
          ]
        }
      }
    ],
    "xpReward": 50
  },
  {
    "id": "lesson_02",
    "title": "Setting Up Your Monster Lab Station",
    "summary": "Install the Arduino IDE, connect your board via USB, and verify serial communication link.",
    "tier": "rookie",
    "estimatedMinutes": 18,
    "prerequisites": [
      "lesson_01"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l02_s01",
        "title": "Give the Monster Its Voice",
        "type": "story",
        "markdownContent": "The Arduino is the robot's brain, but the brain needs instructions.\n\nYour computer is where you write those instructions. The **Arduino IDE** (Integrated Development Environment) is the workbench that lets you write sketches, verify syntax, compile machine binaries, upload them to the board, and monitor serial communications.\n\nThink of the engineering workflow as:\n```\nWrite Code \u2794 Check Syntax \u2794 Compile Binary \u2794 Upload Flash \u2794 Run Hardware\n```\n\nIn this lesson, you will set up your development station, select your communication port, and explore how firmware lifecycles work."
      },
      {
        "stepId": "l02_s02",
        "title": "Prior Knowledge Check: Computer Programs & USB",
        "type": "story",
        "interactiveWidgetType": "priorKnowledgeCheck",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Have you ever written a computer program before?",
              "options": [
                "Yes, I have written code before.",
                "A little bit / block coding.",
                "No, this is my very first time!"
              ],
              "correctIndex": null,
              "explanation": "No prior coding experience is required! Monster Lab teaches you step-by-step."
            },
            {
              "question": "What is a computer program?",
              "options": [
                "Step-by-step instructions that tell a computer what to do",
                "An electrical battery that stores power",
                "A special type of USB cable"
              ],
              "correctIndex": 0,
              "explanation": "A program is a sequence of precise instructions executed by a computer."
            },
            {
              "question": "What is the USB cable used for in Monster Lab?",
              "options": [
                "Connecting the computer to upload code and supply 5V DC power",
                "Supplying infinite high voltage to motors",
                "Making the Arduino wirelessly communicate"
              ],
              "correctIndex": 0,
              "explanation": "USB provides both serial communications for code uploading and regulated 5V power."
            }
          ]
        },
        "markdownContent": "Before setting up your programming workbench, let's check your foundational knowledge about computer software and USB hardware.\n\nAnswer the 3 self-reflection questions below to calibrate your learning path!"
      },
      {
        "stepId": "l02_s03",
        "title": "What Is an IDE? The Programmer's Workbench",
        "type": "story",
        "markdownContent": "**IDE** stands for **Integrated Development Environment**.\n\nThink of it as a master workshop for robotics software. Instead of using a text editor to write code, a separate command-line terminal to compile it, and a third utility to flash the microcontroller chip, the Arduino IDE bundles all essential tools into one unified workbench.\n\n### Core Vocabulary\n- **IDE**: Unified software used to write, compile, and upload sketches.\n- **Sketch**: An Arduino program file ending in `.ino`.\n- **Compile**: The process of translating human-readable C++ instructions into binary machine code.\n- **Upload**: Transmitting the compiled machine hex binary from PC memory into microcontroller flash storage.\n- **Port**: The virtual serial communication channel (e.g. `COM3` or `/dev/ttyUSB0`) connecting your PC to the board."
      },
      {
        "stepId": "l02_s04",
        "title": "Compilation & Flashing: What Happens When You Upload?",
        "type": "visualExplanation",
        "interactiveWidgetType": "compilationPipelineSimulator",
        "markdownContent": "When you click **Upload** in the IDE, your computer does not send C++ words directly to the ATmega328P chip. Microcontrollers cannot read English or C++! They only understand raw hexadecimal binary opcodes.\n\n### The 4-Stage Build & Flash Pipeline:\n1. **Human Source Code**: You write C++ functions (`setup()` and `loop()`).\n2. **Syntax Verification & Lexing**: The compiler checks grammar, matching braces `{ }`, and semicolons `;`.\n3. **Binary Compilation (avr-g++)**: Converts C++ text into machine opcodes (Intel HEX format).\n4. **Hardware Flash Flashing (avrdude)**: Streams bytes over USB serial into the Optiboot bootloader in flash memory.\n\nStep through each stage in the pipeline simulator below to see how code transforms into machine reality!"
      },
      {
        "stepId": "l02_s05",
        "title": "Connecting the USB Cable Safely",
        "type": "physicalTask",
        "markdownContent": "Connect your Arduino Uno development board to your computer using the standard USB Type-B cable.\n\n### Step-by-Step Connection Procedure:\n1. **Inspect Your Workspace**: Ensure your table is completely dry, clean, and free of loose conductive metal clippings or staples.\n2. **Plug Board End**: Firmly insert the square **USB Type-B** plug into the silver receptacle on your Arduino Uno until it clicks.\n3. **Plug Computer End**: Insert the flat rectangular **USB Type-A** plug into a powered USB port on your PC or laptop.\n4. **Verify Power Beacon**: Look at the Arduino Uno. The green surface-mount LED labeled **ON** should glow solid green, indicating regulated 5V power!"
      },
      {
        "stepId": "l02_s06",
        "title": "What Is a Port? Serial COM Ports & Device Drivers",
        "type": "story",
        "interactiveWidgetType": "portSelectorBench",
        "markdownContent": "A **port** is the communication channel your computer uses to identify and talk to external USB devices.\n\nOn Windows, ports are assigned names like `COM1`, `COM3`, `COM4`. On macOS and Linux, they appear as `/dev/cu.usbmodem...` or `/dev/ttyUSB0`.\n\nWhen you plug in the Arduino, an onboard interface chip (ATmega16U2 or CH340) creates a virtual UART serial communication bridge.\n\nIn the IDE menu under **Tools > Board**, choose **Arduino Uno**. Under **Tools > Port**, select the port corresponding to your Uno. Practice configuring the board and port in the virtual bench below, and initiate the serial handshake to flash TX and RX LEDs!"
      },
      {
        "stepId": "l02_s07",
        "title": "First Look at Arduino Code: setup() and loop() Structure",
        "type": "codeExperiment",
        "interactiveWidgetType": "ideLifecycleSimulator",
        "markdownContent": "Every Arduino sketch is built around two fundamental functions:\n\n```cpp\nvoid setup() {\n  // Hardware configuration \u2014 runs ONCE at boot or reset\n  pinMode(13, OUTPUT);\n}\n\nvoid loop() {\n  // Perpetual cycle \u2014 runs REPEATEDLY forever\n  digitalWrite(13, HIGH);\n  delay(1000);\n  digitalWrite(13, LOW);\n  delay(1000);\n}\n```\n\n- `setup()`: Initializes GPIO pin directions and communications. It runs exactly once when power is applied.\n- `loop()`: The infinite heartbeat of your robot. Once `setup()` finishes, the microcontroller jumps into `loop()` and orbits perpetually.\n\nRun the interactive lifecycle simulator below to watch `setup()` illuminate its beacon once, followed by the continuous orbit of `loop()`!"
      },
      {
        "stepId": "l02_s08",
        "title": "Code Prediction Challenge: Empty Setup vs Unbounded Loops",
        "type": "codeExperiment",
        "markdownContent": "Analyze and predict how the microcontroller executes when code structure changes:\n\n### Prediction Challenge 1: Empty setup(), Active loop()\nIf `setup()` is completely empty, does the Arduino freeze?\n*Answer:* No! `setup()` finishes in nanoseconds and immediately begins cycling `loop()`.\n\n### Prediction Challenge 2: Active setup(), Empty loop()\nIf an LED is turned ON inside `setup()`, and `loop()` has no code inside its braces `{ }`, what does the LED do?\n*Answer:* The LED turns ON in `setup()` and stays ON forever! The microcontroller continues running `loop()` endlessly at 16 MHz, maintaining the pin voltage state.\n\n> **Core Principle**: A microcontroller never powers down or \"exits\" unless electrical power is disconnected."
      },
      {
        "stepId": "l02_s09",
        "title": "Real-World Systems: NASA Mars Rovers & Embedded Firmware",
        "type": "visualExplanation",
        "markdownContent": "The `setup()` and `loop()` firmware architecture powers mission-critical robotics worldwide:\n\n- **NASA Mars Rovers (Curiosity & Perseverance)**: Execute diagnostic sensor self-tests upon wake-up (`setup()`), then run autonomous hazard-avoidance cycles continuously (`loop()`).\n- **Automotive Airbag Control Units**: Initialize SPI accelerometer calibrations at engine start, then monitor vehicle deceleration thresholds every 100 microseconds in an unbroken loop.\n- **Commercial Drones**: Zero out gyroscope bias on launch pads, then calculate motor thrust adjustments 400 times per second during flight."
      },
      {
        "stepId": "l02_s10",
        "title": "Troubleshooting Lab Station: Port Not Found & Driver Issues",
        "type": "story",
        "interactiveWidgetType": "portTroubleshootingBench",
        "markdownContent": "If the Arduino IDE reports *\"Port Not Found\"* or errors out during upload, do not panic! Professional robotics engineers use systematic triage:\n\n1. **Check Physical Connection**: Is the USB cable fully seated into the jack?\n2. **Check Port Selection**: Is the active Arduino COM port chosen, or an internal motherboard port like COM1?\n3. **Check USB Drivers**: Does your board use a CH340 or CP2102 chip that requires an OS device driver?\n4. **Check Board Power**: Does the green ON LED illuminate, proving 5V power?\n\nInspect each diagnostic check in the triage bench below, resolve all 4 faults, and restore full communication link!"
      },
      {
        "stepId": "l02_s11",
        "title": "Workshop Safety: Electrostatic Discharge (ESD) & Surge Prevention",
        "type": "story",
        "interactiveWidgetType": "esdSafetyCheck",
        "markdownContent": "Microcontrollers are sensitive CMOS semiconductor devices. A spark of static electricity under 3,000 volts\u2014too faint for human fingers to feel\u2014can permanently destroy internal silicon transistor gate oxide layers!\n\n### The 3 Golden Rules of ESD Defense:\n1. **Touch Grounded Metal**: Touch a metal desk frame or radiator before handling boards to discharge accumulated static charge to 0V.\n2. **Avoid Static Generators**: Never assemble circuits directly on synthetic carpet or wool blankets.\n3. **Grip PCB Edges**: Always pick up boards by the outer fiberglass edges. Never touch exposed IC pins or header pins directly with your fingers.\n\nPractice proper ESD grounding in the interactive lab below to bring your static voltage potential down to a safe 0 Volts!"
      },
      {
        "stepId": "l02_s12",
        "title": "Station Setup Review & Competencies",
        "type": "story",
        "markdownContent": "Congratulations! You have set up your Monster Lab development station. Review your core competencies:\n\n- You understand how the Arduino IDE coordinates writing, verifying, compiling, and flashing code.\n- You know how to identify and select target microcontroller boards and serial communication ports.\n- You recognize the vital roles of `setup()` (initialization, runs 1x) and `loop()` (perpetual execution).\n- You can systematically troubleshoot disconnected ports and missing USB bridge drivers.\n- You apply electrostatic discharge (ESD) safety protocols to protect your hardware.\n\nComplete the comprehensive 8-question assessment below to earn your XP and proceed to Lesson 03!"
      },
      {
        "stepId": "l02_s13",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of IDE compilation, USB device drivers, COM ports, and firmware lifecycles.",
        "interactiveConfig": {
          "question": "What does IDE stand for?",
          "options": [
            "Integrated Development Environment.",
            "Internal Digital Engine.",
            "Input Device Electronics."
          ],
          "correctIndex": 0,
          "explanation": "IDE stands for Integrated Development Environment\u2014the unified coding and flashing workbench.",
          "questions": [
            {
              "question": "What does IDE stand for?",
              "options": [
                "Integrated Development Environment.",
                "Internal Digital Engine.",
                "Input Device Electronics."
              ],
              "correctIndex": 0,
              "explanation": "IDE stands for Integrated Development Environment\u2014the unified coding and flashing workbench."
            },
            {
              "question": "What is an Arduino sketch?",
              "options": [
                "An Arduino program/project.",
                "A battery.",
                "A USB port."
              ],
              "correctIndex": 0,
              "explanation": "An Arduino sketch is the C++ program file containing setup() and loop() routines."
            },
            {
              "question": "What does compiling do?",
              "options": [
                "Converts source code into a form suitable for the target system.",
                "Supplies electricity to the Arduino.",
                "Connects the USB cable."
              ],
              "correctIndex": 0,
              "explanation": "The compiler translates human-readable C++ source text into hexadecimal machine opcodes."
            },
            {
              "question": "What does Upload do?",
              "options": [
                "Sends the program to the Arduino.",
                "Deletes the Arduino.",
                "Changes the USB cable."
              ],
              "correctIndex": 0,
              "explanation": "Upload uses the avrdude utility to transfer compiled hex binary through USB into microcontroller flash memory."
            },
            {
              "question": "Why must you select the correct board?",
              "options": [
                "Different boards can use different hardware and programming requirements.",
                "The board name changes the USB cable.",
                "The Arduino cannot store programs."
              ],
              "correctIndex": 0,
              "explanation": "Different microcontroller boards use distinct pin layouts, register maps, and flash sizes."
            },
            {
              "question": "What does the port identify?",
              "options": [
                "The computer's communication connection to the Arduino.",
                "The Arduino's battery level.",
                "The program's XP reward."
              ],
              "correctIndex": 0,
              "explanation": "The serial COM port provides the virtual UART communication link between host OS and the Uno board."
            },
            {
              "question": "What does setup() do?",
              "options": [
                "Runs once when the Arduino starts or resets.",
                "Runs continuously forever.",
                "Deletes the sketch."
              ],
              "correctIndex": 0,
              "explanation": "void setup() executes once upon microcontroller boot or hardware reset to initialize peripherals."
            },
            {
              "question": "What does loop() normally do?",
              "options": [
                "Repeatedly runs the code placed inside it.",
                "Selects the USB port.",
                "Compiles the computer's operating system."
              ],
              "correctIndex": 0,
              "explanation": "void loop() is called repeatedly in a perpetual cycle to process real-time events."
            }
          ]
        }
      }
    ],
    "xpReward": 50
  },
  {
    "id": "lesson_03",
    "title": "Installing Libraries: Supercharging Code",
    "summary": "Understand open-source modular libraries and how to install them with the Library Manager.",
    "tier": "builder",
    "estimatedMinutes": 18,
    "prerequisites": [
      "lesson_02"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_s01",
        "title": "Supercharge Your Monster's Brain",
        "type": "story",
        "markdownContent": "Robots rely on specialized external modules: character displays, motor drivers, gyro sensors, and real-time clocks. Controlling a 16x2 LCD display via raw 8-bit parallel pulses requires toggling 16 separate pins and managing microsecond pulse timings.\n\nIf robotics engineers had to write low-level bit-banging code for every single display, building a project would take months!\n\n**Libraries** package proven, robust C++ driver code written by experienced engineers so you can command complex hardware with high-level functions like `lcd.print(\"Monster Online!\");`.\n\n```\nYour Sketch \u2794 #include <LiquidCrystal_I2C.h> \u2794 Library Driver \u2794 I2C Bus (A4/A5) \u2794 16x2 LCD Display\n```\n\nIn this lesson, you will install external libraries, deconstruct preprocessor syntax, and calibrate an I2C character LCD display!"
      },
      {
        "stepId": "l03_s02",
        "title": "Prior Knowledge Check: Microcontroller Libraries",
        "type": "story",
        "interactiveWidgetType": "priorKnowledgeCheck",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the primary role of a software library in Arduino?",
              "options": [
                "Providing pre-written functions and drivers that manage complex hardware protocols",
                "Increasing the physical clock frequency of the ATmega328P processor",
                "Converting alternating current (AC) into direct current (DC)"
              ],
              "correctIndex": 0,
              "explanation": "Libraries encapsulate hundreds of lines of timing and register code into clean function calls."
            },
            {
              "question": "What is a C++ header file (.h)?",
              "options": [
                "A file containing class definitions, method prototypes, and constants exposed by a library",
                "A physical header pin soldered onto the Arduino Uno development board",
                "A power cable connector for lithium-polymer batteries"
              ],
              "correctIndex": 0,
              "explanation": "Header files define the interface and available methods exposed by an external library."
            },
            {
              "question": "How many communication signal wires does the I2C protocol require?",
              "options": [
                "Only 2 shared wires (SDA for data, SCL for clock)",
                "16 separate parallel wires",
                "8 analog wires"
              ],
              "correctIndex": 0,
              "explanation": "I2C operates over just two shared bus wires (SDA and SCL), dramatically simplifying wiring."
            }
          ]
        },
        "markdownContent": "Before working with modular drivers and display backpacks, let's verify your understanding of code abstraction and bus communication.\n\nAnswer the 3 self-check questions below to test your baseline knowledge!"
      },
      {
        "stepId": "l03_s03",
        "title": "The Power of Libraries: Raw Registers vs Clean Abstraction",
        "type": "story",
        "interactiveWidgetType": "libraryConceptDiagram",
        "markdownContent": "Why do professional embedded engineers rely on libraries? Look at the difference:\n\n### Without Library (Bit-Banging Raw Hardware)\nDriving an I2C LCD directly requires over 500 lines of complex register manipulation (`TWCR`, `TWDR`), manual I2C start/stop condition pulses, splitting each character into two 4-bit nibbles, and microsecond delay loops.\n\n### With Library (Modular Abstraction)\nWith the `LiquidCrystal_I2C` library, all 500 lines of timing pulses are packaged away. You only need two clean function calls:\n```cpp\nlcd.init();\nlcd.print(\"Monster Online!\");\n```\n\nToggle between both architectures in the diagram below to see how libraries supercharge development!"
      },
      {
        "stepId": "l03_s04",
        "title": "How It Works: Finding & Installing Libraries",
        "type": "visualExplanation",
        "interactiveWidgetType": "libraryManagerSimulator",
        "markdownContent": "The Arduino IDE includes a built-in **Library Manager** connected to an open-source global registry of thousands of community-verified drivers.\n\n### How to Install a Library in Arduino IDE:\n1. Open **Tools > Manage Libraries...** (or click the Library Manager icon on the left sidebar).\n2. Type the name of the library (for example, `LiquidCrystal_I2C`) into the search box.\n3. Locate the verified library authored by Frank de Brabander.\n4. Click **Install**. The IDE downloads the header files (`.h`), C++ implementations (`.cpp`), and example sketches directly into your `~/Arduino/libraries/` folder.\n\nTest the interactive Library Manager below to search, download, and install `LiquidCrystal_I2C`!"
      },
      {
        "stepId": "l03_s05",
        "title": "Hardware Mission: The 16x2 LCD Display & Contrast Potentiometer",
        "type": "physicalTask",
        "interactiveWidgetType": "lcdContrastSimulator",
        "markdownContent": "Examine your **16x2 Character LCD Display with I2C Backpack** (`comp_07`):\n\n### Key Hardware Landmarks:\n1. **The I2C Backpack**: Turn the module over. Notice the black printed circuit board soldered to the back. This contains the PCF8574 I/O expander chip.\n2. **The 4-Pin Header**: Without this backpack, you would need 16 jumper wires! With I2C, you only need 4:\n   - `GND`: Ground 0V return path\n   - `VCC`: +5V power supply\n   - `SDA`: Serial Data (connects to Uno Pin A4)\n   - `SCL`: Serial Clock (connects to Uno Pin A5)\n3. **The Blue Contrast Trimmer**: Locate the small blue square potentiometer with the brass screw on the back. It controls liquid crystal bias voltage (V0).\n\nThe #1 troubleshooting issue is misadjusted contrast! Tune the virtual trimmer potentiometer screw below to find the sweet spot between blank screen and solid white blocks."
      },
      {
        "stepId": "l03_s06",
        "title": "Coding Basics: Deconstructing the #include Directive",
        "type": "story",
        "interactiveWidgetType": "includeSyntaxDeconstruction",
        "markdownContent": "To use an installed library, your sketch must instruct the C++ compiler to load its interface definitions:\n\n```cpp\n#include <LiquidCrystal_I2C.h>\n```\n\n### Syntax Breakdown:\n- `#`: Preprocessor flag indicating a compiler directive evaluated before compilation begins.\n- `include`: Command instructing the compiler to literally insert the contents of the header file.\n- `< >`: Angle brackets tell the compiler to search the system/installed libraries directory.\n- `.h`: The header file extension containing class definitions and function signatures.\n\nTap each syntax token below to inspect its rules and avoid common syntax traps!"
      },
      {
        "stepId": "l03_s07",
        "title": "Code Walkthrough: Annotated LiquidCrystal_I2C Sketch",
        "type": "codeExperiment",
        "markdownContent": "Examine a complete sketch driving the 16x2 character display:\n\n```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// Create the LCD object: Address 0x27, 16 columns, 2 rows\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();          // Initialize LCD hardware over I2C\n  lcd.backlight();     // Turn on the blue LED backlight\n  lcd.setCursor(0, 0); // Column 0, Row 0\n  lcd.print(\"Monster Lab!\");\n  lcd.setCursor(0, 1); // Column 0, Row 1\n  lcd.print(\"System Active\");\n}\n\nvoid loop() {\n  // Static display \u2014 loop remains idle\n}\n```\n\n### Key Function Calls:\n- `LiquidCrystal_I2C lcd(...)`: The **constructor**. Instantiates an object named `lcd` at hex address `0x27`.\n- `lcd.init()`: Configures internal HD44780 controller registers over the I2C bus.\n- `lcd.backlight()`: Powers on the display illumination LED.\n- `lcd.setCursor(col, row)`: Places the writing cursor at the specified zero-indexed grid coordinate."
      },
      {
        "stepId": "l03_s08",
        "title": "Code Prediction: Missing Backlight & Out-of-Bounds Cursors",
        "type": "codeExperiment",
        "markdownContent": "Practice scientific engineering deductions before flashing code:\n\n### Prediction 1: What happens if lcd.backlight() is omitted?\n*Answer:* The characters are still generated by the liquid crystal molecules, but without the LED backlight, the dark blue screen is nearly impossible to read without shining a flashlight directly onto it!\n\n### Prediction 2: What happens if you call lcd.setCursor(16, 0)?\n*Answer:* Columns are zero-indexed from 0 to 15. Column 16 is off the visible screen! The characters will wrap into hidden DDRAM display memory registers and remain invisible."
      },
      {
        "stepId": "l03_s09",
        "title": "Guided Experiment: Dynamic Uptime Counter",
        "type": "codeExperiment",
        "markdownContent": "Let's make the display dynamic! Instead of static text, we can update Row 1 continuously with live system uptime:\n\n```cpp\nvoid loop() {\n  lcd.setCursor(0, 1);\n  lcd.print(\"Uptime: \");\n  lcd.print(millis() / 1000);\n  lcd.print(\"s   \"); // Extra spaces erase trailing old digits\n  delay(500);\n}\n```\n\n### Why the trailing spaces matter:\nWhen a 2-digit number (e.g. `99`) rolls over to a 3-digit number (`100`), or drops back down, older characters remain in LCD RAM unless explicitly overwritten with space characters `\"   \"`!"
      },
      {
        "stepId": "l03_s10",
        "title": "Real-World Robotics: Hardware Abstraction Layers",
        "type": "visualExplanation",
        "markdownContent": "The modular library architecture you learned is used in every advanced engineering discipline:\n\n- **Autonomous Electric Vehicles**: Autonomous drive computers don't send raw PWM pulses to motor windings directly. They call driver libraries: `motorController.setTorqueNm(240);`.\n- **Medical Ventilators**: Airflow sensors and solenoid valves are controlled through certified Hardware Abstraction Layers (HAL) to prevent timing glitches.\n- **3D Printers**: Firmware like Marlin uses stepper motor and thermal thermistor libraries to coordinate micro-stepping smoothly."
      },
      {
        "stepId": "l03_s11",
        "title": "Troubleshooting Challenge: Missing Header & Blank Displays",
        "type": "story",
        "interactiveWidgetType": "missingLibraryTroubleshooting",
        "markdownContent": "You verify a sketch and the compiler halts with a bright red fatal error:\n\n```\nfatal error: LiquidCrystal_I2C.h: No such file or directory\n#include <LiquidCrystal_I2C.h>\n         ^~~~~~~~~~~~~~~~~~~~~\ncompilation terminated.\n```\n\nThis means the preprocessor searched your system libraries folder and could not find the file `LiquidCrystal_I2C.h`.\n\nResolve this compilation failure in the interactive triage station below by installing the missing library!"
      },
      {
        "stepId": "l03_s12",
        "title": "Workshop Safety & Hardware Care: LCD Voltage Ratings",
        "type": "story",
        "markdownContent": "Protect your LCD modules and microcontroller with these workshop rules:\n\n1. **Check Operating Voltage**: Most character LCD backpacks run on 5V. Supplying 5V power to a 3.3V-only display can permanently fry its internal driver chip.\n2. **Disconnect Power Before Rewiring**: Never move or rewire `VCC`, `GND`, `SDA`, or `SCL` jumper wires while the USB cable is plugged in.\n3. **Use Plastic or Insulated Screwdrivers**: When adjusting the blue contrast trimmer on the back of the backpack, use a small insulated trimmer tool to avoid accidentally shorting adjacent exposed solder pads."
      },
      {
        "stepId": "l03_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "Outstanding work! Let's review the key competencies you mastered in Lesson 03:\n\n- You understand how libraries encapsulate low-level register bit-banging into clean C++ functions.\n- You know how to search and install community libraries using the Arduino IDE Library Manager.\n- You can deconstruct the `#include <LibraryName.h>` preprocessor syntax.\n- You know how to calibrate LCD liquid crystal contrast using the blue backpack trimmer potentiometer.\n- You can diagnose and fix `'No such file or directory'` compiler errors.\n\nComplete the 8-question assessment below to earn your XP and proceed to Lesson 04!"
      },
      {
        "stepId": "l03_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of Arduino libraries, header syntax, I2C addressing, and LCD contrast tuning.",
        "interactiveConfig": {
          "question": "What is the primary purpose of an Arduino library?",
          "options": [
            "They speed up code by writing complex hardware protocols for you",
            "They double the CPU clock speed of the Arduino",
            "They convert AC electricity into DC electricity"
          ],
          "correctIndex": 0,
          "explanation": "Correct: They speed up code by writing complex hardware protocols for you. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What is the primary purpose of an Arduino library?",
              "options": [
                "They speed up code by writing complex hardware protocols for you",
                "They double the CPU clock speed of the Arduino",
                "They convert AC electricity into DC electricity"
              ],
              "correctIndex": 0,
              "explanation": "Correct: They speed up code by writing complex hardware protocols for you. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which preprocessor command is used to add a library to a sketch?",
              "options": [
                "`#include <LibraryName.h>`",
                "`import LibraryName;`",
                "`using namespace LibraryName;`"
              ],
              "correctIndex": 0,
              "explanation": "Correct: `#include <LibraryName.h>`. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "In `LiquidCrystal_I2C lcd(0x27, 16, 2);`, what does `0x27` represent?",
              "options": [
                "The 7-bit hexadecimal I2C device address",
                "The pin number connected to the LCD",
                "The operating temperature limit in Celsius"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The 7-bit hexadecimal I2C device address. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Where inside the Arduino IDE can you search for and install community libraries?",
              "options": [
                "Tools > Manage Libraries (or the Library Manager tab)",
                "File > Preferences > Upload",
                "Help > Drivers"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Tools > Manage Libraries (or the Library Manager tab). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What do the numbers `16, 2` indicate in the LCD constructor?",
              "options": [
                "16 columns and 2 rows of characters",
                "16 volts and 2 amperes",
                "16 MHz processor and 2 KB SRAM"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 16 columns and 2 rows of characters. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "If your code compiles cleanly but the LCD shows solid white boxes, what should you adjust first?",
              "options": [
                "The blue contrast potentiometer on the back of the module",
                "Reinstall the Arduino IDE",
                "Replace the Uno microcontroller chip"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The blue contrast potentiometer on the back of the module. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why does using an I2C backpack library save wiring compared to standard parallel LCDs?",
              "options": [
                "It reduces required data pins from 10+ down to 2 shared bus lines",
                "It eliminates the need for power and ground wires",
                "It transmits data over Wi-Fi"
              ],
              "correctIndex": 0,
              "explanation": "Correct: It reduces required data pins from 10+ down to 2 shared bus lines. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What file extension designates C++ header files in libraries?",
              "options": [
                "`.h`",
                "`.ino`",
                "`.hex`"
              ],
              "correctIndex": 0,
              "explanation": "Correct: `.h`. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 60
  },
  {
    "id": "lesson_04",
    "title": "Basics of the Arduino IDE: Setup and Loop",
    "summary": "Master the core microcontroller lifecycle: setup() once, loop() forever, and serial monitoring.",
    "tier": "rookie",
    "estimatedMinutes": 18,
    "prerequisites": [
      "lesson_02"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s01",
        "title": "The Never-Sleeping Monster Brain",
        "type": "story",
        "markdownContent": "Unlike desktop programs that launch, calculate a spreadsheet, and quit, a robot's brain must never terminate! It must continuously monitor distance sensors, evaluate obstacle hazards, and drive motors thousands of times per second until battery power is switched off.\n\nIn this lesson, you will master the two fundamental functions of embedded systems: `setup()`\u2014the one-time initialization routine\u2014and `loop()`\u2014the perpetual heartbeat of your monster robot. You will also unlock the **Serial Monitor**, the primary debugging terminal that lets your Arduino talk directly to your computer screen.\n\n```\nPower On \u2794 setup() Initial Setup \u2794 while(1) { loop(); Serial Telemetry; } Forever\n```"
      },
      {
        "stepId": "l04_s02",
        "title": "Prior Knowledge Check: Firmware Loops & Semicolons",
        "type": "story",
        "interactiveWidgetType": "priorKnowledgeCheck",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How many times does code inside void setup() execute after board startup or reset?",
              "options": [
                "Exactly once",
                "Continuously in an infinite loop",
                "Ten times per second"
              ],
              "correctIndex": 0,
              "explanation": "setup() runs exactly once upon microcontroller startup or hardware reset."
            },
            {
              "question": "What is the primary role of void loop() in robotics firmware?",
              "options": [
                "To repeatedly run sensing, decision logic, and actuator commands forever",
                "To shut down the Arduino when code calculations finish",
                "To format internal flash storage"
              ],
              "correctIndex": 0,
              "explanation": "Embedded microcontrollers run loop() perpetually to react to real-time physical events."
            },
            {
              "question": "What character must terminate every standard C++ instruction statement in Arduino?",
              "options": [
                "Semicolon (;)",
                "Colon (:)",
                "Period (.)"
              ],
              "correctIndex": 0,
              "explanation": "In C++, semicolons are mandatory statement terminators."
            }
          ]
        },
        "markdownContent": "Before exploring serial telemetry and syntax debugging, test your baseline understanding of microcontroller lifecycles.\n\nComplete the 3 questions below to prepare for the lesson!"
      },
      {
        "stepId": "l04_s03",
        "title": "Core Concept & Vocabulary: Functions, Blocks & Baud Rates",
        "type": "story",
        "markdownContent": "Master the foundational vocabulary of embedded software:\n\n### Core Vocabulary\n- **`setup()`**: Executes exactly once upon board power-up or hardware reset. Used for pin modes and UART startup.\n- **`loop()`**: Executes repeatedly forever in an unbroken cycle.\n- **Statement**: A single executable instruction that must conclude with a semicolon `;`.\n- **Code Block (`{ }`)**: Curly braces group multiple statements into a single function or conditional block.\n- **Baud Rate**: The transmission speed in bits per second (e.g., 9600 baud = ~960 characters per second).\n- **Serial Monitor**: An interactive terminal console embedded in the Arduino IDE for text communication with the board."
      },
      {
        "stepId": "l04_s04",
        "title": "How It Works: Microcontroller Heartbeat & 16 MHz Clocks",
        "type": "visualExplanation",
        "interactiveWidgetType": "executionSpeedVisualizer",
        "markdownContent": "The ATmega328P microcontroller is powered by a 16 MHz quartz crystal oscillator. That means the processor ticks **16 million times every single second** (each clock tick is just 62.5 nanoseconds!).\n\nHuman eyes have a flicker fusion limit of ~60 Hz (16.6 milliseconds), and human reaction time is ~200 milliseconds (200,000,000 nanoseconds!).\n\nIf you toggle an LED ON and OFF inside `loop()` without `delay()`, the LED flips millions of times per second. To human eyes, it appears as a solid dim light due to Persistence of Vision!\n\nCompare 16 MHz CPU execution speed against human perception in the visual clock simulator below to understand why `delay()` is essential."
      },
      {
        "stepId": "l04_s05",
        "title": "Hardware Mission: Uno Reset Button & TX/RX Telemetry LEDs",
        "type": "physicalTask",
        "markdownContent": "Pick up your Arduino Uno (`comp_uno`) and locate two critical hardware features:\n\n### 1. The Hardware Reset Switch\nLocate the red or yellow pushbutton in the top-left corner near the USB connector. Pressing this switch pulls the ATmega328P `RESET` pin to GND (0V), restarting program execution from the very beginning of `setup()`!\n\n### 2. The TX and RX Telemetry LEDs\nLook closely near Digital Pins 0 and 1. Notice the two tiny surface-mount LEDs labeled **TX** (Transmit) and **RX** (Receive).\n\nWhenever your sketch sends text to the Serial Monitor via `Serial.print()`, the **TX** LED flashes amber. Whenever your computer sends characters into the Arduino, the **RX** LED flashes amber!"
      },
      {
        "stepId": "l04_s06",
        "title": "Coding Basics: Spotting & Fixing Syntax Errors",
        "type": "story",
        "interactiveWidgetType": "syntaxErrorDebugger",
        "markdownContent": "The C++ compiler is extremely strict. A single misplaced character stops your code from building entirely:\n\n### 3 Most Common Rookie Syntax Traps:\n1. **Missing Semicolon**: Forgetting `;` at the end of a statement (`pinMode(13, OUTPUT)`).\n2. **Case Sensitivity Errors**: Writing `digitalwrite` instead of camelCase `digitalWrite` (C++ treats lowercase and uppercase as totally different names!).\n3. **Unmatched Curly Braces**: Forgetting the closing `}` on a function block.\n\nInspect the code editor below, spot all 3 syntax bugs, and apply fixes to achieve a clean build!"
      },
      {
        "stepId": "l04_s07",
        "title": "Code Walkthrough: Serial.print() vs Serial.println()",
        "type": "codeExperiment",
        "interactiveWidgetType": "serialPrintExperiment",
        "markdownContent": "How does the Arduino send information to your computer screen? Through the `Serial` object!\n\n```cpp\nvoid setup() {\n  Serial.begin(9600); // Start serial UART at 9600 bits per second\n}\n\nvoid loop() {\n  Serial.print(\"MONSTER \");   // Prints text on current line\n  Serial.println(\"ONLINE\");   // Prints text and moves to next line (\\r\\n)\n  delay(1000);\n}\n```\n\n### The Critical Difference:\n- `Serial.print()`: Outputs characters without a line break. Repeated prints concatenate side-by-side horizontally.\n- `Serial.println()`: Outputs characters followed by an invisible Carriage Return `\\r` and Line Feed `\\n`. Moves the cursor to line 2.\n\nToggle between `print` and `println` in the interactive telemetry experiment below to see how terminal output is formatted!"
      },
      {
        "stepId": "l04_s08",
        "title": "Code Prediction: Setup Loops vs Missing Serial.begin",
        "type": "codeExperiment",
        "markdownContent": "Make predictions about serial telemetry behavior before testing in hardware:\n\n### Prediction 1: What happens if Serial.println(\"Booting...\") is placed inside loop() instead of setup()?\n*Answer:* Instead of printing once upon startup, it prints repeatedly every single loop cycle, flooding the Serial Monitor console!\n\n### Prediction 2: What happens if Serial.begin(9600) is omitted from setup()?\n*Answer:* The hardware UART baud rate generator registers are never initialized. The ATmega328P will not send bytes over USB, and the Serial Monitor will stay completely blank!"
      },
      {
        "stepId": "l04_s09",
        "title": "Guided Experiment: Accelerating Telemetry Cadence",
        "type": "codeExperiment",
        "markdownContent": "Let's modify loop cadence and observe the telemetry output rate:\n\n```cpp\nvoid loop() {\n  Serial.print(\"Ping at timestamp: \");\n  Serial.println(millis());\n  delay(250); // Changed from 1000 ms to 250 ms\n}\n```\n\n### Observations:\n1. `millis()` is a built-in Arduino timer function returning the number of milliseconds elapsed since the board powered on.\n2. By reducing `delay(1000)` to `delay(250)`, the board sends **4 telemetry readings every second** instead of 1.\n3. Notice the TX LED on the Uno: it flashes 4 times per second in perfect synchrony with the loop!"
      },
      {
        "stepId": "l04_s10",
        "title": "Real-World Robotics: NASA Rovers & Automotive State Machines",
        "type": "visualExplanation",
        "markdownContent": "The `setup()`, `loop()`, and `Serial` logging pattern is standard across aerospace and automotive robotics:\n\n- **NASA Mars Rovers**: Telemetry transmitters stream engineering packet frames over X-band radio back to Earth's Deep Space Network using calibrated bitrates.\n- **Automotive CAN Bus Diagnostics**: Mechanics plug OBD-II diagnostic scanners into cars to read serial diagnostic trouble codes (DTCs) generated by engine loop telemetry.\n- **Industrial Packaging Arms**: Factory automation PLCs cycle 1,000 times per second, streaming serial telemetry to factory supervisory control systems."
      },
      {
        "stepId": "l04_s11",
        "title": "Troubleshooting Challenge: Garbled Serial & Baud Rates",
        "type": "story",
        "interactiveWidgetType": "serialMonitorSimulator",
        "markdownContent": "You open the Serial Monitor and instead of clean English text, you see strange inverted question marks and scrambled symbols:\n\n```\n\u2e2e\u2e2ex~??\u2e2ef\u2e2e\u2e2e\u2592\u2592\n```\n\nThis is the #1 Serial Monitor bug: **Baud Rate Mismatch**!\n\nIf your sketch specifies `Serial.begin(9600);` (9600 bits per second), but the Serial Monitor selector dropdown is set to `115200 baud`, the computer clock samples the electrical wire 12 times faster than the Arduino sends bits! The bit frames get completely scrambled.\n\nSwitch baud rates in the Serial Monitor simulator below to synchronize communication and restore legible text!"
      },
      {
        "stepId": "l04_s12",
        "title": "Workshop Safety & Hardware Care: USB Power & Non-Conductive Surfaces",
        "type": "story",
        "markdownContent": "Observe these essential safety protocols when programming microcontrollers:\n\n1. **Non-Conductive Work Surfaces**: Always rest your Arduino Uno on a wood desk, cardboard, or antistatic mat. Resting an active board on a metal ruler, laptop aluminum shell, or anti-static bag can short bottom header pins!\n2. **USB Port Protection**: Never insert or remove jumper wires into the `5V` and `GND` headers while the USB cable is plugged in. Accidental wire bridges can trip computer USB overcurrent protection shutdown.\n3. **Safe USB Cable Unplugging**: Grip the molded connector body when disconnecting USB cables\u2014never pull on the flexible wire cord."
      },
      {
        "stepId": "l04_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "Fantastic progress! Let's review the fundamental engineering competencies you mastered in Lesson 04:\n\n- You understand the embedded execution model: `setup()` runs once at boot; `loop()` runs continuously forever.\n- You know why 16 MHz microcontrollers require `delay()` to bridge the speed gap to human perception.\n- You can identify and fix semicolons, camelCase functions, and unmatched curly braces.\n- You understand how `Serial.print()` concatenates and `Serial.println()` inserts clean newlines.\n- You know how to resolve garbled serial text by matching baud rates.\n\nComplete the 8-question assessment below to earn your XP and get ready for Lesson 05: Your first physical circuit!"
      },
      {
        "stepId": "l04_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of microcontroller execution cycles, C++ syntax rules, and UART Serial Monitor telemetry.",
        "interactiveConfig": {
          "question": "How many times does code inside `void setup()` execute after startup?",
          "options": [
            "Exactly once",
            "Exactly ten times",
            "Continuously in an infinite loop"
          ],
          "correctIndex": 0,
          "explanation": "Correct: Exactly once. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "How many times does code inside `void setup()` execute after startup?",
              "options": [
                "Exactly once",
                "Exactly ten times",
                "Continuously in an infinite loop"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Exactly once. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the primary role of `void loop()` in an Arduino robot?",
              "options": [
                "To repeatedly execute sensing, decision-making, and actuator control forever",
                "To shut down the Arduino when code finishes",
                "To format the flash memory"
              ],
              "correctIndex": 0,
              "explanation": "Correct: To repeatedly execute sensing, decision-making, and actuator control forever. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What character must terminate every standard C++ statement in Arduino?",
              "options": [
                "Semicolon (`;`)",
                "Colon (`:`)",
                "Period (`.`)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Semicolon (`;`). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What does the Verify (checkmark) button in the IDE do?",
              "options": [
                "Compiles the sketch to check for syntax and type errors without uploading",
                "Physically tests the Arduino hardware circuits",
                "Deletes existing code from the board"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Compiles the sketch to check for syntax and type errors without uploading. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "If your code specifies `Serial.begin(9600)`, what baud rate must the Serial Monitor be set to?",
              "options": [
                "9600 baud",
                "115200 baud",
                "Any baud rate works automatically"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 9600 baud. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the purpose of curly braces `{ }` in code?",
              "options": [
                "They group multiple statements together into a single function or block",
                "They represent mathematical multiplication",
                "They indicate comments ignored by the compiler"
              ],
              "correctIndex": 0,
              "explanation": "Correct: They group multiple statements together into a single function or block. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What function is used to send text to the Serial Monitor followed by a new line?",
              "options": [
                "`Serial.println()`",
                "`Serial.write()`",
                "`Serial.input()`"
              ],
              "correctIndex": 0,
              "explanation": "Correct: `Serial.println()`. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What happens if `delay(1000)` is omitted from a `loop()` that prints text?",
              "options": [
                "The loop runs at maximum CPU speed, flooding the serial buffer and monitor",
                "The Arduino overheats and shuts off",
                "The compiler refuses to upload the code"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The loop runs at maximum CPU speed, flooding the serial buffer and monitor. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 60
  },
  {
    "id": "lesson_05",
    "title": "Blink: Your First Physical Circuit",
    "summary": "Command digital outputs to HIGH and LOW, control on-board LED, and understand persistence of vision.",
    "tier": "rookie",
    "estimatedMinutes": 20,
    "prerequisites": [
      "lesson_04"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l05_s01",
        "title": "Awaken the Beast: Creating Physical Photons",
        "type": "story",
        "markdownContent": "Software becomes robotics when binary logic gates physically manipulate the physical universe. Turning an LED on and off is the foundational 'Hello World' of physical computing, proving that your software commands can source and sink electric current through semiconductor transistors.\n\nIn this mission, you will command electrical charges through silicon gates to create visible light on your Arduino board!\n\n```\nPORTB5 Register \u2794 Internal P-MOSFET Closes \u2794 Pin 13 at 5V \u2794 Current Flows \u2794 SMD LED Glows \u2794 GND Return\n```"
      },
      {
        "stepId": "l05_s02",
        "title": "Prior Knowledge Check: Digital Signals & Ground",
        "type": "story",
        "interactiveWidgetType": "priorKnowledgeCheck",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is an electrical digital signal in Arduino?",
              "options": [
                "A signal that exists in one of two discrete states: HIGH (+5V) or LOW (0V)",
                "A continuous wave that changes smoothly through infinite values",
                "A radio wave transmitted without physical wires"
              ],
              "correctIndex": 0,
              "explanation": "Digital signals exist in two binary states: HIGH (+5V) or LOW (0V Ground)."
            },
            {
              "question": "What is GND (Ground) used for in an electrical circuit?",
              "options": [
                "A 0V common reference and essential return path for electric current",
                "A high-voltage power booster that accelerates motors",
                "A data storage buffer inside microcontroller RAM"
              ],
              "correctIndex": 0,
              "explanation": "Ground (GND) is the 0V reference potential and essential return path required for electric current to complete a loop."
            },
            {
              "question": "What happens if an external circuit lacks a return path to GND?",
              "options": [
                "No electric current can flow, and the circuit remains inactive",
                "The circuit will draw double current",
                "The microcontroller will crash immediately"
              ],
              "correctIndex": 0,
              "explanation": "Electricity only flows through a closed conductive loop that returns to Ground."
            }
          ]
        },
        "markdownContent": "Before commanding hardware outputs, let's verify your baseline understanding of voltage potentials and Ground reference paths.\n\nComplete the 3 questions below to prepare for the lab!"
      },
      {
        "stepId": "l05_s03",
        "title": "5mm LED Anatomy & Polarity Inspection",
        "type": "story",
        "interactiveWidgetType": "ledPolarityInspector",
        "markdownContent": "LED stands for **Light Emitting Diode**. Because it is a diode, electricity can only flow through it in one forward direction!\n\n### Anatomical Clues:\n- **Cathode (\u2212)**: Connects to Ground (GND). Features a larger triangular **anvil** flag inside the clear epoxy bulb, a **shorter lead**, and a **flat edge** along the plastic rim collar.\n- **Anode (+)**: Connects to positive voltage (+5V). Features a smaller **post** contact inside the epoxy and a **longer lead**.\n\nUse the interactive cutaway inspector below to inspect internal electrodes and observe how reversing polarity blocks photon emission!"
      },
      {
        "stepId": "l05_s04",
        "title": "How It Works: Breadboard Spring Clips & Current Paths",
        "type": "visualExplanation",
        "interactiveWidgetType": "breadboardInternalBusInspector",
        "markdownContent": "Solderless breadboards allow engineers to build circuits without permanent solder. Beneath the plastic faceplate lie rows of stamped spring metal clips.\n\n### Breadboard Internal Routing:\n1. **Terminal Strips**: Horizontal groups of 5 tie-points (a-b-c-d-e and f-g-h-i-j) are electrically joined by an internal spring clip.\n2. **Center Ravine**: A central trench divides the left and right strips so dual-inline IC pins do not short together.\n3. **Power Bus Rails**: Vertical continuous columns (+ and \u2212) run the full length of the board to distribute 5V and GND everywhere.\n\nUse the interactive continuity probe below to test breadboard connections and discover where current flows!"
      },
      {
        "stepId": "l05_s05",
        "title": "Hardware Mission: The On-Board Pin 13 'L' Silkscreen Tour",
        "type": "physicalTask",
        "markdownContent": "Examine your Arduino Uno R3 board (`comp_uno`):\n\n### Hardware Inspection:\n1. **Locate the 'L' LED**: Look between the digital pin headers (Pins 8\u201313) and the main microcontroller chip. Find the tiny amber surface-mount diode labeled with a silkscreened `L`.\n2. **Trace the Silkscreen**: Follow the fine copper trace on the PCB linking Digital Pin 13 to the `L` indicator.\n3. **Power Indicator**: Notice the green `ON` LED nearby. The green LED proves the 5V power bus is energized, while the amber `L` LED is directly driven by your sketch firmware!\n4. **On-Board Protection**: The Uno PCB already includes a built-in SMD series resistor for Pin 13, making it 100% safe to flash without external breadboard wiring."
      },
      {
        "stepId": "l05_s06",
        "title": "Coding Basics: pinMode(OUTPUT) & HIGH/LOW Constants",
        "type": "story",
        "markdownContent": "Microcontroller pins are versatile: by default, they boot into high-impedance `INPUT` mode to prevent accidental short circuits.\n\n### Core Commands:\n- `pinMode(pin, OUTPUT);`: Commands internal push-pull MOSFET transistors to actively drive current.\n- `digitalWrite(pin, HIGH);`: Connects the pin to the positive +5.0V supply rail (sources current).\n- `digitalWrite(pin, LOW);`: Connects the pin to the 0V Ground reference (sinks current).\n- `delay(ms);`: Freezes microcontroller execution for the specified milliseconds so human eyes can perceive state changes."
      },
      {
        "stepId": "l05_s07",
        "title": "Code Walkthrough: The Canonical Blink Sketch",
        "type": "codeExperiment",
        "markdownContent": "Here is the foundational Blink sketch executed by millions of roboticists:\n\n```cpp\nconst int ledPin = 13; // Built-in LED pin\n\nvoid setup() {\n  pinMode(ledPin, OUTPUT); // Configure Pin 13 as a low-impedance driver\n}\n\nvoid loop() {\n  digitalWrite(ledPin, HIGH); // Drive Pin 13 to 5V (turn LED ON)\n  delay(1000);                // Maintain state for 1000 ms (1 second)\n  digitalWrite(ledPin, LOW);  // Drive Pin 13 to 0V (turn LED OFF)\n  delay(1000);                // Maintain state for 1000 ms (1 second)\n}\n```\n\n### Key Rules:\n- `const int ledPin = 13;` prevents accidental reassignment.\n- If you forget `delay()` after `LOW`, the LED turns back ON in nanoseconds, making the OFF state invisible to humans!"
      },
      {
        "stepId": "l05_s08",
        "title": "Code Prediction: Silicon Limits & Series Resistors",
        "type": "codeExperiment",
        "interactiveWidgetType": "resistorOhmLawSimulator",
        "markdownContent": "What happens when wiring external LEDs to Arduino pins? Microcontroller silicon has physical electrical limits!\n\n### Ohm's Law in Action:\n$$I = \\frac{V_{supply} - V_{forward}}{R} = \\frac{5.0\\text{V} - 2.0\\text{V}}{R}$$\n\nAn ATmega328P output pin has an absolute maximum continuous rating of **20 mA** (40 mA absolute destruction limit). Wiring an external LED without a current-limiting resistor (< 100\u03a9) causes catastrophic overcurrent, destroying the pin driver FET!\n\nExplore resistor values in the Ohm's Law simulator below to see safe operating currents vs blowout hazards!"
      },
      {
        "stepId": "l05_s09",
        "title": "Guided Experiment: Blink Cadence & Persistence of Vision",
        "type": "codeExperiment",
        "interactiveWidgetType": "blinkTimingLab",
        "markdownContent": "What happens when the blink frequency becomes extremely fast?\n\nHuman eyes have an optical reset latency of approximately 30 milliseconds (**Persistence of Vision**). When an LED toggles faster than 30 Hz (delays under 30ms), retinal cone cells cannot reset before the next photon packet arrives. The individual flashes fuse into a solid, continuous glow at reduced brightness!\n\nAdjust `delay(HIGH)` and `delay(LOW)` in the Timing Lab below to explore asymmetric cadences and trigger POV optical fusion!"
      },
      {
        "stepId": "l05_s10",
        "title": "Real-World Robotics: Satellite Beacons & Heartbeat Signals",
        "type": "visualExplanation",
        "markdownContent": "Flashing LEDs are vital engineering diagnostic tools across aerospace and medical systems:\n\n- **CubeSats & Drones**: Navigation strobes flash asymmetric patterns (100ms ON / 900ms OFF) to minimize battery drain while maintaining high-visibility beacon tracking.\n- **Medical Ventilators & Pacemakers**: Microcontroller firmware toggles a dedicated hardware 'heartbeat' LED on every main loop iteration. If the CPU hangs in a deadlock, the heartbeat LED freezes, alerting attending doctors.\n- **Autonomous Factory AGVs**: Colored flashing strobes convey vehicle status: amber for transit, blue for barcode scanning, red for safety obstruction stop."
      },
      {
        "stepId": "l05_s11",
        "title": "Troubleshooting Challenge: Inverted Delays & Floating Gates",
        "type": "story",
        "markdownContent": "Master common beginner hardware bugs:\n\n### Symptom 1: LED Stays Solid ON and Never Blinks\n- **Cause**: Missing second `delay()`, or both `digitalWrite` calls are set to `HIGH`.\n- **Fix**: Ensure `digitalWrite(ledPin, LOW)` is followed by a `delay()` of at least 100ms.\n\n### Symptom 2: LED Glows Extremely Dimly\n- **Cause**: Forgot `pinMode(ledPin, OUTPUT);` in `setup()`! In `INPUT` mode, `digitalWrite(HIGH)` merely enables the weak internal 30k\u03a9 pull-up resistor (~0.1 mA current).\n- **Fix**: Add `pinMode(ledPin, OUTPUT);` inside `setup()`."
      },
      {
        "stepId": "l05_s12",
        "title": "Workshop Safety & Limits: Pin Current Limits (20mA Continuous)",
        "type": "story",
        "markdownContent": "Always treat microcontroller silicon with care:\n\n1. **Never Exceed 20 mA**: The ATmega328P can supply up to 20 mA per pin. Total current across all pins combined must not exceed 200 mA.\n2. **Always Use 220\u03a9\u20131k\u03a9 Series Resistors**: When wiring external LEDs on a breadboard, always place a 220\u03a9 or 330\u03a9 resistor in series with the anode or cathode.\n3. **Power Down Before Rewiring**: Disconnect the USB cable before plugging wires into the breadboard to prevent accidental short circuits across 5V and GND."
      },
      {
        "stepId": "l05_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "Outstanding work! In Lesson 05, you created your first physical light output:\n\n- You defined digital output states: 5V (`HIGH`) and 0V (`LOW`).\n- You learned why `pinMode(OUTPUT)` is mandatory to engage push-pull transistor drivers.\n- You inspected 5mm LED polarity (anvil Cathode \u2212 vs post Anode +) and breadboard bus clips.\n- You calculated current via Ohm's Law and respected the 20 mA continuous pin limit.\n- You explored blinking cadences and retinal persistence of vision (POV) fusion.\n\nTake the 8-question assessment below to claim your XP and advance to Lesson 06: Reading analog signals!"
      },
      {
        "stepId": "l05_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of digital output voltage states, LED polarity, Ohm's law, and persistence of vision.",
        "interactiveConfig": {
          "question": "What voltage level does `digitalWrite(pin, HIGH)` produce on an Arduino Uno?",
          "options": [
            "5.0 Volts",
            "0.0 Volts",
            "12.0 Volts"
          ],
          "correctIndex": 0,
          "explanation": "Correct: 5.0 Volts. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What voltage level does `digitalWrite(pin, HIGH)` produce on an Arduino Uno?",
              "options": [
                "5.0 Volts",
                "0.0 Volts",
                "12.0 Volts"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 5.0 Volts. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "How many milliseconds are in 1.5 seconds?",
              "options": [
                "1500 ms",
                "150 ms",
                "15 ms"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 1500 ms. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why must you call `pinMode(pin, OUTPUT)` before writing to a pin?",
              "options": [
                "To switch internal pin transistors from high-impedance listening to active voltage driving",
                "To supply 12V to the USB port",
                "To download the sketch to EEPROM"
              ],
              "correctIndex": 0,
              "explanation": "Correct: To switch internal pin transistors from high-impedance listening to active voltage driving. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which digital pin on the Arduino Uno is wired directly to the on-board amber 'L' LED?",
              "options": [
                "Pin 13",
                "Pin 0",
                "Pin A0"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Pin 13. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What visual phenomenon causes an LED flashing at 100 Hz to appear continuously solid?",
              "options": [
                "Persistence of vision",
                "Capacitive filtering",
                "Inductive kickback"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Persistence of vision. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What happens if you omit the `delay()` between turning the LED OFF and turning it back ON in `loop()`?",
              "options": [
                "The LED turns back on so quickly the off-state is imperceptible",
                "The microcontroller halts",
                "The LED burns out"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The LED turns back on so quickly the off-state is imperceptible. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the maximum safe continuous current that should be drawn from an Uno I/O pin?",
              "options": [
                "Approximately 20 mA",
                "5 Amps",
                "500 mA"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Approximately 20 mA. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What does `digitalWrite(pin, LOW)` connect the output pin to internally?",
              "options": [
                "Ground (0V reference)",
                "5V power supply",
                "Analog-to-digital converter"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Ground (0V reference). Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 75
  },
  {
    "id": "lesson_06",
    "title": "Potentiometer: Reading Analog Signals",
    "summary": "Measure continuous rotary voltages with 10-bit analogRead() and map sensor readings.",
    "tier": "rookie",
    "estimatedMinutes": 20,
    "prerequisites": [
      "lesson_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l06_s01",
        "title": "Sense the Spectrum: Analog Perception",
        "type": "story",
        "markdownContent": "The physical universe is not merely binary ON or OFF. Temperatures rise and fall smoothly, robot battery charges drain gradually, and steering angles vary continuously. A potentiometer gives your monster robot continuous analog perception, allowing it to sense fine gradients like steering angles, joint positions, and motor throttle.\n\nIn this mission, you will wire a 10k\u03a9 rotary potentiometer to Analog Pin A0 and convert raw 10-bit integers into true voltage measurements!\n\n```\n5V Power \u2794 Carbon Track \u2794 Wiper Picks Off Voltage \u2794 ATmega328P 10-bit ADC \u2794 Integer (0 to 1023)\n```"
      },
      {
        "stepId": "l06_s02",
        "title": "Prior Knowledge Check: Digital vs Analog Perception",
        "type": "story",
        "interactiveWidgetType": "priorKnowledgeCheck",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What values does digitalRead() return on an Arduino Uno?",
              "options": [
                "Only binary HIGH (1) or LOW (0)",
                "Continuous decimal voltages from 0.0V to 5.0V",
                "Frequencies between 20 Hz and 20 kHz"
              ],
              "correctIndex": 0,
              "explanation": "Digital inputs only measure two binary states: HIGH or LOW."
            },
            {
              "question": "What voltage does the Arduino Uno provide on its regulated 5V power rail?",
              "options": [
                "A regulated 5.0 Volts DC",
                "120 Volts AC",
                "3.3 Volts AC"
              ],
              "correctIndex": 0,
              "explanation": "The Uno onboard voltage regulator supplies a steady 5.0V DC."
            },
            {
              "question": "Why is an analog input required for robotic steering wheels or dials?",
              "options": [
                "Because rotary angles vary continuously over a smooth spectrum of values",
                "Because analog pins use less battery power than digital pins",
                "Because digital pins cannot connect to breadboards"
              ],
              "correctIndex": 0,
              "explanation": "Physical phenomena like angles, pressures, and temperatures are continuous and require analog-to-digital conversion."
            }
          ]
        },
        "markdownContent": "Before wiring variable resistors, let's verify your baseline understanding of discrete digital logic versus continuous analog voltages.\n\nAnswer the 3 self-check questions below to calibrate your knowledge!"
      },
      {
        "stepId": "l06_s03",
        "title": "Core Concept & Vocabulary: Potentiometers & Voltage Dividers",
        "type": "story",
        "interactiveWidgetType": "voltageDividerCutaway",
        "markdownContent": "A **potentiometer** is a 3-terminal variable resistor with a rotating shaft connected to an internal wiper contact.\n\n### The Voltage Division Principle:\nInside `comp_20`, a horseshoe-shaped carbon track connects Terminal 1 (5V) and Terminal 3 (GND). As the shaft rotates, Center Terminal 2 (Wiper) sweeps across the resistive material, splitting total resistance into two parts ($R_1$ and $R_2$):\n\n$$V_{out} = V_{in} \\times \\frac{R_2}{R_1 + R_2} = 5.0\\text{V} \\times \\text{ratio}$$\n\nRotate the virtual knob in the cutaway visualizer below to see how the wiper divides voltage between 0.00V and 5.00V!"
      },
      {
        "stepId": "l06_s04",
        "title": "How It Works: 10-Bit ADC Successive Approximation Quantization",
        "type": "visualExplanation",
        "interactiveWidgetType": "adcSamplingVisualizer",
        "markdownContent": "Because digital processors only compute in binary bits, the ATmega328P contains an on-chip **Analog-to-Digital Converter (ADC)**.\n\n### 10-Bit Quantization Details:\n- **Resolution**: $2^{10} = 1024$ discrete steps (from 0 to 1023).\n- **Step Voltage Size**: $\\frac{5000\\text{ mV}}{1023} \\approx 4.8876\\text{ mV}$ per ADC count.\n- **Formula**: $\\text{ADC Count} = \\text{round}\\left(V_{in} \\times \\frac{1023}{5.0\\text{V}}\\right)$\n- **Reconstructed Voltage**: $V = \\text{count} \\times \\frac{5.0\\text{V}}{1023}$\n\nUse the interactive visualizer below to explore how continuous analog voltages are sliced into 10-bit integer staircase steps!"
      },
      {
        "stepId": "l06_s05",
        "title": "Hardware Mission: Breadboard Potentiometer 3-Pin Wiring",
        "type": "physicalTask",
        "interactiveWidgetType": "wiperPinoutChecker",
        "markdownContent": "Examine your 10k\u03a9 Rotary Potentiometer (`comp_20`) and solderless breadboard (`comp_breadboard`):\n\n### 3-Pin Terminal Assignment:\n- **Pin 1 (Outer Leg)**: Connects to Uno +5V rail.\n- **Pin 2 (Center Wiper)**: Connects to Uno Analog In Pin `A0`.\n- **Pin 3 (Outer Leg)**: Connects to Uno Ground (GND) rail.\n\n\u26a0\ufe0f **The Dead Short Trap**: Never connect the center wiper directly to 5V or GND! If the wiper touches GND while an outer leg is on 5V, turning the knob to the end of travel creates a 0-ohm dead short, tripping your computer's USB overcurrent protection!\n\nInspect and verify wiring configurations in the pinout checker below before powering your physical circuit!"
      },
      {
        "stepId": "l06_s06",
        "title": "Coding Basics: analogRead(A0) & Voltage Conversion Math",
        "type": "story",
        "markdownContent": "Reading analog signals in Arduino firmware is straightforward:\n\n### Key Rules:\n- **No `pinMode()` Required**: Unlike digital pins, Uno analog input pins (`A0`\u2013`A5`) do not require `pinMode()` in `setup()`. The ADC multiplexer hardware automatically configures the pin during conversion.\n- **`analogRead(A0)`**: Samples the pin voltage and returns an integer between `0` (for 0.0V) and `1023` (for 5.0V).\n- **Conversion Math**: `float voltage = rawValue * (5.0 / 1023.0);` translates the count into true physical Volts.\n- **Conversion Time**: An ADC conversion on the Uno takes approximately 100 microseconds (about 10,000 samples per second)."
      },
      {
        "stepId": "l06_s07",
        "title": "Code Walkthrough: Continuous Telemetry Stream",
        "type": "codeExperiment",
        "markdownContent": "Here is the canonical sketch for reading potentiometer telemetry:\n\n```cpp\nconst int potPin = A0; // Center wiper connected to A0\n\nvoid setup() {\n  Serial.begin(9600); // Initialize telemetry communication\n}\n\nvoid loop() {\n  int rawValue = analogRead(potPin);         // Read ADC count (0 to 1023)\n  float voltage = rawValue * (5.0 / 1023.0); // Convert to true voltage\n\n  Serial.print(\"ADC Count: \");\n  Serial.print(rawValue);\n  Serial.print(\" | Voltage: \");\n  Serial.print(voltage, 2);\n  Serial.println(\" V\");\n\n  delay(200); // 5 Hz telemetry cadence for human readability\n}\n```\n\nOpen the Serial Monitor at 9600 baud. As you rotate the potentiometer shaft clockwise and counterclockwise, watch the values glide smoothly between `0` and `1023`!"
      },
      {
        "stepId": "l06_s08",
        "title": "Code Prediction: ADC Midpoints & Reference Voltages",
        "type": "codeExperiment",
        "markdownContent": "Make predictions about analog conversion values before testing:\n\n### Prediction 1: Exactly what integer count will analogRead(A0) return when the potentiometer is centered at 2.50 Volts?\n*Answer:* $1023 \\times \\frac{2.5}{5.0} = 511.5 \\approx 511$ or $512$.\n\n### Prediction 2: What happens if you connect the potentiometer's outer legs to 3.3V and GND instead of 5V?\n*Answer:* When turned fully clockwise to 3.3V, `analogRead()` reads $1023 \\times \\frac{3.3}{5.0} \\approx 675$. The top third of the integer scale (676\u20131023) will never be reached!"
      },
      {
        "stepId": "l06_s09",
        "title": "Guided Experiment: Sensor Scaling & Moving Average Filter",
        "type": "codeExperiment",
        "interactiveWidgetType": "analogReadNoiseFilter",
        "markdownContent": "Real-world robotics sensors pick up electrical noise from nearby motors and power supplies. What happens when an analog pin is left completely disconnected (**floating input**)?\n\nBecause the ATmega328P ADC has an input impedance exceeding 100 M\u03a9, an unconnected pin acts like an antenna, picking up 60Hz ambient EMI!\n\nIn robotics firmware, engineers implement **Exponential Moving Average (EMA)** software filters:\n```cpp\nsmoothedVal = (0.2 * rawVal) + (0.8 * smoothedVal);\n```\n\nTest floating inputs, ground references, and digital filtering in the interactive laboratory below!"
      },
      {
        "stepId": "l06_s10",
        "title": "Real-World Robotics: Joint Angles & Throttle Pedals",
        "type": "visualExplanation",
        "markdownContent": "Potentiometers and voltage dividers are fundamental components across industrial machines:\n\n- **Robotic Arm Servo Joints**: Precision rotary potentiometers inside robot joints provide closed-loop angular feedback so the controller knows the arm's exact 3D orientation.\n- **Electric Vehicle Throttle Pedals**: Dual-redundant rotary potentiometers measure accelerator pedal angle. Redundant tracks ensure that if one wiper wears out, the car safely idles rather than accelerating runaway!\n- **Radio Volume & Audio Consoles**: Audio mixing consoles use motorized linear slide potentiometers (faders) to adjust channel gain."
      },
      {
        "stepId": "l06_s11",
        "title": "Troubleshooting Challenge: Floating Inputs & Dead Short Traps",
        "type": "story",
        "markdownContent": "Diagnose the top 2 analog input failures:\n\n### Symptom 1: Reading Jumps Wildly Even When Not Touching the Knob\n- **Diagnosis**: Floating input! The center wiper wire is plugged into the wrong breadboard row, or a jumper wire is loose.\n- **Fix**: Confirm that the yellow wiper jumper wire is in the exact same breadboard tie-point column as Pin 2.\n\n### Symptom 2: Reading Stays Locked at 0 or 1023 and Never Changes\n- **Diagnosis**: Both outer pins are plugged into the same power rail (e.g., both into GND or both into 5V), or the wiper pin is bent underneath the pot.\n- **Fix**: Inspect the pot underside to ensure all 3 pins entered distinct breadboard rows."
      },
      {
        "stepId": "l06_s12",
        "title": "Workshop Safety & Breadboard Placement Rules",
        "type": "story",
        "markdownContent": "Observe these critical breadboard installation guidelines:\n\n1. **Never Insert All 3 Pins Into the Same Breadboard Row**: A breadboard row connects all 5 holes together! Inserting all 3 potentiometer pins into row 10 creates a dead short across 5V and GND!\n2. **Gentle Lead Pressure**: Potentiometer pins can bend if forced into tight breadboard holes. Align all 3 pins vertically before applying gentle downward pressure.\n3. **Quiescent Current Awareness**: A 10k\u03a9 potentiometer connected between 5V and GND draws only $I = \\frac{5\\text{V}}{10\\text{k}\\Omega} = 0.5\\text{ mA}$ of continuous power."
      },
      {
        "stepId": "l06_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "Fantastic progress! In Lesson 06, you gave your monster robot continuous analog senses:\n\n- You distinguished discrete binary states from continuous analog voltages.\n- You understood voltage division math: $V_{out} = V_{in} \\times \\frac{R_2}{R_1 + R_2}$.\n- You mastered 10-bit ADC quantization ($2^{10} = 1024$ levels, ~4.89 mV per step).\n- You wired a 3-pin potentiometer safely, avoiding destructive dead short traps.\n- You filtered high-impedance floating noise using moving average algorithms.\n\nComplete the 8-question assessment below to earn your XP and proceed to Lesson 07: Mixing colors with RGB LEDs and PWM!"
      },
      {
        "stepId": "l06_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of potentiometer voltage division, 10-bit ADC sampling, and analog telemetry.",
        "interactiveConfig": {
          "question": "What range of integer values is returned by `analogRead()` on an Arduino Uno?",
          "options": [
            "0 to 1023",
            "0 to 255",
            "-512 to +512"
          ],
          "correctIndex": 0,
          "explanation": "Correct: 0 to 1023. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What range of integer values is returned by `analogRead()` on an Arduino Uno?",
              "options": [
                "0 to 1023",
                "0 to 255",
                "-512 to +512"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 0 to 1023. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the resolution of the built-in ADC on an Arduino Uno?",
              "options": [
                "10-bit (1024 discrete levels)",
                "8-bit (256 discrete levels)",
                "16-bit (65536 discrete levels)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 10-bit (1024 discrete levels). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "If `analogRead(A0)` returns 1023, what voltage is present on pin A0?",
              "options": [
                "5.0 Volts",
                "2.5 Volts",
                "10.23 Volts"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 5.0 Volts. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which terminal of a standard 3-pin potentiometer connects to the variable wiper?",
              "options": [
                "The middle terminal",
                "The leftmost terminal",
                "The mounting metal tab"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The middle terminal. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What electrical circuit principle does a potentiometer utilize to produce variable voltage?",
              "options": [
                "Voltage divider",
                "Inductive coupling",
                "Rectification"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Voltage divider. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Approximately how many millivolts does each single ADC step represent on a 5V Uno?",
              "options": [
                "~4.88 mV (5.0V / 1024)",
                "~100 mV",
                "~0.01 mV"
              ],
              "correctIndex": 0,
              "explanation": "Correct: ~4.88 mV (5.0V / 1024). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why is `pinMode(A0, INPUT)` not strictly mandatory before calling `analogRead(A0)`?",
              "options": [
                "`analogRead()` automatically switches the pin multiplexer to ADC input mode",
                "Analog pins cannot be configured as digital pins",
                "The Arduino detects hardware connections automatically"
              ],
              "correctIndex": 0,
              "explanation": "Correct: `analogRead()` automatically switches the pin multiplexer to ADC input mode. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What causes an analog input reading to jump erratically when nothing is touched?",
              "options": [
                "A floating input wire acting as an antenna picking up electromagnetic interference",
                "A dead microcontroller battery",
                "Excessively high baud rate"
              ],
              "correctIndex": 0,
              "explanation": "Correct: A floating input wire acting as an antenna picking up electromagnetic interference. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 80
  },
  {
    "id": "lesson_07",
    "title": "RGB LED: Mixing Colors with PWM",
    "summary": "Synthesize millions of colors using Pulse Width Modulation and additive optical color physics.",
    "tier": "rookie",
    "estimatedMinutes": 20,
    "prerequisites": [
      "lesson_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard"
    ],
    "steps": [
      {
        "stepId": "l07_s01",
        "title": "Expressive Monsters: Crafting Living Light",
        "type": "story",
        "markdownContent": "Robots need emotion and visual expression! By combining three primary wavelengths of light\u2014Red, Green, and Blue\u2014at varying intensities, we can create any color in the visible rainbow, from energetic yellow to menacing purple or calm cyan.\n\nBecause the Arduino Uno does not have true analog output voltage DACs on its digital headers, we use high-speed silicon pulsing\u2014**Pulse Width Modulation (PWM)**\u2014to fool the human eye into perceiving smooth brightness gradients!\n\n```\nTimer Register OCR1A \u2794 High-Speed 490Hz Pulse Train \u2794 Duty Cycle Average \u2794 Eye Cone Cells \u2794 Perceived Color\n```"
      },
      {
        "stepId": "l07_s02",
        "title": "Prior Knowledge Check: Diodes & Voltage Outputs",
        "type": "story",
        "interactiveWidgetType": "priorKnowledgeCheck",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How does a Light Emitting Diode (LED) generate illumination?",
              "options": [
                "Forward electric current excites electrons across a semiconductor bandgap, releasing photons",
                "A tungsten filament burns inside an inert vacuum bulb",
                "Chemical reactions combust liquid electrolytes"
              ],
              "correctIndex": 0,
              "explanation": "LEDs produce electroluminescence when electrons cross a forward-biased semiconductor junction."
            },
            {
              "question": "Why must every color channel of an RGB LED have its own series resistor?",
              "options": [
                "Because each color die has a different forward voltage drop and requires dedicated current limiting",
                "To increase the speed of light emission",
                "To ground the USB connector"
              ],
              "correctIndex": 0,
              "explanation": "Red (~2.0V), Green (~3.2V), and Blue (~3.2V) have different forward voltages and each need independent current limiters."
            },
            {
              "question": "Can the Arduino Uno output true variable DC voltages (like 2.5V) on standard digital pins?",
              "options": [
                "No, Uno digital pins only switch between 0V and 5V; they use high-speed PWM pulsing to simulate intermediate levels",
                "Yes, every pin has an on-chip digital-to-analog converter (DAC)",
                "Yes, but only when running on battery power"
              ],
              "correctIndex": 0,
              "explanation": "The Uno lacks analog DAC outputs on digital headers; it uses Pulse Width Modulation (PWM) to simulate intermediate voltages."
            }
          ]
        },
        "markdownContent": "Before mixing optical light beams and configuring PWM timer registers, let's test your baseline understanding of semiconductor diodes and voltage driving.\n\nAnswer the 3 self-check questions below to calibrate your knowledge!"
      },
      {
        "stepId": "l07_s03",
        "title": "Core Concept & Vocabulary: Common Cathode vs Common Anode",
        "type": "story",
        "interactiveWidgetType": "commonCathodeVsAnodeDiagram",
        "markdownContent": "An RGB LED packages three independent semiconductor dies (Red, Green, Blue) into a single 5mm plastic lens with 4 leads sharing a single common pin.\n\n### The Two Packaging Standards:\n- **Common Cathode (CC)**: The shared longest lead is connected to **Ground (0V)**. Logic is **Active-HIGH** (`analogWrite(pin, 255)` produces 100% brightness).\n- **Common Anode (CA)**: The shared longest lead is connected to **+5V (VCC)**. Logic is **Active-LOW** (sinks current; `analogWrite(pin, 0)` produces 100% brightness, requiring `255 - value` in code).\n\nToggle between Common Cathode and Common Anode in the schematic below to explore current paths and software logic inversion!"
      },
      {
        "stepId": "l07_s04",
        "title": "How It Works: High-Speed 490Hz PWM Pulse Trains",
        "type": "visualExplanation",
        "interactiveWidgetType": "pwmDutyCycleVisualizer",
        "markdownContent": "Human retina cone cells cannot resolve individual light flashes cycling faster than ~60 Hz due to persistence of vision.\n\n### Pulse Width Modulation (PWM) Physics:\n1. ATmega328P hardware timers oscillate output pins at ~490 Hz (or 980 Hz), giving a cycle period of $T \\approx 2.04\\text{ ms}$.\n2. When you execute `analogWrite(pin, 127)`, the timer holds the pin at 5V for 50% of the period, and 0V for the other 50% (**50% Duty Cycle**).\n3. The human eye integrates this high-speed photon flux, perceiving a steady 50% brightness!\n4. Effective average voltage: $V_{average} = 5.0\\text{V} \\times \\frac{\\text{value}}{255}$.\n\nUse the interactive oscilloscope below to inspect pulse waveforms, high-time vs low-time durations, and perceived LED photon flux!"
      },
      {
        "stepId": "l07_s05",
        "title": "Hardware Mission: 4-Pin RGB LED Leadout & Breadboard Wiring",
        "type": "physicalTask",
        "markdownContent": "Examine your 4-pin 5mm Common Cathode RGB LED and breadboard (`comp_breadboard`):\n\n### Lead Identification Tour:\nHold the LED with the flat edge on the plastic rim collar facing right:\n1. **Lead 1 (Outer Left)**: Red Anode (Forward drop $V_f \\approx 2.0\\text{V}$)\n2. **Lead 2 (Longest Pin)**: Common Cathode (Connects directly to Uno **GND**)\n3. **Lead 3**: Green Anode (Forward drop $V_f \\approx 3.2\\text{V}$)\n4. **Lead 4 (Outer Right)**: Blue Anode (Forward drop $V_f \\approx 3.2\\text{V}$)\n\n### Resistor Wiring:\nNever share a single resistor on the common pin! Connect a separate 220\u03a9 or 330\u03a9 resistor to Lead 1 (Red), Lead 3 (Green), and Lead 4 (Blue). Because red, green, and blue dies have different forward voltage drops, sharing one resistor causes brightness dipping whenever multiple colors illuminate."
      },
      {
        "stepId": "l07_s06",
        "title": "Coding Basics: Identifying Hardware PWM Pins & Timers",
        "type": "story",
        "interactiveWidgetType": "pwmPinIdentifier",
        "markdownContent": "Can you call `analogWrite()` on any Uno pin? **No!** Only pins wired to internal hardware timer compare registers support PWM.\n\n### Finding the PWM Tilde (~):\nLook at the silkscreen on your Arduino Uno next to digital header pins: only pins marked with a tilde `~` (Pins 3, 5, 6, 9, 10, 11) support PWM:\n- **Pins 5 & 6**: Controlled by **Timer0** at **980 Hz** (shared with `millis()` and `delay()`).\n- **Pins 9 & 10**: Controlled by **Timer1** (16-bit) at **490 Hz**.\n- **Pins 3 & 11**: Controlled by **Timer2** (8-bit) at **490 Hz**.\n\n\u26a0\ufe0f **The Non-PWM Trap**: If you call `analogWrite(8, 128)` on non-PWM Pin 8, it only performs binary threshold switching (>=128 is HIGH, <128 is LOW)!\n\nTest and identify all Uno PWM pins in the interactive checker below!"
      },
      {
        "stepId": "l07_s07",
        "title": "Code Walkthrough: 8-Bit analogWrite() & Helper Functions",
        "type": "codeExperiment",
        "markdownContent": "Here is how to control an RGB LED with clean modular firmware:\n\n```cpp\nconst int redPin = 9;   // PWM Pin ~9\nconst int greenPin = 10;// PWM Pin ~10\nconst int bluePin = 11; // PWM Pin ~11\n\nvoid setup() {\n  pinMode(redPin, OUTPUT);\n  pinMode(greenPin, OUTPUT);\n  pinMode(bluePin, OUTPUT);\n}\n\nvoid setColor(int red, int green, int blue) {\n  analogWrite(redPin, constrain(red, 0, 255));\n  analogWrite(greenPin, constrain(green, 0, 255));\n  analogWrite(bluePin, constrain(blue, 0, 255));\n}\n\nvoid loop() {\n  setColor(255, 0, 0);   // Pure Red\n  delay(1000);\n  setColor(0, 255, 0);   // Pure Green\n  delay(1000);\n  setColor(0, 0, 255);   // Pure Blue\n  delay(1000);\n  setColor(255, 255, 0); // Yellow (Red + Green)\n  delay(1000);\n}\n```\n\nBy wrapping `analogWrite()` inside a custom `setColor()` function, your sketch becomes clean and readable!"
      },
      {
        "stepId": "l07_s08",
        "title": "Code Prediction: Inverted Logic & Duty Cycle Math",
        "type": "codeExperiment",
        "markdownContent": "Predict color mixing results before testing on the breadboard:\n\n### Prediction 1: What color does setColor(255, 0, 255) synthesize?\n*Answer:* Full Red combined with full Blue produces vivid **Magenta / Purple**!\n\n### Prediction 2: What happens if you accidentally plug a Common Anode RGB LED into this sketch?\n*Answer:* Because Common Anode uses active-LOW logic, calling `setColor(255, 0, 0)` will produce Cyan instead of Red (Red turns OFF while Green and Blue turn fully ON)!"
      },
      {
        "stepId": "l07_s09",
        "title": "Guided Experiment: Additive Optical Color Mixing Lab",
        "type": "codeExperiment",
        "interactiveWidgetType": "rgbColorSynthesizer",
        "markdownContent": "Time to blend optical wavelengths! In additive color physics:\n\n- **Red + Green = Yellow**\n- **Green + Blue = Cyan**\n- **Red + Blue = Magenta**\n- **Red + Green + Blue = White**\n\nUse the 3-channel optical synthesizer below to mix Red, Green, and Blue light beams into a central frosted lens, inspect the resulting hex color codes, and generate exact Arduino firmware commands!"
      },
      {
        "stepId": "l07_s10",
        "title": "Real-World Robotics: Quadcopter Navigation Beacons & RGB Mood Lighting",
        "type": "visualExplanation",
        "markdownContent": "RGB optical mixing and PWM are used extensively in modern robotics:\n\n- **Quadcopter Flight Navigation**: Drones mount high-intensity RGB LEDs under motor arms: solid green for GPS lock, flashing yellow for return-to-home, and pulsing red for low battery.\n- **Autonomous Delivery Rovers**: Ground rovers project animated light halos on pavements to signal pedestrians whether they are yielding or turning.\n- **Smart Speaker Rings**: Ambient home assistants use 16-channel RGB PWM shift registers to create fluid rotation and pulsing voice feedback animations."
      },
      {
        "stepId": "l07_s11",
        "title": "Troubleshooting Challenge: Reversed Common Anode & Non-PWM Pin Traps",
        "type": "story",
        "markdownContent": "Solve the two most common RGB LED hardware bugs:\n\n### Trap 1: Colors Are Inverted (e.g. Red command shows Cyan)\n- **Diagnosis**: You have a Common Anode LED instead of Common Cathode! The shared pin is wired to GND or expecting active-HIGH driving.\n- **Fix**: Wire the common pin to +5V, and invert firmware values: `analogWrite(pin, 255 - value);`.\n\n### Trap 2: One Color Only Snaps ON or OFF Without Dimming\n- **Diagnosis**: That color channel is connected to a non-PWM pin (such as Pin 7, 8, 12, or 13)!\n- **Fix**: Move the jumper wire to a PWM pin marked with a tilde `~` (3, 5, 6, 9, 10, or 11)."
      },
      {
        "stepId": "l07_s12",
        "title": "Workshop Safety & Independent Resistor Protection",
        "type": "story",
        "markdownContent": "Keep your components protected with these electrical rules:\n\n1. **Never Omit Current Limiting Resistors**: Each of the 3 internal LED dies requires its own 220\u03a9\u2013330\u03a9 resistor to prevent thermal runaway.\n2. **Separate Resistors Prevent Brightness Droop**: Because Red has a 2.0V forward voltage while Green/Blue have ~3.2V, putting a single shared resistor on the cathode will cause Red to steal all the current, extinguishing the other colors!\n3. **Respect Total Package Heat**: Running all three channels at 100% brightness (White) draws ~45 mA total, well within Uno limits when equipped with proper resistors."
      },
      {
        "stepId": "l07_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "Magnificent job! In Lesson 07, you unlocked full optical color synthesis:\n\n- You mastered additive optical color mixing (combining Red, Green, and Blue light).\n- You distinguished Common Cathode (Active-HIGH, shared GND) from Common Anode (Active-LOW, shared 5V).\n- You understood high-speed 490Hz/980Hz PWM duty cycles and average voltage simulation.\n- You located Uno hardware PWM pins marked with `~` (3, 5, 6, 9, 10, 11) and their timers.\n- You wrote modular helper functions (`setColor()`) with 8-bit `analogWrite()` (0\u2013255).\n\nComplete the 8-question assessment below to earn your XP and wrap up Tier 1 physical outputs!"
      },
      {
        "stepId": "l07_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of RGB color synthesis, PWM duty cycles, Common Cathode pinouts, and hardware timers.",
        "interactiveConfig": {
          "question": "What does PWM stand for?",
          "options": [
            "Pulse Width Modulation",
            "Power Wave Measurement",
            "Phase Wire Multiplication"
          ],
          "correctIndex": 0,
          "explanation": "Correct: Pulse Width Modulation. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What does PWM stand for?",
              "options": [
                "Pulse Width Modulation",
                "Power Wave Measurement",
                "Phase Wire Multiplication"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Pulse Width Modulation. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the valid argument range for `analogWrite()` on an Arduino Uno?",
              "options": [
                "0 to 255 (8-bit)",
                "0 to 1023 (10-bit)",
                "0 to 100 (%)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 0 to 255 (8-bit). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which digital pins on the Arduino Uno support hardware PWM?",
              "options": [
                "Pins marked with a tilde (~): 3, 5, 6, 9, 10, 11",
                "All digital pins 0 through 13",
                "Only analog pins A0 through A5"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Pins marked with a tilde (~): 3, 5, 6, 9, 10, 11. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What primary colors of light combine to produce Yellow?",
              "options": [
                "Red and Green",
                "Blue and Yellow",
                "Red and Blue"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Red and Green. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What duty cycle percentage does an `analogWrite()` value of 127 produce?",
              "options": [
                "Approximately 50%",
                "10%",
                "100%"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Approximately 50%. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "On a 4-pin common cathode RGB LED, what does the longest lead connect to?",
              "options": [
                "Ground (GND)",
                "5V Power",
                "Digital Pin 13"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Ground (GND). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why does an LED appear dimmer when fed a 25% duty cycle PWM signal?",
              "options": [
                "The LED is off for 75% of the time, and the human eye averages the photon emission",
                "The voltage is reduced from 5V to 1.25V DC",
                "The resistor value increases dynamically"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The LED is off for 75% of the time, and the human eye averages the photon emission. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What primary colors combine to produce Cyan?",
              "options": [
                "Green and Blue",
                "Red and Blue",
                "Red and Green"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Green and Blue. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 90
  },
  {
    "id": "lesson_08",
    "title": "Digital Inputs: Pushbuttons & Internal Pullups",
    "summary": "Sense mechanical switch presses reliably using ATmega328P internal pull-up resistors and active-low logic.",
    "tier": "rookie",
    "estimatedMinutes": 18,
    "prerequisites": [
      "lesson_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard"
    ],
    "steps": [
      {
        "stepId": "l08_s01",
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Collision Senses: Tactile Bump Detection\nRobots need physical bump sensors to detect wall collisions, mechanical limit switches to prevent robotic arm gear jamming, and emergency stop triggers to prevent accidents. A simple mechanical pushbutton turns physical pressure into electrical continuity.\n\nHowever, microcontrollers do not sense buttons the way humans do. If you wire a button improperly, the pin will act as a radio antenna, triggering phantom ghost presses! In this lesson, you will master the internal pull-up resistor trick used by professional embedded engineers.\n\n```\nButton Open \u2192 30k\u03a9 Internal Pull-Up to 5V \u2192 digitalRead() reads HIGH\nButton Pressed \u2192 Contacts Close to GND \u2192 Current Drains to 0V \u2192 digitalRead() reads LOW\n```"
      },
      {
        "stepId": "l08_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What voltage defines a digital `LOW` state?** 0.0 Volts (connected to Ground).\n2. **What happens to an electrical circuit when the path to ground is broken?** Current stops flowing; it becomes an open circuit."
      },
      {
        "stepId": "l08_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "interactiveWidgetType": "floatingPinSimulator",
        "markdownContent": "- **`digitalRead()`:** Function that measures an input pin, returning `HIGH` (if voltage $\\ge 3.0\\text{V}$) or `LOW` (if voltage $\\le 1.5\\text{V}$).\n- **Floating Pin:** An unconnected high-impedance input pin that acts as an antenna, picking up stray electromagnetic fields and oscillating erratically.\n- **Pull-Up Resistor:** A resistor connecting an input pin to 5V, guaranteeing a stable, deterministic `HIGH` state when a switch is open.\n- **`INPUT_PULLUP`:** Built-in mode configuring the ATmega328P's internal 20k\u03a9\u201350k\u03a9 pull-up resistor, eliminating the need for an external breadboard resistor.\n- **Active-Low Logic:** Circuit architecture where 0V (`LOW`) signals the active/pressed state, and 5V (`HIGH`) signals idle.\n- **Switch Bounce:** Microsecond mechanical vibrations when switch metal contacts collide, creating multiple rapid false triggers.\n\n### Interactive Mission: Test High-Impedance Floating Pins\nExplore the interactive simulator below to observe how an unconnected input pin oscillates erratically from environmental electromagnetic noise. Switch between Floating, Pull-Up, and Pull-Down to observe how pull resistors stabilize logic levels!"
      },
      {
        "stepId": "l08_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "interactiveWidgetType": "internalPullupCircuitDiagram",
        "markdownContent": "Inside the ATmega328P input buffer:\n1. When configured with `INPUT_PULLUP`, an internal P-FET engages a ~30k\u03a9 resistor tied to 5V.\n2. When the external button is open (unpressed), tiny leakage currents flow through the pull-up, holding the pin securely at 5.0V (`HIGH`).\n3. When the button is pressed, it shorts the pin directly to Ground (0V). Because the internal pull-up has a high 30k\u03a9 resistance, only $\\frac{5\\text{V}}{30\\text{k}\\Omega} \\approx 0.16\\text{ mA}$ flows harmlessly to ground.\n4. The input Schmitt trigger detects 0V and reports `LOW`.\n\n### Interactive Schematic: ATmega328P Internal Pull-Up Resistor\nExamine the interactive schematic below. Toggle `pinMode(pin, INPUT_PULLUP)` and press the button to observe the harmless 0.25mA drain to GND and verify active-low logic (unpressed = HIGH, pressed = LOW)!"
      },
      {
        "stepId": "l08_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine a 4-pin tactile momentary pushbutton and `comp_breadboard`:\n1. **Understand Pin Pairs:** A 4-pin pushbutton has two internal metal bars. The pins across from each other along the length of the package are permanently connected together.\n2. **Breadboard Straddling:** Place the pushbutton so it straddles the center divider trench of the breadboard (e.g. Pins in Row 15 columns D and G). This guarantees left pins are isolated from right pins until pressed.\n3. **Simple 2-Wire Connection:**\n   - Connect one leg of the switch to Uno Digital Pin 2.\n   - Connect the opposite leg of the switch to Uno `GND`.\n   - *Notice: No 5V wire or external resistor is needed on the breadboard!*"
      },
      {
        "stepId": "l08_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "interactiveWidgetType": "activeLowLogicChecker",
        "markdownContent": "Because of active-low logic:\n```cpp\nif (digitalRead(buttonPin) == LOW) {\n  // ACTION: Button IS physically pressed!\n} else {\n  // IDLE: Button is released!\n}\n```\n\n### Interactive Bench: Test Active-Low Inverted Logic\nTest the logic checker below. Press the virtual button to evaluate `if (digitalRead(buttonPin) == LOW)` and verify that physical button presses illuminate the built-in Pin 13 LED!"
      },
      {
        "stepId": "l08_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\nconst int buttonPin = 2;\nconst int ledPin = 13;\n\nvoid setup() {\n  pinMode(buttonPin, INPUT_PULLUP); // Enable built-in 30k pull-up resistor\n  pinMode(ledPin, OUTPUT);          // Status LED\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int buttonState = digitalRead(buttonPin);\n\n  if (buttonState == LOW) { // Button is pressed to GND\n    digitalWrite(ledPin, HIGH);\n    Serial.println(\"BUMP DETECTED! Reversing motors...\");\n  } else {\n    digitalWrite(ledPin, LOW);\n  }\n}\n```\n\n### Breakdown:\n- `pinMode(buttonPin, INPUT_PULLUP)`: Crucial line preventing floating state.\n- `if (buttonState == LOW)`: Directly evaluates the active-low contact closure.\n- Response executes with zero noticeable latency."
      },
      {
        "stepId": "l08_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What will `digitalRead(2)` return if the button is NOT pressed?\n  *Answer:* `HIGH` (held at 5V by the internal pull-up).\n- **Prediction 2:** What happens if you configure `pinMode(2, INPUT)` without an external resistor?\n  *Answer:* The pin floats; waving your hand near the wire or touching the insulation causes the LED to flicker randomly due to electrostatic coupling."
      },
      {
        "stepId": "l08_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "interactiveWidgetType": "switchBounceVisualizer",
        "markdownContent": "1. Create a push-to-toggle counter:\n   ```cpp\n   int count = 0;\n   void loop() {\n     if (digitalRead(buttonPin) == LOW) {\n       count++;\n       Serial.print(\"Press Count: \");\n       Serial.println(count);\n       delay(200); // Simple software debounce delay\n     }\n   }\n   ```\n2. Press the button quickly and observe how a 200ms delay prevents mechanical switch bounce from registering 5 presses for 1 physical click.\n\n### Interactive Oscilloscope: Microsecond Switch Bounce\nPress the button on the oscilloscope below to observe microsecond contact chatter. Toggle debounce mode and adjust the software delay window to eliminate false clicks!"
      },
      {
        "stepId": "l08_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Industrial emergency stop (E-stop) mushroom buttons, robotic 3D printer axis limit switches, and missile interlocks are hardwired active-low (normally closed). If an interconnect cable is severed or broken, the circuit immediately drops to open/triggered, halting the machine as a fail-safe!"
      },
      {
        "stepId": "l08_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Button Always Reads LOW Whether Pressed or Released\n- **Diagnosis:** Orientation error! The button is rotated 90 degrees on the breadboard, causing the permanently shorted internal pin pairs to bridge the circuit.\n- **Remedy:** Rotate the button 90 degrees so the curved leads straddle the breadboard center trench.\n\n### Symptom 2: Button Triggers When Fingers Approach Without Touching\n- **Diagnosis:** Floating pin! The sketch used `pinMode(2, INPUT)` instead of `INPUT_PULLUP`.\n- **Remedy:** Add `_PULLUP` to the `pinMode` declaration."
      },
      {
        "stepId": "l08_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- Never wire an input pin directly to 5V and then close a switch directly to GND without a current-limiting resistor, as this creates a direct dead short across the 5V power bus!\n- Always connect the switch between the pin and GND when using `INPUT_PULLUP`."
      },
      {
        "stepId": "l08_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- High-impedance inputs float without a defined pull-up or pull-down reference.\n- `INPUT_PULLUP` engages on-chip resistors, simplifying breadboard wiring.\n- Active-low logic treats `LOW` as pressed and `HIGH` as unpressed.\n- Software debounce delays tame mechanical contact bounce.\n- Up next in Lesson 09: Connecting multi-sensor networks over two wires with the I2C bus."
      },
      {
        "stepId": "l08_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of digital inputs, floating pins, active-low logic, and debouncing.",
        "interactiveConfig": {
          "question": "What state does a pin configured with `INPUT_PULLUP` read when the button is open (unpressed)?",
          "options": [
            "HIGH",
            "LOW",
            "Floating"
          ],
          "correctIndex": 0,
          "explanation": "Correct: HIGH. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What state does a pin configured with `INPUT_PULLUP` read when the button is open (unpressed)?",
              "options": [
                "HIGH",
                "LOW",
                "Floating"
              ],
              "correctIndex": 0,
              "explanation": "Correct: HIGH. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is a \"floating\" digital pin?",
              "options": [
                "An unconnected high-impedance input that fluctuates randomly from electromagnetic noise",
                "A pin submerged in water",
                "A pin configured as both input and output simultaneously"
              ],
              "correctIndex": 0,
              "explanation": "Correct: An unconnected high-impedance input that fluctuates randomly from electromagnetic noise. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why is `INPUT_PULLUP` preferred for simple pushbutton circuits?",
              "options": [
                "It eliminates the need for an external physical resistor on the breadboard",
                "It makes buttons click louder",
                "It allows buttons to operate over Wi-Fi"
              ],
              "correctIndex": 0,
              "explanation": "Correct: It eliminates the need for an external physical resistor on the breadboard. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "When using active-low logic with a pull-up, what value indicates the button is pressed?",
              "options": [
                "LOW (0)",
                "HIGH (1)",
                "1023"
              ],
              "correctIndex": 0,
              "explanation": "Correct: LOW (0). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What physical phenomenon causes a single mechanical button press to register multiple times?",
              "options": [
                "Switch bounce (contact chatter)",
                "Inductive kickback",
                "Serial overflow"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Switch bounce (contact chatter). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Approximately what resistance value does the ATmega328P internal pull-up provide?",
              "options": [
                "20k\u03a9 to 50k\u03a9",
                "1\u03a9",
                "10M\u03a9"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 20k\u03a9 to 50k\u03a9. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "How should a momentary button be wired when using `INPUT_PULLUP`?",
              "options": [
                "One terminal to the digital pin, the other terminal to GND",
                "One terminal to 5V, the other to 12V",
                "One terminal to A0, the other to 3.3V"
              ],
              "correctIndex": 0,
              "explanation": "Correct: One terminal to the digital pin, the other terminal to GND. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "In robotics, why are emergency limit switches typically wired active-low?",
              "options": [
                "Fail-safe protection: if a wire breaks, the system detects it immediately as triggered",
                "To save battery power",
                "It reduces code size"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Fail-safe protection: if a wire breaks, the system detects it immediately as triggered. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 70
  },
  {
    "id": "lesson_09",
    "title": "The I2C Communication Bus",
    "summary": "Daisy-chain multiple sensors and displays over just two shared wires using 7-bit addressing.",
    "tier": "builder",
    "estimatedMinutes": 20,
    "prerequisites": [
      "lesson_03",
      "lesson_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07",
      "comp_10"
    ],
    "steps": [
      {
        "stepId": "l09_s01",
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### The Two-Wire Superhighway: Bus Topologies\nIf every sensor, motor driver, display, and keypad required its own dedicated pins on the Arduino, you would run out of pins after adding just three components. A humanoid robot needs dozens of sensors: gyroscopes, thermal cameras, pressure sensors, and displays.\n\nThe I2C bus solves this pin starvation problem by allowing up to 127 unique peripheral devices to communicate over the exact same two wires! In this lesson, you will network a display and a precision clock onto a shared data superhighway.\n\n```\nController (Uno) \u2500\u2500\u2500\u252c\u2500\u2500\u2500 SDA (Data: A4) \u2500\u2500\u2500\u2500\u252c\u2500\u2500\u2500 LCD Display (0x27)\n                    \u2502                       \u2502\n                    \u2514\u2500\u2500\u2500 SCL (Clock: A5) \u2500\u2500\u2500\u2534\u2500\u2500\u2500 DS3231 RTC Clock (0x68)\n```"
      },
      {
        "stepId": "l09_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What is a library?** Pre-written, compiled code providing functions and classes for hardware devices.\n2. **What is hexadecimal notation?** Base-16 numbering prefixed with `0x` (e.g., `0x27` = $2 \\times 16 + 7 = 39$ decimal)."
      },
      {
        "stepId": "l09_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "interactiveWidgetType": "i2cPullupChecker",
        "markdownContent": "- **I2C (Inter-Integrated Circuit):** A synchronous, multi-target, bidirectional communication bus developed by Philips Semiconductor.\n- **SDA (Serial Data):** The bidirectional line over which data bytes travel.\n- **SCL (Serial Clock):** The synchronizing clock pulse train generated exclusively by the Controller.\n- **Controller (Master):** The device that initiates bus communication and generates SCL clock pulses (the Uno).\n- **Target (Slave):** Peripheral devices listening on the bus, responding only when their unique 7-bit address is called.\n- **7-Bit Address:** A unique identifier allowing up to 128 devices to share the bus without wire conflicts.\n- **ACK / NACK:** Acknowledge (0) or Not Acknowledge (1) bit returned by a target device to confirm packet receipt.\n- **Open-Drain / Pull-Up:** Hardware architecture where lines are passively held at 5V by resistors and pulled to GND by transistors.\n\n### Interactive Circuit Lab: Open-Drain & Pull-Up Resistors\nTest the open-drain schematic below. Select different pull-up resistor values (proper 4.7k\u03a9 vs missing vs weak 100k\u03a9) to observe waveform rise times and see why I2C lines cannot float!"
      },
      {
        "stepId": "l09_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cBusTimingDiagram",
        "markdownContent": "Communication on the I2C bus follows rigid timing:\n1. **Start Condition:** Controller pulls `SDA` LOW while `SCL` remains HIGH.\n2. **Address Frame:** Controller transmits 7 address bits followed by a Read/Write bit (0 for Write, 1 for Read).\n3. **Target ACK:** The target device whose internal address matches pulls `SDA` LOW during clock cycle 9.\n4. **Data Transmission:** Data bytes are transferred 8 bits at a time, each followed by an ACK bit.\n5. **Stop Condition:** Controller transitions `SDA` from LOW to HIGH while `SCL` is HIGH, releasing the bus.\n\n### Interactive Timing Oscilloscope: The I2C Protocol Frame\nStep through the logic analyzer capture below to observe the START condition, 7-bit address frame, R/W bit, peripheral ACK pulse on clock cycle 9, and STOP condition!"
      },
      {
        "stepId": "l09_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "interactiveWidgetType": "i2cDaisyChainSimulator",
        "markdownContent": "Examine `comp_07` (16x2 LCD) and `comp_10` (DS3231 RTC Module):\n1. **Parallel Bus Wiring:** Insert both components onto the breadboard.\n2. **Shared Power:** Connect both `VCC` pins to the breadboard 5V power rail, and both `GND` pins to the Ground rail.\n3. **Shared Data & Clock:**\n   - Connect BOTH `SDA` pins together and run a single wire to Uno Pin `A4`.\n   - Connect BOTH `SCL` pins together and run a single wire to Uno Pin `A5`.\n4. *Notice: Even with two complex peripherals attached, you still have nearly all of your Arduino's digital and analog pins completely free!*\n\n### Interactive Bus Builder: Multi-Device Daisy-Chaining & Collisions\nAttach peripherals to the shared 2-wire bus below. Connect the LCD (`0x27`) and RTC (`0x68`) simultaneously, then attach a duplicate sensor to observe and resolve an address collision!"
      },
      {
        "stepId": "l09_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- Arduino Core includes `<Wire.h>`, which controls the ATmega328P's internal Two-Wire Interface (TWI) hardware.\n- `Wire.begin()` initializes the I2C hardware as Controller.\n- `Wire.beginTransmission(address)` targets a specific chip.\n- `Wire.endTransmission()` transmits the buffer and returns an error code (`0` = Success/ACK)."
      },
      {
        "stepId": "l09_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "interactiveWidgetType": "i2cAddressScanner",
        "markdownContent": "```cpp\n#include <Wire.h>\n\nvoid setup() {\n  Wire.begin();        // Join I2C bus as Controller\n  Serial.begin(9600);\n  Serial.println(\"\\n--- I2C Hardware Bus Scanner ---\");\n}\n\nvoid loop() {\n  byte count = 0;\n  for (byte address = 1; address < 127; address++) {\n    Wire.beginTransmission(address);\n    byte error = Wire.endTransmission();\n\n    if (error == 0) { // Target device acknowledged ping!\n      Serial.print(\"Discovered I2C device at address: 0x\");\n      if (address < 16) Serial.print(\"0\");\n      Serial.println(address, HEX);\n      count++;\n    }\n  }\n  Serial.print(\"Scan complete. Total devices detected: \");\n  Serial.println(count);\n  delay(5000);\n}\n```\n\n### Breakdown:\n- The loop iterates through valid 7-bit addresses ($1$ to $126$).\n- `Wire.endTransmission()` returns `0` if an ACK was received, proving a device is alive at that address.\n- Addresses are printed in standardized hexadecimal format.\n\n### Interactive Terminal: Run the I2C Address Scanner\nRun the simulated serial terminal below to probe 7-bit addresses 0x01 through 0x7E and discover active I2C peripherals in real time!"
      },
      {
        "stepId": "l09_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What appears in the Serial Monitor if only the LCD (`0x27`) and RTC (`0x68`) are connected?\n  *Answer:* The scanner reports `0x27` and `0x68`, and prints `Total devices detected: 2`.\n- **Prediction 2:** What happens if you accidentally swap the SDA and SCL jumper wires?\n  *Answer:* Devices cannot detect clock pulses; no device ACKs, and the scanner reports `Total devices detected: 0`."
      },
      {
        "stepId": "l09_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "1. Leave both devices connected to pins A4 and A5.\n2. Load your LCD sketch from Lesson 03.\n3. Add RTC library calls to read time and display real-time clock hours and minutes directly on the LCD screen, proving simultaneous bus communication."
      },
      {
        "stepId": "l09_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Modern smartphones, DJI drones, and autonomous rovers connect accelerometers, compasses, barometers, capacitive touchscreens, and battery management ICs to a central CPU over shared I2C buses, saving vast amounts of circuit board space."
      },
      {
        "stepId": "l09_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Scanner Freezes on Address 0x01\n- **Diagnosis:** Bus lockup! SCL or SDA is shorted directly to GND on the breadboard, preventing clock edges from rising.\n- **Remedy:** Inspect breadboard wiring and remove the ground bridge on SDA/SCL.\n\n### Symptom 2: Address Collision\n- **Symptom:** Two identical sensors share address `0x68`, corrupting all readings.\n- **Diagnosis:** Both chips drive the line simultaneously.\n- **Remedy:** Solder the address solder-bridge pad (`A0`/`AD0`) on one sensor to alter its base address to `0x69`."
      },
      {
        "stepId": "l09_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- **3.3V Logic Cautions:** Many modern I2C sensors (such as BMP280 or MPU6050) operate on 3.3V logic. Connecting 5V Uno I2C lines to 3.3V-only sensors without bidirectional level shifters can blow the target's input FETs.\n- Always check the module datasheet for built-in 5V level shifting transistors."
      },
      {
        "stepId": "l09_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- I2C coordinates up to 127 devices over two shared lines (`SDA` on A4, `SCL` on A5).\n- The Controller generates clock pulses; targets respond only to their unique 7-bit hex address.\n- Devices wire in parallel\u2014share power, ground, clock, and data.\n- Up next in Lesson 10: Unleashing multi-megahertz bandwidth with the 4-wire SPI protocol."
      },
      {
        "stepId": "l09_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of I2C bus communications, open-drain pull-ups, and device addressing.",
        "interactiveConfig": {
          "question": "What are the names of the two communication lines used by the I2C protocol?",
          "options": [
            "SDA (Serial Data) and SCL (Serial Clock)",
            "TX (Transmit) and RX (Receive)",
            "MOSI and MISO"
          ],
          "correctIndex": 0,
          "explanation": "Correct: SDA (Serial Data) and SCL (Serial Clock). Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What are the names of the two communication lines used by the I2C protocol?",
              "options": [
                "SDA (Serial Data) and SCL (Serial Clock)",
                "TX (Transmit) and RX (Receive)",
                "MOSI and MISO"
              ],
              "correctIndex": 0,
              "explanation": "Correct: SDA (Serial Data) and SCL (Serial Clock). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which pins on the standard Arduino Uno serve as hardware SDA and SCL?",
              "options": [
                "A4 (SDA) and A5 (SCL)",
                "Pin 0 and Pin 1",
                "Pin 11 and Pin 12"
              ],
              "correctIndex": 0,
              "explanation": "Correct: A4 (SDA) and A5 (SCL). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Theoretically, how many unique addresses can be represented by standard 7-bit I2C?",
              "options": [
                "128 (with ~112\u2013119 usable addresses)",
                "256",
                "2"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 128 (with ~112\u2013119 usable addresses). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What component generates the synchronizing clock pulses on the SCL line?",
              "options": [
                "The Controller (Master) device",
                "The Target (Slave) device",
                "The pull-up resistor"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The Controller (Master) device. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What signal does a target device return to confirm receipt of an address or data byte?",
              "options": [
                "ACK (Acknowledge) bit",
                "Reset pulse",
                "12V spike"
              ],
              "correctIndex": 0,
              "explanation": "Correct: ACK (Acknowledge) bit. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "How are multiple I2C devices physically connected to the Arduino?",
              "options": [
                "In parallel: all SDA lines connect together, all SCL lines connect together",
                "In a daisy chain from output to input",
                "Each device requires its own unique Arduino pin"
              ],
              "correctIndex": 0,
              "explanation": "Correct: In parallel: all SDA lines connect together, all SCL lines connect together. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What happens if two devices with the identical address (e.g. 0x27) are wired to the same I2C bus?",
              "options": [
                "Address collision: both devices try to drive the data line at the same time, corrupting data",
                "The Arduino automatically changes one of their addresses",
                "The devices share the reading 50/50"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Address collision: both devices try to drive the data line at the same time, corrupting data. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which built-in Arduino library is used to communicate with I2C devices?",
              "options": [
                "`<Wire.h>`",
                "`<SPI.h>`",
                "`<Serial.h>`"
              ],
              "correctIndex": 0,
              "explanation": "Correct: `<Wire.h>`. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 80
  },
  {
    "id": "lesson_10",
    "title": "The High-Speed SPI Protocol",
    "summary": "Communicate with high-bandwidth displays and memory cards at multi-megahertz clock speeds.",
    "tier": "engineer",
    "estimatedMinutes": 20,
    "prerequisites": [
      "lesson_09"
    ],
    "componentIds": [
      "comp_uno",
      "comp_15",
      "comp_23"
    ],
    "steps": [
      {
        "stepId": "l10_s01",
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Blazing Fast Bitstreams: When Milliseconds Matter\nWhile I2C is great for slow environmental sensors, streaming graphics to a color TFT display, reading megabytes from an SD card flight recorder, or interrogating a 13.56 MHz RFID badge demands raw speed. I2C caps out at 100 kHz or 400 kHz, but the SPI protocol runs at up to 8 MHz on the Arduino Uno\u2014twenty times faster!\n\nIn this lesson, you will master the 4-wire synchronous protocol used for high-speed robotic telemetry and graphics.\n\n```\nMaster (Uno) \u2500\u2500\u2500\u2500 MOSI (Pin 11: Data Out) \u2500\u2500\u2500\u25ba Target (RFID / Matrix)\n             \u25c4\u2500\u2500\u2500 MISO (Pin 12: Data In)  \u2500\u2500\u2500\u2500\n             \u2500\u2500\u2500\u2500 SCK  (Pin 13: Clock)    \u2500\u2500\u2500\u25ba\n             \u2500\u2500\u2500\u2500 CS   (Pin 10: Select)   \u2500\u2500\u2500\u25ba\n```"
      },
      {
        "stepId": "l10_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **How does I2C select target devices?** By broadcasting a 7-bit hexadecimal address in the data packet header.\n2. **What does synchronous mean in digital electronics?** Communication coordinated by a shared, dedicated clock pulse line."
      },
      {
        "stepId": "l10_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "interactiveWidgetType": "spiVsI2cComparison",
        "markdownContent": "- **SPI (Serial Peripheral Interface):** A 4-wire, full-duplex, high-speed synchronous serial interface.\n- **MOSI (Master Out Slave In):** Data line carrying bytes from the Arduino to the peripheral.\n- **MISO (Master In Slave Out):** Data line carrying bytes from the peripheral back into the Arduino.\n- **SCK (Serial Clock):** High-frequency clock generated by the Uno (up to 8 MHz) that latches bits on each edge.\n- **CS / SS (Chip Select / Slave Select):** Dedicated active-low pin that awakens a specific peripheral chip.\n- **Full-Duplex:** Simultaneous transmission and reception of data in both directions during the exact same clock pulse.\n\n### Interactive Matrix: SPI vs. I2C Engineering Decisions\nReview the trade-off matrix below and tackle the 3 engineering design challenges to decide between SPI and I2C based on bandwidth, wire count, and peripheral constraints!"
      },
      {
        "stepId": "l10_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "interactiveWidgetType": "spiFullDuplexVisualizer",
        "markdownContent": "SPI functions as two linked 8-bit shift registers forming a circular ring:\n1. The Arduino pulls the target's dedicated `CS` pin `LOW` (0V).\n2. For each tick of the `SCK` line:\n   - The Master shifts 1 bit out on `MOSI` and samples 1 bit on `MISO`.\n   - The Target simultaneously shifts 1 bit out on `MISO` and samples 1 bit on `MOSI`.\n3. After 8 clock pulses, an entire byte has traveled in both directions simultaneously!\n4. The Arduino pulls `CS` `HIGH` (5V), placing the target's MISO output pin into high-impedance state so other chips can use the bus.\n\n### Interactive Shift Register Visualizer: Full-Duplex Transmission\nStep through the clock pulses on the circular shift register ring below to watch Master and Slave simultaneously exchange bytes over MOSI and MISO on shared SCK ticks!"
      },
      {
        "stepId": "l10_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "interactiveWidgetType": "chipSelectArbitrator",
        "markdownContent": "Examine `comp_23` (RC522 RFID Module) and `comp_15` (8x8 Dot Matrix):\n1. **Header Inspection:** Locate the pin labels on the module headers:\n   - Find `MOSI` (sometimes labeled `SI` or `DIN`).\n   - Find `MISO` (sometimes labeled `SO` or `DOUT`).\n   - Find `SCK` (sometimes labeled `CLK`).\n   - Find `SDA / NSS / CS` (Chip Select).\n2. **Uno Hardware SPI Pins:**\n   - Digital Pin 11: `MOSI`\n   - Digital Pin 12: `MISO`\n   - Digital Pin 13: `SCK`\n   - Digital Pin 10: Standard hardware `SS` / `CS`\n\n### Interactive Bus Arbitrator: Chip Select & Tri-State Standby\nToggle the CS lines below to activate the RC522 RFID reader and 8x8 Dot Matrix display. Observe High-Impedance (Hi-Z) tri-state standby and see why multiple CS pins must never be pulled LOW simultaneously!"
      },
      {
        "stepId": "l10_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- The `<SPI.h>` library provides low-level control of the ATmega328P SPI hardware.\n- `SPI.begin()` configures Pins 11, 12, and 13.\n- `SPI.transfer(value)` performs the simultaneous full-duplex byte exchange."
      },
      {
        "stepId": "l10_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\n#include <SPI.h>\n\nconst int chipSelectPin = 10;\n\nvoid setup() {\n  Serial.begin(9600);\n  pinMode(chipSelectPin, OUTPUT);\n  digitalWrite(chipSelectPin, HIGH); // De-select target initially\n\n  SPI.begin(); // Initialize SCK (13), MOSI (11), MISO (12)\n  Serial.println(\"SPI Master Bus Initialized.\");\n}\n\nbyte transferRegister(byte regAddress, byte value) {\n  digitalWrite(chipSelectPin, LOW); // Select the target chip\n\n  byte status = SPI.transfer(regAddress); // Send register address\n  byte response = SPI.transfer(value);     // Send payload and read response\n\n  digitalWrite(chipSelectPin, HIGH); // Deselect chip (release MISO line)\n  return response;\n}\n\nvoid loop() {\n  byte reply = transferRegister(0x00, 0xFF);\n  Serial.print(\"Register Response: 0x\");\n  Serial.println(reply, HEX);\n  delay(2000);\n}\n```\n\n### Breakdown:\n- `digitalWrite(chipSelectPin, LOW)` selects the peripheral.\n- `SPI.transfer(...)` clocks out data while reading in the response register.\n- `digitalWrite(chipSelectPin, HIGH)` immediately frees the bus."
      },
      {
        "stepId": "l10_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What state must the Chip Select (CS) pin be in to enable communication with the target device?\n  *Answer:* `LOW` (active-low state).\n- **Prediction 2:** What happens if you have two SPI devices on the bus and accidentally drive both of their CS pins LOW at the same time?\n  *Answer:* Bus contention! Both peripherals attempt to drive the `MISO` line simultaneously, corrupting data and potentially damaging output transistors."
      },
      {
        "stepId": "l10_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "interactiveWidgetType": "spiClockPolarityPhaseLab",
        "markdownContent": "1. Add a second SPI target using Digital Pin 9 as `chipSelectPin2`.\n2. Modify the code to query Target 1, set CS1 HIGH, query Target 2, and set CS2 HIGH.\n3. Observe how independent CS pins share the exact same 3 data/clock wires without address collision.\n\n### Interactive Timing Lab: SPI Clock Polarity (CPOL) & Phase (CPHA)\nExplore SPI Modes 0, 1, 2, and 3 below. Observe how clock idle levels and leading vs trailing sample edges change the timing of SPI transfers and generate Arduino `SPISettings`!"
      },
      {
        "stepId": "l10_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Digital high-resolution cameras, SD card flight data recorders on aerospace rockets, fast TFT LCD touch displays, and gigahertz radio transceivers (NRF24L01) use SPI for extreme throughput."
      },
      {
        "stepId": "l10_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: MISO Always Returns 0x00 or 0xFF\n- **Diagnosis:** The dedicated CS pin is floating or wired to the wrong pin.\n- **Remedy:** Ensure `pinMode(csPin, OUTPUT)` is declared in `setup()`, and check breadboard wire connections.\n\n### Symptom 2: Pin 13 LED Interferences\n- **Diagnosis:** The Uno's on-board Pin 13 LED is directly connected to `SCK`, adding slight capacitive load.\n- **Remedy:** Keep clock speeds at or below 4 MHz on breadboards with jumper wires to prevent clock ringing."
      },
      {
        "stepId": "l10_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- **Signal Reflection & Inductance:** SPI operates at multi-megahertz frequencies. Long jumper wires (>20 cm) act as inductors and antennas, creating signal degradation and ringing. Keep SPI wires short and bundled away from motor power leads.\n- Never exceed 3.3V on the RC522 RFID module power pin; connect strictly to the Uno `3.3V` pin!"
      },
      {
        "stepId": "l10_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- SPI achieves multi-megahertz throughput via 4 dedicated lines: `MOSI`, `MISO`, `SCK`, and `CS`.\n- Full-duplex shift-register transfers send and receive data simultaneously.\n- Chip Select (`CS`) lines manage arbitration without address packet overhead.\n- Up next in Lesson 11: Long-distance asynchronous serial communication with UART and wireless Bluetooth."
      },
      {
        "stepId": "l10_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the SPI protocol, full-duplex transmission, chip select arbitration, and clock polarity.",
        "interactiveConfig": {
          "question": "What does SPI stand for?",
          "options": [
            "Serial Peripheral Interface",
            "System Power Interconnect",
            "Synchronous Packet Integration"
          ],
          "correctIndex": 0,
          "explanation": "Correct: Serial Peripheral Interface. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What does SPI stand for?",
              "options": [
                "Serial Peripheral Interface",
                "System Power Interconnect",
                "Synchronous Packet Integration"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Serial Peripheral Interface. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What does the term \"Full-Duplex\" mean in SPI communication?",
              "options": [
                "Data can be transmitted and received at the exact same instant",
                "Only one device can transmit at a time",
                "Data transmits twice for redundancy"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Data can be transmitted and received at the exact same instant. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which line transmits data from the Arduino Master to the peripheral target?",
              "options": [
                "MOSI (Master Out Slave In)",
                "MISO (Master In Slave Out)",
                "SCK (Serial Clock)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: MOSI (Master Out Slave In). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "How does the Arduino Master select which peripheral to talk to on an SPI bus?",
              "options": [
                "By pulling that specific device's Chip Select (CS) line LOW",
                "By broadcasting an I2C hex address",
                "By increasing the voltage to 12V"
              ],
              "correctIndex": 0,
              "explanation": "Correct: By pulling that specific device's Chip Select (CS) line LOW. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which hardware pins on an Arduino Uno serve as MOSI, MISO, and SCK?",
              "options": [
                "Pin 11 (MOSI), Pin 12 (MISO), Pin 13 (SCK)",
                "Pin 0, Pin 1, Pin 2",
                "Pin A4, Pin A5, Pin A6"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Pin 11 (MOSI), Pin 12 (MISO), Pin 13 (SCK). Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "If you add 3 SPI devices to your Arduino, how many shared lines and dedicated lines do you need?",
              "options": [
                "3 shared lines (MOSI, MISO, SCK) and 3 dedicated CS lines",
                "12 individual wires",
                "Only 2 wires total"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 3 shared lines (MOSI, MISO, SCK) and 3 dedicated CS lines. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "In comparison to I2C, what is the main advantage of the SPI protocol?",
              "options": [
                "Significantly higher data transfer speeds and simple shift-register hardware",
                "Uses fewer wires",
                "Transmits over long distances (kilometers)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Significantly higher data transfer speeds and simple shift-register hardware. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What electrical problem occurs if two SPI peripherals share the same CS line?",
              "options": [
                "MISO bus contention: both peripherals attempt to drive the data return line simultaneously",
                "The Arduino clock stops",
                "The memory is wiped"
              ],
              "correctIndex": 0,
              "explanation": "Correct: MISO bus contention: both peripherals attempt to drive the data return line simultaneously. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 90
  },
  {
    "id": "lesson_11",
    "title": "Serial UART & Wireless Communication",
    "summary": "Establish bidirectional serial telemetry and communicate wirelessly with Bluetooth modules.",
    "tier": "engineer",
    "estimatedMinutes": 20,
    "prerequisites": [
      "lesson_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_29"
    ],
    "steps": [
      {
        "stepId": "l11_s01",
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Cut the Tether: Untethered Wireless Telemetry\nA robot tethered to a workbench by a USB cable cannot explore the world. To roam autonomously across terrain, monster robots must transmit telemetry data, video diagnostics, and receive directional steering commands wirelessly through the air.\n\nUART (Universal Asynchronous Receiver-Transmitter) is the universal language of microcontrollers, GPS receivers, radio transceivers, and cellular modems. In this lesson, you will build an asynchronous wireless bridge between your monster robot and your smartphone!\n\n```\nArduino Uno (5V) \u2500\u2500\u2500 Pin 11 (TX) \u2500\u2500\u2500[ 1k\u03a9 ]\u2500\u2500\u2500\u252c\u2500\u2500\u2500 RXD (3.3V) \u2500\u2500\u2500 Bluetooth Module\n                                             \u2502\n                                           [ 2k\u03a9 ]\n                                             \u2502\nArduino Uno (GND) \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2534\u2500\u2500\u2500 GND \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500 Bluetooth Module\nArduino Uno (5V) \u2500\u2500\u2500 Pin 10 (RX) \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500 TXD \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500 Bluetooth Module\n```"
      },
      {
        "stepId": "l11_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What baud rate does `Serial.begin(9600)` configure?** 9600 symbols/bits per second.\n2. **What do the `TX` and `RX` labels represent on microcontrollers?** Transmit (`TX`) and Receive (`RX`)."
      },
      {
        "stepId": "l11_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **UART:** A dedicated hardware peripheral that translates parallel CPU data bytes into serial bitstreams and vice versa.\n- **Asynchronous:** Communication without a shared clock wire; transmitter and receiver agree on precise timing (baud rate) in advance.\n- **Data Framing (8-N-1):** Standard serial protocol consisting of 1 Start bit (falling edge), 8 Data bits, No Parity bit, and 1 Stop bit (high idle).\n- **Crossed Lines:** Fundamental serial rule: Transmitter (`TX`) connects to Receiver (`RX`) on the partner device.\n- **`SoftwareSerial`:** Library that emulates UART timing on general-purpose digital pins, freeing hardware Pins 0 and 1 for USB programming.\n- **Logic Level Shifting:** Stepping down 5.0V output signals to 3.3V to prevent destruction of sensitive radio receiver ICs."
      },
      {
        "stepId": "l11_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "interactiveWidgetType": "uartFrameVisualizer",
        "markdownContent": "UART serial framing operates without a clock line:\n1. **Idle State:** The serial line sits at continuous HIGH (5V or 3.3V).\n2. **Start Bit:** The transmitter pulls the line LOW for exactly 1 bit duration ($\\frac{1}{9600\\text{ baud}} \\approx 104.16\\ \\mu\\text{s}$). This falling edge triggers the receiver's internal clock timer.\n3. **Data Sampling:** The receiver counts clock ticks and samples the line state in the exact middle of each of the subsequent 8 bit windows.\n4. **Stop Bit:** The transmitter pulls the line HIGH for at least 1 bit duration to conclude the frame and re-establish the idle level.\n\n### Interactive Waveform Visualizer: UART Packet Anatomy\nExplore asynchronous UART packet framing below. Observe how the line idles HIGH (+5V), pulls LOW for the Start Bit, sends 8 data bits LSB-first, and returns HIGH for the Stop Bit!"
      },
      {
        "stepId": "l11_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "interactiveWidgetType": "txRxCrossWireChecker",
        "markdownContent": "Examine `comp_29` (HC-05 Bluetooth Module):\n1. **Pin Inspection:** Locate the header pins: `VCC`, `GND`, `TXD`, `RXD`, `STATE`, `EN`.\n2. **Power Wiring:** Connect Module `VCC` to Uno `5V`, and Module `GND` to Uno `GND`.\n3. **Receive Line (Direct):** Connect Module `TXD` (which outputs safe 3.3V logic) directly to Uno Digital Pin 10 (`SoftwareSerial RX`).\n4. **Transmit Line (Voltage Divider):** Uno Pin 11 outputs 5.0V, but the HC-05 RXD pin accepts only 3.3V maximum!\n   - Connect Uno Pin 11 to one leg of a 1k\u03a9 resistor.\n   - Connect the other leg of the 1k\u03a9 resistor to a breadboard node.\n   - Connect the breadboard node to HC-05 `RXD`.\n   - Connect a 2k\u03a9 resistor from the breadboard node to `GND`.\n   - *Result: $V_{\\text{out}} = 5\\text{V} \\times \\frac{2\\text{k}\\Omega}{1\\text{k}\\Omega + 2\\text{k}\\Omega} = 3.33\\text{V}$ (perfect protection!).*\n\n### Interactive Breadboard Checker: TX/RX Cross-Wiring & Voltage Divider\nTest your serial wiring below to avoid the classic TX-to-TX beginner trap and verify that the 1k\u03a9 / 2k\u03a9 voltage divider protects delicate 3.3V wireless RX pins!"
      },
      {
        "stepId": "l11_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- Instantiate the software serial port: `SoftwareSerial bluetooth(10, 11);` (Pin 10 = RX, Pin 11 = TX).\n- Always verify incoming characters using `bluetooth.available()` before invoking `bluetooth.read()`."
      },
      {
        "stepId": "l11_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\n#include <SoftwareSerial.h>\n\n// Pin 10 = Arduino RX (connects to Module TXD)\n// Pin 11 = Arduino TX (connects via voltage divider to Module RXD)\nSoftwareSerial bluetooth(10, 11);\n\nvoid setup() {\n  Serial.begin(9600);       // USB Hardware Serial to Computer\n  bluetooth.begin(9600);    // Wireless UART to Bluetooth Module\n  Serial.println(\"--- Bluetooth Telemetry Bridge Active ---\");\n}\n\nvoid loop() {\n  // Forward wireless commands from phone/tablet to computer monitor\n  if (bluetooth.available()) {\n    char incomingByte = bluetooth.read();\n    Serial.write(incomingByte);\n  }\n\n  // Forward keyboard commands from computer monitor to wireless robot\n  if (Serial.available()) {\n    char outboundByte = Serial.read();\n    bluetooth.write(outboundByte);\n  }\n}\n```\n\n### Breakdown:\n- Bi-directional bridge forwards packets between USB hardware serial and wireless software serial.\n- Zero delay blocks: execution loops continuously at maximum speed."
      },
      {
        "stepId": "l11_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "interactiveWidgetType": "baudRateMismatchDemo",
        "markdownContent": "- **Prediction 1:** What happens if the Bluetooth module transmits at 38400 baud while `bluetooth.begin()` is set to 9600?\n  *Answer:* Severe bit sampling timing errors: incoming characters will appear as corrupted gibberish symbols.\n- **Prediction 2:** What happens if you plug Bluetooth TX directly into Arduino Hardware Pin 0 (RX) while trying to upload code via USB?\n  *Answer:* USB code upload fails with an `avrdude` sync error because the ATmega16U2 USB chip and the Bluetooth module fight to drive Pin 0 simultaneously.\n\n### Interactive Timing Lab: Baud Rate Clock Mismatch & Framing Errors\nExperiment with mismatched baud rates below. Observe how clock drift produces framing errors and corrupted gibberish when sender and receiver clocks disagree!"
      },
      {
        "stepId": "l11_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "interactiveWidgetType": "bluetoothAtCommandTerminal",
        "markdownContent": "1. Pair a smartphone or laptop to the HC-05 module using a Bluetooth terminal application (e.g. Serial Bluetooth Terminal).\n2. Type command `'1'` on the phone.\n3. Expand the Arduino code to toggle the Pin 13 LED on when `'1'` is received, and off when `'0'` is received.\n4. Test wireless control from across the room!\n\n### Interactive Terminal: HC-05 Bluetooth AT Command Console\nConfigure your Bluetooth module using the simulated Hayes AT command terminal below. Test AT ping, rename the device, set passkeys, and inspect status LED pulse timing!"
      },
      {
        "stepId": "l11_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "GPS navigation satellites, drone telemetry radios (MavLink), industrial cellular telemetry modems, and barcode scanners communicate with flight computers using UART serial data streams."
      },
      {
        "stepId": "l11_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Arduino IDE Reports `avrdude: programmer is not responding`\n- **Diagnosis:** Hardware Pin Conflict! External modules are wired to Hardware Pins 0 and 1 during upload.\n- **Remedy:** Unplug wires on Pins 0 and 1 while flashing, or migrate the module connections to `SoftwareSerial` on Pins 10 and 11.\n\n### Symptom 2: Module Pairs, but No Text Received\n- **Diagnosis:** Straight connection error! TX was wired to TX, and RX was wired to RX.\n- **Remedy:** Swap data lines: Arduino TX must connect to Module RX, and Arduino RX must connect to Module TX."
      },
      {
        "stepId": "l11_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- **3.3V Logic Protection:** The RX pin on many Bluetooth (HC-05/ESP8266) modules is strictly 3.3V. Feeding raw 5V from an Arduino Uno output pin directly into the module RX pin will overheat and permanently destroy the wireless radio chip. Always use a resistor voltage divider.\n- Disconnect power before adjusting voltage divider resistors on the breadboard."
      },
      {
        "stepId": "l11_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- UART achieves point-to-point serial communication using start/stop framing without a shared clock wire.\n- TX and RX lines must always cross between partner devices.\n- `SoftwareSerial` frees hardware pins 0 and 1 to prevent USB upload lockouts.\n- Resistor dividers safely step down 5V Uno signals to protect 3.3V wireless silicon.\n- Up next in Lesson 12: High power motor driving, flyback diodes, and H-Bridge physics!"
      },
      {
        "stepId": "l11_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of UART asynchronous framing, crossed TX/RX lines, SoftwareSerial, and Bluetooth telemetry.",
        "interactiveConfig": {
          "question": "What does UART stand for?",
          "options": [
            "Universal Asynchronous Receiver-Transmitter",
            "Ultra Analog Radio Transceiver",
            "Unified Automated Robotic Telemetry"
          ],
          "correctIndex": 0,
          "explanation": "Correct: Universal Asynchronous Receiver-Transmitter. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What does UART stand for?",
              "options": [
                "Universal Asynchronous Receiver-Transmitter",
                "Ultra Analog Radio Transceiver",
                "Unified Automated Robotic Telemetry"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Universal Asynchronous Receiver-Transmitter. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the golden wiring rule for connecting two UART serial devices?",
              "options": [
                "Cross the data lines: TX connects to RX, and RX connects to TX",
                "Connect TX to TX, and RX to RX",
                "Connect both lines to Ground"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Cross the data lines: TX connects to RX, and RX connects to TX. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why is UART called \"asynchronous\"?",
              "options": [
                "There is no shared clock line; timing is governed entirely by agreed baud rates",
                "It only works when the microcontroller is asleep",
                "Signals are sent in reverse order"
              ],
              "correctIndex": 0,
              "explanation": "Correct: There is no shared clock line; timing is governed entirely by agreed baud rates. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why should you avoid connecting external hardware to Digital Pins 0 and 1 on an Uno?",
              "options": [
                "Pins 0 and 1 are shared with the onboard USB-to-serial chip used for flashing code",
                "They have no power supply",
                "They only support 1.8V"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Pins 0 and 1 are shared with the onboard USB-to-serial chip used for flashing code. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the purpose of the `SoftwareSerial` library?",
              "options": [
                "It allows ordinary digital pins to emulate hardware UART serial ports",
                "It compresses sketches to save flash memory",
                "It encrypts wireless data"
              ],
              "correctIndex": 0,
              "explanation": "Correct: It allows ordinary digital pins to emulate hardware UART serial ports. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why is a voltage divider needed between an Uno TX pin and a 3.3V Bluetooth module RX pin?",
              "options": [
                "To step down the 5V Arduino signal to prevent overvoltage damage to the 3.3V module",
                "To speed up data transmission",
                "To filter out radio interference"
              ],
              "correctIndex": 0,
              "explanation": "Correct: To step down the 5V Arduino signal to prevent overvoltage damage to the 3.3V module. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What method checks how many bytes are waiting in the serial receive buffer?",
              "options": [
                "`available()`",
                "`read()`",
                "`length()`"
              ],
              "correctIndex": 0,
              "explanation": "Correct: `available()`. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What happens if the transmitter and receiver are configured with mismatched baud rates?",
              "options": [
                "Bits are sampled at incorrect intervals, resulting in corrupt or unreadable data",
                "The microcontroller shuts off",
                "The hardware catches fire"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Bits are sampled at incorrect intervals, resulting in corrupt or unreadable data. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 90
  },
  {
    "id": "lesson_12",
    "title": "PWM & Motor Physics",
    "summary": "Drive high-current DC motors and servos using H-Bridges, PWM duty cycles, and flyback diode protection.",
    "tier": "engineer",
    "estimatedMinutes": 22,
    "prerequisites": [
      "lesson_06",
      "lesson_07"
    ],
    "componentIds": [
      "comp_uno",
      "comp_33",
      "comp_36",
      "comp_l293d"
    ],
    "steps": [
      {
        "stepId": "l12_s01",
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### High Current & Raw Power: The Muscle of Robotics\nRobots must move, climb, steer, and grip! But motors are hungry, violent electrical beasts. Unlike delicate LEDs that consume just 10 milliamps, motors contain heavy coils of copper wire that store magnetic energy. Connecting a motor directly to an Arduino pin will immediately fry the microcontroller or cause violent resets.\n\nIn this capstone lesson, you will master the physics of inductive kickback, flyback diode protection, and dual H-Bridge circuits to command high-power robotic actuators!\n\n```\nArduino Uno (5V Logic) \u2500\u2500\u2500 Pins 7, 8, 9 \u2500\u2500\u2500\u25ba L293D H-Bridge Driver IC \u25c4\u2500\u2500\u2500 External 9V Battery\n                                                    \u2502\n                                                    \u25bc\n                                            High-Power DC Motor\n```"
      },
      {
        "stepId": "l12_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What is PWM duty cycle?** The percentage of time a digital pulse wave remains HIGH in one period.\n2. **What is the maximum safe continuous current from an Arduino I/O pin?** Approximately 20 mA."
      },
      {
        "stepId": "l12_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **Inductance ($L$):** The property of an electrical conductor opposing changes in electric current by storing energy in a magnetic field.\n- **Inductive Kickback (Back-EMF):** A massive voltage spike (>50V) generated when coil current abruptly stops ($V = -L \\frac{di}{dt}$).\n- **Flyback Diode:** A reverse-biased diode placed in parallel with an inductive coil to safely recirculate and dissipate kickback spikes.\n- **H-Bridge:** A circuit of 4 controllable switches (transistors) allowing voltage to be applied across a motor in either direction.\n- **Stall Current:** Peak current drawn when the motor shaft is physically prevented from rotating.\n- **Common Ground:** Connecting external motor battery ground and Arduino ground together to establish an identical 0V reference."
      },
      {
        "stepId": "l12_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "interactiveWidgetType": "inductiveKickbackSimulator",
        "markdownContent": "When current passes through the motor coils:\n1. Electric current creates a magnetic field that interacts with permanent magnets, generating rotational torque (Lorentz Force).\n2. When the control transistor abruptly opens:\n   - Current drops rapidly ($\\frac{di}{dt} \\to -\\infty$).\n   - The collapsing magnetic field induces a reverse high-voltage spike according to Lenz's Law: $V = -L \\frac{di}{dt}$.\n   - Without protection, this 60V+ spike arcs across transistor junctions, destroying the driver.\n3. The **Flyback Diode** (or the L293D's internal clamping diodes) becomes forward-biased by this negative spike, safely shunting current through the coil resistance as mild heat.\n\n### Interactive Coil Simulator: Inductive Kickback & Flyback Clamping\nSimulate an inductive motor coil when power turns off. Observe the dangerous 85V+ reverse spike caused by Lenz's Law and see how an antiparallel 1N4007 flyback diode safely clamps current!"
      },
      {
        "stepId": "l12_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "interactiveWidgetType": "externalMotorPowerLab",
        "markdownContent": "Examine `comp_l293d` (16-pin Dual H-Bridge IC) and `comp_33` (DC Motor):\n1. **IC Notch Orientation:** Locate the semi-circular notch on the top of the L293D chip. Pin 1 is immediately to the left of the notch.\n2. **Pin Identification:**\n   - Pin 16 ($V_{CC1}$): Logic 5V (from Arduino 5V).\n   - Pin 8 ($V_{CC2}$): Motor Power (connect to external 6V\u20139V battery pack).\n   - Pins 4, 5, 12, 13: Ground heat-sink pins (connect to common Ground).\n   - Pin 1 (Enable 1): PWM speed input (connect to Uno PWM Pin 9).\n   - Pin 2 (Input 1): Direction Leg A (connect to Uno Pin 8).\n   - Pin 7 (Input 2): Direction Leg B (connect to Uno Pin 7).\n   - Pins 3 & 6 (Outputs 1 & 2): Connect directly to the two terminals of the DC motor.\n\n### Interactive Electrical Bench: Motor Power Isolation & Common Ground\nExplore why high-current motors (1-2A stall) cause severe brownout crashes when powered from the Arduino 5V regulator, and verify proper external battery power with a shared Common Ground!"
      },
      {
        "stepId": "l12_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "interactiveWidgetType": "hBridgeDirectionSwitch",
        "markdownContent": "Direction Truth Table for L293D:\n- `IN1 = HIGH, IN2 = LOW`: Motor spins Forward.\n- `IN1 = LOW, IN2 = HIGH`: Motor spins Reverse.\n- `IN1 = IN2 (both LOW or both HIGH)`: Motor stops / active dynamic brake.\n- Speed is commanded by pulsing the Enable pin: `analogWrite(enablePin, speed)`.\n\n### Interactive Circuit Schematic: 4-Transistor H-Bridge & Shoot-Through Protection\nControl the H-Bridge switches below to reverse DC motor polarity, activate dynamic regenerative braking, and avoid catastrophic shoot-through short circuits!"
      },
      {
        "stepId": "l12_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\nconst int enablePin = 9; // PWM Speed\nconst int in1Pin = 8;    // Direction Leg A\nconst int in2Pin = 7;    // Direction Leg B\n\nvoid setup() {\n  pinMode(enablePin, OUTPUT);\n  pinMode(in1Pin, OUTPUT);\n  pinMode(in2Pin, OUTPUT);\n}\n\nvoid driveMotor(int speed, bool forward) {\n  if (forward) {\n    digitalWrite(in1Pin, HIGH);\n    digitalWrite(in2Pin, LOW);\n  } else {\n    digitalWrite(in1Pin, LOW);\n    digitalWrite(in2Pin, HIGH);\n  }\n  analogWrite(enablePin, constrain(speed, 0, 255));\n}\n\nvoid stopMotor() {\n  digitalWrite(in1Pin, LOW);\n  digitalWrite(in2Pin, LOW);\n  analogWrite(enablePin, 0);\n}\n\nvoid loop() {\n  driveMotor(200, true);  // Drive forward at ~78% speed\n  delay(2000);\n  stopMotor();\n  delay(1000);\n  driveMotor(200, false); // Drive reverse\n  delay(2000);\n  stopMotor();\n  delay(1000);\n}\n```\n\n### Breakdown:\n- `driveMotor()` encapsulates high-level direction logic and PWM duty cycle clipping.\n- Separate control legs provide complete bidirectional velocity control."
      },
      {
        "stepId": "l12_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What happens if you set both `in1Pin` and `in2Pin` to `HIGH` simultaneously?\n  *Answer:* Dynamic braking! Both motor terminals connect to the same voltage potential, causing motor back-EMF to brake the rotor quickly.\n- **Prediction 2:** What happens if you try to drive the motor with `analogWrite(enablePin, 20)` from a standstill?\n  *Answer:* The motor hums or whines but will not move due to static friction (stiction). Motors require a minimum threshold duty cycle (~60\u201380) to break friction."
      },
      {
        "stepId": "l12_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "interactiveWidgetType": "servoPulseWidthModulator",
        "markdownContent": "1. Wire the Potentiometer from Lesson 06 to `A0`.\n2. Map readings so:\n   - Full clockwise: Full speed forward.\n   - Center (512): Stopped.\n   - Full counter-clockwise: Full speed reverse.\n3. Test your custom robotic throttle control!\n\n### Interactive PWM Generator: 50Hz Servo Pulse Width Modulator\nAdjust the 50Hz PWM pulse width between 1.0ms (0\u00b0), 1.5ms (90\u00b0), and 2.0ms (180\u00b0) below to command the virtual servo horn with precise microsecond timing!"
      },
      {
        "stepId": "l12_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Electric vehicles (Tesla Model S), the Mars Curiosity Rover wheel drives, automated surgical drills, and industrial 6-axis robot joints use multi-phase H-bridge inverters to drive high-power motors with regenerative braking."
      },
      {
        "stepId": "l12_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Arduino Resets Whenever Motor Starts\n- **Diagnosis:** Brownout reset! The motor is powered from the Arduino 5V regulator pin; the heavy inrush current pulls the 5V rail voltage below 4.3V, causing the ATmega328P to reboot.\n- **Remedy:** Power the motor using an external battery pack connected to Pin 8 ($V_{CC2}$) and tie the battery ground to Arduino ground.\n\n### Symptom 2: Motor Driver Chip Gets Burning Hot\n- **Diagnosis:** Motor stall or thermal overload! The motor is drawing peak stall current (>1A), exceeding the L293D's 600mA rating.\n- **Remedy:** Check for mechanical binding on the motor shaft, reduce load, or upgrade to an L298N module."
      },
      {
        "stepId": "l12_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- **CRITICAL:** NEVER power DC motors or solenoids directly from the Arduino 5V regulator pin. Always use an external battery pack or power supply.\n- **COMMON GROUND:** ALWAYS connect external battery negative (`-`) to Arduino `GND`. Without a common ground reference, control signals cannot be interpreted.\n- Keep fingers and loose wires clear of spinning motor shafts and gears."
      },
      {
        "stepId": "l12_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- Motors convert electrical energy to mechanical torque through electromagnetic fields.\n- Inductive kickback ($V = -L \\frac{di}{dt}$) must be clamped with flyback diodes.\n- H-Bridges provide bidirectional polarity and PWM speed control.\n- High-power loads require dedicated external power supplies and shared common grounds.\n- Congratulations! You have mastered the complete hardware-software stack from electrons to code!"
      },
      {
        "stepId": "l12_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of inductive kickback, flyback diodes, H-bridge motor drivers, and servo PWM modulation.",
        "interactiveConfig": {
          "question": "What causes inductive kickback spikes when a motor is suddenly turned off?",
          "options": [
            "The collapsing magnetic field in the motor's copper coils induces a high reverse voltage",
            "The battery releases excess chemical energy",
            "Static electricity on the motor casing"
          ],
          "correctIndex": 0,
          "explanation": "Correct: The collapsing magnetic field in the motor's copper coils induces a high reverse voltage. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What causes inductive kickback spikes when a motor is suddenly turned off?",
              "options": [
                "The collapsing magnetic field in the motor's copper coils induces a high reverse voltage",
                "The battery releases excess chemical energy",
                "Static electricity on the motor casing"
              ],
              "correctIndex": 0,
              "explanation": "Correct: The collapsing magnetic field in the motor's copper coils induces a high reverse voltage. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What is the primary function of a flyback diode connected across an inductive load?",
              "options": [
                "To safely clamp and dissipate high-voltage inductive kickback spikes",
                "To make the motor spin twice as fast",
                "To convert AC voltage to DC voltage"
              ],
              "correctIndex": 0,
              "explanation": "Correct: To safely clamp and dissipate high-voltage inductive kickback spikes. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why can you NOT power a standard DC hobby motor directly from an Arduino digital pin?",
              "options": [
                "Arduino pins provide only ~20mA, while motors require 300mA\u20131000mA+ and can destroy pin transistors",
                "Arduino digital pins output AC voltage",
                "The code would be too complex"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Arduino pins provide only ~20mA, while motors require 300mA\u20131000mA+ and can destroy pin transistors. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What circuit architecture allows a microcontroller to reverse a motor's rotation direction?",
              "options": [
                "An H-Bridge circuit",
                "A voltage divider",
                "A low-pass filter"
              ],
              "correctIndex": 0,
              "explanation": "Correct: An H-Bridge circuit. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "What electrical problem occurs if you fail to connect the motor battery ground to Arduino ground?",
              "options": [
                "No shared reference voltage: control signals float and the motor driver cannot interpret logic states",
                "The battery explodes",
                "The Arduino executes code at half speed"
              ],
              "correctIndex": 0,
              "explanation": "Correct: No shared reference voltage: control signals float and the motor driver cannot interpret logic states. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why does an Arduino often crash or reset if a motor is wired directly to its 5V pin?",
              "options": [
                "Brownout reset: the sudden motor inrush current pulls the 5V rail voltage below the microcontroller operating limit",
                "Software stack overflow",
                "Flash memory corruption"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Brownout reset: the sudden motor inrush current pulls the 5V rail voltage below the microcontroller operating limit. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "In an H-bridge driver, what happens if both high-side and low-side switches on the same leg turn on simultaneously?",
              "options": [
                "Shoot-through short circuit that burns out the transistors",
                "The motor doubles its torque",
                "The motor switches to generator mode"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Shoot-through short circuit that burns out the transistors. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Why does a DC motor hum but refuse to turn at very low PWM values (e.g. 15 out of 255)?",
              "options": [
                "Static mechanical friction (stiction) requires a minimum threshold torque to overcome",
                "The PWM frequency is too high for electricity to flow",
                "The Arduino compiler ignores values below 20"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Static mechanical friction (stiction) requires a minimum threshold torque to overcome. Understanding this principle ensures proper circuit function and reliability."
            }
          ]
        }
      }
    ],
    "xpReward": 100
  }
  ,
  {
    "id": "l2a_01", "title": "2A Stub 1", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["lesson_01"], "componentIds": [], "steps": [{"stepId": "l2a_01_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_02", "title": "2A Stub 2", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_01"], "componentIds": [], "steps": [{"stepId": "l2a_02_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_03", "title": "2A Stub 3", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_02"], "componentIds": [], "steps": [{"stepId": "l2a_03_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_04", "title": "2A Stub 4", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_03"], "componentIds": [], "steps": [{"stepId": "l2a_04_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_05", "title": "2A Stub 5", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_04"], "componentIds": [], "steps": [{"stepId": "l2a_05_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_06", "title": "2A Stub 6", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_05"], "componentIds": [], "steps": [{"stepId": "l2a_06_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_07", "title": "2A Stub 7", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_06"], "componentIds": [], "steps": [{"stepId": "l2a_07_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2a_08", "title": "2A Stub 8", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2a_07"], "componentIds": [], "steps": [{"stepId": "l2a_08_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_01", "title": "CF Stub 1", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": [], "componentIds": [], "steps": [{"stepId": "cf_01_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_02", "title": "CF Stub 2", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_01"], "componentIds": [], "steps": [{"stepId": "cf_02_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_03", "title": "CF Stub 3", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_02"], "componentIds": [], "steps": [{"stepId": "cf_03_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_04", "title": "CF Stub 4", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_03"], "componentIds": [], "steps": [{"stepId": "cf_04_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_05", "title": "CF Stub 5", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_04"], "componentIds": [], "steps": [{"stepId": "cf_05_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_06", "title": "CF Stub 6", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_05"], "componentIds": [], "steps": [{"stepId": "cf_06_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_07", "title": "CF Stub 7", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_06"], "componentIds": [], "steps": [{"stepId": "cf_07_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "cf_08", "title": "CF Stub 8", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["cf_07"], "componentIds": [], "steps": [{"stepId": "cf_08_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_01", "title": "2B Stub 1", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["lesson_2a"], "componentIds": [], "steps": [{"stepId": "l2b_01_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_02", "title": "2B Stub 2", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_01"], "componentIds": [], "steps": [{"stepId": "l2b_02_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_03", "title": "2B Stub 3", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_02"], "componentIds": [], "steps": [{"stepId": "l2b_03_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_04", "title": "2B Stub 4", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_03"], "componentIds": [], "steps": [{"stepId": "l2b_04_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_05", "title": "2B Stub 5", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_04"], "componentIds": [], "steps": [{"stepId": "l2b_05_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_06", "title": "2B Stub 6", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_05"], "componentIds": [], "steps": [{"stepId": "l2b_06_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_07", "title": "2B Stub 7", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_06"], "componentIds": [], "steps": [{"stepId": "l2b_07_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  },
  {
    "id": "l2b_08", "title": "2B Stub 8", "summary": "", "tier": "rookie", "estimatedMinutes": 2, "prerequisites": ["l2b_07"], "componentIds": [], "steps": [{"stepId": "l2b_08_s01", "title": "Step 1", "type": "story", "markdownContent": "Stub"}], "xpReward": 10
  }
]''';

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
