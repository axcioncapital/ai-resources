# Risk Check — 2026-05-14

## Change

Session 2026-05-14 in project `nordic-pe-macro-landscape-H1-2026`: resolve six deferred repo-dd findings. Changes in scope:

(1) **F-5/F-6/F-11 (High):** Add `## Model Selection` section to project CLAUDE.md at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` declaring a model default (operator will choose Opus / Sonnet / mixed at gate). Create `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.local.json` with project-scoped env config (notably `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` per workspace CLAUDE.md guidance for analytical projects). No permission-allow expansion intended in this file at this time — only env vars and possibly a `model` field. Note: commit `a42d382` previously removed a hard-locked model from `.claude/settings.json`; reintroducing model selection here should not re-hardlock the model — declaration in CLAUDE.md is the canonical mechanism.

(2) **F-3 (Medium):** Delete the directory `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/skills/report-compliance-qc/` (contains only `SKILL.md`). The audit found this skill copy is no longer referenced by `run-report.md`; the canonical version lives in `ai-resources/skills/`. Operator-approved deletion deferred because the `rm` permission prompt was denied last session.

(3) **F-10 (Medium):** Decide whether to rename `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/status.md` (the project's `/status` slash command). Conflicts with Claude Code's built-in `/status`. Options: rename the command, or accept the collision. Note: `.claude/commands/status.md` in this project is a symlink to the ai-resources canonical command — any rename has cross-repo implications.

(4) **F-9 (Low):** Add four local-agent entries (`qc-gate`, `verification-agent`, `execution-agent`, `improvement-analyst`) to the tier table at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md`. Documentation-only.

(5) **Hook scripts:** Decide wire-or-remove for three present-but-unwired scripts: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-claim-ids.sh`, `.../check-skill-size.sh`, `.../check-permission-sanity.sh`. "Wire" means adding hook entries to `.claude/settings.json` (PreToolUse/Stop/etc.) bound to these scripts; "remove" means deleting the `.sh` files. Hooks edits are a flagged structural class per `ai-resources/docs/audit-discipline.md`.

(6) **F-12 (Low):** Possibly condense three verbatim-copy sections in the project CLAUDE.md (project Autonomy Rules, Cross-Model Rules, Compaction pointer). Already-trimmed in the 2026-05-12 audit; this is a low-priority second-pass tightening.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.local.json` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/skills/report-compliance-qc/SKILL.md` — exists (to be deleted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/status.md` — exists (described as symlink in change brief; verified as regular file on disk — see Dimension 5)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-claim-ids.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-skill-size.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/check-permission-sanity.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` — exists (target for hook wiring decisions)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/repo-due-diligence-2026-05-12-project-nordic-pe-macro-landscape-H1-2026.md` — exists (full audit context)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Six bundled changes range from documentation-only (Low) to permission-shape and hook-wiring decisions (High). The change brief contains a factual error about `status.md` being a symlink, which is the strongest signal that change (3) needs verification-before-action; combined with hook-wiring and a new settings.local.json that the SessionStart hook actively reads, the verdict is PROCEED-WITH-CAUTION with paired mitigations per High dimension. No single change is RECONSIDER-tier on its own, but the batch needs sequenced landing to avoid emergent coupling.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Change (1) adds a `## Model Selection` section to always-loaded project CLAUDE.md. Workspace CLAUDE.md § Model Tier specifies this is a short section ("Each project's `CLAUDE.md` includes a `Model Selection` section"). Estimated ~3–8 lines = ~30–80 tokens added to every-turn load. Evidence: workspace CLAUDE.md lines 117–121, project CLAUDE.md currently 56 lines (per current Read at lines 1–57).
- Change (1)'s `settings.local.json` itself is NOT auto-loaded into the model context — it is read by Claude Code at session-init for permission/env config, not appended to the prompt. No ongoing token cost from this file.
- Change (5) wire-decision: if `check-permission-sanity.sh` is wired to SessionStart, it adds ~3–5 lines of conditional `additionalContext` on session start only when drift is detected (otherwise silent — see script lines 67–69). `check-claim-ids.sh` as PostToolUse on Write to pipeline paths is silent unless a `[CITATION NEEDED]` tag is found (lines 21–32). `check-skill-size.sh` is documented as a pre-commit hook (lines 9–11) — does not run per-turn. All three are quiet-by-default; net per-session token impact <50 tokens unless drift fires.
- Change (4) is documentation in `ai-resources/docs/agent-tier-table.md`, which is NOT auto-loaded — the file's frontmatter pointer reads "When to read this file: When adding a new agent... Not needed for every turn." (line 3). Zero per-turn cost.
- Change (6) — condensing CLAUDE.md sections — would REDUCE tokens, not add. Confirmed by 2026-05-12 audit: prior commit `687f7fa` reduced project CLAUDE.md 121→56 lines, saving ~1033 tokens/turn.
- Net assessment: Change (1) adds modestly; others are zero or negative. Tipping factor toward Medium: the `## Model Selection` addition is always-loaded and the brief doesn't yet specify the section's word budget — operator should keep it under 8 lines to stay under the Medium-cost threshold.

### Dimension 2: Permissions Surface
**Risk:** Medium

- Change (1) creates `.claude/settings.local.json`. The change brief explicitly states "No permission-allow expansion intended in this file at this time — only env vars and possibly a `model` field." This is the design promise; if honored, no surface expansion.
- However, Claude Code merges settings.local.json OVER settings.json (workspace `.gitignore` line 12 confirms it is gitignored and operator-local). Per the `check-permission-sanity.sh` logic (lines 35–51): if settings.local.json contains a `permissions` block and its `defaultMode` is NOT `bypassPermissions`, it SHADOWS the parent settings.json's bypassPermissions setting and triggers permission prompts. The change brief proposes no `permissions` block, which is correct — but if an env-only file accidentally includes an empty `{"permissions": {}}` or a permissions block without defaultMode, every Edit/Write/Delete will newly prompt.
- Change (1)'s reintroduction of a `model` field in settings.local.json is explicitly allowed by workspace policy ("default model is declared per-project, not workspace-wide" — workspace CLAUDE.md § Model Tier line 117) but the prior commit `a42d382` removed model-hardlock from `settings.json`. Putting it in settings.local.json honors that intent (operator-local, gitignored).
- Change (5) hook wiring does not change permissions directly, but `check-permission-sanity.sh` is itself a permission-state observer — wiring it would surface drift to the operator at session-start. This is a net safety improvement, not a surface expansion.
- Change (3) rename does not touch permissions.
- Existing settings.json already has `Bash(*)` and `Bash(rm *)` in allow (lines 4–5 of settings.json) — this is an unusually wide allow set. Change (2) deletion uses `rm -rf` semantics which is denied (settings.json deny line 24) — the deferred rm prompt makes sense as the directory deletion would need explicit operator approval at the prompt.

### Dimension 3: Blast Radius
**Risk:** Medium

Enumeration of callers and contracts touched:

- Change (2) — `reference/skills/report-compliance-qc/`: grep across `ai-resources/` returned 20 hits for `report-compliance-qc`, but inspection of project's `run-report.md` line 62 confirms the command reads from `/ai-resources/skills/report-compliance-qc/SKILL.md` (canonical path), NOT the local copy. The local copy has zero callers in this project's commands directory. Safe to delete.
- Change (3) — `.claude/commands/status.md`: The change brief asserts this is a symlink to the ai-resources canonical command. **Filesystem evidence contradicts the brief.** `ls -la` shows `status.md` as a regular file (`-rw-------`, 580 bytes, 2026-05-12), NOT a symlink. And no `status.md` exists in `ai-resources/.claude/commands/` (find returned empty). The 2026-05-12 audit Section 1.1 lists `status` as a LOCAL command (not in the symlink list at line 42). The file content is local: it reads `logs/qc-log.md` (per audit Section 3.1). Cross-repo implications described in the brief do not exist. Rename impact is local-only.
- Change (3) rename callers: grep for `/status` in `ai-resources/.claude/commands/` found one external reference — `deploy-workflow.md` line 348 ("Run /status to verify the project loads correctly"). That reference is in a deploy template, not a runtime caller. Renaming this project's local `/status` to e.g. `/qc-status` does not break that template (the template targets `/status` as a generic verification step, presumably the built-in).
- Change (4) — agent-tier-table.md: pure append, no callers depend on row order; touched in commit `a42d382` recently. Zero blast.
- Change (5) — hook wiring: settings.json hooks block is dense (lines 38–236 of settings.json). Adding three new hook entries means three new triggers fire per matching event. PostToolUse(Write) already has 4 hooks attached (lines 73–101); adding a 5th (`check-claim-ids.sh`) compounds. SessionStart already has 5 hooks (lines 127–166); adding `check-permission-sanity.sh` as a 6th compounds. These are silent-by-default but each adds a 5–10s timeout window. Existing PostToolUse(Edit) auto-commit hook (line 79) runs `git add ... && git commit` automatically — this is a flagged structural class per audit-discipline.md line 23.
- Change (6) — CLAUDE.md condensation: per the 2026-05-12 audit, the three named sections (Autonomy Rules, Cross-Model Rules, Compaction) are already trimmed. Second-pass tightening blast is small (within one file).

### Dimension 4: Reversibility
**Risk:** Medium

- Change (1) `settings.local.json` is gitignored (workspace `.gitignore` line 12). Creating it puts state outside git — `git revert` of any session commit will NOT remove the file. Manual `rm` required. Same caveat for subsequent edits.
- Change (1) `## Model Selection` section in project CLAUDE.md is fully git-tracked, clean revert.
- Change (2) directory deletion (`rm -rf reference/skills/report-compliance-qc/`) is fully reversible via `git revert` of the deletion commit — git tracks both deletion and restoration.
- Change (3) command rename: clean `git mv` is fully revertible. BUT if the operator builds muscle memory on the new command name and uses it across sessions before any revert, that's an operator-state issue git can't undo.
- Change (4) tier-table append is a clean single-file edit, trivially revertible.
- Change (5) wire-or-remove decision:
  - "Wire" option: edit settings.json (git-tracked, clean revert).
  - "Remove" option: deleting the three `.sh` files is git-tracked, clean revert. BUT the operator's prior choice to KEEP these scripts present-but-unwired is itself a signal of preserved optionality. Removing them is more reversible than wiring them (wiring may trigger downstream auto-commits per the PostToolUse hook on the wire-edit, but the auto-commit hook only fires for paths matching `/(preparation|execution|analysis|report)/` per line 79's grep — settings.json doesn't match, so safe).
- Change (6) CLAUDE.md trim: git-tracked, clean revert.

Net: most changes are git-clean. The `settings.local.json` creation is the one item that needs manual cleanup outside git — bumps the dimension to Medium.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Coupling #1 (load-bearing):** The change brief asserts `.claude/commands/status.md` is "a symlink to the ai-resources canonical command — any rename has cross-repo implications." Filesystem evidence (this risk check verified): it is a regular local file, and no ai-resources canonical `status.md` exists. The rename-planning rationale in the brief is built on a false premise. If the operator proceeds based on that premise (e.g., chooses NOT to rename to avoid imagined cross-repo breakage), the collision with the built-in `/status` persists for no real reason. If the operator proceeds assuming it IS a symlink and runs `git mv` thinking the target propagates, the local file is renamed but nothing else changes. The coupling is to a phantom contract.
- **Coupling #2:** Change (1)'s `settings.local.json` is read by Claude Code at session-init AND is observed by the wired-if-Change-(5)-lands `check-permission-sanity.sh` hook. The hook explicitly warns on settings.local.json shadowing settings.json's bypassPermissions (script lines 35–51). If the operator lands Change (1) BEFORE Change (5) wiring (typical order), no observer exists. If wiring lands first, an empty settings.local.json with no permissions block is fine (the script's `local_has_perms` guard skips at line 38); but if a permissions block accidentally lands without defaultMode, every session-start emits the nudge. Cross-change ordering matters.
- **Coupling #3:** Change (5)'s `check-claim-ids.sh` wiring would fire as PostToolUse on Write to paths matching `/(analysis/chapters|analysis/cluster-memos|report/chapters|execution/research-extracts)/` (script line 10). These directories currently contain only `.gitkeep` files (per audit Section 6.3). The hook is silent until pipeline stages run — coupling is to a future state. When pipeline writes start, the hook will fire alongside the 4 existing PostToolUse(Write) hooks (auto-commit, log-write-activity, detect-innovation, auto-qc-nudge per settings.json lines 79–100). Compounding hook execution per write.
- **Coupling #4:** Change (5)'s `check-skill-size.sh` is structured as a pre-commit hook (script line 11: "Invoked by .claude/hooks/pre-commit after its blocking checks"). The project has NO `.claude/hooks/pre-commit` file (would need separate hook infra) — wiring it via settings.json `PreToolUse` would mismatch the script's design (it reads `git diff --cached`, line 14, which is meaningless outside commit context). Wiring this as a PreToolUse hook would silently fail at runtime.
- **Coupling #5:** Change (1) Model Selection section in CLAUDE.md + workspace CLAUDE.md § Model Tier ("Analytical commands declare `model: opus` in YAML frontmatter") + settings.json `model` field policy (removed in `a42d382`). Three layers all express model intent. If the new section in project CLAUDE.md declares e.g. "Opus default for all stages" while command frontmatter has `model: sonnet` (e.g., `.claude/commands/status.md` line 2 has `model: sonnet`), the operator-facing intent and the runtime tier diverge silently. The change brief doesn't specify how the new section reconciles with command-level frontmatter — implicit contract.
- **Coupling #6:** Change (2) deletion uses path `reference/skills/report-compliance-qc/`. Audit Section 4.6 ("Issue") notes `run-report.md` reads from `/ai-resources/skills/report-compliance-qc/SKILL.md`. Verified at run-report.md line 62. The local copy is dead — but only because of how `run-report.md` is currently written. If a future edit to `run-report.md` switches the path to `reference/skills/...` (local-first convention), the deleted directory becomes a missing dep. No documented contract pins the canonical-source decision.

High because: (a) the status.md "symlink" premise is factually wrong and is load-bearing for the rename decision; (b) Change (5) `check-skill-size.sh` wiring as proposed is a design mismatch against the script's actual invocation contract; (c) multiple implicit contracts (Model Selection vs frontmatter, canonical skill path) need explicit reconciliation.

## Mitigations

- **Coupling — status.md (Dimension 5):** Before deciding rename vs. accept-collision, re-verify the file's actual on-disk type. The change brief's symlink claim is wrong (verified: regular file, 580 bytes, no ai-resources counterpart). Decide on the rename based on the actual local-only scope. Recommended: rename to `/qc-status` or `/project-status` (local rename, clean `git mv`, no cross-repo impact).
- **Coupling — check-skill-size.sh wiring (Dimension 5):** Do NOT wire `check-skill-size.sh` as a PreToolUse or PostToolUse hook in settings.json. The script's body reads `git diff --cached` (line 14), meaningful only inside a commit hook. Either (a) keep the script unwired but documented as a manual pre-commit utility, or (b) move it under `.claude/hooks/pre-commit` if a project-level git pre-commit infrastructure is established (it is not currently).
- **Coupling — Model Selection layering (Dimension 5):** When writing the `## Model Selection` section in project CLAUDE.md, explicitly state that command-level YAML frontmatter `model:` declarations take precedence over the section's stated default. Reference workspace CLAUDE.md § Model Tier verbatim path. Do not declare a contradictory blanket override.
- **Permissions surface — settings.local.json shape (Dimension 2):** Create settings.local.json with NO top-level `permissions` block. Restrict the file to `env` and (optionally) `model`. If a `permissions` block is ever required later, include `"defaultMode": "bypassPermissions"` explicitly to avoid shadowing.
- **Reversibility — gitignored file (Dimension 4):** Document in the session notes that settings.local.json is operator-local and gitignored. Note its full content in the session note so revert-via-recreation is feasible.
- **Blast radius — hook stacking (Dimension 3):** If wiring `check-claim-ids.sh` as PostToolUse(Write), bound the matcher precisely to the pipeline-paths grep already present in the script — do not add a broader matcher in settings.json. The script's own grep at line 10 short-circuits; adding a redundant settings.json matcher avoids invoking the script on every Write.
- **Sequencing across changes:** Land in this order to keep observer-before-observed coupling clean: (4) tier-table append → (6) CLAUDE.md trim → (1a) Model Selection section → (3) status rename → (2) skill-copy deletion → (1b) settings.local.json create → (5) hook wire/remove decisions. The settings.local.json creation should precede `check-permission-sanity.sh` wiring so the observer sees the intended state, not a transient one.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (settings.json lines 4–5, 24, 38–236; project CLAUDE.md lines 1–57; check-permission-sanity.sh lines 35–69; check-skill-size.sh lines 9–14; check-claim-ids.sh lines 10–32; run-report.md line 62; workspace CLAUDE.md lines 12, 117–121); verified filesystem state for `status.md` (regular file, not symlink) and absence of canonical `ai-resources/.claude/commands/status.md`; grep counts (20 hits for `report-compliance-qc` across ai-resources, all in audits/reports, zero in active commands except `run-report.md`); audit 2026-05-12 cross-references (Sections 1.1, 1.4, 3.1, 4.6, 4.9, 6.3). No training-data fallback was used on fetch/read failures.
