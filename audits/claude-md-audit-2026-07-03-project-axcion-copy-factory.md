# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (project-weighted; workspace findings covered by a separate committed workspace audit)
**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 231 lines, ~3,800 tokens
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-copy-factory/CLAUDE.md` — 277 lines, ~4,650 tokens

**Combined always-loaded weight in this project's sessions:** ~8,450 tokens (workspace loads via ancestor-walk from the project cwd; the ai-resources CLAUDE.md is an `--add-dir` mount and does NOT auto-load here, so it is out of the per-turn budget for these sessions).

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. the real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

**Method note:** No NOTES_PATH (measurements file) was supplied to this run, so all token figures are this auditor's word×1.3 estimates rather than tokenizer-measured. Turn-frequency judgments ("applies to <25% of turns") are inferred from each block's own stated load-timing (e.g., "NOT loaded at runtime by /copy-task") and from the two-command surface (`/copy-brief`, `/copy-task`) the project describes.

---

## Executive Summary

- **Total findings: HIGH: 4 / MEDIUM: 8 / LOW: 4**
- **Projected token savings if all HIGH+MEDIUM applied: ~1,900 tokens/turn** (~57,000 tokens/session at 30 turns; ~95,000 at 50 turns). That is ~41% of the project file's always-loaded weight.
- **Net verdict:** The project CLAUDE.md is a well-organized but oversized file (277 lines vs. the 200-line official target) whose bloat is driven by embedded command methodology — the `Source Routing Map`, `Page-Level Handling Rule`, `Voice Check Checklist`, `Handoff Standard`, `GPT Pass-Prompt Convention`, and `Runtime Context Loading Rule` are `/copy-brief` / `/copy-task` internals that belong in command references and should load on demand, not every turn — plus four workspace-mirror sections that duplicate always-loaded workspace rules. The core governance blocks (Project Boundary, Communication Craft Standard, Claim Safety, Cross-Project Permission Boundary, Autonomy Posture) are sound and project-specific; keep them. No true behavior-corrupting contradictions were found — two apparent workspace-vs-project tensions are reconciled scoped overrides that would benefit from an explicit cross-reference.

---

## Per-File Inventory

### Workspace CLAUDE.md (231 lines, ~3,800 tokens — assessed in separate workspace audit; listed here for cross-file analysis)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | 30 | descriptive | — |
| Projects | 90 | descriptive | — |
| Axcíon's Tool Ecosystem | 70 | descriptive | — |
| Cross-Model Rules | 50 | bright-line + pointer | plain path |
| Skill Library | 75 | bright-line | — |
| AI Resource Creation | 70 | bright-line + pointer | plain path |
| Placement Discipline | 220 | discretionary + pointer | plain path |
| Design Judgment Principles | 70 | bright-line + pointer | plain path |
| QC Independence Rule | 180 | bright-line + pointer | plain path |
| Contract-Conformance Check | 200 | discretionary | — |
| Blind-Spot Scan Gate | 200 | bright-line | — |
| Assumptions Gate | 90 | bright-line | — |
| Completion Standard | 90 | bright-line | — |
| Requirements-Doc Default | 170 | discretionary | — |
| Working Principles | 360 | mixed + pointers | plain paths |
| Chat Communication Style | 140 | bright-line | — |
| File Write Discipline | 40 | pointer | plain path |
| Autonomy Rules | 230 | bright-line + pointer | plain path |
| Decision-Point Posture | 160 | bright-line | — |
| QC → Triage Auto-Loop | 30 | pointer | plain path |
| Session Guardrails | 180 | bright-line + pointer | plain path |
| Plan Mode Discipline | 70 | bright-line + pointer | plain path |
| CLAUDE.md Scoping | 90 | governance | — |
| Model Tier | 230 | bright-line | — |
| Model Escalation | 160 | bright-line + pointer | plain path |
| Adaptive Thinking Override | 50 | bright-line | — |
| File verification and git commits (+ 5 H3 subsections) | 350 | bright-line + pointer | plain path |
| Delivery | 40 | descriptive | — |
| Agent Harness | 70 | bright-line | `@.claude/references/harness-rules.md` |

Note: the only true `@`-import in either file is workspace `Agent Harness`. Every other reference in both files is a plain-path "Full rule: …" pointer — these do NOT auto-load, which is correct pointer-not-restatement hygiene.

### Project CLAUDE.md (277 lines, ~4,650 tokens)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| Header + scaffolding Note (L1–5) | 273 | descriptive + build-history | plain path |
| Model Selection | 234 | bright-line (prohibition) + recommendation + pointer | plain path |
| Project Boundary | 182 | governance | plain path (internal) |
| Communication Craft Standard | 430 | standard + discretionary | — |
| M&A Register Rule | 195 | bright-line (register) | — |
| Style Consistency Rule | 143 | bright-line | — |
| Working Mode | 78 | bright-line | — |
| Claim Safety Rules | 170 | bright-line (5-status table) | — |
| Handoff Standard | 195 | stage methodology | plain path |
| Copy QC & Review Routing | 143 | governance (override) | — |
| GPT Pass-Prompt Convention | 195 | request-specific methodology | — |
| Operating Standard | 72 | checklist | — |
| Voice Check Checklist | 208 | command output template | — |
| Phrase Bank Discipline | 143 | bright-line | plain path |
| Examples Library | 143 | descriptive + convention | — |
| AI-as-Substrate Rule | 72 | discretionary | — |
| Upstream-Citation Convention | 65 | bright-line | plain path |
| Runtime Context Loading Rule | 234 | command internals | — |
| Source Routing Map | 494 | command data table (brief-time only) | plain paths |
| Page-Level Handling Rule | 300 | stage-by-stage methodology | plain path (internal) |
| Cross-Project Permission Boundary | 143 | governance (permission table) | — |
| Multilingual Deferral Note | 33 | v1 status | plain path |
| Autonomy Posture | 72 | governance (override) | — |
| v1 Deferred Scope | 91 | status ledger | plain path |
| Input File Handling | 13 | pointer (workspace-mirror) | plain path |
| Commit Rules | 143 | bright-line (workspace-mirror) | — |
| Compaction | 156 | bright-line (project + general) | — |
| Session Boundaries | 26 | pointer (workspace-mirror) | plain path |

---

## Tier 1 — Token Cost

**[HIGH] Project file is materially over-length + instruction crowding — file-level.** 277 lines / ~4,650 tokens against the official 200-line target (38% over lines). External guidance rates over-length HIGH "when materially over," and flags instruction-crowding as HIGH for rule-dense files: frontier models reliably follow ~150–200 distinct instructions, with ~50 consumed by the system prompt. In this project's sessions the always-loaded surface is workspace (~29 blocks) + project (~28 blocks) ≈ 57 rule areas before any skill/command loads. Trimming the misplacement and redundancy findings below brings the project file back under target. Source: over-length + instruction-crowding anti-patterns (external guidance).

**[MEDIUM] Header scaffolding Note (L4–5) is always-loaded build-history that informs no runtime behavior.** ~195 tokens describing how the file was scaffolded ("scaffolded at pipeline First Run with the header + Model Selection, then completed in Stage 4 … a deviation from the spec's §5 plan …"). This is maintainer provenance, not a rule. External guidance: "HTML comments are free — stripped before context injection — usable for maintainer notes at zero token cost." Move to a `<!-- -->` block or delete. (Also a Tier 4 change-history finding.) Source: "HTML comments are free" (external guidance).

**[MEDIUM] Communication Craft Standard (~430 tokens, ~9.3% of file) is prose-heavy and overlaps the Voice Check Checklist.** The six craft questions + avoid-patterns + output-quality target are largely explanatory prose that could compress to a bullet list, and the avoid-patterns are restated near-verbatim in the Voice Check Checklist (see Tier 2 within-file). Exceeds the 8% MEDIUM threshold; it does apply to most copy turns, so trim rather than move. Source: "specificity / structure with bullets; dense paragraphs scan worse" (external guidance).

**[MEDIUM] Source Routing Map (~494 tokens, ~10.6% of file) is the single largest block and, by its own statement, applies to <25% of turns.** "Read by `/copy-brief` at brief-generation time. NOT loaded at runtime by `/copy-task`." It exceeds 8% of file tokens and applies to well under 50% of turns. Primary treatment is Tier 5 (move); noted here for its per-turn cost. Source: priors + Tier 5 misplacement.

---

## Tier 2 — Redundancy

**[HIGH] Workspace-mirror sections duplicate always-loaded workspace rules — cross-file.** Four project blocks restate rules that the workspace CLAUDE.md already provides and that IS loaded in these sessions via ancestor-walk:

- **Commit Rules** (project L253–259) restates workspace `Commit behavior` + `Push behavior` in full. The block's own justification — *"It is repeated here because projects are sometimes opened without the parent workspace context loaded"* — does not hold for this project: the workspace file loads via ancestor-walk from the project cwd (confirmed by the launch context). The rationale for duplication is therefore false here, leaving pure double-cost plus divergence risk. External guidance: verbatim duplication across layers risks "Claude may pick one arbitrarily" on divergence.
- **Session Boundaries** (project L274–276) is a near-verbatim copy of workspace `Working Principles → Session boundaries` ("Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`"). Adds nothing project-specific.
- **Input File Handling** (project L249–251) is a bare pointer ("Full rule: `ai-resources/docs/file-write-discipline.md`") duplicating workspace `File Write Discipline`'s pointer to the same doc.
- **Compaction** (project L261–272) mixes genuinely project-specific content (pipeline/stage identifier, page-scope section index — keep) with general restatement ("trust the summary," "prefer writing a short session-state scratchpad and `/clear` + restart") that duplicates workspace compaction guidance.

Token impact is concentrated in Commit Rules (~143) and Compaction's general half (~50); Session Boundaries (~26) and Input File Handling (~13) are cheap but still pure duplication. Recommend reducing all four to short pointers (or deleting the two bare-pointer ones), keeping only Compaction's page-scope specifics. Severity HIGH (spans files). Source: verbatim-duplication-across-files anti-pattern (external guidance).

**[MEDIUM] Model Selection restates the workspace Model Tier prohibition — cross-file, partial.** Project `Model Selection` ¶1 restates "Do not declare a `"model"` field … do not state a default model in this CLAUDE.md" — the canonical workspace rule — while also carrying a pointer ("See workspace `CLAUDE.md` § Model Tier") and genuinely project-specific recommended posture (lean Opus for `/copy-task`, Sonnet for `/copy-brief`). The workspace Model Tier explicitly sanctions the recommended-posture paragraph; the prohibition restatement is the redundant part. Trim ¶1 to the pointer; keep the posture paragraph. Not HIGH because the block is not a pure duplicate and the pointer is already present. Source: CLAUDE.md Scoping ("short pointer acceptable; verbatim duplication is not") + external guidance.

**[MEDIUM] "Feedback-only / operator writes the final copy" is restated four times — within-file.** The same posture appears in Communication Craft Standard (L49), Handoff Standard (L83), Copy QC & Review Routing (L91), and GPT Pass-Prompt Convention (L101). One canonical statement plus cross-references would cut ~40–60 tokens and reduce divergence risk. Severity MEDIUM (within-file).

**[MEDIUM] Avoid-patterns and "Do not use" are each stated twice — within-file.** (a) The five avoid-patterns in Communication Craft Standard (L43–47) are re-listed inside the Voice Check Checklist (L125). (b) The clarification that `Do not use` is the claim-pass terminal and NOT a phrase-bank field appears in both Claim Safety Rules (L77) and Phrase Bank Discipline (L133). (c) The tagline "Strategy lives elsewhere; copy craft happens here; approved copy returns home" appears in the header (L3) and Project Boundary (L15). Consolidate each to one home. Severity MEDIUM (within-file).

---

## Tier 3 — Contradictions

No behavior-corrupting contradictions found. Two apparent workspace-vs-project tensions were examined and judged **reconciled scoped overrides** (different situations, not the same one) — reported as LOW clarity items, not HIGH contradictions:

**[examined — reconciled] Copy QC routing vs. workspace `/qc-pass` mandate.** Workspace `QC Independence Rule` mandates `/qc-pass` "after producing or editing any substantive artifact … Never skip QC as an efficiency call." Project `Copy QC & Review Routing` directs that copy drafts be reviewed by the Copy Director Pass + claim pass "**not** the generic workspace `/qc-pass` or `/refinement-pass`." These do not direct different behavior for the *same* situation: the project substitutes a domain-specific QC for copy artifacts (not skipping QC), and the workspace rule targets analytical artifacts. Reconciled. Recommendation: add an explicit "(project override of workspace QC Independence for copy artifacts)" cross-reference so a reader of either file alone sees the carve-out. (LOW — see L2 below.)

**[examined — reconciled] Autonomy Posture vs. workspace Decision-Point Posture.** Workspace `Decision-Point Posture` says "pick the recommended option and proceed … Do not ask the operator to choose." Project `Autonomy Posture` says "the operator selects, refines, and approves … Operator writes `Chosen direction:` blocks manually." Different situations: the workspace rule governs implementation/approach decisions; the project rule governs final creative *wording*, which the project deliberately makes operator-owned. Reconciled, but the surfaces read as opposed. Recommendation: cross-reference. (LOW — see L1 below.)

---

## Tier 4 — Staleness

**[MEDIUM] Header scaffolding Note is change-history that no longer informs behavior** (also Tier 1). It records the build sequence and a spec-§5 deviation. Per Tier 4, "a block is a change-history … that no longer informs behavior." No runtime turn depends on it. Move to an HTML comment or the `pipeline/implementation-log.md` it already cites. ~195 tokens.

**[LOW] Scaffolding Note's self-description is inaccurate.** It states the four workspace-mirror sections "are present in-file as short pointers." Two of them are not: `Commit Rules` (L253–259) and `Compaction` (L261–272) are full restatements, not short pointers. The note misdescribes the current file — a small accuracy/staleness defect that compounds the Tier 2 redundancy finding.

No stale artifact references were flagged: `pipeline/v2-roadmap.md`, `pipeline/implementation-log.md`, `05-examples/`, `03-phrase-bank/phrase-bank.md`, and the `01-`/`02-`/`04-` directories are referenced consistently, and `Examples Library` / `v1 Deferred Scope` correctly mark the examples library as unpopulated at v1. Per agent rules I did not filesystem-check these paths.

---

## Tier 5 — Misplacement

Per workspace `CLAUDE.md Scoping`: skill methodology → SKILL.md; workflow/command methodology → reference docs; stage-by-stage instructions → `reference/stage-instructions.md`; content applying to <25% of turns should lazy-load. The project uses two commands (`/copy-brief`, `/copy-task`), so "reference docs" here means files those commands load at runtime.

**[HIGH] Source Routing Map → `/copy-brief` reference (e.g., `reference/source-routing-map.md`).** ~494 tokens (>300 → HIGH). The block itself states it is "Read by `/copy-brief` at brief-generation time. NOT loaded at runtime by `/copy-task`" — yet it sits in the always-loaded file and is paid on every turn, including the majority that never touch `/copy-brief`. It is command *data* (task-pattern → source-path table), the canonical case for on-demand loading. Move; leave a one-line pointer. Source: CLAUDE.md Scoping + "path-scoped / on-demand loading" (external guidance).

**[HIGH] Page-Level Handling Rule → `/copy-task` reference (stage-instructions).** ~300 tokens `(boundary — at the >300 HIGH threshold)`. This is stage-by-stage `/copy-task` procedure (numbered: read brief → propose section sequence → wait for operator → write `structure.md` → per-section loop → assemble → review → wrap). Workspace Scoping is explicit: "Stage-by-stage instructions → belongs in `reference/stage-instructions.md`." Move; keep a one-line pointer noting the `--full-page-draft` override. Source: CLAUDE.md Scoping.

**[MEDIUM] Voice Check Checklist → `/copy-task` command file.** ~208 tokens. This is a fixed output template "appended by `/copy-task` to every `options` and `rewrite` output." A command's output template is command-owned; it is paid on every turn but consumed only when `/copy-task` emits a slate. Move to the command. Source: methodology-in-always-loaded-file anti-pattern (external guidance).

**[MEDIUM] Handoff Standard → `/copy-task` wrap-stage reference.** ~195 tokens. The fixed wrap sequence (Copy Director Pass → claim pass → handoff packet shapes) is `/copy-task` methodology, relevant only at wrap. Move; keep a pointer. Source: CLAUDE.md Scoping.

**[MEDIUM] GPT Pass-Prompt Convention → `/copy-task` reference (or a `reference/gpt-pass-prompt.md`).** ~195 tokens. Applies only "when the operator asks for a prompt to run a copy pass in GPT" — a <25%-of-turns request path. Lazy-load. Source: <25%-of-turns → lazy-load (CLAUDE.md Scoping).

**[MEDIUM] Runtime Context Loading Rule → command frontmatter/references.** ~234 tokens describing exactly which files `/copy-brief` and `/copy-task` read at runtime and under which source roles. This is command configuration; it belongs with the commands. Keep only the short claim-safety-relevant role vocabulary (`claim-authority` / `tone-only` / `context-only` / `forbidden`) in CLAUDE.md if it governs claim grounding across turns; move the per-command load lists. Source: methodology-in-always-loaded-file (external guidance).

Blocks explicitly **kept in place** despite touching methodology, because they encode cross-turn governance that applies broadly in this project: `Project Boundary`, `Cross-Project Permission Boundary`, `Claim Safety Rules`, `Communication Craft Standard` (trim only), `Style Consistency Rule`, `M&A Register Rule`, `Upstream-Citation Convention`, `Autonomy Posture`.

---

## Tier 6 — Clarity

**[LOW] Working Mode — "material claim risk" threshold is soft.** "Missing brief fields proceed with marked assumptions unless the gap creates material claim risk — then stop and prompt." "Material claim risk" is partially self-defining (claim-related) but has no bright-line; a reader must infer when a gap crosses from "mark assumption" to "stop." Acceptable for a craft judgment, but a one-clause example would sharpen it.

**[LOW] Autonomy Posture ↔ Decision-Point Posture cross-reference missing** (Tier 3 L1). Add "(project override of workspace Decision-Point Posture for final copy wording)".

**[LOW] Copy QC & Review Routing ↔ workspace QC Independence cross-reference missing** (Tier 3 L2). Add "(project override of workspace `/qc-pass` mandate for copy artifacts)".

**[LOW] Scaffolding-Note "short pointers" claim is inaccurate** (Tier 4). Reword or drop when the Note is moved to a comment.

---

## Per-Block Verdict Table

Every block from both files appears. Workspace blocks are marked "Keep (workspace-audit scope)" except where they are the counterpart of a cross-file finding.

### Project CLAUDE.md

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Header + scaffolding Note | project | 273 | Trim | Keep 1-line description; Note is build-history informing no turn | HTML comment / `pipeline/implementation-log.md` | external: HTML comments free |
| Model Selection | project | 234 | Trim | Drop prohibition restatement (cross-file dup); keep recommended posture + pointer | — | CLAUDE.md Scoping |
| Project Boundary | project | 182 | Keep | Core project-specific governance (may/may-not) | — | priors |
| Communication Craft Standard | project | 430 | Trim | Compress prose; dedup avoid-patterns with Voice Check | — | external: bullets over prose |
| M&A Register Rule | project | 195 | Keep | Project-specific register rule; applies to investor/M&A surfaces | — | priors |
| Style Consistency Rule | project | 143 | Keep | Bright-line "match approved style"; broadly applicable | — | priors |
| Working Mode | project | 78 | Keep | Short, cross-turn drafting posture; soften "material claim risk" | — | priors |
| Claim Safety Rules | project | 170 | Keep | Core 5-status claim table; dedup "Do not use" note vs Phrase Bank | — | priors |
| Handoff Standard | project | 195 | Move | Wrap-stage `/copy-task` methodology | `/copy-task` reference | CLAUDE.md Scoping |
| Copy QC & Review Routing | project | 143 | Keep | Project override of workspace QC; add cross-ref | — | priors |
| GPT Pass-Prompt Convention | project | 195 | Move | Request-specific methodology, <25% of turns | `/copy-task` / `reference/gpt-pass-prompt.md` | CLAUDE.md Scoping |
| Operating Standard | project | 72 | Keep | Short per-task checklist; cross-turn | — | priors |
| Voice Check Checklist | project | 208 | Move | Command output template | `/copy-task` command file | external: methodology on-demand |
| Phrase Bank Discipline | project | 143 | Keep | Core discipline; dedup "Do not use" clause | — | priors |
| Examples Library | project | 143 | Keep | Short project convention; unpopulated-at-v1 marker | — | priors |
| AI-as-Substrate Rule | project | 72 | Keep | Short cross-turn copy posture | — | priors |
| Upstream-Citation Convention | project | 65 | Keep | Bright-line cite-by-reference rule | — | priors |
| Runtime Context Loading Rule | project | 234 | Move | Command load-config; keep only claim-role vocabulary if cross-turn | command frontmatter / references | external: methodology on-demand |
| Source Routing Map | project | 494 | Move | Brief-time-only data table, not runtime-loaded, >300 tok | `reference/source-routing-map.md` (loaded by `/copy-brief`) | CLAUDE.md Scoping |
| Page-Level Handling Rule | project | 300 | Move | Stage-by-stage `/copy-task` procedure (boundary) | `reference/stage-instructions.md` | CLAUDE.md Scoping |
| Cross-Project Permission Boundary | project | 143 | Keep | Structural read/write boundary; project-specific, broadly applies | — | priors |
| Multilingual Deferral Note | project | 33 | Keep | Tiny v1 status marker | — | priors |
| Autonomy Posture | project | 72 | Keep | Project override of workspace autonomy; add cross-ref | — | priors |
| v1 Deferred Scope | project | 91 | Keep | "Not built" guard prevents re-deriving deferred scope | — | priors |
| Input File Handling | project | 13 | Delete | Bare pointer duplicating workspace File Write Discipline | (rely on workspace) | external: cross-file dup |
| Commit Rules | project | 143 | Trim | Cross-file dup; duplication rationale false (workspace loads here) | reduce to pointer | external: cross-file dup |
| Compaction | project | 156 | Trim | Keep page-scope/pipeline specifics; drop general restatement | — | external: cross-file dup |
| Session Boundaries | project | 26 | Delete | Verbatim duplicate of workspace Session boundaries | (rely on workspace) | external: cross-file dup |

### Workspace CLAUDE.md (assessed in separate workspace audit; cross-file counterparts flagged)

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | 30 | Keep (workspace-audit scope) | — | — | — |
| Projects | workspace | 90 | Keep (workspace-audit scope) | — | — | — |
| Axcíon's Tool Ecosystem | workspace | 70 | Keep (workspace-audit scope) | — | — | — |
| Cross-Model Rules | workspace | 50 | Keep (workspace-audit scope) | — | — | — |
| Skill Library | workspace | 75 | Keep (workspace-audit scope) | — | — | — |
| AI Resource Creation | workspace | 70 | Keep (workspace-audit scope) | — | — | — |
| Placement Discipline | workspace | 220 | Keep (workspace-audit scope) | — | — | — |
| Design Judgment Principles | workspace | 70 | Keep (workspace-audit scope) | — | — | — |
| QC Independence Rule | workspace | 180 | Keep — cross-file counterpart | Project Copy QC routing overrides this for copy; add cross-ref | — | priors |
| Contract-Conformance Check | workspace | 200 | Keep (workspace-audit scope) | — | — | — |
| Blind-Spot Scan Gate | workspace | 200 | Keep (workspace-audit scope) | — | — | — |
| Assumptions Gate | workspace | 90 | Keep (workspace-audit scope) | — | — | — |
| Completion Standard | workspace | 90 | Keep (workspace-audit scope) | — | — | — |
| Requirements-Doc Default | workspace | 170 | Keep (workspace-audit scope) | — | — | — |
| Working Principles | workspace | 360 | Keep — cross-file counterpart | Session-boundaries / Compaction bullets duplicated by project | — | priors |
| Chat Communication Style | workspace | 140 | Keep (workspace-audit scope) | — | — | — |
| File Write Discipline | workspace | 40 | Keep — cross-file counterpart | Project Input File Handling duplicates this pointer | — | priors |
| Autonomy Rules | workspace | 230 | Keep — cross-file counterpart | Project Autonomy Posture is a scoped override | — | priors |
| Decision-Point Posture | workspace | 160 | Keep — cross-file counterpart | Project Autonomy Posture overrides for final wording; add cross-ref | — | priors |
| QC → Triage Auto-Loop | workspace | 30 | Keep (workspace-audit scope) | — | — | — |
| Session Guardrails | workspace | 180 | Keep (workspace-audit scope) | — | — | — |
| Plan Mode Discipline | workspace | 70 | Keep (workspace-audit scope) | — | — | — |
| CLAUDE.md Scoping | workspace | 90 | Keep | Governs the project misplacement findings | — | — |
| Model Tier | workspace | 230 | Keep — cross-file counterpart | Project Model Selection restates prohibition | — | priors |
| Model Escalation | workspace | 160 | Keep (workspace-audit scope) | — | — | — |
| Adaptive Thinking Override | workspace | 50 | Keep (workspace-audit scope) | — | — | — |
| File verification and git commits (+subsections) | workspace | 350 | Keep — cross-file counterpart | Project Commit Rules restates Commit/Push behavior | — | priors |
| Delivery | workspace | 40 | Keep (workspace-audit scope) | — | — | — |
| Agent Harness | workspace | 70 | Keep (workspace-audit scope) | — | — | — |

---

## Estimated Savings

Savings accrue to the **project file's per-turn always-loaded budget** (moves relieve every turn; the moved content is paid only when the owning command runs).

- **Per turn: ~1,900 tokens** (HIGH+MEDIUM applied; net of ~40–50-token pointer stubs left behind for moved blocks)
- **Per 30-turn session: ~57,000 tokens**
- **Per 50-turn session: ~95,000 tokens**

Breakdown by tier (approx net savings after stubs):
- **Tier 5 (misplacement):** ~1,150 — Source Routing Map ~450, Page-Level Handling ~260, Voice Check ~200, Handoff Standard ~155 (overlaps Tier-1), GPT Pass-Prompt ~180, Runtime Context Loading ~180. (Some overlap; capped at ~1,150 to avoid double-count.)
- **Tier 2 (redundancy):** ~350 — Commit Rules trim ~110, Compaction general trim ~40, Session Boundaries delete ~26, Input File Handling delete ~13, Model Selection prohibition trim ~40, within-file dedups (feedback-only, avoid-patterns, "Do not use", tagline) ~120.
- **Tier 1/Tier 4 (header Note → HTML comment):** ~195.
- **Tier 1 (Communication Craft Standard compression):** ~100.
- Rounded and de-overlapped to **~1,900 tokens/turn**.

Beyond raw tokens, the moves bring the file under the 200-line official target and cut the combined always-loaded instruction count, which the guidance ties to *adherence*, not just cost.

---

## External Guidance Cited

- **Over-length file (>200 lines) — HIGH when materially over** — official docs synthesis (H1). https://code.claude.com/docs/en/best-practices
- **Instruction crowding (~150–200 instruction budget; ~50 taken by system prompt) — HIGH for rule-dense files** — community synthesis (H1). external-guidance-2026-07-03
- **Verbatim duplication across files/layers — MEDIUM–HIGH; divergence → "Claude may pick one arbitrarily"** — official + synthesis (H4, M6, and project workspace-mirror sections). https://code.claude.com/docs/en/memory
- **Methodology in the always-loaded file belongs in skills/references (load on demand) — MEDIUM** — synthesis (all Tier 5 moves). external-guidance-2026-07-03
- **Content applying to <25% of turns should lazy-load; path-scoped / on-demand loading is the official mechanism** — official (Source Routing Map, GPT Pass-Prompt). https://code.claude.com/docs/en/best-practices
- **HTML comments are free (stripped before context injection) — for maintainer notes at zero token cost** — synthesis (header scaffolding Note). external-guidance-2026-07-03
- **Pointer-not-restatement is the sanctioned way to keep detail out of the always-loaded layer** — synthesis + this workspace's own CLAUDE.md Scoping (Model Selection, Commit Rules trims). external-guidance-2026-07-03
- **Specificity / structure with bullets; dense paragraphs scan worse** — official (Communication Craft Standard compression). https://code.claude.com/docs/en/best-practices
- **The deletion test ("would removing this cause a mistake?")** — official, applied to header Note and workspace-mirror pointers. https://code.claude.com/docs/en/best-practices
