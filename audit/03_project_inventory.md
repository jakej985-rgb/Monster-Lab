# 03 - Project Inventory

## 1. Overview

This document contains a comprehensive breakdown of all **14 robotics projects** found within the Monster kit archive (`Monster.zip`). Each project is detailed with its operational objective, documentation source, multi-phase code sketch progression, physical Bill of Materials (BOM), and required software libraries.

---

## 2. Master Projects Summary Table

| # | Project Name | Tier | Primary Sensor / Input | Primary Actuator / Output | Code Sketches | Libraries Used |
|---|---|---|---|---|---|---|
| **01** | **Intruder Alarm MONSTER** | Rookie (Beginner) | HC-SR04 Ultrasonic | Active Buzzer + LED | 3 sketches | `NewPing` |
| **02** | **Beat Detector MONSTER** | Rookie (Beginner) | KY-037 Sound Sensor | 5mm LED / NeoPixel | 3 sketches | Built-in |
| **03** | **Remote Control Funny Faces** | Builder (Intermediate) | IR Remote Control | MAX7219 8x8 LED Matrix | 3 sketches | `IRremote`, `LedControl` |
| **04** | **Smart MONSTER Door** | Builder (Intermediate) | 4x4 Membrane Keypad | SG90 Servo + Buzzer + LED | 3 sketches | `Keypad`, `Servo` |
| **05** | **MONSTER Alarm Clock** | Builder (Intermediate) | DS3231 RTC Module | 1602 I2C LCD + Buzzer | 3 sketches | `Wire`, `LiquidCrystal_I2C`, `DS3231` |
| **06** | **Gas Leak Detection and Warning** | Builder (Intermediate) | MQ-9 Gas Sensor | 1602 I2C LCD + Buzzer + LED | 5 sketches | `LiquidCrystal_I2C` |
| **07** | **MONSTER ATM & Food Dispenser** | Builder (Intermediate) | 4x4 Keypad | 1602 I2C LCD + SG90 Servo | 4 sketches | `Wire`, `Keypad`, `LiquidCrystal_I2C`, `Servo` |
| **08** | **Electric Motor Control MONSTER** | Engineer (Advanced) | PS2 Dual-Axis Joystick | 130 DC Motor + 28BYJ-48 Stepper | 4 sketches | `Stepper`, `Servo` |
| **09** | **RFID Smart Door MONSTER** | Engineer (Advanced) | RC522 RFID Reader | SG90 Servo + LED + Buzzer | 2 sketches | `SPI`, `MFRC522`, `Servo` |
| **10** | **Oil Drill Rig MONSTER** | Engineer (Advanced) | KY-040 Rotary Encoder | 1602 I2C LCD + 28BYJ-48 Stepper + Servo | 4 sketches | `LiquidCrystal_I2C`, `Servo`, `Stepper` |
| **11** | **Sentry Guard MONSTER** | Engineer (Advanced) | HC-SR04 Ultrasonic + KY-008 Laser | Pan-Tilt SG90 Servos + Buzzer + LCD | 4 sketches | `Servo`, `LiquidCrystal_I2C` |
| **12** | **Weather & Water Reservoir Station**| Engineer (Advanced) | DHT11 Temp/Humidity + Water Sensor + Rain Sensor | 1602 I2C LCD + SG90 Servo (Dam Gate) | 13 sketches (3 variants) | `LiquidCrystal_I2C`, `DHT`, `Servo` |
| **13** | **MONSTER Autopilot** | Monster Master | MPU-6050 6-Axis Gyro/Accel | 1602 I2C LCD + SG90 Servo + Stepper Motor | 3 sketches | `Wire`, `LiquidCrystal_I2C`, `Servo`, `Stepper`, `I2Cdev`, `MPU6050_6Axis_MotionApps20` |
| **14** | **NRF24L01 Wireless MONSTER** | Monster Master | Wireless Radio Packets (Joystick node) | SG90 Servo + LED (Receiver node) | 4 sketches (Transmitter/Receiver/Mega/Nano) | `SPI`, `nRF24L01`, `RF24`, `Servo` |

---

## 3. Individual Project Detailed Profiles

### Project 01: Intruder Alarm MONSTER
- **Folder**: `Projects/Intruder Alarm MONSTER/`
- **Documentation**: `Intruder Alarm MONSTER.pdf`
- **Concept**: A security scanner that measures target distance. When an intruder crosses the tripwire threshold (e.g. < 50cm), an alarm sounds.
- **Bill of Materials**: Arduino Uno, HC-SR04 Ultrasonic sensor, Active Buzzer, Red 5mm LED, 220Ω resistor, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Using_the_Ultrasonic_Sensor/`: Read raw distance values in centimeters to Serial Monitor.
  2. `Code/Activating_the_Buzzer/`: Introduce buzzer triggering logic based on distance thresholds.
  3. `Code/Final_Code/`: Integrate LED indicator, alarm frequency, and smooth distance threshold filtering.
- **Libraries**: `NewPing.h`

### Project 02: Beat Detector MONSTER
- **Folder**: `Projects/Beat Detector MONSTER/`
- **Documentation**: `Beat Detector MONSTER.pdf`
- **Concept**: Sound-reactive lighting system. Learns audio thresholding, background noise calibration, and visual pulse synthesis.
- **Bill of Materials**: Arduino Uno, KY-037 Sound detection sensor module, 5mm Red/Blue LEDs, 220Ω resistors, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Code_1_Reading_The_Microphone/`: Calibrate ambient acoustic levels with analog pin A0.
  2. `Code/Code_2_Adding_The_LED/`: Flash LED upon sound impulse exceeding digital threshold.
  3. `Code/Code_3_Final/`: Dynamic beat pulse smoothing and rhythm reaction.
- **Libraries**: Built-in standard functions (`analogRead`, `digitalWrite`).

### Project 03: Remote Control Funny Faces
- **Folder**: `Projects/Remote Control Funny Faces/`
- **Documentation**: `Remote Control Funny Faces.pdf`
- **Concept**: Interactive digital mood board. Kids press buttons on an IR remote to render animated facial expressions (happy, surprised, sad, wink) onto an 8x8 LED matrix.
- **Bill of Materials**: Arduino Uno, AX-1838HS IR receiver, IR remote control transmitter, MAX7219 8x8 Dot Matrix Module, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Source_Code_1/`: Decode infrared hex packet codes from remote buttons.
  2. `Code/Source_Code_2/`: Initialize MAX7219 and render custom bitmapped 8x8 byte arrays.
  3. `Code/Source_Code_3/`: Map specific remote buttons to switch different animated expressions.
- **Libraries**: `IRremote.h`, `LedControl.h`

### Project 04: Smart MONSTER Door
- **Folder**: `Projects/Smart MONSTER Door/`
- **Documentation**: `Smart MONSTER Door.pdf`
- **Concept**: Automated passcode-protected door lock. Learns keypad matrix decoding, state validation, and servo mechanical unlatching.
- **Bill of Materials**: Arduino Uno, 4x4 Membrane Keypad, TowerPro SG90 Servo, Active Buzzer, Green LED (access granted), Red LED (access denied), 220Ω resistors, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Source_Code_1/`: Poll keypad matrix and print pressed keys to Serial Monitor.
  2. `Code/Source_Code_2/`: Introduce password validation array and trigger servo door latch (90° open, 0° closed).
  3. `Code/Source_Code_3/`: Add audio beeps on keystroke, lockout delays for invalid attempts, and auto-close timer.
- **Libraries**: `Keypad.h`, `Servo.h`

### Project 05: MONSTER Alarm Clock
- **Folder**: `Projects/MONSTER Alarm Clock/`
- **Documentation**: `WAKE UP MONSTER Alarm Clock.pdf`
- **Concept**: Programmable digital desk clock. Reads battery-backed hardware time over I2C, displays clock and date on LCD, and fires a buzzer alarm when set time matches current time.
- **Bill of Materials**: Arduino Uno, DS3231 RTC Module with CR2032 coin cell, 1602 LCD with I2C backpack, Active Buzzer, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Source_Code_1/`: Configure and set initial RTC timestamp; read live time into Serial Monitor.
  2. `Code/Source_Code_2/`: Format time (`HH:MM:SS`) and date strings onto the 1602 I2C LCD screen.
  3. `Code/Source_Code_3/`: Implement alarm comparison logic and activate buzzer cadence when triggered.
- **Libraries**: `Wire.h`, `LiquidCrystal_I2C.h`, `DS3231.h`

### Project 06: Gas Leak Detection and Warning MONSTER
- **Folder**: `Projects/Gas Leak Detection and Warning MONSTER/`
- **Documentation**: `Gas Leak Detection and Warning MONSTER.pdf`
- **Concept**: Industrial environmental safety monitor. Samples air quality, warns when gas levels rise, and displays PPM status on LCD.
- **Bill of Materials**: Arduino Uno, MQ-9 Combustible Gas sensor, 1602 LCD with I2C backpack, Active Buzzer, Red & Green LEDs, 220Ω resistors, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Detecting_Gas_MQ9/`: Sensor burn-in calibration and raw analog voltage reading.
  2. `Code/Working_with_LCD/`: Initialize and display fixed UI labels on I2C LCD.
  3. `Code/Working_with_LED/`: Drive status LEDs based on gas danger thresholds.
  4. `Code/Controlling_the_Buzzer/`: Sound pulsing alert sirens when toxic thresholds are exceeded.
  5. `Code/Gas_Detector_Final/`: Complete integrated industrial alarm monitor.
- **Libraries**: `LiquidCrystal_I2C.h`

### Project 07: MONSTER ATM and Food Dispenser
- **Folder**: `Projects/MONSTER ATM and Food Dispenser/`
- **Documentation**: `MONSTER ATM and Food Dispenser.pdf`
- **Concept**: Interactive vending / banking terminal. Learns transactional UI states (PIN entry, balance check, snack selection, servo gate dispensation).
- **Bill of Materials**: Arduino Uno, 4x4 Keypad, 1602 LCD with I2C backpack, SG90 Servo motor, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Source_Code_1/`: Keypad input validation and numeric PIN entry.
  2. `Code/Source_Code_2/`: LCD menu rendering ("Enter PIN", "Select Item", "Dispensing").
  3. `Code/Source_Code_3/`: Servo mechanical dispenser release and auto-relock sequence.
  4. `Code/Source_Code_Food_Extra/`: Multi-item selection menu with inventory counting.
- **Libraries**: `Keypad.h`, `LiquidCrystal_I2C.h`, `Wire.h`, `Servo.h`

### Project 08: Electric Motor Control MONSTER
- **Folder**: `Projects/Electric Motor Control MONSTER/`
- **Documentation**: `Electric Motor Control Monster.pdf`
- **Concept**: Comprehensive motor driving lab. Explores the differences between DC hobby motors (continuous high-speed rotation) and Stepper motors (discrete precise angular steps).
- **Bill of Materials**: Arduino Uno, PS2 Analog Joystick, 130 DC Motor, PN2222/L293D motor driver, 1N4007 flyback diode, 28BYJ-48 Stepper motor + ULN2003 driver, External power module, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Detecting_joystick/`: Read analog X and Y potentiometer coordinates from joystick.
  2. `Code/Controlling_DCMotor/`: Map joystick Y-axis to PWM duty cycle for speed control.
  3. `Code/Working_with_StepperMotor/`: Sequence 4-step Darlington phases on ULN2003 to rotate stepper motor.
  4. `Code/Final_code/`: Dual-motor control console: Joystick X controls stepper angle; Joystick Y controls DC motor throttle.
- **Libraries**: `Stepper.h`, `Servo.h`

### Project 09: RFID Smart Door MONSTER
- **Folder**: `Projects/RFID Smart Door MONSTER/`
- **Documentation**: `RFID Smart Door MONSTER.pdf`, `RFID Smart Door MONSTER.docx`
- **Concept**: Contactless RFID security gateway. Reads 13.56MHz Mifare RFID cards/keyfobs via SPI; authenticates UID against stored authorized whitelist; triggers motorized lock.
- **Bill of Materials**: Arduino Uno, RC522 (MFRC522) RFID Module, Mifare RFID Card & Keyfob, SG90 Servo, Green LED, Red LED, Active Buzzer, 220Ω resistors, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Using_the_RFID/`: Initialize SPI bus, read tag UID, and print hex address to Serial.
  2. `Code/Final_Code/`: Compare scanned UID with allowed master keys; activate servo latch and buzzer tone.
- **Libraries**: `SPI.h`, `MFRC522.h`, `Servo.h`

### Project 10: Oil Drill Rig MONSTER
- **Folder**: `Projects/Oil Drill Rig MONSTER/`
- **Documentation**: `Oil Drill Rig MONSTER.pdf`
- **Concept**: Industrial simulation of an automated drill rig. Learns quadrature rotary encoder inputs, interactive rotary menus on LCD, and multi-actuator positioning (stepper drill head + servo arm).
- **Bill of Materials**: Arduino Uno, KY-040 Rotary Encoder with push switch, 1602 LCD with I2C backpack, 28BYJ-48 Stepper Motor + ULN2003 Driver, SG90 Servo, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Rotary_Encoder/`: Track clockwise/counterclockwise rotational detents and pushbutton clicks.
  2. `Code/Adding_the_LCD/`: Render interactive menu options selectable via rotary dial.
  3. `Code/Adding_the_Menu/`: Menu navigation engine for drill speed and depth settings.
  4. `Code/Adding_the_Actuators/`: Full simulation: Stepper motor lowers drill pipe, servo controls mud valve, LCD reports live operational telemetry.
- **Libraries**: `LiquidCrystal_I2C.h`, `Stepper.h`, `Servo.h`

### Project 11: Sentry Guard MONSTER
- **Folder**: `Projects/Sentry Guard MONSTER/`
- **Documentation**: `Sentry Guard MONSTER.pdf`
- **Concept**: Autonomous security defense turret. A servo motor pans an ultrasonic radar back and forth. When a target enters the scan cone, the turret locks onto the intruder, fires a targeting laser, sounds an alert, and displays radar distance on LCD.
- **3D Printed & Mechanical Assets**:
  - `3D Printed Files/sentryBase.stl`
  - `3D Printed Files/sentryLaser.stl`
  - `3D Printed Files/sentrySonar.stl`
  - 7 Assembly photographs for servo brackets
- **Bill of Materials**: Arduino Uno, SG90 Servo (radar pan), HC-SR04 Ultrasonic sensor, KY-008 Laser Diode module, Active Buzzer, 1602 LCD with I2C backpack, Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Obstacle_Detection_and_Servo/`: Radar sweep loop (0° to 180° pan) taking distance readings.
  2. `Code/Adding_the_Laser_and_Buzzer/`: Add targeting laser strobe and audio warning upon target detection.
  3. `Code/Adding_the_LCD/`: Display target coordinates (Angle and Distance in cm) on LCD.
  4. `Code/Final_Code/`: Complete automated tracking sentry turret routine.
- **Libraries**: `Servo.h`, `LiquidCrystal_I2C.h`

### Project 12: Weather and Water Reservoir Station
- **Folder**: `Projects/Weather and Water Reservoir Station/`
- **Documentation**:
  - `Weather and Water Reservoir Station - Analog.pdf`
  - `Weather and Water Reservoir Station - Digital.pdf`
  - `Weather and Water Reservoir Station - Advanced.pdf`
- **Concept**: Smart municipal environmental monitoring and automated flood control reservoir. Samples rain levels, water depth, temperature, and humidity; automatically opens reservoir floodgates (servo) when water rises dangerously.
- **Bill of Materials**: Arduino Uno, DHT11 Temp/Humidity sensor, Rain sensor board (FC-37/YL-83), Water level depth sensor, 1602 LCD with I2C backpack, SG90 Servo (Floodgate), LEDs, Buzzer, Breadboard, Jumper wires.
- **Three Variant Implementations & Code Progression (13 Sketches Total)**:
  - **Analog Branch** (`Code Analog/`):
    - `Source_Code_Analog_1`: DHT11 temperature and humidity reporting to LCD.
    - `Source_Code_Analog_2`: Read rain plate analog resistance.
    - `Source_Code_Analog_3`: Combine rain sensing with servo floodgate valve open/close.
    - `Source_Code_Analog_4`: Full weather station with temperature, humidity, and analog rain intensity.
  - **Digital Branch** (`Code Digital/`):
    - `Source_Code_Digital_1`: DHT11 readings.
    - `Source_Code_Digital_2`: Digital threshold comparator reading from rain sensor module.
    - `Source_Code_Digital_3`: Dual sensor alert display.
    - `Source_Code_Digital_4`: Digital trigger automated floodgate opening.
  - **Advanced Branch** (`Code Advanced/`):
    - `Source_Code_Advanced_1` through `5`: Multi-screen LCD telemetry cycling (Screen 1: Weather, Screen 2: Reservoir Water Level, Screen 3: Sluice Gate Position), with alarm buzzer and safety interlocks.
- **Libraries**: `LiquidCrystal_I2C.h`, `DHT.h`, `Servo.h`

### Project 13: MONSTER Autopilot
- **Folder**: `Projects/MONSTER Autopilot/`
- **Documentation**: `MONSTER Autopilot.pdf`
- **Concept**: Flight control system simulation. Reads pitch and roll angular velocity and tilt angles from a 6-axis IMU (MPU-6050); adjusts aircraft elevator wing flap (servo) and rudder trim (stepper) to maintain stable artificial horizon.
- **Bill of Materials**: Arduino Uno, MPU-6050 (GY-521) 6-Axis Gyro & Accelerometer, 1602 LCD with I2C backpack, SG90 Servo (Flap elevator), 28BYJ-48 Stepper Motor + ULN2003 Driver (Rudder trim), Breadboard, Jumper wires.
- **Code Progression**:
  1. `Code/Source_Code__1/`: Digital Motion Processor (DMP) calibration and quaternion pitch/roll extraction.
  2. `Code/Source_Code__2/`: Flight surface actuation (Servo tilts inverse to pitch angle; stepper adjusts yaw).
  3. `Code/Source_Code__3_Extra/`: Complete cockpit instrument panel on LCD (Pitch °, Roll °, Autopilot Status: ENGAGED/DISENGAGED).
- **Libraries**: `Wire.h`, `LiquidCrystal_I2C.h`, `Servo.h`, `Stepper.h`, `I2Cdev.h`, `MPU6050_6Axis_MotionApps20.h`

### Project 14: NRF24L01 Wireless MONSTER
- **Folder**: `Projects/NRF24L01 Wireless MONSTER/`
- **Documentation**: `NRF24L01 Wireless MONSTER.pdf`, `NRF24L01 Wireless MONSTER.docx`
- **Concept**: True multi-node wireless robotics link. Node A (Remote Controller) packages joystick/sensor readings into 32-byte 2.4GHz radio packets; Node B (Receiver Robot) receives radio packets over SPI and executes motor/servo maneuvers.
- **Bill of Materials**: Arduino Uno, Arduino Nano or Mega, 2x NRF24L01+ 2.4GHz Wireless Transceiver modules, 10μF filter capacitors, SG90 Servo, PS2 Joystick or Potentiometer, 2x Breadboards, Jumper wires.
- **Code Progression**:
  1. `Code/Code_1_Transmitter/`: Initialize SPI radio pipe, format binary payload, transmit packet with auto-acknowledgment.
  2. `Code/Code_2_Receiver/`: Listen on radio pipe, verify CRC, extract payload, drive servo angle based on received data.
  3. `Code/Code_3_Mega/`: Arduino Mega pinout adaptation for expanded wireless telemetry.
  4. `Code/Code_4_Nano/`: Arduino Nano compact remote controller implementation.
- **Libraries**: `SPI.h`, `nRF24L01.h`, `RF24.h`, `Servo.h`
