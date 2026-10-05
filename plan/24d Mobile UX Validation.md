# 24d — Mobile UX Validation

## Goal

Validate lesson presentation on real Android phone layouts.

## Test Matrix

### Portrait

- Small phone.
- Standard phone.
- Large phone.

### Navigation

- Gesture navigation.
- Three-button navigation.

### Orientation

- Portrait.
- Landscape.
- Rotate while lesson is open.
- Rotate while expanded image is open.

### Content

- Long text.
- Wide diagrams.
- Code blocks.
- Images.
- Interactive widgets.
- Bottom action buttons.

### Modes

- Immersive off.
- Immersive on.
- App background/resume.

## Acceptance Criteria

- No clipped text.
- No horizontal page overflow.
- No covered controls.
- Images remain readable.
- Expanded viewer works.
- Back navigation works.
- Next Step remains reachable.
- Lesson progress remains correct.
- Existing lessons still render.

## Required Checks

Run:

- `flutter analyze`
- `flutter test`

Then manually walk through Lessons 1–3 and at least one lesson containing a wide diagram and code block.

## Done When

Mobile presentation is reliable enough to become the standard lesson layout for the entire curriculum.
