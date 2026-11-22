# Monster Lab - Build and Install from Source Guide

This guide covers building, packaging, and installing **Monster Lab** from source code across all supported targets: **Web (Docker)**, **Android**, **Linux Desktop**, and **Windows Desktop**.

> For installing pre-compiled releases, see the [Platform Installation Guide](INSTALLATION.md).

---

## 1. Prerequisites and Toolchains

Before compiling, ensure the required SDKs and dependencies are installed for your host operating system and target platforms.

### Universal Prerequisites
- **Flutter SDK**: `3.47.3` (channel `stable`, bundled with Dart `3.13.3+`).
- **Python**: `3.11+` or `3.12+` with `Pillow` library:
  ```bash
  pip install Pillow
  ```
- **Git**: `2.x+`.

### Platform-Specific Prerequisites

#### Android Builds
- **Java Development Kit**: OpenJDK 17 or 21.
- **Android SDK**: Command-line tools, platform tools (`adb`), Android SDK Platform 34+, Build-Tools 34.0.0.
- Environment variables: `JAVA_HOME`, `ANDROID_HOME` or `ANDROID_SDK_ROOT`.

#### Linux Builds (Ubuntu / Debian / Mint)
```bash
sudo apt update
sudo apt install -y clang cmake ninja-build pkg-config libgtk-3-dev libserialport-dev dpkg-dev
```

#### Windows Builds
- Windows 10 or 11 (64-bit).
- **Visual Studio 2022**: Community edition with *"Desktop development with C++"* workload.
- **Inno Setup 6.x**: Required for compiling the `.exe` setup wizard installer:
  ```powershell
  choco install innosetup -y
  ```

#### Web Builds
- **Docker Engine** / Docker Desktop (20.10+).

---

## 2. Setting Up the Development Workspace

1. **Clone the repository**:
   ```bash
   git clone https://github.com/jakej985-rgb/Monster-Lab.git
   cd Monster-Lab
   ```

2. **Install Flutter package dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate release branding assets**:
   Generates Android mipmaps, Linux icons, Windows ICO, and Web PWA icons from the master asset:
   ```bash
   python3 scripts/generate_release_assets.py
   ```

4. **Validate curriculum integrity**:
   Verifies all 141 lessons, 54 components, 20 projects, 24 challenges, and 20 badges:
   ```bash
   python3 scripts/validate_curriculum.py
   ```

5. **Run test suite**:
   ```bash
   flutter test
   ```

6. **Launch in debug mode**:
   ```bash
   flutter run
   ```

---

## 3. Building and Packaging by Platform

### A. Web (Docker & GHCR)

The web version is compiled to WebAssembly / CanvasKit PWA and containerized with Nginx Alpine.

1. **Compile web release bundle**:
   ```bash
   flutter build web --release
   ```
   Compiled output is generated in `build/web/`.

2. **Build Docker container image**:
   ```bash
   docker build -t ghcr.io/jakej985-rgb/monster-lab-web:latest -t monster-lab-web:latest .
   ```

3. **(Optional) Push to GitHub Container Registry**:
   ```bash
   echo "$GITHUB_TOKEN" | docker login ghcr.io -u <username> --password-stdin
   docker push ghcr.io/jakej985-rgb/monster-lab-web:latest
   ```

4. **Run container locally**:
   ```bash
   docker compose up -d
   ```
   Open `http://localhost:8080`.

Web Serial hardware support requires Chrome or Edge on desktop and a secure
context (HTTPS or localhost). The Docker Compose default `http://localhost:8080`
qualifies; serving the PWA from a plain-HTTP LAN address disables real USB
access and leaves the virtual simulator available.


---

### B. Android (APK & AppBundle)

To allow seamless in-place updates without uninstalling (avoiding Android's `INSTALL_FAILED_UPDATE_INCOMPATIBLE` signature mismatch error), release APKs must be signed with a consistent keystore certificate.

#### 1. Local Signing Setup
A local release keystore is configured via `android/key.properties` (which is gitignored):
```properties
storePassword=monsterlab2026
keyPassword=monsterlab2026
keyAlias=monsterlab
storeFile=monster-lab-release.jks
```
Release builds fail if `android/key.properties` or the keystore file is absent.
Use `flutter build apk --debug` for local development; debug keys must never be published.

#### 2. GitHub Actions CI/CD Signing Setup
For automated GitHub Releases, the keystore is injected securely via GitHub Repository Secrets:
- `ANDROID_KEYSTORE_BASE64`: Base64-encoded string of `monster-lab-release.jks`
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password (`monsterlab2026`)
- `ANDROID_KEY_ALIAS`: Key alias (`monsterlab`)
- `ANDROID_KEY_PASSWORD`: Key password (`monsterlab2026`)

#### 3. Building Release Artifacts
1. **Compile Standalone APK**:
   ```bash
   flutter build apk --release
   cp build/app/outputs/flutter-apk/app-release.apk monster-lab-android.apk
   ```

2. **Compile Google Play Store Bundle**:
   ```bash
   flutter build appbundle --release
   cp build/app/outputs/bundle/release/app-release.aab monster-lab-android.aab
   ```

3. **Install / Update onto connected Android device**:
   ```bash
   adb install -r monster-lab-android.apk
   ```

---

### C. Linux Desktop (.deb & Portable Tarball)

1. **Compile Linux release bundle**:
   ```bash
   flutter build linux --release
   ```
   Compiled binary and shared libraries are created in `build/linux/x64/release/bundle/`.

2. **Synchronize Canonical GPG Keyring**:
   ```bash
   python3 scripts/generate_deb_keyring.py
   ```
   Synchronizes the official 50-year ecosystem keyring (`5F84FE50A40111C981410E11775AD1473BF25102`) to `linux/keyring/m3tal-archive-keyring.gpg`.

3. **Build and Sign Debian Package (`.deb`)**:
   ```bash
   python3 scripts/package_linux_deb.py --bundle-dir build/linux/x64/release/bundle --output monster-lab-linux.deb --sign
   ```
   This automatically embeds the binary, desktop launcher, icons, canonical `m3tal-archive-keyring.gpg`, configures `/etc/apt/sources.list.d/m3tal.list`, and creates a detached signature (`monster-lab-linux.deb.asc`).
   
   To automatically ingest and sign into the central APT repository:
   ```bash
   python3 scripts/package_linux_deb.py --bundle-dir build/linux/x64/release/bundle --output monster-lab-linux.deb --sign --push-to-apt-repo
   ```

4. **Package Portable Tarball**:
   ```bash
   tar -czf monster-lab-linux-portable.tar.gz -C build/linux/x64/release/bundle .
   ```

5. **Install locally on Linux host**:
   ```bash
   sudo apt install ./monster-lab-linux.deb
   ```

---

### D. Windows Desktop (.exe Installer & Portable ZIP)

1. **Compile Windows native release**:
   ```powershell
   flutter build windows --release
   ```
   Output is generated in `build\windows\x64\runner\Release\`.

2. **Build Graphical Setup Installer (`monster-lab-windows.exe`)**:
   ```powershell
   & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" windows\installer\monster_lab_setup.iss
   ```
   Generates `monster-lab-windows.exe` in the root repository folder.

3. **Package Portable ZIP Bundle**:
   ```powershell
   Compress-Archive -Path build\windows\x64\runner\Release\* -DestinationPath monster-lab-windows-portable.zip
   ```

4. **Install locally on Windows**:
   Run `monster-lab-windows.exe` and complete the setup wizard.

---

## 4. Automated Version Bumping & Release Quality Gates

Monster Lab follows Semantic Versioning starting at `v0.0.1` (`0.0.1+1`). Every push to `main` triggers `.github/workflows/release.yml`, which uses the smart bump to choose major, minor, or patch from the commits since the last tag, then commits, tags, pushes, and builds the release.

### Version Bumping Script
Run the same smart bump locally before a manual release if you need to inspect the result:
```bash
# Check current version
python3 scripts/bump_version.py --current

# Smart bump: derives major/minor/patch from commits since the last tag
python3 scripts/bump_version.py --auto

# Explicit semantic levels remain available for exceptional releases
python3 scripts/bump_version.py --minor
python3 scripts/bump_version.py --major
python3 scripts/bump_version.py --set-version 0.1.0+10
```
The smart bump synchronizes `version.json`, `pubspec.yaml`, `app_version.dart`, Inno Setup, Windows RC, Dockerfile, and `CHANGELOG.md`.

### Pre-Push Quality Verification
Run the standard validation gates enforced by `.agents/rules/push-gatekeeper.md`:
```bash
# Full local quality gate
bash scripts/quality_gate.sh
```

The quality gate runs formatting, static analysis, the full test suite with coverage,
the secret scan, dependency scan, curriculum validation, version/artifact/changelog contracts,
and the Python release-tool tests. All checks must pass before pushing code.
