---
description: Diagnose accumulated operational complexity in the repo — controls that fire always where they should be conditional, components that fail the complexity budget, and built-but-unwired orphans — and emit a disposition-grouped simplification plan. Diagnose-and-plan-only; never mutates the repo. Reads pre-existing on-disk audit outputs (does not re-run audits). Output to audits/lean-repo-YYYY-MM-DD.md.
model: opus
argument-hint: "[optional focus area, workflow, or known bottleneck]"
---

# /lean-repo — leanness & control-drift diagnosis → simplification plan

Assess the repository for *accumulated operational complexity* and produce a risk-annotated simplification plan. The objective is not maximum minimalism — it is the smallest system that reliably supports the repo's actual work, with critical controls preserved.

**Diagnose-and-plan-only. This command never mutates the repo.** Structural items in its plan route to a separate execution session, gated by `/risk-check` — the same diagnose→execute separation the workspace already uses (`/friday-checkup` → `/friday-act` → execution session; `/token-audit` "fixes happen in a separate session"). See **Closure channel** below.

**Boundary vs neighbours.** `/token-audit` measures *token cost*. `/audit-repo` scores *structural health*. `/architecture-review` *synthesises* the other audits into a severity-ranked health report. `/lean-repo` applies one lens none of them do — **is a control firing always where it should be conditional; does a component earn its keep; is it wired to anything** — and emits a *disposition-grouped plan* (Remove / Merge / Make-conditional / …), not a severity-ranked findings list. If this command ever starts producing a general health synthesis, it has drifted into `/architecture-review`'s job — the three questions in Step 3 are the guardrail.

> **Provenance / self-referential note (OP-11).** This command + its `lean-repo-auditor` agent are two net-new components introduced to *reduce* component sprawl — they fail prong (a) of their own complexity-budget gate (`docs/ai-resource-creation.md` rule #7). They ship under a **loudly-recorded OP-11 exception** justified by prong (b): the sprawl/over-control failure mode is evidenced (see `logs/decisions.md` 2026-07-04 entry), and this command consolidates a leanness lens otherwise scattered across five audits into one plan-producing pass. The exception is recorded, not assumed; the closure channel below satisfies OP-12. If a future review finds the lens is used rarely, the lean move is to fold it into `/architecture-review` and retire this command.

Input: `$ARGUMENTS` — optional focus area, workflow, or known bottleneck. If present, prioritise it while still checking repo-wide causes. If empty, run the full repo-leanness pass.

---

### Step 1 — Setup

1. Set `DATE` = today (`YYYY-MM-DD`).
2. Set `AI_RESOURCES` = absolute path to the `ai-resources/` directory. Set `WORKSPACE_ROOT` = its parent (the directory containing `ai-resources/`, `projects/`, etc.).
3. Set `AUDIT_ROOT` = `AI_RESOURCES` (plus `WORKSPACE_ROOT` for cross-repo consumers).
4. Set `OUTPUT_PATH` = `{AI_RESOURCES}/audits/lean-repo-{DATE}.md`. If it exists, append `-2`, `-3`, … until unique.
5. Set `WORKING_DIR` = `{AI_RESOURCES}/audits/working/`. Set `NOTES_PATH` = `{WORKING_DIR}/lean-repo-{DATE}-notes.md` (carry the same uniqueness suffix as `OUTPUT_PATH`).

---

### Step 2 — Locate the latest on-disk audit outputs (do NOT re-run them)

Glob for the most recent file of each type. All patterns are relative to `{AI_RESOURCES}/audits/` **except** `/architecture-review`, whose output lives under `{WORKSPACE_ROOT}/projects/` (rooted on the absolute `WORKSPACE_ROOT` from Step 1, not a relative hop). This command reads what already ran — it never invokes `/token-audit`, `/audit-repo`, etc.

| Audit | Glob pattern | Variable |
|---|---|---|
| `/token-audit` | `{AI_RESOURCES}/audits/token-audit-*.md` | `TOKEN_AUDIT` |
| `/audit-repo` | `{AI_RESOURCES}/audits/repo-health-*.md` | `AUDIT_REPO` |
| `/architecture-review` | `{WORKSPACE_ROOT}/projects/axcion-ai-system-owner/output/architecture-reviews/architecture-review-*.md` | `ARCH_REVIEW` |
| `/pipeline-review` | `{AI_RESOURCES}/audits/pipeline-reviews/*.md` | `PIPELINE_REVIEW` |
| `/friday-checkup` | `{AI_RESOURCES}/audits/friday-checkup-*.md` | `FRIDAY_CHECKUP` |

For each: if a match exists, take the most recent; tag it `fresh` if ≤14 days old, else `STALE` (record the path for the degraded-mode header). If no match, tag `MISSING`. Reuse `/architecture-review`'s degraded-mode discipline: a MISSING input degrades the pass but does not abort it — note the gap in the output header.

---

### Step 3 — Delegate to the `lean-repo-auditor` subagent

Spawn one `lean-repo-auditor` subagent (fresh context) via the `Task` tool, passing:
- `AUDIT_ROOT`, `NOTES_PATH`, `DATE`.
- `INPUT_FILES` — the five paths above, each with its `fresh` / `STALE` / `MISSING` tag.
- `EVIDENCE_LOGS` — `logs/friction-log.md`, `logs/coaching-log.md`, `logs/improvement-log.md`, `logs/defect-log.md`, `logs/incident-log.md`.
- `FOCUS` — `$ARGUMENTS` (or "none — full repo pass").

The agent applies the three distinctive questions (control-proportionality/drift, retroactive complexity-budget, orphan/adoption), writes full notes to `NOTES_PATH`, and returns a ≤30-line summary ending with `NOTES: {NOTES_PATH}`.

Read **only the returned summary** (per `ai-resources/CLAUDE.md` § Subagent Contracts — do not re-read the full notes unless a specific finding needs context). If the summary lacks the `NOTES:` last line, re-invoke once; if still malformed, proceed with the summary and note it in chat.

---

### Step 4 — Write the simplification plan

Write `{OUTPUT_PATH}`:

```
# Lean-Repo Simplification Plan — {DATE}

## Scope
{FOCUS, or "full repo-leanness pass"}. Inputs read: {list each with fresh/STALE/MISSING}.
[If any MISSING/STALE:] **[PARTIAL — degraded mode: {list}]**

## Executive Summary
{3–5 lines: the headline leanness findings and the single highest-drag bottleneck.}

## Simplification Plan (by disposition)
{From the agent notes. Group under: Remove / Merge / Make-conditional / Simplify / Defer-loading / Retain / Investigate.
Each structural item: component + path — disposition rationale — /risk-check change class (if any) — rollback note.}

## Orphan / Adoption (Q3) — scanned scope and its limits
**Scanned scope:** {the exact paths the agent grepped — copy verbatim from the agent's Q3 section}
**Known-positive check:** /explore-section — {FOUND | NOT FOUND}

{Q3 findings, each carrying the verdict `no evidence of use in scanned scope → CONFIRM BEFORE DELETE`.
If the known-positive check is NOT FOUND, write instead: **Q3 VOID — the orphan scan failed its own known-positive check; no orphan findings are reportable this pass.**}

> A zero-hit grep is a fact about the scan, not about the component. Usage also lives in scratchpads, in operator habit, and in un-logged invocations, and `logs/usage-log.md` has been opt-in since 2026-07-04 — absence of a log line is not absence of use. Nothing in this section is a deletion instruction.

## Top-5 Bottlenecks
{Ranked by operational drag, one line each.}

## Closure — how these land
Advisory plan. Structural items route to a separate /risk-check-gated execution session (see the command's Closure channel). Do not apply fixes from this session.

---
Working notes: {NOTES_PATH}
```

Preserve any `Retain` items explicitly — a leanness pass that only lists deletions is not credible; naming what is justified-and-proportionate is part of the deliverable.

---

### Step 5 — Chat report + closure bridge

Print to chat:
- The executive summary + the top bottleneck.
- Disposition counts (Remove N / Merge N / Make-conditional N / …).
- `Plan: {OUTPUT_PATH}`.
- The closure bridge (below).
- Remind the operator to run `/wrap-session` if the work is complete.

---

## Closure channel (OP-12 — detection ships behind its closer)

This command detects simplifications; it does not apply them. The closer is the workspace's existing diagnose→execute separation:

1. The plan's structural items are each tagged with their `/risk-check` change class and a rollback note — they are execution-ready.
2. They land in a **separate `/risk-check`-gated execution session** (never this one). During the Friday cadence, `/friday-act` is the recurring home for dispositioning a leanness plan into executable plan files; outside the cadence, run the items directly in a fresh session, each gated by `/risk-check` plan-time + end-time.
3. Removals/merges of commands, agents, hooks, or CLAUDE.md rules are structural change classes — they follow `docs/audit-discipline.md` and cannot be self-applied by the diagnosing session.

A `/lean-repo` plan with no execution path is exactly the OP-12 failure this command was built to avoid — always name the closure in the output.

## Guardrails

- **Never mutate the repo.** Advisory plan only. No file removals, no command/agent edits, no CLAUDE.md edits from a `/lean-repo` session.
- **Preserve critical controls.** Do not recommend removing security, backup, recovery, QC-independence, or destructive-op safeguards without a named replacement control. Controls that prevent material errors, context loss, or unrecoverable changes are `Retain` by default.
- **Prefer consolidation over deletion; conditional over mandatory; defer-loading over always-loaded.** Removing components you don't understand is not leanness.
- **Do not add process to remove process.** A recommendation that introduces a new command/agent/gate must itself clear the `docs/ai-resource-creation.md` rule #7 complexity budget, or it is not a simplification.
- **The three questions are the boundary.** Control-drift, budget-fail, orphan. If a finding is really "general health" or "token cost," it belongs to `/architecture-review` or `/token-audit` — route it there, don't restate it here.
- **Q3 never carries deletion authority.** An orphan finding is an *absence of evidence*, and this repo's usage evidence is distributed across project logs, scratchpads, and un-logged operator habit — no grep sees all of it. A Q3 finding is reported as `no evidence of use in scanned scope → CONFIRM BEFORE DELETE`, dispositioned **Investigate** (never **Remove**), with the scanned scope stated and the `/explore-section` known-positive check run. On 2026-07-13 the unqualified version of this lens produced an operator-approved instruction to delete six commands, four of them in live use. Do not restore the shorthand.
