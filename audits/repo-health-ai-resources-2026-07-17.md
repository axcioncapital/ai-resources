# Workspace Health Report

**Date:** 2026-07-17
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The `ai-resources` repo is structurally healthy and mature: six of seven audited areas score GREEN, with zero Critical findings and zero dead references across 80 skills, 90 canonical commands, 42 agents, and every hook script. The one non-GREEN area is Settings & Permissions (YELLOW), driven by a single Important finding — an unsubstituted `{{WORKSPACE_ROOT}}` template placeholder used as an `additionalDirectories` path. That finding, plus two related Minor items, all trace to one directory: `output/deploy-test-scratch-2026-06-12/`, a leftover deploy-test scratch that cross-cutting verification confirmed is both gitignored and untracked (disposable local state, never in the repo). **Top recommendation: delete `output/deploy-test-scratch-2026-06-12/` — a single deletion clears findings flagged independently by three auditors and carries no real permission risk.**

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 1 |
| Skill Inventory | GREEN | 0 | 0 | 4 |
| Commands & Subagents | GREEN | 0 | 0 | 2 |
| Settings & Permissions | YELLOW | 0 | 1 | 3 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 4 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

- **[Settings & Permissions] Unsubstituted template placeholder as an additionalDirectory path**
  `additionalDirectories` is set to `["{{WORKSPACE_ROOT}}"]` — a literal, unsubstituted scaffold token, not a real directory. The placeholder was never filled in when this settings file was deployed, so at runtime Claude Code would be asked to add a directory named literally `{{WORKSPACE_ROOT}}`, which does not exist. This is confined to a disposable deploy-test-scratch output directory (dated 2026-06-12); the canonical template (`workflows/research-workflow/.claude/settings.json`) has no `additionalDirectories` block and is clean. Cross-cutting verification by the best-practices auditor confirmed the directory is both gitignored and untracked (0 tracked files), so this poses no real permission risk to live config.
  *Location:* `output/deploy-test-scratch-2026-06-12/.claude/settings.json` (additionalDirectories)
  *Recommendation:* Delete the whole `output/deploy-test-scratch-2026-06-12/` directory (throwaway deploy-test debris). If retained, remove the `additionalDirectories` block or substitute the real workspace-root path.

### Improvement Opportunities

- **[CLAUDE.md Health] Leftover deploy-test scratch CLAUDE.md in output/**
  `output/deploy-test-scratch-2026-06-12/CLAUDE.md` is a byte-identical copy of the canonical workflow template (`workflows/research-workflow/CLAUDE.md`) left behind by a deploy test on 2026-06-12. It contains only unresolved `{{PLACEHOLDER}}` tokens and would be auto-loaded as project context if any session opened that scratch directory. A housekeeping artifact, not a size/import/secret problem.
  *Location:* `output/deploy-test-scratch-2026-06-12/CLAUDE.md`
  *Recommendation:* Delete the `deploy-test-scratch-2026-06-12/` directory so the scratch template cannot load as live project context. Keep the canonical copy under `workflows/research-workflow/`.

- **[Skill Inventory] 7 skills exceed 300 lines (none exceed 500)**
  Bodies over the 300-line advisory threshold: answer-spec-generator (476), research-plan-creator (476), cluster-memo-refiner (438), ai-resource-builder (433), ai-prose-decontamination (393), evidence-to-report-writer (373), handoff (324). None exceed the 500-line restructuring threshold; average body length is 204.5 lines.
  *Location:* `skills/{answer-spec-generator,research-plan-creator,cluster-memo-refiner,ai-resource-builder,ai-prose-decontamination,evidence-to-report-writer,handoff}/SKILL.md`
  *Recommendation:* Consider moving reference material (rubrics, examples, schemas) into per-skill `references/` files to keep the always-loaded SKILL.md body lean. Advisory only.

- **[Skill Inventory] 3 descriptions lack explicit exclusion clauses**
  workflow-creator, workflow-documenter, and workspace-template-extractor state trigger conditions but no "Do NOT use for" / exclusion clause. (workflow-consultant was auto-flagged but is a false positive — its description ends "Does NOT produce formal workflow designs, hand-off contracts, or documentation.")
  *Location:* `skills/{workflow-creator,workflow-documenter,workspace-template-extractor}/SKILL.md`
  *Recommendation:* Add a short "Do NOT use for:" clause to each description to sharpen routing against the adjacent workflow-* skills.

- **[Skill Inventory] 7 orphaned skills (no command/agent/CLAUDE.md invokes them by name)**
  claude-code-workflow-builder, fund-triage-scanner, journal-thinking-clarifier, journal-wiki-improver, knowledge-file-completeness-qc, workflow-consultant, workspace-template-extractor appear in no `.claude/commands`, `.claude/agents`, CLAUDE.md, or other SKILL.md (they surface only in CATALOG.md, historical audit reports, and inbox notes). Several are likely reached via description-based model routing or a workflow rather than a named command.
  *Location:* `skills/{claude-code-workflow-builder,fund-triage-scanner,journal-thinking-clarifier,journal-wiki-improver,knowledge-file-completeness-qc,workflow-consultant,workspace-template-extractor}/`
  *Recommendation:* Confirm each orphan is reachable via model-invocation routing or a workflow; retire any that are genuinely dead. Advisory — several may be intentionally standalone.

- **[Skill Inventory] jargon-gloss uses a non-canonical model/effort pairing (opus/medium)**
  All 80 skills declare valid `model:`/`effort:` values; 79 use a canonical pair. jargon-gloss is the sole outlier at opus/medium. Its task is a single-pass in-place glossing rewrite with domain judgment about which terms need glossing.
  *Location:* `skills/jargon-gloss/SKILL.md`
  *Recommendation:* Review the pairing: if term-selection judgment justifies Opus, raise effort to high (opus/high); if it is largely structured single-pass execution, move to sonnet/medium. Advisory only.

- **[Commands & Subagents] Leftover deploy-test scratch directory holds 31 command + 4 agent copies**
  `output/deploy-test-scratch-2026-06-12/.claude/{commands,agents}/` is a stale test-deployment of the research-workflow (~1 month old) containing 31 command and 4 agent files as real copies. Of the 11 command basenames that collide with the canonical set, one (update-claude-md.md) is byte-identical to the canonical version and the other 10 diverge (workflow-specific). Because a deployment target intentionally receives real copies rather than symlinks, this is expected deployment behavior, not a maintenance defect.
  *Location:* `output/deploy-test-scratch-2026-06-12/.claude/`
  *Recommendation:* Remove the stale deploy-test scratch directory rather than symlink its files back to canonical. It is disposable test output.

- **[Commands & Subagents] Usage-line convention does not apply to this repo's commands**
  The audit's convention check expects a first-line `Usage:` marker, but only 3 of 90 canonical commands carry one; the repo standardizes on YAML-frontmatter + prose slash-command format (the modern Claude Code style). 71 of 90 commands reference `$ARGUMENTS` where they accept input, and all inspected commands contain procedural steps. Absent `Usage:` lines are a convention mismatch with the audit spec, not a defect.
  *Location:* `.claude/commands/`
  *Recommendation:* No action. Do not flag absent `Usage:` lines as defects for this repo; the frontmatter+prose format is the intended convention.

- **[Settings & Permissions] Redundant narrow Bash allow entries in settings.local.json**
  `settings.local.json` grants four hyper-specific Bash commands (mkdir audits/risk-checks, ls a risk-check agent path, bash -n a hook, cp a hook into a project) — leftover auto-accumulated session approvals. All four referenced paths exist, but every entry is already covered by the parent `Bash(*)` allow and `defaultMode=bypassPermissions`. They grant nothing beyond what is already allowed.
  *Location:* `.claude/settings.local.json`
  *Recommendation:* Clear the allow array (or delete `settings.local.json`). The entries are inert noise under bypassPermissions + `Bash(*)`.

- **[Settings & Permissions] Deny guardrail references a non-existent root archive/ directory**
  The deny entry `Read(archive/**)` targets a top-level `archive/` directory that does not exist at the repo root. This is a protective deny guardrail, not an access grant, so it is harmless — it matches nothing today and would activate only if such a directory were created. (The adjacent `Read(inbox/archive/**)` deny does map to a real directory.)
  *Location:* `.claude/settings.json` (Read(archive/**))
  *Recommendation:* Optional cleanup: drop `Read(archive/**)` if no root-level `archive/` is planned, or leave it as a forward-looking guardrail. No functional impact either way.

- **[Settings & Permissions] Redundant within-file deny pattern (subset duplication)**
  Two deny patterns overlap: `Read(logs/*-archive-*.md)` is fully contained by `Read(logs/*archive*.md)` — anything the former matches, the latter also matches. The narrower pattern is unnecessary duplication.
  *Location:* `.claude/settings.json`
  *Recommendation:* Remove the redundant `Read(logs/*-archive-*.md)`; the broader `Read(logs/*archive*.md)` already covers it.

- **[2026 Best Practices] Compound cross-auditor signal collapses to one gitignored scratch dir**
  The single directory `output/deploy-test-scratch-2026-06-12/` is independently flagged by three Wave-1 auditors: claude-md (leftover CLAUDE.md with unresolved tokens), command (31 command + 4 agent copies), and settings (rated Important for the unsubstituted `{{WORKSPACE_ROOT}}` token). Cross-cutting verification shows the directory is both gitignored and untracked (0 tracked files) — disposable local state that was never in the repo. The severity collapses: the settings-auditor's Important placeholder poses no real permission risk because the file is throwaway and unshared. This is one housekeeping deletion, not a systemic defect.
  *Location:* `output/deploy-test-scratch-2026-06-12/`
  *Recommendation:* Delete `output/deploy-test-scratch-2026-06-12/`. Optionally add a deploy-test cleanup step (or a scratch-dir TTL sweep in `/friday-checkup`) so future `/deploy-workflow` tests self-clean and do not re-accumulate flaggable scratch state.

- **[2026 Best Practices] scope-synthesis-agent runs sonnet on genuine synthesis work (advisory)**
  scope-synthesis-agent (Stage 2 of `/scope-project`) does analytical consolidation — dedupe, theme separation, flagging weak/overbuilt material, surfacing contradictions — which the workspace's tiering doctrine (analytical → opus) would nominally place on opus. It is assigned sonnet. This is most likely deliberate: it is a consolidation front-end feeding opus-tier downstream stages (scope-architecture-agent and scope-qc-evaluator are both opus), so the analytical judgment is backstopped. (risk-check-reviewer, also sonnet, is an explicit logged cost exception and is not flagged.)
  *Location:* `.claude/agents/scope-synthesis-agent.md`
  *Recommendation:* No change required. If `/scope-project` synthesis is ever judged shallow, promote this one agent to opus; otherwise the sonnet tiering is a reasonable cost choice given the opus QC downstream.

- **[Context Health] risk-check command + reviewer agent co-changed — spot-check the pair still agrees**
  Recent-change scan: `.claude/commands/risk-check.md` and `.claude/agents/risk-check-reviewer.md` were both modified in commit c3c0334 ("the gates now grade the premise"), and risk-check.md again in 3179771. The command spawns the reviewer agent; both moved together, so the reference is intact. Informational post-change note.
  *Location:* `.claude/commands/risk-check.md` ; `.claude/agents/risk-check-reviewer.md`
  *Recommendation:* Read the spawn block in risk-check.md against risk-check-reviewer.md's task section once; no action expected — both changed in the same commit.

- **[Context Health] qc-reviewer agent changed — referenced by 6 commands, verify none drifted**
  Recent-change scan: `.claude/agents/qc-reviewer.md` changed in commit c3c0334. It is spawned by 6 commands (qc-pass, friday-journal, refinement-deep, cleanup-worktree, pm, list-critical-resources). All references resolve; no broken link found. Informational.
  *Location:* `.claude/agents/qc-reviewer.md`
  *Recommendation:* If the qc-reviewer rubric/output shape changed, skim the 6 consumer commands for stale expectations.

- **[Context Health] wrap-session command + session-feedback-collector agent co-changed — consistent**
  Recent-change scan: `.claude/commands/wrap-session.md` (commits 3179771, 8de46fd) and its sole consumer-agent `.claude/agents/session-feedback-collector.md` (8de46fd) changed together. wrap-session Step 6.5 spawns the collector; reference intact. Informational.
  *Location:* `.claude/commands/wrap-session.md` ; `.claude/agents/session-feedback-collector.md`
  *Recommendation:* No action needed; noting the coupled edit for post-change spot-check.

- **[Context Health] sentinel-hook-probe.sh churned in recent commits then removed — now absent and unreferenced**
  Recent-change scan: `.claude/hooks/sentinel-hook-probe.sh` appears in commits 3179771 and 8de46fd but does not exist on disk, is not git-tracked, and is referenced by no settings.json, hook, or command. Its removal appears intentional (commit 3179771: "the installer split out on RECONSIDER"). No broken cross-reference results because nothing points to it.
  *Location:* `.claude/hooks/sentinel-hook-probe.sh` (absent)
  *Recommendation:* Confirm the probe's removal was intended (it appears so). If any doc still names it, update; grep found none.

## Detailed Analysis

### File Organization
File organization under the ai-resources repo is healthy. All expected directories are present (`.claude/` with `commands/` + `settings.json`, `skills/`, `CLAUDE.md`, plus `workflows/`, `projects/`, `docs/`, `logs/`, `templates/`, `inbox/`). All 81 symlinks resolve to readable targets with zero broken. All 80 skill directories are lowercase kebab-case and each contains a SKILL.md; all three CLAUDE.md files sit at expected roots. No Critical, Important, or Minor issues. Key metrics: 80 skill dirs, 81 symlinks (0 broken), 3 CLAUDE.md files.

### CLAUDE.md Health
Three CLAUDE.md files found; all pass size limits — the largest is 155 lines / ~2,148 tokens, well under the 200-line / 4,000-token Important threshold. Per-file line counts: root `CLAUDE.md` 77 lines (~1,196 tokens); `workflows/research-workflow/CLAUDE.md` 155 lines (~2,148 tokens); `output/deploy-test-scratch-2026-06-12/CLAUDE.md` 155 lines (~2,148 tokens). Each has a top-level heading and an orientation section, none use `@import`/`@file` directives, and none contain dead references, secret patterns, or cross-level contradictions. The only issue is a Minor housekeeping item: a leftover deploy-test scratch copy in `output/` that would load as context if that directory were opened.

### Skill Inventory
All 80 skills are structurally sound: every folder has a SKILL.md with non-empty `name`/`description` and a valid `model:`+`effort:` pair, no description is too short, and internal-reference integrity is clean (87 referenced paths resolve on disk; the only 4 unresolved are documentation table-rows/examples in the `ai-resource-builder` meta-skill). Zero skills missing tier frontmatter. Four Minor advisories: 7 skills over 300 lines (none over 500; average 204.5), 3 descriptions missing exclusion clauses, 7 orphaned skills (likely model-routed rather than command-invoked), and one non-canonical tier pairing (jargon-gloss opus/medium). No trigger-overlap pair exceeds the 60% threshold (top pair 0.42: editorial-recommendations-generator ↔ editorial-recommendations-qc).

### Commands & Subagents
Commands and subagents are structurally healthy: 152 command files (90 canonical ai-resources, 31 research-workflow, 31 in the leftover deploy-test scratch dir) and 50 agent files, with zero dead references. All 4 command symlinks are live and point into the canonical `.claude/commands/` dir (intentional shared commands); there are no agent symlinks. All 50 agents carry complete frontmatter (name/description/tools/model). Name collisions total 18 — 17 intentional workflow/deployment overrides plus 1 byte-identical deployment copy (`name_collisions_drift`=1), none requiring a fix. Two informational notes verified clean: friday-checkup's two external project-scoped agents (doc-scanner-agent, principles-checker-agent) exist and are existence-guarded; the research-workflow command overrides are intentional. The only cleanup signal is the stale deploy-test scratch directory.

### Settings & Permissions
All 5 settings files are valid JSON with well-formed `permissions` objects, and every referenced hook script exists on disk (9/9 in the root config, plus all template/scratch hooks and both walk-up SessionStart scripts). No hook uses a hardcoded absolute path — all use `$CLAUDE_PROJECT_DIR`. The one Important item is an unsubstituted `{{WORKSPACE_ROOT}}` placeholder used as an `additionalDirectory` in the throwaway deploy-test-scratch settings file (confined to disposable, gitignored, untracked state). Three Minor items cover redundant/leftover permission entries (redundant narrow Bash allows in settings.local.json, a deny for a non-existent root `archive/`, and a subset-duplicated deny pattern). Broad `Bash(*)` (4 files) and `defaultMode=bypassPermissions` are the operator's agreed baseline, reported informationally.

### 2026 Best Practices
The workspace is a mature, self-governing Claude Code environment that meets or exceeds 2026 best practices. Verified compliant: subagent isolation (dedicated context-isolated evaluator agents — qc-reviewer, refinement-reviewer, triage-reviewer, reconcile-reviewer, scope-qc-evaluator, expert-check-reviewer, risk-check-reviewer — QC never runs inline), context isolation (qc-pass explicitly excludes conversation/reasoning/creation context), and filesystem-first verification (all 10 git status/diff usages are delta/staging/orientation, never write-verification). No literal `@import` syntax is used, but lean-core CLAUDE.md files (77/155 lines) pair with a conditional doc-load pattern that achieves the same modularity at lower token cost. Counts: 90 commands, 80 skills, 42 agents, 19 hooks (4 events, all mechanical/nudge). Maturity signals include a well-calibrated 3-tier model system, a consistent notes-to-disk subagent contract, a full session-ritual suite, and dense error-driven CLAUDE.md provenance. The only cross-cutting issue is the compound three-auditor signal that resolves to the single gitignored scratch directory — a single deletion, not a systemic defect. A second Minor advisory notes scope-synthesis-agent runs sonnet on synthesis work (likely intentional, backstopped by opus QC downstream).

### Context Health
Cross-reference integrity is intact across the target. Every skill referenced by CLAUDE.md, by the 90 commands, and by the 41 research-workflow pipeline skill-paths resolves to an existing `skills/{name}/SKILL.md` (54 distinct skill references checked, 0 dead, 0 description mismatches). All 34 command-to-skill/agent references resolve (0 dead); the only non-local names are the two existence-guarded external agents (doc-scanner-agent, principles-checker-agent), both confirmed present. Apparent misses (skills/skill, skills/old-skill-name, agents/agent.md, agents/strategic-critic.md, pipeline-stage-) are documentation placeholders/truncations, not live links. All 15 hook scripts across the 5 settings files exist and are executable (0 missing). No Critical or Important findings. The four Minor items are informational post-change spot-check notes from the recent-commit scan (12 high-impact files traced): the co-changed risk-check command/reviewer pair, the qc-reviewer agent (6 consumers), the co-changed wrap-session/session-feedback-collector pair, and the intentionally-removed `sentinel-hook-probe.sh`.

## Prioritized Recommendations

1. **Delete `output/deploy-test-scratch-2026-06-12/`.** — Clears the single Important finding (unsubstituted `{{WORKSPACE_ROOT}}` placeholder) plus two Minor items (leftover CLAUDE.md, 31 command + 4 agent scratch copies) in one action. The directory is gitignored, untracked, disposable test output — no repo risk. Effort: Low. Area: Settings & Permissions / File Organization.
2. **Add a deploy-test cleanup step or scratch-dir TTL sweep to `/friday-checkup`.** — Prevents future `/deploy-workflow` tests from re-accumulating flaggable scratch state, closing the loop that produced this cycle's only Important finding. Effort: Low–Medium. Area: 2026 Best Practices.
3. **Clean up redundant settings entries.** — Clear the four inert narrow `Bash(...)` allows in `settings.local.json`, drop the deny for the non-existent root `archive/`, and remove the subset-duplicated `Read(logs/*-archive-*.md)` deny. Cosmetic hygiene under bypassPermissions + `Bash(*)`. Effort: Low. Area: Settings & Permissions.
4. **Review the 7 orphaned skills.** — Confirm each (claude-code-workflow-builder, fund-triage-scanner, journal-thinking-clarifier, journal-wiki-improver, knowledge-file-completeness-qc, workflow-consultant, workspace-template-extractor) is reachable via model-routing or a workflow; retire any that are genuinely dead. Effort: Medium. Area: Skill Inventory.
5. **Tighten skill descriptions and trim oversized bodies.** — Add "Do NOT use for" exclusion clauses to the 3 workflow-* skills, review jargon-gloss's opus/medium pairing, and consider moving reference material out of the 7 SKILL.md bodies over 300 lines into `references/` files. Effort: Low–Medium. Area: Skill Inventory.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
