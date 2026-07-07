---
description: Take one page section through Google Stitch UI/layout exploration — page-context scan, 2–3 directions, a Stitch prompt per direction, review of the captured outputs, and the final Claude Design prompt. Axcíon Design Studio, project-local.
model: opus
argument-hint: <surface> <section>   (e.g. homepage why-it-matters)
---

# /explore-section

Take one page section through **UI/layout exploration** before any Claude Design prompt is written. This is the **Google Stitch** layer of the Section Design Sessions flow (`CLAUDE.md § Section Design Sessions`): it runs the page-context scan, produces 2–3 distinct directions, writes one Stitch prompt per direction for the operator to explore, reviews the outputs the operator captures and brings back, and — after the operator selects or combines — writes the paste-ready Claude Design prompt.

**Argument:** `<surface> <section>` — e.g. `homepage why-it-matters`. If the section identifier is missing or ambiguous, ask once, then proceed.

## Role split (load-bearing)

- **This command generates the Stitch *prompts* and reviews the *outputs the operator brings back*.** It never calls Stitch — Google Stitch is an external Google tool. The operator runs each prompt there, explores/selects/combines the variants, captures the chosen output (screenshot or export) into the section folder, and tells the command to continue. (This respects the workspace Cross-Model Rules: Claude prepares prompts and reviews output; the external tool executes.)
- **Stitch = UI/layout explorer, not the design authority.** Its outputs are directional layout variants, not specifications, and nothing from Stitch enters the build. The command extracts the *concept* from a captured output (composition, hierarchy, type relationships, spacing, visual device), never the generated pixels or code. Because Stitch drifts toward generic app/product/SaaS patterns, every prompt binds it to the Axcíon Web Style Lock, brand book, and positioning hazards (Step 5).
- **Claude Design remains the authoritative drafting workspace** downstream of this command; Figma remains the source of truth for approved design. A Stitch-to-Figma export is still a proposal, not approval — approval happens only via the operator in Figma after the Studio chain. This command's terminal output is a Claude Design prompt — it does not touch the Figma build brief or the non-negotiable Studio sequence, and it adds no new critic pass.

## Where this sits in the chain

Repo reasoning → text directions → **Google Stitch UI/layout variants (this command)** → operator selects or combines → captured back into the repo + decision recorded → Claude Design refinement → final design review in Figma. It operationalizes Steps 0–3 of `§ Section Design Sessions` (scan → propose → approve → prompt) with a UI-exploration sub-loop inserted between propose and approve.

## The 10 steps

Create the section folder `work/{surface}/sections/{section}/` and write each artifact as you go.

**1. Baseline + inputs.** Read before doing anything:
- The surface's approved copy (the copy-factory Web Copy Master / workbench full-page — never the stale handoff packet).
- `work/{surface}/figma-build-brief.md` — the page-level reference (authoritative for goals, brand constraints, positioning hazards, and approved decisions; its section order and components are the current approved snapshot).
- The relevant brand-book chapters via `10_brand-system/` pointers (colour, typography, graphic elements, imagery — whichever the section touches).
- `20_criteria/positioning-hazards.md` — the six hazards.
- `30_reference-lenses/apple-blackstone-lens.md` — the Apple × Blackstone reference lens, applied when shaping directions (Step 4). Advisory and subordinate — it never overrides the brand book, mandate, or hazards.
- `30_reference-lenses/axcion-web-style-lock.md` — the durable cross-page web design language; apply it for visual continuity across surfaces, reject directions that read as disconnected from it, and surface any intended departure before use. Advisory and subordinate — the operator, brand book, mandate, hazards, and approved Figma decisions all outrank it.
- Any existing record for this section (`work/{surface}/sections/{section}.md` flat file, or `.../{section}/selected-direction.md`).
- The operator's current section render, saved as `work/{surface}/sections/{section}/baseline.png`. If absent, ask the operator to drop it in before proceeding — the Stitch prompts reference it as the starting point to preserve.

**2. Page-context scan (Step 0).** Run `§ Section Design Sessions` Step 0 against `figma-build-brief.md`: name (a) what must repeat for coherence, (b) which compositions/devices must NOT repeat here, (c) this section's narrative role + intended energy in the page rhythm, (d) any cross-page duplication. Write → `context-scan.md`. This is a per-run working note derived fresh from the build brief — **not** a maintained page-map alongside it (the build brief is the single page-level reference).

**3. Diagnose.** State the section's purpose, what already works, and the specific problem to solve. Write → `diagnosis.md`.

**3.5. Lens Check (mandatory — before directions or prompts).** Actually consult both mandatory lenses *in this session* — load and run them, do not reconstruct from memory. Use `ui-ux-pro-max` (**clarity pass**) for section purpose, hierarchy, comprehension, CTA logic, density, accessibility, **line length**, and responsive behaviour — narrow queries that return concrete constraints (it is retrieval, not a surface evaluator; *mobile reading order* is not in its data — reason that through `impeccable`/manual, not a ui-ux-pro-max search). Apply `impeccable` (**refinement/subtraction pass**) for hierarchy, typography, spacing, alignment, density, rhythm, subtraction, and AI-slop detection.

The proposal still carries the lean **inline summary lines** — `UI/UX Pro Max consulted: {what it changed}` and `Impeccable consulted: {what it changed}`. But `/explore-section` is the **fuller recorded tier**: `lens-check.md` must record **concrete evidence, not just "lens used"** — the four elements below.

For each **mandatory lens** (UI/UX Pro Max, Impeccable), record:
- **Consulted** — what you actually ran/read: the narrow `search.py` query (or checklist section / `impeccable` reference read), not merely the lens name.
- **Changed / confirmed** — the specific effect (a spacing decision, a hierarchy call, a CTA fix), or "confirmed as-is" with the reason.
- **Rejected** — a direction/device/option this lens ruled out — or "nothing ruled out" plainly.

Then two more elements:
- **Taste** (**anti-template pass**, situational) — was `design-taste-frontend` triggered (a section reading generic/templated/too-safe/visually-repetitive, or needing controlled creative exploration)? If yes, the one **anti-template move** it introduced (cite its §0.D anti-default discipline). If not triggered, say so plainly. Taste is not a mandatory lens and never approves a final direction.
- **Doctrine residual** — what stays governed by **Axcíon doctrine**, not the skills: brand book → mandate → positioning hazards → this page's `figma-build-brief.md` / section records → operator/Figma approval. Name the calls the skills did **not** get to make (identity, palette, red budget, positioning).

A Lens Check that names no concrete effect was not really run. For **page-level critique, high-stakes judgment, or where independence matters**, run one or two **isolated design-review subagents** over the markdown / PDF / image evidence using `impeccable`'s rubric — borrowing its independence principle, **not** its `detect.mjs` detector or literal `/critique` command (degraded here, no live codebase). Ordinary section work stays inline. See `.claude/skills/README.md § Reference-only ≠ single-context`.

**Boundaries:** `impeccable` is a critique/refinement lens only here (design-thinking, no code build); `ui-ux-pro-max` uses narrow, task-specific queries and is **not** a brand-identity or design-system generator (discard its generic `--design-system` output — the locked brand system governs identity). Write → `lens-check.md`. Steps 4–5 (directions + Stitch prompts) must not proceed until this is done and shown.

**4. Directions.** Produce 2–3 genuinely distinct directions (not variations of one). Each: a short concept description (layout, hierarchy, emphasis, mood), a rough ASCII wireframe, the Step 0 clearance (which repeats it honours, which it avoids, its role/energy), its **mobile transform** (the actual reshape, not "columns stack"), and any **motion** (only where it aids comprehension). Apply the Apple × Blackstone lens (`30_reference-lenses/apple-blackstone-lens.md`) as steering — reach for confident scale (Apple) and institutional weight (Blackstone), always within the brand grammar and the six hazards. Reject any direction that is strong in isolation but repeats a composition/device already on the page or breaks a cross-page constant. Write → `option-a-concept.md`, `option-b-concept.md`, `option-c-concept.md`.

**5. Stitch prompts.** For each direction, write one prompt using the **6-part structure** below, referencing `baseline.png`. Write → `option-{a,b,c}-stitch-prompt.md`.

**6. PAUSE — operator explores in Stitch.** Tell the operator to run each prompt in Google Stitch, explore/iterate the variants, and capture the chosen output for each direction — a screenshot or export saved as `option-a.png`, `option-b.png`, `option-c.png` in the section folder. Wait. Do not proceed until the captured outputs exist.

**7. Review the captured outputs.** Read each captured PNG. Critique each against the **output-review criteria** below. Write → `comparison.md`.

**8. Present + wait.** Present the comparison and a single recommendation. Wait for the operator's selection. Do not pick for them.

**9. Record the winner and any departures.** Write `selected-direction.md` — the canonical section record. **Extract the concept, not the pixels or code:** translate the selected (or combined) Stitch output into composition rules, typography relationships, spacing intentions, the visual-device description, elements to preserve, and elements to ignore. Record any **departure** the chosen direction implies from the Web Style Lock, an approved section decision, or the brand grammar (route Tier-1 departures per the Chain-fit guardrail). Note what must stay locked next iteration (copy verbatim, red budget, type scale, no new components).

**10. Claude Design prompt.** Write the paste-ready Claude Design prompt for the selected direction — specific enough to guide a targeted revision, not a full-page redesign. This is the command's terminal output.

## The 6-part Stitch prompt structure (Step 5)

Every Stitch prompt has these six parts, in order. Stitch has no Axcíon context and drifts toward generic SaaS/app UI, so every token and constraint is stated inline:

1. **Reference context** — "Design a web page **section** (not an app screen or dashboard) for Axcíon, a Nordic PE/M&A advisory. Use the attached Axcíon {section} as the base. Preserve its dimensions, general grid, approved copy, typography character, {the locked palette}, and restrained use of red; match the Axcíon Web Style Lock." (References `baseline.png`.)
2. **Specific problem** — the one thing this exploration is fixing (from `diagnosis.md`).
3. **Selected direction** — the single concept this prompt explores (from the option's concept file). One direction per prompt — never several in one image.
4. **Locked elements** — the exact headline/body/CTA copy; do not redesign surrounding sections; do not introduce new colours or a new visual identity.
5. **Visual instructions** — the concrete composition, alignment, type scale, negative space, CTA treatment, and wordmark placement for this direction.
6. **Prohibitions** — no SaaS cards, gradients, glass effects, dashboards, decorative finance graphics, stock-market imagery, rounded containers, excessive red, or centred landing-page composition — plus any section-specific positioning-hazard tell to avoid. Stitch defaults to SaaS/app patterns (feature-card grids, dashboards, sign-up forms, app chrome/navigation); explicitly reject them.

Output requirement: **one web-section layout per direction at approximately the section's real dimensions.** Never ask Stitch for a comparison board of several tiny versions, and never for a full multi-section page or an app shell — one section, one direction per prompt.

**Iteration (conversational edit).** To refine a good option, do NOT regenerate — instruct an edit on the existing output: "Keep the current composition unchanged. {one precise change}. Do not change the headline, button, colours, or overall composition."

**Mood/imagery sketch (optional, Nano Banana).** Stitch is for UI/layout structure. When a direction hinges on *imagery, atmosphere, or a mood* rather than layout — e.g. a photographic treatment or a textural background concept — an optional Nano Banana image sketch can make it tangible. That is a supplementary concept frame, not the layout exploration, and the same rules apply: reference-only, extract the concept, nothing enters the build.

## Output-review criteria (Step 7)

For each captured Stitch output (PNG), assess:
- Did it actually follow the concept?
- Did it preserve the Axcíon brand (palette, type character, restraint), or did Stitch drift toward a generic SaaS/app pattern?
- Does it duplicate a composition/device already used elsewhere on this page (page-rhythm check)?
- Is it more striking — for the right reasons, not novelty?
- Is it likely to work responsively?
- Does it rely on details that would be hard to reproduce in Claude Design / the real build?
- Is it actually better than the current version?

A direction can be visually impressive and still be the wrong answer — if it repeats a prior section, duplicates the page's strongest idea in the wrong place, or introduces a third visual language. Say so plainly.

## Important limitation

Treat Stitch outputs as **directional layout variants, not design specs, and never as build source.** Stitch alters copy, approximates typography, shifts spacing, invents off-system details, drifts toward generic SaaS/app patterns, and produces attractive-but-off-brand layouts; its generated code never enters the Axcíon build (code goes to the website repo; Figma is the approved source of truth). Always extract the concept and translate it (Step 9) — never ask Claude Design to copy a Stitch output pixel-for-pixel.

## Choosing the weight: Lean Exploration → this full run → the Studio chain

Section work has three tiers of weight. Use the lightest that fits, and escalate only when the **Escalation** checklist below fires. `CLAUDE.md § Section Design Sessions` makes Lean Exploration the default posture and points here for the full procedure.

**Lean Exploration (the default, pre-approval).** Most early-stage requests — "give me a couple of directions", "some visual exploration", "a Stitch prompt for this section" — do NOT need this full 10-step run. Run the lean loop instead; you do not have to invoke the whole command to explore:

- **Read only the minimum:** the current page/section brief or `work/{surface}/figma-build-brief.md`; the section record if one exists (`sections/{section}.md` or `sections/{section}/selected-direction.md`); the Web Style Lock (`30_reference-lenses/axcion-web-style-lock.md`); `20_criteria/positioning-hazards.md` as a **quick screen only**; and the two mandatory lenses — UI/UX Pro Max + Impeccable — **actually consulted** per `§ Section Design Sessions` Step 0.5. Consult Taste (`design-taste-frontend`) only if the section reads generic, templated, or repetitive.
- **Produce, and stop there:** a short diagnosis; the concrete lens effects (the two `… consulted: {what it changed}` lines); 1–2 **working directions**; an optional Google Stitch / Claude Design prompt.
- **Provisional vocabulary only:** "working direction / candidate / test option / worth trying" — never "approved / locked / final" unless the operator explicitly moves a direction toward approval.
- **Stop before:** VDS creation, the three critic passes, full QC, Figma build-brief updates, commits, and protected-doctrine edits. None of these happen in Lean Exploration — they belong to the escalation tiers below.

**The full 10-step run (this command).** Escalate from lean to the full run when: choosing between genuinely different compositions; a section is competent but generic and you need to SEE it; the section carries imagery or a custom graphic; lean text directions aren't enough to decide. This tier renders concepts and records `selected-direction.md`.

**Skip visual exploration entirely** (go straight to a narrow Claude Design edit) when: the change is only spacing/typography refinement; the direction is already approved; the fix is a narrow Claude Design edit; you're fixing stale copy; you're making a minor mobile adjustment.

## Artifact folder

`work/{surface}/sections/{section}/`:

```
baseline.png                       # operator-supplied current render
context-scan.md                    # Step 0 scan (per-run working note)
lens-check.md                      # Step 3.5 — 4 elements: UI/UX + Impeccable (consulted/changed/rejected), Taste-if-triggered, doctrine residual
diagnosis.md
option-{a,b,c}-concept.md
option-{a,b,c}-stitch-prompt.md
option-{a,b,c}.png                 # operator-captured Stitch outputs (screenshot/export)
comparison.md
selected-direction.md              # canonical section record
```

For sections run through this command, `selected-direction.md` is the **authoritative** section record. If the section already had a flat `sections/{section}.md` record, mark that flat file superseded — add a top line `> Superseded by sections/{section}/selected-direction.md ({date})` — so there are never two live records for one section. Flat records for sections *not* run through this command stay valid as-is; do not migrate them.

## Chain-fit guardrail

Directions must stay within the page's `figma-build-brief.md` (its Tier-1 goals, brand constraints, positioning hazards, and approved section decisions) and the locked design system — the same rule as `§ Section Design Sessions`. A **Tier-1 departure** (a brand rule, positioning hazard, copy authority, or an approved section decision) must be surfaced and routed back through the Studio critics → QC before use; ordinary layout exploration within the Tier-1 constraints (a different sequence, a split section, a component the website repo would add) is normal work and a handoff note, not a gated departure. This command adds no new critic pass and no new terminal output; it stops at the Claude Design prompt.

## Escalation — when Lean Exploration hands off

Lean Exploration (and this command) is a **pre-approval** loop. It hands off to a heavier tier when ANY of these fires. **This is the single canonical escalation list** — `CLAUDE.md § Section Design Sessions` points here rather than restating it:

1. **A direction is selected for approval** — record it and route toward Figma / handoff. The lean loop and this command do not themselves approve; the operator approves in Figma.
2. **The change departs from a brand rule, positioning hazard, approved copy authority, or an approved section decision** (a **Tier-1 departure**) — route the affected part back through the Studio critics → QC (the full `visual-design-spec` chain). See the Chain-fit guardrail above.
3. **The work affects a full page or the design system, not one exploratory section** — run the whole-surface `visual-design-spec` chain, not the lean loop.
4. **The operator explicitly asks for approval, handoff, or finalization** — move to the full chain / handoff.

Ordinary layout exploration *within* the Tier-1 constraints stays lean — it is normal section work (and, where it affects the build, a handoff note to the website repo), not a gated departure. Absent any trigger above, exploration stays provisional: working directions and candidates, never "approved" or "locked."
