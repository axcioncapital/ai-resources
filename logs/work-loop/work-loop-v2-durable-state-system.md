---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 8 — Tracer bullet 6: prove deterministic lifecycle and recovery failures.

Named reason for the loop: this is the next ordered slice of the frozen multi-unit migration and must deliberately prove nine recovery and lifecycle outcomes across several real seams before live concurrency and final cutover proof can begin.

## Brief

Tracer bullet 5 is accepted: the complete five-component deployment capability now fails visibly when incomplete, and its correction proved that the three project-owned files are preserved by the documented merge-only remedies. Tracer bullet 6 is next in the frozen sequence because the new contract must now prove deterministic stop and recovery behaviour under deliberately created failures, not only component tests or design prose.

**Required outcome:** Produce one coherent, fail-capable operational proof of all nine lifecycle/recovery scenarios assigned to Tracer bullet 6 at the real validator, Reorient, owner, command, or courier seams. Each scenario must distinguish the accepted outcome from the corresponding wrong behaviour with a negative control or narrow failpoint.

**Governing authority and constraints:**

- The frozen plan governs: Fixed decisions 1–15, Capabilities C and D, the rollback boundary, Tracer bullet 6, its Proof Matrix assignments, and Execution and Assessment Rules.
- The accepted executable core, validator, owner helper, Reorient, actor-entry command, and courier contracts govern their own semantics. Reuse them and the repository's existing harness/test conventions; add no fallback lifecycle parser, second state store, general-purpose test framework, or speculative recovery machinery.
- Admissions remain paused through operational proof and final landing. Tracer bullet 7's migration/concurrency/live trials and Tracer bullet 8's representative end-to-end demonstration are adjacent work deliberately held outside this unit because the frozen plan assigns them later.
- Live model trials, cross-transport contention, broad fuzzing, performance testing, deployment, merge, push, landing, and production adoption are excluded by the plan or by this unit boundary.
- This is a proof unit. If a scenario exposes an actual runtime defect, preserve and return the red evidence with `turn: codex`; do not silently expand this unit into a runtime repair outside the proof surface.

**Verify first against the repository:**

1. Reconfirm the exact checkout and task, HEAD `4f721055`, `ACTIVE_CLAUDE`, unique repository-depth ownership, and free shared leases. Stop on ambiguity, a competing actor, or a different HEAD.
2. Bound the existing proof inventory to `.claude/commands/work-loop-v2.md`, `.agents/skills/reorient/SKILL.md`, `logs/scripts/work-loop-state.sh` and its test, `logs/scripts/work-loop-owner.sh` and its test, `logs/scripts/work-loop-v2-slice-1.test.sh`, `scripts/axcion-harness-v0.2/carry-turn.sh` and its test, and the dispatcher plus its existing tests under `plans/work-loop-v2-v0.2/handoff-automation-spike/`. For each of the nine scenarios, identify which existing assertion or seam already proves part of it and what composing or failpoint evidence is still missing. Any absence claim must name this searched surface and the pattern used.
3. Verify rather than assume that existing owner tests cover the two closure-interruption states and that carrier/dispatcher tests expose termination and partial effects. Existing component proof may be cited or composed where it reaches the required real seam; do not duplicate it merely to obtain a new count.
4. Check whether the nine scenarios can be demonstrated with temporary Git repositories/worktrees and narrow failpoints without changing runtime behaviour. If not, return the exact unsupported scenario or false premise and stop.

**Proof scenarios required by the frozen plan:**

1. A fresh session with no useful chat reconstructs the same status, turn, latest result, blocker, and next action from the exact task path or validated owner.
2. Compaction/Reorient with an empty or misleading summary cannot override durable state and returns the same validator classification.
3. Unexpected actor termination preserves partial effects and does not blindly relaunch.
4. An interrupted or truncated state update is rejected before launch, while the last committed state plus working diff gives deterministic repair evidence.
5. Operator-blocked recovery retains ownership and refuses a new task.
6. Closure interruption before commit retains ownership.
7. Closure interruption after commit but before owner clear yields `CLOSED` plus a safely clearable stale owner.
8. Task state and Git disagreement stops without automatic rewrite.
9. Clean closure clears ownership and permits checkout reuse.

**Implementation boundary:** Add only the smallest existing-style composing/failpoint proof surface needed to exercise the nine scenarios. Reuse/import accepted component evidence when it proves the required seam, but ensure the combined scenario verdict itself can fail; do not create one fixture framework per scenario or a new general framework. Keep hook-written `logs/friction-log.md` and `logs/innovation-registry.md` uncommitted and outside the commit.

**Required evidence:**

- Give a scenario-by-scenario table or equally exact report: seam exercised, setup/failpoint or negative control, expected wrong behaviour distinguished, observed classification/exit and decisive evidence, and verdict.
- For scenarios 1 and 2, show field-level equality for status, turn, latest result, blocker, and next action, plus validator classification; a prose claim that recovery is correct is insufficient.
- For scenarios 3 and 4, show the preserved partial evidence and prove that no blind relaunch or automatic repair occurred.
- For scenarios 5–9, show the exact owner/state classifications and mutation boundary before and after the injected stop or clean closure.
- Report exact focused-proof assertion counts and exits, plus directly affected regression suite counts and exits. Identify which checks are newly added, reused, or imported by reference.
- Report the implementation commit and exact changed paths. Demonstrate that runtime behaviour, Tracer 7/8 surfaces, excluded machinery, friction log, and innovation registry did not enter the commit, and that the final record validates `ACTIVE_CODEX`.

**Completion condition:** Commit the bounded Tracer 6 proof and return all nine deterministic, fail-capable scenario verdicts in `## Latest result`, with `status: active` and `turn: codex`. State whether any runtime defect was exposed; confirm admissions remain paused, no live model or cross-transport trial ran, nothing was merged, pushed, or landed, and Tracer bullet 7 has not started.

**Stop conditions:** Stop and hand back if a load-bearing premise is false; any scenario lacks a real seam or fail-capable discriminator; producing the proof requires a fallback parser, second state system, general framework, runtime redesign, live model invocation, cross-transport trial, excluded capability, or operator-reserved action; a runtime defect makes the expected outcome red; or the repository/owner/lease preflight is not exact.

Capability subset: baseline only — read and inspect repository state and history, run local tests, edit the existing task-scoped proof/test surfaces needed for Tracer 6, and make the local coherent commit. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

## Latest result

Correction round complete. The one frozen finding is **resolved**, at commit `96ff6786`. Tracer 6 is **74 passed, 0 failed, exit 0** — all nine scenarios green, scenario 6 included. Two suites went red under the correction and both were fixed within it; nothing else broke.

**Reproduced first, before anything changed** — and the finding is **wider than the handback recorded**. In a throwaway `git init` repository: committed record `status: active`, working tree a complete valid closing record, validator `CLOSED`, `.owner` = `t`. `claim --task next` returned `verdict: PROCEED`, exit **0**, and `.owner` became `next` at **both** `--depth local` *and* `--depth repo`. The handback named only local depth. Repo depth reached the identical stale row, because `check_local` decided it and `run_check` never revisited it.

**The correction.** Staleness now needs positive evidence that HEAD carries the exact closing record. `closure_committed()` tests **whole-file equality with HEAD** — not a re-validation of HEAD's blob, so § 4's one-lifecycle-reader rule is untouched: the validator has already classified the working-tree record `CLOSED`, and byte-identity with HEAD makes that the committed record. Three states answer "not committed" and take the same remedy: no commits at all, HEAD not carrying the path, HEAD differing from the working tree (which covers staged-but-uncommitted, since `diff HEAD` spans index and tree). Anything git cannot answer is `unknown` and is never rounded down to committed.

Git is the only reader with that fact, so **the stale row became a repo-depth act.** `check_local` no longer decides it — it hands the row on, and `resolve_stale()` settles it in `run_check`, which keeps `--depth local` literally git-free. Local depth therefore refuses instead of clearing, naming the depth limit and both remedies. Repo depth clears exactly as before when HEAD carries the record, so the accepted post-commit recovery is retained and stays automatic.

No fallback parser, no second state store, no automatic repair, no broad Git policy, no runtime redesign, no Tracer 7 work. `check` and `claim` resolve through the same path, so the two cannot answer one record differently.

**Failing-first, measured against the pre-fix helper.** The new T15 was run against a saved pre-correction copy via `OWNER_BIN=`: **112 passed, 10 failed** — every assertion that names the defect went red, and the negative controls stayed green. Against the corrected helper the same suite is **122 passed, 0 failed, exit 0**.

| Check | Pre-fix | Post-fix |
|---|---|---|
| uncommitted closure, `claim --depth repo` | PROCEED, exit 0, lease released | **REFUSE, exit 3**, declaration and record byte-unchanged, HEAD unchanged |
| uncommitted closure, `claim --depth local` | PROCEED, exit 0, lease released | **REFUSE, exit 3**, declaration intact, and the git trap records **no git call** |
| staged but not committed | PROCEED, exit 0 | **REFUSE, exit 3** |
| closing record never committed | PROCEED, exit 0 | **REFUSE, exit 3** |
| `check` agrees with `claim` | disagreed (0 vs 0 for different reasons) | **both exit 3** |
| **control** — same closure, committed, `--depth repo` | PROCEED, exit 0 | **PROCEED, exit 0**, declaration names the new task |

Tracer 6 scenario 6 now asserts **both depths** plus that committed control, so it cannot be satisfied by a helper that had simply stopped clearing stale declarations — which would break scenarios 5, 7 and 9.

**Two suites broke under the correction, and both were fixed inside it.** Neither is residual.

- `work-loop-state.test.sh` P4.d — the cross-consumer agreement row asserted `CLOSED → rc=0` at `--depth local`, which encoded the defect. P4 now asks at repo depth, and a **new P4L row** keeps the local-depth translation measured, so the depth split is visible rather than dropped. 96/0 → **100/0**.
- `work-loop-capability.test.sh` B5 — the deployed template copy must be byte-identical to canonical. Resynced. 76/1 → **77/0**.

**Deferral, recorded and not done.** `work-loop-owner.sh clear --task {holder}` releases the lease without testing committedness, so the same end state is reachable by running step 3 before step 2. Not corrected here: the frozen finding names the *claim* path, and the two differ in kind — the claim path is a latent trap that fires automatically with no deviation, while `clear` is a documented procedure run deliberately in an order core § 4 and the command file both fix as commit-then-clear. Guarding it would also need git inside a command that has no `--depth` and is reachable git-free, so a closure could become impossible where git is absent. Codex's call whether it is a separate unit, an accepted limitation, or nothing.

Evidence and counts:

- **Tracer 6:** `logs/scripts/work-loop-v2-tracer-6.test.sh` — **74 passed, 0 failed, exit 0**. S1–S9 all PASS. Case 0 falsifiability still discriminates: a stub validator that always prints `ACTIVE_CLAUDE` differs from the real `CLOSED`, so S2/S5/S7/S9 would go red under it.
- **Owner:** `work-loop-owner.test.sh` **122/0, exit 0** (baseline 103/0; +19 from T15 and the two corrected fixtures). Failing-first against the pre-fix helper: 112/10.
- **State:** `work-loop-state.test.sh` **100/0, exit 0** (baseline 96/0; +4 from P4L).
- **Owner-consuming couriers:** dispatcher `dispatch.test.sh` **639/0, exit 0**; carrier `carry-turn.test.sh` **457/0, exit 0**. Both unchanged from their baselines and neither needed an edit.
- **Other directly affected, all exit 0 and all unchanged:** capability **77/0**, slice 1 **308/0**, session preflight **60/0**, core resolver **4/0**, lease **136/0**.
- **New breakage:** none beyond the two suites named above, both fixed in the same commit.
- Deployment: `work-loop-capability.sh check` on this checkout returns `READY`.

Commit `96ff6786` — exact paths: `logs/scripts/work-loop-owner.sh`, `logs/scripts/work-loop-owner.test.sh`, `logs/scripts/work-loop-state.test.sh`, `logs/scripts/work-loop-v2-tracer-6.test.sh`, `workflows/research-workflow/logs/scripts/work-loop-owner.sh`, `.agents/skills/work-loop-v2/SKILL.md`. The skill edit is the instruction half of the same seam: its bullet told Codex to *replace* a `CLOSED` declaration, which the corrected runtime now refuses, so leaving it would put a live instruction in direct contradiction with the code it describes. `logs/scripts/work-loop-state.sh`, `dispatch.sh`, `carry-turn.sh` and `.claude/` are unchanged — `git diff` over them is empty. No Tracer 7 or 8 surface and no excluded machinery entered the commit, and neither `logs/friction-log.md` nor `logs/innovation-registry.md` did; both remain uncommitted. This handback commit adds only this record.

Admissions remain paused. No live model trial and no cross-transport trial ran; nothing was merged, pushed or landed; Tracer bullet 7 has not started. This record validates `ACTIVE_CODEX`.

### Superseded — Unit 8's proof run (kept for the finding's origin only)

Nine scenarios were run at real seams with negative controls; eight passed and scenario 6 was red on the runtime finding corrected above. That proof is commit `096b8985`. Its full scenario table is in that commit's state-file revision.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen finding only — is finding 1 resolved, and did the correction break something?

Resolved is claimed on: the uncommitted complete-and-valid closing record now fails closed at both depths (exit 3, declaration and record byte-unchanged, HEAD unchanged), proved failing-first against the pre-fix helper at 112/10; the committed control still proceeds and clears; Tracer 6 is 74/0 with scenario 6 green and 1–5 and 7–9 unchanged.

Broke something is answered on: two suites went red under the correction — `work-loop-state.test.sh` P4.d and `work-loop-capability.test.sh` B5 — and both were fixed inside the same commit (100/0 and 77/0). Every other directly affected suite is unchanged and exits 0, including the owner-consuming dispatcher (639/0) and carrier (457/0).

Two things for the verdict to dispose of, both stated rather than decided here:

1. The correction makes clearing a stale declaration a **repo-depth act**. `--depth local` now refuses that row instead of clearing it, because committedness needs git and local depth runs none. Post-commit recovery at repo depth is unchanged and automatic. This is a deliberate, measured behaviour change at the Codex-side entry, not a side effect — accept it, or say what should replace it.
2. The recorded deferral: `work-loop-owner.sh clear --task {holder}` still releases the lease without testing committedness. Reasoning is in `## Latest result`. Separate unit, accepted limitation, or nothing.
