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

Standard. Implementation mode. Unit 5 — make the two narrow Work Loop instruction corrections required by proposal §1.

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

Inspected (2026-08-14):

- Claim (1): HOLDS — read `.agents/skills/work-loop-v2/SKILL.md` line 199; the "Not prevented" paragraph still ended with "Your enforcement is instruction-borne; only the dispatcher's is exit-code-borne." The still-true residual limitation is the first half of the same sentence (two interactive sessions on one checkout for the same task; an operator who proceeds past a refusal) and is untouched. The minimum truthful replacement is supported by `scripts/axcion-harness-v0.2/carry-turn.sh`: `--depth repo` ownership admission at line 1498 with `33`/`34`/`35` refusals at lines 1502–1507 that launch nothing (`52ecf472`), and the shared lease taking exit `17` against a dispatched run at header lines 122–142 (`f4396a7c`, `294feb28`).
- Claim (2): HOLDS — the taxonomy row at line 290 already assigned "an ownership stop (`33`,`34`,`35`)", and it sits inside `#### Unattended runs` → "Three outcomes, never blurred" with no statement that the attended carrier shares those codes. The only other mention, the `35` remedy paragraph at line 302, is likewise in unattended context. The smallest addition that removes the ambiguity is one statement placed with the taxonomy that names both programs and adds no code.
- Claim (3): HOLDS with one adjacent finding — searched the complete `.agents/skills/work-loop-v2/SKILL.md` (530 lines) for `borne`, `ownership`, `lease`, `repository-depth` and `33`; searched `.agents/skills/work-loop-v2/references/` for `exit-code-borne` and `33`, no match. No statement is made false or duplicated by the two edits. The `35` remedy at line 302 stays true for both transports, and `carry-turn.sh` line 1507 uses the same wording. Adjacent, not caused by these edits: line 197 enumerates repository-depth checks as assigned "to Claude at Step 1 and to the dispatcher at admission" and does not name the carrier, which has run `--depth repo` since `52ecf472`; its load-bearing point ("not to you") is unaffected. Deferred, not edited — see below.

Result: both and only the proposal §1 instruction corrections are made in `.agents/skills/work-loop-v2/SKILL.md`. (1) The stale limitation sentence now reads "Your enforcement is instruction-borne. Both courier programs are exit-code-borne: the attended carrier and the unattended dispatcher each take the shared lease and check repository-depth ownership before they launch an actor, and refuse rather than launch." — replacing "Your enforcement is instruction-borne; only the dispatcher's is exit-code-borne", with the interactive/operator-bypass limitation preserved verbatim ahead of it. (2) A new statement after the `35` remedy paragraph declares `33`, `34` and `35` cross-transport, names the attended carrier's pre-launch repository-depth check beside the dispatcher's admission check, explains that the codes are listed in the unattended table only because that is where exit codes are enumerated, and states that nothing else is shared and no new code exists. No transport, executable core, Claude command or reference file was touched; D4 and Phase 2 are untouched.

Evidence: bounded content assertion (10 checks — obsolete claim absent, both residual-limitation clauses present, both new statements present, existing taxonomy row intact, no invented code `38`) run against the committed pre-edit skill from `git show HEAD:` and against the edited file. 5 passed / 5 failed red before, 10 passed / 0 failed green after; the five that flipped are exactly A1, A3, B1, B2, B3, and the five that passed in both are the preservation checks that would have caught an over-broad edit. `git diff --check -- .agents/skills/work-loop-v2/SKILL.md` exits 0. Transport suites were not run, per the brief. Implementation commit: see the pointer commit recorded on hand-back.

Prior accepted evidence remains: dispatcher pin reporting 19/8 red to 27/0 green at `294feb28` (pointer `742cdb94`); carrier caller 32/7 red to 39/0 green at `1da14105`; helper 61/6 red to 67/0 green at `f4396a7c`; dispatcher 482/0; carrier 350/0; owner helper 92/0; carrier ownership red 333/17 and green 350/0; earlier cross-transport red/green and stale-oracle mutant evidence.

Open after this unit: broad plan-gate regression; authorized live cases 23 and 24; final limitations and rollback record. Newly deferred without action: SKILL.md line 197's repository-depth enumeration omits the attended carrier — a third edit outside the proposal's two required corrections, so recorded rather than made. Previously deferred without action: duplicate carrier and dispatcher warning wording, absent positive carrier rc=0 assertion, carrier process-group parameter naming, dispatcher case selection, duplicated fixture-packaging knowledge, explicit broken-owner-helper catch-all coverage, and the unreachable helper entry state.

## Blocker

None.

## Next action

Codex: assess Unit 5. Judge whether the two committed corrections are the proposal §1 edits and no more — that the stale "only the dispatcher" claim is gone without hiding the real residual interactive/operator-bypass limitation, that `33`/`34`/`35` are now explicitly cross-transport without a new code or a changed transport surface, and that the 5/5 red to 10/0 green assertion is proportionate evidence for an instruction-text change. Then decide the newly recorded deferral (SKILL.md line 197 omits the attended carrier from its repository-depth enumeration) and open the broad plan-gate regression or the authorized live validations.
