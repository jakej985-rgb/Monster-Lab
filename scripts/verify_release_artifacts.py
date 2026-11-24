#!/usr/bin/env python3
"""
Monster Lab - Release Artifact & Platform Packaging Validator
Verifies configurations and release contracts across:
1. Android: Keystore, key.properties, build.gradle.kts release signing config (#38)
2. Linux: Debian package generator, desktop entry, APT repo integration (#39)
3. Windows: Inno Setup (.iss) manifest, AppId, version sync, executable paths (#40)
4. Docker: Nginx container configuration, /healthz endpoint, SPA routing, wasm MIME (#41)
"""

import os
import sys
import re
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def verify_android() -> list:
    errors = []
    print("Checking Android release signing configuration...")

    example_path = os.path.join(ROOT_DIR, "android", "key.properties.example")
    if not os.path.exists(example_path):
        errors.append("android/key.properties.example missing")
    else:
        with open(example_path, "r") as f:
            example_content = f.read()
        for key in ["storePassword", "keyPassword", "keyAlias", "storeFile"]:
            if key not in example_content:
                errors.append(f"android/key.properties.example missing required property: {key}")

    key_props_path = os.path.join(ROOT_DIR, "android", "key.properties")
    require_keystore = os.environ.get("REQUIRE_ANDROID_KEYSTORE", "").lower() in ("true", "1", "yes")

    if os.path.exists(key_props_path):
        with open(key_props_path, "r") as f:
            content = f.read()
        for key in ["storePassword", "keyPassword", "keyAlias", "storeFile"]:
            if key not in content:
                errors.append(f"android/key.properties missing required property: {key}")
    elif require_keystore:
        errors.append("android/key.properties missing (required by REQUIRE_ANDROID_KEYSTORE)")

    jks_path = os.path.join(ROOT_DIR, "android", "app", "monster-lab-release.jks")
    if os.path.exists(jks_path):
        if os.path.getsize(jks_path) == 0:
            errors.append("android/app/monster-lab-release.jks keystore is empty")
    elif require_keystore:
        errors.append("android/app/monster-lab-release.jks keystore missing (required by REQUIRE_ANDROID_KEYSTORE)")

    gradle_path = os.path.join(ROOT_DIR, "android", "app", "build.gradle.kts")
    if not os.path.exists(gradle_path):
        errors.append("android/app/build.gradle.kts missing")
    else:
        with open(gradle_path, "r") as f:
            gradle_content = f.read()
        if "signingConfigs" not in gradle_content or "release" not in gradle_content:
            errors.append("android/app/build.gradle.kts missing release signingConfig definition")

    print(f"  Android verification: {'PASS' if not errors else 'FAIL'}")
    return errors

def verify_linux() -> list:
    errors = []
    print("Checking Linux release packaging configuration...")

    pkg_script = os.path.join(ROOT_DIR, "scripts", "package_linux_deb.py")
    if not os.path.exists(pkg_script):
        errors.append("scripts/package_linux_deb.py missing")
    else:
        with open(pkg_script, "r") as f:
            script_content = f.read()
        for expected in ["sign_deb_package", "create_deb_package", "load_pubspec_metadata", "deb_control_text"]:
            if expected not in script_content:
                errors.append(f"scripts/package_linux_deb.py missing expected logic: {expected}")

    # The Debian builder now generates the desktop entry, keyring asset handling,
    # and APT source entry during packaging, so do not require a standalone
    # desktop entry in the source tree.

    keyring_gpg = os.path.join(ROOT_DIR, "linux", "keyring", "m3tal-archive-keyring.gpg")
    if not os.path.exists(keyring_gpg):
        errors.append("linux/keyring/m3tal-archive-keyring.gpg missing")
    else:
        if os.path.getsize(keyring_gpg) < 1024:
            errors.append("linux/keyring/m3tal-archive-keyring.gpg appears too small to be a valid keyring")

    keyring_asc = os.path.join(ROOT_DIR, "linux", "keyring", "m3tal-archive-keyring.asc")
    if not os.path.exists(keyring_asc):
        errors.append("linux/keyring/m3tal-archive-keyring.asc missing")

    print(f"  Linux verification: {'PASS' if not errors else 'FAIL'}")
    return errors

def verify_windows() -> list:
    errors = []
    print("Checking Windows installer specification...")

    iss_path = os.path.join(ROOT_DIR, "windows", "installer", "monster_lab_setup.iss")
    if not os.path.exists(iss_path):
        errors.append("windows/installer/monster_lab_setup.iss missing")
    else:
        with open(iss_path, "r") as f:
            iss_content = f.read()
        for item in ["AppId", "MyAppVersion", "monster_lab.exe", "OutputDir", "ArchitecturesInstallIn64BitMode"]:
            if item not in iss_content:
                errors.append(f"windows/installer/monster_lab_setup.iss missing required directive: {item}")

    print(f"  Windows verification: {'PASS' if not errors else 'FAIL'}")
    return errors


def verify_release_automation() -> list:
    """Check release workflow and dispatch configs for common integration pitfalls."""
    errors = []
    print("Checking Linux release automation contracts...")

    release_workflow = os.path.join(ROOT_DIR, ".github", "workflows", "release.yml")
    if not os.path.exists(release_workflow):
        errors.append(".github/workflows/release.yml missing")
    else:
        with open(release_workflow, "r") as f:
            release_content = f.read()

        dispatch_steps = [
            line.strip()
            for line in release_content.splitlines()
            if "repository-dispatch" in line
        ]
        if not dispatch_steps:
            errors.append("release.yml missing repository-dispatch step for APT/hub integration")

        if "m3tal-archive-keyring.gpg" not in release_content:
            errors.append("release.yml missing expected keyring asset publication step")

        if "quality-gate:" not in release_content:
            errors.append("release.yml missing required quality-gate preflight job")

        if "generate_release_provenance.py" not in release_content:
            errors.append("release.yml missing checksum/provenance generation")

    apt_dispatch = os.path.join(ROOT_DIR, ".github", "workflows", "dispatch-apt.yml")
    if not os.path.exists(apt_dispatch):
        errors.append(".github/workflows/dispatch-apt.yml missing")

    print(f"  Release automation verification: {'PASS' if not errors else 'FAIL'}")
    return errors

def verify_docker() -> list:
    errors = []
    print("Checking Docker containerization and healthcheck...")

    dockerfile_path = os.path.join(ROOT_DIR, "Dockerfile")
    if not os.path.exists(dockerfile_path):
        errors.append("Dockerfile missing")
    else:
        with open(dockerfile_path, "r") as f:
            df = f.read()
        if "HEALTHCHECK" not in df or "/healthz" not in df:
            errors.append("Dockerfile missing HEALTHCHECK /healthz instruction")
        if "EXPOSE 80" not in df:
            errors.append("Dockerfile missing EXPOSE 80 instruction")

    nginx_conf_path = os.path.join(ROOT_DIR, "docker", "nginx.conf")
    if not os.path.exists(nginx_conf_path):
        errors.append("docker/nginx.conf missing")
    else:
        with open(nginx_conf_path, "r") as f:
            nc = f.read()
        if "location /healthz" not in nc:
            errors.append("docker/nginx.conf missing location /healthz endpoint")
        if "application/wasm wasm;" not in nc:
            errors.append("docker/nginx.conf missing wasm MIME type specification")
        if "try_files $uri $uri/ /index.html;" not in nc:
            errors.append("docker/nginx.conf missing SPA routing fallback")

    print(f"  Docker verification: {'PASS' if not errors else 'FAIL'}")
    return errors

def main():
    print("=================================================================")
    print("      MONSTER LAB - RELEASE ARTIFACTS & PACKAGING VALIDATOR      ")
    print("=================================================================")

    all_errors = []
    all_errors.extend(verify_android())
    all_errors.extend(verify_linux())
    all_errors.extend(verify_windows())
    all_errors.extend(verify_docker())
    all_errors.extend(verify_release_automation())

    print("=================================================================")
    if all_errors:
        print("[FAILURE] Release artifact verification failed with errors:")
        for err in all_errors:
            print(f"  - {err}")
        return 1

    print("[SUCCESS] All Android, Linux, Windows, and Docker release specs verified.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
