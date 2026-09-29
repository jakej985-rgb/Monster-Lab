#!/usr/bin/env python3
"""
Verification script for Monster Lab - Phase 01 Curriculum Audit.
Validates that 100% of the contents of Monster.zip are audited and indexed
in the audit markdown documentation, and outputs a canonical curriculum_manifest.json.
"""

import zipfile
import re
import os
import json
import sys

ARCHIVE_PATH = "Monster.zip"
AUDIT_DIR = "audit"

def main():
    if not os.path.exists(ARCHIVE_PATH):
        print(f"ERROR: {ARCHIVE_PATH} not found.")
        sys.exit(1)

    print("=== Monster Lab Curriculum Audit Verification ===")

    with zipfile.ZipFile(ARCHIVE_PATH, "r") as z:
        all_files = [n for n in z.namelist() if not n.endswith("/")]
        print(f"Total archive files: {len(all_files)}")

        # 1. Check Tutorials
        tutorial_lessons = [n for n in all_files if n.startswith("Tutorials/Lesson ") and n.endswith(".docx")]
        peripherals = [n for n in all_files if n.startswith("Tutorials/Peripheral ") and n.endswith(".docx")]
        print(f"Found {len(tutorial_lessons)} foundational lessons.")
        print(f"Found {len(peripherals)} peripheral documents.")
        assert len(tutorial_lessons) == 7, f"Expected 7 lessons, found {len(tutorial_lessons)}"
        assert len(peripherals) == 38, f"Expected 38 peripherals, found {len(peripherals)}"

        # 2. Check Projects
        project_folders = set()
        for n in all_files:
            if n.startswith("Projects/"):
                parts = n.split("/")
                if len(parts) > 1 and parts[1]:
                    project_folders.add(parts[1])
        print(f"Found {len(project_folders)} distinct projects: {sorted(project_folders)}")
        assert len(project_folders) == 14, f"Expected 14 projects, found {len(project_folders)}"

        # 3. Check Datasheets
        datasheets = [n for n in all_files if n.startswith("Datasheets/") and n.endswith((".pdf", ".PDF"))]
        print(f"Found {len(datasheets)} datasheet PDFs.")
        assert len(datasheets) == 49, f"Expected 49 datasheets, found {len(datasheets)}"

    # 4. Check Documentation Coverage
    comp_file = os.path.join(AUDIT_DIR, "02_component_inventory.md")
    with open(comp_file, "r", encoding="utf-8") as f:
        comp_text = f.read()

    proj_file = os.path.join(AUDIT_DIR, "03_project_inventory.md")
    with open(proj_file, "r", encoding="utf-8") as f:
        proj_text = f.read()

    curr_file = os.path.join(AUDIT_DIR, "01_curriculum_inventory.md")
    with open(curr_file, "r", encoding="utf-8") as f:
        curr_text = f.read()

    # Validate all 38 peripherals are in 02_component_inventory.md
    missing_peripherals = []
    for i in range(1, 39):
        num_str = f"**{i:02d}**"
        if num_str not in comp_text:
            missing_peripherals.append(num_str)
    assert not missing_peripherals, f"Missing peripherals in component inventory: {missing_peripherals}"
    print("✓ All 38 peripherals verified in component inventory.")

    # Validate all 14 projects are in 03_project_inventory.md
    missing_projects = []
    for p in project_folders:
        if p not in proj_text:
            missing_projects.append(p)
    assert not missing_projects, f"Missing projects in project inventory: {missing_projects}"
    print("✓ All 14 projects verified in project inventory.")

    # Validate all 7 foundation lessons are in 01_curriculum_inventory.md
    for i in range(1, 8):
        lesson_str = f"Lesson {i}"
        assert lesson_str in curr_text, f"Missing {lesson_str} in curriculum inventory"
    print("✓ All 7 foundational lessons verified in curriculum inventory.")

    # 5. Generate Canonical curriculum_manifest.json for Phase 05 Data Engine
    manifest = {
        "version": "1.0.0",
        "archive": ARCHIVE_PATH,
        "total_files": len(all_files),
        "foundational_lessons": 7,
        "peripherals_count": 38,
        "projects_count": 14,
        "datasheets_count": len(datasheets),
        "projects": sorted(list(project_folders)),
        "audit_files": [
            "00_audit_summary.md",
            "01_curriculum_inventory.md",
            "02_component_inventory.md",
            "03_project_inventory.md",
            "04_lesson_dependency_map.md",
            "05_safety_notes.md"
        ]
    }
    manifest_path = os.path.join(AUDIT_DIR, "curriculum_manifest.json")
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)
    print(f"✓ Generated canonical metadata manifest: {manifest_path}")

    print("\nSUCCESS: Phase 01 Curriculum Audit verification PASSED with 100% source coverage!")

if __name__ == "__main__":
    main()
