BRIEF
UNIT: 2026-07-29-prime-minimum-responsibility-build-2
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: 44062e4
NEXT: /develop-ai-resource — qualify the artifact; this unit suspends at route-out until it returns

**Capability:** prime-runtime-delegation
**Settled upstream:** operating outcome, need validation, ownership and seam, and the adoption
decision. Do not reopen these. Qualify the ARTIFACT only; return its disposition here, not to the
operator.

**Operator-authored, 2026-07-29.** Supersedes plan-v3 § 7.1's Option A framing, which scoped this to
a single `prime-marker.sh`. That framing is withdrawn: the need is one capability, not one script.

Need: `/prime`'s orientation runs deterministic scans that are **restated as prose inside an
executable prompt** rather than owned by anything that executes. Plan-v4 measured the consequence —
the two largest available line reductions (Step 1a's merged git cross-check, 69 lines; Step 1d's
active-mission scan, 19) are **verbatim duplications** of `docs/backlog-reconciliation.md` § The git
cross-check mechanism and `.claude/commands/mission.md:47–48`, and neither can be cashed by citation,
because a cited scan must be read at orientation to run. The same shape holds for the 147-line marker
allocator at Step 8k. Qualify the **smallest executing owner** for two responsibilities: **allocator
mechanics** and **deterministic orientation scans**.

Scope: the artifact only. **Do not preselect a shape.** Reuse of something that already exists, one
combined script, several narrow scripts, and **no build** are all admissible outcomes, and no build is
a real answer rather than a failure. Qualification must weigh runtime cost, not only line count: a
script `/prime` shells out to costs an invocation; prose costs tokens every session; a doc citation
costs a read. **A reference-document relocation is not an acceptable substitute for executable
ownership** and must not be recommended as one — that route is already measured and falsified in
plan-v4 § 3–4.

Premises to verify:
- `docs/backlog-reconciliation.md` § The git cross-check mechanism carries `/prime` Step 1a's merged
  multi-repo `--since` scan verbatim, and `mission.md:47–48` carries Step 1d's enumeration verbatim.
  Re-derive both by reading, not from plan-v4's claim.
- `logs/scripts/prime-allocator.test.sh` extracts the 8k allocator from `prime.md` by awk and hard-
  exits 2 if its anchors move; baseline **19 passed / 0 failed**. Any extracted owner must be testable
  against the same contract, and the tripwire repointed in the same slice that moves the code.
- `logs/scripts/` already holds live `/prime` consumers (`run-manifest.sh`), so the topology for a
  script owner exists and is not a new pattern.
- The three orientation scans are genuinely **deterministic** — mechanical enough to leave a prompt.
  If any needs model judgement, it cannot be delegated to a script and stays.

Falsified if: no executable owner can hold these responsibilities without changing observable
behaviour; or the qualified owner's runtime cost exceeds the prose it replaces; or the scans prove
non-deterministic. Any of these is reported, not worked around.

Constraints carried from the operator's direction, 2026-07-29:
- The mission's **≤300 acceptance assertion stays frozen.** It is not renegotiated to fit a result.
- **Merged Slice 4+5 is held** and does not run before this returns.
- After qualification, a **measured package amendment** stating the resulting `prime.md` line count
  **and runtime cost** is produced **before this Build unit resumes**.
- If qualified executable delegation still cannot reach ≤300 without changing behaviour, the mission
  target is recorded **unmet**. The frozen contract is not rewritten to make it pass.
