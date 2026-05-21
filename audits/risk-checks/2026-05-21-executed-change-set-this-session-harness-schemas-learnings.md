# Risk Check — 2026-05-21

## Change

Executed change set this session: (1) `harness/schemas/learnings-schema.md` — added `"none"` sentinel to `learning_type` enum (was 4 values, now 5) and `applicability` enum (was 2 values, now 3); replaced §Null-Rate Pattern line 48 with an explicit full null-entry object shape sentence stating all required fields and their values. (2) `.claude/skills/session-governor/SKILL.md` — replaced Edge Cases crash-recovery bullet (no longer unconditionally rolls back `in_progress` units); updated step 20 JSON example and prose to use `"none"` sentinels; added `judgment_call` payload note before step 22; rewrote A2 five-item list to match `current-state-schema.md` (tier-aware ordering folded into item 1; active hardenings restored as item 3). (3) `harness/reports/2026-05-21-session-governor-b1-unit-1-trace.md` — step 22 wording fix (dry trace qualification). All changes are QC-verified fixes to schema-conformance defects identified in an independent review.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/learnings-schema.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/reports/2026-05-21-session-governor-b1-unit-1-trace.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/schemas/current-state-schema.md` — exists

## Verdict

GO

**Summary:** A self-contained, QC-verified schema-conformance fix set confined to the harness build artifacts; every dimension is Low, with the only minor exposure being the append-only `learnings.json` log shape — but no production log entries exist yet, so even that carries no rollback cost.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the three edited files is an always-loaded file. `learnings-schema.md` and `current-state-schema.md` live under `harness/schemas/` — build-spec documents, not turn-loaded context. The trace report under `harness/reports/` is a generated artifact.
- `session-governor/SKILL.md` is a skill, loaded only when the governor skill is invoked (`description` at SKILL.md lines 3–9 scopes it to "Phase B (the Main Work Loop) of Agent Harness sessions" — a narrow, on-demand trigger, not a broad keyword match). Editing it adds no per-session or per-tool-call cost.
- No hook is registered, no `@import` added, no subagent brief expanded. The edits to SKILL.md are wording/example corrections within an existing file — the schema-conformance fix to step 20 and the A2 rewrite do not materially change the skill's loaded size (net effect is replacement, not addition of a new always-loaded block).
- Workspace CLAUDE.md gates harness-skill work behind `@.claude/references/harness-rules.md` ("Load … only when running a harness skill"), confirming this skill is not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` file is in the change set. `git status --short` on the three referenced paths returns empty (all committed in `1ec3576 fix: QC findings on Phase 3 B1 session-governor skeleton`); the working-tree diff (`git diff --stat HEAD`) shows only log files, none of them settings files.
- No `allow`/`ask` entry added, no `deny` rule removed or narrowed, no new tool-invocation pattern introduced. The edits are to markdown spec/skill/report files only.
- The governor SKILL.md describes git commit and filesystem operations (step 18 commit, step 9 `test -f`), but those invocation patterns are pre-existing in the prior committed version of the skill — the change set does not introduce them.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 3 (`learnings-schema.md`, `session-governor/SKILL.md`, the trace report).
- `learnings-schema.md` consumers — grep `learnings-schema` across `*.md/*.json/*.yaml`: 5 hits — `session-governor/SKILL.md` (edited in the same change set, so kept in sync), plus `logs/usage-log.md`, `logs/session-notes.md`, `logs/session-notes-archive-2026-04.md`, `logs/decisions.md` (all narrative log mentions, not contract consumers).
- `learning_type` / `applicability` enum consumers — grep across `*.md/*.json`: only `session-governor/SKILL.md` and `learnings-schema.md` itself. The skill was edited in the same change set to use the new `"none"` sentinels (SKILL.md step 20 JSON at lines 264–278 and prose at lines 280–289), so the contract producer and the schema are co-updated. No third-party consumer is left stale.
- Maturation-engine coupling check — `promotion-candidates-schema.md` references `learnings` only as a `source_file` provenance string (line 25: `"hardening-registry | learnings | operator-corrections | mandate-history"`); it does not consume the `learning_type` or `applicability` enum values. Adding `"none"` to those enums therefore does not break the maturation schema. `learnings-schema.md` §Field Notes line 39 states the maturation engine matches on `learning_type` + `judgment_made` — a `"none"`-typed null entry simply yields no Path-B match, which is the intended behavior for a no-finding entry.
- `current-state-schema.md` is referenced but, per the change description, only consulted to align the SKILL.md A2 list — the schema file itself is not edited (`git status` confirms it is clean). The A2 rewrite makes the skill conform to the existing schema; it is a contract-alignment, not a contract change.
- Enum widening is additive and backwards-compatible: existing 4-value `learning_type` and 2-value `applicability` entries remain valid; `"none"` is a new permitted value, not a redefinition.

### Dimension 4: Reversibility
**Risk:** Low

- All three files are committed in a single commit (`1ec3576`); `git revert 1ec3576` cleanly restores the prior state of all three within the same working tree. No sibling files or directories are created by this change set.
- `learnings.json` is an append-only log and `learnings-schema.md` defines its shape — but the schema is documentation, not data. No `learnings.json` entries have been produced: the governor is a B1 skeleton, the trace is explicitly a *dry trace* ("No runtime state is written into `harness/session/`", trace report lines 15–16 and §Why a dry trace lines 149–154). Reverting the schema therefore leaves no stale data entries to carry forward.
- The Edge Cases crash-recovery edit in SKILL.md changes documented behavior (the governor no longer unconditionally rolls back `in_progress` units, SKILL.md lines 419–424) but the skill is a skeleton that has not executed a live run — there is no persisted `current-state.json` runtime artifact whose behavior a revert would have to reconcile.
- No state pushed beyond the local repo by this change set; no automation (hook/cron/symlink) added.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The `"none"` sentinel is a new contract value, and it is documented at the change site: `learnings-schema.md` §Null-Rate Pattern line 48 explicitly states "`\"none\"` is the explicit sentinel for enum fields that have no value in a null entry" and enumerates the full null-entry object shape. The skill that produces the entry (`session-governor/SKILL.md` lines 280–289) cites `learnings-schema.md` §Null-Rate Pattern by name. Producer and schema both name the contract — no silent dependency.
- The A2 rewrite explicitly couples SKILL.md to `current-state-schema.md` §Execution Plan Persistence, and the coupling is named in the skill text (SKILL.md line 109: "five schema-defined components (`current-state-schema.md` §Execution Plan Persistence)"). This is a documented dependency on an established schema, not a hidden one.
- No auto-firing behavior: the skill runs only when explicitly invoked; no hook ordering or cross-session side effect is introduced.
- No functional overlap created — the change set narrows divergence (makes the skill conform to the schema), it does not add a second mechanism for the same concern.
- One minor judgment note: the crash-recovery bullet rewrite changes the SKILL.md's documented recovery behavior away from `current-state-schema.md` §Usage Notes line 58 ("On crash recovery, any unit not in `committed` rolls back to `pending`"). The skill's new Edge Cases text (lines 419–424) handles the mandate-parser "resume" path and explicitly says "Do not roll it back." This is a producer/spec divergence that the change set introduces in the skill but not in `current-state-schema.md`. It is not a hidden contract — both texts are visible — and the SKILL.md text is internally reasoned (it distinguishes operator-chosen resume from a crash), so it does not rise to a coupling defect. Flagged here for the operator's awareness: if `current-state-schema.md` §Usage Notes is meant to be the authority, that line and the skill should be reconciled in a later pass.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, git status/log output). No training-data fallback was used on fetch/read failures.
