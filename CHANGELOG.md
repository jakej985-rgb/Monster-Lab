# Changelog

All notable changes to **Monster Lab** are documented in this file.

The project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.0.2+2] - 2026-10-02
- Automated push release build bump to v0.0.2.

## [1.0.0+1] - 2026-09-29

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
