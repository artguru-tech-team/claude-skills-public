---
name: instagram-publish
description: Use when publishing Instagram carousels from HTML files — covers export to PNG at 1080x1350px via Playwright and upload via Upload-Post API. Includes contrast check checklist before export.
visibility: public
---

# Instagram Carousel Publisher

Full pipeline: HTML carousel → PNG slides (1080×1350px) → Instagram via Upload-Post API.

## Pre-publish Checklist (run before every export)

Before exporting slides, verify:
- [ ] Text on light backgrounds (`#F4F0EB`) uses `#0D0B12` or `#4a4540` — never light gray
- [ ] Text on dark backgrounds (`#0D0B12`) uses `#fff` or `rgba(255,255,255,0.72)` minimum — never below 0.5 opacity for body copy
- [ ] Text on gradient slides uses `#fff` or `rgba(255,255,255,0.75)` minimum
- [ ] Tag labels: `#00C8FF` on light, `#7DE8FF` on dark, `rgba(255,255,255,0.6)` on gradient
- [ ] Progress bar label: `rgba(0,0,0,0.3)` on light, `rgba(255,255,255,0.4)` on dark
- [ ] CTA keyword on slide 7 is readable (white text on `#0075A8` background or dark text on white pill)
- [ ] Slide 7 has no swipe arrow, full progress bar (100%)

## Step 1 — Export slides to PNG

Script: `brand-kit/melekbuilds/scripts/export_slides.py`

```bash
python scripts/export_slides.py \
  --html carousel-deep-research.html \
  --out slides/deep-research-hd/ \
  --slides 7
```

**Key settings:**
- `device_scale_factor=2.7` → 400×500px HTML renders as **1080×1350px** PNG (Instagram native 4:5)
- Playwright Chromium, `wait_until="networkidle"` + 1500ms font wait
- Each slide captured with `.slide` nth-selector after JS `translateX`

Output: `slide-01.png` … `slide-07.png` at 1080×1350px.

## Step 2 — Publish via Upload-Post API

Script: `brand-kit/melekbuilds/scripts/publish_carousel.py`

```bash
UPLOADPOST_TOKEN="..." UPLOADPOST_USER="melek" \
python scripts/publish_carousel.py \
  --slides slides/deep-research-hd/slide-*.png \
  --caption "Caption ici. Commente MOT-CLÉ 👇"
```

**API details:**
- Endpoint: `POST https://api.upload-post.com/api/upload_photos`
- Auth header: `Authorization: Token <jwt>` (NOT Bearer, NOT Apikey)
- Photos field name: `photos[]` (NOT `photos`)
- All params (user, platform[], title) sent as `(None, value)` tuples in `files` list
- Token stored in `C:/Users/aquam/Documents/melek/.env` as `UPLOADPOST_TOKEN`
- Username: `melek`

**Multipart format (critique):**
```python
files = [
    ('user',         (None, 'melek')),
    ('platform[]',   (None, 'instagram')),
    ('title',        (None, caption)),
    ('async_upload', (None, 'true')),
    ('photos[]',     ('slide-01.png', open('slide-01.png','rb'), 'image/png')),
    ('photos[]',     ('slide-02.png', open('slide-02.png','rb'), 'image/png')),
    # ... repeat for all slides
]
requests.post(url, headers=headers, files=files)
```

## Step 3 — Check status

```python
requests.get(
    'https://api.upload-post.com/api/uploadposts/status?request_id=<id>',
    headers={'Authorization': f'Token {token}'}
)
# → {"status":"completed","results":[{"success":true,"post_url":"https://instagram.com/p/..."}]}
```

Note: `media_size_bytes` in the status only reflects the first image — not a reliable indicator that the carousel failed. Check the post URL directly.

## Scheduled post

Add `--schedule "2026-04-15T08:00:00Z"` to post at a specific time (Paris timezone auto-applied).

## Caption format (melekbuilds standard)

```
[Hook 1 phrase — reprend le titre slide 1].
[Phrase de valeur].
Commente [MOT-CLÉ] 👇 je t'envoie [le skill / le guide / le template] gratuitement.
```

Emoji autorisés dans la caption (Instagram les affiche bien), mais évite les caractères Unicode spéciaux dans les scripts Python (encode error sur Windows cp1252).

## Known issues

| Problème | Cause | Fix |
|----------|-------|-----|
| Images downscalées | Export à 400px (taille HTML) | `device_scale_factor=2.7` dans export_slides.py |
| `401 Invalid API key format` | Mauvais format d'auth | Utiliser `Token <jwt>`, pas `Bearer` |
| `400 Photo files or URLs required` | Mauvais nom de champ | Utiliser `photos[]` pas `photos` |
| Unicode error sur print | Windows cp1252 | Pas d'emoji dans les f-strings print() |
| Polling timeout | Upload-Post async > 120s | Normal — vérifier statut manuellement après |
