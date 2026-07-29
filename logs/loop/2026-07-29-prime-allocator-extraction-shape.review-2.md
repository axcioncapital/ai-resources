UNIT: 2026-07-29-prime-allocator-extraction-shape
STREAM: 2026-07-29-prime-allocator-extraction
PHASE: shape
REPO: ai-resources
BASE: dcc876aab0e4a2a4e53777b7c6ea6d8b44774577
NEXT: Claude — adjudicate review-2 before G1

REVIEW

Premise dimension:
No premise finding. I inspected plan-v2 at dcc876a, the immutable brief,
prime.md, docs/session-marker.md and prime-allocator.test.sh. prime.md remains
unchanged from 6a2cd0b; the baseline harness passes 19/0 under its intended
bash harness with every allocator execution under zsh; git worktree list
returns only the main worktree.

Prior-finding closure:
- F1 runtime: fixed. Caller, shipped script and allocator executions in the
  suite now consistently use zsh, with an explicit runtime guard.
- F2 guard inventory: fixed. The heuristic is replaced by 16 named,
  baseline-anchored guards plus a planned positive control.
- F3 caller seam: parser coverage was added, but its oracle choice introduces
  the material finding below.
- F4 worktree wording: fixed. The claim now names the command actually run.

Negative-results dimension:
No finding. The relevant no-extra-worktree claim is supported by the positive
output of git worktree list rather than an unchecked empty search.

Material R2-F1 — object inspected: plan-v2’s Script I/O contract and
Caller-seam contract, especially lines 140–157, against docs/session-marker.md
§ Same-day counter, § Both-or-neither writer invariant and § Marker resolution.

The revised seam compares stdout with logs/.session-marker. That file is
explicitly clobber-vulnerable and “no longer the identity oracle.” A legitimate
concurrent /prime can overwrite it after this allocator returns but before its
caller performs the comparison. The first caller would then reject its own
valid allocation and omit its header, even though stdout and its unclobberable
per-session marker agree. This recreates the exact read-after-write race used
to justify stdout.

Fix the contract to compare stdout with
logs/.session-marker-${CLAUDE_CODE_SESSION_ID} whenever the session id is
available. Only the old-CLI/no-session-id path may fall back loudly to the
shared marker; disagreement there may remain a stop. Extend T-SEAM with the
critical concurrency case: shared marker changed by another allocation, own
per-id marker still equals captured stdout — the caller must accept its own
marker and continue.

Claim-to-evidence dimension:
No other material finding. The zsh choice, explicit guard inventory and actual
call-block parser test are adequate Shape-level corrections.

Scope dimension:
No finding. The correction remains inside Slice 1 and does not expand the
three-file package or touch auto mode.

LIMITATIONS:
I reviewed a plan, not an implementation. T-CWD, T-SEAM and P1–P10 remain
future Build/Prove obligations.

Verdict: one material finding introduced by the F3 correction. Plan-v2 is not
ready for G1 as written. Record one disposition, represent an accepted fix in
immutable plan-v3, then present the adjudicated package at G1; another general
review round is not required by this finding.
