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
    raw_sec = re.findall(r'## ([0-9]+)\. (.*?)\n(.*?)(?=\n## [0-9]+|\n## Estimated|\Z)', plan_text, re.DOTALL)
    sections = {num: body for num, title, body in raw_sec}
    qs = parse_questions_21b(plan_text)
    
    port_text = sections['6'] + "\n\n" + sections['7'] + "\n\n" + sections['8']
    trouble_text = sections['11'] + "\n\n" + sections['12']
    esd_text = (
        "### Workshop Safety: Electrostatic Discharge (ESD) & Surge Prevention\n\n"
        "Microcontrollers are sensitive CMOS semiconductor devices. A spark of static electricity that you can barely feel (under 3,000 volts) can permanently puncture internal silicon MOSFET gate oxide layers!\n\n"
        "**Best Safety Practices:**\n"
        "- Touch a grounded metal object before picking up your Arduino board.\n"
        "- Hold boards by the edges—never press fingers directly across exposed IC pins or header solder pads.\n"
        "- Keep conductive liquids, soda cans, and metal rulers away from your active wiring workspace.\n"
        "- Always disconnect USB power before moving wires or inserting IC components."
    )

    steps = [
        {
            "stepId": "l02_s01",
            "title": "Give the Monster Its Voice",
            "type": "story",
            "markdownContent": clean_markdown(sections['1'])
        },
        {
            "stepId": "l02_s02",
            "title": "Prior Knowledge Check: Computer Programs & USB",
            "type": "story",
            "markdownContent": clean_markdown(sections['2'])
        },
        {
            "stepId": "l02_s03",
            "title": "What Is an IDE? The Programmer's Workbench",
            "type": "story",
            "markdownContent": clean_markdown(sections['3'])
        },
        {
            "stepId": "l02_s04",
            "title": "Compilation & Flashing: What Happens When You Upload?",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['4'])
        },
        {
            "stepId": "l02_s05",
            "title": "Connecting the USB Cable Safely",
            "type": "physicalTask",
            "markdownContent": clean_markdown(sections['5'])
        },
        {
            "stepId": "l02_s06",
            "title": "What Is a Port? Serial COM Ports & Device Drivers",
            "type": "story",
            "markdownContent": clean_markdown(port_text)
        },
        {
            "stepId": "l02_s07",
            "title": "First Look at Arduino Code: setup() and loop() Structure",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['9'])
        },
        {
            "stepId": "l02_s08",
            "title": "Code Prediction Challenge: Empty Setup vs Unbounded Loops",
            "type": "codeExperiment",
            "markdownContent": clean_markdown(sections['10'])
        },
        {
            "stepId": "l02_s09",
            "title": "Real-World Systems: NASA Mars Rovers & Embedded Firmware",
            "type": "visualExplanation",
            "markdownContent": clean_markdown(sections['13'])
        },
        {
            "stepId": "l02_s10",
            "title": "Troubleshooting Lab Station: Port Not Found & Driver Issues",
            "type": "story",
            "markdownContent": clean_markdown(trouble_text)
        },
        {
            "stepId": "l02_s11",
            "title": "Workshop Safety: Electrostatic Discharge (ESD) & Surge Prevention",
            "type": "story",
            "markdownContent": clean_markdown(esd_text)
        },
        {
            "stepId": "l02_s12",
            "title": "Station Setup Review & Competencies",
            "type": "story",
            "markdownContent": clean_markdown(sections['15'])
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

def compile_all_lessons():
    lessons = []
    # Lesson 01
    with open(ROOT / 'plan' / '21a Lesson 01 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_01(f.read()))

    # Lesson 02
    with open(ROOT / 'plan' / '21b Lesson 02 Reworked Example.md', 'r', encoding='utf-8') as f:
        lessons.append(build_lesson_02(f.read()))

    # Lessons 03 through 12
    subplans = [
        ('lesson_03', 'plan/21c Lesson 03 Reworked Example.md'),
        ('lesson_04', 'plan/21d Lesson 04 Reworked Example.md'),
        ('lesson_05', 'plan/21e Lesson 05 Reworked Example.md'),
        ('lesson_06', 'plan/21f Lesson 06 Reworked Example.md'),
        ('lesson_07', 'plan/21g Lesson 07 Reworked Example.md'),
        ('lesson_08', 'plan/21h Lesson 08 Reworked Example.md'),
        ('lesson_09', 'plan/21i Lesson 09 Reworked Example.md'),
        ('lesson_10', 'plan/21j Lesson 10 Reworked Example.md'),
        ('lesson_11', 'plan/21k Lesson 11 Reworked Example.md'),
        ('lesson_12', 'plan/21l Lesson 12 Reworked Example.md'),
    ]

    for lid, plan_file in subplans:
        with open(ROOT / plan_file, 'r', encoding='utf-8') as f:
            lessons.append(build_lesson_standard(lid, f.read()))

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
        for s in l['steps']:
            if s['type'] == 'quizCheckpoint':
                print(f"    -> Quiz {s['stepId']}: {len(s['interactiveConfig']['questions'])} questions")
                print(f"       Q1: {s['interactiveConfig']['questions'][0]['question'][:60]}...")
                print(f"       Opt0: {s['interactiveConfig']['questions'][0]['options'][0]}")

    update_generate_curriculum_assets()
    update_asset_curriculum_datasource(all_lessons)

