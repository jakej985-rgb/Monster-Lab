#!/usr/bin/env python3
"""
Monster Lab - Dependency Security and Integrity Scanner
Scans pubspec.lock, pubspec.yaml, and script dependencies for:
1. Pinned package integrity and official pub.dev hosted sources.
2. Insecure / vulnerable packages or known deprecated packages.
3. Git or unverified path dependencies in production blocks.
"""

import os
import sys
import yaml

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PUBSPEC_PATH = os.path.join(ROOT_DIR, "pubspec.yaml")
LOCK_PATH = os.path.join(ROOT_DIR, "pubspec.lock")

# Known advisories / forbidden insecure packages or patterns
DISALLOWED_PACKAGES = {
    "http_server",  # Deprecated in Dart ecosystem
    "safe_eval",    # Unsafe code execution in sandbox
}

# Packages requiring hosted https source
STRICT_HOSTED_HOSTS = [
    "https://pub.dev",
    "https://pub.flutter-io.cn"
]

def scan_dependencies():
    print("Running Monster Lab Dependency Security and Integrity Scanner...")
    issues = []

    if not os.path.exists(PUBSPEC_PATH):
        print(f"[ERROR] pubspec.yaml not found at {PUBSPEC_PATH}")
        return 1

    if not os.path.exists(LOCK_PATH):
        print(f"[ERROR] pubspec.lock not found at {LOCK_PATH}")
        return 1

    # Check pubspec.yaml
    with open(PUBSPEC_PATH, "r", encoding="utf-8") as f:
        pubspec = yaml.safe_load(f)

    prod_deps = pubspec.get("dependencies", {}) or {}
    dev_deps = pubspec.get("dev_dependencies", {}) or {}

    print(f"  pubspec.yaml: {len(prod_deps)} direct dependencies, {len(dev_deps)} dev dependencies.")

    # Check for disallowed direct dependencies
    for pkg in prod_deps.keys():
        if pkg in DISALLOWED_PACKAGES:
            issues.append(f"Disallowed/deprecated dependency in pubspec.yaml: {pkg}")

    # Check pubspec.lock
    with open(LOCK_PATH, "r", encoding="utf-8") as f:
        lock_data = yaml.safe_load(f)

    packages = lock_data.get("packages", {}) or {}
    print(f"  pubspec.lock: {len(packages)} locked packages analyzed.")

    hosted_count = 0
    sdk_count = 0
    for name, details in packages.items():
        source = details.get("source")
        version = details.get("version")
        desc = details.get("description", {})

        if name in DISALLOWED_PACKAGES:
            issues.append(f"Disallowed dependency locked: {name}@{version}")

        if source == "hosted":
            hosted_count += 1
            if isinstance(desc, dict):
                url = desc.get("url")
                if url and not any(url.startswith(h) for h in STRICT_HOSTED_HOSTS):
                    issues.append(f"Untrusted host URL for {name}: {url}")
                sha256 = desc.get("sha256")
                if not sha256 or len(sha256) != 64:
                    issues.append(f"Missing or invalid sha256 checksum for {name}@{version}")
        elif source == "sdk":
            sdk_count += 1
        elif source == "path":
            # Path dependency should only be internal or test
            path_val = desc.get("path") if isinstance(desc, dict) else str(desc)
            if not path_val.startswith(".") and not path_val.startswith("/"):
                issues.append(f"Suspicious path dependency {name}: {path_val}")
        else:
            issues.append(f"Non-standard package source for {name}: {source}")

    print(f"  Summary: {hosted_count} hosted (checksum-verified), {sdk_count} SDK dependencies.")

    if issues:
        print("\n[CRITICAL ERROR] Dependency integrity issues detected:")
        for issue in issues:
            print(f"  - {issue}")
        return 1

    print("[SUCCESS] All locked dependencies verified and compliant.")
    return 0

if __name__ == "__main__":
    sys.exit(scan_dependencies())
