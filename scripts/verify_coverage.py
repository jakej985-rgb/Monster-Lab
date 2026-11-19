#!/usr/bin/env python3
"""
Monster Lab - Repository Coverage Report & Quality Threshold Validator
Parses lcov.info, calculates package and repo-wide line coverage,
and enforces a baseline coverage gate (default >= 80.0%).
"""

import os
import sys
import argparse

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LCOV_PATH = os.path.join(ROOT_DIR, "coverage", "lcov.info")

def parse_lcov(filepath: str):
    files = {}
    current_file = None
    lf = 0
    lh = 0

    if not os.path.exists(filepath):
        print(f"[ERROR] Coverage file not found at {filepath}", file=sys.stderr)
        print("Run 'flutter test --coverage' first to generate coverage/lcov.info", file=sys.stderr)
        return None

    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("SF:"):
                current_file = line[3:]
                lf = 0
                lh = 0
            elif line.startswith("LF:"):
                lf = int(line[3:])
            elif line.startswith("LH:"):
                lh = int(line[3:])
            elif line == "end_of_record" and current_file:
                files[current_file] = {"lf": lf, "lh": lh}
                current_file = None

    return files

def analyze_coverage(threshold: float = 80.0):
    files = parse_lcov(LCOV_PATH)
    if files is None:
        return 1

    total_lf = sum(info["lf"] for info in files.values())
    total_lh = sum(info["lh"] for info in files.values())

    if total_lf == 0:
        print("[ERROR] No measurable lines found in coverage report.", file=sys.stderr)
        return 1

    overall_pct = (total_lh / total_lf) * 100.0

    print("=================================================================")
    print("           MONSTER LAB - TEST COVERAGE REPORT                    ")
    print("=================================================================")
    print(f"Total Source Files Tracked : {len(files)}")
    print(f"Total Measurable Lines (LF): {total_lf}")
    print(f"Total Covered Lines    (LH): {total_lh}")
    print(f"Overall Line Coverage      : {overall_pct:.2f}% (Threshold: {threshold:.1f}%)")
    print("-----------------------------------------------------------------")

    # Group by subsystem
    subsystems = {}
    for path, stats in files.items():
        parts = path.split("/")
        category = "/".join(parts[:2]) if len(parts) >= 2 else "root"
        if category not in subsystems:
            subsystems[category] = {"lf": 0, "lh": 0, "files": 0}
        subsystems[category]["lf"] += stats["lf"]
        subsystems[category]["lh"] += stats["lh"]
        subsystems[category]["files"] += 1

    print(f"{'Subsystem':<32} {'Files':<8} {'Lines (LH/LF)':<18} {'Coverage'}")
    print("-" * 65)
    for sub, data in sorted(subsystems.items()):
        sub_pct = (data["lh"] / data["lf"] * 100.0) if data["lf"] > 0 else 0.0
        line_stat = f"{data['lh']}/{data['lf']}"
        print(f"{sub:<32} {data['files']:<8} {line_stat:<18} {sub_pct:.1f}%")

    print("=================================================================")

    if overall_pct < threshold:
        print(f"[FAILURE] Overall coverage ({overall_pct:.2f}%) is BELOW threshold of {threshold:.1f}%!", file=sys.stderr)
        return 1

    print(f"[SUCCESS] Repository coverage ({overall_pct:.2f}%) satisfies gate threshold (>= {threshold:.1f}%).")
    return 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Validate Monster Lab test coverage threshold.")
    parser.add_argument("--threshold", type=float, default=80.0, help="Required line coverage percentage (default: 80.0)")
    args = parser.parse_args()
    sys.exit(analyze_coverage(args.threshold))
