# Phase 26 - Curriculum Restructure Multi-Agent Launch

## Goal
Use Antigravity 2.0 multi-agent execution to redesign Monster Lab around progressive learning layers instead of 18–22 minute mega-lessons.

## Core Decision
Teach important concepts more than once when useful, but every revisit must increase complexity.

Learning progression:
1. Introduce — concrete, visual, simple.
2. Understand — explain what and why.
3. Explore — manipulate and observe.
4. Practice — guided activity.
5. Apply — combine concepts.
6. Troubleshoot — diagnose failures.
7. Create — solve a new problem independently.
8. Revisit later at a higher difficulty.

Do not pad lessons.

## Target Sequence
1. Arduino Fundamentals — redesigned into submodules.
2A. Meet Monster Lab — keep separate.
2B. Arduino IDE Walkthrough — keep separate.
Coding Foundations — keep separate and own general programming fundamentals.
3. Libraries — beginner-first explanation, then use and modification.
4. PWM & RGB LEDs — old Lesson 7 moved here.
5. Switches, Buttons & Potentiometers — combines old Lesson 8 and old Lesson 6.
6. Circuits, Breadboards & First Builds — expands old Lesson 5.
7. Sensors & Reading the Real World — new bridge lesson.
8. I2C & Connected Devices — old I2C content rebuilt around the new foundation.

## Sequence Gate — Phase 27 Must Be Resolved First

The target sequence above is **provisional** because the Phase 27 audit found forward dependencies: PWM/RGB expects circuit and resistor knowledge that Lesson 6 currently introduces later; Lesson 5 includes PWM-dependent projects; and Lesson 6's sensor activities risk teaching sensor interpretation before Lesson 7.

Before lesson specialists implement or reorder content:
1. Complete `plan/27 - Curriculum Sequence and Prerequisite Audit.md`.
2. Approve a dependency-safe course order.
3. Decide whether to change learner-facing lesson numbering or keep stable IDs with an explicit display-order field.
4. Update course manifests, prerequisites, next/previous references, and roadmap docs as one coordinated integration change.
5. Keep stable IDs and learner progress safe; do not silently rename IDs.

Do not treat the historical lesson numbers as more important than prerequisite correctness. A lesson must not depend on a concept first taught later.

## Multi-Agent Team
### Curriculum Architect
Own sequence, prerequisites, concept ownership, lesson boundaries, repetition rules, and dependency graph. Read Phases 21, 23, 25 and all current curriculum. Produce an authoritative target map before destructive edits.

### Lesson 1 Specialist
Implement only the Lesson 1 redesign from 26a.

### Lesson 3 Specialist
Implement only the Lesson 3 redesign from 26b.

### Lesson 4 Specialist
Implement only the Lesson 4 redesign from 26c.

### Lesson 5 Specialist
Implement only the Lesson 5 redesign from 26d.

### Lesson 6 Specialist
Implement only the Lesson 6 redesign from 26e.

### Lesson 7 Specialist
Implement only the new Lesson 7 from 26f.

### Lesson 8 Specialist
Implement only the Lesson 8 redesign from 26g.

### Curriculum Guardian
Audit age appropriateness, cognitive load, technical accuracy, prerequisites, sequence, timing, safety, assessment, code comprehension, hardware readiness, mobile learning, and progression. Use APPROVED, APPROVED WITH REVISIONS, REVISION REQUIRED, or BLOCKED.

### Integration/QA Agent
Own schema validation, curriculum index, prerequisites, stable IDs, asset references, progress compatibility, tests, and documentation. Do not rewrite pedagogy unless a technical conflict exists.

## Execution Waves
### Wave 1 — Discovery
Every specialist inspects the current implementation and reports current ID, title, retained content, moved content, removed content, new content, prerequisites, assets, references, and migration risks. No destructive edits.

### Wave 2 — Architecture
Curriculum Architect publishes the target map. Guardian checks for missing/circular prerequisites, duplication, and learning gaps.

### Wave 3 — Parallel Lesson Design
Specialists work in parallel because each owns a separate lesson. Shared curriculum files must not be edited concurrently.

### Wave 4 — Integration
Integration agent updates ordering, prerequisites, IDs, indexes, schema, progress migration, assets, and tests.

### Wave 5 — Guardian Audit
Review the complete curriculum as one sequence. Confirm 2A/2B remain distinct, Coding Foundations owns general programming, Lesson 3 explains why libraries before internals, Lesson 4 introduces PWM at the right time, Lesson 5 combines inputs logically, Lesson 6 teaches physical building, Lesson 7 fills the sensor gap, and Lesson 8 is ready for I2C.

### Wave 6 — QA
Run JSON/schema validation, Flutter analyzer, tests, curriculum loader tests, prerequisite tests, completion tests, asset checks, mobile rendering checks, and progress migration checks.

## Shared Lesson Standard
Every redesigned lesson must define:
- stable lesson ID
- title
- age/tier
- estimated time
- prerequisites
- objectives
- submodules
- vocabulary
- visuals
- interactive activities
- hands-on activities
- code activities
- troubleshooting
- assessment
- challenge
- completion criteria
- XP
- required parts
- safety notes
- next-lesson readiness

## Advanced Revisit Rule
A later revisit must add a meaningful new dimension: combination, reasoning, troubleshooting, measurement, or independence. Never copy the beginner lesson with more text.

## Agent Safety
- Never overwrite another specialist's lesson.
- Never silently rename stable IDs.
- Never change shared schemas without Integration.
- Preserve learner progress.
- Prefer additive migrations.
- Do not remove content solely because it appears twice; determine whether it is reinforcement or accidental duplication.

## Definition of Done
Lessons 1, 3, 4, 5, 6, 7, and 8 have approved modular structures; 2A, 2B, and Coding Foundations remain separate; Lesson 7 is complete; prerequisites are coherent; advanced revisits are documented; data validates; progress is safe; Guardian approves; tests pass; README/roadmap documentation is current.


## Optional Pre-Test / Quick Check

Every lesson should **offer** a short diagnostic called **Quick Check** before instruction begins.

The Quick Check is optional. Learners must be able to choose either:

- **Take Quick Check** — answer the readiness questions first.
- **I already know this — Start Lesson** — skip the check and begin instruction immediately.

Do not label the second option "Skip Test." The tone should communicate learner choice, not avoidance.

Suggested learner-facing copy:

> **🧠 Quick Check — About 1 minute**  
> Let's see what you already know. Your answers help Monster Lab decide what to explain.

Buttons:
- **Take Quick Check**
- **I already know this — Start Lesson**

### Two Questions Per Submodule

Every submodule must have exactly **2 readiness questions** in its Quick Check bank.

Questions diagnose prerequisite knowledge rather than trivia.

### Readiness Results

For learners who take the Quick Check:

- **2/2 correct → 🟢 Green — Ready**
- **0–1/2 correct → 🟡 Yellow — Warm Up**

There is **no red state**.

If the learner chooses **I already know this — Start Lesson**, readiness is **Not Assessed**. This is not a failure, warning, or readiness color. It simply means the learner chose to begin without taking the diagnostic.

Not Assessed learners must still receive the full lesson and can demonstrate readiness through later activities.

### Yellow Behavior

Yellow is not failure and does not block progress.

For a yellow submodule:
1. show the yellow readiness indicator;
2. provide a short visual explanation or review;
3. offer one tiny practice interaction;
4. continue into the submodule;
5. do not force a retake.

### Lesson-Level Summary

Only summarize readiness for learners who actually take the Quick Check.

- Mostly Green → **Ready**
- Mixed Green/Yellow → **Ready with Warm-Ups**
- Mostly Yellow → **Start with Guided Review**
- Quick Check not taken → **Not Assessed**

The learner can start the lesson in every case.

### Data Rules

Store Quick Check results separately from lesson completion:

- lesson ID
- submodule ID
- question IDs
- selected answers
- correctness
- readiness result
- timestamp
- whether warm-up was shown
- whether the learner took or bypassed the Quick Check

For a bypass, record **Not Assessed** rather than inventing Green or Yellow results.

Quick Check performance must never:
- fail the lesson
- block navigation
- remove XP
- mark a learner incapable
- overwrite mastery/progress data

Do not award normal lesson-completion XP merely for taking the Quick Check.

### Guardian / QA Requirements

Guardian reviews every question set for prerequisite validity, age appropriateness, fairness, diagnostic value, technical accuracy, and absence of trick questions.

Integration/QA verifies:
- every submodule has exactly 2 Quick Check questions;
- every question has a valid answer;
- checked results resolve only to Green or Yellow;
- bypassed checks resolve to Not Assessed;
- no Red readiness state exists in the UI or data model;
- bypassing does not block lesson access;
- later lesson evidence can still demonstrate readiness.
