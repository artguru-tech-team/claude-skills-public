---
name: yt-search
description: Search YouTube directly from Claude Code. Returns structured results with titles, channels, view counts, duration, and links. Use when user asks to search YouTube, find videos, or uses /yt-search.
user_invocable: true
arguments: query to search for on YouTube
visibility: public
---

# YouTube Search Skill

Search YouTube using yt-dlp and return structured results.

## Usage

The user provides a search query as the argument. Examples:
- `/yt-search claude code tutorial`
- `/yt-search react server components 2026`

## How to Execute

1. Take the user's query from the ARGUMENTS section
2. Run the search command below with the query
3. Parse the JSON output and format as a markdown table
4. Present results to the user

## Search Command

```bash
PYTHONIOENCODING=utf-8 python -m yt_dlp "ytsearch10:<QUERY>" --flat-playlist -j 2>/dev/null
```

- Replace `<QUERY>` with the user's search terms
- Default: 10 results. User can request more/less (e.g. "top 5 results for X")
- Each line of output is a separate JSON object

## Output Format

Present results as a markdown table:

```
| # | Title | Channel | Views | Duration | Link |
|---|-------|---------|-------|----------|------|
| 1 | Video Title | Channel Name | 303K | 35:49 | [Watch](url) |
```

### Field Mapping

| Table Column | JSON Field |
|-------------|-----------|
| Title | `title` (truncate to 60 chars if needed) |
| Channel | `channel` |
| Views | `view_count` (format: 1.2M, 303K, etc.) |
| Duration | `duration_string` |
| Link | `url` or `webpage_url` |

### View Count Formatting
- >= 1,000,000 → `1.2M`
- >= 1,000 → `303K`
- < 1,000 → show as-is

## Error Handling

- If yt-dlp is not installed: tell user to run `pip install yt-dlp`
- If no results: tell user no videos found for that query
- If command fails: show the error message

## Tips

- Add year to query for recent content (e.g. "react 2026")
- Use quotes in query for exact phrases
- User can ask for more results: "search 20 results for X"
