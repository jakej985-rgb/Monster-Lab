# 25 — Curriculum Correction Plan

**Curriculum Guardian Audit & Governance**  
**Action Plan**: Structured remediation roadmap categorized by implementation priority.

---

## 1. Pre-Implementation (Completed in Phase 25 Audit)

The following reconciliations and baseline checks have been evaluated and finalized:
- [x] **Reconcile Lesson 2 Architecture**: Formalized the separation between Course 2A (*Monster Lab Walkthrough*) and Course 2B (*Arduino IDE Walkthrough*).
- [x] **Verify Placement Logic**: Validated `coding_foundations` placement mechanism (`cf_08`) to ensure experienced learners can skip without missing prerequisite unlocks.
- [x] **Verify Backward Compatibility**: Confirmed `LearnerProgressModel.migrateFromOldFormat` preserves existing user progress.
- [x] **Automated Validation**: Verified 100% integrity across 35 lessons, 54 components, 20 projects, 24 challenges, and 20 badges via `python3 scripts/validate_curriculum.py` and Flutter test suites.
- [x] **Child Safety Audit**: Verified zero open flame, zero AC mains, and strict Parent Mode gating for laser modules.

---

## 2. During Implementation (Phase 26+ Content & Feature Builds)

Actions to execute during subsequent curriculum and UI development sprints:
1. **Interactive Waveform Simulators for Lessons 09–10**:
   - Add animated SDA/SCL and MOSI/MISO line transition widgets to deconstruct serial bus frames visually for Builder and Engineer tiers.
2. **Inline Safety Checkpoints in Build Lab Projects**:
   - Add explicit pre-power safety validation dialogs before any project step requiring external battery packs (`comp_power_supply`).
3. **Expandable Visual Schema Integration**:
   - Continue adopting the Phase 24 expandable image format across all project breadboard assembly steps.

---

## 3. Post-Implementation (Continuous Curriculum Governance)

Permanent operational guidelines for the **Curriculum Guardian**:
- **Continuous Audit Gate**: Any PR or commit modifying `assets/curriculum/**` or curriculum models must run:
  ```bash
  python3 scripts/validate_curriculum.py
  flutter test test/unit/
  flutter test test/widget/
  flutter analyze
  ```
- **Prerequisite Integrity**: No lesson or project may introduce an unlisted component or prerequisite without updating the curriculum dependency map.
- **Pedagogical Gate**: All new lessons must uphold the **Learn → Build → Test → Change → Explain** and **Read → Predict → Change → Run → Observe → Explain** loops.
