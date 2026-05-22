# Workspace Health Report

**Date:** 2026-05-22
**Mode:** Full Audit
**Target:** `projects/nordic-pe-macro-landscape-H1-2026`
**Overall:** GREEN

---

## Executive Summary

The Nordic PE Macro Landscape project is in strong health: all seven audit areas score GREEN, with zero Critical and zero Important findings. The most actionable item is low-severity bookkeeping — the `shared-manifest.json` auto-sync manifest is out of sync with the on-disk command set (lists a renamed command, omits a recently added one). Top recommendation: resync the manifest so auto-sync correctly tracks `project-status` and `produce-jargon-gloss`.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 1 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 1 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

No important findings.

### Improvement Opportunities

- **[Commands & Subagents] shared-manifest.json out of sync with on-disk command set**
  The auto-sync manifest at `.claude/shared-manifest.json` lists `status` in `commands.local`, but no `status.md` exists on disk; the actual file is `project-status.md` (a real project-specific command) which is not in the manifest. Separately, `produce-jargon-gloss.md` exists on disk as a real command (added in commit dd6f66c) but is not listed. The auto-sync hook ignores files not in the manifest, so these two commands are simply unmanaged by auto-sync — not a runtime failure, but a stale manifest that predates a rename and an addition.
  *Location:* `.claude/shared-manifest.json`
  *Recommendation:* Update `commands.local`: rename `status` to `project-status` and add `produce-jargon-gloss` so the manifest matches the on-disk command set.

- **[Skill Inventory] knowledge-file-producer is a project-local skill (not symlinked to ai-resources)**
  `reference/skills/` contains 68 symlinks into the canonical `ai-resources/skills/` library plus one real directory: `knowledge-file-producer/`, holding a valid `SKILL.md`. Its frontmatter is complete and valid (`name`, `description`, `model: opus`, `effort: high`; description carries both trigger and exclusion language). The skill lives only in project scope.
  *Location:* `reference/skills/knowledge-file-producer/SKILL.md`
  *Recommendation:* Confirm `knowledge-file-producer` is intentionally project-local. If it has cross-project value, graduate it to `ai-resources/skills/` via `/graduate-resource`.

- **[Settings & Permissions] Redundant permission entries in the allow list**
  `settings.json` `permissions.allow` contains `Bash(*)` alongside the narrower `Bash(rm *)`, and `Edit`/`Write` alongside `Edit(**/.claude/**)`/`Write(**/.claude/**)`. The broad patterns already cover the narrow ones. With `defaultMode: bypassPermissions` this has no functional effect — just noise.
  *Location:* `.claude/settings.json`
  *Recommendation:* Optionally trim the redundant narrow entries for cleanliness. No functional urgency.

- **[2026 Best Practices] Manifest drift is the only systemic signal — and it is isolated**
  Cross-referencing the five Wave 1 findings: the only systemic-looking signal is the manifest staleness above. `name_collisions_drift` is 0 and `intentional_overrides` is 2, so there is no auto-sync drift across command bodies. No other auditor reported a related issue, so this is not a compound problem.
  *Location:* `.claude/shared-manifest.json`
  *Recommendation:* Resync the manifest with the on-disk command set; treat manifest updates as part of the same change whenever a local command is added or renamed.

- **[Context Health] Recent high-impact changes: produce-jargon-gloss and produce-prose-draft commands**
  The last 10 commits show two high-impact command files changed in commit dd6f66c: `produce-jargon-gloss.md` (new) and `produce-prose-draft.md` (jargon-gloss Phase 4 added). Downstream tracing found all references intact — `produce-jargon-gloss` is referenced by `CLAUDE.md`, `reference/stage-instructions.md`, and three sibling produce-* commands; all skill references resolve. `produce-jargon-gloss` carries a documented dual-copy sync contract with its `ai-resources/workflows/research-workflow` companion.
  *Location:* `.claude/commands/produce-jargon-gloss.md`, `.claude/commands/produce-prose-draft.md`
  *Recommendation:* On the next edit to `produce-jargon-gloss.md`, diff against the ai-resources companion and propagate per the dual-copy contract. No fix needed now.

- **[File Organization] Workspace-root structure checks not applicable to a project directory**
  The file-org auditor's expected top-level structure describes the workspace root. The audit target is a project directory, which correctly has its own `CLAUDE.md`, `.claude/`, and project-specific stage directories. No expected-directory finding is raised because the workspace-root checklist does not apply at project scope.
  *Location:* `projects/nordic-pe-macro-landscape-H1-2026/`
  *Recommendation:* No action. Informational note for report readers.

## Detailed Analysis

### File Organization
File organization is healthy. All 148 symlinks (55 command symlinks, 25 agent symlinks, 68 skill symlinks into `ai-resources`) resolve to existing readable targets. The single project `CLAUDE.md` is correctly placed at the project root. `reference/skills/` holds 68 symlinks plus one real skill directory (`knowledge-file-producer`) containing a valid `SKILL.md`; no orphaned skill directories. Stage directories (preparation, execution, analysis, report, final) follow consistent project conventions. Metrics: 69 skill dirs, 148 symlinks, 0 broken, 1 CLAUDE.md.

### CLAUDE.md Health
The project `CLAUDE.md` is well within size limits at 72 lines / ~1,137 estimated tokens (200-line and 4,000-token thresholds not approached). It has a clear orientation section ("Project Context") and well-structured headings. No `@import`/`@file` references, so no dead-import risk. No hardcoded-secret patterns detected. No contradictions with workspace-level rules; the "Command Conventions" section explicitly aligns with the workspace Model Tier frontmatter rule.

### Skill Inventory
Skill inventory is healthy. 69 skills are reachable from the project: 68 symlinked from the canonical `ai-resources/skills/` library and 1 project-local (`knowledge-file-producer`). The only real `SKILL.md` present at project scope passes all frontmatter checks: `name`, `description`, `model: opus`, and `effort: high` are all present and valid, and the description carries both trigger and exclusion language. Symlinked skills are authored and maintained in `ai-resources` and are out of scope for project-level format re-validation. No orphaned skill directories. All 40 skill references from local command files resolve.

### Commands & Subagents
Commands and subagents are healthy. 76 registered command files (55 symlinks into `ai-resources`, 21 real project-local commands) and 29 agent files (25 symlinks, 4 real project-local agents: execution-agent, improvement-analyst, qc-gate, verification-agent — all carry name/description/tools/model). No dead command or agent symlinks; no dead skill or agent references. Two basename collisions (`session-plan.md`, `update-claude-md.md`) both differ in content from their ai-resources counterparts — intentional project-specific overrides, not drift (`name_collisions_drift` = 0, `intentional_overrides` = 2). Two `.md.bak` template archives are correctly named so they do not register as slash commands. Local commands declare tier via YAML frontmatter per the documented project convention; absence of a `Usage:` line is intentional and not flagged.

### Settings & Permissions
Settings and permissions are healthy. Both `settings.json` and `settings.local.json` parse as valid JSON. `settings.json` has a complete permissions object (17 allow, 8 deny) with `defaultMode: bypassPermissions`, consistent with the operator's zero-permission-prompt posture. All 24 hook definitions across PreToolUse, PostToolUse, SessionStart, Stop, and UserPromptSubmit reference valid hook types; every referenced hook script (13 in `.claude/hooks/`, `logs/scripts/check-archive.sh`, and 2 ai-resources auto-sync hooks) exists on disk and is executable. No model field is declared in either settings file, consistent with the workspace Model Tier rule. `settings.local.json` correctly carries only the `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` env var. One Minor note on redundant broad/narrow allow-list overlap.

### 2026 Best Practices
The project is in strong shape against 2026 Claude Code best practices. The `CLAUDE.md` is lean and defers detail to on-demand reference docs rather than being monolithic. Skills are consumed by symlink with no copy-drift, and command bodies show no auto-sync drift. Hooks automate mechanical checks and guardrails (bright-line edit gate, friction logging, auto-commit of pipeline artifacts, permission sanity, archive-size), not judgment calls. Model tiering is declared per-command and per-agent in frontmatter with no `settings.json` model default. Maturity signals: lean CLAUDE.md, symlink-based skill consumption, 24 automation hooks, an error-driven bright-line guardrail, documented dual-copy sync contracts, and session start/stop rituals. The only cross-cutting signal is an isolated, low-severity manifest-staleness gap.

### Context Health
Cross-reference integrity is intact. The project `CLAUDE.md` references `reference/` docs (stage-instructions, file-conventions, quality-standards, style-guide) that all exist. All 40 skill references from local command files resolve to existing skills, and the `knowledge-file-producer` command points at the project-local skill that exists. All 16 hook script references resolve to existing executable scripts. Pipeline stage commands (run-preparation through run-report) reference skills consistent with their declared use. Recent-change scan: two prose-stage commands changed in the last 10 commits; their downstream references all still resolve. Metrics: 41 skill refs checked, 0 dead; 40 command refs checked, 0 dead; 16 hook scripts checked, 0 missing; 2 recent high-impact changes.

## Prioritized Recommendations

1. **Resync `shared-manifest.json` with the on-disk command set** — Rename `status` to `project-status` and add `produce-jargon-gloss` so the auto-sync hook correctly tracks all local commands. Without it, two commands sit outside auto-sync management. Effort: Low. Area: Commands & Subagents / 2026 Best Practices.
2. **Confirm or graduate `knowledge-file-producer`** — Decide whether the one project-local skill is intentionally project-scoped or should be graduated to `ai-resources/skills/` via `/graduate-resource` for cross-project reuse. Effort: Low. Area: Skill Inventory.
3. **Trim redundant allow-list entries in `settings.json`** — Remove `Bash(rm *)`, `Edit(**/.claude/**)`, and `Write(**/.claude/**)` since the broad `Bash(*)`/`Edit`/`Write` patterns already cover them. Cosmetic cleanup only. Effort: Low. Area: Settings & Permissions.
4. **Spot-check the `produce-jargon-gloss` dual-copy sync contract on next edit** — When `produce-jargon-gloss.md` is next modified, diff against the `ai-resources/workflows/research-workflow` companion and propagate. Effort: Low. Area: Context Health.
5. **No structural action required** — All seven areas are GREEN with zero Critical/Important findings; the project's infrastructure (symlinked skills, hook automation, model tiering, lean CLAUDE.md) is sound. Maintain current discipline. Effort: Low. Area: All.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped. Deviation note: the Agent/Task tool was unavailable in this environment, so the lead agent executed each of the 7 auditors' checklists directly and inline, applying each auditor's procedure, scoring rubric, and false-positive screening as written. Findings files were written to `reports/.audit-temp/` and synthesized per the standard procedure.*
