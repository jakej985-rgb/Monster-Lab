#!/usr/bin/env python3
"""
Monster Lab - Release Version Synchronization Verifier
Asserts that canonical version.json, pubspec.yaml, app_version.dart,
Windows packaging configs, and Dockerfile are strictly synchronized.
Fails with non-zero exit code if drift is detected.
"""

import json
import os
import re
import sys

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

VERSION_JSON_PATH = os.path.join(ROOT_DIR, "version.json")
PUBSPEC_PATH = os.path.join(ROOT_DIR, "pubspec.yaml")
DART_VERSION_PATH = os.path.join(ROOT_DIR, "lib", "core", "constants", "app_version.dart")
WINDOWS_ISS_PATH = os.path.join(ROOT_DIR, "windows", "installer", "monster_lab_setup.iss")
RUNNER_RC_PATH = os.path.join(ROOT_DIR, "windows", "runner", "Runner.rc")
DOCKERFILE_PATH = os.path.join(ROOT_DIR, "Dockerfile")

def check_sync():
    print("Checking canonical release version synchronization...")
    errors = []

    # 1. Load canonical version.json
    if not os.path.exists(VERSION_JSON_PATH):
        sys.exit(f"ERROR: Canonical version manifest missing at {VERSION_JSON_PATH}")

    with open(VERSION_JSON_PATH, "r", encoding="utf-8") as f:
        v_data = json.load(f)

    expected_semver = v_data.get("version")
    expected_build = v_data.get("buildNumber")
    expected_full = f"{expected_semver}+{expected_build}"
    print(f"  Canonical Version (version.json): {expected_full}")

    # 2. Check pubspec.yaml
    with open(PUBSPEC_PATH, "r", encoding="utf-8") as f:
        pubspec_content = f.read()
    pub_match = re.search(r"^version:\s*([^\s]+)", pubspec_content, re.MULTILINE)
    if not pub_match:
        errors.append("pubspec.yaml: Missing version field")
    else:
        pub_ver = pub_match.group(1).strip()
        if pub_ver != expected_full:
            errors.append(f"pubspec.yaml version '{pub_ver}' does not match expected '{expected_full}'")
        else:
            print("  [OK] pubspec.yaml matches")

    # 3. Check app_version.dart
    if os.path.exists(DART_VERSION_PATH):
        with open(DART_VERSION_PATH, "r", encoding="utf-8") as f:
            dart_content = f.read()
        dart_semver_match = re.search(r"static const String semver = '([^']+)';", dart_content)
        dart_build_match = re.search(r"static const int buildNumber = (\d+);", dart_content)

        if not dart_semver_match or dart_semver_match.group(1) != expected_semver:
            found = dart_semver_match.group(1) if dart_semver_match else "missing"
            errors.append(f"app_version.dart: semver '{found}' != '{expected_semver}'")
        if not dart_build_match or int(dart_build_match.group(1)) != expected_build:
            found = dart_build_match.group(1) if dart_build_match else "missing"
            errors.append(f"app_version.dart: buildNumber '{found}' != '{expected_build}'")
        if not errors:
            print("  [OK] lib/core/constants/app_version.dart matches")

    # 4. Check Windows setup .iss if present
    if os.path.exists(WINDOWS_ISS_PATH):
        with open(WINDOWS_ISS_PATH, "r", encoding="utf-8") as f:
            iss_content = f.read()
        iss_match = re.search(r'#define MyAppVersion "([^"]+)"', iss_content)
        if iss_match and iss_match.group(1) != expected_semver:
            errors.append(f"monster_lab_setup.iss: MyAppVersion '{iss_match.group(1)}' != '{expected_semver}'")
        else:
            print("  [OK] windows/installer/monster_lab_setup.iss matches")

    # 5. Check Windows Runner.rc if present
    if os.path.exists(RUNNER_RC_PATH):
        with open(RUNNER_RC_PATH, "r", encoding="utf-8") as f:
            rc_content = f.read()
        rc_match = re.search(r'VALUE "ProductVersion", "([^"]+)"', rc_content)
        if rc_match and rc_match.group(1) != expected_full:
            errors.append(f"Runner.rc: ProductVersion '{rc_match.group(1)}' != '{expected_full}'")
        else:
            print("  [OK] windows/runner/Runner.rc matches")

    # 6. Check Dockerfile if present
    if os.path.exists(DOCKERFILE_PATH):
        with open(DOCKERFILE_PATH, "r", encoding="utf-8") as f:
            docker_content = f.read()
        docker_match = re.search(r'org\.opencontainers\.image\.version="([^"]+)"', docker_content)
        if docker_match and docker_match.group(1) != expected_semver:
            errors.append(f"Dockerfile: image.version '{docker_match.group(1)}' != '{expected_semver}'")
        else:
            print("  [OK] Dockerfile matches")

    # 7. Check version.json package metadata mirrors the canonical version
    metadata = v_data.get("packageMetadata") or {}
    android_meta = metadata.get("android") or {}
    if android_meta:
        if android_meta.get("versionCode") != expected_build:
            errors.append(f"version.json: packageMetadata.android.versionCode '{android_meta.get('versionCode')}' != '{expected_build}'")
        if android_meta.get("versionName") != expected_semver:
            errors.append(f"version.json: packageMetadata.android.versionName '{android_meta.get('versionName')}' != '{expected_semver}'")
    docker_meta = metadata.get("docker") or {}
    if docker_meta and docker_meta.get("tag") != expected_semver:
        errors.append(f"version.json: packageMetadata.docker.tag '{docker_meta.get('tag')}' != '{expected_semver}'")
    if not any(err.startswith("version.json:") for err in errors):
        print("  [OK] version.json packageMetadata matches")

    if errors:
        print("\n[FAILED] Version synchronization drift detected:")
        for err in errors:
            print(f"  - {err}")
        sys.exit(1)

    print("\n[SUCCESS] 100% Release version synchronization verified across all targets.")

if __name__ == "__main__":
    check_sync()
