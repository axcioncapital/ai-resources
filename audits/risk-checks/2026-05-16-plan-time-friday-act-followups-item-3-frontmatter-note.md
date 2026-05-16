# Risk Check — 2026-05-16

## Change

Plan-time risk-check for friday-act 2026-05-16 follow-up. Single in-class change.

**Item 3 (change class: project CLAUDE.md) — Add a YAML-frontmatter convention note to nordic-pe-macro CLAUDE.md.**

- File: `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`
- Change: add one or two sentences (likely under the existing "Workflow Overview" section or as a new short "Command Conventions" subsection) documenting that this project's pipeline commands declare their tier/effort via YAML frontmatter (e.g., `friction-log: true`, `model: opus`) at the top of each command file rather than via a `Usage:` line.
- Rationale: the frontmatter convention is already in use across pipeline commands (`run-report.md`, `run-synthesis.md`, `produce-knowledge-file.md`, etc.). Documenting the convention prevents future operators / sessions from trying to "fix" the absence of `Usage:` lines.
- Behavior change: none — the convention already operates as described. This is documentation of existing reality.
- Intersection with workspace rules: workspace CLAUDE.md (Model Tier section) already states YAML frontmatter is the only permitted mechanism for declaring tier outside the live session. This note documents the same rule project-locally.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists

## Verdict

GO

**Summary:** Single-file documentation addition to a project CLAUDE.md that mirrors a workspace rule already in force; no behavior change, no permission change, trivial token cost, and no coupling beyond the convention already operating.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Project CLAUDE.md is loaded once per session in this project's scope; the addition is described as "one or two sentences (likely under the existing 'Workflow Overview' section or as a new short 'Command Conventions' subsection)" — ~30–80 tokens.
- The file is project-scoped, not workspace-scoped — it does not load for sessions outside this project (`projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`).
- Current file is 70 lines (see Read of CLAUDE.md, ends at line 70 with "Retired Commands"); adding 1–2 sentences is a marginal increase, well under the Medium threshold (50–150 tokens to always-loaded files).

### Dimension 2: Permissions Surface
**Risk:** Low

- Change touches CLAUDE.md prose only. No `.claude/settings.json` or `.claude/settings.local.json` edits described.
- No hook registration, no tool-invocation pattern, no allow/deny rule changes implied by CHANGE_DESCRIPTION.

### Dimension 3: Blast Radius
**Risk:** Low

- Single file touched: `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`.
- No contract change. The note describes existing convention; it does not introduce a new format that callers must honor.
- Verified the cited pipeline commands already follow the convention being documented:
  - `run-report.md` — frontmatter `friction-log: true` / `model: sonnet` (lines 1–4)
  - `run-synthesis.md` — frontmatter `friction-log: true` / `model: sonnet` (lines 1–4)
  - `produce-knowledge-file.md` — frontmatter `model: opus` (lines 1–3)
- No `Usage:` line removed; nothing else in the project depends on the new prose.

### Dimension 4: Reversibility
**Risk:** Low

- A single-file prose addition. `git revert` cleanly restores prior state.
- No sibling files, no log mutations, no external state propagation.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The note documents an existing convention; it does not create a new contract. The convention is already operating in `run-report.md`, `run-synthesis.md`, `produce-knowledge-file.md`.
- One intersection with workspace CLAUDE.md → Model Tier (verbatim quote from CHANGE_DESCRIPTION: "This note documents the same rule project-locally"). This is mild redundancy with the workspace rule, but the workspace rule scope is global (tier declaration mechanism) while the project note scope is narrower (this project's pipeline commands' visible convention) — they are complementary, not contradictory.
- No silent auto-firing, no hook ordering concerns, no overlapping mechanisms.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: Read of `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` (lines 1–70 inspected), `head -10` of the three cited pipeline commands confirming frontmatter pattern, and verbatim quotes from CHANGE_DESCRIPTION. No training-data fallback used.
