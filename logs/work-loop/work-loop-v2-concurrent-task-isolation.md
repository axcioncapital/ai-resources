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

**Final bounded fix (2026-08-11) — two seams, closed.** Seam 1 is resolved by moving the marker inside the surface Codex already writes, so the ordinary Local task needs no new command, no authority grant and no extra round trip. Seam 2 is resolved by narrowing Codex's own guarantee to the checkout half and naming where the repository-wide half is actually enforced; the existing `--status` surface is offered as an operator-decided upgrade, with its scope limit stated rather than assumed. Nothing accepted earlier is reopened.

Result: **Seam 1** — the marker moves from `logs/.work-loop-owner` to **`logs/work-loop/.owner`**, gitignored, written by whoever creates the task's state file, immediately before it. In the ordinary case that is Codex, as a plain file write inside the one directory it already owns. **Seam 2** — interactive Codex enforces the checkout half only (is *this* checkout claimed by a different task?), which its local read can establish; the task half (is *my* task claimed elsewhere, is the state file replicated?) is enforced by the actors that may run git — interactive Claude at Step 1 and the dispatcher at admission. Because Claude makes every commit (core § 4), every unit crosses a Claude entry before anything is committed, so the exposure window is exactly one Codex brief write into a checkout the local read has already cleared. This narrowing is stated as a limit, not presented as coverage.

Evidence: **Seam 1** — `logs/work-loop/.owner` is inside Codex's existing write surface and inside `dispatch.sh`'s default allowlist: `printf 'logs/work-loop/.owner' | grep -cE '^logs/work-loop/'` returns `1`. It stays uncommitted: with the file present, `git status --porcelain -- logs/work-loop/` matched `.owner` **1** time (control — the rule absent, the file must appear), and `git -c core.excludesFile=<rule> status --porcelain -- logs/work-loop/` matched it **0** times. The probe file was removed; `ls logs/work-loop/.owner` now reports no such file. `foreign_worktree()` reads `git status --porcelain` and filters against `ALLOW_PATHS`, so an ignored file is invisible to it and an un-ignored one would still be allowed — the dispatcher needs no change for the marker itself. **Seam 2** — `.agents/skills/work-loop-v2/SKILL.md:243` already gives Codex the literal invocation `dispatch.sh --checkout <path> --task <task-id> --status`, `:246` states it is "read-only — no lock, no log, no write", and `dispatch.sh:975–977` confirms it in code (`[ "$STATUS_MODE" -eq 1 ] || acquire_lock`). `:224` supplies the reconciliation with the prohibition — "Launching the dispatcher is not running git … and writes nothing through git." **But `:243` sits inside the Courier-mode section, which `:184` declares "optional and off by default"**, so a Codex session without courier approval has no standing permission to run it. That limit is why the upgrade is an operator choice below and not the recommended default. What would have falsified this fix: if the ignore rule had not suppressed the marker, or if `--status` had turned out to take a lock or write, the narrowed guarantee would have been the only available answer and the upgrade would have been withdrawn.

**Frozen findings 1–5, reproduced earlier this round and now resolved.** Each was checked by opening the file, before any correction was written.

- Finding 1 — **reproduces.** Core `:404` records that Codex "was refused write access to `.git`, the folder Git keeps its own records in." `.agents/skills/work-loop-v2/SKILL.md:134` reads "You **never run git.** Not `add`, not `commit`, not `checkout`", and `:521` repeats "**Commit, or run any git command.** Claude does that". So Codex can neither write inside the Git common directory nor run `git rev-parse --git-common-dir` to locate it. The previous candidate put that write at task-start, which SKILL.md `:151` assigns to Codex. The finding is correct and the design was wrong.
- Finding 2 — **reproduces.** The previous record was keyed by task id, created per task, enumerated by `--status`, migrated for 18 existing tasks, consulted to identify the authoritative copy, and removed at closure. That is a persistent task registry by function, and the task's own exclusions name one.
- Finding 3 — **reproduces.** The previous check asked only "is task T in T's recorded checkout", so tasks A and B could each record checkout X and each receive `OWNED-HERE`. Nothing in it keyed on the checkout. Inspection also settles the liveness half: `.claude/hooks/detect-concurrent-session.sh:89` sets `CC_PROCESS_PATTERN="${CC_PROCESS_PATTERN:-native-binary/claude}"` and `:96` filters `ps` output by that string alone — there is **no Codex process pattern anywhere in the hook**, so interactive Codex has no observable liveness signal in this repository.
- Finding 4 — **reproduces.** The previous pack described manual worktree creation as a residual action while still claiming the exit condition was met. The objective at `## Objective and scope` asks for automatic creation or reuse without the operator reasoning through Git mechanics, so that was a scope reduction presented as a design choice.

The ownership-record design was withdrawn and replaced, not patched: findings 1, 2 and 3 by inverting what is recorded — from a task→checkout map to a per-checkout declaration of its writer — and finding 4 by supplying an authorised pre-brief creation path rather than asking the operator to weaken the objective. Grounding inspections: `logs/scripts/prime-session-entry.sh:36–40` shows the repository already operates per-checkout gitignored declaration files (`logs/.session-marker`, `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`), and `.gitignore` lists `logs/.prime-mtime`, `logs/.session-marker` and `logs/.session-marker-*`, so a gitignored declaration is not replicated by any merge and is writable without touching `.git`. `.claude/commands/new-worktree-session.md:56` creates the worktree with `git worktree add`, and `:63–69` opens it in a new VS Code window via `code -n` with two fallbacks.

---

### The corrected candidate — R2, "the checkout declares its writer"

**What is recorded.** One gitignored file per checkout, **`logs/work-loop/.owner`**, holding one task id and the date it was claimed. Its path is deliberate: it sits *inside* `logs/work-loop/`, which is the one directory both actors already write and which `dispatch.sh`'s default allowlist already covers as `^logs/work-loop/`. It behaves like the existing `logs/.session-marker` family — a gitignored per-checkout declaration — and joins that family rather than starting a new mechanism class. There is **no file anywhere that maps tasks to checkouts.**

**Who writes it, in both lanes — seam 1 and finding 1.** **Whoever creates the task's state file writes the marker, immediately before it, as a plain file write.** In the ordinary case that is Codex, and it needs no git, no new command, no authority grant and no extra round trip: `logs/work-loop/.owner` is inside the surface Codex already owns, and Codex creates `logs/work-loop/` itself today (SKILL.md `:151`). Codex therefore stays entirely inside `:134` and `:521`. Claude writes the marker only when Claude itself opens a task, and clears it at closure in the same write that reduces the file to the closing record.

**The pre-brief sequence — one sequence, both lanes.** The write happens *before* the state file exists, not after:

1. The operator brings the request to Codex, exactly as core § 4 requires.
2. Codex applies SKILL.md's existing isolation table (`:161–171`). Where the table says **Local**, go straight to step 4 in the current checkout. Where it says **isolate**, Codex ends its reply with the Next line it already writes today, naming one Claude command.
3. That Claude command creates the worktree (`git worktree add`, `new-worktree-session.md:56`) and opens it in a new VS Code window (`:63–69`). The operator opens Codex on that checkout.
4. Codex reads `logs/work-loop/.owner`. If it names a different open task, Codex refuses and writes nothing. Otherwise Codex writes the marker, then writes the first brief into `logs/work-loop/{task-id}.md`.

The ordinary Local task is therefore protected before binding by the same step that protects an isolated one, and `/new-worktree-session` needs no work-loop awareness at all — **it drops out of the change set entirely**, which is strictly less machinery than the previous version of R2. Creation and window-opening stay automatic and the operator reasons through no Git mechanics. **The one residual operator action is opening Codex on the prepared checkout**, and only on the isolated path; the Local path has none.

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
- **What interactive Codex can and cannot establish — seam 2.** A local read of `logs/work-loop/.owner` answers one question: *is this checkout claimed by a different task?* That is the whole of Codex's enforcement, and it is the half that matches Codex's own failure mode, because the only thing Codex writes is a brief into the checkout it is standing in. It **cannot** establish that its task is claimed in another checkout, or that the state file is replicated — both need `git worktree list`, and Codex runs no git. Those two facts are established by the actors that may: interactive Claude at Step 1, and `dispatch.sh` at admission. **The guarantee is narrowed here, explicitly.** What keeps the narrowing sound rather than a gap is that Claude makes every commit (core § 4), so every unit crosses a Claude entry before anything is committed; the exposure is one uncommitted brief in a checkout the local read already cleared.
- **Partly resolved, and labelled as such.** Two interactive sessions opened on one checkout for the **same** task are not prevented by anything in this scope, and neither is an operator who proceeds past a refusal. Interactive enforcement is instruction-borne; only dispatch is exit-code-borne. **This is the material scope reduction the finding asks to see stated, and it is stated rather than covered by claim.**

**Locks retained.** The two repository-scoped locks in the Git common directory — one keyed on the task, one on the checkout — replace the composite `${TMPDIR}` key and remain necessary: the marker governs open-task exclusivity, the locks govern live-process exclusivity. They are written by `dispatch.sh`, which may run git, so finding 1 does not touch them.

---

### Gate 3 decision pack (corrected)

**Established problem and diagnosis.** A composite `checkout|task` lock under caller-controlled `${TMPDIR}` enforces neither task nor checkout exclusivity; once two tasks share a checkout the shared working tree and index permit cross-task commit contamination, and the diagnostics misattribute it. Demonstrated at `7a13a45` and `395edd1`. Carried forward as accepted: committed state files replicate across worktrees (D1), so file presence cannot identify ownership; the task-branch convention is withdrawn; exit 25 is retained; both interactive actor surfaces change.

**Recommended minimum correction.** (a) Two repository-scoped locks replacing the composite `${TMPDIR}` key. (b) One gitignored `logs/work-loop/.owner` per checkout, written by whoever creates the task's state file immediately before it — Codex in the ordinary case, with no git and no new authority — and cleared at closure. (c) One shared check, at the depth each actor can reach: interactive Codex reads its own checkout's marker; interactive Claude and the dispatcher additionally enumerate registered worktrees. Verdicts are proceed / refuse-with-name / ambiguous. **What changes in operator practice:** for an ordinary Local task, nothing you do changes. When Codex judges that isolation is needed, its Next line sends you to one Claude command that creates the worktree and opens the window for you; you then open Codex on that checkout. Entering a task from a checkout claimed by another task now stops with the other task named. Branching, landing and cleanup are unchanged.

**Simplest credible alternative — the two locks alone.** Correct while a run is in flight, and it is the safety floor. It gives no continuity between handoffs, no interactive coverage and no ownership visibility, so it does not meet the exit condition. It is the right choice only if the decision is to land safety now and defer continuity.

**Explicit operator choices.**
1. Take R2, or land the two locks only and defer continuity.
2. Accept **one gitignored marker file per checkout at `logs/work-loop/.owner`** as the persistent artifact. It is the only new durable object, and it is the one thing to reject if the no-registry boundary is read more strictly than R2 reads it.
3. Accept the **residual operator action**: opening Codex on the prepared checkout, on the isolated path only. Creation and window-opening are automatic; this step is not. The Local path has no residual action.
4. Accept the **interactive scope reduction**, now in two parts: two interactive sessions on one checkout for the same task, and an ignored refusal, are not prevented; and interactive Codex enforces only the checkout half, with the cross-checkout half enforced at the next Claude entry, which every unit crosses before anything is committed.
5. **Decide on the `--status` upgrade.** Codex could get repository-wide ownership visibility of its own by running the read-only `dispatch.sh … --status`, an invocation SKILL.md `:243` already spells out and `:246` already certifies as read-only. The obstacle is scope, not authority: `:243` lives in the Courier-mode section, which `:184` makes optional and off by default. Permitting that one read-only invocation outside courier mode is a **narrow, explicit widening** for you to grant or refuse. Refusing costs nothing structural — it leaves the recommended narrowing in place.
6. Accept the **dormant-task lease**: an open task holds its checkout until it closes. This is the price of handoff continuity.
7. Confirm that **no new create authority is granted to Codex or to the dispatcher**. All creation stays in Claude's existing `/new-worktree-session` machinery, which this fix leaves unmodified.

**Capabilities and files affected.** `dispatch.sh` and `dispatch.test.sh`; `.claude/commands/work-loop-v2.md` Step 1; `.agents/skills/work-loop-v2/SKILL.md` (isolation table gains the marker step and the Next-line hand-off); `docs/parallel-sessions-playbook.md` § 4; one new helper under `logs/scripts/` with its test; one `.gitignore` line (`logs/work-loop/.owner`); `plans/…/handoff-automation-spike/README.md`. **`.claude/commands/new-worktree-session.md` is no longer in the change set** — the marker is written by the state file's creator, so that command needs no work-loop awareness. Not the executable core, not the five-field ceiling, not the four hooks.
**Persistent artifacts and lifecycle owners:** `logs/work-loop/.owner` — created by whoever creates the task's state file (Codex in the ordinary case), cleared at closure by Claude in the same write that reduces the file to the closing record, owner is the work-loop surface set; the two lock directories — process-lifetime, owner is `dispatch.sh`; the helper script and its test — owner is `dispatch.sh`'s owner. No branches and no worktrees accumulate beyond those the operator already creates.
**Visible failure mode:** an entry that should proceed is refused with the claiming task named. Noisy, never silent.
**Rollback and residue:** revert the call sites, the lock change and the helper; delete the marker files and the `.gitignore` line. Nothing survives a revert — no branch, no worktree, no committed record.

**Required behavioural evidence.** Thirteen cases, each red-before / green-after with one relevant control, no artificial per-test negative control:

| # | Asserts | Red today because |
|---|---|---|
| T1 | same task, same checkout, second dispatcher refused under two different `TMPDIR` roots (control: one shared root) | composite key sits under `${TMPDIR}` (`dispatch.sh:485`) |
| T2 | same task, two worktrees, second entry refused and names the claiming checkout | nothing persists between runs |
| T3 | two tasks, one checkout, second refused and names the holding task | nothing keys on the checkout alone |
| T4 | fan-out 2 on separate worktrees completes with no cross-task path in either commit range | allowlist admits shared-prefix cross-task writes (M3d) |
| T5 | later handoff into the claimed checkout proceeds and creates nothing | no claim exists |
| T6 | **pre-brief authority, both lanes** — for an ordinary **Local** task and for an isolated one, the marker exists before `logs/work-loop/{task-id}.md` does; a sequence that creates the state file without a marker fails; and no git command is run by the writer | no marker exists, and an ordinary Local task had no pre-brief writer at all |
| T7 | **single physical binding preserved** — a replicated task file does not let a second checkout enter; no file is copied, moved or created | D1: replicas exist and nothing distinguishes them |
| T8 | **ordinary serial path** — a Local task with no worktree runs unchanged, creates no isolation, and reuses its checkout after closure | regression guard for the fix itself |
| T9 | **lost-record refusal** — marker absent with the state file replicated yields `AMBIGUOUS` in every checkout, and no checkout claims | nothing refuses today |
| T10 | **safe migration** — an existing open task with replicated copies is never silently claimed by the checkout contacted first | nothing refuses today |
| T11 | **simultaneous interactive tasks in one checkout** — a second task's interactive entry is refused, by Codex's local marker read alone and with no git invoked. The **same** task entered twice interactively is **not** covered and is recorded as the accepted scope reduction, not as a passing case | no interactive check exists |
| T12 | **the marker is local, not shared** — with the ignore rule in place `git status --porcelain` does not list `logs/work-loop/.owner` and no commit contains it; control: with the rule removed it does appear | the file and the rule do not exist |
| T13 | **Codex's narrowed guarantee is real** — a task claimed in another checkout is admitted by Codex's local read and refused at the next Claude entry, before any commit exists | neither check exists |

Representative operator validation after integration, not a precondition for accepting the implementation: two genuinely useful concurrent tasks, separate worktrees, real Claude and Codex actors, at least one handoff each, ending in a real landing. Fan-out above two stays untested.

**Known uncertainty.** Interactive compliance is instruction-borne. Frequency of a differing `${TMPDIR}` in real use is unmeasured. Whether the refusal message is understandable to a person is only testable in the post-integration run.

**Non-goals, unchanged.** Automatic push, merge, landing, conflict resolution, branch deletion or worktree deletion; universal one-worktree-per-session behaviour; a scheduler; a persistent task registry; a second semantic state system; fan-out above two.

**What would justify reverting after implementation.** A correct single task is refused; a handoff loses or duplicates the claim; an ordinary serial task is forced into isolation; a replicated task file is silently claimed; ownership status omits an active supported entry path; or the marker's lifecycle costs exceed the demonstrated safety benefit in representative fan-out-2 use.

**Candidate deferrals, recorded and not implemented.** (a) `.claude/hooks/detect-concurrent-session.sh` detects only Claude processes; adding a Codex pattern would give interactive Codex an observable lifetime and would upgrade the accepted reduction, but it is a hook change outside this task's scope. (b) The 18 replicated open task files and stale fixtures under `logs/work-loop/` want a cleanup. (c) The three sibling checkouts hold older `dispatch.sh` copies; propagation is an integration concern. The earlier deferral about `/new-worktree-session` becoming work-loop-aware **is withdrawn** — this fix removes that command from the change set, so there is nothing left to defer.

No implementation was performed. No production file was modified. Both this fix and the correction before it changed only this state file. One probe file was created and removed during the evidence check above; `ls logs/work-loop/.owner` confirms it is gone.

## Blocker

None.

## Next action

Codex: run the closure check on these two fixes only, then go to the operator or stop.

1. **Seam 1 — pre-brief ownership for an ordinary Local task.** The marker moves to `logs/work-loop/.owner`, inside the surface Codex already writes and inside the dispatcher's default allowlist, and is written by whoever creates the state file, immediately before it. No new command, no authority grant, no extra round trip — so the comparison against the two-lock floor is unchanged and no charge was hidden. `/new-worktree-session` leaves the change set. Check that Codex still runs no git and writes nothing outside `logs/work-loop/`.
2. **Seam 2 — Codex's cross-checkout discovery.** The guarantee is narrowed rather than assumed: Codex's local read settles the checkout half only; the task half is settled by Claude at Step 1 and by the dispatcher at admission, and every unit crosses a Claude entry before any commit exists. The `--status` surface is presented as an operator choice, with its real obstacle named — `SKILL.md:243` grants the invocation, `:246` certifies it read-only, but it sits inside the Courier-mode section that `:184` makes off by default. Check that this reconciles the prohibition rather than stepping around it.

Nothing accepted earlier was reopened, no new architecture was added, no production file was modified. Three candidate deferrals stand at the end of `## Latest result`; the `/new-worktree-session` deferral is withdrawn because the command left the change set. If the check passes, the next move is the operator's Gate 3 scope decision — not implementation.
