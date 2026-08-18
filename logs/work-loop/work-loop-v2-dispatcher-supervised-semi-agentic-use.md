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

Standard. Implementation mode. Unit 8 — repair case 58b against the current contract

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 7 is accepted at `bbd02b419caf5f101d9c1357a9a5808080f95174`: case 58b still asserts the pre-`SHRINK` contract, while production correctly refuses its unwritable evidence directory before admission. The stale case also carried the only proof for the actorless dry-run finalization-failure branch, so deletion alone would hide required proof rather than repair it. This unit updates that one case family without changing production or expanding into every evidence-location refusal branch.

Dominant deliverable: restore case 58b as truthful permanent regression proof for the current evidence-publication boundary, covering its pre-admission input and the dry-run terminal's post-admission finalization-failure branch.
Evidence required in this hop: the accepted three-failure baseline; deterministic fail-capable assertions for both halves of the repaired case; and one sequential full dispatcher-suite run returning zero failures.
Evidence explicitly deferred: the other three unproved `check_evidence_location()` refusal branches; result proof for codes `13`, `14`, `15`, `26`, `35`, `37` and `29`; strengthening case 50e/code 33; the `owner_declared` value question; any per-unit full-suite policy; every other Change set A clause; Change sets B–D; live trials; final regression; adoption review; merge, push, deployment and destructive cleanup.
Primary edit begins after: the accepted Unit 6 run `pass=1319 fail=3`, whose three quoted failures are all case 58b and directly establish the stale red baseline. Do not rerun that baseline before editing.

Required outcome:

- Repair case 58b's existing pre-invocation unwritable-directory half to assert the approved exit-10 pre-admission contract: clear writability error, no actor or model request, no run evidence, no task or checkout lease, no mutation, and a successor admitted after writability is restored. Remove or replace the current `out_lacks "  terminal result:"` assertion because Unit 7 proved it passes vacuously under both contracts.
- Add the smallest adjacent deterministic companion that reaches the admitted dry-run terminal's `finalize_terminal_result 0 || die_terminal_unprovable` branch and proves finalization failure exits 38, advertises no valid result, pins both leases with the truthful cause, and refuses the successor with exit 17.
- Make the companion fail-capable with a bounded scratch-copy mutation that removes or bypasses only the dry-run failure handoff while leaving the dry-run finalizer call and other terminal seams intact. The induction and negative control must be deterministic; no timing race, production hook, new fixture framework or tracked production mutation may survive.
- Reuse the existing mutant/test vocabulary around cases 58 and the existing `DISPATCH_BIN` override. Keep the change inside case 58b and its directly adjacent control unless repository evidence proves that shape impossible.
- Do not add branch-by-branch tests for the symlink, non-directory or unwritable-ancestor refusals. Unit 7 found those adjacent absences, but the approved contract requires the pre-admission class behavior and does not justify an exhaustive preflight matrix here.

Check against the repository:

1. Verify Unit 7 commit `bbd02b41…` changed only this state file and established from approved history that 58b's exit-38 expectation became obsolete under the 2026-08-18 `SHRINK` revision. If that premise differs, hand back before editing.
2. Verify the accepted Unit 6 baseline is the exact current red: `pass=1319 fail=3`, all three failures from case 58b, with the new case 67a green. Do not reproduce it before the primary edit.
3. Verify current cases 58a/58c and 27s/57b/60e prove the surrounding success and shared failure machinery but not the dry-run `||` branch itself. Preserve their behavior and do not rewrite them.
4. Inspect the existing mutation mechanisms before choosing the deterministic induction. The brief specifies the observable proof, not the construction; challenge and hand back if the branch cannot be exercised without a race or production test hook.

Required fail-capable evidence:

- Quote the repaired pre-admission assertions and their green result, including absence of both lease roots and evidence plus successful successor admission.
- Quote the deterministic dry-run failure induction, the exit-38/pinned-lease/successor-refusal result, and the negative control that fails when only the dry-run failure handoff is removed or bypassed. Prove all scratch mutations are outside the tracked tree or restored before commit.
- Run `bash dispatch.test.sh` once, sequentially and without a concurrent mutant run, after the edit is final. Report exact pass/fail counts; this unit is complete only at zero failures.
- Confirm the final diff contains only this state file and the bounded case-58 test repair, with `dispatch.sh` identical to HEAD and pre-existing `logs/friction-log.md` noise unstaged.

Capability subset: baseline only — read the approved plan, Units 6–7 evidence, dispatcher and bounded case-58 test/history surfaces; create scratch mutants outside the tracked tree, edit the case-58 test block, run the local dispatcher suite, and commit the test plus this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No production behavior change, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed implementation handback makes case 58b truthful under the current admission contract, restores deterministic fail-capable proof for the dry-run finalization-failure branch, returns the dispatcher suite green, changes no production behavior, and returns with `turn: codex`.

Stop and hand back if deterministic dry-run failure induction requires a timing race, a production-only test hook, a new general framework or a production behavior change; if the accepted red baseline differs materially; or if the repaired case cannot distinguish pre-admission refusal from post-admission finalization failure. Challenge the brief rather than widening it or recording an accepted limitation on Gate SA's behalf.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `git show bbd02b41 --name-only` lists exactly one file, this state file. Its adjudication is re-derived rather than read back: `git rev-parse 849d0800:…plan-v0.1.md` returns `c7857d5f…` (the blob the 2026-08-18 approval names), and a diff of `### Change set A` against the earlier approved blob `43c44e01` (commit `e9a6fd8b`) shows the two changes the verdict rests on — `- usage or argument refusal;` deleted from the terminal classes, and the **Admission boundary** paragraph naming evidence-location inputs added.
- Claim (2): HOLDS, and was not reproduced — the brief forbids it. Read from Unit 6's accepted handback at `8435c2dc`: `pass=1319 fail=3`, the three failures all `58b —`, case 67a green. Reconciled arithmetically against this unit's run below, which is the stronger check.
- Claim (3): HOLDS — searched `dispatch.test.sh` for every `could not finalize` assertion: 12 sites, of which 57b (7996-7997) is the die funnel, 60e (8810) the carry-one terminal, 50e/40 (6455, 6512) their own seams, and the rest are negative assertions. Only the old 58b (8198) asserted it on a dry-run, and it was red. 27s (3237) covers the interruption terminal. So the dry-run seam's `||` branch had no green case. Confirmed independently by construction: the M30 mutant below removes only that handoff and the pre-existing suite does not notice.
- Claim (4): HOLDS, and it is the claim that changed the shape of the work — see the two rejected inductions under Evidence. `dispatch.sh` is byte-identical to HEAD (`git diff --quiet`), and no production behavior was changed.

Result: **case 58b now asserts the current admission contract, a new case 58g proves the dry-run seam's finalization-failure branch, 58h makes that proof fail-capable, and the full dispatcher suite returns `pass=1338 fail=0`.**

**What changed, and only this.** One insertion region in `dispatch.test.sh`, +186/-16 across 4 hunks. `dispatch.sh` untouched.

- **58b, re-pointed at its own input's current contract.** Same fixture (`mkdir -p runs; chmod a-w runs`), because that input is the one `check_evidence_location()` branch — `[ -w "$want" ]`, 1581-1582 — no other case reaches; 63a and 63a(2) both drive the ancestor-not-a-directory branch at 1591. It now asserts exit 10, the writability reason and the refused path on stderr, and the four absences the revised plan names: the shared lease root was never created, nothing was written into the directory, no actor launched, HEAD unmoved and the working tree byte-identical. Then, with writability restored, **the successor is admitted (exit 0)** — the assertion that gives the four absences their teeth, and the exact inverse of what the case demanded under the old contract.
- **The vacuous assertion is gone, not carried forward.** `out_lacks "  terminal result:"` passed under both contracts, so it could not fail for the right reason. Unit 7 flagged it; this unit removed it rather than preserving a green line that proves nothing.
- **58g — the invariant 58b used to carry, at the boundary the plan still puts it behind.** An admitted `--dry-run` whose publication fails: exit 38, no terminal result advertised, the stop text saying the ending could not be proved, zero results and zero partials, **both leases held and surviving the EXIT trap**, and the successor refused 17. The lease presence is what separates it from 58b — only an admitted run owns those.
- **58h — the control 58c could not be.** M25 deletes the dry-run finalization line *and its failure handoff together*, so it cannot see the handoff go missing alone. M30 removes only ` || die_terminal_unprovable` from `dispatch.sh:4103`, keeps `finalize_terminal_result 0` on the same line, and asserts both other seams intact.

Evidence:

- **The induction is deterministic, and two plausible ones were rejected before it on evidence, not taste.** A dry-run launches no actor, so 57b's and 60e's technique (the actor breaks its own evidence directory) has no door here. *(i)* **Global `umask 0222`** — LOG_DIR absent at admission so the ancestor check passes, then `mkdir -p` creates it unwritable. Probed: it reached exit 38, but through the **die funnel** (`STOP [17] … holds task dry-task` → 38), because the umask also made the lease root unwritable and the lease metadata unreadable. Wrong branch, already covered by 57b. Rejected. *(ii)* **A task id long enough that `.result.partial` exceeds NAME_MAX while `.log` fits** — probed at length 216 and it published normally (`RC=0`), because the observed run id is `<15>-<empty lock key>-<pid>-<task>`, giving an 11-byte window against a pid whose width varies. The window is unsatisfiable across pid widths 1–7 (`L > 237-p` and `L ≤ 233-p` cannot both hold), so it is a coin toss, not a case. Rejected as the race the brief forbids.
- **The induction that was used, and why it is fixture rather than hook.** The dispatcher invokes the **checkout's own** ownership helper at `dispatch.sh:4047-4049` — after run evidence and both leases exist, ~50 lines above the seam. 58g replaces that sandbox-local copy with a wrapper that removes write permission and then `exec`s the real helper, so the ownership answer under test is still the shipped helper's. This is established suite vocabulary, not a new mechanism: cases 27u (3080) and 31 (3360) already substitute that same helper, and 12f removes the lease library outright. Nothing in `dispatch.sh` was touched, and the wrapper is **committed in the sandbox** — the tracked helper is outside the dispatcher's allowlist, so an uncommitted rewrite would read as a foreign working-tree change; 58g asserts the tree is clean before running, so a future allowlist change cannot silently turn this case into an 18.
- **The fail-capability is a cause flip, not an exit-code flip — and that distinction is the finding.** Under M30 the run **still exits 38**, because the consumer gate one line below catches the missing artifact. A control asserting only the code would have passed and proved nothing. What changes is the sentence written into both pins: real dispatcher → `terminal result unprovable: the run could not finalize its terminal result under …` (`could not finalize` present, `was refused before release` absent); M30 → `… was refused before release: path-refused` (`could not finalize` **absent**). 58g asserts the first and 58h asserts the flip, which is 57b's existing distinction applied at the seam that lacked it.
- **The full suite, run once and sequentially after the edit was final, with no concurrent mutant run: `pass=1338 fail=0`, exit 0.** The count reconciles exactly against the accepted baseline, which is the check that no case was silently lost: `1319 pass − 1` (old 58b's single vacuous pass) `+ 20` (new 58b 10, 58g 8, 58h 2) `= 1338`, and `3 fail − 3 = 0`.
- **Disclosed process fact.** A first full-suite attempt was started in the foreground, hit the 10-minute tool ceiling at case 45 (`709 pass, 0 fail`) and was killed. Its partial output was discarded, not reported; the run above is a fresh single run started afterwards from the top. No mutant suite ran concurrently with it. All scratch mutants and probe scripts live outside the tracked tree, under the session scratchpad and the harness's own `$SANDBOX_ROOT`.
- **Final scope, by inspection.** `git status --porcelain` shows this state file, `dispatch.test.sh`, and the pre-existing unstaged `logs/friction-log.md` (untouched — the log is frozen workspace-wide). `git diff --quiet dispatch.sh` confirms production is byte-identical to HEAD. Only the test file and this state file are staged.

Deferrals recorded, not implemented (core § 5): **(a)** the long-task-id probe surfaced that `dispatch.sh:1503-1509` enforces a *character* grammar on task ids with **no length bound**, while Change set A's hostile-input boundary requires "strict **length** and character grammars to task IDs". A 216-character task id was accepted and produced run artifacts. That is a real Change set A gap, and this brief explicitly defers "every other Change set A clause" — recorded for Codex, not acted on. **(b)** The three remaining `check_evidence_location()` refusal branches (symlink-unresolved 1574-1576, exists-not-a-directory 1579-1580, ancestor-not-writable 1594-1596) stay uncovered, as the brief directed.

## Blocker

None.

## Next action

Codex: assess Unit 8. Case 58b now asserts the post-`SHRINK` pre-admission contract over the same fixture, 58g proves the dry-run terminal's finalization-failure branch after admission, 58h makes that proof fail-capable through a cause flip rather than an exit-code flip, the suite is `pass=1338 fail=0` and reconciles exactly with the accepted baseline, and `dispatch.sh` is byte-identical to HEAD. Then decide three things. (a) Whether the ownership-helper substitution used as 58g's induction is accepted as fixture — it is existing suite vocabulary (27u, 31, 12f), it changes no production code, and the two alternatives were rejected on probe evidence recorded above — or whether the dry-run seam should instead carry a written accepted limitation. (b) Whether the newly surfaced **task-id length gap** (`dispatch.sh:1503-1509` enforces characters but no length, against Change set A's "strict length and character grammars to task IDs"; a 216-character id was accepted and produced run artifacts) becomes its own unit now or joins the held Change set A work — it is a hostile-input clause this brief deferred, not something this unit may act on. (c) Whether the three remaining `check_evidence_location()` refusal branches stay deferred. Remaining terminal-result proof gaps (`13, 14, 15, 26, 35, 37, 29`), the case 50e strengthening and the `owner_declared` question stay deferred exactly as this brief left them.
