# Mobile Lesson UX and Responsive Components

This document details the responsive lesson UI components introduced in Phase 24 for **Monster Lab**.

---

## 1. Overview & Principles

Monster Lab runs across mobile phones, tablets, and desktop workstations. On compact mobile screens (under 400dp width):
- Code snippets and syntax tokens must not truncate or wrap into unreadable fragments.
- Circuit schematics and board diagrams require zoom/pan inspections without breaking card layouts.
- Bottom navigation and interaction bars must strictly honor system navigation gestures and display cutouts (`SafeArea`).
- Immersive reading mode can hide system chrome (`SystemChrome.setEnabledSystemUIMode`) for distraction-free learning.

---

## 2. Core Components

### 2.1 ExpandableLessonImage
- **File**: `lib/presentation/shared/widgets/expandable_lesson_image.dart`
- **Purpose**: Displays inline lesson images and diagrams with responsive width scaling and an overlay badge ("Tap to expand").
- **Features**:
  - Full touch-target wrapper.
  - Graceful fallback container for missing or offline assets.
  - Direct integration with `FullScreenImageViewer` on tap.
  - Configurable `allowExpand`, `caption`, and WCAG `semanticsLabel`.

### 2.2 FullScreenImageViewer
- **File**: `lib/presentation/shared/widgets/full_screen_image_viewer.dart`
- **Purpose**: Modal full-screen route for deep inspection of high-resolution diagrams.
- **Features**:
  - Flutter `InteractiveViewer` with `minScale: 0.8` and `maxScale: 4.0`.
  - Double-tap zoom reset / zoom toggle animation.
  - High-contrast close button (`Icons.close`) positioned safely away from system notches.
  - Optional diagram caption header.

### 2.3 ResponsiveCodeBlock
- **File**: `lib/presentation/shared/widgets/responsive_code_block.dart`
- **Purpose**: Displays syntax-highlighted code blocks with line numbers, copy button, and horizontal scrolling.
- **Features**:
  - Monospace font styling with dark theme background (`#1A1A24`).
  - Gutter with line numbers aligned to code lines.
  - Horizontal scroll view preserving indentation and column alignment.
  - "Copy Code" button copying cleanly to clipboard with `SnackBar` confirmation.

### 2.4 LessonActionBar
- **File**: `lib/presentation/shared/widgets/lesson_action_bar.dart`
- **Purpose**: Standardized persistent bottom bar across all lesson steps.
- **Features**:
  - Back, Next, and Complete buttons with clear touch targets (>= 48dp).
  - Built-in safe area insets padding for Android 3-button nav and gesture navigation bars.
  - Step counter indicators (`Step X of Y`).

### 2.5 ImmersiveLessonController
- **File**: `lib/presentation/shared/widgets/immersive_lesson_controller.dart`
- **Purpose**: Platform-safe system chrome controller.
- **Features**:
  - Toggles `SystemUiMode.immersiveSticky` when `immersiveLessonMode` is enabled in settings.
  - Restores `SystemUiMode.edgeToEdge` cleanly on widget dispose or route pop.
  - Persisted in user settings via `SettingsRepository` and `AppSettings`.
