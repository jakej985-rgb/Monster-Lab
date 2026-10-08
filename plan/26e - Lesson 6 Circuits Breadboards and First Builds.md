# Phase 26e - Lesson 6 Circuits, Breadboards & First Builds

## Goal
Expand the old Blink/physical-circuit lesson into a practical beginner hardware course centered on breadboards, simple components, and small projects.

## Teaching Loop
Wire → Observe → Change One Thing → Predict → Run → Explain.

## Target Submodules
6.1 What Is a Circuit?
6.2 Meet the Breadboard
6.3 Breadboard Rows and Rails
6.4 Resistors
6.5 First Breadboard Circuit
6.6 LED + Resistor
6.7 Blink on a Real Circuit
6.8 Digital Output Experiment
6.9 Distance Sensor Experiment
6.10 Sensor + Output Mini Project
6.11 Build Challenge

## Breadboard
Visually teach connected rows, power rails, component placement, and common wiring mistakes. Do not assume prior breadboard knowledge.

## Resistor
Explain the practical reason first: protect an LED and limit current. Advanced electrical math can come later.

## First Builds
LED + resistor, Blink, simple digital output, distance sensor → Serial Monitor, and distance sensor → LED/buzzer.

## Distance Sensor Activity
Wire it, run the provided program, open Serial Monitor, move a hand closer/farther, observe the changing distance, and explain that a sensor converts the real world into data.

## Troubleshooting
Broken examples should include reversed LED, missing resistor, wrong breadboard row, loose jumper, wrong pin, and disconnected sensor. Practice changing one thing at a time.

## Assessment
Learner can identify breadboard connections, explain a resistor's purpose, build a simple LED circuit, read sensor output, and identify common wiring errors.

## Safety
Low-voltage classroom hardware only. Never introduce mains electricity or unsafe power sources.

## Validation
This must teach physical circuit skills, not become another programming lesson.


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

The Quick Check should diagnose:
- Arduino pins
- power and GND
- basic circuit concepts
- LED behavior
- resistor purpose where previously introduced
- safe low-voltage hardware habits

Do not assume prior breadboard knowledge before the breadboard submodule.
