# 25 Curriculum Guardian Audit and Governance

## Goal

Use the permanent **Curriculum Guardian** agent to perform a full curriculum audit of Monster Lab so the plans created so far agree with each other, remain appropriate for the 6+ target audience, and form one correct learning path.

This is a **double-check and reconciliation phase**, not a reason to rewrite good work unnecessarily.

The audit must cover the existing roadmap, the expanded lesson specifications, the new Coding Foundations/2A/2B structure, interactive lesson requirements, mobile lesson UX, prerequisites, timing, safety, and technical accuracy.

## Guardian

Primary reviewer:

`.agents/agents/curriculum-guardian/agent.md`

The Curriculum Guardian is the authority for:

- Age appropriateness.
- Reading level.
- Cognitive load.
- Vocabulary progression.
- Learning quality.
- Hands-on learning.
- Assessment quality.
- Code comprehension.
- Prerequisites.
- Lesson timing.
- Safety.
- Technical accuracy.
- Difficulty progression.
- Curriculum consistency.

Use Antigravity 2.0 subagents for large review areas instead of having one reviewer perform every check serially.

## Audit Scope

Review the current repository plans as one connected curriculum system.

### Foundational Roadmap

Review:

- `plan/00` through `plan/18`.

Check that the original product roadmap still agrees with the newer curriculum architecture.

### Reliability and Content Expansion

Review:

- `plan/19` Lesson Completion and Progress Reliability.
- `plan/20` Parts Lab Pictures and Component Visuals.
- `plan/21` Lesson Content Expansion and 15–20 Minute Learning Modules.
- `plan/21a` through `plan/21l` lesson blueprints.
- `plan/22` Interactive Lesson System and Lesson 1 Redesign.
- `plan/22a` and related Lesson 1 specifications where present.

### Curriculum Restructure

Review:

- `plan/23` Curriculum Structure.
- `plan/23a` Coding Foundations.
- `plan/23b` Lesson 2A.
- `plan/23c` Lesson 2B.
- `plan/23d` Curriculum Integration and Prerequisites.
- `plan/23e` Interactive Activities and Assessments.
- `plan/23f` Validation and Documentation.

### Mobile Lesson Experience

Review:

- `plan/24` Mobile Lesson UX and Immersive Display.
- `plan/24a` Responsive Lesson Content and Expandable Visuals.
- `plan/24b` Lesson Action Bar and Android System UI.
- `plan/24c` Immersive Lesson Setting.
- `plan/24d` Mobile UX Validation.

### Agent Governance

Review:

- `.agents/agents/curriculum-guardian/agent.md`.

Confirm that the agent itself accurately reflects the curriculum standards established by the current plans.

## Critical Reconciliation

The audit must explicitly resolve differences between older and newer plans.

### Lesson 2

Older curriculum specifications may describe Lesson 2 as the Monster Lab station/setup lesson.

The current intended structure is:

1. Lesson 1 — What Is Arduino & How Does It Work?
2. Coding Foundations Course — optional/placement-based.
3. Lesson 2A — Monster Lab Walkthrough.
4. Lesson 2B — Arduino IDE Walkthrough.
5. Lesson 3 — Libraries.
6. Lesson 4 — setup() and loop().
7. Lesson 5 — Blink.
8. Continue the Arduino curriculum.

The Guardian must identify every place where the old Lesson 2 structure conflicts with this newer structure.

Do not silently preserve two competing definitions.

### Lesson Numbering

Check every reference to:

- Lesson IDs.
- Lesson titles.
- Prerequisites.
- XP.
- Duration.
- Component references.
- Next lesson.
- Previous lesson.
- Assessment references.

Flag stale references rather than guessing which one should win.

### Coding Foundations

Verify that Coding Foundations is truly reusable and does not create circular prerequisites.

The placement model must support:

- New learner → complete foundations.
- Some experience → placement assessment.
- Experienced learner → assessment and possible skip.
- Successful placement → prerequisite equivalence.
- Skipping → no missing prerequisite knowledge.

### Lesson 3+

Verify that Arduino lessons apply programming concepts instead of repeatedly reteaching the entire Coding Foundations course.

Use the smallest necessary bridge when a prerequisite is missing.

## Age and Difficulty Audit

Monster Lab is **6+**, but not every lesson should be written at the same depth.

Validate the intended progression:

### Rookie — approximately 6–8

- Concrete explanations.
- Strong visuals.
- Short text blocks.
- Guided interaction.
- Simple code.
- Frequent feedback.
- Limited simultaneous concepts.

### Builder — approximately 9–11

- More independent reasoning.
- More technical detail.
- Longer code examples.
- More troubleshooting.
- Less hand-holding.

### Engineer — approximately 12+

- Formal terminology.
- Deeper technical explanations.
- System reasoning.
- Tradeoffs.
- Experiment design.
- Independent debugging.

Flag material that is too advanced for its assigned tier without scaffolding.

Do not remove technically important material merely because it is difficult.

## Reading and Vocabulary Audit

For every foundational lesson check:

- New vocabulary is explained before or when needed.
- Definitions use understandable language.
- Jargon is not stacked unnecessarily.
- Sentences are manageable for the target age.
- Instructions do not contain too many actions at once.
- Important concepts have concrete examples.
- Visual support is used where prose alone is weak.

Track important terms across lessons, including:

- code.
- program.
- variable.
- function.
- parameter.
- microcontroller.
- pin.
- voltage.
- current.
- resistor.
- sensor.
- actuator.
- PWM.
- library.
- I2C.
- SPI.
- UART.

## Learning Quality Audit

Every lesson should answer:

1. What are we learning?
2. What part or system are we using?
3. How does it work?
4. What should happen?
5. What do we predict?
6. What happened?
7. What can we change?
8. Can we explain why?

Validate the learning loop:

**Learn → Build → Test → Change → Explain**

Do not approve lessons that are mostly reading followed by recall questions.

## Code Comprehension Audit

For every meaningful code example verify:

- The purpose of the program is explained.
- Important lines are explained.
- Functions are explained.
- Parameters are explained.
- Important values are explained.
- Pin behavior is explained.
- Hardware consequences are explained.
- The learner predicts behavior before execution.
- The learner changes something safely.
- The learner observes the result.
- The learner explains why the result occurred.

Use the required loop:

**Read → Predict → Change → Run → Observe → Explain**

Flag copy/paste-only instruction.

## Interactive Activity Audit

Verify that the Phase 22 activity infrastructure and Phase 23 activities agree.

Check:

- Activity schemas.
- Runtime step types.
- Interactive widget routing.
- Completion behavior.
- Immediate feedback.
- Accessibility metadata.
- Offline behavior.
- Lesson progress integration.

Activities should be data-driven rather than hardcoded to individual lessons when the behavior is reusable.

## Assessment Audit

Check that assessments measure what the lesson actually teaches.

Prefer:

- Prediction.
- Code reading.
- Application.
- Troubleshooting.
- Workflow decisions.
- Wiring decisions.
- Cause/effect reasoning.

Avoid making vocabulary recall the primary assessment.

Check that learners receive enough information and practice to answer the assessment fairly.

## Timing Audit

Validate every advertised lesson duration.

Meaningful time includes:

- Reading.
- Visual exploration.
- Thinking.
- Prediction.
- Interactive practice.
- Hands-on work.
- Troubleshooting.
- Assessment.
- Review.

Do not count filler.

Flag:

- Lessons substantially shorter than advertised.
- Lessons substantially longer than advertised.
- Activities that are unrealistic for the target age.
- Timing that assumes hardware access when the lesson is supposed to work without hardware.

The 15–20 minute target is a useful baseline, not permission to add filler.

## Lesson Order and Learning Sequence Audit

The Curriculum Guardian must independently evaluate whether the **order of the curriculum makes educational sense**, not merely whether every prerequisite is technically present.

Do not assume the current order is correct just because it is documented.

For every course and lesson, ask:

1. What does the learner need to know before this?
2. Was that knowledge actually taught earlier?
3. Is the learner ready for the amount of new information being introduced?
4. Is this the right point to introduce this concept?
5. Would another lesson or activity make this easier first?
6. Does the learner get enough practice before the next concept builds on it?
7. Does the sequence move from concrete to abstract and simple to complex?
8. Does it move from recognition → understanding → guided practice → independent application?
9. Does hardware knowledge appear before the learner is expected to use that hardware?
10. Does programming knowledge appear before code requires it?
11. Are communication protocols introduced only after the learner understands the concepts they depend on?
12. Are troubleshooting skills introduced before troubleshooting becomes a major expectation?
13. Are assessments placed after the material and practice they assess?
14. Are build projects introduced only after the learner has the skills needed to complete them safely?
15. Does the sequence avoid unnecessary repetition while still providing useful reinforcement?

### Sequence Principles

Prefer progression such as:

**Orient → Understand → Explore → Practice → Apply → Troubleshoot → Create**

And where appropriate:

**Concrete → Visual → Interactive → Conceptual → Code → Hardware → Independent Challenge**

Flag sequences that:

- Introduce advanced terminology before its foundations.
- Ask learners to use code concepts before they have learned them.
- Ask learners to wire hardware before understanding the relevant component.
- Introduce a library before explaining why it is needed.
- Introduce `setup()`/`loop()` before learners understand basic program flow.
- Introduce motors before motor-driver safety and control concepts.
- Introduce I2C/SPI/UART before the learner has enough understanding of communication and pins.
- Introduce complex troubleshooting before learners have learned a systematic diagnostic process.
- Test a concept before meaningful instruction and practice.
- Place a project before its required skills.
- Create large jumps in difficulty between adjacent lessons.
- Repeat a concept unnecessarily instead of building on it.
- Leave long gaps between teaching a concept and requiring it.

### Recommended Sequence Review

The Guardian must explicitly review the current early sequence:

1. Lesson 1 — What Is Arduino & How Does It Work?
2. Coding Foundations Course — placement-based.
3. Lesson 2A — Monster Lab Walkthrough.
4. Lesson 2B — Arduino IDE Walkthrough.
5. Lesson 3 — Libraries.
6. Lesson 4 — `setup()` and `loop()`.
7. Lesson 5 — Blink.
8. Continue the Arduino curriculum.

The Guardian may recommend changing this order if the evidence shows a better learning progression.

If a change is recommended, explain:

- Current order.
- Proposed order.
- Why the change improves learning.
- What prerequisite relationship caused the change.
- What existing plans/references must be updated.
- Whether the change affects learner progress or IDs.

### Sequence Approval

The curriculum cannot receive final approval until the Guardian confirms:

- The lesson order is pedagogically coherent.
- Each lesson prepares the learner for the next meaningful concept.
- No major prerequisite is taught too late.
- Difficulty increases at a reasonable rate.
- Practice occurs before independent application.
- Assessments occur after instruction and practice.
- Projects occur after the skills they require.
- The overall path makes sense to a new learner.

## Prerequisite Graph Audit

Build a complete dependency graph for the current curriculum.

Check:

- Course prerequisites.
- Lesson prerequisites.
- Placement-equivalent prerequisites.
- Programming concepts.
- Hardware concepts.
- Communication protocols.
- Required component knowledge.
- Assessment prerequisites.

Look specifically for:

- Missing prerequisites.
- Circular prerequisites.
- Prerequisites introduced after first use.
- Duplicate prerequisite requirements.
- Lessons that require knowledge only taught much later.
- Experienced learners being unnecessarily blocked.

## Technical Accuracy Audit

Verify curriculum claims against authoritative technical documentation where needed.

Pay particular attention to:

- Arduino behavior.
- ATmega328P fundamentals.
- Pin modes.
- Digital input/output.
- Analog input.
- PWM.
- Timing.
- Serial communication.
- I2C.
- SPI.
- UART.
- Electrical limits.
- Motor control.
- Pull-up logic.
- Libraries.

Age-appropriate wording must not become technically false.

## Safety Audit

For every hardware lesson check:

- Power safety.
- Voltage/current guidance.
- Short-circuit prevention.
- Polarity.
- Motors and moving parts.
- Motor drivers.
- Batteries.
- Heat.
- Tools.
- Soldering.
- Adult supervision where required.

Clearly distinguish:

- Safe learner activity.
- Adult-supervised activity.
- Advanced activity.

A safety blocker stops approval.

## Visual and Mobile Learning Audit

Cross-check the curriculum content against Phase 24.

Verify that lessons requiring detailed visuals provide an appropriate visual strategy:

**Inline Preview → Tap to Expand → Full-Screen Viewer**

Check:

- Component images.
- Wiring diagrams.
- Signal-flow diagrams.
- Code presentation.
- Accessibility descriptions.
- Offline assets.
- Wide-content behavior.
- Mobile readability.

Do not force detailed diagrams to become unreadably small.

## Findings Classification

Use the Curriculum Guardian severity model:

### BLOCKER

Cannot ship.

Examples:

- Unsafe instruction.
- Fundamentally incorrect technical information.
- Critical prerequisite failure.
- Broken learning path.
- Assessment cannot be completed from the lesson.

### HIGH

Major revision required.

Examples:

- Severe cognitive overload.
- Major age mismatch.
- Large prerequisite gap.
- Unrealistic duration.
- Critical code concept missing.

### MEDIUM

Correct before final curriculum approval.

Examples:

- Unexplained jargon.
- Weak practice.
- Missing useful visual.
- Dense instructions.
- Recall-heavy assessment.

### LOW

Quality improvement.

Examples:

- Wording cleanup.
- Minor repetition.
- Optional visual enhancement.

## Audit Deliverables

The Curriculum Guardian review must produce:

### 1. Master Curriculum Report

Include:

- Current intended curriculum order.
- Age/difficulty progression.
- Course structure.
- Lesson structure.
- Prerequisite graph.
- Timing summary.
- Safety status.
- Technical accuracy status.
- Interactive activity status.
- Assessment status.
- Mobile/visual requirements.

### 2. Conflict Register

List every contradiction found between plans.

For each conflict include:

- Source plan.
- Conflicting requirement.
- Current intended behavior.
- Required correction.
- Severity.

### 3. Curriculum Gap Register

List missing curriculum capabilities.

Examples:

- Missing prerequisite.
- Missing vocabulary introduction.
- Missing visual.
- Missing hands-on activity.
- Missing assessment.
- Missing safety guidance.
- Missing timing support.

### 4. Correction Plan

Group corrections into:

- Must fix before implementation.
- Must fix during implementation.
- Can fix after implementation.

Do not rewrite unaffected plans.

### 5. Approval Matrix

Give each major curriculum area one state:

- APPROVED
- APPROVED WITH REVISIONS
- REVISION REQUIRED
- BLOCKED

## Antigravity 2.0 Review Strategy

For a full audit, use focused subagents in parallel.

Recommended reviewers:

1. **Age & Reading**
   - 6+ comprehension.
   - Vocabulary.
   - Reading load.

2. **Cognitive Load & Learning**
   - Lesson size.
   - Concept sequencing.
   - Practice spacing.

3. **Curriculum Architecture**
   - Course order.
   - Lesson IDs.
   - Prerequisites.
   - Placement.

4. **Technical & Code**
   - Arduino accuracy.
   - Code correctness.
   - Hardware behavior.

5. **Assessment & Interaction**
   - Activities.
   - Prediction.
   - Troubleshooting.
   - Knowledge checks.

6. **Safety**
   - Electrical and physical safety.

7. **Timing**
   - Meaningful duration.

8. **UX/Visual Learning**
   - Images.
   - Diagrams.
   - Mobile presentation.
   - Accessibility.

The lead agent consolidates findings.

Reviewers report findings only.

The lead agent owns approved changes.

Do not allow multiple reviewers to independently rewrite the same curriculum files.

## Correction Rules

When conflicts are found:

1. Prefer the newest explicit curriculum decision when it clearly supersedes an older plan.
2. Preserve technically correct material that is still valid.
3. Do not duplicate lessons merely because older plans contain both versions.
4. Keep lesson IDs stable unless there is a strong reason to migrate them.
5. Update stale references instead of maintaining competing definitions.
6. Preserve reusable activity architecture.
7. Preserve offline-first requirements.
8. Preserve the 6+ progressive difficulty model.
9. Do not add filler to satisfy duration targets.
10. Do not simplify technical material into inaccuracies.

## Regression Checks

After corrections:

- Validate curriculum data.
- Validate prerequisite resolution.
- Validate lesson ordering.
- Validate XP/completion behavior.
- Validate interactive activity schemas.
- Validate lesson references.
- Validate component references.
- Validate mobile lesson requirements.
- Run `flutter analyze`.
- Run `flutter test`.
- Run the curriculum validation script when available.
- Manually verify Lessons 1–5.
- Manually verify the Coding Foundations path.
- Manually verify 2A and 2B.
- Verify at least one later Builder/Engineer lesson.

## Definition of Done

Phase 25 is complete when:

- Curriculum Guardian has reviewed the current curriculum plans.
- Existing plans 00–24 have been checked as one system.
- Lesson 2 conflicts are resolved.
- Coding Foundations placement is validated.
- The prerequisite graph is consistent.
- Age/difficulty progression is approved.
- Lesson timing is realistic.
- Code comprehension requirements are consistent.
- Interactive activities align with runtime architecture.
- Assessments test understanding.
- Safety requirements are complete.
- Technical claims are verified.
- Mobile/visual requirements are consistent.
- All significant conflicts have an explicit resolution.
- Required corrections are captured in follow-up plans.
- No competing curriculum definitions remain.

## Permanent Governance Rule

After Phase 25, Curriculum Guardian becomes a required curriculum gate.

Run it whenever a change affects:

- A lesson.
- A course.
- A prerequisite.
- A difficulty tier.
- A lesson duration.
- A coding concept.
- A hardware concept.
- An assessment.
- Safety instructions.
- Major interactive activity changes.
- Curriculum ordering.

The goal is continuous protection of the curriculum, not a one-time audit.

## Final Standard

Monster Lab must remain:

**Accurate + Comprehensive + Understandable + Age-Appropriate + Interactive**

The final question is:

> Can the intended learner understand it, use it, experiment with it, troubleshoot it, and explain what happened?
