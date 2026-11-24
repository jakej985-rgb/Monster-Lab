# 00 - Product Architecture Overview

## 1. System Vision & Purpose

**Monster Lab** is an offline-first, kid-focused robotics learning platform
engineered to transform the kit's 54 component entries and 20 projects into an
interactive, pedagogical discovery journey.

Rather than replicating a static textbook or manual, Monster Lab implements an active experiential cycle:
$$\text{Learn} \longrightarrow \text{Build} \longrightarrow \text{Test} \longrightarrow \text{Change} \longrightarrow \text{Explain}$$

```mermaid
graph TD
    A["Learn Concept"] --> B["Identify Physical Part"]
    B --> C["Guided Build & Wire"]
    C --> D["Upload & Test Code"]
    D --> E["Observe Physical Output"]
    E --> F["Modify Variables & Logic"]
    F --> G["Solve Mini Challenge"]
    G --> H["Earn XP & Milestones"]
    H --> A
```

---

## 2. Layered Clean Architecture

Monster Lab adheres to strict Clean Architecture boundaries, segregating presentation, application logic, domain entities, local persistence, and hardware communication into distinct layers.

```mermaid
flowchart TD
    subgraph Presentation ["1. Presentation Layer (Flutter UI)"]
        UI_Screens["Core Screens: Home, Learn, Parts, Build, Challenges, Parent"]
        UI_Widgets["Shared Visual Components: Breadboard, CodeEditor, Gauges"]
        UI_State["State Notifiers / Reactive ViewModels"]
    end

    subgraph Application ["2. Application / Logic Layer"]
        ProgMgr["Progress & Milestone Evaluator"]
        CurricMgr["Curriculum Navigation Engine"]
        ProfileMgr["Multi-Learner Profile Manager"]
        SafetyGate["Parent Mode & Safety Interlock Gateway"]
    end

    subgraph Domain ["3. Domain Layer (Pure Dart)"]
        Entities["Entities: Lesson, Component, Project, Challenge, Quiz"]
        ValueObjects["Value Objects: PinDefinition, WireConnection, Badge"]
        Interfaces["Repository Interfaces & Hardware Contracts"]
    end

    subgraph Data ["4. Data & Persistence Layer"]
        CurricRepo["Curriculum Asset Repository (JSON/Markdown)"]
        LocalStore["Local Profile & Progress Store (Isolated Storage)"]
        ExportService["Parent JSON Backup / Restore Service"]
    end

    subgraph Services ["5. Services & Hardware Abstraction (HAL)"]
        SerialBridge["Serial Communication Driver (USB-UART)"]
        BoardDetector["Arduino Board Auto-Discovery"]
        MockHAL["Virtual Board Simulator (No Hardware Fallback)"]
    end

    Presentation --> Application
    Application --> Domain
    Data --> Domain
    Services --> Domain
    Presentation -.-> UI_State
    Application -.-> CurricRepo
    Application -.-> LocalStore
    Application -.-> SerialBridge
```

---

## 3. Core Architectural Pillars

### Pillar 1: Data-Driven Curriculum Engine
- All lessons, component definitions, build guides, and challenges are stored in external, validated schemas (JSON/Markdown) rather than hardcoded into Flutter widgets.
- Adding a new project or updating a pin diagram never requires recompiling application UI logic.

### Pillar 2: 100% Offline-First
- Zero external internet dependency.
- All assets, tutorials, pinout tables, code examples, and progress tracking run completely on the local device.
- Zero tracking, telemetry, or user data collection.

### Pillar 3: Multi-Child Device Sharing
- Tablets and family computers are frequently shared among siblings.
- Profiles maintain independent progress sandboxes keyed by unique `learner_id`. One child unlocking advanced robotics projects never interferes with another child's beginner journey.

### Pillar 4: Decoupled Hardware Companion
- The application is a fully capable learning environment without physical hardware.
- When an Arduino board is connected over USB, the application seamlessly activates real-time telemetry, live sensor plotting, and auto-detection via an event-driven Hardware Abstraction Layer (HAL).
