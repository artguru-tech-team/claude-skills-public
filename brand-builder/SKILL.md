---
name: brand-builder
description: Use when building a complete brand identity for a new or existing brand — brand strategy, voice document, moodboard, logo concepts, color palette, and full AI-ready brand kit. Triggers on "build my brand", "create brand identity", "brand guidelines", "brand kit", or when a project needs visual + copy foundations from scratch.
visibility: public
---

# Brand Builder

Interactive skill that builds a complete brand identity from scratch, with human approval gates before finalizing visuals and documentation.

## Output Structure

```
brand-kit/[brand-name]/
  01-strategy/
    brand-dna.md          # values, positioning, archetype
    brand-voice.md        # AI-ready voice document
  02-visuals/
    moodboard/            # 4 generated mood images + combined overview
    logos/                # 3 concept directions, approved variations
    colors/               # palette.png + palette.json
  03-guidelines/
    visual-guidelines.md
    illustration-prompts.md
  04-ai-ready/
    master-copy-prompt.md
    master-illustration-prompt.md
```

---

## PHASE 1 — Discovery (ask all at once)

Ask the human these questions in a single message. Format as a numbered list.

```
1. Brand name (and tagline if exists)
2. What it does — one sentence, no jargon
3. Target audience — who are they, mindset, age range
4. 3 words that describe the desired vibe/feeling
5. Main competitor(s) — to position AGAINST
6. Color direction — any preferences or hard avoids?
7. Tone — pick one: [Corporate / Professional / Friendly / Casual / Edgy / Underground / Playful / Serious]
8. Industry / category
9. Any existing assets? (logo, colors, fonts — yes/no)
```

Do NOT proceed to Phase 2 until all 9 answers are received.

---

## PHASE 2 — Strategy Generation (auto, no approval needed)

Generate and save `01-strategy/brand-dna.md`:

### Brand DNA Template

```markdown
# [Brand Name] — Brand DNA

## Positioning
[One sentence: We help [audience] [achieve X] unlike [competitor] who [does Y]]

## Archetype
[Choose one: Innocent / Explorer / Sage / Hero / Outlaw / Magician / Regular Guy / Lover / Jester / Caregiver / Creator / Ruler]
[One sentence explaining why this archetype fits]

## Core Values (4)
1. **[Value]** — [What this means in practice for this brand]
2. **[Value]** — [What this means in practice for this brand]
3. **[Value]** — [What this means in practice for this brand]
4. **[Value]** — [What this means in practice for this brand]

## Brand Personality
- [Adjective]: [What this means — e.g., "Bold: We say what others won't"]
- [Adjective]: [...]
- [Adjective]: [...]

## Customer Profile
**Who:** [Demographics + mindset]
**They want:** [Core desire]
**They fear:** [Core anxiety]
**Decision driver:** [What makes them choose]
```

---

## PHASE 3 — Moodboard Generation

### Step 1: Generate 4 moodboard images

Use Replicate (Flux 1.1 Pro) as default. Fallback: DALL-E 3.

**Replicate CLI:**
```bash
python -c "
import replicate, base64, os
prompts = [
  '$PROMPT_1',
  '$PROMPT_2',
  '$PROMPT_3',
  '$PROMPT_4',
]
os.makedirs('brand-kit/$BRAND/02-visuals/moodboard', exist_ok=True)
for i, prompt in enumerate(prompts):
    output = replicate.run('black-forest-labs/flux-1.1-pro', input={'prompt': prompt, 'aspect_ratio': '4:5'})
    with open(f'brand-kit/$BRAND/02-visuals/moodboard/mood-{i+1}.png', 'wb') as f:
        f.write(output.read())
    print(f'Saved mood-{i+1}.png')
"
```

**How to write the 4 moodboard prompts** — each image represents a different facet of the brand:

| Image | What to capture |
|-------|----------------|
| mood-1 | The emotional world / lifestyle of target audience |
| mood-2 | The brand's core product/service in ideal context |
| mood-3 | Texture, material, and environmental aesthetic |
| mood-4 | Color palette + light treatment + spatial mood |

**Prompt formula per image:**
```
[Specific scene], [brand adjectives], [material/texture], [lighting cheat code], [color palette description], editorial photography, no text, no logos
```

**Lighting cheat codes by tone:**
- Underground/edgy → "harsh neon backlight, deep shadows, grain"
- Warm/human → "golden hour window light, soft diffusion, 35mm film"
- Clean/professional → "studio softbox, white seamless, product photography"
- Luxury → "Leica M6, available light, minimal grain, muted tones"
- Playful → "Polaroid wash, saturated pastels, flat lay"

### Step 2: HUMAN APPROVAL GATE — Moodboard

Show all 4 images and ask:

```
Here are 4 moodboard images for [Brand Name].

[image 1] [image 2] [image 3] [image 4]

Direction: ✅ approved / ❌ redo [which ones + why] / 🔄 adjust [what to change]
```

Do NOT proceed to Phase 4 until approved.

---

## PHASE 4 — Logo Concept Generation

### Step 1: Generate 3 logo directions

Use **Ideogram v2** for logo concepts (best for text rendering + design).

**Ideogram via API or ideogram.ai browser:**

Generate 3 distinct visual directions:

| Concept | Style direction |
|---------|----------------|
| A — Wordmark | Clean typographic logo, custom letterforms, no icon |
| B — Icon + Text | Symbol/icon paired with brand name |
| C — Abstract mark | Geometric or abstract logomark, minimal |

**Logo prompt formula:**
```
Professional logo design for "[BRAND NAME]", [STYLE], [PERSONALITY ADJECTIVES], [COLOR PALETTE], clean vector style, white background, no gradients, no shadows, centered composition
```

**Example prompts:**
```
# Concept A
Professional wordmark logo for "Bakchich", bold geometric sans-serif, underground and trustworthy, deep navy and warm gold, white background, centered, no icons, clean vector

# Concept B
Professional logo with icon for "Bakchich", abstract geometric B symbol paired with clean text, modern and bold, deep navy #1a2744 and gold #d4a843, white background, vector style

# Concept C
Minimal abstract logomark for "Bakchich", geometric shape representing exchange/connection, single color deep navy, ultra-minimal, white background, scalable icon
```

### Step 2: Generate variations of each concept

For each concept: generate light version + dark version
```bash
# After approval of concept direction, generate:
# primary (on white), reversed (white on dark), icon-only, horizontal lockup
```

### Step 3: HUMAN APPROVAL GATE — Logo Concepts

```
Here are 3 logo concept directions for [Brand Name].

[Concept A — Wordmark]
[Concept B — Icon + Text]  
[Concept C — Abstract Mark]

Which direction(s) to develop? A / B / C / A+B / other feedback
```

Do NOT proceed to Phase 5 until direction chosen.

---

## PHASE 5 — Color Palette

Derive from approved moodboard. Extract dominant + accent colors.

### Palette structure

| Role | Count | How to pick |
|------|-------|-------------|
| Primary | 1 | Most prominent from moodboard, matches archetype |
| Secondary | 1 | Supports primary, creates contrast |
| Accent | 1 | Energy/CTA color, punchy |
| Neutral dark | 1 | For text on light backgrounds |
| Neutral light | 1 | For backgrounds, cards |

Save as `02-visuals/colors/palette.json`:
```json
{
  "primary": "#HEX",
  "secondary": "#HEX",
  "accent": "#HEX",
  "neutral_dark": "#HEX",
  "neutral_light": "#HEX",
  "usage": {
    "primary": "headlines, key UI, logo",
    "secondary": "supporting elements, subheadings",
    "accent": "CTAs, highlights, links",
    "neutral_dark": "body text",
    "neutral_light": "backgrounds, containers"
  }
}
```

Generate a palette visualization image showing all 5 swatches with hex codes.

### HUMAN APPROVAL GATE — Colors

```
Proposed color palette for [Brand Name]:

[palette visualization]

Primary: [name] [hex]
Secondary: [name] [hex]
Accent: [name] [hex]

Approve / adjust [which + new direction]?
```

---

## PHASE 6 — Documentation Assembly

Once all visuals approved, generate the final 4 docs:

### 1. `01-strategy/brand-voice.md` — AI-Ready Voice Document

```markdown
# [Brand Name] — Brand Voice Document (AI-Ready)

## Role
You are a [ROLE] for [Brand Name], a [description] serving [audience].

## Voice Snapshot
- **[Adjective 1]:** [What this means — e.g., "Bold: Say it once, clearly. No hedging."]
- **[Adjective 2]:** [...]
- **[Adjective 3]:** [...]

## Writing Rules
- Tone: [formal/casual scale description]
- POV: Second person ("you")
- Sentence max: [X] words
- Contractions: yes/no
- Oxford comma: yes/no

## Vocabulary
**Always use:** [signature terms, brand phrases]
**Never use:** [banned words, AI clichés: "unlock", "leverage", "dive into", "skyrocket", "In a world where", "game-changing"]

## Situational Shifts
- Marketing/sales: [tone description]
- Customer support: [tone description]
- Crisis/complaints: [tone description]

## Gold Standard Examples (copy these patterns)
1. "[Best performing past copy example]"
2. "[Another example]"
3. "[Another example]"
```

### 2. `03-guidelines/visual-guidelines.md`

Cover: logo usage rules, color usage, typography recommendations, spacing, do's/don'ts.

### 3. `04-ai-ready/master-copy-prompt.md`

Pre-filled master prompt template using brand voice doc. Ready to paste into any AI tool.

### 4. `04-ai-ready/master-illustration-prompt.md`

Brand illustration prompt skeleton with:
- Approved color hex codes filled in
- Moodboard reference URLs as `--sref` examples
- Style code / personalization hints
- Banned elements list

---

## PHASE 7 — Final Kit Delivery

```
Brand kit for [Brand Name] is complete.

📁 brand-kit/[brand-name]/
  ✅ Brand DNA + Positioning
  ✅ AI-Ready Voice Document
  ✅ Moodboard (4 images)
  ✅ Logo Concepts ([A/B/C] direction)
  ✅ Color Palette (5 colors)
  ✅ Visual Guidelines
  ✅ Master Copy Prompt
  ✅ Master Illustration Prompt

Next steps:
- Refine logos in Figma/Illustrator using AI concepts as reference
- Run /writing-humanizer on all copy before publishing
- Use master-illustration-prompt.md as base for all future AI visuals
```

---

## Tools & Fallbacks

| Task | Primary tool | Fallback |
|------|-------------|---------|
| Moodboard images | Replicate Flux 1.1 Pro (`pip install replicate`) | DALL-E 3 via OpenAI API |
| Logo concepts | Ideogram v2 (browser or API) | DALL-E 3 with "logo design" prompt |
| Color extraction | Python `colorthief` or manual from moodboard | eyedrop from generated images |
| Documents | Claude (inline generation) | — |

**Replicate setup:**
```bash
pip install replicate
export REPLICATE_API_TOKEN=your_token
```

**DALL-E 3 fallback:**
```python
from openai import OpenAI
client = OpenAI()
response = client.images.generate(model="dall-e-3", prompt=PROMPT, size="1024x1024", quality="standard")
```

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Skipping discovery, assuming brand details | Always run Phase 1 first, all 9 questions |
| Generating logos before moodboard approved | Moodboard defines visual direction — always first |
| Using generic Midjourney prompts | Use lighting cheat codes + specific hex colors in prompts |
| Brand voice doc too vague ("be friendly") | Every adjective needs a "what this means" sentence |
| Skipping approval gates to save time | Human must approve moodboard + logos before proceeding |
| Forgetting to run /writing-humanizer | All generated copy must pass humanizer before use |
