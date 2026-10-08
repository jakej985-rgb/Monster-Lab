# Phase 26f - Lesson 7 Sensors & Reading the Real World

## Goal
Create the missing Lesson 7 as the bridge between basic circuits/inputs and later connected devices.

## Core Idea
A sensor turns something happening in the real world into information Arduino can use.

## Target Submodules
7.1 What Is a Sensor?
7.2 Digital Sensors
7.3 Analog Sensors
7.4 Distance Sensors
7.5 Light Sensors
7.6 Reading Sensor Data
7.7 Sensor Thresholds
7.8 Sensor → Output
7.9 Multiple Sensors
7.10 Sensor Troubleshooting
7.11 Sensor Challenge

## Sensor Types
Use approachable examples such as distance, light, temperature, and motion. Do not overload the beginner with dozens of parts.

## Digital vs Analog
Connect directly to Lesson 5: digital sensors have states; analog sensors provide changing measurements. Use visual comparisons.

## Distance Sensor
Build on Lesson 6. Lesson 6 makes the sensor work; Lesson 7 teaches the learner to understand and use its data.

Activities:
- distance → Serial Monitor
- distance thresholds
- distance → LED
- distance → RGB status

## Thresholds
Show how raw measurements become decisions, such as near/medium/far. Connect to Coding Foundations without reteaching the full programming course.

## Multiple Sensors
Advanced activity: read two sensors, compare readings, decide which condition wins, and troubleshoot one bad reading.

## Troubleshooting
Wrong wiring, wrong pins, unexpected values, sensor range, environmental effects, noisy readings, and calibration.

## Challenge
Build a system that reacts when something gets close. Beginner: LED. Builder: RGB state. Advanced: add buzzer or second sensor.

## Assessment
Learner can explain a sensor, distinguish digital/analog sensing, read a sensor value, create a threshold, use sensor data to control an output, and troubleshoot a sensor system.

## Validation
Lesson 5 teaches input components. Lesson 6 teaches physical building. Lesson 7 teaches interpreting real-world measurements.


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
- digital vs analog understanding
- basic inputs
- potentiometer/analog reading concepts
- breadboard and wiring readiness
- reading Serial Monitor output
- simple output control

Distance-sensor submodules should use Lesson 6 knowledge as their prerequisite foundation.
