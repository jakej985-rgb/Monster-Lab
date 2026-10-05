# 24b — Lesson Action Bar and Android System UI

## Goal

Prevent lesson navigation controls from being covered by Android system navigation controls.

## Requirements

The lesson action area must respect:

- Bottom system inset.
- Gesture navigation inset.
- Three-button navigation inset.
- Keyboard inset when relevant.
- Landscape insets.

Next Step must always remain fully visible and tappable.

## Default

Normal lesson mode keeps Android system navigation available.

Do not force immersive mode automatically.

## Immersive Mode

When enabled from Settings:

- Enter immersive mode for lesson screens.
- Restore system UI when leaving lessons.
- Recover if Android temporarily reveals system bars.
- Never place the action bar under the system navigation region.

## Done When

Next Step and other lesson actions remain accessible in portrait and landscape across Android navigation modes.
