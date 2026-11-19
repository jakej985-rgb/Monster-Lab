#!/usr/bin/env python3
"""
Monster Lab - Printable Project Worksheet Generator
Generates clean, classroom- and home-friendly printable worksheets
(in Markdown and HTML formats) from project curriculum definitions.
Includes:
1. Project Overview & Story
2. Bill of Materials (BOM) with part checkboxes
3. Safety & ESD precautions
4. Step-by-step build phases and wiring tables
5. Troubleshooting quick-guide
6. Learner reflection notes & completion sign-off
"""

import os
import sys
import json
import glob
import argparse

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROJECTS_DIR = os.path.join(ROOT_DIR, "assets", "curriculum", "projects")
OUTPUT_DIR = os.path.join(ROOT_DIR, "reports", "worksheets")

def format_markdown_worksheet(p: dict) -> str:
    pid = p.get("id", "proj")
    title = p.get("title", "Monster Lab Project")
    tagline = p.get("tagline", "")
    story = p.get("story", "")
    tier = p.get("tier", "rookie").capitalize()
    time_est = p.get("estimatedMinutes", 30)
    components = p.get("requiredComponents", [])
    phases = p.get("phases", [])
    troubleshooting = p.get("troubleshooting", [])

    lines = [
        f"# Monster Lab Project Worksheet: {title}",
        f"**Difficulty:** {tier} | **Estimated Time:** {time_est} minutes | **Project ID:** `{pid}`",
        f"*{tagline}*",
        "",
        "---",
        "",
        "## 1. Mission Briefing",
        f"{story if story else 'Construct the circuit, program the microcontroller, and test your device.'}",
        "",
        "## 2. Parts Checklist (Bill of Materials)",
        "Gather all required components before connecting any power wires:",
        "",
    ]

    for comp in components:
        lines.append(f"- [ ] `{comp}`")

    lines.extend([
        "",
        "## 3. Safety First! ⚡",
        "> [!IMPORTANT]",
        "> - Never wire or adjust breadboard connections while USB power is plugged in.",
        "> - Double check that 5V and GND never touch directly (prevents short circuits).",
        "> - Verify LED and electrolytic capacitor polarity before powering up.",
        "",
        "## 4. Build Phases & Circuit Wiring",
        "",
    ])

    for phase in phases:
        num = phase.get("phaseNumber", 1)
        p_title = phase.get("phaseTitle", f"Phase {num}")
        instructions = phase.get("instructions", "")
        code = phase.get("codeSnippet")
        wiring = phase.get("wiringConnections", [])
        safety = phase.get("safetyCallout")

        lines.append(f"### [ ] Phase {num}: {p_title}")
        lines.append(f"{instructions}")
        lines.append("")

        if safety:
            lines.append(f"**Safety Alert:** *{safety}*")
            lines.append("")

        if wiring:
            lines.append("**Wiring Connections Table:**")
            lines.append("| From Component Pin | To Arduino / Rail | Wire Color | Verified [X] |")
            lines.append("| :--- | :--- | :--- | :---: |")
            for conn in wiring:
                from_pin = conn.get("from", "Pin")
                to_pin = conn.get("to", "Pin")
                color = conn.get("color", "Any")
                lines.append(f"| {from_pin} | {to_pin} | {color} | [ ] |")
            lines.append("")

        if code:
            lines.append("**Arduino Code:**")
            lines.append("```cpp")
            lines.append(code.strip())
            lines.append("```")
            lines.append("")

    if troubleshooting:
        lines.extend([
            "## 5. Troubleshooting Guide",
            "If your circuit doesn't react as expected, check these common fixes:",
            "",
            "| Symptom | Probable Cause | Action / Fix |",
            "| :--- | :--- | :--- |",
        ])
        for t in troubleshooting:
            sym = t.get("symptom", "").replace("|", "-")
            cau = t.get("cause", "").replace("|", "-")
            sol = t.get("solution", "").replace("|", "-")
            lines.append(f"| {sym} | {cau} | {sol} |")
        lines.append("")

    lines.extend([
        "## 6. Engineer's Lab Reflection",
        "Write down your observations and discoveries:",
        "",
        "1. What did your monster/device do when powered on?",
        "   _____________________________________________________________________________",
        "",
        "2. Did you encounter any bugs or loose wires? How did you solve it?",
        "   _____________________________________________________________________________",
        "",
        "---",
        "**Learner Signature:** ______________________   **Date:** _______________",
        "**Educator / Parent Verification:** ______________________   **Award:** 🌟 100 XP",
        "",
    ])

    return "\n".join(lines)

def generate_all_worksheets() -> int:
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    pattern = os.path.join(PROJECTS_DIR, "proj_*.json")
    files = sorted(glob.glob(pattern))

    if not files:
        print(f"[ERROR] No project files found in {PROJECTS_DIR}", file=sys.stderr)
        return 1

    print(f"Generating printable worksheets for {len(files)} projects...")
    count = 0
    for fpath in files:
        with open(fpath, "r", encoding="utf-8") as f:
            data = json.load(f)

        pid = data.get("id")
        md_content = format_markdown_worksheet(data)
        out_path = os.path.join(OUTPUT_DIR, f"{pid}_worksheet.md")

        with open(out_path, "w", encoding="utf-8") as out:
            out.write(md_content)
        count += 1

    print(f"[SUCCESS] Successfully generated {count} printable worksheets in {OUTPUT_DIR}")
    return 0

if __name__ == "__main__":
    sys.exit(generate_all_worksheets())
