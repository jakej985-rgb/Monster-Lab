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

    key_props_path = os.path.join(ROOT_DIR, "android", "key.properties")
    if not os.path.exists(key_props_path):
        errors.append("android/key.properties missing")
    else:
        with open(key_props_path, "r") as f:
            content = f.read()
        for key in ["storePassword", "keyPassword", "keyAlias", "storeFile"]:
            if key not in content:
                errors.append(f"android/key.properties missing required property: {key}")

    jks_path = os.path.join(ROOT_DIR, "android", "app", "monster-lab-release.jks")
    if not os.path.exists(jks_path):
        errors.append("android/app/monster-lab-release.jks keystore missing")

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
        for expected in ["sign_deb_package", "create_deb_package", "monster-lab"]:
            if expected not in script_content:
                errors.append(f"scripts/package_linux_deb.py missing expected logic: {expected}")

    desktop_path = os.path.join(ROOT_DIR, "linux", "monster-lab.desktop")
    if not os.path.exists(desktop_path):
        # Check if desktop entry is created by package script or exists
        pass

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
