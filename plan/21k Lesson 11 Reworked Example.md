# 21k Lesson 11 Reworked Example

## Purpose
Expand Lesson 11 into an advanced 18–22 minute engineering module covering Universal Asynchronous Receiver-Transmitter (UART) serial architecture, 8-N-1 packet framing, baud rate clocks, crossed TX/RX lines, `SoftwareSerial` pin remapping, 5V-to-3.3V resistor voltage division, and wireless telemetry with `comp_29` (HC-05 Bluetooth).

## Lesson
**Title:** Serial UART & Wireless Communication
**Tier:** Engineer
**Target Time:** 18–22 minutes
**Prerequisites:** Lesson 04
**XP:** 90
**Components:** `comp_uno`, `comp_29` (UART Bluetooth Module HC-05)

---

## Learning Goals
- Explain Universal Asynchronous Receiver-Transmitter (UART) serial architecture.
- Contrast asynchronous (no shared clock) with synchronous protocols (I2C/SPI).
- Understand start bits, data framing (8-N-1: 8 data bits, no parity, 1 stop bit), and baud rate timing.
- Understand the TX-to-RX crossing rule for full-duplex communications.
- Avoid the USB hardware conflict on Pins 0 and 1 using the `<SoftwareSerial.h>` library.
- Construct a 5V-to-3.3V resistor voltage divider to protect delicate wireless module RX pins.
- Establish a wireless bidirectional telemetry bridge with `comp_29` (HC-05 Bluetooth).
- Troubleshoot baud rate corruption, framing errors, and level-shifting issues.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### Cut the Tether: Untethered Wireless Telemetry
A robot tethered to a workbench by a USB cable cannot explore the world. To roam autonomously across terrain, monster robots must transmit telemetry data, video diagnostics, and receive directional steering commands wirelessly through the air.

UART (Universal Asynchronous Receiver-Transmitter) is the universal language of microcontrollers, GPS receivers, radio transceivers, and cellular modems. In this lesson, you will build an asynchronous wireless bridge between your monster robot and your smartphone!

```
Arduino Uno (5V) ─── Pin 11 (TX) ───[ 1kΩ ]───┬─── RXD (3.3V) ─── Bluetooth Module
                                             │
                                           [ 2kΩ ]
                                             │
Arduino Uno (GND) ────────────────────────────┴─── GND ────────── Bluetooth Module
Arduino Uno (5V) ─── Pin 10 (RX) ───────────────── TXD ────────── Bluetooth Module
```

---

## 2. Prior Knowledge Check
1. **What baud rate does `Serial.begin(9600)` configure?** 9600 symbols/bits per second.
2. **What do the `TX` and `RX` labels represent on microcontrollers?** Transmit (`TX`) and Receive (`RX`).

---

## 3. Core Concept & Vocabulary
- **UART:** A dedicated hardware peripheral that translates parallel CPU data bytes into serial bitstreams and vice versa.
- **Asynchronous:** Communication without a shared clock wire; transmitter and receiver agree on precise timing (baud rate) in advance.
- **Data Framing (8-N-1):** Standard serial protocol consisting of 1 Start bit (falling edge), 8 Data bits, No Parity bit, and 1 Stop bit (high idle).
- **Crossed Lines:** Fundamental serial rule: Transmitter (`TX`) connects to Receiver (`RX`) on the partner device.
- **`SoftwareSerial`:** Library that emulates UART timing on general-purpose digital pins, freeing hardware Pins 0 and 1 for USB programming.
- **Logic Level Shifting:** Stepping down 5.0V output signals to 3.3V to prevent destruction of sensitive radio receiver ICs.

---

## 4. How It Works
UART serial framing operates without a clock line:
1. **Idle State:** The serial line sits at continuous HIGH (5V or 3.3V).
2. **Start Bit:** The transmitter pulls the line LOW for exactly 1 bit duration ($\frac{1}{9600\text{ baud}} \approx 104.16\ \mu\text{s}$). This falling edge triggers the receiver's internal clock timer.
3. **Data Sampling:** The receiver counts clock ticks and samples the line state in the exact middle of each of the subsequent 8 bit windows.
4. **Stop Bit:** The transmitter pulls the line HIGH for at least 1 bit duration to conclude the frame and re-establish the idle level.

---

## 5. Hardware Mission
Examine `comp_29` (HC-05 Bluetooth Module):
1. **Pin Inspection:** Locate the header pins: `VCC`, `GND`, `TXD`, `RXD`, `STATE`, `EN`.
2. **Power Wiring:** Connect Module `VCC` to Uno `5V`, and Module `GND` to Uno `GND`.
3. **Receive Line (Direct):** Connect Module `TXD` (which outputs safe 3.3V logic) directly to Uno Digital Pin 10 (`SoftwareSerial RX`).
4. **Transmit Line (Voltage Divider):** Uno Pin 11 outputs 5.0V, but the HC-05 RXD pin accepts only 3.3V maximum!
   - Connect Uno Pin 11 to one leg of a 1kΩ resistor.
   - Connect the other leg of the 1kΩ resistor to a breadboard node.
   - Connect the breadboard node to HC-05 `RXD`.
   - Connect a 2kΩ resistor from the breadboard node to `GND`.
   - *Result: $V_{\text{out}} = 5\text{V} \times \frac{2\text{k}\Omega}{1\text{k}\Omega + 2\text{k}\Omega} = 3.33\text{V}$ (perfect protection!).*

---

## 6. Coding Basics
- Instantiate the software serial port: `SoftwareSerial bluetooth(10, 11);` (Pin 10 = RX, Pin 11 = TX).
- Always verify incoming characters using `bluetooth.available()` before invoking `bluetooth.read()`.

---

## 7. Code Walkthrough
```cpp
#include <SoftwareSerial.h>

// Pin 10 = Arduino RX (connects to Module TXD)
// Pin 11 = Arduino TX (connects via voltage divider to Module RXD)
SoftwareSerial bluetooth(10, 11);

void setup() {
  Serial.begin(9600);       // USB Hardware Serial to Computer
  bluetooth.begin(9600);    // Wireless UART to Bluetooth Module
  Serial.println("--- Bluetooth Telemetry Bridge Active ---");
}

void loop() {
  // Forward wireless commands from phone/tablet to computer monitor
  if (bluetooth.available()) {
    char incomingByte = bluetooth.read();
    Serial.write(incomingByte);
  }

  // Forward keyboard commands from computer monitor to wireless robot
  if (Serial.available()) {
    char outboundByte = Serial.read();
    bluetooth.write(outboundByte);
  }
}
```

### Breakdown:
- Bi-directional bridge forwards packets between USB hardware serial and wireless software serial.
- Zero delay blocks: execution loops continuously at maximum speed.

---

## 8. Code Prediction
- **Prediction 1:** What happens if the Bluetooth module transmits at 38400 baud while `bluetooth.begin()` is set to 9600?
  *Answer:* Severe bit sampling timing errors: incoming characters will appear as corrupted gibberish symbols.
- **Prediction 2:** What happens if you plug Bluetooth TX directly into Arduino Hardware Pin 0 (RX) while trying to upload code via USB?
  *Answer:* USB code upload fails with an `avrdude` sync error because the ATmega16U2 USB chip and the Bluetooth module fight to drive Pin 0 simultaneously.

---

## 9. Guided Experiment
1. Pair a smartphone or laptop to the HC-05 module using a Bluetooth terminal application (e.g. Serial Bluetooth Terminal).
2. Type command `'1'` on the phone.
3. Expand the Arduino code to toggle the Pin 13 LED on when `'1'` is received, and off when `'0'` is received.
4. Test wireless control from across the room!

---

## 10. Real-World Robot Example
GPS navigation satellites, drone telemetry radios (MavLink), industrial cellular telemetry modems, and barcode scanners communicate with flight computers using UART serial data streams.

---

## 11. Troubleshooting Challenge
### Symptom 1: Arduino IDE Reports `avrdude: programmer is not responding`
- **Diagnosis:** Hardware Pin Conflict! External modules are wired to Hardware Pins 0 and 1 during upload.
- **Remedy:** Unplug wires on Pins 0 and 1 while flashing, or migrate the module connections to `SoftwareSerial` on Pins 10 and 11.

### Symptom 2: Module Pairs, but No Text Received
- **Diagnosis:** Straight connection error! TX was wired to TX, and RX was wired to RX.
- **Remedy:** Swap data lines: Arduino TX must connect to Module RX, and Arduino RX must connect to Module TX.

---

## 12. Workshop Safety & Hardware Care
- **3.3V Logic Protection:** The RX pin on many Bluetooth (HC-05/ESP8266) modules is strictly 3.3V. Feeding raw 5V from an Arduino Uno output pin directly into the module RX pin will overheat and permanently destroy the wireless radio chip. Always use a resistor voltage divider.
- Disconnect power before adjusting voltage divider resistors on the breadboard.

---

## 13. Knowledge Check (8 Questions)
1. **What does UART stand for?**
   - [x] Universal Asynchronous Receiver-Transmitter
   - [ ] Ultra Analog Radio Transceiver
   - [ ] Unified Automated Robotic Telemetry

2. **What is the golden wiring rule for connecting two UART serial devices?**
   - [x] Cross the data lines: TX connects to RX, and RX connects to TX
   - [ ] Connect TX to TX, and RX to RX
   - [ ] Connect both lines to Ground

3. **Why is UART called "asynchronous"?**
   - [x] There is no shared clock line; timing is governed entirely by agreed baud rates
   - [ ] It only works when the microcontroller is asleep
   - [ ] Signals are sent in reverse order

4. **Why should you avoid connecting external hardware to Digital Pins 0 and 1 on an Uno?**
   - [x] Pins 0 and 1 are shared with the onboard USB-to-serial chip used for flashing code
   - [ ] They have no power supply
   - [ ] They only support 1.8V

5. **What is the purpose of the `SoftwareSerial` library?**
   - [x] It allows ordinary digital pins to emulate hardware UART serial ports
   - [ ] It compresses sketches to save flash memory
   - [ ] It encrypts wireless data

6. **Why is a voltage divider needed between an Uno TX pin and a 3.3V Bluetooth module RX pin?**
   - [x] To step down the 5V Arduino signal to prevent overvoltage damage to the 3.3V module
   - [ ] To speed up data transmission
   - [ ] To filter out radio interference

7. **What method checks how many bytes are waiting in the serial receive buffer?**
   - [x] `available()`
   - [ ] `read()`
   - [ ] `length()`

8. **What happens if the transmitter and receiver are configured with mismatched baud rates?**
   - [x] Bits are sampled at incorrect intervals, resulting in corrupt or unreadable data
   - [ ] The microcontroller shuts off
   - [ ] The hardware catches fire

---

## 14. Final Review
- UART achieves point-to-point serial communication using start/stop framing without a shared clock wire.
- TX and RX lines must always cross between partner devices.
- `SoftwareSerial` frees hardware pins 0 and 1 to prevent USB upload lockouts.
- Resistor dividers safely step down 5V Uno signals to protect 3.3V wireless silicon.
- Up next in Lesson 12: High power motor driving, flyback diodes, and H-Bridge physics!

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works (UART Framing & Timing) | 2–3 min |
| 5. Hardware Mission (Voltage Divider & HC-05 Wiring) | 3–4 min |
| 6. Coding Basics (SoftwareSerial Library) | 2 min |
| 7. Code Walkthrough (Serial Telemetry Bridge) | 2 min |
| 8. Code Prediction | 1 min |
| 9. Guided Experiment (Remote Wireless Command) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–22 min** |

---

## Implementation Notes
- Component cross-references: `comp_uno`, `comp_29`.
- Milestone XP award: 90 XP.

---

## Done When
- Lesson provides 18–22 minutes of rigorous asynchronous serial and wireless instruction.
- Learner understands baud rate framing, crossed lines, and 3.3V level shifting.
- Learner wires HC-05 module with resistor divider and establishes wireless communication.
- All 8 assessment questions pass cleanly.
