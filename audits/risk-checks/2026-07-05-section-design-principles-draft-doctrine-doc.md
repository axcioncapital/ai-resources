# Risk Check — 2026-07-05

## Change

Change set (DR-8 doctrine-layer structural change to the Axcíon Design Studio): (1) NEW file projects/axcion-design-studio/20_criteria/section-design-principles.md — a DRAFT, NOT-wired-into-the-chain doctrine reference modelled on the existing conversion-clarity-review.md precedent. It imports ONLY two operator-emphasized principles: "Preservation pass" (before revising an approved section, name what must NOT change) and "Stop conditions" (v1 good-enough criteria to end iteration). It cites (does not restate) positioning-hazards.md, defers to the just-landed 2026-07-05 page-rhythm doctrine rather than re-encoding it, keeps positioning hazards as a hard ceiling and the governing principle as top filter, and stays in-lane (routes copy/strategy [ROUTE-UPSTREAM]). It has a DRAFT/not-wired status banner and an explicit Deferred section. No agent reads it (no visual-design-spec/layout-architect edit), so no .codex/.agents mirror change. (2) EDIT projects/axcion-design-studio/CLAUDE.md — add ONE pointer line to the "Section Design Sessions" section pointing at the new doc (pointer, not methodology — respecting DR-5/CLAUDE.md-scoping). Context: this is an operator-elected build over a QC MARGINAL→PARK verdict (evidence is a single why-it-works R→R′ churn episode, below the complexity-budget prong-(b) ≥2× bar; ~4 days / 1 page / 4 sections of usage). An OP-11 waiver is being logged in the project's logs/decisions.md. This is deliberately the same DR-8 class as the 2026-07-05 doctrine-layer change (ai-resources/audits/risk-checks/2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md) but a distinct, own pass — not a light extension of it.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/20_criteria/section-design-principles.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/20_criteria/conversion-clarity-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/20_criteria/positioning-hazards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A deliberately minimal, well-isolated change (one DRAFT-not-wired doctrine doc that nothing reads + one CLAUDE.md pointer line) whose only real risk is principle-level — it fails the complexity budget on single-episode evidence and rests on an OP-11 waiver that is documented in the plan but not yet on disk in decisions.md; land that waiver and note the overlap with the already-encoded protect-approved-decisions doctrine, then proceed.

## Consumer Inventory

Search terms (derived from the new file basename + named markers): `section-design-principles`, `conversion-clarity-review`, `Section Design Sessions`, `Preservation pass`, `Stop conditions`, `20_criteria`, `positioning-hazards`, `page-rhythm`. Grepped across the project, `ai-resources/`, and the workspace root.

**Key finding — the new file has ZERO runtime consumers.** `section-design-principles` returns exactly one hit: the plan doc that specifies its creation (`ai-resources/audits/working/2026-07-05-idea-ai-web-design-operating-principles.md:70`), not a runtime reader. This is the design intent (DRAFT-not-wired): no skill/agent reads it, exactly as `conversion-clarity-review.md` is not wired into the `visual-design-spec` chain (`conversion-clarity-review.md:9`). The CLAUDE.md pointer edit lands in the "Section Design Sessions" section, whose consumers are documentation-only and additive-safe.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/audits/working/2026-07-05-idea-ai-web-design-operating-principles.md | documents (the plan that authored the file) | no |
| projects/axcion-design-studio/work/homepage/sections/{hero,how-we-help,why-it-works,who-we-serve}.md | quote/parse the "Section Design Sessions" protocol + its approval gate (the pointer-edit target section) | no — the pointer line is additive; propose→approve→prompt semantics unchanged |
| projects/axcion-design-studio/20_criteria/conversion-clarity-review.md | sibling precedent the new doc is modelled on (not a consumer) | no |
| projects/axcion-design-studio/20_criteria/positioning-hazards.md | citation target of the new doc (hard ceiling); dependency runs new-doc → hazards, one-directional | no |
| projects/axcion-design-studio/CLAUDE.md:36 (2026-07-05 page-rhythm Step 0) | new doc defers to it (citation, not re-encode) | no |
| projects/axcion-design-studio/.claude/agents/visual-red-team.md (+ .codex/.agents mirrors) | reads `20_criteria/positioning-hazards.md` only — NOT the new file; confirms DRAFT-not-wired isolation | no |

**Total: the new file has 0 runtime consumers (DRAFT-not-wired by design); the CLAUDE.md "Section Design Sessions" section has ~4 documentation consumers, 0 must-change.** No `.codex`/`.agents` mirror is implicated because no agent instruction changes (verified: change touches no `layout-architect`/`visual-design-spec` file).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low
- The new file lives in `20_criteria/` — a **read-on-demand doctrine reference, not always-loaded**. Because it is DRAFT-not-wired, nothing in the chain reads it automatically at all (like its precedent `conversion-clarity-review.md`). Zero always-loaded token cost from the file itself.
- The CLAUDE.md edit adds **one pointer line** to the always-loaded project CLAUDE.md (~15–30 tokens/turn) — well under the rubric's ~50–150 Medium band. It is a pointer, not methodology, so it does not carry the always-loaded weight the 2026-07-05 change's six-part Step 0 did (that one was rated Medium at ~100–180 tokens; `2026-07-05-structural-change...md:41`). This change deliberately keeps methodology in the `20_criteria/` doc and only a pointer in CLAUDE.md.
- No hooks, no auto-load, no subagent brief expansion (no agent reads the doc). Pay-as-used.

### Dimension 2: Permissions Surface
**Risk:** Low
- No hooks, no permissions, no settings changes (explicit in CHANGE_DESCRIPTION). Confirmed against `projects/axcion-design-studio/.claude/settings.json`: `deny` (lines 23–32) covers only `rm -rf`, `sudo`, archive/deprecated reads, and brand-book writes (`../axcion-brand-book/**`) — **nothing on `20_criteria/` or CLAUDE.md**. `allow` includes `Write`, `Edit`, and `Write/Edit(**/.claude/**)`; `defaultMode: bypassPermissions`.
- The new file lands in `20_criteria/`, already an established Studio-authored Write location (`positioning-hazards.md`, `conversion-clarity-review.md` are siblings). Authoring a new sibling is within the established pattern; "PROTECTED" (CP-1 tier-C, `technical-spec.md:255`) means load-bearing/gated, not settings-denied to authoring.
- Editing CLAUDE.md is normal operator-flow editing (git shows CLAUDE.md already modified this session). No new tool pattern, no glob widening, no capability escalation.

### Dimension 3: Blast Radius
**Risk:** Low
- Files touched: **1 new file + 1 pointer-line edit.** No new directory (`20_criteria/` already exists).
- Consumers (from inventory): the new file has **0 runtime consumers** — DRAFT-not-wired, so no caller depends on it and no contract it introduces is live. The CLAUDE.md "Section Design Sessions" section has ~4 documentation consumers (the `sections/*.md` files), **0 must-change**: the pointer addition is additive and backwards-compatible, leaving the propose→approve→prompt gate semantics intact.
- No contract change any caller must honor; no shared infra affecting multiple workflows. The blast is contained to one parked doctrine reference and one always-loaded pointer.
- This is squarely the rubric's Low band (single isolated new file, 0 callers, no contract change) — materially smaller than the 2026-07-05 change (which edited a frequently-spawned agent + carried >12 references and conditional mirror should-changes).

### Dimension 4: Reversibility
**Risk:** Low
- The new file + the pointer-line edit revert cleanly via `git revert` of the introducing commit. Unlike the 2026-07-05 `pattern-inventory.md` (which Step 3 refreshes each session — a mutable, accumulating artifact that leaves orphaned state on revert; `2026-07-05-structural-change...md:61`), this is a **static DRAFT reference** with no per-session accumulation. Nothing accrues before ratification.
- No state beyond git, no append-only shared-log mutation inside the doc, no automation that could fire before revert (advisory doctrine, no hooks, no chain wiring).
- Caveat (not a cleanup burden): the OP-11 waiver in `logs/decisions.md` and the PARK entry in `improvement-log.md` are **deliberate durable records of the decision trail** (OP-11 loud-revision requirement). They should survive a revert of the doc — they document that the override was made and, if reverted, that it was undone. That is correct behaviour, not orphaned state.

### Dimension 5: Hidden Coupling
**Risk:** Medium
- **Functional overlap with an already-encoded principle (primary).** The imported "Preservation pass" ("before revising an approved section, name what must NOT change") restates the **already-solidly-encoded #19 protect-approved-decisions / assemble-don't-redesign** doctrine (`2026-07-05-idea-...md:16`). Two statements of the same rule is a latent multiple-source-of-truth hazard. It is **contained** here because the new doc is DRAFT-not-wired (it cannot compete as live runtime authority) and explicitly bounded, but the doc should name its relationship to #19 so ratification does not create a competing second articulation. Mitigable.
- **Citations, not copies (mitigating).** The doc *cites* `positioning-hazards.md` (hard ceiling) and *defers to* the 2026-07-05 page-rhythm Step 0 (`CLAUDE.md:36`) rather than restating either. Both contracts are named at the change site and run one-directionally (new-doc → target), so neither creates a silent staleness dependency (contrast the 2026-07-05 `pattern-inventory.md` derived-artifact staleness contract, rated a High driver there).
- **No mirror drift (mitigating).** The 2026-07-05 change's Claude↔Codex mirror-drift High driver is **deliberately absent**: this change edits no agent, so no `.codex/.agents` mirror falls out of parity. Verified — no `layout-architect`/`visual-design-spec` file is touched.
- **No auto-firing.** DRAFT-not-wired means the doc enters no context automatically; it cannot fire in an unexpected place. Net: one documented near-overlap, otherwise self-contained → Medium (not High: only one coupling, contained by not-wired status and citation-not-copy discipline).

### Dimension 6: Principle Alignment
**Risk:** Medium
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7) — FAILS BOTH PRONGS, downgraded from High by an OP-11 waiver that is documented but NOT YET ON DISK.**
  - **Prong (a) net-simplification — FAILS.** The change adds a net permanent doc (a load-bearing-eligible unit) and removes none. Both the change description and the plan concede this (`2026-07-05-idea-...md:42,58`).
  - **Prong (b) evidenced-failure — FAILS.** Rule #7(b) requires cited written evidence — a log entry or a pattern seen **≥2×**. The evidence is a **single** why-it-works R→R′ churn episode, which CHANGE_DESCRIPTION and the plan both state is below the ≥2× bar (`2026-07-05-idea-...md:23,58` — "one R→R′ episode does not yet satisfy" prong b). "It'll be useful" / build-ahead-of-first-use fails (b) by the rule's own wording.
  - Per this dimension's rule, a net-additive component that fails both prongs is **High UNLESS it is a loudly-recorded OP-11 exception in `logs/decisions.md`**. The intent to record is thoroughly documented (plan step 2, `2026-07-05-idea-...md:53,58,67`), and the override is transparent (operator-elected over a QC PARK). **However, verified against disk: `logs/decisions.md` contains no waiver for this change** — grep for `section-design` / `complexity budget` / `prong` / `preservation pass` / `stop condition` / `2026-07-05` returns zero hits; the only OP-11 entry present is the unrelated 2026-07-04 PostToolUse-hook removal (`decisions.md:181`). So the loud-record condition is **intended but not yet met**. Scoring **Medium**, conditional on the waiver actually being written before/at commit — see Mitigations.
- **Speculative abstraction (OP-9 / AP-7 / DR-7) — bounded tension, not a violation.** Building on single-episode evidence is a build-ahead-of-first-use signal (the system-owner counsel quoted in the plan is "run section-mode once, then let observed failure justify any artifact… nothing else built yet", `2026-07-05-idea-...md:27`). It is bounded because the doc is DRAFT-not-wired (out of the design path, cannot harm), captures two *operator-emphasized* principles rather than a speculative generalization, and is covered by the same OP-11 waiver. Rolled into the complexity-budget finding above.
- **DR-5 / CLAUDE.md-scoping — RESPECTED.** The CLAUDE.md edit is a pointer line only; methodology stays in the `20_criteria/` doc. This deliberately avoids the DR-5 tension the 2026-07-05 change carried (Step-0 methodology in always-loaded CLAUDE.md).
- **Placement (DR-1 / DR-3) — CORRECT.** The new doc is a project-local sibling of `conversion-clarity-review.md` in the Studio-authored `20_criteria/` doctrine layer — the right tier and home for the exact precedent it follows.
- **OP-5 (advisory vs enforcement) / OP-12 (closure before detection) — SATISFIED.** The doc is advisory, DRAFT-not-wired, no enforcement automation; it is doctrine guidance (Preservation pass / Stop conditions both *close* — they tell the operator what to preserve / when to stop), not an un-closed detector.
- **OP-11 / OP-3 (loud revision, never silent drift) — SATISFIED IN INTENT, pending on-disk record.** The override is loudly framed in the plan; the on-disk waiver is the remaining step that converts intent into the recorded, non-silent trail the principle requires.

## Mitigations

Required because the verdict is PROCEED-WITH-CAUTION (paired action per elevated dimension):

- **[Dim 6 — primary] Land the OP-11 waiver in `logs/decisions.md` before (or in) the commit, and verify it names the complexity-budget status explicitly.** The waiver must state that the change fails prong (a) and does not yet meet prong (b) (single-episode evidence), that it proceeds as an operator override of a QC MARGINAL→PARK verdict, and the ratify-to-wire trigger (homepage fully designed + For Investors through one full chain run — `2026-07-05-idea-...md:76`). This is the exact condition that turns the base-High complexity-budget failure into a legitimate, loudly-recorded OP-11 exception rather than silent drift. At review time this record is absent from disk — do not commit the doc without it.
- **[Dim 5 — primary] State the new doc's relationship to the already-encoded #19 protect-approved-decisions doctrine.** In the doc's Preservation-pass section (or its provenance banner), note that it sharpens/operator-emphasizes the existing assemble-don't-redesign / protect-approved-decisions principle rather than introducing a competing rule — so ratification does not create a second source of truth for the same doctrine.
- **[Dim 5 — secondary] Keep the DRAFT/not-wired banner and cite-don't-restate discipline exactly as scoped.** These are what hold the coupling at Medium (no live authority, no mirror, no staleness). If any later step wires the doc into the chain, re-run `/risk-check` — wiring changes the blast radius, the mirror surface, and the overlap posture materially.

## Recommended redesign

_Omitted — verdict is PROCEED-WITH-CAUTION, not RECONSIDER._

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file paths + line numbers, grep counts, settings.json inspection, and cited principle IDs). The central Dimension-6 finding — that the OP-11 waiver is documented in the plan but not yet on disk — is grounded in a direct grep of `logs/decisions.md` returning zero hits for this change. No training-data fallback used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-05-risk-check-second-opinion-section-design-principles-doctrine.md`._

**Concur with PROCEED-WITH-CAUTION, and with the recommended path.** The change is well-contained; its only live risk is principle-level. Routing confirmed: `20_criteria/`, project-local, correctly NOT an ai-resources candidate (DR-1 fails the multi-project test; graduating now would be AP-7 speculative abstraction).

**The DRAFT-not-wired form is the architecturally right shape** — captures the doctrine without fourth-critic wiring or abstraction (DR-7-compatible). The `conversion-clarity-review.md` precedent already proved this holding pattern legitimate.

**All three mitigations accepted, two sharpened:**
- **#1 (land OP-11 waiver):** concur — converts a silent budget-override into a loud documented deviation (OP-3/OP-11). Sharpen: the waiver must record the *case-specific* reason it clears the sub-2× bar, so it is an exception-with-rationale, not a reusable escape hatch.
- **#2 (Preservation-pass ↔ #19):** concur. `[CITATION NEEDED]` — no literal "#19 protect-approved-decisions" artifact resolves on disk; the *concept* is verifiably encoded (CLAUDE.md Step 0 / Chain-fit clause + PROTECTED-file discipline), the numbered handle is not. Correct form: the new doc cross-references the existing rule and frames Preservation-pass as its pre-revision *procedure*, so they sharpen rather than compete (avoids AP-1 silent conflict).
- **#3 (cite-don't-restate + re-run risk-check if wired):** concur strongly — `positioning-hazards.md` is PROTECTED, so restating it would create a driftable second copy.

**Risks the six-dimension frame is structurally blind to (portfolio-level):**
1. **Doctrine-layer proliferation** — this is the *second* DRAFT-not-wired doc in `20_criteria/`. "Mint an unwired doc and defer" accrues doctrine debt (OP-12). Fix: attach a review-by/close-by trigger to these docs now, before it is ten.
2. **Evidence-standard erosion** — un-parking on single-episode evidence is fine once; the risk is the OP-11 waiver becoming the routine way past the ≥2× bar (addressed by the #1 sharpening).

**Verified de-risk (bounds D5):** the CLAUDE.md pointer needs no AGENTS.md mirror — AGENTS.md delegates to CLAUDE.md, so the pointer is harness-neutral. The dual-harness duplicate and the CLOSED four-role contract only bite at the *wiring* transition — which is why "re-run /risk-check if wired" is load-bearing. Keep the CLAUDE.md line a genuine pointer, not an inline restatement (DR-5).
