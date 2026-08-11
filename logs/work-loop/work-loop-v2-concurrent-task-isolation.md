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

**Correction round — findings 1–4 addressed.** Scope was frozen to those four. Nothing else was implemented; what was newly noticed is recorded as a candidate deferral below.

### The frozen findings, reproduced before correcting

Each was reproduced by inspection on the pre-correction tree (`8a24480`) before anything was changed. A finding that did not reproduce would have been handed back as exactly that; all four reproduced.

- **Finding (1) fail-open admission: REPRODUCED** — read `.claude/commands/work-loop-v2.md:171`, which read "If the helper is not present in this checkout, say so in one line and continue. An absent helper is not a refusal." Read `dispatch.sh:1933-1935`, whose `else` branch was `say "ownership: SKIPPED …"` with no `die`. Measured end to end: the old dispatcher against a checkout with the helper removed printed `ownership: SKIPPED — …/logs/scripts/work-loop-owner.sh is not present in this checkout; no declaration was read or written.` and **exited 0 with the actor launched**.
- **Finding (2) malformed declarations: REPRODUCED** — against the old helper, `alpha beta gamma 2026-99-99 junk`, `alpha not-a-date` and a bare `alpha` each returned `REFUSE … claimed by open task 'alpha'`, i.e. field 1 was accepted as a valid holder. `clear --task beta` on a two-line declaration returned `PROCEED — cleared the declaration` and **the file was destroyed**, where R2 requires AMBIGUOUS and preservation.
- **Finding (3) non-atomic claim: REPRODUCED** — 10 contested rounds, two simultaneous `claim` calls for different tasks on one free checkout: **10/10 rounds returned PROCEED to both**, with the final declaration naming whichever rename landed last (`beta` 7 times, `alpha` 3).
- **Finding (4) mutable candidate identity: REPRODUCED** — the previous `### Starting state` block named only base `381559f` and "the tip of this branch", and stated the implementation hash was "deliberately not written here as a literal hash". No immutable identity was recorded.

Result: **findings 1, 2 and 3 are corrected in code with red-before/green-after regression coverage; finding 4 is resolved by this handback's commit structure. The result is an implementation candidate for independent verification (SOP Step B8). It is not a claim that the task or the defect is resolved.**

### Candidate identity — immutable (finding 4)

| | |
|---|---|
| Base | `381559f` |
| **Corrected implementation-candidate tip** | **`94807fde27ed05abd7b239328ee89fd8320dfc25`** (`94807fd`) |
| **Candidate range** | **`381559f..94807fd`** — two commits: `8a24480` (original candidate) and `94807fd` (this correction) |
| State-file handback commit | a **separate**, state-file-only commit whose parent is `94807fd`. It carries no code and is **outside** the candidate range above. |

Review attaches to `381559f..94807fd`. No branch name and no `HEAD` is candidate identity. This file's own commit hash is necessarily absent from this file — a commit cannot contain its own hash — which is exactly why the code correction was committed first and named here by hash; resolve the handback commit as the child of `94807fd` on this branch.

Unmerged and unpushed. Verify with `git log --oneline 381559f..94807fd`, which returns exactly those two commits.

### Evidence — red before, green after

The correction's own cases are run against the **pre-correction scripts extracted from `8a24480`** (`git show HEAD:…`), which is what makes them capable of failing.

| Suite | Against the pre-correction scripts | After the correction |
|---|---|---|
| `logs/scripts/work-loop-owner.test.sh` | exit 1 — **80 passed, 13 failed** | exit 0 — **92 passed, 0 failed** |
| `plans/…/dispatch.test.sh` | exit 1 — **pass=385 fail=4** | exit 0 — **pass=389 fail=0** |
| `logs/scripts/work-loop-v2-core-resolver.test.sh` | — | exit 0 — 4 passed, 0 failed |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | — | exit 1 — 292 passed, **3 failed, pre-existing** |

**Every one of the 13 red cases is in F1–F3, and every T1–T13 case passed on the pre-correction scripts.** That separation is the point: the new cases measure the correction, and the existing matrix was not re-tuned to fit it. The 13th red is a per-round assertion inside F3's loop that fires only on failure, which is why green is 92 rather than 93.

The named red cases:

```
F1  FAIL  the dispatcher REFUSES a checkout with no helper
F2  FAIL  extra token / second id on the line
F2  FAIL  a bare id with no date at all
F2  FAIL  a date that is not a date
F2  FAIL  a date-shaped value out of range
F2  FAIL  clear REFUSES a malformed declaration as AMBIGUOUS
F2  FAIL  clear did not delete the malformed declaration
F2  FAIL  clear left the malformed declaration byte-for-byte unchanged
F2  FAIL  claim REFUSES on a malformed declaration
F2  FAIL  claim left the malformed declaration unchanged
F2  FAIL  a malformed marker in ANOTHER checkout does not claim this task
F3  FAIL  round 2 — the declaration names the winner
F3  FAIL  no round admitted two writers
```

Dispatcher case 12d, against the pre-correction dispatcher — **both controls passed in the same run**, so the four reds are the behaviour and not the harness:

```
pass=385 fail=4
  FAIL  an ABSENT ownership helper refuses with exit 35     (got 0, actor launched)
  FAIL  the refusal says the check could not run
  FAIL  no actor was launched with the check unavailable
  FAIL  a BROKEN ownership helper refuses with exit 35 too  (got 33)
  PASS  control — with the helper present the same run proceeds
  PASS  control — the actor did run once the check was available
```

### Generated output — the corrected path, end to end

Real repository, two linked worktrees, two tasks, concurrent dispatchers, **different `TMPDIR` roots**, real helper, actors stubbed:

```
alpha-claim: verdict: PROCEED  reason: claimed …/wt-alpha for task 'fanout-alpha'
beta-claim:  verdict: PROCEED  reason: claimed …/wt-beta  for task 'fanout-beta'
alpha exit=0   beta exit=0
ownership: PROCEED — this checkout already declares task 'fanout-beta'; task 'fanout-beta' is declared by this checkout; the later handoff reuses it
ownership: PROCEED — this checkout already declares task 'fanout-alpha'; task 'fanout-alpha' is declared by this checkout; the later handoff reuses it
```

Refusal, ambiguity and the new fail-closed path on that same fixture:

```
=== the same task entered from a second checkout ===
exit=3  REFUSE — task 'fanout-alpha' is already claimed by checkout …/wt-alpha — continue the task there, or close it first

=== a malformed declaration (`fanout-beta fanout-ghost 2026-08-11`) ===
check exit=4  AMBIGUOUS — …/.owner is unreadable or holds more than one task id — no checkout may claim on this evidence
clear exit=4  AMBIGUOUS — it is left exactly as it is, and nothing was removed; the operator names the owner
marker after clear: [fanout-beta fanout-ghost 2026-08-11]        <- preserved, byte for byte
dispatcher    exit=34  STOP [34] ownership is AMBIGUOUS for task fanout-beta in …/wt-beta

=== the ownership check unavailable in this checkout ===
exit=35
STOP [35] the ownership check is unavailable: …/wt-beta/logs/scripts/work-loop-owner.sh is missing or unreadable in …/wt-beta
Recoverable next action: ownership cannot be established without it, so nothing was launched and nothing was committed. Copy the helper into this checkout — or run the task in a checkout that carries it — then re-run.
actor output present? 0 occurrences
```

The last line is the measurement that matters: the actor's own marker string appears **zero** times, so nothing launched.

### The declaration and the new lock cannot be committed

`.owner` is unchanged from the previous unit — `git check-ignore -v logs/work-loop/.owner` → `.gitignore:46`, with `logs/work-loop/some-task.md` **not** ignored as the specificity control.

The mutation lock needed **no** `.gitignore` rule, which is why it was chosen: it is an always-empty directory, and git does not track directories. Asserted rather than assumed — F3 creates `logs/work-loop/.owner.lock` and runs `git status --porcelain -uall -- logs/work-loop/`, which matches it **0** times. `.gitignore` is therefore untouched by this correction and remains the single `.owner` rule the brief authorised.

### Changed files

| File | Behavioural change |
|---|---|
| `logs/scripts/work-loop-owner.sh` | `marker_holder()` takes a path and enforces the one legal shape — exactly one non-empty line, exactly two fields, a valid task id, and a `YYYY-MM-DD` date whose month and day are in range. Anything else is `?`. `clear` on `?` now returns AMBIGUOUS and **removes nothing**; it used to delete. `claim` and `clear` run inside a `mkdir`-based lock at `logs/work-loop/.owner.lock`, and `claim` now decides *and* writes inside that section. The duplicate inline marker reader in `check_repo()` was deleted in favour of the shared one. |
| `logs/scripts/work-loop-owner.test.sh` | F1–F3 added: an unavailable check is distinguishable from a clean one (helper *and* dispatcher halves, with a positive control); five malformed shapes are AMBIGUOUS and survive `check`, `claim` and `clear`, with the legal shape as control and a cross-checkout case for the deleted second reader; six contested concurrent rounds asserting one winner, no deadlock, the declaration naming the winner, no git, lock release, and the lock's invisibility to git. |
| `plans/…/dispatch.sh` | Ownership admission **fails closed**: a missing or unreadable helper, or one exiting outside `0/3/4`, is now **exit 35** with nothing launched. It used to print `ownership: SKIPPED` and run. New exit code 35 documented in the table; the 33 row now points at it. |
| `plans/…/dispatch.test.sh` | `new_sandbox()` installs the ownership helper, because a sandbox without it no longer models a real checkout. New case 12d: absent helper and broken helper both refuse with 35 and launch no actor and make no commit, with an independent-sandbox positive control. |
| `plans/…/README.md` | The "skips the check with a visible line" claim is replaced by the fail-closed rule and why it differs from the session-identity init; exit row 35 added; the 33 row corrected; F1–F3 documented; suite count 381 → 389. |
| `.claude/commands/work-loop-v2.md` | Step 1.5's closing line inverted: a check that cannot run is now a stop for the operator, not a one-line note and continue. |
| `docs/parallel-sessions-playbook.md` | § 4 records the declaration's exact legal shape, that a malformed one is left in place rather than tidied away, and that the check fails closed. |

**Authorised files intentionally left unchanged this round:**

- `.agents/skills/work-loop-v2/SKILL.md` — it **already** specified `{task-id} {YYYY-MM-DD}`, one line (`:181`) and "unreadable, or holding more than one id — refuse and report. Do not guess" (`:184`). Finding 2 was the code failing to enforce what this file already said, so the fix belonged entirely in the helper. Leaving it also avoids adding lines to a file already over its slice-1 ceiling.
- `.gitignore` — the lock needs no rule (see above), and `.owner`'s rule is already correct.
- `.claude/commands/new-worktree-session.md` — excluded by the brief; untouched.

Deleted: none.

**Permanent machinery added:** one `mkdir`-based mutation lock directory per checkout, created and removed inside a single `claim`/`clear` call. **Replaced:** the fail-open ownership skip on both entry surfaces; the permissive marker reader; the check-then-write claim. **Removed:** the duplicate inline marker reader in `check_repo()`. No registry, command, agent, hook, service, second binding or new worktree-creation authority was created.

### Did the correction break previously passing behaviour?

**No.** All T1–T13 still pass, and the dispatcher suite went 381 → 389 with no case lost. The slice-1 suite is unchanged at 292 passed / 3 failed, and the three failures are identical in count and identity to the pre-correction baseline (`3.1a` twice, `ridx` once). SKILL.md is **564 lines, unchanged by this round** — the ceiling breach was not worsened.

One honest limitation on the concurrency evidence: F3 is a **probabilistic** regression. Six contested rounds fail the pre-correction implementation reliably (10/10 in the standalone reproduction, and it went red here on the first run), but a scheduler that serialised every round would let it pass green against broken code. It is a real failing case, not a guaranteed one.

### Deferrals — recorded, not implemented

Carried forward from the previous unit, all still open and all outside the frozen scope:

1. **SKILL.md is 564 lines against slice-1's 340-line ceiling.** Pre-existing; unchanged by this round.
2. **slice-1's `3.1a` allowlist is stale** — 25 names against 56 files.
3. `.claude/hooks/detect-concurrent-session.sh` detects only `native-binary/claude`, so interactive Codex has no observable liveness signal.
4. **Replicated open task files** — `work-loop-v2-intake-router` across 9 checkouts will read AMBIGUOUS at integration.
5. Sibling checkouts hold older `dispatch.sh` copies; propagation is an integration concern. **This correction raises its consequence:** with admission now failing closed, a sibling that lacks `logs/scripts/work-loop-owner.sh` will be refused with exit 35 rather than skipped. That is the intended behaviour, and it makes propagating the helper part of integration rather than optional.
6. `logs/innovation-registry.md` and `logs/friction-log.md` are hook-written and dirty in the working tree; not authorised, so **not staged**.

Newly noticed during this correction, recorded and not implemented:

7. **A malformed declaration in *another* checkout names nobody and is skipped by the cross-checkout half.** The local half refuses on it, so the checkout standing on the damaged file is stopped; but a corrupt sibling marker does not make other tasks ambiguous. Treating it as repository-wide ambiguity would refuse work everywhere for one file the operator can fix in one place. Deliberate and commented at the call site — recorded so the trade-off is visible rather than assumed.
8. **The mutation lock has a one-minute staleness takeover.** An abandoned lock (a process killed mid-claim) is reclaimed after 60s by `rmdir`, which can only succeed while the directory is empty. Bounded and safe, but it is a timeout, and timeouts are worth a look under independent verification.

## Blocker

None.

## Next action

Closure check on the frozen findings only. Two questions:

1. Are findings 1–4 resolved? Finding 1 — an ownership check that cannot run refuses on both supported entry surfaces (`dispatch.sh` exit 35 with nothing launched; Step 1.5 stops for the operator), with tests proving no actor launches and no commit occurs. Finding 2 — the declaration's exact format is enforced, and `check`, `claim` and `clear` all leave a malformed declaration untouched with an ambiguous verdict. Finding 3 — a contested local claim is indivisible via a `mkdir` lock needing no git, with a concurrent regression that fails the previous implementation. Finding 4 — the candidate is frozen at `94807fd`, range `381559f..94807fd`, with this state-file handback as a separate commit outside that range.
2. Did the correction break something? Reported above: no. T1–T13 unchanged, dispatcher 381 → 389 with no case lost, slice-1's three failures identical to baseline, SKILL.md line count unchanged.

Anything newly noticed at the closure check is a deferral, not a second correction round. If findings 1–4 are resolved, the next unit is SOP Step B8 — independent clean-environment verification of `381559f..94807fd`, which must not be collapsed into this self-report.
