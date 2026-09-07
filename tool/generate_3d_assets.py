#!/usr/bin/env python3
"""Generate cute preschool 3D claymation assets via pollinations.ai."""

from __future__ import annotations

import argparse
import io
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
UI = ROOT / "assets" / "ui"
IMAGES = ROOT / "assets" / "images"

STYLE = (
    "cute preschool 3D claymation soft glossy plastic toy, studio soft lighting, "
    "subtle ambient occlusion, vibrant candy colors, toddler friendly, centered, "
    "isolated subject on solid pure black background, no text watermark, high quality"
)

# (relative_path_under_assets, prompt_subject)
UI_JOBS: list[tuple[str, str]] = [
    ("ui/home_start_3d.png", "friendly open storybook with floating ABC candy letter blocks and tiny star"),
    ("ui/home_fun_quiz_3d.png", "smiling yellow question mark character with colorful puzzle pieces"),
    ("ui/home_look_3d.png", "cute magnifying glass looking at three choice toys apple ball and star"),
    ("ui/home_listen_3d.png", "cute cartoon lion wearing oversized purple headphones with music notes"),
    ("ui/rate_star_3d.png", "chubby golden five point star character with cute smile and rosy cheeks"),
    ("ui/sun_3d.png", "smiling orange yellow sun character with soft wavy 3D rays"),
    ("ui/home_mascot_3d.png", "cute friendly cartoon elephant toddler mascot waving hello, soft blue accents"),
    ("ui/cat_Alphabet.png", "glossy 3D ABC letter blocks A B C clustered candy plastic toys"),
    ("ui/cat_Numbers.png", "glossy 3D number blocks 1 2 3 clustered candy plastic toys"),
    ("ui/cat_Color.png", "cute 3D paint palette with colorful candy paint blobs dripping"),
    ("ui/cat_Shapes.png", "cute 3D star circle and triangle toys clustered"),
    ("ui/cat_Animals.png", "cute 3D cartoon lion face toy soft clay"),
    ("ui/cat_Birds.png", "cute 3D cartoon parrot toy soft clay"),
    ("ui/cat_Flowers.png", "cute 3D sunflower and daisy flower toys"),
    ("ui/cat_Fruit.png", "cute 3D apple banana and strawberry toys"),
    ("ui/cat_Month.png", "cute 3D calendar toy with smiling sun weather"),
    ("ui/cat_Vegitable.png", "cute 3D carrot broccoli and tomato toys"),
]

LETTER_COLORS = [
    "coral pink", "sky blue", "mint green", "sunny yellow", "lavender purple",
    "tangerine orange", "aqua teal", "bubblegum pink", "lime green", "soft red",
    "periwinkle blue", "peach orange", "violet", "turquoise", "golden yellow",
    "rose pink", "emerald", "royal blue", "magenta", "cyan",
    "amber", "indigo", "spring green", "hot pink", "ocean blue", "cherry red",
]

CONTENT_JOBS: list[tuple[str, str]] = [
    # Alphabet learning cards (assets/images/2X.png)
    *[(f"images/2{c}.png", f"cute 3D clay capital letter {c} character with simple smile, {LETTER_COLORS[i]} glossy plastic") for i, c in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ")],
    # Numbers
    *[(f"images/8{n}.png", f"cute 3D clay number {n} block character with smile, candy plastic toy") for n in range(10)],
    # Colors — keep filename, describe hue
    ("images/4Aqua.png", "cute 3D clay aqua turquoise paint blob character"),
    ("images/4Azure Radiance.png", "cute 3D clay bright azure blue paint blob character"),
    ("images/4Blue.png", "cute 3D clay blue paint blob character"),
    ("images/4Chartreuse.png", "cute 3D clay chartreuse lime green paint blob character"),
    ("images/4Electric Violet.png", "cute 3D clay electric violet paint blob character"),
    ("images/4green.png", "cute 3D clay green paint blob character"),
    ("images/4Magenta.png", "cute 3D clay magenta paint blob character"),
    ("images/4orange.png", "cute 3D clay orange paint blob character"),
    ("images/4red.png", "cute 3D clay red paint blob character"),
    ("images/4Rose.png", "cute 3D clay rose pink paint blob character"),
    ("images/4Spring Green.png", "cute 3D clay spring green paint blob character"),
    ("images/4yellow.png", "cute 3D clay yellow paint blob character"),
    # Shapes
    ("images/9arrow.png", "cute 3D clay arrow shape toy"),
    ("images/9Circle.png", "cute 3D clay circle shape toy with smile"),
    ("images/9Crescent.png", "cute 3D clay crescent moon shape toy"),
    ("images/9cross.png", "cute 3D clay plus cross shape toy"),
    ("images/9Cube.png", "cute 3D clay cube shape toy"),
    ("images/9Cylinder.png", "cute 3D clay cylinder shape toy"),
    ("images/9Hexagon.png", "cute 3D clay hexagon shape toy"),
    ("images/9Oval.png", "cute 3D clay oval shape toy"),
    ("images/9Parallelogram.png", "cute 3D clay parallelogram shape toy"),
    ("images/9Pentagon.png", "cute 3D clay pentagon shape toy"),
    ("images/9Rhombus.png", "cute 3D clay rhombus diamond shape toy"),
    ("images/9Square.png", "cute 3D clay square shape toy with smile"),
    ("images/9Star.png", "cute 3D clay star shape toy with smile"),
    ("images/9Triangle.png", "cute 3D clay triangle shape toy with smile"),
    # Animals
    ("images/1beer.png", "cute 3D clay cartoon bear toy soft plastic"),
    ("images/1bull.png", "cute 3D clay cartoon bull toy soft plastic"),
    ("images/1camel.png", "cute 3D clay cartoon camel toy soft plastic"),
    ("images/1cat.png", "cute 3D clay cartoon cat toy soft plastic"),
    ("images/1dear.png", "cute 3D clay cartoon deer toy soft plastic"),
    ("images/1dog.png", "cute 3D clay cartoon dog toy soft plastic"),
    ("images/1elephent.png", "cute 3D clay cartoon elephant toy soft plastic"),
    ("images/1fox.png", "cute 3D clay cartoon fox toy soft plastic"),
    ("images/1gorrilla.png", "cute 3D clay cartoon gorilla toy soft plastic"),
    ("images/1horse.png", "cute 3D clay cartoon horse toy soft plastic"),
    ("images/1lion.png", "cute 3D clay cartoon lion toy soft plastic"),
    ("images/1panther.png", "cute 3D clay cartoon black panther toy soft plastic"),
    ("images/1rino.png", "cute 3D clay cartoon rhinoceros toy soft plastic"),
    ("images/1zebra.png", "cute 3D clay cartoon zebra toy soft plastic"),
    # Birds
    ("images/3Arara.png", "cute 3D clay macaw parrot toy"),
    ("images/3Bald eagle.png", "cute 3D clay bald eagle toy"),
    ("images/3Bee hummingbird.png", "cute 3D clay hummingbird toy"),
    ("images/3Cardinal.png", "cute 3D clay red cardinal bird toy"),
    ("images/3Comb.png", "cute 3D clay rooster comb chicken toy"),
    ("images/3Common starling.png", "cute 3D clay starling bird toy"),
    ("images/3Eurasian hoopoe.png", "cute 3D clay hoopoe bird toy"),
    ("images/3Eurasian magpie.png", "cute 3D clay magpie bird toy"),
    ("images/3European goldfinch.png", "cute 3D clay goldfinch bird toy"),
    ("images/3extotic.png", "cute 3D clay exotic tropical bird toy"),
    ("images/3Golden pheasant.png", "cute 3D clay golden pheasant toy"),
    ("images/3Hawk.png", "cute 3D clay hawk bird toy"),
    ("images/3Homing pigeon.png", "cute 3D clay pigeon toy"),
    ("images/3Hooded crow.png", "cute 3D clay crow toy"),
    ("images/3House sparrow.png", "cute 3D clay sparrow bird toy"),
    ("images/3Kingfishers.png", "cute 3D clay kingfisher bird toy"),
    ("images/3owl.png", "cute 3D clay owl toy"),
    ("images/3Pink Flamingo.png", "cute 3D clay pink flamingo toy"),
    ("images/3Rook.png", "cute 3D clay rook crow bird toy"),
    ("images/3Tropical Bird.png", "cute 3D clay tropical bird toy"),
    ("images/3White wagtail.png", "cute 3D clay white wagtail bird toy"),
    # Flowers
    ("images/5Black rose.png", "cute 3D clay dark purple rose flower toy"),
    ("images/5Blue rose.png", "cute 3D clay blue rose flower toy"),
    ("images/5Chrysanthemum Dahlia.png", "cute 3D clay chrysanthemum flower toy"),
    ("images/5Dahlia Flower.png", "cute 3D clay dahlia flower toy"),
    ("images/5daisy Yellow Transvaal.png", "cute 3D clay yellow daisy flower toy"),
    ("images/5German chamomile.png", "cute 3D clay chamomile flower toy"),
    ("images/5Pink Gerbera flower.png", "cute 3D clay pink gerbera flower toy"),
    ("images/5Red Roses.png", "cute 3D clay red rose flower toy"),
    ("images/5sunflower.png", "cute 3D clay sunflower toy"),
    ("images/5White graphy.png", "cute 3D clay white flower toy"),
    ("images/5White rose.png", "cute 3D clay white rose flower toy"),
    # Fruits
    ("images/7APPLE.png", "cute 3D clay red apple fruit toy"),
    ("images/7BANANA.png", "cute 3D clay banana fruit toy"),
    ("images/7blueberries.png", "cute 3D clay blueberries fruit toy"),
    ("images/7boysenberry.png", "cute 3D clay boysenberry fruit toy"),
    ("images/7dragon fruit.png", "cute 3D clay dragon fruit toy"),
    ("images/7kivi.png", "cute 3D clay kiwi fruit toy"),
    ("images/7pineapple fruit.png", "cute 3D clay pineapple fruit toy"),
    ("images/7pomegranate.png", "cute 3D clay pomegranate fruit toy"),
    ("images/7purple grape.png", "cute 3D clay purple grapes fruit toy"),
    ("images/7raspberry.png", "cute 3D clay raspberry fruit toy"),
    ("images/7sour cherry fruit.png", "cute 3D clay cherry fruit toy"),
    ("images/7strawberry .png", "cute 3D clay strawberry fruit toy"),
    ("images/7watermelon.png", "cute 3D clay watermelon fruit toy"),
    # Months — seasonal calendar stickers
    ("images/6Group 3046.png", "cute 3D clay January winter snowflake calendar toy"),
    ("images/6Group 3218.png", "cute 3D clay February heart calendar toy"),
    ("images/6Group 2912.png", "cute 3D clay March spring flower calendar toy"),
    ("images/6Group 3264.png", "cute 3D clay April rain cloud calendar toy"),
    ("images/6Group 3165.png", "cute 3D clay May flower blossom calendar toy"),
    ("images/6Group 3003.png", "cute 3D clay June sun calendar toy"),
    ("images/6Group 2946.png", "cute 3D clay July beach sun calendar toy"),
    ("images/6Group 2843.png", "cute 3D clay August summer leaf calendar toy"),
    ("images/6Group 3095.png", "cute 3D clay September autumn leaf calendar toy"),
    ("images/6Group 2651.png", "cute 3D clay October pumpkin calendar toy"),
    ("images/6Group 2704.png", "cute 3D clay November fall tree calendar toy"),
    ("images/6Group 2779.png", "cute 3D clay December christmas gift calendar toy"),
    # Vegetables
    ("images/10Bell pepper.png", "cute 3D clay bell pepper vegetable toy"),
    ("images/10bitter gourd.png", "cute 3D clay bitter gourd vegetable toy"),
    ("images/10BOTTAL GOURD.png", "cute 3D clay bottle gourd vegetable toy"),
    ("images/10Broccoli .png", "cute 3D clay broccoli vegetable toy"),
    ("images/10Brown potatoes.png", "cute 3D clay potato vegetable toy"),
    ("images/10carrot.png", "cute 3D clay carrot vegetable toy"),
    ("images/10Chili pepper.png", "cute 3D clay chili pepper vegetable toy"),
    ("images/10cucumber.png", "cute 3D clay cucumber vegetable toy"),
    ("images/10eggplants.png", "cute 3D clay eggplant vegetable toy"),
    ("images/10onions.png", "cute 3D clay onion vegetable toy"),
    ("images/10PEASE.png", "cute 3D clay green peas vegetable toy"),
    ("images/10Red tomatoes.png", "cute 3D clay tomato vegetable toy"),
    ("images/10Sliced ginger.png", "cute 3D clay ginger root vegetable toy"),
    # Misc UI
    ("images/sun.png", "smiling orange yellow sun character with soft wavy 3D rays"),
]

# UI letter tiles
for i, c in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ"):
    UI_JOBS.append(
        (
            f"ui/letter_{c}.png",
            f"cute 3D clay capital letter {c} character with simple smile rosy cheeks, "
            f"{LETTER_COLORS[i]} glossy soft plastic toy",
        )
    )


def remove_black_bg(im: Image.Image, threshold: int = 36) -> Image.Image:
    """Make near-black background pixels transparent."""
    rgba = im.convert("RGBA")
    pixels = rgba.load()
    w, h = rgba.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if r <= threshold and g <= threshold and b <= threshold:
                pixels[x, y] = (r, g, b, 0)
            elif r <= threshold + 20 and g <= threshold + 20 and b <= threshold + 20:
                # Soft edge fade
                fade = max(r, g, b)
                alpha = int(255 * (fade - threshold) / 20)
                pixels[x, y] = (r, g, b, max(0, min(255, alpha)))
    return rgba


def fetch(prompt: str, size: int = 768, retries: int = 8) -> Image.Image:
    full = f"{prompt}, {STYLE}"
    q = urllib.parse.quote(full)
    url = (
        f"https://image.pollinations.ai/prompt/{q}"
        f"?width={size}&height={size}&nologo=true&enhance=true"
    )
    last_err: Exception | None = None
    for attempt in range(retries):
        try:
            req = urllib.request.Request(
                url,
                headers={"User-Agent": "kids-learning-asset-gen/1.0"},
            )
            with urllib.request.urlopen(req, timeout=120) as resp:
                data = resp.read()
            return Image.open(io.BytesIO(data)).convert("RGB")
        except urllib.error.HTTPError as exc:
            last_err = exc
            # Pollinations rate-limits aggressively — wait longer on 429.
            wait = 12.0 * (attempt + 1) if exc.code == 429 else 2.5 * (attempt + 1)
            print(f"    retry {attempt + 1}/{retries} after HTTP {exc.code}, sleep {wait:.0f}s", flush=True)
            time.sleep(wait)
        except Exception as exc:  # noqa: BLE001
            last_err = exc
            time.sleep(2.5 * (attempt + 1))
    raise RuntimeError(f"Failed after {retries} tries: {last_err}")


def process_job(rel: str, subject: str, size: int, force: bool) -> str:
    out = ROOT / "assets" / rel
    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists() and not force and out.stat().st_size > 8000:
        # Skip if already a reasonably large file from this run / prior gen
        # Still regenerate if --force
        pass
    if out.exists() and not force:
        # Always regenerate when force=false only if marker file says skip? User wants all new.
        # We'll regenerate UI always when force; otherwise skip existing freshly written.
        mtime_age = time.time() - out.stat().st_mtime
        if mtime_age < 60 * 30 and out.stat().st_size > 12000:
            return f"skip {rel}"
    im = fetch(subject, size=size)
    im = remove_black_bg(im)
    # Soft crop empty margins a bit
    bbox = im.getbbox()
    if bbox:
        pad = 12
        l, t, r, b = bbox
        l = max(0, l - pad)
        t = max(0, t - pad)
        r = min(im.width, r + pad)
        b = min(im.height, b + pad)
        im = im.crop((l, t, r, b))
        # Pad back to square
        side = max(im.width, im.height)
        canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
        canvas.paste(im, ((side - im.width) // 2, (side - im.height) // 2), im)
        im = canvas.resize((size, size), Image.Resampling.LANCZOS)
    im.save(out, format="PNG", optimize=True)
    return f"ok   {rel} ({out.stat().st_size} bytes)"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", choices=("ui", "content", "all"), default="all")
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--size", type=int, default=768)
    parser.add_argument("--limit", type=int, default=0, help="Stop after N jobs (debug)")
    args = parser.parse_args()

    jobs: list[tuple[str, str]] = []
    if args.only in ("ui", "all"):
        jobs.extend(UI_JOBS)
    if args.only in ("content", "all"):
        jobs.extend(CONTENT_JOBS)

    if args.limit:
        jobs = jobs[: args.limit]

    print(f"Generating {len(jobs)} assets into {ROOT / 'assets'}", flush=True)
    ok = 0
    fail = 0
    for i, (rel, subject) in enumerate(jobs, 1):
        try:
            msg = process_job(rel, subject, args.size, args.force)
            print(f"[{i}/{len(jobs)}] {msg}", flush=True)
            if msg.startswith("ok"):
                ok += 1
            else:
                ok += 1  # skip counts as fine
        except Exception as exc:  # noqa: BLE001
            fail += 1
            print(f"[{i}/{len(jobs)}] FAIL {rel}: {exc}", flush=True)
            time.sleep(5)
        # Be gentle with free image API rate limits.
        time.sleep(4.5)
    print(f"done ok={ok} fail={fail}", flush=True)
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
