---
task: axcion-harness-v0-2-normal-trial-1
turn: codex
---

## Objective and scope

Complete Normal Trial 1 for Axcíon Harness v0.2 by repairing one live staging-guard defect: a
session that stages a Git rename must be allowed to commit when the rename destination is inside its
declared footprint, without adding the now-absent source path to the mandate.

Scope: `.claude/hooks/check-foreign-staging.sh`, the focused regression coverage in
`logs/scripts/check-foreign-staging.test.sh`, this state file, and the source improvement-log entry
only if the evidence supports updating its status. Excluded: pure deletions, a new mandate field,
changes to `session-start.md`, other copies of the hook, unrelated staging-guard cleanup, deployment,
push, and any wider harness change. Hook-written `logs/friction-log.md` or
`logs/innovation-registry.md` changes are permitted incidental effects, not implementation targets.

The task exits when the bounded repair has completed implementation, handback, Codex assessment, and
closure with evidence sufficient to count it—or explicitly refuse to count it—as the first normal
attended pilot trial.

## Lane and unit

Standard. Implementation mode. Unit 1 — make an in-footprint staged rename pass without weakening the
guard for an out-of-footprint rename.

Named reason for the loop: the globally active commit guard is consequential enough that its result
needs independent assessment before it counts as repaired, and this unit is also intended to supply
representative operating evidence for the attended harness adoption trial.

## Brief

This unit is worth doing now because the operator has asked to frame Normal Trial 1, the attended
carrier is live for pilot use, and the current pilot record says representative real tasks are the
remaining adoption evidence. The selected defect is genuine repository work with a bounded failing
case, rather than a manufactured harness exercise. It aligns with the accepted pilot boundary of one
checkout, one writer, and one explicit hop at a time.

**Required outcome.** Preserve the staging guard's contamination protection while allowing a staged
rename whose destination is already covered by the session footprint. The implementation mechanism
is Claude's choice; the improvement log's suggested `--name-status` approach is a proposal, not a
requirement.

**Authority and source disposition.**

- Governing operator direction: the current request, `Frame normal trial 1`, authorises framing this
  representative unit now.
- Authoritative current pilot state to verify:
  `logs/work-loop/axcion-harness-v0-2-go-live.md` should show normal attended pilot use is live while
  final adoption remains open pending three to five representative tasks.
- Non-governing background: `plans/axcion-harness-v0.2/mvp-plan.md` describes the representative-task
  adoption bar but labels itself proposed; do not promote it to governing authority.
- Verify-first repository claim and source proposal: the 2026-08-02 improvement-log entry titled
  `The mandate schema has no field for a file a session moves or deletes` says the guard flattens the
  staged set with `git diff --cached --name-only`, then flags the missing rename source as outside the
  footprint. Inspect the live hook and fixture surface before relying on that diagnosis or its
  suggested remedy.

**Check against the repository before editing.**

1. In `.claude/hooks/check-foreign-staging.sh`, locate the staged-candidate collection and confirm
   whether it currently loses rename status/source-destination pairing. The settling evidence is the
   exact live command and parsing path, not the improvement log's line numbers.
2. In `.claude/commands/session-start.md`, confirm only the premise needed for this unit: a rename
   source that no longer exists cannot validly sit in `Files in scope`, while a pre-existing rename
   destination can. Do not edit that command.
3. In `logs/scripts/check-foreign-staging.test.sh`, establish whether a focused staged-rename fixture
   already exists by searching that file for rename-status and `git mv` cases. Any absence finding is
   bounded to that file.
4. Reproduce the failure before implementing: in a disposable fixture, declare only the existing
   destination inside the footprint, stage a rename to it, and show that the current hook blocks on
   the absent source path. If this does not fail as claimed, hand back the false premise without
   implementing.

**Boundaries and framing decisions.** I selected only the rename case because it is the smallest
observable repair supported by the entry's incident; pure deletion has a different authority problem
and is held outside this unit. I also excluded the other hook copies because this trial is bound to
the live `ai-resources/.claude` guard, and cross-copy deployment would add a second deliverable.

**Required evidence.**

- The same focused fixture is red before the change and green after it.
- A paired negative control proves the guard still blocks and names a staged rename when its
  destination is outside the declared footprint; an exit-code-only assertion is insufficient.
- The full existing `logs/scripts/check-foreign-staging.test.sh` suite passes after the change, or any
  pre-existing/environment-dependent failure is separated from the new result with exact output.
- The result identifies every changed path and distinguishes intended edits from incidental hook
  writes.
- The handback records the final commit and enough operating facts for Codex to assess the normal
  trial: whether a fresh Claude process reconstructed the unit from durable sources, whether manual
  actor-to-actor context was ferried, the operator interventions observed during this hop, elapsed
  time if available from carrier evidence, and any loss-of-control or recovery event. Do not invent
  facts the run evidence does not contain.

**Completion condition.** Implement the bounded rename repair, add durable fail-capable regression
coverage, run the proportionate checks, update the source improvement entry only if its rename claim
is fully resolved by the evidence, commit the allowed result, write the result and evidence into this
state file, set `turn: codex`, and stop for assessment.

**Stop conditions.** Hand back without implementation if a load-bearing claim is false, the repair
requires a new mandate field or changes pure-deletion policy, the negative control cannot be made
fail-capable, or completion requires a file outside the stated scope. Stop for the operator if the
only viable change would weaken the guard for ordinary edits or make a hard-to-reverse policy change.
Challenge a false premise or stale direction rather than improvising past it.

## Latest result

Inspected (2026-08-13):

- Claim (1) — the guard's staged-candidate collection loses rename status/source-destination
  pairing: **FALSE**. Read `.claude/hooks/check-foreign-staging.sh` end to end. The gated-`git commit`
  path does collect with `git diff --cached --name-only` (line 690, exactly as the improvement log
  states), but that command does not emit the rename source. With rename detection active — git's
  default, and unconfigured here — git has already collapsed the pair to the destination *before* the
  hook reads it. Nothing is discarded at the collection point, because nothing arrives to discard. The
  wide-`git add` path never used `--name-only` at all: `porcelain_entries()` splits on `" -> "` and
  keeps the new name (lines 646–647), so it resolves rename pairing explicitly today.
- Claim (2) — an absent rename source cannot validly sit in `Files in scope`, while a pre-existing
  destination can: **HOLDS**. `.claude/commands/session-start.md:286-292` runs `test -e` on each
  `files_in_scope` entry as a HARD REJECT, and routes a to-be-created file to `- Required outputs:`.
  An existence test is precisely what admits an existing destination and refuses a moved-away source.
- Claim (3) — no focused staged-rename fixture exists in the regression harness: **HOLDS**. Searched
  `logs/scripts/check-foreign-staging.test.sh` (469 lines) for `rename`, `git mv`, `name-status` and
  `R[0-9]{2,3}`, case-insensitive; no match. The harness's ten cases are all target-repository
  resolution cases.
- Claim (4) — the brief's reproduction fixture blocks on the absent source: **FALSE**. This is the
  settling evidence, and it is the reason the unit does not begin. See `## Blocker`.

Result: Unit 1 was not implemented. The repair the brief scopes has no failing case to repair, and
every neighbouring shape that *does* block is deletion-shaped — the case the brief deliberately held
outside this unit. No file outside this state file was changed.

Evidence: four disposable fixtures under `mktemp -d`, each a throwaway git repo with a session marker
and a `session-notes.md` mandate declaring `- Files in scope: docs/new.md` and nothing else, fed a
synthetic PreToolUse payload exactly as `check-foreign-staging.test.sh` `run_hook()` does. The live
hook was invoked unmodified. Fixture roots were left in the OS temp directory — an `rm -rf` cleanup
was declined at the permission prompt; no repository path was touched by any of them.

- **The brief's own fixture — `git mv docs/old.md docs/new.md`, then `git commit`: exit 0, no
  output.** `git diff --cached --name-only` returned `docs/new.md` alone; `--name-status` returned
  `R100  docs/old.md  docs/new.md`. The staged rename already passes with only the destination
  declared. This is the required outcome the unit was opened to produce, and it is already true.
- Same fixture with `diff.renames=false`: `--name-only` returns both paths, and the hook blocks
  naming `docs/old.md`. Not the live configuration — `diff.renames`, `status.renames` and
  `diff.renameLimit` are unset in every scope of this repository, so git 2.50.1 applies its default
  of on. Recorded to show the check is fail-capable: the same fixture and the same hook do block when
  the source genuinely reaches the candidate set.
- Rename plus a content rewrite below the similarity threshold: `--name-status` returns
  `A  docs/new.md` and `D  docs/old.md`, and the hook blocks on `docs/old.md`. Git recorded **no
  rename here**, so there is no `R`-source for the log's proposed `--name-status` remedy to exempt.
- Unstaged move plus `git add -A`: porcelain shows ` D docs/old.md` and `?? docs/new.md` — no `->`
  pairing exists yet — and the hook blocks on `docs/old.md`. Again a deletion, not a rename.

Rename detection is demonstrably live in this repository independently of the fixtures: `323b57f`
records `R099` across a directory move.

Deferral noticed and not done: the improvement-log entry's `Severity` and `Proposal` paragraphs rest
on the same mechanical diagnosis and would mislead the next reader of it. Not corrected here because
the brief permits touching that entry only if its rename claim is *fully resolved by the evidence*,
and what this run establishes is that the claim is wrong rather than what should replace it — which
is Codex's reframing decision, not a repair Claude may make inside a hand-back.

## Blocker

**The brief's load-bearing reproduction claim is false, so Unit 1 did not begin.**

The brief's check 4 requires: declare only the existing destination inside the footprint, stage a
rename to it, and show the current hook blocks on the absent source — and it directs a hand-back
without implementing if that does not fail as claimed. It does not fail. The hook exits 0 and prints
nothing.

The improvement log's mechanical root cause is mistaken about its own mechanism. `git diff --cached
--name-only` does not flatten a detected rename into two paths; it prints the destination only. The
status letter the entry says is being "thrown away at the point of collection" was never present on
that path for a rename, so switching the call to `--name-status` and exempting `R`-source paths —
recommended option (a) — would change nothing about the case this unit was scoped to, because that
case already passes.

That leaves the entry's original 2026-08-02 incident unexplained by its own diagnosis, and this run
cannot settle which shape actually produced it: the commit is not reachable on this branch. The three
shapes that do block are each a genuine **deletion** in git's model — `D` with no paired `R` — which
is the case the brief's own boundary paragraph held outside this unit as having "a different
authority problem". So the bounded rename repair has no target, and the shapes with a real failing
case sit outside the agreed scope. Widening to them is a scope change, which core § 6 rule 4 sends
back rather than letting Claude decide.

Nothing else was inspected as broken. The guard's contamination protection is intact and its
rename behaviour on the live configuration is already correct.

## Next action

Codex: decide how to reframe, on three findings — the rename case already passes, the improvement
log's mechanical diagnosis is wrong, and the real failing shapes are deletion-shaped and outside the
current scope. The open questions are whether Normal Trial 1 keeps this defect at all or re-selects a
different representative task; whether the improvement-log entry should be corrected as its own unit,
given its recommended fix would not work; and, if the deletion case is taken up instead, that it
needs a new scope and a new boundary rather than an extension of this one.

Note for the trial assessment: no implementation evidence exists to assess, because the unit stopped
at the premise check by design. Operating facts from this hop are in `## Latest result`.
