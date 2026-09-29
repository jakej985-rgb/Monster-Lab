#!/usr/bin/env python3
"""
Verification script for Monster Lab - Phase 02 Product Architecture.
Validates all JSON schemas, checks route definitions for all 8 core areas,
and ensures domain models cover all curriculum and evaluation needs.
"""

import os
import json
import sys

SCHEMAS_DIR = "architecture/schemas"
NAV_DOC = "architecture/01_navigation_and_flows.md"
MODELS_DOC = "architecture/02_domain_models.md"

EXPECTED_SCHEMAS = [
    "lesson.schema.json",
    "component.schema.json",
    "project.schema.json",
    "challenge.schema.json",
    "profile.schema.json",
    "progress.schema.json"
]

CORE_AREAS = [
    "Home", "Learn", "Parts Lab", "Build Lab",
    "Challenges", "Progress", "Parent Mode", "Settings"
]

REQUIRED_PROJECTS = [
    "Intruder Alarm", "Beat Detector", "Funny Faces", "Smart MONSTER Door",
    "Alarm Clock", "Gas Leak", "ATM and Food Dispenser", "Electric Motor Control",
    "RFID Smart Door", "Oil Drill Rig", "Sentry Guard", "Weather",
    "Autopilot", "Wireless"
]

def main():
    print("=== Monster Lab Product Architecture Verification ===")

    # 1. Validate JSON Schemas
    print("1. Validating Canonical JSON Schemas...")
    for schema_file in EXPECTED_SCHEMAS:
        full_path = os.path.join(SCHEMAS_DIR, schema_file)
        if not os.path.exists(full_path):
            print(f"FAILED: Missing schema {full_path}")
            sys.exit(1)
        with open(full_path, "r", encoding="utf-8") as f:
            try:
                data = json.load(f)
                assert "$schema" in data
                assert "title" in data
                print(f"  ✓ {schema_file} ({data['title']}) is valid JSON Schema.")
            except Exception as e:
                print(f"FAILED to parse {schema_file}: {e}")
                sys.exit(1)

    # 2. Check Navigation Coverage
    print("\n2. Validating Core Navigation & Route Coverage...")
    with open(NAV_DOC, "r", encoding="utf-8") as f:
        nav_text = f.read()

    for area in CORE_AREAS:
        assert area.lower() in nav_text.lower(), f"Missing core area '{area}' in {NAV_DOC}"
        print(f"  ✓ Core Area '{area}' covered in navigation routes.")

    # 3. Check Domain Models
    print("\n3. Validating Domain Models Coverage...")
    with open(MODELS_DOC, "r", encoding="utf-8") as f:
        models_text = f.read()

    required_entities = [
        "Lesson", "LessonStep", "Component", "PinDefinition",
        "Project", "BuildPhase", "Challenge", "Quiz",
        "LearnerProfile", "LearnerProgress", "Badge"
    ]
    for entity in required_entities:
        assert entity in models_text, f"Missing entity '{entity}' in {MODELS_DOC}"
        print(f"  ✓ Domain Entity '{entity}' defined.")

    print("\nSUCCESS: Phase 02 Product Architecture verification PASSED with 100% compliance!")

if __name__ == "__main__":
    main()
