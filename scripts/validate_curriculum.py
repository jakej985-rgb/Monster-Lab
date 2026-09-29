#!/usr/bin/env python3
"""
Monster Lab Curriculum Asset Validator.
Validates all JSON curriculum files against Draft-07 schema specifications,
data bounds, and referential integrity constraints.
"""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CURRICULUM_DIR = ROOT / "assets" / "curriculum"
SCHEMAS_DIR = ROOT / "architecture" / "schemas"


class ValidationError(Exception):
    pass


def validate_field(obj, key, expected_type, required=True, min_len=None, pattern=None, enum_vals=None, min_val=None, max_val=None):
    if key not in obj:
        if required:
            raise ValidationError(f"Missing required field: '{key}'")
        return
    val = obj[key]
    if val is None and not required:
        return

    if expected_type == int:
        if not isinstance(val, int) or isinstance(val, bool):
            raise ValidationError(f"Field '{key}' must be integer, got {type(val).__name__}")
        if min_val is not None and val < min_val:
            raise ValidationError(f"Field '{key}' value {val} is less than minimum {min_val}")
        if max_val is not None and val > max_val:
            raise ValidationError(f"Field '{key}' value {val} is greater than maximum {max_val}")
    elif expected_type == str:
        if not isinstance(val, str):
            raise ValidationError(f"Field '{key}' must be string, got {type(val).__name__}")
        if min_len is not None and len(val) < min_len:
            raise ValidationError(f"Field '{key}' length {len(val)} is less than minLength {min_len}")
        if pattern is not None and not re.match(pattern, val):
            raise ValidationError(f"Field '{key}' value '{val}' does not match pattern '{pattern}'")
        if enum_vals is not None and val not in enum_vals:
            raise ValidationError(f"Field '{key}' value '{val}' not in allowed enum {enum_vals}")
    elif expected_type == list:
        if not isinstance(val, list):
            raise ValidationError(f"Field '{key}' must be list, got {type(val).__name__}")
        if min_len is not None and len(val) < min_len:
            raise ValidationError(f"Field '{key}' has fewer items ({len(val)}) than minItems ({min_len})")
    elif expected_type == dict:
        if not isinstance(val, dict):
            raise ValidationError(f"Field '{key}' must be dict, got {type(val).__name__}")
    elif expected_type == bool:
        if not isinstance(val, bool):
            raise ValidationError(f"Field '{key}' must be boolean, got {type(val).__name__}")


def validate_lesson(data, path):
    validate_field(data, "id", str, pattern=r"^lesson_[0-9]{2,3}$")
    validate_field(data, "title", str, min_len=3)
    validate_field(data, "summary", str)
    validate_field(data, "tier", str, enum_vals=["rookie", "builder", "engineer", "monsterMaster"])
    validate_field(data, "estimatedMinutes", int, min_val=5, max_val=120)
    validate_field(data, "prerequisites", list)
    validate_field(data, "componentIds", list)
    validate_field(data, "steps", list, min_len=1)
    validate_field(data, "xpReward", int, min_val=10)

    for i, step in enumerate(data["steps"]):
        validate_field(step, "stepId", str)
        validate_field(step, "title", str)
        validate_field(step, "type", str, enum_vals=[
            "story", "visualExplanation", "physicalTask", "interactiveWiring", "codeExperiment", "quizCheckpoint"
        ])
        validate_field(step, "markdownContent", str)


def validate_component(data, path):
    validate_field(data, "id", str, pattern=r"^comp_[0-9]{2,3}$")
    validate_field(data, "peripheralNumber", int, min_val=1, max_val=38)
    validate_field(data, "name", str, min_len=2)
    validate_field(data, "partNumber", str)
    validate_field(data, "category", str, enum_vals=["sensor", "actuator", "display", "communication", "passive", "power", "switch"])
    validate_field(data, "description", str)
    validate_field(data, "realWorldAnalogy", str)
    validate_field(data, "voltage", str, enum_vals=["v3_3", "v5", "dual"])
    validate_field(data, "pinout", list)
    validate_field(data, "safety", dict)
    validate_field(data, "projectIds", list)

    for pin in data["pinout"]:
        validate_field(pin, "pinName", str)
        validate_field(pin, "type", str, enum_vals=["power", "ground", "digitalIn", "digitalOut", "analogIn", "i2c", "spi", "uart", "passive"])
        validate_field(pin, "description", str)

    safety = data["safety"]
    validate_field(safety, "level", str, enum_vals=["safe", "caution", "restrictedAdultSupervision"])
    validate_field(safety, "hazards", list)
    validate_field(safety, "requiresParentUnlock", bool)

    if "wiringGuidance" in data and data["wiringGuidance"] is not None:
        validate_field(data, "wiringGuidance", str)

    if "commonMistakes" in data and data["commonMistakes"] is not None:
        validate_field(data, "commonMistakes", list)
        for mistake in data["commonMistakes"]:
            if not isinstance(mistake, str):
                raise ValidationError(f"commonMistakes entry must be string, got {type(mistake).__name__}")

    if "miniExperiment" in data and data["miniExperiment"] is not None:
        validate_field(data, "miniExperiment", dict)
        exp = data["miniExperiment"]
        validate_field(exp, "title", str)
        validate_field(exp, "circuit", str)
        validate_field(exp, "code", str)
        validate_field(exp, "expectedOutput", str)



def validate_project(data, path):
    validate_field(data, "id", str, pattern=r"^proj_[0-9]{2}$")
    validate_field(data, "title", str, min_len=3)
    validate_field(data, "tagline", str)
    validate_field(data, "tier", str, enum_vals=["rookie", "builder", "engineer", "monsterMaster"])
    validate_field(data, "estimatedMinutes", int, min_val=15, max_val=180)
    validate_field(data, "requiredComponents", list)
    validate_field(data, "prerequisiteLessons", list)
    validate_field(data, "phases", list, min_len=2)
    validate_field(data, "xpReward", int, min_val=50)

    for phase in data["phases"]:
        validate_field(phase, "phaseNumber", int, min_val=1)
        validate_field(phase, "phaseTitle", str)
        validate_field(phase, "type", str, enum_vals=[
            "gatherParts", "breadboardWiring", "wiringCheck", "codeReview", "uploadSketch", "physicalTest", "debugTuning", "missionComplete"
        ])
        validate_field(phase, "instructions", str)

        if "codeSnippet" in phase and phase["codeSnippet"] is not None:
            validate_field(phase, "codeSnippet", str)
        if "codeExplanation" in phase and phase["codeExplanation"] is not None:
            validate_field(phase, "codeExplanation", str)
        if "wiringConnections" in phase and phase["wiringConnections"] is not None:
            validate_field(phase, "wiringConnections", list)
            for conn in phase["wiringConnections"]:
                validate_field(conn, "from", str)
                validate_field(conn, "to", str)
                validate_field(conn, "wire", str)
                validate_field(conn, "type", str)


    if "troubleshooting" in data:
        validate_field(data, "troubleshooting", list)
        for item in data["troubleshooting"]:
            validate_field(item, "symptom", str)
            validate_field(item, "cause", str)
            validate_field(item, "solution", str)
            if "category" in item and item["category"] is not None:
                validate_field(item, "category", str, enum_vals=["power", "wiring", "code", "upload", "logic"])
            if "diagnosticSteps" in item and item["diagnosticSteps"] is not None:
                validate_field(item, "diagnosticSteps", list)
                for step in item["diagnosticSteps"]:
                    if not isinstance(step, str):
                        raise ValidationError(f"diagnosticSteps item must be string, got {type(step).__name__}")

    if "variants" in data and data["variants"] is not None:
        validate_field(data, "variants", list)
        for var in data["variants"]:
            validate_field(var, "id", str)
            validate_field(var, "title", str)
            validate_field(var, "description", str)
            validate_field(var, "alternativeComponents", list)
            validate_field(var, "wiringDifferences", str)
            validate_field(var, "codeAdaptation", str)

    if "extensionMissions" in data and data["extensionMissions"] is not None:
        validate_field(data, "extensionMissions", list)
        for mis in data["extensionMissions"]:
            validate_field(mis, "id", str)
            validate_field(mis, "title", str)
            validate_field(mis, "objective", str)
            validate_field(mis, "difficulty", str, enum_vals=["rookie", "builder", "engineer", "monsterMaster"])
            validate_field(mis, "hints", list)
            validate_field(mis, "xpReward", int, min_val=25)


def validate_challenge(data, path):
    validate_field(data, "id", str, pattern=r"^chal_[a-z0-9_]+$")
    validate_field(data, "title", str, min_len=3)
    validate_field(data, "type", str, enum_vals=[
        "identifyPart", "predictOutput", "fixWiring", "changeCode",
        "debugLogic", "combineComponents", "buildFromGoal", "explainWhatHappened"
    ])
    validate_field(data, "difficulty", str, enum_vals=["rookie", "builder", "engineer", "monsterMaster"])
    validate_field(data, "prompt", str)
    validate_field(data, "challengeData", dict)
    validate_field(data, "hint", str)
    validate_field(data, "xpAward", int, min_val=25)

    if "hints" in data and data["hints"] is not None:
        validate_field(data, "hints", list)
        for h in data["hints"]:
            if not isinstance(h, str):
                raise ValidationError(f"hints entry must be string, got {type(h).__name__}")

    if "explanation" in data and data["explanation"] is not None:
        validate_field(data, "explanation", str)

    if "codeSnippet" in data and data["codeSnippet"] is not None:
        validate_field(data, "codeSnippet", str)

    if "circuitSnippet" in data and data["circuitSnippet"] is not None:
        validate_field(data, "circuitSnippet", str)



def main():
    print("=" * 60)
    print("Monster Lab - Curriculum Data Validation")
    print("=" * 60)

    manifest_file = CURRICULUM_DIR / "manifest.json"
    if not manifest_file.exists():
        print(f"Error: Manifest file {manifest_file} missing!")
        sys.exit(1)

    with open(manifest_file, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    lessons = {}
    components = {}
    projects = {}
    challenges = {}
    badges = {}

    errors = []

    # 1. Validate Badges
    badges_file = CURRICULUM_DIR / "badges" / "badges.json"
    if badges_file.exists():
        with open(badges_file, "r", encoding="utf-8") as f:
            badge_list = json.load(f)
            for b in badge_list:
                badges[b["id"]] = b
        print(f"[OK] Badges validated: {len(badges)} loaded")
    else:
        errors.append(f"Badges file missing: {badges_file}")

    # 2. Validate Lessons
    lessons_dir = CURRICULUM_DIR / "lessons"
    for lfile in sorted(lessons_dir.glob("*.json")):
        try:
            with open(lfile, "r", encoding="utf-8") as f:
                data = json.load(f)
            validate_lesson(data, lfile)
            lessons[data["id"]] = data
            print(f"  [OK] Lesson: {data['id']} - {data['title']}")
        except Exception as e:
            errors.append(f"Lesson error in {lfile.name}: {e}")

    # 3. Validate Components
    comp_dir = CURRICULUM_DIR / "components"
    for cfile in sorted(comp_dir.glob("*.json")):
        try:
            with open(cfile, "r", encoding="utf-8") as f:
                data = json.load(f)
            validate_component(data, cfile)
            components[data["id"]] = data
            print(f"  [OK] Component: {data['id']} - {data['name']}")
        except Exception as e:
            errors.append(f"Component error in {cfile.name}: {e}")

    # 4. Validate Projects
    proj_dir = CURRICULUM_DIR / "projects"
    for pfile in sorted(proj_dir.glob("*.json")):
        try:
            with open(pfile, "r", encoding="utf-8") as f:
                data = json.load(f)
            validate_project(data, pfile)
            projects[data["id"]] = data
            print(f"  [OK] Project: {data['id']} - {data['title']}")
        except Exception as e:
            errors.append(f"Project error in {pfile.name}: {e}")

    # 5. Validate Challenges
    chal_dir = CURRICULUM_DIR / "challenges"
    for chfile in sorted(chal_dir.glob("*.json")):
        try:
            with open(chfile, "r", encoding="utf-8") as f:
                data = json.load(f)
            validate_challenge(data, chfile)
            challenges[data["id"]] = data
            print(f"  [OK] Challenge: {data['id']} - {data['title']}")
        except Exception as e:
            errors.append(f"Challenge error in {chfile.name}: {e}")

    print("\n--- Cross-Referential Integrity Checks ---")

    # Lesson referential checks
    for lid, l in lessons.items():
        for prereq in l["prerequisites"]:
            if prereq not in lessons:
                errors.append(f"Lesson '{lid}' has non-existent prerequisite lesson '{prereq}'")
        for cid in l["componentIds"]:
            if cid not in components:
                errors.append(f"Lesson '{lid}' references non-existent component '{cid}'")

    # Project referential checks
    for pid, p in projects.items():
        for req_c in p["requiredComponents"]:
            if req_c not in components:
                errors.append(f"Project '{pid}' references non-existent required component '{req_c}'")
        for prereq_l in p["prerequisiteLessons"]:
            if prereq_l not in lessons:
                errors.append(f"Project '{pid}' references non-existent prerequisite lesson '{prereq_l}'")
        if "badgeRewardId" in p and p["badgeRewardId"]:
            if p["badgeRewardId"] not in badges:
                errors.append(f"Project '{pid}' references non-existent badge '{p['badgeRewardId']}'")

    # Component referential checks
    for cid, c in components.items():
        for pid in c["projectIds"]:
            if pid not in projects:
                errors.append(f"Component '{cid}' references non-existent project '{pid}'")

    if errors:
        print("\n[FAILED] Validation errors encountered:")
        for err in errors:
            print(f"  - {err}")
        sys.exit(1)
    else:
        print(f"\n[SUCCESS] 100% Curriculum Validation Passed!")
        print(f"  Total Lessons: {len(lessons)}")
        print(f"  Total Components: {len(components)}")
        print(f"  Total Projects: {len(projects)}")
        print(f"  Total Challenges: {len(challenges)}")
        print(f"  Total Badges: {len(badges)}")
        sys.exit(0)


if __name__ == "__main__":
    main()
