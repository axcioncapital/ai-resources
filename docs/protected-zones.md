# Protected Zones

> **When to read this file:** `/resolve-incident` Step 2 reads it to classify whether a proposed fix touches a protected zone. Maintainer: operator. Update condition: a new shared asset class appears in the repo, or a `/friday-checkup` round flags a missing zone.
>
> **Owner:** operator (Patrik). **Purpose:** pre-classification lookup for the incident pipeline — answers "is this path protected?" with a yes/no + required review path. **Update condition:** add a row when a real incident exposes a missing zone; do not add rows speculatively.

---

## Zone list

| Path or glob | Why protected | Required review |
| --- | --- | --- |
| `CLAUDE.md` (workspace root + ai-resources) | Always-loaded into every session; every rule change affects all future turns | `/risk-check` mandatory; `/consult` if the change is structural or non-trivial |
| `.claude/hooks/*.sh` | Per-session-event runtime; failure modes are often invisible until something breaks | `/risk-check` mandatory |
| `.claude/settings.json` (any layer) | Permission surface and hook wiring; changes can silently block or over-allow tools | `/risk-check` mandatory |
| `.claude/commands/*.md` (shared — in `ai-resources/`) | Autosynced to all projects; a behavior change affects every project session | `/risk-check` if behavior-changing; cosmetic/doc edits may skip |
| `.claude/agents/*.md` (shared — in `ai-resources/`) | Autosynced to all projects; scope or authority changes affect all downstream invocations | `/risk-check` if behavior-changing; `/consult` if scope or authority changes |
| `templates/**` | Consumer contract bound to `/new-project` and `/deploy-workflow`; changing a template changes every future scaffold | Read `templates/README.md` consumer-contract section before any edit |
| `docs/repo-architecture.md` | Source-of-truth for `/route-change` routing; stale map produces wrong placement recommendations | `/risk-check` mandatory |
| `docs/audit-discipline.md` | Defines the mandatory `/risk-check` change classes; editing it redefines when the gate fires | `/risk-check` mandatory |
| `docs/autonomy-rules.md` | Defines the operator-confirmation gates (Autonomy Rules #1–#10); editing it changes when Claude stops | `/risk-check` mandatory |
| `docs/qc-independence.md` | Defines QC methodology and auto-loop mechanics | `/risk-check` if changing methodology; cosmetic edits may skip |
| `logs/improvement-log.md` (schema block only) | Two-end contract between `/friday-act`, `/resolve-repo-problem`, and `/resolve-incident`; schema changes break consumers | Read schema block before any schema change; align all consumers in the same commit |

---

## What "elevated review" means here

- **`/risk-check` mandatory** — run `/risk-check <description>` before implementing the change. A RECONSIDER verdict blocks — do not proceed. A PROCEED-WITH-CAUTION verdict requires applying all listed mitigations.
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
