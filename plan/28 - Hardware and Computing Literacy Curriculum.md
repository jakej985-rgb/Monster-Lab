# Phase 28 — Hardware and Computing Literacy Curriculum

## Goal

Design and implement a progressive Hardware and Computing learning path containing **16 courses: 8 Basic and 8 Advanced**. The detailed course/page map lives in `plan/28a - Hardware and Computing Literacy Course Map.md` and is part of this phase.

The curriculum must teach learners how hardware works, how to interpret specifications, how to select appropriate boards and components, and how computing resources affect robotics, AI, and advanced reasoning workloads.

The Basic track belongs early in the Monster Lab curriculum. The Advanced track builds on the Basic track and introduces PC architecture, performance analysis, AI hardware, local inference, and demanding computing workloads.

Every course must contain at least **5 substantive instructional pages and one end-of-course quiz**.

## Core Principles

1. Introduce concepts before requiring learners to use them.
2. Progress from concrete examples to technical explanations, guided practice, and independent application.
3. Teach hardware selection through evidence and tradeoffs, not memorization.
4. Explain specifications in terms of what they enable, limit, or cost.
5. Distinguish microcontrollers, single-board computers, and desktop PCs.
6. Treat CPU, GPU, NPU, memory, power, cooling, software, and cost as parts of one system.
7. Provide optional physical experiments where hardware is available, with meaningful digital alternatives where practical.
8. Preserve existing lesson/course IDs, learner progress, and completion records.
9. Reinforce concepts later only when the learner applies them at greater depth.
10. Keep content age-appropriate while allowing progression based on demonstrated readiness.

## Curriculum Structure

### Basic Track — 8 Courses

1. **Meet the Machine** — computers, boards, chips, hardware/software, inputs/outputs, and instructions.
2. **Pins, Signals & Safe Connections** — pinouts, digital and analog signals, PWM, voltage, current, power, and electrical limits.
3. **Understanding Hardware Specifications** — clock rates, cores, RAM, storage, capacity, bandwidth, and spec-sheet interpretation.
4. **Meet the Boards** — Arduino, ESP32, Raspberry Pi, microcontrollers versus general-purpose computers, compatibility, and software support.
5. **Sensors, Inputs & Outputs** — sensing, measurements, digital/analog readings, thresholds, actuators, calibration, and troubleshooting.
6. **Powering Real Projects** — voltage/current requirements, batteries, power budgets, runtime, heat, protection, and safe power plans.
7. **Matching Hardware to a Job** — requirements, specifications, compatibility, candidate comparisons, cost/complexity/power tradeoffs, and justification.
8. **Hardware Builder Challenge** — integrated project brief, board selection, I/O plan, power/safety plan, design review, and final defense.

### Advanced Track — 8 Courses

1. **Inside the PC** — CPU, GPU, RAM, VRAM, storage, motherboard, cooling, compatibility, and system-level performance.
2. **Measuring Performance** — latency, throughput, clock speed, architecture, parallel workloads, benchmarks, bandwidth, and bottlenecks.
3. **Parallel Computing** — serial versus parallel work, CPU threads/cores, GPU workloads, scaling, specialized accelerators, and workload matching.
4. **AI Hardware: CPU, GPU & NPU** — inference, accelerators, TOPS limitations, supported operations, memory requirements, and platform comparison.
5. **Understanding AI Models** — parameters, model size, context, quantization, inference speed, capability/cost tradeoffs, and feasibility estimates.
6. **Local AI & Edge Computing** — local versus cloud, edge deployment, platform/runtime support, power/thermal constraints, AI pipelines, and testing.
7. **Advanced Reasoning Workloads** — task characteristics, model capability versus hardware, context/memory demands, latency, bottlenecks, and resource planning.
8. **Systems Architect Challenge** — system requirements, architecture, compute/memory, power/cooling, compatibility/cost, test plans, and design defense.

The detailed page-level learning objectives, activities, and missions for all 16 courses are specified in the companion course map.

## Shared Course Standard

Every course must have:

- At least five substantive instructional pages; additional pages are encouraged when needed.
- Clear course-level learning objectives and prerequisites.
- Age-appropriate vocabulary and explanations.
- Visuals or worked examples where they improve understanding.
- Meaningful interactive or guided practice, not decorative interactions.
- A practical mission or application activity.
- One end-of-course quiz mapped to the stated learning objectives.
- Feedback for quiz answers and opportunities to retry and review.
- Documented completion criteria.
- A digital alternative for hardware-dependent activities where practical.
- Appropriate safety notes for electrical, battery, motor, and power activities.

Five pages is a minimum, not a target that should cause padding. Splitting one short explanation across several pages does not satisfy the requirement.

## Assessment and Progression

Every course must include an end-of-course quiz. The quiz is distinct from any optional pre-lesson Quick Check.

Quiz requirements:

- Test concepts actually taught in the course.
- Include both understanding and practical reasoning.
- Use plausible answer choices, accurate answer keys, and meaningful feedback.
- Cover core objectives rather than isolated trivia.
- Support retries and review of missed concepts.
- Record quiz results separately from lesson completion and mastery.
- Never award normal lesson-completion XP solely for taking a quiz.

**Decision required before implementing score-based gates:** define the passing threshold and whether passing is required to unlock a later course. Do not introduce new progression barriers until this is explicitly decided. Preserve the current optional Quick Check policy: bypassing a diagnostic does not block instruction or imply failure.

## Prerequisites and Placement

The course sequence must be based on a dependency map, not numbering alone.

The Basic track establishes:
- Core hardware and computing vocabulary.
- Hardware/software and input/output concepts.
- Safe electrical practices and pinout interpretation.
- Specification reading.
- Board and component compatibility.
- Sensor/output behavior.
- Power budgeting and hardware selection.

The Advanced track must build on the appropriate foundations before introducing PC performance engineering, parallel computing, AI accelerators, model requirements, local AI, and advanced workload planning.

Audit the existing curriculum before implementation. Reuse and improve relevant lessons where appropriate; do not create duplicate courses merely because a topic appears in this proposal. Existing stable IDs and learner progress must be preserved. Use explicit display order or additive migrations rather than silently renaming or reordering stable IDs.

## Implementation Phases

### Phase 28.1 — Discovery and Existing-Content Audit
- Read the current curriculum, manifests, lesson/course schemas, prerequisite rules, navigation, and progress implementation.
- Map existing lessons to the 16 proposed courses.
- Identify reusable material, missing content, duplicate coverage, and prerequisite conflicts.
- Check the current Phase 27 audit findings and approved curriculum order.
- Do not destructively edit content during discovery.

**Deliverable:** existing-to-target content map, gap report, prerequisite risks, and stable-ID migration notes.

### Phase 28.2 — Curriculum Architecture
- Approve the 16 course identities and their learning objectives.
- Define prerequisites and the dependency graph.
- Define course, page, activity, and quiz ID conventions.
- Decide where the Basic track appears in the early learner sequence and how Advanced unlocks or becomes available.
- Resolve quiz passing and progression behavior before implementing score-based gating.

**Deliverable:** authoritative curriculum architecture and progression decision record.

### Phase 28.3 — Course Specifications
- Turn the companion map into implementation-ready page outlines.
- Define learning objectives, vocabulary, visuals, interactions, missions, safety notes, and quiz coverage.
- Identify which activities require physical hardware and which have digital alternatives.
- Check that every page introduces only concepts already taught or explicitly explains new concepts.

**Deliverable:** validated page-level specifications for all 16 courses.

### Phase 28.4 — Implement and Validate the Basic Track
- Implement Basic Courses 1–8 in prerequisite order.
- Reuse suitable existing content and preserve stable IDs/progress.
- Implement the minimum five substantive pages and quiz for every course.
- Validate content, interactions, navigation, and assessment before beginning the Advanced track.

**Deliverable:** complete, validated Basic track.

### Phase 28.5 — Implement and Validate the Advanced Track
- Implement Advanced Courses 1–8 in dependency order.
- Teach PC architecture and performance before specialized AI hardware and workload decisions.
- Ensure AI model requirements follow the relevant hardware foundations.
- Ensure advanced reasoning lessons distinguish model capability from hardware capacity.
- Implement the minimum five substantive pages and quiz for every course.

**Deliverable:** complete, validated Advanced track.

### Phase 28.6 — Integration, Migration, and QA
- Update course manifests, navigation, prerequisites, indexes, and references.
- Preserve existing IDs and learner progress; prefer additive migrations.
- Validate quiz keys, feedback, objective coverage, page counts, asset references, and schemas.
- Run curriculum-loader, prerequisite, completion, quiz/progress, migration, and relevant app tests.
- Perform mobile-layout and age-appropriateness reviews.
- Review the full 16-course path for forward dependencies, unexplained vocabulary, duplication, and unnecessary repetition.

**Deliverable:** integrated curriculum and QA report with resolved blockers.

## Definition of Done

- Exactly 8 Basic courses and 8 Advanced courses are defined.
- Every course has objectives, prerequisites, and documented completion criteria.
- Every course contains at least 5 substantive instructional pages.
- Every course has a functioning end-of-course quiz.
- The companion course map agrees with the implemented course content.
- Advanced courses build on the appropriate Basic and intermediate foundations.
- Digital alternatives exist for hardware-dependent activities where practical.
- Quiz results remain separate from lesson completion and mastery.
- Any score-based progression rule is explicitly approved before implementation.
- Existing stable IDs and learner progress are preserved.
- Course manifests, navigation, schemas, assets, and relevant tests pass.
- The full curriculum receives a final prerequisite and pedagogical audit.

## Execution Rule

Do not implement all 16 courses as one unreviewed batch. Complete discovery and architecture first, validate the Basic track before implementing the Advanced track, and run integration/QA across the full curriculum. Resolve curriculum and assessment decisions before introducing irreversible data or progression changes.
