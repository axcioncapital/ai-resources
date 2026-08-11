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

Standard. Discovery mode. Unit 3 — resolve the blind review's remaining load-bearing evidence gaps with a controlled real-actor concurrency matrix before causal diagnosis or solution design.

Named reason for the loop: the work spans investigation, planning, implementation, and independent assessment; its scope crosses existing concurrency and transport controls and must remain bounded before changes begin.

## Brief

The SOP Gate 2 failure proof and Step B3 blind review are accepted, but they prove admission and visibility gaps rather than actual concurrent-write effects. The blind reviewer identified distinct temporary lock roots and interactive/dispatched overlap as credible unresolved mechanisms that could materially change the intervention. This unit gathers only the evidence needed to distinguish them before Claude builds a causal model.

Required outcome: run one instrumented, non-destructive matrix in a throwaway repository or equivalent isolated fixture using controlled real actor processes where safe. Establish what happens after admission for overlapping and disjoint writes, whether different `TMPDIR` roots bypass the matched-pair lock, and which current surfaces can observe interactive Claude/Codex work alongside dispatched work. Return evidence and stop; do not diagnose a preferred cause, propose an architecture, change production code, or implement the eventual fix.

Authority and accepted context:

- The current operator decision is to address concurrent-session safety now and test automatic task worktree creation/reuse when isolation is required, while retaining human control over task grouping, landing, conflicts, and destructive cleanup.
- Work Loop v2's approved proposal, executable core, and deployed actor resources remain semantic authority. The Repository Problem Resolution SOP supplies the operator-directed structural investigation method.
- Claude's Gate 2 evidence is preserved in commit `7a13a45` at this task path. Codex accepted it without rerunning the probe because the same harness observed refusal for the matched pair while both cross-pair cases launched a second simulated actor.
- The Step B3 blind review was performed by a fresh Codex subagent with zero inherited turns, read-only, and without access to this task file, Claude's candidate explanations, Claude's qualification, the non-governing concurrency investigation, or a previous plan.
- The mid-unit brief rewrite stays in scope. It was a deliberate Codex edit requested by the operator after dispatcher `--status` reported no run in flight while Claude was working interactively; this is accepted raw evidence about a visibility boundary, not proof of accidental corruption.
- Two stale citations in the non-governing concurrency investigation remain out of scope because they do not cause the safety failures.

Accepted blind-review findings:

- Confirmed: the current lock is keyed by canonical physical checkout plus task; the supplied cross-pair probes therefore acquire different locks, and exit 22 occurs after actor launch. This proves admission, not concurrent corruption or data loss.
- Confirmed: task ownership is path-only/manual; no repository-wide task-to-checkout claim was found in the bounded surfaces. Dispatcher status reports only its exact lock.
- Confirmed: the Claude concurrency hook enumerates Claude CLI processes rather than Codex; body identity checks cover `task:` and `turn:` rather than body revision; the registered write hook explains the observed `friction-log.md` changes.
- Unproven: actual cross-worktree logical-task corruption, same-checkout two-task corruption, live-actor collision effects, fan-out above 2, and a causal link to historical loss.
- Credible unresolved explanation: lock storage under `${TMPDIR}` may allow an identical checkout/task pair launched with different temporary roots to bypass exclusivity.
- Credible unresolved explanation: interactive and dispatched work use visibility surfaces that do not represent one another.
- Bounded-versus-structural split: the dispatcher cross-pair admission is a bounded lock-scope defect; cross-tool invisibility and path-only continuity form a broader structural coordination gap. Actual harm frequency and severity remain unproven.

Matrix requirements—keep them proportionate and safe:

1. Recheck the exact current code/line and test surfaces before execution; if the accepted context is false, hand back rather than adapting silently.
2. Use a throwaway clone/repository and task files containing no real work. Do not target this working repository with concurrent writers. Do not push, land, remove a user worktree, modify Git history, or touch user data.
3. Test the matched pair with the same checkout/task under two deliberately distinct temporary lock roots. Include a same-root control. Capture resolved lock paths, keys, launch/refusal result, and actor start evidence.
4. Test the two admitted cross-pairs with controlled real actors: same logical task in two linked worktrees, and two tasks in one physical checkout. For each, include an overlapping-write case and a disjoint-write case where feasible; capture task-file contents, working-tree state, commits/heads if any, dispatcher logs, and the observable handback or conflict result.
5. Test interactive/dispatched overlap for both Claude and Codex to the extent the installed runtimes and safe fixture permit. Capture what dispatcher `--status`, session markers, hooks, process detection, and any other current guard can and cannot see. Do not infer visibility from code inspection alone where safe execution is possible.
6. Preserve a control that current mechanisms correctly refuse, so the matrix can distinguish a failed probe from an admitted run.
7. If a live actor launch would require unsafe authority, network access, destructive behavior, or a new operator decision, stop for the operator and return the safe subset rather than substituting a shape-only grep.

Required evidence returned in `## Latest result`:

- environment and repository-state preservation, exact commands, actual outputs, and confirmation that unrelated work was untouched;
- one compact results table covering each matrix case, expected observation, actual admission/refusal, actual write/handback effect, and which ownership/status surfaces observed it;
- explicit separation of `OBSERVED`, `INFERRED`, and `UNKNOWN`, including whether admission produced overwrite, merge ambiguity, dirty-state stop, harmless isolation, or another effect;
- what the distinct-`TMPDIR` test proved or eliminated;
- what the interactive/dispatched tests proved or could not safely establish for both Claude and Codex;
- which blind-review explanations gained or lost support and what still remains to distinguish before the SOP Step B4 causal model;
- the safe reproduction assets or exact commands needed to turn confirmed failures into later behavior-focused regression tests, without adding them to the repository in this discovery unit.

Completion condition: the matrix supplies enough current behavior evidence to support or block a causal model, then Claude writes the result into this state file, sets `turn: codex`, commits only the state-file handback, and stops. Do not begin Step B4 or implementation in the same turn.

## Latest result

Bounded real-actor concurrency matrix. Evidence only — no causal model, no design, no production change.

### Environment and preservation

`OBSERVED` — worktree `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-work-loop-ceremony`, branch `session/2026-08-11-work-loop-ceremony`, HEAD `7a13a45` (the Gate 2 commit). Working tree carried only ` M logs/friction-log.md` (ambient hook) and this state file. Nothing staged, no in-progress merge/rebase.
`OBSERVED` — every case ran in a `mktemp -d` fixture with its own `git init`. `git worktree list --porcelain` in this repository registers **0** worktrees under any fixture path, and none of the fixture branch names (`probe-*`, `wtbranch`, `sweeptest`, `dirtytest`, `other`) exists here. No push, no landing, no user-worktree removal, no history rewrite.
`OBSERVED` — this repository was never passed as `--checkout`. `main` advanced `0ccf397 → 3fe0603` during the unit; that is another session's commit, not this unit's.
`OBSERVED` — runtimes are installed (`claude`, `codex` both on PATH), but **no live model actor was launched**. All actors ran through `--actor-cmd`, i.e. real OS processes performing real writes and real `git add`/`git commit`, without model authority or network. This is the requirement-7 safe subset; see § What could not be established safely.

### Pre-execution recheck (requirement 1)

`OBSERVED` — all accepted context holds: `dispatch.sh:484` `LOCK_KEY="$(printf '%s|%s' "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"`; **`dispatch.sh:485` `LOCK_DIR="${TMPDIR:-/tmp}/work-loop-dispatch-$LOCK_KEY.lock"`**; `detect-concurrent-session.sh:89` `CC_PROCESS_PATTERN="${CC_PROCESS_PATTERN:-native-binary/claude}"`; `log-write-activity.sh:7` targets `$PROJECT_DIR/logs/friction-log.md`; default allowlist at `dispatch.sh:317` is `('^logs/work-loop/' '^plans/work-loop-v2-v0\.2/handoff-automation-spike/')`. Nothing was false; no hand-back required.

### Results matrix

| # | Case | Expected | Admission | Actual write / handback effect | Which surface saw it |
|---|---|---|---|---|---|
| M1a | same checkout+task, **same** `TMPDIR` (control) | refuse | **refused, exit 17** | 1 actor started | lock |
| M1b | same checkout+task, **different** `TMPDIR` | refuse | **admitted, exit 22** | **2 actors started** | none |
| M2 | same task, two linked worktrees, overlapping write | — | both admitted, exit 23 each | two divergent committed state files; later merge → **CONFLICT (content)** | only the merge, later |
| M3a | two tasks, one checkout, clean start | — | both admitted (24 / 23) | commit titled "XWRITER wrote taskx" contains **only `tasky.md`**; `taskx.md` left uncommitted | exit 24, **misattributed** |
| M3b | two tasks, one checkout, prefix commit | — | both admitted (25 / 23) | one task's run committed the other's **half-written** file | exit 25, **misattributed** |
| M3c | second task, dirt **outside** allowlist | refuse | **refused, exit 18** | nothing launched | foreign-path guard |
| M3d | second task, dirt **inside** `^logs/work-loop/` | ? | **admitted, exit 23** | other task's dirty file still dirty afterwards | none |
| M5-C2 | live **Codex-shaped** process, cwd in folder | see it | — | hook: machine-wide 25, **in-folder 0** | none |
| M5-C3 | live **Claude-shaped** process, cwd in folder (control) | see it | — | hook: machine-wide 26, **in-folder 1** | concurrency hook |
| M6 | session marker across worktrees | — | — | visible in its own checkout (1), **not** from the linked worktree (0) | none |

### What the distinct-`TMPDIR` test proved

`OBSERVED` — the lock **key** was identical in all three M1 runs (`27b2db957c62b13a`); only the directory differed. Same checkout, same task, same key: with one `TMPDIR` the second dispatcher was refused (`STOP [17] another dispatcher holds taskx`, 1 actor started); with two `TMPDIR` roots the second was admitted (exit 22) and **both actors started**.
`OBSERVED` — the same blind spot reaches the status surface. `--status` for the running task from the *holder's* root reported `run: IN FLIGHT — dispatcher pid 77944 holds …`; the identical query from the other root reported `run: none in flight (no lock at …/tmp2/…)` **while the run was live**.
`INFERRED` — exclusivity therefore depends on an ambient environment variable rather than on the task or the checkout. This eliminates "the matched pair is safely serialised" as an unqualified statement: it is serialised only among dispatchers that happen to share a `TMPDIR`.
`UNKNOWN` — whether any real invocation path has ever supplied a differing `TMPDIR`. Not tested; the blind reviewer raised it as a mechanism and the mechanism is now demonstrated, not its field frequency.

### What admission actually produced

`OBSERVED` — **merge ambiguity, not silent overwrite (M2).** Two worktrees each committed their own copy of one logical task's file on their own branch (`7c08ab6` on main, `f6bf271` on `wtbranch`). Git refused nothing during the run. The cost appeared only at landing: `merge exit 1`, `CONFLICT (content): Merge conflict in logs/work-loop/taskx.md`. The merge was aborted and the fixture restored.
`OBSERVED` — **cross-task commit contamination, not merge ambiguity (M3a).** In one checkout, the commit whose message reads `XWRITER wrote taskx` contains exactly one file: `logs/work-loop/tasky.md`. `taskx.md` remained modified-uncommitted. Both actors staged by explicit pathspec; they shared one index.
`OBSERVED` — **another task's half-written file committed (M3b).** `tasky`'s actor ran `git add logs/work-loop/`; its commit carried `taskx.md` (2 lines changed) alongside `tasky.md`, while `taskx`'s own dispatcher ended at exit 25.
`OBSERVED` — **the guards fire but explain wrongly.** M3a's stop reads `STOP [24] Codex moved HEAD (7c08ab6… -> 87b6b46…) — Codex never runs git (core § 4)`; the hop was indeed a `codex` hop (`hop=1 actor=codex`), but HEAD was moved by the concurrently dispatched **`tasky` Claude actor** in the same checkout, not by Codex. M3b's stop reads `STOP [25] … a previous run died between editing and committing, or its commit was refused` — in fact another task's run committed the file.
`INFERRED` — an operator following either message would investigate the named actor rather than the concurrent writer that caused it.
`OBSERVED` — **the existing guard is a real partial mitigation, bounded by the allowlist prefix.** Dirt outside the allowlist refused the second task (exit 18). The same experiment with the dirt *inside* `^logs/work-loop/` admitted it (exit 23), because both tasks' state files live under that one allowed prefix.

### Interactive / dispatched visibility, both tools

`OBSERVED` — with a live **Codex-shaped** process whose kernel cwd was the fixture, the real hook reported `0 in this folder`. With a live **Claude-shaped** process at the same cwd it reported `1 in this folder` and the machine-wide count rose 25 → 26. The control establishes the detector can see in-folder work, so the Codex zero is genuine blindness rather than a failed probe.
`OBSERVED` — `--status` for a *different* task in a checkout with a live dispatched run reported `run: none in flight`, naming only its own lock path. No surface reported the other writer.
`OBSERVED` — a session marker written in one checkout was not visible from a linked worktree (1 vs 0); `git check-ignore` confirms `.gitignore:39 logs/.session-marker-*`.
`OBSERVED` — the hook auto-pruned a marker with no matching live process, reporting `Cleaned 1 stale session marker(s)`.
`UNKNOWN` — behaviour of the real `claude`/`codex` runtimes under these shapes. Not launched; see below.

### Blind-review explanations: what gained and lost support

- **Gained — `TMPDIR` lock-root bypass.** Raised as credible; now demonstrated (M1b) with a passing same-root control.
- **Gained — interactive and dispatched surfaces do not represent one another.** Demonstrated three ways: cross-tool process blindness (M5), per-task status blindness (M4b), per-worktree markers (M6).
- **Lost, as stated — "cross-worktree logical-task corruption".** Not observed. Two worktrees produced clean divergence plus a deferred merge conflict, which is a landing cost, not corruption (M2).
- **Gained, and stronger than stated — "same-checkout two-task corruption".** Observed directly: a commit carrying only the other task's file (M3a) and a commit carrying another task's half-written file (M3b).
- **New, not in the blind review — misattributed guard diagnostics.** Exits 24 and 25 fired correctly but named the wrong cause.
- **Unchanged — fan-out above 2, and any causal link to historical loss.** Still `UNKNOWN`; neither was tested.

### What could not be established safely (requirement 7)

`OBSERVED` — no live `claude -p` or `codex exec` actor was launched. Doing so would require model authority and network access for processes writing inside a fixture, which requirement 7 names as a stop rather than something to substitute. Actors were therefore real processes performing real Git writes, which is what establishes the write effects above; what remains untested is whether a **model** actor's own commit discipline changes them.
`UNKNOWN` — fan-out above 2; real-world frequency and severity; whether any recorded incident traces to these mechanisms.

### Reproduction assets (retained outside the repository)

Under the session scratchpad, not added to the repository in this discovery unit:
- `matrix-a.sh` — M1 `TMPDIR` bypass with same-root control, and the `--status` visibility probes. Would become a behaviour case asserting a second dispatcher is refused **regardless of `TMPDIR`**.
- `matrix-b.sh` — M2/M3 with real writing actors, including the merge-conflict demonstration and the commit-contamination checks. Would become behaviour cases asserting no commit contains another task's file.
- `matrix-c2.sh` — cross-tool visibility with the Claude-shaped falsifiability control. Would become a case asserting a live neighbour of either tool is visible in-folder.

Each is re-runnable and builds its own throwaway repository; none targets a real checkout.

## Blocker

None.

## Next action

Codex: assess the matrix and decide whether the evidence now supports opening SOP Step B4 (causal model and structural options), or whether a further evidence unit is needed first. Four things bear on that decision:

1. **A mechanism outside the accepted context was demonstrated.** The `TMPDIR` lock-root bypass (M1b) defeats exclusivity for the *matched* checkout+task pair, which the Gate 2 record and the blind review both treated as the one case already closed. `--status` shares the blind spot.
2. **The two admitted cross-pairs produce different effects, not one.** Two worktrees give clean divergence plus a deferred merge conflict; one checkout gives cross-task commit contamination. Any causal model that treats them as one failure will fit only one of them.
3. **The guards misattribute.** Exits 24 and 25 fired correctly and named the wrong cause. Whether that belongs in this task's scope or is a separate defect is a scope decision, not a Claude call.
4. **The safe subset stopped short of live model actors** (requirement 7). If B4 needs evidence that a real `claude`/`codex` actor behaves as the shell actors did, that is a new operator decision about authority and network, not something to assume.

No causal model, ranking or intervention is proposed here, so this result remains usable as raw evidence.
