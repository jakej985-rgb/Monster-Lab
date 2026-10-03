# 22 Interactive Lesson System and Lesson 1 Redesign

## Goal

Turn the Lesson 1 redesign from a text-heavy lesson specification into a reusable interactive learning system for Monster Lab.

Plan 22 covers two connected deliverables:

1. Build reusable schemas and runtime support for interactive lesson activities.
2. Rebuild Lesson 1 around those activities, visuals, guided code learning, and interactive troubleshooting.

The goal is not to create one-off widgets for Lesson 1. The system must be reusable by future lessons.

---

## Core Requirements

- Monster Lab is the teacher.
- Lessons speak directly to the learner.
- Never require a human teacher to explain, ask, or grade lesson content.
- Do not assume rookie learners understand programming syntax.
- Teach concepts before requiring them.
- Prefer interactive learning over large blocks of text.
- Use pictures, diagrams, animations, and component visuals.
- Every interactive activity must have a defined data schema.
- Interactive activities must provide immediate learner feedback.
- Lesson completion must be deterministic and persist reliably.
- Lesson content remains data-driven.
- Runtime widgets must not hard-code Lesson 1-specific behavior.
- Preserve existing six runtime StepType containers for compatibility.

---

# Phase 1 — Audit Existing Lesson Runtime

## Tasks

- Inspect LessonStep model.
- Inspect StepType enum.
- Inspect lesson JSON schema.
- Inspect LessonDetailScreen.
- Inspect current interactiveWidgetType routing.
- Inspect existing BoardInspectorWidget.
- Inspect existing simulator widgets.
- Inspect quiz rendering.
- Inspect lesson completion logic.
- Identify which existing systems can be reused.

## Acceptance Criteria

- Existing runtime behavior is documented.
- Existing schema constraints are known.
- No existing widget is duplicated unnecessarily.
- Plan identifies all required extension points.

---

# Phase 2 — Define Interactive Activity Contract

Create a common activity configuration contract.

## Base Fields

Every interactive activity should support, where applicable:

- activityType
- title
- instructions
- visual/asset references
- interaction state
- feedback
- completion rules
- retry behavior
- accessibility metadata

## Rules

- Activity data is separate from UI implementation.
- Activity IDs must be unique within a lesson.
- Invalid activity configurations must fail validation clearly.
- Activities must support offline operation.

## Acceptance Criteria

A lesson can declare an interactive activity without knowing how its Flutter widget is implemented.

---

# Phase 3 — Implement Visual Flow Diagram Schema

Activity type:

visualFlowDiagram

## Purpose

Teach:

Input → Microcontroller → Program/Decision → Output

## Required Capabilities

- Nodes.
- Connections.
- Node roles.
- Descriptions.
- Optional images.
- Optional animated flow.
- Completion state.

## Lesson 1 Usage

Use in:

- Step 1.
- Step 2.
- Step 7.

## Acceptance Criteria

Learner can visually follow information from an input through the Arduino/program to an output.

---

# Phase 4 — Implement Input/Output Classification

Activity type:

inputOutputClassification

## Purpose

Teach the difference between things that provide information and things that perform actions.

## Required Capabilities

- Input category.
- Output category.
- Component cards.
- Component images.
- Drag/drop or tap classification.
- Correct/incorrect feedback.
- Explanation after each answer.
- Completion tracking.

## Lesson 1 Components

Include:

- Pushbutton.
- Ultrasonic sensor.
- Potentiometer.
- Light sensor.
- LED.
- Buzzer.
- Servo.
- Motor driver.

## Acceptance Criteria

Learner correctly classifies the required components and understands why.

---

# Phase 5 — Build Arduino Board Inspector

Activity type:

arduinoBoardInspector

## Purpose

Teach the physical Arduino Uno layout before wiring.

## Required Board Areas

- USB.
- Power connector.
- Digital pins.
- Analog pins.
- 5V.
- 3.3V.
- GND.
- Reset.
- Built-in LED.

## Interaction

- Tap/click a board region.
- Highlight the selected region.
- Display the component name.
- Explain its purpose.
- Show relevant examples.
- Track discovered areas.

## Acceptance Criteria

The board inspector works without Lesson 1-specific hard-coded logic.

---

# Phase 6 — Build Board Label Drag-and-Drop

Activity type:

boardLabelDragDrop

## Purpose

Allow learners to identify Arduino Uno hardware visually.

## Required Features

- Arduino Uno image.
- Target regions.
- Draggable labels.
- Correct placement validation.
- Incorrect placement feedback.
- Retry.
- Completion state.
- Optional hints.

## Required Labels

- USB.
- Digital Pins.
- Analog Pins.
- 5V.
- 3.3V.
- GND.
- Reset.
- Built-in LED.
- Power.

## Acceptance Criteria

All required labels can be placed correctly before completion.

---

# Phase 7 — Build Circuit and Ground Visualization

Activity types:

circuitDiagram
groundTroubleshooting

## Purpose

Teach complete circuits and why GND matters.

## Required Concepts

- Power path.
- Component.
- Ground/reference.
- Missing ground.
- Loose ground.
- Incorrect ground.
- Shared ground.

## Interactive Scenarios

At minimum include:

1. Correct circuit.
2. Missing ground.
3. Loose ground.
4. Incorrect ground connection.

## Feedback

Explain:

- What is wrong.
- What symptom it causes.
- How to inspect the connection.
- How to correct it.

## Acceptance Criteria

Learner can identify a bad ground and explain why it affects circuit behavior.

---

# Phase 8 — Build Decision Simulator

Activity type:

decisionSimulator

## Purpose

Make the input → program → decision → output process visible.

## Example

Button input:

Pressed → program condition is true → LED ON.

Released → program condition is false → LED OFF.

## Required Features

- Interactive input.
- Condition visualization.
- Decision state.
- Output state.
- Animated signal flow.
- Explanation of each stage.

## Acceptance Criteria

Learner can manipulate the input and observe the programmed output change.

---

# Phase 9 — Build Code Deconstruction Activity

Activity type:

codeDeconstruction

## Purpose

Teach learners to read code before copying it.

## Lesson 1 Example

digitalWrite(13, HIGH);

## Teach Separately

- digitalWrite.
- 13.
- HIGH.
- Semicolon.

## Required Features

- Selectable code parts.
- Highlight selected part.
- Explain selected part.
- Show hardware consequence.
- Use beginner-friendly terminology.
- Do not require prior programming knowledge.

## Acceptance Criteria

Learner can identify what function, pin number, value, and statement terminator mean.

---

# Phase 10 — Build Code Prediction

Activity type:

codePrediction

## Purpose

Teach prediction before execution.

## Required Features

- Code display.
- Multiple predictions.
- Correct answer.
- Explanation.
- Optional simulation.
- Visual hardware result.

## Lesson 1 Example

digitalWrite(13, HIGH);

Prediction:

The built-in LED turns on.

## Acceptance Criteria

Learner commits to a prediction before seeing the simulated result.

---

# Phase 11 — Build Engineering Prediction Experiment

Activity type:

engineeringPrediction

## Purpose

Teach:

Read → Predict → Upload → Observe → Verify → Change → Test.

## Required Features

- Code.
- Prediction choices.
- Simulated execution.
- Expected result.
- Actual result.
- Comparison.
- Explanation.

## Acceptance Criteria

The learner understands that testing verifies a prediction instead of simply proving whether an answer was right.

---

# Phase 12 — Build Real-World System Diagrams

Activity type:

realWorldSystemDiagram

## Purpose

Connect Arduino concepts to real machines.

## Required Examples

- Robot vacuum.
- Automatic door.
- Factory robot.
- Alarm system.
- Smart device.

## Required Flow

Sensor/Input
→ Arduino/Controller
→ Program/Decision
→ Driver
→ Physical Output

## Acceptance Criteria

Learner can trace the information flow through a real-world robotic system.

---

# Phase 13 — Build Interactive Troubleshooting Lab

Activity type:

interactiveTroubleshooting

## Purpose

Teach systematic hardware/software troubleshooting.

## Required Visible Areas

- Arduino board.
- Pins.
- Wiring.
- LED.
- Resistor.
- Power.
- Ground.
- Code.
- Board selection/upload state.

## Fault Categories

- Power.
- Ground.
- Wiring.
- Pin.
- Code.
- Board.
- Component.
- Upload.
- Orientation.

## Diagnostic Process

Observe
→ Form a theory
→ Test
→ Learn

## Learner Actions

Learner can inspect:

- Pins.
- Wires.
- Components.
- Code.
- Power.
- Ground.

## Fault Examples

- LED on wrong pin.
- Code uses wrong pin.
- Missing ground.
- LED reversed.
- Missing resistor.
- Arduino not powered.
- Wrong board selected.
- Code not uploaded.
- Incorrect HIGH/LOW logic.

## Completion

Learner must:

1. Identify the problem.
2. Select the likely fault category.
3. Perform the appropriate diagnostic action.
4. Correct the simulated problem.
5. Explain why the fix works.

## Acceptance Criteria

Troubleshooting teaches diagnosis rather than revealing the answer immediately.

---

# Phase 14 — Build Mini Quiz Activity

Activity type:

miniQuiz

## Purpose

Replace teacher-directed review questions.

## Required Features

- Multiple questions.
- Immediate feedback.
- Explanations.
- Optional images.
- Retry.
- Completion state.

## Lesson 1 Review Topics

- Microcontroller.
- Input.
- Output.
- Pin.
- GND.
- Code.
- HIGH.
- Troubleshooting.

## Acceptance Criteria

Step 12 becomes an actual interactive activity.

---

# Phase 15 — Build Comprehensive Knowledge Check

Activity type:

knowledgeCheck

## Purpose

Assess actual lesson mastery.

## Minimum

8 questions.

## Coverage

- Microcontrollers.
- Inputs.
- Outputs.
- Digital signals.
- Analog signals.
- Power.
- Ground.
- Arduino hardware.
- Pin numbers.
- Code comprehension.
- Code prediction.
- Troubleshooting.

## Requirements

- Correct answer.
- Explanation.
- Optional image/code.
- Passing rules.
- Retry.
- Result state.

## Acceptance Criteria

Assessment content matches concepts actually taught in the lesson.

---

# Phase 16 — Add Common Activity Runtime Infrastructure

Create shared runtime support for:

- Activity loading.
- Activity validation.
- Activity state.
- Completion state.
- Retry.
- Feedback.
- Progress persistence.
- Accessibility.
- Offline operation.
- Error handling.

## Important

Do not build each activity as an isolated system.

Shared behavior belongs in common infrastructure.

---

# Phase 17 — Add Asset and Visual System Support

## Requirements

Support lesson assets for:

- Arduino board images.
- Component images.
- Wiring diagrams.
- Signal-flow diagrams.
- Robot illustrations.
- Troubleshooting diagrams.
- Code illustrations.

## Asset Rules

- Assets must work offline.
- Missing assets must fail gracefully.
- Lesson JSON references assets by stable ID/path.
- Do not hard-code asset paths inside widgets.
- Child-friendly visuals should be the default.

---

# Phase 18 — Rebuild Lesson 1 Content

Use:

plan/22a - Lesson 1.md

as the content specification.

## Step Structure

### Step 1
Monster Brain introduction + visual flow.

### Step 2
Microcontroller architecture + vocabulary + visual flow.

### Step 3
Input/output classification.

### Step 4
Digital vs analog + Arduino board exploration.

### Step 5
Arduino hardware drag/drop.

### Step 6
Power/GND + circuit visualization + bad-ground scenarios.

### Step 7
Decision simulator.

### Step 8
Code deconstruction + prediction.

### Step 9
Trust-but-verify engineering experiment.

### Step 10
Real-world system diagrams.

### Step 11
Interactive troubleshooting lab.

### Step 12
Mini quiz.

### Step 13
Comprehensive knowledge check.

---

# Phase 19 — Remove Teacher-Directed Content

Audit all Lesson 1 content for phrases such as:

- Ask the learner.
- Have the learner.
- Tell the learner.
- Teacher should.
- Instructor should.
- Explain to the learner.

Replace them with actual runtime behavior.

## Rule

Monster Lab is the teacher.

The learner interacts directly with Monster Lab.

---

# Phase 20 — Fix Lesson Markdown Rendering

Lesson content must correctly render:

- Headings.
- Lists.
- Bold text.
- Inline code.
- Code blocks.
- Diagrams.
- Images.
- Interactive activities.

Do not display Markdown syntax as literal text inside lesson cards unless the lesson is specifically teaching Markdown.

## Code

Arduino code must render as a proper code block with syntax highlighting where supported.

---

# Phase 21 — Lesson Timing and Pacing

Recalculate Lesson 1 duration after implementation.

Do not force the original 18-minute estimate.

Measure meaningful interaction time.

Target:

15–25 minutes for a complete rookie lesson.

Ensure time comes from:

- Teaching.
- Exploration.
- Interaction.
- Prediction.
- Experiment.
- Troubleshooting.
- Assessment.

Do not add filler.

---

# Phase 22 — Lesson Data Validation

Extend validation to verify:

- Valid StepType.
- Valid interactiveWidgetType/activityType.
- Required activity fields.
- Valid references.
- Valid quiz indexes.
- Valid target IDs.
- Valid board hotspot IDs.
- Valid diagram connections.
- Valid asset references.
- Valid completion configuration.

Invalid lesson data must produce useful validation errors.

---

# Phase 23 — Automated Tests

Add tests for:

## Schema

- Valid activity configurations.
- Invalid activity configurations.
- Missing required fields.
- Invalid references.

## Runtime

- Activity loads.
- Activity renders.
- Activity state updates.
- Correct answer feedback.
- Incorrect answer feedback.
- Completion.
- Retry.
- Persistence.

## Lesson

- Lesson 1 loads.
- All 13 steps load.
- All activity references resolve.
- No missing assets.
- Quiz answers are valid.
- Completion works.

---

# Phase 24 — Lesson 1 Content QA

Review every step for:

- Child-friendly language.
- Technical correctness.
- No unnecessary jargon.
- Jargon defined before use.
- Visual support.
- Interactive support.
- Direct Monster Lab teaching.
- No teacher instructions.
- Correct code.
- Correct Arduino terminology.
- Correct pin references.
- Correct electrical explanations.

---

# Phase 25 — Hardware Safety Review

Ensure the lesson does not encourage unsafe wiring.

Cover:

- Do not short power to GND.
- Respect board voltage limits.
- Use resistors with LEDs where appropriate.
- Do not drive motors directly from Arduino pins.
- Use motor drivers for motors.
- Check polarity.
- Power down before changing wiring when appropriate.

Safety explanations should be age-appropriate.

---

# Phase 26 — Progress and Completion Integration

Every interactive activity must report completion to the existing lesson progress system.

Completion must survive:

- Navigation away.
- App restart.
- Offline use.
- Reopening the lesson.

Do not allow an activity to visually appear complete while lesson progress remains incomplete.

---

# Phase 27 — Final Lesson 1 Integration

Replace the old Lesson 1 implementation with the expanded version.

Verify:

- 13 steps.
- Interactive activities load.
- Visuals load.
- Code renders correctly.
- Quiz works.
- Troubleshooting works.
- Progress works.
- XP is awarded correctly.
- Lesson completion works.

---

# Phase 28 — Regression Testing

Verify existing lessons still work.

Especially test:

- Existing story steps.
- Existing visualExplanation steps.
- Existing physicalTask steps.
- Existing codeExperiment steps.
- Existing quizCheckpoint steps.
- Existing interactive widgets.
- Lesson completion.
- Progress persistence.

Plan 22 must not break earlier curriculum.

---

# Phase 29 — Documentation

Document:

- Activity schemas.
- Activity registration.
- Widget routing.
- Asset conventions.
- Lesson JSON examples.
- Validation rules.
- Completion reporting.
- How future lessons add interactive activities.

Include one complete example for each activity type.

---

# Phase 30 — Future Lesson Reuse

Ensure all activity systems can be reused by Lessons 2–12 and future curriculum.

Potential reuse:

- Board inspector → all hardware lessons.
- Drag/drop → component identification.
- Circuit diagrams → wiring lessons.
- Decision simulator → programming lessons.
- Code deconstruction → every coding lesson.
- Code prediction → every code experiment.
- Troubleshooting → every build lesson.
- Mini quiz → every lesson review.
- Knowledge check → every lesson assessment.

---

# Definition of Done

Plan 22 is complete when:

- Interactive activity schemas exist.
- Runtime can load schema-driven activities.
- Visual activities work.
- Board inspector works.
- Drag/drop hardware identification works.
- Circuit/ground activities work.
- Decision simulator works.
- Code deconstruction works.
- Code prediction works.
- Engineering prediction works.
- Real-world diagrams work.
- Interactive troubleshooting works.
- Mini quizzes work.
- Knowledge checks work.
- Lesson 1 uses the new system.
- Monster Lab acts as the teacher.
- Teacher-directed instructions are removed.
- Markdown renders correctly.
- Child-friendly visuals are integrated.
- Lesson timing is meaningful.
- Completion persists.
- Validation passes.
- Automated tests pass.
- Existing lessons remain functional.
- Documentation is complete.

## Final Product Goal

Monster Lab should not merely display lessons.

It should function as an interactive teacher that:

Teach → Show → Let the learner try → Ask for a prediction → Simulate/observe → Explain → Let the learner fix mistakes → Check understanding → Record mastery.

Lesson 1 is the first complete demonstration of this architecture.
