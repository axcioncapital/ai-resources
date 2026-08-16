---
task: work-loop-v2-durable-state-system
status: active
turn: claude
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 5 — Tracer bullet 3: atomically switch every Work Loop lifecycle consumer to the canonical validator, then rewrite this checkout's owner and complete the first self-hosted handoff.

Named reason for the loop: this is the high-risk atomic cutover in a multi-unit lifecycle-state migration; partial consumer migration would create contradictory runtime truth and the result requires independent assessment before progression.

## Brief

Tracer bullet 2 is accepted at commit `596f733d`: every tracked state record is classified, all intended-valid records pass the inactive validator, the intentional negatives retain their intended failures, and both the validator and old-runtime deterministic baselines are green. The frozen plan now requires one coherent semantic cutover before any owner-format mutation, followed immediately by the implementation task's first real handoff under the new contract; legacy-session isolation remains the following tracer.

**Required outcome:** In one coherent semantic cutover commit, make the accepted explicit lifecycle contract authoritative and ensure every production Work Loop state consumer obtains lifecycle meaning from `logs/scripts/work-loop-state.sh` rather than private parsing or turn/body inference. Preserve each consumer's program-specific transport and diagnostics while enforcing exact task identity, the four validator classifications, safe blocked behaviour, exact-path or exact-ID entry, and valid-state-first closure ordering. Only after that semantic commit succeeds, validate repository-depth ownership and rewrite this checkout's `.owner` once from `work-loop-v2-durable-state-system 2026-08-14` to exactly `work-loop-v2-durable-state-system`; then complete a separate state-only handback commit whose record validates as `ACTIVE_CODEX` under the new runtime.

**Governing authority and source dispositions:**

- Frozen plan `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`, Fixed decisions 1–15, Capabilities A–E, Safe ordering steps 4–6, and Tracer bullet 3 govern this cutover. Its content is bound to the operator-accepted architecture hash recorded in the plan and is approved for sequential implementation.
- Accepted Tracer 2 commits `a1c81caf`, `f3390f7b`, and `596f733d` govern the preparation baseline. The last material result is: 74 tracked paths fully accounted for; 68 intended-valid records accepted; three intentional negatives fail on their own invariants; this task validates under the new validator; the old runtime remains green; and the stale `diagnosing-bugs` routing marker was corrected without changing route membership.
- `logs/scripts/work-loop-state.sh` is the already-proven canonical classifier and must remain the single lifecycle authority. Consumer-specific adapters may translate its classifications into their own existing messages or exit contracts, but may not retain or introduce a fallback parser.
- The currently canonical executable core at approved commit `5fef08ff` governs this incoming old-runtime handoff. The frozen plan expressly authorizes Tracer 3 to replace its lifecycle/state semantics and authority statement with the accepted explicit-status contract while preserving unrelated Work Loop behaviour; no separate unapproved proposal may override that scope.
- The integrated shared-lease Phase 1 implementation governs live actor exclusion. Reuse it unchanged; this unit may adapt callers to new state classification but may not redesign lease behaviour.
- Current operator decision, 2026-08-15, keeps all new Work Loop admissions paused through operational proof and final landing. This unit is continuation of the already admitted implementation task, not a new admission.

**Check against the repository before editing:**

1. Reconfirm the exact checkout/task, HEAD `596f733d`, this record as `ACTIVE_CLAUDE`, the old-format `.owner`, repository-depth unique ownership, and free shared leases. Reconfirm the preparation-baseline proof that the old runtime accepts this status-augmented task while the new validator classifies it. Stop on any ambiguity, live competing actor, changed HEAD, or another open old-shape owner.
2. Inventory production lifecycle/closed-state parsing and mutation across the plan-named surfaces: the executable core, `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, `.agents/skills/reorient/SKILL.md`, `logs/scripts/work-loop-owner.sh`, `scripts/axcion-harness-v0.2/carry-turn.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, and directly invoked proof helpers. Search those files and their owning tests for parsing of `turn:`, closing headings, candidate scans, owner dates, or independent open/closed inference. Treat any additional production semantic consumer found in that bounded surface as in scope and name it; stop if relevance is ambiguous rather than silently widening.
3. Establish failing-first behaviour for the cutover: representative current consumers must demonstrably accept, infer, or select at least one state the final validator contract rejects or handles differently, and the consumer-consistency/closure-order assertions must fail before implementation. Use existing fixtures and focused test conventions; do not build a general framework.
4. Reconfirm that all other registered checkout declarations are absent, task-only, or bound only to valid new-contract records as applicable. This checkout's old declaration is the only authorized owner mutation in this unit; any other open old-shape declaration stops the cutover.

**Implementation boundary:**

- Update the executable core's lifecycle/state contract and content-bound authority as authorized by the frozen plan.
- Update the Codex Work Loop skill, Claude command, Reorient, owner helper, attended carrier, unattended dispatcher, and directly affected proof helpers/tests so lifecycle classification comes only from the validator. Remove empty-invocation candidate selection and every private old-shape fallback.
- Preserve each transport's existing program-specific exit meanings, allowlist behaviour, live-lease integration, process supervision, permission policy, and partial-effect reporting except where a minimal adapter change is required to consume validator output.
- Enforce closed-state commit before owner clear in every closure/de-escalation path. `BLOCKED_OPERATOR` retains ownership and exposes its exact recorded condition. Missing, malformed, contradictory, identity-mismatched, unsupported, or unclassifiable state stops before actor launch or mutation.
- Keep the complete semantic switch and its directly owning test updates in one cutover commit. The current task may remain `ACTIVE_CLAUDE` in that commit. After it succeeds, rewrite only this checkout's gitignored `.owner` under repository-depth validation, invoke no other Work Loop actor between commit and rewrite, then update only this task record to the final evidence/`ACTIVE_CODEX` handback and make a separate state-only handback commit.

Excluded by the frozen plan and Codex framing: dispatcher legacy-session initialization or allowlist cleanup; legacy command preflights; `handoff-thread` changes; generic compaction-policy changes; lease redesign; actor supervision or permission changes; deployment/sync packaging; project deployment; broad documentation cleanup; historical-record changes; automatic migration/archival; merge, push, landing, or Tracer 4 work. Leave the hook-owned `logs/friction-log.md` modification untouched and outside every commit.

**Capability subset:** Baseline only — read/search/history inspection, repository-depth owner and shared-lease checks, local tests, edits to the inventoried semantic consumers and their directly owning tests, the one semantic commit, the authorized local `.owner` rewrite after that commit, and one state-only handback commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed; no merge, push, deployment, network, credential, destructive shared-state action, policy expansion, or installation change is authorized. This is an operator-carried interactive turn, so no courier runtime profile is claimed.

**Required evidence:**

- A before/after source inventory that names every production lifecycle parser in the bounded consumer surface and shows that, afterward, no production consumer derives lifecycle/closure independently of `work-loop-state.sh`; test-only fixture construction must be distinguished from production parsing.
- Failing-first and passing consumer-consistency evidence: all consumers return or correctly translate the same four classifications for the same legal fixtures, and malformed, contradictory, identity-mismatched, unsupported, and missing-status fixtures stop before launch or mutation.
- Exact-ID/path evidence proving empty invocation cannot scan or select a candidate; negative fixtures must show the old selection behaviour is gone.
- `BLOCKED_OPERATOR` evidence proving the owner is retained and the exact blocker is surfaced.
- Fail-capable closure-order evidence: injected pre-commit failure leaves the owner intact; injected post-commit/pre-clear failure leaves valid `CLOSED` plus a stale owner that is safely clearable; clean closure commits valid closed state before clearing.
- Green exact-count/exit evidence for `logs/scripts/work-loop-state.test.sh`, `logs/scripts/work-loop-owner.test.sh`, `logs/scripts/work-loop-v2-slice-1.test.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`, and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, plus any focused suite owning an additional consumer found by the inventory. Distinguish environmental limitations from accepted green; do not call a red or unavailable suite green.
- Cutover sequencing evidence: the complete semantic switch is one commit; its path list contains every inventoried production consumer and no excluded subsystem; the old owner remains unchanged until that commit exists; repository-depth validation immediately precedes the one rewrite; the final owner contains exactly the task ID; and no actor invocation occurred between semantic commit and owner rewrite.
- Self-hosting evidence after the rewrite: the new core/Claude entry accepts this exact task and task-only owner; the validator returns `ACTIVE_CLAUDE` before the handback flip and `ACTIVE_CODEX` afterward; the state-only handback commit contains only this task record; repository-depth ownership remains unique; and no private fallback was used.

**Completion condition:** Complete and commit the atomic semantic cutover, then rewrite the owner in the required order, then make the state-only handback commit. Replace `## Latest result` with the source inventory, failing/passing cases, suite counts, closure-order, commit/path, owner-rewrite, unique-binding, and self-hosted handoff evidence; set `turn: codex` while retaining `status: active`; and hand back for assessment under the new runtime. State explicitly that admissions remain paused, legacy-session isolation has not started, nothing was deployed or landed, and Tracer 4 has not started.

**Stop conditions:** Stop before the semantic commit if the complete consumer set cannot be bounded, any required consumer cannot safely delegate classification to the validator, a required suite is red/unavailable, another open old-shape owner exists, the core change would exceed the content-bound accepted architecture, or atomicity would be lost. If the semantic commit succeeds but owner validation/rewrite fails, do not invoke another actor or accept either owner format; preserve the fail-closed evidence and report the interruption through the safest existing channel without adding a fallback or second state store. Stop if the self-hosted handoff would require legacy session state, a permission/supervision change, deployment, or any excluded work.

## Latest result

Unit 4 / Tracer bullet 2 accepted after its bounded correction and final fix. Commit `a1c81caf` migrated the complete tracked-record inventory: 55 valid closed, 13 valid active, zero valid blocked, three intentional negative fixtures, and three non-state target fixtures, with all 68 intended-valid records accepted and each negative failing on its intended invariant. Commit `f3390f7b` repaired the two old-runtime mode assertions made stale by Unit 3's authorized retirement. Commit `596f733d80fd79fd277b5253add3f46496c2c419` corrected the factual `diagnosing-bugs` installation marker and restored the required deterministic baseline while preserving its fail-capable live-installation cross-check.

Accepted verification: `work-loop-state.test.sh` 63/0 and `work-loop-v2-slice-1.test.sh` 308/0, both exit 0; this record validates as `ACTIVE_CODEX`; the old runtime still reads the migrated state; no `.owner` or consumer changed; `.owner` remains `work-loop-v2-durable-state-system 2026-08-14`; admissions remain paused; and Tracer 3 had not started. No additional routing-currency mechanism is warranted: the existing live-installation assertion detected the stale marker and remains discriminating in both mismatch directions.

## Blocker

None.

## Next action

Claude: execute Unit 5. Verify the exact consumer inventory, dual-valid self-hosting premise, unique old-format ownership, and failing-first cases before editing; then make the complete semantic cutover commit, rewrite only this checkout's owner in the mandated post-commit order, complete the state-only `ACTIVE_CODEX` handback commit under the new runtime, and stop for Codex assessment. Do not begin legacy-session isolation or invoke another actor between the cutover commit and owner rewrite.
