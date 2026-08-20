---
task: work-loop-v2-post-compaction-recovery-repair
status: closed
turn: operator
---

## Outcome

The post-compaction recovery repair is implemented and proved, including operator-approved
Amendment 1. The Work Loop contract is preserved in full while recovery no longer performs the
incident's irrelevant immediate context refill: `$realign` detects degraded context and delegates
degraded recovery to `$reorient` rather than absorbing it, active-state results roll over so the
state file carries current truth instead of history, and the representative live case demonstrates
correct recovery end to end. Units 0–4 are accepted, the six frozen review findings are resolved at
`63c02624`, and the complete nine-suite Work Loop matrix is green at **1,176 passed, 0 failed**.

## Decisions that matter

- **Repository-read byte volume remains diagnostic, never a gate.** The disposable fixture's
  5,541-byte ceiling was rejected; no launch policy, size gate or threshold entered the contract.
- **Fixture authority never governed.** The disposable plan's claimed content-bound approval anchors
  to `aa11bb22`, which is not a valid object. Nothing from `a0f4f6ec`'s reversed contract was
  imported, and the disposable branch stayed unmerged into the feature branch and into `main`.
- **Only `092a1715`'s rollover behaviour is accepted.** At that revision `u4-live-case.md` carries
  `U4-OLD-RESULT` 0 times and exactly one `## Latest result`, and validates `ACTIVE_CODEX` at exit 0.
  Its byte-ceiling verdict is non-governing.
- **The accepted live trace is Attempt 2**, which exercised the unconditional contract. Attempt 1
  (no `$realign` in the runtime catalog) and the later disposable semantic rewrite are both rejected
  as the representative proof.
- **The disposable branch `disposable/wl2-unit4-case-2026-08-17` is preserved at `4510cb0a`.** It is
  the only ref holding `092a1715`, which is a live evidence pointer. Deleting it was never
  authorized and was not done.
- **The two worktree removals ran under explicit operator authorization.** The
  `check-destructive-liveness.sh` guard had refused them because it cannot establish whether a
  checkout is occupied — a fact core § 7 reserves to the operator. The operator confirmed both idle
  and authorized the documented `AXCION_LIVENESS_OVERRIDE=1` override for those two exact paths;
  `…/ai-resources-wl2-unit4-case` and `…/ai-resources-wl2-unit4-cleanctl` were removed together with
  their two divergent untracked `preflight.sh` scripts (9,868 and 9,065 bytes). Nothing else was
  pruned, deleted or reset, and canonical `main` is untouched at `0d5641b8`.
- **Deferred, with reasons** (both non-behavioral, both recorded in plan § 8): the "five components"
  count staleness in `.claude/commands/work-loop-v2.md` Step 0 and `/sync-workflow`'s remediation
  list — outside the correction's implementation boundary and behaviour-neutral, since the checker
  names the missing file and path itself; and whether references should cite sibling paths at all —
  a contract question, not this correction's, fixed as permitted by an explicit guard CONTROL case.

## Evidence

- **Accepted unit commits:** `66688592`, `072438b3`, `e0b1944b`, `fe61527c`, `7b130cd1`, `4c5f0d0b`.
- **Live post-compaction proof:** Attempt 2 in
  `plans/work-loop-v2-v0.2/work-loop-v2-post-compaction-recovery-repair-implementation-plan-v0.1.md`
  § 8, "Unit 4 — live post-compaction case".
- **Rollover proof:** revision `092a1715`, reachable from `disposable/wl2-unit4-case-2026-08-17`.
- **Correction round:** `63c02624`, with per-finding red/green in plan § 8.
- **Final discovery unit (Unit 4d):** `55214371`.
- **Final regression matrix:** nine suites, 1,176 passed / 0 failed, every exit 0, at HEAD
  `63c02624` — recorded in plan § 8, "Unit 4d — final regression matrix and cleanup".
- **Closing commit:** this commit on `session/2026-08-17-work-loop-fix-17-8`.

## Accepted limitations

- Automatic runtime discovery of `$realign` was not proved by the collaboration-subagent trace.
  Attempt 2 loaded the skill through an explicit transport override, which tests the skill boundary
  but not catalog discovery; that property rests on repository deployment and regression evidence
  instead.
- The read ledger underlying the trace is self-reported, so it cannot independently prove that no
  read was omitted. Read-volume figures are diagnostic evidence, not a guarantee.
