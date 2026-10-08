# Phase 26d - Lesson 5 Switches, Buttons & Potentiometers

## Goal
Combine the old button/digital-input and potentiometer/analog-input material into one coherent input lesson.

## Progression
Switch → button → digital input → pull-up → analog knob → analog reading → input controls output.

## Target Submodules
5.1 What Is a Switch?
5.2 Pushbuttons
5.3 Digital Inputs
5.4 digitalRead
5.5 Floating Inputs
5.6 Pull-Up Resistors
5.7 INPUT_PULLUP
5.8 Button Debouncing
5.9 Meet the Potentiometer
5.10 Voltage Divider
5.11 Analog Inputs
5.12 analogRead
5.13 Button + LED
5.14 Potentiometer → LED Brightness
5.15 Potentiometer → RGB Color
5.16 Input Challenge

Guardian may consolidate modules if cognitive load is too high.

## Button Progression
Teach open/closed, pressed/released, digital state, digitalRead, floating inputs, internal pull-up, active-low, and debounce through real behavior rather than abstract lecture.

## Potentiometer Progression
Teach knob movement, resistance concept, voltage divider, analog voltage, ADC, analogRead, and value range using physical observation before equations.

## Combination Projects
Button controls LED; potentiometer controls brightness; potentiometer controls RGB color. Advanced challenge: button changes potentiometer mode.

## Boundary
Lesson 5 owns physical input concepts. Coding Foundations owns variables, conditions, loops, functions, and general programming concepts.

## Safety
Low-voltage hardware only; correct resistor usage; no power shorts; teach wiring checks.

## Validation
Digital and analog concepts must connect naturally; active-low must be clear; activities must provide immediate feedback; sensor readiness must be established.


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

The Quick Check should diagnose the knowledge needed for:
- circuits
- pins
- digital outputs
- simple voltage/electrical ideas
- breadboard/component recognition where required
- reading simple input/output examples

Questions must distinguish existing knowledge from what the submodule will teach.
