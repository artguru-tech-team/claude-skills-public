---
name: amplitude-measurement-plan
description: Amplitude measurement plan for a B2B two-sided marketplace.
visibility: public
---

# Amplitude Measurement Plan — B2B Two-Sided Marketplace

Use this skill when building, auditing, or improving an Amplitude analytics setup for a B2B marketplace SaaS with two user types (supply/demand, creators/brands, sellers/buyers).

**Trigger phrases:** "measurement plan", "amplitude setup", "what to track", "events to instrument", "build dashboard", "analytics for clip2earn", "track marketplace", "cohort analysis", "retention diagnosis"

---

## Context: What Kind of Product This Covers

- **Two-sided marketplace:** supply side (creators/sellers) + demand side (brands/buyers)
- **B2B on the demand side:** brands are companies with multiple employees → requires Account-level tracking (Group Analytics)
- **B2C on the supply side:** creators are individuals → standard user-level tracking
- **Core value exchange:** brand launches program → creator submits content → brand approves → creator gets paid
- **North Star:** Marketplace Liquidity = supply successfully meeting demand

---

## Part 1 — Event Taxonomy & Tracking Plan

### Naming Conventions

| Layer | Format | Example |
|-------|--------|---------|
| Event names | `Object + Past-Tense Verb` in Title Case | `Program Launched`, `Content Submitted` |
| Event properties | `snake_case` | `payment_method`, `content_type` |
| User properties | `snake_case` | `user_type`, `acquisition_channel` |
| Group properties | `snake_case` | `company_id`, `industry`, `plan_name` |

**Rules:**
- Past tense = action completed successfully (not attempted)
- One broad event + properties > many specific events (avoid event bloat)
- Never track PII as event properties (emails, passwords, card numbers)

---

### Supply Side Events (Creators)

| # | Event Name | Key Properties | User Properties Set |
|---|-----------|---------------|-------------------|
| 1 | `Account Created` | `signup_method` (email/Google/Apple) | `user_type=creator`, `acquisition_channel`, `country` |
| 2 | `Onboarding Tutorial Completed` | `tutorial_duration_seconds`, `skipped_steps` | — |
| 3 | `Account Profile Updated` | `fields_completed[]`, `portfolio_linked` (bool) | `profile_completion_percentage` |
| 4 | `Program Viewed` | `program_id`, `brand_id`, `payout_offered`, `content_format` | — |
| 5 | `Program Applied` | `program_id`, `brand_id` | — |
| 6 | `Content Submitted` ⭐ | `program_id`, `content_format`, `file_size_mb`, `upload_duration_seconds` | — |
| 7 | `Content Approved` | `program_id`, `brand_id`, `payout_amount` | — |
| 8 | `Payout Received` | `payout_amount`, `payout_method`, `currency` | `lifetime_earnings` (increment) |

**⭐ = critical activation + liquidity event**

---

### Demand Side Events (Brands)

| # | Event Name | Key Properties | Properties Set |
|---|-----------|---------------|---------------|
| 1 | `Account Created` | `signup_method` | `user_type=brand`, `acquisition_channel`; Group: `company_id`, `industry`, `company_size` |
| 2 | `Program Drafted` | `program_category`, `requested_format`, `budget_allocated` | — |
| 3 | `Program Launched` ⭐ | `program_id`, `total_budget`, `creators_requested` | — |
| 4 | `Creator Application Reviewed` | `creator_id`, `action_taken` (approved/rejected/shortlisted) | — |
| 5 | `Content Viewed` | `content_id`, `creator_id`, `program_id` | — |
| 6 | `Order Completed` | `program_id`, `payment_method`, `gross_transaction_value`, `net_revenue`, `marketplace_take_rate`, `currency` | — |
| 7 | `Review Submitted` | `creator_id`, `star_rating` (1-5), `has_text_review` (bool) | — |

---

### What NOT to Track

- Generic UI clicks with no business meaning (`button_clicked`, `page_scrolled`)
- Ambiguous events without past tense (`Export file` → use `File Exported`)
- Duplicate events for variations (not `Credit Card Order` + `PayPal Order` → use `Order Completed` + `payment_method` property)
- PII in event properties

### Tracking Plan Maintenance

- Assign a **Data Governor** (PM or Data Lead) who approves all new events
- All events live in one central doc (Amplitude Data / tracking plan spreadsheet)
- Treat analytics code like production code: new events require PR review
- Quarterly audit: deprecate/hide stale events
- Separate Dev and Prod Amplitude projects — never pollute prod with test data
- Validate with live Event Stream after each instrumentation; verify unified `user_id` across web/mobile/backend

---

## Part 2 — North Star & Metrics Framework

### North Star Metric

**For a B2B creator marketplace: Match Rate**

```
Match Rate = Content Submitted (Approved) ÷ Programs Launched
```

This measures marketplace liquidity. A 0 means the flywheel is completely stalled.

Alternative framings:
- Monthly Transactional Liquidity Score
- Search-to-Fill Rate (% of brand searches → completed transaction)

### L1 / L2 / L3 Metric Tree

```
L1 North Star: Match Rate (Approved Content Submitted ÷ Programs Launched)
│
├── DEMAND SIDE (Brands)
│   ├── L2: Buyer Liquidity (Search-to-fill rate)
│   ├── L2: Retention (Repeat program launch ratio)
│   ├── L2: Time-to-Match (Program Launched → Content Submitted)
│   └── L3: Average Order Value, Time to first purchase, Search success rate
│
└── SUPPLY SIDE (Creators)
    ├── L2: Sell-Through / Fill Rate (Content Submitted ÷ Programs Applied)
    ├── L2: Supply Utilization (% of active creators monetizing)
    ├── L2: Time-to-Transaction (Account Created → first Payout Received)
    └── L3: New creator sign-ups/week, Profile completion rate, Response time
```

### Metrics by Growth Stage

| Stage | Focus | Key Metrics |
|-------|-------|-------------|
| Pre-PMF | Find first liquidity | Time-to-first-match, match rate in top category, sell-through, activation rate |
| Post-PMF | Balance at scale | Reduce time-to-match, sell-through >50%, repeat rate, CAC |
| Scaling | Unit economics | Take rate, NRR, LTV:CAC (target 3:1–5:1), CAC payback <18 months |

### Vanity vs. Actionable

**GMV is a vanity metric** if driven by subsidies. Always pair with: Net Revenue, Effective Take Rate, Contribution Margin per Order.

### Benchmarks (B2B SaaS / Marketplace)

| Metric | Good | Great |
|--------|------|-------|
| Activation rate (signup → activated) | 20% | 35%+ |
| D7 retention | 5% | 7%+ |
| D30 retention | 10% | 15%+ |
| Match Rate (seed stage) | 20–40% | — |
| Match Rate (growth stage) | 40–60% | 60%+ |
| Sell-through (early) | 30–50% | — |
| LTV:CAC | 3:1 | 5:1 |
| CAC payback | <18 months | <12 months |

---

## Part 3 — Dashboard Architecture

### Dashboard Map

| Dashboard | Audience | Cadence |
|-----------|----------|---------|
| Marketplace Liquidity & Health | Founders, ops | Daily (15min) |
| Activation & Onboarding | Product, growth | Daily (15min) |
| Retention & Churn Early Warning | Product, CSM | Weekly |
| Supply & Demand Engagement | Supply/demand managers | Weekly |
| Executive / Unit Economics | C-suite, investors | Monthly |
| Growth & Acquisition | Marketing | Weekly |

---

### Dashboard 1: Marketplace Liquidity & Health

| Chart | Type | Configuration |
|-------|------|--------------|
| Match Rate | Event Segmentation (Formula) | A=`Content Submitted`, B=`Program Launched` → Formula: `TOTALS(A)/TOTALS(B)` |
| Time-to-Match | Funnel Analysis | `Program Launched` → `Content Submitted`, view as "Time to Convert" distribution histogram |
| Buyer:Seller Ratio | Event Segmentation (Formula) | A=`Any Active Event` (brand), B=`Any Active Event` (creator) → `UNIQUES(A)/UNIQUES(B)` |
| Supply Utilization | Event Segmentation (Formula) | A=`Content Submitted` (approved), B=`Content Submitted` (total) → `TOTALS(A)/TOTALS(B)` |

**Alert:** Set Amplitude alert if Match Rate drops 10% below 8-week trailing median.

---

### Dashboard 2: Activation & Onboarding

| Chart | Type | Configuration |
|-------|------|--------------|
| Creator Activation Funnel | Funnel Analysis | `Account Created` → `Profile Updated` → `Content Submitted`; filter `user_type=creator`; breakdown by `country`, `device_type` |
| Time-to-Value | Funnel Analysis | Same funnel, view as "Time to Convert" |
| Drop-off Pathing | Pathfinder | Start at the drop-off step; see alternate paths users took |
| Brand Activation Funnel | Funnel Analysis | `Program Drafted` → `Program Launched` → `Order Completed`; filter `user_type=brand` |

---

### Dashboard 3: Retention & Churn Early Warning

| Chart | Type | Configuration |
|-------|------|--------------|
| N-Day Cohort Retention | Retention Analysis | Starting: `Account Created`, Return: `Content Submitted` or `Any Active`; segment by `user_type`, filter `country≠Tunisia` |
| Feature Abandonment | Behavioral Cohort | Users with `Content Submitted` or `Program Launched` > 0 in last 30d, but 0 in last 7d |
| Zero-Liquidity Churn Risk | Event Segmentation | Brands with `Program Launched` but 0 `Content Submitted` within 7 days |
| Post-Login Journey | Pathfinder | Starting: `Account Logged In`; see top 5 paths for brands vs creators |

---

### Dashboard 4: Executive / Unit Economics

| Chart | Type | Configuration |
|-------|------|--------------|
| GMV | Event Segmentation | `Order Completed`, Sum of `gross_transaction_value` property |
| Take Rate | Event Segmentation (Formula) | `PROPSUM(platform_fee) / PROPSUM(gross_transaction_value)` |
| Net Dollar Retention | Event Segmentation | Filter `user_type=brand`, group by `company_id`, track expansion vs contraction revenue |
| CAC | Event Segmentation (Formula) | `PROPSUM(ad_spend) / TOTALS(Account Created)` |

---

## Part 4 — Cohort Analysis & Retention Playbook

### Saved Cohorts to Create

| Cohort Name | Definition | Use |
|-------------|-----------|-----|
| High-Intent Target Creators | `user_type=creator` + `country≠Tunisia` + `Profile Updated` ≥1x in 7d | Supply seeding, outreach |
| Activated Brands | `user_type=brand` + `Program Launched` ≥1x in 30d | Account health tracking |
| Onboarding Drop-offs | `Account Created` but NO `Onboarding Tutorial Completed` within 1d | Traffic quality audit |
| Zero-Liquidity Brands | `Program Launched` ≥1x but NO `Content Submitted` within 7d | CSM churn prevention |
| Churned Creators (Inverted) | `Account Created` but NO `Content Submitted` ever | Compare vs activated |

---

### Finding the Activation ("Aha") Moment

1. List 3–5 hypotheses for what "getting value" looks like per user type
   - Creator: "submitted 1 piece of content within 3 days"
   - Brand: "approved 1 creator application within 7 days"
2. Use **Amplitude Compass** — automatically identifies which behaviors correlate most with long-term retention
3. Build behavioral cohorts around each hypothesis and plot retention curves
4. The behavior with the biggest retention gap between "did it" vs "didn't do it" = your activation moment

---

### Comparing Activated vs Churned Cohorts

1. Build cohort A: creators who triggered `Content Submitted`
2. Build cohort B (inverted): creators who did NOT trigger `Content Submitted`
3. In Retention Analysis, plot both curves → look for the gap
4. Apply cohort A to Pathfinder → identify "golden path" early behaviors (e.g., profile completion, program browsing)
5. Test causation: run A/B experiment making the correlated behavior mandatory → measure retention impact

---

### Diagnosing Low Retention (Step-by-Step)

1. **Filter noise first** — exclude Tunisia; true target-market retention may look completely different
2. **Check Day 1** — massive drop on Day 1 = onboarding friction before any value delivered
3. **Check liquidity** — if `Content Submitted = 0`, marketplace has no value to deliver → retention will always be near zero regardless of onboarding quality
4. **Use Microscope** — click on the exact funnel drop-off step → create instant cohort of abandonments
5. **Apply Pathfinder** to that cohort → find where users went instead (error screen? login loop? specific friction point?)
6. **Compare "retained" vs "churned" paths** — isolate golden path behaviors

### Interpreting Retention Curves

| Curve shape | Meaning |
|-------------|---------|
| Steep then flattens | Good — core loyal users found; focus on accelerating time to that plateau |
| Continuously slopes to zero | Product not delivering ongoing value; fundamental problem |
| Drops immediately on Day 1 | Onboarding broken; users leave before seeing anything |

---

## Part 5 — Acting on Data

### Weekly Review Process (60 min)

**Participants:** PM, Marketing lead, Sales/CSM lead, Data analyst

**Agenda:**
1. Top 5 KPIs vs 8-week baseline (Match Rate, Time-to-Match, Sell-through, GMV, Take Rate)
2. Active A/B test results
3. Anomalies flagged by automated Amplitude alerts
4. Assign remediation owners with 24h action deadline for any threshold breached

**Remediation playbook example:** If Time-to-Match spikes → throttle new brand acquisition, deploy supply boost campaign to creators

---

### A/B Testing with Amplitude Experiment

- **Test one element at a time** — one headline, one form field, one step removed
- **Test at your weakest funnel stage** — not where it's already good
- **Measure downstream impact** — not just clicks; track conversion, retention, and revenue for each variant
- **Don't stop early** — wait for statistical significance before calling winners

**Priority experiments for a marketplace with cold-start problems:**

| # | Experiment | Hypothesis | Measurement |
|---|-----------|-----------|-------------|
| 1 | Show Value First (skip tutorial) | Forced tutorial creates friction before creators see any value | `Account Created → Content Submitted` conversion rate |
| 2 | Geo-fence non-target countries to waitlist | Bad traffic poisons matching algorithms and skews all metrics | Conversion rate + retention of remaining target-market users |
| 3 | Supply-side cash seeding incentive | Guaranteed $50 bonus for first 50 approved submissions kickstarts marketplace liquidity | Match Rate + Time-to-Match + brand 30d retention |

---

### Funnel Leak Investigation Process

1. Open funnel with the drop-off step
2. Click → **Microscope** → create cohort of users who abandoned at that step
3. Apply that cohort to **Pathfinder** → visualize alternate paths taken
4. Compare "dropped" cohort vs "converted" cohort in same Pathfinder → isolate golden path
5. Form hypothesis → A/B test the fix → measure significance

---

### Growth Flywheel Measurement

**Core loop:**
```
New creator acquisition
→ Content Submitted increases
→ Brand search satisfaction improves
→ Brand transaction volume grows
→ Creator earnings grow
→ Creator retention + referrals
→ (repeat)
```

**Measure each link in the chain** — the stalled link is your constraint. If `Content Submitted = 0`, the flywheel is broken at step 2. Fix that before optimizing anything else.

**Network effect signal:** Brand conversion rate improves as creator supply density increases (and vice versa) → this is the flywheel accelerating.

---

### CRM Integration & Triggering Sales Actions

- Connect Amplitude → CRM (HubSpot/Salesforce) bidirectionally
- Sync `Zero-Liquidity Brands` cohort → auto-trigger CSM alert when brand has `Program Launched` but 0 `Content Submitted` within 7 days
- Set Amplitude automated alerts → notify CSM Slack channel when specific thresholds breached

### Leading Churn Indicators (30 days ahead)

| Signal | How to Track in Amplitude |
|--------|--------------------------|
| Drop in DAU/WAU | Event Segmentation on `Any Active Event`, group by `company_id`, alert on >30% week-over-week drop |
| Feature abandonment | Cohort: active in last 30d but 0 events in last 7d |
| Zero content matched after program launch | Zero-Liquidity Brands cohort (7-day check) |
| Login frequency decline | User Sessions, filter by `company_id`, track sessions/week trend |

---

## Part 6 — Red Flags Reference

| Observation | Likely Cause | Immediate Action |
|------------|-------------|-----------------|
| Funnel < 5% end-to-end | Severe onboarding friction OR broken flow OR wrong traffic | Microscope the drop-off; filter by geo to separate traffic quality from UX issues |
| 80%+ users from non-target country | Misconfigured paid ads, affiliate fraud, or click farms | Identify `acquisition_channel` in Cohort 2 (drop-offs); kill that spend |
| D30 retention < 10% | No aha moment reached; or metric poisoned by bad traffic | Filter bad traffic first; then check Day 1 drop-off; then check liquidity |
| Core action event = 0 in a period | Cold start problem or broken instrumentation | First: verify event is firing (check event stream); then: supply seeding |
| GMV growing but Match Rate flat | You're growing quantity of programs but not supply | Supply-side acquisition campaign; seeding incentive |

---

## Notebook Resource

NotebookLM notebook with 333 sources (286 web, 15 YouTube, 11 Amplitude blog articles):
- Notebook ID: `aa22ad52-e1bf-4306-8431-418e538776cc`
- To ask follow-up questions: `PYTHONIOENCODING=utf-8 python3 -m notebooklm ask "your question" --notebook aa22ad52-e1bf-4306-8431-418e538776cc`
