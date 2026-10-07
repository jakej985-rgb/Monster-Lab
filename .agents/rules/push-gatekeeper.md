# Push Gatekeeper Rule

This repository uses a strict validation gate for pushes.

Monster Lab officially targets **Android, Linux, and Windows** (along with a strictly containerized **Docker** web version).

## Mandatory behavior

- **Local Execution First**: Before any push, the Push Gatekeeper MUST execute all tests, static analysis, curriculum validation, and local platform release builds in the working tree. Never push assuming remote CI will catch or pass untested changes.
- **Complete Test & CI Suite**:
  1. `flutter pub get`
  2. `dart format --output=none --set-exit-if-changed .`
  3. `flutter analyze`
  4. `flutter test --coverage` (100% of unit, widget, and integration tests must pass)
  5. `python3 scripts/validate_curriculum.py` (all 114 curriculum items must validate)
  6. `flutter test test/unit/curriculum_validation_suite_test.dart`
  7. `flutter build web --release`
  8. `docker build -t monster-lab-web:local .`
  9. Strict platform configuration verification: Android ProGuard rules (`android/app/proguard-rules.pro` including R8 `-dontwarn`), AGP release setup, Linux desktop setup, and Windows Inno Setup wizard.
- Only the Push Gatekeeper is authorized to execute `git push`.
- Validation results are tied to the exact working-tree/commit state that was tested.
- Any code, configuration, platform runner (`android/`, `linux/`, `windows/`), dependency, generated-source, curriculum dataset, or workflow change after validation invalidates the previous result.
- **Active Diagnostics & Auto-Repair**: If any check fails (locally or remotely), do not simply halt and say "PUSH BLOCKED". Actively diagnose the error, repair it (or invoke `repair-agent`), and retry validation up to 3 repair cycles.
- **Mandatory Remote CI/Release Monitoring**: After pushing, the Push Gatekeeper MUST immediately monitor the remote GitHub Actions workflow runs (`gh run watch`). If any remote job fails (e.g. Android R8, Linux packaging, Windows compilation, Docker GHCR push, or GitHub Release asset publishing), the gatekeeper must immediately inspect the failure log (`gh run view --log-failed`), apply the fix locally, re-run all local validation, and ensure the release is completely green.
- Never bypass a failing test, analyzer, formatter, curriculum integrity check, platform build, or CI-equivalent build to make the gate green.
- Never force-push unless the user explicitly authorizes it.
- Never commit secrets, credentials, signing keys, keystores, generated build output (`build/`, `.dart_tool/`, `*.apk`, `*.aab`, `*.deb`, `*.exe`, `*.tar.gz`, `*.zip`), or temporary test artifacts.
- Enforce strict child-safe and zero-telemetry rules: Monster Lab must remain 100% offline, privacy-compliant (COPPA/FERPA), with no unvetted external HTTP/telemetry endpoints across Android, Linux, Windows, or Web.

## Versioning Protocol (Starts at v0.0.1 & Bumps 0.0.1 Every Push)

- Starting version baseline is **`v0.0.1`** (`0.0.1+1`).
- **Mandatory Pre-Push Version Bump**:
  - Immediately before committing and pushing, the Push Gatekeeper must execute `python3 scripts/bump_version.py` to bump the patch version by `0.0.1` (e.g. `0.0.1` -> `0.0.2` -> `0.0.3`) and advance the internal build number.
  - The script automatically synchronizes:
    - `pubspec.yaml`
    - `lib/core/constants/app_version.dart`
    - `windows/installer/monster_lab_setup.iss`
    - `windows/runner/Runner.rc`
    - `Dockerfile`
    - `CHANGELOG.md`
  - Every pushed commit is tagged with `v[semver]` (e.g. `v0.0.1`, `v0.0.2`).

## Supported Multi-Platform Builds & Release Artifact Matrix

The web version is strictly containerized as Docker and published to GitHub Container Registry (GHCR). All release artifacts conform to the naming format:
- Versioned release packages: `[app]-v[version]-[os].[ext]` and `[app]-v[version]-[os]-portable.[ext]` (e.g. `monster-lab-v0.1.0-android.apk`, `monster-lab-v0.1.0-linux.deb`, `monster-lab-v0.1.0-windows.exe`, `monster-lab-v0.1.0-linux-portable.tar.gz`, `monster-lab-v0.1.0-windows-portable.zip`).
- Permalinks / unversioned aliases: `[app]-[os].[ext]` (packages / installers / Docker archive) and `[app]-[os]-portable.[ext]` (standalone portable desktop bundles).

| Target Platform | Package / Installer (`[app]-v[version]-[os].[ext]` & `[app]-[os].[ext]`) | Portable Bundle (`[app]-v[version]-[os]-portable.[ext]` & `[app]-[os]-portable.[ext]`) | Additional Release Assets | Build / Packaging Mechanism |
| :--- | :--- | :--- | :--- | :--- |
| **Android** | `monster-lab-v[version]-android.apk` / `monster-lab-android.apk`<br>`monster-lab-v[version]-android.aab` / `monster-lab-android.aab` | — | — | `flutter build apk --release`<br>`flutter build appbundle --release` |
| **Linux** | `monster-lab-v[version]-linux.deb` / `monster-lab-linux.deb` | `monster-lab-v[version]-linux-portable.tar.gz` / `monster-lab-linux-portable.tar.gz` | `monster-lab-keyring.gpg` | `flutter build linux --release`<br>`python3 scripts/package_linux_deb.py` (installs GPG keyring in `/etc/apt/keyrings/` & `/usr/share/keyrings/`) |
| **Windows** | `monster-lab-v[version]-windows.exe` / `monster-lab-windows.exe` | `monster-lab-v[version]-windows-portable.zip` / `monster-lab-windows-portable.zip` | — | `flutter build windows --release`<br>`ISCC.exe windows/installer/monster_lab_setup.iss` |
| **Web** | `ghcr.io/${OWNER}/monster-lab-web` *(GHCR Image)* | — *(Web is Docker-only)* | `docker-compose.yml` *(pre-filled with GHCR URL)* | `flutter build web --release`<br>Docker build & push to `ghcr.io/${OWNER}/monster-lab-web:${TAG}` & `:latest` |

## Repository CI baseline

The local gate must stay aligned with the workflows under `.github/workflows/`, especially:
- `.github/workflows/ci.yml` (validates formatting, static analysis, unit/widget tests, curriculum integrity, and Docker web build)
- `.github/workflows/release.yml` (compiles and packages the full multi-platform release matrix, pushes container to GHCR, attaches `monster-lab-keyring.gpg` and pre-filled `docker-compose.yml`, verifies the naming schema, and publishes the GitHub Release)

When workflows change, the workflow auditor must update the gate instructions and affected validators before the next release push.
