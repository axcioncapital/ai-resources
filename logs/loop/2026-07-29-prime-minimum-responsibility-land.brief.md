BRIEF
UNIT: 2026-07-29-prime-minimum-responsibility-land
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: land
REPO: ai-resources
BASE: aa02f87
NEXT: Claude — take the lifecycle decision, close the stream, open the successor

**Capability:** prime-runtime-delegation

**Claude-authored brief.** Composed from the operator's written direction of 2026-07-30, not framed by
Codex. It has therefore had no independent framing, which is a recorded weakness of this unit. The
direction it transcribes is an operator decision and is not itself in scope for re-argument.

Need: the Prove unit closed with release declined at G2. The stream's five phases are complete and its
result is landed but unfit to adopt. This unit takes the lifecycle decision, sets the capability's
`status:`, closes the stream, and states what the successor stream inherits.

Scope: the lifecycle decision only. **No edit to `prime.md`, to any script, or to any consumer.** The
seam correction and the remaining responsibility reductions belong to the successor stream, which this
unit opens but does not execute.

Premises to verify:
- The Prove unit is genuinely closed — evidence carries `Status: complete`, the record's `active_unit`
  reads `none`, and the `## Units` row records the declined release.
- `status: revise` is in the ACTIVE set per `templates/capability-record.md`, so the record stays
  resumable rather than dropping out of `docs/work-loop.md` § Resume order.
- The mission `lean-prime-2026-07` is still `active` and its ≤300 assertion is still unmet and visible.
- No `logs/loop/2026-07-29-prime-minimum-responsibility-*` artifact is uncommitted at stream close.

**The lifecycle decision is directed, not open.** The operator's 2026-07-30 direction settles it:

- **Hold, not adopt, not reject.** The capability takes `status: revise` — an ACTIVE status.
- **≤300 stays frozen.** 413 is an interim result. The ≤430 waypoint does not replace the target, and
  the mission is not closed as successful.
- **The architecture is decided.** `/prime` orients → shows the menu → interprets the selection →
  establishes session entry → dispatches → stops.
- **Retained work is kept, not reverted.** Four landed slices took `prime.md` 635 → 413 with the
  allocator extracted and tested at 19/0. Only the locator seam is defective.

Falsified if: the record cannot be set to an ACTIVE status without losing resumability; the stream
cannot be closed because an artifact is uncommitted or unreachable; or the successor stream cannot be
opened without reopening a decision the operator has settled.

Gates: G3 is this unit's stop. Its substance is supplied by the operator's direction above — the unit
records the decision and does not re-ask for it. `/risk-check`, `/qc-pass` and subagent review are
**retired**, not declined: Codex is the sole independent reviewer.
