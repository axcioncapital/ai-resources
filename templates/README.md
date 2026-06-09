# `templates/` — Canonical Project Scaffolding

Single source of truth for the canonical shape of a new Axcíon AI project's `.claude/settings.json` and `CLAUDE.md`. Consumed by `/new-project` at scaffold time; can be diff'd by audits to detect drift in existing projects.

## What's here

- `project-settings.json.template` — canonical `permissions` block + two `SessionStart` hooks (auto-sync + permission-sanity). Pure data; no template-time substitution. Hook commands resolve `$CLAUDE_PROJECT_DIR` at hook runtime.
- `project-claude-md/header.md` — the project title + description block written only on fresh CLAUDE.md creation. Contains two mustache-style placeholders: `{{NAME}}` and `{{PROJECT_DESCRIPTION}}`. These intentionally use the same `{{...}}` syntax that research-workflow templates use for deploy-time placeholders (e.g., `{{WORKSPACE_ROOT}}`) and are intentionally DIFFERENT from the single-brace `{name}` / `{project-description}` tokens that the `/new-project` agent substitutes in bash source — separating the two syntaxes prevents agent global-substitution from corrupting the consumer's search strings.
- `project-claude-md/input-file-handling.md` — `## Input File Handling` canonical section.
- `project-claude-md/commit-rules.md` — `## Commit Rules` canonical section.
- `project-claude-md/compaction.md` — `## Compaction` canonical section.
- `project-claude-md/session-boundaries.md` — `## Session Boundaries` canonical section.
- `incident-log-template.md` — canonical fillable shape for a `/resolve-incident` per-incident record. Consumed by `/resolve-incident` (Step 5 — reads and fills pre-edit; Step 8 — writes filled record to `audits/incidents/`). Contains `{FIELD}` placeholders replaced at runtime by the command, not at scaffold time.
- `mission-contract.md` — canonical shape for a multi-session mission contract (mission-contract subsystem, added 2026-06-09). Consumed by `/mission create`, which substitutes the frontmatter (`mission_id` / `mission_name` / `status` / `started`) and writes the file to `<repo>/logs/missions/<id>.md`. Body sections (Goal / In-Out scope / Validation contract / Open threads) are authoring prompts the operator fills in. Frozen at creation; only `status` and `Open threads` mutate, via `/mission` only.

The four CLAUDE.md section fragments contain NO substitution tokens — they are constants. Only `header.md` contains `{name}` / `{project-description}`. `incident-log-template.md` and `mission-contract.md` use placeholders resolved at runtime by their consuming command.

## Consumer contract

Four consumers:

1. **`/new-project`** (step 2 + step 4) — the original consumer; writes both `settings.json` and the CLAUDE.md canonical sections when scaffolding a new project.
2. **`/deploy-workflow`** (step 4, sub-step `### Ensure permissions baseline in deployed settings.json`) — added 2026-05-25. Consumes `project-settings.json.template` only (not the CLAUDE.md fragments), and only writes when the deployed project's `.permissions.allow` is empty.
3. **`/resolve-incident`** (Step 5 + Step 8) — added 2026-05-28. Consumes `incident-log-template.md` only. Step 5 reads the template and fills all pre-edit fields; Step 8 writes the filled record as a new file under `audits/incidents/{DATE}-{SLUG}.md`. Does not write to any project CLAUDE.md or settings.json.
4. **`/mission create`** (Step 2) — added 2026-06-09. Consumes `mission-contract.md` only. Reads the template, substitutes the four frontmatter fields, and writes the file to `<repo>/logs/missions/<id>.md`. Does not touch any project CLAUDE.md or settings.json.

All consumers:

1. Read the relevant template file(s).
2. Apply the merge/fill logic locally. Templates are read-only — do not mutate them in place.
3. For `settings.json`: the predicate "already has a non-empty `permissions.allow` array" still gates the merge (consumers 1 and 2 only).
4. For CLAUDE.md: the per-section idempotency check (`grep -q '^## <heading>'`) still gates the append (consumer 1 only).

When adding a fifth consumer, update this contract list and the `## What's here` description for the affected template file.

## 2026-04-13 decision — verdict 2026-05-25: **KEEP**

The 2026-04-13 "Commit Rules propagate by explicit copy" decision held that workspace-level CLAUDE.md inheritance into project sessions was unreliable, so each project CLAUDE.md must mirror load-bearing workspace rules in short form. Re-checked 2026-05-25:

- No evidence that Claude Code's CLAUDE.md inheritance behavior has changed.
- The workaround is in active use but **unevenly applied** across existing projects (only `/new-project` writes these sections; once a project is scaffolded, newly-added canonical sections are not backfilled). Verdict-relevant only as supporting evidence — the architectural decision is correct; the propagation gap is a separate concern.
- The workspace `## CLAUDE.md Scoping` rule ("short pointer acceptable; verbatim duplication is not") is satisfied because the per-project sections are short-form mirrors, not verbatim copies of the workspace text.

**Verdict:** KEEP. Templates encode the canonical short-form mirrors so `/new-project` writes them consistently to every new project. Next re-check: revisit if Claude Code release notes announce a change to per-project CLAUDE.md inheritance behavior, or if the inheritance gap stops appearing in `coaching-data.md`.

## Out-of-scope follow-ups (flagged here so they don't get lost)

- **Backfill gap:** existing projects do not receive newly-canonized sections retroactively. A separate one-shot backfill command (or a `/friday-checkup` rule) could close this. Not addressed by this template extraction.
- **Audit diff:** an audit (e.g., `/audit-claude-md`) could diff each project's CLAUDE.md against these templates and flag missing canonical sections. Not built here.
