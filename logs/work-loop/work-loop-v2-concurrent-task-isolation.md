---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make concurrent Claude and Codex work a safe, supported Work Loop v2 operating model: when another useful task starts, the system should handle routine isolation mechanics, preserve task-to-checkout continuity across handoffs, make ownership visible, and refuse duplicate ownership of either a logical task or a writable checkout.

The target operator experience is automatic creation or reuse of a dedicated task worktree when concurrent writing requires isolation, without requiring the operator to reason through Git mechanics. Human control remains mandatory for whether tasks genuinely belong together, merge and final landing decisions, conflict resolution, and destructive cleanup. Excluded are automatic push, merge, branch deletion, worktree deletion, conflict resolution, universal one-worktree-per-session behavior, a general scheduler, a persistent task registry, and any second semantic state system.

Task exit condition: the repository contains an implemented and evidenced minimum mechanism, integrated with Work Loop v2's existing entry and handoff surfaces, that safely supports two concurrent tasks in one repository on separate worktrees, rejects the same logical task in two worktrees, rejects two dispatched writers in one physical checkout, reuses the bound task worktree on later handoffs, and presents understandable ownership/status information.

Governing task method: apply the structural route in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` inside the Work Loop v2 unit cycle: failure proof; blind fresh-context evidence review; causal model and structural options; Codex complexity challenge and operator scope lock; controlled Claude implementation; independent clean-environment verification; operator-controlled integration and representative fan-out-2 validation. Preserve this sequence through compaction and future unit rewrites without adding a second case document or state system.

## Lane and unit

Standard. Discovery mode. Unit 5 — resolve the SOP Step B5 required corrections and produce one scope-lock candidate plus the concise Gate 3 decision pack for the operator; do not implement.

Named reason for the loop: the work spans investigation, planning, implementation, and independent assessment; its scope crosses existing concurrency and transport controls and must remain bounded before changes begin.

## Brief

Claude's Unit 4 diagnosis is accepted, but its Option D implementation boundary is not ready for scope lock. The proposal correctly removes the composite lock failure, yet it starts automation inside an optional dispatcher after the state file has already bound the task to a checkout, and it explicitly leaves interactive Claude/Codex operation outside the guarantee. Unit 5 must resolve that entry-and-binding seam and return a corrected, minimum-complexity plan for operator trade-off approval.

Required outcome: revise the proposed structural correction against the frozen Step B5 findings below. Return one recommended scope-lock candidate, the simplest credible alternative, and a short SOP Gate 3 decision pack. Do not implement, change production resources, create/move a worktree, migrate this live task, or ask the operator to approve technical correctness.

Accepted evidence and decisions:

- Gate 2 failure proof is preserved at `7a13a45`; the controlled concurrency matrix is preserved at `395edd1`. The immediately preceding Claude commit touching this state file contains the full Unit 4 causal model and options.
- Codex accepts the core diagnosis with high confidence: a composite `checkout|task` lock under caller-controlled `${TMPDIR}` enforces neither repository-wide task exclusivity nor checkout-wide writer exclusivity; once two tasks share a checkout, the shared working tree/index permits cross-task commit contamination. Fragmented diagnostics and status surfaces then miss or misattribute the admitted writers.
- The case remains structural rather than a bounded lock-path repair because the approved outcome includes task-to-checkout continuity, entry/handoff behaviour, and operator-visible ownership in addition to dispatcher exclusion.
- Option C (two repository-scoped live locks) is the safety floor but cannot provide later-handoff continuity. Option D (task branch plus create/reuse worktree plus repository-scoped task lock) remains a plausible candidate, not an approved solution.
- The default complexity budget remains zero. Counting files or commands is not enough: branch/worktree creation authority, lifecycle accumulation, migration and changes to entry behaviour are permanent complexity and must be charged honestly.

Step B5 verdict: **Proceed with required corrections.** Resolve all six before implementation:

1. **Resolve the bootstrap and physical-binding seam.** The task file's physical checkout is currently the binding (`.agents/skills/work-loop-v2/SKILL.md`), while `dispatch.sh` requires `--checkout`, derives `STATE_FILE` under that checkout, and validates it before launching. Explain exactly how isolation is decided and, when needed, created **before Codex writes the first brief**, and separately how a later handoff discovers and reuses the already-bound checkout. A dispatcher must not silently relocate, copy, or create a second task file after the binding exists. If full automation cannot cross that product boundary safely, surface the residual operator action rather than hiding it.
2. **Cover the operating model actually requested, or expose a scope reduction.** Courier/dispatcher mode is optional and off by default; interactive `/work-loop-v2` in Claude and the Codex skill both resolve a task file only inside their current checkout. The revised plan must show how interactive Claude, interactive Codex, and dispatched hops see the same ownership/binding rule and avoid the same writable checkout. If the minimum safe experiment can cover only dispatched runs, label that as a material scope reduction for the operator instead of claiming the task exit condition is met.
3. **Keep isolation conditional and preserve human judgment.** The target is create/reuse when concurrent writing requires isolation, not a task branch/worktree for every serial dispatch. Define the observable condition that selects local versus isolated operation, what becomes sticky once a task is isolated, and how ambiguity refuses safely. Preserve the operator's decisions about whether work belongs together and about landing/cleanup; do not encode those judgments as an automatic branch convention.
4. **Clarify whether a branch is a locator or a second binding.** The state-file location must remain the one semantic binding unless the operator explicitly approves changing that contract. If `work-loop/<task-id>` is retained, specify drift handling for an existing task on another branch, branch rename/deletion, an existing but unregistered/prunable worktree, and a path collision. Explain why the convention is less machinery than deriving/reusing the registered worktree that already contains the authoritative task file. Never auto-move this live task.
5. **Correct the scope and complexity accounting.** Account for the dispatcher's new create authority, accumulated branches/worktrees, migration, status enumeration, changed landing practice, and rollback residue. Reassess which existing surfaces require behaviour changes: at minimum inspect the Codex skill's binding/entry rules, Claude's local task resolution, `dispatch.sh`, `/new-worktree-session`, and the playbook. Do not treat four sibling worktree copies of `dispatch.sh` as four implementation targets; change only this bound checkout and carry rollout risk to operator-controlled integration. Make exit 24 observational rather than naming an actor it did not observe; exit 25 may be removed or deferred if its demonstrated trigger becomes unreachable.
6. **Make verification match the full boundary.** Retain behaviour cases for `TMPDIR`-independent exclusion, same-task/two-worktree refusal, two-task/one-checkout refusal, safe fan-out 2, and later-handoff reuse. Add cases for the pre-brief entry/bootstrap path, preservation of the single physical task-file binding, the ordinary serial/no-isolation path, and ownership/status visibility across Claude/Codex plus interactive/dispatched entry surfaces. A red-before/green-after case and a relevant control are sufficient; remove the proposed ceremony of one deliberately wrong negative control per test.

Required repository checks before revising the plan:

- Recheck `.agents/skills/work-loop-v2/SKILL.md` around the physical binding, explicit Local/Worktree choice, existing-worktree fallback, and courier being optional/off by default.
- Recheck `.claude/commands/work-loop-v2.md` Step 1's current-checkout-only task resolution.
- Recheck `dispatch.sh` from `--checkout` canonicalisation through `STATE_FILE` construction and initial `validate_state`; settle whether create/reuse can legally occur before those steps without contradicting the single-file interface.
- Recheck `docs/parallel-sessions-playbook.md` § 4 and `.claude/commands/new-worktree-session.md`, including the current requirement that an existing state file/worktree precede dispatch, the command's inability to move a live session, and its `-2`/`-3` uniquifying behaviour.
- If any claim is false, hand back the exact mismatch rather than adapting silently.

Gate 3 decision pack required at the end of `## Latest result`:

- established problem and supported diagnosis;
- recommended minimum correction and what changes in operator practice;
- the simplest credible alternative and why it is insufficient or preferable;
- explicit choices the operator must make, especially any new create authority, branch convention, residual manual step, or material dispatcher-only scope reduction;
- capabilities/files affected; machinery added and removed; maintenance owner; visible failure mode; rollback and cleanup residue;
- required behavioural tests and representative post-integration fan-out-2 validation;
- known uncertainty and explicit non-goals.

Keep it short enough for a scope decision. The detailed reasoning may precede it, but do not create a separate plan, case document, registry, or decision artifact.

Completion condition: return a corrected scope-lock candidate that resolves all six findings, state whether it is ready for operator Gate 3, write it into `## Latest result`, set `turn: codex`, commit only this state-file handback, and stop. Do not implement or set `turn: operator`; Codex must assess the corrected candidate first.

## Latest result

Inspected (2026-08-11):

- Claim (1) — `.agents/skills/work-loop-v2/SKILL.md` states the physical binding, an explicit Local/Worktree choice, the existing-worktree fallback, and courier being optional/off by default: **HOLDS** — read lines 153–184. `:155` "**The task file's location is the binding.** … Nothing records this in the file — a state field would be a second copy, free to drift"; `:176` "**Choose Local or Worktree explicitly**, per the table above, when the chat is created"; `:180` the existing-worktree fallback opens the permanent worktree as a **Local** checkout; `:184` "**It is optional and off by default**".
- Claim (2) — `.claude/commands/work-loop-v2.md` Step 1 resolves the task only inside the current checkout: **HOLDS** — `:143` reads `Read the state file at `logs/work-loop/{task-id}.md``, a repo-relative path, and `grep -n -i 'other checkout|worktree|another checkout'` over the whole file returns only `:19`, which is the core resolver's own boundary text. No repository-wide task discovery exists.
- Claim (3) — `dispatch.sh` canonicalises `--checkout`, derives `STATE_FILE` under it, and validates that file before actor launch, with no pre-brief task-start step: **HOLDS** — `:306` requires `--checkout`; `:366–369` canonicalise it and require a Git checkout; `:387–388` set `STATE_DIR="$CHECKOUT/logs/work-loop"` and `STATE_FILE="$STATE_DIR/$TASK.md"`; `:484–485` key the lock `sha256(checkout|task)` under `${TMPDIR:-/tmp}`; `:1785` is the first `validate_state` call, before the hop loop. `grep -n validate_state` returns definitions/calls at `:1339, :1785, :1829, :1977` only — nothing earlier, and no branch or worktree resolution anywhere in the admission path.
- Claim (4) — `docs/parallel-sessions-playbook.md` § 4 says a dispatched run starts in an operator-created worktree holding an existing state file: **HOLDS** — `:125` "for exactly one task with an existing state file … The worktree is still created by the operator (path 3 above), never by the dispatcher".
- Claim (5) — `.claude/commands/new-worktree-session.md` cannot move the live session and uniquifies with `-2`/`-3`: **HOLDS** — `:17` "**Hard limit** … This command **cannot move your current session into the** worktree"; `:44` "If `WORKTREE_PATH` already exists, append `-2`, `-3`, … until unique (do not clobber an" existing one); `:59` tells the operator to pick a different unit or reuse the existing worktree by hand.
- Claim (6) — the accepted evidence commits exist: **HOLDS** — `git log --oneline -1 7a13a45` returns the Unit 1 failure proof; `395edd1` returns the Unit 3 concurrency matrix.

**New evidence found while checking, and it changes the recommendation (D1).** The state file is a **committed** file, so Git replicates it into every worktree whose branch contains its commits. Enumerating `git worktree list --porcelain` (12 registered worktrees) and reading the `turn:` line of every `logs/work-loop/*.md` found **18 distinct open tasks (`turn:` `claude` or `codex`) present in more than one worktree**. `work-loop-v2-intake-router.md` exists in 8 worktrees and its copies **disagree**: `turn: claude` in `~/.codex/worktrees/02e6/ai-resources`, `turn: codex` in the other 7. Falsifier that did not occur: if presence identified ownership, every open task would have appeared exactly once; the actual maximum was 12 (`fixture-slice1-true.md`, `fixture-slice1-false.md`). This task itself is the clean case — `work-loop-v2-concurrent-task-isolation.md` is present in exactly one worktree (this one), because its commits have not merged to `main`.

Consequence: **"the task file's location is the binding" is a rule for actors, not a discoverable fact.** Any mechanism that finds the bound checkout by looking for the file — including the alternative named in finding 4 ("deriving/reusing the registered worktree that already contains the authoritative task file") — returns N answers for any task whose commits have merged, and cannot tell the authoritative copy from a replica. A `--status` that enumerates worktrees for state files reports replicas as ownership. This is not an implementation detail; it removes one of the two candidate mechanisms outright.

---

### Resolving the six frozen findings

**Finding 1 — the bootstrap and physical-binding seam.**
The binding is created the moment `logs/work-loop/{task-id}.md` is written, which is before the first brief and therefore before any dispatcher exists. A dispatcher cannot own the isolation decision without either relocating or duplicating that file, both of which the single-interface contract forbids. **So isolation moves to task-start, where SKILL.md `:176` already puts it, and the dispatcher gains no create authority at all.** Concretely: at task-start the actor applies SKILL.md's existing isolation table, the operator creates the worktree by hand where the table calls for isolation (`/new-worktree-session`, unchanged), and the task-start step then writes one **ownership record** naming the checkout it is about to write the state file into. A later handoff does not search for the file — it reads that record, verifies the recorded checkout is a registered non-prunable worktree that actually contains the state file, and attaches there. Disagreement between record and file is refused and reported, never repaired.
**Residual operator action, stated rather than hidden:** creating the worktree stays manual. Automatic worktree creation is deliberately not taken in this minimum, because the only actor positioned to do it (the dispatcher) runs after the binding already exists.

**Finding 2 — cover the operating model actually requested.**
The three entry surfaces are made to consult **one shared check**, so the rule is single-sourced rather than restated three times: `/work-loop-v2` Step 1 (interactive Claude), the Codex skill's task-start and handoff rules (interactive Codex), and `dispatch.sh` admission. The check answers one question — *for task T, which checkout owns it, and am I in that checkout?* — with four verdicts: `OWNED-HERE` (proceed), `OWNED-ELSEWHERE` (report the owning path, stop), `UNBOUND` (task-start only: record this checkout), `AMBIGUOUS` (stop for the operator). Because the check is repository-scoped and reads shared Git metadata, an interactive Claude window opened in the wrong checkout on a replicated task file is refused by the same rule that refuses a wrong-checkout dispatch. **No scope reduction to dispatched-only is required, and none is claimed** — but see the honest limit under *Known uncertainty*: an interactive actor's compliance rests on its instructions, not on Git, whereas the dispatcher's rests on an exit code.

**Finding 3 — isolation stays conditional, human judgment preserved.**
The observable condition is SKILL.md's existing table, unchanged and not replaced by a decision procedure: a worktree is called for when there is a **concurrent writer in the same repository**, an unattended run, or a genuinely large implementation; otherwise the task is Local. Ordinary serial work therefore records ownership of the ordinary local checkout and creates nothing. What becomes sticky once recorded is only the **checkout path** — not a branch, not a directory naming rule, and not a landing practice. Ambiguity refuses: a recorded path that is missing, unregistered, prunable, or does not contain the state file is `AMBIGUOUS` and goes to the operator. Whether two pieces of work belong to one task, when to land, and when to delete anything remain operator decisions and are encoded nowhere.

**Finding 4 — locator versus second binding.**
Under this candidate **no branch convention is retained**, so `work-loop/<task-id>` and its drift cases (existing task on another branch, rename, deletion, unregistered or prunable worktree, path collision) do not arise. The reason is D1 plus one further point: a task branch is enforced by Git only against a *second checkout of that branch*, and the failure that actually needs covering — an actor opening a replicated state file in a checkout that is on some other branch — is not that case. So the branch buys create authority, accumulating branches and a changed landing practice without covering the interactive path any better than a check does.
The ownership record is a **locator, not a binding**: the state file's location remains the one semantic binding, the record only points at it, and every read verifies the pointer against the file. Where they disagree the file wins and the run stops. It lives in the Git common directory (`git rev-parse --git-common-dir`), which is shared by every worktree, is not a committed file, and is therefore not replicated by merges — the precise property D1 shows the working tree lacks. It holds one line, an absolute path: no objective, no brief, no turn, no result, so it is not a second semantic state system and adds no field to the five-field ceiling. **This live task is not moved:** its record would be written for the checkout it already occupies.
Codex's own suggested alternative — reuse the worktree that contains the task file — is **not implementable as described**, per D1.

**Finding 5 — corrected scope and complexity accounting.**
*Machinery added (permanent):* one helper script (the shared check plus record read/write) under `logs/scripts/`; one directory of one-line records in the Git common directory, one per active task; three call sites that consult it; and the two-lock replacement inside `dispatch.sh`.
*Machinery removed:* the composite `checkout|task` lock key; the `${TMPDIR:-/tmp}` lock root; the allowlist's informal second job as a cross-task safety net.
*Authority:* **no new create authority anywhere.** The dispatcher creates no branch and no worktree. This is the single largest reduction against Unit 4's Option D.
*Accumulation:* one small record per active task; no branches and no worktrees accumulate beyond what the operator already creates. Records are removed with the task at closure — a one-line addition to the closing write, not a new lifecycle.
*Migration:* an open task with no record is `UNBOUND` on first contact and records the checkout it is already in. There are 18 such open tasks today per D1, plus fixtures. Nothing is moved.
*Landing practice:* unchanged. This is the second largest reduction against Option D.
*Status enumeration:* `--status` reports from the record directory and the two lock directories, never by scanning worktrees for state files — D1 shows that scan is wrong.
*Rollback residue:* delete the helper, revert the three call sites and the lock change; the record directory is inert data inside `.git` and can be removed. No branch or worktree survives a revert, unlike Option D.
*Surfaces requiring behaviour change, after inspection:* `.agents/skills/work-loop-v2/SKILL.md` (task-start records ownership; handoff consults it) — **this contradicts Unit 4's claim that the two actor surfaces need no change, and that claim is withdrawn**; `.claude/commands/work-loop-v2.md` Step 1; `dispatch.sh` (locks, admission check, `--status`); `docs/parallel-sessions-playbook.md` § 4 item 3 (add the ownership check to both entry paths; its statement that the operator creates the worktree stays **true** and unchanged); `.claude/commands/new-worktree-session.md` (**no change needed** — with no branch convention, its `-2`/`-3` rule no longer contradicts anything). Only this bound checkout is changed; the three sibling copies of `dispatch.sh` carry old behaviour until the normal merge, and that transition risk is named for operator-controlled integration.
*Exit 24:* reworded to report the observation — HEAD moved during a hop whose actor was `codex` — without asserting that Codex moved it, since another writer in a shared checkout produces the same reading (`:1991`).
*Exit 25:* **retained, not removed.** Its measured trigger is a Claude hop refused permission to run git (`:2008` comment), which is independent of concurrency and stays reachable under this candidate. B5's condition for removal is not met.

**Finding 6 — verification matching the full boundary.**
Nine behaviour cases in `dispatch.test.sh` and the helper's own test, each written red-before/green-after, each with one relevant control, and **no per-test artificial negative control**:

| # | Asserts | Red today because |
|---|---|---|
| T1 | same task, same checkout, second dispatcher refused under two different `TMPDIR` roots (control: one shared root) | composite key lives under `${TMPDIR}` (`:485`) |
| T2 | same task, two worktrees, second entry refused and names the owning checkout | no binding persists between runs |
| T3 | two tasks, one checkout, second refused | nothing keys on the checkout alone |
| T4 | fan-out 2 on separate worktrees completes with no cross-task path in either commit range | allowlist admits shared-prefix cross-task writes (M3d) |
| T5 | later handoff attaches to the recorded checkout, creates nothing | no record exists |
| T6 | **pre-brief entry** — task-start records ownership before the first brief; a dispatcher started against an unrecorded task refuses rather than binding late | dispatcher's first act is `validate_state` on a file it assumes (`:387–388, :1785`) |
| T7 | **single physical binding preserved** — a task file replicated into a second worktree still resolves to the recorded owner, and entry in the replica is refused; no file is copied, moved or created | D1: replicas exist and nothing distinguishes them |
| T8 | **ordinary serial path** — a Local task with no worktree runs unchanged and creates no isolation | regression guard for the fix itself |
| T9 | **visibility** — ownership and in-flight status read the same from any checkout, any `TMPDIR`, for Claude and Codex, interactive and dispatched | `--status` reads only its own lock path |

Representative operator validation after integration (not a precondition for accepting the implementation): two genuinely useful concurrent tasks, separate worktrees, real Claude and Codex actors, at least one handoff each, ending in a real landing. Fan-out above two stays untested.

---

### Gate 3 decision pack

**Established problem and supported diagnosis.** A composite `checkout|task` lock under caller-controlled `${TMPDIR}` enforces neither task exclusivity nor checkout exclusivity; once two tasks share a checkout the shared working tree and index permit cross-task commit contamination, and the diagnostics then misattribute it. Demonstrated by execution at `7a13a45` and `395edd1`. **Added by this unit:** committed state files replicate across worktrees, so file presence cannot identify the bound checkout (18 open tasks duplicated today; one task's copies disagree on `turn:`).

**Recommended minimum correction — "one ownership record, checked at every entry".** (a) Two independent locks in the Git common directory, one keyed on the task and one on the checkout, replacing the composite `${TMPDIR}` lock. (b) One one-line ownership record per active task in the Git common directory, written at task-start, verified against the state file at every use, removed at closure. (c) One shared check consulted by interactive Claude, interactive Codex and the dispatcher. **What changes in operator practice:** at task-start you state Local or Worktree as SKILL.md already asks, and you still create the worktree yourself; entering a task from the wrong checkout now stops with a message naming the right one. Landing, branching and cleanup are unchanged.

**Simplest credible alternative — Option C alone** (the two locks, nothing else). It is the safety floor and it is correct while a run is in flight, but it provides no continuity between handoffs, no interactive coverage, and no ownership visibility — so it does not meet the task's exit condition. It is the right fallback if the decision is to land safety only and defer continuity.

**Explicit operator choices.**
1. Take the recommended candidate, or land Option C only and defer continuity.
2. Accept **one small record file per active task inside `.git`** as the persistent locator. This is the one genuinely new artifact.
3. Accept the **residual manual step**: worktree creation stays operator-run. Full automation is not offered, and the reason is that the only actor able to do it runs after the binding exists.
4. Confirm that **no new create authority** for the dispatcher is wanted — this reverses Unit 4's recommendation, and reversing it back re-opens branch convention, accumulation and landing practice.
5. Confirm the branch convention `work-loop/<task-id>` is **dropped**.
6. Confirm interactive coverage may rest on instructions rather than on a Git-enforced refusal (see uncertainty below).

**Capabilities and files affected.** `dispatch.sh`, `dispatch.test.sh`, `.claude/commands/work-loop-v2.md`, `.agents/skills/work-loop-v2/SKILL.md`, `docs/parallel-sessions-playbook.md` § 4, one new helper under `logs/scripts/` with its test, `plans/…/handoff-automation-spike/README.md`. **Not** `.claude/commands/new-worktree-session.md`, the executable core, the five-field ceiling, or the four hooks. **Added:** one helper, one record per active task, three call sites. **Removed:** the composite key, the `${TMPDIR}` root, the allowlist's informal cross-task role. **Maintenance owner:** whoever owns `dispatch.sh`; no recurring process. **Visible failure mode:** an entry that should proceed is refused with a named checkout — noisy, not silent, and T8 guards the common case. **Rollback:** revert three call sites, the lock change and the helper; the record directory is inert data in `.git`. No branch or worktree survives a revert.

**Known uncertainty.** Interactive compliance is instruction-borne, not Git-enforced — an operator who ignores a refusal can still write in the wrong checkout, and no mechanism inside this scope prevents that. Frequency of a differing `TMPDIR` in real use is unmeasured. Fan-out above two is untested. Whether the ownership message is understandable to a person is only testable in the post-integration run.

**Explicit non-goals.** Automatic push, merge, landing, conflict resolution, branch deletion or worktree deletion; automatic worktree creation; universal one-worktree-per-session behaviour; a scheduler; a persistent task registry; a second semantic state system; any change to interactive same-checkout concurrency, which the playbook and `/new-worktree-session` already own; fan-out above two.

**Readiness.** Ready for operator Gate 3, conditional on Codex accepting D1 and the consequent withdrawal of the branch convention — that reversal is the substantive change from Unit 4 and should be assessed before the operator sees it.

**Adjacent work noticed and deliberately not done.** (a) 18 open task files are replicated across worktrees and several are stale fixtures; a cleanup of `logs/work-loop/` is worth doing and is outside this scope. (b) The three sibling checkouts hold older `dispatch.sh` copies; propagation is an integration concern, not a unit of this task.

**What would justify reverting after implementation.** Carried forward from B5 and re-pointed at this candidate: a correct single task is refused; a handoff creates a second binding or loses the existing one; an ordinary serial task is forced into isolation; the ownership record and the state file drift apart without the check catching it; ownership status omits an active supported entry path; or the record's lifecycle costs exceed the demonstrated safety benefit in representative fan-out-2 use. The two revert triggers that were about automatic creation no longer apply, because nothing is created automatically.

No implementation was performed. No production file was modified. This unit changed only this state file.

## Blocker

None.

## Next action

Codex: assess the corrected scope-lock candidate in `## Latest result` before it reaches the operator. Three things need a decision:

1. **Accept or reject finding D1** — committed state files replicate across worktrees, so file presence cannot identify the bound checkout (18 open tasks duplicated today; `work-loop-v2-intake-router.md` present in 8 worktrees with disagreeing `turn:` values). Everything below depends on it. Re-derive it if wanted: enumerate `git worktree list --porcelain` and read each `logs/work-loop/*.md` frontmatter.
2. **Confirm the reversal of Unit 4's recommendation.** The branch convention `work-loop/<task-id>` and the dispatcher's new create authority are both withdrawn, replaced by an ownership record in the Git common directory plus one shared entry check. This is the substantive change from Unit 4 and is the item to challenge hardest.
3. **Confirm two corrections to B5's optional suggestions.** Exit 25 is retained rather than removed — its measured trigger (a Claude hop refused permission to run git) is independent of concurrency and stays reachable. Unit 4's claim that the two actor surfaces need no change is withdrawn: `SKILL.md` and `work-loop-v2.md` both change, because interactive coverage is what finding 2 requires.

Two deferrals are recorded at the end of `## Latest result` and are not part of any scope lock: cleaning up the replicated and stale files in `logs/work-loop/`, and propagating `dispatch.sh` to the three sibling checkouts.

If the candidate holds, the next move is the operator's Gate 3 scope lock, not implementation.
