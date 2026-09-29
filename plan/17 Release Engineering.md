# 17 Release Engineering & Polish

## Goal
Prepare production builds, release assets, privacy disclosures, and continuous deployment workflows for supported platforms (Android, Web, Desktop).

## Completed Tasks
- [x] Configure Android release builds with ProGuard/R8 shrinking, dead-code elimination, and `proguard-rules.pro`.
- [x] Add Android USB host hardware permissions and feature declarations (`android.hardware.usb.host`) in `AndroidManifest.xml`.
- [x] Configure Web release with offline PWA manifest (`manifest.json`), service worker, and metadata in `index.html`.
- [x] Successfully compile production Web PWA bundle (`flutter build web --release` -> `build/web/`).
- [x] Configure desktop builds (Linux GTK runner, CMakeLists, and runner configurations).
- [x] Generate production release branding assets via `scripts/generate_release_assets.py` (master 1024×1024 icon, Android mipmaps, Web favicons & maskable icons, splash logo).
- [x] Configure branded Android native launch background (`launch_background.xml` & `values/colors.xml`).
- [x] Implement in-app `AboutScreen` (`/parent/about`) with live version `1.0.0+1`, 100% offline COPPA notice, and Flutter `showLicensePage()` integration.
- [x] Configure versioning (`pubspec.yaml` version `1.0.0+1`).
- [x] Configure comprehensive release notes and milestone history (`CHANGELOG.md`).
- [x] Configure child-safe privacy policy statement (`docs/PRIVACY.md`) detailing COPPA and FERPA adherence.
- [x] Document platform installation, sideloading, and development setup (`docs/INSTALLATION.md`).
- [x] Configure CI release validation and packaging workflows (`.github/workflows/ci.yml` and `.github/workflows/release.yml`).

## Done When
- [x] A clean machine can install and launch a release build.
- [x] Release builds are reproducible and verifiable via GitHub Actions.
- [x] Full automated test suite passes with zero errors and analyzer warnings.