# 25 — Curriculum Conflict Register

**Curriculum Guardian Audit & Governance**  
**Resolution Principle**: Modern, explicit architectural decisions (`plan/22`–`plan/24`) supersede legacy draft specifications (`plan/01`–`plan/21`).

---

## Conflict Index & Resolutions

### Conflict CR-01: Lesson 2 Monolithic Definition vs. Course 2A / 2B Split
- **Source of Conflict**:
  - Legacy plans (`plan/01`, `plan/04`, `plan/21`, `plan/21b`) describe "Lesson 02" as a single monolithic lesson: *Setting Up Your Monster Lab Station / Installing Arduino IDE*.
  - Modern plans (`plan/23`, `plan/23b`, `plan/23c`) split this into two dedicated modular courses:
    - **Lesson 2A (`lesson_2a`)**: *Monster Lab Walkthrough* (8 sub-lessons: `l2a_01`–`l2a_08`).
    - **Lesson 2B (`lesson_2b`)**: *Arduino IDE Walkthrough* (8 sub-lessons: `l2b_01`–`l2b_08`).
- **Severity**: HIGH
- **Intended Behavior**:
  The modern Course 2A / 2B split is the authoritative standard. The app and IDE must be taught separately to prevent cognitive overload.
- **Resolution**:
  - Deprecate single `lesson_02.json`.
  - Maintain the 16 modular sub-lessons (`l2a_01`..`l2a_08` and `l2b_01`..`l2b_08`).
  - Provide runtime backward compatibility via `LearnerProgressModel.migrateFromOldFormat(progress)`, which automatically expands legacy `lesson_02` completions into `l2b_01`..`l2b_08`.

---

### Conflict CR-02: Coding Foundations Sequencing and Placement
- **Source of Conflict**:
  - Early plans jumped directly from hardware overview (Lesson 1) into IDE setup (Lesson 2) and library installation (Lesson 3) without introducing programming basics.
  - Phase 23 introduced the **Coding Foundations** course (`coding_foundations`, `cf_01`–`cf_08`) between Lesson 1 and Lesson 2A.
- **Severity**: HIGH
- **Intended Behavior**:
  Learners without coding experience must learn variables, conditional logic, loops, and functions before reading Arduino C++ sketches.
- **Resolution**:
  - Coding Foundations is positioned between Lesson 1 and Lesson 2A.
  - It is marked `isOptional: true` with placement lesson `cf_08`.
  - Experienced learners can test out immediately, satisfying prerequisites for downstream lessons without repetitive drills.

---

### Conflict CR-03: Early Sequence Numbering and "setup()/loop()" Duplication
- **Source of Conflict**:
  - Sub-lesson `l2b_04` teaches `setup() and loop() Deep Dive`.
  - Standalone `lesson_04` is titled `Basics of the Arduino IDE: Setup and Loop`.
  - Sub-lesson `l2b_06` teaches `Libraries Overview`.
  - Standalone `lesson_03` is titled `Installing Libraries: Supercharging Code`.
  - Sub-lesson `l2b_08` walks through flashing Blink.
  - Standalone `lesson_05` is titled `Blink: Your First Physical Circuit`.
- **Severity**: MEDIUM
- **Intended Behavior**:
  Pedagogical progression from mechanical IDE operation to deep embedded systems engineering.
- **Resolution**:
  - **In Lesson 2B**: Concepts are taught from an operational/tooling perspective (where the buttons are in the IDE, how to paste example code, how to hit Upload, and how to open the Serial Monitor).
  - **In Lessons 3, 4, and 5**: Concepts are taught from an embedded engineering perspective:
    - *Lesson 3*: C++ header abstraction, I2C bus wiring on breadboards, and character LCD contrast calibration.
    - *Lesson 4*: 16 MHz microcontroller execution cycles, reset vectors, clock ticks, and UART baud rate framing.
    - *Lesson 5*: Physical photon emission, push-pull MOSFET register manipulation (PORTB5), current limits, and persistence of vision.
  - Retain both layers: Course 2B establishes tool proficiency, while Lessons 3–5 establish engineering depth.

---

### Conflict CR-04: Standalone Lesson IDs vs Modular Course Sub-Lesson IDs
- **Source of Conflict**:
  - Standalone lessons use IDs like `lesson_01`, `lesson_03`..`lesson_12`.
  - Modular course lessons use prefixed short IDs (`cf_01`..`cf_08`, `l2a_01`..`l2a_08`, `l2b_01`..`l2b_08`).
  - Some test and documentation mocks expected uniform `lesson_XX` regex across all entities.
- **Severity**: LOW
- **Intended Behavior**:
  Both patterns are valid and supported.
- **Resolution**:
  - `CurriculumValidator` regex pattern explicitly permits `^(lesson_[0-9]{2,3}|cf_[0-9]{2}|l2a_[0-9]{2}|l2b_[0-9]{2})$`.
  - All automated validation scripts and tests enforce and verify this multi-course pattern.

---

### Conflict CR-05: Project Inventory Counts (12 vs 14 Projects)
- **Source of Conflict**:
  - Initial project roadmap (`plan/01`, `plan/02`) listed 12 projects.
  - Physical kit archive audit (`audit/00_audit_summary.md`) discovered 14 projects in `Projects/` (`MONSTER ATM and Food Dispenser` and `Remote Control Funny Faces`).
  - Assets repository contains 20 projects (`proj_01` through `proj_20`), including advanced IoT, telemetry, and line tracking projects.
- **Severity**: LOW
- **Intended Behavior**:
  The full set of 20 projects represents the complete, rich curriculum.
- **Resolution**:
  - Manifest and validator formally index all 20 projects.
  - All 20 projects pass JSON schema, BOM, and step validation.
