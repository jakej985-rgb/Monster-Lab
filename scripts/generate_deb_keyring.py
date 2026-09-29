#!/usr/bin/env python3
"""
Monster Lab - Debian GPG Keyring Generator
Generates the official OpenPGP signing key and exports public keyrings
for Debian/Ubuntu package verification and APT repository integration.
"""

import os
import sys
import tempfile
import subprocess
import shutil

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KEYRING_DIR = os.path.join(ROOT_DIR, "linux", "keyring")

def generate_keyring():
    os.makedirs(KEYRING_DIR, exist_ok=True)

    gpg_binary = shutil.which("gpg")
    if not gpg_binary:
        print("Error: gpg executable not found on PATH.", file=sys.stderr)
        sys.exit(1)

    temp_gnupg = tempfile.mkdtemp(prefix="monster_lab_gpg_")
    try:
        # Generate batch key configuration
        batch_config = """Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Monster Lab Archive Automatic Signing Key
Name-Email: release@monsterlab.org
Expire-Date: 0
%no-protection
%commit
"""
        print("Generating Monster Lab OpenPGP 4096-bit release key...")
        gen_res = subprocess.run(
            [gpg_binary, "--homedir", temp_gnupg, "--batch", "--gen-key"],
            input=batch_config,
            text=True,
            capture_output=True
        )
        if gen_res.returncode != 0:
            print(f"Error generating GPG key:\n{gen_res.stderr}", file=sys.stderr)
            sys.exit(gen_res.returncode)

        # 1. Export binary keyring (OpenPGP dearmored format)
        binary_keyring_path = os.path.join(KEYRING_DIR, "monster-lab-archive-keyring.gpg")
        export_bin = subprocess.run(
            [gpg_binary, "--homedir", temp_gnupg, "--export"],
            capture_output=True
        )
        if export_bin.returncode != 0:
            print(f"Error exporting binary keyring:\n{export_bin.stderr}", file=sys.stderr)
            sys.exit(export_bin.returncode)

        with open(binary_keyring_path, "wb") as f:
            f.write(export_bin.stdout)
        print(f"Exported binary keyring -> {binary_keyring_path} ({len(export_bin.stdout)} bytes)")

        # 2. Export ASCII-armored public key (.asc)
        armor_keyring_path = os.path.join(KEYRING_DIR, "monster-lab-archive-keyring.asc")
        export_armor = subprocess.run(
            [gpg_binary, "--homedir", temp_gnupg, "--armor", "--export"],
            capture_output=True,
            text=True
        )
        if export_armor.returncode != 0:
            print(f"Error exporting armored keyring:\n{export_armor.stderr}", file=sys.stderr)
            sys.exit(export_armor.returncode)

        with open(armor_keyring_path, "w", encoding="utf-8") as f:
            f.write(export_armor.stdout)
        print(f"Exported ASCII-armored key -> {armor_keyring_path}")

        # 3. Create convenient root/release alias monster-lab-keyring.gpg
        root_alias_path = os.path.join(KEYRING_DIR, "monster-lab-keyring.gpg")
        shutil.copy2(binary_keyring_path, root_alias_path)
        print(f"Created release asset alias -> {root_alias_path}")

        # Print Key Fingerprint
        fp_res = subprocess.run(
            [gpg_binary, "--homedir", temp_gnupg, "--list-keys", "--fingerprint"],
            capture_output=True,
            text=True
        )
        print("\n--- Keyring Fingerprint & Details ---")
        print(fp_res.stdout.strip())

    finally:
        shutil.rmtree(temp_gnupg, ignore_errors=True)

if __name__ == "__main__":
    generate_keyring()
