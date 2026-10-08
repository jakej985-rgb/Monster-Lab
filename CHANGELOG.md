# Changelog

All notable changes to **Monster Lab** are documented in this file.

The project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.8+18] - 2026-10-08

### Overview & Release Highlights
Release **0.1.8** optimizes developer workflows, agent execution efficiency, and repository release governance. It configures the Push Gatekeeper to use relaxed polling intervals (`--interval 120` to `180` seconds) during remote GitHub Actions builds, eliminating unnecessary API and token consumption. In addition, it reconciles full historical release documentation across GitHub Releases for versions `v0.1.5`, `v0.1.6`, and `v0.1.7`.

---

### 🛠️ Developer Toolchains & CI/CD
- **Gatekeeper Remote Watch Polling Optimization**:
  - *What Changed*: Updated `.agents/agents/push-gatekeeper/agent.md` and `.agents/rules/push-gatekeeper.md` to require `--interval 120` or `--interval 180` on `gh run watch`, and mandated a minimum initial delay before remote status checks.
  - *Why*: Multi-platform CI and release workflows across Android, Linux, Windows, and Web take 8–15 minutes. Rapid default polling loops burned agent tokens, quota, and system compute.
  - *User / Developer Impact*: Prevents token exhaustion and agent timeouts while keeping remote release verification 100% rigorous.

---

### 📚 Documentation & Specifications
- **Historical Release Notes Synchronization**:
  - *What Changed*: Backfilled and synchronized complete Keep a Changelog descriptions to GitHub Releases for `v0.1.5` (Asset Pipeline & Build Matrix), `v0.1.6` (Flutter Markdown Migration), and `v0.1.7` (Modular Course Decomposition & 107 Sub-Lessons).
  - *Why*: Ensures GitHub Releases web UI and changelog tracking reflect all major architectural shifts and pedagogical milestones.

---

## [0.1.7+17] - 2026-10-08

### Overview & Release Highlights
Release **0.1.7** is a landmark architectural and educational milestone for Monster Lab. It completes the full modular decomposition of the curriculum by converting Lessons 1 and 3–8 into structured **Course Folders** (`assets/curriculum/courses/*.json`) housing **107 modular sub-lessons** (`l01_01.json` through `l08_10.json`), standardizing the bite-sized learning model introduced with Coding Foundations.

On the presentation layer, the **Learn Lab** (`LearnScreen`) has been revamped to render all 10 courses as interactive, collapsible Lesson Folders with single-folder accordion expansion, eliminating visual overwhelm. Crucial progression loops—such as automated course completion upon finishing final sub-lessons and course-aware prerequisite unlocking across `nextLessonProvider` and `BuildScreen`—are now fully wired. Finally, Linux Debian distribution packaging is unified under our canonical 50-year GPG archive signing key with detached `.deb.asc` signatures.

---

### 🚀 New Features & Capabilities
- **Modular Course Architecture (10 Courses & 107 Sub-Lessons)**:
  - *What Changed*: Converted monolithic lesson files into 7 course container JSON definitions and 79 newly decomposed standalone sub-lesson files, unifying the curriculum into 10 full courses comprising 107 modular sub-lessons:
    - **Course 1 (`lesson_01`)**: Arduino Fundamentals (12 sub-lessons, `l01_01`–`l01_12`)
    - **Coding Foundations (`coding_foundations`)**: Software Basics (8 sub-lessons, `cf_01`–`cf_08`)
    - **Course 2A (`lesson_2a`)**: Meet Monster Lab (8 sub-lessons, `l2a_01`–`l2a_08`)
    - **Course 2B (`lesson_2b`)**: Arduino IDE Walkthrough (8 sub-lessons, `l2b_01`–`l2b_08`)
    - **Course 3 (`lesson_03`)**: Libraries & Reusable Code (9 sub-lessons, `l03_01`–`l03_09`)
    - **Course 4 (`lesson_04`)**: PWM & RGB LEDs (10 sub-lessons, `l04_01`–`l04_10`)
    - **Course 5 (`lesson_05`)**: Switches, Buttons & Potentiometers (16 sub-lessons, `l05_01`–`l05_16`)
    - **Course 6 (`lesson_06`)**: Circuits, Breadboards & First Builds (11 sub-lessons, `l06_01`–`l06_11`)
    - **Course 7 (`lesson_07`)**: Sensors & Reading the Real World (11 sub-lessons, `l07_01`–`l07_11`)
    - **Course 8 (`lesson_08`)**: I2C & Connected Devices (10 sub-lessons, `l08_01`–`l08_10`)
    - *Plus 4 standalone advanced hardware protocol lessons* (`lesson_09`–`lesson_12`)
  - *Why*: Monolithic multi-topic lessons created lengthy cognitive hurdles for children and complicated state serialization. Decomposed sub-lessons offer focused 5–10 minute learning increments with granular progress milestones.
  - *User Impact*: Learners experience steady achievement badges and clear checkpoints instead of wading through lengthy single-file modules.
- **Automated Course Completion & Progression Wiring**:
  - *What Changed*: In `LessonDetailScreen`, finishing the concluding sub-lesson of any course automatically evaluates course-level completion and marks the course finished via `progressRepositoryProvider.completeCourse(courseId)`.
  - *Why*: Ensures a seamless learning path without requiring manual intervention or navigation back to folder headers to claim course completion.
  - *User Impact*: Instant reward feedback, automatic unlocking of subsequent courses, and streamlined progress tracking.
- **Course-Aware Prerequisite Resolution**:
  - *What Changed*: Updated `nextLessonProvider` and `BuildScreen` prerequisite resolution logic to verify `completedCourseIds` alongside individual lesson completion IDs.
  - *Why*: Hardware missions in Build Lab often depend on holistic completion of a course (e.g. Breadboarding Basics or Sensors) rather than just an isolated sub-lesson.
  - *User Impact*: Build Lab hardware projects unlock automatically as soon as the corresponding course folder is completed.

---

### 🎨 User Experience & Design System
- **Single-Folder Accordion on Learn Lab**:
  - *What Changed*: Refactored `LearnScreen` (`lib/presentation/features/learn/learn_screen.dart`) to render all 10 courses as collapsible Lesson Folders with single-folder expansion (`_expandedCourseId`).
  - *Why*: Displaying 107 lessons in an unorganized list created endless scrolling and cognitive overload. Single-folder accordion behavior keeps the interface tidy and focused on the student's active area of study.
  - *User Impact*: Children can quickly scan through the 10 course tracks, open their current focus, view sub-lesson completion badges, and jump directly into the next challenge.

---

### 🏗️ Architecture & Data Layer
- **Decoupled Curriculum Engine & Storage**:
  - *What Changed*: Extended `CurriculumDataEngine`, `AssetCurriculumDatasource`, and `CurriculumRepository` with modular course loading, caching, and manifest resolution. Updated `LearnerProgressModel` and `ParentInsightsModel` to manage `completedCourseIds`.
  - *Why*: Decouples curriculum definitions from monolithic files, reducing memory footprints during asset deserialization and preparing the engine for extensible external lesson modules.
- **Curriculum Validation Pipeline Hardening**:
  - *What Changed*: Updated `CurriculumValidator` (`lib/core/curriculum/curriculum_validator.dart`) and `scripts/validate_curriculum.py` to validate course schemas, sub-lesson links, prerequisite integrity, and quiz bindings across all 10 courses and 107 sub-lessons. Added `scripts/decompose_lessons.py` for automated asset transformation.
  - *Why*: Enforces strict CI-validated pedagogical safety and prevents broken lesson links or missing prerequisites across releases.

---

### 🛠️ Developer Toolchains & Packaging
- **Canonical 50-Year GPG Signing & Keyring Unification**:
  - *What Changed*: Standardized Linux Debian release packaging and signing under canonical 50-year GPG key (`5F84FE50A40111C981410E11775AD1473BF25102`). Synchronized `linux/keyring/m3tal-archive-keyring.asc`, removed deprecated `monster-lab-archive-keyring.*` assets, added `--sign` detached signature generation in `scripts/package_linux_deb.py`, and updated `.github/workflows/release.yml` to publish `.deb.asc` signatures.
  - *Why*: Unifies repository infrastructure across m3tal tools and prevents annual keyring expiration failures.
  - *User / Developer Impact*: Linux users installing Monster Lab via APT receive reliable, cryptographically verified packages with a long-lived trust anchor.

---

### 📚 Documentation & Specifications
- **APT Repository & Verification Documentation**:
  - *What Changed*: Updated `README.md` and Linux setup instructions to reference canonical keyring location `/etc/apt/keyrings/m3tal-archive-keyring.gpg` and provide verification commands for `.deb.asc` detached GPG signatures.

---

## [0.1.6+16] - 2026-10-08

### Overview & Release Highlights
Release **0.1.6** modernizes Monster Lab's core Markdown rendering toolchain by migrating from the discontinued upstream `flutter_markdown` package to the active, community-maintained superseding package `flutter_markdown_plus: ^1.0.12`. This update refactors `MonsterMarkdown` and restores a completely clean dependency tree with zero deprecation warnings.

---

### 🏗️ Architecture & Dependencies
- **Superseded Markdown Engine Migration**:
  - *What Changed*: Replaced `flutter_markdown: ^0.7.7+1` with `flutter_markdown_plus: ^1.0.12` in `pubspec.yaml` and `pubspec.lock`. Refactored `lib/presentation/shared/widgets/monster_markdown.dart` to import `package:flutter_markdown_plus/flutter_markdown_plus.dart`.
  - *Why*: The Flutter team officially marked `flutter_markdown` as discontinued on pub.dev. Moving to `flutter_markdown_plus` ensures ongoing bug fixes, compatibility with modern Flutter rendering pipelines, and seamless support for future Flutter SDK releases.
  - *User Impact*: Lesson guides, circuit schematics, hardware tutorials, and embedded code blocks render with crisp fidelity, consistent styling, and improved layout responsiveness.
  - *Developer Impact*: Eliminates pub dependency deprecation warnings and keeps the codebase fully compliant with strict static analysis.

---

## [0.1.5+15] - 2026-10-08

### Overview & Release Highlights
Release **0.1.5** introduces the **Phase 26 Quick Check Pre-Test Diagnostic Engine**, a formative assessment framework integrated across Lessons 1 and 3–8. Featuring 158 curated diagnostic questions spanning 79 submodules, Quick Check provides non-punitive, warm-up diagnostics designed to prime young builders for upcoming lessons without grade anxiety.

This release also incorporates full governance approval from the **Curriculum Guardian** audit (Phase 25/26), validating learning sequences and hardware concept dependencies. In addition, Linux packaging infrastructure begins initial alignment with the central `m3tal-apt-key` archive keyring.

---

### 🚀 New Features & Capabilities
- **Quick Check Pre-Test Diagnostic Engine**:
  - *What Changed*: Introduced `QuickCheckQuestion`, `QuickCheckResult`, and `QuickCheckReadiness` models alongside an interactive modal dialog `QuickCheckModal` (`lib/presentation/features/learn/widgets/quick_check_modal.dart`), surfaced directly within `LessonDetailScreen`.
  - *Why*: Formative pre-tests allow learners to reflect on prerequisite knowledge before tackling technical content. To foster an encouraging, growth-oriented environment for kids, Quick Checks have **zero XP penalty**, offer warm-up explanations upon incorrect choices, and can be skipped at will.
  - *User Impact*: Learners can take a quick 2-question warm-up before entering a submodule, receive instant encouraging feedback and conceptual refreshers, and proceed into the lesson with confidence.
- **Curriculum-Wide Diagnostic Content (158 Questions / 79 Submodules)**:
  - *What Changed*: Authored and embedded 2 diagnostic warm-up questions for every submodule across Lessons 1 and 3–8 (79 submodules, 158 questions in total).
  - *Why*: Targets common electronics and coding misconceptions identified in the curriculum audit—such as polarity, pin modes, current loops, pullup resistors, and serial communication baud rates.
  - *User Impact*: Bridges foundational knowledge gaps directly in the flow of learning.

---

### 🏗️ Architecture & Data Layer
- **Diagnostic Progress Persistence**:
  - *What Changed*: Added `recordQuickCheckResult` to `ProgressRepository` and implemented local JSON persistence in `ProgressRepositoryImpl` (`lib/data/repositories/progress_repository_impl.dart`).
  - *Why*: Persists assessment readiness states (`ready`, `warmUp`, `notAssessed`) and bypass status per submodule to support parent/educator dashboard insights without penalizing learner scores.
- **Curriculum Schema & Validation Rules**:
  - *What Changed*: Extended `CurriculumValidator` and `scripts/validate_curriculum.py` to enforce structural validation on `quickCheck` JSON arrays, verifying valid option ranges, answer indices, and required non-empty explanations.
  - *Why*: Guarantees lesson content validity and prevents runtime parsing errors on malformed diagnostic blocks.

---

### 📚 Curriculum Governance & Documentation
- **Curriculum Guardian Audit & Governance Approval**:
  - *What Changed*: Formally approved and integrated Phase 25 and Phase 26 audit artifacts, including the `25 Master Curriculum Report`, `25 Conflict Register`, `25 Gap Register`, `25 Approval Matrix`, and multi-agent implementation plans (`plan/26a` through `plan/26g`, `plan/99a`, `plan/99b`). Added `.agents/agents/curriculum-guardian/agent.md`.
  - *Why*: Establishes formal governance ensuring lessons adhere to strict didactic sequencing, clear component requirements, and age-appropriate technical explanations.

---

### 🛠️ Developer Toolchains & CI/CD
- **Debian APT Repository Alignment**:
  - *What Changed*: Aligned Linux packaging scripts (`scripts/generate_deb_keyring.py`, `scripts/package_linux_deb.py`) and workflow `.github/workflows/dispatch-apt.yml` with the central `m3tal-apt-key` repository and keyring infrastructure, preparing for 50-year archive signing keys.
  - *Why*: Streamlines cross-repo APT repository publishing and ensures consistency across distribution pipelines.

---

## [0.1.4+14] - 2026-10-07

### Overview & Release Highlights
Release v0.1.4 introduces updates across 2 commits.

### 🛠️ Developer Toolchains & CI/CD
- **ci(release): separate Android, Linux, Windows, and Web builds into parallel jobs** (`fb4adff`):
  - *What Changed*: Separated release packaging in .github/workflows/release.yml into 5 parallel jobs (create-release, build-android, build-linux, build-windows, build-web).
  - *Why*: To speed up the CI/CD pipeline and improve build reliability.

### 📚 Documentation & Specifications
- **docs(changelog): document 0.1.3+13 release notes for CI dependency fix** (`c5e4658`):
  - *What Changed*: Documented the release notes for v0.1.3.
  - *Why*: To keep the changelog up to date.

## [0.1.3+13] - 2026-10-07

### Overview & Release Highlights
Release **0.1.3** resolves a critical CI/CD build stall on GitHub Actions Ubuntu runners during the `Install Linux build dependencies` step and enforces robust network and execution timeouts across all release packaging jobs.

---

### 🐛 Bug Fixes & Stability
- **Resolved Ubuntu Runner `apt-get` Interactive Hang**:
  - *Problem*: GitHub Actions Ubuntu runners (`ubuntu-latest` / Ubuntu 24.04) stalled indefinitely during Linux desktop dependency installation.
  - *Root Cause*: Installing system packages such as `libgtk-3-dev` triggered Ubuntu 24.04's `needrestart` hook, which defaulted to an interactive curses terminal prompt waiting for user input on non-existent stdin. In addition, unconstrained network connections lacked timeout thresholds.
  - *Resolution*: Configured `DEBIAN_FRONTEND=noninteractive`, configured `needrestart` automatic mode (`$nrconf{restart} = "a"` in `/etc/needrestart/conf.d/99-autorestart.conf`), and set explicit apt connection timeouts (`Acquire::http::Timeout=20`) with dpkg `--force-confdef`/`--force-confold`.
  - *Fail-Safe Protection*: Added `timeout-minutes: 5` to the dependency step and `timeout-minutes: 30` to Ubuntu and Windows runner jobs to guarantee builds never hang.


## [0.1.2+12] - 2026-10-07

### Overview & Release Highlights
Release 0.1.2 introduces updates across 1 commits.

### 🛠️ Developer Toolchains & CI/CD
- **feat(release): enforce versioned-only release packages, attach release changelog, and connect push-gatekeeper to changelog agent** (`9de5570`):
  - *What Changed*: Updated release CI and gatekeeper to use versioned releases and release changelog generation.
  - *Why*: Enforces strict versioning to avoid OS package duplication and improves GitHub release page descriptions.

## [0.1.1+11] - 2026-10-07

### Overview & Release Highlights
Release **0.1.1** delivers major UI/UX responsiveness enhancements tailored specifically for young learners on smaller Android devices (320dp–360dp viewport widths). It completely eliminates side-scrolling (horizontal scrolling) across the application, organizes multi-part modular courses into friendly expandable **Lesson Folders**, and refines the distribution model to publish purely versioned OS release packages.

---

### 🎨 User Experience & Design System
- **Zero Side-Scrolling (Vertical-Only Navigation)**:
  - *What Changed*: Systematically refactored all 21 occurrences of horizontal scroll views across `lib/` to responsive vertical wrapping (`Wrap`), adaptive stacking (`LayoutBuilder`), and soft-wrapping text containers.
  - *Why*: Horizontal scrolling on compact mobile viewports causes friction, accidental swipe navigation, and cognitive overload—especially for kids with no prior exposure to software interfaces or electronics.
  - *User Impact*: Children can seamlessly navigate tutorials and simulators by scrolling naturally up and down, with zero horizontal overflow or hidden UI elements off-screen.
- **Adaptive Interactive Simulators & Diagrams**:
  - `VisualFlowDiagramWidget` and `InternalPullupCircuitDiagramWidget` now automatically transition from horizontal flow to intuitive vertical flow on viewports narrower than 500dp–560dp.
  - Interactive activity widgets—including `CodeDeconstructionWidget`, `CompilationPipelineSimulatorWidget`, `FloatingPinSimulatorWidget`, `PwmPinIdentifierWidget`, `GroundTroubleshootingWidget`, `PortTroubleshootingBenchWidget`, `RealWorldSystemDiagramWidget`, and `UartFrameVisualizerWidget`—now wrap badge matrices, pin connectors, and control tabs vertically.
  - The breadboard wiring color palette in `InteractiveBreadboardWidget` now wraps with comfortable 48×48dp tap targets.
- **Soft-Wrapping Code Snippets**:
  - `ResponsiveCodeBlock`, `CodeStudioWidget`, and `GuidedCodeLabWidget` now soft-wrap Arduino syntax and Markdown code fences with dedicated right padding, preventing the copy button from overlapping code.

---

### 📚 Modular Curriculum Navigation
- **Expandable Lesson Folders on Learn Lab**:
  - *What Changed*: Grouped the sub-lessons for **Course 1B (Coding Foundations)**, **Course 2A (Monster Lab Tour)**, and **Course 2B (Arduino IDE Walkthrough)** into expandable, kid-friendly "Lesson Folder" cards on `LearnScreen`.
  - *Why*: Flattening 35 lessons into one monolithic list overwhelmed beginner learners. Folder groupings provide manageable, bite-sized checkpoints that celebrate incremental mastery.
  - *User Impact*: Standalone introductory Lesson 1 is prominently featured first, followed by expandable course folders with visual progress counters, leading into advanced hardware missions (Lessons 3–12).

---

### 📦 Release Packaging & Distribution
- **Streamlined Versioned Packages**:
  - *What Changed*: Removed unversioned duplicate packages from release assets. All distribution packages now strictly carry the explicit semver tag in their filename:
    - Android: `monster-lab-v0.1.1-android.apk`, `monster-lab-v0.1.1-android.aab`
    - Linux: `monster-lab-v0.1.1-linux.deb`, `monster-lab-v0.1.1-linux-portable.tar.gz`
    - Windows: `monster-lab-v0.1.1-windows.exe`, `monster-lab-v0.1.1-windows-portable.zip`
  - *Why*: Eliminates user confusion and download ambiguity caused by identical duplicate binaries in GitHub Releases.


## [0.1.0+10] - 2026-10-07

### Overview & Release Highlights
Release **0.1.0** represents a significant milestone transition for Monster Lab, elevating the project from initial prototype builds to a structured minor release line (`0.1.0`). This release introduces **Semantic Versioned Release Packages** across all distribution channels (Android, Linux, Windows), automated `--minor` and `--major` semver progression tooling, toolchain discovery hardening, and complete historical release changelog documentation.

---

### 📦 Semantic Versioned Release Packages
- **Dual-Asset Distribution Model**:
  - All release workflows now compile and publish **both** versioned binary packages and unversioned permalinks directly to GitHub Releases.
  - **Android**: Produces `monster-lab-v0.1.0-android.apk` and `monster-lab-v0.1.0-android.aab` alongside static permalinks `monster-lab-android.apk` and `monster-lab-android.aab`.
  - **Linux**: Produces `monster-lab-v0.1.0-linux.deb` and `monster-lab-v0.1.0-linux-portable.tar.gz` alongside `monster-lab-linux.deb` and `monster-lab-linux-portable.tar.gz`.
  - **Windows**: Produces `monster-lab-v0.1.0-windows.exe` (Inno Setup wizard installer) and `monster-lab-v0.1.0-windows-portable.zip` alongside static permalinks `monster-lab-windows.exe` and `monster-lab-windows-portable.zip`.
  - *Developer & User Impact*: External distribution mirrors, school lab administrators, and package registries can now pin and archive exact versions by filename without collision or manual renaming.

---

### 🛠️ Toolchain Discovery & Developer Automation
- **Enhanced Toolchain Reporter (`scripts/toolchain_report.py`)**:
  - Implemented multi-stage discovery resolving host symlinks, directory bin resolution, and environment sandboxes. Accurately pinpoints Flutter (`3.47.3`) and Dart SDK (`3.10.x`) installations across host environments.
- **Automated Semantic Bumping Tool (`scripts/bump_version.py`)**:
  - Added `--minor` (`0.0.9` -> `0.1.0`), `--major` (`0.1.0` -> `1.0.0`), and explicit `--set-version` support to the version bumper.
  - Synchronizes version definitions atomically across `pubspec.yaml`, `lib/core/constants/app_version.dart`, Inno Setup script (`monster_lab_setup.iss`), Windows resource file (`Runner.rc`), container `Dockerfile`, and `CHANGELOG.md`.
- **Global Release Changelog Agent & Generator (`scripts/generate_release_changelog.py`)**:
  - Created global agent and automated diff-mining script to extract structured commit context, categorize changes, and generate detailed "What, Why, and Impact" documentation for every release.
- **Historical Changelog Catchup**:
  - Documented and structured complete retrospective release notes for all earlier versions (`v0.0.1` through `v0.0.8`), ensuring comprehensive project auditability.

---

### 📚 Documentation & Gatekeeper Alignment
- Updated `INSTALLATION.md` and `BUILD_AND_INSTALL.md` with versioned package tables and quick reference matrices.
- Synchronized release packaging rules in `.agents/rules/push-gatekeeper.md`, `push-gatekeeper/agent.md`, `workflow-auditor/agent.md`, and `flutter-validator/agent.md`.


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
