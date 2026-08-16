---
task: work-loop-v2-cross-transport-concurrency-phase-1
status: closed
turn: operator
---

## Outcome

Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal is implemented, corrected and independently reviewed in this worktree (`session/2026-08-14-concurrency-fix-2`), at pilot quality. **The Spec axis recommends merge**, after one high-severity finding it raised was repaired and independently re-confirmed. **The Standards axis did not pass cleanly**: it returned three non-safety findings, none of which was implemented, under the operator's 2026-08-15 direction to fix only what is truly necessary. All three are recorded in *Accepted limitations* with the reason each stays. The remaining step is the operator's merge decision.

**The correction plan's Done definition is not fully met, and this record does not claim it is.** Live case 24 — a genuine fan-out-two pair — was not executed. Everything else the plan requires is complete. See *Decisions that matter* for the operator decision behind that gap and *Accepted limitations* for the residual risk it leaves.

What is in place:

- **One shared repository-rooted live-lease contract**, in `logs/scripts/work-loop-lease.sh`, used by both transports. The attended carrier (`scripts/axcion-harness-v0.2/carry-turn.sh`) and the unattended dispatcher (`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`) acquire and release the same task-and-checkout lease pair, rooted in the repository's Git common directory, so a run of either program is visible to the other from every linked worktree.
- **Stale-lease recovery that produces exactly one winner, including under a late-arriving lower-PID reclaimer.** The rename, recreate and holder write of a reclaim run inside an exclusive claim on the lease, so a reclaimer's verdict cannot be invalidated between its last check and its rename. This is the Unit 11 repair described below; without it, two runs could each believe they owned the same task or checkout.
- **Fail-closed repository-depth ownership admission in both transports, before either launches an actor.** A hop that cannot establish ownership refuses rather than proceeding.
- **A durable record on early refusal.** A pre-actor exit-17 lease refusal writes both a human-readable refusal naming the attended holder and a machine-readable terminal record carrying `actor_launched=no`, under the Git common lease root rather than inside any checkout. Before the fix that refusal happened earlier than the dispatcher's log destination existed and left no artifact; it now also cannot be swept into a commit, because it is outside every working tree.
- **No runtime record created inside a checkout before lease acquisition**, on either transport. Verified from source ordering and from executed assertions.
- **Every pin result reported as itself** by both carrier and dispatcher, with `--status` naming the lease's recorded holder, and a pin in the shared helper that is durable-or-explicit rather than silently best-effort.
- **The governing proposal's controller acceptance matrix**, with proposal cases 3, 4, 12, 16 and 22 each carrying named, falsifiable assertions and positive controls.
- **The required Work Loop instruction updates only** — `.agents/skills/work-loop-v2/SKILL.md`, 4 insertions and 2 deletions. No change to the executable core, and no Phase 2 file touched.

Both transports' intentional boundaries are preserved — they share invariants and result vocabulary without being merged into one command surface — and no work was performed in the main checkout.

**The dispatcher was used as a Work Loop courier during this task.** In the genuine case-23 contention, the unattended dispatcher was launched against this same task and checkout while the attended carrier held the leases; that is precisely what made the proof genuine rather than simulated. It never carried a turn — it refused at exit 17 before launching an actor, which was the behaviour under test. Every hop that completed for this task was carried by the attended carrier.

## Decisions that matter

**The final independent Spec review blocked merge, and the defect it found was real.** On 2026-08-15 the review reproduced a high-severity violation of correction finding 5 against the then-current helper: stale-lease arbitration returned success to two reclaimers. The witness set that arbitrated reclaims is read by scanning it, and a scan cannot see a witness published after it runs — so a lower-PID reclaimer arriving after a higher-PID scan was authorised too, both re-read the same dead holder, and the second renamed the first one's freshly created live lease away and recorded itself. The review's reproduction used shell wrappers to pause the real helper's own `mkdir` and `mv` at that interleaving; it changed no repository file.

**Unit 11 repaired it with an exclusive reclaim claim rather than more re-checking.** No check-then-act sequence can close that race — every one leaves a window between the last check and the `mv`. So the destructive part of a reclaim (rename, recreate, write the holder) now runs while the reclaimer holds an exclusive claim directory on that lease, taken with the same atomic `mkdir` the lease itself uses, and all three pre-rename re-checks moved inside it. The claim reuses the existing `<lease>.reclaiming` directory rather than adding a second marker, so the dead-owner recovery already in the acquisition loop covers it: a claim is cleared only on positive absence, and clearing grants nothing because the following `mkdir` still picks the single winner. That is what stops an exclusive claim stranding the lease one level up — the failure the witness set was originally shaped to avoid. Fail-closed behaviour for `LIVE`, `UNKNOWN`, corrupt pids and pinned leases is unchanged, and no public function, return code or `WL_LEASE_*` variable changed, so neither transport was touched.

**The repair carries a deterministic regression, not a probabilistic one.** Case 22 of the shared-lease harness forces the exact schedule instead of racing and counting: two processes source the shipped library unmodified, shadow `mkdir` and `mv` with shell functions, rendezvous through files, and take their low/high roles from their two real pids. Against the pre-repair helper it fails with two winners on every run; against the repaired one it yields one winner, a loser refused with `CONTENDED`, and the winner's lease intact. Case 17 — the pre-existing barrier race — stays, and stays green, but it is no longer treated as proof of this interleaving.

**The narrow independent re-review of Unit 11 passed and recommends merge.** It confirmed the exclusive claim survives rename and recreate, that case 22 discriminates (`132 / 4` against the parent helper, with only its four new assertions failing, and `136 / 0` on the repaired one), that the loser returns 2 / `CONTENDED`, and that the public helper contract is unchanged.

**The Standards axis returned three findings and none was implemented.** Under the operator's 2026-08-15 direction to fix only what is truly needed, Codex judged all three non-blocking: the historical commit-subject prefix violations would need 21 commits rewritten, which is disproportionate and conflicts with this task's explicit no-history-rewrite boundary; the duplicated ownership-admission block in the transport glue is a judgement-call smell whose behaviour is correct and covered, and extracting it is a separate refactor; and `r17`'s naming is low-severity cleanup. They are recorded honestly as limitations rather than closed, so a merge decision is made knowing the Standards axis did not pass cleanly.

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

**Branch:** `session/2026-08-14-concurrency-fix-2`. **Merge-base with `main`:** `212fa918`. **Head at closure:** `f3b4e1b1` (Unit 11), plus this closing commit.

**Full span against the merge-base:** `10d2eeb6` (the proposal batch) through `f3b4e1b1`. **15 files changed, 6562 insertions, 259 deletions**, measured at `f3b4e1b1`. This supersedes the `6358` figure recorded before Unit 11, which was scoped through the pre-closing commit `1c65deca`. The measured per-file shape of the implementation:

| File | Insertions / deletions |
|---|---|
| `logs/scripts/work-loop-lease.sh` (new) | 665 / 0 |
| `logs/scripts/work-loop-lease.test.sh` (new) | 1252 / 0 |
| `logs/scripts/work-loop-owner.test.sh` | 6 / 0 |
| `scripts/axcion-harness-v0.2/carry-turn.sh` | 435 / 54 |
| `scripts/axcion-harness-v0.2/carry-turn.test.sh` | 774 / 15 |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` | 366 / 100 |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` | 1456 / 8 |
| `.agents/skills/work-loop-v2/SKILL.md` | 4 / 2 |

**Accepted correction commits, in order:** unit 1 `fee4fe49`, `ca35371c`, `57f3b25b`; unit 2 `2d58991d` with record update `bc979e8d`; unit 3 `cda44c50`; unit 4 `8e4261f0`; unit 5 `81644987` with correction `d22978ad`; unit 6 `a3096a21`; verification record `faccb92b`; live case 23 record `8f43438c`; case-24 route and its one correction round `11cb60ba`, `1c65deca`; **unit 11, the stale-reclaim repair, `f3b4e1b1`**.

**Verification gates, measured at `f3b4e1b1` on 2026-08-15.** These replace every earlier total; the superseded figures are not preserved for narrative continuity.

| Gate | Result |
|---|---|
| `bash -n` over `work-loop-lease.sh`, `carry-turn.sh`, `dispatch.sh` | exit 0 |
| Shared lease helper (`work-loop-lease.test.sh`) | exit 0 — 136 / 0, four consecutive runs |
| The same suite against the pre-Unit-11 helper (`WL_LEASE_LIB=`) | exit 1 — 132 / 4, the four failures all case 22 |
| Attended carrier (`carry-turn.test.sh`) | exit 0 — 423 / 0 |
| Unattended dispatcher (`dispatch.test.sh`) | exit 0 — 632 / 0 |
| Ownership helper (`work-loop-owner.test.sh`) | not re-run at Unit 11 — last measured 92 / 0 at `c29cac8a`; Unit 11 changed no ownership file |
| `git diff --check`, working tree | exit 0 |

The pre-Unit-11 row is the falsifying half and is stated as a gate rather than as prose: the case that protects the repair fails against the code the repair replaced, and every other case in the suite passes against it, so case 22 is the only thing separating the two helpers.

`git diff --check` over the full range `212fa918..HEAD` reports trailing whitespace in two plan and report Markdown files. Those are intentional hard line breaks, which the correction plan expressly allows; no source file is affected. The working-tree check, which is the gate above, is clean.

The host performed the required process inspection rather than reporting sandbox artefacts: `ps`, `pgrep`, `lsof` and `kill -0` were each probed against a live background PID before the suites ran. The same run confirmed no Phase 2 or executable-core file changed in the correction range, and that no other checkout was modified by this correction. Unit 11 changed only `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh` and its task state file, and neither transport source file was touched.

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
4. **The `<lease>.reclaiming` directory now has two possible authors.** Unit 11 made it the current build's exclusive reclaim claim; it is also the format an earlier build of the helper left behind. One code path reads both, so an upgraded checkout needs no separate handling, but a reader cannot tell the two apart, and a stranded one from either author is cleared only when its recorded pid is provably absent.
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
15. **A run arriving during another run's reclaim now refuses immediately as `CONTENDED`**, rather than waiting for that reclaim to finish and then refusing as `held` against the new holder. Both are correct refusals and neither admits a second run, but the wording an operator sees for the same underlying situation depends on timing.
16. **Standards finding, not fixed: historical commit-subject prefixes.** Twenty-one commits on this branch carry subjects that do not follow the repository's prefix convention. Fixing them means rewriting history, which this task's scope explicitly excludes and which the operator judged disproportionate.
17. **Standards finding, not fixed: duplicated ownership-admission glue.** The ownership-admission block is duplicated across the two transports. Its behaviour is correct and covered by both suites; extracting it is a separate refactor, not part of a safety correction.
18. **Standards finding, not fixed: `r17` is a mysterious name.** Low-severity naming cleanup, left for a future pass.
19. **A stale comment in the shared-lease harness.** Case 19's comment still describes the `<lease>.reclaiming` marker as a format the correction moved away from, which Unit 11 made only half true. The case's assertions are correct and unaffected; the wording was left rather than widening the safety commit.
