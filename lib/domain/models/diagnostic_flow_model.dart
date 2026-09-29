enum DiagnosticCategory {
  power,
  wiring,
  compile,
  upload,
  logic,
}

enum DiagnosisSeverity {
  normal,
  caution,
  criticalWarning,
}

class DiagnosticResult {
  final String title;
  final String rootCause;
  final String explanation;
  final List<String> fixSteps;
  final String verificationTest;
  final DiagnosisSeverity severity;

  const DiagnosticResult({
    required this.title,
    required this.rootCause,
    required this.explanation,
    required this.fixSteps,
    required this.verificationTest,
    this.severity = DiagnosisSeverity.normal,
  });
}

class DiagnosticOption {
  final String label;
  final String? description;
  final String? nextNodeId;
  final DiagnosticResult? result;

  const DiagnosticOption({
    required this.label,
    this.description,
    this.nextNodeId,
    this.result,
  });
}

class DiagnosticNode {
  final String id;
  final DiagnosticCategory category;
  final String title;
  final String question;
  final String? promptDetails;
  final List<DiagnosticOption> options;

  const DiagnosticNode({
    required this.id,
    required this.category,
    required this.title,
    required this.question,
    this.promptDetails,
    required this.options,
  });
}

class FailurePlaybook {
  final String id;
  final String title;
  final DiagnosticCategory category;
  final String symptomOverview;
  final List<String> commonCauses;
  final String theScience;
  final String kidRule;
  final List<String> stepByStepChecklist;

  const FailurePlaybook({
    required this.id,
    required this.title,
    required this.category,
    required this.symptomOverview,
    required this.commonCauses,
    required this.theScience,
    required this.kidRule,
    required this.stepByStepChecklist,
  });
}

/// Pre-seeded knowledge base containing comprehensive diagnostic trees
/// and universal failure playbooks for Monster Lab.
class DoctorMonsterKnowledgeBase {
  static const List<DiagnosticNode> rootNodes = [
    DiagnosticNode(
      id: 'root',
      category: DiagnosticCategory.power,
      title: 'Triage Station',
      question: 'What type of problem are you experiencing?',
      promptDetails:
          'Select the symptom that best describes what is happening right now:',
      options: [
        DiagnosticOption(
          label: 'Power & Board Dead',
          description:
              'Arduino won’t turn on, green LED is dark, or board gets warm',
          nextNodeId: 'power_start',
        ),
        DiagnosticOption(
          label: 'Breadboard & Wiring',
          description:
              'Board is on, but LED, buzzer, or motor doesn’t do anything',
          nextNodeId: 'wiring_start',
        ),
        DiagnosticOption(
          label: 'Arduino IDE Compile Error',
          description:
              'Orange error messages appear when clicking Verify (check mark)',
          nextNodeId: 'compile_start',
        ),
        DiagnosticOption(
          label: 'Upload & Port Failure',
          description:
              'Upload fails with avrdude timeout or Port is grayed out',
          nextNodeId: 'upload_start',
        ),
        DiagnosticOption(
          label: 'Sensor & Logic Glitches',
          description:
              'Sensors read crazy numbers, random triggers, or LCD is blank',
          nextNodeId: 'logic_start',
        ),
      ],
    ),

    // --- POWER TREE ---
    DiagnosticNode(
      id: 'power_start',
      category: DiagnosticCategory.power,
      title: 'Power Inspection',
      question:
          'Is the small green LED labeled "ON" lit on your Arduino board?',
      promptDetails: 'Look near the center of the green Arduino circuit board.',
      options: [
        DiagnosticOption(
          label: 'No, the green ON LED is completely dark',
          description: 'The microcontroller is receiving zero electricity.',
          nextNodeId: 'power_led_dark',
        ),
        DiagnosticOption(
          label: 'Yes, but it dims or reboots repeatedly',
          description:
              'The board keeps restarting when motor or buzzer activates.',
          result: DiagnosticResult(
            title: 'Current Overload / Brownout Reset',
            rootCause:
                'Drawing more current than the computer USB port can safely supply (>500mA).',
            explanation:
                'Inductive loads like motors and high-current coils draw a massive inrush spike when turning on. This drops the 5V bus voltage below 4.3V, triggering the Arduino’s brownout reset circuit.',
            fixSteps: [
              'Unplug the USB cable immediately.',
              'Disconnect DC motors, servos, or relays from the Arduino 5V pin.',
              'Power mechanical actuators using an external battery pack or 9V barrel jack.',
              'Add a 100uF electrolytic capacitor across the power and GND rails to smooth voltage drops.',
            ],
            verificationTest:
                'Plug USB back in without motors. Verify the green ON LED stays solidly illuminated.',
            severity: DiagnosisSeverity.caution,
          ),
        ),
        DiagnosticOption(
          label: 'Yes, green ON LED is on, but the chip feels hot!',
          description:
              'The black square or rectangle chip feels warm or burning to touch.',
          result: DiagnosticResult(
            title: 'Critical Short Circuit Detected!',
            rootCause:
                'A direct bridge exists between 5V and GND, or an output pin is shorted.',
            explanation:
                'Electricity always takes the path of least resistance. When 5V touches GND directly with no resistor or load, infinite current flows, rapidly heating the onboard voltage regulator or ATmega328P chip.',
            fixSteps: [
              'DISCONNECT USB CABLE RIGHT NOW! Do not leave it plugged in.',
              'Inspect your breadboard: check if a jumper wire connects the red (+) rail directly to the blue (-) rail.',
              'Look for stray bent component leads touching each other.',
              'Let the board cool down for 2 minutes before plugging back in.',
            ],
            verificationTest:
                'With breadboard disconnected, plug in Arduino. Touch chip—it should stay completely cool.',
            severity: DiagnosisSeverity.criticalWarning,
          ),
        ),
      ],
    ),
    DiagnosticNode(
      id: 'power_led_dark',
      category: DiagnosticCategory.power,
      title: 'USB Power Check',
      question:
          'What happens when you unplug the breadboard power wires from the Arduino?',
      promptDetails:
          'Remove the 5V and GND wires connecting Arduino to the breadboard, leaving only the USB cable.',
      options: [
        DiagnosticOption(
          label: 'The green ON LED turns on now!',
          description: 'Arduino lights up when breadboard is unplugged.',
          result: DiagnosticResult(
            title: 'Breadboard Short Circuit',
            rootCause:
                'There is a short circuit somewhere on your breadboard pulling the 5V rail to ground.',
            explanation:
                'The Arduino Uno has a built-in resettable polyfuse that trips when breadboard wiring draws too much current, shutting off power to save your computer.',
            fixSteps: [
              'Keep USB plugged in to Arduino only.',
              'On the breadboard, check every component: verify no wire connects (+) and (-) rails together.',
              'Check IC chips: make sure they are not inserted backwards.',
              'Reconnect breadboard wires one by one to find which component causes the shutdown.',
            ],
            verificationTest:
                'Plug 5V and GND wires back into breadboard; green ON LED must remain lit.',
            severity: DiagnosisSeverity.caution,
          ),
        ),
        DiagnosticOption(
          label: 'Still completely dark even with nothing plugged into Arduino',
          description: 'Board is dark with just the USB cable attached.',
          result: DiagnosticResult(
            title: 'USB Cable or Computer Port Failure',
            rootCause:
                'Using a "charge-only" USB cable, a dead computer port, or a tripped computer USB port.',
            explanation:
                'Some cheap USB cables only contain the 2 power wires and have broken copper traces, or the computer disabled the USB port due to previous overload.',
            fixSteps: [
              'Try a different USB port on your computer (prefer ports directly on the motherboard, not hubs).',
              'Swap the USB-B cable for a known good data cable.',
              'Check if your computer displays a "USB device drawing too much power" notification.',
            ],
            verificationTest:
                'Plug into a different USB port with a known data cable. Green ON LED should glow.',
          ),
        ),
      ],
    ),

    // --- WIRING TREE ---
    DiagnosticNode(
      id: 'wiring_start',
      category: DiagnosticCategory.wiring,
      title: 'Wiring & Component Triage',
      question: 'Which component is refusing to work?',
      options: [
        DiagnosticOption(
          label: 'An LED won’t illuminate',
          description:
              'The LED stays dark when the code runs digitalWrite(pin, HIGH).',
          nextNodeId: 'wiring_led',
        ),
        DiagnosticOption(
          label: 'Active Buzzer makes no sound or only clicks',
          description: 'Buzzer is silent or produces a faint muted click.',
          result: DiagnosticResult(
            title: 'Buzzer Polarity or Protective Sticker',
            rootCause:
                'Active buzzers are polarized and frequently ship with a yellow factory seal.',
            explanation:
                'An active buzzer contains an internal oscillating circuit. If reverse-biased, current cannot flow through the transistor oscillator. Also, the round yellow sticker dampens sound by 90%.',
            fixSteps: [
              'Peel off the round yellow protective sticker on top of the buzzer.',
              'Check the pins: the longer lead or the side marked with a (+) must connect to the Arduino signal pin.',
              'The shorter lead must connect to the GND rail.',
            ],
            verificationTest:
                'Touch the (+) lead to 5V and (-) lead to GND directly. It should emit a sharp loud beep.',
          ),
        ),
        DiagnosticOption(
          label: 'Pushbutton triggers erratically or never triggers',
          description:
              'Button seems to have a mind of its own or waving hands triggers it.',
          result: DiagnosticResult(
            title: 'Floating Digital Input Pin',
            rootCause:
                'Digital input pin has no pull-up or pull-down resistor.',
            explanation:
                'A digital input pin with no resistor floats between 0V and 5V. It acts like an antenna picking up static electromagnetic fields in the air.',
            fixSteps: [
              'In your Arduino sketch, change pinMode(buttonPin, INPUT); to pinMode(buttonPin, INPUT_PULLUP);.',
              'Wire the button between the digital pin and GND.',
              'Verify in code that pressing the button now reads LOW.',
            ],
            verificationTest:
                'Wave your hand over the breadboard. The button should no longer trigger randomly.',
          ),
        ),
        DiagnosticOption(
          label: 'Components on one half of breadboard work, other half dead',
          description:
              'Power is on one side, but anything on the far half receives no power.',
          result: DiagnosticResult(
            title: 'Split Breadboard Power Rails',
            rootCause:
                'Full-size breadboards have a break in the power rails halfway down.',
            explanation:
                'Many full-length breadboards divide their red (+) and blue (-) power buses in the exact center so you can use dual voltages. If not bridged, the bottom half is completely disconnected.',
            fixSteps: [
              'Look closely at the red and blue colored lines on the edges of your breadboard.',
              'If there is a gap in the center of the line, electricity stops there.',
              'Insert short jumper wires across the middle gap from (+) to (+) and (-) to (-).',
            ],
            verificationTest:
                'Move LED circuit to the far end of the breadboard. It should now light up.',
          ),
        ),
      ],
    ),
    DiagnosticNode(
      id: 'wiring_led',
      category: DiagnosticCategory.wiring,
      title: 'LED Inspection',
      question: 'How is the LED oriented in the breadboard?',
      options: [
        DiagnosticOption(
          label: 'I am not sure which leg is which',
          description: 'Both legs look similar or were clipped.',
          result: DiagnosticResult(
            title: 'Reversed LED Polarity (Anode vs Cathode)',
            rootCause:
                'Light Emitting Diodes only conduct electricity in ONE direction.',
            explanation:
                'A diode is a one-way electrical valve. Current must enter the Anode (longer leg) and exit the Cathode (shorter leg, flat side on the plastic rim). When reversed, current is blocked.',
            fixSteps: [
              'Unplug the LED from the breadboard.',
              'Rotate the LED 180 degrees.',
              'Ensure the longer leg (Anode) connects to the Arduino digital pin (through a resistor).',
              'Ensure the shorter leg (Cathode) connects to the GND rail.',
            ],
            verificationTest:
                'Run the Blink sketch. The LED should now flash brightly.',
          ),
        ),
        DiagnosticOption(
          label: 'Orientation is correct, but there is no resistor',
          description: 'LED is wired directly between Arduino pin and GND.',
          result: DiagnosticResult(
            title: 'Burned Out LED (Missing Current Limiting Resistor)',
            rootCause:
                'Excessive current burned the internal LED bonding wire.',
            explanation:
                'Without a resistor (e.g. 220 or 330 ohms), an LED attempts to draw infinite current from the 5V pin. Within milliseconds, the internal silicon junction overheats and pops.',
            fixSteps: [
              'Discard this LED—once burned out, it cannot be fixed.',
              'Take a fresh LED from your kit.',
              'Always insert a 220-ohm (Red-Red-Brown) or 330-ohm (Orange-Orange-Brown) resistor in series with the LED.',
            ],
            verificationTest:
                'Wire fresh LED with a 220-ohm resistor. Verify it lights up safely.',
            severity: DiagnosisSeverity.caution,
          ),
        ),
        DiagnosticOption(
          label: 'Resistor and orientation are good, but still dark',
          description: 'Wiring looks correct but code does nothing.',
          result: DiagnosticResult(
            title: 'Software Pin vs Hardware Pin Mismatch',
            rootCause:
                'The pin defined in code does not match the hole the jumper wire is plugged into.',
            explanation:
                'If your sketch has int ledPin = 13; but the jumper wire is plugged into digital header hole 12, pin 13 is toggling in empty space.',
            fixSteps: [
              'Trace the wire from the breadboard back to the Arduino Uno header.',
              'Read the exact pin number printed next to the header socket.',
              'Update your sketch to match the physical pin, or move the wire to match your code.',
            ],
            verificationTest:
                'Upload the sketch again and verify the LED responds to code commands.',
          ),
        ),
      ],
    ),

    // --- COMPILE TREE ---
    DiagnosticNode(
      id: 'compile_start',
      category: DiagnosticCategory.compile,
      title: 'Compiler Error Decoder',
      question:
          'What does the orange error message in the Arduino IDE console say?',
      options: [
        DiagnosticOption(
          label: "error: expected ';' before '...'",
          description: 'A missing semicolon at the end of a statement.',
          result: DiagnosticResult(
            title: 'Missing Semicolon (;)',
            rootCause:
                'In C++, every single statement must terminate with a semicolon.',
            explanation:
                'The compiler reads ahead until it hits a semicolon. When one is missing, it tries to merge two statements together and reports an error on the NEXT line.',
            fixSteps: [
              'Look at the line of code HIGHLIGHTED in red, then look at the line DIRECTLY ABOVE IT.',
              'Check the end of that line: add a semicolon ;.',
              'Click the Verify checkmark button to recompile.',
            ],
            verificationTest:
                'Arduino IDE console reports "Done compiling" with sketch size.',
          ),
        ),
        DiagnosticOption(
          label: "error: '...' was not declared in this scope",
          description:
              'The compiler does not recognize a variable or function name.',
          result: DiagnosticResult(
            title: 'Undeclared Variable or Typo (Case Sensitivity)',
            rootCause:
                'C++ is strictly case-sensitive. ledPin, LedPin, and LEDPin are 3 totally different names.',
            explanation:
                'If you defined int ledPin = 9; in setup() or at the top, typing digitalWrite(LedPin, HIGH); will fail because the capital L doesn’t match.',
            fixSteps: [
              'Check spelling and capitalization of the identifier listed in the error message.',
              'Verify that the variable was declared at the top of the sketch (global scope) or inside the current function.',
              'Check common built-ins: OUTPUT (all caps), HIGH (all caps), INPUT_PULLUP (all caps).',
            ],
            verificationTest:
                'Fix the typo and click Verify. The error will disappear.',
          ),
        ),
        DiagnosticOption(
          label: "fatal error: ...h: No such file or directory",
          description: 'The sketch references a library that is not installed.',
          result: DiagnosticResult(
            title: 'Missing External Library',
            rootCause:
                'The #include header file cannot be found in your Arduino libraries folder.',
            explanation:
                'Sensors like the DHT11, RFID RC522, and LCD backpacks require third-party C++ libraries to communicate with the hardware.',
            fixSteps: [
              'In the Arduino IDE menu, go to: Sketch -> Include Library -> Manage Libraries...',
              'Type the library name into the search bar (e.g. "LiquidCrystal_I2C" or "DHT sensor library").',
              'Click "Install" (and "Install All" if it asks for dependencies).',
              'Re-verify your sketch.',
            ],
            verificationTest:
                'Sketch compiles cleanly without missing header errors.',
          ),
        ),
        DiagnosticOption(
          label: "error: expected '}' at end of input",
          description: 'Mismatched curly braces in the sketch.',
          result: DiagnosticResult(
            title: 'Unmatched Curly Braces { }',
            rootCause:
                'Every opening curly brace { must have an exact matching closing curly brace }.',
            explanation:
                'Curly braces define code blocks for functions, if-statements, and loops. If one is missing, the compiler thinks loop() never ended.',
            fixSteps: [
              'In Arduino IDE, press Ctrl+T (or Cmd+T on Mac) to Auto-Format your code.',
              'Auto-formatting indents code blocks. Look for code that is indented all the way to the right.',
              'Click on an opening brace {; the IDE will highlight its matching closing brace }.',
              'Add the missing } where the block should finish.',
            ],
            verificationTest:
                'Auto-format the code again and verify proper indentation and clean compilation.',
          ),
        ),
      ],
    ),

    // --- UPLOAD TREE ---
    DiagnosticNode(
      id: 'upload_start',
      category: DiagnosticCategory.upload,
      title: 'Upload & Serial Triage',
      question:
          'What error message appears when you click the Upload arrow button?',
      options: [
        DiagnosticOption(
          label: 'avrdude: stk500_recv(): programmer is not responding',
          description:
              'The computer cannot communicate with the Arduino bootloader.',
          nextNodeId: 'upload_stk500',
        ),
        DiagnosticOption(
          label: 'Tools -> Port menu is grayed out or shows no COM ports',
          description: 'Computer does not recognize any USB device plugged in.',
          result: DiagnosticResult(
            title: 'Missing CH340 Driver or Power-Only Cable',
            rootCause:
                'Clone Arduino boards use a CH340 USB-to-Serial chip requiring a driver, or USB cable has no data wires.',
            explanation:
                'Original Arduinos use an ATmega16U2 for USB, but many student kits use the CH340 chip. Windows/Mac requires the CH340 driver to create a virtual COM port.',
            fixSteps: [
              'Ensure your USB cable is a DATA cable, not a phone charging-only cable.',
              'Download and install the CH340 USB driver (available on Arduino/WCH website).',
              'Restart the Arduino IDE after installing the driver.',
              'Check Tools -> Port: select the new COM port that appears.',
            ],
            verificationTest:
                'Tools -> Port will display an active COM/tty port for your board.',
          ),
        ),
        DiagnosticOption(
          label: 'Upload error: Serial port in use or permission denied',
          description: 'Another application is holding the serial port open.',
          result: DiagnosticResult(
            title: 'Serial Port Lockout',
            rootCause:
                'The Serial Monitor or a second Arduino IDE window is locking the COM port.',
            explanation:
                'Operating systems only allow one program to hold a serial COM port open at a time. Uploading requires exclusive hardware access.',
            fixSteps: [
              'Close the Serial Monitor window (magnifying glass in top right).',
              'Close any other open Arduino IDE windows or 3D printer slicing tools.',
              'Unplug and replug the USB cable.',
            ],
            verificationTest:
                'Click Upload; the TX and RX LEDs on the Uno will flash rapidly during upload.',
          ),
        ),
      ],
    ),
    DiagnosticNode(
      id: 'upload_stk500',
      category: DiagnosticCategory.upload,
      title: 'Bootloader Communication Check',
      question:
          'Are there any wires plugged into Digital Pins 0 (RX) and 1 (TX) on your Arduino?',
      promptDetails:
          'Look at the first two digital pin sockets on the Arduino board labeled 0 and 1.',
      options: [
        DiagnosticOption(
          label: 'Yes, I have Bluetooth, GPS, or sensors wired to pins 0 and 1',
          description: 'Pins 0 and 1 are connected to breadboard components.',
          result: DiagnosticResult(
            title: 'Hardware Serial Interference (Pins 0 & 1 Conflict)',
            rootCause:
                'Pins 0 (RX) and 1 (TX) are directly wired to the USB chip that uploads your code.',
            explanation:
                'When you upload code, binary bytes stream across pins 0 and 1. If an external Bluetooth module, sensor, or wire is connected to those pins, it scrambles the upload data stream!',
            fixSteps: [
              'Unplug the wires from Pin 0 and Pin 1 completely.',
              'Click the Upload button in the Arduino IDE.',
              'Wait for "Done uploading" message.',
              'Plug the wires back into pins 0 and 1.',
            ],
            verificationTest:
                'Sketch uploads in 3 seconds once pins 0 and 1 are temporarily freed.',
          ),
        ),
        DiagnosticOption(
          label: 'No, pins 0 and 1 are empty, but it still fails',
          description: 'Pins 0 and 1 are free.',
          result: DiagnosticResult(
            title: 'Wrong Board Model Selected in Tools Menu',
            rootCause:
                'Selected board type does not match the connected hardware.',
            explanation:
                'If you have an Arduino Uno, but Tools -> Board is set to "Arduino Nano" or "Arduino Mega", the avrdude upload protocol uses the wrong baud rate (e.g. 57600 instead of 115200).',
            fixSteps: [
              'Go to Tools -> Board -> Arduino AVR Boards.',
              'Ensure "Arduino Uno" is selected.',
              'Go to Tools -> Port and re-select your active COM port.',
              'Press the red reset button on the Arduino right as the IDE status changes from "Compiling" to "Uploading".',
            ],
            verificationTest: 'Upload succeeds with "Done uploading" status.',
          ),
        ),
      ],
    ),

    // --- LOGIC & SENSORS TREE ---
    DiagnosticNode(
      id: 'logic_start',
      category: DiagnosticCategory.logic,
      title: 'Sensor & Logic Diagnostics',
      question: 'Which sensor or display is behaving erratically?',
      options: [
        DiagnosticOption(
          label: 'Ultrasonic Distance Sensor reads 0 or 3000 cm constantly',
          description: 'HC-SR04 sonar sensor values are pegged at max or min.',
          result: DiagnosticResult(
            title: 'Ultrasonic Pin Swap or Ping Rate Too Fast',
            rootCause:
                'TRIG and ECHO pins swapped, or sensor triggered without 50ms delay between pings.',
            explanation:
                'The HC-SR04 requires a 10us trigger pulse on TRIG, then listens for sound reflection on ECHO. If swapped, no pulse is emitted. If pinged faster than 20Hz, sound echoes collide in the room.',
            fixSteps: [
              'Verify that TRIG pin in code matches the physical wire to TRIG on the sensor.',
              'Verify that ECHO pin in code matches the physical wire to ECHO on the sensor.',
              'Ensure your code has a delay(50); or delay(60); inside loop() after each reading.',
              'Ensure VCC is connected to 5V (HC-SR04 will not work reliably on 3.3V).',
            ],
            verificationTest:
                'Place your hand 10cm from sensor; serial monitor should read ~10 cm accurately.',
          ),
        ),
        DiagnosticOption(
          label: 'I2C LCD1602 Screen shows dark solid rectangles or nothing',
          description: 'The display has power but no text appears.',
          result: DiagnosticResult(
            title: 'Contrast Potentiometer or I2C Hex Address',
            rootCause:
                'Backlight contrast trimmer is turned too far, or I2C address is 0x3F instead of 0x27.',
            explanation:
                'The I2C backpack on the back of the LCD has a small blue potentiometer that controls liquid crystal contrast. If set to maximum, all pixel blocks appear solid black.',
            fixSteps: [
              'Use a small Phillips screwdriver to slowly turn the blue brass trimmer screw on the back of the LCD backpack.',
              'Turn until letters become crisp and dark while the blue background turns clear.',
              'If still blank, run the I2C Scanner sketch to check if your backpack address is 0x27 or 0x3F.',
              'Update LiquidCrystal_I2C lcd(0x27, 16, 2); with the scanned hex address.',
            ],
            verificationTest:
                'Text prints clearly across both 16-character lines.',
          ),
        ),
        DiagnosticOption(
          label: 'Analog sensor (Potentiometer / LDR) always reads 1023 or 0',
          description:
              'Turning knob or shining light has zero effect on readings.',
          result: DiagnosticResult(
            title: 'Missing Voltage Divider Reference or Digital Pin Connected',
            rootCause:
                'Potentiometer missing 5V or GND outer leg, or wired to digital pin instead of analog.',
            explanation:
                'A potentiometer is a variable voltage divider. Outer legs must connect to 5V and GND. The center wiper pin must connect to an ANALOG IN pin (A0-A5), not digital pin 0-13.',
            fixSteps: [
              'Check outer legs: Leg 1 must go to 5V, Leg 3 must go to GND.',
              'Check center leg: Must connect to A0, A1, A2, A3, A4, or A5.',
              'In code, ensure you are using analogRead(A0), not digitalRead(A0).',
            ],
            verificationTest:
                'Turning knob from left to right should smoothly sweep readings from 0 to 1023.',
          ),
        ),
      ],
    ),
  ];

  static const List<FailurePlaybook> failurePlaybooks = [
    FailurePlaybook(
      id: 'playbook_power_shorts',
      title: 'Power Failures & Short Circuit Protection',
      category: DiagnosticCategory.power,
      symptomOverview:
          'Arduino green ON LED is dark, board turns off immediately, or chip gets hot.',
      commonCauses: [
        'Breadboard 5V and GND rails directly bridged together.',
        'USB cable is charge-only without data wires.',
        'Inductive motor drawing more than the 500mA USB current limit.',
      ],
      theScience:
          'Ohm’s law states I = V / R. When 5V connects directly to GND, resistance R is near zero, causing current I to surge toward infinity. The Arduino polyfuse cuts power to protect your computer motherboard.',
      kidRule:
          'Never let Red (+) and Blue/Black (-) touch without a component in between!',
      stepByStepChecklist: [
        'Unplug the USB cable immediately.',
        'Trace the power rail: verify no bare wires bridge the (+) and (-) rails.',
        'Disconnect all motors or servos and power them with separate batteries.',
        'Let the board cool down for 60 seconds.',
        'Plug USB in: verify the green ON LED is bright and solid.',
      ],
    ),
    FailurePlaybook(
      id: 'playbook_reversed_polarity',
      title: 'Reversed LEDs & Polarized Components',
      category: DiagnosticCategory.wiring,
      symptomOverview:
          'LED won’t light, buzzer won’t beep, or electrolytic capacitor gets warm.',
      commonCauses: [
        'LED inserted backwards (anode and cathode flipped).',
        'Active buzzer signal and ground pins swapped.',
        'Electrolytic capacitor connected backwards (can burst if reverse-biased).',
      ],
      theScience:
          'Diodes and transistors are semiconductors made of P-type and N-type silicon. Current can only flow when the P-side is connected to positive and N-side to negative (forward bias). Reverse bias blocks all current.',
      kidRule: 'Long Leg = Positive (+), Short Leg / Flat Edge = Negative (-).',
      stepByStepChecklist: [
        'Inspect the component legs before inserting into breadboard.',
        'Long leg (Anode) goes to the digital pin through a resistor.',
        'Short leg (Cathode) with flat rim on plastic body goes to GND.',
        'Always use a 220Ω resistor with LEDs to prevent burning the silicon.',
      ],
    ),
    FailurePlaybook(
      id: 'playbook_missing_ground',
      title: 'Missing Grounds & Floating Circuit Loops',
      category: DiagnosticCategory.wiring,
      symptomOverview:
          'Circuits behave randomly, LEDs glow faintly, or readings jump wildly.',
      commonCauses: [
        'Circuit has a 5V path but no return wire back to Arduino GND.',
        'Using external battery for motors without connecting battery (-) to Arduino GND.',
        'Broken jumper wire with internal snapped copper.',
      ],
      theScience:
          'Electricity cannot flow without a continuous closed loop. Current leaves 5V, passes through the components doing work, and must return to GND. If GND is missing, electrons have nowhere to go.',
      kidRule:
          'All grounds must be shared! Every circuit needs a return path home.',
      stepByStepChecklist: [
        'Check that the breadboard blue/black rail has a jumper wire going to an Arduino GND pin.',
        'If using an external battery, connect its (-) negative terminal to Arduino GND.',
        'Verify digital pins have a pull-up or pull-down to prevent floating antenna noise.',
      ],
    ),
    FailurePlaybook(
      id: 'playbook_wrong_pins',
      title: 'Pin Mismatches & Hardware Limitations',
      category: DiagnosticCategory.wiring,
      symptomOverview:
          'Code runs without errors, but the connected component never reacts.',
      commonCauses: [
        'Code defines pin 7 but wire is in pin 8.',
        'Using analogWrite() on a non-PWM pin (missing tilde ~ mark).',
        'Using attachInterrupt() on a pin other than 2 or 3 on Arduino Uno.',
      ],
      theScience:
          'Microcontroller pins have specialized hardware peripherals inside the silicon: timers for PWM (pins 3, 5, 6, 9, 10, 11), ADCs for analog input (pins A0-A5), and hardware interrupt lines (INT0 on pin 2, INT1 on pin 3).',
      kidRule:
          'Look for the squiggly tilde ~ for PWM fading, and check pin numbers twice!',
      stepByStepChecklist: [
        'Trace the jumper wire with your finger from breadboard to Arduino pin.',
        'Double-check the pin declaration at the very top of your Arduino sketch.',
        'For brightness/speed fading, verify the pin is marked with ~.',
      ],
    ),
    FailurePlaybook(
      id: 'playbook_compiler_errors',
      title: 'Deciphering Arduino IDE Compiler Errors',
      category: DiagnosticCategory.compile,
      symptomOverview:
          'Clicking Verify (check mark) turns the bottom console orange with error text.',
      commonCauses: [
        'Missing semicolon at the end of the previous line.',
        'Typo in variable name or keyword (C++ is case sensitive).',
        'Unbalanced curly braces { } causing function nesting errors.',
      ],
      theScience:
          'The C++ compiler operates in passes: preprocessing, lexical tokenizing, syntax parsing, and code generation. When grammar rules are violated, the compiler cannot produce machine instructions.',
      kidRule:
          'Press Ctrl+T to Auto-Format! It instantly reveals missing braces and typos.',
      stepByStepChecklist: [
        'Press Ctrl+T (Cmd+T on Mac) in the Arduino IDE to auto-indent your sketch.',
        'Look at the very FIRST orange error message—fixing it usually resolves subsequent errors.',
        'If it says "expected ;", check the line DIRECTLY ABOVE the red highlight.',
        'Ensure library headers like #include <Wire.h> are at the very top of the file.',
      ],
    ),
    FailurePlaybook(
      id: 'playbook_upload_stk500',
      title: 'Upload Timeouts & Serial Port Conflicts',
      category: DiagnosticCategory.upload,
      symptomOverview:
          'Upload fails with "avrdude: stk500_recv(): programmer is not responding".',
      commonCauses: [
        'Wires connected to Digital Pins 0 (RX) and 1 (TX) during sketch upload.',
        'Wrong COM port or wrong Board model selected in Tools menu.',
        'CH340 USB driver missing on computer.',
      ],
      theScience:
          'The ATmega328P communicates with your PC via universal asynchronous receiver-transmitter (UART) lines routed to pins 0 and 1. If external devices pull those lines HIGH or LOW, the upload data packet frame is corrupted.',
      kidRule:
          'Unplug pins 0 and 1 before uploading! Plug them back in when done uploading.',
      stepByStepChecklist: [
        'Temporarily pull out any wires connected to Pin 0 (RX) and Pin 1 (TX).',
        'Verify Tools -> Board is set to "Arduino Uno".',
        'Verify Tools -> Port has a checkmark next to your connected COM port.',
        'Click Upload. When "Done uploading" appears, re-insert wires into pins 0 and 1.',
      ],
    ),
  ];

  static DiagnosticNode? getNodeById(String id) {
    try {
      return rootNodes.firstWhere((node) => node.id == id);
    } catch (_) {
      return null;
    }
  }
}
