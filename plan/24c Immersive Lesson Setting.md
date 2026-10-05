# 24c — Immersive Lesson Setting

## Goal

Give users control over whether lesson screens hide Android system navigation controls.

## Setting

**Immersive Lesson Mode**

Default: **Off**

Description:

Hide system navigation controls while learning for a more immersive full-screen experience.

## Behavior

Off:

- Standard Android system UI.
- Lesson content uses safe insets.

On:

- Lesson enters supported immersive presentation.
- System navigation is hidden.
- Lesson controls remain accessible.
- System UI is restored when leaving lessons.

## Rules

- Persist the setting.
- Apply it to lesson screens only.
- Do not unexpectedly change the rest of the app.
- Respect Android limitations.
- Handle rotation.
- Handle app background/resume.

## Done When

A learner can turn immersive lesson mode on or off from Settings and the behavior remains predictable after app restart.
