---
name: llm-council
description: Use for hard decisions, strategy calls, or "challenge my thinking / am I fooling myself" — spawns independent role-agents (each a distinct adversarial lens), collects their honest takes, then synthesizes as chairman. Anti-sycophancy by design. Triggers on "council", "bouscule-moi", "pressure-test", "decide X or Y", "pre-mortem", "red team my plan", or any high-stakes trade-off where the main model's agreement bias would hide the truth.
visibility: public
---

# LLM Council — multi-agent decision council

Adapté du *llm-council* de Karpathy (multi-modèle) → ici **multi-agent, single-model** dans Claude Code via le tool Agent. Plus besoin de plusieurs LLMs : plusieurs **agents indépendants**, chacun un rôle qui diverge structurellement, puis une synthèse de chairman.

## Pourquoi (le seul point qui compte)
Le modèle principal est **complaisant** : seul, il valide tes idées. Le council casse ça parce que les rôles sont des **subagents indépendants** qui (a) ne savent pas ce que tu/le chairman penses, (b) ont un mandat qui les pousse à diverger, (c) ont l'ordre explicite de ne PAS faire plaisir. La preuve que ça marche : le chairman se fait corriger par son propre council.

**Règle d'or : ne joue JAMAIS les rôles toi-même.** Si le modèle principal role-play les 5 voix, c'est toujours le même biais → théâtre. Utilise de vrais subagents (tool Agent).

## Process
1. **Brief factuel commun** — écris UNE fois les faits (chiffres réels, contraintes). Ground tous les agents dessus à l'identique. Si tu as des données (DB, métriques), tire-les AVANT — un council sur du narratif/vanity metrics produit du narratif.
2. **Fan-out** — spawn 4-5 agents EN PARALLÈLE (un seul message, plusieurs tool-calls Agent), `subagent_type: general-purpose`. Chacun : le brief + son rôle + l'ordre anti-complaisance + un format de sortie forcé. **Ne révèle pas ta reco ni le lean de l'utilisateur.**
3. **Synthèse chairman** (toi) — fais ressortir : **consensus** (haute confiance), **divergence** (la vraie décision), et **où le council te contredit TOI** (la preuve anti-sycophantisme). Termine par un call net.
4. **Itère** quand les faits changent — round 2 avec données corrigées, ou un round **pré-mortem** une fois la décision prise.

## Roster de rôles (pioche selon la décision)
- **CFO / survie cash** — juge que par le cash et le risque de ruine. Horizon court. Brutal.
- **VC / allocateur de capital** — risk-adjusted, equity, asymétrie, leverage. Quel pari mérite la place ?
- **Red team / avocat du diable** — détruit le plan, nomme les auto-illusions, trouve la faille fatale.
- **Opérateur / bande passante** — heures réelles, focus, burnout, context-switching. Qu'est-ce qui RENTRE vraiment ?
- **Minimiseur de regret / North Star 5 ans** — qu'est-ce qu'il regrettera ? Quel chemin construit l'identité voulue ?
- **Stratège Product/GTM** — le plan est crédible ou hopium ? Le move le plus à fort levier ?
- Compose librement (hiring, technique, légal…). 4-5 = le sweet spot. Choisis des rôles qui **divergent par construction**.

### Variante pré-mortem (décision déjà prise)
Quand c'est tranché, ne re-décide pas (théâtre). Fais un **pré-mortem** : *"On est dans 6 mois, le plan a ÉCHOUÉ — pourquoi ?"* Chaque agent = une autopsie d'une cause différente (burnout, cash/timing, équipe/cofounder, drift d'identité). Sortie : histoire de l'échec + **signal d'alerte le plus précoce (tripwire)** + **assurance la moins chère à prendre maintenant**. Le chairman extrait les tripwires + assurances → les écrit comme risques à surveiller.

## Gabarit de prompt d'agent
```
ROUND [n] d'un council. [Si round 2+ : "tu as les vrais chiffres maintenant, sois spécifique."]
Ton rôle : [RÔLE]. [Mandate qui force la divergence]. Tu n'es pas là pour faire plaisir ; si le consensus évident est mauvais, démonte-le.

[BRIEF FACTUEL COMMUN — identique pour tous]

Réponds ~250-300 mots MAX :
1. Verdict (1 phrase tranchée).
2. [La question forcée — ex: "bet A ou B ?", ou "la faille fatale"].
3. Le blind spot / l'auto-illusion.
4. Le plus gros risque de TA reco.
5. Une chose à ARRÊTER.
Raisonne depuis le brief, pas d'outils.
```

## Gotchas
- **Ne révèle pas ton lean / la reco du user aux agents** → tue l'indépendance.
- **Ground sur des faits réels**, pas du narratif — tire les chiffres d'abord (DB, metrics). Le council a déjà retourné un verdict quand les vrais chiffres contredisaient le narratif du founder.
- **Force un format + un verdict tranché** (sinon réponses molles).
- **Le chairman doit nommer où le council l'a corrigé LUI** — c'est tout l'intérêt, et c'est ce que le user veut (anti-complaisance).
- Persiste la synthèse (gbrain / doc) si la décision est importante — les tripwires d'un pré-mortem méritent d'être surveillés dans le temps.

## Crédit
Concept : [karpathy/llm-council](https://github.com/karpathy/llm-council) (multi-modèle). Adaptation multi-agent single-model pour Claude Code.
