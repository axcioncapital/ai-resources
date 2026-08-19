---
task: canonical-rw-lightweight-l3-adapter
status: closed
turn: operator
---

## Outcome

Accepted completion, at pilot quality, of L3's Standard-route House View adapter in the lightweight
Research Workflow.

The adapter binds Standard only to L2's contract-valid `{base}-approved.md`, established by
`check-judgment-contract.sh` returning exit `0`. It consumes the approved brief's content rather than
its path or existence, preserves the approved artifact's actual thesis IDs, and requires claim-level
and thesis-level traceability for every bound Answer and Inference assertion. Existing evidence
permissions still bind — authority never raises an evidence class. Where authority is missing,
proposed, rejected, evidence-less or malformed, Standard fails closed and escalates one way to the
existing Deep handoff, naming the authority failure.

Ordinary Standard behavior is unchanged. The adapter creates no judgment, no approval, no promotion
path, no second producer or challenge mechanism and no second House View artifact, and it changed no
L2-owned surface.

## Decisions that matter

**The correction round is resolved on both frozen findings.** Bound inference now requires a valid
thesis reference while retaining its claim-ID binding. Thesis identity now comes from the number the
approved heading actually carries rather than encounter order; duplicate or unreadable thesis numbers
fail closed, and the memo checker validates every reference by exact-set membership in the published
`thesis-ids:` set instead of a computed range.

**A deliberate fail-closed narrowing was accepted inside finding 2.** The adapter refuses an approved
brief whose thesis heading carries no readable number, which L2's validator would accept. An ID that
cannot be read cannot be referenced, so it escalates to Deep like any other unusable authority rather
than passing something untraceable through.

**Deferrals carried, with reasons:**

- Thesis references are presently matched anywhere on an Answer or Inference line. Tightening them to
  a narrower bracketed reference grammar is low-consequence and separate from the frozen fixes.
- The authority gate still keys on the literal reserved House View term. Semantic intent detection
  would be a substantially larger mechanism and is not justified in this unit.
- The memo names the approved artifact but is not cryptographically bound to the exact bytes it read,
  the way L2's `reviews_sha256:` binds a challenge. L4 operating evidence should determine whether
  that added machinery is worth its cost.
- The real-validator harness depends on accepted commit `e16cf206` remaining reachable. Its declared
  fallback to exit-code stubs is weaker evidence and must remain disclosed whenever it fires.

## Evidence

Focused harness `logs/scripts/research-route-l3-adapter-unit-1.test.sh`: **41 passed, 0 failed**.
Both pre-existing L3 harnesses still pass unaltered — `research-route-l3-unit-1.test.sh` **14 passed,
0 failed**; `research-route-l3-unit-2.test.sh` **33 passed, 0 failed**. The correction's six new
assertions were mutation-tested rather than assumed fail-capable: a hardcoded thesis set drops the
harness to 38/41, an always-accepting `thesis_known()` drops it to 38/41, and relaxing the inference
requirement drops it to 40/41; each mutation was reverted and the harness restored to 41/41.
`bash -n` clean on every changed shell surface.

Changed surfaces: `.claude/commands/research-route.md`,
`logs/scripts/research-route-judgment-authority.sh`, `logs/scripts/research-route-memo-check.sh`,
`logs/scripts/research-route-l3-adapter-unit-1.test.sh`, and this state file. Nothing under
`workflows/`; no L2-owned surface touched.

Implementation commit `550f47e89c1b2b3f9d0a82efd3d87a5ff5d650e1`; correction commit
`137e4f62701e06569919365a5291c141d8e6da93`. The closing commit is the commit that writes this record
— a commit cannot carry its own hash, and no follow-on commit was made solely to record it. Not
merged and not pushed.

## Accepted limitations

- The judgment trigger and the semantic assessment behind it remain model judgments, not mechanised
  checks.
- The structural checks prove binding, traceability and fail-closed behavior; they do not prove
  analytical quality, nor that a model genuinely reasoned from the approved content it was handed.
- The adapter is not deployed to a consumer.
- Genuine integrated operation against an operator-approved brief remains L4 and is outside this task.
