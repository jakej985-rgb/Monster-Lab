#!/usr/bin/env python3
"""
Compiles all 12 expanded lessons from plan/21a through plan/21l into:
1. Python LESSONS data structure in scripts/generate_curriculum_assets.py
2. Dart getBaselineLessons() in lib/data/datasources/asset_curriculum_datasource.dart
3. JSON assets in assets/curriculum/lessons/ and curriculum manifest.
"""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

def clean_markdown(text):
    text = text.strip()
    while text.endswith('---'):
        text = text[:-3].strip()
    return text

def parse_questions_21a(text):
    m = re.search(r'## 12\. Knowledge Check.*?\n(.*?)(?=\n## 13|\Z)', text, re.DOTALL)
    kc = m.group(1).strip()
    q_blocks = re.findall(r'(\d+)\.\s+(.*?)\n(.*?)(?=\n\d+\.|\Z)', kc, re.DOTALL)
    out = []
    correct_map = {1:0, 2:0, 3:1, 4:1, 5:0, 6:0, 7:0, 8:0}
    explanations = {
        1: "A microcontroller is a specialized chip combining CPU, memory, and IO peripherals to control hardware.",
        2: "Distance sensors gather environmental telemetry and feed data into the Arduino, making them inputs.",
        3: "LEDs produce visual illumination based on controller pin voltages, making them outputs.",
        4: "Ground (GND) is the 0V reference potential and essential return path for electric current.",
        5: "In 5V digital logic, HIGH commands the output transistor to connect to the positive 5V supply rail.",
        6: "The first parameter of digitalWrite specifies the target hardware pin on the ATmega328P header.",
        7: "Potentiometers output a continuously variable voltage division ratio between 0V and 5V.",
        8: "Systematic programmers analyze pin assignments and logic to predict behavior before applying electrical power."
    }
    for qnum, qtext, oblock in q_blocks:
        num = int(qnum)
        opts = [o.strip() for o in re.findall(r'-\s+(.*)', oblock)]
        out.append({
            'question': qtext.strip(),
            'options': opts,
            'correctIndex': correct_map.get(num, 0),
            'explanation': explanations.get(num, "Review the lesson materials to master this concept.")
        })
    return out

def parse_questions_21b(text):
    m = re.search(r'## 14\. Knowledge Check.*?\n(.*?)(?=\n## 15|\Z)', text, re.DOTALL)
    kc = m.group(1).strip()
    q_blocks = re.findall(r'### Question (\d+)\s*\n(.*?)\n(.*?)\n\*\*Correct:\*\*\s*([A-C])', kc, re.DOTALL)
    out = []
    explanations = {
        1: "IDE stands for Integrated Development Environment—the unified coding and flashing workbench.",
        2: "An Arduino sketch is the C++ program file containing setup() and loop() routines.",
        3: "The compiler translates human-readable C++ source text into hexadecimal machine opcodes.",
        4: "Upload uses the avrdude utility to transfer compiled hex binary through USB into microcontroller flash memory.",
        5: "Different microcontroller boards use distinct pin layouts, register maps, and flash sizes.",
        6: "The serial COM port provides the virtual UART communication link between host OS and the Uno board.",
        7: "void setup() executes once upon microcontroller boot or hardware reset to initialize peripherals.",
        8: "void loop() is called repeatedly in a perpetual cycle to process real-time events."
    }
    for qnum, qtext, oblock, corr in q_blocks:
        num = int(qnum)
        opts = [o.strip() for o in re.findall(r'-\s+(.*)', oblock)]
        c_idx = ord(corr.strip().upper()) - ord('A')
        out.append({
            'question': qtext.strip(),
            'options': opts,
            'correctIndex': c_idx,
            'explanation': explanations.get(num, "Review the workstation configuration steps.")
        })
    return out

def parse_questions_21c_l(text):
    m = re.search(r'## 13\. Knowledge Check.*?\n(.*?)(?=\n## 14|\Z)', text, re.DOTALL)
    kc = m.group(1).strip()
    q_blocks = re.findall(r'(\d+)\.\s+\*\*(.*?)\*\*\s*\n(.*?)(?=\n\d+\.|\Z)', kc, re.DOTALL)
    out = []
    for qnum, qtext, oblock in q_blocks:
        raw_opts = re.findall(r'-\s+\[([ xX])\]\s+(.*)', oblock)
        opts = []
        c_idx = 0
        for idx, (check, opt) in enumerate(raw_opts):
            opts.append(opt.strip())
            if check.strip().lower() == 'x':
                c_idx = idx
        out.append({
            'question': qtext.strip(),
            'options': opts,
            'correctIndex': c_idx,
            'explanation': f"Correct: {opts[c_idx]}. Understanding this principle ensures proper circuit function and reliability."
        })
    return out

def build_lesson_01(plan_text=None):
    qs = [
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

    steps = [
        {
            "stepId": "l01_s01",
            "title": "Meet the Monster Brain",
            "type": "story",
            "interactiveWidgetType": "visualFlowDiagram",
            "markdownContent": (
                "A robot needs a brain! The **Arduino Uno** is a small microcontroller development board that reads information from the physical world and commands electronic mechanisms.\n\n"
                "It can read a pushbutton, measure distance with an ultrasonic sensor, turn an LED on or off, control a motor through a driver chip, and talk to other smart devices.\n\n"
                "The Arduino does not magically know what to do. A **program** tells it what to look for and what decisions to make.\n\n"
                "```\nSensor (Input) ➔ Arduino Uno ➔ Program Decision ➔ Actuator (Output)\n```\n\n"
                "Test the interactive signal flow below to watch how information moves through the brain!"
            )
        },
        {
            "stepId": "l01_s02",
            "title": "What Is a Microcontroller? Architecture & Vocabulary",
            "type": "story",
            "interactiveWidgetType": "visualFlowDiagram",
            "markdownContent": (
                "A **microcontroller** is a self-contained computer on a single chip, built specifically to interact with electrical hardware. Unlike a desktop computer with a monitor and keyboard, a microcontroller lives inside devices.\n\n"
                "It contains:\n"
                "- **CPU (Processor)**: Executes your code instructions up to 16 million times per second (16 MHz).\n"
                "- **Flash Memory**: Stores your compiled sketch even when power is turned off.\n"
                "- **RAM**: Holds temporary variables and sensor readings while running.\n"
                "- **GPIO Pins**: General Purpose Input/Output connections that wire into circuits.\n\n"
                "### Core Vocabulary\n"
                "- **Microcontroller**: A compact computer engineered to control physical electronics.\n"
                "- **Program (Sketch)**: Step-by-step instructions that tell the controller what logic to execute.\n"
                "- **Input**: Sensory data flowing **into** the controller from the world.\n"
                "- **Output**: A physical voltage or command sent **out** to control hardware."
            )
        },
        {
            "stepId": "l01_s03",
            "title": "Inputs vs Outputs: Think Like a Robot",
            "type": "story",
            "interactiveWidgetType": "inputOutputClassification",
            "markdownContent": (
                "Robots interact with reality through two fundamental types of hardware:\n\n"
                "### 1. Inputs (The Senses)\n"
                "Sensors collect data from the environment and send electrical signals into the Arduino:\n"
                "- **Pushbutton**: Senses physical finger touch\n"
                "- **Ultrasonic Sensor**: Measures distance by bouncing sound waves\n"
                "- **Potentiometer**: Reads the angle of a rotating knob\n"
                "- **Light Sensor (LDR)**: Measures environmental room brightness\n\n"
                "### 2. Outputs (The Muscles & Voices)\n"
                "Actuators receive voltage commands from the Arduino to change the physical world:\n"
                "- **LED**: Shines colored light\n"
                "- **Piezo Buzzer**: Vibrates to create beeps and musical tones\n"
                "- **4-Digit Display**: Shows numbers and scores\n"
                "- **Servo Motor**: Moves arms and steers robot wheels\n\n"
                "### Classification Mission\n"
                "Classify each hardware component in the mission below as an **Input** or **Output**!"
            )
        },
        {
            "stepId": "l01_s04",
            "title": "Digital vs Analog Signals & Prediction",
            "type": "visualExplanation",
            "interactiveWidgetType": "arduinoBoardInspector",
            "markdownContent": (
                "Electronics communicate using two distinct types of electrical signals:\n\n"
                "### 1. Digital Signals (Binary)\n"
                "Digital signals have only **two discrete states**:\n"
                "- **HIGH**: +5.0 Volts (ON / TRUE / Binary 1)\n"
                "- **LOW**: 0.0 Volts (OFF / FALSE / Binary 0)\n"
                "Like a simple light switch, a digital pin is either fully powered or off.\n\n"
                "### 2. Analog Signals (Continuous)\n"
                "Analog signals can represent **any smooth value** across a continuous range between 0.0V and 5.0V.\n"
                "The Arduino uses an internal **Analog-to-Digital Converter (ADC)** on pins A0–A5 to convert voltage into an integer from **0 to 1023**.\n\n"
                "Explore both signal modes below and test your prediction on potentiometer behavior!"
            )
        },
        {
            "stepId": "l01_s05",
            "title": "Meet the Arduino Uno: Physical Hardware Mission",
            "type": "physicalTask",
            "interactiveWidgetType": "boardLabelDragDrop",
            "markdownContent": (
                "Take your Arduino Uno development board in your hands. Look closely at the surface-mount components, pin headers, and silk-screen labels.\n\n"
                "### Key Board Landmarks to Identify:\n"
                "1. **USB Type-B Port**: Connects to your PC for code uploading and delivers 5V DC power.\n"
                "2. **DC Barrel Jack**: External power input (accepts 7V–12V from battery pack or wall adapter).\n"
                "3. **Digital Pins 0–13**: Top header pins for binary inputs and outputs (pins with `~` support PWM).\n"
                "4. **Analog Pins A0–A5**: Bottom right header reading continuous sensory voltages.\n"
                "5. **Power Rails (5V & 3.3V)**: Regulated power sources for sensors and breadboard circuits.\n"
                "6. **GND (Ground)**: The 0V reference potential and return path for all electricity.\n"
                "7. **Reset Button**: Restarts your program from the very beginning of `setup()`.\n"
                "8. **Built-in LED**: Amber test LED connected internally to Digital Pin 13.\n\n"
                "Drag and match each label badge to its corresponding landmark below!"
            )
        },
        {
            "stepId": "l01_s06",
            "title": "Why Power and Ground Matter: Complete Circuits",
            "type": "story",
            "interactiveWidgetType": "groundTroubleshooting",
            "markdownContent": (
                "Electricity can only do work when it flows in an **unbroken, closed loop**.\n\n"
                "In every electronic circuit:\n"
                "1. Energy leaves the positive power supply (+5V).\n"
                "2. It travels through wires and components (resistors, LEDs, sensors).\n"
                "3. It returns safely to **Ground (GND)**.\n\n"
                "```\n+5V Power Rail ➔ Current-Limiting Resistor ➔ LED Anode ➔ GND Return Rail\n```\n\n"
                "> **The Ground Invariant**: GND is not a trash bin where electricity disappears! It is the zero-volt reference and the return highway for electron current. If the GND wire is loose or disconnected, the circuit opens, current drops to 0 mA, and nothing works.\n\n"
                "Test the 4 circuit conditions below to observe normal, open, loose, and shorted ground connections."
            )
        },
        {
            "stepId": "l01_s07",
            "title": "How the Robot Brain Makes Decisions",
            "type": "story",
            "interactiveWidgetType": "decisionSimulator",
            "markdownContent": (
                "The microcontroller brain doesn't guess what to do—it processes a clear logic sequence:\n\n"
                "```\nCondition (Input) ➔ Decision (Code Logic) ➔ Action (Output)\n```\n\n"
                "### The 3-Step Decision Pipeline:\n"
                "1. **Input**: A finger pushes the button, closing the contacts and delivering 5V to Pin 2.\n"
                "2. **Decision**: The microcontroller runs code: `if (digitalRead(2) == HIGH)`. The condition evaluates to **TRUE**.\n"
                "3. **Action**: The program commands the output: `digitalWrite(13, HIGH);`, powering on the Pin 13 LED!\n\n"
                "Press and hold the virtual tactile button below to watch the decision pipeline evaluate live."
            )
        },
        {
            "stepId": "l01_s08",
            "title": "Your First Instruction: Deconstructing digitalWrite",
            "type": "codeExperiment",
            "interactiveWidgetType": "codeDeconstruction",
            "markdownContent": (
                "Before writing whole sketches, let's deconstruct the most famous instruction in robotics:\n\n"
                "```cpp\ndigitalWrite(13, HIGH);\n```\n\n"
                "### What Each Token Means:\n"
                "- `digitalWrite`: The function name. Commands a digital pin to output voltage.\n"
                "- `(` and `)`: Parentheses containing the arguments.\n"
                "- `13`: The pin number. Digital Pin 13 is connected to the onboard amber LED.\n"
                "- `,`: Comma separating the target pin from the state.\n"
                "- `HIGH`: The output state. Connects Pin 13 to +5 Volts.\n"
                "- `;`: The semicolon. Every instruction in C++ terminates with a semicolon, like a period.\n\n"
                "Tap each code token below to inspect its job, then predict and simulate its hardware execution!"
            )
        },
        {
            "stepId": "l01_s09",
            "title": "Trust but Verify: Scientific Engineering Method",
            "type": "story",
            "interactiveWidgetType": "engineeringPrediction",
            "markdownContent": (
                "Great robotics engineers never blindly upload code from the internet. They use the **Scientific Engineering Method**:\n\n"
                "```\nRead Code ➔ Predict Outcome ➔ Upload ➔ Observe ➔ Verify ➔ Change & Test\n```\n\n"
                "Before uploading any sketch to an Arduino board, always ask:\n"
                "1. Which pin number does this code command?\n"
                "2. Is my physical jumper wire plugged into that exact pin?\n"
                "3. What do the constants and delays mean?\n"
                "4. What physical motion or light do I predict will happen?\n\n"
                "Practice this habit below: Predict what happens when `HIGH` is replaced with `LOW`!"
            )
        },
        {
            "stepId": "l01_s10",
            "title": "Real-World Systems: Obstacle Avoidance & Robot Vacuums",
            "type": "visualExplanation",
            "interactiveWidgetType": "realWorldSystemDiagram",
            "markdownContent": (
                "The simple **Input ➔ Decision ➔ Output** pattern you just learned is the foundation of modern automation:\n\n"
                "- **Robot Vacuums**: Ultrasonic sensor measures distance to wall ➔ if distance < 20cm ➔ reverse right wheel to steer away.\n"
                "- **Automatic Supermarket Doors**: Motion sensor detects approaching customer ➔ if motion detected ➔ slide glass doors open for 5 seconds.\n"
                "- **Security Intruder Alarms**: Laser tripwire monitors doorway ➔ if beam broken ➔ blast siren and flash strobe lights.\n\n"
                "Select each automated system below and simulate how it reacts to environmental triggers!"
            )
        },
        {
            "stepId": "l01_s11",
            "title": "Troubleshooting Challenge: The Silent LED",
            "type": "story",
            "interactiveWidgetType": "interactiveTroubleshooting",
            "markdownContent": (
                "A fellow robotics student calls you over in frustration: *\"I uploaded my sketch, but my LED refuses to light up!\"*\n\n"
                "Instead of randomly moving wires or rewriting code, follow the **4-Step Diagnostic Triage**:\n"
                "1. **Check Power**: Is the green ON LED lit on the Arduino?\n"
                "2. **Check Code**: What pin number is commanded `HIGH` in `digitalWrite`?\n"
                "3. **Check Physical Wiring**: Which header pin is the physical jumper wire actually plugged into?\n"
                "4. **Identify Mismatch**: Compare code pin vs physical pin!\n\n"
                "Inspect the test bench below, find the pin mismatch bug, and fix the circuit!"
            )
        },
        {
            "stepId": "l01_s12",
            "title": "Final Review & Self-Reflection",
            "type": "story",
            "interactiveWidgetType": "miniQuiz",
            "markdownContent": (
                "Congratulations on completing your first robotics investigation! Let's review the fundamental principles:\n\n"
                "- The **Arduino Uno** is a microcontroller development board powered by the **ATmega328P chip**.\n"
                "- **Inputs** collect sensory data; **Outputs** perform physical work in the world.\n"
                "- **Digital signals** are strictly binary (0V or 5V); **Analog signals** represent smooth continuous ranges (0–1023 ADC).\n"
                "- Circuits require an unbroken loop: current flows from **+5V**, through components, and returns safely through **GND**.\n"
                "- Code instructions like `digitalWrite(pin, state);` command specific pins, so physical wiring must match code exactly.\n\n"
                "Complete the 4-question self-reflection check below before tackling the final Knowledge Check!"
            )
        },
        {
            "stepId": "l01_s13",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of microcontrollers, signal types, power paths, and code prediction with this 8-question knowledge check.",
            "interactiveConfig": {
                "question": qs[3]["question"],
                "options": qs[3]["options"],
                "correctIndex": qs[3]["correctIndex"],
                "explanation": qs[3]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_01",
        "title": "What is Arduino & How Does It Work?",
        "summary": "Discover the brain of your robot! Learn what microcontrollers do, explore the pins, and understand how power flows.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": [],
        "componentIds": ["comp_uno"],
        "steps": steps,
        "xpReward": 50
    }

def build_lesson_02(plan_text):
    qs = parse_questions_21b(plan_text)

    prior_check_questions = [
        {
            "question": "Have you ever written a computer program before?",
            "options": [
                "Yes, I have written code before.",
                "A little bit / block coding.",
                "No, this is my very first time!"
            ],
            "correctIndex": None,
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

    steps = [
        {
            "stepId": "l02_s01",
            "title": "Give the Monster Its Voice",
            "type": "story",
            "markdownContent": (
                "The Arduino is the robot's brain, but the brain needs instructions.\n\n"
                "Your computer is where you write those instructions. The **Arduino IDE** (Integrated Development Environment) "
                "is the workbench that lets you write sketches, verify syntax, compile machine binaries, upload them to the board, "
                "and monitor serial communications.\n\n"
                "Think of the engineering workflow as:\n"
                "```\nWrite Code ➔ Check Syntax ➔ Compile Binary ➔ Upload Flash ➔ Run Hardware\n```\n\n"
                "In this lesson, you will set up your development station, select your communication port, and explore how "
                "firmware lifecycles work."
            )
        },
        {
            "stepId": "l02_s02",
            "title": "Prior Knowledge Check: Computer Programs & USB",
            "type": "story",
            "interactiveWidgetType": "priorKnowledgeCheck",
            "interactiveConfig": {
                "questions": prior_check_questions
            },
            "markdownContent": (
                "Before setting up your programming workbench, let's check your foundational knowledge about computer software and USB hardware.\n\n"
                "Answer the 3 self-reflection questions below to calibrate your learning path!"
            )
        },
        {
            "stepId": "l02_s03",
            "title": "What Is an IDE? The Programmer's Workbench",
            "type": "story",
            "markdownContent": (
                "**IDE** stands for **Integrated Development Environment**.\n\n"
                "Think of it as a master workshop for robotics software. Instead of using a text editor to write code, "
                "a separate command-line terminal to compile it, and a third utility to flash the microcontroller chip, "
                "the Arduino IDE bundles all essential tools into one unified workbench.\n\n"
                "### Core Vocabulary\n"
                "- **IDE**: Unified software used to write, compile, and upload sketches.\n"
                "- **Sketch**: An Arduino program file ending in `.ino`.\n"
                "- **Compile**: The process of translating human-readable C++ instructions into binary machine code.\n"
                "- **Upload**: Transmitting the compiled machine hex binary from PC memory into microcontroller flash storage.\n"
                "- **Port**: The virtual serial communication channel (e.g. `COM3` or `/dev/ttyUSB0`) connecting your PC to the board."
            )
        },
        {
            "stepId": "l02_s04",
            "title": "Compilation & Flashing: What Happens When You Upload?",
            "type": "visualExplanation",
            "interactiveWidgetType": "compilationPipelineSimulator",
            "markdownContent": (
                "When you click **Upload** in the IDE, your computer does not send C++ words directly to the ATmega328P chip. "
                "Microcontrollers cannot read English or C++! They only understand raw hexadecimal binary opcodes.\n\n"
                "### The 4-Stage Build & Flash Pipeline:\n"
                "1. **Human Source Code**: You write C++ functions (`setup()` and `loop()`).\n"
                "2. **Syntax Verification & Lexing**: The compiler checks grammar, matching braces `{ }`, and semicolons `;`.\n"
                "3. **Binary Compilation (avr-g++)**: Converts C++ text into machine opcodes (Intel HEX format).\n"
                "4. **Hardware Flash Flashing (avrdude)**: Streams bytes over USB serial into the Optiboot bootloader in flash memory.\n\n"
                "Step through each stage in the pipeline simulator below to see how code transforms into machine reality!"
            )
        },
        {
            "stepId": "l02_s05",
            "title": "Connecting the USB Cable Safely",
            "type": "physicalTask",
            "markdownContent": (
                "Connect your Arduino Uno development board to your computer using the standard USB Type-B cable.\n\n"
                "### Step-by-Step Connection Procedure:\n"
                "1. **Inspect Your Workspace**: Ensure your table is completely dry, clean, and free of loose conductive metal clippings or staples.\n"
                "2. **Plug Board End**: Firmly insert the square **USB Type-B** plug into the silver receptacle on your Arduino Uno until it clicks.\n"
                "3. **Plug Computer End**: Insert the flat rectangular **USB Type-A** plug into a powered USB port on your PC or laptop.\n"
                "4. **Verify Power Beacon**: Look at the Arduino Uno. The green surface-mount LED labeled **ON** should glow solid green, indicating regulated 5V power!"
            )
        },
        {
            "stepId": "l02_s06",
            "title": "What Is a Port? Serial COM Ports & Device Drivers",
            "type": "story",
            "interactiveWidgetType": "portSelectorBench",
            "markdownContent": (
                "A **port** is the communication channel your computer uses to identify and talk to external USB devices.\n\n"
                "On Windows, ports are assigned names like `COM1`, `COM3`, `COM4`. On macOS and Linux, they appear as `/dev/cu.usbmodem...` or `/dev/ttyUSB0`.\n\n"
                "When you plug in the Arduino, an onboard interface chip (ATmega16U2 or CH340) creates a virtual UART serial communication bridge.\n\n"
                "In the IDE menu under **Tools > Board**, choose **Arduino Uno**. Under **Tools > Port**, select the port corresponding to your Uno. "
                "Practice configuring the board and port in the virtual bench below, and initiate the serial handshake to flash TX and RX LEDs!"
            )
        },
        {
            "stepId": "l02_s07",
            "title": "First Look at Arduino Code: setup() and loop() Structure",
            "type": "codeExperiment",
            "interactiveWidgetType": "ideLifecycleSimulator",
            "markdownContent": (
                "Every Arduino sketch is built around two fundamental functions:\n\n"
                "```cpp\nvoid setup() {\n  // Hardware configuration — runs ONCE at boot or reset\n  pinMode(13, OUTPUT);\n}\n\nvoid loop() {\n  // Perpetual cycle — runs REPEATEDLY forever\n  digitalWrite(13, HIGH);\n  delay(1000);\n  digitalWrite(13, LOW);\n  delay(1000);\n}\n```\n\n"
                "- `setup()`: Initializes GPIO pin directions and communications. It runs exactly once when power is applied.\n"
                "- `loop()`: The infinite heartbeat of your robot. Once `setup()` finishes, the microcontroller jumps into `loop()` and orbits perpetually.\n\n"
                "Run the interactive lifecycle simulator below to watch `setup()` illuminate its beacon once, followed by the continuous orbit of `loop()`!"
            )
        },
        {
            "stepId": "l02_s08",
            "title": "Code Prediction Challenge: Empty Setup vs Unbounded Loops",
            "type": "codeExperiment",
            "markdownContent": (
                "Analyze and predict how the microcontroller executes when code structure changes:\n\n"
                "### Prediction Challenge 1: Empty setup(), Active loop()\n"
                "If `setup()` is completely empty, does the Arduino freeze?\n"
                "*Answer:* No! `setup()` finishes in nanoseconds and immediately begins cycling `loop()`.\n\n"
                "### Prediction Challenge 2: Active setup(), Empty loop()\n"
                "If an LED is turned ON inside `setup()`, and `loop()` has no code inside its braces `{ }`, what does the LED do?\n"
                "*Answer:* The LED turns ON in `setup()` and stays ON forever! The microcontroller continues running `loop()` endlessly at 16 MHz, maintaining the pin voltage state.\n\n"
                "> **Core Principle**: A microcontroller never powers down or \"exits\" unless electrical power is disconnected."
            )
        },
        {
            "stepId": "l02_s09",
            "title": "Real-World Systems: NASA Mars Rovers & Embedded Firmware",
            "type": "visualExplanation",
            "markdownContent": (
                "The `setup()` and `loop()` firmware architecture powers mission-critical robotics worldwide:\n\n"
                "- **NASA Mars Rovers (Curiosity & Perseverance)**: Execute diagnostic sensor self-tests upon wake-up (`setup()`), then run autonomous hazard-avoidance cycles continuously (`loop()`).\n"
                "- **Automotive Airbag Control Units**: Initialize SPI accelerometer calibrations at engine start, then monitor vehicle deceleration thresholds every 100 microseconds in an unbroken loop.\n"
                "- **Commercial Drones**: Zero out gyroscope bias on launch pads, then calculate motor thrust adjustments 400 times per second during flight."
            )
        },
        {
            "stepId": "l02_s10",
            "title": "Troubleshooting Lab Station: Port Not Found & Driver Issues",
            "type": "story",
            "interactiveWidgetType": "portTroubleshootingBench",
            "markdownContent": (
                "If the Arduino IDE reports *\"Port Not Found\"* or errors out during upload, do not panic! Professional robotics engineers use systematic triage:\n\n"
                "1. **Check Physical Connection**: Is the USB cable fully seated into the jack?\n"
                "2. **Check Port Selection**: Is the active Arduino COM port chosen, or an internal motherboard port like COM1?\n"
                "3. **Check USB Drivers**: Does your board use a CH340 or CP2102 chip that requires an OS device driver?\n"
                "4. **Check Board Power**: Does the green ON LED illuminate, proving 5V power?\n\n"
                "Inspect each diagnostic check in the triage bench below, resolve all 4 faults, and restore full communication link!"
            )
        },
        {
            "stepId": "l02_s11",
            "title": "Workshop Safety: Electrostatic Discharge (ESD) & Surge Prevention",
            "type": "story",
            "interactiveWidgetType": "esdSafetyCheck",
            "markdownContent": (
                "Microcontrollers are sensitive CMOS semiconductor devices. A spark of static electricity under 3,000 volts—too faint for human fingers to feel—can permanently destroy internal silicon transistor gate oxide layers!\n\n"
                "### The 3 Golden Rules of ESD Defense:\n"
                "1. **Touch Grounded Metal**: Touch a metal desk frame or radiator before handling boards to discharge accumulated static charge to 0V.\n"
                "2. **Avoid Static Generators**: Never assemble circuits directly on synthetic carpet or wool blankets.\n"
                "3. **Grip PCB Edges**: Always pick up boards by the outer fiberglass edges. Never touch exposed IC pins or header pins directly with your fingers.\n\n"
                "Practice proper ESD grounding in the interactive lab below to bring your static voltage potential down to a safe 0 Volts!"
            )
        },
        {
            "stepId": "l02_s12",
            "title": "Station Setup Review & Competencies",
            "type": "story",
            "markdownContent": (
                "Congratulations! You have set up your Monster Lab development station. Review your core competencies:\n\n"
                "- You understand how the Arduino IDE coordinates writing, verifying, compiling, and flashing code.\n"
                "- You know how to identify and select target microcontroller boards and serial communication ports.\n"
                "- You recognize the vital roles of `setup()` (initialization, runs 1x) and `loop()` (perpetual execution).\n"
                "- You can systematically troubleshoot disconnected ports and missing USB bridge drivers.\n"
                "- You apply electrostatic discharge (ESD) safety protocols to protect your hardware.\n\n"
                "Complete the comprehensive 8-question assessment below to earn your XP and proceed to Lesson 03!"
            )
        },
        {
            "stepId": "l02_s13",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Verify your understanding of IDE compilation, USB device drivers, COM ports, and firmware lifecycles.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_02",
        "title": "Setting Up Your Monster Lab Station",
        "summary": "Install the Arduino IDE, connect your board via USB, and verify serial communication link.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_01"],
        "componentIds": ["comp_uno"],
        "steps": steps,
        "xpReward": 50
    }

def build_lesson_03(plan_text):
    qs = parse_questions_21c_l(plan_text)

    prior_check_questions = [
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

    steps = [
        {
            "stepId": "l03_s01",
            "title": "Supercharge Your Monster's Brain",
            "type": "story",
            "markdownContent": (
                "Robots rely on specialized external modules: character displays, motor drivers, gyro sensors, and real-time clocks. "
                "Controlling a 16x2 LCD display via raw 8-bit parallel pulses requires toggling 16 separate pins and managing microsecond pulse timings.\n\n"
                "If robotics engineers had to write low-level bit-banging code for every single display, building a project would take months!\n\n"
                "**Libraries** package proven, robust C++ driver code written by experienced engineers so you can command complex hardware with high-level functions like `lcd.print(\"Monster Online!\");`.\n\n"
                "```\nYour Sketch ➔ #include <LiquidCrystal_I2C.h> ➔ Library Driver ➔ I2C Bus (A4/A5) ➔ 16x2 LCD Display\n```\n\n"
                "In this lesson, you will install external libraries, deconstruct preprocessor syntax, and calibrate an I2C character LCD display!"
            )
        },
        {
            "stepId": "l03_s02",
            "title": "Prior Knowledge Check: Microcontroller Libraries",
            "type": "story",
            "interactiveWidgetType": "priorKnowledgeCheck",
            "interactiveConfig": {
                "questions": prior_check_questions
            },
            "markdownContent": (
                "Before working with modular drivers and display backpacks, let's verify your understanding of code abstraction and bus communication.\n\n"
                "Answer the 3 self-check questions below to test your baseline knowledge!"
            )
        },
        {
            "stepId": "l03_s03",
            "title": "The Power of Libraries: Raw Registers vs Clean Abstraction",
            "type": "story",
            "interactiveWidgetType": "libraryConceptDiagram",
            "markdownContent": (
                "Why do professional embedded engineers rely on libraries? Look at the difference:\n\n"
                "### Without Library (Bit-Banging Raw Hardware)\n"
                "Driving an I2C LCD directly requires over 500 lines of complex register manipulation (`TWCR`, `TWDR`), manual I2C start/stop condition pulses, "
                "splitting each character into two 4-bit nibbles, and microsecond delay loops.\n\n"
                "### With Library (Modular Abstraction)\n"
                "With the `LiquidCrystal_I2C` library, all 500 lines of timing pulses are packaged away. You only need two clean function calls:\n"
                "```cpp\nlcd.init();\nlcd.print(\"Monster Online!\");\n```\n\n"
                "Toggle between both architectures in the diagram below to see how libraries supercharge development!"
            )
        },
        {
            "stepId": "l03_s04",
            "title": "How It Works: Finding & Installing Libraries",
            "type": "visualExplanation",
            "interactiveWidgetType": "libraryManagerSimulator",
            "markdownContent": (
                "The Arduino IDE includes a built-in **Library Manager** connected to an open-source global registry of thousands of community-verified drivers.\n\n"
                "### How to Install a Library in Arduino IDE:\n"
                "1. Open **Tools > Manage Libraries...** (or click the Library Manager icon on the left sidebar).\n"
                "2. Type the name of the library (for example, `LiquidCrystal_I2C`) into the search box.\n"
                "3. Locate the verified library authored by Frank de Brabander.\n"
                "4. Click **Install**. The IDE downloads the header files (`.h`), C++ implementations (`.cpp`), and example sketches directly into your `~/Arduino/libraries/` folder.\n\n"
                "Test the interactive Library Manager below to search, download, and install `LiquidCrystal_I2C`!"
            )
        },
        {
            "stepId": "l03_s05",
            "title": "Hardware Mission: The 16x2 LCD Display & Contrast Potentiometer",
            "type": "physicalTask",
            "interactiveWidgetType": "lcdContrastSimulator",
            "markdownContent": (
                "Examine your **16x2 Character LCD Display with I2C Backpack** (`comp_07`):\n\n"
                "### Key Hardware Landmarks:\n"
                "1. **The I2C Backpack**: Turn the module over. Notice the black printed circuit board soldered to the back. This contains the PCF8574 I/O expander chip.\n"
                "2. **The 4-Pin Header**: Without this backpack, you would need 16 jumper wires! With I2C, you only need 4:\n"
                "   - `GND`: Ground 0V return path\n"
                "   - `VCC`: +5V power supply\n"
                "   - `SDA`: Serial Data (connects to Uno Pin A4)\n"
                "   - `SCL`: Serial Clock (connects to Uno Pin A5)\n"
                "3. **The Blue Contrast Trimmer**: Locate the small blue square potentiometer with the brass screw on the back. It controls liquid crystal bias voltage (V0).\n\n"
                "The #1 troubleshooting issue is misadjusted contrast! Tune the virtual trimmer potentiometer screw below to find the sweet spot between blank screen and solid white blocks."
            )
        },
        {
            "stepId": "l03_s06",
            "title": "Coding Basics: Deconstructing the #include Directive",
            "type": "story",
            "interactiveWidgetType": "includeSyntaxDeconstruction",
            "markdownContent": (
                "To use an installed library, your sketch must instruct the C++ compiler to load its interface definitions:\n\n"
                "```cpp\n#include <LiquidCrystal_I2C.h>\n```\n\n"
                "### Syntax Breakdown:\n"
                "- `#`: Preprocessor flag indicating a compiler directive evaluated before compilation begins.\n"
                "- `include`: Command instructing the compiler to literally insert the contents of the header file.\n"
                "- `< >`: Angle brackets tell the compiler to search the system/installed libraries directory.\n"
                "- `.h`: The header file extension containing class definitions and function signatures.\n\n"
                "Tap each syntax token below to inspect its rules and avoid common syntax traps!"
            )
        },
        {
            "stepId": "l03_s07",
            "title": "Code Walkthrough: Annotated LiquidCrystal_I2C Sketch",
            "type": "codeExperiment",
            "markdownContent": (
                "Examine a complete sketch driving the 16x2 character display:\n\n"
                "```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// Create the LCD object: Address 0x27, 16 columns, 2 rows\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();          // Initialize LCD hardware over I2C\n  lcd.backlight();     // Turn on the blue LED backlight\n  lcd.setCursor(0, 0); // Column 0, Row 0\n  lcd.print(\"Monster Lab!\");\n  lcd.setCursor(0, 1); // Column 0, Row 1\n  lcd.print(\"System Active\");\n}\n\nvoid loop() {\n  // Static display — loop remains idle\n}\n```\n\n"
                "### Key Function Calls:\n"
                "- `LiquidCrystal_I2C lcd(...)`: The **constructor**. Instantiates an object named `lcd` at hex address `0x27`.\n"
                "- `lcd.init()`: Configures internal HD44780 controller registers over the I2C bus.\n"
                "- `lcd.backlight()`: Powers on the display illumination LED.\n"
                "- `lcd.setCursor(col, row)`: Places the writing cursor at the specified zero-indexed grid coordinate."
            )
        },
        {
            "stepId": "l03_s08",
            "title": "Code Prediction: Missing Backlight & Out-of-Bounds Cursors",
            "type": "codeExperiment",
            "markdownContent": (
                "Practice scientific engineering deductions before flashing code:\n\n"
                "### Prediction 1: What happens if lcd.backlight() is omitted?\n"
                "*Answer:* The characters are still generated by the liquid crystal molecules, but without the LED backlight, the dark blue screen is nearly impossible to read without shining a flashlight directly onto it!\n\n"
                "### Prediction 2: What happens if you call lcd.setCursor(16, 0)?\n"
                "*Answer:* Columns are zero-indexed from 0 to 15. Column 16 is off the visible screen! The characters will wrap into hidden DDRAM display memory registers and remain invisible."
            )
        },
        {
            "stepId": "l03_s09",
            "title": "Guided Experiment: Dynamic Uptime Counter",
            "type": "codeExperiment",
            "markdownContent": (
                "Let's make the display dynamic! Instead of static text, we can update Row 1 continuously with live system uptime:\n\n"
                "```cpp\nvoid loop() {\n  lcd.setCursor(0, 1);\n  lcd.print(\"Uptime: \");\n  lcd.print(millis() / 1000);\n  lcd.print(\"s   \"); // Extra spaces erase trailing old digits\n  delay(500);\n}\n```\n\n"
                "### Why the trailing spaces matter:\n"
                "When a 2-digit number (e.g. `99`) rolls over to a 3-digit number (`100`), or drops back down, older characters remain in LCD RAM unless explicitly overwritten with space characters `\"   \"`!"
            )
        },
        {
            "stepId": "l03_s10",
            "title": "Real-World Robotics: Hardware Abstraction Layers",
            "type": "visualExplanation",
            "markdownContent": (
                "The modular library architecture you learned is used in every advanced engineering discipline:\n\n"
                "- **Autonomous Electric Vehicles**: Autonomous drive computers don't send raw PWM pulses to motor windings directly. They call driver libraries: `motorController.setTorqueNm(240);`.\n"
                "- **Medical Ventilators**: Airflow sensors and solenoid valves are controlled through certified Hardware Abstraction Layers (HAL) to prevent timing glitches.\n"
                "- **3D Printers**: Firmware like Marlin uses stepper motor and thermal thermistor libraries to coordinate micro-stepping smoothly."
            )
        },
        {
            "stepId": "l03_s11",
            "title": "Troubleshooting Challenge: Missing Header & Blank Displays",
            "type": "story",
            "interactiveWidgetType": "missingLibraryTroubleshooting",
            "markdownContent": (
                "You verify a sketch and the compiler halts with a bright red fatal error:\n\n"
                "```\nfatal error: LiquidCrystal_I2C.h: No such file or directory\n#include <LiquidCrystal_I2C.h>\n         ^~~~~~~~~~~~~~~~~~~~~\ncompilation terminated.\n```\n\n"
                "This means the preprocessor searched your system libraries folder and could not find the file `LiquidCrystal_I2C.h`.\n\n"
                "Resolve this compilation failure in the interactive triage station below by installing the missing library!"
            )
        },
        {
            "stepId": "l03_s12",
            "title": "Workshop Safety & Hardware Care: LCD Voltage Ratings",
            "type": "story",
            "markdownContent": (
                "Protect your LCD modules and microcontroller with these workshop rules:\n\n"
                "1. **Check Operating Voltage**: Most character LCD backpacks run on 5V. Supplying 5V power to a 3.3V-only display can permanently fry its internal driver chip.\n"
                "2. **Disconnect Power Before Rewiring**: Never move or rewire `VCC`, `GND`, `SDA`, or `SCL` jumper wires while the USB cable is plugged in.\n"
                "3. **Use Plastic or Insulated Screwdrivers**: When adjusting the blue contrast trimmer on the back of the backpack, use a small insulated trimmer tool to avoid accidentally shorting adjacent exposed solder pads."
            )
        },
        {
            "stepId": "l03_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": (
                "Outstanding work! Let's review the key competencies you mastered in Lesson 03:\n\n"
                "- You understand how libraries encapsulate low-level register bit-banging into clean C++ functions.\n"
                "- You know how to search and install community libraries using the Arduino IDE Library Manager.\n"
                "- You can deconstruct the `#include <LibraryName.h>` preprocessor syntax.\n"
                "- You know how to calibrate LCD liquid crystal contrast using the blue backpack trimmer potentiometer.\n"
                "- You can diagnose and fix `'No such file or directory'` compiler errors.\n\n"
                "Complete the 8-question assessment below to earn your XP and proceed to Lesson 04!"
            )
        },
        {
            "stepId": "l03_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of Arduino libraries, header syntax, I2C addressing, and LCD contrast tuning.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_03",
        "title": "Installing Libraries: Supercharging Code",
        "summary": "Understand open-source modular libraries and how to install them with the Library Manager.",
        "tier": "builder",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_02"],
        "componentIds": ["comp_uno", "comp_07"],
        "steps": steps,
        "xpReward": 60
    }

def build_lesson_04(plan_text):
    qs = parse_questions_21c_l(plan_text)

    prior_check_questions = [
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

    steps = [
        {
            "stepId": "l04_s01",
            "title": "The Never-Sleeping Monster Brain",
            "type": "story",
            "markdownContent": (
                "Unlike desktop programs that launch, calculate a spreadsheet, and quit, a robot's brain must never terminate! "
                "It must continuously monitor distance sensors, evaluate obstacle hazards, and drive motors thousands of times per second until battery power is switched off.\n\n"
                "In this lesson, you will master the two fundamental functions of embedded systems: `setup()`—the one-time initialization routine—and "
                "`loop()`—the perpetual heartbeat of your monster robot. You will also unlock the **Serial Monitor**, the primary debugging terminal "
                "that lets your Arduino talk directly to your computer screen.\n\n"
                "```\nPower On ➔ setup() Initial Setup ➔ while(1) { loop(); Serial Telemetry; } Forever\n```"
            )
        },
        {
            "stepId": "l04_s02",
            "title": "Prior Knowledge Check: Firmware Loops & Semicolons",
            "type": "story",
            "interactiveWidgetType": "priorKnowledgeCheck",
            "interactiveConfig": {
                "questions": prior_check_questions
            },
            "markdownContent": (
                "Before exploring serial telemetry and syntax debugging, test your baseline understanding of microcontroller lifecycles.\n\n"
                "Complete the 3 questions below to prepare for the lesson!"
            )
        },
        {
            "stepId": "l04_s03",
            "title": "Core Concept & Vocabulary: Functions, Blocks & Baud Rates",
            "type": "story",
            "markdownContent": (
                "Master the foundational vocabulary of embedded software:\n\n"
                "### Core Vocabulary\n"
                "- **`setup()`**: Executes exactly once upon board power-up or hardware reset. Used for pin modes and UART startup.\n"
                "- **`loop()`**: Executes repeatedly forever in an unbroken cycle.\n"
                "- **Statement**: A single executable instruction that must conclude with a semicolon `;`.\n"
                "- **Code Block (`{ }`)**: Curly braces group multiple statements into a single function or conditional block.\n"
                "- **Baud Rate**: The transmission speed in bits per second (e.g., 9600 baud = ~960 characters per second).\n"
                "- **Serial Monitor**: An interactive terminal console embedded in the Arduino IDE for text communication with the board."
            )
        },
        {
            "stepId": "l04_s04",
            "title": "How It Works: Microcontroller Heartbeat & 16 MHz Clocks",
            "type": "visualExplanation",
            "interactiveWidgetType": "executionSpeedVisualizer",
            "markdownContent": (
                "The ATmega328P microcontroller is powered by a 16 MHz quartz crystal oscillator. "
                "That means the processor ticks **16 million times every single second** (each clock tick is just 62.5 nanoseconds!).\n\n"
                "Human eyes have a flicker fusion limit of ~60 Hz (16.6 milliseconds), and human reaction time is ~200 milliseconds (200,000,000 nanoseconds!).\n\n"
                "If you toggle an LED ON and OFF inside `loop()` without `delay()`, the LED flips millions of times per second. "
                "To human eyes, it appears as a solid dim light due to Persistence of Vision!\n\n"
                "Compare 16 MHz CPU execution speed against human perception in the visual clock simulator below to understand why `delay()` is essential."
            )
        },
        {
            "stepId": "l04_s05",
            "title": "Hardware Mission: Uno Reset Button & TX/RX Telemetry LEDs",
            "type": "physicalTask",
            "markdownContent": (
                "Pick up your Arduino Uno (`comp_uno`) and locate two critical hardware features:\n\n"
                "### 1. The Hardware Reset Switch\n"
                "Locate the red or yellow pushbutton in the top-left corner near the USB connector. "
                "Pressing this switch pulls the ATmega328P `RESET` pin to GND (0V), restarting program execution from the very beginning of `setup()`!\n\n"
                "### 2. The TX and RX Telemetry LEDs\n"
                "Look closely near Digital Pins 0 and 1. Notice the two tiny surface-mount LEDs labeled **TX** (Transmit) and **RX** (Receive).\n\n"
                "Whenever your sketch sends text to the Serial Monitor via `Serial.print()`, the **TX** LED flashes amber. "
                "Whenever your computer sends characters into the Arduino, the **RX** LED flashes amber!"
            )
        },
        {
            "stepId": "l04_s06",
            "title": "Coding Basics: Spotting & Fixing Syntax Errors",
            "type": "story",
            "interactiveWidgetType": "syntaxErrorDebugger",
            "markdownContent": (
                "The C++ compiler is extremely strict. A single misplaced character stops your code from building entirely:\n\n"
                "### 3 Most Common Rookie Syntax Traps:\n"
                "1. **Missing Semicolon**: Forgetting `;` at the end of a statement (`pinMode(13, OUTPUT)`).\n"
                "2. **Case Sensitivity Errors**: Writing `digitalwrite` instead of camelCase `digitalWrite` (C++ treats lowercase and uppercase as totally different names!).\n"
                "3. **Unmatched Curly Braces**: Forgetting the closing `}` on a function block.\n\n"
                "Inspect the code editor below, spot all 3 syntax bugs, and apply fixes to achieve a clean build!"
            )
        },
        {
            "stepId": "l04_s07",
            "title": "Code Walkthrough: Serial.print() vs Serial.println()",
            "type": "codeExperiment",
            "interactiveWidgetType": "serialPrintExperiment",
            "markdownContent": (
                "How does the Arduino send information to your computer screen? Through the `Serial` object!\n\n"
                "```cpp\nvoid setup() {\n  Serial.begin(9600); // Start serial UART at 9600 bits per second\n}\n\nvoid loop() {\n  Serial.print(\"MONSTER \");   // Prints text on current line\n  Serial.println(\"ONLINE\");   // Prints text and moves to next line (\\r\\n)\n  delay(1000);\n}\n```\n\n"
                "### The Critical Difference:\n"
                "- `Serial.print()`: Outputs characters without a line break. Repeated prints concatenate side-by-side horizontally.\n"
                "- `Serial.println()`: Outputs characters followed by an invisible Carriage Return `\\r` and Line Feed `\\n`. Moves the cursor to line 2.\n\n"
                "Toggle between `print` and `println` in the interactive telemetry experiment below to see how terminal output is formatted!"
            )
        },
        {
            "stepId": "l04_s08",
            "title": "Code Prediction: Setup Loops vs Missing Serial.begin",
            "type": "codeExperiment",
            "markdownContent": (
                "Make predictions about serial telemetry behavior before testing in hardware:\n\n"
                "### Prediction 1: What happens if Serial.println(\"Booting...\") is placed inside loop() instead of setup()?\n"
                "*Answer:* Instead of printing once upon startup, it prints repeatedly every single loop cycle, flooding the Serial Monitor console!\n\n"
                "### Prediction 2: What happens if Serial.begin(9600) is omitted from setup()?\n"
                "*Answer:* The hardware UART baud rate generator registers are never initialized. The ATmega328P will not send bytes over USB, and the Serial Monitor will stay completely blank!"
            )
        },
        {
            "stepId": "l04_s09",
            "title": "Guided Experiment: Accelerating Telemetry Cadence",
            "type": "codeExperiment",
            "markdownContent": (
                "Let's modify loop cadence and observe the telemetry output rate:\n\n"
                "```cpp\nvoid loop() {\n  Serial.print(\"Ping at timestamp: \");\n  Serial.println(millis());\n  delay(250); // Changed from 1000 ms to 250 ms\n}\n```\n\n"
                "### Observations:\n"
                "1. `millis()` is a built-in Arduino timer function returning the number of milliseconds elapsed since the board powered on.\n"
                "2. By reducing `delay(1000)` to `delay(250)`, the board sends **4 telemetry readings every second** instead of 1.\n"
                "3. Notice the TX LED on the Uno: it flashes 4 times per second in perfect synchrony with the loop!"
            )
        },
        {
            "stepId": "l04_s10",
            "title": "Real-World Robotics: NASA Rovers & Automotive State Machines",
            "type": "visualExplanation",
            "markdownContent": (
                "The `setup()`, `loop()`, and `Serial` logging pattern is standard across aerospace and automotive robotics:\n\n"
                "- **NASA Mars Rovers**: Telemetry transmitters stream engineering packet frames over X-band radio back to Earth's Deep Space Network using calibrated bitrates.\n"
                "- **Automotive CAN Bus Diagnostics**: Mechanics plug OBD-II diagnostic scanners into cars to read serial diagnostic trouble codes (DTCs) generated by engine loop telemetry.\n"
                "- **Industrial Packaging Arms**: Factory automation PLCs cycle 1,000 times per second, streaming serial telemetry to factory supervisory control systems."
            )
        },
        {
            "stepId": "l04_s11",
            "title": "Troubleshooting Challenge: Garbled Serial & Baud Rates",
            "type": "story",
            "interactiveWidgetType": "serialMonitorSimulator",
            "markdownContent": (
                "You open the Serial Monitor and instead of clean English text, you see strange inverted question marks and scrambled symbols:\n\n"
                "```\n⸮⸮x~??⸮f⸮⸮▒▒\n```\n\n"
                "This is the #1 Serial Monitor bug: **Baud Rate Mismatch**!\n\n"
                "If your sketch specifies `Serial.begin(9600);` (9600 bits per second), but the Serial Monitor selector dropdown is set to `115200 baud`, "
                "the computer clock samples the electrical wire 12 times faster than the Arduino sends bits! The bit frames get completely scrambled.\n\n"
                "Switch baud rates in the Serial Monitor simulator below to synchronize communication and restore legible text!"
            )
        },
        {
            "stepId": "l04_s12",
            "title": "Workshop Safety & Hardware Care: USB Power & Non-Conductive Surfaces",
            "type": "story",
            "markdownContent": (
                "Observe these essential safety protocols when programming microcontrollers:\n\n"
                "1. **Non-Conductive Work Surfaces**: Always rest your Arduino Uno on a wood desk, cardboard, or antistatic mat. Resting an active board on a metal ruler, laptop aluminum shell, or anti-static bag can short bottom header pins!\n"
                "2. **USB Port Protection**: Never insert or remove jumper wires into the `5V` and `GND` headers while the USB cable is plugged in. Accidental wire bridges can trip computer USB overcurrent protection shutdown.\n"
                "3. **Safe USB Cable Unplugging**: Grip the molded connector body when disconnecting USB cables—never pull on the flexible wire cord."
            )
        },
        {
            "stepId": "l04_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": (
                "Fantastic progress! Let's review the fundamental engineering competencies you mastered in Lesson 04:\n\n"
                "- You understand the embedded execution model: `setup()` runs once at boot; `loop()` runs continuously forever.\n"
                "- You know why 16 MHz microcontrollers require `delay()` to bridge the speed gap to human perception.\n"
                "- You can identify and fix semicolons, camelCase functions, and unmatched curly braces.\n"
                "- You understand how `Serial.print()` concatenates and `Serial.println()` inserts clean newlines.\n"
                "- You know how to resolve garbled serial text by matching baud rates.\n\n"
                "Complete the 8-question assessment below to earn your XP and get ready for Lesson 05: Your first physical circuit!"
            )
        },
        {
            "stepId": "l04_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of microcontroller execution cycles, C++ syntax rules, and UART Serial Monitor telemetry.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_04",
        "title": "Basics of the Arduino IDE: Setup and Loop",
        "summary": "Master the core microcontroller lifecycle: setup() once, loop() forever, and serial monitoring.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_02"],
        "componentIds": ["comp_uno"],
        "steps": steps,
        "xpReward": 60
    }




def build_lesson_05(plan_text):
    qs = parse_questions_21c_l(plan_text)

    prior_check_questions = [
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

    steps = [
        {
            "stepId": "l05_s01",
            "title": "Awaken the Beast: Creating Physical Photons",
            "type": "story",
            "markdownContent": (
                "Software becomes robotics when binary logic gates physically manipulate the physical universe. "
                "Turning an LED on and off is the foundational 'Hello World' of physical computing, proving that your software commands "
                "can source and sink electric current through semiconductor transistors.\n\n"
                "In this mission, you will command electrical charges through silicon gates to create visible light on your Arduino board!\n\n"
                "```\nPORTB5 Register ➔ Internal P-MOSFET Closes ➔ Pin 13 at 5V ➔ Current Flows ➔ SMD LED Glows ➔ GND Return\n```"
            )
        },
        {
            "stepId": "l05_s02",
            "title": "Prior Knowledge Check: Digital Signals & Ground",
            "type": "story",
            "interactiveWidgetType": "priorKnowledgeCheck",
            "interactiveConfig": {
                "questions": prior_check_questions
            },
            "markdownContent": (
                "Before commanding hardware outputs, let's verify your baseline understanding of voltage potentials and Ground reference paths.\n\n"
                "Complete the 3 questions below to prepare for the lab!"
            )
        },
        {
            "stepId": "l05_s03",
            "title": "5mm LED Anatomy & Polarity Inspection",
            "type": "story",
            "interactiveWidgetType": "ledPolarityInspector",
            "markdownContent": (
                "LED stands for **Light Emitting Diode**. Because it is a diode, electricity can only flow through it in one forward direction!\n\n"
                "### Anatomical Clues:\n"
                "- **Cathode (−)**: Connects to Ground (GND). Features a larger triangular **anvil** flag inside the clear epoxy bulb, a **shorter lead**, and a **flat edge** along the plastic rim collar.\n"
                "- **Anode (+)**: Connects to positive voltage (+5V). Features a smaller **post** contact inside the epoxy and a **longer lead**.\n\n"
                "Use the interactive cutaway inspector below to inspect internal electrodes and observe how reversing polarity blocks photon emission!"
            )
        },
        {
            "stepId": "l05_s04",
            "title": "How It Works: Breadboard Spring Clips & Current Paths",
            "type": "visualExplanation",
            "interactiveWidgetType": "breadboardInternalBusInspector",
            "markdownContent": (
                "Solderless breadboards allow engineers to build circuits without permanent solder. Beneath the plastic faceplate lie rows of stamped spring metal clips.\n\n"
                "### Breadboard Internal Routing:\n"
                "1. **Terminal Strips**: Horizontal groups of 5 tie-points (a-b-c-d-e and f-g-h-i-j) are electrically joined by an internal spring clip.\n"
                "2. **Center Ravine**: A central trench divides the left and right strips so dual-inline IC pins do not short together.\n"
                "3. **Power Bus Rails**: Vertical continuous columns (+ and −) run the full length of the board to distribute 5V and GND everywhere.\n\n"
                "Use the interactive continuity probe below to test breadboard connections and discover where current flows!"
            )
        },
        {
            "stepId": "l05_s05",
            "title": "Hardware Mission: The On-Board Pin 13 'L' Silkscreen Tour",
            "type": "physicalTask",
            "markdownContent": (
                "Examine your Arduino Uno R3 board (`comp_uno`):\n\n"
                "### Hardware Inspection:\n"
                "1. **Locate the 'L' LED**: Look between the digital pin headers (Pins 8–13) and the main microcontroller chip. Find the tiny amber surface-mount diode labeled with a silkscreened `L`.\n"
                "2. **Trace the Silkscreen**: Follow the fine copper trace on the PCB linking Digital Pin 13 to the `L` indicator.\n"
                "3. **Power Indicator**: Notice the green `ON` LED nearby. The green LED proves the 5V power bus is energized, while the amber `L` LED is directly driven by your sketch firmware!\n"
                "4. **On-Board Protection**: The Uno PCB already includes a built-in SMD series resistor for Pin 13, making it 100% safe to flash without external breadboard wiring."
            )
        },
        {
            "stepId": "l05_s06",
            "title": "Coding Basics: pinMode(OUTPUT) & HIGH/LOW Constants",
            "type": "story",
            "markdownContent": (
                "Microcontroller pins are versatile: by default, they boot into high-impedance `INPUT` mode to prevent accidental short circuits.\n\n"
                "### Core Commands:\n"
                "- `pinMode(pin, OUTPUT);`: Commands internal push-pull MOSFET transistors to actively drive current.\n"
                "- `digitalWrite(pin, HIGH);`: Connects the pin to the positive +5.0V supply rail (sources current).\n"
                "- `digitalWrite(pin, LOW);`: Connects the pin to the 0V Ground reference (sinks current).\n"
                "- `delay(ms);`: Freezes microcontroller execution for the specified milliseconds so human eyes can perceive state changes."
            )
        },
        {
            "stepId": "l05_s07",
            "title": "Code Walkthrough: The Canonical Blink Sketch",
            "type": "codeExperiment",
            "markdownContent": (
                "Here is the foundational Blink sketch executed by millions of roboticists:\n\n"
                "```cpp\nconst int ledPin = 13; // Built-in LED pin\n\nvoid setup() {\n  pinMode(ledPin, OUTPUT); // Configure Pin 13 as a low-impedance driver\n}\n\nvoid loop() {\n  digitalWrite(ledPin, HIGH); // Drive Pin 13 to 5V (turn LED ON)\n  delay(1000);                // Maintain state for 1000 ms (1 second)\n  digitalWrite(ledPin, LOW);  // Drive Pin 13 to 0V (turn LED OFF)\n  delay(1000);                // Maintain state for 1000 ms (1 second)\n}\n```\n\n"
                "### Key Rules:\n"
                "- `const int ledPin = 13;` prevents accidental reassignment.\n"
                "- If you forget `delay()` after `LOW`, the LED turns back ON in nanoseconds, making the OFF state invisible to humans!"
            )
        },
        {
            "stepId": "l05_s08",
            "title": "Code Prediction: Silicon Limits & Series Resistors",
            "type": "codeExperiment",
            "interactiveWidgetType": "resistorOhmLawSimulator",
            "markdownContent": (
                "What happens when wiring external LEDs to Arduino pins? Microcontroller silicon has physical electrical limits!\n\n"
                "### Ohm's Law in Action:\n"
                "$$I = \\frac{V_{supply} - V_{forward}}{R} = \\frac{5.0\\text{V} - 2.0\\text{V}}{R}$$\n\n"
                "An ATmega328P output pin has an absolute maximum continuous rating of **20 mA** (40 mA absolute destruction limit). "
                "Wiring an external LED without a current-limiting resistor (< 100Ω) causes catastrophic overcurrent, destroying the pin driver FET!\n\n"
                "Explore resistor values in the Ohm's Law simulator below to see safe operating currents vs blowout hazards!"
            )
        },
        {
            "stepId": "l05_s09",
            "title": "Guided Experiment: Blink Cadence & Persistence of Vision",
            "type": "codeExperiment",
            "interactiveWidgetType": "blinkTimingLab",
            "markdownContent": (
                "What happens when the blink frequency becomes extremely fast?\n\n"
                "Human eyes have an optical reset latency of approximately 30 milliseconds (**Persistence of Vision**). "
                "When an LED toggles faster than 30 Hz (delays under 30ms), retinal cone cells cannot reset before the next photon packet arrives. "
                "The individual flashes fuse into a solid, continuous glow at reduced brightness!\n\n"
                "Adjust `delay(HIGH)` and `delay(LOW)` in the Timing Lab below to explore asymmetric cadences and trigger POV optical fusion!"
            )
        },
        {
            "stepId": "l05_s10",
            "title": "Real-World Robotics: Satellite Beacons & Heartbeat Signals",
            "type": "visualExplanation",
            "markdownContent": (
                "Flashing LEDs are vital engineering diagnostic tools across aerospace and medical systems:\n\n"
                "- **CubeSats & Drones**: Navigation strobes flash asymmetric patterns (100ms ON / 900ms OFF) to minimize battery drain while maintaining high-visibility beacon tracking.\n"
                "- **Medical Ventilators & Pacemakers**: Microcontroller firmware toggles a dedicated hardware 'heartbeat' LED on every main loop iteration. If the CPU hangs in a deadlock, the heartbeat LED freezes, alerting attending doctors.\n"
                "- **Autonomous Factory AGVs**: Colored flashing strobes convey vehicle status: amber for transit, blue for barcode scanning, red for safety obstruction stop."
            )
        },
        {
            "stepId": "l05_s11",
            "title": "Troubleshooting Challenge: Inverted Delays & Floating Gates",
            "type": "story",
            "markdownContent": (
                "Master common beginner hardware bugs:\n\n"
                "### Symptom 1: LED Stays Solid ON and Never Blinks\n"
                "- **Cause**: Missing second `delay()`, or both `digitalWrite` calls are set to `HIGH`.\n"
                "- **Fix**: Ensure `digitalWrite(ledPin, LOW)` is followed by a `delay()` of at least 100ms.\n\n"
                "### Symptom 2: LED Glows Extremely Dimly\n"
                "- **Cause**: Forgot `pinMode(ledPin, OUTPUT);` in `setup()`! In `INPUT` mode, `digitalWrite(HIGH)` merely enables the weak internal 30kΩ pull-up resistor (~0.1 mA current).\n"
                "- **Fix**: Add `pinMode(ledPin, OUTPUT);` inside `setup()`."
            )
        },
        {
            "stepId": "l05_s12",
            "title": "Workshop Safety & Limits: Pin Current Limits (20mA Continuous)",
            "type": "story",
            "markdownContent": (
                "Always treat microcontroller silicon with care:\n\n"
                "1. **Never Exceed 20 mA**: The ATmega328P can supply up to 20 mA per pin. Total current across all pins combined must not exceed 200 mA.\n"
                "2. **Always Use 220Ω–1kΩ Series Resistors**: When wiring external LEDs on a breadboard, always place a 220Ω or 330Ω resistor in series with the anode or cathode.\n"
                "3. **Power Down Before Rewiring**: Disconnect the USB cable before plugging wires into the breadboard to prevent accidental short circuits across 5V and GND."
            )
        },
        {
            "stepId": "l05_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": (
                "Outstanding work! In Lesson 05, you created your first physical light output:\n\n"
                "- You defined digital output states: 5V (`HIGH`) and 0V (`LOW`).\n"
                "- You learned why `pinMode(OUTPUT)` is mandatory to engage push-pull transistor drivers.\n"
                "- You inspected 5mm LED polarity (anvil Cathode − vs post Anode +) and breadboard bus clips.\n"
                "- You calculated current via Ohm's Law and respected the 20 mA continuous pin limit.\n"
                "- You explored blinking cadences and retinal persistence of vision (POV) fusion.\n\n"
                "Take the 8-question assessment below to claim your XP and advance to Lesson 06: Reading analog signals!"
            )
        },
        {
            "stepId": "l05_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of digital output voltage states, LED polarity, Ohm's law, and persistence of vision.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_05",
        "title": "Blink: Your First Physical Circuit",
        "summary": "Command digital outputs to HIGH and LOW, control on-board LED, and understand persistence of vision.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_04"],
        "componentIds": ["comp_uno"],
        "steps": steps,
        "xpReward": 75
    }


def build_lesson_06(plan_text):
    qs = parse_questions_21c_l(plan_text)

    prior_check_questions = [
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

    steps = [
        {
            "stepId": "l06_s01",
            "title": "Sense the Spectrum: Analog Perception",
            "type": "story",
            "markdownContent": (
                "The physical universe is not merely binary ON or OFF. Temperatures rise and fall smoothly, robot battery charges drain gradually, "
                "and steering angles vary continuously. A potentiometer gives your monster robot continuous analog perception, allowing it to sense fine gradients "
                "like steering angles, joint positions, and motor throttle.\n\n"
                "In this mission, you will wire a 10kΩ rotary potentiometer to Analog Pin A0 and convert raw 10-bit integers into true voltage measurements!\n\n"
                "```\n5V Power ➔ Carbon Track ➔ Wiper Picks Off Voltage ➔ ATmega328P 10-bit ADC ➔ Integer (0 to 1023)\n```"
            )
        },
        {
            "stepId": "l06_s02",
            "title": "Prior Knowledge Check: Digital vs Analog Perception",
            "type": "story",
            "interactiveWidgetType": "priorKnowledgeCheck",
            "interactiveConfig": {
                "questions": prior_check_questions
            },
            "markdownContent": (
                "Before wiring variable resistors, let's verify your baseline understanding of discrete digital logic versus continuous analog voltages.\n\n"
                "Answer the 3 self-check questions below to calibrate your knowledge!"
            )
        },
        {
            "stepId": "l06_s03",
            "title": "Core Concept & Vocabulary: Potentiometers & Voltage Dividers",
            "type": "story",
            "interactiveWidgetType": "voltageDividerCutaway",
            "markdownContent": (
                "A **potentiometer** is a 3-terminal variable resistor with a rotating shaft connected to an internal wiper contact.\n\n"
                "### The Voltage Division Principle:\n"
                "Inside `comp_20`, a horseshoe-shaped carbon track connects Terminal 1 (5V) and Terminal 3 (GND). As the shaft rotates, "
                "Center Terminal 2 (Wiper) sweeps across the resistive material, splitting total resistance into two parts ($R_1$ and $R_2$):\n\n"
                "$$V_{out} = V_{in} \\times \\frac{R_2}{R_1 + R_2} = 5.0\\text{V} \\times \\text{ratio}$$\n\n"
                "Rotate the virtual knob in the cutaway visualizer below to see how the wiper divides voltage between 0.00V and 5.00V!"
            )
        },
        {
            "stepId": "l06_s04",
            "title": "How It Works: 10-Bit ADC Successive Approximation Quantization",
            "type": "visualExplanation",
            "interactiveWidgetType": "adcSamplingVisualizer",
            "markdownContent": (
                "Because digital processors only compute in binary bits, the ATmega328P contains an on-chip **Analog-to-Digital Converter (ADC)**.\n\n"
                "### 10-Bit Quantization Details:\n"
                "- **Resolution**: $2^{10} = 1024$ discrete steps (from 0 to 1023).\n"
                "- **Step Voltage Size**: $\\frac{5000\\text{ mV}}{1023} \\approx 4.8876\\text{ mV}$ per ADC count.\n"
                "- **Formula**: $\\text{ADC Count} = \\text{round}\\left(V_{in} \\times \\frac{1023}{5.0\\text{V}}\\right)$\n"
                "- **Reconstructed Voltage**: $V = \\text{count} \\times \\frac{5.0\\text{V}}{1023}$\n\n"
                "Use the interactive visualizer below to explore how continuous analog voltages are sliced into 10-bit integer staircase steps!"
            )
        },
        {
            "stepId": "l06_s05",
            "title": "Hardware Mission: Breadboard Potentiometer 3-Pin Wiring",
            "type": "physicalTask",
            "interactiveWidgetType": "wiperPinoutChecker",
            "markdownContent": (
                "Examine your 10kΩ Rotary Potentiometer (`comp_20`) and solderless breadboard (`comp_breadboard`):\n\n"
                "### 3-Pin Terminal Assignment:\n"
                "- **Pin 1 (Outer Leg)**: Connects to Uno +5V rail.\n"
                "- **Pin 2 (Center Wiper)**: Connects to Uno Analog In Pin `A0`.\n"
                "- **Pin 3 (Outer Leg)**: Connects to Uno Ground (GND) rail.\n\n"
                "⚠️ **The Dead Short Trap**: Never connect the center wiper directly to 5V or GND! If the wiper touches GND while an outer leg is on 5V, "
                "turning the knob to the end of travel creates a 0-ohm dead short, tripping your computer's USB overcurrent protection!\n\n"
                "Inspect and verify wiring configurations in the pinout checker below before powering your physical circuit!"
            )
        },
        {
            "stepId": "l06_s06",
            "title": "Coding Basics: analogRead(A0) & Voltage Conversion Math",
            "type": "story",
            "markdownContent": (
                "Reading analog signals in Arduino firmware is straightforward:\n\n"
                "### Key Rules:\n"
                "- **No `pinMode()` Required**: Unlike digital pins, Uno analog input pins (`A0`–`A5`) do not require `pinMode()` in `setup()`. The ADC multiplexer hardware automatically configures the pin during conversion.\n"
                "- **`analogRead(A0)`**: Samples the pin voltage and returns an integer between `0` (for 0.0V) and `1023` (for 5.0V).\n"
                "- **Conversion Math**: `float voltage = rawValue * (5.0 / 1023.0);` translates the count into true physical Volts.\n"
                "- **Conversion Time**: An ADC conversion on the Uno takes approximately 100 microseconds (about 10,000 samples per second)."
            )
        },
        {
            "stepId": "l06_s07",
            "title": "Code Walkthrough: Continuous Telemetry Stream",
            "type": "codeExperiment",
            "markdownContent": (
                "Here is the canonical sketch for reading potentiometer telemetry:\n\n"
                "```cpp\nconst int potPin = A0; // Center wiper connected to A0\n\nvoid setup() {\n  Serial.begin(9600); // Initialize telemetry communication\n}\n\nvoid loop() {\n  int rawValue = analogRead(potPin);         // Read ADC count (0 to 1023)\n  float voltage = rawValue * (5.0 / 1023.0); // Convert to true voltage\n\n  Serial.print(\"ADC Count: \");\n  Serial.print(rawValue);\n  Serial.print(\" | Voltage: \");\n  Serial.print(voltage, 2);\n  Serial.println(\" V\");\n\n  delay(200); // 5 Hz telemetry cadence for human readability\n}\n```\n\n"
                "Open the Serial Monitor at 9600 baud. As you rotate the potentiometer shaft clockwise and counterclockwise, "
                "watch the values glide smoothly between `0` and `1023`!"
            )
        },
        {
            "stepId": "l06_s08",
            "title": "Code Prediction: ADC Midpoints & Reference Voltages",
            "type": "codeExperiment",
            "markdownContent": (
                "Make predictions about analog conversion values before testing:\n\n"
                "### Prediction 1: Exactly what integer count will analogRead(A0) return when the potentiometer is centered at 2.50 Volts?\n"
                "*Answer:* $1023 \\times \\frac{2.5}{5.0} = 511.5 \\approx 511$ or $512$.\n\n"
                "### Prediction 2: What happens if you connect the potentiometer's outer legs to 3.3V and GND instead of 5V?\n"
                "*Answer:* When turned fully clockwise to 3.3V, `analogRead()` reads $1023 \\times \\frac{3.3}{5.0} \\approx 675$. The top third of the integer scale (676–1023) will never be reached!"
            )
        },
        {
            "stepId": "l06_s09",
            "title": "Guided Experiment: Sensor Scaling & Moving Average Filter",
            "type": "codeExperiment",
            "interactiveWidgetType": "analogReadNoiseFilter",
            "markdownContent": (
                "Real-world robotics sensors pick up electrical noise from nearby motors and power supplies. "
                "What happens when an analog pin is left completely disconnected (**floating input**)?\n\n"
                "Because the ATmega328P ADC has an input impedance exceeding 100 MΩ, an unconnected pin acts like an antenna, picking up 60Hz ambient EMI!\n\n"
                "In robotics firmware, engineers implement **Exponential Moving Average (EMA)** software filters:\n"
                "```cpp\nsmoothedVal = (0.2 * rawVal) + (0.8 * smoothedVal);\n```\n\n"
                "Test floating inputs, ground references, and digital filtering in the interactive laboratory below!"
            )
        },
        {
            "stepId": "l06_s10",
            "title": "Real-World Robotics: Joint Angles & Throttle Pedals",
            "type": "visualExplanation",
            "markdownContent": (
                "Potentiometers and voltage dividers are fundamental components across industrial machines:\n\n"
                "- **Robotic Arm Servo Joints**: Precision rotary potentiometers inside robot joints provide closed-loop angular feedback so the controller knows the arm's exact 3D orientation.\n"
                "- **Electric Vehicle Throttle Pedals**: Dual-redundant rotary potentiometers measure accelerator pedal angle. Redundant tracks ensure that if one wiper wears out, the car safely idles rather than accelerating runaway!\n"
                "- **Radio Volume & Audio Consoles**: Audio mixing consoles use motorized linear slide potentiometers (faders) to adjust channel gain."
            )
        },
        {
            "stepId": "l06_s11",
            "title": "Troubleshooting Challenge: Floating Inputs & Dead Short Traps",
            "type": "story",
            "markdownContent": (
                "Diagnose the top 2 analog input failures:\n\n"
                "### Symptom 1: Reading Jumps Wildly Even When Not Touching the Knob\n"
                "- **Diagnosis**: Floating input! The center wiper wire is plugged into the wrong breadboard row, or a jumper wire is loose.\n"
                "- **Fix**: Confirm that the yellow wiper jumper wire is in the exact same breadboard tie-point column as Pin 2.\n\n"
                "### Symptom 2: Reading Stays Locked at 0 or 1023 and Never Changes\n"
                "- **Diagnosis**: Both outer pins are plugged into the same power rail (e.g., both into GND or both into 5V), or the wiper pin is bent underneath the pot.\n"
                "- **Fix**: Inspect the pot underside to ensure all 3 pins entered distinct breadboard rows."
            )
        },
        {
            "stepId": "l06_s12",
            "title": "Workshop Safety & Breadboard Placement Rules",
            "type": "story",
            "markdownContent": (
                "Observe these critical breadboard installation guidelines:\n\n"
                "1. **Never Insert All 3 Pins Into the Same Breadboard Row**: A breadboard row connects all 5 holes together! Inserting all 3 potentiometer pins into row 10 creates a dead short across 5V and GND!\n"
                "2. **Gentle Lead Pressure**: Potentiometer pins can bend if forced into tight breadboard holes. Align all 3 pins vertically before applying gentle downward pressure.\n"
                "3. **Quiescent Current Awareness**: A 10kΩ potentiometer connected between 5V and GND draws only $I = \\frac{5\\text{V}}{10\\text{k}\\Omega} = 0.5\\text{ mA}$ of continuous power."
            )
        },
        {
            "stepId": "l06_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": (
                "Fantastic progress! In Lesson 06, you gave your monster robot continuous analog senses:\n\n"
                "- You distinguished discrete binary states from continuous analog voltages.\n"
                "- You understood voltage division math: $V_{out} = V_{in} \\times \\frac{R_2}{R_1 + R_2}$.\n"
                "- You mastered 10-bit ADC quantization ($2^{10} = 1024$ levels, ~4.89 mV per step).\n"
                "- You wired a 3-pin potentiometer safely, avoiding destructive dead short traps.\n"
                "- You filtered high-impedance floating noise using moving average algorithms.\n\n"
                "Complete the 8-question assessment below to earn your XP and proceed to Lesson 07: Mixing colors with RGB LEDs and PWM!"
            )
        },
        {
            "stepId": "l06_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of potentiometer voltage division, 10-bit ADC sampling, and analog telemetry.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_06",
        "title": "Potentiometer: Reading Analog Signals",
        "summary": "Measure continuous rotary voltages with 10-bit analogRead() and map sensor readings.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_05"],
        "componentIds": ["comp_uno", "comp_breadboard", "comp_20"],
        "steps": steps,
        "xpReward": 80
    }


def build_lesson_07(plan_text):
    qs = parse_questions_21c_l(plan_text)

    prior_check_questions = [
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

    steps = [
        {
            "stepId": "l07_s01",
            "title": "Expressive Monsters: Crafting Living Light",
            "type": "story",
            "markdownContent": (
                "Robots need emotion and visual expression! By combining three primary wavelengths of light—Red, Green, and Blue—at varying intensities, "
                "we can create any color in the visible rainbow, from energetic yellow to menacing purple or calm cyan.\n\n"
                "Because the Arduino Uno does not have true analog output voltage DACs on its digital headers, we use high-speed silicon pulsing—**Pulse Width Modulation (PWM)**—"
                "to fool the human eye into perceiving smooth brightness gradients!\n\n"
                "```\nTimer Register OCR1A ➔ High-Speed 490Hz Pulse Train ➔ Duty Cycle Average ➔ Eye Cone Cells ➔ Perceived Color\n```"
            )
        },
        {
            "stepId": "l07_s02",
            "title": "Prior Knowledge Check: Diodes & Voltage Outputs",
            "type": "story",
            "interactiveWidgetType": "priorKnowledgeCheck",
            "interactiveConfig": {
                "questions": prior_check_questions
            },
            "markdownContent": (
                "Before mixing optical light beams and configuring PWM timer registers, let's test your baseline understanding of semiconductor diodes and voltage driving.\n\n"
                "Answer the 3 self-check questions below to calibrate your knowledge!"
            )
        },
        {
            "stepId": "l07_s03",
            "title": "Core Concept & Vocabulary: Common Cathode vs Common Anode",
            "type": "story",
            "interactiveWidgetType": "commonCathodeVsAnodeDiagram",
            "markdownContent": (
                "An RGB LED packages three independent semiconductor dies (Red, Green, Blue) into a single 5mm plastic lens with 4 leads sharing a single common pin.\n\n"
                "### The Two Packaging Standards:\n"
                "- **Common Cathode (CC)**: The shared longest lead is connected to **Ground (0V)**. Logic is **Active-HIGH** (`analogWrite(pin, 255)` produces 100% brightness).\n"
                "- **Common Anode (CA)**: The shared longest lead is connected to **+5V (VCC)**. Logic is **Active-LOW** (sinks current; `analogWrite(pin, 0)` produces 100% brightness, requiring `255 - value` in code).\n\n"
                "Toggle between Common Cathode and Common Anode in the schematic below to explore current paths and software logic inversion!"
            )
        },
        {
            "stepId": "l07_s04",
            "title": "How It Works: High-Speed 490Hz PWM Pulse Trains",
            "type": "visualExplanation",
            "interactiveWidgetType": "pwmDutyCycleVisualizer",
            "markdownContent": (
                "Human retina cone cells cannot resolve individual light flashes cycling faster than ~60 Hz due to persistence of vision.\n\n"
                "### Pulse Width Modulation (PWM) Physics:\n"
                "1. ATmega328P hardware timers oscillate output pins at ~490 Hz (or 980 Hz), giving a cycle period of $T \\approx 2.04\\text{ ms}$.\n"
                "2. When you execute `analogWrite(pin, 127)`, the timer holds the pin at 5V for 50% of the period, and 0V for the other 50% (**50% Duty Cycle**).\n"
                "3. The human eye integrates this high-speed photon flux, perceiving a steady 50% brightness!\n"
                "4. Effective average voltage: $V_{average} = 5.0\\text{V} \\times \\frac{\\text{value}}{255}$.\n\n"
                "Use the interactive oscilloscope below to inspect pulse waveforms, high-time vs low-time durations, and perceived LED photon flux!"
            )
        },
        {
            "stepId": "l07_s05",
            "title": "Hardware Mission: 4-Pin RGB LED Leadout & Breadboard Wiring",
            "type": "physicalTask",
            "markdownContent": (
                "Examine your 4-pin 5mm Common Cathode RGB LED and breadboard (`comp_breadboard`):\n\n"
                "### Lead Identification Tour:\n"
                "Hold the LED with the flat edge on the plastic rim collar facing right:\n"
                "1. **Lead 1 (Outer Left)**: Red Anode (Forward drop $V_f \\approx 2.0\\text{V}$)\n"
                "2. **Lead 2 (Longest Pin)**: Common Cathode (Connects directly to Uno **GND**)\n"
                "3. **Lead 3**: Green Anode (Forward drop $V_f \\approx 3.2\\text{V}$)\n"
                "4. **Lead 4 (Outer Right)**: Blue Anode (Forward drop $V_f \\approx 3.2\\text{V}$)\n\n"
                "### Resistor Wiring:\n"
                "Never share a single resistor on the common pin! Connect a separate 220Ω or 330Ω resistor to Lead 1 (Red), Lead 3 (Green), and Lead 4 (Blue). "
                "Because red, green, and blue dies have different forward voltage drops, sharing one resistor causes brightness dipping whenever multiple colors illuminate."
            )
        },
        {
            "stepId": "l07_s06",
            "title": "Coding Basics: Identifying Hardware PWM Pins & Timers",
            "type": "story",
            "interactiveWidgetType": "pwmPinIdentifier",
            "markdownContent": (
                "Can you call `analogWrite()` on any Uno pin? **No!** Only pins wired to internal hardware timer compare registers support PWM.\n\n"
                "### Finding the PWM Tilde (~):\n"
                "Look at the silkscreen on your Arduino Uno next to digital header pins: only pins marked with a tilde `~` (Pins 3, 5, 6, 9, 10, 11) support PWM:\n"
                "- **Pins 5 & 6**: Controlled by **Timer0** at **980 Hz** (shared with `millis()` and `delay()`).\n"
                "- **Pins 9 & 10**: Controlled by **Timer1** (16-bit) at **490 Hz**.\n"
                "- **Pins 3 & 11**: Controlled by **Timer2** (8-bit) at **490 Hz**.\n\n"
                "⚠️ **The Non-PWM Trap**: If you call `analogWrite(8, 128)` on non-PWM Pin 8, it only performs binary threshold switching (>=128 is HIGH, <128 is LOW)!\n\n"
                "Test and identify all Uno PWM pins in the interactive checker below!"
            )
        },
        {
            "stepId": "l07_s07",
            "title": "Code Walkthrough: 8-Bit analogWrite() & Helper Functions",
            "type": "codeExperiment",
            "markdownContent": (
                "Here is how to control an RGB LED with clean modular firmware:\n\n"
                "```cpp\nconst int redPin = 9;   // PWM Pin ~9\nconst int greenPin = 10;// PWM Pin ~10\nconst int bluePin = 11; // PWM Pin ~11\n\nvoid setup() {\n  pinMode(redPin, OUTPUT);\n  pinMode(greenPin, OUTPUT);\n  pinMode(bluePin, OUTPUT);\n}\n\nvoid setColor(int red, int green, int blue) {\n  analogWrite(redPin, constrain(red, 0, 255));\n  analogWrite(greenPin, constrain(green, 0, 255));\n  analogWrite(bluePin, constrain(blue, 0, 255));\n}\n\nvoid loop() {\n  setColor(255, 0, 0);   // Pure Red\n  delay(1000);\n  setColor(0, 255, 0);   // Pure Green\n  delay(1000);\n  setColor(0, 0, 255);   // Pure Blue\n  delay(1000);\n  setColor(255, 255, 0); // Yellow (Red + Green)\n  delay(1000);\n}\n```\n\n"
                "By wrapping `analogWrite()` inside a custom `setColor()` function, your sketch becomes clean and readable!"
            )
        },
        {
            "stepId": "l07_s08",
            "title": "Code Prediction: Inverted Logic & Duty Cycle Math",
            "type": "codeExperiment",
            "markdownContent": (
                "Predict color mixing results before testing on the breadboard:\n\n"
                "### Prediction 1: What color does setColor(255, 0, 255) synthesize?\n"
                "*Answer:* Full Red combined with full Blue produces vivid **Magenta / Purple**!\n\n"
                "### Prediction 2: What happens if you accidentally plug a Common Anode RGB LED into this sketch?\n"
                "*Answer:* Because Common Anode uses active-LOW logic, calling `setColor(255, 0, 0)` will produce Cyan instead of Red (Red turns OFF while Green and Blue turn fully ON)!"
            )
        },
        {
            "stepId": "l07_s09",
            "title": "Guided Experiment: Additive Optical Color Mixing Lab",
            "type": "codeExperiment",
            "interactiveWidgetType": "rgbColorSynthesizer",
            "markdownContent": (
                "Time to blend optical wavelengths! In additive color physics:\n\n"
                "- **Red + Green = Yellow**\n"
                "- **Green + Blue = Cyan**\n"
                "- **Red + Blue = Magenta**\n"
                "- **Red + Green + Blue = White**\n\n"
                "Use the 3-channel optical synthesizer below to mix Red, Green, and Blue light beams into a central frosted lens, "
                "inspect the resulting hex color codes, and generate exact Arduino firmware commands!"
            )
        },
        {
            "stepId": "l07_s10",
            "title": "Real-World Robotics: Quadcopter Navigation Beacons & RGB Mood Lighting",
            "type": "visualExplanation",
            "markdownContent": (
                "RGB optical mixing and PWM are used extensively in modern robotics:\n\n"
                "- **Quadcopter Flight Navigation**: Drones mount high-intensity RGB LEDs under motor arms: solid green for GPS lock, flashing yellow for return-to-home, and pulsing red for low battery.\n"
                "- **Autonomous Delivery Rovers**: Ground rovers project animated light halos on pavements to signal pedestrians whether they are yielding or turning.\n"
                "- **Smart Speaker Rings**: Ambient home assistants use 16-channel RGB PWM shift registers to create fluid rotation and pulsing voice feedback animations."
            )
        },
        {
            "stepId": "l07_s11",
            "title": "Troubleshooting Challenge: Reversed Common Anode & Non-PWM Pin Traps",
            "type": "story",
            "markdownContent": (
                "Solve the two most common RGB LED hardware bugs:\n\n"
                "### Trap 1: Colors Are Inverted (e.g. Red command shows Cyan)\n"
                "- **Diagnosis**: You have a Common Anode LED instead of Common Cathode! The shared pin is wired to GND or expecting active-HIGH driving.\n"
                "- **Fix**: Wire the common pin to +5V, and invert firmware values: `analogWrite(pin, 255 - value);`.\n\n"
                "### Trap 2: One Color Only Snaps ON or OFF Without Dimming\n"
                "- **Diagnosis**: That color channel is connected to a non-PWM pin (such as Pin 7, 8, 12, or 13)!\n"
                "- **Fix**: Move the jumper wire to a PWM pin marked with a tilde `~` (3, 5, 6, 9, 10, or 11)."
            )
        },
        {
            "stepId": "l07_s12",
            "title": "Workshop Safety & Independent Resistor Protection",
            "type": "story",
            "markdownContent": (
                "Keep your components protected with these electrical rules:\n\n"
                "1. **Never Omit Current Limiting Resistors**: Each of the 3 internal LED dies requires its own 220Ω–330Ω resistor to prevent thermal runaway.\n"
                "2. **Separate Resistors Prevent Brightness Droop**: Because Red has a 2.0V forward voltage while Green/Blue have ~3.2V, putting a single shared resistor on the cathode will cause Red to steal all the current, extinguishing the other colors!\n"
                "3. **Respect Total Package Heat**: Running all three channels at 100% brightness (White) draws ~45 mA total, well within Uno limits when equipped with proper resistors."
            )
        },
        {
            "stepId": "l07_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": (
                "Magnificent job! In Lesson 07, you unlocked full optical color synthesis:\n\n"
                "- You mastered additive optical color mixing (combining Red, Green, and Blue light).\n"
                "- You distinguished Common Cathode (Active-HIGH, shared GND) from Common Anode (Active-LOW, shared 5V).\n"
                "- You understood high-speed 490Hz/980Hz PWM duty cycles and average voltage simulation.\n"
                "- You located Uno hardware PWM pins marked with `~` (3, 5, 6, 9, 10, 11) and their timers.\n"
                "- You wrote modular helper functions (`setColor()`) with 8-bit `analogWrite()` (0–255).\n\n"
                "Complete the 8-question assessment below to earn your XP and wrap up Tier 1 physical outputs!"
            )
        },
        {
            "stepId": "l07_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of RGB color synthesis, PWM duty cycles, Common Cathode pinouts, and hardware timers.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0]["explanation"],
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_07",
        "title": "RGB LED: Mixing Colors with PWM",
        "summary": "Synthesize millions of colors using Pulse Width Modulation and additive optical color physics.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_05"],
        "componentIds": ["comp_uno", "comp_breadboard"],
        "steps": steps,
        "xpReward": 90
    }

LESSON_META = {
    "lesson_03": {
        "title": "Installing Libraries: Supercharging Code",
        "summary": "Understand open-source modular libraries and how to install them with the Library Manager.",
        "tier": "builder",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_02"],
        "componentIds": ["comp_uno", "comp_07"],
        "xpReward": 60,
    },
    "lesson_04": {
        "title": "Basics of the Arduino IDE: Setup and Loop",
        "summary": "Master the core microcontroller lifecycle: setup() once, loop() forever, and serial monitoring.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_02"],
        "componentIds": ["comp_uno"],
        "xpReward": 60,
    },
    "lesson_05": {
        "title": "Blink: Your First Physical Circuit",
        "summary": "Command digital outputs to HIGH and LOW, control on-board LED, and understand persistence of vision.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_04"],
        "componentIds": ["comp_uno"],
        "xpReward": 75,
        "simulator": "blinkSimulator",
    },
    "lesson_06": {
        "title": "Potentiometer: Reading Analog Signals",
        "summary": "Measure continuous rotary voltages with 10-bit analogRead() and map sensor readings.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_05"],
        "componentIds": ["comp_uno", "comp_breadboard", "comp_20"],
        "xpReward": 80,
        "simulator": "potentiometerSimulator",
    },
    "lesson_07": {
        "title": "RGB LED: Mixing Colors with PWM",
        "summary": "Synthesize millions of colors using Pulse Width Modulation and additive optical color physics.",
        "tier": "rookie",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_05"],
        "componentIds": ["comp_uno", "comp_breadboard"],
        "xpReward": 90,
        "simulator": "rgbMixer",
    },
    "lesson_08": {
        "title": "Digital Inputs: Pushbuttons & Internal Pullups",
        "summary": "Sense mechanical switch presses reliably using ATmega328P internal pull-up resistors and active-low logic.",
        "tier": "rookie",
        "estimatedMinutes": 18,
        "prerequisites": ["lesson_05"],
        "componentIds": ["comp_uno", "comp_breadboard"],
        "xpReward": 70,
    },
    "lesson_09": {
        "title": "The I2C Communication Bus",
        "summary": "Daisy-chain multiple sensors and displays over just two shared wires using 7-bit addressing.",
        "tier": "builder",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_03", "lesson_04"],
        "componentIds": ["comp_uno", "comp_07", "comp_10"],
        "xpReward": 80,
    },
    "lesson_10": {
        "title": "The High-Speed SPI Protocol",
        "summary": "Communicate with high-bandwidth displays and memory cards at multi-megahertz clock speeds.",
        "tier": "engineer",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_09"],
        "componentIds": ["comp_uno", "comp_15", "comp_23"],
        "xpReward": 90,
    },
    "lesson_11": {
        "title": "Serial UART & Wireless Communication",
        "summary": "Establish bidirectional serial telemetry and communicate wirelessly with Bluetooth modules.",
        "tier": "engineer",
        "estimatedMinutes": 20,
        "prerequisites": ["lesson_04"],
        "componentIds": ["comp_uno", "comp_29"],
        "xpReward": 90,
    },
    "lesson_12": {
        "title": "PWM & Motor Physics",
        "summary": "Drive high-current DC motors and servos using H-Bridges, PWM duty cycles, and flyback diode protection.",
        "tier": "engineer",
        "estimatedMinutes": 22,
        "prerequisites": ["lesson_06", "lesson_07"],
        "componentIds": ["comp_uno", "comp_33", "comp_36", "comp_l293d"],
        "xpReward": 100,
    },
}

STEP_TITLES_TEMPLATE = [
    ("s01", "Mission Introduction", "story"),
    ("s02", "Prior Knowledge Check", "story"),
    ("s03", "Core Concept & Vocabulary", "story"),
    ("s04", "How It Works: Signal Flow & Hardware Registers", "visualExplanation"),
    ("s05", "Hardware Mission: Component & Pin Inspection", "physicalTask"),
    ("s06", "Coding Basics: Syntax & Control Structures", "story"),
    ("s07", "Code Walkthrough: Annotated Sketch", "codeExperiment"),
    ("s08", "Code Prediction: Hypothesis & Deductions", "codeExperiment"),
    ("s09", "Guided Experiment: Parameter Modulation", "codeExperiment"),
    ("s10", "Real-World Robotics: Industrial & Aerospace Systems", "visualExplanation"),
    ("s11", "Troubleshooting Challenge: Diagnostic Scenarios", "story"),
    ("s12", "Workshop Safety & Hardware Care", "story"),
    ("s13", "Final Review & Competencies", "story"),
    ("s14", "Comprehensive Knowledge Check", "quizCheckpoint"),
]

def build_lesson_standard(lid, plan_text):
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21c_l(plan_text)
    meta = LESSON_META[lid]
    prefix = f"l{int(lid.split('_')[1]):02d}"

    # Section mapping:
    # 1 -> s01
    # 2 -> s02
    # 3 -> s03
    # 4 -> s04
    # 5 -> s05
    # 6 -> s06
    # 7 -> s07
    # 8 -> s08
    # 9 -> s09
    # 10 -> s10
    # 11 -> s11
    # 12 -> s12
    # 14 -> s13 (Final Review)
    # 13 -> s14 (Knowledge Check)

    steps = []
    # 1 through 12
    for sec_num in range(1, 13):
        step_suffix, default_title, step_type = STEP_TITLES_TEMPLATE[sec_num - 1]
        step_id = f"{prefix}_{step_suffix}"
        step_dict = {
            "stepId": step_id,
            "title": default_title,
            "type": step_type,
            "markdownContent": clean_markdown(sections[str(sec_num)])
        }
        if sec_num == 9 and "simulator" in meta:
            step_dict["interactiveWidgetType"] = meta["simulator"]
        steps.append(step_dict)

    # Step 13: Final Review (from section 14)
    steps.append({
        "stepId": f"{prefix}_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": clean_markdown(sections['14'])
    })

    # Step 14: Comprehensive Knowledge Check (from section 13)
    # Question 1 is the primary question
    q1 = qs[0]
    steps.append({
        "stepId": f"{prefix}_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
        "interactiveConfig": {
            "question": q1["question"],
            "options": q1["options"],
            "correctIndex": q1["correctIndex"],
            "explanation": q1.get("explanation"),
            "questions": qs
        }
    })

    return {
        "id": lid,
        "title": meta["title"],
        "summary": meta["summary"],
        "tier": meta["tier"],
        "estimatedMinutes": meta["estimatedMinutes"],
        "prerequisites": meta["prerequisites"],
        "componentIds": meta["componentIds"],
        "steps": steps,
        "xpReward": meta["xpReward"]
    }

def build_lesson_08(plan_text):
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21c_l(plan_text)
    meta = LESSON_META["lesson_08"]

    steps = [
        {
            "stepId": "l08_s01",
            "title": "Mission Introduction",
            "type": "story",
            "markdownContent": clean_markdown(sections['1']),
        },
        {
            "stepId": "l08_s02",
            "title": "Prior Knowledge Check",
            "type": "story",
            "markdownContent": clean_markdown(sections['2']),
        },
        {
            "stepId": "l08_s03",
            "title": "Core Concept & Vocabulary",
            "type": "story",
            "interactiveWidgetType": "floatingPinSimulator",
            "markdownContent": clean_markdown(sections['3']) + (
                "\n\n### Interactive Mission: Test High-Impedance Floating Pins\n"
                "Explore the interactive simulator below to observe how an unconnected input pin oscillates erratically from environmental electromagnetic noise. "
                "Switch between Floating, Pull-Up, and Pull-Down to observe how pull resistors stabilize logic levels!"
            ),
        },
        {
            "stepId": "l08_s04",
            "title": "How It Works: Signal Flow & Hardware Registers",
            "type": "visualExplanation",
            "interactiveWidgetType": "internalPullupCircuitDiagram",
            "markdownContent": clean_markdown(sections['4']) + (
                "\n\n### Interactive Schematic: ATmega328P Internal Pull-Up Resistor\n"
                "Examine the interactive schematic below. Toggle `pinMode(pin, INPUT_PULLUP)` and press the button to observe the harmless 0.25mA drain to GND "
                "and verify active-low logic (unpressed = HIGH, pressed = LOW)!"
            ),
        },
        {
            "stepId": "l08_s05",
            "title": "Hardware Mission: Component & Pin Inspection",
            "type": "physicalTask",
            "markdownContent": clean_markdown(sections['5']),
        },
        {
            "stepId": "l08_s06",
            "title": "Coding Basics: Syntax & Control Structures",
            "type": "story",
            "interactiveWidgetType": "activeLowLogicChecker",
            "markdownContent": clean_markdown(sections['6']) + (
                "\n\n### Interactive Bench: Test Active-Low Inverted Logic\n"
                "Test the logic checker below. Press the virtual button to evaluate `if (digitalRead(buttonPin) == LOW)` and verify that physical button presses "
                "illuminate the built-in Pin 13 LED!"
            ),
        },
        {
            "stepId": "l08_s07",
            "title": "Code Walkthrough: Annotated Sketch",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['7']),
        },
        {
            "stepId": "l08_s08",
            "title": "Code Prediction: Hypothesis & Deductions",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['8']),
        },
        {
            "stepId": "l08_s09",
            "title": "Guided Experiment: Parameter Modulation",
            "type": "codeExperiment",
            "interactiveWidgetType": "switchBounceVisualizer",
            "markdownContent": clean_markdown(sections['9']) + (
                "\n\n### Interactive Oscilloscope: Microsecond Switch Bounce\n"
                "Press the button on the oscilloscope below to observe microsecond contact chatter. Toggle debounce mode and adjust the software delay window "
                "to eliminate false clicks!"
            ),
        },
        {
            "stepId": "l08_s10",
            "title": "Real-World Robotics: Industrial & Aerospace Systems",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['10']),
        },
        {
            "stepId": "l08_s11",
            "title": "Troubleshooting Challenge: Diagnostic Scenarios",
            "type": "story",
            "markdownContent": clean_markdown(sections['11']),
        },
        {
            "stepId": "l08_s12",
            "title": "Workshop Safety & Hardware Care",
            "type": "story",
            "markdownContent": clean_markdown(sections['12']),
        },
        {
            "stepId": "l08_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": clean_markdown(sections['14']),
        },
        {
            "stepId": "l08_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of digital inputs, floating pins, active-low logic, and debouncing.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0].get("explanation"),
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_08",
        "title": meta["title"],
        "summary": meta["summary"],
        "tier": meta["tier"],
        "estimatedMinutes": meta["estimatedMinutes"],
        "prerequisites": meta["prerequisites"],
        "componentIds": meta["componentIds"],
        "steps": steps,
        "xpReward": meta["xpReward"]
    }

def build_lesson_09(plan_text):
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21c_l(plan_text)
    meta = LESSON_META["lesson_09"]

    steps = [
        {
            "stepId": "l09_s01",
            "title": "Mission Introduction",
            "type": "story",
            "markdownContent": clean_markdown(sections['1']),
        },
        {
            "stepId": "l09_s02",
            "title": "Prior Knowledge Check",
            "type": "story",
            "markdownContent": clean_markdown(sections['2']),
        },
        {
            "stepId": "l09_s03",
            "title": "Core Concept & Vocabulary",
            "type": "story",
            "interactiveWidgetType": "i2cPullupChecker",
            "markdownContent": clean_markdown(sections['3']) + (
                "\n\n### Interactive Circuit Lab: Open-Drain & Pull-Up Resistors\n"
                "Test the open-drain schematic below. Select different pull-up resistor values (proper 4.7kΩ vs missing vs weak 100kΩ) "
                "to observe waveform rise times and see why I2C lines cannot float!"
            ),
        },
        {
            "stepId": "l09_s04",
            "title": "How It Works: Signal Flow & Hardware Registers",
            "type": "visualExplanation",
            "interactiveWidgetType": "i2cBusTimingDiagram",
            "markdownContent": clean_markdown(sections['4']) + (
                "\n\n### Interactive Timing Oscilloscope: The I2C Protocol Frame\n"
                "Step through the logic analyzer capture below to observe the START condition, 7-bit address frame, R/W bit, peripheral ACK pulse on clock cycle 9, and STOP condition!"
            ),
        },
        {
            "stepId": "l09_s05",
            "title": "Hardware Mission: Component & Pin Inspection",
            "type": "physicalTask",
            "interactiveWidgetType": "i2cDaisyChainSimulator",
            "markdownContent": clean_markdown(sections['5']) + (
                "\n\n### Interactive Bus Builder: Multi-Device Daisy-Chaining & Collisions\n"
                "Attach peripherals to the shared 2-wire bus below. Connect the LCD (`0x27`) and RTC (`0x68`) simultaneously, then attach a duplicate sensor to observe and resolve an address collision!"
            ),
        },
        {
            "stepId": "l09_s06",
            "title": "Coding Basics: Syntax & Control Structures",
            "type": "story",
            "markdownContent": clean_markdown(sections['6']),
        },
        {
            "stepId": "l09_s07",
            "title": "Code Walkthrough: Annotated Sketch",
            "type": "codeExperiment",
            "interactiveWidgetType": "i2cAddressScanner",
            "markdownContent": clean_markdown(sections['7']) + (
                "\n\n### Interactive Terminal: Run the I2C Address Scanner\n"
                "Run the simulated serial terminal below to probe 7-bit addresses 0x01 through 0x7E and discover active I2C peripherals in real time!"
            ),
        },
        {
            "stepId": "l09_s08",
            "title": "Code Prediction: Hypothesis & Deductions",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['8']),
        },
        {
            "stepId": "l09_s09",
            "title": "Guided Experiment: Parameter Modulation",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['9']),
        },
        {
            "stepId": "l09_s10",
            "title": "Real-World Robotics: Industrial & Aerospace Systems",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['10']),
        },
        {
            "stepId": "l09_s11",
            "title": "Troubleshooting Challenge: Diagnostic Scenarios",
            "type": "story",
            "markdownContent": clean_markdown(sections['11']),
        },
        {
            "stepId": "l09_s12",
            "title": "Workshop Safety & Hardware Care",
            "type": "story",
            "markdownContent": clean_markdown(sections['12']),
        },
        {
            "stepId": "l09_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": clean_markdown(sections['14']),
        },
        {
            "stepId": "l09_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of I2C bus communications, open-drain pull-ups, and device addressing.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0].get("explanation"),
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_09",
        "title": meta["title"],
        "summary": meta["summary"],
        "tier": meta["tier"],
        "estimatedMinutes": meta["estimatedMinutes"],
        "prerequisites": meta["prerequisites"],
        "componentIds": meta["componentIds"],
        "steps": steps,
        "xpReward": meta["xpReward"]
    }

def build_lesson_10(plan_text):
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21c_l(plan_text)
    meta = LESSON_META["lesson_10"]

    steps = [
        {
            "stepId": "l10_s01",
            "title": "Mission Introduction",
            "type": "story",
            "markdownContent": clean_markdown(sections['1']),
        },
        {
            "stepId": "l10_s02",
            "title": "Prior Knowledge Check",
            "type": "story",
            "markdownContent": clean_markdown(sections['2']),
        },
        {
            "stepId": "l10_s03",
            "title": "Core Concept & Vocabulary",
            "type": "story",
            "interactiveWidgetType": "spiVsI2cComparison",
            "markdownContent": clean_markdown(sections['3']) + (
                "\n\n### Interactive Matrix: SPI vs. I2C Engineering Decisions\n"
                "Review the trade-off matrix below and tackle the 3 engineering design challenges to decide between SPI and I2C based on bandwidth, wire count, and peripheral constraints!"
            ),
        },
        {
            "stepId": "l10_s04",
            "title": "How It Works: Signal Flow & Hardware Registers",
            "type": "visualExplanation",
            "interactiveWidgetType": "spiFullDuplexVisualizer",
            "markdownContent": clean_markdown(sections['4']) + (
                "\n\n### Interactive Shift Register Visualizer: Full-Duplex Transmission\n"
                "Step through the clock pulses on the circular shift register ring below to watch Master and Slave simultaneously exchange bytes over MOSI and MISO on shared SCK ticks!"
            ),
        },
        {
            "stepId": "l10_s05",
            "title": "Hardware Mission: Component & Pin Inspection",
            "type": "physicalTask",
            "interactiveWidgetType": "chipSelectArbitrator",
            "markdownContent": clean_markdown(sections['5']) + (
                "\n\n### Interactive Bus Arbitrator: Chip Select & Tri-State Standby\n"
                "Toggle the CS lines below to activate the RC522 RFID reader and 8x8 Dot Matrix display. Observe High-Impedance (Hi-Z) tri-state standby and see why multiple CS pins must never be pulled LOW simultaneously!"
            ),
        },
        {
            "stepId": "l10_s06",
            "title": "Coding Basics: Syntax & Control Structures",
            "type": "story",
            "markdownContent": clean_markdown(sections['6']),
        },
        {
            "stepId": "l10_s07",
            "title": "Code Walkthrough: Annotated Sketch",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['7']),
        },
        {
            "stepId": "l10_s08",
            "title": "Code Prediction: Hypothesis & Deductions",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['8']),
        },
        {
            "stepId": "l10_s09",
            "title": "Guided Experiment: Parameter Modulation",
            "type": "codeExperiment",
            "interactiveWidgetType": "spiClockPolarityPhaseLab",
            "markdownContent": clean_markdown(sections['9']) + (
                "\n\n### Interactive Timing Lab: SPI Clock Polarity (CPOL) & Phase (CPHA)\n"
                "Explore SPI Modes 0, 1, 2, and 3 below. Observe how clock idle levels and leading vs trailing sample edges change the timing of SPI transfers and generate Arduino `SPISettings`!"
            ),
        },
        {
            "stepId": "l10_s10",
            "title": "Real-World Robotics: Industrial & Aerospace Systems",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['10']),
        },
        {
            "stepId": "l10_s11",
            "title": "Troubleshooting Challenge: Diagnostic Scenarios",
            "type": "story",
            "markdownContent": clean_markdown(sections['11']),
        },
        {
            "stepId": "l10_s12",
            "title": "Workshop Safety & Hardware Care",
            "type": "story",
            "markdownContent": clean_markdown(sections['12']),
        },
        {
            "stepId": "l10_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": clean_markdown(sections['14']),
        },
        {
            "stepId": "l10_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of the SPI protocol, full-duplex transmission, chip select arbitration, and clock polarity.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0].get("explanation"),
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_10",
        "title": meta["title"],
        "summary": meta["summary"],
        "tier": meta["tier"],
        "estimatedMinutes": meta["estimatedMinutes"],
        "prerequisites": meta["prerequisites"],
        "componentIds": meta["componentIds"],
        "steps": steps,
        "xpReward": meta["xpReward"]
    }

def build_lesson_11(plan_text):
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21c_l(plan_text)
    meta = LESSON_META["lesson_11"]

    steps = [
        {
            "stepId": "l11_s01",
            "title": "Mission Introduction",
            "type": "story",
            "markdownContent": clean_markdown(sections['1']),
        },
        {
            "stepId": "l11_s02",
            "title": "Prior Knowledge Check",
            "type": "story",
            "markdownContent": clean_markdown(sections['2']),
        },
        {
            "stepId": "l11_s03",
            "title": "Core Concept & Vocabulary",
            "type": "story",
            "markdownContent": clean_markdown(sections['3']),
        },
        {
            "stepId": "l11_s04",
            "title": "How It Works: Signal Flow & Hardware Registers",
            "type": "visualExplanation",
            "interactiveWidgetType": "uartFrameVisualizer",
            "markdownContent": clean_markdown(sections['4']) + (
                "\n\n### Interactive Waveform Visualizer: UART Packet Anatomy\n"
                "Explore asynchronous UART packet framing below. Observe how the line idles HIGH (+5V), pulls LOW for the Start Bit, sends 8 data bits LSB-first, and returns HIGH for the Stop Bit!"
            ),
        },
        {
            "stepId": "l11_s05",
            "title": "Hardware Mission: Component & Pin Inspection",
            "type": "physicalTask",
            "interactiveWidgetType": "txRxCrossWireChecker",
            "markdownContent": clean_markdown(sections['5']) + (
                "\n\n### Interactive Breadboard Checker: TX/RX Cross-Wiring & Voltage Divider\n"
                "Test your serial wiring below to avoid the classic TX-to-TX beginner trap and verify that the 1kΩ / 2kΩ voltage divider protects delicate 3.3V wireless RX pins!"
            ),
        },
        {
            "stepId": "l11_s06",
            "title": "Coding Basics: Syntax & Control Structures",
            "type": "story",
            "markdownContent": clean_markdown(sections['6']),
        },
        {
            "stepId": "l11_s07",
            "title": "Code Walkthrough: Annotated Sketch",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['7']),
        },
        {
            "stepId": "l11_s08",
            "title": "Code Prediction: Hypothesis & Deductions",
            "type": "codeExperiment",
            "interactiveWidgetType": "baudRateMismatchDemo",
            "markdownContent": clean_markdown(sections['8']) + (
                "\n\n### Interactive Timing Lab: Baud Rate Clock Mismatch & Framing Errors\n"
                "Experiment with mismatched baud rates below. Observe how clock drift produces framing errors and corrupted gibberish when sender and receiver clocks disagree!"
            ),
        },
        {
            "stepId": "l11_s09",
            "title": "Guided Experiment: Parameter Modulation",
            "type": "codeExperiment",
            "interactiveWidgetType": "bluetoothAtCommandTerminal",
            "markdownContent": clean_markdown(sections['9']) + (
                "\n\n### Interactive Terminal: HC-05 Bluetooth AT Command Console\n"
                "Configure your Bluetooth module using the simulated Hayes AT command terminal below. Test AT ping, rename the device, set passkeys, and inspect status LED pulse timing!"
            ),
        },
        {
            "stepId": "l11_s10",
            "title": "Real-World Robotics: Industrial & Aerospace Systems",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['10']),
        },
        {
            "stepId": "l11_s11",
            "title": "Troubleshooting Challenge: Diagnostic Scenarios",
            "type": "story",
            "markdownContent": clean_markdown(sections['11']),
        },
        {
            "stepId": "l11_s12",
            "title": "Workshop Safety & Hardware Care",
            "type": "story",
            "markdownContent": clean_markdown(sections['12']),
        },
        {
            "stepId": "l11_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": clean_markdown(sections['14']),
        },
        {
            "stepId": "l11_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of UART asynchronous framing, crossed TX/RX lines, SoftwareSerial, and Bluetooth telemetry.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0].get("explanation"),
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_11",
        "title": meta["title"],
        "summary": meta["summary"],
        "tier": meta["tier"],
        "estimatedMinutes": meta["estimatedMinutes"],
        "prerequisites": meta["prerequisites"],
        "componentIds": meta["componentIds"],
        "steps": steps,
        "xpReward": meta["xpReward"]
    }

def build_lesson_12(plan_text):
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21c_l(plan_text)
    meta = LESSON_META["lesson_12"]

    steps = [
        {
            "stepId": "l12_s01",
            "title": "Mission Introduction",
            "type": "story",
            "markdownContent": clean_markdown(sections['1']),
        },
        {
            "stepId": "l12_s02",
            "title": "Prior Knowledge Check",
            "type": "story",
            "markdownContent": clean_markdown(sections['2']),
        },
        {
            "stepId": "l12_s03",
            "title": "Core Concept & Vocabulary",
            "type": "story",
            "markdownContent": clean_markdown(sections['3']),
        },
        {
            "stepId": "l12_s04",
            "title": "How It Works: Signal Flow & Hardware Registers",
            "type": "visualExplanation",
            "interactiveWidgetType": "inductiveKickbackSimulator",
            "markdownContent": clean_markdown(sections['4']) + (
                "\n\n### Interactive Coil Simulator: Inductive Kickback & Flyback Clamping\n"
                "Simulate an inductive motor coil when power turns off. Observe the dangerous 85V+ reverse spike caused by Lenz's Law and see how an antiparallel 1N4007 flyback diode safely clamps current!"
            ),
        },
        {
            "stepId": "l12_s05",
            "title": "Hardware Mission: Component & Pin Inspection",
            "type": "physicalTask",
            "interactiveWidgetType": "externalMotorPowerLab",
            "markdownContent": clean_markdown(sections['5']) + (
                "\n\n### Interactive Electrical Bench: Motor Power Isolation & Common Ground\n"
                "Explore why high-current motors (1-2A stall) cause severe brownout crashes when powered from the Arduino 5V regulator, and verify proper external battery power with a shared Common Ground!"
            ),
        },
        {
            "stepId": "l12_s06",
            "title": "Coding Basics: Syntax & Control Structures",
            "type": "story",
            "interactiveWidgetType": "hBridgeDirectionSwitch",
            "markdownContent": clean_markdown(sections['6']) + (
                "\n\n### Interactive Circuit Schematic: 4-Transistor H-Bridge & Shoot-Through Protection\n"
                "Control the H-Bridge switches below to reverse DC motor polarity, activate dynamic regenerative braking, and avoid catastrophic shoot-through short circuits!"
            ),
        },
        {
            "stepId": "l12_s07",
            "title": "Code Walkthrough: Annotated Sketch",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['7']),
        },
        {
            "stepId": "l12_s08",
            "title": "Code Prediction: Hypothesis & Deductions",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['8']),
        },
        {
            "stepId": "l12_s09",
            "title": "Guided Experiment: Parameter Modulation",
            "type": "codeExperiment",
            "interactiveWidgetType": "servoPulseWidthModulator",
            "markdownContent": clean_markdown(sections['9']) + (
                "\n\n### Interactive PWM Generator: 50Hz Servo Pulse Width Modulator\n"
                "Adjust the 50Hz PWM pulse width between 1.0ms (0°), 1.5ms (90°), and 2.0ms (180°) below to command the virtual servo horn with precise microsecond timing!"
            ),
        },
        {
            "stepId": "l12_s10",
            "title": "Real-World Robotics: Industrial & Aerospace Systems",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['10']),
        },
        {
            "stepId": "l12_s11",
            "title": "Troubleshooting Challenge: Diagnostic Scenarios",
            "type": "story",
            "markdownContent": clean_markdown(sections['11']),
        },
        {
            "stepId": "l12_s12",
            "title": "Workshop Safety & Hardware Care",
            "type": "story",
            "markdownContent": clean_markdown(sections['12']),
        },
        {
            "stepId": "l12_s13",
            "title": "Final Review & Competencies",
            "type": "story",
            "markdownContent": clean_markdown(sections['14']),
        },
        {
            "stepId": "l12_s14",
            "title": "Comprehensive Knowledge Check",
            "type": "quizCheckpoint",
            "markdownContent": "Test your mastery of inductive kickback, flyback diodes, H-bridge motor drivers, and servo PWM modulation.",
            "interactiveConfig": {
                "question": qs[0]["question"],
                "options": qs[0]["options"],
                "correctIndex": qs[0]["correctIndex"],
                "explanation": qs[0].get("explanation"),
                "questions": qs
            }
        }
    ]

    return {
        "id": "lesson_12",
        "title": meta["title"],
        "summary": meta["summary"],
        "tier": meta["tier"],
        "estimatedMinutes": meta["estimatedMinutes"],
        "prerequisites": meta["prerequisites"],
        "componentIds": meta["componentIds"],
        "steps": steps,
        "xpReward": meta["xpReward"]
    }

def compile_all_lessons():
    lessons = []
    # Lesson 01
    with open(ROOT / 'plan' / '21a Lesson 01 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_01(f.read()))

    # Lesson 02
    with open(ROOT / 'plan' / '21b Lesson 02 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_02(f.read()))

    # Lesson 03
    with open(ROOT / 'plan' / '21c Lesson 03 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_03(f.read()))

    # Lesson 04
    with open(ROOT / 'plan' / '21d Lesson 04 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_04(f.read()))

    # Lesson 05
    with open(ROOT / 'plan' / '21e Lesson 05 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_05(f.read()))

    # Lesson 06
    with open(ROOT / 'plan' / '21f Lesson 06 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_06(f.read()))

    # Lesson 07
    with open(ROOT / 'plan' / '21g Lesson 07 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_07(f.read()))

    # Lesson 08
    with open(ROOT / 'plan' / '21h Lesson 08 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_08(f.read()))

    # Lesson 09
    with open(ROOT / 'plan' / '21i Lesson 09 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_09(f.read()))

    # Lesson 10
    with open(ROOT / 'plan' / '21j Lesson 10 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_10(f.read()))

    # Lesson 11
    with open(ROOT / 'plan' / '21k Lesson 11 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_11(f.read()))

    # Lesson 12
    with open(ROOT / 'plan' / '21l Lesson 12 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_12(f.read()))

    return lessons

def update_generate_curriculum_assets():
    target = ROOT / "scripts" / "generate_curriculum_assets.py"
    content = target.read_text(encoding="utf-8")
    pattern = r"LESSONS = \[.*?\]\n\n# -------------------------------------------------------------\n# 2\. Components Data"
    replacement = "from compile_expanded_lessons import compile_all_lessons\n\nLESSONS = compile_all_lessons()\n\n# -------------------------------------------------------------\n# 2. Components Data"
    new_content, count = re.subn(pattern, replacement, content, count=1, flags=re.DOTALL)
    if count == 1:
        target.write_text(new_content, encoding="utf-8")
        print("Updated scripts/generate_curriculum_assets.py")
    else:
        print("WARN: Could not replace LESSONS in generate_curriculum_assets.py (might already be updated)")

def update_asset_curriculum_datasource(all_lessons):
    target = ROOT / "lib" / "data" / "datasources" / "asset_curriculum_datasource.dart"
    content = target.read_text(encoding="utf-8")
    lessons_json = json.dumps(all_lessons, indent=2)
    new_method = f"""  static List<Lesson>? _cachedBaselineLessons;

  /// Initial curriculum foundation lessons (Lessons 1 through 12, expanded 12–14 steps)
  List<Lesson> getBaselineLessons() {{
    return _cachedBaselineLessons ??= (jsonDecode(_baselineLessonsJson) as List<dynamic>)
        .map((e) => Lesson.fromJson(e as Map<String, dynamic>))
        .toList();
  }}

  static const String _baselineLessonsJson = r'''{lessons_json}''';"""

    pattern = r"(?:  static List<Lesson>\? _cachedBaselineLessons;\n\n)?  /// Initial curriculum foundation lessons.*?\n\n  /// Initial baseline components"
    replacement_str = f"{new_method}\n\n  /// Initial baseline components"
    new_content, count = re.subn(pattern, lambda m: replacement_str, content, count=1, flags=re.DOTALL)
    if count == 1:
        target.write_text(new_content, encoding="utf-8")
        print("Updated lib/data/datasources/asset_curriculum_datasource.dart")
    else:
        print("WARN: Could not replace getBaselineLessons in asset_curriculum_datasource.dart")

if __name__ == '__main__':
    all_lessons = compile_all_lessons()
    print(f"Successfully compiled {len(all_lessons)} lessons:")
    for l in all_lessons:
        print(f"  {l['id']}: '{l['title']}' ({l['tier']}, {l['xpReward']} XP, {l['estimatedMinutes']} mins) - {len(l['steps'])} steps")
        # Ensure JSON files in assets/curriculum/lessons/ are written
        l_path = ROOT / 'assets' / 'curriculum' / 'lessons' / f"{l['id']}.json"
        with open(l_path, 'w', encoding='utf-8') as f:
            json.dump(l, f, indent=2)
        for s in l['steps']:
            if s['type'] == 'quizCheckpoint':
                print(f"    -> Quiz {s['stepId']}: {len(s['interactiveConfig']['questions'])} questions")
                print(f"       Q1: {s['interactiveConfig']['questions'][0]['question'][:60]}...")
                print(f"       Opt0: {s['interactiveConfig']['questions'][0]['options'][0]}")

    update_generate_curriculum_assets()
    update_asset_curriculum_datasource(all_lessons)
