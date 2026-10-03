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
        "markdownContent": "### Meet the Monster Brain\nA robot needs a brain. The Arduino Uno is a small microcontroller development board that can read information from the world and control electronic devices.\n\nIt can read a button, measure a sensor, turn an LED on or off, control a motor through a driver, and communicate with other electronics.\n\nThe Arduino does not magically know what to do. A program tells it what to look for and what actions to take.\n\n**Sensor \u2192 Arduino \u2192 Decision \u2192 Output**"
      },
      {
        "stepId": "l01_s02",
        "title": "What Is a Microcontroller? Architecture & Vocabulary",
        "type": "story",
        "markdownContent": "A microcontroller is a small computer designed to control electronics. Unlike a desktop computer, it is designed to interact directly with hardware.\n\nIt contains a processor that runs instructions, memory for programs and data, input/output connections, timers, and other hardware used by programs.\n\n### Vocabulary\n- **Microcontroller:** A small computer designed to control electronic hardware.\n- **Program:** Instructions that tell a computer what to do.\n- **Input:** Information entering the controller.\n- **Output:** An action or signal produced by the controller."
      },
      {
        "stepId": "l01_s03",
        "title": "Inputs vs Outputs: Think Like a Robot",
        "type": "story",
        "markdownContent": "Robots need ways to sense and act.\n\n### Inputs\n- Pushbutton\n- Distance sensor\n- Sound sensor\n- Potentiometer\n- Light sensor\n\n### Outputs\n- LED\n- Buzzer\n- Display\n- Motor driver\n- Servo\n\n### Think Like a Robot\nAsk the learner to classify an ultrasonic sensor, LED, pushbutton, and motor driver as input or output.\n\nExample: If a robot needs to know whether someone pressed a button, is the button an input or an output?\n\n**Answer:** Input."
      },
      {
        "stepId": "l01_s04",
        "title": "Digital vs Analog Signals & Prediction",
        "type": "visualExplanation",
        "interactiveWidgetType": "boardInspector",
        "markdownContent": "Digital information can represent distinct states. For a simple Arduino input this is often HIGH or LOW, similar to ON or OFF.\n\nAnalog information can represent changing values such as temperature, light level, knob position, or sound level.\n\n### Quick Prediction\nA potentiometer is turned slowly from one end to the other. Would its reading stay the same, change gradually, or only have two possible values?\n\n**Answer:** Change gradually."
      },
      {
        "stepId": "l01_s05",
        "title": "Meet the Arduino Uno: Physical Hardware Mission",
        "type": "physicalTask",
        "markdownContent": "Have the learner physically locate:\n- USB connection\n- Power connection\n- Digital pins\n- Analog pins\n- 5V\n- 3.3V\n- GND\n- Reset button\n- Built-in LED\n\n### Physical Mission\n1. Find 5V.\n2. Find GND.\n3. Find one digital pin.\n4. Find one analog pin.\n5. Find the built-in LED.\n6. Identify the USB connection.\n\nDo not connect anything yet. The goal is identification."
      },
      {
        "stepId": "l01_s06",
        "title": "Why Power and Ground Matter: Complete Circuits",
        "type": "story",
        "markdownContent": "Electronic circuits need a complete electrical path.\n\nFor a simple circuit, electrical energy travels from the power source through the components and returns through the circuit's ground/reference path.\n\nA common pattern is:\n\n**Power \u2192 Component \u2192 GND**\n\nImportant: GND does not mean the electricity simply disappears. It is the circuit's reference and return path."
      },
      {
        "stepId": "l01_s07",
        "title": "How the Robot Brain Makes Decisions",
        "type": "story",
        "markdownContent": "Suppose we want a robot to turn on an LED when a button is pressed:\n\n1. Button provides an input.\n2. Arduino reads the input.\n3. Program checks the value.\n4. Program decides what to do.\n5. Arduino controls the LED.\n\nThis introduces an important programming idea:\n\n**condition \u2192 decision \u2192 action**"
      },
      {
        "stepId": "l01_s08",
        "title": "Your First Instruction: Deconstructing digitalWrite",
        "type": "codeExperiment",
        "markdownContent": "Before giving the learner a complete sketch, introduce one instruction:\n\n    digitalWrite(13, HIGH);\n\n### Break It Apart\n- **digitalWrite:** A function that sets a digital output.\n- **13:** The digital pin being controlled.\n- **HIGH:** The requested high/on state.\n- **;:** Marks the end of the statement.\n\n### Code Prediction\nIf pin 13 controls the built-in LED, what do you predict this instruction will do?\n\n**Expected answer:** Command the LED on.\n\nThe goal is learning to read code, not simply copy it."
      },
      {
        "stepId": "l01_s09",
        "title": "Trust but Verify: Scientific Engineering Method",
        "type": "story",
        "markdownContent": "A programmer should not blindly trust code copied from the internet.\n\nBefore uploading code, ask:\n- What pin does it use?\n- Is that pin connected to the component?\n- What do the important numbers mean?\n- What should happen?\n- What could go wrong?\n\nTeach the habit: **Read \u2192 Predict \u2192 Upload \u2192 Observe \u2192 Verify \u2192 Change \u2192 Test.**"
      },
      {
        "stepId": "l01_s10",
        "title": "Real-World Systems: Obstacle Avoidance & Robot Vacuums",
        "type": "visualExplanation",
        "markdownContent": "Imagine a robot that needs to avoid walls.\n\n**Ultrasonic sensor \u2192 measures distance**\n\n**Arduino \u2192 reads the measurement**\n\n**Program \u2192 decides whether the robot is too close**\n\n**Motor driver \u2192 controls the motors**\n\nThis same input/decision/output pattern appears in robot vacuums, automatic doors, factory robots, alarm systems, and smart devices."
      },
      {
        "stepId": "l01_s11",
        "title": "Troubleshooting Challenge: The Silent LED",
        "type": "story",
        "markdownContent": "### Scenario\nA learner says: My LED code does not work.\n\nHave the learner investigate:\n1. Is the Arduino powered?\n2. Is the correct board selected?\n3. Is the correct pin being used?\n4. Is the LED connected to that pin?\n5. Is the code using HIGH or LOW?\n6. Was the program successfully uploaded?\n\n### Engineering Habit\n**Observe \u2192 Form a theory \u2192 Test \u2192 Learn**\n\nDo not randomly change everything."
      },
      {
        "stepId": "l01_s12",
        "title": "Final Review & Self-Reflection",
        "type": "story",
        "markdownContent": "### You Learned\n- Arduino is a development board built around a microcontroller.\n- A microcontroller runs programs that control electronics.\n- Inputs provide information.\n- Outputs perform actions.\n- Digital signals can represent distinct states.\n- Analog signals can represent changing values.\n- Power and GND are fundamental to circuits.\n- Code contains instructions that control hardware.\n- Pin numbers matter.\n- Good engineers predict, test, and troubleshoot.\n\n### Before You Continue\nAsk the learner:\n- What is the input?\n- What is the output?\n- What pin is being used?\n- What is the code telling the hardware to do?"
      },
      {
        "stepId": "l01_s13",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of microcontrollers, signal types, power paths, and code prediction.",
        "interactiveConfig": {
          "question": "What is GND used for in a typical circuit?",
          "options": [
            "Unlimited power.",
            "A common reference and return path.",
            "Storing the program."
          ],
          "correctIndex": 1,
          "explanation": "Ground (GND) is the 0V reference potential and essential return path for electric current.",
          "questions": [
            {
              "question": "What is a microcontroller?",
              "options": [
                "A small computer designed to control electronics.",
                "A battery.",
                "A mechanical switch."
              ],
              "correctIndex": 0,
              "explanation": "A microcontroller is a specialized chip combining CPU, memory, and IO peripherals to control hardware."
            },
            {
              "question": "A distance sensor sends information to Arduino. Is it an input or output?",
              "options": [
                "Input.",
                "Output.",
                "Power supply."
              ],
              "correctIndex": 0,
              "explanation": "Distance sensors gather environmental telemetry and feed data into the Arduino, making them inputs."
            },
            {
              "question": "An LED controlled by Arduino is an example of what?",
              "options": [
                "Input.",
                "Output.",
                "Ground."
              ],
              "correctIndex": 1,
              "explanation": "LEDs produce visual illumination based on controller pin voltages, making them outputs."
            },
            {
              "question": "What is GND used for in a typical circuit?",
              "options": [
                "Unlimited power.",
                "A common reference and return path.",
                "Storing the program."
              ],
              "correctIndex": 1,
              "explanation": "Ground (GND) is the 0V reference potential and essential return path for electric current."
            },
            {
              "question": "What does HIGH represent in a simple digital output?",
              "options": [
                "The output's high/on state.",
                "A program error.",
                "A sensor failure."
              ],
              "correctIndex": 0,
              "explanation": "In 5V digital logic, HIGH commands the output transistor to connect to the positive 5V supply rail."
            },
            {
              "question": "What does 13 mean in digitalWrite(13, HIGH);?",
              "options": [
                "The pin being controlled.",
                "The amount of memory.",
                "The Arduino speed."
              ],
              "correctIndex": 0,
              "explanation": "The first parameter of digitalWrite specifies the target hardware pin on the ATmega328P header."
            },
            {
              "question": "A potentiometer produces a changing voltage as it turns. Is this digital or analog information?",
              "options": [
                "Analog.",
                "Digital only.",
                "Neither."
              ],
              "correctIndex": 0,
              "explanation": "Potentiometers output a continuously variable voltage division ratio between 0V and 5V."
            },
            {
              "question": "Why should you understand code before uploading it?",
              "options": [
                "So you can predict behavior and troubleshoot problems.",
                "Arduino refuses copied code.",
                "Every program must be memorized."
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
        "markdownContent": "### Give the Monster Its Voice\nThe Arduino is the robot's brain, but the brain needs instructions.\n\nYour computer is where you write those instructions.\n\nThe Arduino IDE is the workbench that lets you write Arduino programs, check code, compile programs, upload them to the board, and communicate with the board.\n\nThink of the process as:\n**Write \u2192 Check \u2192 Compile \u2192 Upload \u2192 Run**"
      },
      {
        "stepId": "l02_s02",
        "title": "Prior Knowledge Check: Computer Programs & USB",
        "type": "story",
        "markdownContent": "Ask the learner:\n\n### Question 1\nHave you ever written a computer program before?\n- Yes.\n- A little.\n- No.\n\n### Question 2\nWhat do you think a program is?\n- Instructions for a computer.\n- A battery.\n- A USB cable.\n\n### Question 3\nWhat do you think USB is used for in this project?\n- Connecting the computer and Arduino.\n- Supplying unlimited power to every component.\n- Making the Arduino wireless.\n\nDo not block beginners based on their answers. If they already know these concepts, allow them to move quickly through the explanation."
      },
      {
        "stepId": "l02_s03",
        "title": "What Is an IDE? The Programmer's Workbench",
        "type": "story",
        "markdownContent": "IDE stands for Integrated Development Environment.\n\nThink of it as a programming workbench. Instead of using one program to write code, another to compile it, and another to send it to the board, the Arduino IDE puts the important tools together.\n\n### Vocabulary\n- **IDE:** Software used to write and work with programs.\n- **Sketch:** Arduino's name for a program/project.\n- **Compile:** Convert source code into a form the Arduino can use.\n- **Upload:** Send the compiled program from the computer to the Arduino.\n- **Port:** A communication connection the computer uses to communicate with a device."
      },
      {
        "stepId": "l02_s04",
        "title": "Compilation & Flashing: What Happens When You Upload?",
        "type": "visualExplanation",
        "markdownContent": "When you press Upload, several things happen.\n\n### Step 1 \u2014 Write code\nYou create a sketch.\n\n### Step 2 \u2014 Check the code\nThe IDE looks for problems that prevent the program from being compiled.\n\n### Step 3 \u2014 Compile\nThe computer translates the source code into machine instructions appropriate for the board.\n\n### Step 4 \u2014 Communicate\nThe computer sends the program through the USB connection.\n\n### Step 5 \u2014 Run\nThe Arduino stores and executes the program.\n\n### Think About It\nDoes pressing Upload magically create the program?\n\n**No.** The computer has already converted the source code and then sends the resulting program to the board."
      },
      {
        "stepId": "l02_s05",
        "title": "Connecting the USB Cable Safely",
        "type": "physicalTask",
        "markdownContent": "The USB cable provides an important connection between the computer and Arduino.\n\nDepending on the board and setup, USB can provide power, data communication, program uploads, and serial communication.\n\n### Physical Mission\n1. Find the USB connector on the Arduino.\n2. Find the USB connector on the computer.\n3. Inspect the cable for damage.\n4. Connect the cable.\n5. Look for the Arduino power indicator.\n6. Confirm the board is receiving power.\n\n### Safety\n- Do not force the connector.\n- Do not connect damaged cables.\n- Do not intentionally short power and ground."
      },
      {
        "stepId": "l02_s06",
        "title": "What Is a Port? Serial COM Ports & Device Drivers",
        "type": "story",
        "markdownContent": "Your computer may have many devices connected to it. The operating system needs a way to identify which communication connection belongs to the Arduino.\n\nThat connection appears as a serial or COM port. The exact name depends on the computer and operating system.\n\nThink:\n**Computer \u2192 Port \u2192 USB \u2192 Arduino**\n\n### Prediction\nIf the Arduino is unplugged, should the Arduino's port normally remain available as the same active device?\n\n**Usually no.** The available port list can change when devices are connected or disconnected.\n\n\nThe IDE needs to know which Arduino board you are programming.\n\nFor this project, select:\n**Arduino Uno**\n\nDifferent boards can have different processors, pin layouts, memory, communication hardware, and programming requirements.\n\nChoosing the wrong board can cause uploads to fail or produce unexpected behavior.\n\n### Guided Task\nHave the learner open:\n**Tools \u2192 Board \u2192 Arduino Uno**\n\nThen verify the selected board.\n\n\nNow select the communication port belonging to the Arduino.\n\nHave the learner:\n1. Open the port selection.\n2. Note which ports are currently visible.\n3. Disconnect the Arduino.\n4. Check the list again.\n5. Reconnect the Arduino.\n6. Identify the port that appears or returns.\n7. Select it.\n\nThis turns port selection into something the learner can understand instead of simply being told which item to click."
      },
      {
        "stepId": "l02_s07",
        "title": "First Look at Arduino Code: setup() and loop() Structure",
        "type": "codeExperiment",
        "markdownContent": "Before uploading a full project, look at this tiny sketch:\n\n    void setup() {\n      Serial.begin(9600);\n    }\n\n    void loop() {\n    }\n\n### What Does This Mean?\n- **void setup():** A function that runs when the Arduino starts or resets.\n- **Serial.begin(9600):** Starts serial communication at a speed called the baud rate.\n- **void loop():** The function Arduino repeatedly runs.\n- The empty loop means this example does not currently have anything repeating.\n\n### Coding Basics\nThis introduces functions, parentheses, braces, statements, numbers, and semicolons.\n\nThe learner does not need to memorize these yet. The goal is recognizing that code has structure."
      },
      {
        "stepId": "l02_s08",
        "title": "Code Prediction Challenge: Empty Setup vs Unbounded Loops",
        "type": "codeExperiment",
        "markdownContent": "### Prediction 1\nIf setup() runs when the Arduino starts, will this happen repeatedly every second?\n\n**No.**\n\n### Prediction 2\nWhat does 9600 represent?\n- The serial communication speed.\n- The Arduino pin number.\n- The amount of memory.\n\n**Answer:** Serial communication speed/baud rate.\n\n### Prediction 3\nWhat happens inside the empty loop?\nNothing from this example is being repeatedly executed."
      },
      {
        "stepId": "l02_s09",
        "title": "Real-World Systems: NASA Mars Rovers & Embedded Firmware",
        "type": "visualExplanation",
        "markdownContent": "Professional developers use similar workflows. They write software, build or compile it, send it to a target system, test it, observe the result, and fix problems.\n\nEmbedded engineers do this with robots, drones, industrial controllers, sensors, automotive electronics, and smart appliances.\n\nMonster Lab is introducing the same basic engineering workflow."
      },
      {
        "stepId": "l02_s10",
        "title": "Troubleshooting Lab Station: Port Not Found & Driver Issues",
        "type": "story",
        "markdownContent": "Walk through the basic workflow:\n1. Connect Arduino.\n2. Open Arduino IDE.\n3. Select Arduino Uno.\n4. Select the correct port.\n5. Open or enter a simple sketch.\n6. Verify the code.\n7. Upload the sketch.\n8. Watch the IDE for the upload result.\n\nExplain the difference:\n**Verify \u2192 checks/compiles the sketch.**\n**Upload \u2192 sends the program to the Arduino.**\n\nThe learner should understand that these are not the same button.\n\n\n### Scenario A \u2014 No Port\nThe Arduino is plugged in, but no new port appears.\n\nAsk the learner to check:\n- Is the USB cable connected?\n- Is the cable capable of data communication?\n- Is the board powered?\n- Is the cable damaged?\n- Is the correct USB port being used?\n- Does the operating system recognize the device?\n\n### Scenario B \u2014 Upload Fails\nAsk:\n- Is the correct board selected?\n- Is the correct port selected?\n- Is another program using the serial port?\n- Is the USB connection stable?\n- Did the code compile successfully?\n\n### Scenario C \u2014 Wrong Board\nThe learner selected a different board model.\n\nAsk why this might cause problems.\n\nExpected reasoning: The IDE needs to know what hardware it is programming so it can compile and upload the program correctly."
      },
      {
        "stepId": "l02_s11",
        "title": "Workshop Safety: Electrostatic Discharge (ESD) & Surge Prevention",
        "type": "story",
        "markdownContent": "### Workshop Safety: Electrostatic Discharge (ESD) & Surge Prevention\n\nMicrocontrollers are sensitive CMOS semiconductor devices. A spark of static electricity that you can barely feel (under 3,000 volts) can permanently puncture internal silicon MOSFET gate oxide layers!\n\n**Best Safety Practices:**\n- Touch a grounded metal object before picking up your Arduino board.\n- Hold boards by the edges\u2014never press fingers directly across exposed IC pins or header solder pads.\n- Keep conductive liquids, soda cans, and metal rulers away from your active wiring workspace.\n- Always disconnect USB power before moving wires or inserting IC components."
      },
      {
        "stepId": "l02_s12",
        "title": "Station Setup Review & Competencies",
        "type": "story",
        "markdownContent": "### You Learned\n- The Arduino IDE is the programming workbench.\n- Arduino sketches are programs.\n- Verify/compile and Upload are different operations.\n- USB can provide power and data communication.\n- A port identifies a computer communication connection.\n- The IDE must know which board you are programming.\n- setup() runs during startup or reset.\n- loop() repeats.\n- Uploading code is part of an engineering test cycle.\n\n### Monster Lab Workflow\n**Connect \u2192 Select Board \u2192 Select Port \u2192 Write \u2192 Verify \u2192 Upload \u2192 Test \u2192 Troubleshoot**"
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
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Supercharge Your Monster's Brain\nRobots rely on specialized integrated circuits: real-time clocks, OLEDs, and motor drivers. Controlling a 16x2 LCD display via raw 8-bit parallel pulses requires toggling 16 pins and managing microsecond timing. If engineers had to write low-level bit-banging code for every display, building a robot would take months!\n\nLibraries package proven, robust C++ code written by senior engineers so learners can command complex hardware with high-level functions like `lcd.print(\"Monster Online!\");`.\n\n```\nCode Sketch \u2192 #include <LiquidCrystal_I2C.h> \u2192 Library Object (0x27) \u2192 I2C Bus (A4/A5) \u2192 PCF8574 Backpack \u2192 LCD\n```"
      },
      {
        "stepId": "l03_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "Before diving into libraries, verify foundational concepts:\n1. **What is source code?** Human-readable C++ instructions written in the IDE editor.\n2. **What happens during compilation?** Source code translates into machine instructions (hex binary) for the ATmega328P.\n3. **Why do microcontrollers need external modules?** To interact with the physical world through displays, sensors, and actuators."
      },
      {
        "stepId": "l03_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **Library:** A reusable collection of code providing functions and classes for specific hardware devices or algorithms.\n- **`#include`:** A preprocessor directive that injects header declarations into your sketch before compilation begins.\n- **Header File (`.h`):** Defines the class interface, constants, and available methods exposed by the library.\n- **Constructor / Instantiation:** Creating an active object variable representing physical hardware in memory.\n- **API (Application Programming Interface):** The set of commands and methods exposed by the library to control the device."
      },
      {
        "stepId": "l03_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "When you invoke `#include <LiquidCrystal_I2C.h>`, the C++ compiler links pre-compiled routines that handle the complex I2C protocol.\n\n1. Your code calls `lcd.print(\"Hello\")`.\n2. The library converts characters into ASCII byte streams.\n3. The library packages bytes into I2C packets directed at hexadecimal address `0x27`.\n4. The hardware I2C bus (`SDA` / `SCL`) shifts the bits across to the PCF8574 backpack.\n5. The backpack expands the serial bytes back into parallel pulses that toggle the HD44780 LCD controller."
      },
      {
        "stepId": "l03_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine `comp_07` (16x2 LCD Display):\n1. **Backpack Inspection:** Turn the display over. Notice the black daughterboard soldered to the back\u2014this is the I2C backpack.\n2. **Pin Identification:** Count the 4 interface pins:\n   - `GND`: Ground return path.\n   - `VCC`: 5V power supply.\n   - `SDA`: Serial Data line (connects to Uno `A4`).\n   - `SCL`: Serial Clock line (connects to Uno `A5`).\n3. **Compare Pins:** Notice that without the backpack, you would need to wire 16 individual pins to your Arduino!\n4. **Contrast Potentiometer:** Locate the small blue square trimmer potentiometer on the backpack. This adjusts display liquid-crystal contrast."
      },
      {
        "stepId": "l03_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "In C++, libraries frequently use Object-Oriented Programming (OOP):\n- **Class:** The blueprint (e.g., `LiquidCrystal_I2C`).\n- **Object Instance:** The physical device you control (e.g., `lcd`).\n- **Constructor Call:** `LiquidCrystal_I2C lcd(0x27, 16, 2);` creates the object, specifying its 7-bit I2C address (`0x27`), column count (`16`), and row count (`2`)."
      },
      {
        "stepId": "l03_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\n// Set I2C address to 0x27 for a 16 chars and 2 line display\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();          // Initialize LCD hardware and join I2C bus\n  lcd.backlight();     // Turn on the LED backlight\n  lcd.setCursor(0, 0); // Position cursor at Column 0, Row 0\n  lcd.print(\"Monster Lab!\");\n  lcd.setCursor(0, 1); // Position cursor at Column 0, Row 1\n  lcd.print(\"System Active\");\n}\n\nvoid loop() {\n  // Static display - loop remains idle\n}\n```\n\n### Line-by-Line Breakdown:\n- `line 1-2`: Imports the Wire (I2C) and LiquidCrystal_I2C libraries.\n- `line 5`: Instantiates `lcd` at address `0x27` with 16 columns and 2 rows.\n- `line 8`: `lcd.init()` configures the LCD controller registers.\n- `line 9`: `lcd.backlight()` powers the backlight LED.\n- `line 10-13`: Sets cursor positions and prints greeting text."
      },
      {
        "stepId": "l03_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What happens if `lcd.backlight()` is omitted or commented out?\n  *Answer:* Text is rendered on the liquid crystals, but without the backlight LED, it is nearly invisible unless illuminated by an external flashlight.\n- **Prediction 2:** What happens if `lcd.setCursor(16, 0)` is used?\n  *Answer:* The cursor is placed beyond the 16 visible columns (columns 0\u201315), causing characters to wrap off-screen or into hidden DDRAM registers."
      },
      {
        "stepId": "l03_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "Make a controlled change to the sketch:\n1. Replace `lcd.print(\"System Active\");` with dynamic elapsed seconds:\n   ```cpp\n   void loop() {\n     lcd.setCursor(0, 1);\n     lcd.print(\"Uptime: \");\n     lcd.print(millis() / 1000);\n     lcd.print(\"s \");\n     delay(500);\n   }\n   ```\n2. Predict what will happen on Row 1.\n3. Upload and observe the dynamic counter updating every half second."
      },
      {
        "stepId": "l03_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Modern aerospace systems, 3D printers, and industrial robotics do not write low-level register drivers for every display or motor. Aerospace engineering relies on Hardware Abstraction Layers (HAL) and certified driver libraries to guarantee safety, modularity, and rapid maintenance."
      },
      {
        "stepId": "l03_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Compiler Error\n- **Error:** `fatal error: LiquidCrystal_I2C.h: No such file or directory`.\n- **Diagnosis:** The library was never installed in the IDE, or the folder name contains illegal characters.\n- **Remedy:** Open **Tools > Manage Libraries...**, search for `LiquidCrystal_I2C`, and click Install.\n\n### Symptom 2: Blank Screen / Solid White Boxes\n- **Symptom:** Display lights up bright blue with 16 solid white rectangular boxes on Row 1, but no text appears.\n- **Diagnosis:** The contrast potentiometer is set too high, or the I2C address is `0x3F` instead of `0x27`.\n- **Remedy:** Turn the blue contrast potentiometer on the back of the backpack with a small screwdriver until text emerges from the boxes."
      },
      {
        "stepId": "l03_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- Verify whether the LCD backpack requires 5V or 3.3V logic. Connecting 5V to a 3.3V-only display can permanently fry the display controller.\n- Never adjust backpack potentiometers using metal screwdrivers while powered if exposed traces or power rails are nearby.\n- Disconnect USB power before rewiring I2C jumper wires."
      },
      {
        "stepId": "l03_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- Libraries encapsulate complex protocols into clean, reusable functions.\n- The preprocessor directive `#include` makes library classes and functions available.\n- Hardware devices like the I2C LCD backpack use 7-bit hex addresses (e.g. `0x27`).\n- Always check the IDE Library Manager when a missing header error occurs.\n- Up next in Lesson 04: The core execution loop of all microcontroller firmware: `setup()` and `loop()`."
      },
      {
        "stepId": "l03_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### The Never-Sleeping Monster Brain\nUnlike desktop programs that launch, calculate a spreadsheet, and quit, a robot's brain must never terminate. It must continuously sense obstacles, calculate trajectory updates, and control motors thousands of times per second until power is switched off.\n\nIn this lesson, you will master the two fundamental functions of embedded systems: `setup()`\u2014the one-time initialization routine\u2014and `loop()`\u2014the perpetual heartbeat of your monster robot."
      },
      {
        "stepId": "l04_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What happens when an Arduino Uno is plugged into USB?** The bootloader initializes the chip and executes the program stored in flash memory.\n2. **What does the COM port represent?** The virtual serial communications link between computer and Arduino."
      },
      {
        "stepId": "l04_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **`setup()`:** A function executed exactly once upon board power-up or hardware reset button press. Used for configuring pins and starting communication.\n- **`loop()`:** A function executed repeatedly and continuously forever. Houses sensing, decision logic, and actuator commands.\n- **Statement:** A single executable instruction that must end with a semicolon `;`.\n- **Baud Rate:** Communication speed in symbols/bits per second (e.g., 9600 baud = 960 characters/sec with 10-bit framing).\n- **Serial Monitor:** An interactive terminal console embedded in the IDE for bidirectional text communication with the board."
      },
      {
        "stepId": "l04_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "The microcontroller execution lifecycle proceeds through distinct phases:\n\n```\nPower On / Reset\n       \u2193\nClock Oscillator Stabilizes (16 MHz)\n       \u2193\nOptiboot Bootloader Runs (Checks for USB Upload)\n       \u2193 (If no upload)\nmain() Jump\n       \u2193\nExecutes setup() Once\n       \u2193\nwhile(1) { loop(); } (Runs Forever)\n```"
      },
      {
        "stepId": "l04_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine your Arduino Uno R3 (`comp_uno`):\n1. **Reset Switch:** Locate the red or yellow pushbutton in the upper-left corner near the USB connector. Pressing this pulls the ATmega328P `RESET` pin to GND, restarting the program at `setup()`.\n2. **TX and RX LEDs:** Locate the two tiny surface-mount LEDs labeled `TX` (Transmit) and `RX` (Receive) near Digital Pins 0 and 1.\n3. **Observation Task:** Connect the board to USB. Notice how TX and RX flash rapidly when sketches are uploaded or serial text transmits."
      },
      {
        "stepId": "l04_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- **Function Syntax:** `void setup() { ... }`. `void` means the function returns no value.\n- **Curly Braces `{}`:** Group multiple instructions into an executable code block. Every `{` must have a matching `}`.\n- **Semicolons `;`:** Mark the conclusion of an instruction statement. Omitting a semicolon causes a compiler syntax error."
      },
      {
        "stepId": "l04_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\nvoid setup() {\n  Serial.begin(9600); // Initialize hardware UART at 9600 baud\n  Serial.println(\"--- Monster Lab Online ---\");\n  Serial.println(\"System Initialized Successfully.\");\n}\n\nvoid loop() {\n  Serial.print(\"Heartbeat ping at timestamp: \");\n  Serial.println(millis());\n  delay(1000); // Pause for 1000 milliseconds (1 second) before repeating\n}\n```\n\n### Breakdown:\n- `Serial.begin(9600)`: Powers on the ATmega328P USART hardware and sets baud generator registers.\n- `Serial.println(...)`: Sends ASCII characters followed by carriage return `\\r` and line feed `\\n`.\n- `millis()`: Returns the number of milliseconds since the Arduino began running the current sketch.\n- `delay(1000)`: Halts execution for 1000 ms, regulating loop cadence."
      },
      {
        "stepId": "l04_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What happens if `Serial.println(\"Booting...\");` is placed inside `loop()` instead of `setup()`?\n  *Answer:* It prints continuously every loop cycle rather than once at startup.\n- **Prediction 2:** What happens if `Serial.begin(9600)` is omitted from `setup()`?\n  *Answer:* The hardware UART baud rate generator is not configured; no text will transmit over USB, and the Serial Monitor will stay completely blank."
      },
      {
        "stepId": "l04_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "1. Change `delay(1000);` to `delay(250);`.\n2. Predict the new transmission frequency: 4 pings per second instead of 1.\n3. Upload sketch, open Serial Monitor, and observe the accelerated telemetry cadence."
      },
      {
        "stepId": "l04_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Automotive electronic control units (ECUs), NASA planetary rovers, and medical infusion pumps execute identical state loops:\n- `setup()`: Perform sensor self-test, verify battery voltage, zero actuators.\n- `loop()`: Read obstacle sensors, update kinematics math, drive steering servos within rigid cycle deadlines."
      },
      {
        "stepId": "l04_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Garbled Characters in Serial Monitor\n- **Symptom:** Serial Monitor prints `\u2e2e\u2e2ex\u2e2ef\u2e2e` or strange inverted symbols.\n- **Diagnosis:** Baud rate mismatch! The sketch specified `9600`, but the Serial Monitor dropdown in the lower right is set to 115200 or 57600.\n- **Remedy:** Click the baud rate dropdown and select `9600 baud`.\n\n### Symptom 2: Compiler Error on Braces / Semicolons\n- **Symptom:** `error: expected ';' before '}' token`.\n- **Diagnosis:** The statement directly preceding line X is missing its terminating `;`.\n- **Remedy:** Locate the unclosed statement and add `;`."
      },
      {
        "stepId": "l04_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- Never plug or unplug shield headers or jumper wires into the 5V and GND rail while the USB cable is supplying power, as accidental shorts can trigger computer USB port overcurrent shutdown.\n- Place the Arduino on a non-conductive surface (wood, plastic, or antistatic mat)\u2014never on metal workbench surfaces or foil wrappers."
      },
      {
        "stepId": "l04_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- The microcontroller execution model relies on `setup()` for configuration and `loop()` for ongoing autonomy.\n- Semicolons, braces, and matching baud rates are non-negotiable fundamentals of embedded software.\n- The Serial Monitor provides an essential telemetry window into your robot's thoughts.\n- Up next in Lesson 05: Moving from digital text to physical photons with the Blink circuit."
      },
      {
        "stepId": "l04_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Awaken the Beast: Creating Physical Photons\nSoftware becomes robotics when binary logic gates physically manipulate the physical universe. Turning an LED on and off is the \"Hello World\" of embedded engineering, validating that the microcontroller output transistors can source and sink electrical current under software command.\n\nIn this mission, you will command electrical charges through silicon gates to create visible light on your Arduino board!\n\n```\nPORTB5 Register \u2192 Internal P-MOSFET Closes \u2192 Pin 13 at 5V \u2192 Current Flows \u2192 SMD LED Glows \u2192 GND Return\n```"
      },
      {
        "stepId": "l05_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What is a digital signal?** An electrical signal that exists in one of two discrete states: HIGH or LOW.\n2. **What is GND?** Ground\u2014the 0V reference return path required for electric current to complete a circuit loop."
      },
      {
        "stepId": "l05_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **`digitalWrite()`:** Function that commands an output pin to 5V (`HIGH`) or 0V (`LOW`).\n- **`pinMode()`:** Function that configures internal silicon transistors for high-impedance listening (`INPUT`) or low-impedance driving (`OUTPUT`).\n- **`OUTPUT`:** Push-pull driver mode capable of sourcing or sinking electrical current to external components.\n- **`delay()`:** Pauses microcontroller execution for a specified number of milliseconds (1/1000th of a second).\n- **Built-in LED (Pin 13):** The surface-mount amber LED hardwired directly to Digital Pin 13 on the Uno PCB."
      },
      {
        "stepId": "l05_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "Inside the ATmega328P microcontroller chip:\n1. Executing `digitalWrite(13, HIGH)` sets bit 5 of the `PORTB` register.\n2. An internal P-channel MOSFET turns on, connecting Pin 13 to the internal 5.0V power rail.\n3. Current (~5\u201310 mA) flows out through Pin 13, passes through an on-board 1k\u03a9 SMD series resistor, enters the amber LED anode, excites photons across the semiconductor bandgap, exits the cathode, and returns to `GND`.\n4. Executing `digitalWrite(13, LOW)` turns on an internal N-channel MOSFET, tying Pin 13 directly to `GND` (0V). With no voltage difference across the LED, current stops flowing and the light extinguishes."
      },
      {
        "stepId": "l05_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Inspect your Arduino Uno R3 (`comp_uno`):\n1. **Locate the 'L' LED:** Look between the digital pin headers (Pins 8\u201313) and the main microcontroller chip. Find the tiny rectangular amber LED labeled with a silkscreened `L`.\n2. **Trace the Silkscreen:** Follow the fine copper PCB trace running between Digital Pin 13 and the `L` indicator.\n3. **Power Verification:** Notice the green `ON` LED nearby. The green LED shows the 5V power bus is energized, while the amber `L` LED is completely under software control!"
      },
      {
        "stepId": "l05_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- **Constants in Arduino Core:** `HIGH` is defined as integer `1`; `LOW` is defined as integer `0`.\n- **`OUTPUT` Mode:** Must be declared in `setup()` before `digitalWrite()` can deliver active drive current. Without `pinMode(OUTPUT)`, the pin remains in high-impedance `INPUT` mode."
      },
      {
        "stepId": "l05_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\nconst int ledPin = 13; // Built-in LED pin\n\nvoid setup() {\n  pinMode(ledPin, OUTPUT); // Configure Pin 13 as a low-impedance output\n}\n\nvoid loop() {\n  digitalWrite(ledPin, HIGH); // Drive Pin 13 to 5V (turn LED ON)\n  delay(1000);                // Maintain state for 1000 ms (1 second)\n  digitalWrite(ledPin, LOW);  // Drive Pin 13 to 0V (turn LED OFF)\n  delay(1000);                // Maintain state for 1000 ms (1 second)\n}\n```\n\n### Key Elements:\n- `const int ledPin = 13;`: Descriptive constant prevents accidental pin number modification.\n- `pinMode(ledPin, OUTPUT);`: Switches internal transistors from high-impedance mode to active push-pull driver.\n- `digitalWrite(ledPin, HIGH)`: Sinks current through LED to ground.\n- `delay(1000)`: Freezes execution so the human eye has time to observe the lit state."
      },
      {
        "stepId": "l05_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What happens if `delay(1000)` is changed to `delay(10)` for both ON and OFF states?\n  *Answer:* The LED flashes at 50 Hz. Due to human *persistence of vision*, the eye cannot resolve individual flashes; it appears steadily lit at approximately half brightness.\n- **Prediction 2:** What happens if `pinMode(13, OUTPUT)` is omitted from `setup()`?\n  *Answer:* Pin 13 defaults to high-impedance `INPUT`. `digitalWrite(HIGH)` merely enables the weak internal 30k\u03a9 pull-up resistor, making the LED illuminate so faintly it is barely visible in a dark room."
      },
      {
        "stepId": "l05_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "1. Create an asymmetric \"strobe heartbeat\" cadence:\n   ```cpp\n   digitalWrite(ledPin, HIGH);\n   delay(100); // Quick flash\n   digitalWrite(ledPin, LOW);\n   delay(900); // Long pause\n   ```\n2. Predict the pattern, upload, and observe the rapid pulse effect used in drone navigation beacons.",
        "interactiveWidgetType": "blinkSimulator"
      },
      {
        "stepId": "l05_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Status indicator lights on satellites, medical ventilators, automated factory cells, and quadcopter flight controllers use pulsed blink patterns to convey hardware health, error codes, and battery telemetry even if primary video screens crash."
      },
      {
        "stepId": "l05_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: LED Stays Solid ON and Never Blinks\n- **Diagnosis:** Missing second `delay()`, or both `digitalWrite` calls are set to `HIGH`.\n- **Remedy:** Verify that `digitalWrite(ledPin, LOW)` is followed by a `delay()`.\n\n### Symptom 2: Upload Fails (`programmer is not responding`)\n- **Diagnosis:** The USB cable lost connection or the wrong COM port is selected in the IDE.\n- **Remedy:** Check USB connection, confirm `Tools > Port`, and retry upload."
      },
      {
        "stepId": "l05_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- **Pin Current Limits:** An ATmega328P output pin has an absolute maximum current rating of 40 mA (recommended 20 mA continuous).\n- **Current Limiting Resistors:** Never wire an external LED directly between an Uno pin and GND without a 220\u03a9\u20131k\u03a9 current-limiting resistor, or the pin's internal driver FET will burn out.\n- The built-in Pin 13 LED already has a built-in SMD resistor on the PCB, making it safe for immediate experimentation."
      },
      {
        "stepId": "l05_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- Digital outputs switch between 5V (`HIGH`) and 0V (`LOW`).\n- `pinMode(OUTPUT)` enables the push-pull transistor drivers.\n- `delay()` regulates timing; rapid toggling (>50Hz) triggers persistence of vision.\n- Respect pin current limits (20mA) to preserve microcontroller silicon.\n- Up next in Lesson 06: Reading continuous analog voltages with a potentiometer and 10-bit ADC."
      },
      {
        "stepId": "l05_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Sense the Spectrum: Analog Perception\nThe physical world is not simply ON or OFF. Temperatures rise and fall smoothly, battery voltages drain gradually, and robot steering angles vary continuously. A potentiometer gives your monster robot continuous analog perception, allowing it to sense fine gradients like steering angles, robotic arm joint positions, and motor throttle.\n\n```\n5V Power \u2192 Carbon Track \u2192 Wiper Picks Off Voltage \u2192 ATmega328P 10-bit ADC \u2192 Integer (0 to 1023)\n```"
      },
      {
        "stepId": "l06_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **What does `digitalRead()` return?** Only binary `HIGH` (1) or `LOW` (0).\n2. **What voltage does the Arduino Uno provide on its 5V rail?** Regulated 5.0 Volts DC."
      },
      {
        "stepId": "l06_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **Potentiometer:** A three-terminal variable resistor with a rotating shaft connected to an internal wiper contact.\n- **Voltage Divider:** A circuit of two resistances in series that divides an input voltage into a proportional output fraction.\n- **ADC (Analog-to-Digital Converter):** An on-chip silicon peripheral that translates continuous analog voltage into a binary integer.\n- **10-Bit Resolution:** $2^{10} = 1024$ discrete measurement steps (~4.88 mV per step on a 5.0V reference).\n- **`analogRead()`:** Built-in function that samples an analog pin (`A0`\u2013`A5`) and returns an integer from 0 to 1023."
      },
      {
        "stepId": "l06_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "Inside `comp_20`:\n1. A horseshoe-shaped resistive carbon track connects Outer Terminal 1 and Outer Terminal 3 (total resistance $\\approx 10\\text{k}\\Omega$).\n2. Outer Pin 1 connects to `5V`, and Outer Pin 3 connects to `GND`.\n3. Turning the knob sweeps Center Wiper Pin 2 across the track, splitting it into two resistances ($R_1$ and $R_2$):\n   $$V_{\\text{out}} = 5.0\\text{V} \\times \\frac{R_2}{R_1 + R_2}$$\n4. The output voltage connects to Uno Pin `A0`.\n5. The ATmega328P's successive-approximation 10-bit ADC quantizes the voltage into an integer:\n   $$\\text{ADC Count} = \\text{round}\\left(V_{\\text{in}} \\times \\frac{1023}{5.0\\text{V}}\\right)$$"
      },
      {
        "stepId": "l06_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine `comp_20` (10k\u03a9 Potentiometer) and `comp_breadboard`:\n1. **Pin Identification:** Notice the 3 pins protruding from the bottom:\n   - Pin 1 (Outer Leg): Connect to Uno `5V`.\n   - Pin 2 (Center Wiper): Connect to Uno `A0`.\n   - Pin 3 (Outer Leg): Connect to Uno `GND`.\n2. **Breadboard Placement:** Insert the potentiometer into the breadboard across three separate terminal tie-point rows (e.g., Rows 10, 11, 12). Never place all three pins in the same row!\n3. **Connect Jumpers:** Run a red jumper from Uno `5V` to breadboard Row 10, a yellow jumper from Uno `A0` to Row 11, and a black jumper from Uno `GND` to Row 12."
      },
      {
        "stepId": "l06_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- Unlike digital pins, Uno analog input pins (`A0`\u2013`A5`) do not require `pinMode()` prior to calling `analogRead()`. The ADC multiplexer hardware automatically configures the pin during conversion.\n- `float` data types store decimal numbers for true voltage calculations."
      },
      {
        "stepId": "l06_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\nconst int potPin = A0;\n\nvoid setup() {\n  Serial.begin(9600); // Initialize telemetry link\n}\n\nvoid loop() {\n  int rawValue = analogRead(potPin);          // Read ADC count (0 to 1023)\n  float voltage = rawValue * (5.0 / 1023.0);  // Convert count to true voltage\n\n  Serial.print(\"ADC Count: \");\n  Serial.print(rawValue);\n  Serial.print(\" | Voltage: \");\n  Serial.print(voltage, 2);\n  Serial.println(\" V\");\n\n  delay(200); // 5 Hz update rate for readable telemetry\n}\n```\n\n### Breakdown:\n- `analogRead(potPin)`: Takes approximately 100 microseconds to sample and hold the analog voltage and execute the 10-bit conversion.\n- `voltage = rawValue * (5.0 / 1023.0)`: Scales the integer count to physical volts.\n- `Serial.print(voltage, 2)`: Prints the float formatted to 2 decimal places."
      },
      {
        "stepId": "l06_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What will `analogRead(A0)` return if the knob is rotated exactly midway?\n  *Answer:* Approximately 511 to 512 counts (~2.50 Volts).\n- **Prediction 2:** What happens if you swap the wires connected to Outer Pin 1 and Outer Pin 3?\n  *Answer:* The rotation polarity reverses (turning clockwise decreases rather than increases the count)."
      },
      {
        "stepId": "l06_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "1. Combine Lesson 05 and 06: use `rawValue` directly as the delay period for the Pin 13 LED:\n   ```cpp\n   digitalWrite(13, HIGH);\n   delay(rawValue);\n   digitalWrite(13, LOW);\n   delay(rawValue);\n   ```\n2. Turn the knob and observe how physical rotation directly modulates the LED's blinking speed.",
        "interactiveWidgetType": "potentiometerSimulator"
      },
      {
        "stepId": "l06_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Radio transmitter control sticks, aircraft throttle quadrants, electric vehicle accelerator pedals, and industrial robotic arm joint potentiometers all use rotary voltage division for position telemetry."
      },
      {
        "stepId": "l06_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Potentiometer Gets Burning Hot!\n- **Diagnosis:** Dead short! 5V and GND were connected across an outer pin and the center wiper, creating an unrestricted short when turned to the stop.\n- **Remedy:** Unplug USB immediately! Verify that 5V and GND connect to the two *outer* legs, and A0 connects to the *center* wiper.\n\n### Symptom 2: Serial Readings Jump Erratically (e.g., 100, 950, 40)\n- **Diagnosis:** Floating input! The center wiper wire is loose or plugged into the wrong breadboard row, acting as an antenna picking up ambient 60Hz electromagnetic noise.\n- **Remedy:** Firmly seat the wiper wire into the center pin's terminal row."
      },
      {
        "stepId": "l06_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- Never apply more than 5.0V to an analog pin on an Uno R3. Exceeding 5.5V will forward-bias the internal silicon clamping diodes and destroy the ADC multiplexer.\n- Avoid applying mechanical torque beyond the physical rotation stops of the potentiometer."
      },
      {
        "stepId": "l06_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- Potentiometers act as variable voltage dividers producing 0.0V to 5.0V.\n- The 10-bit ADC quantizes analog voltages into integers from 0 to 1023 (~4.88 mV per count).\n- Solderless breadboards connect rows horizontally\u2014keep pins in separate rows.\n- Up next in Lesson 07: Modulating digital duty cycles with PWM to mix colors on an RGB LED."
      },
      {
        "stepId": "l06_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "title": "Mission Introduction",
        "type": "story",
        "markdownContent": "### Expressive Monsters: Crafting Living Light\nMonsters need emotion and visual expression! By combining three primary wavelengths of light\u2014Red, Green, and Blue\u2014at varying intensities, we can create any color in the visible rainbow, from energetic yellow to menacing purple or calm cyan.\n\nBecause the Arduino Uno does not have true analog output voltage DACs on its digital pins, we use high-speed silicon pulsing\u2014Pulse Width Modulation\u2014to fool the human eye into perceiving smooth brightness levels!\n\n```\nTimer Register OCR1A \u2192 High-Speed 490Hz Pulse Train \u2192 Duty Cycle Average \u2192 Eye Cone Cells \u2192 Perceived Color\n```"
      },
      {
        "stepId": "l07_s02",
        "title": "Prior Knowledge Check",
        "type": "story",
        "markdownContent": "1. **How does an LED emit light?** Electric current passes forward through a semiconductor diode junction, releasing photons.\n2. **Why does an LED need a series resistor?** To limit forward current and prevent the semiconductor die from thermal runaway."
      },
      {
        "stepId": "l07_s03",
        "title": "Core Concept & Vocabulary",
        "type": "story",
        "markdownContent": "- **RGB LED:** A single component packaging three independent semiconductor dies (Red, Green, Blue) sharing common electrical pins.\n- **Common Cathode:** Configuration where all three LEDs share a single negative Ground (`-`) lead.\n- **Pulse Width Modulation (PWM):** Digital technique of switching an output between 5V and 0V hundreds of times per second to simulate intermediate voltages.\n- **Duty Cycle:** The ratio or percentage of time a square wave pulse remains in the `HIGH` state during one full period.\n- **`analogWrite()`:** Built-in function generating 8-bit PWM (0 = 0% duty cycle / 0V average; 255 = 100% duty cycle / 5V continuous)."
      },
      {
        "stepId": "l07_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "Human photoreceptor cone cells cannot resolve light pulses cycling faster than approximately 60 Hz (persistence of vision).\n1. The ATmega328P hardware timers oscillate at ~490 Hz (Pins 9, 10, 11, 3) or ~980 Hz (Pins 5, 6).\n2. Setting `analogWrite(pin, 127)` configures the timer to drive the pin to 5V for 50% of the period, and 0V for the remaining 50%.\n3. The human eye integrates this photon flux, perceiving exactly 50% brightness.\n4. By mixing different duty cycles across Red, Green, and Blue channels, the three primary wavelengths stimulate retina cone cells in varying proportions to synthesize over 16 million colors!"
      },
      {
        "stepId": "l07_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine a 4-pin 5mm Common Cathode RGB LED:\n1. **Lead Identification:** Hold the LED with the flat edge on the plastic rim facing right:\n   - Lead 1 (Outer Leg): Red Anode\n   - Lead 2 (Longest Leg): Common Cathode (GND)\n   - Lead 3: Green Anode\n   - Lead 4 (Outer Leg): Blue Anode\n2. **Breadboard Insertion:** Insert the 4 leads into 4 adjacent breadboard rows.\n3. **Current Limiting Resistors:** Connect a 220\u03a9 or 330\u03a9 resistor to Lead 1 (Red), Lead 3 (Green), and Lead 4 (Blue). Connect Lead 2 directly to Uno `GND`.\n4. **PWM Pin Wiring:** Connect Red resistor to Pin 9, Green resistor to Pin 10, and Blue resistor to Pin 11."
      },
      {
        "stepId": "l07_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "- `analogWrite(pin, value)` does NOT generate true analog DC voltage; it modulates hardware timer compare registers.\n- Valid values are integers from `0` to `255` (8-bit quantization)."
      },
      {
        "stepId": "l07_s07",
        "title": "Code Walkthrough: Annotated Sketch",
        "type": "codeExperiment",
        "markdownContent": "```cpp\nconst int redPin = 9;\nconst int greenPin = 10;\nconst int bluePin = 11;\n\nvoid setup() {\n  pinMode(redPin, OUTPUT);\n  pinMode(greenPin, OUTPUT);\n  pinMode(bluePin, OUTPUT);\n}\n\nvoid setColor(int r, int g, int b) {\n  analogWrite(redPin, constrain(r, 0, 255));\n  analogWrite(greenPin, constrain(g, 0, 255));\n  analogWrite(bluePin, constrain(b, 0, 255));\n}\n\nvoid loop() {\n  setColor(255, 0, 255);   // Purple (Red + Blue)\n  delay(1000);\n  setColor(255, 120, 0);   // Monster Amber/Orange\n  delay(1000);\n  setColor(0, 255, 255);   // Cyan (Green + Blue)\n  delay(1000);\n}\n```\n\n### Breakdown:\n- `setColor(...)`: Modular helper function encapsulating multi-channel mixing.\n- `constrain(val, 0, 255)`: Defensive programming ensuring PWM values stay within the valid 8-bit window.\n- In `loop()`, high-level colors transition every second."
      },
      {
        "stepId": "l07_s08",
        "title": "Code Prediction: Hypothesis & Deductions",
        "type": "codeExperiment",
        "markdownContent": "- **Prediction 1:** What color appears when `setColor(255, 255, 0)` executes?\n  *Answer:* Bright Yellow (equal parts full-intensity Red and Green light).\n- **Prediction 2:** What happens if you plug the Blue LED jumper into Digital Pin 8 instead of Pin 11?\n  *Answer:* Digital Pin 8 does NOT support hardware PWM on the Uno; `analogWrite(8, 128)` will not produce variable dimming\u2014it will jump abruptly between fully on and fully off."
      },
      {
        "stepId": "l07_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "1. Wire the Potentiometer from Lesson 06 into Analog Pin `A0`.\n2. Map its reading to the Blue channel while keeping Red fixed at 128:\n   ```cpp\n   int knob = analogRead(A0);\n   int blueVal = map(knob, 0, 1023, 0, 255);\n   setColor(128, 0, blueVal);\n   ```\n3. Rotate the knob to dial smoothly between deep red, magenta, and bright violet!",
        "interactiveWidgetType": "rgbMixer"
      },
      {
        "stepId": "l07_s10",
        "title": "Real-World Robotics: Industrial & Aerospace Systems",
        "type": "visualExplanation",
        "markdownContent": "Full-color gaming PC illumination, automotive dynamic ambient lighting, smart home lightbulbs (Philips Hue), and multi-colored warning beacons on autonomous warehouse rovers rely on multi-channel PWM color synthesis."
      },
      {
        "stepId": "l07_s11",
        "title": "Troubleshooting Challenge: Diagnostic Scenarios",
        "type": "story",
        "markdownContent": "### Symptom 1: Inverted Brightness\n- **Symptom:** Passing `255` turns the LED off, and passing `0` turns it fully on.\n- **Diagnosis:** Common Anode LED! You have a common anode component whose shared lead is connected to 5V instead of GND.\n- **Remedy:** Connect common lead to 5V and invert code logic: `analogWrite(pin, 255 - value)`.\n\n### Symptom 2: Red Is Blindingly Bright, Blue Is Very Dim\n- **Diagnosis:** Forward voltage disparity: Red diodes have a lower forward drop ($V_f \\approx 1.8\\text{V}$), while Blue diodes require $V_f \\approx 3.2\\text{V}$.\n- **Remedy:** Use a higher value resistor (330\u03a9 or 470\u03a9) on the Red anode line to balance luminous intensity."
      },
      {
        "stepId": "l07_s12",
        "title": "Workshop Safety & Hardware Care",
        "type": "story",
        "markdownContent": "- Never connect all three color leads directly to 5V or output pins without current-limiting resistors. Three concurrent short circuits can draw >120mA, tripping thermal protection.\n- Ensure the longest pin (cathode) connects to GND, not 5V, to prevent reverse voltage breakdown."
      },
      {
        "stepId": "l07_s13",
        "title": "Final Review & Competencies",
        "type": "story",
        "markdownContent": "- Additive optics combines Red, Green, and Blue light to create full-spectrum color.\n- PWM modulates duty cycles at hundreds of hertz to simulate variable voltage without true DACs.\n- Always use series resistors on each color channel to balance currents and prevent burnouts.\n- Up next in Lesson 08: Reading mechanical pushbuttons, debouncing, and internal pull-up resistors."
      },
      {
        "stepId": "l07_s14",
        "title": "Comprehensive Knowledge Check",
        "type": "quizCheckpoint",
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "markdownContent": "- **`digitalRead()`:** Function that measures an input pin, returning `HIGH` (if voltage $\\ge 3.0\\text{V}$) or `LOW` (if voltage $\\le 1.5\\text{V}$).\n- **Floating Pin:** An unconnected high-impedance input pin that acts as an antenna, picking up stray electromagnetic fields and oscillating erratically.\n- **Pull-Up Resistor:** A resistor connecting an input pin to 5V, guaranteeing a stable, deterministic `HIGH` state when a switch is open.\n- **`INPUT_PULLUP`:** Built-in mode configuring the ATmega328P's internal 20k\u03a9\u201350k\u03a9 pull-up resistor, eliminating the need for an external breadboard resistor.\n- **Active-Low Logic:** Circuit architecture where 0V (`LOW`) signals the active/pressed state, and 5V (`HIGH`) signals idle.\n- **Switch Bounce:** Microsecond mechanical vibrations when switch metal contacts collide, creating multiple rapid false triggers."
      },
      {
        "stepId": "l08_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "Inside the ATmega328P input buffer:\n1. When configured with `INPUT_PULLUP`, an internal P-FET engages a ~30k\u03a9 resistor tied to 5V.\n2. When the external button is open (unpressed), tiny leakage currents flow through the pull-up, holding the pin securely at 5.0V (`HIGH`).\n3. When the button is pressed, it shorts the pin directly to Ground (0V). Because the internal pull-up has a high 30k\u03a9 resistance, only $\\frac{5\\text{V}}{30\\text{k}\\Omega} \\approx 0.16\\text{ mA}$ flows harmlessly to ground.\n4. The input Schmitt trigger detects 0V and reports `LOW`."
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
        "markdownContent": "Because of active-low logic:\n```cpp\nif (digitalRead(buttonPin) == LOW) {\n  // ACTION: Button IS physically pressed!\n} else {\n  // IDLE: Button is released!\n}\n```"
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
        "markdownContent": "1. Create a push-to-toggle counter:\n   ```cpp\n   int count = 0;\n   void loop() {\n     if (digitalRead(buttonPin) == LOW) {\n       count++;\n       Serial.print(\"Press Count: \");\n       Serial.println(count);\n       delay(200); // Simple software debounce delay\n     }\n   }\n   ```\n2. Press the button quickly and observe how a 200ms delay prevents mechanical switch bounce from registering 5 presses for 1 physical click."
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
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "markdownContent": "- **I2C (Inter-Integrated Circuit):** A synchronous, multi-target, bidirectional communication bus developed by Philips Semiconductor.\n- **SDA (Serial Data):** The bidirectional line over which data bytes travel.\n- **SCL (Serial Clock):** The synchronizing clock pulse train generated exclusively by the Controller.\n- **Controller (Master):** The device that initiates bus communication and generates SCL clock pulses (the Uno).\n- **Target (Slave):** Peripheral devices listening on the bus, responding only when their unique 7-bit address is called.\n- **7-Bit Address:** A unique identifier allowing up to 128 devices to share the bus without wire conflicts.\n- **ACK / NACK:** Acknowledge (0) or Not Acknowledge (1) bit returned by a target device to confirm packet receipt.\n- **Open-Drain / Pull-Up:** Hardware architecture where lines are passively held at 5V by resistors and pulled to GND by transistors."
      },
      {
        "stepId": "l09_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "Communication on the I2C bus follows rigid timing:\n1. **Start Condition:** Controller pulls `SDA` LOW while `SCL` remains HIGH.\n2. **Address Frame:** Controller transmits 7 address bits followed by a Read/Write bit (0 for Write, 1 for Read).\n3. **Target ACK:** The target device whose internal address matches pulls `SDA` LOW during clock cycle 9.\n4. **Data Transmission:** Data bytes are transferred 8 bits at a time, each followed by an ACK bit.\n5. **Stop Condition:** Controller transitions `SDA` from LOW to HIGH while `SCL` is HIGH, releasing the bus."
      },
      {
        "stepId": "l09_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine `comp_07` (16x2 LCD) and `comp_10` (DS3231 RTC Module):\n1. **Parallel Bus Wiring:** Insert both components onto the breadboard.\n2. **Shared Power:** Connect both `VCC` pins to the breadboard 5V power rail, and both `GND` pins to the Ground rail.\n3. **Shared Data & Clock:**\n   - Connect BOTH `SDA` pins together and run a single wire to Uno Pin `A4`.\n   - Connect BOTH `SCL` pins together and run a single wire to Uno Pin `A5`.\n4. *Notice: Even with two complex peripherals attached, you still have nearly all of your Arduino's digital and analog pins completely free!*"
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
        "markdownContent": "```cpp\n#include <Wire.h>\n\nvoid setup() {\n  Wire.begin();        // Join I2C bus as Controller\n  Serial.begin(9600);\n  Serial.println(\"\\n--- I2C Hardware Bus Scanner ---\");\n}\n\nvoid loop() {\n  byte count = 0;\n  for (byte address = 1; address < 127; address++) {\n    Wire.beginTransmission(address);\n    byte error = Wire.endTransmission();\n\n    if (error == 0) { // Target device acknowledged ping!\n      Serial.print(\"Discovered I2C device at address: 0x\");\n      if (address < 16) Serial.print(\"0\");\n      Serial.println(address, HEX);\n      count++;\n    }\n  }\n  Serial.print(\"Scan complete. Total devices detected: \");\n  Serial.println(count);\n  delay(5000);\n}\n```\n\n### Breakdown:\n- The loop iterates through valid 7-bit addresses ($1$ to $126$).\n- `Wire.endTransmission()` returns `0` if an ACK was received, proving a device is alive at that address.\n- Addresses are printed in standardized hexadecimal format."
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
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "markdownContent": "- **SPI (Serial Peripheral Interface):** A 4-wire, full-duplex, high-speed synchronous serial interface.\n- **MOSI (Master Out Slave In):** Data line carrying bytes from the Arduino to the peripheral.\n- **MISO (Master In Slave Out):** Data line carrying bytes from the peripheral back into the Arduino.\n- **SCK (Serial Clock):** High-frequency clock generated by the Uno (up to 8 MHz) that latches bits on each edge.\n- **CS / SS (Chip Select / Slave Select):** Dedicated active-low pin that awakens a specific peripheral chip.\n- **Full-Duplex:** Simultaneous transmission and reception of data in both directions during the exact same clock pulse."
      },
      {
        "stepId": "l10_s04",
        "title": "How It Works: Signal Flow & Hardware Registers",
        "type": "visualExplanation",
        "markdownContent": "SPI functions as two linked 8-bit shift registers forming a circular ring:\n1. The Arduino pulls the target's dedicated `CS` pin `LOW` (0V).\n2. For each tick of the `SCK` line:\n   - The Master shifts 1 bit out on `MOSI` and samples 1 bit on `MISO`.\n   - The Target simultaneously shifts 1 bit out on `MISO` and samples 1 bit on `MOSI`.\n3. After 8 clock pulses, an entire byte has traveled in both directions simultaneously!\n4. The Arduino pulls `CS` `HIGH` (5V), placing the target's MISO output pin into high-impedance state so other chips can use the bus."
      },
      {
        "stepId": "l10_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine `comp_23` (RC522 RFID Module) and `comp_15` (8x8 Dot Matrix):\n1. **Header Inspection:** Locate the pin labels on the module headers:\n   - Find `MOSI` (sometimes labeled `SI` or `DIN`).\n   - Find `MISO` (sometimes labeled `SO` or `DOUT`).\n   - Find `SCK` (sometimes labeled `CLK`).\n   - Find `SDA / NSS / CS` (Chip Select).\n2. **Uno Hardware SPI Pins:**\n   - Digital Pin 11: `MOSI`\n   - Digital Pin 12: `MISO`\n   - Digital Pin 13: `SCK`\n   - Digital Pin 10: Standard hardware `SS` / `CS`"
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
        "markdownContent": "1. Add a second SPI target using Digital Pin 9 as `chipSelectPin2`.\n2. Modify the code to query Target 1, set CS1 HIGH, query Target 2, and set CS2 HIGH.\n3. Observe how independent CS pins share the exact same 3 data/clock wires without address collision."
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
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "markdownContent": "UART serial framing operates without a clock line:\n1. **Idle State:** The serial line sits at continuous HIGH (5V or 3.3V).\n2. **Start Bit:** The transmitter pulls the line LOW for exactly 1 bit duration ($\\frac{1}{9600\\text{ baud}} \\approx 104.16\\ \\mu\\text{s}$). This falling edge triggers the receiver's internal clock timer.\n3. **Data Sampling:** The receiver counts clock ticks and samples the line state in the exact middle of each of the subsequent 8 bit windows.\n4. **Stop Bit:** The transmitter pulls the line HIGH for at least 1 bit duration to conclude the frame and re-establish the idle level."
      },
      {
        "stepId": "l11_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine `comp_29` (HC-05 Bluetooth Module):\n1. **Pin Inspection:** Locate the header pins: `VCC`, `GND`, `TXD`, `RXD`, `STATE`, `EN`.\n2. **Power Wiring:** Connect Module `VCC` to Uno `5V`, and Module `GND` to Uno `GND`.\n3. **Receive Line (Direct):** Connect Module `TXD` (which outputs safe 3.3V logic) directly to Uno Digital Pin 10 (`SoftwareSerial RX`).\n4. **Transmit Line (Voltage Divider):** Uno Pin 11 outputs 5.0V, but the HC-05 RXD pin accepts only 3.3V maximum!\n   - Connect Uno Pin 11 to one leg of a 1k\u03a9 resistor.\n   - Connect the other leg of the 1k\u03a9 resistor to a breadboard node.\n   - Connect the breadboard node to HC-05 `RXD`.\n   - Connect a 2k\u03a9 resistor from the breadboard node to `GND`.\n   - *Result: $V_{\\text{out}} = 5\\text{V} \\times \\frac{2\\text{k}\\Omega}{1\\text{k}\\Omega + 2\\text{k}\\Omega} = 3.33\\text{V}$ (perfect protection!).*"
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
        "markdownContent": "- **Prediction 1:** What happens if the Bluetooth module transmits at 38400 baud while `bluetooth.begin()` is set to 9600?\n  *Answer:* Severe bit sampling timing errors: incoming characters will appear as corrupted gibberish symbols.\n- **Prediction 2:** What happens if you plug Bluetooth TX directly into Arduino Hardware Pin 0 (RX) while trying to upload code via USB?\n  *Answer:* USB code upload fails with an `avrdude` sync error because the ATmega16U2 USB chip and the Bluetooth module fight to drive Pin 0 simultaneously."
      },
      {
        "stepId": "l11_s09",
        "title": "Guided Experiment: Parameter Modulation",
        "type": "codeExperiment",
        "markdownContent": "1. Pair a smartphone or laptop to the HC-05 module using a Bluetooth terminal application (e.g. Serial Bluetooth Terminal).\n2. Type command `'1'` on the phone.\n3. Expand the Arduino code to toggle the Pin 13 LED on when `'1'` is received, and off when `'0'` is received.\n4. Test wireless control from across the room!"
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
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
        "markdownContent": "When current passes through the motor coils:\n1. Electric current creates a magnetic field that interacts with permanent magnets, generating rotational torque (Lorentz Force).\n2. When the control transistor abruptly opens:\n   - Current drops rapidly ($\\frac{di}{dt} \\to -\\infty$).\n   - The collapsing magnetic field induces a reverse high-voltage spike according to Lenz's Law: $V = -L \\frac{di}{dt}$.\n   - Without protection, this 60V+ spike arcs across transistor junctions, destroying the driver.\n3. The **Flyback Diode** (or the L293D's internal clamping diodes) becomes forward-biased by this negative spike, safely shunting current through the coil resistance as mild heat."
      },
      {
        "stepId": "l12_s05",
        "title": "Hardware Mission: Component & Pin Inspection",
        "type": "physicalTask",
        "markdownContent": "Examine `comp_l293d` (16-pin Dual H-Bridge IC) and `comp_33` (DC Motor):\n1. **IC Notch Orientation:** Locate the semi-circular notch on the top of the L293D chip. Pin 1 is immediately to the left of the notch.\n2. **Pin Identification:**\n   - Pin 16 ($V_{CC1}$): Logic 5V (from Arduino 5V).\n   - Pin 8 ($V_{CC2}$): Motor Power (connect to external 6V\u20139V battery pack).\n   - Pins 4, 5, 12, 13: Ground heat-sink pins (connect to common Ground).\n   - Pin 1 (Enable 1): PWM speed input (connect to Uno PWM Pin 9).\n   - Pin 2 (Input 1): Direction Leg A (connect to Uno Pin 8).\n   - Pin 7 (Input 2): Direction Leg B (connect to Uno Pin 7).\n   - Pins 3 & 6 (Outputs 1 & 2): Connect directly to the two terminals of the DC motor."
      },
      {
        "stepId": "l12_s06",
        "title": "Coding Basics: Syntax & Control Structures",
        "type": "story",
        "markdownContent": "Direction Truth Table for L293D:\n- `IN1 = HIGH, IN2 = LOW`: Motor spins Forward.\n- `IN1 = LOW, IN2 = HIGH`: Motor spins Reverse.\n- `IN1 = IN2 (both LOW or both HIGH)`: Motor stops / active dynamic brake.\n- Speed is commanded by pulsing the Enable pin: `analogWrite(enablePin, speed)`."
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
        "markdownContent": "1. Wire the Potentiometer from Lesson 06 to `A0`.\n2. Map readings so:\n   - Full clockwise: Full speed forward.\n   - Center (512): Stopped.\n   - Full counter-clockwise: Full speed reverse.\n3. Test your custom robotic throttle control!"
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
        "markdownContent": "Test your mastery of the electrical, programming, and hardware concepts in this module.",
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
