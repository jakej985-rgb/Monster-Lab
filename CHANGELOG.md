# Changelog

All notable changes to **Monster Lab** are documented in this file.

The project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.0.9+9] - 2026-10-07

### Overview & Release Highlights
Release 0.0.9 introduces major architectural, educational, and mobile UX enhancements across 21 commits. It marks the delivery of **Phase 23 (Modular Curriculum Architecture, Courses, and Sub-Lessons)** and **Phase 24 (Responsive Mobile Lesson UX & Safe Viewing)**, expanding the curriculum from 12 monolithic lessons to 35 modular lessons grouped into structured courses with placement testing, zoomable schematics, safe navigation, and persistent immersive display controls.

---

### 🚀 Features & Content Expansions (Phase 23)
- **Coding Foundations Course (Course 1B)**: Added 8 standalone coding lessons (`cf_01` through `cf_08`) covering core programming paradigms:
  - `cf_01` (*What Is Code?*), `cf_02` (*Variables & Data Types*), `cf_03` (*Operators & Math*), `cf_04` (*Decisions with If/Else*), `cf_05` (*Loops & Repetition*), `cf_06` (*Functions & Modular Code*), `cf_07` (*Arduino Sketch Anatomy*), and `cf_08` (*Code Predictor & Placement Challenge*).
  - *Educational Rationale*: Decouples abstract computational thinking from physical hardware assembly, resolving steep learning curve friction for learners with no prior programming experience.
  - *Placement Test*: High-experience learners can test out of the entire Coding Foundations course directly via `cf_08` (`placementLessonId`).
- **Lesson 2A — Meet Monster Lab**: Added an 8-part guided tour (`l2a_01` through `l2a_08`) exploring the Monster Lab platform:
  - Dedicated walkthroughs for Learn Lab, Parts Lab, Build Lab, Code Lab, Hardware Challenges, XP/Badges progression, ESD safety rules, and orientation assessment.
  - *UX Rationale*: Provides a cohesive onboarding orientation to the virtual workshop environment and lab safety protocols before working with physical microcontrollers.
- **Lesson 2B — Arduino IDE Setup Walkthrough**: Split legacy monolithic `lesson_02` into 8 modular sub-lessons (`l2b_01` through `l2b_08`):
  - Step-by-step guidance covering IDE installation, interface anatomy, compilation pipeline vs. flashing, board & COM port discovery, `setup()`/`loop()` lifecycle, Serial Monitor debugging, library management, and first successful compile checkpoint.
  - *Pedagogical Rationale*: Toolchain setup and COM port detection generate over 80% of beginner troubleshooting issues. Granular step-by-step milestones isolate errors and eliminate setup fatigue.

---

### 📱 Responsive Mobile UX & Safe Viewing (Phase 24)
- **Expandable Lesson Images (`ExpandableLessonImage`)**:
  - Displays inline lesson figures, breadboard layouts, and pinout diagrams with touch-friendly expansion overlays ("Tap to expand") and fallback states for offline assets.
  - *UX Rationale*: Mobile phone viewports (under 400dp width) constrain complex breadboard wiring diagrams.
- **Full-Screen Image Viewer (`FullScreenImageViewer`)**:
  - Full-screen modal route powered by Flutter `InteractiveViewer` with pinch-to-zoom (0.8x to 4.0x), pan navigation, double-tap zoom toggle/reset, and WCAG-compliant high-contrast dismiss button positioned clear of display cutouts.
- **Responsive Code Block (`ResponsiveCodeBlock`)**:
  - Integrated into `MonsterMarkdown` to render code snippets with dark-theme syntax styling (`#1A1A24`), monospace typography, horizontal scrolling (preventing broken syntax wrapping on narrow screens), and a one-tap clipboard copy button with `SnackBar` confirmation.
- **Safe Persistent Action Bar (`LessonActionBar`)**:
  - Standardized bottom navigation bar across all lesson steps enforcing system navigation insets (`SafeArea(bottom: true)`) to prevent touch clipping on Android 3-button navigation bars and gesture pill bars.
- **Android Immersive Reading Mode (`ImmersiveLessonController`)**:
  - Platform-safe system chrome controller using `SystemUiMode.immersiveSticky` to hide system status bars and navigation bars during lesson reading for distraction-free focus, cleanly reverting to `SystemUiMode.edgeToEdge` upon exit.
- **Persistent App Settings**:
  - Implemented `AppSettings` model, `SettingsDataSource`, `SettingsRepository`, and Riverpod `settingsNotifierProvider` persisting toggles for sound effects, high-contrast mode, and immersive lesson mode.

---

### ⚠️ Breaking Changes & Backward-Compatibility Migrations
- **Removal of Legacy `lesson_02.json`**:
  - `assets/curriculum/lessons/lesson_02.json` has been hard-renamed and deleted from the curriculum manifest. Total lesson count expanded from 12 to 35.
  - Downstream prerequisites updated: `lesson_03` now requires `l2b_08` (formerly required `lesson_02`); `lesson_04` requires `lesson_03`.
- **Automatic Progress Migration (`LearnerProgressModel.migrateFromOldFormat`)**:
  - Existing user progress containing `lesson_02` completion is automatically upgraded on first load into full completions for all 8 `l2b_01` through `l2b_08` sub-lessons, ensuring zero progression loss for returning learners.

---

### 🏗️ Architecture & Domain Models
- **Course Domain Modeling**:
  - Added `CourseModel` (`lib/domain/models/course_model.dart`) with support for course prerequisites, lesson lists, optional status, and placement test linkages.
  - Added `courseId`, `sortOrder`, and `isOptional` properties to `Lesson`.
  - Added `StepType.placementCheck` to `StepType` enum for placement checkpoints.
  - Added `completedCourseIds` and `placementPassedCourseIds` tracking to `LearnerProgressModel`.
  - Added linear curriculum sequencing via `CurriculumRepository.getLessonsOrdered()`.

---

### 🧪 Quality Assurance & Toolchains
- **Curriculum Validation Suite**:
  - Updated `scripts/validate_curriculum.py` to validate course manifests and multi-course dependencies across 35 lessons, 54 components, 20 projects, 24 challenges, and 20 badges (100% pass rate).
- **Test Coverage Expansion**:
  - Added 10 new test suites (19 new tests) covering `CourseModel` serialization, backward-compatible migration logic, lesson ordering sequences, placement bypass logic, course completion XP idempotency, settings persistence, `ExpandableLessonImage`, `LessonActionBar`, and `ResponsiveCodeBlock`.

## [0.0.8+8] - 2026-10-03

### Overview & Release Highlights
Release 0.0.8 marks the complete deployment of the interactive simulation framework, implementing 44 custom interactive activity widgets across Lessons 02 through 12. Every lesson now features specialized, hands-on micro-simulators that reinforce critical electronics and coding concepts prior to physical assembly.

---

### 🚀 Interactive Activity Rollout (44 Specialized Widgets)
- **Lessons 02–04 (IDE, Libraries, Setup & Loop)**:
  - Added `CompilationPipelineSimulatorWidget`, `ExecutionSpeedVisualizerWidget`, `IdeLifecycleSimulatorWidget`, and `LibraryDependencyVisualizerWidget`.
  - *Pedagogical Rationale*: Microcontroller compilation pipelines, infinite loop timing, and header dependencies are inherently abstract. Simulating preprocessor and linker stages visually bridges the gap between text sketches and machine code.
- **Lessons 05–07 (GPIO, Potentiometers & PWM)**:
  - Added `BlinkTimingLabWidget`, `CurrentLimitingResistorLabWidget`, `FloatingPinSimulatorWidget`, `AdcSamplingVisualizerWidget`, `AnalogReadNoiseFilterWidget`, `VoltageDividerVisualizerWidget`, `PwmDutyCycleVisualizerWidget`, and `CommonCathodeVsAnodeDiagramWidget`.
  - *Safety & Hardware Rationale*: Visualizes real electrical risks—such as short circuits from missing current-limiting resistors, erratic readings from floating GPIO pins, and reverse polarity damage on LEDs.
- **Lessons 08–10 (Digital Inputs, I2C & SPI)**:
  - Added `ActiveLowLogicCheckerWidget`, `InternalPullupVsPulldownWidget`, `ButtonDebounceVisualizerWidget`, `I2cAddressScannerWidget`, `I2cBitBangSimulatorWidget`, `PullupResistorSizingLabWidget`, `SpiClockPhasePolarityWidget`, and `ChipSelectArbitratorWidget`.
  - *Engineering Rationale*: Bus collisions and signal bouncing represent frequent beginner traps. Simulating multi-device slave arbitration and oscilloscope waveforms prepares learners for real hardware debugging.
- **Lessons 11–12 (Serial Communication & Motor Control)**:
  - Added `BaudRateMismatchDemoWidget`, `UartFrameVisualizerWidget`, `BluetoothAtCommandTerminalWidget`, `HbridgeDirectionSimulatorWidget`, `ExternalMotorPowerLabWidget`, `FlybackDiodeProtectionLabWidget`, and `MotorRpmLoadVisualizerWidget`.
  - *Hardware Protection Rationale*: Back-EMF voltage spikes from DC motors can destroy microcontrollers. The flyback diode simulator directly demonstrates inductive kickback voltage clamping.

---

### 🏗️ Architecture & Registry
- Registered all 44 activity widgets in `ActivityRegistry` (`lib/presentation/features/learn/activities/activity_registry.dart`), standardizing configuration schema mapping across all lesson steps.

---

## [0.0.7+7] - 2026-10-03

### Overview & Release Highlights
Release 0.0.7 establishes Phase 22 & 22a: the foundation of the interactive activity engine, a comprehensive redesign of Lesson 01, and the integration of 20 milestone achievement badges.

---

### 🚀 Interactive Activity Framework (Phase 22)
- **Pluggable Activity Registry**:
  - Implemented `ActivityRegistry` allowing dynamic runtime resolution of interactive widget builders based on `step.interactiveWidgetType`.
  - *Architecture Rationale*: Replaces brittle monolithic widget trees with a modular, extensible plugin pattern for interactive learning content.

### 🎨 Lesson 1 Complete Redesign (Phase 22a)
- **Interactive Uno Board Inspector (`InteractiveBoardInspectorWidget`)**:
  - Interactive multi-touch board diagram enabling learners to explore ATmega328P pins, USB interface, voltage regulators, and status LEDs.
- **Board Label Drag-and-Drop Game (`BoardLabelDragDropWidget`)**:
  - Gamified landmark matching game challenging learners to correctly place hardware labels on an unannotated board canvas.
- **Ground Troubleshooting Lab (`GroundTroubleshootingWidget`)**:
  - Interactive electrical circuit simulator highlighting common power connection errors and short circuits.
  - *Pedagogical Rationale*: Ensures learners understand ground loops and power distribution before wiring physical breadboards.

### 🏆 Milestone Badges Pipeline
- Integrated 20 custom achievement badges (`badge_audio`, `badge_iot`, `badge_motor`, `badge_rfid`, etc.) awarding XP and profile honors upon completing major milestone projects and challenge tiers.

---

## [0.0.6+6] - 2026-10-03

### Overview & Release Highlights
Release 0.0.6 introduces a multi-question quiz carousel assessment system, deep lesson step expansions, and automated curriculum build tooling.

---

### 🚀 Multi-Question Quiz Assessment Engine
- **Interactive Quiz Carousel (`QuizCheckpointWidget`)**:
  - Replaced single static quiz questions with swipeable multi-question assessment carousels featuring immediate per-option rationale explanations, score tracking, and retry mechanics.
  - *Pedagogical Rationale*: Evaluates deeper conceptual understanding across electronics and programming concepts, reinforcing why wrong answers fail and why correct answers succeed.

### 📚 Curriculum Step Expansion
- Expanded Lessons 01–12 from 8 steps to 13–14 comprehensive pedagogical steps per lesson, adding detailed troubleshooting rubrics, real-world engineering context, and interactive checkpoint summaries.
- Created `scripts/compile_expanded_lessons.py` to compile structured lesson Markdown specifications into production curriculum JSON assets.

---

## [0.0.5+5] - 2026-10-02

### Overview & Release Highlights
Release 0.0.5 delivers Phase 21: expanding Monster Lab's curriculum into structured 15–20 minute pedagogical learning modules across all 12 core lessons.

---

### 📚 Curriculum Expansion (Phase 21)
- **15–20 Minute Learning Modules**:
  - Redesigned lessons into comprehensive 6-stage learning modules: Concept Hook → Hardware Anatomy → Wiring Lab → Code Deconstruction → Physical Build → Reflection Assessment.
  - *Pedagogical Rationale*: Initial lessons were overly brief and lacked retention checkpoints. The expanded structure aligns with standard classroom and after-school STEM workshop durations.
- **Integrated Code Deconstruction**:
  - Added tokenized code inspection steps (`codeDeconstruction`) allowing learners to inspect syntax tokens, variable definitions, and control structures line-by-line.

---

## [0.0.4+4] - 2026-10-02

### Overview & Release Highlights
Release 0.0.4 introduces learner onboarding with profile customization, progressive parts discovery, the complete 54-part kit catalog, and dynamic home screen curriculum progression.

---

### 🚀 Learner Onboarding & Profiles
- **Interactive Onboarding Flow**:
  - Added new-learner onboarding modal with nickname selection, age bracket filtering (7–9, 10–12, 13+), and animated avatar selection.
  - *UX Rationale*: Adapts interface density and reading levels to the learner's age group while allowing multiple siblings/learners on a single tablet.

### 🔍 Progressive Parts Discovery & 54-Component Catalog
- **Progressive Discovery Mechanic**:
  - Components in Parts Lab start locked and dynamically unlock as learners discover and use them in lessons.
  - Integrated complete 54-part sensor and actuator catalog with high-res photography, pinout descriptions, operating voltages, and real-world analogies.

### 🏠 Home Screen Next Lesson Progression
- Added dynamic "Continue Lesson" card on the Home Screen that automatically tracks the active learner's curriculum position and launches the next incomplete lesson with a single tap.

---

## [0.0.3+3] - 2026-10-02

### Overview & Release Highlights
Release 0.0.3 integrates automated production Android release signing and GitHub Actions secret management.

---

### 🛠️ Android Production Release Signing
- Configured Gradle release keystore injection via GitHub Actions secrets (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`).
- Automated generation of `android/key.properties` during CI builds while maintaining local debug signing fallbacks.
- *DevOps Rationale*: Automates secure, reproducible Android release APK and AAB compilation without storing signing certificates in source control.

---

## [0.0.2+2] - 2026-10-02

### Overview & Release Highlights
Release 0.0.2 implements Phase 19 (Lesson completion and progress persistence reliability) and Phase 20 (Parts Lab photography and visuals overhaul), along with automated web release workflows.

---

### 🐛 Lesson Completion & Progress Reliability (Phase 19)
- **State Machine & Persistence Hardening**:
  - Resolved re-entrant storage locks in `ProgressRepositoryImpl` to prevent race conditions during rapid step navigation.
  - Hardened offline persistence so learner XP, completed steps, and bookmarks persist immediately without data loss.

### 🎨 Parts Lab Photography Overhaul (Phase 20)
- Added high-definition WebP photography, detailed pinout graphics, and component schematics for all 54 physical kit parts.

### 🌐 Web Release Pipeline
- Added `scripts/build_web_release.sh` and GitHub Actions repository dispatch workflow for automated Web PWA deployment to M3tal-Hub.

---

## [0.0.1+1] - 2026-09-29

### Phase 17: Polish and Release Readiness
- **Multi-Platform Bootstrapping**: Generated clean platform runners for Android, Web (PWA), and Linux desktop.
- **Branding & Visual Identity**:
  - Implemented automated asset generation script (`scripts/generate_release_assets.py`) using Pillow.
  - Generated 1024×1024 master icon, Android mipmap adaptive densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`), and Web PWA standard and maskable icons.
  - Built branded Android cold-boot native splash screen in `#6C5CE7` violet with centered mascot logo.
- **Android Production Engineering**:
  - Configured R8/ProGuard shrinking, dead-code elimination, and obfuscation in `build.gradle.kts` and `proguard-rules.pro`.
  - Added optional USB Host feature (`android.hardware.usb.host`) and permissions in `AndroidManifest.xml` for physical Arduino serial connection.
- **Web PWA Production Build**:
  - Configured offline-first web manifest (`manifest.json`) and metadata in `index.html`.
  - Verified clean production compilation with CanvasKit and service worker caching (`flutter build web --release`).
- **In-App Legal, Privacy, and Licenses**:
  - Created `AboutScreen` (`/parent/about`) with live version indicator, COPPA/FERPA compliance declaration, curriculum scope summary, and Flutter `showLicensePage()` integration.
  - Linked About & Legal access within Parent Mode.
- **Continuous Integration & Delivery**:
  - Upgraded `.github/workflows/ci.yml` with automated Python curriculum validation.
  - Created `.github/workflows/release.yml` for automated Web and Android release builds on version tag triggers.

### Phase 16: Quality and Accessibility
- **WCAG 2.1 AA Compliance**:
  - High-contrast text color tokens (`textSuccessOnLight`, `textWarningOnLight`, `textCyanOnLight`, `textAmberOnLight`, `textDangerOnLight`) exceeding 4.5:1 contrast against light surfaces.
  - Screen reader semantics wrappers and live region updates on interactive custom painters, progress bars, and outcome cards.
- **Ergonomics & Touch Targets**:
  - Enforced minimum 48×48dp hit targets on all child-facing interactive controls (`MonsterButton`, `HardwareStatusBadge`, breadboard color swatches, diagnostic checklist rows).
- **Photosensitive Safety**:
  - Clamped simulator flashing speeds to `>= 350ms` (< 2.85 Hz) to protect against seizure trigger frequencies (3–30 Hz).
- **Responsive Layouts**:
  - Resilient font scaling support across 1.0x, 1.5x, and 2.0x without `RenderFlex` overflows.
  - Dynamic child aspect ratio calculations for tablet landscape and mobile portrait layouts.

### Phase 15: Content Expansion
- Expanded curriculum to 12 lessons, 38 components, 20 guided projects, 24 interactive challenges, and 20 milestone badges.
- 100% kit peripheral coverage with zero unassigned components.
- Added Project Variants and Engineering Missions to guided build screens.

### Phases 00 – 14: Core Architecture & Labs
- Clean Architecture implementation (`core/`, `domain/`, `data/`, `presentation/`).
- 5 Core tabs: Home, Learn Lab, Parts Lab, Build Lab, Progress.
- Interactive Breadboard Simulator with live wiring validation.
- Interactive Arduino C++ Code Lab with syntax highlighting and progressive diffs.
- Troubleshooting Lab & "Doctor Monster" diagnostic triage station.
- Parent Mode with arithmetic challenge Parent Gate, competency radar charts, and offline JSON backup/restore.
- Hardware Companion with Web Serial & USB CDC physical Arduino communication.
