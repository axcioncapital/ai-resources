# Friday Act Plan — 2026-07-17 — improvement-log-closure

**Source report:** friday-checkup-2026-07-17.md (weekly tier, recovery run)
**Journal report:** (none — freshest is 2026-05-29, outside the 7-day window)
**Generated:** 2026-07-17
**Items:** 3

> **This is the spine of the week (System Owner triage, `consult-2026-07-17-friday-act-weekly-triage.md`).**
> The real constraint is CLOSURE, not detection: the ai-resources improvement-log holds ~46 active
> entries / 94 entry-headers — 6.5–13× the soft cap of 7. Principle OP-12 (closure before detection).
> Clearing the backlog is the highest-ROI act this cadence; do this plan first.

> **⚠ EXECUTION PRECONDITION (DR-10 — concurrent session).** A live foreign session marker was present
> in the ai-resources main checkout at plan time (`LIVE_FOREIGN_HERE=1`). All three items below edit
> `logs/improvement-log.md`, which takes **in-place** status flips / entry archiving (not atomic appends)
> — a genuine lost-update surface. **Do not execute until the concurrent session has cleared** (re-check
> at execution: no foreign `logs/.session-marker-*` dated today besides your own). Run `/concurrent-session-check`
> first if unsure.

## Items

### 1. [med] Decide the 19 [STALE] improvement entries pending 29–53 days
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- Detail: for each of the 19 entries the checkup listed (Purge `[1m]`/1M-context declarations; /new-project symlink registration; check-foreign-staging fails-open for footprint-less sessions; non-/prime session start writes no per-id marker; split-log.sh tripwire propagation; graduation-verdict second-consumer test; PreToolUse QC-PENDING commit-block hook; /create-requirements-doc; mission promote-rw-canonical close findings; Routine-Yield Review; shared rendering-convention doc; /pm forward-looking handling; sub-subagent dispatch limitation; /pm internal QC step; B-04/S-04 extraction; placement-verifier four-pipeline extension; Q1–Q8 placement logic extraction; fix-spec Milestone 4 follow-ups; refresh-project-state read-surface hardening) decide one of: **apply now** (small, closes a real gap), **defer-with-Review-cycle** (park via `Review-cycle:` reset — the canonical park), or **close** (superseded / no longer worth doing).

### 2. [med] Verify-or-close the 7 applied-but-unverified improvements (2026-07-13/14)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- Detail: the checkup flagged 7 entries marked `applied`/`verified-resolved` on 2026-07-13/14 that need a confirming read (the filesystem is the source of truth, not the status line). Confirm each fix is on disk as described, then flip to `verified` or re-open. Several were verified in the S1-d99 wrap already — reconcile against that.

### 3. [low] `/resolve-improvement-log` — archive the applied+verified entries pending archive
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- Detail: run `/resolve-improvement-log` to move `applied`/`verified` entries into `improvement-log-archive.md`. **SO mis-prioritization correction:** originally defaulted to defer — moved to fix-now because it is the cheapest loop-closer and deferring the archive while doing items 1–2 is backwards. Run this **last** in the plan, after items 1–2 have flipped statuses, so it sweeps the maximum set in one pass.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- **Precondition above is BLOCKING** — confirm the concurrent session has cleared before editing `improvement-log.md`.
- No item here is a `/risk-check` change class (all are log-content edits) — no risk-check gate.
- Run `/wrap-session` when all items in this plan are done.
