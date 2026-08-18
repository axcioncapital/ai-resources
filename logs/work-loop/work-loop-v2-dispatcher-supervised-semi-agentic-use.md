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

Standard. Implementation mode. Unit 17 — refuse missing option values

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 16 is accepted at `2f1cb67e592c7fb266c75643ab4cd860c178272e`. It established that new length or character validators for run IDs, terminal outcomes, reason codes and protocol versions would be ceremony because current producers and consumers already enforce stronger equality or closed-set boundaries; the only reachable Change set A control-token defect is that a value-taking option supplied as the final argument can leave the parser looping instead of returning a clean usage refusal. This unit closes that one defect and permanently proves the adjacent existing unknown-option refusal, directly serving the approved rule that every invalid pre-admission invocation returns clear stderr and a nonzero exit.

Dominant deliverable: a fail-fast argument-parser refusal contract for a value-taking option with no following argument.
Evidence required in this hop: red-to-green executable proof for the missing-value behavior, permanent proof that an unknown option name is refused, syntax checks, and the focused parser test slice only.
Evidence explicitly deferred: interpretation of a following option-looking token as a value; a general `--` option-termination policy; all other hostile-input families; `too-many-lines` defence-in-depth proof; Change set B execution budgets including `--max-hops`; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: a safely time-bounded targeted case demonstrates that one current value-taking option supplied as the final argument does not return the required exit `10` refusal.

Required outcome:

- Every currently supported value-taking option, when it is the final argument and therefore has no following value, must terminate promptly before admission with exit `10` and clear stderr naming the offending option and the missing-value condition.
- Preserve the current meaning of explicitly supplied empty values and of values that merely begin with `-`; this unit owns only the objectively absent second argv element. Stop rather than inventing a broader option-value policy.
- Keep the repair at the existing argument-parser boundary and proportionate to this defect. Do not add a new validation framework, token abstraction, parser rewrite or per-option bespoke machinery where one shared boundary decision is sufficient.
- Preserve the existing closed default refusal for unknown option names and add permanent executable proof that an unknown name returns exit `10` with clear stderr.
- Preserve all valid option parsing and all existing admission behavior.

Check against the repository:

1. Verify the accepted Unit 16 commit and its current parser claim before editing: the value-taking branches in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` read `${2:-}` and then `shift 2` inside the argv loop, while `set -uo pipefail` does not make a failed shift terminate the script.
2. Verify the complete current set of value-taking option names from the parser rather than copying the discovery count blindly. The implementation and permanent proof must cover that current set through one compact shared path or data-driven case.
3. Verify the current unknown-option default branch and the absence of a committed executable assertion for it in `dispatch.test.sh` before adding proof.
4. Treat Unit 16's statement that the hang has “no stderr” as non-governing wording. The required distinction is a prompt, intentional usage refusal versus a parser that fails to terminate; evidence must assert the intentional `STOP [10]` message and exit, not the absence of shell noise in the old behavior.

Required fail-capable evidence:

- Show the targeted missing-value case failing against the pre-edit dispatcher under a bounded watchdog, then passing after the edit with exact exit `10` and an intentional stderr reason that identifies the option.
- Add one compact permanent case that exercises every current value-taking option as the final argv element. It must be capable of distinguishing a prompt exit `10` from the old loop and must not launch an actor, acquire an owner or lease, write run evidence, move HEAD, or alter the checkout.
- Add one permanent unknown-option case that asserts exit `10`, `STOP [10]`, and the rejected name. Do not multiply this into an option-name matrix.
- Report the focused new-case result and `bash -n` results for both changed shell files. Do not run the full dispatcher suite in this unit.
- Report the exact changed paths and confirm `logs/friction-log.md` remains unstaged and otherwise untouched.

Capability subset: baseline only — read the approved plan, accepted Unit 16 evidence, current dispatcher and focused tests; edit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state; run local bounded parser tests and shell syntax checks; and commit those task-scoped changes. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No model launch, authentication attempt, network, external service, full-suite run or operator-reserved capability is permitted.

Completion condition: one minimal parser repair and permanent focused proof make all current value-taking options fail fast when their following value is absent, pin the existing unknown-option refusal, preserve valid parsing, commit only the allowed paths, and return with `turn: codex`.

Stop and hand back if the current parser claim is false, if a shared repair would change how explicit empty or option-looking values are interpreted, if the focused proof cannot safely bound the old hang, or if the repair requires broader parser policy or architecture.

## Latest result

Inspected (2026-08-18):

- Claim (1): HOLDS — `2f1cb67e` exists and touched only this state file (1 file, +51/−27). In `dispatch.sh`, all eleven value-taking branches read `${2:-}` and then `shift 2` inside the `while [ $# -gt 0 ]` loop at 1435–1457; `grep -nE '^set '` returns exactly one line, `set -uo pipefail` at 287, so there is no `-e` and a failed shift's nonzero return is discarded.
- Claim (2): HOLDS — the value-taking set was re-derived from the parser, not copied: `grep -E '^[[:space:]]+--[a-z-]+\).*shift 2'` returns exactly eleven — `--checkout --task --max-hops --timeout --deadline --codex-bin --claude-bin --allow-path --claude-deny --log-dir --actor-cmd`. Four flag branches (`--dry-run --status --carry-one --unattended`) take no value, plus `-h|--help` and the `*)` default. The new permanent case reads this same list out of the dispatcher at run time rather than restating it.
- Claim (3): HOLDS — the default branch is `dispatch.sh:1455`, `printf 'STOP [10] unknown argument: %s\n' "$1" >&2; exit 10`. Searched `dispatch.test.sh` for `unknown argument|unknown-argument|bogus|nosuch|--not-an-option|--wat|--zzz`: no match. All ten `expect_rc 10` sites assert a *value* check (4274, 4276, 4361, 5426) or an evidence-location refusal (8988, 10868, 10939, 11083, 11116, 11155); none asserts the option-name grammar.
- Claim (4): accepted as governing, and Unit 16's wording is corrected here. The claim under test is a prompt, intentional usage refusal versus a parser that does not terminate — not the absence of shell noise. Every assertion below is written that way: the bound reports `124` when the run had to be killed, and the pass condition is an explicit `STOP [10]` naming the option.

Result: the argv arity defect is closed and both parser refusals now have permanent proof. One shared boundary decision was added at the existing parser, deliberately **not** a second list of value-taking option names: the loop records `$#` before the `case` and refuses if the iteration consumed nothing. That states the invariant every branch already satisfies — each one shifts, or exits — so a value-taking option added later is covered by the same three lines, with no list to fall out of step. It owns only the objectively absent element: an explicitly empty value and a value beginning with `-` are real argv elements, `shift 2` succeeds, and both keep exactly today's meaning. Both changed files are pure additions (+27 production, +109 test, 0 deletions), so no existing branch was altered.

Evidence:

- **Red, before the edit, under a bounded watchdog.** `dispatch.sh --checkout <dir> --task` was run against the pre-edit dispatcher in a scratch directory outside the repository, backgrounded with a 5-second poll: it was still alive at the bound, was killed, produced 0 bytes on either stream, and left no survivor process. That is the `Primary edit begins after:` gate — one current value-taking option, supplied as the final argument, did not return the required exit `10`.
- **Green, after the edit.** Focused slice rebuilt from the committed test file (header lines 1–361 plus the new cases) and run against the real dispatcher via the harness's own `DISPATCH_BIN` override: `pass=48 fail=0`. All eleven options return exit `10` with `STOP [10] <option> requires a value, and no argument followed it`; none reached the 8-second bound.
- **Fail-capable, by mutation.** A scratch copy of `dispatch.sh` with the single line carrying the `# argv arity boundary` marker deleted differs by exactly 1 line and parses. Against it the same slice returns `pass=15 fail=33` — every option's three assertions go red, and the three failures are the arity claim, not a collapsed exit code. The mutant is uncommitted.
- **The control discriminates rather than blanketing.** Under the mutant, case 68b still passes (it proves the untouched `*)` branch) and both preserved-meaning assertions still pass (the mutant does not change those paths). So the 33 failures isolate the arity boundary and nothing else.
- **Preserved behaviour, asserted not assumed.** `--task ""` reaches the existing `--task is required` refusal at exit 10; `--task -foo` reaches the existing task-id grammar at exit 12; `--bogus` still exits 10 naming the option; flags, `--deadline 0` and `--help` are unchanged.
- **Pre-admission absences, asserted once for all eleven** because they are a property of the one shared boundary: no shared lease root created, no actor call, no run-evidence directory, HEAD unmoved, working-tree manifest byte-identical, `git status` unchanged.
- `bash -n` is clean on both changed files. The full dispatcher suite was **not** run, per the brief. `work-loop-state.sh`, `work-loop-owner.sh` and `work-loop-lease.sh` are byte-identical to HEAD.
- Changed paths committed: `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `.../dispatch.test.sh`, and this state file. `logs/friction-log.md` was already modified before this unit began, was not touched by it, and remains unstaged. No stray dispatcher processes survive; every backgrounded run was awaited or killed inside this hop.

One deferral, recorded and not done: the new case bounds each invocation at 8 seconds via a poll-and-kill helper because this host has neither `timeout` nor `gtimeout`. That is a wall-clock bound, so on a heavily loaded machine a correct refusal could in principle be misread as the hang. It is not a real risk at the current margin — the refusals return in milliseconds against an 8-second bound — and tightening it would mean a portable timeout helper, which is broader than this unit.

## Blocker

None.

## Next action

Codex: assess Unit 17. Three questions. (1) Is the progress-measuring guard accepted as the right shared boundary, given it deliberately avoids a second list of value-taking option names and therefore also covers options added later — or is a named list preferred despite the drift it reintroduces? (2) Is the evidence sufficient: red under a bounded watchdog before the edit, `48/0` after, and a one-line mutation control returning `15/48` that leaves case 68b and both preserved-meaning assertions green? (3) Accept or reject the recorded deferral that the new case bounds runs by wall clock, because this host has no `timeout` binary. Change set A's hostile-input boundary now has no known open behavior gap; the next unmet clause is Codex's call.
