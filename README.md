# Monster Lab

Monster Lab is a kid-focused, hands-on robotics learning app built around the Monster Arduino kit.

The goal is not to turn the kit manual into an app. The goal is to turn the kit into a guided learning experience where kids learn a concept, find the physical parts, build something, experiment with code, solve problems, and earn progress for understanding what they are doing.

## End Product

Monster Lab will take a learner from **"What is Arduino?"** to building real robotics projects with the Monster kit.

The finished product will provide:
- Kid learner profiles.
- A beginner-friendly robotics curriculum.
- Interactive Arduino lessons.
- A complete Monster kit component library.
- Guided physical build instructions.
- Step-by-step wiring guidance.
- Arduino code explanations and coding challenges.
- Troubleshooting and debugging lessons.
- Quizzes and engineering challenges.
- XP, levels, badges, and project milestones.
- Parent progress tracking.
- Offline-first curriculum access.
- Interactive wiring practice.
- A code lab for learning Arduino programming.
- Optional communication with physical Arduino hardware.
- A curriculum architecture that can grow beyond the original kit.

## Learning Philosophy

Monster Lab is designed around **learn -> build -> test -> change -> explain**.

A learner should not have to blindly copy a wiring diagram or paste code without understanding it.

Each activity should answer:
1. What are we learning?
2. What part are we using?
3. How does the part work?
4. How do we connect it?
5. What should happen?
6. What actually happened?
7. How can we change it?
8. Can we solve a new challenge using the same idea?

## Main Areas

### Learn Lab
- Arduino fundamentals.
- Digital and analog signals.
- Pins and power.
- Breadboards.
- Arduino IDE basics.
- Libraries.
- Variables, conditions, and loops.
- Inputs and outputs.
- Sensors, motors, displays, and communication.

### Parts Lab
The Monster kit becomes an interactive component encyclopedia.

Each component can include:
- Picture or illustration.
- What it does.
- Pin information.
- Wiring guidance.
- Safe-use information.
- Common mistakes.
- Mini experiment.
- Related lessons.
- Related projects.

The initial curriculum covers 54 component entries: the kit's 38 listed peripherals plus supporting electronic components.

### Build Lab
Monster projects become guided builds instead of static instructions.

Representative project families include:
- Monster Autopilot.
- Smart Monster Door.
- Monster Alarm Clock.
- Sentry Guard Monster.
- Beat Detector Monster.
- Oil Drill Rig Monster.
- Intruder Alarm Monster.
- RFID Smart Door Monster.
- NRF24L01 Wireless Monster.
- Weather and Water Reservoir Station.
- Gas Leak Detection and Warning Monster.
- Electric Motor Control Monster.

Each build should guide the learner through:
**Gather -> Wire -> Check -> Code -> Upload -> Test -> Troubleshoot -> Experiment -> Complete**

### Challenges
Challenges test whether the learner understands the concept.

Examples:
- Identify a component.
- Predict a sensor result.
- Fix incorrect wiring.
- Change a program.
- Debug a condition.
- Modify a motor behavior.
- Combine two sensors.
- Build something from a goal instead of instructions.

Difficulty progresses from:
**Rookie -> Builder -> Engineer -> Monster Master**

### Progress
Progress is based on exploration and learning.

The app tracks:
- Lessons completed.
- Components discovered.
- Projects completed.
- Challenges attempted.
- Skills practiced.
- XP.
- Levels.
- Badges.
- Recent activity.

### Parent Mode
Parents can quickly see what was learned, built, explored, and practiced.

Parent Mode should support learning without turning the app into a pressure-heavy grading system.

## Offline First

The core learning experience should work without an internet connection.

Curriculum, lessons, component information, project instructions, progress, and challenges should be stored locally.

Internet access should only be required for optional features such as updates, cloud services, or future integrations.

## Hardware Companion

Hardware integration is a later capability, not a requirement for the basic app.

The architecture will eventually support:
- Arduino detection.
- Serial communication.
- Live sensor readings.
- Hardware test commands.
- Guided hardware diagnostics.
- Interactive project verification.

The app must remain useful when no Arduino is connected.

## Technology Direction

The application is planned as a Flutter project with a data-driven curriculum architecture.

The intended structure separates UI, application logic, domain models, local data, curriculum content, hardware services, and shared components.

Curriculum content should be data-driven so lessons, parts, projects, and challenges can be added without rewriting the application UI.

## Curriculum Source

The original Monster kit materials are the source for the curriculum.

They are treated as reference material rather than as the final learner experience.

Monster Lab will verify the source material, organize it into a progression, rewrite explanations for kids, add prerequisites, add physical activities, add checkpoints, add challenges, add troubleshooting, and connect components to projects.

## Project Roadmap

All implementation plans live in the `plan/` directory.

The project begins at **Phase 0** with no application work completed.

| Phase | Area |
|---|---|
| 00 | Start Project |
| 01 | Curriculum Audit |
| 02 | Product Architecture |
| 03 | Visual Design System |
| 04 | App Foundation |
| 05 | Curriculum Data Engine |
| 06 | Learner Profiles and Progress |
| 07 | Learn Lab |
| 08 | Parts Lab |
| 09 | Build Lab |
| 10 | Challenges and Quizzes |
| 11 | Troubleshooting Lab |
| 12 | Parent Mode |
| 13 | Hardware Companion |
| 14 | Interactive Wiring and Code Lab |
| 15 | Content Expansion |
| 16 | Quality and Accessibility |
| 17 | Release Engineering |
| 18 | Final Product and Launch |

Each phase has its own Markdown plan under `plan/`.

## Guiding Rule

Every feature should answer one question:

> **Does this help a kid understand robotics by actually building, testing, changing, or explaining something?**

If it does not, it should not become core complexity in Monster Lab.

## Target Platforms & Distribution Formats

Monster Lab officially targets Android, Linux, Windows, and Web (Docker):
- **Android**:
  - `monster-lab-android.apk`: Direct sideloading APK; the Hardware Companion is simulated in the current build.
  - `monster-lab-android.aab`: Google Play Store release bundle.
- **Linux Desktop**:
  - `monster-lab-linux.deb`: Standard Debian package with desktop launcher, high-res icons, embedded canonical GPG keyring, and dependency resolution.
  - `monster-lab-linux.deb.asc`: Detached OpenPGP signature verified with the 50-year canonical M3tal key.
  - `monster-lab-linux-portable.tar.gz`: Portable tarball for any x86_64 Linux distribution.
  - `m3tal-archive-keyring.gpg`: Official 50-year OpenPGP release keyring (`5F84FE50A40111C981410E11775AD1473BF25102`, expires 2076) for APT repository verification.
- **Windows Desktop**:
  - `monster-lab-windows.exe`: Graphical setup installer wizard with Start Menu and Desktop shortcuts.
  - `monster-lab-windows-portable.zip`: Portable standalone bundle.
- **Web (Docker & GHCR)**:
  - Container Registry: `ghcr.io/jakej985-rgb/monster-lab-web:latest`
  - `docker-compose.yml`: Pre-filled release compose configuration pulling directly from GHCR.
  - Web Serial hardware support for real Arduino boards in Chrome or Edge on desktop.

> 📖 **Guides**:
> - For downloading and running pre-built releases: **[Platform Installation Guide](docs/INSTALLATION.md)**
> - For compiling, packaging, and developing from source: **[Build and Install from Source Guide](docs/BUILD_AND_INSTALL.md)**

## Versioning & Release Bumping

Monster Lab follows Semantic Versioning starting at `v0.0.1` (`0.0.1+1`).
Every push to `main` runs `.github/workflows/release.yml`, which uses the smart bump to choose a major, minor, or patch release from the commits since the last tag:
```bash
python3 scripts/bump_version.py --auto
```
The workflow synchronizes `version.json`, `pubspec.yaml`, `app_version.dart`, Inno Setup, Windows RC, and Dockerfile; commits and tags `vX.Y.Z`; pushes both atomically; and then builds the full release matrix from that exact commit. Manual release dispatch can supply an explicit `[v]X.Y.Z[+BUILD]` version, or leave it blank to smart-bump.

## Building and Releasing

Release Android builds require `android/key.properties` and the release keystore; use `flutter build apk --debug` for local development. Release builds fail closed when signing material is missing.

```bash
# Android APK & AppBundle (requires release signing configuration)
flutter build apk --release && cp build/app/outputs/flutter-apk/app-release.apk monster-lab-android.apk
flutter build appbundle --release && cp build/app/outputs/bundle/release/app-release.aab monster-lab-android.aab

# Linux Debian (.deb) Package, Keyring & Portable Tarball
flutter build linux --release
python3 scripts/package_linux_deb.py --output monster-lab-linux.deb --sign
tar -czf monster-lab-linux-portable.tar.gz -C build/linux/x64/release/bundle .
cp linux/keyring/m3tal-archive-keyring.gpg m3tal-archive-keyring.gpg

# Windows Setup Installer (.exe) & Portable Zip
flutter build windows --release
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" windows\installer\monster_lab_setup.iss
Compress-Archive -Path build\windows\x64\runner\Release\* -DestinationPath monster-lab-windows-portable.zip

# Web Release (Docker Container & GHCR Push)
flutter build web --release
docker build -t ghcr.io/jakej985-rgb/monster-lab-web:latest -t monster-lab-web:latest .
docker push ghcr.io/jakej985-rgb/monster-lab-web:latest
```

## Quality and Release Gates

Monster Lab enforces automated multi-platform release verification via `.agents/agents/push-gatekeeper/agent.md`:
- Static Analysis (`flutter analyze` — 0 issues)
- Test Suite (`flutter test` — full automated suite)
- Release Preflight (`scripts/quality_gate.sh` — formatting, analysis, tests, coverage, secret scan, curriculum, release contracts, and release-tool tests)
- Curriculum Engine (`python3 scripts/validate_curriculum.py` — 100% integrity)
- Multi-Platform Packaging (Android, Linux .deb, Windows .exe, Web Docker)
- Automated Smart Version Bumping (`python3 scripts/bump_version.py --auto`)
- Offline & Child-Safety Compliance (COPPA / FERPA compliant, zero telemetry)