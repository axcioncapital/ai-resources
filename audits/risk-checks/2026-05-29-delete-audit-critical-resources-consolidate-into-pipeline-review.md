# Risk Check — 2026-05-29

## Change

Delete /audit-critical-resources canonical command, its critical-resource-auditor agent, and the critical-resources-manifest.md. Fold the command's unique signal — currency-check against three pinned Anthropic doc URLs (`https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview`, `https://code.claude.com/docs/en/skills`, `https://code.claude.com/docs/en/memory`) — into the pipeline-review-auditor's Brokenness section.

Add 3 new entries to pipeline-review-registry.md (the registry shipped in commit e557915 with 14 rows): `friction-log` (command), `cleanup-worktree` (command), `token-audit` (command). These were in the deleted manifest as critical resources but are not multi-step orchestrators in the strict sense the registry was scoped to. Adding them preserves coverage that would otherwise drop.

Then clean up the symlink topology:
- 14 projects each have a project-local symlink to both `.claude/commands/audit-critical-resources.md` and `.claude/agents/critical-resource-auditor.md` (auto-synced from ai-resources at SessionStart).
- 1 knowledge-base (`knowledge-bases/pe-kb-vault/`) has the same symlinks.
- 2 workspace-root symlinks at `.claude/commands/audit-critical-resources.md` and `.claude/agents/critical-resource-auditor.md`.
All become broken on canonical removal. Cleanup is `find … -path '*/.claude/{commands,agents}/audit-critical-resources.md' -o -path '*/.claude/{commands,agents}/critical-resource-auditor.md'` then `rm -i` after confirmation that each is a symlink (not a regular file the project edited independently).

Update 9 active doc references (text mentions, not symlinks):
1. `ai-resources/CLAUDE.md` — remove the line about `/audit-critical-resources` under Maintenance Cadence (added earlier this session as a pointer).
2. `ai-resources/docs/operator-maintenance-cadence.md` — same removal in the corresponding section.
3. `ai-resources/docs/repo-architecture.md` — update the manifest entry in Q8 to remove the critical-resources-manifest line, and any nearby reference to the audit command.
4. `ai-resources/.claude/agents/pipeline-review-auditor.md` — replace the "distinct from /audit-critical-resources" framing with the now-correct "subsumed /audit-critical-resources" framing; add the 3 pinned Anthropic doc URLs and currency-check logic to the Brokenness section.
5. `ai-resources/.claude/commands/pipeline-review.md` — same framing update.
6. `ai-resources/audits/pipeline-review-registry.md` header — same framing update.
7. `projects/axcion-ai-system-owner/references/toolkit-relationship.md` — remove the entry that describes /audit-critical-resources as a toolkit item. This is a System Owner grounding doc — high care.
8. `ai-resources/inbox/audit-workflow-pipeline.md` — review and update or note as historical.
9. `ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md` — update if it references the command as a current resource.

Past audit reports, repo-dd reports, project pipeline snapshots, repo-documentation vault, and historical session-notes that mention the command will NOT be edited — they are point-in-time documents.

Reason for deletion: /audit-critical-resources has been run exactly once since it was built (the 2026-05-25 report). /pipeline-review covers the same critical-resource population with richer output. Folding the currency-check preserves the only piece of unique signal. Operator has confirmed option 3 (consolidate, not park).

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/audit-critical-resources.md` — exists (to be deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/critical-resource-auditor.md` — exists (to be deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/critical-resources-manifest.md` — exists (to be deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/operator-maintenance-cadence.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-review-auditor.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/pipeline-review.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-review-registry.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/toolkit-relationship.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/inbox/audit-workflow-pipeline.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/audit-critical-resources.md` — exists (workspace symlink)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/agents/critical-resource-auditor.md` — exists (workspace symlink)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Consolidation is well-scoped and the operator-named active-reference list captures most of the surface, but blast radius is large (32 symlinks, 9+ active doc edits, plus one omitted active-reference file the change description missed), and the cleanup is multi-step manual with reversibility friction that warrants paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Net direction is *reduction*: a command + agent + manifest are deleted; an always-loaded line in `ai-resources/CLAUDE.md` (lines 49–53, the Maintenance Cadence section currently names both `/friday-checkup` and `/pipeline-review` and a recently-added `/audit-critical-resources` pointer per the description) is removed. Evidence: `ai-resources/CLAUDE.md:53` references `/audit-critical-resources` in the pipeline-review pointer block.
- The currency-check folded into `pipeline-review-auditor.md` adds ~10–25 lines to that agent body (three pinned URLs + small fetch-on-failure handling), but the agent is only spawned by `/pipeline-review` (operator-invoked weekly, max 3 picks per cycle) — pay-as-used, not always-loaded. Evidence: `ai-resources/.claude/commands/pipeline-review.md:7` ("Operator-invoked weekly").
- No new auto-load hook, no SessionStart registration, no broadened skill trigger.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` rule additions in any `settings.json` are named or implied by the change.
- The cleanup `find … rm -i` runs in the operator's shell, not as an automated capability addition. `rm -i` is interactive — the operator confirms each removal.
- Auto-sync hook (`ai-resources/.claude/hooks/auto-sync-shared.sh`) explicitly *does not overwrite existing files*, including broken symlinks (per `ai-resources/docs/repo-architecture.md:130` sync rule 1). Post-cleanup, the hook will not re-create the symlinks because the canonical source is gone. No permission widening.

### Dimension 3: Blast Radius
**Risk:** High

Enumeration (grepped against `ai-resources/` and the wider workspace, excluding `audits/working/` and `audits/risk-checks/`):

- **Symlinks to remove (confirmed via `find -type l`):** 32 total — 14 projects × 2 (command + agent) = 28, plus `knowledge-bases/pe-kb-vault/.claude/{commands,agents}/` × 2 = 2, plus workspace root × 2 = 2. Matches the change description count exactly.
- **Active doc references (text mentions, current):** the change description lists 9. Verified grep against `ai-resources/` and `projects/` surfaces one **additional active-reference file the change description did NOT name**:
  - `ai-resources/docs/agent-tier-table.md:17` — `| critical-resource-auditor | opus | Judgment (multi-dimension resource audit). Added 2026-04-27. |` — this is a live agent-tier table consulted when authoring agents. Leaving the row in points readers at a deleted agent.
- **Logs with point-in-time mentions** (not edited per the change description, correct posture): `ai-resources/logs/innovation-registry.md:76-77` (graduation entries from 2026-04-24), session-notes-archive-* files. These are historical and correctly left alone.
- **Past audit reports (correctly excluded):** the 2026-05-25 `audit-critical-resources-2026-05-25.md` exists at `ai-resources/audits/` — point-in-time, left untouched per the change description.
- **Project pipeline snapshots** (per grep): 11 files under `projects/*/pipeline/repo-snapshot.md` reference the command. These are snapshots — leaving them alone is correct; they will go stale on next regeneration cycle and self-heal.
- **System Owner load-bearing doc:** `projects/axcion-ai-system-owner/references/toolkit-relationship.md:38` lists `/audit-critical-resources` as a coexist-mechanism toolkit item. The change description correctly flags this as "high care." Per the toolkit's Section 5 Maintenance Rule, this file's update is operator-owned.
- **`ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1121.md`** mentions the command — current fix-plan, not historical. Should be reviewed.

Contract changes:
- `pipeline-review-auditor.md` Brokenness section grows to absorb currency-check. This is a behavioural extension — existing `/pipeline-review` callers (operator-invoked, no programmatic dependents) absorb it transparently. Backwards-compatible.
- `audits/pipeline-review-registry.md` grows from 14 to 17 rows. Per the registry contract at `pipeline-review.md:19` ("5 columns, fixed"), shape is preserved — pure append.
- Symlink target removal breaks the `auto-sync-shared.sh` contract only in the negative direction: the hook silently *will not* recreate links it does not see in `ai-resources/.claude/`. No code change needed in the hook, but the change *relies on* this behaviour.

### Dimension 4: Reversibility
**Risk:** High

- Canonical file deletion is `git revert`-friendly *for the three deleted files alone*. But the cumulative change is not a single-file edit:
  - 32 symlink removals via `rm -i` operate outside the `ai-resources/` git scope for the workspace root and `knowledge-bases/pe-kb-vault/`. Each project that holds the symlinks IS its own sub-repo (per `ai-resources/docs/repo-architecture.md:23, 78`). Reverting would require coordinated revert-or-recreate across 14 project repos + 1 KB + workspace root — at minimum a multi-commit operation, more realistically a one-by-one walk because the original symlink targets (the canonical files) would also have to be restored first.
  - However, since `auto-sync-shared.sh` runs SessionStart and recreates symlinks for any canonical file it finds, if the canonical files were git-reverted on the ai-resources side, the symlinks *would* be recreated automatically on the next SessionStart in each project — IF the cleanup did not delete project-side files that were never symlinks (the change description's "confirmation that each is a symlink (not a regular file the project edited independently)" check is the load-bearing mitigation).
- Registry write (`pipeline-review-registry.md` +3 rows) is audit-trail-grade per `pipeline-review.md:23` ("Writes are audit-trail-grade. Registry and memo writes are not cleanly git revert-able"). The +3 rows are clean to revert in isolation, but bundled with the deletion they layer cleanup steps.
- Toolkit-relationship.md edit in the System Owner project (`projects/axcion-ai-system-owner/`) lives in a separate sub-repo with its own commit boundary.
- No external/network state changes. No push-beyond-local. No automation will fire between landing and a hypothetical revert (auto-sync only re-creates from canonical → project; canonical deletion stops that direction).

Net: rollback is achievable but requires at least 3 coordinated revert steps (ai-resources canonical + workspace root + 14 project repos + 1 KB) plus a SessionStart pass to re-sync, plus a registry edit to drop the 3 added rows. Not "one `git revert` and done."

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Auto-sync hook behaviour assumption (named).** The change relies on `auto-sync-shared.sh` not recreating broken symlinks after the canonical source is removed. This is documented at `ai-resources/docs/repo-architecture.md:130` (sync rule 1). The coupling is named — Medium, not High.
- **System Owner toolkit-relationship maintenance rule.** The toolkit-relationship doc explicitly states (Section 5) it must be reviewed "whenever a new workspace command ships." Deletion is the symmetric case; the maintenance rule should fire on removal too, and the change description flags this correctly. Coupling documented at the change site.
- **Folding currency-check into pipeline-review-auditor changes its contract surface.** The auditor's Brokenness section currently covers stale doc references and contract drift (line 95-101 of `pipeline-review-auditor.md`). Adding pinned URL fetches and 3-URL currency-checks expands the agent's tool surface (it must now use `WebFetch` per the deleted `critical-resource-auditor.md:5-13` tool list). Current `pipeline-review-auditor.md:5` declares `tools: Read, Bash, Glob, Grep, Write` — **`WebFetch` is not in the tool list**. This is a hidden requirement of the fold-in: the agent's frontmatter `tools:` line must be updated, or the currency-check silently fails at runtime. Not surfaced in the change description.
- **`agent-tier-table.md:17` row stale after deletion** — discussed in Dimension 3; this is a coupling between an active reference doc and the deleted agent.
- **Pipeline-review-registry contract.** Adding 3 non-multi-step-orchestrator commands (`friction-log`, `cleanup-worktree`, `token-audit`) to a registry whose existing rows are all multi-step orchestrators (per existing 14 entries: `create-skill`, `improve-skill`, `friday-checkup`, etc.) slightly broadens the registry's implicit scope. The change description acknowledges this trade-off explicitly ("not multi-step orchestrators in the strict sense"). The registry's header comment at `pipeline-review-registry.md:3` should be updated to reflect the broader scope, or new readers will misclassify the additions as orchestrators.

## Mitigations

- **Dimension 3 (Blast radius):** add `ai-resources/docs/agent-tier-table.md:17` to the active-edit list (remove the `critical-resource-auditor` row). Also scan `ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1121.md` for any current-state mention of `/audit-critical-resources` and update or annotate as historical.
- **Dimension 4 (Reversibility):** before the canonical delete, run a *dry-run pass* of the symlink cleanup that lists every path and confirms `[ -L "$path" ]` for each — emit a single summary block (`N confirmed symlinks; M skipped non-symlinks`). Do not interactively delete one-by-one; instead, after the dry-run report, run a single batched `rm` over the confirmed-symlink list. Record the dry-run report at `ai-resources/audits/symlink-cleanup-2026-05-29.md` so a future revert has a list of paths to recreate from.
- **Dimension 5 (Hidden coupling):** update `pipeline-review-auditor.md` frontmatter `tools:` (line 5) to include `WebFetch` as part of the fold-in. Without this, the currency-check inherits an "incomplete — tool not available" failure path on every `/pipeline-review` run. Also update the `pipeline-review-registry.md` header (line 3) to note the registry's broadened scope (multi-step orchestrators + critical lightweight commands), so the next operator does not interpret the 3 new rows as a misclassification.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts across `ai-resources/`, `projects/`, `knowledge-bases/`, `workflows/`, and workspace root; symlink enumeration via `find -type l`; verbatim quotes from `ai-resources/CLAUDE.md`, `pipeline-review.md`, `pipeline-review-auditor.md`, `critical-resource-auditor.md`, `repo-architecture.md`, `toolkit-relationship.md`, and `agent-tier-table.md`). No training-data fallback was used.
