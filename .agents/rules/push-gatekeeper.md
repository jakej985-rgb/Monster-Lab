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
- Only the Push Gatekeeper is authorized to execute `git push` from the local workspace. `.github/workflows/release.yml` is the automated exception and may push only its synchronized release commit and tag.
- Validation results are tied to the exact working-tree/commit state that was tested.
- Any code, configuration, platform runner (`android/`, `linux/`, `windows/`), dependency, generated-source, curriculum dataset, or workflow change after validation invalidates the previous result.
- **Active Diagnostics & Auto-Repair**: If any check fails (locally or remotely), do not simply halt and say "PUSH BLOCKED". Actively diagnose the error, repair it (or invoke `repair-agent`), and retry validation up to 3 repair cycles.
- **Mandatory Remote CI/Release Monitoring**: After pushing, the Push Gatekeeper MUST monitor the remote GitHub Actions workflow runs until completion. To conserve API quota, system resources, and context tokens during multi-platform builds (which typically take 8–15 minutes), the gatekeeper MUST NOT poll in rapid loops. Always supply `--interval 120` or `--interval 180` to `gh run watch` (e.g. `gh run watch <run-id> --interval 120 --exit-status`), or pause initial status inquiries by 6–8 minutes before checking. If any remote job fails (e.g. Android R8, Linux packaging, Windows compilation, Docker GHCR push, or GitHub Release asset publishing), the gatekeeper must immediately inspect the failure log (`gh run view --log-failed`), apply the fix locally, re-run all local validation, and ensure the release is completely green.
- Never bypass a failing test, analyzer, formatter, curriculum integrity check, platform build, or CI-equivalent build to make the gate green.
- Never force-push unless the user explicitly authorizes it.
- Never commit secrets, credentials, signing keys, keystores, generated build output (`build/`, `.dart_tool/`, `*.apk`, `*.aab`, `*.deb`, `*.exe`, `*.tar.gz`, `*.zip`), or temporary test artifacts.
- Enforce strict child-safe and zero-telemetry rules: Monster Lab must remain 100% offline, privacy-compliant (COPPA/FERPA), with no unvetted external HTTP/telemetry endpoints across Android, Linux, Windows, or Web.

## Versioning Protocol (Smart Bump on Every Push)

- Starting version baseline is **`v0.0.1`** (`0.0.1+1`).
- **Every push to `main` is a release**: `.github/workflows/release.yml` runs `python3 scripts/bump_version.py --auto`, which chooses major, minor, or patch from the commits since the previous tag using the smart bump system.
- **The release workflow owns versioning**: do not run `bump_version.py --auto` with `--apply` or create/push release tags from the local gate. Push the validated source commit; the workflow creates the release commit, tag, and atomic push. Local validation should verify the current sources, not create a second release commit.
  - To preview the next smart bump without writing files, run `python3 scripts/generate_release_changelog.py --bump auto`.
  - The smart bump automatically synchronizes:
    - `version.json` (including package metadata)
    - `pubspec.yaml`
    - `lib/core/constants/app_version.dart`
    - `windows/installer/monster_lab_setup.iss`
    - `windows/runner/Runner.rc`
    - `Dockerfile`
    - `CHANGELOG.md`
  - **Release Changelog Generation**: The smart bump delegates to `scripts/generate_release_changelog.py --bump auto --apply`, ensuring release notes are generated and published.
  - Every release commit is tagged with `v[semver]` (e.g. `v0.0.1`, `v0.0.2`, `v0.1.1`). The workflow commits the synchronized version files, tags the result, and pushes the commit and tag atomically.
  - The release workflow skips its own `chore(release):` commit and commit messages containing `[skip release]`, preventing a bump loop.

## Supported Multi-Platform Builds & Release Artifact Matrix

The web version is strictly containerized as Docker and published to GitHub Container Registry (GHCR). All OS release packages strictly conform to the versioned naming format:
`monster-lab-v[version]-[os].[ext]` and `monster-lab-v[version]-[os]-portable.[ext]`. Unversioned duplicate packages are strictly prohibited to avoid user confusion and download ambiguity.

| Target Platform | Package / Installer (`monster-lab-v[version]-[os].[ext]`) | Portable Bundle (`monster-lab-v[version]-[os]-portable.[ext]`) | Additional Release Assets | Build / Packaging Mechanism |
| :--- | :--- | :--- | :--- | :--- |
| **Android** | `monster-lab-v[version]-android.apk`<br>`monster-lab-v[version]-android.aab` | — | — | `flutter build apk --release`<br>`flutter build appbundle --release` |
| **Linux** | `monster-lab-v[version]-linux.deb` | `monster-lab-v[version]-linux-portable.tar.gz` | `monster-lab-keyring.gpg` | `flutter build linux --release`<br>`python3 scripts/package_linux_deb.py` (installs GPG keyring in `/etc/apt/keyrings/` & `/usr/share/keyrings/`) |
| **Windows** | `monster-lab-v[version]-windows.exe` | `monster-lab-v[version]-windows-portable.zip` | — | `flutter build windows --release`<br>`ISCC.exe windows/installer/monster_lab_setup.iss` |
| **Web** | `ghcr.io/${OWNER}/monster-lab-web` *(GHCR Image)* | — *(Web is Docker-only)* | `docker-compose.yml` *(pre-filled with GHCR URL)* | `flutter build web --release`<br>Docker build & push to `ghcr.io/${OWNER}/monster-lab-web:${TAG}` & `:latest` |

## Repository CI baseline

The local gate must stay aligned with the workflows under `.github/workflows/`, especially:
- `.github/workflows/ci.yml` (validates formatting, static analysis, unit/widget tests, curriculum integrity, and Docker web build)
- `.github/workflows/release.yml` (compiles and packages the full multi-platform release matrix, pushes container to GHCR, attaches `monster-lab-keyring.gpg` and pre-filled `docker-compose.yml`, verifies the naming schema, and publishes the GitHub Release)

When workflows change, the workflow auditor must update the gate instructions and affected validators before the next release push.
