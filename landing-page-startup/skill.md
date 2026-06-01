---
name: landing-page-startup
description: Use when building, auditing, or reviewing a startup landing page. Covers hero copywriting formulas, top-to-bottom section order, design tokens, trust signal hierarchy by growth stage, CTA playbook, tool recommendations, A/B testing, and analytics. Trigger on "landing page", "homepage", "conversion rate", "hero section", "above the fold", "CTA copy", or /landing-page-startup. Based on 18-source deep research (NotebookLM 082aa882, April 2026).
user_invocable: true
arguments: startup name, target audience (brands/creators/B2B/B2C), current growth stage (pre-launch/early/scaling)
visibility: public
---

# Startup Landing Page Playbook

A complete, research-backed system for building high-converting startup landing pages. Based on 18 sources (YouTube: Hormozi, Priestley, Wes McDowell, HubSpot + articles: Julian Shapiro, Unbounce, Stripe Atlas, Userpilot). April 2026.

**For copywriting refinement:** use `writing-humanizer` skill before finalizing any copy.
**For dual-audience platforms (brand + creator):** always build two separate pages, not one.

---

## The 5-Second Test (Do This First)

A visitor must answer 4 questions in 5 seconds — if they can't, your conversion rate will suffer no matter what else you do:

1. **Who is this for?**
2. **What does it do?**
3. **Why should I care?**
4. **What do I click?**

**Self-test:** Cover your logo. Read only the headline. Does it still explain the product? If not, rewrite it.

> 60% of visitors never scroll past the fold. Almost all conversion wins happen in the first viewport.

---

## Page Section Order (Top → Bottom)

Structure your page in this exact sequence — each section earns the next scroll:

```
1. HERO (above fold)          — headline + sub-headline + CTA + one trust cue + visual
2. PROBLEM / OUTCOME          — 2-3 bullets: pain point → promised result
3. SOLUTION SNAPSHOT          — one feature cluster + visual proof (screenshot/GIF)
4. SOCIAL PROOF SANDWICH      — quote, metric, or "as seen in" logos
5. SECONDARY CTA              — alternative for non-buyers ("watch 60-sec demo")
6. HOW IT WORKS               — 3-step numbered process
7. PRICING / CAMPAIGN MODELS  — anchor with comparison if possible
8. OBJECTION / FAQ            — 1-3 biggest objections, one sentence each
9. FOOTER CTA                 — repeat primary CTA + micro-copy
10. FOOTER                    — terms, privacy, minimal links only
```

**Rule:** Remove the navigation menu from dedicated landing pages. Every extra link is an exit point.

---

## Copywriting Formulas (Fill-in-the-Blank)

### Hero Value Prop
```
[Who you help] + [Pain you solve] + [Outcome]
```
Example: "For growth teams. Launch your creator program and pay only for real video views — zero wasted budget."

### Feature → Benefit
```
Get [Benefit]. With [Feature that delivers it].
```

### Objection Buster
```
[Bold claim] even if [objection they're thinking].
```
Example: "Start earning even if you have zero followers."

### Pros Without Cons
```
What if you could [achieve X] without [painful trade-off]?
```

### AIDA Framework (for longer copy)
- **Attention** — hook (statistic, question, bold claim)
- **Interest** — peak curiosity (what's possible)
- **Desire** — show the outcome they want
- **Action** — single, clear CTA

### CTA Copy Rules
| Never use | Use instead |
|-----------|-------------|
| "Learn more" | "See it in action" |
| "Click here" | "Browse campaigns" |
| "Get started" | "Launch your program" |
| "Contact us" | "Book a 15-min teardown" |
| "Sign up" | "Create your account — free" |

### Micro-Copy Under CTAs
Always add one line directly under the button. Options:
- "No credit card required"
- "First campaign live in 24h"
- "No minimum budget"
- "No followers required. Ever."
- "Setup takes 10 minutes"

---

## Trust Signal Hierarchy (By Growth Stage)

Add trust signals in this order as you grow. Don't fake it — start where you actually are.

### Stage 0 — Zero Customers
- Founder video (30-45 sec, phone camera is fine — authenticity > polish)
- Integration partner logos (borrow credibility from tools you connect to)
- Risk reversal under CTA: "No credit card. Cancel anytime."
- Metric promises: "weekly payouts", "setup in 10 min"

### Stage 1 — Early Traction (1-50 customers)
- Tiny specific metrics: "€400K+ paid out", "127 campaigns", "1,500+ creators"
- Third-party review badge (Google, Trustpilot, G2, Product Hunt)
- Press mentions: "As seen in..." (even niche blogs count)

### Stage 2 — Scaling (50+ customers)
- Customer quotes with real headshots and job titles
- Video testimonials — the #1 trust lever, can nearly double conversion rate
- Named case study: "DTC brand sourced 400 UGC videos in 2 weeks for €1,800"

**Reframing tip:** "1,500+ creators" → "join 1,500+ creators already earning every week" — same number, 3x more compelling.

**Hidden bombshell pattern:** If you have a standout claim (e.g., "0% platform fee"), don't bury it in a stats bar. Give it a callout box or put it in the hero sub-headline.

---

## Design Tokens

### Colors
- **Background:** Dark (`#000` or deep navy) = premium feel; light = approachable/SaaS
- **CTA accent:** ONE high-contrast color for ALL primary buttons — never vary it
  - Electric yellow (`#F5F500`) = bold, creator-economy energy
  - Vibrant blue or purple = trust, SaaS default
- **Text:** White on dark backgrounds; black on light

### Typography
- **Headline:** Large, bold, left-aligned (not centered — left converts better on desktop)
- **Body:** Max 60-70 characters per line for readability
- **All-lowercase:** Edgy brand voice — use for creator-facing copy; avoid for B2B buyers (reduces perceived trust)
- **Monospace** (Space Mono, IBM Plex Mono): Tech/authentic feel, strong for developer or creator tools

### Spacing & Texture
- Generous whitespace = reduces cognitive load (especially for complex SaaS)
- Grain texture overlay (5-8% opacity) = tactile, analog, premium feel
- Grid lines for visual rhythm in feature/pricing sections
- Reading pattern: F-pattern (scan headlines left → body right) or Z-pattern

### Mobile Rules
| Rule | Spec |
|------|------|
| CTA tap target | Min 44px height |
| First viewport | CTA must be visible without scrolling |
| Dense sections | Collapse into accordion/FAQ |
| Image layout | Horizontal carousels, not vertical stacks |
| Input font size | Min 16px (prevents iOS auto-zoom) |
| Load time | Under 3 seconds (bounce rate +70% beyond 1s) |

---

## CTA Playbook

- **One primary CTA** per page — don't split attention above the fold
- **Sticky CTA bar** on desktop: follows scroll, always visible
- **Dual-audience fork:** If you serve two segments (e.g., brands + creators), present two distinct CTAs: `"For Brands →"` / `"For Creators →"` — and lead to separate pages
- **Hover state upgrade:** Show the benefit, not just the action. `"i create content → earn per view"` beats `"i create content"` alone
- **Color consistency:** Primary CTA = same color, every time, every section

---

## Tech Stack by Stage

| Stage | Tool | Why |
|-------|------|-----|
| Pre-launch waitlist | Carrd | Live in 1 hour, free |
| MVP landing page | Framer | Fast, flexible, no dev required |
| Marketing site + CMS | Webflow | Scale with blog, dynamic content |
| A/B testing focused | Unbounce / Landingi | Built-in split testing + drag-drop |
| Heatmaps + behavior | Microsoft Clarity | Free, session recordings, heatmaps |
| Event tracking + A/B | PostHog | Open source, good for low traffic |

---

## Performance & Analytics

### Speed
- First meaningful content: <3s on mobile
- Hero image/GIF: keep under weight limit for fast LCP (Largest Contentful Paint)
- Remove: intrusive popups, heavy scripts, full navigation menus

### Events to Track (Minimum Viable Analytics)
| Event | Why |
|-------|-----|
| Primary CTA click | Core conversion signal |
| Form submission | Lead captured |
| Scroll depth (50%, 75%, 100%) | Understand drop-off |
| Time on page | Engagement quality |
| Traffic source | Which channels convert |
| Video play (if any) | Demo/testimonial engagement |

### A/B Testing Rules
- Run **one test per week** — testing multiple things simultaneously kills signal clarity
- **90% of tests:** Focus on headline text or hero image — that's where 90% of gains are
- **Minimum traffic:** 1,000 visitors per variant before drawing conclusions
- **Low traffic (<1K/mo):** Skip A/B testing — use Clarity heatmaps and session recordings instead
- Each test needs a hypothesis: "Changing X will improve Y because Z"

---

## Common Mistakes Checklist

Before publishing, check every item:

- [ ] "We-focused" copy ("We offer...") → flip to "you" framing
- [ ] Clever vague tagline that doesn't explain what the product does
- [ ] Navigation menu on a landing page (every link = exit point)
- [ ] Features listed instead of benefits ("automated payouts" → "save 10h/week on creator payments")
- [ ] Single page for two distinct audiences — build separate pages
- [ ] Social proof only at the bottom — move metrics/logos above the fold
- [ ] CTA button color blends into the page background
- [ ] No micro-copy under the CTA button
- [ ] Pricing shown with no anchor comparison (arbitrary price = high friction)
- [ ] No FAQ / objection handling section
- [ ] Stats presented as raw numbers without context ("1,500 creators" → "join 1,500 creators already earning weekly")
- [ ] Industry jargon in hero copy targeting non-specialist buyers
- [ ] "0% fee" or other bombshell claims buried in stats bar — surface them

---

## Dual-Audience Platform Pattern

For marketplaces/platforms serving two sides (brand + creator, buyer + seller):

```
Homepage: Fork immediately
  → Provocative shared tagline (what the platform IS)
  → Two audience panels: "For [Audience A]" / "For [Audience B]"
  → Each panel leads to a SEPARATE dedicated page

Brand page:
  → Hero speaks to brand buyer's insight/pain
  → Comparison vs alternatives (anchor pricing)
  → Process: brief → approve → pay per result
  → Trust: brand-side logos, campaigns run, fraud detection

Creator page:
  → Hero speaks to creator's identity/aspiration
  → Stats: payouts, creator count, payout frequency
  → Process: browse → post → get paid automatically
  → Trust: "0% fee", escrow explained in plain language, progression path
```

---

## Source

Research notebook: NotebookLM `082aa882-e56a-4e3d-9977-14e540d5cff7`

**18 sources indexed (April 2026):**
- YouTube: Daniel Priestley, Wes McDowell, Alex Hormozi (x2), Alex Fedotoff, HubSpot Marketing, Exposure Ninja, Greg Isenberg, Gerrid Smith, Justin Jackson
- Articles: Julian Shapiro (julian.com), Unbounce, Landingi, Poweredbysearch, Userpilot, Stripe Atlas, Geeks for Growth, Maven

To ask follow-up questions:
```bash
python -m notebooklm ask "your question" --notebook 082aa882-e56a-4e3d-9977-14e540d5cff7
```
