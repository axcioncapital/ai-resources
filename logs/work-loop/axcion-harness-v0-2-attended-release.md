---
task: axcion-harness-v0-2-attended-release
turn: operator
---

## Objective and scope

Ship Axcíon Harness v0.2 as a usable attended-only release today: one thin canonical launch surface
around Work Loop v2 that carries an already-explicit turn through fresh actor processes, validates
the handback, and stops visibly without creating another semantic state system.

This task lives only in the `ai-resources` checkout. Scope is the minimum attended production
surface under `scripts/axcion-harness-v0.2/`, its fail-capable evidence, and this one state file.
Excluded: Work Loop semantic revisions; new task artifacts or schemas; hidden session resume; hooks
or daemons; unattended or automatic multi-hop execution; worktree automation; automatic push,
merge, landing, or cleanup; the retired Monday-prep task; the May harness; and unrelated work.

## Lane and unit

Standard. Discovery mode. Unit 2 — prove the canonical launcher on one real attended fresh-process
carry and establish whether the Phase 2 vertical-slice exit is met.

Named reason for the loop: deployment depends on a real cross-process handoff, the result must
survive the fresh session, and Codex must assess evidence produced by an actor other than itself.

## Brief

Why this unit, why now: Unit 1 produced the canonical attended launcher and strong deterministic
evidence, but the project plan's Phase 2 exit requires a real bounded task to cross a fresh-process
handoff. This unit resolves only that remaining unknown; it does not reopen the implementation or
expand the release.

**Named unknown.** Can `scripts/axcion-harness-v0.2/carry-turn.sh` carry this already-explicit
Claude turn through a real fresh Claude process, using this state file and repository facts alone,
and return a valid committed `claude -> codex` handback with one unambiguous terminal result?

**Governing sources and authority.**

- The operator's 2026-08-11 decision authorizes an attended Harness v0.2 release today while
  keeping unattended execution disabled.
- The governing project direction is `plans/axcion-harness-v0.2/mvp-plan.md`, Phase 2 and its exit
  condition. Its older proposed/no-implementation header is superseded for this attended release
  only by the current operator decision.
- Work Loop semantics remain owned by
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.
- Unit 1's accepted production surface is
  `scripts/axcion-harness-v0.2/carry-turn.sh`; do not substitute the spike dispatcher or revise a
  semantic source.

**What Claude must do after the launcher starts it.** Verify the exact task identity, checkout, and
Unit 2 brief from this file. Inspect the run evidence visible to the child and the repository facts
available after launch. Do not change the launcher or run the deterministic suite again. Write a
concise result stating whether the process was fresh, whether this state file and its cited durable
sources were sufficient to reconstruct the task, whether the invocation used attended
`--permission-mode default`, whether checkout and task binding were exact, and whether any
permission prompt, foreign writer, malformed transition, or other operator intervention occurred.
Set `turn: codex` and commit only this state file.

**Claims to verify.**

1. The process was launched for exactly task `axcion-harness-v0-2-attended-release` in exactly the
   current `ai-resources` checkout. Settle this from the invocation/runtime evidence and the state
   file resolved by the Work Loop command.
2. The child is a fresh Claude process and reconstructs the unit from this file plus the cited
   durable sources, without transcript ferrying. State what observable evidence supports this and
   distinguish it from inference.
3. The attended argv includes `--permission-mode default`; no bypass or unattended flag is
   present. Inspect the run log or runtime invocation evidence rather than relying on Unit 1 prose.
4. Only this state file changes during the child turn. Inspect repository status/diff and commit by
   exact pathspec before handback.

**Evidence required.** Quote the launcher's terminal `RESULT` line if it is visible after the
actor returns. If a child cannot observe its parent's eventual terminal line, say so rather than
inventing it and leave that repository fact for Codex to read from the run log. Record the Claude
process's observable invocation/runtime evidence, the resulting state transition, the commit
identity, and every operator intervention. Evidence must distinguish direct observation from
inference.

**Boundary and exclusions.** This is a Discovery unit and live transport experiment, not an
implementation unit. Only this exact state file may change or be committed. Do not edit the
launcher, tests, plans, skills, commands, settings, friction log, another task, or any unrelated
path. Do not launch another model process, continue a second hop, enable unattended behavior,
approve a permission prompt, or work around a guard. Codex's framing decision is to reuse this task
as the bounded real task so the proof creates no second task artifact.

**Completion condition.** One real fresh Claude process reads and completes this discovery brief,
commits the state-only handback, and sets `turn: codex`; or the launcher/Claude stops with an exact
failure and no workaround. Either outcome must leave enough evidence to decide whether Phase 2 is
met or which single blocker remains.

**Stop conditions.** Stop on any false identity or checkout premise, permission prompt, foreign
writer or dirty-path ambiguity, actor failure, timeout, invalid/no transition, out-of-bound change,
or inability to commit the state-only handback. Do not retry inside the actor.

## Latest result

Unit 1 accepted by Codex. The canonical attended-only launcher and deterministic suite satisfy the
implementation boundary: 98/0 green, five fail-capability mutants, explicit default Claude
permission mode, exact binding and transition guards, mechanical refusal of unattended and
multi-hop requests, and one structured terminal result. Accepted commits: `a232971` and corrective
record commit `bdfe91f`; the second commit is accepted because concurrent movement of `main` made
an amend unsafe and it changed only the factual record. The only release-blocking limitation
carried forward is that the new surface has not yet completed a real fresh-process hop.

## Blocker

The canonical live carry stopped before launching Claude with exit 18 because the checkout contains
unrelated dirty paths: `logs/friction-log.md`, two old Monday-prep task paths, prior spike run
captures, and `scripts/recall-search.py`. The terminal record was
`RESULT outcome=STOPPED code=18 task=axcion-harness-v0-2-attended-release mode=live actor=none
turn_before=claude turn_after=none`; full evidence is in
`/private/tmp/axcion-harness-v0.2-live/20260811T121236-57811-axcion-harness-v0-2-attended-release.log`.
No actor launched and no path besides this state file changed. The run will not be retried.

The unit does not legitimately touch those paths, so widening `--allow-path` would weaken the
release proof. The current checkout must be made clean by the owners of those changes, or the
operator must choose a deliberately isolated clean checkout for a new live trial. Codex will not
commit, stash, delete, or overwrite the unrelated work.

## Next action

Operator: choose whether the unrelated changes are finished/parked in this checkout or whether the
live trial moves to a deliberately isolated clean checkout. Preserve `scripts/recall-search.py`
unless its owner explicitly disposes it.
