UNIT: 2026-07-29-review-layer-consolidation-shape
STREAM: 2026-07-29-review-layer-consolidation
PHASE: shape
REPO: ai-resources
BASE: 83d4adce5e3763dc1b39e48c85e2bd76e0fe53b3
NEXT: Claude — adjudicate findings and produce plan-v2 before G1

REVIEW

Object reviewed:
logs/loop/2026-07-29-review-layer-consolidation-shape.plan.md

Verdict: REVISE before G1.

Material findings: 4. Minor findings: 0.

R2-F1 — MATERIAL — The external-consumer premise and symlink falsifier use
a search that is already known to miss symlinked parent directories.

Object inspected: plan §0 lines 19–24, §1 lines 46–47, and §7 falsifier 1.

The plan reports 25 qc-pass installations: 23 final-component symlinks plus
2 regular files. Running the same search with directory symlinks followed
returns 26. The missing consumer is:
projects/axcion-design-studio/.claude/commands/qc-pass.md

Its commands directory, rather than qc-pass.md itself, is the symlink. The
repository already records this exact method defect in logs/decisions.md:
226–232: test -L and ordinary find are blind to a symlinked parent.

The positive control proves the query can find ordinary entries; it does not
prove the query covers this installation shape. The plan's broken-symlink
falsifier has the same blind spot.

Required correction: re-derive every candidate's consumer inventory with a
parent-symlink-aware method, explain differing counts, and replace the Prove
falsifier with one that covers both file symlinks and symlinked command
directories.

R2-F2 — MATERIAL — The plan defers the two commands at the centre of this
stream to the unrelated Prime stream.

Object inspected: plan §2 lines 60–61 and B10.

The current operator clarification is explicit: this session owns the
unnecessary QC and risk-check behaviour and is not part of the Prime work.
The plan nevertheless keeps /qc-pass, keeps /risk-check unchanged, and says
their retirement decision waits for prime-minimum-responsibility.

No technical dependency on Prime is established. A cited policy that currently
preserves /risk-check is an affected policy surface, not proof that Prime owns
the decision. External consumers can justify deferring physical deletion, but
they do not justify deferring the disposition or removal of automatic calls.

Required correction: plan-v2 must decide the smallest sufficient future role
of /qc-pass and /risk-check in this stream. Separate:
(a) automatic invocation to remove now;
(b) an operator-invoked or Codex-unavailable fallback worth retaining;
(c) physical command deletion that requires consumer migration;
(d) workspace-root policy changes requiring a separate follow-up.
Do not make any of these contingent on Prime without a demonstrated file-level
dependency.

R2-F3 — MATERIAL — The embedded-reviewer inventory is incomplete, so the plan
does not satisfy the brief's “every candidate and embedded stack” requirement.

Object inspected: plan §0 line 21, §2, and B1–B9, correlated against live
command files.

At least three live stacks receive no disposition:

1. friday-journal.md:155–176 and 323 automatically spawns qc-reviewer and says
   the gate cannot be skipped from inside the command.
2. reconcile.md:56–65 automatically runs /contract-check and then
   reconcile-reviewer. The file itself says the latter already performs
   mandate-compliance scoring, making the first pass corroborating duplication.
3. scope-project.md:66–72 has a mandatory scope-qc-evaluator at line 68.
   Only implementation-triage and blindspot-scan are optional; describing the
   whole site as optional overlooks the mandatory evaluator.

Required correction: inventory and disposition these stacks explicitly.
Retaining a specialist evaluator may be correct where Codex is not the second
pass, but that must be established from its invocation route and distinct
purpose. General QC duplicated by Codex should be removed or made
operator-invoked.

R2-F4 — MATERIAL — B1 leaves the canonical in-repository QC methodology
internally contradictory and still broadly mandatory.

Object inspected: plan B1 lines 82–85 against docs/qc-independence.md:8–34.

B1 removes automatic triage and repeated QC but says to retain the
cap-exhaustion rules at lines 28–34. Those rules explicitly depend on “the
second post-edit QC” and reporting how many “triage + fix passes” ran—the
machinery B1 removes. They cannot remain unchanged.

B1 also leaves “Post-edit QC is mandatory,” the plan-QC requirement, and the
large QC-PENDING fallback architecture at lines 8–12. Because this file is the
repository's full QC methodology and layer 4 is in scope, removing only the
auto-loop does not establish the intended Codex-first, one-review,
change-proportional policy. A later workspace-root edit would still point into
a document that prescribes broad Claude QC.

Required correction: rewrite the relevant methodology as one coherent rule:
one independent review total; Codex is the review for work-loop-routed work;
/qc-pass is only the explicitly chosen fallback if retained; review depth is
proportional to change materiality; a second round occurs only when the first
finds a material issue requiring redesign. Preserve genuine stop-time and
unresolved-material-finding safeguards without retaining references to the
deleted multi-pass loop.

G1 should not be offered on the current plan. Findings R2-F2 through R2-F4
change the planned package and policy architecture; R2-F1 changes its evidence
and migration boundary. Produce immutable plan-v2, adjudicate all four
findings, and return it for review-2 under the contract's architecture-change
bar.
