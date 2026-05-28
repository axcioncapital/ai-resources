# Operational Frontmatter Fields

In addition to `name` and `description`, every skill must declare two operational fields: `model:` and `effort:`. The remaining operational fields are optional but should be actively considered for each skill rather than skipped by default.

## Required: model and effort

Every skill must declare both `model:` and `effort:` in frontmatter. The Claude Code harness honors both — when the skill is invoked, the harness swaps to the declared model and effort for the rest of the turn, then reverts on the next user prompt. Without an explicit declaration, skills inherit the session model, so an Opus-tier judgment skill can silently run on Sonnet (the project default in `ai-resources`) and underperform.

### Canonical Mapping

| Work type | `model:` | `effort:` | Examples |
|---|---|---|---|
| **Judgment** — deciding what should be done; ambiguity-heavy synthesis, design, prose review, triage | `opus` | `high` | `refinement-deep`, `pipeline-review`, `triage`, `coach`, `summary` |
| **Structured / execution** — doing what's been decided; repeatable factual workflows, scaffolding, orchestration | `sonnet` | `medium` | `wrap-session`, `prime`, `handoff`, `friction-log`, `request-skill` |
| **Mechanical** — counts, format checks, log appends, pattern matching | `haiku` | `low` | `note`, `resolve-improvement-log` |

### Decision Heuristic

*"Is the hard part deciding, or doing?"*

- **Deciding** (under ambiguity, with judgment) → `opus` + `high`
- **Doing** (executing a defined process) → `sonnet` + `medium`
- **Mechanical** (counting, matching, appending) → `haiku` + `low`

### Format

Use the short form (`opus` / `sonnet` / `haiku`) and the 3-tier effort scale (`low` / `medium` / `high`) — matches the existing convention in `.claude/commands/*.md` and `.claude/agents/*.md`. Do not use `xhigh` or `max` (outside the current convention).

Example skill frontmatter:

```yaml
---
name: refinement-deep
description: Run a deep review of the work you just produced...
model: opus
effort: high
---
```

## Optional Fields — Two Design Questions

Answer these for every skill before choosing fields:

1. **"Who should decide when this runs?"** -> `disable-model-invocation` or default (Claude decides)
2. **"What should this skill be able to do?"** -> `allowed-tools` or unrestricted

## Field Reference

| Field | Purpose | When to Use |
|-------|---------|-------------|
| `allowed-tools` | Restricts which tools Claude can use while skill is active | Read-only skills: `Read, Grep, Glob`. Deployment skills: `Bash`. Security-sensitive operations. |
| `disable-model-invocation: true` | Only user can invoke via `/skill-name` | Skills with side effects: deployments, commits, outbound messages. Has known bugs with `--resume` and plugin skills — test behavior. |
| `user-invocable: false` | Only Claude can invoke | Background knowledge that isn't actionable as a command. |
| `paths` | Glob patterns restricting when skill activates based on files being worked with | Scope skills to relevant directories. Critical at 100+ skills: skills without `paths` burn context on every session whether needed or not. Use `paths: ["research/**"]` to limit research skills to research directories. |
| `context: fork` | Runs skill in isolated subagent | Skills that do extensive exploration or produce large intermediate output. Keeps main conversation clean. Fork when the skill does heavy file reading; keep inline when the skill needs conversation context. |
| `agent` | Specifies subagent type (Explore, Plan, general-purpose, custom) | Paired with `context: fork`. Use Explore for read-only codebase research, Plan for architecture work. |
| `effort` | **REQUIRED** — see "Required: model and effort" above | Use `low` / `medium` / `high` per the canonical mapping. Do not use `xhigh` or `max` in this repo. |
| `depends-on` | References other skills for composition | When skill wraps or extends another skill's functionality. Enables skill chains. |
| `model` | **REQUIRED** — see "Required: model and effort" above | Use `opus` / `sonnet` / `haiku` per the canonical mapping. |
| `hooks` | Hooks scoped to this skill's lifecycle | Deterministic checks that should run when this specific skill is active. |
| `mode: true` | Marks as a mode command | Skills that modify Claude's behavior (debug-mode, review-mode). Appears in special section at top of skills list. |
| `$ARGUMENTS` / `$ARGUMENTS[N]` | Dynamic parameter substitution | Parameterized skills where input varies per invocation. |
| `!`command`` | Shell command preprocessing | Inject dynamic context (git diff, PR details, env info) before Claude sees the prompt. |
| `argument-hint` | Hints shown during autocomplete | Manually-invoked workflow skills where the user needs to know what arguments to pass. |
| `license` | License type | Open-source skills: MIT, Apache-2.0. |
| `compatibility` | Environment requirements | When skill needs specific tools, network access, or platform features. Note portability constraints here. |
| `metadata` | Custom key-value pairs | Author, version, mcp-server, tags. |

## Common Configurations

**Read-only analysis skill:**
```yaml
allowed-tools: Read, Grep, Glob
context: fork
agent: Explore
effort: high
```

**Deployment skill with side effects:**
```yaml
disable-model-invocation: true
allowed-tools: Bash, Read, Glob
```

**Scoped research skill:**
```yaml
paths: ["research/**", "analysis/**"]
context: fork
agent: Explore
```

## Scale Management

With 100+ skills, context budget pressure becomes real:

- **Run `/context` periodically** and look for truncation warnings like `<!-- Showing 42 of 63 skills -->`. If skills are being hidden, shorten descriptions or increase `SLASH_COMMAND_TOOL_CHAR_BUDGET`.
- **Use `paths` aggressively** to conditionally load skills only when relevant files are in scope.
- **Retire dead skills.** Skills that haven't triggered in weeks consume description budget and risk false triggers.
- **Watch for conflicts.** Two skills with similar descriptions confuse Claude's selection. Add negative triggers to both when domains overlap.
- **CLAUDE.md interaction.** CLAUDE.md is loaded even when skills run in a forked subagent context. Don't duplicate CLAUDE.md guidance inside skills.

## Description Field Examples

Good description:
> Creates, evaluates, and improves AI resources (skills, prompts, project instructions). Use when building new skills, reviewing resource quality, or applying feedback to existing resources. Do NOT use for workflow design or non-AI documents.

Bad description:
> A helpful tool for working with various types of AI resources including but not limited to skills and prompts.
