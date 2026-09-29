#!/usr/bin/env python3
"""
Monster Lab - Debian Package (.deb) Generator
Builds a standard Linux .deb package from the Flutter Linux release bundle.
"""

import os
import sys
import shutil
import subprocess
import argparse

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def parse_pubspec_version():
    pubspec_path = os.path.join(ROOT_DIR, "pubspec.yaml")
    if os.path.exists(pubspec_path):
        with open(pubspec_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.startswith("version:"):
                    raw = line.split(":", 1)[1].strip()
                    return raw.split("+")[0]
    return "1.0.0"

def create_deb_package(bundle_dir: str, output_deb: str):
    if not os.path.exists(bundle_dir):
        print(f"Error: Bundle directory not found: {bundle_dir}", file=sys.stderr)
        print("Please build the Linux release first: flutter build linux --release", file=sys.stderr)
        sys.exit(1)

    version = parse_pubspec_version()
    package_name = "monster-lab"

    staging_dir = os.path.join(ROOT_DIR, "build", "deb_staging")
    if os.path.exists(staging_dir):
        shutil.rmtree(staging_dir)

    print(f"Staging Debian package '{package_name}' v{version}...")

    # 1. Directory Structure
    debian_dir = os.path.join(staging_dir, "DEBIAN")
    lib_dir = os.path.join(staging_dir, "usr", "lib", package_name)
    bin_dir = os.path.join(staging_dir, "usr", "bin")
    apps_dir = os.path.join(staging_dir, "usr", "share", "applications")
    pixmaps_dir = os.path.join(staging_dir, "usr", "share", "pixmaps")
    icons_dir = os.path.join(staging_dir, "usr", "share", "icons", "hicolor", "256x256", "apps")
    usr_keyrings_dir = os.path.join(staging_dir, "usr", "share", "keyrings")
    etc_keyrings_dir = os.path.join(staging_dir, "etc", "apt", "keyrings")
    apt_sources_dir = os.path.join(staging_dir, "etc", "apt", "sources.list.d")

    for d in [debian_dir, lib_dir, bin_dir, apps_dir, pixmaps_dir, icons_dir, usr_keyrings_dir, etc_keyrings_dir, apt_sources_dir]:
        os.makedirs(d, exist_ok=True)
    os.chmod(staging_dir, 0o755)
    os.chmod(debian_dir, 0o755)

    # 2. Copy Linux Release Bundle to /usr/lib/monster-lab/
    for item in os.listdir(bundle_dir):
        s = os.path.join(bundle_dir, item)
        d = os.path.join(lib_dir, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, symlinks=True)
        else:
            shutil.copy2(s, d)

    # Ensure executable permission on main binary
    main_binary = os.path.join(lib_dir, "monster_lab")
    if os.path.exists(main_binary):
        os.chmod(main_binary, 0o755)

    # 3. Create launcher script at /usr/bin/monster-lab
    launcher_path = os.path.join(bin_dir, package_name)
    with open(launcher_path, "w", encoding="utf-8") as f:
        f.write("#!/bin/sh\n")
        f.write(f'exec /usr/lib/{package_name}/monster_lab "$@"\n')
    os.chmod(launcher_path, 0o755)

    # 4. Create .desktop entry at /usr/share/applications/monster-lab.desktop
    desktop_path = os.path.join(apps_dir, f"{package_name}.desktop")
    with open(desktop_path, "w", encoding="utf-8") as f:
        f.write("[Desktop Entry]\n")
        f.write("Name=Monster Lab\n")
        f.write("GenericName=Electronics Studio\n")
        f.write("Comment=Hands-on Arduino & Electronics Studio for Kids\n")
        f.write(f"Exec={package_name}\n")
        f.write(f"Icon={package_name}\n")
        f.write("Terminal=false\n")
        f.write("Type=Application\n")
        f.write("Categories=Education;Science;Electronics;Development;\n")
        f.write("Keywords=arduino;electronics;robotics;stem;education;kids;\n")
        f.write("StartupWMClass=monster_lab\n")
    os.chmod(desktop_path, 0o644)

    # 5. Copy desktop icons
    icon_source = os.path.join(ROOT_DIR, "assets", "icons", "linux", "monster_lab_256x256.png")
    if not os.path.exists(icon_source):
        # Fallback to master icon
        icon_source = os.path.join(ROOT_DIR, "assets", "images", "app_icon.png")

    if os.path.exists(icon_source):
        shutil.copy2(icon_source, os.path.join(pixmaps_dir, f"{package_name}.png"))
        shutil.copy2(icon_source, os.path.join(icons_dir, f"{package_name}.png"))
        os.chmod(os.path.join(pixmaps_dir, f"{package_name}.png"), 0o644)
        os.chmod(os.path.join(icons_dir, f"{package_name}.png"), 0o644)

    # 6. Copy Debian GPG Keyring & APT sources entry
    keyring_source = os.path.join(ROOT_DIR, "linux", "keyring", "monster-lab-archive-keyring.gpg")
    if not os.path.exists(keyring_source):
        # Auto-generate keyring if not present
        keyring_gen_script = os.path.join(ROOT_DIR, "scripts", "generate_deb_keyring.py")
        if os.path.exists(keyring_gen_script):
            subprocess.run([sys.executable, keyring_gen_script], check=True)

    if os.path.exists(keyring_source):
        usr_keyring_dest = os.path.join(usr_keyrings_dir, "monster-lab-archive-keyring.gpg")
        etc_keyring_dest = os.path.join(etc_keyrings_dir, "monster-lab-archive-keyring.gpg")
        shutil.copy2(keyring_source, usr_keyring_dest)
        shutil.copy2(keyring_source, etc_keyring_dest)
        os.chmod(usr_keyring_dest, 0o644)
        os.chmod(etc_keyring_dest, 0o644)

        # Also provide /etc/apt/sources.list.d/monster-lab.list
        sources_list_path = os.path.join(apt_sources_dir, f"{package_name}.list")
        with open(sources_list_path, "w", encoding="utf-8") as f:
            f.write("# Monster Lab Official Debian Repository\n")
            f.write("# Verification Key: /etc/apt/keyrings/monster-lab-archive-keyring.gpg\n")
            f.write("deb [signed-by=/etc/apt/keyrings/monster-lab-archive-keyring.gpg] https://github.com/jakej985-rgb/Monster-Lab/releases/latest/download/ ./\n")
        os.chmod(sources_list_path, 0o644)

    # Calculate installed size in KB
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(staging_dir):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    installed_size_kb = (total_size + 1023) // 1024

    # 6. Create DEBIAN/control file
    control_path = os.path.join(debian_dir, "control")
    with open(control_path, "w", encoding="utf-8") as f:
        f.write(f"Package: {package_name}\n")
        f.write(f"Version: {version}\n")
        f.write("Section: education\n")
        f.write("Priority: optional\n")
        f.write("Architecture: amd64\n")
        f.write(f"Installed-Size: {installed_size_kb}\n")
        f.write("Depends: libc6 (>= 2.31), libgtk-3-0 (>= 3.24), libglib2.0-0\n")
        f.write("Maintainer: Monster Lab Team <support@monsterlab.org>\n")
        f.write("Homepage: https://github.com/monsterlab/monster_lab\n")
        f.write("Description: Monster Lab - Educational Arduino & Electronics Studio\n")
        f.write(" Hands-on offline STEM robotics learning studio for kids.\n")
        f.write(" Features 12 guided lessons, 38 sensor components, 20 build projects,\n")
        f.write(" 24 troubleshooting challenges, and physical serial hardware companion.\n")
    os.chmod(control_path, 0o644)

    # 7. Build DEB package using dpkg-deb
    output_dir = os.path.dirname(os.path.abspath(output_deb))
    os.makedirs(output_dir, exist_ok=True)

    print(f"Building Debian archive with dpkg-deb -> {output_deb}...")
    cmd = ["dpkg-deb", "--build", "--root-owner-group", staging_dir, output_deb]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0:
        print(f"dpkg-deb build failed:\n{res.stderr}", file=sys.stderr)
        sys.exit(res.returncode)

    file_size_mb = os.path.getsize(output_deb) / (1024 * 1024)
    print(f"[SUCCESS] Debian package created successfully: {output_deb} ({file_size_mb:.2f} MB)")

    # Print metadata
    info_cmd = ["dpkg-deb", "-I", output_deb]
    info_res = subprocess.run(info_cmd, capture_output=True, text=True)
    print("\n--- Package Control Info ---")
    print(info_res.stdout.strip())

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Package Monster Lab Linux build into a .deb archive.")
    parser.add_argument("--bundle-dir", default=os.path.join(ROOT_DIR, "build", "linux", "x64", "release", "bundle"),
                        help="Path to compiled Flutter Linux bundle directory")
    parser.add_argument("--output", default=os.path.join(ROOT_DIR, "monster-lab-linux.deb"),
                        help="Path to output .deb package")
    args = parser.parse_args()

    create_deb_package(args.bundle_dir, args.output)
