---
task: axcion-harness-v0-2-attended-release
turn: operator
---

## Outcome

**Retired by the operator on 2026-08-15 to permit the Work Loop v2 durable-state migration.** The
task did not reach its Phase 2 exit and is not recorded as released.

The objective was to ship Axcíon Harness v0.2 as a usable attended-only release: one thin canonical
launch surface around Work Loop v2 that carries an already-explicit turn through a fresh actor
process, validates the handback, and stops visibly without creating a second semantic state system.
The launcher and its deterministic evidence were built and accepted. The remaining unknown — whether
the launcher can carry a real turn through a real fresh Claude process — was tested once, and that
run **stopped before launching any actor**. The task is retired with that unknown unresolved.

## Decisions that matter

**Accepted work, assessed and preserved.** Unit 1 was accepted by Codex. The canonical attended-only
launcher and its deterministic suite met the implementation boundary: 98/0 green, five
fail-capability mutants, an explicit default Claude permission mode, exact binding and transition
guards, mechanical refusal of unattended and multi-hop requests, and one structured terminal result.
The corrective record commit was accepted alongside the implementation commit because concurrent
movement of `main` made an amend unsafe and the second commit changed only the factual record.

**Unit 2 ran in Discovery mode and returned a negative result, not a failure of the launcher.** Its
named unknown was whether `scripts/axcion-harness-v0.2/carry-turn.sh` could carry the explicit Claude
turn through a real fresh Claude process using the state file and repository facts alone. The live
carry stopped with exit 18 because the checkout contained unrelated dirty paths — `logs/friction-log.md`,
two old Monday-prep task paths, prior spike run captures, and `scripts/recall-search.py`. No actor
launched and no path besides that state file changed. The stop was environmental; it did not test the
carry itself, and the run was not retried.

**A deliberate refusal to widen scope, recorded and still standing.** The unit does not legitimately
touch those dirty paths, so widening `--allow-path` would have weakened the release proof. Codex
declined to commit, stash, delete or overwrite unrelated work to make the trial pass.

**Superseded by this retirement:** the record's open `Next action` asked the operator to choose
whether the unrelated changes were finished or parked in that checkout, or whether the live trial
should move to a deliberately isolated clean checkout. That choice was never made. The operator's
2026-08-15 decision supersedes the disposition, not the finding — the live carry remains unproven.

## Evidence

Durable evidence already present in this record, carried forward unchanged:

- Accepted commits `a232971` (implementation) and `bdfe91f` (corrective record commit).
- Unit 1 deterministic suite: **98/0 green**, with five fail-capability mutants.
- The Unit 2 terminal record, verbatim:
  `RESULT outcome=STOPPED code=18 task=axcion-harness-v0-2-attended-release mode=live actor=none turn_before=claude turn_after=none`
- Full run log:
  `/private/tmp/axcion-harness-v0.2-live/20260811T121236-57811-axcion-harness-v0-2-attended-release.log`
  (a temporary path recorded at the time; it is not guaranteed to survive).

## Accepted limitations

1. **The Phase 2 vertical-slice exit is unmet.** No real bounded task has crossed a fresh-process
   handoff through this surface. This was the only release-blocking limitation carried forward from
   Unit 1, and it stands unchanged at retirement — the release was never made.
2. **The single live trial proved nothing about the carry.** Exit 18 fired on checkout cleanliness
   before any actor launched, so `carry-turn.sh` remains untested against a real fresh Claude process.
   The run will not be retried under this task.
3. **The blocking condition was never dispositioned.** The unrelated dirty paths in that checkout
   were neither parked by their owners nor bypassed by moving to an isolated clean checkout.
4. **`scripts/recall-search.py` must be preserved** unless its owner explicitly disposes of it. This
   task never owned it and did not dispose of it.
