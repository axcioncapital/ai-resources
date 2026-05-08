# Risk Check — 2026-05-04

## Change

Rewrite workspace CLAUDE.md (219 → ≤130 lines): create 8 new `ai-resources/docs/` files receiving extracted methodology blocks (qc-independence.md, autonomy-rules.md, file-write-discipline.md, analytical-output-principles.md, compaction-protocol.md, plan-mode-discipline.md, cross-model-rules.md, commit-discipline.md), then replace each with a pointer stub in CLAUDE.md. Cross-cutting CLAUDE.md edit affecting all sessions in this repo.

This is the plan-time gate per Autonomy Rules #9 (cross-cutting CLAUDE.md edits are an explicit gated change class). The change implements the verdicts from a completed `claude-md-audit` (26 findings, ~2,500 tokens/turn projected savings). Plan was QC'd and triaged before this gate.

Additional structural details:
- Two commits: (1) ai-resources/ repo — 8 new docs files; (2) workspace repo — CLAUDE.md only.
- Tier 3 contradiction fixes (Autonomy/Assumptions Gate, versioning composing statement) added inline; QC skip-condition fix and Plan Mode tiebreaker fix go into the new docs.
- Adds pause-trigger #10 ("Assumptions Gate concern fired") to Autonomy Rules inline list.
- Deletes Working Principles bullets 1 and 3 (audit Tier 1 standard-knowledge classification).
- Operating Principles is a new collapsed section merging Cross-Model Rules + Skill Library + AI Resource Creation + Design Judgment Principles bullet 1.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/autonomy-rules.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/file-write-discipline.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/analytical-output-principles.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/plan-mode-discipline.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/cross-model-rules.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A net-large token reduction in the always-loaded workspace surface — clearly positive on usage cost — paired with a wide blast radius (8 new sibling docs, multiple in-repo H2-name references) and material reversibility/coupling exposure that need named mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Workspace CLAUDE.md is always-loaded on every turn (verified: workspace CLAUDE.md line 1 is the file's H1; the file is the project-instruction file Claude Code loads). Current size 219 lines / 3,202 words (`wc -l`, `wc -w` on /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md). The change reduces to ≤130 lines per CHANGE_DESCRIPTION ("Rewrite workspace CLAUDE.md (219 → ≤130 lines)").
- Audit projects ~2,500 tokens/turn savings (claude-md-audit-2026-05-04-workspace-only.md line 31: "Per turn: **~2,500 tokens** removed from always-loaded surface"). Ungrounded by the risk reviewer in absolute terms (the audit uses a words×1.3 estimator with ±30% drift, per audit line 9), but the directional sign — net reduction — is unambiguous because the new sibling docs are NOT auto-loaded.
- Pointer-only stubs in CLAUDE.md do not auto-import the new docs unless the stubs use `@import` syntax. CHANGE_DESCRIPTION says "pointer stub" — interpreted as path reference, not `@import`. Existing precedent: workspace CLAUDE.md line 39, 110, 112, 137, 168 all use plain `ai-resources/docs/...` references (not `@import`). If the rewrite preserves that style, the 8 new docs are pay-as-used (loaded only when a relevant skill/command/audit reads them).
- One residual: the only existing `@import` in workspace CLAUDE.md is line 219 (`@.claude/references/harness-rules.md` for Agent Harness). If the rewrite introduces new `@import` chains in the always-loaded file, that would re-import the savings back. CHANGE_DESCRIPTION does not call this out — interpret as plain pointer stubs per the existing convention.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` change is described. CHANGE_DESCRIPTION lists two commits: (1) 8 new docs in `ai-resources/`, (2) CLAUDE.md edit. Neither touches a settings file or hook.
- No new tool invocation pattern, no `allow`/`ask`/`deny` movement, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 9 (1 modified workspace CLAUDE.md, 8 new docs in `ai-resources/docs/`).
- Existing `ai-resources/docs/` siblings: 8 (`agent-tier-table.md`, `ai-resource-creation.md`, `audit-discipline.md`, `operator-principles.md`, `permission-template.md`, `repo-architecture.md`, `session-guardrails.md`, `session-rituals.md`). The change doubles the directory size — non-trivial but consistent with the established pattern; no contract change at the directory level.
- Callers that reference moved sections by name (grep hits across `ai-resources/.claude/` and `projects/`):
  - `ai-resources/.claude/commands/prime.md:59` — "per workspace CLAUDE.md Autonomy Rules"
  - `ai-resources/.claude/commands/recommend.md:23` — "All Autonomy Rules pause-triggers in workspace CLAUDE.md still apply"
  - `ai-resources/.claude/commands/friday-act.md:75, 90` — refs to `/risk-check` change classes and Autonomy Rules
  - `ai-resources/.claude/commands/new-project.md:371` — refs to "Compaction" canonical project sections
  - `projects/buy-side-service-plan/CLAUDE.md:25, 27` — "See workspace `CLAUDE.md` § Cross-Model Rules"
  - `projects/buy-side-service-plan/.claude/commands/draft-section.md:25` — "per workspace CLAUDE.md Autonomy Rules"
  - Plus indirect mentions in audit/log artifacts (already historical, not load-bearing).
- Net: at least 7 active callers reference Autonomy Rules / Cross-Model Rules / Compaction by section name on the workspace CLAUDE.md. After the rewrite, the section names should remain present (as pointer-stub headings) so these references keep resolving textually. CHANGE_DESCRIPTION does not enumerate the new H2 headings, so the post-rewrite section taxonomy is **partially unverified** — if any heading is renamed (e.g., "Cross-Model Rules" merged under "Operating Principles"), the existing project-CLAUDE.md and command-body cross-references break their human-readable anchor.
- "Operating Principles is a new collapsed section merging Cross-Model Rules + Skill Library + AI Resource Creation + Design Judgment Principles bullet 1" — this confirms `Cross-Model Rules` H2 is removed/folded. `projects/buy-side-service-plan/CLAUDE.md:25` ("## Cross-Model Rules") and `:27` ("See workspace `CLAUDE.md` § Cross-Model Rules") are stale after the rewrite. Caller-update load: the project-side `## Cross-Model Rules` block points at a heading that no longer exists.

### Dimension 4: Reversibility
**Risk:** Medium

- Two-commit structure (one per repo). Single `git revert` per repo restores prior state for the files modified in that commit. The 8 new sibling docs are committed in commit (1) — `git revert` of that commit removes them.
- However: the workspace CLAUDE.md commit (2) only restores the old in-line content; if any callers were updated in a separate follow-up to point at new doc paths, those callers persist with broken pointers after revert. CHANGE_DESCRIPTION does not include a caller-update pass, so this risk is bounded — but if a follow-up cleanup occurs before revert, the rollback chain becomes multi-step.
- Operator muscle memory: section-name shift (Cross-Model Rules absorbed into Operating Principles) means anyone — operator or future Claude session — referencing the old name is now consulting a deprecated heading. Revert restores the file but does not unlearn the new mental model. This is the hidden tax of cross-cutting CLAUDE.md edits.
- Tier 3 contradiction fixes (Autonomy/Assumptions Gate, versioning composing statement) added inline are non-trivial — operator or audit may have already absorbed the new framing by the time a revert is contemplated. Still git-recoverable but requires re-rationalizing the reverted state.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The workspace CLAUDE.md hosts H2 anchors that several callers reference by name (see Blast Radius enumeration). Those references are textual — there is no link-validation harness. CHANGE_DESCRIPTION does not list the post-rewrite H2 taxonomy, so the contract between caller and section-name is implicit and partially unverifiable from the inputs.
- New "Operating Principles" section is a new contract that callers will eventually reference, but it has no current callers. Low-risk on direction; high implicit coupling on reverse direction (the merged-source sections lose their identifiers).
- Pause-trigger #10 ("Assumptions Gate concern fired") added to the inline list. Existing `ai-resources/.claude/commands/recommend.md:23` reads "All Autonomy Rules pause-triggers in workspace CLAUDE.md still apply" — this caller now silently absorbs trigger #10 by reference. No contract issue (the wording explicitly defers to the canonical list), but the new trigger fires in cases the callers were not designed against. Worth surfacing.
- Working Principles bullets 1 and 3 are deleted. Bullet 1 is "Follow the project's defined sequence — don't skip gates" (workspace CLAUDE.md line 70); bullet 3 is "Iterate conversationally before writing to file" (workspace CLAUDE.md line 72). The audit classifies these as standard-knowledge. No grep hits found in `ai-resources/` for these specific phrases beyond the audit document itself. Coupling exposure is low.
- The 8 new docs do not have `@import` chains declared in CHANGE_DESCRIPTION. If any of them load other docs implicitly (e.g., qc-independence.md cross-references compaction-protocol.md), that lateral coupling is out of scope of this evaluation — INCOMPLETE for the cross-doc dimension. Mark explicitly: the cross-doc coupling among the 8 new files cannot be evaluated until they exist on disk.

## Mitigations

- **Blast Radius (Medium):** Before committing, enumerate every caller that references a moved section by name (grep over `ai-resources/.claude/` and `projects/` for the literal strings "Cross-Model Rules", "QC Independence", "Autonomy Rules", "File Write Discipline", "Plan Mode Discipline", "Compaction"). Decide per-caller: (a) keep the old section name as a stub heading in CLAUDE.md that points to the new doc, or (b) update the caller to point at the new doc path. Do not leave callers pointing at deleted heading anchors. Treat the post-rewrite H2 taxonomy as a contract and document it in the commit message.
- **Reversibility (Medium):** Stage the rewrite as a single atomic workspace commit (per CHANGE_DESCRIPTION's commit (2)). Do NOT bundle caller updates into the same commit — keep them in a follow-up commit so that `git revert` of the CLAUDE.md commit alone restores a coherent state. If caller updates land in commit (2), revertibility degrades to multi-step.
- **Hidden Coupling (Medium):** In the new `autonomy-rules.md`, list pause-trigger #10 explicitly with a one-line scope statement so callers like `recommend.md:23` ("all pause-triggers apply") have a documented surface to inspect. After all 8 docs are written, run a `qc-reviewer` pass on the doc set as a whole — not per-file — to surface lateral coupling among them (e.g., qc-independence.md referencing compaction-protocol.md without declaring the dependency). Mechanical-mode is NOT eligible per the explicit rule in workspace CLAUDE.md line 54: "Mechanical mode does NOT apply to new files, new sections/capabilities, or structural reorganization; those always get the full rubric."

## Evidence-Grounding Note

All risk levels grounded in direct evidence: workspace CLAUDE.md line counts (`wc`), grep enumeration of caller references (paths and line numbers cited above), CHANGE_DESCRIPTION verbatim quotes, and the source audit document (claude-md-audit-2026-05-04-workspace-only.md lines 31-41, 91). One INCOMPLETE flag: cross-doc coupling among the 8 new files cannot be evaluated pre-creation; flagged in Dimension 5 and mitigated by the post-write doc-set QC pass. No training-data fallback used.
