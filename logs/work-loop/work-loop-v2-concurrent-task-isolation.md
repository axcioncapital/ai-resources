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

Standard. Implementation mode. Unit 6 — implement the operator-approved R2 correction in this bound worktree and return a committed, unmerged candidate with red/green behavioural evidence.

Named reason for the loop: the work spans investigation, planning, implementation, and independent assessment; its scope crosses existing concurrency and transport controls and must remain bounded before changes begin.

## Brief

R2 has passed the SOP's diagnosis and complexity challenge and the operator has now authorised its locked implementation scope. This unit changes the proven concurrency mechanism while preserving human control over landing, conflicts, and cleanup; it does not claim resolution, because independent verification and representative operation still follow. Implement only the approved candidate identified below and hand it back as an unmerged verification candidate.

### Governing authority and approved content identity

- Current operator decision: the 2026-08-11 instruction to prepare the next Claude task approves Codex's recommended R2 package, not the two-lock-only alternative, and leaves the optional Codex `--status` widening outside this implementation.
- Approved content identity: **R2, “the checkout declares its writer,” in this state file as handed back by Claude in commit `d67c3d0` and accepted by Codex's final closure check.** Verify that commit and this task-file provenance before changing production files. If the content identity does not resolve to the R2 candidate described here, stop and hand back the mismatch.
- The Work Loop v2 proposal remains governing intent; its post-MVP single-writer/isolation trigger is now supplied by the proved conflicts. The executable core and the active Claude/Codex Work Loop v2 resources govern actor roles and the single state-file interface.
- The repository-problem-resolution SOP governs this structural implementation: Step B6 scope lock and Step B7 controlled implementation now; Step B8 independent clean-environment verification remains a later unit and must not be collapsed into Claude's self-report.

### Required outcome — the locked R2 correction

Implement these behaviours together:

1. Replace the caller-`TMPDIR` composite dispatcher lock with two live locks located through the repository's Git common directory: one keyed by logical task and one keyed by physical checkout. A second live dispatcher must be refused if either resource is already held, including when the callers use different `TMPDIR` roots.
2. Introduce one gitignored per-checkout declaration at `logs/work-loop/.owner`, containing one task id and claim date. Whoever creates a new task state file writes the declaration immediately before that state file; Claude clears it when closure reduces the task to the closing record.
3. Use one shared ownership check with verdicts equivalent to proceed, refuse with the conflicting task/checkout named, and ambiguous. Interactive Codex checks only whether its current checkout is claimed by another task, using a local read and no Git. Interactive Claude and the dispatcher additionally inspect registered worktrees before execution or commit to detect the same task elsewhere and replicated/ambiguous state files.
4. Preserve conditional isolation. Ordinary serial Local work remains in its checkout. When the existing isolation policy requires a worktree, the existing Claude `/new-worktree-session` path creates and opens it; the operator still opens Codex in that prepared checkout. Once isolated, later handoffs reuse the bound checkout.
5. Preserve the safe state table approved in R2: a unique state-file copy may re-declare a missing marker only in that checkout; replicated copies with no marker are ambiguous everywhere and never first-contact claimed; marker-without-local-state, unreadable/multi-id marker, and conflicting claims refuse visibly; a closed local task's stale marker may be cleared by the next task start in that same checkout.
6. Keep the accepted limitations explicit in the resources: an open task leases its checkout until closure; Codex guarantees only the current-checkout half; same-task duplicate interactive sessions and deliberate bypass of an instruction-borne refusal are not technically prevented.

Do not silently replace these settled behaviours with another architecture. Ordinary reversible implementation choices inside this boundary are Claude's to make and report.

### Authorised files and components

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
- `.claude/commands/work-loop-v2.md`
- `.agents/skills/work-loop-v2/SKILL.md`
- `docs/parallel-sessions-playbook.md`, limited to the concurrent-session/worktree guidance in §4
- `.gitignore`, limited to the `logs/work-loop/.owner` rule
- one new shared ownership helper under `logs/scripts/` and its directly corresponding test
- this state file for the handback

Codex's file list is a locked boundary, not a requirement to edit every listed file. Change only files whose behaviour or contract actually needs to change, and explain any authorised file left untouched.

### Exclusions and preservation constraints

- Do not change `.claude/commands/new-worktree-session.md`; R2 deliberately reuses it unchanged.
- Do not change the executable core, proposal, hooks, model settings, permission settings, sibling worktrees, other task state files, or unrelated logs including `logs/friction-log.md`.
- Do not create a task registry, task-branch convention, new command, agent, hook, service, database, recurring process, second binding, or new worktree-creation authority.
- Do not auto-move, copy, migrate, or claim this live task's state file or create `logs/work-loop/.owner` for this already-open task as an implementation side effect.
- Do not merge, push, land, delete a branch/worktree, resolve unrelated conflicts, or perform cleanup outside the authorised change.
- Preserve the five-field state-file ceiling and the physical task-file location as the single semantic binding.

### Verify before implementation

Report current Git status first. This checkout is expected to be the already-created isolated checkout bound to this task; verify its branch, clean/dirty state, current base commit, the state-file identity, and the `d67c3d0` R2 provenance. Do not create another implementation worktree or move this task. If the correct base depends on uncommitted work, or unrelated changes overlap an authorised file, stop and ask rather than staging or committing them.

Re-derive these load-bearing repository claims before acting:

- In `dispatch.sh`, locate the current composite lock, its `${TMPDIR}` dependency, checkout canonicalisation, state-file construction, initial validation, status path, allow-path behaviour, and exit-code meanings.
- In `.agents/skills/work-loop-v2/SKILL.md`, verify the current physical-binding rule, Local/Worktree isolation policy, pre-brief writer, existing-worktree fallback, Codex Git prohibition, and courier-off-by-default boundary.
- In `.claude/commands/work-loop-v2.md`, verify Step 1 currently resolves only the task in the active checkout and identify the closure write that must clear a declaration.
- In the playbook and spike README, verify the current interactive/dispatched entry guidance that R2 supersedes.
- Across `.gitignore` and the current per-checkout session-marker examples, verify that `logs/work-loop/.owner` will remain checkout-local and cannot enter a commit.

For every absence claim, name the searched surface and pattern. If a load-bearing claim is false or implementing it requires scope outside the authorised list, hand back the exact mismatch without adapting the plan silently.

### Required behavioural evidence

Implement durable regression coverage for the approved T1–T13 matrix from R2:

- T1 different-`TMPDIR` same-task/same-checkout dispatch exclusion, with the existing shared-root case as control.
- T2 same task in two worktrees refused with the claiming checkout visible.
- T3 two tasks in one checkout refused with the holding task visible.
- T4 fan-out 2 in separate worktrees succeeds without cross-task paths in either candidate range.
- T5 a later handoff reuses the claimed checkout and creates no replacement binding.
- T6 Local and isolated pre-brief paths require `.owner` before the state file, with no Git run by the writer.
- T7 a replicated task file cannot authorise a second checkout and is never copied, moved, or recreated by the check.
- T8 ordinary serial Local work remains non-isolated and the checkout is reusable after closure.
- T9 missing marker plus replicated state file is ambiguous everywhere and claims nowhere.
- T10 migration/first-contact cannot silently claim a replicated open task.
- T11 a second interactive task is refused by Codex's local marker read alone; same-task duplicate interactive sessions remain an explicit non-goal.
- T12 `.owner` is absent from status and commits with the ignore rule, while a meaningful control proves it would be visible without that rule.
- T13 Codex's deliberately narrowed check may admit a same-task claim elsewhere, but the next Claude entry refuses it before any implementation commit.

Build the regression coverage before production changes and capture the baseline output. Red-before evidence is required for every changed failure class; preservation cases that already pass on the baseline, such as the ordinary serial control, must be reported honestly rather than forced to fail. After implementation, all T1–T13 and the relevant existing dispatcher/work-loop tests must pass. Exercise real scripts, locks, Git worktrees, and entry paths where safe; actor stubs are acceptable for the model boundary, and real networked Claude/Codex fan-out remains the operator's post-integration validation rather than this unit's authority.

Evidence must include:

- the baseline command(s), exit codes, and actual output showing the original failures;
- the post-change command(s), exit codes, and actual output for T1–T13, relevant existing tests, and at least one refusal/failure path;
- generated output from one representative scripted fan-out-2 or handoff case using the real dispatcher/ownership path;
- a check that `.owner` cannot be committed, with its meaningful no-ignore control;
- the current base commit and final implementation commit;
- every changed and deleted file, with the behavioural change in each affected component;
- permanent machinery added, replaced, and removed;
- deviations from R2, authorised files intentionally left unchanged, remaining limitations, and rollback instructions usable after integration.

Do not claim the task or defect is resolved. State only that the committed implementation candidate is ready for independent verification.

### Stop conditions

Stop and return for renewed operator approval if implementation reveals a need for materially different architecture; a new permanent service, agent, command, hook, registry, or shared-state mechanism; cross-repository changes; additional capability removals; a changed causal diagnosis; a substantially larger scope; or widening Codex `--status` outside courier mode. Stop and hand back to Codex for a false premise, a required file outside scope, or evidence that cannot be produced. Do not stop for ordinary reversible implementation details inside the locked scope.

Completion condition: implement only R2, commit the implementation and this handback in the task's existing isolated branch/worktree without merging or pushing, write the full evidence report into `## Latest result`, set `turn: codex`, and stop.

## Latest result

Inspected (2026-08-11):

- Claim (1) `dispatch.sh` composite lock, `${TMPDIR}` dependency, canonicalisation, state-file construction, initial validation, status path, allow-paths, exit codes: **HOLDS** — read `dispatch.sh`; composite key at `:484` (`sha256("$CHECKOUT|$TASK")`), `${TMPDIR:-/tmp}` parent at `:485`, checkout canonicalisation `cd && pwd -P` at `:367`, `STATE_DIR`/`STATE_FILE` at `:387-388`, first `validate_state` at `:1785`, `--status` skips the lock at `:977` (`[ "$STATUS_MODE" -eq 1 ] || acquire_lock`), default allow-paths at `:316-326`, exit-code table at `:119-177` with 27 a deliberate gap.
- Claim (2) `SKILL.md` physical binding, isolation policy, pre-brief writer, existing-worktree fallback, Git prohibition, courier default: **HOLDS** — `:155` "The task file's location is the binding"; isolation table `:163-169`; Codex creates `logs/work-loop/` at `:151`; existing-worktree fallback `:180`; "You **never run git**" `:134`, repeated `:521`; courier "optional and off by default" `:184`.
- Claim (3) `.claude/commands/work-loop-v2.md` Step 1 resolves only the active checkout; the closure write: **HOLDS** — `:143` resolves `logs/work-loop/{task-id}.md` under the running checkout with no cross-worktree enumeration; the closure write is `## Closing the task` `:251`, with the de-escalation reduction at `:219`.
- Claim (4) playbook and spike README entry guidance: **HOLDS** — playbook § 4 `:106-130` carries the ad-hoc same-checkout anti-pattern and the two entry paths (interactive `/new-worktree-session`, dispatched `dispatch.sh`), with the worktree "created by the operator, never by the dispatcher"; README `## Running the dispatcher` `:24-48` documents the option surface R2 extends.
- Claim (5) `logs/work-loop/.owner` stays checkout-local: **HOLDS** — searched `.gitignore` for `owner`: no match before this unit, so no pre-existing rule. The per-checkout gitignored declaration precedent is real: `.gitignore:34-39` lists `logs/.prime-mtime`, `logs/.session-marker`, `logs/.session-marker-*`, and `logs/scripts/prime-session-entry.sh:36-41` writes exactly that family. `:148` of that script also already keys cross-worktree claims off `$GIT_COMMON`, which is the precedent the relocated locks follow.

Provenance: `d67c3d0` exists, is an ancestor of `HEAD` (`381559f`), touches only this state file, and its `## Latest result` carries R2 "the checkout declares its writer" — the marker at `logs/work-loop/.owner`, the two repository-scoped locks, the narrowed Codex guarantee and the dormant-task lease. Content identity resolves to the brief's approved candidate.

Result: **the locked R2 correction is implemented and committed in this worktree, unmerged and unpushed. This is an implementation candidate for independent verification (SOP Step B8). It is not a claim that the task or the defect is resolved.**

### Starting state

Branch `session/2026-08-11-work-loop-ceremony`, **base commit `381559f`**, in the worktree already bound to this task. **The final implementation commit is the single commit on top of that base — the tip of this branch, which is also the commit carrying this state file.** Resolve it with `git rev-parse HEAD`, or `git log --oneline 381559f..HEAD` to see that there is exactly one. It is deliberately not written here as a literal hash: this file is inside that commit, so any hash written into it is invalidated by the act of committing it. Two files were dirty at entry and neither was staged by this unit: this state file (carrying the Unit 6 brief itself) and `logs/friction-log.md` (a write-activity hook append). No second implementation worktree was created and this task was not moved.

### Baseline — red before

`bash logs/scripts/work-loop-owner.test.sh` → exit 1, **24 passed, 37 failed**. The failures are the changed behaviour classes:

- T1 different-`TMPDIR` exclusion FAILED; **its shared-`TMPDIR` control PASSED on the baseline** — reported as passing, not forced red, because it is the preservation case.
- T3 dispatcher half FAILED — two different tasks in one checkout both admitted.
- T2, T5–T11, T13 FAILED for want of the helper (`work-loop-owner.sh: No such file or directory`).
- T12 FAILED — the ignore rule genuinely did not exist; the harness copies the **real** repository `.gitignore` into its sandboxes rather than authoring one, so T12 measures this repository's rule and not the harness's.
- **T4 PASSED on the baseline** — fan-out 2 on separate worktrees already worked. Reported honestly as a preservation/regression guard rather than presented as a fixed defect.

Case 0 is the harness's own falsifiability proof: pointed at an absent helper, the suite fails.

### Green after

| Suite | Result |
|---|---|
| `logs/scripts/work-loop-owner.test.sh` (T1–T13) | exit 0 — **61 passed, 0 failed** |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` | exit 0 — **pass=381 fail=0** (375 before; +6 from the new case 12b/12c) |
| `logs/scripts/work-loop-v2-core-resolver.test.sh` | exit 0 — 4 passed, 0 failed |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | exit 1 — 292 passed, **3 failed, all pre-existing and unchanged** |

The three slice-1 failures are not caused by this unit and are unchanged in count and identity from the baseline run. Two (`3.1a`) test `logs/work-loop/` against a hard-coded 25-file allowlist while the directory holds 56 files — including this task's own state file, which predates this unit; this unit added no file to `logs/work-loop/`. The third asserts SKILL.md is under a 340-line ceiling; it was **543 lines at `HEAD`** before any edit here. This unit took it to 564, so it worsens a pre-existing breach — recorded as a deferral below, not fixed, because restructuring that file is outside the authorised scope.

### Generated output — representative fan-out 2, real dispatcher and real helper

Two linked worktrees, two tasks, concurrent dispatchers, **different `TMPDIR` roots**, actors stubbed:

```
alpha exit=0   beta exit=0
ownership: PROCEED — this checkout already declares task 'fanout-alpha'; task 'fanout-alpha' is declared by this checkout; the later handoff reuses it
ownership: PROCEED — this checkout already declares task 'fanout-beta'; task 'fanout-beta' is declared by this checkout; the later handoff reuses it
alpha candidate range: [logs/work-loop/fanout-alpha.md ]
beta  candidate range: [logs/work-loop/fanout-beta.md ]
```

Each candidate range contains only its own task's path.

### Refusal and ambiguity paths, end to end

```
=== the same task entered from a second checkout ===
exit=33
STOP [33] ownership refused for task fanout-alpha in .../wt-beta
verdict: REFUSE
reason: task 'fanout-alpha' is already claimed by checkout .../wt-alpha — continue the task there, or close it first
Recoverable next action: continue the task in the checkout named above, or close it there first. Nothing was launched.

=== a second task entering a checkout held by an OPEN task ===
exit=33
verdict: REFUSE
reason: this checkout is claimed by open task 'holder' — close it, or use another checkout. An open task leases its checkout until closure.

=== a replicated state file with no declaration ===
exit=34
verdict: AMBIGUOUS
reason: task 'replicated' has a state file in more than one checkout and no checkout declares it: .../repo .../wt2 — replicated copies authorise nobody; the operator names the owner
```

A first attempt at the second case returned `PROCEED` instead, because the fan-out run had already closed the holding task and the stale-declaration row correctly applied. The scenario was rebuilt with an **open** holder, which is the output above. Recorded because the first reading would have been the wrong evidence for the claim.

`--status` ownership surface, read-only, no lock taken and nothing written:

```
owner: this checkout declares fanout-alpha 2026-08-11
checkout-lock: free (.../repo/.git/work-loop-dispatch-locks/checkout-2eaadbc27e9eda93.lock)
run: none in flight (no lock at .../repo/.git/work-loop-dispatch-locks/task-96a3c8f2a8deddb7.lock)
```

### The declaration cannot be committed

On the real repository, with **no probe file created** in this live checkout:

```
$ git check-ignore -v logs/work-loop/.owner
.gitignore:46:logs/work-loop/.owner	logs/work-loop/.owner    -> IGNORED
```

Meaningful control — the rule must be specific, not swallow the directory: `git check-ignore -q logs/work-loop/some-task.md` returns non-zero, so task state files in the same directory are **not** ignored. T12 adds the file-level pair inside a sandbox carrying the real `.gitignore`: `git status --porcelain -uall` matched `.owner` **0** times and `git ls-files` tracked it **0** times after `git add -A && git commit`, while the control with the rule removed matched it **1** time. `-uall` is required — git otherwise collapses an untracked directory to `logs/` and would hide the file behind its parent rather than behind the rule.

### Changed and added files

| File | Behavioural change |
|---|---|
| `logs/scripts/work-loop-owner.sh` | **NEW.** The one shared ownership check. `check` / `claim` / `clear`, at `--depth local` (no git at all — Codex's whole enforcement) or `--depth repo` (adds registered-worktree enumeration — Claude and the dispatcher). Verdicts PROCEED / REFUSE / AMBIGUOUS on exits 0 / 3 / 4. Implements the R2 safe state table, including the contradiction, stale-closed-task and unreadable/multi-id rows. |
| `logs/scripts/work-loop-owner.test.sh` | **NEW.** T1–T13 with a falsifiability case 0. Real repositories, real linked worktrees, real lock directories, the real dispatcher. |
| `plans/…/dispatch.sh` | The composite `${TMPDIR}` lock is replaced by **two** locks under the Git common directory — one keyed by task, one by checkout — either of which refuses a second dispatcher, naming the conflict. Pinning now covers both. New admission-time ownership check at repo depth, with exits **33** (refused) and **34** (ambiguous); a checkout without the helper skips it with a visible line. `--status` additionally reports the declaration and the checkout lock. |
| `plans/…/dispatch.test.sh` | Lock paths were reconstructed in six places; all six now route through single `lock_root_for` / `task_lock_for` / `checkout_lock_for` helpers. New case 12b/12c: exclusion across differing `TMPDIR` roots, exclusion of a different task in one checkout with the holder named, release of both locks, and the lock root being inside the repository. |
| `plans/…/README.md` | New section on the two locks and the declaration they do not replace; exit rows 31–34 added (31/32 were implemented but undocumented); `--status` and exit-17 rows corrected; the T1–T13 harness documented; the suite count corrected 375 → 381. |
| `.claude/commands/work-loop-v2.md` | New **Step 1.5** — ownership check at repo depth before executing or committing, with PROCEED / REFUSE / AMBIGUOUS each given an action and AMBIGUOUS explicitly never resolved by claiming. Closing the task and the de-escalation path now clear the declaration in the same write. |
| `.agents/skills/work-loop-v2/SKILL.md` | The isolation policy gains the pre-brief sequence: whoever creates the state file writes `logs/work-loop/.owner` immediately before it, with no git. The narrowed Codex guarantee, the un-prevented cases, and the dormant-task lease are stated as limits. |
| `docs/parallel-sessions-playbook.md` | § 4 records the declaration, that it exists to refuse rather than route, that it is not a registry, and its two limits. |
| `.gitignore` | One rule, `logs/work-loop/.owner`, with the reason it must stay checkout-local. |

Deleted: none. No file in the authorised list was removed.

**Authorised files intentionally left unchanged:** none — every file on the list needed a behaviour or contract change. `.claude/commands/new-worktree-session.md` was excluded by the brief and is untouched, as R2 requires.

**Permanent machinery added:** one helper script and its test; one `.gitignore` rule; one gitignored marker file per checkout with a lifecycle (written at task start, cleared at closure); two lock directories per live run under `<git-common-dir>/work-loop-dispatch-locks/`. **Replaced:** the single composite `${TMPDIR}` lock. **Removed:** nothing — no capability was withdrawn. No registry, branch convention, command, agent, hook, service or second binding was created, and no new worktree-creation authority exists; `/new-worktree-session` remains the only creator and is unmodified.

### Deviations from R2

None material. Reversible implementation choices made and reported: two new exit codes (33, 34) rather than overloading 17, because the remedy differs — 17 means wait, 33 means you are in the wrong checkout; the marker format is one line, `{task-id} {YYYY-MM-DD}`; a checkout lacking the helper skips the dispatcher's check with a visible line, matching the existing session-identity-init precedent; `--status` gained two read-only ownership lines, which is inside the approved surface and is **not** the Codex `--status` widening the operator declined — that remains untouched and Codex-side courier scope is unchanged.

### Remaining limitations

- **Interactive enforcement is instruction-borne.** Only the dispatcher's is exit-code-borne. Two interactive sessions on one checkout for the **same** task are not prevented, and neither is an operator who proceeds past a refusal.
- **Codex enforces the checkout half only.** The cross-checkout half is enforced at the next Claude entry and at dispatcher admission — both before any commit, since Claude makes every commit.
- **An open task leases its checkout until closure.** Starting a different task there is refused until it closes.
- **Measured migration exposure, corrected against R2's estimate.** R2's decision pack anticipated "18 open tasks that are replicated today". Measured from this checkout across 14 live registered worktrees: of the open, non-fixture tasks here, **1 is unique** (`work-loop-v2-concurrent-task-isolation` — this task, which the helper reports PROCEED for) and **1 is replicated across 9 checkouts** (`work-loop-v2-intake-router`, `turn: codex`), which will read AMBIGUOUS everywhere until the operator names its owner. That is the designed refusal, not a regression, but it is a real operational consequence at integration.
- **No `.owner` was created for this live task**, per the brief's exclusion. This task is therefore unclaimed; the helper reports PROCEED for it because its state file is unique to this checkout.
- Actors are stubbed throughout. Real networked Claude/Codex fan-out remains the operator's post-integration validation.

### Rollback, usable after integration

Revert the implementation commit. Nothing survives it: no branch, no worktree, no committed record. Then delete any `logs/work-loop/.owner` files that were created in working checkouts (they are gitignored, so a revert does not remove them) and any residual `<git-common-dir>/work-loop-dispatch-locks/` directory. The dispatcher returns to the composite `${TMPDIR}` lock and its prior exit-code set; the command and skill return to their prior entry text. Partial rollback of the locks alone is possible by reverting `dispatch.sh` only, at the cost of reinstating the proven `${TMPDIR}` defect.

### Deferrals — recorded, not implemented

1. **SKILL.md is 564 lines against a 340-line ceiling** that slice-1 asserts. It was already 543 at `HEAD`; this unit added 21. Fixing it means restructuring the skill, which is outside the authorised scope.
2. **slice-1's `3.1a` allowlist is stale** — 25 names against 56 files. It fails for every task opened since the list was written, independently of this unit.
3. `.claude/hooks/detect-concurrent-session.sh` detects only `native-binary/claude`, so interactive Codex has no observable liveness signal. Adding a Codex pattern would upgrade the accepted reduction; it is a hook change outside scope.
4. **Replicated open task files under `logs/work-loop/` want a cleanup** — specifically `work-loop-v2-intake-router` across 9 checkouts, which will read AMBIGUOUS at integration.
5. The sibling checkouts hold older `dispatch.sh` copies; propagation is an integration concern, and only this bound checkout was changed.
6. `logs/innovation-registry.md` was appended to by a repository hook when `work-loop-v2.md` was edited. It is not in the authorised file list, so it was **not staged**; it remains dirty in the working tree for the operator to decide on.

## Blocker

None.

## Next action

Codex: assess this implementation candidate against the locked R2 scope. It is the single commit on top of base `381559f`, at the tip of `session/2026-08-11-work-loop-ceremony`, unmerged and unpushed.

The assessment questions are whether the implemented behaviour matches the six required outcomes, whether the red-before/green-after evidence supports them, and whether the reported deviations and limitations are acceptable. Independent clean-environment verification (SOP Step B8) has **not** been performed and must not be collapsed into this self-report. Do not read this as resolution of the task or the defect.
