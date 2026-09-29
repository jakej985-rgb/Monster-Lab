# 02 - Component Specifications

## 1. Overview

This document specifies the core interactive UI components for **Monster Lab**. Every component is engineered for touch ergonomics, accessibility, and playful physical intuition.

---

## 2. Buttons & Controls

### 2.1 Primary Action Button (`MonsterButton.primary`)
- **Visual Style**: High-saturation Electric Violet (`#6C5CE7`) pill container with soft 3D bottom bevel shadow (`#4834D4`). When pressed, translates down 2dp with haptic feedback.
- **Dimensions**: Full width or min-width 160 dp; minimum height **52 dp** (exceeds 48dp minimum for kids).
- **Typography**: `labelLarge` (16sp Bold), white text (`#FFFFFF`).
- **States**: Default, Hover, Pressed (compressed bevel), Disabled (soft slate fill with 40% opacity).

### 2.2 Secondary / Outlined Button (`MonsterButton.secondary`)
- **Visual Style**: 2dp border stroke (`#6C5CE7`), transparent or soft tinted background (`rgba(108, 92, 231, 0.08)`).
- **Dimensions**: Min-height 48 dp, pill radius (999 dp).
- **Typography**: `labelLarge` in `primaryViolet` text.

### 2.3 Action Icon Button (`MonsterIconButton`)
- **Visual Style**: Circular container with high-contrast icon (e.g. Back arrow, Settings gear, Audio toggle).
- **Dimensions**: **48 × 48 dp** touch target (icon size 24 dp).
- **Background**: Soft surface container (`#EDF2F7`) or brand violet for floating action buttons.

### 2.4 Mascot Speech Bubble (`MascotPromptCard`)
- **Visual Style**: Soft speech bubble card with directional arrow pointing to the talking robot avatar (Bolt, Sparky, Geary, or Byte).
- **Behavior**: Mascots give short, encouraging guidance (1-2 sentences), avoiding overwhelming blocks of text.

---

## 3. Cards

### 3.1 Project Card (`ProjectCard`)
- **Visual Container**: 16dp rounded card, white surface, subtle low elevation shadow.
- **Header**: Project title (`headlineMedium`), difficulty tier chip (e.g. `[Builder]`), and estimated time icon (`⏱ 45 min`).
- **Body**: High-resolution thumbnail illustration or isometric rendering of the assembled monster project.
- **Footer**: Required parts icon ribbon (shows small icons of required components) and primary CTA ("Start Build" or "Resume Phase 3").

### 3.2 Component Card (`ComponentCard`)
- **Visual Container**: 16dp rounded card with top status banner.
- **Top Badge**: Shows peripheral number badge (e.g. `#01`) and category chip (`[Sensor]`).
- **Center**: Crisp illustration of the module showing labeled pins.
- **Footer**: Voltage tag (`5V` or `3.3V`) and safe use status (Green check for Safe; Amber shield for Parent Supervised).

### 3.3 Lesson Card (`LessonCard`)
- **Visual Container**: Horizontal list card with left status icon.
- **Left Indicator**: Circular checkmark badge (Completed = Green check; Current = Pulsing purple; Locked = Padlock).
- **Center Details**: Lesson number, title, and short conceptual hook.
- **Right Bounty**: XP reward pill (`+100 XP`).

---

## 4. Progress Indicators & Badges

### 4.1 XP Progress Bar (`XPProgressBar`)
- **Visual Style**: Pill-shaped bar with smooth rounded caps, height 18 dp.
- **Track**: Soft grey surface (`#EDF2F7`).
- **Indicator**: Animated gradient from Energy Amber (`#FFA502`) to Energy Gold (`#FDCB6E`), featuring an active shimmer highlight.
- **Accompanying Element**: Level badge on the left (`Lv. 5`) and numeric tally on the right (`850 / 1000 XP`).

### 4.2 Step Progression Indicator (`StepTracker`)
- **Visual Style**: Horizontal chain of connected circular nodes representing lesson or project phases.
- **Completed Node**: Solid green circle with white checkmark icon.
- **Active Node**: Electric violet circle with white phase number and subtle pulsing glow.
- **Upcoming Node**: Light grey circle with outline stroke.

### 4.3 Achievement Badge (`TrophyBadge`)
- **Visual Style**: Hexagonal or circular medallion with metallic border, embossed robotic icon, and ribbon banner underneath.
- **Unlock Animation**: Scale-up bounce spring curve ($0 \to 1.15 \to 1.0$), particle sparkle burst, and celebratory chime.
