# AI Resource Creation Rules

> **When to read this file:** When a session identifies the need for a new or modified AI resource (skill, command, agent definition, workflow template), or when routing a skill request.

When a session identifies the need for a new or modified AI resource:

1. **Shared AI resources belong in `ai-resources/`.** Reusable skills, commands, and agent definitions — anything that could plausibly serve more than one project — belong in `ai-resources/`. Project workspaces consume shared resources via symlink or copy; they never own them. Project-specific *pipeline* commands and evaluator agents (e.g., pipeline commands tightly coupled to one project's workflow) are allowed to live locally in the project's own `.claude/` when they are tightly coupled to that project's pipeline and not intended for reuse.

2. **Do not improvise skill-like artifacts.** If the task calls for reusable procedural instructions, it's a skill — route it through the canonical pipeline.

3. **Capture the need, then route to the pipeline.** When working in a project and a skill gap surfaces, use `/request-skill` to write a structured brief to `ai-resources/inbox/`, then hand off to `/create-skill` in the same session. The `ai-resources/` directory is connected via `--add-dir` — no session switch needed.

4. **Always use the canonical pipelines:** `/create-skill` for new skills, `/improve-skill` for modifications, `/migrate-skill` for converting existing prompts. These pipelines include QC gates — skipping them means skipping quality assurance.

5. **Graduation requires confirmation from every existing canonical consumer.** Before graduating a project fork to canonical (i.e., extending the canonical contract with content that originated in one project), enumerate every existing canonical consumer (other projects that consume the resource via symlink or import) and confirm with the operator that each consumer is OK absorbing the change. Record the confirmation in the commit message. **Reason:** `principles.md § DR-7 — Generalize only when a second confirmed consumer exists`. The "one confirmed consumer + one non-consenting consumer about to absorb the result" pattern is the failure mode this rule prevents — project IP silently spreading into canonical and propagating to other projects without their review. Parameterizing the project-specific value through a project-config knob (so each consumer chooses its own value) is structurally cleaner than graduating the value itself; prefer that path when the value is the project-specific part.

## Bulk-backfill Exception

Rule #4 (canonical pipeline mandate) admits a narrow exception for one-time bulk frontmatter backfill operations: mechanical edits to many skills that change only frontmatter (no body changes), where running the full pipeline per skill would produce 50+ identical fix passes with no QC signal.

When invoking the exception:

1. **Document the exception** in the commit message (one line) and in `logs/improvement-log.md` (one entry naming the date, file count, and field(s) added).
2. **Substitute single-batch verification** for per-file post-edit QC. Run grep checks across the entire backfilled set to confirm: (a) every targeted file received the new field(s); (b) every value is within the allowed convention. Document the verification commands in the commit message.
3. **Limit scope.** The exception covers frontmatter-only edits with no body changes. Any edit that touches skill behavior (descriptions changed beyond formatting, body rewrites, structural reorganization) must use the canonical `/improve-skill` pipeline, not this exception.

Recorded invocations:

- **2026-04-28** — Bulk backfill of `model:` and `effort:` to all 69 existing skills (single mechanical 2-line insert per file). Verified via single-batch grep against required field presence and allowed values.
