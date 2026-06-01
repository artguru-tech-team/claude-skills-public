---
name: instagram-carousel-generator
description: Use when creating Instagram carousels as fully designed, export-ready HTML slides. Triggers on requests like "make a carousel about X", "create Instagram slides for Y", or when user provides brand details and wants visual content for Instagram.
visibility: public
---

# Instagram Carousel Generator

## Overview

Generate fully self-contained, swipeable HTML carousels where **every slide is designed to be exported as an individual image** for Instagram posting. Each slide includes a progress bar, swipe arrow, and brand-consistent design baked in.

---

## Step 1: Collect Brand Details

Before generating, ask the user for (if not already provided):

1. **Brand name** — displayed on first and last slides
2. **Instagram handle** — shown in IG frame header and caption
3. **Primary brand color** — hex code, or describe and pick one
4. **Logo** — SVG path, brand initial, or skip
5. **Font preference** — serif+sans (editorial), all sans (modern), or specific Google Fonts
6. **Tone** — professional, casual, playful, bold, minimal, etc.
7. **Images** — any images to include

If user provides a website URL, derive colors and style from it. If user says "make me a carousel about X" without brand details, ask before generating. Don't assume defaults.

---

## Step 2: Derive the Full Color System

From the user's **single primary brand color**, generate the full 6-token palette:

```
BRAND_PRIMARY = {user's color}          // Main accent — progress bar, icons, tags
BRAND_LIGHT   = {primary lightened ~20%} // Secondary accent — tags on dark, pills
BRAND_DARK    = {primary darkened ~30%}  // CTA text, gradient anchor
LIGHT_BG      = {warm or cool off-white} // Light slide background (never pure #fff)
LIGHT_BORDER  = {slightly darker than LIGHT_BG} // Dividers on light slides
DARK_BG       = {near-black with brand tint}    // Dark slide background
```

**Rules:**
- LIGHT_BG: tinted off-white complementing the primary (warm → warm cream, cool → cool gray-white)
- DARK_BG: near-black with subtle brand tint (warm → `#1A1918`, cool → `#0F172A`)
- LIGHT_BORDER: always ~1 shade darker than LIGHT_BG
- Brand gradient: `linear-gradient(165deg, BRAND_DARK 0%, BRAND_PRIMARY 50%, BRAND_LIGHT 100%)`

---

## Step 3: Typography

| Style | Heading Font | Body Font |
|-------|-------------|-----------|
| Editorial / premium | Playfair Display | DM Sans |
| Modern / clean | Plus Jakarta Sans 700 | Plus Jakarta Sans 400 |
| Warm / approachable | Lora | Nunito Sans |
| Technical / sharp | Space Grotesk | Space Grotesk |
| Bold / expressive | Fraunces | Outfit |
| Classic / trustworthy | Libre Baskerville | Work Sans |
| Rounded / friendly | Bricolage Grotesque | Bricolage Grotesque |

**Font size scale (fixed across all brands):**
- Headings: 28–34px, weight 600, letter-spacing -0.3 to -0.5px, line-height 1.1–1.15
- Body: 14px, weight 400, line-height 1.5–1.55
- Tags/labels: 10px, weight 600, letter-spacing 2px, uppercase
- Step numbers: heading font, 26px, weight 300
- Small text: 11–12px

Apply via CSS classes `.serif` (heading font) and `.sans` (body font).

---

## Slide Architecture

### Format
- Aspect ratio: **4:5** (Instagram carousel standard)
- Each slide is self-contained — all UI baked into the image
- Alternate LIGHT_BG and DARK_BG for visual rhythm

### Standard Slide Sequence (7 slides ideal, 5–10 flex)

| # | Type | Background | Purpose |
|---|------|------------|---------|
| 1 | Hero | LIGHT_BG | Hook — bold statement, logo lockup, optional watermark |
| 2 | Problem | DARK_BG | Pain point — what's broken or frustrating |
| 3 | Solution | Brand gradient | The answer — optional quote/prompt box |
| 4 | Features | LIGHT_BG | What you get — feature list with icons |
| 5 | Details | DARK_BG | Depth — customization, specs, differentiators |
| 6 | How-to | LIGHT_BG | Steps — numbered workflow or process |
| 7 | CTA | Brand gradient | Call to action — logo, tagline, CTA button. **No arrow. Full progress bar.** |

### Layout Rules
- Content padding: `0 36px` standard
- Bottom-aligned slides with progress bar: `0 36px 52px` to clear the bar
- Hero/CTA slides: `justify-content: center`
- Content-heavy slides: `justify-content: flex-end` (text at bottom, breathing room above)

---

## Required Elements on Every Slide

### 1. Progress Bar (bottom of every slide)

```javascript
function progressBar(index, total, isLightSlide) {
  const pct = ((index + 1) / total) * 100;
  const trackColor = isLightSlide ? 'rgba(0,0,0,0.08)' : 'rgba(255,255,255,0.12)';
  const fillColor = isLightSlide ? BRAND_PRIMARY : '#fff';
  const labelColor = isLightSlide ? 'rgba(0,0,0,0.3)' : 'rgba(255,255,255,0.4)';
  return `<div style="position:absolute;bottom:0;left:0;right:0;padding:16px 28px 20px;z-index:10;display:flex;align-items:center;gap:10px;">
    <div style="flex:1;height:3px;background:${trackColor};border-radius:2px;overflow:hidden;">
      <div style="height:100%;width:${pct}%;background:${fillColor};border-radius:2px;"></div>
    </div>
    <span style="font-size:11px;color:${labelColor};font-weight:500;">${index + 1}/${total}</span>
  </div>`;
}
```

### 2. Swipe Arrow (every slide EXCEPT last)

```javascript
function swipeArrow(isLightSlide) {
  const bg = isLightSlide ? 'rgba(0,0,0,0.06)' : 'rgba(255,255,255,0.08)';
  const stroke = isLightSlide ? 'rgba(0,0,0,0.25)' : 'rgba(255,255,255,0.35)';
  return `<div style="position:absolute;right:0;top:0;bottom:0;width:48px;z-index:9;display:flex;align-items:center;justify-content:center;background:linear-gradient(to right,transparent,${bg});">
    <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
      <path d="M9 6l6 6-6 6" stroke="${stroke}" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
  </div>`;
}
```

---

## Reusable Components

### Tag / Category Label
```html
<span class="sans" style="display:inline-block;font-size:10px;font-weight:600;letter-spacing:2px;color:{color};margin-bottom:16px;">{TAG TEXT}</span>
```
- Light slides: color = BRAND_PRIMARY
- Dark slides: color = BRAND_LIGHT
- Gradient slides: color = `rgba(255,255,255,0.6)`

### Strikethrough pills
```html
<span style="font-size:11px;padding:5px 12px;border:1px solid rgba(255,255,255,0.1);border-radius:20px;color:#6B6560;text-decoration:line-through;">{Old tool}</span>
```

### Tag pills
```html
<span style="font-size:11px;padding:5px 12px;background:rgba(255,255,255,0.06);border-radius:20px;color:{BRAND_LIGHT};">{Label}</span>
```

### Prompt / quote box
```html
<div style="padding:16px;background:rgba(0,0,0,0.15);border-radius:12px;border:1px solid rgba(255,255,255,0.08);">
  <p class="sans" style="font-size:13px;color:rgba(255,255,255,0.5);margin-bottom:6px;">{Label}</p>
  <p class="serif" style="font-size:15px;color:#fff;font-style:italic;line-height:1.4;">"{Quote text}"</p>
</div>
```

### Feature list row
```html
<div style="display:flex;align-items:flex-start;gap:14px;padding:10px 0;border-bottom:1px solid {LIGHT_BORDER};">
  <span style="color:{BRAND_PRIMARY};font-size:15px;width:18px;text-align:center;">{icon}</span>
  <div>
    <span class="sans" style="font-size:14px;font-weight:600;color:{DARK_BG};">{Label}</span>
    <span class="sans" style="font-size:12px;color:#8A8580;">{Description}</span>
  </div>
</div>
```

### Numbered steps
```html
<div style="display:flex;align-items:flex-start;gap:16px;padding:14px 0;border-bottom:1px solid {LIGHT_BORDER};">
  <span class="serif" style="font-size:26px;font-weight:300;color:{BRAND_PRIMARY};min-width:34px;line-height:1;">01</span>
  <div>
    <span class="sans" style="font-size:14px;font-weight:600;color:{DARK_BG};">{Step title}</span>
    <span class="sans" style="font-size:12px;color:#8A8580;">{Step description}</span>
  </div>
</div>
```

### CTA button (final slide only)
```html
<div style="display:inline-flex;align-items:center;gap:8px;padding:12px 28px;background:{LIGHT_BG};color:{BRAND_DARK};font-family:'{BODY_FONT}',sans-serif;font-weight:600;font-size:14px;border-radius:28px;">
  {CTA text}
</div>
```

### Logo lockup (first and last slides)
- If logo SVG: 40px circle (BRAND_PRIMARY bg) + icon centered, brand name beside it
- If initials: 40px circle with first letter in white
- Brand name: 13px, weight 600, letter-spacing 0.5px

### Watermark (optional)
If user provided a logo icon, use it as subtle background watermark on key slides (hero, CTA, brand gradient) at opacity 0.04–0.06.

---

## Instagram Frame (Preview Wrapper)

Wrap the carousel in an Instagram-style frame for chat preview:
- **Header:** Avatar (BRAND_PRIMARY circle + logo) + handle + subtitle
- **Viewport:** 4:5 aspect ratio, swipeable/draggable track with all slides
- **Dots:** Small dot indicators below viewport
- **Actions:** Heart, comment, share, bookmark SVG icons
- **Caption:** Handle + short description + "2 HOURS AGO" timestamp

Include pointer-based drag/swipe interaction for the preview. The slides themselves remain standalone export-ready images.

---

## Design Principles

1. **Every slide is export-ready** — arrow and progress bar are part of the slide image
2. **Light/dark alternation** — creates visual rhythm across swipes
3. **Heading + body font pairing** — display font for impact, body for readability
4. **Brand-derived palette** — all colors stem from one primary
5. **Progressive disclosure** — progress bar fills, arrow guides forward
6. **Last slide is special** — no arrow, full progress bar, clear CTA
7. **Consistent components** — same tag style, list style, spacing across all slides
8. **Content padding clears UI** — body text never overlaps progress bar or arrow

---

## Example Prompts

- "Create a carousel about the top 5 mistakes people make when starting a business"
- "Generate a carousel explaining what Claude AI can do for marketers"
- "Make a carousel for my product launch — here's our website: [url]"
- "Turn this blog post into a carousel: [paste post]"

## Pro Tips

- Include your hex code — even a rough one. Claude builds an entire color system from it.
- Include images you want inside the carousel.
- Give your website URL — Claude pulls brand colors and style automatically.
- To redo a slide: "redo slide 3 with a darker background and shorter headline"
- To change vibe: "make it more minimal" or "go bolder on the typography"
