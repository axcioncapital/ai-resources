# Sonnet 200k Session Efficiency — Implementation Plan

**Date:** 2026-05-25
**Diagnostic source:** `ai-resources/audits/sonnet-200k-efficiency-diagnostic-2026-05-25.md`
**System owner advisory:** Function B pre-change, 2026-05-25
**Intended execution:** Separate session (this session is planning only)

---

## Context

A ChatGPT advisory produced 10 recommendations for using Sonnet 200k more efficiently. The diagnostic mapped each against current infrastructure and the system-owner consult evaluated each against documented workspace principles. The net result: 4 items to adopt as hardening, 1 to reject, 1 to defer, 1 to reshape, and 3 already substantially covered.

This plan covers only the items the system-owner advisory greenlit for adoption. The rejected, deferred, and already-covered items are documented in the diagnostic and require no execution.

---

## Pre-execution gates

Before running any task in this plan, the execution session should:

1. Read this plan in full.
2. Read the diagnostic for context: `ai-resources/audits/sonnet-200k-efficiency-diagnostic-2026-05-25.md`.
3. Run `/scope` to lock the deliverables.
4. Run `/session-plan` to declare intent + phase plan.
5. Confirm operator model selection (do not declare a default).

---

## Task list (sequenced foundational → dependent)

### Task 1 — Add named compaction checkpoints to compaction-protocol.md

**Recommendation:** #7
**File:** `ai-resources/docs/compaction-protocol.md`
**Type:** Documentation-only edit.
**Risk-check class:** None required — docs-only edit; not in enumerated classes per `docs/audit-discipline.md` § Risk-check change classes.
**Effort:** ~15–30 minutes.

**Change:**
Add a new section "Named checkpoints" listing four compaction-trigger points where the session should write a durable state summary to disk before compacting (or before `/clear`):

1. **Post-inspection** — after initial discovery and file reads, before edits begin.
2. **Post-implementation** — after the main edit/draft phase, before QC.
3. **Post-QC** — after QC findings are recorded, before fix application.
4. **Pre-closeout** — before `/wrap-session` runs, summarizing state for next session.

For each checkpoint, define:
- What state must be on disk before compacting (file list, decision list, current step ID).
- Recommended target file (`logs/session-notes.md`, `logs/scratchpads/`, or session-plan.md).
- Whether `/clear` or `/compact` is preferred at that point.

**Acceptance criteria:**
- Four named checkpoints added with explicit state requirements.
- No conflict with existing "prefer `/clear` over `/compact`" guidance.
- The existing two rules in `compaction-protocol.md` (Pre-compact checkpoint, Post-compact resumption) are preserved verbatim; the Named checkpoints section is appended below them.
- One-line pointer added in `.claude/commands/wrap-session.md` Step 0.5 (after the existing scratchpad body — does not replace or alter scratchpad mechanics) and in `.claude/commands/session-plan.md` (read the file to identify the right section before inserting).

**Stop condition:** File saved, cross-references added, no other docs touched.

---

### Task 2 — Add output cap to qc-reviewer agent

**Recommendation:** #5
**File:** `ai-resources/.claude/agents/qc-reviewer.md`
**Type:** Canonical-agent edit.
**Risk-check class:** Edit to existing agent. Per `docs/audit-discipline.md` § Risk-check change classes, editing an existing agent is not in the enumerated classes (the list covers *new* commands or skills, not edits to existing ones). `/risk-check` optional — invoke given the auto-symlink blast radius to every project.
**Blast radius:** Every project running `/qc-pass` (auto-symlinked).
**Effort:** ~20–40 minutes.

**Change:**
Add an explicit output cap to the qc-reviewer agent body:

- Maximum findings: 10 (chosen to avoid truncating legitimate QC catches; read `ai-resources/.claude/agents/refinement-reviewer.md` at execution time to confirm parity or divergence with that agent's cap before committing).
- Required output shape: pass/fail verdict + findings list + concrete fix recommendation per finding.
- Full QC notes optional, written to `audits/working/` only if a finding requires extensive context.

**Acceptance criteria:**
- Output cap added to agent body.
- Cap is high enough that legitimate findings are not truncated (sanity-check: review last 3 `/qc-pass` invocations to confirm none exceeded 10 findings).
- If operator elects to run `/risk-check`: fire plan-time + end-time (two-gate model per `docs/audit-discipline.md`).

**Stop condition:** Agent file saved, no other agent files touched.

---

### Task 3 — Extend session-start to capture allowed_inputs and required_outputs

**Recommendation:** Reshaped #2 + #3.
**File:** `ai-resources/.claude/commands/session-start.md`
**Type:** Command edit.
**Risk-check class:** Edit to existing command. Per `docs/audit-discipline.md` § Risk-check change classes, editing an existing command is not in the enumerated classes. Fields are optional — no cross-cutting rule change. `/risk-check` optional; invoke at operator discretion.
**Effort:** ~30–60 minutes.

**Change:**
Add two new optional mandate fields to the session-start command:

- `allowed_inputs:` — explicit list of files/directories the session is authorized to read. If omitted, defaults to current behavior (no restriction).
- `required_outputs:` — explicit list of files/artifacts the session is expected to produce. If omitted, defaults to inferring from work_scope.

Both fields:
- Optional, not required (preserves existing operator workflow, respects OP-2 autonomy default).
- Captured by parsing operator correction syntax (`field: replacement`) consistent with current parse contract.
- Appended to the Mandate line in `logs/session-notes.md` only when populated.

**Explicit non-changes (rejected from ChatGPT bundle):**
- No "do-not-load list" field — system-owner advisory rejected as speculative (AP-7).
- No required-field promotion — fields remain optional to preserve autonomy default.

**Acceptance criteria:**
- Two new fields added with optional semantics.
- `.claude/commands/session-start.md` Step 3 bullet format extended with two new optional bullets (written only when operator provides a value; omitted entirely when not provided — no `(none stated)` placeholder):
  ```
  - Allowed inputs: {value}
  - Required outputs: {value}
  ```
- Parse contract note in `session-start.md` Step 3 updated to name the two new bullet labels.
- `.claude/commands/wrap-session.md` Step 7a updated to recognize `- Allowed inputs:` and `- Required outputs:` labels in coaching classification (classify as specified/omitted in Mandate fields output). Existing three-bullet parsing unchanged.
- Existing sessions continue to work unchanged when fields are omitted.
- `wrap-session.md` Step 7b's coaching-data entry will automatically reflect the new labels in the `specified`/`omitted` lists once Step 7a recognizes them — confirm this is the intended behavior (not a defect) before committing.
- `/qc-pass` after edit.

**Stop condition:** `.claude/commands/session-start.md` saved, `.claude/commands/wrap-session.md` Step 7a updated, no other command files touched.

---

### Task 4 — DEFERRED — Discovery-first pattern reference doc

**Recommendation:** Reshaped #8.
**Disposition:** Deferred. DR-7 trigger not yet met.
**Reason:** Per system-owner advisory (Function B, 2026-05-25): audit-shaped commands already practice discovery inline; a second advisory recommending the pattern is not a second *consumer*. The bar is that a command body must cite the pattern doc and would degrade without it.
**Trigger to revisit:** Land Tasks 1–3. Then pick one heavy command (`/friday-checkup`, `/risk-check`, `/repo-dd`, or `/audit-repo`), add an inline discovery-first instruction to its body. If a second command then needs the same instruction, write `ai-resources/docs/discovery-first-pattern.md` and refactor both to cite it. Until then, the pattern stays inline.

---

### Task 5 — OPTIONAL — Heavy-read discipline reference doc

**Source:** Second ChatGPT advisory (20-point read discipline advisory, 2026-05-25); system-owner advisory (Function B, 2026-05-25).
**Disposition:** Greenlit by system-owner as the single sound action from the second advisory — but optional, not required.
**What it is:** A new load-on-demand reference doc `ai-resources/docs/heavy-read-discipline.md` covering:
- Which commands legitimately read archive/historical directories (`/log-sweep`, `/wrap-session`, `/repo-dd`, `/friday-checkup`) and why.
- What the default read floor looks like for normal sessions (tie to `[HEAVY]` guardrail rather than a mandate-level field).
- What not to read by default in normal sessions (archive, old reports, superseded drafts).

**Why not permission denies or a `read_budget` mandate field:** Both were evaluated and rejected by the system-owner advisory — permission denies conflict with OP-2 and AP-7 and have blast radius on the four named commands; a `read_budget` field duplicates `[HEAVY]`, expands the parse contract, and binds at mandate-time against an uncalibrated number.
**If operator elects to add this:** Documentation-only; no risk-check class. Route: `ai-resources/docs/heavy-read-discipline.md`. No dependency on Tasks 1–4.

---

## Items explicitly excluded from this plan

The following items from the ChatGPT bundle are NOT in the plan, with reason:

| Item | Status | Reason |
|---|---|---|
| #1, #4, #10 | Already covered | No action; documented in diagnostic. |
| #6 (continuous main-session externalization) | Rejected | Speculative; DR-7 violation; no confirmed second consumer. |
| #9 (90/10 Sonnet/Opus ratio doctrine) | Rejected | Direct conflict with workspace CLAUDE.md § Model Tier; same concern already addressed by QS-5 per-task tier judgment. |
| #3 "do-not-load list" | Rejected | Speculative defensive scaffolding (AP-7); conflicts with OP-2 autonomy default. |
| Closeout report template promotion from harness/prep | Rejected | Crosses harness/Claude-Code boundary (system-doc.md § 1.1). |
| Permission deny rules for archive directories (2nd advisory) | Rejected | AP-7 (speculative), OP-2 conflict, blast radius on /log-sweep, /wrap-session, /repo-dd, /friday-checkup. Route to docs reference instead. |
| `read_budget` mandate field (2nd advisory) | Rejected | Duplicates `[HEAVY]` guardrail, OP-2 binding-at-mandate conflict, expands parse contract. Route to same docs reference. |
| Un-deferring Task 4 based on named candidates (2nd advisory) | Rejected | DR-7 bar requires a command body citing the pattern, not candidates that would benefit. |

---

## Execution sequencing

Run in order — earlier tasks are foundational, later tasks depend on the discipline established by earlier ones:

1. **Task 1 first** (docs-only, zero risk, highest leverage).
2. **Task 2 second** (canonical-agent edit, optional risk-check). Independent of Task 1.
3. **Task 3 third** (command edit with two-end parse-contract update).

Note: this is **risk-ordered, not dependency-ordered**. Tasks 1, 2, and 3 are technically independent (disjoint files, disjoint behaviors). If Task 1 or Task 2 hits an unexpected blocker, the execution session may proceed to Task 3 without waiting.
4. **Task 4 deferred** — do not execute this session.
5. **Task 5 optional** — write `ai-resources/docs/heavy-read-discipline.md` at operator discretion. No dependency on Tasks 1–4; can run in the same session or a later one.

Each task ends with a commit. Per workspace commit rules: stage relevant files, commit with heredoc message, do not push (operator-approved).

---

## Verification (per task)

| Task | Verification |
|---|---|
| 1 | Read updated `compaction-protocol.md`; confirm 4 checkpoints named; confirm one-line pointers added in `wrap-session.md` Step 0.5 and `session-plan.md`. |
| 2 | Read updated `qc-reviewer.md`; confirm cap present; verify by spawning `/qc-pass` on a small artifact and counting findings in the return. |
| 3 | Read updated `.claude/commands/session-start.md`; confirm two new optional bullet labels added to Step 3 format and parse contract note. Read updated `.claude/commands/wrap-session.md` Step 7a; confirm new labels recognized. Trigger session-start with both fields populated and confirm they land in `logs/session-notes.md`; trigger with fields omitted and confirm legacy behavior unchanged. |
| 5 (optional) | Read `ai-resources/docs/heavy-read-discipline.md`; confirm it covers archive-read discipline + read-floor guidance; confirm `/log-sweep`, `/wrap-session`, `/repo-dd`, `/friday-checkup` named as legitimate archive-reading commands. |

---

## Total estimated effort

- Task 1: 15–30 minutes
- Task 2: 20–40 minutes
- Task 3: 30–60 minutes
- Task 5 (optional): 20–30 minutes
- **Required total: ~65–130 minutes** plus `/scope`, `/session-plan`, commits, and verification.

Fits comfortably in one Sonnet 200k session if executed sequentially with the disciplined work-unit pattern recommended in the ChatGPT advisory itself.

---

## Next session opening

```
/prime
/session-start
/scope  (read this plan; lock deliverables)
/session-plan  (three tasks, sequential)
```

Then execute Task 1 → commit → Task 2 (with risk-check) → commit → Task 3 (with qc-pass) → commit → `/wrap-session`.
