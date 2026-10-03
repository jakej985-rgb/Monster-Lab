# 21c Lesson 03 Reworked Example

## Purpose
Expand Lesson 03 into a comprehensive 16–20 minute learning module that demystifies Arduino libraries, header files, C++ abstraction, and the I2C LCD backpack hardware, teaching learners to understand library-based code rather than blindly copying it.

## Lesson
**Title:** Installing Libraries: Supercharging Code
**Tier:** Builder
**Target Time:** 16–20 minutes
**Prerequisites:** Lesson 02
**XP:** 60
**Components:** `comp_uno`, `comp_07` (16x2 Character LCD with I2C)

---

## Learning Goals
- Explain what an Arduino library is and how it abstracts low-level hardware registers.
- Differentiate between header files (`.h`), source files (`.cpp`), and compiled binaries.
- Use the Arduino IDE Library Manager to search, install, update, and manage dependencies.
- Inspect an I2C LCD backpack and identify pins (`GND`, `VCC`, `SDA`, `SCL`).
- Read and explain a `LiquidCrystal_I2C` sketch line-by-line.
- Predict hardware behavior when parameters (I2C hex address, screen dimensions, backlight) change.
- Troubleshoot compiler errors (`fatal error: ... No such file or directory`) and runtime contrast issues.
- Demonstrate mastery through a comprehensive 8-question assessment.

---

## 1. Mission Introduction
### Supercharge Your Monster's Brain
Robots rely on specialized integrated circuits: real-time clocks, OLEDs, and motor drivers. Controlling a 16x2 LCD display via raw 8-bit parallel pulses requires toggling 16 pins and managing microsecond timing. If engineers had to write low-level bit-banging code for every display, building a robot would take months!

Libraries package proven, robust C++ code written by senior engineers so learners can command complex hardware with high-level functions like `lcd.print("Monster Online!");`.

```
Code Sketch → #include <LiquidCrystal_I2C.h> → Library Object (0x27) → I2C Bus (A4/A5) → PCF8574 Backpack → LCD
```

---

## 2. Prior Knowledge Check
Before diving into libraries, verify foundational concepts:
1. **What is source code?** Human-readable C++ instructions written in the IDE editor.
2. **What happens during compilation?** Source code translates into machine instructions (hex binary) for the ATmega328P.
3. **Why do microcontrollers need external modules?** To interact with the physical world through displays, sensors, and actuators.

---

## 3. Core Concept & Vocabulary
- **Library:** A reusable collection of code providing functions and classes for specific hardware devices or algorithms.
- **`#include`:** A preprocessor directive that injects header declarations into your sketch before compilation begins.
- **Header File (`.h`):** Defines the class interface, constants, and available methods exposed by the library.
- **Constructor / Instantiation:** Creating an active object variable representing physical hardware in memory.
- **API (Application Programming Interface):** The set of commands and methods exposed by the library to control the device.

---

## 4. How It Works
When you invoke `#include <LiquidCrystal_I2C.h>`, the C++ compiler links pre-compiled routines that handle the complex I2C protocol.

1. Your code calls `lcd.print("Hello")`.
2. The library converts characters into ASCII byte streams.
3. The library packages bytes into I2C packets directed at hexadecimal address `0x27`.
4. The hardware I2C bus (`SDA` / `SCL`) shifts the bits across to the PCF8574 backpack.
5. The backpack expands the serial bytes back into parallel pulses that toggle the HD44780 LCD controller.

---

## 5. Hardware Mission
Examine `comp_07` (16x2 LCD Display):
1. **Backpack Inspection:** Turn the display over. Notice the black daughterboard soldered to the back—this is the I2C backpack.
2. **Pin Identification:** Count the 4 interface pins:
   - `GND`: Ground return path.
   - `VCC`: 5V power supply.
   - `SDA`: Serial Data line (connects to Uno `A4`).
   - `SCL`: Serial Clock line (connects to Uno `A5`).
3. **Compare Pins:** Notice that without the backpack, you would need to wire 16 individual pins to your Arduino!
4. **Contrast Potentiometer:** Locate the small blue square trimmer potentiometer on the backpack. This adjusts display liquid-crystal contrast.

---

## 6. Coding Basics
In C++, libraries frequently use Object-Oriented Programming (OOP):
- **Class:** The blueprint (e.g., `LiquidCrystal_I2C`).
- **Object Instance:** The physical device you control (e.g., `lcd`).
- **Constructor Call:** `LiquidCrystal_I2C lcd(0x27, 16, 2);` creates the object, specifying its 7-bit I2C address (`0x27`), column count (`16`), and row count (`2`).

---

## 7. Code Walkthrough
```cpp
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Set I2C address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  lcd.init();          // Initialize LCD hardware and join I2C bus
  lcd.backlight();     // Turn on the LED backlight
  lcd.setCursor(0, 0); // Position cursor at Column 0, Row 0
  lcd.print("Monster Lab!");
  lcd.setCursor(0, 1); // Position cursor at Column 0, Row 1
  lcd.print("System Active");
}

void loop() {
  // Static display - loop remains idle
}
```

### Line-by-Line Breakdown:
- `line 1-2`: Imports the Wire (I2C) and LiquidCrystal_I2C libraries.
- `line 5`: Instantiates `lcd` at address `0x27` with 16 columns and 2 rows.
- `line 8`: `lcd.init()` configures the LCD controller registers.
- `line 9`: `lcd.backlight()` powers the backlight LED.
- `line 10-13`: Sets cursor positions and prints greeting text.

---

## 8. Code Prediction
- **Prediction 1:** What happens if `lcd.backlight()` is omitted or commented out?
  *Answer:* Text is rendered on the liquid crystals, but without the backlight LED, it is nearly invisible unless illuminated by an external flashlight.
- **Prediction 2:** What happens if `lcd.setCursor(16, 0)` is used?
  *Answer:* The cursor is placed beyond the 16 visible columns (columns 0–15), causing characters to wrap off-screen or into hidden DDRAM registers.

---

## 9. Guided Experiment
Make a controlled change to the sketch:
1. Replace `lcd.print("System Active");` with dynamic elapsed seconds:
   ```cpp
   void loop() {
     lcd.setCursor(0, 1);
     lcd.print("Uptime: ");
     lcd.print(millis() / 1000);
     lcd.print("s ");
     delay(500);
   }
   ```
2. Predict what will happen on Row 1.
3. Upload and observe the dynamic counter updating every half second.

---

## 10. Real-World Robot Example
Modern aerospace systems, 3D printers, and industrial robotics do not write low-level register drivers for every display or motor. Aerospace engineering relies on Hardware Abstraction Layers (HAL) and certified driver libraries to guarantee safety, modularity, and rapid maintenance.

---

## 11. Troubleshooting Challenge
### Symptom 1: Compiler Error
- **Error:** `fatal error: LiquidCrystal_I2C.h: No such file or directory`.
- **Diagnosis:** The library was never installed in the IDE, or the folder name contains illegal characters.
- **Remedy:** Open **Tools > Manage Libraries...**, search for `LiquidCrystal_I2C`, and click Install.

### Symptom 2: Blank Screen / Solid White Boxes
- **Symptom:** Display lights up bright blue with 16 solid white rectangular boxes on Row 1, but no text appears.
- **Diagnosis:** The contrast potentiometer is set too high, or the I2C address is `0x3F` instead of `0x27`.
- **Remedy:** Turn the blue contrast potentiometer on the back of the backpack with a small screwdriver until text emerges from the boxes.

---

## 12. Workshop Safety & Hardware Care
- Verify whether the LCD backpack requires 5V or 3.3V logic. Connecting 5V to a 3.3V-only display can permanently fry the display controller.
- Never adjust backpack potentiometers using metal screwdrivers while powered if exposed traces or power rails are nearby.
- Disconnect USB power before rewiring I2C jumper wires.

---

## 13. Knowledge Check (8 Questions)
1. **What is the primary purpose of an Arduino library?**
   - [x] They speed up code by writing complex hardware protocols for you
   - [ ] They double the CPU clock speed of the Arduino
   - [ ] They convert AC electricity into DC electricity

2. **Which preprocessor command is used to add a library to a sketch?**
   - [x] `#include <LibraryName.h>`
   - [ ] `import LibraryName;`
   - [ ] `using namespace LibraryName;`

3. **In `LiquidCrystal_I2C lcd(0x27, 16, 2);`, what does `0x27` represent?**
   - [x] The 7-bit hexadecimal I2C device address
   - [ ] The pin number connected to the LCD
   - [ ] The operating temperature limit in Celsius

4. **Where inside the Arduino IDE can you search for and install community libraries?**
   - [x] Tools > Manage Libraries (or the Library Manager tab)
   - [ ] File > Preferences > Upload
   - [ ] Help > Drivers

5. **What do the numbers `16, 2` indicate in the LCD constructor?**
   - [x] 16 columns and 2 rows of characters
   - [ ] 16 volts and 2 amperes
   - [ ] 16 MHz processor and 2 KB SRAM

6. **If your code compiles cleanly but the LCD shows solid white boxes, what should you adjust first?**
   - [x] The blue contrast potentiometer on the back of the module
   - [ ] Reinstall the Arduino IDE
   - [ ] Replace the Uno microcontroller chip

7. **Why does using an I2C backpack library save wiring compared to standard parallel LCDs?**
   - [x] It reduces required data pins from 10+ down to 2 shared bus lines
   - [ ] It eliminates the need for power and ground wires
   - [ ] It transmits data over Wi-Fi

8. **What file extension designates C++ header files in libraries?**
   - [x] `.h`
   - [ ] `.ino`
   - [ ] `.hex`

---

## 14. Final Review
- Libraries encapsulate complex protocols into clean, reusable functions.
- The preprocessor directive `#include` makes library classes and functions available.
- Hardware devices like the I2C LCD backpack use 7-bit hex addresses (e.g. `0x27`).
- Always check the IDE Library Manager when a missing header error occurs.
- Up next in Lesson 04: The core execution loop of all microcontroller firmware: `setup()` and `loop()`.

---

## Estimated Time Breakdown
| Activity | Target Time |
|---|---:|
| 1. Mission Introduction | 1–2 min |
| 2. Prior Knowledge Check | 1 min |
| 3. Core Concept & Vocabulary | 2 min |
| 4. How It Works | 2 min |
| 5. Hardware Mission (LCD & Backpack Inspection) | 3 min |
| 6. Coding Basics & Instantiation | 2 min |
| 7. Code Walkthrough | 2 min |
| 8. Code Prediction | 1 min |
| 9. Guided Experiment (Dynamic Uptime) | 2 min |
| 10. Real-World Robot Example | 1 min |
| 11. Troubleshooting & Safety | 2 min |
| 12. Knowledge Check (8 Questions) | 2–3 min |
| 13. Final Review | 1 min |
| **Total** | **18–20 min** |

---

## Implementation Notes
- Step container mapping: sections 1–3 use `story`, sections 4–5 use `visualExplanation` and `physicalTask`, sections 6–9 use `codeExperiment`, sections 11–12 use `story`, and section 13 uses `quizCheckpoint`.
- Canonical quiz string preserved for compatibility: `'They speed up code by writing complex hardware protocols for you'`.
- Placed on final step of Lesson 03 to maintain automated test assertion compatibility.

---

## Done When
- Lesson provides 16–20 minutes of meaningful learning.
- Learner understands `#include`, header files, constructors, and I2C hex addressing.
- Learner inspects physical I2C backpack and adjusts contrast potentiometer.
- All 8 assessment questions pass and reinforce hardware-software understanding.
