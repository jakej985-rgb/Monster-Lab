#!/usr/bin/env python3
"""
Monster Lab - Changelog Hygiene Verifier
Fails if CHANGELOG.md contains assistant attribution footers copied verbatim
from commit bodies (e.g. "Generated with Codebuff", "Co-Authored-By: ...").
"""

import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
if SCRIPT_DIR not in sys.path:
    sys.path.insert(0, SCRIPT_DIR)

from release_attribution import find_attribution_footers  # noqa: E402

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CHANGELOG_PATH = os.path.join(ROOT_DIR, "CHANGELOG.md")


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
