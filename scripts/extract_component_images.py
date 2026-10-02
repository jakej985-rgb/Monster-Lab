#!/usr/bin/env python3
"""
Monster Lab Component Image Extractor.
Extracts component hardware photos and diagrams from Monster.zip peripheral docx files,
resizes them to max 512px preserving aspect ratio, and exports optimized WebP images
into assets/images/components/.
"""

import io
import os
import re
import sys
import zipfile
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
ZIP_PATH = ROOT / "Monster.zip"
OUTPUT_DIR = ROOT / "assets" / "images" / "components"


def resize_and_save(img_bytes: bytes, output_path: Path, max_dim: int = 512) -> None:
    with Image.open(io.BytesIO(img_bytes)) as im:
        # Convert paletted or CMYK to RGBA or RGB
        if im.mode in ("RGBA", "LA") or (im.mode == "P" and "transparency" in im.info):
            im = im.convert("RGBA")
        else:
            im = im.convert("RGB")

        # Preserve aspect ratio
        w, h = im.size
        if max(w, h) > max_dim:
            if w >= h:
                new_w = max_dim
                new_h = int(round(h * (max_dim / w)))
            else:
                new_h = max_dim
                new_w = int(round(w * (max_dim / h)))
            im = im.resize((new_w, new_h), Image.Resampling.LANCZOS)

        output_path.parent.mkdir(parents=True, exist_ok=True)
        im.save(output_path, "WEBP", quality=85, method=6)


def main():
    if not ZIP_PATH.exists():
        print(f"Error: {ZIP_PATH} not found!")
        sys.exit(1)

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    print("Extracting peripheral hardware images from Monster.zip...")
    extracted_primary = 0
    extracted_details = 0

    with zipfile.ZipFile(ZIP_PATH, "r") as z:
        peri_files = [f for f in z.namelist() if "Tutorials/Peripheral " in f and f.endswith(".docx")]
        sorted_files = sorted(peri_files, key=lambda p: int(re.search(r"Peripheral (\d+)", p).group(1)))

        for f in sorted_files:
            match = re.search(r"Peripheral (\d+)", f)
            if not match:
                continue
            num = int(match.group(1))
            comp_id = f"comp_{num:02d}"

            docx_data = io.BytesIO(z.read(f))
            with zipfile.ZipFile(docx_data) as docx:
                # 1. Primary photo: image1.*
                img1_candidates = [
                    m for m in docx.namelist()
                    if re.match(r"^word/media/image1\.[a-zA-Z]+$", m, re.IGNORECASE)
                ]
                if img1_candidates:
                    img_bytes = docx.read(img1_candidates[0])
                    out_file = OUTPUT_DIR / f"{comp_id}.webp"
                    resize_and_save(img_bytes, out_file)
                    extracted_primary += 1
                else:
                    print(f"Warning: No primary image found for {comp_id} ({f})")

                # 2. Detail / schematic diagram: image2.* (if available)
                img2_candidates = [
                    m for m in docx.namelist()
                    if re.match(r"^word/media/image2\.[a-zA-Z]+$", m, re.IGNORECASE)
                ]
                if img2_candidates:
                    img_bytes = docx.read(img2_candidates[0])
                    out_file = OUTPUT_DIR / f"{comp_id}_detail.webp"
                    resize_and_save(img_bytes, out_file)
                    extracted_details += 1

    total_size = sum(p.stat().st_size for p in OUTPUT_DIR.glob("*.webp"))
    print(f"Extracted {extracted_primary} primary photos and {extracted_details} detail diagrams.")
    print(f"Total directory size: {total_size / 1024:.1f} KB in {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
