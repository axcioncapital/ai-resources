# CLAUDE.md Audit — 2026-05-12

**Scope:** project-only (nordic-pe-macro-landscape-H1-2026)
**File under audit:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md`
**Reference for cross-file comparison only (not audited):** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`
**Total findings:** 13 (HIGH: 5 / MEDIUM: 6 / LOW: 2)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift versus real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

---

## Executive Summary

- **Size is borderline-acceptable but bloated by redundancy and methodology.** At ~1,673 tokens / 121 lines, the file sits inside the 2,000-token informal soft cap but is paying for content that does not belong in always-loaded context. ~30–40% of tokens can be reclaimed without losing any operative rule.
- **Two H2 sections deliberately mirror the workspace** ("Input File Handling", "Commit Rules" — plus a third partial mirror, "File Verification and Git Commits"). The self-documented rationale ("in case workspace context isn't loaded") does not hold: workspace CLAUDE.md is auto-discovered by Claude Code when CWD is inside a project subdirectory of the workspace, which is the operating mode here. This is verbatim cross-file duplication — flagged HIGH by external guidance.
- **"Project Context" carries ephemeral session-state** ("Current Section: 1.1 — Task Plan (Stage 1 entry point)"). Session-state in an always-loaded file decays on every stage transition and forces edits — flagged anti-pattern.
- **Three sections are pure pointers wrapping a single line of prose** ("Context Isolation Rules", "Citation Conversion Rule", "Bright-Line Rule"). Each is an H2 with a one-line "see reference/...". The H2 framing inflates token cost and section-count noise; these should be merged into a single pointer block or removed from CLAUDE.md entirely and relied upon via the existing pointer in "Workflow Overview".
- **Three blocks contain workflow methodology that belongs in `reference/`** ("Workflow Overview", "Skill Dependency Chain", "Workflow Status Command"). They restate process narration that the file itself points to as living in `reference/stage-instructions.md`.
- **One contradiction with workspace:** project "Autonomy Rules" is a 4-bullet workflow-execution variant; workspace "Autonomy Rules" is a 10-trigger pause list. They are not contradictory in letter but they are competing rule sets for the same heading, and Claude has no precedence model for which wins.
- **Bottom line:** the project file is doing two jobs that conflict — onboarding doc and runtime rule loader. Trimming methodology + dropping workspace mirrors brings the file to ~1,000 tokens with no loss of operative behavior.

---

## Per-File Inventory

| Property | Value |
|---|---|
| Path | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` |
| Lines | 121 |
| Words | 1287 |
| Approx tokens | ~1673 (1287 × 1.3) |
| H2 count | 18 |
| H3 count | 0 |
| `@`-reference count | 0 (relies on prose pointers to `reference/*.md`) |

### Rule-block enumeration (18 H2 blocks)

| # | Heading | Approx tokens | Type | @-refs |
|---|---|---|---|---|
| 1 | Project Context | ~290 | Project metadata + scope | none |
| 2 | Operator Profile | ~35 | Discretionary guidance | none |
| 3 | Confidentiality Boundaries | ~10 | Bright-line (null) | none |
| 4 | Workflow Overview | ~110 | Methodology + pointers | prose refs to 4 reference docs |
| 5 | Skill Dependency Chain | ~50 | Methodology | none |
| 6 | Workflow Status Command | ~75 | Command description | prose ref |
| 7 | Utility Commands | ~45 | Command description | none |
| 8 | Cross-Model Rules | ~55 | Bright-line rules | none |
| 9 | Autonomy Rules | ~95 | Bright-line rules | none |
| 10 | Context Isolation Rules | ~10 | Pointer-only | prose ref |
| 11 | Friction Logging | ~55 | Command description | none |
| 12 | Citation Conversion Rule | ~10 | Pointer-only | prose ref |
| 13 | Bright-Line Rule | ~10 | Pointer-only | prose ref |
| 14 | Input File Handling | ~250 | Bright-line rules (mirrors workspace) | none |
| 15 | File Verification and Git Commits | ~50 | Bright-line rules (mirrors workspace) | none |
| 16 | Commit Rules | ~140 | Bright-line rules (mirrors workspace) | none |
| 17 | Compaction | ~95 | Bright-line + guidance | none |
| 18 | Session Boundaries | ~35 | Discretionary guidance | none |

**Total H2 blocks: 18.** The per-block verdict table below has 18 rows.

---

## Tier 1 — Token cost per turn

**T1-A (HIGH) — "Input File Handling" — block #14, ~250 tokens (~15% of file).**
This block is the largest in the file. Its content is a verbatim mirror of the workspace "Input File Handling" section (the file says so explicitly in its closing sentence). It applies to every turn that touches a file — a meaningful fraction — but the workspace copy is always in context too, so the project copy adds 100% redundant cost. External guidance (BuildToLaunch, ObviousWorks, KDnuggets 2026): verbatim cross-file duplication is a HIGH-severity token anti-pattern.

**T1-B (HIGH) — "Project Context" — block #1, ~290 tokens (~17% of file).**
Largest section. Justified as project-onboarding, but four issues inflate the token cost:
- Ephemeral state ("Current Section: 1.1 — Task Plan (Stage 1 entry point)") forces edits on every stage transition and decays fast.
- "Document architecture" paragraph restates content that the file itself points to in `reference/stage-instructions.md`.
- "Evidence calibration" paragraph (~130 tokens) is methodology more than a standing rule — it applies to research-execution turns but is loaded on every turn.
- Prose density; bullet form would compress ~30%.

**T1-C (MEDIUM) — "Commit Rules" — block #16, ~140 tokens (~8% of file, boundary).**
Mirrors the workspace "Commit behavior" subsection. Same redundancy critique as T1-A but smaller absolute size. The block applies to commit-bearing turns (a subset). Trimming the mirror to a one-line pointer recovers ~120 tokens.

**T1-D (MEDIUM) — "Compaction" — block #17, ~95 tokens.**
Inline rules for `/compact` behavior. Workspace points to `ai-resources/docs/compaction-protocol.md` instead of inlining. Project inlines, paying token cost on every turn for guidance that only fires when `/compact` is invoked (rare).

---

## Tier 2 — Cross-file redundancy

The workspace CLAUDE.md is auto-loaded when CWD is inside a project subdirectory of the workspace. This is the operating mode for any session in `projects/nordic-pe-macro-landscape-H1-2026/`. The "in case workspace isn't loaded" defensive rationale therefore does not apply under current Claude Code behavior.

**T2-A (HIGH) — "Input File Handling" duplicates workspace "Input File Handling".**
The project block ends with: *"This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* The workspace section is the source of truth and is always loaded. Mirror is unjustified. Quoted overlap: both files contain "**Default to `Read`**", "**Do not materialize chat content**", "**Do not co-locate inputs with outputs**", "**Outputs are different**", "**Exception: legitimate copying**" — verbatim bullet labels.

**T2-B (HIGH) — "Commit Rules" duplicates workspace "Commit behavior".**
Project block ends with the same defensive-mirror disclaimer. Workspace says: *"Commit directly. Do not ask for permission, do not run pre-commit checks (git status, git diff), do not run post-commit verification."* Project says: *"Commit directly. Do not ask for permission. ... Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification."* Substantively identical.

**T2-C (MEDIUM) — "File Verification and Git Commits" duplicates workspace "Use the filesystem, not git, to verify your own work" subsection.**
Project: *"Verify files you just wrote by reading them from the filesystem, not by running git status/diff."* Workspace: *"When you write or modify a file, verify it by reading the file directly from the filesystem — not by running git status or git diff."* Identical rule. Adds a minor extension (commit-failure handling) that could move to the workspace.

**T2-D (MEDIUM) — Project "Autonomy Rules" overlaps with workspace "Autonomy Rules".**
Workspace defines a 10-trigger pause list (general autonomy). Project defines a 4-trigger workflow-execution variant. Both use the same H2 heading "Autonomy Rules". They are not contradictory in letter (project rules are workflow-execution scope; workspace rules are general scope) but Claude has no precedence model when a turn hits both. See Tier 3 for contradiction-risk discussion.

---

## Tier 3 — Contradictions

**T3-A (HIGH) — "Autonomy Rules" (project) versus "Autonomy Rules" (workspace) — heading collision with different rule sets.**
Both files have an H2 titled "Autonomy Rules" but each defines its own list. The workspace list enumerates 10 pause-triggers for general behavior (destructive git ops, external writes, file deletion outside session scope, QC DISAGREE, etc.). The project list enumerates 4 pause-triggers for workflow-step execution ([Operator] tags, [Operator + Claude Code] tags, critical findings, gate failures).

Concrete divergence scenarios:
- A workflow step is tagged [Operator + Claude Code] AND requires a `git push` (workspace #2). Project rule says "proceed if no issues found"; workspace rule says "always pause for external writes". No precedence rule.
- A workflow gate fails AND the operator has not explicitly approved continuation. Project rule says "pause and explain"; workspace rule says nothing (silent).
- Minor formatting fix during workflow execution. Project says "apply and note"; workspace doesn't enumerate this case.

The two rule sets are reconcilable conceptually (project = workflow-execution scope; workspace = general scope), but no statement in either file declares the scope distinction. Claude resolves arbitrarily.

**T3-B (LOW, boundary) — "Commit Rules" (project) versus workspace "Commit behavior" — wording drift.**
Project: *"Do not push. Pushing is a manual operator step."* Workspace: *"Push requires operator approval (Autonomy Rules #2). After committing, ask Patrik whether to push."* Workspace requires Claude to ask; project says "remind the operator to push" (passive). Outcome similar but the action differs (ask versus remind). Minor — could matter on edge cases.

---

## Tier 4 — Staleness

**T4-A (HIGH) — "Project Context" carries ephemeral session-state.**
*"Current Section: 1.1 — Task Plan (Stage 1 entry point)"* is in-flight state. Today is 2026-05-12 with deadline "within May 2026" (~19 days remaining); Stage 1 should be far behind. If it is, the line is already stale; if it isn't, the deadline is at risk. Either way, "Current Section" is session-state, not always-true context — anti-pattern flagged by external guidance (severity MEDIUM, escalated to HIGH because deadline proximity makes drift immediately consequential).

**T4-B (MEDIUM) — "Project Context" — deadline "within May 2026" is ~19 days out.**
Not stale yet, but the project file does not specify what happens at the boundary. Worth noting in Recommended Edit Sequence as a near-term staleness risk.

**T4-C (LOW) — `/improve` and `/friction-log` command references in "Friction Logging".**
Cannot verify without filesystem access to commands directory. Listed for completeness only; no action.

---

## Tier 5 — Misplacement

**T5-A (HIGH) — "Workflow Overview" — block #4, ~110 tokens — methodology in always-loaded context.**
Contains the 5-stage pipeline name list and the 8-artifact chain. This is workflow methodology that the same block explicitly points to as living in `reference/stage-instructions.md`. Belongs in that reference doc; CLAUDE.md should hold only the pointer. External guidance: "Move methodology downward — workflow steps belong in reference docs, not in every-turn context."

**T5-B (HIGH) — "Skill Dependency Chain" — block #5, ~50 tokens.**
Describes which skills are upstream/downstream of which. Pure methodology; applies only when modifying skill code. Belongs in the skill files themselves (frontmatter or SKILL.md "Dependencies" section) or in `reference/stage-instructions.md`. Does not belong in always-loaded context.

**T5-C (MEDIUM) — "Workflow Status Command" — block #6, ~75 tokens.**
Long-form description of `/workflow-status`. Command descriptions belong in the command's frontmatter `description:` field and are surfaced by `/help`. Always-loading 75 tokens to describe a command that may run zero times in a session is wasteful.

**T5-D (MEDIUM) — "Utility Commands" — block #7, ~45 tokens.**
Same critique as T5-C: `/audit-repo` description belongs in command frontmatter, not in CLAUDE.md.

**T5-E (MEDIUM) — "Friction Logging" — block #11, ~55 tokens.**
Mostly command descriptions. Could compress to one-line pointer or move to command frontmatter.

**T5-F (MEDIUM) — "Evidence calibration" paragraph in "Project Context".**
Methodology that applies only to research-execution turns. Belongs in `reference/quality-standards.md` (already referenced in the file). Trim "Project Context" to scope/consumers/deadline; move evidence methodology to the referenced doc.

---

## Tier 6 — Clarity

**T6-A (LOW) — "Operator Profile" — vague modal.**
*"They review outputs at defined gates"* — "defined" where? Either point to where gates are defined, or drop the line — operator profile is already implicit in the workspace.

**T6-B (LOW) — "Confidentiality Boundaries" — null-content block.**
*"No confidentiality constraints for this project."* True but adds an H2 and a sentence for a null condition. Either drop, or move to "Project Context" as a one-line "Confidentiality: none." Token cost is tiny but the H2 framing inflates noise.

**T6-C (LOW) — Three pointer-only H2s ("Context Isolation Rules", "Citation Conversion Rule", "Bright-Line Rule").**
Each is an H2 wrapping a single "See reference/stage-instructions.md § ..." line. The H2 framing implies a rule lives at this location; the body says "go elsewhere." Either inline the rule (if short and load-bearing every turn) or remove the H2 (the pointer in "Workflow Overview" already directs Claude to load `reference/stage-instructions.md` when relevant).

---

## Per-Block Verdict Table

| # | Block heading | ~Tokens | Verdict | Rationale | Move target | Source |
|---|---|---|---|---|---|---|
| 1 | Project Context | ~290 | Trim | Drop "Current Section" (session-state); move Evidence calibration to `reference/quality-standards.md`; compress Document architecture into a one-line pointer to `reference/stage-instructions.md`. Keep What / Analytical lens / Deadline. | `reference/quality-standards.md` (evidence); `reference/stage-instructions.md` (architecture); session-state file (current section) | T1+T4+T5 |
| 2 | Operator Profile | ~35 | Keep | Stable project-level fact; minor vagueness on "defined gates" is LOW. | — | T6 |
| 3 | Confidentiality Boundaries | ~10 | Move | Null condition; fold into Project Context as one-line "Confidentiality: none." | Project Context | T6 |
| 4 | Workflow Overview | ~110 | Trim | Keep one-line pointer to `reference/stage-instructions.md` and the four `reference/*.md` filenames. Drop the stage-name list and the artifact chain — both restate methodology already in the referenced doc. | `reference/stage-instructions.md` | T1+T5 (HIGH) |
| 5 | Skill Dependency Chain | ~50 | Move | Methodology; belongs in skill frontmatter or stage-instructions. Triggers only when modifying skills. | `reference/stage-instructions.md` or per-skill SKILL.md | T5 (HIGH) |
| 6 | Workflow Status Command | ~75 | Move | Command description; belongs in `.claude/commands/workflow-status.md` frontmatter. | `.claude/commands/workflow-status.md` | T5 (MEDIUM) |
| 7 | Utility Commands | ~45 | Move | Same critique as #6 — `/audit-repo` description belongs in its command frontmatter. | `.claude/commands/audit-repo.md` | T5 (MEDIUM) |
| 8 | Cross-Model Rules | ~55 | Keep | Bright-line, project-specific (GPT/Perplexity assignments), applies broadly. Tight wording. | — | priors |
| 9 | Autonomy Rules | ~95 | Trim | Add an opening clause stating scope ("Workflow-execution autonomy — supplements the workspace Autonomy Rules") to resolve T3-A heading collision. Otherwise keep — workflow-step gate semantics are project-specific. | — | T2+T3 (HIGH) |
| 10 | Context Isolation Rules | ~10 | Delete | Pointer-only H2; the pointer in "Workflow Overview" already covers it. | (subsumed by Workflow Overview pointer) | T6 |
| 11 | Friction Logging | ~55 | Trim | Compress to two-line pointer; move command descriptions to command frontmatter. | `.claude/commands/friction-log.md`, `.claude/commands/improve.md` | T5 (MEDIUM) |
| 12 | Citation Conversion Rule | ~10 | Delete | Pointer-only H2; redundant with Workflow Overview pointer. | (subsumed) | T6 |
| 13 | Bright-Line Rule | ~10 | Delete | Pointer-only H2; redundant with Workflow Overview pointer. | (subsumed) | T6 |
| 14 | Input File Handling | ~250 | Delete | Verbatim mirror of workspace section; workspace is auto-loaded in this CWD. Defensive rationale does not hold. | (workspace CLAUDE.md is canonical) | T1+T2 (HIGH) |
| 15 | File Verification and Git Commits | ~50 | Trim | Drop the filesystem-verification sentence (duplicates workspace); keep only the project-specific "no staged changes → report once and move on" line, or fold that into workspace. | (workspace CLAUDE.md) | T2 (MEDIUM) |
| 16 | Commit Rules | ~140 | Delete | Verbatim mirror of workspace "Commit behavior"; minor wording drift on push behavior (T3-B) should be reconciled in workspace. | (workspace CLAUDE.md is canonical) | T1+T2+T3 (HIGH) |
| 17 | Compaction | ~95 | Trim | Workspace points to `ai-resources/docs/compaction-protocol.md`; project should do the same. Keep at most a one-line "preserve current stage + pending subagent outputs" pointer if project-specific. | `ai-resources/docs/compaction-protocol.md` | T1 (MEDIUM) |
| 18 | Session Boundaries | ~35 | Keep | Tight, broadly applicable, no redundancy. | — | priors |

**Verdict summary:** Keep 3 · Trim 6 · Move 4 · Delete 5 (of 18 blocks).

---

## Estimated Savings

Per-block token reclamation if all Trim/Move/Delete verdicts applied:

| # | Block | Action | Tokens saved |
|---|---|---|---|
| 1 | Project Context | Trim | ~150 |
| 3 | Confidentiality Boundaries | Move (inline) | ~5 |
| 4 | Workflow Overview | Trim | ~80 |
| 5 | Skill Dependency Chain | Move | ~50 |
| 6 | Workflow Status Command | Move | ~70 |
| 7 | Utility Commands | Move | ~40 |
| 9 | Autonomy Rules | Trim (small) | ~0 (adds scope clause, net neutral) |
| 10 | Context Isolation Rules | Delete | ~10 |
| 11 | Friction Logging | Trim | ~40 |
| 12 | Citation Conversion Rule | Delete | ~10 |
| 13 | Bright-Line Rule | Delete | ~10 |
| 14 | Input File Handling | Delete | ~250 |
| 15 | File Verification and Git Commits | Trim | ~30 |
| 16 | Commit Rules | Delete | ~140 |
| 17 | Compaction | Trim | ~80 |
| **Total** | | | **~965 tokens/turn** |

- **Per turn:** ~965 tokens saved (~58% of current file)
- **Per 30-turn session:** ~28,950 tokens saved
- **Per 50-turn session:** ~48,250 tokens saved
- **Resulting file size:** ~708 tokens — well below the 2,000-token soft cap with substantial headroom

**Breakdown by tier (approximate, with overlap):**
- Tier 1 (token cost): ~600 tokens (the big three: blocks #1, #14, #16)
- Tier 2 (cross-file redundancy): ~440 tokens (blocks #14, #15, #16 — overlaps with T1)
- Tier 4 (staleness): ~30 tokens (Current Section line + minor evidence-calibration drift)
- Tier 5 (misplacement): ~290 tokens (blocks #4, #5, #6, #7, #11 — partial overlap with T1)
- Tier 6 (clarity): ~30 tokens (pointer-only H2s, null-content block)

---

## Recommended Edit Sequence

1. **HIGH — Delete "Input File Handling" (block #14).** ~250 tokens; verbatim mirror of workspace; defensive rationale does not hold because workspace auto-loads in this CWD.
2. **HIGH — Delete "Commit Rules" (block #16).** ~140 tokens; verbatim mirror of workspace "Commit behavior". Reconcile minor wording drift (ask vs. remind on push) in workspace, not by keeping the mirror.
3. **HIGH — Trim "Project Context" (block #1).** Remove the line "Current Section: 1.1 — Task Plan (Stage 1 entry point)" (session-state). Move "Evidence calibration" paragraph to `reference/quality-standards.md`. Compress "Document architecture" to a one-line pointer.
4. **HIGH — Trim "Workflow Overview" (block #4).** Drop the stage-name list and artifact chain; keep the pointer-block to the four `reference/*.md` files. The methodology lives in `reference/stage-instructions.md` per the file's own pointer.
5. **HIGH — Add scope clause to "Autonomy Rules" (block #9).** Open with "Workflow-execution autonomy — supplements the workspace Autonomy Rules" to resolve the heading collision with workspace and give Claude a precedence anchor.
6. **MEDIUM — Move "Skill Dependency Chain" (block #5)** to `reference/stage-instructions.md` or per-skill SKILL.md frontmatter.
7. **MEDIUM — Move "Workflow Status Command" (block #6) and "Utility Commands" (block #7)** to command-frontmatter `description:` fields.
8. **MEDIUM — Trim "Compaction" (block #17)** to a one-line pointer at `ai-resources/docs/compaction-protocol.md` (matching the workspace pattern).
9. **MEDIUM — Trim "File Verification and Git Commits" (block #15)** to keep only the project-specific "no staged changes → report once" rule, dropping the filesystem-verification sentence (duplicates workspace).
10. **MEDIUM — Trim "Friction Logging" (block #11)** to a two-line pointer; move command bodies to command frontmatter.
11. **LOW — Delete the three pointer-only H2s ("Context Isolation Rules", "Citation Conversion Rule", "Bright-Line Rule").** Subsumed by the existing "Workflow Overview" pointer to `reference/stage-instructions.md`.
12. **LOW — Inline "Confidentiality Boundaries"** as a one-line "Confidentiality: none." in Project Context.

---

## External Guidance Cited

- **Verbatim cross-file duplication is HIGH-severity** — `ai-resources/audits/working/audit-claude-md-external-guidance-2026-05-12.md` (BuildToLaunch, ObviousWorks, KDnuggets 2026 synthesis). Drives T1-A, T1-C, T2-A, T2-B, T2-C and recommendations #1–#2.
- **Move methodology downward — workflow steps belong in reference docs, not in every-turn context** — same source (best-practices section). Drives T5-A, T5-B, T5-F and recommendation #4, #6.
- **Ephemeral / session-state in CLAUDE.md is MEDIUM anti-pattern (HIGH when deadline-proximate)** — same source. Drives T4-A and recommendation #3.
- **Treat CLAUDE.md as a lookup table, not a brain dump; five-section default structure (overview · directory · commands · conventions · quirks)** — same source (best practices). Drives the overall verdict pattern that command descriptions and methodology should leave the file.
- **Long-context models are worse, not better, at noticing contradictions across an oversized rule set** — same source (Opus 4.7 notes). Drives T3-A severity (HIGH despite reconcilability).
- **Optimize for the lower tier — Sonnet sessions pay the same per-turn token cost as Opus sessions** — same source (Opus 4.7 notes). Drives the savings projection emphasis (~50K tokens / 50-turn session is material at any tier).
