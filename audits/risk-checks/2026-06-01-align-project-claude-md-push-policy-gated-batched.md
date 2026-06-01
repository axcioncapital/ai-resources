# Risk Check — 2026-06-01

## Change

Replace the contradicting "After committing, push automatically." line with canonical gated/batched push wording across 11 project CLAUDE.md files. Old line (identical in all 11, exactly 1 occurrence each):
"After committing, push automatically. Remind the operator to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens)."
New line:
"After committing, do NOT push. Pushes are batched until session end and gated by a single operator confirmation at `/wrap-session` (or an explicit signal like \"we're done\" / \"ship it\"). Remind the operator to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens)."
Purpose: align project CLAUDE.md mirror blocks with the canonical gated/batched push rule that was inverted on 2026-05-29 (workspace CLAUDE.md Push behavior + ai-resources CLAUDE.md Commit Rules). The 11 project files currently contradict the canonical rule.
Out of scope: 3 project files already correct (axcion-ai-system-owner, global-macro-analysis, repo-documentation); workspace-root + ai-resources canonical CLAUDE.md files (already correct — they are the source of truth being mirrored).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/personal/travel-os/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/CLAUDE.md — exists

## Verdict

GO

**Summary:** A literal one-line find-and-replace across 11 project CLAUDE.md mirror blocks that brings them into agreement with the already-canonical gated/batched push rule; every dimension is Low, and the change net-reduces an existing contradiction rather than adding surface.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Each project CLAUDE.md is always-loaded only within that project's own sessions, not globally — the edit changes one already-present line, not an addition of a new always-loaded file or hook. Evidence: old line at `projects/strategic-os/CLAUDE.md:76`, inside an existing `## Commit Rules` block (context lines 74–77).
- Net token delta is small: the new line is ~2 sentences vs. the old ~3 sentences; it replaces existing text rather than appending. No `@import`, hook registration, subagent brief, or skill description is touched. Evidence: `CHANGE_DESCRIPTION` describes a single-line substitution only.
- No SessionStart / Stop / PreToolUse / UserPromptSubmit hook is added — change is pure prose edit. Evidence: no hook files in REFERENCED_FILE_PATHS.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` file is touched; no `allow` / `ask` / `deny` entry is added, removed, or narrowed. Evidence: all 11 referenced paths are `CLAUDE.md` files; none are settings files.
- The change *narrows* effective behavior (push becomes gated rather than automatic) — it removes an implied autonomous-push instruction, which tightens rather than widens the operational surface. Evidence: old line "push automatically" → new line "do NOT push … gated by a single operator confirmation".
- No new tool invocation pattern, shell capability, or external API is authorized. Evidence: prose-only edit.

### Dimension 3: Blast Radius
**Risk:** Low

- Directly touches 11 files, each with exactly 1 occurrence of the target line and no other variants. Evidence (grep): per-file `grep -c "After committing, push automatically."` returned `1` for all 11; `grep -rln "push automatically" projects/` returned exactly the same 11 files and no others.
- No contract change: CLAUDE.md prose is read by the model as guidance, not parsed by any caller against a schema. No command, skill, agent, or hook references these per-project lines as a parse target. Evidence: the edited text is a free-prose `## Commit Rules` mirror block, not a frontmatter key, parse marker, or section heading depended on by tooling.
- Out-of-scope files correctly excluded — the 3 named already-correct project files (axcion-ai-system-owner, global-macro-analysis, repo-documentation) return `0` occurrences of the old line, confirming they are not in the edit set and need no change. Evidence: `grep -c` returned `0` for all 3.
- Canonical source files (workspace CLAUDE.md `### Push behavior` at line 195–201; ai-resources CLAUDE.md `## Commit Rules` at lines 23/70/77) already carry the gated wording — this change makes the 11 mirrors agree with them, reducing divergence rather than introducing a new contract. Evidence: grep of canonical files confirms "gated and batched" / "single operator confirmation" / "we're done" / "ship it" language already present.

### Dimension 4: Reversibility
**Risk:** Low

- Pure in-tree text edit to 11 tracked files; `git revert` (or `git checkout`) restores prior state fully with no sibling files, generated artifacts, or directories left behind. Evidence: change creates no new files — REPORT_PATH aside, all targets are existing tracked CLAUDE.md files.
- No log/registry mutation (no append to innovation-registry, improvement-log, session-notes, or archives) that a revert would leave stale. Evidence: none of those files are in scope.
- No state propagates beyond git: no push, no Notion write, no external POST, no hook/cron/symlink added that could fire between landing and revert. Evidence: prose-only edit; push itself remains gated per the new wording.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new wording is an explicit mirror of a documented canonical rule, not a new implicit dependency. Evidence: new line matches the canonical `### Push behavior` (workspace CLAUDE.md:197–201) and `## Commit Rules` (ai-resources CLAUDE.md:77) language, both of which the mirror block already references in-spirit.
- The change resolves an existing hidden-coupling hazard rather than creating one: the 11 stale mirrors currently contradict the canonical rule, so any session opened in those projects without parent-workspace context would have read "push automatically" and acted against the gated policy. The edit removes that latent conflict. Evidence: old line "push automatically" vs. canonical "Do NOT run `git push` mid-session" (workspace CLAUDE.md:197).
- No silent auto-firing, no new parse marker, no functional overlap with another mechanism is introduced — the mirror block's purpose (restate canonical commit/push rules for projects opened without workspace context) is unchanged; only its content is corrected. Evidence: surrounding `## Commit Rules` block structure (strategic-os CLAUDE.md:74–77) is preserved.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (per-file and recursive grep counts confirming exactly 1 occurrence in each of the 11 files and 0 in the 3 out-of-scope files; verbatim quotes from the old/new lines; canonical-source line references in workspace CLAUDE.md:195–201 and ai-resources CLAUDE.md:23/70/77; confirmed existence of the risk-checks output directory). No training-data fallback was used on fetch/read failures.
