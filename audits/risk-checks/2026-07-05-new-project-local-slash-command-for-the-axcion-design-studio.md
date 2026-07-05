# Risk Check — 2026-07-05

## Change
New project-local slash command for the Axcíon Design Studio: /explore-section — takes one page section through Nano Banana visual-concept exploration before the Claude Design prompt is crafted. Operator explicitly directed building the command (not a lean capability-only version) because Nano Banana will be used heavily across this project's sections and pages — a confirmed repeated consumer. Change set (3 items; a planned shared-manifest.json edit was DROPPED after discovering this project has NO shared-manifest.json and uses 88 real command files with zero symlinks — the auto-sync hook only walks projects that HAVE a manifest, so a new real command file here is automatically project-local with no distribution machinery to edit or clobber it):

(1) NEW projects/axcion-design-studio/.claude/commands/explore-section.md — project-local command, model: opus frontmatter. 10 steps: (1) resolve section+surface, read approved copy + brand-book chapters + positioning-hazards + the page's figma-build-brief.md, save the operator's section crop as baseline.png; (2) run the just-committed CLAUDE.md "Step 0 page-context scan" AGAINST the build brief (NOT build a separate pattern inventory — a separate inventory file was deliberately rejected earlier this session by risk-check + system-owner second opinion), output context-scan.md as a per-run working note (derived fresh each run, not a maintained authority); (3) diagnose current section -> diagnosis.md; (4) produce 2-3 distinct directions cleared against the Step 0 checks -> option-{a,b,c}-concept.md; (5) one 6-part Nano Banana prompt per direction referencing baseline.png -> option-{a,b,c}-nano-banana-prompt.md; (6) PAUSE — operator renders prompts in Nano Banana (an external Google tool the repo CANNOT call), saves option-{a,b,c}.png into the folder; (7) repo READS the PNGs (the Read tool renders images) and critiques each against inline review criteria -> comparison.md; (8) present comparison + recommendation, wait for operator selection; (9) record winner -> selected-direction.md translated into composition/type/spacing/visual-device rules + preserve/ignore ("extract the concept, not the pixels"); (10) write the paste-ready Claude Design prompt. The 6-part Nano Banana prompt template, the image-review criteria, and the concept-not-pixels rule live INLINE in the command file.

(2) NEW per-section artifact-folder convention: work/{surface}/sections/{section}/ (baseline.png, context-scan.md, diagnosis.md, option-*-concept.md, option-*-nano-banana-prompt.md, option-*.png, comparison.md, selected-direction.md). This changes the section-record convention from the current flat single file work/{surface}/sections/{section}.md. Existing flat records (work/homepage/sections/hero.md, how-we-help.md, who-we-serve.md, why-it-works.md) are NOT migrated and stay valid; selected-direction.md inside the folder is the new canonical section record for explored sections. NOTE for blast-radius: check whether any command/agent/skill globs or reads work/{surface}/sections/{section}.md as a flat file and would be confused by a folder of the same section name.

(3) EDIT protected projects/axcion-design-studio/CLAUDE.md — "Section Design Sessions" section: one lean line noting section work runs via /explore-section, which inserts a Nano Banana visual-concept step between propose (Step 1) and approve (Step 2), and that explored sections use the folder convention. Builds directly on the Step 0 page-context scan committed earlier this session (commit 481810e).

Cross-model note: respects the workspace Cross-Model Rules — Claude generates the Nano Banana PROMPTS and reviews the returned images; it does NOT generate images or call any Google API (no new external capability/permission). No hooks, no settings/permission changes. The command is advisory/generative doctrine; its terminal output stays a Claude Design prompt, upstream of the Figma build brief — the Studio's non-negotiable sequence and terminal boundary are unchanged.

## Referenced files
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/commands/explore-section.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/homepage/figma-build-brief.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/work/homepage/sections/why-it-works.md — exists

## Verdict
GO
**Summary:** A pay-as-used, project-local, no-new-capability command that breaks no consumer and clears every principle check; the single Medium is a doctrine-internal mixed-convention wrinkle (Step 3's flat path vs. the new folder record) to reconcile in the item-(3) edit before landing.

## Consumer Inventory
Terms grepped across `ai-resources/` and workspace root (`grep -rniI --exclude-dir=.git`): `explore-section`, `Section Design Session`, `nano.banana`, `baseline.png`, `sections/`, `figma-build-brief`, plus the flat-file path and the folder convention. `explore-section` → zero existing hits (net-new contract). `baseline.png` → zero hits (net-new artifact name). `nano.banana` in the design-studio project → zero hits (all hits are in the *brand-book* project's asset pipeline + one audit note stating it "appears nowhere in the actual toolchain" — this command is the first design-studio wiring). No consumer parses/globs the sections directory.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-design-studio/CLAUDE.md (Section Design Sessions block, lines 34–42) | co-edits (item 3 edits it; hosts Step 0 scan the command depends on) | Yes (intended edit target) |
| projects/axcion-design-studio/.claude/commands/ (88 files, 0 symlinks) | new-file home | N/A (new file) |
| work/homepage/sections/{hero,how-we-help,who-we-serve,why-it-works}.md | documents (reference the protocol in prose; flat records, not migrated) | No |
| projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md + .agents/skills/ copy | documents figma-build-brief; "sections" refs are VDS doc-structure, NOT the directory | No |
| projects/axcion-design-studio/.claude/agents/layout-architect.md | documents figma-build-brief + page rhythm; does NOT glob the sections directory | No |
| ai-resources/.claude/hooks/auto-sync-shared.sh | distribution hook — bails at line 29 without a manifest; never touches design-studio commands | No |
| pipeline/*.md (architecture, project-plan, technical-spec, create-skill-brief, …) | documents figma-build-brief | No |
| logs/{session-plan,session-notes,decisions,scratchpads} | documents flat sections/ paths in historical records | No |

Total: 8 consumer classes found, 1 must-change (the item-(3) CLAUDE.md edit target itself). No machine consumer globs or parses `work/{surface}/sections/{section}.md` as a flat file — effectively an isolated additive change with one intended doctrine edit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low
- The command file is **project-local and pay-as-used** — loaded only when `/explore-section` is invoked, never standing. The inline template/criteria/concept-not-pixels rules add no per-turn cost. The change description's pay-as-used claim is correct per the standing-vs-invoked model.
- The only always-loaded cost is item (3): "one lean line" in the Section Design Sessions block of the always-loaded project `CLAUDE.md`. One pointer line ≈ 20–40 tokens/turn — below the rubric's Medium band (~50–150).
- Contrast anchor: the prior 2026-07-05 doctrine-layer risk-check flagged the Step 0 insert (~100–180 tokens, six sub-directives) as **Medium**. This change is deliberately a single pointer line pointing *at* the command, so **Low** — the heavy methodology lives in the pay-as-used command file, not in CLAUDE.md (aligns with workspace `CLAUDE.md § CLAUDE.md Scoping`: methodology out of always-loaded CLAUDE.md).
- Per-run working files (context-scan.md, diagnosis.md, option-*, comparison.md, selected-direction.md) are written to disk under `work/`, not loaded every turn — no standing cost.

### Dimension 2: Permissions Surface
**Risk:** Low
- No settings/permission changes. Verified: no deny rules on `work/` or `sections/` in the project `settings.json`/`settings.local.json`; the change states no hooks/settings edits.
- **No new external capability.** Claude generates Nano Banana **prompts** (text files) and **reads** the returned PNGs via the Read tool (which already renders images). It does **not** call any Google API — the operator renders externally (Step 6 pause) and saves the PNGs back. Operator-in-the-loop, no new tool/API/capability surface.
- Reading a PNG is an existing Read-tool capability (the brand-book project already produces nano-banana prompt files); no widening.

### Dimension 3: Blast Radius
**Risk:** Low
- Files touched: 1 new command file + 1 CLAUDE.md line + a new run-time folder convention.
- Consumers found: 8 classes, **0 hard must-change** beyond the intended CLAUDE.md edit (see inventory).
- **Critical flat-file-vs-folder check — clears.** No skill, agent, command, or hook globs or parses `work/{surface}/sections/{section}.md` as a flat file. Every `sections/` hit is prose documentation (CLAUDE.md:39 doctrine line, session logs, pipeline docs); the `layout-architect.md`/`SKILL.md` "sections" hits are about **VDS document sections**, not the directory. A same-named section folder therefore breaks no parser.
- The four existing flat records are not migrated and stay valid. Filesystem allows `why-it-works.md` (flat) and a `why-it-works/` folder to coexist — different names, no collision.
- Residual: if a section already recorded as a flat file is later *re-explored*, both `{section}.md` and `{section}/` would coexist — inert but ambiguous to a human reader (readability wrinkle, not a break). Carried to D5.

### Dimension 4: Reversibility
**Risk:** Low
- Clean `git revert` removes the new command file **and** the CLAUDE.md line — both tracked.
- Per-section folders + PNGs + working notes are created at **run time** (inert output artifacts under `work/`, no downstream consumer). Reverting the doctrine after runs leaves orphaned per-section folders — a **revert + optional manual cleanup**, same shape the prior doctrine-layer risk-check noted for `pattern-inventory.md`. Because the artifacts have no consumer, cleanup is optional, not required for correctness.
- No schema or cross-tool contract is changed irreversibly.

### Dimension 5: Hidden Coupling
**Risk:** Medium
- **(1) Mixed section-record convention — doctrine-internal contradiction (top concern).** Step 3 of the current Section Design Sessions block (`CLAUDE.md:39`) states the approved direction is written to the **flat** `work/{surface}/sections/{section}.md`. Item (3) introduces the **folder** convention with `selected-direction.md` as the canonical record for explored sections. If item (3) adds the folder line but leaves Step 3's flat-path sentence untouched, the doctrine will name two different record locations for the same step. The edit must reconcile them — e.g. update Step 3 to "explored sections use the folder; `selected-direction.md` is the record; legacy flat records remain valid" — or the protocol self-contradicts. This is a documentation defect, not a code break, but it is the reason this dimension is Medium.
- **(2) Dependence on the just-committed Step 0 page-context scan.** The command's Steps 2 and 4 invoke the Step 0 checks by reference. **Verified present** at `CLAUDE.md:36` — the dependency is satisfiable, not a forward-reference. Watch: Step 0 doctrine ends "do not maintain a separate page-map artifact alongside it," and the command's Step 2 emits `context-scan.md`. The design threads this by framing `context-scan.md` as a per-run, **derived-fresh working note (not a maintained authority)** — compatible in intent (the doctrine forbids a *maintained* parallel authority). Keep that "derived fresh each run, not maintained" framing explicit in the command body so the two never drift into a maintained parallel page-map.
- **(3) External Nano Banana dependency = operator-in-the-loop pause.** Step 6 hard-pauses for out-of-band rendering; Step 7 silently relies on the operator having saved the PNGs and on Read rendering them. Both couplings are inherent to the cross-model design and are **explicitly stated** (no hidden assumption). The command should degrade gracefully (re-prompt) if PNGs are absent at Step 7.

### Dimension 6: Principle Alignment
**Risk:** Low
- **Speculative abstraction / complexity budget (ai-resource-creation rule #7; OP-9 / AP-7 / DR-7) — CLEARS via prong (b).** A new command clears via net-simplification OR a confirmed repeated consumer / cited failure mode. The operator explicitly directs the full command because Nano Banana will be used **heavily across the project's sections and pages** — a confirmed, repeated, operator-directed consumer, with a queued second page (`work/for-investors/`) already in the Studio. Honest caveat: `nano-banana` currently "appears nowhere in the actual [design-studio] toolchain" (`audits/working/2026-07-05-idea-ai-web-design-operating-principles.md:25`), so this is the **first** wiring — the repeated-consumer basis rests on operator intent + adjacent brand-book precedent, not yet in-repo usage history. Alignment holds: prong (b) is operator-directed confirmed consumer, not build-ahead-of-use.
- **System boundary / cross-tool coordination (OP-10) — CLEARS.** The command orchestrates a workflow that uses an external Google tool but stays in bounds: it **generates prompts** and **reviews returned images** (operator-in-the-loop, no API call). Terminal output remains a Claude Design prompt, upstream of `figma-build-brief.md` — the Studio's terminal boundary is unchanged. Respects the workspace Cross-Model Rules (Claude does not substitute its own work for the assigned tool; it does not generate the image).
- **Advisory vs enforcement (OP-5) — CLEARS.** Advisory/generative doctrine; blocks nothing, and its output is never a source of truth (Figma stays authority).
- **Closure before detection (OP-12) — CLEARS (with the D5-2 watch).** `context-scan.md` is derived-fresh, not a maintained authority that could silently go stale — consistent with the Step 0 "no separate page-map" rule as long as the command keeps it ephemeral.
- **Placement (DR-1 / DR-3) — CLEARS.** A design-studio-specific workflow command correctly lives in the project's `.claude/commands/`, not the shared ai-resources library (it is not a cross-project resource) — consistent with the 88 project-local commands already there.
- **Loud revision (OP-11) — CLEARS with D5-1 resolved.** The doctrine edit is a visible CLAUDE.md line; the only place a silent drift could hide is the mixed-convention wrinkle (D5-1) — surfacing it here is the loud-revision discharge.

## Evidence-Grounding Note
All risk levels grounded in direct evidence (grep counts, file reads, hook source lines 28–29, CLAUDE.md:36/39). No training-data fallback.
