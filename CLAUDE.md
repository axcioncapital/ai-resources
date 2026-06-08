# Axcion AI Resource Repository

## What This Repo Contains

This repo stores AI resources — primarily skills (SKILL.md files under `skills/`), plus prompts, docs, templates, and audit/log artifacts. Non-obvious conventions:

- **Inbox flow:** resource briefs land in `inbox/` (created via `/request-skill` in project sessions, picked up by `/create-skill` here); fulfilled briefs move to `inbox/archive/` to clear the intake queue without losing the record.
- **`templates/`** holds canonical deployable fragments consumed at scaffold time (project settings + project CLAUDE.md sections) — edit the fragment, not the consuming command. See `templates/README.md` for the consumer contract.
- **`logs/`** includes the output-quality `defect-log.md` — see `docs/defect-to-fix-loop.md` for the rule/eval/example closure loop.
- **Session telemetry (`usage-log.md`)** is written by `/usage-analysis` into each *consuming project's* `logs/` directory — this repo does not host a canonical usage log.

These resources operate across a multi-tool ecosystem — not just Claude. Skills may reference GPT-5 (via API/CustomGPT), Perplexity (via API), Notion, and NotebookLM. Do not design resources that assume a single-tool environment.

## How I Work

I am Patrik, a non-developer. Explain technical details in plain language. Commit/push behavior: see `## Commit Rules` below.

## Skill Creation and Improvement

See `skills/ai-resource-builder/SKILL.md` for skill format, creation sequence, improvement sequence, and quality-check framework. `/create-skill` and `/improve-skill` read that SKILL.md at invocation.

## Model Selection

**Model defaults are prohibited** — never add a `"model"` field to any settings.json or declare a default model in any `CLAUDE.md`; per-command/agent/skill `model:` frontmatter is the only permitted tiering mechanism. Full rule and rationale: workspace `CLAUDE.md` → Model Tier.

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

- Commit messages: `new: skill-name — purpose` / `update: skill-name — what changed`; multi-file → `batch: description`
- Never force-push; default branch `main`
- Push is batched and gated — see `## Commit Rules` below

## Commit Rules

**Commit directly** (no permission ask; no pre-commit `git status`/`git diff` and no post-commit verification — the filesystem is the source of truth). **Do not push** — pushes are batched and gated to session wrap. Never commit secrets (`.env`, credentials, tokens). Remind the operator to run `/wrap-session` when work is complete.

Full commit/push behavior — including the wrap-time push confirmation prompt — is canonical in workspace `CLAUDE.md` → File verification and git commits.

## Compaction

When `/compact` fires, preserve:
- The active inbox brief path (if a skill-creation or resource-request session is underway).
- The current pipeline stage identifier (e.g., `/create-skill` Step 3, `/improve-skill` Step 5).
- Any pending subagent-output file paths the main session has not yet read.

Auto-compact defaults drop these by priority; name them explicitly so they survive.
