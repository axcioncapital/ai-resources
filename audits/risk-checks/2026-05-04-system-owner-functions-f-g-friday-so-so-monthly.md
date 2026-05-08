# Risk Check — 2026-05-04

## Change

Added two new System Owner functions (F=friday-so, G=so-monthly) to the system-owner agent. Changes: system-owner.md — Phase 2 detection rules and Phase 5 output shapes for Functions F and G added; grounding.md — Function F and G read maps added, triage rule updated with steps (f) and (g); CLAUDE.md — command count 4→6, out-of-scope note updated, project layout updated; shared-manifest.json — local commands list updated to include friday-so and so-monthly. Command files (friday-so.md, so-monthly.md) were already committed in a prior session. No hooks, permissions, or workspace-level CLAUDE.md touched.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/agents/system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/grounding.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/shared-manifest.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/friday-so.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/so-monthly.md — exists

## Verdict

GO

**Summary:** All changes are pay-as-used additions to a project-local agent; no hooks, no permission widening, no always-loaded-file token impact, and the new commands write only into already-existing output subdirectories under the project's own scope.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- system-owner.md is read only when one of the six commands delegates to the `system-owner` agent (project-local) — not a SessionStart hook, not an `@import` chain, not always-loaded. Evidence: `system-owner.md:1-12` declares an agent (frontmatter `name: system-owner`, `model: opus`); agents load only on Task delegation.
- grounding.md is read by the agent during Phase 1 of an invocation, not on every session turn. Evidence: `system-owner.md:32` ("`projects/axcion-ai-system-owner/references/grounding.md` — per-function read map and triage rule") sits inside the "every invocation" block, not the always-loaded path.
- The 14-line additions to project CLAUDE.md (command count 4→6, layout updates) only apply when working inside `projects/axcion-ai-system-owner/`. Evidence: workspace `CLAUDE.md` § "CLAUDE.md Scoping" — project CLAUDE.md is project-scope; commit diff shows `+14/-3` lines on project CLAUDE.md only.
- shared-manifest.json change is one-line metadata for the auto-sync hook; not loaded into LLM context. Evidence: `shared-manifest.json:2` ("`Lists project-owned files under .local`") — declarative manifest, not prompt content.
- No always-loaded file (workspace `CLAUDE.md`, ai-resources `CLAUDE.md`) touched. Confirmed by commit 3820a21 stat — only project-scoped files modified.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description states explicitly: "No hooks, permissions, or workspace-level CLAUDE.md touched." Verified — commit 3820a21 file list contains no `.claude/settings.json`, no hook files, no workspace-level edits.
- The `system-owner` agent's tool grant is unchanged: `Read, Grep, Glob, Task, Skill, Write` (system-owner.md:5-11). Functions F and G use `Write` to paths under `projects/axcion-ai-system-owner/output/{friday-advisories,monthly-reviews}/` — within the already-scoped output directory (system-owner.md:21 "scoped to `projects/axcion-ai-system-owner/output/` only").
- New `Glob` reads under `ai-resources/audits/friday-checkup-*.md`, `ai-resources/logs/maintenance-observations.md`, and `projects/axcion-ai-system-owner/output/friday-advisories/` (friday-so.md:12, so-monthly.md:12,22) — all read-only operations under additionalDirectories already granted to the project (per project CLAUDE.md line 47 "additionalDirectories includes workspace root").

### Dimension 3: Blast Radius
**Risk:** Low

- Direct file count: 4 files modified (system-owner.md, grounding.md, project CLAUDE.md, shared-manifest.json), all inside `projects/axcion-ai-system-owner/`. Evidence: `git show 3820a21 --stat`.
- Cross-component reference scan in `ai-resources/.claude/`, workspace `CLAUDE.md`, `.claude/`: zero hits for `system-owner`, `/consult`, `/friday-so`, or `/so-monthly`. Evidence: `grep -rln "system-owner\|/consult\|/friday-so\|/so-monthly" ai-resources/.claude/ CLAUDE.md .claude/` returned no matches. The System Owner agent and commands are encapsulated in the project — nothing else in the workspace depends on them.
- Contract-shape additions are additive only:
  - system-owner.md Phase 2 grew from 4 functions (A–D) to 7 (A–G); existing functions A–E are unchanged.
  - grounding.md § 2 added two new function entries; existing per-function read maps unchanged.
  - grounding.md § 3 triage step 1 added (f) and (g) branches; existing (a)–(e) branches unchanged.
- shared-manifest.json change is purely additive — `"local"` array grew from 4 to 6 entries (shared-manifest.json:4). The auto-sync hook treats local commands as "skip during sync" per the file's `_doc` field; no caller has to change.
- No callers external to the project affected. The two new commands are project-local entry points the operator invokes by hand.

### Dimension 4: Reversibility
**Risk:** Low

- Single commit (3820a21) — `git revert 3820a21` cleanly undoes all four files. Evidence: `git show 3820a21 --stat` shows isolated, additive changes.
- No data/log file mutations. The commit touches no append-only logs (innovation-registry.md, improvement-log.md, session-notes.md, archives) — verified absent from the file list.
- No external state propagation: no `git push` performed yet (operator-gated per Autonomy Rules pause-trigger #2), no Notion writes, no external API calls.
- No automation registered: no hook added that could fire between landing and revert. Confirmed by absence of `.claude/hooks/` files in the commit.
- Output directories `friday-advisories/` and `monthly-reviews/` already exist on disk — created in a prior session — so even revert leaving them empty is benign (no orphan dirs introduced by this commit).

### Dimension 5: Hidden Coupling
**Risk:** Low

- The two new commands depend on three external artifacts the operator must produce or maintain:
  1. `ai-resources/audits/friday-checkup-*.md` — both commands abort cleanly if missing. Evidence: friday-so.md:12 ("If none found, abort: ..."), so-monthly.md:12 (same pattern). The dependency is explicit and surfaced to the operator.
  2. `ai-resources/logs/maintenance-observations.md` with `## YYYY-MM-DD — Friday Act (...)` session-block headers (so-monthly.md:24). This is a parse-marker contract.
  3. `projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-*.md` filename convention for sorting (so-monthly.md:18).
- Coupling assessment: contract (1) is explicit and self-handling. Contract (3) is owned by /friday-so itself — no coupling outside the project. Contract (2) couples /so-monthly to a header convention written by /friday-act in `ai-resources/`. This is one implicit dependency on an established repo convention — at the boundary between "low" and "medium," but the convention is documented in so-monthly.md:24 itself ("session-block headers matching the pattern `## YYYY-MM-DD — Friday Act (...)`"), satisfying the Low criterion ("contract is explicitly named in the change itself").
- No silent auto-firing: both commands are operator-invoked (Step 1 in each command body requires a manual invocation; no hook registers them).
- No functional overlap with existing mechanisms: the workspace already has `/friday-checkup` (audit) and `/friday-act` (remediation). The two new commands sit between them as a synthesis layer; the docstring of friday-so.md:2 names this explicitly ("Run between /friday-checkup and /friday-act"). No two systems compete for the same concern.
- Existing files reference Functions F and G consistently: system-owner.md:14 advertises "seven advisory functions (A–G)"; grounding.md § 2 has matching read maps; CLAUDE.md command count and layout match. No drift between change-site declarations.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from the change description and referenced files, and commit-stat verification of commit 3820a21). No training-data fallback was used on fetch/read failures.
