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

Standard. Implementation mode. Unit 4r2a — recover, verify, and commit only the carrier wrapper's truthful pin-result handling.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The combined Unit 4r2 hop stopped at the fixed 900-second boundary with exit 21, leaving allowed uncommitted partial edits in both wrappers and both test files while the state file and HEAD remained unchanged at `a0ab4061`; both live leases are free. Inspection found a directionally complete carrier implementation and carrier section 12f, but no returned test evidence or commit, so none of that partial work is accepted yet. On 2026-08-14 the operator approved this fresh smaller recovery, bounded to the carrier half while the dispatcher partial edits are preserved untouched for Unit 4r2b.

Governing authority: the operator-approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, especially §4.1 property 4, §4.3, §4.4 exit-code compatibility, §5 cases 16 and 18, and §8's pinned-lease risks. The accepted Unit 4r1 helper contract at `f4396a7c` is verified repository reality. Phase 2 remains deferred, D4 remains, and the executable core is excluded.

Required outcome: preserve and finish only the attended carrier's interpretation of helper pin results. rc=0 prints the existing durable-pin success message; rc=1 remains the silent “nothing owned” path; rc=2 produces an explicit warning naming `WL_LEASE_PIN_FAILED`, stating that the lease directories were retained and later runs remain refused, without printing the durable-pin success message; an unrecognized nonzero is reported explicitly. The outer carrier outcome and public exit-code taxonomy remain unchanged.

Claims to verify before changing anything further:

1. Inspect the preserved uncommitted diff in `scripts/axcion-harness-v0.2/carry-turn.sh` and `scripts/axcion-harness-v0.2/carry-turn.test.sh`. Establish which required rc=0/1/2/unrecognized behaviors are already implemented and which, if any, are incomplete; do not discard or recreate sound partial work.
2. Confirm the committed pre-fix carrier at HEAD `a0ab4061` merges rc=1, rc=2 and unexpected nonzero results into silence, and confirm the preserved section 12f exercises the real carrier path rather than only grepping source text.
3. Record fingerprints or equivalent before/after evidence for the two dispatcher partial files. They are preserved inputs to Unit 4r2b and must remain byte-identical, unstaged, and uncommitted throughout this unit.

Evidence required:

- Produce a focused failing-first carrier result against the committed pre-fix carrier using the preserved behavioral cases: rc=2 must show the missing warning, while the rc=0 control remains valid. Do not mutate the committed baseline to manufacture the red.
- Produce focused post-fix carrier evidence for rc=0, rc=1, rc=2 and an unrecognized nonzero. For rc=2, prove the affected resources are named, both lease directories remain, a second carry is refused with exit 17, the original outer timeout result remains 21, and the durable-pin success line is absent.
- Use the smallest existing sanctioned carrier test slice that can exercise section 12f and its rc=0 control. Do not run the complete carrier suite; broad regression remains a later plan gate. Temporary evidence runners or baseline copies stay outside the repository and are not committed.
- Record exact red and green commands, assertion totals, exit codes, and representative output. Evidence must be capable of failing.
- Commit only `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`, and this state file, using explicit pathspecs. Leave both dispatcher partial files untouched and uncommitted. Do not change the shared helper. Report the implementation commit and any pointer commit.

Codex framing decisions: this unit inherits the carrier partial work from the stopped hop and separates it by transport, not by repeating the combined brief. Dispatcher wrapper/test edits, Work Loop instruction edits, full-suite regression, and live cases 23/24 remain outside. The Unit 4r1 no-marker limitation remains unresolved until both wrappers report it truthfully.

Stop if the preserved carrier partial is unsound enough to require redesign, focused evidence cannot isolate the carrier behavior, truthful reporting requires a new public exit code or helper change, either dispatcher partial file changes, or any focused post-fix assertion remains red. Do not run the dispatcher tests, discard partial work, widen the unit, or rerun the stopped combined hop.

Completion condition: the preserved carrier partial is verified and completed; genuine focused red/green evidence proves all four helper outcomes remain distinct through the real carrier path; outer outcomes and lease refusal remain correct; only carrier files and state are committed; dispatcher partials remain byte-identical and uncommitted; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — read the preserved uncommitted diff of `scripts/axcion-harness-v0.2/carry-turn.sh` (+54/-3, `pin_leases` only) and `scripts/axcion-harness-v0.2/carry-turn.test.sh` (+110, new section 12f only). All four required behaviors are already present and sound: `rc` is captured on its own line after the call (not through a `local` assignment), and the `case` gives rc=0 the two existing success lines, rc=1 a `:` no-op, rc=2 a three-line warning naming `${WL_LEASE_PIN_FAILED}` plus retention, exit-17 refusal and the anti-stale-lease caution, and `*)` an explicit unrecognised-code report. `return 0` still terminates every branch, so the outer outcome is untouched. Nothing was incomplete; no code was added, discarded or recreated in this unit.
- Claim (2): HOLDS — `git show a0ab4061:scripts/axcion-harness-v0.2/carry-turn.sh` line 819 reads `wl_lease_pin "${1:-}" "${2:-}" "$TASK" || return 0`, so rc=1, rc=2 and any unexpected nonzero all take the same silent return; searched that file for any other `wl_lease_pin` call and found only that one. Section 12f drives the real carrier: each case invokes `"$SUT"` with a fixture checkout, a fake actor and a stubbed `ps`, then asserts on the launcher's own stdout and exit code — searched the section for `grep .* "$SUT"` and other source-text assertions and found none.
- Claim (3): HOLDS — `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` = `674f2642a03d6393d2eaf204834f8dad111d9e0071aba558724ffe3fc95f25f2` and `dispatch.test.sh` = `34097ed24882bba6b57397be164dd83ba541f2c0fa7821c85e813f56ccbb2394`, taken before any work and re-taken after the green run: identical both times, and `git status --porcelain` still shows both as unstaged ` M`. `logs/scripts/work-loop-lease.sh` and `work-loop-owner.sh` are clean at `f4396a7c`.

Result: Unit 4r2a is committed at `1da14105` — `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh` and this state file, by explicit pathspec and nothing else. It recovered the preserved carrier partial unchanged and proved it. The attended carrier now answers each helper pin result as itself — rc=0 keeps the durable-pin success lines, rc=1 stays silent, rc=2 warns and withholds the success line, and an unrecognised code is reported as unrecognised. Outer outcomes and the public exit-code taxonomy are unchanged. Committed carrier files plus this state file only.

Evidence: a focused two-section slice (12d as the rc=0 control, 12f as the new behavior) assembled from the working-tree suite into `$TMPDIR/wl2-4r2a-evidence/slice.test.sh`, outside the repository and not committed; it adds one line, `SUT="${WL_SLICE_SUT:-$SUT}"`, so the same assertions can be pointed at either carrier. The complete carrier suite was not run.

- RED, against the committed pre-fix carrier extracted read-only to `$TMPDIR/wl2-4r2a-evidence/carry-turn.PREFIX.sh` (sha256 `c159c928df47a367…`, baseline never mutated): `LEASE_BIN=… OWNER_BIN=… WL_SLICE_SUT=…/carry-turn.PREFIX.sh bash slice.test.sh` → **passed 32, failed 7**, exit 1. The seven are the rc=2 warning (record-not-persisted, resources named, retained, still-refused, stale-lease caution) and the two unrecognised-code assertions. Every 12d assertion stayed green, so the rc=0 control is valid and the red is not a broken slice.
- GREEN, same slice against the working-tree carrier: `WL_SLICE_SUT=…/scripts/axcion-harness-v0.2/carry-turn.sh bash slice.test.sh` → **passed 39, failed 0**, exit 0.
- rc=2 forced for real, not stubbed: a `ps` shim makes `<lease>/survivors` a directory at the moment the launcher looks, so the write cannot create the file for any user. Representative output — `WARNING: the pin RECORD could not be persisted for: task checkout.` / `Those lease directories are deliberately RETAINED and were NOT released, so the next Work Loop run … is still refused with exit 17.` / `Do NOT read them as a removable stale lease…`, and `RESULT outcome=STOPPED code=21`. Asserted alongside it: `BOTH leases are now PINNED` absent, both lease directories still present, `[ -f <lease>/survivors ]` false (the evidence really is missing), a second carry refused with **17** launching nothing further, and the outer result still **21**. rc=1 and rc=3 are reached through a committed per-fixture stub of `wl_lease_pin`, the only route to them from here.
- `bash -n` passes on both changed files. Both dispatcher partial files are byte-identical, unstaged and uncommitted (Claim 3).

Prior accepted evidence remains: Unit 4r1 helper implementation `f4396a7c` (pointer `a0ab4061`), pre-fix 61/6 red and post-fix 67/0 green, with the helper never automatically reaping a dead-holder directory — where no marker can persist the residual risk is an operator mistaking an unexplained held lease for a removable stale one, not an automatic unsafe admission. Also: dispatcher 482/0; carrier 350/0; owner helper 92/0; Unit 3b1 carrier ownership red 333/17; Unit 3b2r carrier owner-admission green 350/0; earlier cross-transport red/green and stale-oracle mutant evidence.

Open after this unit: Unit 4r2b, the dispatcher half of the same truthful pin-result reporting, whose partial edits are preserved untouched; the two narrow Work Loop instruction edits required by proposal §1; broad plan-gate regression only where still needed; authorized live cases 23 and 24; final limitations and rollback record. The Unit 4r1 no-marker limitation is now resolved on the attended side only and stays open until the dispatcher reports it truthfully too.

Deferred without action, noticed and not done: the two 12f warning branches (rc=2 and unrecognised) repeat the retention-and-exit-17 sentence in slightly different words, which a later unit could fold into one shared line — left alone here because the brief froze this unit to the carrier's pin-result interpretation and rewording asserted operator text would put the frozen assertions at risk for no behavioral gain. Still deferred from before: carrier process-group parameter naming, dispatcher case selection, duplicated fixture-packaging knowledge, explicit broken-owner-helper catch-all coverage, and the unreachable helper entry state above.

## Blocker

None.

## Next action

Codex: assess Unit 4r2a. Decide whether the recovered carrier partial and its focused 32/7 red to 39/0 green evidence satisfy the unit's completion condition — in particular whether forcing rc=2 for real while reaching rc=1 and the unrecognised code through a committed per-fixture pin stub is acceptable evidence, and whether the deferred duplicate-wording note is correctly deferred rather than corrected. Then close, continue to Unit 4r2b (the preserved dispatcher half), or correct once.
