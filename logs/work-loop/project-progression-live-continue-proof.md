---
task: project-progression-live-continue-proof
turn: operator
---

## Outcome
The Work Loop v2 project-progression candidate now has genuine ordered Codex-to-Claude multi-unit
behavioral evidence, rather than only hand-authored static-state classification. The material finding
frozen by the fresh-context Codex review on 2026-08-06 is resolved: Codex accepted Unit 1 and authored
a tokenless `Continue` hand-off, and Claude then executed Unit 2 and handed back — each half performed
by the actor the protocol assigns it to, and each recorded as a separate commit rather than as one
constructed blob.

## Decisions that matter
- Candidate `6ba4c3f` was authorised only as the implementation **baseline**, and this task was the
  operator's bounded override of the Work Loop v2 no-self-hosting rule. Neither decision adopts,
  installs or propagates the candidate.
- The `seam` block measures ordered commit history, not prose. `turn: claude` is a required conjunct of
  the hand-off fact, because without it a Claude hand-back could be counted as Codex's hand-off — the
  seam proving itself.
- **Deferral — `classify_state()` wrong-turn gap.** It calls a structurally valid Continue-shaped state
  `CONTINUE` whether `turn:` is `claude`, `codex` or `operator`. Reason it is deferred and not accepted:
  the live seam is protected by its own separate `turn: claude` conjunct, so the gap did not invalidate
  this proof — but it remains material candidate-evidence correction work, outside this task's scope
  rather than a limitation of it.

## Evidence
Commits `4750fb5` (Codex's hand-off preserved unchanged, state file only) and `e1d40a4` (Claude's
one-line Unit 2 execution and hand-back). Surfaces: `logs/work-loop/fixture-target-3.md` and the `seam`
block in `logs/scripts/work-loop-v2-slice-1.test.sh`. The harness moved 177 passed / 5 failed → 178 / 4
on Codex's hand-off commit alone → 180 / 2 on the hand-back, each flip tied to a fact coming into
existence. Codex independently reproduced 180 passed / 2 failed, exit 1, with all five `seam` and all
28 `cont`/`rout` assertions passing.

## Accepted limitations
The full harness remains red on the two disclosed unrelated `3.1a` closed-set assertions. This task
neither fixes them nor describes the full suite as green.
