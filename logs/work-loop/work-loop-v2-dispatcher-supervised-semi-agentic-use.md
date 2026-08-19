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

Standard. Discovery mode. Unit 25 — locate trustworthy effective permission evidence

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 24 is accepted at `91206e2c376bcc9ea53b9633b29b7595329cc068`. The attended dispatcher now accepts only per-invocation `default | acceptEdits`, passes that exact request to Claude, records it as requested, and refuses wider or inapplicable combinations before admission. Effective mode remains honestly `unavailable`, as Unit 24 deliberately required.

The approved Change set B contract separately requires the effective permission mode to be recorded. The current attended capture uses JSON rather than the unattended `stream-json` form whose `system/init` event exposes effective runtime configuration. This discovery determines whether trustworthy effective-mode evidence already exists on an attended, in-scope surface before any capture-format or parser change is proposed.

Dominant deliverable: identify the smallest trustworthy source for attended effective permission mode, or prove none is available in the current runtime contract.
Evidence required in this hop: a bounded producer-to-capture map for attended Claude output and local runtime metadata, the exact field/value semantics if present, trust/failure behavior, and one implementation target only if justified.
Evidence explicitly deferred: implementation or test changes; denial/resume; permission-prompt handling; retries and budgets; unattended release claims; full regression; Change sets B remainder, C and D; live trials; adoption review; cleanup; merge, push, deployment and destructive cleanup.

Required outcome:

- Inspect the installed Claude CLI's local help/version surface, existing committed attended/unattended captures or fixtures, and current dispatcher capture readers for a runtime-authored effective permission-mode value. Do not launch a live model or use network access.
- Distinguish requested argv, repository/user settings, actor prose and runtime-authored effective configuration. Only the last can satisfy `permission_mode_effective`.
- Determine whether attended JSON already carries it; whether `stream-json` `system/init` carries it; and whether switching attended capture format would preserve the final result/denial evidence currently consumed.
- If no trustworthy source exists, say so and identify the exact plan conflict or smallest product-output change needed. Do not infer effective mode from the requested flag.
- Return `COVERED`, `IMPLEMENTABLE GAP`, `RUNTIME CAPABILITY GAP`, or `UNKNOWN`, with one smallest next target. Do not design a general capture parser or import unattended containment work.

Check against the repository:

1. Verify Unit 24 commit and bounded file scope without rerunning tests.
2. Verify the approved requested/effective wording and current `permission_mode_effective=unavailable` producer.
3. Search existing committed run captures/fixtures for runtime-authored initialization fields, then inspect current JSON/stream-json readers only as needed.
4. Use local CLI `--help`/`--version` or a disposable fake-output fixture only if repository evidence does not settle the output contract. No authenticated model request.

Required fail-capable evidence:

- Name the exact artifact and field that would carry effective mode, who authors it, and how absence/malformed/conflicting values would fail closed.
- Show whether `default` and `acceptEdits` are distinguishable on that surface without treating argv as observation.
- State the compatibility effect on permission-denial extraction and final result capture if the attended format changes.
- Confirm no production, test, plan or documentation file changed and no model/test suite ran; only this state file may be committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline read-only investigation plus committing this task state — inspect the approved plan, Unit 24, current dispatcher/tests, committed local captures and installed CLI help/version. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No source mutation, live model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback establishes whether and how the attended dispatcher can truthfully record effective permission mode using an existing runtime-authored surface, changes only this state file, and returns with `turn: codex`.

Stop and hand back if evidence requires a live paid model request, if the runtime exposes no effective-mode field, or if satisfying the plan would require changing permission policy rather than observing it.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS — `git show --stat 91206e2c376bcc9ea53b9633b29b7595329cc068` returns the Unit 24 handback touching exactly three paths: this state file, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`. No test suite was rerun.
- Claim (2): HOLDS — searched `dispatch.sh` for `permission_mode_effective`; the sole producer is line 886, `tr_kv permission_mode_effective unavailable`, an unconditional literal. `permission_mode_requested` is produced by `result_permission_mode_requested()` (lines 713–725) from `PERMISSION_MODE`, the same variable the attended argv reads (line 4374). The comment at lines 692–697 states the separation the plan requires: the effective mode is never derived from the request, and only the child's own `system/init` event establishes it.
- Claim (3): HOLDS — searched every committed file for `permissionMode`; four hits, one of them a capture: `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probes/unattended-effective-policy-2026-08-07.raw.txt`. Parsed all 12 committed `runs/*.claude.out` attended captures and that probe; results below. The only capture consumer, `permission_denials_in()` (line 3973, called once at line 4788), was inspected in full.
- Claim (4): HOLDS — repository evidence settled the field but not the CLI's own argv contract, so `claude --version` and `claude --help` were read locally (2.1.220), plus three `--help` invocations that exit at argv parsing. No authenticated model request was made.

**Verdict: IMPLEMENTABLE GAP.** A trustworthy runtime-authored effective-mode field exists in the product, on a format the attended path does not currently use.

**The artifact and field.** `permissionMode`, a top-level key of the child's own `system/init` event — the first line the Claude Code runtime emits under `--output-format stream-json`. Authored by the runtime, not by the dispatcher, not by settings, not by actor prose. Committed evidence, probe line 271: `{"type":"system","subtype":"init",...,"permissionMode":"default",...}`.

**Attended JSON does not carry it.** The three parseable committed attended captures (`20260805T152939…hop2`, `20260805T154555…hop1`, `20260811T113106…hop1`) each hold one object whose complete key set is `api_error_status, duration_api_ms, duration_ms, fast_mode_disabled_reason, fast_mode_state, is_error, modelUsage, num_turns, permission_denials, result, session_id, stop_reason, subtype, terminal_reason, total_cost_usd, type, usage, uuid` — no permission field of any kind. `--output-format json` emits one `result` object and no `system/init` event, so the attended surface cannot observe effective mode today.

**The field is observation, not an argv echo.** Two independent proofs. First, the committed probe passed no `--permission-mode` at all (the unattended branch, `dispatch.sh:4346–4353`, deliberately carries none) and `system/init` still reported `default` — a runtime-resolved value with no argv to copy. Second, `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md:56–57` records the fail-capable red/green pair read off that same event: `bypassPermissions` **before** the explicit flag, `default` **after**. The red half is decisive — the field reported the checkout's inherited `defaultMode: bypassPermissions` when argv carried nothing, which an argv restatement could not do.

**`default` vs `acceptEdits` is NOT directly observed, and this is the one residual.** Searched all of `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/` for `acceptEdits`: no match in any committed capture. What is established is that the field tracks actual resolution across three distinct values in the same enum family (`bypassPermissions`, `default`, and the runtime default), so there is no mechanism by which it would report `acceptEdits` as anything else. Confirming it directly requires launching a live paid model under `acceptEdits`, which this brief forbids. Stated as unobserved rather than inferred.

**Changing the attended format preserves the evidence currently consumed.** The probe's terminal `result` event key set is identical, key for key, to the attended `json` object key set quoted above — including `permission_denials`, `result`, `is_error`, `session_id` and `usage`. So `stream-json` is a superset of today's capture, exactly as `dispatch.sh:4336–4339` claims for the unattended path. `permission_denials_in()` already reads both shapes without knowing which it is on: `denials_via_jq()` uses `jq -s`, which slurps a single object and a line-per-event stream alike, and `denials_via_python()` tries a whole-file parse first and falls to line-by-line on `ValueError` (lines 3941–3954). Nothing else reads the capture — `LAST_CAPTURE` is otherwise only reported as a path (lines 897, 4791, 4814, 4821). `--verbose` must accompany `stream-json` under `--print` (CLI help; already asserted for the unattended path by `dispatch.test.sh` case 32).

**How it fails closed.** Absent `system/init`, absent key, a non-string value, or two init events disagreeing all resolve to `unavailable` — the token this record already uses for "established as unreadable", distinguished from `none` at `owner_declaration()` (lines 740–748). Falling back to `PERMISSION_MODE` on absence is the request-to-effective promotion `dispatch.sh:692–697` forbids and must not be the failure path.

**The cost, stated.** Capture volume. The probe is 68KB for one short hop; attended hops run 26+ turns. `dispatch.sh:4341–4343` names that price as worth paying only where nobody is watching; switching attended pays it on every hop.

**Plan conflict: none.** Change set B (plan line 231) requires recording requested and effective mode. The runtime does expose effective mode; it is on a format the attended path does not use. No permission policy changes — this is observation only.

**Deferral, not implemented (side finding).** `claude --help` on 2.1.220 documents `--permission-mode` choices as `acceptEdits, auto, bypassPermissions, manual, dontAsk, plan` — `default` is absent from that list, yet `dispatch.sh:4374` passes it on every attended launch. Verified by argv parsing alone: `claude --permission-mode zzzinvalid --help` exits 1 with "Allowed choices are…", while `claude --permission-mode default --help` and `--permission-mode acceptEdits --help` both exit 0. So `default` is accepted but undocumented, and a future CLI could drop it without warning. Out of this unit's scope; recorded so it is not lost.

**Smallest next target, one only.** On the attended launch branch only (`dispatch.sh:4373`), replace `--output-format json` with `--output-format stream-json --verbose`, add one reader returning the first `system/init` event's `permissionMode` or `unavailable`, and produce `permission_mode_effective` from that reader instead of the literal at line 886. No general capture parser, no unattended containment work. The test surface already exists: `dispatch.test.sh` case 32n builds a format-regression mutant, and case 71b asserts the honest `unavailable` that this change would replace.

Evidence: `git status --porcelain` reports exactly two modified paths — `logs/friction-log.md` (pre-existing, unstaged, untouched here) and this state file. No production, test, plan or documentation file changed; no test suite and no model ran. The claim is fail-capable in both directions: had attended JSON carried a permission field, the parsed key sets above would have shown it and the verdict would have been `COVERED`; had `system/init` reported the same value regardless of environment, the P0-F red/green pair would have read `default` on both halves and the verdict would have been `RUNTIME CAPABILITY GAP`.

## Blocker

None.

## Next action

Codex: assess Unit 25's discovery. Effective permission mode is available on `system/init`'s `permissionMode` under `stream-json` and absent from the attended `json` object; switching the attended format is a superset that preserves denial and final-result extraction. Decide whether to open the named smallest target as the next unit, how to treat the unobserved `acceptEdits` value given that confirming it needs a live paid launch, and whether the undocumented `--permission-mode default` deferral is recorded or acted on.
