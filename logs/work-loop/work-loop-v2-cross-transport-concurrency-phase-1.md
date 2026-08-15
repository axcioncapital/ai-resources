---
task: work-loop-v2-cross-transport-concurrency-phase-1
turn: operator
---

## Outcome

Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal is implemented and corrected in this worktree (`session/2026-08-14-concurrency-fix-2`), at pilot quality, and is ready for one final independent Standards and Spec review and an operator merge decision.

**The correction plan's Done definition is not fully met, and this record does not claim it is.** Live case 24 — a genuine fan-out-two pair — was not executed. Everything else the plan requires is complete. See *Decisions that matter* for the operator decision behind that gap and *Accepted limitations* for the residual risk it leaves.

What is in place:

- **One shared repository-rooted live-lease contract**, in `logs/scripts/work-loop-lease.sh`, used by both transports. The attended carrier (`scripts/axcion-harness-v0.2/carry-turn.sh`) and the unattended dispatcher (`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`) acquire and release the same task-and-checkout lease pair, rooted in the repository's Git common directory, so a run of either program is visible to the other from every linked worktree.
- **Fail-closed repository-depth ownership admission in both transports, before either launches an actor.** A hop that cannot establish ownership refuses rather than proceeding.
- **A durable record on early refusal.** A pre-actor exit-17 lease refusal writes both a human-readable refusal naming the attended holder and a machine-readable terminal record carrying `actor_launched=no`, under the Git common lease root rather than inside any checkout. Before the fix that refusal happened earlier than the dispatcher's log destination existed and left no artifact; it now also cannot be swept into a commit, because it is outside every working tree.
- **No runtime record created inside a checkout before lease acquisition**, on either transport. Verified from source ordering and from executed assertions.
- **Every pin result reported as itself** by both carrier and dispatcher, with `--status` naming the lease's recorded holder, and a pin in the shared helper that is durable-or-explicit rather than silently best-effort.
- **The governing proposal's controller acceptance matrix**, with proposal cases 3, 4, 12, 16 and 22 each carrying named, falsifiable assertions and positive controls.
- **The required Work Loop instruction updates only** — `.agents/skills/work-loop-v2/SKILL.md`, 4 insertions and 2 deletions. No change to the executable core, and no Phase 2 file touched.

Both transports' intentional boundaries are preserved — they share invariants and result vocabulary without being merged into one command surface — and no work was performed in the main checkout.

**The dispatcher was used as a Work Loop courier during this task.** In the genuine case-23 contention, the unattended dispatcher was launched against this same task and checkout while the attended carrier held the leases; that is precisely what made the proof genuine rather than simulated. It never carried a turn — it refused at exit 17 before launching an actor, which was the behaviour under test. Every hop that completed for this task was carried by the attended carrier.

## Decisions that matter

**Case 23 (genuine cross-transport contention) is proven end-to-end in one continuous post-fix observation.** This supersedes the earlier composite acceptance recorded here before the correction. On 2026-08-15 a real attended carrier held both leases while a real `dispatch.sh` was started against the same task and the same checkout, and all seven of the plan's case-23 steps passed in that single run: the carrier held both leases; the dispatcher lost admission at exit 17 before actor launch; its refusal named the attended carrier rather than a dispatcher; a durable refusal record was written under the Git common lease root carrying `actor_launched=no`; the losing run created nothing inside the checkout; and the carrier's leases and work were undisturbed and released normally at completion. The evidence is falsifiable and was made falsifiable — the sentinel actor binary was proven capable of writing its marker, so its absence is a result the run could have failed on.

**The operator decided on 2026-08-15 to skip live case 24 rather than orchestrate it.** Case 24 needs two real Work Loop tasks in two linked worktrees with two top-level transports. A supported, contract-compliant route for it was worked out and is recorded in `logs/work-loop/cross-transport-concurrency-correction.md`: a dedicated witness task in a dedicated witness worktree driven by the dispatcher in unattended loop mode, alongside the attended carrier on this task, with the concurrency read live from four simultaneous lease directories. The route was not rejected as unsafe or unsupported — the operator judged that the second-worktree setup costs more operator time than is available now. **This supersedes the correction plan's case-24 requirement for this task only.** No attempt was made to reconstruct, simulate or approximate the case, and nothing in this record treats controller evidence as a substitute for it.

**Enforcement is exit-code-borne on both transports; interactive same-task enforcement is not.** The attended carrier and the unattended dispatcher each take the shared lease and check repository-depth ownership before launching an actor, and refuse with an exit code rather than launching — the carrier's enforcement is exit-code-borne after this correction, where before it was not. What remains instruction-borne is the interactive case: two interactive sessions opened on one checkout for the same task, and an operator who proceeds past a refusal, are prevented by nothing (`logs/scripts/work-loop-owner.sh` 36–39, repeated in `.agents/skills/work-loop-v2/SKILL.md` 199).

**Deferrals carried out of this closure, each with why it stays outside Phase 1:**

- **`LOCK_KEY` is unassigned in `dispatch.sh`.** Pre-existing, not introduced by this repair, and not on the Phase 1 surface. Fixing it would be an unrelated edit inside a task whose scope excluded repairs.
- **`wl_lease_init` hashes the checkout string it is handed** rather than a resolved path, so correctness depends on every caller canonicalizing first. Both shipped callers do, so no current behaviour is wrong. Not fixed because it is a production change in the shared library, noticed inside a unit that authorized no production file.
- **Refusal records have no pruning machinery.** Case 23 created the first live entry, so the shared lease root will now accumulate one file per refusal indefinitely. No longer hypothetical, but a dispatcher change and outside Phase 1.
- **`dispatch.sh` and its README document `--carry-one` without noting the skill forbids using it to carry an attended hop.** The program's own documentation is complete and the constraint lives only in `.agents/skills/work-loop-v2/SKILL.md` (223, 225, 262). A route proposal walked into that gap during this task and was corrected. Fixing the documentation means editing the dispatcher header and README, which no unit here authorized.
- **Phase 2 task-aware automatic worktrees, and any change to D4.** Explicitly excluded by scope. Phase 2 is the next proposal stage and depends on an operator integration decision on Phase 1 first.
- **The interactive same-task limitation (proposal §3 F5).** It stays open deliberately: closing it would mean enforcing instructions on a live model session, a different and larger problem than the one Phase 1 set out to solve. The mitigating structure is that Claude makes every commit (core §4), so every unit crosses one repository-depth ownership check before anything is committed.

**A false premise was handed back once and honoured.** A unit found that ordinary helper packaging could not preserve the over-refusal control in the carrier's section 12b, and handed back rather than building around it; the admission was then implemented properly.

## Evidence

**Branch:** `session/2026-08-14-concurrency-fix-2`. **Merge-base with `main`:** `212fa918`. **Head at closure:** `1c65deca`, plus this closing commit.

**Full span against the merge-base:** `10d2eeb6` (the proposal batch) through `1c65deca`. **15 files changed, 6358 insertions, 259 deletions.** The measured per-file shape of the implementation:

| File | Insertions / deletions |
|---|---|
| `logs/scripts/work-loop-lease.sh` (new) | 606 / 0 |
| `logs/scripts/work-loop-lease.test.sh` (new) | 1079 / 0 |
| `logs/scripts/work-loop-owner.test.sh` | 6 / 0 |
| `scripts/axcion-harness-v0.2/carry-turn.sh` | 435 / 54 |
| `scripts/axcion-harness-v0.2/carry-turn.test.sh` | 774 / 15 |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` | 366 / 100 |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` | 1456 / 8 |
| `.agents/skills/work-loop-v2/SKILL.md` | 4 / 2 |

**Accepted correction commits, in order:** unit 1 `fee4fe49`, `ca35371c`, `57f3b25b`; unit 2 `2d58991d` with record update `bc979e8d`; unit 3 `cda44c50`; unit 4 `8e4261f0`; unit 5 `81644987` with correction `d22978ad`; unit 6 `a3096a21`; verification record `faccb92b`; live case 23 record `8f43438c`; case-24 route and its one correction round `11cb60ba`, `1c65deca`.

**Verification gates, measured from the committed implementation state at `c29cac8a` on 2026-08-15.** These replace every earlier total; the superseded figures are not preserved for narrative continuity.

| Gate | Result |
|---|---|
| `bash -n` over `work-loop-lease.sh`, `carry-turn.sh`, `dispatch.sh` | exit 0 |
| Shared lease helper (`work-loop-lease.test.sh`) | exit 0 — 127 / 0 |
| Ownership helper (`work-loop-owner.test.sh`) | exit 0 — 92 / 0 |
| Attended carrier (`carry-turn.test.sh`) | exit 0 — 423 / 0 |
| Unattended dispatcher (`dispatch.test.sh`) | exit 0 — 632 / 0 |
| `git diff --check` | exit 0 |

The host performed the required process inspection rather than reporting sandbox artefacts: `ps`, `pgrep`, `lsof` and `kill -0` were each probed against a live background PID before the suites ran. The same run confirmed no Phase 2 or executable-core file changed in the correction range, and that no other checkout was modified by this correction.

**Live case-23 evidence, durable.** The refusal record written by the losing dispatcher survives under the Git common lease root at `<git-common-dir>/work-loop-dispatch-locks/refusals/20260815T154142-30771-cross-transport-concurrency-correction.refusal`. Its two lines are the durable conclusion:

```
STOP [17] an attended carry holds task cross-transport-concurrency-correction (.../task-49232871fc66fd85.lock)
  it is running in checkout: .../ai-resources-concurrency-fix-2
terminal-record outcome=refused code=17 task=cross-transport-concurrency-correction resource=task
  refusal=held holder_program=carry holder_pid=27235 holder_task=cross-transport-concurrency-correction
  holder_checkout=.../ai-resources-concurrency-fix-2 actor_launched=no
```

It names the real attended holder by program and pid, records the terminal result, and states that no actor launched. It sits outside every working tree, so it is invisible to `git status` and cannot be swept into a commit. The full seven-step observation that produced it is recorded in `logs/work-loop/cross-transport-concurrency-correction.md` at commit `8f43438c`.

**Non-durable evidence, named as such.** `logs/harness-runs/` in this worktree is untracked and not gitignored — local working evidence that will not survive a clean checkout. The carrier run log for case 23 (`20260815T153845-27235-cross-transport-concurrency-correction.log`) and the earlier gate outputs live there. The case-23 before/after checkout fingerprints and the losing dispatcher's stdout and stderr were captured under `/tmp` and are gone. **Every conclusion those artifacts support is written into this record and into the task state file rather than left pointing at them** — that is why the refusal record's content is quoted above rather than cited by path alone.

**Rollback path:** nothing from this task has been merged to `main` or pushed. Rollback is to decline the merge and discard the branch; the repository returns to `212fa918` with no revert needed. If a partial rollback is ever wanted after a merge, the implementation is separable at file level — `logs/scripts/work-loop-lease.sh` and its test are new files, and the transport changes are confined to `carry-turn.sh` and `dispatch.sh`.

## Accepted limitations

1. **Live case 24 was not executed, so the plan's Done definition is not fully met.** Controller case 12 covers two different tasks in two linked worktrees, and it passes — but there is no post-fix live proof of two real concurrent Work Loop tasks each completing a later handoff in its own isolated linked worktree. The residual risk is that fan-out-two behaviour is proven at controller level and by one pre-correction sandbox run, not by the corrected code in live operation. The operator accepted this on 2026-08-15 on time grounds, with a supported route already worked out and recorded. The next real pair of concurrent Work Loop tasks is the natural producer of this evidence; it does not need to be manufactured.
2. **Mutually uninspectable live reclaimers both fail closed.** Two reclaimers that cannot inspect each other will both refuse rather than one proceeding.
3. **`wl_lease_status` describes a provably dead holder as `HELD`.** The status surface does not distinguish a dead holder from a live one; only the three-state lock verdict does.
4. **The old-marker transition block remains** until no checkout can still carry that format.
5. **A host unable to execute `ps -g` pins rather than releases on shutdown.** The safe direction, but it leaves a pin behind.
6. **An unwritable shared lease root leaves refusal evidence terminal-only.** The refusal still fires and is still correct; only its durable record is lost, with a warning on stderr.
7. **Refusal records have no pruning machinery**, and case 23 created the first live entry, so the directory now grows without bound.
8. **`LOCK_KEY` remains unassigned in `dispatch.sh`**, excluded from this scope.
9. **The carrier's fallback labels retain contextual `another` wording** while both recognized holder classes agree.
10. **The dispatcher's `STALE LOCK` sentence still says a dispatcher died**, outside the explicit `LIVE`/`UNKNOWN` scope that was corrected.
11. **`wl_lease_init` depends on callers canonicalizing checkout paths.** Both shipped callers do; a future one that does not would take a second, invisible checkout lease and contend with nobody.
12. **The interactive same-task limitation stays open by design** (proposal §3 F5). Nothing prevents two interactive sessions on one checkout for the same task, or an operator proceeding past a refusal.
13. **One load-sensitive carrier-suite timeout was observed** — five section-16 assertions failed with actor timeout during a run with other work on the machine, and later clean runs returned 423 / 0 over the same assertions. Recorded as a timing flake rather than a product failure; no retry or timeout was changed to conceal it.
14. **Live evidence in `logs/harness-runs/` is untracked** and will not survive a clean checkout.
