# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (axcion-ai-system-redesign)
**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 230 lines, ~3,394 tokens, 29 H2 blocks (+5 H3 under one H2)
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/CLAUDE.md` — 44 lines, ~878 tokens, 6 H2 blocks (+ title/intro preamble)

**Token-estimation method & caveat:** Counts are word × 1.3, ±30% drift vs. a real tokenizer. Block-level estimates are independent approximations and sum slightly above the file totals in the measurement notes; treat all counts as directional. Findings within ±15% of a percentage threshold are tagged `(boundary)`.

**Loading model (weighed throughout):** The project dir is a direct descendant of the workspace root, so the workspace CLAUDE.md loads in this project's sessions via ancestor-walk (guidance §"Notes specific to long-context models," line 35). Both files are therefore always-loaded together here: ~4,270 tokens/turn combined (measurement notes). The workspace file is permanent and loads in **every** workspace session; the project file is temporary (time-boxed design window) and loads only in this project's sessions.

---

## Executive Summary

- **Total findings:** HIGH: 5 / MEDIUM: 12 / LOW: 6
- **Headline:** The workspace file is 230 lines — over the official <200-line target (guidance line 13, rated HIGH severity "when materially over"). It is not bloated with restatement in most blocks (the pointer-to-canonical-doc pattern is used well), but a cluster of **rare-firing gate blocks** carry full trigger/skip mechanics inline when a one-line auto-fire trigger + pointer would serve, and two or three **discretionary prose paragraphs** could compress. The project file's largest weakness is **cross-file redundancy**: three of its six sections (Commit Rules, Session Boundaries, Input File Handling) restate workspace content that already loads via ancestor-walk, and the file itself admits the mirror.
- **Contradictions:** No genuine hard contradiction between or within the files. One *apparent* tension (Decision-Point Posture vs. Plan Mode Discipline) is reconcilable by scope and is routed to Tier 6 as a clarity fix.
- **Projected savings if all HIGH+MEDIUM applied:** ~1,035 tokens/turn in this project's sessions (~820 workspace-permanent + ~215 project-only) → ~31,000 tokens per 30-turn session, ~51,700 per 50-turn session.
- **Net verdict:** Structurally sound and unusually disciplined for its size, but over the length target. Trim the rare-firing gate blocks to trigger+pointer form, compress two prose paragraphs, and delete the project file's duplicated commit/session-boundary/input-handling sections. No deletions of substance required; the fixes are compression and de-duplication.

---

## Per-File Inventory

### Workspace CLAUDE.md (29 H2 blocks; ~3,394 tokens)

| # | Block (H2) | ~Tokens | Type | @-ref |
|---|---|---|---|---|
| 1 | What This Workspace Is For | 26 | Orientation | — |
| 2 | Projects | 72 | Reference/structure | — |
| 3 | Axcíon's Tool Ecosystem | 85 | Reference + 1 rule | — |
| 4 | Cross-Model Rules | 39 | Bright-line + pointer | — |
| 5 | Skill Library | 78 | Bright-line | — |
| 6 | AI Resource Creation | 65 | Bright-line + pointer | — |
| 7 | Placement Discipline | 234 | Gate + triggers | — |
| 8 | Design Judgment Principles | 65 | Discretionary + pointer | — |
| 9 | QC Independence Rule | 156 | Bright-line + pointer | — |
| 10 | Contract-Conformance Check | 195 | Gate + triggers | — |
| 11 | Blind-Spot Scan Gate | 221 | Gate + triggers | — |
| 12 | Assumptions Gate | 91 | Discretionary | — |
| 13 | Completion Standard | 78 | Bright-line | — |
| 14 | Requirements-Doc Default | 169 | Discretionary + planned-cmd | — |
| 15 | Working Principles | 325 | Mixed grab-bag | — |
| 16 | Chat Communication Style | 117 | Bright-line (every turn) | — |
| 17 | File Write Discipline | 33 | Bright-line + pointer | — |
| 18 | Autonomy Rules | 195 | Bright-line list + pointer | — |
| 19 | Decision-Point Posture | 182 | Discretionary prose | — |
| 20 | QC → Triage Auto-Loop | 20 | Pure pointer | — |
| 21 | Session Guardrails | 169 | Bright-line list + pointer | — |
| 22 | Plan Mode Discipline | 59 | Bright-line + pointer | — |
| 23 | CLAUDE.md Scoping | 85 | Bright-line | — |
| 24 | Model Tier | 260 | Bright-line (non-negotiable) | — |
| 25 | Model Escalation | 143 | Gate + procedure | — |
| 26 | Adaptive Thinking Override | 39 | Bright-line | — |
| 27 | File verification and git commits (H2) | 397 | Bright-line (5 H3s) | — |
| 27a | — H3 Use filesystem not git | 52 | Bright-line | — |
| 27b | — H3 Repo-status reporting | 72 | Bright-line | — |
| 27c | — H3 Commit behavior | 65 | Bright-line | — |
| 27d | — H3 Push behavior | 182 | Bright-line + gate | — |
| 27e | — H3 Git edge-case rules | 26 | Pointer | — |
| 28 | Delivery | 33 | Orientation | — |
| 29 | Agent Harness | 59 | Bright-line | `@.claude/references/harness-rules.md` (conditional) |

### Project CLAUDE.md (6 H2 blocks + preamble; ~878 tokens)

| # | Block | ~Tokens | Type | @-ref |
|---|---|---|---|---|
| P0 | Title + intro preamble | 72 | Orientation (scope statement) | — |
| P1 | Model Selection | 143 | Recommended posture | — |
| P2 | Window Operating Rules | 299 | Bright-line (project, every turn) | — |
| P3 | Input File Handling | 10 | Pure pointer | — |
| P4 | Commit Rules | 169 | Bright-line (mirrors workspace) | — |
| P5 | Compaction | 169 | Bright-line (project + generic) | — |
| P6 | Session Boundaries | 20 | Bright-line + pointer | — |

---

## Tier 1 — Token Cost

Thresholds against workspace total (~3,394): 15% = ~509 tokens; 8% = ~272 tokens. No single block exceeds 15%. Two exceed 8% (File verification 11.7%, Working Principles 9.6%); Model Tier at 7.7% is `(boundary)`.

**HIGH — File-level over-length (anchored to `Working Principles` and `File verification and git commits`).** At 230 lines the workspace file is materially over the official <200-line target, which guidance rates HIGH ("Bloated CLAUDE.md files cause Claude to ignore your actual instructions!" — guidance line 13; instruction-crowding, line 14). The two heaviest blocks are the primary reduction targets: `Working Principles` (~325) and `File verification and git commits` (~397) together are ~21% of the file. Neither needs deletion, but both carry compressible weight (see below).

**HIGH — `Working Principles` carries a long prose argument.** The "Structural fix as default style; ROI decides scope" bullet is ~110 words of explanatory argument (the *why* of a maintenance philosophy), not a rule. It applies only during maintenance-fix sessions (<25% of turns) yet loads every turn. Meets the HIGH criterion "long prose argument (explanatory paragraphs rather than rules) that could compress to a bullet list." Verdict: compress to a 1–2 line rule + pointer to a maintenance doc.

**MEDIUM — `File verification and git commits` → H3 Push behavior is verbose.** ~182 tokens including a full quoted confirmation prompt. The push gate fires once per session (at wrap), applies to <50% of turns, and its mechanics are also restated in `Autonomy Rules` item 2 and in the project `Commit Rules`. Terse trigger + pointer to `/wrap-session` would serve.

**MEDIUM — `Model Tier` (~260, 7.7% `(boundary)`).** Applies only to settings edits and command/agent/skill creation (<50% of turns). The non-negotiable core ("no `"model"` field anywhere; no default-model line in any CLAUDE.md") must stay always-loaded; the per-command/agent/skill tiering table detail can move to `agent-tier-table.md` (already pointed to). Trim, keep core.

**MEDIUM — `Placement Discipline` (~234).** Full trigger list + skip list + friction-log clause loads every turn, but the gate only fires when creating a new file in a new/uncertain location (<25% of turns). Trigger/skip mechanics belong in the `/placement` command; keep a one-line "run `/placement` before novel-location files" + pointer.

**MEDIUM — `Contract-Conformance Check` (~195) and `Blind-Spot Scan Gate` (~221).** Both are rare-firing gates (multi-round-QC / post-plan) carrying full trigger enumerations inline. See Tier 5 — the mechanics belong in the implementing commands; a one-line auto-fire trigger + pointer stays.

**MEDIUM — `Requirements-Doc Default` (~169).** Discretionary; fires only on substantive operator-input gaps. Compressible, and it contains a forward-looking "until it ships" clause (see Tier 4).

**LOW — `Decision-Point Posture` (~182) and `Axcíon's Tool Ecosystem` (~85).** Decision-Point is applicable broadly but is prose-dense and could tighten ~30%. Tool Ecosystem's 5-bullet inventory is reference material Claude can largely infer (guidance line 15); only the last sentence ("Always specify tool assignments at the step level") is a rule.

---

## Tier 2 — Redundancy

**HIGH — Project `Commit Rules` duplicates workspace `File verification and git commits` (Commit behavior + Push behavior).** The project section opens "**Commit directly. Do not ask for permission.**" — verbatim substance of the workspace Commit-behavior H3 — and restates the entire push-batching gate. The file *admits* it: "This rule mirrors the canonical `Commit behavior` and `Push behavior` sections in the workspace-level `CLAUDE.md`." The stated justification ("repeated here because projects are sometimes opened without the parent workspace context loaded") is undercut by the loading model: the project dir is a descendant of the workspace root, so the workspace file loads via ancestor-walk in these sessions (guidance line 35). ~130 tokens duplicated. Keep only the *new* clause the workspace lacks — "Never commit files that may contain secrets" — and a one-line pointer.

**HIGH — Project `Session Boundaries` duplicates the workspace `Working Principles` session-boundaries bullet.** Both read "Prefer `/clear` over dirty context when switching tasks" and both point to the same `ai-resources/docs/session-boundaries.md`. Full verbatim duplication across files; the project copy adds nothing project-specific. Delete (workspace copy loads via ancestor-walk).

**MEDIUM — Project `Input File Handling` duplicates workspace `File Write Discipline` pointer.** Both are bare pointers to `ai-resources/docs/file-write-discipline.md`. Spans files (rubric → HIGH) but token weight is trivial (~10). Rated MEDIUM on impact; delete the project copy.

**MEDIUM — Project `Compaction` partially overlaps workspace `Working Principles` compaction bullet + likely the referenced `compaction-protocol.md`.** The project section's project-specific preserve-list (pipeline/stage id, subagent-output paths, pending gate) is legitimately local and should stay. The generic "Post-compact resumption — trust the summary. Do NOT re-derive via `git log`…" rule is not project-specific and probably restates `compaction-protocol.md` (pointed to from workspace Working Principles). Not confirmed by read (the target is a path pointer, not an `@`-import, so outside the read exception). Trim the generic half; keep the project-specific preserve-list.

**MEDIUM — Within-file: push-gate stated three times in the workspace file.** `Autonomy Rules` item 2 ("`git push` is also gated, batched until session end, and confirmed via a single prompt at wrap"), and the `Push behavior` H3 fully restate the same rule; item 2 already cross-references "see `Push behavior` below." Collapse item 2 to a bare reference.

**LOW — QC theme spread across three blocks.** `QC Independence Rule`, `Contract-Conformance Check`, and `QC → Triage Auto-Loop` are distinct functions (not duplicates), but the "unreachable-QC → commit-blocked" paragraph in `QC Independence Rule` restates mechanics it also points to (`qc-independence.md § Subagent-unavailable fallback`). Compress the inline mechanic to the pointer.

**LOW — Coverage asymmetry (not redundancy, noted here).** The secrets-commit rule ("Never commit files that may contain secrets") exists **only** in the project file. Workspace sessions do not get it. Consider promoting to the workspace `Commit behavior` H3 in a later rewrite turn (out of audit scope — flagged, not actioned).

---

## Tier 3 — Contradictions

**No genuine hard contradiction found**, between the two files or within the workspace file. Specific pairs checked and cleared:

- Project `Window Operating Rules` "one work unit per session" vs. workspace session-packaging default — an **explicit, declared override** ("This overrides the workspace default of packaging 1–3 units per session"), which the workspace `Design Judgment Principles` "surface conflicts, don't silently resolve" endorses. Not a contradiction.
- Project `Model Selection` (Fable 5 recommended) vs. workspace `Model Tier` ("model defaults prohibited") — compliant: the project frames it as "recommended posture only, not a default declaration," which `Model Tier` explicitly permits. Not a contradiction.
- `Decision-Point Posture` ("pick and proceed, do not ask") vs. `Autonomy Rules` / `Commit behavior` — consistent (commit is local; autonomy gates are the enumerated exceptions).
- `QC Independence Rule` ("run `/qc-pass` before commit") vs. `Commit behavior` ("commit directly, no pre-commit checks") — reconcilable: QC is a distinct pass; "no pre-commit checks" refers to `git status`/`diff`, not to skipping QC.

**LOW (apparent tension, routed to Tier 6):** `Decision-Point Posture` lists "plan-mode approach selection — pick the recommended option and proceed automatically," while `Plan Mode Discipline` says "after delivering a plan and exiting plan mode, wait for operator confirmation before beginning implementation." These are reconcilable by scope (choosing *which* approach to present vs. *starting to implement* an approved plan), but the text does not draw the boundary. Not a genuine contradiction — treated as a clarity gap. See Tier 6.

---

## Tier 4 — Staleness

**MEDIUM — `Requirements-Doc Default` contains a forward-looking "until it ships" clause.** "A reusable `/create-requirements-doc` command (multi-stage, QC-gated) is a planned resource; until it ships, produce the doc by hand." This is frequently-changing info (guidance line 18 lists it as an exclude): the day the command ships, this text misleads. Convert to command-shipped state or prune to a pointer once available. Cannot filesystem-verify whether it has shipped (out of read scope).

**LOW — Project file is inherently temporary.** The whole project CLAUDE.md governs a time-boxed design window; recent commits show W1.1/W1.3/W1.6/W1.7 already complete. When the window closes, the entire file (and its `pipeline/*`, decision D1/D2, A1/A2, "W0.1 6g escalation" references) becomes stale. Housekeeping note: schedule deletion/archival at window close. No action now.

**LOW — Numeric thresholds are staleness-prone.** `QC Independence Rule` ("1M-credit subagent gate," ">200k-token conversation") and `Session Guardrails` ("~20 turns") bake in specific numbers that drift as the harness/pricing changes. Currently plausible; monitor.

---

## Tier 5 — Misplacement

Per the workspace `CLAUDE.md Scoping` block and guidance lines 17/19/27: multi-step procedures and sometimes-relevant workflows belong in skills / command references / path-scoped rules, not the always-loaded file; content applying to <25% of turns should lazy-load. **Caveat:** for "run X automatically" gates, the *trigger* must stay always-loaded or the gate never fires (the command only loads on invocation). So the correct verdict for these is **Trim** (keep a one-line auto-fire trigger + pointer; move mechanics), not full Move.

**MEDIUM — `Blind-Spot Scan Gate` (~221).** Firing-point detail, skip conditions, and "run once per plan approval" mechanics belong in the `/blindspot-scan` command reference. Keep: "Run `/blindspot-scan` automatically post-plan, pre-implementation" + pointer. Move-target: `/blindspot-scan` command / its reference.

**MEDIUM — `Contract-Conformance Check` (~195).** The four-trigger enumeration belongs in the `/contract-check` command. Keep a one-line trigger summary + pointer. Move-target: `/contract-check` command reference.

**MEDIUM — `Placement Discipline` (~234).** Trigger list + skip list belong in the `/placement` command. Keep the one-line rule + friction-log escalation clause. Move-target: `/placement` command reference.

**MEDIUM — `Model Escalation` (~143).** The escalation procedure ("spawn an Opus subagent with current state…") is a sometimes-relevant workflow. Move the procedure to `autonomy-rules.md` (already partly pointed to); keep the four triggers + one-line action. Move-target: `ai-resources/docs/autonomy-rules.md`.

**LOW — `Requirements-Doc Default` (~169).** Mechanics should live in the planned `/create-requirements-doc` command once it ships; until then keep as a compressed rule. Move-target: `/create-requirements-doc` (planned).

**LOW — `Axcíon's Tool Ecosystem` inventory (~85).** The 5-tool bullet list is reference/context (guidance line 15), not a per-turn rule. Keep the tool-assignment rule; move the inventory to an `ai-resources/` doc or README. Move-target: `ai-resources/docs/` (tooling reference).

**Note — gates that guidance says should be hooks, not prose.** `Blind-Spot Scan Gate` and `QC Independence Rule` describe rules that "must fire every time" via memory-dependent prose. Guidance line 19 ("advisory text doing a hook's job") flags this as a conversion signal: a deterministic hook enforces better than always-loaded prose and costs zero per-turn tokens. Structural recommendation for a later turn — out of this audit's edit scope.

---

## Tier 6 — Clarity

**MEDIUM — `Decision-Point Posture` vs. `Plan Mode Discipline` scope boundary.** As in Tier 3: add a one-clause carve-out so "proceed automatically at decision points" is not read as license to skip the plan-approval gate. Proposed disambiguation lives in a rewrite turn; the fix is a scope clause, not new substance.

**LOW — `Working Principles` → "Context constraint deferral" uses a vague threshold.** "When context is clearly constrained (extended session, approaching compaction threshold)" — "clearly constrained" has no bright-line. A concrete trigger (e.g., a token/percentage or turn count) would remove the judgment call.

**LOW — `Model Escalation` → "plausible but shallow — repeats your inputs without improving them."** Subjective; acceptable given the accompanying examples, but inherently a judgment trigger.

**LOW — `Session Guardrails` → `[COST]` "~20 turns."** Approximate modifier ("~") on a firing threshold; acceptable but soft.

---

## Per-Block Verdict Table

Every block from both inventories appears. Move-target given only for Move/Trim-with-relocation verdicts.

### Workspace CLAUDE.md

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | 26 | Keep | Minimal orientation; earns its cost | — | priors |
| Projects | workspace | 72 | Trim | Structure Claude can infer; keep brief pointer to `ai-resources/CLAUDE.md` | — | guidance L15 |
| Axcíon's Tool Ecosystem | workspace | 85 | Trim | Keep tool-assignment rule; relocate 5-bullet inventory | `ai-resources/docs/` tooling ref | guidance L15 |
| Cross-Model Rules | workspace | 39 | Keep | Already pointer form; core rule terse | — | priors |
| Skill Library | workspace | 78 | Keep | Bright-line, applies broadly | — | priors |
| AI Resource Creation | workspace | 65 | Keep | Bright-line + pointer, well-formed | — | guidance L31 |
| Placement Discipline | workspace | 234 | Trim | Rare trigger (<25% turns); move trigger/skip lists to command, keep 1-line + friction-log clause | `/placement` cmd ref | guidance L17,L27 |
| Design Judgment Principles | workspace | 65 | Keep | Cross-cutting rule + pointer | — | priors |
| QC Independence Rule | workspace | 156 | Trim | Compress inline "unreachable-QC" mechanic to its pointer | `qc-independence.md` | guidance L31 |
| Contract-Conformance Check | workspace | 195 | Trim | Rare fire; move 4-trigger list to command, keep 1-line + pointer | `/contract-check` cmd ref | guidance L17 |
| Blind-Spot Scan Gate | workspace | 221 | Trim | Rare fire; move firing detail to command, keep auto-fire trigger; hook-conversion candidate | `/blindspot-scan` cmd ref | guidance L17,L19 |
| Assumptions Gate | workspace | 91 | Keep | Bright-line behavior rule | — | priors |
| Completion Standard | workspace | 78 | Keep | BLOCKING/IMPORTANT well-specified | — | guidance L25 |
| Requirements-Doc Default | workspace | 169 | Trim | Compress; prune "until it ships" clause (staleness) | `/create-requirements-doc` (planned) | guidance L18 |
| Working Principles | workspace | 325 | Trim | Compress "Structural fix" prose argument to rule + pointer; largest discretionary block | maintenance doc | guidance L23,L25 |
| Chat Communication Style | workspace | 117 | Keep | Project-specific, applies every chat turn; not inferable | — | guidance L24 |
| File Write Discipline | workspace | 33 | Keep | Bright-line + pointer | — | guidance L31 |
| Autonomy Rules | workspace | 195 | Trim | Collapse item 2 push restatement to bare cross-ref (within-file dup) | — | guidance L16 |
| Decision-Point Posture | workspace | 182 | Trim | Tighten prose ~30%; add scope clause vs Plan Mode | — | priors |
| QC → Triage Auto-Loop | workspace | 20 | Keep | Pure pointer, ideal form | — | guidance L31 |
| Session Guardrails | workspace | 169 | Keep | Applies broadly; four flags terse; minor trim only | — | priors |
| Plan Mode Discipline | workspace | 59 | Keep | Bright-line gate; add scope clause vs Decision-Point | — | priors |
| CLAUDE.md Scoping | workspace | 85 | Keep | The governing rule this audit enforces | — | priors |
| Model Tier | workspace | 260 | Trim | Keep non-negotiable core; move per-command/agent tiering detail to referenced doc | `agent-tier-table.md` | guidance L17 |
| Model Escalation | workspace | 143 | Trim | Move procedure to autonomy doc; keep triggers + 1-line action | `autonomy-rules.md` | guidance L17 |
| Adaptive Thinking Override | workspace | 39 | Keep | Terse env rule; not inferable | — | guidance L24 |
| File verification and git commits (H2) | workspace | 397 | Trim | Largest block; trim Push-behavior H3 (see below) | — | guidance L13 |
| — Use filesystem not git (H3) | workspace | 52 | Keep | Non-obvious gotcha, applies every write | — | guidance L24 |
| — Repo-status reporting (H3) | workspace | 72 | Keep | Bright-line; minor trim possible | — | priors |
| — Commit behavior (H3) | workspace | 65 | Keep | Core commit rule, applies broadly | — | priors |
| — Push behavior (H3) | workspace | 182 | Trim | Verbose (quoted prompt); fires once/session; restated in Autonomy item 2 + project Commit Rules | `/wrap-session` cmd | guidance L16 |
| — Git edge-case rules (H3) | workspace | 26 | Keep | Pure pointer | — | guidance L31 |
| Delivery | workspace | 33 | Keep | Terse orientation fact | — | priors |
| Agent Harness | workspace | 59 | Keep | Conditional `@`-load, correctly scoped | — | guidance L27 |

### Project CLAUDE.md

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Title + intro preamble | project | 72 | Keep | Design-only scope statement; governs every turn here | — | priors |
| Model Selection | project | 143 | Keep | Compliant recommended posture (workspace Model Tier permits); minor trim of restated reasoning | — | priors |
| Window Operating Rules | project | 299 | Keep | Genuinely project-specific, applies every turn; declared override, not restatement | — | guidance L31 |
| Input File Handling | project | 10 | Delete | Bare-pointer duplicate of workspace File Write Discipline (loads via ancestor-walk) | — | guidance L16,L35 |
| Commit Rules | project | 169 | Trim | Cross-file dup of workspace commit/push; keep only secrets-commit rule + 1-line pointer | — | guidance L16,L35 |
| Compaction | project | 169 | Trim | Keep project-specific preserve-list; drop generic "trust the summary" (likely dup of compaction-protocol.md) | `compaction-protocol.md` | guidance L17 |
| Session Boundaries | project | 20 | Delete | Verbatim dup of workspace Working Principles bullet, same pointer target | — | guidance L16,L35 |

---

## Estimated Savings

Applying all HIGH+MEDIUM verdicts (compression, not deletion of substance). Estimates are word × 1.3, ±30%.

- **Per turn (this project's sessions, workspace + project):** ~1,035 tokens
  - Workspace-permanent portion (all workspace sessions): ~820 tokens
  - Project-only portion (this window's sessions): ~215 tokens
- **Per 30-turn session:** ~31,000 tokens
- **Per 50-turn session:** ~51,700 tokens

**Breakdown by tier (deduplicated — Tier 5 gate-trims overlap Tier 1 and are counted once):**

| Source | ~Tokens/turn saved |
|---|---|
| Tier 1/5 — trim rare-firing gates + verbose prose (Placement, Blind-Spot, Contract-Conformance, Requirements-Doc, Model Escalation, Model Tier, Working Principles, Decision-Point, Push behavior, Tool-Ecosystem inventory) | ~700 (workspace) |
| Tier 2 — within-workspace dedup (Autonomy item 2, QC inline mechanic) | ~120 (workspace) |
| Tier 2 — project cross-file dedup (Commit Rules, Session Boundaries, Input File Handling, Compaction generic half) | ~215 (project) |
| Tier 4/6 — staleness prune + clarity edits | net ~0 (edits, not cuts) |

**Reaching under the 200-line target:** the workspace-permanent ~820-token reduction corresponds to roughly 55–60 lines removed, bringing the file from 230 lines to ~170–175 — under the official target and below the instruction-crowding concern (guidance lines 13–14).

---

## External Guidance Cited

- **L13** — Over-length file (>200 lines); HIGH when materially over. → Tier 1 file-level HIGH; savings target.
- **L14** — Instruction crowding (~150–200 instruction ceiling). → Tier 1 file-level HIGH.
- **L15** — Duplicating what the model can infer (structure/inventory). → Projects, Tool Ecosystem trims.
- **L16** — Verbatim duplication across files/layers; MEDIUM–HIGH. → Tier 2 cross-file findings, within-file push dup.
- **L17** — Methodology in the always-loaded file belongs in skills/path-scoped rules. → Tier 5 gate-block trims.
- **L18** — Frequently-changing info is an exclude (goes stale). → Requirements-Doc "until it ships" clause (Tier 4).
- **L19** — Advisory text doing a hook's job should convert to a hook. → Blind-Spot / QC gate hook-conversion note.
- **L23** — Deletion test ("would removing this cause a mistake?"). → Working Principles prose finding.
- **L24** — Include list (non-obvious gotchas, env quirks, style differing from defaults). → Keep verdicts (Chat Style, Adaptive Thinking, filesystem-not-git).
- **L25** — Specificity beats vagueness. → Completion Standard Keep; Working Principles compress.
- **L27** — Path-scoped rules load only when relevant. → Tier 5 relocation targets.
- **L31** — Pointer-not-restatement is the sanctioned pattern. → Keep verdicts for pure-pointer blocks; compress inline-restated mechanics.
- **L35** — Ancestor-walk loads workspace-root CLAUDE.md in descendant project sessions. → Undercuts the project file's stated reason for duplicating commit/session-boundary/input-handling content (Tier 2 HIGH).
