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

Standard. Implementation mode. Unit 3a1 recovery — finish and validate only the preserved pin-on-unproven-shutdown carrier correction (executed; awaiting assessment).

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

The carrier's shared-lease integration is committed at `04de80a7`, but its shutdown path still violated proposal § 4.1 property 4 by releasing both leases when the actor tree could not be proven stopped. The first correction carry stopped at the 900-second boundary with exit `21`; it made no commit or state transition but left attributable edits in `scripts/axcion-harness-v0.2/carry-turn.sh` and `scripts/axcion-harness-v0.2/carry-turn.test.sh`. The operator approved this smaller recovery on 2026-08-14. Preserve and assess those edits rather than restarting or discarding them.

Governing authority: the approved Phase 1 decision and `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, especially § 4.1 property 4. The recorded pre-correction failure is durable in the preceding Unit 3a1 result: `terminate_actor_group` warned and ordinary cleanup released the leases because the carrier had no pin call site. That is the failing baseline; do not spend this recovery reconstructing a historical red run or fabricating evidence.

Required outcome: finish the preserved correction so an actor shutdown that cannot be proven complete visibly pins every lease this run owns, and ordinary cleanup cannot release those pinned leases. A subsequent carrier on the task or checkout must refuse before launch with exit `17`. A shutdown proven complete must retain ordinary release behavior.

Check before editing:

1. Inspect the two preserved diffs for correctness and unnecessary mechanism. Simplify where an equivalent, easier-to-audit implementation preserves the safety property; do not redesign actor lifecycle handling broadly.
2. Verify `wl_lease_pin`'s actual return contract in `logs/scripts/work-loop-lease.sh`. The carrier may treat the documented no-owned-lease result as non-fatal, but must not silently swallow any distinct infrastructure failure if the helper exposes one. Do not change the helper.
3. Verify the proposed process-group census works on this host and that an unavailable census cannot silently mean a clean shutdown. Keep survivor evidence visible to the operator.

Evidence for this recovery:

- Run `bash -n` on `carry-turn.sh`, `carry-turn.test.sh`, and the unchanged lease helper.
- Run only the smallest isolated carrier slice containing the new pin-on-unproven-shutdown case and its clean-shutdown control. Wait for it to complete and report its exact pass/fail output.
- The slice must prove: clean shutdown releases both leases; visible or unprovable survivor state pins both owned leases; pinned lease evidence names the survivor or unknown census condition; and a second carrier is refused with exit `17` before another actor starts.
- Report the final focused diff, any simplification made, the helper return-contract finding, and the committed paths.
- Commit only `scripts/axcion-harness-v0.2/carry-turn.sh`, narrowly required `scripts/axcion-harness-v0.2/carry-turn.test.sh`, and this state file by explicit pathspec. Hand back at `turn: codex` with the commit hash.

Explicitly excluded from this recovery: broad carrier or dispatcher suites; dispatcher 12e; `--prove-failure` M6; ownership admission; instruction edits; helper changes; controller-wide acceptance; live validations; and every other deferral. These remain later units because this recovery must fit inside one bounded hop.

Stop and hand back without broadening if the preserved approach needs new architecture, a helper change, a new exit code, or cannot be validated by the isolated pin slice. Challenge any false premise rather than improvising.

Completion condition: the preserved carrier correction is reduced to a correct and auditable implementation, syntax and the isolated pin slice pass, both owned leases stay pinned when shutdown is unproven while clean shutdown still releases them, a second launch refuses at exit `17`, only the carrier, its narrow test and this state file are committed, and the state hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14):

- Claim (1) — the carrier's shared-lease integration is committed at `04de80a7`: HOLDS — `git log --oneline -1 04de80a7` returns `batch: work-loop-v2-cross-transport-concurrency-phase-1 — unit 3a1, carrier wired to the shared live lease`.
- Claim (2) — the preserved edits are attributable and unrestarted at 174 insertions / 5 deletions across the two named files: HOLDS — `git diff --stat` over `scripts/axcion-harness-v0.2/carry-turn.sh` and `carry-turn.test.sh` returned exactly `174 insertions(+), 5 deletions(-)` before this recovery edited anything.
- Claim (3) — the preserved diff contains a pin call site, a process-group census and a targeted test section: HOLDS — read the full diff: `pin_leases()` plus its call inside `terminate_actor_group`, `actor_group_census()`, and test section `12d. An unprovable shutdown pins both leases`.
- Claim (4) — `wl_lease_pin` exposes no distinct infrastructure failure the carrier could silently swallow: HOLDS — read `logs/scripts/work-loop-lease.sh` lines 217–241. The only non-zero return is `1`, guarded solely on `[ "$WL_LEASE_TASK_OWNED" -eq 1 ]`, i.e. the documented no-owned-lease case. The pin-file write and the checkout-lease copy are both `2>/dev/null` and cannot change the return, and `WL_LEASE_PINNED=1` is set *before* the write, so a failed write still blocks release. The carrier's `|| return 0` is therefore correct and hides nothing. Helper unchanged.
- Claim (5) — the process-group census works on this host: HOLDS — ran the census body directly: `ps -o pid= -p $$` succeeds (the readability control), and `ps -o pid=,pgid= -g <pgid>` returned three group members, which the `awk` filter reduced to a pid list.
- Claim (6) — an unavailable census cannot silently mean a clean shutdown: HOLDS — the readability control fails first when `ps` is broken, `actor_group_census` returns 1, and `terminate_actor_group` converts that to the `unknown` reason rather than to an empty survivor list. Proven by the `NOPSDIR` case in the slice below.
- Claim (7) — a killed-but-unreaped actor does not appear in the census as a false survivor (checked because the census runs before `wait` reaps the actor): HOLDS — probed on this host: a child in its own process group, SIGKILLed and deliberately not reaped, returned an empty census both before and after `wait`.

Result: the preserved pin-on-unproven-shutdown correction is finished, with one correctness fix and no redesign. Reviewing the preserved diff found one real gap: when the census ran, named nobody, and `kill -0` on the group still succeeded, the code fell through to the pin with **both** `survivors` and `unknown` empty, so the pin file would have carried neither a `descendants still running:` line nor a `sweep incomplete:` line and the operator would have been told to inspect nothing. That branch now sets an explicit unknown reason (`process group <pgid> still answers to signals, but the census named no member of it`), so every pinning path names either the survivor or the unknown condition. Behaviour is otherwise identical: the branch already pinned, it just pinned mutely. Nothing else was simplified — the census and the thin `pin_leases` wrapper each carry weight the other cannot (named pids for the operator, and this surface's exit-17 wording), and no helper, exit code or architecture changed.

Evidence:

- `bash -n` passes on `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh` and the unchanged `logs/scripts/work-loop-lease.sh`.
- The isolated pin slice — test section `12d` plus its clean-shutdown control, extracted with the suite preamble and run from the harness directory so `SUT`/`LEASE_BIN` resolve identically — returns **passed: 18, failed: 0**. It proves all four required properties: a proven-clean shutdown is `21` with nothing pinned and both leases released; an injected visible survivor pins both leases and the run *names the pid*; the pin file records `descendants still running: <pid>`; a broken `ps` is reported as `sweep incomplete` and still pins both leases; and a second carrier on the same task is refused with exit **17**, says `is PINNED`, refuses to advise deleting anything, and launches nothing further.
- The slice can fail. With the single line `pin_leases "$survivors" "$unknown"` replaced by a no-op, the same slice returns **passed: 8, failed: 10** — the second carrier drops from `17` to `22` and *starts a second actor* (`launched nothing further` expected 1, got 2), which is exactly the pre-correction defect. `carry-turn.sh` was restored byte-identical afterwards (`cmp` clean) and the slice re-run green at 18/18 on the committed content.

Limitation, stated rather than papered over: the one branch this recovery added — census ran, named nobody, group still answers — has no automated case. Exercising it needs a `ps` that reports an empty group while `kill -0` on that same group succeeds, and since the actor is SIGKILLed before the census, a hermetic stub that empties `ps` makes `kill -0` fail too and the run correctly returns clean. Rather than invent a check that cannot fail, the branch is covered by inspection only. Its cost is one assignment and it strictly improves evidence.

Deferral noticed and not done: the second call site, `terminate_actor_group "$pid"` at the timeout path, passes the actor's pid as the pgid. That is pre-existing and correct only because the actor is launched into its own process group; it is not this recovery's business and needs no change now, but it is worth a naming pass in a later unit.

Committed by explicit pathspec at `2bef1acf`: `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`, and this state file. Final diffstat over the two harness files: 184 insertions, 5 deletions. Nothing else was staged — `logs/friction-log.md` and the untracked `logs/harness-runs/` were left alone.

## Blocker

None.

## Next action

Codex: assess the Unit 3a1 recovery only. Judge whether the finished pin correction satisfies proposal § 4.1 property 4 — pinned on unproven shutdown, released on proven shutdown, second launch refused at exit `17` — whether the added unknown-reason branch and its stated inspection-only coverage are acceptable, and whether the recorded deferral is rightly held back. Then close this unit or open the next Phase 1 unit from the excluded list (broad carrier and dispatcher suites, dispatcher 12e, `--prove-failure` M6, ownership admission, instruction edits, controller-wide acceptance, live validations).
