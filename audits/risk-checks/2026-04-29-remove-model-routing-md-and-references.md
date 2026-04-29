# Risk Check — 2026-04-29

## Change

Deleted ai-resources/docs/model-routing.md and removed all references to it from 18 operational files across 6 git repos. Changes: (1) deleted the doc itself; (2) removed trailing "Routing rule: ai-resources/docs/model-routing.md" sentences from workspace CLAUDE.md (2 places), ai-resources CLAUDE.md, and 6 project CLAUDE.mds; (3) removed doc reference from .claude/hooks/model-classifier.sh heredoc (no logic change, only removed the pointer text); (4) removed references from 4 slash commands (prime, route-change, deploy-workflow, new-project) and 3 skill/agent files. No new hooks, commands, permissions, or functionality added — all changes are purely removals of text pointing to the now-deleted file.

This is an END-TIME risk-check — the change has already been executed and committed across 6 git repos (commits f76c1fe in ai-resources, 1bfe340 in workspace, plus per-project commits). No plan-time risk-check was run; the change was operator-directed and judged simple at proposal time.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/model-routing.md — not yet present (deleted this session; verified absent via `ls`)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/model-classifier.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/route-change.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/repo-health-analyzer/agents/skill-auditor.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/CLAUDE.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A pure-deletion / pointer-removal change that removed a duplicated doc and 18 callers cleanly, but produced two residual coupling concerns: (a) stale references in `projects/repo-documentation/output/phase-1/` (a generated documentation snapshot that now describes a non-existent doc); (b) loss of a single-source-of-truth that previously consolidated tier rules — content now lives only in dispersed inlines, raising future drift risk.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change is purely *removal* of trailing pointer sentences from always-loaded files (workspace CLAUDE.md, ai-resources CLAUDE.md, 6 project CLAUDE.mds). Each removal is approximately one sentence ("Routing rule: ai-resources/docs/model-routing.md."), so always-loaded token budget *decreases* by ~8–16 sentences across the workspace — net improvement.
- No new hooks, no new auto-loaded files, no new `@import` chains, no new subagents introduced. Verbatim from CHANGE_DESCRIPTION: "No new hooks, commands, permissions, or functionality added".
- The model-classifier.sh hook is unchanged in behavior — only the heredoc's pointer text was trimmed; firing cadence (UserPromptSubmit, once per session) is unchanged. Verified by reading the hook file: the additionalContext block now references the project's `CLAUDE.md` → Model Selection directly, no reference to the deleted doc (line 46).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` changes. No allow/ask/deny additions or removals. CHANGE_DESCRIPTION explicitly states "No new hooks, commands, permissions, or functionality added".
- No tool-invocation patterns introduced. No scope escalations.

### Dimension 3: Blast Radius
**Risk:** Medium

- 18 operational files modified across 6 git repos (per CHANGE_DESCRIPTION). Verified: grep across operational dirs (`ai-resources/.claude`, `ai-resources/skills`, `ai-resources/docs`, `workflows`, `.claude/hooks`, all 6 project CLAUDE.mds) returns **zero** residual `model-routing` matches. Operational surface is fully cleaned.
- Workspace and ai-resources CLAUDE.md `Model Tier` / `Model Selection` / `Model Escalation` sections survive intact (verified at workspace CLAUDE.md lines 160–181 and ai-resources CLAUDE.md lines 28–32). The rules they encode are unchanged; only the trailing pointer to the deleted doc was removed.
- **Residual stale references in non-operational files** — grep across the workspace surfaces 11 residual `model-routing` matches in non-operational locations: 5 in `projects/repo-documentation/output/phase-1/` (principles.md, system-doc.md, components/references.md, inventory/components.md, inventory/fragments.md, repo-snapshot.md), 1 in `audits/repo-due-diligence-2026-04-27-project-repo-documentation.md`, several in `audits/working/` and `logs/session-notes-archive-2026-04.md`. Audit/log/archive files are explicitly *historical records* per CHANGE_DESCRIPTION ("historical files (audits, logs, project outputs) were left untouched as records") and are correctly out-of-scope for cleanup. However, `projects/repo-documentation/output/phase-1/` is described as project *output* — it now documents a doc that no longer exists. If that project's output is treated as a current artifact (not a frozen phase output), readers will encounter dangling references. This is the principal Medium-blast item.
- Contract changes: none. The deleted doc was a *referent*, not a contract producer. No subagent input schema, report heading, hook output shape, or slash-command syntax was altered.

Enumeration of grep'd components and reference counts:
- Operational files (CLAUDE.md, .claude/commands, .claude/hooks, ai-resources/skills, ai-resources/docs, ai-resources/.claude, workflows): **0 residual references**.
- `projects/*/CLAUDE.md` (6 files): **0 residual references**.
- `projects/repo-documentation/output/phase-1/`: **5+ stale references** (these describe `model-routing.md` as if it still exists).
- `ai-resources/audits/` and `ai-resources/logs/`: **multiple** (correctly preserved as historical records).

### Dimension 4: Reversibility
**Risk:** Low

- All changes are git-tracked text-only edits and one file deletion. `git revert f76c1fe 1bfe340` plus the per-project revert commits would restore the doc and all 18 references in a single mechanical operation per repo.
- No state propagated beyond the local repos other than commits-not-yet-pushed (per CHANGE_DESCRIPTION the change is committed; per workspace rules push is a manual operator step requiring confirmation, so the change is presumptively local-only or recently pushed).
- No external writes (no Notion writes, no API POSTs, no automation fired).
- One caveat: the deleted doc itself contained content (per `logs/session-notes-archive-2026-04.md` line 2685: "three-tier rule, decision question, examples table, cost ratios, project-default architecture, identifier forms"). A revert restores the file from git history, so no content is lost — but a restore requires either revert or `git show <pre-deletion-sha>:ai-resources/docs/model-routing.md > ai-resources/docs/model-routing.md`. Single mechanical step, qualifies as Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Single-source-of-truth removed without redistribution check.** The deleted doc consolidated three layers of tier rules: session-level, agent-level, and skill-level (per `logs/session-notes.md` line 358: "Skill-level routing subsection added as third layer (alongside session-level and agent-level); canonical mapping table included"). CHANGE_DESCRIPTION asserts "the tier rules described in model-routing.md are already inlined in CLAUDE.md and skill/agent files; no content migration was needed" (verbatim). I verified that workspace CLAUDE.md retains Model Tier (line 160), Model Selection (line 162), Model Escalation (line 170), and an Agent Tier sub-section pointer to `agent-tier-table.md`. However, a few items the deleted doc carried do not have an obvious surviving canonical home: the cost-ratio table, the identifier-forms reference (e.g., when to use `[1m]` suffix), and the skill-level routing mapping. The `[1m]` suffix rule is preserved in user memory (per MEMORY.md "Sonnet identifiers need [1m] suffix") but memory files are user-private; if a future operator opens the workspace fresh, they may not encounter that rule until they hit the bare-Sonnet downgrade. This is implicit coupling on user memory, not a documented contract.
- **Stale snapshot in `projects/repo-documentation/output/phase-1/`.** That phase output names `model-routing.md` as a current component (e.g., `system-doc.md` line 181: "`ai-resources/docs/model-routing.md` defines model tier selection rules"). If anything (a future audit, a migration command, an operator query) consumes that snapshot expecting the doc to exist, it will hit a dangling reference. The snapshot is presumably frozen-as-of-its-date, but the frozen-vs-current status is not declared inline.
- **No functional overlap** with surviving mechanisms — the deleted doc was descriptive, not active. No two-hooks-on-the-same-event pattern.
- **No new contracts introduced** — the change is pure deletion, so there is no new parse marker, filename convention, or output-format expectation downstream callers must honor.

## Mitigations

- **Dimension 3 (Blast Radius) — repo-documentation phase-1 output:** Either (a) annotate `projects/repo-documentation/output/phase-1/` files with a frontmatter note `as_of: 2026-04-25` (or whatever date the snapshot reflects) so future readers understand the snapshot is historical and `model-routing.md` was deleted on 2026-04-29; or (b) if the project is still active, run `/sync-workflow` or an equivalent regeneration so the output reflects the post-deletion state. Choose (a) if the project is parked, (b) if active.
- **Dimension 5 (Hidden Coupling) — orphaned content:** Sweep workspace CLAUDE.md, ai-resources CLAUDE.md, and `docs/agent-tier-table.md` for explicit coverage of the three items the deleted doc owned: (i) cost-ratio guidance (Haiku ≪ Sonnet ≪ Opus pricing intuition); (ii) Sonnet 1M identifier rule (`[1m]` suffix to force 1M context, otherwise downgrades to 200k); (iii) skill-level routing mapping table. If any of the three is missing from a surviving canonical location, add a one-paragraph block to the most appropriate home. Recommended targets: cost-ratio → workspace CLAUDE.md `Model Tier`; `[1m]` suffix → `docs/permission-template.md` near the existing `model: "sonnet[1m]"` mention; skill-level routing → `skills/ai-resource-builder/SKILL.md`.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `ls` confirming file deletion; recursive `grep` returning zero matches across operational dirs (CLAUDE.md, .claude/commands, .claude/hooks, ai-resources/skills, ai-resources/docs, ai-resources/.claude, workflows, all 6 project CLAUDE.mds) and enumerated matches across non-operational dirs (projects/repo-documentation/output/phase-1, audits, logs); verbatim quotes from CHANGE_DESCRIPTION; line-cited reads of model-classifier.sh, route-change.md, prime.md, deploy-workflow.md, new-project.md, repo-architecture.md, permission-template.md; `git log --oneline` confirming commits f76c1fe and 1bfe340. No INCOMPLETE dimensions. No training-data fallback.
