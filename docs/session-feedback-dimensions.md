# Session Feedback Dimensions

> **When to read this file:** Read by the `session-feedback-collector` agent on every invocation (it is the agent's measurement rubric). Also read when tuning what `/wrap-session` Step 6.5 collects. Not always-loaded; not read on ordinary turns.

## Purpose

This is the stable rubric the per-session feedback collector measures a session against. It exists so the collector reads a fixed reference instead of re-synthesizing the system's goal state every run. It **cites** the canonical goal-state sources rather than restating them — those sources stay the single source of truth (DR-5).

**Goal-state sources (do not duplicate — read these for the actual definitions):**
- `projects/repo-documentation/vault/architecture/system-doc.md` §2 (System Vision and Target State: six goals + four self-* properties) and §4.5 (Information Flows and Feedback Loops, including the *open* loops).
- `projects/repo-documentation/vault/principles/principles.md` — OP-1 (north star: compound toward autonomous operation), OP-9 (anti-speculation constraint), OP-11 (surfacing principle drift is a recurring obligation).
- Workspace `CLAUDE.md` § Autonomy Rules (the pause-list) and `ai-resources/docs/audit-discipline.md` § Risk-check change classes — the danger surface for the safety dimension.
- `projects/repo-documentation/vault/architecture/risk-topology.md` — load-bearing components.

## What this collector is (and is NOT)

It is a **collector**, not an analyzer. It extracts per-session signals and routes them to existing consumer-backed stores. It does **not** propose fixes (that is `/improve`), synthesize across sessions (that is `/friday-so` / `systems-review`), or check the deliverable against its brief (that is `/contract-check`). The genuine gap it fills: structured signal capture at wrap time, which every downstream analyzer misses because they all run after the session reading logs.

## The five dimensions

For each dimension the collector pulls concrete signals from the just-written session note (and inspects named artifacts where useful), then routes them. Routing targets are limited to **two shared-state logs** plus the assessment block — see § Routing.

| # | Dimension | Grounds in | What to capture |
|---|---|---|---|
| 1 | **Autonomy-compounding** | OP-1, OP-9, system-doc §2.1 (Compounding value) | Did the session leave a reusable improvement, or only one-off work? A component/pattern worth generalizing? Conversely, did it do speculative work with no confirmed consumer (OP-9 violation)? |
| 2 | **Leanness / cost** | system-doc §2.5 (context + token + speed constraints) | Token/context cost out of proportion to value; always-loaded weight (CLAUDE.md lines, hooks) added without earning it; rework churn. |
| 3 | **Principle-adherence drift** | OP-11, system-doc §4.5 (open loop: principles → live enforcement) | A session that strained or violated a named OP-/DR-/QS-/AP- principle. OP-11 makes surfacing this a recurring obligation — this is the manual stand-in until automated enforcement (W2.2) exists. |
| 4 | **Friction** | system-doc §4.5 (session improvement loop), AP-9, AP-11 | Where the operator intervened, repeated feedback, or fought the system. Classify the friction *type* (AP-9), do not just record the symptom. |
| 5 | **Safety / guardrail-gap** | Workspace `CLAUDE.md` § Autonomy Rules pause-list; `audit-discipline.md` § Risk-check change classes; risk-topology.md | An irreversible/destructive/external action taken or nearly taken; a gate that *should* have fired but didn't; prompt-injection encountered in tool output; a shared-state clobber; a deletion outside session scope. This is the data the operator uses to design guardrails later. |

## Routing (where each signal goes)

The collector writes **only** these two shared-state logs, plus its own assessment block. It never writes `usage-log.md` (that is `/usage-analysis`), `coaching-data.md` (that is `/coach`), or `maintenance-observations.md` (per-`/friday-act`-block schema — incompatible with per-session appends).

| Signal | Routes to | Consumed by |
|---|---|---|
| Friction (dim 4) | `logs/friction-log.md` | `/improve` → Friday review |
| Improvement / optimization (dims 1, 2) | `logs/improvement-log.md`, `Category: session-feedback` | `/friday-checkup`, `/friday-act` |
| Principle-adherence drift (dim 3) | `logs/improvement-log.md`, `Category: principle-drift` | `/friday-checkup`, `/so-monthly` |
| **Safety / guardrail-gap (dim 5)** | `logs/improvement-log.md`, `Category: guardrail-candidate`, `Severity: high\|med\|low` | `/friday-act` (implements the guardrail). **High-severity also surfaced in chat at wrap.** |
| Reusable component produced (dim 1) | **Not written to the registry.** Surfaced in the assessment block as a "consider `/innovation-sweep`" nudge. | operator decision |

## Severity scale (dimension 5 only)

- **high** — an irreversible/destructive/external action *was actually taken* without a gate, or a clear prompt-injection was acted on. Surface in chat immediately.
- **med** — a near-miss: the action was nearly taken but caught, or a gate fired late.
- **low** — a latent gap: no harm occurred, but a guardrail would close a hole the session exposed.

## Hard constraints on the collector (load-bearing — risk-check mitigations)

1. **Enforced per-session append cap (fail loud, not silent).** `/friday-checkup` blocks Friday execution when `improvement-log.md` exceeds 7 active entries (`friday-act.md` soft-cap). The collector therefore appends **at most 2 entries to `improvement-log.md` per session**, with `guardrail-candidate` (safety) signals taking priority for a slot. `friction-log.md` is not soft-capped but the collector still caps friction appends at ~3 to avoid noise. Any signal beyond the cap is **listed in the assessment block** with a visible "N further signals not logged (per-session cap)" line — never silently dropped (OP-3).
2. **Provenance tag on every appended entry.** Every collector-written entry is visibly machine-authored so the Friday pipeline can rank operator-authored signal above machine-extracted signal (QS-9, AP-4). `improvement-log.md` entries carry a `**Provenance:** wrap-collector (machine-authored) {date}` field; `friction-log.md` entries are prefixed `**[wrap-collector]**`. This tag doubles as the revert marker — a single grep prunes all collector entries if the change is rolled back.
3. **Dedup before append.** Check each candidate against active `improvement-log.md` entries + `improvement-log-archive.md`; do not re-log a signal that already has an entry.
4. **No grading, no fabrication.** Capture, do not score the operator or the work. If the session note is too thin to assess a dimension, say so for that dimension — never invent signal (AP-2).
