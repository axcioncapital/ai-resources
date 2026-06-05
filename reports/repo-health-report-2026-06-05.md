# Workspace Health Report

**Date:** 2026-05-29
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The ai-resources workspace is structurally healthy across the board — zero broken symlinks, zero dead skill/command/agent references, zero missing-frontmatter cases across 78 skills and 35 agents, and every hook script referenced by every settings.json resolves and is executable. The single YELLOW signal is on the Settings layer: three April-2026 dated stale-suppression deny entries in `ai-resources/.claude/settings.json` have outlived their window and should be retired. Top recommendation: clean those three entries, then this report would have been GREEN end-to-end.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 3 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | YELLOW | 0 | 1 | 2 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)
No critical findings.

### Important (Fix Soon)
- **[Settings & Permissions] Stale dated-deny entries in ai-resources/.claude/settings.json** / The deny list contains 3 path patterns scoped to April 2026 audit/report files that no longer warrant a permanent deny entry: `Read(audits/token-audit-2026-04-*.md)`, `Read(audits/friday-checkup-2026-04-*.md)`, `Read(reports/repo-health-report-2026-04-*.md)`. The files still exist (so the entries are not technically dead paths), but they were added as time-bound stale-suppression and should be retired now that the workspace has moved through May. / *Location:* `ai-resources/.claude/settings.json` (lines 32-34) / *Recommendation:* Remove the three April-dated Read deny entries. The generic `Read(archive/**)` and `Read(logs/*-archive-*.md)` entries already cover archival suppression structurally.

### Improvement Opportunities
- **[Skill Inventory] 5 skills over 300 body lines** / Five SKILL.md files exceed the 300-line soft floor (none exceed 500): ai-prose-decontamination (393), ai-resource-builder (403), answer-spec-generator (476), evidence-to-report-writer (373), research-plan-creator (452). / *Location:* `ai-resources/skills/{ai-prose-decontamination,ai-resource-builder,answer-spec-generator,evidence-to-report-writer,research-plan-creator}/SKILL.md` / *Recommendation:* Spot-check the 5 skills; move static reference content (rubrics, schemas, templates) to a sibling reference file if the body itself is now mostly procedural prose.
- **[Skill Inventory] 8 skills lack explicit trigger conditions in description** / The auto-routing heuristic looks for phrases like "use when", "trigger", "run when", "invoke when". These 8 skills do not have such phrasing: architecture-qc, formatting-qc, grill-me, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic. / *Location:* `ai-resources/skills/*/SKILL.md` (8 skills) / *Recommendation:* On next `/improve-skill` pass, add a one-line "Use when X" clause to each description.
- **[Skill Inventory] 4 skills lack explicit exclusion clauses in description** / These 4 skills do not contain exclusion language ("do not", "not for", "never", "avoid") in their description: workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor. / *Location:* `ai-resources/skills/*/SKILL.md` (4 skills) / *Recommendation:* Add a "Do NOT use for X (use Y instead)" clause to each description, particularly to disambiguate the three workflow-* siblings.
- **[Commands & Subagents] Most slash-command files omit explicit "Usage:" line** / The active convention places a description sentence after the model frontmatter instead of a literal `Usage:` keyword line. ~60+ commands lack the keyword form; functionally the description sentence does the same job. / *Location:* `ai-resources/.claude/commands/*.md` (workspace-wide convention) / *Recommendation:* Optional — decide whether `Usage:` is a required convention. If so, add it on next sweep; if not, drop the check from the auditor.
- **[Settings & Permissions] Scaffold template denies git push (contradicts workspace policy)** / The obsidian-kb-builder scaffold template includes `Bash(git push*)` in its deny list. Workspace policy treats push as a routine post-commit step. If deployed verbatim to a new KB project, this creates a permission prompt the operator has agreed to eliminate. / *Location:* `ai-resources/skills/obsidian-kb-builder/templates/scaffold/settings.json` (line 16) / *Recommendation:* Remove the `Bash(git push*)` deny entry from the scaffold template.
- **[Settings & Permissions] Template placeholder in workflow settings additionalDirectories** / workflows/research-workflow/.claude/settings.json contains `additionalDirectories: ['{{WORKSPACE_ROOT}}']`. This file is the workflow template — the placeholder is intentional in its template role. / *Location:* `ai-resources/workflows/research-workflow/.claude/settings.json` (line 33) / *Recommendation:* No change needed; confirm `/deploy-workflow` substitutes the placeholder. Document the placeholder as intentional with a comment or sibling README.
- **[2026 Best Practices] ai-resources/CLAUDE.md uses inline rules rather than the parent's pointer pattern** / The parent workspace CLAUDE.md uses 15 "Full rules: ai-resources/docs/..." pointers. ai-resources/CLAUDE.md (90 lines) inlines its rules. Currently fine at this size; observation only. / *Location:* `ai-resources/CLAUDE.md` / *Recommendation:* When ai-resources/CLAUDE.md next grows past ~150 lines, factor longer sections into docs/ and replace with pointers.
- **[2026 Best Practices] Skill model-tier distribution leans heavily on opus** / Across 78 skills, opus dominates; agent tier mix (16 opus / 9 sonnet / 6 haiku) is closer to balanced. Some opus-declared skills may be structured-execution rather than judgment-bound and could move to sonnet. / *Location:* `ai-resources/skills/*/SKILL.md` (frontmatter model: field) / *Recommendation:* Optional review pass: for each opus skill, ask whether the work is judgment-bound or structured execution; route the latter to sonnet via `/improve-skill`.
- **[Context Health] Recent high-impact changes — spot-check downstream** / Last 10 commits modified 13 high-impact files including 8 orchestration commands (deploy-workflow, graduate-resource, new-project, prime, resolve-incident, session-plan, session-start, wrap-session). No broken refs detected, but the volume suggests active iteration worth a spot-check. / *Location:* `ai-resources/.claude/commands/{session-plan,session-start,wrap-session,prime,resolve-incident}.md` / *Recommendation:* Run `/drift-check` or a quick read-through after the next session to confirm commands still call each other consistently.

## Detailed Analysis

### File Organization
File organization is healthy. 79 skill directories in `ai-resources/skills/` (78 skill folders + one `CATALOG.md` reference file), all skill folder names are kebab-case, all containing SKILL.md. Two symlinks in the repo (both shared-command auto-syncs from `workflows/research-workflow/.claude/commands/` into `ai-resources/.claude/commands/`) resolve cleanly. No empty `.claude/` directories. No misplaced CLAUDE.md files — both observed CLAUDE.md files (`./CLAUDE.md` and `./workflows/research-workflow/CLAUDE.md`) sit at expected locations.

**Key metrics:** 79 skill dirs / 2 symlinks (0 broken) / 2 CLAUDE.md files.

### CLAUDE.md Health
Two CLAUDE.md files inside ai-resources, both well below the 200-line size floor (90 and 155 lines, estimated 1,301 and 2,148 tokens respectively). Both have orientation sections and clear top-level headings. No @imports in use (monolithic-but-small structure; appropriate for these sizes). No hardcoded secrets detected. No dead references. No level contradictions detected between the repo CLAUDE.md and the workflow CLAUDE.md.

**Per-file line counts:** `CLAUDE.md` = 90 lines / `workflows/research-workflow/CLAUDE.md` = 155 lines.

### Skill Inventory
Skill library is healthy: 78 skills, all with valid frontmatter declaring both `model:` and `effort:` (no inheritance), all referenced from at least one consuming file (zero orphans). No skill exceeds 500 body lines; 5 sit between 300-500 (minor refactor opportunity). No description-overlap pair exceeds the 60% Jaccard threshold — top pair sits at 0.41. Minor opportunities exist to tighten trigger/exclusion phrasing in 12 descriptions.

**Key metrics:** 78 skills / avg 199 lines / 0 orphans / 0 missing tier frontmatter / top overlap 0.41 (execution-manifest-creator ↔ research-prompt-creator).

### Commands & Subagents
Commands & subagents inventory is healthy. 97 command files across 2 scopes (66 in ai-resources, 31 in workflows/research-workflow) and 35 agent files (31 + 4) — all with complete frontmatter (name/description/tools/model). Zero dead skill or agent references. Zero broken symlinks. All 11 same-name command collisions are either intentional symlink shares (2: consult, session-plan) or intentional project-specific overrides (9, content differs from ai-resources). Only Minor observation: most commands omit the explicit "Usage:" line convention.

**Counts by scope:** 66 ai-resources commands / 31 workflow commands / 31 ai-resources agents / 4 workflow agents / 0 dead refs / 0 broken symlinks.

### Settings & Permissions
Settings layer is broadly sound: all 4 settings.json files parse as valid JSON, every hook command references an existing script, bypassPermissions mode is set everywhere as policy requires, and no `model` field appears in any settings file (compliant with the non-negotiable Model Tier rule). One Important issue: three dated April-2026 stale-suppression deny entries in `ai-resources/.claude/settings.json` should be removed. Two Minor: scaffold template denies git push (contradicts workspace policy) and the workflow template uses an unresolved `{{WORKSPACE_ROOT}}` placeholder (correct in its template role).

**Per-file analysis:**
- `.claude/settings.json` — valid JSON / 18 allow / 10 deny / 9 hooks / 3 stale entries
- `.claude/settings.local.json` — valid JSON / empty `{}`
- `workflows/research-workflow/.claude/settings.json` — valid JSON / 16 allow / 7 deny / 12 hooks
- `skills/obsidian-kb-builder/templates/scaffold/settings.json` — valid JSON / 10 allow / 3 deny / 0 hooks

### 2026 Best Practices
Workspace shows strong 2026 best-practice adoption: explicit model-tier-per-skill (no inheritance), pointer-style CLAUDE.md from workspace root, fresh-context subagent isolation documented as a hard rule, filesystem-first verification, and a mature ritual layer (Friday cadence, permission sweeps, audit/dd commands). No Critical or Important findings.

**Maturity signals observed:** structured permission management with canonical template + `/permission-sweep`; Friday cadence rituals with weekly/monthly/quarterly auto-detection; pointer-style cross-references from parent CLAUDE.md (15 instances); filesystem-first verification rule explicit in both CLAUDE.md files; subagent-contract pattern (notes-to-disk, summary-to-main); zero-permission-prompts floor with bypassPermissions; repo-health-analyzer itself as meta-tooling for introspection; two-wave audit pattern; per-command/per-skill explicit model declaration.

### Context Health
Cross-reference integrity is clean. All 78 skills referenced from CLAUDE.md and commands resolve; all 19 hook scripts referenced by settings.json files exist and are executable; the workflow pipeline's stage commands all point to existing skills. Three initial dead-agent candidates were re-checked against project-scope agent inventories and confirmed as either operationally-guarded cross-project agents (doc-scanner-agent and principles-checker-agent live under `projects/repo-documentation/.claude/agents/` and `friday-checkup.md` explicitly guards with existence checks) or markdown-table examples (strategic-critic in sync-workflow.md's sync-table). None are real dead references.

**Cross-reference integrity metrics:** 78 skill references checked / 0 dead / 97 command references checked / 0 dead / 31 pipeline steps checked / 0 mismatches / 19 hook scripts checked / 0 missing / 0 not-executable / 13 recent high-impact file changes.

## Prioritized Recommendations

1. **Remove 3 April-dated Read deny entries from `ai-resources/.claude/settings.json` (lines 32-34)** — The only Important finding in the audit. These were time-bound stale-suppression entries that have outlived their window; removing them tightens the permission file without changing behavior since `Read(archive/**)` and `Read(logs/*-archive-*.md)` already cover archival paths structurally. Effort: Low. Area: Settings.

2. **Fix the obsidian-kb-builder scaffold template — remove `Bash(git push*)` deny** — Contradicts the workspace zero-permission-prompts floor. If/when the scaffold is deployed to a new KB project verbatim, it creates a manual permission prompt that the operator has explicitly opted out of system-wide. Effort: Low. Area: Settings.

3. **Add trigger/exclusion phrasing to the 12 flagged skill descriptions on the next `/improve-skill` pass** — 8 skills lack "use when" trigger phrasing and 4 lack "do not / never" exclusion phrasing. This improves auto-routing reliability, especially for the 3 sibling workflow-* skills that currently have no exclusion clauses to disambiguate them from one another. Effort: Low (per-skill, one description edit each). Area: Skill Inventory.

4. **Spot-check the 5 over-300-line skills for refactor opportunities** — None are critical (all under 500), but factoring static reference content (rubrics, schemas, templates) into sibling reference files reduces the skill-load cost and follows the established docs/ pointer pattern. Targets: research-plan-creator (452), answer-spec-generator (476), ai-resource-builder (403), ai-prose-decontamination (393), evidence-to-report-writer (373). Effort: Medium (one skill at a time). Area: Skill Inventory.

5. **Review opus-leaning skill-tier distribution** — Walk the opus-declared skills and ask whether the work is judgment-bound (route, decide, evaluate) or structured execution (transform, extract, format). Move the latter to sonnet per the canonical mapping in the workspace CLAUDE.md (Model Tier section). This is optional; sonnet may produce lower quality on borderline cases, so triage carefully. Effort: Medium. Area: 2026 Best Practices.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
