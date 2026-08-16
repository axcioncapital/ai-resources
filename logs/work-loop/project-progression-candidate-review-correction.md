---
task: project-progression-candidate-review-correction
status: closed
turn: operator
---

## Outcome

Both material findings from the independent fresh-context Codex review were resolved, and the
artifact verdict was **Accept after corrections**.

- **Finding 1 — the skill copied core-owned Continue mechanics.** The `**Continuing.**` paragraph in
  `.agents/skills/work-loop-v2/SKILL.md` now defers every mechanic to core § 3 by reference and keeps
  only the skill-owned Codex judgment: justify the next unit against the objective, route the next
  move by owner first, and treat Continue as an acceptance — so it neither dodges closure nor
  disguises a correction. A negative harness assertion guards the paragraph against a future re-copy,
  and that guard was proved capable of failing against the pre-correction text.
- **Finding 2 — the Continue evidence did not discriminate.** A `classify_state()` discriminator was
  added to `logs/scripts/work-loop-v2-slice-1.test.sh`, plus constructed negative fixtures. It reads
  the state file's own structure — frontmatter validity, core § 4's exact active headings, the two
  core-owned protocol tokens, and the Continue precondition — and reads no core or skill prose.
- **The final tightly-bounded fix** (permitted by Codex under the core § 3 menu) removed the ordinal
  proxy from the acceptance precondition and corrected the record's then-stale authority sentence.

Later, separate tasks then proved the live cross-actor `Continue` seam by execution and corrected the
turn-sensitive classifier gap this task had deferred; the operator subsequently **adopted** the
corrected candidate on 2026-08-06. That adoption is preserved here as subsequent repository fact — it
was not an action of this task, which never approved, adopted, installed or propagated anything.

## Decisions that matter

- **The close hand-off's original prerequisite was overtaken and is deliberately not executed.** An
  earlier close instruction required three factual-status files to be set to "artifact accepted but
  not adopted". Repository reality advanced past it: the candidate record, the decision journal entry
  and the mission file all now record the operator's 2026-08-06 adoption. Those later durable facts
  govern. Restoring the obsolete "not adopted" status would have written a false state, so the three
  files were left untouched — their current content is the evidence that the old prerequisites were
  completed by later work rather than left undone.
- **Closing this stale task changes no design, adoption, installation or propagation decision.** It
  records an already-finished correction round; nothing downstream moves because of it.
- **Finding 2's stated consequence did not match the repository, and that was reported rather than
  smoothed over.** The frozen finding said the old `cont` block "can stay green for a state the
  protocol defines as non-Continue". A probe showed the opposite failure: the old predicates were
  bound to one fixture's incidental strings and would have *rejected* valid Continues. The finding was
  resolved either way, because discrimination now exists.
- **The correction's own first attempt was defective and the probe caught it.** The initial
  `classify_state()` keyed the precondition on the literal word "accepted" and misclassified a valid
  Unit-3 Continue as OPENING — reproducing the fixture-literal failure being corrected. Fixed before
  the green run.
- **Deferral, recorded and not done:** the Work Loop v2 skill's `**A correction is written into the
  state file…**` paragraph also restates core-owned mechanics, including `set turn: claude`. It is the
  same class of defect as finding 1, but it fell outside the frozen findings, so the duplication guard
  was narrowed to the `**Continuing.**` paragraph rather than widening this round past its scope. It
  remains separate future work.

## Evidence

- **Correction round.** RED before: `passed: 168  failed: 8`, exit 1, with six of seven new assertions
  red against the uncorrected candidate (the seventh — the positive Continue case — was green on
  arrival and reported as such). GREEN after: `passed: 174  failed: 2`, exit 1; `cont`/`rout` 27/27.
- **Final tightly-bounded fix.** RED before: `passed: 174  failed: 3`, exit 1, with the classifier
  returning `CONTINUE` for `logs/work-loop/fixture-continue-unaccepted.md` when queried directly.
  GREEN after: `passed: 175  failed: 2`, exit 1; `cont`/`rout` 28/28.
- **Six-fixture discrimination, each for its own distinct reason:** `fixture-continue.md` → CONTINUE;
  `-opening` → OPENING (placeholder result); `-close` → CLOSE (close token); `-correction` → CORRECT
  (correction token); `-malformed` → MALFORMED (`## Next steps` where core § 4 requires
  `## Next action`); `-unaccepted` → OPENING (no unnegated acceptance).
- **Controls unchanged, verified by execution.** `git status --porcelain` empty for
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (blob `8f30da6c`) and
  `.claude/commands/work-loop-v2.md` (blob `125de530`).
- **Current authority record:** `plans/work-loop-v2-mvp/project-progression-candidate-review.md`
  §§ 0, 5, 5a and 5b — which own the later and current evidence, including the live-seam proof and the
  classifier correction.
- **Current adopted status entries:** `logs/missions/work-loop-v2-mvp.md` (project-progression thread
  marked complete and adopted) and the decision-journal entry *"2026-08-06 — Work Loop v2
  project-progression proposal"*. **Pointer correction:** that entry now lives in
  `logs/decisions-archive-2026-08.md` (from line 757), not in `logs/decisions.md` — the journal was
  rotated on 2026-08-07, after the close hand-off was written. The decision itself is unchanged; only
  its location moved.

## Accepted limitations

- **The acceptance classifier is lexical and conservative** at this task's artifact-closure boundary.
  A result recording an acceptance in wording it does not recognise falls to OPENING — verified live,
  not asserted: a valid Continue whose result reads "taken as good enough to move on" classifies as
  OPENING. That under-calls a real Continue, which is the safe direction, and is the conservatism the
  closure check expressly permitted.
- **The full harness retained two disclosed unrelated failures** — the pre-existing `3.1a` closed-set
  reds, untouched and out of scope. This round never claimed the full suite green. New fixtures were
  registered in `KNOWN_WORKLOOP_FILES`, which is that assertion's documented friction, not a widening
  to hide a red.
- **These limitations describe this task's closure boundary only.** The candidate record owns the
  later and current evidence, and the state of the adopted candidate is read from there, not here.
