---
task: work-loop-v2-cross-transport-concurrency-phase-1
turn: codex
---

## Objective and scope

Implement and validate Phase 1 of the accepted Work Loop v2 cross-transport concurrency proposal: one shared repository-rooted live-lease contract used by the attended carrier and unattended dispatcher, plus fail-closed repository-depth ownership admission before the carrier launches an actor. Complete the controller-level acceptance coverage, preserve both transports' intentional boundaries and existing behavior, make only the necessary Work Loop instruction updates, and run the two explicitly authorized live validations after the implementation has passed independent assessment.

Task exit condition: the Phase 1 implementation and required instruction changes are committed in this worktree, the relevant controller suites and failure paths pass, one genuine cross-transport contention proof and one genuine fan-out-two Work Loop pair produce the accepted evidence, and the final limitations and rollback path are recorded for an operator integration decision.

Scope: the Phase 1 files and test surfaces named in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-and-task-aware-worktrees-implementation-proposal-2026-08-13.md`, plus this state file. Temporary linked worktrees may be created only when the approved live validations require them; implementation remains bound to this checkout.

Excluded: Phase 2 task-aware automatic worktrees; changing or replacing D4; changes to the executable core; automatic merge, landing, push, branch deletion, worktree cleanup or other destructive cleanup; a scheduler, registry, service or lease database; and concurrency outside Work Loop v2. No work is performed in the main checkout.

## Lane and unit

Standard. Implementation mode. Unit 5 correction — add the attended carrier to SKILL.md's repository-depth assignment, per the frozen finding.

Named reason for the loop: the accepted repair spans shared process leasing, two transports, durable ownership, controller tests and authorized live validations; it requires multiple bounded units and independent assessment before it can support an integration decision.

## Brief

Unit 4r2b is accepted: implementation `294feb28` (pointer `742cdb94`) recovered the dispatcher partial and produced focused 19/8 red to 27/0 green evidence across both operator channels, while preserving outer exit 28 and later refusal 17. Phase 1 transport behavior is now implemented and independently assessed; the approved proposal requires exactly two accompanying Work Loop instruction corrections before the broad regression and live-validation gates. This unit makes those two edits and no other policy or core change.

Governing authority: the operator-approved Phase 1 proposal bound at `10d2eeb6f8868b2f073e11150dc1a50a95ea760a`, §1 “What must change in Work Loop instructions, and no more.” Verified implementation reality: carrier repository-depth ownership admission at `52ecf472`, carrier pin reporting at `1da14105`, dispatcher shared lease/pin reporting through `294feb28`, and shared helper at `f4396a7c`. The executable core is excluded; Phase 2 remains deferred and D4 remains.

Required outcome in `.agents/skills/work-loop-v2/SKILL.md`, and only there: (1) correct the stale limitation sentence that says only the dispatcher has exit-code-borne enforcement, now that the attended carrier also enforces shared leases and repository-depth ownership before actor launch; preserve the still-true interactive/operator-bypass limitation. (2) make the existing `33`/`34`/`35` ownership-stop taxonomy explicitly true for both the attended carrier and unattended dispatcher, without inventing new codes or changing the transports' distinct surfaces.

Claims to verify before editing:

1. Confirm the current “Not prevented” paragraph still ends with “only the dispatcher's is exit-code-borne,” and identify the minimum truthful replacement supported by the implemented carrier and dispatcher behavior.
2. Confirm the current stopped-outcome taxonomy already assigns `33`/`34`/`35` to ownership stops but sits in unattended-run context without explicitly saying the attended carrier now shares those codes. Identify the smallest addition that removes that ambiguity.
3. Search the complete skill for other statements that would become false or duplicated by these two edits. Bound any absence claim to `.agents/skills/work-loop-v2/SKILL.md`; do not expand into the executable core or Claude command.

Evidence required:

- Show the exact before and after text for both corrections and tie each to the verified implementation source that makes it true.
- Run a bounded text assertion that fails against the committed pre-edit skill and passes afterwards: the obsolete “only the dispatcher” claim must be absent; the surviving interactive/operator-bypass limitation must remain; and the ownership-stop wording must explicitly cover attended carrier plus unattended dispatcher with `33`/`34`/`35`. Instruction text is the behavior under test here, so a targeted content assertion is proportionate; do not invent a permanent test framework.
- Run `git diff --check` on the bounded edit. Do not run transport suites in this unit; their behavior is already accepted and the full regression gate follows.
- Commit only `.agents/skills/work-loop-v2/SKILL.md` and this state file, using explicit pathspecs. Report the implementation commit and any pointer commit.

Codex framing decisions: these are the proposal's two required instruction edits in one documentation deliverable. No wording cleanup, duplicate-warning refactor, executable-core change, Claude-command change, full regression, or live validation belongs here.

Stop if the proposal's two premises are false, truthful wording requires changing a transport or the executable core, the edit would reopen D4 or Phase 2, or any bounded assertion remains red. Do not silently broaden policy.

Completion condition: both and only the proposal §1 instruction corrections are committed; the stale limitation is removed without hiding the real residual limitation; ownership codes `33`/`34`/`35` are explicitly cross-transport; bounded assertions and whitespace validation pass; and the task hands back at `turn: codex`.

## Latest result

Inspected (2026-08-14) — the frozen finding reproduced before it was corrected:

- Finding (1): REPRODUCES — read `.agents/skills/work-loop-v2/SKILL.md` line 197. The paragraph read "both need `git worktree list` across the registered worktrees, and this loop assigns repository-depth checks to Claude at Step 1 and to the dispatcher at admission, not to you. Those are the actors that establish it". It named two actors and omitted the attended carrier.
- The omission is materially stale, confirmed at the source rather than by recall: `scripts/axcion-harness-v0.2/carry-turn.sh` line 1498 runs `check --checkout "$CHECKOUT" --task "$TASK" --depth repo` and lines 1502–1507 refuse with `33`/`34`/`35`, each `die()` before any actor launches. `git show --stat 52ecf472` confirms that block entered at the accepted carrier admission commit. So the carrier has established repository-depth ownership since `52ecf472`, and the sentence excluded it.

Result: the frozen finding is resolved, and only it. `.agents/skills/work-loop-v2/SKILL.md` line 197 now reads "this loop assigns repository-depth checks to Claude at Step 1, to the attended carrier before it launches an actor, and to the unattended dispatcher at admission — not to you." The attended carrier is added to the existing assignment; the paragraph's load-bearing conclusion is preserved verbatim ("not to you. Those are the actors that establish it, and a read-only look of your own does not stand in for their check"), as is the closing exposure bound about every unit crossing a Claude entry. The change is one line and one sentence; the diff touches nothing else. No transport, executable core, Claude command or reference file was touched, and D4 and Phase 2 are untouched.

Evidence: the Unit 5 bounded content assertion, extended with five checks (C1–C5) for this finding, run against the committed pre-correction skill from `git show HEAD:` and against the corrected file. **12 passed / 2 failed red before, 14 passed / 0 failed green after.** The two that flipped are exactly C1 (stale two-actor assignment must be absent) and C2 (attended carrier must be named). C3–C5 assert the load-bearing conclusion, "not to you", and the exposure bound and passed in both runs — they would have caught a correction that resolved the omission by deleting the limit. A1–B5 are Unit 5's two accepted edits and also passed in both runs, which is the "did the correction break something" guard: the obsolete "only the dispatcher" claim stays absent, both residual-limitation clauses stay present, the cross-transport `33`/`34`/`35` statement and the unattended taxonomy row stay intact, and no code `38` was invented. `git diff --check -- .agents/skills/work-loop-v2/SKILL.md` exits 0. Transport suites were not run, per the frozen finding's bound; the broad regression gate still follows.

Prior accepted evidence remains: Unit 5's two instruction corrections at `9226c7c4` (pointer `32fd2c9d`), 5/5 red to 10/0 green; dispatcher pin reporting 19/8 red to 27/0 green at `294feb28` (pointer `742cdb94`); carrier caller 32/7 red to 39/0 green at `1da14105`; helper 61/6 red to 67/0 green at `f4396a7c`; dispatcher 482/0; carrier 350/0; owner helper 92/0; carrier ownership red 333/17 and green 350/0; earlier cross-transport red/green and stale-oracle mutant evidence.

Open after this correction: broad plan-gate regression; authorized live cases 23 and 24; final limitations and rollback record. Nothing new was noticed during this correction, so no new deferral is recorded. The deferral Unit 5 recorded for line 197 is now closed by this correction — Codex reclassified it as part of proposal §1's required narrowing rather than a third improvement. Previously deferred without action, unchanged: duplicate carrier and dispatcher warning wording, absent positive carrier rc=0 assertion, carrier process-group parameter naming, dispatcher case selection, duplicated fixture-packaging knowledge, explicit broken-owner-helper catch-all coverage, and the unreachable helper entry state.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen finding only. Two questions, per core § 3:

1. Is the finding resolved? The attended carrier is now named in SKILL.md line 197's repository-depth assignment, and the paragraph's load-bearing conclusion that Codex's local read cannot establish repository-depth ownership is preserved verbatim. Evidence: C1/C2 flipped red to green; C3–C5 held in both runs.
2. Did the correction break anything? A1–B5 — Unit 5's two accepted edits — passed in both the red and the green run, and `git diff --check` exits 0. The diff is one line in one file.

Anything newly noticed at this closure check is a deferral, not a second correction round.
