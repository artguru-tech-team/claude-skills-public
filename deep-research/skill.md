---
name: deep-research
description: Multi-source deep research combining YouTube, web search, and article URLs into NotebookLM as a free RAG backend. Use when user wants to research a topic in depth, find up-to-date information, generate analysis, infographics, podcasts, quizzes, or any NotebookLM artifact. Triggers on "research X", "deep dive into X", "find everything about X", or /deep-research.
user_invocable: true
arguments: topic to research
visibility: public
---

# Deep Research Skill

Research any topic using **multiple sources** (YouTube, web articles, web research) fed into NotebookLM as a free RAG analysis engine. Zero token cost for the research itself — only tokens used are for sending/receiving commands.

## Why This Works

- **YouTube** = expert video content, tutorials, talks, interviews
- **Web research** = NotebookLM's built-in web search finds and indexes articles automatically
- **WebSearch** = Claude's web search finds specific articles, blog posts, papers to add as URL sources
- **NotebookLM** = free Google-powered RAG that indexes all sources and generates artifacts
- **Claude Code** = orchestrator that runs all source-gathering in parallel
- **Result**: comprehensive, multi-perspective research without burning Claude tokens on analysis

## Workflow

```
User query
  ├── YouTube search (yt-search) ──────────────┐
  ├── Web research (notebooklm add-research) ──┼── NotebookLM notebook ── Analyze/Generate
  └── Article search (WebSearch + add URLs) ───┘
```

## Step-by-Step Execution

### Step 1: Create NotebookLM Notebook

Create the notebook first so all source-adding steps can target it.

```bash
notebooklm create "<TOPIC> Research" --json
# Parse the notebook ID from output
notebooklm use <notebook_id>
```

### Step 2: Gather Sources (run in parallel)

Launch **three parallel tracks** to maximize source diversity:

#### Track A: YouTube Videos
Use `/yt-search` to find relevant videos:

```bash
PYTHONIOENCODING=utf-8 python3 -m yt_dlp "ytsearch10:<TOPIC>" --flat-playlist -j 2>/dev/null
# (use `python` instead of `python3` on systems without python3 on PATH)
```

- Pick top 5-10 by view count and relevance
- Add each to the notebook:
  ```bash
  notebooklm source add "https://www.youtube.com/watch?v=VIDEO_ID" --notebook <notebook_id>
  ```

#### Track B: NotebookLM Web Research (automatic)
Let NotebookLM search the web and import sources itself:

```bash
# Fast mode: 5-10 sources, ~30 seconds
notebooklm source add-research "<TOPIC>" --notebook <notebook_id>

# Deep mode: 20+ sources, 2-5 minutes (use for thorough research)
notebooklm source add-research "<TOPIC>" --mode deep --no-wait --notebook <notebook_id>
```

- Fast mode is good for focused topics
- Deep mode is better for broad or complex topics
- Deep mode runs async — use `notebooklm research wait --notebook <notebook_id> --import-all` to wait

#### Track C: Targeted Article URLs (optional but powerful)
Use Claude's WebSearch to find high-quality articles, then add them:

```bash
# Use WebSearch tool to find articles, blog posts, papers
# Then add each relevant URL:
notebooklm source add "https://example.com/article" --notebook <notebook_id>
notebooklm source add "https://blog.example.com/post" --notebook <notebook_id>
```

Good for:
- Industry reports and whitepapers
- Blog posts from known experts
- Documentation and official guides
- Academic papers and case studies

### Step 3: Wait for Sources

Ensure all sources are indexed before analysis:

```bash
notebooklm source list --notebook <notebook_id> --json
# Check all sources have status "ready"
# Or wait for specific sources:
notebooklm source wait <source_id> -n <notebook_id>
```

For deep research, also wait for research completion:
```bash
notebooklm research wait -n <notebook_id> --import-all --timeout 300
```

### Step 4: Analyze with NotebookLM

```bash
notebooklm ask "Analyze the key strategies, frameworks, and trends discussed across all sources. Provide a comprehensive summary." --notebook <notebook_id>

# Ask specific follow-up questions
notebooklm ask "<specific question>" --notebook <notebook_id>
```

### Step 5: Generate Artifacts (Optional)

| Artifact | Command | Output |
|----------|---------|--------|
| Audio podcast | `notebooklm generate audio` | MP3 |
| Video overview | `notebooklm generate video` | MP4 |
| Infographic | `notebooklm generate infographic` | PNG |
| Slide deck | `notebooklm generate slide-deck` | PDF/PPTX |
| Quiz | `notebooklm generate quiz` | JSON/MD |
| Flashcards | `notebooklm generate flashcards` | JSON/MD |
| Report | `notebooklm generate report --format briefing-doc` | Markdown |
| Mind map | `notebooklm generate mind-map` | JSON |
| Data table | `notebooklm generate data-table "description"` | CSV |

Download artifacts:
```bash
notebooklm download audio output.mp3
notebooklm download infographic output.png
```

### Step 6: Return Results to User

- Present the analysis in a clean, structured format
- List source breakdown: X YouTube videos, Y web research sources, Z articles
- Offer to generate additional artifacts if useful

## Parallel Execution Strategy

For maximum efficiency, use subagents:

```
Main agent: Create notebook
  ├── Subagent 1: yt-search → add YouTube videos → wait for indexing
  ├── Subagent 2: add-research (deep) → wait → import-all
  └── Subagent 3: WebSearch → add article URLs → wait for indexing
Main agent: Once all ready → analyze + generate artifacts
```

Use the `--notebook <id>` flag on all commands so subagents don't conflict on context.

## Research Depth Levels

| Level | YouTube | Web Research | Articles | Best For |
|-------|---------|-------------|----------|----------|
| Quick | 5 videos | fast mode | skip | Quick overview, familiar topic |
| Standard | 10 videos | fast mode | 3-5 URLs | Most research tasks |
| Deep | 15-20 videos | deep mode | 5-10 URLs | Comprehensive analysis, new domain |

Default to **Standard**. Use **Deep** when user says "thorough", "comprehensive", or "deep dive".

## Tips

- **Diversity wins** — mixing YouTube + web articles + auto-research gives the richest analysis
- **Filter YouTube by views** — higher view count usually means better quality
- **Use WebSearch strategically** — search for "[topic] guide 2026" or "[topic] case study" to find written content YouTube doesn't cover
- **Deep research is async** — start it first, add YouTube/articles while it runs
- **Source limits** — Standard plan: 50 sources/notebook. Don't overshoot.
- **Save results** — `notebooklm ask "..." --save-as-note` preserves Q&A in the notebook

## Example Prompt

> /deep-research meta ad strategies 2026
>
> This will:
> 1. Create a NotebookLM notebook
> 2. Search YouTube for top 10 videos on meta ad strategies
> 3. Run deep web research via NotebookLM
> 4. Find 5 top articles/guides via WebSearch
> 5. Wait for all sources to index
> 6. Generate comprehensive analysis
> 7. Optionally create infographic/slides/podcast

## Credits

Workflow inspired by [Erik Lazar](https://www.youtube.com/@eriklazar). NotebookLM Python API by [teng-lin/notebooklm-py](https://github.com/teng-lin/notebooklm-py).
