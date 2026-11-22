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
import sys
sys.path.insert(0, str(Path(__file__).resolve().parent))
from compile_expanded_lessons import compile_all_lessons

LESSONS = compile_all_lessons()

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
     "Button.pdf", "restrictedAdultSupervision",
     ["Direct eye exposure to laser beam can cause retinal injury"],
     "Never look directly into laser aperture; use target reflective paper only",
     True, ["proj_11", "proj_16"]),

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
