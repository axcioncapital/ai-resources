# Risk Check — 2026-07-13

## Change

Change the shared SessionStart hook `ai-resources/.claude/hooks/auto-sync-shared.sh` so that its baked-in EXCLUDE_COMMANDS list (currently: new-project deploy-workflow run-sufficiency pipeline-review scope-project lean-repo) is NOT applied when the hook is running at the Axcíon AI workspace root — i.e. when the directory being synced is the one where `ai-resources/` is a DIRECT child, rather than an ancestor's child.

Motivation / bug being fixed: `/new-project` returns "Unknown command" at the workspace root. The exclusion list is documented as keeping ai-resources-meta commands out of "downstream projects", but the hook treats the workspace root as just another project (the root has its own `.claude/shared-manifest.json`), so it applies the exclusion there too. The result contradicts `/new-project`'s own documented contract at `.claude/commands/new-project.md:17`, which states that running from the workspace root IS valid and that only running from inside `ai-resources/` is blocked. Same contradiction affects deploy-workflow, pipeline-review, scope-project, and lean-repo.

Current state evidence:
- Workspace root has 87 command symlinks; ai-resources has 89 command files.
- Missing at root: new-project.md, deploy-workflow.md, pipeline-review.md, scope-project.md, lean-repo.md.
- Also stale at root (broken symlinks, sources deleted from ai-resources): audit-critical-resources.md, diagnostics-plan.md, route-change.md — out of scope for this change, noted separately.
- EXCLUDE_COMMANDS is at auto-sync-shared.sh:46. The EXCLUDE_AGENT_GLOBS list (line 47: `pipeline-stage-* session-guide-generator pipeline-review-* scope-*`) is the agent-side equivalent and would likely need the same treatment, since /new-project delegates to pipeline-stage-* agents — ASSESS whether the agent exclusions must also be lifted at root for /new-project to actually RUN there, not just be visible in the command menu.
- The hook already contains a walk-up idiom to locate ai-resources (lines 33-43); the workspace-root test would reuse the same shape.
- ADDITIONAL FINDING: `run-sufficiency` appears in EXCLUDE_COMMANDS but `.claude/commands/run-sufficiency.md` does not exist — the exclusion list carries at least one stale entry. Factor this into your hidden-coupling / principle-alignment scoring (the list is manually maintained and has already drifted).

Blast radius to assess: this hook runs on SessionStart in EVERY project and at the workspace root. Assess whether lifting the exclusion at root could cause meta-commands to be invoked in the wrong context, whether the root is genuinely the intended home for these commands, and whether the CWD guards inside those commands are sufficient protection on their own. Read each of the five excluded commands and check what CWD/scope guard (if any) each one actually has — do not assume they all have one like /new-project does. A command with NO guard becoming newly visible at root is a materially different risk from one with a guard.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/pipeline-review.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope-project.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/lean-repo.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/run-sufficiency.md — not yet present (STALE EXCLUSION ENTRY; the only `run-sufficiency.md` in the repo lives at `ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md`, a different directory tree the hook's loop never scans — confirms the stale-entry finding)
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/.claude/shared-manifest.json — exists (workspace root manifest; `commands.local: []`, `agents.local: []` — confirms the hook's precondition `[ -f "$MANIFEST" ]` is already satisfied at root today)
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists (22,637 bytes; documents the hook's exclusion contract at line 135)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The core fix (exempt EXCLUDE_COMMANDS at workspace root) is narrow, well-evidenced, and closes a real documented-contract violation, but as literally scoped it only fixes command-menu visibility — 3 of the 5 newly-exposed commands (new-project, pipeline-review, scope-project) delegate to subagents still blocked by the untouched EXCLUDE_AGENT_GLOBS list, so without a paired agent-side fix the change trades today's honest "Unknown command" failure for a later, silent mid-pipeline spawn failure.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/settings.json` (workspace root) | invokes | no |
| `ai-resources/workflows/research-workflow/.claude/settings.json` | invokes | no |
| `.claude/shared-manifest.json` (workspace root) | co-edits (precondition read by the hook) | no — already correctly configured |
| `ai-resources/.claude/commands/fix-symlinks.md` | parses (sed-reads `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` literal lines, fix-symlinks.md:81-82) | no — its scan scope is `projects/*/` only (fix-symlinks.md:7, "Does not scan ... ai-resources/ itself"), so the root-only exemption doesn't touch its output; format-fragility risk noted under Hidden Coupling |
| `ai-resources/docs/repo-architecture.md` | documents (line 135 states the exclusion as an absolute, context-free rule) | yes — becomes stale/inaccurate once a root exception exists |
| `ai-resources/.claude/commands/new-project.md` | invokes (Step 5 initial sync) + documents + is a change target | no (own CWD guard, lines 13-17, already matches the fix's intent) |
| `ai-resources/.claude/commands/deploy-workflow.md` | is a change target (unguarded) | no — no subagent dependency, would work fully once command-visible at root |
| `ai-resources/.claude/commands/pipeline-review.md` | is a change target (unguarded) | no |
| `ai-resources/.claude/commands/scope-project.md` | is a change target (unguarded) | no |
| `ai-resources/.claude/commands/lean-repo.md` | is a change target (unguarded) | no — its only delegate agent (`lean-repo-auditor`) is not excluded (see below), so it already works |
| `ai-resources/.claude/agents/pipeline-stage-3a.md` … `-5.md`, `session-guide-generator.md` | invokes (new-project.md:21-26, 186, 193 spawn these by name) but blocked by `EXCLUDE_AGENT_GLOBS` (`pipeline-stage-*`, `session-guide-generator`) | yes, if `/new-project` must actually complete a pipeline stage from workspace root, not just appear in the menu |
| `ai-resources/.claude/agents/pipeline-review-auditor.md` | invokes (pipeline-review.md:125) but blocked by `EXCLUDE_AGENT_GLOBS` (`pipeline-review-*`) | yes, same condition |
| `ai-resources/.claude/agents/scope-synthesis-agent.md`, `scope-architecture-agent.md`, `scope-qc-evaluator.md` | invokes (scope-project.md:47, 51, 68) but blocked by `EXCLUDE_AGENT_GLOBS` (`scope-*`) | yes, same condition |
| `ai-resources/.claude/agents/lean-repo-auditor.md` | invokes (lean-repo.md:49) — does NOT match any `EXCLUDE_AGENT_GLOBS` pattern | no — already synced everywhere today (undocumented asymmetry, noted under Hidden Coupling) |

Total: 14 consumers, 4 must-change (repo-architecture.md doc-staleness + 3 agent-dependency groups conditional on completing the fix's own stated intent). Reference-type key: `invokes` = calls the target, `parses` = reads a marker/format from the target, `documents` = names it in prose, `co-edits` = a paired precondition file.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook already fires on every SessionStart, at the workspace root and in every project (auto-sync-shared.sh header comment, lines 1-2; existing behavior, not added by this change).
- The change adds an internal conditional (reusing the existing walk-up idiom, auto-sync-shared.sh:33-43) — a few extra shell comparisons per session, not a new hook registration or an always-loaded-file token increase.
- No `@import`, no CLAUDE.md content growth, no new subagent spawn cadence.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`deny`/`ask` entries touched. `.claude/settings.json` (workspace root) appears only as an unchanged SessionStart hook registration ("invokes" row in the Consumer Inventory) — the change does not modify that registration.
- No new Bash pattern, Write path, or external API is introduced; the change is confined to bash conditional logic inside an already-permitted, already-executing hook script.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touched: 1 (`auto-sync-shared.sh`).
- Consumer Inventory (Step 1.5) found 14 distinct consumers; 4 are must-change (`repo-architecture.md` doc-staleness, plus the three agent-dependency groups conditional on the change's own motivating intent — see Consumer Inventory table above).
- `fix-symlinks.md` parses the exclusion lists via sed (fix-symlinks.md:81-82) but its scan scope explicitly excludes the workspace root (fix-symlinks.md:7), so it is not a functional must-change — confirmed by reading its Step 1 scope declaration directly.
- The change's own stated motivating bug (`/new-project` "Unknown command" at root) is only fully closed if the EXCLUDE_AGENT_GLOBS half is addressed too — a second, un-scoped edit site in the same file, widening the true blast radius beyond the single list the change names.
- No consumer requires modification to avoid *breaking* (nothing currently depends on the exclusion firing at root the way it does today) — the Medium grade reflects consumer count and doc-staleness, not caller breakage.

### Dimension 4: Reversibility
**Risk:** Medium

- The script edit itself is a single-file change, cleanly `git revert`-able.
- The hook's own idempotency guard (`[ -e "$target" ] || [ -L "$target" ] && continue`, auto-sync-shared.sh:88, 105 — "never overwrites", header comment lines 10-11) means it also never *removes* a prior sync. Once the fix runs once at a workspace-root session start and creates the five (or more, if agents are also unblocked) new symlinks under `<workspace-root>/.claude/commands/` (and possibly `.claude/agents/`), a later `git revert` of the script does not retract those already-created symlinks.
- `fix-symlinks.md` cannot be used to clean this up either, since its scope excludes the workspace root (fix-symlinks.md:7) — cleanup would be a manual `rm` of the newly created symlinks.
- No data/log mutation, no external writes (git push, Notion, API) — the extra step is local and mechanical, consistent with the "Medium" heuristic (one extra cleanup step).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Unaddressed parallel exclusion list.** The change as literally scoped touches only `EXCLUDE_COMMANDS` (auto-sync-shared.sh:46). `EXCLUDE_AGENT_GLOBS` (auto-sync-shared.sh:47: `pipeline-stage-* session-guide-generator pipeline-review-* scope-*`) is untouched. Three of the five newly-exposed commands have a hard runtime dependency on agents this glob still blocks at root: `/new-project` spawns `pipeline-stage-3a`…`-5` and `session-guide-generator` (new-project.md:21-26 Pre-Flight Validation, :186, :193); `/pipeline-review` spawns `pipeline-review-auditor` (pipeline-review.md:125); `/scope-project` spawns `scope-synthesis-agent`, `scope-architecture-agent`, `scope-qc-evaluator` (scope-project.md:47, 51, 68). If the agent-side list is not also exempted at root, these three commands would move from today's *immediate* "Unknown command" failure to a *deferred* subagent-spawn failure mid-pipeline — a materially different, harder-to-diagnose failure shape than the one being fixed. `/deploy-workflow` and `/lean-repo` do not have this exposure (confirmed by direct read: `deploy-workflow.md` has no `Task`/`Agent` delegation at all; `lean-repo.md`'s only delegate, `lean-repo-auditor`, does not match any pattern in `EXCLUDE_AGENT_GLOBS`).
- **Undocumented format contract.** `fix-symlinks.md:81-82` parses `EXCLUDE_COMMANDS`/`EXCLUDE_AGENT_GLOBS` via a sed pattern that requires the literal single-line form `EXCLUDE_COMMANDS="..."`. If the implementation of the root-conditional rewrites this as a computed/conditional value rather than preserving the static line and gating only its *application*, the sed parse silently degrades (fix-symlinks.md:88-91, "WARNING: could not parse... skipping drift+missing scan" — a quiet capability loss, not a loud error) — nothing in the hook file documents this format requirement as load-bearing for a downstream consumer.
- **Already-drifted exclusion list.** The `run-sufficiency` entry in `EXCLUDE_COMMANDS` (auto-sync-shared.sh:46) matches no file the hook's loop ever scans (`"$AI_RESOURCES"/.claude/commands/*.md` — confirmed by grep: the only `run-sufficiency.md` in the repo is under `ai-resources/workflows/research-workflow/.claude/commands/`, a different directory entirely). This is direct evidence the exclusion lists are manually maintained and already stale, which raises the likelihood a new root-conditional edit introduces or perpetuates similar drift without being caught.
- **Undocumented asymmetry.** `lean-repo-auditor` is the only one of the five commands' delegate agents that is *not* covered by `EXCLUDE_AGENT_GLOBS` — it is already synced to every project and to root today. A naive "add the same root-exception to both lists uniformly" implementation could over-apply logic that was never symmetric to begin with.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (confirmed present, read in full).

- **DR-8** (structural changes in gated classes require `/risk-check` — hooks are named explicitly) is being honored, not violated: this hook edit is exactly the DR-8/workspace-CLAUDE.md-Autonomy-Rule-#9 gated class, and it is being risk-checked now.
- **OP-9 / AP-7 / DR-7 (speculative abstraction)** — not triggered. This is not "hooks for Phase 2" or building for an absent consumer; it closes a real, evidenced contradiction between the hook's behavior and `/new-project`'s own documented contract (new-project.md:17). The Consumer Inventory found existing, current consumers (the five commands and their delegate agents already exist and are already invoked), not speculative future ones.
- **OP-3 (loud failure over silent continuation) — tension, not a clear violation.** If the change ships as literally worded (EXCLUDE_COMMANDS only, leaving EXCLUDE_AGENT_GLOBS as an open "ASSESS" question per the change description) without resolving the agent-side half, three of the five newly-exposed commands would trade today's *loud, immediate* failure ("Unknown command") for a *quieter, deferred* failure (menu-visible, then fails mid-pipeline on subagent spawn) — the opposite direction from OP-3's intent. This is graded a tension rather than a violation because the change description itself explicitly surfaces the open question ("ASSESS whether the agent exclusions must also be lifted") rather than silently shipping the half-fix — that act of surfacing is itself the OP-3-aligned behavior. The tension becomes a violation only if the change lands with the agent-side question left unresolved and unacknowledged at ship time.
- No DR-1/DR-3 placement issue (the hook stays in its canonical home) and no OP-10 boundary expansion (no cross-tool coordination involved).

## Mitigations

- **(Hidden Coupling — required)** Extend the same workspace-root conditional to `EXCLUDE_AGENT_GLOBS` (auto-sync-shared.sh:47) for the specific agents each of the five commands actually delegates to (`pipeline-stage-*`, `session-guide-generator` for `/new-project`; `pipeline-review-auditor` for `/pipeline-review`; `scope-*` for `/scope-project`) — not just `EXCLUDE_COMMANDS` — and end-to-end verify from a live workspace-root session that `/new-project`, `/pipeline-review`, and `/scope-project` can each actually spawn their first delegated subagent, not merely appear in the command menu, before calling the fix complete.
- **(Reversibility — Medium)** If the change is later reverted, also manually remove the symlinks the fix creates at `<workspace-root>/.claude/commands/{new-project,deploy-workflow,pipeline-review,scope-project,lean-repo}.md` (and any newly-synced agent symlinks) — a script-only `git revert` will not retract them, since the hook never removes existing targets (auto-sync-shared.sh:88, 105).
- **(Blast Radius / doc staleness — Medium)** Update `ai-resources/docs/repo-architecture.md` line 135 (and the "Symlink topology" section, lines 128-141) in the same change to state the workspace-root exception, so the documented contract does not go stale the moment the code ships.
- **(Principle Alignment — Medium)** Land the `EXCLUDE_COMMANDS` and `EXCLUDE_AGENT_GLOBS` fixes together in one change, not command-only followed by a later, separate agent-side fix — shipping the command-only half in isolation trades today's loud "Unknown command" failure for a silent, deferred pipeline failure for three of the five commands, in tension with OP-3.
- **(Optional, lower priority)** While in the file, consider removing the stale `run-sufficiency` entry from `EXCLUDE_COMMANDS` — it matches no file the hook's loop scans and has no functional effect either way, but leaving it perpetuates the "manually maintained and already drifted" state flagged under Hidden Coupling.
- **(sed-contract safety)** Preserve the exact literal single-line form `EXCLUDE_COMMANDS="..."` / `EXCLUDE_AGENT_GLOBS="..."` as static string declarations (gate only their *application*, not their *assignment*, on the root-conditional) so `fix-symlinks.md`'s sed-based parse (fix-symlinks.md:81-82) continues to succeed without a silent capability loss.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
