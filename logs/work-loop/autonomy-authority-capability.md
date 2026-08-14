---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through a repository-grounded implementation plan that remains faithful to current authority and live behavior.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Discovery mode. Unit 11 — one bounded correction from the fresh isolated review of the research-amended implementation plan.

Named reason for the loop: the materially amended plan governs high-consequence changes to the canonical core and live authority rules; its tracer and evidence contracts must be internally satisfiable before operator re-freeze.

## Brief
A genuinely fresh isolated reviewer assessed only the amended plan, primary-source report, approved proposal, canonical-core baseline, and review criteria. Verdict: **CORRECT**. Correct the four frozen material findings below without changing the approved direction, research conclusions, unrelated plan content, or any target implementation surface.

Artifact identities:

- Reviewed plan commit: `4d3bbfd0ebceba44676d787abb23cd5379ec13de`.
- Reviewed plan blob: `d5b351d008ee581cfe496eef65fe7f2231415f66`.
- Research report blob: `16d5203bcfcdb3f6ddd19a1e4baf36612650efa6`.
- Approved proposal blob: `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`.
- Canonical-core baseline blob: `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`.

Scope: correct only findings 1–4 in the implementation plan plus this state-file handback. Preserve §8 placement, no-renumbering, T1's approved paragraph, the separate T1a/T2/T3a sequence, the complete proposal §6 authority classes, T8's accepted limitation, T9 strict exit, item-11 measures, MVP deferrals, and draft/unfrozen status. Do not edit the research report, proposal, core, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or any target implementation surface. Do not re-freeze or implement.

Required evidence: for each finding, show the exact before/after contract and why the corrected evidence can fail when the prohibited behavior occurs. Confirm the other three corrected contracts and unrelated plan content remain intact. Report the correction commit and resulting plan blob.

Completion condition: correct findings 1–4, set `turn: codex`, commit only the implementation plan plus state-file handback, and stop. The closure check will ask only whether these four findings are resolved and whether the correction broke something.

## Latest result

All four frozen findings reproduced by inspection before correcting, against baseline plan blob `d5b351d008ee581cfe496eef65fe7f2231415f66` (confirmed current): finding 1's contradiction was verified directly in the core (the two dated notes genuinely sit inside §3, lines 165–167, and §4, lines 285–287 — both "from `## 1.` onward"); finding 2's `grep -qv` bug was confirmed present at both its cited locations; finding 3's evidence was confirmed to name only lines 469/475 while Outputs named all five; finding 4's evidence was confirmed to check only the exact-phrase absence plus a vague presence check, with no structural test that would fail a synonym rewrite.

Result: all four findings corrected, fully. Plan blob `d5b351d008ee581cfe496eef65fe7f2231415f66` → `3fd5322fc3d499de01661dfb5d645def482b6168`. `git diff` shows exactly seven hunks across the four correction sites (§ 3.1a and T1a for findings 1–2; § 3.2 and T2 for finding 3; § 3.3a and T3a for finding 4) — 88 insertions, 47 deletions, no other section touched.

**Finding 1 — before/after:** Before, both § 3.1a and T1a's fail-capable evidence (b) claimed "a diff confirming ... every section from `## 1.` onward are byte-unchanged" while the same item's own Intended change requires editing text inside those very sections. After: the evidence is split into two paired diffs — (b-i) the T1 authority paragraph (lines 9–12) stays byte-unchanged, and (b-ii) a diff of the whole core *excluding* the header line and the two note blockquotes must be empty. This can fail two distinct ways it could not before: a change outside the header/notes now fails (b-ii) even though it would previously have passed the (false) "every section onward" claim vacuously; and it no longer falsely indicts a correct T1a implementation for touching text the Intended change explicitly authorizes.

**Finding 2 — before/after:** Before, `grep -qv "pre-authorized capabilities"` on the whole core — a check that returns success whenever *any* line in a multi-line file lacks the phrase, which is true of virtually every real file regardless of whether the phrase appears elsewhere. After, `! grep -q "pre-authorized capabilities"` — genuinely fails if the phrase appears anywhere in the file. Demonstrated failing case, run with `command grep` — this session's interactive shell aliases plain `grep` to a wrapped `ugrep` invocation whose exit-code behavior differs on piped input, so the check below deliberately bypasses that alias to test the primitive the plan's prose actually specifies: `printf 'a\npre-authorized capabilities\nb\n' | command grep -qv "pre-authorized capabilities"; echo $?` → `0` (wrongly reports success even though the phrase is present); `printf 'a\npre-authorized capabilities\nb\n' | { ! command grep -q "pre-authorized capabilities"; }; echo $?` → `1` (correctly fails). Also corrected at the parallel location in T1a's tracer verification (a), which had the same bug applied to "draft for operator approval" — the spec's own (a) had used the correct `grep -q` form throughout, so only the tracer's (a) needed this half of the fix.

**Finding 3 — before/after:** Before, T2's fail-capable evidence (d) named only two bare strings — "the change would be hard to reverse" (line 469) and "anything else that is genuinely consequential" (line 475) — leaving lines 26, 59–60, and 477 uncovered; a commit clearing only 469/475 would pass declared evidence while the core still stated three other unqualified consequence-transfer rules. After, (d) names all five bare current strings individually — line 26 ("and any decision that is hard to reverse"), lines 59–60 ("Genuinely consequential work stops and goes to the operator instead"), line 469, line 475, and line 477 ("is the answer for consequential situations") — with an explicit statement that clearing only some of the five is a partial reconciliation, not a pass. Demonstrated failing case: a hypothetical commit that reworded only 469 and 475 (leaving 26, 59–60, 477 verbatim) would fail the corrected (d-i), (d-ii), (d-v) checks while it would have silently passed the old (d) entirely.

**Finding 4 — before/after:** Before, T3a's evidence checked only (a) the exact old phrase is gone, and (b) "the skill still states, in some form, that a genuinely operator-reserved ... decision is not Codex's to make — read and confirmed, not grepped" — a vague positive check that a synonym rewrite ("anything irreversible," "anything with major consequence") would satisfy while remaining the same freestanding categorical rule under new words. After, the Outputs and Failure behavior now require the replacement bullet to **cite** core § 7 rather than restate a rule, matching the "cite, don't restate" discipline already used at § 3.2/§ 3.3 for the same duplication risk; the evidence adds two structural, narrowly-scoped checks: `grep -q "core § 7"` on the replacement bullet (proves it defers rather than stands alone — a synonym rewrite with no citation now fails this even though it still passes the exact-phrase check), and a read-and-confirm that the bullet does not itself enumerate proposal §6's class list verbatim (guards against a second, driftable copy). No broad or ceremonial synonym scan was added, per the stop condition.

No newly noticed finding arose during this correction; there is nothing to record as a deferral.

Regression, unaffected: `work-loop-v2-core-resolver.test.sh` — `4 passed, 0 failed`. `work-loop-v2-slice-1.test.sh` — `passed: 308  failed: 0`. `git status --porcelain` on `plans/`, `docs/`, `.claude/`, `.agents/`, `scripts/` restricted to files other than this plan — empty; no target implementation surface, and not the research report, was touched.

## Blocker
None.

## Next action
Codex: run the closure check on these four frozen findings only — are all four resolved, and did the correction break anything else in the amended plan. If closed, the amended plan (blob `3fd5322fc3d499de01661dfb5d645def482b6168`) still requires the operator's explicit content-bound re-freeze before any status-reconciliation, T2, T3a, or later target-implementation unit may begin — a passed review is not the re-freeze itself.
