# Friday Act Plan — 2026-07-03 — claude-md-template

**Source report:** friday-checkup-2026-07-03.md (quarterly tier)
**Journal report:** (none)
**Generated:** 2026-07-03
**Items:** 1

## Items

### 1. [med] Fix the systemic project-CLAUDE.md scaffold template (Input File Handling / Commit Rules / Session Boundaries / Compaction duplication); then trim the 6 existing project files
- **Source:** checkup
- **Risk-check required:** yes — change class: new-project scaffold template edit + 6 project CLAUDE.md edits
- **W2.4 auto-draft:** no
- Root cause (policy-level finding, same session): every audited project CLAUDE.md restates the same 4 workspace blocks — Input File Handling, Commit Rules, Session Boundaries, Compaction — each justified by a false "opened without parent context" rationale, even though these already load via ancestor-walk. This is one template/scaffolding defect, not 6 independent problems (~6,170 tokens/turn recoverable across the 6 projects). Fix the `/new-project` project-CLAUDE.md scaffold fragment (per `templates/README.md` consumer contract — edit the fragment, not the consuming command) so future projects don't inherit the duplication, THEN trim the 6 existing project CLAUDE.md files: axcion-copy-factory (277 lines, largest), interpersonal-communication (4 root blocks, ~45% of file), marketing-positioning, nordic-pe-screening-project, obsidian-pe-kb, project-planning. Per-project detail in `audits/claude-md-audit-2026-07-03-project-*.md`.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules) — likely: one commit for the template fragment fix, one commit per trimmed project (or a batched commit if all 6 are mechanical once the template is fixed).
- Risk-check required — this touches the canonical scaffold template consumed by every future `/new-project` run, plus always-loaded CLAUDE.md content in 6 live projects.
- Fix the template FIRST, then trim existing files against the corrected template — trimming first would leave a stale template that keeps re-introducing the duplication in new projects.
- Run `/wrap-session` when done.
