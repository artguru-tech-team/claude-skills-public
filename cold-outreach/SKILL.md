---
name: cold-outreach
description: Use when planning cold outreach campaigns, LinkedIn prospecting sequences, multichannel outreach architecture, or signal-based targeting. Covers LinkedIn + email sequencing, profile optimization, cadence design, deliverability, and campaign benchmarks. Also use when reviewing or optimizing existing outreach campaigns.
visibility: public
---

# Cold Outreach Strategy & Architecture

Complete playbook for B2B cold outreach combining LinkedIn and email. Based on 300+ sources analyzed in April 2026 (NotebookLM notebook `f74397b7`).

**For email copywriting:** Use `cold-email` skill (frameworks, subject lines, CTAs, follow-ups).
**For copy refinement:** Use `josh-braun-copywriting` skill (5 principles, personalization).
**This skill covers:** Campaign architecture, LinkedIn tactics, multichannel sequencing, signal-based targeting, deliverability, benchmarks.

---

## Signal-Based Targeting (Do This First)

Stop targeting by job title alone. Target by **buying signals**:

| Signal | Why It Works | Timing |
|--------|-------------|--------|
| Leadership change | New execs spend 70% of budget in first 100 days | Within 30 days of hire |
| Funding round | 71% finalize vendors within 90 days | Within 60 days |
| Hiring surge | Indicates operational pain + budget | Active postings |
| Tech stack change | Migration = budget allocated | During transition |
| Company news | Expansion, acquisition, rebrand | Within 2 weeks |

**Stack signals**: "VP of Sales whose company just raised Series B and hired 12 SDRs" > "VP of Sales"

Tools for signal detection: LinkedIn Sales Navigator, Clay, Builtwith, Crunchbase, Google Alerts.

---

## LinkedIn Outreach

### Profile Optimization (Your Landing Page)

- **Headline**: Value-driven, not job title. "Helping SaaS CTOs Cut Onboarding Time by 50%" > "Sales Manager at Acme"
- **About**: First-person, Pain-to-Benefit framework. Hook with their biggest challenge, follow with quantified proof
- **Featured**: Pin 45-sec screen recordings, case study PDFs, slide decks
- **Banner**: Clear value prop or social proof

### Connection Requests

- **Blank request** gets 3-5% higher acceptance than generic pitch note
- **Only add note** if highly personalized: specific post they wrote, mutual connection, recent event
- Personalized notes boost acceptance up to 58% — but must NOT contain a pitch

### LinkedIn Message Sequence (7-Day)

| Day | Action | Purpose |
|-----|--------|---------|
| 1 | Blank connection request | Low-friction entry |
| 3 | Engage their content (like + thoughtful comment) | Build familiarity |
| 5 | Personalized voice note or message with image | Stand out |
| 7 | Brief follow-up message | Close the loop |

### Content-First Approach (Pre-Warming)

Post daily → monitor who engages → engage their content → THEN connect/message. Prospect recognizes your name before any outreach. Significantly higher acceptance and reply rates vs cold-cold.

---

## Multichannel Sequencing (LinkedIn + Email)

### Why Multichannel

- **40% higher engagement** than single-channel
- **3x better conversion rates**
- LinkedIn builds credibility; email delivers detail at scale

### Channel Order: LinkedIn First

LinkedIn profile view/engagement before cold email = name recognition in inbox. Exception: if you have a very strong email signal (e.g., they downloaded your content), lead with email.

### 14-Day Multichannel Cadence (8-12 Touchpoints)

| Day | Channel | Action |
|-----|---------|--------|
| 1 | LinkedIn + Email | Profile visit + signal-anchored cold email |
| 3-4 | LinkedIn + Email | Connection request (personalized note) + Email #2 (fresh insight) |
| 6-7 | Phone + LinkedIn | Call attempt (reference email) + comment on their post |
| 8-10 | Email or LinkedIn | Email #3 (case study/social proof) OR LinkedIn voice note |
| 12-14 | Email | Break-up email (leave door open) |

### Follow-Up Rules

- Each touchpoint adds NEW value (different angle, proof, resource)
- Never "just checking in" or "bumping this up"
- Each email stands alone (assume they didn't read previous)
- Break-up email is final — honor it

---

## Cold Email Architecture

### Optimal Format

- **Length**: 50-125 words (under 80 is sweet spot)
- **Structure**: Context (1-2 sentences) → Value (1-2 sentences) → Ask (1 sentence)
- **Format**: Plain text, short paragraphs, 6th-grade reading level, max 6 sentences
- **Subject**: 3-7 words, lowercase, looks internal ("reply rates", "Q2 forecast")

### Personalization That Scales

Don't just swap `{FirstName}`. Use AI to:
1. Research signals (earnings, LinkedIn posts, job boards, tech stack)
2. Generate ONE personalized sentence (2-8 words) connecting signal to their problem
3. Let that sentence lead naturally into your value prop

"Teams your size often struggle with X once they pass Y stage" > "Saw you're the Head of RevOps"

### CTA: Low-Friction Only

| Bad (high friction) | Good (low friction) |
|----|----|
| "Book a 30-min call" | "Worth a quick look?" |
| "When are you free this week?" | "Is this a current focus for your team?" |
| "Let me show you a demo" | "Can I send a 2-min video?" |

---

## Deliverability (Non-Negotiable)

Technical infra is now the #1 variable in campaign performance. Great copy in spam = zero results.

### Must-Haves

- **Authentication**: SPF + DKIM + DMARC on all sending domains
- **Domain warming**: 2-4 weeks before any outreach campaign
- **Inbox rotation**: Multiple mailboxes per domain, rotate sending
- **Volume limits**: 50-100 emails/day per mailbox max
- **Bounce rate**: Keep under 2% (use email validation tools)
- **Monitoring**: Google Postmaster Tools daily

### What Kills Deliverability

- Spam words: "Free", "Guaranteed", "Act Now"
- Fake "RE:" or "FW:" subject lines (actively penalized)
- HTML-heavy emails, images, multiple links
- High bounce rates from bad lists
- Sending too much too fast from new domains

---

## Benchmarks (2025-2026)

| Metric | Poor | Average | Good | Signal-Based |
|--------|------|---------|------|-------------|
| Open rate | <30% | 35-45% | 45-55% | (inflated by Apple MPP) |
| Reply rate | <2% | 3-5% | 8-12% | 15-40% |
| LinkedIn acceptance | <20% | 30% | 45-55% | with pre-warming |
| Email → meeting | <1% | 2.5% | 4%+ | 6.7-15% |

### What to Measure (Focus Here)

1. **Positive reply rate** (not just any reply)
2. **Meetings booked**
3. **Pipeline generated**

Stop obsessing over open rates (inflated 30-50% by Apple MPP). Only useful to detect deliverability failures (<30%).

### A/B Testing

- Test ONE element at a time (subject vs subject, CTA vs CTA)
- For discovering new winning audiences: test different offers/lead magnets with same subject line
- Minimum 100 sends per variant for statistical significance

---

## What's Dead in 2026

- Spray-and-pray high volume (leads to account bans, <2% reply)
- Generic `{FirstName}` only personalization
- Pitch slapping (pitching in connection note or first email)
- Feature dumps instead of problem-solving
- "I hope this email finds you well"
- ALL CAPS subjects, fake urgency, emojis in subjects

---

## Campaign Launch Checklist

1. [ ] Define ICP + buying signals to monitor
2. [ ] Set up signal detection (Sales Nav, Clay, alerts)
3. [ ] Optimize LinkedIn profile (headline, about, featured)
4. [ ] Prepare sending infrastructure (domains, SPF/DKIM/DMARC, warming)
5. [ ] Write email sequence using `cold-email` skill (3-5 emails)
6. [ ] Design multichannel cadence (LinkedIn + email + optional phone)
7. [ ] Run copy through `writing-humanizer` before launch
8. [ ] Validate email list (bounce rate <2%)
9. [ ] Set daily volume limits (50-100/mailbox)
10. [ ] Launch, monitor deliverability daily, A/B test weekly

---

## Related Skills

| Skill | Use For |
|-------|---------|
| `cold-email` | Email copywriting, frameworks, subject lines, CTAs |
| `josh-braun-copywriting` | Copy refinement, 5 principles, personalization |
| `writing-humanizer` | Remove AI-sounding patterns before sending |
| `clip2earn-brand` | Clip2Earn-specific voice and messaging |
| `content-creator` | LinkedIn content for pre-warming strategy |

## Source

Research notebook: NotebookLM `f74397b7-6543-4b7b-8244-e29d8950e2bf` (300 sources: 12 YouTube videos, 10 articles, deep web research). April 2026.
