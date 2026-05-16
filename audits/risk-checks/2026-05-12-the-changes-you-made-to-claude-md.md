# Risk Check — 2026-05-12

## Change

the changes you made to claude.md

This is an END-TIME risk check on a CLAUDE.md edit already executed (commit `687f7fa`). The change applied 13 verdicts from `/audit-claude-md` against the project CLAUDE.md and propagated one content move to a reference doc.

Scope of the executed change set:

1. `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` rewritten 121 → 56 lines, ~1673 → ~640 tokens, 18 → 9 H2 sections.
   - Deleted (8 H2 blocks): `Skill Dependency Chain`, `Workflow Status Command`, `Utility Commands`, `Context Isolation Rules` (pointer-only), `Citation Conversion Rule` (pointer-only), `Bright-Line Rule` (pointer-only), `Input File Handling` (workspace mirror), `Commit Rules` (workspace mirror).
   - Trimmed (6 H2 blocks): `Project Context`, `Workflow Overview`, `Autonomy Rules`, `Friction Logging`, `File Verification and Git Commits`, `Compaction`.
   - Inlined (1): `Confidentiality Boundaries` → `Project Context`.
   - Kept unchanged (3): `Operator Profile`, `Cross-Model Rules`, `Session Boundaries`.
2. `projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md` — new `## Evidence Calibration` section (~120 words) inserted between `Core QC Principles` and `Bright-Line Rule`, carrying the four-tier epistemic labeling, "public sources only / no PitchBook/Preqin/Mergermarket/FactSet", and Finnish/Norwegian-language press requirement.

Commit confirmed: `687f7fa9 claude-md: apply 13 audit verdicts — 121→56 lines, ~1033 tokens/turn saved`, with diff `87/12 lines, 23+/76-`.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` — exists (post-rewrite)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md` — exists (with new Evidence Calibration section, lines 12–22)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — exists (workspace, unchanged)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md` — exists (lines 134, 142, 146 host the three sections previously H2'd in CLAUDE.md)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/claude-md-audit-2026-05-12-project-nordic-pe-macro-landscape-H1-2026.md` — exists

## Verdict

GO

**Summary:** Net-positive on token cost (~1033 tokens/turn saved), no permissions touched, blast radius is contained to the project itself (one residual ref-doc pointer was already in stage-instructions.md), the change is cleanly revertable in git, and no new hidden coupling was introduced — the surviving pointer-based design is well-supported by existing workspace canonical sources and reference docs that already host the content.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Always-loaded project CLAUDE.md is reduced from ~1673 to ~640 tokens — direct saving of ~1033 tokens on every turn while CWD is in the project subdirectory. Verified by `git show --stat 687f7fa`: `CLAUDE.md | 87 ++++++------------------------------------` (76 lines removed).
- No hooks added; no new `@import` chain; no skill registered with broad triggers; no subagent brief touched.
- Quality-standards.md ~120-word addition is in a reference file that is documented as load-on-demand: "**When to read this file:** When running QC checks, applying fixes to prose, or handling evidence gaps. Not needed for every turn" (`reference/quality-standards.md:3`). It pays per-load, not per-turn.
- **Re-derivation risk:** Evidence Calibration content (Tier 1–4 labels, paid-database prohibition, Nordic-language press requirement) is preserved verbatim in `reference/quality-standards.md` (lines 12–22) AND already independently present in `pipeline/context-pack.md:273-276` and `pipeline/project-plan.md:63-66`. Three independent live copies — no risk of forcing future re-derivation.
- Session-state content removed from Project Context (the "Current Section: 1.1" line) is now ephemeral by design — stage-instructions.md:20 already specifies that the operator updates Project Context on Task Plan approval, so the absence of a stale "Current Section" line is intended behavior.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings*.json` touched. The diff in commit 687f7fa is exclusively `CLAUDE.md` + `reference/quality-standards.md`.
- No `allow`/`ask`/`deny` rules added, removed, or modified.
- No new tool invocation patterns introduced; the change is content-only in instruction documents.
- **Behavioral-rule attenuation check:** The deleted `Input File Handling` and `Commit Rules` H2 blocks were verbatim mirrors of workspace canonical sections (`CLAUDE.md:67-69` File Write Discipline, `CLAUDE.md:141-153` File verification and git commits). Workspace CLAUDE.md auto-loads when CWD is inside `projects/*`, so the rules continue to apply. The deleted project copies explicitly self-described as mirrors ("This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded"). Workspace auto-load remains in effect; no behavioral rule has been weakened.
- The new project `File Verification and Git Commits` section (line 48) explicitly delegates upward: "Workspace `CLAUDE.md` covers filesystem-verification and commit behavior" — naming the canonical source.

### Dimension 3: Blast Radius
**Risk:** Low

Enumerated grep coverage (paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/`):

- **`/workflow-status` command references in the project:** 1 hit in `projects/nordic-pe-macro-landscape-H1-2026/.claude/shared-manifest.json:24` — manifest still lists the command. Command file `.claude/commands/workflow-status.md` is not the audit-deleted block (the deleted block was the *description* of the command inside CLAUDE.md, not the command file). No dependent caller is broken.
- **`/audit-repo` references in the project:** 1 hit in `.claude/shared-manifest.json:32` — same disposition; command file is untouched.
- **"Skill Dependency Chain" downstream callers:** zero callers reference the deleted block specifically. The phrase survives in the new project CLAUDE.md (line 21) as a pointer item in the Workflow Overview pointer list ("five-stage pipeline, sequence constraints, skill dependency chain, Context Isolation Rules, Citation Conversion Rule, Bright-Line Rule"), routing readers to `reference/stage-instructions.md`.
- **"Citation Conversion Rule" / "Context Isolation Rules" / "Bright-Line Rule" targets:** verified present in `reference/stage-instructions.md` at lines 134, 142, 146. The H2 deletions in CLAUDE.md only removed redundant pointer-shells; the actual rule prose is intact at the canonical location.
- **Evidence Calibration (moved content):** target `reference/quality-standards.md` is referenced by 1 explicit pointer in the new project CLAUDE.md:23 ("QC standards, evidence calibration, bright-line rule application"). Tier 1–4 labels independently duplicated in `pipeline/context-pack.md` and `pipeline/project-plan.md` (no single point of failure).
- **Stage-instructions.md callback:** `reference/stage-instructions.md:20` instructs "update the Project Context section of CLAUDE.md with the approved Task Plan's objective, scope, constraints, and audience" — Project Context section still exists in new CLAUDE.md (lines 3–11), so the Stage 1 update target is preserved.
- **Friction-logging hook contract:** `.claude/agents/improvement-analyst.md:3` references "Invoked by /improve at session end" — the new compressed Friction Logging block (CLAUDE.md:42–44) still names `/improve` and `/friction-log`, so the agent dispatch contract is unchanged.
- **No contract changes:** subagent input schemas, report section headings, hook output shape, and slash-command invocation syntax are untouched.

Conclusion: zero callers require modification to keep working. The change touched 2 files; downstream impact is bounded by the project directory and the one reference doc.

### Dimension 4: Reversibility
**Risk:** Low

- Single commit `687f7fa9` modifies exactly 2 files (CLAUDE.md, reference/quality-standards.md). `git revert 687f7fa9` cleanly restores prior state.
- No sibling files created; no data/log mutation; no append-only artifact affected; no external state propagated (commit is local — no push in the chain visible).
- No automation triggered between commit and a potential revert: no new hooks, no cron, no symlink.
- **Pointer-fragility check (per task brief):** the pointer-based design routes to `reference/stage-instructions.md` lines 134, 142, 146 (Context Isolation / Citation Conversion / Bright-Line) — verified present. The Workflow Overview pointer block (CLAUDE.md:21) names "skill dependency chain" routing to `reference/stage-instructions.md`, but that doc does not currently contain a section titled "Skill Dependency Chain" (its sections are: Sequence Constraints, Stage 1–5, Context Management, Context Isolation Rules, Citation Conversion Rule, Bright-Line Rule). The audit verdict mapped Skill Dependency Chain to `reference/stage-instructions.md OR per-skill SKILL.md frontmatter`; the executed change took the latter route implicitly (skill files self-document their dependencies). This is not a silent degradation — the audit explicitly accepted this routing — but it is the one place where the pointer-list label is more aspirational than literal. Worth a one-line follow-up only if the skill-chain content is consulted again.
- No operator muscle-memory dependency on a new command or flag was introduced.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The `Autonomy Rules` heading collision risk (project's H2 with same name as workspace H2) was explicitly resolved by the new scope clause on CLAUDE.md:34: "**Workflow-execution autonomy — supplements the workspace Autonomy Rules.**" Verified the workspace `CLAUDE.md:71-86` defines a numbered 10-item pause list (default-autonomy with explicit gates) and the project rules now name themselves as a workflow-execution overlay rather than a competing default. No conflict; the supplement-vs-override relationship is explicit.
- The "supplements the workspace Autonomy Rules" claim holds: workspace rules govern all sessions; project rules add workflow-specific [Operator] / [Operator + Claude Code] / gate-failure semantics that do not exist at the workspace level. No silent overlap.
- The deleted `Input File Handling` and `Commit Rules` blocks are continuously covered by workspace canonical sections — verified at workspace `CLAUDE.md:67-69` (File Write Discipline) and `CLAUDE.md:141-153` (File verification and git commits). Workspace targets `ai-resources/docs/file-write-discipline.md` (1949 bytes) and `ai-resources/docs/compaction-protocol.md` (1283 bytes) both exist on disk.
- No new contract is introduced. The Evidence Calibration content moves into a section that follows the existing structure of `reference/quality-standards.md` (which already has Core QC Principles, Bright-Line Rule, Claim ID Invariant, Scarcity Register, Late-Stage Data Correction sections).
- No new auto-firing behavior; no hook ordering change; no functional overlap with existing mechanisms.
- The Friction Logging compression keeps the hook-trigger phrasing ("Pipeline commands auto-start a friction log session via hook") — the implicit contract with the `friction-log: true` frontmatter convention is preserved in language. Note this is the one residual implicit dependency (the convention `friction-log: true` in command frontmatter is not documented in CLAUDE.md), but it pre-existed the change and was not weakened by it.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: commit-show output, file/line references, grep counts, and verbatim quotes from CHANGE_DESCRIPTION or referenced files. Files on disk verified present where the change routes pointers (`ai-resources/docs/file-write-discipline.md`, `ai-resources/docs/compaction-protocol.md`, `reference/stage-instructions.md` lines 134/142/146, `reference/quality-standards.md` lines 12–22). No training-data fallback was used on fetch/read failures.
