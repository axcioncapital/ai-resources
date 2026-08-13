---
task: axcion-harness-v0-2-normal-trial-1
turn: operator
---

## Outcome

A correct false-premise stop. The live staging guard already permits the bounded case the task was
opened to repair: a staged rename whose destination is inside the declared footprint commits cleanly,
with only the destination in `Files in scope`. No repair was implemented, and no file outside this
state file was changed.

This task does **not** count as Normal Trial 1 for Axcíon Harness v0.2. The unit was framed in
Implementation mode, and its evidence bar — a failing case, an implemented result, and regression
protection — was consequently not met, because there was no failing case to meet it with. The
premise-check evidence was sufficient to refuse that trial count on its own, without a correction
round.

## Decisions that matter

Deferral — the 2026-08-02 improvement-log entry `The mandate schema has no field for a file a session
moves or deletes` carries a mechanical diagnosis that the fixtures contradict, and a proposed fix
(switch to `--name-status`, exempt `R`-source paths) that would not repair the tested case. It was
left uncorrected because the brief permitted touching that entry only if its rename claim was fully
resolved by the evidence; this run establishes that the claim is wrong, not what should replace it.
Reframing a durable source is Codex's decision, not a repair Claude may make inside a hand-back.

Four follow-on threads each require separately framed work and none is authorised as an extension of
this closed unit: correcting that improvement-log entry, investigating the unexplained 2026-08-02
incident, selecting a replacement representative task for the pilot, and addressing deletion-shaped
staging behaviour.

## Evidence

Final commit: `bc2340b` — `handback: axcion-harness-v0-2-normal-trial-1 — false premise, Unit 1 did
not begin`. That commit carries the full inspection record and fixture evidence; this closing record
is committed on top of it and changes no other file.

Four disposable fixtures under `mktemp -d`, each a throwaway git repository with a session marker and
a mandate declaring `- Files in scope: docs/new.md` and nothing else, fed a synthetic PreToolUse
payload the way `logs/scripts/check-foreign-staging.test.sh` `run_hook()` does, invoking the live
`.claude/hooks/check-foreign-staging.sh` unmodified:

- The brief's own fixture (`git mv docs/old.md docs/new.md`, then `git commit`) exits 0 with no
  output. `git diff --cached --name-only` returns `docs/new.md` alone.
- The same fixture with `diff.renames=false` blocks and names `docs/old.md` — the fail-capable
  control, showing the check can fail when the source genuinely reaches the candidate set.
- Rename plus a sub-threshold content rewrite, and an unstaged move followed by `git add -A`, both
  block on `docs/old.md`. Git records these as deletions (`D` with no paired `R`), which is the case
  the brief held outside this unit.

Rename detection is live in this repository independently of the fixtures: `323b57f` records `R099`
across a directory move.

## Accepted limitations

The original 2026-08-02 incident remains unexplained: its commit is not reachable on this branch, so
this run could not establish which staged shape actually produced it.

The disposable fixture directories remain in the OS temporary directory. An `rm -rf` cleanup was
declined at the permission prompt. No repository path was touched by any of them.
