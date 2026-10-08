# Phase 26b - Lesson 3 Libraries

## Goal
Rebuild Lesson 3 so learners understand why libraries exist before technical C++ details.

## Required Order
1. What is a library?
2. Why are libraries useful?
3. Real-world examples.
4. Find a library.
5. Install a library.
6. Include and use it.
7. Run an example.
8. Modify the example.
9. Meet the library API.
10. Decide when a library is useful.
11. Library challenge.

## Target Submodules
3.1 What Is a Library?
3.2 Libraries in the Real World
3.3 Your First Library
3.4 Find and Install
3.5 Use an Example
3.6 Change the Example
3.7 Meet the Library API
3.8 When Should I Use a Library?
3.9 Library Challenge

## Examples
LCD, servo, sensor, display, motor driver, and communication libraries. Do not force I2C theory into the first explanation.

## Technical Depth
Introduce include statements, library functions, examples, documentation, and beginner API concepts only after the purpose is clear. Advanced C++ implementation details are optional/deferred.

## Activities
Library matching, choosing a library for a project, install/use, run an example, change one value, predict the result, and troubleshoot a missing library.

## Boundary
Coding Foundations owns general programming. Lesson 3 owns reusable Arduino code packages, finding/installing/using libraries, reading examples, and beginner API concepts.

## Validation
No premature C++ overload, no unexplained I2C dependency, working example, age-appropriate vocabulary, and readiness for later device lessons.


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

The Quick Check should diagnose readiness for:
- recognizing reusable tools
- understanding that software can provide reusable functionality
- basic sketch/code familiarity from Coding Foundations
- recognizing examples and documentation
- basic computer workflow from 2B

Do not test advanced C++ before it is taught.
