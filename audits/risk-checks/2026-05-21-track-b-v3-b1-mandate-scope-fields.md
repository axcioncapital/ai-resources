# Risk Check — 2026-05-21

## Change

Track B v3 amendment B1 — mandate scope fields. Proposed structural change: add three new fields to the canonical Agent Harness mandate field set — `prohibited_actions` (net-new), plus `out_of_scope` and `allowed_files` (these two already exist in the Phase-3 prep mandate template `harness/prep/session-mandate-template.md` but are absent from the full-harness mandate schema). The change is specified in `project-plan-v3.md` (Phase 2) THIS session — v3 is a plan document. The actual built-component edits are DEFERRED to a follow-on Track B phase 2 and consist of: (1) `harness/schemas/mandate-history-schema.md` — add the new fields to the `resolved_fields` object + field notes (the schema itself flags this reconciliation as open in its Field Notes); (2) `.claude/skills/mandate-parser/SKILL.md` — update 4 mandate-field enumeration sites: the §Required Mandate Fields 8-field table, the Step 7 `mandate.json` `fields` object, the Step 8 `mandate-history.jsonl` `resolved_fields` object, and the Step 9 `mandate_parsed` payload `fields_resolved` count; (3) `harness/session/mandate.json` — sample/live instance shape (currently absent — session-scoped, created at runtime). Note the key coupling: the schema and the built `mandate-parser` skill must change together or the skill enumerates a field set inconsistent with the schema. This is a plan-time risk gate per the implementation plan §7 — evaluate the risk of the proposed schema+skill change so v3 can specify it correctly. The harness is currently at Phase 2 complete (mandate-parser is a built, shipped skill); the governor (Phase 3+) is not yet built.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/mandate-history-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/session/mandate.json — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/prep/session-mandate-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/agent-harness/project-plan-v3.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A bounded multi-site schema+skill field-set extension whose risk is concentrated in blast radius and hidden coupling — multiple enumeration sites and at least one external schema (`promotion-candidates-schema.md` Path C) must change in lockstep — but every elevated dimension has a concrete paired mitigation, and the change itself is correctly scoped as plan-time-only this session.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The change targets `harness/schemas/mandate-history-schema.md`, `.claude/skills/mandate-parser/SKILL.md`, and a runtime-created `harness/session/mandate.json` — none of these is workspace or project CLAUDE.md. Workspace CLAUDE.md loads `mandate-parser` only via the on-demand Agent Harness pointer ("When running a harness skill … load `@.claude/references/harness-rules.md`"), not per-turn.
- The `mandate-parser` SKILL.md is pay-as-used: it is invoked once per harness session at startup ("Must be run at the start of every harness session" — SKILL.md description, lines 7-8), not per turn and not per tool call. Adding three field rows to its 8-field table and three keys to two JSON blocks adds an estimated 60–110 tokens to a skill that is already ~320 lines and only loads inside harness sessions.
- No hook is added or modified. No `@import` chain is introduced. The `mandate-history-schema.md` reference doc is read by the skill at Step 3 only inside harness sessions.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. The change edits two markdown/schema files and (in phase 2) a runtime JSON instance — no `allow`, `ask`, or `deny` entry is added, removed, or widened.
- `prohibited_actions` is a *data field carrying operator intent*, not a Claude Code permission primitive. It does not grant or gate any tool capability — it is parsed and surfaced at `/clarify` like every other mandate field (SKILL.md Steps 4–6). Naming note: despite the word "prohibited", this field does not interact with the permissions layer; it is advisory mandate content.
- No new Bash/Write/external-API invocation pattern is introduced. The mandate-parser's write set is unchanged (`mandate.json`, `mandate-history.jsonl`, `session-log.json` — SKILL.md Output Summary, lines 316-322).

### Dimension 3: Blast Radius
**Risk:** High

- Direct files touched by the deferred phase-2 edit: 2 existing (`mandate-history-schema.md`, `mandate-parser/SKILL.md`) + 1 runtime instance (`harness/session/mandate.json`). v3 itself (plan doc) is edited this session.
- Within `mandate-parser/SKILL.md` the change is **not** single-site — CHANGE_DESCRIPTION names 4 enumeration sites, and direct read confirms them: §Required Mandate Fields table (SKILL.md lines 51-60, currently 8 rows), Step 7 `mandate.json` `fields` object (lines 182-192), Step 8 `mandate-history.jsonl` `resolved_fields` object (lines 212-221), Step 9 `mandate_parsed` payload `fields_resolved: 8` (line 263). A 5th coupled site exists: SKILL.md line 49 prose "must include all eight canonical fields" and line 228 note on `trust_statement` exclusion from mandate-history. Any site missed leaves the skill internally inconsistent.
- Grep enumeration across `harness/`, `ai-resources/`, `.claude/` for components referencing the affected artifacts:
  - `resolved_fields` (the schema object being extended): 4 files — `mandate-parser/SKILL.md`, `harness/learning/mandate-history.jsonl` (1 live data line), `harness/schemas/mandate-history-schema.md`, `harness/reports/2026-05-20-chatgpt-design-ideas-implementation-plan.md`.
  - `mandate-history` referenced by: `harness/schemas/promotion-candidates-schema.md`, `harness/schemas/session-log-schema.md`, `harness/schemas/write-ownership.md`, plus the SKILL and the implementation-plan report.
  - `mandate-parser` referenced by: `.claude/hooks/session-start.sh`, `.claude/references/harness-rules.md`, `ai-resources/.claude/commands/session-start.md`, plus reports/audits.
- Contract change is **not backwards-compatible at the schema level**: `promotion-candidates-schema.md` line 57 defines Path C ("Mandate field → Workflow default … Sourced exclusively from `mandate-history.jsonl` … where `field_sources` shows `operator`"). Adding fields to `resolved_fields` silently expands the set of fields the future maturation engine treats as Path C promotion candidates — `prohibited_actions`, `out_of_scope`, `allowed_files` would all become auto-fill candidates unless explicitly excluded. The schema's own Field Notes (lines 50-51) already flag this reconciliation as open: "Additional mandate fields … are not enumerated in the `resolved_fields` sub-object … The Phase 0 shared-infrastructure build should reconcile this if it matters for Path C matching."
- Existing live data: `harness/learning/mandate-history.jsonl` has 1 real entry (session `20260425-1512`). It will lack the three new keys after the schema changes — a real (if small) data-shape skew between historical and future entries.
- v3's own internal consistency: v3 §6 Phase 2 item 1 (lines 256-257) still enumerates the *old* 9-field list ("work scope, exit condition, permissions level, stop rule, review layer overrides, trust statement, constraint priority order, success criteria, review window") with no mention of B1's three fields. The B1 row in the changelog table (line 20) says B1 "Lands in §6 Phase 2", but §6 Phase 2's body text was not updated to match. v3 is internally inconsistent on B1 as currently written.
- v3 references a "Track B Amendment Record" section ("at the end", line 16; "§ Track B Amendment Record → Deferred schema/skill application phase", line 29) — but the file ends at line 689 (Appendix A) and that section is **absent**. The deferred-phase enumeration the CHANGE_DESCRIPTION relies on as the authoritative scope list does not exist in the referenced file.

### Dimension 4: Reversibility
**Risk:** Low

- The phase-2 built-component edits are confined to two tracked text files (`mandate-history-schema.md`, `mandate-parser/SKILL.md`) — a single `git revert` of the phase-2 commit fully restores both. No sibling files or directories are created by the field-set extension itself.
- `harness/session/mandate.json` is session-scoped and runtime-created (SKILL.md line 25, "Written (overwrite)" line 318); it is not committed state, so there is nothing to revert for that artifact.
- `harness/learning/mandate-history.jsonl` is append-only, but this change does **not** mutate it — no log entry is written by the schema/skill edit. The 1 existing entry is untouched. (Once the changed skill runs in a future session it will append wider entries, but that is downstream session behavior, not part of this change's revert surface.)
- This session's edit is to `project-plan-v3.md` only (a plan document) — `git revert` cleans it fully. No external write, no push, no automation fires.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Schema↔skill lockstep is named but a third coupled artifact is not.** CHANGE_DESCRIPTION correctly flags that `mandate-history-schema.md` and `mandate-parser/SKILL.md` must change together. It does **not** name `harness/schemas/promotion-candidates-schema.md`, whose Path C definition (line 57) is contractually coupled to the `resolved_fields` field set. Extending `resolved_fields` without a paired decision on Path C eligibility silently changes which mandate fields the maturation engine (Phase 7) will later treat as workflow-default promotion candidates. This is an undocumented downstream contract dependency.
- **Asymmetric field set across the three mandate artifacts is a pre-existing trap the change widens.** The skill already carries an asymmetry: `trust_statement` appears in the §Required Fields table and in `mandate.json` (Step 7) but is deliberately excluded from `mandate-history.jsonl` (SKILL.md line 228: "`trust_statement` is excluded from mandate-history per the schema"). Each of the three new fields needs an explicit in/out decision *per artifact* — is `prohibited_actions` a Path C candidate (→ in `resolved_fields`) or not (→ excluded like `trust_statement`)? CHANGE_DESCRIPTION assumes all three go into `resolved_fields` but does not state the Path C rationale. Without that rationale documented at the change site, a future editor cannot tell whether the inclusion was intentional.
- **The `fields_resolved` count is a magic number with no derivation.** SKILL.md Step 9 line 263 hardcodes `"fields_resolved": 8`. After the change it becomes 11 (or 12 with `review_layer_overrides`, which is currently optional — SKILL.md line 62). The count is a literal, not computed; it is silently coupled to the table length and will drift on any future field add. Nothing at the change site documents what the number must equal.
- **Naming collision risk.** `out_of_scope` and `allowed_files` already exist in `harness/prep/session-mandate-template.md` but under *prose labels* ("Files that may be edited", "Out of scope" — template lines 14, 16-17), and that template states only "All five fields are parsed by `/session-start`" (line 7). The prep template and the full-harness mandate schema are two different mandate surfaces with different field counts (5 vs 8/11). Propagating the names into the canonical set without reconciling the two surfaces creates two systems that both define a field called `out_of_scope`/`allowed_files` with potentially different parse semantics — a functional overlap.
- **`prohibited_actions` semantics are undefined at the change site.** Unlike the existing 8 fields, which each have a one-line description in the SKILL.md table and Step-5 mechanical validation rules (lines 143-152), `prohibited_actions` is net-new and has no validation rule, no description, and no stated relationship to `stop_rule` or `out_of_scope`. The change introduces a new mandate contract that callers (the future governor, which reads `mandate.json` per SKILL.md line 286) must honor, but the contract is not yet documented anywhere on disk.

## Mitigations

- **Blast radius / Hidden coupling — make the Path C decision explicit and land it in the schema.** Before phase-2 edits, decide and document in `mandate-history-schema.md` Field Notes whether each of `prohibited_actions`, `out_of_scope`, `allowed_files` is a Path C promotion candidate. If not (recommended for `prohibited_actions` and `allowed_files`, which are safety/scope constraints the operator should restate per session, not silently auto-fill), exclude them from `resolved_fields` exactly as `trust_statement` is excluded, and add a one-line note mirroring SKILL.md line 228. This closes the silent `promotion-candidates-schema.md` line-57 coupling.
- **Blast radius — enumerate every edit site as a checklist in v3's deferred-phase spec.** The phase-2 work item in v3 must list all 5 SKILL.md sites (table lines 51-60, Step 7 lines 182-192, Step 8 lines 212-221, Step 9 count line 263, and the prose "eight canonical fields" line 49) plus `mandate-history-schema.md` (Shape block lines 18-27 and Field Notes lines 39-51) plus `promotion-candidates-schema.md` line 57. A site-by-site checklist prevents the internal-inconsistency failure mode where one enumeration site is missed.
- **Blast radius — fix v3's internal inconsistency before B1 is treated as specified.** v3 §6 Phase 2 item 1 (lines 256-257) still lists the old 9-field set and the referenced "Track B Amendment Record" section is absent from the file (ends at line 689). v3 must be updated so §6 Phase 2 names B1's three fields and the Amendment Record section actually exists, otherwise the deferred phase has no authoritative scope source to execute against.
- **Hidden coupling — define `prohibited_actions` semantics and a Step-5 validation rule at the change site.** Add a SKILL.md table description for `prohibited_actions` and a mechanical validation check in Step 5 (e.g., non-empty-if-present, list-shaped), and state its relationship to `stop_rule` and `out_of_scope` so the future governor has a documented contract to read.
- **Hidden coupling — reconcile the prep template vs canonical schema field names.** State explicitly in v3 (or the schema) that `out_of_scope`/`allowed_files` in `session-mandate-template.md` and in the canonical mandate set are the same field with the same parse semantics, or rename one surface. Two field definitions with the same name and divergent semantics is the overlap to eliminate.
- **Hidden coupling — make `fields_resolved` derivation explicit.** Either change SKILL.md Step 9 to state the count must equal the number of required fields in the §Required Mandate Fields table, or add a comment at line 263 recording the expected value, so the magic number does not silently drift on the next field add.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
