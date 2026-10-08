# Phase 99a — Lesson Builder Full Plan

## Status

Future planning only. No implementation is authorized by this plan alone.

## Purpose

Define the complete product requirements for a separate Docker-based **Monster Lab Lesson Builder** for parents, trainers, teachers, and other adult content creators.

The Builder should turn source material into structured Monster Lab lessons that can be reviewed, edited, validated, and published to the Monster Lab kid app.

## Core Workflow

```
Upload Source
      ↓
Extract Content
      ↓
Generate Lesson
      ↓
Curriculum Guardian Review
      ↓
Adult Review/Edit
      ↓
Publish
      ↓
Monster Lab Kid App
```

## Source Material

Initial supported inputs should include:

- PDF
- Markdown
- DOC/DOCX
- Images
- Diagrams
- Worksheets

Future formats can be added after the core workflow is stable.

## Adult Dashboard

Provide an adult-focused interface for:

- Dashboard
- Source library
- Draft lessons
- Lessons needing review
- Published lessons
- Lesson versions
- Publishing/sync status

The Builder should make it possible for an adult to create useful lessons without manually understanding the internal lesson schema.

## Lesson Generation

Generated lessons should use the same lesson system as Monster Lab's built-in curriculum.

The generator should create appropriate:

- Lesson metadata
- Learning objectives
- Explanations
- Visuals
- Interactive activities
- Guided practice
- Hands-on activities
- Code activities when applicable
- Troubleshooting activities
- Assessments
- Review
- Timing
- Prerequisites
- Difficulty
- Safety information

Generated content must not be treated as automatically publishable.

## Curriculum Guardian

Every generated lesson should pass through the Curriculum Guardian before publication.

The Guardian should evaluate:

- Age appropriateness
- Reading level
- Vocabulary
- Cognitive load
- Learning progression
- Prerequisites
- Lesson order
- Technical accuracy
- Safety
- Activities
- Assessments
- Timing
- Difficulty
- Repetition
- Overall educational quality

Findings should have clear severity and require adult review when appropriate.

## Human Review

Adults must be able to inspect and edit generated lessons before publishing.

The system should clearly distinguish:

- Draft
- Needs Review
- Approved
- Published
- Updated/New Version

AI-generated content should never silently become published curriculum.

## Monster Lab Integration

Monster Lab should eventually connect to one or more Lesson Builder servers through Settings.

Possible configuration:

```
Lesson Sources
└── Monster Lab Lesson Builder
    ├── Server URL
    ├── API Key
    ├── Test Connection
    └── Sync Lessons
```

Support should eventually include:

- URL only
- URL + API key
- API endpoint configuration if needed

The connection should be secure and should not expose private Builder credentials to lesson content.

## Lesson Portability

Lessons should be portable and offline-friendly.

The Builder should publish a standard Monster Lab lesson package that the kid app can download and store locally.

The kid app should not require the Builder server to remain online while a lesson is being completed.

## Versioning

Published lessons should be versioned.

Updating a lesson should create a new version rather than silently changing the version currently being used by a learner.

Progress and completion should remain consistent across lesson versions.

## Future Parent/Trainer Features

The architecture should leave room for:

- Multiple children
- Classes/groups
- Lesson assignment
- Progress viewing
- Private lesson collections
- Shared curriculum
- Trainer-created courses
- Import/export
- Organization support

These are future capabilities and should not expand the initial implementation unnecessarily.

## Product Principle

The Lesson Builder is not a second lesson system.

It is a content-authoring system that produces the same structured lesson format Monster Lab already uses.

```
                 Monster Lab Curriculum
                         Rules
                           │
             ┌─────────────┴─────────────┐
             │                           │
      Built-in Lessons            Lesson Builder
             │                           │
             └─────────────┬─────────────┘
                           ↓
                   Monster Lab Lesson
                           ↓
                        Kid App
```

## Planning Requirements

Before implementation, define:

1. Complete lesson schema compatibility
2. Source extraction behavior
3. Generation pipeline
4. Curriculum Guardian integration
5. Human review workflow
6. Publishing workflow
7. Lesson package format
8. Versioning rules
9. API contract
10. Authentication model
11. Offline synchronization behavior
12. Error handling
13. Security requirements
14. Backup/export behavior
15. Future parent/trainer expansion

Implementation should not begin until the product and technical plans are reviewed together.
