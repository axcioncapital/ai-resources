UNIT: 2026-07-29-review-layer-consolidation-build-4
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S4 — Consumer/migration evidence, guidance and decision record
REPO: ai-resources
BASE: c1b4435
NEXT: Prove

EVIDENCE

Brief and evidence combined, as in Build-3.

## 1. Guidance realigned (7 files, 19 replacements, all matched)

| File | What changed |
|---|---|
| `docs/session-rituals.md` (3) | `/qc-pass` is **no longer "default after every creation"**; `/refinement-pass` no longer "after QC passes" (it is independent, not a stage); `/triage` marked optional |
| `docs/weekly-session-guide.md` (4) | Same three in the quick-reference block, plus the "After every creation or improvement" cell |
| `docs/friday-cadence-runbook.md` (1) | **The Build-2 carry-over**: *"F4 auto-runs `/qc-pass`"* → *"F4 offers a review (y/n)"*, matching what S2 actually did |
| `docs/operator-maintenance-cadence.md` (1) | Fix-session line no longer prescribes `/qc-pass` per command-shaped memo |
| `docs/onboarding-daniel-cheatsheet.md` (5) | All five review commands re-described as operator-invoked; `/risk-check` corrected from "5 risk dimensions" to 7 and marked operator-invoked-only |
| `docs/onboarding-daniel.md` (4) | Same for the narrative sections; autonomy item 9 rekeyed to "high-consequence, one risk-aware review"; the `qc-independence.md` pointer re-described |
| `.claude/commands/monday-prep.md` (1) | The two-line ritual replaced by the proportional rule |

Not touched, as planned: `docs/materiality-bar.md` — the finding floor survives intact.

## 2. Decision record

One append-only entry in `logs/decisions.md`, dated 2026-07-29. It records: the three-row rule; the `/risk-check` reversal from plan-v2's KEEP and **why that argument was circular**; the four deletion deferrals on consumer grounds with the 26-consumer count and the whole-directory symlink; the eight real separate project files (six diverged); `positioning-research`'s locally wired nudge hooks; the transition gate's RECONSIDER and its resolution; both sequenced follow-ups with exact line numbers; and the seven pre-existing broken symlinks. **An entry in an existing log — not a registry, layer or gate.**

## 3. Final falsifier sweep — whole stream

| # | Result |
|---|---|
| 1 | **Clear.** No symlink created, deleted or retargeted by any slice. The 7 pre-existing breakages are unchanged (Build-1 § 5). |
| 2 | **Clear.** All 12 counts re-derived with `find -L` after S4: qc-pass 26, refinement-pass 26, refinement-deep 26, triage 26, resolve 26, contract-check 22, blindspot-scan 19, implementation-triage 26, risk-check 26, consult 28, reconcile 15, pm 22 — identical to plan-v3 § 8 at every slice boundary. |
| 3 | **Clear.** No overclaim. The permitted claim is plan-v3 § 4's, bounded by Correction 1 and § 6, and S1's transitional caveats say so inside the governing docs themselves. |
| 4 | **Clear.** Zero new commands, agents, hooks, registries, wrappers, gates or programmes across all four slices. The only files added are `logs/loop/` artifacts and one risk-check report. |
| 5 | **Clear.** Six protected hooks byte-identical; zero permission-entry changes; `cleanup-worktree` hard gates and counters 1/2/4, Steps 13/13b; `execution-protocol` §§ 7–13 unchanged and un-renumbered; `friday-journal` 5.4/5.6/5.7; `promote-workflow` P4/P6/P5.4; `materiality-bar.md`. |
| 6 | **Clear.** No excluded file touched by any slice. |
| 7 | **Clear.** Only the two nudge hooks deleted. Zero canonical commands or agents removed. |
| 8 | **Clear.** Final full-scope sweep leaves nine hits, every one accounted for: four are **historical narration** of past incidents (`session-marker.md:248`, `commit-discipline.md:51`, `handoff/SKILL.md:202,205` — explicitly authorized by plan-v3 § 0 Correction 2), and five are in **`prime.md`**, the excluded file named as § 6 follow-up item 1. No live reference to removed machinery survives in any file this stream may edit. |
| 9 | **Clear.** Transition gate ran once, in Build-1. |

## 4. State at end of Build

**Delivered:** no general Claude review and no risk-reviewer subagent fires automatically from any file this stream may edit. Two prompting hooks gone. Eleven commands, one agent, two skills and nine governing/guidance documents realigned to one proportional rule.

**Not delivered, by design and named:** `prime.md:816` still fires the plan-time gate and `session-plan.md:157` still emits the two-gate pointer — both excluded by the brief. Workspace-root `CLAUDE.md` still carries the unconditional QC mandate, so **behavior in workspace-rooted sessions does not change until that follow-up lands**. Both are § 6 items with owners and an order, recorded in `logs/decisions.md`.

---

Status: complete

Marker appended 2026-07-29 during `/work-loop` Step 1 reconciliation, not at the time
the unit ran. The S4 work landed at commit 8840672 and is unaltered by this append;
only this closure block was added.

**Ordering rule was not satisfied for this unit**, as for Build-3. The recovery brief
`…-build-4.brief.md` was written retrospectively and carries the full notice. It also
records one open question this evidence does not answer: plan-v3 § 3 S4 lists eight
guidance files including `docs/weekly-cadence.md`, and § 1 above reports seven without
it. Left for Prove rather than reconciled here.
