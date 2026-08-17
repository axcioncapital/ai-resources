---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Discovery mode. Unit 22 — establish untracked foreign-path semantics

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 21 is accepted at `6df2eafd016c5ca7c54268d4a0b4b1981ddf26fe`: all six shared exit-31 paths now reach truthful worktree helpers without moving executable preflight. Its evidence exposed a separate semantic ambiguity: `foreign_worktree()` uses default `git status --porcelain`, which can collapse several untracked files into one directory entry, while its sibling requests `--untracked-files=all`. Before more terminal results rely on this fact, this discovery unit determines whether the current count is truthful under the approved Gate SA contract or requires a bounded correction.

Dominant deliverable: one evidence-backed disposition of the intended and actual semantics of `worktree_foreign_paths` for collapsed untracked directories.
Evidence required in this hop: the complete repository contract and consumer surface for the field; controlled Git examples that distinguish status-entry count from individual-path count; comparison with the allowlisted sibling; and an explicit `CURRENT SEMANTICS TRUTHFUL` or `CORRECTION REQUIRED` conclusion with rationale.
Evidence explicitly deferred: any implementation or regression test arising from the conclusion; separate coverage for Unit 21's five sibling exit-31 call sites; dedicated permission-result rows for other post-hop and between-hop terminals; validator-side outcome-token or semantic-tuple whitelisting; case 50a's planted-lookalike standalone control; remaining terminal families A–C and M; status and resume; crash and hostile-input matrices; Change sets B–D; live trials; adoption review; full synchronous regression gate; merge, push, deployment, and destructive cleanup.

Required outcome:

- Establish exactly what `foreign_worktree()` counts today for modified tracked files, one untracked file, multiple untracked files under one new directory, nested untracked directories, and mixed tracked/untracked foreign effects.
- Establish what the repository currently claims `worktree_foreign_paths` means by tracing its producer, field name, comments, schema text, tests, status/report rendering, plan requirements, and every mechanical consumer. Do not infer an individual-file contract merely from the name, and do not redefine the field to preserve current behavior.
- Compare its semantics with `allowlisted_dirty()`, including why that helper requests `--untracked-files=all`, and determine whether the difference is intentional, incidental, or unsupported by any durable authority.
- Determine the consequence of undercounting individual untracked files, if that is what occurs: whether downstream logic uses only zero/nonzero foreign-work classification or relies on the exact number for validation, routing, takeover, status, recovery, or evidence truthfulness.
- Return one explicit disposition:
  - `CURRENT SEMANTICS TRUTHFUL` only if the best-supported contract is a count of Git status entries and that contract remains honest for Gate SA evidence; or
  - `CORRECTION REQUIRED` if the field claims individual foreign paths, the exact count is mechanically consequential, or the plan's truthful working-tree evidence cannot be met by the collapsed count.
- If correction is required, name the smallest observable implementation outcome and focused evidence for a later unit, without implementing it. If current semantics are truthful, state the wording or interpretation that makes them truthful and identify any non-material naming limitation.
- Change nothing beyond this task state file. Add no helper, parser, test fixture, plan amendment, schema change, or documentation artifact in this discovery unit.

Check against the repository before experimenting:

1. In `dispatch.sh` at Unit 21 commit `6df2eafd…`, verify the exact command pipelines in `foreign_worktree()` and `allowlisted_dirty()`, where their counts enter terminal results, and whether either helper's comments define count semantics.
2. Search the complete checkout for `worktree_foreign_paths`, `foreign_worktree`, `worktree_allowlisted_dirty_paths`, and `allowlisted_dirty`. Classify every hit as producer, schema/presence validation, exact-value consumer, boolean consumer, renderer, fixture, or prose claim; absence claims must name this searched surface.
3. Read only the approved plan sections governing working-tree/changed-path truth, terminal evidence, status and takeover, plus directly cited schema or test contracts. Treat test expectations as repository evidence, not automatically as governing authority.
4. Run controlled experiments in a disposable temporary Git repository or an existing non-mutating fixture surface. Do not dirty or reconfigure this task checkout merely to establish Git's porcelain behavior.

Required fail-capable evidence:

- Quote the exact commands and outputs for each controlled case, including default porcelain and `--untracked-files=all`, so the two candidate semantics produce visibly different counts where applicable.
- Report the full searched surface and every mechanical consumer's use of the value. A conclusion based only on helper implementation or field naming is insufficient.
- Trace the selected semantic conclusion to the strongest available authority and state how the alternative interpretation was rejected. If durable sources conflict or remain tied, hand back the conflict rather than silently choosing.
- If concluding `CURRENT SEMANTICS TRUTHFUL`, show why an untracked directory representing several files does not make the terminal claim false or mechanically misleading. If concluding `CORRECTION REQUIRED`, identify the exact false claim or affected decision and the smallest later repair boundary.
- Report the discovery commit and prove it changes only this task state file. `logs/friction-log.md` remains pre-existing session noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan, Unit 21 evidence, dispatcher and test contracts; run read-only searches and disposable local Git experiments; update and locally commit only this task state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No production edit, external model request or operator-reserved capability is needed.

Completion condition: the actual and intended untracked foreign-path semantics are established from fail-capable experiments, complete consumer tracing and governing authority; one explicit disposition is returned; any later implementation is bounded but not performed; only the state file is committed; and the task returns with `turn: codex`.

Stop and hand back if durable authorities remain materially tied; if resolving the semantics would require changing the approved operating outcome, schema, or Gate SA scope; if the complete consumer surface cannot be established; or if a controlled experiment cannot distinguish the candidate meanings. Challenge a false premise rather than implementing through uncertainty.

## Latest result

Inspected (2026-08-17):

- Claim (1) — helper pipelines, count entry points, comment semantics: HOLDS. `dispatch.sh:2749` runs `git -C "$CHECKOUT" status --porcelain` with no untracked flag; `dispatch.sh:2796` runs the same with `--untracked-files=all`. Both counts enter the terminal record at exactly one place each — `dispatch.sh:787-788` computes `foreign_n`/`dirty_n` via `count_lines()` (`dispatch.sh:682`, `grep -c .`), emitted at `dispatch.sh:834-835`. Neither helper's comment defines a *count* unit, but `foreign_worktree()`'s header at `dispatch.sh:2745-2746` names its output unit explicitly: "Working-tree **lines** NOT covered by the allowlist". `allowlisted_dirty()`'s header at `:2762` calls itself "Working-tree **lines** that ARE covered ... the exact complement".
- Claim (2) — complete consumer surface: HOLDS. Searched the whole checkout excluding `.git` for `worktree_foreign_paths`, `worktree_allowlisted_dirty_paths`, `foreign_worktree`, `allowlisted_dirty`. Classification below under Evidence. No exact-value consumer exists outside the test file.
- Claim (3) — governing plan sections: HOLDS. `work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md:161` requires the terminal result to truthfully record "working-tree and changed-path facts"; `:311` and `:329` require working-tree facts in the handoff and in `--status`. Searched all 480 lines for `worktree|foreign|untracked|changed_paths|working[ -]tree`: **no plan line defines a counting unit** for either field, and none mentions untracked-file expansion.
- Claim (4) — experiments run in disposable repos only: HOLDS. Seven porcelain cases plus four classification/snapshot cases, all in `mktemp -d` repositories. The task checkout was not dirtied or reconfigured; `git status` here is unchanged apart from this state file and the pre-existing `logs/friction-log.md` noise.

Result: **CURRENT SEMANTICS TRUTHFUL.** `worktree_foreign_paths` is a count of Git status *entries* outside the allowlist, not of individual files, and that is the best-supported contract in the repository. It under-counts whenever foreign work sits under a new untracked directory, but it never mis-detects, no mechanical consumer reads the number, and no durable authority states a per-file contract. One non-material naming limitation and one presentational risk are recorded below; neither is a false claim. No correction is required, and none was made — production and tests are byte-for-byte unchanged.

Evidence:

**A. What Git actually does** (disposable repos, `git 2.50.1`, scratchpad script `u22-porcelain.sh`). Default porcelain vs `--untracked-files=all`, entry counts in brackets:

| Case | Real foreign/dirty paths | `--porcelain` | `--porcelain -uall` |
|---|---|---|---|
| 1 — two modified tracked files | 2 | ` M tracked/a.txt`, ` M tracked/b.txt` **[2]** | same **[2]** |
| 2 — one untracked file at root | 1 | `?? loose.txt` **[1]** | same **[1]** |
| 3 — three untracked files, one new dir | 3 | `?? newdir/` **[1]** | three `?? newdir/fN.txt` **[3]** |
| 4 — nested untracked dirs, 3 files, 2 depths | 3 | `?? deep/` **[1]** | three explicit paths **[3]** |
| 5 — mixed: 1 modified tracked + 3 untracked in one dir | 4 | ` M tracked/a.txt`, `?? newdir/` **[2]** | four explicit lines **[4]** |
| 7 — one empty untracked directory | 0 | *(nothing)* **[0]** | *(nothing)* **[0]** |

Cases 3, 4 and 5 make the two candidate semantics produce visibly different numbers, so the experiment could have shown them identical and did not. Tracked modifications (case 1) are never collapsed, and an empty directory (case 7) produces no entry under either flag.

**Case 6 — the delta-blindness boundary.** With `newdir/f1.txt` already untracked, adding `newdir/f2.txt` leaves default porcelain byte-identical (`?? newdir/` before and after → a string-equality delta sees nothing), while `-uall` changes (`?? newdir/f1.txt` → plus `?? newdir/f2.txt`). This is the sharpest possible failure mode for the collapsed reading — **and it cannot arise in a launched hop**, because `dispatch.sh:3814-3815` refuses to launch (`die 18`) whenever `foreign_worktree()` is non-empty, and re-runs that guard before every hop (`:3796`). The before-baseline is therefore always empty, so any foreign directory the actor creates during the hop appears as a new entry and trips `die_hop 24` at `:3913-3917`.

**B. Classification is correct; only the count collapses** (scratchpad script `u22-classify.sh`, faithful copies of both production helpers with the default allowlist `^logs/work-loop/` and `^plans/work-loop-v2-v0\.2/handoff-automation-spike/`):

- *Experiment A* — three untracked files under `logs/work-loop/scratch/`: `foreign_worktree()` → `[]` count 0 (correctly allowed); `allowlisted_dirty()` → 3 explicit lines, count 3. Same three files, two different units, in the two fields that sit on adjacent lines of the record.
- *Experiment B* — three untracked files under a new foreign `newthing/`: `foreign_worktree()` → `?? newthing/`, count **1** against **3** real files; non-empty, so `die 18` / `die_hop 24` both fire. Detection intact, count under-reports.
- *Experiment C — straddle* — an allowlisted path under a wholly untracked ancestor (`logs/` untracked, containing `logs/work-loop/task.md` and `logs/other.md`): default porcelain collapses to `?? logs/`, classified by the **directory** path, so the allowlisted file is counted **foreign**. The failure direction is conservative — it over-reports and stops rather than hiding — and it cannot occur in this checkout under the default allowlist, because `logs/` and `plans/` are tracked. It is reachable only via a custom `--allow-path` whose prefix has an untracked ancestor.

**C. Why the sibling differs — intentional there, incidental here.** `--untracked-files=all` entered at commit `570c4fb0` together with `allowlisted_dirty_snapshot()`, whose commit message states the blob-hash pairing rationale. That helper hashes **each path** (`dispatch.sh:2822`, `git hash-object -- "$p"`). *Experiment D*: `git hash-object -- 'logs/work-loop/scratch/'` → `fatal: Unable to hash`, whereas the explicit file path hashes normally. A collapsed directory entry would resolve to `UNHASHABLE` (`:2823`) and blind the partial-effect delta — the exact O2 failure that helper exists to remove. So `-uall` is **mechanically load-bearing for the sibling only**. `foreign_worktree()` has no per-path consumer, so its default flag is incidental, not a considered decision — and no durable source anywhere states that either helper must count individual files.

**D. Complete searched surface and every consumer.** Whole checkout excluding `.git`; 9 hits for `worktree_foreign_paths`, 5 for `worktree_allowlisted_dirty_paths`, 24 for `foreign_worktree`, 11 for `allowlisted_dirty`. Classified:

- **Producer (exactly one each):** `dispatch.sh:834`, `:835`.
- **Schema / presence validation:** `dispatch.sh:914` `TERMINAL_RESULT_REQUIRED` lists both key names. It is a key-set assertion with **no value grammar** — consistent with Unit 18's finding for `permission_mode_requested`.
- **Exact-value consumers:** two, both in `dispatch.test.sh`. Case 50b `:4910` asserts `= "1"` against a single modified tracked file. Case 50h `:5280-5281` compares both fields against a ground truth read from `git status --porcelain` over `other.txt` and `logs/work-loop/…` — both **tracked modifications**, so that ground truth agrees under either flag and the test is blind to the collapse question. It is not tautological (it reads git, not a literal) but it does not settle this unit.
- **Boolean / whole-string consumers of `foreign_worktree()` — every decision the dispatcher makes:** `:3697` dry-run report `[ -n … ]`; `:3814` pre-launch guard `[ -n … ]` → `die 18`; `:3874` crash-retry safety `[ "$(foreign_worktree)" = "$before_foreign" ]`; `:3913` post-hop violation `[ "$before_foreign" != "$after_foreign" ]` → `die_hop 24`. **None reads the number.**
- **Renderers:** `:3915` prints a `diff` of the two listings; `:3697` and `:3815` print the raw lines. All show paths, none shows a count.
- **Separate program, not a consumer:** `scripts/axcion-harness-v0.2/carry-turn.sh` defines its own `foreign_worktree()` via `worktree_lines foreign` (`:536`), also default porcelain, and emits **no** `worktree_foreign_paths` field (0 hits). It uses only `[ -n ]` and `!=` on the foreign set (`:1362`, `:1565`, `:1700`, `:1719`).
- **Prose claims:** `unattended-operation-plan-v0.2.md:147` ("`foreign_worktree()` reads `git status --porcelain`" — established fact 5, about *committed* changes, not untracked collapse); `bounded-execution-fix-plan-v0.2.md:147`; `dispatch.test.sh:2962`. None asserts a per-file count.

**E. Why the alternative was rejected.** The individual-file reading rests on one thing only: the `_paths` suffix in the field name. The brief forbids inferring the contract from the name, and the repository states the opposite unit twice in the producer's own comments ("Working-tree **lines**") and implements it consistently (`count_lines` counts lines). Against that, all three of the brief's `CORRECTION REQUIRED` triggers fail on the evidence: the field does not *claim* individual paths in any durable source; the exact count is proven not mechanically consequential by the complete consumer trace in D; and the plan's requirement — truthfully recorded working-tree facts — is met, because a count of status entries is a true statement about the working tree. The sources are not tied: a documented statement of the unit outranks an identifier.

**F. The wording that makes it truthful, and the limitation.** Read `worktree_foreign_paths` as *"the number of Git status entries outside the allowlist"*. Under that reading every terminal record this dispatcher has emitted is true. The **non-material naming limitation** is that the suffix `_paths` invites the per-file reading, and nothing in the record itself carries the unit.

One presentational risk is worth Codex's attention because it comes from the evidence rather than from the name, and Experiment A is what exposes it: `worktree_foreign_paths` and `worktree_allowlisted_dirty_paths` are produced on adjacent lines, share a suffix, and are asserted together by case 50h as "both worktree facts" — yet they count in **different units**. Three files in one new directory are `1` on the foreign side and `3` on the allowlisted side. Both numbers are individually true; read as a matched pair they are not comparable, and the record does not say so. This is presentation, not falsity, and no decision turns on it — but if Codex judges operator-facing comparability of that pair to be part of Gate SA's evidence contract, that is a reframing call that belongs to Codex, and it is the one finding that could flip this disposition. I have not treated it as sufficient to flip it myself.

**G. Bounded later repair, named but not performed.** If Codex reframes to `CORRECTION REQUIRED`, the smallest observable outcome is one word added to `dispatch.sh:2749` — `--untracked-files=all` — making both helpers count individual files. Focused evidence would be a new case dirtying a foreign new directory holding three files, red at `worktree_foreign_paths=1` against a `-uall` ground truth of 3, green at 3, with `die 18`/`die_hop 24` behaviour and case 50b/50h unchanged as regression controls. Risk to weigh at that point: `:3874` and `:3913` compare whole listings, so expanding them changes what a retry-safety comparison and a violation diff see — the direction is strictly more sensitive (Case 6's blind spot closes), but it is a behaviour change to the guard, not evidence hygiene alone, and that is why it is not part of this discovery unit.

**H. Commit scope.** Discovery commit changes only this state file. `logs/friction-log.md` was left unstaged as pre-existing session noise; the two scratchpad scripts live outside the repository.

Candidate deferrals recorded, none implemented:

1. The unit mismatch between the two adjacent worktree fields (F above) — a naming or record-level clarification if Codex wants it, not a behaviour change.
2. `carry-turn.sh:1353` counts *allowed* lines with `count_lines` over default-porcelain output, so its `R_PARTIAL` collapses untracked directories the way the dispatcher's allowed side no longer does. Different program, outside this task's scope, recorded so it is not lost.
3. The straddle case (Experiment C) has no test anywhere. It is unreachable under the default allowlist in this checkout and fails conservatively, so it does not warrant a unit on its own.

## Blocker

None.

## Next action

Codex: assess the disposition. The three `CORRECTION REQUIRED` triggers each fail on the evidence, so this returns `CURRENT SEMANTICS TRUTHFUL` with the entry-count wording in F. The one question genuinely open to reframing is whether the differing counting units of the two adjacent worktree fields fall inside Gate SA's operator-facing evidence contract — a judgment I did not make on Codex's behalf. Accept and open the next unit, or reframe to a bounded correction using the repair boundary in G.


