# Risk Check — 2026-05-21

## Change

End-time gate for Track B phase 2 — the deferred schema/skill edits from project-plan-v3.md §11, applied to the working tree (not yet committed). Six files changed:

1. .claude/skills/mandate-parser/SKILL.md — B1/B4: added 4 new OPTIONAL mandate fields (out_of_scope, allowed_files, prohibited_actions, max_interruptions) to the §Required Mandate Fields table, the Step 7 mandate.json `fields` template, and preamble prose (eight→twelve canonical fields); Step 8 note that the 4 fields are excluded from `resolved_fields`; Step 9 `fields_resolved` literal 8→12 tied to table row count; Step 5 validation rule for the optional fields. B2: Steps 5/6 + Edge Cases reworded to the 5-mode blocker vocabulary; the operator-facing contract string `MANDATE UNRESOLVED — GENUINE BLOCKER` kept verbatim.
2. harness/schemas/mandate-history-schema.md — B1: Field Notes line documenting the 4 new fields are canonical but excluded from `resolved_fields`; a 4-word precision fix to one prose line ("eight canonical mandate fields" → "eight mandate fields recorded").
3. .claude/references/harness-rules.md — B2: the "Operational definition of genuine blocker" section reframed as the 5-mode blocker model (Stop / Escalate / Pause / Park / Narrow + a Confidence×Impact grid); Stop carries the verbatim v7 §Component 1 genuine-blocker definition. Marked as a Track B v3 amendment.
4. harness/schemas/state-machine.md — B2: an amendment note in Rollback Rules pointing to the 5-mode model; verbatim v7 rollback bullets unchanged.
5. harness/schemas/current-state-schema.md — B3: a `blocked_items` JSON array added with its entry shape (the Park-mode destination queue).
6. harness/test-workflows/minimal-markdown/workflow-config.yaml — B6: optional per-unit `tier` field (values A/B/C) added to the 3 test work units; YAML verified to still parse, accumulated_defaults unchanged.

Context: these are definitional-contract edits to harness components (a skill SKILL.md, two transcribed schemas, the harness-rules reference doc). B1/B2/B6 were already risk-checked at plan time (3 PROCEED-WITH-CAUTION reports under ai-resources/audits/risk-checks/2026-05-21-track-b-v3-*.md); mitigations were folded into project-plan-v3.md §11 and into these edits. The harness governor (Phase 3) is not yet built — these are forward-compatible contract changes it will consume. To be committed as: one commit for the mandate-parser/harness-rules definitional changes (B1/B4 + B2), one for B3, one for B6.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/mandate-history-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/references/harness-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/state-machine.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/current-state-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/test-workflows/minimal-markdown/workflow-config.yaml — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/agent-harness/project-plan-v3.md (authoritative spec, §11 lines 691–866) — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Self-contained, well-specified contract amendments to harness components with zero ongoing token cost and no permission changes; the only elevated dimension is blast radius — a contract change touching a multi-component definitional surface — and it is mitigable by atomic per-change commit sequencing, which the change plan already specifies.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the six edited files is an always-loaded file. `harness-rules.md` is explicitly load-on-demand: it states "Load this file before invoking any of [harness skills/commands]... Do NOT load when doing unrelated work in the repo — these rules cost context and are irrelevant outside harness sessions" (harness-rules.md lines 1–16). Token cost is paid only inside harness sessions, not per session generally.
- The `mandate-parser` SKILL.md is a skill body — loaded only when the skill is invoked at harness entry, not on every turn. No skill description change broadens its trigger pattern (frontmatter `description` block, SKILL.md lines 3–9, unchanged in scope by the edits).
- The three `harness/schemas/*.md` files are reference documents read on demand by harness components; they are not `@import`-ed into any CLAUDE.md.
- No hook is registered or modified. `session-start.sh` is invoked from inside the skill (SKILL.md Step 1, lines 72–78) and is explicitly "not a `SessionStart` hook" — the change does not alter that.
- The workflow-config.yaml `tier` field adds ~3 short lines to a test-only config (workflow-config.yaml lines 9, 27, 45); cost is incurred only when the test workflow runs.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` file is in the change set. The six files are skill/schema/reference/config documents only.
- No new Bash command pattern, Write path, or external API is introduced. The edits are prose, table rows, JSON-shape templates, and YAML keys inside files Claude already reads/writes within the harness working tree.
- No `deny` rule is removed or narrowed; no scope escalation (project → user). The change does not touch any permission layer.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 6 (the referenced set). The authoritative spec `project-plan-v3.md` §11 is a read-only input, not edited.
- Components referencing `harness-rules.md` (grep `harness-rules`, 6 hits): `.claude/hooks/subagent-stop.sh`, `.claude/skills/mandate-parser/SKILL.md`, `harness/README.md`, `harness/schemas/current-state-schema.md`, `harness/schemas/state-machine.md`, `harness/reports/2026-05-20-chatgpt-design-ideas-implementation-plan.md`. The B2 reframe preserves the verbatim v7 genuine-blocker definition as the Stop mode (harness-rules.md lines 61–63) and explicitly keeps "genuine blocker" valid as terminology (line 77), so callers that reference the blocker concept stay compatible.
- Components referencing `mandate-parser` (grep, 8 hits) and `current-state` (grep, 9 hits) — all are either the harness skills themselves, prep/roadmap docs, or historical reports. No executable caller breaks.
- Contract changes are additive/backwards-compatible: (a) the 4 new mandate fields are OPTIONAL — "absence is allowed and surfaced at /clarify" (SKILL.md line 49, line 156); the existing single `mandate-history.jsonl` entry (workflow `new-project`) has only 7 `resolved_fields` keys and stays schema-valid because the 4 fields are excluded from `resolved_fields` by design (SKILL.md Step 8 lines 238; mandate-history-schema.md line 52). (b) `blocked_items` is a new array added to a snapshot whose schema is still TBD ("Exact field names... are TBD" — current-state-schema.md line 63); no consumer reads it yet — the Phase 4 reporter and Phase 3 governor that consume it are not built. (c) the `tier` field is "optional; absent = A" (workflow-config.yaml line 9 comment; project-plan-v3.md line 805), honoring the v7 interface-evolution rule.
- The cross-cutting fragility point: `fields_resolved` literal in SKILL.md Step 9 (line 274, value `12`) and the §Required Mandate Fields table row count (12 rows, lines 53–64) are now coupled — SKILL.md line 279 documents this coupling and instructs updating both together. This is a known, documented dependency, not a silent one. `promotion-candidates-schema.md` Path C (line 57) correctly needs no edit because the candidate set is unchanged (verified: file references `resolved_fields` only, not the new fields).
- Why Medium not Low: this is a contract change spanning a multi-file definitional surface (one skill + three schemas + one reference doc + one config), and a 5th enumeration site beyond the originally-scoped 4 was discovered during planning (project-plan-v3.md line 838). A partial application — e.g., the SKILL.md table updated but the Step 9 literal not, or B3's `blocked_items` landing without B2's Park mode — would leave an inconsistent contract. The change is backwards-compatible only if applied as complete units.

### Dimension 4: Reversibility
**Risk:** Low

- All six files are tracked source files; the change is applied to the working tree and not yet committed. A `git revert` (post-commit) or `git checkout -- <file>` / `git restore` (pre-commit) fully restores prior state within the working tree.
- No data/log file is mutated. `mandate-history.jsonl` is NOT in the change set — the edits change the SKILL.md template that *will* produce future entries, not any existing entry. The one existing JSONL line is untouched and stays valid.
- No `settings.json` change, so no cached permission state to clean up.
- No state propagates beyond git: no push, no external write, no Notion write is part of this change. (Push remains a separate operator-gated step per Autonomy Rule #2.)
- No automation is added that could fire between landing and a revert — no hook, cron, or symlink.
- The three-commit split (B1/B4+B2, then B3, then B6) means a revert can target one definitional change without disturbing the others — this improves, not harms, reversibility.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- New contracts introduced are documented at the change site, which holds risk down: the 4 optional fields' exclusion from `resolved_fields` is stated in SKILL.md Step 8 (line 238) AND mirrored in mandate-history-schema.md (line 52, "Track B v3 amendment"); the `blocked_items` entry shape is given inline in current-state-schema.md (lines 30–40) with a "Track B v3 amendment" marker; the `tier` field carries an inline comment pointing to project-plan-v3.md §11 B6 (workflow-config.yaml line 9). The transcribed-schema files (`state-machine.md`, `current-state-schema.md`, `mandate-history-schema.md`) all carry explicit "Amendment (Track B v3)" markers so the verbatim-v7-transcription provenance is not silently broken (state-machine.md line 29; current-state-schema.md lines 20, 22–24).
- Implicit dependency 1: the `fields_resolved: 12` literal (SKILL.md line 274) silently depends on the §Required Mandate Fields table having exactly 12 rows. This coupling is now documented at the change site (line 279), but it remains a manual-sync invariant — a future field add that updates the table but not the literal, or vice versa, drifts silently with no automated check. Documented, but live.
- Implicit dependency 2: B3 (`blocked_items`) is the Park-mode destination and is meaningless without B2 (the 5-mode model that defines Park). current-state-schema.md line 26 names this: "the destination of the **Park** mode... see harness-rules.md". If B3's commit landed but B2's were reverted, `blocked_items` would reference an undefined mode. The change plan commits B1/B4+B2 first, then B3 — correct ordering — but the dependency is real and cross-commit.
- Functional-overlap check: no two mechanisms now contend for the same concern. B2 explicitly subsumes rather than replaces DP-8 ("Log, don't stop" → Park/Stop; harness-rules.md line 77), and the change preserves DP-8 in the Judgment rules section. No double-handling introduced.
- Forward-coupling to a not-yet-built component: the Phase 3 governor and Phase 4 reporter will consume `blocked_items`, `max_interruptions`, and the 5-mode model. These are forward-compatible contract changes by design (project-plan-v3.md §11 B2 "Consumers" note, line 745; B3 "Lands in v3" line 767). The governor is not on disk, so this cannot be verified against a real consumer — evaluated here from the documented intent in project-plan-v3.md §11, which is internally consistent.
- Why Medium not Low: two implicit dependencies (the table-count/literal sync invariant; the B3→B2 cross-commit ordering dependency). Both are documented, neither auto-fires in an unexpected context — which keeps it at Medium rather than High.

## Mitigations

- **Blast radius (Medium) — atomic per-definitional-change commits.** Land the change as the three commits the plan already specifies (B1/B4 + B2 together; B3 alone; B6 alone) and do NOT split a single definitional change across commits. In particular, the five B1/B4 enumeration sites in `mandate-parser/SKILL.md` (table rows, Step 7 template, Step 8 exclusion note, Step 9 `fields_resolved` literal, preamble prose) plus the Step 5 validation rule and the `mandate-history-schema.md` Field Notes line must all be in one commit so no consumer ever sees a half-applied field set. Before committing, confirm the §Required Mandate Fields table has exactly 12 rows and the Step 9 literal reads `12`.
- **Hidden coupling (Medium) — verify the B3→B2 commit order and the table-count invariant at commit time.** Commit B2 (5-mode model in `harness-rules.md` + `mandate-parser` + `state-machine.md`) before or with the B1/B4 commit, and commit B3 (`blocked_items` in `current-state-schema.md`) only after B2 is committed — `blocked_items` references the Park mode that B2 defines. As a one-line completion check, grep the final `mandate-parser/SKILL.md` for the `fields_resolved` literal and the table row count and confirm they agree (the file documents this invariant at line 279).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION, the six referenced files, project-plan-v3.md §11, and cross-referencing schema files). The forward-coupling to the not-yet-built Phase 3 governor is explicitly evaluated from the documented intent in project-plan-v3.md §11 and flagged as such under Dimension 5. No training-data fallback was used on fetch/read failures.
