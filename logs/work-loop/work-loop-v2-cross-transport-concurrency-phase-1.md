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

Standard. Discovery mode. Unit 9r3 — run the single full dispatcher regression gate.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 9r2 is accepted at `40bb184e`: the focused controller case passed 20/0, the losing dispatcher wrote a durable exit-17 terminal record without launching an actor, `--status` remained no-write, and syntax and diff checks passed. The only remaining implementation gate before retrying live case 23 is the complete dispatcher controller suite, deliberately separated because combining it with implementation exceeded the fixed hop timeout.

Governing authority: the operator-approved Phase 1 proposal §7 step 4 requires the dispatcher regression suite before live validation. This unit is evidence-only and makes no implementation change.

Required outcome and evidence: run `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` exactly once against committed HEAD `40bb184e`, capture its complete output under `logs/harness-runs/`, and report the final pass/fail count and exit code. Do not rerun the focused case separately. Commit only the state-file handoff with explicit pathspec; raw output remains uncommitted evidence.

Scope: the dispatcher suite, raw evidence under `logs/harness-runs/`, and this state file. Excluded: source or test edits, fixes, live case 23, case 24, Phase 2, main checkout, push, cleanup, and any extra validation.

Stop and hand back if the suite fails or cannot complete inside the unchanged timeout; preserve the output and do not repair or rerun it.

Completion condition: one complete dispatcher suite reaches its final summary at exit 0 with no failures, its evidence path is recorded, only the state handoff is committed, and the task returns at `turn: codex`.

## Latest result

Inspected (2026-08-14) — checked before running anything:

- Claim (1): HOLDS — ran `git rev-parse --short HEAD` and `git log -1` in this checkout; HEAD is `40bb184e`, subject "unit 9r2 makes a pre-actor exit-17 refusal leave a durable record". The suite therefore ran against the commit the brief names.
- Claim (2): HOLDS — `ls -l plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` returns a present, executable 211074-byte file, and `git status --porcelain plans/work-loop-v2-v0.2/handoff-automation-spike/` returned no lines, so neither the dispatcher nor its suite carries a working-tree edit. The run is against committed HEAD, not a dirty tree.
- Claim (3): HOLDS — `logs/harness-runs/` exists (untracked) and accepted the new capture.

Result: the complete dispatcher controller suite is green at HEAD `40bb184e` — **pass=537, fail=0, exit 0**, reaching its own final summary line `pass=537 fail=0  (all cases SIMULATED — no live product transport)`. No source or test file was edited, no fix was applied, no live hop ran, and HEAD is unmoved at `40bb184e` with the spike directory still clean.

Evidence: `logs/harness-runs/20260814-unit9r3-dispatcher-suite-full.out` (751 lines, uncommitted raw evidence), captured with `SUITE_EXIT=0` appended by the wrapper. `grep -c '  FAIL'` over that file returns 0 and `grep -c '  PASS'` returns 537. The suite is falsifiable by its own first case and was observed exercising that: Case 0 — harness falsifiability asserts the suite fails when the dispatcher binary is absent (exit 127) before asserting the dispatcher under test exists. Unit 9r2's new case is inside this run and green under the full harness rather than in isolation — Case 12h, four assertions at lines 133–137 of the capture: the second dispatcher is refused at 17 by a real held lease, the requested `--log-dir` received a run log for the refused run, the human refusal reached that log, and a stable terminal-record line is present.

Correction to the record: a previous hop (`20260814T202444-61808`, actor exit 0 at 70s) started this same suite in the background and ended its turn before the suite finished, leaving a 52-line partial capture at `logs/harness-runs/20260814-unit9r3-dispatcher-suite.out` that stops mid Case 10. That is an abandoned run, not a suite failure and not a timeout — the dispatcher classified the hop NO_TRANSITION (exit 22) and no result was ever handed back. The partial file is preserved untouched; this unit's run was written to a separate filename and is the first complete one. If Codex holds "run exactly once" to mean one *attempt* rather than one *completed* run, this is the finding to rule on.

Carried forward, still open:

- Deferral, recorded and not done: `LOCK_KEY` is never assigned anywhere in `dispatch.sh`; the only occurrences are the explanatory comment and the use in `RUN_ID`. Under `set -uo pipefail`, `${LOCK_KEY:0:8}` expands to empty, so `RUN_ID` carries an empty key segment and only `$$` separates two same-second runs of one task from different checkouts. Pre-existing at HEAD, outside this unit's bounds.
- Live case 23 is not accepted. Unit 9's live hop refused correctly at exit 17 while the attended carrier held the shared lease, but `logs/harness-runs/case23-live-dispatcher/` was never created — that observed absence was the failing case Unit 9r2 fixed. The retry is the next validation, not part of this unit.

## Blocker

None.

## Next action

Codex: assess Unit 9r3 — the full dispatcher suite is green at HEAD `40bb184e` (537/0, exit 0) with Case 12h passing inside it. Decide whether the implementation gate is satisfied and live case 23 may be retried, and rule on the abandoned-partial-run point recorded above.
