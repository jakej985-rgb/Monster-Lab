# 24 Mobile Lesson UX and Immersive Display

## Goal

Make Monster Lab lessons comfortable and usable on phone screens without losing information, interactions, or navigation.

The current lessons contain wide diagrams/visual blocks and the full-screen presentation can place Android system navigation over lesson action controls.

## Core Requirements

- Mobile-first lesson layout.
- No clipped lesson content.
- Large visuals can be expanded.
- Long code stays readable.
- Lesson actions respect Android system insets.
- Normal portrait mode keeps system navigation available by default.
- Immersive mode is optional through Settings.
- Rotation is handled cleanly.
- No lesson-specific UI hacks.

## Visual Pattern

Use:

**Inline Preview → Tap to Expand → Full-Screen Viewer → Close/Back**

Expanded visuals should support zoom, pan where needed, back/close, orientation changes, and accessibility descriptions.

Do not shrink detailed diagrams until labels become unreadable.

## Wide Content

- Responsive sizing for normal content.
- Horizontal scrolling only when genuinely required.
- Expanded viewer for detailed inspection.
- Never let wide content push primary controls off-screen.

## Code Blocks

- Horizontal scrolling for long lines.
- Wrapping only when it does not change code meaning.
- Syntax highlighting.
- Optional copy action.
- No clipped code.
- One code block must never force the entire lesson page to scroll horizontally.

## Lesson Action Area

Next Step/Back controls must sit above the Android system navigation area.

Use SafeArea/system insets so controls work with:

- Gesture navigation.
- Three-button navigation.
- Landscape.
- Keyboard visibility where relevant.

## Full-Screen Behavior

Normal mode:

- System navigation remains available.
- Lesson content respects system insets.

Add a Settings option:

**Immersive Lesson Mode**

Description: **Hide system navigation controls while learning for a more immersive full-screen experience.**

Default: **Off**

When enabled:

- Use supported immersive/full-screen behavior.
- Restore system UI when leaving the lesson.
- Recover if Android temporarily reveals system bars.
- Do not change the rest of the app.

## Rotation

Portrait and landscape must reflow content and controls.

If system bars temporarily appear, the lesson must recover without overlap.

## Reusable Components

Create shared components as appropriate:

- ExpandableLessonImage.
- ExpandableLessonDiagram.
- ResponsiveCodeBlock.
- LessonActionBar.
- SystemInsetAwareScaffold.
- ImmersiveLessonController.

Names may match the existing architecture.

## Content Data

Lesson data should declare:

- Asset.
- Caption.
- Accessibility description.
- Expandable/zoom behavior.

Do not put Flutter layout code in lesson JSON.

## Performance

Use appropriately sized previews and load high-resolution assets when expanded. Keep all lesson assets offline-capable.

## Accessibility

Expanded visuals need labels, descriptions, usable close/back controls, and sufficient touch targets. Important information must not exist only inside an image.

## Testing

Test small/large portrait phones, landscape, gesture navigation, three-button navigation, immersive on/off, rotation, long code, wide diagrams, missing assets, expanded viewer back navigation, and lesson completion.

## Definition of Done

- No important content is clipped.
- Large visuals have an expand/view-full option.
- Expanded visuals are usable.
- Long code is readable.
- Android navigation does not cover Next Step.
- Immersive mode is optional and off by default.
- Rotation works.
- Offline assets work.
- Existing lessons need no UI workarounds.
- Flutter analyze and tests pass.
