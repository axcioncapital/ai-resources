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

Standard. Discovery mode. Unit 4 — locate the trusted terminal-result seam.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A is now the active plan phase: Unit 3 is accepted at `d03dc5d6045444eb0042ac6ff214ee076dc778e3`, the plan is active and content-bound approved, and no dispatcher implementation has begun. Change set A requires one trusted run and result boundary, while the current dispatcher visibly contains several terminal mechanisms whose exact ownership must be established before the first safe edit can be bounded. Inspect only that live seam and return the smallest justified first implementation unit; do not change dispatcher or test code in this discovery unit.

Dominant deliverable: an evidence-backed identification of the single production seam and first bounded implementation unit for Change set A's trusted terminal-result boundary.
Evidence required in this hop: the handback maps the current terminal families and field availability sufficiently to show where one versioned atomic result producer can own them, and states one fail-capable first implementation completion condition.
Evidence explicitly deferred: all dispatcher and test edits, terminal-path migration, Change sets B–D, live trials, Gate SA regression, independent adoption review, the `$diagnose-and-fix`/`$realign` routing migration, merge, push, deployment, and destructive cleanup.

Named unknown: what is the smallest existing dispatcher seam that can own one versioned, run-bound, atomically finalized terminal-result contract without adding a second lifecycle parser or combining a shared primitive, its first consumer, and a broad regression matrix in one implementation unit?

Governing authority and source disposition:

- The active plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md`, approved through the binding recorded at handback `d03dc5d6045444eb0042ac6ff214ee076dc778e3`, governs. Change set A and Gate SA are the execution boundary; §§ 4 and 7 exclusions remain binding.
- The live dispatcher `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and its focused controller suite `dispatch.test.sh` are verify-first repository reality, not presumed architecture. Inspect their current bytes and report what they actually centralize.
- Unit 3's `22/0` narrow approval-record check and twelve red mutations are accepted evidence and must not be rerun. The activation baseline suites are also settled and must not be rerun in this discovery unit.
- Historical run captures, source rationale, adjacent routing defects, and Gate ST/U material are non-governing and outside this unit unless one exact citation in the two inspected files is necessary to interpret a live code path.

Check against the repository:

1. In `dispatch.sh`, identify the current run-identity and evidence-initialization boundary, each distinct terminal-exit family, and the functions or direct exits that own them. The inventory must cover every terminal family in this one production file because a missed family could bypass the future single result producer; group equivalent call sites rather than producing a line-by-line diary.
2. For each family, establish which required Change set A facts are available at that point: task, checkout, run, stage, actor, whether a model request started, state and HEAD before/after, working-tree or changed-path facts, permission mode, hop/deadline/usage facts, capture/log paths, and owner/lease status. Mark unavailable facts as unavailable rather than proposing reconstruction.
3. In `dispatch.test.sh`, identify the narrowest existing fixture boundary capable of proving atomic single-finalization, schema/version rejection, missing-result blocking, and fake-result separation. State what genuinely requires a new focused fixture; do not design or run the full Gate SA matrix.
4. Determine whether the first implementation can stay within the existing dispatcher surface or whether the plan's narrow-helper condition is actually triggered. Treat either as a technical conclusion supported by inspected evidence, not as a requirement from Codex.

Required fail-capable evidence:

- cite exact functions or bounded line regions for the run/evidence boundary and each grouped terminal family;
- provide a compact producer-availability table whose result would differ if a terminal family or required fact were absent;
- cite the exact focused test fixtures that can or cannot distinguish one atomic result from ad hoc log or terminal prose;
- recommend exactly one next Implementation-mode unit, with one dominant deliverable, one targeted failing case, exact permitted source/test paths, and an explicit list of terminal integrations and broader evidence deferred; and
- report the discovery commit and prove it changes only this task state file.

Capability subset: baseline only — read and search the active plan, `dispatch.sh`, `dispatch.test.sh`, and directly referenced accepted helpers where necessary; inspect local Git history only if a live code comment requires it; update and locally commit only this task state file. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: the named unknown is resolved from live repository evidence, the handback recommends exactly one properly packaged first Change set A implementation unit, no dispatcher or test source changes, and the task returns with `turn: codex`.

Stop and hand back if the active plan or dispatcher surface contradicts the approved Change set A boundary, the result seam cannot be established from the bounded files, a plan change is required, or any source edit appears necessary to answer the discovery question. Challenge a false premise rather than filling gaps from historical narrative.

## Latest result

Inspected (2026-08-17):

- Claim (1) — run/evidence boundary and terminal-exit families in `dispatch.sh`: HOLDS as a discovery target and is now inventoried below. Read `dispatch.sh` in full at 159180 bytes / 2885 lines; enumerated exit sites with `grep -n 'die \|die_hop \|refuse_17\|exit [0-9]'` and functions with `grep -n '^[a-zA-Z_]*() *{'`.
- Claim (2) — required-fact availability per family: HOLDS; the availability table below is built from the inspected assignment sites, and three required facts are marked unavailable rather than reconstructed.
- Claim (3) — narrowest existing fixture boundary in `dispatch.test.sh`: HOLDS. Read the harness prelude (lines 44–345) and the 57 case blocks located by `grep -n '^# ={10,} case'`; the existing `terminal-record` assertions at lines 1359–1375 are the only structured-record fixture in the suite.
- Claim (4) — whether plan § 8's narrow-helper condition fires: HOLDS as a question and is answered below from inspected evidence.

**Result: the trusted terminal-result seam is `die()` at `dispatch.sh:393–404`, and it is already the single funnel for every post-admission nonzero terminal.**

`die()` today composes the partial-effect block, writes the same bytes to stderr and to `$RUN_LOG`, releases the lease, and exits with the code. `die_hop()` (`dispatch.sh:2019–2021`) is a bare alias for it, so post-hop stops add no second owner. `refuse_17()` (`dispatch.sh:827–842`) already proves the intended pattern one directory over: it writes a machine-readable `terminal-record outcome=… code=17 … actor_launched=no` line to a durable record under the shared lease root. That prefix occurs nowhere else in the file (`grep -n 'terminal-record' dispatch.sh` → line 819 comment, line 829 producer only), so today exactly one terminal family of thirteen has a structured result.

**Run identity and evidence initialization** are at `dispatch.sh:1563–1618`: `LOG_DIR` resolved and created at 1578–1590, `RUN_ID` composed at 1607, `RUN_LOG` truncated at 1609, `DEADLINE_AT` at 1613–1614. That boundary sits *after* argument parsing, task-id/checkout validation, lease acquisition (`acquire_lock`, called at 1399) and the read-only `--status` branch (1401–1561), and that ordering is deliberate and documented at 1563–1577: a run refused at 17 must leave the checkout byte-identical.

**Terminal families, grouped by owning site.** Thirteen nonzero families and five zero-exit sites:

| # | Family | Owning site | Funnel |
|---|---|---|---|
| A | usage / argument refusal (10, 12) | direct `printf`+`exit` at 433–444, 461, 471, 483–486, 518 | none — pre-`RUN_ID` |
| B | checkout / lease infrastructure (11), log-dir failure (10) | direct `printf`+`exit` at 489–492, 664–676, 848; 1579, 1584 | none — pre/at `RUN_ID` |
| C | lease refusal (17) | `refuse_17()` 827–842 via `r17()` 805–809 | own producer, `terminal-record` line |
| D | missing runtime / auth (31, 20, 15) | `die` at 1794–1821, 2390, 2401, 2505 | `die()` |
| E | invalid state / identity / turn (13, 14, 15, 26) | `validate_state()` 1872–1902 | `die()` |
| F | ownership (33, 34, 35) | 2573–2578 | `die()` |
| G | pre-hop repository guards (25, 16, 18, 19) | 2588, 2660, 2666, 2676 | `die()` |
| H | shutdown / hop limit (28, 23) | 2649, 2653 | `die()` |
| I | actor failure / timeout / budget (20, 21, 29) | 2688, 2720–2762 | `die_hop()` |
| J | unexpected effect / commit (24, 30) | 2777–2792 | `die_hop()` |
| K | permission denial (37) | 2814 | `die_hop()` |
| L | missing handback / no transition (36, 25, 22) | 2836–2857 | `die_hop()` |
| M | interruption / operator takeover (28) | `on_signal()` 1344–1384 | **bypasses `die()`** — own `printf`, own `release_lock`, own `exit 28` |
| N | zero-exit success, five sites | `--help` 432, `--status` 1560, `--dry-run` 2610, `turn: operator` 2642, `--carry-one` 2883 | **none** |

D through L — nine of thirteen nonzero families — reach `die()`. Only A, B, C and M do not, plus every site in N.

**Producer availability at each boundary.** Facts required by plan § 5 Change set A item 4:

| Fact | A/B (pre-`RUN_ID`) | C (17) | D–G (pre-hop) | H–L (post-hop) | M (signal) |
|---|---|---|---|---|---|
| task | yes (after 438/485) | yes | yes | yes | yes |
| checkout | canonical only after 490 | yes | yes | yes | guarded at 1377 |
| run | **unavailable** | **unavailable** | yes (`RUN_ID` 1607) | yes | yes |
| stage / outcome / code | yes | yes | yes | yes | yes |
| actor | n/a | n/a | n/a (hop=0) | `$before_turn`, `CUR_ACTOR` 2693 | `CUR_ACTOR` 1350 |
| model request started | provably no | stated `actor_launched=no` 829 | provably no | yes (`hop`, `LAST_CAPTURE`) | yes |
| state before/after | **unavailable** (validator not yet run) | **unavailable** | class only, via `ST_CLASS` 1872–1902 | `before_hash`/`after_hash` 2678, 2835 | hash re-readable |
| HEAD before/after | **unavailable** | **unavailable** | `git_head()` 1905 | `before_head`/`after_head` 2680, 2781 | re-readable |
| working-tree / changed paths | **unavailable** | **unavailable** | `foreign_worktree()` 1909 | `HOP_ALLOWED_SNAPSHOT` 2706 + `partial_effect_block()` 1999 | same, guarded 1377 |
| permission mode | **unavailable as data** | **unavailable** | **unavailable as data** | **unavailable as data** — literal `--permission-mode default` at 2498; no variable exists | **unavailable** |
| hop count | 0 | 0 | 0 | `$hop` / `CUR_HOP` | `CUR_HOP` |
| deadline | **unavailable** (`DEADLINE_AT` set 1613) | **unavailable** | yes | yes, `remaining_seconds()` 2333 | yes |
| recorded usage | **unavailable** — never extracted; `permission_denials_in()` 2123 reads only `.permission_denials` | **unavailable** | **unavailable** | **unavailable** | **unavailable** |
| actor/session identifier | **unavailable** — legacy session identity RETIRED at Tracer bullet 4 (`dispatch.sh` ~2510+) | **unavailable** | **unavailable** | **unavailable** | **unavailable** |
| log / capture paths | **unavailable** | refusal record path only | `RUN_LOG` | `RUN_LOG`, `LAST_CAPTURE` 379 | both |
| owner / lease status | **unavailable** | full holder fields 829–837 | after 2572 | yes | `report_teardown()` 1292 |

Three facts are unavailable at **every** boundary and are marked unavailable rather than reconstructed: **permission mode as data**, **recorded usage**, and **actor/session identifier**. Each is a Change set B or later concern, not a blocker on the result contract, because item 4 qualifies them with "when available".

**Fixture boundary in `dispatch.test.sh`.** The narrowest existing boundary is `new_sandbox()` (121) + `state_file()` (55) + `run_dispatch()` (285) + `calls()` (292). Case 6 (lines 421–428) is the minimal instance: a committed fixture state file, a no-op `--actor-cmd` stub, `expect_rc 22`, and `calls "$d" = 1`. That reaches a post-hop `die_hop()` terminal with one launched actor in a disposable checkout — exactly the shape a result-producer assertion needs, with no new harness.

What the suite can already distinguish:

- **structured record vs prose** — lines 1359–1375 assert a `terminal-record` line field by field (`outcome=`, `code=`, `task=`, `resource=`, `refusal=`, `actor_launched=no`, `holder_checkout=`). This is the existing proof that a machine-readable line can be asserted without parsing prose.
- **fake-result separation, partially** — `calls()` (292) counts real actor launches and `make_carry_stub()` (252) already writes actor-controlled content, so an actor stub that forges a result artifact is an extension of an existing helper, not a new fixture.
- **byte-level non-interference** — `tree_manifest()` (306) proves a refused run wrote nothing into a working tree.

What genuinely requires new focused fixtures:

- **atomic single-finalization** — nothing counts result artifacts per run. `tree_manifest()` cannot serve: it prunes nothing under `runs/` and compares whole trees, so it cannot express "exactly one, and it appeared whole".
- **schema/version rejection** — no code in either file reads a version field today.
- **missing-result blocking** — no case asserts that an absent result refuses to advance the loop.

Verified absence: `ls runs/ | grep -c '\.result'` → `0`. No result artifact of any kind exists in the spike's evidence directory, so a case asserting one is red today.

**Narrow-helper condition (plan § 8): NOT triggered for the first unit.** The condition fires on a second production parser, duplicated lifecycle semantics, or a pure transition untestable without the full dispatcher. A result *writer* hung on `die()` is none of those: `die()` is already the sole production owner of the nonzero terminal path, the writer introduces no parser, and it is exercisable end-to-end through the existing case-6 fixture. The condition may well fire later, on the result *reader* that must reject a hostile or wrong-version artifact — that is a pure parse with no dispatcher run behind it — but deciding that now would be building ahead of evidence, so it is recorded as a deferral below.

**Recommended next unit — Implementation mode, one dominant deliverable:**

- **Dominant deliverable:** one versioned, run-bound, atomically finalized terminal-result producer owned by `die()`, covering the nine nonzero families D–L that already funnel through it.
- **Primary edit begins after:** a new focused case in `dispatch.test.sh`, modelled on case 6, asserting that a run stopped at exit 22 writes exactly one artifact under `$LOG_DIR` named for `$RUN_ID`, carrying a schema/version token, `outcome`, `code=22`, `task`, `checkout`, `run`, `actor_launched=yes`, `head_before`, `head_after`, `state_before`, `state_after` and the next required action. Red today — no `.result` artifact exists.
- **Permitted source paths:** `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` only.
- **Deferred from that unit, explicitly:** families A and B (pre-`RUN_ID` usage/infrastructure refusals, which have no run identity to bind to and need the boundary moved or a second record location decided); family C (17 — already has its own record; migrating it onto the shared producer is a separate move); family M (`on_signal`, which bypasses `die()` and carries teardown-verification concerns of its own); all five family N zero-exit sites; the result *reader*/validator and its hostile-input grammar; missing-result blocking; the write-order and crash-recovery contract of plan § 5 *Durable ordering and recovery*; permission mode, usage and session identifier as data; and the full Gate SA matrix.

**Evidence: this hop changed only this state file.** `git diff --stat HEAD~1` after the discovery commit names `logs/work-loop/work-loop-v2-dispatcher-reliable-supervised-use.md` and nothing else; `dispatch.sh` and `dispatch.test.sh` are byte-unchanged. The availability table would read differently if any of the three unavailable facts were in fact assigned somewhere — each was searched for by name (`grep -n 'SESSION_ID\|session_id\|usage\|total_cost\|num_turns\|PERMISSION_MODE\|permission-mode'` returns only comment lines and the two literal argv sites), and the recommendation's failing case would be green rather than red if any result artifact already existed.

## Blocker

None.

## Next action

Codex: assess the discovery result and either open the recommended first Change set A implementation unit as packaged above, or reframe the seam decision. Note the deferral recorded above — plan § 8's narrow-helper condition is not triggered by the result writer, but may fire on the later result reader; that judgment is deliberately left open rather than pre-decided here.
