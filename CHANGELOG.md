# Changelog

All notable changes to **Monster Lab** are documented in this file.

The project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.5.1+34] - 2026-11-21

### Overview & Release Highlights
Release 0.5.1+34 introduces updates across 1 commits.

### 🛠️ Developer Toolchains & CI/CD
- **ci(actions): upgrade workflows to Node 24 runtimes** (`f8afbb0`):
  - *What Changed*: Update checkout, setup-python, setup-java, release publishing, container login, and repository dispatch actions to Node 24 releases so GitHub Actions no longer emits Node.js 20 deprecation warnings.
  - *Why*: Technical necessity and user enhancement.


---

## [0.5.0+33] - 2026-11-21

### Overview & Release Highlights
Release 0.5.0+33 introduces updates across 3 commits.

### 🚀 New Features & Capabilities
- **feat(release): automate smart bump releases on every push** (`722082b`):
  - *What Changed*: Run the release pipeline on every main push, smart-bump and verify the version targets, then commit, tag, and atomically push the release before building every platform from that exact SHA. Align the local gate docs with the workflow owning versioning.
  - *Why*: Technical necessity and user enhancement.

### 🐛 Bug Fixes & Stability
- **fix(app): resolve badge, contrast, and version review findings** (`114ac37`):
  - *What Changed*: Award and backfill the First Circuit Scout badge, make progress badge state consistent, use theme-derived on-colors and controls for high contrast, and separate short and full version overrides.
  - *Why*: Technical necessity and user enhancement.
- **fix(app): complete accessibility and release audit** (`7551248`):
  - *What Changed*: Make app surfaces and simulator copy theme-aware, add persisted sound feedback and high-contrast theme support, and source version labels from the generated release metadata. Add regression coverage for settings, sound gating, and light-mode activity contrast.
  - *Why*: Technical necessity and user enhancement.


---

## [0.4.3+32] - 2026-11-20

### Overview & Release Highlights
Release 0.4.3+32 introduces updates across 2 commits.

### 🐛 Bug Fixes & Stability
- **fix(release): strip assistant attribution footers from generated notes** (`6d5cc94`):
  - *What Changed*: Generated bullets embedded the assistant trailer from each commit body, so published changelogs and GitHub release bodies carried them too. Drop those trailers during draft generation, clean the existing entries, and tell the release-changelog agent not to copy them.
  - *Why*: Technical necessity and user enhancement.

### 🛠️ Developer Toolchains & CI/CD
- **ci: fail when CHANGELOG regains assistant attribution footers** (`dd1434e`):
  - *What Changed*: Add verify_changelog_hygiene.py and run it from both the CI workflow and the local quality gate so a footer copied by hand cannot ship unnoticed.
  - *Why*: Technical necessity and user enhancement.


---

## [0.4.2+31] - 2026-11-20

### Overview & Release Highlights
Release 0.4.2+31 introduces updates across 1 commits.

### 🐛 Bug Fixes & Stability
- **fix(release): keep version.json packageMetadata in sync with bumps** (`67eaa6b`):
  - *What Changed*: android versionCode/versionName and docker.tag were frozen at 0.3.0/27 because both bump entry points only rewrote the top-level version fields. Sync them on every bump and fail CI when the manifest drifts.
  - *Why*: Technical necessity and user enhancement.


---

## [0.4.1+30] - 2026-11-20

### Overview & Release Highlights
Release 0.4.1+30 introduces updates across 2 commits.

### 🎨 User Experience & Design System
- **fix(linux): scope the APT source to amd64 and stop apt warnings** (`b42e4dd`):
  - *What Changed*: The generated sources.list entry requested every architecture, so apt on multiarch systems (i386 enabled for Steam/Wine) warned that the repo has no i386 index and skipped it on every update. Emit arch=<target_arch> explicitly, matching what the repository actually publishes, and update the documented install command to match.
  - *Why*: Technical necessity and user enhancement.
- **fix(linux): use canonical APT repository URL in deb sources.list** (`3612c66`):
  - *What Changed*: The DEB builder derived its sources.list entry from pubspec's homepage, so the installed file pointed at .../M3tal-Hub/Monster-Lab/m3tal-apt-key, which serves no Release file and makes apt-get update fail for everyone who installs the package. Point it at the m3tal-apt-key Pages site directly via a dedicated constant, leaving the app homepage untouched in the control file and AppStream metadata.
  - *Why*: Technical necessity and user enhancement.


---

## [0.4.0+29] - 2026-11-20

### Overview & Release Highlights
Release 0.4.0+29 introduces updates across 20 commits.

### 🚀 New Features & Capabilities
- **🛡️ Sentinel: [MEDIUM] Add android:allowBackup="false" to AndroidManifest.xml** (`fc6e0e4`):
  - *What Changed*: Co-authored-by: jakej985-rgb <224218482+jakej985-rgb@users.noreply.github.com>
  - *Why*: Technical necessity and user enhancement.

### 🏗️ Architecture & Data Layer
- **chore(release): derive deb metadata from pubspec and restore canonical keyring** (`49e2a1f`):
  - *What Changed*: - Make scripts/package_linux_deb.py read name, description, maintainer,   homepage, and dependency list from pubspec.yaml instead of duplicating   them as inline text in the DEB builder. - Build DEBIAN/control from that derived metadata so package control fields   stay synchronized with the source of truth. - Generate the APT sources.list entry from metadata[homepage] instead of a   hardcoded URL, with rstrip('/') to avoid a doubled slash. - Treat non-conformant pubspec name and SSH-style repository.url as usable   warnings rather than crashing the packaging script. - Update scripts/verify_release_artifacts.py to validate the new packaging   functions and to require the Linux keyring assets in linux/keyring/. - Add a release-automation contract check so missing repository-dispatch or   keyring asset publication steps show up as verification failures. - Fail the missing-APT-dispatch-token path as a warning, not a hard failure,   since the signed DEB publishing step can still complete independently. - Restore canonical linux/keyring/m3tal-archive-keyring.asc from   jakej985-rgb/m3tal-apt-key so the in-repo keyring surface matches the   authoritative remote keyring.
  - *Why*: Technical necessity and user enhancement.
- **feat: complete Phase D roadmap (Curriculum Expansion #9)** (`2e4e8b7`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **feat: complete Phase C roadmap (Release Engineering #7 and Automated Quality #8)** (`3406472`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **feat: complete Phase B roadmap (Hardware Architecture #5 and Parent Controls & Safety #6)** (`8fe39eb`):
  - *What Changed*: - Implement physical serial adapter and MockUsbSerialAdapter abstraction (#22) - Add capability-gated WebSerialAdapter with browser fallback (#23) - Create HardwareDeviceCapabilityRegistry indexing board specs and commands (#24) - Implement formal HardwareConnectionStateMachine and all connection states (#25) - Add HardwareProtocolNegotiator for protocol versioning and handshakes (#26) - Implement HardwareSafetyInterlock, pin guards, and Safe State enforcement (#27) - Author comprehensive hardware simulation and integration test suite (#28) - Implement expiring ParentSessionService with renewals and revocations (#30) - Add route authorization guard on /parent routes eliminating deep-link bypass (#31) - Create ComponentRestrictionService securing restricted component unlocks (#32) - Implement DestructiveActionConfirmation and automated snapshot rollback (#33) - Inventory child data collection, sandbox privacy, and permissions (#34) - Author COPPA/FERPA compliance review and regulatory evidence matrix (#35)
  - *Why*: Technical necessity and user enhancement.
- **feat: complete Phase A roadmap (Curriculum Integrity #3 and Learner Progress #4)** (`b704e01`):
  - *What Changed*: - Add strict loader failure boundaries and status tracking in CurriculumDataEngine (#10) - Add manifest count validation against loaded collections (#11) - Enforce unique identifiers across curriculum assets and collections (#12) - Add directed cycle detection for course and lesson prerequisites (#13) - Validate media file existence on disk and interactive activity schemas (#14) - Add comprehensive curriculum integrity regression test suite (#15) - Implement schema versioning v2, migrations, and invariants in LearnerProgressModel (#16) - Create append-only progress event ledger with replay reconstruction (#17) - Enforce idempotent reward transactions preventing duplicate XP (#18) - Add progress corruption detection, dual snapshot backups, and auto-repair (#19) - Implement transactional backup imports with atomic rollback in ParentDataService (#20) - Add multi-profile concurrency synchronization locks in ProgressRepositoryImpl (#21)
  - *Why*: Technical necessity and user enhancement.

### 🎨 User Experience & Design System
- **Merge pull request #63 from jakej985-rgb/fix/linux-true-ui-zoom-and-desktop-density** (`9cfac05`):
  - *What Changed*: fix(ui): true full-UI canvas zoom, MenuBar zoom controls, and 0.80 desktop density (v0.3.1)
  - *Why*: Technical necessity and user enhancement.
- **fix(ui): full-UI canvas zoom, MenuBar zoom controls, 0.80 desktop density, and bump to v0.3.1** (`db40db6`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **Merge pull request #62 from jakej985-rgb/feat/linux-mint-desktop-experience** (`ee79653`):
  - *What Changed*: feat(linux): native Linux Mint desktop UI, GTK sidebar, MenuBar, and Mint-Y theme
  - *Why*: Technical necessity and user enhancement.
- **feat(linux): native Linux Mint desktop UI, GTK sidebar, MenuBar, and Mint-Y theme** (`4b26c23`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **Merge pull request #61 from jakej985-rgb/fix/linux-responsive-ui-scale** (`279f052`):
  - *What Changed*: fix(ui): responsive desktop layout and Linux UI scale calibration
  - *Why*: Technical necessity and user enhancement.
- **fix(ui): responsive desktop layout and Linux UI scale calibration** (`3f01857`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **fix(ci): remove cache from setup-python to fix missing requirements.txt error** (`a268e5b`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **fix(release): harden linux deb packaging and central apt publishing dispatch** (`aba2c81`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.

### 🐛 Bug Fixes & Stability
- **Merge pull request #60 from jakej985-rgb/fix/apt-publishing-pipeline** (`70afa78`):
  - *What Changed*: fix(release): harden linux deb packaging and central apt publishing dispatch
  - *Why*: Technical necessity and user enhancement.
- **fix(ci): verify android key.properties template while allowing gitignored keystore** (`8b7d2f1`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **fix(release): restore M3TAL_HUB_TOKEN fallback and drop unversioned deb alias** (`113a905`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **Merge pull request #2 from jakej985-rgb/security-fix-allow-backup-7759820879455152755** (`b481af3`):
  - *What Changed*: 🛡️ Sentinel: [MEDIUM] Fix data backup privacy risk
  - *Why*: Technical necessity and user enhancement.

### 🛠️ Developer Toolchains & CI/CD
- **Merge pull request #1 from jakej985-rgb/palette-add-icon-tooltips-5305982885982795190** (`5fc71d7`):
  - *What Changed*: 🎨 Palette: Add tooltips to icon-only buttons
  - *Why*: Technical necessity and user enhancement.
- **🎨 Palette: Add tooltips to icon-only buttons** (`8cc4ee2`):
  - *What Changed*: 💡 What: Added tooltips to several icon-only buttons across the app. 🎯 Why: To improve accessibility for screen readers and provide context for users hovering over the buttons. ♿ Accessibility: Screen readers will now announce the button's purpose instead of just 'button'.  Co-authored-by: jakej985-rgb <224218482+jakej985-rgb@users.noreply.github.com>
  - *Why*: Technical necessity and user enhancement.


---

## [0.3.1+28] - 2026-11-20
- Automated push release build bump to v0.3.1.

## [0.3.0+27] - 2026-10-13

### Overview & Release Highlights
Release 0.3.0+27 introduces updates across 5 commits.

### 🏗️ Architecture & Data Layer
- **feat(curriculum): refine RFID rectifier, flyback diode spike model, and in-app simulator preview** (`d9c0d25`):
  - *What Changed*: - Replace inaccurate capacitor-rectifies statement in l10_06 with RF tag rectifier circuit explanation - Qualify the 3.0 cm RFID detection threshold in l10_06 and simulator widget as a simulation boundary - Document Monster Lab 85V illustrative model spike caveat in l12_02 educator key - Add dedicated RFID coupling simulator static preview mockup in scripts/render_in_app_lesson.py - Add printable activity table validation in scripts/generate_lesson_pdf.py - Add changelog version parsing and validation in scripts/generate_release_changelog.py - Realign tests with Course 1 lesson count and add regression unit/widget test suites
  - *Why*: Technical necessity and user enhancement.
- **feat(curriculum): improve course 1 lessons and assessments** (`0606aea`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **Add Phase 28a detailed 16-course hardware curriculum map** (`53fd196`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.
- **Add Phase 28 hardware and computing literacy curriculum plan** (`ff40b1c`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.

### 🎨 User Experience & Design System
- **style: apply dart format to lesson model, widgets, and tests** (`693b007`):
  - *What Changed*: Implemented changes described in commit.
  - *Why*: Technical necessity and user enhancement.


---

## [0.2.1+26] - 2026-10-11

### Overview & Release Highlights
Release **v0.2.1** refines curriculum simulation fidelity, printable worksheet ergonomics, and automated release tooling. Key enhancements include simulation-tailored printable activity worksheets for LED resistor labs, RFID SPI buses, and DC motor drivers, removal of generic fallback worksheet templates in favor of bespoke classroom recording sheets, decoupling checkpoint quiz badges to prevent print collisions, and qualification of microcontroller GPIO current constraints.

---

### 🎓 Curriculum & Simulation Worksheets
- **Bespoke In-App Simulation Printable Worksheets (`l06_04.json`, `l10_06.json`, `l12_02.json`)**:
  - *What Changed*: Authored structured `printableActivity` objects with custom task instructions, apparatus listings, and bespoke table headers tailored to the specific in-app simulators:
    - *LED Current Limiter*: Hands-on recording table for 220 Ω, 10 kΩ, and 0 Ω boundary states with observation fields for brightness, current draw, and component thermal/burnout risks.
    - *RFID SPI Bus Architecture*: Step-by-step MOSI/MISO/SCK/SS telemetry signal logging table with tag UID capture and validation notes.
    - *DC Motor Driver & Flyback Protection*: Transistor saturation and inductive kickback table recording base bias pin logic, flyback diode presence, and motor shaft status.
  - *Why*: Replaces synthetic or generic three-box 'Predict / Observe / Analyze' templates with authentic laboratory worksheets matching student simulator steps.
  - *User Impact*: Students and educators receive clear, reproducible recording tables in physical handouts that directly align with interactive screen exercises.

- **GPIO Current Limits & Motor Driver Load Qualification (`l12_01.json`, `l12_02.json`, `asset_curriculum_datasource.dart`)**:
  - *What Changed*: Explicitly clarified microcontroller GPIO pin source/sink current ceilings (e.g. 20–40 mA max on standard ATmega/ESP GPIOs) versus DC motor stall currents (often 500 mA–1.5 A+), reinforcing why external driver circuits (transistors/MOSFETs/H-bridges) and flyback diodes are physically mandatory.
  - *Why*: Eliminates ambiguities regarding whether microcontrollers can directly power motors and prevents physical hardware damage during breadboard assembly.
  - *User Impact*: Clearer electrical safety understanding for learners transitioning between simulation and physical hardware.

### 📄 Exporter & Printable PDF Polish
- **Decoupled Checkpoint Quiz & Badge Layout (`scripts/generate_lesson_pdf.py`)**:
  - *What Changed*: Decoupled checkpoint quiz card rendering to avoid overlapping step badges, improved table layout width allocation, and removed brittle phrase-matching heuristics that previously attempted to reconstruct worksheet columns.
  - *Why*: Guarantees clean, publication-grade formatting in both Educator and Student printable modes without text collisions or truncated tables.
  - *User Impact*: Printable lesson sheets have crisp alignment, correct column distribution, and clean page breaks.

### 🛠️ Developer Tooling & Automation
- **Semantic Bump Calculation & Pubspec Synchronization (`scripts/generate_release_changelog.py`)**:
  - *What Changed*: Implemented `--bump auto|major|minor|patch` semantic level evaluation from conventional git commit messages and automated bidirectional synchronization with `pubspec.yaml` and `CHANGELOG.md`.
  - *Why*: Streamlines release cadence gating and prevents version drift across repository metadata files.
  - *User Impact*: Automated CI/CD and release pipelines generate comprehensive, context-rich changelogs with zero manual formatting overhead.

## [0.2.0+25] - 2026-10-11

### Overview & Major Milestone Highlights
Release **v0.2.0** marks the milestone completion of Monster Lab's comprehensive curriculum expansion and interactive learning platform. Monster Lab now delivers 14 complete courses with 139 interactive lessons, universal step and activity completion gating, dual-viewport simulation, high-fidelity printable teacher/student lesson exporters, and complete test verification.

---

### 🚀 Milestone Capabilities & Enhancements

- **Full 14-Course / 139-Lesson Curriculum Expansion & Master Dependency Mapping**:
  - *Curriculum Breadth*: 14 fully authored courses spanning 139 lessons, 38 components, 20 projects, 24 challenges, and 20 badges.
  - *Dependency Architecture*: Fully reconciled prerequisite and track progression mapping (`audit/04_lesson_dependency_map.md`) ensuring deterministic unlocking and scaffolded learning paths.
  - *Physical & Simulation Parity*: Complete coverage across breadboard electronics, microcontroller coding, sensors, actuators, serial protocols, and robotics.

- **Universal Step & Activity Completion Gating**:
  - *Engagement Verification*: Universal activity completion gating requiring students to complete interactive simulations, code experiments, and mastery checkpoints before unlocking sequential steps.
  - *Offline State Persistence*: Deterministic progress tracking stored locally via SharedPreferences with zero cloud reliance or external data leakage.

- **Dual-Viewport In-App Simulator & Interactive Widget Previews**:
  - *Dual Form-Factor Support*: Responsive support for mobile (390px portrait) and desktop/tablet (720px/1024px landscape) layouts.
  - *Interactive Previews*: In-app preview system and visual simulator for all interactive widgets and circuits, complete with real-time waveform inspection, component telemetry, and state animation.

- **High-Fidelity Lesson Exporters (Educator & Learner Modes)**:
  - *Classroom Printables*: Automated lesson PDF exporter producing professional educator keys with solution rationales and clean student lab handouts with observation log tables.
  - *Typography & Rendering*: Full LaTeX math Unicode parsing, pre-wrapped syntax-highlighted code blocks, page-break boundary protection, and visual schematic previews.

- **Quality Assurance & Zero-Regression Test Suite**:
  - *Test Coverage*: 263/263 passing unit and integration tests across state management, curriculum validation, and widget interactions.
  - *Compliance & Safety*: 100% COPPA/FERPA compliance with zero network telemetry and fully self-contained offline assets.

## [0.1.14+24] - 2026-10-11

### Overview & Release Highlights
Release **v0.1.14** finalizes core curriculum precision improvements across analog-to-digital conversion, semiconductor diode protection thresholds, level-shifting wiring for 3.3V SPI peripherals, inductive kickback recirculation loops, and self-contained in-app interactive pedagogy. Additionally, it overhauls the automated lesson PDF exporter with LaTeX math unicode rendering, code block wrapping, blank first page elimination, clean student/educator separation, and updated offline preview bundles.

---

### 🎓 Pedagogical & Curriculum Enhancements
- **Analog-to-Digital Conversion Physics & ADC Precision (`l01_02.json`)**:
  - *What Changed*: Refined the analog pins diagram and step descriptions to explicitly detail discrete 10-bit ADC conversion (0–1023 integer range corresponding to 0–5V) rather than generic continuous voltage descriptions.
  - *Why*: Eliminates early learner confusion between continuous analog signals and digitized values read by the microcontroller.
  - *User Impact*: Learners establish clear foundations for sensor telemetry and quantization before writing analog sensing code.

- **Component Safe Operating Parameters & Resistor Protection Rule (`l06_04.json`, `l01_07.json`)**:
  - *What Changed*: Replaced fixed current targets with qualified safe operating ranges; clarified that in physical circuits, current does not reach infinity without a resistor but is bounded by source, switch, and wiring impedance; and updated course cross-references. Added structured hands-on simulation tasks with dedicated laboratory recording logs comparing $220\,\Omega$, $10\,\text{k}\Omega$, and $0\,\Omega$ boundary conditions.
  - *Why*: Prevents misconceptions about semiconductor impedance and infinite current, grounds current limiting in Ohm's law, and avoids misleading learners with fixed numeric current assumptions.
  - *User Impact*: Clearer safety guidelines and hands-on simulation tasks that reinforce safe experimentation habits.

- **RC522 3.3V Logic Level Shifting, Custom Flow Stages & Self-Contained App Pedagogy (`l10_06.json`, `l10_07.json`)**:
  - *What Changed*: Added explicit step-by-step wiring instructions guiding learners through logic level shifting for 5V Arduino Uno signals connected to the 3.3V RC522 RFID reader. Configured interactive visual flow diagram nodes specific to 13.56 MHz RFID electromagnetic physics (RF field emission, inductive coupling, load modulation, and SPI transfer). Structured steps to center around Monster Lab's in-app virtual card/fob simulation and serial UID decoding, framing physical breadboard assembly as an optional hardware extension without third-party workstation prerequisites.
  - *Why*: Protects sensitive 3.3V inputs from 5V logic signals, ensures all lessons are fully self-contained within the Monster Lab offline app, and provides bespoke interactive flow diagrams.
  - *User Impact*: Learners can complete the lesson purely in-app or successfully wire physical RFID peripherals without risking hardware damage.

- **Flyback Diode Recirculation & Inductive Clamping (`l12_02.json`)**:
  - *What Changed*: Replaced misleading open-switch current claims with accurate descriptions of coil magnetic energy dissipation through an antiparallel flyback diode. Clarified that Arduino GPIO pins can never drive DC motors directly (20 mA limit vs motor inrush/stall currents), provided an external MOSFET/transistor driver schematic with common ground, labeled sketches for simulation only, and structured a 5-step active in-app simulation task.
  - *Why*: Teaches physically accurate circuit mechanics for inductive kickback suppression and motor driving safety.
  - *User Impact*: Students gain accurate mental models for motor/relay switching and transient spike protection.

- **Curriculum Dependency Map Reconciliation (`audit/04_lesson_dependency_map.md`)**:
  - *What Changed*: Fully reconciled prerequisite and follow-up lesson chains across all 14 course manifests and 20 projects.
  - *Why*: Ensures strict curriculum progression integrity and prevents broken prerequisite links.
  - *Developer/Educator Impact*: Complete audit alignment guaranteeing deterministic lesson progression and track consistency.

### 🛠️ Tooling & Educator Resources
- **Automated Lesson PDF Exporter Polish (`scripts/generate_lesson_pdf.py`)**:
  - *What Changed*: Eliminated blank page 1 defects by removing unneeded container break constraints while preserving header and question integrity (`break-after: avoid`). Implemented clean LaTeX math rendering to styled HTML and unicode symbols ($\Omega$, $\approx$, $\le$, $\frac{1}{2}$, superscripts, subscripts), added `pre-wrap` and `break-word` styling to prevent code clipping, eliminated redundant generic prediction prompts by detecting structured markdown tasks and emitting clean laboratory observation tables, and strictly suppressed answer keys and `[CORRECT ANSWER]` tags from student handouts (`--mode learner`).
  - *Why*: Produces polished, publication-ready classroom printouts that fit neatly onto standard pages without mid-question page breaks, raw LaTeX markup, or duplicate boilerplate prompts.
  - *Educator Impact*: High-quality printable handouts and keys ready for classroom distribution and lab exercises.

## [0.1.13+23] - 2026-10-11

### Overview & Release Highlights
Release **v0.1.13** enhances curriculum precision across Coding Foundations and core electronics courses, clarifies execution models and ADC quantization physics, enriches active code ambiguity challenges, and upgrades the automated lesson PDF exporter with dual learner and educator modes for printable classroom worksheets.

---

### 🎓 Pedagogical & Curriculum Enhancements
- **Execution Model & Hardware Precision in Lessons**:
  - *What Changed*: Refined explanatory text across lessons (`l01`, `l05`, `l06`, `l10`, `l11`, `l12`, and `cf_*`) to emphasize exact computer execution over anthropomorphic models (clarifying that microcontrollers execute deterministic code instructions rather than "thinking"). Enriched ADC explanations in Lesson 05 to emphasize 1,024 discrete quantization steps, ADC reference voltage ($V_{ref}$), and supply rail drift.
  - *Why*: Eliminates misconceptions among beginning learners regarding program execution flow and physical voltage-to-integer conversion.
  - *User Impact*: Learners build rigorous mental models of computer architecture, binary quantization, and sensor telemetry.

- **Active Challenges & Ambiguity Tracing in Coding Foundations**:
  - *What Changed*: Enhanced step content in `cf_01` through `cf_06` with hands-on robot instruction sequencing challenges, ambiguity checks, and code trace exercises.
  - *Why*: Strengthens computational thinking by demonstrating why computers cannot infer vague directions and require unambiguous, ordered statements.
  - *User Impact*: Greater learner engagement and intuitive understanding of sequential execution and debugging.

### 🛠️ Tooling & Educator Resources
- **Dual-Mode Lesson PDF & HTML Worksheet Exporter**:
  - *What Changed*: Upgraded `scripts/generate_lesson_pdf.py` with `--mode learner|educator` support. Learner mode generates printable hands-on experiment worksheets with prediction/observation/explanation prompts and blank checkpoint answer blanks, while educator mode prints complete answer keys with detailed explanations and warmup hints.
  - *Why*: Provides classrooms, STEM camps, and parents with flexible, offline-ready printable curriculum materials.
  - *Developer/Educator Impact*: Zero-dependency offline lesson sheet export with automated formatting and clean distinction between student challenges and educator keys.


## [0.1.12+22] - 2026-10-11

### Overview & Release Highlights
Release **v0.1.12** introduces universal lesson completion gating with automated scroll-to-activity assistance, dark theme contrast enhancements on card surfaces, multi-viewport Flutter widget previews for dual mobile and desktop form factors, updated completion flow test verification, and offline dual-viewport HTML/PDF lesson curriculum exporters.

---

### 🎓 Pedagogical & Learning Experience
- **Universal Lesson Completion Gating & Docked Action Bar**:
  - *What Changed*: In `LessonDetailScreen`, enforced mandatory activity completion checks across all interactive step types (quiz checkpoints, physical hardware tasks, simulators, and code blocks) before permitting progression or completion. Implemented auto-scrolling with user-friendly guidance banners directly targeting incomplete activities when 'Next Step' is pressed prematurely. Positioned a docked action bar beneath step content.
  - *Why*: To uphold pedagogical mastery and ensure learners thoroughly engage with hands-on challenges and checkpoints rather than bypassing learning requirements.
  - *User Impact*: Learners receive clear, immediate feedback on missing activities and smoothly scroll to incomplete tasks; checkpoint XP (+10 XP) and lesson completion rewards are awarded consistently and persist reliably.

### 🎨 UI & Accessibility
- **Dark Theme Contrast Fallback on MonsterCard**:
  - *What Changed*: Updated fallback background color resolution in `MonsterCard` to evaluate theme brightness, selecting `AppColors.surfaceDark` when running in dark theme instead of defaulting to light surface values.
  - *Why*: Fixed visual contrast issues where card surfaces in dark mode could appear washed out or display improper text-to-surface contrast ratios.
  - *User Impact*: Crisp, high-contrast visual presentation across all card containers in dark mode, satisfying WCAG AA legibility guidelines.

### 🧪 Developer Toolchains & Widget Previews
- **Dual Form Factor Flutter Widget Previews**:
  - *What Changed*: Added `lib/presentation/features/learn/previews/lesson_previews.dart` with `@Preview` decorators and configurable containers simulating both mobile (390x844) and desktop (1024x768) environments across multiple step types (story, visual explanation, physical tasks, and quiz checkpoints).
  - *Why*: Provides developer and designer toolchains with instantaneous visual inspection and verification of lesson layouts without running full device emulators.
  - *Developer Impact*: Accelerates UI component review and layout regression testing across form factors.

- **In-App Dual-Viewport Lesson Renderer & PDF Exporter Scripts**:
  - *What Changed*: Added `scripts/render_in_app_lesson.py` and `scripts/generate_lesson_pdf.py` for automated headless rendering and PDF export of curriculum lessons, along with gitignore protections for generated report artifacts in `reports/`.
  - *Why*: Supports educators and curriculum developers with printable, offline lesson plans matching the exact in-app presentation.
  - *Developer Impact*: Enables reproducible, batch generation of curriculum documentation without bloating git repository history.

### 🧪 Automated Testing & Verification
- **Completion Flow & XP Verification Suite**:
  - *What Changed*: Updated `test/widget/learn_completion_flow_test.dart` to simulate prerequisite quiz submissions on completion steps and verify multi-tier XP accrual (individual checkpoint XP + lesson completion XP + course milestone XP).
  - *Why*: Ensures full test coverage reflecting the newly enforced universal completion gating logic.
  - *Developer Impact*: Complete 263-test automated test suite passing cleanly with zero regressions.

## [0.1.11+21] - 2026-10-09
- Course 1 microcontroller family expansion (Uno, Nano, Mega, ESP8266, ESP32, 5V vs 3.3V logic safety).
- Conversion of lessons 09, 10, 11, and 12 into full modular course folders (Course 9 Advanced I2C, Course 10 SPI, Course 11 UART/Bluetooth, Course 12 Motors/H-Bridges).
- Thorough pedagogical prerequisite coverage introducing all components before wiring or experiments.

## [0.1.10+20] - 2026-10-09

### Overview & Release Highlights
Release v0.1.10 implements the Phase 27 Curriculum Diagnostic Audit and Sequence Realignment, resolving prerequisite dependencies and improving the pedagogical flow.

### 📚 Curriculum & Pedagogy
- **Phase 27 Realignment**: Reordered lessons in the curriculum manifest and updated tests to reflect the new sequence.
  - *What Changed*: Adjusted `prerequisites` in lessons (e.g., `l07_01.json`, `l08_01.json`, etc.), reordered courses in `manifest.json`.
  - *Why*: To ensure concepts are introduced logically based on the Phase 27 prerequisite audit findings.
  - *Impact*: Learners will experience a smoother progression with foundational concepts properly preceding advanced topics.


## [0.1.9+19] - 2026-10-09

### Overview & Release Highlights
Release **0.1.9** introduces a massive pedagogical expansion to the Monster Lab curriculum. Over 100 lesson schemas have been restructured to include deeper progression modeling and pre-test diagnostics. This update transforms Courses 1–8 into structured 4-step submodules and integrates "Quick Check" diagnostics across foundational and standalone lessons. These changes ensure learners receive immediate feedback and a more scaffolded educational experience.

---

### 🚀 New Features & Capabilities
- **Quick Check Pre-Test Diagnostics**:
  - *What Changed*: Added interactive pre-test "Quick Check" elements to Coding Foundations (`cf_`), Level 2A (`l2a_`), Level 2B (`l2b_`), and standalone lessons (`09` through `12`).
  - *Why*: Pedagogical design emphasizes early knowledge retrieval. Quick Checks assess baseline comprehension before instruction, priming the learner and calibrating the educational flow.
  - *User Impact*: Learners will face a short diagnostic assessment before diving into foundational topics, ensuring better knowledge retention and self-evaluation.

### 🏗️ Architecture & Data Layer
- **4-Step Submodule Expansion (Courses 1–8)**:
  - *What Changed*: Re-architected lesson JSON files and updated the `AssetCurriculumDataSource` with over 4,000 lines of new modular payload data. Courses 1 through 8 (`l01_` to `l08_`) have been explicitly expanded into dedicated 4-step submodules.
  - *Why*: Breaks down complex coding concepts into smaller, more digestible learning steps (e.g., Theory, Demonstration, Guided Practice, Independent Task).
  - *User Impact*: Substantially improves lesson pacing. Instead of monolithic sessions, learners progress through clearly defined, incremental milestones.

### 🛠️ Developer Toolchains & CI/CD
- **Automated Version & Release Bump**:
  - *What Changed*: Updated versioning to `0.1.9+19` across `pubspec.yaml`, `Dockerfile`, `app_version.dart`, and Windows/InnoSetup runner scripts.
  - *Why*: To accurately track the new curriculum payload, trigger release pipelines, and maintain semantic versioning parity across all target platforms.


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
