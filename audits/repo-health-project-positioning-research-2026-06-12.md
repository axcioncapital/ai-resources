# Workspace Health Report

**Date:** 2026-06-12
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The positioning-research project is in good structural health: zero broken symlinks across 188 links, valid settings JSON with all hook scripts present and executable, a lean compliant CLAUDE.md, and strong 2026 best-practice adoption (filesystem-first verification, QC subagent isolation, hook-delegated mechanical checks). The only items needing action are two Important findings — both project-owned skills (`knowledge-file-producer`, `report-compliance-qc`) omit the required `model:`/`effort:` tier frontmatter. The #1 thing to fix: add explicit tier frontmatter to those two SKILL.md files in a single edit pass. Two Minor command-drift copies (`refinement-pass.md`, `update-claude-md.md`) should be reconverted to symlinks.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 2 | 0 |
| Commands & Subagents | YELLOW | 0 | 0 | 2 |
| Settings & Permissions | GREEN | 0 | 0 | 0 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

- **[Skill Inventory] knowledge-file-producer SKILL.md missing model: and effort: frontmatter**
  Frontmatter declares name and description only. Per the tier-frontmatter check, `model:` (opus|sonnet|haiku) and `effort:` (high|medium|low) are both required. Without them the skill inherits the session model instead of declaring its own tier, and the harness cannot apply a skill-level effort budget. This is a judgment-heavy condensation skill, so the canonical pairing is `model: opus` / `effort: high`.
  *Location:* `reference/skills/knowledge-file-producer/SKILL.md`
  *Recommendation:* Add `model: opus` and `effort: high` to the frontmatter (edit in ai-resources if this skill is shared; it is currently a project-local real directory).

- **[Skill Inventory] report-compliance-qc SKILL.md missing model: and effort: frontmatter**
  Frontmatter declares name and description only; `model:` and `effort:` are absent. This is a structured-execution QC skill producing PASS/FAIL with per-finding severity, so the canonical pairing is `model: sonnet` / `effort: medium`.
  *Location:* `reference/skills/report-compliance-qc/SKILL.md`
  *Recommendation:* Add `model: sonnet` and `effort: medium` to the frontmatter.

### Improvement Opportunities

- **[Commands & Subagents] refinement-pass.md is a real file byte-identical to the ai-resources source (auto-sync drift)**
  Project file `.claude/commands/refinement-pass.md` is a regular file (not a symlink) and is byte-identical to `../../ai-resources/.claude/commands/refinement-pass.md`. This is unwanted drift: the project should reference the canonical command via symlink, and the copy was likely left behind before auto-sync-shared.sh managed shared commands.
  *Location:* `.claude/commands/refinement-pass.md`
  *Recommendation:* Replace with a symlink to the ai-resources source (matching the 70+ other command symlinks), or register it in shared-manifest.json.

- **[Commands & Subagents] update-claude-md.md is a real file byte-identical to the ai-resources source (auto-sync drift)**
  Project file `.claude/commands/update-claude-md.md` is a regular file (not a symlink) and is byte-identical to `../../ai-resources/.claude/commands/update-claude-md.md`. Same drift pattern as refinement-pass.md.
  *Location:* `.claude/commands/update-claude-md.md`
  *Recommendation:* Replace with a symlink to the ai-resources source, or register it in shared-manifest.json.

- **[2026 Best Practices] Compound tier-frontmatter gap on the two project-owned skills**
  Both project-real skills omit `model:`/`effort:` frontmatter. The 70+ symlinked skills inherit canonical ai-resources frontmatter, so the gap is isolated to the two locally-owned skills rather than systemic. Worth fixing in one pass to bring project-owned resources up to the explicit-tier standard.
  *Location:* `reference/skills/knowledge-file-producer/SKILL.md, reference/skills/report-compliance-qc/SKILL.md`
  *Recommendation:* Add explicit `model:`/`effort:` pairs to both skills in a single edit pass.

- **[Context Health] Recent high-impact changes concentrated in shared-resource sync and report-workflow templates**
  Last 10 commits touched concurrent-session hook dedup (P2), C5 skill+6-mirror lockstep landing, and RW template fixes (C2/C3/C6). After the C5 lockstep landing, spot-check that the project-local mirror of the affected skill matches the ai-resources canonical source. The SessionStart hook dedup leaves a single concurrent-session firing (confirmed, no duplicate).
  *Location:* `.claude/settings.json, reference/skills/`
  *Recommendation:* Spot-check the C5 skill mirror against ai-resources; no action required for the hook dedup.

## Detailed Analysis

### File Organization
Project file organization is clean. All 188 symlinks (76 skill symlinks into ai-resources, plus command and agent symlinks) resolve correctly with zero broken links. Two project-local real skill dirs (knowledge-file-producer, report-compliance-qc) both contain SKILL.md. Single project CLAUDE.md at root, all skill folders kebab-case, no orphaned or empty `.claude/` directories. Metrics: 78 skill dirs (76 symlink / 2 real), 188 total symlinks, 0 broken, 1 CLAUDE.md.

### CLAUDE.md Health
The single project CLAUDE.md is 177 lines (~3,129 tokens), under both the 200-line and 4,000-token Important thresholds. No `@import`/`@file` directives (it uses short pointer references to `ai-resources/docs` paths, none of which are @-include syntax), no hardcoded secrets, and a clear orientation section (Project Context). No contradictions detected against inherited workspace rules.

### Skill Inventory
The project owns two real skills; the other 76 entries are symlinks into the canonical ai-resources library and are out of project-edit scope. Both real skills have valid name/description with triggers and exclusions and bodies under 300 lines (135 / 113), but both omit the required `model:`/`effort:` tier frontmatter (Important x2). Neither is orphaned — each is invoked by a project command (produce-knowledge-file, run-report). No internal-reference or overlap issues. Metrics: 2 skills missing tier frontmatter, 0 over 300 lines, 0 orphaned.

### Commands & Subagents
98 commands (70 symlinked from ai-resources, 28 project-real) and 32 agents (28 symlinked, 4 project-real) — all symlinks resolve, zero broken. The 4 real agents (execution-agent, improvement-analyst, qc-gate, verification-agent) all have valid name/description/tools/model frontmatter. Two apparent dead skill references (`old-skill-name`, `skills/skill`) are documentation placeholders inside a Markdown table and a template line — correctly not flagged. Eight command name-collisions with ai-resources: 6 are intentional project overrides (divergent content, not findings), 2 (refinement-pass, update-claude-md) are byte-identical drift copies flagged Minor.

### Settings & Permissions
Single project `.claude/settings.json` is valid JSON with a well-formed permissions object (17 allow, 7 deny) and 22 hook entries across PreToolUse/PostToolUse/SessionStart/Stop/UserPromptSubmit. All 11 referenced project hook scripts plus `logs/scripts/check-archive.sh` exist and are executable; the two parent-walked ai-resources hooks (check-template-drift.sh, auto-sync-shared.sh) also resolve. Hooks use `$CLAUDE_PROJECT_DIR` rather than hardcoded absolute paths. Deny entries are generic guard globs, not stale path references. `Bash(*)` is a documented broad design choice, not a finding.

### 2026 Best Practices
The project follows 2026 Claude Code best practices well: filesystem-first verification, QC subagent isolation, hook-delegated mechanical checks, and disciplined sharing of canonical resources via symlinks. CLAUDE.md is lean and points to canonical docs rather than duplicating them (no @import syntax, but the pointer pattern achieves the same leanness). Maturity signals: filesystem-first verification rule, QC independence, error-driven rules (anti-leakage Execution Contract, Bright-Line Rule), mechanical checks in hooks, shared-resource symlink discipline with shared-manifest.json. The only cross-cutting opportunity is the isolated tier-frontmatter gap on the two project-owned skills; no systemic drift (command name_collisions_drift is 2 individual stale copies, not an auto-sync breakdown).

### Context Health
Cross-reference integrity is intact: all skill and command references resolve (the two apparent dead skill refs are documentation placeholders, correctly excluded), all 13 hook scripts referenced by settings.json exist and are executable, and CLAUDE.md references resolve. No dead cross-links or description mismatches. Recent commits cluster around shared-resource sync and report-workflow template fixes — flagged Minor as a spot-check pointer, no broken state detected. Metrics: 49 skill refs / 28 command refs checked, 0 dead; 13 hook scripts checked, 0 missing; 8 recent high-impact changes.

## Prioritized Recommendations

1. **Add `model: opus` / `effort: high` to knowledge-file-producer SKILL.md** — Closes an Important tier-frontmatter gap so the skill declares its own tier instead of inheriting the session model. Effort: Low. Area: Skill Inventory.
2. **Add `model: sonnet` / `effort: medium` to report-compliance-qc SKILL.md** — Same Important gap; do it in the same edit pass as #1. Effort: Low. Area: Skill Inventory.
3. **Reconvert refinement-pass.md and update-claude-md.md to symlinks** — Removes two byte-identical drift copies of shared commands so they track the canonical ai-resources source. Effort: Low. Area: Commands & Subagents.
4. **Spot-check the C5 skill mirror against ai-resources** — Recent lockstep landing touched a skill plus 6 mirrors; confirm the project-local copy matches canonical. Effort: Low. Area: Context Health.
5. **Maintain the current best-practice posture** — Filesystem-first verification, QC subagent isolation, and symlink-based resource sharing are all in good shape; no systemic issues to address. Effort: None. Area: 2026 Best Practices.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
