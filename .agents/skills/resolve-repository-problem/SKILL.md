---
name: resolve-repository-problem
description: Resolves one specific repository fault through executable reproduction, hypothesis testing, bounded repair, and proof. Use when repo behavior, state, commands, workflows, configuration, or performance are broken. Do not use for audits, backlog batches, or feature work.
---

# Resolve Repository Problem

Diagnose and, where justified, repair one observed repository problem. The center
of the method is a named executable feedback loop that goes red on the reported
behavior and green only when that behavior is corrected.

This skill owns the whole bounded path: evidence, diagnosis, correction, and
proof. It is not a triage-only prelude. If the supported correction becomes a
material capability or architecture change, produce a Fix Brief and stop.

This skill is repository-generic; local repository instructions and a more
specific named capability still take precedence. Within the Axcíon workspace,
this is the canonical end-to-end owner for a specific repository fault. It
takes precedence there over the generic `diagnosing-bugs` skill, whose method
overlaps but does not own Axcíon routing, state boundaries, or Route C handoff.

## Operating Rules

- Start from observed behavior, not the reporter's proposed cause or remedy.
- Inspect the repository, runtime, Git, and authoritative state directly when
  they can answer the question. Do not ask the operator for discoverable facts.
- Preserve enough evidence to reconstruct the failure before changing the
  affected state. Do not clean contradictory state merely to make it tidy.
- Keep unrelated work untouched. Follow repository instructions and approval,
  protected-zone, testing, and commit rules throughout.
- Prefer fixtures, copies, and reversible probes over experiments on production
  or irreplaceable state.
- Treat previous reports, model conclusions, and stale documentation as leads,
  not authority over current executable evidence.

## Current Issue Record

Maintain this concise record after each phase transition, not after every
command:

```yaml
problem: "observable symptom"
evidence: ["authoritative artifact or observation"]
feedback_loop:
  id: LOOP-01
  status: pending
  invocation: "exact command"
  red: "observable failure condition"
  green: "observable success condition"
reproduction:
  status: pending
  location: "fixture, test, or preserved state"
hypotheses: []
cause:
  status: pending
  mechanism: ""
  enabling_condition: ""
  intervention_point: ""
route: undecided
repair: pending
proof:
  regression_case: pending
  original_loop: pending
  surrounding_checks: pending
next_action: ""
scope_boundary: ""
```

Use an existing task, incident, or investigation record when the repository has
one and its writer or lock rules permit the current agent to update it. Never
edit a live record owned by another actor. Otherwise keep this record in the
active task context. Do not create a second issue lifecycle merely to store it.
Before a handoff or compaction, make the current record durable only through a
repository-approved location or an explicit user request.

## Stage 1: Capture And Preserve

**INPUT**

- A specific observed repository failure or measurable regression.

**ACTION**

1. Record the intended action, expected behavior, observed behavior,
   consequence, and available evidence.
2. Read the governing repository instructions and the smallest relevant set of
   current files, state, logs, and Git/worktree facts.
3. Preserve volatile evidence before materially changing the system.
4. Separate observations from inferences and proposed explanations.

**OUTPUT**

- A populated problem, evidence, scope boundary, and next action in the Current
  Issue Record.

**GATE**

Proceed only when the symptom is specific enough that a fresh agent could tell
whether it happened. If the request is open-ended improvement, an audit, a
backlog batch, or feature work, route to the capability that owns that work.

## Stage 2: Declare The Feedback Loop

Create one named loop before developing a causal theory:

```text
LOOP-01
Invocation: <exact command, test, replay, or measurement>
RED means: <observable reported problem>
GREEN means: <observable corrected behavior>
Runtime: <seconds or minutes>
Representative boundary: <real behavior exercised>
```

The loop should be red-capable, sharp, repeatable, fast enough to rerun, and
agent-runnable. Exercise the real invocation boundary whenever practical. A
code-shape assertion is not a substitute for the behavior that matters.

Read [feedback-loops.md](references/feedback-loops.md) when choosing among tests,
replays, fixtures, differential runs, stress loops, or measurements.

**GATE**

Run `LOOP-01` and observe the reported failure. Do not diagnose from code
reading while a meaningful executable signal can reasonably be built.

If no representative loop can be built, take the forensic route: record what
was attempted, the strongest preserved evidence, and what future evidence or
instrumentation could create a signal. Do not implement a causal correction on
an invented reproduction or confident prose alone. An urgent, reversible state
restoration may still be justified by independent operational evidence, but it
is containment or recovery: validate it separately and do not call the cause
resolved or prevented.

## Stage 3: Reproduce And Minimise

Confirm that `LOOP-01` fails for the reported reason. Capture the relevant
output or state, then remove unnecessary inputs, callers, configuration, files,
and steps one meaningful variable at a time. Rerun the loop after each change.

Stop minimising before the reproduction loses the real invocation path or
operational condition that makes the failure possible.

**OUTPUT**

- The smallest practical representative reproduction.
- `LOOP-01 = RED` on both the minimised case and, where distinct, the original
  scenario.

## Stage 4: Test Competing Hypotheses

When the cause is genuinely uncertain, generate roughly three to five credible
explanations. Use fewer when evidence already rules the space down. Give every
hypothesis one status: `ACTIVE`, `SUPPORTED`, `REJECTED`, or `UNTESTABLE`.

```text
H1 - ACTIVE
Hypothesis: <possible explanation>
Prediction: <observable result if true>
Probe: <narrow test that distinguishes it>
Evidence: <result after execution>
```

Run the narrowest probe that separates the candidates. Change one meaningful
variable at a time where practical. Temporary instrumentation should answer a
named prediction and be uniquely identifiable for cleanup.

Read [hypotheses-and-routing.md](references/hypotheses-and-routing.md) for probe
selection, the causal chain, and difficult routing boundaries.

**GATE**

Do not declare a cause while a materially credible competing hypothesis remains
`ACTIVE` without an evidence-backed reason. Stop diagnosis when the evidence
identifies an intervention point and further investigation would not materially
change the cause, route, scope, or safety of the correction.

## Stage 5: Establish Cause And Route

Express the supported causal model as:

```text
Observed failure
-> immediate mechanism
-> enabling condition
-> intervention point
```

Classify adjacent discoveries as required for the current correction, separate
issue, observation, or discard. Only the first category enters this scope.

Choose exactly one route:

### Route A: No Repository Change

Use when the problem is not confirmed, the premise is disproved, behavior is
already correct, the limitation is intentionally accepted, or no change is
currently justified. State the evidence and, for an unconfirmed problem, what
would justify reopening it. Do not create repository work merely to produce an
artifact.

### Route B: Bounded Repair

Use when the supported cause can be corrected locally without materially
changing durable state, ownership or concurrency semantics, public interfaces,
shared mechanisms, orchestration, agent roles, or the repository's operating
model. Continue to Stage 6.

### Route C: Capability Change

Use when the correction materially changes any boundary above, or when a
bounded repair expands into one during implementation. Produce this Fix Brief:

```text
Proven failure:
Minimised reproduction:
Supported cause:
Intervention point:
Required behavior:
Proof case:
Boundaries and excluded findings:
```

Resolve the exact implementation owner from current repository instructions and
available capabilities, name it in the handoff, and stop. Do not leave a vague
"standard implementation workflow" label for the next agent to interpret.

## Stage 6: Make Red Go Green

1. Preserve `LOOP-01` as the governing signal.
2. When a durable test seam genuinely represents the failure, turn the
   minimised reproduction into a regression case and observe it fail.
3. Apply the smallest sufficient correction. Prefer removal, simplification,
   restoration of the intended path, and consolidation of duplicated authority
   before adding permanent machinery.
4. Run the regression case until it passes.
5. Rerun the original, unminimised `LOOP-01` until it passes.
6. Run surrounding checks proportional to the change's blast radius.
7. Remove temporary instrumentation and throwaway diagnostic artifacts unless
   the repository deliberately adopts them.

If no correct regression seam exists, record that honestly. Do not add a
shallow test that passes while missing the real failure pattern. If creating the
needed seam is architectural, switch to Route C.

Read [operational-cases.md](references/operational-cases.md) for concurrency,
recovery, intermittent, historical, and performance failures.

## Stage 7: Closure Check

Evaluate each assertion explicitly:

```text
[PASS/FAIL] Reported behavior established
[PASS/FAIL] Feedback loop represents the symptom
[PASS/FAIL] Actionable cause supported
[PASS/FAIL] Correction matches the intervention point
[PASS/NA]   Regression case went RED -> GREEN
[PASS/FAIL] Original LOOP-01 is GREEN
[PASS/FAIL] Proportionate surrounding checks passed
[PASS/FAIL] Temporary instrumentation removed
[PASS/FAIL] Material adjacent findings dispositioned
[PASS/FAIL] Remaining uncertainty and untested behavior stated
```

Declare `resolved` only when every required assertion passes. Report the root
cause, changed files, exact verification evidence, untested behavior, residual
risk, and rollback path. A completed implementation is not proof of resolution.

## Failure Behavior

- **No executable signal:** stop causal implementation; preserve evidence and
  state what would enable a representative loop.
- **Wrong failure:** repair the loop before investigating the nearby error.
- **Cause remains ambiguous:** keep the credible candidates explicit; do not
  force a single diagnosis.
- **Scope expands:** stop Route B, update the causal model, and route again.
- **Unsafe or destructive probe required:** use a fixture or seek the approval
  required by repository rules.
- **Verification cannot run:** do not claim green; report the exact gap and keep
  the issue unresolved or deferred.

## Bias And Pitfalls

- A proposed fix in the report is a hypothesis, not an instruction.
- The first plausible explanation is not privileged; competing predictions
  prevent anchoring.
- More logs are not more evidence unless they distinguish hypotheses.
- A green unit test is insufficient when the original operational path remains
  untested.
- An interesting adjacent defect does not earn entry into the current repair.
- Difficulty should increase evidence quality, not automatically increase
  ceremony or permanent machinery.

## Runtime Recommendations

Use a high-judgment model because the hard part is causal discrimination and
routing, not editing. Keep the main skill loaded throughout; read only the
reference relevant to the current failure class. Use repository-native tools
and test frameworks. Add deterministic hooks only for stable binary invariants
that recur across incidents, never as a speculative substitute for diagnosis.

## Examples

- "This CLI says success but creates no output" -> execute this skill.
- "Two worktrees can both claim the same task" -> execute this skill and load
  the operational cases reference.
- "This command is slower than its established baseline" -> execute this skill
  with a measurement as `LOOP-01`.
- "Find anything wrong with this repository" -> use a repository audit.
- "Fix all outstanding issues" -> use the repository's backlog-fix workflow.
- "Implement the approved cache design" -> use the implementation owner named
  by the approved plan.
