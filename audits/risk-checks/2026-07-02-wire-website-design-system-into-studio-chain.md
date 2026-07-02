# Risk Check — 2026-07-02

## Change

Proposed structural change: wire the website project's locked design system into the Axcíon Design Studio chain so the Studio designs WITHIN it.

Change set (4 files):
1. `.claude/agents/layout-architect.md` (creator) — add `projects/axcion-website/pipeline/technical-spec-design-system.md` as a primary input (component library, page-template archetypes incl. HomepageLayout, tokens, responsive system); add a "design within the locked system, never invent new components/patterns — surface them as operator decisions" constraint.
2. `.claude/agents/implementation-bridge.md` (buildability critic) — change its primary buildability reference from `projects/axcion-website/pipeline/project-plan.md` to the design-system spec; update its three feasibility dimensions to judge against the real component library/tokens/responsive system.
3. `.claude/skills/visual-design-spec/SKILL.md` — add the design-system spec to the Step 1 creator dispatch inputs and the Step 2 implementation-bridge reference; add a one-line note on the QC-rubric seam.
4. `00_mandate/design-studio-mandate.md` (PROTECTED doctrine) — §1 add "designs within the website's locked design system"; §2 add a scope bullet that the website design system is an input the Studio designs within; §5 note component-patterns/responsive reference the website system.

Context: The Studio is Phase 1, engine built but not yet run end-to-end (no homepage proof yet), so there are no existing VDS/critique outputs that depend on the old input set. Operator has confirmed the boundary (design within the website's fixed system). The website design-system spec exists, is substantial, and mandates "assemble, don't redesign / never design a page freely." Evaluate before landing.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/layout-architect.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/agents/implementation-bridge.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/00_mandate/design-studio-mandate.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/technical-spec-design-system.md` (new input being wired in)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/scratchpads/2026-07-02-design-system-wiring-plan.md` (plan)

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The change closes a real gap and is fully reversible, but it introduces a new cross-project dependency on a large, not-yet-finalized website spec (versioned `refined (ready for /spec-evaluate)`), adds a heavy per-pass read on two Opus/critic agents, and touches the PROTECTED mandate plus several now-stale pipeline docs — three Medium dimensions that want scoped reads, a currency guard, and a stale-doc sweep.

## Consumer Inventory

Search terms: `layout-architect`, `implementation-bridge`, `visual-design-spec`, `design-studio-mandate`, `technical-spec-design-system`, `project-plan.md`. Greps run across the design-studio project and the workspace root. Rows below are distinct consumers *outside* the four files in the change set. Self-references (the four changed files referencing each other) are excluded. Log/QC/scratchpad files (session-notes, decisions, qc/*, scratchpads, innovation-registry, session-plan, project-next-steps) are historical records, not live contracts — grouped, not enumerated.

| Consumer path | Reference type | Must-change? |
|---|---|---|
| `.claude/skills/visual-design-spec/SKILL.md` | invokes (dispatches both agents; owns the halt-gate that names `project-plan.md` as implementation-bridge's required input) | yes — **in change set** |
| `00_mandate/design-studio-mandate.md` | documents (the four-role table + sequence) | yes — **in change set** |
| `pipeline/architecture.md` | documents implementation-bridge I/O (`project-plan.md` as its reference) | no (staleness — will misdescribe the new reference) |
| `pipeline/technical-spec.md` | documents agent contracts | no (staleness) |
| `pipeline/implementation-spec.md` | documents agent contracts | no (staleness) |
| `.claude/skills/visual-design-spec/references/figma-build-brief-schema.md` | documents implementation-bridge as source of "Component patterns"/"Responsive" sections | no (may want a note that these now trace to the website system) |
| `.claude/agents/brand-guardian.md`, `.claude/agents/visual-red-team.md` | documents sibling critics (scope-boundary notes) | no |
| `10_brand-system/README.md`, `pipeline/project-plan.md`, `pipeline/create-skill-brief.md`, `pipeline/test-results.md`, `pipeline/implementation-log.md`, `CLAUDE.md` | documents the roster / references the agents | no |
| `projects/axcion-website/pipeline/technical-spec-design-system.md` | new upstream dependency (read-only input) | no — but see Dimension 5 (drift/currency) |
| design-studio `logs/**` (session-notes, decisions, qc/*, scratchpads, innovation-registry, session-plan, project-next-steps) + workspace `logs/session-notes.md` | historical records | no |

Total: ~19 distinct consumers, 2 must-change (both in the change set). No live external invoker outside the change set — the only functional invoker (SKILL.md) is being updated in lockstep.

## Dimensions

### Dimension 1: Usage Cost

**Risk:** Medium

- The new input is large: `technical-spec-design-system.md` is **812 lines / ~44,776 tokens** (verbatim from the Read system-reminder: "showing lines 1-385 of 812 total (44776 tokens)"). Adding it as a *primary* read materially raises per-pass context load on **two** agents: `layout-architect` (creator, `model: opus`, line 4) and `implementation-bridge` (critic).
- The creator already carries a heavy read set — page brief, approved copy, 7 brand-book chapters, mandate, hazards (layout-architect.md lines 20-35). A ~45k-token spec on top is a real cost per design pass, on Opus (`visual-design-spec` SKILL.md runs `opus`/`high`, lines 11-12, 157-160).
- Mitigant already in the plan: it scopes the read to named sections ("component library §2.2, page templates §2.3, tokens §2.1, responsive system §2.4" — plan line 14), not the whole file. If the agent instructions cite specific sections and the agents honour them, cost is contained; if they read the whole file, cost is high. The instruction wording will decide which.
- implementation-bridge currently reads `project-plan.md` (implementation-bridge.md line 23); this swaps one cross-project read for a larger one — a net increase, not a new read slot.

### Dimension 2: Permissions Surface

**Risk:** Low

- No new permission is required. design-studio `.claude/settings.json` grants unscoped `Read` (allow list) and denies only `Edit`/`Write` to `../axcion-brand-book/**` — there is **no** deny on reading `projects/axcion-website/**`.
- The cross-project read pattern is already established and working: implementation-bridge.md line 23 already reads `projects/axcion-website/pipeline/project-plan.md`, and layout-architect already reads `projects/axcion-brand-book/` and `projects/axcion-copy-factory/` (layout-architect.md lines 23-32). Adding `axcion-website` as a creator read source is the same class of same-workspace cross-project read.
- The Studio only *reads* the spec; it never writes it. The mandate boundary ("the code build … belongs to the website project" — mandate §2, line 29) is preserved at the permission layer.

### Dimension 3: Blast Radius

**Risk:** Medium

- Consumer inventory: ~19 distinct consumers, **2 must-change, both inside the change set** (SKILL.md invoker + mandate). No live external invoker needs to change — the dispatch interface (agent *names*) is unchanged; only agent *content* (read-lists, dimensions, constraints) changes.
- Blast radius is bounded by the Phase-1 state: the change description states no end-to-end run has occurred, so **no existing `work/{surface}/` VDS or critique outputs depend on the old input set** — there is nothing downstream to re-derive. This is the single biggest reason the radius stays Medium rather than High.
- The pressure is **documentation staleness**, not functional breakage: `pipeline/architecture.md`, `technical-spec.md`, and `implementation-spec.md` describe implementation-bridge's reference as `project-plan.md`. After the change they misdescribe the live contract. Non-breaking, but it is exactly the drift the workspace's contract-conformance discipline exists to catch.
- The change touches **4 coordinated files including the PROTECTED mandate** (mandate.md line 3: "Edit only with explicit operator approval (CP-1 tier-C gate)"). Coordinated multi-file edits where one file is doctrine raise the radius above Low.

### Dimension 4: Reversibility

**Risk:** Low

- All four edits are additive text changes to git-tracked Markdown instruction files. No data migration, no schema change, no destructive op, no generated artifact to unwind (Phase-1, not yet run).
- Full revert is a `git revert` / manual un-edit; the swapped reference in implementation-bridge (project-plan.md → design-system spec) is a one-line restore.
- The one reversibility asterisk: the PROTECTED mandate edit should be reverted *loudly* if rolled back (it is doctrine), but the mechanical reversal itself is trivial.

### Dimension 5: Hidden Coupling

**Risk:** Medium

- **New cross-project dependency on a non-finalized spec.** `technical-spec-design-system.md` frontmatter reads `status: refined (ready for /spec-evaluate)` and `version: v2` (lines 4-6) — it has **not yet passed its own `/spec-evaluate` QC gate**. Wiring an un-QC'd, still-moving spec as a *primary* Studio input couples the Studio to a target that may shift when the website project evaluates/revises it. There is no version pin and no drift-detection cadence protecting the Studio (contrast the spec's own §3.4 CP-cadence that guards *it* against brand-book drift — no symmetric guard protects the Studio from *this* spec's drift).
- **Halt-gate sync coupling.** The SKILL.md failure behaviour hard-codes implementation-bridge's required input as `project-plan.md` ("A critic's required *input* file is missing (e.g. … `projects/axcion-website/pipeline/project-plan.md` for `implementation-bridge`): halt before dispatching" — SKILL.md lines 184-189). The agent's own Step-1 halt also names project-plan.md (implementation-bridge.md line 26). Both must be updated in lockstep with the reference swap, or the skill halts on the wrong file / dispatches against a missing standard. The plan flags the SKILL.md update (plan line 29) but the risk is a partial edit leaving one halt pointing at the old file.
- **Boundary-blur coupling.** The design-system spec is the website's *renderer infrastructure* — Astro component file paths, TypeScript `Props` interfaces, `tokens.ts`, `tailwind.config.ts` (spec §2.1-§2.4, §4.2 directory tree). The mandate lists "the code build … belongs to the website project" as **out of scope** (mandate §2 line 29). Feeding implementation-specific detail into the creator and buildability critic risks their reasoning drifting from *visual reasoning* into *build spec* — the exact boundary the mandate draws. The "design within the system / surface new components as operator decisions" framing (plan line 5) mitigates this by intent, but the coupling is real and depends on instruction discipline to hold.

### Dimension 6: Principle Alignment

**Risk:** Low

- **DR-7 / OP-9 / AP-7 (speculative abstraction)** — *not* tripped; the change is the opposite of speculation. The consumer (the homepage design pass) is real and imminent, and the design-system spec already exists. The change removes a gap where the creator "designs from the brand book alone" and could propose components the website cannot build. This grounds the Studio in a confirmed real constraint (principles-base.md OP-9 line 47, DR-7 line 60).
- **OP-12 (closure before detection)** — aligned; the change closes an identified gap (Studio blind to the locked system) rather than adding new detection (principles-base.md line 50).
- **OP-5 (advisory vs enforcement)** — preserved; implementation-bridge still only *flags*, and new-component needs *surface as operator decisions* rather than being auto-resolved (principles-base.md line 43). The creator/critic separation and operator-approver posture are untouched.
- **OP-11 / OP-3 (loud, deliberate revision)** — the PROTECTED mandate edit is a doctrine change and must be loud and operator-gated; the plan explicitly requires "explicit operator go on file 4 specifically" (plan line 42), satisfying OP-11's "recorded, explicit evolution, never silent drift" (principles-base.md lines 33, 49).
- **OP-2 (gate judgment)** — respected; the mandate carries a CP-1 tier-C gate (mandate line 3) and the change routes through `/risk-check` per Autonomy Rule #9 (plan line 41).
- **DR-1 / DR-3 (placement)** — no new files; edits land in the correct existing homes (agents in `.claude/agents/`, skill in `.claude/skills/`, doctrine in `00_mandate/`).
- One watch-item, not a violation: the boundary-blur noted in Dimension 5 sits adjacent to **OP-10** (system-boundary discipline) in spirit — keep the Studio's use of the spec to *visual* reasoning, not build authorship.

## Mitigations

Per-Medium paired mitigations (no High dimensions; verdict driven by three Mediums):

- **[Dim 1 — Usage cost]** Scope the agent read instructions to the *named sections* of the design-system spec (§2.1 tokens, §2.2 component library, §2.3 page templates/HomepageLayout, §2.4 responsive), as the plan already intends — explicitly tell the agents *not* to read the full 812-line file. Cite section anchors in both agent bodies so the read stays bounded on every pass.
- **[Dim 3 — Blast radius]** Sweep the three stale pipeline docs (`architecture.md`, `technical-spec.md`, `implementation-spec.md`) and the `figma-build-brief-schema.md` note in the same change (or log them as an immediate follow-up) so the design-studio record does not describe implementation-bridge's reference as `project-plan.md` after the swap. Confirm the mandate edit ships only with the operator's explicit tier-C go.
- **[Dim 5 — Hidden coupling]** (a) Add a currency note where the spec is cited — record that it is wired at `version: v2 / ready for /spec-evaluate` and flag a re-check when the website project finalizes it; consider a lightweight drift trigger (re-read the spec's frontmatter version at the start of a design pass). (b) Update **both** halt-gates (SKILL.md failure behaviour *and* implementation-bridge.md Step 1) in the same edit — verify no halt still names `project-plan.md`. (c) Keep the agent instructions explicit that the spec is consumed for *visual/buildability reasoning only*, not to author build detail, preserving the mandate's code-build boundary.

## Recommended redesign

Not applicable — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.

## Evidence-Grounding Note

Every finding cites a file path with line numbers, a verbatim frontmatter/instruction quote, or a grep count. Consumer inventory derived from `grep -rlniI` across the design-studio project and workspace root for the five basenames plus `project-plan.md`. The design-system spec was read to line 385 of 812 (token cap); §2.1-§2.5, §3.4, and §4.2 — the sections the change wires in and the coupling-relevant shared-state section — fall within the read window, so the dependency and drift findings are grounded, not inferred. Principle IDs cite `projects/strategic-os/ai-strategy/principles-base.md` (present; 106 lines). No dimension is INCOMPLETE.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concur with PROCEED-WITH-CAUTION.** Closes a real gap with a confirmed imminent consumer (the homepage pass) — DR-7 / OP-9 aligned, clears AP-7. Not a RECONSIDER shape. Routing clean (all edits land in existing project-local homes; no canonical surface touched). Blast radius bounded.

**Design-authority boundary resolvable; "design within the locked system" is correct.** Authority splits by layer: brand book owns element grammar; website owns component grammar + HomepageLayout skeleton + rendered-page rubric; Studio owns reasoning within that grammar; operator owns approval + departures.

**Two risks the six-dimension review missed:**
- **A — thin residual decision space.** With skeleton/components/tokens/responsive fixed upstream + a website rubric on rendered output, the Studio's unique space narrows to section selection/order, hierarchy, copy→component mapping, positioning-hazard screening. The planned mandate §2 edit ("an input the Studio designs within") is too thin — it must NAME the authority split, or the four-role team drifts into over-reach or redundancy (OP-12 signal).
- **B — cost mitigation and coupling collide.** Citing hard section numbers §2.1–§2.4 creates a fragile two-end anchor into a spec whose sections move between versions and which is about to enter `/spec-evaluate`. Cite section TITLES, not numbers.

**Mitigations — right path, five refinements:**
1. Mandate §2: name the website-owns-grammar / Studio-owns-reasoning split explicitly.
2. Scope reads by section TITLE + hard cap; frame implementation-bridge's dimensions as a checklist against the enumerated component set (fits Sonnet tier, QS-5).
3. Sweep the 3 stale pipeline docs in-change (cheap, structural-fix-as-default); ship mandate edit only with explicit tier-C go (OP-2/OP-11).
4. Two-rubric seam needs more than one line: state SEQUENTIAL authority — website rubric authoritative on rendered output, implementation-bridge a pre-build early-warning, operator reconciles contradictions at the approval gate.
5. SKIP the automated frontmatter-re-read drift-trigger — over-builds for Phase 1 (DR-7/AP-7). Currency note + a re-verify pinned to the website's `/spec-evaluate` completion is the correct minimum.

**Grounding note:** axcion-website / axcion-design-studio / axcion-copy-factory are not yet in the vault projects registry — paste at next `/friday-act` (not a blocker).

_Full advisory: projects/axcion-ai-system-owner/output/consultations/consult-2026-07-02-wire-website-design-system-into-studio.md_
