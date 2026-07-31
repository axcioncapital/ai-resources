UNIT: 2026-07-31-g1-reviewed-plan-invariant-prove   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: prove
REPO: ai-resources                                  BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Claude writer

BRIEF

**Authored by Claude, and that is the correct provenance for a Prove unit.** The framing was fixed at
Frame and Shape and approved at G1; Prove does not receive new framing. This brief opens the unit that
transcribes and adjudicates the independent Prove review of the S1 candidate. It proposes no scope.

Need: an independent Codex review of the Slice 1 implementation candidate has been returned with
verdict **REVISE BEFORE G2** and two material findings. It must be transcribed verbatim, bound to a
computed review identity, and adjudicated — before any correction is contemplated and with **G2
closed**.

Authority for this unit, in order (`docs/work-loop-repair-workflow.md` §1):

1. explicit operator direction for this session — transcribe, adjudicate, **do not modify the
   implementation**, treat **G1-PV1-02** as requiring an operator/control-room decision before the
   bounded correction pass is spent, keep **G2 closed**;
2. `docs/work-loop-repair-workflow.md` §§ Stage 8, 10, 11, 14;
3. plan-v4 at commit `df45a2b1a42a2140c85a56e71c395407dc9eb903`, blob
   `9ae4839afc8ccb23c4bd50a2644f32213273ed90` — its acceptance criteria A1–A20 and falsifiers F1–F12
   are what Prove judges against;
4. the Build handoff `…-build-1.handoff.md`.

Object under review — the candidate, not a summary:

| Field | Value |
|---|---|
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` |
| S1 implementation commit | `8762fc7fc413d1149eb3dec531d235bc368d1108` |
| Reviewed HEAD | `504cf4995c3d4f61cca987506756ac24e4ec4b87` |
| Build evidence | commit `a8256df72e9430d37f8d50f77ccb55debcadeaec`, blob `8d890430d7e4a3a3291bc760c6b04fbfa05ffc7d` |

Premises to verify — all re-derived against Git in this worktree before any write:

- the envelope's every field matches the live repository, and the worktree is clean.
  [check: `git rev-parse`, `git status --porcelain`, `git merge-base --is-ancestor`]
- the previous writer released ownership in the Build handoff commit, and this session explicitly
  acquires it. A handoff never infers acquisition from silence (`…repair-workflow.md` §7).
- **no target object changed after the S1 commit** — otherwise the review is stale before it is read.
  [check: `git diff --name-only 8762fc7f HEAD -- <four paths>`]
- the G1-approved plan-v4 still resolves to blob `9ae4839a…`; any mutation would have voided G1.
- **each material finding reproduces on the live files.** A review's premises are verified, not
  accepted — Claude may reject an inaccurate premise with evidence (`…repair-workflow.md` §5.3).
  [check: read the cited lines in the candidate blobs; re-run the diff filter with a positive control]

Scope of this unit: **transcription, identity computation, adjudication and evidence only.**

Explicitly **not** in this unit: any edit to `docs/work-loop.md`, `.agents/skills/work-loop/SKILL.md`,
`.claude/commands/work-loop.md` or `templates/capability-record.md`; any mutation of plan-v4; spending
the bounded correction pass; opening G2. Prove is read/test/evidence-only and does not repair the
object it judges (`…repair-workflow.md` § Stage 8).

Falsified if: the candidate is mutated in this unit · a material finding is dismissed without cited
evidence · the review is edited rather than transcribed verbatim · the correction pass is spent before
G1-PV1-02 has an operator-authorized resolution · G2 is opened · a finding is recorded `fixed` when
nothing was fixed.

Budget: this unit's **initial independent review is consumed** by the returned block. One bounded
correction pass remains **available and unspent**; a conditional closure `review-2` remains available
only if that correction changes something this verdict rests on. No `review-3` exists.

LIMITATIONS: This brief opens an adjudication unit and authorizes no implementation. It makes no
behavioural claim about the candidate — the review it processes judges text, identity arithmetic and
diff bounds, and the M8–M10 scenarios remain unexecutable before Stage 9 (Use).
