# Antigravity 2.0 Multi-Agent Prompt — Phases 23 & 24

You are the lead implementation agent for the Monster Lab Flutter repository:
https://github.com/jakej985-rgb/Monster-Lab

Use Antigravity 2.0's multi-agent workflow to implement **Phase 23 and Phase 24 completely**. Treat the plans as the implementation specification, not suggestions.

## Plans to Implement

### Phase 23
- plan/23 Curriculum Structure - Coding Foundations and Lesson 2 Split.md
- plan/23a Coding Foundations Course.md
- plan/23b Lesson 2A Monster Lab Walkthrough.md
- plan/23c Lesson 2B Arduino IDE Walkthrough.md
- plan/23d Curriculum Integration and Prerequisites.md
- plan/23e Interactive Activities and Assessments.md
- plan/23f Validation and Documentation.md

### Phase 24
- plan/24 Mobile Lesson UX and Immersive Display.md
- plan/24a Responsive Lesson Content and Expandable Visuals.md
- plan/24b Lesson Action Bar and Android System UI.md
- plan/24c Immersive Lesson Setting.md
- plan/24d Mobile UX Validation.md

First inspect the existing architecture, lesson schema, curriculum assets, progress system, settings system, interactive lesson runtime, and current Lesson 1–12 implementation. Do not blindly rewrite working systems.

# Multi-Agent Workstreams

## Agent 1 — Curriculum/Data Architecture
Own Phase 23, 23a, and 23d.

Implement:
- Course/module model support.
- Coding Foundations course.
- Lesson ordering.
- Prerequisites.
- Optional courses.
- Coding placement assessment.
- Curriculum manifest integration.
- Existing curriculum migration/integration.

Do not redesign lesson UI.

## Agent 2 — Coding Foundations Content
Own Phase 23a and relevant 23e work.

Create the standalone beginner course:
1. What Is Code?
2. Variables.
3. Operators and Decisions.
4. Functions.
5. Loops.
6. Arduino Code Basics.
7. Read and Predict Code.
8. Your First Program.

Teach real concepts, not filler. Cover statements, variables, values/types, operators, comparisons, booleans, if/else, functions, parameters, loops, Arduino functions, code reading, prediction, and debugging.

Support:
- New learner → full course.
- Some experience → placement.
- Experienced → placement and possible skip.

## Agent 3 — Lesson 2A
Own Phase 23b.

Implement **Monster Lab Walkthrough**:
- Learn.
- Parts Lab.
- Build Lab.
- Code Lab.
- Challenges.
- Progress/XP.
- Safe hardware workflow.
- Learn → Explore → Build → Code → Test → Troubleshoot → Master.

Use interactive navigation, component identification, workflow simulation, and an orientation challenge. Reuse Phase 22 infrastructure.

## Agent 4 — Lesson 2B
Own Phase 23c.

Implement **Arduino IDE Walkthrough**:
- IDE purpose.
- Sketch/editor.
- Verify.
- Compile.
- Upload.
- Board selection.
- Port selection.
- Serial Monitor.
- Serial Plotter where appropriate.
- Libraries.
- Console/errors.
- First upload.
- Common troubleshooting.

Teach:
**Write → Verify → Compile → Upload → Run → Observe**

Do not assume programming knowledge.

## Agent 5 — Mobile Lesson UX
Own Phase 24 and 24a.

Implement reusable mobile lesson presentation:
- Responsive content.
- Responsive cards.
- Expandable images.
- Expandable diagrams.
- Full-screen viewer.
- Zoom/pan where useful.
- Responsive code blocks.
- No page-wide horizontal overflow.
- Accessibility.
- Offline assets.

Use:
**Inline Preview → Tap to Expand → Full-Screen Viewer → Close/Back**

Do not make Lesson 3-specific hacks. This must work for Lessons 1–12 and future lessons.

## Agent 6 — Android System UI
Own Phase 24b and 24c.

Implement:
- Safe system insets.
- Lesson action bar positioning.
- Gesture navigation support.
- Three-button navigation support.
- Landscape handling.
- Immersive Lesson Mode setting.
- Persisted setting.
- Enter/exit immersive behavior.
- App background/resume handling.
- System UI restoration.

Default:
**Immersive Lesson Mode = OFF**

Normal lesson mode keeps Android system navigation available.

The Next Step button must never be covered by Android navigation controls.

## Agent 7 — QA/Integration
Own Phase 23f and 24d.

Continuously test:
- Course loading.
- Lesson ordering.
- Prerequisites.
- Placement.
- Activity completion.
- Lesson completion.
- Progress persistence.
- XP idempotency.
- Offline behavior.
- Responsive layouts.
- Wide diagrams.
- Long code.
- Image expansion.
- Rotation.
- Gesture navigation.
- Three-button navigation.
- Immersive mode.
- Back navigation.

Run:
`flutter analyze`
`flutter test`

Perform an Android walkthrough when possible.

# Lead Agent Responsibilities

The lead agent must:
1. Inspect before delegating.
2. Read all relevant Phase 21–24 plans.
3. Identify reusable existing systems.
4. Keep workstreams separated to minimize conflicts.
5. Coordinate interfaces between agents.
6. Resolve conflicts intentionally.
7. Integrate curriculum, runtime, UI, settings, and tests.
8. Run the full test suite.
9. Fix integration failures.
10. Review the final diff.
11. Update documentation.
12. Commit and push the final implementation.

# Architecture Rules

Preserve existing architecture unless a change is genuinely required.

- Curriculum remains data-driven.
- Lesson content must not be hard-coded into widgets.
- Interactive activities use reusable schemas/runtime.
- Progress persists.
- Completion is deterministic.
- XP is idempotent.
- Offline-first behavior remains intact.
- Existing Lessons 1–12 continue working.
- Do not create duplicate widget/progress systems.
- Do not replace existing lesson data without a migration path.
- Preserve existing StepType compatibility.

# Teaching Rules

Monster Lab is the teacher.

Do not rely on:
- Teacher instructions.
- Instructor explanations.
- Unanswered prompts requiring an adult.

Use:
**Teach → Show → Try → Predict → Test → Observe → Explain → Troubleshoot → Assess**

Coding must follow:
**Read → Predict → Change → Run → Observe → Explain**

Explain functions, parameters, values, hardware effects, and changes before expecting learners to copy code.

# Mobile Rules

Never allow:
- Clipped text.
- Controls behind Android navigation.
- Unreadable diagrams.
- One code block causing page-wide horizontal scrolling.
- Fixed-width cards overflowing the viewport.

Large visuals must support an expanded viewer.

Code blocks may scroll horizontally internally.

# Immersive Mode Rules

Default OFF.

Normal mode:
- Android navigation visible.
- Safe insets respected.

Enabled mode:
- Hide system navigation where supported.
- Keep lesson controls usable.
- Restore system UI on exit.
- Handle rotation.
- Handle background/resume.
- Affect lesson screens only.

# Technical Accuracy

Verify technical/API behavior before implementation where necessary, especially:
- Arduino IDE behavior.
- Board/port behavior.
- Serial Monitor.
- Flutter system UI/insets.
- Android immersive mode.
- Any new dependency.

Prefer existing project dependencies and Flutter/Dart versions.

# Git Rules

Agents must coordinate through Git carefully.

Before committing:
- Check branch/status.
- Pull/rebase as appropriate.
- Inspect changed files.
- Never overwrite unrelated work.
- Resolve conflicts intentionally.

Suggested commits:
- feat(curriculum): add coding foundations
- feat(lesson): add Monster Lab walkthrough
- feat(lesson): add Arduino IDE walkthrough
- feat(lesson-ui): add responsive visual viewer
- feat(android): add lesson immersive mode
- test(curriculum): validate new course flow
- test(lesson-ui): validate mobile layouts

The lead owns final integration and push.

# Do Not

- Do not delete working curriculum.
- Do not break Lessons 1–12.
- Do not duplicate widgets.
- Do not hard-code lesson-specific UI.
- Do not force immersive mode by default.
- Do not make the whole lesson horizontally scroll.
- Do not add giant unresponsive images.
- Do not make Coding Foundations mandatory for experienced learners.
- Do not skip tests.
- Do not stop at planning; implement the plans.

# Final Curriculum Target

Lesson 1 — Meet Arduino
↓
Coding Foundations — Learn programming
↓
Lesson 2A — Learn Monster Lab
↓
Lesson 2B — Learn Arduino IDE
↓
Lesson 3 — Libraries
↓
Lesson 4 — setup() / loop()
↓
Lesson 5 — Blink
↓
Sensors → Inputs → Outputs → Communication → Motors → Robotics Projects

The learner should understand **why the code works**, not merely copy code.

# Final Acceptance Gate

Do not report completion until:
- Phase 23 is implemented.
- Coding Foundations exists.
- Placement works.
- 2A exists.
- 2B exists.
- Prerequisites work.
- Phase 24 is implemented.
- Large visuals are mobile-friendly.
- Expandable image/diagram viewing works.
- Code blocks are mobile-friendly.
- Lesson actions respect system insets.
- Immersive Lesson Mode exists and defaults OFF.
- Rotation works.
- Existing Lessons 1–12 still work.
- Progress persists.
- XP is not duplicated.
- Offline behavior remains functional.
- `flutter analyze` passes.
- `flutter test` passes.
- Android walkthrough passes as far as the environment permits.
- Documentation is updated.
- Final changes are committed and pushed.

At the end, report:
1. Agents/workstreams used.
2. Features/files changed.
3. Tests run and results.
4. Remaining limitations.
5. Final commit SHA.
6. Confirmation that changes were pushed.
