#!/usr/bin/env python3
"""
Verification script for Monster Lab - Phase 03 Visual Design System.
Validates machine-readable theme_tokens.json, computes WCAG contrast ratios,
and ensures all 12 design system tasks from plan 03 are documented.
"""

import json
import os
import re
import sys

TOKENS_FILE = "design_system/theme_tokens.json"
DESIGN_DIR = "design_system"

PLAN_TASKS = [
    "branding",
    "typography",
    "color",
    "button",
    "card",
    "badge",
    "progress",
    "lesson step",
    "code display",
    "wiring diagram",
    "accessibility",
    "responsive"
]

def hex_to_rgb(hex_code):
    hex_code = hex_code.lstrip('#')
    return tuple(int(hex_code[i:i+2], 16) for i in (0, 2, 4))

def relative_luminance(rgb):
    def adjust(c):
        c = c / 255.0
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = [adjust(v) for v in rgb]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast_ratio(hex1, hex2):
    l1 = relative_luminance(hex_to_rgb(hex1))
    l2 = relative_luminance(hex_to_rgb(hex2))
    lighter = max(l1, l2)
    darker = min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)

def main():
    print("=== Monster Lab Visual Design System Verification ===")

    # 1. Validate theme_tokens.json
    print("1. Validating Theme Tokens JSON...")
    if not os.path.exists(TOKENS_FILE):
        print(f"FAILED: {TOKENS_FILE} missing.")
        sys.exit(1)

    with open(TOKENS_FILE, "r", encoding="utf-8") as f:
        try:
            tokens = json.load(f)
            assert "colors" in tokens
            assert "typography" in tokens
            assert "spacing" in tokens
            assert "radii" in tokens
            assert "touchTargets" in tokens
            assert "breakpoints" in tokens
            print("  ✓ theme_tokens.json is valid and contains all required categories.")
        except Exception as e:
            print(f"FAILED to parse theme tokens: {e}")
            sys.exit(1)

    # 2. Validate Color Contrast
    print("\n2. Computing WCAG Contrast Ratios...")
    text_primary = tokens["colors"]["surfaces"]["light"]["textPrimary"]
    surface_light = tokens["colors"]["surfaces"]["light"]["surface"]
    primary_violet = tokens["colors"]["brand"]["primaryViolet"]
    primary_violet_dark = tokens["colors"]["brand"]["primaryVioletDark"]

    ratio_text = contrast_ratio(text_primary, surface_light)
    ratio_violet_dark = contrast_ratio(primary_violet_dark, surface_light)
    print(f"  ✓ Text Primary ({text_primary}) on Surface ({surface_light}) Contrast: {ratio_text:.2f}:1 (Target: >= 7.0:1 AAA)")
    print(f"  ✓ High-Contrast Violet ({primary_violet_dark}) on Surface ({surface_light}) Contrast: {ratio_violet_dark:.2f}:1 (Target: >= 4.5:1 AA)")
    assert ratio_text >= 7.0, "Body text contrast ratio failed AAA standard"
    assert ratio_violet_dark >= 4.5, "Interactive dark violet failed AA standard"

    # 3. Verify Wire Colors
    print("\n3. Validating Physical Wire Color Standard...")
    wires = tokens["colors"]["wires"]
    expected_wires = ["power5v", "ground", "analog", "digital", "i2c", "spi", "signalAlt"]
    for w in expected_wires:
        assert w in wires, f"Missing wire token '{w}'"
        print(f"  ✓ Wire '{w}' defined as {wires[w]}")

    # 4. Verify Documentation Coverage for all 12 Tasks
    print("\n4. Validating Documentation Coverage across design_system/*.md...")
    combined_docs = ""
    for md_file in sorted(os.listdir(DESIGN_DIR)):
        if md_file.endswith(".md"):
            with open(os.path.join(DESIGN_DIR, md_file), "r", encoding="utf-8") as f:
                combined_docs += f.read().lower() + "\n"

    for task in PLAN_TASKS:
        assert task in combined_docs, f"Task '{task}' not adequately covered in design documentation"
        print(f"  ✓ Plan Task '{task}' verified in documentation.")

    print("\nSUCCESS: Phase 03 Visual Design System verification PASSED with 100% compliance!")

if __name__ == "__main__":
    main()
