# 21i Lesson 09 Reworked Example

## Purpose
Expand Lesson 09 into an advanced 18–22 minute learning module that unpacks serial bus topologies, the Inter-Integrated Circuit (I2C) protocol, open-drain architectures, pull-up resistors, 7-bit hexadecimal addressing, the `<Wire.h>` library, and multi-device parallel bus wiring with `comp_07` and `comp_10`.

## Lesson
**Title:** The I2C Communication Bus
**Tier:** Builder
**Target Time:** 18–22 minutes
**Prerequisites:** Lesson 03, Lesson 04
**XP:** 80
**Components:** `comp_uno`, `comp_07` (16x2 I2C LCD), `comp_10` (DS3231 Precision RTC)

---

## Learning Goals
- Understand serial communication buses and contrast with point-to-point pin wiring.
- Explain the I2C (Inter-Integrated Circuit) protocol: Controller/Target architecture.
- Identify the two shared lines: `SDA` (Serial Data) and `SCL` (Serial Clock).
- Locate hardware I2C pins on Uno: `A4` (`SDA`) and `A5` (`SCL`).
- Understand 7-bit hexadecimal device addressing (e.g., `0x27`, `0x68`).
- Wire multiple I2C devices (`comp_07` LCD and `comp_10` RTC) in parallel to the same bus.
- Run an I2C scanner sketch to discover hardware addresses dynamically.
- Troubleshoot address collisions, swapped data lines, and bus lockups.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### The Two-Wire Superhighway: Bus Topologies
If every sensor, motor driver, display, and keypad required its own dedicated pins on the Arduino, you would run out of pins after adding just three components. A humanoid robot needs dozens of sensors: gyroscopes, thermal cameras, pressure sensors, and displays.

The I2C bus solves this pin starvation problem by allowing up to 127 unique peripheral devices to communicate over the exact same two wires! In this lesson, you will network a display and a precision clock onto a shared data superhighway.

```
Controller (Uno) ───┬─── SDA (Data: A4) ────┬─── LCD Display (0x27)
                    │                       │
                    └─── SCL (Clock: A5) ───┴─── DS3231 RTC Clock (0x68)
```

---

## 2. Prior Knowledge Check
1. **What is a library?** Pre-written, compiled code providing functions and classes for hardware devices.
2. **What is hexadecimal notation?** Base-16 numbering prefixed with `0x` (e.g., `0x27` = $2 \times 16 + 7 = 39$ decimal).

---

## 3. Core Concept & Vocabulary
- **I2C (Inter-Integrated Circuit):** A synchronous, multi-target, bidirectional communication bus developed by Philips Semiconductor.
- **SDA (Serial Data):** The bidirectional line over which data bytes travel.
- **SCL (Serial Clock):** The synchronizing clock pulse train generated exclusively by the Controller.
- **Controller (Master):** The device that initiates bus communication and generates SCL clock pulses (the Uno).
- **Target (Slave):** Peripheral devices listening on the bus, responding only when their unique 7-bit address is called.
- **7-Bit Address:** A unique identifier allowing up to 128 devices to share the bus without wire conflicts.
- **ACK / NACK:** Acknowledge (0) or Not Acknowledge (1) bit returned by a target device to confirm packet receipt.
- **Open-Drain / Pull-Up:** Hardware architecture where lines are passively held at 5V by resistors and pulled to GND by transistors.

---

## 4. How It Works
Communication on the I2C bus follows rigid timing:
1. **Start Condition:** Controller pulls `SDA` LOW while `SCL` remains HIGH.
2. **Address Frame:** Controller transmits 7 address bits followed by a Read/Write bit (0 for Write, 1 for Read).
3. **Target ACK:** The target device whose internal address matches pulls `SDA` LOW during clock cycle 9.
4. **Data Transmission:** Data bytes are transferred 8 bits at a time, each followed by an ACK bit.
5. **Stop Condition:** Controller transitions `SDA` from LOW to HIGH while `SCL` is HIGH, releasing the bus.

---

## 5. Hardware Mission
Examine `comp_07` (16x2 LCD) and `comp_10` (DS3231 RTC Module):
1. **Parallel Bus Wiring:** Insert both components onto the breadboard.
2. **Shared Power:** Connect both `VCC` pins to the breadboard 5V power rail, and both `GND` pins to the Ground rail.
3. **Shared Data & Clock:**
   - Connect BOTH `SDA` pins together and run a single wire to Uno Pin `A4`.
   - Connect BOTH `SCL` pins together and run a single wire to Uno Pin `A5`.
4. *Notice: Even with two complex peripherals attached, you still have nearly all of your Arduino's digital and analog pins completely free!*

---

## 6. Coding Basics
- Arduino Core includes `<Wire.h>`, which controls the ATmega328P's internal Two-Wire Interface (TWI) hardware.
- `Wire.begin()` initializes the I2C hardware as Controller.
- `Wire.beginTransmission(address)` targets a specific chip.
- `Wire.endTransmission()` transmits the buffer and returns an error code (`0` = Success/ACK).

---

## 7. Code Walkthrough
```cpp
#include <Wire.h>

void setup() {
  Wire.begin();        // Join I2C bus as Controller
  Serial.begin(9600);
  Serial.println("\n--- I2C Hardware Bus Scanner ---");
}

void loop() {
  byte count = 0;
  for (byte address = 1; address < 127; address++) {
    Wire.beginTransmission(address);
    byte error = Wire.endTransmission();

    if (error == 0) { // Target device acknowledged ping!
      Serial.print("Discovered I2C device at address: 0x");
      if (address < 16) Serial.print("0");
      Serial.println(address, HEX);
      count++;
    }
  }
  Serial.print("Scan complete. Total devices detected: ");
  Serial.println(count);
  delay(5000);
}
```

### Breakdown:
- The loop iterates through valid 7-bit addresses ($1$ to $126$).
- `Wire.endTransmission()` returns `0` if an ACK was received, proving a device is alive at that address.
- Addresses are printed in standardized hexadecimal format.

---

## 8. Code Prediction
- **Prediction 1:** What appears in the Serial Monitor if only the LCD (`0x27`) and RTC (`0x68`) are connected?
  *Answer:* The scanner reports `0x27` and `0x68`, and prints `Total devices detected: 2`.
- **Prediction 2:** What happens if you accidentally swap the SDA and SCL jumper wires?
  *Answer:* Devices cannot detect clock pulses; no device ACKs, and the scanner reports `Total devices detected: 0`.

---

## 9. Guided Experiment
1. Leave both devices connected to pins A4 and A5.
2. Load your LCD sketch from Lesson 03.
3. Add RTC library calls to read time and display real-time clock hours and minutes directly on the LCD screen, proving simultaneous bus communication.

---

## 10. Real-World Robot Example
Modern smartphones, DJI drones, and autonomous rovers connect accelerometers, compasses, barometers, capacitive touchscreens, and battery management ICs to a central CPU over shared I2C buses, saving vast amounts of circuit board space.

---

## 11. Troubleshooting Challenge
### Symptom 1: Scanner Freezes on Address 0x01
- **Diagnosis:** Bus lockup! SCL or SDA is shorted directly to GND on the breadboard, preventing clock edges from rising.
- **Remedy:** Inspect breadboard wiring and remove the ground bridge on SDA/SCL.

### Symptom 2: Address Collision
- **Symptom:** Two identical sensors share address `0x68`, corrupting all readings.
- **Diagnosis:** Both chips drive the line simultaneously.
- **Remedy:** Solder the address solder-bridge pad (`A0`/`AD0`) on one sensor to alter its base address to `0x69`.

---

## 12. Workshop Safety & Hardware Care
- **3.3V Logic Cautions:** Many modern I2C sensors (such as BMP280 or MPU6050) operate on 3.3V logic. Connecting 5V Uno I2C lines to 3.3V-only sensors without bidirectional level shifters can blow the target's input FETs.
- Always check the module datasheet for built-in 5V level shifting transistors.

---

## 13. Knowledge Check (8 Questions)
1. **What are the names of the two communication lines used by the I2C protocol?**
   - [x] SDA (Serial Data) and SCL (Serial Clock)
   - [ ] TX (Transmit) and RX (Receive)
   - [ ] MOSI and MISO

2. **Which pins on the standard Arduino Uno serve as hardware SDA and SCL?**
   - [x] A4 (SDA) and A5 (SCL)
   - [ ] Pin 0 and Pin 1
   - [ ] Pin 11 and Pin 12

3. **Theoretically, how many unique addresses can be represented by standard 7-bit I2C?**
   - [x] 128 (with ~112–119 usable addresses)
   - [ ] 256
   - [ ] 2

4. **What component generates the synchronizing clock pulses on the SCL line?**
   - [x] The Controller (Master) device
   - [ ] The Target (Slave) device
   - [ ] The pull-up resistor

5. **What signal does a target device return to confirm receipt of an address or data byte?**
   - [x] ACK (Acknowledge) bit
   - [ ] Reset pulse
   - [ ] 12V spike

6. **How are multiple I2C devices physically connected to the Arduino?**
   - [x] In parallel: all SDA lines connect together, all SCL lines connect together
   - [ ] In a daisy chain from output to input
   - [ ] Each device requires its own unique Arduino pin

7. **What happens if two devices with the identical address (e.g. 0x27) are wired to the same I2C bus?**
   - [x] Address collision: both devices try to drive the data line at the same time, corrupting data
   - [ ] The Arduino automatically changes one of their addresses
   - [ ] The devices share the reading 50/50

8. **Which built-in Arduino library is used to communicate with I2C devices?**
   - [x] `<Wire.h>`
   - [ ] `<SPI.h>`
   - [ ] `<Serial.h>`

---

## 14. Final Review
- I2C coordinates up to 127 devices over two shared lines (`SDA` on A4, `SCL` on A5).
- The Controller generates clock pulses; targets respond only to their unique 7-bit hex address.
- Devices wire in parallel—share power, ground, clock, and data.
- Up next in Lesson 10: Unleashing multi-megahertz bandwidth with the 4-wire SPI protocol.

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (I2C Protocol Framing) | 2–3 min |
| 5. Hardware Mission (Parallel Wiring LCD & RTC) | 3–4 min |
| 6. Coding Basics (Wire Library API) | 2 min |
| 7. Code Walkthrough (Bus Scanner) | 2 min |
| 8. Code Prediction | 1 min |
| 9. Guided Experiment (Multi-Device Integration) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–22 min** |

---

## Implementation Notes
- Component cross-references: `comp_uno`, `comp_07`, `comp_10`.
- Milestone XP award: 80 XP.

---

## Done When
- Lesson provides 18–22 minutes of rigorous bus protocol instruction.
- Learner understands Controller/Target topology, ACK/NACK signaling, and 7-bit hex addressing.
- Learner builds parallel bus circuit and scans hardware devices.
- All 8 assessment questions pass cleanly.
