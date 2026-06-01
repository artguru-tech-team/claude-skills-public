---
name: tldv
description: Summarize YouTube videos using yt-dlp transcript extraction. Use when user shares a YouTube URL and wants a summary, tldv, transcript, or key takeaways.
user_invocable: true
arguments: <youtube_url>
visibility: public
---

# TLDV - YouTube Video Summarizer

Extract and summarize YouTube videos using yt-dlp subtitle download + transcript parsing. Zero browser needed.

## Execution

### Step 1: Extract metadata + subtitles

```bash
python -m yt_dlp --write-auto-sub --sub-lang en --skip-download --sub-format json3 \
  --print "%(title)s|||%(channel)s|||%(view_count)s|||%(upload_date)s|||%(duration)s|||%(description).500s" \
  -o "C:/Users/aquam/AppData/Local/Temp/%(id)s" \
  "<YOUTUBE_URL>" 2>&1
```

Parse the `--print` output: `title|||channel|||views|||date|||duration_seconds|||description`

### Step 2: Parse transcript from json3

```python
import json
with open(r'C:\Users\aquam\AppData\Local\Temp\<VIDEO_ID>.en.json3', 'r', encoding='utf-8') as f:
    data = json.load(f)
seen = set()
lines = []
for event in data.get('events', []):
    for seg in event.get('segs', []):
        text = seg.get('utf8', '').strip()
        if text and text != '\n' and text not in seen:
            seen.add(text)
            lines.append(text)
transcript = ' '.join(lines)
print(transcript)
```

For long transcripts (>12000 chars), read in chunks.

### Step 3: Summarize

Present results as:

```
## "<Video Title>"
**Channel:** <channel> | **Date:** <date> | **Views:** <views> | **Duration:** <duration>

### Key Takeaways
- Bullet point summary of main points

### Detailed Breakdown
| # | Topic/Section | Summary |
|---|---------------|---------|
| 1 | ... | ... |

### Notable Quotes / Mentions
- Any specific tools, products, people, or resources mentioned
```

## Rules

- Always use `python -m yt_dlp` (not `yt-dlp` directly — may not be in PATH on Windows)
- Output path: `C:/Users/aquam/AppData/Local/Temp/<VIDEO_ID>`
- If no English subs available, try `--sub-lang en.*` for auto-generated variants
- For multiple videos, process in parallel using subagents
- Keep summary concise — use tables when listing many items
- Respect copyright: summarize, don't reproduce verbatim chunks

## Fallback

If yt-dlp fails (geo-blocked, private, etc.):
1. Try browser automation to get transcript from YouTube's built-in transcript feature
2. Report the error to the user
