# Phase 26a - Lesson 1 Arduino Fundamentals

## Goal
Replace the current large Lesson 1 with a beginner-first modular introduction for ages 6+ that prepares learners for 2A, 2B, and later hardware lessons.

## Preserve
Arduino, Uno, microcontroller, CPU, memory, GPIO, inputs, outputs, digital vs analog, pins, power, ground, code-to-hardware relationship, simple troubleshooting, and engineering mindset.

## Target Submodules
1. What Is Arduino?
2. Meet the Arduino Uno
3. What Is a Microcontroller?
4. Inputs and Outputs
5. Digital vs Analog
6. Meet the Pins
7. Power and Ground
8. How Arduino Makes Decisions
9. Code to Hardware
10. Your First Engineering Experiment
11. Basic Troubleshooting
12. Review and Challenge

The agent may adjust the exact count after Guardian review.

## Rules
- Concrete before technical.
- Pictures before terminology.
- Vocabulary immediately before use.
- Do not turn this into a programming course.
- Do not duplicate Coding Foundations.
- Use simple input → Arduino → output diagrams.
- Make power and ground visually obvious.

## Activities
Board landmark identification, input/output classification, digital/analog sorting, pin identification, power/GND recognition, decision-pipeline prediction, simple troubleshooting, and an Arduino detective challenge.

## Assessment
Learner can explain Arduino simply, identify input/output, distinguish digital/analog examples, identify power/GND, explain that code controls hardware, and recognize a basic wiring/code problem.

## Exclude
No deep loops/functions, libraries, communication protocols, PWM theory, or sensor wiring.

## Validation
Check age 6+ readability, no Coding Foundations duplication, short chunks, visual requirements, stable ID compatibility, and minimal prerequisites.


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

## Quick Check Content

The Quick Check should diagnose whether the learner recognizes:
- everyday machines
- simple input/output ideas
- basic electronics vocabulary
- the idea that a computer follows instructions

Do not assume prior Arduino knowledge.
