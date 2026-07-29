UNIT: 2026-07-29-prime-minimum-responsibility-frame
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: frame
REPO: ai-resources
BASE: dcc876aab0e4a2a4e53777b7c6ea6d8b44774577
NEXT: Claude

BRIEF
Need: determine the minimum responsibility /prime must retain to orient the
operator and dispatch chosen work, then define the boundary for a substantial
lean-down rather than an allocator-only extraction.

Premises to verify:
- prime.md is 830 lines; auto mode alone is 236 lines.
- Step 8k plus 8a/8b make /prime a session-state writer as well as an orienter.
- Auto mode duplicates mandate, context, plan, manifest and execution logic
  already owned by /session-start and /session-plan.
- Project-model alignment runs before task selection, while /session-plan owns
  task-specific model selection; new-project no longer emits that section.
- /open-items owns full backlog reconciliation.
- Concurrency hooks and /session-start already own stronger live-session checks.
- develop-ai-resource requires the smallest mechanism, clear ownership,
  reference instead of copied authority, and removal of non-contributing material.

Scope: Frame only. Inventory every responsibility in prime.md and classify it
retain · delegate to existing owner · qualify separately · remove. Test whether
a ≤300-line /prime is achievable without losing the short orientation menu,
number/free-text selection, required session-start synchronization, or safe
dispatch. Make no object-under-work edit.

Falsified if the result merely extracts the allocator, leaves copied
/session-start or /session-plan logic inside /prime, or obtains the cut by
moving prose into another always-loaded prompt or inventing an unqualified
durable resource.
