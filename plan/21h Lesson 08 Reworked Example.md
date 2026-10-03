# 21h Lesson 08 Reworked Example

## Purpose
Expand Lesson 08 into a comprehensive 16–20 minute learning module that unpacks digital input sensing, high-impedance floating pin vulnerabilities, the ATmega328P internal 20k–50kΩ pull-up resistor architecture, active-low logic inversion, and mechanical switch contact debouncing.

## Lesson
**Title:** Digital Inputs: Pushbuttons & Internal Pullups
**Tier:** Rookie
**Target Time:** 16–20 minutes
**Prerequisites:** Lesson 05
**XP:** 70
**Components:** `comp_uno`, `comp_breadboard`

---

## Learning Goals
- Understand digital input sensing and read binary states using `digitalRead()`.
- Explain high-impedance inputs and the severe vulnerability of "floating pins".
- Explain the internal pull-up resistor architecture of the ATmega328P microcontroller.
- Configure `pinMode(pin, INPUT_PULLUP)` and master active-low inverted logic (Pressed = `LOW`).
- Understand the physics of mechanical switch contacts and switch chatter/bounce.
- Construct a tactile momentary button circuit on a solderless breadboard.
- Troubleshoot erratic triggers, orientation bugs, and floating state noise.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### Collision Senses: Tactile Bump Detection
Robots need physical bump sensors to detect wall collisions, mechanical limit switches to prevent robotic arm gear jamming, and emergency stop triggers to prevent accidents. A simple mechanical pushbutton turns physical pressure into electrical continuity.

However, microcontrollers do not sense buttons the way humans do. If you wire a button improperly, the pin will act as a radio antenna, triggering phantom ghost presses! In this lesson, you will master the internal pull-up resistor trick used by professional embedded engineers.

```
Button Open → 30kΩ Internal Pull-Up to 5V → digitalRead() reads HIGH
Button Pressed → Contacts Close to GND → Current Drains to 0V → digitalRead() reads LOW
```

---

## 2. Prior Knowledge Check
1. **What voltage defines a digital `LOW` state?** 0.0 Volts (connected to Ground).
2. **What happens to an electrical circuit when the path to ground is broken?** Current stops flowing; it becomes an open circuit.

---

## 3. Core Concept & Vocabulary
- **`digitalRead()`:** Function that measures an input pin, returning `HIGH` (if voltage $\ge 3.0\text{V}$) or `LOW` (if voltage $\le 1.5\text{V}$).
- **Floating Pin:** An unconnected high-impedance input pin that acts as an antenna, picking up stray electromagnetic fields and oscillating erratically.
- **Pull-Up Resistor:** A resistor connecting an input pin to 5V, guaranteeing a stable, deterministic `HIGH` state when a switch is open.
- **`INPUT_PULLUP`:** Built-in mode configuring the ATmega328P's internal 20kΩ–50kΩ pull-up resistor, eliminating the need for an external breadboard resistor.
- **Active-Low Logic:** Circuit architecture where 0V (`LOW`) signals the active/pressed state, and 5V (`HIGH`) signals idle.
- **Switch Bounce:** Microsecond mechanical vibrations when switch metal contacts collide, creating multiple rapid false triggers.

---

## 4. How It Works
Inside the ATmega328P input buffer:
1. When configured with `INPUT_PULLUP`, an internal P-FET engages a ~30kΩ resistor tied to 5V.
2. When the external button is open (unpressed), tiny leakage currents flow through the pull-up, holding the pin securely at 5.0V (`HIGH`).
3. When the button is pressed, it shorts the pin directly to Ground (0V). Because the internal pull-up has a high 30kΩ resistance, only $\frac{5\text{V}}{30\text{k}\Omega} \approx 0.16\text{ mA}$ flows harmlessly to ground.
4. The input Schmitt trigger detects 0V and reports `LOW`.

---

## 5. Hardware Mission
Examine a 4-pin tactile momentary pushbutton and `comp_breadboard`:
1. **Understand Pin Pairs:** A 4-pin pushbutton has two internal metal bars. The pins across from each other along the length of the package are permanently connected together.
2. **Breadboard Straddling:** Place the pushbutton so it straddles the center divider trench of the breadboard (e.g. Pins in Row 15 columns D and G). This guarantees left pins are isolated from right pins until pressed.
3. **Simple 2-Wire Connection:**
   - Connect one leg of the switch to Uno Digital Pin 2.
   - Connect the opposite leg of the switch to Uno `GND`.
   - *Notice: No 5V wire or external resistor is needed on the breadboard!*

---

## 6. Coding Basics
Because of active-low logic:
```cpp
if (digitalRead(buttonPin) == LOW) {
  // ACTION: Button IS physically pressed!
} else {
  // IDLE: Button is released!
}
```

---

## 7. Code Walkthrough
```cpp
const int buttonPin = 2;
const int ledPin = 13;

void setup() {
  pinMode(buttonPin, INPUT_PULLUP); // Enable built-in 30k pull-up resistor
  pinMode(ledPin, OUTPUT);          // Status LED
  Serial.begin(9600);
}

void loop() {
  int buttonState = digitalRead(buttonPin);

  if (buttonState == LOW) { // Button is pressed to GND
    digitalWrite(ledPin, HIGH);
    Serial.println("BUMP DETECTED! Reversing motors...");
  } else {
    digitalWrite(ledPin, LOW);
  }
}
```

### Breakdown:
- `pinMode(buttonPin, INPUT_PULLUP)`: Crucial line preventing floating state.
- `if (buttonState == LOW)`: Directly evaluates the active-low contact closure.
- Response executes with zero noticeable latency.

---

## 8. Code Prediction
- **Prediction 1:** What will `digitalRead(2)` return if the button is NOT pressed?
  *Answer:* `HIGH` (held at 5V by the internal pull-up).
- **Prediction 2:** What happens if you configure `pinMode(2, INPUT)` without an external resistor?
  *Answer:* The pin floats; waving your hand near the wire or touching the insulation causes the LED to flicker randomly due to electrostatic coupling.

---

## 9. Guided Experiment
1. Create a push-to-toggle counter:
   ```cpp
   int count = 0;
   void loop() {
     if (digitalRead(buttonPin) == LOW) {
       count++;
       Serial.print("Press Count: ");
       Serial.println(count);
       delay(200); // Simple software debounce delay
     }
   }
   ```
2. Press the button quickly and observe how a 200ms delay prevents mechanical switch bounce from registering 5 presses for 1 physical click.

---

## 10. Real-World Robot Example
Industrial emergency stop (E-stop) mushroom buttons, robotic 3D printer axis limit switches, and missile interlocks are hardwired active-low (normally closed). If an interconnect cable is severed or broken, the circuit immediately drops to open/triggered, halting the machine as a fail-safe!

---

## 11. Troubleshooting Challenge
### Symptom 1: Button Always Reads LOW Whether Pressed or Released
- **Diagnosis:** Orientation error! The button is rotated 90 degrees on the breadboard, causing the permanently shorted internal pin pairs to bridge the circuit.
- **Remedy:** Rotate the button 90 degrees so the curved leads straddle the breadboard center trench.

### Symptom 2: Button Triggers When Fingers Approach Without Touching
- **Diagnosis:** Floating pin! The sketch used `pinMode(2, INPUT)` instead of `INPUT_PULLUP`.
- **Remedy:** Add `_PULLUP` to the `pinMode` declaration.

---

## 12. Workshop Safety & Hardware Care
- Never wire an input pin directly to 5V and then close a switch directly to GND without a current-limiting resistor, as this creates a direct dead short across the 5V power bus!
- Always connect the switch between the pin and GND when using `INPUT_PULLUP`.

---

## 13. Knowledge Check (8 Questions)
1. **What state does a pin configured with `INPUT_PULLUP` read when the button is open (unpressed)?**
   - [x] HIGH
   - [ ] LOW
   - [ ] Floating

2. **What is a "floating" digital pin?**
   - [x] An unconnected high-impedance input that fluctuates randomly from electromagnetic noise
   - [ ] A pin submerged in water
   - [ ] A pin configured as both input and output simultaneously

3. **Why is `INPUT_PULLUP` preferred for simple pushbutton circuits?**
   - [x] It eliminates the need for an external physical resistor on the breadboard
   - [ ] It makes buttons click louder
   - [ ] It allows buttons to operate over Wi-Fi

4. **When using active-low logic with a pull-up, what value indicates the button is pressed?**
   - [x] LOW (0)
   - [ ] HIGH (1)
   - [ ] 1023

5. **What physical phenomenon causes a single mechanical button press to register multiple times?**
   - [x] Switch bounce (contact chatter)
   - [ ] Inductive kickback
   - [ ] Serial overflow

6. **Approximately what resistance value does the ATmega328P internal pull-up provide?**
   - [x] 20kΩ to 50kΩ
   - [ ] 1Ω
   - [ ] 10MΩ

7. **How should a momentary button be wired when using `INPUT_PULLUP`?**
   - [x] One terminal to the digital pin, the other terminal to GND
   - [ ] One terminal to 5V, the other to 12V
   - [ ] One terminal to A0, the other to 3.3V

8. **In robotics, why are emergency limit switches typically wired active-low?**
   - [x] Fail-safe protection: if a wire breaks, the system detects it immediately as triggered
   - [ ] To save battery power
   - [ ] It reduces code size

---

## 14. Final Review
- High-impedance inputs float without a defined pull-up or pull-down reference.
- `INPUT_PULLUP` engages on-chip resistors, simplifying breadboard wiring.
- Active-low logic treats `LOW` as pressed and `HIGH` as unpressed.
- Software debounce delays tame mechanical contact bounce.
- Up next in Lesson 09: Connecting multi-sensor networks over two wires with the I2C bus.

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (Internal Pull-Up Circuitry) | 2–3 min |
| 5. Hardware Mission (Breadboard Switch Straddling) | 3 min |
| 6. Coding Basics (Active-Low Inversion) | 2 min |
| 7. Code Walkthrough | 2 min |
| 8. Code Prediction | 1 min |
| 9. Guided Experiment (Debounce Counter) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–20 min** |

---

## Implementation Notes
- Component cross-references: `comp_uno`, `comp_breadboard`.
- Milestone XP award: 70 XP.

---

## Done When
- Lesson provides 16–20 minutes of rigorous digital input instruction.
- Learner understands floating pins, active-low logic, and internal pull-ups.
- Learner wires physical button to GND and verifies clean trigger telemetry.
- All 8 assessment questions pass cleanly.
