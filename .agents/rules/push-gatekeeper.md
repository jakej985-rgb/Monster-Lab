# Push Gatekeeper Rule

This repository uses a strict validation gate for pushes.

Monster Lab officially targets **Android, Linux, and Windows** (along with a strictly containerized **Docker** web version).

## Mandatory behavior

- Do not push code directly after making changes.
- Before any push, use the `push-gatekeeper` custom agent or follow its complete validation protocol.
- Only the Push Gatekeeper is authorized to execute `git push`.
- Validation results are tied to the exact working-tree/commit state that was tested.
- Any code, configuration, platform runner (`android/`, `linux/`, `windows/`), dependency, generated-source, curriculum dataset, or workflow change after validation invalidates the previous result.
- If any check fails, do not simply halt and say "PUSH BLOCKED". Actively diagnose the error, repair it (or invoke repair-agent), and retry validation up to 3 repair cycles. A push is only permanently blocked if errors persist after all 3 repair cycles are exhausted.
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

The web version is strictly containerized as Docker and published to GitHub Container Registry (GHCR). All release artifacts must conform to the naming format:
`[app]-[os].[ext]` (for packages / installers / Docker archive)
`[app]-[os]-portable.[ext]` (for standalone portable desktop bundles)

| Target Platform | Package / Installer (`[app]-[os].[ext]`) | Portable Bundle (`[app]-[os]-portable.[ext]`) | Additional Release Assets | Build / Packaging Mechanism |
| :--- | :--- | :--- | :--- | :--- |
| **Android** | `monster-lab-android.apk`<br>`monster-lab-android.aab` | — | — | `flutter build apk --release`<br>`flutter build appbundle --release` |
| **Linux** | `monster-lab-linux.deb` | `monster-lab-linux-portable.tar.gz` | `monster-lab-keyring.gpg` | `flutter build linux --release`<br>`python3 scripts/package_linux_deb.py` (installs GPG keyring in `/etc/apt/keyrings/` & `/usr/share/keyrings/`) |
| **Windows** | `monster-lab-windows.exe` | `monster-lab-windows-portable.zip` | — | `flutter build windows --release`<br>`ISCC.exe windows/installer/monster_lab_setup.iss` |
| **Web** | `ghcr.io/${OWNER}/monster-lab-web` *(GHCR Image)* | — *(Web is Docker-only)* | `docker-compose.yml` *(pre-filled with GHCR URL)* | `flutter build web --release`<br>Docker build & push to `ghcr.io/${OWNER}/monster-lab-web:${TAG}` & `:latest` |

## Repository CI baseline

The local gate must stay aligned with the workflows under `.github/workflows/`, especially:
- `.github/workflows/ci.yml` (validates formatting, static analysis, unit/widget tests, curriculum integrity, and Docker web build)
- `.github/workflows/release.yml` (compiles and packages the full multi-platform release matrix, pushes container to GHCR, attaches `monster-lab-keyring.gpg` and pre-filled `docker-compose.yml`, verifies the naming schema, and publishes the GitHub Release)

When workflows change, the workflow auditor must update the gate instructions and affected validators before the next release push.
