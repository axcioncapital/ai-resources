---
name: research-prompt-creator
description: >
  Transform an Execution Manifest, Research Plan, and Answer Specs into a
  Research Execution Prompts document — per-session execution prompts, session
  plan table, and operational notes, primarily for Research GPT sessions.
  Perplexity sessions may appear in the manifest but use simpler prompt
  formats; CustomGPT sessions follow Research GPT patterns. Session groupings and tool assignments come
  from the Execution Manifest (produced by execution-manifest-creator); this
  skill writes the prompts, not the routing. Trigger when an Execution
  Manifest exists and the operator needs execution prompts, or on requests
  like "create research prompts" or "write prompts for these sessions." This
  is Step 2.1 in Stage 2 of the Axcion Research Workflow. Do NOT use for
  research plan creation (research-plan-creator), answer spec generation
  (answer-spec-generator), execution routing (execution-manifest-creator),
  evidence compression, or direct research execution — this skill produces
  prompts for the operator to paste into the assigned execution tool.
model: sonnet
effort: medium
---

# Research Prompt Creator

## Input Requirements

**Required:**
1. **Execution Manifest** — produced by `execution-manifest-creator`. Contains session groupings, tool assignments (Research GPT vs. Perplexity), dependencies, and parallel execution opportunities. Accept the manifest's routing and grouping decisions as given — do not re-cluster or re-route questions.
2. **Research Plan** — research questions with scope, key terms, source preferences, search terminology guidance
3. **Answer Specs** — per-question specifications defining required evidence components, evidence rules, and completion gates
4. **Source-class hierarchy** — `reference/source-class-hierarchy.md` (project-level). Declares the best-available source class per evidence type, the source-exhaustion ladder when best-class evidence is unavailable, and named-source paths. Consumed by Step 2b element 4a (per-directive source-class targeting). If the file is absent, halt — prompts cannot meet the source-class targeting requirement without it.

All provided by the operator. Do not generate these.

**If inputs are incomplete:** Flag missing elements. Proceed with `[inferred]` defaults only for non-critical gaps (e.g., missing source preferences). Halt for critical gaps (missing Execution Manifest, missing scope parameters, missing questions).

**Question-spec mismatch:** If the Execution Manifest references questions not found in the Answer Specs (or vice versa), flag as `[MISMATCH]`, list orphaned items, and ask whether to proceed with the matched subset or halt.

**Information boundary:** Accept session groupings, dependencies, and tool assignments from the Execution Manifest without modification. Base prompt construction decisions (priority allocation, depth signals, format choices) on the provided inputs. Domain knowledge is acceptable for search term selection, keyword seeding, and steering note context — these benefit from the model knowing the field.

## Platform Context

Research GPT (GPT-5.2-based) has characteristics that constrain prompt design:

- **No clarification step** — research starts immediately from the prompt. Prompt quality is the single biggest lever on output quality.
- **Keyword-driven search** — the model uses keywords from the prompt as search seeds. Embed domain-specific terms, proper nouns, and technical terminology explicitly.
- **Session capacity** — overloaded prompts produce shallow coverage on later questions. Session groupings come from the Execution Manifest; focus on writing prompts that work well within the given session sizes.
- **Structured output** — tables, headers, and format instructions are well-followed. Leverage this.
- **Context pack** — a compact, section-level project summary embedded in each execution prompt for orientation. Identical across all sessions in a section. Contains only universal context: project background, one-line section objective, analytical framework, scope reference. No hypotheses, no content map areas, no prior findings from other sections — those belong in the session intro paragraph (the free text between the context pack and the first directive), where they are naturally session-specific. This separation prevents attention dilution: the context pack orients, the session intro focuses.
- **Finite search budget** — execution tools have a limited number of searches per question or session. Generic seeds burn budget on shallow results, leaving nothing for harder components. Prompt design must account for this: prioritize high-specificity seeds for difficult components, and keep broad seeds to a minimum for well-documented topics.
- **Site restrictions** — the operator can restrict or prioritize specific sites per session via the ChatGPT UI.

## Planning Protocol

Before producing the full document, present:

1. **Session summary** — confirm the sessions from the Execution Manifest (questions, tool assignments, dependencies)
2. **Prompt strategy** — key decisions about prompt construction (epistemic framing, depth allocation, format choices)
3. **Key assumptions** — any inferences about priority or emphasis
4. **Flags** — ambiguities, conflicts, or gaps found in the inputs

Proceed to full document only after the operator confirms the plan.

## Workflow

### Step 1: Analyze Inputs

Read the Execution Manifest, Research Plan, and Answer Specs. Extract:

- Session groupings, tool assignments, and dependencies from the Execution Manifest
- All research questions with their IDs
- Scope parameters (geography, deal size range, fund size range, time frame, industry focus)
- Per-question evidence components and completion gates
- Source preferences and search terminology guidance

### Step 2: Construct Per-Session Prompts

Use the session groupings, tool assignments, and dependency ordering from the Execution Manifest. Do not re-cluster or re-route questions.

For each session, produce:

**2a. Session Header**
- Session letter (A, B, C...)
- Questions included (by ID and short title)
- Site restriction guidance (mode, sites, rationale) — or "Default (full web search)"
- Recency preference (e.g., "Prefer sources from 2023–present" or "No recency constraint")

**2b. Execution Prompt** (in a code fence — literal text for the operator to paste)

The prompt must be self-contained. It includes the following elements, in order:

**Always present:**
1. **Evidence-First preamble** — a short verbatim preamble citing the project's Evidence-First Principle (from `reference/quality-standards.md` § Evidence-First Principle). Use this exact text:

   > Per the Evidence-First Principle: find the strongest available evidence class. Do not synthesize a plausible answer if direct evidence is unavailable; return a labeled gap instead. Do not compensate for weak evidence with stronger prose.

   This preamble is project-level boilerplate, not per-question custom text. It sits at the very top of the prompt — above the Scope block and above all directives — so the model encounters the precedence rule before any question framing.
2. **Scope block** — a clearly labeled standalone block with all scope parameters as literal values (geography, deal size, fund size, time frame, industry focus). Placed below the Evidence-First preamble so the model references it throughout.
3. **Context pack block** — a compact, section-level orientation block, delimited by `--- CONTEXT PACK ---` / `--- END CONTEXT PACK ---` markers. Placed after the scope block, before the session intro. **Identical across all sessions in the section.** Contains four lines only: (1) project background, (2) one-line section objective (what the section maps, not what individual sessions investigate), (3) analytical framework, (4) scope reference. Do not include hypotheses, content map areas, prior findings from other sections, or session-specific framing — those belong in the **session intro paragraph** (free text between the context pack and the first directive). Do not duplicate scope parameters — include a one-line reference to the standalone scope block. The scope block is authoritative for all scope values.
4. **Per-question research directives** — translated from Answer Spec components into plain-language directives. Each directive header must include the Answer Spec component ID so downstream tools (research-extract-creator) can match outputs to specs. Format: `Directive 1 (Q1-A01) — [Short title]`. Load `references/prompt-construction-guide.md` for translation patterns, output format templates, and depth signal language. If this file is unavailable, use the translation principles and format templates described in the prompt construction rules below.
4a. **Source-class targeting block (per directive)** — directly under each directive header (and above the directive body), name the target source class and order the fallback chain, drawn from the project's `reference/source-class-hierarchy.md`. Format: a single `Target source class:` line listing the best class, followed by `Fallback chain:` listing the fallback class(es) and, where applicable, the relevant source-exhaustion ladder by name (e.g., "transactions ladder, descend to step 6 max before flagging gap"). The directive body may then proceed with the research instruction.

   Two hard rules apply:
   - A directive may **not** target only advisory aggregators (KPMG, EY, PwC, Clearwater-style commentary) when a higher source class exists in the hierarchy for the evidence type in question. Use the hierarchy table to identify the best class; advisory may appear only as fallback.
   - Where the project's hierarchy file declares ladder-depth downgrade thresholds (e.g., transactions-step-7+ → automatic claim-strength downgrade), the directive's sufficiency threshold must be set above the downgrade boundary (i.e., stop descending the ladder before the auto-downgrade triggers, or state explicitly that downgraded evidence is acceptable for this directive).

**Conditional:**
5. **Epistemic frame** — include when multiple directives share a research stance (e.g., "Focus on how this works in practice, not idealized models"). Set once as a session-level framing sentence; do not restate per directive. Omit when directives have no shared epistemic orientation.
6. **Output format instructions** — include for structured/quantitative directives (prescribe tables, columns). Omit for analytical/qualitative directives — state the deliverable and let the model choose format.
7. **Depth/priority signals** — include when questions within a session have unequal importance. Use operative effort signals (directive ordering, minimum search allocations) and sufficiency thresholds. Omit when all directives in a session have equal weight.
8. **Disconfirming-evidence reporting (additive — fix-spec #22, no-reader as of landing)** — instruct the execution tool to report, at session/report level, any **disconfirming evidence found** while researching the session's directives — evidence that contradicts, weakens, or counters the expected or most-likely answer (e.g., a trend that is cyclical rather than structural, a gap already solved by incumbents, an opportunity that is not commercially material). This is a single report-level output field — `Disconfirming evidence found` — not a per-directive field. The **empty-with-reason allowance** applies: the field may be empty if accompanied by a stated reason (e.g., "no disconfirming evidence found after 3 targeted searches"). Include this element when the session carries analytical or load-bearing directives; omit for purely descriptive inventory sessions. **This field is currently additive with no downstream consumer** (status as of 2026-06-08 landing; re-check when fix-spec #4 lands) — it is emitted for capture by `research-extract-creator` but is not yet read by any gate, verifier, or sufficiency/stop-condition check; its consumer (the Tier-A counter-search, fix-spec #4) is deferred. Do NOT make session completion contingent on this field, and do NOT add it to any stop-condition or sufficiency gate.

**Prompt construction rules:**

Rules are grouped by priority. Structural decisions shape the prompt architecture — if these are wrong, good writing won't compensate. Strategic choices govern research depth and focus. Writing craft ensures clarity and concision.

*Structural decisions (highest priority):*
- **Component ID labeling:** Every directive header must carry the Answer Spec component ID in parentheses — e.g., `Directive 1 (Q1-A01) — Activity inventory`. This is a hard requirement: `research-extract-creator` matches research outputs to Answer Spec components by these IDs. If a single directive covers multiple components, list all IDs: `Directive 3 (Q2-A01, Q2-A02)`. If the Answer Specs do not use the `Q[n]-A##` convention, preserve whatever ID scheme they use.
- **Source-class targeting per directive (no advisory-as-primary):** Each directive carries an explicit `Target source class:` line and `Fallback chain:` line drawn from `reference/source-class-hierarchy.md`. The directive may not target advisory aggregators as the primary class when a higher class exists in the hierarchy for the evidence type. This is a hard requirement and the highest-leverage governance lever in Stage 2: a prompt that names an advisory class as primary will produce advisory-anchored evidence that no downstream stage can recover from. See Step 2b element 4a for the literal block shape.
- **Required dimension preservation:** When an Answer Spec component description includes a `**Segment by:** [dimension] (Required)` marker, the corresponding directive must include that dimension as an explicit research instruction — e.g., "Break down findings by fund size. If no evidence exists for a specific segment, state that explicitly rather than omitting it." Do not drop Required dimensions into generic "explore variation" language. Optional dimensions may be mentioned as stretch goals ("if data permits, also segment by geographic sub-region").
- **Scope block separation:** Pull scope parameters (geography, deal size, fund size, time frame, industry focus) into a clearly labeled standalone block at the top of the execution prompt, separate from the research directives. Directives reference the scope block rather than re-embedding parameters inline. Clean separation means the same scope block can be reused across sessions without rewriting.
- **Format prescription — match to directive type:** Prescribe specific output format (tables, column names) for structured/quantitative directives where the value is in the data shape. For analytical or qualitative directives (pattern analysis, narrative synthesis, value judgments), state the deliverable clearly but let the model choose the best format. Over-prescribing format on qualitative work forces the model to fit insights into structures that may not serve them.
- **Epistemic frame — set once, not per-directive:** If multiple directives share a research stance (e.g., "how this actually works in practice, not idealized models"), state it once as a session-level framing sentence near the top of the prompt. Per-directive restatements waste tokens and dilute the signal.

*Strategic choices (research quality):*
- **Claim anchoring:** When the inputs contain specific claims, figures, or benchmarks (e.g., a reported ratio, a percentage from an industry source), embed them in the directive as concrete anchors to validate. This focuses the model on targeted research against a specific claim rather than open-ended exploration. Extract validatable claims from the Research Plan, Answer Specs, or operator briefing and embed at least one per directive where available.
- **Sufficiency signals:** For each directive, include a brief threshold that tells the model when to stop digging and report what it has. Example: "If fewer than 3 independent sources exist for this topic, report what is available and characterize the evidence gap rather than continuing to search." Without these, the model cannot make good trade-offs when directives compete for attention within a session.
- **Volume calibration from Expected Claims:** Each Answer Spec component includes an Expected Claims range (e.g., 3–5, 5–10). Use these ranges to calibrate how much evidence each directive asks for — preventing flat, one-size-fits-all depth signals that let easy components absorb all the search budget. Translation by component type:
  - **Inventory/catalog** (high range, e.g., 5–10): Use comprehensive-coverage language ("Identify all distinct [items]"). Set the sufficiency threshold at the lower bound ("if fewer than 5 distinct items surface, report what exists and characterize the gap").
  - **Mechanics/process** (mid range, e.g., 3–6): Use step-coverage language ("Trace the main [steps/mechanisms]"). A sufficiency note at the lower bound is optional.
  - **Comparison/difference** (mid range, e.g., 3–5): Use focus language ("Identify the key [differences/axes]").
  - **Analytical/evaluative** (low range, e.g., 2–4): Use depth-over-volume language ("Analyze in depth — 2–3 well-supported findings are more valuable than 5 shallow ones"). Do not push for volume.
  - **Boundary/edge case** (low range, e.g., 0–3): Flag that thin evidence is expected ("Report what exists — do not force volume").
  Do not state the Expected Claims range itself in the prompt (e.g., "5–10 claims expected") — the execution tool doesn't count claims. Instead, translate the lower bound into a sufficiency threshold and the upper bound into an implicit effort ceiling, using natural-language calibration that shapes search behavior. See `references/prompt-construction-guide.md` for volume calibration templates.
- **Depth/priority signals:** When questions within a session have unequal importance, effort signals must be operative, not just descriptive. Percentage allocations alone (e.g., "allocate ~60%") don't translate into search behavior — the execution tool front-loads effort on the first components it encounters and runs out of budget for later ones. Two mechanisms make effort signals operative: (1) order directives so the hardest or most important components appear first in the prompt, and (2) specify minimum dedicated searches per component (e.g., "Allocate at least 2 dedicated searches to Directive 3 regardless of results on earlier directives"). See `references/prompt-construction-guide.md` for operative allocation templates.
- **Per-component source quality floors:** Aggregate source targets (e.g., "≥10 sources per session") let the execution tool meet the target by stacking good sources on easy components while using a single low-quality source for critical ones. Set a per-component minimum in the prompt: no component's findings may rest on fewer than 2 independent sources. If a component has only 1 source after dedicated searching, the execution tool must classify it as thin and document the gap. When the Answer Spec sets `min_high_sources` ≥ 3, add a source authority emphasis to the prompt: "Prioritize authoritative primary sources (industry associations, regulatory bodies, large-sample surveys, peer-reviewed research) over secondary commentary." This prevents the execution tool from meeting count thresholds entirely with medium-quality secondary sources. See `references/prompt-construction-guide.md` for embedding templates.
- **Search seed tiering:** Seeds must match the difficulty of the question, not just the topic. Easy questions (well-documented topics, established frameworks) need broad topical seeds. Hard questions — those probing practitioner behavior, tacit knowledge, or operational detail — need narrow, high-specificity seeds targeting the source types where that evidence actually lives (practitioner surveys, GP letters, operational benchmarks). Include two tiers of seeds: broad seeds for topic coverage, and a second tier of narrow seeds explicitly labeled for the harder components. When the scope includes a geographic region, seeds must cover all constituent countries or markets, not just the most prominent ones. Use concrete source paths ("search for 'ILPA due diligence guidelines'"), not just institution names ("ILPA"). See `references/prompt-construction-guide.md` for seed tiering templates.
- **Proxy hierarchies for known data gaps:** When the scope includes specificity constraints likely to produce data gaps (niche geography, narrow market segment, recent phenomenon), include a prioritized proxy fallback chain in the prompt. The chain tells the execution tool what approximation to use and in what order when exact-match data is unavailable, and requires it to state which proxy level was used. Without explicit fallback instructions, the execution tool either returns nothing or silently approximates without flagging the substitution. Derive proxy hierarchies from the Research Plan's scope parameters and source preferences. See `references/prompt-construction-guide.md` for proxy chain templates.
- **Paywall fast-lane scarcity audit (#5 — for `public-gated` needs):** When the execution manifest's source-plan table classifies a need `public-gated`, the prompt must NOT commission a full deep search by default. The route is set by the need's risk tier — read the `Tier {A|B|C|D}` marker the manifest annotates in the `paywall risk` cell (e.g. `public-gated → Tier B fast-lane`), which the manifest derived from `reference/quality-standards.md § Risk-Tier Model` control-matrix row "Paywall fast-lane (#5)". *(This is the risk tier, distinct from the S-13 "research stop conditions" — same words, different concept.)*
  - **Tier A gated → full deep session.** A Tier-A need is load-bearing enough to earn the deep search despite the paywall — write the normal full-ladder prompt (the fast lane does NOT apply).
  - **Tier B / Tier C gated → bounded fast-lane audit.** Write the directive as a *scarcity audit*, not an open search: (1) run **5–8 public-proxy searches** (not the full ladder) — enough to confirm the public proxy surface is genuinely thin, not merely unsearched; (2) **check the project's #24 known-unavailable-evidence register** (`reference/known-limits.md § Known-Unavailable-Evidence Register`) — if the need matches a documented limit, the scarcity is already established, so stop early and cite the register row; (3) **classify the residual** as `Proprietary` (exists, paywalled), `Gated` (exists, partially public/lagged), or `Opaque` (may not exist at all); (4) **stop** — record the residual classification + any proxy evidence found + the permission ceiling. Do NOT continue to a deep session unless the operator explicitly overrides.
  - **Tier D gated → not pursued.** Record as not-pursued; no search directive.
  - **Tier unreadable → conservative default.** If the need is `public-gated` but no readable `Tier {A|B|C|D}` marker is present in the manifest, take the **bounded fast-lane audit** (the Tier-B/C route) and flag the inferred tier `[inferred]` in the directive — never silently default a gated need to a full deep session.
  - **#24 register graceful-absent:** if `reference/known-limits.md` (or its register section) is absent, skip step (2) — do not halt — and have the prompt note that the scarcity audit ran without a register anchor (best-effort, search-only).
  - The residual labels `Proprietary` / `Gated` / `Opaque` are a **distinct scarcity taxonomy** (public-obtainability), not a substitute for the claim-permission classes (SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED) that grade evidential strength downstream — the two axes coexist. This rule consumes the manifest's `paywall risk` classification (`execution-manifest-creator` § Paywall Classification & Source-Plan Table); it does not re-derive it.
- **In-lens / proxy-source declaration (S-02 — No-Source-Substitution Rule):** Every directive must explicitly declare its in-lens evidence target (the exact geography + deal-size band + sponsor tier the question is about) AND its proxy-source fallback path. The directive's wording must require the execution tool to return one of three outcomes per `reference/quality-standards.md § No-Source-Substitution Rule`:
  - (a) direct evidence found (claim tagged `IN-LENS`);
  - (b) proxy evidence found, clearly downgraded (claim tagged `PROXY-DOWNGRADE` and the proxy nature named explicitly — e.g., "above-lens deal used as illustration," "pan-Nordic aggregate cited for country-specific claim");
  - (c) no evidence found (claim tagged `NO-EVIDENCE`).
  The prompt must instruct the tool: *if no in-lens evidence is found, do not broaden the claim — broaden the source only and downgrade the conclusion.* When a substitution is made, the prompt must require the tool to name the substitution explicitly in its output (e.g., "evidence for Finland not found; substituted Nordic aggregate"). This is a hard requirement and directly couples to `research-extract-creator`'s tag-emission rule and `cluster-memo-refiner`'s Check 9.
- **Per-country search ordering (S-03 — Country-Parity Enforcement Gate):** For country-relevant directives (those targeting evidence about Sweden, Norway, and/or Finland specifically), the prompt must specify per-country search ordering: **Sweden block → Norway block → Finland block → pan-Nordic synthesis last, NOT first.** Pan-Nordic-first ordering biases the claim toward three-country framing before per-country evidence is known. The directive must list per-country source-class targets separately (e.g., "Sweden: SVCA + Bolagsverket; Norway: NVCA + Brønnøysund; Finland: FVCA + PRH; pan-Nordic synthesis: Invest Europe/EDC only AFTER per-country pass") so the execution tool surfaces per-country evidence before any pan-Nordic claim is constructed.
- **Local-language search blocks (S-04 — Mandatory Local-Language Search Pass):** For country-specific directives, the prompt must include a local-language search block alongside (not as fallback to) the English-language block. The local-language block runs in parallel with the English block, not as a fallback — English-only sessions over-represent large-cap deals; local-language coverage is the primary remediation for "non-English-market evidence thin because English-only." Per-language search-term sets are loaded from `reference/language-search-blocks.md` (project-fillable, instantiated from `ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md`); per-language iteration is driven by the Project Config `Languages:` field (see `docs/project-config-schema.md` field 5). The loader applies a **3-case absent-file contract** — do not collapse the cases into a single fallback:
  - (1) `Languages:` absent or `[]` → emit English-only directives, no warning. Correct posture for monolingual projects.
  - (2) `Languages:` populated AND `reference/language-search-blocks.md` absent → **HALT with a clear error** naming the declared `Languages:` codes. Do NOT fall back to English-only — silent fallback for a project that explicitly declared multi-language coverage degrades evidence integrity.
  - (3) `Languages:` populated AND `reference/language-search-blocks.md` present → iterate over every code in `Languages:`; emit the matching `## {{LANG_CODE}}` block from the file. HALT if `Languages:` declares a code with no matching block; emit a one-line warning and skip blocks present in the file but not declared in `Languages:` (Project Config wins).
- **Target stop condition declaration (S-13 — Research Stop Conditions):** Each session-level prompt declares which of the 4 stop conditions per `reference/quality-standards.md § Research Stop Conditions` is the target completion criterion for the session — e.g., "this session targets condition 1 (two high-quality direct sources answer the question)." This anchors the execution tool's sufficiency judgment. Sessions that exit before any of the 4 conditions is met are flagged by `research-extract-verifier` as incomplete and the affected claims auto-downgrade to NOT-SUPPORTED per the reciprocal rule. The 4 conditions are: (1) two high-quality direct sources answer the question; (2) one high-quality direct source plus three named examples support the pattern; (3) three source classes have been checked and no direct evidence exists; (4) local-language, primary-source, and advisory-source searches all fail. The prompt's stop-condition declaration is a session-level note (not per-directive) and goes in the Steering Notes section.

*Writing craft (clarity and concision):*
- Translate Answer Spec components into research directives — never use Answer Spec terminology ("evidence component," "completion gate") in the prompt
- Use imperative verbs: "Find," "Compare," "Present," "Trace," "Identify"
- **Omit what the model already does:** Do not include instructions the model would follow naturally from a well-scoped directive — e.g., "cross-reference for consistency," "cite sources," or generic quality reminders. **Test:** if a sub-bullet is unpacking what the main instruction already means, cut it.

**2c. Steering Notes** (operator guidance, not pasted into the research tool)
- Anticipate likely thin-results areas with alternative search angles
- Specify acceptance criteria for scarcity vs. when to push harder
- Flag cross-session implications — but only when operationally actionable (see rule below)
- See `references/prompt-construction-guide.md` for steering note templates. If unavailable, cover: likely thin-results areas with alternative search angles, acceptance criteria for scarcity, and cross-session implications.

**Cross-session reference rule:** Every cross-session reference in a steering note must be operationally actionable within the isolated execution context. Since GPT sessions run independently with no shared context, a reference to another session's findings is meaningless to the researcher. Two valid patterns:
1. **Dependency embedding** — the manifest declares a dependency (hard or soft), and the prompt embeds the relevant context or shared assumptions so the session can act on it independently. The steering note explains the relationship for the operator.
2. **Silent deferral** — the relationship is real but will be reconciled in the extract or cluster phase. No cross-session reference appears in the steering note. Reconciliation happens downstream without creating unactionable expectations in the prompt.

**Invalid pattern:** Advisory cross-session flags that note a relationship but defer action (e.g., "Q3's findings should be consistent with Session A's coverage gaps. Conflicts will be reconciled in the extract phase."). These create expectations that no participant can act on during execution — the researcher cannot see Session A's results, and the operator has no reconciliation mechanism at execution time. If the manifest classifies a relationship as "None," do not add a cross-session flag that contradicts that classification.

### Step 3: Assemble the Document

Produce a single markdown file with this structure:

```
# Research Execution Prompts — [Project Name]

## How to Use This Document
[Setup instructions, global settings]

## Session Plan
[Table: Session | Questions | Qs/Session | Cluster Logic | Dependencies]
[Parallel execution opportunities]

## Session [A]: [Descriptive Title]

### Settings
[Site restrictions, recency preferences]

### Execution Prompt
[Literal prompt text in code fence]

### Steering Notes
[Operator guidance]

## Session [B]: [Descriptive Title]
[Same structure]

...

## Post-Execution Notes
[Save instructions, cross-session review checklist, downstream flags]
```

See `references/prompt-construction-guide.md` for the Post-Execution Notes template. If unavailable, include: save naming convention, cross-session review checklist (contradictions, gap coverage, scope drift), and downstream flags for Research Plan assumption changes.

### Step 4: Run Self-Check

Before delivering the document, verify every item in the Self-Check list below. Fix any failures before presenting to the operator. If new conflicts or ambiguities emerge during prompt construction that were not flagged in the planning summary, pause and present them to the operator before continuing.

## Failure Behavior

- **Ambiguous Answer Spec component** — flag as `[AMBIGUITY]`, propose 1–2 interpretations, do not silently pick one
- **Unclear dependencies** — flag the uncertainty, propose conservative ordering (sequential over parallel), do not assume independence
- **Session count mismatch** — if the Execution Manifest contains more or fewer sessions than expected, flag it but proceed with what the manifest specifies
- **Scope conflict between Research Plan and Answer Specs** — flag as `[CONFLICT]` with both versions quoted, do not silently resolve
- **Missing source preferences** — generate defaults based on question domain, label as `[inferred]`
- **Missing reference file** (`references/prompt-construction-guide.md`) — proceed using the inline fallback guidance provided at each reference point in this skill. Do not halt.
- **Unknown execution tool** — if the Execution Manifest routes a session to a tool not covered by this skill's platform context, flag as `[UNSUPPORTED TOOL]`, produce a best-effort prompt using the Research GPT format, and note that the operator should review for platform compatibility.

If provided information is insufficient to make a confident decision, say so. It is acceptable to leave gaps and flag them rather than invent plausible-sounding defaults. If the operator's inputs contain an error or questionable assumption, flag it constructively.

## Self-Check

Before delivering, verify:

- Every session prompt begins with the Evidence-First preamble (verbatim text per Step 2b element 1), above the Scope block
- Every research question from the Execution Manifest appears in exactly one session prompt
- Session plan table matches the Execution Manifest's groupings and dependencies
- Parallel execution opportunities from the manifest are reflected in the document
- Every Answer Spec evidence component is translated into a research directive in at least one prompt
- Every directive header includes the Answer Spec component ID (e.g., `Q1-A01`) for downstream traceability
- Every directive carries a Source-class targeting block (`Target source class:` + `Fallback chain:`) drawn from `reference/source-class-hierarchy.md`; no directive names an advisory aggregator as primary when a higher class exists in the hierarchy
- No prompt uses Answer Spec terminology — all directives are in plain research language
- Each directive's sufficiency signal reflects the Answer Spec's Expected Claims range for that component (inventory components have higher volume language than analytical components)
- Every Required dimension from Answer Spec component descriptions (`**Segment by:** [dimension] (Required)`) appears as an explicit segmentation instruction in the corresponding directive
- Each prompt includes a per-component source quality floor instruction
- If any session's Answer Spec completion gates include `min_high_sources` ≥ 3, the corresponding prompt includes a source authority emphasis instruction after the source quality floor
- Each prompt has a labeled scope block with literal parameter values
- Each prompt includes the context pack block with `--- CONTEXT PACK ---` / `--- END CONTEXT PACK ---` delimiters, and the context pack does not duplicate scope parameters from the scope block
- The context pack is identical across all sessions and contains only universal orientation (project, section objective, framework, scope reference) — no hypotheses, prior findings, or content map areas
- Session-specific context (hypotheses, prior findings, category framing) appears in the session intro paragraph, not in the context pack
- Each session has specific steering notes (not generic)
- If scope parameters include known data gap risks, a proxy fallback chain is included in the prompt
- Every directive declares an explicit in-lens evidence target AND a proxy-source fallback path; the prompt requires the execution tool to return one of `IN-LENS` / `PROXY-DOWNGRADE` / `NO-EVIDENCE` per directive (S-02)
- For country-relevant directives: per-country search ordering is specified (Sweden → Norway → Finland → pan-Nordic synthesis last) with per-country source-class targets listed separately (S-03)
- For country-specific directives: local-language search blocks are included alongside the English-language block (not as fallback), iterated over the Project Config `Languages:` field with per-language term content loaded from `reference/language-search-blocks.md` per the 3-case absent-file contract (S-04). Self-check is N/A when `Languages:` is absent or `[]` (monolingual project); otherwise enforces a present block for every code in `Languages:`.
- Every session-level prompt declares a target stop condition (one of the 4 per `reference/quality-standards.md § Research Stop Conditions`) in the Steering Notes section (S-13)
- For any need the manifest classified `public-gated`: the directive matches the need's risk-tier route (#5) — Tier A → full deep search; Tier B/C → bounded scarcity audit (5–8 proxy searches + #24 register check + residual `Proprietary`/`Gated`/`Opaque` classification, then stop unless operator override); Tier D → not pursued; unreadable tier → bounded audit with `[inferred]` flag. A Tier-B/C gated directive does NOT commission an open-ended deep search, requires the residual to be recorded with one of the three scarcity labels, and — when the #24 register is absent — carries the best-effort/search-only note
- Site restriction guidance is included for every session (even if "Default")
- Post-execution notes section is present

## Output Protocol

**Default mode: Refinement**

Before producing the full document, present the planning summary defined in the Planning Protocol above (session summary, prompt strategy, key assumptions, flags). **Do not produce the full document until the operator approves the plan.** After approval, write the complete document to file.
