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

Standard. Discovery mode. Unit 36 — resolve the pre-run terminal-result boundary

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Unit 35 is accepted at `f8efcd70d70818a7b749d6bdc9cf76f02f68f7b8` for its dominant discovery: usage and argument refusals exit before `RUN_ID` and therefore cannot reach the accepted terminal-result finalizer. The same report exposed why implementation is not ready to frame yet: some rejected arguments are themselves the values normally used to locate evidence, so the trustworthy pre-run identity and evidence boundary must be established before changing order or adding writes.

Current position: the approved plan is content-bound at `e9a6fd8bc51992a1ce8f6e09dcf95b273dd07240` (plan blob `43c44e01703c8622482d93d80407ddc1c83e038a`) against baseline `2451e3df5b8616e035a39a679799738a975b642e`; Change set A remains in progress after 35 accepted units. Unit 35 established the earliest unmet part of plan § 5 Change set A Required behavior item 3. Codex does not adopt its “five covered” summary: under the discovery brief’s own row-level bar, rows 6–8 are only partially proven because named sibling routes lack fail-capable result assertions. That reclassification does not change the earliest gap, and those proof gaps remain deferred.

Dominant deliverable: establish the smallest plan-compliant identity and evidence boundary that can give usage and argument refusals exactly one durable terminal result without trusting the argument being refused.
Evidence required in this hop: a repository-grounded call-order and trust-boundary adjudication that ends in one bounded implementable seam, or a precise finding that the approved requirement cannot be met inside the current interface and solution envelope.
Evidence explicitly deferred: implementation and tests; lease refusal; result-proof gaps for other terminal classes; other Change set A clauses; the focused-case selector; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.

Required outcome:

- Map the exact data available before, during and after argument parsing: trusted/default evidence root, proposed or validated checkout, task id, requested log directory, permission/runtime options, and the point where `RUN_ID` is currently created. Distinguish absent values from supplied-but-rejected values.
- Enumerate the usage and argument refusal sites by trust condition, not merely exit code. For each condition, state which path values are safe to use, which are untrusted or unavailable, and whether the current terminal-result schema can represent unavailable fields truthfully.
- Determine the earliest safe point at which one dispatcher-owned run identity and external evidence location can exist without writing through an unvalidated user path or weakening argument refusal. Preserve the plan’s single producer/finalizer and one schema; do not propose a second result type, refusal store or lifecycle parser.
- Return one bounded next implementation seam only if repository evidence establishes it. The seam must cover usage and argument refusal as one terminal class, name what production/test surface it would legitimately touch, and state the failing behavior that would precede editing. Do not implement it here.
- If no safe evidence location can exist for a refusal whose checkout or log path is absent or rejected, identify the exact plan/interface conflict and hand back rather than inventing a fallback, silently narrowing the terminal class, or using a rejected path.

Check against the repository:

1. Verify Unit 35’s finding at `f8efcd70…`: all usage/argument refusal exits are before current `RUN_ID` creation and the finalizer’s coverage guard refuses when run identity or evidence location is absent. If that differs, hand back the corrected call order.
2. Inspect the parser defaults, option-processing order, evidence-root canonicalization, schema support for unavailable fields, and existing early-refusal tests in `dispatch.sh` and `dispatch.test.sh`. Bound absence claims to those files and the approved plan; do not search adjacent systems for a new store.
3. Check whether any existing dispatcher-owned safe default evidence root or pre-parse identity primitive already exists and can be reused. Its existence must be proven by the code path, not inferred from test fixtures or later initialization.
4. Treat class 4 lease refusal only as an adjacent constraint sharing the pre-run boundary. Do not solve or combine it with this unit’s class-1 deliverable.

Required fail-capable evidence:

- Return a concise ordered map from process entry through the last usage/argument refusal and current run initialization, citing exact symbols/locations and the trust status of each value at each boundary.
- For every distinct class-1 trust condition, show whether a valid result could be written without consuming the rejected value. Cite the schema fields or guards that make the conclusion fail-capable.
- State exactly one of: `IMPLEMENTABLE SEAM` with the smallest justified implementation boundary and a targeted red that would distinguish success; or `PLAN/INTERFACE CONFLICT` with the precise unmet assumption and why current authorized machinery cannot satisfy it.
- Report inspected commits and paths and confirm no production or test file changed. The only permitted changed path is this task state file; `logs/friction-log.md` remains pre-existing noise and must not be staged or committed.

Capability subset: baseline only — read the approved plan, current dispatcher and focused tests, inspect necessary accepted history, and update/commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, external service, production action or operator-reserved capability is needed.

Completion condition: one committed discovery handback resolves the trustworthy pre-run identity/evidence boundary for usage and argument refusals into one implementable seam or one precise plan/interface conflict, changes no production or test file, and returns the state with `turn: codex`.

Stop and hand back if the only apparent solution trusts a rejected checkout/log path, adds a second durable result mechanism, changes the approved schema ownership, silently excludes any usage/argument refusal, combines lease refusal into the deliverable, or requires an operator-owned scope or architecture decision. Challenge a false premise rather than widening.

## Latest result

Inspected (2026-08-18) — Unit 36, discovery. Inspected at `f8efcd70d70818a7b749d6bdc9cf76f02f68f7b8` (working tree clean of production/test edits). Paths read: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `.../dispatch.test.sh`, `logs/scripts/work-loop-lease.sh`, the approved plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` § 5 Change set A, and `.gitignore`. History inspected: `94b440b2`, `0d9e3355`.

- Claim (1): HOLDS — searched `dispatch.sh` for every exit in the usage/argument family and for the run-identity assignment. `exit 10` at 1455, 1459, 1460, 1461, 1462, 1463, 1465, 1466, 1483, 1493, 3113, 3118; `exit 12` at 1505, 1508, 1540; `exit 11` at 1511, 1512, 1514. `LOG_DIR` defaults at 3112 and `RUN_ID` is created at 3141, so every one of those exits precedes both. None routes through `die()` (1365) — each is a bare `printf … >&2; exit N` — so the die-funnel finalize transfer at 1385 is never reached either. `finalize_terminal_result()` refuses at 769 on `[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ]`. Unit 35's call-order finding stands unchanged; no correction to it is owed.
- Claim (2): HOLDS — searched `dispatch.sh` for the parser and evidence-root surfaces: defaults 297–308, option loop 1435–1457, grammar checks 1459–1494, mode derivation 1496–1499, task-id grammar 1503–1509, checkout validation 1511–1514, `DEFAULT_LOG_DIR`/`STATE_FILE` derivation 1530–1541, lease resolve/init 1680–1699, `acquire_lock` call 2742, read-only `--status` branch 2752–2906, run-evidence block 3112–3143. Schema support for unavailable values exists but is narrow: `tr_kv_or` (529) and the `unavailable`/`none` tokens are present, yet of the 41 required keys listed at 930 only eight use it (`actor`, `turn_at_terminal`, `state_class`, `state_sha256_before`/`_after`, `head_before`/`_after`, `deadline_seconds`, `capture`); `task`, `checkout`, `run`, `state_file`, `run_log`, `lease_task_dir`, `lease_checkout_dir` and `owner_check` are unconditional `tr_kv` (833–874). Searched `dispatch.test.sh` for assertions on codes 10/11/12 — seven found (398, 400, 1158, 3626, 3628, 3713, 4778), every one asserting exit code and message only; searched the same file for any `.result` assertion attached to those cases — no match.
- Claim (3): HOLDS — searched for a dispatcher-owned pre-parse evidence root and identity primitive, and the code path settles both. `SPIKE_DIR` (299) is argument-free, but 1516–1524 records its deliberate abandonment as an evidence root ("Run evidence belongs to the checkout being driven, not to wherever this script happens to sit"), and `runs/` is tracked — `git check-ignore -v` on `runs/x.log` and `runs/x.result` returns no match. `REFUSAL_DIR="$WL_LEASE_ROOT/refusals"` (1785) is a proven pre-`RUN_ID` durable store, but it is derived after `wl_lease_init "$CHECKOUT" "$TASK"` (1694 → `work-loop-lease.sh` 166–177, root = the driven checkout's Git common directory), so it needs the validated checkout. No pre-parse run-identity primitive exists: `RUN_START` (297) is a second-resolution timestamp, which is the exact collision the `RUN_ID` discriminator was added to remove.
- Claim (4): HOLDS — lease refusal (exit 17, `refuse_17` 1849, reached from `acquire_lock` at 2742) appears below only as the adjacent precedent for a durable pre-`RUN_ID` record. It is not solved, combined with class 1, or re-scoped here.

Result: **PLAN/INTERFACE CONFLICT.** No bounded seam can give usage and argument refusal one durable run-bound terminal result inside the current interface and solution envelope, because the class is defined by the absence or refusal of the very values a run-bound result is made of.

Ordered map from process entry to run initialization, with the trust status of each value:

| Boundary | Line(s) | Established and trusted | Absent or untrusted |
|---|---|---|---|
| entry | 287–308 | `set -uo pipefail`, `RUN_START`, `SPIKE_DIR`, option defaults | `CHECKOUT`, `TASK`, `LOG_DIR` all empty |
| option loop | 1435–1457 | nothing new | every assigned value raw from argv, in argv order; unknown token → `exit 10` (1455) |
| grammar checks | 1459–1494 | numeric options and mode-conflict rules settled | `CHECKOUT`/`TASK` still unvalidated strings; `exit 10` sites |
| mode | 1496–1499 | `MODE` (dispatcher-owned) | — |
| task-id grammar | 1503–1509 | after this, `TASK` is trusted | before this, `TASK` may be supplied-but-rejected; `exit 12` |
| checkout validation | 1511–1514 | after this, `CHECKOUT` is canonical, existent, a git checkout | before this, `CHECKOUT` absent or supplied-but-rejected; `exit 11` |
| derived paths | 1530–1541 | `DEFAULT_LOG_DIR`, `STATE_DIR`, `STATE_FILE` | no lease, no `RUN_ID`; `exit 12` at 1540 |
| lease library | 1680–1699 | `WL_LEASE_ROOT`, `WL_LEASE_TASK_DIR`, `WL_LEASE_CHECKOUT_DIR`, hence `REFUSAL_DIR` (1785) | `exit 11` (lease infrastructure — class 4 territory) |
| lease acquisition | 2742 | both leases | `exit 17` (class 4, deferred) |
| run evidence | 3112–3143 | `LOG_DIR`, `LOG_DIR_ABS`, then `RUN_ID` (3141), `RUN_LOG` | `exit 10` at 3113/3118 — still before `RUN_ID` |

Class-1 trust conditions, and whether a valid result could be written without consuming the rejected value:

1. **Argument grammar** (1455, 1459–1466, 1483, 1493 — `exit 10`). `CHECKOUT` absent or unvalidated, `TASK` absent or unvalidated, `LOG_DIR` possibly set from an earlier `--log-dir` and never validated. **No.** Every admitted root is derived from `--checkout`; using the supplied `--log-dir` here is writing through an unvalidated user path.
2. **Rejected task id** (1505, 1508 — `exit 12`). `CHECKOUT` still unvalidated. **No, and doubly so.** 1502 states the reason for the refusal: "Rejected before any path is built, so a hostile id never reaches the filesystem." The accepted artifact path is `$LOG_DIR/$RUN_ID.result` and `RUN_ID` (3141) ends in `-$TASK`, so a run-bound record would put the refused value into a filename — the refusal reason and the evidence path contradict each other.
3. **Rejected checkout** (1511, 1512, 1514 — `exit 11`). `TASK` trusted; `CHECKOUT` nonexistent, unreadable or not a repository, so it yields no Git common directory and no `DEFAULT_LOG_DIR`. **No.** Note also that 1512 assigns before it tests, so a failed canonicalization leaves `CHECKOUT` empty — the record could not even name what was rejected.
4. **State-file escape** (1540 — `exit 12`). `TASK` and `CHECKOUT` both trusted; `DEFAULT_LOG_DIR` derivable. **Yes in principle**, but no lease is held, so writing into the driven working tree here is what 1764–1772 records as the failure that broke the following run at 18.
5. **Log-dir unusable** (3113, 3118 — `exit 10`). Both leases held, `TASK`/`CHECKOUT` trusted, `WL_LEASE_ROOT/refusals` available. **Yes** — but the rejected value here *is* the evidence location, so the record cannot live at the path the plan's producer/consumer pair names.

The precise unmet assumption: plan § 5 Change set A Required behavior item 3 lists "usage or argument refusal" as a terminal class that must atomically finalize one terminal result, while items 1 and 5 define that result as **run-bound** — one run identity plus one external evidence location, consumed over "one exact run-bound producer/consumer evidence path". Every input to both is an argument (`--checkout`, `--task`, `--log-dir`). A refusal of those arguments is by definition the state in which run identity and evidence location cannot be constituted, so under items 1 and 5 as written this class is not merely uncovered — it is uncoverable.

Why the currently authorized machinery cannot close it:

- `DEFAULT_LOG_DIR` (1530) is `$CHECKOUT/…` and `WL_LEASE_ROOT` (`work-loop-lease.sh` 166–177) is the Git common directory of `$CHECKOUT`. Both need the validated checkout that conditions 1–3 lack.
- `SPIKE_DIR` (299) is the only argument-free directory, and 1516–1524 abandons it as an evidence root by an accepted decision; `runs/` is tracked, so records there are working-tree litter.
- A caller-environment root was tried and deliberately removed (`work-loop-lease.sh` 160–165: `TMPDIR` made two runs compute the same key under different parents).
- The consumer settles this independently of any location choice. `consume_terminal_result` (2161) calls `validate_terminal_result_path` and `validate_terminal_result_identity` with `"$TASK" "$CHECKOUT" "$RUN_ID" "$LOG_DIR_ABS"` (2163–2169). For conditions 1–3 three or four of those comparands do not exist, so the accepted producer/consumer pair cannot be run over a class-1 record without a second, weaker identity contract — which the brief and plan § 5 both forbid.
- Even given a location, the record could not be written truthfully today: `task`, `checkout`, `run`, `state_file`, `run_log`, `lease_task_dir`, `lease_checkout_dir` and `owner_check` are unconditional `tr_kv` (833–874) with no `unavailable` fallback.

What is decidable, named but **not** adopted here, because adopting any of it would narrow the class or take an operator-owned decision: (a) re-scope item 3's first bullet to the sub-class that has an admitted root (conditions 4–5) and record the remainder as an accepted limitation; (b) authorize an argument-free evidence root **plus** a run identity not derived from the refused values — that is a new root, a changed `RUN_ID` composition (which `--status` globs at 3139), and a weaker consumer identity contract, i.e. an architecture decision; (c) accept stderr-only evidence for the argument-refusal sub-class and amend item 7 to match.

Deferral noticed and not done (adjacent, not this unit's deliverable): `RUN_ID`'s checkout discriminator is dead. 3141 reads `RUN_ID="$(date '+%Y%m%dT%H%M%S')-${LOCK_KEY:0:8}-$$-$TASK"`, and `LOCK_KEY` is never assigned — `grep -rn 'LOCK_KEY=' --include='*.sh' .` matches only two probe scripts under `runs/probes/`, never `dispatch.sh`; 1706–1708 alias `LOCK_ROOT`/`LOCK_DIR`/`CHECKOUT_LOCK_DIR` from the library but no `LOCK_KEY`, and the library exposes no equivalent. `0d9e3355` both introduced `${LOCK_KEY:0:8}` into `RUN_ID` and removed the assignment, so the field has been empty since it was added. Not fixed here: it is outside this unit's deliverable and belongs to whichever unit touches run-identity composition.

Evidence: fail-capable at each step, and each check could have read the other way.

- Call order: `grep -n 'exit 1[012]\b' dispatch.sh` returns the 18 sites listed above, all with line numbers below 3141; had any sat after it, the claim-1 verdict would have been a corrected call order handed back instead.
- Finalizer guard: line 769 is the literal `[ -n "${RUN_ID:-}" ] && [ -n "${LOG_DIR:-}" ] || return 1`; had it been absent or defaulted, class 1 would already be partially covered.
- Consumer comparands: 2163–2169 pass exactly `"$TASK" "$CHECKOUT" "$RUN_ID" "$LOG_DIR_ABS"`; had the consumer taken fewer, or accepted an `unavailable` comparand, the conflict would not hold.
- Schema fallbacks: 833–874 against the required-key list at 930 — eight `tr_kv_or` calls, thirty-three `tr_kv`. Had `task`/`checkout`/`run` been `tr_kv_or`, the truthfulness objection would have failed.
- Existing early-refusal proof: seven code-only assertions and zero `.result` assertions in `dispatch.test.sh`; a single `.result` assertion on any of them would have contradicted the uncovered finding.
- Evidence-root exclusions: `git check-ignore -v` on `runs/x.log` and `runs/x.result` returns nothing (only `logs/work-loop/.owner` matched, at `.gitignore:50`), so `runs/` really is tracked territory; had it been ignored, option (b) would have been cheaper.
- Dead discriminator: `bash -c 'set -uo pipefail; TASK=demo; printf "%s\n" "$(date "+%Y%m%dT%H%M%S")-${LOCK_KEY:0:8}-$$-$TASK"'` prints `20260818T114719--51274-demo` — the empty field between two dashes. Committed run logs from before `0d9e3355` (`20260811T100947-d571444e-81459-…`) carry a populated field, so the difference is real and not an artifact of the isolated evaluation.

No production or test file changed. `git status --porcelain` shows only this state file plus the pre-existing `logs/friction-log.md` and `logs/work-loop/work-loop-v2-dispatcher-reliable-supervised-use.md` noise; only this state file is staged. No suite was run and the dispatcher was not executed.

## Blocker

None.

## Next action

Codex: assess the Unit 36 discovery. The verdict is `PLAN/INTERFACE CONFLICT` — plan § 5 Change set A item 3's "usage or argument refusal" bullet cannot be satisfied as one run-bound terminal class under items 1 and 5, because every input to run identity and evidence location is an argument this class refuses or lacks. Decide the framing: re-scope the bullet to the sub-class with an admitted root and record the remainder as an accepted limitation; escalate the argument-free-root plus run-identity-composition change to Patrik as an architecture decision; or accept stderr-only evidence for the argument-refusal sub-class. The dead `RUN_ID` discriminator is recorded above as a deferral for whichever unit touches run-identity composition.
