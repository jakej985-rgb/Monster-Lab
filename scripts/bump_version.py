#!/usr/bin/env python3
"""
Monster Lab - Automated Version Bump Script
Increments the patch version by 0.0.1 (e.g. 0.0.1 -> 0.0.2) and increments build number.
Synchronizes pubspec.yaml, app_version.dart, Windows installer, Runner.rc, and Dockerfile.
"""

import os
import sys
import re
import argparse
from datetime import datetime

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PUBSPEC_PATH = os.path.join(ROOT_DIR, "pubspec.yaml")
DART_VERSION_PATH = os.path.join(ROOT_DIR, "lib", "core", "constants", "app_version.dart")
INNO_SETUP_PATH = os.path.join(ROOT_DIR, "windows", "installer", "monster_lab_setup.iss")
RUNNER_RC_PATH = os.path.join(ROOT_DIR, "windows", "runner", "Runner.rc")
DOCKERFILE_PATH = os.path.join(ROOT_DIR, "Dockerfile")
CHANGELOG_PATH = os.path.join(ROOT_DIR, "CHANGELOG.md")

def parse_current_version():
    with open(PUBSPEC_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    match = re.search(r"^version:\s*([0-9]+\.[0-9]+\.[0-9]+)(?:\+([0-9]+))?", content, re.MULTILINE)
    if not match:
        raise ValueError("Could not parse version from pubspec.yaml")
    semver = match.group(1)
    build = int(match.group(2)) if match.group(2) else 1
    return semver, build

def bump_patch(semver: str, build: int):
    parts = [int(p) for p in semver.split(".")]
    parts[2] += 1
    new_semver = f"{parts[0]}.{parts[1]}.{parts[2]}"
    new_build = build + 1
    return new_semver, new_build

def bump_minor(semver: str, build: int):
    parts = [int(p) for p in semver.split(".")]
    parts[1] += 1
    parts[2] = 0
    new_semver = f"{parts[0]}.{parts[1]}.{parts[2]}"
    new_build = build + 1
    return new_semver, new_build

def bump_major(semver: str, build: int):
    parts = [int(p) for p in semver.split(".")]
    parts[0] += 1
    parts[1] = 0
    parts[2] = 0
    new_semver = f"{parts[0]}.{parts[1]}.{parts[2]}"
    new_build = build + 1
    return new_semver, new_build

def update_pubspec(new_semver: str, new_build: int):
    with open(PUBSPEC_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    new_version_str = f"version: {new_semver}+{new_build}"
    updated = re.sub(r"^version:\s*.*$", new_version_str, content, flags=re.MULTILINE)
    with open(PUBSPEC_PATH, "w", encoding="utf-8") as f:
        f.write(updated)
    print(f"  [OK] pubspec.yaml: {new_semver}+{new_build}")

def update_dart_version(new_semver: str, new_build: int):
    dart_content = f"""/// Application version constants for Monster Lab.
/// Automatically updated by `scripts/bump_version.py`.
class AppVersion {{
  AppVersion._();

  static const String version = '{new_semver}+{new_build}';
  static const String semver = '{new_semver}';
  static const int buildNumber = {new_build};
  static const String displayVersion = 'Version $version • Production Release';
}}
"""
    os.makedirs(os.path.dirname(DART_VERSION_PATH), exist_ok=True)
    with open(DART_VERSION_PATH, "w", encoding="utf-8") as f:
        f.write(dart_content)
    print(f"  [OK] lib/core/constants/app_version.dart: {new_semver}+{new_build}")

def update_inno_setup(new_semver: str):
    if os.path.exists(INNO_SETUP_PATH):
        with open(INNO_SETUP_PATH, "r", encoding="utf-8") as f:
            content = f.read()
        updated = re.sub(r'^#define MyAppVersion\s*".*"', f'#define MyAppVersion "{new_semver}"', content, flags=re.MULTILINE)
        with open(INNO_SETUP_PATH, "w", encoding="utf-8") as f:
            f.write(updated)
        print(f"  [OK] windows/installer/monster_lab_setup.iss: {new_semver}")

def update_runner_rc(new_semver: str):
    if os.path.exists(RUNNER_RC_PATH):
        with open(RUNNER_RC_PATH, "r", encoding="utf-8") as f:
            content = f.read()
        updated = re.sub(r'^#define VERSION_AS_STRING\s*".*"', f'#define VERSION_AS_STRING "{new_semver}"', content, flags=re.MULTILINE)
        with open(RUNNER_RC_PATH, "w", encoding="utf-8") as f:
            f.write(updated)
        print(f"  [OK] windows/runner/Runner.rc: {new_semver}")

def update_dockerfile(new_semver: str):
    if os.path.exists(DOCKERFILE_PATH):
        with open(DOCKERFILE_PATH, "r", encoding="utf-8") as f:
            content = f.read()
        updated = re.sub(r'^LABEL org\.opencontainers\.image\.version=".*"', f'LABEL org.opencontainers.image.version="{new_semver}"', content, flags=re.MULTILINE)
        with open(DOCKERFILE_PATH, "w", encoding="utf-8") as f:
            f.write(updated)
        print(f"  [OK] Dockerfile: {new_semver}")

def update_changelog(new_semver: str, new_build: int):
    if os.path.exists(CHANGELOG_PATH):
        with open(CHANGELOG_PATH, "r", encoding="utf-8") as f:
            content = f.read()
        today = datetime.now().strftime("%Y-%m-%d")
        new_header = f"## [{new_semver}+{new_build}] - {today}"
        if new_header not in content:
            entry = f"{new_header}\n- Automated push release build bump to v{new_semver}.\n\n"
            # Insert after main heading
            lines = content.splitlines(keepends=True)
            for i, line in enumerate(lines):
                if line.startswith("## ["):
                    lines.insert(i, entry)
                    break
            else:
                lines.append("\n" + entry)
            with open(CHANGELOG_PATH, "w", encoding="utf-8") as f:
                f.writelines(lines)
            print(f"  [OK] CHANGELOG.md: Added entry for {new_semver}+{new_build}")

def main():
    parser = argparse.ArgumentParser(description="Bump Monster Lab version.")
    parser.add_argument("--minor", action="store_true", help="Bump minor version (e.g. 0.0.9 -> 0.1.0)")
    parser.add_argument("--major", action="store_true", help="Bump major version (e.g. 0.1.0 -> 1.0.0)")
    parser.add_argument("--set-version", help="Explicit version to set (e.g. 0.0.1+1)")
    parser.add_argument("--current", action="store_true", help="Print current version and exit")
    args = parser.parse_args()

    current_semver, current_build = parse_current_version()

    if args.current:
        print(f"v{current_semver}+{current_build}")
        return

    if args.set_version:
        raw = args.set_version.lstrip("v")
        if "+" in raw:
            new_semver, build_str = raw.split("+", 1)
            new_build = int(build_str)
        else:
            new_semver = raw
            new_build = current_build + 1
    elif args.major:
        new_semver, new_build = bump_major(current_semver, current_build)
    elif args.minor:
        new_semver, new_build = bump_minor(current_semver, current_build)
    else:
        new_semver, new_build = bump_patch(current_semver, current_build)

    print(f"Bumping Monster Lab version: {current_semver}+{current_build} -> {new_semver}+{new_build}")
    update_pubspec(new_semver, new_build)
    update_dart_version(new_semver, new_build)
    update_inno_setup(new_semver)
    update_runner_rc(new_semver)
    update_dockerfile(new_semver)
    update_changelog(new_semver, new_build)

    print(f"\n[SUCCESS] Version bumped to v{new_semver} (build {new_build})")
    print(f"v{new_semver}")

if __name__ == "__main__":
    main()
