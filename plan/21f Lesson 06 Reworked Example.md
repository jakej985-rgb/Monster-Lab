# 21f Lesson 06 Reworked Example

## Purpose
Expand Lesson 06 into an in-depth 18–22 minute learning module that teaches voltage division, resistive carbon tracks, the 10-bit Successive Approximation Analog-to-Digital Converter (ADC), voltage conversion math, and breadboard wiring with `comp_20`.

## Lesson
**Title:** Potentiometer: Reading Analog Signals
**Tier:** Rookie
**Target Time:** 18–22 minutes
**Prerequisites:** Lesson 05
**XP:** 80
**Components:** `comp_uno`, `comp_breadboard`, `comp_20` (10k Rotary Potentiometer)

---

## Learning Goals
- Distinguish between discrete digital signals (0 or 1) and continuous analog voltages (0.0V to 5.0V).
- Explain the physical operation of a 3-terminal potentiometer as an adjustable voltage divider.
- Explain the internal Analog-to-Digital Converter (ADC) and 10-bit quantization ($2^{10} = 1024$ levels, 0–1023).
- Wire `comp_20` correctly to 5V, GND, and Analog Pin `A0` on a solderless breadboard.
- Read analog values using `analogRead(A0)` and output telemetry to the Serial Monitor.
- Calculate voltage from raw ADC integers ($V = \text{raw} \times \frac{5.0}{1023}$).
- Troubleshoot floating analog inputs and shorted wiper pins.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### Sense the Spectrum: Analog Perception
The physical world is not simply ON or OFF. Temperatures rise and fall smoothly, battery voltages drain gradually, and robot steering angles vary continuously. A potentiometer gives your monster robot continuous analog perception, allowing it to sense fine gradients like steering angles, robotic arm joint positions, and motor throttle.

```
5V Power → Carbon Track → Wiper Picks Off Voltage → ATmega328P 10-bit ADC → Integer (0 to 1023)
```

---

## 2. Prior Knowledge Check
1. **What does `digitalRead()` return?** Only binary `HIGH` (1) or `LOW` (0).
2. **What voltage does the Arduino Uno provide on its 5V rail?** Regulated 5.0 Volts DC.

---

## 3. Core Concept & Vocabulary
- **Potentiometer:** A three-terminal variable resistor with a rotating shaft connected to an internal wiper contact.
- **Voltage Divider:** A circuit of two resistances in series that divides an input voltage into a proportional output fraction.
- **ADC (Analog-to-Digital Converter):** An on-chip silicon peripheral that translates continuous analog voltage into a binary integer.
- **10-Bit Resolution:** $2^{10} = 1024$ discrete measurement steps (~4.88 mV per step on a 5.0V reference).
- **`analogRead()`:** Built-in function that samples an analog pin (`A0`–`A5`) and returns an integer from 0 to 1023.

---

## 4. How It Works
Inside `comp_20`:
1. A horseshoe-shaped resistive carbon track connects Outer Terminal 1 and Outer Terminal 3 (total resistance $\approx 10\text{k}\Omega$).
2. Outer Pin 1 connects to `5V`, and Outer Pin 3 connects to `GND`.
3. Turning the knob sweeps Center Wiper Pin 2 across the track, splitting it into two resistances ($R_1$ and $R_2$):
   $$V_{\text{out}} = 5.0\text{V} \times \frac{R_2}{R_1 + R_2}$$
4. The output voltage connects to Uno Pin `A0`.
5. The ATmega328P's successive-approximation 10-bit ADC quantizes the voltage into an integer:
   $$\text{ADC Count} = \text{round}\left(V_{\text{in}} \times \frac{1023}{5.0\text{V}}\right)$$

---

## 5. Hardware Mission
Examine `comp_20` (10kΩ Potentiometer) and `comp_breadboard`:
1. **Pin Identification:** Notice the 3 pins protruding from the bottom:
   - Pin 1 (Outer Leg): Connect to Uno `5V`.
   - Pin 2 (Center Wiper): Connect to Uno `A0`.
   - Pin 3 (Outer Leg): Connect to Uno `GND`.
2. **Breadboard Placement:** Insert the potentiometer into the breadboard across three separate terminal tie-point rows (e.g., Rows 10, 11, 12). Never place all three pins in the same row!
3. **Connect Jumpers:** Run a red jumper from Uno `5V` to breadboard Row 10, a yellow jumper from Uno `A0` to Row 11, and a black jumper from Uno `GND` to Row 12.

---

## 6. Coding Basics
- Unlike digital pins, Uno analog input pins (`A0`–`A5`) do not require `pinMode()` prior to calling `analogRead()`. The ADC multiplexer hardware automatically configures the pin during conversion.
- `float` data types store decimal numbers for true voltage calculations.

---

## 7. Code Walkthrough
```cpp
const int potPin = A0;

void setup() {
  Serial.begin(9600); // Initialize telemetry link
}

void loop() {
  int rawValue = analogRead(potPin);          // Read ADC count (0 to 1023)
  float voltage = rawValue * (5.0 / 1023.0);  // Convert count to true voltage

  Serial.print("ADC Count: ");
  Serial.print(rawValue);
  Serial.print(" | Voltage: ");
  Serial.print(voltage, 2);
  Serial.println(" V");

  delay(200); // 5 Hz update rate for readable telemetry
}
```

### Breakdown:
- `analogRead(potPin)`: Takes approximately 100 microseconds to sample and hold the analog voltage and execute the 10-bit conversion.
- `voltage = rawValue * (5.0 / 1023.0)`: Scales the integer count to physical volts.
- `Serial.print(voltage, 2)`: Prints the float formatted to 2 decimal places.

---

## 8. Code Prediction
- **Prediction 1:** What will `analogRead(A0)` return if the knob is rotated exactly midway?
  *Answer:* Approximately 511 to 512 counts (~2.50 Volts).
- **Prediction 2:** What happens if you swap the wires connected to Outer Pin 1 and Outer Pin 3?
  *Answer:* The rotation polarity reverses (turning clockwise decreases rather than increases the count).

---

## 9. Guided Experiment
1. Combine Lesson 05 and 06: use `rawValue` directly as the delay period for the Pin 13 LED:
   ```cpp
   digitalWrite(13, HIGH);
   delay(rawValue);
   digitalWrite(13, LOW);
   delay(rawValue);
   ```
2. Turn the knob and observe how physical rotation directly modulates the LED's blinking speed.

---

## 10. Real-World Robot Example
Radio transmitter control sticks, aircraft throttle quadrants, electric vehicle accelerator pedals, and industrial robotic arm joint potentiometers all use rotary voltage division for position telemetry.

---

## 11. Troubleshooting Challenge
### Symptom 1: Potentiometer Gets Burning Hot!
- **Diagnosis:** Dead short! 5V and GND were connected across an outer pin and the center wiper, creating an unrestricted short when turned to the stop.
- **Remedy:** Unplug USB immediately! Verify that 5V and GND connect to the two *outer* legs, and A0 connects to the *center* wiper.

### Symptom 2: Serial Readings Jump Erratically (e.g., 100, 950, 40)
- **Diagnosis:** Floating input! The center wiper wire is loose or plugged into the wrong breadboard row, acting as an antenna picking up ambient 60Hz electromagnetic noise.
- **Remedy:** Firmly seat the wiper wire into the center pin's terminal row.

---

## 12. Workshop Safety & Hardware Care
- Never apply more than 5.0V to an analog pin on an Uno R3. Exceeding 5.5V will forward-bias the internal silicon clamping diodes and destroy the ADC multiplexer.
- Avoid applying mechanical torque beyond the physical rotation stops of the potentiometer.

---

## 13. Knowledge Check (8 Questions)
1. **What range of integer values is returned by `analogRead()` on an Arduino Uno?**
   - [x] 0 to 1023
   - [ ] 0 to 255
   - [ ] -512 to +512

2. **What is the resolution of the built-in ADC on an Arduino Uno?**
   - [x] 10-bit (1024 discrete levels)
   - [ ] 8-bit (256 discrete levels)
   - [ ] 16-bit (65536 discrete levels)

3. **If `analogRead(A0)` returns 1023, what voltage is present on pin A0?**
   - [x] 5.0 Volts
   - [ ] 2.5 Volts
   - [ ] 10.23 Volts

4. **Which terminal of a standard 3-pin potentiometer connects to the variable wiper?**
   - [x] The middle terminal
   - [ ] The leftmost terminal
   - [ ] The mounting metal tab

5. **What electrical circuit principle does a potentiometer utilize to produce variable voltage?**
   - [x] Voltage divider
   - [ ] Inductive coupling
   - [ ] Rectification

6. **Approximately how many millivolts does each single ADC step represent on a 5V Uno?**
   - [x] ~4.88 mV (5.0V / 1024)
   - [ ] ~100 mV
   - [ ] ~0.01 mV

7. **Why is `pinMode(A0, INPUT)` not strictly mandatory before calling `analogRead(A0)`?**
   - [x] `analogRead()` automatically switches the pin multiplexer to ADC input mode
   - [ ] Analog pins cannot be configured as digital pins
   - [ ] The Arduino detects hardware connections automatically

8. **What causes an analog input reading to jump erratically when nothing is touched?**
   - [x] A floating input wire acting as an antenna picking up electromagnetic interference
   - [ ] A dead microcontroller battery
   - [ ] Excessively high baud rate

---

## 14. Final Review
- Potentiometers act as variable voltage dividers producing 0.0V to 5.0V.
- The 10-bit ADC quantizes analog voltages into integers from 0 to 1023 (~4.88 mV per count).
- Solderless breadboards connect rows horizontally—keep pins in separate rows.
- Up next in Lesson 07: Modulating digital duty cycles with PWM to mix colors on an RGB LED.

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (Voltage Division Math) | 2–3 min |
| 5. Hardware Mission (Breadboard Wiring comp_20) | 3–4 min |
| 6. Coding Basics (analogRead & float math) | 2 min |
| 7. Code Walkthrough | 2 min |
| 8. Code Prediction | 1 min |
| 9. Guided Experiment (Potentiometer Blink Rate) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–22 min** |

---

## Implementation Notes
- Interactive simulator pairing: integrates with `PotentiometerSimulatorWidget` (`potentiometerSimulator`).
- Component cross-references: `comp_uno`, `comp_breadboard`, `comp_20`.
- Milestone XP award: 80 XP.

---

## Done When
- Lesson provides 18–22 minutes of rigorous analog electronics instruction.
- Learner understands voltage division, ADC quantization, and floating input prevention.
- Learner builds the physical circuit on breadboard and views telemetry in Serial Monitor.
- All 8 assessment questions pass cleanly.
