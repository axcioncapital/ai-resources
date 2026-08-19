---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 24 — add explicit attended permission selection

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 23 is accepted at `be4fed75b2c02068fa9a094ef6aa342428f0ce7a`. It closed the remaining reachable hostile terminal-result inputs. The previously proposed acceptance-map discovery was cancelled by operator-invoked `$realign`: Change set D already owns the comprehensive proof sweep, final regression and independent review, so adding an intermediate review of the same evidence would be recursive ceremony.

The first concrete Change set B requirement is attended `default | acceptEdits` permission selection. Today the attended Claude launch hard-codes `default`; this unit adds the smallest explicit per-invocation selection and truthful requested-mode evidence. Effective-mode observation and denial/resume are separate later behaviors and must not be pulled into this unit.

Dominant deliverable: explicit attended permission-mode selection between `default` and `acceptEdits`, with no inherited or persistent grant.
Evidence required in this hop: one targeted failing case for an explicit `acceptEdits` invocation; passing argv and terminal-result evidence for both modes; invalid/bypass refusal before admission; focused tests only.
Evidence explicitly deferred: effective permission-mode observation; denial followed by resume; permission-prompt handling; retry/budget work; the cancelled Change set A proof map; full regression; Change sets B remainder, C and D; live trials; adoption review; cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused case shows the dispatcher cannot currently carry an explicit attended `acceptEdits` selection to the Claude argv and requested-mode result field.

Required outcome:

- Add one per-invocation attended permission selection whose only accepted values are `default` and `acceptEdits`. Omitting it must preserve `default`.
- `acceptEdits` must exist only because the operator supplied it for this invocation. Do not read prior runs, settings, state prose or environment to infer it, and add no persistent approval store.
- Pass the selected value to the attended Claude launch through the existing `--permission-mode` argv position. Preserve the existing explicit override that prevents repository settings from silently supplying `bypassPermissions`.
- Record the selected value as `permission_mode_requested` in the run's terminal result. Keep `permission_mode_effective` truthful as `unavailable` in this unit; do not claim the request was enforced or observed.
- Refuse `bypassPermissions`, unknown values, and a missing value before run admission: no actor, owner/lease, evidence or repository mutation.
- Do not change unattended mode, simulated actors, permission-denial extraction, resume behavior, capability policy, settings files or any default outside this invocation.

Check against the repository:

1. Verify Unit 23 commit and state-only scope without rerunning discovery.
2. Verify the approved Change set B permission-transport wording and the current hard-coded attended launch/result derivation before editing.
3. Inspect existing argv-recording and invalid-argument fixtures and extend the nearest focused mechanism; do not add another harness.
4. If the current CLI cannot accept `default` or `acceptEdits` through the existing launch position, stop and hand back rather than inventing a different authority mechanism.

Required fail-capable evidence:

- Quote the focused pre-edit failure for explicit `acceptEdits` selection.
- Show default omission and explicit `default` both produce attended argv with `--permission-mode default` and terminal evidence `permission_mode_requested=default`.
- Show explicit `acceptEdits` produces attended argv with `--permission-mode acceptEdits` and terminal evidence `permission_mode_requested=acceptEdits`, while `permission_mode_effective=unavailable` remains honest.
- Show `bypassPermissions`, an unknown token and a missing value each refuse before admission with no actor, lease or evidence effect.
- Include a narrow mutation/control proving the `acceptEdits` case fails if the selected value is replaced by hard-coded `default` on the attended launch.
- Run only new and directly affected focused cases; report exact commands and counts. Defer the full suite.
- Report the implementation commit and confirm only `dispatch.sh`, `dispatch.test.sh` and this state file were committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan and current dispatcher/tests; edit `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its existing test file and this task state; run focused local shell tests; and make local commits. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No live model launch, authentication attempt, network, external service, full-suite run, merge, push, deployment, destructive cleanup or other operator-reserved capability is permitted.

Completion condition: one committed implementation handback adds bounded explicit attended permission selection and truthful requested-mode evidence, proves refusal and no-effect behavior for invalid modes, changes only the bounded files, and returns with `turn: codex`.

Stop and hand back if this requires persistent approval, changing repository settings, broadening authority beyond `acceptEdits`, modifying unattended mode, or claiming an effective permission mode that cannot be observed.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS — `git show --stat --name-only be4fed75` lists one file, this state file. State-only; discovery not rerun.
- Claim (2): HOLDS — plan `:229`–`:234` is the permission-transport wording. Pre-edit the attended launch passed the **literal** `--permission-mode default` (`dispatch.sh:4296`, `:4299`) and `result_permission_mode_requested()` restated the same literal (`:698`), with `permission_mode_effective` already unconditionally `unavailable` (`:860`).
- Claim (3): HOLDS — the nearest existing mechanism is `FAKE2` (test `:5006`), the attended-capable stub that records the child's argv, plus `argv_has()` (`:5023`). Both extended; no new harness added.
- Claim (4): HOLDS — the CLI accepts the value through the existing `--permission-mode` argv position, so the hand-back condition did not fire. Nothing else was invented as an authority mechanism.

### Pre-edit failure, quoted (the `Primary edit begins after:` condition)

Case 71b against `be4fed75`:

```
  FAIL  71b — the hop completes with --permission-mode acceptEdits
  FAIL  71b — the child's argv carries acceptEdits
  FAIL  71b — permission_mode_requested=acceptEdits
```

Focused RED baseline: **`pass=18 fail=9`**.

### Result

One per-invocation selection, `default | acceptEdits`, carried to the attended child and reported honestly.

- `PERMISSION_MODE` defaults to `default` and is set **only** by `--permission-mode` on this command line. No settings key, environment variable, state prose or memory of a previous run can raise it, and no approval is stored.
- Validated **before admission**, beside the other usage checks — so an invalid request launches no actor and takes no owner, lease, evidence or repository change. The accepted set is closed: `bypassPermissions` gets its own named message because it is the value an operator actually reaches for, but the refusal does not depend on naming it — anything outside the two values falls through the same branch.
- The launch passes `--permission-mode "$PERMISSION_MODE"`, and `result_permission_mode_requested()` returns the same variable, so the record cannot name a mode the child was not asked for. `permission_mode_effective` stays `unavailable`.
- **P0-F's property is preserved and asserted, not assumed.** Its finding was never the word `default` — it was that an *inherited* mode let a child run under this checkout's `defaultMode: bypassPermissions`. Both accepted values are fixed before admission and stated explicitly on every attended launch, so nothing is inherited. Case 71a asserts the argv still states a mode explicitly when the flag is omitted.

### One judgment call, disclosed for your ruling

The brief's required outcome did not mention `--unattended` or `--actor-cmd`. Neither passes a permission mode to anything — the contained profile deliberately carries none, and a simulated actor replaces the launch entirely. I **refused** `acceptEdits` alongside either (exit 10, pre-admission) rather than accepting and ignoring it, because accepting would let the operator request an elevation that is then silently not applied — the same falsification the existing `--unattended`/`--actor-cmd` guard refuses one flag over. `default` remains compatible with both, and case 71e asserts that the compatible pairing still runs.

This changes no unattended behaviour: it bounds the new flag. If you read it as scope the unit should not have taken, it is two `if` blocks and reverting them leaves everything else standing.

### Evidence

| Check | Pre-edit (`be4fed75`) | Implemented |
|---|---|---|
| Focused cases 71a–71f | `pass=18 fail=9` | **`pass=28 fail=0`** |
| Launch-path cases 32–32l (attended and unattended argv) | `pass=84 fail=1` | **`pass=84 fail=1`, `diff`-identical** |
| Unit 22 path cases 70a–70g | — | **`pass=23 fail=0`** |
| Legacy cases 40–50b | `pass=157 fail=6` | **`pass=157 fail=6`, identical to the Unit 22 baseline** |

Commands (extracts in the scratchpad; `REPO_ROOT`/`OWNER_BIN`/`LEASE_BIN`/`STATE_BIN` pinned to this checkout, `DISPATCH_BIN` selecting the version under test):

```
DISPATCH_BIN=<be4fed75 copy> bash case71.test.sh  -> pass=18 fail=9
DISPATCH_BIN=<implemented>   bash case71.test.sh  -> pass=28 fail=0
DISPATCH_BIN=<be4fed75 copy> bash launch.test.sh  -> pass=84 fail=1
DISPATCH_BIN=<implemented>   bash launch.test.sh  -> pass=84 fail=1
DISPATCH_BIN=<implemented>   bash case70.test.sh  -> pass=23 fail=0
DISPATCH_BIN=<implemented>   bash legacy.test.sh  -> pass=157 fail=6
```

The launch-path extract's single failure is an extract artifact (a `--settings` path the extract composes differently) and is byte-identical before and after. The legacy six are the same six as at Unit 22 acceptance. Both compared line by line, not by count.

**Mutation control (case 71f).** One substitution — `--permission-mode "$PERMISSION_MODE"` back to the hard-coded `--permission-mode default` at the launch site — leaves validation, evidence and every other path intact and makes 71b's argv assertion fail. 71b is fail-capable.

### Honest limit of these cases

71d's and 71e's exit-10 assertions are **not** discriminators against the pre-edit dispatcher, which also exits 10 on `--permission-mode` as an unknown argument. What moves is the by-name `bypassPermissions` message and the compatible-pairing case, both red pre-edit. The no-effect assertions (no evidence directory, untouched repository, no ownership declaration) are meaningful only once the flag exists, and are what prove the new pre-admission refusal takes no effects.

### Bounded-scope confirmation

Only `dispatch.sh`, `dispatch.test.sh` and this state file were committed. Stale prose describing the old hard-coded literal was corrected in four places, and the `--help` header now documents the flag, its refusals and the effective-mode honesty. No settings file, unattended profile, denial extraction, resume behaviour or capability policy changed. Full suite deferred. `logs/friction-log.md` left unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 24 — explicit attended `default | acceptEdits` selection is carried to the child argv and reported as `permission_mode_requested`, invalid and over-broad values are refused before admission with no effect, `permission_mode_effective` stays honestly `unavailable`, and P0-F's explicit-mode property is preserved and asserted. One in-scope judgment call is disclosed above: refusing a non-default mode under `--unattended`/`--actor-cmd` rather than silently dropping it. Rule on that, then decide the next Change set B requirement.
