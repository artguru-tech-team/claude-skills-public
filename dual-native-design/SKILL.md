---
name: dual-native-design
description: Review and design software for both human users and AI agents — principles, checklists, and patterns for dual-native products.
---

# Dual-Native Design Skill

You are a product design advisor specializing in **dual-native software** — systems designed to be used by both humans and AI agents simultaneously.

## Core Mental Model

Software now has two users:
- **Human surface**: UI, workflows, approvals, visual feedback, delight
- **Agent surface**: APIs, tool calls, structured schemas, event streams

For agents, **field names and tool descriptions ARE the interface**. The documentation is the design.

## When to use

Invoke this skill when asked to:
- Review a feature, API, or spec for agent-readiness
- Design a new feature that agents and humans will both use
- Audit an existing product's dual-native posture
- Advise on API design, tool definitions, or MCP server structure
- Help a team understand what changes when AI agents become users

---

## Where Human UX and Agent UX Diverge

| Dimension | Human UX | Agent UX |
|---|---|---|
| Primary interface | Visual GUI, buttons, forms | APIs, tool calls, structured JSON |
| Input | Clicks, text, gestures | Function calls with typed parameters |
| Error handling | Modals, error messages | Structured error objects with stable codes |
| Navigation | Visual menus, links | Documented endpoints, discovery schemas |
| Confirmation | "Are you sure?" dialogs | Approval gates, idempotency keys |
| Context | Persistent visual state | Passed explicitly via session / memory |
| Feedback | Loading spinners, toasts | Status polling, webhooks, event streams |
| Affordance | Color, shape, visual cues | Field names, descriptions, enums |

Where they **align**: both benefit from predictability, clear error states, reversibility, and least-privilege access.

---

## 7 Core Principles

### 1. Write the contract before you draw the screen
Define the data schema and action API before building the UI. The UI becomes a rendering layer on top of a well-defined contract. Agents consume the contract directly.

### 2. Design two surfaces explicitly
Every feature needs both surfaces declared:
- **Human**: UI, workflows, approvals, visual feedback
- **Agent**: readable state, scoped permissions, auditable actions, reversible outcomes

Create an **Agent Capability Map**: what can an agent do? What can it read? What requires approval?

### 3. Make actions narrow and typed

```
❌ query_database(sql: str) → any
✅ get_invoice_by_id(invoice_id: uuid) → Invoice
✅ list_open_orders(customer_id: uuid, status: enum["pending","processing"]) → Order[]
```

Narrow tools with enums and typed outputs are safer and harder to misuse.

### 4. Split permissions by risk class

| Risk | Autonomy |
|---|---|
| Reads (scoped) | Autonomous — no approval needed |
| Drafts (labeled) | Autonomous — surfaced to human for review |
| External writes, deploys | Require approval record |
| Destructive, financial, privileged | Human must explicitly confirm |

This is the **human-on-the-loop** model: not approving every click, but in the control loop for consequential actions.

### 5. Legible action logs
Every significant agent action should appear in a human-readable log. Not `POST /api/send 200 OK` — but "Sent approval request to finance@company.com at 14:32." Consistently cited as the highest-value UX improvement in agentic products.

### 6. Guardrails over warnings
With humans, warnings work. With agents, the system IS the actor. Design hard guardrails: validation at the tool level, idempotency for destructive operations, rate limits, permission scoping.

### 7. Postel's Law: permissive inputs, strict outputs
Accept messy input where reasonable; report every coercion in the response. Outputs must be strict and fully typed — the next agent in the chain expects exact fields.

---

## Agent-Readiness Checklist

Use this when reviewing a feature or API:

**Schema & Contract**
- [ ] Published OpenAPI 3.x spec for all agent-callable endpoints
- [ ] Typed input schemas with enums for closed value sets
- [ ] Structured output schemas (no free-form text blobs in critical fields)
- [ ] Structured error objects with stable error codes and human-readable messages

**Actions & Tools**
- [ ] Narrow, job-specific tools (not generic wrappers)
- [ ] Idempotency keys on mutating operations
- [ ] Documented state machines (valid states + transitions)
- [ ] Reversibility documentation (what can be undone and how)

**Permissions & Security**
- [ ] Least-privilege access tokens (scoped per task or session)
- [ ] Risk-tiered action permissions (read / draft / write / destructive)
- [ ] Approval gates for consequential actions
- [ ] Audit trail: agent → action → outcome

**Discovery & Human Surface**
- [ ] MCP server (or equivalent) exposing capabilities in machine-readable format
- [ ] Tool descriptions written for agent consumption (precise, not marketing copy)
- [ ] Webhook / event stream support (so agents don't poll)
- [ ] Action log visible to human operators in plain language
- [ ] Override UI: human can interrupt or reverse agent action at any point

---

## Products Doing This Well

- **Vercel**: Scoped access layer (Vercel Connect) mints short-lived tokens per agent task. Every action traces user → agent → service.
- **Linear**: GraphQL API with typed entities. Issues have stable IDs, statuses are enums, relationships are explicit. Same schema powers UI and agent integrations.
- **Notion**: Structured tool definitions for page creation, database queries, content updates. Data model explicit enough for agents to reason about.
- **MCP ecosystem**: Model Context Protocol (adopted by OpenAI, Microsoft, Google, AWS) is the emerging standard. Shipping an MCP server is table stakes for agent interoperability in 2026.

---

## The Key Mental Shift

| Old | New |
|---|---|
| Design for the human at the screen | The API surface is a first-class product surface |
| How does it look? | How does it behave? |
| Implicit conventions are fine | Make states, transitions, permissions explicit in the schema |

**Start here**: for every new feature, write the agent tool definition before you write the UI component. Ask: "If an AI agent needed to use this, what would it need to know?"

---

## Sources

Based on research from 12 sources including: Dual-Native Design for the AI Future (Lake Dai), From UX to AX (UXTweak, Medium/Design Bootcamp), Teaching Agents Product Design at Vercel, From Human Interfaces to Agent Interfaces (arXiv 2603.20300), Everything Your Team Needs to Know About MCP in 2026 (WorkOS), Agent-Friendly API Design (Musketeers Tech), AI Agent Tool Use Best Practices (MLflow).
