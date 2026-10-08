# Phase 99b — Lesson Builder Technical Architecture

## Status

Future planning only. No implementation is authorized by this plan alone.

## Purpose

Define the technical architecture for the future Monster Lab Lesson Builder Docker application and its connection to the Monster Lab kid app.

## High-Level Architecture

```
                 Lesson Builder Docker
        ┌─────────────────────────────────┐
        │                                 │
        │ Web UI                          │
        │ API                             │
        │ Authentication                  │
        │ Source Storage                  │
        │ Content Extraction              │
        │ Lesson Generation               │
        │ Curriculum Guardian             │
        │ Lesson Validation               │
        │ Publishing                      │
        │ Version Management              │
        │ Database                        │
        │                                 │
        └───────────────┬─────────────────┘
                        │
                    REST API
                        │
                        ↓
                 Monster Lab App
```

## Docker

The Builder should be deployable as a self-contained Docker-based application.

Architecture should support:

- Local/home server deployment
- LAN access
- Reverse proxy deployment
- HTTPS
- Persistent storage
- Database persistence
- Backup/restore
- Offline Builder operation where practical

Exact container decomposition should be determined during technical design rather than prematurely locking the architecture.

## API

Define a versioned API, initially conceptually:

```
GET    /api/v1/lessons
GET    /api/v1/lessons/{id}
GET    /api/v1/lessons/{id}/package
GET    /api/v1/categories
GET    /api/v1/versions
```

Additional endpoints will be required for:

- Authentication
- Source uploads
- Draft management
- Lesson generation
- Guardian validation
- Editing
- Publishing
- Versioning
- Sync
- Health checks

The final API contract belongs in the implementation plan.

## Authentication

Support a simple secure model suitable for self-hosted installations.

Initial direction:

- Server URL
- API key
- HTTPS recommended/required for remote connections

API keys should be revocable and should never be embedded inside published lesson packages.

Future architecture may support accounts, organizations, roles, and OAuth if needed.

## Source Processing Pipeline

```
Upload
  ↓
Validate File
  ↓
Store Original
  ↓
Extract Text/Images
  ↓
Normalize Content
  ↓
Generate Lesson Draft
  ↓
Validate Schema
  ↓
Curriculum Guardian
  ↓
Human Review
  ↓
Publish Package
```

Original source files should remain available so adults can trace generated content back to the source.

## Lesson Schema

The Builder must use the same canonical lesson schema as Monster Lab.

Do not create a Builder-only lesson format.

The schema must support:

- Metadata
- Difficulty
- Age range
- Prerequisites
- Objectives
- Content
- Visuals
- Activities
- Code
- Hands-on work
- Assessments
- Safety
- Timing
- Completion rules
- Version information

Schema changes must be coordinated with Monster Lab.

## Lesson Package

Published lessons should have a portable package representation containing the lesson definition and required assets.

Conceptually:

```
lesson/
├── lesson.json
├── metadata.json
├── content/
├── activities/
├── assessments/
├── images/
└── diagrams/
```

The exact package format will be finalized during implementation planning.

## Sync

Monster Lab should be able to:

1. Connect to a configured Builder
2. Authenticate
3. Discover available lessons
4. Compare versions
5. Download required lesson packages
6. Validate packages
7. Store them locally
8. Use them offline
9. Detect future updates

Sync failures must not destroy already-installed lessons.

## Versioning

Use immutable published versions.

A lesson update should create a new version.

The client should be able to determine:

- Installed version
- Available version
- Whether an update exists
- Whether an update is compatible

Never overwrite learner progress accidentally because a lesson was updated.

## Storage

Separate:

- Original source files
- Extracted content
- Draft lesson data
- Published lesson data
- Lesson assets
- Version history
- Configuration/secrets

The exact database and storage technologies should be selected during implementation planning.

## Security

The Builder should protect:

- API keys
- Uploaded private documents
- Generated lessons
- Adult account information
- Child-related information if future assignment features are added

Security requirements should include:

- Authentication
- Authorization
- Secure secret storage
- HTTPS support
- Input validation
- File-type validation
- Upload size limits
- Safe document processing
- API rate limiting where appropriate
- Audit logging for publishing actions

## Offline and Reliability Requirements

The kid app remains offline-first.

The Builder being unavailable must not prevent already-downloaded lessons from working.

Failed downloads must be recoverable.

Partial packages must not replace valid installed packages.

## Future Expansion

Architecture should leave room for:

- Multiple Builder servers
- Multiple organizations
- Parent accounts
- Trainer accounts
- Classes
- Assignments
- Private/shared curriculum
- Import/export
- Remote publishing
- Additional source types
- Additional AI providers

These should remain future capabilities rather than requirements for the first implementation.

## Technical Planning Gate

Before implementation, produce detailed specifications for:

1. Docker architecture
2. Backend stack
3. Frontend stack
4. Database
5. Storage
6. Authentication
7. API contract
8. Lesson schema
9. Package format
10. Source extraction
11. AI generation pipeline
12. Curriculum Guardian interface
13. Publishing/versioning
14. Monster Lab synchronization
15. Security
16. Backup/restore
17. Testing
18. Deployment

The technical plan must remain compatible with Phase 99a's product requirements.
