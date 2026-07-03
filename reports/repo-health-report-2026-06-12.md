# Workspace Health Report

**Date:** 2026-06-12
**Mode:** Full Audit
**Overall:** GREEN

---

## Executive Summary

The `ai-resources` repo is in strong health: across all seven audited areas there are **zero Critical and zero Important findings** — only Minor, advisory items. The library is mature and well-utilized (81 commands, 79 skills, 37 agents) with deliberate model tiering, lean CLAUDE.md files, codified subagent/context isolation, and filesystem-first verification. The single highest-value cleanup is replacing two byte-identical command copies in the research-workflow with symlinks so future edits auto-propagate. Nothing blocks normal operation.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 3 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 0 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 1 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

No important findings.

### Improvement Opportunities

- **[Commands & Subagents] Two project command copies are byte-identical to ai-resources sources (auto-sync drift)**
  `workflows/research-workflow/.claude/commands/refinement-pass.md` and `update-claude-md.md` are real files (not symlinks) that are byte-for-byte identical to their `.claude/commands/` sources. They were likely left behind before symlink sharing was adopted. The other 7 same-name pairs diverge in content and are intentional workflow overrides — not flagged.
  *Location:* `workflows/research-workflow/.claude/commands/refinement-pass.md, update-claude-md.md`
  *Recommendation:* Replace each identical copy with a symlink to the ai-resources source, matching the `consult.md` / `session-plan.md` pattern already in that directory.

- **[Skill Inventory] Seven skills exceed 300 body lines**
  Over 300 lines: answer-spec-generator (476), research-plan-creator (476), ai-resource-builder (431), ai-prose-decontamination (393), evidence-to-report-writer (373), cluster-memo-refiner (350), handoff (324). None exceed the 500-line restructure threshold; average across all 79 skills is 202 lines.
  *Location:* `skills/answer-spec-generator/SKILL.md and 6 others`
  *Recommendation:* Optionally move detailed procedure into `references/` files for the longest skills. Advisory only.

- **[Skill Inventory] One orphaned skill**
  `fund-triage-scanner` is not referenced by name in any command, agent, CLAUDE.md, workflow, doc, or other SKILL.md. May be intentional (project-invoked or reserved).
  *Location:* `skills/fund-triage-scanner/`
  *Recommendation:* Confirm it is still reachable from a project workspace; otherwise consider archiving.

- **[Skill Inventory] A few skill descriptions use non-'when' trigger phrasing**
  8 skills phrase triggers as "Use after"/"Use before"/"Invoked as a subagent" rather than the canonical "use when" (e.g. architecture-qc, grill-me, session-usage-analyzer, workflow-system-critic); 4 skills (the workflow-* family, workspace-template-extractor) state triggers but no explicit exclusions. All valid; advisory.
  *Location:* `skills/architecture-qc/SKILL.md and others`
  *Recommendation:* Optional normalization to explicit "Use when ... / Do NOT use for ..." for routing consistency. No functional impact.

- **[2026 Best Practices] Two mechanical-leaning auditor agents run on opus**
  `claude-md-auditor` and `token-audit-auditor` are on `model: opus`, yet much of their work (line counting, JSON parsing, pattern matching) is mechanical. The repo already splits the mechanical portion in `token-audit-auditor-mechanical` (haiku). Both do involve some interpretation, so this is advisory.
  *Location:* `.claude/agents/claude-md-auditor.md, .claude/agents/token-audit-auditor.md`
  *Recommendation:* Optionally review whether a sonnet/haiku split would match quality at lower cost. No action required.

- **[Context Health] Recent high-impact changes to spot-check**
  Last 10 commits touched `.claude/settings.json`, `.claude/hooks/check-foreign-staging.sh`, `skills/research-prompt-qc/SKILL.md`, and `workflows/research-workflow/.claude/commands/run-execution.md`. All downstream references still resolve. Informational, surfaced for post-change spot-check.
  *Location:* `.claude/settings.json, .claude/hooks/check-foreign-staging.sh, skills/research-prompt-qc/SKILL.md, workflows/research-workflow/.claude/commands/run-execution.md`
  *Recommendation:* After the concurrent-session hook work, confirm `check-foreign-staging.sh` behaves as intended in a live two-session test (it is invoked by other hooks, not wired directly in settings.json).

## Detailed Analysis

### File Organization
File organization is clean. All 79 skill directories contain a SKILL.md and use lowercase kebab-case names. Both symlinks resolve to existing targets. The two CLAUDE.md files (repo root and `workflows/research-workflow/`) sit in expected locations. No orphaned skill directories, no empty project `.claude/` directories.
*Key metrics:* 79 skill dirs · 2 symlinks (0 broken) · 2 CLAUDE.md files.

### CLAUDE.md Health
Both CLAUDE.md files are well within size limits — repo root 77 lines (~1,092 tokens), `workflows/research-workflow/` 155 lines (~2,148 tokens), both under the 200-line/4,000-token Important threshold. Each has headings and an orientation section. No `@imports`, so no dead-import risk. No secrets detected. No cross-level contradictions: the research-workflow file extends rather than negates the repo root rules.

### Skill Inventory
Healthy. All 79 skills have a SKILL.md with non-empty name and description and valid `model:`/`effort:` frontmatter (0 missing or out-of-range). No trigger-overlap pair exceeds 0.41 Jaccard (highest: editorial-recommendations-generator vs editorial-recommendations-qc) — well below the 0.60 ambiguous-routing threshold. Minor items only: 7 skills over 300 lines (none over 500), 1 orphan, and advisory description-wording notes.
*Key metrics:* 79 skills · avg 202 body lines · 7 over 300 · 0 over 500 · 1 orphan · 0 missing tier frontmatter.

### Commands & Subagents
Structurally sound. 81 ai-resources commands plus 11 in the research-workflow (2 symlinks, 9 real files). All 37 agents have complete name/description/tools/model frontmatter and no broken symlinks. No genuine dead references: the apparent dead refs (`skills/old-skill-name`, `skills/skill`, `agents/agent.md`, `agents/strategic-critic.md`) are template placeholders in Markdown tables; `doc-scanner-agent` / `principles-checker-agent` are project-scoped optional agents that friday-checkup guards with explicit "if missing, skip" logic. Only finding is 2 byte-identical project command copies that should be symlinks.
*Key metrics:* 92 commands total (81 ai-resources, 11 workflows) · 37 agents · 0 dead references · 11 name collisions (2 drift, 7 intentional overlap, plus 2 symlinks).

### Settings & Permissions
All three settings files are valid JSON with proper permissions structures and no `model` field (compliant with the Model Tier prohibition). Every hook script referenced resolves to an existing, executable file — including the research-workflow SessionStart hooks that locate `ai-resources/.claude/hooks/` scripts via a runtime directory walk. No stale path entries: the deny-list globs (`**/deprecated/**`, `**/old/**`) are defensive guards and the allow globs are generic patterns. `Bash(*)` is a deliberate broad-permission design choice, noted informationally.
*Key metrics:* 3 settings files (all valid JSON) · 9+9 hooks across the two workspace settings files · 0 stale entries.

### 2026 Best Practices
The workspace reflects mature 2026 Claude Code practices. CLAUDE.md files are lean and delegate detail to `docs/`; subagent isolation and context isolation (pass content, not paths) are codified and observed (37 commands use isolation language; 0 anti-patterns); verification is filesystem-first by rule. Agent tiering is deliberate — opus for judgment/synthesis, sonnet for structured execution, haiku for mechanical extraction. The only finding is the Minor opus-on-mechanical-agent advisory.
*Maturity signals:* lean CLAUDE.md with doc pointers · full session lifecycle (prime/session-start/session-plan/wrap-session/handoff) · 17 mechanical hooks (no judgment in hooks) · no model field in any settings · 81:79 command-to-skill ratio with 37 agents (well-utilized library).

### Context Health
Cross-reference integrity is intact. All CLAUDE.md skill/doc references resolve, including the two research-workflow docs (`project-config-schema.md`, `required-reference-files.md`) that resolve relative to that workflow's own directory. No dead command, agent, or pipeline references. All 18 hook scripts referenced across settings files exist and are executable, including the runtime-resolved ai-resources hooks. Four recent high-impact changes were traced; all downstream links hold. Drift risk is low.
*Key metrics:* 81 skill refs + 92 command refs checked, 0 dead · 18 hook scripts checked, 0 missing · 4 recent high-impact changes.

## Prioritized Recommendations

1. **Replace the two byte-identical research-workflow command copies with symlinks** — `refinement-pass.md` and `update-claude-md.md` will silently drift from their sources over time; symlinking restores auto-propagation. Effort: Low. Area: Commands & Subagents.
2. **Confirm `fund-triage-scanner` is still reachable** — an unreferenced skill is either a deployment gap or dead weight; a one-line check resolves which. Effort: Low. Area: Skill Inventory.
3. **Spot-check the recent concurrent-session hook change** — `check-foreign-staging.sh` was just modified; a live two-session test confirms the fail-open split behaves correctly. Effort: Low. Area: Context Health.
4. **Optionally trim the longest skills** — moving procedure from the 7 over-300-line skills into `references/` improves instruction-following headroom; none are urgent (all under 500). Effort: Medium. Area: Skill Inventory.
5. **Optionally re-tier the two mechanical-leaning opus auditors** — a sonnet/haiku split for `claude-md-auditor` and `token-audit-auditor` could cut cost at equal quality, following the existing `token-audit-auditor-mechanical` precedent. Effort: Medium. Area: 2026 Best Practices.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped. Note: this environment provided no subagent-spawning tool, so the lead agent executed each auditor's documented check procedure directly rather than via isolated subagents; findings reflect only what those checks actually surfaced.*
