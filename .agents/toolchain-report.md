# Host Toolchain Report & Verified Machine Facts

**Generated**: 2026-09-29
**Host Architecture**: Linux x86_64 (Ubuntu / Linux Mint)
**Status**: All core Monster Lab tools verified on this PC

---

## 1. Verified Host Tool Paths (Exact Facts for Subagents)

All coding, validator, and gatekeeper subagents operating on this PC must use these verified executable and root paths:

| Tool | Status | Exact Verified Path | Symlink / Alternate | Verified Version | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Flutter** | **FOUND** | `/opt/flutter/bin/flutter` | `/usr/bin/flutter` | `3.47.3 (channel stable)` | Primary Flutter SDK root: `/opt/flutter` |
| **Dart** | **FOUND** | `/opt/flutter/bin/dart` | `/opt/flutter/bin/cache/dart-sdk/bin/dart` | `3.13.3 (stable)` | Bundled inside Flutter SDK |
| **Python** | **FOUND** | `/usr/bin/python3` | `/usr/bin/python3.12` | `3.12.3` | System Python 3 runtime; Pillow `10.2.0` installed |
| **Git** | **FOUND** | `/usr/bin/git` | `/usr/bin/git` | `2.55.0` | Active VCS CLI |
| **Java (JDK)** | **FOUND** | `/usr/lib/jvm/java-21-openjdk-amd64/bin/java` | `/usr/bin/java` | `openjdk 21.0.12` | JDK root: `/usr/lib/jvm/java-21-openjdk-amd64` |
| **Docker** | **FOUND** | `/usr/bin/docker` | `/usr/bin/docker` | `29.8.1` | Daemon socket active and healthy |
| **Node.js** | **FOUND** | `/usr/bin/node` | `/usr/bin/node` | `v20.20.2` | Active JavaScript runtime |

---

## 2. Missing Tools (Do NOT Attempt Installation)

The following tools are **NOT INSTALLED** on this host PC:

* **Android SDK / ADB**: Not present locally on disk.
  * *Policy*: Do **not** install or download via apt/sdkmanager.
* **Google Chrome / Chromium**: Not present globally on PATH.
  * *Policy*: For web compilation use `flutter build web --release`. Headless browser tests run in CI.

---

## 3. Subagent Instruction: Direct Execution Factsheet

When any agent runs commands on this PC:
1. **Never guess or search blindly**.
2. **Execute directly using the verified paths** above:
   * To run Flutter: use `/opt/flutter/bin/flutter`.
   * To run Dart: use `/opt/flutter/bin/dart` or `/opt/flutter/bin/cache/dart-sdk/bin/dart`.
   * To run Python (curriculum validator & asset generation): use `/usr/bin/python3`.
   * To run Docker: use `/usr/bin/docker`.
   * To run Git: use `/usr/bin/git`.
3. **Never attempt to install missing prerequisites**. Report missing requirements to the user.
