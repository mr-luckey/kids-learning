#!/usr/bin/env python3
"""Procedural cute clay / soft-plastic 3D-style PNG icons (no network)."""

from __future__ import annotations

import math
import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
UI = ROOT / "assets" / "ui"
IMAGES = ROOT / "assets" / "images"
SIZE = 768


def soft_circle(
    draw: ImageDraw.ImageDraw,
    cx: float,
    cy: float,
    r: float,
    color: tuple[int, int, int, int],
) -> None:
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=color)


def radial_blob(
    size: int,
    color: tuple[int, int, int],
    highlight: tuple[int, int, int] | None = None,
    shadow: tuple[int, int, int] | None = None,
) -> Image.Image:
    """Soft shaded sphere (clay ball)."""
    im = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = im.load()
    cx = cy = size / 2
    r = size / 2 - 2
    hx, hy = cx - r * 0.28, cy - r * 0.32
    highlight = highlight or tuple(min(255, c + 55) for c in color)
    shadow = shadow or tuple(max(0, c - 55) for c in color)
    for y in range(size):
        for x in range(size):
            dx, dy = x - cx, y - cy
            d = math.sqrt(dx * dx + dy * dy)
            if d > r:
                continue
            # Base radial shading
            t = d / r
            shade = 1.0 - t * 0.35
            # Specular highlight
            dhx, dhy = x - hx, y - hy
            hd = math.sqrt(dhx * dhx + dhy * dhy) / (r * 0.85)
            spec = max(0.0, 1.0 - hd) ** 2.4
            # Bottom ambient occlusion
            ao = 1.0 - max(0.0, (y - cy) / r) * 0.22
            mix = shade * ao
            rr = int(color[0] * mix * (1 - spec) + highlight[0] * spec)
            gg = int(color[1] * mix * (1 - spec) + highlight[1] * spec)
            bb = int(color[2] * mix * (1 - spec) + highlight[2] * spec)
            # Soft edge alpha
            edge = 1.0 if d < r - 1.5 else max(0.0, (r - d) / 1.5)
            # Pull toward shadow on far side
            far = max(0.0, ((x - cx) * 0.4 + (y - cy) * 0.8) / r)
            rr = int(rr * (1 - far * 0.25) + shadow[0] * far * 0.25)
            gg = int(gg * (1 - far * 0.25) + shadow[1] * far * 0.25)
            bb = int(bb * (1 - far * 0.25) + shadow[2] * far * 0.25)
            px[x, y] = (rr, gg, bb, int(255 * edge))
    return im


def drop_shadow(base: Image.Image, blur: int = 18, opacity: int = 90, dy: int = 18) -> Image.Image:
    alpha = base.split()[-1]
    shadow = Image.new("RGBA", base.size, (0, 0, 0, 0))
    sh = Image.new("RGBA", base.size, (0, 0, 0, opacity))
    shadow.paste(sh, (0, dy), alpha)
    shadow = shadow.filter(ImageFilter.GaussianBlur(blur))
    out = Image.new("RGBA", base.size, (0, 0, 0, 0))
    out.alpha_composite(shadow)
    out.alpha_composite(base)
    return out


def face(draw: ImageDraw.ImageDraw, cx: float, cy: float, scale: float = 1.0) -> None:
    eye_r = 10 * scale
    soft_circle(draw, cx - 22 * scale, cy - 6 * scale, eye_r, (40, 55, 80, 255))
    soft_circle(draw, cx + 22 * scale, cy - 6 * scale, eye_r, (40, 55, 80, 255))
    soft_circle(draw, cx - 19 * scale, cy - 9 * scale, 3.5 * scale, (255, 255, 255, 230))
    soft_circle(draw, cx + 25 * scale, cy - 9 * scale, 3.5 * scale, (255, 255, 255, 230))
    # blush
    soft_circle(draw, cx - 38 * scale, cy + 10 * scale, 9 * scale, (255, 140, 160, 110))
    soft_circle(draw, cx + 38 * scale, cy + 10 * scale, 9 * scale, (255, 140, 160, 110))
    # smile
    box = (cx - 18 * scale, cy + 4 * scale, cx + 18 * scale, cy + 28 * scale)
    draw.arc(box, 20, 160, fill=(40, 55, 80, 255), width=max(2, int(4 * scale)))


def rounded_rect_3d(
    size: int,
    color: tuple[int, int, int],
    radius: int = 90,
) -> Image.Image:
    im = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    body = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(body)
    margin = max(8, size // 11)
    rad = min(radius, (size - 2 * margin) // 2)
    d.rounded_rectangle(
        (margin, margin, size - margin, size - margin),
        radius=rad,
        fill=color + (255,),
    )
    # top highlight band
    hi = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    hd = ImageDraw.Draw(hi)
    mid = size // 2
    hd.rounded_rectangle(
        (margin + 4, margin + 4, size - margin - 4, mid + size // 20),
        radius=max(4, rad - 6),
        fill=(255, 255, 255, 70),
    )
    body.alpha_composite(hi)
    # bottom shade
    sh = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    sd = ImageDraw.Draw(sh)
    top = mid + size // 10
    bot = size - margin - 4
    if bot > top + 4:
        sd.rounded_rectangle(
            (margin + 6, top, size - margin - 6, bot),
            radius=max(4, rad - 10),
            fill=(0, 0, 0, 45),
        )
    body.alpha_composite(sh)
    return drop_shadow(body, blur=max(6, size // 20), opacity=80, dy=max(6, size // 20))



def letter_icon(ch: str, color: tuple[int, int, int]) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    # clay pillow base
    ball = radial_blob(520, color)
    canvas.alpha_composite(ball, ((SIZE - 520) // 2, (SIZE - 520) // 2 + 10))
    draw = ImageDraw.Draw(canvas)
    # try bold font
    font = None
    for path in (
        "/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf",
        "/System/Library/Fonts/Supplemental/Arial Rounded MT Bold.ttf",
        "/Library/Fonts/Arial Rounded Bold.ttf",
        str(ROOT / "assets/fonts/arlrdbd.ttf"),
        "/System/Library/Fonts/Supplemental/Impact.ttf",
    ):
        try:
            font = ImageFont.truetype(path, 340)
            break
        except OSError:
            continue
    if font is None:
        font = ImageFont.load_default()
    # letter shadow then fill
    text = ch.upper()
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (SIZE - tw) / 2 - bbox[0]
    y = (SIZE - th) / 2 - bbox[1] - 20
    draw.text((x + 6, y + 8), text, font=font, fill=(0, 0, 0, 70))
    draw.text((x, y), text, font=font, fill=(255, 255, 255, 245))
    face(draw, SIZE / 2, SIZE / 2 + 70, scale=1.15)
    return drop_shadow(canvas, blur=22, opacity=100, dy=22)


def sun_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    cx = cy = SIZE / 2
    # rays
    for i in range(12):
        ang = i * (math.pi * 2 / 12)
        x2 = cx + math.cos(ang) * 310
        y2 = cy + math.sin(ang) * 310
        # thick ray as ellipse along angle
        ray = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
        rd = ImageDraw.Draw(ray)
        rd.ellipse((cx - 28, cy - 300, cx + 28, cy - 170), fill=(255, 200, 70, 255))
        ray = ray.rotate(-math.degrees(ang), center=(cx, cy), resample=Image.Resampling.BICUBIC)
        canvas.alpha_composite(ray)
    core = radial_blob(420, (255, 180, 40), highlight=(255, 240, 160), shadow=(230, 120, 20))
    canvas.alpha_composite(core, ((SIZE - 420) // 2, (SIZE - 420) // 2))
    face(ImageDraw.Draw(canvas), cx, cy + 10, scale=1.5)
    return drop_shadow(canvas)


def star_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(canvas)
    cx = cy = SIZE / 2
    pts = []
    for i in range(10):
        ang = -math.pi / 2 + i * math.pi / 5
        r = 300 if i % 2 == 0 else 130
        pts.append((cx + math.cos(ang) * r, cy + math.sin(ang) * r))
    # soft layers
    for grow, col, a in ((18, (255, 170, 40), 60), (0, (255, 210, 60), 255)):
        p2 = []
        for x, y in pts:
            dx, dy = x - cx, y - cy
            p2.append((cx + dx * (1 + grow / 300), cy + dy * (1 + grow / 300)))
        draw.polygon(p2, fill=col + (a,))
    # gloss
    soft_circle(draw, cx - 40, cy - 70, 55, (255, 255, 255, 90))
    face(draw, cx, cy + 20, scale=1.3)
    return drop_shadow(canvas)


def book_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(canvas)
    # Soft glow pad under book
    canvas.alpha_composite(
        radial_blob(
            520,
            (200, 230, 255),
            highlight=(240, 250, 255),
            shadow=(120, 170, 230),
        ),
        (124, 180),
    )
    # Open book pages
    d.polygon([(150, 280), (384, 240), (384, 560), (170, 580)], fill=(255, 255, 255, 250))
    d.polygon([(618, 280), (384, 240), (384, 560), (598, 580)], fill=(235, 245, 255, 250))
    # Cover edges
    d.line((384, 240, 384, 560), fill=(70, 130, 210, 255), width=10)
    d.line((150, 280, 170, 580), fill=(90, 160, 240, 255), width=8)
    d.line((618, 280, 598, 580), fill=(90, 160, 240, 255), width=8)
    # ABC clay blocks on top
    for ch, col, pos in (
        ("A", (255, 110, 110), (170, 90)),
        ("B", (110, 210, 120), (310, 50)),
        ("C", (255, 200, 70), (450, 95)),
    ):
        canvas.alpha_composite(radial_blob(200, col), pos)
        td = ImageDraw.Draw(canvas)
        try:
            font = ImageFont.truetype(
                "/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf", 90
            )
        except OSError:
            font = ImageFont.load_default()
        td.text((pos[0] + 60, pos[1] + 45), ch, font=font, fill=(255, 255, 255, 255))
    # tiny star
    canvas.alpha_composite(radial_blob(90, (255, 220, 70)), (560, 200))
    return drop_shadow(canvas)



def quiz_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    mark = radial_blob(480, (255, 210, 60))
    canvas.alpha_composite(mark, ((SIZE - 480) // 2, (SIZE - 480) // 2 - 20))
    d = ImageDraw.Draw(canvas)
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf", 280)
    except OSError:
        font = ImageFont.load_default()
    d.text((SIZE / 2 - 70, SIZE / 2 - 200), "?", font=font, fill=(255, 255, 255, 250))
    face(d, SIZE / 2, SIZE / 2 + 90, scale=1.2)
    # puzzle pieces
    for col, pos in (
        ((255, 120, 170), (80, 520)),
        ((110, 200, 255), (540, 520)),
        ((140, 230, 120), (310, 560)),
    ):
        p = radial_blob(160, col)
        canvas.alpha_composite(p, pos)
    return drop_shadow(canvas)


def look_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    # magnifier glass
    glass = radial_blob(360, (180, 230, 255), highlight=(240, 250, 255), shadow=(80, 140, 200))
    canvas.alpha_composite(glass, (120, 100))
    d = ImageDraw.Draw(canvas)
    d.ellipse((140, 120, 460, 440), outline=(90, 120, 200, 255), width=28)
    # handle
    d.rounded_rectangle((400, 420, 560, 500), radius=30, fill=(255, 170, 70, 255))
    # choice toys
    for col, pos in (((255, 90, 90), (90, 480)), ((90, 170, 255), (300, 520)), ((255, 210, 60), (510, 480))):
        canvas.alpha_composite(radial_blob(140, col), pos)
    return drop_shadow(canvas)


def listen_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    # lion face
    mane = radial_blob(560, (255, 150, 50), highlight=(255, 200, 100), shadow=(210, 90, 20))
    canvas.alpha_composite(mane, ((SIZE - 560) // 2, (SIZE - 560) // 2))
    face_ball = radial_blob(340, (255, 220, 140))
    canvas.alpha_composite(face_ball, ((SIZE - 340) // 2, (SIZE - 340) // 2 + 20))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, SIZE / 2 + 20, scale=1.4)
    # headphones
    d.arc((140, 160, 628, 520), 200, 340, fill=(160, 110, 255, 255), width=36)
    d.rounded_rectangle((120, 300, 200, 430), radius=30, fill=(160, 110, 255, 255))
    d.rounded_rectangle((568, 300, 648, 430), radius=30, fill=(160, 110, 255, 255))
    # notes
    soft_circle(d, 560, 160, 18, (200, 140, 255, 255))
    soft_circle(d, 610, 200, 14, (200, 140, 255, 255))
    return drop_shadow(canvas)


def mascot_icon() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    body = radial_blob(420, (150, 200, 255), highlight=(220, 240, 255), shadow=(80, 130, 200))
    canvas.alpha_composite(body, ((SIZE - 420) // 2, 180))
    head = radial_blob(340, (170, 210, 255))
    canvas.alpha_composite(head, ((SIZE - 340) // 2, 90))
    # ears
    for ox in (-150, 150):
        ear = radial_blob(160, (140, 190, 245))
        canvas.alpha_composite(ear, (SIZE // 2 + ox - 80, 70))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, 250, scale=1.35)
    # trunk
    d.rounded_rectangle((SIZE / 2 - 28, 300, SIZE / 2 + 28, 480), radius=24, fill=(130, 180, 240, 255))
    return drop_shadow(canvas)


def category_cluster(colors: list[tuple[int, int, int]], labels: list[str] | None = None) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    positions = [(120, 160), (300, 100), (470, 180), (220, 360), (420, 380)]
    for i, col in enumerate(colors[:5]):
        blob = radial_blob(260, col)
        canvas.alpha_composite(blob, positions[i])
    if labels:
        d = ImageDraw.Draw(canvas)
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf", 90)
        except OSError:
            font = ImageFont.load_default()
        for i, lab in enumerate(labels[:3]):
            x, y = positions[i]
            d.text((x + 80, y + 70), lab, font=font, fill=(255, 255, 255, 250))
    return drop_shadow(canvas)


LETTER_PALETTE = [
    (255, 120, 140), (90, 170, 255), (110, 210, 130), (255, 200, 70), (180, 130, 255),
    (255, 150, 80), (80, 210, 200), (255, 120, 190), (150, 220, 90), (255, 100, 100),
    (120, 150, 255), (255, 170, 110), (190, 120, 255), (70, 200, 180), (255, 210, 90),
    (255, 130, 170), (90, 200, 140), (100, 140, 255), (255, 90, 180), (70, 210, 230),
    (255, 180, 70), (140, 110, 255), (120, 220, 120), (255, 110, 160), (80, 160, 230),
    (255, 90, 110),
]


def save(im: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    im = im.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    im.save(path, format="PNG", optimize=True)
    print(f"wrote {path.relative_to(ROOT)} ({path.stat().st_size} bytes)")


def main() -> None:
    random.seed(7)
    save(book_icon(), UI / "home_start_3d.png")
    save(quiz_icon(), UI / "home_fun_quiz_3d.png")
    save(look_icon(), UI / "home_look_3d.png")
    save(listen_icon(), UI / "home_listen_3d.png")
    save(star_icon(), UI / "rate_star_3d.png")
    save(sun_icon(), UI / "sun_3d.png")
    save(sun_icon(), IMAGES / "sun.png")
    save(mascot_icon(), UI / "home_mascot_3d.png")

    save(category_cluster([(90, 170, 255), (110, 210, 130), (255, 110, 110)], ["A", "B", "C"]), UI / "cat_Alphabet.png")
    save(category_cluster([(255, 120, 170), (255, 200, 70), (110, 200, 255)], ["1", "2", "3"]), UI / "cat_Numbers.png")
    save(category_cluster([(255, 90, 90), (90, 200, 120), (90, 150, 255), (255, 210, 70), (200, 100, 255)]), UI / "cat_Color.png")
    save(category_cluster([(255, 210, 70), (110, 200, 255), (255, 120, 170)]), UI / "cat_Shapes.png")
    save(category_cluster([(255, 170, 60), (255, 200, 120), (230, 140, 40)]), UI / "cat_Animals.png")
    save(category_cluster([(80, 200, 160), (255, 120, 100), (110, 180, 255)]), UI / "cat_Birds.png")
    save(category_cluster([(255, 140, 180), (255, 210, 70), (255, 170, 200)]), UI / "cat_Flowers.png")
    save(category_cluster([(255, 90, 90), (255, 220, 70), (255, 120, 150)]), UI / "cat_Fruit.png")
    save(category_cluster([(110, 180, 255), (255, 200, 70), (140, 220, 140)]), UI / "cat_Month.png")
    save(category_cluster([(255, 140, 60), (90, 200, 100), (255, 90, 80)]), UI / "cat_Vegitable.png")

    for i, ch in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ"):
        save(letter_icon(ch, LETTER_PALETTE[i]), UI / f"letter_{ch}.png")
        # Also replace learning alphabet cards
        save(letter_icon(ch, LETTER_PALETTE[i]), IMAGES / f"2{ch}.png")

    # Numbers 0-9
    for n in range(10):
        save(letter_icon(str(n), LETTER_PALETTE[n]), IMAGES / f"8{n}.png")

    print("procedural UI + letters + numbers done")


if __name__ == "__main__":
    main()
