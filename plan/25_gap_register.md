# 25 — Curriculum Gap Register

**Curriculum Guardian Audit & Governance**  
**Assessment Area**: Missing curriculum capabilities, scaffolding enhancements, vocabulary prerequisites, and interactive asset readiness.

---

## Identified Curriculum Gaps & Mitigations

### Gap CG-01: Visual Diagram Richness in Later Engineering Lessons (Lessons 09–12)
- **Description**: While Lessons 01–08 feature rich custom interactive simulators (`arduinoBoardInspector`, `visualFlowDiagram`, `decisionSimulator`, `executionSpeedVisualizer`), Lessons 09–12 (I2C, SPI, UART, PWM Motor Physics) rely primarily on code deconstructions and quizzes.
- **Impact**: Medium cognitive load on 9–11 year olds attempting to visualize multi-master bus arbitration or SPI clock polarity ($CPOL / CPHA$) without dynamic signal waveforms.
- **Mitigation / Next Steps**:
  - Incorporate Phase 24 expandable interactive timing diagrams for I2C and SPI transactions.
  - Implement dynamic oscilloscope/waveform simulators in future content revisions.

---

### Gap CG-02: Intermediate Microcontroller Architecture Scaffolding for Rookies
- **Description**: Lesson 01 introduces flash memory, SRAM, CPU, and GPIO. Rookies (ages 6–8) sometimes struggle to differentiate volatile SRAM from nonvolatile Flash memory.
- **Impact**: Minor confusion when discussing variable resets on board reboot.
- **Mitigation / Next Steps**:
  - Scaffolding added: "SRAM is the robot's short-term memory (like what you're thinking right now); Flash memory is its permanent memory book (like instructions written in stone)."
  - Reinforced in `cf_02` (Variables) and `lesson_04` (Microcontroller Lifecycle).

---

### Gap CG-03: Offline Breadboard Prototyping Without Hardware
- **Description**: Some learners may run Monster Lab on a tablet or desktop before their physical kit arrives or while traveling without hardware.
- **Impact**: Lessons referencing physical tasks (`physicalTask`) could cause confusion if learners feel blocked from progressing.
- **Mitigation / Next Steps**:
  - Ensure all `physicalTask` steps include virtual interactive simulators and "Predict & Verify" software modes so that completion is never strictly blocked by lack of physical hardware.
  - Phase 22 & Phase 23 activities already provide full software interactive widgets for all steps.

---

### Gap CG-04: Advanced Safety Badging in Build Lab Projects
- **Description**: Projects involving spinning motors (`proj_08`, `proj_10`, `proj_17`) or high-gain microphones (`proj_02`) need prominent inline safety reminders at the step where power is connected, not just in introductory overview text.
- **Impact**: Ensures young learners do not plug in 9V battery packs before inspecting wiring polarity.
- **Mitigation / Next Steps**:
  - Project step schemas should include mandatory `SafetyCheck` callouts before battery power connection steps.
  - Audit confirms safety rules are fully documented in `audit/05_safety_notes.md` and should be systematically mirrored into project step JSONs during Phase 26.
