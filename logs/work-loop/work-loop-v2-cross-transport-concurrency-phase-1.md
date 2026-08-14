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

Standard. Implementation mode. Unit 1 — freeze the central cross-transport lease failures as executable failing-first acceptance cases; do not change production behavior yet.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Phase 1 was explicitly approved on 2026-08-14 after the proposal task closed, together with its two bounded live validations; the operator explicitly retained D4 and deferred Phase 2. This first unit makes the central carrier-versus-dispatcher blindness fail visibly in the existing test system before any production mechanism changes, so later green results can demonstrate a real correction rather than merely describe one.

Governing sources and authority:

- Current operator decision: approve Phase 1 and the two bounded live validations; retain D4 and defer Phase 2. This approval is bound to the proposal committed at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a` and does not authorize the excluded work above.
- Approved implementation basis: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, especially §§ 3–5 and § 7. It governs this task subject to the operator decision above.
- Governing Work Loop behavior: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`; only its separately approved amendments carry approved status where the file says the whole core remains draft.
- Current-state context: `logs/work-loop/work-loop-v2-concurrent-task-isolation.md` and `logs/work-loop/work-loop-v2-production-readiness-policy.md`. D4 remains governing and unchanged.
- Non-governing repair context: `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md`. The already accepted proposal and present approval supply the locked structural scope; this unit must not reopen the diagnosis or expand the plan.

Required outcome: add the smallest executable failing-first test slice that proves the two existing transports cannot currently observe and refuse each other's live lease. Cover both acquisition directions for (a) different tasks contending in one physical checkout and (b) the same logical task contending from different linked worktrees. The tests must exercise the real carrier and dispatcher controller entry paths using their existing sanctioned test seams, and must fail against the current production code for the diagnosed unsafe-admission reason. Do not change production scripts, shared helpers, instructions or policy in this unit.

Claims to verify before changing tests:

1. Re-open the exact carrier and dispatcher lease sections cited by the proposal and confirm the cross-transport blindness still exists at this task's current base. If either transport already reads the other's lease, stop and hand back the false premise.
2. Search `scripts/axcion-harness-v0.2/carry-turn.test.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` for existing carrier-versus-dispatcher contention coverage. Report the searched patterns and do not duplicate a case already present.
3. Establish the existing sanctioned test seams for both programs. Preserve the carrier's refusal of `--actor-cmd`; use only its existing stub-binary seam. Preserve the dispatcher's existing simulated-controller seam. Do not launch a live model in this unit.
4. Record `git status --short --untracked-files=all` before editing. Treat the existing harness captures and ambient `logs/friction-log.md` change as pre-existing unrelated work; do not stage, modify intentionally, delete or commit them.

Required evidence:

- For each of the four required cross-transport combinations, identify the test case, the expected refusal after Phase 1, the current observed unsafe admission, and the actual failing command/output. The evidence must distinguish a failure caused by unsafe admission from fixture, timeout, authentication or permission failure.
- Show that each case exercises the real controller path and can fail for behavior, not merely because a source string or function is absent.
- Report the baseline behavior of directly surrounding existing cases so this red slice is distinguishable from a generally broken test harness. Do not run broader suites whose result this unit cannot use.
- Commit only this state file and the test files or narrowly required test fixture files changed by this unit, using explicit pathspecs. Report `git diff --cached --name-only` before committing and the final commit hash. Leave the four cases intentionally red for the next implementation unit; state that clearly rather than claiming the suite is green.

Codex framing decisions:

- This unit freezes only the four central cross-transport failures, not the proposal's entire 24-row acceptance matrix. Reason: one dominant deliverable fits the bounded handoff, while existing regression guards and two-resource helper cases belong with the mechanisms they protect in later units.
- A committed red slice is acceptable on this dedicated implementation branch because the next unit will make it green; it must be explicit and must not be represented as a releasable state.
- Live validations are held outside this unit. Reason: they are authorized, but controller failures must exist and the implementation must pass assessment before real actors are used.

Completion condition: the four missing cross-transport acceptance cases are committed in the existing test system, each demonstrably fails against current production behavior for the expected unsafe-admission reason, no production or instruction file changed, unrelated work stayed untouched, and the state file hands back at `turn: codex` with the evidence above.

Stop and hand back if the central premise is false, the necessary cases already exist, a case cannot be exercised without a live model, the test harness requires production changes to expose the failure, or the work would touch anything outside the bounded test slice and this state file.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — reopened both lease sections. `scripts/axcion-harness-v0.2/carry-turn.sh`
  636–659: a single lock keyed on `sha256(canonical checkout)` under
  `${TMPDIR:-/tmp}/axcion-harness-v0.2.<key>.lock`, no task lease, no ownership call.
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` 639–650: `LOCK_ROOT` from
  `git rev-parse --git-common-dir` plus `/work-loop-dispatch-locks`, two independent leases;
  ownership admission at 2336–2348. Blindness confirmed by pattern, both directions: searched
  `dispatch.sh` for `axcion-harness-v0.2.` — no match; searched `carry-turn.sh` for
  `work-loop-dispatch-locks`, `--depth repo` and `git-common-dir` — no match, and the only
  `work-loop-owner` occurrence is the comment at 626 saying the declaration is a different
  mechanism. Neither transport reads the other's lease.
- Claim (2): HOLDS — no existing cross-transport contention coverage, so nothing is duplicated.
  Searched `scripts/axcion-harness-v0.2/carry-turn.test.sh` (case-insensitive) for `dispatch`,
  `cross-transport`, `cross transport`, `work-loop-dispatch-locks`, `other program`: zero matches.
  Searched `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` for `carry-turn`,
  `carrier`, `axcion-harness`, `cross-transport`, `cross transport`, `attended`: `carry-turn`,
  `carrier` and `axcion-harness` had zero matches; every `attended` hit (lines 2085–2569) is the
  dispatcher's own non-`--unattended` child shape, not the carrier program.
- Claim (3): HOLDS — seams established and preserved. Carrier: `--actor-cmd` / `--simulate` /
  `--fake-actor` refused at `carry-turn.sh` 316–317; the sanctioned route is a stub binary on
  `--claude-bin`, per its suite header at `carry-turn.test.sh` 8–11. The new cases use only that
  route and pass no simulated-actor flag. Dispatcher: `--actor-cmd` simulated-controller seam,
  per `dispatch.test.sh` 4–6 and every existing case. No live model was launched.
- Claim (4): HOLDS — `git status --short --untracked-files=all` before editing recorded one
  modified `logs/friction-log.md` and eleven untracked files: ten under `logs/harness-runs/` and
  this state file. The friction log and the harness captures are pre-existing unrelated work and
  were not staged, modified or deleted. HEAD at the time was `17210038`.

Result: the four missing cross-transport acceptance cases exist and are red. They were added as
`Case 12e-1` … `12e-4` in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`,
beside the existing lock cluster (12, 12d), together with the helpers they need — `CARRY_BIN`,
`carrier_lock_for`, `make_carry_stub`, `carry_calls`, `CARRY_ALLOW` — and one honest amendment to
the suite header, which previously said every case replaces actors with `--actor-cmd`. No
production script, shared helper, instruction file or policy file was changed.

Both transports are launched for real in every case, each taking its own lease through its own
acquire path. A planted lock directory was rejected as the fixture: the claim under test is whether
one program's code observes the lease the other program's code takes, which a hand-placed directory
cannot show.

Evidence:

- Command: a bounded scratch runner at `/tmp/wl2-xt-slice.sh` (outside the repository, not
  committed) assembled from the suite's own preamble plus cases 12, 12d and 12e, run as
  `DISPATCH_BIN=<repo>/plans/.../dispatch.sh REPO_ROOT=<repo> bash /tmp/wl2-xt-slice.sh`. Result
  `SLICE pass=25 fail=11`, exit 1. The whole suite was not run: this unit cannot use the result of
  the cases it did not touch.
- Before (current production behaviour) — every one of the four fails as unsafe admission:
  - 12e-1 carrier holds the checkout, dispatcher on another task starts: `expected exit 17, got 0`;
    `and the dispatcher launched no actor` FAIL, `actors ran: xt-dispatched;`.
  - 12e-2 dispatcher holds the checkout, carrier on another task starts: `expected exit 17, got 0`;
    `and the carrier launched no actor` FAIL, `launches: 1`; `and committed nothing` FAIL.
  - 12e-3 carrier holds the task in a linked worktree, dispatcher starts on it: `expected exit 17,
    got 0`; `actors ran: xt-shared;`; `and committed nothing` FAIL.
  - 12e-4 dispatcher holds the task, carrier starts on it in a linked worktree: `expected exit 17,
    got 0`; `launches: 1`; `and committed nothing in the worktree` FAIL.
- After Phase 1 the expected behaviour is the assertion already written: exit 17, zero actor
  launches, HEAD unmoved. The cases turn green by behaviour, not by being rewritten.
- The failures are unsafe admission and not fixture, timeout, authentication or permission
  failures. Exit 0 with a completed hop is admission: 12e-4's captured output ends
  `RESULT outcome=CARRIED code=0 task=xt-shared ... turn_before=claude turn_after=codex`, and
  12e-3's dispatcher prints `ownership: PROCEED`, launches, commits and reaches
  `turn=operator — stopping for the operator`. A fixture, timeout, auth or permission failure would
  carry its own non-zero code (10–16, 18–21, 33–35, 37) and no completed hop.
- Each case exercises the real controller path, and can fail for behaviour rather than for an
  absent source string. No assertion greps either script's source. The decisive assertion in every
  case is an actor-launch count read from a file the stub or the simulated actor writes when it
  actually starts, so an implementation that merely mentions the other lease without refusing would
  still fail. Setup assertions confirm the holder's lease really exists before the second program
  starts (`carrier_lock_for`, `checkout_lock_for`, `task_lock_for` all PASS), and 12e-1 and 12e-3
  carry a control proving the holding carrier did launch its own actor — without it the case would
  pass equally against a carrier that never ran.
- Baseline of the directly surrounding cases, in the same run: case 12 (7 assertions) and case 12d
  (8 assertions) are fully green, 15/15. The harness is not generally broken; the 11 failures are
  the new slice alone.
- Working tree after the edit: `logs/friction-log.md` and `logs/harness-runs/` untouched.
  `git diff --cached --name-only` before committing:
  `logs/work-loop/work-loop-v2-cross-transport-concurrency-phase-1.md` and
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. The commit carrying the test
  slice is `54d9db9c`; this hash line is corrected in the immediately following commit, which
  changes this state file only.

**The suite is deliberately red and this is not a releasable state.** The four cases are left
failing for the next implementation unit to make green.

Two notes for the assessment, neither implemented:

- 12e-1's third assertion, `and committed nothing`, passes today. Its fixture task carries
  `turn: codex`, and the simulated actor commits only on a Claude hop, so that particular
  consequence does not materialise there. The two decisive assertions in that case — the exit code
  and the actor-launch count — are red. Left as written rather than re-shaped to maximise redness.
- 12e-4 expects 17 rather than 33. The carrier gains a repo-depth ownership check in the same
  change and that worktree does not declare the task, so ownership alone would also refuse the run.
  17 is expected because the dispatcher takes its leases before ownership admission
  (`dispatch.sh` 1192 versus 2336) and the shared contract is written against what the dispatcher
  already does. The reasoning is recorded in the case's own comment. If the implementation unit
  orders admission first, the expected code becomes 33; the behaviour under test — refused, nothing
  launched — does not move.

Deferral recorded, not done now: the proposal's § 4.2 also requires inverting
`carry-turn.test.sh` § 12b (line 811, "the same task in a separate linked worktree IS admitted").
That is carrier-versus-carrier, not cross-transport, and § 7 step 3 places it with the carrier's own
migration. Out of this unit's bounded slice, so `carry-turn.test.sh` was not touched.

## Blocker

None.

## Next action

Codex: assess the red slice. Are the four cases the right four, is each red for unsafe admission
rather than for a fixture reason, and is the single-file placement in `dispatch.test.sh` accepted
against the proposal's § 4.2 change map? Then decide the next unit — proposal § 7 step 2, extracting
the shared lease and pointing the dispatcher at it.
