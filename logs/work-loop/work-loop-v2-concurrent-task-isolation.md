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

**Frozen findings reproduced (2026-08-11).** Each was checked by opening the file, before any correction was written.

- Finding 1 — **reproduces.** Core `:404` records that Codex "was refused write access to `.git`, the folder Git keeps its own records in." `.agents/skills/work-loop-v2/SKILL.md:134` reads "You **never run git.** Not `add`, not `commit`, not `checkout`", and `:521` repeats "**Commit, or run any git command.** Claude does that". So Codex can neither write inside the Git common directory nor run `git rev-parse --git-common-dir` to locate it. The previous candidate put that write at task-start, which SKILL.md `:151` assigns to Codex. The finding is correct and the design was wrong.
- Finding 2 — **reproduces.** The previous record was keyed by task id, created per task, enumerated by `--status`, migrated for 18 existing tasks, consulted to identify the authoritative copy, and removed at closure. That is a persistent task registry by function, and the task's own exclusions name one.
- Finding 3 — **reproduces.** The previous check asked only "is task T in T's recorded checkout", so tasks A and B could each record checkout X and each receive `OWNED-HERE`. Nothing in it keyed on the checkout. Inspection also settles the liveness half: `.claude/hooks/detect-concurrent-session.sh:89` sets `CC_PROCESS_PATTERN="${CC_PROCESS_PATTERN:-native-binary/claude}"` and `:96` filters `ps` output by that string alone — there is **no Codex process pattern anywhere in the hook**, so interactive Codex has no observable liveness signal in this repository.
- Finding 4 — **reproduces.** The previous pack described manual worktree creation as a residual action while still claiming the exit condition was met. The objective at `## Objective and scope` asks for automatic creation or reuse without the operator reasoning through Git mechanics, so that was a scope reduction presented as a design choice.

Result: the ownership-record design is **withdrawn and replaced**, not patched. Findings 1, 2 and 3 are resolved by inverting what is recorded — from a task→checkout map to a per-checkout declaration of its writer. Finding 4 is resolved by supplying an authorised pre-brief creation path rather than by asking the operator to weaken the objective. Finding 5's corrected pack and evidence plan follow. One part of finding 3 is only partly resolved and is labelled as such below.

Evidence: the four reproduction checks above, each naming the file and line that settles it, plus the two inspections that ground the replacement — `logs/scripts/prime-session-entry.sh:36–40` shows the repository already operates per-checkout gitignored declaration files (`logs/.session-marker`, `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`), and `.gitignore` lists all three of `logs/.prime-mtime`, `logs/.session-marker` and `logs/.session-marker-*`, so a gitignored sibling is not replicated by any merge and is writable without touching `.git`. `.claude/commands/new-worktree-session.md:56` creates the worktree with `git worktree add`, and `:63–69` opens it in a new VS Code window via `code -n` with two fallbacks. What would have falsified the replacement: if the marker family had turned out to be committed files, or if `new-worktree-session` had been unable to open the window, the manual-creation floor would have been the only honest answer.

---

### The corrected candidate — R2, "the checkout declares its writer"

**What is recorded.** One gitignored file per checkout, `logs/.work-loop-owner`, holding one task id and the date it was claimed. It is a sibling of `logs/.session-marker` and joins that existing family rather than starting a new mechanism class. There is **no file anywhere that maps tasks to checkouts.**

**Who writes it — finding 1.** **Claude writes it; Codex never does.** Claude already runs git and already writes repository files, so no authority is invented and none is assumed. Codex's only interaction is a local read of the marker in the checkout it is already standing in, which is an ordinary file read requiring no git — so Codex stays entirely inside SKILL.md `:134` and `:521`.

**The pre-brief sequence — findings 1 and 4.** The write happens *before* the state file exists, not after:

1. The operator brings the request to Codex, exactly as core § 4 requires.
2. Codex applies SKILL.md's existing isolation table (`:161–171`). Where the table says isolate, Codex ends its reply with the Next line it already writes today, naming one Claude command.
3. That Claude command creates the worktree (`git worktree add`, `new-worktree-session.md:56`), opens it in a new VS Code window (`:63–69`), and writes `logs/.work-loop-owner` in the new checkout.
4. The operator opens Codex on that checkout and Codex writes the first brief into `logs/work-loop/{task-id}.md` there.

Creation and window-opening are therefore automatic and the operator reasons through no Git mechanics. **The one residual operator action is step 4** — opening Codex on the prepared checkout — and it is named rather than absorbed.

**Why it is not a registry — finding 2.** Nothing is keyed by task id, nothing is stored centrally, and nothing is migrated. The decisive property is what the marker is *not* used for: **it never chooses among replicated copies of a task file.** It is only ever used to refuse — a second task entering a claimed checkout, or a task whose id is claimed by a different checkout. Refusal needs no authoritative-copy selection, which is exactly what made the withdrawn design a second binding. Where a repository-wide question is asked at all, the answer is computed on demand by reading each worktree's own declaration; there is no stored index to fall out of sync.
Charged honestly against that: it is still a persistent artifact with a lifecycle, and it is accounted for as one below. It is not offered as free.

**Lost, stale and missing behaviour — finding 2, in full.**

| State found | Verdict |
|---|---|
| No marker; the state file exists nowhere | Free to claim. Ordinary new task. |
| No marker; the state file exists in **exactly one** checkout | That checkout may re-declare; any other is refused. A single copy is decisive evidence — it is this task's own situation today. |
| No marker; the state file is **replicated** across checkouts | `AMBIGUOUS`. Every checkout is refused and the operator names the owner. **The checkout contacted first never claims silently** — this is the migration case finding 2 names, and it covers the 18 open tasks that are replicated today. |
| Marker present; no state file in that checkout | Contradiction. Refuse and report. |
| Marker names a task whose local copy is closed (`turn: operator`) | Stale. Reported, and cleared by the next task-start **in that same checkout** — never by another checkout. |
| Marker unreadable or holding more than one id | `AMBIGUOUS`. Refuse and report. |

**Checkout exclusion, and the honest limit — finding 3.** The marker holds **at most one open task**, so two tasks declaring one checkout is precisely what it refuses; task B entering a checkout claimed by task A is stopped with A named. That closes the hole in the withdrawn design.
Writer lifetime, stated plainly and not smoothed over:

- **Dispatched writers** get a process-backed lifetime — the dispatcher's live checkout and task locks, acquired at admission and released at exit.
- **Interactive writers have no process-backed lifetime available.** The inspection above shows the only liveness machinery in the repository detects `native-binary/claude` and nothing else, so interactive Codex is invisible to it. The interactive lease is therefore held by the **task's open state**, not by a session.
- **That is a lease held by a dormant open task, which the finding warns about.** It is accepted deliberately, because continuity between handoffs is what the objective asks for and a session-scoped lease cannot survive a session ending. Its cost is bounded and visible: starting a *different* task in that checkout is refused until the task closes, and the refusal names the holding task and both remedies (close it, or use another checkout). Ordinary serial reuse is unaffected — closure clears the marker, and one task at a time in one checkout is the ordinary case.
- **Partly resolved, and labelled as such.** Two interactive sessions opened on one checkout for the **same** task are not prevented by anything in this scope, and neither is an operator who proceeds past a refusal. Interactive enforcement is instruction-borne; only dispatch is exit-code-borne. **This is the material scope reduction the finding asks to see stated, and it is stated rather than covered by claim.**

**Locks retained.** The two repository-scoped locks in the Git common directory — one keyed on the task, one on the checkout — replace the composite `${TMPDIR}` key and remain necessary: the marker governs open-task exclusivity, the locks govern live-process exclusivity. They are written by `dispatch.sh`, which may run git, so finding 1 does not touch them.

---

### Gate 3 decision pack (corrected)

**Established problem and diagnosis.** A composite `checkout|task` lock under caller-controlled `${TMPDIR}` enforces neither task nor checkout exclusivity; once two tasks share a checkout the shared working tree and index permit cross-task commit contamination, and the diagnostics misattribute it. Demonstrated at `7a13a45` and `395edd1`. Carried forward as accepted: committed state files replicate across worktrees (D1), so file presence cannot identify ownership; the task-branch convention is withdrawn; exit 25 is retained; both interactive actor surfaces change.

**Recommended minimum correction.** (a) Two repository-scoped locks replacing the composite `${TMPDIR}` key. (b) One gitignored `logs/.work-loop-owner` per checkout, written by Claude at task-start before the state file exists, cleared by Claude at closure. (c) One shared check consulted by interactive Claude, interactive Codex and the dispatcher, returning proceed / refuse-with-name / ambiguous. **What changes in operator practice:** when Codex judges that isolation is needed, its Next line sends you to one Claude command that creates the worktree and opens the window for you; you then open Codex on that checkout. Entering a task from a checkout claimed by another task now stops with the other task named. Branching, landing and cleanup are unchanged.

**Simplest credible alternative — the two locks alone.** Correct while a run is in flight, and it is the safety floor. It gives no continuity between handoffs, no interactive coverage and no ownership visibility, so it does not meet the exit condition. It is the right choice only if the decision is to land safety now and defer continuity.

**Explicit operator choices.**
1. Take R2, or land the two locks only and defer continuity.
2. Accept **one gitignored marker file per checkout** as the persistent artifact. It is the only new durable object, and it is the one thing to reject if the no-registry boundary is read more strictly than R2 reads it.
3. Accept the **residual operator action**: opening Codex on the prepared checkout. Creation and window-opening are automatic; this step is not.
4. Accept the **interactive scope reduction**: two interactive sessions on one checkout for the same task, and an ignored refusal, are not prevented. Dispatch is enforced; interactive entry is instructed.
5. Accept the **dormant-task lease**: an open task holds its checkout until it closes. This is the price of handoff continuity.
6. Confirm that **no new create authority is granted to Codex or to the dispatcher**. All creation stays in Claude's existing `/new-worktree-session` machinery.

**Capabilities and files affected.** `dispatch.sh` and `dispatch.test.sh`; `.claude/commands/work-loop-v2.md` Step 1; `.agents/skills/work-loop-v2/SKILL.md` (isolation table gains the marker step and the Next-line hand-off); `.claude/commands/new-worktree-session.md` (writes the marker after creating the worktree — a small addition, where the withdrawn design needed none); `docs/parallel-sessions-playbook.md` § 4; one new helper under `logs/scripts/` with its test; one `.gitignore` line; `plans/…/handoff-automation-spike/README.md`. Not the executable core, not the five-field ceiling, not the four hooks.
**Persistent artifacts and lifecycle owners:** `logs/.work-loop-owner` — created by `/new-worktree-session` or Claude's task-start, cleared by Claude at closure, owner is the work-loop surface set; the two lock directories — process-lifetime, owner is `dispatch.sh`; the helper script and its test — owner is `dispatch.sh`'s owner. No branches and no worktrees accumulate beyond those the operator already creates.
**Visible failure mode:** an entry that should proceed is refused with the claiming task named. Noisy, never silent.
**Rollback and residue:** revert the call sites, the lock change and the helper; delete the marker files and the `.gitignore` line. Nothing survives a revert — no branch, no worktree, no committed record.

**Required behavioural evidence.** Eleven cases, each red-before / green-after with one relevant control, no artificial per-test negative control:

| # | Asserts | Red today because |
|---|---|---|
| T1 | same task, same checkout, second dispatcher refused under two different `TMPDIR` roots (control: one shared root) | composite key sits under `${TMPDIR}` (`dispatch.sh:485`) |
| T2 | same task, two worktrees, second entry refused and names the claiming checkout | nothing persists between runs |
| T3 | two tasks, one checkout, second refused and names the holding task | nothing keys on the checkout alone |
| T4 | fan-out 2 on separate worktrees completes with no cross-task path in either commit range | allowlist admits shared-prefix cross-task writes (M3d) |
| T5 | later handoff into the claimed checkout proceeds and creates nothing | no claim exists |
| T6 | **pre-brief authority** — the marker is written by Claude before the state file exists, and a run in which Codex writes it fails | the write did not exist, and the withdrawn design put it in Codex's hands |
| T7 | **single physical binding preserved** — a replicated task file does not let a second checkout enter; no file is copied, moved or created | D1: replicas exist and nothing distinguishes them |
| T8 | **ordinary serial path** — a Local task with no worktree runs unchanged, creates no isolation, and reuses its checkout after closure | regression guard for the fix itself |
| T9 | **lost-record refusal** — marker absent with the state file replicated yields `AMBIGUOUS` in every checkout, and no checkout claims | nothing refuses today |
| T10 | **safe migration** — an existing open task with replicated copies is never silently claimed by the checkout contacted first | nothing refuses today |
| T11 | **simultaneous interactive tasks in one checkout** — a second task's interactive entry is refused. The **same** task entered twice interactively is **not** covered and is recorded as the accepted scope reduction, not as a passing case | no interactive check exists |

Representative operator validation after integration, not a precondition for accepting the implementation: two genuinely useful concurrent tasks, separate worktrees, real Claude and Codex actors, at least one handoff each, ending in a real landing. Fan-out above two stays untested.

**Known uncertainty.** Interactive compliance is instruction-borne. Frequency of a differing `${TMPDIR}` in real use is unmeasured. Whether the refusal message is understandable to a person is only testable in the post-integration run.

**Non-goals, unchanged.** Automatic push, merge, landing, conflict resolution, branch deletion or worktree deletion; universal one-worktree-per-session behaviour; a scheduler; a persistent task registry; a second semantic state system; fan-out above two.

**What would justify reverting after implementation.** A correct single task is refused; a handoff loses or duplicates the claim; an ordinary serial task is forced into isolation; a replicated task file is silently claimed; ownership status omits an active supported entry path; or the marker's lifecycle costs exceed the demonstrated safety benefit in representative fan-out-2 use.

**Newly noticed during this correction, recorded as candidate deferrals and not implemented.** (a) `.claude/commands/new-worktree-session.md` becomes a work-loop-aware surface under R2, which is a small widening of that command's remit and may deserve its own review. (b) `.claude/hooks/detect-concurrent-session.sh` detects only Claude processes; adding a Codex pattern would give interactive Codex an observable lifetime and would upgrade finding 3's accepted reduction, but it is a hook change outside this task's scope. (c) The 18 replicated open task files and stale fixtures under `logs/work-loop/` want a cleanup. (d) The three sibling checkouts hold older `dispatch.sh` copies; propagation is an integration concern.

No implementation was performed. No production file was modified. This correction changed only this state file.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen findings only — are findings 1 to 5 resolved, and did the correction break anything?

1. **Finding 1** — the marker write moves to Claude, before the state file exists, using `/new-worktree-session`'s existing `git worktree add`. Codex writes nothing outside `logs/work-loop/` and runs no git. Check that no assumed authority remains.
2. **Finding 2** — the task→checkout map is gone; a per-checkout declaration replaces it, is never used to select among replicated copies, and has stated lost / stale / missing behaviour including the never-silently-claim rule for replicated files. Check whether that still functions as a registry in your reading.
3. **Finding 3** — checkout exclusion now holds at most one open task per checkout. The lease is task-scoped, not session-scoped, and two interactive sessions on one checkout for the **same** task are named as an accepted scope reduction rather than covered. Check that the reduction is stated where the operator will see it.
4. **Finding 4** — an authorised pre-brief creation path is supplied, so no revision of the objective is requested. One residual operator action remains and is named. Check that this is a real path and not a relabelled manual floor.
5. **Finding 5** — the corrected pack carries D1, the branch withdrawal, exit 25 and the interactive-surface changes forward, adds T6, T9, T10 and T11, and re-accounts for every persistent artifact and its lifecycle owner.

Four candidate deferrals are recorded at the end of `## Latest result` and are not part of any scope lock. If the closure check passes, the next move is the operator's Gate 3 scope lock — not implementation, and not a second correction round.
