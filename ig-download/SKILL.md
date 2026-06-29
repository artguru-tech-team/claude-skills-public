---
name: ig-download
description: Download Instagram posts, reels, or carousels by URL or shortcode using instaloader. Requires one-time login as @ghmelek (session cached locally). Triggers on "download this IG post", "rip this reel", "save this carousel", or any instagram.com/p/, /reel/, /tv/ URL.
---

# IG Download

Download Instagram posts (single images, carousels, reels, stories) to the Obsidian vault using `instaloader` with a cached @ghmelek session.

## When to trigger

- User pastes an `instagram.com/p/<SHORTCODE>/`, `/reel/<SHORTCODE>/`, or `/tv/<SHORTCODE>/` URL
- User says "download this IG post", "rip this reel", "save this carousel"

## Prerequisites

**One-time login** — anonymous IG access is broken in 2026 (403 Forbidden on graphql). The session file lives at `~/.config/instaloader/session-ghmelek`.

If the file doesn't exist OR a call returns `Login required`, ask the user to run:
```bash
instaloader --login=ghmelek
```
This prompts for the @ghmelek password interactively and caches the session. Do NOT attempt to pass the password via flags or env.

## Workflow

### 1. Extract the shortcode
From a URL like `https://www.instagram.com/p/C9xYz1aB2cD/?igsh=...`, the shortcode is `C9xYz1aB2cD`.

Regex: `/(?:p|reel|tv)/([A-Za-z0-9_-]+)`

### 2. Resolve output dir
```bash
OUT="$(~/.claude/skills/ig-download/config.sh)"
cd "$OUT"
```

### 3. Run instaloader
```bash
instaloader --login=ghmelek --quiet -- -<SHORTCODE>
```

Notes on syntax:
- `-- -<SHORTCODE>` — the `--` ends flag parsing, the leading `-` before the shortcode tells instaloader "this is a shortcode, not a profile".
- `--login=ghmelek` reuses the cached session (no prompt if session exists).

### 4. Output
Files land in `<OUT>/-<SHORTCODE>/`:
- `YYYY-MM-DD_HH-MM-SS_UTC.jpg` (or `.mp4` for reels)
- `..._1.jpg`, `..._2.jpg`... for carousels
- `..._UTC.txt` — caption
- `..._UTC.json.xz` — full metadata (timestamp, location, like count, owner)

### 5. Report back
- Number of media files saved
- Full path
- First 200 chars of caption

## Bulk profile download

```bash
instaloader --login=ghmelek --no-videos --post-metadata-txt="{caption}" USERNAME
```

Use only when explicitly asked. Throttle to <50 posts/day to minimize ban risk on @ghmelek.

## Gotchas

- **Anonymous access dead (2026)** — IG returns 403 on graphql endpoints without auth. Login is required even for "public" posts.
- **Session expires** — if the cached session is invalidated (logout from another device, password change), re-run `instaloader --login=ghmelek`.
- **Ban risk** — keep volume modest. ~50 posts/day is safe; bulk profile scrapes of 1000+ posts may trigger temporary blocks.
- **Stories** — work with login: `instaloader --login=ghmelek :stories` (downloads stories of followees).
- **Shortcode vs media ID** — the URL segment after `/p/` is the shortcode, NOT the numeric media ID.

## Output directory

Resolved by `config.sh` in this skill folder. Defaults to the Obsidian vault's `03 - Resources/ig-downloads/` (Mac Drive mount or Windows G:). Override with `IG_DOWNLOAD_DIR=...` env var.
