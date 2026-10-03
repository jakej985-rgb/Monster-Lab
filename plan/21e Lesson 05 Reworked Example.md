# 21e Lesson 05 Reworked Example

## Purpose
Expand Lesson 05 into an authentic 18–22 minute learning module that bridges abstract binary code to physical electron flow, teaching digital output states (`HIGH` vs `LOW`), `pinMode(OUTPUT)` transistor driver physics, the built-in Pin 13 LED (`L`), persistence of vision, and ATmega328P output pin current limits.

## Lesson
**Title:** Blink: Your First Physical Circuit
**Tier:** Rookie
**Target Time:** 18–22 minutes
**Prerequisites:** Lesson 04
**XP:** 75
**Components:** `comp_uno` (Arduino Uno R3)

---

## Learning Goals
- Define digital output states: `HIGH` (5.0V) and `LOW` (0.0V).
- Explain `pinMode(pin, OUTPUT)` and understand high-impedance vs push-pull output driver states.
- Locate the on-board surface-mount LED connected to Digital Pin 13 (labeled `L`).
- Trace electrical current paths from the ATmega328P output pin through the series resistor to ground.
- Walk through the canonical Blink sketch and predict blink cadences.
- Understand human persistence of vision and high-frequency flashing (>50 Hz).
- Understand maximum pin current limits (20mA continuous / 40mA absolute max).
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### Awaken the Beast: Creating Physical Photons
Software becomes robotics when binary logic gates physically manipulate the physical universe. Turning an LED on and off is the "Hello World" of embedded engineering, validating that the microcontroller output transistors can source and sink electrical current under software command.

In this mission, you will command electrical charges through silicon gates to create visible light on your Arduino board!

```
PORTB5 Register → Internal P-MOSFET Closes → Pin 13 at 5V → Current Flows → SMD LED Glows → GND Return
```

---

## 2. Prior Knowledge Check
1. **What is a digital signal?** An electrical signal that exists in one of two discrete states: HIGH or LOW.
2. **What is GND?** Ground—the 0V reference return path required for electric current to complete a circuit loop.

---

## 3. Core Concept & Vocabulary
- **`digitalWrite()`:** Function that commands an output pin to 5V (`HIGH`) or 0V (`LOW`).
- **`pinMode()`:** Function that configures internal silicon transistors for high-impedance listening (`INPUT`) or low-impedance driving (`OUTPUT`).
- **`OUTPUT`:** Push-pull driver mode capable of sourcing or sinking electrical current to external components.
- **`delay()`:** Pauses microcontroller execution for a specified number of milliseconds (1/1000th of a second).
- **Built-in LED (Pin 13):** The surface-mount amber LED hardwired directly to Digital Pin 13 on the Uno PCB.

---

## 4. How It Works
Inside the ATmega328P microcontroller chip:
1. Executing `digitalWrite(13, HIGH)` sets bit 5 of the `PORTB` register.
2. An internal P-channel MOSFET turns on, connecting Pin 13 to the internal 5.0V power rail.
3. Current (~5–10 mA) flows out through Pin 13, passes through an on-board 1kΩ SMD series resistor, enters the amber LED anode, excites photons across the semiconductor bandgap, exits the cathode, and returns to `GND`.
4. Executing `digitalWrite(13, LOW)` turns on an internal N-channel MOSFET, tying Pin 13 directly to `GND` (0V). With no voltage difference across the LED, current stops flowing and the light extinguishes.

---

## 5. Hardware Mission
Inspect your Arduino Uno R3 (`comp_uno`):
1. **Locate the 'L' LED:** Look between the digital pin headers (Pins 8–13) and the main microcontroller chip. Find the tiny rectangular amber LED labeled with a silkscreened `L`.
2. **Trace the Silkscreen:** Follow the fine copper PCB trace running between Digital Pin 13 and the `L` indicator.
3. **Power Verification:** Notice the green `ON` LED nearby. The green LED shows the 5V power bus is energized, while the amber `L` LED is completely under software control!

---

## 6. Coding Basics
- **Constants in Arduino Core:** `HIGH` is defined as integer `1`; `LOW` is defined as integer `0`.
- **`OUTPUT` Mode:** Must be declared in `setup()` before `digitalWrite()` can deliver active drive current. Without `pinMode(OUTPUT)`, the pin remains in high-impedance `INPUT` mode.

---

## 7. Code Walkthrough
```cpp
const int ledPin = 13; // Built-in LED pin

void setup() {
  pinMode(ledPin, OUTPUT); // Configure Pin 13 as a low-impedance output
}

void loop() {
  digitalWrite(ledPin, HIGH); // Drive Pin 13 to 5V (turn LED ON)
  delay(1000);                // Maintain state for 1000 ms (1 second)
  digitalWrite(ledPin, LOW);  // Drive Pin 13 to 0V (turn LED OFF)
  delay(1000);                // Maintain state for 1000 ms (1 second)
}
```

### Key Elements:
- `const int ledPin = 13;`: Descriptive constant prevents accidental pin number modification.
- `pinMode(ledPin, OUTPUT);`: Switches internal transistors from high-impedance mode to active push-pull driver.
- `digitalWrite(ledPin, HIGH)`: Sinks current through LED to ground.
- `delay(1000)`: Freezes execution so the human eye has time to observe the lit state.

---

## 8. Code Prediction
- **Prediction 1:** What happens if `delay(1000)` is changed to `delay(10)` for both ON and OFF states?
  *Answer:* The LED flashes at 50 Hz. Due to human *persistence of vision*, the eye cannot resolve individual flashes; it appears steadily lit at approximately half brightness.
- **Prediction 2:** What happens if `pinMode(13, OUTPUT)` is omitted from `setup()`?
  *Answer:* Pin 13 defaults to high-impedance `INPUT`. `digitalWrite(HIGH)` merely enables the weak internal 30kΩ pull-up resistor, making the LED illuminate so faintly it is barely visible in a dark room.

---

## 9. Guided Experiment
1. Create an asymmetric "strobe heartbeat" cadence:
   ```cpp
   digitalWrite(ledPin, HIGH);
   delay(100); // Quick flash
   digitalWrite(ledPin, LOW);
   delay(900); // Long pause
   ```
2. Predict the pattern, upload, and observe the rapid pulse effect used in drone navigation beacons.

---

## 10. Real-World Robot Example
Status indicator lights on satellites, medical ventilators, automated factory cells, and quadcopter flight controllers use pulsed blink patterns to convey hardware health, error codes, and battery telemetry even if primary video screens crash.

---

## 11. Troubleshooting Challenge
### Symptom 1: LED Stays Solid ON and Never Blinks
- **Diagnosis:** Missing second `delay()`, or both `digitalWrite` calls are set to `HIGH`.
- **Remedy:** Verify that `digitalWrite(ledPin, LOW)` is followed by a `delay()`.

### Symptom 2: Upload Fails (`programmer is not responding`)
- **Diagnosis:** The USB cable lost connection or the wrong COM port is selected in the IDE.
- **Remedy:** Check USB connection, confirm `Tools > Port`, and retry upload.

---

## 12. Workshop Safety & Hardware Care
- **Pin Current Limits:** An ATmega328P output pin has an absolute maximum current rating of 40 mA (recommended 20 mA continuous).
- **Current Limiting Resistors:** Never wire an external LED directly between an Uno pin and GND without a 220Ω–1kΩ current-limiting resistor, or the pin's internal driver FET will burn out.
- The built-in Pin 13 LED already has a built-in SMD resistor on the PCB, making it safe for immediate experimentation.

---

## 13. Knowledge Check (8 Questions)
1. **What voltage level does `digitalWrite(pin, HIGH)` produce on an Arduino Uno?**
   - [x] 5.0 Volts
   - [ ] 0.0 Volts
   - [ ] 12.0 Volts

2. **How many milliseconds are in 1.5 seconds?**
   - [x] 1500 ms
   - [ ] 150 ms
   - [ ] 15 ms

3. **Why must you call `pinMode(pin, OUTPUT)` before writing to a pin?**
   - [x] To switch internal pin transistors from high-impedance listening to active voltage driving
   - [ ] To supply 12V to the USB port
   - [ ] To download the sketch to EEPROM

4. **Which digital pin on the Arduino Uno is wired directly to the on-board amber 'L' LED?**
   - [x] Pin 13
   - [ ] Pin 0
   - [ ] Pin A0

5. **What visual phenomenon causes an LED flashing at 100 Hz to appear continuously solid?**
   - [x] Persistence of vision
   - [ ] Capacitive filtering
   - [ ] Inductive kickback

6. **What happens if you omit the `delay()` between turning the LED OFF and turning it back ON in `loop()`?**
   - [x] The LED turns back on so quickly the off-state is imperceptible
   - [ ] The microcontroller halts
   - [ ] The LED burns out

7. **What is the maximum safe continuous current that should be drawn from an Uno I/O pin?**
   - [x] Approximately 20 mA
   - [ ] 5 Amps
   - [ ] 500 mA

8. **What does `digitalWrite(pin, LOW)` connect the output pin to internally?**
   - [x] Ground (0V reference)
   - [ ] 5V power supply
   - [ ] Analog-to-digital converter

---

## 14. Final Review
- Digital outputs switch between 5V (`HIGH`) and 0V (`LOW`).
- `pinMode(OUTPUT)` enables the push-pull transistor drivers.
- `delay()` regulates timing; rapid toggling (>50Hz) triggers persistence of vision.
- Respect pin current limits (20mA) to preserve microcontroller silicon.
- Up next in Lesson 06: Reading continuous analog voltages with a potentiometer and 10-bit ADC.

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (Silicon Transistors & Paths) | 2–3 min |
| 5. Hardware Mission (Pin 13 'L' Silkscreen Tour) | 2–3 min |
| 6. Coding Basics (pinMode, HIGH/LOW constants) | 2 min |
| 7. Code Walkthrough | 2 min |
| 8. Code Prediction (Persistence of Vision) | 1–2 min |
| 9. Guided Experiment (Asymmetric Strobe) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety Limits | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–22 min** |

---

## Implementation Notes
- Component cross-reference corrected: uses `comp_uno` (built-in Pin 13 LED), not `comp_34`.
- Interactive simulator pairing: integrates with `BlinkSimulatorWidget` (`blinkSimulator`).
- Milestone XP award: 75 XP.

---

## Done When
- Lesson provides 18–22 minutes of rigorous hardware-software instruction.
- Learner understands electrical output states, transistor driving, and persistence of vision.
- Learner successfully flashes the on-board LED and modifies cadences.
- All 8 assessment questions pass cleanly.
