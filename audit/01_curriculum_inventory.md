# 01 - Curriculum Inventory

## 1. Overview

This document provides a complete inventory of the educational tutorials, documentation, and reference materials provided within the Monster kit archive. It categorizes the curriculum into structured learning tiers and outlines the core conceptual objectives for each lesson.

---

## 2. Foundational Lessons Inventory

The archive contains 7 foundational lesson documents located in `Tutorials/`. These establish the baseline knowledge required before interacting with sensors or actuators.

| Lesson | Title | Core Concepts | Hardware / Software Used | Learning Outcome |
|---|---|---|---|---|
| **Lesson 1** | What is Arduino and how does it work | Microcontrollers vs computers, inputs/processing/outputs, USB interface, power pins | Arduino Uno / Nano / Mega | Understand board structure, power sources, and the role of the ATmega microcontroller. |
| **Lesson 2** | Installing the Arduino IDE | IDE installation, CH340 USB drivers, port configuration | Arduino IDE 1.x/2.x, CH340G Driver | Install development tools, detect COM/Serial ports, and establish computer-to-board link. |
| **Lesson 3** | Installing Libraries | Software modularity, Library Manager, `.zip` library imports, `#include` statements | Arduino IDE, LiquidCrystal_I2C, NewPing, Servo | Learn how open-source libraries simplify complex communication protocols. |
| **Lesson 4** | Basics of the Arduino IDE | Sketch anatomy (`setup()` and `loop()`), Verify (Compile), Upload, Serial Monitor baud rates | Arduino IDE, Serial Monitor | Understand execution flow, syntax error checking, and real-time serial debugging. |
| **Lesson 5** | Blink (Building Your First Project) | Digital outputs, logic HIGH/LOW (5V/0V), clock timing with `delay()`, pin 13 built-in LED | Arduino Uno, Onboard LED | Write, compile, and upload first sketch. Observe immediate physical feedback. |
| **Lesson 6** | Potentiometer Readings | Analog signals vs digital signals, voltage divider principle, 10-bit ADC (0 to 1023), `analogRead()` | Potentiometer, Breadboard, Jumper wires | Convert variable physical resistance into numeric digital values. Print values to Serial Monitor. |
| **Lesson 7** | Simple RGB LEDs | Additive color theory (RGB), Pulse Width Modulation (PWM), 8-bit duty cycle (0 to 255), `analogWrite()` | RGB LED (Common Cathode), Current-limiting Resistors (220Ω), Breadboard | Control LED brightness and mix primary colors to generate custom hues. |

---

## 3. Curriculum Tiers & Material Segmentation

To prevent cognitive overload in young learners, the curriculum is separated into three progressive tiers:

### Tier 1: Rookie (Beginner)
- **Focus**: Physical intuition, safety, basic electricity, simple digital/analog I/O.
- **Concepts**: Closed circuits, grounds, current limiting, digital HIGH/LOW, analog reading, basic time delays.
- **Hardware**: LEDs, pushbuttons, passive/active buzzers, potentiometers, tilt switches, light-dependent resistors (LDR/photoresistor).
- **Milestone Project**: Intruder Alarm (Simple buzzer + sensor trigger), Beat Detector (Microphone + LED reaction).

### Tier 2: Builder (Intermediate)
- **Focus**: Communication buses (I2C), multi-component state coordination, mechanical actuation.
- **Concepts**: Character displays, angles and rotation, matrix scanning, threshold calibration, PWM motor speed control.
- **Hardware**: 1602 LCD with I2C backpack, SG90 Servo motor, 4x4 Membrane Keypad, Sound sensor, Ultrasonic sensor, DHT11 temp/humidity, Infrared remote control, MAX7219 8x8 LED matrix.
- **Milestone Project**: Smart Monster Door (Keypad + Servo + Buzzer), Monster Alarm Clock (RTC + LCD + Buzzer), Remote Control Funny Faces (IR + Matrix).

### Tier 3: Engineer & Monster Master (Advanced)
- **Focus**: Complex protocols (SPI, UART), multi-degree kinematics, wireless packet transmission, multi-sensor telemetry.
- **Concepts**: Radio packets, master-slave communication, interrupt-driven rotary encoding, 6-axis IMU pitch/roll calculations, stepper step-sequencing.
- **Hardware**: NRF24L01+ Transceiver, RC522 RFID reader/writer, MPU-6050 6-Axis Gyro/Accelerometer, 28BYJ-48 Stepper motor + ULN2003 driver, Rotary encoder, W5100 Ethernet shield.
- **Milestone Project**: Monster Autopilot (IMU + Stepper + Servo), Oil Drill Rig (Rotary encoder + LCD + Stepper), NRF24L01 Wireless Link (Dual-node communication).

---

## 4. Documentation & Reference Material Inventory

### 4.1 Monster Quick Start Operational Manual
- **File**: `Monster Quick Start File.pdf` (GAR MOM – 880825-00 REV. 1)
- **Contents**: Unboxing checklist, driver links (CH340), troubleshooting COM port issues, Paul McWhorter tutorial links, and component reference index with external tutorial links.

### 4.2 Comprehensive Project Manuals
- **Files**: 14 Project Guides (`Projects/*/*.pdf` and `.docx`).
- **Structure**: Each guide contains a component bill of materials (BOM), step-by-step breadboard wiring schematics, and code walkthroughs divided into sequential phases.

### 4.3 Reference eBooks & Supplementary Archive
- **Directory**: `Free eBooks and Resources/eBooks/` (221 files)
- **Notable Volumes**:
  - *Arduino Programming Notebook* by Brian Evans (concise syntax syntax reference).
  - *18 Arduino Projects eBook* & *Home Automation Using ESP8266* by Rui Santos.
  - *Arduino Projects For Dummies* & *Arduino-For-Beginners-REV2*.
  - *GAR 1000 Robots in Industry.pdf* (Historical and modern industrial automation background).
