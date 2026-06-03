# Risk Check — 2026-06-03

## Change

Relocate machine-specific additionalDirectories from two git-tracked settings.json files (projects/interpersonal-communication/.claude/settings.json and projects/nordic-pe-macro-landscape-h1-2026/.claude/settings.json) into per-machine gitignored settings.local.json files, and add "defaultMode": "bypassPermissions" to ai-resources/.claude/settings.local.json. The two tracked settings.json edits require commits in their respective repos and a push. Removing the tracked Patrik workspace-root path means Patrik's machine loses workspace-root additionalDirectories after pull unless he maintains his own local file.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/interpersonal-communication/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-h1-2026/.claude/settings.json — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-h1-2026/.claude/settings.local.json — not yet present (will be created)
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The relocation is mechanically reversible and adds no permission breadth, but it puts two tracked project `settings.json` files in direct conflict with the canonical permission-template doc (Detection Rule 8), which the operator chose to leave untouched — this creates a standing doc-vs-config contract mismatch that the permission-sweep tooling will flag as a false positive every session.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded CLAUDE.md (workspace or project). The change touches only `settings.json` / `settings.local.json` JSON config — evidence: all four referenced paths are settings files, none is a CLAUDE.md or `@import` target.
- No new hook registered. The change edits `permissions` blocks only; the `hooks` blocks in both tracked files are untouched — evidence: interpretation of CHANGE_DESCRIPTION ("Relocate machine-specific additionalDirectories", "add defaultMode") names no hook, and the existing `hooks` objects in interpersonal-communication/.claude/settings.json (lines 35-58) and nordic-pe-macro/.claude/settings.json (lines 37-249) are not in scope.
- No subagent brief or skill expanded. No frequently-spawned component touched.

### Dimension 2: Permissions Surface
**Risk:** Low

- Adding `"defaultMode": "bypassPermissions"` to `ai-resources/.claude/settings.local.json` does NOT widen the surface — it is a correctness fix. The file currently declares a `permissions` block with only `allow` (lines 1-8: `Edit(.../**)`, `Write(.../**)`), no `defaultMode`. Per permission-template.md line 106, a local file that declares `permissions` without `defaultMode` *shadows* the parent's bypass and re-enables prompts. Adding `defaultMode` restores the parent (`ai-resources/.claude/settings.json`, which has `bypassPermissions` per Layer C) rather than escalating.
- Relocating `additionalDirectories` does not add any `allow`/`ask` entry, does not remove or narrow a `deny`, and does not introduce a new tool/Bash/Write/API capability. `additionalDirectories` is a directory-scope grant, not a tool grant; the same path value moves from a tracked file to a gitignored sibling on the same machine — no new capability appears on Daniel's machine (interpersonal-communication/.claude/settings.local.json already carries the Daniel workspace-root path per verified context).
- No scope escalation between settings files (project → user). All edits stay within project-layer and ai-resources-layer local files.

### Dimension 3: Blast Radius
**Risk:** Medium

- Directly touches 3 files (2 tracked `settings.json` edits + 1 new `nordic-pe-macro/.claude/settings.local.json`) plus the ai-resources local file = 4 files across 3 separate git repos (interpersonal-communication, nordic-pe-macro, ai-resources). The cwd session repo (interpersonal-communication-copy) is a fourth repo not edited.
- Contract dependency: the canonical permission-template doc declares the relocated value as belonging in tracked project files. Evidence — `ai-resources/docs/permission-template.md`:
  - Layer D canonical shape (lines 176-178) places `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` inside the *tracked* project `settings.json`.
  - Line 188: "`additionalDirectories` granting workspace root — required for ai-resources symlinks to resolve."
  - Detection Rule 8 (line 371): "Missing or stale `additionalDirectories` in project files (should include workspace root absolute path)" — CRITICAL/HIGH tier.
- Consumer enumeration (grep across `{AI_RESOURCES}`, live config only, excluding read-only `/audits/` history):
  - `additionalDirectories` referenced in 6 live consumers: `docs/permission-template.md`, `.claude/agents/repo-dd-auditor.md`, `.claude/agents/permission-sweep-auditor.md`, `.claude/commands/friday-journal.md`, `.claude/commands/new-project.md`, `.claude/commands/deploy-workflow.md`, `.claude/commands/permission-sweep.md`.
  - The `/permission-sweep` command + `permission-sweep-auditor` agent + `check-permission-sanity.sh` SessionStart hook (registered in both tracked files — interpersonal-communication lines 47-56, nordic-pe-macro lines 161-165) all read Rule 8. After the change, every session in these two projects runs `check-permission-sanity.sh`, which will see a tracked `settings.json` with NO `additionalDirectories` and flag it as a Rule 8 violation — a false positive the operator must repeatedly dismiss.
- All callers keep *functioning* (the grant still resolves on Daniel's machine via the local file), so no caller breaks — but the diagnostic tooling produces persistent noise. That is a backwards-compatible-runtime / contract-divergent-tooling split, which lands at Medium not High.

### Dimension 4: Reversibility
**Risk:** Medium

- The two tracked `settings.json` edits are clean single-block `git revert` candidates within their own repos. The new `nordic-pe-macro/.claude/settings.local.json` is gitignored, so `git revert` will NOT remove it — it requires a manual `rm` to fully restore prior state (one extra cleanup step). Evidence: verified context states the file "will be created" and is "confirmed gitignored."
- State propagates beyond git: CHANGE_DESCRIPTION states the two tracked edits "require commits in their respective repos and a push." Once pushed, rollback is no longer a local-only operation — it requires revert commits + a second push per repo, and Patrik's machine state diverges on his next pull (he loses the tracked workspace-root path until he creates his own local file). This is the "state propagated beyond git (push)" signal.
- The ai-resources local-file edit is gitignored and trivially hand-revertable (delete one key).
- Net: revert works but needs (a) manual deletion of the new gitignored local file and (b) coordination of Patrik's local file post-push. Multi-step but bounded — Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Documented contract conflict, left unreconciled by operator decision. The change makes the two tracked `settings.json` files diverge from the canonical shape in `permission-template.md` (Layer D, lines 176-178; Rule 8, line 371), and the verified context states the operator deliberately left the doc untouched ("permission-template.md doc example left untouched (doc declares those paths canonical)"). The new contract (tracked files carry NO `additionalDirectories`; the grant lives only in per-machine local files) is therefore *undocumented* at the canonical location and actively contradicted there. Callers that honor the doc (permission-sweep, check-permission-sanity.sh) will treat the new state as broken.
- Cross-machine implicit dependency: the change silently relies on each operator maintaining a private gitignored `settings.local.json`. CHANGE_DESCRIPTION states this explicitly for Patrik ("loses workspace-root additionalDirectories after pull unless he maintains his own local file"). There is no automation that creates the local file on pull, so the workspace-root symlink resolution (permission-template.md line 188) silently degrades on any machine that lacks the local file.
- Shadow-merge coupling (already correct in this change, noted for completeness): the ai-resources local file's `defaultMode` addition depends on the documented non-merge shadow behavior (line 13, line 106). The change honors it correctly, so no new risk — but it confirms the settings-local layer carries load-bearing implicit behavior.

## Mitigations

- **Dimension 3 (blast radius) / Dimension 5 (hidden coupling) — reconcile the canonical doc in the same change set.** Before or with the commits, update `ai-resources/docs/permission-template.md` so the new contract is documented at the canonical location: either (a) move the `additionalDirectories` example out of the Layer D *tracked* shape into a Layer D′ (project `settings.local.json`) note, and amend Detection Rule 8 (line 371) so it no longer flags tracked project files lacking `additionalDirectories`; or (b) if the operator wants to keep the doc as-is, add an explicit "Intentional-narrow exception" entry (alongside the obsidian-pe-kb exception at line 203) naming these two projects so `/permission-sweep` and `check-permission-sanity.sh` stop flagging them. Without one of these, the doc-vs-config conflict is a standing CLAUDE.md "conflicts must be surfaced, not silently resolved" violation and produces per-session false-positive noise.

- **Dimension 4 (reversibility) — record the rollback recipe in the commit body.** Because the new `nordic-pe-macro/.claude/settings.local.json` is gitignored (survives `git revert`) and the tracked edits will be pushed, note in each commit message that full rollback = revert the tracked edit + `rm` the gitignored local file + have Patrik re-create or `git checkout` his local workspace-root path. This converts an undocumented multi-step manual rollback into a one-read recipe.

- **Dimension 5 (hidden coupling) — give Patrik a ready-to-paste local-file snippet.** Since his machine loses the tracked path on pull, provide the exact `settings.local.json` JSON (with his `/Users/patrik.lindeberg/...` workspace-root `additionalDirectories` plus `defaultMode: bypassPermissions`) so the silent post-pull degradation has an explicit recovery step rather than relying on him to reconstruct it.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the four referenced settings files and `ai-resources/docs/permission-template.md`, grep counts of live `additionalDirectories` consumers under `{AI_RESOURCES}`, and verbatim quotes from CHANGE_DESCRIPTION and the verified-context inputs). The `not yet present` nordic-pe-macro `settings.local.json` was evaluated from described intent only and flagged as such under Dimensions 4 and 5. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult` → `system-owner` agent, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Second opinion UNAVAILABLE — agent DECLINED (ungrounded).** The `system-owner` agent's grounding base (persona/grounding/toolkit-relationship references plus the vault: principles / blueprint / risk-topology / repo-state) is not present in the `interpersonal-communication-copy` checkout. The agent correctly applied its decline-when-ungrounded rule rather than producing a confident-but-ungrounded verdict from training data or the risk-check brief alone.

The agent confirmed the brief's verified on-disk facts are not in question (local file carries the Daniel path; all three local files gitignored; tracked files in separate repos). What it could not ground was the architectural judgment layer (concur/dissent on verdict; canonical-pattern correctness; doc-vs-config tension resolution; missed risks).

Agent's options for a grounded second opinion: (1) re-invoke from the main workspace root where vault references resolve; (2) supply grounding inline. One unhedged process observation it offered: the doc-vs-config tension (mitigation 1 vs. leaving permission-template.md untouched) is owned operationally by the permission-sweep tooling; naming the standing flag in each commit body is the minimum so a future session does not re-litigate it as a fresh finding.

**Effect on verdict:** None. Per `/risk-check` Step 4d, a declined/unavailable second opinion does not change the verdict and does not block. The risk-check-reviewer's PROCEED-WITH-CAUTION verdict stands as the gate result.
