# House View Workflow Repair Plan

**Status:** Approved by the operator on 2026-08-20 — implementation authorized per § 7 (Moves 0–2 first; Moves 3–4 only if Move 2 passes)  
**Approved content:** SHA-256 `1b9700666c62a2cbfae3b5b3a4daa7669d503dcc617c8b3c7f9bd3b11bb22ad4`, the bytes of this file immediately before this header block was added. The approval binds to that hash; the semantic body below is unchanged from it.  
**Date:** 2026-08-20  
**Decision sought:** Authorize one early feasibility test and, only if it passes, the minimum workflow repair plus one successor pilot.

## 1. Operating outcome

Axcíon needs a House View workflow that turns researched evidence into an explicit, founder-authorized judgment without making the founder supervise an open-ended review loop.

The repaired path must:

- preserve the current founder authority and fail-closed controls;
- comprehensively challenge all defined review surfaces before the first founder decision;
- allow one batched revision followed by one narrow correction check;
- require no more than two founder interactions in an ordinary case;
- prove that approved judgment shapes downstream analysis and prose; and
- stop if later review exposes an old material defect that the first challenge should have found.

This is a repair of the existing proposal/review path. It is not a new review system, approval system, workflow stage, or rollout programme.

## 2. What failed and what stays

The L4 pilot proved the safety model works: proposed and rejected briefs do not become authority, promotion and downstream use fail closed, permission breaches cannot be waived, and the founder remains the sole decider.

The review path failed operationally. Findings already present in the first proposal appeared serially across four rounds; incomplete decision inputs caused a false finding; a revision introduced another defect; and each edit triggered another unrestricted whole-document review. The founder faced three revision gates and 22,214 words of review records before rejecting the proposal. L1 had already shown the same burden pattern.

The repair therefore keeps the authority mechanics and changes only the review behavior:

```text
proposal
→ one comprehensive independent challenge
→ founder approves, rejects, or requests one batched revision
→ one narrow correction check
→ founder approves or rejects
```

A third ordinary founder interaction or another broad review is failure, not continuation.

## 3. The minimum repair

### Move 0 — Close the rejected L4 run

The current `canonical-rw-l4-integrated-pilot` task must first close as stopped without L4 acceptance. The rejected precision-components proposal remains rejected and cannot be reused as authority or revived as the successor case.

No repair implementation begins in the closing unit.

### Move 1 — Fix the known validator defect

Fix the final-thesis parser so the last thesis cannot borrow citations from the provisional verdict or later sections.

Proof:

- add one failing five-thesis mutation case that demonstrates the defect;
- make the smallest parser correction; and
- pass the existing judgment-contract regression suite.

This move changes no lifecycle, review, approval, or downstream behavior.

### Move 2 — Prove reviewer feasibility before building

Run a manual experiment using the frozen historical proposal and its known F1–F10 outcomes. Build no command, schema, validator, manifest, or permanent fixture framework for this experiment.

Give one fresh-context reviewer:

- the complete evidence and context inputs used by the proposal;
- the complete applicable decision inventory, including CC-1;
- the existing five challenge questions; and
- an improved two-part rubric covering evidence/permission and decision/logic.

The experiment passes only if the reviewer:

- finds the historical F1–F3, F5–F8, and F10 defect classes in the first challenge;
- does not reproduce the erroneous F4 premise because CC-1 is present;
- returns a founder-facing finding summary no longer than 1,500 words; and
- after applying the historical F9-causing revision, identifies F9 in a narrow check limited to the carried findings, changed content, and directly affected content.

Stop the repair if this cannot be demonstrated within 16 total hours for Moves 1 and 2. A failed semantic design is not repaired by building more workflow machinery.

### Move 3 — Apply only the changes the experiment proves necessary

If Move 2 passes, update the existing workflow rather than adding a subsystem:

1. Give the existing independent reviewer the complete input inventory and the tested two-part rubric.
2. Keep one review record bound to the proposal's exact bytes using the existing hash and archive behavior.
3. Present one concise proposal and finding summary to the founder.
4. If revision is requested, apply all findings in one batch.
5. Run one fresh correction check asking only whether the frozen findings were resolved and whether the correction broke directly affected content.
6. Return once to the founder for approval or rejection.

A revision is not narrow when it changes the direction of the provisional verdict, materially rewrites more than two theses, or otherwise replaces most of the analytical argument. Treat that as a new proposal and stop the pilot; do not route it through the correction check.

Proposal-body byte changes invalidate the prior semantic check. Administrative metadata may be repaired and validators rerun without founder involvement while the proposal body is unchanged. Broken automation must still stop rather than retry indefinitely.

Expected canonical touchpoints are limited to:

- `workflows/research-workflow/.claude/commands/run-analysis.md`;
- `workflows/research-workflow/docs/judgment-authority-contract.md`;
- `workflows/research-workflow/reference/unit-judgment-brief.template.md`;
- the matching stage/file-convention references;
- the final-thesis parser and its existing tests; and
- focused changes to existing judgment-seam tests where behavior changed.

Do not add:

- a coverage manifest;
- specialist-reviewer records or consolidation machinery;
- a source-to-ledger map or validator;
- a revision-scope script;
- a new failure taxonomy;
- new global skills or agents;
- a telemetry system; or
- duplicate semantic review gates.

### Move 4 — Run one bounded successor pilot

Use one genuinely new case with mature frozen evidence and no new retrieval. It should fit three substantive theses, contain at least one real caveat or proxy constraint, and involve at least one material operator-decision constraint.

The downstream proof is deliberately small: one governed directive, one substantive prose section, and independent content QC. Do not make the pilot prove the complete research-production pipeline.

No second consumer, generic synchronization, broader rollout, or second pilot is authorized.

## 4. Controls that remain unchanged

- `proposed` and `rejected` remain non-authoritative.
- Silence or ambiguous language never counts as approval.
- Only the founder may approve, revise, or reject.
- Permission-breach findings cannot be waived into approval.
- Reviews remain bound to exact proposal bytes.
- Promotion remains a mechanical, byte-faithful transition.
- Missing, stale, malformed, proposed, and rejected states fail closed.
- Downstream analysis, prose, and QC must visibly consume the approved House View.
- The rejected L4 content and its records remain intact.

## 5. Acceptance and stop conditions

The repair passes only when:

1. Existing authority, challenge, promotion, rejection, staleness, and downstream-consumption regressions remain green.
2. The final-thesis mutation case fails before the parser fix and passes afterward.
3. The manual historical experiment passes every Move 2 criterion before workflow implementation begins.
4. The successor proposal is no more than 1,000 words and its founder-facing package no more than 1,500 words.
5. The founder is required to act no more than twice. Each assistant message requiring founder action counts.
6. A revision stays narrow under Move 3's rule and the correction check finds the revision-introduced F9 class.
7. Approved judgment visibly governs the bounded directive and prose section, confirmed by independent content QC.

Internal review volume is recorded as a burden diagnostic, not a hard safety gate. Repeated growth toward the failed pilot's 22,214 words is evidence against adoption even if the founder package remains concise.

Stop immediately on:

- a safety or authority regression;
- failure of the early reviewer experiment;
- an old unrelated material defect discovered after the first challenge;
- a broad rewrite presented as a narrow revision;
- a third founder interaction;
- inability to prove downstream consumption; or
- pressure to add the machinery explicitly excluded above.

Record elapsed processing time, founder interactions, review volume, outcome, and existing regression/QC evidence in the repair task's ordinary evidence record. Do not create a new telemetry or governance artifact.

## 6. Estimated exposure and decision points

These are estimates, not commitments:

| Work | Estimate |
|---|---:|
| Validator fix and manual feasibility experiment | 8–16 hours |
| Minimal workflow and regression changes | 6–12 hours |
| Manual consumer reconciliation | 2–5 hours |
| Successor pilot and evidence | 14–30 hours |
| **Total if every step passes** | **30–63 hours** |

The first decision point is after at most 16 hours: stop unless the single-reviewer design succeeds against the historical case. The second is after the minimal build: stop unless existing regressions and the same historical experiment pass. Only then spend the 14–30 hours on the live pilot.

## 7. Recommended authorization

Approve Moves 0–2 first. Passing Move 2 authorizes Moves 3–4 inside the boundaries above; failing it ends the repair.

This approval would not approve implementation output in advance, reopen L4, revive the rejected proposal, weaken founder authority, authorize a broad rewrite, deploy to other consumers, merge, push, or create new workflow machinery.
