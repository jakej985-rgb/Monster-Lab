#!/usr/bin/env python3
"""
Monster Lab - Changelog Hygiene Verifier
Fails if CHANGELOG.md contains assistant attribution footers copied verbatim
from commit bodies (e.g. "Generated with Codebuff", "Co-Authored-By: ...").
"""

import os
import re
import sys

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CHANGELOG_PATH = os.path.join(ROOT_DIR, "CHANGELOG.md")

ASSISTANT_NAMES = r"(?:codebuff|claude|copilot|chatgpt|cursor|aider|devin)"

ATTRIBUTION_PATTERNS = (
    re.compile(r"🤖"),
    re.compile(rf"(?i)\bgenerated with\b[^\n]*\b{ASSISTANT_NAMES}\b"),
    re.compile(rf"(?i)\bco-authored-by:\s*{ASSISTANT_NAMES}\b"),
)


def find_attribution_footers(lines):
    findings = []
    for number, line in enumerate(lines, 1):
        if any(pattern.search(line) for pattern in ATTRIBUTION_PATTERNS):
            findings.append((number, line.strip()))
    return findings


def main():
    print("Checking CHANGELOG.md for assistant attribution footers...")
    if not os.path.exists(CHANGELOG_PATH):
        sys.exit(f"ERROR: CHANGELOG.md missing at {CHANGELOG_PATH}")

    with open(CHANGELOG_PATH, "r", encoding="utf-8") as handle:
        findings = find_attribution_footers(handle.readlines())

    if findings:
        print("\n[FAILED] Assistant attribution footers found in CHANGELOG.md:")
        for number, line in findings:
            print(f"  line {number}: {line[:160]}")
        print(
            "\nDrop these trailers from commit bodies; "
            "scripts/generate_release_changelog.py strips them automatically."
        )
        sys.exit(1)

    print("\n[SUCCESS] No assistant attribution footers in CHANGELOG.md.")


if __name__ == "__main__":
    main()
