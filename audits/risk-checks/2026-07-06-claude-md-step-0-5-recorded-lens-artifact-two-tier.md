# Risk Check — 2026-07-06

## Change

Proposed ADDITIVE clause appended to the END of `CLAUDE.md § Section Design Sessions` Step 0.5 (project-level, always-loaded, protected-adjacent doctrine) in the axcion-design-studio project. The existing two-line lean inline Lens Check is UNCHANGED; this only appends a two-tier clause. Proposed text to append verbatim:

"**Recorded (fuller) form.** The two lines above are the lean inline check for ordinary section work — keep them concise. For `/explore-section` runs and page-level or high-stakes visual judgment, the recorded lens artifact (`lens-check.md`) additionally states: **(c) Taste** — whether `design-taste-frontend` was triggered (a section reading generic/templated/too-safe/visually-repetitive, or needing controlled creative exploration) and, if so, the one anti-template move it introduced — Taste stays situational, **not** a third mandatory lens; and **(d) doctrine residual** — what stays governed by Axcíon doctrine (brand book → mandate → positioning hazards → page brief/section records → operator/Figma approval), **not** by the skills. The skills run narrow passes and supply constraints; Claude/operator synthesize; Figma/operator approve — the skills never decide identity or approve a final direction. Isolated subagents are for page-level critique, high-stakes judgment, or where independence matters — not every ordinary section."

Context: This is a continuation of last session's third-party design-skill wiring fixes. The operator explicitly chose (Q1) to reflect this in CLAUDE.md doctrine, and (Q2) to keep ordinary inline checks lean (the recorded 4-part artifact is required only for /explore-section runs + high-stakes work). The mandatory lens pair stays UI/UX Pro Max + Impeccable — Taste is NOT promoted to a third mandatory lens. Consumers were already updated in the SAME change set (not yet committed): `.claude/skills/README.md` (operational-roles table + § Lens Check inline-vs-recorded), `.claude/commands/explore-section.md` Step 3.5 (records the 4 elements — this command is symlinked to the ai-resources repo), and `web-refinement-playbook.md` header note #6. An agent-memory `section-lens-sequence` sync is queued (outside the repo). No new agents, no new files, no permission changes, no hook changes. The `20_criteria/section-design-principles.md` DRAFT is unaffected.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/skills/README.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/commands/explore-section.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/web-refinement-playbook.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The clause is small, purely additive, and backward-compatible with every consumer found, but it repeats — in a third file — mechanics that already live in full in `.claude/skills/README.md` and `.claude/commands/explore-section.md`, pushing an already-large always-loaded CLAUDE.md paragraph further past the token-cost line the *previous day's* risk-check on this exact doctrine block explicitly warned against.

## Consumer Inventory

Search terms derived from the change: `Step 0.5`, `Lens Check`, `lens-check.md`, `doctrine residual`, `Section Design Sessions`, `design-taste-frontend`, `mandatory... lens`. Grepped across `ai-resources/` and the workspace root (`projects/axcion-design-studio/` and sibling dirs), per Step 1.5.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-design-studio/.claude/skills/README.md` | documents + co-edits (already restates the same 2-tier / 4-element structure in § "Lens Check: inline vs recorded", lines 63/72–74; already updated in this same change set per CHANGE_DESCRIPTION) | no |
| `projects/axcion-design-studio/.claude/commands/explore-section.md` | invokes/parses + co-edits (Step 3.5 is the mechanism that produces `lens-check.md`; already restates the 4-element contract in more operational detail; already updated in this same change set; this file is symlinked into `ai-resources/`) | no |
| `projects/axcion-design-studio/web-refinement-playbook.md` | documents (governance header note #6, already added in this same change set) | no |
| `projects/axcion-design-studio/logs/session-notes.md` | documents (historical — records the original Step 0.5 wiring decision, lines 536/542/545) | no |
| `projects/axcion-design-studio/logs/decisions.md` | documents (historical — 2026-07-05/07-06 entries on the Lens Check and Apple×Blackstone doctrine additions; no entry yet for *this* specific two-tier clause — see Dimension 6) | no (but recommended — see Mitigations) |
| `projects/axcion-design-studio/pipeline/visual-system-integration-plan.md` | documents (references `design-taste-frontend`'s role generally, not the specific 4-element contract) | no |
| `projects/axcion-design-studio/audits/lean-repo-2026-07-05-playbook-fit.md` | documents (historical audit) | no |
| `projects/axcion-design-studio/work/homepage/audit-notes.md`, `work/for-investors/audit-notes.md` | documents (historical, references Taste in specific section audits) | no |
| `projects/axcion-design-studio/logs/scratchpads/2026-07-04-22-30-scratchpad.md` | documents (historical scratchpad) | no |
| `ai-resources/audits/risk-checks/2026-07-04-change-set-this-session-installed-three-third-party.md`, `2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md` | documents (historical risk-check precedent — the second of these directly recommended keeping this exact CLAUDE.md block lean; see Dimension 1/6) | no |

**Total: 10 distinct consumer references found, 0 must-change.** No `not yet present` targets — the clause's contract (`lens-check.md`'s 4-element structure, the inline-vs-recorded 2-tier split) already exists and already has a real, current consumer (`/explore-section` Step 3.5, edited in the same batch), so this is not a speculative new contract — see Dimension 6.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- The target is `projects/axcion-design-studio/CLAUDE.md`, an **always-loaded project file** — every line here loads on every turn of every session in this project.
- Measured: the existing Step 0.5 paragraph (`CLAUDE.md:37`) is already ~203 words / ~1,425 characters (~356-token estimate at chars/4) — itself flagged **Medium** for usage cost by the prior risk-check on this same block (`ai-resources/audits/risk-checks/2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md` Dimension 1).
- The proposed addition measures **~139 words / ~1,041 characters (~260-token estimate)** — verified by direct word/char count of the verbatim text in CHANGE_DESCRIPTION. This alone clears the rubric's High line (">150 tokens added to always-loaded files") by a wide margin, and compounds onto an already-large block, taking the total Step 0.5 content to roughly 600 tokens in a single always-loaded paragraph.
- **This repeats a pattern the immediately-prior risk-check on the same block explicitly flagged and mitigated against.** That report's Dimension 1/6 mitigation reads: *"Land the gate + a one-line pointer in CLAUDE.md and move the six-part Step-0 mechanics into a section-session reference the protocol points to (or tighten Step 0 to ≤4 lines). Preserves the doctrine while respecting 'every line loads every turn.'"* The current change does the opposite — it inlines full mechanics a second time rather than pointing to `.claude/skills/README.md § Lens Check: inline vs recorded`, which already states this exact two-tier / four-element structure in comparable detail.

### Dimension 2: Permissions Surface
**Risk:** Low

- CHANGE_DESCRIPTION states explicitly: "No new agents, no new files, no permission changes, no hook changes." Confirmed by reading all four referenced files — none contains a settings.json edit, a new tool-invocation pattern, or a capability grant.
- The change is a pure text append to a markdown doctrine file.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer Inventory (Step 1.5): **10 distinct references found, 0 must-change.** The raw count (>5) nominally crosses the rubric's High line, but — mirroring the qualitative call the 2026-07-05 risk-check made on this identical block under the same circumstance (">12 references found, 0 hard must-change... the raw count exceeds the rubric's >5=High line, but the qualitative reality is Medium: all >5 are documentation/compatible references, none hard-break") — every reference here is either (a) a consumer already edited in this same, not-yet-committed change set to match (`.claude/skills/README.md`, `.claude/commands/explore-section.md`, `web-refinement-playbook.md`), or (b) a historical log/audit record with no live dependency on the exact wording.
- No contract change: the existing two-line lean inline check is untouched verbatim (CHANGE_DESCRIPTION: "The existing two-line lean inline Lens Check is UNCHANGED"). The addition is purely additive and backward-compatible.
- No shared infra outside the design-studio project's own doctrine chain is touched.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file text append to `CLAUDE.md`. `git revert` on the introducing commit fully restores the prior state within the same working tree — no sibling files, no directories, no data/log mutation, no automation added that could fire between landing and a potential revert.
- The sibling consumer edits (`skills/README.md`, `explore-section.md`, `web-refinement-playbook.md`) are separate files each independently revertible; none of them depend on this specific CLAUDE.md text existing to remain internally valid (they already state the four-element structure in their own words).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Genuine three-way content duplication, no explicit tie-breaker.** After this change, the same "two-tier inline-vs-recorded, four-element `lens-check.md`" concept is stated in detail in three separate files: `CLAUDE.md` (new), `.claude/skills/README.md` (§ "Lens Check: inline vs recorded", lines 72–74 — near-identical substance, different wording), and `.claude/commands/explore-section.md` (Step 3.5 — most operationally detailed version). None of the three states "if these diverge, X governs."
- **`00_mandate/source-of-truth-hierarchy.md`** — read directly for this check — defines a 5-layer authority order for *design content* (brand book → Studio doctrine → positioning criteria → reference lenses → per-surface work) but does **not** rank `CLAUDE.md` against `.claude/skills/README.md` or `.claude/commands/*.md` for *procedural/doctrine-text* authority; both are listed only as "protected" (§2, CP-1 gate) with no relative order stated. So the informal convention — CLAUDE.md is doctrine, the other two are elaboration that already cite CLAUDE.md as their reference point — is real but unwritten.
- **Mitigating factor (keeps this Medium, not High):** all three files are being edited in the same, not-yet-committed change set, so they are consistent at landing time, and this change arguably *improves* prior coherence — before it, `.claude/skills/README.md` stated the four-element fuller-tier concept in more detail than `CLAUDE.md` itself, an inversion (elaboration more authoritative-sounding than the doctrine it elaborates). This change corrects that inversion rather than worsening it.
- No consumer requires modification to stay compatible (0 must-change per the inventory), so this does not reach the rubric's "functional overlap... [callers] must honor" High trigger in the operational sense — but it is a real future-drift risk if any one of the three is edited later without the other two.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly) and the workspace `CLAUDE.md § CLAUDE.md Scoping` (already loaded).

- **DR-5 tension — "CLAUDE.md holds cross-session rules only, not methodology. Every line loads every turn; only every-turn content earns its place."** The proposed clause is workflow/skill methodology — the specific mechanics of what `lens-check.md`'s fuller tier records (four named elements, their trigger conditions, the authority chain) — which workspace `CLAUDE.md § CLAUDE.md Scoping` independently states does *not* belong in project CLAUDE.md ("Skill methodology. Belongs in SKILL.md." / "Workflow methodology. Belongs in the workflow's reference docs."). That reference doc already exists and already carries this content: `.claude/skills/README.md § Lens Check: inline vs recorded`.
  - DR-5 does carry a **built-in escape valve**: "(Deliberate cross-level duplication is a recognized, self-identified exception.)" — and `principles-base.md`'s GAP-3 confirms this pattern ("CLAUDE.md intentional duplication — RESOLVED (recognized DR-5 exception)"). CHANGE_DESCRIPTION states the operator explicitly chose (Q1) this placement — a real, deliberate decision, not silent drift at the point of the conversation.
  - **But the decision is not yet "loudly recorded" per OP-11** ("Surfacing tacit principles is a recurring obligation... practice-vs-principle divergence must be surfaced and resolved loudly... never silent drift"). Grep of `projects/axcion-design-studio/logs/decisions.md` and `logs/session-notes.md` for this specific decision (search terms: "Recorded (fuller)", "Q1", "Q2") returned **zero hits** — the operator's Q1/Q2 choices exist only in the live conversation, not on disk, even though this exact doctrine thread already used `logs/decisions.md` twice in the prior two days (2026-07-05, 2026-07-06) to record comparable Lens Check/doctrine decisions. Per the risk-check rubric's Dimension 6 special handling: an acknowledged, recorded exception scores Medium/Low; an unacknowledged one scores High. This one is *decided* but not yet *recorded* — a fixable gap, not a violation, hence Medium rather than High.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — clears.** The `lens-check.md` four-element contract is not speculative: `/explore-section.md` Step 3.5 already implements it in full (in this same, already-edited batch), i.e., a real, current, named consumer exists. This is backfilling doctrine to match already-shipped consumer behavior, not building ahead of a consumer.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7) — does not apply.** This test targets "a new command, agent, mandatory stage/gate, or permanent always-loaded doc." Nothing new is created here — Step 0.5 and the fuller-tier requirement both already exist (in the consumer files); this is a consistency/backfill edit to the doctrine layer, not the introduction of a new mandatory gate.
- **OP-5 (advisory vs enforcement) — clears.** The clause stays descriptive/advisory; no hook or auto-enforcement is added.
- **DR-1/DR-3 (placement) — clears.** `CLAUDE.md` is the correct canonical home for project doctrine; the question is altitude/duplication (DR-5), not wrong home.

## Mitigations

- **[Dimension 1 — High]** Compress the addition to a short pointer + gate statement rather than restating the full mechanics, e.g.: *"Recorded (fuller) form. For `/explore-section` runs and page-level or high-stakes judgment, the recorded lens artifact (`lens-check.md`) additionally records Taste-triggered status and the doctrine residual — see `.claude/skills/README.md § Lens Check: inline vs recorded` for the full structure."* This preserves the doctrine gate (so a CLAUDE.md-only reader still learns the fuller tier exists and when it fires) while cutting the token add from ~260 to roughly 40–60 — resolving Dimension 1 to Low/Medium. If the operator has weighed this and prefers the fuller inline text anyway (the CHANGE_DESCRIPTION suggests a considered choice), that is a legitimate override — but it should be a *conscious* choice against this cheaper alternative, not an unconsidered default.
- **[Dimension 5 — Medium]** Add one explicit tie-breaker sentence (in either the new CLAUDE.md clause or `.claude/skills/README.md`): "If this description and `.claude/skills/README.md` / `.claude/commands/explore-section.md`'s fuller descriptions of the recorded artifact ever diverge, CLAUDE.md governs." Closes the unwritten-convention gap identified in Dimension 5 at near-zero cost.
- **[Dimension 6 — Medium]** Log this decision explicitly in `projects/axcion-design-studio/logs/decisions.md`, following the same convention this doctrine thread already used on 2026-07-05 and 2026-07-06 — one short entry naming the Q1 (doctrine placement) and Q2 (keep inline lean) choices and the DR-5 duplication trade-off accepted. This converts the DR-5 exception from "decided in chat" to "loudly recorded," satisfying OP-11 and fully clearing Dimension 6 to Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: verbatim word/char counts of the current and proposed CLAUDE.md text, direct reads of all four referenced files plus `00_mandate/source-of-truth-hierarchy.md` and `projects/strategic-os/ai-strategy/principles-base.md`, grep counts across `ai-resources/` and the project tree (10 consumer references, 0 must-change), and citation of the directly-prior risk-check on this same doctrine block (`ai-resources/audits/risk-checks/2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md`) for precedent on both the Dimension 1 token-cost pattern and the Dimension 3 "raw count vs. qualitative Medium" call. No training-data fallback was used on fetch/read failures.
