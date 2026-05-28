# Risk Check — 2026-05-28

## Change

FX-B2 — Extract Swedish/Finnish/Norwegian language-search blocks from ai-resources/skills/research-prompt-creator/SKILL.md lines 143–166 into (a) a new canonical fillable template at ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md, and (b) a new nordic-pe project instance at projects/nordic-pe-macro-landscape-H1-2026/reference/language-search-blocks.md. SKILL.md lines 143–166 become a loader stanza pointing to the per-project file. Pattern matches FX-B3/B5/B6 precedent (template + project instance with loader stanza in skill).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/language-search-blocks.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is structurally sound, mirrors a now-established multi-precedent pattern (FX-B3/B4/B5/B6), and removes hardcoded Nordic content from a canonical skill consumed by multiple projects — but blast radius is High (the skill is consumed by every research project plus its execution-manifest sibling, and the SKILL.md self-check at line 262 will reference the new file by path), and hidden coupling is High (the canonical skill becomes dependent on a per-project file that does NOT exist in buy-side-service-plan today; absent-file behavior must be defined explicitly to avoid a load-bearing silent fail). Both High dimensions have viable paired mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The skill SKILL.md is not always-loaded — `research-prompt-creator` activates only at Stage 2.1 of the research workflow (verified: SKILL.md line 13 — "This is Step 2.1 in Stage 2 of the Axcion Research Workflow"). No `@import` of this skill exists in any always-loaded surface (workspace CLAUDE.md, project CLAUDE.md, or workflow CLAUDE.md).
- Net token effect on the skill: lines 143–166 (~24 lines of operator-verbatim language blocks) are replaced by a much shorter loader stanza (~3–6 lines), so the skill SHRINKS, not grows. Token cost at skill-load time decreases.
- The new project-side file `reference/language-search-blocks.md` is read by the skill at runtime only when the skill activates. Pay-as-used.
- The new canonical `language-search-blocks.template.md` is a fillable template never loaded directly — projects instantiate it once, never consume the template itself. Zero ongoing token cost.
- No new hooks, no new auto-loaded skills, no broad-trigger skill-description widening (skill `description:` frontmatter unchanged, no new triggers).

### Dimension 2: Permissions Surface
**Risk:** Low

- The change is a markdown-edit + two new markdown-file creations inside already-tracked directories (`ai-resources/workflows/research-workflow/reference/` and `projects/nordic-pe-macro-landscape-H1-2026/reference/`). No `.claude/settings.json` or `.claude/settings.local.json` change required.
- No new tool invocation pattern (Bash command, Write path, external API). All writes target paths in already-authorized directories.
- No `allow` / `ask` / `deny` rule touched. No scope escalation (project → user → workspace). No MCP server enablement.

### Dimension 3: Blast Radius
**Risk:** High

**Direct file edits:** 3 (1 skill edit + 2 new file creations). Modest at the change site.

**Enumeration of canonical consumers of `research-prompt-creator` and the S-04 language-block contract (grep across `ai-resources/`):**

- `ai-resources/skills/research-prompt-creator/SKILL.md` — direct edit target. Lines 143–166 (S-04 block) + line 262 (Self-Check item naming Swedish/Finnish/Norwegian "as relevant"). Both must be updated coherently or the Self-Check fires against the loader stanza.
- `ai-resources/skills/execution-manifest-creator/SKILL.md` — lines 87–106 contain the S-04 Country-Specific Language-Block Routing table that names Sweden→Swedish, Norway→Norwegian, Finland→Finnish verbatim (per grep hit). Same project-content-baked-into-canonical anti-pattern. **FX-B2 leaves this companion file untouched** — fix-phase audit `04-generalization-fitness.md:274` (B-04) explicitly names it as a separate extraction item. Result: after FX-B2 lands, S-04 is half-extracted — `research-prompt-creator` reads from project config; `execution-manifest-creator` still has Nordic content baked in. Stage 2 routing still hardcodes Nordic countries.
- `ai-resources/workflows/research-workflow/docs/project-config-schema.md` — line 49 (field 5 `Languages`) already names `reference/language-search-blocks.md` as the block-template-instantiation consumer of the schema's `Languages` field. Forward contract is in place; FX-B2 is the implementation that makes that contract live.
- Workflow command `ai-resources/workflows/research-workflow/.claude/commands/run-execution.md` invokes the skill — no direct grep hit for the S-04 block text, but the skill's output (prompt language blocks) flows through this command. Behavior-compatible if the loader stanza preserves the skill's output shape.
- Project consumers — `projects/buy-side-service-plan/.claude/commands/run-execution.md` line 38 calls the skill. Buy-side has NO project `reference/language-search-blocks.md` and explicitly declares (CLAUDE.md line 17) "This project does not currently use the country-research consumers (`country-parity-checker`, `research-prompt-creator` Nordic-language blocks, etc.)." After FX-B2 lands, when buy-side runs `research-prompt-creator`, the skill will look for the project's `language-search-blocks.md` and not find it. Whether this is a graceful no-op (skip language blocks → English-only prompts) or a halt depends entirely on the loader stanza wording. This is the load-bearing decision of FX-B2.
- Other projects with research-workflow infrastructure (`nordic-pe-screening-project`, `project-planning`, `obsidian-pe-kb`, `personal/travel-os`, `strategic-os` — all surface `research-prompt-creator` in their `pipeline/repo-snapshot.md`): none have a `reference/language-search-blocks.md`. Same absent-file question applies to each.

**Contract assessment.** The S-04 contract has two surfaces today:
1. `research-prompt-creator/SKILL.md` lines 143–166 — verbatim language strings (project-content-as-canonical anti-pattern).
2. `execution-manifest-creator/SKILL.md` lines 87–106 — verbatim country routing table (same anti-pattern).
3. `research-prompt-creator/SKILL.md` line 262 — Self-Check item enforcing the contract.

FX-B2 fixes #1 only. After FX-B2 lands, the S-04 contract is half-canonical-half-project: `execution-manifest-creator` still hard-codes Nordic content. This is fine if FX-B2 is positioned as "Phase 1 of a 2-step extraction" rather than "S-04 extraction complete." Per `audits/workflow-audit/04-generalization-fitness.md:274` (B-04), the second step is on the docket as a separate item.

**Self-Check coherence.** SKILL.md line 262 currently reads: "local-language search blocks (Swedish + Finnish + Norwegian as relevant) are included alongside the English-language block, not as fallback (S-04)." After FX-B2, this is project-specific language baked into the canonical self-check. Either the self-check must be rewritten to be project-agnostic (read country list from `Languages` field; iterate over what the project file contains) or it remains as legacy text that doesn't match the loader-stanza architecture.

### Dimension 4: Reversibility
**Risk:** Medium

- The skill edit (replace lines 143–166 with loader stanza) is a single-file change to a tracked file — `git revert` cleanly restores. Low on its own.
- The new canonical template file (`language-search-blocks.template.md`) is a NEW file — `git revert` of the creating commit removes it cleanly. Low.
- The new project-side file (`projects/nordic-pe-macro-landscape-H1-2026/reference/language-search-blocks.md`) is a NEW file in the project repo — `git revert` of the creating commit removes it cleanly. Low.
- **However:** FX-B2 spans TWO git repos (ai-resources + nordic-pe project). The cross-repo dual-commit means revert is a two-repo operation. If the skill edit lands in ai-resources but the project-side file commit fails or is delayed, the canonical skill is looking for a project file that doesn't exist for the active project. Same risk in reverse: reverting only ai-resources without reverting the project file leaves a project-side reference file with no skill consumer.
- Operator muscle-memory risk is low — operators don't directly invoke language-search-blocks.md; the skill consumes it. But the active session's Stage 2 prompts already generated under the old SKILL.md will reference verbatim language strings that no longer live in the skill. Existing prompt artifacts are unaffected (already-generated output is durable); only NEW prompts after the change are affected.
- Bumps to Medium because of the dual-repo commit-coupling and the requirement that ai-resources and project commits be staged-by-name per `commit-discipline.md` to avoid half-state.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Absent-project-file semantics undefined.** This is the central coupling risk. After FX-B2 lands, what does the skill do when invoked from a project that has NO `reference/language-search-blocks.md`? Three possible behaviors, each with different downstream consequences:
  - (a) **Halt with operator-visible error** — clean failure mode, matches the SKILL.md line 30 precedent for `source-class-hierarchy.md` ("If the file is absent, halt — prompts cannot meet the source-class targeting requirement without it"). Safest for evidence integrity. Breaks buy-side and any other project that doesn't yet declare language blocks.
  - (b) **Skip language-block emission, log a [INFERRED] flag** — graceful degradation, matches the "non-critical gap" pattern in SKILL.md line 34 ("Proceed with `[inferred]` defaults only for non-critical gaps"). Compatible with buy-side's English-only posture. Risk: the country-specific S-04 self-check item (line 262) silently passes when it shouldn't, because there are no country-specific directives to check against.
  - (c) **Fall back to inline English-only emission** — matches the existing "English-only fallback" notion in `audits/workflow-audit/04-generalization-fitness.md:273` ("Falls back to English-only when config absent").
  - The CHANGE_DESCRIPTION does NOT specify which behavior is intended. Without an explicit decision in the loader stanza wording, the implementer's choice will silently become canonical contract. This is a textbook hidden-coupling site.
- **Project Config schema dependency.** The schema (`docs/project-config-schema.md:49`) already declares `Languages` as a list (e.g., `[sv, fi, no]`) and names `reference/language-search-blocks.md` as the block-template-instantiation consumer. The loader stanza must read `Languages` from Project Config to know which language blocks to expect. If the loader stanza doesn't reference Project Config explicitly, two parallel sources of truth emerge: the project's `Languages` field and the project's `language-search-blocks.md` file. Drift between them is silent (e.g., project declares `[sv, fi]` but the file still has Norwegian terms from a copy-paste).
- **Companion skill `execution-manifest-creator` not updated in same change.** SKILL.md lines 87–106 of `execution-manifest-creator` still hard-code the Sweden/Norway/Finland routing table. After FX-B2, the routing decision (which language to call for) and the term list (what queries to emit) live in different places — routing in canonical skill prose, terms in project config. A project that swaps `[sv, fi, no]` for, say, `[de, fr, it]` will have its term list updated but its routing table still says "Sweden → Swedish." Silent contract drift. The CHANGE_DESCRIPTION acknowledges this only obliquely ("Pattern matches FX-B3/B5/B6 precedent") without naming the B-04 deferred item.
- **Self-Check item line 262 coupling.** The skill's Self-Check currently enforces "Swedish + Finnish + Norwegian as relevant" — verbatim Nordic content in a canonical self-check. If FX-B2 leaves this line unchanged, the canonical skill still has Nordic-specific text. If FX-B2 rewrites it, the rewrite must read the language list from Project Config to remain generic. The CHANGE_DESCRIPTION does not specify whether line 262 is part of the edit scope. INCOMPLETE specification.
- **Loader-stanza format precedent.** FX-B3 landed `source-class-hierarchy.template.md` and `known-limits.template.md`. Reading `source-class-hierarchy.template.md:5-9`, the template uses a `> **Authority.** Project-level reference. Consumed by:` callout that lists the consuming skills. The skill side (e.g., `research-prompt-creator/SKILL.md:30`) names the file by path with halt-if-absent semantics. FX-B5/B6 templates use the same pattern. FX-B2 should follow the same pattern OR explicitly diverge with rationale. The CHANGE_DESCRIPTION says "Pattern matches FX-B3/B5/B6 precedent" but doesn't pin down whether the absent-file behavior is halt (matching source-class-hierarchy.md) or skip (different from the FX-B3 precedent because the file is project-conditional for multi-language projects only).

## Mitigations

- **Dimension 3 (Blast Radius — High): Define absent-file semantics in the loader stanza explicitly before landing.** Choose between (a) halt-with-error, (b) skip-with-[INFERRED]-flag, or (c) fall-back-to-English-only. Write the chosen behavior into the loader stanza in plain language so the next skill maintainer reads the intended semantics from the skill file itself, not from CHANGE_DESCRIPTION. Recommended choice: **option (c) fall-back-to-English-only when `Languages:` is empty or the file is absent**, because it preserves backward compatibility with buy-side and other single-language projects while keeping multi-language projects (nordic-pe) on the new architecture. This matches `audits/workflow-audit/04-generalization-fitness.md:273`'s stated intent ("Falls back to English-only when config absent").

- **Dimension 3 (Blast Radius — High): Update Self-Check item line 262 in the same edit.** Rewrite from "Swedish + Finnish + Norwegian as relevant" to a generic formulation that reads the language list from Project Config (e.g., "For country-specific directives: local-language search blocks for each language in Project Config `Languages` are included alongside the English-language block, not as fallback (S-04). If `Languages:` is empty or `language-search-blocks.md` is absent, this item is N/A and the prompt emits English-only directives."). Leaving line 262 with verbatim Nordic content while extracting lines 143–166 to a loader stanza is incoherent — the same canonical skill would both extract project content AND keep project content.

- **Dimension 5 (Hidden Coupling — High): The loader stanza must read `Languages:` from Project Config FIRST, then iterate over `language-search-blocks.md` blocks matching those language codes.** This prevents the silent-drift failure mode where Project Config and language-search-blocks.md disagree. If the language-search-blocks.md file contains a block for a language NOT in `Languages:`, skip it and emit a one-line warning to the operator. If `Languages:` declares a language with no matching block in the file, halt with a clear error message. Mirror the schema-consumer contract from `docs/project-config-schema.md:49` exactly.

- **Dimension 5 (Hidden Coupling — High): Document the deferred companion extraction (B-04 — `execution-manifest-creator` Country-Specific Language-Block Routing table).** Add a one-line note in the loader stanza or in the new template's authority callout: "Companion file: `execution-manifest-creator/SKILL.md § Country-Specific Language-Block Routing` — country routing table currently still hard-codes Sweden/Norway/Finland; B-04 will extract it. Until B-04 lands, this template is the source of truth for language-term content; the routing table is the source of truth for country→language mapping." This makes the half-extracted state explicit so a future maintainer doesn't read FX-B2 as a complete S-04 generalization.

- **Dimension 4 (Reversibility — Medium): Stage and commit the ai-resources side first, verify the loader stanza compiles (skill reads cleanly), then stage and commit the nordic-pe project side in a separate commit.** This avoids the half-state where the canonical skill is mid-edit but the project file isn't yet in place. If reversal is needed, revert the project-side commit first (restoring the absent-file state), then revert the ai-resources commit. Two-commit sequencing aligns with `commit-discipline.md` concurrent-session staging discipline. Do NOT use `git add -A` in either repo.

## Evidence-Grounding Note

All risk levels grounded in direct evidence:
- SKILL.md lines 13, 30, 34, 143–166, 262 read verbatim.
- Project Config schema field 5 (`Languages`) verified at `docs/project-config-schema.md:49`.
- Companion skill grep verified at `execution-manifest-creator/SKILL.md:87, 89, 93, 102, 106, 153`.
- Cross-project consumer enumeration grounded in `grep -rn` results across `ai-resources/` and `projects/`.
- Buy-side absence verified at `projects/buy-side-service-plan/CLAUDE.md:17` ("This project does not currently use the country-research consumers ... `research-prompt-creator` Nordic-language blocks").
- FX-B3 precedent template structure verified at `workflows/research-workflow/reference/source-class-hierarchy.template.md:1-13` and `known-limits.template.md:1-12`.
- FX-B4 risk-check audit cross-referenced at `audits/risk-checks/2026-05-27-fx-b4-extend-canonical-quality-standards.md:11, 20, 79`.
- B-04 deferred-item evidence at `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/04-generalization-fitness.md:273-274`.
- No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — FX-B2 (Language-Search Block Extraction)

## Routing Position

The change lands in established homes. The canonical template belongs at `ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md`, alongside the existing `.template.md` siblings (`source-class-hierarchy.template.md`, `known-limits.template.md`, `claim-permission.template.md`). The project instance at `projects/nordic-pe-macro-landscape-H1-2026/reference/language-search-blocks.md` mirrors the FX-B3/B5/B6 instantiation pattern. The skill remains at `ai-resources/skills/research-prompt-creator/SKILL.md`. No new top-level directories; no new artifact category; no layer ambiguity. The routing is correct (`blueprint.md § 3.2`, `principles.md § DR-3`).

## Concurrence with PROCEED-WITH-CAUTION

**We concur with the verdict.** The change is structurally aligned with the documented system, the dimension breakdown is accurate, and both High dimensions have viable mitigations on the table. Three load-bearing reasons:

1. The change advances OP-1 (compounding value) and reverses an active anti-pattern: project-content baked into a canonical skill is a textbook DR-1 violation — "Could this plausibly serve more than one project?" The current SKILL.md lines 143–166 fail that test by hardcoding Nordic vocabulary into a skill every research project consumes (`principles.md § DR-1`, `system-doc.md § 4.4 — auto-sync symlink topology`).
2. The pattern (template + project instance + loader stanza) is now a four-instance precedent (FX-B3/B4/B5/B6). DR-7 says "generalize only when a second confirmed consumer exists" — that bar is exceeded; this is not speculative abstraction (`principles.md § DR-7`).
3. The blast radius is correctly classified High because the canonical skill is auto-distributed to every research project (`risk-topology.md § 3 — "New canonical command/agent edit: All projects (auto-synced)"`), and the absent-file decision is genuinely load-bearing — this is not over-caution.

## Concurrence with the Mitigation Path

**We concur with the recommended mitigations as listed, with refinements on two points and one addition.**

### Concur as-stated
- **Per-file `git add` discipline at commit.** Required, non-negotiable. Patrik has disclosed a concurrent terminal in recent sessions; DR-10 forbids directory wildcards under that condition (`principles.md § DR-10`).
- **Loader reads `Languages:` from Project Config first.** This is the right architecture — single source of truth for which languages apply, file is the term content for those languages. Matches the schema-consumer contract already declared in `docs/project-config-schema.md:49`. Surfaces drift loudly per OP-3 instead of silently per AP-1 (`principles.md § OP-3, § AP-1`).
- **Document B-04 deferred companion in the loader stanza or template authority callout.** Required. Without this note, a future maintainer reads FX-B2 as "S-04 extraction complete" when it is half-extracted — that is precisely AP-11 territory if it surfaces in a later audit and produces another correction cycle on the same drafter (`principles.md § AP-11`).

### Refinement 1 — Absent-file semantics

The risk-check report recommends **(c) fall-back-to-English-only when `Languages:` is empty or the file is absent**, with the rationale "preserves backward compatibility with buy-side." We concur with the choice and add a refinement: the loader stanza must distinguish three cases explicitly, not collapse them into one fallback:

1. `Languages:` field absent or `[]` → emit English-only, no warning (correct posture for monolingual projects; buy-side's stated state).
2. `Languages:` populated but `language-search-blocks.md` absent → **halt with a clear error**, not fall back. A multi-language project that declares `Languages: [sv, fi, no]` and lacks the per-language file is a configuration error, not an intended monolingual posture. Falling back here silently degrades evidence integrity for a project that explicitly asked for multi-language coverage — direct AP-2 / OP-3 violation (`principles.md § AP-2, § OP-3`).
3. `Languages:` populated AND file present → iterate over languages, skip any in the file not in `Languages:` with a one-line operator warning, halt if `Languages:` names a language with no matching block.

The risk-check's option (c) handles case 1 correctly. Cases 2 and 3 need separate semantics. This refinement also addresses the Self-Check line 262 incoherence directly — line 262 becomes "N/A when `Languages:` is absent; otherwise enforces a language block for every entry in `Languages:`."

### Refinement 2 — Update Self-Check line 262 in the same edit

We concur with the risk-check on this point and elevate it: this is not optional. Leaving line 262 with verbatim Nordic content while extracting lines 143–166 creates a self-inconsistent canonical skill — extract project content from one location, retain project content in another. AP-1 (silent conflict resolution) fires if the implementer interprets "Pattern matches FX-B3/B5/B6 precedent" as authorization to leave line 262 alone (`principles.md § AP-1`). Same change, same commit.

## Risk the Dimension Review Did Not Surface

The risk-check report covers blast radius, reversibility, and hidden coupling thoroughly. One risk it does not name explicitly:

**Cross-skill contract enforcement is unowned.** After FX-B2 lands, S-04 has three surfaces — `research-prompt-creator/SKILL.md` (now generalized), `execution-manifest-creator/SKILL.md` (still hardcoded), and `docs/project-config-schema.md:49` (the field declaration). The risk-check report names this state but treats it as "fine if FX-B2 is positioned as Phase 1 of 2." That framing is correct, but there is no mechanism in the system today that will *detect* the half-extracted state if B-04 is never landed. There is no automated check that S-04 contracts agree across all three surfaces. W2.2 accountability automation would close this loop (`system-doc.md § 2.3, § 4.5 — Open loops: Principles → live enforcement`), but W2.2 does not exist yet.

The mitigation is operator-level: log B-04 as a Friday-cadence follow-up in `ai-resources/logs/maintenance-observations.md` (or equivalent improvement log) at commit time, with a stated trigger ("review when next project declares `Languages:` with a non-Nordic set, or at the next Friday checkup, whichever comes first"). Without this, B-04 drifts off the radar and the half-extracted state becomes invisible technical debt — drift-without-detection is the OP-11 / OP-3 anti-pattern at system scale (`principles.md § OP-3, § OP-11`).

## Summary

Proceed. The mitigation path is sound; tighten on absent-file semantics (three cases, not one), require the Self-Check line 262 rewrite in the same commit, and log B-04 as a tracked deferred item before the FX-B2 commit lands. The right answer is to ship FX-B2 with the refined mitigation set, then queue B-04 visibly so the half-extracted state cannot drift silently.
