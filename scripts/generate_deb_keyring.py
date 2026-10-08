#!/usr/bin/env python3
"""
Monster Lab - Debian GPG Keyring Synchronizer
Synchronizes and configures the canonical M3tal ecosystem signing keyring
(m3tal-archive-keyring.gpg) for Debian/Ubuntu package verification.
"""

import os
import sys
import shutil
import urllib.request
import subprocess

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KEYRING_DIR = os.path.join(ROOT_DIR, "linux", "keyring")

CENTRAL_KEY_URL = "https://jakej985-rgb.github.io/m3tal-apt-key/public.key"
CENTRAL_KEY_FINGERPRINT = "B95A45C647577DEBCC877C49AF6190B0C01346DD"
LOCAL_CENTRAL_REPO = os.path.expanduser("~/apps/m3tal-apt-key")


def sync_central_keyring():
    os.makedirs(KEYRING_DIR, exist_ok=True)
    target_gpg = os.path.join(KEYRING_DIR, "m3tal-archive-keyring.gpg")
    target_asc = os.path.join(KEYRING_DIR, "m3tal-archive-keyring.asc")

    # 1. Check local m3tal-apt-key repo first
    local_gpg = os.path.join(LOCAL_CENTRAL_REPO, "keyrings", "m3tal-archive-keyring.gpg")
    local_asc = os.path.join(LOCAL_CENTRAL_REPO, "keyrings", "m3tal-archive-keyring.asc")

    if os.path.exists(local_gpg):
        print(f"Syncing central keyring from local repo: {local_gpg}")
        shutil.copy2(local_gpg, target_gpg)
        if os.path.exists(local_asc):
            shutil.copy2(local_asc, target_asc)
    else:
        # 2. Download from official public key URL
        print(f"Fetching canonical M3tal public key from {CENTRAL_KEY_URL}...")
        try:
            req = urllib.request.Request(CENTRAL_KEY_URL, headers={"User-Agent": "MonsterLab-KeySync/1.0"})
            with urllib.request.urlopen(req) as resp, open(target_asc, "wb") as f:
                content = resp.read()
                f.write(content)

            # Dearmor to binary keyring
            gpg_bin = shutil.which("gpg")
            if gpg_bin:
                subprocess.run([gpg_bin, "--dearmor", "--output", target_gpg, target_asc], check=True)
        except Exception as e:
            print(f"Warning: Failed to download central key: {e}", file=sys.stderr)

    # 3. Maintain compatibility alias for legacy scripts
    compat_alias = os.path.join(KEYRING_DIR, "monster-lab-archive-keyring.gpg")
    if os.path.exists(target_gpg):
        shutil.copy2(target_gpg, compat_alias)
        compat_root = os.path.join(KEYRING_DIR, "monster-lab-keyring.gpg")
        shutil.copy2(target_gpg, compat_root)

    print(f"Central keyring synchronized: {target_gpg}")
    print(f"Expected Fingerprint: {CENTRAL_KEY_FINGERPRINT}")


if __name__ == "__main__":
    sync_central_keyring()
