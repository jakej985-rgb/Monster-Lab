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


## Pre-Test and Submodule Readiness System

Every lesson must begin with a **Pre-Test / Readiness Check** before the learner starts instruction.

The purpose is diagnosis, not punishment.

### Two Questions Per Submodule

Every submodule must have exactly **2 readiness questions** in its pre-test bank.

Questions should test the knowledge needed to understand that specific submodule, not trivia.

Examples:
- recognition
- vocabulary
- concept understanding
- prerequisite hardware knowledge
- simple prediction
- basic code reading when appropriate

The system may randomize from a larger question bank later, but the plan must guarantee at least 2 valid questions per submodule.

### Readiness Indicators

There are only two learner-facing readiness states:

- 🟢 **Green — Ready**
  - Strong evidence the learner already understands the prerequisite knowledge.
  - Continue normally.
- 🟡 **Yellow — Warm Up**
  - Some prerequisite knowledge is missing or uncertain.
  - Give a short review, visual explanation, or warm-up activity before the submodule.
  - The learner is **not blocked**.

**There is intentionally no red state.**

A learner must never be labeled “not ready,” “failed,” or blocked by the pre-test.

### Scoring

Each submodule's two questions produce a readiness result:

- **2/2 correct → Green**
- **0–1/2 correct → Yellow**

The lesson readiness screen should show all submodules, for example:

| Submodule | Readiness |
|---|---|
| What Is Arduino? | 🟢 Green |
| Inputs & Outputs | 🟡 Warm Up |
| Digital vs Analog | 🟢 Green |
| Power & Ground | 🟡 Warm Up |

The lesson can then provide a short targeted warm-up for yellow modules.

### Lesson-Level Readiness

Calculate an overall readiness summary from the submodule results:

- **Mostly Green → Ready**
- **Mixed Green/Yellow → Ready with Warm-Ups**
- **Mostly Yellow → Start with Guided Review**

Never display a red/failure state.

The learner still gets to start the lesson regardless of the result.

### Question Design Rules

Questions must:
- be age appropriate
- use visuals where helpful
- avoid trick questions
- avoid requiring knowledge the learner has not reasonably encountered
- distinguish prerequisite knowledge from lesson content
- provide useful diagnostic information
- support accessibility
- work on mobile

Questions should not reveal the exact answer to the upcoming submodule.

### Warm-Up Behavior

When a submodule is yellow:
1. show the learner the yellow readiness indicator;
2. provide a short explanation or visual;
3. offer one tiny practice interaction;
4. let the learner continue;
5. do not force them to retake the pre-test.

### Data Requirements

Readiness results should be stored separately from lesson completion.

Suggested data:
- lesson ID
- submodule ID
- question IDs
- selected answers
- correctness
- readiness state
- timestamp
- whether warm-up was shown

Do not award normal lesson completion XP merely for answering the pre-test.

### Progress Rules

Pre-test performance must not:
- fail the lesson
- block navigation
- remove XP
- mark a learner as incapable
- overwrite mastery/progress data

Pre-test results are diagnostic signals that can help the app recommend review.

### Guardian Requirement

Curriculum Guardian must review every pre-test question set for:
- prerequisite validity
- age appropriateness
- fairness
- diagnostic value
- technical accuracy
- absence of trick questions
- correct Green/Yellow classification

Integration/QA must verify:
- every submodule has 2 questions
- every question has a valid answer
- every result resolves to Green or Yellow
- no Red state exists in the readiness UI/data model
