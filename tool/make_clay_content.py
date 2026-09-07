#!/usr/bin/env python3
"""Clay toy content images: animals, birds, fruits, veggies, shapes, colors, months."""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "assets" / "images"
SIZE = 768


def radial_blob(
    size: int,
    color: tuple[int, int, int],
    highlight: tuple[int, int, int] | None = None,
    shadow: tuple[int, int, int] | None = None,
) -> Image.Image:
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
            t = d / r
            shade = 1.0 - t * 0.35
            dhx, dhy = x - hx, y - hy
            hd = math.sqrt(dhx * dhx + dhy * dhy) / (r * 0.85)
            spec = max(0.0, 1.0 - hd) ** 2.4
            ao = 1.0 - max(0.0, (y - cy) / r) * 0.22
            mix = shade * ao
            rr = int(color[0] * mix * (1 - spec) + highlight[0] * spec)
            gg = int(color[1] * mix * (1 - spec) + highlight[1] * spec)
            bb = int(color[2] * mix * (1 - spec) + highlight[2] * spec)
            edge = 1.0 if d < r - 1.5 else max(0.0, (r - d) / 1.5)
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


def soft_circle(draw: ImageDraw.ImageDraw, cx: float, cy: float, r: float, color) -> None:
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), fill=color)


def face(draw: ImageDraw.ImageDraw, cx: float, cy: float, scale: float = 1.0) -> None:
    soft_circle(draw, cx - 22 * scale, cy - 6 * scale, 10 * scale, (40, 55, 80, 255))
    soft_circle(draw, cx + 22 * scale, cy - 6 * scale, 10 * scale, (40, 55, 80, 255))
    soft_circle(draw, cx - 19 * scale, cy - 9 * scale, 3.5 * scale, (255, 255, 255, 230))
    soft_circle(draw, cx + 25 * scale, cy - 9 * scale, 3.5 * scale, (255, 255, 255, 230))
    soft_circle(draw, cx - 38 * scale, cy + 10 * scale, 9 * scale, (255, 140, 160, 110))
    soft_circle(draw, cx + 38 * scale, cy + 10 * scale, 9 * scale, (255, 140, 160, 110))
    box = (cx - 18 * scale, cy + 4 * scale, cx + 18 * scale, cy + 28 * scale)
    draw.arc(box, 20, 160, fill=(40, 55, 80, 255), width=max(2, int(4 * scale)))


def paste(canvas: Image.Image, blob: Image.Image, xy: tuple[int, int]) -> None:
    canvas.alpha_composite(blob, xy)


def animal_base(body: tuple[int, int, int], accent: tuple[int, int, int] | None = None) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    paste(canvas, radial_blob(420, body), ((SIZE - 420) // 2, 200))
    paste(canvas, radial_blob(340, body), ((SIZE - 340) // 2, 110))
    # ears
    ear = accent or body
    paste(canvas, radial_blob(150, ear), (170, 90))
    paste(canvas, radial_blob(150, ear), (448, 90))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, 250, 1.35)
    return drop_shadow(canvas)


def make_cat() -> Image.Image:
    im = animal_base((255, 180, 90), (255, 150, 70))
    d = ImageDraw.Draw(im)
    # pointed ear tips already round; whiskers
    for y in (280, 300, 320):
        d.line((220, y, 160, y - 8), fill=(80, 60, 40, 180), width=3)
        d.line((548, y, 608, y - 8), fill=(80, 60, 40, 180), width=3)
    return im


def make_dog() -> Image.Image:
    im = animal_base((210, 160, 100), (180, 120, 70))
    d = ImageDraw.Draw(im)
    # floppy ears overlay darker
    paste(im, radial_blob(180, (160, 100, 60)), (140, 160))
    paste(im, radial_blob(180, (160, 100, 60)), (450, 160))
    # nose
    soft_circle(d, SIZE / 2, 290, 16, (60, 40, 30, 255))
    return im


def make_lion() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    paste(canvas, radial_blob(560, (255, 150, 50)), ((SIZE - 560) // 2, 90))
    paste(canvas, radial_blob(340, (255, 220, 140)), ((SIZE - 340) // 2, 200))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, 340, 1.4)
    return drop_shadow(canvas)


def make_elephant() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    paste(canvas, radial_blob(420, (150, 200, 255)), ((SIZE - 420) // 2, 200))
    paste(canvas, radial_blob(340, (170, 210, 255)), ((SIZE - 340) // 2, 110))
    paste(canvas, radial_blob(150, (140, 190, 245)), (170, 70))
    paste(canvas, radial_blob(150, (140, 190, 245)), (448, 70))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, 250, 1.3)
    d.rounded_rectangle((SIZE / 2 - 28, 300, SIZE / 2 + 28, 500), radius=24, fill=(130, 180, 240, 255))
    return drop_shadow(canvas)


def make_bear() -> Image.Image:
    return animal_base((160, 110, 70), (130, 85, 50))


def make_fox() -> Image.Image:
    im = animal_base((255, 130, 60), (240, 100, 40))
    # white chest
    paste(im, radial_blob(180, (255, 245, 230)), ((SIZE - 180) // 2, 340))
    return im


def make_horse() -> Image.Image:
    im = animal_base((180, 130, 90), (140, 95, 60))
    d = ImageDraw.Draw(im)
    # snout
    paste(im, radial_blob(160, (210, 170, 130)), ((SIZE - 160) // 2, 320))
    soft_circle(d, SIZE / 2 - 18, 380, 8, (40, 30, 25, 255))
    soft_circle(d, SIZE / 2 + 18, 380, 8, (40, 30, 25, 255))
    return im


def make_zebra() -> Image.Image:
    im = animal_base((245, 245, 245), (40, 40, 40))
    d = ImageDraw.Draw(im)
    for i in range(5):
        x = 250 + i * 50
        d.rectangle((x, 180, x + 18, 420), fill=(40, 40, 40, 160))
    return im


def make_camel() -> Image.Image:
    im = animal_base((210, 170, 110), (190, 140, 90))
    paste(im, radial_blob(200, (200, 150, 90)), ((SIZE - 200) // 2, 80))
    return im


def make_deer() -> Image.Image:
    im = animal_base((210, 160, 100), (180, 120, 70))
    d = ImageDraw.Draw(im)
    # antlers
    d.line((280, 120, 240, 40), fill=(120, 80, 40, 255), width=10)
    d.line((240, 40, 210, 70), fill=(120, 80, 40, 255), width=8)
    d.line((488, 120, 528, 40), fill=(120, 80, 40, 255), width=10)
    d.line((528, 40, 558, 70), fill=(120, 80, 40, 255), width=8)
    return im


def make_bull() -> Image.Image:
    im = animal_base((120, 90, 70), (90, 60, 45))
    d = ImageDraw.Draw(im)
    d.line((240, 140, 180, 90), fill=(230, 230, 230, 255), width=12)
    d.line((528, 140, 588, 90), fill=(230, 230, 230, 255), width=12)
    return im


def make_gorilla() -> Image.Image:
    return animal_base((80, 80, 90), (60, 60, 70))


def make_panther() -> Image.Image:
    return animal_base((45, 45, 55), (30, 30, 40))


def make_rhino() -> Image.Image:
    im = animal_base((160, 165, 170), (130, 135, 140))
    d = ImageDraw.Draw(im)
    # horn
    d.polygon([(SIZE / 2, 160), (SIZE / 2 - 25, 260), (SIZE / 2 + 25, 260)], fill=(220, 220, 220, 255))
    return im


def make_bird(body: tuple[int, int, int], beak: tuple[int, int, int] = (255, 180, 60)) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    paste(canvas, radial_blob(380, body), ((SIZE - 380) // 2, 180))
    paste(canvas, radial_blob(260, body), ((SIZE - 260) // 2, 120))
    # wing
    paste(canvas, radial_blob(200, tuple(max(0, c - 30) for c in body)), (420, 260))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, 230, 1.1)
    d.polygon([(SIZE / 2 + 40, 260), (SIZE / 2 + 110, 275), (SIZE / 2 + 40, 290)], fill=beak + (255,))
    return drop_shadow(canvas)


def make_fruit(color: tuple[int, int, int], leaf: bool = True) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    paste(canvas, radial_blob(460, color), ((SIZE - 460) // 2, 160))
    d = ImageDraw.Draw(canvas)
    if leaf:
        paste(canvas, radial_blob(120, (90, 190, 80)), (400, 120))
        d.rectangle((SIZE / 2 - 8, 120, SIZE / 2 + 8, 180), fill=(90, 140, 60, 255))
    face(d, SIZE / 2, 380, 1.2)
    return drop_shadow(canvas)


def make_banana() -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(canvas)
    d.pieslice((180, 160, 580, 560), 200, 340, fill=(255, 220, 70, 255))
    d.pieslice((210, 190, 550, 530), 200, 340, fill=(255, 235, 120, 255))
    face(d, SIZE / 2, 360, 1.1)
    return drop_shadow(canvas)


def make_veg(color: tuple[int, int, int]) -> Image.Image:
    return make_fruit(color, leaf=True)


def make_flower(petal: tuple[int, int, int], center: tuple[int, int, int] = (255, 220, 70)) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    cx = cy = SIZE / 2
    for i in range(8):
        ang = i * math.pi / 4
        x = int(cx + math.cos(ang) * 150 - 110)
        y = int(cy + math.sin(ang) * 150 - 110)
        paste(canvas, radial_blob(220, petal), (x, y))
    paste(canvas, radial_blob(220, center), ((SIZE - 220) // 2, (SIZE - 220) // 2))
    d = ImageDraw.Draw(canvas)
    face(d, cx, cy, 1.0)
    return drop_shadow(canvas)


def make_shape(kind: str, color: tuple[int, int, int]) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(canvas)
    c = color + (255,)
    if kind == "circle":
        paste(canvas, radial_blob(480, color), ((SIZE - 480) // 2, (SIZE - 480) // 2))
    elif kind == "square":
        d.rounded_rectangle((160, 160, 608, 608), radius=50, fill=c)
    elif kind == "triangle":
        d.polygon([(384, 140), (600, 600), (168, 600)], fill=c)
    elif kind == "star":
        pts = []
        for i in range(10):
            ang = -math.pi / 2 + i * math.pi / 5
            r = 280 if i % 2 == 0 else 120
            pts.append((384 + math.cos(ang) * r, 384 + math.sin(ang) * r))
        d.polygon(pts, fill=c)
    elif kind == "heart" or kind == "crescent":
        paste(canvas, radial_blob(300, color), (160, 200))
        paste(canvas, radial_blob(300, color), (308, 200))
        d.polygon([(200, 360), (384, 600), (568, 360)], fill=c)
    elif kind == "hexagon":
        pts = [(384 + math.cos(i * math.pi / 3) * 260, 384 + math.sin(i * math.pi / 3) * 260) for i in range(6)]
        d.polygon(pts, fill=c)
    elif kind == "pentagon":
        pts = [(384 + math.cos(-math.pi / 2 + i * 2 * math.pi / 5) * 260, 384 + math.sin(-math.pi / 2 + i * 2 * math.pi / 5) * 260) for i in range(5)]
        d.polygon(pts, fill=c)
    elif kind == "oval":
        d.ellipse((180, 220, 588, 548), fill=c)
    elif kind == "cube":
        d.polygon([(220, 280), (420, 200), (620, 280), (420, 360)], fill=tuple(min(255, x + 40) for x in color) + (255,))
        d.polygon([(220, 280), (220, 500), (420, 580), (420, 360)], fill=c)
        d.polygon([(420, 360), (420, 580), (620, 500), (620, 280)], fill=tuple(max(0, x - 40) for x in color) + (255,))
    elif kind == "cylinder":
        d.ellipse((220, 160, 548, 280), fill=tuple(min(255, x + 30) for x in color) + (255,))
        d.rectangle((220, 220, 548, 520), fill=c)
        d.ellipse((220, 460, 548, 580), fill=tuple(max(0, x - 30) for x in color) + (255,))
    elif kind == "arrow":
        d.polygon([(384, 140), (560, 340), (460, 340), (460, 600), (308, 600), (308, 340), (208, 340)], fill=c)
    elif kind == "cross":
        d.rounded_rectangle((300, 160, 468, 608), radius=40, fill=c)
        d.rounded_rectangle((160, 300, 608, 468), radius=40, fill=c)
    elif kind == "rhombus":
        d.polygon([(384, 140), (600, 384), (384, 628), (168, 384)], fill=c)
    elif kind == "parallelogram":
        d.polygon([(220, 220), (600, 220), (520, 560), (140, 560)], fill=c)
    else:
        paste(canvas, radial_blob(480, color), ((SIZE - 480) // 2, (SIZE - 480) // 2))
    face(ImageDraw.Draw(canvas), SIZE / 2, SIZE / 2 + 40, 1.15)
    return drop_shadow(canvas)


def make_color_blob(color: tuple[int, int, int]) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    paste(canvas, radial_blob(520, color), ((SIZE - 520) // 2, (SIZE - 520) // 2))
    # drip
    paste(canvas, radial_blob(160, color), (300, 560))
    d = ImageDraw.Draw(canvas)
    face(d, SIZE / 2, SIZE / 2, 1.4)
    return drop_shadow(canvas)


def make_month(label: str, color: tuple[int, int, int]) -> Image.Image:
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(canvas)
    d.rounded_rectangle((140, 160, 628, 600), radius=40, fill=(255, 255, 255, 255))
    d.rounded_rectangle((140, 160, 628, 280), radius=40, fill=color + (255,))
    # fix bottom of header
    d.rectangle((140, 230, 628, 280), fill=color + (255,))
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf", 70)
        big = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Rounded Bold.ttf", 160)
    except OSError:
        font = ImageFont.load_default()
        big = font
    d.text((SIZE / 2 - 60, 185), label[:3].upper(), font=font, fill=(255, 255, 255, 255))
    # cute sun/weather
    paste(canvas, radial_blob(180, (255, 210, 70)), ((SIZE - 180) // 2, 340))
    face(ImageDraw.Draw(canvas), SIZE / 2, 430, 0.9)
    return drop_shadow(canvas)


def save(im: Image.Image, name: str) -> None:
    path = IMAGES / name
    im = im.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    im.save(path, format="PNG", optimize=True)
    print(f"wrote assets/images/{name}")


def main() -> None:
    # Animals
    save(make_bear(), "1beer.png")
    save(make_bull(), "1bull.png")
    save(make_camel(), "1camel.png")
    save(make_cat(), "1cat.png")
    save(make_deer(), "1dear.png")
    save(make_dog(), "1dog.png")
    save(make_elephant(), "1elephent.png")
    save(make_fox(), "1fox.png")
    save(make_gorilla(), "1gorrilla.png")
    save(make_horse(), "1horse.png")
    save(make_lion(), "1lion.png")
    save(make_panther(), "1panther.png")
    save(make_rhino(), "1rino.png")
    save(make_zebra(), "1zebra.png")

    # Birds
    birds = [
        ("3Arara.png", (255, 90, 90)),
        ("3Bald eagle.png", (230, 230, 230)),
        ("3Bee hummingbird.png", (110, 200, 180)),
        ("3Cardinal.png", (220, 50, 60)),
        ("3Comb.png", (255, 140, 60)),
        ("3Common starling.png", (90, 90, 110)),
        ("3Eurasian hoopoe.png", (210, 160, 80)),
        ("3Eurasian magpie.png", (60, 60, 70)),
        ("3European goldfinch.png", (255, 200, 70)),
        ("3extotic.png", (255, 120, 180)),
        ("3Golden pheasant.png", (255, 170, 40)),
        ("3Hawk.png", (160, 120, 80)),
        ("3Homing pigeon.png", (150, 150, 160)),
        ("3Hooded crow.png", (50, 50, 55)),
        ("3House sparrow.png", (170, 130, 90)),
        ("3Kingfishers.png", (50, 140, 220)),
        ("3owl.png", (200, 170, 120)),
        ("3Pink Flamingo.png", (255, 140, 180)),
        ("3Rook.png", (40, 40, 45)),
        ("3Tropical Bird.png", (80, 200, 160)),
        ("3White wagtail.png", (245, 245, 245)),
    ]
    for name, col in birds:
        save(make_bird(col), name)

    # Flowers
    flowers = [
        ("5Black rose.png", (80, 40, 90)),
        ("5Blue rose.png", (80, 130, 255)),
        ("5Chrysanthemum Dahlia.png", (255, 160, 80)),
        ("5Dahlia Flower.png", (255, 100, 140)),
        ("5daisy Yellow Transvaal.png", (255, 230, 90)),
        ("5German chamomile.png", (255, 250, 230)),
        ("5Pink Gerbera flower.png", (255, 120, 170)),
        ("5Red Roses.png", (230, 50, 70)),
        ("5sunflower.png", (255, 200, 50)),
        ("5White graphy.png", (250, 250, 255)),
        ("5White rose.png", (250, 250, 255)),
    ]
    for name, col in flowers:
        save(make_flower(col), name)

    # Fruits
    save(make_fruit((230, 50, 60)), "7APPLE.png")
    save(make_banana(), "7BANANA.png")
    save(make_fruit((70, 110, 220)), "7blueberries.png")
    save(make_fruit((120, 50, 100)), "7boysenberry.png")
    save(make_fruit((255, 90, 140)), "7dragon fruit.png")
    save(make_fruit((140, 190, 60)), "7kivi.png")
    save(make_fruit((255, 200, 60)), "7pineapple fruit.png")
    save(make_fruit((200, 40, 60)), "7pomegranate.png")
    save(make_fruit((140, 70, 180)), "7purple grape.png")
    save(make_fruit((230, 50, 90)), "7raspberry.png")
    save(make_fruit((210, 40, 60)), "7sour cherry fruit.png")
    save(make_fruit((255, 70, 100)), "7strawberry .png")
    save(make_fruit((80, 200, 100)), "7watermelon.png")

    # Vegetables
    veggies = [
        ("10Bell pepper.png", (70, 180, 80)),
        ("10bitter gourd.png", (110, 160, 70)),
        ("10BOTTAL GOURD.png", (150, 190, 90)),
        ("10Broccoli .png", (60, 150, 70)),
        ("10Brown potatoes.png", (180, 140, 80)),
        ("10carrot.png", (255, 130, 50)),
        ("10Chili pepper.png", (220, 40, 50)),
        ("10cucumber.png", (90, 170, 80)),
        ("10eggplants.png", (120, 60, 150)),
        ("10onions.png", (230, 200, 170)),
        ("10PEASE.png", (120, 200, 80)),
        ("10Red tomatoes.png", (230, 50, 60)),
        ("10Sliced ginger.png", (220, 180, 100)),
    ]
    for name, col in veggies:
        save(make_veg(col), name)

    # Colors
    colors = [
        ("4Aqua.png", (70, 220, 210)),
        ("4Azure Radiance.png", (40, 140, 255)),
        ("4Blue.png", (50, 110, 255)),
        ("4Chartreuse.png", (180, 230, 50)),
        ("4Electric Violet.png", (160, 60, 255)),
        ("4green.png", (60, 190, 80)),
        ("4Magenta.png", (230, 40, 180)),
        ("4orange.png", (255, 140, 40)),
        ("4red.png", (230, 40, 50)),
        ("4Rose.png", (255, 110, 160)),
        ("4Spring Green.png", (70, 230, 140)),
        ("4yellow.png", (255, 220, 50)),
    ]
    for name, col in colors:
        save(make_color_blob(col), name)

    # Shapes
    shapes = [
        ("9arrow.png", "arrow", (255, 140, 60)),
        ("9Circle.png", "circle", (90, 170, 255)),
        ("9Crescent.png", "crescent", (255, 210, 70)),
        ("9cross.png", "cross", (255, 100, 130)),
        ("9Cube.png", "cube", (140, 120, 255)),
        ("9Cylinder.png", "cylinder", (80, 200, 180)),
        ("9Hexagon.png", "hexagon", (110, 210, 130)),
        ("9Oval.png", "oval", (255, 150, 180)),
        ("9Parallelogram.png", "parallelogram", (255, 170, 70)),
        ("9Pentagon.png", "pentagon", (100, 160, 255)),
        ("9Rhombus.png", "rhombus", (200, 100, 255)),
        ("9Square.png", "square", (255, 200, 70)),
        ("9Star.png", "star", (255, 210, 60)),
        ("9Triangle.png", "triangle", (90, 210, 160)),
    ]
    for name, kind, col in shapes:
        save(make_shape(kind, col), name)

    # Months
    months = [
        ("6Group 3046.png", "JAN", (140, 190, 255)),
        ("6Group 3218.png", "FEB", (255, 120, 160)),
        ("6Group 2912.png", "MAR", (120, 210, 120)),
        ("6Group 3264.png", "APR", (100, 180, 255)),
        ("6Group 3165.png", "MAY", (255, 150, 180)),
        ("6Group 3003.png", "JUN", (255, 200, 70)),
        ("6Group 2946.png", "JUL", (255, 160, 60)),
        ("6Group 2843.png", "AUG", (255, 180, 70)),
        ("6Group 3095.png", "SEP", (255, 140, 80)),
        ("6Group 2651.png", "OCT", (255, 120, 50)),
        ("6Group 2704.png", "NOV", (200, 120, 70)),
        ("6Group 2779.png", "DEC", (80, 160, 220)),
    ]
    for name, label, col in months:
        save(make_month(label, col), name)

    # Category thumbs used by VideoLearning (assets/images/*.png)
    for name, colors in (
        ("Alphabet.png", [(90, 170, 255), (110, 210, 130), (255, 110, 110)]),
        ("Numbers.png", [(255, 120, 170), (255, 200, 70), (110, 200, 255)]),
        ("Color.png", [(255, 90, 90), (90, 200, 120), (90, 150, 255)]),
        ("Shapes.png", [(255, 210, 70), (110, 200, 255), (255, 120, 170)]),
        ("Animals.png", [(255, 170, 60), (255, 200, 120), (230, 140, 40)]),
        ("Birds.png", [(80, 200, 160), (255, 120, 100), (110, 180, 255)]),
        ("Flowers.png", [(255, 140, 180), (255, 210, 70), (255, 170, 200)]),
        ("Fruit.png", [(255, 90, 90), (255, 220, 70), (255, 120, 150)]),
        ("Month.png", [(110, 180, 255), (255, 200, 70), (140, 220, 140)]),
        ("Vegitable.png", [(255, 140, 60), (90, 200, 100), (255, 90, 80)]),
    ):
        canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
        positions = [(120, 160), (300, 100), (470, 180)]
        for i, col in enumerate(colors):
            paste(canvas, radial_blob(260, col), positions[i])
        save(drop_shadow(canvas), name)

    print("content clay assets done")


if __name__ == "__main__":
    main()
