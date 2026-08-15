# Operational Cases

Load this reference for concurrency, recovery, intermittent, historical, or
performance failures.

## Concurrency

Preserve actor identities, worktrees, branches, commits, locks, leases, timing,
and authoritative state before cleanup. A useful loop attempts the conflicting
operation and asserts the actual admission or serialization result.

Vary one concurrency condition at a time. Artificial sleeps are useful only
when they test a timing prediction. Record trial count and failure rate. A fix
that passes once has not established a concurrency invariant.

Use separate fixtures or worktrees when actors could overwrite one another.
Do not run multiple editing agents in the same checkout to reproduce a problem
unless the collision itself is the controlled subject and recovery is proven.

## Recovery And Corrupted State

Copy or snapshot the state before repair. Separate two questions:

1. Can the current state be restored safely?
2. What allowed the state to become invalid?

Restoration may be urgent, but it does not prove the causal correction. Define
independent validation for restored state and keep the prevention diagnosis
open until a representative signal exists.

## Historical One-Time Failures

Use logs, commits, task records, outputs, and preserved fixtures to reconstruct
the incident. Mark each claim `OBSERVED`, `INFERRED`, or `UNKNOWN`. Do not clean
contradictions before understanding which source was authoritative at the time.

If the environment no longer exists, take the forensic route. A nearby synthetic
failure must not be presented as the original incident.

## External Actors

When a model, service, user session, or remote system cannot be replayed, isolate
the repository-controlled boundary. Capture or redact the external input where
allowed, then replay it through the local decision point. Never expose secrets
in fixtures, logs, commands, or reports.

If the external behavior itself is the unknown and cannot be observed, state
that limitation rather than attributing the failure to local code.

## Performance Regressions

Require a specific measurable symptom. Establish the comparison before editing:

```text
baseline or accepted range
vs.
observed regression
```

Control input, environment, cache state, warm-up, and sample count. Prefer a
profile, trace, query plan, or differential run that can distinguish candidate
causes. Report distribution or variance when a single timing is misleading.

After correction, rerun the same measurement and relevant functional checks.
Performance green does not excuse incorrect behavior.

## Operational Proof

Some failures only become meaningful through representative execution. After
the narrow regression case turns green, rerun the fuller scenario with the
same boundaries that produced the incident: another worktree, clean session,
recovery path, realistic load, or repeated concurrent actors.

Keep this proof proportional and reversible. It validates the supported fix; it
is not permission to broaden the investigation into an audit.
