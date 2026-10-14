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

  /// Initial curriculum foundation lessons (Lessons 1 through 12, expanded 12–14 steps)
  List<Lesson> getBaselineLessons() {
    return _cachedBaselineLessons ??=
        (jsonDecode(_baselineLessonsJson) as List<dynamic>)
            .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
            .toList();
  }

  static const String _baselineLessonsJson = r'''[
  {
    "id": "l01_01",
    "title": "What Is Arduino?",
    "summary": "Every monster robot needs a brain to explore the world.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s01",
        "title": "What Is Arduino?",
        "type": "story",
        "markdownContent": "Meet your robot’s control board! It follows your program: a sensor notices something, the board follows the instructions, and an output responds. Sense → Decide → Act!",
        "quickCheck": [
          {
            "questionId": "l01_s01_q1",
            "question": "What part of a robot helps it decide what to do?",
            "options": [
              "A small computer brain",
              "A shiny coat of paint",
              "A cardboard storage box"
            ],
            "correctIndex": 0,
            "explanation": "Just like humans use their brains to make choices, a robot uses a computer brain to decide what to do!",
            "warmupExplanation": "Think about how you decide what game to play. You use your brain! Robots have little computer brains to make choices."
          },
          {
            "questionId": "l01_s01_q2",
            "question": "If a robot vacuum cleaner bumps into a wall, what does it do next?",
            "options": [
              "Senses the bump and turns around",
              "Disappears into thin air",
              "Turns into a bowl of soup"
            ],
            "correctIndex": 0,
            "explanation": "Smart machines sense things around them and react. The vacuum feels the bump and steers away!",
            "warmupExplanation": "Everyday smart machines sense their surroundings and make simple decisions, like turning away from walls."
          }
        ]
      },
      {
        "stepId": "l01_01_s02",
        "title": "The Robot Signal Flow",
        "type": "visualExplanation",
        "markdownContent": "A button or light sensor is an input. The Arduino follows code. An LED or buzzer is an output. The board follows the program; it does not guess."
      },
      {
        "stepId": "l01_01_s03",
        "title": "Test the Brain's Signal Pulse",
        "type": "codeExperiment",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Put the stages in order: sense, decide, act. Then tap Test Signal Pulse and follow the robot’s message from sensor to output."
      },
      {
        "stepId": "l01_01_s04",
        "title": "Arduino Brain Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Prove your rookie engineer skills by answering these checkpoint questions about the Arduino brain!",
        "interactiveConfig": {
          "question": "What is the main job of an Arduino in a robot project?",
          "options": [
            "It acts as the robot brain, reading sensors and commanding outputs",
            "It only paints the robot cool colors",
            "It acts like a heavy brick to hold paper down"
          ],
          "correctIndex": 0,
          "explanation": "The Arduino is the electronic brain that connects senses to physical actions!",
          "questions": [
            {
              "question": "What is the main job of an Arduino in a robot project?",
              "options": [
                "It acts as the robot brain, reading sensors and commanding outputs",
                "It only paints the robot cool colors",
                "It acts like a heavy brick to hold paper down"
              ],
              "correctIndex": 0,
              "explanation": "The Arduino is the electronic brain that connects senses to physical actions!"
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Trace how a robot senses something, follows code, and acts.",
    "vocabulary": [
      {
        "term": "Sensor",
        "pronunciation": "SEN-sor",
        "meaning": "A part that notices something, like light or a button press."
      },
      {
        "term": "Program",
        "pronunciation": "PROH-gram",
        "meaning": "Instructions that tell a computer what to do."
      }
    ]
  },
  {
    "id": "l01_02",
    "title": "Meet the Arduino Uno",
    "summary": "Pick up your Arduino Uno board and hold it gently by its edges, just like holding a tasty cracker!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l01_01"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s02",
        "title": "Meet the Arduino Uno",
        "type": "physicalTask",
        "markdownContent": "Look at your board, then match the USB port, reset button, digital pins, and analog pins to their labels.",
        "quickCheck": [
          {
            "questionId": "l01_s02_q1",
            "question": "How should you hold an electronic circuit board like an Arduino?",
            "options": [
              "Gently by the outer edges",
              "By grabbing the delicate metal pins",
              "With wet hands right out of the sink"
            ],
            "correctIndex": 0,
            "explanation": "Holding circuit boards gently by their outer edges keeps all the delicate electronic parts safe and clean!",
            "warmupExplanation": "Electronics are friendly but delicate! Hold circuit boards by their plastic edges, just like a favorite trading card."
          },
          {
            "questionId": "l01_s02_q2",
            "question": "What cable connects your Arduino to your computer to share power and code?",
            "options": [
              "A USB cable",
              "A jump rope",
              "A garden hose"
            ],
            "correctIndex": 0,
            "explanation": "A USB cable delivers electrical power and transfers your code from the computer into the Arduino!",
            "warmupExplanation": "Computers use USB cables to talk to printers, game controllers, and Arduino boards."
          }
        ]
      },
      {
        "stepId": "l01_02_s02",
        "title": "Board Architecture & Key Landmarks",
        "type": "visualExplanation",
        "markdownContent": "USB connects the board to a computer. Reset restarts the program. The L light is built in. Pin headers connect wires and parts."
      },
      {
        "stepId": "l01_02_s03",
        "title": "Drag & Match Board Landmarks",
        "type": "physicalTask",
        "interactiveWidgetType": "boardLabelDragDrop",
        "markdownContent": "### Put Your Board Knowledge to the Test! 🎯\n\nInspect your physical Arduino Uno board, then match each label badge to its corresponding landmark below:\n- **USB Connection**: Silver port that links to PC for flashing code & 5V power.\n- **DC Power Barrel Jack**: Black round port for external 9V battery or wall adapter.\n- **Digital Pins (0–13)**: Top header pins sending & receiving binary HIGH/LOW.\n- **Analog Pins (A0–A5)**: Bottom right pins converting variable analog voltages into discrete 10-bit ADC readings (0–1023).\n\nDrag each badge into its slot to complete the hardware inspection!"
      },
      {
        "stepId": "l01_02_s04",
        "title": "Board Landmarks Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check how well you know the physical parts of the Arduino Uno board!",
        "interactiveConfig": {
          "question": "Which part of the Arduino connects to your computer for uploading code?",
          "options": [
            "The silver USB port",
            "The plastic battery snap",
            "The reset push button"
          ],
          "correctIndex": 0,
          "explanation": "The silver USB port connects to your computer to transfer program code and supply 5V power.",
          "questions": [
            {
              "question": "Which part of the Arduino connects to your computer for uploading code?",
              "options": [
                "The silver USB port",
                "The plastic battery snap",
                "The reset push button"
              ],
              "correctIndex": 0,
              "explanation": "The silver USB port connects to your computer to transfer program code and supply 5V power."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Find the main parts of an Arduino Uno board.",
    "vocabulary": [
      {
        "term": "Microcontroller",
        "pronunciation": "MY-kroh-kun-TROH-ler",
        "meaning": "A tiny computer chip that follows a program."
      },
      {
        "term": "Reset",
        "pronunciation": "ree-SET",
        "meaning": "Start the program again from the beginning."
      }
    ]
  },
  {
    "id": "l01_03",
    "title": "What Is a Microcontroller?",
    "summary": "Look right at the middle of your Arduino board.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l01_02"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s03",
        "title": "What Is a Microcontroller?",
        "type": "story",
        "markdownContent": "The black chip is the microcontroller. It runs your code. The blue board holds the chip and makes it easier to connect to a computer and other parts.",
        "quickCheck": [
          {
            "questionId": "l01_s03_q1",
            "question": "Which of these everyday machines has a tiny computer inside it?",
            "options": [
              "A microwave oven with a digital timer",
              "A plain wooden pencil",
              "A metal spoon"
            ],
            "correctIndex": 0,
            "explanation": "Microwaves use tiny microcontroller computers to count seconds, read button presses, and heat food!",
            "warmupExplanation": "Many household gadgets that beep, show numbers, or have buttons have tiny computers inside them."
          },
          {
            "questionId": "l01_s03_q2",
            "question": "Why does a computer chip need memory?",
            "options": [
              "To store instructions so it knows what to do",
              "To make delicious snacks",
              "To grow bigger leaves"
            ],
            "correctIndex": 0,
            "explanation": "Memory holds the instructions and numbers a computer needs to do its job!",
            "warmupExplanation": "Just like you use memory to remember a phone number or story, computers use memory to remember code instructions."
          }
        ]
      },
      {
        "stepId": "l01_03_s02",
        "title": "Inside the Chip: CPU, Flash, and RAM",
        "type": "visualExplanation",
        "markdownContent": "Think of Flash as a recipe book for saved code and RAM as a tiny scratchpad for information used while the program runs. The Uno also has memory for saved settings."
      },
      {
        "stepId": "l01_03_s03",
        "title": "CPU vs Memory Signal Flow",
        "type": "codeExperiment",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Follow the path: saved code → processor → pin. Tap each part to see how the program reaches an LED.",
        "interactiveConfig": {
          "nodes": [
            {
              "id": "flash",
              "label": "1. FLASH MEMORY\n(Permanent Storage)",
              "icon": "program",
              "role": "Stores your uploaded C++ program safely, keeping code ready even when disconnected from power.",
              "example": "32 KB Flash holding setup() and loop() instructions",
              "color": "#FFB300"
            },
            {
              "id": "cpu",
              "label": "2. CPU PROCESSOR\n(The Thinker)",
              "icon": "memory",
              "role": "Fetches code instructions at 16 million clock cycles per second and calculates logic decisions.",
              "example": "ATmega328P 8-bit RISC core evaluating conditions",
              "color": "#00E5FF"
            },
            {
              "id": "sram",
              "label": "3. SRAM SCRATCHPAD\n(Active Memory)",
              "role": "Holds temporary numbers and sensor readings while the sketch is actively running.",
              "example": "2 KB RAM tracking timer counts and light levels",
              "color": "#76FF03"
            },
            {
              "id": "pins",
              "label": "4. I/O PINS\n(Hardware Bridge)",
              "icon": "output",
              "role": "Translates internal CPU bits into physical electrical voltages on the Uno pin headers.",
              "example": "Pin 13 sending 5V to the built-in amber LED",
              "color": "#E040FB"
            }
          ]
        }
      },
      {
        "stepId": "l01_03_s04",
        "title": "Microcontroller Knowledge Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Prove your understanding of what makes a microcontroller tick!",
        "interactiveConfig": {
          "question": "What is the primary difference between a microcontroller and a desktop computer?",
          "options": [
            "A microcontroller is built to control physical hardware and live inside devices without a monitor",
            "A microcontroller has a 50-inch display screen built in",
            "A microcontroller can only be used to bake cookies"
          ],
          "correctIndex": 0,
          "explanation": "Microcontrollers are self-contained computer chips specialized for interacting with physical sensors and circuits.",
          "questions": [
            {
              "question": "What is the primary difference between a microcontroller and a desktop computer?",
              "options": [
                "A microcontroller is built to control physical hardware and live inside devices without a monitor",
                "A microcontroller has a 50-inch display screen built in",
                "A microcontroller can only be used to bake cookies"
              ],
              "correctIndex": 0,
              "explanation": "Microcontrollers are self-contained computer chips specialized for interacting with physical sensors and circuits."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Explain what the microcontroller chip does on the Uno.",
    "vocabulary": [
      {
        "term": "Processor",
        "pronunciation": "PRAH-ses-er",
        "meaning": "The part of the chip that follows instructions."
      },
      {
        "term": "Memory",
        "pronunciation": "MEM-uh-ree",
        "meaning": "A place where a computer keeps code or information."
      }
    ]
  },
  {
    "id": "l01_04",
    "title": "Inputs and Outputs",
    "summary": "Robots interact with the world through two main kinds of parts: Inputs and Outputs.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l01_03"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s04",
        "title": "Inputs and Outputs",
        "type": "story",
        "markdownContent": "Inputs help a robot notice the world: a button or light sensor. Outputs let it respond: an LED, buzzer, or motor. A motor needs a driver; never power it from an Arduino pin.",
        "quickCheck": [
          {
            "questionId": "l01_s04_q1",
            "question": "When you push a doorbell button, is the button an input or an output?",
            "options": [
              "An input sending a signal in",
              "An output making a ringing sound",
              "A power cable"
            ],
            "correctIndex": 0,
            "explanation": "Pushing the button sends information IN to the system, so the button is an input!",
            "warmupExplanation": "Inputs send information IN to the brain (like a button press). Outputs send actions OUT (like a chime)."
          },
          {
            "questionId": "l01_s04_q2",
            "question": "When a flashlight bulb shines bright light in a dark room, is the bulb an input or an output?",
            "options": [
              "An output creating light",
              "An input sensing the dark",
              "A battery holder"
            ],
            "correctIndex": 0,
            "explanation": "The bulb creates light and sends it OUT into the room, making it an output!",
            "warmupExplanation": "Outputs do things in the physical world, like shining lights, making sounds, or moving motors."
          }
        ]
      },
      {
        "stepId": "l01_04_s02",
        "title": "Senses vs. Muscles Architecture",
        "type": "visualExplanation",
        "markdownContent": "Ask: does this part send information to the board, or receive a command from it? That tells you whether it is an input or output."
      },
      {
        "stepId": "l01_04_s03",
        "title": "Sort the Senses and Muscles",
        "type": "physicalTask",
        "interactiveWidgetType": "inputOutputClassification",
        "markdownContent": "Sort the parts into inputs and outputs. Then explain one choice in your own words."
      },
      {
        "stepId": "l01_04_s04",
        "title": "Inputs and Outputs Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check how well you understand the difference between inputs and outputs!",
        "interactiveConfig": {
          "question": "An ultrasonic distance sensor measures how far away a toy monster is. Is it an input or an output?",
          "options": [
            "An Input (measures the physical world)",
            "An Output (creates movement)",
            "A power source"
          ],
          "correctIndex": 0,
          "explanation": "Sensors measure the world and deliver data into the Arduino, making them inputs.",
          "questions": [
            {
              "question": "An ultrasonic distance sensor measures how far away a toy monster is. Is it an input or an output?",
              "options": [
                "An Input (measures the physical world)",
                "An Output (creates movement)",
                "A power source"
              ],
              "correctIndex": 0,
              "explanation": "Sensors measure the world and deliver data into the Arduino, making them inputs."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Sort common robot parts into inputs and outputs.",
    "vocabulary": [
      {
        "term": "Input",
        "pronunciation": "IN-put",
        "meaning": "Information going into the Arduino."
      },
      {
        "term": "Output",
        "pronunciation": "OUT-put",
        "meaning": "A signal or action coming out of the Arduino."
      }
    ]
  },
  {
    "id": "l01_05",
    "title": "Digital vs Analog",
    "summary": "Electronic signals talk to the Arduino in two different ways:",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l01_04"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s05",
        "title": "Digital vs Analog",
        "type": "story",
        "markdownContent": "A button can give a digital HIGH or LOW reading. A knob can give changing voltages that the Uno measures as numbers. The voltage is smooth; the ADC reading is a set of steps.",
        "quickCheck": [
          {
            "questionId": "l01_s05_q1",
            "question": "A standard light switch is either flipped ON or flipped OFF. Is this digital or analog?",
            "options": [
              "Digital (two clear states)",
              "Analog (a smooth range)",
              "Disconnected"
            ],
            "correctIndex": 0,
            "explanation": "Digital signals have only two states (ON or OFF), just like a regular light switch!",
            "warmupExplanation": "Digital means two simple choices: ON or OFF, HIGH or LOW. Think of a simple light switch."
          },
          {
            "questionId": "l01_s05_q2",
            "question": "A volume knob turns smoothly from whisper-quiet to super loud. Is that digital or analog?",
            "options": [
              "Analog (smooth range with many levels)",
              "Digital (only ON or OFF)",
              "Empty"
            ],
            "correctIndex": 0,
            "explanation": "Because the volume changes smoothly through many levels in between, it is an analog signal!",
            "warmupExplanation": "Analog signals can be any level in between, like sliding a volume bar up and down."
          }
        ]
      },
      {
        "stepId": "l01_05_s02",
        "title": "HIGH/LOW vs. Continuous Waves",
        "type": "visualExplanation",
        "markdownContent": "The Uno’s analog input turns a voltage into a number from 0 to 1023. Digital HIGH is a recognized logic state; it is not a promise that the pin is exactly 5 volts."
      },
      {
        "stepId": "l01_05_s03",
        "title": "Interactive Signal Inspector & Prediction",
        "type": "physicalTask",
        "interactiveWidgetType": "arduinoBoardInspector",
        "markdownContent": "Flip the virtual switch and move the slider. Predict how the reading changes before you test it."
      },
      {
        "stepId": "l01_05_s04",
        "title": "Digital vs Analog Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of digital switches and analog waves!",
        "interactiveConfig": {
          "question": "What does the Uno do with a changing voltage on an analog input?",
          "options": [
            "Turns it into a number",
            "Makes it wireless",
            "Uses it to power a motor"
          ],
          "correctIndex": 0,
          "explanation": "The Uno measures the voltage and reports a number from 0 to 1023.",
          "questions": [
            {
              "question": "What does the Uno do with a changing voltage on an analog input?",
              "options": [
                "Turns it into a number",
                "Makes it wireless",
                "Uses it to power a motor"
              ],
              "correctIndex": 0,
              "explanation": "The Uno measures the voltage and reports a number from 0 to 1023."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Tell a two-state digital signal from a changing analog signal.",
    "vocabulary": [
      {
        "term": "Digital",
        "pronunciation": "DIJ-ih-tul",
        "meaning": "A signal read as one of a few choices, such as HIGH or LOW."
      },
      {
        "term": "Analog",
        "pronunciation": "AN-uh-log",
        "meaning": "A measurement that can change across a range."
      }
    ]
  },
  {
    "id": "l01_06",
    "title": "Meet the Pins",
    "summary": "Look along the top and bottom edges of your Arduino Uno.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l01_05"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s06",
        "title": "Meet the Pins",
        "type": "story",
        "markdownContent": "The Uno has digital pins for HIGH/LOW signals, analog pins for measurements, and power pins. Some digital pins have a ~ mark for PWM. Pins 0 and 1 are also used for serial communication.",
        "quickCheck": [
          {
            "questionId": "l01_s06_q1",
            "question": "Why does an Arduino have little pin holes along its edges?",
            "options": [
              "To plug in jumper wires to connect circuits",
              "To let cool air blow through",
              "To hold colored crayons"
            ],
            "correctIndex": 0,
            "explanation": "Pin headers let you plug jumper wires in so the Arduino can communicate with your circuits!",
            "warmupExplanation": "Pins are tiny sockets where wires plug in, connecting the Arduino brain to lights and sensors."
          },
          {
            "questionId": "l01_s06_q2",
            "question": "What does the letter 'A' stand for on pins labeled A0 through A5?",
            "options": [
              "Analog",
              "Airplane",
              "Action"
            ],
            "correctIndex": 0,
            "explanation": "The 'A' stands for Analog! Pins A0 to A5 read smooth, continuous signals from sensors.",
            "warmupExplanation": "Labels give us helpful clues. 'A' stands for Analog, designed for reading smooth ranges."
          }
        ]
      },
      {
        "stepId": "l01_06_s02",
        "title": "Pin Headers & Specialized Channels",
        "type": "visualExplanation",
        "markdownContent": "Use the board labels as your map: digital for switches and outputs, analog for changing sensor measurements, power and GND for the circuit."
      },
      {
        "stepId": "l01_06_s03",
        "title": "Pin Inspection & Matching Challenge",
        "type": "physicalTask",
        "interactiveWidgetType": "boardLabelDragDrop",
        "markdownContent": "Find digital pin 13, analog pin A0, 5V, and GND. Match each label to the right part of the board.",
        "interactiveConfig": {
          "targets": [
            {
              "id": "digital_pins",
              "label": "Digital Pins (0–13)",
              "hint": "Top row of sockets sending HIGH/LOW signals and reading switches"
            },
            {
              "id": "analog_pins",
              "label": "Analog Pins (A0–A5)",
              "hint": "Bottom right sockets reading smooth analog sensor voltages"
            },
            {
              "id": "power_5v",
              "label": "5V Power Supply",
              "hint": "Power pin on bottom left feeding 5 Volts to circuits"
            },
            {
              "id": "gnd",
              "label": "GND (Ground)",
              "hint": "Zero volt reference pin returning electricity safely back home"
            }
          ]
        }
      },
      {
        "stepId": "l01_06_s04",
        "title": "Pin Mastery Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check how well you know the pin headers on the Arduino Uno!",
        "interactiveConfig": {
          "question": "What do the wavy tildes (~) next to digital pins 3, 5, 6, 9, 10, and 11 mean?",
          "options": [
            "They support PWM for simulating analog fading and speed control",
            "They are broken and cannot be used",
            "They are only for playing underwater"
          ],
          "correctIndex": 0,
          "explanation": "The tilde (~) indicates Pulse Width Modulation (PWM) capable pins that can simulate variable analog outputs.",
          "questions": [
            {
              "question": "What do the wavy tildes (~) next to digital pins 3, 5, 6, 9, 10, and 11 mean?",
              "options": [
                "They support PWM for simulating analog fading and speed control",
                "They are broken and cannot be used",
                "They are only for playing underwater"
              ],
              "correctIndex": 0,
              "explanation": "The tilde (~) indicates Pulse Width Modulation (PWM) capable pins that can simulate variable analog outputs."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Choose a useful Uno pin group for a simple task.",
    "vocabulary": [
      {
        "term": "Pin",
        "pronunciation": "pin",
        "meaning": "A connection point for a wire or part."
      },
      {
        "term": "PWM",
        "pronunciation": "pee-dub-yoo-em",
        "meaning": "Fast on/off pulses that can control effects like LED brightness."
      }
    ]
  },
  {
    "id": "l01_07",
    "title": "Power and Ground",
    "summary": "Electricity is like a train on a circular railway track: it must travel in a complete, unbroken loop!",
    "tier": "rookie",
    "estimatedMinutes": 8,
    "courseId": "lesson_01",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l01_06"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s07",
        "title": "Power and Ground",
        "type": "story",
        "markdownContent": "A circuit needs a complete path. For this LED activity, use the kit’s resistor in series with the LED. Unplug the board before changing wires.",
        "quickCheck": [
          {
            "questionId": "l01_s07_q1",
            "question": "What does electricity need in order to flow and light up a bulb?",
            "options": [
              "A complete, unbroken loop from power to ground",
              "A broken wire with a big gap in it",
              "A cold glass of lemonade"
            ],
            "correctIndex": 0,
            "explanation": "Electricity can only flow when there is a complete, unbroken circle (circuit) from power back to ground!",
            "warmupExplanation": "The word 'circuit' means circle! Electricity must travel in a full circle from power back to ground."
          },
          {
            "questionId": "l01_s07_q2",
            "question": "What does the label 'GND' stand for on the Arduino board?",
            "options": [
              "Ground — the return path for electric current",
              "Giant Number Dial",
              "Game Never Done"
            ],
            "correctIndex": 0,
            "explanation": "GND stands for Ground! It is the essential return path for electricity in every circuit.",
            "warmupExplanation": "GND is short for Ground. In electronics, Ground is the safe return route for electric current."
          }
        ]
      },
      {
        "stepId": "l01_07_s02",
        "title": "The Closed Electrical Highway",
        "type": "visualExplanation",
        "markdownContent": "Follow the path: 5V → resistor → LED → GND. If the path breaks, the LED turns off. A wire straight from 5V to GND makes an unsafe short."
      },
      {
        "stepId": "l01_07_s03",
        "title": "Ground Troubleshooting Lab",
        "type": "physicalTask",
        "interactiveWidgetType": "groundTroubleshooting",
        "markdownContent": "Build or inspect the LED path. Try the complete circuit, a missing connection, and the short-circuit diagram. Never build a direct 5V-to-GND short."
      },
      {
        "stepId": "l01_07_s04",
        "title": "Power & Ground Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of electrical circuits, power, and ground!",
        "interactiveConfig": {
          "question": "What happens if the Ground (GND) wire falls out of a working LED circuit?",
          "options": [
            "The circuit opens, electrons stop flowing, and the LED turns OFF",
            "The LED turns into a laser beam",
            "The LED turns bright purple forever"
          ],
          "correctIndex": 0,
          "explanation": "Without Ground, there is no return path for current, creating an open circuit where electricity cannot flow.",
          "questions": [
            {
              "question": "What happens if the Ground (GND) wire falls out of a working LED circuit?",
              "options": [
                "The circuit opens, electrons stop flowing, and the LED turns OFF",
                "The LED turns into a laser beam",
                "The LED turns bright purple forever"
              ],
              "correctIndex": 0,
              "explanation": "Without Ground, there is no return path for current, creating an open circuit where electricity cannot flow."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Trace a safe, complete LED circuit from power back to ground.",
    "vocabulary": [
      {
        "term": "Circuit",
        "pronunciation": "SUR-kit",
        "meaning": "A complete path that lets electricity flow."
      },
      {
        "term": "Ground",
        "pronunciation": "ground",
        "meaning": "The circuit’s shared reference and return connection."
      }
    ]
  },
  {
    "id": "l01_08",
    "title": "How Arduino Makes Decisions",
    "summary": "How does the Arduino brain make smart choices?",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l01_07"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s08",
        "title": "How Arduino Makes Decisions",
        "type": "story",
        "markdownContent": "Robots follow rules. IF a button is pressed, turn the LED on. ELSE, turn it off. The Arduino checks the button and follows the matching instruction.",
        "quickCheck": [
          {
            "questionId": "l01_s08_q1",
            "question": "If you give a robot the rule: 'IF you see a red light, THEN stop,' what will it do when it sees red?",
            "options": [
              "Stop right away",
              "Speed up as fast as possible",
              "Spin in circles and laugh"
            ],
            "correctIndex": 0,
            "explanation": "Robots strictly follow rules! When the condition happens (red light), it executes the action (stop).",
            "warmupExplanation": "Robots follow simple 'IF this happens, THEN do that' rules. They do exactly what the rule says."
          },
          {
            "questionId": "l01_s08_q2",
            "question": "Can an Arduino guess what you want if you don't give it any code instructions?",
            "options": [
              "No, it can only follow instructions we give it",
              "Yes, it reads human minds",
              "Yes, it dreams on its own"
            ],
            "correctIndex": 0,
            "explanation": "Computers do not guess or read minds. They need clear instructions from us to know what to do!",
            "warmupExplanation": "Microcontrollers are loyal helpers, but they only do what our program code tells them to do."
          }
        ]
      },
      {
        "stepId": "l01_08_s02",
        "title": "Condition Logic: IF, THEN, ELSE",
        "type": "visualExplanation",
        "markdownContent": "A condition is like a fork in the path: YES follows one branch; NO follows the other. Each branch tells the output what to do."
      },
      {
        "stepId": "l01_08_s03",
        "title": "Interactive Decision Simulator",
        "type": "codeExperiment",
        "interactiveWidgetType": "decisionSimulator",
        "markdownContent": "Press the virtual button. Before each tap, predict whether the LED will be on or off."
      },
      {
        "stepId": "l01_08_s04",
        "title": "Decision Logic Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of robot decisions and IF/THEN logic!",
        "interactiveConfig": {
          "question": "In an IF/ELSE block, what code runs if the condition is FALSE?",
          "options": [
            "The code inside the ELSE branch",
            "The Arduino shuts down permanently",
            "All code runs backwards"
          ],
          "correctIndex": 0,
          "explanation": "When an IF condition evaluates to FALSE, execution branches into the ELSE statement.",
          "questions": [
            {
              "question": "In an IF/ELSE block, what code runs if the condition is FALSE?",
              "options": [
                "The code inside the ELSE branch",
                "The Arduino shuts down permanently",
                "All code runs backwards"
              ],
              "correctIndex": 0,
              "explanation": "When an IF condition evaluates to FALSE, execution branches into the ELSE statement."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Predict what an if/else rule makes an LED do.",
    "vocabulary": [
      {
        "term": "Condition",
        "pronunciation": "kun-DISH-un",
        "meaning": "A question the code checks before choosing an action."
      },
      {
        "term": "If/else",
        "pronunciation": "if / els",
        "meaning": "Code that chooses what to do for two different cases."
      }
    ]
  },
  {
    "id": "l01_09",
    "title": "Code to Hardware",
    "summary": "Now let's connect words in code to physical hardware pins!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l01_08"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s09",
        "title": "Code to Hardware",
        "type": "story",
        "markdownContent": "Code becomes instructions the board can run. On the Uno, the built-in L light is connected to pin 13. A program can tell that output to turn on or off.",
        "quickCheck": [
          {
            "questionId": "l01_s09_q1",
            "question": "In the command digitalWrite(13, HIGH);, what does the number 13 mean?",
            "options": [
              "Which pin number to turn on",
              "How many minutes to wait",
              "The robot's age"
            ],
            "correctIndex": 0,
            "explanation": "The number 13 tells the Arduino exactly which pin header to send electricity to!",
            "warmupExplanation": "Commands tell the board which pin to use. The number specifies the exact pin connection."
          },
          {
            "questionId": "l01_s09_q2",
            "question": "What does the word HIGH mean in digitalWrite(13, HIGH);?",
            "options": [
              "Turn power ON (+5V)",
              "Turn power OFF (0V)",
              "Lift the board up high"
            ],
            "correctIndex": 0,
            "explanation": "In digital code, HIGH means turn the power ON so current flows to your component!",
            "warmupExplanation": "Think of HIGH like flipping a switch ON. LOW means flipping the switch OFF."
          }
        ]
      },
      {
        "stepId": "l01_09_s02",
        "title": "How Text Turns Into Voltage",
        "type": "visualExplanation",
        "markdownContent": "Read the code as a tiny command: choose a pin, choose an output state. The board runs the uploaded program and changes the pin signal."
      },
      {
        "stepId": "l01_09_s03",
        "title": "Code Deconstruction Lab",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "Tap the parts of the code to see what each one controls. Then predict what the built-in L light will do."
      },
      {
        "stepId": "l01_09_s04",
        "title": "Code-to-Hardware Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of how code statements command electronic pins!",
        "interactiveConfig": {
          "question": "What happens if you forget the semicolon (;) at the end of a statement in C++?",
          "options": [
            "The compiler will report a syntax error and refuse to upload",
            "The Arduino will guess what you meant",
            "The pin will catch on fire"
          ],
          "correctIndex": 0,
          "explanation": "In C++, semicolons are mandatory statement terminators. Omitting one stops compilation.",
          "questions": [
            {
              "question": "What happens if you forget the semicolon (;) at the end of a statement in C++?",
              "options": [
                "The compiler will report a syntax error and refuse to upload",
                "The Arduino will guess what you meant",
                "The pin will catch on fire"
              ],
              "correctIndex": 0,
              "explanation": "In C++, semicolons are mandatory statement terminators. Omitting one stops compilation."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Connect a line of code to the pin or light it controls.",
    "vocabulary": [
      {
        "term": "Upload",
        "pronunciation": "UP-lohd",
        "meaning": "Send a program from a computer to the board."
      },
      {
        "term": "Output",
        "pronunciation": "OUT-put",
        "meaning": "A signal the board sends to control a part."
      }
    ]
  },
  {
    "id": "l01_10",
    "title": "Your First Engineering Experiment",
    "summary": "Great engineers don't just guess what happens—they use the Scientific Engineering Method:",
    "tier": "rookie",
    "estimatedMinutes": 8,
    "courseId": "lesson_01",
    "sortOrder": 10,
    "isOptional": false,
    "prerequisites": [
      "l01_09"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s10",
        "title": "Your First Engineering Experiment",
        "type": "story",
        "markdownContent": "Engineers test ideas. First predict what will happen. Then run one test, watch closely, and compare the result with your prediction.",
        "quickCheck": [
          {
            "questionId": "l01_s10_q1",
            "question": "What should an engineer do BEFORE running a test or experiment?",
            "options": [
              "Predict what they expect will happen",
              "Close their eyes and hope for the best",
              "Toss the board across the room"
            ],
            "correctIndex": 0,
            "explanation": "Making a thoughtful prediction helps you see if your experiment worked the way you expected!",
            "warmupExplanation": "Predicting means thinking ahead about what should happen before you run a test."
          },
          {
            "questionId": "l01_s10_q2",
            "question": "Where is the built-in test LED located on your Arduino Uno board?",
            "options": [
              "Connected to Pin 13, labeled with the letter 'L'",
              "Hidden inside the USB plug",
              "Underneath the wooden table"
            ],
            "correctIndex": 0,
            "explanation": "The built-in LED is right on the board next to Pin 13 and labeled 'L'!",
            "warmupExplanation": "The Arduino has a tiny light on the board labeled 'L' so you can test code without extra wires."
          }
        ]
      },
      {
        "stepId": "l01_10_s02",
        "title": "The Scientific Engineering Method",
        "type": "visualExplanation",
        "markdownContent": "A fair test changes one thing at a time. Write or say: “I thought ___. I tried ___. I noticed ___.”"
      },
      {
        "stepId": "l01_10_s03",
        "title": "Formulate Your Prediction & Test",
        "type": "physicalTask",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "Predict what the L light will do, run the virtual test, and compare what happened with your prediction."
      },
      {
        "stepId": "l01_10_s04",
        "title": "Engineering Method Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of experimental engineering methods!",
        "interactiveConfig": {
          "question": "Why is forming a prediction before running a test essential for engineers?",
          "options": [
            "It forces you to understand the logic and lets you verify if hardware behaves as expected",
            "It makes the computer run ten times faster",
            "It prevents the USB cable from being plugged in"
          ],
          "correctIndex": 0,
          "explanation": "Predicting outcome requires analyzing how code and circuit interface together, enabling meaningful verification.",
          "questions": [
            {
              "question": "Why is forming a prediction before running a test essential for engineers?",
              "options": [
                "It forces you to understand the logic and lets you verify if hardware behaves as expected",
                "It makes the computer run ten times faster",
                "It prevents the USB cable from being plugged in"
              ],
              "correctIndex": 0,
              "explanation": "Predicting outcome requires analyzing how code and circuit interface together, enabling meaningful verification."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Make a prediction, test it, and describe what happened.",
    "vocabulary": [
      {
        "term": "Predict",
        "pronunciation": "pree-DIKT",
        "meaning": "Say what you think will happen before a test."
      },
      {
        "term": "Observe",
        "pronunciation": "ub-ZURV",
        "meaning": "Carefully notice and record what happens."
      }
    ]
  },
  {
    "id": "l01_11",
    "title": "Basic Troubleshooting",
    "summary": "What happens when your circuit doesn't work?",
    "tier": "rookie",
    "estimatedMinutes": 8,
    "courseId": "lesson_01",
    "sortOrder": 11,
    "isOptional": false,
    "prerequisites": [
      "l01_10"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_s11",
        "title": "Basic Troubleshooting",
        "type": "story",
        "markdownContent": "When a light does not work, be a robot detective. Check power, check that the code pin matches the wire, then check the LED direction and ground.",
        "quickCheck": [
          {
            "questionId": "l01_s11_q1",
            "question": "If an LED light does not turn on, what is the best first thing to check?",
            "options": [
              "Check that wires are plugged into the right pins and firmly connected",
              "Throw all the parts into the trash",
              "Paint the wires with colorful glitter"
            ],
            "correctIndex": 0,
            "explanation": "Checking that wires are firmly connected to the correct pins fixes most electronics puzzles!",
            "warmupExplanation": "When something doesn't work, stay calm and check connections first: are wires in the right spots?"
          },
          {
            "questionId": "l01_s11_q2",
            "question": "If your code commands Pin 13, but your wire is plugged into Pin 8, what will happen?",
            "options": [
              "The part on Pin 8 will not receive the command",
              "The computer will turn into a pumpkin",
              "Pin 8 will automatically slide over to Pin 13"
            ],
            "correctIndex": 0,
            "explanation": "Code commands specific pins! If the wire is plugged into the wrong pin, the signal won't reach it.",
            "warmupExplanation": "Code and wires must match! If code commands Pin 13, the wire must be connected to Pin 13."
          }
        ]
      },
      {
        "stepId": "l01_11_s02",
        "title": "The Hardware Detective's Playbook",
        "type": "visualExplanation",
        "markdownContent": "Change one thing at a time. That helps you learn which fix solved the problem."
      },
      {
        "stepId": "l01_11_s03",
        "title": "Interactive Troubleshooting Bench",
        "type": "physicalTask",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "Solve the Silent LED Mystery. Find the pin mismatch, move the wire, and test the circuit again."
      },
      {
        "stepId": "l01_11_s04",
        "title": "Troubleshooting Master Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your hardware troubleshooting instincts and detective skills!",
        "interactiveConfig": {
          "question": "Why should an engineer change only ONE thing at a time when debugging a circuit?",
          "options": [
            "So you know exactly which change solved the problem or caused a new issue",
            "Because changing two wires makes the board explode",
            "To make the troubleshooting take longer"
          ],
          "correctIndex": 0,
          "explanation": "Changing one variable at a time isolate causes, ensuring clear and repeatable engineering solutions.",
          "questions": [
            {
              "question": "Why should an engineer change only ONE thing at a time when debugging a circuit?",
              "options": [
                "So you know exactly which change solved the problem or caused a new issue",
                "Because changing two wires makes the board explode",
                "To make the troubleshooting take longer"
              ],
              "correctIndex": 0,
              "explanation": "Changing one variable at a time isolate causes, ensuring clear and repeatable engineering solutions."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Use clues to find and fix one simple circuit problem.",
    "vocabulary": [
      {
        "term": "Troubleshoot",
        "pronunciation": "TRUB-ul-shoot",
        "meaning": "Check clues to find and fix a problem."
      },
      {
        "term": "Mismatch",
        "pronunciation": "MIS-match",
        "meaning": "Two things that should agree but do not."
      }
    ]
  },
  {
    "id": "l01_12",
    "title": "Hardware Safety & Board Care",
    "summary": "Learn essential lab safety rules: avoiding short circuits, proper USB handling, and protecting delicate microcontroller pins.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 12,
    "isOptional": false,
    "prerequisites": [
      "l01_11"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l01_12_s01",
        "title": "Lab Safety: Protecting Your Board",
        "type": "story",
        "markdownContent": "Before powering a circuit, check the wires, LED direction, and loose metal pieces. Use a resistor with an LED. Ask an adult before changing a powered circuit.",
        "quickCheck": [
          {
            "questionId": "l01_12_s01_q1",
            "question": "When should you move wires or plug in components on your breadboard?",
            "options": [
              "Always when the board is completely unplugged and powered OFF",
              "While uploading code rapidly",
              "While the motor is spinning at top speed"
            ],
            "correctIndex": 0,
            "explanation": "Wiring while unplugged prevents accidental short circuits from destroying sensitive components!",
            "warmupExplanation": "Always disconnect power before making circuit changes. Safety first!"
          },
          {
            "questionId": "l01_12_s01_q2",
            "question": "Why should you never place a powered Arduino board on a metal tabletop?",
            "options": [
              "The metal conducts electricity and shorts out the exposed pins on the bottom of the board",
              "The metal makes the board too cold to think",
              "Because boards get seasick"
            ],
            "correctIndex": 0,
            "explanation": "Conductive metal surfaces create accidental electrical bridges between solder joints, frying components.",
            "warmupExplanation": "Metal conducts electricity! Keep your Arduino on a wooden desk, rubber mat, or cardboard."
          }
        ]
      },
      {
        "stepId": "l01_12_s02",
        "title": "Understanding the Dreaded Short Circuit",
        "type": "visualExplanation",
        "interactiveWidgetType": "shortCircuitSafetyDiagram",
        "markdownContent": "A direct connection between power and ground can damage parts. Arduino pins are for small signals, not motors or other power-hungry parts.",
        "interactiveConfig": {
          "vcc": 5.0,
          "normalResistance": 220,
          "shortResistance": 0.1
        }
      },
      {
        "stepId": "l01_12_s03",
        "title": "Hands-On Safety Pre-Flight Inspection",
        "type": "physicalTask",
        "markdownContent": "Do the pre-flight scan: check the power path, part direction, and work area. Choose the safe setup.",
        "interactiveConfig": {
          "checklist": [
            "Power trace verified",
            "Component polarity checked",
            "Workbench cleared of metal debris"
          ]
        }
      },
      {
        "stepId": "l01_12_s04",
        "title": "Check Your Knowledge",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your hardware safety habits and lab best practices!",
        "interactiveConfig": {
          "question": "What happens in a short circuit?",
          "options": [
            "Power connects directly to Ground without enough resistance, causing high current and overheating",
            "The wires run out of electricity and freeze",
            "The computer turns into a robot"
          ],
          "correctIndex": 0,
          "explanation": "A short circuit creates a zero-resistance path from power to ground, causing high current and heating.",
          "questions": [
            {
              "question": "What happens in a short circuit?",
              "options": [
                "Power connects directly to Ground without enough resistance, causing high current and overheating",
                "The wires run out of electricity and freeze",
                "The computer turns into a robot"
              ],
              "correctIndex": 0,
              "explanation": "A short circuit creates a zero-resistance path from power to ground, causing high current and heating."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Spot unsafe wiring before powering a board.",
    "vocabulary": [
      {
        "term": "Current",
        "pronunciation": "KUR-unt",
        "meaning": "The flow of electric charge."
      },
      {
        "term": "Short circuit",
        "pronunciation": "short SUR-kit",
        "meaning": "An unintended path that can let too much current flow."
      }
    ]
  },
  {
    "id": "l01_13",
    "title": "The Arduino Family: Uno, Nano, and Mega",
    "summary": "Discover the different members of the Arduino board family: the standard Uno, breadboard-friendly Nano, and the pin-packed Mega 2560.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 13,
    "isOptional": false,
    "prerequisites": [
      "l01_12"
    ],
    "componentIds": [
      "comp_uno",
      "comp_nano",
      "comp_mega"
    ],
    "steps": [
      {
        "stepId": "l01_13_s01",
        "title": "Meet the Arduino Family",
        "type": "story",
        "markdownContent": "The Uno is a handy starter board. The Nano is smaller. The Mega has more pins. Choose by project size and the connections you need—not by the biggest number alone.",
        "quickCheck": [
          {
            "questionId": "l01_13_s01_q1",
            "question": "Why are there different sizes of Arduino boards like the Nano and Mega?",
            "options": [
              "Different robot projects require different physical sizes and pin numbers",
              "Because smaller boards only understand Spanish",
              "Because large boards can only be used outdoors"
            ],
            "correctIndex": 0,
            "explanation": "Different projects have different needs: a small rover needs a compact Nano, while an intricate robot with dozens of parts needs the Mega!",
            "warmupExplanation": "Think of shoes: you wouldn't wear heavy snow boots to run a race. Engineers choose the right board for the mission!"
          },
          {
            "questionId": "l01_13_s01_q2",
            "question": "Can code written for an Arduino Uno run on an Arduino Nano?",
            "options": [
              "Yes! Both use the same ATmega328P microcontroller chip and language",
              "No, you must rewrite everything from scratch",
              "Only on weekends"
            ],
            "correctIndex": 0,
            "explanation": "The Uno and Nano share the ATmega328P microcontroller core, so their code and pin commands are virtually identical!",
            "warmupExplanation": "The Nano is simply a shrunken Uno: same brain inside, just packed into a breadboard-sized body."
          }
        ]
      },
      {
        "stepId": "l01_13_s02",
        "title": "Comparing Board Architectures",
        "type": "visualExplanation",
        "interactiveWidgetType": "arduinoFamilyComparison",
        "markdownContent": "Different board versions can have different features. Check the board label and pin map before connecting parts.",
        "interactiveConfig": {
          "boards": [
            {
              "id": "comp_uno",
              "name": "Arduino Uno",
              "digitalPins": 14,
              "analogPins": 6,
              "formFactor": "Standard Shield",
              "breadboardFriendly": false
            },
            {
              "id": "comp_nano",
              "name": "Arduino Nano",
              "digitalPins": 14,
              "analogPins": 8,
              "formFactor": "DIP-30 Breadboard Module",
              "breadboardFriendly": true
            },
            {
              "id": "comp_mega",
              "name": "Arduino Mega 2560",
              "digitalPins": 54,
              "analogPins": 16,
              "formFactor": "Extended Board",
              "breadboardFriendly": false
            }
          ]
        }
      },
      {
        "stepId": "l01_13_s03",
        "title": "Hands-On: Choosing the Right Board",
        "type": "codeExperiment",
        "markdownContent": "Choose a board for each robot mission. Count the connections you need, then use the board-choice simulator. Servos and motors may need extra driver parts.",
        "interactiveConfig": {
          "testCases": [
            {
              "motors": 1,
              "sensors": 1,
              "recommended": "Arduino Nano"
            },
            {
              "motors": 6,
              "sensors": 8,
              "recommended": "Arduino Mega 2560"
            },
            {
              "motors": 2,
              "sensors": 2,
              "recommended": "Arduino Uno"
            }
          ]
        }
      },
      {
        "stepId": "l01_13_s04",
        "title": "Check Your Knowledge",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the Arduino board family and how to choose the right microcontroller for your robot mission!",
        "interactiveConfig": {
          "question": "Which Arduino board is designed with pin legs on the bottom so it can plug directly into a solderless breadboard?",
          "options": [
            "Arduino Nano",
            "Arduino Uno",
            "Arduino Mega 2560"
          ],
          "correctIndex": 0,
          "explanation": "The Arduino Nano has a compact dual-inline package (DIP) pinout that presses right into breadboard sockets.",
          "questions": [
            {
              "question": "Which Arduino board is designed with pin legs on the bottom so it can plug directly into a solderless breadboard?",
              "options": [
                "Arduino Nano",
                "Arduino Uno",
                "Arduino Mega 2560"
              ],
              "correctIndex": 0,
              "explanation": "The Arduino Nano has a compact dual-inline package (DIP) pinout that presses right into breadboard sockets."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Choose an Arduino board that fits a project’s size and connections.",
    "vocabulary": [
      {
        "term": "Board",
        "pronunciation": "bord",
        "meaning": "The circuit board that holds a microcontroller and connectors."
      },
      {
        "term": "Compare",
        "pronunciation": "kum-PAIR",
        "meaning": "Look at how things are alike and different."
      }
    ]
  },
  {
    "id": "l01_14",
    "title": "The IoT Revolution: ESP8266 and ESP32",
    "summary": "Explore the wireless powerhouses: the ESP8266 WiFi module and the dual-core ESP32 with built-in Bluetooth and high-speed processing.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 14,
    "isOptional": false,
    "prerequisites": [
      "l01_13"
    ],
    "componentIds": [
      "comp_esp8266",
      "comp_esp32",
      "comp_esp01"
    ],
    "steps": [
      {
        "stepId": "l01_14_s01",
        "title": "Cutting the Cable: The Wireless Revolution",
        "type": "story",
        "markdownContent": "Some ESP boards have Wi-Fi built in. ESP32 boards may also support Bluetooth. Features and pins vary by board, so check its pin map before wiring.",
        "quickCheck": [
          {
            "questionId": "l01_14_s01_q1",
            "question": "What wireless feature is built into many ESP boards?",
            "options": [
              "Wi-Fi",
              "A bigger battery",
              "A screen"
            ],
            "correctIndex": 0,
            "explanation": "Many ESP boards include Wi-Fi. Features vary by board.",
            "warmupExplanation": "A standard Arduino Uno needs external add-on shields for wireless, while ESP chips have radios built right inside the chip."
          },
          {
            "questionId": "l01_14_s01_q2",
            "question": "How does the clock speed of an ESP32 (up to 240 MHz) compare to an Arduino Uno (16 MHz)?",
            "options": [
              "The ESP32 is much faster (over 10 times the processor speed)",
              "The ESP32 is much slower",
              "They are the exact same speed"
            ],
            "correctIndex": 0,
            "explanation": "At 240 MHz with dual 32-bit cores, the ESP32 crunches numbers up to 15 times faster than an 8-bit Arduino Uno running at 16 MHz!",
            "warmupExplanation": "The Uno is like a trusty bicycle; the ESP32 is like an electric sports car."
          }
        ]
      },
      {
        "stepId": "l01_14_s02",
        "title": "ESP8266 vs. ESP32: Inside the Silicon",
        "type": "visualExplanation",
        "interactiveWidgetType": "espChipComparison",
        "markdownContent": "An ESP board can connect a project to a network. You do not need to memorize chip speeds or pin counts yet.",
        "interactiveConfig": {
          "chips": [
            {
              "id": "comp_esp8266",
              "name": "ESP8266",
              "wifi": true,
              "bluetooth": false,
              "cores": 1,
              "clockSpeedMhz": 80
            },
            {
              "id": "comp_esp32",
              "name": "ESP32",
              "wifi": true,
              "bluetooth": true,
              "cores": 2,
              "clockSpeedMhz": 240
            }
          ]
        }
      },
      {
        "stepId": "l01_14_s03",
        "title": "IoT Code Architecture: Connecting to Wi-Fi",
        "type": "codeExperiment",
        "markdownContent": "Watch the Wi-Fi connection simulator. In a real project, the board needs the right library, network name, and password. Keep real passwords private.",
        "interactiveConfig": {
          "status": "connected",
          "mockIp": "192.168.1.142"
        }
      },
      {
        "stepId": "l01_14_s04",
        "title": "Check Your Knowledge",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of the wireless microcontroller revolution with ESP8266 and ESP32!",
        "interactiveConfig": {
          "question": "Which microcontroller chip has BOTH Wi-Fi and Bluetooth radios built directly inside it?",
          "options": [
            "ESP32",
            "Arduino Uno",
            "ESP8266"
          ],
          "correctIndex": 0,
          "explanation": "The ESP32 features integrated 2.4 GHz Wi-Fi and dual-mode Bluetooth (Classic + BLE) on a single silicon chip.",
          "questions": [
            {
              "question": "Which microcontroller chip has BOTH Wi-Fi and Bluetooth radios built directly inside it?",
              "options": [
                "ESP32",
                "Arduino Uno",
                "ESP8266"
              ],
              "correctIndex": 0,
              "explanation": "The ESP32 features integrated 2.4 GHz Wi-Fi and dual-mode Bluetooth (Classic + BLE) on a single silicon chip."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Recognize that ESP boards can add wireless features to a project.",
    "vocabulary": [
      {
        "term": "Wireless",
        "pronunciation": "WIRE-less",
        "meaning": "Sending information without a cable."
      },
      {
        "term": "Wi-Fi",
        "pronunciation": "WHY-fye",
        "meaning": "A way for devices to connect to a network without wires."
      }
    ]
  },
  {
    "id": "l01_15",
    "title": "Voltage Frontiers: 5V vs. 3.3V Logic Safety",
    "summary": "Master the #1 rule of hardware protection: understanding the difference between 5V and 3.3V logic levels and how to prevent frying sensitive chips.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_01",
    "sortOrder": 15,
    "isOptional": false,
    "prerequisites": [
      "l01_14"
    ],
    "componentIds": [
      "comp_uno",
      "comp_esp32"
    ],
    "steps": [
      {
        "stepId": "l01_15_s01",
        "title": "The Golden Rule of Voltage Protection",
        "type": "story",
        "markdownContent": "Some boards use 5V signals; others use 3.3V. A 5V output can be unsafe for a 3.3V input. Check the labels and use the right protection before connecting them.",
        "quickCheck": [
          {
            "questionId": "l01_15_s01_q1",
            "question": "Which logic-voltage family does the Arduino Uno use?",
            "options": [
              "5V logic",
              "3.3V logic",
              "120V power"
            ],
            "correctIndex": 0,
            "explanation": "The Uno is designed for 5V logic. A HIGH is a logic state, not a promise of exactly 5V.",
            "warmupExplanation": "The Uno operates on 5V logic, the classic standard for robotics education."
          },
          {
            "questionId": "l01_15_s01_q2",
            "question": "What happens if you connect a 5V output wire directly to an unprotected 3.3V input pin on a modern radio chip?",
            "options": [
              "The excess voltage can overheat and destroy the sensitive 3.3V silicon chip",
              "The chip grows stronger and faster",
              "Nothing at all happens"
            ],
            "correctIndex": 0,
            "explanation": "3.3V chips are not designed for 5V input pressures. Overvoltage destroys the internal transistor gates!",
            "warmupExplanation": "Imagine filling a small water balloon with a firehose: too much pressure pops the balloon!"
          }
        ]
      },
      {
        "stepId": "l01_15_s02",
        "title": "Bridging the Kingdoms: Voltage Shifting",
        "type": "visualExplanation",
        "interactiveWidgetType": "voltageLevelShiftDiagram",
        "markdownContent": "A level shifter or a correctly wired resistor divider can protect a 3.3V input from a 5V signal. Explore the safe connection in the diagram; detailed resistor math is for a later lesson.",
        "interactiveConfig": {
          "r1Ohms": 1000,
          "r2Ohms": 2000,
          "inputVoltage": 5.0,
          "expectedOutput": 3.33
        }
      },
      {
        "stepId": "l01_15_s03",
        "title": "Testing Logic Compatibility in Code",
        "type": "codeExperiment",
        "markdownContent": "Use the simulator to identify the unsafe connection and choose a safer way to connect the boards.",
        "interactiveConfig": {
          "safeDirection": "3.3V -> 5V",
          "dangerDirection": "5V -> 3.3V (Needs Shifter)"
        }
      },
      {
        "stepId": "l01_15_s04",
        "title": "Check Your Knowledge",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of 5V vs 3.3V voltage safety and logic level shifting!",
        "interactiveConfig": {
          "question": "Which combination is dangerous and requires a voltage divider or level shifter?",
          "options": [
            "Sending a 5V output signal directly into a 3.3V microcontroller input pin",
            "Sending a 3.3V output signal into a 5V Arduino Uno input pin",
            "Connecting two Ground wires together"
          ],
          "correctIndex": 0,
          "explanation": "5V output into a 3.3V input exposes the 3.3V chip to overvoltage, requiring a level shifter or voltage divider.",
          "questions": [
            {
              "question": "Which combination is dangerous and requires a voltage divider or level shifter?",
              "options": [
                "Sending a 5V output signal directly into a 3.3V microcontroller input pin",
                "Sending a 3.3V output signal into a 5V Arduino Uno input pin",
                "Connecting two Ground wires together"
              ],
              "correctIndex": 0,
              "explanation": "5V output into a 3.3V input exposes the 3.3V chip to overvoltage, requiring a level shifter or voltage divider."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Identify when a 5V signal needs protection before reaching a 3.3V input.",
    "vocabulary": [
      {
        "term": "Voltage",
        "pronunciation": "VOHL-tij",
        "meaning": "The electrical push measured in volts."
      },
      {
        "term": "Level shifter",
        "pronunciation": "LEV-ul SHIFT-er",
        "meaning": "A part that changes a signal voltage to a safer level."
      }
    ]
  },
  {
    "id": "l01_16",
    "title": "Course 1 Review & Microcontroller Master Challenge",
    "summary": "You have completed your comprehensive tour of the microcontroller universe! Put on your detective hat and prove your skills in the Grand Capstone Exam.",
    "tier": "rookie",
    "estimatedMinutes": 8,
    "courseId": "lesson_01",
    "sortOrder": 16,
    "isOptional": false,
    "prerequisites": [
      "l01_15"
    ],
    "componentIds": [
      "comp_uno",
      "comp_nano",
      "comp_mega",
      "comp_esp32",
      "comp_esp8266"
    ],
    "steps": [
      {
        "stepId": "l01_16_s01",
        "title": "Course 1 Master Recap",
        "type": "story",
        "markdownContent": "You have explored boards, signals, circuits, code, and safety. Now use those ideas to help a robot choose a board and respond to an input.",
        "quickCheck": [
          {
            "questionId": "l01_16_s01_q1",
            "question": "What is the main role of a microcontroller development board in robotics?",
            "options": [
              "To act as the brain reading sensors and controlling outputs",
              "To serve as a heavy paperweight",
              "To play loud music like a radio"
            ],
            "correctIndex": 0,
            "explanation": "The microcontroller is the brain of your robot, taking in sensor data and commanding motors and lights!",
            "warmupExplanation": "Remember our main big idea: the microcontroller board is the brain that brings robots to life."
          },
          {
            "questionId": "l01_16_s01_q2",
            "question": "Why do we take quizzes and challenges at the end of a lesson?",
            "options": [
              "To celebrate what we learned and prove our new skills",
              "To erase our memory of what we did",
              "To lose points and start over"
            ],
            "correctIndex": 0,
            "explanation": "Challenges help review key concepts, celebrate your progress, and earn XP!",
            "warmupExplanation": "Reviews help lock in your new skills and show how much you've learned as a young engineer."
          }
        ]
      },
      {
        "stepId": "l01_16_s02",
        "title": "Grand Monster Lab Architecture Review",
        "type": "visualExplanation",
        "markdownContent": "Remember the path: input → code → output. Check power and ground, then make sure your parts are safe for the board.",
        "interactiveConfig": {
          "boardsCovered": [
            "comp_uno",
            "comp_nano",
            "comp_mega",
            "comp_esp32",
            "comp_esp8266"
          ]
        }
      },
      {
        "stepId": "l01_16_s03",
        "title": "Mini Capstone Inspection Challenge",
        "type": "physicalTask",
        "interactiveWidgetType": "boardLabelDragDrop",
        "markdownContent": "Complete the board-inspection challenge. Explain one choice, then answer a short review question about a skill you practiced.",
        "interactiveConfig": {
          "targets": [
            {
              "id": "usb",
              "label": "USB Connection",
              "hint": "Silver port linking to PC for code upload & 5V power"
            },
            {
              "id": "dc_jack",
              "label": "DC Power Barrel Jack",
              "hint": "Black barrel jack for mobile battery packs"
            },
            {
              "id": "digital_pins",
              "label": "Digital Pins (0–13)",
              "hint": "Header pins for HIGH/LOW binary signals"
            },
            {
              "id": "analog_pins",
              "label": "Analog Pins (A0–A5)",
              "hint": "Header pins for smooth continuous analog signals"
            }
          ]
        }
      },
      {
        "stepId": "l01_16_s04",
        "title": "Course 1 Final Graduation Quiz",
        "type": "quizCheckpoint",
        "markdownContent": "Answer these graduation questions to complete Course 1 and earn your Master Rookie Engineer XP!",
        "interactiveConfig": {
          "question": "What is the Arduino Uno?",
          "options": [
            "A microcontroller development board that acts as a robot brain",
            "A mechanical toy car",
            "A computer monitor"
          ],
          "correctIndex": 0,
          "explanation": "The Arduino Uno is a microcontroller development board that acts as the brain for your robot projects.",
          "questions": [
            {
              "question": "What is the Arduino Uno?",
              "options": [
                "A microcontroller development board that acts as a robot brain",
                "A mechanical toy car",
                "A computer monitor"
              ],
              "correctIndex": 0,
              "explanation": "The Arduino Uno is a microcontroller development board that acts as the brain for your robot projects."
            }
          ]
        }
      }
    ],
    "xpReward": 25,
    "learningGoal": "Use course ideas to inspect a board and explain a simple design choice.",
    "vocabulary": [
      {
        "term": "Review",
        "pronunciation": "ree-VYOO",
        "meaning": "Look again at ideas you have already learned."
      },
      {
        "term": "Challenge",
        "pronunciation": "CHAL-inj",
        "meaning": "A task that lets you use what you know."
      }
    ]
  },
  {
    "id": "cf_01",
    "title": "What Is Code?",
    "summary": "Learn what programs are and how they execute top-to-bottom.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 1,
    "isOptional": true,
    "prerequisites": [
      "lesson_01"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_01_s01",
        "title": "What Are Programs?",
        "type": "story",
        "markdownContent": "Programs are instructions a computer follows. Just like a recipe tells a chef how to bake a cake, a program tells a computer what to do.",
        "quickCheck": [
          {
            "questionId": "qc_cf_01_s01_q1",
            "question": "What tells a computer or robot what actions to perform?",
            "options": [
              "A set of instructions called code or a program",
              "A coat of colorful paint",
              "A battery charging cord"
            ],
            "correctIndex": 0,
            "explanation": "Computers follow written instructions called code or programs to know what actions to take!",
            "warmupExplanation": "Just like a recipe tells a baker how to make cookies, computer instructions tell machines what to do."
          },
          {
            "questionId": "qc_cf_01_s01_q2",
            "question": "In what order do computer programs usually follow instructions?",
            "options": [
              "One step at a time from top to bottom",
              "Backwards from bottom to top",
              "Completely at random"
            ],
            "correctIndex": 0,
            "explanation": "Programs execute sequentially, running one instruction after another from top to bottom!",
            "warmupExplanation": "When you read a book or follow a recipe, you read line by line from top to bottom."
          }
        ]
      },
      {
        "stepId": "cf_01_s02",
        "title": "Statements",
        "type": "story",
        "markdownContent": "A single instruction in code is called a statement. In Arduino (C++), every statement must end in a semicolon `;`."
      },
      {
        "stepId": "cf_01_s03",
        "title": "Top-to-Bottom Flow",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Programs run top-to-bottom, one statement at a time. The computer does exactly what you tell it—nothing more."
      },
      {
        "stepId": "cf_01_s04",
        "title": "Deconstruct a Program",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "Let's look at a simple program and break it down into statements.",
        "interactiveConfig": {
          "codeSnippet": "digitalWrite(13, HIGH);\ndelay(1000);\ndigitalWrite(13, LOW);"
        }
      },
      {
        "stepId": "cf_01_s05",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about programs and statements.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is a program?",
              "options": [
                "A random string of text",
                "Instructions a computer follows",
                "A physical component"
              ],
              "correctIndex": 1,
              "explanation": "A program is a set of instructions a computer follows to perform a task."
            },
            {
              "question": "What must every statement end with in C++?",
              "options": [
                ".",
                ",",
                ";"
              ],
              "correctIndex": 2,
              "explanation": "Every statement must end with a semicolon."
            },
            {
              "question": "How do programs run?",
              "options": [
                "Bottom-to-top",
                "Randomly",
                "Top-to-bottom"
              ],
              "correctIndex": 2,
              "explanation": "Programs execute sequentially from top to bottom."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_02",
    "title": "Variables",
    "summary": "Learn how to store and change data using variables.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 2,
    "isOptional": true,
    "prerequisites": [
      "cf_01"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_02_s01",
        "title": "What is a Variable?",
        "type": "story",
        "markdownContent": "A variable is like a named box that holds a value. You can read what's in the box, or change it.",
        "quickCheck": [
          {
            "questionId": "qc_cf_02_s01_q1",
            "question": "If you need to keep track of a robot's score or speed, where can your program store it?",
            "options": [
              "In a named memory container called a variable",
              "In a cardboard shipping box",
              "On the floor"
            ],
            "correctIndex": 0,
            "explanation": "Variables are named storage containers in memory that hold numbers, words, or true/false values!",
            "warmupExplanation": "Think of a variable as a labeled storage box where you keep a number until you need to change or read it."
          },
          {
            "questionId": "qc_cf_02_s01_q2",
            "question": "Can the value stored inside a variable change while a program is running?",
            "options": [
              "Yes, variables can be updated whenever needed",
              "No, variables are permanently carved into stone",
              "Only if the computer is turned off"
            ],
            "correctIndex": 0,
            "explanation": "Variables are variable—they can be updated, counted up, or replaced with new values whenever needed!",
            "warmupExplanation": "The word variable comes from vary, which means change! A score can go from 0 to 10 as you play."
          }
        ]
      },
      {
        "stepId": "cf_02_s02",
        "title": "Declaring Variables",
        "type": "story",
        "markdownContent": "To use a variable, you must declare its type and name: `int age = 10;`. Common types include `int` for integers, `float` for decimals, `bool` for true/false, and `String` for text."
      },
      {
        "stepId": "cf_02_s03",
        "title": "Why Variables Matter",
        "type": "story",
        "markdownContent": "Variables let you store sensor readings, keep score, or count how many times an event has happened."
      },
      {
        "stepId": "cf_02_s04",
        "title": "Deconstruct a Variable Declaration",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "Inspect `int ledPin = 13;` token by token.",
        "interactiveConfig": {
          "codeSnippet": "int ledPin = 13;"
        }
      },
      {
        "stepId": "cf_02_s05",
        "title": "Predict the Variable Value",
        "type": "codeExperiment",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "What is the value of `x` after these assignments?",
        "interactiveConfig": {
          "codeSnippet": "int x = 5;\nx = x + 3;"
        }
      },
      {
        "stepId": "cf_02_s06",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about variables.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is a variable?",
              "options": [
                "A named box that holds a value",
                "A type of sensor",
                "A function"
              ],
              "correctIndex": 0,
              "explanation": "A variable stores information for your program to use."
            },
            {
              "question": "Which type holds true/false?",
              "options": [
                "int",
                "bool",
                "String"
              ],
              "correctIndex": 1,
              "explanation": "The bool type holds boolean true or false values."
            },
            {
              "question": "What happens when you reassign a variable?",
              "options": [
                "It holds both values",
                "It crashes",
                "The old value is replaced"
              ],
              "correctIndex": 2,
              "explanation": "Assigning a new value overwrites the old value in the box."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_03",
    "title": "Operators and Decisions",
    "summary": "Learn how your program can make decisions based on conditions.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 3,
    "isOptional": true,
    "prerequisites": [
      "cf_02"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_03_s01",
        "title": "Operators",
        "type": "story",
        "markdownContent": "You can use arithmetic operators like `+`, `-`, `*`, and `/` to calculate values. Comparison operators like `==`, `!=`, `<`, `>`, `<=`, `>=` compare values and result in `true` or `false`.",
        "quickCheck": [
          {
            "questionId": "qc_cf_03_s01_q1",
            "question": "What type of variable would you use to store a whole counting number like 5 or 42?",
            "options": [
              "An integer (int)",
              "A picture file",
              "A musical song"
            ],
            "correctIndex": 0,
            "explanation": "In C++ and Arduino, the int type stores whole integer numbers without decimals!",
            "warmupExplanation": "Counting fingers or items uses whole numbers: 1, 2, 3... In code, these are called integers (int)."
          },
          {
            "questionId": "qc_cf_03_s01_q2",
            "question": "What type of variable represents a simple YES/NO or TRUE/FALSE decision?",
            "options": [
              "A boolean (bool)",
              "A decimal float",
              "A long paragraph"
            ],
            "correctIndex": 0,
            "explanation": "Boolean (bool) variables can only hold two states: true or false!",
            "warmupExplanation": "Is the light on or off? That is a true/false question. In programming, true/false values are booleans."
          }
        ]
      },
      {
        "stepId": "cf_03_s02",
        "title": "Making Decisions with If",
        "type": "story",
        "markdownContent": "An `if` statement lets your code make decisions: `if (condition) { do this; }`. It only runs the block if the condition is true."
      },
      {
        "stepId": "cf_03_s03",
        "title": "If / Else",
        "type": "story",
        "markdownContent": "Use `else` to specify what happens when the condition is false."
      },
      {
        "stepId": "cf_03_s04",
        "title": "Decision Simulator",
        "type": "visualExplanation",
        "interactiveWidgetType": "decisionSimulator",
        "markdownContent": "Press the virtual button and watch the if/else branch execute.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_03_s05",
        "title": "Predict Output",
        "type": "codeExperiment",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "Predict the output of this if/else chain.",
        "interactiveConfig": {
          "codeSnippet": "int temp = 30;\nif (temp > 25) {\n  digitalWrite(13, HIGH);\n} else {\n  digitalWrite(13, LOW);\n}"
        }
      },
      {
        "stepId": "cf_03_s06",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about operators and decisions.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Which operator checks if two values are equal?",
              "options": [
                "=",
                "==",
                "!="
              ],
              "correctIndex": 1,
              "explanation": "== compares values, while = assigns a value."
            },
            {
              "question": "What does an `if` statement do?",
              "options": [
                "Repeats code",
                "Executes code only if a condition is true",
                "Creates a variable"
              ],
              "correctIndex": 1,
              "explanation": "If statements create decision branches based on conditions."
            },
            {
              "question": "When does the `else` block run?",
              "options": [
                "Always",
                "When the if condition is true",
                "When the if condition is false"
              ],
              "correctIndex": 2,
              "explanation": "Else provides a fallback when the initial condition is not met."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_04",
    "title": "Functions",
    "summary": "Learn how to reuse code using functions.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 4,
    "isOptional": true,
    "prerequisites": [
      "cf_03"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_04_s01",
        "title": "What is a Function?",
        "type": "story",
        "markdownContent": "A function is a named block of reusable instructions. It helps avoid repeating code and keeps your program organized.",
        "quickCheck": [
          {
            "questionId": "qc_cf_04_s01_q1",
            "question": "What does a computer use to make choices like \"IF it is raining, THEN open umbrella\"?",
            "options": [
              "Conditional IF statements",
              "A magic crystal ball",
              "Random guessing"
            ],
            "correctIndex": 0,
            "explanation": "Conditional IF statements check if a condition is true before running specific code!",
            "warmupExplanation": "You make decisions all day: IF bedtime, THEN sleep! Computers use the exact same IF logic."
          },
          {
            "questionId": "qc_cf_04_s01_q2",
            "question": "What word specifies what a computer should do when an IF condition is FALSE?",
            "options": [
              "ELSE",
              "NEVER",
              "STOP_FOREVER"
            ],
            "correctIndex": 0,
            "explanation": "The ELSE block gives alternative instructions to run when the IF condition isn't met!",
            "warmupExplanation": "IF sunny wear sunglasses, ELSE wear a raincoat! ELSE is the backup plan when IF is false."
          }
        ]
      },
      {
        "stepId": "cf_04_s02",
        "title": "Calling Functions",
        "type": "story",
        "markdownContent": "You use a function by calling its name followed by parentheses: `blink();`. Sometimes you pass parameters, like `digitalWrite(13, HIGH);`."
      },
      {
        "stepId": "cf_04_s03",
        "title": "Return Values",
        "type": "story",
        "markdownContent": "Some functions give back a result (like `digitalRead()`). If a function doesn't give anything back, it uses the keyword `void`."
      },
      {
        "stepId": "cf_04_s04",
        "title": "Deconstruct a Function Call",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "Deconstruct `digitalWrite(13, HIGH)` token by token.",
        "interactiveConfig": {
          "codeSnippet": "digitalWrite(13, HIGH);"
        }
      },
      {
        "stepId": "cf_04_s05",
        "title": "Execution Speed Visualizer",
        "type": "visualExplanation",
        "interactiveWidgetType": "executionSpeedVisualizer",
        "markdownContent": "Watch how calling a function executes its block of code.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_04_s06",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about functions.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is a function?",
              "options": [
                "A named block of reusable instructions",
                "A type of variable",
                "A physical component"
              ],
              "correctIndex": 0,
              "explanation": "Functions bundle instructions so they can be reused easily."
            },
            {
              "question": "What does `void` mean?",
              "options": [
                "The function is broken",
                "The function returns no value",
                "The function takes no parameters"
              ],
              "correctIndex": 1,
              "explanation": "Void indicates that the function performs an action but doesn't return a data value."
            },
            {
              "question": "What are the values passed inside the parentheses called?",
              "options": [
                "Variables",
                "Operators",
                "Parameters"
              ],
              "correctIndex": 2,
              "explanation": "Parameters (or arguments) provide data to the function."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_05",
    "title": "Loops",
    "summary": "Learn how to repeat actions in code.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 5,
    "isOptional": true,
    "prerequisites": [
      "cf_04"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_05_s01",
        "title": "Why Loops?",
        "type": "story",
        "markdownContent": "Loops let you repeat actions without copying code. If you want an LED to blink 10 times, you don't need 10 blink commands.",
        "quickCheck": [
          {
            "questionId": "qc_cf_05_s01_q1",
            "question": "If a robot needs to blink a light 100 times, what coding tool avoids writing 100 lines of code?",
            "options": [
              "A loop (such as a for or while loop)",
              "Copying and pasting 1000 pages",
              "Turning off the robot"
            ],
            "correctIndex": 0,
            "explanation": "Loops repeat blocks of code automatically until a stopping condition is met!",
            "warmupExplanation": "Instead of saying step, step, step 100 times, you say repeat 100 times: take a step!"
          },
          {
            "questionId": "qc_cf_05_s01_q2",
            "question": "What happens if a loop has no condition telling it when to stop?",
            "options": [
              "It becomes an infinite loop and repeats forever",
              "The computer turns into wood",
              "The program runs backwards"
            ],
            "correctIndex": 0,
            "explanation": "A loop without a stopping condition repeats continuously—just like Arduino's loop() function!",
            "warmupExplanation": "A merry-go-round keeps spinning until someone stops it. Loops without stop conditions run forever."
          }
        ]
      },
      {
        "stepId": "cf_05_s02",
        "title": "For Loops",
        "type": "story",
        "markdownContent": "A `for` loop counts. Example: `for (int i = 0; i < 5; i++) { ... }` runs 5 times, with `i` acting as a counter."
      },
      {
        "stepId": "cf_05_s03",
        "title": "While Loops",
        "type": "story",
        "markdownContent": "A `while` loop runs as long as a condition is true. It can be infinite if the condition never becomes false. Arduino's main `loop()` is an intentional infinite loop!"
      },
      {
        "stepId": "cf_05_s04",
        "title": "Visualize a Loop",
        "type": "visualExplanation",
        "interactiveWidgetType": "executionSpeedVisualizer",
        "markdownContent": "Visualize a `for` loop counting from 0 to 4.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_05_s05",
        "title": "Predict Loop Behavior",
        "type": "codeExperiment",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "How many times will this loop run?",
        "interactiveConfig": {
          "codeSnippet": "for (int i = 1; i <= 3; i++) {\n  blink();\n}"
        }
      },
      {
        "stepId": "cf_05_s06",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about loops.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Why do we use loops?",
              "options": [
                "To slow down the program",
                "To repeat actions without writing duplicate code",
                "To make decisions"
              ],
              "correctIndex": 1,
              "explanation": "Loops automate repetition, keeping code clean and short."
            },
            {
              "question": "What is `i` in a typical `for` loop?",
              "options": [
                "A function",
                "A counter variable",
                "An error"
              ],
              "correctIndex": 1,
              "explanation": "The counter variable tracks how many times the loop has run."
            },
            {
              "question": "What kind of loop does Arduino use continuously?",
              "options": [
                "A finite for loop",
                "An infinite loop",
                "It doesn't use loops"
              ],
              "correctIndex": 1,
              "explanation": "The main loop() function repeats forever to keep processing."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_06",
    "title": "Arduino Code Basics",
    "summary": "Understand the complete structure of an Arduino sketch.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 6,
    "isOptional": true,
    "prerequisites": [
      "cf_05"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_06_s01",
        "title": "Arduino Sketch Structure",
        "type": "story",
        "markdownContent": "An Arduino sketch has a specific structure. It starts with `#include` for libraries, then global variables.",
        "quickCheck": [
          {
            "questionId": "qc_cf_06_s01_q1",
            "question": "What is a function in programming?",
            "options": [
              "A named reusable block of code that performs a specific job",
              "A physical screw on the board",
              "A broken wire"
            ],
            "correctIndex": 0,
            "explanation": "Functions package instructions under a single name so you can call them whenever needed!",
            "warmupExplanation": "Think of a function like a spell or recipe named makeToast(). Whenever you say makeToast(), it runs the steps!"
          },
          {
            "questionId": "qc_cf_06_s01_q2",
            "question": "Why do programmers break large programs into smaller functions?",
            "options": [
              "To make code organized, easier to read, and reusable",
              "To make files heavier",
              "Because computers dislike short words"
            ],
            "correctIndex": 0,
            "explanation": "Functions keep programs organized and allow code to be reused without duplicating lines!",
            "warmupExplanation": "Organizing toys into labeled bins makes them easy to find and play with again."
          }
        ]
      },
      {
        "stepId": "cf_06_s02",
        "title": "Setup",
        "type": "story",
        "markdownContent": "The `setup()` function runs exactly once when power is applied. It's used for configurations like `pinMode()`."
      },
      {
        "stepId": "cf_06_s03",
        "title": "Loop",
        "type": "story",
        "markdownContent": "The `loop()` function runs repeatedly, forever. It contains the main behavior of your program, using functions like `digitalWrite()` and `delay()`."
      },
      {
        "stepId": "cf_06_s04",
        "title": "Compilation & Uploading",
        "type": "story",
        "markdownContent": "Code is compiled (translated to machine instructions) and uploaded to the board via USB."
      },
      {
        "stepId": "cf_06_s05",
        "title": "IDE Lifecycle",
        "type": "visualExplanation",
        "interactiveWidgetType": "ideLifecycleSimulator",
        "markdownContent": "Watch the setup() and then loop() cycle.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_06_s06",
        "title": "Deconstruct Blink",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "Deconstruct the full Blink sketch.",
        "interactiveConfig": {
          "codeSnippet": "void setup() {\n  pinMode(13, OUTPUT);\n}\nvoid loop() {\n  digitalWrite(13, HIGH);\n  delay(1000);\n  digitalWrite(13, LOW);\n  delay(1000);\n}"
        }
      },
      {
        "stepId": "cf_06_s07",
        "title": "Compilation Pipeline",
        "type": "visualExplanation",
        "interactiveWidgetType": "compilationPipelineSimulator",
        "markdownContent": "Simulate the compilation process.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_06_s08",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about the sketch structure.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How many times does `setup()` run?",
              "options": [
                "Never",
                "Once",
                "Forever"
              ],
              "correctIndex": 1,
              "explanation": "Setup runs once at startup to initialize settings."
            },
            {
              "question": "Where should you put code that needs to repeat continuously?",
              "options": [
                "setup()",
                "loop()",
                "At the top of the file"
              ],
              "correctIndex": 1,
              "explanation": "The loop() function repeats its contents indefinitely."
            },
            {
              "question": "What does compiling do?",
              "options": [
                "Turns on the Arduino",
                "Translates code into machine instructions",
                "Fixes your wiring"
              ],
              "correctIndex": 1,
              "explanation": "Compilation translates human-readable C++ into binary machine code."
            },
            {
              "question": "What is a global variable?",
              "options": [
                "A variable inside loop()",
                "A variable accessible everywhere",
                "An error"
              ],
              "correctIndex": 1,
              "explanation": "Variables declared outside of functions are global and can be used anywhere in the sketch."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_07",
    "title": "Read and Predict Code",
    "summary": "Learn how to read, predict, and debug code.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 7,
    "isOptional": true,
    "prerequisites": [
      "cf_06"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_07_s01",
        "title": "Reading Unfamiliar Code",
        "type": "story",
        "markdownContent": "Look for structure first: identify the variables, the `setup()` function, and the `loop()`. Trace execution step by step.",
        "quickCheck": [
          {
            "questionId": "qc_cf_07_s01_q1",
            "question": "When a program doesn't do what you expect, what do engineers call that mistake?",
            "options": [
              "A bug",
              "A monster byte",
              "A ghost"
            ],
            "correctIndex": 0,
            "explanation": "Flaws or mistakes in code logic are famously known as software bugs!",
            "warmupExplanation": "Even master engineers write bugs! Finding and fixing bugs is called debugging."
          },
          {
            "questionId": "qc_cf_07_s01_q2",
            "question": "What is the best way to debug a program that isn't working?",
            "options": [
              "Test one small piece at a time and read error messages",
              "Smash the keyboard",
              "Delete the whole computer"
            ],
            "correctIndex": 0,
            "explanation": "Testing small sections and reading compiler error messages helps pinpoint bugs quickly!",
            "warmupExplanation": "Detectives look for clues one by one. Debugging means finding clues to fix the code."
          }
        ]
      },
      {
        "stepId": "cf_07_s02",
        "title": "Spotting Errors",
        "type": "story",
        "markdownContent": "A syntax error (missing `;`, wrong bracket) stops code from compiling. A logic error (a condition that is never true) compiles but behaves incorrectly."
      },
      {
        "stepId": "cf_07_s03",
        "title": "Scientific Engineering Method",
        "type": "story",
        "markdownContent": "Read the code → Predict what it will do → Test it → Observe the results → Explain why it happened."
      },
      {
        "stepId": "cf_07_s04",
        "title": "Syntax Error Debugger",
        "type": "codeExperiment",
        "interactiveWidgetType": "syntaxErrorDebugger",
        "markdownContent": "Find and fix syntax errors in this code.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_07_s05",
        "title": "Engineering Prediction",
        "type": "codeExperiment",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "Predict the LED state based on this code logic.",
        "interactiveConfig": {
          "codeSnippet": "int count = 0;\nvoid loop() {\n  count++;\n  if (count > 5) {\n    digitalWrite(13, HIGH);\n  }\n}"
        }
      },
      {
        "stepId": "cf_07_s06",
        "title": "Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you learned about code reading and debugging.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is a syntax error?",
              "options": [
                "A mistake in the wiring",
                "A typo or grammar mistake in the code",
                "The code doing the wrong thing"
              ],
              "correctIndex": 1,
              "explanation": "Syntax errors violate the rules of the programming language."
            },
            {
              "question": "What is a logic error?",
              "options": [
                "Code that won't compile",
                "A mistake in the wiring",
                "Code that compiles but does the wrong thing"
              ],
              "correctIndex": 2,
              "explanation": "Logic errors occur when the code is grammatically correct but logically flawed."
            },
            {
              "question": "What should you do before running unfamiliar code?",
              "options": [
                "Just upload it",
                "Read and trace it step by step",
                "Delete it"
              ],
              "correctIndex": 1,
              "explanation": "Tracing code helps you predict behavior and find errors."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "cf_08",
    "title": "Your First Program",
    "summary": "Combine everything to pass the Coding Foundations assessment.",
    "tier": "rookie",
    "estimatedMinutes": 10,
    "courseId": "coding_foundations",
    "sortOrder": 8,
    "isOptional": true,
    "prerequisites": [
      "cf_07"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "cf_08_s01",
        "title": "Bringing It All Together",
        "type": "story",
        "markdownContent": "You now know about statements, variables, operators, if/else decisions, functions, loops, and the structure of an Arduino sketch.",
        "quickCheck": [
          {
            "questionId": "qc_cf_08_s01_q1",
            "question": "How do software code and physical hardware components work together in a robot?",
            "options": [
              "Code sends electrical signals through pins to command components",
              "They do not interact at all",
              "Components whisper to the screen"
            ],
            "correctIndex": 0,
            "explanation": "The microcontroller translates code commands into electrical voltages that power motors, lights, and sensors!",
            "warmupExplanation": "Your brain thinks raise hand, and your muscles move. Code is the thought, electronics are the muscles."
          },
          {
            "questionId": "qc_cf_08_s01_q2",
            "question": "What are the two core functions found in every Arduino program?",
            "options": [
              "setup() and loop()",
              "start() and finish()",
              "eat() and sleep()"
            ],
            "correctIndex": 0,
            "explanation": "Every Arduino program requires setup() to initialize hardware once, and loop() to repeat tasks continuously!",
            "warmupExplanation": "First you wake up and get ready (setup), then you go about your active day (loop)."
          }
        ]
      },
      {
        "stepId": "cf_08_s02",
        "title": "Mentally Writing a Sketch",
        "type": "story",
        "markdownContent": "Given a hardware goal, identify the necessary global variables, configure pins in `setup()`, and write the logic in `loop()`."
      },
      {
        "stepId": "cf_08_s03",
        "title": "Compilation Simulation",
        "type": "visualExplanation",
        "interactiveWidgetType": "compilationPipelineSimulator",
        "markdownContent": "Review how code goes from text to binary.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_08_s04",
        "title": "Final Debugging",
        "type": "codeExperiment",
        "interactiveWidgetType": "syntaxErrorDebugger",
        "markdownContent": "One last bug hunt before the placement assessment.",
        "interactiveConfig": {}
      },
      {
        "stepId": "cf_08_s05",
        "title": "Placement Assessment",
        "type": "quizCheckpoint",
        "markdownContent": "Pass this 8-question assessment to complete Coding Foundations.",
        "interactiveConfig": {
          "isPlacementAssessment": true,
          "passingScore": 6,
          "questions": [
            {
              "question": "What is a variable?",
              "options": [
                "A physical component",
                "A named storage container in memory",
                "An error"
              ],
              "correctIndex": 1,
              "explanation": "Variables store data."
            },
            {
              "question": "Which operator means 'is equal to'?",
              "options": [
                "=",
                "==",
                "!="
              ],
              "correctIndex": 1,
              "explanation": "== is the equality comparison operator."
            },
            {
              "question": "What is an `if` statement used for?",
              "options": [
                "Making decisions based on conditions",
                "Repeating code forever",
                "Declaring a variable"
              ],
              "correctIndex": 0,
              "explanation": "If statements allow conditional execution."
            },
            {
              "question": "What does a function do?",
              "options": [
                "Groups code into a reusable named block",
                "Stops the program",
                "Adds two numbers"
              ],
              "correctIndex": 0,
              "explanation": "Functions organize and reuse code."
            },
            {
              "question": "What is the purpose of a `for` loop?",
              "options": [
                "To make a decision",
                "To run code a specific number of times",
                "To end the program"
              ],
              "correctIndex": 1,
              "explanation": "For loops repeat code for a counted number of iterations."
            },
            {
              "question": "When does the `setup()` function run?",
              "options": [
                "Once, when the Arduino turns on",
                "Forever in a loop",
                "Never"
              ],
              "correctIndex": 0,
              "explanation": "Setup is for initialization at startup."
            },
            {
              "question": "What runs continuously on an Arduino?",
              "options": [
                "setup()",
                "loop()",
                "variables"
              ],
              "correctIndex": 1,
              "explanation": "The loop function runs repeatedly."
            },
            {
              "question": "If your code is missing a semicolon, what type of error is it?",
              "options": [
                "Logic Error",
                "Syntax Error",
                "Hardware Error"
              ],
              "correctIndex": 1,
              "explanation": "Missing punctuation is a syntax error."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "l2a_01",
    "title": "What Is Monster Lab?",
    "summary": "Monster Lab is an app that teaches you to build real Arduino robots.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "lesson_01"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_01_s01",
        "title": "Your Robot Mentor",
        "type": "story",
        "markdownContent": "Welcome to **Monster Lab**!\n\nMonster Lab is an interactive app that replaces a traditional teacher. It acts as your personal robot mentor, teaching you how to build real Arduino circuits and code them from scratch.\n\nEverything you need to know is right here in the app. Let's explore how it works!",
        "quickCheck": [
          {
            "questionId": "qc_l2a_01_s01_q1",
            "question": "What does Monster Lab help you build?",
            "options": [
              "Real Arduino circuits and interactive robotics projects",
              "Cardboard dollhouses",
              "Paper airplanes"
            ],
            "correctIndex": 0,
            "explanation": "Monster Lab is your mentor that guides you through building real hardware electronics and writing code!",
            "warmupExplanation": "Monster Lab turns your computer into a high-tech workshop for robotics and inventing."
          },
          {
            "questionId": "qc_l2a_01_s01_q2",
            "question": "How does software code connect with physical hardware?",
            "options": [
              "Software instructions tell the hardware when to glow, move, or beep",
              "They are completely unrelated",
              "Hardware operates without any rules"
            ],
            "correctIndex": 0,
            "explanation": "Software is the thought/plan and hardware is the body/action!",
            "warmupExplanation": "Your brain thinks to wave a hand, and your arm moves. Software directs hardware!"
          }
        ]
      },
      {
        "stepId": "l2a_01_s02",
        "title": "Software Meets Hardware",
        "type": "story",
        "markdownContent": "Here's the magic: Monster Lab is the **software** that teaches you how to build physical **hardware**.\n\nYou'll use this app to read lessons, study wiring diagrams, and practice coding logic. Then, you'll put your device down and build the real circuits with your own hands.\n\nFinally, you'll upload real code to your Arduino board using a computer."
      },
      {
        "stepId": "l2a_01_s03",
        "title": "The Learning Path",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Every project in Monster Lab follows a specific path to turn you into a robotics master.\n\n1. **Learn**: Read the interactive lesson.\n2. **Explore**: Study the new parts in the Parts Lab.\n3. **Build**: Wire up the circuit in the Build Lab.\n4. **Code**: Write and upload the sketch in the Code Lab.\n5. **Test**: See if your robot works.\n6. **Troubleshoot**: Fix bugs and wiring mistakes.\n7. **Master**: Complete optional challenges for more XP.\n\nCheck out the flow diagram below to see your journey!"
      },
      {
        "stepId": "l2a_01_s04",
        "title": "The Big Picture",
        "type": "visualExplanation",
        "interactiveWidgetType": "realWorldSystemDiagram",
        "markdownContent": "How do all the pieces fit together? You have the Monster Lab app, your computer running the Arduino IDE, the Arduino board, and electronic components.\n\nExplore the interactive system diagram below to see how information flows from the app to your brain, and from your computer to the robot!"
      },
      {
        "stepId": "l2a_01_s05",
        "title": "Quick Check",
        "type": "quizCheckpoint",
        "markdownContent": "Let's make sure you understand the core mission of Monster Lab.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the purpose of Monster Lab?",
              "options": [
                "To act as your robot mentor and teach you Arduino",
                "To play video games",
                "To buy electronic parts"
              ],
              "correctIndex": 0,
              "explanation": "Monster Lab is your personal guide to mastering Arduino and robotics."
            },
            {
              "question": "In the Monster Lab path, what do you do after you Build your circuit?",
              "options": [
                "Take it apart immediately",
                "Code it in the Code Lab",
                "Throw it away"
              ],
              "correctIndex": 1,
              "explanation": "After building the hardware, you move to the Code Lab to write the software!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_02",
    "title": "The Learn Lab",
    "summary": "Explore where all your interactive lessons live and learn how to navigate them.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l2a_01"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_02_s01",
        "title": "Welcome to the Learn Lab",
        "type": "story",
        "markdownContent": "The **Learn Lab** is your headquarters. It's the screen where all your lessons are listed, just like a table of contents in a book.\n\nWhenever you're ready to start a new mission, you come here to select your next lesson.",
        "quickCheck": [
          {
            "questionId": "qc_l2a_02_s01_q1",
            "question": "What is the primary purpose of the Learn Lab in Monster Lab?",
            "options": [
              "To guide you through step-by-step concepts, diagrams, and experiments",
              "To delete your code files",
              "To buy groceries online"
            ],
            "correctIndex": 0,
            "explanation": "The Learn Lab is where you study foundational electronics, signal flow, and programming mechanics!",
            "warmupExplanation": "Every great inventor studies how things work first. The Learn Lab is your interactive library."
          },
          {
            "questionId": "qc_l2a_02_s01_q2",
            "question": "What can you do if a concept in Learn Lab feels new or challenging?",
            "options": [
              "Use the optional Quick Check warmups and interactive widgets to practice at your own pace",
              "Give up immediately",
              "Smash the monitor"
            ],
            "correctIndex": 0,
            "explanation": "Warmups and interactive widgets let you manipulate simulated circuits and practice with zero stress!",
            "warmupExplanation": "Mistakes are how engineers learn. Monster Lab gives you warmups whenever you want extra practice."
          }
        ]
      },
      {
        "stepId": "l2a_02_s02",
        "title": "Difficulty Tiers",
        "type": "story",
        "markdownContent": "Lessons are organized into four difficulty tiers:\n\n1. **Rookie**: The basics. You are here!\n2. **Builder**: Intermediate circuits and code.\n3. **Engineer**: Advanced logic and sensors.\n4. **Monster Master**: Complex robots and final projects.\n\nYou have to complete the early tiers to unlock the later ones."
      },
      {
        "stepId": "l2a_02_s03",
        "title": "Navigating a Lesson",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "When you open a lesson, you'll see a series of **steps**. You're looking at a step right now!\n\n- Read the text.\n- Interact with any diagrams or simulators.\n- Tap the **Next Step** button to move forward.\n\nExplore the layout diagram below to see how a lesson screen works."
      },
      {
        "stepId": "l2a_02_s04",
        "title": "Completing Lessons",
        "type": "story",
        "markdownContent": "When you reach the final step of a lesson, you'll usually find a **Quiz Checkpoint**. You must pass the quiz to finish the lesson.\n\nOnce finished, you'll earn **XP** (Experience Points) and the next lesson will automatically unlock!"
      },
      {
        "stepId": "l2a_02_s05",
        "title": "Tier Check",
        "type": "story",
        "interactiveWidgetType": "miniQuiz",
        "markdownContent": "Let's see if you remember the difficulty tiers. Answer the questions below!",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Which tier is for beginners starting out?",
              "options": [
                "Monster Master",
                "Engineer",
                "Rookie"
              ],
              "correctIndex": 2,
              "explanation": "Rookie is the starting tier where everyone begins their journey."
            }
          ]
        }
      },
      {
        "stepId": "l2a_02_s06",
        "title": "Quick Check",
        "type": "quizCheckpoint",
        "markdownContent": "Let's review the Learn Lab.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What do you do in the Learn Lab?",
              "options": [
                "Find and read interactive lessons",
                "Buy Arduino boards",
                "Write C++ code"
              ],
              "correctIndex": 0,
              "explanation": "The Learn Lab is where you find all your educational content and lessons."
            },
            {
              "question": "How do you progress through a lesson?",
              "options": [
                "Wait 5 minutes",
                "Read the content and tap the Next Step button",
                "Shake the device"
              ],
              "correctIndex": 1,
              "explanation": "You control your own pace by tapping the Next Step button when you're ready."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_03",
    "title": "The Parts Lab",
    "summary": "Discover your component library. Learn how to search, browse, and understand your hardware.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l2a_02"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_03_s01",
        "title": "Welcome to the Parts Lab",
        "type": "story",
        "markdownContent": "The **Parts Lab** is your digital hardware encyclopedia.\n\nIt lists every single component, wire, sensor, and board you'll use in Monster Lab. It's the perfect place to go when you encounter a new part and want to know how it works.",
        "quickCheck": [
          {
            "questionId": "qc_l2a_03_s01_q1",
            "question": "Where do you go in Monster Lab to inspect electronic components, pinouts, and safety specs?",
            "options": [
              "The Parts Lab",
              "The trash bin",
              "The settings menu"
            ],
            "correctIndex": 0,
            "explanation": "The Parts Lab is an encyclopedia of every sensor, motor, IC, and resistor in your Monster Lab kit!",
            "warmupExplanation": "Before cooking, chefs check their ingredients. In the Parts Lab, you discover all your robot pieces."
          },
          {
            "questionId": "qc_l2a_03_s01_q2",
            "question": "Why is knowing a component's pinout and voltage rating important before building?",
            "options": [
              "Connecting wrong voltages or pins backwards can damage delicate electronics",
              "Colors look prettier",
              "To make the board heavier"
            ],
            "correctIndex": 0,
            "explanation": "Electronics are designed for specific voltages (like 5V or 3.3V). Checking pinouts keeps components safe!",
            "warmupExplanation": "Plugging a toy into the wrong battery could hurt it. Inspecting pinouts keeps hardware healthy."
          }
        ]
      },
      {
        "stepId": "l2a_03_s02",
        "title": "Finding Your Parts",
        "type": "story",
        "markdownContent": "You can find parts in two ways:\n\n1. **Browse**: Scroll through categories like Boards, Outputs, Inputs, and Power.\n2. **Search**: Type the name of a part (like 'LED' or 'Resistor') in the search bar to find it instantly.\n\nAlways know your parts before you build!"
      },
      {
        "stepId": "l2a_03_s03",
        "title": "Reading a Component Page",
        "type": "visualExplanation",
        "interactiveWidgetType": "boardLabelDragDrop",
        "markdownContent": "When you open a part's page, you'll see crucial information:\n- **What it is**: A simple explanation.\n- **Pins**: Which pin is power, ground, or signal.\n- **Wiring Tips**: Important safety warnings, like 'Always use a resistor with an LED!'\n\nTry matching these part names to their functions below!"
      },
      {
        "stepId": "l2a_03_s04",
        "title": "Input or Output?",
        "type": "story",
        "interactiveWidgetType": "inputOutputClassification",
        "markdownContent": "One of the most important things to know about a part is whether it's an **Input** (a sensor) or an **Output** (an actuator).\n\nThe Parts Lab will always tell you this. Practice classifying some common parts below!"
      },
      {
        "stepId": "l2a_03_s05",
        "title": "Quick Check",
        "type": "quizCheckpoint",
        "markdownContent": "Let's test your Parts Lab knowledge.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the Parts Lab used for?",
              "options": [
                "Writing code",
                "Looking up information about hardware components",
                "Building circuits"
              ],
              "correctIndex": 1,
              "explanation": "The Parts Lab is your encyclopedia for understanding your physical components."
            },
            {
              "question": "What important safety information can you find in the Parts Lab?",
              "options": [
                "How to hold a soldering iron",
                "Wiring tips and pin layouts for a specific component",
                "Safety glasses requirements"
              ],
              "correctIndex": 1,
              "explanation": "Component pages show you exactly how to wire a part safely, including which pins are power and ground."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_04",
    "title": "The Build Lab",
    "summary": "Step-by-step guided hardware builds. Learn how to follow diagrams safely.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l2a_03"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_04_s01",
        "title": "Welcome to the Build Lab",
        "type": "story",
        "markdownContent": "The **Build Lab** is where the magic happens. This is where you get your hands dirty and wire up real circuits.\n\nEvery project has a Build Lab section showing you exactly where to plug in every wire and component.",
        "quickCheck": [
          {
            "questionId": "qc_l2a_04_s01_q1",
            "question": "What is the main mission of the Build Lab?",
            "options": [
              "To guide you through physical breadboard circuit wiring step-by-step",
              "To play background music",
              "To draw cartoon pictures"
            ],
            "correctIndex": 0,
            "explanation": "The Build Lab provides interactive wiring diagrams to guide your hands on the physical workbench!",
            "warmupExplanation": "Building real circuits is the fun part! The Build Lab shows exactly where each jumper wire plugs in."
          },
          {
            "questionId": "qc_l2a_04_s01_q2",
            "question": "What safety step should you ALWAYS take before changing wiring on your breadboard?",
            "options": [
              "Unplug USB power from your Arduino so current cannot flow during wiring",
              "Pour water on the board",
              "Wear sunglasses indoors"
            ],
            "correctIndex": 0,
            "explanation": "Always disconnect power before placing or moving wires to protect both yourself and the components!",
            "warmupExplanation": "Power off before you touch! It is rule #1 of electrical engineering."
          }
        ]
      },
      {
        "stepId": "l2a_04_s02",
        "title": "Following the Blueprint",
        "type": "story",
        "markdownContent": "Build Lab diagrams are step-by-step blueprints.\n\nInstead of throwing a complex diagram at you, Monster Lab breaks it down. You'll add one wire or part at a time, making it impossible to get lost."
      },
      {
        "stepId": "l2a_04_s03",
        "title": "Will It Work?",
        "type": "story",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "Always check your work before powering on. If you miss a wire, the circuit won't work.\n\nLook at the scenario below. Based on what you know about closed loops, predict if this circuit will work!"
      },
      {
        "stepId": "l2a_04_s04",
        "title": "Checking Your Ground",
        "type": "story",
        "interactiveWidgetType": "groundTroubleshooting",
        "markdownContent": "The most common mistake in the Build Lab is a disconnected **Ground (GND)** wire.\n\nIf ground is disconnected, electricity can't flow. Practice finding the ground problem in the circuit below."
      },
      {
        "stepId": "l2a_04_s05",
        "title": "Quick Check",
        "type": "quizCheckpoint",
        "markdownContent": "Let's review the Build Lab.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What do you do in the Build Lab?",
              "options": [
                "Follow step-by-step diagrams to wire up physical circuits",
                "Write C++ code",
                "Take quizzes"
              ],
              "correctIndex": 0,
              "explanation": "The Build Lab gives you the blueprints to construct your hardware."
            },
            {
              "question": "What is the most common wiring mistake to check for?",
              "options": [
                "Using the wrong color LED",
                "A disconnected Ground (GND) wire",
                "Plugging in the USB cable too slowly"
              ],
              "correctIndex": 1,
              "explanation": "If the ground wire isn't securely connected, the circuit is open and nothing will work."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_05",
    "title": "The Code Lab & Challenges",
    "summary": "Discover where to find your code, what an experiment is, and how to conquer optional challenges.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l2a_04"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_05_s01",
        "title": "Welcome to the Code Lab",
        "type": "story",
        "markdownContent": "Once your hardware is built, you need to give it a brain. That's what the **Code Lab** is for.\n\nThe Code Lab gives you the exact C++ sketches you need to upload to your Arduino to make your circuit come alive.",
        "quickCheck": [
          {
            "questionId": "qc_l2a_05_s01_q1",
            "question": "What is the role of the Code Lab in Monster Lab?",
            "options": [
              "To write, review, and test code sketches before uploading to your Arduino",
              "To print paper letters",
              "To browse websites"
            ],
            "correctIndex": 0,
            "explanation": "The Code Lab lets you deconstruct Arduino sketches, understand syntax, and solve programming challenges!",
            "warmupExplanation": "The Code Lab is where you give your monster circuits their personality and smart behaviors."
          },
          {
            "questionId": "qc_l2a_05_s01_q2",
            "question": "What should you check when your code has a syntax error?",
            "options": [
              "Look for missing semicolons, unmatched parentheses, or typos in command names",
              "Throw away the Arduino",
              "Wait until tomorrow"
            ],
            "correctIndex": 0,
            "explanation": "C++ compilers are very precise: missing semicolons or spelling mistakes are the most common syntax errors!",
            "warmupExplanation": "If a sentence forgets a period, it looks strange. Code needs its semicolons and correct spellings."
          }
        ]
      },
      {
        "stepId": "l2a_05_s02",
        "title": "The IDE Connection",
        "type": "story",
        "markdownContent": "You don't type code directly into Monster Lab on your phone or tablet to run it. \n\nInstead, you use a computer running the **Arduino IDE** (Integrated Development Environment). You'll copy the code from the Code Lab, paste it into the IDE on your computer, and click **Upload**.\n\nWe'll cover exactly how the IDE works in the next lesson!"
      },
      {
        "stepId": "l2a_05_s03",
        "title": "The Upload Pipeline",
        "type": "visualExplanation",
        "interactiveWidgetType": "compilationPipelineSimulator",
        "markdownContent": "When you click Upload, your code goes on a journey. It gets **Compiled** (translated into machine language) and then sent over the USB cable to the Arduino's memory.\n\nWatch the pipeline simulator below to see how your text becomes a running program!"
      },
      {
        "stepId": "l2a_05_s04",
        "title": "What are Challenges?",
        "type": "story",
        "markdownContent": "After you finish a lesson's main code, you'll unlock **Challenges**.\n\nChallenges are optional, extra-hard missions where you have to modify the code or the wiring yourself, without step-by-step instructions. They are the best way to earn extra XP and prove you've mastered the concept!"
      },
      {
        "stepId": "l2a_05_s05",
        "title": "Code Lab Review",
        "type": "story",
        "interactiveWidgetType": "miniQuiz",
        "markdownContent": "Let's check your understanding of the Code Lab.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Where do you actually upload code to the Arduino?",
              "options": [
                "Directly from the Monster Lab app on your phone",
                "From the Arduino IDE on a computer",
                "You don't need to upload code"
              ],
              "correctIndex": 1,
              "explanation": "You use the Arduino IDE on your computer to compile and upload the sketches."
            }
          ]
        }
      },
      {
        "stepId": "l2a_05_s06",
        "title": "Quick Check",
        "type": "quizCheckpoint",
        "markdownContent": "Let's review.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What are Challenges?",
              "options": [
                "Mandatory quizzes",
                "Optional, extra-hard missions to modify code or wiring",
                "A list of broken parts"
              ],
              "correctIndex": 1,
              "explanation": "Challenges are optional missions that test your mastery and give you extra XP."
            },
            {
              "question": "What happens when code is 'compiled'?",
              "options": [
                "It is deleted",
                "It is printed on paper",
                "It is translated from C++ into machine language the Arduino understands"
              ],
              "correctIndex": 2,
              "explanation": "Compilation turns human-readable code into machine instructions."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_06",
    "title": "Progress, XP & Badges",
    "summary": "Learn how to level up, earn badges, and track your progress in Monster Lab.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l2a_05"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_06_s01",
        "title": "Earning XP",
        "type": "story",
        "markdownContent": "As you complete lessons, quizzes, and challenges, you earn **XP** (Experience Points).\n\nXP is a measure of your robotics knowledge. The more you learn, the more XP you get!",
        "quickCheck": [
          {
            "questionId": "qc_l2a_06_s01_q1",
            "question": "How do you earn Experience Points (XP) and unlock new badges in Monster Lab?",
            "options": [
              "By completing lessons, building circuits, and passing challenge checkpoints",
              "By clicking random buttons rapidly",
              "By turning the computer off"
            ],
            "correctIndex": 0,
            "explanation": "Completing learning journeys and solving hands-on challenges awards XP and unlocks achievement badges!",
            "warmupExplanation": "Every time you learn a concept or build a circuit, your engineer level increases!"
          },
          {
            "questionId": "qc_l2a_06_s01_q2",
            "question": "Can you re-visit past lessons to review concepts after completing them?",
            "options": [
              "Yes, all completed lessons remain unlocked in your Learn Lab library",
              "No, completed lessons disappear forever",
              "Only once per year"
            ],
            "correctIndex": 0,
            "explanation": "You can re-open any unlocked lesson at any time to refresh your memory or try experiments again!",
            "warmupExplanation": "Great engineers look back at notes and diagrams often. Lessons stay available in your library."
          }
        ]
      },
      {
        "stepId": "l2a_06_s02",
        "title": "Leveling Up",
        "type": "story",
        "markdownContent": "Collect enough XP, and your overall **Level** will increase.\n\nLeveling up proves you're becoming a more advanced robotics engineer. You'll need high levels to unlock the hardest projects later on."
      },
      {
        "stepId": "l2a_06_s03",
        "title": "Badges of Honor",
        "type": "story",
        "markdownContent": "You can also earn **Badges** for special achievements, like getting a perfect score on a safety quiz, or completing all the challenges in a tier.\n\nCheck your profile to see all the badges you've earned."
      },
      {
        "stepId": "l2a_06_s04",
        "title": "Saved Progress",
        "type": "story",
        "markdownContent": "Monster Lab automatically saves your progress.\n\nIf you leave a lesson halfway through, you can come back later and pick up right where you left off.\n\n*Note: You only earn XP for completing a lesson the first time. Re-doing a lesson is great for review, but won't double your XP!*"
      },
      {
        "stepId": "l2a_06_s05",
        "title": "XP Rules",
        "type": "story",
        "interactiveWidgetType": "miniQuiz",
        "markdownContent": "Let's make sure you understand the XP rules.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Can you earn XP for completing the same lesson twice?",
              "options": [
                "Yes",
                "No"
              ],
              "correctIndex": 1,
              "explanation": "You only earn the XP reward the first time you complete a lesson."
            }
          ]
        }
      },
      {
        "stepId": "l2a_06_s06",
        "title": "Quick Check",
        "type": "quizCheckpoint",
        "markdownContent": "Let's review XP and progress.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What happens when you collect enough XP?",
              "options": [
                "You lose your badges",
                "Your overall Level increases",
                "The app restarts"
              ],
              "correctIndex": 1,
              "explanation": "Accumulating XP increases your Level, showing your growth as an engineer."
            },
            {
              "question": "How do you earn Badges?",
              "options": [
                "By buying them",
                "By asking the teacher",
                "By completing special achievements, like perfect quizzes"
              ],
              "correctIndex": 2,
              "explanation": "Badges are unlocked by completing specific achievements in the app."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_07",
    "title": "Safe Hardware Workflow",
    "summary": "The Golden Rules of hardware. Keep your components safe from short circuits and static shock.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l2a_06"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_07_s01",
        "title": "Safety First!",
        "type": "story",
        "markdownContent": "Unlike software, hardware can be permanently broken if you make a mistake.\n\nPlugging a wire into the wrong place can cause a **short circuit**, instantly destroying an LED or even your Arduino board. You must learn the Safe Hardware Workflow.",
        "quickCheck": [
          {
            "questionId": "qc_l2a_07_s01_q1",
            "question": "What is electrostatic discharge (ESD) and why should we be aware of it?",
            "options": [
              "A tiny spark of static electricity that can damage microchips without you even feeling it",
              "A magical energy beam",
              "A special battery boost"
            ],
            "correctIndex": 0,
            "explanation": "Static electricity built up on fingers can shock delicate microchips. Touching grounded surfaces discharges static safely!",
            "warmupExplanation": "Ever gotten a tiny shock after walking on a carpet? Electronics feel that shock much harder than you do."
          },
          {
            "questionId": "qc_l2a_07_s01_q2",
            "question": "How should you organize your workbench before starting a build?",
            "options": [
              "Keep tools, wires, and parts clean, dry, and organized in trays",
              "Pile everything in a messy heap with drinks nearby",
              "Cover the desk with conductive foil"
            ],
            "correctIndex": 0,
            "explanation": "A clean, dry workbench prevents accidental short circuits and keeps components easy to find!",
            "warmupExplanation": "Keep liquids far away from electronics and give yourself plenty of space to work."
          }
        ]
      },
      {
        "stepId": "l2a_07_s02",
        "title": "The First Golden Rule",
        "type": "story",
        "markdownContent": "**Always unplug your Arduino from USB power before changing any wiring.**\n\nNever pull wires or plug in new components while the green ON light is lit. Build the circuit dead, then bring it to life."
      },
      {
        "stepId": "l2a_07_s03",
        "title": "The Second Golden Rule",
        "type": "story",
        "markdownContent": "**Double-check every connection before plugging the USB cable back in.**\n\nCompare your physical breadboard to the Monster Lab diagram. Check the Ground wire, the Power wire, and component orientation (like LED legs). Only plug it in when you are 100% sure."
      },
      {
        "stepId": "l2a_07_s04",
        "title": "Beware the Static Shock (ESD)",
        "type": "story",
        "interactiveWidgetType": "esdSafetyCheck",
        "markdownContent": "Have you ever dragged your socks on carpet and shocked a doorknob? That's **Electrostatic Discharge (ESD)**.\n\nWhile a shock feels tiny to you, it acts like a lightning bolt to an Arduino chip. Always touch a grounded piece of metal (like a metal table leg or computer case) before picking up a bare circuit board to discharge yourself."
      },
      {
        "stepId": "l2a_07_s05",
        "title": "Inspect the Circuit",
        "type": "story",
        "interactiveWidgetType": "groundTroubleshooting",
        "markdownContent": "Let's practice the Second Golden Rule. Inspect the circuit below before we 'plug it in'. \n\nIs there anything unsafe or disconnected?"
      },
      {
        "stepId": "l2a_07_s06",
        "title": "Safety Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Safety is critical. You must get all these questions right to pass.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the First Golden Rule of wiring?",
              "options": [
                "Always use red wires",
                "Always unplug power before changing wires",
                "Always work fast"
              ],
              "correctIndex": 1,
              "explanation": "Never modify a live circuit. Always disconnect power first."
            },
            {
              "question": "What should you do before picking up an Arduino board?",
              "options": [
                "Wash your hands",
                "Touch a grounded piece of metal to discharge static electricity",
                "Put on gloves"
              ],
              "correctIndex": 1,
              "explanation": "Discharging ESD prevents static shocks from destroying sensitive microchips."
            },
            {
              "question": "When is it safe to plug the USB cable in?",
              "options": [
                "Immediately after placing the first part",
                "While you are holding the wires",
                "Only after you have double-checked all connections against the diagram"
              ],
              "correctIndex": 2,
              "explanation": "Double-check your work first to prevent short circuits upon power-up."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2a_08",
    "title": "Orientation Challenge",
    "summary": "Prove you know your way around Monster Lab in this final orientation challenge.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2a",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l2a_07"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l2a_08_s01",
        "title": "The Full Map",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "You've seen all the pieces. Let's look at the full Monster Lab map one last time.\n\n- **Learn Lab**: Read lessons.\n- **Parts Lab**: Learn about hardware.\n- **Build Lab**: Wire the circuit.\n- **Code Lab**: Copy the code.\n- **Challenges**: Go beyond the basics.\n\nReview the flow below.",
        "quickCheck": [
          {
            "questionId": "qc_l2a_08_s01_q1",
            "question": "What makes a successful Monster Lab hardware inventor?",
            "options": [
              "Curiosity, patience, testing hypotheses, and learning from mistakes",
              "Rushing as fast as possible without reading",
              "Never testing anything"
            ],
            "correctIndex": 0,
            "explanation": "Engineering is all about iterating, experimenting, and treating unexpected bugs as learning opportunities!",
            "warmupExplanation": "When something doesn't work on the first try, engineers say: \"Fascinating! Let's find out why!\""
          },
          {
            "questionId": "qc_l2a_08_s01_q2",
            "question": "When you encounter an unfamiliar electronic component in your kit, what is your first step?",
            "options": [
              "Look up its name, symbol, and pinout in the Parts Lab",
              "Plug random wires into it with power on",
              "Throw it out the window"
            ],
            "correctIndex": 0,
            "explanation": "Checking the Parts Lab reveals what the component does, its safe voltage range, and its pin layout!",
            "warmupExplanation": "The Parts Lab is your secret field guide for every mystery component."
          }
        ]
      },
      {
        "stepId": "l2a_08_s02",
        "title": "Final Exam",
        "type": "quizCheckpoint",
        "markdownContent": "This is it! An 8-question exam covering everything you learned in Lesson 2A.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the correct order for a new project?",
              "options": [
                "Code -> Build -> Learn",
                "Learn -> Build -> Code",
                "Build -> Code -> Parts"
              ],
              "correctIndex": 1,
              "explanation": "Always Learn the theory, Build the hardware, then upload the Code."
            },
            {
              "question": "Where do you go to find the pinout for a new sensor?",
              "options": [
                "The Parts Lab",
                "The Code Lab",
                "The Challenges section"
              ],
              "correctIndex": 0,
              "explanation": "The Parts Lab is the encyclopedia for all hardware components."
            },
            {
              "question": "What is the most important thing to do before wiring a circuit?",
              "options": [
                "Turn the computer on",
                "Disconnect the Arduino from power",
                "Open the Code Lab"
              ],
              "correctIndex": 1,
              "explanation": "Always build circuits 'dead' by disconnecting power first."
            },
            {
              "question": "Where do you find the step-by-step wiring diagrams?",
              "options": [
                "The Learn Lab",
                "The Build Lab",
                "The Code Lab"
              ],
              "correctIndex": 1,
              "explanation": "The Build Lab contains all physical assembly instructions."
            },
            {
              "question": "Where do you actually upload code to the Arduino?",
              "options": [
                "Inside the Monster Lab app",
                "Using the Arduino IDE on a computer",
                "Inside the Build Lab"
              ],
              "correctIndex": 1,
              "explanation": "The Arduino IDE on a computer is required to compile and upload code over USB."
            },
            {
              "question": "How do you earn extra XP in a project?",
              "options": [
                "Reading the lesson twice",
                "Completing optional Challenges",
                "Closing the app"
              ],
              "correctIndex": 1,
              "explanation": "Challenges offer bonus XP for proving your mastery."
            },
            {
              "question": "How do you earn Badges?",
              "options": [
                "Completing special achievements",
                "They are given randomly",
                "You start with all of them"
              ],
              "correctIndex": 0,
              "explanation": "Badges are rewards for specific accomplishments like perfect safety quizzes."
            },
            {
              "question": "What is ESD?",
              "options": [
                "A type of LED",
                "Electrostatic Discharge (static shock) that can damage boards",
                "Extra System Data"
              ],
              "correctIndex": 1,
              "explanation": "ESD is static electricity that must be discharged before touching bare circuit boards."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_01",
    "title": "What Is an IDE?",
    "summary": "Learn what an IDE is and the workflow for writing, compiling, and uploading code.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l2a_08"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_01_s01",
        "title": "Give the Monster Its Voice",
        "type": "story",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "The Arduino is the robot's brain, but the brain needs instructions.\n\nYour computer is where you write those instructions. The **Arduino IDE** (Integrated Development Environment) is the workbench that lets you write sketches, verify syntax, compile machine binaries, upload them to the board, and monitor serial communications.\n\nThe Monster Lab will talk to your physical Arduino Uno through this IDE. Think of the engineering workflow as:\n```\nWrite Code ➔ Check Syntax ➔ Compile Binary ➔ Upload Flash ➔ Run Hardware ➔ Observe\n```\n\nIn this lesson, you will set up your development station, select your communication port, and explore how firmware lifecycles work.",
        "quickCheck": [
          {
            "questionId": "qc_l2b_01_s01_q1",
            "question": "What is an IDE (Integrated Development Environment) like the Arduino IDE?",
            "options": [
              "A software program where you write, check, and upload code sketches to microcontrollers",
              "A video streaming app",
              "A physical screwdriver"
            ],
            "correctIndex": 0,
            "explanation": "An IDE combines a code editor, compiler, and hardware programmer in one easy tool!",
            "warmupExplanation": "An IDE is like a word processor designed especially for computer code and robot brains."
          },
          {
            "questionId": "qc_l2b_01_s01_q2",
            "question": "What are code programs called in the Arduino ecosystem?",
            "options": [
              "Sketches",
              "Drawings",
              "Paintings"
            ],
            "correctIndex": 0,
            "explanation": "Arduino programs are affectionately called \"sketches\"!",
            "warmupExplanation": "Just like drawing out an idea in a sketchbook, Arduino programs are known as sketches."
          }
        ]
      },
      {
        "stepId": "l2b_01_s02",
        "title": "What Is an IDE? The Programmer's Workbench",
        "type": "story",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "**IDE** stands for **Integrated Development Environment**.\n\nThink of it as a master workshop for robotics software. Instead of using a text editor to write code, a separate command-line terminal to compile it, and a third utility to flash the microcontroller chip, the Arduino IDE bundles all essential tools into one unified workbench.\n\n### Core Vocabulary\n- **IDE**: Unified software used to write, compile, and upload sketches.\n- **Sketch**: An Arduino program file ending in `.ino`.\n- **Compile**: The process of translating human-readable C++ instructions into binary machine code.\n- **Upload**: Transmitting the compiled machine hex binary from PC memory into microcontroller flash storage.\n- **Port**: The virtual serial communication channel (e.g. `COM3` or `/dev/ttyUSB0`) connecting your PC to the board."
      },
      {
        "stepId": "l2b_01_s03",
        "title": "Knowledge Check: IDE",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of IDE basics.",
        "interactiveConfig": {
          "question": "What does IDE stand for?",
          "options": [
            "Integrated Development Environment",
            "Internal Digital Engine",
            "Input Device Electronics"
          ],
          "correctIndex": 0,
          "explanation": "IDE stands for Integrated Development Environment—the unified coding and flashing workbench.",
          "questions": [
            {
              "question": "What does IDE stand for?",
              "options": [
                "Integrated Development Environment",
                "Internal Digital Engine",
                "Input Device Electronics"
              ],
              "correctIndex": 0,
              "explanation": "IDE stands for Integrated Development Environment—the unified coding and flashing workbench."
            },
            {
              "question": "What is an Arduino sketch?",
              "options": [
                "An Arduino program/project (.ino file)",
                "A battery",
                "A USB port"
              ],
              "correctIndex": 0,
              "explanation": "An Arduino sketch is the C++ program file containing setup() and loop() routines."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_02",
    "title": "Compilation & Flashing Pipeline",
    "summary": "Understand what happens when you click the Upload button.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l2b_01"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_02_s01",
        "title": "Compilation & Flashing: What Happens When You Upload?",
        "type": "visualExplanation",
        "interactiveWidgetType": "compilationPipelineSimulator",
        "markdownContent": "When you click **Upload** in the IDE, your computer does not send C++ words directly to the ATmega328P chip. Microcontrollers cannot read English or C++! They only understand raw hexadecimal binary opcodes.\n\n### The 4-Stage Build & Flash Pipeline:\n1. **Human Source Code**: You write C++ functions.\n2. **Syntax Verification & Lexing**: The compiler checks grammar, matching braces `{ }`, and semicolons `;`.\n3. **Binary Compilation (avr-g++)**: Converts C++ text into machine opcodes (Intel HEX format).\n4. **Hardware Flash Flashing (avrdude)**: Streams bytes over USB serial into the bootloader in flash memory.\n\nStep through each stage in the pipeline simulator below to see how code transforms into machine reality!",
        "quickCheck": [
          {
            "questionId": "qc_l2b_02_s01_q1",
            "question": "What does the compiler in the Arduino IDE do when you click the \"Verify\" (check mark) button?",
            "options": [
              "Translates your human-readable C++ code into machine binary code and checks for syntax errors",
              "Deletes your file",
              "Takes a picture of the screen"
            ],
            "correctIndex": 0,
            "explanation": "Compiling turns text code into 1s and 0s that the microcontroller hardware can directly execute!",
            "warmupExplanation": "Computers don't speak English—they speak machine binary. The compiler is your translator."
          },
          {
            "questionId": "qc_l2b_02_s01_q2",
            "question": "What is \"flashing\" or \"uploading\" in microcontroller programming?",
            "options": [
              "Sending compiled binary instructions through the USB cable into the Arduino's flash memory",
              "Waving a flashlight at the board",
              "Taking a photo with a flash bulb"
            ],
            "correctIndex": 0,
            "explanation": "Uploading writes machine code into the chip's non-volatile flash memory so it stays saved even without power!",
            "warmupExplanation": "Flash memory is like the Arduino's long-term brain notebook where your program is stored."
          }
        ]
      },
      {
        "stepId": "l2b_02_s02",
        "title": "Predict the Pipeline",
        "type": "story",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "If there's a syntax error like a missing semicolon in your code, which stage fails? Why? Think about the 4-Stage Pipeline.\n\nIt would fail at Stage 2 (Syntax Verification & Lexing). The compiler won't even try to build binary if the C++ grammar is invalid. Let's see if you can predict other failures!"
      },
      {
        "stepId": "l2b_02_s03",
        "title": "Knowledge Check: Compilation",
        "type": "quizCheckpoint",
        "markdownContent": "Check what you learned about compilation.",
        "interactiveConfig": {
          "question": "What does compiling do?",
          "options": [
            "Converts source code into a form suitable for the target system",
            "Supplies electricity to the Arduino",
            "Connects the USB cable"
          ],
          "correctIndex": 0,
          "explanation": "The compiler translates human-readable C++ source text into hexadecimal machine opcodes.",
          "questions": [
            {
              "question": "What does compiling do?",
              "options": [
                "Converts source code into a form suitable for the target system",
                "Supplies electricity to the Arduino",
                "Connects the USB cable"
              ],
              "correctIndex": 0,
              "explanation": "The compiler translates human-readable C++ source text into hexadecimal machine opcodes."
            },
            {
              "question": "What does Upload do?",
              "options": [
                "Sends the compiled program to the Arduino flash memory",
                "Deletes the Arduino",
                "Changes the USB cable"
              ],
              "correctIndex": 0,
              "explanation": "Upload transfers compiled hex binary through USB into microcontroller flash memory."
            },
            {
              "question": "Which stage catches missing semicolons?",
              "options": [
                "Syntax Verification",
                "Hardware Flash",
                "Human Source Code"
              ],
              "correctIndex": 0,
              "explanation": "The syntax verification stage analyzes grammar before attempting compilation."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_03",
    "title": "Connecting, Board & Port Selection",
    "summary": "Safely connect the USB and choose the right board and port in the IDE.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l2b_02"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_03_s01",
        "title": "Connecting the USB Cable Safely",
        "type": "physicalTask",
        "markdownContent": "Connect your Arduino Uno development board to your computer using the standard USB Type-B cable.\n\n### Step-by-Step Connection Procedure:\n1. **Inspect Your Workspace**: Ensure your table is completely dry, clean, and free of loose conductive metal clippings or staples.\n2. **Plug Board End**: Firmly insert the square **USB Type-B** plug into the silver receptacle on your Arduino Uno until it clicks.\n3. **Plug Computer End**: Insert the flat rectangular **USB Type-A** plug into a powered USB port on your PC or laptop.\n4. **Verify Power Beacon**: Look at the Arduino Uno. The green surface-mount LED labeled **ON** should glow solid green, indicating regulated 5V power!",
        "quickCheck": [
          {
            "questionId": "qc_l2b_03_s01_q1",
            "question": "Why must you select the correct Board (e.g. Arduino Uno) in the Arduino IDE Tools menu?",
            "options": [
              "So the compiler generates machine instructions tailored to that exact chip hardware",
              "It changes the color of the IDE",
              "It is purely cosmetic"
            ],
            "correctIndex": 0,
            "explanation": "Different boards have different chips, memory sizes, and pin configurations. The IDE must know which one you are using!",
            "warmupExplanation": "Different game consoles need different game discs. The IDE needs to know which board is plugged in."
          },
          {
            "questionId": "qc_l2b_03_s01_q2",
            "question": "What does the \"Port\" (COM port on Windows or /dev/tty on Linux/macOS) represent?",
            "options": [
              "The virtual communication channel through which your computer talks to the USB-connected board",
              "A sea port where ships dock",
              "An audio headphone jack"
            ],
            "correctIndex": 0,
            "explanation": "The serial port is the designated USB channel connecting your computer's operating system to the Arduino!",
            "warmupExplanation": "Think of the Port as a dedicated telephone line between your computer and the Arduino."
          }
        ]
      },
      {
        "stepId": "l2b_03_s02",
        "title": "What Is a Port? Serial COM Ports & Device Drivers",
        "type": "story",
        "interactiveWidgetType": "portSelectorBench",
        "markdownContent": "A **port** is the communication channel your computer uses to identify and talk to external USB devices.\n\nOn Windows, ports are assigned names like `COM1`, `COM3`, `COM4`. On macOS and Linux, they appear as `/dev/cu.usbmodem...` or `/dev/ttyUSB0`.\n\nWhen you plug in the Arduino, an onboard interface chip creates a virtual UART serial communication bridge.\n\nIn the IDE menu under **Tools > Board**, choose **Arduino Uno**. Under **Tools > Port**, select the port corresponding to your Uno. Practice configuring the board and port in the virtual bench below!"
      },
      {
        "stepId": "l2b_03_s03",
        "title": "Troubleshooting Lab Station",
        "type": "story",
        "interactiveWidgetType": "portTroubleshootingBench",
        "markdownContent": "If the Arduino IDE reports *\"Port Not Found\"* or errors out during upload, do not panic! Professional robotics engineers use systematic triage:\n\n1. **Check Physical Connection**: Is the USB cable fully seated into the jack?\n2. **Check Port Selection**: Is the active Arduino COM port chosen, or an internal motherboard port like COM1?\n3. **Check USB Drivers**: Does your board use a CH340 or CP2102 chip that requires an OS device driver?\n4. **Check Board Power**: Does the green ON LED illuminate, proving 5V power?\n\nInspect each diagnostic check in the triage bench below, resolve all 4 faults, and restore full communication link!"
      },
      {
        "stepId": "l2b_03_s04",
        "title": "Knowledge Check: Board & Port",
        "type": "quizCheckpoint",
        "markdownContent": "Test your knowledge on boards and ports.",
        "interactiveConfig": {
          "question": "Why must you select the correct board?",
          "options": [
            "Different boards can use different hardware and programming requirements",
            "The board name changes the USB cable",
            "The Arduino cannot store programs"
          ],
          "correctIndex": 0,
          "explanation": "Different microcontroller boards use distinct pin layouts, register maps, and flash sizes.",
          "questions": [
            {
              "question": "Why must you select the correct board?",
              "options": [
                "Different boards can use different hardware and programming requirements",
                "The board name changes the USB cable",
                "The Arduino cannot store programs"
              ],
              "correctIndex": 0,
              "explanation": "Different microcontroller boards use distinct pin layouts, register maps, and flash sizes."
            },
            {
              "question": "What does the port identify?",
              "options": [
                "The computer's communication connection to the Arduino",
                "The Arduino's battery level",
                "The program's XP reward"
              ],
              "correctIndex": 0,
              "explanation": "The serial COM port provides the virtual UART communication link between host OS and the Uno board."
            },
            {
              "question": "What should you check if the port is not found?",
              "options": [
                "Physical connection and driver installation",
                "The color of the USB cable",
                "The room temperature"
              ],
              "correctIndex": 0,
              "explanation": "Physical connection issues and missing drivers are the most common causes of unrecognized ports."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_04",
    "title": "setup() and loop() Deep Dive",
    "summary": "Understand the core structure of every Arduino sketch: setup() and loop().",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l2b_03"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_04_s01",
        "title": "First Look at Arduino Code: setup() and loop() Structure",
        "type": "codeExperiment",
        "interactiveWidgetType": "ideLifecycleSimulator",
        "markdownContent": "Every Arduino sketch is built around two fundamental functions:\n\n```cpp\nvoid setup() {\n  // Hardware configuration — runs ONCE at boot or reset\n  pinMode(13, OUTPUT);\n}\n\nvoid loop() {\n  // Perpetual cycle — runs REPEATEDLY forever\n  digitalWrite(13, HIGH);\n  delay(1000);\n  digitalWrite(13, LOW);\n  delay(1000);\n}\n```\n\n- `setup()`: Initializes GPIO pin directions and communications. It runs exactly once when power is applied.\n- `loop()`: The infinite heartbeat of your robot. Once `setup()` finishes, the microcontroller jumps into `loop()` and orbits perpetually.\n\nRun the interactive lifecycle simulator below to watch `setup()` illuminate its beacon once, followed by the continuous orbit of `loop()`!",
        "quickCheck": [
          {
            "questionId": "qc_l2b_04_s01_q1",
            "question": "How many times does the code inside void setup() execute when an Arduino powers up?",
            "options": [
              "Exactly once at startup or after reset",
              "100 times per second",
              "Never"
            ],
            "correctIndex": 0,
            "explanation": "setup() runs once at the very beginning to configure pin modes and initialize hardware!",
            "warmupExplanation": "Setup is morning prep: you brush your teeth once before starting your day."
          },
          {
            "questionId": "qc_l2b_04_s01_q2",
            "question": "What happens when execution reaches the bottom of void loop()?",
            "options": [
              "It immediately jumps back to the top of loop() and runs again forever",
              "The Arduino turns off",
              "The code erases itself"
            ],
            "correctIndex": 0,
            "explanation": "loop() repeats continuously as long as the Arduino has power!",
            "warmupExplanation": "A loop goes round and round: sensing, thinking, and acting over and over again."
          }
        ]
      },
      {
        "stepId": "l2b_04_s02",
        "title": "Code Prediction Challenge",
        "type": "codeExperiment",
        "interactiveWidgetType": "engineeringPrediction",
        "markdownContent": "Analyze and predict how the microcontroller executes when code structure changes:\n\n### Prediction Challenge 1: Empty setup(), Active loop()\nIf `setup()` is completely empty, does the Arduino freeze?\n*Answer:* No! `setup()` finishes in nanoseconds and immediately begins cycling `loop()`.\n\n### Prediction Challenge 2: Active setup(), Empty loop()\nIf an LED is turned ON inside `setup()`, and `loop()` has no code inside its braces `{ }`, what does the LED do?\n*Answer:* The LED turns ON in `setup()` and stays ON forever! The microcontroller continues running `loop()` endlessly at 16 MHz, maintaining the pin voltage state.\n\n> **Core Principle**: A microcontroller never powers down or \"exits\" unless electrical power is disconnected."
      },
      {
        "stepId": "l2b_04_s03",
        "title": "Real-World Systems: NASA Mars Rovers & Embedded Firmware",
        "type": "visualExplanation",
        "markdownContent": "The `setup()` and `loop()` firmware architecture powers mission-critical robotics worldwide:\n\n- **NASA Mars Rovers (Curiosity & Perseverance)**: Execute diagnostic sensor self-tests upon wake-up (`setup()`), then run autonomous hazard-avoidance cycles continuously (`loop()`).\n- **Automotive Airbag Control Units**: Initialize SPI accelerometer calibrations at engine start, then monitor vehicle deceleration thresholds every 100 microseconds in an unbroken loop.\n- **Commercial Drones**: Zero out gyroscope bias on launch pads, then calculate motor thrust adjustments 400 times per second during flight."
      },
      {
        "stepId": "l2b_04_s04",
        "title": "Knowledge Check: setup() and loop()",
        "type": "quizCheckpoint",
        "markdownContent": "Test your knowledge on program structure.",
        "interactiveConfig": {
          "question": "What does setup() do?",
          "options": [
            "Runs once when the Arduino starts or resets",
            "Runs continuously forever",
            "Deletes the sketch"
          ],
          "correctIndex": 0,
          "explanation": "void setup() executes once upon microcontroller boot or hardware reset to initialize peripherals.",
          "questions": [
            {
              "question": "What does setup() do?",
              "options": [
                "Runs once when the Arduino starts or resets",
                "Runs continuously forever",
                "Deletes the sketch"
              ],
              "correctIndex": 0,
              "explanation": "void setup() executes once upon microcontroller boot or hardware reset to initialize peripherals."
            },
            {
              "question": "What does loop() normally do?",
              "options": [
                "Repeatedly runs the code placed inside it",
                "Selects the USB port",
                "Compiles the computer's operating system"
              ],
              "correctIndex": 0,
              "explanation": "void loop() is called repeatedly in a perpetual cycle to process real-time events."
            },
            {
              "question": "What happens if loop() is empty?",
              "options": [
                "The Arduino keeps running loop() empty endlessly",
                "The Arduino catches fire",
                "The Arduino powers down"
              ],
              "correctIndex": 0,
              "explanation": "A microcontroller never exits; it just keeps running the empty loop at full speed."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_05",
    "title": "Serial Monitor & Debugging",
    "summary": "Learn to talk to your computer with Serial.begin and Serial.println.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l2b_04"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_05_s01",
        "title": "What is Serial Communication?",
        "type": "story",
        "markdownContent": "Your Arduino board and computer can talk to each other over the USB cable using **Serial communication**. They send text messages back and forth, one bit at a time (serially).\n\nThis is incredibly useful! You can use it to send commands to the robot or have the robot tell you sensor values. The IDE has a built-in tool called the **Serial Monitor** (under the Tools menu) to view these messages.",
        "quickCheck": [
          {
            "questionId": "qc_l2b_05_s01_q1",
            "question": "What is the Serial Monitor in the Arduino IDE used for?",
            "options": [
              "Viewing diagnostic messages, text outputs, and sensor readings sent from the board",
              "Watching animated cartoons",
              "Listening to music"
            ],
            "correctIndex": 0,
            "explanation": "The Serial Monitor lets the Arduino \"speak\" to your computer screen using Serial.println()!",
            "warmupExplanation": "If your robot can't talk out loud yet, it sends text messages to the Serial Monitor."
          },
          {
            "questionId": "qc_l2b_05_s01_q2",
            "question": "What command initializes Serial communication at a speed of 9600 baud in setup()?",
            "options": [
              "Serial.begin(9600);",
              "startTalking();",
              "helloScreen();"
            ],
            "correctIndex": 0,
            "explanation": "Serial.begin(9600); wakes up the serial hardware and sets the baud rate to 9600 bits per second!",
            "warmupExplanation": "Serial.begin(9600) opens the telephone line so your Arduino can talk to your screen."
          }
        ]
      },
      {
        "stepId": "l2b_05_s02",
        "title": "Serial.begin() in setup()",
        "type": "codeExperiment",
        "markdownContent": "Before the Arduino can talk, you must initialize the Serial port in `setup()`.\n\n```cpp\nvoid setup() {\n  Serial.begin(9600);\n}\n```\n\nThe `9600` is the **baud rate** — the speed at which they talk (9600 bits per second). Both the Arduino and the Serial Monitor window must be set to the exact same baud rate, or the message will look like garbage text!"
      },
      {
        "stepId": "l2b_05_s03",
        "title": "Serial.println() in loop()",
        "type": "codeExperiment",
        "markdownContent": "Once initialized, use `Serial.println()` inside `loop()` to send text.\n\n```cpp\nvoid loop() {\n  Serial.println(\"Hello Monster Lab!\");\n  delay(1000);\n}\n```\n\nThis prints the text and moves to a new line (that's what the `ln` in `println` means). It's great for debugging! If your robot isn't moving, you can print a sensor's value to see what the Arduino is actually reading."
      },
      {
        "stepId": "l2b_05_s04",
        "title": "Serial Monitor Practice",
        "type": "story",
        "interactiveWidgetType": "serialMonitorSimulator",
        "markdownContent": "Try out the Serial Monitor simulator below. Type a command to see the output from the virtual Arduino!"
      },
      {
        "stepId": "l2b_05_s05",
        "title": "Baud Rate Mismatch",
        "type": "story",
        "interactiveWidgetType": "baudRateMismatchDemo",
        "markdownContent": "What happens if the baud rate in `Serial.begin(9600)` doesn't match the dropdown in the Serial Monitor? \n\nYou get garbage characters like `⸮⸮⸮`. See what happens in the demo below when the speeds don't match."
      },
      {
        "stepId": "l2b_05_s06",
        "title": "Knowledge Check: Serial Monitor",
        "type": "quizCheckpoint",
        "markdownContent": "Check your Serial knowledge.",
        "interactiveConfig": {
          "question": "What does Serial.begin() do?",
          "options": [
            "Initializes serial communication",
            "Turns on an LED",
            "Uploads the code"
          ],
          "correctIndex": 0,
          "explanation": "Serial.begin() prepares the hardware UART to send and receive text at a specific speed.",
          "questions": [
            {
              "question": "What does Serial.begin() do?",
              "options": [
                "Initializes serial communication",
                "Turns on an LED",
                "Uploads the code"
              ],
              "correctIndex": 0,
              "explanation": "Serial.begin() prepares the hardware UART to send and receive text at a specific speed."
            },
            {
              "question": "Why do we use Serial.println()?",
              "options": [
                "To print text and variables for debugging",
                "To reset the Arduino",
                "To make the code run faster"
              ],
              "correctIndex": 0,
              "explanation": "It sends readable text to the computer so you can see what the Arduino is doing inside."
            },
            {
              "question": "What happens if the baud rate on the computer doesn't match the Arduino?",
              "options": [
                "You see garbage characters (gibberish) instead of text",
                "The Arduino powers off",
                "The computer gets a virus"
              ],
              "correctIndex": 0,
              "explanation": "If the two devices expect different bit speeds, the text is interpreted incorrectly."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_06",
    "title": "Libraries Overview",
    "summary": "Learn what libraries are and how to include them to save time.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l2b_05"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_06_s01",
        "title": "What is a Library?",
        "type": "story",
        "interactiveWidgetType": "libraryConceptDiagram",
        "markdownContent": "A **library** is pre-written code that someone else created to make your life easier.\n\nInstead of writing 500 lines of complex math to talk to a temperature sensor, you can use a library that reduces it to one line: `sensor.readTemp();`.\n\nLibraries exist so engineers don't have to reinvent the wheel for every common component!",
        "quickCheck": [
          {
            "questionId": "qc_l2b_06_s01_q1",
            "question": "What is an Arduino library?",
            "options": [
              "A collection of pre-written functions that make it easy to control complex hardware like screens or servos",
              "A shelf of paper books",
              "A bundle of wires"
            ],
            "correctIndex": 0,
            "explanation": "Libraries provide high-level commands so you don't have to write tricky timing code from scratch!",
            "warmupExplanation": "Libraries are cheat sheets written by other engineers to make complex hardware easy."
          },
          {
            "questionId": "qc_l2b_06_s01_q2",
            "question": "How do you include a library at the top of your Arduino sketch?",
            "options": [
              "With an #include directive like #include <Servo.h>",
              "By typing \"PLEASE ADD LIBRARY\"",
              "With an emoji"
            ],
            "correctIndex": 0,
            "explanation": "#include <HeaderName.h> tells the compiler to import that library's tools into your program!",
            "warmupExplanation": "#include tells the computer: Bring in my favorite toolbox for this sketch!"
          }
        ]
      },
      {
        "stepId": "l2b_06_s02",
        "title": "How to Use a Library (#include)",
        "type": "codeExperiment",
        "interactiveWidgetType": "includeSyntaxDeconstruction",
        "markdownContent": "To use a library, you add an `#include` line at the very top of your sketch, before `setup()`.\n\n```cpp\n#include <Servo.h>\n```\n\nThis tells the compiler to attach the Servo motor code to your sketch before compiling. If you try to command a servo without including the library, the compiler will fail and give you an error."
      },
      {
        "stepId": "l2b_06_s03",
        "title": "Arduino Library Manager",
        "type": "story",
        "interactiveWidgetType": "libraryManagerSimulator",
        "markdownContent": "Where do libraries come from? \n\nThe Arduino IDE has a built-in **Library Manager** (under Tools > Manage Libraries). It's like an app store for code! You can search for the sensor or motor you are using, and click Install. Use the simulator below to find and install a library."
      },
      {
        "stepId": "l2b_06_s04",
        "title": "Knowledge Check: Libraries",
        "type": "quizCheckpoint",
        "markdownContent": "Test what you know about libraries.",
        "interactiveConfig": {
          "question": "What is a code library?",
          "options": [
            "Pre-written code that makes programming hardware easier",
            "A place to store batteries",
            "A type of USB cable"
          ],
          "correctIndex": 0,
          "explanation": "Libraries contain complex code wrapped into simple functions so you don't reinvent the wheel.",
          "questions": [
            {
              "question": "What is a code library?",
              "options": [
                "Pre-written code that makes programming hardware easier",
                "A place to store batteries",
                "A type of USB cable"
              ],
              "correctIndex": 0,
              "explanation": "Libraries contain complex code wrapped into simple functions so you don't reinvent the wheel."
            },
            {
              "question": "Which symbol is used to add a library to your sketch?",
              "options": [
                "#include",
                "Serial.begin",
                "void setup()"
              ],
              "correctIndex": 0,
              "explanation": "The #include directive tells the compiler to fetch the library files."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_07",
    "title": "ESD Safety",
    "summary": "Learn how to protect your electronics from Electrostatic Discharge.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l2b_06"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_07_s01",
        "title": "Workshop Safety: Electrostatic Discharge (ESD)",
        "type": "story",
        "interactiveWidgetType": "esdSafetyCheck",
        "markdownContent": "Microcontrollers are sensitive CMOS semiconductor devices. A spark of static electricity under 3,000 volts—too faint for human fingers to feel—can permanently destroy internal silicon transistor gate oxide layers!\n\n### The 3 Golden Rules of ESD Defense:\n1. **Touch Grounded Metal**: Touch a metal desk frame or radiator before handling boards to discharge accumulated static charge to 0V.\n2. **Avoid Static Generators**: Never assemble circuits directly on synthetic carpet or wool blankets.\n3. **Grip PCB Edges**: Always pick up boards by the outer fiberglass edges. Never touch exposed IC pins or header pins directly with your fingers.\n\nPractice proper ESD grounding in the interactive lab below to bring your static voltage potential down to a safe 0 Volts!",
        "quickCheck": [
          {
            "questionId": "qc_l2b_07_s01_q1",
            "question": "Why should you avoid touching conductive circuit pins when walking across carpet on dry days?",
            "options": [
              "Electrostatic shocks can damage sensitive silicon microchips inside the components",
              "Carpet causes fires",
              "Pins will get cold"
            ],
            "correctIndex": 0,
            "explanation": "Electrostatic discharge (ESD) can zap microscopic transistors inside chips before you even notice!",
            "warmupExplanation": "Static zaps tickle your fingers, but to a tiny chip, they feel like lightning bolts."
          },
          {
            "questionId": "qc_l2b_07_s01_q2",
            "question": "What is a simple, safe habit before handling bare circuit boards?",
            "options": [
              "Touch a grounded metal surface or hold boards by their outer edges",
              "Dip fingers in juice",
              "Rub your feet fast on a rug"
            ],
            "correctIndex": 0,
            "explanation": "Discharging static safely and holding boards by their edges protects delicate circuitry!",
            "warmupExplanation": "Hold boards gently by the corners, like a prized photo or trading card."
          }
        ]
      },
      {
        "stepId": "l2b_07_s02",
        "title": "Knowledge Check: Safety",
        "type": "quizCheckpoint",
        "markdownContent": "Check your ESD safety knowledge.",
        "interactiveConfig": {
          "question": "How should you pick up a circuit board?",
          "options": [
            "By the outer edges",
            "By the metal pins",
            "With a wet towel"
          ],
          "correctIndex": 0,
          "explanation": "Handling by the edges prevents direct discharge into sensitive silicon components.",
          "questions": [
            {
              "question": "How should you pick up a circuit board?",
              "options": [
                "By the outer edges",
                "By the metal pins",
                "With a wet towel"
              ],
              "correctIndex": 0,
              "explanation": "Handling by the edges prevents direct discharge into sensitive silicon components."
            },
            {
              "question": "What does touching grounded metal do?",
              "options": [
                "Discharges static electricity from your body safely",
                "Charges you up with electricity",
                "Turns on the computer"
              ],
              "correctIndex": 0,
              "explanation": "It equalizes your voltage potential to 0V, preventing a spark."
            },
            {
              "question": "Can you feel all sparks that destroy microchips?",
              "options": [
                "No, some destructive sparks are too small to feel",
                "Yes, they always hurt",
                "Sparks cannot destroy microchips"
              ],
              "correctIndex": 0,
              "explanation": "Sparks under 3000V are imperceptible to humans but deadly to microscopic transistors."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l2b_08",
    "title": "First Upload + Final Assessment",
    "summary": "Walk through your first upload and pass the final lesson quiz.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_2b",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l2b_07"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l2b_08_s01",
        "title": "First Upload Walkthrough",
        "type": "physicalTask",
        "interactiveWidgetType": "compilationPipelineSimulator",
        "markdownContent": "Time to put it all together and upload your first sketch! We will use the built-in Blink example.\n\n1. **Connect**: Plug the Arduino into USB.\n2. **Open Sketch**: In the IDE, go to File > Examples > 01.Basics > Blink.\n3. **Select Board**: Tools > Board > Arduino Uno.\n4. **Select Port**: Tools > Port > [Select your port].\n5. **Verify**: Click the Checkmark button to compile.\n6. **Upload**: Click the Right Arrow button to flash.\n7. **Observe**: Look at the board. The built-in LED near pin 13 should blink on and off every second!",
        "quickCheck": [
          {
            "questionId": "qc_l2b_08_s01_q1",
            "question": "When uploading a sketch, what indicator lights on the Arduino Uno flash to show data is transferring?",
            "options": [
              "The TX and RX LEDs flash rapidly",
              "The power light turns purple",
              "A bell rings"
            ],
            "correctIndex": 0,
            "explanation": "The TX (Transmit) and RX (Receive) LEDs blink rapidly as code bytes stream over the USB cable!",
            "warmupExplanation": "Watch the TX and RX lights dance when your code travels into the board!"
          },
          {
            "questionId": "qc_l2b_08_s01_q2",
            "question": "Congratulations! What have you mastered by completing Lesson 2B?",
            "options": [
              "The entire Arduino IDE workflow: writing sketches, selecting boards/ports, compiling, and flashing hardware",
              "Only how to click a mouse",
              "Nothing yet"
            ],
            "correctIndex": 0,
            "explanation": "You now know how to take ideas from your mind, turn them into code, and upload them to real hardware!",
            "warmupExplanation": "You are officially equipped with the master tools of an embedded software engineer!"
          }
        ]
      },
      {
        "stepId": "l2b_08_s02",
        "title": "Common Failures",
        "type": "story",
        "markdownContent": "If the LED doesn't blink, review these common failures:\n- **Upload Error (avrdude sync)**: You likely chose the wrong Port. Check the Tools > Port menu again.\n- **Compilation Error**: You might have accidentally deleted a semicolon or curly brace `{` in the code.\n- **No Lights At All**: The USB cable isn't pushed in fully, or the port is dead."
      },
      {
        "stepId": "l2b_08_s03",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of IDE compilation, USB device drivers, COM ports, and firmware lifecycles.",
        "interactiveConfig": {
          "question": "What does IDE stand for?",
          "options": [
            "Integrated Development Environment",
            "Internal Digital Engine",
            "Input Device Electronics"
          ],
          "correctIndex": 0,
          "explanation": "IDE stands for Integrated Development Environment—the unified coding and flashing workbench.",
          "questions": [
            {
              "question": "What does IDE stand for?",
              "options": [
                "Integrated Development Environment",
                "Internal Digital Engine",
                "Input Device Electronics"
              ],
              "correctIndex": 0,
              "explanation": "IDE stands for Integrated Development Environment—the unified coding and flashing workbench."
            },
            {
              "question": "What is an Arduino sketch?",
              "options": [
                "An Arduino program/project (.ino file)",
                "A battery",
                "A USB port"
              ],
              "correctIndex": 0,
              "explanation": "An Arduino sketch is the C++ program file containing setup() and loop() routines."
            },
            {
              "question": "What does compiling do?",
              "options": [
                "Converts source code into a form suitable for the target system",
                "Supplies electricity to the Arduino",
                "Connects the USB cable"
              ],
              "correctIndex": 0,
              "explanation": "The compiler translates human-readable C++ source text into hexadecimal machine opcodes."
            },
            {
              "question": "What does Upload do?",
              "options": [
                "Sends the program to the Arduino",
                "Deletes the Arduino",
                "Changes the USB cable"
              ],
              "correctIndex": 0,
              "explanation": "Upload uses the avrdude utility to transfer compiled hex binary through USB into microcontroller flash memory."
            },
            {
              "question": "Why must you select the correct board?",
              "options": [
                "Different boards can use different hardware and programming requirements",
                "The board name changes the USB cable",
                "The Arduino cannot store programs"
              ],
              "correctIndex": 0,
              "explanation": "Different microcontroller boards use distinct pin layouts, register maps, and flash sizes."
            },
            {
              "question": "What does the port identify?",
              "options": [
                "The computer's communication connection to the Arduino",
                "The Arduino's battery level",
                "The program's XP reward"
              ],
              "correctIndex": 0,
              "explanation": "The serial COM port provides the virtual UART communication link between host OS and the Uno board."
            },
            {
              "question": "What does Serial.begin() do?",
              "options": [
                "Initializes serial communication to talk to the computer",
                "Starts a motor",
                "Deletes the code"
              ],
              "correctIndex": 0,
              "explanation": "It prepares the hardware to send and receive text."
            },
            {
              "question": "What is the difference between setup() and loop()?",
              "options": [
                "setup() runs once, loop() runs repeatedly forever",
                "setup() is optional, loop() is not",
                "setup() compiles code, loop() uploads it"
              ],
              "correctIndex": 0,
              "explanation": "setup() initializes hardware once on boot. loop() cycles endlessly to process real-time events."
            }
          ]
        }
      }
    ],
    "xpReward": 25
  },
  {
    "id": "l03_01",
    "title": "What Is a Library?",
    "summary": "Imagine you want your monster robot to speak numbers on an LCD display screen or steer a robotic arm with a motor.",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l2b_08"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_01_s01",
        "title": "What Is a Library?",
        "type": "story",
        "markdownContent": "Welcome to Monster Lab! Imagine you want your monster robot to speak numbers on an LCD display screen or steer a robotic arm with a motor. 🤖\n\nInside the screen or motor, thousands of tiny electrical pulses have to happen in the exact right microsecond pattern. If you had to write every single pulse, every timing rule, and every wire signal from scratch, building a simple blinking robot would take months!\n\nLuckily, you don't have to reinvent the wheel! In the coding world, expert engineers have already figured out those tricky signals and bundled them into neat packages called **Libraries**.\n\nA **library** is a pre-built toolbox of reusable code written by other friendly engineers. Instead of writing 500 lines of complex wire commands, you just use simple actions like `lcd.print(\"Monster Lab!\");` or `servo.write(90);`.\n\nThink of a library like a recipe book for your monster: you don't need to reinvent bread every time you make a sandwich—you just follow the recipe!",
        "quickCheck": [
          {
            "questionId": "qc_l03_s01_q1",
            "question": "What is a software library in programming?",
            "options": [
              "A collection of pre-written, reusable code tools that makes building projects easier",
              "A physical bookshelf where you store robot batteries",
              "A piece of metal used to solder electronic parts together"
            ],
            "correctIndex": 0,
            "explanation": "A library is a collection of pre-written code that provides helpful functions so you don't have to write everything from scratch.",
            "warmupExplanation": "Think of a library as a handy toolkit: someone else made the tools so you can build your robot faster!"
          },
          {
            "questionId": "qc_l03_s01_q2",
            "question": "Why do programmers use libraries instead of writing every tiny instruction themselves?",
            "options": [
              "To save time and avoid re-solving difficult hardware problems",
              "Because microcontrollers refuse to run any custom code",
              "To make their computer run out of memory"
            ],
            "correctIndex": 0,
            "explanation": "Libraries save huge amounts of time and prevent tricky bugs by reusing proven solutions written by experienced engineers.",
            "warmupExplanation": "Reusing reliable tools lets you focus on building fun robot features instead of debugging low-level timing pulses."
          }
        ]
      },
      {
        "stepId": "l03_01_s02",
        "title": "How Libraries Work: The Software Stack",
        "type": "visualExplanation",
        "markdownContent": "### The Monster Software Stack: Layers of Abstraction\n\nHow does a friendly line of code like `lcd.print(\"ROAR!\")` actually make physical letters light up on your robot's screen? It all happens through **layers of abstraction**!\n\n```\n+-------------------------------------------------------+\n|  YOUR SKETCH: lcd.print(\"ROAR!\");                     |\n|  (Easy, human-friendly monster commands)             |\n+-------------------------------------------------------+\n                          │\n                          ▼\n+-------------------------------------------------------+\n|  LIBRARY: LiquidCrystal_I2C                           |\n|  (Translates letters into I2C bus bytes & ASCII codes)|\n+-------------------------------------------------------+\n                          │\n                          ▼\n+-------------------------------------------------------+\n|  ARDUINO CORE & REGISTERS: Wire.h / TWDR / TWCR       |\n|  (Wiggles SDA & SCL pins with microsecond clock ticks)|\n+-------------------------------------------------------+\n                          │\n                          ▼\n+-------------------------------------------------------+\n|  PHYSICAL HARDWARE: 16x2 LCD + HD44780 Controller     |\n|  (Liquid crystals twist and display photons!)        |\n+-------------------------------------------------------+\n```\n\nWithout the library, your sketch would have to manage register addresses (`0x27`), bitwise shifts, clock pulse delays, and 4-bit nibble transfers manually. With the library, all of that hard work is hidden inside clean, reusable tools!"
      },
      {
        "stepId": "l03_01_s03",
        "title": "Raw Registers vs. Clean Abstraction",
        "type": "codeExperiment",
        "interactiveWidgetType": "libraryConceptDiagram",
        "markdownContent": "Let's see the dramatic difference between programming hardware with and without a library!\n\nExplore both tabs in the interactive diagram below:\n1. Check the **Without Library** tab to see the hundreds of lines of cryptic register manipulation and timing pulses needed just to write one letter.\n2. Switch to the **With Library** tab to see how a library reduces all that complexity to a clean, readable one-liner!\n\nNotice how much time and energy libraries save you when building robots.",
        "interactiveConfig": {
          "title": "The Power of Libraries: Raw Registers vs Clean Abstraction"
        }
      },
      {
        "stepId": "l03_01_s04",
        "title": "Knowledge Check: Library Fundamentals",
        "type": "quizCheckpoint",
        "markdownContent": "Check what you've learned about software libraries and abstraction layers!",
        "interactiveConfig": {
          "question": "What does a library hide from the programmer?",
          "options": [
            "Complex low-level hardware timing, protocols, and register controls",
            "The USB cable connecting the computer",
            "The battery voltage of the wall outlet"
          ],
          "correctIndex": 0,
          "explanation": "Libraries provide an abstraction layer that handles intricate hardware protocols and timing pulses so you can focus on building your robot's behavior.",
          "questions": [
            {
              "question": "What does a library hide from the programmer?",
              "options": [
                "Complex low-level hardware timing, protocols, and register controls",
                "The USB cable connecting the computer",
                "The battery voltage of the wall outlet"
              ],
              "correctIndex": 0,
              "explanation": "Libraries provide an abstraction layer that handles intricate hardware protocols and timing pulses so you can focus on building your robot's behavior."
            },
            {
              "question": "What is the primary benefit of 'abstraction' in robotics code?",
              "options": [
                "You can use simple commands like print() instead of managing microsecond electrical pulses",
                "It turns off the Arduino to save room power",
                "It replaces the microcontroller with a cardboard cutout"
              ],
              "correctIndex": 0,
              "explanation": "Abstraction lets programmers interact with hardware using intuitive commands rather than calculating low-level wire signals."
            },
            {
              "question": "Who writes Arduino libraries?",
              "options": [
                "Open-source community engineers, hardware makers, and experienced developers",
                "Only computer robots from the future",
                "Nobody, libraries generate randomly on every reboot"
              ],
              "correctIndex": 0,
              "explanation": "Arduino libraries are created and shared by generous engineers, chip manufacturers, and hobbyists worldwide."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_02",
    "title": "Libraries in the Real World",
    "summary": "Where do you see libraries in real robotics and everyday gadgets?",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l03_01"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_02_s01",
        "title": "Libraries in the Real World",
        "type": "story",
        "markdownContent": "Where do you see libraries in real robotics and everyday gadgets? Almost everywhere!\n\nEvery cool gadget around you uses specialized libraries to talk to different components:\n\n1. **Character Displays (LCDs)**: An LCD library lets a smart microwave or 3D printer print text without worrying about how liquid crystals twist and turn.\n2. **Servo Motors**: A servo library lets an animatronic dinosaur or robot arm turn to an exact angle like 45° or 90° with a single command.\n3. **Sensors (Temperature & Distance)**: Sensor libraries turn electrical voltages into readable numbers like `22°C` or `15 cm`.\n4. **Motor Drivers**: Motor libraries control robot wheels going forward, backward, or spinning on a dime.\n5. **Sound & Buzzers**: Tone libraries create music notes and sound effects for games.\n6. **Communication Modules**: Radio and Bluetooth libraries let robots send secret messages to each other wirelessly!\n\nJust like a carpenter brings different specialized tools—a hammer, a saw, and a ruler—your robot program brings in different libraries for each cool part it controls.",
        "quickCheck": [
          {
            "questionId": "qc_l03_s02_q1",
            "question": "Which type of library would you choose if your monster needs to steer a robot arm to an angle?",
            "options": [
              "A servo motor library",
              "A sound playback library",
              "A weather forecast library"
            ],
            "correctIndex": 0,
            "explanation": "Servo motors specialize in moving arms and wheels to precise angles, so a servo library provides the right angle commands.",
            "warmupExplanation": "Look at the hardware you want to control: arms and steering mechanisms use servo motors!"
          },
          {
            "questionId": "qc_l03_s02_q2",
            "question": "Can a single robot sketch use more than one library at the same time?",
            "options": [
              "Yes, you can use multiple libraries together for different parts",
              "No, an Arduino can only load one single library per sketch",
              "No, using two libraries causes the board to catch fire"
            ],
            "correctIndex": 0,
            "explanation": "Robots routinely combine multiple libraries—for example, one library for a screen and another library for a distance sensor!",
            "warmupExplanation": "Just like a carpenter uses both a hammer and a tape measure, a sketch can include multiple libraries."
          }
        ]
      },
      {
        "stepId": "l03_02_s02",
        "title": "Cooperating Libraries in a Robot System",
        "type": "visualExplanation",
        "markdownContent": "### A Robot's Multi-Tool Backpack\n\nReal robots almost never rely on just a single library. A full-featured monster robot integrates senses, displays, and actuators simultaneously!\n\n| Robot System | Real-World Hardware | Popular Arduino Library | Example Action |\n| :--- | :--- | :--- | :--- |\n| **Face / Display** | 16x2 Character LCD | `LiquidCrystal_I2C.h` | `lcd.print(\"Scanning...\");` |\n| **Arm / Steering** | SG90 Micro Servo | `Servo.h` | `clawServo.write(45);` |\n| **Senses / Range** | HC-SR04 Ultrasonic Sensor | `NewPing.h` | `int cm = sonar.ping_cm();` |\n| **Clock / Time** | DS3231 Real Time Clock | `RTClib.h` | `DateTime now = rtc.now();` |\n| **Sound / Voice** | Piezo Buzzer / Speaker | `Tone.h` | `tone(8, 440, 200);` |\n\nBecause each library is self-contained, you can include multiple `.h` headers at the top of a single sketch. They cooperate smoothly to create complex, intelligent behavior!"
      },
      {
        "stepId": "l03_02_s03",
        "title": "Hands-On Hardware: The Real LCD Backpack",
        "type": "physicalTask",
        "interactiveWidgetType": "lcdContrastSimulator",
        "markdownContent": "One of the most famous real-world library components in your kit is the **16x2 I2C Character LCD (comp_07)**.\n\nOn the back of the LCD board is a small black chip called an **I2C backpack**, featuring a tiny blue box with a brass adjustment screw (the contrast potentiometer).\n\nIf the contrast is adjusted incorrectly, the screen either shows nothing at all or solid white blocks! Even with perfect library code, bad contrast hides your text.\n\nTry the simulator below: rotate the potentiometer screw to find the sweet spot where your monster's status text is crisp and readable!",
        "interactiveConfig": {
          "title": "LCD Contrast Tuning: The Blue Potentiometer"
        }
      },
      {
        "stepId": "l03_02_s04",
        "title": "Knowledge Check: Real-World Libraries",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of how libraries power real-world gadgets and robotic peripherals.",
        "interactiveConfig": {
          "question": "What happens when you adjust the blue trimmer potentiometer on an LCD backpack?",
          "options": [
            "It adjusts the contrast of the display characters so text becomes visible",
            "It changes the Arduino's CPU speed",
            "It changes the Wi-Fi password"
          ],
          "correctIndex": 0,
          "explanation": "The potentiometer on the LCD backpack controls the contrast voltage feeding the liquid crystal elements, tuning character sharpness.",
          "questions": [
            {
              "question": "What happens when you adjust the blue trimmer potentiometer on an LCD backpack?",
              "options": [
                "It adjusts the contrast of the display characters so text becomes visible",
                "It changes the Arduino's CPU speed",
                "It changes the Wi-Fi password"
              ],
              "correctIndex": 0,
              "explanation": "The potentiometer on the LCD backpack controls the contrast voltage feeding the liquid crystal elements, tuning character sharpness."
            },
            {
              "question": "Which component would you pair with the Servo.h library?",
              "options": [
                "A 9g micro servo motor to rotate an arm to a set degree",
                "A standard resistor to change its ohms",
                "A 9V battery snap"
              ],
              "correctIndex": 0,
              "explanation": "Servo.h is designed specifically to output precise PWM pulses for controlling servo motor angles."
            },
            {
              "question": "Why do engineers split robot functionality across several focused libraries?",
              "options": [
                "Modular libraries keep code clean, lightweight, and easy to maintain",
                "Because microcontrollers can only read files with fewer than 10 lines",
                "Because libraries delete each other if they do too much"
              ],
              "correctIndex": 0,
              "explanation": "Modular design allows engineers to pick only the exact drivers their project needs without wasting microcontroller memory."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_03",
    "title": "Your First Library",
    "summary": "Now let's see how your sketch invites a library to join the party!",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l03_02"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_03_s01",
        "title": "Your First Library",
        "type": "story",
        "markdownContent": "Now let's see how your sketch invites a library to join the party!\n\nAt the very top of your Arduino code, before `setup()` and before `loop()`, you write a special line called an **`#include` directive**:\n\n```cpp\n#include <LiquidCrystal_I2C.h>\n```\n\nLet's break down this secret handshake:\n- **`#` (Pound / Hash)**: Tells the preprocessor that this is a special instruction before normal compilation starts.\n- **`include`**: The magic word that says, *\"Please bring in all the tools from this package!\"*\n- **`< >` (Angle Brackets)**: Tells the computer to search your installed library collection for this name.\n- **`.h` (Header File)**: A file ending in `.h` is the table of contents of the library, listing all the available commands and features.\n\n> ⚠️ **Watch Out**: Preprocessor lines like `#include` do **NOT** use a semicolon (`;`) at the end! Adding one is a classic beginner typo.",
        "quickCheck": [
          {
            "questionId": "qc_l03_s03_q1",
            "question": "Where in your Arduino sketch should you place an #include statement?",
            "options": [
              "At the very top of the file, before setup()",
              "Inside the loop() function between curly braces",
              "At the very bottom after the sketch ends"
            ],
            "correctIndex": 0,
            "explanation": "#include directives belong at the very top of the sketch so the compiler knows about the library tools before any functions use them.",
            "warmupExplanation": "Always invite your tools first! Include libraries at the very top of your sketch."
          },
          {
            "questionId": "qc_l03_s03_q2",
            "question": "Does an #include directive end with a semicolon (;)?",
            "options": [
              "No, preprocessor directives like #include do not use a semicolon",
              "Yes, every single line in C++ must always end with a semicolon",
              "Yes, but only on Mondays"
            ],
            "correctIndex": 0,
            "explanation": "#include is a preprocessor command, so adding a semicolon produces a compiler syntax error.",
            "warmupExplanation": "Remember the special rule for #include: no semicolon at the end of the line!"
          }
        ]
      },
      {
        "stepId": "l03_03_s02",
        "title": "The Preprocessor Pipeline: Behind #include",
        "type": "visualExplanation",
        "markdownContent": "### What Really Happens During `#include`?\n\nBefore the C++ compiler translates your code into machine instructions (binary 0s and 1s), a special tool called the **C++ Preprocessor** scans your sketch.\n\n```\n+-----------------------+\n|  Your Sketch (.ino)   |\n|  #include <Servo.h>   | ────┐\n|  void setup() {...}   |     │\n+-----------------------+     │\n                              ▼\n+-----------------------+   [PREPROCESSOR STEP]\n|  Servo.h Header File  | ──► Replaces #include line with\n|  class Servo {...};   |     the actual header declarations\n+-----------------------+     │\n                              ▼\n                    +-------------------+\n                    |  Full Translation |\n                    |  Ready to Compile!|\n                    +-------------------+\n```\n\n### The Rules of `#include`\n1. **Placement**: Always place `#include` directives at the very top of your sketch file.\n2. **Angle Brackets (`< >`) vs Quotes (`\" \"`)**:\n   - `<LibraryName.h>` searches system and installed library folders.\n   - `\"MyFile.h\"` searches your local sketch folder first.\n3. **No Semicolon**: Preprocessor directives are NOT C++ statements; ending them with `;` triggers a compile error!"
      },
      {
        "stepId": "l03_03_s03",
        "title": "Deconstructing the #include Directive",
        "type": "codeExperiment",
        "interactiveWidgetType": "includeSyntaxDeconstruction",
        "markdownContent": "Let's inspect every single character of the `#include` directive under our code microscope!\n\nTap each token in the interactive deconstruction tool below:\n- Examine the `#` preprocessor flag\n- Explore the `include` directive keyword\n- Inspect the `< >` angle brackets and the `.h` header filename\n\nPay close attention to the common mistakes for each token so you avoid rookie compilation traps!",
        "interactiveConfig": {}
      },
      {
        "stepId": "l03_03_s04",
        "title": "Knowledge Check: Syntax & Preprocessor",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of preprocessor headers and `#include` syntax.",
        "interactiveConfig": {
          "question": "What does the .h file extension in <LiquidCrystal_I2C.h> stand for?",
          "options": [
            "Header file",
            "Hardware file",
            "Help file"
          ],
          "correctIndex": 0,
          "explanation": ".h stands for Header file. It contains the class declarations, constants, and function prototypes of the library.",
          "questions": [
            {
              "question": "What does the .h file extension in <LiquidCrystal_I2C.h> stand for?",
              "options": [
                "Header file",
                "Hardware file",
                "Help file"
              ],
              "correctIndex": 0,
              "explanation": ".h stands for Header file. It contains the class declarations, constants, and function prototypes of the library."
            },
            {
              "question": "What happens if you type '#include <Servo.h>;' with a semicolon at the end?",
              "options": [
                "The preprocessor/compiler flags a syntax error because preprocessor directives do not use semicolons",
                "The servo turns clockwise automatically",
                "The sketch uploads twice as fast"
              ],
              "correctIndex": 0,
              "explanation": "Preprocessor commands are not regular C++ statements and do not use semicolons. Adding one causes compilation errors."
            },
            {
              "question": "What do the angle brackets < > indicate around a library name?",
              "options": [
                "They tell the preprocessor to look in the installed library search paths",
                "They mark the text as an emoji",
                "They tell the Arduino to erase the chip"
              ],
              "correctIndex": 0,
              "explanation": "Angle brackets instruct the preprocessor to search standard library installation directories for the header file."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_04",
    "title": "Find and Install",
    "summary": "Where do you get libraries?",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l03_03"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_04_s01",
        "title": "Find and Install",
        "type": "story",
        "markdownContent": "Where do you get libraries? Inside the Arduino IDE, there is a built-in search tool called the **Library Manager**!\n\nThink of the Library Manager like an **App Store for code**. Thousands of community engineers publish open-source drivers there for free.\n\n### How to Install in Arduino IDE:\n1. Open the Arduino IDE on your computer.\n2. Click **Tools > Manage Libraries...** (or click the stacked books icon on the left navigation bar).\n3. In the search box, type the name of the library (for example, `LiquidCrystal I2C`).\n4. Find the version by Frank de Brabander and click **INSTALL**.\n5. The IDE downloads the library files into your computer's `libraries` folder automatically!\n\nTry the interactive Library Manager below: search for `LiquidCrystal_I2C` and press Install to watch how packages download and register!",
        "quickCheck": [
          {
            "questionId": "qc_l03_s04_q1",
            "question": "Where inside the Arduino IDE can you search for and install community libraries?",
            "options": [
              "Tools > Manage Libraries (or the Library Manager sidebar tab)",
              "File > Save As",
              "Help > About Arduino"
            ],
            "correctIndex": 0,
            "explanation": "Tools > Manage Libraries opens the Arduino Library Manager, which searches the global library index.",
            "warmupExplanation": "The Library Manager is your built-in tool for discovering and installing code packages."
          },
          {
            "questionId": "qc_l03_s04_q2",
            "question": "What happens if your sketch has #include <CoolSensor.h>, but you forgot to install CoolSensor?",
            "options": [
              "The compiler shows a 'No such file or directory' error and halts",
              "The Arduino automatically invents the sensor code",
              "The computer plays a musical song"
            ],
            "correctIndex": 0,
            "explanation": "If a library isn't installed, the compiler cannot find the header file and halts with 'No such file or directory'.",
            "warmupExplanation": "If the compiler can't find your tool in the workshop, it stops and tells you the file is missing!"
          }
        ]
      },
      {
        "stepId": "l03_04_s02",
        "title": "Where Libraries Live on Your Machine",
        "type": "visualExplanation",
        "markdownContent": "### Inside Your Computer's Library Vault\n\nWhen you press **INSTALL** in the Library Manager, what actually happens to your computer's filesystem? It downloads and organizes the files into a dedicated directory:\n\n```\nDocuments/\n└── Arduino/\n    └── libraries/\n        └── LiquidCrystal_I2C/\n            ├── library.properties    <-- Metadata (Author, version, dependencies)\n            ├── src/\n            │   ├── LiquidCrystal_I2C.h   <-- The header file (#include)\n            │   └── LiquidCrystal_I2C.cpp <-- The actual C++ implementation\n            └── examples/\n                └── HelloWorld/\n                    └── HelloWorld.ino    <-- Working demonstration sketch!\n```\n\n### The Library Lifecycle\n1. **Search**: The IDE queries the online Arduino library registry index.\n2. **Download**: A ZIP archive containing headers, source, and examples is fetched.\n3. **Extraction**: Files are unpacked into your `Arduino/libraries/` folder.\n4. **Indexing**: The compiler immediately recognizes the new header in your `#include` lines!"
      },
      {
        "stepId": "l03_04_s03",
        "title": "Library Manager Simulator",
        "type": "physicalTask",
        "interactiveWidgetType": "libraryManagerSimulator",
        "markdownContent": "Practice installing a library using the simulated Arduino Library Manager workbench!\n\n1. Type or verify the library search term `LiquidCrystal_I2C` in the search bar.\n2. Locate the package by **Frank de Brabander**.\n3. Press **INSTALL** and watch the simulator establish connection, download archive files, unpack headers, and index the library.\n4. Confirm the status badges flip to **INSTALLED**!",
        "interactiveConfig": {}
      },
      {
        "stepId": "l03_04_s04",
        "title": "Knowledge Check: Library Manager",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your mastery of library discovery and installation mechanics.",
        "interactiveConfig": {
          "question": "What subfolder inside an installed library contains sample sketches to test?",
          "options": [
            "The examples/ folder",
            "The trash/ folder",
            "The temp/ folder"
          ],
          "correctIndex": 0,
          "explanation": "The examples/ directory contains verified working sketches that demonstrate how to use the library.",
          "questions": [
            {
              "question": "What subfolder inside an installed library contains sample sketches to test?",
              "options": [
                "The examples/ folder",
                "The trash/ folder",
                "The temp/ folder"
              ],
              "correctIndex": 0,
              "explanation": "The examples/ directory contains verified working sketches that demonstrate how to use the library."
            },
            {
              "question": "If you install a library on your computer, do you need to reinstall it for every new sketch you create?",
              "options": [
                "No, once installed in your Arduino libraries folder, any sketch on your computer can use it",
                "Yes, you must download it again every time you save a sketch",
                "Yes, libraries expire after 10 minutes"
              ],
              "correctIndex": 0,
              "explanation": "Libraries are installed globally in your Arduino libraries folder and remain accessible to all your sketches."
            },
            {
              "question": "What is the purpose of the library.properties file?",
              "options": [
                "It holds metadata such as the library version, author, and compatible board architectures",
                "It contains the Arduino's electrical circuit schematic",
                "It stores audio files for robot speech"
              ],
              "correctIndex": 0,
              "explanation": "library.properties contains essential metadata like name, author, version, and architecture compatibility."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_05",
    "title": "Use an Example",
    "summary": "Here is the best secret every pro engineer knows: every good library comes with working example code!",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l03_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_05_s01",
        "title": "Use an Example",
        "type": "story",
        "markdownContent": "Here is the best secret every pro engineer knows: **every good library comes with working example code!**\n\nWhen you install a library, you don't have to guess how to use it. You can open a ready-to-run sketch directly:\n- In the Arduino IDE: go to **File > Examples > LiquidCrystal I2C > HelloWorld**.\n\nLook at this classic starter sketch:\n\n```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// Create the screen helper: address 0x27, 16 columns, 2 rows\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();          // Wake up the screen\n  lcd.backlight();     // Turn on the background light\n  lcd.setCursor(0, 0); // Start at column 0, row 0\n  lcd.print(\"Monster Lab!\");\n}\n\nvoid loop() {\n  // Nothing needed in the loop for a static message!\n}\n```\n\nStarting with an official example is the safest way to verify that your wiring and library installation both work perfectly before you write custom code!",
        "quickCheck": [
          {
            "questionId": "qc_l03_s05_q1",
            "question": "Where can you find pre-made starter sketches that show how to use an installed library?",
            "options": [
              "Under File > Examples in the Arduino IDE menu",
              "Under Edit > Cut in the top menu",
              "Inside the computer's recycle bin"
            ],
            "correctIndex": 0,
            "explanation": "The File > Examples menu lists built-in example sketches provided by installed libraries.",
            "warmupExplanation": "Libraries include working examples under File > Examples so you can test them immediately!"
          },
          {
            "questionId": "qc_l03_s05_q2",
            "question": "Why is testing an official example sketch a smart first step when trying new hardware?",
            "options": [
              "It proves your wiring and library work before you write your own code",
              "It deletes old sketches so you have more disk space",
              "It makes the Arduino board waterproof"
            ],
            "correctIndex": 0,
            "explanation": "If an official example works, you know your hardware, wires, and library are good. If your custom code later fails, you know exactly where the bug is!",
            "warmupExplanation": "Starting with known working code eliminates guesswork about whether the problem is in your wiring or your code."
          }
        ]
      },
      {
        "stepId": "l03_05_s02",
        "title": "Anatomy of a Hardware Starter Sketch",
        "type": "visualExplanation",
        "markdownContent": "### Dissecting the Official Starter Sketch\n\nWhen you open **File > Examples > LiquidCrystal I2C > HelloWorld**, you see four critical structural zones:\n\n```cpp\n// 1. HEADER INCLUSION ZONE\n#include <Wire.h>               // I2C bus communications\n#include <LiquidCrystal_I2C.h>  // LCD driver commands\n\n// 2. CONSTRUCTOR / OBJECT CREATION\nLiquidCrystal_I2C lcd(0x27, 16, 2); // Address 0x27, 16 columns, 2 rows\n\n// 3. HARDWARE INITIALIZATION ZONE\nvoid setup() {\n  lcd.init();          // Wake up controller\n  lcd.backlight();     // Turn on backlight LED\n  lcd.setCursor(0, 0); // Position cursor\n  lcd.print(\"Monster Lab!\");\n}\n\n// 4. MAIN LOOP RUNTIME\nvoid loop() {\n  // Static messages remain on screen without constant refreshing!\n}\n```\n\n### Why `Wire.h` is Included\nThe `LiquidCrystal_I2C` library communicates over the Arduino's I2C bus (pins A4 and A5 on the Uno). It relies on the built-in Arduino `Wire.h` library to send the physical I2C clock and data packets!"
      },
      {
        "stepId": "l03_05_s03",
        "title": "Displaying Your First Message on Hardware",
        "type": "physicalTask",
        "interactiveWidgetType": "lcdContrastSimulator",
        "markdownContent": "When you flash an example sketch to physical hardware, there's one physical trick that trips up almost every beginner!\n\nYou upload the code successfully, the backlight turns on, but... **no letters appear!** Is the code broken? Is the Arduino dead?\n\nNope! The LCD contrast potentiometer on the back of the backpack simply needs to be adjusted with a small screwdriver.\n\nInteract with the contrast simulator below: adjust the potentiometer until `Monster Lab!` displays sharp, high-contrast characters on the screen!",
        "interactiveConfig": {
          "title": "LCD Contrast Tuning: Getting the Example to Show"
        }
      },
      {
        "stepId": "l03_05_s04",
        "title": "Knowledge Check: Working with Examples",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of opening, running, and verifying library example sketches.",
        "interactiveConfig": {
          "question": "What does LiquidCrystal_I2C lcd(0x27, 16, 2); tell the program?",
          "options": [
            "Create an LCD object at I2C address 0x27 with 16 columns and 2 rows",
            "Buy an LCD from website #27 for 16 dollars",
            "Turn off pins 16 and 2"
          ],
          "correctIndex": 0,
          "explanation": "The constructor parameters configure the I2C bus address (0x27) and screen dimensions (16 characters wide by 2 lines tall).",
          "questions": [
            {
              "question": "What does LiquidCrystal_I2C lcd(0x27, 16, 2); tell the program?",
              "options": [
                "Create an LCD object at I2C address 0x27 with 16 columns and 2 rows",
                "Buy an LCD from website #27 for 16 dollars",
                "Turn off pins 16 and 2"
              ],
              "correctIndex": 0,
              "explanation": "The constructor parameters configure the I2C bus address (0x27) and screen dimensions (16 characters wide by 2 lines tall)."
            },
            {
              "question": "Why does the example sketch include <Wire.h> alongside <LiquidCrystal_I2C.h>?",
              "options": [
                "Wire.h handles the low-level I2C hardware bus communication used by the LCD backpack",
                "Wire.h is required to supply electricity to the computer mouse",
                "Wire.h turns the Arduino into a speaker"
              ],
              "correctIndex": 0,
              "explanation": "Wire.h is Arduino's standard I2C library; LiquidCrystal_I2C depends on Wire.h to send electrical packets."
            },
            {
              "question": "If your example sketch compiles and uploads with zero errors but the screen shows only solid blank rectangles, what should you inspect first?",
              "options": [
                "Adjust the blue contrast potentiometer on the back of the LCD backpack",
                "Smash the Arduino with a hammer",
                "Reinstall Windows or macOS"
              ],
              "correctIndex": 0,
              "explanation": "Solid rectangles or completely blank screens almost always mean the contrast trimmer potentiometer needs tuning."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_06",
    "title": "Change the Example",
    "summary": "The fun of engineering begins when you change someone else's example!",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l03_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_06_s01",
        "title": "Change the Example",
        "type": "story",
        "markdownContent": "The fun of engineering begins when you change someone else's example! 🛠️\n\nLet's modify our starter sketch to display a two-line greeting for your robot:\n\n```cpp\nvoid setup() {\n  lcd.init();\n  lcd.backlight();\n\n  // Line 1 (Top row)\n  lcd.setCursor(0, 0);\n  lcd.print(\"Monster: Sparky\");\n\n  // Line 2 (Bottom row)\n  lcd.setCursor(0, 1);\n  lcd.print(\"Status: ONLINE\");\n}\n```\n\n### Making Predictions\nNotice the cursor coordinates: `lcd.setCursor(col, row)`. In computer programming, rows and columns start counting from **0**, not 1!\n- `(0, 0)` is the very first character of the **top row**.\n- `(0, 1)` is the very first character of the **bottom row**.\n\nWhat happens if you change `\"ONLINE\"` to `\"SLEEPING\"`? The screen updates with your new word when you re-upload! By changing one line at a time, you learn how the library controls the physical world.",
        "quickCheck": [
          {
            "questionId": "qc_l03_s06_q1",
            "question": "In lcd.setCursor(0, 1), which row of a 16x2 display does the cursor move to?",
            "options": [
              "The second row (bottom row)",
              "The first row (top row)",
              "Off the screen completely"
            ],
            "correctIndex": 0,
            "explanation": "Because coordinates are zero-indexed, row 0 is the top row and row 1 is the bottom row.",
            "warmupExplanation": "Remember that computers start counting at 0! Row 0 is the top, row 1 is the bottom."
          },
          {
            "questionId": "qc_l03_s06_q2",
            "question": "When you want to display your robot's name instead of 'Monster Lab!', what should you modify in the sketch?",
            "options": [
              "The text inside the quotation marks in lcd.print(\"...\")",
              "The #include line at the top",
              "The name of the Arduino board in the Tools menu"
            ],
            "correctIndex": 0,
            "explanation": "The characters inside the quotation marks in lcd.print(...) determine the exact message printed on the screen.",
            "warmupExplanation": "Change the text inside the quotes to print whatever message your monster wants to say!"
          }
        ]
      },
      {
        "stepId": "l03_06_s02",
        "title": "The 16x2 Display Coordinate Grid",
        "type": "visualExplanation",
        "markdownContent": "### Understanding the LCD Matrix Grid\n\nA 16x2 LCD display is arranged as a grid of character cells: **16 columns wide** (numbered 0 to 15) and **2 rows tall** (numbered 0 to 1):\n\n```\nCol:  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15\n    ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐\nRow0│ M │ o │ n │ s │ t │ e │ r │ : │   │ S │ p │ a │ r │ k │ y │   │\n    ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤\nRow1│ S │ t │ a │ t │ u │ s │ : │   │ O │ N │ L │ I │ N │ E │   │   │\n    └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘\n```\n\n### Coordinate Rules\n- **Column 0, Row 0** (`lcd.setCursor(0, 0)`): Top-left corner.\n- **Column 0, Row 1** (`lcd.setCursor(0, 1)`): Bottom-left corner.\n- **Column 15, Row 1** (`lcd.setCursor(15, 1)`): Bottom-right corner.\n\nIf you print more than 16 characters on Row 0 without setting the cursor to Row 1, the extra characters either wrap unpredictably or vanish into memory!"
      },
      {
        "stepId": "l03_06_s03",
        "title": "Catching Code Modification Bugs",
        "type": "codeExperiment",
        "interactiveWidgetType": "syntaxErrorDebugger",
        "markdownContent": "When modifying example code, beginners frequently make small syntax mistakes like forgetting a semicolon, mixing up uppercase/lowercase letters, or misplacing braces.\n\nPut on your debugging goggles! Inspect each highlighted bug in the interactive editor below and apply the fix to achieve a successful compilation!",
        "interactiveConfig": {}
      },
      {
        "stepId": "l03_06_s04",
        "title": "Knowledge Check: Coordinates & Code Edits",
        "type": "quizCheckpoint",
        "markdownContent": "Check what you know about cursor coordinates and editing example code.",
        "interactiveConfig": {
          "question": "What are the coordinates for the top-right corner of a 16x2 LCD?",
          "options": [
            "Column 15, Row 0",
            "Column 16, Row 1",
            "Column 0, Row 15"
          ],
          "correctIndex": 0,
          "explanation": "Because columns count from 0 to 15 and rows count 0 and 1, Column 15, Row 0 is the top-right corner.",
          "questions": [
            {
              "question": "What are the coordinates for the top-right corner of a 16x2 LCD?",
              "options": [
                "Column 15, Row 0",
                "Column 16, Row 1",
                "Column 0, Row 15"
              ],
              "correctIndex": 0,
              "explanation": "Because columns count from 0 to 15 and rows count 0 and 1, Column 15, Row 0 is the top-right corner."
            },
            {
              "question": "Why is C++ case-sensitivity important when calling library commands?",
              "options": [
                "lcd.print() works, but lcd.Print() or LCD.print() will fail with 'was not declared' error",
                "Capital letters make the letters print in bold on the LCD",
                "Lowercase letters run slower on the Arduino"
              ],
              "correctIndex": 0,
              "explanation": "C++ is strictly case-sensitive; function names must match the exact capitalization defined by the library."
            },
            {
              "question": "What happens if you print a 20-character string starting at (0, 0) on a 16-column display?",
              "options": [
                "The characters beyond column 15 get clipped or spill off the visible screen",
                "The screen expands physically to fit the text",
                "The microcontroller restarts in emergency mode"
              ],
              "correctIndex": 0,
              "explanation": "Standard 16x2 displays only show 16 characters per line; text exceeding 16 columns gets cut off unless you scroll the display."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_07",
    "title": "Meet the Library API",
    "summary": "You might hear programmers talk about a library's API.",
    "tier": "builder",
    "estimatedMinutes": 8,
    "courseId": "lesson_03",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l03_06"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_07_s01",
        "title": "Meet the Library API",
        "type": "story",
        "markdownContent": "You might hear programmers talk about a library's **API**.\n\nAPI stands for **Application Programming Interface**. That sounds super fancy, but it just means:\n> **The list of commands a library gives you to talk to it!**\n\nThink of an API like the menu at an ice cream shop 🍦. The menu tells you all the flavors you can order. If you ask for something that isn't on the menu, the shopkeeper looks confused!\n\nHere is a quick look at the `LiquidCrystal_I2C` library menu (its API):\n- `lcd.init()`: Wakes up and configures the screen.\n- `lcd.backlight()`: Turns on the blue LED light behind the screen.\n- `lcd.noBacklight()`: Turns off the light to save power.\n- `lcd.clear()`: Erases everything on the screen.\n- `lcd.setCursor(col, row)`: Jumps the writing pen to a grid position.\n- `lcd.print(message)`: Writes text or numbers on the display.\n\nWhenever you use a new library, checking its documentation or README gives you its complete menu of commands!",
        "quickCheck": [
          {
            "questionId": "qc_l03_s07_q1",
            "question": "What does a library's 'API' mean in friendly terms?",
            "options": [
              "The menu of commands and functions the library allows you to call",
              "The physical plastic casing around the Arduino",
              "The battery voltage needed to power the board"
            ],
            "correctIndex": 0,
            "explanation": "An API is the set of functions, methods, and commands exposed by a library for you to control the device.",
            "warmupExplanation": "Think of an API like a restaurant menu: it lists all the options and commands you can use!"
          },
          {
            "questionId": "qc_l03_s07_q2",
            "question": "If you want to erase all text currently shown on an LCD screen, which API command would you look for?",
            "options": [
              "lcd.clear()",
              "lcd.destroy()",
              "lcd.burn()"
            ],
            "correctIndex": 0,
            "explanation": "lcd.clear() is the standard API function that wipes the character memory and leaves the screen blank.",
            "warmupExplanation": "Most display libraries provide a clear() command to wipe the display clean."
          }
        ]
      },
      {
        "stepId": "l03_07_s02",
        "title": "Object-Oriented Syntax: Dot Notation",
        "type": "visualExplanation",
        "markdownContent": "### Understanding Dot Notation: `object.method()`\n\nNotice how every command in our LCD library uses a dot (`.`):\n\n```cpp\n  lcd.clear();\n// ^   ^\n// │   └── METHOD (The action to perform)\n// └────── OBJECT (The specific hardware device instance)\n```\n\nIn C++, this is called **Object-Oriented Programming (OOP)**:\n1. **The Object (`lcd`)**: Represents your physical hardware device in code.\n2. **The Dot (`.`)**: Tells the compiler, *\"Reach inside this object and run this specific tool!\"*\n3. **The Method (`print`, `clear`, `setCursor`)**: The pre-written function that carries out the task.\n4. **Parameters (`\"Hello\"`, `0, 1`)**: The specific details passed between parentheses.\n\n### The Common LiquidCrystal_I2C API Roster\n- `lcd.init()`: Prepares the hardware registers.\n- `lcd.clear()`: Blanks all 32 character locations.\n- `lcd.home()`: Returns cursor to (0, 0) without erasing text.\n- `lcd.backlight()` / `lcd.noBacklight()`: Controls the blue LED backlight.\n- `lcd.cursor()` / `lcd.noCursor()`: Shows or hides the blinking underline."
      },
      {
        "stepId": "l03_07_s03",
        "title": "Exploring the API Surface",
        "type": "codeExperiment",
        "interactiveWidgetType": "libraryConceptDiagram",
        "markdownContent": "Let's review the API command surface! Check out how the library cleanly bundles dozens of hardware actions behind simple method names.\n\nUse the diagram to inspect how calling simple methods like `init()`, `backlight()`, and `print()` cleanly replaces hundreds of lines of cryptic bit-shifting and register writes.",
        "interactiveConfig": {
          "title": "API Command Surface: Exploring Methods and Abstraction"
        }
      },
      {
        "stepId": "l03_07_s04",
        "title": "Knowledge Check: Library APIs & Methods",
        "type": "quizCheckpoint",
        "markdownContent": "Test your knowledge of library APIs, dot notation, and common display methods.",
        "interactiveConfig": {
          "question": "In the statement 'lcd.backlight();', what does the dot '.' do?",
          "options": [
            "It calls the backlight() method on the lcd object",
            "It creates a new integer variable",
            "It ends the program execution"
          ],
          "correctIndex": 0,
          "explanation": "Dot notation calls a method (function) belonging to an object instance in object-oriented C++.",
          "questions": [
            {
              "question": "In the statement 'lcd.backlight();', what does the dot '.' do?",
              "options": [
                "It calls the backlight() method on the lcd object",
                "It creates a new integer variable",
                "It ends the program execution"
              ],
              "correctIndex": 0,
              "explanation": "Dot notation calls a method (function) belonging to an object instance in object-oriented C++."
            },
            {
              "question": "Which API method turns off the blue LCD backlight to save battery power?",
              "options": [
                "lcd.noBacklight()",
                "lcd.shutdown()",
                "lcd.sleepMode()"
              ],
              "correctIndex": 0,
              "explanation": "lcd.noBacklight() disables the transistor controlling the backlight LED on the I2C backpack."
            },
            {
              "question": "What is the difference between lcd.clear() and lcd.home()?",
              "options": [
                "lcd.clear() erases all characters, while lcd.home() only moves the cursor to (0, 0) without erasing",
                "lcd.home() shuts down the Arduino, while lcd.clear() plays music",
                "There is no difference; they are identical functions"
              ],
              "correctIndex": 0,
              "explanation": "lcd.clear() wipes character display RAM; lcd.home() simply resets the cursor to the top-left cell without erasing text."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_08",
    "title": "When Should I Use a Library?",
    "summary": "Now that you know how awesome libraries are, an important engineering question arises:",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_03",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l03_07"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_s08",
        "title": "When Should I Use a Library?",
        "type": "story",
        "interactiveWidgetType": "missingLibraryTroubleshooting",
        "markdownContent": "Now that you know how awesome libraries are, an important engineering question arises:\n\n**Should you use a library for EVERYTHING?** 🤔\n\nLet's compare two scenarios:\n\n### 1. When You DO Want a Library:\n- Complex communication (talking to an LCD screen, an OLED display, or a Wi-Fi chip).\n- Precise timing devices (servo motors, ultrasonic distance sensors, sound decoders).\n- Complicated math (reading a 6-axis gyroscope, calculating angles, or encrypting data).\n\n### 2. When You DON'T Need a Library:\n- Simple things built right into Arduino! Turning a single LED on or off only needs `digitalWrite(pin, HIGH);`.\n- Reading a basic pushbutton switch only needs `digitalRead(pin);`.\n- Reading a potentiometer dial only needs `analogRead(pin);`.\n\nUsing a giant library for a simple pushbutton is like calling a helicopter just to cross the street! A great engineer chooses the right tool for the job: simple built-in commands for basic pins, and powerful libraries for smart modules.",
        "quickCheck": [
          {
            "questionId": "qc_l03_s08_q1",
            "question": "Do you need to install an external library just to turn a single basic LED on and off?",
            "options": [
              "No, simple built-in commands like digitalWrite() are already part of Arduino",
              "Yes, you cannot turn on any LED without downloading a library",
              "Yes, an LED requires at least three different libraries"
            ],
            "correctIndex": 0,
            "explanation": "Basic input/output like digitalWrite() and digitalRead() are built right into the Arduino language—no extra libraries needed!",
            "warmupExplanation": "Simple LED control is already built into Arduino: digitalWrite() does the job with zero extra downloads!"
          },
          {
            "questionId": "qc_l03_s08_q2",
            "question": "When is installing an external library strongly recommended?",
            "options": [
              "When working with complex modules like screens, motors, or special sensors",
              "Only when you want to make your code run slower",
              "Never, engineers avoid libraries at all costs"
            ],
            "correctIndex": 0,
            "explanation": "External libraries handle the intricate timing and protocol math required by complex hardware devices like screens and servos.",
            "warmupExplanation": "Use libraries whenever a component requires dozens of complex timing steps to operate safely."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l03_09",
    "title": "Library Challenge",
    "summary": "You have unlocked the superpower of libraries!",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_03",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l03_08"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l03_s09",
        "title": "Library Challenge",
        "type": "quizCheckpoint",
        "markdownContent": "You have unlocked the superpower of libraries! Test your skills on finding, installing, including, and modifying library code to earn your Builder XP.",
        "interactiveConfig": {
          "question": "What is the primary purpose of an Arduino library?",
          "options": [
            "They speed up code by writing complex hardware protocols for you",
            "They double the CPU clock speed of the Arduino",
            "They convert AC electricity into DC electricity"
          ],
          "correctIndex": 0,
          "explanation": "They speed up code by writing complex hardware protocols for you. Understanding this principle ensures proper circuit function and reliability.",
          "questions": [
            {
              "question": "What is the primary purpose of an Arduino library?",
              "options": [
                "They speed up code by writing complex hardware protocols for you",
                "They double the CPU clock speed of the Arduino",
                "They convert AC electricity into DC electricity"
              ],
              "correctIndex": 0,
              "explanation": "They speed up code by writing complex hardware protocols for you. Understanding this principle ensures proper circuit function and reliability."
            },
            {
              "question": "Which preprocessor command is used to add a library to a sketch?",
              "options": [
                "#include <LibraryName.h>",
                "import LibraryName;",
                "using namespace LibraryName;"
              ],
              "correctIndex": 0,
              "explanation": "#include <LibraryName.h> is the standard preprocessor directive that imports a library into an Arduino sketch."
            },
            {
              "question": "Where inside the Arduino IDE can you search for and install community libraries?",
              "options": [
                "Tools > Manage Libraries (or the Library Manager tab)",
                "File > Preferences > Upload",
                "Help > Drivers"
              ],
              "correctIndex": 0,
              "explanation": "Tools > Manage Libraries opens the Library Manager, allowing you to search and install verified libraries."
            },
            {
              "question": "What does a library's 'API' represent?",
              "options": [
                "The list of functions and commands exposed for you to control the device",
                "The physical size of the circuit board in millimeters",
                "The price of the component in the store"
              ],
              "correctIndex": 0,
              "explanation": "An API (Application Programming Interface) is the collection of functions and commands the library provides."
            },
            {
              "question": "Where can you find pre-tested example sketches showing how to use an installed library?",
              "options": [
                "File > Examples in the Arduino IDE",
                "Tools > Auto Format",
                "Sketch > Export compiled Binary"
              ],
              "correctIndex": 0,
              "explanation": "Installed libraries bundle working sample programs under the File > Examples menu in the IDE."
            },
            {
              "question": "If your compiler shows 'fatal error: Servo.h: No such file or directory', what should you do?",
              "options": [
                "Install the missing Servo library using the Library Manager",
                "Buy a new computer",
                "Add five semicolons to the #include line"
              ],
              "correctIndex": 0,
              "explanation": "'No such file or directory' means the library header isn't installed in your libraries folder yet."
            },
            {
              "question": "Why shouldn't you use an external library to read a simple pushbutton?",
              "options": [
                "Arduino already has built-in digitalRead() commands for simple buttons",
                "Pushbuttons do not work with electricity",
                "External libraries are illegal to use with buttons"
              ],
              "correctIndex": 0,
              "explanation": "Simple tasks like reading a digital button are already supported natively by Arduino's core functions."
            },
            {
              "question": "What file extension designates C++ header files in libraries?",
              "options": [
                ".h",
                ".ino",
                ".hex"
              ],
              "correctIndex": 0,
              "explanation": "Header files use the .h extension and contain the declarations exposed by a C++ library."
            }
          ]
        },
        "quickCheck": [
          {
            "questionId": "qc_l03_s09_q1",
            "question": "What happens when you install a library from the Library Manager?",
            "options": [
              "Its code and example sketches are downloaded to your computer for your sketches to use",
              "It permanently erases all previous sketches",
              "It changes the language of your computer"
            ],
            "correctIndex": 0,
            "explanation": "The Library Manager downloads the library's header, source files, and examples into your local libraries folder.",
            "warmupExplanation": "Installing adds the library to your computer's toolkit so any sketch can include it."
          },
          {
            "questionId": "qc_l03_s09_q2",
            "question": "Can you inspect and modify the example code provided by an installed library?",
            "options": [
              "Yes, you can edit example code, customize values, and save it as your own sketch",
              "No, example code is locked and will break your computer if edited",
              "No, you can only look at it through a magnifying glass"
            ],
            "correctIndex": 0,
            "explanation": "Examples are meant to be explored, adapted, and saved into your own custom robot sketches!",
            "warmupExplanation": "Modifying example code is one of the best ways to learn and build custom robot features."
          }
        ]
      }
    ],
    "xpReward": 15
  },
  {
    "id": "l04_01",
    "title": "From ON/OFF to Control",
    "summary": "Imagine you are building a robotic monster in the dark!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l03_09"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s01",
        "title": "From ON/OFF to Control",
        "type": "story",
        "markdownContent": "Imagine you are building a robotic monster in the dark! So far, your digital output pins act like a standard light switch on the wall: they can only be completely **ON (+5V)** or completely **OFF (0V)**.\n\nWhen you call `digitalWrite(pin, HIGH)`, the light turns on at full power. When you call `digitalWrite(pin, LOW)`, the light switches off entirely.\n\n```\nDigital Output:  0V (LOW / OFF)  ⟷  5V (HIGH / ON)\n```\n\nWhat if your monster wants to wake up slowly with a gentle dawn glow? What if you want a soft nightlight, a pulsing heartbeat beacon, or smooth motor speed control instead of full-throttle jerking?\n\nIn the physical world, things do not simply snap between 0% and 100%. We need **variable control**—the ability to choose any brightness between total darkness and full blast!\n\nMicrocontrollers do not have built-in dials that turn voltage down to 2.5V or 1.2V on their digital pins. So how can a digital chip that only speaks 0s and 1s create smooth, gentle brightness?\n\nGet ready to discover the magic trick of electronics: **Pulse Width Modulation (PWM)**!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s01_q1",
            "question": "What happens when an Arduino digital output pin is set to HIGH?",
            "options": [
              "It connects to the full +5V supply rail (turned ON)",
              "It drops the voltage to half-power (+2.5V)",
              "It disconnects power and turns off the circuit"
            ],
            "correctIndex": 0,
            "explanation": "A digital HIGH connects the pin to the full +5V supply rail, turning the output completely ON.",
            "warmupExplanation": "Digital pins have two states: HIGH means ON (+5V) and LOW means OFF (0V)."
          },
          {
            "questionId": "qc_l04_s01_q2",
            "question": "If you want an LED connected to an output pin to turn completely dark, what command state do you send?",
            "options": [
              "LOW (0V)",
              "HIGH (+5V)",
              "HALF (+2.5V)"
            ],
            "correctIndex": 0,
            "explanation": "Sending LOW switches the pin to 0V (Ground level), stopping current and turning off the LED.",
            "warmupExplanation": "In digital electronics, LOW means 0 Volts, which turns off power to components."
          }
        ]
      },
      {
        "stepId": "l04_01_s02",
        "title": "The Illusion of Smooth Brightness",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Fast Flashing Illusion\nHow can your Arduino simulate a dim glow if pins only output 0V or 5V?\n\nImagine flipping a light switch on and off with your finger as fast as you can. If you flip it once per second, your eyes see obvious blinking. But what if you could flip that switch **500 times every single second**?\n\nAt 500 times per second, your human eyes cannot keep up! Instead of seeing flashes, your brain blends the light and dark periods together into a steady, soft glow.\n\n- Spend 50% of the time ON and 50% OFF -> Your eyes see **half brightness**!\n- Spend 10% of the time ON and 90% OFF -> Your eyes see a **dim glow**!\n- Spend 90% of the time ON and 10% OFF -> Your eyes see **bright light**!\n\nThis technique is called **Pulse Width Modulation (PWM)**."
      },
      {
        "stepId": "l04_01_s03",
        "title": "Interactive Duty Cycle Test",
        "type": "physicalTask",
        "interactiveWidgetType": "pwmDutyCycleVisualizer",
        "markdownContent": "### Experiment with the Duty Cycle Visualizer\nUse the interactive tool below to adjust the ratio of ON time vs. OFF time.\n\nObserve how the simulated LED reacts as you change the percentage of time power is active during each wave cycle."
      },
      {
        "stepId": "l04_01_s04",
        "title": "Knowledge Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Review what you learned about digital output limitations and variable control.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Can a standard digital Arduino pin output an actual analog voltage of 2.5V on its own?",
              "options": [
                "No, digital pins can only output 0V or 5V",
                "Yes, pins can output any voltage directly",
                "Only on Tuesdays"
              ],
              "correctIndex": 0,
              "explanation": "Digital pins are binary: they only output 0V or 5V. Variable effects are created with rapid switching (PWM)!"
            },
            {
              "question": "Why do our eyes see a steady dim glow instead of rapid flashing when PWM is used?",
              "options": [
                "The switching happens hundreds of times per second, faster than our eyes can detect",
                "The LED turns into a candle",
                "The wires store daylight"
              ],
              "correctIndex": 0,
              "explanation": "Persistence of vision blends the high-speed flashes into an apparent steady brightness level!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_02",
    "title": "What Is PWM?",
    "summary": "Pulse Width Modulation (PWM) is the clever engineering technique microcontrollers use to simulate variable brightness using only digital ON and OFF...",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l04_01"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s02",
        "title": "What Is PWM?",
        "type": "visualExplanation",
        "interactiveWidgetType": "pwmDutyCycleVisualizer",
        "markdownContent": "**Pulse Width Modulation (PWM)** is the clever engineering technique microcontrollers use to simulate variable brightness using only digital ON and OFF signals!\n\nHere is the secret: instead of lowering the voltage, the Arduino flips the pin ON and OFF hundreds of times every single second (about 490 to 980 times per second)!\n\nWhy doesn't the LED look like a flickering strobe light?\nBecause of a property of human vision called **Persistence of Vision** (flicker fusion). Your eyes and brain can only process about 60 image updates per second. When an LED flickers at 490 times per second, the flashes blur together!\n\nYour eyes integrate the bursts of light:\n- If the LED is ON for tiny slivers of time and OFF most of the cycle, your brain perceives a **dim, gentle glow**.\n- If the LED is ON most of the cycle and OFF for only tiny moments, your brain perceives **bright light**.\n\nIt is like flipping a light switch on and off at superhero speed!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s02_q1",
            "question": "When a light flashes on and off hundreds of times every second, how do human eyes perceive it?",
            "options": [
              "As a steady, smooth glow without visible flickering",
              "As slow, separate flashes that can be counted",
              "As total darkness"
            ],
            "correctIndex": 0,
            "explanation": "Because our eyes blend fast light pulses together (persistence of vision), rapid flashing appears as a continuous steady glow.",
            "warmupExplanation": "When light blinks faster than ~60 times a second, our eyes cannot see the flicker and blend it into a steady glow."
          },
          {
            "questionId": "qc_l04_s02_q2",
            "question": "Does a standard digital output pin physically change its DC voltage to 2.5V, or does it rapidly pulse between 0V and 5V?",
            "options": [
              "It rapidly pulses between 0V and 5V to simulate an average voltage",
              "It physically steps down its DC voltage to 2.5V",
              "It changes the chemical composition of the wire"
            ],
            "correctIndex": 0,
            "explanation": "Digital pins only output 0V or 5V; they create in-between brightness by rapidly pulsing between the two states.",
            "warmupExplanation": "Microcontrollers are digital: they only output 0V (OFF) or 5V (ON). To get medium brightness, they pulse!"
          }
        ]
      },
      {
        "stepId": "l04_02_s02",
        "title": "The Clock & Frequency of PWM",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Understanding PWM Signals\nPulse Width Modulation works on a fixed cycle frequency.\n\nOn the Arduino Uno, PWM pins operate around **490 Hz** (or 980 Hz on pins 5 & 6). That means the cycle repeats roughly **500 times every second**!\n\nWithin that single cycle (about 2 milliseconds long):\n- The time the signal stays HIGH is called the **Pulse Width**.\n- The longer the pulse width, the more total electrical energy delivers to the LED or motor."
      },
      {
        "stepId": "l04_02_s03",
        "title": "Explore the PWM Pin Identifier",
        "type": "physicalTask",
        "interactiveWidgetType": "pwmPinIdentifier",
        "markdownContent": "### Finding the PWM Pins on Uno\nNot every pin can do PWM! Look for the little tilde symbol  next to pin numbers.\n\nInspect the pinout below to identify which pins support hardware PWM."
      },
      {
        "stepId": "l04_02_s04",
        "title": "PWM Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What symbol on the Arduino Uno marks pins that support PWM?",
              "options": [
                "A small squiggly tilde (~)",
                "An exclamation point (!)",
                "A dollar sign ($)"
              ],
              "correctIndex": 0,
              "explanation": "Look closely at pins 3, 5, 6, 9, 10, and 11: each has a ~ symbol next to its number!"
            },
            {
              "question": "What happens to the total energy delivered when the pulse width is increased?",
              "options": [
                "More energy reaches the component, making it brighter or faster",
                "Energy drops to zero",
                "The board resets"
              ],
              "correctIndex": 0,
              "explanation": "Wider pulses mean power is connected for more time during each cycle, delivering more total energy!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_03",
    "title": "Duty Cycle",
    "summary": "To control how bright the LED appears, we adjust the Duty Cycle.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l04_02"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s03",
        "title": "Duty Cycle",
        "type": "visualExplanation",
        "interactiveWidgetType": "pwmDutyCycleVisualizer",
        "markdownContent": "To control how bright the LED appears, we adjust the **Duty Cycle**.\n\nThe duty cycle is simply the **percentage of time** that the signal stays ON (+5V) during each repeating pulse cycle:\n\n- **0% Duty Cycle**: The signal is ON 0% of the time (always 0V). The LED is completely **OFF**.\n- **25% Duty Cycle**: The signal is ON for 1/4 of the time and OFF for 3/4 of the time. The LED glows **dimly**.\n- **50% Duty Cycle**: The signal is ON half the time and OFF half the time. The LED shines at **medium brightness**.\n- **75% Duty Cycle**: The signal is ON 3/4 of the time and OFF 1/4 of the time. The LED shines **brightly**.\n- **100% Duty Cycle**: The signal is ON 100% of the time (always +5V). The LED shines at **maximum brightness**!\n\n```\n 0% Duty:  ____________________________________ (OFF)\n25% Duty:  _--________--________--________--___ (DIM)\n50% Duty:  _----____----____----____----____--- (MEDIUM)\n75% Duty:  _------__------__------__------__--- (BRIGHT)\n100% Duty: ------------------------------------ (MAX)\n```\n\nThe width of the ON pulse determines the brightness. That is why it is called **Pulse Width Modulation**—we modulate (adjust) the width of the pulse!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s03_q1",
            "question": "If an electrical signal spends half of each cycle turned ON and half turned OFF, what is its duty cycle?",
            "options": [
              "50% duty cycle",
              "10% duty cycle",
              "100% duty cycle"
            ],
            "correctIndex": 0,
            "explanation": "Spending half the time active and half inactive corresponds to a 50% duty cycle.",
            "warmupExplanation": "Duty cycle is the percentage of ON time: half of 100% is 50%."
          },
          {
            "questionId": "qc_l04_s03_q2",
            "question": "What happens to the perceived brightness of an LED as its ON-time percentage increases?",
            "options": [
              "The LED appears brighter",
              "The LED becomes dimmer",
              "The LED turns completely dark"
            ],
            "correctIndex": 0,
            "explanation": "More time ON during each cycle delivers more light energy to your eyes, making the LED appear brighter.",
            "warmupExplanation": "The longer the pulse stays ON during each cycle, the brighter the light appears."
          }
        ]
      },
      {
        "stepId": "l04_03_s02",
        "title": "Duty Cycle Percentages",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Measuring the Duty Cycle\nThe ratio of ON time compared to total cycle time is called the **Duty Cycle**:\n\n- **0% Duty Cycle**: Signal is OFF 100% of the time (0V average).\n- **25% Duty Cycle**: ON for 1/4 of the time, OFF for 3/4 (1.25V average).\n- **50% Duty Cycle**: ON for half the time, OFF for half (2.5V average).\n- **75% Duty Cycle**: ON for 3/4 of the time, OFF for 1/4 (3.75V average).\n- **100% Duty Cycle**: Constant HIGH (+5V steady)."
      },
      {
        "stepId": "l04_03_s03",
        "title": "Simulate Wave Duty Cycles",
        "type": "codeExperiment",
        "interactiveWidgetType": "pwmDutyCycleVisualizer",
        "markdownContent": "### Tune the Duty Cycle Waveform\nAdjust the slider in the simulator to see square waves stretch and shrink in real time."
      },
      {
        "stepId": "l04_03_s04",
        "title": "Duty Cycle Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the duty cycle if an LED signal is ON for 500 microseconds and OFF for 500 microseconds?",
              "options": [
                "50%",
                "100%",
                "0%"
              ],
              "correctIndex": 0,
              "explanation": "Since it spends equal time ON and OFF, the duty cycle is 50%!"
            },
            {
              "question": "What duty cycle corresponds to maximum full brightness (constant 5V)?",
              "options": [
                "100%",
                "0%",
                "25%"
              ],
              "correctIndex": 0,
              "explanation": "A 100% duty cycle means the pin remains ON throughout the entire cycle!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_04",
    "title": "LED Brightness",
    "summary": "Let's wire an LED circuit and examine how hardware components protect your circuit!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l04_03"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s04",
        "title": "LED Brightness",
        "type": "physicalTask",
        "markdownContent": "Let's wire an LED circuit and examine how hardware components protect your circuit!\n\n### Circuit Building Steps:\n1. **Identify LED Polarity**:\n   - The **Anode** (positive) is the **longer leg**.\n   - The **Cathode** (negative) is the **shorter leg** (and has a flat edge on the plastic collar).\n2. **Add a Current-Limiting Resistor**:\n   - Connect a **220Ω resistor** (color bands: red-red-brown-gold) in series with the LED.\n   - *Why?* LEDs have almost no electrical resistance once illuminated! Without a resistor, excessive current rushes through the delicate semiconductor, overheating and damaging it. The resistor keeps current safely below 20 mA.\n3. **Connect to Arduino**:\n   - Connect the resistor to **Digital Pin ~9** (a PWM pin marked with a tilde `~`).\n   - Connect the short leg (Cathode) to **GND** (Ground).\n\n```\nPin ~9 ──[ 220Ω Resistor ]──( Anode + ) LED ( - Cathode )── GND\n```\n\nWhen testing brightness, remember: changing pulse width changes perceived brightness, while the resistor keeps current safe!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s04_q1",
            "question": "Why is a current-limiting resistor required in series with an LED?",
            "options": [
              "To limit electrical current and protect the LED from burning out",
              "To change the color of the emitted light",
              "To increase the microcontroller clock speed"
            ],
            "correctIndex": 0,
            "explanation": "Without a resistor, excessive current flows through the LED diode junction, causing overheating and permanent damage.",
            "warmupExplanation": "LEDs need a resistor to restrict current flow and keep components safe."
          },
          {
            "questionId": "qc_l04_s04_q2",
            "question": "When inspecting a standard LED, which lead connects toward Ground (0V)?",
            "options": [
              "The shorter leg (cathode)",
              "The longer leg (anode)",
              "Either leg—LEDs work in both directions"
            ],
            "correctIndex": 0,
            "explanation": "The shorter leg with the flat notch is the cathode (negative terminal) and connects toward Ground.",
            "warmupExplanation": "Diodes only allow current to flow in one direction! Long leg is positive (anode), short leg is negative (cathode)."
          }
        ]
      },
      {
        "stepId": "l04_04_s02",
        "title": "Controlling Brightness without Heat",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Why PWM is Super Efficient\nOld-fashioned analog dimmers used variable resistors that turned excess electricity into wasteful heat.\n\nBecause PWM switches transistors completely ON (almost zero resistance) and completely OFF (zero current), it generates virtually **zero wasted heat**! This is why PWM is used in smartphones, electric cars, and industrial robotics."
      },
      {
        "stepId": "l04_04_s03",
        "title": "Fading an LED on the Workbench",
        "type": "physicalTask",
        "interactiveWidgetType": "blinkSimulator",
        "markdownContent": "### Observe Smooth Fading\nWatch the simulated LED fade smoothly from 0% to 100% brightness as the duty cycle ramps up."
      },
      {
        "stepId": "l04_04_s04",
        "title": "LED Brightness Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Why is PWM switching preferred over using variable resistors to dim lights?",
              "options": [
                "PWM produces almost no wasted heat and saves energy",
                "Resistors are too heavy",
                "PWM makes lights purple"
              ],
              "correctIndex": 0,
              "explanation": "Transistors are most efficient when fully on or fully off. PWM prevents wasting power as heat!"
            },
            {
              "question": "Can PWM make an LED brighter than its 100% maximum rating?",
              "options": [
                "No, 100% is full power (+5V)",
                "Yes, it gives 1000V",
                "Only if unplugged"
              ],
              "correctIndex": 0,
              "explanation": "PWM can only vary the average output between 0V and the maximum +5V supply rail."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_05",
    "title": "analogWrite",
    "summary": "To output a PWM signal in Arduino code, we use the analogWrite() function!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l04_04"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s05",
        "title": "analogWrite",
        "type": "codeExperiment",
        "interactiveWidgetType": "pwmPinIdentifier",
        "markdownContent": "To output a PWM signal in Arduino code, we use the `analogWrite()` function!\n\n```cpp\nanalogWrite(pin, value);\n```\n\n### The 8-Bit Range: 0 to 255\nThe `value` parameter accepts a whole number from **0 to 255**:\n- `analogWrite(9, 0);` → 0% duty cycle (Completely OFF).\n- `analogWrite(9, 64);` → 25% duty cycle (Dim glow).\n- `analogWrite(9, 127);` → 50% duty cycle (Medium brightness).\n- `analogWrite(9, 255);` → 100% duty cycle (Maximum brightness).\n\n*Why 255?* Arduino PWM uses an 8-bit scale ($2^8 = 256$ distinct levels: 0 through 255).\n\n### Spotting PWM Pins: Look for the Tilde (~)\nNot every digital pin supports PWM! Look closely at the numbers printed on your Arduino Uno:\n- Only pins marked with a wavy tilde (`~`) support PWM: **Pins 3, 5, 6, 9, 10, and 11**.\n- If you call `analogWrite()` on a non-PWM pin (like Pin 8), it behaves like `digitalWrite()`: 0–127 turns OFF, and 128–255 turns full ON!\n\n### Smooth Fading Loop:\n```cpp\nvoid loop() {\n  for (int b = 0; b <= 255; b += 5) {\n    analogWrite(9, b); // Fade up\n    delay(20);\n  }\n  for (int b = 255; b >= 0; b -= 5) {\n    analogWrite(9, b); // Fade down\n    delay(20);\n  }\n}\n```",
        "quickCheck": [
          {
            "questionId": "qc_l04_s05_q1",
            "question": "What symbol on the Arduino Uno printed silkscreen marks digital pins that support PWM output?",
            "options": [
              "A tilde symbol (~)",
              "An exclamation mark (!)",
              "A plus sign (+)"
            ],
            "correctIndex": 0,
            "explanation": "Pins marked with a tilde (~) such as 3, 5, 6, 9, 10, and 11 support hardware PWM output.",
            "warmupExplanation": "Look at the digital pin headers on your Arduino board: the wavy line ~ marks PWM pins."
          },
          {
            "questionId": "qc_l04_s05_q2",
            "question": "In the Arduino analogWrite(pin, value) command, what value produces full 100% brightness?",
            "options": [
              "255",
              "100",
              "1023"
            ],
            "correctIndex": 0,
            "explanation": "analogWrite uses an 8-bit scale from 0 (OFF) to 255 (maximum 100% duty cycle).",
            "warmupExplanation": "Arduino PWM operates on an 8-bit scale: 0 is completely off, and 255 is maximum power."
          }
        ]
      },
      {
        "stepId": "l04_05_s02",
        "title": "The analogWrite() Function Range (0 to 255)",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The 8-Bit Number Range\nIn Arduino C++, the command to output PWM is .\n\nEven though it has \"analog\" in the name, it actually outputs a digital PWM square wave!\n\nThe  parameter is an **8-bit integer** ranging from **0 to 255**:\n-  -> 0% duty cycle (OFF)\n-  -> 25% duty cycle\n-  -> 50% duty cycle\n-  -> 100% duty cycle (Full brightness)"
      },
      {
        "stepId": "l04_05_s03",
        "title": "Deconstruct an analogWrite Statement",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "### Inspect the Syntax\nExamine the statement  to see how the pin number and duty cycle value are passed."
      },
      {
        "stepId": "l04_05_s04",
        "title": "analogWrite Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What range of values does analogWrite() accept?",
              "options": [
                "0 to 255",
                "0 to 10",
                "1 to 1000"
              ],
              "correctIndex": 0,
              "explanation": "Arduino Uno uses 8-bit PWM timers, giving 256 discrete levels (0 to 255)!"
            },
            {
              "question": "What duty cycle does analogWrite(pin, 127) produce approximately?",
              "options": [
                "50% (half brightness)",
                "100% (full brightness)",
                "0% (off)"
              ],
              "correctIndex": 0,
              "explanation": "127 is roughly half of 255, producing a 50% duty cycle!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_06",
    "title": "Meet the RGB LED",
    "summary": "Single-color LEDs are great, but monster robots love rich, vibrant color!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l04_05"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s06",
        "title": "Meet the RGB LED",
        "type": "physicalTask",
        "markdownContent": "Single-color LEDs are great, but monster robots love rich, vibrant color! Meet the **RGB LED**.\n\n### Three Lights in One Package\nAn RGB LED looks like a single frosted bulb, but inside the lens are **three separate semiconductor dies**:\n- One **Red** LED\n- One **Green** LED\n- One **Blue** LED\n\n### The 4-Leg Tour:\nBecause there are three LEDs inside, how many wire legs does the component have? **Four legs!**\nEach color has its own control leg, and all three share one common pin:\n\n1. **Leg 1 (Outer Left)**: Red Anode\n2. **Leg 2 (Longest Leg)**: Common Pin (Cathode / GND on Common Cathode LEDs)\n3. **Leg 3**: Green Anode\n4. **Leg 4 (Outer Right)**: Blue Anode\n\n```\n   [Frosted 5mm Lens]\n        │ │ │ │\n        │ │ │ └── Leg 4: Blue\n        │ │ └──── Leg 3: Green\n        │ └────── Leg 2: Common (Longest!)\n        └──────── Leg 1: Red\n```\n\n### Three Dedicated Resistors!\n**Golden Rule**: Always connect a separate 220Ω resistor to EACH color leg (Leg 1, Leg 3, and Leg 4)!\n*Why not share one resistor on the common leg?*\nRed LEDs operate around ~2.0V, while Green and Blue operate around ~3.2V. If you share one resistor, the lower-voltage Red channel draws all the current, causing Green and Blue to dim or turn off!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s06_q1",
            "question": "How many physical wire legs does a standard single-package RGB LED have?",
            "options": [
              "4 legs (Red, Common, Green, Blue)",
              "2 legs",
              "8 legs"
            ],
            "correctIndex": 0,
            "explanation": "An RGB LED has 4 legs: one control leg for each of the 3 colors, plus one shared common leg.",
            "warmupExplanation": "Three color channels plus one common shared pin equals 4 legs total on an RGB LED."
          },
          {
            "questionId": "qc_l04_s06_q2",
            "question": "Why should each color channel of an RGB LED have its own dedicated series resistor?",
            "options": [
              "Because Red, Green, and Blue have different operating voltages and need independent current regulation",
              "To convert the LED into a sensor",
              "Because resistors make light brighter"
            ],
            "correctIndex": 0,
            "explanation": "Dedicated resistors ensure each color channel receives balanced current without stealing power from adjacent channels.",
            "warmupExplanation": "Red, green, and blue LEDs use different forward voltages. A resistor for each color keeps all three balanced and protected."
          }
        ]
      },
      {
        "stepId": "l04_06_s02",
        "title": "Inside the RGB LED Package",
        "type": "visualExplanation",
        "interactiveWidgetType": "commonCathodeVsAnodeDiagram",
        "markdownContent": "### Three LEDs in One Shell!\nAn RGB LED looks like a single clear bulb, but look closely inside: it holds **three microscopic LED chips**:\n- One Red diode\n- One Green diode\n- One Blue diode\n\nIt has **4 legs (pins)**:\n- One leg for Red\n- One leg for Green\n- One leg for Blue\n- One shared common leg (longest pin) for Power or Ground!"
      },
      {
        "stepId": "l04_06_s03",
        "title": "Identify the Longest Leg",
        "type": "physicalTask",
        "interactiveWidgetType": "boardInspector",
        "markdownContent": "### Pin Identification Challenge\nExamine your RGB LED package and identify which pin is the common return pin."
      },
      {
        "stepId": "l04_06_s04",
        "title": "RGB LED Pinout Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How many separate light-emitting diodes are packaged inside an RGB LED?",
              "options": [
                "Three (Red, Green, Blue)",
                "Only one",
                "Twelve"
              ],
              "correctIndex": 0,
              "explanation": "An RGB LED combines three distinct diodes (Red, Green, Blue) into a single 4-pin case!"
            },
            {
              "question": "How can you physically tell which leg is the common pin on an RGB LED?",
              "options": [
                "It is noticeably the longest pin",
                "It is made of gold",
                "It has a ribbon tied to it"
              ],
              "correctIndex": 0,
              "explanation": "Manufacturers make the common cathode/anode leg longer than the other three legs for easy identification!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_07",
    "title": "Mixing Colors",
    "summary": "Mixing light is pure physics magic!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l04_06"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s07",
        "title": "Mixing Colors",
        "type": "visualExplanation",
        "interactiveWidgetType": "rgbColorSynthesizer",
        "markdownContent": "Mixing light is pure physics magic!\n\nWhen you mix paint in art class (subtractive color), combining colors absorbs wavelengths, eventually creating muddy dark brown or black.\n\nWith light, we use **Additive Color Mixing**. When colored light beams overlap, they add energy together:\n\n- **Red + Green = Yellow** (Red and green light beams combine into bright yellow!)\n- **Green + Blue = Cyan** (Vibrant aqua / sky blue)\n- **Red + Blue = Magenta** (Vivid purple / hot pink)\n- **Red + Green + Blue = White** (All three primary wavelengths create clean white light!)\n\n### Creating Custom Shades with PWM:\nBy varying the PWM values between 0 and 255 on each channel, you can blend any shade imaginable:\n- **Orange**: High Red (`255`) + Medium-Low Green (`80`) + Zero Blue (`0`)\n- **Purple**: Medium Red (`160`) + Zero Green (`0`) + High Blue (`255`)\n- **Soft Pink**: Full Red (`255`) + Low Green (`80`) + Low Blue (`80`)\n\nWith $256 \\times 256 \\times 256$ possible combinations, your Arduino can synthesize over **16.7 million distinct colors**!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s07_q1",
            "question": "In additive light color mixing, what color do you see when Red light and Green light shine together at equal brightness?",
            "options": [
              "Yellow",
              "Brown",
              "Black"
            ],
            "correctIndex": 0,
            "explanation": "In additive light physics, combining pure Red and Green beams creates bright Yellow light.",
            "warmupExplanation": "Light mixing is additive! Unlike paint, combining red light and green light shines as bright yellow."
          },
          {
            "questionId": "qc_l04_s07_q2",
            "question": "What color is created when Red, Green, and Blue light all shine simultaneously at full brightness?",
            "options": [
              "White",
              "Pitch black",
              "Dark brown"
            ],
            "correctIndex": 0,
            "explanation": "Combining all three primary light wavelengths (Red, Green, Blue) at full intensity produces White light.",
            "warmupExplanation": "When all three light channels are turned on at full power, their wavelengths blend to form White light."
          }
        ]
      },
      {
        "stepId": "l04_07_s02",
        "title": "Additive Color Theory: Red + Green + Blue",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Painting with Photons!\nUnlike mixing paint where adding colors makes brown/black (subtractive), light is **additive**:\n- **Red + Green** = **Yellow** 🟨\n- **Red + Blue** = **Magenta / Purple** 🟪\n- **Green + Blue** = **Cyan / Aqua** 🟦\n- **Red + Green + Blue** = **White Light** ⬜\n\nBy adjusting the PWM brightness of each color between 0 and 255, you can create over **16 million colors**!"
      },
      {
        "stepId": "l04_07_s03",
        "title": "Interactive RGB Color Synthesizer",
        "type": "physicalTask",
        "interactiveWidgetType": "rgbColorSynthesizer",
        "markdownContent": "### Mix Custom Colors\nSlide the Red, Green, and Blue sliders to blend any hue on your robot."
      },
      {
        "stepId": "l04_07_s04",
        "title": "Color Mixing Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What color of light do you see when Red and Green beams shine together equally?",
              "options": [
                "Yellow",
                "Purple",
                "Black"
              ],
              "correctIndex": 0,
              "explanation": "In additive light theory, combining pure Red and pure Green produces bright Yellow light!"
            },
            {
              "question": "What happens when Red, Green, and Blue all shine at full 100% power simultaneously?",
              "options": [
                "You get crisp White light",
                "The room turns pitch black",
                "The bulb shatters"
              ],
              "correctIndex": 0,
              "explanation": "All visible primary light wavelengths combined together produce White light!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_08",
    "title": "Common Cathode vs Common Anode",
    "summary": "When using an RGB LED, you must know which internal wiring standard it uses: Common Cathode or Common Anode.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l04_07"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s08",
        "title": "Common Cathode vs Common Anode",
        "type": "visualExplanation",
        "interactiveWidgetType": "commonCathodeVsAnodeDiagram",
        "markdownContent": "When using an RGB LED, you must know which internal wiring standard it uses: **Common Cathode** or **Common Anode**.\n\n### 1. Common Cathode (Standard in Monster Lab Kits)\n- **Cathode** means negative terminal (GND).\n- The longest shared pin connects to **GND (0V)**.\n- Driving a color pin HIGH (or positive PWM) turns that color **ON**.\n- `analogWrite(redPin, 255);` = 100% Brightness.\n- `analogWrite(redPin, 0);` = Completely OFF.\n- *Straightforward and intuitive logic!*\n\n### 2. Common Anode\n- **Anode** means positive terminal (+5V).\n- The longest shared pin connects to **+5V**.\n- Driving a color pin LOW (0V) completes the circuit and turns that color **ON**.\n- `analogWrite(redPin, 0);` = 100% Brightness!\n- `analogWrite(redPin, 255);` = Completely OFF!\n- *Inverted logic (Active-LOW)!*\n\n### Quick Hardware Test:\nPlug the longest pin into GND. Touch a 220Ω resistor from 5V to any color pin. If that color lights up, congratulations—you have a **Common Cathode** LED!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s08_q1",
            "question": "In a Common Cathode RGB LED, what does the shared longest pin connect to?",
            "options": [
              "Ground (GND / 0V)",
              "Positive +5V power",
              "An analog input header"
            ],
            "correctIndex": 0,
            "explanation": "Cathode is the negative terminal, so a Common Cathode LED shares a single connection to Ground (GND).",
            "warmupExplanation": "Cathode means negative (GND), while Anode means positive (+5V). Common Cathode connects to GND."
          },
          {
            "questionId": "qc_l04_s08_q2",
            "question": "If an RGB LED has Common Anode wiring (shared +5V), what code value turns a color channel fully ON?",
            "options": [
              "0 (or LOW), because current flows when the pin is pulled down to 0V",
              "255 (or HIGH)",
              "500"
            ],
            "correctIndex": 0,
            "explanation": "Common Anode LEDs use inverted (active-LOW) logic: sending 0 connects the pin to Ground, completing the circuit from +5V.",
            "warmupExplanation": "Common Anode has inverted logic: pulling a pin to 0V turns it ON, and sending 255 turns it OFF."
          }
        ]
      },
      {
        "stepId": "l04_08_s02",
        "title": "Common Cathode vs Common Anode",
        "type": "visualExplanation",
        "interactiveWidgetType": "commonCathodeVsAnodeDiagram",
        "markdownContent": "### Cathode (GND) vs Anode (+5V)\nThere are two kinds of RGB LEDs:\n1. **Common Cathode (Most Common)**:\n   - Long pin connects to **Ground (GND)**.\n   - A HIGH (255) signal turns that color ON.\n2. **Common Anode**:\n   - Long pin connects to **+5V**.\n   - Logic is inverted: LOW (0) turns color ON, and 255 turns it OFF!"
      },
      {
        "stepId": "l04_08_s03",
        "title": "Common Leg Circuit Verification",
        "type": "physicalTask",
        "interactiveWidgetType": "ledPolarityInspector",
        "markdownContent": "### Check Your Kit LED Polarity\nVerify whether your Monster Lab kit contains Common Cathode or Common Anode diodes."
      },
      {
        "stepId": "l04_08_s04",
        "title": "Cathode vs Anode Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "In a Common Cathode RGB LED, where does the longest shared leg connect?",
              "options": [
                "To Ground (GND)",
                "To +5V power",
                "To Pin A0"
              ],
              "correctIndex": 0,
              "explanation": "Cathode means negative/ground return! The longest leg connects to GND."
            },
            {
              "question": "If you send analogWrite(pin, 255) to a Common Cathode pin, what happens?",
              "options": [
                "That color shines at maximum brightness",
                "It turns off completely",
                "Nothing happens"
              ],
              "correctIndex": 0,
              "explanation": "With Common Cathode, higher values provide more forward voltage, maximizing brightness!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_09",
    "title": "RGB Mini Project",
    "summary": "Time to build your monster's Mood & Status Beacon!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l04_08"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s09",
        "title": "RGB Mini Project",
        "type": "physicalTask",
        "markdownContent": "Time to build your monster's **Mood & Status Beacon**!\n\n### Breadboard Wiring Mission:\n1. Insert your Common Cathode RGB LED across separate rows on the breadboard.\n2. Connect the **longest pin (Pin 2)** directly to Arduino **GND**.\n3. Connect **Pin 1 (Red)** through a **220Ω resistor** to Uno **PWM Pin ~9**.\n4. Connect **Pin 3 (Green)** through a **220Ω resistor** to Uno **PWM Pin ~10**.\n5. Connect **Pin 4 (Blue)** through a **220Ω resistor** to Uno **PWM Pin ~11**.\n\n### The Status Light Sketch:\n```cpp\nconst int RED_PIN = 9;    // PWM Pin ~9\nconst int GREEN_PIN = 10; // PWM Pin ~10\nconst int BLUE_PIN = 11;  // PWM Pin ~11\n\nvoid setup() {\n  pinMode(RED_PIN, OUTPUT);\n  pinMode(GREEN_PIN, OUTPUT);\n  pinMode(BLUE_PIN, OUTPUT);\n}\n\nvoid setColor(int red, int green, int blue) {\n  analogWrite(RED_PIN, red);\n  analogWrite(GREEN_PIN, green);\n  analogWrite(BLUE_PIN, blue);\n}\n\nvoid loop() {\n  // 🟢 Green = Ready / Systems Clear\n  setColor(0, 255, 0);\n  delay(1500);\n\n  // 🟡 Yellow = Warning / Charging\n  setColor(255, 180, 0);\n  delay(1500);\n\n  // 🔴 Red = Alert / Stop!\n  setColor(255, 0, 0);\n  delay(1500);\n\n  // 🟣 Purple = Party Mode Beacon!\n  setColor(200, 0, 255);\n  delay(1500);\n}\n```\n\nUpload this sketch to watch your monster express its status in living color!",
        "quickCheck": [
          {
            "questionId": "qc_l04_s09_q1",
            "question": "Which set of Arduino Uno pins is used for PWM color control in this project?",
            "options": [
              "Pins ~9, ~10, and ~11",
              "Pins 0, 1, and 2",
              "Pins 7, 8, and 12"
            ],
            "correctIndex": 0,
            "explanation": "Pins ~9, ~10, and ~11 all feature hardware PWM (tilde ~), allowing variable brightness on every color channel.",
            "warmupExplanation": "Look for the tilde (~) on the Uno silkscreen: pins 9, 10, and 11 all support PWM."
          },
          {
            "questionId": "qc_l04_s09_q2",
            "question": "In the setColor(red, green, blue) function, what arguments produce a bright Yellow status light?",
            "options": [
              "setColor(255, 255, 0); (Red + Green ON, Blue OFF)",
              "setColor(0, 0, 255);",
              "setColor(0, 255, 255);"
            ],
            "correctIndex": 0,
            "explanation": "Yellow light is synthesized by mixing Red and Green while keeping Blue turned off.",
            "warmupExplanation": "To create yellow light, turn ON Red (255) and Green (255), and set Blue to 0."
          }
        ]
      },
      {
        "stepId": "l04_09_s02",
        "title": "Wiring 3 Current-Limiting Resistors",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Bench Rule: Three Separate Resistors!\nNever share a single resistor on the common leg! If you do, turning on Red will steal current from Green, changing their brightness unevenly.\n\n**Always put one 220Ω resistor on each individual color leg (R, G, and B)!**\n\n"
      },
      {
        "stepId": "l04_09_s03",
        "title": "Build the RGB Mini Project Circuit",
        "type": "physicalTask",
        "interactiveWidgetType": "rgbMixer",
        "markdownContent": "### Wire and Test\nWire pins 9, 10, and 11 to your RGB LED through 220Ω resistors and observe the color cycle."
      },
      {
        "stepId": "l04_09_s04",
        "title": "Mini Project Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Why should each color channel have its own separate 220Ω protective resistor?",
              "options": [
                "Different color diodes have different forward voltages and need independent current limits",
                "To use up spare parts",
                "Because resistors get lonely"
              ],
              "correctIndex": 0,
              "explanation": "Red, green, and blue diodes have different forward voltages. Individual resistors prevent brightness interference!"
            },
            {
              "question": "Which three Uno pins are commonly used for RGB PWM control?",
              "options": [
                "Pins 9, 10, and 11",
                "Pins 0, 1, and 2",
                "Pins A0, A1, and A2"
              ],
              "correctIndex": 0,
              "explanation": "Pins 9, 10, and 11 are adjacent hardware PWM pins on the Uno header!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l04_10",
    "title": "PWM Challenge",
    "summary": "Put all your new skills together: test your understanding of PWM, duty cycles, analogWrite commands, resistor safety, and RGB color synthesis with ...",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_04",
    "sortOrder": 10,
    "isOptional": false,
    "prerequisites": [
      "l04_09"
    ],
    "componentIds": [
      "comp_uno"
    ],
    "steps": [
      {
        "stepId": "l04_s10",
        "title": "PWM Challenge",
        "type": "quizCheckpoint",
        "markdownContent": "Congratulations on completing Lesson 04! Put all your new skills together: test your understanding of PWM, duty cycles, analogWrite commands, resistor safety, and RGB color synthesis with this checkpoint.",
        "interactiveConfig": {
          "question": "What is the primary purpose of Pulse Width Modulation (PWM) when controlling an LED?",
          "options": [
            "To simulate variable brightness by rapidly pulsing between ON and OFF",
            "To convert the LED into a digital temperature sensor",
            "To make the Arduino run at double clock speed"
          ],
          "correctIndex": 0,
          "explanation": "PWM rapidly pulses a digital output so human eyes perceive smooth, variable brightness.",
          "questions": [
            {
              "question": "What is the primary purpose of Pulse Width Modulation (PWM) when controlling an LED?",
              "options": [
                "To simulate variable brightness by rapidly pulsing between ON and OFF",
                "To convert the LED into a digital temperature sensor",
                "To make the Arduino run at double clock speed"
              ],
              "correctIndex": 0,
              "explanation": "PWM rapidly pulses a digital output so human eyes perceive smooth, variable brightness."
            },
            {
              "question": "What duty cycle percentage produces medium (approximately half) brightness on an LED?",
              "options": [
                "50% duty cycle",
                "10% duty cycle",
                "100% duty cycle"
              ],
              "correctIndex": 0,
              "explanation": "A 50% duty cycle powers the LED for half the pulse duration, creating roughly half brightness."
            },
            {
              "question": "What integer value in analogWrite(pin, value) corresponds to full 100% brightness?",
              "options": [
                "255",
                "100",
                "1023"
              ],
              "correctIndex": 0,
              "explanation": "analogWrite is 8-bit, so values range from 0 (OFF) to 255 (full 100% duty cycle)."
            },
            {
              "question": "Which pins on an Arduino Uno support hardware PWM output?",
              "options": [
                "Pins marked with a tilde (~) such as 3, 5, 6, 9, 10, and 11",
                "All digital pins from 0 to 13",
                "Only analog pins A0 through A5"
              ],
              "correctIndex": 0,
              "explanation": "Only pins marked with a tilde (~) on the Uno silkscreen support PWM output."
            },
            {
              "question": "Why does an RGB LED need a separate resistor on each color channel?",
              "options": [
                "Because Red, Green, and Blue have different forward voltages and each need dedicated current limiting",
                "To change the frequency of the microcontroller oscillator",
                "To convert alternating current into direct current"
              ],
              "correctIndex": 0,
              "explanation": "Independent resistors ensure safe current distribution across colors with different forward voltage drops."
            },
            {
              "question": "In additive light mixing, what color is created when Red and Green light shine at full intensity?",
              "options": [
                "Yellow",
                "Brown",
                "Cyan"
              ],
              "correctIndex": 0,
              "explanation": "In additive color optics, combining red light and green light produces yellow light."
            },
            {
              "question": "Where does the longest lead of a Common Cathode RGB LED connect?",
              "options": [
                "Ground (GND)",
                "+5V power supply",
                "Digital Pin 13"
              ],
              "correctIndex": 0,
              "explanation": "The cathode is negative, so a Common Cathode LED connects its longest shared lead to Ground (GND)."
            },
            {
              "question": "If your RGB LED shows Cyan when you commanded Red, what is the most likely cause?",
              "options": [
                "The LED is Common Anode, so its logic is inverted (Active-LOW)",
                "The Arduino has run out of memory",
                "The breadboard is too close to a magnet"
              ],
              "correctIndex": 0,
              "explanation": "Common Anode LEDs turn ON with LOW (0) and OFF with HIGH (255), so an un-inverted Red command leaves Green and Blue ON (producing Cyan)."
            }
          ]
        },
        "quickCheck": [
          {
            "questionId": "qc_l04_s10_q1",
            "question": "What happens if you run analogWrite(8, 128) on digital pin 8 on an Arduino Uno?",
            "options": [
              "Pin 8 lacks PWM (~), so it will only switch ON or OFF without smooth dimming",
              "The board will immediately reset",
              "Pin 8 will output a continuous analog sine wave"
            ],
            "correctIndex": 0,
            "explanation": "Pin 8 is not a PWM pin, so analogWrite acts like a simple threshold switch rather than pulsing.",
            "warmupExplanation": "Always check for the tilde (~)! Non-PWM pins cannot dim with analogWrite."
          },
          {
            "questionId": "qc_l04_s10_q2",
            "question": "In a Common Cathode RGB LED, what code turns both Red and Blue ON to create vibrant Magenta (purple) light?",
            "options": [
              "analogWrite(redPin, 255); analogWrite(bluePin, 255); analogWrite(greenPin, 0);",
              "analogWrite(greenPin, 255); analogWrite(redPin, 0); analogWrite(bluePin, 0);",
              "analogWrite(redPin, 0); analogWrite(bluePin, 0); analogWrite(greenPin, 0);"
            ],
            "correctIndex": 0,
            "explanation": "Magenta is made of Red plus Blue; with Common Cathode, 255 turns a channel full ON while 0 keeps Green OFF.",
            "warmupExplanation": "Red + Blue = Magenta! Set Red to 255, Blue to 255, and Green to 0."
          }
        ]
      },
      {
        "stepId": "l04_10_s02",
        "title": "The Mood Lamp Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Monster Mood Lamp Capstone\nIn this challenge, you combine loops, variables, and PWM to create a breathing mood light!\n\nThe sketch smoothly transitions from Ruby Red → Emerald Green → Sapphire Blue and back without abrupt jumps."
      },
      {
        "stepId": "l04_10_s03",
        "title": "Deconstruct the Color Transition Code",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "### Code Walkthrough\nInspect how three analogWrite() statements work inside a for loop to blend colors smoothly."
      },
      {
        "stepId": "l04_10_s04",
        "title": "PWM Mastery Challenge Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of the concepts covered in this module.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How do you create a smooth breathing fade effect in code?",
              "options": [
                "Gradually increase and decrease the PWM value using a loop with small delay pauses",
                "Turn power switch on and off with your hand",
                "Shake the board gently"
              ],
              "correctIndex": 0,
              "explanation": "Incrementing analogWrite() values in a loop creates silky smooth pulsing animations!"
            },
            {
              "question": "What hardware capability makes PWM so versatile for robotics?",
              "options": [
                "It can control LED brightness, motor speed, and servo positioning without complex analog circuitry",
                "It makes sound without a buzzer",
                "It stores extra memory"
              ],
              "correctIndex": 0,
              "explanation": "PWM is the universal digital technique for variable power, motor speed, and robot actuators!"
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "l05_01",
    "title": "What Is a Switch?",
    "summary": "Every interactive robot begins with a way to sense physical human contact.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l04_10"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s01",
        "title": "What Is a Switch?",
        "type": "story",
        "markdownContent": "### Bridging the Physical and Digital Worlds\nEvery interactive robot begins with a way to sense physical human contact. The simplest and most universal sensor in all of electronics is the **switch**!\n\nThink of an electrical switch like a drawbridge across a river:\n- **Closed Circuit (Bridge Down)**: The metal contacts touch. Electricity has an unbroken conductive road to travel from the power source, through the device, and back to ground. Current flows and the circuit comes alive!\n- **Open Circuit (Bridge Up)**: The metal contacts separate. There is an air gap between the conductors. Electricity cannot leap across the gap, so current immediately drops to zero. The circuit turns completely OFF.\n\n```\nClosed (ON):   [5V Power] ====== [Closed Contacts] ======> [Robot Load] ======> [GND]\nOpen (OFF):    [5V Power] ====== [   Air Gap     ]   X   [Robot Load] ....... [GND]\n```\n\n### Latching vs. Momentary Switches\n1. **Latching Switches**: Like a bedroom wall toggle or your robot's master power switch. When you flip it ON, it clicks and mechanically stays ON until you manually flip it back.\n2. **Momentary Switches**: Like a doorbell, keyboard key, or game controller button. An internal spring keeps the switch open until your finger physically pushes it down. The split second you let go, the spring snaps the contacts apart again!\n\nIn Monster Lab, switches let your creations sense when a door opens, when a foot hits the floor, or when an emergency stop button is pressed.",
        "quickCheck": [
          {
            "questionId": "l05_s01_q1",
            "question": "What must exist for electric current to flow through a circuit?",
            "options": [
              "A continuous, closed conductive path from power to ground",
              "An open circuit with a gap between wires",
              "Only a battery with no wires connected"
            ],
            "correctIndex": 0,
            "explanation": "Electricity requires an unbroken conductive loop (closed circuit) from power through a load to ground.",
            "warmupExplanation": "Electric current requires a continuous conductive path to flow; air gaps stop the current."
          },
          {
            "questionId": "l05_s01_q2",
            "question": "What happens when a switch opens, creating a gap between conductors?",
            "options": [
              "Current immediately stops flowing through the gap",
              "Current speeds up and sparks continuously",
              "The circuit voltage doubles automatically"
            ],
            "correctIndex": 0,
            "explanation": "Opening a switch breaks the conductive loop, dropping current flow to zero.",
            "warmupExplanation": "An open circuit breaks the loop, preventing electrons from traveling through the circuit."
          }
        ]
      },
      {
        "stepId": "l05_01_s02",
        "title": "Switch Electrical Mechanics",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "How Contacts Close the Circuit\nA switch is a mechanical bridge that makes or breaks an electrical circuit when actuated."
      },
      {
        "stepId": "l05_01_s03",
        "title": "Hands-On: What Is a Switch?",
        "type": "physicalTask",
        "interactiveWidgetType": "floatingPinSimulator",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how what is a switch? operates in a circuit."
      },
      {
        "stepId": "l05_01_s04",
        "title": "Switch Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What does a closed switch do in an electrical circuit?",
              "options": [
                "Allows current to flow across its contacts",
                "Stops current immediately",
                "Reverses battery polarity"
              ],
              "correctIndex": 0,
              "explanation": "Closing a switch completes the circuit loop!"
            },
            {
              "question": "What happens when a switch is opened?",
              "options": [
                "It creates an air gap that halts current flow",
                "It doubles voltage",
                "It catches fire"
              ],
              "correctIndex": 0,
              "explanation": "Opening contacts introduces an open circuit gap, dropping current to zero!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_02",
    "title": "Pushbuttons",
    "summary": "Grab a 4-pin momentary tactile pushbutton from your kit.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l05_01"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s02",
        "title": "Pushbuttons",
        "type": "physicalTask",
        "markdownContent": "### Anatomical Tour of the Tactile Pushbutton\nGrab a 4-pin momentary tactile pushbutton from your kit. These tiny buttons are built into robots, game controllers, and appliances worldwide.\n\n### The 4-Pin Mystery: Why Four Legs for Two Contacts?\nWhen you look at the bottom of the button, you notice **4 metal legs**, but a simple switch only needs 2 wires to connect. Why are there 4?\n\nInside the plastic housing:\n- The two legs on the **same long side** are permanently joined together by an internal metal bar!\n- Leg A and Leg B are connected to each other inside.\n- Leg C and Leg D are connected to each other inside.\n- The push action connects the AB pair to the CD pair!\n\n```\nTop View of 4-Pin Tactile Button:\n\n   Pin 1 [=== Internal Bar ===] Pin 2\n                |  |\n             [ Switch ]\n                |  |\n   Pin 3 [=== Internal Bar ===] Pin 4\n```\n\n### Breadboard Insertion Technique\nTo prevent shorting the switch out before you even push it, always insert the button so its body **straddles the center divider trench (ravine)** of your solderless breadboard:\n1. Place Pins 1 and 2 on Row 15, Column D and E (left side of ravine).\n2. Place Pins 3 and 4 on Row 15, Column F and G (right side of ravine).\n3. Press firmly until all four legs seat cleanly into the breadboard spring clips.\n4. Press down with your index finger: feel the crisp tactile snap as the miniature metal dome clicks inside!",
        "quickCheck": [
          {
            "questionId": "l05_s02_q1",
            "question": "Why do solderless breadboards feature a center divider trench (ravine)?",
            "options": [
              "To electrically isolate opposing rows so dual-pin parts do not short together",
              "To store extra jumper wires during assembly",
              "To act as a heat sink for the power supply"
            ],
            "correctIndex": 0,
            "explanation": "The center trench separates columns a-e from f-j, allowing DIP chips and buttons to straddle across without shorting.",
            "warmupExplanation": "Breadboard rows are connected across columns a-e and f-j, but separated by the center ravine."
          },
          {
            "questionId": "l05_s02_q2",
            "question": "What happens when you release your finger from a momentary pushbutton?",
            "options": [
              "An internal flexible spring snaps the contacts apart, opening the circuit",
              "The switch remains locked closed permanently",
              "The polarity of the connected battery reverses"
            ],
            "correctIndex": 0,
            "explanation": "Momentary switches only maintain contact while external force is applied; releasing them opens the circuit.",
            "warmupExplanation": "Momentary pushbuttons return to their open state as soon as pressure is released."
          }
        ]
      },
      {
        "stepId": "l05_02_s02",
        "title": "Normally Open (NO) Tactile Switches",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Tactile Button Architecture\nInspect the 4 pins of a miniature tactile button: pins on the same side are connected in pairs internally."
      },
      {
        "stepId": "l05_02_s03",
        "title": "Hands-On: Pushbuttons",
        "type": "physicalTask",
        "interactiveWidgetType": "boardInspector",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how pushbuttons operates in a circuit."
      },
      {
        "stepId": "l05_02_s04",
        "title": "Button Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What does Normally Open (NO) mean for a momentary pushbutton?",
              "options": [
                "Contacts are disconnected until your finger presses down",
                "Contacts are always connected",
                "The button has no wires"
              ],
              "correctIndex": 0,
              "explanation": "Normally Open buttons only conduct current while actively held down!"
            },
            {
              "question": "Why do tactile pushbuttons have 4 pins?",
              "options": [
                "To provide mechanical stability on breadboards with two internal pairs",
                "Because each pin needs its own battery",
                "It is a mistake"
              ],
              "correctIndex": 0,
              "explanation": "The 4 legs provide firm stability and duplicate pins in pairs!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_03",
    "title": "Digital Inputs",
    "summary": "Up until now, you have used Arduino pins as OUTPUTS to push electrical energy into LEDs, buzzers, and displays.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l05_02"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s03",
        "title": "Digital Inputs",
        "type": "visualExplanation",
        "interactiveWidgetType": "decisionSimulator",
        "markdownContent": "### Senses vs. Muscles: Listening to Voltage\nUp until now, you have used Arduino pins as **OUTPUTS** to push electrical energy into LEDs, buzzers, and displays. But an interactive monster brain also needs to **listen**!\n\nWhen you set an Arduino pin to `INPUT` mode:\n1. The pin enters a **high-impedance state** (nearly 100 million ohms of resistance).\n2. It stops driving current and instead behaves like an ultra-sensitive electronic ear, measuring the voltage placed upon it without interfering with the circuit.\n3. It evaluates that voltage using binary digital logic thresholds.\n\n```\n+5.0V -------------- HIGH Region (Logic 1) ---------------\n+3.0V -----------------------------------------------------\n       Undefined / Floating Zone (Unpredictable! Avoid!)\n+1.5V -----------------------------------------------------\n 0.0V -------------- LOW Region  (Logic 0) ---------------\n```\n\n### Arduino Uno Digital Logic Rules:\n- **`HIGH`**: Any voltage between **+3.0V and +5.0V**. The microcontroller interprets this as binary `1` or `true`.\n- **`LOW`**: Any voltage between **0.0V and +1.5V**. The microcontroller interprets this as binary `0` or `false`.\n- **The Dead Zone**: Voltages floating between 1.5V and 3.0V are unpredictable and must be avoided by using decisive switching!",
        "quickCheck": [
          {
            "questionId": "l05_s03_q1",
            "question": "What are the two discrete binary states of a digital pin on an Arduino Uno?",
            "options": [
              "HIGH (+5V) and LOW (0V / Ground)",
              "Positive (+12V) and Negative (-12V)",
              "Alternating (AC) and Direct (DC)"
            ],
            "correctIndex": 0,
            "explanation": "Digital pins only recognize two binary voltage states: HIGH (+5V) and LOW (0V / Ground).",
            "warmupExplanation": "Digital pins in 5V microcontrollers recognize binary logic: 5V is HIGH and 0V is LOW."
          },
          {
            "questionId": "l05_s03_q2",
            "question": "When an Arduino pin is configured as an INPUT, what is its primary function?",
            "options": [
              "To measure incoming electrical voltage without sourcing heavy current",
              "To deliver high current to drive large mechanical motors",
              "To step down battery power from 120 volts"
            ],
            "correctIndex": 0,
            "explanation": "Inputs act as high-impedance sensors that read incoming voltage signals from external devices.",
            "warmupExplanation": "Output pins drive voltages out; input pins sample incoming voltages from the world."
          }
        ]
      },
      {
        "stepId": "l05_03_s02",
        "title": "Reading HIGH (+5V) and LOW (0V)",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Digital Logic Thresholds\nThe ATmega328P interprets voltages above ~3.0V as HIGH and voltages below ~1.5V as LOW."
      },
      {
        "stepId": "l05_03_s03",
        "title": "Hands-On: Digital Inputs",
        "type": "physicalTask",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how digital inputs operates in a circuit."
      },
      {
        "stepId": "l05_03_s04",
        "title": "Digital Input Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How many distinct logic states can a digital input pin read?",
              "options": [
                "Two states: HIGH and LOW",
                "Infinite analog levels",
                "Ten different colors"
              ],
              "correctIndex": 0,
              "explanation": "Digital inputs are binary: they detect either HIGH (1) or LOW (0)!"
            },
            {
              "question": "What threshold voltage does the Uno roughly need to register a HIGH signal?",
              "options": [
                "Above approximately 3.0 Volts",
                "Above 1000 Volts",
                "Exactly 0.1 Volts"
              ],
              "correctIndex": 0,
              "explanation": "CMOS logic requires around 0.6 * VCC (approx 3.0V) for a solid HIGH!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_04",
    "title": "digitalRead",
    "summary": "How does your Arduino sketch inspect the physical voltage on a pin?",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l05_03"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s04",
        "title": "digitalRead",
        "type": "codeExperiment",
        "markdownContent": "### The Software Lens: Reading Digital Pins\nHow does your Arduino sketch inspect the physical voltage on a pin? With the built-in C++ function `digitalRead()`!\n\n```cpp\nint sensorReading = digitalRead(2); // Reads Pin 2 at this exact microsecond\n```\n\n### How digitalRead() Works:\n1. The ATmega328P processor samples the input buffer register for Digital Pin 2.\n2. If the pin is at +5V, it returns the constant **`HIGH`** (integer value 1).\n3. If the pin is at 0V (GND), it returns the constant **`LOW`** (integer value 0).\n4. We store this value in an `int` variable so our sketch can make intelligent decisions using `if` statements!\n\n```cpp\nconst int buttonPin = 2;\n\nvoid setup() {\n  pinMode(buttonPin, INPUT); // Configure Pin 2 to listen\n  Serial.begin(9600);        // Open Serial Monitor communication\n}\n\nvoid loop() {\n  int state = digitalRead(buttonPin); // Query the hardware pin\n  Serial.print(\"Pin 2 State: \");\n  Serial.println(state);              // Prints 1 for HIGH or 0 for LOW\n  delay(250);\n}\n```\n\nRun this sketch and open your Serial Monitor. But wait! What happens if no wire is connected to Pin 2 yet? Let's uncover the biggest trap in physical computing!",
        "quickCheck": [
          {
            "questionId": "l05_s04_q1",
            "question": "Which Arduino C++ function is used to sample the binary voltage of a digital pin?",
            "options": [
              "digitalRead(pin)",
              "digitalWrite(pin, HIGH)",
              "analogRead(pin)"
            ],
            "correctIndex": 0,
            "explanation": "`digitalRead(pin)` queries a pin and returns its current digital logic state (HIGH or LOW).",
            "warmupExplanation": "`digitalWrite()` sends output; `digitalRead()` brings an incoming digital signal into code."
          },
          {
            "questionId": "l05_s04_q2",
            "question": "What possible values can digitalRead() return on an Arduino Uno?",
            "options": [
              "HIGH (1) or LOW (0)",
              "Any floating decimal between 0.0 and 5.0",
              "Values from 0 to 1023"
            ],
            "correctIndex": 0,
            "explanation": "Because it is a digital function, `digitalRead()` only returns binary HIGH (1) or LOW (0).",
            "warmupExplanation": "Digital inputs only measure binary two-state logic: HIGH or LOW."
          }
        ]
      },
      {
        "stepId": "l05_04_s02",
        "title": "Reading Pin States in Code",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "The digitalRead() Function\nUse int state = digitalRead(pin); to poll whether an input pin is HIGH or LOW."
      },
      {
        "stepId": "l05_04_s03",
        "title": "Hands-On: digitalRead",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how digitalread operates in a circuit."
      },
      {
        "stepId": "l05_04_s04",
        "title": "digitalRead Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What command reads the state of an Arduino digital pin?",
              "options": [
                "digitalRead(pin)",
                "analogWrite(pin)",
                "listenToPin(pin)"
              ],
              "correctIndex": 0,
              "explanation": "digitalRead() samples the pin voltage and returns HIGH or LOW!"
            },
            {
              "question": "What mode must the pin be configured to in setup() before digitalRead?",
              "options": [
                "INPUT or INPUT_PULLUP",
                "OUTPUT",
                "SHUTDOWN"
              ],
              "correctIndex": 0,
              "explanation": "pinMode(pin, INPUT) prepares the pin circuitry to listen to signals!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_05",
    "title": "Floating Inputs",
    "summary": "If you run digitalRead(2) with nothing connected to Pin 2, you might expect it to read LOW (0V).",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l05_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s05",
        "title": "Floating Inputs",
        "type": "visualExplanation",
        "interactiveWidgetType": "floatingPinSimulator",
        "markdownContent": "### The Ghost Button: Why Unconnected Pins Go Crazy\nIf you run `digitalRead(2)` with nothing connected to Pin 2, you might expect it to read `LOW` (0V). But look at the Serial Monitor: it bounces wildly between `0` and `1`!\n\nIf you wave your hand near the Arduino board or touch the plastic wire insulation, the numbers flicker like mad. Your robot thinks a phantom monster is smashing the button hundreds of times per second!\n\n```\nUnconnected Pin:  [Stray Electrostatic Fields] ~~~> [Pin 2 Antenna] ===> ??? (0 or 1 at random!)\n```\n\n### The Physics Behind the Float\n1. **High Impedance**: Remember, an input pin has nearly 100 MΩ of resistance. It takes virtually zero electric current to influence it.\n2. **Stray Electromagnetic Radiation**: The room around you is full of electromagnetic noise: 60Hz wall wiring, Wi-Fi routers, fluorescent lights, and electrostatic charges on your skin and clothing.\n3. **The Unintentional Antenna**: With nothing holding the pin firmly to a voltage source, the wire acts as a radio antenna, picking up micro-volt charges that randomly push the pin above 3V (HIGH) and below 1.5V (LOW).\n\nAn input pin left open with no definitive connection to power or ground is called a **floating pin**. In robotics, a floating pin is a catastrophic bug!",
        "quickCheck": [
          {
            "questionId": "l05_s05_q1",
            "question": "What is an electrical 'floating pin' in microcontroller systems?",
            "options": [
              "An input pin left unconnected to power or ground, making its logic state random and erratic",
              "A pin submerged in water during cooling",
              "An output pin that powers a hovercraft motor"
            ],
            "correctIndex": 0,
            "explanation": "A floating pin lacks a solid reference connection to 5V or GND, causing it to pick up ambient noise and toggle unpredictably.",
            "warmupExplanation": "Without a physical connection to 5V or Ground, an input pin's voltage is undefined and floats."
          },
          {
            "questionId": "l05_s05_q2",
            "question": "Why does waving your hand near an unconnected input pin cause the Serial Monitor readings to flip?",
            "options": [
              "Your body carries electrostatic charges that couple into high-impedance inputs",
              "Your hand blocks the microcontroller's internal radio receiver",
              "Human body heat slows down the quartz crystal clock"
            ],
            "correctIndex": 0,
            "explanation": "High-impedance inputs easily detect tiny electrostatic electric fields radiating from human bodies and clothing.",
            "warmupExplanation": "High-impedance inputs are so sensitive that ambient electrical charges nearby induce false signals."
          }
        ]
      },
      {
        "stepId": "l05_05_s02",
        "title": "The Danger of an Unconnected Pin",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Why Floating Pins Flap in the Breeze\nAn unconnected CMOS input pin acts like an antenna, picking up electromagnetic noise and flipping randomly between 0 and 1."
      },
      {
        "stepId": "l05_05_s03",
        "title": "Hands-On: Floating Inputs",
        "type": "physicalTask",
        "interactiveWidgetType": "floatingPinSimulator",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how floating inputs operates in a circuit."
      },
      {
        "stepId": "l05_05_s04",
        "title": "Floating Pin Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What happens if you leave a digital input pin completely unconnected (floating)?",
              "options": [
                "It picks up environmental electrical noise and fluctuates unpredictably",
                "It always reads HIGH steadily",
                "It always reads LOW steadily"
              ],
              "correctIndex": 0,
              "explanation": "High-impedance inputs float without a reference, picking up stray electromagnetic static!"
            },
            {
              "question": "How do engineers solve the floating input problem?",
              "options": [
                "By adding a pull-up or pull-down resistor",
                "By blowing on the board",
                "By cutting the pin off"
              ],
              "correctIndex": 0,
              "explanation": "Pull resistors tie the pin weakly to a defined voltage state when the switch is open!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_06",
    "title": "Pull-Up Resistors",
    "summary": "How do engineers prevent floating pins?",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l05_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s06",
        "title": "Pull-Up Resistors",
        "type": "visualExplanation",
        "interactiveWidgetType": "internalPullupCircuitDiagram",
        "markdownContent": "### Anchoring the Voltage: The Pull-Up Solution\nHow do engineers prevent floating pins? We anchor the pin to a known voltage using a **pull-up resistor**!\n\nA pull-up resistor connects the input pin to **+5V**. When the switch is open, the resistor gently \"pulls\" the pin up to 5V, guaranteeing a stable, rock-solid `HIGH`.\n\n```\nButton OPEN (Idle):\n  +5V ---[ 10k Resistor ]---> Pin 2 (Reads HIGH, 5.0V)\n                                |\n                           [ Switch: OPEN ]\n                                |\n                               GND\n```\n\n### Why a Resistor Instead of a Plain Wire?\nWhy not connect Pin 2 directly to +5V with a solid wire? Consider what happens when someone presses the button to GND:\n- If you used a plain wire from 5V to the pin, pressing the button would connect **+5V directly to GND with ZERO resistance**!\n- This creates a **dead short circuit**, drawing massive current, heating the wires, and triggering USB shutdown protection!\n\n### Ohm's Law to the Rescue:\nWith a 10,000Ω (10kΩ) pull-up resistor in place:\n$$I = \\frac{V}{R} = \\frac{5.0\\text{V}}{10{,}000\\Omega} = 0.0005\\text{ A} = 0.5\\text{ mA}$$\nWhen the button is pressed, only half a milliamp of current flows safely to GND, pulling Pin 2 all the way to **0.0V (LOW)** with zero danger!\n\n### Active-Low Logic:\nNotice the logic pattern in this circuit:\n- **Button Released (Idle)**: Pin 2 reads **`HIGH`** (+5V).\n- **Button Pressed (Active)**: Pin 2 reads **`LOW`** (0V).\nBecause the active state is `LOW`, this is called **active-low logic**!",
        "quickCheck": [
          {
            "questionId": "l05_s06_q1",
            "question": "What hazardous condition occurs if you connect +5V directly to Ground with a plain wire and no resistance?",
            "options": [
              "A dead short circuit that draws extreme current and can damage hardware",
              "The microcontroller automatically increases its clock speed",
              "The breadboard changes color to blue"
            ],
            "correctIndex": 0,
            "explanation": "Joining power and ground with negligible resistance causes a dead short circuit, risking silicon damage.",
            "warmupExplanation": "Current equals voltage divided by resistance (I = V/R). Zero resistance leads to dangerous overcurrent."
          },
          {
            "questionId": "l05_s06_q2",
            "question": "In an active-low circuit with a pull-up resistor, what voltage level does the pin read when the button is pressed to GND?",
            "options": [
              "LOW (0.0 Volts / Ground)",
              "HIGH (+5.0 Volts)",
              "1023 Volts"
            ],
            "correctIndex": 0,
            "explanation": "Pressing the button connects the input directly to GND, pulling the pin voltage down to 0V (LOW).",
            "warmupExplanation": "Active-low circuits connect the input to ground when pressed, registering as LOW (0V)."
          }
        ]
      },
      {
        "stepId": "l05_06_s02",
        "title": "Tying Inputs to +5V Safely",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Pull-Up Circuit Architecture\nA 10k resistor connects the pin to +5V. When the button is unpressed, the pin reads HIGH. When pressed to GND, it reads LOW."
      },
      {
        "stepId": "l05_06_s03",
        "title": "Hands-On: Pull-Up Resistors",
        "type": "physicalTask",
        "interactiveWidgetType": "internalPullupCircuitDiagram",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how pull-up resistors operates in a circuit."
      },
      {
        "stepId": "l05_06_s04",
        "title": "Pull-Up Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What state does a pull-up resistor keep a pin in when the button is NOT pressed?",
              "options": [
                "HIGH (+5V)",
                "LOW (0V)",
                "Floating randomly"
              ],
              "correctIndex": 0,
              "explanation": "The pull-up resistor pulls the pin voltage up to +5V (HIGH) until grounded!"
            },
            {
              "question": "Why is a 10k resistor used instead of a direct wire to +5V?",
              "options": [
                "To limit current when the button connects the pin directly to Ground",
                "To speed up electrons",
                "To turn the pin blue"
              ],
              "correctIndex": 0,
              "explanation": "Without resistance, pressing a button connected to GND would cause a direct short circuit!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_07",
    "title": "INPUT_PULLUP",
    "summary": "Wiring an external 10k resistor on your breadboard for every single button takes up space and requires extra jumper wires.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l05_06"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s07",
        "title": "INPUT_PULLUP",
        "type": "codeExperiment",
        "interactiveWidgetType": "activeLowLogicChecker",
        "markdownContent": "### The Secret Silicon Superpower: Built-In Pull-Ups\nWiring an external 10k resistor on your breadboard for every single button takes up space and requires extra jumper wires. Fortunately, the designers of the ATmega328P microcontroller gave us a brilliant shortcut:\n\nEvery digital I/O pin on the Arduino Uno has an **internal 20kΩ to 50kΩ pull-up resistor** manufactured directly inside the silicon chip!\n\nAll you have to do is activate it in code using:\n```cpp\npinMode(buttonPin, INPUT_PULLUP);\n```\n\n```\nMinimalist 2-Wire Hardware Wiring:\n  Arduino Pin 2 <================== [ Pushbutton Leg A ]\n                                     [ Pushbutton Leg B ] <==== Arduino GND\n  (No external resistor or 5V power wire needed on breadboard!)\n```\n\n### The Canonical Active-Low Sketch:\n```cpp\nconst int buttonPin = 2;\nconst int ledPin = 13; // Built-in Uno LED\n\nvoid setup() {\n  pinMode(buttonPin, INPUT_PULLUP); // Turn ON internal pull-up resistor!\n  pinMode(ledPin, OUTPUT);          // Status indicator LED\n}\n\nvoid loop() {\n  int buttonState = digitalRead(buttonPin);\n\n  // Remember: In active-low logic, LOW means the button is PRESSED!\n  if (buttonState == LOW) {\n    digitalWrite(ledPin, HIGH); // Turn LED ON when pressed\n  } else {\n    digitalWrite(ledPin, LOW);  // Turn LED OFF when released\n  }\n}\n```\n\nWire one leg of your button to Pin 2, the other leg to GND, upload this sketch, and press the button: instant, rock-solid control!",
        "quickCheck": [
          {
            "questionId": "l05_s07_q1",
            "question": "What is the primary benefit of configuring a pin with pinMode(pin, INPUT_PULLUP)?",
            "options": [
              "It activates the Arduino's built-in pull-up resistor, eliminating the need for an external breadboard resistor",
              "It turns the pin into a high-voltage motor output",
              "It makes the Arduino run without USB power"
            ],
            "correctIndex": 0,
            "explanation": "`INPUT_PULLUP` uses the chip's internal 20k-50k resistor to hold the pin at 5V, reducing parts and wiring complexity.",
            "warmupExplanation": "The microcontroller has internal pull-up resistors in silicon that can be enabled with `INPUT_PULLUP`."
          },
          {
            "questionId": "l05_s07_q2",
            "question": "When using INPUT_PULLUP, what does digitalRead(pin) return when nobody is touching the button?",
            "options": [
              "HIGH (held at +5V by the internal pull-up)",
              "LOW (0V)",
              "Random fluctuating numbers"
            ],
            "correctIndex": 0,
            "explanation": "When unpressed, the internal pull-up holds the pin securely at 5V (HIGH) with zero floating noise.",
            "warmupExplanation": "The internal pull-up resistor pulls the pin voltage up to HIGH (+5V) when the switch is open."
          }
        ]
      },
      {
        "stepId": "l05_07_s02",
        "title": "Using the Built-In Microcontroller Resistors",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Activating Internal 20k-50k Resistors\nCalling pinMode(pin, INPUT_PULLUP); enables internal silicon resistors inside the chip!"
      },
      {
        "stepId": "l05_07_s03",
        "title": "Hands-On: INPUT_PULLUP",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how input_pullup operates in a circuit."
      },
      {
        "stepId": "l05_07_s04",
        "title": "INPUT_PULLUP Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What advantage does pinMode(pin, INPUT_PULLUP) provide?",
              "options": [
                "It eliminates the need for external breadboard resistors",
                "It makes the button click louder",
                "It powers heavy motors"
              ],
              "correctIndex": 0,
              "explanation": "Internal pull-ups save breadboard space and extra jumper wires!"
            },
            {
              "question": "With INPUT_PULLUP, what does digitalRead() return when the button IS pressed to GND?",
              "options": [
                "LOW (0)",
                "HIGH (1)",
                "255"
              ],
              "correctIndex": 0,
              "explanation": "Active-low logic: pressing the button connects the pin to Ground, reading LOW!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_08",
    "title": "Button Debouncing",
    "summary": "Imagine you write a sketch that increments a counter every time you press a button:",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l05_07"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s08",
        "title": "Button Debouncing",
        "type": "visualExplanation",
        "interactiveWidgetType": "switchBounceVisualizer",
        "markdownContent": "### The Microsecond Bounce: Why One Click Becomes Five\nImagine you write a sketch that increments a counter every time you press a button:\n```cpp\nint score = 0;\nvoid loop() {\n  if (digitalRead(buttonPin) == LOW) {\n    score++;\n    Serial.println(score);\n  }\n}\n```\nYou tap the button once quickly. You expect `score` to become `1`. Instead, the Serial Monitor prints:\n`1, 2, 3, 4, 7, 8!` Why did one gentle tap count as 8 presses?\n\n### The Physics of Contact Chatter\nTo human fingers, pressing a tactile button feels like a single instantaneous click. But microcontrollers run at **16,000,000 clock cycles per second**!\n\nInside the switch, two microscopic metal plates collide. Like dropping a bouncy rubber ball onto a hardwood floor, the metal contacts **bounce and vibrate against each other** for 1 to 10 milliseconds before settling into solid contact!\n\n```\nIdeal Human View:   HIGH -----------------\\__________________ LOW (Clean Step)\n\nSilicon Reality:    HIGH -------\\ | | | \\/\\/\\/\\______________ LOW (Contact Bounce!)\n                                  ^ ^ ^\n                          Rapid microsecond spikes!\n```\n\n### How to Debounce in Software:\n1. **Software Debounce Delay**: When you detect the initial `LOW` edge, wait a tiny duration (such as `delay(20)`) to let the mechanical vibrations settle before reading again.\n2. **State Change Tracking**: Store the `lastButtonState` and only increment the score when the button transitions from `HIGH` to `LOW` (the falling edge).\n3. **Hardware Debouncing**: Placing a small 100nF capacitor across the switch contacts absorbs the high-frequency voltage chatter physically!",
        "quickCheck": [
          {
            "questionId": "l05_s08_q1",
            "question": "Why does a mechanical pushbutton often register multiple button presses from a single finger tap?",
            "options": [
              "Mechanical metal contacts bounce against each other for several milliseconds upon colliding",
              "The Arduino Uno serial baud rate is too slow",
              "The microcontroller flash memory is running out of space"
            ],
            "correctIndex": 0,
            "explanation": "Microscopic contact bounce produces rapid voltage spikes that high-speed microcontrollers interpret as multiple presses.",
            "warmupExplanation": "Switch contacts vibrate mechanically when slamming shut; the fast microcontroller sees every vibration."
          },
          {
            "questionId": "l05_s08_q2",
            "question": "About how long does typical mechanical contact bounce last in tactile buttons?",
            "options": [
              "Between 1 and 20 milliseconds",
              "Several full minutes",
              "One hour"
            ],
            "correctIndex": 0,
            "explanation": "Contact bounce typically lasts between 1 and 20 milliseconds before the contacts settle firmly.",
            "warmupExplanation": "Switch bounce is very brief (a few milliseconds), but easily detectable at 16 MHz CPU speeds."
          }
        ]
      },
      {
        "stepId": "l05_08_s02",
        "title": "Filtering Mechanical Contact Bounce",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Contact Bounce Waveforms\nMetal switch contacts bounce microscopically for 5-10 milliseconds when pressed, causing dozens of false triggers."
      },
      {
        "stepId": "l05_08_s03",
        "title": "Hands-On: Button Debouncing",
        "type": "physicalTask",
        "interactiveWidgetType": "switchBounceVisualizer",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how button debouncing operates in a circuit."
      },
      {
        "stepId": "l05_08_s04",
        "title": "Debounce Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is switch contact bounce?",
              "options": [
                "Rapid microscopic mechanical bouncing of contacts creating multiple false pulses",
                "The button jumping off the desk",
                "A rubber coating on the switch"
              ],
              "correctIndex": 0,
              "explanation": "Mechanical contacts bounce like a basketball, triggering multiple edges within milliseconds!"
            },
            {
              "question": "How can code filter out switch bounce?",
              "options": [
                "By waiting a small delay (10-20ms) before re-checking button state",
                "By pressing harder",
                "By turning off the Arduino"
              ],
              "correctIndex": 0,
              "explanation": "Software debouncing checks that the signal remains steady for a few milliseconds!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_09",
    "title": "Meet the Potentiometer",
    "summary": "Buttons and switches are binary: either ON or OFF, black or white, 1 or 0.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l05_08"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s09",
        "title": "Meet the Potentiometer",
        "type": "physicalTask",
        "interactiveWidgetType": "wiperPinoutChecker",
        "markdownContent": "### Stepping Beyond Binary: Continuous Sensory Control\nButtons and switches are binary: either ON or OFF, black or white, 1 or 0. But the physical universe is not binary!\n- A robot's arm doesn't just snap between fully extended and fully retracted—it moves through a smooth arc of angles.\n- A sound volume dial doesn't jump from silent to deafening—it glides continuously.\n\nMeet **`comp_20`**: The **10kΩ Rotary Potentiometer** (engineers affectionately call it a \"pot\").\n\n### Anatomy of the Potentiometer\nPick up `comp_20` from your kit and examine its features:\n1. **Rotating Shaft**: A metal or plastic shaft that turns smoothly across about 270 degrees of rotation.\n2. **Three Stamped Terminal Pins**:\n   - **Pin 1 (Outer Leg)**: Connects to one end of an internal horseshoe-shaped carbon resistive strip.\n   - **Pin 2 (Center Leg)**: Connects to a movable metal contact called the **wiper** that sweeps along the carbon track as you turn the knob!\n   - **Pin 3 (Outer Leg)**: Connects to the opposite end of the carbon resistive strip.\n\n```\nPotentiometer Internal Cutaway:\n\n      Pin 1 (5V) ---------\\  (10k Horseshoe Carbon Track)\n                           \\    \n                            [ Wiper Arm ] <==== Pin 2 (Center Output)\n                           /    \n      Pin 3 (GND) --------/ \n```\n\n⚠️ **Safety Rule**: Never connect the center wiper pin directly between 5V and GND! The outer pins receive 5V and GND, while the center wiper connects to an **Analog Input pin** (such as A0).",
        "quickCheck": [
          {
            "questionId": "l05_s09_q1",
            "question": "How many external terminal pins does a standard rotary potentiometer possess?",
            "options": [
              "3 pins (two outer track ends and one center wiper)",
              "1 pin",
              "8 pins"
            ],
            "correctIndex": 0,
            "explanation": "A standard potentiometer has 3 pins: two outer fixed terminals and one movable center wiper terminal.",
            "warmupExplanation": "Potentiometers use two reference power pins and one variable center wiper pin."
          },
          {
            "questionId": "l05_s09_q2",
            "question": "What internal component moves when you rotate a potentiometer shaft?",
            "options": [
              "A conductive wiper arm that glides along a resistive track",
              "A miniature lithium battery",
              "An optical laser diode"
            ],
            "correctIndex": 0,
            "explanation": "Rotating the knob moves the wiper arm across the carbon track, tapping into different points of resistance.",
            "warmupExplanation": "A potentiometer has an internal wiper contact that slides across a resistive strip."
          }
        ]
      },
      {
        "stepId": "l05_09_s02",
        "title": "The 3-Pin Rotary Resistor",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Potentiometer Anatomy\nA resistive carbon strip with two outer power/GND legs and a center wiper leg that slides along the track."
      },
      {
        "stepId": "l05_09_s03",
        "title": "Hands-On: Meet the Potentiometer",
        "type": "physicalTask",
        "interactiveWidgetType": "wiperPinoutChecker",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how meet the potentiometer operates in a circuit."
      },
      {
        "stepId": "l05_09_s04",
        "title": "Potentiometer Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Which pin on a 3-pin potentiometer is the moving wiper contact?",
              "options": [
                "The middle pin",
                "The left outer pin",
                "The mounting bracket"
              ],
              "correctIndex": 0,
              "explanation": "The center pin connects to the movable wiper that slides along the resistive track!"
            },
            {
              "question": "What happens across the two outer pins of a 10k potentiometer?",
              "options": [
                "A constant total resistance of 10,000 Ohms",
                "Zero resistance",
                "Infinite resistance"
              ],
              "correctIndex": 0,
              "explanation": "The outer pins connect to the ends of the fixed 10k resistive strip!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_10",
    "title": "Voltage Divider",
    "summary": "The carbon track inside comp20 has a total resistance of 10,000  (10 k) from Pin 1 to Pin 3.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 10,
    "isOptional": false,
    "prerequisites": [
      "l05_09"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s10",
        "title": "Voltage Divider",
        "type": "visualExplanation",
        "interactiveWidgetType": "voltageDividerCutaway",
        "markdownContent": "### How Resistance Becomes Voltage\nThe carbon track inside `comp_20` has a total resistance of **10,000 Ω (10 kΩ)** from Pin 1 to Pin 3. How does turning the knob produce a variable voltage signal?\n\nThrough the universal electrical principle of the **Voltage Divider**!\n\nAs the center wiper moves along the track, it splits that 10k total resistance into two separate series resistors:\n- $R_1$: The resistance between Pin 1 (+5V) and the wiper.\n- $R_2$: The resistance between the wiper and Pin 3 (GND).\n\n```\n       +5V\n        |\n      [ R1 ]  <--- Resistance from 5V to Wiper\n        |\n        +---------> Wiper Output Voltage (Vout)\n        |\n      [ R2 ]  <--- Resistance from Wiper to GND\n        |\n       GND\n```\n\n### The Voltage Divider Formula:\n$$V_{out} = V_{in} \\times \\frac{R_2}{R_1 + R_2} = 5.0\\text{V} \\times \\frac{R_2}{10{,}000\\Omega}$$\n\n### Three Key Rotary Positions:\n1. **Turned Fully Counter-Clockwise (Wiper at GND)**:\n   $R_2 = 0\\Omega \\implies V_{out} = 5.0\\text{V} \\times \\frac{0}{10{,}000} = \\mathbf{0.00\\text{V}}$\n2. **Centered Exactly in the Middle**:\n   $R_1 = 5\\text{k}\\Omega, R_2 = 5\\text{k}\\Omega \\implies V_{out} = 5.0\\text{V} \\times \\frac{5{,}000}{10{,}000} = \\mathbf{2.50\\text{V}}$\n3. **Turned Fully Clockwise (Wiper at 5V)**:\n   $R_2 = 10\\text{k}\\Omega \\implies V_{out} = 5.0\\text{V} \\times \\frac{10{,}000}{10{,}000} = \\mathbf{5.00\\text{V}}$\n\nBy simply turning the knob, you smoothly command any analog voltage between 0.0V and 5.0V!",
        "quickCheck": [
          {
            "questionId": "l05_s10_q1",
            "question": "If a 10k potentiometer has its outer pins wired to 5V and GND, what voltage appears on the wiper when centered halfway?",
            "options": [
              "2.5 Volts (exactly half of the 5.0V supply)",
              "0.0 Volts",
              "10.0 Volts"
            ],
            "correctIndex": 0,
            "explanation": "At the midpoint, resistance splits equally (5kΩ and 5kΩ), dividing the 5V supply exactly in half to 2.5V.",
            "warmupExplanation": "A voltage divider with equal resistors splits the applied voltage equally in half."
          },
          {
            "questionId": "l05_s10_q2",
            "question": "What happens to the wiper voltage as you rotate the potentiometer shaft closer to the GND terminal?",
            "options": [
              "The voltage steadily decreases toward 0.0 Volts",
              "The voltage surges to 50 Volts",
              "The resistance between the outer terminals drops to zero"
            ],
            "correctIndex": 0,
            "explanation": "Moving the wiper closer to the ground terminal decreases R2, dropping the output voltage toward 0.0V.",
            "warmupExplanation": "Approaching the ground terminal pulls the wiper voltage down toward 0V reference."
          }
        ]
      },
      {
        "stepId": "l05_10_s02",
        "title": "How Division Creates Continuous Voltage",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "The Voltage Divider Equation\nVout = Vin * (R2 / (R1 + R2)). As the wiper turns, Vout varies smoothly between 0.0V and 5.0V!"
      },
      {
        "stepId": "l05_10_s03",
        "title": "Hands-On: Voltage Divider",
        "type": "physicalTask",
        "interactiveWidgetType": "voltageDividerCutaway",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how voltage divider operates in a circuit."
      },
      {
        "stepId": "l05_10_s04",
        "title": "Voltage Divider Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What does a voltage divider do to an input voltage?",
              "options": [
                "Outputs a proportional fraction of the input voltage based on resistance ratios",
                "Multiplies voltage by 10",
                "Turns DC into AC"
              ],
              "correctIndex": 0,
              "explanation": "Voltage dividers scale down voltages smoothly based on resistor ratios!"
            },
            {
              "question": "If a potentiometer is turned exactly to its center midpoint, what voltage appears at the wiper?",
              "options": [
                "2.5 Volts (half of 5V)",
                "0 Volts",
                "10 Volts"
              ],
              "correctIndex": 0,
              "explanation": "At midpoint, R1 equals R2, dividing 5V evenly to produce 2.5V!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_11",
    "title": "Analog Inputs",
    "summary": "Your Arduino's ATmega328P processor is purely digital.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 11,
    "isOptional": false,
    "prerequisites": [
      "l05_10"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s11",
        "title": "Analog Inputs",
        "type": "visualExplanation",
        "interactiveWidgetType": "adcSamplingVisualizer",
        "markdownContent": "### The Translation Problem: How Computers Read Voltages\nYour Arduino's ATmega328P processor is purely digital. Its arithmetic logic unit only understands binary 1s and 0s. How can it measure a smooth, continuous voltage like 2.37 Volts from a potentiometer?\n\nIt uses a specialized on-chip hardware peripheral called the **Analog-to-Digital Converter (ADC)**!\n\nOn the Arduino Uno, the ADC is connected to the six pins labeled **A0, A1, A2, A3, A4, and A5** along the lower board edge.\n\n```\nContinuous Analog Voltage (0.0V to 5.0V)\n                  |\n         [ 10-bit Successive ]\n         [ Approximation ADC ]\n                  |\nDiscrete Integer Range: 0 to 1023 (1024 unique steps)\n```\n\n### 10-Bit ADC Resolution Breakdown:\n- **10 Bits of Resolution**: In binary, 10 bits can represent $2^{10} = 1024$ unique integers (from **0 to 1023**).\n- **0** corresponds to **0.00 Volts** (GND).\n- **1023** corresponds to **5.00 Volts** (Full 5V supply rail).\n- **Resolution Step Size**: Each step represents:\n  $$\\text{Step Voltage} = \\frac{5.000\\text{ V}}{1023} \\approx 0.004887\\text{ V} = 4.89\\text{ mV}$$\n\nWhenever the input voltage changes by just 4.89 millivolts, the integer count shifts up or down by 1! The ADC takes approximately **100 microseconds** to perform this conversion, allowing your robot to sample analog inputs up to 10,000 times per second!",
        "quickCheck": [
          {
            "questionId": "l05_s11_q1",
            "question": "What integer value range does the Arduino Uno's 10-bit ADC produce?",
            "options": [
              "0 to 1023 (1024 discrete steps)",
              "0 to 255",
              "0 to 1",
              "-512 to +512"
            ],
            "correctIndex": 0,
            "explanation": "A 10-bit Analog-to-Digital Converter converts voltages into integers from 0 (0V) to 1023 (5V).",
            "warmupExplanation": "10 binary bits represent 2^10 = 1024 possible numbers, numbered from 0 up to 1023."
          },
          {
            "questionId": "l05_s11_q2",
            "question": "Which dedicated header pins on the Arduino Uno connect to the internal ADC?",
            "options": [
              "Pins A0 through A5",
              "Digital pins 0 and 1 only",
              "The AREF and RESET pins only"
            ],
            "correctIndex": 0,
            "explanation": "Pins labeled A0 through A5 on the Uno are dedicated analog inputs wired to the ADC multiplexer.",
            "warmupExplanation": "The pins designated with 'A' (A0-A5) are the analog input channels on the Uno."
          }
        ]
      },
      {
        "stepId": "l05_11_s02",
        "title": "The 10-Bit Analog-to-Digital Converter (ADC)",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Converting Voltage to Numbers\nThe ATmega328P ADC compares input voltages against 5V, slicing the range into 1024 discrete steps (0 to 1023)."
      },
      {
        "stepId": "l05_11_s03",
        "title": "Hands-On: Analog Inputs",
        "type": "physicalTask",
        "interactiveWidgetType": "adcSamplingVisualizer",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how analog inputs operates in a circuit."
      },
      {
        "stepId": "l05_11_s04",
        "title": "ADC Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How many bits of resolution does the Arduino Uno ADC have?",
              "options": [
                "10 bits (0 to 1023 levels)",
                "2 bits (0 to 3 levels)",
                "64 bits"
              ],
              "correctIndex": 0,
              "explanation": "The 10-bit converter maps 0V-5V across 1024 steps (0 to 1023)!"
            },
            {
              "question": "What pins on the Arduino Uno can read analog voltages?",
              "options": [
                "Pins A0 through A5",
                "Pins 0 through 13",
                "The USB jack"
              ],
              "correctIndex": 0,
              "explanation": "Pins labeled A0-A5 are connected to the internal analog multiplexer!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_12",
    "title": "analogRead",
    "summary": "To capture analog values in software, Arduino provides the built-in function analogRead():",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 12,
    "isOptional": false,
    "prerequisites": [
      "l05_11"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s12",
        "title": "analogRead",
        "type": "codeExperiment",
        "interactiveWidgetType": "potentiometerSimulator",
        "markdownContent": "### Streaming Analog Telemetry in Code\nTo capture analog values in software, Arduino provides the built-in function `analogRead()`:\n\n```cpp\nint rawReading = analogRead(A0); // Samples Analog Pin A0\n```\n\n### Two Crucial Things to Know:\n1. **No `pinMode()` Required!** Unlike digital pins that default to high-impedance inputs, calling `analogRead(A0)` automatically instructs the hardware ADC multiplexer to switch to Pin A0. You do NOT need `pinMode(A0, INPUT)` in `setup()`.\n2. **Translating Raw Counts to Real Volts**: To calculate true physical voltage in software:\n   ```cpp\n   float voltage = rawReading * (5.0 / 1023.0);\n   ```\n\n### Complete Analog Telemetry Sketch:\n```cpp\nconst int potPin = A0;\n\nvoid setup() {\n  Serial.begin(9600); // 9600 baud serial telemetry\n}\n\nvoid loop() {\n  int rawValue = analogRead(potPin);         // 0 to 1023\n  float voltage = rawValue * (5.0 / 1023.0); // Convert to volts\n\n  Serial.print(\"Raw ADC: \");\n  Serial.print(rawValue);\n  Serial.print(\" | Voltage: \");\n  Serial.print(voltage, 2);\n  Serial.println(\" V\");\n\n  delay(100); // 10 readings per second\n}\n```\n\nUpload this code and rotate the potentiometer knob. Watch the raw integer count and calculated voltage glide smoothly between `0 (0.00V)` and `1023 (5.00V)`!",
        "quickCheck": [
          {
            "questionId": "l05_s12_q1",
            "question": "Is it mandatory to declare pinMode(A0, INPUT) in setup() before calling analogRead(A0)?",
            "options": [
              "No, analogRead() automatically configures the internal ADC multiplexer for that pin",
              "Yes, omitting pinMode causes a compilation error",
              "Yes, pinMode must be set to OUTPUT"
            ],
            "correctIndex": 0,
            "explanation": "Analog pins automatically configure their internal ADC circuitry upon calling `analogRead()`, so `pinMode` is optional.",
            "warmupExplanation": "The Arduino core automatically configures analog pins when `analogRead()` is invoked."
          },
          {
            "questionId": "l05_s12_q2",
            "question": "If analogRead(A0) returns a reading of approximately 512, what voltage is present on pin A0?",
            "options": [
              "Approximately 2.50 Volts",
              "0.00 Volts",
              "5.00 Volts"
            ],
            "correctIndex": 0,
            "explanation": "512 is halfway between 0 and 1023, representing exactly half of 5.0V (2.5V).",
            "warmupExplanation": "512 / 1023 is approximately 50%, which corresponds to 2.5V out of 5.0V."
          }
        ]
      },
      {
        "stepId": "l05_12_s02",
        "title": "Reading Variable Signals in Code",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "The analogRead() Function\nint sensorVal = analogRead(A0); returns a number between 0 and 1023 in about 100 microseconds."
      },
      {
        "stepId": "l05_12_s03",
        "title": "Hands-On: analogRead",
        "type": "codeExperiment",
        "interactiveWidgetType": "codeDeconstruction",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how analogread operates in a circuit."
      },
      {
        "stepId": "l05_12_s04",
        "title": "analogRead Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What range of integer values does analogRead() return on an Uno?",
              "options": [
                "0 to 1023",
                "0 to 255",
                "HIGH or LOW only"
              ],
              "correctIndex": 0,
              "explanation": "10-bit analogRead() produces numbers from 0 (0V) up to 1023 (5V)!"
            },
            {
              "question": "What reading does analogRead() return if an analog pin is connected directly to 5V?",
              "options": [
                "1023",
                "500",
                "0"
              ],
              "correctIndex": 0,
              "explanation": "Full supply voltage (5.0V) reaches the maximum 10-bit ADC value: 1023!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_13",
    "title": "Button + LED",
    "summary": "Now let's synthesize inputs and outputs together!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 13,
    "isOptional": false,
    "prerequisites": [
      "l05_12"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s13",
        "title": "Button + LED",
        "type": "physicalTask",
        "markdownContent": "### The Fundamental Loop of Robotics: Input Directly Driving Output\nNow let's synthesize inputs and outputs together! We will build a circuit where a physical pushbutton directly commands an LED.\n\n### Breadboard Circuit Assembly:\n1. **Pushbutton**: Place the button straddling the breadboard center ravine.\n   - Wire Leg A to Arduino **Digital Pin 2**.\n   - Wire opposing Leg B to Arduino **GND**.\n2. **LED Indicator**:\n   - Connect a 220Ω resistor from Arduino **Digital Pin 8** to the breadboard.\n   - Connect the LED long leg (Anode, +) to the resistor.\n   - Connect the LED short leg (Cathode, −) to **GND**.\n\n```\nWiring Diagram:\n  Pin 2 ======= [ Button ] ======= GND   (Active-low with INPUT_PULLUP)\n  Pin 8 ===[ 220R Resistor ]===>|=== GND   (Standard LED output)\n```\n\n### The Sketch:\n```cpp\nconst int buttonPin = 2;\nconst int ledPin = 8;\n\nvoid setup() {\n  pinMode(buttonPin, INPUT_PULLUP);\n  pinMode(ledPin, OUTPUT);\n}\n\nvoid loop() {\n  int pressed = (digitalRead(buttonPin) == LOW);\n\n  if (pressed) {\n    digitalWrite(ledPin, HIGH); // Light ON while button is held\n  } else {\n    digitalWrite(ledPin, LOW);  // Light OFF when button released\n  }\n}\n```\n\n### Challenge: Toggle Mode (Push ON, Push OFF)\nCan you modify the code so the LED flips state and stays ON even after you release the button? That's software latching—you've built a software toggle switch!",
        "quickCheck": [
          {
            "questionId": "l05_s13_q1",
            "question": "Why must an external LED have a resistor in series when driven by an Arduino digital pin?",
            "options": [
              "To limit electric current and protect both the LED semiconductor and Arduino pin from burning out",
              "To change the color of the emitted light",
              "To convert direct current into alternating current"
            ],
            "correctIndex": 0,
            "explanation": "LEDs have negligible internal resistance; a series resistor prevents destructive overcurrent.",
            "warmupExplanation": "Remember from Lesson 4: LEDs draw excessive current unless protected by a current-limiting resistor."
          },
          {
            "questionId": "l05_s13_q2",
            "question": "How do you invert your code so the LED stays ON normally and turns OFF only when the button is held?",
            "options": [
              "Change the condition to write HIGH when buttonState == HIGH, and LOW when buttonState == LOW",
              "Reverse the power wires on the Arduino Uno",
              "Change the baud rate in Serial.begin()"
            ],
            "correctIndex": 0,
            "explanation": "Flipping the conditional logic in code inverts how the output responds to the physical input state.",
            "warmupExplanation": "Software logic controls the relationship: flipping your `if-else` branch reverses the action."
          }
        ]
      },
      {
        "stepId": "l05_13_s02",
        "title": "Combining Inputs and Outputs",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Physical Interaction\nRead the button state with digitalRead() and command the LED with digitalWrite() in a real-time response loop."
      },
      {
        "stepId": "l05_13_s03",
        "title": "Hands-On: Button + LED",
        "type": "physicalTask",
        "interactiveWidgetType": "blinkSimulator",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how button + led operates in a circuit."
      },
      {
        "stepId": "l05_13_s04",
        "title": "Button + LED Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How can a robot react immediately when a bumper button is pressed?",
              "options": [
                "Read the pin inside loop() and update the output state in an IF statement",
                "Wait 10 minutes",
                "Unplug the power"
              ],
              "correctIndex": 0,
              "explanation": "Continually polling inputs in loop() allows the robot to respond in microseconds!"
            },
            {
              "question": "What happens if you forget to set the LED pin to OUTPUT in setup()?",
              "options": [
                "The LED will be extremely dim or fail to illuminate properly",
                "The computer reboots",
                "The LED explodes"
              ],
              "correctIndex": 0,
              "explanation": "Pins default to high-impedance inputs; OUTPUT mode is required to deliver driving current!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_14",
    "title": "Potentiometer -> LED Brightness",
    "summary": "Now let's connect an analog input directly to an analog output: a rotary dimmer switch!",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 14,
    "isOptional": false,
    "prerequisites": [
      "l05_13"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s14",
        "title": "Potentiometer -> LED Brightness",
        "type": "physicalTask",
        "interactiveWidgetType": "potentiometerSimulator",
        "markdownContent": "### The Range Mismatch Problem\nNow let's connect an analog input directly to an analog output: a **rotary dimmer switch**!\n\nWhen we wire our potentiometer to Pin A0 and our LED to PWM Pin 9, we run directly into the most famous mathematical puzzle in rookie robotics:\n- **`analogRead()`** returns a **10-bit** number from **0 to 1023**.\n- **`analogWrite()`** (PWM duty cycle) only accepts an **8-bit** number from **0 to 255**!\n\nIf you pass `1023` directly into `analogWrite()`, the 8-bit timer register overflows, causing the LED to flash wildly and reset its brightness four times across the knob's rotation!\n\n```\nAnalog Input Range:   0 ======================================> 1023  (10-bit)\n                                        |\n                                [ Scaled by / 4 ]\n                                        v\nPWM Output Range:     0 ====================> 255                     (8-bit)\n```\n\n### Two Ways to Solve the Mismatch in Code:\n1. **Integer Division**: Since $1023 / 4 \\approx 255$, simply divide by 4:\n   ```cpp\n   int brightness = analogRead(A0) / 4;\n   ```\n2. **The map() Function**: Arduino includes a handy linear mapping utility:\n   ```cpp\n   int brightness = map(analogRead(A0), 0, 1023, 0, 255);\n   ```\n\n### The Complete Dimmer Sketch:\n```cpp\nconst int potPin = A0;\nconst int ledPin = 9; // Must be a PWM pin (~)\n\nvoid setup() {\n  pinMode(ledPin, OUTPUT);\n}\n\nvoid loop() {\n  int sensorVal = analogRead(potPin);\n  int brightness = map(sensorVal, 0, 1023, 0, 255);\n  analogWrite(ledPin, brightness); // Modulate PWM duty cycle\n  delay(15);\n}\n```\n\nTurn the dial and marvel at the silky smooth brightness transition from total dark to blinding brilliance!",
        "quickCheck": [
          {
            "questionId": "l05_s14_q1",
            "question": "What numeric range does analogWrite() accept on an Arduino Uno PWM pin?",
            "options": [
              "0 to 255 (8-bit resolution)",
              "0 to 1023",
              "HIGH or LOW only",
              "-100 to +100"
            ],
            "correctIndex": 0,
            "explanation": "`analogWrite()` modulates PWM duty cycle using an 8-bit value from 0 (0% duty cycle) to 255 (100% duty cycle).",
            "warmupExplanation": "PWM outputs in Arduino use 8-bit resolution, which spans from 0 to 255."
          },
          {
            "questionId": "l05_s14_q2",
            "question": "Why must you divide analogRead() by 4 or use map() before sending the value to analogWrite()?",
            "options": [
              "Because analogRead is 10-bit (0-1023) while analogWrite only takes 8-bit (0-255)",
              "Because analogWrite requires negative numbers",
              "Because the potentiometer will overheat otherwise"
            ],
            "correctIndex": 0,
            "explanation": "Passing values greater than 255 into `analogWrite()` causes register overflow and erratic brightness jumps.",
            "warmupExplanation": "10-bit input (0-1023) is 4 times larger than 8-bit output (0-255), requiring scaling."
          }
        ]
      },
      {
        "stepId": "l05_14_s02",
        "title": "Mapping 10-Bit Input to 8-Bit Output",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "The map() Function\nint brightness = map(sensorVal, 0, 1023, 0, 255); scales the analog input range down to PWM range!"
      },
      {
        "stepId": "l05_14_s03",
        "title": "Hands-On: Potentiometer -> LED Brightness",
        "type": "physicalTask",
        "interactiveWidgetType": "potentiometerSimulator",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how potentiometer -> led brightness operates in a circuit."
      },
      {
        "stepId": "l05_14_s04",
        "title": "Map Function Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "Why must an analogRead value (0-1023) be scaled down before passing to analogWrite (0-255)?",
              "options": [
                "analogRead is 10-bit (0-1023) while analogWrite is 8-bit (0-255)",
                "To save memory",
                "Because numbers over 255 are illegal"
              ],
              "correctIndex": 0,
              "explanation": "analogWrite only accepts 0-255. Dividing by 4 or using map() scales the ranges correctly!"
            },
            {
              "question": "What convenient Arduino function rescales a number from one range to another?",
              "options": [
                "map(value, fromLow, fromHigh, toLow, toHigh)",
                "convert()",
                "scaleNumber()"
              ],
              "correctIndex": 0,
              "explanation": "The built-in map() function calculates proportional scaling between any two numerical ranges!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_15",
    "title": "Potentiometer -> RGB Color",
    "summary": "In Lesson 4, you discovered that an RGB LED contains three microscopic diodes (Red, Green, Blue) packaged inside a single lens.",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 15,
    "isOptional": false,
    "prerequisites": [
      "l05_14"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s15",
        "title": "Potentiometer -> RGB Color",
        "type": "physicalTask",
        "interactiveWidgetType": "rgbColorSynthesizer",
        "markdownContent": "### The Rainbow Dial: Multi-Channel Control\nIn Lesson 4, you discovered that an RGB LED contains three microscopic diodes (Red, Green, Blue) packaged inside a single lens. By mixing different brightness levels on PWM pins ~9, ~10, and ~11, you can produce any color in the rainbow!\n\nNow, let's use a single rotary potentiometer knob to steer your monster robot through the entire color spectrum!\n\n### Zone-Based Color Selector\nDivide the potentiometer's 0 to 1023 range into four equal color zones:\n- **Zone 1 (0 to 255)**: Pure Ruby Red\n- **Zone 2 (256 to 511)**: Amber Yellow (Red + Green)\n- **Zone 3 (512 to 767)**: Emerald Green\n- **Zone 4 (768 to 1023)**: Electric Monster Blue\n\n```cpp\nconst int potPin = A0;\nconst int redPin = 9;\nconst int greenPin = 10;\nconst int bluePin = 11;\n\nvoid setup() {\n  pinMode(redPin, OUTPUT);\n  pinMode(greenPin, OUTPUT);\n  pinMode(bluePin, OUTPUT);\n}\n\nvoid setColor(int r, int g, int b) {\n  analogWrite(redPin, r);\n  analogWrite(greenPin, g);\n  analogWrite(bluePin, b);\n}\n\nvoid loop() {\n  int val = analogRead(potPin);\n\n  if (val < 256) {\n    setColor(255, 0, 0);     // Red\n  } else if (val < 512) {\n    setColor(255, 200, 0);   // Yellow\n  } else if (val < 768) {\n    setColor(0, 255, 0);     // Green\n  } else {\n    setColor(0, 0, 255);     // Blue\n  }\n  delay(20);\n}\n```\n\n### Advanced Monster Lab Challenge:\nAdd a pushbutton on Pin 2! When the button is unpressed, turning the knob changes the **Color**. When the button is pressed down, turning the knob adjusts the overall **Brightness**! You have built a multi-function menu controller!",
        "quickCheck": [
          {
            "questionId": "l05_s15_q1",
            "question": "What type of Arduino pins must you connect to an RGB LED's color channels to mix custom colors?",
            "options": [
              "PWM pins designated with a tilde ~ (such as 9, 10, 11)",
              "Analog input pins A0 through A5 only",
              "Only the 5V power and Reset pins"
            ],
            "correctIndex": 0,
            "explanation": "PWM pins provide variable duty cycles via `analogWrite()`, enabling color mixing on RGB LEDs.",
            "warmupExplanation": "RGB color mixing requires PWM output pins to adjust the individual brightness of each color channel."
          },
          {
            "questionId": "l05_s15_q2",
            "question": "How can a continuous potentiometer reading (0 to 1023) select between four distinct robot modes?",
            "options": [
              "By dividing the 0-1023 range into four numeric threshold zones in code",
              "By rotating the knob faster than 500 RPM",
              "By toggling the computer's USB port"
            ],
            "correctIndex": 0,
            "explanation": "Threshold intervals in code allow a continuous analog signal to select discrete operating states or colors.",
            "warmupExplanation": "Code can divide numeric ranges into discrete buckets using `if-else` threshold comparisons."
          }
        ]
      },
      {
        "stepId": "l05_15_s02",
        "title": "Multi-Threshold Color Selection",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Color Tuning Dial\nTurn the dial to glide through rainbow colors as thresholds route PWM power to different channels."
      },
      {
        "stepId": "l05_15_s03",
        "title": "Hands-On: Potentiometer -> RGB Color",
        "type": "physicalTask",
        "interactiveWidgetType": "rgbMixer",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how potentiometer -> rgb color operates in a circuit."
      },
      {
        "stepId": "l05_15_s04",
        "title": "Color Dial Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "How can a single rotary knob select among multiple colors?",
              "options": [
                "Divide the 0-1023 reading into ranges using IF/ELSE checks or math equations",
                "Paint the knob red",
                "Twist the wires together"
              ],
              "correctIndex": 0,
              "explanation": "Splitting the 0-1023 range into segments lets one knob select presets or blend colors!"
            },
            {
              "question": "What visual component helps learners verify sensor readings in real time?",
              "options": [
                "The Arduino IDE Serial Plotter and Serial Monitor",
                "A paper drawing",
                "A multimeter without batteries"
              ],
              "correctIndex": 0,
              "explanation": "The Serial Monitor and Plotter show live numerical graphs of potentiometer movements!"
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l05_16",
    "title": "Input Challenge",
    "summary": "You have mastered both sides of the physical input spectrum:",
    "tier": "rookie",
    "estimatedMinutes": 5,
    "courseId": "lesson_05",
    "sortOrder": 16,
    "isOptional": false,
    "prerequisites": [
      "l05_15"
    ],
    "componentIds": [
      "comp_uno",
      "comp_20"
    ],
    "steps": [
      {
        "stepId": "l05_s16",
        "title": "Input Challenge",
        "type": "quizCheckpoint",
        "markdownContent": "### The Input Master Challenge\nCongratulations, Monster Engineer! You have mastered both sides of the physical input spectrum:\n- **Digital Inputs**: Mechanical contact switches, active-low logic, internal pull-up resistors, and contact debouncing.\n- **Analog Inputs**: Rotary potentiometers, voltage dividers, the 10-bit ADC, and mapping analog sensor telemetry into actuator output commands.\n\nDemonstrate your complete mastery by completing this 8-question input engineering challenge!",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What does digitalRead(pin) return when an active-low button wired with INPUT_PULLUP is physically pressed to GND?",
              "options": [
                "LOW (0)",
                "HIGH (1)",
                "1023",
                "-1"
              ],
              "correctIndex": 0,
              "explanation": "In an active-low circuit, pressing the button connects the pin directly to Ground, making digitalRead() return LOW."
            },
            {
              "questionId": "q2",
              "question": "Why is an internal pull-up resistor essential when reading a button connected between a pin and Ground?",
              "options": [
                "It prevents the pin from floating and picking up stray electromagnetic noise when the button is open",
                "It increases the battery voltage to 24 volts",
                "It slows down the CPU to save flash memory",
                "It makes the button flash different colors"
              ],
              "correctIndex": 0,
              "explanation": "Without a pull-up resistor, an open input pin floats and oscillates wildly between HIGH and LOW."
            },
            {
              "question": "What physical phenomenon causes a mechanical button to register multiple false clicks during a single press?",
              "options": [
                "Mechanical contact bounce as internal metal contacts vibrate against each other",
                "Solar radiation heating the breadboard",
                "The Arduino USB cable is upside down",
                "The pull-up resistor has too much resistance"
              ],
              "correctIndex": 0,
              "explanation": "Microscopic mechanical contact chatter causes rapid voltage oscillations lasting several milliseconds upon closing."
            },
            {
              "question": "What happens if you accidentally connect a potentiometer's center wiper to 5V and an outer leg to GND, then turn the knob fully?",
              "options": [
                "A dead short circuit between 5V and GND occurs, triggering USB safety shutdown",
                "The potentiometer produces a musical tone",
                "The LED blinks twice as fast",
                "Nothing unusual happens"
              ],
              "correctIndex": 0,
              "explanation": "Connecting the wiper to 5V and turning it to the GND terminal creates a zero-resistance path between 5V and GND (dead short)."
            },
            {
              "question": "What voltage does a 10k potentiometer supply to its wiper when connected between 5V and GND and centered exactly halfway?",
              "options": [
                "2.50 Volts",
                "0.00 Volts",
                "5.00 Volts",
                "1.25 Volts"
              ],
              "correctIndex": 0,
              "explanation": "At the exact center, the resistance splits equally into two 5k resistors, dividing the 5V supply to 2.5V."
            },
            {
              "question": "What integer range does the Arduino Uno's internal 10-bit ADC produce when reading analogRead(A0)?",
              "options": [
                "0 to 1023",
                "0 to 255",
                "0 to 1",
                "1 to 100"
              ],
              "correctIndex": 0,
              "explanation": "A 10-bit ADC provides 1024 discrete integer steps, ranging from 0 (0.0V) to 1023 (5.0V)."
            },
            {
              "question": "Why must you divide an analogRead() value by 4 (or use map()) before passing it to analogWrite() on a PWM pin?",
              "options": [
                "Because analogRead() outputs 10 bits (0-1023) but analogWrite() only accepts 8 bits (0-255)",
                "Because analogWrite() only works with even numbers",
                "Because 4 is the lucky number of physical computing",
                "Because PWM pins operate at 400 MHz"
              ],
              "correctIndex": 0,
              "explanation": "analogRead produces 0-1023 (10-bit), while analogWrite accepts 0-255 (8-bit). Scaling is required to prevent overflow."
            },
            {
              "question": "How many external jumper wires are needed to connect a pushbutton to Arduino using INPUT_PULLUP?",
              "options": [
                "Exactly 2 wires (one to the digital pin, one to GND)",
                "4 wires including 5V and external resistors",
                "1 wire with no ground connection",
                "6 wires"
              ],
              "correctIndex": 0,
              "explanation": "INPUT_PULLUP enables the internal resistor, so you only need two wires: one from the pin to the switch, and one from the switch to GND."
            }
          ]
        },
        "quickCheck": [
          {
            "questionId": "l05_s16_q1",
            "question": "What fundamental property distinguishes digital inputs from analog inputs on an Arduino?",
            "options": [
              "Digital inputs measure binary HIGH/LOW states, while analog inputs measure continuous voltage from 0 to 1023",
              "Digital inputs only work during the daytime",
              "Analog inputs can only connect to loudspeakers"
            ],
            "correctIndex": 0,
            "explanation": "Digital inputs measure two binary voltage levels (HIGH/LOW), while analog inputs convert continuous voltages to a 10-bit range (0-1023).",
            "warmupExplanation": "Digital inputs evaluate binary logic states (HIGH/LOW); analog inputs measure continuous voltage gradients (0-1023)."
          },
          {
            "questionId": "l05_s16_q2",
            "question": "When wiring a pushbutton between an Arduino pin and GND, which code declaration ensures reliable, stable readings?",
            "options": [
              "pinMode(pin, INPUT_PULLUP)",
              "pinMode(pin, OUTPUT)",
              "digitalWrite(pin, 1023)"
            ],
            "correctIndex": 0,
            "explanation": "`pinMode(pin, INPUT_PULLUP)` enables the internal pull-up resistor, holding the pin HIGH until pressed to GND.",
            "warmupExplanation": "`INPUT_PULLUP` engages the internal resistor so the input pin stays stable at 5V when the switch is open."
          }
        ]
      },
      {
        "stepId": "l05_16_s02",
        "title": "The Physical Controls Capstone",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "Interactive Console Capstone\nCombine two pushbuttons and one potentiometer to build a full robotic cockpit control console!"
      },
      {
        "stepId": "l05_16_s03",
        "title": "Hands-On: Input Challenge",
        "type": "physicalTask",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Interactive Bench Activity\nUse the simulated tool to test and observe how input challenge operates in a circuit."
      },
      {
        "stepId": "l05_16_s04",
        "title": "Controls Capstone Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Check your understanding of physical inputs and circuit mechanics.",
        "interactiveConfig": {
          "questions": [
            {
              "question": "What is the golden rule of electrical workbench wiring?",
              "options": [
                "Always disconnect power before placing or rearranging wires",
                "Wire everything as fast as possible",
                "Never use resistors"
              ],
              "correctIndex": 0,
              "explanation": "Unplugging power protects delicate chips and prevents accidental short circuits!"
            },
            {
              "question": "What makes physical inputs so exciting in robotics engineering?",
              "options": [
                "They allow human operators and the physical environment to guide robot behavior",
                "They use up spare pins",
                "They require no code"
              ],
              "correctIndex": 0,
              "explanation": "Physical inputs bridge the gap between people and machines, turning static circuits into interactive robots!"
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "l06_01",
    "title": "What Is a Circuit?",
    "summary": "In Lesson 5, you commanded an on-board LED to flash.",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l05_16"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s01",
        "title": "What Is a Circuit?",
        "type": "story",
        "markdownContent": "# What Is a Circuit?\n\nWelcome to physical hardware building! In Lesson 5, you commanded an on-board LED to flash. Now, it is time to leap beyond the board and build real, tangible circuits on your workbench!\n\n### The Closed Loop Principle\nAn electrical circuit is a **complete, unbroken loop** through which electrical energy travels:\n\n```\nPower (+5V) ➔ Conductor Wires ➔ Working Device (LED / Sensor) ➔ Ground Return (GND)\n```\n\n1. **Energy leaves the source**: Positive voltage (+5V) pushes electrical charges forward.\n2. **Energy does useful work**: As charges travel through components (like an LED or buzzer), electrical energy transforms into photons (light), sound, or motion.\n3. **Energy returns home**: Electricity must return to **Ground (GND)**. If the return highway to GND is missing, current stops instantly!\n\n### Open vs. Closed Circuits\n- **Closed Circuit**: A continuous conductive pathway connects +5V all the way to GND. Electricity flows and components activate!\n- **Open Circuit**: A broken wire, loose pin, or open switch interrupts the path. Current drops to 0 mA immediately, and the circuit sleeps.\n- **Short Circuit**: When +5V connects straight into GND with zero resistance in between! Electricity rushes dangerously fast without doing work. Always place protective components like resistors in your circuits!\n\n### Bench Rule #1\n**Always unplug your Arduino USB cable before modifying or inserting wires on your workbench!**",
        "quickCheck": [
          {
            "questionId": "q_l06_s01_01",
            "question": "What is required for electricity to flow and power an electronic component?",
            "options": [
              "A wireless internet connection to the cloud",
              "A closed, continuous loop connecting power (+5V) to Ground (GND)",
              "Only a single wire connected to 5V with no return path",
              "An open gap in the wire so air can flow through"
            ],
            "correctIndex": 1,
            "explanation": "Electricity requires a closed, unbroken loop from the power source (+5V) through components and back to Ground (GND) to flow.",
            "warmupExplanation": "Electric current flows like water in a closed loop. It must have a way out (+5V) and an unbroken return path home (GND)."
          },
          {
            "questionId": "q_l06_s01_02",
            "question": "What happens when a circuit is 'open' (has a loose wire or disconnected pin)?",
            "options": [
              "Electric current stops flowing immediately and components turn off",
              "Electricity leaps through the air as sparks",
              "The components work twice as fast",
              "The Arduino generates extra battery power"
            ],
            "correctIndex": 0,
            "explanation": "In an open circuit, the electrical path is broken, so no current can flow and devices turn off.",
            "warmupExplanation": "Think of a drawbridge: when open, traffic stops completely. In electronics, any gap halts current flow."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_02",
    "title": "Meet the Breadboard",
    "summary": "Take your solderless breadboard (compbreadboard) out of your kit.",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l06_01"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s02",
        "title": "Meet the Breadboard",
        "type": "physicalTask",
        "markdownContent": "# Meet the Breadboard\n\nTake your solderless breadboard (`comp_breadboard`) out of your kit. This is your electronic sandbox where circuits come alive!\n\n### Why Is It Called a 'Breadboard'?\nIn the 1920s, early radio tinkerers literally grabbed wooden bread-cutting boards from their family kitchens and hammered metal nails into the wood to mount radio tubes and coils without permanent soldering. Today's modern breadboard has hundreds of reusable spring clips hidden underneath smooth plastic!\n\n### Anatomy of the Breadboard\n- **Tie-Points (Holes)**: Grid holes spaced exactly 0.1 inches (2.54 mm) apart—the international standard for electronic pins.\n- **Internal Spring Clips**: Inside every tiny hole is a bronze spring clip that grips your wire pins and bonds them together electrically.\n- **Power Rails (Outer Edges)**: Two long columns running down each side, clearly painted with red `+` and blue/black `-` lines.\n- **Terminal Columns & Numbered Rows**: Numbered horizontal strips (1 to 30 or 1 to 60) divided by a central canyon.\n\n### Hands-On Exploration:\n1. Unplug the Arduino from USB.\n2. Pick up a male-to-male jumper wire.\n3. Gently push one metal pin into any breadboard hole.\n4. Notice the firm mechanical grip of the internal spring clip holding your wire securely!\n5. Pull it out gently—no solder, no glue, 100% reusable!",
        "quickCheck": [
          {
            "questionId": "q_l06_s02_01",
            "question": "What safe habit should you always follow before placing or moving wires on your breadboard?",
            "options": [
              "Leave USB power running so you can see sparks",
              "Submerge the breadboard in water to keep it cool",
              "Unplug the Arduino USB cable to safely remove power",
              "Press the reset button continuously with both hands"
            ],
            "correctIndex": 2,
            "explanation": "Always disconnect USB power before moving or adding wires. This prevents accidental short circuits while working!",
            "warmupExplanation": "Safety first! Turning off power or unplugging USB before touching wires protects your board and computer."
          },
          {
            "questionId": "q_l06_s02_02",
            "question": "Why do roboticists and engineers build prototypes on a solderless breadboard?",
            "options": [
              "To connect and test circuits quickly without melting solder or using permanent glue",
              "Because breadboards generate their own high-voltage electricity",
              "To slice sandwiches while coding firmware",
              "Because pins can never be unplugged once inserted"
            ],
            "correctIndex": 0,
            "explanation": "Breadboards use internal spring clips that allow parts and wires to be plugged in, tested, and moved easily without soldering.",
            "warmupExplanation": "A breadboard is like reusable building blocks: you can push pins in, test your circuit, and pull them out freely."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_03",
    "title": "Breadboard Rows and Rails",
    "summary": "To wire like a master roboticist, you must visualize what is happening beneath the plastic faceplate!",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l06_02"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s03",
        "title": "Breadboard Rows and Rails",
        "type": "visualExplanation",
        "markdownContent": "# Breadboard Rows and Rails\n\nTo wire like a master roboticist, you must visualize what is happening beneath the plastic faceplate!\n\n### 1. Terminal Rows (Short Horizontal Bridges)\nLook at the numbered rows in the center (Row 1, Row 2, Row 3...):\n- On the left side, the five holes marked **a, b, c, d, e** are connected together by a single horizontal metal clip.\n- On the right side, the five holes marked **f, g, h, i, j** share another separate metal clip.\n- **The Rule**: Any two wires plugged into the same 5-hole group (for example, `10a` and `10c`) are touching each other electrically!\n\n### 2. The Center Ravine (Trough)\nNotice the deep plastic trench running right down the middle of the board:\n- It electrically isolates group `a–e` from group `f–j`.\n- Hole `10e` does **NOT** connect to hole `10f`! This lets integrated circuits (chips) straddle the trench without shorting their opposite pins together.\n\n### 3. Power Rails (Long Vertical Highways)\n- **Red Rail (+)**: Runs vertically along the edge to distribute positive voltage (+5V) across your entire board.\n- **Blue/Black Rail (-)**: Runs vertically along the edge to deliver Ground (0V / GND) everywhere.\n\n### Common Beginner Traps:\n- **Trap A (Shorting out a part)**: Plugging both legs of a resistor or LED into the *same* 5-hole row! That connects both legs together, completely bypassing the component!\n- **Trap B (Unconnected row leap)**: Plugging a wire into `10e` and expecting it to connect to `10f` across the trench without a jumper wire bridge.",
        "quickCheck": [
          {
            "questionId": "q_l06_s03_01",
            "question": "If you plug one wire into hole 12a and another wire into hole 12d on the same breadboard half, what happens?",
            "options": [
              "The two wires are completely isolated from each other",
              "The two wires are electrically joined by an internal metal spring clip",
              "A circuit breaker will trip immediately",
              "Hole 12d converts the signal into high-voltage AC"
            ],
            "correctIndex": 1,
            "explanation": "Holes in the same numbered group (columns a through e in row 12) share an internal metal spring strip, connecting them together.",
            "warmupExplanation": "Remember: Within columns a to e of any row, all five holes share the same internal metal connector."
          },
          {
            "questionId": "q_l06_s03_02",
            "question": "Does an internal metal connection link Row 15 column 'e' across the center ravine to Row 15 column 'f'?",
            "options": [
              "No, the center ravine separates the left and right halves into two distinct electrical areas",
              "Yes, all ten holes in a row are always joined straight across the ravine",
              "Yes, but only if the Arduino is connected to a computer",
              "No, because the center ravine is filled with copper wire"
            ],
            "correctIndex": 0,
            "explanation": "The center ravine splits the row into two separate halves (a-e and f-j), allowing multi-pin chips to sit across the gap without shorting.",
            "warmupExplanation": "Think of the center trench as a river: left bank (a-e) and right bank (f-j) are separate unless you build a wire bridge across it."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_04",
    "title": "Resistors",
    "summary": "Why does almost every LED circuit need a resistor?",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l06_03"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s04",
        "title": "Resistors",
        "type": "visualExplanation",
        "markdownContent": "# Resistors: The Guardians of Your Circuit\n\nWhy does almost every LED circuit need a resistor? Let's uncover the guardian of your electronic parts!\n\n### The Water Hose Analogy\nImagine a giant fire hose hooked to high water pressure. If you attach a fragile paper balloon directly to the wide open nozzle, the immense rush of water bursts the balloon in a fraction of a second!\n\nA **resistor** acts like an adjustable pinch-valve or narrow nozzle. It restricts the volume of electric current flowing through the wire, keeping it at a safe, controlled trickle.\n\n### Why LEDs Need Current Protection\n- A Light Emitting Diode (LED) is a specialized semiconductor crystal. Once it turns ON, it has almost zero internal electrical resistance.\n- If you connect an LED straight across 5V and GND without a resistor, immense current surges through the tiny crystal. The LED will flash blindingly for a split second, turn brown, smell like burnt plastic, and die forever!\n- Drawing too much current (> 20–40 mA) can also permanently damage the Arduino microcontroller pin driver.\n\n### Meet the 220Ω Resistor\n- Locate a small striped cylinder with two bendable metal legs in your kit.\n- Look at its color stripes: **Red – Red – Brown – Gold** = **220 Ohms (220Ω)**.\n- A 220Ω resistor limits the current from a 5V supply to approximately **15 to 20 milliamps (mA)**—plenty bright for your eyes and 100% safe for both LED and Arduino!\n\n### Fun Fact: Zero Polarity!\nResistors are completely symmetrical. It does not matter which way you plug them into the breadboard—electricity flows through them identically in both directions!",
        "quickCheck": [
          {
            "questionId": "q_l06_s04_01",
            "question": "Why must you always place a protective resistor in series with an LED connected to an Arduino?",
            "options": [
              "To increase the battery voltage up to 100 Volts",
              "To make the LED shine ultraviolet light",
              "To limit electrical current so neither the LED nor Arduino pin burns out",
              "Because LEDs cannot produce light without high resistance"
            ],
            "correctIndex": 2,
            "explanation": "An LED has very low internal resistance. A resistor restricts current to a safe level (~15-20 mA) so neither the LED nor pin is damaged.",
            "warmupExplanation": "A resistor is an electronic shield: it restricts current so fragile components like LEDs don't overheat and pop."
          },
          {
            "questionId": "q_l06_s04_02",
            "question": "Does a resistor have positive and negative polarity (does it matter which direction it faces)?",
            "options": [
              "No, resistors work identically in either direction and have no positive or negative leads",
              "Yes, the gold band must always point toward the Arduino reset button",
              "Yes, backwards resistors block all electricity permanently",
              "Yes, reversing a resistor reverses the direction of current"
            ],
            "correctIndex": 0,
            "explanation": "Resistors are non-polar components; current flows through them in either direction with the same resistance.",
            "warmupExplanation": "Unlike LEDs which only let current flow one way, resistors are symmetrical. Either leg can connect to power or ground."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_05",
    "title": "First Breadboard Circuit",
    "summary": "Before wiring sensors and monster alarms, every professional robotics engineer sets up their Power Bus Highways!",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l06_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s05",
        "title": "First Breadboard Circuit",
        "type": "physicalTask",
        "markdownContent": "# First Breadboard Circuit: Power Distribution\n\nBefore wiring sensors and monster alarms, every professional robotics engineer sets up their **Power Bus Highways**!\n\n### The Mission Checklist:\n1. **Unplug USB**: Ensure your Arduino Uno (`comp_uno`) is disconnected from your computer.\n2. **Run +5V Power Wire**:\n   - Take a **Red jumper wire**.\n   - Plug one end into the Arduino **5V** pin socket.\n   - Plug the other end into the **Red `+` power rail** on the breadboard.\n3. **Run Ground Return Wire**:\n   - Take a **Black (or Blue) jumper wire**.\n   - Plug one end into any **GND** pin socket on the Arduino.\n   - Plug the other end into the **Blue/Black `-` power rail** on the breadboard.\n4. **Inspect Connections**: You now have regulated +5V and 0V Ground running along the entire edge of your breadboard, ready for any component!\n\n### Maker Wiring Conventions:\n- **Red**: Positive supply (+5V or +3.3V).\n- **Black or Blue**: 0V Ground (GND).\n- **Yellow, Green, White**: Signal and data lines.\n\nFollowing color conventions prevents costly wiring errors as your robot builds grow in complexity!",
        "quickCheck": [
          {
            "questionId": "q_l06_s05_01",
            "question": "Which Arduino Uno pin should you connect to the red `+` power rail of your breadboard?",
            "options": [
              "The RESET pin header",
              "The regulated 5V power pin",
              "Analog input pin A0",
              "The AREF pin header"
            ],
            "correctIndex": 1,
            "explanation": "The Arduino 5V pin provides steady +5V DC power, which is connected to the breadboard's red `+` rail.",
            "warmupExplanation": "The red `+` rail on a breadboard is reserved for the positive power supply (+5V from your Arduino)."
          },
          {
            "questionId": "q_l06_s05_02",
            "question": "By standard maker convention, which wire color should you connect to GND (Ground)?",
            "options": [
              "Bright yellow",
              "Neon orange",
              "Black (or dark blue)",
              "Glitter red"
            ],
            "correctIndex": 2,
            "explanation": "Black (or blue) is universally used for Ground (0V reference), while red is reserved for positive power (+5V).",
            "warmupExplanation": "Consistent color coding keeps circuits safe: Red for positive power (+5V) and Black/Blue for Ground (GND)."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_06",
    "title": "LED + Resistor",
    "summary": "Let's construct your very first physical light circuit on the breadboard!",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l06_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s06",
        "title": "LED + Resistor",
        "type": "physicalTask",
        "markdownContent": "# LED + Resistor: The Foundational Circuit\n\nLet's construct your very first physical light circuit on the breadboard!\n\n### Know Your 5mm LED:\n- **Anode (+)**: The **longer leg**. Needs positive voltage (+5V).\n- **Cathode (-)**: The **shorter leg** (and the flat bevel on the rim). Needs Ground (0V).\n\n### Step-by-Step Build Instructions:\n1. Unplug USB power from your Arduino.\n2. **Place the Resistor (220Ω)**:\n   - Bend the leads into a gentle 'U' shape.\n   - Plug one leg into the **`+` (red) power rail**.\n   - Plug the second leg into **Row 15, column a**.\n3. **Place the LED**:\n   - Plug the **Long leg (Anode +)** into **Row 15, column b** (sharing Row 15 with the resistor!).\n   - Plug the **Short leg (Cathode -)** into **Row 16, column b**.\n4. **Place the Ground Wire**:\n   - Take a jumper wire. Plug one end into **Row 16, column c** (sharing Row 16 with the short leg!).\n   - Plug the other end into the **`-` (blue) Ground rail**.\n5. **Plug in USB and Behold!**\n   - Connect your USB cable. The LED glows brightly!\n\n### Trace the Complete Electrical Journey:\n```\n5V Rail ➔ 220Ω Resistor ➔ Row 15 ➔ LED Anode (+) ➔ Semiconductor ➔ LED Cathode (-) ➔ Row 16 ➔ Jumper ➔ GND Rail\n```\n\n### Systematic Troubleshooting:\n- *LED not glowing?* Unplug USB. Check if the LED is backwards (short leg must face Row 16 / GND). Check that the resistor and LED long leg are truly sharing Row 15!",
        "quickCheck": [
          {
            "questionId": "q_l06_s06_01",
            "question": "Which lead of a standard 5mm LED should connect toward the positive (+5V) side of the circuit?",
            "options": [
              "The longer lead (the Anode)",
              "The shorter lead (the Cathode)",
              "Either lead because LEDs are completely reversible",
              "The plastic rim on the flat side"
            ],
            "correctIndex": 0,
            "explanation": "The longer lead of an LED is the Anode (+), which must connect toward positive voltage so forward current can flow.",
            "warmupExplanation": "Remember: Long leg = Anode (+) connected toward power; Short leg = Cathode (-) connected toward Ground."
          },
          {
            "questionId": "q_l06_s06_02",
            "question": "If the resistor is plugged into Row 15 column 'a' and the LED long leg is in Row 16 column 'a', why won't the LED light up?",
            "options": [
              "The breadboard will overheat and shut down",
              "Row 15 and Row 16 are separate electrical rows, leaving the circuit open with no connection between them",
              "The resistor will turn into a battery",
              "The LED burns out instantly from too much voltage"
            ],
            "correctIndex": 1,
            "explanation": "Different numbered rows are electrically isolated; components only connect when sharing the same numbered row.",
            "warmupExplanation": "To connect two parts on a breadboard, their pins must plug into the same numbered row (e.g., both into row 15)."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_07",
    "title": "Blink on a Real Circuit",
    "summary": "In Step 6, your LED was tied directly to the constant 5V power rail, so it stayed on continuously.",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l06_06"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s07",
        "title": "Blink on a Real Circuit",
        "type": "codeExperiment",
        "markdownContent": "# Blink on a Real Circuit\n\nIn Step 6, your LED was tied directly to the constant 5V power rail, so it stayed on continuously. Now, let's put the Arduino microcontroller in command!\n\n### Hardware Transition:\n1. Unplug the USB cable.\n2. Gently unplug the resistor leg from the `+` rail.\n3. Move that resistor leg into **Row 10, column a**.\n4. Take a jumper wire: connect Arduino **Digital Pin 9** to **Row 10, column b**.\n5. Leave the LED short leg connected through Row 16 to Ground.\n\nNow, Digital Pin 9 controls whether 5V is supplied to the circuit!\n\n### Upload the External Blink Sketch:\n```cpp\nconst int ledPin = 9; // External circuit wired to Digital Pin 9\n\nvoid setup() {\n  pinMode(ledPin, OUTPUT); // Configure Pin 9 as an active driver\n}\n\nvoid loop() {\n  digitalWrite(ledPin, HIGH); // Supply +5V: Circuit closes, LED lights up!\n  delay(1000);                // Wait 1000 ms (1 second)\n  digitalWrite(ledPin, LOW);  // Drive to 0V: Circuit off, LED dark!\n  delay(1000);                // Wait 1000 ms (1 second)\n}\n```\n\n### The Hardware-Software Bridge:\n- When code calls `digitalWrite(9, HIGH)`, an internal transistor inside the ATmega328P connects Pin 9 to the internal 5V supply, sourcing electric current.\n- When code calls `digitalWrite(9, LOW)`, the transistor connects Pin 9 to Ground (0V), collapsing the voltage across the LED so current ceases.",
        "quickCheck": [
          {
            "questionId": "q_l06_s07_01",
            "question": "What voltage appears on Digital Pin 9 when code executes `digitalWrite(9, HIGH)` on an Arduino Uno?",
            "options": [
              "0.0 Volts (Ground)",
              "-12.0 Volts AC",
              "+5.0 Volts DC",
              "120 Volts house current"
            ],
            "correctIndex": 2,
            "explanation": "Calling `digitalWrite(pin, HIGH)` drives the digital pin to +5V DC, sourcing current to the external circuit.",
            "warmupExplanation": "In Arduino digital logic, HIGH means +5V (active power) and LOW means 0V (Ground)."
          },
          {
            "questionId": "q_l06_s07_02",
            "question": "If you want an LED on Pin 9 to blink rapidly twice every second, what delay duration should you use?",
            "options": [
              "delay(250); for 250 milliseconds ON and 250 milliseconds OFF",
              "delay(5000); for 5 seconds",
              "delay(0); with no waiting",
              "delay(60000); for 1 minute"
            ],
            "correctIndex": 0,
            "explanation": "250 ms ON + 250 ms OFF = 500 ms per cycle, resulting in 2 complete blinks every second (1000 ms).",
            "warmupExplanation": "One second is 1000 milliseconds. 250 ms ON plus 250 ms OFF creates two swift blink pulses per second."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_08",
    "title": "Digital Output Experiment",
    "summary": "Engineers master hardware through a disciplined learning loop:",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l06_07"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s08",
        "title": "Digital Output Experiment",
        "type": "physicalTask",
        "markdownContent": "# Digital Output Experiment: Change One Thing!\n\nEngineers master hardware through a disciplined learning loop:\n**Wire ➔ Observe ➔ Change One Thing ➔ Predict ➔ Run ➔ Explain**\n\n### The Build: Dual Monster Warning Lights\nLet's add a second independent output channel to your breadboard!\n1. Unplug USB.\n2. Grab a second LED (Green or Yellow) and a second 220Ω resistor.\n3. Connect second resistor from **Row 20, column a** to **Row 25, column a**.\n4. Connect Arduino **Digital Pin 8** to **Row 20, column b**.\n5. Insert the second LED: Long leg (Anode +) into **Row 25, column b**, and Short leg (Cathode -) into **Row 26, column b**.\n6. Connect **Row 26, column c** with a jumper wire back to the shared **`-` Ground rail**.\n\n### Upload the Alternating Strobe Sketch:\n```cpp\nconst int redLed = 9;\nconst int greenLed = 8;\n\nvoid setup() {\n  pinMode(redLed, OUTPUT);\n  pinMode(greenLed, OUTPUT);\n}\n\nvoid loop() {\n  // Red ON, Green OFF\n  digitalWrite(redLed, HIGH);\n  digitalWrite(greenLed, LOW);\n  delay(300);\n\n  // Red OFF, Green ON\n  digitalWrite(redLed, LOW);\n  digitalWrite(greenLed, HIGH);\n  delay(300);\n}\n```\n\n### The 'Change One Thing' Challenge:\n- **Predict**: What happens if you unplug the Ground jumper wire from Row 26 while the code runs?\n- **Observe**: The green LED stops completely, while the red LED continues blinking happily! Both circuits share the ground highway, but each circuit loop must be independently complete.",
        "quickCheck": [
          {
            "questionId": "q_l06_s08_01",
            "question": "Can two different LEDs connected to Pin 8 and Pin 9 share the same Ground (GND) power rail on your breadboard?",
            "options": [
              "No, each LED requires its own separate battery pack",
              "Yes, multiple components can share a common Ground return path",
              "No, sharing Ground causes an instant short circuit",
              "Yes, but only if they are the exact same color"
            ],
            "correctIndex": 1,
            "explanation": "A common Ground rail provides a shared 0V return path for any number of components in a circuit.",
            "warmupExplanation": "GND is the shared return highway: all components can safely return their current to the same GND rail."
          },
          {
            "questionId": "q_l06_s08_02",
            "question": "In the 'Change One Thing' scientific method, why do we change only one wire or code variable at a time?",
            "options": [
              "Because Arduino only allows one edit per week",
              "To conserve electricity from our computer USB port",
              "So we know exactly which change caused the new behavior or solved the bug",
              "Because changing two things deletes all files on the board"
            ],
            "correctIndex": 2,
            "explanation": "Changing one variable at a time isolates causes and effects, making engineering debugging systematic and reliable.",
            "warmupExplanation": "Engineers change one thing at a time so they know exactly what created the fix or triggered the error."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_09",
    "title": "Distance Sensor Experiment",
    "summary": "Meet Component comp01: The HC-SR04 Ultrasonic Distance Sensor!",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l06_08"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s09",
        "title": "Distance Sensor Experiment",
        "type": "physicalTask",
        "markdownContent": "# Distance Sensor Experiment: Echolocation in Code\n\nMeet Component `comp_01`: The **HC-SR04 Ultrasonic Distance Sensor**! This sensor gives your robot creature the sense of spatial awareness.\n\n### How Bats and Robots See with Sound:\nThe sensor features two metal cylinders that look like robot eyes:\n- **Transmitter (Trig)**: Emits a sharp ultrasonic burst at **40,000 Hz** (40 kHz)—far too high for human ears to detect.\n- **Receiver (Echo)**: Listens for the reflected sound echo bouncing off nearby surfaces.\n- Because the speed of sound through room air is roughly **340 meters/second (0.034 cm/microsecond)**, the Arduino measures time ($t$) and calculates distance:\n\n$$\\text{Distance (cm)} = \\frac{\\text{Echo Time (microseconds)} \\times 0.034}{2}$$\n\n### Wiring the 4-Pin Sensor:\n1. Unplug USB.\n2. Gently press the HC-SR04 pins into 4 adjacent breadboard rows (e.g. Rows 1, 2, 3, 4 across the center):\n   - **VCC Pin** ➔ Red `+` Power Rail (+5V)\n   - **Trig Pin** ➔ Arduino **Digital Pin 12**\n   - **Echo Pin** ➔ Arduino **Digital Pin 11**\n   - **GND Pin** ➔ Blue `-` Ground Rail (GND)\n\n### The Distance Telemetry Sketch:\n```cpp\nconst int trigPin = 12;\nconst int echoPin = 11;\n\nvoid setup() {\n  Serial.begin(9600); // 9600 baud communication\n  pinMode(trigPin, OUTPUT);\n  pinMode(echoPin, INPUT);\n}\n\nvoid loop() {\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10); // 10-microsecond trigger pulse\n  digitalWrite(trigPin, LOW);\n\n  long duration = pulseIn(echoPin, HIGH); // Measure echo pulse length\n  int distanceCm = duration * 0.034 / 2;  // Convert echo time to cm\n\n  Serial.print(\"Measured Distance: \");\n  Serial.print(distanceCm);\n  Serial.println(\" cm\");\n\n  delay(200); // Sample 5 times per second\n}\n```\n\n### Hands-On Observation:\nOpen the **Serial Monitor** at 9600 baud. Move your palm toward and away from the sensor cylinders. Watch the distance readings update live! A physical sensor converts physical reality into digital numbers in memory!",
        "quickCheck": [
          {
            "questionId": "q_l06_s09_01",
            "question": "How does the HC-SR04 ultrasonic distance sensor measure how far away an obstacle is?",
            "options": [
              "It times how long a high-frequency sound wave takes to bounce off an object and return",
              "It uses an infrared laser beam to heat up the target object",
              "It weighs the air pressure pushing against its front cylinders",
              "It takes high-resolution color photographs with dual cameras"
            ],
            "correctIndex": 0,
            "explanation": "The sensor uses echolocation: it sends an ultrasonic sound pulse and measures the time until the echo bounces back.",
            "warmupExplanation": "Like a bat navigating at night, the ultrasonic sensor bounces sound waves off obstacles to calculate distance."
          },
          {
            "questionId": "q_l06_s09_02",
            "question": "Which pin on the ultrasonic sensor receives the returning sound echo signal and sends it to the Arduino?",
            "options": [
              "The VCC power pin",
              "The Echo pin",
              "The Ground (GND) pin",
              "The Trig (Trigger) pin"
            ],
            "correctIndex": 1,
            "explanation": "The Trig pin sends the sound pulse out, while the Echo pin listens for the reflected sound and pulses HIGH when it arrives.",
            "warmupExplanation": "Trig triggers the sound pulse out; Echo listens for the reflected sound wave coming back."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_10",
    "title": "Sensor + Output Mini Project",
    "summary": "Now we unite everything you have mastered into a full Cyber-Physical System:",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 10,
    "isOptional": false,
    "prerequisites": [
      "l06_09"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s10",
        "title": "Sensor + Output Mini Project",
        "type": "physicalTask",
        "markdownContent": "# Sensor + Output Mini Project: Monster Proximity Sentry\n\nNow we unite everything you have mastered into a full Cyber-Physical System:\n**Sensory Input ➔ Microcontroller Decision Logic ➔ Physical Output Action**!\n\n### The Robotic Mission\nYour monster sentry will guard your desk. When an intruder's hand gets closer than **20 centimeters**, the sentry sounds an alarm by flashing the Pin 9 LED rapidly! When clear, the sentry stays peaceful.\n\n### System Circuit Checklist:\n1. **Breadboard Power Rails**: 5V to red rail, GND to blue rail.\n2. **Ultrasonic Sensor**: VCC to 5V rail, GND to GND rail, Trig to Pin 12, Echo to Pin 11.\n3. **Warning LED Circuit**: Digital Pin 9 ➔ 220Ω resistor ➔ LED Anode (+) ➔ LED Cathode (-) ➔ GND rail.\n\n### Upload the Sentry Firmware:\n```cpp\nconst int trigPin = 12;\nconst int echoPin = 11;\nconst int alertLed = 9;\n\nvoid setup() {\n  Serial.begin(9600);\n  pinMode(trigPin, OUTPUT);\n  pinMode(echoPin, INPUT);\n  pinMode(alertLed, OUTPUT);\n}\n\nvoid loop() {\n  // 1. Emit ultrasonic trigger\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(trigPin, LOW);\n\n  // 2. Measure echo and compute distance\n  long duration = pulseIn(echoPin, HIGH);\n  int distance = duration * 0.034 / 2;\n\n  Serial.print(\"Distance: \");\n  Serial.print(distance);\n  Serial.println(\" cm\");\n\n  // 3. Autonomous Decision Pipeline\n  if (distance > 0 && distance < 20) {\n    // Intruder in security zone! Rapid strobe alarm!\n    digitalWrite(alertLed, HIGH);\n    delay(100);\n    digitalWrite(alertLed, LOW);\n    delay(100);\n  } else {\n    // Perimeter secure: quiet mode\n    digitalWrite(alertLed, LOW);\n    delay(250);\n  }\n}\n```\n\n### Test the System:\nWave your hand in front of the sensor. When you cross inside 20 cm, the alarm fires! You have built a complete, intelligent automated robotic sentry!",
        "quickCheck": [
          {
            "questionId": "q_l06_s10_01",
            "question": "In our Monster Sentry project, what role does the ultrasonic sensor play in the Input → Decision → Output pipeline?",
            "options": [
              "It acts as the visual Output displaying the warning signal",
              "It computes the mathematical code logic in its own microprocessor",
              "It supplies high-voltage power to the breadboard",
              "It provides the sensory Input data (distance measurement) to the Arduino"
            ],
            "correctIndex": 3,
            "explanation": "The ultrasonic sensor is the Input device that gathers real-world distance data and delivers it to the Arduino.",
            "warmupExplanation": "In robotics: Sensors are Inputs (the senses), code makes Decisions, and LEDs/motors are Outputs (the actions)."
          },
          {
            "questionId": "q_l06_s10_02",
            "question": "If the alert LED never turns on even when your hand is 5 cm away, what is the best systematic troubleshooting step?",
            "options": [
              "Open the Serial Monitor to check if distance values are being read, then inspect the LED wiring and resistor",
              "Immediately replace your computer with a new one",
              "Change every wire and all code lines simultaneously",
              "Connect the LED directly to 120V wall power"
            ],
            "correctIndex": 0,
            "explanation": "Checking Serial Monitor telemetry first isolates whether the problem is in the sensor input/code or the LED output circuit.",
            "warmupExplanation": "Use telemetry first: Serial Monitor reveals whether the sensor is reading correctly before you debug the output circuit."
          }
        ]
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l06_11",
    "title": "Build Challenge",
    "summary": "You can now route power rails, calculate safe current with series resistors, wire polarized semiconductor LEDs, interface ultrasonic distance senso...",
    "tier": "builder",
    "estimatedMinutes": 5,
    "courseId": "lesson_06",
    "sortOrder": 11,
    "isOptional": false,
    "prerequisites": [
      "l06_10"
    ],
    "componentIds": [
      "comp_uno",
      "comp_breadboard",
      "comp_01"
    ],
    "steps": [
      {
        "stepId": "l06_s11",
        "title": "Build Challenge",
        "type": "quizCheckpoint",
        "markdownContent": "# Lesson 6 Build Challenge\n\nCongratulations on completing your breadboard and physical circuits apprenticeship! You can now route power rails, calculate safe current with series resistors, wire polarized semiconductor LEDs, interface ultrasonic distance sensors, and diagnose circuit issues systematically.\n\nTake the final challenge assessment below to verify your circuit mastery and claim your **50 XP** reward!",
        "interactiveConfig": {
          "question": "What is the primary function of a 220Ω resistor in series with an LED connected to an Arduino pin?",
          "options": [
            "To limit electrical current and prevent the LED and Arduino pin from burning out",
            "To increase battery voltage up to 120 Volts",
            "To store compiled C++ firmware code in flash memory",
            "To convert DC voltage into AC radio waves"
          ],
          "correctIndex": 0,
          "explanation": "The resistor restricts electrical current to a safe 15-20 mA level, shielding the fragile LED diode crystal and Arduino output driver from overcurrent destruction.",
          "questions": [
            {
              "question": "What is the primary function of a 220Ω resistor in series with an LED connected to an Arduino pin?",
              "options": [
                "To limit electrical current and prevent the LED and Arduino pin from burning out",
                "To increase battery voltage up to 120 Volts",
                "To store compiled C++ firmware code in flash memory",
                "To convert DC voltage into AC radio waves"
              ],
              "correctIndex": 0,
              "explanation": "The resistor restricts electrical current to a safe 15-20 mA level, shielding the fragile LED diode crystal and Arduino output driver from overcurrent destruction."
            },
            {
              "question": "How are tie-point holes arranged internally on the main terminal strips of a solderless breadboard?",
              "options": [
                "In horizontal rows of 5 connected holes (a–e and f–j) separated by a center ravine",
                "In single diagonal lines running across the entire board",
                "Every hole on the entire board is connected to every other hole",
                "Only the outer corners have metal connections"
              ],
              "correctIndex": 0,
              "explanation": "On a solderless breadboard, each numbered row has two isolated groups of 5 tie-points (a-e and f-j) joined by internal bronze spring clips."
            },
            {
              "question": "Which terminal of a standard 5mm LED is the positive Anode (+)?",
              "options": [
                "The longer lead",
                "The shorter lead",
                "The lead next to the flat rim notch",
                "Both leads are completely identical"
              ],
              "correctIndex": 0,
              "explanation": "The longer lead indicates the Anode (+), which connects toward positive supply voltage, while the shorter lead is the Cathode (-)."
            },
            {
              "question": "How does the HC-SR04 ultrasonic distance sensor calculate distance to an obstacle?",
              "options": [
                "It emits a 40 kHz sound pulse from Trig, measures the echo return time on Echo, and multiplies by the speed of sound",
                "It uses a mechanical measuring tape inside the metal cylinders",
                "It calculates the weight of atmospheric air pushing against the board",
                "It detects heat radiated from the target using an infrared thermal lens"
              ],
              "correctIndex": 0,
              "explanation": "The ultrasonic sensor measures the round-trip travel time of an emitted 40 kHz sound ping and applies the speed of sound formula."
            },
            {
              "question": "What should an engineer do first when a physical circuit does not respond as expected?",
              "options": [
                "Unplug power, inspect serial telemetry, and change one wire or parameter at a time",
                "Tear out all wires and buy a completely new computer",
                "Increase the power supply voltage to 50 Volts",
                "Shake the breadboard vigorously while connected to USB"
              ],
              "correctIndex": 0,
              "explanation": "Systematic debugging relies on safely removing power, observing diagnostic telemetry, and modifying only one variable at a time."
            }
          ]
        },
        "quickCheck": [
          {
            "questionId": "q_l06_s11_01",
            "question": "What is the primary danger of connecting an LED directly between 5V and GND without a protective resistor?",
            "options": [
              "The LED will permanently change color to infrared",
              "Excessive current will burn out the LED crystal and can damage the Arduino pin driver",
              "The breadboard will become permanently magnetized",
              "The Arduino will upload random code automatically"
            ],
            "correctIndex": 1,
            "explanation": "Without a current-limiting resistor, excessive current flows through the LED, causing thermal destruction.",
            "warmupExplanation": "Remember: Resistors limit current. Without one, the LED and microcontroller pin face catastrophic overcurrent."
          },
          {
            "questionId": "q_l06_s11_02",
            "question": "If an ultrasonic sensor's Echo pin is accidentally plugged into Pin 4 instead of Pin 11 as configured in code, what will happen?",
            "options": [
              "The sensor will transmit sound waves at double the speed",
              "The computer will shut down with an overcurrent alert",
              "The code on Pin 11 will never detect an echo pulse and distance readings will fail",
              "Pin 4 will automatically rewrite the sketch firmware"
            ],
            "correctIndex": 2,
            "explanation": "The microcontroller only listens on the pin configured in code (echoPin = 11); wiring to the wrong pin results in no pulse detected.",
            "warmupExplanation": "Hardware pins must match software definitions. If your wire is in Pin 4 but code reads Pin 11, the signal is missed."
          }
        ]
      }
    ],
    "xpReward": 15
  },
  {
    "id": "l07_01",
    "title": "What Is a Sensor?",
    "summary": "Just like humans and friendly lab monsters use eyes to see, ears to hear, and skin to feel warmth, your Arduino needs electronic senses to understa...",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l06_11"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s01",
        "title": "What Is a Sensor?",
        "type": "story",
        "markdownContent": "Welcome to the sensory world of robotics! Just like humans and friendly lab monsters use eyes to see, ears to hear, and skin to feel warmth, your Arduino needs electronic senses to understand what is happening around it.\n\nWithout sensors, a microcontroller is completely blind and deaf—it can only run pre-programmed timers over and over. A **sensor** is an electronic component that detects a physical condition in the real world (such as light brightness, acoustic sound waves, warmth, proximity, or motion) and transforms it into an electrical signal that your Arduino can measure.\n\n### The Robot Perception Loop:\n```\nReal-World Event (Hand getting close) ➔ Sensor (Echolocation ping) ➔ Electrical Signal (Voltage / Pulse) ➔ Arduino Brain (Decision Logic) ➔ Output Action (Alarm LED glows!)\n```\n\nIn this mission, you will unlock the superpower of robotic perception using both digital and analog sensors, learn how to calibrate smart decision thresholds, and connect real-world data directly to monster actions!",
        "quickCheck": [
          {
            "questionId": "l07_s01_q1",
            "question": "What is the primary role of a sensor in an electronics system?",
            "options": [
              "It measures physical events in the real world and turns them into electrical signals",
              "It provides battery power to the entire circuit",
              "It spins motors to move a robot across the room"
            ],
            "correctIndex": 0,
            "explanation": "Sensors detect physical conditions like light, sound, or distance and convert them into electrical data that the Arduino can read.",
            "warmupExplanation": "Think of your own senses: your eyes detect light and your ears detect sound. Electronic sensors do the exact same thing for robots!"
          },
          {
            "questionId": "l07_s01_q2",
            "question": "Which of the following is an example of an electronic sensor detecting the environment?",
            "options": [
              "A photoresistor detecting that the room lights were turned off",
              "An LED emitting red light to signal an alert",
              "A speaker playing a warning alarm beep"
            ],
            "correctIndex": 0,
            "explanation": "A photoresistor detects changes in ambient light levels, making it an input sensor. LEDs and speakers are output devices.",
            "warmupExplanation": "Sensors are inputs that listen to the world, while lights, speakers, and motors are outputs that take action."
          }
        ]
      },
      {
        "stepId": "l07_01_s02",
        "title": "The Sensory Perception Pipeline",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### How Robots Perceive Reality\n\nIn electronics, sensors act as **transducers**—devices that convert one form of energy into electrical energy.\n\n```\n+--------------------------------------------------------------------------+\n|                       ROBOT PERCEPTION PIPELINE                          |\n|                                                                          |\n|  [Physical World]      Photons, Sound Waves, Temperature, Proximity      |\n|         │                                                                |\n|         ▼                                                                |\n|  [Transducer Element]  Material reacts (resistance shifts, piezo charges)|\n|         │                                                                |\n|         ▼                                                                |\n|  [Conditioning Circuit]Voltage divider or amplifier converts to 0V–5V    |\n|         │                                                                |\n|         ▼                                                                |\n|  [Arduino Input Pin]   Digital GPIO (HIGH/LOW) or Analog ADC (0–1023)    |\n|         │                                                                |\n|         ▼                                                                |\n|  [Microcontroller CPU] Firmware evaluates conditional thresholds         |\n|         │                                                                |\n|         ▼                                                                |\n|  [Actuator Action]     LED illuminates, buzzer chimes, motor spins       |\n+--------------------------------------------------------------------------+\n```\n\nEvery sensory decision follows this strict chain. If any link is broken—whether a loose ground wire or a software logic error—perception fails!"
      },
      {
        "stepId": "l07_01_s03",
        "title": "Filtering Real-World Noise",
        "type": "physicalTask",
        "interactiveWidgetType": "analogReadNoiseFilter",
        "markdownContent": "### The Noisy Physical World\n\nReal environments are filled with invisible electromagnetic interference (EMI)—such as 60Hz hum radiating from room power cords and radio waves.\n\nWhen a sensor wire is unplugged or left **floating**, it acts like an antenna, picking up wild electrical noise that jumps between random values!\n\n```cpp\n// Typical EMA (Exponential Moving Average) filter formula\nsmoothedValue = (alpha * rawReading) + ((1.0 - alpha) * smoothedValue);\n```\n\n**Laboratory Task:**\n1. Inspect the interactive noise filter simulator below.\n2. Observe how a **floating pin** fluctuates erratically due to environmental EMI.\n3. Compare it to a **grounded reference** (solid 0 counts) and a **smoothed filter** that tames raw jitter into smooth, actionable telemetry!"
      },
      {
        "stepId": "l07_01_s04",
        "title": "Perception Knowledge Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of robotic perception and electronic transducers before proceeding to digital sensors!",
        "interactiveConfig": {
          "question": "What is the primary role of a transducer inside a robotic sensor?",
          "options": [
            "It converts real-world physical conditions into measurable electrical signals",
            "It stores compiled C++ sketches in microcontroller flash memory",
            "It steps up USB battery voltage to power heavy high-voltage motors"
          ],
          "correctIndex": 0,
          "explanation": "Transducers convert physical phenomena like light, sound, pressure, or heat into electrical signals (voltage, current, or resistance) that microcontrollers can measure.",
          "questions": [
            {
              "question": "What is the primary role of a transducer inside a robotic sensor?",
              "options": [
                "It converts real-world physical conditions into measurable electrical signals",
                "It stores compiled C++ sketches in microcontroller flash memory",
                "It steps up USB battery voltage to power heavy high-voltage motors"
              ],
              "correctIndex": 0,
              "explanation": "Transducers convert physical phenomena like light, sound, pressure, or heat into electrical signals (voltage, current, or resistance) that microcontrollers can measure."
            },
            {
              "question": "Why does an unconnected (floating) analog input pin produce jumpy, erratic numbers in an Arduino sketch?",
              "options": [
                "Its high electrical impedance causes the pin wire to act like an antenna picking up electromagnetic noise",
                "The ATmega328P microcontroller chip has suffered permanent internal damage",
                "The compiler generated machine opcodes in reverse order"
              ],
              "correctIndex": 0,
              "explanation": "Because high-impedance CMOS inputs draw virtually no current, a disconnected pin picks up stray electromagnetic fields (such as 60Hz mains hum) from surrounding air like an antenna."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_02",
    "title": "Digital Sensors",
    "summary": "Electronic sensors generally fall into two major families: Digital and Analog.",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l07_01"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s02",
        "title": "Digital Sensors",
        "type": "visualExplanation",
        "markdownContent": "Electronic sensors generally fall into two major families: **Digital** and **Analog**.\n\n### Binary Perception:\nA **digital sensor** communicates in discrete binary states. It only ever reports one of two possible values:\n- **HIGH (1)**: 5 Volts (Active / Triggered / Closed)\n- **LOW (0)**: 0 Volts (Idle / Untriggered / Open)\n\nThink of a standard light switch on your wall: it is either completely switched ON or completely switched OFF—there are no middle values!\n\n### Common Digital Sensors:\n- **Pushbuttons & Bumper Switches (`comp_04`)**: Pressed (`HIGH`) or Released (`LOW`).\n- **Tilt Ball Switches (`comp_28`)**: Upright (`HIGH`) or Tilted (`LOW`).\n- **PIR Motion Detectors (`comp_03`)**: Warm body moving (`HIGH`) or Quiet room (`LOW`).\n\nIn your Arduino firmware, you read digital sensors with `digitalRead(pin)`. When you only need a simple Yes-or-No answer—such as *'Did the monster bump into a wall?'*—a digital sensor is lightning-fast, highly reliable, and easy to program!",
        "quickCheck": [
          {
            "questionId": "l07_s02_q1",
            "question": "How many discrete electrical states does a standard digital sensor output?",
            "options": [
              "Exactly two states: HIGH (5V) or LOW (0V)",
              "An infinite number of smooth voltage levels",
              "1024 different numbers between 0 and 1023"
            ],
            "correctIndex": 0,
            "explanation": "Digital signals only exist in two binary states: HIGH (5V / 1) or LOW (0V / 0).",
            "warmupExplanation": "Digital means binary—like a light switch that is either completely on or completely off with no dimming in between."
          },
          {
            "questionId": "l07_s02_q2",
            "question": "Which Arduino function is used to check the binary state of a digital sensor pin?",
            "options": [
              "digitalRead()",
              "analogRead()",
              "digitalWrite()"
            ],
            "correctIndex": 0,
            "explanation": "digitalRead(pin) reads a digital pin and returns either HIGH or LOW.",
            "warmupExplanation": "Remember: 'Read' gets information into the Arduino, while 'Write' sends electricity out to an actuator."
          }
        ]
      },
      {
        "stepId": "l07_02_s02",
        "title": "Binary States and Digital Logic",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Digital Senses: Two States Only\n\nDigital sensors communicate in crisp, unambiguous binary signals:\n\n```\n+5V ───────── [ HIGH / 1 / TRUE ]  ── Threshold (approx > 3.0V on 5V Uno)\n             ▲\n             │ Transition Region (Avoid leaving pins here!)\n             ▼\n 0V ───────── [ LOW  / 0 / FALSE ] ── Threshold (approx < 1.5V on 5V Uno)\n```\n\nCommon digital sensors in your lab:\n- **PIR Motion Sensor (`comp_03`)**: Jumps HIGH (+5V) when infrared body warmth shifts; drops LOW (0V) when still.\n- **Impact Collision Switch (`comp_04`)**: Mechanical lever closes contacts to Ground or +5V when bumped.\n- **Photo Interrupter (`comp_05`)**: Infrared beam breaks when an encoder wheel tooth passes through.\n\nBecause digital inputs only distinguish between 0 and 1, they are immune to minor electrical noise!"
      },
      {
        "stepId": "l07_02_s03",
        "title": "Diagnosing Digital Sensor Logic",
        "type": "codeExperiment",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Hands-On: Reading Digital Inputs\n\nTo read a digital sensor, configure the pin using `pinMode()` and read its state in `loop()`:\n\n```cpp\nconst int sensorPin = 2;\n\nvoid setup() {\n  pinMode(sensorPin, INPUT_PULLUP); // Activates internal 20kΩ pull-up resistor\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int sensorState = digitalRead(sensorPin);\n  if (sensorState == LOW) {\n    Serial.println(\"ALERT: Sensor Triggered (Connected to Ground)!\");\n  }\n  delay(100);\n}\n```\n\n**Troubleshooting Lab:**\nPractice diagnosing digital input misconfigurations—such as missing pull-up resistors or loose ground connections—in the interactive troubleshooting workbench below!"
      },
      {
        "stepId": "l07_02_s04",
        "title": "Digital Sensor Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of digital sensor signals and pin configurations.",
        "interactiveConfig": {
          "question": "Which Arduino C++ function reads the binary state of a digital sensor pin?",
          "options": [
            "digitalRead(pin)",
            "analogRead(pin)",
            "analogWrite(pin, 255)"
          ],
          "correctIndex": 0,
          "explanation": "digitalRead(pin) returns either HIGH (1) or LOW (0) depending on whether the pin voltage is near 5V or near Ground.",
          "questions": [
            {
              "question": "Which Arduino C++ function reads the binary state of a digital sensor pin?",
              "options": [
                "digitalRead(pin)",
                "analogRead(pin)",
                "analogWrite(pin, 255)"
              ],
              "correctIndex": 0,
              "explanation": "digitalRead(pin) returns either HIGH (1) or LOW (0) depending on whether the pin voltage is near 5V or near Ground."
            },
            {
              "question": "In an active-low sensor circuit configured with pinMode(pin, INPUT_PULLUP), what value does digitalRead() return when the switch contacts close to GND?",
              "options": [
                "LOW (0)",
                "HIGH (1)",
                "512 counts"
              ],
              "correctIndex": 0,
              "explanation": "With INPUT_PULLUP, the pin is pulled HIGH by default. When the switch closes to Ground, it pulls the pin down to 0V, returning LOW."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_03",
    "title": "Analog Sensors",
    "summary": "The physical universe does not always flip between pure black and white!",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l07_02"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s03",
        "title": "Analog Sensors",
        "type": "visualExplanation",
        "markdownContent": "The physical universe does not always flip between pure black and white! Shadows deepen gradually, temperatures climb fraction by fraction of a degree, and robotic monster arms pivot smoothly through angles.\n\n### The Continuous Spectrum:\nAn **analog sensor** provides a continuous, smoothly varying measurement across an entire range of voltages between 0.0V and 5.0V.\n\nIn Lesson 06, you explored how a rotary potentiometer functions as a variable voltage divider. The Arduino Uno contains an internal **10-bit Analog-to-Digital Converter (ADC)** wired to pins `A0` through `A5`. When you call `analogRead(A0)`, the ADC converts continuous input voltage into an integer from `0` to `1023`:\n\n- **0.0 Volts** = `0`\n- **2.5 Volts** = `512`\n- **5.0 Volts** = `1023`\n- Each count represents $\\approx 4.89\\text{ mV}$ of change!\n\n### Digital vs. Analog Comparison:\n- **Digital Sensor**: *'Is it dark outside? Yes or No.'*\n- **Analog Sensor**: *'Exactly how bright is the room right now? It measures 648 out of 1023.'*\n\nAnalog sensing gives your robot nuanced awareness of its environment!",
        "quickCheck": [
          {
            "questionId": "l07_s03_q1",
            "question": "What range of integer values does `analogRead()` return on an Arduino Uno?",
            "options": [
              "0 to 1023 (10-bit resolution)",
              "0 to 255 (8-bit resolution)",
              "Only binary 0 or 1"
            ],
            "correctIndex": 0,
            "explanation": "The Uno has a 10-bit ADC, which quantizes analog voltages between 0V and 5V into 1024 discrete steps (0 through 1023).",
            "warmupExplanation": "From Lesson 6: 10 bits means 2 to the 10th power = 1024 possible values, counting from 0 up to 1023."
          },
          {
            "questionId": "l07_s03_q2",
            "question": "Why would an engineer choose an analog sensor instead of a digital sensor for a thermometer?",
            "options": [
              "Because temperature changes smoothly and requires measuring subtle gradients across a range",
              "Because analog pins use less electrical current than digital pins",
              "Because digital pins cannot be connected to any microcontroller"
            ],
            "correctIndex": 0,
            "explanation": "Analog sensors capture continuous gradients of physical phenomena, such as smooth temperature fluctuations.",
            "warmupExplanation": "Digital sensors can only answer 'Is it hot: YES/NO?'. An analog sensor can report the exact continuous temperature value."
          }
        ]
      },
      {
        "stepId": "l07_03_s02",
        "title": "The 10-Bit ADC Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Analog-to-Digital Converter (ADC)\n\nReal-world phenomena—such as fading sunlight, room temperature, and potentiometer angles—change smoothly across infinite gradients. Microcontrollers, however, only process numbers!\n\nThe Arduino Uno ATmega328P contains an internal **10-bit Successive Approximation ADC**:\n\n```\nContinuous Voltage Input (0.00V to 5.00V)\n                  │\n                  ▼\n+──────────────────────────────────────────────────────+\n|          10-Bit Successive Approximation ADC         |\n|  2^10 = 1024 Discrete Quantization Levels (0 to 1023)|\n+──────────────────────────────────────────────────────+\n                  │\n                  ▼\n       Resolution = 5.0V / 1024 = 4.88 mV per step\n\n0.00V ──────────► ADC Reading = 0\n1.25V ──────────► ADC Reading = 256\n2.50V ──────────► ADC Reading = 512\n3.75V ──────────► ADC Reading = 768\n5.00V ──────────► ADC Reading = 1023\n```\n\nWhen you call `analogRead(A0)`, the ADC samples the voltage on pin A0 and returns an integer from 0 to 1023."
      },
      {
        "stepId": "l07_03_s03",
        "title": "Analog Jitter & Software Filtering",
        "type": "physicalTask",
        "interactiveWidgetType": "analogReadNoiseFilter",
        "markdownContent": "### Measuring and Smoothing Analog Signals\n\nBecause ADC conversions measure tiny voltage steps (4.88 mV), small thermal ripples and supply fluctuations produce slight reading jitter (e.g. 511, 513, 512, 514).\n\n```cpp\n// Moving Average of 8 consecutive readings\nint readSmoothedAnalog(int pin) {\n  long sum = 0;\n  for (int i = 0; i < 8; i++) {\n    sum += analogRead(pin);\n    delay(2);\n  }\n  return sum / 8;\n}\n```\n\n**Bench Experiment:**\nUse the noise filter simulator below to explore how raw analog sensor jitter is smoothed using software averaging before being passed to robot motor and alarm logic!"
      },
      {
        "stepId": "l07_03_s04",
        "title": "Analog Sensors Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your grasp of analog voltages and 10-bit ADC resolution.",
        "interactiveConfig": {
          "question": "What integer value does analogRead() return when an analog pin receives exactly 2.50V on a 5V Arduino Uno?",
          "options": [
            "Approximately 512",
            "Exactly 2.5",
            "1023"
          ],
          "correctIndex": 0,
          "explanation": "2.5V is half of the 5.0V reference range. Halfway through the 10-bit range (0 to 1023) is approximately 512 counts.",
          "questions": [
            {
              "question": "What integer value does analogRead() return when an analog pin receives exactly 2.50V on a 5V Arduino Uno?",
              "options": [
                "Approximately 512",
                "Exactly 2.5",
                "1023"
              ],
              "correctIndex": 0,
              "explanation": "2.5V is half of the 5.0V reference range. Halfway through the 10-bit range (0 to 1023) is approximately 512 counts."
            },
            {
              "question": "What is the resolution of the built-in ADC on an Arduino Uno R3?",
              "options": [
                "10-bit (1024 discrete quantization steps)",
                "8-bit (256 discrete quantization steps)",
                "1-bit (HIGH or LOW only)"
              ],
              "correctIndex": 0,
              "explanation": "The ATmega328P microcontroller has a 10-bit ADC, which divides the 0V-5V input voltage into 2^10 = 1024 integer steps (0 to 1023)."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_04",
    "title": "Distance Sensors",
    "summary": "Time to inspect your first superpower sensor: the HC-SR04 Ultrasonic Distance Sensor (comp01)!",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l07_03"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s04",
        "title": "Distance Sensors",
        "type": "physicalTask",
        "markdownContent": "Time to inspect your first superpower sensor: the **HC-SR04 Ultrasonic Distance Sensor (`comp_01`)**!\n\n### Nature's Echolocation:\nJust like a bat navigating a dark cave or a submarine pinging the ocean depths, the HC-SR04 uses sound waves to calculate distance:\n1. **The 'Eyes' of the Sensor**: Notice the two metallic cylinders on the front. One is labeled **T** (Transmitter/Speaker) and the other **R** (Receiver/Microphone).\n2. **The Ping**: The Arduino triggers the **TRIG** pin to emit a burst of ultrasonic sound at 40,000 Hz (far above human hearing).\n3. **The Echo**: The sound bounces off an obstacle in front of the sensor. The **ECHO** pin goes `HIGH` for the exact amount of time the sound took to make the round trip!\n\n### Distance Formula Math:\nSound travels through room-temperature air at approximately 340 meters per second ($0.034\\text{ cm/\\mu s}$):\n$$\\text{Distance (cm)} = \\frac{\\text{Echo Time (microseconds)} \\times 0.034}{2}$$\n*(We divide by 2 because the sound traveled out to the object and all the way back!)*\n\n### Breadboard Wiring Tour:\n- **VCC**: Connect to Uno **5V** power rail.\n- **GND**: Connect to Uno **GND** ground rail.\n- **TRIG**: Connect to Uno Digital Pin **9**.\n- **ECHO**: Connect to Uno Digital Pin **10**.",
        "quickCheck": [
          {
            "questionId": "l07_s04_q1",
            "question": "How does an ultrasonic distance sensor (HC-SR04) calculate the distance to an obstacle?",
            "options": [
              "By timing how long high-frequency sound pulses take to echo back from the object",
              "By shining an invisible laser beam and measuring its brightness",
              "By sensing the magnetic field produced by nearby objects"
            ],
            "correctIndex": 0,
            "explanation": "The ultrasonic sensor emits high-frequency sound waves from its trigger cylinder and measures the travel time of the echo bouncing back.",
            "warmupExplanation": "Think of a bat shouting in a dark cave: it listens for how long the echo takes to return to know how far away the cave wall is!"
          },
          {
            "questionId": "l07_s04_q2",
            "question": "Why do we divide the echo travel time by 2 when calculating distance in centimeters?",
            "options": [
              "Because the sound pulse travels out to the object and then all the way back, covering twice the distance",
              "Because the Arduino processor runs twice as fast as sound",
              "Because the sensor has two metal cylinders"
            ],
            "correctIndex": 0,
            "explanation": "The sound wave makes a round trip: from the sensor to the obstacle, and back to the sensor. Dividing by 2 gives the one-way distance.",
            "warmupExplanation": "If you walk to a tree and walk back home, you walked double the distance to the tree. Divide by 2 to get the distance from home to tree!"
          }
        ]
      },
      {
        "stepId": "l07_04_s02",
        "title": "Ultrasonic Echolocation Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### How the HC-SR04 Uses Sound Waves\n\nThe **HC-SR04 Ultrasonic Distance Sensor (`comp_01`)** gives your monster robot bats' superpower of echolocation:\n\n```\n[ Arduino ] ── Trigger (10 µs HIGH) ──► [ Transmitter (T) ]\n                                                │\n                                                ▼  Sound Burst (40 kHz ultrasonic wave)\n                                            ) ) ) ) ) ) )\n                                                          │\n                                                    [ Obstacle Wall ]\n                                                          │\n                                            ( ( ( ( ( ( (\n                                                ▲  Echo Reflection\n                                                │\n[ Arduino ] ◄── Echo Pin (HIGH pulse) ── [ Receiver (R) ]\n```\n\n1. **Trigger Pin**: The Arduino sends a 10-microsecond HIGH pulse to start the measurement.\n2. **Sonic Burst**: The sensor's transmitter cylinder emits eight ultrasonic sound pulses at 40,000 Hz.\n3. **Echo Pin**: The sensor holds its Echo pin HIGH for the exact duration it takes for the sound wave to travel to the obstacle and bounce back!"
      },
      {
        "stepId": "l07_04_s03",
        "title": "Echo Pulse Timing and Speed of Sound Math",
        "type": "codeExperiment",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Calculating Distance from Microseconds\n\nSound travels through room-temperature air at approximately **343 meters per second**, which equals **0.0343 centimeters per microsecond**:\n\n```cpp\nconst int trigPin = 9;\nconst int echoPin = 10;\n\nvoid setup() {\n  pinMode(trigPin, OUTPUT);\n  pinMode(echoPin, INPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  // 1. Send 10µs trigger pulse\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(trigPin, LOW);\n\n  // 2. Measure round-trip echo pulse duration\n  long duration = pulseIn(echoPin, HIGH);\n\n  // 3. Distance formula: divide by 2 for one-way distance!\n  float distanceCm = (duration * 0.0343) / 2.0;\n\n  Serial.print(\"Distance: \");\n  Serial.print(distanceCm);\n  Serial.println(\" cm\");\n  delay(200);\n}\n```\n\n**Troubleshooting Workbench:**\nUse the diagnostic simulator below to identify what happens when trigger and echo jumper wires are accidentally reversed or disconnected!"
      },
      {
        "stepId": "l07_04_s04",
        "title": "Distance Sensor Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of ultrasonic sound wave transmission and round-trip distance math.",
        "interactiveConfig": {
          "question": "Why do we divide the pulse duration by 2 in the HC-SR04 distance formula?",
          "options": [
            "Because the sound wave travels out to the obstacle and bounces back, covering double the distance",
            "Because the Arduino clock runs at half speed when measuring sound",
            "Because ultrasonic sound waves travel at half the speed of light"
          ],
          "correctIndex": 0,
          "explanation": "The measured echo pulse duration represents the entire round trip (to the target and back). To calculate the distance to the obstacle, we divide by 2.",
          "questions": [
            {
              "question": "Why do we divide the pulse duration by 2 in the HC-SR04 distance formula?",
              "options": [
                "Because the sound wave travels out to the obstacle and bounces back, covering double the distance",
                "Because the Arduino clock runs at half speed when measuring sound",
                "Because ultrasonic sound waves travel at half the speed of light"
              ],
              "correctIndex": 0,
              "explanation": "The measured echo pulse duration represents the entire round trip (to the target and back). To calculate the distance to the obstacle, we divide by 2."
            },
            {
              "question": "Which HC-SR04 pin produces a HIGH pulse whose duration matches the sound wave travel time?",
              "options": [
                "Echo pin",
                "Trigger pin",
                "VCC pin"
              ],
              "correctIndex": 0,
              "explanation": "The Trigger pin receives a start command from the Arduino, while the Echo pin outputs a HIGH signal whose width matches the travel time of the sound pulse."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_05",
    "title": "Light Sensors",
    "summary": "Now let's give our monster the sense of sight using the Light Dependent Resistor (LDR / Photoresistor, comp19)!",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l07_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s05",
        "title": "Light Sensors",
        "type": "physicalTask",
        "markdownContent": "Now let's give our monster the sense of sight using the **Light Dependent Resistor (LDR / Photoresistor, `comp_19`)**!\n\n### How Light Changes Resistance:\nAn LDR is made of a light-sensitive semiconductor (cadmium sulfide) with a squiggly conductive track on top:\n- **In Pitch Darkness**: Electrons stay locked in place. The LDR has very high resistance (often $50\\text{k}\\Omega$ to $100\\text{k}\\Omega$ or more), blocking current flow.\n- **In Bright Light**: Incoming photons knock electrons loose! Electrical resistance plunges (down to $500\\Omega$ or less), letting current flow freely.\n\n### The Voltage Divider Partner:\nBecause the Arduino ADC only measures voltage ($0\\text{V}-5\\text{V}$) rather than raw resistance, we must pair the LDR with a fixed **10kΩ resistor** to create a voltage divider:\n\n```\n5V Rail ➔ LDR Leg 1 ➔ [LDR Leg 2 + Junction to Pin A0] ➔ 10k Resistor ➔ GND Rail\n```\n\n### Breadboard Wiring Tour:\n1. Insert the LDR into two separate breadboard rows.\n2. Connect one leg of the LDR to the **5V** rail with a jumper wire.\n3. Connect the other leg of the LDR to Uno Analog Pin **A0**.\n4. From that exact same junction row, insert one leg of a **10kΩ fixed resistor** (brown-black-orange bands), and connect its other leg to the **GND** rail.\n\nNow, when light shifts across the sensor, the voltage at pin A0 glides between 0V and 5V!",
        "quickCheck": [
          {
            "questionId": "l07_s05_q1",
            "question": "What happens to the electrical resistance of a photoresistor (LDR) when exposed to bright light?",
            "options": [
              "Its resistance drops significantly, allowing current to flow more easily",
              "Its resistance rises infinitely, blocking all current flow",
              "Its resistance stays strictly constant at 10,000 ohms"
            ],
            "correctIndex": 0,
            "explanation": "Light photons liberate electrons in the semiconductor material, dramatically reducing the LDR's electrical resistance.",
            "warmupExplanation": "More light = less resistance! In the dark, the LDR resists current; in bright light, current flows freely."
          },
          {
            "questionId": "l07_s05_q2",
            "question": "Why must an LDR be paired with a fixed resistor in a voltage divider circuit to be read by an Arduino?",
            "options": [
              "Because the Arduino ADC measures voltage, so the circuit converts changing resistance into changing voltage",
              "To prevent the Arduino USB cable from melting",
              "Because photoresistors cannot connect to breadboards without a helper resistor"
            ],
            "correctIndex": 0,
            "explanation": "Arduino analog pins read voltages (0-5V), not raw resistance. A voltage divider converts the LDR's resistance shifts into measurable voltage levels.",
            "warmupExplanation": "Recall Lesson 6: Arduino's ADC pin measures voltage! Pairing the LDR with a fixed resistor creates a voltage divider that splits the 5V supply."
          }
        ]
      },
      {
        "stepId": "l07_05_s02",
        "title": "Light-Dependent Resistor & Voltage Divider",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Science of Photoresistance\n\nThe **Light-Dependent Resistor (LDR / Photoresistor, `comp_19`)** contains a cadmium sulfide semiconductor track:\n- **Total Darkness**: Photons are absent, electrons are trapped -> Resistance soars over **1,000,000 Ω (1 MΩ)**.\n- **Bright Sunshine**: Photons strike the semiconductor, freeing electrons -> Resistance plummets to **few hundred Ω**.\n\n```\n         +5V Power Rail\n              │\n             ┌┴┐\n             │ │  Photoresistor (LDR)\n             └┬┘  (Variable Resistance R1)\n              │\n              ├───► Analog Pin A0  (Vout = 5V * R2 / (R1 + R2))\n              │\n             ┌┴┐\n             │ │  Fixed Resistor (10 kΩ)\n             └┬┘  (Reference Resistance R2)\n              │\n         GND Ground Rail\n```\n\nBecause the Arduino ADC only measures voltage (not raw resistance), pairing the LDR with a fixed 10kΩ resistor in a **voltage divider** converts changing resistance into a varying 0V to 5V voltage signal!"
      },
      {
        "stepId": "l07_05_s03",
        "title": "Calibrating Ambient Light Telemetry",
        "type": "physicalTask",
        "interactiveWidgetType": "analogReadNoiseFilter",
        "markdownContent": "### Bench Experiment: Light vs Shadow\n\nWhen wiring your LDR circuit:\n1. Connect one leg of the LDR to +5V.\n2. Connect the other leg to analog pin **A0**, AND connect a 10kΩ resistor from that same A0 junction to **GND**.\n\n```cpp\nvoid setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int lightLevel = analogRead(A0);\n  Serial.print(\"Raw Light Level (0-1023): \");\n  Serial.println(lightLevel);\n  delay(100);\n}\n```\n\n**Laboratory Task:**\nObserve the live readings in the simulator. Cover the sensor with your thumb to observe darkness drop, then shine a light to observe the voltage rise!"
      },
      {
        "stepId": "l07_05_s04",
        "title": "Light Sensor Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of photoresistors and voltage divider principles.",
        "interactiveConfig": {
          "question": "What happens to the internal electrical resistance of an LDR when bright light strikes its surface?",
          "options": [
            "Its electrical resistance decreases sharply",
            "Its electrical resistance increases to infinity",
            "Its electrical resistance stays permanently at 10,000 ohms"
          ],
          "correctIndex": 0,
          "explanation": "Incoming light photons energize electrons in the semiconductor material, dramatically reducing electrical resistance.",
          "questions": [
            {
              "question": "What happens to the internal electrical resistance of an LDR when bright light strikes its surface?",
              "options": [
                "Its electrical resistance decreases sharply",
                "Its electrical resistance increases to infinity",
                "Its electrical resistance stays permanently at 10,000 ohms"
              ],
              "correctIndex": 0,
              "explanation": "Incoming light photons energize electrons in the semiconductor material, dramatically reducing electrical resistance."
            },
            {
              "question": "Why must an LDR be paired with a fixed resistor in a voltage divider circuit to be read by an Arduino?",
              "options": [
                "Because the Arduino ADC measures voltage, not raw resistance; the divider translates resistance shifts into voltage changes",
                "Because the LDR would otherwise explode from high battery voltage",
                "Because the Arduino can only run code when resistors are present"
              ],
              "correctIndex": 0,
              "explanation": "The Arduino's analog inputs only measure electrical potential (voltage from 0V to 5V). A voltage divider circuit transforms variable resistance into proportional voltage."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_06",
    "title": "Reading Sensor Data",
    "summary": "Let's stream live sensor telemetry straight into your computer's screen using the Arduino IDE Serial Monitor!",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l07_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s06",
        "title": "Reading Sensor Data",
        "type": "codeExperiment",
        "markdownContent": "Let's stream live sensor telemetry straight into your computer's screen using the Arduino IDE **Serial Monitor**!\n\n### The Sensor Reader Sketch:\nUpload the following sketch to read both the LDR on `A0` and the Ultrasonic distance sensor on pins `9` & `10`:\n\n```cpp\nconst int trigPin = 9;   // HC-SR04 Trigger pin\nconst int echoPin = 10;  // HC-SR04 Echo pin\nconst int ldrPin = A0;   // Photoresistor analog pin\n\nvoid setup() {\n  Serial.begin(9600);     // Open serial channel at 9600 baud\n  pinMode(trigPin, OUTPUT); \n  pinMode(echoPin, INPUT);  \n}\n\nvoid loop() {\n  // 1. Trigger ultrasonic acoustic chirp\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(trigPin, LOW);\n\n  // 2. Measure pulse duration in microseconds\n  long duration = pulseIn(echoPin, HIGH);\n  int distanceCm = duration * 0.034 / 2;\n\n  // 3. Read analog light level\n  int lightLevel = analogRead(ldrPin);\n\n  // 4. Stream telemetry to Serial Monitor\n  Serial.print(\"Light Level: \");\n  Serial.print(lightLevel);\n  Serial.print(\" | Distance: \");\n  Serial.print(distanceCm);\n  Serial.println(\" cm\");\n\n  delay(200); // 5 Hz telemetry cadence for easy reading\n}\n```\n\n### Experiment With Telemetry:\nOpen the Serial Monitor (Ctrl+Shift+M / Cmd+Shift+M) and ensure the baud rate dropdown is set to **9600 baud**. Move your hand toward the ultrasonic sensor and watch the distance count drop smoothly. Cover the LDR with your thumb and watch the light level drop!",
        "quickCheck": [
          {
            "questionId": "l07_s06_q1",
            "question": "Which command in `setup()` opens the serial data channel so your computer can display sensor telemetry?",
            "options": [
              "Serial.begin(9600);",
              "pinMode(SERIAL, INPUT);",
              "analogRead(SERIAL_PORT);"
            ],
            "correctIndex": 0,
            "explanation": "Serial.begin(9600) sets the communication speed (baud rate) and opens the serial channel between the Arduino and computer.",
            "warmupExplanation": "From Lesson 4 & 6: Serial.begin(9600) is the handshake that lets your Arduino talk to the Serial Monitor at 9600 bits per second."
          },
          {
            "questionId": "l07_s06_q2",
            "question": "What happens if the baud rate selected in the Arduino IDE Serial Monitor does not match `Serial.begin()` in your code?",
            "options": [
              "The telemetry will appear as garbled symbols, gibberish, or blank lines",
              "The Arduino microcontroller chip will be permanently damaged",
              "The sensor will stop measuring physical values"
            ],
            "correctIndex": 0,
            "explanation": "When baud rates mismatch, the computer and Arduino sample bits at different speeds, resulting in garbled characters or blank text.",
            "warmupExplanation": "Both sides must agree on the exact same speed (like 9600 baud) to understand each other's data signals."
          }
        ]
      },
      {
        "stepId": "l07_06_s02",
        "title": "The Serial Telemetry Pipeline",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Streaming Data Over UART Serial\n\nTo see what your robot senses, you stream digital telemetry over the USB cable to your computer's screen:\n\n```\n[ Sensor Voltage ] ──► [ ATmega328P ADC ]\n                              │\n                              ▼ (10-bit integer 0-1023)\n                       [ Hardware UART ]\n                              │\n                              ▼ (ASCII text bytes at 9600 bits/sec)\n                       [ USB-Serial Bridge Chip ]\n                              │\n                              ▼ (USB D+ / D- packets)\n                       [ Computer Screen: Arduino Serial Monitor ]\n```\n\n- `Serial.begin(9600)`: Synchronizes the communication clock to 9,600 baud (bits per second).\n- `Serial.print()`: Streams text or numbers side-by-side on the same terminal line.\n- `Serial.println()`: Appends a carriage return and newline (`\\r\\n`), moving the cursor down to the next row."
      },
      {
        "stepId": "l07_06_s03",
        "title": "Diagnosing Serial Monitor Mismatches",
        "type": "codeExperiment",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Formatting Telemetry and Fixing Mismatches\n\nWhen printing sensor data, always include descriptive text labels so you know what each number represents:\n\n```cpp\nvoid loop() {\n  int rawLdr = analogRead(A0);\n  float voltage = rawLdr * (5.0 / 1023.0);\n\n  Serial.print(\"LDR Count: \");\n  Serial.print(rawLdr);\n  Serial.print(\" | Voltage: \");\n  Serial.print(voltage);\n  Serial.println(\" V\");\n\n  delay(250);\n}\n```\n\n**Common Trap: Baud Rate Mismatch**\nIf `Serial.begin(9600);` is in code, but the Serial Monitor bottom dropdown is set to `115200 baud`, the computer samples incoming bits at the wrong clock speed, displaying garbled alien characters (`⸮⸮⸮`).\n\nPractice aligning serial settings in the troubleshooting lab below!"
      },
      {
        "stepId": "l07_06_s04",
        "title": "Serial Telemetry Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of serial communications and telemetry formatting.",
        "interactiveConfig": {
          "question": "What happens if the baud rate selected in the Arduino Serial Monitor does not match Serial.begin() in your sketch?",
          "options": [
            "The Serial Monitor displays garbled, unintelligible symbols or question marks",
            "The Arduino board immediately powers off",
            "The sensor values are automatically multiplied by 10"
          ],
          "correctIndex": 0,
          "explanation": "When baud rates do not match, the receiver samples incoming bits at the wrong clock frequency, causing timing framing errors and garbled output.",
          "questions": [
            {
              "question": "What happens if the baud rate selected in the Arduino Serial Monitor does not match Serial.begin() in your sketch?",
              "options": [
                "The Serial Monitor displays garbled, unintelligible symbols or question marks",
                "The Arduino board immediately powers off",
                "The sensor values are automatically multiplied by 10"
              ],
              "correctIndex": 0,
              "explanation": "When baud rates do not match, the receiver samples incoming bits at the wrong clock frequency, causing timing framing errors and garbled output."
            },
            {
              "question": "What is the key difference between Serial.print(\"Value\") and Serial.println(\"Value\")?",
              "options": [
                "Serial.println() automatically moves the terminal cursor to a new line after printing",
                "Serial.println() only prints numbers while Serial.print() only prints letters",
                "Serial.println() sends data directly to an SD card instead of USB"
              ],
              "correctIndex": 0,
              "explanation": "Serial.println() appends newline and carriage return characters at the end of the text, advancing subsequent output to the next line."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_07",
    "title": "Sensor Thresholds",
    "summary": "Raw data numbers like 642 or 14 cm mean nothing to a monster robot on their own.",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l07_06"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s07",
        "title": "Sensor Thresholds",
        "type": "visualExplanation",
        "markdownContent": "Raw data numbers like `642` or `14 cm` mean nothing to a monster robot on their own. To give your creation intelligence, you must define **thresholds**!\n\n### What Is a Threshold?\nA **threshold** is a boundary value in code that divides one decision state from another. When sensor data crosses this invisible line, your robot changes its behavior:\n\n```cpp\nconst int PROXIMITY_THRESHOLD = 20; // 20 cm boundary\n\nif (distanceCm < PROXIMITY_THRESHOLD) {\n  // Action when an obstacle gets closer than 20 cm!\n}\n```\n\n### Multi-Level Decision Zones:\nYou can create multiple thresholds to categorize the world into nuanced zones:\n- **Zone 1: Danger Close (`< 10 cm`)**: Halt all motors and sound the loud alarm!\n- **Zone 2: Caution (`10 cm to 30 cm`)**: Slow down and blink a warning light.\n- **Zone 3: Clear (`> 30 cm`)**: Cruise forward freely.\n\n### The Calibration Principle:\nEvery environment is unique! On a bright sunny morning, your LDR might read `750` in ambient light and `250` in shadow. On an overcast evening in a dim room, it might read `400` in ambient light and `120` in shadow.\n\n⚠️ **Golden Rule of Calibration**: Never guess threshold numbers! Always open the Serial Monitor, observe your sensor's minimum and maximum readings in your actual physical room, and choose a threshold midway between them!",
        "quickCheck": [
          {
            "questionId": "l07_s07_q1",
            "question": "What is a 'threshold' in sensor programming?",
            "options": [
              "A cutoff value used in comparison statements to trigger actions or mode changes",
              "The maximum voltage a wire can carry before breaking",
              "The total memory size available on the ATmega328P chip"
            ],
            "correctIndex": 0,
            "explanation": "A threshold is a boundary number used in conditional statements (like if/else) to decide when an action should trigger.",
            "warmupExplanation": "Think of a height requirement on a roller coaster: 'You must be this tall to ride!' That minimum height is a threshold."
          },
          {
            "questionId": "l07_s07_q2",
            "question": "Why is sensor calibration necessary before hardcoding threshold values in code?",
            "options": [
              "Because environmental baselines (like room lighting and acoustic reflections) differ across locations",
              "Because Arduino analog pins lose their settings whenever power is disconnected",
              "Because sensors only work if calibrated by the factory every week"
            ],
            "correctIndex": 0,
            "explanation": "Sensors respond to real ambient environments. A room on a sunny day produces very different baseline readings than the same room at dusk.",
            "warmupExplanation": "Always check raw numbers in the Serial Monitor first so you know what 'normal' looks like in your specific room!"
          }
        ]
      },
      {
        "stepId": "l07_07_s02",
        "title": "Decision Boundaries and Hysteresis",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### From Raw Numbers to Smart Decisions\n\nA raw reading like `487` doesn't make a robot intelligent. A robot becomes smart when it compares readings against a **decision threshold**:\n\n```\n                       [ RAW SENSOR READING ]\n                                 │\n                 Is reading > Threshold (e.g. 500)?\n                                ╱ ╲\n                               ╱   ╲\n                           YES╱     ╲NO\n                             ▼       ▼\n                       [ Daytime ]  [ Nighttime ]\n                       (LED OFF)    (LED ON)\n```\n\n### The Boundary Chatter Problem & Hysteresis\nIf the room light reading hovers right at `500` (oscillating 499, 501, 500, 499), a single threshold makes an LED flicker rapidly!\n\nRobotics engineers solve this with **hysteresis** (dual thresholds):\n- Turn ON only when light drops below **450** (definitely dark).\n- Turn OFF only when light rises above **550** (definitely bright)."
      },
      {
        "stepId": "l07_07_s03",
        "title": "Calibrating Trigger Thresholds Against Noise",
        "type": "codeExperiment",
        "interactiveWidgetType": "analogReadNoiseFilter",
        "markdownContent": "### Calibration: Measuring the Real World\n\nNever guess threshold numbers in your head! Every room, flashlight, and sensor batch has unique electrical characteristics.\n\n**The Calibration Routine:**\n1. Read the sensor in normal room light (e.g. `reading = 720`).\n2. Cover the sensor completely to simulate darkness (e.g. `reading = 180`).\n3. Calculate the midpoint threshold:\n   ```cpp\n   int threshold = (720 + 180) / 2; // = 450\n   ```\n\n**Laboratory Task:**\nIn the interactive filter below, test how noise filtering stabilizes sensor readings near decision boundaries to eliminate false alarms!"
      },
      {
        "stepId": "l07_07_s04",
        "title": "Thresholds Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of sensor calibration and decision thresholds.",
        "interactiveConfig": {
          "question": "If an LDR circuit reads 800 in bright room light and 200 in shadow, what is an optimal midpoint threshold to trigger a nightlight?",
          "options": [
            "500",
            "1000",
            "50"
          ],
          "correctIndex": 0,
          "explanation": "The midpoint is (800 + 200) / 2 = 500. This provides a balanced buffer between both operating states.",
          "questions": [
            {
              "question": "If an LDR circuit reads 800 in bright room light and 200 in shadow, what is an optimal midpoint threshold to trigger a nightlight?",
              "options": [
                "500",
                "1000",
                "50"
              ],
              "correctIndex": 0,
              "explanation": "The midpoint is (800 + 200) / 2 = 500. This provides a balanced buffer between both operating states."
            },
            {
              "question": "Why do engineers implement hysteresis (separate turn-on and turn-off thresholds) in sensor systems?",
              "options": [
                "To stop actuators from rapid, annoying flickering when sensor values fluctuate near the boundary",
                "To make the microcontroller draw zero electrical current",
                "To allow the circuit to operate without an Arduino board"
              ],
              "correctIndex": 0,
              "explanation": "Hysteresis introduces a deadband gap between activation and deactivation thresholds, preventing noisy sensor signals from chattering on and off."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_08",
    "title": "Sensor -> Output",
    "summary": "Now let's complete the loop by connecting a sensor input directly to a physical output actuator!",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l07_07"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s08",
        "title": "Sensor -> Output",
        "type": "physicalTask",
        "markdownContent": "Now let's complete the loop by connecting a sensor input directly to a physical output actuator!\n\n### Hardware Mission: Proximity Alarm LED\nKeep your HC-SR04 ultrasonic sensor wired on pins `9` (TRIG) and `10` (ECHO). Add an indicator LED:\n- Connect the **Anode** (longer leg) of a Red LED to Uno Digital Pin **13** (which has an onboard series resistor).\n- Connect the **Cathode** (shorter flat leg) of the LED to the **GND** rail.\n\n### Firmware Architecture:\nHere is how sensor readings drive output decisions:\n\n```cpp\nconst int trigPin = 9;\nconst int echoPin = 10;\nconst int alertLedPin = 13;\nconst int NEAR_THRESHOLD_CM = 15; // Trigger alarm if closer than 15 cm\n\nvoid setup() {\n  pinMode(trigPin, OUTPUT);\n  pinMode(echoPin, INPUT);\n  pinMode(alertLedPin, OUTPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  // Ping ultrasonic sensor\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(trigPin, LOW);\n\n  long duration = pulseIn(echoPin, HIGH);\n  int distanceCm = duration * 0.034 / 2;\n\n  // Threshold decision logic\n  if (distanceCm > 0 && distanceCm < NEAR_THRESHOLD_CM) {\n    digitalWrite(alertLedPin, HIGH); // Alarm ON: Monster eye glows!\n    Serial.println(\"WARNING: Intruder in perimeter!\");\n  } else {\n    digitalWrite(alertLedPin, LOW);  // Alarm OFF: Area clear\n    Serial.println(\"Status: Patrol normal.\");\n  }\n\n  delay(100);\n}\n```\n\nUpload the sketch, wave your hand in front of the sensor, and observe how your monster instantly reacts to proximity!",
        "quickCheck": [
          {
            "questionId": "l07_s08_q1",
            "question": "In a complete robotic control loop, what is the correct chronological sequence of operations?",
            "options": [
              "Sense the environment -> Process data with logic -> Command output actuators",
              "Command output actuators -> Sense the environment -> Turn off the power",
              "Process logic -> Command output actuators -> Wire the breadboard"
            ],
            "correctIndex": 0,
            "explanation": "Robotic systems follow the Sense -> Think -> Act loop: gather sensor data, process decisions in code, and command physical outputs.",
            "warmupExplanation": "Sense, Think, Act! First your robot gathers info, then its code decides, and finally it takes action in the world."
          },
          {
            "questionId": "l07_s08_q2",
            "question": "Which command turns an alert LED connected to digital pin 13 ON when a sensor threshold is triggered?",
            "options": [
              "digitalWrite(13, HIGH);",
              "digitalRead(13, HIGH);",
              "analogWrite(13, 0);"
            ],
            "correctIndex": 0,
            "explanation": "digitalWrite(13, HIGH) sends 5V to digital pin 13, illuminating the connected LED.",
            "warmupExplanation": "From Lesson 5: digitalWrite(pin, HIGH) applies full 5V power to make an LED illuminate."
          }
        ]
      },
      {
        "stepId": "l07_08_s02",
        "title": "The Closed-Loop Perception-Action Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Complete Cybernetic Feedback Loop\n\nRobots don't just sense the world—they react to it! This is called the **Perception-Action Loop**:\n\n```\n+──────────────────────────────────────────────────────────────────────────+\n|                    CLOSED-LOOP ROBOT CONTROLLER                          |\n|                                                                          |\n|   1. SENSE:  Read hardware input (analogRead(A0) or pulseIn(echoPin))    |\n|        │                                                                 |\n|        ▼                                                                 |\n|   2. THINK:  Compare value against threshold in conditional if/else      |\n|        │                                                                 |\n|        ▼                                                                 |\n|   3. ACT:    Drive actuator pin (digitalWrite(13, HIGH) or tone())       |\n|        │                                                                 |\n|        ▼                                                                 |\n|   4. REPEAT: Loop immediately to maintain real-time responsiveness       |\n+──────────────────────────────────────────────────────────────────────────+\n```\n\nEvery autonomous system—from automatic room nightlights to self-driving cars—runs this loop continuously."
      },
      {
        "stepId": "l07_08_s03",
        "title": "Proximity Alert Circuit Diagnosis",
        "type": "physicalTask",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Hardware Build: Ultrasonic Intruder Sentry\n\nConnect your HC-SR04 distance sensor and an alert LED:\n- Trig -> Pin 9, Echo -> Pin 10\n- LED Anode -> Pin 13 through a 220Ω resistor, Cathode -> GND\n\n```cpp\nconst int trigPin = 9;\nconst int echoPin = 10;\nconst int ledPin = 13;\nconst int alertThresholdCm = 15; // 15 cm threshold\n\nvoid setup() {\n  pinMode(trigPin, OUTPUT);\n  pinMode(echoPin, INPUT);\n  pinMode(ledPin, OUTPUT);\n}\n\nvoid loop() {\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(trigPin, LOW);\n\n  long duration = pulseIn(echoPin, HIGH);\n  float distanceCm = (duration * 0.0343) / 2.0;\n\n  if (distanceCm > 0 && distanceCm < alertThresholdCm) {\n    digitalWrite(ledPin, HIGH); // Intruder detected!\n  } else {\n    digitalWrite(ledPin, LOW);  // All clear\n  }\n  delay(100);\n}\n```\n\n**Troubleshooting Lab:**\nPractice resolving common wiring traps (swapped pins, reverse LED polarity) in the workbench below!"
      },
      {
        "stepId": "l07_08_s04",
        "title": "Perception-Action Loop Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Verify your understanding of closed-loop robotic control architectures.",
        "interactiveConfig": {
          "question": "What is the correct execution sequence inside loop() for an autonomous sensor-driven alarm?",
          "options": [
            "Read sensor input -> Evaluate threshold condition -> Command output actuator",
            "Command output actuator -> Compile C++ sketch -> Read sensor input",
            "Unplug USB cable -> Set pin modes -> Measure circuit voltage"
          ],
          "correctIndex": 0,
          "explanation": "A closed-loop control system must always gather current telemetry (Sense), make logical decisions (Think), and then command physical actions (Act).",
          "questions": [
            {
              "question": "What is the correct execution sequence inside loop() for an autonomous sensor-driven alarm?",
              "options": [
                "Read sensor input -> Evaluate threshold condition -> Command output actuator",
                "Command output actuator -> Compile C++ sketch -> Read sensor input",
                "Unplug USB cable -> Set pin modes -> Measure circuit voltage"
              ],
              "correctIndex": 0,
              "explanation": "A closed-loop control system must always gather current telemetry (Sense), make logical decisions (Think), and then command physical actions (Act)."
            },
            {
              "question": "What happens if you command digitalWrite(13, HIGH) in code without first calling pinMode(13, OUTPUT) in setup()?",
              "options": [
                "The pin remains in high-impedance INPUT mode and an attached LED will only glow very faintly or not at all",
                "The microcontroller chip will burn out immediately",
                "The LED blinks at 10,000 Hz automatically"
              ],
              "correctIndex": 0,
              "explanation": "Without pinMode(13, OUTPUT), the pin remains in high-impedance input mode; writing HIGH merely enables the internal weak pull-up resistor, providing barely enough current to illuminate an LED faintly."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_09",
    "title": "Multiple Sensors",
    "summary": "Living creatures do not rely on just one sense.",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l07_08"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s09",
        "title": "Multiple Sensors",
        "type": "physicalTask",
        "markdownContent": "Living creatures do not rely on just one sense. A monster guards its territory using both sight and hearing simultaneously!\n\n### Multi-Sensor Fusion:\nWhen you combine multiple sensors, your robot can make sophisticated, multi-factor decisions using C++ boolean logic:\n\n#### 1. Logical AND (`&&`) — Both Conditions Required:\nSuppose we want a **Night-Watch Sentry**: the alarm should only wake up if it is pitch dark in the room **AND** someone sneaks within 20 cm of the guard post!\n\n```cpp\nif (lightLevel < 250 && distanceCm < 20) {\n  digitalWrite(alarmLed, HIGH); // Intruder lurking in the shadows!\n} else {\n  digitalWrite(alarmLed, LOW);\n}\n```\n\n#### 2. Logical OR (`||`) — Either Condition Triggers:\nSuppose we want an **Emergency Security Alarm**: trigger if an object is dangerously close **OR** if an intruder turns on a flashlight:\n\n```cpp\nif (distanceCm < 10 || lightLevel > 800) {\n  digitalWrite(alarmLed, HIGH); // Emergency breach!\n}\n```\n\n### Prioritized Conditions:\nWhat if sensor readings conflict? By ordering `if`, `else if`, and `else` blocks strategically, you establish clear priority hierarchy so safety rules always take precedence over everyday tasks!",
        "quickCheck": [
          {
            "questionId": "l07_s09_q1",
            "question": "Which C++ logical operator requires BOTH sensor conditions to be true before executing an `if` block?",
            "options": [
              "The logical AND operator (&&)",
              "The logical OR operator (||)",
              "The assignment operator (=)"
            ],
            "correctIndex": 0,
            "explanation": "The && operator evaluates to true only when both conditions on either side are true simultaneously.",
            "warmupExplanation": "From Coding Foundations: && means both must be true, while || means either one can be true."
          },
          {
            "questionId": "l07_s09_q2",
            "question": "If you want a robot alarm to sound if a collision switch hits an obstacle OR a distance sensor reads under 5 cm, which operator should connect the conditions?",
            "options": [
              "The logical OR operator (||)",
              "The logical AND operator (&&)",
              "The equality operator (==)"
            ],
            "correctIndex": 0,
            "explanation": "The || (OR) operator triggers the action if either one of the conditions is met.",
            "warmupExplanation": "Use || when either warning signal is enough to trigger the protective response!"
          }
        ]
      },
      {
        "stepId": "l07_09_s02",
        "title": "Multi-Sensor Fusion Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Multi-Sensor Fusion\n\nLiving creatures don't navigate with only one sense. A friendly lab monster combines sight, sound, and touch simultaneously!\n\nIn robotics, **sensor fusion** combines data from multiple sensors to make reliable, intelligent decisions using Boolean logic:\n\n```\n[ Light Sensor (LDR) ] ────────► isDark = (ldr < 400)\n                                        │\n                                        ▼\n                                [ Boolean Logic ] ──► TRIGGER SENTRY ALARM?\n                                        ▲\n[ Ultrasonic Distance ] ───────► isClose = (dist < 15)\n```\n\n- **Logical AND (`&&`)**: BOTH conditions must be true simultaneously!\n  ```cpp\n  if (isDark && isClose) {\n    // Only alarm if it is night AND an intruder is close!\n  }\n  ```\n- **Logical OR (`||`)**: EITHER condition triggers the action!\n  ```cpp\n  if (bumpSwitchPressed || distanceCm < 5) {\n    // Emergency stop if bumped OR wall too close!\n  }\n  ```"
      },
      {
        "stepId": "l07_09_s03",
        "title": "Evaluating Multi-Sensor Decision Matrices",
        "type": "codeExperiment",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Hands-On: Sentry Guard Logic Matrix\n\nReview this truth table for the Night Sentry Robot:\n\n| Light Level (`isDark`) | Distance (`isClose`) | `isDark && isClose` | Monster Action |\n|:---:|:---:|:---:|:---|\n| Bright (False) | Far (False) | **FALSE** | Sleeping (Standby) |\n| Bright (False) | Near (True) | **FALSE** | Ignoring (Daytime visitor) |\n| Dark (True) | Far (False) | **FALSE** | Patrolling quietly |\n| Dark (True) | Near (True) | **TRUE** | **ALARM TRIGGERED!** |\n\n**Troubleshooting Lab:**\nPractice testing multi-condition `if` statements and identifying logic bugs in the interactive simulator below!"
      },
      {
        "stepId": "l07_09_s04",
        "title": "Multi-Sensor Fusion Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of multi-sensor fusion and C++ Boolean operators.",
        "interactiveConfig": {
          "question": "Which C++ Boolean operator requires BOTH sensor conditions to be true before executing an action?",
          "options": [
            "&& (Logical AND)",
            "|| (Logical OR)",
            "! (Logical NOT)"
          ],
          "correctIndex": 0,
          "explanation": "The logical AND operator (&&) evaluates to true only if both expressions on its left and right sides are true.",
          "questions": [
            {
              "question": "Which C++ Boolean operator requires BOTH sensor conditions to be true before executing an action?",
              "options": [
                "&& (Logical AND)",
                "|| (Logical OR)",
                "! (Logical NOT)"
              ],
              "correctIndex": 0,
              "explanation": "The logical AND operator (&&) evaluates to true only if both expressions on its left and right sides are true."
            },
            {
              "question": "If an autonomous robot should halt whenever a bumper switch is pressed OR an ultrasonic rangefinder detects an obstacle, which operator connects the checks?",
              "options": [
                "|| (Logical OR)",
                "&& (Logical AND)",
                "== (Equality)"
              ],
              "correctIndex": 0,
              "explanation": "The logical OR operator (||) evaluates to true if either condition (or both) is true, making it ideal for safety triggers."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_10",
    "title": "Sensor Troubleshooting",
    "summary": "Even experienced lab engineers encounter misbehaving sensors.",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 10,
    "isOptional": false,
    "prerequisites": [
      "l07_09"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s10",
        "title": "Sensor Troubleshooting",
        "type": "story",
        "markdownContent": "Even experienced lab engineers encounter misbehaving sensors. Here is your master troubleshooting guide to conquer the most common sensing traps:\n\n### 1. Swapped TRIG and ECHO Wires:\n- **Symptom**: HC-SR04 always reads `0 cm` or times out completely.\n- **Cause**: Pin 9 is waiting for an echo while Pin 10 is sending triggers.\n- **Fix**: Double-check your jumper wires: Pin 9 connects to TRIG, Pin 10 connects to ECHO.\n\n### 2. The Floating Input Trap:\n- **Symptom**: The LDR light reading jumps erratically between 0 and 1023 when you barely move your hand near the breadboard.\n- **Cause**: Missing the 10kΩ fixed pull-down resistor! Without a reference path to ground, pin A0 acts like an antenna picking up ambient electromagnetic noise.\n- **Fix**: Ensure the 10kΩ resistor firmly connects the LDR junction row to the GND rail.\n\n### 3. Out-of-Range Distances:\n- **Symptom**: Ultrasonic reading suddenly spikes to huge numbers or drops to zero.\n- **Cause**: The HC-SR04 has an effective range between 2 cm and 400 cm. Objects closer than 2 cm reflect sound before the receiver is ready; objects farther than 4 meters produce echoes too weak to detect.\n- **Trap**: Soft, fluffy surfaces (like a wool sweater or plush monster fur) absorb ultrasonic pings instead of bouncing them!\n\n### 4. The Golden Rule of Sensor Debugging:\nWhen code seems broken, **never guess**! Always add `Serial.println()` statements to inspect the raw measurements. Telemetry never lies!",
        "quickCheck": [
          {
            "questionId": "l07_s10_q1",
            "question": "What is the primary symptom of an analog input pin that is 'floating' without a proper pull-down or circuit connection?",
            "options": [
              "Readings fluctuate wildly and unpredictably due to picking up stray ambient electromagnetic noise",
              "The Arduino board immediately powers off with a short-circuit alert",
              "The Serial Monitor stops responding and crashes"
            ],
            "correctIndex": 0,
            "explanation": "A floating pin acts like an antenna, picking up stray electromagnetic radiation from the air and producing erratic, jumpy readings.",
            "warmupExplanation": "Remember Lesson 6: an unanchored pin floats! It needs a resistor to hold it to a known reference voltage."
          },
          {
            "questionId": "l07_s10_q2",
            "question": "What is the very first diagnostic step you should take when a sensor circuit is not triggering an LED properly?",
            "options": [
              "Print the raw sensor readings to the Serial Monitor to observe what values the microcontroller is actually receiving",
              "Replace the Arduino Uno with a brand-new microcontroller",
              "Delete the entire sketch and start over from scratch"
            ],
            "correctIndex": 0,
            "explanation": "Viewing live telemetry in the Serial Monitor instantly reveals whether the sensor is reading correctly, miswired, or missing its threshold.",
            "warmupExplanation": "Always inspect your data first! The Serial Monitor is your diagnostic window into the Arduino's mind."
          }
        ]
      },
      {
        "stepId": "l07_10_s02",
        "title": "Sensor Diagnostic Flowchart",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Robotics Diagnostic Protocol\n\nWhen a sensor circuit fails, never guess or change random wires! Follow this systematic 4-step engineering protocol:\n\n```\n[ Problem: Sensor Output Dead or Erratic ]\n                   │\n                   ▼\n1. CHECK POWER RAILS: Are +5V and GND firmly seated? Does sensor get warm?\n                   │  (If shorted or cold, fix power wiring first!)\n                   ▼\n2. CHECK SIGNAL PINS: Does the pin in code match the breadboard wire socket?\n                   │  (Common bug: plugging wire into A1 while code reads A0!)\n                   ▼\n3. CHECK TELEMETRY: Open Serial Monitor at 9600 baud. Do numbers respond?\n                   │  (If values are stuck at 0 or 1023, check for floating pins!)\n                   ▼\n4. CHECK LOGIC THRESHOLDS: Did you test comparison operators (< vs >)?\n                      (Ensure threshold was calibrated in current room lighting!)\n```"
      },
      {
        "stepId": "l07_10_s03",
        "title": "Sensor Fault Isolation & Bench Repair",
        "type": "physicalTask",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Hands-On: Repairing Faulty Circuits\n\nCommon hardware failure modes on the sensor bench:\n1. **The Floating Input**: A jumper wire slipped out of its breadboard row. The pin floats as an antenna, producing wildly jumpy values.\n2. **The Bridged Short**: Component legs touch across the center divider, pulling the signal rail directly to Ground.\n3. **Reversed Polarities**: Ultrasonic Trig and Echo lines swapped, causing `pulseIn()` to time out and return 0.\n\n**Workbench Task:**\nUse the interactive troubleshooting bench below to diagnose and repair simulated hardware faults!"
      },
      {
        "stepId": "l07_10_s04",
        "title": "Sensor Troubleshooting Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your diagnostic instincts and systematic debugging skills.",
        "interactiveConfig": {
          "question": "What is the most informative first step when a sensor circuit is not responding as expected?",
          "options": [
            "Print the live sensor readings to the Serial Monitor to observe real-time telemetry",
            "Discard the sensor and purchase a replacement module",
            "Randomly swap wires around on the breadboard"
          ],
          "correctIndex": 0,
          "explanation": "Serial telemetry reveals whether the sensor is sending valid data, stuck at 0 or 1023, or fluctuating wildly from a floating wire.",
          "questions": [
            {
              "question": "What is the most informative first step when a sensor circuit is not responding as expected?",
              "options": [
                "Print the live sensor readings to the Serial Monitor to observe real-time telemetry",
                "Discard the sensor and purchase a replacement module",
                "Randomly swap wires around on the breadboard"
              ],
              "correctIndex": 0,
              "explanation": "Serial telemetry reveals whether the sensor is sending valid data, stuck at 0 or 1023, or fluctuating wildly from a floating wire."
            },
            {
              "question": "If an analog sensor pin returns wildly fluctuating values when nothing is touching it, what is the most likely cause?",
              "options": [
                "A loose or disconnected wire leaving the analog pin floating without a ground reference",
                "The serial baud rate was set too high",
                "The Arduino microcontroller has too much memory"
              ],
              "correctIndex": 0,
              "explanation": "High-impedance analog inputs float and pick up ambient electromagnetic interference like an antenna when disconnected from a reference voltage."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l07_11",
    "title": "Sensor Challenge",
    "summary": "Outstanding work, junior roboticist!",
    "tier": "builder",
    "estimatedMinutes": 10,
    "courseId": "lesson_07",
    "sortOrder": 11,
    "isOptional": false,
    "prerequisites": [
      "l07_10"
    ],
    "componentIds": [
      "comp_uno",
      "comp_01",
      "comp_19"
    ],
    "steps": [
      {
        "stepId": "l07_s11",
        "title": "Sensor Challenge",
        "type": "quizCheckpoint",
        "markdownContent": "Outstanding work, junior roboticist! You have bridged the gap between pure electrical circuits and intelligent perception of the real world:\n\n- You differentiated discrete **Digital sensors** from continuous **Analog sensors**.\n- You harnessed acoustic echolocation with the **HC-SR04 Ultrasonic Distance Sensor**.\n- You wired a photoresistor **voltage divider** to give your monster the gift of light perception.\n- You streamed live data streams over **Serial telemetry**.\n- You calibrated **decision thresholds** to transform raw measurements into responsive behaviors.\n- You combined multiple sensor inputs using **boolean logic** (`&&` and `||`).\n- You mastered the art of diagnosing **swapped pins**, **floating inputs**, and **acoustic absorption**.\n\nDemonstrate your complete sensor mastery in the Comprehensive Knowledge Check below to earn your XP and level up!",
        "quickCheck": [
          {
            "questionId": "l07_s11_q1",
            "question": "Which type of sensor would you choose to measure the exact distance in centimeters between a monster robot and a wall?",
            "options": [
              "An ultrasonic distance sensor (HC-SR04)",
              "A digital momentary push button",
              "A single-color red LED"
            ],
            "correctIndex": 0,
            "explanation": "The ultrasonic distance sensor measures precise transit times of sound echoes to calculate distance in centimeters.",
            "warmupExplanation": "Buttons only tell you if you bumped a wall, but ultrasonic echolocation tells you how many centimeters away the wall is before you hit it!"
          },
          {
            "questionId": "l07_s11_q2",
            "question": "How does an Arduino convert real-world analog voltage into a digital number that software can process?",
            "options": [
              "Using its on-chip Analog-to-Digital Converter (ADC)",
              "Using a mechanical relay switch",
              "Using a step-up power transformer"
            ],
            "correctIndex": 0,
            "explanation": "The Arduino ATmega328P uses a 10-bit Analog-to-Digital Converter (ADC) to translate continuous analog voltages into integer values from 0 to 1023.",
            "warmupExplanation": "The ADC is the bridge between the analog physical world and digital computer code!"
          }
        ],
        "interactiveConfig": {
          "question": "What is the primary difference between a digital sensor and an analog sensor?",
          "options": [
            "Digital sensors produce binary states (HIGH/LOW), while analog sensors provide continuous changing measurements",
            "Digital sensors work without power, while analog sensors require high-voltage wall outlets",
            "Digital sensors can only detect sound, while analog sensors only detect light"
          ],
          "correctIndex": 0,
          "explanation": "Correct: Digital sensors produce binary states (HIGH/LOW), while analog sensors provide continuous changing measurements across a spectrum.",
          "questions": [
            {
              "question": "What is the primary difference between a digital sensor and an analog sensor?",
              "options": [
                "Digital sensors produce binary states (HIGH/LOW), while analog sensors provide continuous changing measurements",
                "Digital sensors work without power, while analog sensors require high-voltage wall outlets",
                "Digital sensors can only detect sound, while analog sensors only detect light"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Digital sensors produce binary states (HIGH/LOW), while analog sensors provide continuous changing measurements across a spectrum."
            },
            {
              "question": "What integer range does `analogRead()` return when sampling an analog pin on the Arduino Uno?",
              "options": [
                "0 to 1023 (10-bit resolution)",
                "0 to 255 (8-bit resolution)",
                "0 to 100 (percentage)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 0 to 1023 (10-bit resolution). The Uno ADC quantizes 0V to 5V into 1024 discrete integer levels."
            },
            {
              "question": "How does an HC-SR04 ultrasonic sensor determine the distance to an obstacle?",
              "options": [
                "By timing how long high-frequency sound chirps take to echo back from the object",
                "By measuring the ambient magnetic field distortion",
                "By detecting heat radiated by the obstacle"
              ],
              "correctIndex": 0,
              "explanation": "Correct: By timing how long high-frequency sound chirps take to echo back from the object (echolocation)."
            },
            {
              "question": "Why does the ultrasonic distance calculation formula divide the measured echo duration by 2?",
              "options": [
                "Because the sound wave makes a round trip out to the obstacle and back to the receiver",
                "Because the Arduino operates with two timers",
                "Because sound moves twice as fast backwards"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Because the sound wave makes a round trip out to the obstacle and back to the receiver, doubling the travel distance."
            },
            {
              "question": "What happens to the electrical resistance of an LDR (photoresistor) when bright light shines on its surface?",
              "options": [
                "Its resistance decreases, allowing more electric current to flow",
                "Its resistance increases to infinity, stopping all current",
                "Its resistance never changes under any lighting condition"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Its resistance decreases, allowing more electric current to flow through the sensor."
            },
            {
              "question": "What is a 'threshold' in sensor programming?",
              "options": [
                "A defined boundary value used in decision statements to trigger specific actions",
                "The physical length of a breadboard jumper wire",
                "The maximum temperature of a soldering iron"
              ],
              "correctIndex": 0,
              "explanation": "Correct: A defined boundary value used in decision statements to trigger specific actions."
            },
            {
              "question": "Which C++ logical operator requires BOTH conditions to evaluate to true for an action to execute?",
              "options": [
                "&& (Logical AND)",
                "|| (Logical OR)",
                "!= (Not Equal)"
              ],
              "correctIndex": 0,
              "explanation": "Correct: && (Logical AND). Both sensor conditions must be met simultaneously."
            },
            {
              "question": "What tool in the Arduino IDE should you open first to inspect real-time sensor measurements?",
              "options": [
                "Serial Monitor (at matching baud rate)",
                "Library Manager",
                "Board Firmware Burner"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Serial Monitor (at matching baud rate). Live telemetry lets you observe exact sensor values for debugging and calibration."
            }
          ]
        }
      },
      {
        "stepId": "l07_11_s02",
        "title": "Autonomous Sentry Robot Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Grand Challenge: Sentry Monster System\n\nCongratulations on reaching the Course 7 Capstone Challenge! In this project, you combine all your sensing skills into a unified Autonomous Sentry Monster:\n\n```\n[ LDR Ambient Light ] ──► Pin A0 (Analog ADC) ──┐\n                                                │\n[ Ultrasonic Echolocation ] ──► Echo Pin 10 ────┼──► [ Arduino Uno CPU ]\n                                                │    (Threshold Logic & Fusion)\n[ Trigger Pulse ] ◄────────── Trig Pin 9 ───────┘        │\n                                                         ▼\n                                             [ Alert Actuators ]\n                                             - Standby Green LED (Pin 12)\n                                             - Alert Red LED (Pin 13)\n                                             - Piezo Buzzer (Pin 11)\n```\n\nSystem Requirements:\n1. Continuously measure ambient light and target distance.\n2. Filter raw ADC jitter with moving average software smoothing.\n3. Apply calibrated thresholds: if darkness is detected AND an obstacle is within 20 cm, trigger the multi-tone alarm!"
      },
      {
        "stepId": "l07_11_s03",
        "title": "Multi-Sensor Noise Filtering & Calibration",
        "type": "codeExperiment",
        "interactiveWidgetType": "analogReadNoiseFilter",
        "markdownContent": "### Final Lab: Calibration and Signal Conditioning\n\nBefore uploading your final firmware, calibrate your sensors:\n1. Record ambient room light on A0 (e.g. 680 counts).\n2. Measure shadow reading with your hand over the LDR (e.g. 210 counts).\n3. Compute the decision midpoint: `(680 + 210) / 2 = 445`.\n4. Run the noise filter workbench below to verify that sensor noise remains below your hysteresis threshold margin!"
      },
      {
        "stepId": "l07_11_s04",
        "title": "Master Sensor Challenge Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Prove your complete mastery of sensors, ADC math, and perception-action robotics to claim your certification XP!",
        "interactiveConfig": {
          "question": "How does the HC-SR04 distance sensor calculate distance to an obstacle?",
          "options": [
            "It transmits ultrasonic sound pulses and measures the echo return time",
            "It emits an infrared laser beam to measure photon speed",
            "It senses the magnetic attraction of nearby metal objects"
          ],
          "correctIndex": 0,
          "explanation": "The HC-SR04 emits 40 kHz ultrasonic acoustic waves and measures the microsecond travel duration until the echo reflects back to the receiver cylinder.",
          "questions": [
            {
              "question": "How does the HC-SR04 distance sensor calculate distance to an obstacle?",
              "options": [
                "It transmits ultrasonic sound pulses and measures the echo return time",
                "It emits an infrared laser beam to measure photon speed",
                "It senses the magnetic attraction of nearby metal objects"
              ],
              "correctIndex": 0,
              "explanation": "The HC-SR04 emits 40 kHz ultrasonic acoustic waves and measures the microsecond travel duration until the echo reflects back to the receiver cylinder."
            },
            {
              "question": "What is the primary role of a voltage divider when interfacing an LDR with an Arduino analog pin?",
              "options": [
                "It converts the LDR's varying resistance into a measurable variable voltage between 0V and 5V",
                "It amplifies sensor voltage up to 120 volts AC",
                "It prevents the Arduino from compiling incorrect code"
              ],
              "correctIndex": 0,
              "explanation": "Arduino analog pins only measure voltage. A voltage divider converts shifting resistance into a proportional voltage signal."
            },
            {
              "question": "Which C++ control structure allows your robot to execute different actions depending on whether sensor data exceeds a threshold?",
              "options": [
                "if / else conditional statements",
                "while(true) infinite loops",
                "#include <Wire.h> preprocessor directives"
              ],
              "correctIndex": 0,
              "explanation": "if / else conditional branches allow firmware to compare telemetry against thresholds and execute distinct action paths."
            }
          ]
        }
      }
    ],
    "xpReward": 15
  },
  {
    "id": "l08_01",
    "title": "Why Do Devices Need to Talk?",
    "summary": "In earlier missions, you connected one component per pin: an LED to Pin 9, a pushbutton to Pin 2, and a potentiometer to A0.",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 1,
    "isOptional": false,
    "prerequisites": [
      "l07_11"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s01",
        "title": "Why Do Devices Need to Talk?",
        "type": "story",
        "markdownContent": "### The Pin Starvation Bottleneck\nIn earlier missions, you connected one component per pin: an LED to Pin 9, a pushbutton to Pin 2, and a potentiometer to A0. But imagine engineering an advanced exploration robot with a character display, an environmental temperature sensor, a precision real-time clock, a 3-axis accelerometer, and a compass!\n\nIf every peripheral required 4 to 8 dedicated pins, the Arduino Uno (which has only 14 digital and 6 analog pins) would run out of pins almost immediately. A standard 16x2 character display wired directly in parallel mode requires up to 6 to 10 pins alone!\n\n```\nIndividual Wiring: 5 Peripherals × 4 Pins = 20 Pins (Arduino Exhausted!)\nShared I2C Bus:    5 Peripherals over 2 Pins = 2 Pins (18 Pins Free!)\n```\n\n### The Communication Solution: A Shared Highway\nInstead of running private point-to-point wires to every device, smart electronics share a single two-lane communication highway called a **bus**.\n\nThink of a classroom hallway: students don't build separate private tunnels to every desk. Instead, everyone steps into the same hallway, and messages are addressed to specific individuals. In robotics, devices \"talk\" by sending serialized digital packets across shared wires.\n\n### Smart Peripherals vs. Raw Voltages\nUnlike simple analog sensors that merely output a variable voltage between 0V and 5V, smart digital devices contain their own internal microchips. They measure physical phenomena, process calculations internally, and transmit structured data packets—including text strings, time stamps, degrees Celsius, and 3D coordinates!",
        "quickCheck": [
          {
            "questionId": "q_l08_s01_1",
            "question": "Why can an Arduino Uno run out of pins quickly if every sensor and display uses dedicated GPIO lines?",
            "options": [
              "The Arduino Uno has a limited number of GPIO pins (14 digital and 6 analog pins), so point-to-point connections exhaust available pins rapidly.",
              "Microcontrollers can only electrically drive a single peripheral before shutting down.",
              "Input pins lose their conductivity after three jumper wires are attached."
            ],
            "correctIndex": 0,
            "explanation": "The Uno has only 14 digital and 6 analog I/O pins. A robot needing displays, clocks, and sensors would quickly exhaust all pins without a shared communication bus.",
            "warmupExplanation": "Think back to the Uno hardware tour from Lesson 1: the microcontroller board has a limited set of pin headers for external circuits."
          },
          {
            "questionId": "q_l08_s01_2",
            "question": "How does a smart digital peripheral differ from a simple analog sensor like a potentiometer?",
            "options": [
              "A smart digital peripheral has an onboard microchip that formats and transmits structured multi-byte data packets rather than outputting a raw analog voltage.",
              "A smart digital peripheral operates without ground reference or electrical power.",
              "A smart digital peripheral only functions when connected directly to a computer monitor."
            ],
            "correctIndex": 0,
            "explanation": "Smart digital peripherals contain their own integrated circuits that calculate measurements and communicate structured information over digital protocols.",
            "warmupExplanation": "In Lesson 6 and Lesson 7, simple components like potentiometers and LEDs handled variable voltages directly, whereas smart devices exchange digital data."
          }
        ]
      },
      {
        "stepId": "l08_01_s02",
        "title": "The Pin Starvation Bottleneck & Bus Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Point-to-Point Wiring Bottleneck\n\nAn Arduino Uno has 14 digital pins and 6 analog pins. In complex robotics builds, pins run out quickly:\n- 16x2 Parallel LCD: Requires 6 to 10 pins!\n- 4x4 Matrix Keypad: Requires 8 pins!\n- 3 Distance Sensors: Require 6 pins!\n- **Total: Over 20 pins!** The Uno is completely starved of I/O lines.\n\n```\nPOINT-TO-POINT TOPOLOGY (Dozens of messy wires):\n[ Arduino ] ═══════════════════════════════════════════► [ LCD Display (6-10 Pins) ]\n[ Arduino ] ════════════════════════════► [ RTC Clock (4 Pins) ]\n[ Arduino ] ════════════════════► [ Pressure Sensor (4 Pins) ]\n\nBUS TOPOLOGY (Only 2 shared signal wires for ALL devices!):\n[ Arduino ] ──┬── SDA (Serial Data)  ───────────┬──────────────┬────────►\n              └── SCL (Serial Clock) ───────────┼──────────────┼────────►\n                                                ▼              ▼\n                                           [ I2C LCD ]    [ I2C Sensor ]\n```\n\nA **bus** is a shared electrical highway where dozens of devices connect to the exact same two wires without interfering with each other!"
      },
      {
        "stepId": "l08_01_s03",
        "title": "Point-to-Point vs Bus Topology Experiment",
        "type": "physicalTask",
        "interactiveWidgetType": "i2cPullupChecker",
        "markdownContent": "### The Power of Bus Architecture\n\nBy switching to I2C (Inter-Integrated Circuit), a 16x2 LCD display goes from needing 16 header pins down to just **4 wires**:\n1. **VCC**: +5V Power Rail\n2. **GND**: 0V Ground Return\n3. **SDA**: Serial Data (carries information bytes)\n4. **SCL**: Serial Clock (synchronizes timing)\n\nAnd the best part? You can attach 10 more sensors to those exact same SDA and SCL pins without using up a single extra pin on your Arduino!\n\n**Laboratory Task:**\nInspect the bus topology and pull-up resistor architecture in the interactive simulator below."
      },
      {
        "stepId": "l08_01_s04",
        "title": "Device Communication Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of communication buses and pin starvation solutions.",
        "interactiveConfig": {
          "question": "What major problem does a shared communication bus like I2C solve in robotics?",
          "options": [
            "It prevents pin starvation by allowing many devices to share the exact same two signal wires",
            "It increases battery voltage so motors run faster",
            "It replaces the need for power and ground wires"
          ],
          "correctIndex": 0,
          "explanation": "A communication bus allows multiple smart peripherals to share two common wires (SDA and SCL) instead of requiring dedicated pins for each component.",
          "questions": [
            {
              "question": "What major problem does a shared communication bus like I2C solve in robotics?",
              "options": [
                "It prevents pin starvation by allowing many devices to share the exact same two signal wires",
                "It increases battery voltage so motors run faster",
                "It replaces the need for power and ground wires"
              ],
              "correctIndex": 0,
              "explanation": "A communication bus allows multiple smart peripherals to share two common wires (SDA and SCL) instead of requiring dedicated pins for each component."
            },
            {
              "question": "How do multiple devices share the same communication bus without confusing the microcontroller?",
              "options": [
                "Each device has a unique digital address and only responds when addressed by the controller",
                "Only one peripheral is physically plugged in at any given moment",
                "Devices transmit random radio signals"
              ],
              "correctIndex": 0,
              "explanation": "Every I2C device listens for its unique 7-bit address. When the controller broadcasts an address, only the matching device replies."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_02",
    "title": "Meet I2C",
    "summary": "I2C stands for Inter-Integrated Circuit (pronounced \"Eye-Squared-See\" or \"I-Two-C\").",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 2,
    "isOptional": false,
    "prerequisites": [
      "l08_01"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s02",
        "title": "Meet I2C",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cPullupChecker",
        "markdownContent": "### What is I2C?\n**I2C** stands for **Inter-Integrated Circuit** (pronounced *\"Eye-Squared-See\"* or *\"I-Two-C\"*). Invented by Philips Semiconductor, it is a synchronous, multi-target, bidirectional serial communication bus.\n\nThe genius of I2C: it coordinates communication between up to **127 unique peripheral devices** over **just two shared wires**!\n\n```\nArduino Uno (Controller)\n       │           │\n      SDA         SCL\n       │           │\n   ┌───┴───┐   ┌───┴───┐   ┌───┴───┐\n   │  LCD  │   │ Clock │   │ Sensor│\n   └───────┘   └───────┘   └───────┘\n```\n\n### The Two Roles on the Bus\n1. **Controller (Master):** The Arduino Uno is the manager of the network. It initiates every communication session, drives the clock pulses, and commands target devices to send or receive data.\n2. **Target (Peripheral / Slave):** The connected modules (such as LCD backpacks, sensors, or real-time clocks). They listen quietly on the bus and only respond when their unique address is called.\n\n### Open-Drain & Pull-Up Resistors\nHow can dozens of devices share the exact same wires without short-circuiting each other? I2C uses an **open-drain** architecture:\n- Both communication lines are passively held at +5V (**HIGH**) by **pull-up resistors** (typically 4.7kΩ).\n- Connected devices only ever pull the line to Ground (0V / **LOW**) using internal transistors. They never force a 5V HIGH onto the wire.\n- Because devices only pull LOW and never drive HIGH, two devices talking at once cannot create a direct short circuit between power and ground!\n\nTest the interactive pull-up resistor simulator below to see why I2C lines cannot float and how proper pull-up values ensure crisp digital signals!",
        "quickCheck": [
          {
            "questionId": "q_l08_s02_1",
            "question": "What is the primary role of the Arduino Uno when acting as the I2C Controller (Master)?",
            "options": [
              "It manages the shared bus, generates clock pulses, and initiates all communication sessions with peripheral devices.",
              "It cuts power to the circuit whenever more than two peripherals are connected.",
              "It converts serial signals into high-frequency radio waves."
            ],
            "correctIndex": 0,
            "explanation": "In an I2C network, the Controller initiates all transactions and provides the synchronizing clock pulse train for target peripheral devices.",
            "warmupExplanation": "Recall from Lesson 1 that the microcontroller acts as the central brain directing and coordinating peripherals in your robot."
          },
          {
            "questionId": "q_l08_s02_2",
            "question": "Why are pull-up resistors required on the shared I2C communication lines?",
            "options": [
              "They hold the open-drain lines at a stable HIGH voltage when idle so connected devices can pull the line LOW without creating a dead short circuit.",
              "They amplify 5V signals up to 24V for long-distance industrial cables.",
              "They slow down electrical current to keep wires from overheating."
            ],
            "correctIndex": 0,
            "explanation": "I2C uses open-drain drivers. External pull-up resistors maintain lines at HIGH (5V) by default, allowing devices to safely pull lines to GND (LOW) to communicate.",
            "warmupExplanation": "In Lesson 5, you learned that pull-up resistors keep inputs at a defined voltage rather than leaving lines floating in an undefined state."
          }
        ]
      },
      {
        "stepId": "l08_02_s02",
        "title": "Controller-Target & Open-Drain Bus Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cPullupChecker",
        "markdownContent": "### Controller/Target Roles and Open-Drain Lines\n\nI2C works like a master conductor directing an orchestra:\n- **Controller (Master)**: The Arduino Uno. It generates the clock signal (SCL) and initiates all conversations.\n- **Targets (Slaves)**: The peripherals (LCD backpack, barometer, clock). They listen quietly until their address is called.\n\n```\n           +5V Power Rail\n                 │\n           ┌─────┴─────┐\n          ┌┴┐         ┌┴┐\n          │ │4.7kΩ    │ │4.7kΩ  Pull-up Resistors\n          └┬┘         └┬┘\n           │           │\nSDA ───────┴───────────┼─────────── [ Open-Drain Data Highway ]\n                       │\nSCL ───────────────────┴─────────── [ Open-Drain Clock Highway ]\n     │                   │\n  [ Arduino ]         [ I2C LCD ]\n (Controller)          (Target)\n```\n\n### Why Open-Drain Architecture?\nIf multiple devices drove wires HIGH (+5V) and LOW (0V) with push-pull transistors, two devices outputting opposite levels at the same time would create a direct short circuit!\n\nIn I2C, devices **only pull lines LOW** to Ground. When no device pulls a line down, **pull-up resistors (typically 4.7 kΩ)** pull the lines gently up to +5V."
      },
      {
        "stepId": "l08_02_s03",
        "title": "The Open-Drain Pull-Up Resistor Lab",
        "type": "physicalTask",
        "interactiveWidgetType": "i2cPullupChecker",
        "markdownContent": "### Exploring Pull-Up Resistor Physics\n\nIn the interactive lab below, test three different pull-up scenarios:\n1. **Proper 4.7 kΩ Pull-Ups**: Lines rise rapidly to 5V, producing sharp square wave clock pulses.\n2. **Missing Pull-Ups**: The lines cannot return to HIGH; the bus stays clamped at 0V and communication freezes!\n3. **Weak Pull-Ups (100 kΩ)**: Rise times are sluggish, rounding off digital square waves and causing communication corruption at high speeds.\n\n**Laboratory Task:**\nSwitch between resistor modes in the simulator to observe how pull-up resistance shapes digital waveforms!"
      },
      {
        "stepId": "l08_02_s04",
        "title": "I2C Architecture Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your grasp of I2C roles and open-drain pull-up circuitry.",
        "interactiveConfig": {
          "question": "Why are I2C signal lines designed as 'open-drain' with pull-up resistors instead of push-pull outputs?",
          "options": [
            "To prevent short circuits when multiple devices share the bus lines simultaneously",
            "Because +5V is too dangerous for microcontrollers to handle",
            "Because I2C communication only operates using negative voltages"
          ],
          "correctIndex": 0,
          "explanation": "Open-drain outputs can only pull lines to Ground, never to +5V. This allows multiple devices to connect in parallel without risking a short circuit if two talk at once.",
          "questions": [
            {
              "question": "Why are I2C signal lines designed as 'open-drain' with pull-up resistors instead of push-pull outputs?",
              "options": [
                "To prevent short circuits when multiple devices share the bus lines simultaneously",
                "Because +5V is too dangerous for microcontrollers to handle",
                "Because I2C communication only operates using negative voltages"
              ],
              "correctIndex": 0,
              "explanation": "Open-drain outputs can only pull lines to Ground, never to +5V. This allows multiple devices to connect in parallel without risking a short circuit if two talk at once."
            },
            {
              "question": "What happens on the I2C bus if pull-up resistors are completely missing from both SDA and SCL?",
              "options": [
                "The bus lines remain at 0V and cannot return HIGH, completely halting communication",
                "Communication speeds up to 100 megabits per second",
                "The Arduino Uno flash memory is permanently erased"
              ],
              "correctIndex": 0,
              "explanation": "Without pull-up resistors, open-drain lines have no mechanism to pull the voltage back up to +5V, leaving the lines floating or stuck at 0V."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_03",
    "title": "SDA and SCL",
    "summary": "I2C communication relies on two dedicated electrical pathways:",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 3,
    "isOptional": false,
    "prerequisites": [
      "l08_02"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s03",
        "title": "SDA and SCL",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cBusTimingDiagram",
        "markdownContent": "### The Two Signal Lines\nI2C communication relies on two dedicated electrical pathways:\n\n1. **SDA (Serial Data):** The information highway. Binary bits of data (1s and 0s) travel back and forth over this single bidirectional wire.\n2. **SCL (Serial Clock):** The heartbeat rhythm. Generated exclusively by the Arduino Uno Controller, this clock pulse train synchronizes the exact moment each bit is transmitted and read.\n\n### Why Synchronization Matters\nSerial transmission requires a shared clock rhythm. If a sender transmits a stream of high and low voltages without a clock, the receiver cannot tell whether a long high pulse means three '1' bits or four '1' bits. With SCL:\n- When SCL is **LOW**, the transmitting device changes the voltage on SDA.\n- When SCL transitions to **HIGH**, the receiving device samples and locks in the bit on SDA!\n\n```\nSCL:  ──┐   ┌───┐   ┌───┐   ┌───┐   ┌───\n        └───┘   └───┘   └───┘   └───┘\nSDA:  ──────[ Bit 7 ]───[ Bit 6 ]───[ Bit 5 ]───\n            ↑ Sample    ↑ Sample    ↑ Sample\n```\n\n### Arduino Uno Hardware Pins\nOn the Arduino Uno R3, hardware I2C lines are routed to:\n- **SDA:** Analog Pin **A4** (and the top header pin marked SDA next to AREF).\n- **SCL:** Analog Pin **A5** (and the top header pin marked SCL).\n\n> **The 4-Wire Reality:** Even though I2C is called a \"2-wire serial bus,\" every peripheral still needs **+5V** for power and **GND** for an electrical reference return path. You will connect 4 wires per device: VCC, GND, SDA, and SCL.\n\nExplore the interactive bus timing diagram below to step through clock edges, address bits, and data transitions!",
        "quickCheck": [
          {
            "questionId": "q_l08_s03_1",
            "question": "Which dedicated pins on an Arduino Uno R3 are connected to the hardware I2C bus?",
            "options": [
              "Analog Pin A4 (SDA) and Analog Pin A5 (SCL)",
              "Digital Pin 0 (RX) and Digital Pin 1 (TX)",
              "Digital Pin 10 (SS) and Digital Pin 13 (SCK)"
            ],
            "correctIndex": 0,
            "explanation": "On the Arduino Uno, the ATmega328P Two-Wire Interface (TWI) routes the Serial Data line (SDA) to pin A4 and the Serial Clock line (SCL) to pin A5.",
            "warmupExplanation": "Check the Uno pinout: while A4 and A5 can read analog signals, they double as the hardware I2C bus pins."
          },
          {
            "questionId": "q_l08_s03_2",
            "question": "Why is a common Ground (GND) connection mandatory when connecting an I2C peripheral to an Arduino Uno?",
            "options": [
              "GND establishes a shared zero-volt electrical reference so both devices interpret HIGH and LOW voltage levels identically.",
              "The ground wire is only needed if the devices use different color jumper wires.",
              "GND prevents the Arduino clock speed from drifting."
            ],
            "correctIndex": 0,
            "explanation": "Voltage is a difference in electrical potential. Without a common ground reference between devices, digital signals cannot be accurately measured.",
            "warmupExplanation": "Remember from Lesson 1 and Lesson 6: every electrical circuit requires a complete return path to GND."
          }
        ]
      },
      {
        "stepId": "l08_03_s02",
        "title": "SDA & SCL Signal Waveforms & Timing",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cBusTimingDiagram",
        "markdownContent": "### The Clock and Data Dance\n\nI2C relies on two synchronized lines:\n1. **SDA (Serial Data)**: Carries binary bits (0 or 1). On an Arduino Uno R3, SDA is mapped to **Analog Pin A4** (and the dedicated SDA header pin above AREF).\n2. **SCL (Serial Clock)**: Synchronizes data sampling. On an Arduino Uno R3, SCL is mapped to **Analog Pin A5** (and the dedicated SCL header pin).\n\n```\n        START       BIT 7        BIT 6                 ACK        STOP\nSCL ────┐       ┌─────┐      ┌─────┐      ┌─────┐       ┌─────┐    ┌────────\n        └───────┘     └──────┘     └──────┘     └───────┘     └────┘\nSDA ──┐            ┌───────────────┐                             ┌──────────\n      └────────────┘               └─────────────────────────────┘\n      (SDA drops                  (Data bit sampled              (SDA rises\n       while SCL is HIGH)          when SCL is HIGH)              while SCL HIGH)\n```\n\n- **Rule of I2C**: Data on SDA may only change while SCL is **LOW**. Whenever SCL is **HIGH**, the data bit is locked and being read by the receiver!\n- **START Condition**: SDA transitions from HIGH to LOW while SCL is held HIGH.\n- **STOP Condition**: SDA transitions from LOW to HIGH while SCL is held HIGH."
      },
      {
        "stepId": "l08_03_s03",
        "title": "Stepping Through an I2C Frame Transaction",
        "type": "codeExperiment",
        "interactiveWidgetType": "i2cBusTimingDiagram",
        "markdownContent": "### An I2C Message Byte by Byte\n\nEvery standard I2C transmission contains:\n1. **START condition**: Alerts every device on the bus that a message is beginning.\n2. **7-Bit Target Address**: Broadcasts who the message is for (e.g. `0x27`).\n3. **Read/Write Bit**: `0` for Write (Arduino sends data), `1` for Read (Arduino requests data).\n4. **ACK (Acknowledge) Bit**: The target pulls SDA LOW to confirm receipt.\n5. **Data Bytes**: 8-bit payloads (commands, text characters, or sensor registers).\n6. **STOP condition**: Releases the bus back to IDLE.\n\n**Interactive Oscilloscope Task:**\nUse the timing diagram simulator below to step through clock cycles and watch data bits and ACK pulses in real time!"
      },
      {
        "stepId": "l08_03_s04",
        "title": "SDA & SCL Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of I2C clock timing, data framing, and pin assignments.",
        "interactiveConfig": {
          "question": "Which pins on an Arduino Uno R3 are connected to the hardware I2C bus lines?",
          "options": [
            "A4 (SDA) and A5 (SCL)",
            "D0 (RX) and D1 (TX)",
            "D10 (SS) and D13 (SCK)"
          ],
          "correctIndex": 0,
          "explanation": "On the Arduino Uno R3, the ATmega328P hardware Two-Wire Interface (TWI/I2C) is wired internally to analog pins A4 (SDA) and A5 (SCL).",
          "questions": [
            {
              "question": "Which pins on an Arduino Uno R3 are connected to the hardware I2C bus lines?",
              "options": [
                "A4 (SDA) and A5 (SCL)",
                "D0 (RX) and D1 (TX)",
                "D10 (SS) and D13 (SCK)"
              ],
              "correctIndex": 0,
              "explanation": "On the Arduino Uno R3, the ATmega328P hardware Two-Wire Interface (TWI/I2C) is wired internally to analog pins A4 (SDA) and A5 (SCL)."
            },
            {
              "question": "In the I2C protocol, what signal transition signals a START condition?",
              "options": [
                "SDA transitions from HIGH to LOW while SCL remains HIGH",
                "Both SDA and SCL stay LOW for 5 seconds",
                "SCL pulses 10 times with SDA disconnected"
              ],
              "correctIndex": 0,
              "explanation": "A START condition is defined specifically by SDA falling from HIGH to LOW while SCL is held HIGH."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_04",
    "title": "I2C Addresses",
    "summary": "When multiple devices share the exact same SDA and SCL wires, how does the Arduino speak to a display without confusing a sensor?",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 4,
    "isOptional": false,
    "prerequisites": [
      "l08_03"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s04",
        "title": "I2C Addresses",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cAddressScanner",
        "markdownContent": "### The Postal Address System\nWhen multiple devices share the exact same SDA and SCL wires, how does the Arduino speak to a display without confusing a sensor? Every peripheral has a unique **7-bit hardware address**!\n\nJust like houses on a street have distinct numbers, each I2C device listens for its specific number:\n1. The Arduino sends a **START condition** (pulling SDA LOW while SCL is HIGH).\n2. The Arduino transmits a 7-bit address followed by a Read/Write bit (0 = Write, 1 = Read).\n3. Every device on the bus hears the address, but only the matching device replies with an **ACK (Acknowledge)** pulse by pulling SDA LOW on clock pulse 9!\n4. Non-matching devices ignore all subsequent data bytes until the next transmission.\n5. The Arduino sends a **STOP condition** (releasing SDA HIGH while SCL is HIGH) to free the bus.\n\n### Hexadecimal Addresses (`0x`)\nI2C addresses are represented in **hexadecimal** (base-16) notation prefixed by `0x`:\n- **16x2 LCD Backpack (PCF8574):** Typically `0x27` (decimal 39) or `0x3F` (decimal 63).\n- **DS3231 Real Time Clock:** `0x68` (decimal 104).\n- **BMP280 Barometric Pressure Sensor:** `0x76` or `0x77`.\n\nLaunch the simulated address scanner below to ping 7-bit addresses and discover responsive hardware devices live!",
        "quickCheck": [
          {
            "questionId": "q_l08_s04_1",
            "question": "How do multiple devices share the same SDA data wire without corrupting each other's messages?",
            "options": [
              "Every device has a unique 7-bit hardware address and only listens or responds when the Controller calls its specific address.",
              "Devices take turns based on how far they are plugged into the breadboard.",
              "Only one peripheral device can be physically plugged into an Arduino at a time."
            ],
            "correctIndex": 0,
            "explanation": "Each I2C peripheral listens for its unique 7-bit address frame; non-addressed devices ignore transmissions on the bus.",
            "warmupExplanation": "Think of roll call in school: only the person whose name is called answers, while everyone else remains quiet."
          },
          {
            "questionId": "q_l08_s04_2",
            "question": "What number system is conventionally used in Arduino sketches to write I2C addresses like 0x27 or 0x68?",
            "options": [
              "Hexadecimal (base-16), designated by the '0x' prefix.",
              "Octal (base-8), indicated by trailing exclamation marks.",
              "Roman numerals enclosed in parentheses."
            ],
            "correctIndex": 0,
            "explanation": "I2C addresses are standardly documented and written in hexadecimal notation prefixed with '0x' (such as 0x27 for 39 in decimal).",
            "warmupExplanation": "In Coding Foundations and Lesson 3, hexadecimal literals were introduced with the '0x' prefix."
          }
        ]
      },
      {
        "stepId": "l08_04_s02",
        "title": "7-Bit Address Space & Hexadecimal Addressing",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cAddressScanner",
        "markdownContent": "### The 7-Bit Address Space\n\nHow do multiple devices share the same two wires without talking over each other? Every device has a unique digital **address**:\n\n```\n7-Bit Address Range: 0x00 to 0x7F (0 to 127 in decimal)\n(Reserved addresses: 0x00..0x07 and 0x78..0x7F are reserved by the standard)\nAvailable peripheral addresses: 0x08 through 0x77 (112 possible devices!)\n```\n\n### Hexadecimal (`0x`) Notation\nEngineers write I2C addresses in **hexadecimal** (base 16):\n- `0x27` = Standard 16x2 I2C Character LCD backpack\n- `0x3F` = Alternate 16x2 I2C Character LCD backpack\n- `0x68` = DS3231 Real-Time Clock or MPU-6050 Accelerometer\n- `0x3C` = 0.96-inch OLED Graphic Display\n- `0x76` / `0x77` = BMP280 Barometric Pressure Sensor\n\nWhen the Arduino sends `0x27`, only the LCD backpack responds with an ACK pulse. All other devices remain silent!"
      },
      {
        "stepId": "l08_04_s03",
        "title": "Scanning the Bus with I2C Address Scanner",
        "type": "codeExperiment",
        "interactiveWidgetType": "i2cAddressScanner",
        "markdownContent": "### How the I2C Scanner Sketch Works\n\nBefore writing code for an unknown I2C breakout board, run an **I2C Scanner sketch**.\n\nThe scanner sends a probe packet to every address from 1 to 127 using the `Wire` library:\n\n```cpp\n#include <Wire.h>\n\nvoid setup() {\n  Wire.begin();\n  Serial.begin(9600);\n  Serial.println(\"\\nI2C Scanner Probing Bus...\");\n}\n\nvoid loop() {\n  byte error, address;\n  int nDevices = 0;\n\n  for (address = 1; address < 127; address++) {\n    Wire.beginTransmission(address);\n    error = Wire.endTransmission();\n\n    if (error == 0) {\n      Serial.print(\"I2C device found at address 0x\");\n      if (address < 16) Serial.print(\"0\");\n      Serial.print(address, HEX);\n      Serial.println(\"  !\");\n      nDevices++;\n    }\n  }\n  delay(5000);\n}\n```\n\n**Laboratory Task:**\nRun the interactive I2C address scanner simulator below to discover connected peripherals!"
      },
      {
        "stepId": "l08_04_s04",
        "title": "I2C Addresses Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your grasp of I2C addresses and bus scanning methodology.",
        "interactiveConfig": {
          "question": "What is the standard address length used by most consumer I2C peripherals?",
          "options": [
            "7 bits (allowing up to 128 unique addresses)",
            "32 bits",
            "1 bit"
          ],
          "correctIndex": 0,
          "explanation": "Standard I2C uses 7-bit addresses (values 0x00 through 0x7F), allowing up to 128 address slots on a single bus.",
          "questions": [
            {
              "question": "What is the standard address length used by most consumer I2C peripherals?",
              "options": [
                "7 bits (allowing up to 128 unique addresses)",
                "32 bits",
                "1 bit"
              ],
              "correctIndex": 0,
              "explanation": "Standard I2C uses 7-bit addresses (values 0x00 through 0x7F), allowing up to 128 address slots on a single bus."
            },
            {
              "question": "How does an I2C scanner sketch determine whether a peripheral exists at a specific address?",
              "options": [
                "It sends a start transmission to that address and checks if the device returns an ACK signal (code 0)",
                "It reads the serial barcode printed on the module chip",
                "It measures the temperature of the microcontroller"
              ],
              "correctIndex": 0,
              "explanation": "Wire.endTransmission() returns 0 when the addressed target pulls SDA LOW during the 9th clock cycle to acknowledge the transmission."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_05",
    "title": "Your First I2C Device",
    "summary": "A standard 16-character by 2-line liquid crystal display has 16 raw header pins.",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 5,
    "isOptional": false,
    "prerequisites": [
      "l08_04"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s05",
        "title": "Your First I2C Device",
        "type": "physicalTask",
        "markdownContent": "### Inspecting the 16x2 Character LCD (`comp_07`)\nA standard 16-character by 2-line liquid crystal display has 16 raw header pins. Wiring it in parallel requires dozens of wires and consumes almost all Arduino I/O pins.\n\nOur `comp_07` display features an onboard black daughterboard: the **PCF8574 I2C Backpack**. The backpack converts those 16 parallel pins into a streamlined 4-pin I2C interface!\n\n### The 4 Backpack Pins:\n1. **GND:** Connect to Arduino Uno **GND** (Black / Slate wire).\n2. **VCC:** Connect to Arduino Uno **5V** (Red wire).\n3. **SDA:** Connect to Arduino Uno Analog Pin **A4** (Blue wire).\n4. **SCL:** Connect to Arduino Uno Analog Pin **A5** (Yellow wire).\n\n```\nLCD Backpack [ GND | VCC | SDA | SCL ]\n               │     │     │     │\nArduino Uno   [ GND | 5V  | A4  | A5  ]\n```\n\n### ⚠️ The Blue Contrast Trimpot Trap\nLook at the small blue potentiometer on the back of the I2C backpack. If you power on the screen and see blank boxes or solid black rectangles, do not panic! Use a small screwdriver to gently rotate this trimpot until crisp, clear text appears.\n\n### Hands-On Wiring Steps:\n1. **Safety First:** Unplug the USB cable from your Arduino Uno.\n2. Connect female-to-male jumper wires to the LCD backpack header pins.\n3. Wire `GND` to Uno `GND` and `VCC` to Uno `5V`.\n4. Wire `SDA` to Uno `A4` and `SCL` to Uno `A5`.\n5. Double check every wire connection before reconnecting USB power!",
        "quickCheck": [
          {
            "questionId": "q_l08_s05_1",
            "question": "Before plugging jumper wires between your Arduino Uno and the 16x2 I2C LCD backpack, what safe hardware workflow step must you take?",
            "options": [
              "Unplug the USB cable from your computer to completely disconnect power.",
              "Press the red reset button for ten seconds while powered on.",
              "Increase the Arduino IDE baud rate to 115200."
            ],
            "correctIndex": 0,
            "explanation": "Always disconnect USB power before creating or changing wiring connections on breadboards and breakout modules to prevent short circuits.",
            "warmupExplanation": "Remember the fundamental lab rule from Lesson 2A and Lesson 5: never build or wire live circuits!"
          },
          {
            "questionId": "q_l08_s05_2",
            "question": "If your I2C LCD powers up with the backlight illuminated but characters do not appear on screen, what hardware adjustment should you check first?",
            "options": [
              "The blue contrast potentiometer on the back of the I2C backpack module.",
              "Replace the Uno microcontroller chip.",
              "Reverse the 5V and GND wires to invert polarity."
            ],
            "correctIndex": 0,
            "explanation": "The blue contrast trimpot on the PCF8574 backpack sets the liquid crystal contrast voltage; if it is turned too far, characters become invisible or all black boxes.",
            "warmupExplanation": "In Lesson 6, you learned that potentiometers act as adjustable voltage dividers; the LCD backpack uses a tiny trimpot to tune display contrast."
          }
        ]
      },
      {
        "stepId": "l08_05_s02",
        "title": "The 16x2 I2C Backpack Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Anatomical Tour of the I2C LCD (`comp_07`)\n\nA standard 16x2 LCD display can show 16 characters across 2 rows. On its back sits a black daughterboard: the **PCF8574 I2C Backpack**:\n\n```\n+──────────────────────────────────────────────────────────+\n|            REAR VIEW: 16x2 CHARACTER LCD BACKPACK        |\n|                                                          |\n|   [ 16-Pin Header to HD44780 LCD Controller Glass ]      |\n|                                                          |\n|        [ PCF8574 ]           [ Blue Contrast Pot ]       |\n|    8-Bit I2C I/O Expander     Rotate with screwdriver!   |\n|                                                          |\n|        [ A0 A1 A2 ]          [ 4-Pin Bus Header ]        |\n|      Address Jumper Pads       GND  VCC  SDA  SCL        |\n+──────────────────────────────────────────────────────────+\n```\n\n- **PCF8574 Chip**: An 8-bit remote I/O expander that receives serial commands over I2C and toggles the 16 LCD pins in parallel.\n- **Blue Contrast Potentiometer**: Controls liquid crystal alignment voltage. If text is invisible or all white boxes, this pot needs adjusting!\n- **Backlight Jumper**: A physical jumper shunt that powers the LED backlight."
      },
      {
        "stepId": "l08_05_s03",
        "title": "Wiring & Contrast Potentiometer Adjustment",
        "type": "physicalTask",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Hardware Mission: Wiring the 16x2 LCD\n\n**Golden Rule:** Always unplug your Arduino USB cable before connecting wires!\n\nConnect the 4 wires from the backpack header:\n1. **GND** -> Arduino Uno **GND** (Black wire)\n2. **VCC** -> Arduino Uno **5V** (Red wire)\n3. **SDA** -> Arduino Uno **A4** (or dedicated SDA pin)\n4. **SCL** -> Arduino Uno **A5** (or dedicated SCL pin)\n\n**The Contrast Potentiometer Trap:**\nWhen first powered, the screen may look blank or show a row of solid rectangles! Use a small Phillips screwdriver to gently rotate the blue contrast pot on the backpack until crisp, clear letters appear.\n\n**Workbench Task:**\nPractice diagnosing LCD wiring and contrast issues in the interactive troubleshooting bench below!"
      },
      {
        "stepId": "l08_05_s04",
        "title": "First I2C Device Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of I2C LCD backpack hardware and wiring.",
        "interactiveConfig": {
          "question": "How many total wires are needed to interface a 16x2 LCD backpack with an Arduino Uno?",
          "options": [
            "4 wires (VCC, GND, SDA, and SCL)",
            "16 wires",
            "1 wire"
          ],
          "correctIndex": 0,
          "explanation": "The I2C backpack collapses the 16 parallel pins down to just 4 wires: power (VCC), ground (GND), serial data (SDA), and serial clock (SCL).",
          "questions": [
            {
              "question": "How many total wires are needed to interface a 16x2 LCD backpack with an Arduino Uno?",
              "options": [
                "4 wires (VCC, GND, SDA, and SCL)",
                "16 wires",
                "1 wire"
              ],
              "correctIndex": 0,
              "explanation": "The I2C backpack collapses the 16 parallel pins down to just 4 wires: power (VCC), ground (GND), serial data (SDA), and serial clock (SCL)."
            },
            {
              "question": "If the LCD backlight turns on but no text characters appear on the screen, what is the first hardware adjustment you should check?",
              "options": [
                "Gently turn the blue contrast potentiometer on the back of the I2C backpack",
                "Replace the Arduino board with a different model",
                "Replace the USB cable"
              ],
              "correctIndex": 0,
              "explanation": "If the contrast potentiometer is turned too far in either direction, characters will either be completely washed out or hidden under solid black blocks."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_06",
    "title": "I2C LCD",
    "summary": "In Lesson 3, you learned that libraries supercharge code by bundling complex hardware protocols into friendly functions.",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 6,
    "isOptional": false,
    "prerequisites": [
      "l08_05"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s06",
        "title": "I2C LCD",
        "type": "codeExperiment",
        "markdownContent": "### The Library Connection\nIn Lesson 3, you learned that **libraries** supercharge code by bundling complex hardware protocols into friendly functions. To command our I2C LCD, we use two cooperating libraries:\n1. `<Wire.h>`: Built into the Arduino Core, it directly commands the ATmega328P Two-Wire Interface hardware.\n2. `<LiquidCrystal_I2C.h>`: Translates characters and cursor positions into PCF8574 register bytes.\n\n### The Complete LCD Firmware:\n```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// Create LCD object: address 0x27, 16 columns, 2 rows\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();          // Join I2C bus and wake up display controller\n  lcd.backlight();     // Turn on backlight LED\n\n  lcd.setCursor(0, 0); // Column 0, Row 0 (top line)\n  lcd.print(\"Monster Lab!\");\n\n  lcd.setCursor(0, 1); // Column 0, Row 1 (bottom line)\n  lcd.print(\"I2C Bus: 0x27\");\n}\n\nvoid loop() {\n  // Static display: nothing needed in loop!\n}\n```\n\n### Code Deconstruction:\n- `LiquidCrystal_I2C lcd(0x27, 16, 2);`: Creates an instance targeting device address `0x27` with a 16x2 character grid.\n- `lcd.init()`: Transmits initialization byte sequences over SDA/SCL to configure font size, display mode, and memory registers.\n- `lcd.backlight()`: Commands the backpack transistor to illuminate the LED backlight.\n- `lcd.setCursor(col, row)`: Places the writing cursor using 0-indexed coordinates (row 0 is the top line, row 1 is the bottom line).\n- `lcd.print(\"...\")`: Streams ASCII character data across the I2C bus onto the glass.\n\n### Hands-On Modification:\nUpload the sketch to your board. Then customize line 2 to print your monster's name and re-upload!",
        "quickCheck": [
          {
            "questionId": "q_l08_s06_1",
            "question": "Which standard library header file must be included in your Arduino sketch to provide I2C communication functions?",
            "options": [
              "<Wire.h>",
              "<Servo.h>",
              "<EEPROM.h>"
            ],
            "correctIndex": 0,
            "explanation": "<Wire.h> is the built-in Arduino library that manages the ATmega328P Two-Wire Interface (I2C) hardware.",
            "warmupExplanation": "Recall Lesson 3: libraries provide pre-written driver code, and <Wire.h> is the universal Arduino library for I2C."
          },
          {
            "questionId": "q_l08_s06_2",
            "question": "In the declaration LiquidCrystal_I2C lcd(0x27, 16, 2);, what information does the first argument 0x27 provide?",
            "options": [
              "The 7-bit I2C bus hardware address of the display backpack.",
              "The refresh rate of the LCD in frames per second.",
              "The pin number where the contrast knob is connected."
            ],
            "correctIndex": 0,
            "explanation": "The first parameter defines the I2C hardware address (0x27) so the library communicates with the correct physical backpack on the bus.",
            "warmupExplanation": "In Step 4, we saw that every I2C device requires its specific 7-bit address to respond to incoming bus packets."
          }
        ]
      },
      {
        "stepId": "l08_06_s02",
        "title": "Software Drivers: Wire.h and LiquidCrystal_I2C",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Software Driver Architecture\n\nTo control the LCD from C++, two libraries collaborate:\n\n```\n[ Your Monster Sketch: lcd.print(\"ROBOT ACTIVE!\"); ]\n                         │\n                         ▼\n[ LiquidCrystal_I2C Library: Translates text into character codes ]\n                         │\n                         ▼\n[ Wire.h Library: Manages hardware TWI clock & byte packets ]\n                         │\n                         ▼ (SDA & SCL Pulses over A4 & A5)\n[ PCF8574 Hardware Backpack ] ──► [ 16x2 LCD Glass Screen ]\n```\n\n### Essential Driver Methods:\n- `LiquidCrystal_I2C lcd(0x27, 16, 2);`: Constructor setting address (0x27), columns (16), and rows (2).\n- `lcd.init();`: Initializes the PCF8574 and LCD controller chip.\n- `lcd.backlight();`: Powers the LED backlight on.\n- `lcd.setCursor(col, row);`: Positions the text cursor (0-indexed: col 0–15, row 0–1).\n- `lcd.print(\"Text\");`: Renders characters on screen."
      },
      {
        "stepId": "l08_06_s03",
        "title": "Debugging LCD Coordinates and Addresses",
        "type": "codeExperiment",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Writing and Debugging LCD Firmware\n\nHere is a complete template sketch for your monster display:\n\n```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// If 0x27 fails, verify with I2C scanner (may be 0x3F)\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();\n  lcd.backlight();\n\n  // Row 0 (Top line, zero-indexed!)\n  lcd.setCursor(0, 0);\n  lcd.print(\"MONSTER LAB OS\");\n\n  // Row 1 (Bottom line)\n  lcd.setCursor(0, 1);\n  lcd.print(\"STATUS: ONLINE!\");\n}\n\nvoid loop() {\n  // Static banner display\n}\n```\n\n**Common Software Bugs:**\n1. Using 1-indexed coordinates: `lcd.setCursor(0, 2)` goes out of bounds on a 2-line display!\n2. Wrong address: Declaring `0x27` when your board is hardwired to `0x3F`.\n\nPractice diagnosing LCD code issues in the interactive workbench below!"
      },
      {
        "stepId": "l08_06_s04",
        "title": "I2C LCD Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of LCD library commands, coordinates, and drivers.",
        "interactiveConfig": {
          "question": "What do the coordinate arguments (0, 1) specify in lcd.setCursor(0, 1);?",
          "options": [
            "Column 0 (far left) on Row 1 (the bottom line), because coordinates are zero-indexed",
            "Column 1 on Row 0",
            "The number 01 is printed onto the screen"
          ],
          "correctIndex": 0,
          "explanation": "LCD coordinates are zero-indexed: columns run 0 to 15, and rows run 0 (top line) and 1 (bottom line).",
          "questions": [
            {
              "question": "What do the coordinate arguments (0, 1) specify in lcd.setCursor(0, 1);?",
              "options": [
                "Column 0 (far left) on Row 1 (the bottom line), because coordinates are zero-indexed",
                "Column 1 on Row 0",
                "The number 01 is printed onto the screen"
              ],
              "correctIndex": 0,
              "explanation": "LCD coordinates are zero-indexed: columns run 0 to 15, and rows run 0 (top line) and 1 (bottom line)."
            },
            {
              "question": "Which C++ standard library must be included to enable I2C hardware bus communication in Arduino sketches?",
              "options": [
                "#include <Wire.h>",
                "#include <SPI.h>",
                "#include <SoftwareSerial.h>"
              ],
              "correctIndex": 0,
              "explanation": "Wire.h is the standard Arduino library that manages the hardware Two-Wire Interface (TWI/I2C) peripheral."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_07",
    "title": "I2C Sensor",
    "summary": "Now let's add a smart I2C sensorsuch as a digital temperature sensor, a barometric pressure altimeter, or a real-time clock.",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 7,
    "isOptional": false,
    "prerequisites": [
      "l08_06"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s07",
        "title": "I2C Sensor",
        "type": "physicalTask",
        "markdownContent": "### Expanding the Bus with Smart Sensors\nNow let's add a smart I2C sensor—such as a digital temperature sensor, a barometric pressure altimeter, or a real-time clock.\n\nBecause I2C is a shared parallel bus, the sensor does NOT require new GPIO pins on the Arduino! It connects directly to the exact same **SDA (A4)** and **SCL (A5)** wires as the LCD display.\n\n### Breadboard Bus Distribution Architecture\nTo attach multiple devices cleanly without cramming multiple wires into a single Arduino pin socket, use the breadboard distribution rails:\n\n```\nArduino Uno 5V  ──────► Breadboard Power Rail (+)\nArduino Uno GND ──────► Breadboard Ground Rail (-)\nArduino Uno A4  ──────► Breadboard Row 20 (SDA Bus)\nArduino Uno A5  ──────► Breadboard Row 21 (SCL Bus)\n```\n\n1. Connect LCD `VCC` and Sensor `VCC` to the breadboard `+` rail.\n2. Connect LCD `GND` and Sensor `GND` to the breadboard `-` rail.\n3. Connect LCD `SDA` and Sensor `SDA` together into Row 20.\n4. Connect LCD `SCL` and Sensor `SCL` together into Row 21.\n\n### How Data Flows\nWhen the Arduino requests temperature readings, it broadcasts the sensor's address (e.g., `0x44` or `0x68`). The LCD ignores the packet. The sensor processes the command and returns measurement bytes. A fraction of a millisecond later, the Arduino addresses `0x27` and writes the new temperature string onto the LCD!",
        "quickCheck": [
          {
            "questionId": "q_l08_s07_1",
            "question": "When connecting an I2C sensor to an Arduino Uno that already has an I2C display wired up, where must the sensor's SDA and SCL pins be connected?",
            "options": [
              "In parallel to the exact same SDA (A4) and SCL (A5) bus lines as the display.",
              "To digital pins 2 and 3 to keep them separated.",
              "To analog inputs A0 and A1."
            ],
            "correctIndex": 0,
            "explanation": "All I2C peripherals connect in parallel to the shared SDA (A4) and SCL (A5) bus wires.",
            "warmupExplanation": "Remember the defining feature of a bus: all connected devices share the exact same clock and data lines."
          },
          {
            "questionId": "q_l08_s07_2",
            "question": "Why is a breadboard power rail helpful when wiring multiple I2C devices to an Arduino Uno?",
            "options": [
              "It distributes the Uno's single 5V pin and GND pin across multiple tie-points so all devices receive power and share ground cleanly.",
              "It doubles the voltage supplied to each attached sensor.",
              "It converts direct current into alternating current."
            ],
            "correctIndex": 0,
            "explanation": "The breadboard power rails allow multiple modules to tap into the Uno's 5V and GND pins reliably.",
            "warmupExplanation": "In Lesson 6, you learned how breadboard power buses distribute 5V and GND across dozens of connection points."
          }
        ]
      },
      {
        "stepId": "l08_07_s02",
        "title": "Smart Sensors with On-Board Microchips",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### Raw Analog Sensors vs. Smart I2C Sensors\n\nIn Lesson 7, you used raw analog sensors (like an LDR) that required voltage dividers and microcontroller ADC conversions.\n\n**Smart I2C Sensors** take things to a whole new level:\n\n```\n[ Raw Analog Sensor ] ──► [ Voltage Divider ] ──► [ Arduino 10-bit ADC ] ──► [ Code Math ]\n\n[ Smart I2C Sensor ]\n┌────────────────────────────────────────────────────────┐\n│  Transducer ──► Internal 24-bit ADC ──► DSP Filter    │\n│                       │                                │\n│                       ▼                                │\n│             Internal Register Map                      │\n│     (0x00: Status, 0x01: Temp MSB, 0x02: Temp LSB)     │\n│                       │                                │\n│                       ▼                                │\n│              I2C Bus Engine (0x68)                     │\n└───────────────────────┬────────────────────────────────┘\n                        │ (SDA & SCL Clean Digital Bytes)\n                        ▼\n                [ Arduino Uno ]\n```\n\nSmart sensors perform internal signal conditioning and store calibrated values in internal registers. The Arduino simply asks for the number over I2C!"
      },
      {
        "stepId": "l08_07_s03",
        "title": "Parallel Bus Expansion with I2C Sensors",
        "type": "physicalTask",
        "interactiveWidgetType": "i2cAddressScanner",
        "markdownContent": "### Adding a Smart Sensor Alongside Your LCD\n\nTo connect an I2C sensor (such as a BMP280 barometer or DS3231 RTC clock) to your Arduino while the LCD is already connected:\n1. Connect the sensor's **VCC** to the +5V breadboard power rail.\n2. Connect the sensor's **GND** to the GND breadboard power rail.\n3. Connect the sensor's **SDA** in parallel with the LCD's SDA line (Pin A4).\n4. Connect the sensor's **SCL** in parallel with the LCD's SCL line (Pin A5).\n\n**Zero Extra Pins Used!** Both devices share the exact same 2 pins!\n\n**Laboratory Task:**\nRun the interactive I2C Address Scanner below to confirm that both the LCD (`0x27`) and smart sensor (`0x68`) respond cleanly on the bus!"
      },
      {
        "stepId": "l08_07_s04",
        "title": "I2C Sensor Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of smart digital sensors and bus sharing.",
        "interactiveConfig": {
          "question": "Where do you connect the SDA and SCL pins of a new I2C sensor when an I2C LCD is already attached?",
          "options": [
            "To the exact same SDA (A4) and SCL (A5) pins in parallel",
            "To digital pins 2 and 3",
            "To the 3.3V and AREF pins"
          ],
          "correctIndex": 0,
          "explanation": "Because I2C is a shared bus, all peripherals connect in parallel to the exact same SDA (A4) and SCL (A5) lines.",
          "questions": [
            {
              "question": "Where do you connect the SDA and SCL pins of a new I2C sensor when an I2C LCD is already attached?",
              "options": [
                "To the exact same SDA (A4) and SCL (A5) pins in parallel",
                "To digital pins 2 and 3",
                "To the 3.3V and AREF pins"
              ],
              "correctIndex": 0,
              "explanation": "Because I2C is a shared bus, all peripherals connect in parallel to the exact same SDA (A4) and SCL (A5) lines."
            },
            {
              "question": "What is a key advantage of smart digital I2C sensors over raw analog sensors?",
              "options": [
                "They perform internal high-resolution analog-to-digital conversion and transmit clean, noise-free digital data",
                "They never require power or ground connections",
                "They do not require any software code"
              ],
              "correctIndex": 0,
              "explanation": "Smart I2C sensors contain built-in precision digitizers and DSP filters, sending ready-to-use digital values over the bus without susceptibility to analog noise."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_08",
    "title": "Multiple I2C Devices",
    "summary": "In I2C, daisy-chaining refers to running parallel connections from device to device along the shared 4-wire bus (VCC, GND, SDA, SCL).",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 8,
    "isOptional": false,
    "prerequisites": [
      "l08_07"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s08",
        "title": "Multiple I2C Devices",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cDaisyChainSimulator",
        "markdownContent": "### Daisy-Chaining Topologies\nIn I2C, **daisy-chaining** refers to running parallel connections from device to device along the shared 4-wire bus (VCC, GND, SDA, SCL). Because every device shares the same electrical bus, you can attach 2, 5, or 10 peripherals while using only pins A4 and A5 on the Uno!\n\n```\nUno (Controller)\n  │        │\n SDA      SCL\n  ├───┬────┤\n  │   │    │\n LCD RTC Temp\n0x27 0x68 0x48\n```\n\n### The Golden Rule: Unique Addresses Only\nEvery device connected to an active I2C bus **MUST have a unique 7-bit hardware address**.\n\n### What is an Address Collision?\nIf you attach two identical display modules that both use address `0x27`:\n1. The Arduino sends a message targeting `0x27`.\n2. **Both devices** think they are being addressed!\n3. Both devices attempt to drive the SDA line simultaneously.\n4. Bits collide and corrupt each other, causing communications to freeze or display nonsense.\n\n### Changing Hardware Addresses\nWhat if you want to use two identical modules in the same robot? Most I2C breakout boards include **address solder pads** (labeled A0, A1, A2):\n- By default, pads are open (representing binary 1s).\n- Bridging a pad with a tiny drop of solder ties that address line to GND (representing binary 0).\n- This changes the device address (for example, shifting `0x27` to `0x26`), enabling both identical devices to communicate happily on the exact same bus!\n\nUse the interactive daisy-chain simulator below to add multiple peripherals, detect address collisions, and adjust solder pads to resolve conflicts!",
        "quickCheck": [
          {
            "questionId": "q_l08_s08_1",
            "question": "What happens on the I2C bus if two different peripherals share the exact same hardware address (e.g. both configured to 0x27)?",
            "options": [
              "An address collision occurs: both devices attempt to drive the SDA wire simultaneously, causing corrupt data and failed packets.",
              "The Arduino Uno automatically assigns a new address to the second device.",
              "The device with longer wires is ignored while the other functions normally."
            ],
            "correctIndex": 0,
            "explanation": "Address collisions cause multiple peripherals to acknowledge and drive the bus at once, scrambling data packets.",
            "warmupExplanation": "Think about what happens if two people have the identical phone number or home address: messages collide!"
          },
          {
            "questionId": "q_l08_s08_2",
            "question": "How can you resolve an address conflict between two identical breakout boards on the same I2C bus?",
            "options": [
              "Change the hardware address on one board by bridging or cutting an address selection pad (like A0, A1, or AD0).",
              "Power one board with 3.3V and the other with 5V.",
              "Swap the SDA and SCL wires on one of the boards."
            ],
            "correctIndex": 0,
            "explanation": "Breakout boards provide address pads (often labeled A0, A1, A2) so developers can change the base address by bridging solder pads.",
            "warmupExplanation": "Many sensor boards provide hardware jumpers to alter the lowest bits of their 7-bit I2C address."
          }
        ]
      },
      {
        "stepId": "l08_08_s02",
        "title": "Daisy-Chaining Architecture & Address Collisions",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cDaisyChainSimulator",
        "markdownContent": "### Multi-Device Buses & Address Collisions\n\nConnecting multiple I2C peripherals in parallel along a shared 4-wire bus (VCC, GND, SDA, SCL) is called **daisy-chaining**:\n\n```\n[ Arduino ] ───┬─────────────┬─────────────┬─────────────►\n(Controller)   │             │             │\n               ▼             ▼             ▼\n          [ LCD 16x2 ]   [ RTC Clock ] [ OLED Display ]\n           Addr: 0x27    Addr: 0x68    Addr: 0x3C\n            (No Conflict! All addresses are distinct)\n```\n\n### The Address Collision Hazard\nWhat happens if you plug in **two identical sensor boards** (e.g. two DS3231 RTCs or two identical gyroscopes, both configured to address `0x68`)?\n\nWhen the Arduino calls `0x68`, **both devices reply at the same moment!** They fight over the SDA line, causing bus contention and corrupted data bytes!\n\n### Solving Address Collisions:\nMost quality I2C breakout boards have **address solder jumpers (A0, A1, A2)**. Bridging a solder pad changes the low-order address bits (e.g. from `0x68` to `0x69`), resolving the conflict instantly!"
      },
      {
        "stepId": "l08_08_s03",
        "title": "Resolving I2C Bus Address Collisions",
        "type": "codeExperiment",
        "interactiveWidgetType": "i2cDaisyChainSimulator",
        "markdownContent": "### Interactive Daisy-Chain Simulator\n\nIn the bus simulator below, you can connect multiple peripherals to an Arduino Uno:\n- 16x2 Character LCD (`0x27`)\n- Real-Time Clock Module (`0x68`)\n- OLED Graphic Display (`0x3C`)\n\n**Laboratory Experiment:**\n1. Enable the second RTC module.\n2. Observe how the simulator flags an **ADDRESS COLLISION ALERT (0x68)**.\n3. Use the address configuration jumper to remap the second peripheral and restore clean bus communication!"
      },
      {
        "stepId": "l08_08_s04",
        "title": "Multiple I2C Devices Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your understanding of bus topologies, address conflicts, and hardware jumper configuration.",
        "interactiveConfig": {
          "question": "What happens on the I2C bus if two different breakout modules share the exact same hardware address (e.g. both 0x68)?",
          "options": [
            "An address collision occurs, causing bus contention and corrupting transmitted data",
            "The Arduino board doubles its processor speed",
            "Both devices take turns automatically without conflict"
          ],
          "correctIndex": 0,
          "explanation": "Because both devices respond to the same address simultaneously, their open-drain outputs clash on the SDA line, corrupting bytes.",
          "questions": [
            {
              "question": "What happens on the I2C bus if two different breakout modules share the exact same hardware address (e.g. both 0x68)?",
              "options": [
                "An address collision occurs, causing bus contention and corrupting transmitted data",
                "The Arduino board doubles its processor speed",
                "Both devices take turns automatically without conflict"
              ],
              "correctIndex": 0,
              "explanation": "Because both devices respond to the same address simultaneously, their open-drain outputs clash on the SDA line, corrupting bytes."
            },
            {
              "question": "How can you resolve an address conflict between two identical breakout boards on the same I2C bus?",
              "options": [
                "By bridging or cutting solder jumper pads (labeled A0, A1, or A2) on one board to alter its hardware address",
                "By plugging the Arduino into a different USB socket",
                "By changing wire colors on the breadboard"
              ],
              "correctIndex": 0,
              "explanation": "Most I2C breakout boards include address select pads (A0, A1, A2) that connect internal address pins to VCC or GND, changing the hardware address."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_09",
    "title": "I2C Troubleshooting",
    "summary": "Even veteran robotics engineers encounter I2C communication failures.",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 9,
    "isOptional": false,
    "prerequisites": [
      "l08_08"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s09",
        "title": "I2C Troubleshooting",
        "type": "story",
        "markdownContent": "### The Engineer's Diagnostic Playbook\nEven veteran robotics engineers encounter I2C communication failures. When your display won't print or your scanner freezes, follow this systematic diagnostic triage:\n\n### 1. Swapped SDA and SCL Wires\n- **Symptom:** Sketch hangs in `Wire.endTransmission()` or scanner reports 0 devices detected.\n- **Cause:** Pin A4 is accidentally plugged into SCL, and Pin A5 into SDA.\n- **Remedy:** Verify wire paths. **A4 = SDA** (Data), **A5 = SCL** (Clock).\n\n### 2. Missing Common Ground (GND)\n- **Symptom:** Random garbled symbols appear on screen, or sensor values jump wildly.\n- **Cause:** The peripheral has power, but no return GND wire to the Arduino.\n- **Remedy:** Ensure a solid ground jumper wire connects the peripheral to the Uno GND header.\n\n### 3. Wrong Address in Firmware\n- **Symptom:** LCD backlight turns on, but text never renders; code runs without throwing errors.\n- **Cause:** Your code specified `0x27`, but your specific backpack hardware is configured to `0x3F`!\n- **Remedy:** Run an I2C scanner sketch to discover the true address, then update your sketch declaration.\n\n### 4. Excessive Wire Length & Capacitance\n- **Symptom:** Devices work on a small breadboard, but fail when connected through long 2-meter ribbon cables.\n- **Cause:** Long wires introduce electrical capacitance, rounding off square-wave clock edges.\n- **Remedy:** Keep I2C jumper wires under 30 cm (12 inches) or lower bus speed to standard mode (100 kHz).\n\n### 5. 3.3V vs. 5V Logic Incompatibility\n- **Symptom:** Fragile modern sensors overheat or burn out.\n- **Cause:** Connecting an Uno's 5V I2C bus directly to a 3.3V-only sensor without logic level shifting.\n- **Remedy:** Always verify the sensor board has built-in level-shifting FETs or use a bidirectional logic level shifter!",
        "quickCheck": [
          {
            "questionId": "q_l08_s09_1",
            "question": "If your I2C scanner sketch reports 'No I2C devices found' despite power LEDs glowing on all modules, what is the most common wiring error?",
            "options": [
              "The SDA and SCL lines are swapped (SDA plugged into A5 and SCL plugged into A4).",
              "The USB cable is plugged into the wrong computer port.",
              "The breadboard has too much electricity stored in it."
            ],
            "correctIndex": 0,
            "explanation": "Swapping SDA and SCL prevents clock edges from synchronizing with data bits, completely preventing communication on the bus.",
            "warmupExplanation": "Remember: SDA must go to A4, and SCL must go to A5. If swapped, neither device can understand the signals."
          },
          {
            "questionId": "q_l08_s09_2",
            "question": "Why is running an I2C scanner sketch the best first step when a new I2C display or sensor fails to communicate?",
            "options": [
              "It tests electrical connectivity and discovers the exact 7-bit hardware address responding on the bus without requiring complex library code.",
              "It uploads new operating systems onto peripheral chips.",
              "It automatically solders loose jumper wires."
            ],
            "correctIndex": 0,
            "explanation": "An I2C scanner sketch verifies physical bus wiring and prints the exact hex address where devices respond, isolating hardware issues from software bugs.",
            "warmupExplanation": "In Step 4 and Step 6, we saw how testing the raw address confirms electrical continuity before writing full application code."
          }
        ]
      },
      {
        "stepId": "l08_09_s02",
        "title": "Systematic I2C Diagnostic Playbook",
        "type": "visualExplanation",
        "interactiveWidgetType": "visualFlowDiagram",
        "markdownContent": "### The Master I2C Diagnostic Playbook\n\nWhen an I2C LCD stays blank or a scanner finds zero devices, follow this 5-step checklist:\n\n```\n[ Problem: I2C Device Dead, Frozen, or Unrecognized ]\n                           │\n                           ▼\n1. CHECK COMMON GROUND: Do ALL devices share a solid GND wire with Arduino?\n                           │ (Without common ground, 5V reference is lost!)\n                           ▼\n2. CHECK SDA/SCL WIRING: Are data and clock wires swapped?\n                           │ (SDA MUST go to A4, SCL MUST go to A5!)\n                           ▼\n3. CHECK CONTRAST POT: On LCDs, is the blue potentiometer adjusted?\n                           │ (Too far left = blank; too far right = black blocks!)\n                           ▼\n4. RUN I2C SCANNER: Does the scanner report the expected hex address?\n                           │ (Discovers if backpack is 0x3F instead of 0x27!)\n                           ▼\n5. CHECK PULL-UPS: Are bus lines held at 5V when idle?\n```"
      },
      {
        "stepId": "l08_09_s03",
        "title": "Interactive Bench Repair of I2C Bus Faults",
        "type": "physicalTask",
        "interactiveWidgetType": "interactiveTroubleshooting",
        "markdownContent": "### Hands-On: Diagnosing Bus Lockups\n\n**The Dreaded Bus Lockup:**\nBecause I2C is a shared bus, if **one single wire** has a short circuit or loose connection, the entire bus can freeze! Calling `Wire.endTransmission()` may hang indefinitely waiting for an ACK that never comes.\n\nTop I2C bench traps to inspect:\n- **Wire Cross**: Accidentally connecting SDA to A5 and SCL to A4.\n- **Floating Ground**: Powering a sensor from an external battery without tying battery negative to Arduino GND.\n- **Wrong Sketch Address**: Hardcoding `0x27` in code when the module is actually configured to `0x3F`.\n\n**Workbench Task:**\nUse the interactive troubleshooting bench below to isolate and fix simulated I2C bus wiring and software faults!"
      },
      {
        "stepId": "l08_09_s04",
        "title": "I2C Troubleshooting Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Test your diagnostic instincts and systematic debugging skills on the I2C bus.",
        "interactiveConfig": {
          "question": "If your I2C scanner sketch reports 'No I2C devices found' despite power LEDs glowing on all modules, what is the most common wiring error?",
          "options": [
            "SDA and SCL jumper wires are swapped between the Arduino and the modules",
            "The Arduino board does not have enough flash memory",
            "The USB cable is plugged in upside down"
          ],
          "correctIndex": 0,
          "explanation": "Swapping SDA and SCL is the #1 most common wiring error. Without clock pulses on SCL, peripherals cannot decode incoming address bits.",
          "questions": [
            {
              "question": "If your I2C scanner sketch reports 'No I2C devices found' despite power LEDs glowing on all modules, what is the most common wiring error?",
              "options": [
                "SDA and SCL jumper wires are swapped between the Arduino and the modules",
                "The Arduino board does not have enough flash memory",
                "The USB cable is plugged in upside down"
              ],
              "correctIndex": 0,
              "explanation": "Swapping SDA and SCL is the #1 most common wiring error. Without clock pulses on SCL, peripherals cannot decode incoming address bits."
            },
            {
              "question": "Why is a shared Common Ground (GND) wire mandatory between the Arduino and every I2C device?",
              "options": [
                "Ground provides the common 0V voltage reference needed to measure whether SDA and SCL lines are HIGH or LOW",
                "Ground is only needed to power the LED backlight",
                "Ground makes the I2C clock run faster"
              ],
              "correctIndex": 0,
              "explanation": "Voltage is a relative difference in electrical potential. Without a common Ground return, devices have no shared 0V reference to interpret logic levels."
            }
          ]
        }
      }
    ],
    "xpReward": 10
  },
  {
    "id": "l08_10",
    "title": "I2C Challenge",
    "summary": "You have mastered the fundamentals of serial bus communication, open-drain pull-up physics, SDA/SCL pinouts, 7-bit hardware addressing, multi-devic...",
    "tier": "engineer",
    "estimatedMinutes": 10,
    "courseId": "lesson_08",
    "sortOrder": 10,
    "isOptional": false,
    "prerequisites": [
      "l08_09"
    ],
    "componentIds": [
      "comp_uno",
      "comp_07"
    ],
    "steps": [
      {
        "stepId": "l08_s10",
        "title": "I2C Challenge",
        "type": "quizCheckpoint",
        "markdownContent": "### Master Certification: 2-Wire Serial Networking\nYou have mastered the fundamentals of serial bus communication, open-drain pull-up physics, SDA/SCL pinouts, 7-bit hardware addressing, multi-device daisy-chaining, and systematic troubleshooting!\n\n### The Final Challenge Mission\nImagine designing an **Environmental Telemetry Station**: you have an I2C LCD at address `0x27` and a temperature sensor at address `0x48`. Both connect in parallel to pins A4 and A5 on your Arduino Uno.\n\nComplete this comprehensive 8-question assessment to prove your readiness for connected embedded devices!",
        "interactiveConfig": {
          "question": "How many signal wires does the I2C protocol require to communicate between a microcontroller and multiple peripherals?",
          "options": [
            "2 wires (SDA for data and SCL for clock)",
            "8 wires (one for each bit of a byte)",
            "4 wires (MISO, MOSI, SCK, and SS)"
          ],
          "correctIndex": 0,
          "explanation": "I2C requires only 2 signal wires (SDA and SCL) to coordinate communications with up to 127 devices.",
          "questions": [
            {
              "question": "How many signal wires does the I2C protocol require to communicate between a microcontroller and multiple peripherals?",
              "options": [
                "2 wires (SDA for data and SCL for clock)",
                "8 wires (one for each bit of a byte)",
                "4 wires (MISO, MOSI, SCK, and SS)"
              ],
              "correctIndex": 0,
              "explanation": "I2C requires only 2 signal wires (SDA and SCL) to coordinate communications with up to 127 devices."
            },
            {
              "question": "Which Arduino Uno pins are used for hardware I2C communication?",
              "options": [
                "A4 (SDA) and A5 (SCL)",
                "Pin 0 (RX) and Pin 1 (TX)",
                "Pin 9 (PWM) and Pin 10 (PWM)"
              ],
              "correctIndex": 0,
              "explanation": "Analog pin A4 carries the SDA data line and analog pin A5 carries the SCL clock line."
            },
            {
              "question": "What is the purpose of the 7-bit address in an I2C communication packet?",
              "options": [
                "It identifies which specific peripheral on the shared bus should listen to and execute the transmission.",
                "It sets the screen brightness of connected displays.",
                "It determines the physical wire length of the circuit."
              ],
              "correctIndex": 0,
              "explanation": "Every peripheral has a unique 7-bit address so the Controller can communicate with one specific device without interference."
            },
            {
              "question": "Why do I2C bus lines use pull-up resistors connected to 5V?",
              "options": [
                "They establish a default HIGH state so devices can pull lines LOW safely using open-drain transistors without short circuits.",
                "They convert digital signals into analog sound waves.",
                "They prevent static electricity from entering the computer."
              ],
              "correctIndex": 0,
              "explanation": "I2C is an open-drain bus: pull-up resistors pull lines HIGH to 5V when idle, and devices pull lines LOW to send binary bits."
            },
            {
              "question": "What is the consequence of having two devices with identical addresses (such as two 0x27 displays) on the same I2C bus?",
              "options": [
                "An address collision occurs, causing both devices to drive the data line simultaneously and corrupting data.",
                "The Arduino Uno will assign one device to run at double speed.",
                "The circuit will safely alternate between the two devices automatically."
              ],
              "correctIndex": 0,
              "explanation": "Two devices sharing the same address will both attempt to respond, causing data corruption and bus contention."
            },
            {
              "question": "Which standard library header file is built into Arduino to manage I2C hardware?",
              "options": [
                "<Wire.h>",
                "<SPI.h>",
                "<LiquidCrystal.h>"
              ],
              "correctIndex": 0,
              "explanation": "The built-in <Wire.h> library provides all the fundamental Two-Wire Interface (I2C) functions on Arduino."
            },
            {
              "question": "If your 16x2 I2C LCD displays solid white/black boxes instead of text, what should you do first?",
              "options": [
                "Adjust the blue contrast potentiometer on the back of the backpack with a small screwdriver.",
                "Cut the SDA wire in half.",
                "Reinstall the Arduino IDE software."
              ],
              "correctIndex": 0,
              "explanation": "The blue contrast trimpot adjusts the voltage to the liquid crystal fluid; tuning it reveals text hidden by over- or under-contrast."
            },
            {
              "question": "How do you connect a second I2C device when the Arduino Uno's A4 and A5 pins already have wires in them?",
              "options": [
                "Use a breadboard to branch A4 and A5 into parallel rows so both devices connect to the same pins.",
                "Connect the second device to analog pin A0 and A1.",
                "Stack two Arduino Uno boards on top of each other."
              ],
              "correctIndex": 0,
              "explanation": "I2C is a parallel bus: breadboard tie-points allow multiple devices to connect to SDA (A4) and SCL (A5) simultaneously."
            }
          ]
        },
        "quickCheck": [
          {
            "questionId": "q_l08_s10_1",
            "question": "What is the primary advantage of connecting multiple robot sensors and displays using an I2C bus rather than dedicated pins?",
            "options": [
              "It conserves GPIO pins by networking up to 127 devices across only two shared signal lines (SDA and SCL).",
              "It eliminates the need for any programming libraries.",
              "It operates without consuming any battery electrical power."
            ],
            "correctIndex": 0,
            "explanation": "I2C allows multiple peripherals to communicate over just two shared wires, preventing microcontroller pin exhaustion.",
            "warmupExplanation": "Remember the primary motivation introduced in Step 1: preventing pin starvation on your microcontroller."
          },
          {
            "questionId": "q_l08_s10_2",
            "question": "When developing an embedded project with an I2C peripheral, which two software components work together in your sketch?",
            "options": [
              "The Arduino <Wire.h> bus library and the device-specific driver library (such as <LiquidCrystal_I2C.h>).",
              "The <Keyboard.h> library and the <Mouse.h> library.",
              "The <SD.h> file system library and the <WiFi.h> library."
            ],
            "correctIndex": 0,
            "explanation": "<Wire.h> manages the hardware I2C bus protocol, while the device library provides high-level commands for the specific module.",
            "warmupExplanation": "In Step 6 and Lesson 3, you saw how hardware bus libraries partner with device drivers to control complex peripherals."
          }
        ]
      },
      {
        "stepId": "l08_10_s02",
        "title": "Complete Connected Monster Bus Architecture",
        "type": "visualExplanation",
        "interactiveWidgetType": "i2cDaisyChainSimulator",
        "markdownContent": "### The Capstone: Connected Monster Lab System\n\nYou have reached the final milestone of Course 8! In this capstone project, you integrate multiple smart devices onto a single 2-wire serial bus:\n\n```\n[ Arduino Uno R3 Brain ]\n   │          │\n   │ SDA (A4) ├───┬──────────────────────────────┬──────────────────►\n   │ SCL (A5) └───┼──────────────┬───────────────┼──────────────────►\n                  ▼              ▼               ▼\n             [ I2C LCD ]    [ I2C RTC ]     [ I2C Sensor ]\n              Addr: 0x27     Addr: 0x68      Addr: 0x76\n             Status Display Real-Time Clock  Telemetry Stream\n```\n\nCapstone System Specifications:\n1. All devices share common +5V and GND power rails.\n2. All devices communicate over the shared A4/A5 bus highway.\n3. Address scanner verifies zero address collisions.\n4. Firmware coordinates real-time telemetry updates cleanly without bus lockups!"
      },
      {
        "stepId": "l08_10_s03",
        "title": "Final Multi-Device Bus Verification",
        "type": "codeExperiment",
        "interactiveWidgetType": "i2cAddressScanner",
        "markdownContent": "### Final Lab: Multi-Peripheral Bus Commissioning\n\nBefore uploading your master firmware, commission the bus:\n1. Verify solid power rail connections (+5V and GND).\n2. Wire LCD backpack (SDA -> A4, SCL -> A5).\n3. Wire environmental sensor in parallel to the same bus rails.\n4. Run the interactive I2C Address Scanner below to verify conflict-free detection of all peripheral addresses!"
      },
      {
        "stepId": "l08_10_s04",
        "title": "Master I2C Challenge Checkpoint",
        "type": "quizCheckpoint",
        "markdownContent": "Prove your complete mastery of 2-wire I2C communication, bus topologies, and device addressing to earn your certification XP!",
        "interactiveConfig": {
          "question": "What are the two dedicated communication lines used in the I2C protocol?",
          "options": [
            "SDA (Serial Data) and SCL (Serial Clock)",
            "TX (Transmit) and RX (Receive)",
            "MOSI (Master Out) and MISO (Master In)"
          ],
          "correctIndex": 0,
          "explanation": "I2C uses SDA to transport bidirectional serial data bits and SCL to synchronize clock pulses.",
          "questions": [
            {
              "question": "What are the two dedicated communication lines used in the I2C protocol?",
              "options": [
                "SDA (Serial Data) and SCL (Serial Clock)",
                "TX (Transmit) and RX (Receive)",
                "MOSI (Master Out) and MISO (Master In)"
              ],
              "correctIndex": 0,
              "explanation": "I2C uses SDA to transport bidirectional serial data bits and SCL to synchronize clock pulses."
            },
            {
              "question": "Why is I2C referred to as an 'open-drain' bus with pull-up resistors?",
              "options": [
                "Devices only pull lines down to Ground; pull-up resistors return lines to +5V when idle",
                "Water drains out of the microchips to keep them cool",
                "The pins drain the battery even when the board is unplugged"
              ],
              "correctIndex": 0,
              "explanation": "Open-drain transistors can only pull signals LOW to GND. Passive pull-up resistors pull lines HIGH to +5V when released, preventing short circuits."
            },
            {
              "question": "In Arduino C++, which core library provides hardware support for I2C bus communication?",
              "options": [
                "Wire.h",
                "LiquidCrystal.h",
                "EEPROM.h"
              ],
              "correctIndex": 0,
              "explanation": "The Wire library is the official Arduino library for I2C (Two-Wire Interface) communication."
            }
          ]
        }
      }
    ],
    "xpReward": 15
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
        "markdownContent": "### The Two-Wire Superhighway: Bus Topologies\nIf every sensor, motor driver, display, and keypad required its own dedicated pins on the Arduino, you would run out of pins after adding just three components. A humanoid robot needs dozens of sensors: gyroscopes, thermal cameras, pressure sensors, and displays.\n\nThe I2C bus solves this pin starvation problem by allowing up to 127 unique peripheral devices to communicate over the exact same two wires! In this lesson, you will network a display and a precision clock onto a shared data superhighway.\n\n```\nController (Uno) ───┬─── SDA (Data: A4) ────┬─── LCD Display (0x27)\n                    │                       │\n                    └─── SCL (Clock: A5) ───┴─── DS3231 RTC Clock (0x68)\n```",
        "quickCheck": [
          {
            "questionId": "qc_l09_s01_q1",
            "question": "Why do engineers use communication buses like I2C instead of wiring dedicated pins to every sensor?",
            "options": [
              "To share two communication wires among dozens of devices without running out of pins",
              "Because wires are made of heavy rock",
              "To slow down robot reflexes"
            ],
            "correctIndex": 0,
            "explanation": "The I2C bus lets up to 127 devices share the exact same two wires (SDA and SCL) using unique 7-bit addresses!",
            "warmupExplanation": "Imagine having to run a separate road to every single house versus sharing a highway network. Buses share wires!"
          },
          {
            "questionId": "qc_l09_s01_q2",
            "question": "How does an Arduino talk to one specific sensor when multiple sensors share the same I2C wires?",
            "options": [
              "Each sensor has a unique numerical address it listens for",
              "The Arduino screams very loudly",
              "By cutting wires to other sensors"
            ],
            "correctIndex": 0,
            "explanation": "Every I2C sensor has an address (like a home postal address). When the Arduino announces that address, only that device answers!",
            "warmupExplanation": "In a classroom, when a teacher calls your name, you respond while other students listen politely."
          }
        ]
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
        "markdownContent": "- **I2C (Inter-Integrated Circuit):** A synchronous, multi-target, bidirectional communication bus developed by Philips Semiconductor.\n- **SDA (Serial Data):** The bidirectional line over which data bytes travel.\n- **SCL (Serial Clock):** The synchronizing clock pulse train generated exclusively by the Controller.\n- **Controller (Master):** The device that initiates bus communication and generates SCL clock pulses (the Uno).\n- **Target (Slave):** Peripheral devices listening on the bus, responding only when their unique 7-bit address is called.\n- **7-Bit Address:** A unique identifier allowing up to 128 devices to share the bus without wire conflicts.\n- **ACK / NACK:** Acknowledge (0) or Not Acknowledge (1) bit returned by a target device to confirm packet receipt.\n- **Open-Drain / Pull-Up:** Hardware architecture where lines are passively held at 5V by resistors and pulled to GND by transistors.\n\n### Interactive Circuit Lab: Open-Drain & Pull-Up Resistors\nTest the open-drain schematic below. Select different pull-up resistor values (proper 4.7kΩ vs missing vs weak 100kΩ) to observe waveform rise times and see why I2C lines cannot float!"
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
        "markdownContent": "- I2C coordinates up to 127 devices over two shared lines (`SDA` on A4, `SCL` on A5).\n- The Controller generates clock pulses; targets respond only to their unique 7-bit hex address.\n- Devices wire in parallel—share power, ground, clock, and data.\n- Up next in Lesson 10: Unleashing multi-megahertz bandwidth with the 4-wire SPI protocol."
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
                "128 (with ~112–119 usable addresses)",
                "256",
                "2"
              ],
              "correctIndex": 0,
              "explanation": "Correct: 128 (with ~112–119 usable addresses). Understanding this principle ensures proper circuit function and reliability."
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
        "markdownContent": "### Blazing Fast Bitstreams: When Milliseconds Matter\nWhile I2C is great for slow environmental sensors, streaming graphics to a color TFT display, reading megabytes from an SD card flight recorder, or interrogating a 13.56 MHz RFID badge demands raw speed. I2C caps out at 100 kHz or 400 kHz, but the SPI protocol runs at up to 8 MHz on the Arduino Uno—twenty times faster!\n\nIn this lesson, you will master the 4-wire synchronous protocol used for high-speed robotic telemetry and graphics.\n\n```\nMaster (Uno) ──── MOSI (Pin 11: Data Out) ───► Target (RFID / Matrix)\n             ◄─── MISO (Pin 12: Data In)  ────\n             ──── SCK  (Pin 13: Clock)    ───►\n             ──── CS   (Pin 10: Select)   ───►\n```",
        "quickCheck": [
          {
            "questionId": "qc_l10_s01_q1",
            "question": "When a robot needs to send visual graphics or audio data at ultra-high speed, which protocol is preferred?",
            "options": [
              "The high-speed synchronous SPI bus",
              "A slow tin-can telephone",
              "Sending letters by snail mail"
            ],
            "correctIndex": 0,
            "explanation": "SPI (Serial Peripheral Interface) offers dedicated clock and data lines reaching speeds up to tens of megahertz!",
            "warmupExplanation": "SPI is like an express bullet train for data: clock, transmit, and receive lines run at top speed simultaneously."
          },
          {
            "questionId": "qc_l10_s01_q2",
            "question": "In an SPI circuit, how does the Arduino select which peripheral device is active?",
            "options": [
              "By pulling that device's Chip Select (CS) pin LOW",
              "By flashing an LED",
              "By turning the power off"
            ],
            "correctIndex": 0,
            "explanation": "Each SPI device has a dedicated Chip Select (CS) line. Pulling CS LOW wakes the chip up to communicate!",
            "warmupExplanation": "Think of CS like tapping a friend on the shoulder: Hey, I am talking to you now!"
          }
        ]
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
        "markdownContent": "### Cut the Tether: Untethered Wireless Telemetry\nA robot tethered to a workbench by a USB cable cannot explore the world. To roam autonomously across terrain, monster robots must transmit telemetry data, video diagnostics, and receive directional steering commands wirelessly through the air.\n\nUART (Universal Asynchronous Receiver-Transmitter) is the universal language of microcontrollers, GPS receivers, radio transceivers, and cellular modems. In this lesson, you will build an asynchronous wireless bridge between your monster robot and your smartphone!\n\n```\nArduino Uno (5V) ─── Pin 11 (TX) ───[ 1kΩ ]───┬─── RXD (3.3V) ─── Bluetooth Module\n                                             │\n                                           [ 2kΩ ]\n                                             │\nArduino Uno (GND) ────────────────────────────┴─── GND ────────── Bluetooth Module\nArduino Uno (5V) ─── Pin 10 (RX) ───────────────── TXD ────────── Bluetooth Module\n```",
        "quickCheck": [
          {
            "questionId": "qc_l11_s01_q1",
            "question": "What does UART Serial communication use to send text messages and sensor logs to your computer?",
            "options": [
              "Two crossed wires: Transmit (TX) and Receive (RX)",
              "A string of tin cans",
              "A compass magnet"
            ],
            "correctIndex": 0,
            "explanation": "UART uses TX to transmit bytes out and RX to receive incoming bytes!",
            "warmupExplanation": "One person talks (TX) and the other person listens (RX). To hear back, you cross the wires so ears meet mouths!"
          },
          {
            "questionId": "qc_l11_s01_q2",
            "question": "Why must both devices in a UART connection use the exact same baud rate (like 9600)?",
            "options": [
              "So they agree on the timing speed of each individual bit",
              "Because computers refuse mismatched colors",
              "To save battery power"
            ],
            "correctIndex": 0,
            "explanation": "Baud rate defines bit transmission speed. If baud rates differ, data bytes arrive garbled!",
            "warmupExplanation": "If someone speaks in fast-forward and you listen at normal speed, words sound like gibberish. Baud rates must match."
          }
        ]
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
        "markdownContent": "Examine `comp_29` (HC-05 Bluetooth Module):\n1. **Pin Inspection:** Locate the header pins: `VCC`, `GND`, `TXD`, `RXD`, `STATE`, `EN`.\n2. **Power Wiring:** Connect Module `VCC` to Uno `5V`, and Module `GND` to Uno `GND`.\n3. **Receive Line (Direct):** Connect Module `TXD` (which outputs safe 3.3V logic) directly to Uno Digital Pin 10 (`SoftwareSerial RX`).\n4. **Transmit Line (Voltage Divider):** Uno Pin 11 outputs 5.0V, but the HC-05 RXD pin accepts only 3.3V maximum!\n   - Connect Uno Pin 11 to one leg of a 1kΩ resistor.\n   - Connect the other leg of the 1kΩ resistor to a breadboard node.\n   - Connect the breadboard node to HC-05 `RXD`.\n   - Connect a 2kΩ resistor from the breadboard node to `GND`.\n   - *Result: $V_{\\text{out}} = 5\\text{V} \\times \\frac{2\\text{k}\\Omega}{1\\text{k}\\Omega + 2\\text{k}\\Omega} = 3.33\\text{V}$ (perfect protection!).*\n\n### Interactive Breadboard Checker: TX/RX Cross-Wiring & Voltage Divider\nTest your serial wiring below to avoid the classic TX-to-TX beginner trap and verify that the 1kΩ / 2kΩ voltage divider protects delicate 3.3V wireless RX pins!"
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
        "markdownContent": "### High Current & Raw Power: The Muscle of Robotics\nRobots must move, climb, steer, and grip! But motors are hungry, violent electrical beasts. Unlike delicate LEDs that consume just 10 milliamps, motors contain heavy coils of copper wire that store magnetic energy. Connecting a motor directly to an Arduino pin will immediately fry the microcontroller or cause violent resets.\n\nIn this capstone lesson, you will master the physics of inductive kickback, flyback diode protection, and dual H-Bridge circuits to command high-power robotic actuators!\n\n```\nArduino Uno (5V Logic) ─── Pins 7, 8, 9 ───► L293D H-Bridge Driver IC ◄─── External 9V Battery\n                                                    │\n                                                    ▼\n                                            High-Power DC Motor\n```",
        "quickCheck": [
          {
            "questionId": "qc_l12_s01_q1",
            "question": "Why should electric motors NEVER be powered directly from an Arduino I/O pin?",
            "options": [
              "Motors draw much more current than an Arduino pin can safely supply and require a driver",
              "Motors are scared of pins",
              "Pins only produce cold air"
            ],
            "correctIndex": 0,
            "explanation": "Arduino pins are limited to 20 mA continuous (40 mA absolute max). In contrast, motor operating and stall currents easily exceed GPIO limits and need a motor driver (like L293D)!",
            "warmupExplanation": "An Arduino pin is like an AAA battery trying to launch a real rocket—it needs a motor driver helper to supply muscle power."
          },
          {
            "questionId": "qc_l12_s01_q2",
            "question": "What technique controls the speed of a DC motor using digital switching pulses?",
            "options": [
              "Pulse Width Modulation (PWM)",
              "Static electricity",
              "Wrapping tape around the axle"
            ],
            "correctIndex": 0,
            "explanation": "PWM rapidly switches power ON and OFF, varying the duty cycle to smoothly regulate motor speed!",
            "warmupExplanation": "By tapping the gas pedal faster or holding it down longer, you control how fast a car moves. That is PWM!"
          }
        ]
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
        "markdownContent": "Examine `comp_l293d` (16-pin Dual H-Bridge IC) and `comp_33` (DC Motor):\n1. **IC Notch Orientation:** Locate the semi-circular notch on the top of the L293D chip. Pin 1 is immediately to the left of the notch.\n2. **Pin Identification:**\n   - Pin 16 ($V_{CC1}$): Logic 5V (from Arduino 5V).\n   - Pin 8 ($V_{CC2}$): Motor Power (connect to external 6V–9V battery pack).\n   - Pins 4, 5, 12, 13: Ground heat-sink pins (connect to common Ground).\n   - Pin 1 (Enable 1): PWM speed input (connect to Uno PWM Pin 9).\n   - Pin 2 (Input 1): Direction Leg A (connect to Uno Pin 8).\n   - Pin 7 (Input 2): Direction Leg B (connect to Uno Pin 7).\n   - Pins 3 & 6 (Outputs 1 & 2): Connect directly to the two terminals of the DC motor.\n\n### Interactive Electrical Bench: Motor Power Isolation & Common Ground\nExplore why high-current motors (1-2A stall) cause severe brownout crashes when powered from the Arduino 5V regulator, and verify proper external battery power with a shared Common Ground!"
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
        "markdownContent": "- **Prediction 1:** What happens if you set both `in1Pin` and `in2Pin` to `HIGH` simultaneously?\n  *Answer:* Dynamic braking! Both motor terminals connect to the same voltage potential, causing motor back-EMF to brake the rotor quickly.\n- **Prediction 2:** What happens if you try to drive the motor with `analogWrite(enablePin, 20)` from a standstill?\n  *Answer:* The motor hums or whines but will not move due to static friction (stiction). Motors require a minimum threshold duty cycle (~60–80) to break friction."
      },
      {
        "stepId": "l12_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "interactiveWidgetType": "servoPulseWidthModulator",
        "markdownContent": "1. Wire the Potentiometer from Lesson 06 to `A0`.\n2. Map readings so:\n   - Full clockwise: Full speed forward.\n   - Center (512): Stopped.\n   - Full counter-clockwise: Full speed reverse.\n3. Test your custom robotic throttle control!\n\n### Interactive PWM Generator: 50Hz Servo Pulse Width Modulator\nAdjust the 50Hz PWM pulse width between 1.0ms (0°), 1.5ms (90°), and 2.0ms (180°) below to command the virtual servo horn with precise microsecond timing!"
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
                "Arduino pins provide only ~20mA, while motors require 300mA–1000mA+ and can destroy pin transistors",
                "Arduino digital pins output AC voltage",
                "The code would be too complex"
              ],
              "correctIndex": 0,
              "explanation": "Correct: Arduino pins provide only ~20mA, while motors require 300mA–1000mA+ and can destroy pin transistors. Understanding this principle ensures proper circuit function and reliability."
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
  },
  {
    "id": "l01_17",
    "title": "Course 1 Vocabulary Check",
    "summary": "Match the key words from Course 1 to their meanings. This quick check helps you warm up your memory before the final knowledge test.",
    "tier": "rookie",
    "estimatedMinutes": 8,
    "courseId": "lesson_01",
    "sortOrder": 17,
    "isOptional": false,
    "prerequisites": [
      "l01_16"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l01_17_s01",
        "title": "Vocabulary Match",
        "type": "physicalTask",
        "interactiveWidgetType": "vocabularyMatch",
        "markdownContent": "Match each word to its meaning. You will see up to four words at a time. Drag a word to its meaning, or tap a word and then tap its match.",
        "interactiveConfig": {
          "title": "Course 1 Vocabulary Check",
          "items": [
            {
              "term": "Sensor",
              "meaning": "A part that notices something, like light or a button press."
            },
            {
              "term": "Program",
              "meaning": "Instructions that tell a computer what to do."
            },
            {
              "term": "Microcontroller",
              "meaning": "A tiny computer chip that follows a program."
            },
            {
              "term": "Reset",
              "meaning": "Start the program again from the beginning."
            },
            {
              "term": "Processor",
              "meaning": "The part of the chip that follows instructions."
            },
            {
              "term": "Memory",
              "meaning": "A place where a computer keeps code or information."
            },
            {
              "term": "Input",
              "meaning": "Information going into the Arduino."
            },
            {
              "term": "Output",
              "meaning": "A signal or action coming out of the Arduino."
            },
            {
              "term": "Digital",
              "meaning": "A signal read as one of a few choices, such as HIGH or LOW."
            },
            {
              "term": "Analog",
              "meaning": "A measurement that can change across a range."
            },
            {
              "term": "Pin",
              "meaning": "A connection point for a wire or part."
            },
            {
              "term": "PWM",
              "meaning": "Fast on/off pulses that can control effects like LED brightness."
            },
            {
              "term": "Circuit",
              "meaning": "A complete path that lets electricity flow."
            },
            {
              "term": "Ground",
              "meaning": "The circuit’s shared reference and return connection."
            },
            {
              "term": "Condition",
              "meaning": "A question the code checks before choosing an action."
            },
            {
              "term": "If/else",
              "meaning": "Code that chooses what to do for two different cases."
            },
            {
              "term": "Upload",
              "meaning": "Send a program from a computer to the board."
            },
            {
              "term": "Predict",
              "meaning": "Say what you think will happen before a test."
            },
            {
              "term": "Observe",
              "meaning": "Carefully notice and record what happens."
            },
            {
              "term": "Troubleshoot",
              "meaning": "Check clues to find and fix a problem."
            },
            {
              "term": "Mismatch",
              "meaning": "Two things that should agree but do not."
            },
            {
              "term": "Current",
              "meaning": "The flow of electric charge."
            },
            {
              "term": "Short circuit",
              "meaning": "An unintended path that can let too much current flow."
            },
            {
              "term": "Board",
              "meaning": "The circuit board that holds a microcontroller and connectors."
            },
            {
              "term": "Compare",
              "meaning": "Look at how things are alike and different."
            },
            {
              "term": "Wireless",
              "meaning": "Sending information without a cable."
            },
            {
              "term": "Wi-Fi",
              "meaning": "A way for devices to connect to a network without wires."
            },
            {
              "term": "Voltage",
              "meaning": "The electrical push measured in volts."
            },
            {
              "term": "Level shifter",
              "meaning": "A part that changes a signal voltage to a safer level."
            },
            {
              "term": "Review",
              "meaning": "Look again at ideas you have already learned."
            },
            {
              "term": "Challenge",
              "meaning": "A task that lets you use what you know."
            }
          ]
        }
      }
    ],
    "xpReward": 10,
    "learningGoal": "Recall the important words from Course 1."
  },
  {
    "id": "l01_18",
    "title": "Course 1 Post-Test: Show What You Know",
    "summary": "Use what you learned about boards, signals, circuits, and safe connections. Take your time and show how much you remember.",
    "tier": "rookie",
    "estimatedMinutes": 8,
    "courseId": "lesson_01",
    "sortOrder": 18,
    "isOptional": false,
    "prerequisites": [
      "l01_17"
    ],
    "componentIds": [],
    "steps": [
      {
        "stepId": "l01_18_s01",
        "title": "Course 1 Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Answer each question to finish Course 1. Think about the ideas you practiced in the lessons.",
        "interactiveConfig": {
          "question": "What does a microcontroller board do in a robot?",
          "options": [
            "Reads inputs and controls outputs using code",
            "Stores the robot’s wheels",
            "Makes electricity from sunlight"
          ],
          "correctIndex": 0,
          "explanation": "The board runs code that reads inputs and controls outputs.",
          "questions": [
            {
              "question": "What does a microcontroller board do in a robot?",
              "options": [
                "Reads inputs and controls outputs using code",
                "Stores the robot’s wheels",
                "Makes electricity from sunlight"
              ],
              "correctIndex": 0,
              "explanation": "The board runs code that reads inputs and controls outputs."
            },
            {
              "question": "A sensor detects a button press. What is the button press?",
              "options": [
                "An input",
                "An output",
                "A power source"
              ],
              "correctIndex": 0,
              "explanation": "A button gives the board information, so it is an input."
            },
            {
              "question": "Which pin type is best for reading a simple HIGH or LOW signal?",
              "options": [
                "Digital pin",
                "Analog pin",
                "Ground pin"
              ],
              "correctIndex": 0,
              "explanation": "Digital pins read or send HIGH and LOW signals."
            },
            {
              "question": "What does an analog input help a board measure?",
              "options": [
                "A range of changing values",
                "Only two states: on or off",
                "The board’s name"
              ],
              "correctIndex": 0,
              "explanation": "Analog inputs can read a range of values, such as a changing sensor level."
            },
            {
              "question": "Why does an LED need a resistor in its circuit?",
              "options": [
                "To limit current and help protect the LED",
                "To make the LED read a button",
                "To store the program"
              ],
              "correctIndex": 0,
              "explanation": "A resistor limits current so too much current does not damage the LED."
            },
            {
              "question": "Why do circuit parts need a shared ground?",
              "options": [
                "It gives current a common return path",
                "It makes the board wireless",
                "It raises every signal to 5 volts"
              ],
              "correctIndex": 0,
              "explanation": "A shared ground gives the circuit a common reference and return path."
            },
            {
              "question": "How should you connect a 5V signal to a 3.3V-only input?",
              "options": [
                "Use suitable level protection, such as a level shifter",
                "Connect it directly every time",
                "Remove the ground wire"
              ],
              "correctIndex": 0,
              "explanation": "A 5V signal can damage a 3.3V-only input; use suitable level protection."
            },
            {
              "question": "In a simple robot system, what usually happens after an input is read?",
              "options": [
                "Code decides what to do, then an output responds",
                "The board forgets the input",
                "The sensor becomes the battery"
              ],
              "correctIndex": 0,
              "explanation": "The board reads an input, uses code to decide, and controls an output."
            }
          ]
        }
      }
    ],
    "xpReward": 25,
    "learningGoal": "Show that you can use Course 1 ideas about boards, inputs, outputs, circuits, and safety."
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
