UNIT: 2026-07-29-prime-allocator-extraction-shape
STREAM: 2026-07-29-prime-allocator-extraction
PHASE: shape
REPO: ai-resources
BASE: e57e72dec106c58c32bf0c5fce03e8ca95c4ee44
NEXT: Claude — adjudicate findings before G1

REVIEW

Premise dimension:
No material premise finding. I inspected the immutable plan and the live objects it cites.
The six brief premises are supported; prime-allocator.test.sh still passes 19/0.

Negative-results dimension:
Minor F4 — object inspected: the plan’s “What this plan does not do” stale-worktree paragraph.
It says “Verified this unit: no such worktree exists today” and immediately says
`git worktree list` was not run, so the plan itself supplies no evidence for “verified.”
I ran it independently and observed only the main worktree, making the claim true today,
but the immutable plan should not describe an unrun check as its own evidence.

Material F1 — object inspected: Slice 1 item 1, Slice 1 item 3, and
logs/scripts/prime-allocator.test.sh lines 1–6 and its `run` functions.
The plan gives the new script `#!/usr/bin/env bash`, while the existing harness says a
bash-only run previously passed broken code and requires every allocator run under ZSH.
Prime’s direct invocation would honor the shebang and execute bash; the planned tests still
invoke the script through zsh. Build and Prove would therefore test a different runtime from
the caller while calling the move “verbatim” and behavior-preserving. Before G1, choose the
runtime deliberately and make caller, suite and differential checks exercise that same runtime.
If bash is intentional, the plan must treat it as a runtime change and prove equivalence.

Material F2 — object inspected: Prove P3 and the baseline allocator comments at
6a2cd0b:.claude/commands/prime.md lines 370–509.
P3’s imperative-keyword extraction cannot prove that every guarded invariant survives.
It misses, among others, “CLAIMING IS ATOMIC, NOT ADVISORY,” the empty-CLAIMS fail-safe,
namespace scoping, stale-claim deletion containment, session-id suffix reasoning, and the
identity-oracle rule. A guard can therefore disappear while P3 passes. Replace the keyword
heuristic with an explicit, baseline-derived guard inventory or another check that covers
every named invariant, with a positive control demonstrating that omission is detected.

Material F3 — object inspected: the Script I/O contract, Slice 1’s Prime call block,
Prove P4/P5, and Residual risk 1.
Returning the marker on stdout is reasonable and safer than re-reading the shared marker,
which another concurrent Prime may replace. But the plan tests allocator results, not the new
caller seam: it does not require Prime’s parser to reject zero lines, multiple lines, malformed
fields, or output inconsistent with the allocator’s own written oracle. The plan itself calls
stdout a new surface, so one integration check must exercise the actual call block and prove
that valid output is accepted and malformed output stops loudly before header creation.

Scope dimension:
No finding. D1 is supported by the recorded wrong-repository incident. D2’s canonical-only
divergence is justified by the different shadowing consequence. Slice 1’s three-file atomicity
is appropriate: it is one complete behavior and splitting it would knowingly disconnect the
caller or test. Auto mode remains outside scope.

LIMITATIONS:
I reviewed the plan and current source/test objects, not an implementation. I did not prototype
either shell choice or caller parser. Those remain claims for the corrected plan and later Prove.

Verdict: three material findings. The plan is not ready for G1 until each receives one
work-loop disposition and the accepted corrections are represented in a new immutable plan.
