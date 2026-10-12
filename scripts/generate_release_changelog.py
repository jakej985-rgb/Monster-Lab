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


PUBSPEC_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "pubspec.yaml")


def get_current_pubspec_version():
    if not os.path.exists(PUBSPEC_PATH):
        return None, None
    with open(PUBSPEC_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    match = re.search(r"^version:\s*([0-9]+\.[0-9]+\.[0-9]+)(?:\+([0-9]+))?", content, re.MULTILINE)
    if match:
        semver = match.group(1)
        build = int(match.group(2)) if match.group(2) else 1
        return semver, build
    return None, None


def update_pubspec_version(new_semver, new_build):
    if not os.path.exists(PUBSPEC_PATH):
        return False
    with open(PUBSPEC_PATH, "r", encoding="utf-8") as f:
        content = f.read()
    new_version_str = f"version: {new_semver}+{new_build}"
    updated = re.sub(r"^version:\s*.*$", new_version_str, content, flags=re.MULTILINE)
    with open(PUBSPEC_PATH, "w", encoding="utf-8") as f:
        f.write(updated)
    return True


def determine_bump_level(commits):
    """
    Evaluates commit messages to recommend MAJOR, MINOR, or PATCH bump level.
    """
    has_breaking = False
    has_minor = False

    for c in commits:
        subj = c["subject"]
        body = c.get("body", "")
        combined = f"{subj}\n{body}"

        # 1. Breaking changes -> MAJOR
        if re.search(r"^[a-z]+(\([^\)]+\))?!:", subj) or "BREAKING CHANGE:" in combined:
            has_breaking = True
            break

        # 2. Features / Curriculum / Significant capabilities -> MINOR
        if re.search(r"^feat(\([^\)]+\))?:", subj):
            has_minor = True
        elif any(k in subj.lower() for k in ["feat", "feature", "curriculum", "milestone", "course", "expansion"]):
            has_minor = True

    if has_breaking:
        return "major"
    elif has_minor:
        return "minor"
    return "patch"


def calculate_next_version(current_semver, current_build, bump_type="auto", commits=None):
    if commits is None:
        commits = []
    
    parts = [int(p) for p in current_semver.split(".")]
    major, minor, patch = parts[0], parts[1], parts[2]

    if bump_type == "auto":
        bump_type = determine_bump_level(commits)

    if bump_type == "major":
        next_semver = f"{major + 1}.0.0"
    elif bump_type == "minor":
        next_semver = f"{major}.{minor + 1}.0"
    else:  # patch
        next_semver = f"{major}.{minor}.{patch + 1}"

    next_build = current_build + 1
    return next_semver, next_build, bump_type


def prepend_to_changelog(new_entry):
    if not os.path.exists(CHANGELOG_PATH):
        with open(CHANGELOG_PATH, "w", encoding="utf-8") as f:
            f.write("# Changelog\n\n" + new_entry + "\n")
        return True

    with open(CHANGELOG_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    # Locate first release entry (## [) or header divider (---)
    match = re.search(r"(## \[.*?\])", content)
    if match:
        idx = match.start()
        updated = content[:idx] + new_entry + "\n\n---\n\n" + content[idx:]
    else:
        updated = content + "\n\n" + new_entry + "\n"

    with open(CHANGELOG_PATH, "w", encoding="utf-8") as f:
        f.write(updated)
    return True


def main():
    parser = argparse.ArgumentParser(description="Generate release changelog and automate semantic version bumping")
    parser.add_argument("--version", default=None, help="Target version string (e.g. 0.2.0 or 0.2.0+25)")
    parser.add_argument("--since", default=None, help="Starting git tag/ref")
    parser.add_argument("--until", default="HEAD", help="Ending git tag/ref")
    parser.add_argument("--output", default=None, help="Path to write output markdown")
    parser.add_argument("--force-generate", action="store_true", help="Always synthesize from git history")
    parser.add_argument("--bump", choices=["auto", "major", "minor", "patch"], help="Compute semantic version bump")
    parser.add_argument("--apply", action="store_true", help="Apply version bump to pubspec.yaml and CHANGELOG.md")
    args = parser.parse_args()

    current_semver, current_build = get_current_pubspec_version()
    if not current_semver:
        current_semver, current_build = "0.1.0", 1

    start_tag = args.since
    if not start_tag:
        tags = get_latest_tags(1)
        start_tag = tags[0] if tags else None

    commits = get_commits_in_range(start_tag, args.until)

    target_semver = current_semver
    target_build = current_build
    bump_reason = None

    if args.bump:
        target_semver, target_build, bump_reason = calculate_next_version(
            current_semver, current_build, args.bump, commits
        )
        print(f"Current version : {current_semver}+{current_build}")
        print(f"Calculated bump : {bump_reason.upper()} -> {target_semver}+{target_build}")

    if args.version:
        if "+" in args.version:
            target_semver, b_str = args.version.split("+", 1)
            target_build = int(b_str) if b_str.isdigit() else current_build + 1
        else:
            target_semver = args.version
            target_build = current_build + 1

    full_version_tag = f"{target_semver}+{target_build}"

    content = None
    if not args.force_generate and not args.bump:
        content = extract_from_changelog(target_semver)

    if not content:
        content = generate_draft(full_version_tag, start_tag, args.until)

    if args.apply:
        print(f"Applying version update to pubspec.yaml: {full_version_tag}")
        update_pubspec_version(target_semver, target_build)
        print("Prepending release section to CHANGELOG.md...")
        prepend_to_changelog(content)
        print("Done. Recommended git commands:")
        print(f"  git commit -am 'chore(release): bump version to v{target_semver}'")
        print(f"  git tag v{target_semver}")

    if args.output:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(content + "\n")
        print(f"Changelog written to {args.output}")
    elif not args.apply:
        print(content)


if __name__ == "__main__":
    main()
