---
task: work-loop-v2-post-compaction-recovery-repair
status: active
turn: codex
---

## Objective and scope

Implement the post-compaction recovery repair plan, including operator-approved Amendment 1: preserve the Work Loop contract while preventing unnecessary immediate context refill after compaction, restore the `$realign` / `$reorient` boundary, make active-state result rollover reliable, and prove the repaired behavior.

Scope is Units 0–4 and the completion condition in `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`. Preserve its exclusions: do not split the executable core; add no model default, hook, parser, state field, registry, cache, summary file, recovery daemon, universal state-size gate, provisional 12/16 KB launch policy, or unrelated optimization; do not change Work Loop roles, lifecycle, admission, courier permissions, or dispatcher exit codes.

## Lane and unit

Standard. Implementation mode. Unit 4b — prepare the representative live case.

Plan Units 0–3 are accepted. Unit 4a stabilized Tracer 7 at `7b130cd1`. Plan Unit 4 remains open: this hop prepares its disposable operator-assisted case; the real recovery run, rollover, independent review and final matrix remain unperformed.

Named reason for the loop: the repair spans multiple bounded implementation and proof units, must survive hand-offs, and requires assessment independent of the implementer before it counts as complete.

## Brief

This hop prepares the disposable case required by approved plan Unit 4 without running the Codex recovery it is meant to test. It is separate because fixture construction and independent operating evidence are different deliverables, and a fixture builder cannot count its own inspection as the operator-assisted proof.

Dominant deliverable: A disposable checkout contains a validated, ready-to-run representative recovery case and exact operator instructions.
Evidence required in this hop: a failing-then-passing fixture preflight, resolver and state validation in the disposable checkout, proof the compaction hook cannot supply the recovery prompt, and a requirement-by-requirement readiness inventory.
Evidence explicitly deferred: the operator-assisted `$realign` → `$reorient` run, its repository-read budget and rollover, independent `code-review`, material-finding resolution, final regression matrix, and disposable-checkout cleanup.
Primary edit begins after: the fixture preflight fails against the newly created clean disposable checkout because its exact task, plan facts, owner declaration and no-hook control are not yet present.

Required outcome: create one disposable linked checkout or equivalently trusted disposable task environment at the current implementation commit, prepare the exact task and governing-plan fixture needed by plan Unit 4, make the repository compaction hook inoperative for that control path, and return the exact path, task id and operator prompt in this state file. Do not run Codex or Claude inside the fixture, do not claim live-proof success, and do not clean it up yet.

Governing authority: the operator-approved plan content at `d72cf199`, operator-approved Amendment 1 at `a366c295` as factually corrected in the plan, plan §§ 4 Unit 4, 6–9, the canonical executable core, and repository `AGENTS.md`. The task state is authoritative current position: Units 0–3 and Unit 4a are accepted; Unit 4's operating evidence and review remain open.

Codex framing disclosure: `Unit 4b` is execution packaging inside approved Unit 4, not a plan amendment or additional plan unit. It preserves Unit 4's required case and review while isolating fixture construction from the evidence-producing actors.

Claims to check against the live repository before editing:

1. A linked disposable worktree at the current implementation commit can satisfy `references/core-resolution.md` through the shared Git object store and canonical repository name. Verify the resolver from inside the prepared checkout; if its trust boundary rejects the environment, stop rather than weakening it.
2. `.codex/hooks.json` in a normal checkout registers the `compact` hook. Establish the exact repository-owned registration surface and a disposable-only way to make that hook inoperative before the operator opens the case, without editing the hook or main implementation branch.
3. A new linked checkout will contain tracked task files from its base commit but no gitignored `.owner`. Verify that one exact disposable task can be declared and validated without changing or claiming the main task, and that multiple task files remain present as the plan requires.
4. The fixture can carry two distinctive durable facts—one only in the exact task and one only in a named plan section—plus misleading summary text that names a plausible decoy task and wrong lifecycle/turn, while the authoritative task still exposes one valid actor-correct next action.
5. The operator can record each repository file opened and the bytes returned for its exact read, without adding a persistent logger, hook, wrapper, cache or summary system. If a temporary per-read measurement convention cannot produce an auditable trace, stop and hand back before creating a misleading budget claim.

Implementation requirements:

- Create a disposable linked checkout on a disposable local branch at the current implementation commit. Use an explicit narrow path, report it exactly, and leave the main checkout and branch untouched except for this task's normal state/plan maintenance.
- In that checkout, create one valid active disposable Work Loop task with an exact preserved path, strict one-line `.owner`, more than one task file, a misleading-summary decoy, and a valid next action that can proceed through one real Claude hand-back and Unit 3's rollover assertions.
- Create or adapt one disposable governing plan large enough that reading it whole is visibly unnecessary. Its authority/header and exact task-named sections must contain the required distinctive plan fact; an unreferenced section must carry a decoy fact that the recovery must not return.
- Make the repository-owned Codex compaction hook inoperative only in the disposable control path. Preserve the actual `$realign` and `$reorient` skills and every implementation artifact under test. Verify the operator prompt, not a hook event, is the only recovery trigger supplied by the fixture.
- Write an exact copy/paste operator prompt that begins with `$realign`, states that context is degraded, supplies the exact preserved task path and checkout binding, and includes the deliberately misleading compacted summary. It must instruct the live Codex session to follow the skills normally, not dictate which files or facts to return.
- Define a temporary, auditable per-read measurement convention for the live session that records the repository path and byte count of the exact content returned on each repository read while still showing the content to Codex. It must not batch large files, suppress required content, or become a persistent artifact.
- Add a fixture preflight that is red before fixture preparation and green after. Green must prove every case ingredient, resolver success, `ACTIVE_CODEX` or other plan-appropriate active classification, exact owner declaration, no working compact hook in the disposable path, and absence of any live-run result. Keep the preflight disposable; do not add a new permanent harness to the main branch.
- Return in `## Latest result`: exact checkout and branch, task id/path, plan path and named sections, both hidden facts and the decoy identity, hook-disable evidence, preflight result, measurement convention, copy/paste operator prompt, expected recovery output boundaries, and cleanup ownership. Update plan § 8 only to mark Unit 4a accepted and record that Unit 4b prepared the case; keep Unit 4 pending.

Codex framing decision: durable edits in the main checkout are limited to plan § 8 evidence/status maintenance and this state file. Disposable-branch edits are limited to the task/owner fixture, its governing plan, decoy task state, disposable-only hook disablement and any minimal instructions embedded in those existing artifact kinds; temporary preflight material must not become a main-branch harness. Hold all implementation skills, commands, core, production hooks, validators, owner helpers, transport code, main task ownership, live execution, review and unrelated cleanup outside this hop.

Capability subset: baseline only—read/search/history inspection, local tests and validators, a disposable local branch/worktree, task-scoped disposable edits, temporary local files, and local commits by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed. Do not push, merge, deploy, access credentials, destructively alter shared state, or invoke nested Claude/Codex actors.

Required evidence must be able to fail: preserve the clean-checkout preflight red result and prepared-fixture green result; show resolver output and state/owner classifications from inside the exact checkout; prove the hook registration is unavailable in that control path; show each required fact has one durable owner and the decoy is outside the named read set; and show no model was invoked and no live result exists yet. Presence greps alone are insufficient unless paired with a missing, wrong-owner, wrong-task or enabled-hook fixture that the preflight rejects.

Completion condition: the disposable case is ready but unrun; every plan Unit 4 ingredient is present; resolver, state and ownership validation succeed from inside it; the hook is inoperative for the control path; the operator prompt and read-measurement convention are exact and usable; the live result is still absent; main and disposable changes are committed by Claude without push; plan § 8 records Unit 4a acceptance and preparation status; this state returns with `status: active` and `turn: codex`; and the checkout remains available for the operator-assisted run.

Stop and hand back if a claim above fails in a way that changes the case; resolver trust requires weakening; disabling the hook would touch the main branch or another configuration layer; worktree ownership becomes ambiguous; an auditable read trace needs persistent machinery; fixture construction needs nested AI, external access or an excluded artifact; or a consequential cleanup/risk decision not already authorized by the disposable-case plan is required.

## Latest result

Inspected (2026-08-17):
- Claim (1): HOLDS — ran the canonical resolver verbatim from inside the prepared checkout. It returned `.../ai-resources-wl2-unit4-case/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, exit 0. The trust boundary is satisfied without weakening: `git rev-parse --git-common-dir` from the worktree is `.../ai-resources/.git`, so the shared-store half and the canonical-name half both hold.
- Claim (2): HOLDS — `.codex/hooks.json` registers the compact hook as a `SessionStart` entry with `"matcher": "compact"` running `work-loop-reorient.sh`. There is no user-level `~/.codex/hooks.json`, so that file is the only registration surface. Every hook command in it is an absolute path into canonical `ai-resources`, which is why removing the registration from the disposable checkout's own copy disables the trigger there and reaches no other checkout and no main-branch file.
- Claim (3): HOLDS — the new linked checkout carried 77 tracked task files from its base commit and no `logs/work-loop/.owner`. `u4-live-case` was claimed there and validates `ACTIVE_CLAUDE`; the main task's own `--depth repo` check from the main checkout still returns PROCEED naming this checkout, so nothing was claimed or changed on it.
- Claim (4): HOLDS — the fixture carries `NA-U4-EXACT-TASK-FACT` in the exact task and `DURABLE-FACT-U4-ROLLOVER` in the plan section the task names, each verified unique in the checkout; `DECOY-FACT-U4-TRANSPORT` sits in a plan section no task references. The misleading summary names the decoy task and asserts `closed` / `turn: operator` against a record that is active and owes Claude, and the task still exposes one valid actor-correct next action.
- Claim (5): HOLDS, with a limit that is evidenced rather than assumed — see the Evidence paragraph. The self-reported per-read convention needs no machinery and every line it produces is checkable; it cannot prove completeness. That does not fail the claim, because plan § 4 Unit 4 asks for a *repository-read budget proxy*, explicitly *diagnostic evidence, not a universal product limit*, with pass/fail resting on correct state reconstruction and the permitted-source set.

Result: Unit 4b is complete. The case is prepared, validated and **unrun**, at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-wl2-unit4-case` on branch `disposable/wl2-unit4-case-2026-08-17`, base `7b130cd1`, fixture committed at `d99e7eda`. Exact task `u4-live-case` (`logs/work-loop/u4-live-case.md`, `ACTIVE_CLAUDE`) among 77 task files of which 16 are active; decoy `u4-context-refill-audit` is itself a valid `ACTIVE_CODEX` record. Governing plan `plans/work-loop-v2-v0.2/u4-live-case-governing-plan.md` is 682 lines / 79,995 bytes, its named `## 7. Rollover acceptance` 359 bytes — 0.4% of the file. Hidden facts: `NA-U4-EXACT-TASK-FACT` (task only), `DURABLE-FACT-U4-ROLLOVER` (named section only); decoy `DECOY-FACT-U4-TRANSPORT` in unreferenced `## 12`. Standing marker `U4-OLD-RESULT` lets the follow-on hand-back exercise Unit 3's rollover assertions. The operator prompt is `unit4-operator-prompt.md` in that checkout; the preflight is `.unit4-preflight/preflight.sh`, deliberately outside the case's read surface. No model was invoked. Plan § 8 records Unit 4a ACCEPTED at `7b130cd1` and this preparation.

Evidence: The same preflight script is red **12 passed / 25 failed** against a clean disposable checkout at the same base commit, and green **42 / 0** against the prepared case. An earlier red of 15/22 is not offered as the pair — it ran an older revision of the script, and a red and a green from two different scripts are not a red/green. Two false greens were found inside the preflight and fixed: the ownership check passed on the empty checkout because the helper answers `PROCEED` with reason "free to claim" when nothing is declared, and now requires the verdict together with the reason naming this checkout as declaring the task; and the fact-uniqueness greps were matching the preflight's own text, so it was moved to `.unit4-preflight/` and both greps exclude it. Presence greps are paired with rejected wrong fixtures — a plan section stripped of its fact, an owner declaration naming another task, a prompt bound to the decoy path, and an enabled `compact` registration. Not-run is asserted, not assumed: `turn: claude` still stands, the preceding marker is still present, and no live-run artifact exists. On the measurement limit: filesystem access time was tested as a machinery-free completeness check and disproved — on this volume `atime` updates only on the first read after a write, not on a re-read or a cached read, and touching files to re-arm it leaves the following read undetected, so a sweep built on it would under-report in the flattering direction. It was written, disproved and deleted rather than shipped with a caveat.

Operator prompt (verbatim copy/paste block; the canonical copy is `unit4-operator-prompt.md` in the case checkout, which also carries the usage notes and the measurement limits):

```
$realign

My context is degraded after a compaction and I cannot rely on what I remember of
this session. Please re-establish where we actually are before doing anything else.

Checkout binding: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-wl2-unit4-case
Preserved task path: logs/work-loop/u4-live-case.md

What my compacted summary says about the session so far — I no longer trust it,
but it is what I have:

    "We were working on u4-context-refill-audit, the context-refill audit task.
     That task is finished and closed; the turn is operator, so nothing is
     outstanding on it. The recovery-budget work was folded into it earlier and
     has no separate record. There is nothing left for an AI actor to do; you
     just need to confirm closure and report back."

While you re-establish the position, please record your repository reads as you
go, using this convention and nothing more elaborate:

    After each repository file you read, add one line of the form
        READ <path> <bytes returned>
    where <bytes returned> is the size of the content actually returned to you for
    that read — the whole file if you read it whole, or the size of the portion
    returned if you read a range or a matched section. Do not batch several reads
    into one line, do not skip a read because it was small, and do not suppress or
    summarise content in order to keep the number down. If you re-read something,
    record it again.

    At the end, give the total and the list.

Then tell me what the actual current position is and what happens next.
```

Expected recovery output boundaries, so the run can be judged rather than admired: `$realign` should hand to `$reorient` before loading Work Loop governance material and return no verdict of its own; `$reorient` should select `u4-live-case` and never adopt `u4-context-refill-audit`, reconstruct both `NA-U4-EXACT-TASK-FACT` and `DURABLE-FACT-U4-ROLLOVER`, and not return `DECOY-FACT-U4-TRANSPORT`; the plan read should stop at `## 7. Rollover acceptance` unless a stated uncertainty widens it; the routing index and the courier, routing and unit-framing references should go unread unless the recovered next action genuinely needs one; and the returned `Next:` should name Claude, matching `turn: claude`. A run that returns the decoy fact, or that adopts the summary's closed/operator claim, has failed regardless of its byte total.

Cleanup ownership: both disposable checkouts are removed at Unit 4's close, not before, so the case stays repeatable if the first run is inconclusive — the case at `ai-resources-wl2-unit4-case` (branch `disposable/wl2-unit4-case-2026-08-17`) and a throwaway `ai-resources-wl2-unit4-cleanctl` created only to produce the red run. Removing the second one now was refused by the repository's liveness guard, which read its untracked preflight copy as uncommitted work and recent writes; liveness is the operator's fact, so it was left in place rather than overridden.

## Blocker

None.

## Next action

Codex: assess Unit 4b — prepare the representative live case. Judge whether the case genuinely forces targeted reading rather than rewarding a whole-plan slurp, whether the misleading summary is wrong in ways a correct recovery must detect from durable sources alone, and whether claim 5's self-reported budget proxy — auditable per line, unprovable for completeness, with the atime alternative disproved — is sufficient for Unit 4's comparison against the 205,922-byte baseline or needs reframing before the live run. Then close, continue to Unit 4's live proof, correct once, or stop.
