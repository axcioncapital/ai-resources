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

Standard. Implementation mode. Unit 26 — record attended effective permission mode

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 25 is accepted at `b3b4e02a336102213fca70e4b489dbac0ab602f2`. It established that attended JSON does not expose effective permission mode, while the runtime-authored `system/init` event under `stream-json` exposes top-level `permissionMode`. Existing denial readers already support both capture shapes, and the terminal `result` event preserves the fields consumed today.

This is a genuine Change set B gap: `permission_mode_requested` is now truthful, but `permission_mode_effective` remains an unconditional `unavailable`. This unit changes only attended capture/observation so the terminal result records runtime-authored effective mode after an attended launch. Enforcement of missing/mismatched effective mode and denial/resume are later behaviors and must not be imported.

Dominant deliverable: populate attended `permission_mode_effective` from the runtime-authored `system/init.permissionMode` value.
Evidence required in this hop: one targeted failing fake attended stream case before the edit; passing `default` and `acceptEdits` fixtures; table-driven absent/malformed/non-string/conflicting fail-closed cases; one focused denial/final-result compatibility case; focused tests only.
Evidence explicitly deferred: live paid acceptEdits observation; enforcement or takeover on unavailable/mismatched effective mode; denial and resume; permission-prompt handling; retries/budgets; undocumented `default` CLI compatibility until complete runtime preflight; unattended release claims; full regression; Change sets B remainder, C and D; live trials; adoption review; cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused attended fixture carries `system/init.permissionMode=acceptEdits` but the terminal result still records `permission_mode_effective=unavailable`.

Required outcome:

- Change only the attended Claude launch from `--output-format json` to `--output-format stream-json --verbose`. Preserve the attended permission argv, deny rules, cwd and every other launch property.
- Add one narrow production reader for the attended capture's runtime-authored `system/init.permissionMode`. Accept exactly one consistent string value; absent, malformed, non-string or conflicting init values yield `unavailable`.
- Never derive or fall back to `PERMISSION_MODE`, argv, settings, actor prose or the terminal result event. Requested and effective remain independently sourced.
- Populate `permission_mode_effective` from that observation for terminal results finalized after an attended actor capture exists. Pre-launch, simulated and otherwise unobserved terminals remain `unavailable`.
- Preserve current permission-denial extraction and final result capture under the new superset format.
- Do not enforce requested/effective equality, create operator takeover, alter unattended capture, add a general event parser, or change permission policy in this unit.

Check against repository:

1. Verify only the current attended JSON launch and literal `unavailable` producer needed to place the edit; Unit 25's accepted capture-format discovery is settled and must not be rerun.
2. Reuse existing fake Claude/capture fixtures and nearest terminal-result validators. No new harness.
3. If the focused compatibility case contradicts Unit 25 by showing that stream-json does not preserve the terminal result/denial fields, stop and hand back.

Required fail-capable evidence:

- Quote pre-edit failure for fake attended system/init acceptEdits yielding unavailable.
- Show default and acceptEdits stream fixtures each make terminal result effective match runtime event while requested remains independently correct.
- Show absent, malformed, non-string and conflicting init values produce unavailable, not requested.
- Show permission denials are still extracted and final result capture remains consumable.
- Treat the two preceding fixture groups as the negative controls: ignoring `system/init` fails the positive fixtures, and falling back to requested fails the unavailable cases. Do not build a separate mutation harness.
- Run only new/directly affected focused cases, exact commands/counts, defer full suite.
- Report implementation commit, only `dispatch.sh`, `dispatch.test.sh`, and this state file committed; leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read, inspect, focused local tests, edits inside the dispatcher implementation/tests and this state file, and a local commit by Claude. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No live model/network/full suite, operator-reserved capability, merge, push, deployment or destructive cleanup.

Completion condition: one committed implementation handback records runtime-authored attended effective permission mode without conflating it with the request, preserves existing capture consumers, changes only the bounded files, and returns with `turn: codex`.

Stop and hand back if the change needs a live paid model, a general event parser, a permission-policy or unattended-path change, or cannot preserve denial/result extraction.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS — searched `dispatch.sh` for the attended launch and the effective-mode producer. The attended branch was the single `run_bounded … --output-format json --permission-mode "$PERMISSION_MODE" --disallowedTools "${a_deny[@]}"` at line 4373, with its `say "  cmd: …"` echo at 4366; the producer was the unconditional literal `tr_kv permission_mode_effective unavailable` at line 886. Both are exactly where Unit 25 recorded them. No part of Unit 25's capture-format discovery was rerun.
- Claim (2): HOLDS — searched `dispatch.test.sh` for the fixtures the brief names. The live fake-binary technique (`FAKE60H`, case 60h, lines 9872–9882) keeps `MODE=live` while forking no model; the terminal-result readers `res_field()`, `run_id_of()`, `res_count()`, `expect_rc()` (lines 314–333) and `argv_has()`/`argv_pair()` (5023, 355) already exist. Case 72 reuses all of them; no new harness was written.
- Claim (3): HOLDS, in the direction that permits the unit to proceed — the focused compatibility case does NOT contradict Unit 25. A `stream-json` capture whose terminal `result` event carries `permission_denials` still produces exit 37 naming the exact target, and the terminal record still finalizes to its `result_complete=yes` sentinel (case 72e, both green). Had it contradicted Unit 25, this would have been a hand-back rather than an implementation.
- Packaging lines: HOLD — `Dominant deliverable:` names one deliverable, `Evidence required in this hop:` and `Evidence explicitly deferred:` are both filled, and `Primary edit begins after:` is present as Implementation mode requires.

Result: `permission_mode_effective` is now read from the child runtime's own `system/init.permissionMode` on attended live Claude hops, instead of being the literal `unavailable` on every path. Three changes, all inside `dispatch.sh`: the attended launch moved from `--output-format json` to `--output-format stream-json --verbose` (argv otherwise byte-identical — same permission request, same nested-actor denies, same cwd, same prompt); a narrow two-tier reader (`init_modes_via_jq` / `init_modes_via_python`, resolved by `attended_effective_permission_mode`) that returns a value only when exactly one `system/init` event yields one consistent string of at most 32 characters matching `[[:alpha:]][[:alnum:]_-]*`, and `unavailable` otherwise; and `result_permission_mode_effective()`, guarded on fork / live / claude / attended, wired into the record. The reader has no path to `PERMISSION_MODE`, the argv, any settings layer, actor prose or the terminal `result` event — the event selector is `type == "system" and subtype == "init"`, so the result event is excluded structurally. No terminal-result field was added, no permission policy changed, no unattended behaviour changed, no general capture parser introduced.

Evidence: focused cases only, as the brief requires. New Case 72 in `dispatch.test.sh` (38 assertions across 72a–72g). Existing directly-affected cases 31, 31b, 32–32n, 43–43d, 50a–50d, 60h and 71a–71f were rerun as a second focused slice.

- **Red half — the targeted pre-edit failure.** Command: `REPO_ROOT=<checkout> DISPATCH_BIN=<HEAD copy of dispatch.sh> bash <case-72 slice>`. Result `pass=31 fail=7`. The failing lines, verbatim: `FAIL 72a — permission_mode_effective=acceptEdits, read from system/init` (`got: unavailable — the capture … carries permissionMode acceptEdits`); `FAIL 72b — permission_mode_effective=default`; `FAIL 72c — requested=acceptEdits while effective=default` (`requested=acceptEdits effective=unavailable`); `FAIL 72e — and the denial terminal still records the effective mode`; and the three 72f argv lines (`stream-json`, `--verbose`, `the plain json output format is gone`) against `argv: -p /work-loop-v2 eff-clean-task --output-format json --permission-mode default --disallowedTools …`.
- **Green half.** The same command against the edited `dispatch.sh`: `pass=38 fail=0`. `default` and `acceptEdits` stream fixtures each make the terminal record's effective mode match the runtime event; 72c holds `requested=acceptEdits` beside `effective=default` from one run, so neither field can be derived from the other; the eleven rows of 72d (absent init, absent key, number, null, boolean, object, array, empty string, two conflicting init events, an unparseable line, an empty capture) each report `effective=unavailable` while `requested` stays `acceptEdits`; 72e keeps exit 37 with the exact denied target and a complete record; 72g's three guard rows (unattended, simulated, live Codex) each report `unavailable` from a capture that does contain a readable init event, so the guard rather than a missing fixture is what produces it.
- **Negative control 1 — ignoring `system/init`.** That is the pre-edit dispatcher above, and it fails 72a, 72b, 72c and 72e's effective assertion. The positive fixtures cannot pass a reader that does not read the event.
- **Negative control 2 — falling back to the requested mode.** A one-line mutant making `result_permission_mode_effective()` substitute `result_permission_mode_requested()` whenever the reader returns `unavailable` was run against Case 72: `pass=27 fail=11`, all eleven failures being the whole of 72d. The unavailable cases cannot pass a reader that falls back. No mutation harness was added to the suite; both controls are the fixture groups the brief named.
- **Directly-affected existing cases.** Second focused slice, `pass=347 fail=1` on the edited dispatcher. The single failure, `the --settings argument points at the written profile`, is identical on the pre-edit baseline (`pass=347 fail=1`, same line): it compares `/var/folders/…` from `ls` against `/private/var/folders/…` in the argv, a macOS `$TMPDIR` symlink artifact unrelated to this unit. Case 32j's three attended-format assertions were inverted deliberately — they asserted the old `--output-format json` and are replaced by the opposite claim, with the contained-profile flags still asserted absent so the inversion cannot swallow a widening. Comments in cases 32n, 50a, 60h and 71b that stated no `system/init` reader exists were corrected; their assertions are unchanged and still green for the honest reason (those stubs emit no stream).

Deferred, recorded and not implemented (§ 5): everything the brief lists under `Evidence explicitly deferred` — chiefly the live paid `acceptEdits` observation, which is what would turn "the reader reports what `system/init` says" into "the real runtime says `acceptEdits` there". Two further items noticed during this unit and not acted on: the capture-volume cost now falls on every attended hop as well (the probe measured 68KB for one short hop, and attended hops run 26+ turns), which is a real operating cost worth a decision rather than a silent acceptance; and the sliced-suite `--settings` artifact above is a genuine harness fragility on macOS, but fixing it is outside this unit's files.

## Blocker

None.

## Next action

Codex: assess Unit 26. The attended launch now captures `stream-json`, the effective permission mode is read only from the runtime-authored `system/init` event and fails closed to `unavailable` on every unresolvable shape, and denial plus final-result extraction are preserved under the new format. Decide whether the fail-closed boundary and the two negative controls are sufficient without the deferred live `acceptEdits` observation, whether the attended capture-volume cost needs its own decision, and what the next unit in Change set B is.
