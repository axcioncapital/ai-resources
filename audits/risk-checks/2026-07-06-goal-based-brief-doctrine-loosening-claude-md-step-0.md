# Risk Check — 2026-07-06

## Change

PLAN-TIME + PRE-COMMIT gate. Structural change (cross-cutting CLAUDE.md edit + doctrine + command reconcile) in projects/axcion-design-studio, part of the S2 goal-based brief conversion. The two work/ files (figma-build-brief.md, page-brief.md) are already reframed goal-based on disk (low-risk tier, done). This gate covers the doctrine loosening that must match them.

CHANGE SET (5 edits across 3 files):
1. CLAUDE.md § Section Design Sessions Step 0 (currently line ~36): loosen "the build brief is the authority of record" → the brief is authoritative for the page's GOALS, brand constraints, positioning hazards, and approved decisions; its section order + component mapping are the "current approved snapshot" (reference the design serves, not a fixed skeleton). Also replace the hardcoded "red spent at most twice per page" with "red kept within the brief's approved red budget" (resolves a pre-existing staleness: the brief was updated 2→3 red moments in Phase A but Step 0 still says twice). Keep the "no separate page-map artifact" rule. Retitle "authority of record" → "single page-level reference."
2. CLAUDE.md § Section Design Sessions Chain-fit clause (currently line ~43): refine "if a proposal departs from the approved brief, route back through the Studio chain" → only a TIER-1 departure (brand rule / positioning hazard / copy authority / approved section decision) routes back through critics→QC; ordinary layout exploration within the Tier-1 constraints (different sequence, split section, a component the website repo must add) is normal section work + a handoff note to the website project, NOT a gated departure.
3. 20_criteria/section-design-principles.md Constraint 4 (currently line ~23): update its cross-reference that currently describes CLAUDE.md Step 0 as binding the brief "as the authority of record" → match the new framing (authoritative for goals/constraints/hazards/decisions; section order/components are current approved snapshot).
4. .claude/commands/explore-section.md (currently line ~29): "the page-level authority of record" → "the page-level reference (authoritative for goals/brand-constraints/positioning-hazards/approved-decisions; section order/components are current approved snapshot)."
5. .claude/commands/explore-section.md (currently line ~36): "(the build brief is the authority of record)" → "(the build brief is the single page-level reference)."

INTENT: make the section-refinement doctrine goal-based so a good new section design is not judged "wrong" merely for diverging from the old fixed skeleton, while keeping brand rules, positioning hazards, copy authority, red discipline, the one-action principle, and approved section decisions strict. Operator has approved the two work/ file reframes and said "go" to this gated edit; final sign-off pending on the exact diffs + this verdict.

EXPLICITLY NOT TOUCHED: brand book grammar; 20_criteria/positioning-hazards.md; the four-role critic count/shape (CLOSED contract, pipeline/architecture.md DD-A4); approved section records (why-it-works.md R, who-we-serve.md A); the parked conversion-critic; pipeline/ docs. Out of scope but FLAGGED for a later gated pass: .claude/agents/layout-architect.md line ~67 still hardcodes "red spent at most twice" (same pre-existing staleness as edit #1) — an agent-instruction edit, separate structural class, not folded in here.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/20_criteria/section-design-principles.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/commands/explore-section.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/homepage/figma-build-brief.md — exists (already reframed goal-based; read to see the target framing the doctrine must match)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/homepage/page-brief.md — exists (already reframed goal-based)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/layout-architect.md — exists (out-of-scope; flagged for the stale "red twice" line — assessed below)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The five proposed edits are correctly scoped and directionally sound, but the consumer inventory surfaces two additional must-change spots the change set omits — one inside the very file it edits (explore-section.md's own Chain-fit guardrail) and one it doesn't mention at all (vds-template.md's duplicate stale red-count) — plus a Medium always-loaded token cost.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-design-studio/CLAUDE.md:36` (Step 0) | edited directly | Yes (edit #1, in scope) |
| `projects/axcion-design-studio/CLAUDE.md:43` (Chain-fit clause) | edited directly | Yes (edit #2, in scope) |
| `projects/axcion-design-studio/20_criteria/section-design-principles.md:23` (Constraint 4) | quotes Step 0's "authority of record" framing verbatim | Yes (edit #3, in scope) |
| `projects/axcion-design-studio/.claude/commands/explore-section.md:29` | quotes "the page-level authority of record" | Yes (edit #4, in scope) |
| `projects/axcion-design-studio/.claude/commands/explore-section.md:36` | quotes "(the build brief is the authority of record)" | Yes (edit #5, in scope) |
| `projects/axcion-design-studio/.claude/commands/explore-section.md:109–111` ("Chain-fit guardrail") | restates the *binary* departure rule the change is loosening — "the same rule as `§ Section Design Sessions`… If a direction departs from the approved brief, surface the departure and route the affected part back through the Studio critics → QC" | **Yes — not in the proposed edit set (gap).** Same file edits #4/#5 already touch, third relevant line missed. |
| `projects/axcion-design-studio/.claude/skills/visual-design-spec/references/vds-template.md:40` | duplicates the exact stale phrase edit #1 fixes in CLAUDE.md — `"symmetric icon grid, red spent at most twice per page"` | **Yes — not flagged anywhere in CHANGE_DESCRIPTION (gap, distinct from the acknowledged layout-architect.md deferral).** |
| `projects/axcion-design-studio/.claude/agents/layout-architect.md:67` | duplicates the same stale "red spent at most twice per page" phrase | No — explicitly flagged and deferred by the operator to a separate gated pass (loud, not silent) |
| `projects/axcion-design-studio/30_reference-lenses/apple-blackstone-lens.md:48` | restates the binary Chain-fit rule ("per `CLAUDE.md § Section Design Sessions` 'Chain fit'") | No — its departures are brand-grammar/imagery/colour, which stay Tier-1 under the new framing, so the restatement remains accurate in practice; cosmetic staleness only |
| `projects/axcion-design-studio/20_criteria/section-design-principles.md:11` ("Relationship to existing doctrine") | restates "route departures back through critics → QC" generically | No — generic enough to remain accurate (Tier-1 departures still route back) |
| `projects/axcion-design-studio/web-refinement-playbook.md` | grep-verified per the operator's own session-plan flag (`logs/session-plan-2026-07-06-S2.md:68`); contains only an unrelated self-referential "authority of record" (playbook-vs-`source-of-truth-hierarchy.md` authority, line 6) and a loose "Step 0 page-context scan" pointer (line 7) | No — confirmed no exact-phrase dependency; survives unchanged. The session-plan's own flag on this file is resolved by this grep as a non-issue. |
| `work/homepage/figma-build-brief.md`, `work/homepage/page-brief.md` | the two already-reframed goal-based documents this doctrine edit must match | No — already done (Phase A/D 2026-07-06), this is the target framing, not an additional edit target |
| `work/homepage/sections/{hero,who-we-serve,how-we-help}.md` | historical "Chain fit:" notes recording already-resolved past decisions under the old binary rule | No — explicitly out of scope (approved section records); historical record of a resolved decision, not a live rule statement |
| `logs/decisions.md`, `logs/session-notes.md`, `logs/next-up.md`, `logs/scratchpads/*`, `audits/lean-repo-2026-07-05-playbook-fit.md`, `projects/axcion-ai-system-owner/output/consultations/*.md` | historical/log records quoting the pre-change wording as history | No — append-only or point-in-time archives |

**Total: 14 consumers found, 7 must-change** (5 covered by the proposed edit set + 2 gaps the change set omits).

## Dimensions

### Dimension 1: Usage Cost

**Risk:** Medium

- CLAUDE.md is always-loaded project context (`00_mandate/source-of-truth-hierarchy.md:29`, "`CLAUDE.md` | Always-loaded context", cited in this project's own prior risk-checks e.g. `ai-resources/audits/risk-checks/2026-07-05-apple-blackstone-lens-integration.md:42`).
- Edit #1 replaces one sentence ("The build brief is the authority of record — do not maintain a separate page-map artifact alongside it.", ~20 words) with a materially longer tier explanation (goals/brand-constraints/hazards/decisions vs. current-approved-snapshot vs. retitle), plus a red-budget rewording.
- Edit #2 replaces one binary sentence with a Tier-1-vs-ordinary-layout distinction (~2–3x the current clause length).
- By direct comparison with this project's own prior precedent for CLAUDE.md § Section Design Sessions edits — the 2026-07-05 Step 0 insertion was independently estimated at "100–180 tokens… squarely the rubric's Medium band" (`ai-resources/audits/risk-checks/2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md:41`), and the smaller 2026-07-05 lens-pointer edit was estimated "~50–100 tokens… at the low end of Medium" (`ai-resources/audits/risk-checks/2026-07-05-apple-blackstone-lens-integration.md:42`) — this change's two clause rewrites (retitle + tier framework + red-budget wording) land in the same Medium band, likely 60–110 net tokens added to every design-studio session turn.

### Dimension 2: Permissions Surface

**Risk:** Low

- No `.claude/settings.json` change, no new tool/Write/API capability, no hook. Pure prose edits to already-existing, already-writable project files (`CLAUDE.md`, `20_criteria/section-design-principles.md`, `.claude/commands/explore-section.md`) — the same file set and edit shape as this project's prior same-day CLAUDE.md/doctrine edits (Phase A/B/C/D, commits `01f0f00`/`42b600e`/`d7d04c7`/`ac87d12`).

### Dimension 3: Blast Radius

**Risk:** Medium

- From the Consumer Inventory: 14 consumers found, 7 true must-change against the 5 proposed edits — i.e. the change set is **incomplete relative to its own stated purpose**, missing 2 of 7 identified must-change spots.
- The two gaps are textual/doctrinal, not mechanical — no script or agent parses these strings by pattern-match, so nothing throws or silently misfires; the risk is that a future Studio session (or `/explore-section` run) reads a self-contradicting or stale rule and applies it as-is.
- This stays in the Medium band rather than High because: (a) the gaps are compatible, backwards-compatible prose corrections, not a caller contract break; (b) one gap (`vds-template.md`) is the same known staleness class the operator already consciously deferred once (`layout-architect.md`), so the fix pattern is already established; (c) the other gap (`explore-section.md:109–111`) is a same-file, same-edit-pass addition, not a new cross-project dependency to trace.

### Dimension 4: Reversibility

**Risk:** Low

- All five edits are prose changes to git-tracked markdown files in an existing git repo (`projects/axcion-design-studio` — confirmed a git working tree). A clean `git revert` of the commit restores prior wording exactly. No sibling-file mutation beyond the stated 3 files, no log/state mutation, no automation triggered.

### Dimension 5: Hidden Coupling

**Risk:** High

- **Direct evidence of self-inconsistency after the edit lands.** `explore-section.md` contains three distinct restatements of CLAUDE.md doctrine this change touches: lines 29 and 36 (the "authority of record" phrase, edits #4/#5 — covered) and lines 109–111, the "Chain-fit guardrail" section, which explicitly claims to mirror "`§ Section Design Sessions`" and then restates the *old* binary departure rule ("If a direction departs from the approved brief, surface the departure and route the affected part back through the Studio critics → QC before use"). After edit #2 lands, `explore-section.md` will contain, in the same file, two updated lines using the new Tier-1 framing and one untouched line stating the pre-change binary rule while claiming to be "the same rule" — a verifiable in-file contradiction, not a hypothetical one.
- **Duplicated numeric fact with no single source of truth.** The "red spent at most twice per page" phrase is hardcoded independently in three files (`CLAUDE.md:36`, `layout-architect.md:67`, `vds-template.md:40`) rather than derived from or pointing to `figma-build-brief.md` §5 (the actual current count — three moments, per its own Reconciliation Log). This is the exact failure mode this project's own prior risk-check named by evidence: "Three-way overlap / no stated authority of record… classic multiple-source-of-truth hazard" (`ai-resources/audits/risk-checks/2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md:66`). This change fixes one of the three duplicates, explicitly acknowledges (and defers) the second, and is silent on the third.
- Not Low because these are not self-contained edits into files with no other reference to the same substance — three additional files (`explore-section.md`'s own third line, `vds-template.md`, `apple-blackstone-lens.md`) independently restate substance this change is revising, without any pointer-not-restate discipline enforcing sync.

### Dimension 6: Principle Alignment

**Risk:** Low

- **OP-11 (surfacing/revising principles loudly, not silent drift) / OP-3 (loud failure over silent continuation) — satisfied.** This is a deliberate, recorded doctrine revision: it is named in `logs/session-plan-2026-07-06-S2.md`, gated through this `/risk-check`, and requires explicit operator sign-off before landing — the loud mechanism OP-11 requires, not drift.
- **DR-5 (CLAUDE.md holds cross-session rules only, not methodology) — clear.** The rewording stays at the rule level (tier definitions, departure routing) rather than adding step-by-step methodology.
- **AP-1 (silent conflict resolution) — the risk this dimension flags is prospective, not a violation of the change as proposed.** The two Blast-Radius/Hidden-Coupling gaps found above (§D3/D5) would become AP-1 instances (undocumented multi-source restatement drifting apart) **only if landed without acknowledgment**. Since this risk-check is itself the loud-surfacing mechanism catching them pre-commit, landing the 5 edits as-is is not itself a violation — but doing so *silently, without addressing or logging the 2 gaps*, would re-create the exact pattern the operator's own prior audit already named and warned against (`2026-07-05-structural-change-to-the-axcion-design-studio-doctrine-layer.md:66`, `:91`).
- **DR-1/DR-3 (placement) — clear.** All edits land in their established canonical homes (project `CLAUDE.md`, `20_criteria/`, `.claude/commands/`); no placement ambiguity.
- **OP-12 (closure before detection) — aligned.** This change closes existing staleness (the CLAUDE.md/brief mismatch) rather than building new detection machinery — the correct priority order per OP-12.

## Mitigations

- **[Pairs with Dimension 5 — High]** Extend the `explore-section.md` edit to also update the Chain-fit guardrail (lines 109–111): either restate it with the same Tier-1-vs-ordinary-layout nuance edit #2 introduces in CLAUDE.md, or replace the restatement with a bare pointer ("see `CLAUDE.md § Section Design Sessions`'s Chain-fit clause for the current departure rule") so this file never needs a second edit when CLAUDE.md's Chain-fit wording changes again.
- **[Pairs with Dimension 5 — High]** Resolve `vds-template.md:40`'s stale "red spent at most twice" the same way `layout-architect.md:67` is being handled: either fold the one-line fix into this same pass (it is the identical phrase, identical fix, and this change's own rationale already names the staleness class), or explicitly add it to the logged deferral alongside `layout-architect.md` so it is a loud, named exception rather than a silent omission.
- **[Pairs with Dimension 3 — Medium]** Before committing, re-run the "authority of record" / "Chain fit" / "red spent at most twice" grep sweep once more against the final diffs to confirm no other duplicate restatement was missed (this risk-check's sweep used `command grep` to bypass a gitignore-aware shell alias that silently excluded the entire `projects/axcion-design-studio` tree on the first pass — see Evidence-Grounding Note).
- **[Pairs with Dimension 1 — Medium]** No specific token-reduction mitigation required — the added tier language is load-bearing (it is the entire point of the goal-based conversion) — but keep the reworded Step 0/Chain-fit prose as tight as the tier distinction allows; do not pad with illustrative examples beyond what's already in the plan.

## Evidence-Grounding Note

All risk levels are grounded in direct file reads (all six `exists`-tagged referenced files, plus `CLAUDE.md` at both the workspace root and `ai-resources/` root, plus `principles-base.md`) and in `command grep` sweeps across the workspace root and `ai-resources/`. One methodological correction made mid-review: the default `grep` in this shell resolves to a wrapped `ugrep` invocation with `--ignore-files --hidden`, which silently respects `.gitignore`-style excludes and returned **zero** hits inside `projects/axcion-design-studio/` for phrases directly confirmed present there by direct-file grep (e.g. `CLAUDE.md:36` itself). All Consumer Inventory and Dimension findings above are from the re-run `command grep` sweep (bypassing that alias), not the first, under-reporting pass — flagging this because the *identical* under-reporting failure mode was independently noted in a prior risk-check for this same project (`2026-07-02-wireframe-first-stage-design-studio-pipeline.md:147`: "a repo-root `grep -r .` under-reported project matches"). No training-data fallback was used; every dimension is cited to a specific file+line or direct quote.
