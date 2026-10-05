# 23f — Validation and Documentation

## Goal

Verify the new curriculum from first launch through the first Arduino programming lessons.

## Automated Tests

Test course loading, lesson ordering, prerequisites, placement, activity loading, activity completion, progress persistence, XP idempotency, offline behavior, and regression for existing Lessons 1–12.

## Required Checks

Run flutter analyze and flutter test.

## Manual Android Walkthrough

Test:

Lesson 1 → Coding Foundations/Placement → 2A → 2B → Lesson 3 → Lesson 4 → Lesson 5.

Verify content, images, code rendering, interactive activities, progress, completion, and prerequisite behavior.

## Documentation

Document course structure, Coding Foundations, placement rules, prerequisites, 2A/2B, course data schema, activity schemas, and how future courses reuse Coding Foundations.

## Done When

Automated tests pass, the Android path passes, documentation is current, and existing curriculum remains functional.
