# Repository Problem Resolution SOP

## Contents

- [Purpose](#purpose)
- [Step 1 — Qualify and Prioritise](#step-1--qualify-and-prioritise)
- [Part I — Lane A: Normal Repair](#part-i--lane-a-normal-repair)
- [Part II — Lane B: Structural Resolution](#part-ii--lane-b-structural-resolution)
- [Part III — Controls That Apply to Both Lanes](#part-iii--controls-that-apply-to-both-lanes)
- [Operator Checklist](#operator-checklist)
- [Decision Standard](#decision-standard)
- [Flags and Open Points](#flags-and-open-points)

## Purpose

This SOP explains how Axcíon resolves repository problems with Claude and Codex. It is written for the operator: it explains what to report, what to challenge, what to approve, and what to copy and paste. Claude performs the investigation and implementation. Codex challenges and verifies independently. Neither model is an authority on whether its own work is correct, and neither authorises integration.

The governing standard is simple:

> Correct a repository problem at the level of the condition that causes it, using
the lightest route that can demonstrate the correction reliably. Close a case
only on an explicit outcome supported by evidence proportionate to the
consequence — never on activity performed or on a persuasive explanation.
> 

Two routes exist, and the routing decision at Step 1 is the most consequential judgment in this SOP.

- **Lane A — Normal repair.** Bounded defects with a local correction. Most problems belong here. Lane A has two depths: *simple repair* and *test-backed repair*.
- **Lane B — Structural resolution.** Problems that cannot be safely resolved as a bounded local correction. Lane B is deliberately not a general-purpose meta-fixer.

Lane A does not inherit Lane B's gates. A Lane A repair closes as a Lane A repair, without pretending the structural process was run.

The failure this SOP exists to prevent: running Lane A repeatedly on a Lane B problem, so each repair adds another warning, guard or check while the underlying condition survives untouched. The opposite failure matters too — running Lane B on a bounded defect converts a ten-minute fix into a week of ceremony.

**Context sources.** Where a system map, decision record, critical-rules list or other governing document exists, use it and treat it as authoritative for its subject. Their absence does not block a justified investigation. Record material authority or documentation gaps in the context manifest and proceed on the available evidence.

**Related documents.** The Independent Review SOP governs review depth, verdicts and adjudication, including the verdicts used here. The Codex–Claude Session Operating SOP governs how each session is run. The AI Development Lifecycle SOP takes over when investigation shows the answer is a new or changed capability rather than a repair.

### Case outcomes

One vocabulary is used at admission and at closure. A case carries exactly one of these at any time.

| Outcome | Meaning | Terminal? |
| --- | --- | --- |
| **Proceed — normal repair** | Bounded defect, local correction. Enters Lane A. | No |
| **Proceed — structural resolution** | Cannot be safely resolved locally. Enters Lane B. | No |
| **Defer** | Real problem, not justified now. Records the reason and the reconsideration trigger. | No |
| **Operate around** | Correction not justified now; a defined workaround is in use. Records the limitation and the reopening trigger. | No |
| **Not confirmed** | Insufficient current evidence to authorise a correction. Records what evidence exists and what would justify reopening. | No |
| **No action justified** | Premise disproved, obsolete, duplicated, outside scope, or accepted as not worth correcting. | Yes |
| **Resolved** | The correction was verified, integrated, and — in Lane B — survived representative use. | Yes |

Three distinctions matter and must not blur:

- **Not confirmed is not No action justified.** The first says the evidence is insufficient; the second says there is nothing to fix. Failure to reproduce produces *Not confirmed*, never *No action justified* by default.
- **Not confirmed is not Resolved.** An unconfirmed case has not been fixed.
- **Defer and Operate around are not silent closure.** Both are open states. The case record preserves the reason, the known consequence and the trigger for reconsideration. Do not build a separate backlog or tracking mechanism to hold them — the case record is sufficient.

> **Note on vocabulary:** the source material carried three incompatible gate sets and two verdict lists. This SOP uses one gate set and the Independent Review SOP's verdict vocabulary. That consolidation is a decision, not a finding — confirm it before adopting. The mapping from older wordings is in the flags at the end.
> 

---

## Step 1 — Qualify and Prioritise

Admission answers two separate questions, in this order. Conflating them is how repository maintenance quietly displaces rollout work.

- **Qualification — what kind of problem is this?** A technical judgment. Claude provides the evidence.
- **Priority — does addressing it now justify the cost, disruption and opportunity cost?** A business judgment. You decide.

A problem can be real, reproducible and structural without being worth resolving now. Structural classification does not itself authorise structural investigation.

### 1.1 Describe the problem in observable terms

Start from what you observed. Do not start from a technical theory, because a theory in the problem statement becomes the diagnosis nobody challenges.

Good:

> When two Claude Code sessions work at the same time, they sometimes create conflicting files or identifiers. Previous instructions telling sessions to coordinate have not prevented it. The result is manual cleanup and uncertainty about which output is authoritative.
> 

Weak:

> The repository has a concurrency architecture defect.
> 

State what you were trying to do, what you expected, what actually happened, how often, why it matters, and what has already been attempted.

### 1.2 Qualify the lane

The test is **whether current evidence indicates the problem can be safely resolved as a bounded local correction** — not how many times it has occurred.

**Lane A** where the defect is bounded, its correction is local, and resolving it does not require changing a shared mechanism or the operating model. A frequently recurring but bounded local defect stays in Lane A. Repetition alone is not structural.

**Lane B** where the problem:

- crosses ownership, workflow, component or repository boundaries;
- depends on shared state, hidden coupling or ambiguous authority;
- creates false-success behaviour — the system reports completion when required work did not happen;
- has survived a relevant prior correction;
- repeatedly generates compensating controls, guards, warnings or repair tasks;
- or requires a change to the operating model or a governing mechanism.

A serious first-observed shared-state or data-integrity problem may qualify for Lane B immediately. Waiting for a second occurrence is not required and may be irresponsible.

**The lane decision is provisional.** Reroute whenever the evidence changes:

> **Rerouting rule:** if Lane A diagnosis reveals shared state, hidden coupling, ambiguous authority, false-success behaviour or a non-obvious cause, stop and re-enter at Lane B Step B1. If Lane B investigation shows the cause is bounded and locally correctable after all, drop to Lane A rather than completing the structural process for its own sake. Record the reroute and the evidence that caused it.
> 

### 1.3 Select the Lane A depth

Where the case enters Lane A, Claude recommends the depth from current evidence. You should not have to make a test-design judgment.

**Simple repair** where the defect is bounded and low-consequence; the incorrect behaviour or content can be confirmed directly; the correction is obvious and local; no shared mechanism, hidden coupling or ambiguous authority is involved; and recurrence would not justify maintaining a permanent regression test.

Typical: documentation errors, broken references, configuration typos, incorrect literal values with no downstream behaviour.

**Test-backed repair** where the defect affects executable behaviour; recurrence would matter; the cause or the affected consumers require diagnosis; the correction could create regressions; the real invocation path needs protection; or an executable regression case provides durable value proportionate to its maintenance cost.

The selection principle:

> Require the lightest repair depth that can demonstrate the correction reliably
and protect against recurrence in proportion to the consequence.
> 

A permanent regression test is not automatically valuable. Where maintaining the test would cost more than the recurrence risk warrants, direct verification and diff review are sufficient.

### 1.4 Decide priority

**Gate 1 — Admission.** You decide whether to proceed now. Keep the assessment brief and proportionate to the problem; this is a judgment, not an appraisal exercise.

Consider: the practical consequence if nothing changes; frequency and affected workflows; data, security, recovery or operational risk; whether the problem blocks or materially impairs current priority work; whether a safe workaround exists; the likely cost and disruption of investigation; the cost of postponement.

Constraints on this decision:

- Technical importance is not automatic business priority. A structurally interesting problem with no operational consequence may legitimately remain unresolved.
- Serious safety, security, data-integrity or irreversible-loss risks are not deferred because rollout work is busy. These are the cases where postponement cost is highest and least visible.
- You are not judging technical correctness. You are judging whether the expected value justifies the disruption.

Record the outcome using the vocabulary above. Where the outcome is *Defer* or *Operate around*, the case record must carry the reason, the known consequence and the reconsideration trigger.

**Prompt 1 — Qualification and priority evidence (Claude)**

```
Qualify a repository problem and provide the evidence I need to decide priority.
Do not fix anything and do not propose a solution in this response.

OBSERVED PROBLEM

[PASTE YOUR PLAIN-LANGUAGE PROBLEM STATEMENT]

Inspect the current repository and determine:

1. Whether the problem still exists, and whether it can be demonstrated now.
2. Whether it has already been fixed, duplicates a known issue, or rests on an
   outdated premise.
3. Whether the correction is likely to be bounded and local, or whether it would
   require changing a shared mechanism or the operating model.
4. Whether the problem crosses ownership, workflow, component or repository
   boundaries.
5. Whether it depends on shared state, hidden coupling or ambiguous authority.
6. Whether the system reports success while required work is incomplete.
7. Whether a relevant prior correction has already been attempted and survived by
   the problem.
8. Whether it repeatedly generates compensating controls, guards or repair tasks.

Then provide PRIORITY EVIDENCE — facts, not a recommendation on whether to
proceed:
- practical consequence if nothing changes
- frequency, and which workflows are affected
- any data, security, recovery or operational risk
- whether it blocks or impairs work currently in progress
- whether a safe workaround exists, and what it costs
- your estimate of investigation cost and disruption
- what gets worse if this is left for later

Classify every material statement as OBSERVED (directly demonstrated by
inspection or execution), INFERRED (reasoned from evidence, not demonstrated),
or UNKNOWN.

Recommend one qualification:

- NORMAL REPAIR — SIMPLE: bounded, low consequence, correction obvious and
  local, direct verification sufficient, no permanent regression test warranted
- NORMAL REPAIR — TEST-BACKED: bounded, but affects executable behaviour or
  recurrence matters enough to justify a durable regression case
- STRUCTURAL: cannot be safely resolved as a bounded local correction
- NOT CONFIRMED: insufficient current evidence — state what evidence exists and
  what would establish or eliminate the problem

Recurrence alone does not make a problem structural. A frequently recurring but
bounded local defect is a normal repair. A first-observed shared-state or
data-integrity problem may be structural immediately.

I make the priority decision. Do not tell me whether the work is worth doing.
```

**Complete this step when:** the lane and, in Lane A, the depth rest on stated evidence; the priority decision has been made by the operator; and the case carries one outcome from the vocabulary above. Where the outcome is *Defer*, *Operate around*, *Not confirmed* or *No action justified*, the case record carries the reason and any reopening trigger, and work stops here.

---

# Part I — Lane A: Normal Repair

**Confirm → correct → verify → review → integrate → close.** Most defects stay here.

Steps A3 and A4 apply to **test-backed repair only**. A simple repair runs A1, A2, A5, A6.

## Step A1 — Preserve State and Set the Change Boundary

Claude inspects and reports the current branch, worktree and Git status, and states what is uncommitted.

**Claude does not modify, stage or commit unrelated work.** Uncommitted work in the tree belongs to you. Deciding what enters a commit, and under what message, is not delegated.

Claude starts from a separate branch or worktree at an agreed base commit. Where the correct base depends on uncommitted work, Claude stops and asks for direction rather than resolving it itself.

One implementing agent per writable worktree. Where Codex needs repository access, it works from a separate worktree or a read-only context, pinned to a clear base and target commit.

**Complete this step when:** the Git state is reported, the base commit is agreed, unrelated work is untouched, and the change boundary and rollback path are clear.

## Step A2 — Confirm the Defect

The defect must be established before any correction is designed.

- **Simple repair:** direct confirmation is sufficient. Observing the broken link, the wrong value or the incorrect content is confirmation.
- **Test-backed repair:** reproduce the failure, or establish it through reliable current execution evidence.

Audits, logs, warnings and old issue records are leads, not proof — they count when confirmed against current repository behaviour.

> **Condition:** where the defect cannot be confirmed, the outcome is **Not confirmed**. Record the attempted confirmation and what would establish it. Do not correct speculatively, and do not record the case as resolved or as no action justified.
> 

> **Condition:** never perform unsafe or destructive reproduction to satisfy this step. Where reproduction would risk data, production state or irreversible change, rely on preserved outputs, logs or trustworthy execution records instead.
> 

**Complete this step when:** the defect is confirmed, or the case carries *Not confirmed* and stops.

## Step A3 — Diagnose *(test-backed repair only)*

Claude identifies the exact failure path, the root cause, affected consumers, the blast radius, simpler interventions and recovery implications. Presumed causes are labelled as inferences, not stated as fact.

Where the failure is described in terms of a file, instruction or configuration, confirm the actual runtime path. The presence of a rule does not establish that the rule executes.

> **Condition:** apply the rerouting rule. Shared state, hidden coupling, ambiguous authority, false-success behaviour or a non-obvious cause means Lane B, not a cleverer local fix.
> 

**Complete this step when:** the cause is confirmed rather than presumed, and the affected consumers are named.

## Step A4 — Establish the Regression Case *(test-backed repair only)*

Demonstrate that the real failure is detectable before correcting it. Where practical and safe, the case fails for the diagnosed reason before the correction is applied.

The case must exercise the real invocation path rather than inspect implementation shape. A test that asserts a function exists, or that a file contains a phrase, is not a regression case.

Where safe reproduction is impossible, record what the case would need to cover and why it could not be written. Do not substitute a test that passes for the wrong reason.

**Complete this step when:** a case exists that would catch the failure if it returned, or the reason one could not be written is recorded.

## Step A5 — Correct Narrowly

Claude considers corrections in this order and justifies moving past each one:

1. Removal — delete the thing that fails.
2. Simplification — reduce what is there.
3. Restoring the intended path — the mechanism was correct but bypassed.
4. Consolidating authority — the rule exists in several places and they disagree.
5. A narrow fix.
6. A new guard, warning or control — last resort only.

Change only what the confirmed cause requires. No unrelated cleanup. For a simple repair this ladder is usually answered in one line; do not turn it into an essay.

**Complete this step when:** one bounded correction exists, and nothing outside it has changed.

## Step A6 — Verify, Review, Integrate and Close

**Verify.** Run the regression case where one exists, the surrounding tests, and the actual operator or runtime path. For a simple repair, verify the corrected content or path directly. A hook, rule or guard does not count merely because its file exists.

**Review.** Inspect the final diff. Confirm that unrelated files were not changed and the change is recoverable. Apply the **Independent Review SOP** at the level the consequence warrants — most Lane A repairs are Level 1; test-backed repairs touching shared behaviour may be Level 2.

**Integrate.** Claude does not merge its own work. You authorise integration once verification and diff review are complete. For anything touching a shared path, use the change once in real conditions before wider use resumes.

**Close.** The outcome is **Resolved** only when the previously failing path completes correctly. Not because a change was made, and not because the diagnosis was persuasive.

**Prompt A — Lane A repair (Claude)**

```
Repair a confirmed repository defect. This is a normal repair, not a structural
investigation. Keep it bounded.

PROBLEM AND QUALIFICATION

[PASTE THE PROBLEM STATEMENT AND THE QUALIFICATION OUTPUT, INCLUDING THE
AGREED DEPTH: SIMPLE or TEST-BACKED]

1. PRESERVE
   Report the current branch, worktree and Git status, and what is uncommitted.
   Do NOT modify, stage or commit unrelated work — it is not yours to commit.
   Work from a separate branch or worktree at the agreed base commit. If the
   correct base depends on uncommitted work, stop and ask.

2. CONFIRM THE DEFECT
   Simple repair: confirm the incorrect content or behaviour directly.
   Test-backed: reproduce the failure, or establish it through reliable current
   execution evidence.
   If you cannot confirm it, stop and report NOT CONFIRMED with the evidence you
   do have and what would establish it. Do not correct speculatively.
   Never attempt unsafe or destructive reproduction to satisfy this step.

3. DIAGNOSE  [test-backed only]
   Exact failure path, root cause, affected consumers, blast radius, recovery
   implications. Label anything not directly demonstrated as INFERRED.
   STOP AND REPORT if you find shared state, hidden coupling, ambiguous
   authority, false-success behaviour or a non-obvious cause — that is a
   structural problem and this prompt is the wrong route for it.

4. REGRESSION CASE  [test-backed only]
   Write a case that fails for the diagnosed reason and exercises the real
   invocation path. Confirm it fails before you correct anything. If a safe case
   cannot be written, say what it would need to cover and why.

5. CORRECT
   Consider in this order and justify skipping each: removal; simplification;
   restoring the intended path; consolidating authority; a narrow fix; a new
   control. A new control is the last option, not the first.

6. VERIFY AND REPORT
   Run the regression case where one exists, the surrounding tests, and the
   actual operator or runtime path — or verify the corrected content directly
   for a simple repair. Report the commands and their real output.

Constraints:
- no unrelated cleanup;
- no new commands, agents, hooks, registers or gates;
- do not merge;
- do not claim the problem is resolved — state that the repair is ready for
  review and integration.

Report: files changed and deleted, verification commands and actual results,
deviations, remaining limitations, rollback instructions.
```

**Complete this step when:** verification passed, the diff was reviewed, you authorised integration, and the case carries **Resolved**.

---

# Part II — Lane B: Structural Resolution

Lane B adds four things Lane A does not have: proof before diagnosis, an independent Codex reading of the evidence *before* it sees Claude's explanation, a locked implementation scope, and executable tests as the durable record.

**The five gates**

| Gate | Required result | Owner | Failure outcome |
| --- | --- | --- | --- |
| 1. Admission | Qualifies as structural, and is worth addressing now | Operator, on Claude's evidence | Lane A, Defer, Operate around, Not confirmed, or No action justified |
| 2. Failure proof | Failure reproduced or established by reliable current evidence | Claude, challenged by Codex | Case carries Not confirmed |
| 3. Design approval | Causal mechanism and intervention supported | Codex challenges, operator approves | Revise, gather evidence, or stop |
| 4. Technical verification | Independent execution and review pass | Codex and automated tests | Return to Claude or revert |
| 5. Operational closure | Integrated and supported by representative real use | Operator, on observed evidence | Keep open, revise, or revert |

A gate is not passed through narrative confidence. It is passed through defined evidence.

**Authority hierarchy.** When sources conflict about current behaviour: reproducible execution; current code and configuration; automated tests; repository documentation; system summaries; historical logs and previous model conclusions. A model must never use an old audit, issue description or previous AI conclusion to override current observable behaviour.

## Step B1 — Preserve State and Build the Context Manifest

Claude reports the current branch, worktree and Git status. **It does not modify, stage or commit unrelated work.** Work proceeds on a dedicated branch or worktree from an agreed base commit. Where the correct base depends on uncommitted work, Claude stops for your direction. Neither model edits the main working directory or the same tree as the other.

Then define what context each model may use. Claude should not be handed a general link to the repository and told to inspect whatever it considers relevant — that is how an investigation becomes a redesign.

The manifest identifies: affected repositories; exact base commit; whichever governing documents exist and are relevant; previous related cases; reproduction or forensic evidence; tests that must be run; approved investigation scope; explicit exclusions.

**Where governing documentation is absent, incomplete or of uncertain authority, record that gap in the manifest and proceed.** A missing system map is a recorded limitation, not a stop condition. Do not create governance documents to satisfy this step.

**Complete this step when:** the repository state is recoverable, unrelated work is untouched, the base commit is recorded, and the manifest states the scope, the exclusions and any authority gaps.

## Step B2 — Claude Establishes the Failure Without Fixing

**Gate 2 — Failure proof.** No diagnosis or solution design begins until the failure is established.

Claude establishes exact observed behaviour, expected behaviour, reproduction steps or forensic evidence, execution evidence, affected components and workflows, practical consequences, recurrence evidence, and previous attempted corrections.

**Reproduction is the strongest evidence but not the only admissible evidence.** Intermittent, concurrency-dependent, destructive, production-only and externally dependent failures may be established through preserved outputs, logs, traces or trustworthy execution records where direct reproduction is unsafe or impractical. Unsafe or destructive reproduction is never required to satisfy this SOP.

Every material statement is classified **Observed**, **Inferred**, **Proposed** or **Unknown**. Missing evidence stays missing — no "likely," "probably" or assumed behaviour where the fact can be checked directly.

> **Condition:** where the failure can be neither reproduced nor established through reliable current evidence, the case carries **Not confirmed**. Record the available evidence and what would justify reopening. This is not *No action justified*, which requires the premise to be disproved, obsolete, duplicated or out of scope.
> 

**Prompt B2 — Failure proof (Claude)**

```
Investigate a suspected structural repository problem. You are an investigator in
this session. Do not fix anything, do not modify any file, and do not propose a
solution yet.

Report the current branch, worktree and Git status first. Do NOT modify, stage or
commit unrelated work.

CONTEXT MANIFEST

[PASTE THE MANIFEST: repositories, base commit, available governing documents,
previous cases, scope, exclusions, known authority gaps]

OBSERVED PROBLEM

[PASTE THE PROBLEM STATEMENT]

Produce:

1. Reproduction steps and the actual command outputs you observed — OR, where
   reproduction is unsafe or impractical, the forensic evidence that establishes
   the failure: preserved outputs, logs, traces, execution records. State which
   route you took and why.
2. Observed behaviour versus expected behaviour.
3. Affected files, components and workflows.
4. Evidence of previous occurrences and previous attempted corrections.
5. Practical consequence.
6. A proposed failing test or reproduction script, where one can be written
   safely.
7. What is confirmed, and what remains uncertain.
8. Possible explanations — as candidates only, not a chosen diagnosis.

Classify every material statement as:
  OBSERVED  — directly demonstrated by inspection or execution
  INFERRED  — reasoned from evidence but not demonstrated
  PROPOSED  — a possible explanation or intervention
  UNKNOWN   — evidence insufficient

Rules:
- Every OBSERVED claim points to a file and line, a commit, a test, or a command
  and its output.
- Do not state that tests pass without running them. Reading test code is not
  execution.
- Where a fact can be checked directly, check it rather than estimating.
- Audits, logs, warnings and old issue records are leads, not proof.
- Do NOT attempt unsafe or destructive reproduction. If establishing the failure
  would risk data, production state or irreversible change, stop and say what
  forensic evidence is available instead.

If the failure can be neither reproduced nor established through reliable current
evidence, report NOT CONFIRMED with the evidence you have and what would
establish or eliminate it. An unconfirmed issue is a valid and useful result — do
not manufacture a diagnosis to avoid it.
```

**Complete this step when:** the failure is established through reproduction or reliable current evidence and the Observed/Inferred split is explicit — or the case carries *Not confirmed* and stops.

## Step B3 — Codex Reviews the Evidence Blind

Codex must read the evidence **before** it sees Claude's explanation. This is what keeps the review independent rather than a second opinion on a conclusion it has already absorbed.

**This requires a fresh Codex context.** Your main Codex conversation is the session guide — it prepares prompts, holds project continuity and will already have seen Claude's investigation. That conversation cannot perform this review, regardless of instructions given to it.

The arrangement:

- The main Codex conversation continues to guide you and prepare prompts. Nothing about that changes.
- The blind evidence review runs in a **new Codex session** that has not seen Claude's diagnosis.
- That reviewer receives the context manifest, the problem statement and the raw evidence only.
- Check that Claude's diagnosis is not reachable through a case document or other material you paste in. A manifest that links to a case file containing the diagnosis defeats the control.
- Lane A does not require a blind review.

No new agent architecture or orchestration is needed. A fresh session and a clean context boundary are sufficient.

**Prompt B3 — Blind evidence review (fresh Codex session)**

```
Independently interpret evidence about a suspected structural repository problem.

You are being used as an independent reviewer in a clean context. You have not
been given anyone else's diagnosis, and you should not ask for one — the point of
this review is that your reading of the evidence is formed before you see theirs.
Do not modify any files.

CONTEXT MANIFEST

[PASTE THE MANIFEST — CHECK IT DOES NOT LINK TO A CASE FILE CONTAINING THE
DIAGNOSIS]

OBSERVED PROBLEM

[PASTE THE PROBLEM STATEMENT]

EVIDENCE

[PASTE THE REPRODUCTION STEPS OR FORENSIC EVIDENCE, RAW COMMAND OUTPUTS,
AFFECTED FILES, AND PREVIOUS ATTEMPTED FIXES — NO PROPOSED DIAGNOSIS]

Inspect the repository yourself where necessary and determine:

1. What has actually been proven by this evidence.
2. What has not been proven, and what is being asserted without support.
3. Whether the reproduction or forensic evidence is valid, or whether it
   demonstrates something other than the reported problem.
4. Which causal mechanisms could explain the evidence — list every credible one,
   not only the most obvious.
5. What additional evidence would distinguish between them.
6. Whether this could be caused by operator practice rather than repository
   architecture.
7. Whether the problem is genuinely structural, or a bounded defect that should
   be handled as a normal repair.

Return:
- confirmed facts
- unproven claims
- credible explanations, with what would support or eliminate each
- missing checks
- recommended next investigation step
```

**Complete this step when:** a fresh Codex context has named the credible explanations independently, and any explanation it raises that Claude did not consider is recorded.

## Step B4 — Claude Produces the Causal Model and Structural Options

### B4.1 The causal chain

**Observed failure → immediate technical mechanism → enabling system property → broader failure class → intervention point**

Worked example:

> Two sessions allocate the same identifier → both read and update the same mutable file → parallel sessions depend on central shared state → coordination is implemented through non-atomic file mutation → eliminate shared allocation or replace it with an atomic mechanism
> 

The objective is not an unquestionable philosophical root cause. It is the causal mechanism that is sufficiently supported by evidence and must change to prevent recurrence.

Claude must document competing explanations, evidence for and against, confidence level, and **what finding would disprove the diagnosis**. A diagnosis that cannot be disproved has not been stated precisely enough.

### B4.2 The option ladder

1. Eliminate the triggering condition.
2. Simplify the operating model.
3. Remove the problematic component.
4. Narrow or reuse an existing mechanism.
5. Isolate the affected capability.
6. Redesign the causal mechanism.
7. Repair the existing implementation.
8. Add a new guard, warning, gate or control — last resort only.

The recommendation is the least-complex intervention that removes, contains or materially reduces the proven mechanism. This does not mean the fewest changed lines: a slightly broader simplification is preferable to a narrow patch that preserves the underlying condition.

**Prompt B4 — Causal model and options (Claude)**

```
Develop a causal model and compare structural interventions. Do not implement
anything and do not modify any file.

ESTABLISHED FAILURE AND EVIDENCE

[PASTE YOUR FAILURE-PROOF OUTPUT]

INDEPENDENT EVIDENCE REVIEW

[PASTE THE BLIND CODEX REVIEW]

Where the independent review identified an explanation you had not considered,
address it explicitly rather than restating your original view.

Produce:

1. CAUSAL CHAIN
   Observed failure → immediate technical mechanism → enabling system property →
   broader failure class → intervention point.
   Explain each link in plain English, without unexplained terminology.

2. COMPETING EXPLANATIONS
   - every credible alternative
   - evidence supporting the preferred explanation
   - evidence against each alternative
   - your confidence level
   - what observation would DISPROVE your diagnosis

3. STRUCTURAL OPTIONS
   Compare in this order of preference, and justify skipping each: eliminate the
   triggering condition; simplify the operating model; remove the component;
   narrow or reuse an existing mechanism; isolate the capability; redesign the
   mechanism; repair the implementation; add a new guard or control.

   For each realistic option state: which part of the causal mechanism it
   changes; whether it prevents, contains or merely detects the failure;
   complexity added; complexity removed; maintenance created; new failure modes;
   operational limitations; reversibility; migration required; how it is tested.

4. RECOMMENDATION
   The least-complex intervention that removes or materially reduces the proven
   mechanism.

5. COMPLEXITY EFFECT
   Permanent machinery added. Permanent machinery removed. Continuing maintenance
   created. Whether the repository becomes structurally simpler.

6. PROPOSED SCOPE
   Exact files and components expected to change; behavioural change required in
   each; what should be deleted; what must remain unchanged; explicit non-goals;
   any cross-repository effect.

7. VERIFICATION PLAN
   How the correction will be demonstrated; relevant existing tests; regression
   tests to add; what result would show the correction FAILED.

Do not present one solution as inevitable. Do not propose new commands, agents,
hooks, registers, services or databases unless you can show that removal or
simplification cannot solve the problem more safely.
```

**Complete this step when:** the causal mechanism is supported strongly enough to justify intervention, alternatives were compared, and a disproving observation has been stated.

## Step B5 — Codex Challenges the Diagnosis and the Complexity

Codex now sees Claude's reasoning and challenges it, including a specific search for unnecessary permanent mechanisms. This review does not need a fresh context — the anchoring risk it guards against has already passed.

Any new permanent mechanism requires answers to: what verified failure requires it; why removal or a process restriction cannot solve the issue; which existing mechanisms were considered; what maintenance it creates; who owns that maintenance; how it fails visibly; how it is removed later.

**The default complexity budget is zero.** A structural fix should preferably remove mechanisms, or replace several fragile controls with one simpler mechanism.

**Prompt B5 — Design challenge and over-engineering review (Codex)**

```
Challenge a proposed structural correction. Do not modify any files. Inspect the
repository independently where necessary.

ESTABLISHED FAILURE AND EVIDENCE

[PASTE THE FAILURE-PROOF OUTPUT]

INDEPENDENT EVIDENCE REVIEW

[PASTE THE BLIND REVIEW]

CLAUDE'S CAUSAL MODEL AND PROPOSED CORRECTION

[PASTE CLAUDE'S COMPLETE ANSWER]

Assess:

 1. Whether the evidence supports the proposed causal mechanism.
 2. Whether Claude has treated correlation as causation.
 3. Whether another explanation still fits the evidence equally well.
 4. Whether the proposal changes the causal mechanism, or merely adds
    instructions, warnings and checks above it.
 5. Whether old mandatory machinery would remain active underneath the
    correction.
 6. Whether removal, simplification or an operational restriction would be safer.
 7. What new failure modes or maintenance obligations the correction creates.
 8. Whether the scope is too narrow, too broad, or correctly proportioned.
 9. Which proposed changes should be removed from the scope entirely.
10. Whether the tests would demonstrate BEHAVIOUR rather than inspect
    configuration.
11. What evidence would justify reverting the change after implementation.
12. What must change before implementation begins.
13. Whether this is genuinely structural, or a bounded defect that should drop to
    a normal repair.

Then run an explicit over-engineering pass. Assume the proposal is more
complicated than necessary and find the simplest credible alternative. Search
specifically for unnecessary new commands, agents, hooks, databases, shared
state, recurring processes, cross-repository dependencies, duplicated
documentation and additional gates.

For every proposed permanent mechanism, require: what verified failure needs it;
why removal or a process restriction is insufficient; which existing mechanism
was considered; what maintenance it creates; who owns it; how it fails visibly;
how it is removed later.

Apply this central test:

  Would the repository actually contain materially less machinery after this
  correction, or would it merely contain more instructions saying it should?

Return one verdict:
  Proceed
  Proceed with required corrections
  More evidence required
  Reconsider the approach
  Close

Give required corrections as a short, actionable list suitable for sending
directly back to Claude. Separate required corrections from optional
suggestions. State what you inspected or ran.
```

> **Condition:** *More evidence required* or *Reconsider the approach* returns to Step B4. *Close* ends the case as *No action justified* where the premise is disproved, or *Not confirmed* where the evidence is merely insufficient.
> 

**Complete this step when:** Codex has returned one verdict, separated required from optional findings, and stated what it inspected or ran.

## Step B6 — Approve the Trade-off and Lock the Scope

**Gate 3 — Design approval.** Your decision, and it is about trade-offs, not code.

You should receive a short comparison containing: the established problem; the supported diagnosis; the recommended solution; simpler alternatives considered; capabilities affected; complexity added; complexity removed; maintenance requirement; rollback approach; required tests; known uncertainty.

You approve whether work should proceed, which capability trade-off is acceptable, whether the complexity is justified, and whether the scope is appropriate. You do not approve technical correctness — that remains subject to implementation and verification.

Ask before approving:

- What will change in practice, and what will no longer happen?
- Which old instructions or mechanisms are being removed, not just added to?
- Is Claude replacing rules or stacking new ones on top?
- Does the change reduce permanent machinery?
- How will this be tested using an actual representative case?
- Can it be reversed?

**Prompt B6 — Scope lock and implementation authorisation (Claude)**

```
I approve the following structural correction.

APPROVED PLAN

[PASTE THE FINAL PLAN AS REVISED THROUGH CODEX REVIEW]

This is now the locked implementation scope.

Report the current Git status first. Do NOT modify, stage or commit unrelated
work. Create a dedicated implementation branch and worktree from the agreed base
commit. If the correct base depends on uncommitted work, stop and ask. Do not
modify the main branch.

Implement only the approved correction.

Requirements:
- modify or remove the mechanisms causing the failure;
- do not add a new policy or control above unchanged mandatory machinery;
- no unrelated repository cleanup;
- no unapproved commands, agents, hooks, registers, services, databases or
  mandatory gates;
- preserve the capabilities the plan says must remain;
- add regression tests tied to the ORIGINAL failure, testing behaviour rather
  than implementation shape;
- test at least one failure path;
- remove superseded controls where safe.

STOP AND RETURN FOR RENEWED APPROVAL if implementation reveals a need for:
materially different architecture; a new permanent service, agent or shared-state
mechanism; cross-repository changes not already approved; removal of additional
capabilities; a different causal diagnosis; or a substantially larger change. Do
not stop for ordinary implementation details inside the approved scope.

When implementation is complete:
 1. Do not merge. You do not authorise integration.
 2. Commit the implementation branch.
 3. Report the base commit and the implementation commit.
 4. List every changed and deleted file.
 5. Explain the behavioural change in each affected component.
 6. Report machinery added and machinery removed.
 7. Provide the actual test commands and their real output.
 8. Show the generated output of a representative real case.
 9. Identify deviations from the approved plan.
10. Identify remaining limitations.
11. Provide rollback instructions, and state how the change can be reversed after
    integration.

Do not claim the problem is resolved. State only that the implementation is ready
for independent verification.
```

**Complete this step when:** the scope contract states the problem, the mechanism being changed, the components included, expected behaviour after the change, non-goals, required tests, and what requires renewed approval.

## Step B7 — Claude Implements in a Controlled Worktree

Claude works in the dedicated branch or worktree, one writer at a time, from a known base commit, with a rollback path that remains usable after integration.

A change is not structural merely because it modifies architecture. It must demonstrably alter the condition that allowed the failure.

Claude may not declare the issue durably fixed, and does not merge. It states that implementation is complete and ready for independent verification.

**Complete this step when:** the implementation is committed on its own branch, unmerged, with an evidence report containing real executed output.

## Step B8 — Codex Verifies From a Clean Environment

**Gate 4 — Technical verification.** Codex works from a clean checkout or separate worktree and does not rely on output pasted by Claude.

**Codex verifies. It does not authorise integration.** A verification verdict is technical evidence for your decision at Step B9, not permission to merge.

**Prompt B8 — Independent verification (Codex)**

```
Independently verify a structural correction. Work from a clean checkout or a
separate worktree. Do not rely on output reported by Claude — run the commands
yourself. Do not modify any files and do not merge anything.

APPROVED SCOPE

[PASTE THE LOCKED SCOPE CONTRACT]

ORIGINAL FAILURE AND EVIDENCE

[PASTE THE REPRODUCTION OR FORENSIC EVIDENCE]

IMPLEMENTATION REPORT

[PASTE CLAUDE'S COMPLETE REPORT, INCLUDING BASE AND IMPLEMENTATION COMMITS]

Independently execute:
- the original reproduction case, where it can be run safely
- the new regression tests
- relevant existing tests
- at least one failure-path scenario
- the affected surrounding workflow

Then assess:

 1. Does the original failure still occur?
 2. Does the implementation match the approved design?
 3. Were unrelated changes introduced? Was any unrelated work committed?
 4. Does the regression test genuinely represent the original failure, or was it
    written around the new implementation?
 5. Does the test exercise the real invocation path?
 6. Did complexity increase or decrease? Report machinery added and removed.
 7. Was hidden coupling introduced, or a new single point of failure created?
 8. Do obsolete controls remain, and were they deliberately retained or simply
    left behind?
 9. Is the rollback path real and usable after integration, not only before it?
10. Is Claude's completion claim supported by what you actually observed?

Return one verdict:
  Proceed
  Proceed with recorded limitations (list them explicitly)
  Proceed with required corrections
  Reconsider the approach — the diagnosis remains unproven
  Revert

State exactly which commands you ran and what output you observed. A claim that
something works is not acceptable without the execution behind it.

You are verifying, not authorising. The operator decides whether this is
integrated.
```

Then require a plain-language brief before integration: what was wrong; what changed; what evidence shows the old problem no longer occurs; what tests were independently run; what could still go wrong; whether complexity increased or decreased; how the change is reversed; whether operational validation is still required.

Do not accept a brief whose claims cannot be traced to the commands Codex actually ran. Do not approve integration if the explanation depends on technical language you cannot follow — ask for it to be rewritten until the practical logic is clear.

**Complete this step when:** Codex has independently executed the evidence, returned one verdict, and produced an operator-readable brief traceable to executed commands.

## Step B9 — Integration, Operational Validation and Closure

**Gate 5 — Operational closure.** This gate opens with integration and closes with evidence from real use. Both halves are yours.

### B9.1 Authorise integration

**Which verdicts permit further action:**

| Verdict | Effect |
| --- | --- |
| Proceed | Integration may be authorised. |
| Proceed with recorded limitations | Integration may be authorised once you have explicitly accepted each listed limitation. |
| Proceed with required corrections | Return to Step B7. Re-verify before integration. |
| Reconsider the approach | Return to Step B4. Not integrated. |
| Revert | Abandon the branch. Case returns to *Not confirmed* or *No action justified*. |

You authorise controlled integration — a merge, a staged activation, or enabling the change for one workflow first. Claude does not merge its own work and Codex does not authorise it.

For cross-repository or high-risk changes, do not change everything at once. Start with one limited workflow or repository.

**The rollback path must remain usable throughout operational validation**, not only up to the merge. Confirm before authorising integration that you know how to reverse the change once it is live.

### B9.2 Run representative use

Some problems only appear under real usage: parallel sessions, long-running workflows, incomplete context, interactions between repositories, real model behaviour, recovery after interruption, and use under time pressure.

Define before implementation what representative use means, how many genuine executions are required, what failure signals will be observed, and what would reopen the issue. Keep it proportionate — a shared-state fix may need several parallel sessions; a planning workflow may need one or two complete real projects.

Status during this stage is **Integrated, awaiting operational validation**. The case is not resolved.

**If operational validation fails:** reverse the change using the preserved rollback path, record what was observed, and return the case to Step B4 with the new evidence. A failure during validation is evidence about the diagnosis, not merely a defect in the implementation — treat it as a reason to re-examine the causal model, not to patch the symptom.

### B9.3 Close

The case carries **Resolved** only when: the failure was established; the causal mechanism was documented; a fresh Codex context interpreted the evidence independently; structural options were compared; the intervention was approved; implementation stayed within scope; the original failure was retested; regressions were tested; the change was integrated; representative use supported the result; obsolete controls were removed or deliberately retained; limitations were documented; and recovery references were recorded.

The closure record stays concise: problem; proven causal mechanism; structural intervention; test evidence; Codex verdict; integration decision; operational validation; known limitations; base commit; implementation commit; revert instructions.

**Complete this step when:** the change is integrated, the defined operational evidence has been collected, and the case carries one terminal outcome.

---

# Part III — Controls That Apply to Both Lanes

These apply to every repository case. Lane B's additional controls are in Part II and are not universal requirements.

## Universal closure requirements

A case closes only when:

- the defect was confirmed, or the case carries *Not confirmed* with its evidence recorded;
- the correction was verified against the real path, not against documentation;
- the diff was reviewed and unrelated work was untouched;
- integration was authorised by the operator;
- the change is reversible and the rollback path is recorded;
- the case carries exactly one outcome from the vocabulary in the Purpose.

Everything beyond this — blind evidence review, causal modelling, separate-environment verification, representative operational use — is a Lane B requirement and is not expected of a normal repair.

## No model authorises its own work

Claude does not merge. Codex verifies but does not authorise integration. Claude may recommend closure; it cannot declare it. This applies in both lanes.

## Unrelated work is never committed by a model

In both lanes and every prompt: Claude reports Git status, does not modify, stage or commit anything outside the authorised change, and stops for direction where the correct base depends on uncommitted work.

## Tests as durable memory

Written instructions are weak controls, because future models may misunderstand, ignore or reinterpret them. Where a failure justifies durable protection, it becomes a regression test, a reproduction script, an invariant check or an observable failure condition.

If a workflow previously reported success without producing an output, the durable solution includes an executable test proving that success cannot be returned when the output is missing. The test encodes the behaviour, not the implementation details, so the protection survives refactoring.

This is not universal. A permanent test carries permanent maintenance. Where the recurrence risk does not justify that cost — a documentation typo, a broken link — direct verification and diff review are the proportionate answer.

## Required artifacts

A Lane B case produces five artifacts and no more: one case document (evidence, diagnosis, decisions, closure); one reproduction case, failing test or forensic evidence record; one approved implementation scope; one implementation diff with regression tests; one verification verdict.

A Lane A case produces a diff, its verification evidence, and a one-line outcome record. A simple repair does not need a case document.

No issue database, orchestration platform, scoring model or new command system is required, in either lane.

## Definition of a durable fix

A fix is durable when it changes the proven causal mechanism; makes recurrence impossible or materially less likely; does not depend on a model remembering written guidance; is enforced through structure or executable behaviour; produces observable rather than silent failure; includes recovery behaviour; survives representative use; does not introduce disproportionate maintenance; reduces or does not materially increase complexity; makes temporary controls unnecessary where possible; and remains understandable to a future operator or model.

## Warning signs — stop the process

Universal:

- The defect cannot be confirmed, but correction proceeds anyway.
- Claude begins implementing before establishing the failure.
- Either model uses "likely," "probably" or "should work" instead of checking.
- The models cannot explain the solution in plain language.
- The scope expands during implementation.
- Claude reports that tests pass without providing executed results.
- Unrelated work was staged or committed.
- The change cannot be rolled back.
- Obsolete controls remain "just in case" without justification.
- The issue is called fixed after one successful test.
- A structural problem is being repaired locally for the third time.

Lane B specifically:

- Codex repeats Claude's language without independent analysis.
- The blind review was run in a context that had already seen the diagnosis.
- Codex verifies only by reading Claude's summary.
- A test passes only because it was designed around the new implementation.
- The original evidence is not re-checked after implementation.
- The solution depends on future models remembering an instruction.

## High-risk changes

Apply additional caution where a change affects data deletion or migration; authentication or access control; security, secrets or credentials; production deployment; repository permissions; Git history; shared dependencies; cross-repository automation; concurrent sessions; background processes; backups; or irreversible file conversion.

For these: add at least one further independent review, restrict the first implementation to a copy or test environment, and do not proceed without a tested recovery path. These changes are not deferred on grounds of rollout workload.

## The limits of this approach

Using one AI system to review another is useful, but it is not equivalent to independent expert engineering review. Both models may share assumptions, misunderstand the same behaviour, accept an incorrect problem statement, design tests that confirm their own assumptions, or report success on incomplete execution.

The protection is not "Codex agrees with Claude." It is:

> Claude's claim survived independent challenge, executable testing, separate
verification, and representative use.
> 

---

# Operator Checklist

## Every case

- Was the lane chosen on whether the correction is bounded and local — not on how many times it has happened?
- Where Lane A: was the depth the lightest that demonstrates the correction reliably?
- Did I decide priority separately from technical qualification?
- Was unrelated work left untouched, unstaged and uncommitted?
- Was the defect confirmed, or does the case honestly carry *Not confirmed*?
- Was removal or simplification considered before anything was added?
- Did I inspect the diff, or accept a description of it?
- Did I authorise integration, rather than a model deciding it was ready?
- Can the change be reversed, and do I know how?
- Does the case carry exactly one outcome, with a reopening trigger where it is deferred or worked around?

## Lane B additionally

- Did a fresh Codex context see the evidence before anyone's diagnosis?
- Is the causal mechanism confirmed, or still an inference presented as fact?
- Was a disproving observation stated?
- Was every proposed permanent mechanism justified against a verified failure?
- Did I approve a trade-off rather than a technical argument?
- Was the scope locked before implementation began?
- Did Codex execute the evidence itself, from a clean environment?
- Are the claims in the plain-language brief traceable to commands actually run?
- Does the regression test represent the original failure, or the new implementation?
- Did complexity go down?
- Did the correction survive representative real use?
- Is the closure claim narrower than the evidence supports?

---

# Decision Standard

**Both lanes.** Close a case only on an explicit outcome. A repair is *Resolved* when the defect was confirmed, the narrowest sufficient correction was applied, verification exercised the real path, the diff was reviewed, and integration was authorised by the operator. Where the defect could not be confirmed, the outcome is *Not confirmed* — never *Resolved*, and never *No action justified* unless the premise was actually disproved.

**Lane B additionally.** The causal mechanism must have been independently challenged from a context that had not seen the diagnosis, verified through independent execution from a separate environment, and supported by representative real use after integration.

The final operating principle:

> Do not add a mechanism until you have established the failure, identified the
system property that enables it, and demonstrated that removal or simplification
cannot solve it more safely.
> 

Where the cause is structural, do not repair around it. Where a new control is proposed, require evidence that removal, simplification or restoring the intended path would not have been sufficient. Where the problem is real but not worth addressing now, defer it explicitly with a reconsideration trigger rather than leaving it to rot in an open state.

Fixing nothing is a valid professional outcome. Closing an issue that still fails is not.

---

# Flags and Open Points

- **Gate sets were reconciled by decision, not by evidence.** The source documents carried three incompatible gate lists. This SOP uses Admission / Failure Proof / Design Approval / Technical Verification / Operational Closure. Confirm before adopting.
- **Verdict wordings were mapped onto the Independent Review vocabulary.** Old pre-implementation verdicts: *Proceed with required changes* → Proceed with required corrections; *Redesign required* → Reconsider the approach; *Stop* → Close. Old post-implementation verdicts: *Verified* → Proceed; *Verified with accepted limitations* → Proceed with recorded limitations; *Revision required* → Proceed with required corrections; *Diagnosis remains unproven* → Reconsider the approach; *Revert recommended* → Revert.
- **Authority overlap with the Independent Review SOP is unresolved.** That SOP claims to own the review vocabulary; this one now also defines case outcomes and a verdict-to-action table. They do not currently conflict, but the boundary is not stated anywhere. Not addressed in this pass.
- **No governing System Owner layer exists.** Lane B now treats system maps, decision records and critical-rules lists as conditional context rather than prerequisites, so it is runnable without them. Whether that layer should exist at all remains an open question, deliberately not answered here.
- **The pilot case lists differ across the source documents.** The three pilots should be: a genuine structural failure; a false or inaccurate premise where the correct outcome is *No action justified*; and an over-engineering trap where simplification is sufficient. An ineffective-control case is a fourth candidate, not a substitute.
- **Operator-readable briefs remain a partial single point of failure.** Step B8 now requires that brief claims be traceable to executed commands, which catches the confidently-wrong brief that cites nothing. It does not catch a brief that cites real commands and misdescribes what they showed. No further mitigation is proposed here.
- **The Lane A depth boundary will need calibration in use.** "Recurrence would not justify maintaining a permanent regression test" is a judgment, not a rule. Expect the first few cases to sit awkwardly, and expect to move the line.
