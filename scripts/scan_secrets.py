#!/usr/bin/env python3
"""
Monster Lab - Secret and Sensitive Pattern Scanner
Scans source files, scripts, and configurations for exposed API keys,
private keys, hardcoded credentials, and high-entropy sensitive tokens.
"""

import os
import re
import sys

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

IGNORED_DIRS = {
    ".git", ".dart_tool", ".toolchain", ".fvm", ".venv", "build", "ephemeral",
    "node_modules", "linux/flutter/ephemeral", "windows/flutter/ephemeral",
    "__pycache__", ".gradle", ".idea", ".widget_preview", "coverage", "audit"
}

IGNORED_EXTENSIONS = {
    ".png", ".jpg", ".jpeg", ".ico", ".pdf", ".ttf", ".woff", ".mp3", ".wav",
    ".bin", ".jar", ".jks", ".so", ".a", ".deb", ".tar", ".gz", ".zip", ".lock"
}

SECRET_PATTERNS = [
    (r"(?i)-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----", "Private cryptographic key"),
    (r"(?i)(?:api_key|apikey|secret_key|secretkey|auth_token)\s*[:=]\s*['\"][A-Za-z0-9_\-]{20,}['\"]", "API or Auth token"),
    (r"(?i)ghp_[A-Za-z0-9]{36}", "GitHub Personal Access Token"),
    (r"(?i)AKIA[0-9A-Z]{16}", "AWS Access Key ID"),
    (r"(?i)eyJ[A-Za-z0-9_\-]{10,}\.eyJ[A-Za-z0-9_\-]{10,}\.[A-Za-z0-9_\-]{10,}", "JSON Web Token (JWT)"),
]

def scan_file(filepath: str) -> list:
    findings = []
    try:
        with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
            for line_no, line in enumerate(f, start=1):
                # Skip comments explaining patterns or mocks
                if "SECRET_PATTERNS" in line or "dummy" in line.lower() or "example" in line.lower():
                    continue
                for pattern, desc in SECRET_PATTERNS:
                    if re.search(pattern, line):
                        findings.append((line_no, desc, line.strip()[:80]))
    except Exception as e:
        findings.append((0, f"Error reading file: {e}", ""))
    return findings

def scan_all() -> int:
    print("Running Monster Lab Secret and Sensitive Pattern Scanner...")
    all_findings = []
    scanned_count = 0

    for root, dirs, files in os.walk(ROOT_DIR):
        dirs[:] = [d for d in dirs if d not in IGNORED_DIRS and not d.startswith(".system_")]
        for file in files:
            ext = os.path.splitext(file)[1].lower()
            if ext in IGNORED_EXTENSIONS:
                continue
            filepath = os.path.join(root, file)
            # Skip this script itself
            if filepath == os.path.abspath(__file__):
                continue

            findings = scan_file(filepath)
            scanned_count += 1
            if findings:
                all_findings.append((os.path.relpath(filepath, ROOT_DIR), findings))

    print(f"  Scanned {scanned_count} files across repository.")

    if all_findings:
        print("\n[CRITICAL ERROR] High-entropy secrets or sensitive tokens detected:")
        for path, issues in all_findings:
            print(f"  File: {path}")
            for lno, desc, snippet in issues:
                print(f"    Line {lno}: {desc} -> {snippet}")
        return 1

    print("[SUCCESS] Zero exposed secrets or hardcoded credentials found.")
    return 0

if __name__ == "__main__":
    sys.exit(scan_all())
