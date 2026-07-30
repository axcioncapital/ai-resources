# Protected Zones

> **When to read this file:** `/resolve-incident` Step 2 reads it to classify whether a proposed fix touches a protected zone. Maintainer: operator. Update condition: a new shared asset class appears in the repo, or a `/friday-checkup` round flags a missing zone.
>
> **Owner:** operator (Patrik). **Purpose:** pre-classification lookup for the incident pipeline — answers "is this path protected?" with a yes/no + required review path. **Update condition:** add a row when a real incident exposes a missing zone; do not add rows speculatively.

---

## Zone list

| Path or glob | Why protected | Required review |
| --- | --- | --- |
| `CLAUDE.md` (workspace root + ai-resources) | Always-loaded into every session; every rule change affects all future turns | Risk-aware review required; `/consult` if the change is structural or non-trivial |
| `.claude/hooks/*.sh` | Per-session-event runtime; failure modes are often invisible until something breaks | Risk-aware review required |
| `.claude/settings.json` (any layer) | Permission surface and hook wiring; changes can silently block or over-allow tools | Risk-aware review required |
| `.claude/commands/*.md` (shared — in `ai-resources/`) | Autosynced to all projects; a behavior change affects every project session | Risk-aware review if behavior-changing; cosmetic/doc edits may skip |
| `.claude/agents/*.md` (shared — in `ai-resources/`) | Autosynced to all projects; scope or authority changes affect all downstream invocations | Risk-aware review if behavior-changing; `/consult` if scope or authority changes |
| `templates/**` | Consumer contract bound to `/new-project` and `/deploy-workflow`; changing a template changes every future scaffold | Read `templates/README.md` consumer-contract section before any edit |
| `docs/repo-architecture.md` | Source-of-truth for `/route-change` routing; stale map produces wrong placement recommendations | Risk-aware review required |
| `docs/audit-discipline.md` | Defines the structural change classes; editing it redefines which changes count as high-consequence | Risk-aware review required |
| `docs/autonomy-rules.md` | Defines the operator-confirmation gates (Autonomy Rules #1–#10); editing it changes when Claude stops | Risk-aware review required |
| `docs/qc-independence.md` | Defines the independent-review rule — which changes get reviewed, by whom, and how findings close | Risk-aware review if changing the rule; cosmetic edits may skip |
| `logs/improvement-log.md` (schema block only) | Two-end contract between `/friday-act`, `/resolve-repo-problem`, and `/resolve-incident`; schema changes break consumers | Read schema block before any schema change; align all consumers in the same commit |

---

## What "elevated review" means here

- **Risk-aware review required** — the change takes the risk-aware review row of `qc-independence.md` § The rule: one Codex review carrying the seven risk dimensions, **before** implementing. Apply what it found before the change lands. A material finding left unresolved blocks — surface it and stop, do not proceed on the reasoning that the review ran. When Codex cannot reach the change, fall back to inline self-review and record the result as `unassessed`, never as passed (`qc-independence.md` § When the reviewer cannot be reached).
- **`/consult` (Function B)** — invoke `/consult` as a pre-change advisory when the change is structural or load-bearing. Pre-invoke gate: `/consult` Step 0 requires a prior Read of the relevant file.
- **Read consumer contract** — read the named reference doc; confirm the planned change does not break stated consumers. No further gate required unless the read surfaces a conflict.

---

## How to use this file mid-incident

In `/resolve-incident` Step 2:

1. Read this file.
2. For each file or directory the proposed fix would touch, check whether it matches any row above (exact match or glob match).
3. If yes → set `PROTECTED = yes`, apply the required review for that zone before proceeding past Step 4.
4. If no match → `PROTECTED = no`, continue.

A fix may touch multiple zones. Each zone's required review applies independently.
