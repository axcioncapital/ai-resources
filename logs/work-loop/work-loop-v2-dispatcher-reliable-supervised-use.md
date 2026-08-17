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

Standard. Implementation mode. Unit 16 — publish the successful carry-one terminal result

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 15 is accepted at `467f3265a75bf66145951dcb7190514dc89dd5d9`. Its four-transition live probe plus a pre-hop control established that successful post-hop `--carry-one` is the remaining code-zero terminal seam that releases its lease and exits without durable result evidence. The accepted semantic contract is one `CARRY_ONE_COMPLETE` outcome for every validated carried hop, with `next_action` derived from the canonical post-hop class so the next actor, closed task, and operator-blocked task remain distinguishable; this unit integrates that one result through the accepted producer/consumer path before release.

Dominant deliverable: the successful carry-one terminal seam finalizes and consumes exactly one truthful `CARRY_ONE_COMPLETE` result before either lease is released.
Evidence required in this hop: one targeted artifact-absence failure before the production edit; the four reachable carry-one transition results; pre-hop operator and dry-run over-fire controls; truthful exit-38 pin behavior when publication is unprovable; one branch-only vocabulary mutation control; and proportionate focused regression plus shell syntax evidence.
Evidence explicitly deferred: validator-side outcome-token or semantic-tuple whitelisting; terminal families A–C and M; status rendering; resume; crash-boundary recovery beyond this seam; hostile-input and full regression matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.
Primary edit begins after: a focused case proves a valid `--carry-one` `claude -> codex` hop exits `0` while no promised terminal-result artifact exists under its evidence root.

Required outcome:

- After all accepted post-hop state, Git, proof, path, ownership, and transition checks succeed, every reachable carried hop publishes and consumes exactly one versioned run-bound result before release and exit.
- The post-hop carry-one result uses `outcome=CARRY_ONE_COMPLETE`, `stage=post-hop`, `actor_launched=yes`, `hop=1`, and the accepted run/task/checkout identity and observed before/after facts.
- `next_action` uses the canonical post-hop class: active Claude and Codex turns receive distinct bounded carry-specific tokens naming the next actor; `CLOSED` keeps `none-task-closed`; `BLOCKED_OPERATOR` keeps `operator-answer-the-blocking-question`.
- The carry-one classification applies only after a model process actually started. A carry-one invocation whose task is already operator-terminal remains the accepted pre-hop `COMPLETED` or `OPERATOR_TAKEOVER` terminal, and `--carry-one --dry-run` remains `DRY_RUN_COMPLETE`.
- Preserve the approved ordering: existing carry report → atomic finalization → exact-result consumption/identity validation → result-path report → release → exit `0`. If finalization or consumption is unprovable, exit `38`, retain both leases, and leave the next dispatcher acquisition refusing `17`.
- Finding F1 is part of this seam's truthfulness: exit-38 messaging must name the carry-one terminal rather than falsely saying the run reached a real operator terminal. Preserve one pin-and-exit owner and the existing operator-terminal default wording. Unit 15's optional context-label parameter is a non-governing implementation recommendation; use the smallest single-owner mechanism supported by the live code and explain any deviation.
- Keep the accepted producer, consumer, structural and identity validators, dry-run and operator-terminal behavior, nonzero vocabulary, and final result schema unchanged. Add no second parser, lifecycle reader, terminal producer, or helper.

Check against the repository before editing:

1. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, verify Unit 15's seam facts still hold: the four transitions pass through the accepted post-hop validation table before the carry-one branch; the canonical validator has refreshed `ST_CLASS`/`ST_TURN`; `CARRY_ONE` and the actor-start fact distinguish post-hop carrying from the pre-hop control; and the accepted finalizer/consumer are callable before release. Hand back if any premise is false.
2. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, add one focused carry-one result case around the existing cases 23–26 and only the fixtures needed for the four transition rows, the two over-fire controls, publication failure, and M27. Do not rerun Unit 14's accepted `102/0` slice as a precondition or build a broad baseline before editing.
3. Verify the selected next-actor tokens satisfy the existing bounded grammar and established vocabulary style. The semantic requirements above govern their meaning; the exact strict spellings are Claude's technical judgment and must be reported.

Required fail-capable evidence:

- Quote the targeted red result before production editing: the valid `claude -> codex` carried hop exits `0` and the expected `*.result` is absent.
- After editing, run the focused carry-one/result slice and report exact pass/fail counts. All four reachable transitions must produce one structurally and identity-valid result with `CARRY_ONE_COMPLETE`, post-hop facts, and their decided next actions.
- Prove the carry-one-over-already-operator control still takes the pre-hop operator terminal and that `--carry-one --dry-run` remains the accepted dry-run terminal.
- With result publication made unprovable only at the carry-one seam, prove exit `38`, both leases pinned, the next acquisition refusing `17`, and truthful carry-one-specific failure wording. Restore the writable path before the green handback.
- M27 removes or bypasses only the new carry-one vocabulary branches; rows 1–2 must return to `UNCLASSIFIED` and rows 3–4 to borrowed lifecycle outcomes while the production edit remains restored and green.
- Run the proportionate shell syntax/static check for both changed shell files. Do not run the broad synchronous Gate SA regression matrix.
- Report the implementation commit and prove it changes only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state file. `logs/friction-log.md` is pre-existing session noise: do not stage or commit it.

Capability subset: baseline only — read/search the approved plan and accepted Unit 15 evidence; edit and locally test only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`; update and locally commit those files plus this task state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: every validated post-hop carry-one success publishes and consumes one truthful `CARRY_ONE_COMPLETE` result before release; next-action distinctions, pre-hop operator and dry-run behavior, and exit-38 lease safety remain truthful; targeted red/green, focused regression, M27, and syntax evidence pass; no second owner/parser/helper, schema expansion, or deferred work enters the unit; only permitted paths are committed; and the task returns with `turn: codex`.

Stop and hand back if the accepted post-hop facts are unavailable at the seam, the existing producer/consumer cannot be reused before release, truthful failure handling requires duplicated terminal logic or a new parser/helper, any accepted dry-run/operator-terminal or lease invariant would change, or the required evidence cannot be made fail-capable. Challenge a false premise rather than widening the unit.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — re-verified every Unit 15 seam fact in `dispatch.sh` before editing. The carry-one branch still sits after the full accepted post-hop region (allowlist delta `3802`, Codex-HEAD guard `3808`, committed-paths guard `3815`, permission denials `3837`, uncommitted/unchanged handback `3846`, byte-identical and unchanged-turn guards `3874`–`3879`, transition table `3881`); `validate_state` at `3795` has refreshed `ST_CLASS`/`ST_TURN` from the canonical validator; `CARRY_ONE` (`311`, `1248`) and `ACTOR_PROCESS_STARTED` (`417`, set only at the single fork `3264`) are both live and dispatcher-owned; and `finalize_terminal_result` / `consume_terminal_result` are callable before `release_lock`. No premise was false.
- Claim (2): HOLDS — searched `dispatch.test.sh` for the carry-one region; cases 23–26 are at `1806`–`1902` and the new case 60 was added after case 59 as a sibling of the other terminal-result cases. Unit 14's accepted slice was not rerun as a precondition and no broad baseline was built before editing.
- Claim (3): HOLDS — inspected the record grammar (`tr_val` bounds to 512 chars and strips newlines/tabs; `validate_terminal_result` `1063`–`1074` enforces `[a-z][a-z0-9_]*=` keys, no tab/CR in values, and key membership only). Outcomes are `UPPER_SNAKE` (`COMPLETED`, `DRY_RUN_COMPLETE`, `OPERATOR_TAKEOVER`), next actions are lowercase-hyphen and prefixed by who must act (`operator-…`, `none-…`, `wait-for-lease-holder`). No validator change is needed for a new value.

Result: **Unit 16 is implemented.** The carry-one terminal seam now finalizes one truthful `CARRY_ONE_COMPLETE` result and consumes it through the accepted path-structure-identity boundary before either lease is released. It was the dispatcher's last successful terminal with no durable evidence, and its only post-hop one.

Six production edits, all inside existing owners:

1. `result_outcome()` — one line inside `0)`, after the dry-run branch: `[ "${CARRY_ONE:-0}" -eq 1 ] && [ "${ACTOR_PROCESS_STARTED:-0}" -eq 1 ] && { printf 'CARRY_ONE_COMPLETE'; return 0; }`.
2. `result_next_action()` — one line in the same position, branching on `ST_CLASS` for the two active classes only; `CLOSED` and `BLOCKED_OPERATOR` fall through to the accepted tokens unchanged.
3. `die_terminal_unprovable()` — optional terminal label as `$1`, defaulting to the wording it already had.
4. `die_terminal_untrusted()` — optional terminal label as `$2` (the refusal token stays `$1`, so every existing caller is unchanged).
5. `consume_terminal_result()` — optional label as `$1`, carried through to all three refusal paths; called with no argument, behaviour is byte-for-byte as accepted.
6. The seam itself — `finalize_terminal_result 0 || die_terminal_unprovable "the carry-one terminal after one carried hop"`, then `consume_terminal_result "…"`, then the result-path line, then the existing `release_lock; exit 0`. The three carry report lines are untouched.

**Token spellings, reported as the brief requires.** `CARRY_ONE_COMPLETE` matches the accepted outcome style. For next action I did **not** use Unit 15's suggested `carry-one-hop-carried-next-turn-<actor>`: every accepted token is prefixed by *who must act*, so the established shape gives `operator-carry-turn-to-claude` and `operator-carry-turn-to-codex`. Same meaning, consistent with the four accepted `operator-…` tokens, and shorter.

Evidence:

- **Targeted red, before any production edit.** `60a — a terminal result exists at the run-bound path` failed on the artifact's absence: `missing …/runs/20260817T155800--70563-carry-pub.result; runs/ holds: …hop1.claude.out …hop1.claude.tree …log`. The focused slice was **129 pass / 19 fail**.
- **Green after the edit: 149 pass / 0 fail** on the same slice (cases 23–26 carry-one behaviour, 55–59 terminal-result/dry-run/vocabulary, and the new 60a–60g). One assertion count more than red because case 60f's mutation control runs its inner check only once its outer guard passes.
- **All four transitions publish one outcome with a distinct next action** (60b): `claude->codex` → `CARRY_ONE_COMPLETE operator-carry-turn-to-codex`; `codex->claude` → `… operator-carry-turn-to-claude`; `claude->operator/CLOSED` → `… none-task-closed`; `codex->operator/BLOCKED` → `… operator-answer-the-blocking-question`. Each is asserted not to be the unmapped fallback.
- **Over-fire controls (60c).** `--carry-one` over an already-operator task still takes the pre-hop terminal: `calls=0`, `COMPLETED / none-task-closed`, `stage=pre-hop`, `actor_launched=no`. `--carry-one --dry-run` still reports `DRY_RUN_COMPLETE / none-dry-run-preflight-complete`, so Unit 14 is unchanged.
- **Unprovable publication (60e).** The actor hands the turn on and then makes the evidence directory refuse new entries. Exit `38`, no result advertised, both leases retained with `terminal result unprovable: … could not finalize`, and the next dispatcher refused `17`. Finding F1 is proven by two assertions on the same output: it does **not** contain `reached a real operator terminal`, and it does name the carry-one terminal.
- **M27 (60f).** Deleting only the two marked vocabulary lines leaves the publication seam intact and parsing, and the borrowed behaviour returns exactly: `claude->codex` becomes `UNCLASSIFIED operator-read-run-log` and `claude->operator/CLOSED` becomes `COMPLETED none-task-closed`. 60b is fail-capable.
- **Single-owner check (60g).** Each of the four markers appears exactly once, and the operator and dry-run seams still carry their own — four separately addressable boundaries.
- **Regression, with a real control.** The full harness ran to case 27d at **240 pass / 0 fail** and did not finish inside the hop; it was terminated, not left running. To cover the untested middle I ran a contiguous cases-28→60 slice against the edited dispatcher (**583/24**) and the same slice against `HEAD`'s dispatcher (**563/43**). The failure sets differ only by my 19 case-60 assertions: every failure under the edit is also present at `HEAD`, so this unit introduces **zero** new failures and fixes 19.
- **Syntax.** `bash -n` clean on both changed files.

The 24 shared failures are not this unit's and are not new: 23 are slice artifacts (cases 30d–30h call `lock_path_for`, defined at `dispatch.test.sh:1997`, outside the slice's range), and one is real — see the deferral below.

Deferrals recorded, not implemented:

- **Case 50c's M1 mutation control is dead at `HEAD`.** Its `sed 's|^  finalize_terminal_result "\$code"$|  :|'` no longer matches: Unit 11 rewrote that line to `finalize_terminal_result "$code" || die_funnel_unprovable "$code" # die funnel failure transfer`. The control reports "the sed matched nothing — the control cannot run", so case 50a's finalization assertion has been unproven since Unit 11, and the full suite is red by one at `HEAD` independently of this unit. Proven by the baseline control run, which fails identically. The fix is one pattern, but it is in the accepted case-50 region and outside this unit's permitted scope.
- **`actor=none` with `actor_launched=yes`** is a combination no accepted terminal produced before this seam. `actor` names the actor *in flight*, and the hop-over line (`3890`) clears it before the carry-one branch by design, so the record is truthful under the field's own meaning — an actor really ran, which `stage=post-hop`, `actor_launched`, `hop` and the capture path all record. Moving the clear would make the record read better and make the signal handler lie about a process group it cannot terminate, so it is not a trade to make inside this unit. The same cause makes `permission_mode_requested` report `none` for a live Claude carried hop. Both are recorded here for Codex to size separately.

Evidence pointer: this handback commit, which changes exactly `dispatch.sh`, `dispatch.test.sh` and this state file. `logs/friction-log.md` is pre-existing session noise and was neither staged nor committed.

## Blocker

None.

## Next action

Codex: assess Unit 16 — the carry-one seam's finalize/consume/release integration, the two reported next-action token spellings (`operator-carry-turn-to-claude` / `-codex`, chosen over Unit 15's suggestion to match the accepted who-must-act prefix), the label-parameter resolution of Finding F1 across the three code-zero seams, and the `129/19` → `149/0` focused proof with the `HEAD`-baseline regression control showing zero new failures. Then decide the next unit, and size the two recorded deferrals — the dead M1 control at case 50c, and the `actor` / `permission_mode_requested` reading at a post-hop seam.
