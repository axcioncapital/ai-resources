# Hypotheses And Routing

Load this reference when the cause is uncertain or Route B versus Route C is
difficult to distinguish.

## Hypothesis Discipline

A useful hypothesis predicts an observation that could prove it wrong:

```text
Hypothesis: stale ownership state is selected before checkout resolution.
Prediction: holding all other state constant and resolving checkout first makes
the admission pass; changing unrelated task content does not.
Probe: replay the same fixture while varying only operation order.
```

Rank candidates by plausibility and discriminatory value, not by how easy they
are to fix. A cheap probe that separates several candidates is more valuable
than a broad inspection that weakly supports all of them.

## Status Rules

- `ACTIVE`: credible and not yet distinguished.
- `SUPPORTED`: predictions match the evidence and credible alternatives have
  been distinguished.
- `REJECTED`: a prediction failed or contrary evidence rules it out.
- `UNTESTABLE`: current evidence cannot distinguish it; state what would.

More than one hypothesis may remain supported when causes compose. State the
relationship rather than forcing one label onto several necessary conditions.

## Probe Selection

Choose the smallest probe that makes candidates predict different outcomes:

- inspect a value at one decision boundary;
- change one controlled fixture condition;
- compare old and new commits with the same loop;
- use `git bisect run` when history is the differentiator;
- introduce a uniquely tagged temporary log or trace;
- use a debugger or direct runtime inspection;
- add a failpoint at the suspected boundary;
- profile or inspect a query plan for performance cases.

Remove diagnostic machinery after closure unless it independently qualifies as
permanent product behavior.

## Actionable Cause

Build a chain with four levels:

1. **Observed failure:** what went red.
2. **Immediate mechanism:** the event that produced the symptom.
3. **Enabling condition:** why the mechanism was possible.
4. **Intervention point:** the condition the correction must change.

Do not search indefinitely for a philosophical root. Stop when this chain
predicts a preventive change and the credible alternatives would require a
different observation.

## Route B: Bounded Repair

Route B remains appropriate when all of these are true:

- the intervention point is local and understood;
- the correction preserves accepted architecture and operating assumptions;
- shared consumers keep the same contract;
- rollback is straightforward;
- verification can exercise the original behavior;
- implementation does not require inventing a new durable mechanism.

The number of files is evidence about blast radius, not a routing rule. A
one-line authority change may be architectural; a multi-file mechanical repair
may remain bounded.

## Route C: Capability Change

Switch to Route C when the intervention changes durable state shape, ownership,
concurrency or recovery semantics, public interfaces, shared authority,
orchestration, roles, lifecycle, or the operating model. Also switch when a
correct durable test seam itself requires architectural work.

The Fix Brief carries the established evidence and behavioral proof case. It
must not design the new architecture. Resolve an exact current implementation
owner from repository instructions instead of naming a generic workflow.

## Adjacent Findings

Use four dispositions:

- **Required:** causal or necessary for safe correction; enters current scope.
- **Separate issue:** material, but has a distinct symptom or intervention.
- **Observation:** interesting evidence without enough consequence or support.
- **Discard:** unsupported, duplicate, irrelevant, or immaterial.

Discovering an adjacent issue does not authorise creating its tracking artifact.
Follow the repository's existing issue mechanism and user authority.
