# Friday Act Plan — 2026-05-16 — nordic-pe-macro

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 4

## Items

### 1. [high] Resolve nordic-pe-macro-landscape-H1-2026 missing context/ directory
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** Context-health auditor flagged missing `context/` directory referenced by `produce-prose-draft.md` and `produce-architecture.md`. Missing files: `context/prose-quality-standards.md`, `context/content-architecture.md`, `context/project-brief.md`. Decision at execution time: (a) restore the files if prose production is still in scope, or (b) document in CLAUDE.md that `produce-prose-draft` and `produce-architecture` are retired. Operator must decide which path before implementing.

### 2. [high] Add model: opus and effort: high frontmatter to knowledge-file-producer SKILL.md
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** File: `projects/nordic-pe-macro-landscape-H1-2026/reference/skills/knowledge-file-producer/SKILL.md`. Add `model: opus` and `effort: high` to the YAML frontmatter block at the top of the file. Missing required fields per ai-resources skill format.

### 3. [high] Add CLAUDE.md note that pipeline commands use YAML frontmatter (not Usage: lines)
- **Source:** checkup
- **Risk-check required:** yes — change class: project CLAUDE.md
- **W2.4 auto-draft:** no
- **Detail:** File: `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`. Add a note (one or two lines) in an appropriate section documenting that project pipeline commands use YAML frontmatter headers instead of `Usage:` lines. This is a documented design decision, not a bug. Run `/risk-check` before editing.

### 4. [med] Run /improve against session-plan hook overwrite in nordic-pe-macro (3 deferred occurrences)
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** /coach flagged this as "The One Thing" for nordic-pe-macro. The session-plan hook overwrite has fired in 3 consecutive sessions and been deferred each time. Run `/improve` from the nordic-pe-macro project directory, targeting the session-plan hook overwrite friction pattern. Capture any resulting improvement-log entries.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For item 3 (CLAUDE.md edit), run `/risk-check` before executing.
- Item 1 requires an operator decision (restore vs. retire) before implementing — prompt at execution time.
- Run `/wrap-session` when all items in this plan are done.
