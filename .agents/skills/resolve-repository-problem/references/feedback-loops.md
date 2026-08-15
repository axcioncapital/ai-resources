# Feedback Loop Patterns

Load this reference while selecting or sharpening `LOOP-01`.

## Selection Order

Prefer the narrowest option that crosses the real failure boundary:

1. Existing failing test that asserts the reported behavior.
2. New integration or regression test at the real call site.
3. Actual CLI or workflow invocation against a controlled fixture.
4. Deterministic script against a temporary repository or copied state.
5. Replay of preserved input, request, event, or state.
6. Differential comparison between working and failing states.
7. Repeated stress loop for intermittent or concurrency behavior.
8. Representative measurement for a performance regression.
9. Forensic evidence record when the original environment cannot be recreated.

Do not prefer a unit test merely because it is easy. Prefer the lowest-cost loop
that can actually distinguish the user's symptom.

## Loop Declaration

Name the loop once and keep the same identity through diagnosis and proof:

```text
LOOP-01
Invocation: ./scripts/reproduce-owner-conflict.sh
RED means: second valid owner is admitted
GREEN means: second valid owner is refused with the expected reason
Runtime: seconds
Representative boundary: repository-wide ownership admission
```

When the minimised regression test differs from the original loop, name it
separately. The regression test protects the correction; `LOOP-01` proves that
the real incident is gone.

## Quality Tests

**Red-capable:** The loop can fail on the precise reported behavior. A command
that merely exits zero cannot detect incorrect output unless output is asserted.

**Sharp:** The verdict is not dominated by unrelated setup, network, permission,
or dependency errors.

**Repeatable:** The same scenario produces the same verdict. For intermittent
failures, record trials, failures, rate, and confidence rather than pretending
one run is deterministic.

**Fast:** Narrow setup and execution enough to support repeated probing. Cache
expensive invariant setup when doing so does not hide the fault.

**Agent-runnable:** The invocation and verdict do not require unrecorded human
interpretation between each attempt.

## Minimisation

Remove one meaningful element, rerun, and keep the removal only if the same
failure remains red. Candidate removals include callers, files, inputs, config,
worktrees, timing steps, services, and historical state.

Stop when further reduction changes the failure mechanism or bypasses the real
entry point. A small synthetic test of a helper is not representative when the
defect depends on sequencing, integration, or multiple actors.

## Intermittent Loops

Increase observability and reproduction rate before theorising:

- repeat the trigger;
- control random seeds and time where legitimate;
- isolate external variability;
- vary concurrency or inject timing at a named boundary;
- record trial count and failure rate;
- compare one variable at a time.

Define red and green statistically when appropriate. For example, red may be
"at least one duplicate admission in 100 trials" and green may require a
predeclared number of clean trials plus surrounding invariants.

## Performance Loops

Use a measurement only when the symptom has a baseline or acceptable range.
Record environment, input, warm-up, sample count, summary statistic, and
variance. Compare like with like. One faster run after a change is not proof.

## Forensic Route

When no representative loop can exist, record:

- what reproduction attempts were made;
- why each failed to represent the incident;
- the strongest preserved artifact;
- which claims are observed, inferred, and unknown;
- what instrumentation or recurrence would make the issue executable.

Do not invent a red state by testing a nearby behavior. A forensic conclusion
may narrow the next investigation, but it does not earn a green closure claim.
