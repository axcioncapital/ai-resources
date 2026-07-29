REVIEW
UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape
REPO: ai-resources
BASE: 9be8bb0
NEXT: Claude — revise the plan before G1

PREMISE DIMENSION

The central premise remains sound: `/prime` can become an orient → menu → select → dispatch router, with operational ownership delegated elsewhere.

However, the proposed plan is not ready for G1. Six material findings affect the delegation contract, line budget, citation migration, slice boundaries, and proof package.

[MATERIAL F1] The “four stops become one” analysis is incomplete.

Object inspected:
- Shape plan § C1 and Slice 1
- `session-start.md` Steps 2, 2.4 and 2.5
- `session-plan.md` Step 0

`{gate:pre-approved}` suppresses only the Step 2 confirmation and Step 2.4 re-emission. It does not prevent:

- Step 2.5 re-asking when scope, exit condition, files, or `stop_if` are not safely derivable.
- `/session-plan` prompting during same-session re-invocation.

Therefore a normal first run may retain one stop, but the full dispatch contract does not. F-1GATE exercises neither of these branches.

The token may be the smallest syntax, but it is not yet a sufficient interface. Shape must explicitly decide how Step 2.5 exceptions and same-session re-invocation behave.

[MATERIAL F2] The context-pack result cannot be folded into a gate that occurs before context discovery.

Object inspected:
- Shape plan Slice 1 ordering and dependency graph
- Current `prime.md` Steps 8c.4.5–8c.6
- `session-start.md` Steps 2–2.5

The plan moves context discovery into `/session-start`, which runs after Prime’s approval gate. Consequently, Prime cannot show the context-pack result or readiness state at that gate as it does today.

There is a second seam: Prime approves one set of mandate fields, then `/session-start` reparses and may enrich or correct them after approval while its confirmation is suppressed. Nothing proves that the approved mandate equals the mandate written to disk.

The plan also says “abort still writes nothing” while acknowledging marker/header/mtime writes occur before the gate. Those statements cannot both be true.

Before G1, the plan needs a coherent owner and order for:

- context discovery;
- the single approval gate;
- the exact approved mandate payload;
- abort/write behavior.

[MATERIAL F3] The 64-line Step 8c budget and 297-line total are not sufficiently supported.

Object inspected:
- Shape plan §1 budget table
- Current `prime.md` Step 8c

The current gate and response parser alone occupy roughly the planned 16-line gate allowance several times over. The proposed 64 lines also have no allowance for resolving F1/F2: context-pack disclosure, exact mandate handoff, exceptional Step 2.5 stops, or re-invocation behavior.

Other high-risk estimates are:

- Step 0: 58 → 14 while retaining repo detection, behind checks, pull/rebase/autostash recovery, and unpushed-state handling.
- Step 1a: 39 → 20.
- Step 8a: 50 → 15.
- Step 8b: 32 → 11.

Three lines of global slack across fifteen prose-derived estimates is not a credible completion margin.

Slice 5 need not always run, but it must become a mandatory contingency: execute it when the live result exceeds a defined safe threshold. Calling it fully droppable leaves no recovery path if the estimates miss.

[MATERIAL F4] The citation census and Slice 1 repoint list are incomplete.

Object inspected:
- Shape plan C2, Slice 1 file list and F-CITE
- Repository-wide citation search

At least these live references are omitted:

- `.claude/commands/build-context.md` — cites Prime Step 8c.4.5.
- `.codex/agents/context-discovery.toml` — cites auto-prime and Step 8c.4.5.
- `.claude/hooks/check-foreign-staging.sh` — cites Prime Step 8c.7 as the mandate writer.

The claimed six-file Slice 1 is therefore incomplete, as is the “14 external files / 3 scripts” baseline.

F-CITE must search the repository for removed identifiers and ownership claims, with positive controls. Rechecking only the original 14-file census could pass while stale references survive.

[MATERIAL F5] Slice 2 has unresolved ownership and rollback semantics.

Object inspected:
- Shape plan Slice 2, §4 qualification and §5 rollback
- `/develop-ai-resource`
- Work-loop capability-record rules

The plan says `/develop-ai-resource` must author and qualify `prime-marker.sh`, but Slice 2 simultaneously lists that script as its own new artifact and claims reverting Slice 2 deletes it.

Those cannot all be true. If another development stream authors the script, this stream integrates an existing artifact; its rollback would remove the integration but leave the qualified script in place.

The proposed capability record is also opened after G1 even though the development path expects that record at Frame. The exact owner, record, unit boundary, commit ownership, and handoff must be settled before G1.

Slice 3 is unnecessarily blocked on Slice 2: shared header/mtime consolidation can call the existing inline allocator after Slice 1. It depends on Slice 1, not inherently on allocator extraction.

[MATERIAL F6] The falsification table does not yet prove all affected dispatch paths.

Object inspected:
- Shape plan §6
- Current Prime auto, menu, failure and context-discovery branches

Important missing proofs include:

- Step 2.5’s re-ask branches.
- Same-session `/session-plan` re-invocation.
- Approved gate fields exactly matching the written mandate.
- Context-pack information being available at the promised operator point.
- `edit` and `abort` paths, including pre-gate writes.
- Context discovery outcomes: enriched, insufficient, skipped and failed.
- Out-of-range auto selections.
- Direct-route and risk-check branch behavior.

Several current criteria also have evidence problems:

- F-DUP searches phrases, so duplicated logic can survive with rewritten wording.
- F-CITE relies on an incomplete census.
- F-SEED does not specify an executable method for proving marker consultation occurs before scanning.
- F-FAIL tests direct `/session-start` failure, but not the new Prime-to-session-start seam.

NEGATIVE-RESULT DIMENSION

[MINOR F7] The “no capability record exists” result lacks a positive control.

Object inspected:
- Shape plan §0 and §4

The absence may be correct, but the plan records only an empty search result. Add a nearby known-match control or an explicit registry/inventory check so the result distinguishes “nothing exists” from “the search shape was wrong.”

WORK-LOOP AUTHORITY

[MINOR F8] F1 does not require an operator ruling at G1.

Object inspected:
- `.claude/commands/work-loop.md`
- `docs/work-loop.md`

The command says the contract wins on conflict. The contract permits settled corrections to existing commands. Therefore authority to build this correction is already resolved.

The contradictory “never edits `/prime`” command text is a separate work-loop defect. Record and route it separately; do not make it an operator authorization condition for this stream.

SCOPE AND LIMITATIONS

- The reviewed commit changes the plan, not `/prime`; scope discipline is intact.
- This was a static pre-implementation review. No proposed token or delegated flow exists to execute yet.
- The ≤300-line target remains plausible, but the current ~297 estimate is not proven until the approval/context seam is redesigned and measured.

VERDICT

Not ready for G1.

Claude should produce `shape.plan-v2.md` resolving F1–F6, with:

1. One coherent approval/context/mandate handoff.
2. A complete citation census.
3. Exact ownership for allocator development and integration.
4. A contingent but mandatory headroom slice.
5. Executable proofs for every changed dispatch and failure path.

Because those corrections change the load-bearing architecture rather than merely wording, plan-v2 should return for review-2 before G1.

Next: paste this REVIEW block back into Claude’s `/work-loop` Shape unit and request `shape.plan-v2.md`.
