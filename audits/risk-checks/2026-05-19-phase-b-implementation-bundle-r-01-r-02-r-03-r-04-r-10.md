# Risk Check — 2026-05-19

## Change

Phase B implementation bundle (R-01 + R-02 + R-03 + R-04 + R-10) for the Nordic PE Macro Landscape project's R1 workflow remediation. Per implementation spec v2 dated 2026-05-19. Bundle scope is locked per Phase B open-question decisions logged 2026-05-19 (Edit 1-E to ai-resources/docs/analytical-output-principles.md dropped — bundle contains no cross-project policy amendment).

**R-01 — Caveat routing to back-matter section (4 edits, 4 files):**
- Edit 1-A: ai-resources/skills/research-structure-creator/SKILL.md (lines 139–143) — add "Evidence Limitations & Open Questions" as a required back-matter section when uncertainty disclosure is in scope.
- Edit 1-B: projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md (after line 22) — new "Uncertainty Disclosure and Caveat Routing" section defining load-bearing vs. non-load-bearing caveats, routing test, back-matter structure.
- Edit 1-C: ai-resources/skills/evidence-to-report-writer/SKILL.md (after line 258) — new "Caveat Routing" subsection: tag non-load-bearing caveats `[CAVEAT-ROUTE: back-matter]` during drafting; batch-extract after section completion.
- Edit 1-D: projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md (line 118) — expand Step 5.8 to include back-matter assembly.

**R-02 — Decontamination pass coverage extension (5 edits, 1 file):**
- All edits to ai-resources/skills/ai-prose-decontamination/SKILL.md.
- New Sub-pattern 1d (academic constructions); Sub-pattern 2b (summary-restatement closers); extend Sub-pattern 3b to section-level caveat density; new Pass 5 (paragraph shape: circular structure + topic-discontinuity); replace "four passes" → "five passes" throughout.

**R-03 — MTC trigger extensions (4 edits, 2 files):**
- Edit 3-A: ai-resources/skills/prose-formatter/SKILL.md (lines 56–71) — lower Trigger #1 to 3+ parallel items unconditional (no claim-opener exception); add Triggers #6 (chronological data points), #7 (geography×metric table), #8 (Pass 5b paragraph-split handoff).
- Edit 3-B: ai-resources/skills/prose-formatter/SKILL.md — Operation 3 mandatory trigger (d).
- Edit 3-C: ai-resources/skills/prose-formatter/SKILL.md — Operation 2 claim-opener + enumeration pattern (D-11).
- Edit 3-D: projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-formatting.md (line 52) — Phase 2 pre-scan description updated from 5 to 8 triggers.

**R-04 — Paragraph length, density, shape, coherence rules (2 edits, 2 files):**
- Edit 4-A: projects/nordic-pe-macro-landscape-H1-2026/reference/style-guide.md (after line 35) — three new sections (paragraph/section length; section heading length; italic-opener form). D-11 claim+leadin paragraphs exempt from length checks.
- Edit 4-B: ai-resources/skills/chapter-prose-reviewer/SKILL.md (after line 86) — four new checks (paragraph topical coherence; paragraph circular structure; paragraph length with D-11 exemption; caveat density at section level).

**R-10 — prose-refinement-writer constraint extensions (3 edits, 1 file):**
- All edits to ai-resources/skills/prose-refinement-writer/SKILL.md.
- Fix 1 50-word sentence cap; Fix 1 definition-interruption sub-case; Fix 2 closing-sentence restatement check (defer actual deletion to ai-prose-decontamination Pass 2b); cross-reference under "Parenthetical qualifier stacks".

**Scope summary:** 6 ai-resources skill files modified; 3 project reference docs modified; 1 project command file modified. Total: 10 files across 4 directories.

**Sequencing constraints:** R-01 sequence: 1-A → 1-B → 1-C → 1-D. R-05 Edit 5-A and R-07 Edit 7-A must land same session (outside this bundle). Bundle excludes R-05/R-07/R-08/R-09.

**Locked decisions framing this bundle:** Edit 1-E (cross-project amendment to analytical-output-principles.md) dropped. /risk-check at Phase B Step 1 retained. R2/R3 short-H3 retroactive restructure skipped.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-structure-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/evidence-to-report-writer/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/ai-prose-decontamination/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/prose-formatter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/chapter-prose-reviewer/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/prose-refinement-writer/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/style-guide.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-formatting.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Bundle is large (10 files, 18 distinct edits across 5 remediation items) and touches a contract surface (Mechanical Triggers count: 5→8) that is referenced verbatim in adjacent skills, a command file, and a `.bak` template; blast radius and hidden-coupling risks are elevated but mitigable with sequenced edits and verified caller updates.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All 10 edited files are pay-as-used artifacts. None is an always-loaded file. Workspace CLAUDE.md and project CLAUDE.md are not in the file list. Project CLAUDE.md explicitly directs lazy-loading: *"IMPORTANT: Load these references only when working on the relevant stage or task — not on every turn"* (projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md "Workflow Overview" block).
- No new `@import` chain, no SessionStart/Stop/PreToolUse/UserPromptSubmit hook, no subagent brief expansion, no new skill auto-load trigger pattern. Bundle modifies content inside already-existing SKILL.md / command / reference docs.
- Skill files are loaded only when their pipeline step runs. Five SKILL.md files modified (research-structure-creator 207 lines, ai-prose-decontamination 316, prose-formatter 289, chapter-prose-reviewer 171, prose-refinement-writer 269, evidence-to-report-writer 334 — `wc -l` verified) will each grow modestly. R-02 alone adds 1 new sub-pattern, 1 new sub-pattern extension, 1 new pass, and ~5 in-place renames; estimate +30–80 lines on a 316-line file. None of these is in always-loaded context.
- The two project reference docs that grow (quality-standards.md, style-guide.md, stage-instructions.md) are guarded by their own "When to read this file" headers and are not loaded on every turn.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` edits in the bundle. No `allow`, `ask`, or `deny` rule additions, removals, or scope changes.
- No new tool families introduced. No Bash/Write/external API patterns enabled. No MCP server access. No scope escalation (project → user, etc.).
- Bundle is pure markdown content edits to SKILL/command/reference docs.

### Dimension 3: Blast Radius
**Risk:** High

Enumeration of dependent callers (grep across ai-resources and project workspaces):

- `prose-formatter` referenced in: `ai-resources/skills/formatting-qc/SKILL.md` (6 refs), `ai-resources/skills/h3-title-pass/SKILL.md` (5 refs), `ai-resources/skills/decision-to-prose-writer/SKILL.md` (1), `ai-resources/skills/prose-compliance-qc/SKILL.md` (1), `ai-resources/skills/ai-prose-decontamination/SKILL.md` (1), `ai-resources/skills/workflow-system-analyzer/SKILL.md` (1), `ai-resources/skills/CATALOG.md`, `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/produce-formatting.md` (6 refs), and `produce-formatting-v1-template.md.bak` (6 refs). 9+ caller surfaces.
- `ai-prose-decontamination` and `prose-refinement-writer` referenced by: `projects/.../commands/produce-prose-draft.md`, `produce-prose-draft-v1-template.md.bak`, `ai-resources/skills/prose-compliance-qc/SKILL.md`, plus internal cross-refs in `prose-refinement-writer/SKILL.md` and `ai-prose-decontamination/SKILL.md`. 4–5 active caller surfaces.
- The MTC trigger count is a hard-coded contract repeated verbatim across files. Grep for "five mandatory triggers" / "5 triggers" in `produce-formatting.md` line 52 and `produce-formatting-v1-template.md.bak` shows the phrase *"the five mandatory triggers"* used verbatim. Edit 3-D updates the active command from 5 → 8 but the **`.bak` template is not touched in this bundle** — if `.bak` ever becomes the basis for a re-template, the count will drift. (Note: project CLAUDE.md says `.bak` is intentionally non-registered as a slash command, so drift impact is bounded but real.)
- The "four passes" → "five passes" rename in R-02 must propagate consistently. Grep finds at least 6 in-file occurrences in `ai-prose-decontamination/SKILL.md` itself (intro, constraints, runtime, worked-example pointer); plus an external reference in `ai-resources/skills/ai-prose-decontamination/references/worked-example.md` ("transformed through all four passes") and `projects/.../report/produced/1.1/R1/decontamination-log.md` ("four passes"). Spec v2 names "find-and-replace throughout SKILL.md" but the worked-example.md reference file is NOT in the edit list — drift hazard.
- Edit 4-B adds new chapter-prose-reviewer checks that depend on D-11 from style-guide.md (Edit 4-A). Cross-skill contract: chapter-prose-reviewer must reference a concept defined in a project-specific style-guide. If the skill is ever invoked against a non-Nordic project, the D-11 exemption check has no anchor.
- R-01 introduces a new contract (`[CAVEAT-ROUTE: back-matter]` tag) that crosses four files in a strict sequence (1-A → 1-B → 1-C → 1-D). Out-of-order application leaves intermediate states where evidence-to-report-writer tags caveats with a marker that has no consumer.

Total dependent callers / contract-bearing references: 15+ surfaces across 10 directly edited files plus 5+ indirect ones.

### Dimension 4: Reversibility
**Risk:** Medium

- All 10 file edits are git-tracked content edits. `git revert` cleans them up fully at the file level.
- However, R-01 creates **append-only side effects** in artifacts that the workflow then writes through:
  - The evidence-to-report-writer caveat-tagging instruction (Edit 1-C) will, on next pipeline run, produce prose with `[CAVEAT-ROUTE: back-matter]` markers in `/report/chapters/{section}/`. A revert of the SKILL.md edit will not remove tags already written to chapter files — manual cleanup needed.
  - Edit 1-D expands Step 5.8 to include back-matter assembly. If executed before revert, the assembled back-matter section persists in the compiled output (`report/compiled/1.1/`). Revert doesn't undo the assembled artifact.
- The R-02 "four passes → five passes" find-and-replace propagates through SKILL.md and may also need a manual sweep of `references/worked-example.md` and the project's existing `decontamination-log.md` (which records "four passes" verbatim for R1 prose already produced). Revert of SKILL.md will not reconcile downstream log entries.
- No external writes (no `git push`, no Notion, no API). No new hook/cron/symlink. Within-repo revert is the rollback path.
- Net: single-step `git revert` recovers most of the bundle; one extra manual step (delete `[CAVEAT-ROUTE]` tags from any prose already produced post-edit, reconcile decontamination-log.md if pipeline ran) is required if revert happens after the pipeline has executed against the new SKILL.md content. This pushes the dimension to Medium, not Low.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Cross-edit ordering dependency in R-01.** Spec v2 names "1-A → 1-B → 1-C → 1-D" but does not document the failure mode of out-of-order application. If 1-C lands before 1-B, evidence-to-report-writer begins tagging caveats with a marker whose routing rule (defined in quality-standards.md) does not yet exist. The contract is implicit, not enforced by the file content itself.
- **D-11 cross-file dependency.** Edit 3-C introduces "D-11 (claim-opener + enumeration pattern)" in `prose-formatter/SKILL.md`. Edit 4-A defines D-11 in `style-guide.md` (project-specific). Edit 4-B adds chapter-prose-reviewer checks that reference D-11. The label "D-11" is shared across three files — a generic skill (chapter-prose-reviewer) now silently depends on a project-specific style-guide section. If the skill is reused on a different project's prose, D-11 is undefined. The change description does not document this as a project-scoped extension vs. a generic skill extension.
- **MTC trigger count drift.** The phrase *"five mandatory triggers"* appears verbatim in `produce-formatting.md` (Edit 3-D updates 5→8) and in `produce-formatting-v1-template.md.bak` (NOT in bundle). The `.bak` file is intentionally non-registered (project CLAUDE.md Stage 5 Polish Commands block), but it is a documented template archive. If anyone uses it as the base for a future re-template, the count drifts immediately.
- **R-10 references a not-yet-landed sub-pattern.** R-10 Fix 2 "closing-sentence restatement check (defer actual deletion to ai-prose-decontamination Pass 2b)". Sub-pattern 2b is added in R-02 Edit 2-B. If R-10 lands before R-02 in the bundle execution order, prose-refinement-writer references a sub-pattern that doesn't yet exist in ai-prose-decontamination. Spec v2 names the R-01 sequence but no equivalent sequencing constraint for R-02 → R-10.
- **"Four passes" → "five passes" rename is a sub-string contract.** R-02 Edit 2-E does a find-and-replace inside SKILL.md but `references/worked-example.md` retains "all four passes" and the project's existing decontamination-log.md records "four passes (R1 prose already produced)". The downstream artifacts will not auto-update — the rename creates a silent inconsistency between the active skill body and the existing on-disk artifacts.
- **Caveat-routing contract is new and unvalidated.** R-01 introduces a four-file contract (define routing test → define section → tag in prose → assemble in back-matter) without a corresponding QC check that validates the contract held end-to-end. The Stage 5.1 document-integration-qc was named as the gate for short-H3 restructure (per locked decisions) but not for caveat-routing consistency.
- **chapter-prose-reviewer new checks depend on prose-formatter D-11 detection.** Edit 4-B's "paragraph length with D-11 exemption" check assumes D-11-class paragraphs can be identified mechanically. If the reviewer skill cannot identify D-11 from the prose alone (without the formatter's annotation), the check is unenforceable — implicit coupling.

Multiple implicit dependencies; one new four-file contract (R-01) is undocumented at any single change site; one cross-skill label (D-11) silently depends on a project-scoped definition. Dimension is High.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius):** Before landing Edit 3-D, run `rg "five.{0,30}triggers|5 (mandatory )?triggers|five mandatory" ai-resources/ projects/nordic-pe-macro-landscape-H1-2026/` and update *every* occurrence — including the `.bak` template archive — to "eight" or add an inline comment in the `.bak` file noting the trigger count has moved on. Verify zero occurrences of "five mandatory triggers" remain post-bundle.
- **Mitigation for Dimension 3 (Blast Radius):** Before landing R-02 Edit 2-E, extend the find-and-replace scope to include `ai-resources/skills/ai-prose-decontamination/references/worked-example.md` and `ai-resources/skills/ai-prose-decontamination/references/change-log-template.md`. After the rename, grep for "four passes" across the full `ai-prose-decontamination/` directory and confirm zero residual occurrences in skill-internal files. The R1 `decontamination-log.md` is a historical artifact and may be left as-is, but note in the change-log header that prose produced before 2026-05-19 ran the four-pass version.
- **Mitigation for Dimension 5 (Hidden Coupling) — R-01 ordering:** Apply R-01 strictly in the spec-named sequence 1-A → 1-B → 1-C → 1-D *and* gate Edit 1-C (evidence-to-report-writer tagging) on 1-B (quality-standards routing definition) being present. Add a one-line cross-reference at the top of the new "Caveat Routing" subsection in evidence-to-report-writer pointing to `quality-standards.md` "Uncertainty Disclosure and Caveat Routing", so the contract is explicit at the change site.
- **Mitigation for Dimension 5 (Hidden Coupling) — D-11 scoping:** In Edit 3-C (prose-formatter D-11 pattern), name D-11 with a project-neutral description and note explicitly that the "D-11" label originates in `projects/nordic-pe-macro-landscape-H1-2026/reference/style-guide.md` and is project-scoped. In Edit 4-B (chapter-prose-reviewer), reference D-11 with the same scoping note so a future caller from a non-Nordic project understands the exemption check is conditional on a project-specific style-guide section.
- **Mitigation for Dimension 5 (Hidden Coupling) — R-02 before R-10:** Add an explicit sequencing note alongside the existing "R-01: 1-A → 1-B → 1-C → 1-D" sequence: R-02 Edit 2-B (Sub-pattern 2b) must land before R-10 Fix 2 cross-reference. Either enforce by sequencing within this bundle's commit order, or land R-10's "defer to Pass 2b" cross-reference as a forward-pointer noting "Pass 2b added in R-02" so the file is consistent even mid-bundle.
- **Mitigation for Dimension 5 (Hidden Coupling) — caveat-routing QC gate:** Add a one-line check to either `document-integration-qc` (Stage 5.1 gate) or `chapter-prose-reviewer` (Edit 4-B's new checks block) that flags any `[CAVEAT-ROUTE: back-matter]` marker remaining in body prose after compilation, OR any back-matter section asserted by Edit 1-D's Step 5.8 expansion that contains zero entries (suggesting the upstream tagging didn't fire). Closes the end-to-end loop on the new contract.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from the 10 referenced files (all read in full or in target ranges), `rg`/`wc` counts across `ai-resources/` and `projects/nordic-pe-macro-landscape-H1-2026/`, verbatim quotes from `CHANGE_DESCRIPTION` and the referenced files, and contract-string grep results for "five mandatory triggers" and "four passes" / "five passes". No training-data fallback was used on fetch/read failures.
