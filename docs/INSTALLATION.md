# Monster Lab - Platform Installation Guide

This guide covers downloading, installing, and deploying pre-built releases of **Monster Lab** across supported platforms.

> If you want to compile and package Monster Lab from source code, see the [Build and Install from Source Guide](BUILD_AND_INSTALL.md).

---

## System Requirements

- **Supported Platforms**:
  - **Android**: Android 5.0 (Lollipop, API Level 21) or newer; tablets and phones.
  - **Web**: Modern Evergreen browsers (Chrome 89+, Edge 89+, Safari 16+, Firefox 100+) supporting WebAssembly and CanvasKit.
  - **Linux Desktop**: 64-bit Linux (Debian 11+, Ubuntu 20.04+, Linux Mint, Fedora, Arch).
  - **Windows Desktop**: 64-bit Windows 10 or Windows 11.

---

## 1. Web Deployment (Docker Compose & GHCR)

Monster Lab provides an official container image on GitHub Container Registry (GHCR) powered by Nginx Alpine, configured with Single Page Application (SPA) fallback routing, WASM headers, and health checks.

### Quick Start with Docker Compose (Recommended)

1. Download the pre-configured `docker-compose.yml` directly from the [Latest GitHub Release](https://github.com/jakej985-rgb/Monster-Lab/releases/latest):
   ```bash
   curl -fsSLO https://github.com/jakej985-rgb/Monster-Lab/releases/latest/download/docker-compose.yml
   ```

2. Start the container in detached mode:
   ```bash
   docker compose up -d
   ```
   Docker will automatically pull `ghcr.io/jakej985-rgb/monster-lab-web:latest` and start serving on port `8080`.

3. Open **`http://localhost:8080`** in any modern web browser.

### Hardware Companion (Simulation Only)

The Hardware Companion currently runs the built-in virtual simulator on every platform, including the web build. Real USB/Web Serial connections are not enabled in this release.

### Running Directly via Docker CLI

```bash
docker run -d \
  --name monster-lab-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/jakej985-rgb/monster-lab-web:latest
```

### Health Check Endpoint

The container includes a built-in health probe:
```bash
curl http://localhost:8080/healthz
# Returns: 200 OK
```

---

## 2. Android Installation

Monster Lab distributes official Android binaries for direct sideloading and Google Play installation.

### Sideloading APK

1. Download **`monster-lab-android.apk`** from the [GitHub Releases](https://github.com/jakej985-rgb/Monster-Lab/releases) page.
2. Transfer the APK to your Android device or install directly via ADB:
   ```bash
   adb install -r monster-lab-android.apk
   ```
3. If installing directly on the device, allow *Install from Unknown Sources* when prompted by Android.

### Hardware Companion Permissions (USB OTG)

The Android build exposes the Hardware Companion with simulated serial boards only. It does not open a physical USB OTG/serial transport, so Android will not show a USB-device authorization prompt. The simulator is useful for learning commands and telemetry without hardware. Real USB serial is not available on any platform in this release.

---

## 3. Linux Desktop Installation

Monster Lab provides a Debian package (`.deb`) and a standalone portable tarball (`.tar.gz`).

### Installing via Debian Package (`.deb`)

1. Download **`monster-lab-linux.deb`** from [GitHub Releases](https://github.com/jakej985-rgb/Monster-Lab/releases).
2. Install with `apt` (which automatically resolves system dependencies):
   ```bash
   sudo apt install ./monster-lab-linux.deb
   ```
   *(Or using dpkg: `sudo dpkg -i monster-lab-linux.deb && sudo apt-get install -f`)*

The package automatically sets up:
- Executable binary in `/usr/lib/monster-lab/` and launcher at `/usr/bin/monster-lab`.
- Desktop menu item in `/usr/share/applications/monster-lab.desktop`.
- High-resolution application icons in `/usr/share/icons/hicolor/256x256/apps/`.
- Official 50-year OpenPGP archive signing keyring at `/etc/apt/keyrings/m3tal-archive-keyring.gpg` and `/usr/share/keyrings/`.
- Central APT repository configuration at `/etc/apt/sources.list.d/m3tal.list`.

### Central APT Repository & Keyring Setup

To install or receive automatic updates from the central M3tal APT repository:

1. **Install Prerequisites**:
   ```bash
   sudo apt-get update && sudo apt-get install -y curl gnupg
   ```

2. **Install the Canonical 50-Year Keyring**:
   ```bash
   sudo install -d -m 0755 /etc/apt/keyrings
   curl -fsSL https://jakej985-rgb.github.io/m3tal-apt-key/public.key | sudo gpg --dearmor -o /etc/apt/keyrings/m3tal-archive-keyring.gpg
   sudo chmod 0644 /etc/apt/keyrings/m3tal-archive-keyring.gpg
   ```

3. **Verify Key Fingerprint**:
   ```bash
   gpg --dry-run --show-keys /etc/apt/keyrings/m3tal-archive-keyring.gpg
   # Expected Fingerprint: 5F84 FE50 A401 11C9 8141  0E11 775A D147 3BF2 5102
   # Lifespan: 50 years (Expires 2076-09-25)
   ```

4. **Configure Repository Source & Install**:
   ```bash
   echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/m3tal-archive-keyring.gpg] https://jakej985-rgb.github.io/m3tal-apt-key stable main" | sudo tee /etc/apt/sources.list.d/m3tal.list > /dev/null
   sudo apt-get update
   sudo apt-get install -y monster-lab
   ```

### Running the Portable Tarball

1. Download **`monster-lab-linux-portable.tar.gz`**.
2. Extract and launch:
   ```bash
   tar -xzf monster-lab-linux-portable.tar.gz
   ./monster_lab
   ```

### Hardware Companion

The Linux desktop build uses the virtual simulator only; no serial-port permissions (such as the `dialout` group) are required.

---

## 4. Windows Desktop Installation

Monster Lab provides a graphical setup installer (`.exe`) and a standalone portable zip archive.

### Graphical Setup Installer (`.exe`)

1. Download **`monster-lab-windows.exe`** from [GitHub Releases](https://github.com/jakej985-rgb/Monster-Lab/releases).
2. Double-click `monster-lab-windows.exe` to start the installation wizard.
3. Follow the wizard steps:
   - Choose destination directory (default: `C:\Program Files\Monster Lab` or `%LOCALAPPDATA%`).
   - Choose whether to create a Desktop shortcut.
   - Click **Install**.
4. Launch Monster Lab from the Start Menu or Desktop shortcut.
5. Clean uninstallation is available at any time via Windows *Add or Remove Programs*.

### Portable ZIP Archive

1. Download **`monster-lab-windows-portable.zip`**.
2. Extract the ZIP archive to any folder (e.g. `C:\MonsterLab` or a USB drive).
3. Double-click **`monster_lab.exe`** to run immediately without administrative privileges.

---

## Release Asset Quick Reference
 
Each official GitHub Release provides both **semantic versioned packages** (e.g. `monster-lab-v0.1.0-android.apk`) and **convenience permalink aliases** (e.g. `monster-lab-android.apk`):

| Platform | Versioned Release Asset | Static Permalink Alias | Format |
| :--- | :--- | :--- | :--- |
| **Android** | `monster-lab-v<version>-android.apk` | `monster-lab-android.apk` | Sideload APK |
| **Android** | `monster-lab-v<version>-android.aab` | `monster-lab-android.aab` | Google Play Store Bundle |
| **Linux** | `monster-lab-v<version>-linux.deb` | `monster-lab-linux.deb` | Debian Package with Embedded Keyring |
| **Linux** | `monster-lab-v<version>-linux.deb.asc` | `monster-lab-linux.deb.asc` | Detached OpenPGP Signature (50-Yr Key) |
| **Linux** | `monster-lab-v<version>-linux-portable.tar.gz` | `monster-lab-linux-portable.tar.gz` | Standalone Portable Archive |
| **Linux** | — | `m3tal-archive-keyring.gpg` | Canonical 50-Year OpenPGP Public Keyring |
| **Windows** | `monster-lab-v<version>-windows.exe` | `monster-lab-windows.exe` | Graphical Setup Wizard Installer |
| **Windows** | `monster-lab-v<version>-windows-portable.zip` | `monster-lab-windows-portable.zip` | Standalone Portable ZIP |
| **Web** | — | `docker-compose.yml` | Pre-configured GHCR Compose File |
