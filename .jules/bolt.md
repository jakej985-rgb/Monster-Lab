## 2026-11-21 - [Parallel curriculum asset-group loads]
**Learning:** Starting all six curriculum asset groups concurrently did not improve cold initialization (270 ms median before, 273 ms after). The Flutter asset bundle/platform channel serializes the 253 small reads, and I/O dominates; JSON decode and validation are comparatively small.
**Action:** Do not parallelize curriculum group loads for startup speed. Reduce the asset count or defer groups that the current screen does not need, and benchmark with a fresh `PlatformAssetBundle` across multiple runs.

## 2026-11-21 - [Lesson detail future re-created on every rebuild]
**Learning:** `LessonDetailScreen` created its `FutureBuilder` future inside `build`, so every step/quiz/checkbox rebuild issued another `getLessonById` call (measured 2 fetches for one initial load plus one step transition) and reset through a transient loading state.
**Action:** Keep repository futures in `State` and recreate them only when the input ID changes. Verify with a counting repository implementation.
