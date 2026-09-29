PROJECT_ENRICHMENTS = {
    "proj_01": {
        "story": "A pesky shadow monster is sneaking into your laboratory while you sleep! Build an automated ultrasonic radar sentry tripwire that monitors room distance and sounds a loud piezo siren whenever an intruder breaches the 30cm perimeter.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Components",
                "type": "gatherParts",
                "instructions": "Locate these parts from your kit: Arduino Uno, HC-SR04 Ultrasonic Distance Sensor, Piezo Buzzer, Red LED, 220-ohm resistor, and jumper wires.",
                "verificationCheckpoints": [
                    "Arduino Uno and USB-B cable ready",
                    "HC-SR04 sensor pins are straight and clean",
                    "Peel off yellow paper sticker from top of buzzer",
                    "1x 220-ohm resistor (Red-Red-Brown-Gold bands)"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Mount the HC-SR04 sensor and Buzzer onto your breadboard. Follow the color-coded connections below to hook up power, ground, echo timing, and buzzer triggers.",
                "wiringConnections": [
                    {
                        "from": "HC-SR04 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "HC-SR04 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "HC-SR04 TRIG",
                        "to": "Arduino Pin 9",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "HC-SR04 ECHO",
                        "to": "Arduino Pin 10",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Buzzer (+)",
                        "to": "Arduino Pin 8",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Buzzer (-)",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "LED Anode (+)",
                        "to": "Arduino Pin 7 (via 220R)",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "LED Cathode (-)",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "VCC connected to Red 5V rail",
                    "GND wires connected to Dark Slate GND rail",
                    "TRIG is in Pin 9 and ECHO is in Pin 10",
                    "Resistor is in series with LED anode"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Wiring Pre-Flight Check",
                "type": "wiringCheck",
                "instructions": "SAFETY FIRST! Never plug in your board until you complete this pre-flight verification checklist. A short between 5V and GND can harm your board.",
                "verificationCheckpoints": [
                    "Unplug USB cable during physical inspection",
                    "Confirm Red wire connects to 5V and Dark Slate wire connects to GND",
                    "Ensure no bare component legs touch each other",
                    "Verify buzzer polarity: (+) pin connects to Pin 8"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Logic",
                "type": "codeReview",
                "instructions": "Review how the Arduino pulses the ultrasonic speaker and calculates echo roundtrip time into distance in centimeters.",
                "codeSnippet": "const int TRIG_PIN = 9;\nconst int ECHO_PIN = 10;\nconst int BUZZER_PIN = 8;\nconst int LED_PIN = 7;\n\nvoid setup() {\n  Serial.begin(9600);\n  pinMode(TRIG_PIN, OUTPUT);\n  pinMode(ECHO_PIN, INPUT);\n  pinMode(BUZZER_PIN, OUTPUT);\n  pinMode(LED_PIN, OUTPUT);\n}\n\nvoid loop() {\n  digitalWrite(TRIG_PIN, LOW);\n  delayMicroseconds(2);\n  digitalWrite(TRIG_PIN, HIGH);\n  delayMicroseconds(10);\n  digitalWrite(TRIG_PIN, LOW);\n\n  long duration = pulseIn(ECHO_PIN, HIGH);\n  float distanceCm = duration * 0.0343 / 2.0;\n\n  if (distanceCm > 0 && distanceCm < 30.0) {\n    digitalWrite(LED_PIN, HIGH);\n    tone(BUZZER_PIN, 2000, 100);\n  } else {\n    digitalWrite(LED_PIN, LOW);\n    noTone(BUZZER_PIN);\n  }\n  delay(60);\n}",
                "codeExplanation": "- TRIG_PIN emits a 10-microsecond ultrasonic chirp at 40 kHz.\n- pulseIn(ECHO_PIN, HIGH) measures how many microseconds elapsed before the echo bounced back.\n- Multiplying by sound speed (0.0343 cm/us) and dividing by 2 yields distance to obstacle.\n- If obstacle < 30cm, the alarm sounds tone(2000Hz) and illuminates the LED.",
                "verificationCheckpoints": [
                    "Understand how pulseIn measures travel time",
                    "Understand why dividing by 2 is necessary (out-and-back trip)"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Physical Radar Test",
                "type": "uploadSketch",
                "instructions": "Connect USB cable to your computer, compile and upload the sketch. Wave your hand toward the sensor to verify perimeter tripwire triggering.",
                "verificationCheckpoints": [
                    "Hand at 50cm: buzzer quiet, LED dark",
                    "Hand moves closer than 30cm: buzzer chirps, LED flashes",
                    "Serial monitor displays live distance readings in cm"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete & Reflection",
                "type": "missionComplete",
                "instructions": "Awesome job! You successfully built and tested an active ultrasonic perimeter detector. Position it near your bedroom door or desk to guard against intruders!",
                "verificationCheckpoints": [
                    "Perimeter detection confirmed working",
                    "Ready to claim Security Rookie badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Distance always reads 0 or 3000 cm",
                "cause": "TRIG and ECHO pins are swapped",
                "solution": "Swap pins 9 and 10 on your breadboard or verify wires.",
                "category": "logic",
                "diagnosticSteps": [
                    "Check TRIG on Pin 9 and ECHO on Pin 10.",
                    "Ensure VCC is connected to 5V (not 3.3V).",
                    "Verify acoustic line of sight is clear."
                ]
            },
            {
                "symptom": "Buzzer clicks faintly but makes no siren",
                "cause": "Buzzer protective sticker not removed or negative pin on wrong rail",
                "solution": "Peel off the round yellow label and ensure (-) pin is in the GND rail.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Peel off the yellow protective sticker on top.",
                    "Ensure longer (+) pin is connected to Pin 8 and (-) to GND."
                ]
            },
            {
                "symptom": "LED does not illuminate",
                "cause": "LED inserted backwards (polarity error)",
                "solution": "Unplug LED and rotate 180 degrees. The longer leg (anode) must connect toward Pin 7.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Rotate LED 180 degrees to verify polarity.",
                    "Check that 220\u03a9 resistor connects cathode to GND."
                ]
            }
        ]
    },
    "proj_02": {
        "story": "Your robot wants to dance! Build an acoustic Beat Detector that samples acoustic pressure waves through a microphone and creates a pulsing light show synced to your clapping or music.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Acoustic Hardware",
                "type": "gatherParts",
                "instructions": "Collect the KY-037 Sound Sensor module, 3x LEDs (Red, Green, Blue), 3x 220-ohm resistors, and jumpers.",
                "verificationCheckpoints": [
                    "KY-037 microphone sensor with electret capsule ready",
                    "3x 220-ohm resistors ready",
                    "3x colored LEDs ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Wire KY-037 power and analog output A0. Wire the 3 LEDs to digital pins 9, 10, 11 with 220-ohm current-limiting resistors.",
                "wiringConnections": [
                    {
                        "from": "KY-037 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "KY-037 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "KY-037 A0",
                        "to": "Arduino Pin A0",
                        "wire": "Yellow",
                        "type": "analogIn"
                    },
                    {
                        "from": "LED 1 Anode",
                        "to": "Arduino Pin 9",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "LED 2 Anode",
                        "to": "Arduino Pin 10",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "LED 3 Anode",
                        "to": "Arduino Pin 11",
                        "wire": "Green",
                        "type": "digitalOut"
                    }
                ],
                "verificationCheckpoints": [
                    "KY-037 A0 connected to Arduino Analog Pin A0",
                    "LED cathodes all tied to GND rail"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Microphone Calibration Check",
                "type": "wiringCheck",
                "instructions": "Check that the trimmer screw on the blue box on KY-037 is tuned so the onboard LED stays off in quiet room noise.",
                "verificationCheckpoints": [
                    "No short between 5V and GND",
                    "Analog wire in A0",
                    "Turn potentiometer screw until onboard LED is just off"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Waveform Analysis",
                "type": "codeReview",
                "instructions": "Examine the sketch. We take high-speed analog samples, calculate acoustic deviations from baseline 512, and light up LEDs proportionally to loudness.",
                "codeSnippet": "const int micPin = A0;\nconst int ledPins[3] = {9, 10, 11};\n\nvoid setup() {\n  Serial.begin(9600);\n  for (int i = 0; i < 3; i++) pinMode(ledPins[i], OUTPUT);\n}\n\nvoid loop() {\n  int raw = analogRead(micPin);\n  int amplitude = abs(raw - 512);\n\n  digitalWrite(ledPins[0], amplitude > 20 ? HIGH : LOW);\n  digitalWrite(ledPins[1], amplitude > 60 ? HIGH : LOW);\n  digitalWrite(ledPins[2], amplitude > 120 ? HIGH : LOW);\n\n  delay(20);\n}",
                "codeExplanation": "- abs(raw - 512) measures how far sound pressure waves swing away from silence midpoint (512).\n- Moderate sounds (>20) light LED 1.\n- Louder claps (>60) light LED 2.\n- Peak beats (>120) light all 3 LEDs simultaneously.",
                "verificationCheckpoints": [
                    "Understand acoustic amplitude calculation",
                    "Understand tiered threshold activation"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Beat Test",
                "type": "uploadSketch",
                "instructions": "Upload the code, open Serial Plotter, play music near the mic or clap hands, and watch the LEDs pulse with the rhythm!",
                "verificationCheckpoints": [
                    "LEDs pulse in sync with claps",
                    "Quiet room leaves all LEDs off"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Groovy! You built an acoustic sound visualizer and mastered ADC signal processing.",
                "verificationCheckpoints": [
                    "System responds accurately to rhythm",
                    "Ready to claim Audio Engineer badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "LEDs are permanently ON even when quiet",
                "cause": "Sensitivity screw tuned too sensitive",
                "solution": "Rotate the brass screw on the blue potentiometer counter-clockwise until LEDs turn off.",
                "category": "logic",
                "diagnosticSteps": [
                    "Use a small screwdriver to turn the blue potentiometer on the microphone module.",
                    "Open Serial Monitor to observe live acoustic baseline numbers."
                ]
            }
        ]
    },
    "proj_03": {
        "story": "Build an animated emotional monster face on a 64-pixel LED matrix that changes its mood and expression when you press buttons on an infrared handheld remote!",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Remote & Display",
                "type": "gatherParts",
                "instructions": "Locate the AX-1838HS IR receiver, IR transmitter remote controller, and MAX7219 8x8 dot matrix display module.",
                "verificationCheckpoints": [
                    "MAX7219 8x8 dot matrix module ready",
                    "AX-1838HS IR sensor ready",
                    "Pull clear plastic battery pull-tab out of IR remote"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "SPI Display & IR Sensor Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect the MAX7219 SPI display lines (DIN, CS, CLK) and IR receiver data pin to Arduino.",
                "wiringConnections": [
                    {
                        "from": "MAX7219 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "MAX7219 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "MAX7219 DIN",
                        "to": "Arduino Pin 12",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "MAX7219 CS",
                        "to": "Arduino Pin 10",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "MAX7219 CLK",
                        "to": "Arduino Pin 11",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "IR Sensor OUT",
                        "to": "Arduino Pin 2",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "IR Sensor VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "IR Sensor GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "DIN to Pin 12, CS to Pin 10, CLK to Pin 11",
                    "IR receiver signal to Pin 2 (hardware interrupt)",
                    "Shared 5V and GND rail connections intact"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "SPI Bus Pre-Flight Check",
                "type": "wiringCheck",
                "instructions": "Inspect SPI bus wiring carefully. Double-check that DIN, CS, and CLK pins are not swapped.",
                "verificationCheckpoints": [
                    "5V and GND not reversed on IR sensor (reversing burns IR chip)",
                    "SPI wires firmly inserted"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Face Bitmaps",
                "type": "codeReview",
                "instructions": "Review how 8x8 bitmap arrays represent monster expressions (Happy, Surprised, Angry, Sleeping) and how IR hex codes swap expressions.",
                "codeSnippet": "#include <IRremote.hpp>\n#include <LedControl.h>\n\nLedControl lc = LedControl(12, 11, 10, 1); // DIN, CLK, CS\nconst int IR_PIN = 2;\n\nconst byte happyFace[8] = {\n  B00111100, B01000010, B10100101, B10000001,\n  B10100101, B10011001, B01000010, B00111100\n};\n\nvoid setup() {\n  IrReceiver.begin(IR_PIN);\n  lc.shutdown(0, false);\n  lc.setIntensity(0, 8);\n  lc.clearDisplay(0);\n}\n\nvoid loop() {\n  if (IrReceiver.decode()) {\n    unsigned long cmd = IrReceiver.decodedIRData.command;\n    // Switch expression based on remote key command\n    IrReceiver.resume();\n  }\n}",
                "codeExplanation": "- LedControl initializes the MAX7219 driver over SPI pins.\n- byte happyFace[8] stores an 8x8 pixel bitmap where 1 turns an LED on and 0 turns it off.\n- IrReceiver.decode() parses 38kHz infrared pulse bursts into clean command numbers.\n- Pressing remote buttons selects and displays different emotional bitmap arrays.",
                "verificationCheckpoints": [
                    "Understand how 8 bytes map to 64 display pixels",
                    "Understand IrReceiver.resume() to listen for next click"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Remote Control Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch, point the handheld remote at the sensor, and press buttons 1 to 4 to animate hilarious monster faces!",
                "verificationCheckpoints": [
                    "Button 1 displays Happy monster face",
                    "Button 2 displays Surprised monster face",
                    "Button 3 displays Silly monster face"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Fantastic! You constructed an animated interactive display and mastered SPI and IR decoding.",
                "verificationCheckpoints": [
                    "All facial expressions toggle reliably",
                    "Ready to claim Pixel Artist badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Remote button presses do nothing",
                "cause": "Clear plastic battery insulator is still inside remote",
                "solution": "Pull out the plastic tab from the battery compartment at the base of the remote.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Check if the transparent plastic battery tab is pulled from the IR remote.",
                    "Verify IR receiver signal wire is in digital pin 11."
                ]
            }
        ]
    },
    "proj_04": {
        "story": "Protect your monster vault! Construct a motorized safe door featuring a 16-key matrix keypad, 9g micro-servo locking deadbolt, and wrong-passcode siren.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Vault Hardware",
                "type": "gatherParts",
                "instructions": "Collect the 4x4 matrix keypad, SG90 micro-servo motor, servo horn, piezo buzzer, and breadboard.",
                "verificationCheckpoints": [
                    "4x4 membrane keypad ribbon intact",
                    "SG90 servo with single-arm horn attached",
                    "Piezo buzzer ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Servo Latch & Keypad Wiring",
                "type": "breadboardWiring",
                "instructions": "Wire Keypad rows to pins 9-6, cols to pins 5-2. Connect Servo PWM signal to Pin 11 and Buzzer to Pin 12.",
                "wiringConnections": [
                    {
                        "from": "Keypad R1-R4",
                        "to": "Pins 9, 8, 7, 6",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Keypad C1-C4",
                        "to": "Pins 5, 4, 3, 2",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Servo Red",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "Servo Brown",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "Servo Orange",
                        "to": "Arduino Pin 11",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Buzzer (+)",
                        "to": "Arduino Pin 12",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Buzzer (-)",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "Keypad pins matched sequentially",
                    "Servo Red wire to 5V, Brown to GND"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Servo & Pin Check",
                "type": "wiringCheck",
                "instructions": "Make sure the servo arm has room to swing freely from 0 to 90 degrees without bumping into components.",
                "verificationCheckpoints": [
                    "Servo arm moves freely",
                    "No power short on servo leads"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Passcode Verification",
                "type": "codeReview",
                "instructions": "Inspect the keypad scanning routine and servo unlock deadbolt logic.",
                "codeSnippet": "#include <Servo.h>\nServo lockServo;\nconst String SECRET_CODE = \"1234\";\nString enteredCode = \"\";\n\nvoid setup() {\n  Serial.begin(9600);\n  lockServo.attach(11);\n  lockServo.write(0); // Locked position\n}\n\nvoid loop() {\n  // Keypad scanning logic parses digits\n  // If enteredCode == SECRET_CODE:\n  // lockServo.write(90); delay(3000); lockServo.write(0);\n}",
                "codeExplanation": "- SECRET_CODE stores the 4-digit master passkey.\n- lockServo.write(0) extends the deadbolt into the locked position.\n- Upon passcode match, lockServo.write(90) pulls back the bolt to open.",
                "verificationCheckpoints": [
                    "Understand deadbolt angle positions (0 vs 90)",
                    "Understand passcode buffer matching"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Passcode Validation Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch and tap digits '1234' on the keypad. The servo deadbolt should swing open for 3 seconds!",
                "verificationCheckpoints": [
                    "Entering '1234' unlocks deadbolt",
                    "Wrong passcode sounds warning beep"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Vault secured! You built a real physical access control system with matrix scanning and servo mechanics.",
                "verificationCheckpoints": [
                    "Ready to claim Smart Security badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Keypad presses do not register",
                "cause": "Keypad ribbon inverted 180 degrees",
                "solution": "Unplug the 8-pin keypad ribbon and reverse its pin connection.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Verify ribbon cable row/column order against pin table.",
                    "Ensure keypad library #include <Keypad.h> is installed in Arduino IDE."
                ]
            }
        ]
    },
    "proj_05": {
        "story": "Build an unhackable desktop alarm clock! You will wire a precision DS3231 real-time clock module with battery backup, an I2C 1602 liquid crystal display, and an alarm buzzer that ensures you never miss morning monster training.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Clock Components",
                "type": "gatherParts",
                "instructions": "Collect the DS3231 RTC module (with CR2032 coin cell), 1602 I2C LCD display, piezo buzzer, and breadboard jumpers.",
                "verificationCheckpoints": [
                    "DS3231 RTC module ready with coin cell battery",
                    "1602 LCD with black I2C backpack board attached",
                    "Active buzzer ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "I2C Shared Bus Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect both the RTC and LCD to the Arduino I2C bus. Because I2C uses unique hardware addresses, both devices share SDA (A4) and SCL (A5) lines!",
                "wiringConnections": [
                    {
                        "from": "DS3231 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "DS3231 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "DS3231 SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "DS3231 SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "LCD GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "LCD SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "Buzzer (+)",
                        "to": "Arduino Pin 8",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Buzzer (-)",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "Both SDA pins connected to A4",
                    "Both SCL pins connected to A5",
                    "Buzzer connected to Pin 8"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "I2C Bus Pre-Flight Check",
                "type": "wiringCheck",
                "instructions": "Verify that neither I2C device has crossed lines between SDA and SCL, and verify 5V power rails.",
                "verificationCheckpoints": [
                    "Power rail 5V connected to Red bus",
                    "Ground rail connected to Dark Slate bus",
                    "No crossed signal wires between A4 and A5"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Clock Synchronization",
                "type": "codeReview",
                "instructions": "Study how the RTClib library queries time registers over I2C and prints formatted HH:MM:SS text to the LiquidCrystal_I2C screen.",
                "codeSnippet": "#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n#include \"RTClib.h\"\n\nRTC_DS3231 rtc;\nLiquidCrystal_I2C lcd(0x27, 16, 2);\nconst int BUZZER_PIN = 8;\nconst int ALARM_HOUR = 7;\nconst int ALARM_MIN = 30;\n\nvoid setup() {\n  Wire.begin();\n  lcd.init();\n  lcd.backlight();\n  rtc.begin();\n  pinMode(BUZZER_PIN, OUTPUT);\n}\n\nvoid loop() {\n  DateTime now = rtc.now();\n  lcd.setCursor(0, 0);\n  lcd.print(\"TIME: \");\n  if (now.hour() < 10) lcd.print('0');\n  lcd.print(now.hour());\n  lcd.print(':');\n  if (now.minute() < 10) lcd.print('0');\n  lcd.print(now.minute());\n  lcd.print(':');\n  if (now.second() < 10) lcd.print('0');\n  lcd.print(now.second());\n\n  if (now.hour() == ALARM_HOUR && now.minute() == ALARM_MIN) {\n    tone(BUZZER_PIN, 1500, 200);\n  }\n  delay(500);\n}",
                "codeExplanation": "- Wire.h manages I2C bus communication between Arduino, RTC, and LCD.\n- rtc.now() queries battery-backed time from the DS3231 oscillator.\n- lcd.print() draws formatted two-digit time strings on row 0.\n- When current hour and minute match alarm settings, tone() sounds.",
                "verificationCheckpoints": [
                    "Understand how 2 devices share 2 I2C wires via unique addresses (0x68 and 0x27)",
                    "Understand time comparison logic for alarm trigger"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Clock Verification Test",
                "type": "uploadSketch",
                "instructions": "Upload the alarm clock sketch. Adjust the blue contrast potentiometer on the back of the LCD with a small screwdriver until characters appear crisp and sharp.",
                "verificationCheckpoints": [
                    "LCD displays live advancing seconds",
                    "Adjust contrast trimmer so black text is clear against blue backlight"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Congratulations! You mastered multi-device I2C bus arbitration and built a functional real-time clock.",
                "verificationCheckpoints": [
                    "RTC retains time even when USB unplugged",
                    "Ready to claim Time Master badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "LCD shows 16 solid white boxes and no text",
                "cause": "Contrast potentiometer out of adjustment or wrong I2C address",
                "solution": "Turn the blue potentiometer on the back of the LCD module until text appears, or verify whether I2C address is 0x27 or 0x3F.",
                "category": "logic",
                "diagnosticSteps": [
                    "Turn the brass contrast trimmer screw on the back of the I2C backpack.",
                    "Run an I2C scanner sketch to verify if address is 0x27 or 0x3F."
                ]
            },
            {
                "symptom": "Time resets to 2000/01/01 every time USB is unplugged",
                "cause": "DS3231 coin cell battery missing or dead",
                "solution": "Insert a fresh CR2032 3V coin cell battery into the RTC battery holder.",
                "category": "power",
                "diagnosticSteps": [
                    "Check CR2032 coin battery orientation (+ side facing up).",
                    "Verify battery contacts are clean and tight."
                ]
            }
        ]
    },
    "proj_06": {
        "story": "Build a laboratory environmental safety sentinel! Construct an air quality monitor utilizing the MQ-9 gas sensor, 1602 LCD telemetry readout, and multi-stage audio/visual danger alarms.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Safety Components",
                "type": "gatherParts",
                "instructions": "Collect the MQ-9 Gas Sensor module, 1602 I2C LCD, Piezo Buzzer, and Red/Green status LEDs.",
                "verificationCheckpoints": [
                    "MQ-9 sensor with stainless steel mesh head ready",
                    "1602 I2C LCD ready",
                    "Piezo buzzer ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Sensor & Alarm Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect MQ-9 analog pin to Arduino A0. Connect 1602 LCD to I2C lines (A4/A5), and Buzzer to Digital Pin 8.",
                "wiringConnections": [
                    {
                        "from": "MQ-9 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "MQ-9 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "MQ-9 AOUT",
                        "to": "Arduino Pin A0",
                        "wire": "Yellow",
                        "type": "analogIn"
                    },
                    {
                        "from": "LCD SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "LCD GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "Buzzer (+)",
                        "to": "Arduino Pin 8",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Buzzer (-)",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "AOUT on A0",
                    "LCD on A4/A5",
                    "Buzzer on Pin 8"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Heater Inspection",
                "type": "wiringCheck",
                "instructions": "IMPORTANT: MQ gas sensors contain an internal micro-heating coil. The metal grill will get noticeably warm to the touch \u2014 this is normal operation! Do not touch metal mesh directly.",
                "verificationCheckpoints": [
                    "Inspect wiring for short circuits",
                    "Ensure MQ-9 is elevated off flammable surfaces"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Threshold Alarm Logic",
                "type": "codeReview",
                "instructions": "Examine how analog read values are mapped to air quality PPM safety zones and alert thresholds.",
                "codeSnippet": "#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\nLiquidCrystal_I2C lcd(0x27, 16, 2);\nconst int MQ_PIN = A0;\nconst int BUZZER_PIN = 8;\nconst int THRESHOLD_ALERT = 350;\n\nvoid setup() {\n  lcd.init();\n  lcd.backlight();\n  pinMode(BUZZER_PIN, OUTPUT);\n}\n\nvoid loop() {\n  int airQuality = analogRead(MQ_PIN);\n  lcd.setCursor(0, 0);\n  lcd.print(\"Gas Level: \");\n  lcd.print(airQuality);\n  lcd.print(\"    \");\n\n  lcd.setCursor(0, 1);\n  if (airQuality > THRESHOLD_ALERT) {\n    lcd.print(\"STATUS: DANGER! \");\n    tone(BUZZER_PIN, 2500, 100);\n  } else {\n    lcd.print(\"STATUS: SAFE    \");\n    noTone(BUZZER_PIN);\n  }\n  delay(250);\n}",
                "codeExplanation": "- analogRead(MQ_PIN) measures resistance changes across the heated tin dioxide (SnO2) sensing element.\n- Values below 300 represent clean ambient air.\n- Values above 350 trigger the LCD DANGER warning and sound the alarm.",
                "verificationCheckpoints": [
                    "Understand how SnO2 resistance drops in presence of combustible gas",
                    "Understand hysteresis threshold checking"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Simulation Test",
                "type": "uploadSketch",
                "instructions": "Upload the code. Allow sensor 3 minutes to warm up. Simulate gas detection safely using an unlit butane lighter puff under adult supervision.",
                "verificationCheckpoints": [
                    "Sensor warmup readings stabilize",
                    "Simulated gas puff causes PPM to spike past 350 and sounds alarm"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Safety mission complete! You built a critical environmental monitor and mastered analog gas telemetry.",
                "verificationCheckpoints": [
                    "Ready to claim Safety Officer badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Sensor metal cap feels warm",
                "cause": "Internal heater coil operating normally",
                "solution": "This is completely normal and required for chemical reduction measurement. Keep away from bare skin.",
                "category": "power",
                "diagnosticSteps": [
                    "This is normal: MQ gas sensors have internal 5V heaters.",
                    "Wait 3 minutes for heater stabilization before testing gas."
                ]
            },
            {
                "symptom": "Alarm triggers immediately on power up",
                "cause": "Sensor requires burn-in preheating period after being unpowered",
                "solution": "Allow the sensor to run for 2-3 minutes until internal chemistry stabilizes.",
                "category": "logic",
                "diagnosticSteps": [
                    "Allow 2-3 minutes preheat burn-in cycle in clean air.",
                    "Tune threshold potentiometer until alarm SILENCES in fresh air."
                ]
            }
        ]
    },
    "proj_07": {
        "story": "Build an automated Monster ATM and snack treat dispenser! Your monster customers enter their secret 4-digit PIN on the matrix keypad; if approved, the LCD welcomes them and a servo arm sweeps open the vault chute to dispense a treat.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Dispenser Hardware",
                "type": "gatherParts",
                "instructions": "Gather the 4x4 membrane keypad, 1602 I2C LCD, SG90 micro-servo motor, and cardboard chute or cup.",
                "verificationCheckpoints": [
                    "4x4 Matrix keypad ready",
                    "1602 LCD with I2C backpack ready",
                    "SG90 micro servo with arm attached"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "ATM Circuit Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect LCD to A4/A5 I2C lines. Connect keypad rows to pins 9-6 and columns to pins 5-2. Connect Servo PWM signal to Pin 10.",
                "wiringConnections": [
                    {
                        "from": "LCD SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "LCD GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "Keypad Rows",
                        "to": "Pins 9, 8, 7, 6",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Keypad Cols",
                        "to": "Pins 5, 4, 3, 2",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Servo Signal",
                        "to": "Arduino Pin 10",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Servo 5V",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "Servo GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "Keypad pins matched sequentially 9 through 2",
                    "Servo signal on Pin 10"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Mechanical Sweep Check",
                "type": "wiringCheck",
                "instructions": "Ensure the servo dispenser door flap can rotate freely 90 degrees without binding against the dispenser wall.",
                "verificationCheckpoints": [
                    "Flap moves smoothly through 90 degree arc",
                    "Verify power lines have solid breadboard connections"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Banking State Machine",
                "type": "codeReview",
                "instructions": "Review how the Arduino manages banking states: AWAIT_PIN -> VALIDATING -> DISPENSING -> LOCKED.",
                "codeSnippet": "#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n#include <Servo.h>\n\nLiquidCrystal_I2C lcd(0x27, 16, 2);\nServo dispenserServo;\nconst String MASTER_PIN = \"7788\";\nString inputPin = \"\";\n\nvoid setup() {\n  lcd.init();\n  lcd.backlight();\n  dispenserServo.attach(10);\n  dispenserServo.write(0); // Chute closed\n  lcd.setCursor(0, 0);\n  lcd.print(\"MONSTER ATM: PIN\");\n}\n\nvoid dispenseReward() {\n  lcd.clear();\n  lcd.print(\"ACCESS GRANTED!\");\n  dispenserServo.write(90); // Open chute\n  delay(2000);\n  dispenserServo.write(0);  // Close chute\n  lcd.clear();\n  lcd.print(\"MONSTER ATM: PIN\");\n}",
                "codeExplanation": "- State machine prompts user for 4-digit PIN on the LCD.\n- Keys typed are accumulated into inputPin string.\n- When inputPin == MASTER_PIN, dispenseReward() triggers servo to swing 90 degrees for 2 seconds.\n- After dispensing, door closes and system re-locks automatically.",
                "verificationCheckpoints": [
                    "Understand string accumulation for keypad digits",
                    "Understand timed servo actuation for mechanical dispensing"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Dispense Verification Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch, load a candy or bead into the chute, type PIN '7788' and press '#' to watch your ATM dispense!",
                "verificationCheckpoints": [
                    "Key presses appear as asterisks on LCD",
                    "Correct PIN opens servo chute and drops treat"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Bravo! You integrated user interaction, display feedback, and mechanical actuation into a complete product.",
                "verificationCheckpoints": [
                    "Ready to claim Inventor badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Servo twitches and resets Arduino when activating",
                "cause": "Servo inrush current causes 5V rail voltage drop (brownout)",
                "solution": "Add a 100uF electrolytic capacitor across 5V and GND near the servo power pins.",
                "category": "power",
                "diagnosticSteps": [
                    "Servo draws high inrush current causing brownout reset.",
                    "Add external 4xAA battery pack with shared ground to Arduino GND."
                ]
            }
        ]
    },
    "proj_08": {
        "story": "Build a Dual Motor Control command deck! Harness analog joystick vectors to drive both a high-speed DC motor (via L293D H-Bridge driver) and a precision 28BYJ-48 stepper motor (via ULN2003 Darlington array).",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Motor Drivers",
                "type": "gatherParts",
                "instructions": "Collect the 28BYJ-48 Stepper Motor + ULN2003 Driver Board, 130 DC Motor + L293D Driver IC, Analog Joystick module, and 10k potentiometer.",
                "verificationCheckpoints": [
                    "28BYJ-48 5V stepper motor ready",
                    "ULN2003 driver board with 4 red indicator LEDs ready",
                    "L293D dual H-bridge motor driver chip ready",
                    "Analog thumb joystick ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Driver Shield & Joystick Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect ULN2003 inputs to pins 8-11. Connect L293D PWM enable to Pin 5 and direction to Pin 4. Connect Joystick X to A0 and Y to A1.",
                "wiringConnections": [
                    {
                        "from": "ULN2003 IN1-IN4",
                        "to": "Pins 8, 9, 10, 11",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "ULN2003 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "ULN2003 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "L293D Enable 1 (PWM)",
                        "to": "Arduino Pin 5",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "L293D IN1 (Dir)",
                        "to": "Arduino Pin 4",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Joystick X",
                        "to": "Arduino Pin A0",
                        "wire": "Yellow",
                        "type": "analogIn"
                    },
                    {
                        "from": "Joystick Y",
                        "to": "Arduino Pin A1",
                        "wire": "Yellow",
                        "type": "analogIn"
                    },
                    {
                        "from": "Joystick VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "Joystick GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "ULN2003 stepper inputs matched sequentially",
                    "Joystick connected to A0 and A1"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Motor Power Isolation",
                "type": "wiringCheck",
                "instructions": "Check that the DC motor has a flyback suppression capacitor or diode across its terminals to prevent inductive voltage spikes from damaging the Arduino.",
                "verificationCheckpoints": [
                    "Motor wiring clear of breadboard shorts",
                    "Motor shafts free to spin without obstruction"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Dual Actuation",
                "type": "codeReview",
                "instructions": "Study how Stepper library generates 4-phase step sequences while analogRead maps joystick displacement to PWM motor speed.",
                "codeSnippet": "#include <Stepper.h>\n\nconst int STEPS_PER_REV = 2048;\nStepper myStepper(STEPS_PER_REV, 8, 10, 9, 11);\nconst int DC_PWM_PIN = 5;\nconst int DC_DIR_PIN = 4;\n\nvoid setup() {\n  myStepper.setSpeed(10);\n  pinMode(DC_PWM_PIN, OUTPUT);\n  pinMode(DC_DIR_PIN, OUTPUT);\n}\n\nvoid loop() {\n  int joyX = analogRead(A0);\n  int joyY = analogRead(A1);\n\n  // Stepper positioning via X-axis\n  if (joyX > 600) myStepper.step(20);\n  else if (joyX < 400) myStepper.step(-20);\n\n  // DC motor throttle via Y-axis\n  int speed = map(abs(joyY - 512), 50, 512, 0, 255);\n  speed = constrain(speed, 0, 255);\n  digitalWrite(DC_DIR_PIN, joyY > 512 ? HIGH : LOW);\n  analogWrite(DC_PWM_PIN, speed);\n}",
                "codeExplanation": "- myStepper(2048, 8, 10, 9, 11) initializes 4-step sequence for internal 64:1 reduction gearing.\n- Pushing joystick X left/right steps the motor in discrete micro-steps.\n- Pushing joystick Y controls DC motor PWM speed and rotational direction.",
                "verificationCheckpoints": [
                    "Understand difference between continuous DC rotation vs discrete stepper stepping",
                    "Understand PWM speed control with analogWrite"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Flight Control Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch and maneuver joystick in all directions to verify simultaneous stepper indexing and DC motor variable throttle.",
                "verificationCheckpoints": [
                    "Stepper indexes smoothly with joystick X",
                    "DC motor accelerates smoothly with joystick Y"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Command deck operational! You mastered multi-motor control across both continuous and stepper domains.",
                "verificationCheckpoints": [
                    "Ready to claim Motor Dynamo badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Stepper motor vibrates and buzzes but does not rotate",
                "cause": "Sequence coil pins 9 and 10 are reversed in stepper constructor",
                "solution": "Use pin order (8, 10, 9, 11) in Stepper constructor for 28BYJ-48 motors.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Check 4-phase sequence wires (IN1 to IN4) on driver board.",
                    "Ensure 5V power supply has enough current (>500mA)."
                ]
            }
        ]
    },
    "proj_09": {
        "story": "Build a high-security Contactless RFID monster lock! Read 13.56 MHz Mifare RFID cards and keyfobs over the SPI bus, authorize authorized serial badges, and actuate a micro-servo deadbolt.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather RFID Hardware",
                "type": "gatherParts",
                "instructions": "Collect the RC522 13.56MHz RFID Reader/Writer module, RFID white card, blue RFID keyfob, SG90 servo, and buzzer.",
                "verificationCheckpoints": [
                    "RC522 module with 8 header pins ready",
                    "RFID white card and blue keyfob ready",
                    "SG90 servo motor ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "3.3V SPI Bus Wiring",
                "type": "breadboardWiring",
                "instructions": "CRITICAL: Connect RC522 VCC to 3.3V ONLY (NEVER 5V or you will fry the chip!). Connect SPI pins: MOSI to 11, MISO to 12, SCK to 13, SDA/SS to 10, RST to 9.",
                "wiringConnections": [
                    {
                        "from": "RC522 VCC",
                        "to": "Arduino 3.3V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "RC522 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "RC522 RST",
                        "to": "Arduino Pin 9",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "RC522 SDA(SS)",
                        "to": "Arduino Pin 10",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "RC522 MOSI",
                        "to": "Arduino Pin 11",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "RC522 MISO",
                        "to": "Arduino Pin 12",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "RC522 SCK",
                        "to": "Arduino Pin 13",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "Servo Signal",
                        "to": "Arduino Pin 6",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Buzzer (+)",
                        "to": "Arduino Pin 7",
                        "wire": "Green",
                        "type": "digitalOut"
                    }
                ],
                "verificationCheckpoints": [
                    "VCC connected strictly to 3.3V pin",
                    "SPI bus pins 11, 12, 13 firmly seated"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight 3.3V Voltage Verification",
                "type": "wiringCheck",
                "instructions": "STOP AND DOUBLE CHECK: Verify with your eyes that the RC522 red wire goes into the Arduino '3.3V' socket, NOT '5V'.",
                "verificationCheckpoints": [
                    "Power lead strictly in 3.3V header",
                    "No bridged solder connections on RC522 header"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & UID Authentication",
                "type": "codeReview",
                "instructions": "Review how the MFRC522 library queries tag UIDs and checks against authorized master card credentials.",
                "codeSnippet": "#include <SPI.h>\n#include <MFRC522.h>\n#include <Servo.h>\n\n#define RST_PIN 9\n#define SS_PIN 10\nMFRC522 mfrc522(SS_PIN, RST_PIN);\nServo lockServo;\n\nbyte masterUID[4] = {0xDE, 0xAD, 0xBE, 0xEF}; // Replace with your card UID\n\nvoid setup() {\n  Serial.begin(9600);\n  SPI.begin();\n  mfrc522.PCD_Init();\n  lockServo.attach(6);\n  lockServo.write(0); // Locked\n}\n\nvoid loop() {\n  if (!mfrc522.PICC_IsNewCardPresent() || !mfrc522.PICC_ReadCardSerial()) return;\n\n  bool match = true;\n  for (byte i = 0; i < 4; i++) {\n    if (mfrc522.uid.uidByte[i] != masterUID[i]) match = false;\n  }\n\n  if (match) {\n    lockServo.write(90); // Unlock\n    delay(3000);\n    lockServo.write(0);  // Re-lock\n  }\n  mfrc522.PICC_HaltA();\n}",
                "codeExplanation": "- SPI.begin() initializes high-speed hardware SPI clock and data lines.\n- mfrc522.PICC_ReadCardSerial() reads the 4-byte or 7-byte unique identifier (UID) from the tag.\n- The loop compares the scanned UID byte-by-byte with masterUID.\n- If matched, the deadbolt rotates 90 degrees for 3 seconds.",
                "verificationCheckpoints": [
                    "Understand how 13.56 MHz electromagnetic coupling powers passive tag chip",
                    "Understand UID byte comparison array"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Tag Enrollment Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch and tap your card to serial monitor to view its unique UID. Update the masterUID array with your card's numbers and re-upload to unlock your door!",
                "verificationCheckpoints": [
                    "Serial monitor prints card UID hex values",
                    "Authorized card unlocks servo deadbolt"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Access Granted! You built a commercial-grade contactless RFID security gate.",
                "verificationCheckpoints": [
                    "Ready to claim RFID Guardian badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "RFID reader does not detect cards at all",
                "cause": "VCC wire plugged into 5V (which can damage chip) or poor SPI connection on Pin 13",
                "solution": "Ensure VCC is plugged into 3.3V and check that SCK pin is securely connected to Pin 13.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Check RC522 VCC wire: strictly 3.3V (5V will damage it).",
                    "Inspect SPI jumper connections: MOSI 11, MISO 12, SCK 13."
                ]
            }
        ]
    },
    "proj_10": {
        "story": "Operate heavy industrial robotic drilling equipment! Construct an automated Oil Drill Rig where an incremental rotary encoder with push-button controls stepper drilling depth with precision micrometer readouts on an I2C LCD screen.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Drill Rig Components",
                "type": "gatherParts",
                "instructions": "Collect the KY-040 Rotary Encoder module, 28BYJ-48 Stepper Motor + ULN2003 driver, 1602 I2C LCD display, and breadboard.",
                "verificationCheckpoints": [
                    "KY-040 rotary click encoder ready",
                    "28BYJ-48 Stepper with reduction gear shaft ready",
                    "ULN2003 driver board ready",
                    "1602 LCD with I2C backpack ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Rig Telemetry & Driver Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect Rotary Encoder CLK to Pin 2 and DT to Pin 3 (hardware interrupt pins). Connect ULN2003 driver to pins 8-11 and LCD to A4/A5.",
                "wiringConnections": [
                    {
                        "from": "Encoder CLK",
                        "to": "Arduino Pin 2 (INT0)",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Encoder DT",
                        "to": "Arduino Pin 3 (INT1)",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Encoder SW (Button)",
                        "to": "Arduino Pin 4",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Encoder VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "Encoder GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "ULN2003 IN1-IN4",
                        "to": "Pins 8, 10, 9, 11",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "LCD SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    }
                ],
                "verificationCheckpoints": [
                    "Encoder CLK connected specifically to Pin 2 for hardware interrupt support",
                    "LCD on A4/A5"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Rig Safety Check",
                "type": "wiringCheck",
                "instructions": "Ensure the drill bit shaft has vertical clearance to lower and raise without snagging cables.",
                "verificationCheckpoints": [
                    "Stepper wires not tangled",
                    "Encoder knob clicks cleanly in both directions"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Quadrature Decoding",
                "type": "codeReview",
                "instructions": "Examine how hardware interrupts on Pin 2 decode 2-bit Gray code quadrature pulses to determine rotation direction.",
                "codeSnippet": "#include <Stepper.h>\n#include <LiquidCrystal_I2C.h>\n\nLiquidCrystal_I2C lcd(0x27, 16, 2);\nStepper drillStepper(2048, 8, 10, 9, 11);\nconst int ENCODER_CLK = 2;\nconst int ENCODER_DT = 3;\nvolatile int drillDepthMm = 0;\n\nvoid readEncoder() {\n  int dtVal = digitalRead(ENCODER_DT);\n  if (dtVal == HIGH) drillDepthMm++;\n  else drillDepthMm--;\n}\n\nvoid setup() {\n  lcd.init(); lcd.backlight();\n  drillStepper.setSpeed(12);\n  pinMode(ENCODER_CLK, INPUT_PULLUP);\n  pinMode(ENCODER_DT, INPUT_PULLUP);\n  attachInterrupt(digitalPinToInterrupt(ENCODER_CLK), readEncoder, FALLING);\n}\n\nvoid loop() {\n  lcd.setCursor(0, 0);\n  lcd.print(\"DRILL DEPTH:    \");\n  lcd.setCursor(0, 1);\n  lcd.print(drillDepthMm);\n  lcd.print(\" mm            \");\n  delay(100);\n}",
                "codeExplanation": "- attachInterrupt() executes readEncoder immediately whenever CLK falls, with zero missed clicks.\n- Checking DT state determines whether rotation was clockwise (drilling down) or counter-clockwise (retracting).\n- LCD renders depth telemetry in real time.",
                "verificationCheckpoints": [
                    "Understand how 90-degree phase shift in quadrature pulses indicates direction",
                    "Understand why hardware interrupts prevent missed encoder steps"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Drilling Simulation Test",
                "type": "uploadSketch",
                "instructions": "Upload code, turn the rotary knob clockwise to lower drill bit, and push the knob down to trigger high-speed auto-retract!",
                "verificationCheckpoints": [
                    "Clockwise rotation increments depth readout",
                    "Counter-clockwise rotation decrements depth"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Mission Accomplished! You built an industrial-grade precision positioning mechanism.",
                "verificationCheckpoints": [
                    "Ready to claim Industrial Chief badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Encoder skips numbers or increments randomly",
                "cause": "Mechanical switch bouncing",
                "solution": "Add small 10nF ceramic capacitors between CLK/DT and GND, or add a 5ms software debounce filter.",
                "category": "logic",
                "diagnosticSteps": [
                    "Check CLK and DT pull-up resistors or software debouncing.",
                    "Verify interrupt service routine has no delay() calls."
                ]
            }
        ]
    },
    "proj_11": {
        "story": "Build an Autonomous Sentry Turret! Construct a dual-axis pan/tilt motorized gimbal armed with an ultrasonic sonar radar and a visible red targeting laser that automatically sweeps the perimeter and locks onto approaching targets.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Turret Mechanics",
                "type": "gatherParts",
                "instructions": "Collect 2x SG90 servo motors, HC-SR04 ultrasonic sensor, KY-008 Laser diode module, piezo buzzer, and cardboard turret brackets.",
                "verificationCheckpoints": [
                    "2x SG90 servo motors with dual horns ready",
                    "HC-SR04 ultrasonic sensor ready",
                    "KY-008 650nm Red Laser diode ready",
                    "Piezo buzzer ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Pan-Tilt Turret Wiring",
                "type": "breadboardWiring",
                "instructions": "Wire Pan Servo to Pin 9, Tilt Servo to Pin 10, Laser to Pin 6, Buzzer to Pin 7, and Ultrasonic TRIG/ECHO to pins 11/12.",
                "wiringConnections": [
                    {
                        "from": "Pan Servo Signal",
                        "to": "Arduino Pin 9",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Tilt Servo Signal",
                        "to": "Arduino Pin 10",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Laser (+) Pin",
                        "to": "Arduino Pin 6",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "Laser (-) Pin",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "Buzzer (+)",
                        "to": "Arduino Pin 7",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "HC-SR04 TRIG",
                        "to": "Arduino Pin 11",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "HC-SR04 ECHO",
                        "to": "Arduino Pin 12",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "HC-SR04 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "HC-SR04 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "Servos connected to PWM pins 9 and 10",
                    "Laser (+) connected to Pin 6 with ground to Dark Slate rail"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Laser Safety Briefing",
                "type": "wiringCheck",
                "instructions": "CRITICAL LASER SAFETY: Never point the laser into anyone's eyes or look directly into the beam aperture. Test only against a non-reflective wall or paper target.",
                "verificationCheckpoints": [
                    "Turret pointed toward empty wall target area",
                    "Mechanical brackets tightly screwed"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Radar Sweep Algorithm",
                "type": "codeReview",
                "instructions": "Review how the pan servo sweeps 30 to 150 degrees while sonar calculates obstacle coordinates and activates target tracking lock.",
                "codeSnippet": "#include <Servo.h>\n\nServo panServo;\nServo tiltServo;\nconst int LASER_PIN = 6;\nconst int BUZZER_PIN = 7;\nconst int TRIG_PIN = 11;\nconst int ECHO_PIN = 12;\n\nvoid setup() {\n  panServo.attach(9);\n  tiltServo.attach(10);\n  pinMode(LASER_PIN, OUTPUT);\n  pinMode(BUZZER_PIN, OUTPUT);\n  pinMode(TRIG_PIN, OUTPUT);\n  pinMode(ECHO_PIN, INPUT);\n  tiltServo.write(90); // Level horizon\n}\n\nfloat pingDistance() {\n  digitalWrite(TRIG_PIN, LOW); delayMicroseconds(2);\n  digitalWrite(TRIG_PIN, HIGH); delayMicroseconds(10);\n  digitalWrite(TRIG_PIN, LOW);\n  return pulseIn(ECHO_PIN, HIGH) * 0.0343 / 2.0;\n}\n\nvoid loop() {\n  for (int angle = 30; angle <= 150; angle += 5) {\n    panServo.write(angle);\n    delay(40);\n    float d = pingDistance();\n    if (d > 0 && d < 25.0) { // Target lock!\n      digitalWrite(LASER_PIN, HIGH);\n      tone(BUZZER_PIN, 3000, 100);\n      delay(500);\n      digitalWrite(LASER_PIN, LOW);\n    }\n  }\n}",
                "codeExplanation": "- The pan servo sweeps continuously in 5-degree increments across 120 degrees of field of view.\n- At each angle, pingDistance() samples obstacle range.\n- If an obstacle appears within 25cm, turret halts, illuminates laser target dot, and sounds audio lock chirp.",
                "verificationCheckpoints": [
                    "Understand radar scanning sweep loop",
                    "Understand target lock condition and actuator sequence"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Turret Engagement Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch, place target box 20cm away within sweep sector, and observe autonomous radar tracking lock-on!",
                "verificationCheckpoints": [
                    "Turret sweeps back and forth smoothly",
                    "Targets trigger laser pulse and alert tone"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Turret defense active! You mastered pan-tilt robotic kinematics and sensor-guided target acquisition.",
                "verificationCheckpoints": [
                    "Ready to claim Turret Commander badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Servos violently jitter during radar sweep",
                "cause": "Both servos drawing peak current simultaneously from Arduino 5V rail",
                "solution": "Add a separate 5V power supply for the servos with shared ground, or add a large 470uF decoupling capacitor across power rails.",
                "category": "power",
                "diagnosticSteps": [
                    "Two servos exceed 500mA USB limit simultaneously.",
                    "Power servo rail with external 5V/6V supply and bridge GNDs."
                ]
            }
        ]
    },
    "proj_12": {
        "story": "Build an Automated Environmental & Floodgate Station! Monitor environmental conditions with DHT11 temperature/humidity, FC-37 raindrop plate, and water level depth sensor. If rainfall exceeds capacity, an emergency servo floodgate opens automatically.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Hydrological Sensors",
                "type": "gatherParts",
                "instructions": "Collect the DHT11 temp/humidity sensor, FC-37 rain sensor module, Water Level depth sensor, 1602 LCD, and SG90 servo floodgate.",
                "verificationCheckpoints": [
                    "DHT11 blue digital temperature/humidity sensor ready",
                    "FC-37 nickel-plated rain sensor board ready",
                    "Submersible water depth sensor plate ready",
                    "SG90 servo motor ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Sensor Matrix Wiring",
                "type": "breadboardWiring",
                "instructions": "Wire DHT11 to Pin 2, Rain Sensor Analog to A1, Water Depth Sensor to A2, Servo to Pin 9, and LCD to A4/A5.",
                "wiringConnections": [
                    {
                        "from": "DHT11 DATA",
                        "to": "Arduino Pin 2",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "DHT11 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "DHT11 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "Rain Plate A0",
                        "to": "Arduino Pin A1",
                        "wire": "Yellow",
                        "type": "analogIn"
                    },
                    {
                        "from": "Water Level S",
                        "to": "Arduino Pin A2",
                        "wire": "Yellow",
                        "type": "analogIn"
                    },
                    {
                        "from": "Servo PWM",
                        "to": "Arduino Pin 9",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "LCD SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    }
                ],
                "verificationCheckpoints": [
                    "Rain sensor in A1, Water depth in A2",
                    "DHT11 data line has 10k pull-up resistor or onboard module resistor"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight Waterproof Inspection",
                "type": "wiringCheck",
                "instructions": "WATER SAFETY CHECK: Only the sensing traces of the water probe may touch water. Never submerge the Arduino board, breadboard, or servo motor in liquid!",
                "verificationCheckpoints": [
                    "Breadboard and Arduino kept on dry towel",
                    "Water cup kept separate from electronics"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Reservoir Management",
                "type": "codeReview",
                "instructions": "Review how the Arduino monitors rain presence and reservoir depth, triggering emergency floodgate evacuation if critical depth is reached.",
                "codeSnippet": "#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n#include <Servo.h>\n\nLiquidCrystal_I2C lcd(0x27, 16, 2);\nServo floodgateServo;\nconst int RAIN_PIN = A1;\nconst int WATER_PIN = A2;\nconst int FLOOD_LIMIT = 450;\n\nvoid setup() {\n  lcd.init(); lcd.backlight();\n  floodgateServo.attach(9);\n  floodgateServo.write(0); // Gate sealed\n}\n\nvoid loop() {\n  int rainVal = analogRead(RAIN_PIN);\n  int waterLevel = analogRead(WATER_PIN);\n\n  lcd.setCursor(0, 0);\n  lcd.print(\"Water: \"); lcd.print(waterLevel);\n  lcd.print(\" Rain: \"); lcd.print(rainVal < 600 ? \"Y\" : \"N\");\n\n  if (waterLevel > FLOOD_LIMIT) {\n    lcd.setCursor(0, 1);\n    lcd.print(\"FLOODGATE OPEN! \");\n    floodgateServo.write(90); // Open spillway\n  } else {\n    lcd.setCursor(0, 1);\n    lcd.print(\"RESERVOIR SAFE  \");\n    floodgateServo.write(0);  // Close spillway\n  }\n  delay(500);\n}",
                "codeExplanation": "- FC-37 resistance drops when water droplets bridge the nickel tracks (rainVal < 600 indicates rain).\n- Water level probe acts as variable resistor immersed in water (higher water = higher analog reading).\n- When waterLevel exceeds FLOOD_LIMIT (450), the servo gate swings 90 degrees to release water.",
                "verificationCheckpoints": [
                    "Understand how water conductivity decreases electrical resistance",
                    "Understand automated threshold protective response"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Spillway Verification Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Dip water probe into a shallow cup of water. When depth exceeds threshold, verify servo floodgate swings open!",
                "verificationCheckpoints": [
                    "LCD displays live water level",
                    "Dipping probe past threshold opens floodgate servo"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Reservoir protected! You built an automated environmental civil engineering defense station.",
                "verificationCheckpoints": [
                    "Ready to claim Earth Scientist badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Water level reading is erratic or fluctuating wildly",
                "cause": "Sensing traces have corrosion or static pickup",
                "solution": "Dry probe with paper towel, and connect probe GND directly to Arduino main ground pin.",
                "category": "wiring",
                "diagnosticSteps": [
                    "Wipe trace electrodes dry with paper towel.",
                    "Verify analog pin A0 wire has good breadboard grip."
                ]
            }
        ]
    },
    "proj_13": {
        "story": "Build an Autonomous Flight Control & Gimbal Autopilot! Read real-time pitch, roll, and angular acceleration from an MPU-6050 6-axis gyroscope/accelerometer over I2C, and actively counter external tilts using micro-servos to keep a camera platform perfectly level in mid-air.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Flight Avionics",
                "type": "gatherParts",
                "instructions": "Collect the MPU-6050 6-DOF IMU sensor module, SG90 servo motor, tactile momentary button, 1602 LCD, and breadboard.",
                "verificationCheckpoints": [
                    "MPU-6050 sensor board with onboard 3.3V regulator ready",
                    "SG90 servo motor with gimbal horn ready",
                    "Tactile push-button ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Avionics I2C Bus & Actuator Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect MPU-6050 to 5V, GND, SDA (A4), SCL (A5), and INT to Pin 2. Connect Servo to Pin 9, and LCD to shared I2C bus.",
                "wiringConnections": [
                    {
                        "from": "MPU-6050 VCC",
                        "to": "Arduino 5V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "MPU-6050 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "MPU-6050 SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "MPU-6050 SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "MPU-6050 INT",
                        "to": "Arduino Pin 2",
                        "wire": "Green",
                        "type": "digitalIn"
                    },
                    {
                        "from": "Gimbal Servo PWM",
                        "to": "Arduino Pin 9",
                        "wire": "Green",
                        "type": "digitalOut"
                    },
                    {
                        "from": "LCD SDA",
                        "to": "Arduino Pin A4",
                        "wire": "Blue",
                        "type": "i2c"
                    },
                    {
                        "from": "LCD SCL",
                        "to": "Arduino Pin A5",
                        "wire": "Blue",
                        "type": "i2c"
                    }
                ],
                "verificationCheckpoints": [
                    "MPU-6050 and LCD sharing I2C bus cleanly",
                    "Servo mounted to gimbal pivot bracket"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight IMU Calibration Orientation",
                "type": "wiringCheck",
                "instructions": "Keep the IMU completely flat and motionless on your desk during initial power-on calibration.",
                "verificationCheckpoints": [
                    "Board resting flat on level surface",
                    "Wires relaxed without pulling on IMU board"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Complementary Filter",
                "type": "codeReview",
                "instructions": "Review how the sketch fuses accelerometer gravity vectors with gyro angular rate integration to compute a drift-free tilt angle.",
                "codeSnippet": "#include <Wire.h>\n#include <Servo.h>\n\nconst int MPU_ADDR = 0x68;\nServo gimbalServo;\nint16_t ax, ay, az, gx, gy, gz;\n\nvoid setup() {\n  Wire.begin();\n  Wire.beginTransmission(MPU_ADDR);\n  Wire.write(0x6B); // PWR_MGMT_1 register\n  Wire.write(0);    // Wake up MPU-6050\n  Wire.endTransmission(true);\n\n  gimbalServo.attach(9);\n  gimbalServo.write(90);\n}\n\nvoid loop() {\n  Wire.beginTransmission(MPU_ADDR);\n  Wire.write(0x3B); // Starting register for accelerometer\n  Wire.endTransmission(false);\n  Wire.requestFrom(MPU_ADDR, 6, true);\n\n  ax = Wire.read() << 8 | Wire.read();\n  ay = Wire.read() << 8 | Wire.read();\n  az = Wire.read() << 8 | Wire.read();\n\n  // Calculate tilt angle in degrees from gravity vector\n  float angle = atan2(ay, az) * 180.0 / PI;\n  int servoAngle = constrain(90 - (int)angle, 0, 180);\n  gimbalServo.write(servoAngle);\n  delay(20);\n}",
                "codeExplanation": "- 0x6B register write wakes the MPU-6050 from sleep mode.\n- High and low bytes are combined (Wire.read() << 8 | Wire.read()) to form signed 16-bit acceleration values.\n- atan2(ay, az) calculates exact physical pitch angle from Earth's gravity vector.\n- Servo moves opposite to tilt angle (90 - angle), keeping platform level.",
                "verificationCheckpoints": [
                    "Understand how gravity vector reveals tilt angle",
                    "Understand negative feedback loop in gimbal stabilization"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Gimbal Active Leveling Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Pick up the breadboard and tilt it left and right: notice how the servo platform instantly tilts in reverse to stay horizontal!",
                "verificationCheckpoints": [
                    "Platform counters roll and pitch tilts",
                    "Platform remains horizontal during gentle motion"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Autopilot online! You engineered an active closed-loop inertial stabilization flight controller.",
                "verificationCheckpoints": [
                    "Ready to claim Autopilot Ace badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "MPU-6050 readings always return -1 or 0",
                "cause": "MPU-6050 didn't wake up or I2C address is 0x69 (if AD0 pin is high)",
                "solution": "Verify AD0 pin is tied to GND (sets address to 0x68) and ensure 0x6B wake-up command is sent in setup.",
                "category": "logic",
                "diagnosticSteps": [
                    "Write 0x00 to power management register 0x6B to wake from sleep.",
                    "Verify SDA on A4 and SCL on A5."
                ]
            }
        ]
    },
    "proj_14": {
        "story": "Master Long-Range Wireless Robot Teleoperation! Establish a 2.4 GHz digital packet radio link between two Arduinos using NRF24L01+ transceivers. Command robotic servos and steering mechanisms over the air from across the room!",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Radio Transceivers",
                "type": "gatherParts",
                "instructions": "Collect 2x Arduino boards, 2x NRF24L01+ 2.4GHz transceivers, 2x 10uF electrolytic capacitors, SG90 servo motor, and joystick.",
                "verificationCheckpoints": [
                    "2x NRF24L01+ 8-pin wireless modules ready",
                    "2x 10uF filter capacitors ready (vital for RF stability)",
                    "2x Arduino boards ready (e.g. Uno and Nano)"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Strict 3.3V RF SPI Wiring",
                "type": "breadboardWiring",
                "instructions": "WARNING: NRF24L01 requires strictly 3.3V power (5V destroys chip!). Connect CE to Pin 7, CSN to Pin 8, SCK to Pin 13, MOSI to Pin 11, MISO to Pin 12. Solder or place a 10uF capacitor directly across VCC and GND pins!",
                "wiringConnections": [
                    {
                        "from": "NRF24 VCC",
                        "to": "Arduino 3.3V",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "NRF24 GND",
                        "to": "Arduino GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    },
                    {
                        "from": "NRF24 CE",
                        "to": "Arduino Pin 7",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "NRF24 CSN",
                        "to": "Arduino Pin 8",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "NRF24 SCK",
                        "to": "Arduino Pin 13",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "NRF24 MOSI",
                        "to": "Arduino Pin 11",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "NRF24 MISO",
                        "to": "Arduino Pin 12",
                        "wire": "Orange",
                        "type": "spi"
                    },
                    {
                        "from": "Filter Cap (+)",
                        "to": "NRF24 VCC",
                        "wire": "Red",
                        "type": "power"
                    },
                    {
                        "from": "Filter Cap (-)",
                        "to": "NRF24 GND",
                        "wire": "Dark Slate",
                        "type": "ground"
                    }
                ],
                "verificationCheckpoints": [
                    "VCC connected to 3.3V only",
                    "10uF decoupling capacitor across VCC/GND pins",
                    "SPI lines connected to pins 11, 12, 13"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Pre-Flight 3.3V RF Power Verification",
                "type": "wiringCheck",
                "instructions": "DOUBLE-CHECK POWER: Check the 3.3V rail. NRF24 draws high-frequency current bursts; without the 10uF capacitor, the radio may fail to initialize.",
                "verificationCheckpoints": [
                    "Strict 3.3V verification",
                    "Decoupling capacitor polarity correct (stripe is negative)"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Radio Pipe Packets",
                "type": "codeReview",
                "instructions": "Review the RF24 protocol: opening write/read pipes, packing 32-byte payload structs, and receiving verified ACK packets.",
                "codeSnippet": "#include <SPI.h>\n#include <nRF24L01.h>\n#include <RF24.h>\n\nRF24 radio(7, 8); // CE, CSN\nconst byte address[6] = \"00001\";\n\nstruct PacketData {\n  int joyX;\n  int joyY;\n  byte button;\n};\n\nvoid setup() {\n  Serial.begin(9600);\n  radio.begin();\n  radio.openWritingPipe(address);\n  radio.setPALevel(RF24_PA_LOW);\n  radio.stopListening();\n}\n\nvoid loop() {\n  PacketData data;\n  data.joyX = analogRead(A0);\n  data.joyY = analogRead(A1);\n  data.button = digitalRead(2);\n\n  radio.write(&data, sizeof(PacketData));\n  delay(20);\n}",
                "codeExplanation": "- radio.begin() configures Nordic 2.4GHz GFSK transceiver hardware.\n- openWritingPipe sets a 5-byte physical radio frequency address shared between transmitter and receiver.\n- sizeof(PacketData) packs telemetry into an atomic radio frame transmitted at 1 Mbps.\n- Receiver unpacks data and drives servos with sub-5ms latency.",
                "verificationCheckpoints": [
                    "Understand 2.4GHz wireless pipe address matching",
                    "Understand struct packet serialization and deserialization"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Wireless Flight Range Test",
                "type": "uploadSketch",
                "instructions": "Upload transmitter code to Node 1 and receiver code to Node 2. Move 10 meters away and manipulate joystick to watch the remote servo respond instantly!",
                "verificationCheckpoints": [
                    "Transmitter packet LED confirms delivery",
                    "Remote servo moves in real-time across the room"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Wireless Mastery! You built a robust 2.4GHz teleoperation radio link for long-range robotics.",
                "verificationCheckpoints": [
                    "Ready to claim Wireless Wizard badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "radio.begin() fails or packets drop frequently",
                "cause": "3.3V rail voltage droop or missing filter capacitor",
                "solution": "Add a 10uF electrolytic capacitor directly across the NRF24 module's VCC and GND pins.",
                "category": "power",
                "diagnosticSteps": [
                    "Add a 10uF capacitor across NRF24L01 VCC and GND pins.",
                    "Ensure VCC is connected to 3.3V only (not 5V)."
                ]
            }
        ]
    },
    "proj_15": {
        "story": "Your greenhouse plants need constant moisture and temperature management while you're away! Build an autonomous environmental controller that reads soil conductivity and turns on a 5V relay water pump with LCD telemetry.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Components",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, Soil Moisture Sensor (comp_26), 5V Relay Module (comp_36), DHT11 Temp/Humidity (comp_09), 1602 I2C LCD (comp_07), Piezo Buzzer (comp_34), Breadboard, and jumper wires.",
                "verificationCheckpoints": [
                    "Soil moisture dual-probe clean and dry",
                    "5V relay optocoupler jumper in place",
                    "LCD backpack address verified (0x27 or 0x3F)"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect Soil Probe A0 to Arduino A0. Connect DHT11 DATA to Pin 2. Connect 5V Relay IN to Pin 7. Connect LCD SDA/SCL to A4/A5. Connect Buzzer to Pin 8.",
                "wiringConnections": [
                    {"from": "Soil Sensor A0", "to": "Arduino A0", "wire": "Yellow", "type": "analogIn"},
                    {"from": "DHT11 DATA", "to": "Arduino Pin 2", "wire": "Green", "type": "digitalIn"},
                    {"from": "Relay IN", "to": "Arduino Pin 7", "wire": "Blue", "type": "digitalOut"},
                    {"from": "LCD SDA", "to": "Arduino A4", "wire": "Orange", "type": "i2c"},
                    {"from": "LCD SCL", "to": "Arduino A5", "wire": "Yellow", "type": "i2c"},
                    {"from": "Buzzer (+)", "to": "Arduino Pin 8", "wire": "Red", "type": "digitalOut"}
                ],
                "verificationCheckpoints": [
                    "Common ground shared across all modules",
                    "Relay VCC wired to 5V power rail"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Wiring Verification & Safety",
                "type": "wiringCheck",
                "instructions": "Verify relay coil isolation. Ensure test pump is powered by a low-voltage battery pack (never wall AC).",
                "verificationCheckpoints": [
                    "DC power supply strictly under 12V",
                    "No short circuits on sensor power headers"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Hysteresis Logic",
                "type": "codeReview",
                "instructions": "Review closed-loop control: when soil moisture falls below DRY_THRESHOLD, the relay triggers the pump. When moisture exceeds MOIST_THRESHOLD, the pump turns off.",
                "codeSnippet": "#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n#include <DHT.h>\n\nLiquidCrystal_I2C lcd(0x27, 16, 2);\nDHT dht(2, DHT11);\nconst int RELAY_PIN = 7;\nconst int SOIL_PIN = A0;\n\nvoid setup() {\n  pinMode(RELAY_PIN, OUTPUT);\n  digitalWrite(RELAY_PIN, HIGH); // Active LOW off\n  lcd.init();\n  lcd.backlight();\n  dht.begin();\n}\n\nvoid loop() {\n  int soilVal = analogRead(SOIL_PIN);\n  float temp = dht.readTemperature();\n  lcd.setCursor(0, 0);\n  lcd.print(\"Soil: \"); lcd.print(soilVal);\n  lcd.setCursor(0, 1);\n  lcd.print(\"Temp: \"); lcd.print(temp); lcd.print(\"C\");\n  if (soilVal > 700) {\n    digitalWrite(RELAY_PIN, LOW); // Pump ON\n  } else if (soilVal < 400) {\n    digitalWrite(RELAY_PIN, HIGH); // Pump OFF\n  }\n  delay(1000);\n}",
                "codeExplanation": "- Hysteresis thresholding (700 on, 400 off) prevents rapid, damaging relay chatter.\n- DHT11 reads ambient room air temperature every second.\n- LCD renders real-time soil resistance and atmospheric climate telemetry.",
                "verificationCheckpoints": [
                    "Understand hysteresis deadband buffer",
                    "Verify relay active-LOW trigger behavior"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Irrigation Bench Test",
                "type": "uploadSketch",
                "instructions": "Upload the sketch. Keep probe in air to watch the relay click ON. Dip probe in a cup of water and observe the relay click OFF automatically!",
                "verificationCheckpoints": [
                    "Relay indicator LED illuminates when soil is dry",
                    "LCD updates temperature and soil values live"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Botany Master! Your automated greenhouse controller protects sensitive plants with precision watering.",
                "verificationCheckpoints": [
                    "Ready to claim Botanist badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Relay chatters on and off rapidly",
                "cause": "Threshold values are too close together without a hysteresis deadband",
                "solution": "Widen the gap between the turn-on (700) and turn-off (400) threshold constants.",
                "category": "logic",
                "diagnosticSteps": [
                    "Print raw analogRead(A0) to Serial Monitor",
                    "Ensure at least 200 units of separation between ON and OFF thresholds"
                ]
            }
        ]
    },
    "proj_16": {
        "story": "Secure the Monster Lab vault! Rig a 650nm red optical laser diode across the doorway to reflect into a light-dependent resistor (LDR). If any shadow or intruder breaks the beam, sound the alert sirens!",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Optical Hardware",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, KY-008 Laser Diode (comp_37), LDR Photoresistor (comp_19), 10k resistor, Active Buzzer (comp_34), Red LED, 220-ohm resistor, breadboard, and jumper wires.",
                "verificationCheckpoints": [
                    "KY-008 laser module ready",
                    "LDR leads intact and clean",
                    "10k pulldown resistor (Brown-Black-Orange-Gold)"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Optical Bench Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Wire KY-008 Laser Signal to Pin 7, Ground to GND. Wire LDR in voltage divider to A0 with 10k resistor to GND. Connect Buzzer to Pin 8 and Red LED to Pin 9.",
                "wiringConnections": [
                    {"from": "Laser Signal", "to": "Arduino Pin 7", "wire": "Red", "type": "digitalOut"},
                    {"from": "Laser GND", "to": "Arduino GND", "wire": "Dark Slate", "type": "ground"},
                    {"from": "LDR Pin 1", "to": "Arduino 5V", "wire": "Red", "type": "power"},
                    {"from": "LDR Pin 2", "to": "Arduino A0", "wire": "Yellow", "type": "analogIn"},
                    {"from": "Buzzer (+)", "to": "Arduino Pin 8", "wire": "Blue", "type": "digitalOut"},
                    {"from": "LED Anode", "to": "Arduino Pin 9", "wire": "Green", "type": "digitalOut"}
                ],
                "verificationCheckpoints": [
                    "Laser aimed safely toward LDR sensor face",
                    "10k resistor links A0 to GND"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Laser Safety Verification",
                "type": "wiringCheck",
                "instructions": "Position the breadboards so the laser beam projects horizontally onto the LDR. Never look directly into the laser aperture!",
                "verificationCheckpoints": [
                    "Laser beam points strictly at target paper / LDR",
                    "No reflective mirrors pointed at eye level"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Photometric Sampling",
                "type": "codeReview",
                "instructions": "Review the tripwire sketch: turns on the laser emitter, samples analog voltage from the LDR, and trips the alarm when light falls below calibrated threshold.",
                "codeSnippet": "const int LASER_PIN = 7;\nconst int LDR_PIN = A0;\nconst int BUZZER_PIN = 8;\nconst int LED_PIN = 9;\nint baselineLight = 0;\n\nvoid setup() {\n  pinMode(LASER_PIN, OUTPUT);\n  pinMode(BUZZER_PIN, OUTPUT);\n  pinMode(LED_PIN, OUTPUT);\n  digitalWrite(LASER_PIN, HIGH); // Fire laser beam\n  delay(500);\n  baselineLight = analogRead(LDR_PIN);\n}\n\nvoid loop() {\n  int currentLight = analogRead(LDR_PIN);\n  if (currentLight < (baselineLight - 150)) {\n    // Beam broken!\n    digitalWrite(LED_PIN, HIGH);\n    digitalWrite(BUZZER_PIN, HIGH);\n    delay(100);\n    digitalWrite(BUZZER_PIN, LOW);\n    delay(100);\n  } else {\n    digitalWrite(LED_PIN, LOW);\n    digitalWrite(BUZZER_PIN, LOW);\n  }\n}",
                "codeExplanation": "- Setup turns on the laser and records initial ambient light baseline.\n- Loop samples LDR light levels at 100Hz.\n- A drop in light exceeding 150 ADC units triggers pulsing audio-visual alarm sirens.",
                "verificationCheckpoints": [
                    "Understand differential baseline light thresholding",
                    "Verify alarm siren frequency timing"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Perimeter Intrusion Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Observe red laser dot on LDR. Pass your hand through the beam: buzzer sounds immediately and red strobe triggers!",
                "verificationCheckpoints": [
                    "Alarm fires within 10ms of breaking the laser beam",
                    "Alarm clears when beam path is restored"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Laser Security Specialist! You engineered a concentrated photonic tripwire perimeter grid.",
                "verificationCheckpoints": [
                    "Ready to claim Laser Master badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Alarm sounds continuously even when laser is hitting LDR",
                "cause": "Baseline light reading was taken before laser fully illuminated",
                "solution": "Increase delay(500) in setup() before sampling baselineLight.",
                "category": "logic",
                "diagnosticSteps": [
                    "Print baselineLight and currentLight to Serial Monitor",
                    "Ensure laser dot is centered directly over the LDR serpentine track"
                ]
            }
        ]
    },
    "proj_17": {
        "story": "The Monster Lab logistics rover needs to deliver supplies around the facility without human drivers! Program dual TCRT5000 infrared reflection sensors and an L293D dual motor driver to follow floor lines autonomously.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Robotic Hardware",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, TCRT5000 Dual Line Trackers (comp_14), 130 DC Motor (comp_33), L293D Motor Driver IC, Crash Switch (comp_04), Battery clip, Breadboard, and wires.",
                "verificationCheckpoints": [
                    "Two TCRT5000 IR reflectance sensors ready",
                    "L293D H-bridge IC notch orientation identified",
                    "Dual DC drive motors wired"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "H-Bridge & Sensor Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Mount L293D across center breadboard trough. Connect motor controls to Pins 5, 6, 9, 10. Connect Left Line Sensor to Pin 2, Right Line Sensor to Pin 3, and Crash Switch to Pin 4.",
                "wiringConnections": [
                    {"from": "Left Line D0", "to": "Arduino Pin 2", "wire": "Green", "type": "digitalIn"},
                    {"from": "Right Line D0", "to": "Arduino Pin 3", "wire": "Yellow", "type": "digitalIn"},
                    {"from": "Crash Switch OUT", "to": "Arduino Pin 4", "wire": "Orange", "type": "digitalIn"},
                    {"from": "L293D IN1", "to": "Arduino Pin 5", "wire": "Blue", "type": "digitalOut"},
                    {"from": "L293D IN2", "to": "Arduino Pin 6", "wire": "Blue", "type": "digitalOut"},
                    {"from": "L293D IN3", "to": "Arduino Pin 9", "wire": "Purple", "type": "digitalOut"},
                    {"from": "L293D IN4", "to": "Arduino Pin 10", "wire": "Purple", "type": "digitalOut"}
                ],
                "verificationCheckpoints": [
                    "L293D pin 16 (VCC1) to 5V, pin 8 (VCC2) to battery power",
                    "Common ground linked between battery and Arduino"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Ground Sensor Calibration",
                "type": "wiringCheck",
                "instructions": "Adjust the tiny trimmer potentiometers on the TCRT5000 boards so the indicator LED turns ON over white paper and OFF over black tape.",
                "verificationCheckpoints": [
                    "Sensors differentiate black tape from white floor at 5mm distance",
                    "Crash switch triggers cleanly upon bumper contact"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Differential Steering",
                "type": "codeReview",
                "instructions": "Review differential robot steering: both sensors on white = drive forward; left sensor on black line = pivot left; right on black line = pivot right; crash switch active = full emergency stop!",
                "codeSnippet": "const int LEFT_SENSOR = 2;\nconst int RIGHT_SENSOR = 3;\nconst int BUMPER_PIN = 4;\n\nvoid setup() {\n  pinMode(LEFT_SENSOR, INPUT);\n  pinMode(RIGHT_SENSOR, INPUT);\n  pinMode(BUMPER_PIN, INPUT_PULLUP);\n  pinMode(5, OUTPUT); pinMode(6, OUTPUT);\n  pinMode(9, OUTPUT); pinMode(10, OUTPUT);\n}\n\nvoid driveForward() {\n  digitalWrite(5, HIGH); digitalWrite(6, LOW);\n  digitalWrite(9, HIGH); digitalWrite(10, LOW);\n}\nvoid turnLeft() {\n  digitalWrite(5, LOW); digitalWrite(6, LOW);\n  digitalWrite(9, HIGH); digitalWrite(10, LOW);\n}\nvoid turnRight() {\n  digitalWrite(5, HIGH); digitalWrite(6, LOW);\n  digitalWrite(9, LOW); digitalWrite(10, LOW);\n}\nvoid stopMotors() {\n  digitalWrite(5, LOW); digitalWrite(6, LOW);\n  digitalWrite(9, LOW); digitalWrite(10, LOW);\n}\n\nvoid loop() {\n  if (digitalRead(BUMPER_PIN) == LOW) {\n    stopMotors(); return;\n  }\n  int left = digitalRead(LEFT_SENSOR);\n  int right = digitalRead(RIGHT_SENSOR);\n  if (left == HIGH && right == HIGH) driveForward();\n  else if (left == LOW && right == HIGH) turnLeft();\n  else if (left == HIGH && right == LOW) turnRight();\n  else stopMotors();\n}",
                "codeExplanation": "- Digital inputs 2 and 3 evaluate optical infrared reflectance in real time.\n- Dual H-Bridge channels control wheel motor velocity independently to correct heading.\n- Bumper collision switch immediately halts motors to prevent damage.",
                "verificationCheckpoints": [
                    "Understand bang-bang differential steering",
                    "Verify fail-safe bumper priority override"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Track Navigation Run",
                "type": "uploadSketch",
                "instructions": "Place rover on a black tape loop track. Power on battery switch: the rover tracks the line smoothly around corners and stops when bumping a wall!",
                "verificationCheckpoints": [
                    "Rover follows closed-loop tape path without leaving line",
                    "Collision bumper immediately cuts motor drive"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Autonomous Vehicle Engineer! You deployed differential robotics navigation and real-time obstacle avoidance.",
                "verificationCheckpoints": [
                    "Ready to claim Rover Commander badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Rover spins in circles instead of following line",
                "cause": "Motor wiring polarity reversed on one channel",
                "solution": "Swap motor terminals on L293D pins 3 and 6 (or 11 and 14).",
                "category": "wiring",
                "diagnosticSteps": [
                    "Elevate rover wheels off ground",
                    "Verify both wheels spin forward during driveForward()"
                ]
            }
        ]
    },
    "proj_18": {
        "story": "Tired of tethering your robot to your laptop? Connect an HC-05 Bluetooth UART module to control robot servos and stream analog sensor graphs wirelessly to any smartphone or tablet terminal app!",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Wireless Terminal Parts",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, HC-05 Bluetooth Module (comp_29), 1602 I2C LCD (comp_07), 10k Potentiometer (comp_20), RGB LED, 1k and 2k resistors (for 3.3V divider), breadboard, and wires.",
                "verificationCheckpoints": [
                    "HC-05 Bluetooth module ready",
                    "1k and 2k resistors for 3.3V logic level shifting",
                    "1602 I2C LCD address confirmed"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Breadboard Wiring & Logic Divider",
                "type": "breadboardWiring",
                "instructions": "Connect HC-05 TX to Arduino Pin 10 (SoftwareSerial RX). Connect Arduino Pin 11 (TX) through 1k/2k voltage divider to HC-05 RX (3.3V level). Connect LCD to A4/A5.",
                "wiringConnections": [
                    {"from": "HC-05 VCC", "to": "Arduino 5V", "wire": "Red", "type": "power"},
                    {"from": "HC-05 GND", "to": "Arduino GND", "wire": "Dark Slate", "type": "ground"},
                    {"from": "HC-05 TXD", "to": "Arduino Pin 10", "wire": "Green", "type": "uart"},
                    {"from": "Arduino Pin 11", "to": "1k Resistor -> HC-05 RXD", "wire": "Blue", "type": "uart"},
                    {"from": "LCD SDA", "to": "Arduino A4", "wire": "Orange", "type": "i2c"},
                    {"from": "LCD SCL", "to": "Arduino A5", "wire": "Yellow", "type": "i2c"}
                ],
                "verificationCheckpoints": [
                    "Voltage divider steps Arduino 5V TX down to 3.3V for HC-05 RX",
                    "LCD backpack wired to hardware I2C pins"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Wiring Verification",
                "type": "wiringCheck",
                "instructions": "Double check the voltage divider on the HC-05 RX pin. Applying direct 5V to HC-05 RX can damage its radio processor.",
                "verificationCheckpoints": [
                    "1k resistor in series with Arduino TX, 2k resistor to GND",
                    "HC-05 red LED blinks rapidly in discovery mode"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & SoftwareSerial",
                "type": "codeReview",
                "instructions": "Review SoftwareSerial bridge: forward characters from smartphone terminal to LCD, and transmit potentiometer telemetry back to the phone!",
                "codeSnippet": "#include <SoftwareSerial.h>\n#include <Wire.h>\n#include <LiquidCrystal_I2C.h>\n\nSoftwareSerial bt(10, 11); // RX, TX\nLiquidCrystal_I2C lcd(0x27, 16, 2);\n\nvoid setup() {\n  Serial.begin(9600);\n  bt.begin(9600);\n  lcd.init();\n  lcd.backlight();\n  lcd.print(\"Bluetooth Ready!\");\n}\n\nvoid loop() {\n  if (bt.available()) {\n    char c = bt.read();\n    lcd.clear();\n    lcd.setCursor(0, 0);\n    lcd.print(\"Cmd Received:\");\n    lcd.setCursor(0, 1);\n    lcd.print(c);\n    bt.print(\"ACK: \"); bt.println(c);\n  }\n  int pot = analogRead(A0);\n  static unsigned long lastSend = 0;\n  if (millis() - lastSend > 1000) {\n    bt.print(\"Telemetry Pot=\"); bt.println(pot);\n    lastSend = millis();\n  }\n}",
                "codeExplanation": "- SoftwareSerial(10, 11) creates a secondary serial channel without blocking USB programming pins 0 and 1.\n- Inbound characters from smartphone are parsed and rendered onto the LCD.\n- Non-blocking millis() timer pushes live analog sensor readings to the phone every second.",
                "verificationCheckpoints": [
                    "Understand software serial emulation",
                    "Understand non-blocking telemetry broadcast loops"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Wireless Terminal Pairing",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Pair your phone to 'HC-05' (passcode 1234). Open any Bluetooth Serial Terminal app, connect, and type 'A' to see it display on the LCD!",
                "verificationCheckpoints": [
                    "Phone terminal displays 'Telemetry Pot=' stream",
                    "Typed messages appear immediately on the physical LCD"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Wireless Telemetry Pioneer! You freed your Arduino from USB cables with bidirectional Bluetooth communication.",
                "verificationCheckpoints": [
                    "Ready to claim Bluetooth Pioneer badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "Garbled question marks or weird symbols on terminal app",
                "cause": "Baud rate mismatch between Arduino sketch and HC-05 module",
                "solution": "Verify bt.begin(9600) matches the module default. If module was configured for 38400, adjust bt.begin(38400).",
                "category": "upload",
                "diagnosticSteps": [
                    "Test at 9600 baud first",
                    "Check terminal app line ending is set to CR+LF"
                ]
            }
        ]
    },
    "proj_19": {
        "story": "How fast is that motor really spinning? Build laboratory instrumentation! Combine an optical slotted photogate and a magnetic Hall effect sensor with hardware interrupts to calculate rotational velocity in Revolutions Per Minute (RPM) and display on a 7-segment display.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather Instrumentation Parts",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, Photo Interrupter Photogate (comp_05), 3144 Hall Effect Sensor (comp_38), 7-Segment Display (comp_32), 74HC595 Shift Register, 130 DC Motor (comp_33), Neodymium magnet, Breadboard, and wires.",
                "verificationCheckpoints": [
                    "ITR9608 photogate slotted optical switch ready",
                    "3144 Hall effect magnetic switch ready",
                    "74HC595 shift register IC ready"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Interrupt & Display Breadboard Wiring",
                "type": "breadboardWiring",
                "instructions": "Connect Photogate OUT to Pin 2 (Hardware Interrupt 0). Connect Hall Sensor OUT to Pin 3 (Hardware Interrupt 1). Connect 74HC595 Latch/Clock/Data to Pins 4, 5, 6. Connect Shift Register outputs to 7-Segment segments A-G.",
                "wiringConnections": [
                    {"from": "Photogate OUT", "to": "Arduino Pin 2", "wire": "Yellow", "type": "digitalIn"},
                    {"from": "Hall Sensor OUT", "to": "Arduino Pin 3", "wire": "Green", "type": "digitalIn"},
                    {"from": "74HC595 Latch", "to": "Arduino Pin 4", "wire": "Blue", "type": "digitalOut"},
                    {"from": "74HC595 Clock", "to": "Arduino Pin 5", "wire": "Purple", "type": "digitalOut"},
                    {"from": "74HC595 Data", "to": "Arduino Pin 6", "wire": "Orange", "type": "digitalOut"}
                ],
                "verificationCheckpoints": [
                    "Photogate and Hall sensors wired to hardware interrupt pins (Pins 2 and 3)",
                    "Current-limiting resistors protect display segments"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Sensor Trigger Verification",
                "type": "wiringCheck",
                "instructions": "Pass a piece of cardboard through the photogate slot: observe digital signal drop on Pin 2. Wave magnet near Hall sensor: observe digital signal drop on Pin 3.",
                "verificationCheckpoints": [
                    "Optical beam break triggers clean falling edge",
                    "Magnetic field triggers clean falling edge"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Interrupt Math",
                "type": "codeReview",
                "instructions": "Review hardware interrupt velocity math: ISR increments a pulse counter. Every 500ms, the main loop computes RPM = (pulses * 60000) / (timeDelta * slots) and shifts digits out to the 7-segment display.",
                "codeSnippet": "volatile unsigned long pulseCount = 0;\nunsigned long lastCalcTime = 0;\nint currentRpm = 0;\n\nvoid countPulse() {\n  pulseCount++;\n}\n\nvoid setup() {\n  Serial.begin(9600);\n  pinMode(2, INPUT_PULLUP);\n  attachInterrupt(digitalPinToInterrupt(2), countPulse, FALLING);\n}\n\nvoid loop() {\n  unsigned long now = millis();\n  if (now - lastCalcTime >= 500) {\n    detachInterrupt(digitalPinToInterrupt(2));\n    currentRpm = (pulseCount * 60000) / ((now - lastCalcTime) * 1); // 1 slot\n    pulseCount = 0;\n    lastCalcTime = now;\n    attachInterrupt(digitalPinToInterrupt(2), countPulse, FALLING);\n    Serial.print(\"Motor Speed: \"); Serial.print(currentRpm); Serial.println(\" RPM\");\n  }\n}",
                "codeExplanation": "- attachInterrupt() executes countPulse() instantly when a slot breaks the optical beam without polling delay.\n- volatile keyword ensures the compiler doesn't optimize away the interrupt-modified variable.\n- Periodic calculation window converts pulse frequency into engineering units (RPM).",
                "verificationCheckpoints": [
                    "Understand hardware interrupt execution priority",
                    "Understand atomic variable access during time window calculation"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & High-Speed Spin Bench Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Power up DC motor with slotted disc spinning in the photogate slot. Observe precise, jitter-free RPM readings updating live!",
                "verificationCheckpoints": [
                    "RPM scales smoothly with motor voltage",
                    "Display matches physical spin rate"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "Tachometer Instrument Specialist! You harnessed hardware interrupts to measure high-speed physical velocity.",
                "verificationCheckpoints": [
                    "Ready to claim Tachometer Tech badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "RPM reads zero even when motor is spinning",
                "cause": "Sensor connected to non-interrupt pin, or slotted disc not passing between photogate posts",
                "solution": "Verify sensor output is wired strictly to digital Pin 2 (Interrupt 0) or Pin 3 (Interrupt 1).",
                "category": "wiring",
                "diagnosticSteps": [
                    "Check interrupt pin wiring",
                    "Test countPulse() by manually tapping Pin 2 to GND"
                ]
            }
        ]
    },
    "proj_20": {
        "story": "Bring your Monster Lab online to the global internet! Mount the W5100 SPI Ethernet shield, connect a LAN cable, and host an interactive micro-web server that serves live atmospheric temperature, barometric pressure, and altitude to any browser on your network.",
        "phases": [
            {
                "phaseNumber": 1,
                "phaseTitle": "Gather IoT Server Hardware",
                "type": "gatherParts",
                "instructions": "Locate from your kit: Arduino Uno, W5100 Ethernet Shield (comp_30), BMP180 Barometric Pressure Sensor (comp_08), DHT11 Temp/Humidity Sensor (comp_09), RJ-45 LAN Ethernet cable, breadboard, and wires.",
                "verificationCheckpoints": [
                    "W5100 Ethernet shield pins straight",
                    "BMP180 I2C sensor ready",
                    "LAN cable connected to home router/switch"
                ]
            },
            {
                "phaseNumber": 2,
                "phaseTitle": "Shield Mounting & Sensor Header Wiring",
                "type": "breadboardWiring",
                "instructions": "Carefully press the W5100 Ethernet Shield onto the Arduino Uno headers. Connect BMP180 SDA/SCL to the shield's A4/A5 header pins. Connect DHT11 DATA to Pin 2.",
                "wiringConnections": [
                    {"from": "BMP180 VCC", "to": "Shield 3.3V", "wire": "Red", "type": "power"},
                    {"from": "BMP180 GND", "to": "Shield GND", "wire": "Dark Slate", "type": "ground"},
                    {"from": "BMP180 SDA", "to": "Shield A4", "wire": "Orange", "type": "i2c"},
                    {"from": "BMP180 SCL", "to": "Shield A5", "wire": "Yellow", "type": "i2c"},
                    {"from": "DHT11 DATA", "to": "Shield Pin 2", "wire": "Green", "type": "digitalIn"}
                ],
                "verificationCheckpoints": [
                    "Ethernet shield ICSP header fully seated",
                    "Sensors wired to pass-through headers on top of shield"
                ]
            },
            {
                "phaseNumber": 3,
                "phaseTitle": "Network Hardware Verification",
                "type": "wiringCheck",
                "instructions": "Plug in LAN cable: verify the green LINK LED and amber ACT LED illuminate on the shield's RJ-45 jack.",
                "verificationCheckpoints": [
                    "RJ-45 link light active",
                    "No bent pins on the shield stacking headers"
                ]
            },
            {
                "phaseNumber": 4,
                "phaseTitle": "Code Walkthrough & Embedded HTTP Web Server",
                "type": "codeReview",
                "instructions": "Review embedded HTTP server architecture: negotiates local IP via DHCP, listens on port 80, parses client GET requests, and streams an HTML5 live telemetry dashboard.",
                "codeSnippet": "#include <SPI.h>\n#include <Ethernet.h>\n#include <Wire.h>\n#include <Adafruit_BMP085.h>\n\nbyte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };\nEthernetServer server(80);\nAdafruit_BMP085 bmp;\n\nvoid setup() {\n  Serial.begin(9600);\n  if (Ethernet.begin(mac) == 0) {\n    Serial.println(\"DHCP Failed!\");\n  }\n  server.begin();\n  bmp.begin();\n  Serial.print(\"Server online at: \");\n  Serial.println(Ethernet.localIP());\n}\n\nvoid loop() {\n  EthernetClient client = server.available();\n  if (client) {\n    boolean currentLineIsBlank = true;\n    while (client.connected()) {\n      if (client.available()) {\n        char c = client.read();\n        if (c == '\\n' && currentLineIsBlank) {\n          client.println(\"HTTP/1.1 200 OK\");\n          client.println(\"Content-Type: text/html\");\n          client.println(\"Connection: close\");\n          client.println(\"Refresh: 5\"); // Auto-refresh\n          client.println();\n          client.println(\"<!DOCTYPE HTML>\");\n          client.println(\"<html><h1>Monster Lab Weather Beacon</h1>\");\n          client.print(\"<p>Temperature: \"); client.print(bmp.readTemperature()); client.println(\" C</p>\");\n          client.print(\"<p>Pressure: \"); client.print(bmp.readPressure() / 100.0); client.println(\" hPa</p>\");\n          client.print(\"<p>Altitude: \"); client.print(bmp.readAltitude()); client.println(\" m</p></html>\");\n          break;\n        }\n        if (c == '\\n') currentLineIsBlank = true;\n        else if (c != '\\r') currentLineIsBlank = false;\n      }\n    }\n    delay(1);\n    client.stop();\n  }\n}",
                "codeExplanation": "- Ethernet.begin(mac) automatically acquires IP address from local home router via DHCP.\n- server.available() intercepts web browser TCP connections on port 80.\n- Sends standard HTTP 200 OK headers followed by semantic HTML markup.\n- Browser displays live updating weather dashboard from any computer, tablet, or phone on the LAN.",
                "verificationCheckpoints": [
                    "Understand HTTP client/server request/response cycle",
                    "Understand DHCP local IP address leasing"
                ]
            },
            {
                "phaseNumber": 5,
                "phaseTitle": "Upload & Web Browser Live Dashboard Test",
                "type": "uploadSketch",
                "instructions": "Upload sketch. Open Serial Monitor to see the assigned IP address. Open Chrome or Safari on your phone or laptop, type the IP into the URL bar, and watch your Arduino serve live weather telemetry!",
                "verificationCheckpoints": [
                    "Serial Monitor reports valid local IP (e.g. 192.168.1.xxx)",
                    "Web browser displays live HTML5 weather page with 5-second auto-refresh"
                ]
            },
            {
                "phaseNumber": 6,
                "phaseTitle": "Mission Complete",
                "type": "missionComplete",
                "instructions": "IoT Architect Master! You deployed a fully standalone HTTP internet server on an embedded microcontroller.",
                "verificationCheckpoints": [
                    "Ready to claim IoT Architect badge"
                ]
            }
        ],
        "troubleshooting": [
            {
                "symptom": "DHCP Failed error in Serial Monitor",
                "cause": "LAN cable disconnected or router blocked DHCP lease",
                "solution": "Check RJ-45 cable connection to router, or specify a static IP address using Ethernet.begin(mac, ip).",
                "category": "upload",
                "diagnosticSteps": [
                    "Verify green link LED on Ethernet shield jack",
                    "Test LAN cable with a laptop to verify active internet"
                ]
            }
        ]
    }
}


def get_project_enrichment(project_id):
    return PROJECT_ENRICHMENTS.get(project_id)
