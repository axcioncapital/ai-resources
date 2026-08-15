---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push. The operator wants Phase 1 finished and merged as soon as the plan's final gates support it; merge follows task closure and final review.

## Lane and unit

Standard. Discovery mode. Unit 8 — complete live validation case 23, genuine cross-transport contention.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1–7 are accepted. The controller matrix and full clean verification gates are green; the nearest unmet done condition is the correction plan's live case 23. This unit produces that one live result and nothing else. It must be executed as the actor of a real attended carrier hop; that carrier is the subject under test. If this file is opened in an ordinary interactive Claude session instead, do not invoke another model or simulate the case—hand back that the required transport was not used.

Governing source: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md` at approved content commit `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially `### Case 23 — genuine cross-transport contention`. The governing proposal's case 23 classifies this as live actor evidence; controller or stub-only evidence cannot satisfy it.

Required outcome: while this real attended carrier hop holds both leases for this task and checkout, run the real dispatcher against the same task and checkout and prove the complete post-fix losing path in one observation. The dispatcher must be configured with a harmless sentinel actor command whose only purpose is to prove that no actor was launched; it must not invoke Claude, Codex, or another model.

Required evidence:

- Before starting the dispatcher, prove that this invocation is running under the real attended carrier, that both task and checkout leases exist in the shared Git-common lease root, that both record `program=carry`, and that the carrier's launcher is live. Record the exact paths and metadata needed to distinguish a real lease from a planted fixture.
- Capture a before-state for the checkout sufficient to detect any write by the losing dispatcher, while separating pre-existing operator-owned `logs/friction-log.md` and `logs/harness-runs/` and this carrier actor's own later state-file update from the dispatcher observation.
- Start the real `dispatch.sh` against this exact checkout and task. Prove exit 17, refusal before actor launch, wording that names an attended carry rather than a dispatcher, and that the sentinel actor did not run.
- Prove a durable refusal record was created under the Git common lease root, outside every worktree, and quote its fields establishing the task, terminal result, holder attribution, and `actor_launched=no`.
- Prove the losing dispatcher created no requested in-checkout log directory and left the measured checkout state unchanged.
- After the refusal and before this carrier actor exits, prove the carrier still owns the same two leases and that its work/state was not disturbed. Record enough post-hop evidence for Codex to verify carrier completion and normal release after the attended command returns.
- Record exact commands, exit codes, evidence paths, deviations, remaining limitations, and whether every one of the correction plan's seven case-23 steps passed as one live path.

Authorized repository changes: this state file only. The attended carrier may create its normal untracked run evidence under `logs/harness-runs/`, and the existing hook may modify `logs/friction-log.md`; neither may be staged or committed. The losing dispatcher's refusal record belongs under the Git common lease root, not in a working tree. Do not change production, tests, plans, the closing record, or any other worktree. Do not remove or rewrite pre-existing operator-owned files.

Completion condition: all seven plan steps for live case 23 are supported by one genuine carrier-versus-dispatcher run; no losing actor launches; the checkout remains uncontaminated by the loser; Claude records the evidence here, sets `turn: codex`, commits only this state file, and exits normally so the attended carrier can finish and release its leases.

Stop and hand back without improvising if this invocation is not itself inside the real attended carrier, either lease is absent or not carrier-held, the dispatcher launches its sentinel, the loser writes inside the checkout, the refusal record is missing or inaccurate, the carrier's leases/work are disturbed, or any proof would require invoking a nested model or changing an unauthorized file.

## Latest result

Inspected (2026-08-15):

- Claim (1) — this invocation is the actor inside a real attended carrier hop: HOLDS. Read the process ancestry of this shell: this Claude process is pid 27589, whose parent is pid 27235, which `ps -o pid=,ppid=,lstart=,command= -p 27235` shows started Sat Aug 15 15:38:45 2026 as `/bin/bash scripts/axcion-harness-v0.2/carry-turn.sh --checkout /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2 --task cross-transport-concurrency-correction` with the four `--allow-path` values. Corroborated from the carrier's own untracked run log `logs/harness-runs/20260815T153845-27235-cross-transport-concurrency-correction.log`, whose final lines record `cmd: claude -p '/work-loop-v2 cross-transport-concurrency-correction' --output-format json --permission-mode default --disallowedTools Bash(claude:*) Bash(claude *) Bash(codex:*) Bash(codex *)`. No environment variable was trusted for this; the pid chain and the launcher argv are the evidence, and a planted fixture cannot produce a live parent process.
- Claim (2) — both leases exist in the shared Git-common lease root and both record `program=carry`: HOLDS. `git rev-parse --git-common-dir` returns `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git`; `WL_LEASE_DIRNAME` is `work-loop-dispatch-locks` (`logs/scripts/work-loop-lease.sh:114`). Read every metadata file in both lease directories: `.../work-loop-dispatch-locks/task-49232871fc66fd85.lock` and `.../checkout-0d1f538516e4119f.lock` each carry `program=carry`, `pid=27235`, `task=cross-transport-concurrency-correction`, `checkout=/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2`. Both directories are stamped 15:38, matching the carrier's start second, and their recorded pid is the same live launcher from claim (1) — the two facts together are what distinguish these from planted fixtures.
- Claim (3) — the governing plan's case 23 exists at the approved content commit: HOLDS. `git show f2b19b5d80a061111c39cc7444f90f6374f19d38:plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md` contains `### Case 23 — genuine cross-transport contention` at line 210, enumerating exactly the seven steps used below.
- Claim (4) — the dispatcher accepts a sentinel actor binary and never validates it before refusing: HOLDS. Searched `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` for `CLAUDE_BIN`/`CODEX_BIN` above the acquisition line; the only occurrences before it are the defaults at lines 301–302 and the flag assignments at lines 428–429. No existence, executability or version check runs before refusal.
- Claim (5) — refusal precedes both actor launch and any in-checkout write: HOLDS. In the same file `acquire_lock` is called at line 1415, under the comment `EVERY WRITE THIS RUN MAKES INTO THE CHECKOUT IS BELOW THIS LINE`, while `mkdir -p "$LOG_DIR"` is at line 1595 and the ownership admission block that could otherwise mask the code is at line 2579 — both after it. `refuse_17` (line 843) exits without reaching `launch_actor`.
- Mode check: `## Lane and unit` records Discovery mode, and the completion condition asks for one live observation, its evidence recorded here, and a hand-back — evidence about a named unknown, changing nothing beyond this state file. Mode and completion condition agree.

Result: live case 23 passed as one continuous observation. While the carrier above held both leases, a real `dispatch.sh` was started against the same task and the same checkout and lost admission at every one of the plan's seven steps, launching nothing and writing nothing into the checkout.

Evidence — the seven plan steps, in the one run:

1. Carrier holding both leases: claims (1) and (2) above, established before the dispatcher started.
2. Real dispatcher started against the conflicting task and checkout: `/bin/bash <checkout>/plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh --checkout <checkout> --task cross-transport-concurrency-correction --claude-bin <sentinel> --codex-bin <sentinel> --log-dir <checkout>/logs/harness-runs/unit8-case23-loser-logdir-MUST-NOT-EXIST`, run from `/tmp` at 15:41. Both actor binaries pointed at a sentinel shell script that invokes no model and only appends a line to a marker file.
3. Exit 17 before actor launch: the run exited `17`, and the sentinel marker file does not exist. That check is proven capable of firing — executing the same sentinel directly with a different marker path wrote `SENTINEL ACTOR RAN pid=31461 args=--pretend-hop-args`, so marker-absence is a result the run could have failed.
4. Wording names an attended carry, not a dispatcher: stderr line 1 is `STOP [17] an attended carry holds task cross-transport-concurrency-correction (.../task-49232871fc66fd85.lock)`, followed by `  it is running in checkout: .../ai-resources-concurrency-fix-2`. `holder_label()` (dispatch.sh:739) maps `program=carry` to `an attended carry`, so the wording is driven by the losing run's read of the real lease, not by a fixed string.
5. Durable refusal record under the Git common directory, `actor_launched=no`: created at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/work-loop-dispatch-locks/refusals/20260815T154142-30771-cross-transport-concurrency-correction.refusal`, the first entry in a `refusals/` directory that did not exist before the run. Its machine-readable line reads `terminal-record outcome=refused code=17 task=cross-transport-concurrency-correction resource=task refusal=held holder_program=carry holder_pid=27235 holder_task=cross-transport-concurrency-correction holder_checkout=/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2 actor_launched=no` — task, terminal result, holder attribution and non-launch, all naming the real carrier. It sits under the shared Git common directory, is readable from every linked worktree, and is not working-tree content: `git status --porcelain -uall` in the main checkout shows no `work-loop-dispatch-locks` or `refusal` path.
6. Nothing written into the checkout: the requested `--log-dir` was not created (`.../logs/harness-runs/unit8-case23-loser-logdir-MUST-NOT-EXIST` absent after the run), and stderr states it. A before/after measurement of the whole checkout excluding `.git` — 2193 paths and 1919 files captured by name, size and mtime, plus `git status --porcelain -uall` — is byte-identical across the run (`diff` reports no difference on all three). The measurement was taken with the operator-owned `logs/friction-log.md` modification and the pre-existing `logs/harness-runs/` contents already in the before-state, and before this actor's own state-file write, so none of the three can mask a dispatcher write.
7. Carrier undisturbed: after the refusal, both lease directories still carry `program=carry pid=27235` for this task and checkout, still stamped 15:38 — the loser neither rewrote nor touched them. No `survivors` or pin artifact was left anywhere under the lease root. Carrier pid 27235 is still live, and this actor is still its child (`ps -o pid=,ppid= -p 27589` returns `27589 27235`).

Post-hop evidence for Codex to verify carrier completion and normal release: the carrier releases through `release_lock()` → `wl_lease_release` (`scripts/axcion-harness-v0.2/carry-turn.sh:853`, wired to the `EXIT` trap at line 317 and to the completion paths at 1536, 1637 and 1650). After this actor exits, normal release is confirmed by both lease directories being gone from `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/work-loop-dispatch-locks/` while the `refusals/` entry above remains, and by the tail of `logs/harness-runs/20260815T153845-27235-cross-transport-concurrency-correction.log`.

Deviations: none. No plan step was substituted, reordered or assembled from separate observations.

Accepted implementation commits: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`), Unit 5 (`81644987`, correction `d22978ad`), Unit 6 (`a3096a21`), verification record (`faccb92b`). Unit 7's clean gates stand as recorded there: syntax rc 0; shared lease `127/0`; owner helper `92/0`; attended carrier `423/0`; dispatcher `632/0`; `git diff --check` rc 0.

Items held for task closure and final review: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block remains until no checkout can carry that format; a host unable to execute `ps -g` pins rather than releases on shutdown; an unwritable shared lease root leaves refusal evidence terminal-only; refusal records have no pruning machinery — this run created the first live one, so the directory is now non-empty and unpruned; the unassigned `LOCK_KEY` remains excluded; carrier fallback wording retains contextual `another`; dispatcher `STALE LOCK` wording still says a dispatcher died; `wl_lease_init` depends on callers canonicalizing checkout paths, although both shipped callers do; Unit 6 observed one load-sensitive carrier-suite timeout run followed by clean Unit 6 and Unit 7 runs.

Limitations of this live case, stated rather than smoothed over:

- The refusal that fired was the **task**-resource path (`resource=task`). Because `acquire_lock` tests the task lease before the checkout lease, a single dispatcher contending on both can only surface one of them, and the checkout-resource wording (`is already running in this checkout`, plus the two-runs-one-working-tree lines) was therefore not exercised by this live run. It remains covered by the Unit 6 controller matrix. Producing it live would need a second task id bound to this same checkout, which is outside this unit's authorized scope.
- The before/after capture, the dispatcher's stdout and stderr, and the sentinel live under `/tmp/wl2-case23-29580/`, which is non-durable. The durable artifacts of this case are the refusal record under the Git common lease root and this state file; the conclusions above are written here rather than left in `/tmp` for that reason.
- Nothing was written into `logs/harness-runs/` for this observation. The brief authorized this state file only, and keeping the dispatcher observation out of the checkout is also what let step 6's measurement stay clean.

Candidate deferral noticed during this unit, not implemented: `refusals/` now holds its first real entry and has no pruning machinery, so the shared lease root will accumulate one file per refusal indefinitely. This is already on the held-items list as a design limitation; what is new is that it is no longer hypothetical. Not done now because it is outside this unit's scope and would change the dispatcher.

## Blocker

None.

## Next action

Codex: assess Unit 8. Live case 23 is complete — all seven plan steps in one genuine carrier-versus-dispatcher run, no actor launched, checkout provably unchanged. Decide whether the plan's remaining done conditions are met and, if the correction plan's case 24 is not required for Phase 1 closure or is satisfied by the existing fan-out evidence, whether the task closes. Two judgments are needed either way: whether the task-resource-only refusal path is sufficient live evidence for case 23 given the Unit 6 controller matrix covers the checkout-resource wording, and whether the recorded held items and the new `refusals/` accumulation deferral are accepted limitations or fresh work.
