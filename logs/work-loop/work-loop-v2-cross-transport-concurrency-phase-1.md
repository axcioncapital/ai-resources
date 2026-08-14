---
task: work-loop-v2-cross-transport-concurrency-phase-1
turn: codex
---

## Objective and scope

Implement and validate Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal: one shared repository-rooted live-lease contract used by the attended carrier and unattended dispatcher, plus fail-closed repository-depth ownership admission before the carrier launches an actor. Complete the controller-level acceptance coverage, preserve both transports' intentional boundaries and existing behavior, make only the necessary Work Loop instruction updates, and run the two explicitly authorized live validations after the implementation has passed independent assessment.

Task exit condition: the Phase 1 implementation and required instruction changes are committed in this worktree, the relevant controller suites and failure paths pass, one genuine cross-transport contention proof and one genuine fan-out-two Work Loop pair produce the accepted evidence, and the final limitations and rollback path are recorded for an operator integration decision.

Scope: the Phase 1 files and test surfaces named in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, plus this state file. Temporary linked worktrees may be created only when the approved live validations require them; implementation remains bound to this checkout.

Excluded: Phase 2 task-aware automatic worktrees; changing or replacing D4; changes to the executable core; automatic merge, landing, push, branch deletion, worktree cleanup or other destructive cleanup; a scheduler, registry, service or lease database; and concurrency outside Work Loop v2. No work is performed in the main checkout.

## Lane and unit

Standard. Implementation mode. Unit 4r2b — recover, verify, and commit only the dispatcher's truthful pin-result handling.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 4r2a is accepted: implementation `1da14105` (pointer `66b1ba80`) recovered the carrier partial and produced focused 32/7 red to 39/0 green evidence across rc=0, rc=1, real rc=2, and an unrecognized result, while preserving outer exit 21 and later refusal 17. The timed-out combined hop's dispatcher script and test partials remain byte-identical, unstaged, and uncommitted, with no evidence yet and therefore no accepted dispatcher result. This unit recovers only that remaining dispatcher half before instruction or live-validation work opens.

Governing authority: the operator-approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, especially §4.1 property 4, §4.3, §4.4 exit-code compatibility, §5 cases 16 and 18, and §8's pinned-lease risks. The accepted Unit 4r1 helper contract at `f4396a7c` and carrier caller contract at `1da14105` are verified repository reality. Phase 2 remains deferred, D4 remains, and the executable core is excluded.

Required outcome: preserve and finish only the unattended dispatcher's interpretation of helper pin results. rc=0 prints and run-log-mirrors the existing durable-pin success message; rc=1 remains the silent “nothing owned” path; rc=2 prints and run-log-mirrors an explicit warning naming `WL_LEASE_PIN_FAILED`, stating that lock directories were retained and later runs remain refused, without printing the durable-pin success message; an unrecognized nonzero is explicitly reported rather than silently merged with rc=1. The outer dispatcher outcome and public exit-code taxonomy remain unchanged.

Claims to verify before changing anything further:

1. Inspect the preserved uncommitted diff in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `dispatch.test.sh`. Establish which required rc=0/1/2/unrecognized behaviors are already implemented and which, if any, are incomplete; do not discard or recreate sound partial work.
2. Confirm the committed dispatcher at HEAD `66b1ba80` still merges rc=1, rc=2 and unexpected nonzero results into silence, and confirm the preserved cases 27ka/27kb exercise the real dispatcher path rather than only grepping source text.
3. Record fingerprints or equivalent before/after evidence for `scripts/axcion-harness-v0.2/carry-turn.sh` and `carry-turn.test.sh`, plus the shared helper. They are accepted dependencies and must remain byte-identical, unstaged, and uncommitted throughout this unit.

Evidence required:

- Produce a focused failing-first dispatcher result against the committed pre-fix dispatcher using the preserved behavioral cases: rc=2 must show the missing terminal/run-log warning, while the rc=0 control remains valid. Do not mutate the committed baseline to manufacture the red.
- Produce focused post-fix dispatcher evidence for rc=0, rc=1, rc=2 and an unrecognized nonzero. For rc=2, prove affected resources are named, both lock directories remain, a second dispatcher is refused with exit 17, the original outer interruption result remains 28, the durable-pin success line is absent, and the warning reaches the existing run log.
- Use the smallest existing sanctioned dispatcher test slice that can exercise cases 27ka/27kb and their rc=0 control. Do not run the complete dispatcher suite; broad regression remains a later plan gate. Temporary evidence runners or baseline copies stay outside the repository and are not committed.
- Record exact red and green commands, assertion totals, exit codes, and representative output. Evidence must be capable of failing.
- Commit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `dispatch.test.sh`, and this state file, using explicit pathspecs. Do not change the carrier files or shared helper. Report the implementation commit and any pointer commit.

Codex framing decisions: this unit inherits the dispatcher partial work from the stopped combined hop and finishes the transport split; it is not a rerun of that hop. Work Loop instruction edits, full-suite regression, and live cases 23/24 remain outside. The Unit 4r1 no-marker limitation is resolved only when this unit proves unattended terminal and durable run-log reporting.

Stop if the preserved dispatcher partial is unsound enough to require redesign, focused evidence cannot isolate dispatcher behavior, truthful reporting requires a new public exit code or helper change, any accepted carrier/helper file changes, or any focused post-fix assertion remains red. Do not run the carrier tests, discard partial work, widen the unit, or rerun the stopped combined hop.

Completion condition: the preserved dispatcher partial is verified and completed; genuine focused red/green evidence proves all four helper outcomes remain distinct through the real dispatcher path and both operator channels; outer outcomes and lock refusal remain correct; only dispatcher files and state are committed; accepted carrier/helper files remain byte-identical; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — read the uncommitted diff of `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `dispatch.test.sh` (`git diff`, 188 insertions across the two). The dispatcher partial is sound and complete: `pin_lock` captures the helper code into `rc` on its own line, then a `case` gives rc=0 the existing durable-pin line, rc=1 a silent `return 0`, rc=2 an explicit `WL_LEASE_PIN_FAILED` warning, and any other code an explicit unrecognised-result warning — all mirrored to `$RUN_LOG`. The test partial is sound but incomplete in one place: cases 27ka and 27kb assert the durable-pin line only in the negative (`grep -n "the task lock is PINNED at" dispatch.test.sh` returned exactly two hits, both inside `if ... then bad`), and no case anywhere asserted it in the positive on either channel — so a dispatcher that stopped printing it entirely would have satisfied the whole partial. That is the only gap; nothing was discarded or recreated.
- Claim (2): HOLDS — `git show 66b1ba80:...dispatch.sh` line 755 reads `wl_lease_pin "${1:-}" "${2:-}" "$TASK" || return 0`, which merges rc=1, rc=2 and every unrecognised nonzero into one silent path. Cases 27ka and 27kb exercise the real dispatcher, not source text: both launch `bash "$DISPATCH_BIN"` as a background run, interrupt it with SIGTERM, and read the resulting terminal output, run log and lock directories; 27ka additionally runs a second real dispatcher and asserts exit 17. 27ka forces rc=2 from inside the run by placing a directory where each `survivors` file must go; 27kb reaches rc=1 and rc=3 by overriding `wl_lease_pin` in the sandbox copy of the library only.
- Claim (3): HOLDS — SHA-256 recorded before and after the unit and unchanged: `carry-turn.sh` `962ca6a5…f80dea`, `carry-turn.test.sh` `d82254f4…4a02895`, `logs/scripts/work-loop-lease.sh` `cb41a2c6…9497cff`. `git status --porcelain` for those three paths was empty before and after, so they stayed byte-identical, unstaged and uncommitted throughout.

Result: implementation commit `294feb28` (this pointer `HEAD`). Unit 4r2b recovered the preserved dispatcher partial unchanged and closed its one gap. `dispatch.sh` needed no further edit. `dispatch.test.sh` gained the rc=0 control inside case 27k: the pin record is proved present on disk (`[ -f "$KTL/survivors" ]`, which separates a real rc=0 from an rc=2 wearing rc=0's message), the durable-pin line is proved present on the terminal, and proved present in the run log. All four helper outcomes are now distinct through the real dispatcher path on both operator channels, and the outer taxonomy is untouched.

Evidence: one focused slice (cases 27k, 27ka, 27kb plus their shared fixtures) built outside the repository by marker-resolved line ranges, never by hand-copied assertions; the full dispatcher suite was not run. Red — `DISPATCH_BIN=<tmp>/dispatch-baseline.sh REPO_ROOT=<repo> bash <tmp>/slice.test.sh`, against the unmodified committed dispatcher extracted with `git show 66b1ba80:…/dispatch.sh` and never edited: exit 1, **pass=19 fail=8**. The eight failures are exactly the missing truthful reporting — the rc=2 warning absent from the terminal and from the run log, the affected resources unnamed, "RETAINED", "still refused (exit 17)" and "removable stale lock" all absent, and the unrecognised code silently swallowed on both its assertions. All nine rc=0 control assertions in 27k passed against the pre-fix dispatcher, so the red isolates dispatcher pin-result reporting and nothing else. Green — same slice, `DISPATCH_BIN=<spike>/dispatch.sh`: exit 0, **pass=27 fail=0**, same 27 assertions. Real post-fix rc=2 run captured on both channels: terminal `WARNING: the pin RECORD could not be persisted for: task checkout.` beside the still-standing `teardown UNVERIFIED`, and the run log carrying the same warning plus `Those lock directories are deliberately RETAINED and were NOT released (…task-85106877b5935f81.lock, and this checkout's lock at …checkout-9e19b5c567c6ca24.lock), so a second dispatcher is still refused (exit 17).` and `Do NOT read them as a removable stale lock`. In that run the durable-pin success line was absent, both lock directories survived, the interrupted run still exited 28, and a second dispatcher was refused with exit 17. The evidence can fail and did: an intermediate green run with `DISPATCH_BIN` unset resolved to a nonexistent path and returned pass=4 fail=23, which is what a slice that proves nothing looks like. Outputs kept untracked at `logs/harness-runs/dispatcher-pin-result-{red,green}-unit-4r2b-20260814.out`; the slice runner and the baseline copy stayed outside the repository and are not committed.

Prior accepted evidence remains: Unit 4r2a carrier 32/7 red to 39/0 green at `1da14105`; Unit 4r1 helper 61/6 red to 67/0 green at `f4396a7c`; dispatcher 482/0; carrier 350/0; owner helper 92/0; Unit 3b1 carrier ownership red 333/17; Unit 3b2r carrier owner-admission green 350/0; earlier cross-transport red/green and stale-oracle mutant evidence.

Open after this unit: the two narrow Work Loop instruction edits required by proposal §1; broad plan-gate regression only where still needed; authorized live cases 23 and 24; final limitations and rollback record. The no-marker limitation is now resolved on both transports. Deferred without action, unchanged and joined by two noticed in this unit: duplicate carrier warning wording, carrier process-group parameter naming, dispatcher case selection, duplicated fixture-packaging knowledge, explicit broken-owner-helper catch-all coverage, the unreachable helper entry state, plus (new) the near-duplicate rc=2 and unrecognised-result warning wording inside `pin_lock`, and (new) the absence of any positive rc=0 assertion in the carrier's own pin-result cases — the same gap this unit closed on the dispatcher side, left alone because the carrier is frozen for this unit.

## Blocker

None.

## Next action

Codex: assess Unit 4r2b. Judge whether the recovered dispatcher partial plus the added rc=0 control satisfies the unit's completion condition — all four helper outcomes distinct through the real dispatcher path on both operator channels, outer taxonomy and lock refusal unchanged, only dispatcher files and state committed, accepted carrier/helper byte-identical. Decide in particular whether extending case 27k with the positive rc=0 assertions was inside this unit or should have been handed back as a brief gap, and whether the two new deferrals are recorded correctly. Then close, continue to the proposal §1 instruction edits, or correct once.
