# 23 Curriculum Structure — Coding Foundations and Lesson 2 Split

## Goal

Restructure the beginning of Monster Lab so learners get programming, app, and IDE foundations before the deeper Arduino lessons.

## New Flow

1. Lesson 1 — What Is Arduino & How Does It Work?
2. Coding Foundations Course
3. Lesson 2A — Monster Lab Walkthrough
4. Lesson 2B — Arduino IDE Walkthrough
5. Lesson 3 — Libraries
6. Lesson 4 — setup() and loop()
7. Lesson 5 — Blink
8. Continue the existing Arduino curriculum.

## Coding Foundations

Create a reusable beginner course covering:

- What code and programs are.
- Statements and instructions.
- Variables and values.
- Operators and comparisons.
- true/false and if/else.
- Functions and parameters.
- Loops and repetition.
- Arduino-specific code basics.
- Code reading and prediction.
- Debugging.
- Building a first small program.

Support a placement assessment so experienced learners can skip material without losing prerequisites.

## Lesson 2A

Teach Monster Lab itself:

- Learn.
- Parts Lab.
- Build Lab.
- Code Lab.
- Challenges.
- Progress and XP.
- Safe hardware workflow.
- Learn → Explore → Build → Code → Test → Troubleshoot → Master.

Use interactive navigation and orientation activities rather than a slideshow.

## Lesson 2B

Teach the Arduino IDE:

- What an IDE is.
- Sketches and the editor.
- Verify and compile.
- Upload.
- Board selection.
- Port selection.
- Serial Monitor.
- Serial Plotter where applicable.
- Libraries.
- Console/errors.
- First upload.
- Common setup and upload failures.

Teach the complete workflow: Write → Verify → Compile → Upload → Run → Observe.

## Integration

Update course/lesson data to support:

- Course IDs.
- Lesson/module ordering.
- Prerequisites.
- Optional courses.
- Placement assessments.
- Completion requirements.
- XP.
- Estimated duration.

Coding Foundations should be reusable by future robotics courses.

## Validation

Test beginner and experienced paths, activity completion, prerequisites, progress persistence, XP idempotency, offline operation, and existing Lessons 1–12.

Run flutter analyze and flutter test plus a complete Android walkthrough.

## Done When

The learner can progress naturally:

Meet Arduino → Learn Coding → Learn Monster Lab → Learn Arduino IDE → Learn Arduino Programming → Build → Code → Test → Troubleshoot → Create.
