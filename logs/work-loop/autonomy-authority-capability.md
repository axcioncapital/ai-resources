---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 31 — implement T6's documentation-only capability envelope, control map, and state-content convention in the Codex Work Loop skill.

Named reason for the loop: T6 defines a cross-cutting capability boundary and evidence convention that must be complete, technically honest, and independently assessed before it becomes operating guidance.

## Brief
T5 is accepted at commit `2a50b3219357fdfaacdf8efb640a29f4db53475d`: `/session-plan` now distinguishes session pause posture from per-action authority while preserving every existing posture and criterion. T6 is the nearest unmet tracer in the approved plan. This unit documents the MVP capability envelope and what the current carrier does and does not enforce; it changes no runtime enforcement.

Governing authority: the re-frozen implementation plan at `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, especially § 3.4 and T6; canonical core §§ 4 and 8; live `.agents/skills/work-loop-v2/SKILL.md`; and live `scripts/axcion-harness-v0.2/carry-turn.sh` for verify-first technical facts. The approved plan fixes the following semantic content:

- Baseline-granted: read/search/history/diagnosis; local tests, lint and builds; edits within task-scoped paths; local branches; local commits through Claude; reversible local refactoring; evidence written to the existing state and approved repository paths.
- Operator-reserved and not baseline: deploy/release; public, customer, employee or partner communication; credentials/secrets; destructive shared/production-state change; force-push/shared-history rewrite; protected-branch merge; irreversible deletion; permission/sandbox/policy changes used to authorize the current action; disabling logging, containment or verification.
- Separately pre-authorizable, with an empty current set: read-only network to approved domains; approved-registry dependency resolution; approved MCP/remote test services; approved branch push/namespace; draft PR creation; remote CI; bounded reversible writes to external development systems.
- Control truth: identity is prevented; task-path violations are detected after the hop, not prevented; sandbox and network/tool restriction are deferred and not carrier-verified; bypass mode is prevented; nested-actor requests are prevented and occurrence is observed; push/merge/deploy/credential/destructive-operation denials are required per invocation but are not carrier defaults; timeout/deadline/one-hop limits are prevented; before/after repository evidence is enforced; missing terminal evidence cannot become success.

Required outcome: add the smallest sufficient section to the skill's existing brief-preparation guidance that (1) states all three envelope sets and the current empty pre-authorized set, (2) maps every non-deferred control to its real enforcement surface, strength and fail-capable evidence while labelling the two deferred controls honestly, (3) documents the exact deny rules a baseline Standard carrier invocation must pass, and (4) shows how a selected capability subset belongs inside `## Brief` and how the observed/requested runtime profile belongs inside `## Latest result`, without adding a state heading. Sandbox/network claims must say `requested` or `selected, not carrier-verified`, never `effective` unless an enforcement surface actually observed them.

Scope: `.agents/skills/work-loop-v2/SKILL.md` and this state-file handback only. Excluded: executable core, carrier, dispatcher, commands, autonomy rules, session plan, proposal, approved plan, tests, routing index, new state fields, connected-development enforcement, and T7–T9. Preserve unrelated `logs/friction-log.md` changes.

Claims to check before editing:

1. The live skill contains no capability-envelope/subset/runtime-profile convention matching T6, and a suitable location exists in its current brief-preparation guidance.
2. The live carrier and its current tests support the plan's control-strength map and allow exact baseline `--claude-deny` rules to be derived without changing runtime code.
3. The executable core's five-field contract and example are unchanged at core blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136` and need no T6 edit.
4. T6's paired `denials=` evidence can be produced through an existing safe non-nested carrier fixture or actor path. A Claude or Codex process must not be launched recursively from this Work Loop invocation.

Required evidence:

- Show the T6 concepts are absent before and present after; provide the bounded skill diff and resulting blob/commit.
- Account for every envelope member and every § 11 control exactly once. For each non-deferred control, name surface, true strength and a field/check that can expose failure; label sandbox plus network/tools deferred rather than met.
- Show a sample `## Brief` selected-subset block and `## Latest result` runtime-profile block without any new state heading, with sandbox/network described as requested or selected but not carrier-verified.
- Prove the executable core file and its five-field example are unchanged.
- Produce the plan-required paired `denials=` evidence using a repository-supported non-nested fixture/actor path: required baseline deny rules present versus omitted rules yielding empty `denials=`. If the live carrier cannot produce this safely without nested Claude/Codex execution, stop and hand back that false premise instead of weakening or fabricating the evidence.
- Run the relevant carrier tests and `work-loop-v2-slice-1.test.sh`; compare the latter with the known 307 passed / 1 failed baseline. No new failure is allowed, and the existing routing-index/live-installation drift remains deferred.

Completion condition: the skill alone carries the complete T6 convention, all documentation claims match live enforcement, all fail-capable evidence passes, only the skill plus this state handback are committed, `turn: codex`, and Claude stops before T7.

Stop conditions: hand back if a plan premise is false, the paired carrier evidence requires nested model execution, a control cannot be mapped honestly, exact deny rules cannot be derived, the core or runtime code would need editing, or any regression adds a failure. Do not silently narrow the envelope or round detected/requested controls up to prevented/effective.

## Latest result

Unit 31 did not begin. Claim (4) is false, so nothing was implemented and `.agents/skills/work-loop-v2/SKILL.md` was not edited.

Inspected (2026-08-15):
- Claim (1): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` (530 lines) for `capability envelope|capability subset|runtime profile|pre-authoriz|operator-reserved|claude-deny|denials=`. Exactly one hit, line 266, and it is not a T6 convention: it describes the **dispatcher's** `--unattended` flag inside `#### Unattended runs — when the operator is leaving`. No envelope, subset or runtime-profile convention exists. A suitable location does exist: `## Opening a unit and writing the brief` (386) and its six subsections through 462, which is the same brief-preparation guidance T3 and T3a already touched, as § 3.4's placement decision assumes.
- Claim (2): HOLDS — every line the control map cites resolves. `carry-turn.sh:201` is `CLAUDE_DENY=()`; `:224-229` is `CLAUDE_DENY_MANDATORY=(` with all four nested-actor rules; `:314-315` is the `--dangerously-skip-permissions|--bypass-permissions|--permission-mode` refusal; the two-value permission-mode allowlist is `case "$CLAUDE_PERMISSION_MODE" in` / `default|acceptEdits` at `:363-364` (the plan cites `:366`, which lands on the `*)` fallback inside the same block — the block is right, the line number is off by two); `:182` is the single-classification comment and `:241-242` is `denials`'s three-state honesty note. `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` → **285 passed / 0 failed**, matching the map's "285/0". Exact baseline `--claude-deny` rules can be derived and passed with no runtime change — proved live below.
- Claim (3): HOLDS — `git hash-object plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returns `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`. Its § 4 five-field table and example state file are intact and need no T6 edit; this unit read the core and did not touch it.
- Claim (4): **FALSE** — the paired `denials=` evidence cannot be produced by any fixture, because `denials=` is not a function of the deny-rule set. Searched `carry-turn.sh` for `denials|DENIALS|R_DENIALS|disallowedTools|claude-deny|CLAUDE_DENY`: `R_DENIALS` is set at `:967-970` from `read_denials` (`:508-525`), which parses the **child's own** `permission_denials` array out of its JSON capture. The `--claude-deny` rules are a separate thing — appended to the mandatory set at `:879-882` and passed as `--disallowedTools` at `:899`. Nothing connects them.

**The live proof, run non-nested.** Two real `carry-turn.sh` invocations, identical except for the deny rules, with a fake actor passed through `--claude-bin` — the same seam `carry-turn.test.sh` uses at its 40-plus `--claude-bin "$FAKEBIN"` call sites. No `claude` or `codex` process was launched; both runs happened in throwaway repositories outside this checkout.

```
A (baseline deny rules passed): RESULT outcome=CARRIED code=0 ... denials=0 partial=0 actors=1 nested=0
B (no deny rules passed):       RESULT outcome=CARRIED code=0 ... denials=0 partial=0 actors=1 nested=0

argv, A: 1 × [Bash(git push:*)]   1 × [Bash(claude:*)]
argv, B: 0 × [Bash(git push:*)]   1 × [Bash(claude:*)]
```

`denials=` is byte-identical across the pair. The only surface that discriminates is argv. An earlier run of the same probe that stopped before launch (exit 18) reported `denials=n/a`, confirming the field's three states are `n/a` / `0` / `<n>` / `unavailable` — all describing whether the child's denial evidence was readable, never which rules were requested.

**Why no fixture can rescue it.** The fake actor's `permission_denials` output is written by the fixture action (`denied`, `dirty-noop`, …, `carry-turn.test.sh:104-140`), independent of argv. A real actor's is driven by which tools it happened to attempt. So a pairing on `denials=` either shows `0` on both sides — proving nothing — or shows a difference the fixture author put there, which would be fabricated evidence, exactly what the brief's stop condition forbids. This is not a nested-execution problem: the non-nested path exists and works. It is that the specified field does not measure the specified thing.

**What the existing suite does instead, and it is already fail-capable.** `carry-turn.test.sh` § 5 and § 5b prove the deny rules entirely through `$ARGVLOG.args`, one argument per line and bracketed — `assert_contains "deny path passes the deny rule through" "Bash(git push:*)"`, `assert_contains "plain launch requests --disallowedTools at all" "[--disallowedTools]"`, and the four mandatory rules asserted individually. The bracketed one-per-line shape is deliberate: it distinguishes `--disallowedTools 'A B'` (one argument) from `--disallowedTools A B` (two), so a collapsed or displaced rule fails. The carrier's own header says the same thing at `:106-108` — "What is verifiable here is the argv: the rules are requested on every Claude launch. Enforcement belongs to the child."

Nothing else was inspected beyond the named surfaces, and no repository file was changed. `git status --porcelain` shows this state file and the pre-existing untouched `logs/friction-log.md`. The skill, carrier, core, plan, commands and tests are all unchanged.

## Blocker

Claim (4) is false, and so is the plan's T6 verification (e) that it restates: "a real `carry-turn.sh` invocation under the documented baseline shows the required rules in `denials=`, and an invocation without them shows an empty `denials=`" (plan lines 1350–1352). The RESULT line's `denials=` reports the count of permission denials the **child recorded**, read from its `permission_denials` array. It does not report which `--claude-deny` rules were passed. The paired runs above show `denials=0` on both sides while argv differs, so the specified pairing cannot discriminate and cannot be made to without fabricating the fixture's output.

This propagates into § 3.4's control map, whose "no push, merge, deploy, credential access, or destructive shared-state operation" row names "the `RESULT` line's `denials=` field and the recorded argv" as its evidence (plan line 915). The argv half is sound and already tested; the `denials=` half is not evidence of that control at all. Writing the map into the skill as-is would document an evidence field that cannot fail — the precise failure § 3.4's own *Failure behavior* clause exists to prevent.

Second, smaller finding, surfaced because it would land in the same file: § 3.4's control truth says per-invocation sandbox and network/tool restriction are deferred. That is exactly right for `carry-turn.sh`, which refuses `--unattended|--contained|--sandbox` outright at `:306-307`. But the skill already tells the operator at line 266 that the **dispatcher's** `--unattended` gives "an OS-backed sandbox with an empty network allowlist". An unqualified "sandbox is deferred" sentence added to the same file would contradict that line as read. The fix is scoping, not omission, but the scope is Codex's to set.

## Next action

Codex: decide how T6's deny-set evidence is specified, then reissue the unit. Three things need a ruling.

1. **Replace the `denials=` pairing.** The recommendation is to specify the evidence as argv, matching what the carrier claims for itself and what `carry-turn.test.sh` § 5/§ 5b already assert: a baseline invocation whose `--disallowedTools` list carries the required rules, paired against one without them, read from the per-argument log. That pairing does discriminate — proved above — and it fails if a rule is dropped, displaced or collapsed. `denials=` can still be recorded as runtime-profile evidence, but for what it actually is: whether the child's permission-denial evidence was readable and what it contained.
2. **Restate the control-map row.** § 3.4's push/merge/deploy row should name argv as the fail-capable evidence and drop `denials=` from that cell, or the skill will document an uncheckable control. Whether this is a plan amendment or a T6-local restatement is Codex's call; it is a change to a plan surface, so it should not be made silently inside an implementation unit.
3. **Scope the sandbox sentence.** Rule on whether the T6 text says "deferred on the attended carrier (`carry-turn.sh`), which is what a baseline Standard invocation uses", leaving the dispatcher's `--unattended` sandbox at line 266 untouched and uncontradicted.

Claims (1), (2) and (3) all hold, so the rest of T6 is ready to implement as soon as the evidence contract is settled. Nothing was implemented and no target file was touched.
