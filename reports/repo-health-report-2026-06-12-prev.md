# Workspace Health Report
**Date:** 2026-06-05
**Mode:** Full Audit
**Overall:** GREEN

## Executive Summary
The ai-resources repository is in strong health: all seven audit areas are GREEN, with no Critical or Important findings anywhere. The only items are three Minor housekeeping notes — most actionable being three research-workflow command files (qc-pass, refinement-pass, update-claude-md) that are byte-identical copies and should be symlinks to ride the auto-sync path. Top recommendation: convert those three copies to symlinks to close the only real drift risk in an otherwise clean shared-resource model.

## Scores
| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 1 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 0 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)
None.

### Important (Fix Soon)
None.

### Improvement Opportunities
- **[Commands & Subagents] Three workspace commands are byte-identical copies of ai-resources sources (drift)**
  In `workflows/research-workflow/.claude/commands/`, three real (non-symlink) files are byte-for-byte identical to their ai-resources sources: `qc-pass.md`, `refinement-pass.md`, `update-claude-md.md`. They should be symlinks, like `consult.md` and `session-plan.md` already are. The other six same-name commands (audit-repo, friction-log, improve, note, prime, wrap-session) differ and are intentional overrides — not flagged.
  *Location:* `workflows/research-workflow/.claude/commands/{qc-pass,refinement-pass,update-claude-md}.md`
  *Recommendation:* Replace the three identical copies with symlinks to the ai-resources sources so they stay in sync via auto-sync-shared.sh.

- **[2026 Best Practices] Three command copies undercut the auto-sync shared-resource pattern**
  Cross-referencing the command-auditor's `name_collisions_drift` metric (3), the same three copies are the only consistency gap in an otherwise mature sharing model that uses auto-sync-shared.sh plus symlinks. Not systemic — the other same-name commands are confirmed intentional overrides.
  *Location:* `workflows/research-workflow/.claude/commands/`
  *Recommendation:* Convert the three identical copies to symlinks. Low effort, removes future drift risk.

- **[Skill Inventory] Eight skills exceed 300 lines**
  Eight SKILL.md bodies run 300–500 lines (none over 500): answer-spec-generator (487), research-plan-creator (466), ai-resource-builder (432), ai-prose-decontamination (411), evidence-to-report-writer (393), cluster-memo-refiner (324), workflow-evaluator (318), workflow-system-critic (302). All within the Minor band.
  *Location:* `skills/answer-spec-generator/SKILL.md` and 7 others
  *Recommendation:* Optional — move illustrative examples or long reference material in the largest skills into `references/` files to keep operational bodies lean. Not urgent.

- **[Context Health] Recent commits touched high-impact command and CLAUDE.md files**
  The last 10 commits modified five command definitions and the repo CLAUDE.md. All cross-references resolve; no breakage present. Informational — these are the files to spot-check first if a downstream session misbehaves after the recent S6/S8 sessions.
  *Location:* `git log -10` (CLAUDE.md, friday-checkup.md, log-defect.md, prime.md, wrap-session.md, run-sufficiency.md)
  *Recommendation:* No action required.

## Detailed Analysis

### File Organization (GREEN)
File organization is healthy. 78 skill directories all carry SKILL.md and use lowercase kebab-case naming; no orphaned or mis-named skill folders. Both workspace symlinks (research-workflow consult.md and session-plan.md) resolve to live ai-resources sources. The two CLAUDE.md files sit in expected locations (repo root and the research-workflow template).
*Metrics:* total_skill_dirs 78 · total_symlinks 2 · broken_symlinks 0 · claude_md_files 2

### CLAUDE.md Health (GREEN)
Both CLAUDE.md files are well within size limits (98 and 155 lines; both under the 200-line / 4,000-token Important threshold). No @import references exist, so there are no dead imports. No secret-like patterns found, and each file carries an orientation section. No cross-level contradictions detected.
*Metrics:* CLAUDE.md 98 lines / ~1,521 tokens · workflows/research-workflow/CLAUDE.md 155 lines / ~2,148 tokens · 0 dead imports

### Skill Inventory (GREEN)
All 78 skills carry SKILL.md with valid name, description, model (opus/sonnet/haiku), and effort (high/medium/low) frontmatter — full tier-frontmatter compliance. No orphaned skills, no missing required fields. Eight skills run 300–500 lines (Minor); none over 500. Trigger overlap is low: the highest Jaccard similarity between any skill-description pair is 0.167, far below the 0.60 ambiguous-routing threshold.
*Metrics:* total_skills 78 · average_lines 214 · over_300 8 · over_500 0 · orphaned 0 · missing_tier_frontmatter 0

### Commands & Subagents (GREEN)
103 command files (72 ai-resources, 31 research-workflow) and 38 agent definitions (34 ai-resources, 4 workflow). All agent frontmatter is complete (name, description, tools, model on every agent). No dead command symlinks and no dead skill references — the `skills/old-skill-name` and `skills/skill` strings are illustrative template placeholders. Only finding: three byte-identical command copies that should be symlinks; six other same-name commands are intentional overrides.
*Metrics:* total_commands 103 · total_agents 38 · command_symlinks 2 · dead_references 0 · name_collisions_total 11 · name_collisions_drift 3 · intentional_overrides 6

### Settings & Permissions (GREEN)
All four settings files are valid JSON. No model field is declared in any settings file, consistent with the Model Tier rule. All 10 hook scripts referenced by `.claude/settings.json` exist and are executable; workflow settings reference hooks via `$CLAUDE_PROJECT_DIR` and ancestor-walk patterns that resolve to live scripts. No stale path-specific permission entries. `Bash(*)` in the allow list is a deliberate broad pattern (informational).
*Metrics:* total_settings_files 4 · all valid_json true · stale_entries 0 · broad_patterns: Bash(*) in ai-resources allow

### 2026 Best Practices (GREEN)
The workspace tracks 2026 best practices closely. Subagent isolation, context isolation (no command instructs a subagent to read a file path), and filesystem-first verification are all compliant — the seven git status/diff usages are for state orientation, recovery, and push-gating, never for verifying the model's own writes. Lean CLAUDE.md files (98/155 lines) mean the absence of @imports is not a maturity gap.
*Metrics:* subagent_isolation true · context_isolation true · filesystem_verification true · commands 103 · skills 78 · agents 38 · maturity signals: full tier frontmatter, 16 mechanical hooks, 12 session-ritual commands, error-driven CLAUDE.md rules

### Context Health (GREEN)
Cross-reference integrity is intact. The one skill reference in CLAUDE.md (ai-resource-builder) resolves; no command or agent points at a missing skill or agent; all 16 hook scripts referenced by settings exist and are executable. The only note is informational: six high-impact files changed in the last 10 commits, all currently consistent.
*Metrics:* skill_references_checked 4 · dead_references 0 · command_references_checked 103 · hook_scripts_checked 16 · hook_scripts_missing 0 · recent_high_impact_changes 6

## Prioritized Recommendations
1. **Symlink the three drift commands** — convert `qc-pass.md`, `refinement-pass.md`, `update-claude-md.md` in research-workflow to symlinks of their ai-resources sources, closing the only drift risk. (Low effort, highest impact.)
2. **Optionally trim the largest skills** — move examples/reference material out of the 400+ line skills (answer-spec-generator, research-plan-creator, ai-resource-builder) into `references/` files for leaner operational bodies.
3. **Spot-check recently-changed commands** if any downstream session misbehaves — start from prime.md, wrap-session.md, friday-checkup.md, log-defect.md.
4. **No settings or permission action needed** — all four files are valid, model-free, and hook-complete; maintain current discipline.
5. **No CLAUDE.md action needed** — both files are lean and within limits; revisit @import adoption only if either grows past ~200 lines.

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
