# Risk Check — 2026-06-03

## Change

Phase 7.1 of interpersonal-communication v1: restructure the project-level CLAUDE.md (projects/interpersonal-communication-copy/CLAUDE.md, currently ~45 lines of project rules, always-loaded) into an onboarding-tuned file ≤100 lines. Change has three parts: (1) ADD a compact onboarding block at the top — project purpose (1 para), system architecture (KB ↔ commands/skills ↔ practice-output list), command guide (when to use /meeting-prep, role-play skill, /today-drill, /ic-consult), KB orientation (top-level folder pointers), quality discipline (tier-tagging, falsifiable rubric, no manipulative drift), and a pointer to README for workflow walkthroughs; (2) CONVERT the two sections that verbatim-duplicate workspace canon (Input File Handling, Commit Rules) into short pointers to the workspace CLAUDE.md with a one-line summary each — per workspace § CLAUDE.md Scoping which states verbatim duplication is not acceptable but a short pointer is, and to free line budget for ≤100; (3) KEEP the genuinely project-specific rules (Compaction, Session Boundaries, Model Selection) as-is. The three workflow walkthroughs go in README (Phase 7.2), NOT CLAUDE.md, to avoid duplication. Risk concern to evaluate: trimming the verbatim-duplicated rules reduces standalone-open robustness (the stated original reason for the duplication was that projects are sometimes opened without parent workspace context); mitigation is that the short pointer still names the rule + workspace source so its existence stays visible standalone. This is a single always-loaded project CLAUDE.md edit, fully git-reversible, no hooks/permissions/symlinks touched, no cross-project blast radius.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/interpersonal-communication-copy/CLAUDE.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/interpersonal-communication-copy/README.md — not yet present

## Verdict

GO

**Summary:** A single always-loaded project CLAUDE.md edit that re-allocates roughly the same line budget toward onboarding while replacing two verbatim workspace-canon duplications with named pointers; fully git-reversible, touches no hooks/permissions/symlinks, no external callers, with one minor coupling note to verify during the edit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edited file is always-loaded project context, so net token delta is the relevant metric — not gross presence. Current file is 45 lines (Read confirmed line 45 is last); target ceiling is ≤100 lines ("into an onboarding-tuned file ≤100 lines"). Worst case is a ~55-line / ~roughly +400–500 token increase to always-loaded context.
- The increase is partly self-funding: parts (2) collapses two verbatim blocks — Input File Handling (lines 5–16, ~10 bullet/prose lines) and Commit Rules (lines 18–24) — into "short pointers ... with a one-line summary each," reclaiming budget that the onboarding block then spends.
- This crosses the Medium calibration point (">150 tokens to always-loaded files") on gross addition, but the change is a re-allocation within a hard ≤100-line cap on a file that is intentionally always-loaded, and the onboarding content is operationally load-bearing (command guide, KB orientation) rather than incidental. Net cost above the current baseline is bounded and modest; no hook, @import, or frequently-spawned subagent brief is touched. Treated as Low on net effect, with the ceiling noted.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission entries added, removed, or widened. CHANGE_DESCRIPTION: "no hooks/permissions/symlinks touched."
- The Model Selection section (lines 41–45) is explicitly kept as-is, so the existing prohibition on declaring a `"model"` field in settings is preserved — no scope change to settings files.
- No new tool-invocation pattern, Bash glob, Write path, or external/MCP capability introduced. The edit is content-only on a markdown rules file.

### Dimension 3: Blast Radius
**Risk:** Low

- Single file edited directly: `projects/interpersonal-communication-copy/CLAUDE.md`. No sibling files modified in this phase (README is Phase 7.2, out of scope here).
- External-reference enumeration: `grep -rl "interpersonal-communication-copy/CLAUDE.md" ai-resources` → 0 matches. No command, skill, agent, or hook in `ai-resources/` references this project CLAUDE.md by path, so no caller depends on its section headings or line layout.
- No contract change: project CLAUDE.md is consumed as ambient context by the model, not parsed by tooling against a fixed schema. Renaming/restructuring sections breaks no downstream parser.
- The onboarding block names four invocables (`/meeting-prep`, role-play skill, `/today-drill`, `/ic-consult`); these are referenced, not modified — no contract on them changes. (Their existence/names were not independently verified here; see Hidden Coupling.)

### Dimension 4: Reversibility
**Risk:** Low

- Single-file content edit to a tracked file; `git revert` (or `git checkout` of the prior blob) fully restores the 45-line original within the working tree. CHANGE_DESCRIPTION: "fully git-reversible."
- No data/log mutation (no innovation-registry, improvement-log, or session-notes append), no settings.json change, no state pushed beyond the local repo, no automation that could fire between landing and revert. No cleanup step beyond the revert itself.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Standalone-open robustness: the stated original reason for the verbatim duplication (lines 16 and 24: "It is repeated here because projects are sometimes opened without the parent workspace context loaded") is a real implicit dependency on the workspace file being loaded. The change's own mitigation addresses it — the short pointer "still names the rule + workspace source so its existence stays visible standalone." This keeps the rule discoverable when opened solo, downgrading what would otherwise be a Medium coupling to Low. The behavioral detail is lost standalone, but its existence + canonical location remain visible.
- Pre-existing content divergence to preserve carefully during the rewrite: the project Commit Rules currently say "After committing, push automatically" (line 22), whereas workspace § Commit behavior says "Push requires operator approval (Autonomy Rules #2)" (line 149) and Autonomy Rule #2 lists `git push` as a pause gate. The two are already in conflict today. When part (2) collapses Commit Rules to "a short pointer ... with a one-line summary," the one-line summary must point to the workspace rule (operator-approval) and must NOT re-assert "push automatically," or the pointer would propagate the more permissive of two conflicting rules. This is a correctness note for the edit, not a blocker.
- The pointer targets workspace CLAUDE.md § Input File Handling and § Commit behavior; those section names exist (workspace lines 71–73 cover File Write Discipline and lines 147–149 cover Commit behavior). The pointer should name the canonical section precisely so it does not dangle.
- README pointer in the onboarding block references a file tagged not yet present (Phase 7.2 target). Per methodology, this is evaluated on described intent: a forward pointer to a sibling README that lands in the next phase is a self-contained, low-risk convention so long as Phase 7.2 actually creates it; until then the pointer is a soft dangling reference with no functional break (ambient context, not a parsed link).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (line references from both Read'd CLAUDE.md files, a 0-match grep count for external references, verbatim quotes from CHANGE_DESCRIPTION and the referenced files, and an explicit not-yet-present flag for README). No training-data fallback was used on fetch/read failures.
