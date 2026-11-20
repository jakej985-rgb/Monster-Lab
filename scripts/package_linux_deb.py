#!/usr/bin/env python3
"""
Monster Lab - Debian Package (.deb) Generator
Builds a standard Linux .deb package from the Flutter Linux release bundle,
integrating with the central M3tal APT repository & keyring.
"""

import os
import sys
import shutil
import subprocess
import argparse
from typing import Optional

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_APT_REPO = os.path.expanduser("~/apps/m3tal-apt-key")
def parse_pubspec_version():
    pubspec_path = os.path.join(ROOT_DIR, "pubspec.yaml")
    if os.path.exists(pubspec_path):
        with open(pubspec_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.startswith("version:"):
                    raw = line.split(":", 1)[1].strip()
                    return raw.split("+")[0]
    return "0.1.4"


def load_pubspec_metadata():
    """Read declarative package metadata from pubspec.yaml so Debian metadata,
    dependency constraints, and descriptions stay synchronized with the source
    of truth instead of being duplicated as text in the DEB builder.
    """
    pubspec_path = os.path.join(ROOT_DIR, "pubspec.yaml")
    metadata = {
        "name": "monster-lab",
        "description": "Hands-on offline STEM robotics learning studio for kids.",
        "long_description": [
            "Hands-on offline STEM robotics learning studio for kids.",
            "Features 12 guided lessons, 38 sensor components, 20 build projects,",
            "24 troubleshooting challenges, and physical serial hardware companion.",
        ],
        "maintainer": "Monster Lab Team <support@monsterlab.org>",
        "homepage": "https://jakej985-rgb.github.io/M3tal-Hub/Monster-Lab/",
        "depends": [
            "libc6 (>= 2.31)",
            "libgtk-3-0 (>= 3.24)",
            "libglib2.0-0",
            "libserialport0",
        ],
    }

    if not os.path.exists(pubspec_path):
        return metadata

    try:
        import yaml

        with open(pubspec_path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)

        if not isinstance(data, dict):
            return metadata

        name = data.get("name")
        if name and isinstance(name, str):
            proposed = name.replace(" ", "-").lower().strip()
            if proposed and proposed.replace("-", "").replace("+", "").isalnum():
                metadata["name"] = proposed
            else:
                print(
                    "Note: ignoring non-conformant name in pubspec.yaml "
                    f"({proposed!r}); using package fallback {metadata['name']!r}",
                    file=sys.stderr,
                )

        description = data.get("description")
        if description and isinstance(description, str):
            description = description.strip()
            if description:
                metadata["description"] = description
                metadata["long_description"] = [description]

        homepage = None
        if isinstance(data.get("homepage"), str) and data["homepage"].strip():
            homepage = data["homepage"].strip()
        else:
            repository = data.get("repository") or {}
            if isinstance(repository, dict):
                repo_url = repository.get("url")
                if isinstance(repo_url, str) and repo_url.strip():
                    homepage = repo_url.strip()
        if homepage:
            if homepage.startswith("git@") or homepage.startswith("ssh://"):
                print(
                    "Note: ignoring SSH-style repository URL in pubspec.yaml; "
                    "a public HTTPS homepage is preferred for Debian metadata.",
                    file=sys.stderr,
                )
            else:
                metadata["homepage"] = homepage

        if isinstance(data.get("author"), dict) and data["author"]:
            author_name = data["author"].get("name", "")
            author_email = data["author"].get("email", "")
            if author_name or author_email:
                if author_email:
                    metadata["maintainer"] = f"{author_name} <{author_email}>"
                else:
                    metadata["maintainer"] = author_name
    except Exception as exc:
        print(f"Note: could not parse pubspec.yaml metadata ({exc})", file=sys.stderr)

    return metadata


def deb_control_text(metadata, version, arch, installed_size_kb):
    depends_line = ", ".join(metadata["depends"])
    long_desc = "\n ".join(metadata["long_description"])
    return (
        f"Package: {metadata['name']}\n"
        f"Version: {version}\n"
        f"Section: education\n"
        f"Priority: optional\n"
        f"Architecture: {arch}\n"
        f"Installed-Size: {installed_size_kb}\n"
        f"Depends: {depends_line}\n"
        f"Maintainer: {metadata['maintainer']}\n"
        f"Homepage: {metadata['homepage']}\n"
        f"Description: {metadata['description']}\n"
        f" {long_desc}\n"
    )


def sign_deb_package(output_deb: str, key_id: Optional[str] = None, passphrase: Optional[str] = None) -> Optional[str]:
    """Generate detached GPG signature (.deb.asc) using canonical 50-year key."""
    gpg_bin = shutil.which("gpg")
    if not gpg_bin:
        print("Warning: gpg not found, skipping detached signature.", file=sys.stderr)
        return None

    asc_path = f"{output_deb}.asc"
    cmd = [gpg_bin, "--batch", "--yes"]
    if key_id:
        cmd.extend(["--default-key", key_id])
    if passphrase:
        cmd.extend(["--pinentry-mode", "loopback", "--passphrase", passphrase])
    cmd.extend(["--detach-sign", "--armor", "--output", asc_path, output_deb])

    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0:
        print(f"[SUCCESS] Detached GPG signature created with canonical key: {asc_path}")
        return asc_path
    else:
        print(f"Warning: Failed to sign deb package: {res.stderr}", file=sys.stderr)
        return None


def create_deb_package(bundle_dir: str, output_deb: str, push_to_apt_repo: str = None, sign: bool = False, key_id: Optional[str] = None, passphrase: Optional[str] = None, version: Optional[str] = None, arch: str = "amd64"):
    if not os.path.exists(bundle_dir):
        print(f"Error: Bundle directory not found: {bundle_dir}", file=sys.stderr)
        print("Please build the Linux release first: flutter build linux --release", file=sys.stderr)
        sys.exit(1)

    raw_version = version or parse_pubspec_version()
    clean_version = raw_version.lstrip("v").split("+")[0]
    target_arch = arch or "amd64"
    metadata = load_pubspec_metadata()
    package_name = metadata["name"]

    staging_dir = os.path.join(ROOT_DIR, "build", "deb_staging")
    if os.path.exists(staging_dir):
        shutil.rmtree(staging_dir)

    print(f"Staging Debian package '{package_name}' v{clean_version} ({target_arch})...")

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
    metainfo_dir = os.path.join(staging_dir, "usr", "share", "metainfo")
    mime_dir = os.path.join(staging_dir, "usr", "share", "mime", "packages")

    for d in [debian_dir, lib_dir, bin_dir, apps_dir, pixmaps_dir, icons_dir, usr_keyrings_dir, etc_keyrings_dir, apt_sources_dir, metainfo_dir, mime_dir]:
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
        f.write(f"Exec={package_name} %F\n")
        f.write(f"Icon={package_name}\n")
        f.write("Terminal=false\n")
        f.write("Type=Application\n")
        f.write("Categories=Education;Science;Electronics;Development;Engineering;\n")
        f.write("Keywords=arduino;electronics;robotics;stem;education;kids;\n")
        f.write("MimeType=application/x-monsterlab-project;\n")
        f.write("StartupWMClass=monster_lab\n")
    os.chmod(desktop_path, 0o644)

    # 4b. Create AppStream Metadata for Linux Mint Software Manager / GNOME Software
    appdata_path = os.path.join(metainfo_dir, f"org.monsterlab.MonsterLab.appdata.xml")
    with open(appdata_path, "w", encoding="utf-8") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<component type="desktop-application">\n')
        f.write('  <id>org.monsterlab.MonsterLab</id>\n')
        f.write('  <metadata_license>CC0-1.0</metadata_license>\n')
        f.write('  <project_license>MIT</project_license>\n')
        f.write('  <name>Monster Lab</name>\n')
        f.write('  <summary>Hands-on Arduino and electronics studio for kids</summary>\n')
        f.write('  <description>\n')
        f.write('    <p>Monster Lab is an interactive educational electronics and Arduino studio designed for young makers and students. It features guided breadboard building, simulated circuits, interactive challenges, and hardware companion bridges.</p>\n')
        f.write('  </description>\n')
        f.write('  <launchable type="desktop-id">monster-lab.desktop</launchable>\n')
        f.write('  <url type="homepage">https://jakej985-rgb.github.io/M3tal-Hub/Monster-Lab/</url>\n')
        f.write('  <provides>\n')
        f.write('    <mediatype>application/x-monsterlab-project</mediatype>\n')
        f.write('  </provides>\n')
        f.write('</component>\n')
    os.chmod(appdata_path, 0o644)

    # 4c. Create MIME Type Definition for .mlab project files
    mime_path = os.path.join(mime_dir, f"{package_name}.xml")
    with open(mime_path, "w", encoding="utf-8") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write('<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">\n')
        f.write('  <mime-type type="application/x-monsterlab-project">\n')
        f.write('    <comment>Monster Lab Circuit Project</comment>\n')
        f.write('    <glob pattern="*.mlab"/>\n')
        f.write('    <glob pattern="*.monsterlab"/>\n')
        f.write('  </mime-type>\n')
        f.write('</mime-info>\n')
    os.chmod(mime_path, 0o644)

    # Copy desktop icons
    icon_source = os.path.join(ROOT_DIR, "assets", "icons", "linux", f"{package_name}_256x256.png")
    if not os.path.exists(icon_source):
        icon_source = os.path.join(ROOT_DIR, "assets", "images", "app_icon.png")

    if os.path.exists(icon_source):
        shutil.copy2(icon_source, os.path.join(pixmaps_dir, f"{package_name}.png"))
        shutil.copy2(icon_source, os.path.join(icons_dir, f"{package_name}.png"))
        os.chmod(os.path.join(pixmaps_dir, f"{package_name}.png"), 0o644)
        os.chmod(os.path.join(icons_dir, f"{package_name}.png"), 0o644)

    # Prepare Linux GPG Keyring Asset

    keyring_source = os.path.join(ROOT_DIR, "linux", "keyring", "m3tal-archive-keyring.gpg")
    keyring_asc = os.path.join(ROOT_DIR, "linux", "keyring", "m3tal-archive-keyring.asc")
    if not os.path.exists(keyring_source):
        # Sync central keyring
        keyring_gen_script = os.path.join(ROOT_DIR, "scripts", "generate_deb_keyring.py")
        if os.path.exists(keyring_gen_script):
            subprocess.run([sys.executable, keyring_gen_script], check=True)

    if os.path.exists(keyring_source):
        usr_keyring_dest = os.path.join(usr_keyrings_dir, "m3tal-archive-keyring.gpg")
        etc_keyring_dest = os.path.join(etc_keyrings_dir, "m3tal-archive-keyring.gpg")
        shutil.copy2(keyring_source, usr_keyring_dest)
        shutil.copy2(keyring_source, etc_keyring_dest)
        os.chmod(usr_keyring_dest, 0o644)
        os.chmod(etc_keyring_dest, 0o644)

        # Also provide /etc/apt/sources.list.d/m3tal.list
        sources_list_path = os.path.join(apt_sources_dir, "m3tal.list")
        with open(sources_list_path, "w", encoding="utf-8") as f:
            f.write("# M3tal Official Debian APT Repository\n")
            f.write("# Verification Key: /etc/apt/keyrings/m3tal-archive-keyring.gpg\n")
            repo_base = metadata["homepage"].rstrip("/")
            f.write(f"deb [signed-by=/etc/apt/keyrings/m3tal-archive-keyring.gpg] {repo_base}/m3tal-apt-key stable main\n")
        os.chmod(sources_list_path, 0o644)

    # Calculate installed size in KB
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(staging_dir):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    installed_size_kb = (total_size + 1023) // 1024

    # 7. Create DEBIAN/control file
    control_path = os.path.join(debian_dir, "control")
    with open(control_path, "w", encoding="utf-8") as f:
        f.write(deb_control_text(metadata, clean_version, target_arch, installed_size_kb))
    os.chmod(control_path, 0o644)

    # 8. Build DEB package using dpkg-deb
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

    # 9. Optionally sign debian package with detached GPG signature
    if sign:
        sign_deb_package(output_deb, key_id=key_id, passphrase=passphrase)

    # 10. Optionally push to central apt repository
    if push_to_apt_repo:
        apt_ingest_script = os.path.join(push_to_apt_repo, "scripts", "ingest_deb.py")
        if os.path.exists(apt_ingest_script):
            print(f"\n--> Pushing package to central repository at {push_to_apt_repo}...")
            push_res = subprocess.run([sys.executable, apt_ingest_script, output_deb, "--repo-dir", push_to_apt_repo, "--allow-replace"])
            if push_res.returncode != 0:
                print(f"Warning: Failed to push to central repository.", file=sys.stderr)
            else:
                print(f"[SUCCESS] Successfully published to central repository!")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Package Monster Lab Linux build into a .deb archive.")
    parser.add_argument("--bundle-dir", default=os.path.join(ROOT_DIR, "build", "linux", "x64", "release", "bundle"),
                        help="Path to compiled Flutter Linux bundle directory")
    parser.add_argument("--output", default=os.path.join(ROOT_DIR, "monster-lab-linux.deb"),
                        help="Path to output .deb package")
    parser.add_argument("--version", default=None,
                        help="Explicit Debian package version (e.g. 0.3.0)")
    parser.add_argument("--arch", default="amd64",
                        help="Target architecture (default: amd64)")
    parser.add_argument("--push-to-apt-repo", nargs="?", const=DEFAULT_APT_REPO, default=None,
                        help="Path to central m3tal-apt-key repo to push package to (defaults to ~/apps/m3tal-apt-key if flag passed without value)")
    parser.add_argument("--sign", action="store_true",
                        help="Generate detached GPG signature (.asc) for the debian package")
    parser.add_argument("--key-id", default=os.environ.get("APT_GPG_KEY_ID") or os.environ.get("GPG_KEY_ID") or "5F84FE50A40111C981410E11775AD1473BF25102",
                        help="GPG key ID/fingerprint to sign with")

    default_pass = os.environ.get("APT_GPG_PASSPHRASE") or os.environ.get("GPG_PASSPHRASE")
    if not default_pass and os.path.exists(os.path.expanduser("~/.config/m3tal/apt_gpg_passphrase")):
        try:
            with open(os.path.expanduser("~/.config/m3tal/apt_gpg_passphrase")) as pf:
                default_pass = pf.read().strip()
        except Exception:
            pass
    parser.add_argument("--passphrase", default=default_pass, help="GPG key passphrase")

    args = parser.parse_args()

    create_deb_package(
        bundle_dir=args.bundle_dir,
        output_deb=args.output,
        push_to_apt_repo=args.push_to_apt_repo,
        sign=args.sign,
        key_id=args.key_id,
        passphrase=args.passphrase,
        version=args.version,
        arch=args.arch,
    )
