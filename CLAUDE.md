# Axcion AI Resource Repository

## What This Repo Contains

This repo stores AI resources — primarily skills (SKILL.md files), plus occasional prompts and project instructions. Each skill lives in its own folder under `skills/`. Resource briefs from project workspaces land in `inbox/` — these are requests for new skills, created via `/request-skill` in project sessions and picked up by `/create-skill` here. Fulfilled briefs are moved to `inbox/archive/` (preserves the brief as a record without leaving it in the active intake queue).

Other directories:
- `prompts/` — Standalone prompts for cross-tool workflows (e.g., supplementary research prompts consumed by GPT-5)
- `reports/` — Generated audit and health reports
- `logs/` — Session notes, decisions, innovation registry, and the output-quality `defect-log.md` (see `docs/defect-to-fix-loop.md` for the rule/eval/example closure loop)
- `audits/` — Due diligence and audit artifacts
- `docs/` — Process documentation (session rituals, etc.)
- `scripts/` — Utility scripts for repo maintenance
- `style-references/` — Style reference materials consumed by formatting and prose-compliance skills
- `templates/` — Canonical deployable fragments consumed at scaffold time (project settings + project CLAUDE.md sections); edit the fragment, not the consuming command. See `templates/README.md` for the consumer contract.

Session telemetry (`usage-log.md`) is written by `/usage-analysis` into each consuming project's `logs/` directory (alongside `decisions.md`, `friction-log.md`, etc.) — this repo itself does not host a canonical usage log.

These resources operate across a multi-tool ecosystem — not just Claude. Skills may reference or interact with GPT-5 (via API/CustomGPT), Perplexity (via API), Notion, and NotebookLM. Do not design resources that assume a single-tool environment.

## How I Work

I am Patrik, a non-developer. Explain technical details in plain language. Commits proceed directly per `## Commit Rules` below. Pushes are gated — batched until session end, with a single operator confirmation prompt before pushing.

## Skill Creation and Improvement

See `skills/ai-resource-builder/SKILL.md` for skill format, creation sequence, improvement sequence, and quality-check framework. `/create-skill` and `/improve-skill` read that SKILL.md at invocation.

## Model Selection

**Model defaults are prohibited.** Never add a `"model"` field to any `.claude/settings.json` or `.claude/settings.local.json`, and never declare a default model in any `CLAUDE.md`. The operator selects the session model via `/model`; settings/CLAUDE.md defaults block in-session model switches. See workspace `CLAUDE.md` → Model Tier for the full rule. Per-command, per-agent, and per-skill `model:` frontmatter (in slash-command files, agent definitions, and `SKILL.md` files) is the only permitted way to assert a tier outside the live session — see Agent Tier Table for agents.

## Subagent Contracts

Subagents that read, scan, or audit across many files must write full notes to disk and return only a short summary to the main session.

- **Summary cap:** 30 lines. Tighter cap (20 lines) when per-unit invocations proliferate (one subagent per workflow, per chapter, per file). The cap is enforced in the agent's own body, not the orchestrator — each agent knows its own output shape.
- **Notes to disk:** full findings go to a working-notes file under the invoking command's working directory (e.g., `audits/working/...`). Summary returned to main session includes the path.
- **Main-session reads summary only.** Do not re-read the full notes unless the summary flags a specific finding that requires context.

Existing implementations: `token-audit-auditor`, `token-audit-auditor-mechanical`, `repo-dd-auditor`. New audit/scan subagents follow the same contract.

## Session Telemetry

Run `/usage-analysis` at the end of every substantive session. Output goes to `logs/usage-log.md` and is the baseline that future token audits measure against — without the data, a token audit can't tell whether past efficiency optimizations actually moved the needle.

`/wrap-session` prompts for this automatically. If the session was trivial (single-file edit, one-question read), dismiss with one letter; don't skip by default.

## Maintenance Cadence

Run `/friday-checkup` each Friday before starting next week's work. Auto-detects tier (weekly / monthly / quarterly), asks which projects are active, runs the tier's audits across `ai-resources/`, workspace root, and named projects, and writes a consolidated review-only report to `ai-resources/audits/friday-checkup-YYYY-MM-DD.md`. Full mechanics: `.claude/commands/friday-checkup.md`.

Run `/pipeline-review` once per week to give 1–3 critical pipelines a deep System-Owner-grounded design review (innovations, leanness, brokenness, cross-resource interactions, currency-check against pinned Anthropic doc URLs). Memo only — fixes happen in a separate session. Registry: `audits/pipeline-review-registry.md`. Distinct from `/friday-checkup` (housekeeping).

## Permission Management

Claude Code permission prompts (Edit / Write / Delete) are managed structurally, not reactively. Canonical shapes for all settings layers (user / workspace / ai-resources / project) live in `docs/permission-template.md`. The `/permission-sweep` command diagnoses and remediates drift across all layers in one approved pass; `/new-project` emits the canonical project template for every new project; the `check-permission-sanity.sh` SessionStart hook nudges on drift. Pairs with `/fewer-permission-prompts` (which handles empirical, transcript-driven gaps).

## General Session Rules

- Do not create files or resources that weren't explicitly requested. Suggest additions in chat instead.
- Complete the requested task before proposing extensions or improvements.
- Pull the latest from GitHub at the start of each session.

## Git Rules

- Use descriptive commit messages: `new: skill-name — purpose` or `update: skill-name — what changed`
- Multi-file changes: `batch: description`
- Never force-push
- After committing, do NOT push — pushes are batched and gated; see `## Commit Rules` below for the full rule. Remind Patrik to wrap the session (`/wrap-session`) if the work is complete.
- Default branch: main

## Commit Rules

**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

**Do NOT push after committing.** Pushes are batched until session end. At wrap (`/wrap-session`, or an explicit operator signal like "we're done" / "ship it"), ask the operator with a single confirmation:

> Ready to push N commits across M repos: [list]. Push now? y/n

On `y`: run `git push` per repo; surface any failure (auth, network, non-fast-forward) and stop. On `n`: leave commits unpushed and note it in chat. No mid-session pushes, even for "critical" fixes — surface the situation and ask the operator instead.

Remind the operator to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

This rule mirrors the canonical `Commit behavior` and `Push behavior` sections in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.

## Compaction

When `/compact` fires, preserve:
- The active inbox brief path (if a skill-creation or resource-request session is underway).
- The current pipeline stage identifier (e.g., `/create-skill` Step 3, `/improve-skill` Step 5).
- Any pending subagent-output file paths the main session has not yet read.

Auto-compact defaults drop these by priority; name them explicitly so they survive.

## Session Boundaries

Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`.
