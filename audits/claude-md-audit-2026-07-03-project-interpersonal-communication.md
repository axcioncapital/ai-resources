# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (interpersonal-communication). This run is **project-weighted**: per the invoking task, the workspace CLAUDE.md loads in these sessions via ancestor-walk and its *internal* findings are already covered by a separate committed workspace audit. Findings here concentrate on the PROJECT file and on cross-file redundancy between project ↔ workspace. Workspace-internal blocks are inventoried and given a `Keep — deferred to workspace audit` verdict unless they participate in a cross-file finding.

**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 231 lines, ~3,300 tokens (est.)
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/interpersonal-communication/CLAUDE.md` — 46 lines, ~1,015 tokens (est.)

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`. The workspace total is a coarse estimate (not the focus of this run); the project total is measured block-by-block.

**Note on the ai-resources CLAUDE.md:** `ai-resources/CLAUDE.md` also loads in the wider environment and independently restates commit/compaction rules. It is *out of this run's scope* (workspace + interpersonal-communication only), but it is noted below where a project rule is in fact triple-covered.

---

## Executive Summary

- **Total findings: HIGH: 7 / MEDIUM: 5 / LOW: 2.**
- The 7 HIGH findings cluster onto **4 root blocks in the project file** — *Input File Handling*, *Compaction*, *Commit Rules*, and *Session Boundaries* — each flagged under more than one tier (token cost + cross-file redundancy + misplacement all land on the same over-weight, duplicated blocks). This is not 7 independent problems; it is 4 blocks that each fail several tiers.
- **Projected token savings if all HIGH+MEDIUM applied: ~770 tokens/turn** (project file shrinks from ~1,015 to ~245 tokens). At always-loaded framing: ~23,100 tokens across a 30-turn session; ~38,500 across a 50-turn session.
- **Net verdict:** The project CLAUDE.md is ~75% duplicated methodology that the workspace file (and its pointed-to docs) already carries. Its own stated justification for the duplication — "projects are sometimes opened without the parent workspace context loaded" — is **factually false for this setup** (ancestor-walk always loads the workspace root here), which removes the main argument for keeping the duplication. Trim the three big mirrored blocks to short pointers, delete the verbatim Session Boundaries block, and fix one stray-word defect.

---

## Per-File Inventory

### Workspace CLAUDE.md (inventory only — internal findings deferred to the committed workspace audit)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | ~25 | context | — |
| Projects | ~70 | context | pointer → ai-resources/CLAUDE.md |
| Axcíon's Tool Ecosystem | ~70 | context | — |
| Cross-Model Rules | ~40 | rule + ref | cross-model-rules.md |
| Skill Library | ~70 | rule | — |
| AI Resource Creation | ~65 | rule + ref | ai-resource-creation.md |
| Placement Discipline | ~230 | rule + ref | friction-log.md |
| Design Judgment Principles | ~55 | rule + ref | analytical-output-principles.md |
| QC Independence Rule | ~180 | rule + ref | qc-independence.md |
| Contract-Conformance Check | ~170 | rule | — |
| Blind-Spot Scan Gate | ~180 | rule | — |
| Assumptions Gate | ~85 | rule | — |
| Completion Standard | ~75 | rule | — |
| Requirements-Doc Default | ~140 | rule | — |
| Working Principles | ~330 | rule + ref | compaction-protocol.md, session-boundaries.md, +others |
| Chat Communication Style | ~130 | rule | — |
| File Write Discipline | ~35 | rule + ref | file-write-discipline.md |
| Autonomy Rules | ~200 | rule + ref | autonomy-rules.md, audit-discipline.md |
| Decision-Point Posture | ~150 | rule | — |
| QC → Triage Auto-Loop | ~30 | ref | qc-independence.md |
| Session Guardrails | ~140 | rule + ref | session-guardrails.md |
| Plan Mode Discipline | ~55 | rule + ref | plan-mode-discipline.md |
| CLAUDE.md Scoping | ~75 | rule | — |
| Model Tier | ~230 | rule + ref | agent-tier-table.md |
| Model Escalation | ~130 | rule + ref | autonomy-rules.md |
| Adaptive Thinking Override | ~40 | rule | — |
| File verification and git commits (Repo-status / Commit / Push / Git edge) | ~330 | rule + ref | commit-discipline.md |
| Delivery | ~35 | rule | — |
| Agent Harness | ~55 | rule + ref | @.claude/references/harness-rules.md |

### Project CLAUDE.md (interpersonal-communication)

| Block | ~Tokens | % of file | Type | @-refs |
|---|---|---|---|---|
| Title / intro (`# interpersonal-communication`) | ~39 | 4% | context | — |
| Input File Handling | ~455 | 45% | rule (methodology) | pointer → workspace CLAUDE.md (by wrong name) |
| Commit Rules | ~175 | 17% | rule | pointer → workspace CLAUDE.md |
| Compaction | ~210 | 21% | rule (methodology) | — |
| Session Boundaries | ~20 | 2% | rule + ref | session-boundaries.md |
| Model Selection | ~117 | 12% | rule + ref | pointer → workspace § Model Tier |

---

## Tier 1 — Token Cost

**T1-1 · Input File Handling · project · HIGH.** ~455 tokens = **~45% of the 1,015-token file** — three times the 15% HIGH threshold. It is a seven-bullet prose expansion (default-to-Read, don't-materialize, don't-co-locate, outputs-are-different, operator-pasted-verbatim, legitimate-copying exception) of a rule the workspace carries in a **2-line pointer** ("File Write Discipline" → `ai-resources/docs/file-write-discipline.md`). The granular sub-rules (verbatim-save, copying exception) apply to well under 25% of turns. Fails two HIGH criteria at once: long prose that compresses to a pointer, and duplication of lazy-loadable doc content. *Why it costs:* it is the single heaviest block in the file and is paid on every turn. Guidance: over-length file; methodology-in-always-loaded-file; pointer-not-restatement.

**T1-2 · Compaction · project · HIGH.** ~210 tokens = ~21% of file, over the 15% threshold, and applies only at `/compact` events (<25% of turns). Procedural detail ("write a short session-state scratchpad… `/clear` + restart", "trust the summary, do NOT re-derive via git log") that the workspace delegates to `ai-resources/docs/compaction-protocol.md` and that `ai-resources/CLAUDE.md` also restates. *Why it costs:* always-loaded weight for a rarely-triggered procedure.

**T1-3 · Commit Rules · project · MEDIUM `(boundary)`.** ~175 tokens = ~17% of file (within ±15% of the 15% line → boundary-tagged). Exceeds 8% and applies to <50% of turns (commit turns). Primary problem is redundancy (T2-2); flagged here for the always-loaded token weight it adds.

---

## Tier 2 — Redundancy

**T2-1 · Session Boundaries · project ↔ workspace · HIGH (cross-file).** Project lines 37–39 are **near-verbatim** the workspace Working Principles bullet (line 98):
- Project: *"Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`."*
- Workspace: *"**Session boundaries.** Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`."*

The workspace bullet already loads via ancestor-walk in every project session (confirmed by the invoking task). This block adds no new information — pure duplicate. Verdict: Delete.

**T2-2 · Commit Rules · project ↔ workspace (↔ ai-resources) · HIGH (cross-file).** Project lines 18–24 restate the workspace "Commit behavior" + "Push behavior" blocks (lines 204–218). The project block itself says: *"This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`."* The same rule is *also* carried a third time in `ai-resources/CLAUDE.md` § Commit Rules. Triple coverage of one rule → divergence risk on the next edit (guidance: "if two rules contradict, Claude may pick one arbitrarily"). The block's stated justification for duplicating — "projects are sometimes opened without the parent workspace context loaded" — is false here (see T4-2), so the redundancy is not earning its keep. Verdict: Trim to a one-line pointer.

**T2-3 · Input File Handling · project ↔ workspace · HIGH (cross-file).** Project lines 5–16 are the expanded form of the workspace "File Write Discipline" pointer (lines 114–116, → `ai-resources/docs/file-write-discipline.md`). Same substance, ~13× the tokens. The project block claims to "mirror the canonical `Input File Handling` section" of the workspace file — but the workspace section is titled *File Write Discipline*, not *Input File Handling* (see T4-1). Verdict: Trim to pointer.

**T2-4 · Compaction · project ↔ workspace (↔ ai-resources) · HIGH (cross-file).** Project lines 26–35 duplicate the substance of the workspace compaction pointer (line 97 → `ai-resources/docs/compaction-protocol.md`) and overlap `ai-resources/CLAUDE.md` § Compaction. The "trust the summary / do NOT re-derive via git log" paragraph also restates a standing memory note. Verdict: Trim to pointer, keeping at most the project-specific preserve-list items not covered upstream.

---

## Tier 3 — Contradictions

**None found between the two in-scope files.** Commit/push rules align (commit directly, batch-and-gate push); Model Selection is explicitly permitted by workspace § Model Tier; the two Input File Handling sub-rules that look opposed (line 9 "never Write against input files" vs. line 13 "use Write to save operator-pasted content") are reconciled inside the block — pasted chat content is not a file-on-disk input. The false-premise justification (T4-2) is a staleness issue, not a behavioral contradiction.

---

## Tier 4 — Staleness

**T4-1 · Input File Handling mirror-claim references a non-existent workspace heading · project · MEDIUM.** Line 16: *"This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`."* The workspace file has **no** `Input File Handling` heading — the corresponding section is `File Write Discipline` (line 114). The cross-reference is inaccurate today and will drift silently if the workspace section or its doc is renamed. (This is a diagnostic note; the block's disposition is driven by T2-3 / T5-1.)

**T4-2 · "opened without the parent workspace context loaded" justification is false for this setup · project · MEDIUM.** Both the Input File Handling block (line 16) and the Commit Rules block (line 24) justify their duplication with *"projects are sometimes opened without the parent workspace context loaded."* Per the invoking task and the external-guidance note (*"ancestor-walk from cwd still loads workspace-root CLAUDE.md normally"*), the workspace root **always** loads in these sessions. The premise that motivates keeping the duplicated blocks does not hold — which materially strengthens the T2-2 / T2-3 redundancy verdicts.

---

## Tier 5 — Misplacement

**T5-1 · Input File Handling · project · HIGH (>300 tokens).** ~455-token methodology block. Per workspace § CLAUDE.md Scoping ("Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not") the detail belongs in the canonical doc. **Move target:** `ai-resources/docs/file-write-discipline.md` (already the workspace pointer target); the project keeps at most a one-line pointer. Guidance: methodology-in-always-loaded-file; pointer-not-restatement.

**T5-2 · Compaction · project · MEDIUM (<300 tokens).** Procedural compaction detail belongs in the canonical doc. **Move target:** `ai-resources/docs/compaction-protocol.md`; retain only genuinely project-specific preserve-list items as a short pointer-plus-delta.

**T5-3 · Commit Rules · project · MEDIUM.** Canonical home is the workspace file (which already carries the full rule) and `ai-resources/docs/commit-discipline.md` for edge cases. **Move target:** replace with a one-line pointer to workspace § File verification and git commits.

---

## Tier 6 — Clarity

**T6-1 · Stray "Ninja" token · project · LOW.** Line 7 ends: *"…do not copy or rewrite them. **Ninja**"* — an orphan word with no rule attached, almost certainly an editing/paste artifact. It attaches to no instruction and slightly degrades the block's credibility. Remove.

**T6-2 · Model Selection restates prohibition rationale · project · LOW.** Lines 43 first-sentence restate the workspace § Model Tier prohibition ("never add a `model` field…") that already always-loads; the load-bearing, legitimately project-local content is the second part ("Recommended posture: Sonnet 1M for KB ops… Opus for strategic analysis"). Trim the restated prohibition to a pointer; keep the recommended-posture line (which workspace § Model Tier explicitly sanctions).

---

## Per-Block Verdict Table

Every project block appears in full detail. Workspace blocks appear with a `Keep — deferred to workspace audit` verdict except where they are the source side of a cross-file finding (marked ⇄).

### Project — interpersonal-communication

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Title / intro | project | ~39 | Keep | Concise project identity; load-bearing orientation. | — | priors |
| Input File Handling | project | ~455 | Trim (→ pointer) | 45% of file; cross-file dup of workspace File Write Discipline; >300t methodology; mirror-claim names a non-existent heading. T1-1/T2-3/T4-1/T5-1. | ai-resources/docs/file-write-discipline.md | best-practices (deletion test, over-length); memory doc (imports don't save context) |
| Commit Rules | project | ~175 | Trim (→ pointer) | Triple-covered (workspace + ai-resources); false "opened without workspace" premise. T1-3/T2-2/T4-2/T5-3. | workspace § File verification and git commits | best-practices (verbatim-dup contradiction risk) |
| Compaction | project | ~210 | Trim (→ pointer + delta) | 21% of file, rarely triggered; dup of compaction-protocol.md + ai-resources. T1-2/T2-4/T5-2. | ai-resources/docs/compaction-protocol.md | best-practices (methodology in always-loaded) |
| Session Boundaries | project | ~20 | Delete | Near-verbatim workspace duplicate that already ancestor-loads. T2-1. | — (rule stays in workspace) | best-practices (verbatim duplication) |
| Model Selection | project | ~117 | Trim | Keep recommended-posture line (sanctioned by workspace § Model Tier); drop restated prohibition. T6-2. | pointer → workspace § Model Tier | workspace § Model Tier (permits posture note) |

### Workspace (deferred; cross-file sources marked ⇄)

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| File Write Discipline | workspace | ~35 | Keep ⇄ | Canonical pointer; source side of T2-3. Correct shape — project should mirror this brevity. | — | priors |
| File verification and git commits (Commit / Push) | workspace | ~330 | Keep ⇄ | Canonical commit/push rule; source side of T2-2. | — | priors |
| Working Principles (→ Session boundaries + Compaction bullets) | workspace | ~330 | Keep ⇄ | Canonical session-boundaries + compaction pointers; source side of T2-1 / T2-4. | — | priors |
| Model Tier | workspace | ~230 | Keep ⇄ | Canonical model-default prohibition + posture-note permission; source side of T6-2. | — | priors |
| What This Workspace Is For | workspace | ~25 | Keep — deferred | Workspace-internal; covered by committed workspace audit. | — | n/a |
| Projects | workspace | ~70 | Keep — deferred | " | — | n/a |
| Axcíon's Tool Ecosystem | workspace | ~70 | Keep — deferred | " | — | n/a |
| Cross-Model Rules | workspace | ~40 | Keep — deferred | " | — | n/a |
| Skill Library | workspace | ~70 | Keep — deferred | " | — | n/a |
| AI Resource Creation | workspace | ~65 | Keep — deferred | " | — | n/a |
| Placement Discipline | workspace | ~230 | Keep — deferred | " | — | n/a |
| Design Judgment Principles | workspace | ~55 | Keep — deferred | " | — | n/a |
| QC Independence Rule | workspace | ~180 | Keep — deferred | " | — | n/a |
| Contract-Conformance Check | workspace | ~170 | Keep — deferred | " | — | n/a |
| Blind-Spot Scan Gate | workspace | ~180 | Keep — deferred | " | — | n/a |
| Assumptions Gate | workspace | ~85 | Keep — deferred | " | — | n/a |
| Completion Standard | workspace | ~75 | Keep — deferred | " | — | n/a |
| Requirements-Doc Default | workspace | ~140 | Keep — deferred | " | — | n/a |
| Chat Communication Style | workspace | ~130 | Keep — deferred | " | — | n/a |
| Autonomy Rules | workspace | ~200 | Keep — deferred | " | — | n/a |
| Decision-Point Posture | workspace | ~150 | Keep — deferred | " | — | n/a |
| QC → Triage Auto-Loop | workspace | ~30 | Keep — deferred | " | — | n/a |
| Session Guardrails | workspace | ~140 | Keep — deferred | " | — | n/a |
| Plan Mode Discipline | workspace | ~55 | Keep — deferred | " | — | n/a |
| CLAUDE.md Scoping | workspace | ~75 | Keep — deferred | " | — | n/a |
| Model Escalation | workspace | ~130 | Keep — deferred | " | — | n/a |
| Adaptive Thinking Override | workspace | ~40 | Keep — deferred | " | — | n/a |
| Delivery | workspace | ~35 | Keep — deferred | " | — | n/a |
| Agent Harness | workspace | ~55 | Keep — deferred | " | — | n/a |

---

## Estimated Savings

- **Per turn: ~770 tokens** (project file trimmed from ~1,015 to ~245 tokens: Title ~39 + Input-Handling pointer ~40 + Commit pointer ~25 + Compaction pointer+delta ~60 + Session Boundaries 0 + Model Selection ~80).
- **Per 30-turn session: ~23,100 tokens.**
- **Per 50-turn session: ~38,500 tokens.**
- Framing caveat: CLAUDE.md is always-loaded, so "per turn" reflects the resident context weight processed each turn (prompt-cached, but still occupying the window and adherence budget). The adherence benefit — fewer competing instructions — is separate from and additional to the raw token saving (guidance: instruction-crowding).

**Breakdown by block (avoids double-counting across tiers):**
- Input File Handling → pointer: ~415 saved (primary Tier 5; also T1/T2/T4).
- Commit Rules → pointer: ~150 saved (primary Tier 2; also T1/T4/T5).
- Compaction → pointer+delta: ~150 saved (primary Tier 1/5; also T2).
- Session Boundaries → delete: ~20 saved (Tier 2).
- Model Selection → trim: ~40 saved (Tier 2/6).
- Total ≈ **775 tokens/turn.**

**Breakdown by tier (primary attribution):** Tier 1 ~150 · Tier 2 ~210 · Tier 5 ~415. (Tiers 3/4/6 carry accuracy and clarity value but negligible standalone token savings.)

---

## External Guidance Cited

1. **Over-length file / bloat reduces adherence** — official best-practices (code.claude.com/docs/en/best-practices), via GUIDANCE_PATH § Identified anti-patterns. Drives T1-1.
2. **Methodology in the always-loaded file belongs in skills/docs** — GUIDANCE_PATH § anti-patterns. Drives T1-2, T5-1, T5-2.
3. **Verbatim duplication across files/layers → contradiction risk + double cost** ("if two rules contradict, Claude may pick one arbitrarily") — official memory docs, via GUIDANCE_PATH. Drives T2-1, T2-2, T2-3, T2-4.
4. **Pointer-not-restatement is the sanctioned way to keep detail out of the always-loaded layer** (matches this workspace's own § CLAUDE.md Scoping) — GUIDANCE_PATH § best practices. Drives all Trim-to-pointer verdicts.
5. **Deletion test** ("would removing this cause Claude to make a mistake? if not, cut") — official, via GUIDANCE_PATH. Drives Session Boundaries Delete (T2-1).
6. **@-imports / duplication do not save context; ancestor-walk loads workspace root normally** — GUIDANCE_PATH § long-context notes. Drives T4-2 (false-premise justification).
7. **Instruction-crowding (~150–200 instruction budget)** — GUIDANCE_PATH § anti-patterns. Supports the adherence-benefit note in Estimated Savings.
