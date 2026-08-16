---
task: work-loop-v2-durable-state-system
status: closed
turn: operator
---

## Outcome

The frozen Work Loop v2 durable-state plan is implemented through all eight tracer bullets. Work Loop v2 now has one small durable state system: every consumer takes its lifecycle classification from the single read-only validator, `status` and `turn` are stated rather than inferred, `.owner` holds only a task id, both couriers contend through one shared live lease, no legacy session state feeds the Work Loop path, and an incomplete deployment reports itself unavailable instead of failing at whichever seam is reached first.

The candidate demonstrates the accepted lifecycle end to end — admission, execution, handback, closure and checkout reuse — with the wrong-order controls refusing rather than falsely proving reuse. The two material Tracer 8 findings are corrected at `b81a1b58`. The branch is ready for the operator's landing decision.

## Decisions that matter

**The uninspectable-worktree correction is filesystem-based, and Git's `prunable` marker was rejected as the discriminator.** Measured across five worktree states, Git reports `prunable` both for a worktree that is gone and for one it merely cannot read, because both resolve to the same failed stat. Following the original suggestion would have preserved the fail-open, and did so on the first attempt. A worktree now counts as absent only when its path does not exist *and* its parent is readable and searchable; anything else that cannot be entered makes repository-depth ownership `AMBIGUOUS`. The unreadable-parent handling and the permanent owner-suite cases (T16, T16b) are accepted as direct regression protection for the same defect: every other assertion in that suite returns the same verdict before and after the fix, so without them the fail-open could return unnoticed.

**The correction was accepted without the independent re-check.** By operator decision the stalled re-check was neither waited for nor replaced. The acceptance rests on three separate parties instead: the original independent assessment found both findings, Claude supplied fail-capable correction evidence, and Codex's bounded closure check provided the independent acceptance.

**Two deferrals, recorded and not done.** A worktree that Git reports prunable but that is still enterable can have a stale `.owner` counted as a claimant and cause over-refusal — deferred because it fails safe, is unchanged by this work, and sits outside the frozen correction scope. No permanent representative-proof harness was added — deferred because Tracer 8 explicitly excluded convenience tooling and this record carries the proof.

**Admissions remain paused** until the operator's landing decision.

## Evidence

Fixed baseline `814f305b56d87b2c8453ce0ca41a769873526521`, which is exactly `git merge-base main HEAD`; the candidate is that range, 123 files.

Tracer implementation and proof commits, all ancestors of the candidate: T1 `bc5e9add`, T2 `a1c81caf`, T3 `bd04704f`, T4 `f3eec25d`, T5 `e2823253` with correction `8560e632`, T6 `096b8985` with correction `96ff6786`, T7 `c650d2a1` with correction `1223fda5`. Tracer 8 readiness handback `7a8d38e5`; Tracer 8 correction `b81a1b58`. The closing commit is the commit that carries this record.

Proof: representative end-to-end lifecycle and reuse 44/0, with two mutation runs (37/7 and 36/8) establishing that it can fail. Correction evidence: focused five-mode ownership proof 18/0, and 7 red against the pre-correction helper including the predicted durable double-claim. Suites at the readiness gate and after the correction — owner 133/0, slice-1 309/0, tracer-6 74/0, tracer-7 120/0, carry-turn 457/0, dispatch 639/0, state 100/0, capability 77/0, lease 136/0, session-preflight 60/0, core-resolver 4/0. The new owner cases fail against the pre-correction helper and pass against the corrected one.

Rollback boundary — before landing, withhold this isolated branch. After landing, a deliberate Git revert of the cutover commits plus explicit restoration of any still-open record and owner pair from known pre-cutover evidence. No automated downgrade parser is retained, by design.

## Accepted limitations

- There is no atomic migration verb or runbook; migration is a documented ordered manual sequence.
- One replica-refusal path names checkout occupancy rather than the task's other owner.
- Explicit `work-loop-owner.sh clear` does not itself verify that closure is committed; that guard sits at repository-depth stale-declaration handling.
- No real Claude or Codex model was invoked under the new contract. The bounded live proofs drive real courier processes with scripted actor commands, so the end-to-end handoff is demonstrated mechanically rather than with live actors.
- Tracer 8 fell outside the original independent review range, and the correction re-check remained unassessed; the correction was accepted through Codex's bounded closure check instead.
- A worktree that Git reports prunable but that is still enterable can cause safe over-refusal.
