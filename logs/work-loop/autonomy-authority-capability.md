---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Discovery mode. Unit 18 — prepare the exact T2 candidate core patch and its risk-aware review evidence without editing the core.

Named reason for the loop: T2 changes the canonical authority contract and the approved plan requires an independent high-consequence review of its exact wording before implementation; the candidate must survive that review without crossing the implementation gate.

## Brief
Unit 17 passed: the corrected plan is re-frozen, while T2 remains unimplemented. T2 changes the canonical authority contract, so the approved plan requires a risk-aware Codex review of the exact coherent change before implementation; this unit prepares that reviewable candidate while leaving the core untouched. It advances T2 without crossing its implementation gate.

**Governing authority:** the operator-approved proposal at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; the corrected implementation-plan content approved at commit `74c33a28d4cd18be376ab40127af0af303fd1d59`, blob `964068c627a92adf3aaadfb0d9c8e56ba0383e6e`, whose status-only re-freeze landed at commit `d8af1c4146332cdb4a63500426ad77cd0a7ec233`; and the compact Axcíon Standard Implementation Workflow. **Authoritative current state:** this file and the core after T1a, expected blob `82f119cd63c379b24f0bef8aab029ae04c165203`. **Non-governing evidence:** `plans/work-loop-v2-v0.2/t2-governing-autonomy-clause-primary-source-findings-2026-08-14.md` supports the corrected placement and coherence rationale but does not override the approved plan.

Required outcome: return one exact, reviewable candidate unified diff for T2 against the current core, without applying it to the repository target. The candidate must implement the approved plan's one coherent change as written in § 3.2 and T2:

1. Append the proposal § 1 governing-rule blockquote verbatim as new `## 8. The governing autonomy rule` after existing § 7. Preserve the titles, order, and numbering of §§ 1–7 exactly.
2. Reconcile all five enumerated categorical consequence/hard-to-reverse gates so consequence alone scales safeguards rather than automatically transferring a decision to the operator.
3. Reconcile core § 6 rule 4 as the separate sixth surface: preserve the full no-quiet-change disclosure for scope and success criteria, while transferring only intended-outcome or priority changes, material scope expansion, and exclusion removal.
4. Preserve and make explicit in reconciled core § 7 every operator-reserved-decision and mandatory-stop-or-handback class listed in approved proposal § 6. Do not weaken a real operator boundary while removing categorical language.

Check these repository premises before drafting: the plan status and identities above hold; the core matches blob `82f119cd63c379b24f0bef8aab029ae04c165203`; it has exactly §§ 1–7 and no governing-autonomy clause; the plan's five removed consequence strings, separate scope-transfer string, and retained disclosure string all match the normalized pre-change core; T1's authority paragraph and T1a's canonical header remain present. If any premise is false, hand back the evidence and do not draft against it.

Required review evidence:

1. Include the exact candidate unified diff in `## Latest result`, clearly labelled **not applied**. The diff may touch only the approved core surfaces: the five categorical gates, § 6 rule 4, and appended § 8.
2. Prove the appended blockquote is byte-identical to the approved proposal § 1 blockquote, including its verified byte count; prove it appears exactly once in the candidate result.
3. Give the normalized before/candidate-after matrix for all seven strings: the six removed strings match before and not after; the retained disclosure string matches before and after.
4. Show the candidate result has exactly eight numbered headings in order, with headings 1–7 byte-identical to the current core and § 8 appended.
5. Map every proposal § 6 operator-reserved class and mandatory stop/handback class to the exact candidate § 7 clause that preserves it. This is reviewer-read semantic coverage, not a keyword count.
6. Show the candidate leaves T1's authority paragraph and T1a's header byte-identical, changes no consumer, and requires no scope beyond the one core file.
7. Confirm the repository core itself remains blob `82f119cd63c379b24f0bef8aab029ae04c165203` and no implementation target changed. Report the state-only handback commit.

Codex framing decision: implementation, tests, consumer reconciliation, T3/T3a/T4+, and all existing deferrals stay outside this discovery unit because the approved review must judge exact T2 wording before the target is changed. After handback, Codex will obtain the fresh isolated risk-aware review the plan requires; this unit itself does not perform or pre-judge that review.

Completion condition: return the exact unapplied candidate diff and all review evidence, set `turn: codex`, commit only this state-file handback, and stop. Do not edit the core or any consumer, do not run T2's implementation regression suite as though T2 had landed, and do not begin downstream tracers.

Stop conditions: stop if a baseline identity differs, the approved blockquote cannot be recovered byte-identically, any proposal § 6 protection cannot be represented without exceeding T2's approved core boundary, the coherent candidate requires another file, or the plan and proposal cannot be satisfied together. Challenge a false premise rather than improvising or weakening either authority boundary.

## Latest result

Operator decision (2026-08-15): **approved** the bounded plan-amendment direction stated in `## Blocker` below — add the pre-existing settled-decision operator gate as a **seventh** reconciliation surface, counted separately from the five consequence gates and the one scope rule, and narrow it so only reopening an **operator-owned** settled decision transfers the decision. The approval was given directly to Claude and is recorded here verbatim in scope; Claude committed the record because only Claude commits (core § 4).

**This authorizes drafting and reviewing the amendment. It is not content-bound approval of the amended content, which does not yet exist at an identifiable blob.** No core edit is authorized. T2 implementation remains stopped until the amended plan has had one fresh bounded review and the operator's explicit content-bound reapproval of the reviewed commit and blob.

Unit 18 produced the exact unapplied T2 candidate at state-only handback commit `6ab0633f17935f0b845a77568d9007a0e844226b`; the repository core remains blob `82f119cd63c379b24f0bef8aab029ae04c165203`.

Fresh isolated high-consequence risk-aware review verdict: **CORRECT — implementation may not proceed against the candidate.** The review accepted the verbatim § 8 clause and its navigation sentence, the § 7 explanatory opening/closing prose, the six planned categorical-transfer removals, retained scope disclosure, headings, and proposal-§6 coverage. It found three material corrections:

1. Split capability handling: a missing capability grant goes to the operator, while a capability that is already authorized but cannot be enforced safely is a technical/infrastructure handback to Codex; unsafe enforcement is not operator-waivable.
2. Route an action that would bypass, weaken, or self-expand the control system to mandatory Codex handback. Operator involvement is needed only if the remedy requires the separately reserved material change to authority policy.
3. Reject the candidate's merged settled-decision/operator-intent bullet. Restore inventing operator intent as its own mandatory-stop clause, but the pre-existing core sentence `Proceeding would need a settled decision to be reopened.` remains a blocking seventh categorical operator-transfer surface: proposal § 3 delegates settled implementation decisions inside the solution envelope, while the new § 8 permits escalation only at named authority boundaries. Qualifying this sentence to `operator-owned` is needed for coherence, but the approved T2 plan explicitly limits edits to five consequence gates plus one scope rule and does not authorize this seventh surface.

Reviewer clarification: restoring the old sentence byte-for-byte is the only correction inside the current plan, but would leave the canonical core contradictory; changing it is necessary and requires a bounded substantive plan amendment plus operator content-bound reapproval before implementation.

Held outside the current decision: all existing deferrals. None explains away the authority contradiction.

## Blocker
None. The operator approval that was blocking the amendment direction has been given (see `## Latest result`). The amendment direction was: add the pre-existing settled-decision operator gate as a seventh reconciliation surface, separate from the five consequence gates and the scope rule, and narrow it so only reopening an operator-owned settled decision transfers the decision. No core edit is authorized until the amended plan is reviewed and content-bound reapproved.

## Next action
Codex: open the plan-only amendment unit on the approved direction. The amendment carries the seventh surface plus the risk review's two in-scope routing corrections — split capability handling (missing grant to the operator, unsafe enforcement to Codex), and route control-system bypass/self-expansion to Codex handback — and restores inventing operator intent as its own mandatory-stop clause. The plan returns to draft on a substantive T2-contract change, so state the two live status regions accordingly. T2 implementation remains stopped; no core edit is authorized by this approval.
