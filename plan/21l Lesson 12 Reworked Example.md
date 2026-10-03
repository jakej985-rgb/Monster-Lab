# 21l Lesson 12 Reworked Example

## Purpose
Expand Lesson 12 into a premier 20–25 minute capstone engineering module covering DC motor electromagnetic physics, Lorentz forces, inductive kickback (back-EMF), Lenz's Law ($V = -L \frac{di}{dt}$), flyback diode clamping, H-Bridge bidirectional transistor topologies, separate logic/motor power supplies, shared grounds, and hardware interfacing with `comp_l293d`.

## Lesson
**Title:** PWM & Motor Physics
**Tier:** Engineer
**Target Time:** 20–25 minutes
**Prerequisites:** Lesson 06, Lesson 07
**XP:** 100
**Components:** `comp_uno`, `comp_33` (Toy DC Motor), `comp_36` (Relay), `comp_l293d` (Dual H-Bridge IC)

---

## Learning Goals
- Understand DC motor electromagnetic physics: coils, rotor commutators, magnetic flux, and torque generation.
- Explain inductive kickback (back-EMF) and Lenz's Law ($V = -L \frac{di}{dt}$).
- Explain why microcontroller pins (~20mA) cannot power DC motors directly (stall current 500mA–2A).
- Implement flyback diodes across inductive loads to suppress high-voltage spikes.
- Explain H-Bridge transistor topology for bidirectional direction control and PWM speed modulation.
- Wire `comp_l293d` (Dual H-Bridge IC) with separate logic 5V and external motor battery power.
- Troubleshoot brownout resets, shoot-through short circuits, and deadband static friction.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### High Current & Raw Power: The Muscle of Robotics
Robots must move, climb, steer, and grip! But motors are hungry, violent electrical beasts. Unlike delicate LEDs that consume just 10 milliamps, motors contain heavy coils of copper wire that store magnetic energy. Connecting a motor directly to an Arduino pin will immediately fry the microcontroller or cause violent resets.

In this capstone lesson, you will master the physics of inductive kickback, flyback diode protection, and dual H-Bridge circuits to command high-power robotic actuators!

```
Arduino Uno (5V Logic) ─── Pins 7, 8, 9 ───► L293D H-Bridge Driver IC ◄─── External 9V Battery
                                                    │
                                                    ▼
                                            High-Power DC Motor
```

---

## 2. Prior Knowledge Check
1. **What is PWM duty cycle?** The percentage of time a digital pulse wave remains HIGH in one period.
2. **What is the maximum safe continuous current from an Arduino I/O pin?** Approximately 20 mA.

---

## 3. Core Concept & Vocabulary
- **Inductance ($L$):** The property of an electrical conductor opposing changes in electric current by storing energy in a magnetic field.
- **Inductive Kickback (Back-EMF):** A massive voltage spike (>50V) generated when coil current abruptly stops ($V = -L \frac{di}{dt}$).
- **Flyback Diode:** A reverse-biased diode placed in parallel with an inductive coil to safely recirculate and dissipate kickback spikes.
- **H-Bridge:** A circuit of 4 controllable switches (transistors) allowing voltage to be applied across a motor in either direction.
- **Stall Current:** Peak current drawn when the motor shaft is physically prevented from rotating.
- **Common Ground:** Connecting external motor battery ground and Arduino ground together to establish an identical 0V reference.

---

## 4. How It Works
When current passes through the motor coils:
1. Electric current creates a magnetic field that interacts with permanent magnets, generating rotational torque (Lorentz Force).
2. When the control transistor abruptly opens:
   - Current drops rapidly ($\frac{di}{dt} \to -\infty$).
   - The collapsing magnetic field induces a reverse high-voltage spike according to Lenz's Law: $V = -L \frac{di}{dt}$.
   - Without protection, this 60V+ spike arcs across transistor junctions, destroying the driver.
3. The **Flyback Diode** (or the L293D's internal clamping diodes) becomes forward-biased by this negative spike, safely shunting current through the coil resistance as mild heat.

---

## 5. Hardware Mission
Examine `comp_l293d` (16-pin Dual H-Bridge IC) and `comp_33` (DC Motor):
1. **IC Notch Orientation:** Locate the semi-circular notch on the top of the L293D chip. Pin 1 is immediately to the left of the notch.
2. **Pin Identification:**
   - Pin 16 ($V_{CC1}$): Logic 5V (from Arduino 5V).
   - Pin 8 ($V_{CC2}$): Motor Power (connect to external 6V–9V battery pack).
   - Pins 4, 5, 12, 13: Ground heat-sink pins (connect to common Ground).
   - Pin 1 (Enable 1): PWM speed input (connect to Uno PWM Pin 9).
   - Pin 2 (Input 1): Direction Leg A (connect to Uno Pin 8).
   - Pin 7 (Input 2): Direction Leg B (connect to Uno Pin 7).
   - Pins 3 & 6 (Outputs 1 & 2): Connect directly to the two terminals of the DC motor.

---

## 6. Coding Basics
Direction Truth Table for L293D:
- `IN1 = HIGH, IN2 = LOW`: Motor spins Forward.
- `IN1 = LOW, IN2 = HIGH`: Motor spins Reverse.
- `IN1 = IN2 (both LOW or both HIGH)`: Motor stops / active dynamic brake.
- Speed is commanded by pulsing the Enable pin: `analogWrite(enablePin, speed)`.

---

## 7. Code Walkthrough
```cpp
const int enablePin = 9; // PWM Speed
const int in1Pin = 8;    // Direction Leg A
const int in2Pin = 7;    // Direction Leg B

void setup() {
  pinMode(enablePin, OUTPUT);
  pinMode(in1Pin, OUTPUT);
  pinMode(in2Pin, OUTPUT);
}

void driveMotor(int speed, bool forward) {
  if (forward) {
    digitalWrite(in1Pin, HIGH);
    digitalWrite(in2Pin, LOW);
  } else {
    digitalWrite(in1Pin, LOW);
    digitalWrite(in2Pin, HIGH);
  }
  analogWrite(enablePin, constrain(speed, 0, 255));
}

void stopMotor() {
  digitalWrite(in1Pin, LOW);
  digitalWrite(in2Pin, LOW);
  analogWrite(enablePin, 0);
}

void loop() {
  driveMotor(200, true);  // Drive forward at ~78% speed
  delay(2000);
  stopMotor();
  delay(1000);
  driveMotor(200, false); // Drive reverse
  delay(2000);
  stopMotor();
  delay(1000);
}
```

### Breakdown:
- `driveMotor()` encapsulates high-level direction logic and PWM duty cycle clipping.
- Separate control legs provide complete bidirectional velocity control.

---

## 8. Code Prediction
- **Prediction 1:** What happens if you set both `in1Pin` and `in2Pin` to `HIGH` simultaneously?
  *Answer:* Dynamic braking! Both motor terminals connect to the same voltage potential, causing motor back-EMF to brake the rotor quickly.
- **Prediction 2:** What happens if you try to drive the motor with `analogWrite(enablePin, 20)` from a standstill?
  *Answer:* The motor hums or whines but will not move due to static friction (stiction). Motors require a minimum threshold duty cycle (~60–80) to break friction.

---

## 9. Guided Experiment
1. Wire the Potentiometer from Lesson 06 to `A0`.
2. Map readings so:
   - Full clockwise: Full speed forward.
   - Center (512): Stopped.
   - Full counter-clockwise: Full speed reverse.
3. Test your custom robotic throttle control!

---

## 10. Real-World Robot Example
Electric vehicles (Tesla Model S), the Mars Curiosity Rover wheel drives, automated surgical drills, and industrial 6-axis robot joints use multi-phase H-bridge inverters to drive high-power motors with regenerative braking.

---

## 11. Troubleshooting Challenge
### Symptom 1: Arduino Resets Whenever Motor Starts
- **Diagnosis:** Brownout reset! The motor is powered from the Arduino 5V regulator pin; the heavy inrush current pulls the 5V rail voltage below 4.3V, causing the ATmega328P to reboot.
- **Remedy:** Power the motor using an external battery pack connected to Pin 8 ($V_{CC2}$) and tie the battery ground to Arduino ground.

### Symptom 2: Motor Driver Chip Gets Burning Hot
- **Diagnosis:** Motor stall or thermal overload! The motor is drawing peak stall current (>1A), exceeding the L293D's 600mA rating.
- **Remedy:** Check for mechanical binding on the motor shaft, reduce load, or upgrade to an L298N module.

---

## 12. Workshop Safety & Hardware Care
- **CRITICAL:** NEVER power DC motors or solenoids directly from the Arduino 5V regulator pin. Always use an external battery pack or power supply.
- **COMMON GROUND:** ALWAYS connect external battery negative (`-`) to Arduino `GND`. Without a common ground reference, control signals cannot be interpreted.
- Keep fingers and loose wires clear of spinning motor shafts and gears.

---

## 13. Knowledge Check (8 Questions)
1. **What causes inductive kickback spikes when a motor is suddenly turned off?**
   - [x] The collapsing magnetic field in the motor's copper coils induces a high reverse voltage
   - [ ] The battery releases excess chemical energy
   - [ ] Static electricity on the motor casing

2. **What is the primary function of a flyback diode connected across an inductive load?**
   - [x] To safely clamp and dissipate high-voltage inductive kickback spikes
   - [ ] To make the motor spin twice as fast
   - [ ] To convert AC voltage to DC voltage

3. **Why can you NOT power a standard DC hobby motor directly from an Arduino digital pin?**
   - [x] Arduino pins provide only ~20mA, while motors require 300mA–1000mA+ and can destroy pin transistors
   - [ ] Arduino digital pins output AC voltage
   - [ ] The code would be too complex

4. **What circuit architecture allows a microcontroller to reverse a motor's rotation direction?**
   - [x] An H-Bridge circuit
   - [ ] A voltage divider
   - [ ] A low-pass filter

5. **What electrical problem occurs if you fail to connect the motor battery ground to Arduino ground?**
   - [x] No shared reference voltage: control signals float and the motor driver cannot interpret logic states
   - [ ] The battery explodes
   - [ ] The Arduino executes code at half speed

6. **Why does an Arduino often crash or reset if a motor is wired directly to its 5V pin?**
   - [x] Brownout reset: the sudden motor inrush current pulls the 5V rail voltage below the microcontroller operating limit
   - [ ] Software stack overflow
   - [ ] Flash memory corruption

7. **In an H-bridge driver, what happens if both high-side and low-side switches on the same leg turn on simultaneously?**
   - [x] Shoot-through short circuit that burns out the transistors
   - [ ] The motor doubles its torque
   - [ ] The motor switches to generator mode

8. **Why does a DC motor hum but refuse to turn at very low PWM values (e.g. 15 out of 255)?**
   - [x] Static mechanical friction (stiction) requires a minimum threshold torque to overcome
   - [ ] The PWM frequency is too high for electricity to flow
   - [ ] The Arduino compiler ignores values below 20

---

## 14. Final Review
- Motors convert electrical energy to mechanical torque through electromagnetic fields.
- Inductive kickback ($V = -L \frac{di}{dt}$) must be clamped with flyback diodes.
- H-Bridges provide bidirectional polarity and PWM speed control.
- High-power loads require dedicated external power supplies and shared common grounds.
- Congratulations! You have mastered the complete hardware-software stack from electrons to code!

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (Inductive Kickback Physics) | 3 min |
| 5. Hardware Mission (L293D IC & Dual Power Wiring) | 4–5 min |
| 6. Coding Basics (Direction Truth Table & PWM) | 2 min |
| 7. Code Walkthrough (driveMotor & stopMotor) | 2 min |
| 8. Code Prediction (Braking & Stiction) | 1–2 min |
| 9. Guided Experiment (Potentiometer Throttle) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Brownout Protection | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **20–25 min** |

---

## Implementation Notes
- Component cross-references: `comp_uno`, `comp_33`, `comp_36`, `comp_l293d`.
- Milestone XP award: 100 XP.

---

## Done When
- Lesson provides 20–25 minutes of rigorous power electronics and motor physics instruction.
- Learner understands inductance, back-EMF, flyback diodes, and H-Bridge topologies.
- Learner wires L293D with separate battery power and common ground, commanding forward/reverse and PWM speed.
- All 8 assessment questions pass cleanly.
