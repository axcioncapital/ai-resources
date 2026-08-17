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

Standard. Discovery mode. Unit 13 — resolve code-zero terminal outcome semantics

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 12 is accepted at `f702c41f5df77078c44fe2bf644f8cf525a7c884`: valid admitted `--dry-run` now finalizes and consumes one exact run-bound result before release, and unprovable publication exits 38 with both leases pinned. Its structurally valid record carries `outcome=UNCLASSIFIED` because the accepted code-zero mapping recognizes only canonical `CLOSED` and `BLOCKED_OPERATOR`; that was explicitly outside Unit 12's schema boundary, but it is load-bearing before the next code-zero terminal site is integrated. Resolve whether the current complete record satisfies Change set A's truthful-outcome contract or whether one bounded vocabulary/semantic change is required; do not edit dispatcher or test code in this discovery unit.

Dominant deliverable: one evidence-backed decision on the truthful code-zero terminal-outcome contract and the smallest next implementation boundary.
Evidence required in this hop: a compact map of every current code-zero terminal class that is or will be an admitted run, the exact outcome/validation facts each carries, a plan-grounded judgment on whether `UNCLASSIFIED` is acceptable or a gap, and exactly one fail-capable next Implementation-mode unit.
Evidence explicitly deferred: every dispatcher and test edit; `--carry-one` integration itself; terminal families A–C and M; `--help` and strictly read-only `--status`; broad schema or semantic-tuple enforcement beyond the conclusion this unit supports; status rendering; resume; crash-boundary recovery; hostile-input and full regression matrices; Change sets B–D; live trials; adoption review; merge, push, deployment, and destructive cleanup.

Named unknown: under the approved Change set A contract, can a known successful dry-run truthfully use `outcome=UNCLASSIFIED` when `mode=dry-run`, code, stage, next action, actor-start facts, and expected identity are otherwise explicit, or must the single v1 outcome vocabulary distinguish this and the coming `--carry-one` success before either path can count toward change-set acceptance?

Governing authority and settled evidence:

- The content-bound-approved plan governs Change set A items 2–8, especially the required truthful `outcome`, the one versioned bounded schema, the exact run-bound producer/consumer path, every-terminal-class acceptance, strict outcome grammar, and § 8's one-production-owner rule.
- Units 5–12 are accepted. Their producer, structural validator, expected-identity validator, consumer, exit-38 pin behavior, operator-terminal outcomes, and dry-run seam are settled implementation evidence and must not be redesigned or broadly re-proved.
- Unit 12's `95/0` focused evidence and M25 control are accepted and must not be rerun. Its `outcome=UNCLASSIFIED` observation is verify-first repository reality, not yet a conclusion about plan compliance.
- Codex's framing decision: this discovery happens before `--carry-one` because knowingly duplicating an unresolved code-zero classification would make a later correction broader. It does not promote the whole deferred semantic-tuple matrix.

Check against the repository:

1. In `dispatch.sh`, inspect the one `result_outcome()` owner, terminal-result producer, structural validator, expected-identity validator, consumer, and current code-zero finalization sites. Establish the exact accepted outcome grammar and what the validators mechanically require rather than inferring semantics from comments.
2. Map the admitted code-zero classes relevant to Change set A: canonical `CLOSED`, canonical `BLOCKED_OPERATOR`, valid `--dry-run`, and the deferred successful `--carry-one` path. For each, show the live `ST_CLASS`, mode, stage, actor/model-start facts, `next_action`, outcome symbol, and whether the result is currently produced and consumed. Keep `--help` and strictly read-only `--status` separate and explain from control flow why they are or are not admitted runs; do not widen into their implementation.
3. Apply the approved plan's truthful-outcome, every-terminal-class, hostile-token, and one-schema requirements to that map. Decide explicitly whether `UNCLASSIFIED` is a truthful final classification, a deliberately honest but temporary fallback that still leaves Change set A unmet, or invalid for a known class. Distinguish structural validity from semantic sufficiency.
4. Determine the smallest next implementation unit supported by the evidence. It must preserve one vocabulary owner and one parser, avoid a second lifecycle reading, and not combine a vocabulary change with `--carry-one` integration unless the evidence shows they are inseparable at one existing production seam.

Required fail-capable evidence:

- cite exact bounded source regions for the outcome mapping, grammar/validator, producer, consumer, and each mapped code-zero terminal site;
- provide one compact table whose entries would differ if `UNCLASSIFIED`, `mode`, `next_action`, or lifecycle class were consumed differently than reported;
- quote the accepted validator behavior that proves what is structurally accepted today and identify the exact plan sentence that settles whether that is semantically sufficient;
- recommend exactly one next Implementation-mode unit with one dominant deliverable, one targeted failing case, exact permitted source/test paths, and explicit deferred work;
- state whether plan § 8's narrow-helper condition is triggered and why, without implementing a helper; and
- report the discovery commit and prove it changes only this task state file. `dispatch.sh`, `dispatch.test.sh`, and `logs/friction-log.md` must remain untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan, accepted Unit 12 state/history, `dispatch.sh`, `dispatch.test.sh`, and directly referenced accepted helper code where necessary; update and locally commit only this task state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: the named unknown is resolved from live repository and approved-plan evidence; the handback distinguishes structural validity from truthful semantic sufficiency; it recommends exactly one properly packaged next implementation unit without changing dispatcher or test code; only this task state changes; and the task returns with `turn: codex`.

Stop and hand back if the approved plan does not determine the semantic bar, the current schema ownership cannot be established from the bounded files, resolving the question requires a material plan or operating-model choice, or any source edit appears necessary to answer it. Challenge the framing rather than guessing or implementing through the uncertainty.

## Latest result

Discovery findings (2026-08-17), all by inspection of the live repository and the approved plan; no dispatcher or test file was touched.

Source regions inspected (`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`): outcome owner `result_outcome()` at 502–536 and next-action owner `result_next_action()` at 542–570 (one vocabulary owner, both keyed on exit code then `ST_CLASS`); producer `finalize_terminal_result()` at 662–783; path gate 913–962; structural validator `validate_terminal_result()` at 964–1086; identity validator 1118–1170; consumer `consume_terminal_result()` at 1863–1880; code-zero terminal sites: dry-run seam 3579 (`# dry-run terminal finalization`), operator terminal 3637 (`# operator terminal finalization`), carry-one exit ~3881–3888 (`release_lock; exit 0`, no finalize/consume). `--status` skips lease acquisition entirely (2336: `[ "$STATUS_MODE" -eq 1 ] || acquire_lock`) and its branch (2346) exits before run evidence is initialized — not an admitted run, so no terminal result is owed, matching plan item 8. `--help` exits inside argument parsing before checkout validation — likewise not admitted.

What the validators mechanically require: the structural validator enforces version-first, exact schema name, the exact produced key set, singleton fields, value length ≤ 512 with no tab/CR, sentinel-last, and swap-detection digests; the identity validator binds task/checkout/run to caller-owned expectations. **Neither constrains the `outcome` value beyond generic value grammar — `outcome=banana` would pass both.** Semantic outcome truth therefore has exactly one owner today: the producer's `result_outcome()` mapping. That is the quoted fact that separates structural validity from semantic sufficiency.

Code-zero terminal map (live probe, sandboxed dry-runs on each state class; fields as consumed by `res_field`):

| Class | ST_CLASS | mode | stage | actor/model | outcome | next_action | produced+consumed? |
|---|---|---|---|---|---|---|---|
| Loop terminal, closed | CLOSED | live | pre-hop* | no/no | COMPLETED | none-task-closed | yes (U8+U10) |
| Loop terminal, blocked | BLOCKED_OPERATOR | live | pre-hop* | no/no | OPERATOR_TAKEOVER | operator-answer-the-blocking-question | yes (U8+U10) |
| Dry-run on active task | ACTIVE_CODEX | dry-run | pre-hop | no/no | UNCLASSIFIED | operator-read-run-log | yes (U12) |
| Dry-run on closed task | CLOSED | dry-run | pre-hop | no/no | COMPLETED | none-task-closed | yes (U12) |
| Dry-run on blocked task | BLOCKED_OPERATOR | dry-run | pre-hop | no/no | OPERATOR_TAKEOVER | operator-answer-the-blocking-question | yes (U12) |
| Carry-one success | any post-hop | live | post-hop | yes/varies | — | — | **no result at all (deferred)** |

*stage is post-hop when a hop ran before the operator terminal. Every row's cells were read from live records (or, for carry-one, from the absence of one); each would differ if outcome, mode, next_action, or lifecycle class were consumed differently than reported.

Judgment on the named unknown: `UNCLASSIFIED` is a deliberately honest fallback, not a lie — but **it leaves Change set A unmet for the dry-run class, and the probe found the sharper defect**: one terminal class yields three different outcome symbols by state class, and on closed/blocked tasks it *borrows the loop terminals' symbols* — a preflight that completed nothing reports `COMPLETED`; a run that took nothing over reports `OPERATOR_TAKEOVER` — with `next_action` misdirecting the same way (`none-task-closed` for a run whose point was to preview a launch). Only `mode=dry-run` distinguishes these records from real loop terminals. The plan sentences that settle the bar: item 4 "The result must truthfully record at least: task, checkout, run, stage, actor, and **outcome**"; item 3's terminal-class list requiring exactly one result per class; and Change-set acceptance "**Every terminal class produces exactly one valid result**" read with § 1's two trustworthy outcomes. A known class whose designated outcome field reports either "no entry" or another class's symbol does not satisfy that bar. Structural validity: intact. Semantic sufficiency: a gap — temporary-honest on active tasks, actively misleading on closed/blocked ones.

Recommended next unit (exactly one, Implementation mode): **truthful mode-derived code-zero classification for the admitted dry-run terminal, inside the single vocabulary owner.** Dominant deliverable: `result_outcome()`/`result_next_action()` classify code-zero by dispatcher-owned `MODE` before `ST_CLASS`, giving every admitted dry-run one class-true outcome symbol (suggest `DRY_RUN_COMPLETE`) and one bounded next-action token (suggest `none-dry-run-preflight-complete`), regardless of the underlying task's state class; loop terminals unchanged. Targeted failing case: the probe above as fixture — dry-run on active shows `UNCLASSIFIED`/`operator-read-run-log`, dry-run on closed shows `COMPLETED`/`none-task-closed`; green shows the one dry-run symbol on all three state classes with 55c's loop-terminal distinction intact; mutation control deletes only the mode branch and the borrowed/fallback symbols return. Permitted paths: `dispatch.sh`, `dispatch.test.sh`, this task state. Explicitly deferred: `--carry-one` integration (its seam does not exist yet — the vocabulary change is separable at the existing production owner, so coupling is not justified) and its future outcome symbol; any validator-side outcome-token whitelist (semantic-tuple enforcement stays deferred); families A–C and M; status rendering. § 8's narrow-helper condition is **not triggered**: the change is one branch inside the existing single production owner, no second parser, no duplicated lifecycle semantics, no pure transition needing extraction.

Discovery commit: this state file's own commit, and it changes only this file. `dispatch.sh`, `dispatch.test.sh`, and `logs/friction-log.md` are untouched; friction-log remains uncommitted with its pre-existing session notes.

## Blocker

None.

## Next action

Codex: assess the discovery — the code-zero map, the borrowed-symbol defect on closed/blocked dry-runs, the UNCLASSIFIED verdict, and the recommended mode-derived vocabulary unit — and decide whether to open that unit as framed, reframe, or stop.
