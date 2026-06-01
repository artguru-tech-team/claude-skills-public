---
name: perplexity-scraper
description: Enrich leads via Perplexity.ai with Playwright when scrapers are blocked.
visibility: public
---

# Skill: Perplexity Lead Enrichment via Playwright

Enrich leads (email, social handles) by querying Perplexity.ai with Playwright when Google/Bing scrapers are blocked.

Reference implementation: `C:/Users/aquam/Documents/melek/scripts/enrich_streamers_perplexity.py`

---

## When to Use

- Google/Bing scraping is blocked (CAPTCHAs, 429s, Cloudflare)
- You need AI-synthesized results, not raw HTML (Perplexity aggregates multiple sources)
- Target is a semi-public figure (streamer, influencer, freelancer) with scattered web presence
- Standard enrichment tools (Apollo, Hunter, Dropcontact) return nothing or placeholder emails

---

## Prerequisites

```bash
pip install playwright
playwright install chromium
```

Export cookies from a logged-in Perplexity.ai session using Cookie-Editor (Chrome extension).
Save as `cookies.txt` (Netscape format) or `cookies.json` (Cookie-Editor JSON export).
Place the file somewhere accessible and point `COOKIES_FILE` at it.

---

## Cloudflare Workaround

**One fresh browser per query.** Do not reuse context across queries.

```python
browser = await pw.chromium.launch(headless=False)  # headless=True gets blocked
ctx = await browser.new_context(
    user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) ...",
    locale="fr-FR",
    viewport={"width": 1280, "height": 800}
)
await ctx.add_cookies(cookies)
# ... run query ...
await browser.close()  # close after every query
```

`headless=False` is required. Headless Chromium is fingerprinted and blocked by Cloudflare.

---

## Cookie Loading

Supports two formats, auto-detected:

**Netscape `.txt`** (tab-separated, 7 columns):
```
domain  include_subdomains  path  secure  expiry  name  value
```

**Cookie-Editor JSON** (array of objects with `name`, `value`, `domain`, etc.):
```json
[{"name": "...", "value": "...", "domain": ".perplexity.ai", ...}]
```

The `sameSite` field needs normalization: `"unspecified"` and `"no_restriction"` map to `"None"`.

---

## Query Design

Be specific. Vague queries return generic pages, not contact info.

**Template:**
```
email de contact du [role] [nationality] [name + alias].
Trouve son adresse email personnelle ou professionnelle.
LinkedIn: [url if available]
```

**Tips:**
- Include alias/tagline if different from legal name (e.g. streamer handles)
- Add platform context: "streamer Twitch français", "YouTuber gaming anglophone"
- Append "trouve email" or "adresse email" explicitly — Perplexity responds to intent
- Country narrows results significantly for common names

---

## Extract Patterns

```python
# Email — exclude known fake domains
emails = re.findall(r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}', text)

# Twitch
twitch = re.findall(r'https?://(?:www\.)?twitch\.tv/[\w\-]+', text)

# Twitter/X
twitter = re.findall(r'(?:twitter\.com|x\.com)/[\w\-]+', text)

# Instagram (URL or contextual @handle)
instagram = re.findall(r'(?:instagram\.com|instagr\.am)/[\w\.\-]+', text)
if not instagram:
    ig_ctx = re.findall(r'instagram[^\n]{0,40}@([\w\.]+)', text, re.IGNORECASE)
```

**Blacklist domains** (never real contact emails):
- `twitch.tv`, `youtube.com`, `tiktok.com`, `kick.com`
- `placeholder.clip2earn.money`, `example.com`, `noreply`
- Any business domain clearly unrelated to the person (cross-reference manually)

---

## Rate Limiting

```python
DELAY_MIN = 9.0
DELAY_MAX = 14.0
await asyncio.sleep(random.uniform(DELAY_MIN, DELAY_MAX))
```

Do not go below 8 seconds. Perplexity rate-limits aggressively on repeated fast queries from the same account.

---

## Resume Pattern

Add a `pplx_status` column to the output CSV. On restart, skip rows where `pplx_status` is already set.

```python
# On startup, load existing output if it exists
if os.path.exists(OUTPUT_CSV):
    done_rows = {r["_id"]: r for r in csv.DictReader(open(OUTPUT_CSV)) if r.get("pplx_status")}
    for r in rows:
        if r["_id"] in done_rows:
            r.update(done_rows[r["_id"]])

# Only process rows that need enrichment AND have no status
targets = [
    (i, r) for i, r in enumerate(rows)
    if needs_enrichment(r) and not r.get("pplx_status")
]
```

Status values: `EMAIL_FOUND` | `NOT_FOUND` | `ECHEC`

---

## Checkpoint

Write to disk every 5 rows to avoid losing work on crash or Cloudflare block:

```python
if idx % 5 == 0:
    with open(OUTPUT_CSV, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)
```

---

## Output Columns Added

| Column | Description |
|--------|-------------|
| `real_email` | Email found by Perplexity (empty if not found) |
| `twitch_url_found` | Twitch profile URL |
| `twitter_found` | Twitter/X handle URL |
| `instagram_found` | Instagram profile URL |
| `pplx_status` | `EMAIL_FOUND` / `NOT_FOUND` / `ECHEC` |
| `pplx_response` | First 200 chars of Perplexity answer (for manual review) |

---

## Known Limitations

- **Email find rate: ~15-20%** for anonymous/pseudonymous streamers
- Works better for public figures with media coverage (journalists, founders, public speakers)
- Perplexity returns page body via `document.body.innerText` — no structured JSON, regex only
- Sessions expire; re-export cookies if you get auth errors
- Cloudflare challenges still occur occasionally even with fresh browser + headless=False — retry manually
- Not suitable for bulk runs over 200 rows in one session (account risk)
