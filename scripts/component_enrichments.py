"""
Monster Lab Component Enrichments.
Contains wiring guidance, common mistakes, and zero-wire mini experiments
for all 38 peripherals.
"""

COMPONENT_ENRICHMENTS = {
    1: {
        "wiringGuidance": "Connect VCC (Red wire) to 5V power rail, GND (Dark Slate wire) to GND. Connect TRIG (Green wire) to digital pin 9 and ECHO (Green wire) to digital pin 10.",
        "commonMistakes": [
            "Swapping TRIG and ECHO pins will result in continuous 0cm readings.",
            "Powering HC-SR04 with 3.3V causes erratic or missing distance pings—it requires a full 5V supply."
        ],
        "miniExperiment": {
            "title": "Ultrasonic Ping Ruler",
            "circuit": "VCC to 5V (Red), GND to GND (Dark Slate), TRIG to Pin 9 (Green), ECHO to Pin 10 (Green).",
            "code": "const int trigPin = 9;\nconst int echoPin = 10;\n\nvoid setup() {\n  Serial.begin(9600);\n  pinMode(trigPin, OUTPUT);\n  pinMode(echoPin, INPUT);\n}\n\nvoid loop() {\n  digitalWrite(trigPin, LOW);\n  delayMicroseconds(2);\n  digitalWrite(trigPin, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(trigPin, LOW);\n  long duration = pulseIn(echoPin, HIGH);\n  int distanceCm = duration * 0.034 / 2;\n  Serial.print(\"Distance: \");\n  Serial.print(distanceCm);\n  Serial.println(\" cm\");\n  delay(200);\n}",
            "expectedOutput": "Distance in centimeters printed in Serial Monitor (e.g. 'Distance: 18 cm'). Move your hand closer to see the number decrease."
        }
    },
    2: {
        "wiringGuidance": "Connect VCC (Red wire) to 5V, GND (Dark Slate wire) to GND. Connect A0 (Yellow wire) to analog pin A0 and D0 (Green wire) to digital pin 2.",
        "commonMistakes": [
            "Leaving the onboard blue potentiometer unadjusted—turn it until the onboard LED just turns off in quiet room noise.",
            "Using digital pin D0 instead of analog pin A0 when trying to measure gradual acoustic volume."
        ],
        "miniExperiment": {
            "title": "Clap & Noise Visualizer",
            "circuit": "VCC to 5V, GND to GND, A0 to Analog Pin A0.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int soundLevel = analogRead(A0);\n  Serial.print(\"Sound Level: \");\n  Serial.println(soundLevel);\n  delay(50);\n}",
            "expectedOutput": "A steady stream of values around 500-600. Clapping near the mic causes sharp spikes above 750."
        }
    },
    3: {
        "wiringGuidance": "Connect VCC (Red wire) to 5V, GND (Dark Slate wire) to GND, and OUT (Green wire) to digital pin 2.",
        "commonMistakes": [
            "Testing immediately after power-up—PIR sensors require a 30 to 60-second warm-up calibration cycle.",
            "Confusing the time delay and sensitivity trim potentiometers on the board."
        ],
        "miniExperiment": {
            "title": "Motion Sentry Alarm",
            "circuit": "VCC to 5V, GND to GND, OUT to Pin 2.",
            "code": "const int motionPin = 2;\nconst int ledPin = 13;\n\nvoid setup() {\n  pinMode(motionPin, INPUT);\n  pinMode(ledPin, OUTPUT);\n  Serial.begin(9600);\n  Serial.println(\"Warming up sensor for 10s...\");\n  delay(10000);\n  Serial.println(\"Sentry Armed!\");\n}\n\nvoid loop() {\n  int motion = digitalRead(motionPin);\n  if (motion == HIGH) {\n    digitalWrite(ledPin, HIGH);\n    Serial.println(\"MOTION DETECTED!\");\n  } else {\n    digitalWrite(ledPin, LOW);\n  }\n  delay(100);\n}",
            "expectedOutput": "Pin 13 LED turns ON and Serial prints 'MOTION DETECTED!' whenever a person moves in front of the Fresnel lens."
        }
    },
    4: {
        "wiringGuidance": "Connect one terminal to GND (Dark Slate wire) and the NO terminal to digital pin 3 (Green wire). Use Arduino internal pull-up resistor.",
        "commonMistakes": [
            "Forgetting to enable INPUT_PULLUP in code, resulting in erratic floating values.",
            "Connecting to NC (Normally Closed) instead of NO (Normally Open), reversing switch logic."
        ],
        "miniExperiment": {
            "title": "Bumper Impact Trigger",
            "circuit": "Connect Common to GND, NO to Digital Pin 3.",
            "code": "const int bumperPin = 3;\n\nvoid setup() {\n  pinMode(bumperPin, INPUT_PULLUP);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  if (digitalRead(bumperPin) == LOW) {\n    Serial.println(\"CRASH! Bumper triggered!\");\n    delay(200);\n  }\n}",
            "expectedOutput": "Serial Monitor prints 'CRASH! Bumper triggered!' whenever the microswitch lever is pressed."
        }
    },
    5: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and OUT (Green) to digital pin 2.",
        "commonMistakes": [
            "Placing transparent objects in the slit that do not sufficiently block infrared light.",
            "Confusing active-HIGH or active-LOW trigger conditions."
        ],
        "miniExperiment": {
            "title": "Optical Speed Gate",
            "circuit": "VCC to 5V, GND to GND, OUT to Digital Pin 2.",
            "code": "const int gatePin = 2;\n\nvoid setup() {\n  pinMode(gatePin, INPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  if (digitalRead(gatePin) == HIGH) {\n    Serial.println(\"Beam Interrupted!\");\n    delay(150);\n  }\n}",
            "expectedOutput": "Serial Monitor announces 'Beam Interrupted!' the instant an opaque card or toothpick enters the optical slot."
        }
    },
    6: {
        "wiringGuidance": "Connect Row pins R1-R4 (Green wires) to digital pins 9, 8, 7, 6. Connect Column pins C1-C4 (Green wires) to digital pins 5, 4, 3, 2.",
        "commonMistakes": [
            "Reversing row and column ribbon connector pin order.",
            "Attempting to read keys without enabling internal pull-ups or scanning row by row."
        ],
        "miniExperiment": {
            "title": "Keypad Matrix Scanner",
            "circuit": "Rows to pins 9-6, Cols to pins 5-2.",
            "code": "const byte ROWS = 4;\nconst byte COLS = 4;\nbyte rowPins[ROWS] = {9, 8, 7, 6};\nbyte colPins[COLS] = {5, 4, 3, 2};\n\nvoid setup() {\n  Serial.begin(9600);\n  for (int r = 0; r < ROWS; r++) pinMode(rowPins[r], OUTPUT);\n  for (int c = 0; c < COLS; c++) pinMode(colPins[c], INPUT_PULLUP);\n}\n\nvoid loop() {\n  for (int r = 0; r < ROWS; r++) {\n    digitalWrite(rowPins[r], LOW);\n    for (int c = 0; c < COLS; c++) {\n      if (digitalRead(colPins[c]) == LOW) {\n        Serial.print(\"Pressed Row: \");\n        Serial.print(r);\n        Serial.print(\" Col: \");\n        Serial.println(c);\n        delay(200);\n      }\n    }\n    digitalWrite(rowPins[r], HIGH);\n  }\n}",
            "expectedOutput": "Serial Monitor logs exact row and column numbers as you tap keys on the membrane keypad."
        }
    },
    7: {
        "wiringGuidance": "Connect GND (Dark Slate) to GND, VCC (Red) to 5V, SDA (Blue) to Arduino pin A4, and SCL (Blue) to pin A5.",
        "commonMistakes": [
            "Not adjusting the blue contrast potentiometer on the back I2C backpack—characters appear invisible!",
            "Using incorrect I2C address (typically 0x27 or 0x3F)."
        ],
        "miniExperiment": {
            "title": "I2C Hello World Display",
            "circuit": "GND to GND, VCC to 5V, SDA to A4 (Blue), SCL to A5 (Blue).",
            "code": "#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  lcd.init();\n  lcd.backlight();\n  lcd.setCursor(0, 0);\n  lcd.print(\"Monster Lab!\");\n  lcd.setCursor(0, 1);\n  lcd.print(\"System Online\");\n}\n\nvoid loop() {}",
            "expectedOutput": "The 16x2 LCD backlight illuminates and displays 'Monster Lab!' on line 1 and 'System Online' on line 2."
        }
    },
    8: {
        "wiringGuidance": "Connect VCC (Red) to 3.3V or 5V, GND (Dark Slate) to GND, SCL (Blue) to A5, and SDA (Blue) to A4.",
        "commonMistakes": [
            "Leaving SCL and SDA unconnected or swapped.",
            "Failing to let temperature stabilize after touching the sensor with warm fingers."
        ],
        "miniExperiment": {
            "title": "Barometric Weather Station",
            "circuit": "VCC to 3.3V, GND to GND, SCL to A5, SDA to A4.",
            "code": "#include <Wire.h>\n#include <Adafruit_BMP085.h>\n\nAdafruit_BMP085 bmp;\n\nvoid setup() {\n  Serial.begin(9600);\n  if (!bmp.begin()) {\n    Serial.println(\"BMP180 not found!\");\n    while (1) {}\n  }\n}\n\nvoid loop() {\n  Serial.print(\"Temp: \");\n  Serial.print(bmp.readTemperature());\n  Serial.print(\" *C | Pressure: \");\n  Serial.print(bmp.readPressure());\n  Serial.println(\" Pa\");\n  delay(1000);\n}",
            "expectedOutput": "Serial Monitor displays ambient temperature in Celsius and atmospheric pressure in Pascals every second."
        }
    },
    9: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and DATA (Green) to digital pin 2 with a 10k pull-up resistor to 5V.",
        "commonMistakes": [
            "Querying the sensor faster than once every 2 seconds, which leads to timeout errors.",
            "Confusing 3-pin breakout modules with bare 4-pin components."
        ],
        "miniExperiment": {
            "title": "Room Climate Check",
            "circuit": "VCC to 5V, GND to GND, DATA to Pin 2.",
            "code": "#include <dht.h>\ndht DHT;\n#define DHT11_PIN 2\n\nvoid setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int chk = DHT.read11(DHT11_PIN);\n  Serial.print(\"Temp: \");\n  Serial.print(DHT.temperature);\n  Serial.print(\"C | Humidity: \");\n  Serial.print(DHT.humidity);\n  Serial.println(\"%\");\n  delay(2000);\n}",
            "expectedOutput": "Serial Monitor prints temperature and relative humidity every 2 seconds. Exhaling on the sensor spikes humidity to 90%+."
        }
    },
    10: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, SDA (Blue) to A4, and SCL (Blue) to A5.",
        "commonMistakes": [
            "Forgetting to install the CR2032 backup battery, losing time when power is disconnected.",
            "Using rechargeable batteries in RTC modules designed for non-rechargeable CR2032."
        ],
        "miniExperiment": {
            "title": "Real-Time Clock Ticker",
            "circuit": "VCC to 5V, GND to GND, SDA to A4, SCL to A5.",
            "code": "#include <Wire.h>\n#include <RTClib.h>\n\nRTC_DS3231 rtc;\n\nvoid setup() {\n  Serial.begin(9600);\n  if (!rtc.begin()) {\n    Serial.println(\"RTC not found\");\n    while (1);\n  }\n}\n\nvoid loop() {\n  DateTime now = rtc.now();\n  Serial.print(now.hour());\n  Serial.print(':');\n  Serial.print(now.minute());\n  Serial.print(':');\n  Serial.println(now.second());\n  delay(1000);\n}",
            "expectedOutput": "Serial Monitor displays live real-time hours, minutes, and seconds advancing every second."
        }
    },
    11: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, D0 (Green) to digital pin 4, and A0 (Yellow) to analog pin A0.",
        "commonMistakes": [
            "Bringing an open flame too close to the sensor and melting the epoxy casing.",
            "Testing under direct sunlight, which floods the sensor with ambient infrared light."
        ],
        "miniExperiment": {
            "title": "Infrared Flame Detector",
            "circuit": "VCC to 5V, GND to GND, A0 to Analog Pin A0.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int flameVal = analogRead(A0);\n  Serial.print(\"IR Intensity: \");\n  Serial.println(flameVal);\n  delay(100);\n}",
            "expectedOutput": "Reads high numbers (~900-1023) in normal room light, and drops below 200 when exposed to an infrared source."
        }
    },
    12: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, SCL (Blue) to A5, and SDA (Blue) to A4.",
        "commonMistakes": [
            "Leaving the module loose or unfastened, causing extreme noise in accelerometer values.",
            "Connecting AD0 to 5V when using default address 0x68 (AD0 must connect to GND)."
        ],
        "miniExperiment": {
            "title": "Tilt & Gyro Balance Stream",
            "circuit": "VCC to 5V, GND to GND, SCL to A5, SDA to A4.",
            "code": "#include <Wire.h>\n#include <MPU6050.h>\n\nMPU6050 mpu;\n\nvoid setup() {\n  Serial.begin(9600);\n  Wire.begin();\n  mpu.initialize();\n}\n\nvoid loop() {\n  int16_t ax, ay, az;\n  mpu.getAcceleration(&ax, &ay, &az);\n  Serial.print(\"X: \"); Serial.print(ax);\n  Serial.print(\" | Y: \"); Serial.print(ay);\n  Serial.print(\" | Z: \"); Serial.println(az);\n  delay(100);\n}",
            "expectedOutput": "Serial Monitor streams raw 3-axis acceleration vectors that change as you tilt the sensor."
        }
    },
    13: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and OUT (Green) to digital pin 11.",
        "commonMistakes": [
            "Wiring VCC and GND in reverse (destroys the infrared demodulator chip).",
            "Operating under high-frequency ballast fluorescent lights causing noise spikes."
        ],
        "miniExperiment": {
            "title": "Remote Control Hex Decoder",
            "circuit": "VCC to 5V, GND to GND, OUT to Pin 11.",
            "code": "#include <IRremote.h>\nconst int RECV_PIN = 11;\n\nvoid setup() {\n  Serial.begin(9600);\n  IrReceiver.begin(RECV_PIN, ENABLE_LED_FEEDBACK);\n}\n\nvoid loop() {\n  if (IrReceiver.decode()) {\n    Serial.print(\"Hex Code: 0x\");\n    Serial.println(IrReceiver.decodedIRData.decodedRawData, HEX);\n    IrReceiver.resume();\n  }\n}",
            "expectedOutput": "Pressing buttons on the handheld remote prints unique hexadecimal codes in Serial Monitor."
        }
    },
    14: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and D0 (Green) to digital pin 7.",
        "commonMistakes": [
            "Placing sensor too far from ground (optimal focal distance is 3mm to 10mm).",
            "Using shiny reflective tape instead of matte electrical tape."
        ],
        "miniExperiment": {
            "title": "Dark Line Detector",
            "circuit": "VCC to 5V, GND to GND, D0 to Pin 7.",
            "code": "const int trackerPin = 7;\n\nvoid setup() {\n  pinMode(trackerPin, INPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int state = digitalRead(trackerPin);\n  if (state == HIGH) {\n    Serial.println(\"BLACK LINE DETECTED\");\n  } else {\n    Serial.println(\"White Surface\");\n  }\n  delay(100);\n}",
            "expectedOutput": "Serial Monitor prints 'BLACK LINE DETECTED' when placed over dark tape, and 'White Surface' otherwise."
        }
    },
    15: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, DIN (Orange) to Pin 11, CS (Orange) to Pin 10, and CLK (Orange) to Pin 13.",
        "commonMistakes": [
            "Powering with 3.3V instead of 5V, leading to dim LEDs and erratic controller sync.",
            "Swapping DIN and CLK wires."
        ],
        "miniExperiment": {
            "title": "Smiley Face Pixel Matrix",
            "circuit": "VCC to 5V, GND to GND, DIN to 11, CS to 10, CLK to 13.",
            "code": "#include <LedControl.h>\nLedControl lc = LedControl(11, 13, 10, 1);\n\nbyte smile[8] = {\n  B00111100,\n  B01000010,\n  B10100101,\n  B10000001,\n  B10100101,\n  B10011001,\n  B01000010,\n  B00111100\n};\n\nvoid setup() {\n  lc.shutdown(0, false);\n  lc.setIntensity(0, 8);\n  lc.clearDisplay(0);\n  for (int i = 0; i < 8; i++) {\n    lc.setRow(0, i, smile[i]);\n  }\n}\n\nvoid loop() {}",
            "expectedOutput": "The 8x8 LED matrix lights up displaying a bright, smiling monster face."
        }
    },
    16: {
        "wiringGuidance": "Connect VCC (Red) to 5V (requires ~150mA current), GND (Dark Slate) to GND, and A0 (Yellow) to analog pin A0.",
        "commonMistakes": [
            "Touching the heated metal casing while powered on (burn hazard).",
            "Not waiting 2-3 minutes for the internal heater to reach operating temperature."
        ],
        "miniExperiment": {
            "title": "Vapor Concentration Meter",
            "circuit": "VCC to 5V, GND to GND, A0 to Analog Pin A0.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int sensorVal = analogRead(A0);\n  Serial.print(\"Vapor Index: \");\n  Serial.println(sensorVal);\n  delay(500);\n}",
            "expectedOutput": "Outputs steady ambient readings (~50-150). Approaching with an alcohol swab causes readings to jump to 600+."
        }
    },
    17: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and A0 (Yellow) to analog pin A1.",
        "commonMistakes": [
            "Attempting to test with real open gas sources without adult supervision.",
            "Testing before the heating element has completed warm-up."
        ],
        "miniExperiment": {
            "title": "Combustible Gas Sniffer",
            "circuit": "VCC to 5V, GND to GND, A0 to Analog Pin A1.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int gasVal = analogRead(A1);\n  Serial.print(\"Gas Reading: \");\n  Serial.println(gasVal);\n  delay(500);\n}",
            "expectedOutput": "Steady baseline readings in clean ambient air (~80-140)."
        }
    },
    18: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and OUT (Green) to digital pin 4.",
        "commonMistakes": [
            "Turning the sensitivity potentiometer too far until the sensor is stuck LOW.",
            "Expecting reliable detection on dark black surfaces."
        ],
        "miniExperiment": {
            "title": "Proximity Trap",
            "circuit": "VCC to 5V, GND to GND, OUT to Pin 4.",
            "code": "const int obsPin = 4;\n\nvoid setup() {\n  pinMode(obsPin, INPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  if (digitalRead(obsPin) == LOW) {\n    Serial.println(\"OBSTACLE DETECTED IN FRONT!\");\n    delay(200);\n  }\n}",
            "expectedOutput": "Serial Monitor prints obstacle warnings whenever an object approaches within 2-10cm."
        }
    },
    19: {
        "wiringGuidance": "Connect one leg of LDR to 5V (Red). Connect the second leg to analog pin A0 (Yellow) and through a 10k resistor to GND (Dark Slate).",
        "commonMistakes": [
            "Omitting the series 10k fixed resistor, creating a short circuit when exposed to bright light.",
            "Using digitalRead instead of analogRead."
        ],
        "miniExperiment": {
            "title": "Light & Shadow Theremin",
            "circuit": "5V -> LDR -> Pin A0 -> 10k resistor -> GND.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int lightVal = analogRead(A0);\n  Serial.print(\"Light Level: \");\n  Serial.println(lightVal);\n  delay(100);\n}",
            "expectedOutput": "Outputs 600-900 in room light, falling below 150 when you cover the LDR with your palm."
        }
    },
    20: {
        "wiringGuidance": "Connect left pin 1 to 5V (Red), right pin 3 to GND (Dark Slate), and center wiper pin 2 to analog pin A0 (Yellow).",
        "commonMistakes": [
            "Connecting center wiper to 5V and outer pins to GND (creates a direct dead short when turned fully!).",
            "Forcing the shaft beyond its ~270 degree mechanical limits."
        ],
        "miniExperiment": {
            "title": "Rotary Voltage Gauge",
            "circuit": "Pin 1 to 5V, Pin 2 to A0, Pin 3 to GND.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int raw = analogRead(A0);\n  float volts = raw * (5.0 / 1023.0);\n  Serial.print(\"Raw: \"); Serial.print(raw);\n  Serial.print(\" | Voltage: \"); Serial.print(volts);\n  Serial.println(\" V\");\n  delay(100);\n}",
            "expectedOutput": "Rotating the knob smoothly shifts readings from 0 (0.00V) to 1023 (5.00V)."
        }
    },
    21: {
        "wiringGuidance": "Connect GND (Dark Slate) to GND, +5V (Red) to 5V, VRx (Yellow) to A0, VRy (Yellow) to A1, and SW (Green) to digital pin 2.",
        "commonMistakes": [
            "Leaving the switch pin SW floating without INPUT_PULLUP.",
            "Expecting exact 512 center values without accounting for mechanical potentiometer tolerances."
        ],
        "miniExperiment": {
            "title": "Arcade Joystick Coordinates",
            "circuit": "GND to GND, 5V to 5V, VRx to A0, VRy to A1, SW to Pin 2.",
            "code": "void setup() {\n  Serial.begin(9600);\n  pinMode(2, INPUT_PULLUP);\n}\n\nvoid loop() {\n  int x = analogRead(A0);\n  int y = analogRead(A1);\n  int btn = digitalRead(2);\n  Serial.print(\"X: \"); Serial.print(x);\n  Serial.print(\" | Y: \"); Serial.print(y);\n  Serial.print(\" | Click: \"); Serial.println(btn == LOW ? \"YES\" : \"NO\");\n  delay(100);\n}",
            "expectedOutput": "Serial Monitor streams live 2-axis stick coordinates and button click states."
        }
    },
    22: {
        "wiringGuidance": "Connect sensing plate to amplifier board. Connect amplifier VCC (Red) to 5V, GND (Dark Slate) to GND, and A0 (Yellow) to analog pin A0.",
        "commonMistakes": [
            "Submerging the electronic comparator module instead of only the probe plate.",
            "Leaving water droplet residue on the probe tracks between tests."
        ],
        "miniExperiment": {
            "title": "Storm Raindrop Alarm",
            "circuit": "VCC to 5V, GND to GND, A0 to Analog Pin A0.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int rainLevel = analogRead(A0);\n  Serial.print(\"Rain Intensity: \");\n  Serial.println(1023 - rainLevel);\n  delay(200);\n}",
            "expectedOutput": "Outputs near 0 when dry; a single raindrop placed on the plate jumps the value to 700+."
        }
    },
    23: {
        "wiringGuidance": "Connect 3.3V (Red) to 3.3V ONLY! Connect GND (Dark Slate) to GND, RST to Pin 9, SDA to Pin 10, MOSI to Pin 11, MISO to Pin 12, SCK to Pin 13 (Orange wires).",
        "commonMistakes": [
            "Connecting VCC to 5V (permanently fries the RC522 RFID silicon!).",
            "Loose jumper wire connections on the 8-pin header."
        ],
        "miniExperiment": {
            "title": "Smart Card UID Reader",
            "circuit": "VCC to 3.3V, GND to GND, RST to 9, SDA to 10, MOSI to 11, MISO to 12, SCK to 13.",
            "code": "#include <SPI.h>\n#include <MFRC522.h>\n\n#define SS_PIN 10\n#define RST_PIN 9\nMFRC522 rfid(SS_PIN, RST_PIN);\n\nvoid setup() {\n  Serial.begin(9600);\n  SPI.begin();\n  rfid.PCD_Init();\n  Serial.println(\"Tap an RFID card or fob...\");\n}\n\nvoid loop() {\n  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial()) return;\n  Serial.print(\"Card UID: \");\n  for (byte i = 0; i < rfid.uid.size; i++) {\n    Serial.print(rfid.uid.uidByte[i] < 0x10 ? \" 0\" : \" \");\n    Serial.print(rfid.uid.uidByte[i], HEX);\n  }\n  Serial.println();\n  rfid.PICC_HaltA();\n}",
            "expectedOutput": "Serial Monitor displays the hex UID whenever an RFID card or keychain is tapped against the coil."
        }
    },
    24: {
        "wiringGuidance": "Connect GND (Dark Slate) to GND, + (Red) to 5V, CLK (Green) to Pin 2, DT (Green) to Pin 3, and SW (Green) to Pin 4.",
        "commonMistakes": [
            "Missing switch debounce filtering in software, causing erratic count jumps.",
            "Swapping CLK and DT, which inverts rotation direction."
        ],
        "miniExperiment": {
            "title": "Endless Dial Counter",
            "circuit": "GND to GND, + to 5V, CLK to Pin 2, DT to Pin 3.",
            "code": "const int pinA = 2;\nconst int pinB = 3;\nint counter = 0;\nint lastStateA;\n\nvoid setup() {\n  pinMode(pinA, INPUT);\n  pinMode(pinB, INPUT);\n  Serial.begin(9600);\n  lastStateA = digitalRead(pinA);\n}\n\nvoid loop() {\n  int stateA = digitalRead(pinA);\n  if (stateA != lastStateA && stateA == 1) {\n    if (digitalRead(pinB) != stateA) counter++;\n    else counter--;\n    Serial.print(\"Position: \");\n    Serial.println(counter);\n  }\n  lastStateA = stateA;\n}",
            "expectedOutput": "Rotating the knob clockwise increases position in Serial Monitor; counter-clockwise decreases it."
        }
    },
    25: {
        "wiringGuidance": "Connect Brown wire (Dark Slate) to GND, Red wire (Red) to 5V, and Orange wire (Green) to digital pin 9.",
        "commonMistakes": [
            "Manually forcing the horn past 0 or 180 degrees, stripping the small plastic gears.",
            "Powering several servos directly from Arduino 5V regulator, triggering brownout resets."
        ],
        "miniExperiment": {
            "title": "Servo Arm Sweep",
            "circuit": "Brown to GND, Red to 5V, Orange to Pin 9.",
            "code": "#include <Servo.h>\nServo myServo;\n\nvoid setup() {\n  myServo.attach(9);\n}\n\nvoid loop() {\n  myServo.write(0);\n  delay(1000);\n  myServo.write(90);\n  delay(1000);\n  myServo.write(180);\n  delay(1000);\n}",
            "expectedOutput": "The servo arm smoothly steps between 0, 90, and 180 degrees every second."
        }
    },
    26: {
        "wiringGuidance": "Connect probes to amplifier board. Connect amplifier VCC (Red) to 5V, GND (Dark Slate) to GND, and A0 (Yellow) to analog pin A0.",
        "commonMistakes": [
            "Keeping power on 24/7 in moist soil, corroding copper probes rapidly through electrolysis.",
            "Touching both prongs with sweaty skin during dry calibration."
        ],
        "miniExperiment": {
            "title": "Soil Moisture Plant Monitor",
            "circuit": "VCC to 5V, GND to GND, A0 to Analog Pin A0.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int val = analogRead(A0);\n  Serial.print(\"Moisture Level: \");\n  Serial.println(1023 - val);\n  delay(1000);\n}",
            "expectedOutput": "Outputs 0 in air, increasing to 600-800 when inserted into damp potting soil."
        }
    },
    27: {
        "wiringGuidance": "Connect ULN2003 + (Red) to 5V, - (Dark Slate) to GND, and IN1-IN4 (Green wires) to digital pins 8, 9, 10, 11.",
        "commonMistakes": [
            "Trying to drive stepper coils directly from micro pins without the ULN2003 driver.",
            "Incorrect phase stepping sequence making the motor vibrate in place without turning."
        ],
        "miniExperiment": {
            "title": "Precision Stepper Revolution",
            "circuit": "IN1-IN4 to Pins 8-11, Power to 5V & GND.",
            "code": "#include <Stepper.h>\nconst int stepsPerRev = 2048;\nStepper myStepper(stepsPerRev, 8, 10, 9, 11);\n\nvoid setup() {\n  myStepper.setSpeed(10);\n}\n\nvoid loop() {\n  myStepper.step(stepsPerRev);\n  delay(1000);\n  myStepper.step(-stepsPerRev);\n  delay(1000);\n}",
            "expectedOutput": "The stepper shaft completes a full 360-degree rotation clockwise, pauses, and reverses."
        }
    },
    28: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and DO (Green) to digital pin 3.",
        "commonMistakes": [
            "Leaving the sensor dangling freely without rigid mounting to the monitored chassis.",
            "Missing rapid transient pulse events by polling too slowly in the sketch."
        ],
        "miniExperiment": {
            "title": "Seismic Quake Alarm",
            "circuit": "VCC to 5V, GND to GND, DO to Pin 3.",
            "code": "const int vibPin = 3;\n\nvoid setup() {\n  pinMode(vibPin, INPUT);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  if (digitalRead(vibPin) == HIGH) {\n    Serial.println(\"VIBRATION DETECTED!\");\n    delay(200);\n  }\n}",
            "expectedOutput": "Tapping the desk triggers 'VIBRATION DETECTED!' instantly in the Serial Monitor."
        }
    },
    29: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, TXD (Purple) to Pin 2, and RXD (Purple) through a voltage divider to Pin 3.",
        "commonMistakes": [
            "Connecting Arduino 5V TX directly to HC-05 RXD without a voltage divider.",
            "Leaving Bluetooth connected to pins 0 and 1 while uploading sketches."
        ],
        "miniExperiment": {
            "title": "Bluetooth Serial Echo",
            "circuit": "VCC to 5V, GND to GND, TX to Pin 2, RX via divider to Pin 3.",
            "code": "#include <SoftwareSerial.h>\nSoftwareSerial btSerial(2, 3);\n\nvoid setup() {\n  Serial.begin(9600);\n  btSerial.begin(9600);\n  Serial.println(\"Bluetooth Ready\");\n}\n\nvoid loop() {\n  if (btSerial.available()) Serial.write(btSerial.read());\n  if (Serial.available()) btSerial.write(Serial.read());\n}",
            "expectedOutput": "Messages sent from a Bluetooth terminal smartphone app appear in the Serial Monitor."
        }
    },
    30: {
        "wiringGuidance": "Mount shield directly onto the Arduino Uno headers. Connect an RJ45 Ethernet cable to the shield jack and a router.",
        "commonMistakes": [
            "Pin conflicts on digital pins 10, 11, 12, 13 (reserved for Ethernet SPI).",
            "Forgetting to initialize with a valid local MAC address."
        ],
        "miniExperiment": {
            "title": "Local Network Web Ping",
            "circuit": "Mount shield onto Arduino Uno, plug in RJ45 network cable.",
            "code": "#include <SPI.h>\n#include <Ethernet.h>\n\nbyte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };\n\nvoid setup() {\n  Serial.begin(9600);\n  if (Ethernet.begin(mac) == 0) {\n    Serial.println(\"DHCP failed\");\n  } else {\n    Serial.print(\"Assigned IP: \");\n    Serial.println(Ethernet.localIP());\n  }\n}\n\nvoid loop() {}",
            "expectedOutput": "Shield obtains an IP address from your local router and prints it in the Serial Monitor."
        }
    },
    31: {
        "wiringGuidance": "Connect GND (Dark Slate) to GND, VCC (Red) to 3.3V ONLY, CE (Orange) to Pin 9, CSN (Orange) to Pin 10, SCK (Orange) to Pin 13, MOSI (Orange) to Pin 11, MISO (Orange) to Pin 12.",
        "commonMistakes": [
            "Powering VCC with 5V permanently destroys the RF chip!",
            "Noisy 3.3V power rails causing packet drops (add a 10uF capacitor across VCC and GND)."
        ],
        "miniExperiment": {
            "title": "RF Transmitter Beacon",
            "circuit": "VCC to 3.3V, GND to GND, CE to 9, CSN to 10, SCK to 13, MOSI to 11, MISO to 12.",
            "code": "#include <SPI.h>\n#include <nRF24L01.h>\n#include <RF24.h>\n\nRF24 radio(9, 10);\nconst byte address[6] = \"00001\";\n\nvoid setup() {\n  radio.begin();\n  radio.openWritingPipe(address);\n  radio.setPALevel(RF24_PA_MIN);\n  radio.stopListening();\n}\n\nvoid loop() {\n  const char text[] = \"Monster Lab Ping!\";\n  radio.write(&text, sizeof(text));\n  delay(1000);\n}",
            "expectedOutput": "Transmits 2.4GHz wireless telemetry packets once per second."
        }
    },
    32: {
        "wiringGuidance": "Connect COM (Dark Slate) to GND through a 220-ohm resistor. Connect segment pins A-G (Green wires) to digital pins 2-8.",
        "commonMistakes": [
            "Omitting series current-limiting resistors, damaging the LED segments.",
            "Confusing Common Anode (requires VCC) with Common Cathode (requires GND)."
        ],
        "miniExperiment": {
            "title": "Digital Countdown 0-9",
            "circuit": "COM through 220 ohm to GND, Segments A-G to Pins 2-8.",
            "code": "const int segPins[7] = {2, 3, 4, 5, 6, 7, 8};\nbyte digits[10] = {\n  B0111111, B0000110, B1011011, B1001111, B1100110,\n  B1101101, B1111101, B0000111, B1111111, B1101111\n};\n\nvoid setup() {\n  for (int i = 0; i < 7; i++) pinMode(segPins[i], OUTPUT);\n}\n\nvoid loop() {\n  for (int d = 0; d < 10; d++) {\n    for (int s = 0; s < 7; s++) {\n      digitalWrite(segPins[s], bitRead(digits[d], s));\n    }\n    delay(1000);\n  }\n}",
            "expectedOutput": "The single-digit display clearly counts from 0 through 9 once per second."
        }
    },
    33: {
        "wiringGuidance": "Connect motor terminals through a transistor (e.g. PN2222) or motor driver shield. Never connect motor leads directly to Arduino pins!",
        "commonMistakes": [
            "Connecting DC motor directly to Arduino pins (exceeds 40mA max pin rating and fries the board).",
            "Omitting the flyback protection diode across the motor terminals."
        ],
        "miniExperiment": {
            "title": "Transistor Motor Speed Control",
            "circuit": "Arduino Pin 9 -> 1k resistor -> Base of NPN transistor. Collector -> Motor -> 5V. Emitter -> GND. Diode across motor.",
            "code": "const int motorPin = 9;\n\nvoid setup() {\n  pinMode(motorPin, OUTPUT);\n}\n\nvoid loop() {\n  for (int speed = 0; speed <= 255; speed += 5) {\n    analogWrite(motorPin, speed);\n    delay(50);\n  }\n  delay(1000);\n  analogWrite(motorPin, 0);\n  delay(1000);\n}",
            "expectedOutput": "Motor smoothly spins up from zero to full speed, stops, and repeats."
        }
    },
    34: {
        "wiringGuidance": "Connect positive (+) terminal (Red/Green wire) to digital pin 8 and negative (-) terminal (Dark Slate wire) to GND.",
        "commonMistakes": [
            "Confusing active buzzers (constant tone on DC) with passive buzzers (require tone() PWM frequency).",
            "Reversing polarity on active buzzer modules."
        ],
        "miniExperiment": {
            "title": "Chirp & Melody Player",
            "circuit": "(+) to Pin 8, (-) to GND.",
            "code": "const int buzzerPin = 8;\n\nvoid setup() {}\n\nvoid loop() {\n  tone(buzzerPin, 440, 200);\n  delay(300);\n  tone(buzzerPin, 880, 200);\n  delay(700);\n}",
            "expectedOutput": "Buzzer plays two cheerful alternating tones every second."
        }
    },
    35: {
        "wiringGuidance": "Connect + (Red) to 5V, - (Dark Slate) to GND, and S (Yellow) to analog pin A0.",
        "commonMistakes": [
            "Submerging past the maximum level line and wetting the top wire pins.",
            "Powering constantly in water, accelerating copper electrolysis corrosion."
        ],
        "miniExperiment": {
            "title": "Water Immersion Gauge",
            "circuit": "+ to 5V, - to GND, S to Analog Pin A0.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  int depth = analogRead(A0);\n  Serial.print(\"Water Depth: \");\n  Serial.println(depth);\n  delay(250);\n}",
            "expectedOutput": "Reads 0 when dry; dipping into water increases value proportionally up to ~650."
        }
    },
    36: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and IN (Green) to digital pin 7. Use only with low-voltage DC loads (under 12V).",
        "commonMistakes": [
            "Attempting to wire 120V/240V mains household voltage (strictly forbidden without adult supervision).",
            "Not accounting for active-LOW relay triggering."
        ],
        "miniExperiment": {
            "title": "Relay Click Switcher",
            "circuit": "VCC to 5V, GND to GND, IN to Pin 7.",
            "code": "const int relayPin = 7;\n\nvoid setup() {\n  pinMode(relayPin, OUTPUT);\n}\n\nvoid loop() {\n  digitalWrite(relayPin, LOW);\n  delay(2000);\n  digitalWrite(relayPin, HIGH);\n  delay(2000);\n}",
            "expectedOutput": "The mechanical relay audibly clicks every two seconds and toggles its indicator LED."
        }
    },
    37: {
        "wiringGuidance": "Connect Signal (Green wire) to digital pin 8 and - (Dark Slate wire) to GND.",
        "commonMistakes": [
            "Pointing the laser beam at eyes, faces, or reflective surfaces (serious eye safety hazard).",
            "Leaving the laser diode powered continuously without heat dissipation."
        ],
        "miniExperiment": {
            "title": "Laser Pulse Blaster",
            "circuit": "Signal to Pin 8, (-) to GND.",
            "code": "const int laserPin = 8;\n\nvoid setup() {\n  pinMode(laserPin, OUTPUT);\n}\n\nvoid loop() {\n  digitalWrite(laserPin, HIGH);\n  delay(500);\n  digitalWrite(laserPin, LOW);\n  delay(500);\n}",
            "expectedOutput": "A bright red 650nm laser beam pulses on and off every half second onto a safe target sheet."
        }
    },
    38: {
        "wiringGuidance": "Connect VCC (Red) to 5V, GND (Dark Slate) to GND, and OUT (Green) to digital pin 2 with a 10k pull-up resistor to 5V.",
        "commonMistakes": [
            "Omitting the 10k pull-up resistor (the 3144 has an open-collector output).",
            "Testing with the wrong magnetic pole (3144 detects South magnetic poles only)."
        ],
        "miniExperiment": {
            "title": "Magnetic Field Detector",
            "circuit": "VCC to 5V, GND to GND, OUT to Pin 2 with 10k pullup.",
            "code": "const int hallPin = 2;\n\nvoid setup() {\n  pinMode(hallPin, INPUT_PULLUP);\n  Serial.begin(9600);\n}\n\nvoid loop() {\n  if (digitalRead(hallPin) == LOW) {\n    Serial.println(\"MAGNET DETECTED!\");\n    delay(200);\n  }\n}",
            "expectedOutput": "Approaching the sensor with the South pole of a magnet triggers 'MAGNET DETECTED!' in Serial Monitor."
        }
    },
    39: {
        "wiringGuidance": "Connect to your computer using the blue USB Type-A to Type-B cable. Power is supplied directly from USB or via 7-12V DC barrel jack.",
        "commonMistakes": [
            "Leaving the board resting on conductive metal surfaces while powered.",
            "Connecting sensors to 5V when they require 3.3V logic."
        ],
        "miniExperiment": {
            "title": "Onboard Heartbeat Blink",
            "circuit": "No wires needed! The Arduino Uno has an onboard LED connected to Digital Pin 13.",
            "code": "void setup() {\n  pinMode(LED_BUILTIN, OUTPUT);\n}\n\nvoid loop() {\n  digitalWrite(LED_BUILTIN, HIGH);\n  delay(500);\n  digitalWrite(LED_BUILTIN, LOW);\n  delay(500);\n}",
            "expectedOutput": "The tiny amber LED labeled 'L' next to pin 13 blinks steadily once per second."
        }
    },
    40: {
        "wiringGuidance": "Press firmly across the center divider of a solderless breadboard so each pin has its own separate tie-point row.",
        "commonMistakes": [
            "Plugging the Nano into a single column of breadboard holes, shorting opposite pins.",
            "Selecting Uno instead of Nano in Arduino IDE board selector."
        ],
        "miniExperiment": {
            "title": "Nano Serial Hello",
            "circuit": "Connect Nano via Mini-USB to computer.",
            "code": "void setup() {\n  Serial.begin(9600);\n  Serial.println(\"Hello from Arduino Nano!\");\n}\n\nvoid loop() {\n  Serial.println(\"Nano online.\");\n  delay(1000);\n}",
            "expectedOutput": "Serial Monitor displays 'Hello from Arduino Nano!' followed by 'Nano online.' every second."
        }
    },
    41: {
        "wiringGuidance": "Connect via USB-B cable. Use hardware serial ports Serial1 (pins 18/19), Serial2 (16/17), or Serial3 (14/15) for multi-device communication without software emulation.",
        "commonMistakes": [
            "Connecting SPI peripherals to pins 10-13 instead of Mega hardware SPI pins 50 (MISO), 51 (MOSI), 52 (SCK), 53 (SS).",
            "Exceeding power limits when running multiple motors directly."
        ],
        "miniExperiment": {
            "title": "Mega Multi-Serial Echo",
            "circuit": "Connect Mega via USB-B cable.",
            "code": "void setup() {\n  Serial.begin(9600);\n  Serial.println(\"Arduino Mega 2560 - 54 Pins Ready!\");\n}\n\nvoid loop() {\n  Serial.println(\"Mega ready for heavy duty robotics.\");\n  delay(2000);\n}",
            "expectedOutput": "Serial Monitor prints board specifications every 2 seconds."
        }
    },
    42: {
        "wiringGuidance": "Power via Micro-USB or 3.3V pin. When connecting 5V Arduino sensors, use a resistive voltage divider or logic level shifter on signal lines.",
        "commonMistakes": [
            "Applying 5V logic signals directly to ESP32 input pins.",
            "Trying to use GPIO 34, 35, 36, or 39 as outputs—they are input-only pins!"
        ],
        "miniExperiment": {
            "title": "ESP32 Wi-Fi Scanner",
            "circuit": "Connect ESP32 via Micro-USB cable.",
            "code": "#include <WiFi.h>\n\nvoid setup() {\n  Serial.begin(115200);\n  WiFi.mode(WIFI_STA);\n  WiFi.disconnect();\n  delay(100);\n}\n\nvoid loop() {\n  Serial.println(\"Scanning Wi-Fi networks...\");\n  int n = WiFi.scanNetworks();\n  Serial.print(n);\n  Serial.println(\" networks found.\");\n  delay(5000);\n}",
            "expectedOutput": "Serial Monitor (at 115200 baud) lists the number of nearby 2.4GHz Wi-Fi networks detected."
        }
    },
    43: {
        "wiringGuidance": "Use Micro-USB to flash code. Remember that D-number pin labels on the PCB do not match raw GPIO numbers (e.g., D1 is GPIO5, D2 is GPIO4).",
        "commonMistakes": [
            "Using D3 or D4 as active low inputs during boot, preventing the ESP8266 from booting into run mode.",
            "Setting Serial Monitor baud rate to 9600 instead of 115200."
        ],
        "miniExperiment": {
            "title": "NodeMCU Blue LED Pulse",
            "circuit": "Connect NodeMCU via Micro-USB cable.",
            "code": "void setup() {\n  pinMode(LED_BUILTIN, OUTPUT);\n}\n\nvoid loop() {\n  digitalWrite(LED_BUILTIN, LOW); // Active LOW on NodeMCU\n  delay(200);\n  digitalWrite(LED_BUILTIN, HIGH);\n  delay(800);\n}",
            "expectedOutput": "The blue onboard Wi-Fi module LED flashes a quick beacon flash every second."
        }
    },
    44: {
        "wiringGuidance": "Align all pins with Uno female headers and press down gently and evenly. Peel the backing off the mini breadboard to stick it onto the shield's solder pad area.",
        "commonMistakes": [
            "Bending header pins by pressing down at an uneven angle.",
            "Shorting soldered components underneath the shield against the Uno's metal USB jack."
        ],
        "miniExperiment": {
            "title": "Shield Status Test",
            "circuit": "Plug Protoshield onto Uno. Connect jumper wire from D13 header to LED1 anode on the shield.",
            "code": "void setup() {\n  pinMode(13, OUTPUT);\n}\nvoid loop() {\n  digitalWrite(13, HIGH);\n  delay(300);\n  digitalWrite(13, LOW);\n  delay(300);\n}",
            "expectedOutput": "The shield LED blinks on and off rhythmically."
        }
    },
    45: {
        "wiringGuidance": "Connect VCC to 5V, GND to GND, and PLAYE to Arduino digital pin 8. Connect the included 2-pin mini speaker to the SP+ and SP- terminals.",
        "commonMistakes": [
            "Holding the REC button too far from your mouth when recording audio.",
            "Forgetting to set REC pin to LOW during normal operation."
        ],
        "miniExperiment": {
            "title": "Robot Voice Trigger",
            "circuit": "Connect VCC to 5V, GND to GND, PLAYE to Pin 8. Connect speaker to module.",
            "code": "const int playPin = 8;\nvoid setup() {\n  pinMode(playPin, OUTPUT);\n  digitalWrite(playPin, LOW);\n  delay(2000);\n  digitalWrite(playPin, HIGH);\n  delay(100);\n  digitalWrite(playPin, LOW);\n}\nvoid loop() {}",
            "expectedOutput": "The speaker plays your recorded message 2 seconds after startup."
        }
    },
    46: {
        "wiringGuidance": "Plug the USB Doctor directly between your computer USB port and your Arduino board's blue cable. It requires no programming and powers on automatically.",
        "commonMistakes": [
            "Trying to upload code through damaged or charge-only USB cables plugged into the doctor."
        ],
        "miniExperiment": {
            "title": "System Power Consumption Check",
            "circuit": "Plug USB Doctor into laptop, then plug Arduino Uno into USB Doctor.",
            "code": "void setup() {\n  pinMode(LED_BUILTIN, OUTPUT);\n}\nvoid loop() {\n  digitalWrite(LED_BUILTIN, HIGH);\n  delay(1000);\n  digitalWrite(LED_BUILTIN, LOW);\n  delay(1000);\n}",
            "expectedOutput": "The display alternates between ~5.0V voltage and ~0.03A (30mA) operating current."
        }
    },
    47: {
        "wiringGuidance": "Connect VCC to 5V, GND to GND, CLK to Pin 2, and DIO to Pin 3. Install TM1637Display library in the Arduino IDE.",
        "commonMistakes": [
            "Swapping CLK and DIO connections.",
            "Omitting the TM1637 library initialization parameters."
        ],
        "miniExperiment": {
            "title": "Digital Counter",
            "circuit": "VCC to 5V, GND to GND, CLK to Pin 2, DIO to Pin 3.",
            "code": "#include <TM1637Display.h>\n#define CLK 2\n#define DIO 3\nTM1637Display display(CLK, DIO);\nvoid setup() {\n  display.setBrightness(0x0f);\n}\nvoid loop() {\n  for (int i = 0; i <= 99; i++) {\n    display.showNumberDec(i);\n    delay(100);\n  }\n}",
            "expectedOutput": "The display rapidly counts from 0 up to 99 in glowing red numerals."
        }
    },
    48: {
        "wiringGuidance": "Must be powered by a dedicated 3.3V supply (Uno 3.3V pin cannot provide the 200mA Wi-Fi transmit current spikes). Use 1k/2k resistor divider on RX line.",
        "commonMistakes": [
            "Connecting ESP-01 VCC directly to Uno 5V—this burns out the radio chip instantly!",
            "Leaving the CH_PD / EN pin floating (it must be pulled HIGH to 3.3V)."
        ],
        "miniExperiment": {
            "title": "AT Communication Ping",
            "circuit": "3V3 and EN to 3.3V supply, GND to GND, TX to Pin 2 (SoftRX), RX through divider to Pin 3 (SoftTX).",
            "code": "#include <SoftwareSerial.h>\nSoftwareSerial esp(2, 3); // RX, TX\nvoid setup() {\n  Serial.begin(9600);\n  esp.begin(115200);\n  Serial.println(\"Sending AT ping to ESP-01...\");\n  esp.println(\"AT\");\n}\nvoid loop() {\n  if (esp.available()) Serial.write(esp.read());\n}",
            "expectedOutput": "ESP-01 responds with 'OK' in the Serial Monitor."
        }
    },
    49: {
        "wiringGuidance": "Connect pin 16 (VCC1) to Arduino 5V for logic, pin 8 (VCC2) to motor battery supply (6-9V), pins 4, 5, 12, 13 to common GND.",
        "commonMistakes": [
            "Forgetting to connect both battery GND and Arduino GND together.",
            "Leaving EN1 (pin 1) low or floating, which disables the motor outputs."
        ],
        "miniExperiment": {
            "title": "Forward & Reverse DC Motor Spin",
            "circuit": "Pin 1 (EN) to 5V, Pin 2 (1A) to Pin 4, Pin 7 (2A) to Pin 5, Pin 3 & 6 to Motor terminals.",
            "code": "const int in1 = 4, in2 = 5;\nvoid setup() {\n  pinMode(in1, OUTPUT);\n  pinMode(in2, OUTPUT);\n}\nvoid loop() {\n  digitalWrite(in1, HIGH); digitalWrite(in2, LOW); delay(2000);\n  digitalWrite(in1, LOW); digitalWrite(in2, LOW); delay(500);\n  digitalWrite(in1, LOW); digitalWrite(in2, HIGH); delay(2000);\n  digitalWrite(in1, LOW); digitalWrite(in2, LOW); delay(500);\n}",
            "expectedOutput": "The DC motor spins forward for 2 seconds, pauses, then reverses direction for 2 seconds."
        }
    },
    50: {
        "wiringGuidance": "Connect DS to Pin 11, ST_CP (latch) to Pin 8, SH_CP (clock) to Pin 12. Tie OE to GND and MR to 5V.",
        "commonMistakes": [
            "Leaving OE (Output Enable) floating high, which turns off all outputs.",
            "Leaving MR (Master Reset) low or disconnected, which keeps the register cleared."
        ],
        "miniExperiment": {
            "title": "8-LED Shift Chaser",
            "circuit": "Connect DS to Pin 11, Latch to Pin 8, Clock to Pin 12. Connect Q0-Q7 through 220-ohm resistors to 8 LEDs.",
            "code": "int dataPin = 11, latchPin = 8, clockPin = 12;\nvoid setup() {\n  pinMode(dataPin, OUTPUT);\n  pinMode(latchPin, OUTPUT);\n  pinMode(clockPin, OUTPUT);\n}\nvoid loop() {\n  for (int i = 0; i < 8; i++) {\n    digitalWrite(latchPin, LOW);\n    shiftOut(dataPin, clockPin, MSBFIRST, 1 << i);\n    digitalWrite(latchPin, HIGH);\n    delay(100);\n  }\n}",
            "expectedOutput": "A single lit LED sweeps across the 8 output pins in sequence."
        }
    },
    51: {
        "wiringGuidance": "Form a voltage divider: Connect one leg of the thermistor to 5V, the other leg to Arduino A0. Connect a 10k fixed resistor between A0 and GND.",
        "commonMistakes": [
            "Connecting without a fixed 10k divider resistor—the analog pin will read constant 5V.",
            "Assuming voltage changes linearly with temperature."
        ],
        "miniExperiment": {
            "title": "Fingertip Heat Detector",
            "circuit": "Thermistor between 5V and A0; 10k resistor between A0 and GND.",
            "code": "void setup() {\n  Serial.begin(9600);\n}\nvoid loop() {\n  int raw = analogRead(A0);\n  float v = raw * (5.0 / 1023.0);\n  Serial.print(\"Raw ADC: \"); Serial.print(raw);\n  Serial.print(\" | Voltage: \"); Serial.println(v);\n  delay(250);\n}",
            "expectedOutput": "ADC value decreases steadily as you pinch the thermistor bead with warm fingertips."
        }
    },
    52: {
        "wiringGuidance": "Connect center pin to Arduino digital input with INPUT_PULLUP enabled. Connect outer pin 1 to GND. When slid toward pin 1, input reads LOW.",
        "commonMistakes": [
            "Leaving center pin floating when using external voltage instead of pull-up resistors.",
            "Forcing the plastic slider knob with excessive force."
        ],
        "miniExperiment": {
            "title": "A/B Mode Selector",
            "circuit": "Pin 2 (Common) to Pin 7 (INPUT_PULLUP), Pin 1 to GND, Pin 3 open.",
            "code": "const int switchPin = 7;\nvoid setup() {\n  pinMode(switchPin, INPUT_PULLUP);\n  Serial.begin(9600);\n}\nvoid loop() {\n  if (digitalRead(switchPin) == LOW) {\n    Serial.println(\"MODE: Manual Control\");\n  } else {\n    Serial.println(\"MODE: Autonomous Autopilot\");\n  }\n  delay(500);\n}",
            "expectedOutput": "Serial Monitor updates the operational mode message whenever the slider is flipped."
        }
    },
    53: {
        "wiringGuidance": "Always run Red jumper from Arduino 5V to the (+) rail, and Dark Slate or Black wire from GND to the (-) rail. Bridging components straddle the central trough.",
        "commonMistakes": [
            "Assuming the power rails are continuous across the entire board—some models have a split in the middle requiring a bridge wire.",
            "Plugging both legs of an LED or resistor into the same 5-hole column, shorting the component."
        ],
        "miniExperiment": {
            "title": "Breadboard Power Rail Continuity Check",
            "circuit": "Connect 5V to (+) rail, GND to (-) rail. Place 220-ohm resistor and Red LED across the rails.",
            "code": "void setup() {\n  pinMode(13, OUTPUT);\n  digitalWrite(13, HIGH);\n}\nvoid loop() {}",
            "expectedOutput": "The LED illuminates bright red directly from the breadboard power rail."
        }
    },
    54: {
        "wiringGuidance": "Plug directly into the Arduino Uno or Mega circular black barrel jack. The board's onboard voltage regulator will cleanly step down 9V to 5V and 3.3V.",
        "commonMistakes": [
            "Plugging an AC-output adapter or reverse-polarity supply into the Arduino (GAR adapter is verified center-positive DC).",
            "Leaving power supply plugged into wall when not in use."
        ],
        "miniExperiment": {
            "title": "Untethered Robot Power Up",
            "circuit": "Unplug USB cable. Plug 9V DC adapter barrel jack into Arduino Uno DC socket. Plug adapter into wall.",
            "code": "void setup() {\n  pinMode(LED_BUILTIN, OUTPUT);\n}\nvoid loop() {\n  digitalWrite(LED_BUILTIN, HIGH);\n  delay(200);\n  digitalWrite(LED_BUILTIN, LOW);\n  delay(200);\n}",
            "expectedOutput": "The Arduino boots autonomously without computer connection, and the LED blinks untethered."
        }
    }
}
