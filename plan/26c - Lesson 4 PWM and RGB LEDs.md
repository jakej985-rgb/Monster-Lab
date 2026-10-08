# Phase 26c - Lesson 4 PWM and RGB LEDs

## Goal
Move the old RGB/PWM material into Lesson 4 and rebuild it from simple ON/OFF control to variable output.

## Progression
ON/OFF → PWM → brightness → color → combined control.

## Target Submodules
4.1 From ON/OFF to Control
4.2 What Is PWM?
4.3 Duty Cycle
4.4 LED Brightness
4.5 analogWrite
4.6 Meet the RGB LED
4.7 Mixing Colors
4.8 Common Cathode vs Common Anode
4.9 RGB Mini Project
4.10 PWM Challenge

## Hands-On
Simple LED output, PWM brightness, fade, RGB channels, color creation, and later an input-controlled RGB challenge.

## Visual Explanations
PWM waveform, duty cycle, fast switching, perceived brightness, and RGB channel mixing. Do not require internal timer knowledge.

## Hardware
Use correct resistors, LED polarity, and simple current-limit guidance.

## Mini Project
Build an RGB status light such as green=ready, yellow=warning, red=stop. Advanced option: use an input to change color or brightness.

## Assessment
Learner can explain PWM simply, predict brightness changes, use analogWrite, identify RGB pins, create a color, and troubleshoot wrong colors.

## Validation
No advanced sensor dependency and no unnecessary Coding Foundations repetition.


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
- basic digital output knowledge
- LED behavior
- polarity/component recognition
- simple ON/OFF reasoning
- basic code-to-output understanding

Do not require prior PWM knowledge.
