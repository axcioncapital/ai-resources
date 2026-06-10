# Risk Check — 2026-06-10

## Change

New skill + new command landing together: skills/technical-solution-consultant/ (SKILL.md + 4 reference files: selection-memo-template.md, build-spec-template.md, example-selection-memo.md, tool-selection-heuristics.md) and .claude/commands/tech-consult.md. Standalone advisory skill (model: opus, effort: high) named technical-solution-consultant, invoked as /tech-consult; produces consultation memos/specs/builder-prompts — advisory output only, no file/external side effects beyond what the operator runs. No hooks, no permission changes, no CLAUDE.md edits, no symlink topology changes, not wired into any orchestrator (explicitly NOT a /new-project stage). The new command tech-consult.md is NOT in the auto-sync EXCLUDE_COMMANDS list, so it auto-symlinks into every project's .claude/commands/ on next session start (same as any other shared command — intended). Also archived the source brief to inbox/archive/technical-solution-consultant-brief.md. End-time gate before commit; the change set is already executed in the working tree.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/technical-solution-consultant/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/technical-solution-consultant/references/selection-memo-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/technical-solution-consultant/references/build-spec-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/technical-solution-consultant/references/example-selection-memo.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/technical-solution-consultant/references/tool-selection-heuristics.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/tech-consult.md — exists

## Verdict

GO

**Summary:** A pay-as-used, advisory-only skill + command pair that follows the established shared-command symlink pattern with no hooks, permission changes, or always-loaded cost — every dimension is Low.

## Consumer Inventory

Search terms: `tech-consult` (command token), `technical-solution-consultant` (skill name), the four reference basenames, and the `EXCLUDE_COMMANDS` auto-sync contract. Grep run across `ai-resources` and the workspace root (`projects/`, root `CLAUDE.md` files), excluding the change's own files.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/tech-consult.md` | invokes (reads `skills/technical-solution-consultant/SKILL.md` and executes the workflow) | no |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` (line 46 `EXCLUDE_COMMANDS`) | parses (walks `commands/*.md`; `tech-consult` not excluded → auto-symlinks) | no |
| 15 projects with `.claude/shared-manifest.json` (e.g. `strategic-os`, `axcion-ai-system-owner`, `repo-documentation`, …) | invokes (receive a `tech-consult.md` symlink on next SessionStart) | no |
| `ai-resources/.claude/commands/fix-symlinks.md` | parses (reconciles symlink set from the same hook contract — picks up `tech-consult` automatically) | no |
| `ai-resources/audits/working/evaluation-technical-solution-consultant.md` | documents (creation-pipeline evaluation note for the skill) | no |

Total: 5 distinct consumer types, 0 must-change. The command-side reference to `skills/technical-solution-consultant/SKILL.md` is the only true invoker; the hook, the 15 manifest projects, and `fix-symlinks.md` are all generic shared-command machinery that absorbs a new command with zero edits (confirmed: `auto-sync-shared.sh:82-96` walks `commands/*.md` unconditionally minus `EXCLUDE_COMMANDS`). The four reference files and the SKILL.md have no external consumers — they are loaded only by the skill itself via relative links (SKILL.md lines 45, 89). No consumer was surfaced that the CHANGE_DESCRIPTION did not already anticipate.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded cost. The change touches no CLAUDE.md (workspace, ai-resources, or project) — confirmed: CHANGE_DESCRIPTION states "no CLAUDE.md edits," and no CLAUDE.md appears in the referenced files or consumer inventory.
- No hook registered. CHANGE_DESCRIPTION: "No hooks." The skill/command pair adds nothing to SessionStart/Stop/PreToolUse/UserPromptSubmit.
- Pay-as-used. The skill loads only when `/tech-consult` is invoked; SKILL.md reference files (selection-memo-template, build-spec, example, heuristics) are conditionally loaded inside the workflow (SKILL.md:45 "Load … when forming or defending a tool recommendation"; SKILL.md:89), not preloaded.
- The command auto-symlinks into 15 projects, but a symlinked command file carries zero per-session token cost until invoked — it is a filesystem entry, not loaded context (same posture as every other shared command).
- Skill description trigger is need-scoped ("a technical project isn't yet scoped to a stack"), not a broad keyword that would auto-load in unrelated sessions (SKILL.md:3-12).

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission changes. CHANGE_DESCRIPTION: "no permission changes." No `allow`/`ask`/`deny` entry is added, narrowed, or removed; no settings.json appears in the change set or consumer inventory.
- No new tool family. The skill is advisory and produces text outputs ("advisory output only, no file/external side effects beyond what the operator runs"); SKILL.md:139 deliberately omits `allowed-tools` restriction and notes the skill "may read project files" — read-only, within existing repo posture.
- No scope escalation, no cross-repo/external capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: 5 consumer types, 0 must-change. The only file that names the skill directly is its own command (`tech-consult.md`); all other consumers are generic shared-command infrastructure.
- No contract change. The skill introduces no parse marker, report-heading schema, or hook-output shape that any existing caller depends on. The `parses` rows in the inventory (`auto-sync-shared.sh`, `fix-symlinks.md`) consume the *pre-existing* `EXCLUDE_COMMANDS` contract unchanged — `tech-consult` simply falls through the default branch like any other shared command.
- The 15-project symlink fan-out is wide in file count but null in behavioral coupling: each project gets an invocable command it can ignore. Confirmed against precedent — `grill-me`, `summary`, `create-skill`, `migrate-skill`, `handoff` all reference `skills/…/SKILL.md` the same way and already fan out identically.
- Not wired into any orchestrator. CHANGE_DESCRIPTION + SKILL.md:128 ("not wired as a mandatory stage of any orchestrator") confirm no `/new-project` stage or pipeline edits — no downstream workflow contract is touched.
- No inventory consumer was surfaced beyond what CHANGE_DESCRIPTION anticipated; the description explicitly names the auto-symlink behavior as intended.

### Dimension 4: Reversibility
**Risk:** Low

- Clean `git revert`. The change is net-new files only (one skill dir + 4 references + one command + one archived brief) plus one inbox archive move — deleting them via revert fully restores prior state within the working tree.
- The auto-symlink side effect is self-healing on revert: once `tech-consult.md` is removed from canonical, the hook stops creating the symlink, and `/fix-symlinks` (inventory consumer) reconciles existing symlinks against the canonical set. No manual per-project cleanup logic is required beyond, at most, deleting now-dangling symlinks — a single mechanical step the existing `/fix-symlinks` command already owns.
- No state pushed beyond git (no push, no external write, no log mutation). The inbox-archive move is a tracked file rename, fully reverted by git.
- The only minor caveat (keeps it solidly Low, not zero-touch): symlinks already created in the 15 projects before a revert would need `/fix-symlinks` to clear — an existing one-command operation, not multi-step manual rollback.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The one cross-file dependency — the command reading `skills/technical-solution-consultant/SKILL.md` (tech-consult.md:10) — is explicit and named at the change site, not implicit.
- The skill's relative reference links to its own four reference files (SKILL.md:45, 89) resolve within the skill directory; they do not assume any external component's presence or behavior.
- No new undocumented contract. The skill's reliance on `/qc-pass` → `triage-reviewer` for independent review (SKILL.md:124, 140) is an *advisory pointer to an existing mechanism*, documented at the change site — it does not create a new contract others must honor.
- No silent auto-firing. The skill runs only on explicit `/tech-consult` invocation; `disable-model-invocation` is deliberately left unset but the skill "has no file or external side effects" (SKILL.md:139), so auto-invocation cannot mutate state.
- No functional overlap with an existing mechanism that would cause two systems to handle the same concern — the evaluation note (`evaluation-technical-solution-consultant.md:72`) flags only *future* sibling skills (Website Architect, etc.) that do not yet exist; no current sibling competes.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`); IDs cited from it.
- **DR-7 / OP-9 / AP-7 (speculative abstraction): clean.** The skill carries all stages itself and does NOT build hooks for the absent future sibling roles — SKILL.md:128 "for now, it carries all stages itself." It generalizes nothing for an unconfirmed consumer; the consumer (the operator invoking `/tech-consult`) exists today. The "can later route to specialized roles" line (SKILL.md:128) is a documented *possibility*, not built infrastructure — no speculative scaffold ships.
- **OP-5 (advisory vs enforcement): clean.** The skill advises and stops — "advisory output only, no file/external side effects" (CHANGE_DESCRIPTION; SKILL.md:139). No enforcement/auto-correct authority is granted.
- **OP-12 (closure before detection): not triggered.** The skill is a generative/advisory consultant, not a detection or finding-generator, so the closure-channel constraint does not apply.
- **OP-10 (system boundary): clean.** The skill hands off *to* downstream builders (Claude Code, Cursor, no-code) and names GPT/Notion-class tools only as recommendation targets the operator runs — it does not govern or coordinate their behavior as part of the system.
- **DR-1 / DR-3 (placement): aligned.** Shared skill correctly placed in `ai-resources/skills/`; command in `ai-resources/.claude/commands/`; brief archived to `inbox/archive/` per the repo's inbox-flow convention (ai-resources/CLAUDE.md). DR-2 honored — the skill was produced via the canonical `/create-skill` pipeline (evidence: `audits/working/evaluation-technical-solution-consultant.md` is the pipeline's evaluation artifact).
- **Model tier (QS-5 / Model Tier rule): compliant.** `model: opus` declared in per-skill and per-command frontmatter (SKILL.md:13, tech-consult.md:2); no model field added to any settings.json — consistent with the workspace prohibition.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: full read of `SKILL.md` (160 lines) and `tech-consult.md` (15 lines); read of `auto-sync-shared.sh` lines 1-130 (confirming line 46 `EXCLUDE_COMMANDS` and the unconditional commands walk at 82-96); grep across `ai-resources` + workspace root for `tech-consult` and `technical-solution-consultant` (only hit outside the change set: the creation-pipeline evaluation note); `find` count of 15 `shared-manifest.json` projects; precedent check confirming `grill-me`/`summary`/`create-skill`/`migrate-skill`/`handoff` use the identical `Read skills/…/SKILL.md` pattern; principle IDs cited from the readable `principles-base.md`. No training-data fallback was used.
