# Risk Check — 2026-05-08

## Change

Bundled settings.json changes across ai-resources and research-workflow (items 1, 2, 4 from the 2026-05-08 settings plan — single combined plan-time gate per the plan's bundling guidance):

1. Run `/permission-sweep` to add missing canonical tool grants and `additionalDirectories` to `ai-resources/.claude/settings.json`. Missing allow-list entries: Read, Agent, Skill, TodoWrite, Glob, Grep, WebFetch, WebSearch, NotebookEdit, ToolSearch, Edit(**/.claude/**), Write(**/.claude/**), plus absolute-path fallbacks. `additionalDirectories` missing workspace root path.

2. `ai-resources/.claude/settings.json` hardening pass — (a) delete the entire `"deny": [...]` array (8 entries that override bypassPermissions and surface prompts every session), AND (b) verify settings has `defaultMode: bypassPermissions` and `additionalDirectories` covering workspace root so sibling-directory edits from project sessions don't surface UI prompts.

4. Remove stale `Read(archive/**)` deny entry from `ai-resources/.claude/settings.json`. `archive/` directory does not exist in `ai-resources/`. Likely subsumed by item 2 (deny-list array removal) — verify after item 2 lands.

Change class: Permission changes (settings.json allow/ask/deny edits).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

RECONSIDER

**Summary:** The bundle's stated rationale for item 2 (deny-list shadows bypassPermissions and surfaces prompts) contradicts the canonical Layer C template, which explicitly retains a 5-entry deny floor including `Bash(git push*)`, `Bash(rm -rf *)`, and `Bash(sudo *)`; deleting the entire deny array would remove canonical destructive-op safeguards while only items inside the deny array that are truly stale (one entry: `Read(archive/**)`) actually merit removal. Additionally, item 1's `additionalDirectories` claim conflicts with the canonical Layer C shape (which omits the field), and the research-workflow scope listed in the change is unreachable.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Settings file is loaded once at session start, not per turn — adding ~12 allow entries adds negligible per-turn token cost. Evidence: `ai-resources/.claude/settings.json` lines 1–120 — single static JSON, no `@import` chain, no auto-load hooks added by this change.
- No new SessionStart / PreToolUse / Stop hooks introduced. Existing hook block (lines 25–119) is untouched.
- No subagent or skill briefs altered. Per-session footprint shifts by tens of bytes only.

### Dimension 2: Permissions Surface
**Risk:** High

- **Item 2(a) deletes the entire deny array, including canonical destructive-op denies.** Current deny (lines 10–19) contains `Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(git push*)` — these are present in the canonical Layer C deny (`docs/permission-template.md` lines 131–136: `"Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)", "Read(archive/**)", "Read(logs/*-archive-*.md)", "Read(inbox/archive/**)", "Read(**/deprecated/**)", "Read(**/old/**)"`). Removing all 8 widens the surface across destructive shell ops AND removes archive-read denies that the template Note (line 141) says were intentionally retained.
- **Stated rationale for item 2 is unsupported by template precedent.** Change description claims deny entries "override bypassPermissions and surface prompts every session." Template line 144–148 explicitly retains the same deny floor *with* `bypassPermissions` (line 121). `bypassPermissions` does not consult deny rules for prompts — deny acts as a hard block, not a prompt trigger. The "surfaces prompts every session" framing appears to misattribute prompt cause to deny rules.
- **Item 1 adds canonical bare-tool entries** (Read, Agent, Skill, TodoWrite, Glob, Grep, WebFetch, WebSearch, NotebookEdit, ToolSearch, plus dotfile + absolute-path globs). These match the canonical Layer C shape (`docs/permission-template.md` lines 122–129) and widen surface in a documented, reviewed way — Low risk in isolation.
- **Item 1 claim that `additionalDirectories` is missing for Layer C contradicts the canonical template.** The Layer C shape (`docs/permission-template.md` lines 119–139) does NOT include `additionalDirectories`. The field is canonical only at Layer D (project) per line 177–180 and per `new-project.md` line 237 ("`additionalDirectories` is **not** included in this canonical block because each project's entry is computed dynamically at enrichment time"). Adding it to Layer C would diverge from the template without a documented rationale.
- **Item 4 alone is well-scoped.** `Read(archive/**)` deny is verifiably stale: `ai-resources/archive/` does not exist as a top-level directory (only `ai-resources/inbox/archive/` and `ai-resources/logs/*-archive-*.md` exist, both covered by their own deny entries on lines 16 and 15). Removing this single entry narrows-by-pruning, not widens.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Layer C template is mirrored in two emitting commands.** `Read(archive/**)` and the broader Layer C deny pattern appear in:
  - `ai-resources/.claude/commands/new-project.md` line 267 (canonical block emitted to every new project)
  - `ai-resources/.claude/commands/new-project.md` line 312 (`CANONICAL_PERMS` jq literal)
  - `ai-resources/.claude/commands/deploy-workflow.md` lines 190 and 209 (workflow deploy template)
  - `ai-resources/docs/permission-template.md` lines 131–136 (canonical Layer C) and lines 172–176 (canonical Layer D)
- Total references to `Read(archive` across `.claude/`: 5 (grep count). Changing the canonical Layer C deny without syncing these four other locations creates template drift across `/permission-sweep`, `/new-project`, `/deploy-workflow`.
- **research-workflow path does not exist.** `workflows/research-workflow/.claude/settings.json` and `workflows/research-workflow/` both `No such file or directory`. The change description references a scope that cannot be touched in this run — INCOMPLETE for that scope. Workspace root `workflows/` directory itself does not exist.
- **Workspace root settings.json is untouched** by this bundle (verified `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` lines 1–33). Only Layer C is in scope.
- **Hooks unchanged**, so blast radius on hook ordering and pre/post-tool flow is zero.

### Dimension 4: Reversibility
**Risk:** Low

- Settings file is a single JSON file under git. `git revert` of the settings commit fully restores prior allow/deny state. No log mutation, no append-only file, no external state.
- No automation fires between commit and revert that would persist state outside git (no new hook is added that would, e.g., write to a log on session start).
- Any operator muscle-memory change is minimal (the surface widens but the operator's typed commands don't change).
- One caveat: if Layer C deny is wiped and a destructive Bash command is run before revert lands, the revert does not undo whatever that command did — but that is a generic property, not specific to this change.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Layer C template has documented coupling to the emitting commands.** `permission-template.md` line 280–287 ("Update protocol") explicitly requires: when these templates change, also update `CANONICAL_PERMS` in `new-project.md` (and by parallel, `deploy-workflow.md`). The change description does not name this coupling — items 1, 2, 4 are scoped only to `ai-resources/.claude/settings.json`. Without syncing the templates, `/new-project` and `/deploy-workflow` will continue emitting the old Layer C / Layer D shape (with `Read(archive/**)`), and the next `/permission-sweep` run will flag the parent and re-introduce drift findings.
- **`bypassPermissions` ↔ deny semantics.** The deny list does not surface prompts — it hard-blocks. Removing deny entries does not "stop surfacing prompts every session" (the change rationale); it removes blocks. Any hidden coupling between deny entries and the operator's expected safety floor (e.g., expecting `Bash(rm -rf *)` to be blocked) is severed silently if item 2(a) lands as worded.
- **Layer C "Note on `audits/working/`"** (`permission-template.md` line 141) documents a prior decision to retire one deny entry while explicitly keeping the rest. That note implies the remaining denies are reviewed and intentional. Item 2(a) bypasses this prior review.
- **`Bash(rm *)` interaction.** Current settings line 8 has `Bash(rm *)` in allow alongside `Bash(*)` (line 7). Layer C canonical (template line 129) has `Bash(rm *)` in allow AND `Bash(rm -rf *)` in deny — paired guard. If item 2(a) wipes the `rm -rf` deny while item 1 keeps `Bash(rm *)` and `Bash(*)` in allow, Claude Code can run `rm -rf` without any block, contrary to the canonical pairing. This is the most consequential coupling break.

## Recommended redesign

- **Split the bundle.** Land item 1 (canonical bare-tool grants + dotfile/absolute-path globs per Layer C template) as one change. Land item 4 (remove `Read(archive/**)` only) as a second change. Drop item 2(a) entirely — its rationale (deny rules surface prompts) is not consistent with how `bypassPermissions` and deny interact, and deleting the destructive-op deny floor would silently remove canonical safeguards (`Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(git push*)`). If a specific deny entry is empirically causing a prompt, name that entry and remove only it — do not blanket-delete.
- **Reconcile item 1's `additionalDirectories` claim with the canonical template before landing.** Either (a) update Layer C in `permission-template.md` to include `additionalDirectories` with a documented rationale, then run `/permission-sweep`, or (b) drop the `additionalDirectories` portion of item 1 (Layer C does not need it per the current template — only Layer D does). Do not silently diverge the live file from the documented Layer C shape.
- **Drop the research-workflow scope from this gate.** `workflows/research-workflow/` does not exist on disk. Re-introduce that scope only when the directory and a target settings.json exist.
- **If any deny removal beyond item 4 is intended, sync the four mirrored locations** in the same commit: `permission-template.md` Layer C, `new-project.md` line 267 + `CANONICAL_PERMS` line 312, `deploy-workflow.md` lines 190 and 209. Otherwise template drift will be flagged on the next sweep.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references in `ai-resources/.claude/settings.json` lines 1–120 and `ai-resources/docs/permission-template.md` lines 119–148, 172–180, 280–287; grep counts on `Read(archive` across `.claude/` (5 references); filesystem checks confirming `ai-resources/archive/` absent and `workflows/research-workflow/` absent. No training-data fallback was used.
