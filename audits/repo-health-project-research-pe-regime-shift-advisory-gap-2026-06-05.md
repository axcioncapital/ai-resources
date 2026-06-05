# Workspace Health Report
**Date:** 2026-06-05
**Mode:** Full Audit
**Overall:** YELLOW

## Executive Summary
This project is structurally healthy: zero broken symlinks across 191 links, a lean and well-formed CLAUDE.md, valid settings with all hook scripts present, and intact cross-references throughout. The single actionable issue is two project-local skills (`knowledge-file-producer`, `report-compliance-qc`) missing `model:`/`effort:` tier frontmatter — fix those and the project clears to GREEN. All remaining findings are Minor stylistic or informational notes requiring no action.

## Scores
| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 2 | 0 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 1 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)
None.

### Important (Fix Soon)
- **[Skill Inventory] Local skill knowledge-file-producer missing model: and effort: frontmatter**
  `reference/skills/knowledge-file-producer/SKILL.md` (a project-local real file, not a symlink) has `name` and `description` but no `model:` or `effort:` field. Without `model:` the skill inherits the session model instead of declaring its tier; without `effort:` the effort budget is undefined. The skill is judgment-heavy, so canonical tiering is `model: opus` / `effort: high`.
  *Location:* `reference/skills/knowledge-file-producer/SKILL.md`
  *Recommendation:* Add `model: opus` and `effort: high` to the frontmatter.
- **[Skill Inventory] Local skill report-compliance-qc missing model: and effort: frontmatter**
  `reference/skills/report-compliance-qc/SKILL.md` (a project-local real file) has `name` and `description` but no `model:`/`effort:` field. It is a structured PASS/FAIL compliance check; canonical tiering is `model: sonnet` / `effort: medium` (or opus/high if judgment-weighted).
  *Location:* `reference/skills/report-compliance-qc/SKILL.md`
  *Recommendation:* Add an explicit `model:`/`effort:` pair to the frontmatter.

### Improvement Opportunities
- **[File Organization] Non-standard project layout vs. workspace-root auditor spec**
  The auditor spec targets a workspace root; TARGET is a single research project using the standard Axcíon project shape — skills under `reference/skills/` (78 symlinks into `ai-resources/skills/`), commands/agents under `.claude/` (mostly symlinks). Checks were adapted accordingly. No structural problem.
  *Location:* `projects/research-pe-regime-shift-advisory-gap/`
  *Recommendation:* No action.
- **[Commands & Subagents] Project pipeline commands use frontmatter convention, not a Usage: line**
  The 20 project-local command files open with YAML frontmatter plus a one-line purpose statement rather than the `Usage: /command ...` convention. Consistent project style, reported once in aggregate.
  *Location:* `.claude/commands/` (project-local files)
  *Recommendation:* Optional — add `Usage:` lines for convention parity. Low value.
- **[Settings & Permissions] Hardcoded absolute path in additionalDirectories**
  `permissions.additionalDirectories` contains the absolute parent-workspace path (which symlinked resources resolve into). Target exists; fragile only if the workspace moves. Standard project shape.
  *Location:* `.claude/settings.json (permissions.additionalDirectories)`
  *Recommendation:* No action; update the path if the workspace is relocated.
- **[2026 Best Practices] Two project-local skills lack explicit tier frontmatter (cross-section)**
  Cross-section view of the Skill Inventory finding: the gap is isolated to 2 local skills, not systemic — every project-local command and agent declares an explicit `model:` tier.
  *Location:* `reference/skills/knowledge-file-producer/SKILL.md, reference/skills/report-compliance-qc/SKILL.md`
  *Recommendation:* Add `model:`/`effort:` to the two local SKILL.md files.
- **[Context Health] Recent commits are report-content only — no high-impact infra changes**
  Last 10 commits are report-chapter and log writes (Stage 4 Part 9 / Section 1.1). No CLAUDE.md, settings, SKILL.md, agent, or command changes — minimal harness-drift risk.
  *Location:* `git log (last 10 commits)`
  *Recommendation:* No action; informational.

## Detailed Analysis

### File Organization
File organization is healthy. All 191 symlinks (78 skills under `reference/skills/`, ~68 commands, ~25 agents) resolve to existing targets — zero broken. All skill folder names are lowercase kebab-case, and every symlinked skill resolves to a directory containing `SKILL.md`. Single CLAUDE.md at project root, correctly placed.
- total_skill_dirs: 78 | total_symlinks: 191 | broken_symlinks: 0 | claude_md_files: 1

### CLAUDE.md Health
The single project CLAUDE.md is 149 lines (~2,599 tokens), comfortably under the 200-line / 4,000-token Important threshold. Clear headings and a strong orientation section (Project Context / What). No @imports, so no dead-reference or aggregate-size risk. No secrets patterns detected.
- total_claude_md_files: 1 | CLAUDE.md: 149 lines, ~2,599 tokens, 0 imports, 0 dead imports

### Skill Inventory
78 skills under `reference/skills/`; 76 are symlinks into the canonical `ai-resources` library and 2 are project-local real files (`knowledge-file-producer`, `report-compliance-qc`). All resolve to a `SKILL.md`. Both local skills validate name/description and carry triggers and exclusions, and both are under 300 body lines (123 and 102), but neither declares `model:`/`effort:` frontmatter — the only Important findings. Symlinked skills are governed by the canonical library and were not re-audited for tier frontmatter here. Trigger-overlap analysis was not run across the symlinked set (canonical library is the owner).
- total_skills: 78 | skills_over_300_lines: 0 | skills_over_500_lines: 0 | orphaned_skills: 0 | skills_missing_tier_frontmatter: 2

### Commands & Subagents
88 command files (68 symlinks into the shared library, 20 project-local real files) and 29 agent definitions (25 symlinks, 4 project-local). Zero broken command or agent symlinks. The 20 project-local commands are genuinely project-specific (no byte-identical match in `ai-resources`, so no auto-sync drift). The 4 project-local agents (improvement-analyst, qc-gate, verification-agent, execution-agent) all carry complete name/description/tools/model frontmatter. Only finding is a Minor note on the Usage:-line convention.
- total_commands: 88 | total_agents: 29 | command_symlinks: 68 | agent_symlinks: 25 | dead_references: 0 | name_collisions_drift: 0 | intentional_overrides: 0

### Settings & Permissions
Single settings.json, well-formed, with a complete permissions object (17 allow, 7 deny) and `defaultMode: bypassPermissions`. All non-inline hook scripts (friction-log-auto.sh, log-write-activity.sh, detect-innovation.sh) exist and are executable, and the SessionStart-referenced `logs/scripts/check-archive.sh` is present. No `model` field (compliant with the no-model-in-settings rule). Deny entries are generic glob patterns; no stale path references. Only a Minor note on the hardcoded `additionalDirectories` absolute path.
- total_settings_files: 1 | valid_json: true | allow_count: 17 | deny_count: 7 | hooks_count: 6 | stale_entries: 0

### 2026 Best Practices
The project follows 2026 best practices well. CLAUDE.md is lean (149 lines) so the absence of @imports is appropriate, not a gap. Subagent isolation, context isolation, and filesystem-first verification patterns are present. Strong maturity signals: explicit model tiering on commands/agents, an extensive session-ritual hook suite, error-driven CLAUDE.md evolution, and a clean shared-vs-local resource manifest. Only cross-section issue is the two local skills missing tier frontmatter — narrow, not systemic.
- command_count: 88 | skill_count: 78 | agent_count: 29 | subagent_isolation_compliant: true | context_isolation_compliant: true | filesystem_verification_compliant: true

### Context Health
Cross-reference integrity is intact. All 8 skill names referenced in CLAUDE.md (including the 4-skill dependency chain) resolve to existing SKILL.md files, and both command-to-skill references (produce-knowledge-file → knowledge-file-producer, run-report → report-compliance-qc) resolve. All 4 hook-referenced scripts exist and are executable. No dead references, no description mismatches. Recent commit activity is report-content only, so harness-layer drift risk is minimal.
- skill_references_checked: 8 | dead_references_found: 0 | command_references_checked: 2 | command_dead_references: 0 | hook_scripts_checked: 4 | hook_scripts_missing: 0 | recent_high_impact_changes: 0

## Prioritized Recommendations
1. **Add `model: opus` / `effort: high` to `knowledge-file-producer/SKILL.md`** — closes one of the two Important findings; the skill is judgment-heavy and should not inherit the session model.
2. **Add an explicit `model:`/`effort:` pair to `report-compliance-qc/SKILL.md`** — closes the second Important finding; `model: sonnet` / `effort: medium` fits a structured PASS/FAIL QC skill. Completing items 1–2 clears the project to GREEN.
3. **(Optional) Standardize project command headers** — add a `Usage:` line to the 20 project-local commands for convention parity. Low value; current frontmatter form is self-documenting.
4. **(Watch) `additionalDirectories` absolute path** — no action now; revisit only if the workspace is relocated.
5. **(No action) Maintain current cross-reference hygiene** — zero broken references across symlinks, hooks, and command/skill links; preserve this on the next infra change by re-running the audit after any CLAUDE.md / settings / skill edits.

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
