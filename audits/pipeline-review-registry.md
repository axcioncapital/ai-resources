# Pipeline Review Registry

> **Purpose:** Tracks the critical command pipelines reviewed by `/pipeline-review` and when each was last given the deep design treatment. Distinct from `critical-resources-manifest.md` (which feeds `/audit-critical-resources` for drift detection). Two parallel registries, two different jobs.

## Registry contract

- **Columns (5, fixed):** `Pipeline` (path, relative to `ai-resources/`) · `Type` (command / skill) · `Last reviewed` (`YYYY-MM-DD` or `never`) · `Last memo` (`YYYY-MM-DD` resolving to `audits/pipeline-reviews/{pipeline-slug}-{YYYY-MM-DD}.md`, or `—`) · `Friction flag` (Y / N).
- **Date-key, not path-key.** The `Last memo` column carries a date that the consumer resolves to a path via the convention above — per System Owner's `risk-topology.md § 1` warning about brittle two-end contracts.
- **Tiebreak rule:** When two or more rows share the same `Last reviewed` value (including the cold-start case where all are `never`), sort by `Pipeline` column alphabetically. Friction-flagged rows are promoted to the top regardless of date, and tiebreak alphabetically among themselves.
- **Audit-trail-grade writes.** This file is updated by `/pipeline-review` once per cycle after subagents return. The bumped row preserves the prior `Last reviewed` only via git history — manual reverts are not clean.
- **`Friction flag` is operator-manual at v1.** When a friction-log entry names a pipeline tracked here, set its `Friction flag` to `Y` manually. The flag remains `Y` until the next `/pipeline-review` cycle reviews that pipeline (the command resets it to `N` on bump). Friday-cadence reminder: scan recent friction-log additions during `/friday-checkup` and set flags for any newly-named pipelines. Automating this via a friction-log hook is deferred — re-evaluate if manual-set proves to drift silently.

## Pipelines

| Pipeline | Type | Last reviewed | Last memo | Friction flag |
|---|---|---|---|---|
| `.claude/commands/create-skill.md` | command | never | — | N |
| `.claude/commands/friday-checkup.md` | command | never | — | N |
| `.claude/commands/improve-skill.md` | command | never | — | N |
| `.claude/commands/new-project.md` | command | never | — | N |
| `.claude/commands/prime.md` | command | never | — | N |
| `.claude/commands/repo-dd.md` | command | never | — | N |
| `.claude/commands/resolve-repo-problem.md` | command | never | — | N |
| `.claude/commands/risk-check.md` | command | never | — | N |
| `.claude/commands/session-plan.md` | command | never | — | N |
| `.claude/commands/session-start.md` | command | never | — | N |
| `.claude/commands/wrap-session.md` | command | never | — | N |
| `skills/context-pack-builder/SKILL.md` | skill | never | — | N |
| `skills/implementation-project-planner/SKILL.md` | skill | never | — | N |
| `skills/implementation-spec-writer/SKILL.md` | skill | never | — | N |
