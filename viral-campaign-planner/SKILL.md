---
name: viral-campaign-planner
description: Use when planning a viral / organic-distribution campaign for a mobile app, B2C product, or creator program. Triggers on "plan a viral campaign", "organic UA strategy", "UGC campaign plan", "scale creators", "TikTok/Reels/Shorts distribution plan", "layer paid on organic". Produces a phased plan with goals, KPIs, creator-ops setup, and scale roadmap based on the UGC Ninja Mobile App Organic Distribution Playbook.
---

# Viral Campaign Planner

Frame organic UGC as **top-of-funnel demand & awareness**, not a performance channel. No direct view→install attribution — judge by algo signals + business trend lines over weeks.

Source: UGC Ninja — Mobile App Organic Distribution Playbook (captured 2026-06-04). Full doc: `obsidian/03 - Resources/UGC Ninja - Mobile App Organic Distribution Playbook.md`.

---

## 1. Set the goal correctly

Pick the **one platform-native KPI** that maps to algo behavior:

| Platform | Primary KPI | Target |
|---|---|---|
| TikTok | Completion rate | 70%+ |
| Instagram Reels | ER by views/reach | 0.5%+ baseline |
| YouTube Shorts | VVSA | 70%+ (<60% = weak hook) |

Secondary algo signals: shares (0.5–2% good, 2%+ viral), saves (above account median), real-question comments, velocity to first milestones.

Off-platform business metrics (review every 1–2 weeks, never daily): branded search · category search uplift · organic installs · store-page views · revenue trend. Always log context: ASO changes, paid bursts, PR, seasonality.

---

## 2. Map the real funnel

`Views → Profile/Interest → Store Search → Store Page Visit → Install → Purchase`

Without **branded search + store traffic tracking**, the campaign feels broken even when it's working. Set those up before launch.

Decision rule: if platform signals improve WoW but search is flat → weak product anchoring, wrong GEO/intent, or store/landing not converting. Don't "post more random videos."

---

## 3. KPI & weekly decision tree

- **Scale** when key benchmark hits repeatedly → produce variations, more volume, more accounts.
- **Iterate** when signals are close (ER ok, retention drops) → rewrite first 1–2s, change opening frame, tighten pacing.
- **Kill** when underperforms across multiple attempts/accounts → add to do-not list.

Engine-health metrics (track weekly): posting volume · **median** views/video (not average) · winner density · distribution spread · GEO/format mix.

Validity filter: set a view floor (e.g. 1K or 10K) before counting a video as "valid." Set a minimum attempts threshold before killing a format.

---

## 4. Launch plan

**Day 0 pre-launch:**
- Do-Not rules (1 page): banned topics/visuals/claims, competitor rules, tone, strike risks.
- Reference pack: 5 good / 5 bad / 10–20 hooks.
- Tracking sheet: link, platform, date, format, views, engagement, key metric, status.

**Week 1 ramp:** breadth over perfection · multiple formats & hooks · speed > polish · **enforce rules via payment** (no payout = real feedback loop).

**Weeks 2–4 iteration loop:** review → decide (scale/iterate/kill) → update rules → ship new volume.

"We're live" = posting volume stable + Do-Not consistently followed + winners appearing + weekly iteration loop running.

---

## 5. Geo-targeted views (when needed)

- **Web farm** (AdsPower/Multilogin + residential proxies, Scamalytics <25): cheap, increasingly detected.
- **Mobile farm**: OpenWRT router + WireGuard/OpenVPN tunnel → all phones share one in-geo IP. One account per device.
- **Warm-up is non-negotiable**: 7–14 days (US = 14). Daily 20–30 min: watch local+niche fully, 3–8 likes, 1–3 real comments, 1–2 saves, follow 5–10 small accounts/week. Done when feed shifts to target geo+niche, comments look local, no rate limits.
- **Anti-ban**: 95%+ views from target geo, random pauses, no 24/7, rotate proxies weekly, scale gradually.

---

## 6. Scaling to 200+ creators

**Why 200+:** winner density becomes statistical (3,000+ videos/mo → weekly winners), CPM stabilizes, algo gets signal density.

**Creator-led model only** at scale: operator owns brief + Do-Not rules + approval + tracking; creator owns their account, idea-gen within brief, production, cadence.

**Ramp:** M1 pilot → M2–3 referrals kick in → M4–6 steady state 150–250 active creators.

**Retention economics:** never minimize per-video pay. Below creator's effective hourly minimum → churn → replacing churn becomes a full-time op problem. Pay = per-approved baseline (above creator alternatives) + visible winner bonus.

**Team functions:** brief writers · approval/moderation · performance analytics · payment ops. Two people cannot run 200+.

---

## 7. Volume math: 3,000+ videos/mo

200 × 15 = 150 × 20 = 100 × 30. ~15/mo per creator is sustainable; 20–30/mo only with templates.

**Track weekly, not monthly:** ~750 approved/week target · submitted→approved ratio · ~3–4 approved videos/creator/week at 200 scale.

**Real bottleneck = brief-writing throughput.** Multiple active briefs, refresh every 2–3 weeks. Slower = repetition; faster = creators can't learn.

**Format mix:** majority proven winners · slice iteration on near-winners · always-on minority for new exploration (prevents CPM climbing).

**5 bottlenecks at 3K/mo:** brief throughput · approval lag (>1 day kills quality) · payment cycle drift · feedback latency · recruit-to-churn inverting.

Sweet spot is **3K–4K/mo**. Past that, optimize **winner density per 1,000 videos**, not raw volume.

---

## 8. Layering paid on organic

Organic = discovery (cheap). Paid = amplification (only after discovery de-risked the creative).

CPM gap: Tier-1 Meta UA ≈ **$42 CPM** vs organic at scale ≈ **$6 CPM** → ~7× more usable impressions.

**Layer paid when:**
1. Promote organic winners via TikTok Spark Ads / Meta Partnership Ads (pre-validated creative).
2. GEO/segment expansion when organic under-indexes a target market.
3. Bottom-funnel retargeting on people who saw multiple organic videos (when branded search lifts but install CR lags).

**Don't:** top-of-funnel paid before organic baseline · paid on creative that didn't earn organic distribution · replacing organic with paid for "speed."

Composite $200k/mo example: ~70% organic ($140k → tens of millions impressions @ $6 CPM) + ~30% paid ($60k → low millions @ $42 CPM). Blended CPM materially below paid-only.

---

## Plan output template

When invoked, produce a campaign plan with these sections:

1. **Context snapshot** — product, geo, current organic baseline (if any), budget envelope.
2. **Primary KPI** — pick one per platform from §1.
3. **Funnel tracking setup** — what branded-search + store-traffic instrumentation must exist before Day 0 (§2).
4. **Day-0 artifacts** — Do-Not rules, reference pack, tracking sheet (§4).
5. **Creator ops** — recruitment channel, pay structure, approval SLA. Flag if scope <50 creators (pilot mode) vs ≥200 (engine mode, §6).
6. **Volume plan** — videos/week target, brief refresh cadence, format mix (§7).
7. **Weekly decision loop** — scale/iterate/kill thresholds tied to §3 metrics.
8. **Paid-layer trigger** — explicit condition under which paid kicks in (§8). Default: not before §4 "we're live" definition is met.
9. **Risks & bottlenecks** — flag any of the §7 five-bottleneck list that the current setup is exposed to.

---

## Operating rules (Melek's defaults)

1. **Scope** — Always ask up-front: pilot (<50 creators) or engine (200+)? Do not assume. §5 output adapts to the answer.
2. **Budget anchor** — Always close the plan with a composite CPM target (§8 format: ~70% organic / ~30% paid, blended CPM line), even for pilots. If no budget is provided, ask for one before producing the plan.
3. **Tone — mentor mode** — Before producing the plan, name (a) the weakest assumption in the inputs, (b) the blind spot, (c) the better alternative if one exists. Be direct, explain why, propose a fix. Then produce the plan.
4. **Obsidian write** — After producing the plan, auto-write it to `obsidian/01 - Projects/<campaign-slug>/viral-plan.md`. Ask only for the campaign slug if not obvious from context. Commit the submodule per CLAUDE.md workflow.
