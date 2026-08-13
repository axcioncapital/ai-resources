---
task: project-progression-candidate-recovery
turn: operator
---

## Outcome
The bounded recovery objective is met: the Work Loop v2 project-progression candidate is
review-ready and evidence-honest, while remaining explicitly unapproved and unadopted. The four
frozen defects were resolved — pinned vocabulary is restored (no undefined `delivery unit`);
Continue now requires an accepted prior unit and no longer overlaps an ordinary Unit 1 opening;
the fixture invents no pseudo-token; and the evidence record no longer calls the full harness
green. Codex accepted Unit 1 on 2026-08-06 and closed the task.

## Decisions that matter
- The authority statement in the candidate record's § 0 was judged sufficient for a fresh
  reviewer: it names the crossed approval gate, the bounded recovery authorisation, and the
  still-pending independent-review and adoption gates.
- The corrected Continue precondition distinguishes Unit 1 from Continue; the correction boundary
  remains separately identified by the core-owned correction token. No material ambiguity remains
  for this recovery unit.
- Deferrals, each separate work none of which was required to close this task: redesigning the
  `3.1a` closed-set check (it reddens with normal repository growth and needs a design fix, not
  list-widening); running any live multi-unit Continue proof; and conducting the independent
  candidate review. Candidate adoption remains an operator decision after that review.
- The `/work-loop-v2` direct-invocation session-marker gap was hit again during this unit;
  already logged at `high` in `logs/improvement-log.md` (2026-08-06).

## Evidence
Unit 1 hand-back committed in `4fb2ce7`; candidate record at
`plans/work-loop-v2-mvp/project-progression-candidate-review.md` (current blobs pinned in its
§ 1). Independent Codex verification on 2026-08-06 reproduced `passed: 167   failed: 2`, exit 1,
with all 20 candidate-specific `cont`/`rout` assertions passing.

## Accepted limitations
- The full harness remains red for two unrelated pre-existing `3.1a` closed-set assertions; the
  totals above are not evidence that this candidate is fully green.
- Continue has constructed multi-unit evidence (the fixture) rather than a live multi-unit run.
