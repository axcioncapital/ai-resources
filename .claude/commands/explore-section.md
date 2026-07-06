---
description: Take one page section through Nano Banana visual-concept exploration — page-context scan, 2–3 directions, a Nano Banana prompt per direction, image review, and the final Claude Design prompt. Axcíon Design Studio, project-local.
model: opus
argument-hint: <surface> <section>   (e.g. homepage why-it-matters)
---

# /explore-section

Take one page section through **visual-concept exploration** before any Claude Design prompt is written. This is the Nano Banana layer of the Section Design Sessions flow (`CLAUDE.md § Section Design Sessions`): it runs the page-context scan, produces 2–3 distinct directions, writes one Nano Banana prompt per direction for the operator to render, reviews the images the operator brings back, and — after the operator selects — writes the paste-ready Claude Design prompt.

**Argument:** `<surface> <section>` — e.g. `homepage why-it-matters`. If the section identifier is missing or ambiguous, ask once, then proceed.

## Role split (load-bearing)

- **This command generates the Nano Banana *prompts* and reviews the *images the operator brings back*.** It never calls Nano Banana — Nano Banana is an external Google tool. The operator runs each prompt there, saves the outputs into the section folder, and tells the command to continue. (This respects the workspace Cross-Model Rules: Claude prepares prompts and reviews output; the external tool executes.)
- **Nano Banana = fast visualizer, not the design authority.** Its outputs are directional concept frames, not specifications. The command extracts the *concept* from an image (composition, type relationships, spacing, visual device), never the pixels.
- **Claude Design remains the authoritative design workspace** downstream of this command; Figma remains the source of truth for approved design. This command's terminal output is a Claude Design prompt — it does not touch the Figma build brief or the non-negotiable Studio sequence, and it adds no new critic pass.

## Where this sits in the chain

Repo reasoning → text directions → **Nano Banana concept mockups (this command)** → operator selection → Claude Design refinement → final design review. It operationalizes Steps 0–3 of `§ Section Design Sessions` (scan → propose → approve → prompt) with a visual-concept sub-loop inserted between propose and approve.

## The 10 steps

Create the section folder `work/{surface}/sections/{section}/` and write each artifact as you go.

**1. Baseline + inputs.** Read before doing anything:
- The surface's approved copy (the copy-factory Web Copy Master / workbench full-page — never the stale handoff packet).
- `work/{surface}/figma-build-brief.md` — the page-level reference (authoritative for goals, brand constraints, positioning hazards, and approved decisions; its section order and components are the current approved snapshot).
- The relevant brand-book chapters via `10_brand-system/` pointers (colour, typography, graphic elements, imagery — whichever the section touches).
- `20_criteria/positioning-hazards.md` — the six hazards.
- `30_reference-lenses/apple-blackstone-lens.md` — the Apple × Blackstone reference lens, applied when shaping directions (Step 4). Advisory and subordinate — it never overrides the brand book, mandate, or hazards.
- Any existing record for this section (`work/{surface}/sections/{section}.md` flat file, or `.../{section}/selected-direction.md`).
- The operator's current section render, saved as `work/{surface}/sections/{section}/baseline.png`. If absent, ask the operator to drop it in before proceeding — the Nano Banana prompts reference it.

**2. Page-context scan (Step 0).** Run `§ Section Design Sessions` Step 0 against `figma-build-brief.md`: name (a) what must repeat for coherence, (b) which compositions/devices must NOT repeat here, (c) this section's narrative role + intended energy in the page rhythm, (d) any cross-page duplication. Write → `context-scan.md`. This is a per-run working note derived fresh from the build brief — **not** a maintained page-map alongside it (the build brief is the single page-level reference).

**3. Diagnose.** State the section's purpose, what already works, and the specific problem to solve. Write → `diagnosis.md`.

**4. Directions.** Produce 2–3 genuinely distinct directions (not variations of one). Each: a short concept description (layout, hierarchy, emphasis, mood), a rough ASCII wireframe, the Step 0 clearance (which repeats it honours, which it avoids, its role/energy), its **mobile transform** (the actual reshape, not "columns stack"), and any **motion** (only where it aids comprehension). Apply the Apple × Blackstone lens (`30_reference-lenses/apple-blackstone-lens.md`) as steering — reach for confident scale (Apple) and institutional weight (Blackstone), always within the brand grammar and the six hazards. Reject any direction that is strong in isolation but repeats a composition/device already on the page or breaks a cross-page constant. Write → `option-a-concept.md`, `option-b-concept.md`, `option-c-concept.md`.

**5. Nano Banana prompts.** For each direction, write one prompt using the **6-part structure** below, referencing `baseline.png`. Write → `option-{a,b,c}-nano-banana-prompt.md`.

**6. PAUSE — operator renders.** Tell the operator to run each prompt in Nano Banana and save the outputs as `option-a.png`, `option-b.png`, `option-c.png` in the section folder. Wait. Do not proceed until the images exist.

**7. Review the images.** Read each PNG. Critique each against the **image-review criteria** below. Write → `comparison.md`.

**8. Present + wait.** Present the comparison and a single recommendation. Wait for the operator's selection. Do not pick for them.

**9. Record the winner.** Write `selected-direction.md` — the canonical section record. **Extract the concept, not the pixels:** translate the selected image into composition rules, typography relationships, spacing intentions, the visual-device description, elements to preserve, and elements to ignore. Note what must stay locked next iteration (copy verbatim, red budget, type scale, no new components).

**10. Claude Design prompt.** Write the paste-ready Claude Design prompt for the selected direction — specific enough to guide a targeted revision, not a full-page redesign. This is the command's terminal output.

## The 6-part Nano Banana prompt structure (Step 5)

Every Nano Banana prompt has these six parts, in order:

1. **Reference context** — "Use the attached Axcíon {section} as the base. Preserve its dimensions, general grid, approved copy, typography character, {the locked palette}, and restrained use of red." (References `baseline.png`.)
2. **Specific problem** — the one thing this exploration is fixing (from `diagnosis.md`).
3. **Selected direction** — the single concept this prompt explores (from the option's concept file). One direction per prompt — never several in one image.
4. **Locked elements** — the exact headline/body/CTA copy; do not redesign surrounding sections; do not introduce new colours or a new visual identity.
5. **Visual instructions** — the concrete composition, alignment, type scale, negative space, CTA treatment, and wordmark placement for this direction.
6. **Prohibitions** — no SaaS cards, gradients, glass effects, dashboards, decorative finance graphics, stock-market imagery, rounded containers, excessive red, or centred landing-page composition — plus any section-specific positioning-hazard tell to avoid.

Output requirement: **one image per direction at approximately the section's real dimensions.** Never ask Nano Banana for a comparison board of several tiny versions.

**Iteration (conversational edit).** To refine a good option, do NOT regenerate — instruct an edit on the existing output: "Keep the current composition unchanged. {one precise change}. Do not change the headline, button, colours, or overall composition."

## Image-review criteria (Step 7)

For each returned PNG, assess:
- Did it actually follow the concept?
- Did it preserve the Axcíon brand (palette, type character, restraint)?
- Does it duplicate a composition/device already used elsewhere on this page (page-rhythm check)?
- Is it more striking — for the right reasons, not novelty?
- Is it likely to work responsively?
- Does it rely on details that would be hard to reproduce in Claude Design / the real build?
- Is it actually better than the current version?

A direction can be visually impressive and still be the wrong answer — if it repeats a prior section, duplicates the page's strongest idea in the wrong place, or introduces a third visual language. Say so plainly.

## Important limitation

Treat Nano Banana outputs as **directional concept frames, not design specs.** Image models alter copy, approximate typography, shift spacing, invent off-system details, and produce attractive-but-unbuildable layouts. Always extract the concept and translate it (Step 9) — never ask Claude Design to copy an image pixel-for-pixel.

## When to use / when to skip

**Use** `/explore-section` when: choosing between genuinely different compositions; a section is competent but generic; you need to see how a visual idea looks; the section carries imagery or a custom graphic; text wireframes aren't enough to decide.

**Skip it** (go straight to a narrow Claude Design edit) when: the change is only spacing/typography refinement; the direction is already approved; the fix is a narrow Claude Design edit; you're fixing stale copy; you're making a minor mobile adjustment.

## Artifact folder

`work/{surface}/sections/{section}/`:

```
baseline.png                       # operator-supplied current render
context-scan.md                    # Step 0 scan (per-run working note)
diagnosis.md
option-{a,b,c}-concept.md
option-{a,b,c}-nano-banana-prompt.md
option-{a,b,c}.png                 # operator-rendered
comparison.md
selected-direction.md              # canonical section record
```

For sections run through this command, `selected-direction.md` is the **authoritative** section record. If the section already had a flat `sections/{section}.md` record, mark that flat file superseded — add a top line `> Superseded by sections/{section}/selected-direction.md ({date})` — so there are never two live records for one section. Flat records for sections *not* run through this command stay valid as-is; do not migrate them.

## Chain-fit guardrail

Directions must stay within the page's `figma-build-brief.md` (its Tier-1 goals, brand constraints, positioning hazards, and approved section decisions) and the locked design system — the same rule as `§ Section Design Sessions`. A **Tier-1 departure** (a brand rule, positioning hazard, copy authority, or an approved section decision) must be surfaced and routed back through the Studio critics → QC before use; ordinary layout exploration within the Tier-1 constraints (a different sequence, a split section, a component the website repo would add) is normal work and a handoff note, not a gated departure. This command adds no new critic pass and no new terminal output; it stops at the Claude Design prompt.
