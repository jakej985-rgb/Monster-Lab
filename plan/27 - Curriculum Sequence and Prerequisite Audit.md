# Phase 27 — Curriculum Sequence and Prerequisite Audit

## Goal

Audit the full Monster Lab curriculum and ensure every lesson builds on concepts learners have already encountered. No lesson should require an unexplained skill, component, programming concept, or workflow that is first taught later.

This is an audit and correction plan. Do not make destructive curriculum edits until the Curriculum Architect has mapped current IDs, existing content, and migration risks.

## Core Rule

**Introduce it → explain it → practice it → build on it.**

A lesson may introduce new concepts, but it must establish the minimum prerequisites first, explain new terms before using them, provide concrete or visual examples before abstraction, provide guided practice before independent work, and build on earlier learning rather than assume future learning. Revisit concepts only when adding a meaningful new dimension.

A Quick Check is optional and is not a substitute for instruction. A learner who bypasses it must still receive any prerequisite teaching required by the lesson.

## Initial Audit Findings

### BLOCKER — Current lesson order violates hardware prerequisites

The Phase 26 target order places Lesson 4: PWM and RGB LEDs, Lesson 5: Switches, Buttons and Potentiometers, then Lesson 6: Circuits, Breadboards and First Builds.

However, Lesson 4 needs learners to understand LED wiring, polarity, current-limiting resistors, and safe circuits. Lesson 5 expects circuit and component recognition and includes physical button/potentiometer activities. Lesson 6 is where breadboards, circuit paths, resistors, and first physical builds are explicitly taught.

**Required correction:** Establish basic circuit, resistor, LED, breadboard, power, and ground skills before lessons depend on them. Do not leave those skills until Lesson 6 if Lessons 4 and 5 require them.

### HIGH — Lesson 5 depends on concepts assigned to Lesson 4

The Lesson 5 plan includes potentiometer-to-LED brightness, potentiometer-to-RGB color, and a button changing potentiometer mode. Brightness control requires PWM and analogWrite, which are the core of Lesson 4. Learners should not be expected to use PWM before it has been taught.

**Required correction:** Move PWM-dependent activities into a later application or mark them clearly as optional previews with a complete guided explanation. Keep Lesson 5's core outcomes limited to concepts already taught, such as reading button states and potentiometer values.

### HIGH — Lesson 6 introduces a sensor before the sensor sequence is established

Lesson 6 includes a distance sensor, Serial Monitor observations, and sensor-to-output builds. Lesson 7 is intended to teach what sensors are, digital versus analog sensing, measurements, thresholds, and sensor interpretation.

This works only if Lesson 6 is a guided first encounter that explains every required wire, code line, and Serial Monitor action. It must not assume learners already understand sensor signal types, calibration, or thresholds.

**Required correction:** Lesson 6 may offer one tightly guided sensor demonstration as a preview, but Lesson 7 should own sensor concepts, interpreting readings, thresholds, calibration, and combining sensors.

### HIGH — Lesson 3 and Lesson 2B overlap on libraries

Lesson 2B already includes libraries in the IDE workflow. Lesson 3 is dedicated to understanding, finding, installing, using, and modifying libraries.

**Required correction:** In Lesson 2B, only show where library tools are and explain that libraries can be added to a project. Defer the purpose, selection, installation practice, example modification, and API concepts to Lesson 3.

### HIGH — Lesson 1 is too broad for a single first encounter

The Lesson 1 plan lists microcontrollers, CPU, memory, GPIO, inputs/outputs, digital/analog, pins, power/ground, decision flow, code-to-hardware, experiments, and troubleshooting.

Some are appropriate as first-look concepts, but a beginner should not be expected to master CPU architecture, flash/SRAM distinctions, GPIO behavior, or power-flow details all at once.

**Required correction:** Keep Lesson 1 primarily concrete and visual. Give each technical term a simple first explanation, clearly mark deeper detail as optional, and teach wiring/electrical practice in the circuit lesson. Avoid detailed memory/CPU/register explanations until needed later.

### HIGH — Coding Foundations and Arduino-specific lessons need a clear boundary

Coding Foundations owns general programming concepts: variables, operators, decisions, functions, loops, and reading/predicting code. Arduino lessons should apply those concepts to pins, sensors, outputs, and hardware.

**Required correction:** Before a lesson uses variables, conditions, loops, or functions in a meaningful way, either ensure Coding Foundations has introduced the concept, provide a short in-context explanation and guided example, or offer a beginner path that does not assume it. Do not duplicate a full programming lesson inside hardware lessons.

### MEDIUM — Later communication and motor lessons need a prerequisite recheck

The legacy plans place I2C, SPI, UART/wireless, and motor physics later in the sequence. The new Lesson 8 I2C plan is reasonable only after wiring, basic inputs/outputs, libraries, and sensor/device examples.

**Required correction:** Audit every later lesson against the new course map. SPI must build on the idea of devices communicating and basic signal/wire concepts. UART must distinguish serial communication from the Serial Monitor workflow already introduced in 2B. Motor control must follow circuits, outputs, and PWM, and must teach motor-driver and power safety before energizing hardware.

## Recommended Learning Dependency Order

The Curriculum Architect must validate and publish the final order. The dependency-safe conceptual sequence should be:

1. **Lesson 1 — Arduino Fundamentals:** What Arduino is; concrete board recognition; simple input/output idea; first look at pins, power, and ground. No assumed prior Arduino knowledge.
2. **Coding Foundations — optional/placement-based:** Teach general code concepts before code-heavy applications. Passing placement can satisfy only the concepts actually assessed.
3. **Lesson 2A — Meet Monster Lab:** Learn the app and safe workflow.
4. **Lesson 2B — Arduino IDE Walkthrough:** Learn sketches, verify/compile/upload, board/port selection, and Serial Monitor. Libraries are only briefly pointed out.
5. **Basic Circuits and First Builds:** Introduce circuit paths, breadboard rows/rails, LED polarity, resistor purpose, power/GND, and a simple LED build. This foundation must occur before learners are asked to wire LEDs, buttons, potentiometers, or sensors independently.
6. **Switches, Buttons and Potentiometers:** Digital inputs first, then analog readings; explain pull-ups and floating inputs with visuals and guided experiments. Do not require PWM yet.
7. **PWM and RGB LEDs:** Build on a working LED circuit and basic output knowledge; introduce PWM, brightness, RGB channels, and color mixing.
8. **Sensors and Reading the Real World:** Build on inputs, analog/digital values, breadboard skills, and Serial Monitor. Teach readings, thresholds, calibration, and sensor-to-output behavior.
9. **Libraries:** If the existing Lesson 3 remains before hardware practice, its early sections may introduce library purpose and examples; installation and modification must be fully guided. The Architect should decide whether the complete course is better placed after the first physical build, but it must precede I2C library-based work.
10. **I2C and Connected Devices:** Explain why devices communicate, then SDA/SCL, addresses, one device, libraries, and multiple devices.
11. **SPI:** Reuse the communication concept and compare SPI to I2C before teaching additional wires/signals and timing.
12. **UART/Wireless:** Reuse the already-known idea of serial data and Serial Monitor, then extend it to device-to-device communication and wireless modules.
13. **Motors and Actuators:** Build on circuits, outputs, PWM, and safe power handling; introduce driver hardware and flyback protection before any motor test.
14. **Integrated projects:** Combine sensors, inputs, outputs, displays, communication, and motor control only after each required part has been introduced and practiced.

### Numbering and Stable IDs

The conceptual order above differs from the historical Lesson 4/5/6 numbering in Phase 26. Do not silently reorder lesson IDs or change existing IDs. The Curriculum Architect must recommend one of these before implementation:
- renumber the learner-facing course sequence and update all references; or
- preserve stable IDs while explicitly defining a separate display/order field.

Do not display a learner-facing sequence that jumps confusingly between Lesson 4, Lesson 6, and Lesson 5 without explaining why.

## Per-Submodule Audit Checklist

For every submodule, record:

- [ ] What the learner must already know.
- [ ] Where each prerequisite was first introduced.
- [ ] Whether it was explained or merely mentioned.
- [ ] Whether the learner practiced it before this point.
- [ ] Whether any code syntax is assumed without prior instruction.
- [ ] Whether hardware setup assumes unintroduced wiring/component knowledge.
- [ ] Whether the activity uses a future lesson's concept.
- [ ] Whether vocabulary is introduced before use.
- [ ] Whether a concrete/visual example precedes abstraction.
- [ ] Whether the challenge is a reasonable step above the guided example.
- [ ] Whether a bypassed Quick Check still leaves enough teaching for a beginner.
- [ ] Whether a repeated concept adds a new dimension instead of repeating content.
- [ ] Whether the next lesson has a clear readiness bridge.

## Required Deliverables

1. A course-order map showing all courses and lessons in actual learner order.
2. A prerequisite matrix for every submodule, mapping each prerequisite to its first teaching location.
3. A forward-reference report listing any concept used before it is taught.
4. A duplicate-content report separating helpful reinforcement from accidental duplication.
5. A correction register with severity, affected file/ID, issue, and exact proposed fix.
6. An updated dependency graph with no circular prerequisites.
7. A numbering/ID migration recommendation that preserves learner progress.
8. A Curriculum Guardian review after corrections.

## Acceptance Criteria

- No lesson requires an unexplained concept first taught in a later lesson.
- Learners are taught safe wiring, power/GND, LED polarity, resistor purpose, and breadboard connections before independent builds depend on them.
- Code concepts are introduced in Coding Foundations or explained in context before meaningful use.
- Lesson 2B does not pre-teach the full Lesson 3 library curriculum.
- Lesson 5 does not require PWM before PWM is taught.
- Lesson 6 does not expect sensor interpretation before Lesson 7 teaches it.
- Lesson 7 owns sensor reasoning; Lesson 8 owns I2C communication.
- SPI, UART/wireless, and motor control have explicit prerequisites.
- Quick Check bypass never removes necessary prerequisite instruction.
- IDs and learner progress remain stable or are migrated safely.
- The final report marks each issue as fixed, accepted with rationale, or still open.
