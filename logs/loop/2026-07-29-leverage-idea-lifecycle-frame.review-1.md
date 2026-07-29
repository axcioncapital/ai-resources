UNIT: 2026-07-29-leverage-idea-lifecycle-frame   STREAM: 2026-07-29-leverage-idea-lifecycle   PHASE: frame
REPO: ai-resources                               BASE: 557987764bbef917ddb05696ba59964320628b41   NEXT: Claude

REVIEW
Objects inspected:
- Frame brief at commit 3d744bd52162a7cb6cfdefac82e79d08a005903e.
- Frame evidence at commit 557987764bbef917ddb05696ba59964320628b41.
- The live leverage-idea.md; its hash matches the version Frame inspected.
- develop-ai-resource.md, docs/work-loop.md and .claude/commands/work-loop.md.

MATERIAL 1 — premise P2 was not fully confirmed.
develop-ai-resource.md’s authoritative resource enumeration names skills, prompts,
instructions, reference files, commands, scripts and hooks, but not agent definitions.
Its later search of .claude/agents establishes duplicate-search coverage, not lifecycle
ownership. The required new-agent route therefore rests on inference while Frame reports
the premise as confirmed. Adjudication must resolve that authority gap before an agent
handoff can be treated as compliant.

MATERIAL 2 — Frame’s execution-boundary judgment conflicts with the contract.
leverage-idea.md currently accepts ideas about workspace AI resources and produces an
implementation plan. The required result expands its accepted idea classes to operating
capabilities, new projects, broad technical needs and domain decisions; replaces its
terminal plan with lifecycle handoffs; and may introduce durable inbox addressing.
That changes the command’s authority, input domain and output contract, not merely an
incorrect destination row. Under docs/work-loop.md § Execution boundary, this is a
material expansion of an existing durable AI artifact and belongs to
/develop-ai-resource. Because the artifact change is this stream’s whole need rather
than one component of a capability stream, Frame’s “work-loop implements” conclusion
is unsupported.

MATERIAL 3 — this review was requested at the wrong reviewed-route phase.
docs/work-loop.md defines reviewed work as one Codex review of the result. Frame’s own
evidence says the object was not edited and no result exists. However,
.claude/commands/work-loop.md Step 7 currently sends every reviewed unit to Codex,
including Frame. The command’s introduction says the contract wins on disagreement.
This Frame review must not be counted as the reviewed route’s result review; the
command/contract disagreement is a separate work-loop defect requiring disposition.

MINOR 1 — one load-bearing negative result lacked a positive control.
The BASE-overlap grep returned empty without showing the same check matching a known
changed path. Independent inspection of 44062e4..2b8b350 shows only
logs/loop/2026-07-29-prime-minimum-responsibility-build-2.brief.md, so the no-overlap
conclusion is correct, but the submitted evidence did not meet the contract’s negative-
result standard on its own.

Scope and limitations:
- Frame made no out-of-scope repository edit.
- LIMITATIONS is specific and candid.
- The known System Owner toolkit row was inspected and still describes leverage-idea
  as producing build proposals and feeding request-skill; sibling correction remains
  outside this unit.
