---
task: develop-ai-resource-v2-capability-seam
turn: operator
---

## Outcome

`.claude/commands/develop-ai-resource.md` now carries a truthful, sequential one-owner boundary.
Work Loop v2 owns an unresolved operating outcome; `/develop-ai-resource` owns the later question of
whether and how a durable AI artifact should exist; and the artifact disposition does not take
operational adoption away from its owner. The upstream provenance clause states honestly that no live
producer emits the reserved `**Capability:**` / `**Settled upstream:**` fields, while preserving all
four defensive checks and the ordinary direct-invocation path.

Unit 1 changed only `.claude/commands/develop-ai-resource.md` — six lines (24, 34, 64, 67, 159, 164).
Units 2–4 of the approved plan remain unstarted.

## Decisions that matter

- **The two surviving bare `/work-loop` strings are accepted as non-routes.** Each names the v1
  command only to state that it was deleted. The acceptance condition was removal of every callable
  or implied route to that command, not erasure of accurate historical context; zero live route
  remains.
- **Deferral to Unit 4 — the `docs/work-loop.md` citation at current line 163.** That file is live
  today, so the citation is sound now, but it is v1 doctrine whose keep/fold/retire disposition
  belongs to Unit 4. Not resolved here because touching it would decide the v1 capability system's
  fate, which this unit's scope excludes. If Unit 4 folds or retires that document, it must
  disposition this downstream citation rather than leave it dangling.
- **Non-interference was the binding constraint on the fix.** The four provenance checks, the
  ACTIVE/TERMINAL status sets, the three field-presence branches, the direct-invocation path and
  Step 4's artifact-only disposition were required to stay behaviourally unchanged, and were verified
  byte-identical to the prior commit rather than re-reasoned.
- **Codex's verdict is artifact-fitness only.** Unit 1 is accepted; nothing here approves Units 2–4
  or authorises a material departure from Unit 1.

## Evidence

Implementation commit `4088df9` — "update: develop-ai-resource — reconcile the dangling Work Loop v1
seam to the live v2 owner". Six insertions, six deletions in the target command.

Five fail-capable evidence groups were recorded and assessed before this closure: the dead-route
regression (7 bare `` `/work-loop` `` before, 2 historical mentions after, `/work-loop-v2` still
distinguishable); two one-owner routing cases, each returning exactly one first owner and the named
condition ending that owner's responsibility; three provenance cases run against the one live
capability record, where check 1 and check 4 each discriminate against real alternatives; a
region-by-region `shasum` of the unchanged blocks against `HEAD`; and a boundary proof that no file
outside the target and this state file was staged.

## Accepted limitations

- **The producer-side path is dormant.** No component emits the two reserved upstream fields today,
  so Step 1.0's four checks are live consumer-side and unexercised producer-side. If a future unit
  creates a real producer, that unit must update the dated absence statement in the command and prove
  the producer contract through this same seam.
