# Phase 26g - Lesson 8 I2C & Connected Devices

## Goal
Rebuild the old I2C lesson so it follows the new hardware, input, sensor, and library foundation.

## Required Readiness
Arduino pins, power/GND, circuits, breadboards, inputs, sensors, libraries, and basic code concepts.

## Progression
Why devices communicate → two wires → addresses → library → first device → multiple devices → troubleshooting.

## Target Submodules
8.1 Why Do Devices Need to Talk?
8.2 Meet I2C
8.3 SDA and SCL
8.4 I2C Addresses
8.5 Your First I2C Device
8.6 I2C LCD
8.7 I2C Sensor
8.8 Multiple I2C Devices
8.9 I2C Troubleshooting
8.10 I2C Challenge

## Beginner Explanation
Start with the problem: how can another device send information to Arduino? Then introduce I2C as a shared communication path using a simple analogy.

## Technical Progression
Introduce SDA, SCL, addresses, controller/device roles, pull-ups, and shared-bus behavior only after the basic concept is understood.

## Library Connection
Explicitly connect to Lesson 3: install a device library, run its example, modify it, and understand which library functions communicate with the device.

## Hands-On
Wire one device, run an example, observe output, modify it, add a second device, then diagnose a communication problem.

## Troubleshooting
Swapped SDA/SCL, missing GND, wrong address, wrong library, loose wiring, incompatible device, and address conflicts.

## Challenge
Build a small information station using a sensor and I2C display. Advanced version adds a second I2C device.

## Boundary
Lesson 3 = libraries. Lesson 8 = communication using a library and physical devices.

## Validation
I2C must appear only after the learner has enough hardware, sensor, and library experience.


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
- pins and wiring
- power/GND
- sensors
- libraries
- basic input/output concepts
- Serial Monitor
- the idea that devices can exchange information

Later I2C submodules may test SDA/SCL, addresses, and device roles only after those ideas have been introduced.
