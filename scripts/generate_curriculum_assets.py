#!/usr/bin/env python3
"""
Curriculum Asset Generator for Monster Lab.
Generates schema-compliant, data-driven JSON assets for:
- 7 foundational lessons
- 38 peripheral components
- 14 projects
- Challenges & Badges
- Root Curriculum Manifest
"""

import json
from pathlib import Path
from component_enrichments import COMPONENT_ENRICHMENTS
from project_enrichments import get_project_enrichment

ROOT = Path(__file__).resolve().parent.parent
CURRICULUM_DIR = ROOT / "assets" / "curriculum"
LESSONS_DIR = CURRICULUM_DIR / "lessons"
COMPONENTS_DIR = CURRICULUM_DIR / "components"
PROJECTS_DIR = CURRICULUM_DIR / "projects"
CHALLENGES_DIR = CURRICULUM_DIR / "challenges"
BADGES_DIR = CURRICULUM_DIR / "badges"

for d in [CURRICULUM_DIR, LESSONS_DIR, COMPONENTS_DIR, PROJECTS_DIR, CHALLENGES_DIR, BADGES_DIR]:
    d.mkdir(parents=True, exist_ok=True)

# -------------------------------------------------------------
# 1. Lessons Data
# -------------------------------------------------------------
LESSONS = [
    {
        "id": "lesson_01",
        "title": "What is Arduino & How Does It Work?",
        "summary": "Discover the brain of your robot! Learn what microcontrollers do, explore the pins, and understand how power flows.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": [],
        "componentIds": [],
        "steps": [
            {
                "stepId": "l01_s01",
                "title": "Meet the Monster Brain",
                "type": "story",
                "markdownContent": "Welcome to Monster Lab! The **Arduino Uno** is a microcontroller board—a tiny, rugged computer designed to interact directly with hardware in the physical world. Unlike desktop computers, it runs a dedicated program that loops continuously to sense inputs and command outputs."
            },
            {
                "stepId": "l01_s02",
                "title": "Inputs vs Outputs & The Decision Engine",
                "type": "visualExplanation",
                "interactiveWidgetType": "boardInspector",
                "markdownContent": "Robots follow a continuous loop: **Sensor → Arduino → Decision → Output**.\n\n- **Inputs (Senses)**: Pushbuttons, ultrasonic distance sensors, sound detectors, and potentiometers.\n- **Outputs (Actions)**: LEDs, buzzers, LCD screens, and motor drivers.\n- **The Program**: You write the code that decides how inputs turn into actions!"
            },
            {
                "stepId": "l01_s03",
                "title": "Digital vs Analog Signals",
                "type": "story",
                "markdownContent": "Microcontrollers understand two kinds of electrical information:\n\n- **Digital Signals**: Have distinct binary states—either `HIGH` (5.0V / ON) or `LOW` (0.0V / OFF).\n- **Analog Signals**: Vary smoothly across a continuous spectrum (like temperature, sound volume, or knob angle from 0V to 5V)."
            },
            {
                "stepId": "l01_s04",
                "title": "Pin Tour: Power and Ground Paths",
                "type": "physicalTask",
                "markdownContent": "Electricity must flow in a complete loop: **Power (5V) → Component → Ground (GND)**.\n\nInspect your physical Arduino Uno board:\n1. Locate the `5V` and `3.3V` power output pins.\n2. Locate the multiple `GND` (Ground) reference return sockets.\n3. Find Digital Pins `0` through `13` on the upper header.\n4. Find Analog In Pins `A0` through `A5` on the lower header.\n5. Spot the tiny amber `L` LED next to pin 13."
            },
            {
                "stepId": "l01_s05",
                "title": "Your First Instruction: Reading Code",
                "type": "codeExperiment",
                "markdownContent": "Before uploading sketches, engineers read and predict code line by line:\n\n```cpp\ndigitalWrite(13, HIGH);\n```\n\n- `digitalWrite`: The built-in command that controls a digital output pin.\n- `13`: The target pin connected to the built-in amber LED.\n- `HIGH`: Sets the pin to 5.0 Volts (turn on).\n- `;`: The semicolon terminates every C++ statement!"
            },
            {
                "stepId": "l01_s06",
                "title": "Knowledge Check",
                "type": "quizCheckpoint",
                "markdownContent": "What role does Ground (GND) play in an electrical circuit?",
                "interactiveConfig": {
                    "question": "What is Ground (GND)?",
                    "options": [
                        "A battery that provides unlimited power",
                        "The return path for electric current to complete the circuit",
                        "A sensor that measures dirt depth"
                    ],
                    "correctIndex": 1,
                    "questions": [
                        {
                            "question": "What is a microcontroller?",
                            "options": ["A small computer designed to control electronics", "A chemical battery", "A mechanical switch"],
                            "correctIndex": 0
                        },
                        {
                            "question": "A distance sensor sends distance readings to Arduino. Is it an input or output?",
                            "options": ["Input", "Output", "Power supply"],
                            "correctIndex": 0
                        },
                        {
                            "question": "An LED controlled by Arduino is an example of what?",
                            "options": ["Input", "Output", "Ground"],
                            "correctIndex": 1
                        },
                        {
                            "question": "What is GND used for in a typical circuit?",
                            "options": ["A common reference and return path", "Unlimited power", "Storing program code"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does HIGH represent in a simple digital output?",
                            "options": ["The output's high/on state (5V)", "A program error", "A sensor disconnect"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does 13 mean in digitalWrite(13, HIGH);?",
                            "options": ["The digital pin number being controlled", "The microcontroller clock speed", "Flash memory bytes"],
                            "correctIndex": 0
                        },
                        {
                            "question": "A potentiometer produces a smoothly changing voltage as it turns. Is this digital or analog?",
                            "options": ["Analog", "Digital only", "Neither"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why should you read and understand code before uploading it?",
                            "options": ["So you can predict behavior and troubleshoot problems", "Arduino deletes unverified sketches", "Every program must be memorized"],
                            "correctIndex": 0
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
        "prerequisites": ["lesson_01"],
        "componentIds": [],
        "steps": [
            {
                "stepId": "l02_s01",
                "title": "The Arduino IDE Workbench",
                "type": "story",
                "markdownContent": "To give life to your monster, you write programs in the **Arduino IDE** (Integrated Development Environment). The IDE brings together a code editor, a C++ compiler (AVR-GCC), and an automated flash loader (avrdude) into a single workbench."
            },
            {
                "stepId": "l02_s02",
                "title": "USB Cable Connection",
                "type": "physicalTask",
                "markdownContent": "Connect your physical hardware station:\n1. Plug the square USB Type-B cable into your Arduino Uno.\n2. Plug the USB Type-A connector into your computer.\n3. Look for the green `ON` LED illuminating solidly on the board.\n4. Observe the yellow `TX` and `RX` LEDs flash briefly as the computer enumerates the serial link."
            },
            {
                "stepId": "l02_s03",
                "title": "Select Board and Port",
                "type": "visualExplanation",
                "markdownContent": "Before code can be compiled and transferred, tell the IDE what hardware is attached:\n\n- **Select Board**: Open **Tools > Board > Arduino AVR Boards > Arduino Uno**.\n- **Select Port**: Open **Tools > Port** and pick the communication channel (e.g., `COM3` on Windows, or `/dev/cu.usbmodem...` on macOS/Linux).\n- The COM port represents the virtual serial stream connecting your computer's OS to the Uno's USB communication chip."
            },
            {
                "stepId": "l02_s04",
                "title": "Source Code vs Machine Language",
                "type": "story",
                "markdownContent": "Microcontrollers cannot read English or C++ directly. When you click **Verify**, the IDE compiler transforms your human-readable instructions into a stream of binary machine instructions (hexadecimal opcode bytes). When you click **Upload**, this binary program is flashed into the ATmega328P's 32 KB flash memory!"
            },
            {
                "stepId": "l02_s05",
                "title": "Verify and Upload Lifecycle",
                "type": "codeExperiment",
                "markdownContent": "The programming lifecycle follows five disciplined engineering steps:\n\n1. **Write**: Compose code in the editor.\n2. **Verify (Checkmark)**: Compile code to check for typos and syntax errors without touching hardware.\n3. **Upload (Right Arrow)**: Flash the compiled machine binary onto the board.\n4. **Observe**: Watch how the physical circuit and LEDs react.\n5. **Iterate**: Adjust timing, change pin behaviors, and re-test!"
            },
            {
                "stepId": "l02_s06",
                "title": "Connection Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "Which menu in the IDE lets you choose your Arduino board model?",
                "interactiveConfig": {
                    "question": "Where do you select your board?",
                    "options": ["Edit > Cut", "Tools > Board", "Help > About"],
                    "correctIndex": 1,
                    "questions": [
                        {
                            "question": "What does IDE stand for?",
                            "options": ["Integrated Development Environment", "Internal Digital Engine", "Internet Device Emulator"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which menu in the IDE lets you choose your Arduino board model?",
                            "options": ["Tools > Board", "File > Save", "Help > About"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the primary function of the Verify (checkmark) button?",
                            "options": ["Checks for syntax and type errors by compiling without uploading", "Physically uploads code to the Arduino", "Formats flash memory"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does the Upload (arrow) button do?",
                            "options": ["Compiles and flashes the program onto the board", "Deletes existing files", "Opens the serial monitor"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does a COM or serial port represent?",
                            "options": ["The virtual communication channel between computer and board", "An AC wall power socket", "A graphics rendering pipeline"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What LED indicates the Arduino is receiving electrical power?",
                            "options": ["The green ON LED", "The amber L LED", "The TX LED"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What software translates human-readable C++ into binary machine code?",
                            "options": ["The compiler", "The text editor", "The web browser"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What happens to the program stored in flash memory when USB power is disconnected?",
                            "options": ["It is safely preserved in non-volatile flash memory", "It is permanently erased", "It resets back to factory defaults"],
                            "correctIndex": 0
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
        "prerequisites": ["lesson_02"],
        "componentIds": [],
        "steps": [
            {
                "stepId": "l03_s01",
                "title": "What is a Library?",
                "type": "story",
                "markdownContent": "A library is a pre-written, reusable collection of C++ code created by experienced engineers. Instead of writing hundreds of lines of complex microsecond timing and register manipulation to talk to an LCD screen, a library lets you control it with simple commands like `lcd.print(\"Monster Lab!\");`."
            },
            {
                "stepId": "l03_s02",
                "title": "Using the Library Manager",
                "type": "visualExplanation",
                "markdownContent": "The Arduino IDE includes a built-in package repository:\n\n1. Open **Tools > Manage Libraries...** (or click the Library icon on the left tab bar).\n2. Search for the library name (e.g., `LiquidCrystal_I2C`).\n3. Click **Install**. The IDE downloads the header files (`.h`), source code (`.cpp`), and usage examples directly into your local library folder!"
            },
            {
                "stepId": "l03_s03",
                "title": "Inspecting the I2C LCD Backpack",
                "type": "physicalTask",
                "markdownContent": "Examine your 16x2 Character LCD (`comp_07`):\n1. Flip the display over and look at the black daughterboard soldered to its pins—this is the **I2C Backpack**.\n2. Notice how it reduces 16 individual parallel LCD pins down to just 4 wires: `GND`, `VCC`, `SDA`, and `SCL`.\n3. Find the blue square potentiometer on the backpack—this is the contrast trimmer that adjusts text readability!"
            },
            {
                "stepId": "l03_s04",
                "title": "Annotated Walkthrough: LiquidCrystal_I2C",
                "type": "codeExperiment",
                "markdownContent": "```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// Create LCD object at 7-bit hex address 0x27 (16 columns, 2 rows)\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();          // Initialize LCD hardware and I2C bus\n  lcd.backlight();     // Turn on backlight LED\n  lcd.setCursor(0, 0); // Column 0, Row 0\n  lcd.print(\"Monster Online!\");\n}\n\nvoid loop() {\n  // Static display\n}\n```"
            },
            {
                "stepId": "l03_s05",
                "title": "Library Quiz",
                "type": "quizCheckpoint",
                "markdownContent": "Why do roboticists use libraries?",
                "interactiveConfig": {
                    "question": "What is the primary benefit of libraries?",
                    "options": [
                        "They speed up code by writing complex hardware protocols for you",
                        "They replace the need for physical wires",
                        "They make the Arduino heavier"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What is the primary purpose of an Arduino library?",
                            "options": [
                                "They speed up code by writing complex hardware protocols for you",
                                "They double the CPU clock speed of the Arduino",
                                "They convert AC electricity into DC electricity"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which preprocessor directive imports a library header into a sketch?",
                            "options": ["#include <LibraryName.h>", "import LibraryName;", "using namespace LibraryName;"],
                            "correctIndex": 0
                        },
                        {
                            "question": "In LiquidCrystal_I2C lcd(0x27, 16, 2);, what does 0x27 represent?",
                            "options": ["The 7-bit hexadecimal I2C device address", "The digital pin connected to the screen", "The operating temperature in Celsius"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Where in the IDE can you search for and install community libraries?",
                            "options": ["Tools > Manage Libraries", "File > Preferences > Upload", "Help > Drivers"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What do the numbers (16, 2) specify in the LCD constructor?",
                            "options": ["16 columns and 2 rows of text", "16 volts and 2 amps", "16 MHz clock and 2 KB RAM"],
                            "correctIndex": 0
                        },
                        {
                            "question": "If your code compiles cleanly but the LCD shows solid white boxes, what should you adjust?",
                            "options": ["The blue contrast potentiometer on the backpack", "Reinstall the Arduino IDE", "Replace the Uno microcontroller"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why does an I2C backpack save wiring compared to standard parallel LCDs?",
                            "options": ["It reduces required data pins from 10+ down to 2 shared bus lines", "It eliminates the need for power and ground", "It transmits over Wi-Fi"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What file extension designates C++ header files in libraries?",
                            "options": [".h", ".ino", ".hex"],
                            "correctIndex": 0
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
        "summary": "Explore sketch anatomy: the one-time setup() routine and the infinite loop(). Learn Verify and Upload.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_02"],
        "componentIds": [],
        "steps": [
            {
                "stepId": "l04_s01",
                "title": "The Two Heartbeats: setup() and loop()",
                "type": "story",
                "markdownContent": "Unlike computer apps that terminate, a robot's brain must never quit. An Arduino sketch has two mandatory architectural functions:\n\n- `void setup()`: Executes **exactly once** when power is applied or the reset button is pressed. Used for configuring pin modes, establishing serial baud rates, and initializing sensors.\n- `void loop()`: Executes **continuously and repeatedly forever**. Houses sensing, decision logic, and actuator commands."
            },
            {
                "stepId": "l04_s02",
                "title": "Syntax Anatomy: Blocks and Semicolons",
                "type": "visualExplanation",
                "markdownContent": "Arduino C++ programs follow strict punctuation grammar:\n\n- **Statements**: Every executable command must end with a semicolon `;`.\n- **Functions**: Group reusable blocks of code inside curly braces `{}`.\n- **Comments**: Notes ignored by the compiler. Single-line comments start with `//`, and block comments span `/* ... */`."
            },
            {
                "stepId": "l04_s03",
                "title": "Board Tour: TX/RX LEDs and Reset Switch",
                "type": "physicalTask",
                "markdownContent": "Locate hardware feedback indicators on your Uno:\n1. Find the small red or yellow **Reset** momentary switch in the corner.\n2. Locate the surface-mount LEDs labeled `TX` (Transmit) and `RX` (Receive) near digital pins 0 and 1.\n3. Connect USB and press Reset—notice how the board restarts and TX/RX flash as the bootloader handshakes with the computer."
            },
            {
                "stepId": "l04_s04",
                "title": "Serial Monitor at 9600 Baud",
                "type": "codeExperiment",
                "markdownContent": "```cpp\nvoid setup() {\n  Serial.begin(9600); // Initialize UART communication at 9600 baud\n  Serial.println(\"--- Monster Lab Station Online ---\");\n}\n\nvoid loop() {\n  Serial.print(\"Heartbeat timestamp: \");\n  Serial.println(millis()); // Print milliseconds since boot\n  delay(1000);              // Wait 1 second before repeating\n}\n```\n\nOpen **Tools > Serial Monitor** and set the bottom-right dropdown to **9600 baud** to view real-time diagnostics."
            },
            {
                "stepId": "l04_s05",
                "title": "Sketch Anatomy Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "How many times does code inside void setup() run?",
                "interactiveConfig": {
                    "question": "How often does setup() execute?",
                    "options": [
                        "Exactly once on startup or reset",
                        "Every millisecond",
                        "Only when you press a button"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "How many times does code inside void setup() execute after startup?",
                            "options": ["Exactly once", "Exactly ten times", "Continuously in an infinite loop"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the primary role of void loop() in an Arduino robot?",
                            "options": [
                                "To repeatedly execute sensing, decision-making, and actuator control forever",
                                "To shut down the Arduino when code finishes",
                                "To format the flash memory"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What character must terminate every standard C++ statement in Arduino?",
                            "options": ["Semicolon (;)", "Colon (:)", "Period (.)"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does the Verify (checkmark) button in the IDE do?",
                            "options": [
                                "Compiles the sketch to check for syntax and type errors without uploading",
                                "Physically tests the Arduino hardware circuits",
                                "Deletes existing code from the board"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "If your code specifies Serial.begin(9600), what baud rate must the Serial Monitor be set to?",
                            "options": ["9600 baud", "115200 baud", "Any baud rate works automatically"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the purpose of curly braces { } in code?",
                            "options": [
                                "They group multiple statements together into a single function or block",
                                "They represent mathematical multiplication",
                                "They indicate comments ignored by the compiler"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What function is used to send text to the Serial Monitor followed by a new line?",
                            "options": ["Serial.println()", "Serial.write()", "Serial.input()"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What happens if delay(1000) is omitted from a loop() that prints text?",
                            "options": [
                                "The loop runs at maximum CPU speed, flooding the serial buffer and monitor",
                                "The Arduino overheats and shuts off",
                                "The compiler refuses to upload the code"
                            ],
                            "correctIndex": 0
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
        "summary": "Take control of physical photons! Toggle digital outputs with digitalWrite() and master delay() timing.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_04"],
        "componentIds": ["comp_uno"],
        "steps": [
            {
                "stepId": "l05_s01",
                "title": "Digital HIGH vs LOW & Push-Pull Drivers",
                "type": "story",
                "markdownContent": "Software commands physical electrons through digital output pins:\n\n- `HIGH` = **5.0 Volts** (internal P-FET connects pin to 5V rail; sources current).\n- `LOW` = **0.0 Volts** (internal N-FET connects pin to Ground; sinks current).\n\nBefore an output pin can drive current, you must configure its silicon driver into low-impedance mode by calling `pinMode(pin, OUTPUT);` inside `setup()`."
            },
            {
                "stepId": "l05_s02",
                "title": "The Built-In LED (Pin 13 'L')",
                "type": "physicalTask",
                "markdownContent": "Inspect your Arduino Uno hardware:\n1. Look between Digital Pin 13 and the ATmega328P microcontroller chip.\n2. Find the tiny rectangular surface-mount amber LED labeled with silkscreen `L`.\n3. Trace the fine copper trace on the PCB leading from Pin 13 through an onboard 1kΩ SMD resistor to the LED.\n4. You can control this light without plugging in a single external jumper wire!"
            },
            {
                "stepId": "l05_s03",
                "title": "The Blink Code",
                "type": "codeExperiment",
                "interactiveWidgetType": "blinkSimulator",
                "markdownContent": "```cpp\nconst int ledPin = 13;\n\nvoid setup() {\n  pinMode(ledPin, OUTPUT); // Configure Pin 13 as a low-impedance output\n}\n\nvoid loop() {\n  digitalWrite(ledPin, HIGH); // Turn LED ON (5V)\n  delay(1000);                // Wait 1000 ms (1 second)\n  digitalWrite(ledPin, LOW);  // Turn LED OFF (0V)\n  delay(1000);                // Wait 1000 ms (1 second)\n}\n```"
            },
            {
                "stepId": "l05_s04",
                "title": "Persistence of Vision & Current Limits",
                "type": "story",
                "markdownContent": "Two critical physical principles govern microcontroller LEDs:\n\n- **Persistence of Vision**: If an LED is toggled faster than 50 times per second (`delay(10)`), human retina cone cells cannot detect the dark interval—the LED appears steadily illuminated at reduced brightness.\n- **Current Limits**: An ATmega328P output pin can supply a maximum of **20 mA** continuous current. Never wire an external LED directly to a pin without a 220Ω–1kΩ current-limiting resistor!"
            },
            {
                "stepId": "l05_s05",
                "title": "Timing Challenge",
                "type": "quizCheckpoint",
                "markdownContent": "What does delay(500) do?",
                "interactiveConfig": {
                    "question": "What is delay(500)?",
                    "options": [
                        "Waits for half a second (500 milliseconds)",
                        "Waits for 500 seconds",
                        "Increases voltage by 500 millivolts"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What voltage level does digitalWrite(pin, HIGH) produce on an Arduino Uno?",
                            "options": ["5.0 Volts", "0.0 Volts", "12.0 Volts"],
                            "correctIndex": 0
                        },
                        {
                            "question": "How many milliseconds are in 1.5 seconds?",
                            "options": ["1500 ms", "150 ms", "15 ms"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why must you call pinMode(pin, OUTPUT) before writing to a pin?",
                            "options": [
                                "To switch internal pin transistors from high-impedance listening to active voltage driving",
                                "To supply 12V to the USB port",
                                "To download the sketch to EEPROM"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which digital pin on the Arduino Uno is wired directly to the on-board amber 'L' LED?",
                            "options": ["Pin 13", "Pin 0", "Pin A0"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What visual phenomenon causes an LED flashing at 100 Hz to appear continuously solid?",
                            "options": ["Persistence of vision", "Capacitive filtering", "Inductive kickback"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What happens if you omit the delay() between turning the LED OFF and turning it back ON in loop()?",
                            "options": [
                                "The LED turns back on so quickly the off-state is imperceptible",
                                "The microcontroller halts",
                                "The LED burns out"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the maximum safe continuous current that should be drawn from an Uno I/O pin?",
                            "options": ["Approximately 20 mA", "5 Amps", "500 mA"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does digitalWrite(pin, LOW) connect the output pin to internally?",
                            "options": ["Ground (0V reference)", "5V power supply", "Analog-to-digital converter"],
                            "correctIndex": 0
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
        "summary": "Convert physical rotation into digital numbers! Discover the 10-bit Analog to Digital Converter (ADC).",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_05"],
        "componentIds": ["comp_20"],
        "steps": [
            {
                "stepId": "l06_s01",
                "title": "Analog vs Digital Signals",
                "type": "story",
                "markdownContent": "The physical world is not binary. Temperature rises smoothly, sound levels swell, and robotic arms rotate through infinite angles. To perceive these gradients, microcontrollers use **Analog Inputs** (`A0`–`A5`) to measure continuous voltages between 0.0V and 5.0V."
            },
            {
                "stepId": "l06_s02",
                "title": "The Voltage Divider Knob",
                "type": "visualExplanation",
                "markdownContent": "A potentiometer (`comp_20`) is a variable resistor with 3 pins:\n\n- **Outer Pin 1**: Connected to `5V`.\n- **Outer Pin 3**: Connected to `GND`.\n- **Center Wiper Pin 2**: Slides across a resistive carbon track as you turn the knob, outputting a proportional voltage fraction according to the voltage divider formula: $V_{out} = 5.0\\text{V} \\times \\frac{R_2}{R_1 + R_2}$."
            },
            {
                "stepId": "l06_s03",
                "title": "Breadboard Wiring",
                "type": "interactiveWiring",
                "markdownContent": "Construct your circuit on the breadboard:\n1. Insert the potentiometer across 3 separate terminal rows (e.g. Rows 10, 11, 12).\n2. Connect outer pin 1 to Uno `5V`.\n3. Connect outer pin 3 to Uno `GND`.\n4. Connect center wiper pin 2 to Uno Analog Pin `A0`."
            },
            {
                "stepId": "l06_s04",
                "title": "ADC Math (0 to 1023)",
                "type": "codeExperiment",
                "interactiveWidgetType": "potentiometerSimulator",
                "markdownContent": "```cpp\nconst int potPin = A0;\n\nvoid setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int rawValue = analogRead(potPin);         // 10-bit ADC conversion (0 to 1023)\n  float voltage = rawValue * (5.0 / 1023.0); // Convert count to true voltage\n\n  Serial.print(\"ADC: \");\n  Serial.print(rawValue);\n  Serial.print(\" | Voltage: \");\n  Serial.print(voltage, 2);\n  Serial.println(\" V\");\n  delay(200);\n}\n```\n\nThe Uno's 10-bit Successive Approximation ADC provides $2^{10} = 1024$ measurement steps (~4.88 mV per step)!"
            },
            {
                "stepId": "l06_s05",
                "title": "Analog Perception Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "What range of integer values is returned by analogRead() on an Arduino Uno?",
                "interactiveConfig": {
                    "question": "What is the range of analogRead()?",
                    "options": ["0 to 1023", "0 to 255", "-512 to +512"],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What range of integer values is returned by analogRead() on an Arduino Uno?",
                            "options": ["0 to 1023", "0 to 255", "-512 to +512"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the resolution of the built-in ADC on an Arduino Uno?",
                            "options": ["10-bit (1024 discrete levels)", "8-bit (256 discrete levels)", "16-bit (65536 discrete levels)"],
                            "correctIndex": 0
                        },
                        {
                            "question": "If analogRead(A0) returns 1023, what voltage is present on pin A0?",
                            "options": ["5.0 Volts", "2.5 Volts", "10.23 Volts"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which terminal of a standard 3-pin potentiometer connects to the variable wiper?",
                            "options": ["The middle terminal", "The leftmost terminal", "The mounting metal tab"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What electrical circuit principle does a potentiometer utilize to produce variable voltage?",
                            "options": ["Voltage divider", "Inductive coupling", "Rectification"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Approximately how many millivolts does each single ADC step represent on a 5V Uno?",
                            "options": ["~4.88 mV (5.0V / 1024)", "~100 mV", "~0.01 mV"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why is pinMode(A0, INPUT) not strictly mandatory before calling analogRead(A0)?",
                            "options": [
                                "analogRead() automatically switches the pin multiplexer to ADC input mode",
                                "Analog pins cannot be configured as digital pins",
                                "The Arduino detects hardware connections automatically"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What causes an analog input reading to jump erratically when nothing is touched?",
                            "options": [
                                "A floating input wire acting as an antenna picking up electromagnetic interference",
                                "A dead microcontroller battery",
                                "Excessively high baud rate"
                            ],
                            "correctIndex": 0
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
        "summary": "Harness Pulse Width Modulation (PWM) and additive color physics to generate millions of custom hues.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_05"],
        "componentIds": [],
        "steps": [
            {
                "stepId": "l07_s01",
                "title": "Additive Optics: Red, Green, Blue",
                "type": "story",
                "markdownContent": "An RGB LED packages three independent semiconductor dies (Red, Green, Blue) into a single 5mm lens. By combining these three primary wavelengths of light at varying intensities, additive optics stimulates human retina cone cells to synthesize over 16 million colors:\n\n- Red + Green = **Yellow**\n- Green + Blue = **Cyan**\n- Red + Blue = **Magenta / Purple**\n- Red + Green + Blue = **White**"
            },
            {
                "stepId": "l07_s02",
                "title": "Pulse Width Modulation (PWM) & Duty Cycle",
                "type": "visualExplanation",
                "markdownContent": "Because digital pins can only output 5V or 0V, the Uno simulates intermediate voltages using **Pulse Width Modulation (PWM)**—pulsing the output hundreds of times per second (~490 Hz).\n\n- **Duty Cycle**: The percentage of time the square wave stays HIGH in one period.\n- Look for the tilde `~` symbol next to PWM pins: `3`, `5`, `6`, `9`, `10`, `11`!"
            },
            {
                "stepId": "l07_s03",
                "title": "Common Cathode Lead Identification",
                "type": "physicalTask",
                "markdownContent": "Inspect a 4-pin Common Cathode RGB LED:\n1. Find the longest lead—this is the **Common Cathode (GND)**.\n2. The isolated pin on one side of the cathode is **Red**.\n3. The two pins on the other side are **Green** and **Blue**.\n4. Insert into breadboard. Connect Cathode to `GND`, and place a 220Ω resistor on Red, Green, and Blue leading to PWM pins `9`, `10`, and `11`."
            },
            {
                "stepId": "l07_s04",
                "title": "analogWrite() Color Studio",
                "type": "codeExperiment",
                "interactiveWidgetType": "rgbMixer",
                "markdownContent": "```cpp\nconst int redPin = 9;\nconst int greenPin = 10;\nconst int bluePin = 11;\n\nvoid setColor(int r, int g, int b) {\n  analogWrite(redPin, constrain(r, 0, 255));\n  analogWrite(greenPin, constrain(g, 0, 255));\n  analogWrite(bluePin, constrain(b, 0, 255));\n}\n\nvoid setup() {\n  pinMode(redPin, OUTPUT);\n  pinMode(greenPin, OUTPUT);\n  pinMode(bluePin, OUTPUT);\n}\n\nvoid loop() {\n  setColor(255, 0, 255); // Purple (Red + Blue)\n  delay(1000);\n  setColor(255, 120, 0); // Monster Amber\n  delay(1000);\n  setColor(0, 255, 255); // Cyan (Green + Blue)\n  delay(1000);\n}\n```"
            },
            {
                "stepId": "l07_s05",
                "title": "Color Mixing Quiz",
                "type": "quizCheckpoint",
                "markdownContent": "What color do you get if you mix Red at 255 and Green at 255 (with Blue at 0)?",
                "interactiveConfig": {
                    "question": "Red + Green light makes what color?",
                    "options": ["Yellow", "Cyan", "Magenta"],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What does PWM stand for?",
                            "options": ["Pulse Width Modulation", "Power Wave Measurement", "Phase Wire Multiplication"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the valid argument range for analogWrite() on an Arduino Uno?",
                            "options": ["0 to 255 (8-bit)", "0 to 1023 (10-bit)", "0 to 100 (%)"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which digital pins on the Arduino Uno support hardware PWM?",
                            "options": [
                                "Pins marked with a tilde (~): 3, 5, 6, 9, 10, 11",
                                "All digital pins 0 through 13",
                                "Only analog pins A0 through A5"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What primary colors of light combine to produce Yellow?",
                            "options": ["Red and Green", "Blue and Yellow", "Red and Blue"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What duty cycle percentage does an analogWrite() value of 127 produce?",
                            "options": ["Approximately 50%", "10%", "100%"],
                            "correctIndex": 0
                        },
                        {
                            "question": "On a 4-pin common cathode RGB LED, what does the longest lead connect to?",
                            "options": ["Ground (GND)", "5V Power", "Digital Pin 13"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why does an LED appear dimmer when fed a 25% duty cycle PWM signal?",
                            "options": [
                                "The LED is off for 75% of the time, and the human eye averages the photon emission",
                                "The voltage is reduced from 5V to 1.25V DC",
                                "The resistor value increases dynamically"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What primary colors combine to produce Cyan?",
                            "options": ["Green and Blue", "Red and Blue", "Red and Green"],
                            "correctIndex": 0
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
        "summary": "Sense physical button presses without phantom triggers! Learn the secret of INPUT_PULLUP and debouncing.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_05"],
        "componentIds": [],
        "steps": [
            {
                "stepId": "l08_s01",
                "title": "Buttons and Open Circuits",
                "type": "story",
                "markdownContent": "Robots need bump switches and limit sensors to detect physical collisions. A momentary tactile pushbutton is a mechanical bridge: when pressed, two internal metal contacts connect, completing a circuit path."
            },
            {
                "stepId": "l08_s02",
                "title": "The Floating Pin Trap",
                "type": "visualExplanation",
                "markdownContent": "Microcontroller input pins have enormous internal resistance (>100 MΩ). If an input is not firmly connected to either 5V or GND, it **floats** like an open antenna, picking up 60Hz wall hum and electrostatic fields, causing random false triggers!\n\nTo prevent this, every digital input must be tied to a stable reference voltage using a pull-up or pull-down resistor."
            },
            {
                "stepId": "l08_s03",
                "title": "Pushbutton Breadboard Placement",
                "type": "physicalTask",
                "markdownContent": "Wire a tactile pushbutton using active-low logic:\n1. Place the 4-pin button so it straddles the center divider trench of your breadboard.\n2. Connect one terminal to Uno Digital Pin `2`.\n3. Connect the opposite terminal to Uno `GND`.\n4. *Notice: No 5V wire or external resistor is needed on the breadboard!*"
            },
            {
                "stepId": "l08_s04",
                "title": "INPUT_PULLUP to the Rescue",
                "type": "codeExperiment",
                "markdownContent": "```cpp\nconst int buttonPin = 2;\nconst int ledPin = 13;\n\nvoid setup() {\n  pinMode(buttonPin, INPUT_PULLUP); // Enable ATmega328P built-in 30k pullup\n  pinMode(ledPin, OUTPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int state = digitalRead(buttonPin);\n  if (state == LOW) { // Active-Low: Pressed shorts pin to GND\n    digitalWrite(ledPin, HIGH);\n    Serial.println(\"BUMP DETECTED!\");\n  } else {\n    digitalWrite(ledPin, LOW);\n  }\n}\n```"
            },
            {
                "stepId": "l08_s05",
                "title": "Pullup Logic Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "When using INPUT_PULLUP, what value does digitalRead() return when the button is NOT pressed?",
                "interactiveConfig": {
                    "question": "What is the unpressed state with INPUT_PULLUP?",
                    "options": ["HIGH (5V)", "LOW (0V)", "Random values"],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What state does a pin configured with INPUT_PULLUP read when the button is open (unpressed)?",
                            "options": ["HIGH", "LOW", "Floating"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is a 'floating' digital pin?",
                            "options": [
                                "An unconnected high-impedance input that fluctuates randomly from electromagnetic noise",
                                "A pin submerged in water",
                                "A pin configured as both input and output simultaneously"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why is INPUT_PULLUP preferred for simple pushbutton circuits?",
                            "options": [
                                "It eliminates the need for an external physical resistor on the breadboard",
                                "It makes buttons click louder",
                                "It allows buttons to operate over Wi-Fi"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "When using active-low logic with a pull-up, what value indicates the button is pressed?",
                            "options": ["LOW (0)", "HIGH (1)", "1023"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What physical phenomenon causes a single mechanical button press to register multiple times?",
                            "options": ["Switch bounce (contact chatter)", "Inductive kickback", "Serial overflow"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Approximately what resistance value does the ATmega328P internal pull-up provide?",
                            "options": ["20kΩ to 50kΩ", "1Ω", "10MΩ"],
                            "correctIndex": 0
                        },
                        {
                            "question": "How should a momentary button be wired when using INPUT_PULLUP?",
                            "options": [
                                "One terminal to the digital pin, the other terminal to GND",
                                "One terminal to 5V, the other to 12V",
                                "One terminal to A0, the other to 3.3V"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "In robotics, why are emergency limit switches typically wired active-low?",
                            "options": [
                                "Fail-safe protection: if a wire breaks, the system detects it immediately as triggered",
                                "To save battery power",
                                "It reduces code size"
                            ],
                            "correctIndex": 0
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
        "summary": "Network dozens of sensors and displays using only two wires: SDA and SCL! Master addresses and bus scanning.",
        "tier": "builder",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_03", "lesson_04"],
        "componentIds": ["comp_07", "comp_10"],
        "steps": [
            {
                "stepId": "l09_s01",
                "title": "Why Buses Save Wires",
                "type": "story",
                "markdownContent": "If every sensor, display, clock, and keypad required dedicated pins, an Arduino Uno would run out of pins after adding 3 devices. With the **I2C** (Inter-Integrated Circuit) bus, up to 127 unique peripheral devices share the exact same two wires without interfering with each other!"
            },
            {
                "stepId": "l09_s02",
                "title": "SDA, SCL, and 7-Bit Hex Addresses",
                "type": "visualExplanation",
                "markdownContent": "The I2C bus uses two open-drain signal lines:\n\n- **SDA (Serial Data)**: Transfers data bytes bidirectionally (on Pin `A4`).\n- **SCL (Serial Clock)**: Synchronizing clock ticks generated by the Controller (on Pin `A5`).\n- **7-Bit Hex Address**: Every module has a unique address (e.g. `0x27` for LCDs, `0x68` for Real Time Clocks). The Uno broadcasts the address before transmitting data, and only the matching chip responds with an ACK bit!"
            },
            {
                "stepId": "l09_s03",
                "title": "Parallel Bus Breadboard Wiring",
                "type": "physicalTask",
                "markdownContent": "Wire the 16x2 LCD (`comp_07`) and DS3231 RTC (`comp_10`) in parallel:\n1. Connect both module `VCC` pins to Uno `5V`.\n2. Connect both module `GND` pins to Uno `GND`.\n3. Connect BOTH module `SDA` pins to Uno Pin `A4`.\n4. Connect BOTH module `SCL` pins to Uno Pin `A5`."
            },
            {
                "stepId": "l09_s04",
                "title": "The Wire Library & Bus Scanner",
                "type": "codeExperiment",
                "markdownContent": "```cpp\n#include <Wire.h>\n\nvoid setup() {\n  Wire.begin(); // Join I2C bus as Controller\n  Serial.begin(9600);\n  Serial.println(\"--- I2C Hardware Bus Scanner ---\");\n}\n\nvoid loop() {\n  for (byte addr = 1; addr < 127; addr++) {\n    Wire.beginTransmission(addr);\n    if (Wire.endTransmission() == 0) {\n      Serial.print(\"Discovered device at address: 0x\");\n      if (addr < 16) Serial.print(\"0\");\n      Serial.println(addr, HEX);\n    }\n  }\n  Serial.println(\"Scan complete.\\n\");\n  delay(5000);\n}\n```"
            },
            {
                "stepId": "l09_s05",
                "title": "I2C Bus Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "How many communication signal wires does the I2C bus use to talk to multiple devices?",
                "interactiveConfig": {
                    "question": "How many signal wires does I2C use?",
                    "options": [
                        "2 wires (SDA and SCL)",
                        "8 wires (one for each bit)",
                        "14 wires"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What are the names of the two communication lines used by the I2C protocol?",
                            "options": [
                                "SDA (Serial Data) and SCL (Serial Clock)",
                                "TX (Transmit) and RX (Receive)",
                                "MOSI and MISO"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which pins on the standard Arduino Uno serve as hardware SDA and SCL?",
                            "options": ["A4 (SDA) and A5 (SCL)", "Pin 0 and Pin 1", "Pin 11 and Pin 12"],
                            "correctIndex": 0
                        },
                        {
                            "question": "Theoretically, how many unique addresses can be represented by standard 7-bit I2C?",
                            "options": ["128 (with ~112–119 usable addresses)", "256", "2"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What component generates the synchronizing clock pulses on the SCL line?",
                            "options": ["The Controller (Master) device", "The Target (Slave) device", "The pull-up resistor"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What signal does a target device return to confirm receipt of an address or data byte?",
                            "options": ["ACK (Acknowledge) bit", "Reset pulse", "12V spike"],
                            "correctIndex": 0
                        },
                        {
                            "question": "How are multiple I2C devices physically connected to the Arduino?",
                            "options": [
                                "In parallel: all SDA lines connect together, all SCL lines connect together",
                                "In a daisy chain from output to input",
                                "Each device requires its own unique Arduino pin"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What happens if two devices with the identical address (e.g. 0x27) are wired to the same I2C bus?",
                            "options": [
                                "Address collision: both devices try to drive the data line at the same time, corrupting data",
                                "The Arduino automatically changes one of their addresses",
                                "The devices share the reading 50/50"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which built-in Arduino library is used to communicate with I2C devices?",
                            "options": ["<Wire.h>", "<SPI.h>", "<Serial.h>"],
                            "correctIndex": 0
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
        "summary": "Transmit megabits per second to displays and radios with 4-wire SPI (MOSI, MISO, SCK, CS).",
        "tier": "engineer",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_09"],
        "componentIds": ["comp_15", "comp_23", "comp_31"],
        "steps": [
            {
                "stepId": "l10_s01",
                "title": "When Speed Matters: SPI vs I2C",
                "type": "story",
                "markdownContent": "While I2C is great for slow environmental sensors, streaming graphics to a dot matrix display or reading radio packets at 2.4 GHz requires raw bandwidth. **SPI** (Serial Peripheral Interface) operates at up to **8 MHz** on an Arduino Uno—twenty times faster than standard I2C!"
            },
            {
                "stepId": "l10_s02",
                "title": "The 4 SPI Lines & Shift Registers",
                "type": "visualExplanation",
                "markdownContent": "SPI communicates via 4 dedicated synchronous lines:\n\n- `MOSI` (Pin 11): **Master Out, Slave In** (Uno to module)\n- `MISO` (Pin 12): **Master In, Slave Out** (Module to Uno)\n- `SCK` (Pin 13): **Serial Clock** (Generated by Uno to latch bits)\n- `CS / SS` (Pin 10): **Chip Select** (Pulled LOW to wake a specific peripheral)\n\nSPI is **Full-Duplex**: data shifts out on MOSI at the exact same instant incoming data shifts in on MISO!"
            },
            {
                "stepId": "l10_s03",
                "title": "Module Header Pinout Inspection",
                "type": "physicalTask",
                "markdownContent": "Inspect your high-speed peripherals:\n1. Examine the MAX7219 8x8 Dot Matrix (`comp_15`) and RC522 RFID module (`comp_23`).\n2. Locate the header labels: find `MOSI` (or `DIN`), `MISO` (or `DOUT`), `SCK` (or `CLK`), and `CS` (or `SS`/`SDA`).\n3. Note: On Uno R3, hardware SPI pins are fixed to Pins 11, 12, 13, plus any digital pin for Chip Select."
            },
            {
                "stepId": "l10_s04",
                "title": "Chip Select (CS) Control & SPI.transfer()",
                "type": "codeExperiment",
                "markdownContent": "```cpp\n#include <SPI.h>\n\nconst int csPin = 10;\n\nvoid setup() {\n  pinMode(csPin, OUTPUT);\n  digitalWrite(csPin, HIGH); // De-select target initially\n  SPI.begin();               // Initialize SCK(13), MOSI(11), MISO(12)\n  Serial.begin(9600);\n}\n\nbyte exchangeData(byte regAddress, byte value) {\n  digitalWrite(csPin, LOW);         // 1. Select peripheral\n  SPI.transfer(regAddress);          // 2. Transmit register\n  byte response = SPI.transfer(value); // 3. Full-duplex exchange\n  digitalWrite(csPin, HIGH);        // 4. Release bus\n  return response;\n}\n\nvoid loop() {\n  byte resp = exchangeData(0x00, 0xFF);\n  Serial.println(resp, HEX);\n  delay(2000);\n}\n```"
            },
            {
                "stepId": "l10_s05",
                "title": "SPI Line Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "Which SPI line carries data FROM the peripheral BACK to the Arduino?",
                "interactiveConfig": {
                    "question": "Which line sends data to Arduino?",
                    "options": [
                        "MISO (Master In Slave Out)",
                        "MOSI (Master Out Slave In)",
                        "SCK (Serial Clock)"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What does SPI stand for?",
                            "options": ["Serial Peripheral Interface", "System Power Interconnect", "Synchronous Packet Integration"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What does the term 'Full-Duplex' mean in SPI communication?",
                            "options": [
                                "Data can be transmitted and received at the exact same instant",
                                "Only one device can transmit at a time",
                                "Data transmits twice for redundancy"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which line transmits data from the Arduino Master to the peripheral target?",
                            "options": ["MOSI (Master Out Slave In)", "MISO (Master In Slave Out)", "SCK (Serial Clock)"],
                            "correctIndex": 0
                        },
                        {
                            "question": "How does the Arduino Master select which peripheral to talk to on an SPI bus?",
                            "options": [
                                "By pulling that specific device's Chip Select (CS) line LOW",
                                "By broadcasting an I2C hex address",
                                "By increasing the voltage to 12V"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Which hardware pins on an Arduino Uno serve as MOSI, MISO, and SCK?",
                            "options": ["Pin 11 (MOSI), Pin 12 (MISO), Pin 13 (SCK)", "Pin 0, Pin 1, Pin 2", "Pin A4, Pin A5, Pin A6"],
                            "correctIndex": 0
                        },
                        {
                            "question": "If you add 3 SPI devices to your Arduino, how many shared lines and dedicated lines do you need?",
                            "options": [
                                "3 shared lines (MOSI, MISO, SCK) and 3 dedicated CS lines",
                                "12 individual wires",
                                "Only 2 wires total"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "In comparison to I2C, what is the main advantage of the SPI protocol?",
                            "options": [
                                "Significantly higher data transfer speeds and simple shift-register hardware",
                                "Uses fewer wires",
                                "Transmits over long distances (kilometers)"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What electrical problem occurs if two SPI peripherals share the same CS line?",
                            "options": [
                                "MISO bus contention: both peripherals attempt to drive the data return line simultaneously",
                                "The Arduino clock stops",
                                "The memory is wiped"
                            ],
                            "correctIndex": 0
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
        "summary": "Connect Arduinos to computers, Bluetooth modules, and GPS with asynchronous TX/RX serial streams.",
        "tier": "engineer",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_04"],
        "componentIds": ["comp_29"],
        "steps": [
            {
                "stepId": "l11_s01",
                "title": "Asynchronous Streams & Baud Framing",
                "type": "story",
                "markdownContent": "To roam untethered across terrain, robots transmit commands wirelessly using **UART** (Universal Asynchronous Receiver-Transmitter). Unlike I2C or SPI, UART is **asynchronous**—there is no shared clock line! Both devices agree on a precise bit frequency (the **Baud Rate**, such as 9600 bits per second) and synchronize on the falling edge of a Start Bit."
            },
            {
                "stepId": "l11_s02",
                "title": "Crossed Wires: TX to RX",
                "type": "visualExplanation",
                "markdownContent": "The golden wiring rule of UART serial is to **cross the lines**:\n\n- Arduino `TX` (Transmit) connects to Module `RX` (Receive).\n- Module `TX` connects to Arduino `RX`.\n- Pins `0` and `1` are hardwired to the onboard USB chip. To avoid USB upload collisions, we use the `<SoftwareSerial.h>` library to create virtual serial ports on pins `10` and `11`!"
            },
            {
                "stepId": "l11_s03",
                "title": "Voltage Divider Protection for 3.3V RX",
                "type": "physicalTask",
                "markdownContent": "Examine the HC-05 Bluetooth Module (`comp_29`):\n1. Module `TXD` outputs safe 3.3V logic—connect directly to Uno Pin `10` (`SoftwareSerial RX`).\n2. Module `RXD` cannot tolerate 5.0V! Build a resistor divider on breadboard:\n   - Connect Uno Pin `11` (`TX`) to a 1kΩ resistor.\n   - Connect the resistor to a node wired to Module `RXD`.\n   - Connect a 2kΩ resistor from the node to `GND`.\n   - Voltage drops safely: $5\\text{V} \\times \\frac{2\\text{k}\\Omega}{1\\text{k}\\Omega + 2\\text{k}\\Omega} = 3.33\\text{V}$!"
            },
            {
                "stepId": "l11_s04",
                "title": "SoftwareSerial Bidirectional Bridge",
                "type": "codeExperiment",
                "markdownContent": "```cpp\n#include <SoftwareSerial.h>\n\nSoftwareSerial bluetooth(10, 11); // RX, TX\n\nvoid setup() {\n  Serial.begin(9600);    // USB Serial to computer\n  bluetooth.begin(9600); // Wireless UART to Bluetooth\n  Serial.println(\"--- Telemetry Bridge Active ---\");\n}\n\nvoid loop() {\n  if (bluetooth.available()) {\n    Serial.write(bluetooth.read()); // Phone -> Computer\n  }\n  if (Serial.available()) {\n    bluetooth.write(Serial.read()); // Computer -> Phone\n  }\n}\n```"
            },
            {
                "stepId": "l11_s05",
                "title": "UART Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "What happens if two devices attempt to communicate with mismatched baud rates (e.g. 9600 vs 115200)?",
                "interactiveConfig": {
                    "question": "What happens when baud rates do not match?",
                    "options": [
                        "Garbled characters or complete silence",
                        "The board gets too hot",
                        "The code fails to compile"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What does UART stand for?",
                            "options": [
                                "Universal Asynchronous Receiver-Transmitter",
                                "Ultra Analog Radio Transceiver",
                                "Unified Automated Robotic Telemetry"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the golden wiring rule for connecting two UART serial devices?",
                            "options": [
                                "Cross the data lines: TX connects to RX, and RX connects to TX",
                                "Connect TX to TX, and RX to RX",
                                "Connect both lines to Ground"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why is UART called 'asynchronous'?",
                            "options": [
                                "There is no shared clock line; timing is governed entirely by agreed baud rates",
                                "It only works when the microcontroller is asleep",
                                "Signals are sent in reverse order"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why should you avoid connecting external hardware to Digital Pins 0 and 1 on an Uno?",
                            "options": [
                                "Pins 0 and 1 are shared with the onboard USB-to-serial chip used for flashing code",
                                "They have no power supply",
                                "They only support 1.8V"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the purpose of the SoftwareSerial library?",
                            "options": [
                                "It allows ordinary digital pins to emulate hardware UART serial ports",
                                "It compresses sketches to save flash memory",
                                "It encrypts wireless data"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why is a voltage divider needed between an Uno TX pin and a 3.3V Bluetooth module RX pin?",
                            "options": [
                                "To step down the 5V Arduino signal to prevent overvoltage damage to the 3.3V module",
                                "To speed up data transmission",
                                "To filter out radio interference"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What method checks how many bytes are waiting in the serial receive buffer?",
                            "options": ["available()", "read()", "length()"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What happens if the transmitter and receiver are configured with mismatched baud rates?",
                            "options": [
                                "Bits are sampled at incorrect intervals, resulting in corrupt or unreadable data",
                                "The microcontroller shuts off",
                                "The hardware catches fire"
                            ],
                            "correctIndex": 0
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
        "summary": "Harness high-power inductors! Control motor speed with pulse width modulation and protect pins with flyback diodes.",
        "tier": "engineer",
        "estimatedMinutes": 22,
        "prerequisites": ["lesson_06", "lesson_07"],
        "componentIds": ["comp_33", "comp_36"],
        "steps": [
            {
                "stepId": "l12_s01",
                "title": "Inductive Coils & Magnetic Fields",
                "type": "story",
                "markdownContent": "Motors and relays contain coils of copper wire that generate magnetic fields to produce mechanical torque. But motors are inductive loads: an ATmega328P output pin can only supply 20mA, while a stalled DC motor draws **500mA to 2000mA**! Attempting to power a motor directly from an Arduino pin will destroy its internal driver transistors."
            },
            {
                "stepId": "l12_s02",
                "title": "The Flyback Diode Protector",
                "type": "visualExplanation",
                "markdownContent": "According to Lenz's Law ($V = -L \\frac{di}{dt}$), when current flowing through a motor coil is abruptly cut, the collapsing magnetic field generates a massive reverse voltage spike called **inductive kickback** (>60 Volts!).\n\nA reverse-biased **Flyback Diode** placed across the coil safely recirculates this spike, dissipating the inductive energy harmlessly as heat instead of frying your microcontroller."
            },
            {
                "stepId": "l12_s03",
                "title": "H-Bridge IC Pinout & Common Ground",
                "type": "physicalTask",
                "markdownContent": "Inspect the L293D Dual H-Bridge IC (`comp_l293d`):\n1. Locate the semi-circular notch on top of the DIP-16 chip. Pin 1 is to the left of the notch.\n2. **Pin 16 ($V_{CC1}$)**: Logic 5V (from Arduino 5V).\n3. **Pin 8 ($V_{CC2}$)**: Motor Power (connect to separate external 6V–9V battery pack).\n4. **Pins 4, 5, 12, 13**: Connect to common Ground.\n5. **CRITICAL**: Always connect the external motor battery Ground to the Arduino Ground to establish a shared 0V reference!"
            },
            {
                "stepId": "l12_s04",
                "title": "L293D Bidirectional Motor Control",
                "type": "codeExperiment",
                "markdownContent": "```cpp\nconst int enablePin = 9; // PWM Speed Control\nconst int in1Pin = 8;    // Direction Leg A\nconst int in2Pin = 7;    // Direction Leg B\n\nvoid driveMotor(int speed, bool forward) {\n  digitalWrite(in1Pin, forward ? HIGH : LOW);\n  digitalWrite(in2Pin, forward ? LOW : HIGH);\n  analogWrite(enablePin, constrain(speed, 0, 255));\n}\n\nvoid stopMotor() {\n  digitalWrite(in1Pin, LOW);\n  digitalWrite(in2Pin, LOW);\n  analogWrite(enablePin, 0);\n}\n\nvoid setup() {\n  pinMode(enablePin, OUTPUT);\n  pinMode(in1Pin, OUTPUT);\n  pinMode(in2Pin, OUTPUT);\n}\n\nvoid loop() {\n  driveMotor(200, true);  // Forward ~78% speed\n  delay(2000);\n  stopMotor();\n  delay(1000);\n  driveMotor(200, false); // Reverse\n  delay(2000);\n  stopMotor();\n  delay(1000);\n}\n```"
            },
            {
                "stepId": "l12_s05",
                "title": "Flyback Checkpoint",
                "type": "quizCheckpoint",
                "markdownContent": "Why do engineers install a flyback diode across DC motor and relay coils?",
                "interactiveConfig": {
                    "question": "What is the purpose of a flyback diode?",
                    "options": [
                        "To absorb high-voltage inductive kickback spikes when the coil shuts off",
                        "To make the motor spin backwards",
                        "To turn battery power into AC wall electricity"
                    ],
                    "correctIndex": 0,
                    "questions": [
                        {
                            "question": "What causes inductive kickback spikes when a motor is suddenly turned off?",
                            "options": [
                                "The collapsing magnetic field in the motor's copper coils induces a high reverse voltage",
                                "The battery releases excess chemical energy",
                                "Static electricity on the motor casing"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What is the primary function of a flyback diode connected across an inductive load?",
                            "options": [
                                "To safely clamp and dissipate high-voltage inductive kickback spikes",
                                "To make the motor spin twice as fast",
                                "To convert AC voltage to DC voltage"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why can you NOT power a standard DC hobby motor directly from an Arduino digital pin?",
                            "options": [
                                "Arduino pins provide only ~20mA, while motors require 300mA–1000mA+ and can destroy pin transistors",
                                "Arduino digital pins output AC voltage",
                                "The code would be too complex"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "What circuit architecture allows a microcontroller to reverse a motor's rotation direction?",
                            "options": ["An H-Bridge circuit", "A voltage divider", "A low-pass filter"],
                            "correctIndex": 0
                        },
                        {
                            "question": "What electrical problem occurs if you fail to connect the motor battery ground to Arduino ground?",
                            "options": [
                                "No shared reference voltage: control signals float and the motor driver cannot interpret logic states",
                                "The battery explodes",
                                "The Arduino executes code at half speed"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why does an Arduino often crash or reset if a motor is wired directly to its 5V pin?",
                            "options": [
                                "Brownout reset: the sudden motor inrush current pulls the 5V rail voltage below the microcontroller operating limit",
                                "Software stack overflow",
                                "Flash memory corruption"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "In an H-bridge driver, what happens if both high-side and low-side switches on the same leg turn on simultaneously?",
                            "options": [
                                "Shoot-through short circuit that burns out the transistors",
                                "The motor doubles its torque",
                                "The motor switches to generator mode"
                            ],
                            "correctIndex": 0
                        },
                        {
                            "question": "Why does a DC motor hum but refuse to turn at very low PWM values (e.g. 15 out of 255)?",
                            "options": [
                                "Static mechanical friction (stiction) requires a minimum threshold torque to overcome",
                                "The PWM frequency is too high for electricity to flow",
                                "The Arduino compiler ignores values below 20"
                            ],
                            "correctIndex": 0
                        }
                    ]
                }
            }
        ],
        "xpReward": 100
    }
]

# -------------------------------------------------------------
# 2. Components Data (38 Peripherals)
# -------------------------------------------------------------
COMPONENTS_RAW = [
    (1, "HC-SR04", "HC-SR04", "sensor", "Ultrasonic Distance Sensor", "Like a bat's echolocation ears! Emits high-frequency ultrasonic chirps and measures the echo return time.", "v5",
     [("VCC", "power", "5V Power"), ("TRIG", "digitalOut", "Trigger pulse send"), ("ECHO", "digitalIn", "Echo pulse receive"), ("GND", "ground", "Ground")],
     "hc-sr04_ultrasonic_module_user_guidejohn .pdf", "safe", [], None, False, ["proj_01", "proj_11"]),

    (2, "KY-037", "KY-037", "sensor", "High-Sensitivity Sound Sensor", "Like an ear! Detects acoustic pressure waves with an electret condenser microphone and LM358 amplifier.", "dual",
     [("VCC", "power", "Power (3.3V-5V)"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital trigger output"), ("A0", "analogIn", "Raw analog acoustic waveform")],
     "Arduino KY-037 Sensitive microphone sensor module.pdf", "safe", [], None, False, ["proj_02"]),

    (3, "HC-SR501", "HC-SR501", "sensor", "PIR Motion Sensor", "Like thermal vision! Senses shifts in infrared heat radiated by moving human or animal bodies.", "dual",
     [("VCC", "power", "Power (4.5V-12V)"), ("OUT", "digitalIn", "Digital motion trigger (3.3V logic)"), ("GND", "ground", "Ground")],
     "HC-SR501.pdf", "safe", [], None, False, ["proj_01"]),

    (4, "Crash Switch", "KW11", "switch", "Impact Collision Switch", "Like a robot bumper! Mechanical microswitch that triggers immediately upon physical collision.", "dual",
     [("VCC", "power", "Power rail"), ("OUT", "digitalIn", "Normally Open switch contact"), ("GND", "ground", "Ground")],
     "Button.pdf", "safe", [], None, False, ["proj_13", "proj_17"]),

    (5, "Photogate", "ITR9608", "sensor", "Photo Interrupter Sensor", "Like an invisible tripwire! Infrared beam between two posts detects when an object breaks the beam.", "dual",
     [("VCC", "power", "Power rail"), ("OUT", "digitalIn", "Optical break trigger"), ("GND", "ground", "Ground")],
     "CDS-55 Photoresistor.pdf", "safe", [], None, False, ["proj_19"]),

    (6, "4x4 Matrix Keypad", "MEM-4X4", "switch", "16-Button Membrane Keypad", "Like a bank vault keypad! 16 tactile keys multiplexed into 8 pins using row-column matrix scanning.", "dual",
     [("R1", "digitalOut", "Row 1"), ("R2", "digitalOut", "Row 2"), ("R3", "digitalOut", "Row 3"), ("R4", "digitalOut", "Row 4"),
      ("C1", "digitalIn", "Col 1"), ("C2", "digitalIn", "Col 2"), ("C3", "digitalIn", "Col 3"), ("C4", "digitalIn", "Col 4")],
     "4x4-Matrix-Membrane-Keypad.pdf", "safe", [], None, False, ["proj_04", "proj_07"]),

    (7, "1602 I2C LCD", "LCD1602-PCF8574", "display", "16x2 Character LCD with I2C", "Like a digital nametag! Displays 32 letters/numbers over a simple two-wire I2C communication bus.", "v5",
     [("GND", "ground", "Ground"), ("VCC", "power", "5V Power"), ("SDA", "i2c", "I2C Data line (A4)"), ("SCL", "i2c", "I2C Clock line (A5)")],
     "1602 I2C LCD.pdf", "safe", [], None, False, ["proj_05", "proj_06", "proj_07", "proj_10", "proj_11", "proj_12", "proj_13", "proj_15", "proj_18"]),

    (8, "BMP180", "GY-68", "sensor", "Barometric Pressure & Altitude", "Like a weather barometer! Senses atmospheric weight and calculates elevation above sea level.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("SCL", "i2c", "I2C Clock"), ("SDA", "i2c", "I2C Data")],
     "RM-MPU-6050A.pdf", "safe", [], None, False, ["proj_12", "proj_20"]),

    (9, "DHT11", "DHT11", "sensor", "Temperature & Humidity Sensor", "Like an electronic weather forecaster! Measures air moisture and temperature digitally.", "dual",
     [("VCC", "power", "Power rail"), ("DATA", "digitalIn", "Single-wire digital data"), ("NC", "passive", "No connection"), ("GND", "ground", "Ground")],
     "DHT11 .pdf", "safe", [], None, False, ["proj_12", "proj_15", "proj_20"]),

    (10, "DS3231 RTC", "DS3231", "sensor", "High-Precision Real Time Clock", "Like a battery-powered wristwatch for your Arduino! Never forgets the second, minute, or year even when unplugged.", "dual",
     [("32K", "digitalOut", "32kHz clock out"), ("SQW", "digitalOut", "Square wave / Interrupt"), ("SCL", "i2c", "I2C Clock"), ("SDA", "i2c", "I2C Data"), ("VCC", "power", "Power"), ("GND", "ground", "Ground")],
     "DS3231.pdf", "safe", [], None, False, ["proj_05"]),

    (11, "Flame Sensor", "YG1006", "sensor", "Infrared Flame Detector", "Like fire eyes! Detects the invisible 760nm to 1100nm infrared spectrum radiating from flames.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital fire threshold"), ("A0", "analogIn", "Analog flame intensity")],
     "IR-Receiver-AX-1838HS .pdf", "caution", ["Sensitive to heat and fire sources"], "Simulate with an infrared LED or flashlight", False, ["proj_11"]),

    (12, "MPU-6050", "GY-521", "sensor", "6-Axis Gyroscope & Accelerometer", "Like the inner ear of an acrobat! Measures tilt angles, gravity vector, and rotational spin speed.", "dual",
     [("VCC", "power", "Power (3.3V-5V)"), ("GND", "ground", "Ground"), ("SCL", "i2c", "I2C Clock"), ("SDA", "i2c", "I2C Data"), ("XDA", "i2c", "Auxiliary I2C Data"), ("XCL", "i2c", "Auxiliary I2C Clock"), ("AD0", "digitalIn", "I2C address select"), ("INT", "digitalIn", "Motion interrupt")],
     "RM-MPU-6050A.pdf", "safe", [], None, False, ["proj_13"]),

    (13, "IR Remote & Receiver", "AX-1838HS", "communication", "Infrared Remote & Receiver Kit", "Like a television remote! Sends pulses of invisible 38kHz infrared light encoded with button commands.", "dual",
     [("OUT", "digitalIn", "Demodulated data pulse"), ("GND", "ground", "Ground"), ("VCC", "power", "Power rail")],
     "IR Remote Control.pdf", "safe", [], None, False, ["proj_03"]),

    (14, "Line Tracker", "TCRT5000", "sensor", "Infrared Line Tracking Sensor", "Like robot road navigation! Bounces infrared light off the ground to distinguish white roads from black tape.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital line threshold"), ("A0", "analogIn", "Analog reflection value")],
     "IR-Receiver-AX-1838HS .pdf", "safe", [], None, False, ["proj_17"]),

    (15, "MAX7219 8x8 Matrix", "MAX7219", "display", "8x8 Dot Matrix LED Display", "Like a retro arcade screen! 64 individually addressable bright red LEDs for faces, icons, and text.", "v5",
     [("VCC", "power", "5V Power"), ("GND", "ground", "Ground"), ("DIN", "spi", "Serial Data in"), ("CS", "spi", "Chip Select / Load"), ("CLK", "spi", "Serial Clock")],
     "MAX7219 8x8 Matrix Display Module.pdf", "safe", [], None, False, ["proj_03"]),

    (16, "MQ-3 Gas Sensor", "MQ-3", "sensor", "Alcohol Vapor Gas Sensor", "Chemical vapor nose! Uses a heated tin-dioxide element to detect alcohol vapors in air.", "v5",
     [("VCC", "power", "5V Power (150mA heater)"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital alarm threshold"), ("A0", "analogIn", "Analog vapor concentration")],
     None, "restrictedAdultSupervision", ["Heated metal mesh reaches high temperature (burn hazard)", "Requires adult supervision"], "Use rubbing alcohol swab at distance; never inhale", True, ["proj_06"]),

    (17, "MQ-9 Gas Sensor", "MQ-9", "sensor", "Combustible Gas & CO Sensor", "Industrial safety nose! Detects carbon monoxide and flammable hydrocarbon gas leaks.", "v5",
     [("VCC", "power", "5V Power (150mA heater)"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital trigger threshold"), ("A0", "analogIn", "Analog gas concentration")],
     None, "restrictedAdultSupervision", ["Active internal heating coil", "Testing with live gas sources is strictly prohibited without adults"], "Simulate with a potentiometer or test with safe unlit lighter puff under adult eye", True, ["proj_06"]),

    (18, "IR Obstacle Sensor", "FC-51", "sensor", "Infrared Obstacle Proximity Sensor", "Like a blind person's cane! Bounces short-range infrared light off nearby obstacles to avoid collisions.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("OUT", "digitalIn", "Active LOW obstacle detect")],
     "IR-Receiver-AX-1838HS .pdf", "safe", [], None, False, ["proj_11", "proj_13"]),

    (19, "Photoresistor", "CDS-55", "sensor", "Light Dependent Resistor (LDR)", "Like a pupil! Resistance drops dramatically when light hits it, allowing light level tracking.", "dual",
     [("PIN1", "passive", "Resistor terminal 1"), ("PIN2", "passive", "Resistor terminal 2")],
     "CDS-55 Photoresistor.pdf", "safe", [], None, False, ["proj_12", "proj_16"]),

    (20, "Potentiometer", "WH148", "passive", "10k Rotary Potentiometer", "Like a physical volume knob! Creates a smooth voltage divider from 0 to 5 volts as you turn it.", "dual",
     [("1", "passive", "5V End terminal"), ("2", "analogIn", "Center Wiper (Variable voltage)"), ("3", "passive", "Ground End terminal")],
     "Potentiometers.pdf", "safe", [], None, False, ["proj_08", "proj_18"]),

    (21, "PS2 Joystick", "KY-023", "sensor", "Dual-Axis Analog Joystick Module", "Like a gaming controller thumbstick! Contains two potentiometers (X and Y) and a tactile push button.", "v5",
     [("GND", "ground", "Ground"), ("+5V", "power", "5V Power"), ("VRx", "analogIn", "Horizontal X-Axis (0-1023)"), ("VRy", "analogIn", "Vertical Y-Axis (0-1023)"), ("SW", "digitalIn", "Pushbutton switch")],
     "JOYSTICK MODULE.pdf", "safe", [], None, False, ["proj_08"]),

    (22, "Rain Sensor", "FC-37", "sensor", "Raindrop Detection Plate", "Like an umbrella sensor! Interleaved copper traces short together when raindrops fall on the plate.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital rain threshold"), ("A0", "analogIn", "Analog water coverage")],
     "Water Level Sensor.pdf", "safe", [], None, False, ["proj_12"]),

    (23, "RC522 RFID Kit", "RC522", "communication", "13.56MHz RFID Reader & Card", "Like a contactless hotel keycard! Transmits electromagnetic radio waves to read smart tags.", "v3_3",
     [("3.3V", "power", "3.3V Power ONLY"), ("RST", "digitalOut", "Reset pin"), ("GND", "ground", "Ground"), ("IRQ", "digitalIn", "Interrupt request"), ("MISO", "spi", "SPI Master In Slave Out"), ("MOSI", "spi", "SPI Master Out Slave In"), ("SCK", "spi", "SPI Clock"), ("SDA/NSS", "spi", "Chip Select")],
     "MFRC522 Datasheet.pdf", "safe", [], None, False, ["proj_09"]),

    (24, "Rotary Encoder", "KY-040", "sensor", "Quadrature Rotary Encoder", "Like an endless digital knob! Outputs quadrature pulses to measure clicks, speed, and direction of rotation.", "v5",
     [("GND", "ground", "Ground"), ("+", "power", "5V Power"), ("SW", "digitalIn", "Pushbutton switch"), ("DT", "digitalIn", "Encoder Channel B"), ("CLK", "digitalIn", "Encoder Channel A")],
     "Rotary Encoder module.pdf", "safe", [], None, False, ["proj_10"]),

    (25, "SG90 Micro Servo", "SG90", "actuator", "9g Micro Position Servo Motor", "Like a robotic elbow! Rotates to exact angular positions from 0 to 180 degrees using PWM pulses.", "v5",
     [("Brown", "ground", "Ground"), ("Red", "power", "5V Power"), ("Orange", "digitalOut", "PWM Control signal (50Hz)")],
     "Servo SG90.pdf", "safe", [], None, False, ["proj_04", "proj_07", "proj_09", "proj_10", "proj_11", "proj_12", "proj_13", "proj_14"]),

    (26, "Soil Moisture Sensor", "FC-28", "sensor", "Soil Moisture Dual-Probe Sensor", "Like a thirsty plant alarm! Measures electrical conductivity between two soil probes.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("D0", "digitalIn", "Digital moisture threshold"), ("A0", "analogIn", "Analog resistance")],
     "Water Level Sensor.pdf", "safe", [], None, False, ["proj_15"]),

    (27, "Stepper Motor & ULN2003", "28BYJ-48", "actuator", "4-Phase Geared Stepper & Driver", "Like clockwork gears! Steps precisely 2048 steps per full revolution with high torque.", "v5",
     [("VCC", "power", "5V External Power"), ("GND", "ground", "Ground"), ("IN1", "digitalOut", "Phase 1"), ("IN2", "digitalOut", "Phase 2"), ("IN3", "digitalOut", "Phase 3"), ("IN4", "digitalOut", "Phase 4")],
     "28BYJ-48 Stepper Motor.pdf", "safe", [], None, False, ["proj_08", "proj_10", "proj_13"]),

    (28, "Vibration Sensor", "SW-420", "sensor", "High-Sensitivity Vibration Switch", "Like an earthquake detector! A spring contact shakes open when vibration or shock is detected.", "dual",
     [("VCC", "power", "Power rail"), ("GND", "ground", "Ground"), ("DO", "digitalIn", "Digital vibration output")],
     "Tilt Switch.pdf", "safe", [], None, False, ["proj_01"]),

    (29, "HC-05 Bluetooth", "HC-05", "communication", "UART Bluetooth Serial Module", "Like a wireless serial cable! Links your phone or computer to the Arduino using Bluetooth radio.", "dual",
     [("VCC", "power", "Power (3.6V-6V)"), ("GND", "ground", "Ground"), ("TXD", "uart", "UART Serial Transmit"), ("RXD", "uart", "UART Serial Receive (3.3V logic)"), ("STATE", "digitalIn", "Connection state"), ("EN", "digitalOut", "AT command mode enable")],
     "IR-Receiver-AX-1838HS .pdf", "safe", [], None, False, ["proj_18"]),

    (30, "W5100 Ethernet Shield", "W5100", "communication", "SPI Ethernet Controller Shield", "Like a robot internet jack! Plugs directly onto Arduino to connect to LAN networks and the web.", "v5",
     [("STACKABLE", "spi", "Standard Arduino SPI shield headers")],
     "UNO Proto Shield Expansion Board.pdf", "safe", [], None, False, ["proj_20"]),

    (31, "NRF24L01+ Transceiver", "NRF24L01+", "communication", "2.4GHz Wireless Radio Transceiver", "Like walkie-talkies for microcontrollers! Sends packet data wirelessly over 2.4GHz ISM band.", "v3_3",
     [("GND", "ground", "Ground"), ("VCC", "power", "3.3V Power ONLY"), ("CE", "digitalOut", "Chip Enable"), ("CSN", "spi", "SPI Chip Select"), ("SCK", "spi", "SPI Clock"), ("MOSI", "spi", "SPI Master Out"), ("MISO", "spi", "SPI Master In"), ("IRQ", "digitalIn", "Interrupt request")],
     "RM-MPU-6050A.pdf", "caution", ["Requires strictly regulated 3.3V; 5V will permanently destroy module"], "Always connect VCC to 3.3V pin with 10uF filter capacitor", False, ["proj_14"]),

    (32, "7-Segment Display", "5161AS", "display", "Digital 7-Segment LED Display", "Like a digital alarm clock number! 8 LEDs arranged to illuminate any digit from 0 to 9 plus a decimal point.", "v5",
     [("A", "passive", "Segment A"), ("B", "passive", "Segment B"), ("C", "passive", "Segment C"), ("D", "passive", "Segment D"), ("E", "passive", "Segment E"), ("F", "passive", "Segment F"), ("G", "passive", "Segment G"), ("DP", "passive", "Decimal point"), ("COM", "ground", "Common Cathode")],
     "1 digit 7-segment Display .pdf", "safe", [], None, False, ["proj_19"]),

    (33, "130 DC Motor", "130-DC", "actuator", "High-Speed Toy DC Motor", "Like an electric fan propeller! Spins continuously when power is applied, controllable via H-Bridge.", "v5",
     [("+", "power", "Motor terminal 1"), ("-", "ground", "Motor terminal 2")],
     "130 DC Motor.pdf", "safe", [], None, False, ["proj_08", "proj_17"]),

    (34, "Piezo Buzzer", "B-1205", "actuator", "Active & Passive Piezo Buzzer", "Like a monster voice! Vibrates a piezo ceramic disc to emit beeps, songs, and alarm sounds.", "v5",
     [("+", "power", "Positive terminal"), ("-", "ground", "Negative terminal")],
     "Active buzzer.pdf", "safe", [], None, False, ["proj_01", "proj_04", "proj_05", "proj_06", "proj_11", "proj_15", "proj_16"]),

    (35, "Water Level Sensor", "WL-10", "sensor", "10-Trace Resistive Depth Probe", "Like a water dipstick! Ten parallel copper traces detect liquid immersion depth by electrical resistance.", "dual",
     [("+", "power", "Power rail"), ("-", "ground", "Ground"), ("S", "analogIn", "Analog depth level (A0)")],
     "Water Level Sensor.pdf", "safe", [], None, False, ["proj_12"]),

    (36, "5V Relay Module", "SRD-05VDC", "actuator", "1-Channel Optocoupled 5V Relay", "Like a heavy-duty electric light switch! Uses an electromagnet to safely switch external high-current circuits.", "v5",
     [("VCC", "power", "5V Power"), ("GND", "ground", "Ground"), ("IN", "digitalOut", "Optocoupled control trigger")],
     "5V Relay.pdf", "restrictedAdultSupervision", ["High voltage switching hazard if connected to mains AC", "Adult supervision required"], "Use only with low voltage DC (batteries under 12V); NEVER connect to 120V/240V wall outlets", True, ["proj_15"]),

    (37, "KY-008 Laser Diode", "KY-008", "actuator", "650nm Red Laser Diode Module", "Like a sci-fi targeting beam! Concentrated 650nm red optical laser diode for security tripwires.", "v5",
     [("Signal", "digitalOut", "Laser toggle (HIGH = On)"), ("-", "ground", "Ground")],
     "Button.pdf", "caution", ["Direct eye exposure to laser beam can cause retinal injury"], "Never look directly into laser aperture; use target reflective paper only", False, ["proj_11", "proj_16"]),

    (38, "Hall Effect Sensor", "3144", "sensor", "Magnetic Field Hall Effect Sensor", "Like a magnetic compass detector! Senses proximity of permanent magnetic fields (neodymium magnets).", "v5",
     [("VCC", "power", "Power (4.5V-24V)"), ("GND", "ground", "Ground"), ("OUT", "digitalIn", "Digital magnetic presence trigger")],
     "Button.pdf", "safe", [], None, False, ["proj_19"]),

    (39, "Arduino Uno R3", "ATmega328P", "microcontroller", "Arduino Uno R3", "The flagship central brain of Monster Lab. Features 14 digital I/O pins, 6 analog inputs, a 16MHz clock, and a USB interface.", "v5",
     [("D0/RX", "uart", "Serial Receive / Digital Pin 0"), ("D1/TX", "uart", "Serial Transmit / Digital Pin 1"),
      ("D2", "digitalIn", "Digital I/O / External Interrupt 0"), ("D3", "digitalOut", "Digital I/O / PWM Output"),
      ("D4", "digitalIn", "Digital I/O"), ("D5", "digitalOut", "Digital I/O / PWM Output"),
      ("D6", "digitalOut", "Digital I/O / PWM Output"), ("D7", "digitalIn", "Digital I/O"),
      ("D8", "digitalIn", "Digital I/O"), ("D9", "digitalOut", "Digital I/O / PWM Output"),
      ("D10", "digitalOut", "Digital I/O / PWM / SPI SS"), ("D11", "digitalOut", "Digital I/O / PWM / SPI MOSI"),
      ("D12", "digitalIn", "Digital I/O / SPI MISO"), ("D13", "digitalOut", "Digital I/O / SPI SCK / Built-in LED"),
      ("A0", "analogIn", "Analog Input 0 (10-bit ADC)"), ("A1", "analogIn", "Analog Input 1"),
      ("A2", "analogIn", "Analog Input 2"), ("A3", "analogIn", "Analog Input 3"),
      ("A4/SDA", "i2c", "Analog Input 4 / I2C Serial Data"), ("A5/SCL", "i2c", "Analog Input 5 / I2C Serial Clock"),
      ("5V", "power", "Regulated 5V Power Output"), ("3.3V", "power", "Regulated 3.3V Power Output"),
      ("GND", "ground", "Ground Reference"), ("VIN", "power", "External DC Input 7-12V")],
     None, "safe", ["Do not connect 5V directly to GND", "Do not draw more than 200mA total across all I/O pins"], None, False,
     ["proj_01", "proj_02", "proj_03", "proj_04", "proj_05", "proj_06", "proj_07", "proj_08", "proj_09", "proj_10", "proj_11", "proj_12", "proj_13", "proj_14", "proj_15", "proj_16", "proj_17", "proj_18", "proj_19", "proj_20"]),

    (40, "Arduino Nano V3", "ATmega328P-AU", "microcontroller", "Arduino Nano V3", "A compact, breadboard-friendly microcontroller with 14 digital pins, 8 analog inputs, and a Mini-B USB programming port.", "v5",
     [("D0-D13", "digitalIn", "14 Digital I/O Pins (6 PWM)"), ("A0-A7", "analogIn", "8 Analog Input Pins"),
      ("5V", "power", "Regulated 5V Power"), ("3V3", "power", "Regulated 3.3V Power"),
      ("GND", "ground", "Ground Reference"), ("VIN", "power", "Unregulated 7-12V Input"), ("RST", "digitalIn", "Reset Pin")],
     None, "safe", ["Double check pin alignment before pressing into breadboard"], None, False, ["proj_14"]),

    (41, "Arduino Mega 2560", "ATmega2560", "microcontroller", "Arduino Mega 2560", "Heavyweight powerhouse brain with 54 digital I/O pins, 16 analog inputs, 4 hardware UART serial ports, and 256KB flash memory.", "v5",
     [("D0-D53", "digitalIn", "54 Digital I/O Pins (15 PWM)"), ("A0-A15", "analogIn", "16 Analog Input Pins"),
      ("TX1-3/RX1-3", "uart", "3 Additional Hardware Serial Ports"), ("SPI", "spi", "Hardware SPI (Pins 50-53)"),
      ("5V", "power", "5V Power Output"), ("3.3V", "power", "3.3V Power Output"), ("GND", "ground", "Ground Reference")],
     None, "safe", ["Support the board firmly when plugging shields into extended headers"], None, False, ["proj_14"]),

    (42, "ESP32 DevKit V1", "ESP-WROOM-32", "microcontroller", "ESP32 DevKit V1", "High-performance 240MHz dual-core Xtensa 32-bit MCU with integrated Wi-Fi 802.11 b/g/n, Bluetooth v4.2 BR/EDR, and BLE.", "v3_3",
     [("GPIO2", "digitalOut", "Onboard Blue LED / Boot Strapping"), ("GPIO4", "digitalIn", "Capacitive Touch / Digital I/O"),
      ("GPIO5", "digitalOut", "VSPI CS"), ("GPIO18", "digitalOut", "VSPI SCK"), ("GPIO19", "digitalIn", "VSPI MISO"),
      ("GPIO21", "i2c", "I2C SDA"), ("GPIO22", "i2c", "I2C SCL"), ("GPIO23", "digitalOut", "VSPI MOSI"),
      ("3V3", "power", "3.3V Regulated Power Output"), ("GND", "ground", "Ground Reference"),
      ("VIN", "power", "5V External / USB Power Input")],
     None, "safe", ["All GPIO pins operate strictly at 3.3V logic - 5V inputs will damage the chip!"], None, False, ["proj_20"]),

    (43, "ESP8266 NodeMCU V3", "ESP-12E", "microcontroller", "ESP8266 NodeMCU V3", "Connected IoT microcontroller board running at 80/160MHz with full TCP/IP stack and onboard USB-to-Serial converter.", "v3_3",
     [("D0/GPIO16", "digitalIn", "User Wake / Digital I/O"), ("D1/GPIO5", "i2c", "I2C SCL / Digital I/O"),
      ("D2/GPIO4", "i2c", "I2C SDA / Digital I/O"), ("D3/GPIO0", "digitalIn", "Flash Boot / Pullup"),
      ("D4/GPIO2", "digitalOut", "Onboard LED / TX1"), ("D5/GPIO14", "spi", "SPI SCLK"),
      ("D6/GPIO12", "spi", "SPI MISO"), ("D7/GPIO13", "spi", "SPI MOSI"), ("D8/GPIO15", "digitalOut", "SPI SS / Pulldown"),
      ("A0/ADC0", "analogIn", "Analog Input (0-3.3V via onboard divider)"), ("3V3", "power", "3.3V Regulated Output"),
      ("GND", "ground", "Ground Reference"), ("VIN", "power", "5V USB / External Input")],
     None, "safe", ["GPIO pins accept maximum 3.3V logic levels"], None, False, ["proj_20"]),

    (44, "Uno Protoshield", "GAR-PROTO-SHIELD", "passive", "Uno Protoshield + Mini Breadboard", "Expansion shield that plugs directly onto Arduino Uno headers with a 170-tie-point mini breadboard and custom prototyping pads.", "v5",
     [("Pass-Through Headers", "passive", "Full Uno pin breakout D0-D13, A0-A5, Power, GND"),
      ("Mini Breadboard", "passive", "170 tie-point solderless prototyping matrix"),
      ("5V Rail", "power", "5V Bus"), ("GND Rail", "ground", "Ground Bus")],
     "UNO Proto Shield Prototype Expansion Board.pdf", "safe", ["Ensure shield header pins are aligned before pressing into Uno"], None, False, ["proj_01", "proj_04"]),

    (45, "ISD1820 Voice Module", "ISD1820", "actuator", "ISD1820 Voice Recording & Playback Module", "Single-chip voice recording and playback module with onboard microphone, 10-second non-volatile audio memory, and direct 8-ohm speaker driver.", "v5",
     [("VCC", "power", "Power Supply (3V-5V)"), ("GND", "ground", "Ground"),
      ("REC", "digitalIn", "Record trigger (active HIGH)"), ("PLAYE", "digitalIn", "Edge-triggered playback trigger"),
      ("PLAYL", "digitalIn", "Level-triggered playback trigger"),
      ("SP+", "passive", "Speaker output positive"), ("SP-", "passive", "Speaker output negative")],
     None, "safe", ["Keep speaker away from magnetic storage devices"], None, False, ["proj_01", "proj_05"]),

    (46, "USB Charger Doctor", "KWS-V20", "sensor", "USB Charger Doctor Multimeter", "Inline USB diagnostics monitor measuring voltage (3-9V) and current (0-3A) in real time with dual 7-segment LED display.", "v5",
     [("USB-IN", "power", "Male USB Type-A 5V Input"), ("USB-OUT", "power", "Female USB Type-A Output to Monitored Device"),
      ("VCC", "power", "Power Rail 3V-9V"), ("GND", "ground", "Ground Return")],
     None, "safe", ["Do not exceed 9V maximum operating input"], None, False, []),

    (47, "4-Digit Display", "TM1637", "display", "4-Digit 7-Segment LED Clock Display", "4-digit numeric LED display with central clock colon, controlled over a 2-wire serial protocol (CLK, DIO) using the TM1637 driver.", "v5",
     [("GND", "ground", "Ground Reference"), ("VCC", "power", "5V Power Supply"),
      ("DIO", "digitalIn", "Serial Data Input/Output"), ("CLK", "digitalOut", "Serial Clock Input")],
     "4 digit 7-segment Display .PDF", "safe", [], None, False, ["proj_05"]),

    (48, "ESP-01 Wi-Fi Module", "ESP-01S", "communication", "ESP8266 ESP-01 Wi-Fi Transceiver", "Compact 8-pin Wi-Fi serial module allowing any Arduino board to connect to 2.4GHz wireless networks via AT commands.", "v3_3",
     [("3V3", "power", "3.3V Power (DO NOT CONNECT 5V)"), ("TX", "uart", "Serial Transmit (3.3V)"),
      ("RX", "uart", "Serial Receive (3.3V)"), ("EN", "digitalIn", "Chip Enable (connect to 3.3V)"),
      ("IO0", "digitalIn", "Flash / Run Mode Select"), ("IO2", "digitalIn", "General Purpose I/O 2"),
      ("RST", "digitalIn", "Hardware Reset (active LOW)"), ("GND", "ground", "Ground")],
     None, "caution", ["Module operates strictly at 3.3V. 5V on VCC or RX will damage the chip without level shifter."], "Use ESP32 DevKit or USB cable communication for beginner wireless experiments", False, ["proj_20"]),

    (49, "L293D Motor Driver", "L293D", "actuator", "L293D Dual H-Bridge Motor Driver IC", "16-pin dual-channel H-bridge driver integrated circuit delivering up to 600mA per channel with internal flyback clamping diodes.", "v5",
     [("1,2EN", "digitalOut", "Enable channel 1 and 2 (PWM speed)"), ("1A", "digitalOut", "Input 1 direction control"),
      ("1Y", "power", "Output 1 to Motor A"), ("GND", "ground", "Heatsink Ground"),
      ("2Y", "power", "Output 2 to Motor A"), ("2A", "digitalOut", "Input 2 direction control"),
      ("VCC2", "power", "Motor Supply Voltage (4.5V-36V)"), ("3,4EN", "digitalOut", "Enable channel 3 and 4"),
      ("3A", "digitalOut", "Input 3 direction"), ("3Y", "power", "Output 3 to Motor B"),
      ("4Y", "power", "Output 4 to Motor B"), ("4A", "digitalOut", "Input 4 direction"),
      ("VCC1", "power", "Logic Supply Voltage (5V)")],
     "L293d .pdf", "safe", ["IC can become hot when driving continuous high motor currents"], None, False, ["proj_08", "proj_17"]),

    (50, "74HC595 Shift Register", "74HC595N", "actuator", "74HC595 8-Bit Shift Register IC", "Serial-in, parallel-out 8-stage shift register with storage latch that expands 3 microcontroller pins into 8 independent digital outputs.", "v5",
     [("Q0-Q7", "digitalOut", "8 Parallel Digital Outputs"), ("GND", "ground", "Ground"),
      ("Q7S", "digitalOut", "Serial Output for Cascading"), ("MR", "digitalIn", "Master Reset (active LOW - tie to 5V)"),
      ("SH_CP", "digitalOut", "Shift Clock Input"), ("ST_CP", "digitalOut", "Storage Latch Clock Input"),
      ("OE", "digitalIn", "Output Enable (active LOW - tie to GND)"), ("DS", "digitalIn", "Serial Data Input"),
      ("VCC", "power", "5V Power Supply")],
     "74HC595.PDF", "safe", [], None, False, ["proj_07", "proj_19"]),

    (51, "10K Thermistor", "MF52-103", "sensor", "NTC 10K Thermistor Temperature Probe", "Negative Temperature Coefficient ceramic semiconductor resistor whose resistance decreases predictably as temperature increases.", "v5",
     [("Leg 1", "power", "Connect to 5V Power Rail"),
      ("Leg 2", "analogIn", "Connected to Analog Pin A0 and 10k resistor to GND")],
     "Thermoresistor NTC MF52-103 3435 10K ohm 5%.pdf", "safe", ["Avoid placing sensor against open flame or surfaces above 100°C"], None, False, ["proj_12"]),

    (52, "Slider Switch", "SS-12D00", "switch", "3-Pin Slider Switch (SPDT)", "Single-Pole Double-Throw miniature slide switch for toggling power or selecting between two operational circuit modes.", "v5",
     [("Pin 1", "digitalIn", "Throw 1 Contact"), ("Pin 2", "power", "Common Center Wiper"),
      ("Pin 3", "digitalIn", "Throw 2 Contact")],
     None, "safe", [], None, False, ["proj_04", "proj_08"]),

    (53, "Solderless Breadboard", "MB-102", "passive", "830-Point Solderless Breadboard", "Solderless prototyping board with 830 tie-points arranged in interconnected 5-hole rows and 4 full-length dual power rails.", "dual",
     [("Red Rail (+)", "power", "Positive Voltage Bus"), ("Blue Rail (-)", "ground", "Ground Return Bus"),
      ("Row Pins (a-j)", "passive", "5-pin interconnected component sockets")],
     "830 430 tie-points Breadboard.pdf", "safe", ["Do not insert wire leads thicker than 22 AWG"], None, False, ["proj_01", "proj_04", "proj_08"]),

    (54, "9V 1A DC Power Supply", "GAR-9V1A-DC", "power", "9V 1A DC Power Supply Adapter", "Regulated wall adapter converting 100-240V AC to 9V 1000mA DC with standard 5.5mm x 2.1mm center-positive barrel jack.", "v5",
     [("Center Pin (+)", "power", "+9V DC Regulated Output"),
      ("Outer Ring (-)", "ground", "Ground Return Reference")],
     "9V 1A.pdf", "caution", ["Use wall outlets under adult supervision", "Do not cut or short power cord wires"], "Use USB cable power or 9V battery snap connector for portable power", False, ["proj_08", "proj_10"])
]

# -------------------------------------------------------------
# 3. Projects Data (14 Projects)
# -------------------------------------------------------------
PROJECTS = [
    {
        "id": "proj_01",
        "title": "Intruder Alarm MONSTER",
        "tagline": "Protect your secret base with an ultrasonic security tripwire and alarm!",
        "tier": "rookie",
        "estimatedMinutes": 35,
        "requiredComponents": ["comp_01", "comp_34"],
        "prerequisiteLessons": ["lesson_05"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Parts & Tool Check",
                "type": "gatherParts",
                "instructions": "Collect your Arduino Uno, HC-SR04 ultrasonic sensor, active buzzer, red LED, 220-ohm resistor, breadboard, and jumper wires.",
                "verificationCheckpoints": ["Arduino Uno verified", "HC-SR04 pins straight", "Buzzer sticker removed"]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect HC-SR04 VCC to 5V, GND to GND, TRIG to Pin 9, ECHO to Pin 10. Connect Buzzer positive to Pin 8 and negative to GND. Wire LED to Pin 7 with a 220-ohm current resistor.",
                "verificationCheckpoints": ["TRIG on Pin 9", "ECHO on Pin 10", "LED resistor in series"]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Upload & Test Tripwire",
                "type": "uploadSketch",
                "instructions": "Upload the Intruder Alarm sketch. Wave your hand in front of the sensor: when closer than 30cm, the siren sounds!",
                "verificationCheckpoints": ["Distance reads in Serial Monitor", "Alarm triggers on approach"]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Mount your Intruder Alarm by your bedroom doorway to catch unsuspecting invaders!"
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Distance always reads 0cm or 3000cm",
                "cause": "TRIG and ECHO wires are swapped",
                "solution": "Swap pins 9 and 10 on your breadboard"
            },
            {
                "symptom": "Buzzer makes click but no loud tone",
                "cause": "Passive buzzer used instead of active buzzer, or sticker left on",
                "solution": "Peel off the protective paper sticker on top of the buzzer"
            }
        ],
        "variants": [
            {
                "id": "proj_01_var_1",
                "title": "Dual Piezo Stereo Siren",
                "description": "Use two piezos on separate pins with alternating frequencies to create an authentic European police siren effect.",
                "alternativeComponents": ["comp_34"],
                "wiringDifferences": "Connect second buzzer to Pin 6 and GND",
                "codeAdaptation": "Alternate tone(8, 800) and tone(6, 600) with 250ms intervals"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_01_mis_1",
                "title": "Stealth Silent Alarm",
                "objective": "Silence the loud piezo and replace it with an invisible infrared beacon or silent strobe warning to catch intruders unawares.",
                "difficulty": "rookie",
                "hints": [
                    "Replace tone() with digitalWrite() pulsing on an LED or IR LED pin",
                    "Ensure the loop still calculates distance accurately"
                ],
                "xpReward": 50
            }
        ],
        "xpReward": 100,
        "badgeRewardId": "badge_security_rookie"
    },
    {
        "id": "proj_02",
        "title": "Beat Detector MONSTER",
        "tagline": "Turn sound waves into light shows that pulse with your favorite music!",
        "tier": "rookie",
        "estimatedMinutes": 30,
        "requiredComponents": ["comp_02"],
        "prerequisiteLessons": ["lesson_06"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Parts",
                "type": "gatherParts",
                "instructions": "Fetch the KY-037 sound sensor module, 5mm LEDs, 220-ohm resistors, and jumpers."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Acoustic Calibration",
                "type": "physicalTest",
                "instructions": "Wire KY-037 A0 to Arduino A0. Open Serial Plotter and turn the blue potentiometer screw until ambient room noise hovers around 500."
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Light Pulse Synthesis",
                "type": "uploadSketch",
                "instructions": "Upload the Beat Detector sketch. Clap your hands or play music to watch the LEDs flash with the beat!"
            }
        ],
        "troubleshooting": [
            {
                "symptom": "LED stays permanently ON",
                "cause": "Microphone sensitivity potentiometer tuned too high",
                "solution": "Turn the brass screw on the blue trimmer counter-clockwise until LED turns off when silent"
            }
        ],
        "xpReward": 100,
        "badgeRewardId": "badge_audio_engineer"
    },
    {
        "id": "proj_03",
        "title": "Remote Control Funny Faces",
        "tagline": "Animate happy, silly, and surprised monster expressions on an 8x8 LED matrix!",
        "tier": "builder",
        "estimatedMinutes": 45,
        "requiredComponents": ["comp_13", "comp_15"],
        "prerequisiteLessons": ["lesson_03", "lesson_05"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Unbox Remote & Display",
                "type": "gatherParts",
                "instructions": "Pull out the AX-1838HS IR receiver, IR transmitter remote, and MAX7219 8x8 dot matrix module."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "SPI-Style Bus Connection",
                "type": "breadboardWiring",
                "instructions": "Connect MAX7219 DIN to Pin 12, CLK to Pin 11, CS to Pin 10. Connect IR receiver signal to Pin 2."
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Face Expression Switching",
                "type": "uploadSketch",
                "instructions": "Upload code and press buttons 1-9 on the remote to shift through 9 hilarious animated faces!"
            }
        ],
        "xpReward": 150,
        "badgeRewardId": "badge_pixel_artist"
    },
    {
        "id": "proj_04",
        "title": "Smart MONSTER Door",
        "tagline": "Build a secret passcode door lock with keypad, servo latch, and access alarms!",
        "tier": "builder",
        "estimatedMinutes": 50,
        "requiredComponents": ["comp_06", "comp_25", "comp_34"],
        "prerequisiteLessons": ["lesson_03", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Keypad & Servo Assembly",
                "type": "gatherParts",
                "instructions": "Grab your 4x4 matrix keypad, SG90 servo motor, active buzzer, red and green status LEDs."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Matrix Scanning & Latch Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect 8 keypad pins to digital pins 2 through 9. Connect Servo signal to pin 10, buzzer to pin 11."
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Passcode Lock Verification",
                "type": "uploadSketch",
                "instructions": "Enter default code '1234*'. The servo rotates 90 degrees, the green light flashes, and the door unlocks!"
            }
        ],
        "variants": [
            {
                "id": "proj_04_var_1",
                "title": "Reverse Deadbolt Mechanism",
                "description": "Invert servo throw angles (0 deg locked, 90 deg unlocked) and add auto-lock timer.",
                "alternativeComponents": ["comp_11"],
                "wiringDifferences": "No wiring changes required",
                "codeAdaptation": "Change servo.write(90) to servo.write(0) and track millis() for 10-second auto relock"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_04_mis_1",
                "title": "Lockout Tamper Penalty",
                "objective": "Add a security lockout that disables keypad inputs for 60 seconds after 3 consecutive wrong passcodes.",
                "difficulty": "builder",
                "hints": [
                    "Keep a failedAttempts counter",
                    "When failedAttempts >= 3, record millis() and ignore key presses until 60,000ms elapse"
                ],
                "xpReward": 60
            }
        ],
        "xpReward": 175,
        "badgeRewardId": "badge_smart_security"
    },
    {
        "id": "proj_05",
        "title": "MONSTER Alarm Clock",
        "tagline": "Build an unhackable bedside desk clock with real-time clock chip, I2C LCD, and snooze buzzer!",
        "tier": "builder",
        "estimatedMinutes": 45,
        "requiredComponents": ["comp_07", "comp_10", "comp_34"],
        "prerequisiteLessons": ["lesson_03"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "I2C Dual Device Connection",
                "type": "breadboardWiring",
                "instructions": "Connect both DS3231 RTC and 1602 LCD SDA to A4, and SCL to A5. The I2C bus shares pins using unique hex addresses!"
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Sync Time & Alarm Trigger",
                "type": "uploadSketch",
                "instructions": "Upload the clock sketch to display live hours, minutes, and seconds. Set your wake-up alarm to fire the buzzer!"
            }
        ],
        "xpReward": 150,
        "badgeRewardId": "badge_time_master"
    },
    {
        "id": "proj_06",
        "title": "Gas Leak Detection and Warning",
        "tagline": "Build an industrial air quality laboratory monitor that alerts you if hazardous gas is detected!",
        "tier": "builder",
        "estimatedMinutes": 50,
        "requiredComponents": ["comp_07", "comp_17", "comp_34"],
        "prerequisiteLessons": ["lesson_06"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Safety Briefing & Sensor Warmup",
                "type": "gatherParts",
                "instructions": "Review safety guidelines for MQ gas sensors. The metal top heats up normally to burn off atmospheric impurities."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "LCD Telemetry Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect MQ-9 sensor analog pin to A0, LCD to I2C pins, and alarm buzzer to digital pin 8."
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Air Quality Safety Guard",
                "type": "uploadSketch",
                "instructions": "Upload sketch and watch live PPM air quality readouts on your LCD screen."
            }
        ],
        "xpReward": 160,
        "badgeRewardId": "badge_safety_officer"
    },
    {
        "id": "proj_07",
        "title": "MONSTER ATM and Food Dispenser",
        "tagline": "Build an automated banking and snack dispenser with PIN authentication and servo dispensing!",
        "tier": "builder",
        "estimatedMinutes": 60,
        "requiredComponents": ["comp_06", "comp_07", "comp_25"],
        "prerequisiteLessons": ["lesson_03", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Dispenser Mechanism",
                "type": "gatherParts",
                "instructions": "Assemble the cardboard or 3D dispenser funnel with SG90 servo motor gate."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Banking System Code",
                "type": "uploadSketch",
                "instructions": "Program account balance management, PIN codes, and treat dispensing rotation cycles."
            }
        ],
        "xpReward": 180,
        "badgeRewardId": "badge_inventor"
    },
    {
        "id": "proj_08",
        "title": "Electric Motor Control MONSTER",
        "tagline": "Take command of dual mechanical power! Control DC motor speed and stepper angles with an analog joystick.",
        "tier": "engineer",
        "estimatedMinutes": 60,
        "requiredComponents": ["comp_20", "comp_21", "comp_27", "comp_33"],
        "prerequisiteLessons": ["lesson_06", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Motor Driver Shielding",
                "type": "breadboardWiring",
                "instructions": "Connect ULN2003 stepper driver to pins 8-11 and L293D DC motor driver to PWM pin 5 and direction pin 4."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Joystick Throttle & Steering",
                "type": "uploadSketch",
                "instructions": "Push joystick forward for DC motor propulsion; nudge left and right for precision stepper position steering."
            }
        ],
        "variants": [
            {
                "id": "proj_08_var_1",
                "title": "Encoder Speed Controller",
                "description": "Replace standard potentiometer with a rotary encoder for detented digital speed steps.",
                "alternativeComponents": ["comp_24"],
                "wiringDifferences": "Connect rotary encoder CLK to Pin 2 and DT to Pin 3",
                "codeAdaptation": "Use pin change interrupts or polling to increment/decrement PWM duty cycle"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_08_mis_1",
                "title": "Soft-Start Ramp Profiler",
                "objective": "Prevent motor stall and current spikes by smoothly accelerating motor PWM from 0 to target speed over 1.5 seconds.",
                "difficulty": "builder",
                "hints": [
                    "Use a timer loop to increment PWM by 5 every 30ms until reaching targetPWM"
                ],
                "xpReward": 70
            }
        ],
        "xpReward": 200,
        "badgeRewardId": "badge_motor_dynamo"
    },
    {
        "id": "proj_09",
        "title": "RFID Smart Door MONSTER",
        "tagline": "Swipe your badge to enter! Read 13.56MHz crypto tags with SPI and unlock physical servo deadbolts.",
        "tier": "engineer",
        "estimatedMinutes": 60,
        "requiredComponents": ["comp_23", "comp_25", "comp_34"],
        "prerequisiteLessons": ["lesson_03", "lesson_05"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Strict 3.3V SPI Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect RC522 VCC to 3.3V ONLY (NEVER 5V!). Connect MOSI to 11, MISO to 12, SCK to 13, NSS to 10."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Master Key Authorization",
                "type": "uploadSketch",
                "instructions": "Scan your white card and blue key fob. Authorize only your master UID to grant physical access!"
            }
        ],
        "xpReward": 220,
        "badgeRewardId": "badge_rfid_guardian"
    },
    {
        "id": "proj_10",
        "title": "Oil Drill Rig MONSTER",
        "tagline": "Industrial heavy machinery! Control stepper drilling depth with a rotary click encoder and LCD telemetry.",
        "tier": "engineer",
        "estimatedMinutes": 75,
        "requiredComponents": ["comp_07", "comp_24", "comp_27", "comp_25"],
        "prerequisiteLessons": ["lesson_06", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Rotary Encoder Calibration",
                "type": "breadboardWiring",
                "instructions": "Connect KY-040 encoder to pins 2 and 3 (hardware interrupt pins). Connect LCD to A4/A5."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Deep Well Drill Sequencing",
                "type": "uploadSketch",
                "instructions": "Rotate encoder clockwise to lower the drill stepper bit millimeter by millimeter with live LCD readout."
            }
        ],
        "xpReward": 230,
        "badgeRewardId": "badge_industrial_chief"
    },
    {
        "id": "proj_11",
        "title": "Sentry Guard MONSTER",
        "tagline": "Autonomous pan-tilt turret! Scans the perimeter with ultrasonic radar and targets invaders with a red laser!",
        "tier": "engineer",
        "estimatedMinutes": 80,
        "requiredComponents": ["comp_01", "comp_07", "comp_25", "comp_34", "comp_37"],
        "prerequisiteLessons": ["lesson_05", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Pan-Tilt Turret Mechanics",
                "type": "gatherParts",
                "instructions": "Mount horizontal servo for 180-degree sweep, and vertical servo with ultrasonic sensor and KY-008 laser."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Radar Sweeping Algorithm",
                "type": "uploadSketch",
                "instructions": "The turret sweeps back and forth continuously. When an intruder is detected, it locks on target and chirps!"
            }
        ],
        "xpReward": 250,
        "badgeRewardId": "badge_turret_commander"
    },
    {
        "id": "proj_12",
        "title": "Weather & Water Reservoir Station",
        "tagline": "Environmental science lab! Monitor rainfall, water depth, temp, and trigger automated floodgates.",
        "tier": "engineer",
        "estimatedMinutes": 70,
        "requiredComponents": ["comp_07", "comp_09", "comp_22", "comp_25", "comp_35"],
        "prerequisiteLessons": ["lesson_06"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Hydraulic Sensor Array",
                "type": "breadboardWiring",
                "instructions": "Wire DHT11 to Pin 2, FC-37 Rain plate to A1, and Water level depth sensor to A2."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Automated Floodgate Servo",
                "type": "uploadSketch",
                "instructions": "When water reservoir level rises past safety limit, the dam floodgate servo automatically swings open to release overflow!"
            }
        ],
        "variants": [
            {
                "id": "proj_12_var_1",
                "title": "Reservoir Auto-Fill Sump",
                "description": "Use the water level sensor to control an inlet relay solenoid rather than a drain pump.",
                "alternativeComponents": ["comp_36"],
                "wiringDifferences": "Connect relay module to Pin 7 to drive 12V pump solenoid",
                "codeAdaptation": "Invert logic: energize relay when water < 300, de-energize when water > 700"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_12_mis_1",
                "title": "Electrolysis Protection Pulse",
                "objective": "Prevent probe corrosion by only supplying power to the water sensor trace for 10ms right before analogRead().",
                "difficulty": "engineer",
                "hints": [
                    "Power sensor VCC from digital pin 6 instead of 5V rail",
                    "digitalWrite(6, HIGH); delay(10); analogRead(A0); digitalWrite(6, LOW);"
                ],
                "xpReward": 75
            }
        ],
        "xpReward": 240,
        "badgeRewardId": "badge_earth_scientist"
    },
    {
        "id": "proj_13",
        "title": "MONSTER Autopilot",
        "tagline": "Flight control computing! Stabilize robotic wings and vehicles using 6-axis gyroscope accelerometer fusion.",
        "tier": "monsterMaster",
        "estimatedMinutes": 90,
        "requiredComponents": ["comp_04", "comp_07", "comp_12", "comp_25", "comp_27"],
        "prerequisiteLessons": ["lesson_03", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "6-DOF IMU Sensor Fusion",
                "type": "breadboardWiring",
                "instructions": "Connect MPU-6050 to I2C pins A4/A5 and INT pin to Digital Pin 2 for hardware DMP packet interrupts."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Active Gimbal Stabilization",
                "type": "uploadSketch",
                "instructions": "Tilt the board in any direction: the servo instantly counters the tilt angle to keep the horizon perfectly level!"
            }
        ],
        "xpReward": 300,
        "badgeRewardId": "badge_autopilot_ace"
    },
    {
        "id": "proj_14",
        "title": "NRF24L01 Wireless MONSTER",
        "tagline": "Teleoperation over the airwaves! Send 2.4GHz radio packets between two Arduinos to control robots from across the room.",
        "tier": "monsterMaster",
        "estimatedMinutes": 100,
        "requiredComponents": ["comp_25", "comp_31"],
        "prerequisiteLessons": ["lesson_03", "lesson_07"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Dual Node Transmitter & Receiver",
                "type": "gatherParts",
                "instructions": "Set up two Arduinos (e.g. Uno and Nano) with NRF24L01 radio transceivers and 10uF filter capacitors."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Packet Telemetry Link",
                "type": "uploadSketch",
                "instructions": "Transmit joypad joystick vectors from node 1. Node 2 receives packet bursts and drives servo actuators in real-time!"
            }
        ],
        "variants": [
            {
                "id": "proj_14_var_1",
                "title": "Bi-Directional Telemetry Handshake",
                "description": "Send sensor packets back from receiver to transmitter node to display remote stats.",
                "alternativeComponents": ["comp_31"],
                "wiringDifferences": "No wiring changes required",
                "codeAdaptation": "Use radio.writeAckPayload() or swap TX/RX roles dynamically"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_14_mis_1",
                "title": "Long-Range RF Channel Hopping",
                "objective": "Implement dynamic channel hopping across 2.400GHz-2.525GHz to evade WiFi 2.4GHz interference.",
                "difficulty": "monsterMaster",
                "hints": [
                    "Change radio.setChannel() using a shared pseudo-random sequence"
                ],
                "xpReward": 90
            }
        ],
        "xpReward": 350,
        "badgeRewardId": "badge_wireless_wizard"
    },
    {
        "id": "proj_15",
        "title": "Automated Greenhouse Monitor",
        "tagline": "Keep your monster botanical garden thriving with soil moisture telemetry and automated relay irrigation!",
        "tier": "builder",
        "estimatedMinutes": 50,
        "requiredComponents": ["comp_26", "comp_36", "comp_09", "comp_07", "comp_34"],
        "prerequisiteLessons": ["lesson_09", "lesson_12"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Components",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, Soil Moisture Sensor (comp_26), 5V Relay Module (comp_36), DHT11 Temp/Humidity (comp_09), 1602 I2C LCD (comp_07), Piezo Buzzer (comp_34), Breadboard, and jumper wires."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Upload & Test Irrigation",
                "type": "uploadSketch",
                "instructions": "Upload the Greenhouse sketch. When the soil probe detects low conductivity (dry soil), the relay clicks ON and displays watering status on LCD!"
            }
        ],
        "variants": [
            {
                "id": "proj_15_var_1",
                "title": "Solar Radiance Irrigation",
                "description": "Incorporate a photoresistor (comp_19) so plants are only irrigated after sunset to reduce water evaporation.",
                "alternativeComponents": ["comp_19"],
                "wiringDifferences": "Wire photoresistor voltage divider to A1",
                "codeAdaptation": "Add condition: if (moisture < THRESHOLD && lightLevel < SUNSET_LEVEL) activatePump();"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_15_mis_1",
                "title": "Vapor Pressure Deficit (VPD) Calculator",
                "objective": "Calculate and display air VPD in kiloPascals (kPa) on the LCD using DHT11 temp and humidity curves.",
                "difficulty": "engineer",
                "hints": [
                    "Look up the Tetens formula for saturation vapor pressure",
                    "VPD = VP_sat * (1 - humidity / 100.0)"
                ],
                "xpReward": 80
            }
        ],
        "xpReward": 200,
        "badgeRewardId": "badge_botanist"
    },
    {
        "id": "proj_16",
        "title": "Laser Tripwire Sentry",
        "tagline": "Guard the laboratory perimeter with a 650nm concentrated optical beam and responsive photoresistor alarm!",
        "tier": "builder",
        "estimatedMinutes": 45,
        "requiredComponents": ["comp_37", "comp_19", "comp_34"],
        "prerequisiteLessons": ["lesson_08"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Optical Hardware",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, KY-008 Laser Diode (comp_37), LDR Photoresistor (comp_19), 10k resistor, Active Buzzer (comp_34), Red LED, 220-ohm resistor, breadboard, and jumper wires."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Upload & Perimeter Intrusion Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Observe red laser dot on LDR. Pass your hand through the beam: buzzer sounds immediately and red strobe triggers!"
            }
        ],
        "variants": [
            {
                "id": "proj_16_var_1",
                "title": "Modulated IR Carrier Beam",
                "description": "Replace visible red laser with 38kHz pulsed IR transmitter and IR receiver for ambient-light immune tripwire.",
                "alternativeComponents": ["comp_12", "comp_13"],
                "wiringDifferences": "Connect IR receiver output to Pin 2",
                "codeAdaptation": "Use tone(pin, 38000) to pulse emitter and test digitalRead() on receiver"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_16_mis_1",
                "title": "Grid Alignment Meter",
                "objective": "Display real-time photonic signal strength on an I2C LCD to assist field technicians in aligning the beam optics.",
                "difficulty": "builder",
                "hints": [
                    "Map analogRead(A0) to 0-100%",
                    "Render a custom bar graph on LCD 1602"
                ],
                "xpReward": 70
            }
        ],
        "xpReward": 200,
        "badgeRewardId": "badge_laser_master"
    },
    {
        "id": "proj_17",
        "title": "Autonomous Line Tracking Rover",
        "tagline": "Deploy autonomous warehouse logistics! Guide an AGV robot over complex black electrical tape race tracks.",
        "tier": "engineer",
        "estimatedMinutes": 80,
        "requiredComponents": ["comp_14", "comp_33", "comp_04"],
        "prerequisiteLessons": ["lesson_12"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Robotic Hardware",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, TCRT5000 Dual Line Trackers (comp_14), 130 DC Motor (comp_33), L293D Motor Driver IC, Crash Switch (comp_04), Battery clip, Breadboard, and wires."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Upload & Track Navigation Test",
                "type": "uploadSketch",
                "instructions": "Upload navigation sketch. Place robot over black electrical tape course: watch dual IR sensors steer motors seamlessly around bends!"
            }
        ],
        "variants": [
            {
                "id": "proj_17_var_1",
                "title": "3-Sensor PID Tracking",
                "description": "Add a third TCRT5000 sensor in center to implement proportional steering corrections.",
                "alternativeComponents": ["comp_14"],
                "wiringDifferences": "Add Center IR sensor to Pin A0",
                "codeAdaptation": "Compute error offset (-1, 0, 1) and calculate proportional PWM differential steering"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_17_mis_1",
                "title": "Autonomous Obstacle Braking",
                "objective": "Mount an ultrasonic sensor (comp_01) on the front bumper to stop rover 15cm before collisions.",
                "difficulty": "engineer",
                "hints": [
                    "Call pingDistance() each loop",
                    "If distance < 15, immediately brake motors and sound warning beep"
                ],
                "xpReward": 85
            }
        ],
        "xpReward": 260,
        "badgeRewardId": "badge_rover_commander"
    },
    {
        "id": "proj_18",
        "title": "Bluetooth Wireless Telemetry Hub",
        "tagline": "Cut the umbilical cable! Stream live analog instrumentation telemetry to any smartphone or PC over Bluetooth RF.",
        "tier": "engineer",
        "estimatedMinutes": 70,
        "requiredComponents": ["comp_29", "comp_07", "comp_20"],
        "prerequisiteLessons": ["lesson_11"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Wireless Terminal Parts",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, HC-05 Bluetooth Module (comp_29), 1602 I2C LCD (comp_07), 10k Potentiometer (comp_20), RGB LED, 1k and 2k resistors (for 3.3V divider), breadboard, and wires."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Upload & Smartphone Serial Terminal Pair",
                "type": "uploadSketch",
                "instructions": "Pair your phone to HC-05 (passcode 1234). Open Serial Bluetooth Terminal: send commands to trigger RGB colors and view potentiometer graphs live!"
            }
        ],
        "variants": [
            {
                "id": "proj_18_var_1",
                "title": "Dual Joystick Remote Telemetry",
                "description": "Receive XY joystick coordinates from mobile gamepad app to steer pan/tilt servo cameras.",
                "alternativeComponents": ["comp_10", "comp_11"],
                "wiringDifferences": "Connect dual servos to Pins 5 and 6",
                "codeAdaptation": "Parse incoming serial commands like 'X120Y45' and map to servo positions"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_18_mis_1",
                "title": "Encrypted Challenge-Response Link",
                "objective": "Require Bluetooth terminal user to enter a 4-digit PIN before telemetry data is unlocked.",
                "difficulty": "engineer",
                "hints": [
                    "Buffer incoming characters until newline",
                    "Compare to stored PIN hash before streaming sensor values"
                ],
                "xpReward": 80
            }
        ],
        "xpReward": 260,
        "badgeRewardId": "badge_bluetooth_pioneer"
    },
    {
        "id": "proj_19",
        "title": "Digital Tachometer & Speed Trap",
        "tagline": "Precision lab instrumentation: measure motor RPM using optical photogates and magnetic Hall effect sensors with hardware interrupts!",
        "tier": "engineer",
        "estimatedMinutes": 65,
        "requiredComponents": ["comp_05", "comp_38", "comp_32", "comp_33"],
        "prerequisiteLessons": ["lesson_08", "lesson_10"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Instrumentation Parts",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, Photo Interrupter Photogate (comp_05), 3144 Hall Effect Sensor (comp_38), 7-Segment Display (comp_32), 74HC595 Shift Register, 130 DC Motor (comp_33), Neodymium magnet, Breadboard, and wires."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Upload & RPM Dynamometer Bench Test",
                "type": "uploadSketch",
                "instructions": "Power motor: pass magnet past Hall sensor. Hardware interrupts tally transitions and refresh measured RPM on 7-segment display every 500ms!"
            }
        ],
        "variants": [
            {
                "id": "proj_19_var_1",
                "title": "Optical Slotted Photogate",
                "description": "Use ITR9608 slotted optical gate instead of magnetic Hall sensor for detecting gear tooth passes.",
                "alternativeComponents": ["comp_05"],
                "wiringDifferences": "Connect photogate digital output to Pin 2 interrupt",
                "codeAdaptation": "Calculate RPM = (pulses / gearTeeth) * (60000 / sampleTimeMs)"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_19_mis_1",
                "title": "Overspeed Governor Interlock",
                "objective": "Trip a safety relay to cut motor power if rotational speed exceeds 3,000 RPM.",
                "difficulty": "engineer",
                "hints": [
                    "In the loop(), check currentRPM > 3000",
                    "If triggered, drive relay pin LOW and latch fault state"
                ],
                "xpReward": 85
            }
        ],
        "xpReward": 250,
        "badgeRewardId": "badge_tachometer_tech"
    },
    {
        "id": "proj_20",
        "title": "IoT Weather Web Server Beacon",
        "tagline": "Deploy a standalone internet HTTP server on an Arduino with W5100 SPI shield to serve live barometric weather data.",
        "tier": "monsterMaster",
        "estimatedMinutes": 110,
        "requiredComponents": ["comp_30", "comp_08", "comp_09"],
        "prerequisiteLessons": ["lesson_10", "lesson_11"],
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather IoT Server Hardware",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, W5100 Ethernet Shield (comp_30), BMP180 Barometric Pressure Sensor (comp_08), DHT11 Temp/Humidity Sensor (comp_09), RJ-45 LAN Ethernet cable, breadboard, and wires."
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Upload & Web Browser Live Dashboard Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Open Serial Monitor to see the assigned IP address. Open browser, type the IP into the URL bar, and view live weather telemetry!"
            }
        ],
        "variants": [
            {
                "id": "proj_20_var_1",
                "title": "RESTful JSON Telemetry Endpoint",
                "description": "Serve structured JSON payloads (/api/telemetry) instead of HTML for mobile app consumption.",
                "alternativeComponents": ["comp_30"],
                "wiringDifferences": "No wiring changes required",
                "codeAdaptation": "Inspect HTTP request line for '/api/telemetry'; output Content-Type: application/json and raw JSON"
            }
        ],
        "extensionMissions": [
            {
                "id": "proj_20_mis_1",
                "title": "Remote Relay Actuation via Web",
                "objective": "Parse HTTP POST or GET /relay/on and /relay/off requests to remotely trigger physical lab equipment.",
                "difficulty": "monsterMaster",
                "hints": [
                    "Parse URL query parameters",
                    "If matched, digitalWrite(RELAY_PIN, HIGH) and output status page"
                ],
                "xpReward": 100
            }
        ],
        "xpReward": 380,
        "badgeRewardId": "badge_iot_architect"
    }
]

# -------------------------------------------------------------
# 4. Challenges Data
# -------------------------------------------------------------
CHALLENGES = [
    {
        "id": "chal_01",
        "title": "Missing Ground Wire",
        "type": "fixWiring",
        "difficulty": "rookie",
        "prompt": "The LED circuit is connected to Pin 13 and a 220-ohm resistor, but it won't light up. What connection is missing to complete the circuit?",
        "circuitSnippet": "Arduino Pin 13 -> Resistor (220Ω) -> LED Anode (+) -> LED Cathode (-) -> ???",
        "challengeData": {
            "options": [
                "A connection to Arduino 5V",
                "A connection to Arduino GND",
                "A second 220Ω resistor",
                "A 9V battery input"
            ]
        },
        "hint": "Electric circuits must form a complete closed loop back to ground.",
        "hints": [
            "Electricity must flow in a complete loop from power back to ground.",
            "Look for the common negative rail or GND pin on the Arduino board."
        ],
        "explanation": "A circuit requires a closed loop. The LED cathode must be connected to GND so current can return to the power supply.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 30
    },
    {
        "id": "chal_02",
        "title": "Potentiometer Midpoint Reading",
        "type": "predictOutput",
        "difficulty": "rookie",
        "prompt": "A 10k potentiometer is wired between 5V and GND with its wiper connected to analog pin A0. If turned exactly halfway, what integer does analogRead(A0) return?",
        "circuitSnippet": "5V -> Potentiometer Leg 1\nGND -> Potentiometer Leg 3\nA0 -> Potentiometer Wiper (Center)",
        "challengeData": {
            "options": [
                "255",
                "512",
                "1023",
                "2.5"
            ]
        },
        "hint": "Arduino's ADC has 10 bits of precision, mapping 0V-5V to 0-1023.",
        "hints": [
            "Arduino's ADC has 10 bits of precision, mapping 0V-5V to 0-1023.",
            "Half of 1023 is approximately 511-512."
        ],
        "explanation": "The 10-bit analog-to-digital converter divides 0–5V into 1024 discrete steps (0 to 1023). 2.5V corresponds to 511 or 512.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 30
    },
    {
        "id": "chal_03",
        "title": "Relay High-Voltage Safety Rule",
        "type": "identifyPart",
        "difficulty": "rookie",
        "prompt": "You want to use a 5V relay module to turn on an electric desk lamp plugged into the 120V wall socket. What is the Monster Lab safety rule?",
        "challengeData": {
            "options": [
                "It is safe if you wear rubber shoes",
                "Never connect hobby breadboard wires to wall mains AC; use DC battery circuits only",
                "Wrap exposed pins in electrical tape and proceed",
                "Only switch it on for 5 seconds at a time"
            ]
        },
        "hint": "Wall sockets carry mains AC voltage which is lethal.",
        "hints": [
            "Wall sockets carry mains AC voltage which is lethal.",
            "Monster Lab experiments only use safe low-voltage DC."
        ],
        "explanation": "Mains AC voltage (120V/240V) carries severe electrocution and fire hazards. Monster Lab is strictly low-voltage DC (5V / 9V battery).",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 35
    },
    {
        "id": "chal_04",
        "title": "Double the Blinking Speed",
        "type": "changeCode",
        "difficulty": "rookie",
        "prompt": "The following code blinks an LED once every 2 seconds (1 second ON, 1 second OFF). How should you change it so it blinks twice as fast (twice per second)?",
        "codeSnippet": "void loop() {\n  digitalWrite(13, HIGH);\n  delay(1000);\n  digitalWrite(13, LOW);\n  delay(1000);\n}",
        "challengeData": {
            "options": [
                "Change delay(1000) to delay(2000)",
                "Change delay(1000) to delay(500)",
                "Change digitalWrite(13, HIGH) to digitalWrite(13, 200)",
                "Add a second loop() function"
            ]
        },
        "hint": "Blinking twice as fast means the total period is cut in half.",
        "hints": [
            "Blinking twice as fast means the total period is cut in half.",
            "Halving 1000ms delay gives 500ms delay for each phase."
        ],
        "explanation": "Changing delay(1000) to delay(500) makes the LED stay HIGH for 0.5s and LOW for 0.5s, completing a full cycle every 1.0 second (twice as fast).",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 35
    },
    {
        "id": "chal_05",
        "title": "I2C Bus Address Collision",
        "type": "debugLogic",
        "difficulty": "builder",
        "prompt": "An engineer wired an LCD1602 display and an RTC clock to pins A4 (SDA) and A5 (SCL). The LCD fails to initialize while the clock works erratically. What is the most likely cause?",
        "circuitSnippet": "A4 (SDA) -> LCD SDA & RTC SDA\nA5 (SCL) -> LCD SCL & RTC SCL\n5V & GND shared",
        "challengeData": {
            "options": [
                "I2C only supports a single peripheral at a time",
                "Both devices might have conflicting I2C addresses or improper bus pull-ups",
                "The clock must be connected to digital pins 0 and 1",
                "SDA and SCL must be swapped on the LCD"
            ]
        },
        "hint": "I2C devices share the bus wires, but each device must have a unique identifier.",
        "hints": [
            "I2C devices share the bus wires, but each device must have a unique identifier.",
            "Run an I2C scanner sketch to verify unique hex bus addresses."
        ],
        "explanation": "I2C allows multiple peripherals on SDA/SCL, but each must have a unique hex address. If two modules share an address (or have missing pull-ups), bus collision occurs.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 40
    },
    {
        "id": "chal_06",
        "title": "The Ghost Button Trigger",
        "type": "explainWhatHappened",
        "difficulty": "builder",
        "prompt": "A pushbutton is wired between Pin 2 and GND. In the code, pinMode(2, INPUT) was used. When you wave your hand near the wire, the Arduino randomly triggers button presses! Why?",
        "codeSnippet": "pinMode(2, INPUT); // Button between pin 2 and GND\nif (digitalRead(2) == LOW) { /* triggers randomly! */ }",
        "challengeData": {
            "options": [
                "Static electricity in your hand broke the microcontroller",
                "The pin is 'floating' without a pull-up resistor, picking up ambient electromagnetic noise",
                "Pin 2 is reserved for serial communication",
                "The pushbutton requires 9V to latch properly"
            ]
        },
        "hint": "An unconnected input pin acts like an antenna.",
        "hints": [
            "An unconnected input pin acts like an antenna.",
            "Without a pull-up or pull-down resistor, the voltage is indeterminate."
        ],
        "explanation": "An input pin with no resistor floats between 0V and 5V, picking up electromagnetic noise. Using pinMode(2, INPUT_PULLUP) activates the internal 20k pull-up resistor to stabilize it.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 40
    },
    {
        "id": "chal_07",
        "title": "RGB Color Synthesis",
        "type": "combineComponents",
        "difficulty": "builder",
        "prompt": "You want to produce a warm Yellow glow using a Common Cathode RGB LED connected to PWM pins 9 (Red), 10 (Green), and 11 (Blue). What analogWrite values should you send?",
        "challengeData": {
            "options": [
                "Red: 255, Green: 0, Blue: 255",
                "Red: 255, Green: 255, Blue: 0",
                "Red: 0, Green: 255, Blue: 255",
                "Red: 128, Green: 128, Blue: 128"
            ]
        },
        "hint": "Yellow light in additive color mixing is made of Red and Green.",
        "hints": [
            "Yellow light in additive color mixing is made of Red and Green.",
            "Blue should be turned completely off (0)."
        ],
        "explanation": "Additive color synthesis mixes Red light and Green light to create Yellow. Blue is set to 0.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 40
    },
    {
        "id": "chal_08",
        "title": "Ultrasonic Echo Time Math",
        "type": "predictOutput",
        "difficulty": "builder",
        "prompt": "An HC-SR04 ultrasonic sensor sends a ping and measures an echo pulse duration of 580 microseconds. Using the formula (distance = duration / 58), what is the target obstacle distance in centimeters?",
        "challengeData": {
            "options": [
                "5 cm",
                "10 cm",
                "20 cm",
                "58 cm"
            ]
        },
        "hint": "Divide 580 by 58.",
        "hints": [
            "Divide 580 by 58.",
            "The speed of sound in air is ~340 m/s or 29 microseconds per cm round trip (58 µs round trip)."
        ],
        "explanation": "Sound travels 1 cm in ~29 microseconds. Round trip is 58 microseconds per cm. 580 / 58 = 10 cm.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 40
    },
    {
        "id": "chal_09",
        "title": "Active Buzzer Reversed Polarity",
        "type": "fixWiring",
        "difficulty": "builder",
        "prompt": "An active buzzer is wired to Pin 8 and GND, but it produces a faint, muted clicking instead of a loud 2.5kHz beep. The long leg is connected to GND and short leg to Pin 8. What is wrong?",
        "circuitSnippet": "Pin 8 -> Short Leg (-)\nGND -> Long Leg (+)",
        "challengeData": {
            "options": [
                "Buzzers only work on analog pins",
                "The buzzer is backwards: the longer positive lead must go to Pin 8 and shorter lead to GND",
                "A 10k resistor is required in series",
                "The buzzer needs an AC alternating current"
            ]
        },
        "hint": "Like LEDs and electrolytic capacitors, buzzers are polarized components.",
        "hints": [
            "Like LEDs and electrolytic capacitors, buzzers are polarized components.",
            "The longer lead indicates positive anode (+)."
        ],
        "explanation": "Piezo buzzers and active sounders are polarized. The longer lead (+) must connect to the signal pin (Pin 8) and the shorter lead (-) to GND.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 40
    },
    {
        "id": "chal_10",
        "title": "28BYJ-48 Stepper Gear Steps",
        "type": "predictOutput",
        "difficulty": "engineer",
        "prompt": "The 28BYJ-48 stepper motor has 64 electrical half-steps per rotor cycle and a 1:64 gear reduction gearbox. How many total half-steps are required to turn the output shaft one full 360° turn?",
        "challengeData": {
            "options": [
                "512 steps",
                "1,024 steps",
                "2,048 steps",
                "4,096 steps"
            ]
        },
        "hint": "Multiply internal motor steps per rotation by gear ratio.",
        "hints": [
            "Multiply internal motor steps per rotation by gear ratio.",
            "64 * 64 = ?"
        ],
        "explanation": "64 internal steps * 64 gearbox reduction = 4,096 half-steps per 360° full output rotation (or 2048 full-steps).",
        "solutionValidation": { "correctIndex": 3 },
        "xpAward": 50
    },
    {
        "id": "chal_11",
        "title": "Flyback Diode Protection",
        "type": "identifyPart",
        "difficulty": "engineer",
        "prompt": "When driving a DC motor or relay coil with a transistor, why must a 1N4007 diode be placed in parallel (reverse-biased) across the coil terminals?",
        "circuitSnippet": "Transistor Collector -> Coil Leg 1\nCoil Leg 2 -> 5V\nDiode Cathode (stripe) -> 5V, Anode -> Collector",
        "challengeData": {
            "options": [
                "To make the motor spin in reverse",
                "To clamp the high-voltage inductive kick (back-EMF) caused by the collapsing magnetic field",
                "To reduce current draw and save battery life",
                "To filter audio noise generated by the motor brushes"
            ]
        },
        "hint": "Inductive coils resist changes in current.",
        "hints": [
            "Inductive coils resist changes in current.",
            "When the transistor turns off, the magnetic field collapses and generates a high-voltage spike."
        ],
        "explanation": "When coil current is switched off, the collapsing magnetic field creates a huge reverse inductive kick (back-EMF) that can destroy the switching transistor. The flyback diode safely clamps this spike.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 50
    },
    {
        "id": "chal_12",
        "title": "Hardware Interrupt Pin Trap",
        "type": "debugLogic",
        "difficulty": "engineer",
        "prompt": "A student writes `attachInterrupt(digitalPinToInterrupt(7), onMotion, RISING);` on an Arduino Uno (ATmega328P), but the interrupt service routine never fires when sensor Pin 7 goes HIGH. Why?",
        "codeSnippet": "void setup() {\n  pinMode(7, INPUT);\n  attachInterrupt(digitalPinToInterrupt(7), onMotion, RISING);\n}",
        "challengeData": {
            "options": [
                "Pin 7 is an output-only pin",
                "The Arduino Uno hardware external interrupts are strictly limited to pins 2 and 3",
                "Interrupt routines require delay(100) inside them",
                "The RISING parameter must always be CHANGE"
            ]
        },
        "hint": "Check the Arduino Uno hardware specs for external interrupt pins.",
        "hints": [
            "Check the Arduino Uno hardware specs for external interrupt pins.",
            "Uno only supports hardware external interrupts on pins 2 and 3."
        ],
        "explanation": "On the Arduino Uno (ATmega328P), only digital pins 2 (Interrupt 0) and 3 (Interrupt 1) support hardware external interrupts via `attachInterrupt`.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 50
    },
    {
        "id": "chal_13",
        "title": "Automated Sump Pump Threshold",
        "type": "buildFromGoal",
        "difficulty": "engineer",
        "prompt": "Design the logic condition for a sump pump controller: The pump (relay on Pin 4) should turn ON when water level exceeds 700 AND temperature is above freezing (0°C). It should turn OFF otherwise.",
        "challengeData": {
            "options": [
                "if (waterLevel > 700 || temperature > 0)",
                "if (waterLevel > 700 && temperature > 0)",
                "if (waterLevel < 700 && temperature < 0)",
                "if (waterLevel == 700 && temperature == 0)"
            ]
        },
        "hint": "Use logical AND (&&) to combine both sensor conditions.",
        "hints": [
            "Use logical AND (&&) to combine both sensor conditions.",
            "Check that both water > 700 and temp > 0."
        ],
        "explanation": "The compound boolean expression `waterLevel > 700 && temperature > 0` ensures the pump activates only when water is dangerously high and not frozen.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 50
    },
    {
        "id": "chal_14",
        "title": "NRF24L01 Voltage Killer",
        "type": "fixWiring",
        "difficulty": "monsterMaster",
        "prompt": "An engineer connects an NRF24L01+ 2.4GHz RF module to an Arduino Uno. Why must the VCC pin NEVER be connected to the Arduino 5V header?",
        "challengeData": {
            "options": [
                "5V makes the radio broadcast on illegal frequencies",
                "The transceiver chip maximum rating is 3.6V; 5V will permanently burn the silicon",
                "The Arduino 5V regulator cannot deliver more than 1mA",
                "5V inverts the radio packet bits"
            ]
        },
        "hint": "Check the Nordic Semiconductor silicon datasheet absolute maximum ratings.",
        "hints": [
            "Check the Nordic Semiconductor silicon datasheet absolute maximum ratings.",
            "The maximum operating voltage is 3.6V."
        ],
        "explanation": "The NRF24L01+ transceiver chip has an absolute maximum VCC rating of 3.6V. Supplying 5V destroys the radio IC instantly. Note: its SPI I/O pins are 5V-tolerant, but VCC is strictly 3.3V.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 60
    },
    {
        "id": "chal_15",
        "title": "MPU-6050 Sleep Mode Trap",
        "type": "debugLogic",
        "difficulty": "monsterMaster",
        "prompt": "You initialize an MPU-6050 accelerometer/gyroscope over I2C, but reading register 0x3B always returns all zeros for X, Y, and Z acceleration. What essential startup step was missed?",
        "codeSnippet": "Wire.begin();\nWire.beginTransmission(0x68);\nWire.write(0x3B); // Accel X High\nWire.endTransmission();\nWire.requestFrom(0x68, 6);",
        "challengeData": {
            "options": [
                "The I2C clock speed must be set to 10 MHz",
                "Writing 0x00 to Power Management register 0x6B to wake the device from default Sleep Mode",
                "Connecting a 12V boost converter to the AD0 pin",
                "Inverting the SDA and SCL pull-down resistors"
            ]
        },
        "hint": "The MPU-6050 powers up in Sleep Mode by default.",
        "hints": [
            "The MPU-6050 powers up in Sleep Mode by default.",
            "You must write 0 to register 0x6B (PWR_MGMT_1) to wake the sensor."
        ],
        "explanation": "The MPU-6050 powers on in low-power SLEEP mode (bit 6 of register 0x6B is set to 1). You must clear PWR_MGMT_1 by writing 0x00 to wake the internal oscillator and sensor circuitry.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 60
    },
    {
        "id": "chal_16",
        "title": "Radio Packet Struct Alignment",
        "type": "changeCode",
        "difficulty": "monsterMaster",
        "prompt": "Two Arduinos communicate via NRF24L01. The transmitter sends a data struct, but the receiver prints corrupted telemetry data. What code modification fixes packet serialization?",
        "codeSnippet": "struct Telemetry {\n  byte monsterId;\n  float batteryVoltage;\n  int rpm;\n};\nradio.write(&data, sizeof(data));",
        "challengeData": {
            "options": [
                "Convert all numbers into 64-bit doubles",
                "Ensure transmitter and receiver share the identical struct layout and memory packing",
                "Transmit each byte 10 times in a for loop",
                "Change the radio channel on every transmission"
            ]
        },
        "hint": "Both transmitter and receiver must share the identical struct byte definition.",
        "hints": [
            "Both transmitter and receiver must share the identical struct byte definition.",
            "Different struct padding or data types will misalign incoming bytes."
        ],
        "explanation": "Binary radio transmissions send raw memory bytes. Both transmitter and receiver sketches must define the exact same struct layout (matching types, field order, and byte sizes) for deserialization to work.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 60
    },
    {
        "id": "chal_17",
        "title": "Internal Pull-Up Inversion",
        "type": "debugLogic",
        "difficulty": "rookie",
        "prompt": "When configuring a pushbutton input with pinMode(2, INPUT_PULLUP), what logic state does digitalRead(2) return when the button is actively pressed down connecting Pin 2 to GND?",
        "challengeData": {
            "options": [
                "HIGH (1) because pressing creates power",
                "LOW (0) because pressing connects the pin to Ground",
                "Floating (random 0 or 1)",
                "An analog voltage between 2V and 3V"
            ]
        },
        "hint": "Think about which rail the button connects the input pin to when closed.",
        "hints": [
            "Think about which rail the button connects the input pin to when closed.",
            "INPUT_PULLUP holds the pin HIGH until grounded."
        ],
        "explanation": "The internal pull-up resistor holds the pin at 5V (HIGH) when idle. Pressing the button pulls the pin directly to GND, making digitalRead() return LOW (0). This is active-LOW logic.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 40
    },
    {
        "id": "chal_18",
        "title": "I2C Bus Address Collision",
        "type": "fixWiring",
        "difficulty": "builder",
        "prompt": "Two I2C devices both use default address 0x68 (e.g. RTC DS1307 and MPU-6050 accelerometer). How can both communicate with the same Arduino without bus collision?",
        "challengeData": {
            "options": [
                "Increase the I2C pullup resistors to 100k ohms",
                "Toggle the MPU-6050 AD0 address pin HIGH to shift its address to 0x69",
                "Connect the second device to the Arduino SPI pins instead",
                "Run the I2C clock backwards"
            ]
        },
        "hint": "Check the MPU-6050 AD0 pin function in the datasheet.",
        "hints": [
            "Check the MPU-6050 AD0 pin function in the datasheet.",
            "Connecting AD0 to VCC changes its 7-bit slave address from 0x68 to 0x69."
        ],
        "explanation": "Many I2C chips have an address select pin (like AD0 on MPU-6050). Tying AD0 to 3.3V/5V shifts its I2C address to 0x69, eliminating the collision with the RTC at 0x68.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 50
    },
    {
        "id": "chal_19",
        "title": "SPI Chip Select Protocol",
        "type": "debugLogic",
        "difficulty": "builder",
        "prompt": "When multiple SPI peripherals (e.g., SD Card and Ethernet W5100) share the MOSI, MISO, and SCK lines, how does the master communicate with only one device at a time?",
        "challengeData": {
            "options": [
                "By broadcasting device addresses in the first byte of every transaction",
                "By driving the target slave's dedicated Chip Select (CS/SS) pin LOW while keeping all other CS pins HIGH",
                "By switching the SPI clock speed between 1MHz and 10MHz",
                "By disconnecting the MISO wire physically with a relay"
            ]
        },
        "hint": "SPI slave select lines are active-low.",
        "hints": [
            "SPI slave select lines are active-low.",
            "Slaves keep their MISO output in high-impedance (tri-state) unless their CS pin is pulled LOW."
        ],
        "explanation": "SPI uses dedicated Chip Select (CS) pins per device. Pulling a device's CS line LOW enables its SPI transceiver and MISO bus driver, while keeping inactive devices HIGH prevents bus contention.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 50
    },
    {
        "id": "chal_20",
        "title": "UART Voltage Level Danger",
        "type": "fixWiring",
        "difficulty": "builder",
        "prompt": "The Arduino Uno TX pin outputs 5V TTL logic. When sending serial commands to the HC-05 Bluetooth module RX pin (rated for 3.3V logic), what is the safest way to connect them?",
        "challengeData": {
            "options": [
                "Connect Uno TX directly to HC-05 RX because signals are low current",
                "Use a 2-resistor voltage divider (e.g., 1kΩ and 2kΩ) to drop 5V to 3.3V",
                "Connect a 10uF capacitor in series with the TX line",
                "Connect Uno 5V directly to HC-05 RX"
            ]
        },
        "hint": "A simple voltage divider safely scales 5V down to ~3.3V.",
        "hints": [
            "A simple voltage divider safely scales 5V down to ~3.3V.",
            "R2 / (R1 + R2) * 5V: with R1=1k and R2=2k, Vout = 2/3 * 5V = 3.33V."
        ],
        "explanation": "Applying 5V signals to 3.3V UART RX inputs will damage the Bluetooth silicon over time. A voltage divider (1kΩ series, 2kΩ to GND) steps the 5V logic signal down to safe 3.3V levels.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 55
    },
    {
        "id": "chal_21",
        "title": "H-Bridge Shoot-Through Prevention",
        "type": "debugLogic",
        "difficulty": "engineer",
        "prompt": "In a discrete or integrated H-bridge motor driver, what dangerous electrical condition occurs if both high-side and low-side transistors in the same half-bridge turn ON at the same time?",
        "challengeData": {
            "options": [
                "The motor spins at twice its rated speed",
                "Shoot-through: a direct short circuit from VCC to GND destroying the transistors",
                "The battery charges automatically through regenerative braking",
                "The PWM frequency drops to 0Hz"
            ]
        },
        "hint": "What happens when both top and bottom switches on a leg close simultaneously?",
        "hints": [
            "What happens when both top and bottom switches on a leg close simultaneously?",
            "Power connects straight to ground with near-zero resistance."
        ],
        "explanation": "Shoot-through creates a direct short from power to ground through both transistors simultaneously. Massive current surges through the silicon, causing thermal runaway and chip destruction.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 60
    },
    {
        "id": "chal_22",
        "title": "Hall Effect RPM Calculation",
        "type": "changeCode",
        "difficulty": "engineer",
        "prompt": "A 3144 Hall effect sensor detects 2 magnet passes per motor shaft revolution. An interrupt counts 120 pulses over a 1000ms sampling window. What is the calculated motor RPM?",
        "codeSnippet": "volatile int pulses = 0;\n// 120 pulses counted in 1000 ms\n// 2 pulses per revolution\nint rpm = ???;",
        "challengeData": {
            "options": [
                "1200 RPM",
                "3600 RPM",
                "7200 RPM",
                "240 RPM"
            ]
        },
        "hint": "Revolutions = pulses / 2. Then scale from seconds to minutes (x 60).",
        "hints": [
            "Revolutions = pulses / 2. Then scale from seconds to minutes (x 60).",
            "120 pulses / 2 = 60 revs in 1 second. 60 revs/sec * 60 sec/min = ?"
        ],
        "explanation": "120 pulses / 2 pulses_per_rev = 60 revolutions per second. 60 rev/s * 60 seconds/minute = 3600 RPM.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 65
    },
    {
        "id": "chal_23",
        "title": "W5100 Ethernet Socket Exhaustion",
        "type": "debugLogic",
        "difficulty": "monsterMaster",
        "prompt": "An Arduino Uno HTTP web server using the W5100 shield responds to 4 browser refreshes, but then permanently stops responding. What is the root cause?",
        "challengeData": {
            "options": [
                "The RJ-45 cable overheated",
                "The sketch did not call client.stop(), exhausting all 4 available hardware sockets on the W5100",
                "The Arduino ran out of flash program memory",
                "The browser sent too many cookies"
            ]
        },
        "hint": "The W5100 hardware has exactly 4 simultaneous socket channels.",
        "hints": [
            "The W5100 hardware has exactly 4 simultaneous socket channels.",
            "Each connection must be explicitly terminated with client.stop() to release its socket."
        ],
        "explanation": "The W5100 hardware controller has 4 hardware sockets. If the server code doesn't call client.stop() after sending HTTP headers and body, the sockets remain in CLOSE_WAIT or ESTABLISHED, blocking all subsequent incoming connections.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 75
    },
    {
        "id": "chal_24",
        "title": "Soil Sensor Electrolysis Prevention",
        "type": "buildFromGoal",
        "difficulty": "builder",
        "prompt": "Resistive soil moisture probes rapidly corrode away due to electrochemical galvanic action when powered continuously. What hardware and code design prevents this erosion?",
        "challengeData": {
            "options": [
                "Coat the entire sensor in thick waterproof electrical tape",
                "Power the sensor VCC from an Arduino digital pin, only driving it HIGH for 10ms during sampling then setting it LOW",
                "Run the sensor on 12V instead of 5V",
                "Submerge the probe in saltwater"
            ]
        },
        "hint": "Only apply electrical current when taking a measurement.",
        "hints": [
            "Only apply electrical current when taking a measurement.",
            "Powering VCC via a digital GPIO pin lets you switch off DC current between readings."
        ],
        "explanation": "By powering the probe from a digital pin (e.g. Pin 7) and only setting it HIGH for 10 milliseconds during analogRead(), the DC current exposure is reduced by 99.9%, preserving probe metal for years.",
        "solutionValidation": { "correctIndex": 1 },
        "xpAward": 60
    }
]

# -------------------------------------------------------------
# 5. Badges Data
# -------------------------------------------------------------
BADGES = [
    {
        "id": "badge_security_rookie",
        "name": "Perimeter Guard",
        "description": "Built and calibrated your first ultrasonic security tripwire alarm!",
        "iconAsset": "assets/images/badges/badge_security.png",
        "category": "security",
        "tier": "rookie",
        "xpBonus": 100
    },
    {
        "id": "badge_audio_engineer",
        "name": "Sonic Maestro",
        "description": "Synthesized acoustic noise waves into dancing light shows.",
        "iconAsset": "assets/images/badges/badge_audio.png",
        "category": "acoustics",
        "tier": "rookie",
        "xpBonus": 100
    },
    {
        "id": "badge_pixel_artist",
        "name": "Pixel Picasso",
        "description": "Animated funny pixel faces over infrared wireless remote control!",
        "iconAsset": "assets/images/badges/badge_pixel.png",
        "category": "graphics",
        "tier": "builder",
        "xpBonus": 150
    },
    {
        "id": "badge_smart_security",
        "name": "Vault Breaker",
        "description": "Constructed a matrix keypad passcode lock with motorized deadbolt.",
        "iconAsset": "assets/images/badges/badge_keypad.png",
        "category": "security",
        "tier": "builder",
        "xpBonus": 175
    },
    {
        "id": "badge_time_master",
        "name": "Chronos Engineer",
        "description": "Synchronized battery-backed hardware time across I2C displays.",
        "iconAsset": "assets/images/badges/badge_clock.png",
        "category": "time",
        "tier": "builder",
        "xpBonus": 150
    },
    {
        "id": "badge_safety_officer",
        "name": "Hazmat Detective",
        "description": "Deployed calibrated chemical gas monitoring with LCD telemetry.",
        "iconAsset": "assets/images/badges/badge_gas.png",
        "category": "safety",
        "tier": "builder",
        "xpBonus": 160
    },
    {
        "id": "badge_inventor",
        "name": "Master Dispenser",
        "description": "Automated a physical vending mechanism with bank authentication.",
        "iconAsset": "assets/images/badges/badge_dispenser.png",
        "category": "automation",
        "tier": "builder",
        "xpBonus": 180
    },
    {
        "id": "badge_motor_dynamo",
        "name": "Motion Dynamo",
        "description": "Tamed high-speed DC motors and precision multi-phase steppers.",
        "iconAsset": "assets/images/badges/badge_motor.png",
        "category": "mechanics",
        "tier": "engineer",
        "xpBonus": 200
    },
    {
        "id": "badge_rfid_guardian",
        "name": "Crypto Keymaster",
        "description": "Authenticated contactless RFID electromagnetic tokens over SPI.",
        "iconAsset": "assets/images/badges/badge_rfid.png",
        "category": "security",
        "tier": "engineer",
        "xpBonus": 220
    },
    {
        "id": "badge_industrial_chief",
        "name": "Heavy Industry Chief",
        "description": "Controlled industrial drill rigs with quadrature rotary encoders.",
        "iconAsset": "assets/images/badges/badge_drill.png",
        "category": "industry",
        "tier": "engineer",
        "xpBonus": 230
    },
    {
        "id": "badge_turret_commander",
        "name": "Sentry Commander",
        "description": "Engineered a motorized dual-servo laser radar tracking turret.",
        "iconAsset": "assets/images/badges/badge_turret.png",
        "category": "robotics",
        "tier": "engineer",
        "xpBonus": 250
    },
    {
        "id": "badge_earth_scientist",
        "name": "Hydrologic Guardian",
        "description": "Built automated flood prevention stations with servo dam gates.",
        "iconAsset": "assets/images/badges/badge_weather.png",
        "category": "environment",
        "tier": "engineer",
        "xpBonus": 240
    },
    {
        "id": "badge_autopilot_ace",
        "name": "Autopilot Ace",
        "description": "Stabilized mechanical robotics gimbals with 6-DOF IMU sensor fusion.",
        "iconAsset": "assets/images/badges/badge_autopilot.png",
        "category": "avionics",
        "tier": "monsterMaster",
        "xpBonus": 300
    },
    {
        "id": "badge_wireless_wizard",
        "name": "Wireless Arch-Mage",
        "description": "Teleoperated distributed robots over 2.4GHz wireless radio packets!",
        "iconAsset": "assets/images/badges/badge_wireless.png",
        "category": "telecom",
        "tier": "monsterMaster",
        "xpBonus": 350
    },
    {
        "id": "badge_botanist",
        "name": "Botanical Architect",
        "description": "Engineered automated greenhouse irrigation and soil telemetry.",
        "iconAsset": "assets/images/badges/badge_botanist.png",
        "category": "environment",
        "tier": "builder",
        "xpBonus": 180
    },
    {
        "id": "badge_laser_master",
        "name": "Photon Master",
        "description": "Constructed invisible laser optical tripwire security grids.",
        "iconAsset": "assets/images/badges/badge_laser.png",
        "category": "security",
        "tier": "builder",
        "xpBonus": 190
    },
    {
        "id": "badge_rover_commander",
        "name": "Rover Commander",
        "description": "Navigated autonomous AGV line-tracking rovers with obstacle reflexes.",
        "iconAsset": "assets/images/badges/badge_rover.png",
        "category": "robotics",
        "tier": "engineer",
        "xpBonus": 260
    },
    {
        "id": "badge_bluetooth_pioneer",
        "name": "Bluetooth Pioneer",
        "description": "Streamed bi-directional wireless telemetry to mobile apps over Bluetooth RF.",
        "iconAsset": "assets/images/badges/badge_bluetooth.png",
        "category": "telecom",
        "tier": "engineer",
        "xpBonus": 250
    },
    {
        "id": "badge_tachometer_tech",
        "name": "Tachometer Specialist",
        "description": "Measured high-speed rotational velocities using hardware interrupts and magnetic hall probes.",
        "iconAsset": "assets/images/badges/badge_tachometer.png",
        "category": "instrumentation",
        "tier": "engineer",
        "xpBonus": 260
    },
    {
        "id": "badge_iot_architect",
        "name": "IoT Cloud Architect",
        "description": "Deployed a standalone HTTP internet web server on bare-metal microcontroller hardware.",
        "iconAsset": "assets/images/badges/badge_iot.png",
        "category": "iot",
        "tier": "monsterMaster",
        "xpBonus": 380
    }
]

# -------------------------------------------------------------
# Execution & JSON File Writing
# -------------------------------------------------------------
print("Writing Lesson JSONs...")
lesson_manifest = []
for les in LESSONS:
    fpath = LESSONS_DIR / f"{les['id']}.json"
    with open(fpath, "w", encoding="utf-8") as f:
        json.dump(les, f, indent=2)
    lesson_manifest.append(les["id"])

ID_MAP = {
    39: "comp_uno",
    40: "comp_nano",
    41: "comp_mega",
    42: "comp_esp32",
    43: "comp_esp8266",
    44: "comp_protoshield",
    45: "comp_isd1820",
    46: "comp_usb_doctor",
    47: "comp_4digit_display",
    48: "comp_esp01",
    49: "comp_l293d",
    50: "comp_74hc595",
    51: "comp_thermistor",
    52: "comp_slider_switch",
    53: "comp_breadboard",
    54: "comp_power_supply",
}

print("Writing Component JSONs...")
comp_manifest = []
for comp_tuple in COMPONENTS_RAW:
    num, name, part, cat, title, desc, volt, pinout_raw, ds, safety_lvl, hazards, alt, parent_req, projs = comp_tuple
    comp_id = ID_MAP.get(num, f"comp_{num:02d}")

    pinout_list = [{"pinName": p[0], "type": p[1], "description": p[2]} for p in pinout_raw]

    comp_dict = {
        "id": comp_id,
        "peripheralNumber": num,
        "name": title,
        "partNumber": part,
        "category": cat,
        "description": desc,
        "realWorldAnalogy": desc,
        "voltage": volt,
        "pinout": pinout_list,
        "safety": {
            "level": safety_lvl,
            "hazards": hazards,
            "childSafeAlternative": alt,
            "requiresParentUnlock": parent_req
        },
        "projectIds": projs
    }
    if ds:
        comp_dict["datasheetRef"] = ds

    enrichment = COMPONENT_ENRICHMENTS.get(num, {})
    if "wiringGuidance" in enrichment:
        comp_dict["wiringGuidance"] = enrichment["wiringGuidance"]
    if "commonMistakes" in enrichment:
        comp_dict["commonMistakes"] = enrichment["commonMistakes"]
    if "miniExperiment" in enrichment:
        comp_dict["miniExperiment"] = enrichment["miniExperiment"]

    primary_img_rel = f"assets/images/components/{comp_id}.webp"
    detail_img_rel = f"assets/images/components/{comp_id}_detail.webp"
    if (ROOT / primary_img_rel).exists():
        comp_dict["primaryImage"] = primary_img_rel
        comp_dict["imageDescription"] = f"Hardware photo of {title}"
    details = []
    if (ROOT / detail_img_rel).exists():
        details.append(detail_img_rel)
    if details:
        comp_dict["detailImages"] = details

    fpath = COMPONENTS_DIR / f"{comp_id}.json"
    with open(fpath, "w", encoding="utf-8") as f:
        json.dump(comp_dict, f, indent=2)
    comp_manifest.append(comp_id)

print("Writing Project JSONs...")
proj_manifest = []
for proj in PROJECTS:
    proj_dict = dict(proj)
    enrichment = get_project_enrichment(proj["id"])
    if enrichment:
        if "story" in enrichment:
            proj_dict["story"] = enrichment["story"]
        if "phases" in enrichment:
            proj_dict["phases"] = enrichment["phases"]
        if "troubleshooting" in enrichment:
            proj_dict["troubleshooting"] = enrichment["troubleshooting"]
        if "variants" in enrichment:
            proj_dict["variants"] = enrichment["variants"]
        if "extensionMissions" in enrichment:
            proj_dict["extensionMissions"] = enrichment["extensionMissions"]
    if "variants" not in proj_dict:
        proj_dict["variants"] = []
    if "extensionMissions" not in proj_dict:
        proj_dict["extensionMissions"] = []
    fpath = PROJECTS_DIR / f"{proj_dict['id']}.json"
    with open(fpath, "w", encoding="utf-8") as f:
        json.dump(proj_dict, f, indent=2)
    proj_manifest.append(proj_dict["id"])

print("Writing Challenge JSONs...")
chal_manifest = []
for chal in CHALLENGES:
    fpath = CHALLENGES_DIR / f"{chal['id']}.json"
    with open(fpath, "w", encoding="utf-8") as f:
        json.dump(chal, f, indent=2)
    chal_manifest.append(chal["id"])

print("Writing Badges JSON...")
badges_file = BADGES_DIR / "badges.json"
with open(badges_file, "w", encoding="utf-8") as f:
    json.dump(BADGES, f, indent=2)

print("Writing Curriculum Manifest...")
manifest = {
    "version": "1.0.0",
    "curriculumVersion": "1.0.0",
    "tiers": ["rookie", "builder", "engineer", "monsterMaster"],
    "counts": {
        "lessons": len(lesson_manifest),
        "components": len(comp_manifest),
        "projects": len(proj_manifest),
        "challenges": len(chal_manifest),
        "badges": len(BADGES)
    },
    "lessons": lesson_manifest,
    "components": comp_manifest,
    "projects": proj_manifest,
    "challenges": chal_manifest,
    "badges": [b["id"] for b in BADGES]
}

with open(CURRICULUM_DIR / "manifest.json", "w", encoding="utf-8") as f:
    json.dump(manifest, f, indent=2)

print("Curriculum assets generated successfully!")
