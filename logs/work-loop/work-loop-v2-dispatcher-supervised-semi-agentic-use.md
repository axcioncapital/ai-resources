---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: closed
turn: operator
---

## Outcome

The accepted dispatcher work through Unit 31 is retained. That includes the explicit permission-denial takeover with its named approved restart and a status read from the terminal result rather than the run log (Unit 28); the finite whole-run deadline, which a live multi-hop run is refused before admission without (Unit 30); and zero automatic replay after an actor process has launched, where a nonzero actor exit ends the run on both the repository-unchanged and partial-effect shapes and recovery is an explicitly started new run (Unit 31).

Gate SA and the independent `ADOPT` review were not completed. The task exit condition was therefore not met by acceptance; it was met by Patrik's explicit `SHRINK` choice on 2026-08-19, which stopped the work before Unit 32 was implemented.

## Decisions that matter

- **Patrik chose `SHRINK` on 2026-08-19.** Work stops at the accepted candidate through Unit 31; Unit 32 (the three-hop normal ceiling) was briefed but never implemented.
- **The release target is reduced to an explicitly experimental supervised deployment.** Neither **Ready for supervised semi-agentic use** label may be used, and it must not be claimed that durable terminal results are guaranteed after run admission.
- **Merge, push and deployment stay outside this task** and require the separate operator-authorized repository path. This closing record is a local commit only.
- Deferred at closure, with the reason: the remaining Change-set-B controls (fixed three-hop normal ceiling, optional correction corridor, nested-AI control), the remaining minimum preflight (item 3), the remaining status/takeover work (item 4), the supervised live trials, the synchronous regression gate and the independent adoption decision are all left undone — because the operator ended the task at the accepted candidate rather than continuing to the Gate SA contract.

## Evidence

Accepted evidence commits on branch `session/2026-08-16-dispatcher-last-fixes`, in order: `a4b8645a3ecd1ca02c191cd1d3c55cfdaab08e4b` (minimum-contract item 1 — denial takeover and status source), `cfd58681` (Unit 27 — plan reconciled to the read-only takeover model; the approved plan content this task ran against), `f3621898` and `8921bba2` (Unit 29 and the Unit 30 reframing hand-backs), `52add0fd93bcc700d01cd568fe71e1be91031ad0` (Unit 30 — the finite whole-run deadline), ending at `7b5efd123246c7c10cbd435ebe3f61e216707391` (Unit 31 — no automatic replay after actor launch; 141 focused assertions passing, 0 failing).

Plus the commit carrying this closing record on the same branch.

## Accepted limitations

- The fixed three-hop normal ceiling is **not** enforced: a normal prepared run can still launch more than three actors.
- The optional correction corridor and the nested-AI prevention/reporting control are unimplemented.
- Minimum preflight item 3 and status/takeover item 4 are unfinished.
- No supervised live trial was run, no synchronous regression gate exists, the full dispatcher regression suite was never run as a gate, and no independent adoption decision was taken.
- **No unattended, walk-away, Gate ST, Gate U, or reliable semi-autonomous claim is authorized for this dispatcher.** Its only authorized description is an explicitly experimental supervised deployment.
