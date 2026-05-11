# Risk Check — 2026-05-11

## Change

Proposed structural change: edit `projects/global-macro-analysis/CLAUDE.md` to apply HIGH+MEDIUM+3 LOW findings from `audits/working/audit-claude-md-global-macro-analysis-2026-05-11.md`. Specifically:

(1) HIGH — Delete the "Commit Rules" block (verbatim workspace duplicate per audit Tier 2 HIGH). Replace with one-line pointer: "Commit behavior: see workspace CLAUDE.md § File verification and git commits."

(2) MEDIUM — Trim Command Scope Table: drop `Reads` and `Writes` columns; keep `Command | Purpose` only. (Picked over the "Move to macro-kb/_meta/docs/command-scope.md + @-reference" alternative because the Purpose column is genuinely useful every turn; saves ~200 tokens.)

(3) MEDIUM — Trim Overview block from two multi-clause bullets to one line each; remove the "All data lives in macro-kb/" reiteration since "What This Is" already states this.

(4) LOW — Drop the final rationale sentence in Model Selection ("The 'supports judgment, never replaces it' principle in Hard Rule #6 maps to..."). Keep the operative rule in sentences 1–2.

(5) LOW — Drop or rephrase the stale Operational Notes bullet about bootstrap deprioritization (bootstrap phase is past peak per dd-extract; 23/43 themes populated).

(6) LOW — Consolidate `/kb-create-report` Phase-2 mention (currently appears in both Overview and Command Scope Table row); keep the Overview mention, shorten the table cell to "(Phase-2; spec only)".

Net effect: ~390 tokens saved per turn from always-loaded surface; one verbatim cross-file duplicate eliminated. No new files. No skill, command, agent, hook, permission, settings, or workflow changes. No semantic changes to active rules; the deletion of Commit Rules depends on workspace CLAUDE.md being loaded for project sessions (which it is — `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` is auto-loaded as the parent dir).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-claude-md-global-macro-analysis-2026-05-11.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists

## Verdict

GO

**Summary:** Pure prose cleanup of a single project CLAUDE.md, well-grounded in a prior audit, with no permission, contract, or behavior change; the one cross-file dependency (workspace CLAUDE.md auto-loaded as parent dir) is independently verifiable.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change is a net token *reduction* on an always-loaded surface, not an addition. Audit estimates ~390 tokens saved per turn (audit lines 102–109: "Per-turn savings: ~515 tokens"; the change description's six-item subset lands closer to ~390).
- No new always-loaded content added beyond a one-line pointer ("Commit behavior: see workspace CLAUDE.md § File verification and git commits.") replacing a ~150-token block (project CLAUDE.md lines 76–82) — net negative for that block alone.
- No new `@import`, hook registration, SessionStart wiring, subagent brief expansion, or skill trigger pattern. Six items are all in-place edits to one file (`projects/global-macro-analysis/CLAUDE.md`).
- No frequently-spawned subagent or pattern-matching skill description is touched.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to `.claude/settings.json`, `.claude/settings.local.json`, or any allow/ask/deny rule. Change description explicitly: "No skill, command, agent, hook, permission, settings, or workflow changes."
- No new tool invocation pattern introduced (no new Bash command, Write path, MCP server, or external API).
- Scope of the change is one Markdown file under `projects/global-macro-analysis/`.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct file count: 1 (`projects/global-macro-analysis/CLAUDE.md`).
- Grep for callers/references to this CLAUDE.md across the repo (`grep -r "projects/global-macro-analysis/CLAUDE.md"`): 14 hits, of which the load-bearing ones are:
  - `projects/global-macro-analysis/pipeline/implementation-spec.md:1751` — names "Section 2: Command Scope Table".
  - `projects/global-macro-analysis/macro-kb/_meta/docs/report-layer-spec.md:131, 134, 166` — names "Command Scope Table" and "Hard Rules" sections; line 166 cross-refs `../../CLAUDE.md` for `Command Scope Table, Hard Rules`.
  - `projects/global-macro-analysis/logs/session-notes-archive-2026-05.md:532, 545, 566` — historical session notes; archival, not load-bearing.
  - Other hits are unrelated audit/dd reports.
- Contract preservation: the change keeps the `## Command Scope Table` section heading (only its columns shrink), keeps `## Hard Rules` untouched, keeps the `Overview` and `What This Is` headings. So the three load-bearing cross-references (implementation-spec.md, report-layer-spec.md) remain valid by section name.
- The single in-file `Hard Rule #6` reference inside `Model Selection` is being dropped along with the rationale sentence — but Hard Rule #6 itself is not renumbered (Hard Rules block is `Keep` per audit line 95), so no other file's "Hard Rule #N" reference breaks.
- No subagent input schema, hook output shape, slash-command syntax, or frontmatter schema touched.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file Markdown edit. `git revert` of the commit fully restores prior text in one operation.
- No sibling files or directories created. No log file or registry mutated. No `settings.json` change.
- No state propagates beyond local repo on commit (push gated by operator). No external write (Notion, API POST, etc.).
- No new hook/cron/symlink registered that could fire between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The one implicit dependency — "workspace CLAUDE.md is auto-loaded for project sessions because the project sits under the workspace parent dir" — is directly verifiable: `projects/global-macro-analysis/` is under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/` (confirmed via filesystem inventory), and Claude Code's standard behavior is to load CLAUDE.md from parent directories. The audit itself documents this (audit line 55: "Workspace CLAUDE.md is loaded whenever a project session opens from a path under the workspace (every session, given the workspace IS the parent dir)").
- The replacement one-line pointer cites a section heading in workspace CLAUDE.md. Workspace CLAUDE.md line 141 confirms the section exists with the exact heading `## File verification and git commits`. The pointer in the change description names "§ File verification and git commits" — matches workspace heading exactly.
- The trimmed Command Scope Table preserves the section heading by which `report-layer-spec.md:166` and `implementation-spec.md:1751` cross-reference it; no callers are silently broken.
- Bootstrap rule deletion from `Operational Notes` does NOT remove the bootstrap mechanic from any command — confirmed via grep: `kb-synthesize.md`, `kb-audit.md`, `kb-reindex.md`, `kb-review.md`, and `synthesis-prompt.md` continue to handle `bootstrap: true` independently. The deleted line was descriptive surfacing, not operative.
- No new contract (parse marker, filename convention, YAML key, output format) introduced. No auto-firing in unexpected contexts.
- No functional overlap with existing mechanisms — change is pure subtraction plus one pointer line.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
