---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: closed
turn: operator
---

## Outcome

Patrik explicitly chose `SHRINK` after accepted Unit 36. The task ended through its operator-decision exit condition: no integrated candidate passed Gate SA and no independent review returned `ADOPT`. The original release label **Reliable supervised semi-autonomous dispatcher** is not authorized.

The accepted narrowed boundary is: invalid pre-run invocations may refuse with clear stderr and a nonzero exit without a durable terminal result; the durable-result guarantee begins only after checkout, task and evidence location are trusted.

## Decisions that matter

- **The narrowed boundary, and its value-and-risk ground.** Unit 36 established a `PLAN/INTERFACE CONFLICT`: early usage and argument refusals occur before a trustworthy checkout, task, evidence root and run identity can all exist, while the approved terminal-result producer and consumer require exactly those values, and the accepted schema requires several of them rather than representing them as unavailable. Patrik chose the cleaner admitted-run boundary instead of adding a dispatcher-global evidence root, an independent pre-parse identity, and compatible schema and consumer changes solely to represent malformed non-runs. The accepted cost is weaker durable evidence for those early refusals.
- **This SHRINK ends work under the content-bound plan without silently amending it.** Any future implementation of the narrowed operating envelope requires a new or materially revised content-bound plan and task carrying an explicit narrower release claim. Do not continue implementation under the old Gate SA authority.
- **Deferral recorded at closure — the dead `RUN_ID` checkout discriminator.** `dispatch.sh` line 3141 composes `RUN_ID` from `${LOCK_KEY:0:8}`, and `LOCK_KEY` is never assigned; commit `0d9e3355` both introduced that use and removed the assignment when the lease moved into `logs/scripts/work-loop-lease.sh`, so the field has been empty since it was added. Reason for deferral: it is outside Unit 36's discovery deliverable and belongs to whichever unit next touches run-identity composition. Not fixed here.
- **Deferral recorded at closure — the focused-case selector.** Carried forward from earlier units as operating friction, not Gate SA work.

## Evidence

- Accepted Unit 35 discovery commit `f8efcd70d70818a7b749d6bdc9cf76f02f68f7b8`.
- Accepted Unit 36 discovery commit `e53e6592583a6b16b83b2853e21f439d7029ef49` — the repository-grounded call-order and trust-boundary adjudication behind the narrowed boundary.
- The closing commit carrying this record, on branch `session/2026-08-16-dispatcher-last-fixes`.

## Accepted limitations

- Early usage and argument refusals have no durable terminal result.
- Gate SA and its final regression, live-trial and adoption contract remain unmet.
- Change set A proof gaps and remaining clauses, Change sets B–D, live trials, final regression and the independent adoption review remain incomplete or deferred.
- The dead `RUN_ID` checkout discriminator and the focused-case selector remain deferred.
- Merge, push, deployment and destructive cleanup remain excluded.
