---
task: project-progression-classifier-turn-correction
turn: operator
---

## Outcome
`classify_state()` in `logs/scripts/work-loop-v2-slice-1.test.sh` is turn-sensitive. The valid
`turn: claude` Continue is still recognised, while otherwise equivalent states at `turn: codex` and
`turn: operator` cannot classify as `CONTINUE`. This closes the one material evidence gap the live
cross-actor Continue proof deferred. The candidate-review record now describes the live seam, this
correction, the real suite totals, and the authority boundary. Codex independently reproduced
`passed: 183   failed: 2`, exit 1, with the `cont`/`rout` block at 31/31 and the live `seam` block at
5/5 — no classification and no live-seam evidence regressed.

## Decisions that matter
- Candidate `6ba4c3f` was authorised as an **implementation baseline**, and this task carried a
  bounded no-self-hosting exception. Neither decision adopts, installs or propagates the candidate.
  The next authority move is the operator's adoption decision.
- Returning `OPENING` for a wrong-turn tokenless state is accepted as a **conservative internal
  harness verdict**. The helper exists to prevent false `CONTINUE` evidence, not to be an exhaustive
  lifecycle classifier. No runtime semantics and no new lifecycle state, protocol token, artifact kind
  or review layer were added, and no runtime file was touched.
- The wrong-turn states are **derived** inside the harness from the valid fixture by rewriting only
  the frontmatter turn, so the sole difference from a real Continue is the thing under test, no new
  persistent fixture exists, and the `3.1a` closed set was not widened.
- **Deferral — the candidate-review record's accumulating-history shape.** It now carries three
  sequential correction narratives (§ 2a, § 5, § 5a/§ 5b) and reads as a history rather than a
  current-state record. Reason for deferring: it is outside this bounded evidence correction and
  affects neither the corrected classifier nor the adoption authority boundary.

## Evidence
Commit `dd6817b` — the one-predicate fix plus three assertions in
`logs/scripts/work-loop-v2-slice-1.test.sh`, and the record update in
`plans/work-loop-v2-mvp/project-progression-candidate-review.md`. The two wrong-turn assertions were
shown RED against the pre-fix classifier (`passed: 181   failed: 4`, exit 1) and green after
(`passed: 183   failed: 2`, exit 1); the third assertion is a control proving the derivation faithful,
and passes before and after by design. Codex reproduced the post-fix result independently.

## Accepted limitations
The full harness remains red on the two known unrelated `3.1a` closed-set assertions. It exits 1 and
must not be described as green; this task neither fixed nor suppressed them.
