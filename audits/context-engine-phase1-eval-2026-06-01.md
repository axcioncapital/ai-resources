# Context Engine — Phase 1 Evaluation

**Date:** 2026-06-01
**Evaluator:** Claude (Opus 4.8), Session S2
**Scope:** Score the context engine's packs on 5 real tasks against the 6 Brief-1 criteria. Carryover from S6/S9.
**Verdict:** **PASS** — 5 of 5 tasks score ≥4-of-6 (threshold: ≥3 of 5 must score ≥4-of-6).

---

## Method

The engine was evaluated against the 6 Brief-1 criteria, one point per criterion met:

1. **Right files** — pack surfaces the correct load-bearing files for the task.
2. **No missing dependencies** — pack includes all prerequisite files the task depends on.
3. **No stale content** — cited files/line-numbers are current, not outdated.
4. **Handoff improves execution** — frontmatter, missing-context flags, and handoff prompt tangibly help the next agent.
5. **Reduces operator effort** — using the pack is materially faster than manual context discovery.
6. **Safe to act from pack alone** — the agent can proceed on the pack without external clarification (completeness/safety).

Pass threshold: **≥3 of 5 tasks score ≥4-of-6**.

**Sample (5 packs).** Three are real packs produced during actual dev work (not synthetic test runs — stronger evidence); two were generated fresh from the Brief-1 suggested task list to cover task types not otherwise represented:

| # | Pack slug | Task | Type | Source |
|---|---|---|---|---|
| 1 | hook-20260601-c4e7a | Build concurrent-session detection hook | hook | real (S1 dev work) |
| 2 | project-20260529-s6w12 | Execute Friday-act Wave 1+2 items | project | real (S6 dev work) |
| 3 | command-20260529-7b2a4 | Make /friday-act auto-triage | command | real (S6 dev work) |
| 4 | architecture-20260601-a1c4f | Add a permission entry to settings.json | config* | fresh |
| 5 | command-20260601-c4e1a | Understand how /prime chains to /session-plan | comprehension | fresh |

**Verification depth.** Packs 1 and 5 were verified first-hand: I executed the hook task (#1) this session, and I executed the prime→session-start→session-plan chain (#5) this session — so both packs' factual claims were checked against lived reality, not just plausibility. Pack 4's line-number citations were spot-checked against disk (all accurate). Pack 2 was assessed against the recorded S6 session outcome in session-notes (the conflicts it flagged are the conflicts the S6 session actually hit). Pack 3's "no stale content" score was settled via git history rather than a current-disk spot-check — it was accurate at creation but has since been superseded by its own task's execution (see Task 3 caveat); this distinction was caught in QC and is reflected in the scoring.

---

## Per-task scores

### Task 1 — Hook (hook-20260601-c4e7a) — **5/6** ✓
- ✓ Right files — `files_in_scope` (hooks/, settings.json, session-marker.md) were exactly what the implementation touched.
- ✓ No missing deps — `allowed_inputs` included the two prior risk-check reports and the two hook-shape precedents the session actually reused.
- ✓ No stale content — cited the correct settings.json hook-wiring lines and the `logs/`-prefixed state-file paths.
- ✓ Handoff improves execution — the 3 missing-context flags were the 3 real issues; the unknown-scope flag (supplement vs duplicate existing guards) directly drove the session's Option A→B design pivot.
- ✓ Reduces operator effort — pre-populated the /prime 8c.4.5 mandate confirmation.
- ✗ Safe to act alone — `sufficient_to_implement: false`, correctly: the design decision genuinely required /risk-check + a system-owner opinion. The miss reflects an inherently operator-gated task, not a pack defect.

### Task 2 — Project execution (project-20260529-s6w12) — **5/6** ✓
- ✓ Right files — pinpointed all 10 target files across 4 repos.
- ✓ No missing deps — covered the source audits, plans, and permission templates.
- ✓ No stale content — actively *detected* staleness: flagged that Wave 2's plan premises no longer matched disk state, citing the RECONSIDER risk-check.
- ✓ Handoff improves execution — surfaced 3 conflicts that the actual S6 session hit exactly (Wave 2 was dropped after the RECONSIDER, per session-notes).
- ✓ Reduces operator effort.
- ✗ Safe to act alone — `sufficient_to_implement: false`, correctly: the conflicts genuinely required operator/risk-check resolution.

### Task 3 — Command improvement (command-20260529-7b2a4) — **5/6** ✓
- ✓ Right files — correct single target (friday-act.md) + the right inputs (improve-skill.md, SKILL.md, the summarizer agent, decisions.md).
- ✓ No missing deps.
- ✓ No stale content — **accurate at creation, now superseded.** Verified via git: this pack was the context pack *for* the auto-triage task, created 2026-05-29; the auto-triage work (commit `11dfd92`) landed the same day at 20:30 — *after* the pack was generated. So the pack's central premise ("auto-triage not yet codified in friday-act.md, lives only in the deferral entry") was correct at creation. Staleness is judged at creation time, so criterion 3 ✓ stands. **Caveat:** the pack is now outdated — friday-act.md Step 13a (lines 142–148) implements the rule the pack says is uncodified, and the pack's cited Step 3 line numbers (118–149) have shifted. This is normal pack aging (a pack ages out as its own task executes), not an engine defect, but it means the pack must not be reused as-is today.
- ✓ Handoff improves execution — surfaced the load-bearing pipeline-target conflict (/improve-skill targets SKILL.md, but /friday-act is a command) plus the undefined-predicates rule gap.
- ✓ Reduces operator effort.
- ✗ Safe to act alone — `sufficient_to_implement: false`, correctly: the vehicle conflict needs operator resolution.

### Task 4 — Permission entry (architecture-20260601-a1c4f) — **5/6** ✓
- ✓ Right files — settings.json + permission-template.md, exactly right.
- ✓ No missing deps — audit-discipline, permission-sweep, CLAUDE.md, decisions.md, gitignore.
- ✓ No stale content — line claims verified against disk (allow@3, deny@24, defaultMode@34, Layer C@112, "do not restore retired deny"@141).
- ✓ Handoff improves execution — flagged the under-specification and the two-gate /risk-check rule; cited the retired-deny gotcha.
- ✓ Reduces operator effort.
- ✗ Safe to act alone — `sufficient_to_implement: false`, correctly: the task literally doesn't name which entry to add.
- *Wart (non-scoring):* task_type mis-labeled `architecture` for a config/permission edit. Cosmetic — does not affect any of the 6 criteria, but a classification-tuning candidate.

### Task 5 — Comprehension / trace (command-20260601-c4e1a) — **6/6** ✓
- ✓ Right files — prime.md + session-plan.md, the two correct files.
- ✓ No missing deps — session-start.md, session-marker.md, context-pack-schema.md as background.
- ✓ No stale content — the 8a/8b/8c branch description was verified accurate against this session's lived chain execution.
- ✓ Handoff improves execution — the handoff prompt actually *answers* the question (summarizes all 3 branch shapes).
- ✓ Reduces operator effort — saves reading 2 long command files.
- ✓ Safe to act alone — `sufficient_to_implement: true`, no missing context; correctly recognized a comprehension task (`consumer: human`) that genuinely IS complete from the pack alone.

---

## Tally

| Task | Score | ≥4-of-6? |
|---|---|---|
| 1 — Hook | 5/6 | ✓ |
| 2 — Project | 5/6 | ✓ |
| 3 — Command-improve | 5/6 | ✓ |
| 4 — Permission | 5/6 | ✓ |
| 5 — Trace | 6/6 | ✓ |

**5 of 5 tasks score ≥4-of-6. Threshold (≥3 of 5) cleared comfortably. → PASS.**

---

## Findings

1. **The engine consistently nails criteria 1–5.** Across all 5 packs, "right files," "no missing deps," "no stale content," "handoff improves execution," and "reduces operator effort" were met every time. Citations are precise (line-level). **Verification scope:** packs 1 and 5 were checked first-hand (both tasks I executed this session); pack 4's line citations were spot-checked against disk (all accurate); pack 2's flagged conflicts were checked against the recorded S6 session outcome; pack 3's criterion-3 score was checked against git history (accurate at creation, see Task 3 caveat) rather than a current-disk spot-check. So "no stale content" for pack 3 is a creation-time judgment, not a present-state verification.

2. **Criterion 6 reads as a miss on 4 packs, but the miss tracks task nature, not pack quality.** Four packs missed only criterion 6 — all because the *tasks* were inherently operator-gated (`sufficient_to_implement: false` by honest design: a design decision, a stale-premise conflict, a vehicle conflict, a literally-unspecified entry). The engine correctly refuses to claim implement-readiness it doesn't have. The one task with no inherent operator gate (the comprehension trace) scored a clean 6/6. **Recorded scores stay at 5/6** — criterion 6 as written ("safe to act from pack alone") is genuinely not met when a pack honestly flags it is not implement-ready. **Rubric recommendation (not a re-score):** the rubric should distinguish "pack is incomplete (engine failure)" from "task genuinely needs operator input (correct caution)" — under the latter reading these four packs are high-quality despite the criterion-6 miss, but that is a proposed rubric change, not grounds to override the criterion today.

3. **`sufficient_to_implement: false` is a feature, not a weakness.** In every false case, the flag was correct and its `missing_context` items were the genuinely load-bearing unknowns — confirmed first-hand on the hook task (the flagged unknown-scope drove the real design pivot) and against the S6 record (the flagged conflicts were the conflicts that actually halted execution).

4. **Conflict/staleness detection works at a high level.** Pack 2 detected that a source plan's premises had gone stale vs disk and pointed at the RECONSIDER risk-check — the engine isn't just listing files, it's reasoning about currency.

5. **Minor: task-type classification is loose.** The permission edit was labeled `architecture`. Cosmetic (doesn't affect pack contents or the 6 criteria), but a tuning candidate if classification feeds any downstream routing.

---

## Recommendation

**Keep the engine; promote it past Phase 1.** It clears the Brief-1 bar on real tasks with margin, its citations are precise and accurate on every claim that was spot-checked (packs 1, 4, 5 directly; pack 2 against the session record; pack 3 settled via git), and its `sufficient_to_implement` honesty is exactly the safety property the brief wanted. Two low-priority tuning candidates for a future pass: (a) refine the criterion-6 rubric to separate engine-incompleteness from task-gating; (b) tighten task-type classification (the `architecture` mislabel). Neither blocks promotion.

**Side observation (out of evaluation scope, worth a one-line operator note):** `logs/decisions.md` Item 10 still records the friday-act auto-triage as `SCHEDULE-DEDICATED` (deferred), but the feature shipped 2026-05-29 (commit `11dfd92`, Step 13a). The decisions-log entry is stale and could be flipped to APPLIED. Independent of this evaluation — surfaced because the QC pass crossed it.

This closes the S6/S9 carryover (context-engine Phase 1 evaluation).
