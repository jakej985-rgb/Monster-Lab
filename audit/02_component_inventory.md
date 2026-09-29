# 02 - Component Inventory

## 1. Overview

This document provides a verified, complete inventory of every electronic and mechanical component contained in the Monster kit archive. It details all **38 primary peripherals**, the **49 associated datasheets**, and the supporting **discrete electronic components**.

---

## 2. 38 Peripherals Inventory

Each peripheral has been cross-referenced with its corresponding guide in `Tutorials/`, datasheet in `Datasheets/`, pinouts, operational voltages, and projects.

| # | Peripheral Name | Common Part / Module ID | Signal / Interface Type | Pinout | Op. Voltage | Associated Datasheet | Used in Projects |
|---|---|---|---|---|---|---|---|
| **01** | Ultrasonic Sensor | HC-SR04 | Digital Pulse (Timing) | VCC, TRIG, ECHO, GND | 5V | `hc-sr04_ultrasonic_module_user_guidejohn .pdf` | Intruder Alarm, Sentry Guard |
| **02** | Sound Detection Sensor | KY-037 / LM358 | Analog Out + Digital Out | VCC, GND, D0, A0 | 3.3V - 5V | `Arduino KY-037 Sensitive microphone sensor module.pdf` | Beat Detector |
| **03** | PIR Motion Sensor | HC-SR501 | Digital Output (High/Low) | VCC, OUT, GND | 4.5V - 12V (Regulated 3.3V logic) | `HC-SR501.pdf` | Intruder Alarm variant |
| **04** | Impact Switch Sensor | Crash / Collision Switch | Digital Output (Normally Open) | VCC, OUT, GND | 3.3V - 5V | `Button.pdf` | Autopilot crash detection |
| **05** | Photo Interrupter Sensor | Photogate (Slotted Optocoupler) | Digital Output | VCC, OUT, GND | 3.3V - 5V | `CDS-55 Photoresistor.pdf` | Speed / RPM tachometer |
| **06** | 4x4 Keypad Matrix | 16-Key Membrane Keypad | Digital Matrix Scanning (8 GPIO) | R1, R2, R3, R4, C1, C2, C3, C4 | 3.3V - 5V | `4x4-Matrix-Membrane-Keypad.pdf` | Smart Door, ATM & Food Dispenser |
| **07** | 1602 LCD with I2C | LCD1602 + PCF8574 Backpack | I2C Protocol (Addr 0x27 / 0x3F) | GND, VCC, SDA (A4), SCL (A5) | 5V | `1602 I2C LCD.pdf`, `LCD1602A.pdf` | Gas Leak, Autopilot, Alarm Clock, Sentry Guard, Oil Drill, ATM, Weather Station |
| **08** | Barometric Pressure Sensor | BMP180 (GY-68) | I2C Protocol (Addr 0x77) | VCC, GND, SCL, SDA | 3.3V - 5V (Onboard LDO) | `RM-MPU-6050A.pdf` (I2C reference) | Weather Station variant |
| **09** | Temperature & Humidity Sensor | DHT11 Module | Single-Wire Digital Serial | VCC, DATA, NC, GND | 3.3V - 5.5V | `DHT11 .pdf` | Weather Station (Analog/Digital/Advanced) |
| **10** | Real Time Clock (RTC) | DS3231 High Precision RTC | I2C Protocol (Addr 0x68) | 32K, SQW, SCL, SDA, VCC, GND | 3.3V - 5.5V | `DS3231.pdf` | Monster Alarm Clock |
| **11** | IR Flame Sensor | 760nm - 1100nm Phototransistor | Digital Out + Analog Out | VCC, GND, D0, A0 | 3.3V - 5V | `IR-Receiver-AX-1838HS .pdf` | Sentry Guard / Safety monitors |
| **12** | 6-Axis Gyro & Accelerometer | MPU-6050 (GY-521) | I2C Protocol (Addr 0x68 / 0x69) | VCC, GND, SCL, SDA, XDA, XCL, AD0, INT | 3.3V - 5V | `RM-MPU-6050A.pdf` | Monster Autopilot |
| **13** | IR Remote Control & Receiver | NEC Format IR / AX-1838HS | Digital Pulse (38 kHz) | VCC, GND, IN (Receiver) | 3.3V - 5V | `IR Remote Control.pdf`, `IR-Receiver-AX-1838HS .pdf` | Remote Control Funny Faces |
| **14** | Line Tracking Sensor | TCRT5000 Infrared Reflective | Digital Out + Analog Out | VCC, GND, OUT | 3.3V - 5V | `IR-Receiver-AX-1838HS .pdf` | Robotics navigation |
| **15** | LED Matrix Display | MAX7219 8x8 Dot Matrix | SPI-like 3-Wire Serial | VCC, GND, DIN, CS, CLK | 5V | `MAX7219 8x8 Matrix Display Module.pdf` | Remote Control Funny Faces |
| **16** | Alcohol Gas Sensor | MQ-3 | Analog In (Heating Element) | VCC, GND, D0, A0 | 5V (High Current ~150mA) | `MQ3 Alcohol Sensor` (Quickstart ref) | Lab testing (Restricted handling) |
| **17** | Combustible Gas / CO Sensor | MQ-9 | Analog In + Digital Out | VCC, GND, D0, A0 | 5V (Heater ~150mA) | `MQ9 Combustible Gas` (Quickstart ref) | Gas Leak Detection and Warning |
| **18** | IR Obstacle Detection Sensor | Active Infrared Distance Switch | Digital Output | VCC, GND, OUT | 3.3V - 5V | `IR-Receiver-AX-1838HS .pdf` | Autopilot, Sentry Guard |
| **19** | Photoresistor (LDR) | CDS-55 Light Dependent Resistor | Analog In (Voltage Divider) | 2 Pins (Non-polar) | 0V - 5V | `CDS-55 Photoresistor.pdf` | Light sensing / Weather station |
| **20** | Potentiometer | 10kΩ Rotary Potentiometer | Analog Voltage Output | Pin 1 (5V), Pin 2 (Wiper/A0), Pin 3 (GND) | 0V - 5V | `Potentiometers.pdf` | Lesson 6, Motor speed tuning |
| **21** | PS2 Joystick Module | Dual Potentiometer + Switch | Analog X, Analog Y, Digital Key | GND, +5V, VRx, VRy, SW | 5V | `JOYSTICK MODULE.pdf` | Electric Motor Control |
| **22** | Rain Sensor Board | FC-37 / YL-83 Moisture Plate | Analog In + Digital Out | VCC, GND, D0, A0 | 3.3V - 5V | `Water Level Sensor.pdf` | Weather Station (Analog & Digital) |
| **23** | RFID Reader / Writer Kit | RC522 (MFRC522) + Tag & Card | SPI Protocol | 3.3V, RST, GND, MISO, MOSI, SCK, NSS | **3.3V ONLY** | `MFRC522 Datasheet.pdf`, `MF1S50YYX_V1.pdf` | RFID Smart Door |
| **24** | Rotary Encoder | KY-040 Quadrature Encoder | Digital Pulses (Phase A/B + Switch) | GND, +, SW, DT, CLK | 5V | `Rotary Encoder module.pdf` | Oil Drill Rig |
| **25** | Micro Servo Motor | TowerPro SG90 (9g) | PWM Position Control (50Hz) | Brown (GND), Red (VCC), Orange (Signal) | 4.8V - 6V | `Servo SG90.pdf` | Smart Door, Autopilot, Sentry Guard, RFID Door, ATM, Weather Station |
| **26** | Soil Moisture Sensor | Dual Probe Resistive Sensor | Analog In + Digital Out | VCC, GND, D0, A0 | 3.3V - 5V | `Water Level Sensor.pdf` | Automated watering experiments |
| **27** | Stepper Motor & Driver | 28BYJ-48 5V + ULN2003 Driver | 4-Phase Digital Stepping | 5V, GND, IN1, IN2, IN3, IN4 | 5V DC | `28BYJ-48 Stepper Motor.pdf`, `ULN2003A.pdf` | Electric Motor Control, Oil Drill Rig, Autopilot |
| **28** | Vibration Sensor | SW-420 High Sensitivity Switch | Digital Out (Normally Closed) | VCC, GND, DO | 3.3V - 5V | `Tilt Switch.pdf` | Security alarms, Earthquake detection |
| **29** | Bluetooth Module | HC-05 (UART Serial Transceiver) | UART Serial (38400 / 9600 baud) | VCC, GND, TXD, RXD, STATE, EN | 3.6V - 6V (RX needs 3.3V level) | `IR-Receiver-AX-1838HS .pdf` (Wireless ref) | Wireless robotics link |
| **30** | Ethernet Shield | W5100 SPI Ethernet Controller | SPI Protocol + ICSP header | Stackable Arduino Shield | 5V | `UNO Proto Shield Expansion Board.pdf` | IoT web server experiments |
| **31** | Wireless Transceiver | NRF24L01+ 2.4GHz Module | SPI Protocol + CE/CSN | VCC (**3.3V ONLY**), GND, CSN, CE, SCK, MOSI, MISO, IRQ | **3.3V ONLY** | `RM-MPU-6050A.pdf` (SPI ref) | NRF24L01 Wireless MONSTER |
| **32** | 7-Segment Display | 1-Digit & 4-Digit Display | Parallel / Shift Register Driven | Common Cathode / Anode pins | 2V - 5V (Via Resistor) | `1 digit 7-segment Display .pdf`, `4 digit 7-segment Display .PDF` | Digital counter experiments |
| **33** | DC Motor | 130 Hobby DC Toy Motor | Direct DC / PWM via Driver | 2 Terminals (+ / -) | 3V - 6V (High Current) | `130 DC Motor.pdf`, `L293d .pdf` | Electric Motor Control |
| **34** | Piezo Buzzer | Active Buzzer & Passive Buzzer | Digital DC (Active) / PWM Tone (Passive) | VCC (+), GND (-) | 3.3V - 5V | `Active buzzer.pdf`, `Passive buzzer.pdf` | Intruder Alarm, Smart Door, Gas Leak, Sentry Guard, Alarm Clock |
| **35** | Water Level Sensor | 10-Trace Resistive Depth Probe | Analog Output (Variable Resistance) | +, -, S (Signal to A0) | 3.3V - 5V | `Water Level Sensor.pdf` | Weather and Water Reservoir Station |
| **36** | Relay Module | 1-Channel 5V Relay with Optocoupler | Digital Trigger (Active LOW/HIGH) | VCC, GND, IN (Relay Out: COM, NO, NC) | 5V (Coil current ~70mA) | `5V Relay.pdf` | High-current DC switching (Restricted) |
| **37** | Laser Diode Module | KY-008 650nm Red Laser Diode | Digital Output (HIGH = On) | Signal (S), -, Middle (NC) | 5V (<30mA) | `Button.pdf` (Opto ref) | Sentry Guard MONSTER |
| **38** | Hall Effect Sensor | 3144 / A3144 Magnetic Sensor | Digital Output (Magnetic field detected) | VCC, GND, OUT | 4.5V - 24V | `Button.pdf` (Switch ref) | RPM counting, Door open detection |

---

## 3. Microcontrollers & Expansion Hardware

| Hardware Name | Description / Specifications | Role in Monster Lab |
|---|---|---|
| **Arduino UNO R3** | ATmega328P, 16MHz, 14 Digital I/O (6 PWM), 6 Analog In, USB-B interface | Core primary prototyping platform used in all 14 projects |
| **Arduino Nano V3** | ATmega328P, Mini-USB, compact breadboard form factor | Secondary node used in NRF24L01 Wireless project |
| **Arduino Mega 2560** | ATmega2560, 54 Digital I/O, 16 Analog In, 4 UART ports | Extended node used in complex multi-device projects |
| **UNO Proto Shield** | Prototype expansion board with mini breadboard and reset button | Permanent breadboard-free circuit soldering/testing |
| **Breadboard 830 Points** | Full-size solderless breadboard with dual power distribution rails | Main circuit assembly area for all guided builds |
| **Breadboard 430 Points** | Half-size solderless breadboard | Auxiliary circuit prototyping for dual-node builds |
| **MB-102 Power Module** | Breadboard power supply module, 6.5V-12V input, selectable 3.3V / 5V rails | Dedicated clean power for high-current servos and motors |
| **9V 1A DC Adapter** | Wall power supply with 2.1mm center-positive barrel jack | Standalone operation without computer USB |
| **9V Battery Clip** | 9V snap connector to 2.1mm DC barrel plug | Portable wireless robotics power |

---

## 4. Discrete Electronics & Integrated Circuits

| Component Group | Part ID / Specifications | Quantity / Description | Key Function |
|---|---|---|---|
| **Resistors** | 1/4W 1% Metal Film | 220Ω, 1kΩ, 10kΩ, 100kΩ assortments | Current limiting for LEDs, pull-up/pull-down networks, voltage dividers |
| **Capacitors (Ceramic)** | 22pF, 104 (0.1μF) 50V | High frequency noise decoupling | Smoothing digital sensor noise (e.g. NRF24L01 power rail) |
| **Capacitors (Electrolytic)**| 10μF, 100μF 16V-50V | Low frequency bulk power filtering | Absorbing servo/motor sudden current draw surges |
| **Rectifier Diode** | 1N4007 (1000V 1A) | Flyback / freewheeling protection | Absorbing inductive voltage spikes when DC motors/relays shut off |
| **NPN Transistors** | PN2222, S8050 (TO-92) | Bipolar Junction Transistors | Low-side switching to drive DC motors and buzzers exceeding 20mA |
| **Shift Register IC** | 74HC595 (DIP-16) | 8-bit Serial-In Parallel-Out | Expands 3 Arduino pins into 8 digital outputs (used for 7-segment displays) |
| **Dual H-Bridge IC** | L293D (DIP-16) | Dual full-bridge motor driver | Bidirectional DC motor speed and direction control |
| **Darlington Driver IC** | ULN2003A (DIP-16) | 7-channel Darlington transistor array | High-voltage, high-current driver for 28BYJ-48 stepper motor coils |
| **LEDs (Standard)** | 5mm Diffused (Red, Green, Blue, Yellow, White)| High-brightness visual indicators | Logic status, user feedback, and circuit debugging |
| **RGB LED** | 5mm Common Cathode (4 pins) | Red, Green, Blue in single housing | Color mixing, status alarms (Green = Safe, Red = Alert) |
| **Tactile Buttons** | 6x6mm momentary switches with color caps | User input triggers | UI control, reset buttons, password entry |
| **Tilt Switch** | Ball tilt mechanical switch | Gravity-based orientation switch | Tilt alarm and motion detection |
| **NTC Thermistor** | MF52-103 (10kΩ NTC) | Negative temperature coefficient resistor | Analog temperature monitoring |
| **Jumpers & Wires** | M-M, M-F, F-F 20cm Dupont ribbons | 65+ flexible breadboard jumpers | Solderless component interconnection |
