# 21 Lesson Content Expansion and 15-20 Minute Learning Modules

## Goal
Expand every Monster Lab lesson into a rigorous, engaging, and meaningful 15–20 minute learning experience with thorough conceptual reading, physical hardware discovery, line-by-line coding instruction, prediction-driven experiments, diagnostic troubleshooting, and comprehensive knowledge checks to justify the advertised time budget without fluff or filler.

## Core Principle
Do not add filler or busywork.

Build every lesson according to the engineering pedagogical pipeline:

```
Technical Research & Ground Truth
               ↓
    Pedagogical Simplification
               ↓
      14-Section Content Taxonomy
               ↓
 6 Runtime UI Containers (Schema-Compliant)
               ↓
     Single Source of Truth Compiler
               ↓
  Automated Validation & Test Suites
```

---

## Target Pacing Model (15–20 Minutes)

Each lesson provides approximately 15–22 minutes of meaningful activity:
- **4–6 minutes**: Conceptual reading, signal flow, and real-world system context.
- **2–3 minutes**: Visual architectural diagrams and pin identification.
- **2–4 minutes**: Guided practice and code prediction.
- **3–5 minutes**: Hands-on hardware inspection or interactive simulator experiment.
- **2–4 minutes**: Multi-question assessment checkpoint and competency recap.

Pacing may vary slightly based on difficulty tier and circuit complexity.

---

## Master Lesson Curriculum Table

All 12 foundational lessons are paced for 15–25 minutes of focused learning, with verified component cross-references and prerequisite dependency chains:

| Lesson ID | Lesson Title | Difficulty Tier | Target Time | Prerequisites | Component Cross-References | XP Reward |
|---|---|---|---|---|---|---|
| `lesson_01` | What is Arduino & How Does It Work? | Rookie | 15–20 min | None | `comp_uno` | 50 |
| `lesson_02` | Setting Up Your Monster Lab Station | Rookie | 15–20 min | `lesson_01` | `comp_uno` | 50 |
| `lesson_03` | Installing Libraries: Supercharging Code | Builder | 16–20 min | `lesson_02` | `comp_uno`, `comp_07` | 60 |
| `lesson_04` | Basics of the Arduino IDE: Setup and Loop | Rookie | 16–20 min | `lesson_02` | `comp_uno` | 60 |
| `lesson_05` | Blink: Your First Physical Circuit | Rookie | 18–22 min | `lesson_04` | `comp_uno` | 75 |
| `lesson_06` | Potentiometer: Reading Analog Signals | Rookie | 18–22 min | `lesson_05` | `comp_uno`, `comp_breadboard`, `comp_20` | 80 |
| `lesson_07` | RGB LED: Mixing Colors with PWM | Rookie | 18–22 min | `lesson_05` | `comp_uno`, `comp_breadboard` | 90 |
| `lesson_08` | Digital Inputs: Pushbuttons & Internal Pullups | Rookie | 16–20 min | `lesson_05` | `comp_uno`, `comp_breadboard` | 70 |
| `lesson_09` | The I2C Communication Bus | Builder | 18–22 min | `lesson_03`, `lesson_04` | `comp_uno`, `comp_07`, `comp_10` | 80 |
| `lesson_10` | The High-Speed SPI Protocol | Engineer | 18–22 min | `lesson_09` | `comp_uno`, `comp_15`, `comp_23` | 90 |
| `lesson_11` | Serial UART & Wireless Communication | Engineer | 18–22 min | `lesson_04` | `comp_uno`, `comp_29` | 90 |
| `lesson_12` | PWM & Motor Physics | Engineer | 20–25 min | `lesson_06`, `lesson_07` | `comp_uno`, `comp_33`, `comp_36`, `comp_l293d` | 100 |

---

## Lesson Rework Files (Sub-Plans 21a through 21l)

The detailed lesson rework blueprints are maintained as separate Markdown specifications using the 21-series letter format:

- **21a** — Lesson 01: What Is Arduino & How Does It Work?
- **21b** — Lesson 02: Setting Up Your Monster Lab Station
- **21c** — Lesson 03: Installing Libraries: Supercharging Code
- **21d** — Lesson 04: Basics of the Arduino IDE: Setup and Loop
- **21e** — Lesson 05: Blink: Your First Physical Circuit
- **21f** — Lesson 06: Potentiometer: Reading Analog Signals
- **21g** — Lesson 07: RGB LED: Mixing Colors with PWM
- **21h** — Lesson 08: Digital Inputs: Pushbuttons & Internal Pullups
- **21i** — Lesson 09: The I2C Communication Bus
- **21j** — Lesson 10: The High-Speed SPI Protocol
- **21k** — Lesson 11: Serial UART & Wireless Communication
- **21l** — Lesson 12: PWM & Motor Physics

### 21x Technical Specification Standard
Each 21x sub-plan is an authoritative technical blueprint for its corresponding lesson. When implementing or modifying curriculum content:
1. Treat the 21x blueprint as the canonical content standard.
2. Ensure technical assertions match ATmega328P datasheet electrical limits, protocol timings, and Arduino Core C++ standards.
3. Map the 14 pedagogical categories directly into schema-valid runtime step types.
4. Maintain test suite invariants (e.g. `lesson_01` 50 XP, `lesson_03` canonical quiz copy and step placement).

---

## Learner Coding Baseline

### Coding Knowledge Check
Before lessons introduce significant code:
- Verify prerequisite concepts through inline prediction and warmups.
- Avoid assuming that seeing code syntax translates directly to structural understanding.
- Address cognitive misconceptions (e.g. infinite loop semantics, blocking delays, inverted pullup logic) proactively.
- Provide progressive scaffolding so rookie learners are never stalled.

### Arduino Coding Basics
Connect programming concepts directly to embedded hardware operations:
- Microcontroller lifecycle: Reset, bootloader, `setup()`, and infinite `loop()`.
- Silicon pin driver states: `pinMode(pin, OUTPUT)`, `pinMode(pin, INPUT)`, `pinMode(pin, INPUT_PULLUP)`.
- Digital logic levels: `digitalWrite(pin, HIGH / LOW)` and `digitalRead(pin)`.
- Analog sampling: 10-bit ADC Successive Approximation via `analogRead(pin)`.
- Pulse Width Modulation: 8-bit timer registers via `analogWrite(pin, 0..255)`.
- Clock & timing: Millisecond delays (`delay()`) vs non-blocking timestamp arithmetic (`millis()`).
- Hardware debugging: Bidirectional serial communication via `Serial.begin(baud)` and `Serial.println()`.

---

## Code Understanding Standard

Before a learner uploads or simulates significant code:
- Explain the engineering goal of the sketch.
- Provide line-by-line annotations of crucial statements, types, and constants.
- Demystify magic numbers (pin numbers, baud rates, bitmasks, millisecond durations).
- Explain hardware consequences: identify which transistors switch and which registers update.

### Code Walkthrough & Trust but Verify
Teach learners to:
1. **Read & Deconstruct**: Inspect the sketch structure and pinout configuration before uploading.
2. **Predict First**: Commit to a behavioral hypothesis before seeing the simulator or hardware react.
3. **Isolate Variables**: Make a single controlled parameter edit (`Change → Predict → Upload → Observe → Explain`).
4. **Debug Systematically**: Correlate compiler error syntax or hardware runtime anomalies to root causes.

---

## 14-Section Pedagogical Taxonomy

To deliver a comprehensive 15–20 minute module, every lesson structure is authored across 14 standardized pedagogical sections:

1. **Mission Introduction**: Set the narrative hook and frame the lesson around an authentic robotics problem.
2. **Prior Knowledge Check**: 2–4 quick warmup questions reinforcing prerequisite concepts without blocking progress.
3. **Core Concept & Vocabulary**: Clear, age-appropriate definitions of technical terms before they are used in code or hardware.
4. **How It Works / Signal Flow**: Deep-dive physical explanation tracing: `Hardware → Electrical Signal → Arduino Register → Software Decision → Physical Output`.
5. **Hardware Mission**: Hands-on inspection of components, identifying pinouts, polarity indicators, and package markings before wiring.
6. **Coding Basics**: Introduction of fundamental programming syntax (functions, variables, control flow, pin modes) required for the lesson.
7. **Code Walkthrough**: Fully annotated sketch where every line, parameter, constant, and hardware interaction is explained.
8. **Code Prediction**: Explicit "what-if" cognitive challenge asking learners to predict hardware behavior before executing code.
9. **Guided Experiment**: A structured parameter change teaching scientific isolation (`Change → Predict → Upload → Observe → Explain`).
10. **Real-World Systems**: Industrial, aerospace, automotive, or medical robotics case studies demonstrating the concept in professional engineering.
11. **Troubleshooting Challenge**: Real-world diagnostic scenario providing a symptom, probable causes, a targeted test, and systematic remedy.
12. **Workshop Safety & Hardware Care**: Electrical rules protecting both learner and hardware (current limits, back-EMF, short-circuit prevention).
13. **Knowledge Check (8 Questions)**: Comprehensive multi-concept assessment testing recall, code comprehension, troubleshooting, and electrical safety.
14. **Final Review**: Summary of competencies mastered, vocabulary recap, and forward bridge to the subsequent lesson.

---

## Runtime Architecture: Pedagogical Taxonomy to Runtime Container Mapping

In the runtime Flutter client (`LessonDetailScreen`), domain models (`LessonStep`), and schema validators (`lesson.schema.json`), `StepType` is strictly constrained to 6 container types to preserve backward compatibility, responsive UI layout, and test suite stability:

| 14-Section Pedagogical Category | Runtime StepType Container | Runtime UI Behavior & Widget Scoping |
|---|---|---|
| 1. Mission Introduction | `story` | Full-width narrative card with monster lore and mission objectives |
| 2. Prior Knowledge Check | `story` or `quizCheckpoint` | Warmup review card or inline diagnostic question |
| 3. Core Concept & Vocabulary | `story` | Concept briefing card highlighting key technical terms |
| 4. How It Works / Signal Flow | `visualExplanation` | Architectural diagram card or visual signal flow trace |
| 5. Hardware Mission | `physicalTask` | Tactile hardware inspection checklist with pinout identification |
| 6. Coding Basics | `story` | Syntax foundation briefing explaining keywords, data types, and functions |
| 7. Code Walkthrough | `codeExperiment` | Annotated code viewer with line-by-line syntax explanation |
| 8. Code Prediction | `codeExperiment` | Prediction prompt card challenging learners to deduce behavior |
| 9. Guided Experiment | `codeExperiment` | Parameter modulation task paired with interactive hardware simulator |
| 10. Real-World Systems | `visualExplanation` or `story` | Case study card connecting lesson to professional robotics |
| 11. Troubleshooting Challenge | `story` or `codeExperiment` | Diagnostic branching scenario isolating root hardware/software bugs |
| 12. Workshop Safety & Hardware Care | `story` | High-visibility electrical safety warnings and current limit rules |
| 13. Knowledge Check (8 Questions) | `quizCheckpoint` | Interactive assessment card awarding milestone XP upon completion |
| 14. Final Review | `story` | Mission debrief card summarizing competencies and next steps |

---

## Interactive Simulator Routing & Visual Pipeline

### 1. Dynamic Widget Routing (`interactiveWidgetType`)
Interactive simulators in `lib/presentation/features/learn/widgets/` are routed via `currentStep.interactiveWidgetType` rather than relying exclusively on hardcoded `lesson.id` and `currentStep.type`:
- `'boardInspector'`: Interactive Arduino Uno pin and component explorer (`BoardInspectorWidget`).
- `'blinkSimulator'`: Real-time LED digital frequency and persistence of vision simulator (`BlinkSimulatorWidget`).
- `'potentiometerSimulator'`: Continuous ADC voltage division and wiper slider simulator (`PotentiometerSimulatorWidget`).
- `'rgbMixer'`: 3-channel 8-bit PWM additive color synthesis simulator (`RgbMixerWidget`).

### 2. Illustration Asset Pipeline (`illustrationAsset`)
When a lesson step defines an `illustrationAsset`, the lesson detail viewer renders the asset using Monster Lab's standard asset view (`Image.asset`), falling back gracefully if offline images are unavailable.

---

## Research Standards & Difficulty Tiers

### Research Standards
For every lesson module:
- Base technical assertions on official Atmel ATmega328P datasheets, Arduino Core documentation, and IPC electronics standards.
- Ground circuit limits in verified physics (e.g. 20 mA continuous pin limit, 200 mA VCC/GND package limit, 4.88 mV ADC step size).
- Translate complex engineering mechanisms into crisp, age-appropriate prose without oversimplifying core electrical truths.

### Difficulty Tiers
- **Rookie** (`lesson_01`, `02`, `04`, `05`, `06`, `07`, `08`):
  Focuses on foundational concepts, visual circuits, intuitive analogies, and guarded experiments.
- **Builder** (`lesson_03`, `09`):
  Introduces multi-device communication buses (I2C), modular C++ libraries, hardware abstraction, and register addressing.
- **Engineer** (`lesson_10`, `11`, `12`):
  Covers high-speed synchronous buses (SPI), asynchronous wireless telemetry (UART), inductive electromagnetism, and motor physics.

---

## Assessment Requirements

Assessments must not test trivial memorization alone:
- **Core Recall**: Fundamental vocabulary, pin functions, and voltage levels.
- **Code Reading & Syntax**: Tracing execution paths, variable scope, and parameter effects.
- **Prediction Challenges**: Deducing physical hardware behavior when code values change.
- **Diagnostic Troubleshooting**: Identifying circuit faults from symptoms and selecting correct remedies.
- **Electrical Safety**: Current limits, flyback diodes, and short-circuit prevention.

---

## Single Source of Truth Compiler Pipeline

All curriculum data assets are managed under a single source of truth compilation architecture:

```
scripts/generate_curriculum_assets.py
               │
               ▼  (Generates JSON files)
assets/curriculum/lessons/lesson_*.json
assets/curriculum/curriculum_manifest.json
               │
               ▼  (Validates Schema & Foreign Keys)
scripts/validate_curriculum.py
               │
               ▼  (Embedded Fallback Data Sync)
lib/data/datasources/asset_curriculum_datasource.dart
```

1. **Authorship**: All lesson content expansions, steps, and quiz questions are authored in `scripts/generate_curriculum_assets.py`.
2. **Generation**: Executing `python3 scripts/generate_curriculum_assets.py` compiles JSON assets into `assets/curriculum/lessons/` and updates `curriculum_manifest.json`.
3. **Validation**: Executing `python3 scripts/validate_curriculum.py` guarantees 100% schema compliance, 54-component integrity, and valid cross-references.
4. **Offline Resilience**: Fallback mock structures in `asset_curriculum_datasource.dart` mirror the generated asset schemas to ensure offline reliability.

---

## Implementation Workflow (Phases A through H)

1. **Phase A — Sub-Plan Grounding**: Audit and expand sub-plan technical specifications (21a–21l).
2. **Phase B — Engineering Research**: Verify electrical constants and protocol timings against datasheets.
3. **Phase C — Content Authoring**: Implement the 14-section taxonomy mapped into 6 runtime container steps in `scripts/generate_curriculum_assets.py`.
4. **Phase D — Interactive Simulators**: Route simulators via `interactiveWidgetType` and wire responsive controls.
5. **Phase E — Asset Generation**: Compile JSON assets and validate schemas via `validate_curriculum.py`.
6. **Phase F — Fallback Synchronization**: Align `asset_curriculum_datasource.dart` baseline definitions with the full 12-lesson suite.
7. **Phase G — Pacing & Duration Audit**: Confirm modules provide 15–22 minutes of rigorous learning.
8. **Phase H — Automated Testing**: Verify 100% pass rate across all unit, widget, and static analysis suites.

---

## Testing & Verification Criteria

1. **Schema & Referential Integrity**:
   - `python3 scripts/validate_curriculum.py` must pass 100% with 12 lessons, 54 components, 20 projects, 24 challenges, and 20 badges.
2. **Full Automated Test Suite**:
   - `flutter test` must pass all 136+ unit and widget tests without failure.
   - Specific assertions in `test/widget/learn_completion_flow_test.dart` (XP awards, button text, canonical quiz copy, replay idempotency) must remain 100% green.
3. **Static Analysis**:
   - `flutter analyze` must report 0 issues.
4. **Code Style**:
   - `dart format --output=none --set-exit-if-changed .` must pass with zero formatting drift.

---

## Done When
- Lessons genuinely provide approximately 15–20 minutes of meaningful learning.
- Every lesson has a corresponding, fully expanded 21x Markdown specification matching the depth of 21a and 21b.
- The 14-section pedagogical taxonomy is cleanly mapped into schema-valid runtime step types.
- `scripts/generate_curriculum_assets.py` acts as the single source of truth for all lesson JSONs and manifests.
- Embedded fallback mock data in `asset_curriculum_datasource.dart` provides all 12 lessons with full offline resilience.
- `interactiveWidgetType` routing enables dynamic simulator mounting.
- All curriculum validation checks pass 100%.
- Flutter tests, static analysis, and dart format checks pass with zero errors.
