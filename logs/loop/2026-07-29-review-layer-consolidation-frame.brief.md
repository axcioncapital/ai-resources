UNIT: 2026-07-29-review-layer-consolidation-frame
STREAM: 2026-07-29-review-layer-consolidation
PHASE: frame
REPO: ai-resources
BASE: aa0e26621689ea35b724733506b084b8218cc016
NEXT: Claude

BRIEF
Need: overlapping QC, refinement, triage, contract and specialist reviewers add
cost after Claude work that Codex already reviews independently.
Operator direction: Codex is the default independent reviewer; general-purpose
reviewers must not be automatically stacked around that pass.
Apply the supplied redesign principles: use the smallest sufficient system,
concentrate governance on material risk and remove obsolete scaffolding.
Premises to verify:
- Live non-prime workflows still invoke overlapping reviewers automatically.
- /work-loop already makes Codex the reviewer and handles finding adjudication.
- Deterministic checks and irreversible-action confirmations are distinct safeguards.
Scope:
- Inventory and simplify the review layer outside the active /prime redesign.
- Assess /refinement-{pass,deep}, /triage, /resolve, /contract-check,
  /blindspot-scan, /consult, /reconcile and /implementation-triage.
- Remove embedded reviewer stacks from /pm, Friday workflows, cleanup,
  promotion, scoping, new-project, incident and issue-fixing workflows.
- Update their authoritative policies, templates and operator guidance.
Exclude .claude/commands/prime.md, /session-start, /session-plan,
docs/backlog-reconciliation.md and all prime-minimum-responsibility artifacts.
For /qc-pass and /risk-check, remove or revise non-prime callers but do not delete
their commands or agents while the active /prime implementation still consumes them.
Record their final retirement decision as deferred until the prime stream lands;
do not create a registry, compatibility layer or new gate to represent that deferral.
Protected: tests, schema validation, consumer searches, Git recovery, secrets and
permission protections, and confirmations immediately before destructive operations.
Evidence must include positive-controlled consumer searches and representative
ordinary, shared-change, destructive and Codex-unavailable scenarios.
Falsified if non-prime Codex-reviewed work still stacks a general reviewer, if an
edited workflow has a broken reference, or if this stream modifies prime-owned files.
