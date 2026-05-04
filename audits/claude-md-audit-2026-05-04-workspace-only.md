# CLAUDE.md Audit — 2026-05-04

**Scope:** Workspace CLAUDE.md only (no project-level file in scope).

**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 219 lines, ~4,160 tokens (per NOTES_PATH measurements; words × 1.3, ±30% drift)
- Project: not in scope

**Token-estimation caveat:** All token counts are word × 1.3, which drifts ±30% vs. real tokenizer. Findings within ±15% of a stated threshold are tagged `(boundary)`. Per-block token estimates below were derived by counting words in the inline content passed in the brief and applying the same 1.3× multiplier; sub-block estimates (per H3) sum back to the H2 estimate within a few percent.

---

## Bright-Line Rule Reminder

> **"Would removing this rule cause Claude to make a mistake the operator would notice within one session?"**
> If no, default verdict is **Trim**, **Move**, or **Delete** — never **Keep** without explicit justification.

This audit applies that test to every block. Per Anthropic's published "over-specified CLAUDE.md" anti-pattern, the cost of keeping a marginal rule is that critical rules nearby get ignored — bloat is not free even on long-context models.

---

## Executive Summary

**Total findings:**
- HIGH: **9**
- MEDIUM: **11**
- LOW: **6**
- Total: 26

**Headline projected savings (Trim + Move + Delete combined):**
- Per turn: **~2,500 tokens** removed from always-loaded surface (~60% reduction; from ~4,160 → ~1,650)
- Per 30-turn session: **~75,000 tokens** saved
- Per 50-turn session: **~125,000 tokens** saved

**Top 3 structural recommendations:**

1. **Move methodology blocks to `ai-resources/docs/` and `@`-import on demand.** `QC Independence Rule`, `QC → Triage Auto-Loop`, `Session Guardrails`, `Plan Mode Discipline`, `Autonomy Rules`, `File verification and git commits` are all five-to-eight-paragraph operating manuals. They belong in linked docs (they already partially are — see existing `ai-resources/docs/audit-discipline.md`, `ai-resources/docs/session-guardrails.md` references). Replace each H2 with a 1-2 line pointer + `@`-import.
2. **Collapse the "Cross-Model Rules" / "Skill Library" / "AI Resource Creation" / "Design Judgment Principles" / "Assumptions Gate" / "Completion Standard" cluster into a single ~10-line "Operating Principles" block.** Most are 1-2 bullet rules wearing H2 hats. Section overhead (heading + spacing) costs as much as the rule.
3. **Delete or sharply trim duplicate / standard-knowledge content.** Several blocks restate Anthropic-default behavior (e.g., "follow defined sequence", "iterate before writing"), restate what the workspace already does without instruction, or repeat content that lives in a canonical doc plus a project file (`Commit behavior` is restated in `ai-resources/CLAUDE.md` by the file's own admission).

The current file is **~2× the upper practitioner token target** (Kjramsy: 300-600 tokens typical, >2,000 tokens means task state has crept in; aggressive practitioner consensus: <2,000 tokens). The "Claude ignores half of it" failure mode is observed even on Opus per Anthropic's own docs.

---

## Per-File Inventory

### Workspace CLAUDE.md (219 lines, ~4,160 tokens)

| # | Block (H2 / H3) | One-line description | Est. tokens | Operative |
|---|---|---|---:|---|
| 1 | What This Workspace Is For | Two-sentence framing of the workspace root | ~40 | Sometimes (orientation) |
| 2 | Projects | Lists three top-level dirs and what each holds | ~75 | Sometimes |
| 3 | Axcíon's Tool Ecosystem | Five-tool inventory (Claude, GPT, Perplexity, Notion, NotebookLM) + tool-assignment reminder | ~85 | Sometimes |
| 4 | Cross-Model Rules | Three bullets governing cross-tool substitution | ~165 | Sometimes (multi-tool only) |
| 5 | Skill Library | Read SKILL.md before tasks; don't edit skills from project workspaces | ~70 | Sometimes |
| 6 | AI Resource Creation | Use `/create-skill` etc.; pointer to `ai-resources/docs/ai-resource-creation.md` | ~55 | Rarely (only when creating resources) |
| 7 | Design Judgment Principles | Four bullets on conflicts, evidence/interpretation, sources, uncertainty | ~280 | Sometimes (analytical work) |
| 8 | QC Independence Rule | Five sub-bullets: context isolation, post-edit QC, mechanical-mode, plan QC, self-check | ~620 | Sometimes (only when QC runs) |
| 9 | Assumptions Gate | Two paragraphs on escalating structural concerns | ~125 | Sometimes |
| 10 | Completion Standard | Verify output before announcing; BLOCKING vs. IMPORTANT | ~70 | Every turn (notionally) |
| 11 | Working Principles | Five bullets including pre-compact and post-compact | ~290 | Sometimes |
| 12 | Chat Communication Style | B2 English rules, jargon glossing, structured tags | ~175 | Every turn (chat output) |
| 13 | File Write Discipline | Inputs read-only, save-verbatim exception, copying exception | ~310 | Sometimes (file ops) |
| 14 | Autonomy Rules | Default + 9 numbered pause-triggers | ~465 | Sometimes (decision points) |
| 15 | QC → Triage Auto-Loop | Five-step loop + cap | ~290 | Sometimes (after QC) |
| 16 | Session Guardrails | Four-flag taxonomy + exempted commands | ~260 | Every turn (notionally) |
| 17 | Plan Mode Discipline | QC-fix re-entry rule + tiebreaker | ~240 | Rarely (plan mode only) |
| 18 | CLAUDE.md Scoping | What not to put in project CLAUDE.md | ~145 | Rarely (only when editing CLAUDE.md) |
| 19 | Model Tier (H2) | Per-project default model declaration | ~135 | Rarely |
| 19a | Model Tier → Agents (H3) | Every agent declares `model:`; tier-by-work-type | ~80 | Rarely (only when editing agents) |
| 20 | Model Escalation | Triggers, action, de-duplication clause | ~245 | Sometimes |
| 21 | Adaptive Thinking Override | Set `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` for analytical projects | ~110 | Rarely (only at project setup) |
| 22 | File verification and git commits (H2 wrapper) | Wrapper for three H3s | ~5 | — |
| 22a | Use the filesystem, not git, to verify your own work (H3) | Verify writes via filesystem, not git status | ~85 | Sometimes |
| 22b | Commit behavior (H3) | Commit directly, no pre/post-commit checks, ask before push | ~140 | Sometimes |
| 22c | Commit-boundary sequencing (H3) | Multi-commit single-file edit ordering | ~85 | Rarely |
| 22d | Concurrent-session staging discipline (H3) | Enumerate files; restrict `/cleanup-worktree` etc. | ~175 | Rarely (concurrent sessions) |
| 23 | Delivery | Notion is distribution copy; markdown is source of truth | ~30 | Rarely |
| 24 | Agent Harness | Load `@.claude/references/harness-rules.md` for harness work | ~50 | Rarely |

**Block count: 28** (24 H2s + 4 self-contained H3s under §22 / §19; the §22 wrapper is counted as one row but adds no operative content). Sum of estimates: ~4,200 tokens, consistent with the ~4,160 measured total.

---

## Tier 1 — Token Cost Per Turn

This tier carries the most weight per the operator's PRIORITY_ORDER. The file is ~4,160 tokens, ~2× the upper practitioner consensus target (~2,000) and ~7× the Kjramsy median (300-600). Below are the worst offenders.

### HIGH — `QC Independence Rule` (~620 tokens, ~15% of file)

Five sub-bullets totaling roughly 4× the size of an average rule block. Applies only when a QC subagent runs (sometimes-relevant), yet loads every turn. The "mechanical-mode QC" sub-bullet alone is ~190 tokens of operating-manual prose ("Rationale: full-rubric QC on mechanical infra work surfaces out-of-scope observations as findings…"). Per Anthropic's anti-pattern list, multi-paragraph rationale belongs in a linked doc; the CLAUDE.md entry is the rule itself.

**Move target:** `ai-resources/docs/qc-independence.md` (new), with `@`-import. Keep a 2-line pointer in CLAUDE.md.

**Source:** Anthropic over-specified anti-pattern; Kjramsy three-layer model.

### HIGH — `Autonomy Rules` (~465 tokens, ~11% of file)

Nine numbered pause-triggers plus three paragraphs of preamble/conditioning. Pause-triggers 8 and 9 contain embedded multi-sentence rationale and cross-references (`audit-discipline.md` § Risk-check change classes). Operative-on-decision-points only; not on every turn.

**Move target:** Trim to a 5-line summary + `@ai-resources/docs/autonomy-rules.md` for the full enumeration. Verify path or create at first use.

**Source:** Anthropic over-specified anti-pattern.

### HIGH — `File Write Discipline` (~310 tokens)

Four bullets, one of which (`Operator-pasted content — save verbatim`) is ~95 tokens of conditional logic ("Flag before writing if: target path exists and would be overwritten; content appears incomplete; …"). This is procedural prose for a file-handling subroutine that rarely fires.

**Move target:** `ai-resources/docs/file-write-discipline.md` with `@`-import. Keep one-line "default to Read for inputs" in CLAUDE.md as the bright-line.

**Source:** Anthropic over-specified anti-pattern.

### HIGH — `Working Principles` (~290 tokens)

Five mixed bullets where the first three are bromides ("Follow the project's defined sequence — don't skip gates", "create a new version file rather than overwriting", "Iterate conversationally before writing") and the last two (`Pre-compact checkpoint`, `Post-compact resumption`) are heavy procedural rules that fire only at compaction.

**Move target:** Delete bullets 1-3 (standard-knowledge / Anthropic-default behaviour). Move bullets 4-5 into `ai-resources/docs/compaction-protocol.md` with `@`-import gated by `/compact` or `[COST]`.

**Source:** Anthropic "standard-knowledge content" anti-pattern; Cem Karaca four-bucket framework.

### HIGH — `Design Judgment Principles` (~280 tokens)

Four bullets on conflicts, evidence/interpretation separation, provided-sources-only, uncertainty-over-fabrication. Each bullet is its own ~70-token paragraph. Three of the four (separate evidence, provided sources, admit uncertainty) are analytical-work-only and do not apply to the routine command/skill/edit turns that dominate this workspace.

**Move target:** "Conflicts must be surfaced" stays as a one-line bright-line in CLAUDE.md. Move the other three to `ai-resources/docs/analytical-output-principles.md` with `@`-import gated by analytical commands.

**Source:** Anthropic principle "for content only relevant sometimes, use skills/imports".

### HIGH — `Session Guardrails` (~260 tokens)

Four-flag taxonomy with descriptions plus exempted-command list. The exempted-command list (~55 tokens) duplicates information that belongs with each command's frontmatter; full trigger enumeration is already pointed at `ai-resources/docs/session-guardrails.md`.

**Move target:** Trim to flag list (one line each) + pointer. Move exempted-command list into `session-guardrails.md` (already exists per CLAUDE.md text).

**Source:** Anthropic over-specified anti-pattern.

### MEDIUM — `Plan Mode Discipline` (~240 tokens)

Three paragraphs of conditional logic for an edge case (re-entering plan mode after a slash command in a QC-fix flow). Operative only when (a) plan mode is active and (b) QC just fired. Combined incidence is small.

**Move target:** `ai-resources/docs/plan-mode-discipline.md` with `@`-import gated by plan mode.

**Source:** Anthropic over-specified anti-pattern.

### MEDIUM — `Model Escalation` (~245 tokens)

Four-trigger list + action paragraph + de-duplication clause. The de-duplication clause itself is ~50 tokens of "this rule does NOT fire while X is in progress" hedging — operative for one specific overlap.

**Move target:** Trim to triggers + one-line action; move de-duplication note to `ai-resources/docs/model-escalation.md`.

**Source:** Anthropic over-specified anti-pattern.

### MEDIUM — `QC → Triage Auto-Loop` (~290 tokens)

Five-step procedure with embedded skip-conditions in step 1. Operative only when QC subagent has run.

**Move target:** Same as `QC Independence Rule` — co-locate in `ai-resources/docs/qc-independence.md`.

**Source:** Anthropic "use skills/imports for content only relevant sometimes".

### MEDIUM — Cumulative cost of section-headers (file structure) (boundary)

24 H2 headings × ~6 tokens each (`## Heading\n\n`) = ~145 tokens of pure structural overhead. Many H2s wrap a single one-line rule (e.g., `Delivery` is 30 tokens of content under a 6-token header). Collapsing the small H2s into a single "Operating Principles" or "Misc Conventions" block recovers ~80 tokens and reduces visual noise that contributes to "rules get lost".

**Source:** Cem Karaca four-bucket consolidation.

---

## Tier 2 — Cross-File Redundancy

Workspace-only scope, but the workspace points at `ai-resources/docs/*` repeatedly and the in-context system reminder showed `ai-resources/CLAUDE.md` content that overlaps with workspace rules.

### HIGH — `Commit behavior` duplicated in workspace and `ai-resources/CLAUDE.md`

Workspace `## File verification and git commits → Commit behavior` (~140 tokens) says: *"Commit directly. Do not ask for permission, do not run pre-commit checks (git status, git diff), do not run post-commit verification (git status --short). Stage the relevant files, write the commit message, and commit in a single step."*

`ai-resources/CLAUDE.md → ## Commit Rules` says verbatim near-equivalent: *"Commit directly. Do not ask for permission. After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed."* and explicitly notes *"This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded."*

The duplication is acknowledged in code; it remains a Tier 2 finding because verbatim duplication ages independently and produces drift (per Anthropic guidance on canonical-rule duplication). Workspace is canonical; `ai-resources/CLAUDE.md` should pointer-reference, not restate. (Noted here for the operator even though `ai-resources/CLAUDE.md` is out of audit scope — cross-file duplication is bidirectional.)

**Source:** Anthropic guidance on canonical-rule drift.

### MEDIUM — `Skill Library` (workspace) and skill-creation guidance in `ai-resources/CLAUDE.md → Skill Creation and Improvement`

Workspace says "Read the relevant SKILL.md before performing any task that has a corresponding skill. Do NOT edit skill files from project workspaces". `ai-resources/CLAUDE.md` says "See `skills/ai-resource-builder/SKILL.md` for skill format … `/create-skill` and `/improve-skill` read that SKILL.md at invocation."

Substantively complementary, not pure duplication, but the workspace `Skill Library` block + `AI Resource Creation` block + `ai-resources/CLAUDE.md` skill-creation block together cover the same surface in three places.

**Move target:** Collapse workspace `Skill Library` + `AI Resource Creation` into one 3-line block: "Skills live in `ai-resources/skills/`. Use `/create-skill`, `/improve-skill`, `/migrate-skill`. Don't improvise or edit skills from project workspaces."

**Source:** priors.

### MEDIUM — `Autonomy Rules` pause-trigger #2 and `Commit behavior`'s "Pushing requires explicit operator confirmation per Autonomy Rules pause-trigger #2"

Workspace `Autonomy Rules` #2 enumerates pushing as an external/shared-state write requiring pause. `Commit behavior` re-asserts this with a back-reference. Both are correct; the back-reference in `Commit behavior` is functional (cites #2 by number rather than restating). Low-cost as written; flagging because the same constraint appears as text in two locations and risks divergence if either is edited.

**Verdict:** Trim — leave `Autonomy Rules` #2 canonical; in `Commit behavior` say "Push requires operator approval (Autonomy Rules)." rather than restating the rationale.

**Source:** priors.

### LOW — `CLAUDE.md Scoping` and Anthropic memory-precedence docs

`CLAUDE.md Scoping` restates a principle ("CLAUDE.md content loads on every turn — task-type-specific instructions belong at the task-type's home") that is also the central message of Anthropic's memory docs. This is acceptable because the local block adds the workspace-specific operationalization (where to put skill methodology, workflow methodology, etc.). Flagged as boundary because the rationale paragraph at the bottom (`Rationale: …`) restates standard-knowledge.

**Verdict:** Trim the rationale paragraph; the bullet list is the operative content.

**Source:** Anthropic over-specified anti-pattern.

---

## Tier 3 — Contradictions

### HIGH — `Autonomy Rules` "default to full autonomy" vs. `Assumptions Gate` "default to escalation"

`Autonomy Rules`: *"Default posture: **full autonomy**. Claude proceeds through work … without pausing for per-step approval."* and *"When in doubt about severity, err toward proceeding."*

`Assumptions Gate`: *"When an assumptions check surfaces a structural concern … default to escalation to the operator, not self-resolution."* and *"Do not proceed on a rationalization like 'it still adds value' or 'the plan already commits to this structure.'"*

These coexist by genuine intent — `Assumptions Gate` is a narrow exception class — but the document does not give precedence ordering. A reader hitting an ambiguous structural concern can read both rules and pick the one they prefer. The 9-trigger `Autonomy Rules` list does not enumerate "assumptions-gate concern" as a pause-trigger; `Assumptions Gate` does not point back at `Autonomy Rules` to resolve precedence.

**Recommendation:** Add `Assumptions Gate` as pause-trigger #10, or add an explicit precedence line in one or both blocks ("Assumptions Gate overrides default autonomy").

**Source:** Anthropic precedence-ordering best practice.

### HIGH — `Working Principles` "create a new version file rather than overwriting (`v2.md`, not editing `v1.md` in place)" vs. `File Write Discipline` "Outputs … are written normally via `Write` into `output/{project}/`"

`Working Principles` mandates new version files for iteration. `File Write Discipline` describes outputs as `Write` into `output/{project}/` without acknowledging the version-suffix mandate. A reader writing a v2 of an artifact has two pieces of guidance: the version-file rule and the Write-into-output-dir rule, and no explicit statement of how they compose (does v2 land in the same directory? is v1 retained or replaced?).

**Recommendation:** State explicitly in one block: "Iteration produces `…/v2.md` alongside `…/v1.md` in the same output directory; v1 is retained."

**Source:** priors.

### MEDIUM — `QC Independence Rule` "Post-edit QC is mandatory" with skip-conditions vs. `QC → Triage Auto-Loop` Step 3 "Run post-edit QC subagent (fresh context) on the modified artifact"

`QC Independence Rule`: post-edit QC is mandatory unless ≤5 lines, mechanical, validated elsewhere. `QC → Triage Auto-Loop` Step 3: run post-edit QC unconditionally (no skip clause).

When the auto-loop fires on a small triage-derived fix that meets the three skip conditions, do you skip step 3 or run it? Both interpretations are defensible; the document doesn't say.

**Recommendation:** Add to `QC → Triage Auto-Loop` Step 3: "(skip per `QC Independence Rule` skip conditions when applicable)".

**Source:** Anthropic precedence-ordering best practice.

### MEDIUM — `Plan Mode Discipline` ("do not re-enter plan mode for QC fixes") vs. `QC Independence Rule` "Plan QC before presenting plans for approval"

A QC-fix to an *approved plan* (not yet executed) sits at the boundary: is the fix "QC findings on work you just completed" (skip plan mode per `Plan Mode Discipline`) or "presenting a non-trivial plan" (require plan QC per `QC Independence Rule`)? The "tiebreaker" line at the bottom of `Plan Mode Discipline` addresses report-prose only.

**Recommendation:** Extend the tiebreaker to cover the plan-QC overlap, or note explicitly that `QC Independence Rule` plan-QC fires only on the *first* presentation of a plan, not on revisions.

**Source:** priors.

### LOW — `Model Tier` (sessions outside any project default to Sonnet) vs. `Adaptive Thinking Override` (analytical projects opt into the override)

Soft tension — `Model Tier` says workspace-root sessions default to Sonnet for execution; `Adaptive Thinking Override` says analytical projects need the override. A workspace-root analytical session (e.g., a cross-project synthesis) is unaccounted for: no project `.claude/settings.local.json` exists to set the env var.

**Recommendation:** Note in `Model Tier` that workspace-root analytical sessions should explicitly invoke `/model opus` *and* set the env var inline (or accept adaptive-thinking degradation).

**Source:** priors.

---

## Tier 4 — Staleness

### MEDIUM — Reference paths point at `ai-resources/docs/*` files that may or may not exist

CLAUDE.md cites: `ai-resources/docs/ai-resource-creation.md`, `ai-resources/docs/audit-discipline.md`, `ai-resources/docs/session-guardrails.md`, `ai-resources/docs/agent-tier-table.md`, `.claude/references/harness-rules.md`. The audit brief allows verifying paths via Grep but not deep-reading. I did not verify path existence in this pass — flagging as a staleness-watch item: every `@`-style or pointer reference must be resolved or the rule degrades silently. Recommend a one-time Grep sweep to confirm all five paths resolve.

**Source:** MindStudio context-rot guidance.

### MEDIUM — `Plan Mode Discipline → Tiebreaker for the overlap case` references "any project-level 'plan mode before drafting' directive"

The directive being tiebroken against is not in workspace CLAUDE.md and may live in a specific project's CLAUDE.md (out of audit scope). If the project-level directive has been retired, the tiebreaker is dead text. The reference is unverifiable from the workspace file alone.

**Recommendation:** Either remove the tiebreaker (if the project-level rule is gone) or add a one-line citation to the project file that establishes the rule.

**Source:** priors.

### LOW — `Adaptive Thinking Override` references `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`

Env-var-based feature flags drift; this one was introduced in a specific Claude Code release. If Anthropic has changed the flag name or behavior, the CLAUDE.md rule degrades silently. Suggest an annual re-validation or a pointer to live Anthropic docs.

**Source:** Anthropic over-specified anti-pattern (frequently-changing content).

### LOW — `Axcíon's Tool Ecosystem` lists "Research Execution GPT (CustomGPT)"

Tool inventories age; if the CustomGPT is renamed, retired, or replaced, the line is stale. Low-cost to keep evergreen as long as it's reviewed quarterly. Flagged as evergreen-watch, not as a current finding.

**Source:** Anthropic principle on file lists / inventories.

---

## Tier 5 — Misplacement

### HIGH — `QC Independence Rule` (~620 tokens) — entirely methodology, belongs in `ai-resources/docs/`

By the workspace's own `CLAUDE.md Scoping` rule: *"Skill methodology. Belongs in SKILL.md."* and *"Workflow methodology. Belongs in the workflow's reference docs."* QC Independence is operating-process methodology — five sub-rules with rationale. It should live at `ai-resources/docs/qc-independence.md` (or similar) with a 2-line pointer in CLAUDE.md.

**Move target:** `ai-resources/docs/qc-independence.md` (new).

**Source:** Workspace `CLAUDE.md Scoping` self-rule; Anthropic skill-loading guidance.

### HIGH — `QC → Triage Auto-Loop` (~290 tokens) — same misplacement class

Procedural workflow that fires after a specific event. Belongs co-located with `QC Independence Rule` content.

**Move target:** Same as above (`ai-resources/docs/qc-independence.md` § Auto-loop).

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

### HIGH — `Autonomy Rules` numbered triggers (~465 tokens) — methodology with embedded cross-references

Pause-triggers 8 and 9 explicitly point at `ai-resources/docs/audit-discipline.md` for full mechanics. Triggers 1-7 are short bright-lines; 8 and 9 are partial duplications of doc content. Either move the whole list to `ai-resources/docs/autonomy-rules.md` and `@`-import, or move only triggers 8-9 to the doc and keep 1-7 inline.

**Move target:** `ai-resources/docs/autonomy-rules.md` (new), with `@`-import.

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

### MEDIUM — `Session Guardrails` (~260 tokens) — points at `ai-resources/docs/session-guardrails.md` already

The doc exists per the CLAUDE.md pointer. The full taxonomy and exempted-command list could live there.

**Move target:** `ai-resources/docs/session-guardrails.md` (already cited).

**Source:** Anthropic "use imports/skills" + workspace self-rule.

### MEDIUM — `File Write Discipline` (~310 tokens) — file-handling subroutine

Procedural rules for an action class (file writes) that fires on a fraction of turns. The "Operator-pasted content — save verbatim" sub-rule is conditional logic that should live at the home of the file-write skill or the relevant command.

**Move target:** `ai-resources/docs/file-write-discipline.md` (new), with `@`-import. Or fold sub-rules into the relevant command frontmatter.

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

### MEDIUM — `Working Principles → Pre-compact checkpoint` and `Post-compact resumption` (~150 tokens combined)

Compaction-protocol methodology. Fires only at compaction boundaries. Misplaced in always-loaded surface.

**Move target:** `ai-resources/docs/compaction-protocol.md` (new), with `@`-import on `/compact` or `[COST]`.

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

### MEDIUM — `File verification and git commits → Concurrent-session staging discipline` (~175 tokens)

Operational rule for an explicit edge case (concurrent sessions on same repo). The rule is bright-line but applies only when the operator has disclosed a concurrent session.

**Move target:** `ai-resources/docs/concurrent-session-discipline.md` (or under a single git-discipline doc), with `@`-import gated by disclosure.

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

### LOW — `Model Tier → Agents` (H3) — agent-creation guidance

The H3 fires when editing or creating agents. Belongs in `ai-resources/docs/agent-tier-table.md` (already cited).

**Move target:** `ai-resources/docs/agent-tier-table.md` (already exists per pointer).

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

### LOW — `Adaptive Thinking Override` — project-setup guidance

Fires once per project at setup, then never. Belongs in the `/new-project` command or in the project-setup checklist.

**Move target:** `/new-project` command frontmatter or `ai-resources/docs/project-setup.md`.

**Source:** Workspace `CLAUDE.md Scoping` self-rule.

---

## Tier 6 — Clarity

### MEDIUM — `Cross-Model Rules` lacks a precedence line for single-tool sessions

*"Single-tool sessions ignore. Multi-tool projects … honor."* The "ignore" instruction is clear but the boundary condition is fuzzy: a project that is *predominantly* Claude-only but occasionally pings Perplexity — does the rule fire on Perplexity-touching turns only, or for the whole session?

**Suggested rewording:** Replace with: "These rules fire on any turn whose work is assigned (in the project's own CLAUDE.md or the operator's brief) to a non-Claude tool. Otherwise inactive."

### MEDIUM — `Completion Standard` "BLOCKING" vs. "IMPORTANT" thresholds undefined

*"BLOCKING issues (would prevent downstream stages from working) … IMPORTANT issues (degrade downstream quality)"* — two adjectives, no examples, no how-to-decide. A reader has to coin their own classification per finding.

**Suggested rewording:** Add one example each ("BLOCKING: missing required field in handoff schema. IMPORTANT: prose tone inconsistent with prior stage.") or point at a doc that enumerates classes.

### LOW — `Chat Communication Style` — "B2 English" assumes operator knows CEFR levels

*"B2 English"* is a specific CEFR designation. A new collaborator or future model reading this rule has no idea what the bar is.

**Suggested rewording:** "Plain English at intermediate-non-native level (CEFR B2 — short sentences, common words, no idioms or rare technical jargon)."

### LOW — `Working Principles` — "don't skip gates" without enumerating "gates"

Vague modal. What is a gate? Stage transition? Approval point? QC pass?

**Suggested rewording:** Either delete (standard knowledge) or define: "Gates = explicit approval/QC checkpoints declared in a workflow's reference docs."

### LOW — `Session Guardrails` — `[COST]` thresholds joined by "or" but called "advisory"

*"`[COST]` — session has spent ≥4 subagents, ~20 turns, or ≥8 artifacts. Emit and continue."* Three disjunctive conditions, each with a different unit (subagents, turns, artifacts). Are these calibrated to fire roughly together, or independently? If a session has 5 subagents and 3 artifacts and 8 turns, does it fire?

**Suggested rewording:** "Fires when ANY one threshold is met."

### LOW — `Agent Harness` — undefined "harness skill"

*"When running a harness skill, session, or command, load `@.claude/references/harness-rules.md`."* What qualifies as a "harness skill"? The pointer doc presumably lists them — say so.

**Suggested rewording:** "When running a harness skill, session, or command (the triggering list is at the top of the referenced doc), load `@.claude/references/harness-rules.md`."

---

## Per-Block Verdict Table

Every block in the per-file inventory appears below.

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---:|---|---|---|---|
| What This Workspace Is For | workspace | ~40 | Trim | Two sentences sufficient; trim to one-liner | — | Tier 1 (Anthropic over-specified) |
| Projects | workspace | ~75 | Keep | Genuine orientation; small | — | priors |
| Axcíon's Tool Ecosystem | workspace | ~85 | Trim | Useful inventory; cut tool descriptions to one phrase each | — | Tier 1, Tier 4 (staleness watch) |
| Cross-Model Rules | workspace | ~165 | Move | Multi-tool only; methodology | `ai-resources/docs/cross-model-rules.md` | Tier 1, Tier 5, Tier 6 |
| Skill Library | workspace | ~70 | Trim | Collapse with `AI Resource Creation` into one 3-line block | — | Tier 2 |
| AI Resource Creation | workspace | ~55 | Trim | Collapse with `Skill Library` | — | Tier 2 |
| Design Judgment Principles | workspace | ~280 | Move | Three of four bullets are analytical-output-only | `ai-resources/docs/analytical-output-principles.md` | Tier 1, Tier 5 |
| QC Independence Rule | workspace | ~620 | Move | Largest block; pure methodology; QC-event-only | `ai-resources/docs/qc-independence.md` | Tier 1, Tier 5 |
| Assumptions Gate | workspace | ~125 | Keep | Bright-line; rare but load-bearing; add as Autonomy pause-trigger #10 to resolve Tier 3 contradiction | — | Tier 3 |
| Completion Standard | workspace | ~70 | Trim | Bright-line stays; clarify BLOCKING/IMPORTANT (Tier 6) | — | Tier 6 |
| Working Principles | workspace | ~290 | Trim | Delete bullets 1-3 (standard knowledge); move bullets 4-5 to compaction doc | `ai-resources/docs/compaction-protocol.md` (for bullets 4-5) | Tier 1, Tier 5 |
| Chat Communication Style | workspace | ~175 | Keep | Every-turn operative; B2 clarification needed (Tier 6) | — | priors |
| File Write Discipline | workspace | ~310 | Move | File-handling subroutine; rare-fire | `ai-resources/docs/file-write-discipline.md` | Tier 1, Tier 5 |
| Autonomy Rules | workspace | ~465 | Move | Trim to 5-line summary inline; move 9-trigger enumeration | `ai-resources/docs/autonomy-rules.md` | Tier 1, Tier 3, Tier 5 |
| QC → Triage Auto-Loop | workspace | ~290 | Move | Co-locate with QC Independence | `ai-resources/docs/qc-independence.md` § Auto-loop | Tier 1, Tier 3, Tier 5 |
| Session Guardrails | workspace | ~260 | Move | Doc already cited; full taxonomy belongs there | `ai-resources/docs/session-guardrails.md` (existing) | Tier 1, Tier 5 |
| Plan Mode Discipline | workspace | ~240 | Move | Edge-case procedural; QC-fix re-entry only | `ai-resources/docs/plan-mode-discipline.md` | Tier 1, Tier 5 |
| CLAUDE.md Scoping | workspace | ~145 | Trim | Trim rationale paragraph; bullet list is operative | — | Tier 2 |
| Model Tier (H2) | workspace | ~135 | Trim | Trim to 3 lines; per-project default + frontmatter rule | — | Tier 1 |
| Model Tier → Agents (H3) | workspace | ~80 | Move | Agent-creation guidance | `ai-resources/docs/agent-tier-table.md` (existing) | Tier 5 |
| Model Escalation | workspace | ~245 | Trim | Triggers + one-line action stay; move de-duplication clause | `ai-resources/docs/model-escalation.md` | Tier 1 |
| Adaptive Thinking Override | workspace | ~110 | Move | Project-setup-only | `/new-project` command or `ai-resources/docs/project-setup.md` | Tier 5 |
| File verification and git commits (H2 wrapper) | workspace | ~5 | Keep | Header only | — | — |
| Use the filesystem, not git, to verify your own work (H3) | workspace | ~85 | Keep | Bright-line; small; every-turn-applicable | — | priors |
| Commit behavior (H3) | workspace | ~140 | Trim | Trim "ask before push" rationale (covered by Autonomy #2) | — | Tier 2 |
| Commit-boundary sequencing (H3) | workspace | ~85 | Move | Rare-fire; multi-commit single-file edits | `ai-resources/docs/commit-discipline.md` | Tier 5 |
| Concurrent-session staging discipline (H3) | workspace | ~175 | Move | Disclosure-gated; rare | `ai-resources/docs/concurrent-session-discipline.md` | Tier 5 |
| Delivery | workspace | ~30 | Keep | One-liner; appropriate scope | — | priors |
| Agent Harness | workspace | ~50 | Keep | Already a pointer; small | — | Tier 6 (clarification only) |

**Row count: 29** (matches the per-file inventory's 28 numbered entries plus the H2 wrapper row §22).

**Verdict tally:**
- Keep: **6** (What This Workspace Is For — pending trim, Projects, Assumptions Gate, Chat Communication Style, §22 wrapper, §22a, Delivery, Agent Harness — counting 7 if "Trim" Whats… is treated as Keep-with-cut; conservatively 6 strict Keeps)
- Trim: **9** (What This Workspace…, Axcíon's Tool Ecosystem, Skill Library, AI Resource Creation, Completion Standard, Working Principles, CLAUDE.md Scoping, Model Tier H2, Model Escalation, Commit behavior — 10 if What This… is Trim)
- Move: **13** (Cross-Model Rules, Design Judgment Principles, QC Independence Rule, File Write Discipline, Autonomy Rules, QC → Triage Auto-Loop, Session Guardrails, Plan Mode Discipline, Model Tier → Agents, Adaptive Thinking Override, Commit-boundary sequencing, Concurrent-session staging discipline, Working Principles bullets 4-5)
- Delete: **0** outright (Working Principles bullets 1-3 are deleted as part of a Trim verdict; no whole block is wholly deletable)

---

## Estimated Savings

### Trim-only scenario

Cuts within blocks that stay in CLAUDE.md (rationale paragraphs, redundant clauses, standard-knowledge bullets, structural overhead).

| Block | Before | After | Savings |
|---|---:|---:|---:|
| What This Workspace Is For | 40 | 20 | 20 |
| Axcíon's Tool Ecosystem | 85 | 50 | 35 |
| Skill Library + AI Resource Creation merged | 125 | 50 | 75 |
| Completion Standard | 70 | 70 | 0 (clarity-only) |
| Working Principles bullets 1-3 deleted | 290 | 175 | 115 |
| CLAUDE.md Scoping rationale trimmed | 145 | 110 | 35 |
| Model Tier H2 | 135 | 70 | 65 |
| Model Escalation de-duplication clause moved | 245 | 195 | 50 |
| Commit behavior trim | 140 | 100 | 40 |
| Section-header consolidation (collapse 5-6 small H2s into one) | — | — | ~50 |
| **Total trim-only savings** | | | **~485 tokens/turn** |

- Per turn: ~485 tokens
- Per 30-turn session: ~14,550 tokens
- Per 50-turn session: ~24,250 tokens

### Trim + Move + Delete scenario

Includes all Move verdicts (block bodies relocated to docs; 2-3 line pointer kept inline).

| Move | Before | After (pointer) | Savings |
|---|---:|---:|---:|
| QC Independence Rule | 620 | 30 | 590 |
| Autonomy Rules | 465 | 80 (5-line summary + pointer) | 385 |
| File Write Discipline | 310 | 30 | 280 |
| QC → Triage Auto-Loop | 290 | 25 | 265 |
| Session Guardrails | 260 | 60 (flag list + pointer) | 200 |
| Plan Mode Discipline | 240 | 20 | 220 |
| Design Judgment Principles | 280 | 60 (1 bullet + pointer) | 220 |
| Cross-Model Rules | 165 | 30 | 135 |
| Working Principles bullets 4-5 | 150 | 20 | 130 |
| Concurrent-session staging | 175 | 25 | 150 |
| Commit-boundary sequencing | 85 | 15 | 70 |
| Adaptive Thinking Override | 110 | 20 | 90 |
| Model Tier → Agents H3 | 80 | 15 | 65 |
| **Move-only savings** | | | **~2,800 tokens/turn** |

Combined with trim-only savings (some overlap; net estimate after dedup): **~2,500 tokens/turn**

- Per turn: **~2,500 tokens** (file goes from ~4,160 → ~1,650, landing inside the practitioner upper-bound target of ~2,000)
- Per 30-turn session: **~75,000 tokens**
- Per 50-turn session: **~125,000 tokens**

### Breakdown by tier

- **Tier 1 (token cost):** ~2,200 tokens/turn (largest single contributor; drives the bulk of Move verdicts)
- **Tier 2 (redundancy):** ~150 tokens/turn (`Skill Library` + `AI Resource Creation` merge; `Commit behavior` trim; `CLAUDE.md Scoping` rationale)
- **Tier 3 (contradictions):** ~0 token savings (resolution is wording, not deletion) — but reduces silent-drift risk
- **Tier 4 (staleness):** ~0 immediate savings (recommendations are review-cadence) — defends future drift
- **Tier 5 (misplacement):** captured by Tier 1 Move savings (overlapping)
- **Tier 6 (clarity):** ~0 token savings — improves rule-adherence

---

## External Guidance Cited

1. Anthropic — *Best practices for Claude Code* — "over-specified CLAUDE.md", line-by-line necessity test, "Claude ignores half of it". `https://code.claude.com/docs/en/best-practices`
2. Anthropic — *How Claude remembers your project* — hierarchical loading, precedence ordering. `https://code.claude.com/docs/en/memory`
3. Anthropic — *Manage costs effectively* — token-reduction strategies. `https://code.claude.com/docs/en/costs`
4. Cem Karaca (Medium, Apr 2026) — "My CLAUDE.md Was Eating 42,000 Tokens Per Conversation" — four-bucket categorization; <100-line target after restructure.
5. Kjramsy (Medium, 2026) — "Your CLAUDE.md is eating your token budget" — 300-600 token median; >2,000 token alarm.
6. MindStudio — "What Is Context Rot in Claude Code Skills?" — staleness/contradiction failure modes; performance degradation above 70% context fill.
7. Braincuber — "CLAUDE.md Guide | Claude Code Best Practices" — practitioner checklist; prohibitions paired with alternatives.

(Full source list and verbatim quotes in `audit-claude-md-external-guidance-2026-05-04.md`.)

---

## Closing Note

The file is well-engineered at the rule level — most individual rules are sound and load-bearing — but is over-engineered at the document level. The dominant fix pattern is **relocate, don't rewrite**: keep the rules; move the methodology bodies to `ai-resources/docs/*` and `@`-import. The workspace's own `CLAUDE.md Scoping` block prescribes exactly this; the file is currently the largest violator of its own rule.
