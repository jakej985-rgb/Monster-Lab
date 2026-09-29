#!/usr/bin/env python3
"""
Monster Lab - Release Asset Generator
Generates production-grade branding, app icons, splash screens, and web icons
using Pillow for Android, Web, and desktop distribution.
"""

import os
from PIL import Image, ImageDraw, ImageFont

ASSETS_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def draw_robot_icon(size: int, is_maskable: bool = False) -> Image.Image:
    """Renders a friendly Monster Lab robot mascot with circuit tracks."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Background color: vibrant Monster Lab violet (#6C5CE7)
    bg_color = (108, 92, 231, 255)

    if is_maskable:
        # Full bleed for adaptive/maskable icons
        draw.rectangle([(0, 0), (size, size)], fill=bg_color)
    else:
        # Rounded squircle for standalone icon
        corner_radius = int(size * 0.22)
        draw.rounded_rectangle([(0, 0), (size - 1, size - 1)], radius=corner_radius, fill=bg_color)

    # Scale factor relative to 1024
    s = size / 1024.0

    # Draw circuit traces in background (#00CEC9 cyan, #FFD93D amber)
    cyan = (0, 206, 201, 140)
    amber = (255, 217, 61, 140)
    line_w = max(2, int(10 * s))

    # Circuit line 1: top-left to center
    draw.line([(int(120 * s), int(160 * s)), (int(260 * s), int(160 * s)), (int(320 * s), int(220 * s))], fill=cyan, width=line_w)
    draw.ellipse([(int(105 * s), int(145 * s)), (int(135 * s), int(175 * s))], fill=cyan)
    draw.ellipse([(int(310 * s), int(210 * s)), (int(330 * s), int(230 * s))], fill=cyan)

    # Circuit line 2: top-right to center
    draw.line([(int(904 * s), int(180 * s)), (int(764 * s), int(180 * s)), (int(704 * s), int(240 * s))], fill=amber, width=line_w)
    draw.ellipse([(int(889 * s), int(165 * s)), (int(919 * s), int(195 * s))], fill=amber)

    # Circuit line 3: bottom-left
    draw.line([(int(140 * s), int(860 * s)), (int(280 * s), int(860 * s)), (int(340 * s), int(800 * s))], fill=amber, width=line_w)
    draw.ellipse([(int(125 * s), int(845 * s)), (int(155 * s), int(875 * s))], fill=amber)

    # Circuit line 4: bottom-right
    draw.line([(int(884 * s), int(840 * s)), (int(744 * s), int(840 * s)), (int(684 * s), int(780 * s))], fill=cyan, width=line_w)
    draw.ellipse([(int(869 * s), int(825 * s)), (int(899 * s), int(855 * s))], fill=cyan)

    # Antenna stem and bulb
    antenna_stem_color = (223, 230, 233, 255)
    antenna_tip_color = (255, 217, 61, 255) # glowing yellow LED tip
    stem_w = max(3, int(18 * s))
    draw.line([(int(512 * s), int(330 * s)), (int(512 * s), int(210 * s))], fill=antenna_stem_color, width=stem_w)

    # Antenna bulb glowing ring
    draw.ellipse([(int(467 * s), int(165 * s)), (int(557 * s), int(255 * s))], fill=(255, 217, 61, 90))
    draw.ellipse([(int(477 * s), int(175 * s)), (int(547 * s), int(245 * s))], fill=antenna_tip_color)

    # Side robot terminal ears/bolts
    ear_color = (162, 155, 254, 255) # pastel violet
    draw.rounded_rectangle([(int(200 * s), int(460 * s)), (int(260 * s), int(580 * s))], radius=int(14 * s), fill=ear_color)
    draw.rounded_rectangle([(int(764 * s), int(460 * s)), (int(824 * s), int(580 * s))], radius=int(14 * s), fill=ear_color)

    # Robot Head Chassis (Clean white curved rectangle)
    chassis_color = (255, 255, 255, 255)
    chassis_shadow = (220, 225, 240, 255)
    draw.rounded_rectangle([(int(240 * s), int(310 * s)), (int(784 * s), int(730 * s))], radius=int(90 * s), fill=chassis_shadow)
    draw.rounded_rectangle([(int(240 * s), int(300 * s)), (int(784 * s), int(715 * s))], radius=int(90 * s), fill=chassis_color)

    # Visor screen (Dark slate rounded visor)
    visor_color = (45, 52, 54, 255)
    draw.rounded_rectangle([(int(285 * s), int(370 * s)), (int(739 * s), int(640 * s))], radius=int(60 * s), fill=visor_color)

    # Robot Eyes (Dual glowing cyan LED matrices)
    eye_cyan = (0, 206, 201, 255)
    eye_glow = (0, 206, 201, 90)
    eye_radius = int(48 * s)
    eye_y = int(475 * s)
    left_x = int(395 * s)
    right_x = int(629 * s)

    # Eye glows
    draw.ellipse([(left_x - eye_radius - int(12 * s), eye_y - eye_radius - int(12 * s)),
                  (left_x + eye_radius + int(12 * s), eye_y + eye_radius + int(12 * s))], fill=eye_glow)
    draw.ellipse([(right_x - eye_radius - int(12 * s), eye_y - eye_radius - int(12 * s)),
                  (right_x + eye_radius + int(12 * s), eye_y + eye_radius + int(12 * s))], fill=eye_glow)

    # Main eyes
    draw.ellipse([(left_x - eye_radius, eye_y - eye_radius), (left_x + eye_radius, eye_y + eye_radius)], fill=eye_cyan)
    draw.ellipse([(right_x - eye_radius, eye_y - eye_radius), (right_x + eye_radius, eye_y + eye_radius)], fill=eye_cyan)

    # Eye specular highlights
    spec_r = int(14 * s)
    draw.ellipse([(left_x - int(24 * s), eye_y - int(24 * s)), (left_x - int(24 * s) + spec_r * 2, eye_y - int(24 * s) + spec_r * 2)], fill=(255, 255, 255, 240))
    draw.ellipse([(right_x - int(24 * s), eye_y - int(24 * s)), (right_x - int(24 * s) + spec_r * 2, eye_y - int(24 * s) + spec_r * 2)], fill=(255, 255, 255, 240))

    # Friendly smile (curved line)
    smile_color = (0, 206, 201, 230)
    mouth_w = max(3, int(14 * s))
    draw.arc([(int(450 * s), int(525 * s)), (int(574 * s), int(595 * s))], start=10, end=170, fill=smile_color, width=mouth_w)

    # Bottom Branding Ribbon "MONSTER LAB" if size >= 512
    if size >= 512:
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", int(56 * s))
        except Exception:
            font = ImageFont.load_default()
        text = "MONSTER LAB"
        bbox = draw.textbbox((0, 0), text, font=font)
        tw = bbox[2] - bbox[0]
        tx = int((size - tw) / 2)
        ty = int(820 * s)
        draw.text((tx, ty), text, font=font, fill=(255, 255, 255, 245))

    return img


def draw_splash_logo(width: int = 512, height: int = 512) -> Image.Image:
    """Renders a clean transparent logo for native splash screen."""
    return draw_robot_icon(min(width, height), is_maskable=False)


def main():
    print("Generating Monster Lab Production Release Assets...")
    os.makedirs(os.path.join(ASSETS_DIR, "assets", "images"), exist_ok=True)
    os.makedirs(os.path.join(ASSETS_DIR, "web", "icons"), exist_ok=True)

    # 1. Master Icon (1024x1024)
    master_icon_path = os.path.join(ASSETS_DIR, "assets", "images", "app_icon.png")
    master_icon = draw_robot_icon(1024)
    master_icon.save(master_icon_path, "PNG")
    print(f"  [OK] Master Icon: {master_icon_path}")

    # 2. Splash Logo (512x512)
    splash_path = os.path.join(ASSETS_DIR, "assets", "images", "splash_logo.png")
    splash_logo = draw_splash_logo(512, 512)
    splash_logo.save(splash_path, "PNG")
    print(f"  [OK] Splash Logo: {splash_path}")

    # 3. Android Mipmap Icons
    android_res = os.path.join(ASSETS_DIR, "android", "app", "src", "main", "res")
    android_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    for folder, dim in android_sizes.items():
        folder_path = os.path.join(android_res, folder)
        os.makedirs(folder_path, exist_ok=True)
        # Standard icon
        icon = draw_robot_icon(dim, is_maskable=False)
        icon.save(os.path.join(folder_path, "ic_launcher.png"), "PNG")
        print(f"  [OK] Android {folder} ({dim}x{dim}): ic_launcher.png")

    # 4. Web Icons & Favicons
    web_dir = os.path.join(ASSETS_DIR, "web")
    web_icons_dir = os.path.join(web_dir, "icons")

    # Favicon 32x32
    favicon = draw_robot_icon(32, is_maskable=False)
    favicon.save(os.path.join(web_dir, "favicon.png"), "PNG")
    print("  [OK] Web Favicon (32x32): favicon.png")

    # PWA Icons (192, 512) standard and maskable
    for pwa_dim in [192, 512]:
        pwa_icon = draw_robot_icon(pwa_dim, is_maskable=False)
        pwa_icon.save(os.path.join(web_icons_dir, f"Icon-{pwa_dim}.png"), "PNG")

        maskable_icon = draw_robot_icon(pwa_dim, is_maskable=True)
        maskable_icon.save(os.path.join(web_icons_dir, f"Icon-maskable-{pwa_dim}.png"), "PNG")
        print(f"  [OK] Web PWA ({pwa_dim}x{pwa_dim}): Icon-{pwa_dim}.png & Icon-maskable-{pwa_dim}.png")

    # 5. Windows Desktop ICO
    windows_ico_path = os.path.join(ASSETS_DIR, "windows", "runner", "resources", "app_icon.ico")
    if os.path.exists(os.path.dirname(windows_ico_path)):
        master_icon.save(windows_ico_path, format="ICO", sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
        print(f"  [OK] Windows Application Icon: {windows_ico_path}")

    # 6. Linux Desktop Icons
    linux_icons_dir = os.path.join(ASSETS_DIR, "assets", "icons", "linux")
    os.makedirs(linux_icons_dir, exist_ok=True)
    for l_dim in [64, 128, 256, 512]:
        l_icon = draw_robot_icon(l_dim, is_maskable=False)
        l_icon_path = os.path.join(linux_icons_dir, f"monster_lab_{l_dim}x{l_dim}.png")
        l_icon.save(l_icon_path, "PNG")
        print(f"  [OK] Linux Desktop Icon ({l_dim}x{l_dim}): {l_icon_path}")

    print("\nAll Release Branding Assets Successfully Generated for Android, Linux, Windows, and Web!")

if __name__ == "__main__":
    main()
