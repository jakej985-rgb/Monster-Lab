# 21g Lesson 07 Reworked Example

## Purpose
Expand Lesson 07 into a rich 18–22 minute learning module that explores additive optical color mixing, Common Cathode vs Common Anode packaging, Pulse Width Modulation (PWM) duty cycles, hardware timer compare registers, and 8-bit `analogWrite()` control across Uno PWM pins.

## Lesson
**Title:** RGB LED: Mixing Colors with PWM
**Tier:** Rookie
**Target Time:** 18–22 minutes
**Prerequisites:** Lesson 05
**XP:** 90
**Components:** `comp_uno`, `comp_breadboard`

---

## Learning Goals
- Explain additive color theory (Red + Green + Blue light combination).
- Distinguish between Common Cathode (shared GND) and Common Anode (shared 5V) packages.
- Explain Pulse Width Modulation (PWM), period frequency (~490 Hz / 980 Hz), and duty cycle percentage.
- Identify PWM-capable hardware pins on the Uno (marked with `~`: 3, 5, 6, 9, 10, 11).
- Output 8-bit PWM levels (0–255) using `analogWrite()`.
- Calculate duty cycle percentages from integer values ($D = \frac{\text{value}}{255} \times 100\%$).
- Troubleshoot non-PWM pins and inverted common anode polarity.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### Expressive Monsters: Crafting Living Light
Monsters need emotion and visual expression! By combining three primary wavelengths of light—Red, Green, and Blue—at varying intensities, we can create any color in the visible rainbow, from energetic yellow to menacing purple or calm cyan.

Because the Arduino Uno does not have true analog output voltage DACs on its digital pins, we use high-speed silicon pulsing—Pulse Width Modulation—to fool the human eye into perceiving smooth brightness levels!

```
Timer Register OCR1A → High-Speed 490Hz Pulse Train → Duty Cycle Average → Eye Cone Cells → Perceived Color
```

---

## 2. Prior Knowledge Check
1. **How does an LED emit light?** Electric current passes forward through a semiconductor diode junction, releasing photons.
2. **Why does an LED need a series resistor?** To limit forward current and prevent the semiconductor die from thermal runaway.

---

## 3. Core Concept & Vocabulary
- **RGB LED:** A single component packaging three independent semiconductor dies (Red, Green, Blue) sharing common electrical pins.
- **Common Cathode:** Configuration where all three LEDs share a single negative Ground (`-`) lead.
- **Pulse Width Modulation (PWM):** Digital technique of switching an output between 5V and 0V hundreds of times per second to simulate intermediate voltages.
- **Duty Cycle:** The ratio or percentage of time a square wave pulse remains in the `HIGH` state during one full period.
- **`analogWrite()`:** Built-in function generating 8-bit PWM (0 = 0% duty cycle / 0V average; 255 = 100% duty cycle / 5V continuous).

---

## 4. How It Works
Human photoreceptor cone cells cannot resolve light pulses cycling faster than approximately 60 Hz (persistence of vision).
1. The ATmega328P hardware timers oscillate at ~490 Hz (Pins 9, 10, 11, 3) or ~980 Hz (Pins 5, 6).
2. Setting `analogWrite(pin, 127)` configures the timer to drive the pin to 5V for 50% of the period, and 0V for the remaining 50%.
3. The human eye integrates this photon flux, perceiving exactly 50% brightness.
4. By mixing different duty cycles across Red, Green, and Blue channels, the three primary wavelengths stimulate retina cone cells in varying proportions to synthesize over 16 million colors!

---

## 5. Hardware Mission
Examine a 4-pin 5mm Common Cathode RGB LED:
1. **Lead Identification:** Hold the LED with the flat edge on the plastic rim facing right:
   - Lead 1 (Outer Leg): Red Anode
   - Lead 2 (Longest Leg): Common Cathode (GND)
   - Lead 3: Green Anode
   - Lead 4 (Outer Leg): Blue Anode
2. **Breadboard Insertion:** Insert the 4 leads into 4 adjacent breadboard rows.
3. **Current Limiting Resistors:** Connect a 220Ω or 330Ω resistor to Lead 1 (Red), Lead 3 (Green), and Lead 4 (Blue). Connect Lead 2 directly to Uno `GND`.
4. **PWM Pin Wiring:** Connect Red resistor to Pin 9, Green resistor to Pin 10, and Blue resistor to Pin 11.

---

## 6. Coding Basics
- `analogWrite(pin, value)` does NOT generate true analog DC voltage; it modulates hardware timer compare registers.
- Valid values are integers from `0` to `255` (8-bit quantization).

---

## 7. Code Walkthrough
```cpp
const int redPin = 9;
const int greenPin = 10;
const int bluePin = 11;

void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void setColor(int r, int g, int b) {
  analogWrite(redPin, constrain(r, 0, 255));
  analogWrite(greenPin, constrain(g, 0, 255));
  analogWrite(bluePin, constrain(b, 0, 255));
}

void loop() {
  setColor(255, 0, 255);   // Purple (Red + Blue)
  delay(1000);
  setColor(255, 120, 0);   // Monster Amber/Orange
  delay(1000);
  setColor(0, 255, 255);   // Cyan (Green + Blue)
  delay(1000);
}
```

### Breakdown:
- `setColor(...)`: Modular helper function encapsulating multi-channel mixing.
- `constrain(val, 0, 255)`: Defensive programming ensuring PWM values stay within the valid 8-bit window.
- In `loop()`, high-level colors transition every second.

---

## 8. Code Prediction
- **Prediction 1:** What color appears when `setColor(255, 255, 0)` executes?
  *Answer:* Bright Yellow (equal parts full-intensity Red and Green light).
- **Prediction 2:** What happens if you plug the Blue LED jumper into Digital Pin 8 instead of Pin 11?
  *Answer:* Digital Pin 8 does NOT support hardware PWM on the Uno; `analogWrite(8, 128)` will not produce variable dimming—it will jump abruptly between fully on and fully off.

---

## 9. Guided Experiment
1. Wire the Potentiometer from Lesson 06 into Analog Pin `A0`.
2. Map its reading to the Blue channel while keeping Red fixed at 128:
   ```cpp
   int knob = analogRead(A0);
   int blueVal = map(knob, 0, 1023, 0, 255);
   setColor(128, 0, blueVal);
   ```
3. Rotate the knob to dial smoothly between deep red, magenta, and bright violet!

---

## 10. Real-World Robot Example
Full-color gaming PC illumination, automotive dynamic ambient lighting, smart home lightbulbs (Philips Hue), and multi-colored warning beacons on autonomous warehouse rovers rely on multi-channel PWM color synthesis.

---

## 11. Troubleshooting Challenge
### Symptom 1: Inverted Brightness
- **Symptom:** Passing `255` turns the LED off, and passing `0` turns it fully on.
- **Diagnosis:** Common Anode LED! You have a common anode component whose shared lead is connected to 5V instead of GND.
- **Remedy:** Connect common lead to 5V and invert code logic: `analogWrite(pin, 255 - value)`.

### Symptom 2: Red Is Blindingly Bright, Blue Is Very Dim
- **Diagnosis:** Forward voltage disparity: Red diodes have a lower forward drop ($V_f \approx 1.8\text{V}$), while Blue diodes require $V_f \approx 3.2\text{V}$.
- **Remedy:** Use a higher value resistor (330Ω or 470Ω) on the Red anode line to balance luminous intensity.

---

## 12. Workshop Safety & Hardware Care
- Never connect all three color leads directly to 5V or output pins without current-limiting resistors. Three concurrent short circuits can draw >120mA, tripping thermal protection.
- Ensure the longest pin (cathode) connects to GND, not 5V, to prevent reverse voltage breakdown.

---

## 13. Knowledge Check (8 Questions)
1. **What does PWM stand for?**
   - [x] Pulse Width Modulation
   - [ ] Power Wave Measurement
   - [ ] Phase Wire Multiplication

2. **What is the valid argument range for `analogWrite()` on an Arduino Uno?**
   - [x] 0 to 255 (8-bit)
   - [ ] 0 to 1023 (10-bit)
   - [ ] 0 to 100 (%)

3. **Which digital pins on the Arduino Uno support hardware PWM?**
   - [x] Pins marked with a tilde (~): 3, 5, 6, 9, 10, 11
   - [ ] All digital pins 0 through 13
   - [ ] Only analog pins A0 through A5

4. **What primary colors of light combine to produce Yellow?**
   - [x] Red and Green
   - [ ] Blue and Yellow
   - [ ] Red and Blue

5. **What duty cycle percentage does an `analogWrite()` value of 127 produce?**
   - [x] Approximately 50%
   - [ ] 10%
   - [ ] 100%

6. **On a 4-pin common cathode RGB LED, what does the longest lead connect to?**
   - [x] Ground (GND)
   - [ ] 5V Power
   - [ ] Digital Pin 13

7. **Why does an LED appear dimmer when fed a 25% duty cycle PWM signal?**
   - [x] The LED is off for 75% of the time, and the human eye averages the photon emission
   - [ ] The voltage is reduced from 5V to 1.25V DC
   - [ ] The resistor value increases dynamically

8. **What primary colors combine to produce Cyan?**
   - [x] Green and Blue
   - [ ] Red and Blue
   - [ ] Red and Green

---

## 14. Final Review
- Additive optics combines Red, Green, and Blue light to create full-spectrum color.
- PWM modulates duty cycles at hundreds of hertz to simulate variable voltage without true DACs.
- Always use series resistors on each color channel to balance currents and prevent burnouts.
- Up next in Lesson 08: Reading mechanical pushbuttons, debouncing, and internal pull-up resistors.

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (PWM Timers & Retina Persistence) | 2–3 min |
| 5. Hardware Mission (RGB LED Lead Tour & Wiring) | 3–4 min |
| 6. Coding Basics (analogWrite & 8-bit quantization) | 2 min |
| 7. Code Walkthrough | 2 min |
| 8. Code Prediction | 1 min |
| 9. Guided Experiment (Potentiometer Hue Mixing) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–22 min** |

---

## Implementation Notes
- Interactive simulator pairing: integrates with `RgbMixerWidget` (`rgbMixer`).
- Component cross-references: `comp_uno`, `comp_breadboard`.
- Milestone XP award: 90 XP.

---

## Done When
- Lesson provides 18–22 minutes of rigorous optics and PWM timing instruction.
- Learner understands duty cycles, additive light mixing, and hardware PWM pins.
- Learner wires RGB LED on breadboard and mixes primary/secondary hues.
- All 8 assessment questions pass cleanly.
