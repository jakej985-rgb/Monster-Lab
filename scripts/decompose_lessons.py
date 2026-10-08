#!/usr/bin/env python3
"""
Decomposes monolithic lessons (lesson_01, lesson_03..lesson_08) into:
- 79 standalone sub-lesson JSON files in assets/curriculum/lessons/
- 7 Course container JSON files in assets/curriculum/courses/
- Updates assets/curriculum/manifest.json
"""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CURRICULUM_DIR = ROOT / "assets" / "curriculum"
LESSONS_DIR = CURRICULUM_DIR / "lessons"
COURSES_DIR = CURRICULUM_DIR / "courses"

MONOLITHIC_FILES = [
    {
        "file": "lesson_01.json",
        "course_id": "lesson_01",
        "course_title": "Lesson 1 — Arduino Fundamentals",
        "prefix": "l01",
        "tier": "rookie",
        "prereqs": [],
        "first_prereq": [],
        "course_xp": 100,
        "est_minutes": 60,
    },
    {
        "file": "lesson_03.json",
        "course_id": "lesson_03",
        "course_title": "Lesson 3 — Libraries: Power Up Your Code",
        "prefix": "l03",
        "tier": "builder",
        "prereqs": ["lesson_2b"],
        "first_prereq": ["l2b_08"],
        "course_xp": 100,
        "est_minutes": 45,
    },
    {
        "file": "lesson_04.json",
        "course_id": "lesson_04",
        "course_title": "Lesson 4 — PWM & RGB LEDs: Colors and Brightness",
        "prefix": "l04",
        "tier": "rookie",
        "prereqs": ["lesson_03"],
        "first_prereq": ["l03_09"],
        "course_xp": 100,
        "est_minutes": 50,
    },
    {
        "file": "lesson_05.json",
        "course_id": "lesson_05",
        "course_title": "Lesson 5 — Switches, Buttons & Potentiometers: Physical Inputs",
        "prefix": "l05",
        "tier": "rookie",
        "prereqs": ["lesson_04"],
        "first_prereq": ["l04_10"],
        "course_xp": 150,
        "est_minutes": 80,
    },
    {
        "file": "lesson_06.json",
        "course_id": "lesson_06",
        "course_title": "Lesson 6 — Circuits, Breadboards & First Builds",
        "prefix": "l06",
        "tier": "builder",
        "prereqs": ["lesson_05"],
        "first_prereq": ["l05_16"],
        "course_xp": 100,
        "est_minutes": 55,
    },
    {
        "file": "lesson_07.json",
        "course_id": "lesson_07",
        "course_title": "Lesson 7 — Sensors & Reading the Real World",
        "prefix": "l07",
        "tier": "builder",
        "prereqs": ["lesson_06"],
        "first_prereq": ["l06_11"],
        "course_xp": 100,
        "est_minutes": 55,
    },
    {
        "file": "lesson_08.json",
        "course_id": "lesson_08",
        "course_title": "Lesson 8 — I2C & Connected Devices",
        "prefix": "l08",
        "tier": "engineer",
        "prereqs": ["lesson_07"],
        "first_prereq": ["l07_11"],
        "course_xp": 100,
        "est_minutes": 50,
    },
]


def clean_summary(step, parent_title):
    md = step.get("markdownContent", "")
    lines = [
        line.strip()
        for line in md.split("\n")
        if line.strip()
        and not line.strip().startswith("#")
        and not line.strip().startswith("```")
    ]
    for line in lines:
        cleaned = re.sub(r"[*_`]", "", line)
        cleaned = re.sub(r"[^\x00-\x7F]+", "", cleaned).strip()
        sentences = re.split(r"(?<=[.!?])\s+", cleaned)
        for s in sentences:
            s = s.strip()
            if (
                len(s) >= 20
                and not s.lower().startswith("welcome to")
                and not s.lower().startswith("hooray")
                and not s.lower().startswith("congratulations")
            ):
                if len(s) > 150:
                    s = s[:147] + "..."
                return s
    step_title = step.get("title", "")
    return f"Learn about {step_title} as part of {parent_title}."


def main():
    print("Starting asset decomposition...")
    created_lessons = []

    for cfg in MONOLITHIC_FILES:
        filepath = LESSONS_DIR / cfg["file"]
        if not filepath.exists():
            print(f"Skipping {cfg['file']} (not found)")
            continue

        with open(filepath, "r", encoding="utf-8") as f:
            mono = json.load(f)

        steps = mono.get("steps", [])
        sublesson_ids = []

        print(f"Decomposing {cfg['file']} ({len(steps)} steps)...")

        for idx, step in enumerate(steps):
            sort_order = idx + 1
            sub_id = f"{cfg['prefix']}_{sort_order:02d}"
            sublesson_ids.append(sub_id)

            if idx == 0:
                prereqs = list(cfg["first_prereq"])
            else:
                prev_id = f"{cfg['prefix']}_{idx:02d}"
                prereqs = [prev_id]

            summary = clean_summary(step, mono.get("title", cfg["course_title"]))
            # XP: 15 for last step in course, 10 for other steps
            xp = 15 if (idx == len(steps) - 1) else 10

            sublesson_data = {
                "id": sub_id,
                "title": step.get("title", f"Step {sort_order}"),
                "summary": summary,
                "tier": cfg["tier"],
                "estimatedMinutes": 5,
                "courseId": cfg["course_id"],
                "sortOrder": sort_order,
                "isOptional": False,
                "prerequisites": prereqs,
                "componentIds": mono.get("componentIds", []),
                "steps": [step],
                "xpReward": xp,
            }

            sub_path = LESSONS_DIR / f"{sub_id}.json"
            with open(sub_path, "w", encoding="utf-8") as f:
                json.dump(sublesson_data, f, indent=2)

            created_lessons.append(sub_id)

        # Create Course container
        course_data = {
            "id": cfg["course_id"],
            "title": cfg["course_title"],
            "summary": mono.get("summary", ""),
            "lessonIds": sublesson_ids,
            "isOptional": False,
            "placementLessonId": None,
            "prerequisites": cfg["prereqs"],
            "xpReward": cfg["course_xp"],
            "estimatedMinutes": cfg["est_minutes"],
        }

        course_path = COURSES_DIR / f"{cfg['course_id']}.json"
        with open(course_path, "w", encoding="utf-8") as f:
            json.dump(course_data, f, indent=2)
        print(f"Created course container: {course_path.name}")

        # Remove monolithic file
        filepath.unlink()
        print(f"Removed monolithic file: {cfg['file']}")

    print(f"Total sub-lessons created: {len(created_lessons)}")

    # Update manifest.json
    manifest_path = CURRICULUM_DIR / "manifest.json"
    with open(manifest_path, "r", encoding="utf-8") as f:
        manifest = json.load(f)

    # 10 Courses in exact order
    manifest["courses"] = [
        "lesson_01",
        "coding_foundations",
        "lesson_2a",
        "lesson_2b",
        "lesson_03",
        "lesson_04",
        "lesson_05",
        "lesson_06",
        "lesson_07",
        "lesson_08",
    ]

    # Reconstruct lesson list in exact order
    all_lessons = []
    # 1. lesson_01: l01_01 .. l01_12
    all_lessons.extend([f"l01_{i:02d}" for i in range(1, 13)])
    # 2. coding_foundations: cf_01 .. cf_08
    all_lessons.extend([f"cf_{i:02d}" for i in range(1, 9)])
    # 3. lesson_2a: l2a_01 .. l2a_08
    all_lessons.extend([f"l2a_{i:02d}" for i in range(1, 9)])
    # 4. lesson_2b: l2b_01 .. l2b_08
    all_lessons.extend([f"l2b_{i:02d}" for i in range(1, 9)])
    # 5. lesson_03: l03_01 .. l03_09
    all_lessons.extend([f"l03_{i:02d}" for i in range(1, 10)])
    # 6. lesson_04: l04_01 .. l04_10
    all_lessons.extend([f"l04_{i:02d}" for i in range(1, 11)])
    # 7. lesson_05: l05_01 .. l05_16
    all_lessons.extend([f"l05_{i:02d}" for i in range(1, 17)])
    # 8. lesson_06: l06_01 .. l06_11
    all_lessons.extend([f"l06_{i:02d}" for i in range(1, 12)])
    # 9. lesson_07: l07_01 .. l07_11
    all_lessons.extend([f"l07_{i:02d}" for i in range(1, 12)])
    # 10. lesson_08: l08_01 .. l08_10
    all_lessons.extend([f"l08_{i:02d}" for i in range(1, 11)])
    # Standalone lessons 09..12
    all_lessons.extend(["lesson_09", "lesson_10", "lesson_11", "lesson_12"])

    manifest["lessons"] = all_lessons
    manifest["counts"]["lessons"] = len(all_lessons)
    manifest["counts"]["courses"] = len(manifest["courses"])

    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest, f, indent=2)

    print(f"Updated manifest.json: {manifest['counts']['lessons']} lessons, {manifest['counts']['courses']} courses")


if __name__ == "__main__":
    main()
