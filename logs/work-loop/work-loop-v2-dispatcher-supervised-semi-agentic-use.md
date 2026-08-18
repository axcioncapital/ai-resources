---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Discovery mode. Unit 7 — adjudicate the stale publication-failure regression

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 6 is accepted at `8435c2dcb329121549b906bac8e8229179288629`: code 34 now has permanent fail-capable proof, production stayed unchanged, and the full dispatcher run exposed three failures confined to case 58b. That case makes the requested evidence directory unwritable before invocation, while Unit 1 added a pre-admission refusal for exactly that input; current case 60e separately appears to exercise publication failure after admission. Before any fix, this discovery must determine whether 58b is now an obsolete fixture, a missing proof route, or a real behavior regression.

Dominant deliverable: adjudicate case 58b against the approved admission boundary and the current permanent proof for post-admission terminal-result publication failure.
Evidence required in this hop: one compact causal trace and coverage comparison that classifies the failure as `OBSOLETE FIXTURE`, `BEHAVIOR GAP`, `PROOF GAP`, or `UNKNOWN`, and identifies the smallest justified next change if one exists.
Evidence explicitly deferred: editing or running tests; changing production; result proof for codes `13`, `14`, `15`, `26`, `35`, `37` and `29`; strengthening case 50e/code 33; the `owner_declared` value question; any new per-unit full-suite policy; every other Change set A clause; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.

Required outcome:

- Trace case 58b's actual current route from its pre-invocation `chmod` through `check_evidence_location()`, admission, run identity, evidence creation and lease acquisition. State precisely which of those boundaries it reaches before exit 10.
- Recover case 58b's original intended invariant from the smallest necessary accepted history, then compare that invariant with current cases 58a, 58c and 60e and the shared production finalization/lease path. Do not assume one case substitutes for another merely because both mention publication failure.
- Decide whether the approved plan still requires a distinct dry-run publication-failure proof after the pre-admission check, and whether current committed evidence already proves that requirement. Separate behavior coverage from fixture mechanics.
- Classify the three failures together as `OBSOLETE FIXTURE`, `BEHAVIOR GAP`, `PROOF GAP`, or `UNKNOWN`. If obsolete, say whether the smallest honest repair is deletion, replacement with a pre-admission assertion, or a different post-admission induction and why; if a behavior or proof gap, identify the exact missing contract without designing the fix.
- Identify one next bounded target. Do not adjudicate the seven other terminal codes or use this discovery to create a general regression policy. Codex's current framing is that requiring the full suite after every focused unit would be ceremony; the approved plan already requires the full synchronous gate before adoption, and this unit should challenge that framing only if repository evidence shows a narrower load-bearing cadence requirement.

Check against the repository:

1. Verify Unit 6 commit `8435c2dc…` changed only the focused dispatcher test and this state file, and reported `pass=1319 fail=3` with all three failures in case 58b while case 67a passed 28/28. Treat the quoted execution as accepted evidence; do not rerun it.
2. Verify Unit 1 commit `48d0459d…` introduced `check_evidence_location()` as a pre-admission refusal and establish the exact approved behavior it was meant to enforce.
3. Verify the content-bound approved plan's distinction between invalid pre-admission evidence locations and post-admission inability to finalize a result, including the required lease disposition when teardown is uncertain.
4. Inspect current cases 58a, 58b, 58c and 60e plus only the shared production paths they cite. Bound history to the commits that introduced or materially changed those cases and Unit 1's admission check.

Required fail-capable evidence:

- Quote the decisive current control-flow sites and the before/after historical diff that explains why case 58b now exits 10 instead of 38.
- Provide a small invariant-to-proof map: pre-admission unwritable evidence, dry-run result finalization, finalization failure, lease pinning, and next-run refusal. For each, name the exact committed case that can fail or mark it unproved.
- Explain how the proposed classification would read differently under the nearest alternative classification; a label that follows only from the brief's wording is not evidence.
- Confirm no production, test or documentation file changed and no suite ran; only this state file may be committed. Leave pre-existing `logs/friction-log.md` noise unstaged.

Capability subset: baseline only — read the approved plan, Unit 1 and Unit 6 commits, current dispatcher, owner/lease helpers as directly needed, and bounded dispatcher test/history surfaces; update and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback settles why case 58b is red, proves whether the release contract has lost behavior or only a valid fixture, identifies one smallest next target, changes only this state file, and returns with `turn: codex`.

Stop and hand back if the admission/finalization boundary remains genuinely ambiguous after bounded history; if deciding would require executing or constructing a fixture; if the approved plan and accepted Unit 1 behavior materially conflict; or if the cause expands beyond case 58b's stated invariant. Challenge the brief rather than widening it.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show --stat 8435c2dc` lists exactly two files, `logs/work-loop/…-supervised-semi-agentic-use.md` and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. The quoted execution facts are read from that commit's own accepted handback and not rerun: `pass=1319 fail=3`, the three named failures all `58b —`, case 67a's 28 assertions all green.
- Claim (2): HOLDS — `git log -S"check_evidence_location"` returns `48d0459d` as the introducing commit, and its diff adds `check_evidence_location()` plus one `STATUS_MODE`-guarded call. In HEAD they sit at `dispatch.sh:1568-1598` and `1599-1606`, above `mkdir -p "$LOG_DIR"` (3144), `RUN_ID` (3172), `: >"$RUN_LOG"` (3174) and `acquire_lock` (3263). Pre-admission confirmed by position, not by the commit message.
- Claim (3): HOLDS, and the pin is exact — `git rev-parse 849d0800:…plan-v0.1.md` returns `c7857d5f…`, the blob Patrik's 2026-08-18 approval names; HEAD's blob is `af0f1efd…`, and a diff of `### Change set A` between the two is byte-identical, so the approved text is quoted below unchanged.
- Claim (4): HOLDS — cases 58a (`dispatch.test.sh:8140`), 58b (8185), 58c (8209) and 60e (8789) read in full, with only the production sites they reach: 1568-1606, 3143-3174, 3263, 1956-1999 (`pin_lock_terminal`, `die_terminal_unprovable`), 4103 and 4135.

Result: **case 58b is an `OBSOLETE FIXTURE`, and the obsolescence is Patrik's own approved `SHRINK` decision, not a behavior regression. Two real proof gaps sit behind it and must not be lost to a deletion.**

**The current route, and where it stops.** 58b's fixture is environmental and pre-invocation — `mkdir -p "$V58B/runs"; chmod a-w "$V58B/runs"` (8189) — then a direct call with `--log-dir "$V58B/runs" … --dry-run` (8191-8192). Control reaches `check_evidence_location "$V58B/runs"` at 1605 (the guard is `STATUS_MODE -ne 1`; `--dry-run` is deliberately not excluded) and inside it takes the third branch: not a symlink (1574), `-e` true (1578), `-d` true (1579), **`-w` false (1581) → `STOP [10] run evidence directory is not writable` → `exit 10` (1582)**. It never reaches state-file reading (1607+), the log-dir creation (3144), the run identity (3172), the run log (3174), `acquire_lock` (3263) or the dry-run finalization (4103). No lease root, no evidence, no result — which is precisely why all three assertions fail and why they fail in that shape: 38→10 (8193), both lock directories absent so the retention check has nothing to read (8196-8203), and after `chmod u+w` nothing is held, so the second `--dry-run` is admitted and exits 0 instead of 17 (8205-8206). 58b's fourth assertion, `out_lacks "  terminal result:"` (8194), still passes — **vacuously**, because an exit-10 refusal advertises nothing. One of its four assertions cannot tell the two contracts apart.

**Why the exit moved, from the historical diff.** The case did not drift: a diff of 58b's block at `f702c41f` (2026-08-17, where it entered) against HEAD returns no content difference — byte-identical, only the surrounding line offsets moved. The before/after that explains the change is in the **approved plan**, between the earlier approved blob `43c44e01` (commit `e9a6fd8b`, approved 2026-08-16) and the current approved blob `c7857d5f` (commit `849d0800`, approved 2026-08-18). `### Change set A` changed in exactly three places:

```
- 1. Create one run identity and initialize its external evidence location …
-    - usage or argument refusal;
+ **Admission boundary:** a run exists only after argument parsing has supplied syntactically
+ valid task, checkout and evidence-location inputs and the dispatcher has established their
+ trusted canonical values. … Such a refusal is not a run terminal class and needs no durable result.
+ 1. After admission, create one run identity …
- - Every terminal class produces exactly one valid result.
+ - Every admitted-run terminal class produces exactly one valid result.
+ - Every invalid pre-admission invocation produces clear stderr and a nonzero exit while
+   launching no actor, taking no owner or lease, mutating nothing and writing no evidence.
```

Under the 2026-08-16 contract an unusable evidence location was a **usage refusal inside the run**, an enumerated terminal class owing one durable result — so 58b's expectation of 38, pinned leases and a refused successor was correct when written. Under the 2026-08-18 `SHRINK` revision, evidence-location validity is an **admission input** and the usage-refusal terminal class was deleted, so exit 10 with no lease and no evidence is the required behavior for that exact input. Unit 1 (`48d0459d`) implemented the revision one day after the case was written. The case is red because the contract moved under it.

**Does the plan still require a distinct dry-run publication-failure proof? Yes — and that is a separate question from the fixture.** Gate SA requires "every terminal path after run admission produces one durable atomic result" (§ 6) and "every success, block, failure, partial effect, correction, reconciliation, and closure path follows the accepted durable order"; Change set A's durable ordering requires "release a lease only after the terminal result exists and teardown is proven safe", with "Uncertain teardown pins the applicable lease." A `--dry-run` is an admitted run — it takes both leases, and only `--status` is carved out (1599, 3263). The dry-run terminal has **its own call site**: `dispatch.sh:4103`, `finalize_terminal_result 0 || die_terminal_unprovable # dry-run terminal finalization`, byte-identical to `f702c41f:3579`. Production did not change; four *other* sites (2676 interruption, 4192 operator, 4472 carry-one, and the die-funnel transfer) call the same single owner `die_terminal_unprovable`/`pin_lock_terminal` (1956-1999), and their failure branches are proved by 27s, 57b (fail-capable via 57c) and 60e. **None of them reaches 4103.** Separating behavior coverage from fixture mechanics: 58a proves the dry-run success publication and consumption, and 58c's M25 mutant proves the seam is load-bearing — but M25 deletes both marked lines together, so it removes `finalize_terminal_result 0` *and* its `||` clause. A mutant keeping the finalizer call and dropping only `|| die_terminal_unprovable` would still pass 58a, 58c and 58e. That is exactly the contract 58b held, and nothing green holds it now.

**Invariant-to-proof map.**

| Invariant | Case that can fail | Status |
|---|---|---|
| Pre-admission: ancestor of the evidence location is not a directory → exit 10, no lease root, no evidence dir, no actor, no commit, tree unchanged | 63a, 63a(2); positive control 63b | proved |
| Pre-admission: evidence location **exists as a directory but is not writable** (1581-1582) | none | **unproved** |
| Dry-run result finalization + consumption + truthful no-model fields | 58a; fail-capable via 58c (M25) | proved |
| Finalization failure → exit 38, no result claimed, at other seams | 27s (interruption), 57b (die funnel, fail-capable via 57c), 60e (carry-one) | proved |
| Finalization failure → exit 38 at the **dry-run** seam (4103's `||` clause) | none since `48d0459d` | **unproved** |
| Lease pinning with the truthful `terminal result unprovable:` / `could not finalize` cause | 27s, 57b, 60e | proved, not at the dry-run seam |
| Next-run refusal (exit 17) by the retained pin | 57b:8007, 60e:8818 | proved, not at the dry-run seam |

**Next bounded target — one.** *Restore proof for case 58b's two orphaned invariants at the same case:* re-point 58b at what the approved contract now requires for its own input (exit 10 with the writability message, no lease root, no evidence directory, no actor, successor admitted), and add a companion reaching 4103's `||` clause on an admitted dry-run, with a mutation control that removes **only** that clause. Deletion alone drops both residues silently; a pre-admission assertion alone abandons the dry-run failure branch; a post-admission induction alone abandons the 1581 branch, which today has no case at all. The two share one fixture and one narrative, so they are one unit rather than two. **One question that unit must settle first, which I am not resolving here:** a dry-run has no actor, so neither existing induction technique applies — 57b/60e use the actor's own command (`BREAK_PUBLISH`), 27s uses an external `chmod` while the actor hangs — and between the run log (3174) and finalization (4103) a dry-run does state reads, lease acquisition and its preflight report with nothing blocking, so an external `chmod` is a race, not a deterministic induction. If no deterministic induction exists, the honest outcome is the mutation control plus a **written accepted limitation** under Gate SA, not a flaky case. Naming that fork is the target; choosing inside it is Codex's framing call.

**No cadence challenge.** The brief asked for one only if repository evidence showed a narrower load-bearing cadence requirement. It does not: the plan names the final synchronous gate and the suite list, and no per-unit full-suite duty. Recorded as a fact rather than a challenge — this regression entered at Unit 1 and was first seen at Unit 6, and what saw it was a full run.

Evidence:

- **The classification would read differently under BEHAVIOR GAP**, the nearest alternative. That reading says Unit 1 illegitimately closed a path the release contract needs open, and the repair belongs in `dispatch.sh` — narrowing `check_evidence_location()` so an unwritable existing directory is admitted and fails at finalization. For it to be right, the approved plan would have to place evidence-location validity *after* admission, or keep `usage or argument refusal` among the classes owing a durable result. The diff above shows the opposite on both counts, inside the blob Patrik's approval is bound to. Had that terminal-class list been unchanged between `43c44e01` and `c7857d5f`, this hand-back would return `BEHAVIOR GAP` and the target would be a production narrowing, not a test repair. The second alternative, plain `PROOF GAP`, is refuted because 58b's *expected outcome* now contradicts the approved contract for its own input — an obsolete assertion, not a coverage shortfall — but it is why the verdict carries two residues instead of being a clean delete.
- **The unproved rows are absence claims and name their searches.** Searched `dispatch.test.sh` for each of `check_evidence_location()`'s four refusal texts — `is a symlink that does not resolve`, `exists and is not a directory`, `run evidence directory is not writable`, `is not writable: ` — each returning 0 matches; 63a asserts only `STOP [10]` plus the path, and its fixture (`printf 'not a directory' >"$d/blocked-runs"`, `--log-dir "$d/blocked-runs/inside"`) reaches the 1591 ancestor branch, not 1581. Searched for every `chmod a-w`/`chmod -w` in the suite: lines 3232 (27s, mid-run), 7947 (`BREAK_PUBLISH`, post-hop), 8189 (58b) and 8796 (60e, post-hop) — 58b is the only pre-invocation one. Searched for every `expect_rc 38` site and mapped each to its seam; none is the dry-run seam.
- **Scope, confirmed by inspection.** `git status --porcelain` shows only `logs/friction-log.md` (pre-existing, 383 unstaged insertions, left unstaged and untouched — the log is frozen workspace-wide) and this state file. No production, test or documentation file was changed. No suite ran; every execution fact above is quoted from the accepted Unit 6 handback or derived from static reading of committed content. Only this state file is staged.

Deferrals recorded, not implemented (core § 5): (a) three of `check_evidence_location()`'s four refusal branches have no committed case at all — symlink-unresolved (1574-1576), exists-not-a-directory (1579-1580), ancestor-not-writable (1594-1596) — which widens past 58b's invariant and is a Codex call on whether Gate SA's pre-admission clause needs branch-level coverage. (b) Whatever replaces 58b should not carry forward assertion 8194, which passes under both contracts and so cannot fail for the right reason.

## Blocker

None.

## Next action

Codex: assess Unit 7. The adjudication is `OBSOLETE FIXTURE` — 58b's expectation was correct under the 2026-08-16 approved contract and is contrary to the 2026-08-18 `SHRINK` revision that Unit 1 implemented; production behavior at the dry-run seam is byte-identical to the day the case was written. Two invariants lost their only proof with it: the pre-admission unwritable-directory refusal (`dispatch.sh:1581-1582`) and the dry-run seam's finalization-failure branch (`4103`). Decide (a) whether to open the single proposed unit repairing both at case 58b, (b) how that unit resolves the fork it must settle first — a deterministic post-admission induction for an actorless dry-run, or a mutation control plus a written accepted limitation under Gate SA — and (c) whether the two recorded deferrals enter its scope or stay held. No cadence rule is proposed. Remaining proof gaps (`13, 14, 15, 26, 35, 37, 29`), the case 50e strengthening and the `owner_declared` question stay deferred exactly as this brief left them.
