UNIT: 2026-07-29-prime-allocator-extraction-shape    STREAM: 2026-07-29-prime-allocator-extraction    PHASE: shape
REPO: ai-resources                                    BASE: 6a2cd0b119c9370c31363700f0ec9077dcb5e226    NEXT: Claude

BRIEF
Need: define the smallest safe package that gives /prime’s embedded marker allocator
one executable owner and removes duplicated runtime rationale without changing behavior.

Premises to verify:
- The prior stream closed rejected-premise and its correction is durable in logs/decisions.md.
- 29 consumers resolve live to canonical; the two 33-line variants contain no allocator.
  [check inode/realpath and symlinked-parent identity, not final-component test -L alone]
- prime-allocator.test.sh still scrapes prime.md on “Allocate N = 1”. [open and run: 19/0]
- The allocator block remains 138 lines: 49 executable and 88 comment-only. [re-derive]
- docs/session-marker.md owns the four-source allocation contract. [open]
- Auto-mode duplication remains deferred and outside this stream. [scope check]

Scope: produce the immutable Shape PLAN only; make no object-under-work edit.
The plan must define one executable ownership path, keep /prime as its current caller,
repoint the regression suite in the same Build slice that moves the running implementation,
carry line-local anti-regression warnings beside the code they protect, name exact files,
define vertical Build slices, rollback, and Prove checks against observable marker behavior.
Do not change marker format, allocation semantics, session artifacts, task routing or auto mode.

Falsified if the plan permits multiple canonical allocator implementations, temporarily
disconnects tests from running code, drops guarded invariants, changes observable allocation,
or claims to lean more of /prime than the verified 138-line allocator boundary can reach.
