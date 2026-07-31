UNIT: 2026-07-31-g1-reviewed-plan-invariant-frame   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: frame
REPO: ai-resources                                   BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Claude

BRIEF
Need: the challenged route can still present a materially revised Shape plan at
G1 when Codex reviewed only an earlier version. Its one-correction rule also has
no terminal outcome when review-2 still requires a material plan change.

Premises to verify:
- `docs/work-loop.md` requires Shape review before G1 and permits immutable plan
  revisions, but does not bind G1 to the exact reviewed plan identity.
- `.claude/commands/work-loop.md` transcribes a review and then presents “the plan”
  at G1 without comparing the presented plan to the reviewed object.
- The contract's “at most one review round” rule conflicts with its permitted
  `review-2`; neither authority defines what follows a material review-2 finding.
- Git history on current main retains the observed failure: commit `31080b0` says
  plan-v3 reached G1 after being reviewed zero times.
- The old branch blocker is gone: review-layer consolidation has landed on main.

Scope: `docs/work-loop.md`, `.claude/commands/work-loop.md`, and
`.agents/skills/work-loop/SKILL.md`. Make G1 fail closed unless the candidate is
the exact independently reviewed plan; distinguish material from non-material
revision; permit at most one closure review; terminate unresolved material
review-2 findings as `hold-reframe`, with no review-3 in the same unit.

Preserve: G1/G2/G3 only; immutable artifacts; separate Shape and Prove reviews;
solo/reviewed proportionality; Claude as planner and sole implementation writer.

Exclude: foreign-block routing, worktree/state redesign, G2 candidate identity,
phase enforcement, validators, review-method expansion, and historical rewrites.

Falsified if an unreviewed material plan reaches G1, a wording-only edit forces
review churn, or a material review-2 finding can start another same-unit cycle.
