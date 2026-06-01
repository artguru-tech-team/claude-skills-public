---
name: karpathy-loop
description: Use when building self-improving autonomous systems, optimization loops, or applying experiment-driven iteration to any domain. Triggers on "auto-improve", "self-optimizing", "experiment loop", "karpathy loop", autonomous optimization, or when a workflow could benefit from measure-analyze-rewrite cycles.
visibility: public
---

# Karpathy Loop - Autonomous Experiment Framework

Turn any measurable workflow into a self-improving loop. Based on Karpathy's autoresearch (700 ML experiments in 2 days) and proven adaptations to content, outreach, and ops.

## Core Loop

```
Seed Knowledge --> Generate Hypothesis --> Run Experiment --> Measure --> Analyze --> Rewrite Strategy --> Repeat
```

## The 3-Register Program

Every loop needs a `program.md` (or equivalent) with exactly three registers:

| Register | Purpose | Example |
|----------|---------|---------|
| **Instructions** | What to search for / try next | "Test subject lines with numbers vs questions" |
| **Constraints** | What must NOT change (invariants) | "Never exceed 3 emails per sequence, keep tone professional" |
| **Stopping criteria** | When to stop and report | "After 50 experiments OR when metric plateaus for 3 rounds" |

## 6 Patterns to Apply

### 1. Seed Before You Loop
Never cold-start. Seed with 15-25 real examples of "what good looks like."
- Bad seed = wasted loops. The seed defines the search space.

### 2. Metric-Driven Self-Rewrite
The agent scrapes real-world metrics, then rewrites its own strategy file.

| Domain | Metric | Strategy file |
|--------|--------|---------------|
| ML training | loss, speed | hyperparams.yaml |
| Content | impressions, engagement | content_strategy.md |
| Cold email | open rate, reply rate | sequence_strategy.md |
| Support routing | misroute rate | routing_rules.json |
| Ad creative | CTR, CPA | creative_brief.md |
| Hiring outreach | response rate, conversion | outreach_playbook.md |
| Pricing | revenue, churn | pricing_rules.md |

### 3. Two-Speed Schedule
Split generation from optimization:
- **Fast loop** (daily/hourly): generate + execute + log results
- **Slow loop** (weekly): analyze patterns + rewrite strategy

Don't analyze every run. You need enough data to see patterns.

### 4. Git-as-Lab-Notebook
Every experiment commits results. Gives you: rollback, diffs, audit trail.
Alternative: structured DB (Notion, Postgres) with version history.

### 5. Parallel Explore, Sequential Integrate
Fan out N experiments in parallel. Collect results. Merge findings one at a time.
This is why 700 > 50 in the same timeframe.

### 6. Constraint-Preserving Mutation
The agent changes variables but NEVER touches invariants. Define invariants explicitly or the loop will drift.

## How to Apply to a New Domain

```
1. IDENTIFY: What metric do you want to optimize?
2. SEED: Collect 15-25 examples of current best performance
3. DEFINE: Write program.md with instructions/constraints/stopping criteria
4. INSTRUMENT: Build metric scraper (Apify, API, DB query, etc.)
5. LOOP: Agent generates variation -> executes -> logs result
6. ANALYZE: Weekly slow-loop rewrites strategy based on data
7. GUARD: Define invariants that must never change
```

## Quick Checklist

- [ ] Metric identified and measurable automatically
- [ ] 15-25 seed examples collected
- [ ] program.md written (3 registers)
- [ ] Invariants explicitly listed
- [ ] Metric scraper built and tested
- [ ] Fast loop schedule set (generation cadence)
- [ ] Slow loop schedule set (analysis cadence)
- [ ] Results logged to git or structured DB
- [ ] Stopping criteria defined

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| No seed data, starting from zero | Always seed with real examples first |
| Analyzing after every single run | Batch analysis weekly, need enough data for patterns |
| No invariants defined | Agent will drift - explicitly list what must NOT change |
| Optimizing vanity metrics | Choose metrics tied to actual business outcome |
| No stopping criteria | Loop runs forever burning tokens for marginal gains |
| Manual metric collection | Automate scraping or the loop breaks on human latency |
