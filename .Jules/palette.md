## 2024-05-18 - Tooltips on custom IconButtons
**Learning:** Custom `IconButton`s in Flutter need an explicit `tooltip` property for screen readers and mouse hovers, as the `Icon` widget inside them does not inherently communicate purpose.
**Action:** Always check `IconButton`s for `tooltip` properties, especially those used for navigation (e.g., 'Back', 'Close') or actions (e.g., 'Copy').
