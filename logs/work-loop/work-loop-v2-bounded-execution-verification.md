---
task: work-loop-v2-bounded-execution-verification
status: closed
turn: operator
---

## Outcome

The merged bounded-execution repair is technically verified and cleared for its separately
authorised, single representative attended pilot.

All three frozen findings from the correction round are resolved:

- The live exit taxonomy is consistent across every instruction surface — `37` for a permission
  denial, `35` for an unavailable ownership check.
- The 15 failing 27-series harness cases were shown to be environmental, not a merged regression.
  They were control assertions probing whether the host permits process-group and ancestry
  inspection; a failed control short-circuits the behavioural assertion behind it.
- The default-deny wording is truthful: `claude_deny=none` now states that the operator supplied no
  extra rule, not that nothing is denied.

The full integrated harness passed `454/0`. The correction introduced no dispatcher control-flow or
launch-policy change beyond the corrected log string.

**Technically verified is not operationally resolved.** The one bounded attended pilot defined by the
governing plan is still required, and it is the next operational step rather than part of this task.

## Decisions that matter

- **The prior `408/15` result is a restricted-environment control failure, not a product
  regression.** The same controls, and every bounded-execution case, pass in the normal supported
  environment. Suite totals are not comparable across the two runs — failed controls suppress the
  assertions behind them, which is why the failing run reported fewer assertions overall.
- **Deferred: pinning the corrected `claude_deny=none` sentence in harness case 31b.** Case 31b greps
  only the `claude_deny=none` prefix, which both the old false wording and the corrected wording
  satisfy, so a regression to the old sentence would pass unnoticed. Deferred because it was noticed
  during the correction and falls outside the frozen correction scope.
- **The attended pilot is the next operational step**, not part of this technical-verification task.

## Evidence

- Correction commit `07bcf96` — the exit-taxonomy fix in `.agents/skills/work-loop-v2/SKILL.md`, the
  deny-policy wording in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and its
  `README.md`, and the harness diagnosis.
- Full integrated harness on the corrected tree, normal supported environment:
  `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → exit `0`,
  `pass=454 fail=0`. Every reported-failing case passed: `27`, `27b`–`27n`, `27L`; bounded-execution
  cases `40`–`47` passed.
- Fail-capable before/after searches run against `f994900` and the corrected tree. The permission-stop
  search returned `SKILL.md:277` and `:289` before and nothing after; the deny-wording search returned
  four lines before and now returns only a comment recording why the retired wording is not restored.
  Both checks fail on the pre-fix tree.
- Independent review pointers: `audits/working/code-review-bounded-execution-merged-spec.md` and
  `audits/working/code-review-bounded-execution-merged-standards.md`.

## Accepted limitations

- O1 proves *requested* permission policy, not containment or real-actor enforcement.
- O3 still uses a modelled denial fixture rather than one replayed from preserved raw evidence.
- All 454 harness cases are simulated. No live model, nested AI or pilot ran.
- The environmental diagnosis establishes behaviour on the supported host, not on every possible
  host.
- Operational resolution still requires the one bounded attended pilot defined by the governing plan.
