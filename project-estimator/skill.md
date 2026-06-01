---
name: project-estimator
description: Generate detailed project estimations (chiffrage/devis) from a cahier des charges
trigger: estimate, estimation, chiffrage, devis, /project-estimator
arguments:
  - name: price_target
    description: "Budget target (e.g. '12k', '30000'). Adjusts scope to fit."
    required: false
  - name: tjm
    description: "TJM override in EUR HT (default: 300)"
    required: false
  - name: team
    description: "Team composition (e.g. '2 devs + 1 QA')"
    required: false
visibility: public
---

# Project Estimator Skill

Generate a complete project estimation document from a cahier des charges (specs document).

## Input

Read the cahier des charges provided by the user. Accepted formats: .docx, .md, .pdf, or pasted text. If .docx or .pdf, use appropriate tools to extract content.

## Process

### Step 1: Analyze the specs

- Identify: project name, target platform (web/mobile/desktop), tech stack
- Detect if a BaaS/framework is specified (Base44, Supabase, Firebase, etc.) -- this reduces backend estimates significantly
- Identify core value proposition and monetization model
- List all requested features and group them logically

### Step 2: Define EPICs

Break down into EPICs (logical feature groups). Always include:
- **Sprint 0 - Discovery**: setup, prototyping, scope validation (2-4 days typically)
- **Integration & Polish**: end-to-end testing, UX polish (2-3 days typically)
- Group remaining features into 4-8 EPICs by domain

### Step 3: Estimate each feature

For each feature, determine:
- **ID**: EPIC prefix + sequential number (e.g. CE01, AI02)
- **Feature name**: concise description
- **Story Points**: Fibonacci scale (1, 2, 3, 5, 8, 13) -- use for complex projects only
- **Days**: estimated dev days (can be 0.5 increments)
- **Price**: days x TJM (default 300 EUR HT)
- **Status**: MVP or DIFFERE
- **Justification**: why MVP or why deferred (1 sentence)

### Step 4: MVP vs DIFFERE classification

MVP features must:
- Deliver the core value proposition
- Be necessary for first usable version
- Include auth if monetization is in scope

DIFFERE features are:
- Nice-to-have optimizations
- Advanced/premium features
- Features that need market validation first
- Features with high cost but low initial impact

### Step 5: Calculate totals

- Subtotal per EPIC (MVP count, MVP price, Differe count, Differe price)
- Grand total with optional buffer/margin
- If price_target is set: adjust scope (move features to DIFFERE or MVP) to hit the target while preserving core value. The margin between raw feature cost and price target covers project management, communication, iterations, and testing.

### Step 6: Generate 3 pricing options

1. **Essentiel** (budget-friendly): stripped-down MVP, core features only
2. **MVP Recommande** (recommended): full MVP with all essential features
3. **Tout inclus**: MVP + all deferred features

Each option has: scope summary, duration, price.

### Step 7: Payment schedule

Always 4 milestones at 25% each:
| Jalon | % | Montant | Declencheur | Semaine |
|-------|---|---------|-------------|---------|
| Acompte | 25% | ... | Signature du contrat | S0 |
| Jalon 1 | 25% | ... | Demo X validee | S... |
| Jalon 2 | 25% | ... | Demo Y validee | S... |
| Solde | 25% | ... | Recette finale + Deploiement | S... |

Include a demo planning table aligned with milestones.

### Step 8: Monthly costs

Estimate recurring costs the client will pay:
- Hosting/cloud, APIs (data, AI/LLM, image generation), BaaS, Stripe fees, domain/SSL
- Provide low and high estimates
- If AI/LLM is involved, include a volume-based cost table

### Step 9: Post-delivery revenue

Table of maintenance, support, and future phase pricing.

### Step 10: First year total cost

Table comparing all 3 options: development + 12 months recurring + 12 months maintenance.
Include market comparison (French freelance senior 500-700 EUR/day).

### Step 11: Tech recommendations (if relevant)

If a key architectural decision impacts estimates (BaaS vs custom backend, LLM vs rule-based, etc.), add a comparison table with: dev time, initial cost, monthly cost, maintenance, scalability.

### Step 12: Risks table

Include technical, legal/regulatory, and business risks:
| Risque | Impact | Mitigation |
|--------|--------|-----------|

Always consider: API dependencies, data privacy (RGPD), performance, vendor lock-in, AI quality/cost.

### Step 13: Conditions

Standard conditions (adapt as needed):
1. Forfait fixe (not billed by the day)
2. Regular demos with client feedback integrated
3. Scope changes require a separate avenant
4. Third-party APIs/hosting paid by client
5. IP transfers to client upon full delivery and payment
6. 30-day bug fix guarantee after recette finale
7. Timeline from signature, subject to API access availability

Add project-specific conditions (e.g. RGPD for children's data, content moderation).

## Output Format

Generate a single Markdown file with this exact structure:

```markdown
# ESTIMATION COMPLETE - [PROJECT NAME]

## Chiffrage detaille par feature avec recommandations

**TJM** : [TJM]EUR HT | **Stack** : [stack] | **Cible** : [platform]

[Month Year] - Document confidentiel

---

## 1. Synthese rapide
[Table with 3 options: Essentiel / MVP Recommande / Tout inclus]
[Summary paragraph]

## 2. Chiffrage feature par feature
### Legende
### SPRINT 0 - DISCOVERY
### EPIC 1 - [NAME]
[Feature table with ID, Feature, (Pts if complex project), Jours, Prix, Statut, Justification]
[Subtotal table: MVP vs Differe]
### EPIC 2 - [NAME]
...
### INTEGRATION & POLISH
### FEATURES DIFFEREES - PHASE 2+ (if many deferred features, group them)

## 3. RECAPITULATIF GENERAL
### Par Epic
[Summary table with all epics, MVP and Differe columns]

## 4. OPTIONS DE FACTURATION
### Option Essentiel
### Option MVP Recommande (notre recommandation)
### Option Tout inclus

## 5. ECHELONNEMENT DE PAIEMENT (Option MVP Recommande - [PRICE])
[Payment milestone table]
### Planning des demos

## 6. COUTS RECURRENTS MENSUELS
[Monthly costs table with low/high estimates]

## 7. REVENUS ADDITIONNELS POST-LIVRAISON
[Maintenance, support, future phases table]

## 8. COUT TOTAL PREMIERE ANNEE
[Comparison table for all 3 options]
### Mise en perspective marche

## 9. [TECH RECOMMENDATION TITLE] (if relevant)
[Comparison table]

## 10. RISQUES ET POINTS D'ATTENTION
[Risk table]

## 11. CONDITIONS
[Numbered list]
```

## Rules

- **TJM default**: 300 EUR HT (override with `tjm` argument)
- **Story points**: Fibonacci (1, 2, 3, 5, 8, 13). Use for complex projects (>30 features). For simpler projects, days alone suffice.
- **Sprint 0**: Always include. 2-4 days depending on complexity.
- **BaaS impact**: If Base44/Supabase/Firebase is used, reduce backend estimates by 60-80%. Note this explicitly.
- **Budget fitting**: If user specifies a price target ("fais moi un truc a 12k"), adjust scope to fit. Move features to DIFFERE, simplify EPICs, but always keep core value. The gap between raw feature cost and target price = margin for PM, iterations, testing.
- **Payment**: Always 4 milestones at 25%.
- **AI costs**: If the project uses AI/LLM, always include per-unit cost estimates and a volume table.
- **All text in French** (section titles, justifications, conditions). Technical terms in English are OK.
- **No em dashes** in the output document.
- **Currency**: EUR with EUR symbol after the number (e.g. 300EUR)
- Save the estimation file as `Estimation_[ProjectName].md` in the current working directory or as specified by the user.

## Post-estimation

After generating the estimation, ask the user:
1. "Veux-tu que j'ajuste le scope ou le prix?"
2. "Veux-tu que je cree un dossier Google Drive + Google Sheet avec /gws?"
