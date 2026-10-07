#!/usr/bin/env python3
"""
scripts/generate_release_changelog.py
Automated release change & impact analyzer for Monster Lab and general git repositories.
Extracts commits between releases, analyzes diff stats, and produces structured drafts
highlighting What Changed, Why, and User/Architectural Impact.
"""

import sys
import os
import re
import subprocess
import argparse
from datetime import datetime


def run_git(args):
    proc = subprocess.run(["git"] + args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if proc.returncode != 0:
        return ""
    return proc.stdout.strip()


def get_latest_tags(count=2):
    out = run_git(["tag", "--sort=-creatordate"])
    if not out:
        return []
    tags = [t.strip() for t in out.split("\n") if t.strip()]
    return tags[:count]


def get_commits_in_range(start_ref, end_ref="HEAD"):
    range_str = f"{start_ref}..{end_ref}" if start_ref else end_ref
    raw = run_git(["log", range_str, "--pretty=format:%h%x1f%s%x1f%b%x1e"])
    if not raw:
        return []
    commits = []
    for entry in raw.split("\x1e"):
        parts = entry.strip().split("\x1f")
        if len(parts) >= 2:
            sha = parts[0].strip()
            subject = parts[1].strip()
            body = parts[2].strip() if len(parts) > 2 else ""
            if sha:
                commits.append({"sha": sha, "subject": subject, "body": body})
    return commits


def get_diff_stat(start_ref, end_ref="HEAD"):
    range_str = f"{start_ref}..{end_ref}" if start_ref else end_ref
    return run_git(["diff", range_str, "--stat"])


CHANGELOG_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "CHANGELOG.md")


def extract_from_changelog(version):
    if not os.path.exists(CHANGELOG_PATH):
        return None
    try:
        with open(CHANGELOG_PATH, "r", encoding="utf-8") as f:
            content = f.read()
        clean_ver = version.lstrip("v").split("+")[0]
        # Match ## [version...] until next ## [ or EOF
        pattern = rf"(## \[(?:v)?{re.escape(clean_ver)}[^\]]*\].*?)(?=\n## \[|\Z)"
        match = re.search(pattern, content, re.DOTALL)
        if match:
            entry = match.group(1).strip()
            # If entry has substantial content beyond a single line bullet
            lines = [l for l in entry.splitlines() if l.strip()]
            if len(lines) > 2:
                return entry
    except Exception:
        pass
    return None


def categorize_commit(commit):
    subj = commit["subject"].lower()
    if any(k in subj for k in ["ui", "screen", "widget", "design", "ux", "responsive", "theme", "scroll", "folder"]):
        return "UX"
    elif any(k in subj for k in ["break", "rename", "migrate", "remove"]):
        return "Breaking"
    elif any(k in subj for k in ["fix", "repair", "resolve", "patch"]):
        return "Fixes"
    elif any(k in subj for k in ["arch", "model", "engine", "repo", "data", "curriculum", "lesson"]):
        return "Architecture"
    elif any(k in subj for k in ["tool", "script", "ci", "workflow", "build", "dock", "package"]):
        return "Toolchain"
    elif any(k in subj for k in ["doc", "readme", "spec", "audit", "plan"]):
        return "Docs"
    elif any(k in subj for k in ["feat", "add", "introduce", "implement"]):
        return "Features"
    return "Features"


def generate_draft(version, start_ref, end_ref="HEAD"):
    commits = get_commits_in_range(start_ref, end_ref)
    today = datetime.now().strftime("%Y-%m-%d")

    groups = {
        "Features": [],
        "Breaking": [],
        "Architecture": [],
        "UX": [],
        "Fixes": [],
        "Toolchain": [],
        "Docs": [],
    }

    for c in commits:
        cat = categorize_commit(c)
        groups[cat].append(c)

    lines = []
    lines.append(f"## [{version}] - {today}\n")
    lines.append("### Overview & Release Highlights")
    lines.append(f"Release {version} introduces updates across {len(commits)} commits.\n")

    section_titles = {
        "Features": "🚀 New Features & Capabilities",
        "Breaking": "⚠️ Breaking Changes & Migrations",
        "Architecture": "🏗️ Architecture & Data Layer",
        "UX": "🎨 User Experience & Design System",
        "Fixes": "🐛 Bug Fixes & Stability",
        "Toolchain": "🛠️ Developer Toolchains & CI/CD",
        "Docs": "📚 Documentation & Specifications",
    }

    for key, title in section_titles.items():
        if groups[key]:
            lines.append(f"### {title}")
            for c in groups[key]:
                lines.append(f"- **{c['subject']}** (`{c['sha']}`):")
                body_desc = c['body'].replace("\n", " ") if c['body'] else ""
                if body_desc:
                    lines.append(f"  - *What Changed*: {body_desc}")
                else:
                    lines.append(f"  - *What Changed*: Implemented changes described in commit.")
                lines.append(f"  - *Why*: Technical necessity and user enhancement.")
            lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Generate release changelog with detailed rationale")
    parser.add_argument("--version", default="Unreleased", help="Target version string")
    parser.add_argument("--since", default=None, help="Starting git tag/ref")
    parser.add_argument("--until", default="HEAD", help="Ending git tag/ref")
    parser.add_argument("--output", default=None, help="Path to write output markdown")
    parser.add_argument("--force-generate", action="store_true", help="Always synthesize from git history")
    args = parser.parse_args()

    content = None
    if not args.force_generate:
        content = extract_from_changelog(args.version)

    if not content:
        start_tag = args.since
        if not start_tag:
            tags = get_latest_tags(1)
            start_tag = tags[0] if tags else None
        content = generate_draft(args.version, start_tag, args.until)

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(content + "\n")
        print(f"Changelog written to {args.output}")
    else:
        print(content)


if __name__ == "__main__":
    main()
