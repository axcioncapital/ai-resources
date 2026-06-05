# CLAUDE.md Audit — 2026-06-05

**Scope:** workspace + project (project file is the audit target; workspace file is the redundancy reference)
**Files audited:**
- Project (target): `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/CLAUDE.md` — 149 lines, ~2,533 tokens
- Workspace (reference only): `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — ~290 lines, ~3,400 tokens (not block-verdicted; consulted for cross-file redundancy)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

## Executive Summary

- Total findings: **HIGH: 5 / MEDIUM: 6 / LOW: 3**
- Projected token savings if all HIGH+MEDIUM applied: **~1,150 tokens/turn** (~34,500 tokens/session at 30 turns; ~57,500 at 50 turns). This is ~45% of the file.
- Net verdict: A heavily over-loaded project CLAUDE.md. At ~2,533 tokens it is ~5x the external-guidance target (~500 tokens) and breaches the "behavior-only, ~80%-of-turns" test in roughly half its blocks. The two largest blocks (`Project Config`, `Input File Handling`) plus three duplicated-from-workspace blocks (`Input File Handling`, `Commit Rules`, `Session Boundaries`, `File Verification and Git Commits`) and several workflow-methodology blocks (`Skill Dependency Chain`, `Workflow Status Command`, `Utility Commands`, `Cross-Model Rules`, `Autonomy Rules`) carry the cost. Real per-turn project-specific behavior is a small fraction of the file.

## Per-File Inventory

### Project CLAUDE.md (target — 19 H2 blocks)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| Project Context | ~520 | Discretionary/context | `1.1-research-plan-v2.md`, `reference/stage-instructions.md` |
| Operator Profile | ~50 | Context | — |
| Project Config | ~430 | Spec ref + data | `docs/project-config-schema.md` |
| Confidentiality Boundaries | ~12 | Bright-line | — |
| Workflow Overview | ~150 | Methodology + pointers | `reference/stage-instructions.md`, `file-conventions.md`, `quality-standards.md`, `style-guide.md`, `docs/required-reference-files.md` |
| Skill Dependency Chain | ~70 | Methodology | — |
| Workflow Status Command | ~80 | Command doc | `reference/stage-instructions.md` |
| Utility Commands | ~45 | Command doc | — |
| Cross-Model Rules | ~75 | Bright-line | — |
| Autonomy Rules | ~110 | Bright-line | — |
| Context Isolation Rules | ~12 | Pointer | `reference/stage-instructions.md` |
| Friction Logging | ~75 | Command doc | — |
| Citation Conversion Rule | ~10 | Pointer | `reference/stage-instructions.md` |
| Bright-Line Rule | ~10 | Pointer | `reference/stage-instructions.md` |
| Input File Handling | ~430 | Bright-line (verbose) | — |
| File Verification and Git Commits | ~55 | Bright-line | — |
| Commit Rules | ~110 | Bright-line | — |
| Compaction | ~150 | Bright-line | — |
| Session Boundaries | ~20 | Pointer | `ai-resources/docs/session-boundaries.md` |

### Workspace CLAUDE.md
Not block-verdicted (reference only). Relevant canonical sections consulted: `File Write Discipline` (2-line pointer to `docs/file-write-discipline.md`), `Autonomy Rules`, `Commit behavior` / `Push behavior`, `Working Principles` → Compaction/Session boundaries pointers, `Cross-Model Rules` (pointer to `docs/cross-model-rules.md`).

## Tier 1 — Token Cost

- **HIGH — `Project Config` (~430 tokens, ~17% of file).** A ~120-word prose preamble ("Forward contract…") wraps a 13-field code block. Most of the prose (consumer fan-out, wiring status, parse-order, schema-doc pointer) restates `docs/project-config-schema.md` and applies only when a Stage-5 command runs — well under 25% of turns. The fenced field block is load-bearing per-turn data; the surrounding prose is not. Exceeds the 15%/<25% HIGH threshold. Source: external guidance (CLAUDE.md bloat; methodology-belongs-in-docs).
- **HIGH — `Input File Handling` (~430 tokens, ~17% of file).** Six bulleted sub-rules plus a "mirrors canonical workspace" footer. This is a long bright-line elaboration that the *workspace* file itself compresses to a 2-line pointer (`File Write Discipline` → `docs/file-write-discipline.md`). Could compress to a pointer + one bright-line. Exceeds 15%/<25%. Source: external guidance (duplication + methodology-in-docs).
- **HIGH — `Project Context` (~520 tokens, ~21% of file).** Largest block. Four dense paragraphs (What / Analytical lens / Document architecture / Evidence calibration). Genuine project framing, but the depth (re-aim rationale, supersession note, nine-part architecture enumeration, thin-evidence sub-question IDs) is reference-grade, not every-turn behavior. The nine-part architecture and evidence-calibration detail duplicate `reference/stage-instructions.md` / `quality-standards.md`. Trim to a short orientation + pointer. (boundary on the >15% cut for the trimmable portion). Source: external guidance (only include what's needed in ~80% of turns).
- **MEDIUM — `Compaction` (~150 tokens, ~6% of file).** Substantially overlaps the workspace `Working Principles` → compaction-protocol pointer and the ai-resources `Compaction` block. Verbose where terse would serve. (boundary on 8% threshold.)
- **MEDIUM — `Workflow Overview` (~150 tokens).** The artifact-chain enumeration and five-stage list are methodology mirrored in `reference/stage-instructions.md`; only the pointer cluster is per-turn useful.

## Tier 2 — Redundancy (cross-file HIGH)

- **HIGH — `Commit Rules` (project) duplicates workspace `Commit behavior` + `Push behavior`.** The block self-declares the duplication: *"This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded."* External guidance flags verbatim cross-layer duplication as HIGH and notes a pointer is acceptable, duplication is not. Note also a **drift** between the copies (see Tier 3). ~110 tokens.
- **HIGH — `Input File Handling` (project) vs. workspace `File Write Discipline`.** Project block claims *"This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`"* — but the current workspace file has **no `Input File Handling` section**; it has a 2-line `File Write Discipline` pointer. So the project block is a ~430-token expansion of a rule the workspace deliberately lazy-loads to `docs/file-write-discipline.md`. Both a redundancy and a stale self-reference (Tier 4). HIGH.
- **MEDIUM — `Session Boundaries` (project) duplicates workspace + ai-resources `Session Boundaries`.** All three are the same one-line rule + same pointer (`ai-resources/docs/session-boundaries.md`). Acceptable as a pointer but triplicated; project copy adds nothing. ~20 tokens.
- **MEDIUM — `File Verification and Git Commits` (project) overlaps workspace `File verification and git commits` → "Use the filesystem, not git".** Same rule, restated. ~55 tokens.
- **MEDIUM — `Cross-Model Rules` (project) overlaps workspace `Cross-Model Rules`.** Workspace points to `docs/cross-model-rules.md`; project enumerates three stage-specific bullets. The project bullets are project-specific (Stage 2/4 GPT roles) so partial-keep, but the framing duplicates the canonical pointer.

## Tier 3 — Contradictions

- **HIGH — Push behavior: project `Commit Rules` vs. workspace `Push behavior` + ai-resources `Commit Rules`.** Project file says: *"Do not push. Pushing is a manual operator step. After committing, remind the operator to push…"* The workspace canonical (and the ai-resources copy, and MEMORY.md `feedback_push_gated`) say push is **gated and batched with a single confirmation prompt at `/wrap-session`** — i.e., Claude *does* run `git push` on operator `y`, not "pushing is a manual operator step." The project block asserts it "mirrors the canonical" while stating the **pre-2026-05-29 inverted rule**. Concrete divergence: at wrap, under the project rule Claude tells Patrik to push manually; under the canonical rule Claude offers the `Ready to push N commits…? y/n` prompt and pushes itself. This silently corrupts wrap-session behavior. HIGH.

## Tier 4 — Staleness

- **HIGH (stale + large) — `Input File Handling` self-reference.** Claims to mirror a workspace `Input File Handling` section that no longer exists under that name (workspace now uses `File Write Discipline`). The "repeated here because…" justification is stale, and the block is large (~430 tokens). HIGH per the stale-and-large rule.
- **MEDIUM — `Commit Rules` stale push semantics.** The "do not push / manual operator step" wording predates the 2026-05-29 push-rule inversion (per MEMORY.md `feedback_push_gated`). Stale relative to the canonical it claims to mirror.
- **MEDIUM — `Project Context` carries unresolved supersession debt.** Notes the "Task Plan v1 still carries the old single-thesis framing and is pending a follow-up update" and "pending a follow-up update." A pending-reconciliation note in always-loaded context is change-history, not standing behavior — move to session-plan/decisions once reconciled. (boundary — partially still-active.)
- **LOW — `Project Config` forward-contract status prose.** "as of canonical landing 2026-05-28", "remain forward-contract until separately wired" is wiring-status narrative that will date quickly; belongs in the schema doc.

## Tier 5 — Misplacement

Per workspace `CLAUDE.md Scoping` ("Skill methodology → SKILL.md; Workflow methodology → reference docs; project CLAUDE.md is for content that applies to *every turn* and cannot live elsewhere"):

- **HIGH — `Skill Dependency Chain` (~70 tokens).** Pure workflow/skill methodology (pipeline graph + "check downstream skills when modifying"). Applies only when editing a chain skill — far under every-turn. Belongs in `reference/stage-instructions.md` or the skills' own docs. >... under 300 tokens so HIGH driver is the scoping rule, not size → MEDIUM. (Reclassified MEDIUM.)
- **MEDIUM — `Workflow Status Command`, `Utility Commands`, `Friction Logging` (~200 tokens combined).** Command-catalog documentation. These describe how `/workflow-status`, `/audit-repo`, `/friction-log`, `/improve` behave — that lives in the command files' own frontmatter/body, not always-loaded CLAUDE.md. Applies only when those commands are invoked.
- **MEDIUM — `Workflow Overview` artifact chain + stage list.** Methodology; move to `reference/stage-instructions.md` (which already holds it), keep only the pointer cluster.
- **MEDIUM — `Autonomy Rules` (project, ~110 tokens).** Stage-gate tag semantics ([Operator], [Operator + Claude Code]) are workflow-execution methodology that overlaps `reference/stage-instructions.md`; the workspace `Autonomy Rules` already governs the general posture. Keep a short project delta, move the tag table to reference.
- **LOW — `Context Isolation Rules` / `Citation Conversion Rule` / `Bright-Line Rule`.** Already correctly reduced to pointers (good pattern) — listed for completeness; no move needed.

## Tier 6 — Clarity

- **MEDIUM — `Autonomy Rules`: "pause only if you find something that changes the project's logic, scope, or structure."** Vague threshold for the `[Operator + Claude Code]` tag — "changes the logic" is unspecified. Has plausibly caused drift (judgment call every gate). Specify a bright-line.
- **LOW — `Project Context`: "The document should be uncomfortable to read in places."** Aspirational, no bright-line; fine as voice but not a checkable rule.
- **LOW — `Project Config` preamble: "assume only the wired consumers parse the block unless you've separately verified additional consumer parsers exist."** Conditional with an unstated verification method.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Project Context | project | ~520 | Trim | Largest block; arch + evidence-calibration detail is reference-grade | `reference/stage-instructions.md`, `quality-standards.md` (keep short orientation) | guidance |
| Operator Profile | project | ~50 | Keep | Genuine per-project context, terse | — | priors |
| Project Config | project | ~430 | Trim | Field block load-bearing; ~120-word prose preamble belongs in schema doc | `docs/project-config-schema.md` | guidance |
| Confidentiality Boundaries | project | ~12 | Keep | One-line bright-line, applies every turn | — | priors |
| Workflow Overview | project | ~150 | Trim | Keep pointer cluster; move artifact chain + stage list | `reference/stage-instructions.md` | guidance |
| Skill Dependency Chain | project | ~70 | Move | Workflow/skill methodology, not every-turn | `reference/stage-instructions.md` | guidance |
| Workflow Status Command | project | ~80 | Move | Command documentation | `.claude/commands/workflow-status.md` | guidance |
| Utility Commands | project | ~45 | Move | Command documentation | command file / drop | guidance |
| Cross-Model Rules | project | ~75 | Trim | Keep project stage-roles; dedupe framing vs workspace pointer | — | guidance |
| Autonomy Rules | project | ~110 | Trim | Keep project delta; move tag-table methodology; tighten vague threshold | `reference/stage-instructions.md` | guidance |
| Context Isolation Rules | project | ~12 | Keep | Already a pointer | — | priors |
| Friction Logging | project | ~75 | Move | Command catalog | command files | guidance |
| Citation Conversion Rule | project | ~10 | Keep | Already a pointer | — | priors |
| Bright-Line Rule | project | ~10 | Keep | Already a pointer | — | priors |
| Input File Handling | project | ~430 | Trim/Delete | Cross-file dup of workspace `File Write Discipline`; stale self-ref; verbose | pointer → `docs/file-write-discipline.md` | guidance |
| File Verification and Git Commits | project | ~55 | Delete | Duplicates workspace rule | — (covered by workspace) | guidance |
| Commit Rules | project | ~110 | Delete | Cross-file dup + stale/contradictory push semantics | — (covered by workspace) | guidance + priors |
| Compaction | project | ~150 | Trim | Overlaps workspace + ai-resources compaction; keep project-specific gate-path line | — | guidance |
| Session Boundaries | project | ~20 | Delete | Triplicated pointer; adds nothing | — | guidance |

## Estimated Savings

- Per turn: **~1,150 tokens** (HIGH+MEDIUM applied; ~45% of the file)
- Per 30-turn session: ~34,500 tokens
- Per 50-turn session: ~57,500 tokens
- Breakdown by tier:
  - Tier 1 (trim Project Context / Project Config / Workflow Overview prose): ~600 tokens
  - Tier 2 (delete cross-file dups: Commit Rules, File Verification, Session Boundaries; collapse Input File Handling to pointer): ~520 tokens
  - Tier 5 (move Skill Dependency Chain / Workflow Status / Utility Commands / Friction Logging to command/reference docs): ~270 tokens
  - (Tiers overlap on Input File Handling / Commit Rules; net dedup ~1,150 after overlap.)

## External Guidance Cited

- CLAUDE.md bloat — per-turn baseline cost; target ~500 tokens / 150–200 lines, behavior-only. [guidance §Identified anti-patterns]
- Over-specification — "important rules lost in noise" regardless of context-window size. [guidance §Notes on Opus 4.x]
- Verbatim cross-layer duplication is HIGH; pointer acceptable, duplication not. [guidance §anti-patterns, this workspace's own rule]
- Methodology belongs in skills/docs; include only what ~80% of sessions need. [guidance §anti-patterns / best practices]
