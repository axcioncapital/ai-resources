# Session Plan (pass2) — 2026-05-28

> **Concurrent-session note:** This pass2 file holds the Wave 3 session plan. The canonical `logs/session-plan.md` is held by a concurrent Wave 2 session (intent: "Execute the Wave 2 fix plan ... 8 single-file edits across /prime, hooks, and docs"). Both plans touch `/prime` — see the Concurrent-session warning under Autonomy Posture below for the read-from-disk protocol that protects against in-context staleness.

## Intent
Execute the Wave 3 fix plan at `audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave3-structural.md` — 4 structural items, each requires its own `/risk-check`. Land `id-31` Phase 1 (`.session-marker` write) first; re-evaluate items 2–4 (`id-09`, `id-32`, `nordic-pe-macro/id-13`) against the new state before applying. Do NOT batch.

## Class
execution

## Model
opus — match (active: `claude-opus-4-7[1m]`). Judgment-heavy: 4 `/risk-check` verdicts, mitigation acceptance per item, post-`id-31` re-evaluation of items 2–4, per-item `/qc-pass`. Doing-with-deciding-at-every-gate, not pure mechanical execution.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave3-structural.md` — the plan being executed
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — id-31 edit target (Steps 8a.3.a, 8b.1, 8c.3 marker-write sites; brief footer)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — id-09 + id-32 edit target (canonical; Step 3.5)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` — id-09 + id-32 paired workspace-root copy (PAIRED CONTRACT)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` — id-13 edit target (Step 0 MISMATCH branch wrap-state check)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md` — gate command
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` — status-flip schema
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — source entries (id-31 at :183, id-32 at :248) + new entry for id-09
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` — source entry (id-13 at :172)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — entry :85 (`Resolved:` annotation for id-09)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes + risk-check rules

## Findings / Items to Address

1. **id-31 Phase 1 — `/prime` writes `logs/.session-marker`** ([source: ai-resources improvement-log.md:183]). `/prime` Steps 8a.3.a / 8b.1 / 8c.3 currently capture only `.prime-mtime`. Add a 4-char session marker (`S1`/`S2`/…) written alongside: increment if same-day file exists, reset to `S1` otherwise. Add `logs/.session-marker` to `.gitignore`. Surface value in brief footer (`Session marker: {value}`). Phase 1 only — Phases 2–4 (consumer reads, file-naming switch, legacy cleanup) explicitly deferred per source entry's migration plan. Update supersession note on improvement-log.md:174.
2. **id-09 — `/wrap-session` Step 3.5 guard reads per-session task count** ([source: ai-resources friction-log.md:85 — 2026-05-28 14:20 Step 3.5 false-positive on chained auto-mode]). Current guard math: `FOREIGN_HEADERS = ADDED_HEADERS - 1`. New math: `FOREIGN_HEADERS = ADDED_HEADERS - PRIME_TASKS` where `PRIME_TASKS` defaults to 1 if marker absent. `/prime` Step 8c (auto-mode) writes incremented count to `.prime-mtime` payload OR sibling `.prime-task-count`. Edit BOTH canonical (`ai-resources/.claude/commands/wrap-session.md`) AND workspace-root paired copy (`~/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md`) per PAIRED CONTRACT. New improvement-log entry; annotate friction-log:85 with `Resolved:` line. **Re-evaluation gate after id-31 lands:** check whether `.session-marker` payload can subsume the per-session task-count signal, possibly merging this into id-31's marker schema.
3. **id-32 — `/wrap-session` Step 3.5 CONCURRENT / REMNANT / MIXED classifier** ([source: ai-resources improvement-log.md:248]). Patch Step 3.5 to parse the enclosing `## YYYY-MM-DD` header of each extra mandate detected by the foreign-guard: today-dated → CONCURRENT (current warn); prior-day-dated → REMNANT (offer "commit orphan as standalone wrap-recovery commit" path); both → MIXED (warn both, ask operator). Update canonical + paired workspace-root copy. Flip improvement-log.md:248 to `applied {date}` + `Verified:` + risk-check ref. **Re-evaluation gate after id-31 lands:** classifier reads dates from header text independent of marker identity — confirm still needed (likely yes).
4. **nordic-pe-macro/id-13 — `/session-plan` Step 0 wrap-state check** ([source: projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:172]). Extend `/session-plan` Step 0 MISMATCH branch (`ai-resources/.claude/commands/session-plan.md`, ~Step 0 sub-step 5–6 region) to check whether the existing plan's session has wrapped. Wrap-signal candidates: grep `logs/session-notes.md` for matching `## {plan_date}` header that ALSO contains `### Summary` + `### Next Steps`, OR `git log --grep='^session: {date} wrap'`. If wrapped → allow plain overwrite of `session-plan.md`; if not wrapped → preserve current MISMATCH → `pass2.md` routing. Flip improvement-log.md:172 to `applied {date}` + `Verified:` + risk-check ref. **Re-evaluation gate after id-31 lands:** marker presence alone does not indicate wrap status — confirm classifier still independent of marker (likely yes).

## Execution Sequence

1. **Pre-flight read.** Read source improvement-log entries for id-31 (:183), id-32 (:248), nordic id-13 (:172), and friction-log :85 in full. Read `docs/audit-discipline.md § Risk-check change classes`. Read `.claude/commands/resolve-improvement-log.md` for status-flip schema. **Verification:** confirm source entries are at the cited line numbers (they may have shifted since the plan was written).
2. **Item 1 — id-31 Phase 1.**
   a. **Re-read `prime.md` from disk** (Wave 2 may have edited it; in-context state stale). Draft `/prime` edits (3 marker-write sites + brief footer) inline; draft `.gitignore` line addition.
   b. Run `/risk-check` on the drafted change. **Verification:** verdict captured to `audits/risk-checks/2026-05-28-prime-session-marker-write.md`.
   c. On GO → apply edits. On RECONSIDER → apply named mitigations inline, then re-verify. On NO-GO → STOP, surface to operator.
   d. Apply `/qc-pass` on the edits. **Verification:** REVISE findings either resolved inline or surfaced.
   e. Smoke test: walk the edited steps against the actual file write logic to verify marker generation round-trips. (Cannot execute `/prime` from within `/prime` — manual trace only.)
   f. Flip improvement-log.md:183 status to `Phase 1 applied 2026-05-28` + `Verified:` line + annotate Phases 2–4 `pending`. Update supersession note on :174.
   g. Commit.
3. **Re-evaluation gate.** Re-read items 2, 3, 4 plan text against the post-id-31 state. For each, decide: still-needed (proceed as planned), modified (note the change inline before risk-check), or obsoleted (skip + log). **Verification:** explicit GO/MODIFY/SKIP decision recorded inline for each before moving on.
4. **Item 2 — id-09.**
   a. **Re-read `wrap-session.md` (canonical + paired) from disk** before drafting. Draft Step 3.5 guard math change for BOTH copies; draft `/prime` Step 8c (auto-mode) increment logic.
   b. `/risk-check`. **Verification:** report at `audits/risk-checks/2026-05-28-wrap-session-prime-tasks-counter.md`.
   c. Apply per verdict (GO / RECONSIDER+mitigate / NO-GO+stop).
   d. `/qc-pass`. **Verification:** canonical and paired copy in sync.
   e. Add new improvement-log entry; annotate friction-log:85 with `Resolved:` line.
   f. Commit.
5. **Item 3 — id-32.**
   a. Draft Step 3.5 classifier (today / prior-day / both) for canonical + workspace-root paired copy.
   b. `/risk-check`. **Verification:** report at `audits/risk-checks/2026-05-28-wrap-session-concurrent-remnant-mixed-classifier.md`.
   c. Apply per verdict.
   d. `/qc-pass`. **Verification:** canonical and paired copy in sync.
   e. Flip improvement-log.md:248 to `applied 2026-05-28` + `Verified:` + risk-check ref.
   f. Commit.
6. **Item 4 — nordic id-13.**
   a. Draft `/session-plan` Step 0 MISMATCH-branch wrap-state check (lines 56–60 region in current `session-plan.md`).
   b. `/risk-check`. **Verification:** report at `audits/risk-checks/2026-05-28-session-plan-wrap-state-check.md`.
   c. Apply per verdict.
   d. `/qc-pass`.
   e. Flip nordic improvement-log.md:172 to `applied 2026-05-28` + `Verified:` + risk-check ref.
   f. Commit.
7. **Post-wave wrap.** Confirm 4 risk-check reports + 4 status flips + 1 new improvement-log entry (id-09) + 1 friction-log annotation. Recommend operator run `/wrap-session` (do not auto-invoke).

## Scope Alternatives

- **Min (id-31 only):** ~30 min. Land Phase 1 marker, status-flip its entry, commit. Stop. Allows next session to re-evaluate items 2–4 with fresh context. Pick if context budget is tight or `/risk-check` returns RECONSIDER with non-trivial mitigations on item 1.
- **Recommended (id-31 + items 2–4 in sequence):** ~2–3 hours. Full plan as written. Per-item risk-check + re-eval gate after item 1 preserved.
- **Max (recommended + Phase 2 of id-31 starter):** ~3–4 hours. After items 1–4 land, draft (not apply) the Phase 2 marker-consumer reads in `/session-start` and `/session-plan` as the next-wave plan file. **Reject by default** — Phases 2–4 are explicitly out of scope per the source entry's migration plan; doing them now defeats the staged-rollout protection.

## Autonomy Posture
Gated

**Stop points:**
- After each `/risk-check` verdict: NO-GO → halt and surface; RECONSIDER → apply named mitigations inline, then proceed without re-verify (per workspace `feedback_end_time_risk_check_skip`-style judgment — only halt if mitigations are non-trivial or unclear).
- After id-31 Phase 1 lands and is QC-clean: **mandatory re-evaluation gate** for items 2, 3, 4. Decide GO/MODIFY/SKIP for each before continuing.
- After each `/qc-pass` REVISE verdict: resolve inline if findings are scoped (single-file, single-edit); surface to operator if findings touch architectural assumptions.
- **Concurrent-session warning (Wave 2):** Wave 2 is concurrently editing `/prime` (its items 1–3 all edit `prime.md`) and may touch `wrap-session.md`. Before EVERY edit in items 1, 2, 3 of this plan, **re-read the target file from disk**; do not assume in-context state matches HEAD. If Wave 2 commits between this session's draft and apply, abandon the in-context draft, re-read, re-draft. Surface immediately if Wave 2 has touched my edit region.
- `[COST]` guardrail: 4 `/risk-check` dispatches + 4 `/qc-pass` calls + likely 1–2 `/triage` if QC verdicts are non-trivial. Expected high subagent count; if exceeded, surface and ask whether to defer remaining items.

## Risk
Run `/risk-check` per item (4 total). The fix plan itself states every item is a structural change class — cross-cutting protocol changes (id-31), shared-state automation (id-09, id-32), and load-bearing collision-detection logic (id-13). Per workspace Autonomy Rules #9 and `docs/audit-discipline.md § Risk-check change classes`, plan-time `/risk-check` is REQUIRED before each item's edit. End-time `/risk-check` may be skipped per `feedback_end_time_risk_check_skip` if plan-time covered with mitigations applied AND `/qc-pass` clean AND drift bounded — document any skip in the wrap.

**Tripwire fires:** id-09 and id-32 both *reorder operations against shared state* (`logs/session-notes.md` mandate counting; date-header classification). Cannot exempt under "existing-command refactor" framing.

**Concurrent-session amplifier:** Wave 2 edits to `prime.md` may interact with this session's id-31 marker-write additions. Read-from-disk-before-every-edit is the mitigation; if Wave 2 and this session both modify `prime.md` Step 8a.3.a / 8b.1 / 8c.3 region, the second commit will need a rebase or merge resolution.
