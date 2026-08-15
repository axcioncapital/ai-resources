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

Inspected (2026-08-15):

- Claim (1): HOLDS — `git hash-object` on `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returned `82f119cd63c379b24f0bef8aab029ae04c165203`, and `git rev-parse d8af1c41…:<core>` returned the same blob.
- Claim (2): HOLDS — the plan is at blob `c3fec34d9b43dfc7ddda2eb391d238cd032f6db9` in the worktree and at commit `d8af1c4146332cdb4a63500426ad77cd0a7ec233`; the approved corrected content it re-froze is blob `964068c627a92adf3aaadfb0d9c8e56ba0383e6e` at commit `74c33a28…`.
- Claim (3): HOLDS — searched the core for `^## [0-9]`; found exactly seven headings, numbered 1–7 in order, at lines 16, 40, 64, 251, 416, 438, 456. No eighth heading, and no governing-autonomy clause: `grep -c 'pre-authorized capabilities'` on the core returned **0**.
- Claim (4): HOLDS — all seven plan strings match the pre-change core when it is normalized to one logical line (see the matrix below, BEFORE column: seven of seven MATCH). Checked normalized because (d-ii) and rule 4 hard-wrap; matched literally against the raw file they would return zero hits before any edit, which is the trap the plan's own *Matching discipline* clause exists to close.
- Claim (5): HOLDS — core line 3 is T1a's reconciled header (`**Status:** canonical — content at commit 5fef08ff approved by the operator on 2026-08-14`), and lines 9–12 are T1's `**Authority.**` paragraph. Both present and unmodified.
- Claim (6): HOLDS, with a stated reading — the approved proposal § 1 governing-rule blockquote is proposal line 15. It is **587 bytes of text plus its line terminator = 588 bytes**, which is the plan's stated "588-byte governing-rule blockquote". Recording the reading because a reviewer counting without the terminator would get 587 and read the premise as false.
- Claim (7): HOLDS, with a difference worth naming — the **worktree** proposal is blob `e2a50c5e6e82482ed81a37000ac927af4f5bc672`, not the approved `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`. `git diff d8a89e0f… -- <proposal>` is a **single hunk, `@@ -3 +3 @@`** — the status line only. Proposal line 15 is byte-identical between the approved blob and the worktree copy (`diff` returns empty). The blockquote in the candidate was taken from the worktree file and verified against the approved blob, so the candidate binds to approved content either way.

Result: one exact **candidate** T2 patch is prepared and returned below, **not applied**. The repository core is unchanged at blob `82f119cd63c379b24f0bef8aab029ae04c165203`; the candidate exists only as a scratch file and the diff text in this record. No implementation target, consumer, test or plan file was edited by this unit. T2 has not been implemented and no review was performed or pre-judged here.

### The candidate diff — NOT APPLIED

Four hunks, one file. Against the current core (477 lines) the candidate is 512 lines.

```diff
--- a/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
+++ b/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
@@ -23,7 +23,9 @@
 **Claude** owns repository reality. It checks claims against the live repository, implements, tests,
 and produces evidence.
 
-**The operator** owns priorities, scope, and any decision that is hard to reverse.
+**The operator** owns intent and priorities, the approved solution envelope, and the decisions § 7
+reserves to them. Consequence alone does not move a decision to the operator; it raises containment,
+evidence and review (§ 8).
 
 Four limits on those roles:
 
@@ -56,8 +58,9 @@
 what was learned, close the task, and finish the work directly. Do not keep a task in the loop only
 because it started there.
 
-Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Genuinely
-consequential work stops and goes to the operator instead (§ 7).
+Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Consequential
+work runs in Standard with stronger containment, evidence and review; it goes to the operator only
+when § 7 reserves the decision to them.
 
 ---
 
@@ -446,8 +449,10 @@
    malformed, stale, or belongs to a different task, report it and change nothing.
 3. **An absence claim must say what was searched.** "There is no such field" is not a finding.
    "There is no such field — searched the model, the view and their tests" is.
-4. **Scope and success criteria do not change quietly.** A change to either is stated out loud, and
-   a change to scope goes to the operator.
+4. **Scope and success criteria do not change quietly.** A change to either is stated out loud, never
+   made silently. The decision is the operator's when the change is one they reserve — the intended
+   outcome or the priority, a material expansion of scope, or the removal of an exclusion (§ 7). A
+   change that is none of those is disclosed and proceeds.
 5. **Evidence must be able to fail.** If the check would pass whatever happened, it is not evidence.
    Build the failing case first, then show it passing.
 
@@ -457,21 +462,51 @@
 
 Stopping is a normal outcome. Each trigger below names who to stop for.
 
+**Consequence is not itself a trigger.** Higher consequence means stronger containment, stronger
+evidence and a proportional review — not that the decision moves to someone else (§ 8). A
+consequential change whose outcome, envelope and capabilities are already delegated stays with the
+agent and is done more carefully. What moves a decision is the class it falls in, and the classes are
+listed here.
+
 **Hand back to Codex** — write the finding into the state file, set `turn: codex`, commit, and stop:
 
-- A claim the brief rests on is false (rule 1).
+- A claim the brief rests on is false (rule 1), or a load-bearing premise is still unsupported after
+  bounded investigation.
 - The work would go outside the approved scope, or touch something the brief excluded.
 - The required evidence cannot be produced.
+- The approved plan is materially invalid, and repairing it would go outside the solution envelope.
 
 **Stop for the operator** — write the question into the state file, set `turn: operator`, commit, and
 stop:
 
-- The change would be hard to reverse.
-- Proceeding would need a settled decision to be reopened.
+- The intended outcome or the priority would change.
+- Scope would expand materially, or an exclusion would be removed.
+- Product or business behaviour must be chosen and existing authority does not determine it.
+- The approved operating model, a material architecture commitment, the cost or risk profile, or the
+  governance model would change.
+- Material residual risk would be accepted that was not already delegated — including the case where
+  the correction was not enough and the choice among the options in § 3 is really about accepting
+  risk.
+- The authorized capability envelope would expand, or the capability the work needs is not granted or
+  cannot be enforced safely.
+- Production deployment, public or customer communication, credential use, or destructive action on
+  shared state would be authorized, and no separate explicit delegation already covers it.
+- Operator intentions are genuinely tied or in conflict, or governing sources stay materially tied
+  after the authority hierarchy has been applied.
+- The policy governing agent authority would materially change.
+- Proceeding would need a settled decision to be reopened, or would require inventing operator intent.
+- The action would bypass, weaken, or self-expand the control system.
 - The state file is stale or belongs to another task, and it is not obvious which is correct
   (rule 2).
-- The correction was not enough, and the choice among the options in § 3 is really about accepting
-  risk.
-- Anything else that is genuinely consequential.
 
-In this version, "stop and bring this to the operator" is the answer for consequential situations.
+These classes are what stop the work. Everything outside them proceeds under § 8, with containment,
+evidence and review scaled to what is at stake.
+
+---
+
+## 8. The governing autonomy rule
+
+> **Within the approved solution envelope, resolve what evidence can resolve, exercise professional technical judgment, and use only pre-authorized capabilities. Consequence increases containment and verification; it does not by itself transfer the decision to the operator. Escalate only when continuing requires operator-owned intent, accepted risk, a material change outside the solution envelope, or expansion of the authorized capability envelope. Stop when a load-bearing premise or required verification cannot be established, or when continuing would bypass the control system.**
+
+This rule governs §§ 1–7 above wherever they touch autonomy: § 7 lists the classes that escalate it,
+and § 6 rule 4 states how it applies to a change of scope.
```

### Evidence

**(3) The seven-string matrix, normalized to one logical line, before and candidate-after.** Run over both files with `tr '\n' ' ' | tr -s ' '` and a shell substring test, so no regex could pass on a partial match:

| # | String | Kind | BEFORE | AFTER |
|---|---|---|---|---|
| d-i | `and any decision that is hard to reverse` | removed | MATCH | **no match** |
| d-ii | `Genuinely consequential work stops and goes to the operator instead` | removed | MATCH | **no match** |
| d-iii | `The change would be hard to reverse.` | removed | MATCH | **no match** |
| d-iv | `Anything else that is genuinely consequential.` | removed | MATCH | **no match** |
| d-v | `is the answer for consequential situations` | removed | MATCH | **no match** |
| g-1 | `a change to scope goes to the operator` | removed | MATCH | **no match** |
| g-2 | `Scope and success criteria do not change quietly` | **retained** | MATCH | **MATCH** |

Six removed, one retained, seven before-matches — exactly the split the corrected § 3.2 *Matching discipline* requires. The five consequence gates and the one scope surface stay separately identified, so a partial reconciliation of either would show as a single row failing rather than hiding inside an aggregate.

**(2) The appended blockquote.** Taken from proposal line 15, not retyped. Byte-identical to the approved blob: `diff` between `git cat-file blob 39c67196…:line 15` and the candidate's blockquote line is empty. **588 bytes including the line terminator** (587 without), matching § 3.2's stated size. It appears **exactly once** in the candidate (`grep -c '^> \*\*Within the approved solution envelope'` → 1), and nothing outside the core carries it.

**(a) The clause-presence check goes from failing to passing.** `grep -c 'pre-authorized capabilities'` on the core: **0 before, 1 after**. This is the check that catches a forgotten clause.

**(4) Headings.** `grep -n '^## [0-9]'` on the candidate returns exactly eight, numbered 1–8 in order:

```
16:## 1. Who does what      254:## 4. The task-state file    461:## 7. When to stop and ask
42:## 2. When to use the loop 419:## 5. Words we use          507:## 8. The governing autonomy rule
67:## 3. The unit cycle      441:## 6. Safety rules
```

`diff` between the seven heading lines of the current core and the first seven of the candidate is empty — **titles and order byte-identical, nothing renumbered or retitled**. The new title does not collide with the reserved `## Mode` heading slice-1 asserts against.

**(6) Fixed points untouched, one file only.** `diff` of lines 1–12 before against after is empty, so T1a's reconciled header (line 3) and T1's authority paragraph (lines 9–12) are byte-identical. The diff touches one file. No consumer, no skill, no command, no test, no plan file is in it, so T3 keeps its citation-only scope and T3a stays limited to skill line 508.

**(5) Coverage — every proposal § 6 class mapped to the exact candidate clause.** Read against the proposal text, not grepped.

*Operator-reserved decisions — all nine:*

| Proposal § 6 class | Candidate § 7 clause |
|---|---|
| changing the intended outcome or priority | "The intended outcome or the priority would change." |
| material scope expansion or exclusion removal | "Scope would expand materially, or an exclusion would be removed." — and § 6 rule 4's narrowed transfer names the same three |
| product or business behavior not determined by existing authority | "Product or business behaviour must be chosen and existing authority does not determine it." |
| approved operating model, material architecture commitment, cost/risk profile, or governance model | "The approved operating model, a material architecture commitment, the cost or risk profile, or the governance model would change." |
| accepting material residual risk not already delegated | "Material residual risk would be accepted that was not already delegated — including the case where the correction was not enough…" |
| expanding the workspace or plan capability envelope | "The authorized capability envelope would expand…" |
| production deployment, public/customer communication, credential use, destructive shared-state action without separate delegation | "Production deployment, public or customer communication, credential use, or destructive action on shared state would be authorized, and no separate explicit delegation already covers it." |
| resolving genuinely tied or conflicting operator intentions | "Operator intentions are genuinely tied or in conflict…" |
| approving a material change to the policy governing agent authority | "The policy governing agent authority would materially change." |

*Mandatory stop or handback — all seven:*

| Proposal § 6 class | Candidate § 7 clause |
|---|---|
| load-bearing premise unsupported after bounded investigation | Hand back: "…or a load-bearing premise is still unsupported after bounded investigation." |
| approved plan materially invalid, repair exceeds the envelope | Hand back: "The approved plan is materially invalid, and repairing it would go outside the solution envelope." |
| required load-bearing verification cannot be produced | Hand back: "The required evidence cannot be produced." (retained verbatim) |
| needed capability not granted or not safely enforceable | Operator: "…or the capability the work needs is not granted or cannot be enforced safely." |
| continuing would require inventing operator intent | Operator: "…or would require inventing operator intent." |
| the action would bypass, weaken, or self-expand the control system | Operator: "The action would bypass, weaken, or self-expand the control system." |
| governing sources materially tied after applying the authority hierarchy | Operator: "…or governing sources stay materially tied after the authority hierarchy has been applied." |

*Nothing in the pre-change core was dropped.* Retained verbatim: "The work would go outside the approved scope, or touch something the brief excluded."; "The required evidence cannot be produced."; "The state file is stale or belongs to another task, and it is not obvious which is correct (rule 2)."; "There is no third lane." Retained in reworded form: "A claim the brief rests on is false (rule 1)"; "Proceeding would need a settled decision to be reopened"; "The correction was not enough, and the choice among the options in § 3 is really about accepting risk." Removed **as categories only**, which is the point of T2: "The change would be hard to reverse." and "Anything else that is genuinely consequential." Their real content is carried by the enumerated classes above — most directly the production/communication/credential/destructive-shared-state clause.

**(f) Regression protection.** The resolver suite passes against the unchanged repository core (`4 passed, 0 failed`). Because the candidate is not applied, the slice-1 suite could not be run whole; instead its **fourteen core-reading assertions were extracted and evaluated directly against the candidate file** — all fourteen PASS, including the two the candidate came closest to breaking: `grep -q 'There is no third lane'` (the (d-ii) rewrite preserves that sentence verbatim) and `! grep -qE '^## Mode'` (the new § 8 title). This is the fail-capable part: had the (d-ii) rewrite dropped the third-lane sentence, that assertion would have failed here rather than after the core was edited.

**(7) The repository is unchanged.** `git hash-object` on the core still returns `82f119cd63c379b24f0bef8aab029ae04c165203`. `git status --porcelain` lists only this state file and the hook-appended `logs/friction-log.md`, which this unit does not commit. The candidate lives in the session scratchpad (`core-candidate.md`, `candidate-t2.diff`), outside the repository.

### Judgment calls the risk-aware review must rule on

Four drafting decisions are mine, not the plan's. Naming them so the review judges them rather than discovering them:

1. **§ 8 carries two sentences of navigation after the verbatim blockquote** ("This rule governs §§ 1–7 above wherever they touch autonomy…"). The clause itself is verbatim and appears once; the added sentence states *where* the rule applies and does not restate it. § 3.2's failure behavior targets paraphrase of the clause — this is not that — but it is additional text and the review may want it cut.
2. **§ 7 gained a "Consequence is not itself a trigger" opening paragraph and a closing sentence.** Neither is required by § 3.2. They exist because removing the categorical language without saying what replaced it leaves a reader to infer the new rule from the absence of the old one.
3. **The ungranted-or-unenforceable-capability class is placed under "Stop for the operator", not "Hand back to Codex".** Proposal § 6 calls it "mandatory stop or handback" without assigning a side; granting capability is operator-reserved, so operator is the non-weakening reading. A reviewer could reasonably route it to Codex instead.
4. **Two pre-change bullets are merged into one** ("Proceeding would need a settled decision to be reopened, or would require inventing operator intent"). Both triggers survive; only the bullet count changed.

### Noted, not acted on

- The **worktree proposal is not at the approved blob** — one hunk, the status line at line 3, exactly as the approved plan itself anticipates ("status-recorded at commit `5b0d5fd8…`; no substantive proposal content changed"). It does not affect this candidate, since line 15 is identical in both. Not corrected here; it is outside this unit's scope.
- The `grep -c` counting trap noted in Units 16 and 17 recurred and was avoided again: every count in this record was taken with an explicit substring test or against named line numbers, not with `grep -c` on wrapped prose.

Deferrals carried forward, unchanged and non-blocking: the future normalized-count harness note; the proportionality/continuity-plan follow-on; the stale row in the unapproved resource-capability development plan; the plan's § 14 item-6 wording inconsistency. None blocks T2.

## Blocker
None. The core was not edited; T2 remains at its implementation gate.

## Next action
Codex: obtain the fresh isolated risk-aware review the plan requires for T2, on the whole coherent change together — the appended clause, the five consequence gates and the scope rule — and put the four judgment calls above in front of it. Then decide whether to open T2's implementation unit against this candidate, correct it once, or reframe.
