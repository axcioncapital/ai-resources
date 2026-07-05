# Risk Check — 2026-07-05

## Change
Structural change to the Axcíon Design Studio doctrine layer: add a "Step 0 — page-context scan" to the Section Design Sessions protocol so section design is never evaluated as an isolated rectangle. Change set (4 files): (1) EDIT protected projects/axcion-design-studio/CLAUDE.md — Section Design Sessions section: insert Step 0 (build/refresh a per-page pattern inventory; name design-system elements that must repeat for coherence; name section compositions/devices that must NOT repeat here; state the section's narrative role + intended visual energy; check duplication against this page and other approved Axcíon pages; reject options strong in isolation but weak for page rhythm / cross-page consistency), change the header order to scan→propose→approve→prompt, and have Step 3 refresh the inventory with the newly approved section. (2) EDIT protected .claude/agents/layout-architect.md — add the same page-level rhythm/repetition/cross-page reasoning: read the pattern inventory + cross-page constants in Step 1, reason about it in VDS §2, add a Constraint to reject locally-strong-but-globally-repetitive directions. (3) NEW work/homepage/pattern-inventory.md — derived composition + rhythm/energy table seeded from the approved VDS + figma-build-brief (NOT the old Claude Design PDF). (4) NEW work/_shared/cross-page-constants.md — provisional shared CTA-family constants + per-page variation. Rationale: today the page-level reasoning exists only as implicit prose in the full-page VDS, is not written into the creator agent's instructions (grep of layout-architect.md returns zero hits for inventory/rhythm/repetition/cross-section), is entirely absent from the section-by-section mode the operator is about to adopt, and is structurally impossible cross-page. Operator approved "fix-first" (option A). This is advisory doctrine, not code; no hooks, no permissions, no settings changes.

## Referenced files
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/layout-architect.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/homepage/pattern-inventory.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/_shared/cross-page-constants.md — not yet present

## Verdict
PROCEED-WITH-CAUTION

**Summary:** The doctrine gap is real and backed by cited written evidence, so the change earns its keep; proceed, but resolve the three-way overlap of page-rhythm content, the derived-artifact staleness contract, and the Claude↔Codex mirror drift before landing.

## Consumer Inventory
Search terms: `layout-architect`, `Section Design Session`, `pattern-inventory` / `pattern inventory`, `cross-page-constants` / `cross-page constant`, `page-context scan`, `propose → approve → prompt`. Grepped across the project, `ai-resources/`, and the workspace root. `cross-page-constants` and `page-context scan` returned **zero** existing hits (the two new files' contracts have no current consumers — the contract is net-new). `pattern-inventory` hits were all in an unrelated research archive (`archive/nordic-pe-macro-landscape-*`) using the phrase in a different sense — **not** consumers.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-design-studio/.codex/agents/layout-architect.toml | Codex mirror of the edited agent (co-edit for parity) | Conditional — yes if Codex parity is maintained |
| projects/axcion-design-studio/.agents/skills/visual-design-spec/SKILL.md | dispatches layout-architect (invokes, mirror) | No |
| projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md | dispatches layout-architect (invokes) | No |
| projects/axcion-design-studio/.claude/skills/visual-design-spec/references/vds-template.md | VDS §2 structure = source of truth (agent body: "if the two diverge, the skill wins and this inline copy must be resynced") | Conditional — divergence risk if §2 rhythm reasoning / new Constraint land only in the agent |
| projects/axcion-design-studio/.agents/skills/visual-design-spec/references/vds-template.md | VDS template (mirror) | Conditional — same divergence risk |
| projects/axcion-design-studio/00_mandate/design-studio-mandate.md | documents creator role + authority split | No |
| projects/axcion-design-studio/.claude/agents/{brand-guardian,visual-red-team,implementation-bridge}.md (+ .codex/.toml mirrors) | reference creator; critics review the VDS the agent writes | No (but no critic checks the new §2 rhythm reasoning — see Dim 5/6) |
| projects/axcion-design-studio/work/homepage/figma-build-brief.md + visual-design-spec.md | SEED SOURCES the new pattern-inventory.md derives from | No (but staleness coupling — see Dim 5) |
| projects/axcion-design-studio/work/homepage/sections/{hero,how-we-help,why-it-works,who-we-serve}.md | reference the Section Design Sessions protocol / its gate | No (header reorder is additive; approval-gates-prompt semantics preserved) |
| projects/axcion-design-studio/.claude/skills/README.md | documents the protocol | No |
| projects/axcion-design-studio/pipeline/*.md (project-plan, architecture, technical-spec, implementation-*, test-results, …) | document the agent + chain | No |
| logs/ (session-notes, session-plans, scratchpads, decisions, qc/*) across the project | historical records mentioning the agent/protocol | No |

**Total: >12 distinct consumer references found; 0 hard must-change; ~2–5 conditional should-change** (Codex `.toml` mirror + `.agents` skill/template mirrors for parity, and the two `vds-template.md` copies for §2/Constraint divergence). The new files' own contracts (`pattern-inventory`, `cross-page-constants`, `work/_shared/`) are net-new — no existing consumer.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium
- The Step 0 insert lands in an **always-loaded project CLAUDE.md**. The current Section Design Sessions block is ~7 lines (`projects/axcion-design-studio/CLAUDE.md:32–40`); Step 0 as described carries six distinct sub-directives (build/refresh inventory; name must-repeat elements; name must-NOT-repeat compositions; state narrative role + visual energy; cross-page duplication check; reject-locally-strong rule) plus the Step 3 refresh clause. Realistic add ≈ 100–180 tokens paid on **every turn of every design-studio session** — squarely the rubric's Medium band (~50–150) and touching High (>150) if the prose is verbose.
- Tension with `principles-base.md DR-5` ("CLAUDE.md holds cross-session rules only, not methodology; every line loads every turn") and workspace `CLAUDE.md § CLAUDE.md Scoping` ("Do not put in project CLAUDE.md: Skill/Workflow methodology"). Step 0 is *protocol methodology* that fires only during a Section Design Session, not every turn — a candidate to live in a section-session reference the protocol points to, with only the gate + a one-line pointer in always-loaded CLAUDE.md. Mitigable (see Mitigations).
- `layout-architect` is a **frequently-spawned** subagent (spawned on every full-page design run). Adding a Step-1 read line + a §2 reasoning paragraph + one Constraint is a modest, not oversized, brief expansion — Low on its own; it nudges the composite to Medium.

### Dimension 2: Permissions Surface
**Risk:** Low
- CHANGE_DESCRIPTION is explicit: "no hooks, no permissions, no settings changes." Confirmed — grep of the project `.claude/settings.json` shows no deny/allow rule touching `layout-architect`, `Section Design`, `work/homepage`, or `work/_shared`.
- Creating `work/_shared/` is a new subdirectory under the Studio's own authored `work/` layer, within the established Write pattern (`work/homepage/sections/` already exists). No new tool pattern, no glob widening, no capability escalation.
- Editing the two "protected" files (project CLAUDE.md, `layout-architect.md`) is normal operator-flow editing (git shows CLAUDE.md already modified this session); "protected" here means load-bearing / risk-check-gated, not settings-denied.

### Dimension 3: Blast Radius
**Risk:** Medium
- Files directly touched: 2 edits + 2 new files + 1 new dir.
- Consumer count (from inventory): **>12 references found, 0 hard must-change.** No consumer breaks: the header reorder `propose→approve→prompt` → `scan→propose→approve→prompt` is **additive and backwards-compatible** (Step 0 prepended; the approval-gates-prompt semantics that `work/homepage/sections/hero.md:4` quotes — "Section Design Sessions gates prompt-crafting on approval" — still hold).
- The raw count exceeds the rubric's ">5 = High" line, but the qualitative reality is Medium: all >5 are documentation/compatible references, none hard-break, and the contract change is backwards-compatible (rubric's explicit Medium trigger). The genuine caller-side work is the **conditional should-change set**: `.codex/agents/layout-architect.toml` (Claude↔Codex parity), the `.agents` skill/template mirrors, and the two `vds-template.md` copies (§2/Constraint divergence). If the operator treats those mirrors as load-bearing parity copies, effective must-change rises to ~3 and this edges toward High — hence the mitigation to update-or-explicitly-defer them.
- No shared infra affecting *multiple* workflows: the blast is contained to the Design Studio's own creator+section chain.

### Dimension 4: Reversibility
**Risk:** Medium
- The two file **edits** (CLAUDE.md, `layout-architect.md`) revert cleanly via `git revert`.
- The two **new files** + the new `work/_shared/` directory are removed by reverting the introducing commit **only while they stay pristine**. But the design intends them to accumulate: Step 3 "refresh the inventory with the newly approved section" makes `pattern-inventory.md` a **mutable, accumulating** artifact, and section runs under the new protocol will author `work/homepage/sections/*.md` and populate `cross-page-constants.md`. Reverting the *doctrine* after sessions have run leaves an orphaned, half-populated `pattern-inventory.md` / `cross-page-constants.md` / `work/_shared/` — a **revert + one manual cleanup step**.
- No state beyond git, no append-only shared-log mutation, no automation that could fire before revert (advisory doctrine, no hooks). That keeps it Medium, not High.

### Dimension 5: Hidden Coupling
**Risk:** High
- **Three-way overlap / no stated authority of record.** The change's own rationale says page-rhythm reasoning "exists only as implicit prose in the full-page VDS." After the change, overlapping page-rhythm content lives in **three** places: (a) the VDS §2 "Section-by-section layout intent" (`layout-architect.md:56–64`), (b) the new `pattern-inventory.md`, and (c) the agent's new §2 reasoning + Constraint. Nothing states which is authoritative when they disagree — a classic multiple-source-of-truth hazard and functional overlap with an existing mechanism.
- **Derived-artifact staleness contract (silent).** `pattern-inventory.md` is "seeded from the approved VDS + figma-build-brief." It therefore silently depends on `work/homepage/figma-build-brief.md` staying current; if the brief is re-QC'd, the inventory goes stale with no detection channel and no stated refresh trigger. Undocumented new contract callers rely on.
- **New location convention.** `work/_shared/cross-page-constants.md` introduces a project-new `_shared/` directory convention and a shared cross-page-constants contract that the agent's Step 1 will read by path. Provisional constants with **no named owner or update protocol** is silent-convention reliance — when the constants change, nothing tells the pages/agent.
- **Claude↔Codex mirror drift.** Editing `.claude/agents/layout-architect.md` without the `.codex/agents/layout-architect.toml` mirror (12 KB, dated Jul 2) and the `.agents/skills/visual-design-spec/` mirror creates silent Claude-vs-Codex divergence — an implicit dependency invisible from the `.md` change site.
- Multiple implicit dependencies + functional overlap ⇒ High per rubric. All are mitigable (see Mitigations).

### Dimension 6: Principle Alignment
**Risk:** Low
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7) — CLEARS via prong (b).** The change adds a mandatory Step 0 + two doc artifacts + always-loaded content, so it fails prong (a) net-simplification. Prong (b) requires **cited written evidence** of the failure mode (a log entry or a pattern seen ≥2×). The CHANGE_DESCRIPTION's grep-of-absence proves the *instruction* is missing, not that outputs *failed* — on its own that is a gap, not evidence. **However, the on-disk audit records supply the ≥2× written pattern the gate wants:**
  - `work/homepage/audit-notes.md:37` — page-rhythm/repetition is an actual evaluated dimension ("Layout family variety… No 3-in-a-row zigzag repetition — passes design-taste-frontend's Zigzag Alternation Cap"), and it is checked **post-hoc at full-page audit time**, exactly the gap Step 0 moves upstream.
  - `work/for-investors/audit-notes.md:51` — a live written cross-page-consistency question ("check with the operator whether this section should extend/echo [the homepage's] visual language for cross-page consistency").
  - `work/for-investors/audit-notes.md:68` — "[P3] Eyebrow density — same cross-page brand-doctrine check as Home Page; **resolve once for both pages together**."
  - `work/for-investors/audit-notes.md:31,60` — duplicate CTA-intent flagged across mid-page vs closing (the CTA-family concern `cross-page-constants.md` targets).
  - `work/homepage/sections/why-it-works.md:5` — an approved section's red verdict node "adds a third red moment to a page brief that locked 'red twice'" — a section decision breaching a **page-level budget**, precisely the "strong in isolation, weak for page rhythm" failure Step 0 catches.
  These are a ≥2× pattern with cited locations ⇒ **prong (b) satisfied.** (The OP-11 logged-exception escape hatch in `logs/decisions.md` remains available regardless.)
- **Speculative abstraction (OP-9 / AP-7 / DR-7) — CLEARS.** DR-7 forbids generalizing before a **second confirmed consumer**. `work/for-investors/` is a second page in active design with its own audit-notes and a planned first Section Design Session (`work/for-investors/audit-notes.md:51`), and the cross-page consistency need is already documented between the two pages (`:68` "resolve once for both pages together"). So `work/_shared/cross-page-constants.md` responds to a real, documented second consumer — it is **not** "hooks for a future phase." Keep it explicitly *provisional / seeded-minimal* (the change already labels it so) to avoid over-building past the two current pages.
- **OP-12 (closure before detection) — SATISFIED.** Step 0's duplication check is detection, but its closure ships in the same change: the propose→approve loop rejects the repetitive option, and Step 3 refreshes the inventory. The detector is not shipped ahead of its closer.
- **OP-5 (advisory vs enforcement) / OP-2 (gate judgment) — SATISFIED.** Step 0 is advisory doctrine applied by the creator/operator's judgment; no enforcement automation is added.
- **OP-11 / OP-3 (loud revision, never silent drift) — SATISFIED.** The protocol reorder is an explicit, recorded CLAUDE.md edit — a loud doctrine revision.
- **Placement (DR-1 / DR-3) — CORRECT.** Both new artifacts sit in the project's Studio-authored `work/` layer (project-local, not canonical) — the right tier.
- **Residual tension (not a violation):** DR-5 / CLAUDE.md-scoping — Step 0 mechanics in always-loaded CLAUDE.md (carried in Dimension 1). Acknowledged and mitigable, so the dimension stays Low.

## Mitigations
Required because the verdict is PROCEED-WITH-CAUTION (≥1 paired mitigation for the single High dimension, plus the Mediums):

- **[Dim 5 — High, primary] Name the authority of record.** In `pattern-inventory.md`'s header, state its relationship to VDS §2 explicitly — one is derived-from / subordinate-to the other. Recommended: the VDS/figma-build-brief remain the source of truth; `pattern-inventory.md` is a *derived index* that never overrides them. This dissolves the three-way overlap.
- **[Dim 5 — High] Make the staleness contract loud.** Put a one-line provenance + refresh-trigger banner at the top of `pattern-inventory.md` ("Derived from work/homepage/{visual-design-spec, figma-build-brief}.md as of <date>; re-derive if either changes") and give `cross-page-constants.md` a named update owner + "provisional" banner. Turns a silent dependency into a visible one.
- **[Dim 5 — High] Resolve mirror drift in the same change or defer it loudly.** Either update `.codex/agents/layout-architect.toml` and the `.agents/` skill/template mirrors alongside the `.claude` edits, **or** add a one-line note (in `logs/decisions.md` or the commit message) that the Codex/.agents mirrors are intentionally deferred and out of parity as of this commit.
- **[Dim 1 / Dim 6 residual — DR-5] Keep always-loaded weight down.** Land the gate + a one-line pointer in CLAUDE.md and move the six-part Step-0 mechanics into a section-session reference the protocol points to (or tighten Step 0 to ≤4 lines). Preserves the doctrine while respecting "every line loads every turn."
- **[Dim 3] Sync the VDS template.** If the §2 rhythm reasoning and the new Constraint are load-bearing, mirror them into `references/vds-template.md` (both copies) — the agent body already declares the template the source of truth on divergence.
- **[Dim 4] Pre-log the rollback step.** Note in the commit/decisions entry that reverting the doctrine also requires removing `work/_shared/` + `pattern-inventory.md` if they have been populated — so a future revert isn't left with orphaned derived artifacts.

## Evidence-Grounding Note
All risk levels grounded in direct evidence (file paths + line numbers, grep counts, and the cited principle IDs). No training-data fallback used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-05-risk-check-second-opinion-pattern-inventory-page-rhythm.md`._

**Routing position.** The baseline is correct — both new files are project-scoped `work/` artifacts (not ai-resources candidates, Q1); the CLAUDE.md + `layout-architect` edits are project-local doctrine in a DR-8 structural class. The disagreement is not *where within the project* — it is *whether the two new files should exist at all*.

**(a) Concur with PROCEED-WITH-CAUTION — but discharge the caution by shrinking the change, not by adding provenance banners.** The doctrine gap is real and DR-8 makes the gate non-optional, so the tier is right. Two rating corrections: Principle-alignment Low understates a DR-7 violation (`cross-page-constants.md` = one consumer today); the Hidden-Coupling HIGH is correctly rated but under-diagnosed (see missed risk 1).

**(b) A separate derived `pattern-inventory.md` is the wrong structure.** The right answer is **one authored, QC'd home** — fold page rhythm/repetition into the existing `figma-build-brief.md`, which the project's own "Chain fit" clause *already* designates as the page-level authority a section must respect. Step 0 then becomes a read instruction, not a file. A derived, hand-refreshed cache of authoritative data is a vault-documented failure mode (registry drift). Defer `cross-page-constants.md` + `work/_shared/` entirely (DR-7/AP-7/OP-9 — one consumer).

**Downstream impact / missed risks.** (1) Biggest miss: a derived inventory injects an **un-QC'd authority into the design path** — it never passes the critic chain (QS-1/QS-9; non-negotiable sequence). Folding into the QC'd build brief fixes coupling *and* legitimacy in one move. (2) The Codex mirror is an **OP-10 boundary decision** (cross-tool governance = explicit scope call), not a sync chore — defer it. (3) Build-ahead-of-first-use (OP-9/OP-12 — run section-mode once, then let observed failure justify any artifact). Keep only mitigations 3 (lean CLAUDE.md pointer, DR-5) and 4 (VDS-template sync); supersede 1/2/5.

**Clear position — the right answer is:** one authored, QC'd home for page rhythm inside `figma-build-brief.md` + a lean Step 0 read instruction, and nothing else built yet. This strengthens the change's original goal while removing the entire HIGH coupling surface.
