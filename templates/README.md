# `templates/` — Canonical Project Scaffolding

Single source of truth for the canonical shape of a new Axcíon AI project's `.claude/settings.json` and `CLAUDE.md`. Consumed by `/new-project` at scaffold time; can be diff'd by audits to detect drift in existing projects.

## What's here

- `project-settings.json.template` — canonical `permissions` block + two `SessionStart` hooks (auto-sync + permission-sanity). Pure data; no template-time substitution. Hook commands resolve `$CLAUDE_PROJECT_DIR` at hook runtime.
- `project-claude-md.md` — the **entire** canonical project `CLAUDE.md`: a title heading and a description, nothing else. Contains two mustache-style placeholders, `{{NAME}}` and `{{PROJECT_DESCRIPTION}}`, resolved once at file creation. These intentionally use the same `{{...}}` syntax that research-workflow templates use for deploy-time placeholders (e.g. `{{WORKSPACE_ROOT}}`) and are intentionally DIFFERENT from the single-brace `{name}` / `{project-description}` tokens that the `/new-project` agent substitutes in bash source — separating the two syntaxes prevents agent global-substitution from corrupting the consumer's search strings.
- `incident-log-template.md` — **RETIRED LEGACY, no live writer.** Preserves the fillable shape used by the retired `/resolve-incident` command so historical records remain interpretable. Do not use it to create a new incident pipeline.
- `mission-contract.md` — canonical shape for a multi-session mission contract (mission-contract subsystem, added 2026-06-09). Consumed by `/mission create`, which substitutes the frontmatter (`mission_id` / `mission_name` / `status` / `started`) and writes the file to `<repo>/logs/missions/<id>.md`. Body sections (Goal / In-Out scope / Validation contract / Open threads) are authoring prompts the operator fills in. Frozen at creation; only `status` and `Open threads` mutate, via `/mission` only.
- `capability-record.md` — **RETIRED LEGACY, no live writer** (Work Loop v1 subsystem, added 2026-07-28; retired 2026-08-11). Canonical shape for one operating-capability development record. Its only writer was `/work-loop` (v1), deleted 2026-08-06; the v1 Codex controller skill was retired 2026-08-11. **Work Loop v2 does not produce capability records** and has no equivalent artifact — do not read this template as a v2 shape. It is kept for one reason: `/develop-ai-resource` Step 1.0 still *reads* a capability record when a brief claims upstream qualification, and needs the shape to verify that claim. Since no component emits such a brief today, that check exists to reject unproven claims, not to service a live producer. Method and process lived in `skills/capability-development/SKILL.md` and `docs/work-loop.md`, both now inert v1 method documents with unresolved ownership.

`project-claude-md.md` is the only CLAUDE.md template. `mission-contract.md` uses placeholders resolved at runtime by its consuming command; `incident-log-template.md` and `capability-record.md` preserve retired placeholder shapes with no live writer; `project-settings.json.template` carries none.

## What a project `CLAUDE.md` contains

Title, description, and **only** rules that are genuinely project-specific — a rule that applies to every turn in that project's sessions and can live nowhere else (the workspace `## CLAUDE.md Scoping` rule). A direct-route project additionally carries the line `**Execution route:** direct` immediately under the description.

**Workspace rules are never copied in.** Input-file handling, commit and push behaviour, compaction, session boundaries, QC discipline and model tiering are workspace-level; the workspace-root `CLAUDE.md` loads in every session, so a per-project restatement is duplication, not insurance. **No `## Model Selection` section** — model defaults are prohibited at every layer, and `/new-project` no longer scaffolds one.

Most new projects need no project-specific section at all. A file that is title plus description is a correct result.

## Consumer contract

Three live consumers, plus two retired:

1. **`/new-project`** (step 2 + step 4 + Direct Route step 3) — the original consumer; writes `settings.json` and the project `CLAUDE.md` when scaffolding a new project.
2. **`/deploy-workflow`** (step 4, sub-step `### Ensure permissions baseline in deployed settings.json`) — added 2026-05-25. Consumes `project-settings.json.template` only (not the CLAUDE.md skeleton), and only writes when the deployed project's `.permissions.allow` is empty. Note that the Research Workflow ships its **own** specialist project `CLAUDE.md` as `CLAUDE.md.template`, stored inside the workflow, not here — `/new-project` hands Research Workflow requests to `/deploy-workflow` at its Step 0.3a rather than scaffolding them.
3. **`/mission create`** (Step 2) — added 2026-06-09. Consumes `mission-contract.md` only. Reads the template, substitutes the four frontmatter fields, and writes the file to `<repo>/logs/missions/<id>.md`. Does not touch any project CLAUDE.md or settings.json.
4. **`/resolve-incident`** — added 2026-05-28, **retired 2026-08-15**. It was `incident-log-template.md`'s only writer. Codex `$diagnose-and-fix` reuses an existing repository-approved task or incident record when one exists and does not inherit this template or create a second issue lifecycle.
5. **`/work-loop`** (v1, capability units only) — added 2026-07-28, **retired 2026-08-11**. This was `capability-record.md`'s only writer. The command was deleted on 2026-08-06 and its Codex controller skill retired on 2026-08-11, so **`capability-record.md` now has no producer**. Work Loop v2 did not inherit this consumer role and writes no capability records. The template's only remaining reader is `/develop-ai-resource` Step 1.0, which verifies a record's shape when a brief claims upstream qualification.

All consumers:

1. Read the relevant template file(s).
2. Apply the merge/fill logic locally. Templates are read-only — do not mutate them in place.
3. For `settings.json`: the predicate "already has a non-empty `permissions.allow` array" still gates the merge (consumers 1 and 2 only).
4. For `CLAUDE.md`: **write-once.** The `[ ! -f ]` guard gates the whole write (consumer 1 only). An existing project `CLAUDE.md` is left byte-for-byte unchanged — never overwritten, never appended to, never backfilled.

When adding a sixth consumer, update this contract list and the `## What's here` description for the affected template file.

## 2026-04-13 decision — **SUPERSEDED 2026-07-27**

The 2026-04-13 "Commit Rules propagate by explicit copy" decision held that workspace-level CLAUDE.md inheritance into project sessions was unreliable, so each project CLAUDE.md had to mirror load-bearing workspace rules in short form. That produced five fragments here (`header.md`, `input-file-handling.md`, `commit-rules.md`, `compaction.md`, `session-boundaries.md`), reaffirmed as KEEP on 2026-05-25.

**Superseded 2026-07-27.** The premise was retired: the workspace-root `CLAUDE.md` does load in project sessions, so the mirrors were duplication rather than insurance — and duplication with a cost, since each copy drifts from its canonical source independently. The five fragments were deleted, the mirrored sections were removed from 26 project files, and this directory now holds one minimal skeleton.

The load-bearing assumption is recorded plainly because everything above rests on it: **the workspace-root `CLAUDE.md` loads in every session opened at `projects/<name>/`.** If that is ever found false, the removals are pure deletions and each is recoverable by `git revert` of its own commit. Re-check if Claude Code release notes announce a change to CLAUDE.md inheritance behaviour, or if the inheritance gap reappears in `coaching-data.md`.

## Out-of-scope follow-ups (flagged here so they don't get lost)

- **Five legacy `## Model Selection` sections** survive in `buy-side-service-plan`, `global-macro-analysis`, `nordic-pe-screening-project`, `obsidian-pe-kb` and `project-planning`. Advisory prose only; `/prime` tolerates both presence and absence. Left for a separate cleanup pass.
- **Audit diff:** an audit (e.g. `/audit-claude-md`) could flag project CLAUDE.md files that have re-accumulated workspace-rule mirrors. Not built here.
