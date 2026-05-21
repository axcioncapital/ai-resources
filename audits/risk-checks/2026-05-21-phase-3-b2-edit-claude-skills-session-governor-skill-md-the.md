# Risk Check — 2026-05-21

## Change

Phase 3 B2 — edit `.claude/skills/session-governor/SKILL.md` (the Phase 3 B1 governor skeleton) to fill its `STUB [B2]:` markers. Five changes, all within this single existing skill file: (1) add a new Phase C section for strategic compaction + governor-owned post-compact rehydration (re-read `mandate.json`, `current-state.json`, `hardening-registry.json`, `workflow-config.yaml` from disk); (2) fill Phase B step 5 with real context-budget monitoring — log `context_usage` events, trigger `/compact` at 60–70% at a unit boundary; (3) fill Phase A step A2 part 5 so the governor acts on the compaction policy; (4) fill Phase B steps 11–13 so the Park disposition appends to the `blocked_items` queue in `current-state.json` (amendment B3) — leaving the co-located `STUB [PHASE-5]:` verification-failure handling intact; (5) add the operator attention budget (B4 — `max_interruptions` field caps Escalates, downgrade to Park past cap) and the decision-packet format (B5). The `blocked_items` schema (`harness/schemas/current-state-schema.md`) and the `max_interruptions` mandate field already exist from Track B phase 2 (commits 87f92eb, ff86fcd) — B2 wires the governor to them; no schema edits. The Phase D `STUB [B2]:` marker (session-reporter trigger / Stop hook veto) is deliberately NOT filled — that is Phase 4 work. Single-file structural edit to an existing skill; no new files, no new commands, no permission changes, no hook edits.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md — exists

## Verdict

GO

**Summary:** A single-file edit to an existing, never-yet-invoked skeleton skill that wires the governor to schemas already locked upstream; no ongoing token cost, no permission change, clean git revert, and every contract it depends on or creates is documented at the change site or in a co-located schema.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edited file is a skill, not an always-loaded file. `session-governor/SKILL.md` is invoked on demand, "Run once per harness session, after mandate-parser has written mandate.json" (`SKILL.md:8`) — it is not loaded on every turn and does not enter any `@import` chain in workspace or project CLAUDE.md.
- Neither CLAUDE.md references the governor skill as always-loaded content. The workspace CLAUDE.md "Agent Harness" section loads `@.claude/references/harness-rules.md` on demand only ("Do not load it for unrelated work" — workspace `CLAUDE.md:164`); the governor skill itself is not auto-imported anywhere.
- No hook is registered, edited, or auto-fired by this change — the description states "no hook edits" and the skill body confirms "it is NOT built from chained hooks" (`SKILL.md:23`).
- The change adds skill body content (a new Phase C section plus filled stub bodies) — this enlarges the skill's token cost only when the skill is actually invoked (once per harness session), i.e. pay-as-used, not per-turn.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change description explicitly states "no permission changes." No `settings.json` `allow`/`ask`/`deny` file is in scope.
- The governor's actions inside the new content — re-reading JSON/YAML state files from disk, appending `session-log.json` events, calling `/compact` — are all capabilities the B1 skeleton already exercises (`current-state.json` writes, `session-log.json` appends, sub-agent delegation per `SKILL.md:212`). `/compact` is a built-in slash command, not a tool family requiring a new permission entry.
- No new external API, cross-repo write, or MCP capability is introduced; all reads/writes stay within `harness/`.

### Dimension 3: Blast Radius
**Risk:** Low

- **Files touched directly: 1** — `.claude/skills/session-governor/SKILL.md`. The description states "no new files, no new commands, no permission changes, no hook edits," and the session plan corroborates: "the single file B2 edits" (`harness/logs/session-plan.md:15`).
- **Skill-reference enumeration** (`grep -rl "session-governor"`, excluding the skill itself): 11 files reference the governor by name. Of these, only **2 are operative callers/contracts** — `.claude/references/harness-rules.md` (lists the skill in its load-trigger list, `harness-rules.md:7`) and `.claude/skills/mandate-parser/SKILL.md` (hands off to the governor). The remaining 9 are logs, reports, and session notes (`harness/logs/session-notes.md`, `logs/decisions.md`, `harness/reports/2026-05-21-session-governor-b1-unit-1-trace.md`, etc.) — historical record, not runtime callers. Neither operative caller requires modification: the handoff contract (mandate-parser writes `mandate.json`, governor reads it) is unchanged by B2, and harness-rules.md's load-trigger list is unaffected.
- **Schema-contract enumeration:** the new content reads from `current-state-schema.md` (`blocked_items` entry shape), `session-log-schema.md` (`context_usage`, `compaction_event` event types), and `mandate-history-schema.md`/`mandate-parser` (`max_interruptions`). All three schemas are confirmed present and already define the exact fields B2 consumes (see Dimension 5). B2 conforms to these schemas; it does not edit them — "no schema edits" per the description, confirmed.
- **No contract change.** The governor's external contracts — `current-state.json` shape, `session-log.json` event types, the per-unit `learnings.json` null entry, the commit-message format — are all unchanged. B2 fills internal stub bodies and adds one new internal phase section; nothing a caller depends on changes shape.
- The skill has **never been invoked in production** — it is the "B1 skeleton … the first of the two-session Phase 3 build" (`SKILL.md:43`). There is no live workflow whose behavior B2 can regress.

### Dimension 4: Reversibility
**Risk:** Low

- The change is a single-file edit to a version-controlled skill file. `git revert` of the B2 commit fully restores the B1 skeleton with no residue — no sibling files or directories are created (description: "no new files").
- The skill is a definition file, not a data/log file. Reverting it does not leave stale entries in any append-only log — `innovation-registry.md`, `session-log.json`, `learnings.json`, etc. are untouched by this edit. (The git status shows `logs/innovation-registry.md` modified, but that is unrelated session-tracking churn, not part of this change's scope.)
- No `settings.json` edit, so no cached permission state or operator-remembered workflow to clean up beyond git.
- No state is pushed beyond the local repo by the change itself; push remains a separate operator-gated step (Autonomy Rule #2).
- No automation (hook, cron, symlink) is added that could fire between landing and a potential revert — the skill only executes when explicitly invoked in a harness session.

### Dimension 5: Hidden Coupling
**Risk:** Low

- **`blocked_items` contract — verified present and documented.** `current-state-schema.md:22-43` defines the `blocked_items` array and the exact entry shape `{id, unit_id, mode, raised_at, summary, recommended_resolution, status}`, with `mode` enum `park | escalate_downgraded`. The B1 skeleton already reserves the slot: "`blocked_items` is written as an empty array `[]` … the slot is reserved so B2 (the blocked-item queue, B3) … never see an absent key" (`SKILL.md:166-170`). B2 wires to a documented, pre-locked contract — not a new implicit dependency.
- **`max_interruptions` field — verified present.** `mandate-parser/SKILL.md:64` defines `max_interruptions` ("Integer cap on operator-facing escalations per session (default 2)"), and `current-state-schema.md:42` already references the attention-budget downgrade semantics ("an Escalate that the operator attention budget (`max_interruptions`) downgraded to a Park"). The B4 logic B2 adds honors an existing field with an existing default.
- **`context_usage` / `compaction_event` log events — verified present.** `session-log-schema.md:28-29` already defines both event types. B2's context-monitoring and compaction logging emit pre-defined event types — no new undocumented log contract.
- **Compaction preservation contract — verified present.** `harness-rules.md:79-83` gives the verbatim `/compact` preservation instructions and explicitly states the governor re-reads `mandate.json`, `current-state.json`, and `hardening-registry.json` after compaction; `harness-rules.md:44` states "The governor owns post-compaction rehydration." The new Phase C section implements an already-documented design, not a silent new mechanism. Note: the B2 description adds `workflow-config.yaml` to the rehydration set — harness-rules.md names three files, the description names four. This is an additive, internally-consistent extension (the workflow config is in the governor's must-read tier, `SKILL.md:86`) and is documented at the change site; not a hidden dependency, but the B2 author should note the minor superset relative to `harness-rules.md:83`.
- **No functional overlap.** Hooks log compaction events but "do not drive control" (`harness-rules.md:44`, `SKILL.md:24`); the governor owns rehydration. B2's Phase C does not duplicate or contend with a hook — the division of labor is already specified.
- **Co-located stub hazard is identified and bounded.** Phase B steps 11–13 hold both a `STUB [B2]:` and a `STUB [PHASE-5]:` marker in the same paragraph (`SKILL.md:228-234`). The change description and session plan both flag this explicitly ("leaving the co-located `STUB [PHASE-5]:` … intact" — description; `session-plan.md:25` *Caution* note). This is a known, documented surgical boundary inside a single skill file, not hidden coupling — but it is the one place where an imprecise edit could damage an unrelated Phase 5 stub. It is correctly surfaced upstream and is an execution-care item, not a structural risk.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. The two upstream commits cited in the change description (87f92eb, ff86fcd) were verified via `git log`: 87f92eb = "Track B phase 2 — B3 blocked-item queue in current-state schema"; ff86fcd = "Track B phase 2 — B1/B4 mandate scope fields + B2 5-mode blocker model" — both confirm the schema prerequisites the change relies on.
