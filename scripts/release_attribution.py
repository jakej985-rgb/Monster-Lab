#!/usr/bin/env python3
"""Shared attribution policy for release notes and CHANGELOG hygiene."""

import re

ASSISTANT_NAMES = r"(?:codebuff|claude|copilot|chatgpt|cursor|aider|devin)"

ATTRIBUTION_PATTERNS = (
    re.compile(r"🤖"),
    re.compile(rf"(?i)\bgenerated with\b[^\n]*\b{ASSISTANT_NAMES}\b"),
    re.compile(rf"(?i)\bco-authored-by:\s*{ASSISTANT_NAMES}\b"),
)


def find_attribution_footers(lines):
    findings = []
    for number, line in enumerate(lines, 1):
        if any(pattern.search(line) for pattern in ATTRIBUTION_PATTERNS):
            findings.append((number, line.strip()))
    return findings


def strip_commit_trailers(body):
    """Remove assistant attribution lines from a commit body used in release notes."""
    if not body:
        return ""
    kept_lines = [
        line
        for line in body.splitlines()
        if not any(pattern.search(line) for pattern in ATTRIBUTION_PATTERNS)
    ]
    return " ".join(" ".join(kept_lines).split())
