# Phase 28a — Hardware and Computing Literacy Course Map

## Purpose

This document is the page-level companion to `plan/28 - Hardware and Computing Literacy Curriculum.md`. It describes the intended learning experience for all 16 courses: 8 Basic and 8 Advanced.

Every course must contain at least **5 substantive instructional pages and an end-of-course quiz**. The page counts below are planning estimates, not hard limits. Add pages when needed to teach safely and clearly; never pad a course to hit a count.

## Shared Teaching Pattern

Where appropriate, each course should progress through:
1. **Introduce:** concrete question, visual, and vocabulary.
2. **Explain:** teach the concept with a clear example.
3. **Demonstrate:** work through a diagram, comparison, or scenario.
4. **Practice:** learner makes a prediction, classification, configuration, or diagnosis.
5. **Apply:** mission that combines the concepts.
6. **Assess:** end-of-course quiz aligned to the objectives.

Interactions must teach something. Physical experiments should have meaningful digital alternatives where practical. The quiz is separate from an optional pre-lesson Quick Check.

---

# Basic Track

## Basic 1 — Meet the Machine

**Goal:** Understand what a computer is, what its parts do, and how software makes hardware act.

**Prerequisites:** None.

**Estimated structure:** 6 instructional pages + quiz.

### Page 1 — What Is a Computer?
- Explain that computers receive information, process instructions, and produce results.
- Compare a desktop PC, phone, Arduino, and robot.
- **Activity:** Sort examples into computing devices and non-computing devices; discuss examples that do not fit an overly simple rule.

### Page 2 — Hardware vs. Software
- Distinguish physical components from programs and instructions.
- **Activity:** Match code, a processor, an LED, and a sensor to their roles in a working robot.

### Page 3 — Meet the Board
- Identify a processor, USB connection, power connection, pins, and visible components on a development board.
- **Activity:** Interactive board diagram with selectable hotspots.

### Page 4 — Inputs and Outputs
- Explain how a button provides input and an LED provides output.
- **Activity:** Connect virtual inputs to appropriate outputs in a simple robot scenario.

### Page 5 — From Instructions to Action
- Trace a simple sequence: read a button, make a decision, and turn on a light.
- **Activity:** Arrange instruction cards in a logical order.

### Page 6 — Build a Mental Model
- Connect processor, inputs, outputs, power, and program into one system.
- **Mission:** Diagnose a robot that has power but does not respond to a button.

### End-of-Course Quiz
Assess:
- Computing device and component identification.
- Hardware/software distinctions.
- Input/output roles.
- The path from instruction to physical action.

---

## Basic 2 — Pins, Signals & Safe Connections

**Goal:** Read pinouts and understand what can safely connect to a board.

**Prerequisites:** Basic 1, or equivalent introductory knowledge.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — Reading Pin Labels
- Find digital, analog, power, ground, and communication pins on a board diagram.
- **Activity:** Locate pins on an interactive board.

### Page 2 — Digital Signals
- Explain HIGH and LOW as logical states; note that the corresponding electrical levels depend on the board.
- **Activity:** Interpret button and LED states.

### Page 3 — Analog Inputs
- Explain how an analog-to-digital converter (ADC) turns a varying input voltage into a numeric reading.
- **Activity:** Move a virtual sensor slider and observe changing readings.

### Page 4 — PWM Explained
- Explain how rapidly switching a digital output can approximate adjustable output for supported loads.
- **Activity:** Change virtual LED brightness and observe the duty-cycle concept.

### Page 5 — Voltage and Current
- Distinguish voltage from current and explain why component ratings matter.
- **Activity:** Identify incompatible electrical connections in sample diagrams.

### Page 6 — Power, Ground, and Pin Limits
- Trace supply and ground connections.
- Explain per-pin and total current limits, and why limits must be checked in the actual board documentation.
- **Activity:** Inspect a wiring diagram for safety problems.

### Page 7 — Read a Pinout for a Job
- Select suitable pins for a button, sensor, and output using an actual board's documentation.
- **Mission:** Produce a safe connection layout and explain the choices.

### End-of-Course Quiz
Assess:
- Pinout interpretation.
- Digital versus analog concepts.
- PWM purpose.
- Voltage/current distinctions.
- Board-specific safety and connection limits.

**Accuracy note:** Use the actual limits for each board taught. A 5 V Arduino and a 3.3 V ESP32 are not electrically interchangeable.

---

## Basic 3 — Understanding Hardware Specifications

**Goal:** Read specification sheets without assuming bigger numbers always mean better performance.

**Prerequisites:** Basic 1; Basic 2 recommended.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — What Is a Specification?
- Explain why manufacturers publish measurable capabilities and limits.
- **Activity:** Match project requirements to relevant specification fields.

### Page 2 — Clock Speed
- Explain clock cycles and why MHz/GHz alone cannot predict overall performance.
- **Activity:** Compare hypothetical processors with different clock rates and other differing characteristics.

### Page 3 — Cores and Processing Work
- Explain the role of cores and why additional cores help some workloads more than others.
- **Activity:** Assign independent jobs to available workers and discuss coordination.

### Page 4 — RAM vs. Storage
- Compare working memory with longer-term storage.
- **Activity:** Sort tasks by their memory and storage needs.

### Page 5 — Capacity vs. Speed
- Distinguish capacity, bandwidth, and latency.
- **Activity:** Choose a system for a workload that exceeds available memory.

### Page 6 — Read a Real Spec Sheet
- Interpret processor model, RAM, storage, connectivity, and power information.
- **Activity:** Find specified facts in a sample product sheet.

### Page 7 — Compare Two Systems
- Weigh multiple specifications against a stated task.
- **Mission:** Recommend a machine for a classroom robot project and justify the tradeoffs.

### End-of-Course Quiz
Assess:
- Specification terminology.
- Clock speed and core-count interpretation.
- RAM/storage distinctions.
- Capacity, bandwidth, and latency.
- Evidence-based comparison of systems.

---

## Basic 4 — Meet the Boards

**Goal:** Understand why different computing boards exist and when each is useful.

**Prerequisites:** Basic 1–3.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — One Name, Different Machines
- Introduce microcontrollers, single-board computers, and desktop computers.
- **Activity:** Classify devices by role and capability.

### Page 2 — Arduino and Microcontrollers
- Explain dedicated control, direct hardware interaction, and simple predictable tasks.
- **Activity:** Match control tasks to a microcontroller scenario.

### Page 3 — ESP32 and Connectivity
- Explore integrated Wi-Fi/Bluetooth on supported variants and tradeoffs for connected projects.
- **Activity:** Choose between wired and wireless communication for a project brief.

### Page 4 — Raspberry Pi and General-Purpose Computing
- Introduce operating systems, multitasking, storage, and richer software environments.
- **Activity:** Identify which requirements call for general-purpose computing.

### Page 5 — Pins, Peripherals, and Compatibility
- Compare GPIO, ADC, PWM, communication interfaces, and electrical limits.
- **Activity:** Check a board against a set of sensor/output requirements.

### Page 6 — Software Support Matters
- Compare programming environments, libraries, drivers, and setup complexity.
- **Activity:** Identify a software compatibility risk in a proposed build.

### Page 7 — Choose Your Platform
- Compare boards against requirements for a remote sensor, a small robot, and a camera-based project.
- **Mission:** Select one platform for a battery-powered sensor robot and another for computer vision, justifying both choices.

### End-of-Course Quiz
Assess:
- Platform categories and strengths.
- Microcontroller versus general-purpose computing.
- Connectivity and peripheral support.
- Software compatibility.
- Project-based board selection.

---

## Basic 5 — Sensors, Inputs & Outputs

**Goal:** Understand how a computer observes and affects the physical world.

**Prerequisites:** Basic 1–4; Basic 2 electrical concepts must be understood before independent wiring.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — What Is a Sensor?
- Explain measurements such as distance, light, temperature, and motion.
- **Activity:** Match sensors to the information they provide.

### Page 2 — Reading Digital Sensors
- Explain discrete states such as pressed/not pressed or detected/not detected.
- **Activity:** Interpret a sequence of digital sensor states.

### Page 3 — Reading Analog Sensors
- Interpret changing measurements and the limits of sensor resolution.
- **Activity:** Compare changing values and distinguish measurement from physical units.

### Page 4 — Thresholds and Decisions
- Turn measurements into decisions using conditions.
- **Activity:** Make a virtual robot stop before an obstacle using a defined threshold.

### Page 5 — Outputs and Actuators
- Explore LEDs, buzzers, displays, servos, and motors, including the need for appropriate drivers.
- **Activity:** Match outputs to tasks and identify when a driver is required.

### Page 6 — Combining Input and Output
- Trace sensor → reading → decision → action.
- **Activity:** Complete a simple behavior flow.

### Page 7 — Calibration and Troubleshooting
- Explain noisy readings, inconsistent sensors, calibration, and systematic testing.
- **Mission:** Design and troubleshoot a robot that reacts to a changing sensor value.

### End-of-Course Quiz
Assess:
- Sensor types and measurement interpretation.
- Digital/analog readings.
- Thresholds and decisions.
- Output selection.
- Calibration and troubleshooting.

---

## Basic 6 — Powering Real Projects

**Goal:** Plan power safely instead of guessing which battery or supply will work.

**Prerequisites:** Basic 2 and Basic 4; Basic 5 recommended.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — Where Power Comes From
- Introduce batteries, USB supplies, regulated outputs, and adapters.
- **Activity:** Match power sources to supported use cases.

### Page 2 — Voltage Requirements
- Match supply voltage to board and component ratings.
- **Activity:** Identify mismatched supplies and loads.

### Page 3 — Current Requirements
- Estimate demand, distinguish typical operation from peak loads, and respect limits.
- **Activity:** Compare a component's demand with a supply's capabilities.

### Page 4 — Power Budgets
- Add component demand and identify when a supply is insufficient.
- **Activity:** Complete a simple power budget with supplied specifications.

### Page 5 — Battery Capacity and Runtime
- Estimate runtime and explain why actual runtime varies with load and battery conditions.
- **Activity:** Compare two battery options for a defined load.

### Page 6 — Heat and Protection
- Explore regulators, motor drivers, wiring limits, and overheating risks.
- **Activity:** Find hazards in a proposed power design.

### Page 7 — Build a Power Plan
- Evaluate power sources, loads, and safe wiring for a robot.
- **Mission:** Correct an unsafe or undersized power design and explain the changes.

### End-of-Course Quiz
Assess:
- Voltage matching.
- Current and power budgets.
- Battery capacity/runtime estimates.
- Heat and protection.
- Safe system-level power planning.

---

## Basic 7 — Matching Hardware to a Job

**Goal:** Make defensible hardware choices from requirements rather than preference.

**Prerequisites:** Basic 1–6.

**Estimated structure:** 6 instructional pages + quiz.

### Page 1 — Start With Requirements
- Identify what a project must do before choosing components.
- **Activity:** Separate required features from optional features in a project brief.

### Page 2 — Turn Requirements Into Specs
- Translate needs into processing, pins, connectivity, memory, and power.
- **Activity:** Build a requirement-to-specification matrix.

### Page 3 — Check Compatibility
- Confirm electrical, mechanical, interface, and software compatibility.
- **Activity:** Identify incompatibilities in a sample parts list.

### Page 4 — Compare Candidates
- Use a requirements matrix to compare three candidate platforms.
- **Activity:** Score options against explicit criteria.

### Page 5 — Understand Tradeoffs
- Balance price, complexity, power, performance, and future expansion.
- **Activity:** Re-evaluate a choice when one project constraint changes.

### Page 6 — Defend Your Decision
- Write a hardware recommendation supported by evidence.
- **Mission:** Select a platform for one of several project briefs and explain why plausible alternatives were rejected.

### End-of-Course Quiz
Assess:
- Requirement analysis.
- Specification mapping.
- Compatibility checks.
- Tradeoff reasoning.
- Evidence-backed selection.

---

## Basic 8 — Hardware Builder Challenge

**Goal:** Demonstrate that the learner can apply the Basic track to a complete design.

**Prerequisites:** Basic 1–7.

**Estimated structure:** 6 instructional/workshop pages + quiz.

### Page 1 — Read the Project Brief
- Extract required behavior, constraints, and success criteria.
- **Activity:** Turn a written brief into a checklist.

### Page 2 — Choose the Board
- Compare at least two candidates using documented capabilities.
- **Activity:** Fill out a selection matrix.

### Page 3 — Plan Inputs and Outputs
- Map sensors, controls, and actuators to appropriate interfaces.
- **Activity:** Create a pin and interface plan.

### Page 4 — Plan Power and Safety
- Identify supply requirements and component limits.
- **Activity:** Build a power-budget and safety checklist.

### Page 5 — Review the Design
- Find compatibility problems and explain fixes.
- **Activity:** Perform a structured design review.

### Page 6 — Present the Solution
- Submit a hardware plan, rationale, and test strategy.
- **Mission:** Design a small robot or sensor system. A physical build is optional; learners without hardware can complete a documented digital design.

### End-of-Course Quiz
- Cumulative Basic-track concepts.
- Scenario-based hardware decisions.
- Quiz results should supplement, not replace, review of the submitted mission.

---

# Advanced Track

## Advanced 1 — Inside the PC

**Goal:** Understand a PC as a complete system rather than a collection of isolated specifications.

**Prerequisites:** Basic 3 and Basic 7.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — Inside the System
- Introduce motherboard, CPU, memory, storage, GPU, power supply, and cooling.
- **Activity:** Label a PC system diagram.

### Page 2 — How the CPU Works
- Introduce instruction execution, cores, caches, and architecture at an appropriate level.
- **Activity:** Trace a simple application task through the system.

### Page 3 — RAM, Cache, and Storage
- Explain how memory layers differ in capacity, speed, and role.
- **Activity:** Match data needs to memory/storage layers.

### Page 4 — The Graphics Processing Unit
- Explain graphics processing, parallel computation, and supported compute workloads.
- **Activity:** Match tasks to CPU/GPU roles without assuming every task benefits from a GPU.

### Page 5 — VRAM and System Memory
- Explain why dedicated GPU memory matters for large datasets and AI models.
- **Activity:** Evaluate whether a workload fits a proposed memory capacity.

### Page 6 — Power, Cooling, and Compatibility
- Cover thermal limits, power delivery, and physical/system constraints.
- **Activity:** Identify a compatibility or cooling concern.

### Page 7 — Trace a Workload
- Follow an application through CPU, memory, storage, and GPU resources.
- **Mission:** Explain why a PC with a faster advertised CPU can still perform worse for a specific workload.

### End-of-Course Quiz
Assess system architecture, memory roles, GPU capabilities, and component interactions.

---

## Advanced 2 — Measuring Performance

**Goal:** Measure performance and distinguish useful evidence from misleading numbers.

**Prerequisites:** Advanced 1 and Basic 3.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — What Does Fast Mean?
- Define latency, throughput, responsiveness, and completion time.
- **Activity:** Choose an appropriate performance measure for different tasks.

### Page 2 — Clock Speed and Architecture
- Explain why equal clock rates do not guarantee equal performance.
- **Activity:** Compare two hypothetical processors with different architectures and clocks.

### Page 3 — Single-Threaded vs. Parallel Work
- Compare workloads that benefit from one fast core versus many workers.
- **Activity:** Classify workload examples.

### Page 4 — Reading Benchmarks
- Explain workload-specific tests, score meaning, and comparison limits.
- **Activity:** Interpret a sample benchmark report.

### Page 5 — Memory Bandwidth and Bottlenecks
- Identify when moving data becomes the limiting factor.
- **Activity:** Diagnose a simplified compute-versus-memory bottleneck.

### Page 6 — Measure, Don't Guess
- Compare performance data while accounting for conditions and repeatability.
- **Activity:** Identify which benchmark comparison is methodologically fair.

### Page 7 — Diagnose the Slow System
- Determine whether compute, memory, storage, or thermal limits dominate.
- **Mission:** Analyze a fictional performance report and recommend the most effective upgrade.

### End-of-Course Quiz
Assess performance metrics, benchmark interpretation, and bottleneck diagnosis.

---

## Advanced 3 — Parallel Computing

**Goal:** Understand why some jobs scale across many processing units and others do not.

**Prerequisites:** Advanced 1; Advanced 2 recommended.

**Estimated structure:** 6 instructional pages + quiz.

### Page 1 — One Worker or Many?
- Model tasks as serial work, independent jobs, or dependent steps.
- **Activity:** Split a task into work that can and cannot happen simultaneously.

### Page 2 — CPU Parallelism
- Introduce threads, cores, scheduling, and coordination costs.
- **Activity:** Analyze a task with independent and dependent steps.

### Page 3 — GPU Parallelism
- Explain many similar operations and data-parallel workloads.
- **Activity:** Match example workloads to GPU strengths and limitations.

### Page 4 — When Parallelism Helps
- Explore task size, dependencies, overhead, and scaling limits.
- **Activity:** Compare two task designs with different amounts of parallel work.

### Page 5 — Specialized Accelerators
- Introduce hardware optimized for particular operation types.
- **Activity:** Compare general-purpose and specialized approaches.

### Page 6 — Select the Computing Approach
- Match workloads to CPU, GPU, or specialized hardware using evidence.
- **Mission:** Choose a computing strategy for three workloads and explain why alternatives are less suitable.

### End-of-Course Quiz
Assess parallelism, workload characteristics, scaling limits, and processor selection.

---

## Advanced 4 — AI Hardware: CPU, GPU & NPU

**Goal:** Understand how different processors execute AI workloads and what limits them.

**Prerequisites:** Advanced 1–3.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — What AI Computing Requires
- Introduce matrix operations, tensor computation, and inference.
- **Activity:** Connect a simplified AI workload to its computational needs.

### Page 2 — AI on a CPU
- Explain flexibility, compatibility, and cases where CPU inference is sufficient.
- **Activity:** Evaluate a small AI workload with a stated latency target.

### Page 3 — AI on a GPU
- Explain parallel computation, software support, and memory constraints.
- **Activity:** Compare GPU candidates for a defined workload.

### Page 4 — What an NPU Does
- Introduce specialized neural-network operations, supported precision, and platform-specific limitations.
- **Activity:** Match NPU capabilities to a workload requirement sheet.

### Page 5 — TOPS and Other AI Specs
- Explain advertised throughput and why it is not a universal performance score.
- **Activity:** Identify missing information needed to compare two accelerator claims.

### Page 6 — Memory Is Part of the Accelerator
- Evaluate model size, available memory, bandwidth, and data movement.
- **Activity:** Assess whether a model/workload fits a platform's memory constraints.

### Page 7 — Compare AI Platforms
- Use workload-specific benchmarks and software requirements to make a recommendation.
- **Mission:** Select a processor/platform for a specified AI task and justify the decision with evidence.

### End-of-Course Quiz
Assess CPU/GPU/NPU roles, accelerator specifications, memory needs, and AI hardware tradeoffs.

---

## Advanced 5 — Understanding AI Models

**Goal:** Connect model properties to memory, performance, and practical capability.

**Prerequisites:** Advanced 1, 2, and 4.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — What Is a Model?
- Explain parameters, learned patterns, inference, and the difference between a model and a running application.
- **Activity:** Classify model, runtime, input, and output in a simplified pipeline.

### Page 2 — Model Size
- Introduce parameter counts and how numeric precision affects storage requirements.
- **Activity:** Compare approximate memory/storage requirements using provided values.

### Page 3 — Context and Working Memory
- Explain how prompts, generated tokens, and context length can affect memory use.
- **Activity:** Compare two context-length scenarios.

### Page 4 — Quantization
- Explain reduced numeric precision, memory savings, and possible quality/performance tradeoffs.
- **Activity:** Compare model deployment options under memory constraints.

### Page 5 — Inference Speed
- Introduce time to first token, generation speed, and total response time.
- **Activity:** Interpret a small performance table.

### Page 6 — Capability vs. Cost
- Explain why a larger model is not automatically the best choice for every task.
- **Activity:** Match candidate models to task requirements and resource limits.

### Page 7 — Estimate Feasibility
- Use model requirements to judge whether a system can run a model and what compromises might be needed.
- **Mission:** Compare candidate models for a local assistant with defined memory and response-time limits.

### End-of-Course Quiz
Assess model size, context, quantization, inference performance, and feasibility.

---

## Advanced 6 — Local AI & Edge Computing

**Goal:** Decide where AI should run and what the deployment environment requires.

**Prerequisites:** Advanced 4 and 5; Basic 6 recommended.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — Local vs. Cloud
- Compare network dependence, latency, privacy, cost, and operational constraints.
- **Activity:** Select deployment approaches for several scenarios.

### Page 2 — Edge Computing
- Explain AI running near a sensor or robot instead of on a remote server.
- **Activity:** Trace data paths for local and remote inference.

### Page 3 — Choose a Deployment Platform
- Compare PC, single-board computer, and microcontroller-class platforms for specific workloads.
- **Activity:** Eliminate candidates that fail key requirements.

### Page 4 — Runtime and Software Support
- Explain why model format, runtime, drivers, and supported operations matter.
- **Activity:** Diagnose a deployment blocked by incompatible software support.

### Page 5 — Power and Thermal Constraints
- Evaluate battery runtime, cooling, and sustained performance.
- **Activity:** Compare deployment choices for a battery-powered device.

### Page 6 — Design a Local AI Pipeline
- Connect camera/sensor input, preprocessing, inference, and an output action.
- **Activity:** Arrange pipeline stages and identify where latency can occur.

### Page 7 — Plan Deployment and Testing
- Establish measurable accuracy, latency, reliability, and fallback requirements.
- **Mission:** Design a local vision or sensor-AI system under explicit power, cost, and response-time constraints.

### End-of-Course Quiz
Assess deployment tradeoffs, software compatibility, edge computing, and system design.

---

## Advanced 7 — Advanced Reasoning Workloads

**Goal:** Reason about the resources demanded by more complex AI tasks without treating hardware as a substitute for model capability.

**Prerequisites:** Advanced 2, 4, 5, and 6.

**Estimated structure:** 7 instructional pages + quiz.

### Page 1 — Different Tasks, Different Demands
- Compare classification, generation, long-context analysis, and multi-step workflows.
- **Activity:** Match workload descriptions to their likely resource constraints.

### Page 2 — Model Capability and Compute
- Separate learned model capability from the resources available to run it.
- **Activity:** Analyze cases where extra hardware improves speed but not the underlying model's capabilities.

### Page 3 — Memory and Long Context
- Analyze how longer inputs and retained working state affect resource requirements.
- **Activity:** Compare memory implications of two context scenarios.

### Page 4 — Latency and Multi-Step Work
- Explore serial stages, repeated model calls, and tool use as contributors to total completion time.
- **Activity:** Calculate total latency from a simple sequence of stages.

### Page 5 — Bottleneck Analysis
- Identify compute, memory, bandwidth, storage, and orchestration constraints.
- **Activity:** Diagnose a workload from a supplied resource profile.

### Page 6 — Scale or Simplify?
- Compare upgrading hardware, choosing a smaller model, quantizing, shortening context, or splitting work.
- **Activity:** Choose a response to a constrained deployment scenario.

### Page 7 — Build a Workload Recommendation
- Defend a resource plan based on measured requirements rather than vague claims about intelligence.
- **Mission:** Select a practical model and system for a multi-step reasoning workflow and explain compromises and limitations.

### End-of-Course Quiz
Assess workload characterization, memory/compute tradeoffs, latency, and bottleneck analysis.

---

## Advanced 8 — Systems Architect Challenge

**Goal:** Demonstrate that the learner can design a complete system using evidence, constraints, and tradeoff reasoning.

**Prerequisites:** Advanced 1–7.

**Estimated structure:** 7 instructional/workshop pages + quiz.

### Page 1 — Define the Mission
- Turn a project brief into measurable performance, connectivity, and reliability requirements.
- **Activity:** Produce a requirements checklist.

### Page 2 — Choose the Architecture
- Decide whether the system needs a microcontroller, SBC, PC, remote service, or a combination.
- **Activity:** Compare candidate architecture diagrams.

### Page 3 — Select Compute and Memory
- Justify CPU/GPU/NPU and memory choices for the actual workload.
- **Activity:** Match system resources to workload constraints.

### Page 4 — Design Power and Cooling
- Estimate system demand and check thermal and electrical constraints.
- **Activity:** Review a power/thermal budget.

### Page 5 — Check Compatibility and Cost
- Validate software, interfaces, physical constraints, budget, and future expansion.
- **Activity:** Find missing or incompatible items in a proposed system.

### Page 6 — Test the Design
- Create a benchmark plan, acceptance criteria, and troubleshooting strategy.
- **Activity:** Write measurable pass/fail criteria.

### Page 7 — Present and Defend the Architecture
- Explain the design, rejected alternatives, assumptions, and remaining risks.
- **Mission:** Design a complete system for a specified robotics or local-AI scenario and submit a parts/platform list, compatibility reasoning, resource estimates, and test plan.

### End-of-Course Quiz
Assess cumulative advanced concepts and scenario-based architecture decisions. Quiz results supplement, but do not replace, review of the capstone submission.

---

# Cross-Course Requirements

## Quiz Design
- Every course has one end-of-course quiz aligned to its objectives.
- Questions must assess taught content and include practical reasoning.
- Answer keys and feedback must be accurate and meaningful.
- Support retries and review of missed concepts.
- Store quiz results separately from course/lesson completion and mastery.
- Decide the passing threshold and any score-based course gates before implementing blocking behavior.
- The optional pre-lesson Quick Check is separate and must not block access to instruction.

## Prerequisite Integrity
- A course must not require an unexplained concept first taught in a later course.
- Basic 2 introduces pinouts and signal safety before independent wiring activities.
- Basic 3 teaches specification interpretation before Basic 7 asks learners to make evidence-based selections.
- Basic 6 teaches power budgeting before the integrated Basic 8 design.
- Advanced 1–3 establish PC architecture and performance foundations before advanced AI hardware decisions.
- Advanced 4 introduces CPU/GPU/NPU differences before Advanced 5 evaluates model requirements.
- Advanced 6 covers deployment realities before Advanced 7's resource-planning scenarios.
- Advanced 8 integrates prior knowledge instead of introducing major new concepts for the first time.

## Technical Accuracy
- Use board-specific pin, voltage, current, and power limits from authoritative documentation.
- Clearly label hypothetical benchmark/specification data as fictional.
- Do not compare TOPS or benchmark scores as universal measures when workloads, precision, software, and test conditions differ.
- Distinguish model capability from inference speed and hardware capacity.
- State assumptions and units in calculations and power/runtime examples.

## Accessibility and Age Progression
- Use concrete examples and visuals for first encounters.
- Introduce technical vocabulary before using it without explanation.
- Progress from guided work to independent decisions.
- Provide digital alternatives to physical hardware activities where practical.
- Use progressively richer data and less scaffolding for Builder and Engineer learners without duplicating whole courses.

## Final Acceptance Review
Verify:
- 8 Basic courses and 8 Advanced courses.
- At least 5 substantive instructional pages per course.
- One functioning end-of-course quiz per course.
- Objectives, prerequisites, activities, and quiz coverage for every course.
- No forward dependencies or unexplained vocabulary.
- Technical accuracy and electrical safety.
- Stable IDs and learner progress are preserved.
- Course navigation, manifests, assets, and relevant tests pass.
