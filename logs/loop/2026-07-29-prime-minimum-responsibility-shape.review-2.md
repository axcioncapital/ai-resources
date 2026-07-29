REVIEW
UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape
REPO: ai-resources
BASE: aa7a56d
NEXT: Claude — adjudicate review-2 and correct the plan before G1

PREMISE DIMENSION

V2 materially improves the design, but it is not ready for G1. Four material findings remain.

[MATERIAL F1] Moving Step 2.5 before Step 2.4 removes validation from the values closest to the write.

Objects inspected:
- Plan-v2 §1
- `session-start.md` Steps 2, 2.4 and 2.5

`files_inferred` is initially set by Step 2, not Step 2.4. The actual ordering hazard is:

1. Step 2.5 sees `files_inferred=true` and accepts `(inferred)`.
2. Step 2.4 replaces it with engine-generated concrete paths and clears the flag.
3. Those new paths reach disk without Step 2.5’s shape and existence checks.

Likewise, any `f:` or other correction made at the new Step 2.4 gate happens after the self-check and is written without revalidation.

The gate must operate on discovered and validated state, and gate edits must be revalidated before writing. A second stop remains acceptable only when validation cannot auto-correct—the named error exception already allows that.

One further ambiguity: current Step 2.4 does not re-emit on `engine-skipped` or `engine-error`. Under `{gate:auto}`, the plan must explicitly require a gate for all four engine outcomes; “use the existing re-emit” is insufficient because two outcomes have no existing re-emit.

[MATERIAL F2] The approved plan payload still has two owners and `/session-plan` may begin execution before Prime’s risk-check.

Objects inspected:
- Plan-v2 gate diagram and `{gate:auto}` payload
- `session-start.md` Step 4
- `session-plan.md` Steps 0, 2, 5–8

Prime derives and displays model, autonomy and structural-risk fields at the gate. `/session-plan` does not consume those fields—it derives them again when writing the plan. P-PAYLOAD compares only mandate fields.

Therefore the operator-approved plan fields can differ from the plan on disk. An `edit` changing `work_scope` makes this worse: Prime’s precomputed `STRUCTURAL_RISK` can become stale while `/session-plan` derives from the corrected scope.

There is also a control-flow hazard. With only `{plan:overwrite}`, `/session-plan` Step 8 takes its default branch and says to begin execution. Prime’s `/risk-check` is supposed to run only after that command returns. The plan has not established a “write plan and return to Prime without prompting or executing” contract.

Before G1, Shape must establish:

- one authoritative plan-field state;
- how gate edits update that state;
- how `/session-plan` returns without beginning work;
- proof that risk-check precedes every structural edit.

NEGATIVE-RESULT DIMENSION

[MATERIAL F3] P-CITE excludes active code under `logs/scripts/`.

Object inspected:
- Plan-v2 P-CITE
- `logs/scripts/run-manifest.sh`
- `logs/scripts/prime-allocator.test.sh`

Excluding all of `logs/` omits live consumers that the slices themselves modify. In particular, `run-manifest.sh` currently cites Steps 8c.7 and 8k.

Exclude historical/session artifacts narrowly, but include `logs/scripts/`. A positive control over a search domain that excludes known consumers does not establish completeness.

[MINOR F4] P-PACK4 is not executable as written.

Object inspected:
- Plan-v2 P-PACK4 and `LIMITATIONS`

The plan requires forcing an engine failure but explicitly says no deterministic failure mechanism is known. Until a fixture, stub, or equivalent injection method is named, the failed-engine branch remains unassessed rather than falsifiable.

CLAIM-TO-EVIDENCE DIMENSION

[MATERIAL F5] The neither-field `/develop-ai-resource` route exists, but it does not provide the claimed return path.

Objects inspected:
- `develop-ai-resource.md` Steps 1.0 and 4
- `docs/work-loop.md` Execution boundary
- Plan-v2 Slice 2 and open item 7

The reading of line 38 is correct: neither field invokes ordinary qualification without a capability record.

The conclusion is not correct. Ordinary direct invocation ends with its own operator choice—Ship, Revise, Defer or Delete. It does not return an artifact disposition to `/work-loop`. Only upstream mode returns a disposition, and that mode requires a capability record.

Consequences:

- Writing the disposition into Prove evidence is an invented return path that contradicts the current contract.
- Direct invocation introduces an additional adoption stop outside the challenged route’s exactly-three-stop contract.
- Merely reporting the contract gap does not unblock Slice 2.

This must be settled as a blocking dependency before G1, not deferred as a separate informational defect.

[MINOR F6] The line-budget arithmetic is internally inconsistent.

Object inspected:
- Plan-v2 §2 and Slice 5

The 8c targets total 59, not 57, because the two-line header was omitted from the sum. The overall projection is therefore 310, not 308.

Slice 5’s stated reductions total 16:

- Step 1b: 10 → 6 = 4
- Step 1c: 12 → 4 = 8
- Step 6: 24 → 20 = 4

That projects 310 → 294, not 308 → 296. If only 12 lines are actually recovered, the corrected projection is 298.

The ≤300 result remains plausible, but the figures presented to G1 must be corrected.

[MINOR F7] The `session-start.md` +25 estimate is understated under the architecture actually required.

Object inspected:
- Plan-v2 §1
- Current 405-line `session-start.md`

The estimate does not yet include complete handling for:

- gates on skipped and failed engine outcomes;
- validation after discovery and gate edits;
- exact payload serialization;
- returning from `/session-plan` without execution;
- keeping approved plan fields equal to written fields.

Re-estimate after F1/F2 are resolved. This growth does not directly threaten Prime’s ≤300 target, but it affects the claimed workspace-level leanness and maintenance cost.

CONFIRMED DECISIONS

- The Slice 5 floor is correct. If the live result remains above 300, report falsification rather than improvising deeper cuts. That preserves the Shape contract.
- The ordering `Slice 1 → Slice 3 → Slice 2` is correct. Consolidating to the final 8h call site before allocator integration reduces the integration surface. Slice 2 remains blocked on F5.
- The revised abort wording is honest: marker/header/mtime remain, while mandate, manifest and plan do not.
- Plan-v2’s `LIMITATIONS` section is specific and candid.
- Scope discipline is intact: commit `aa7a56d` adds only plan-v2.

VERDICT

Not ready for G1.

The blocking corrections are:

1. Validate engine-derived and gate-edited fields before writing.
2. Establish one plan-field owner and a non-executing return from `/session-plan`.
3. Include `logs/scripts/` in citation proof.
4. Resolve the non-capability artifact-return contract before Slice 2.
5. Correct the budget arithmetic and revised growth estimate.

Because this is already review-2, Claude should adjudicate these findings under the existing unit and present the corrected, explicitly bounded G1 package without assuming another review round.
