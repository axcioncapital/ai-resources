# Workspace Health Report

**Date:** 2026-05-29
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The nordic-pe-macro-landscape-H1-2026 project is in strong overall health: file organization, CLAUDE.md, skill inventory, settings/permissions, 2026 best-practice adoption, and cross-reference integrity all scored GREEN with no Critical findings. The single YELLOW signal comes from `.claude/shared-manifest.json` drift — one phantom entry (`route-change`) and 14 commands/agents whose actual on-disk state contradicts their manifest classification. The fix is mechanical: reconcile the manifest in one pass and, optionally, add a SessionStart hook that warns when manifest and disk drift in the future (matches the workspace's stated preference for automated structural enforcement).

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 1 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 0 |
| Commands & Subagents | YELLOW | 0 | 2 | 0 |
| Settings & Permissions | GREEN | 0 | 0 | 0 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 3 |

## Findings

### Critical (Fix Now)
No critical findings.

### Important (Fix Soon)

- **[Commands & Subagents] shared-manifest.json lists 'route-change' as shared command but file does not exist anywhere**
  / shared-manifest.json declares 'route-change' under commands.shared, but neither `.claude/commands/route-change.md` (project) nor `ai-resources/.claude/commands/route-change.md` (canonical source) exists. The auto-sync hook will silently skip this entry; no runtime error, but the manifest is misleading and will not auto-create a symlink if route-change is reintroduced.
  / *Location:* `.claude/shared-manifest.json (commands.shared array)`
  / *Recommendation:* Remove 'route-change' from shared-manifest.json, or confirm the command should exist and restore it in ai-resources.

- **[Commands & Subagents] shared-manifest.json classifies 14 commands+agents incorrectly (declared 'local' but exist as symlinks, or absent from manifest but exist as symlinks)**
  / Drift between manifest declaration and on-disk reality: (a) `session-plan` and `wrap-session` are listed under commands.local but actually exist as symlinks to ai-resources canonical (so the manifest's 'local' label is wrong; they auto-sync); (b) 10 commands exist as symlinks but are absent from the manifest entirely — contract-check, decide, drift-check, fix-repo-issues, grill-me, handoff, placement, pm, resolve-incident, resolve-repo-problem — auto-sync will not see them; (c) 4 agents in the same state — fading-gate-scanner, fix-repo-issues-scanner, friday-act-16a-summarizer, project-manager. Functionally the symlinks work, but the manifest no longer reflects truth, which weakens auto-sync hook coverage and any reporting that depends on it.
  / *Location:* `.claude/shared-manifest.json`
  / *Recommendation:* Run a manifest-reconciliation pass: move 'session-plan' and 'wrap-session' from commands.local to commands.shared; add the 10 missing commands to commands.shared; add the 4 missing agents to agents.shared.

### Improvement Opportunities

- **[File Organization] Two .md.bak archive files in .claude/commands/**
  / `produce-formatting-v1-template.md.bak` and `produce-prose-draft-v1-template.md.bak` are pre-FX-D1 fork archives. The `.bak` extension correctly prevents slash-command registration. CLAUDE.md documents these as historical reference.
  / *Location:* `.claude/commands/produce-formatting-v1-template.md.bak, .claude/commands/produce-prose-draft-v1-template.md.bak`
  / *Recommendation:* Optional — relocate to `.claude/commands/archive/` for clearer separation.

- **[2026 Best Practices] Manifest-disk drift is the dominant systemic signal**
  / Command-auditor surfaced 15 manifest-disk drift instances (1 phantom + 10 missing-from-manifest commands + 4 missing-from-manifest agents + 2 wrongly-classified-local). A periodic reconciliation hook (extend `check-permission-sanity.sh` or add a small manifest-drift check) would close the gap once and prevent recurrence.
  / *Location:* `.claude/shared-manifest.json + .claude/commands/ + .claude/agents/`
  / *Recommendation:* Add a SessionStart hook that diffs `shared-manifest.json` against the on-disk symlink set and warns when they drift.

- **[Context Health] Recent change to .claude/settings.json (commit 56ee1cb, 2026-05-28) — git-push gate removed**
  / Spot-check any session-end commit/push workflows to confirm they don't still reference the removed gate.
  / *Location:* `.claude/settings.json, CLAUDE.md (commit 56ee1cb)`
  / *Recommendation:* Quick grep across `.claude/commands/` for any prose still mentioning 'approval before push' or 'push gate' — clean up stale references if found.

- **[Context Health] Recent change to .claude/hooks/backup-session-plan.sh (commit 4c1e4f6, 2026-05-28) — swapped to canonical symlink**
  / The hook script was migrated from a local copy to a symlink pointing at ai-resources canonical. Symlink resolves; no drift detected.
  / *Location:* `.claude/hooks/backup-session-plan.sh (symlink), .claude/settings.json PreToolUse Write block`
  / *Recommendation:* On the next Write-tool invocation, confirm the hook runs cleanly.

- **[Context Health] Recent changes to .claude/commands/run-report.md and .claude/commands/review-chapter.md (commit 5028c3b)**
  / Both pipeline command files modified in the wave-2 nordic-pe scope commit. All referenced skills and reference docs verified present.
  / *Location:* `.claude/commands/run-report.md, .claude/commands/review-chapter.md (commit 5028c3b)`
  / *Recommendation:* No action required. Listed for spot-check visibility.

## Detailed Analysis

### File Organization
Project is a research-project workspace (not the repo root) with a healthy `.claude/` structure: 89 command files (68 symlinked to ai-resources, 17 local pipeline-specific, plus 2 `.bak` archives and 2 from prior layout), 33 agent files (29 symlinked, 4 local), and a 66-skill symlink farm under `reference/skills/` that mirrors a curated subset of `ai-resources/skills/`. All 165 symlinks resolve; no broken targets. The CLAUDE.md sits at project root as expected, and `reference/` holds project-scoped policy docs. The only minor observation is two `.bak` archive files in `commands/` that could be relocated for tidiness.

### CLAUDE.md Health
Single project-level CLAUDE.md at 126 lines / ~2,400 tokens. Well under all size thresholds (200/4,000 Important, 400/8,000 Critical). No `@import` statements (acceptable at this size; `@imports` become useful past ~200 lines). All inline cross-references to `reference/*.md` files resolve. No secrets-like patterns when scanned with word-boundary regex. Structure is clean and an orientation section is present (Project Context).

### Skill Inventory
The project owns one local skill (`knowledge-file-producer`) and exposes 66 ai-resources skills via symlink under `reference/skills/`. The local skill has complete frontmatter (`name`, `description`, `model: opus`, `effort: high`), proper trigger conditions, explicit exclusions naming three sibling skills, and 137 lines of body (well under 300/500 thresholds). All 66 symlinked skills point to the canonical ai-resources library and were verified resolvable. The symlink farm is a curated subset — three ai-resources skills referenced from this project's commands (`grill-me`, `handoff`, `report-compliance-qc`) are not in the local mirror, but commands either reach them via the symlinked command body (which Claude resolves relative to the canonical location) or via absolute paths (`run-report.md`).

### Commands & Subagents
All 68 command symlinks and 29 agent symlinks resolve cleanly — no broken links, no dead references at runtime. Local files (17 commands, 4 agents) all have valid YAML frontmatter per the project convention documented in CLAUDE.md (no `Usage:` line is intentional). Two Important findings concern `shared-manifest.json` drift: one phantom entry (`route-change` declared but file absent everywhere), and 14 commands/agents whose actual on-disk state contradicts their manifest classification. Functionally the workspace runs; the manifest needs reconciliation so auto-sync coverage matches reality.

### Settings & Permissions
Both settings files parse as valid JSON. Permissions are well-structured: 16 allow entries, 7 deny entries (deny includes destructive-Bash guards plus archive/deprecated/old read-blocks — all pattern-based, no stale path references). All 14 hook scripts referenced across PreToolUse / PostToolUse / SessionStart / Stop / UserPromptSubmit blocks exist on the filesystem (including the symlinked `backup-session-plan.sh` pointing to canonical ai-resources). `settings.local.json` correctly carries only the adaptive-thinking env var per workspace rule.

### 2026 Best Practices
Project demonstrates strong 2026 best-practice adoption: subagent-with-content-passing is the dominant pattern in pipeline commands (`Launch a general-purpose sub-agent. Pass it: the skill content...`), context isolation is explicit, filesystem-first verification holds (git usage is for state probes and operator-facing snapshots, not for self-verification of writes), local agents are well-formed, and the CLAUDE.md carries change-rationale annotations (FX-D1, Bundle 1/2) that signal error-driven evolution. The single cross-cutting concern is `shared-manifest.json` drift — best closed with a small mechanical hook rather than manual discipline.

### Context Health
Cross-reference integrity is intact across all four checks: every CLAUDE.md reference to `reference/*.md` resolves; every skill mentioned in pipeline commands (`run-report`, `run-analysis`, `run-cluster`, `run-execution`, `run-preparation`, `run-synthesis`) exists in either the project's `reference/skills/` mirror or the ai-resources canonical (resolved via absolute paths `/ai-resources/skills/{name}/SKILL.md`); every hook script declared in `settings.json` exists on the filesystem. Three Minor findings flag recent high-impact file changes (`settings.json`, `backup-session-plan.sh`, `run-report.md` + `review-chapter.md`) for spot-check awareness — none are dead references, just change-risk surface.

## Prioritized Recommendations

1. **Reconcile shared-manifest.json against on-disk state** — Closes both Important findings in one pass: remove the `route-change` phantom entry, move `session-plan` + `wrap-session` from `commands.local` to `commands.shared`, add the 10 unlisted symlinked commands (`contract-check`, `decide`, `drift-check`, `fix-repo-issues`, `grill-me`, `handoff`, `placement`, `pm`, `resolve-incident`, `resolve-repo-problem`) to `commands.shared`, and add the 4 unlisted agents (`fading-gate-scanner`, `fix-repo-issues-scanner`, `friday-act-16a-summarizer`, `project-manager`) to `agents.shared`. Effort: Low. Area: Commands & Subagents.

2. **Add a manifest-drift SessionStart hook** — Prevents recurrence of finding 1. Compare `jq -r '.commands.shared[], .commands.local[]'` against the basenames of files in `.claude/commands/`; warn on diff. Pairs naturally with the existing `check-permission-sanity.sh` model. Effort: Low. Area: 2026 Best Practices.

3. **Grep for stale 'push gate' / 'approval before push' references in `.claude/commands/`** — Recent commit 56ee1cb removed the git-push gate; downstream prose in command files may still reference it. Effort: Low. Area: Context Health.

4. **Relocate the two `.md.bak` archive files to `.claude/commands/archive/`** — Cosmetic; current layout works because `.bak` blocks slash-command registration, but a dedicated archive folder is cleaner and matches the workspace's general pattern. Effort: Low. Area: File Organization.

5. **Confirm the next Write-tool invocation triggers the symlinked `backup-session-plan.sh` cleanly** — Validates that the FX-E1/FX-E2 hook swap is working as intended. Passive observation only; no proactive action needed. Effort: Low. Area: Context Health.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
