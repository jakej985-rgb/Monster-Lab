#!/usr/bin/env python3
"""
Monster Lab - Release Checksums & Provenance Generator
Computes SHA-256 checksums and SLSA-compatible build provenance metadata
for all release artifacts in build/ and dist/ directories.
"""

import hashlib
import json
import os
import sys
from datetime import datetime, timezone

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def sha256_file(filepath: str) -> str:
    h = hashlib.sha256()
    with open(filepath, "rb") as f:
        while chunk := f.read(65536):
            h.update(chunk)
    return h.hexdigest()

def generate_checksums_and_provenance(artifact_paths: list, output_dir: str = None) -> tuple:
    if output_dir is None:
        output_dir = os.path.join(ROOT_DIR, "build", "release")
    os.makedirs(output_dir, exist_ok=True)

    checksums_file = os.path.join(output_dir, "SHA256SUMS.txt")
    provenance_file = os.path.join(output_dir, "provenance.json")

    version_json_path = os.path.join(ROOT_DIR, "version.json")
    version = "unknown"
    if os.path.exists(version_json_path):
        with open(version_json_path, "r", encoding="utf-8") as f:
            version = json.load(f).get("version", "unknown")

    checksum_lines = []
    artifacts_metadata = []

    for path in artifact_paths:
        if not os.path.exists(path):
            continue
        filename = os.path.basename(path)
        digest = sha256_file(path)
        size = os.path.getsize(path)

        checksum_lines.append(f"{digest}  {filename}")
        artifacts_metadata.append({
            "name": filename,
            "path": os.path.relpath(path, ROOT_DIR),
            "sizeBytes": size,
            "sha256": digest,
        })

    with open(checksums_file, "w", encoding="utf-8") as f:
        f.write("\n".join(checksum_lines) + ("\n" if checksum_lines else ""))

    provenance_data = {
        "_type": "https://in-toto.io/Statement/v0.1",
        "predicateType": "https://slsa.dev/provenance/v0.2",
        "subject": [
            {"name": a["name"], "digest": {"sha256": a["sha256"]}}
            for a in artifacts_metadata
        ],
        "builder": {
            "id": "https://github.com/jakej985-rgb/Monster-Lab/.github/workflows/release.yml"
        },
        "metadata": {
            "buildStartedOn": datetime.now(timezone.utc).isoformat(),
            "releaseVersion": version,
            "reproducible": True,
            "artifacts": artifacts_metadata,
        }
    }

    with open(provenance_file, "w", encoding="utf-8") as f:
        json.dump(provenance_data, f, indent=2)

    return checksums_file, provenance_file

def verify_checksums(checksums_file: str, base_dir: str = None) -> bool:
    if not os.path.exists(checksums_file):
        return False
    if base_dir is None:
        base_dir = os.path.dirname(checksums_file)

    with open(checksums_file, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split(maxsplit=1)
            if len(parts) != 2:
                continue
            expected_hash, fname = parts
            target = os.path.join(base_dir, fname)
            if not os.path.exists(target):
                target = os.path.join(ROOT_DIR, fname)
                if not os.path.exists(target):
                    return False
            actual_hash = sha256_file(target)
            if actual_hash != expected_hash:
                return False
    return True

if __name__ == "__main__":
    test_files = [os.path.join(ROOT_DIR, "version.json"), os.path.join(ROOT_DIR, "pubspec.yaml")]
    c, p = generate_checksums_and_provenance(test_files)
    print(f"[OK] Checksums written to: {c}")
    print(f"[OK] Provenance written to: {p}")
    valid = verify_checksums(c, ROOT_DIR)
    print(f"[OK] Checksums verified: {valid}")
