# Risk Check — 2026-05-27

## Change

FX-B4 — extend canonical research-workflow `reference/quality-standards.md` from ~80 to ~150–180 lines.

Scope: extend `ai-resources/workflows/research-workflow/reference/quality-standards.md` in place. Add Generic chassis content the file is intentionally missing per its own top-of-file deferred-additions callout — Evidence Calibration (four-tier framework), Uncertainty Disclosure / Caveat Routing, No-Source-Substitution Rule (IN-LENS / PROXY-DOWNGRADE / NO-EVIDENCE tag vocabulary + operating rule), Country Coverage Table format, Claim-Permission Classes (SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED — full chassis including permitted-verb lists, blocking-gate semantics, gate-clearance artifact format), Research Stop Conditions (4-condition rule), Source-Conflict Resolution Procedure (3-step), plus three empty fillable section blocks (Minimum Evidence Thresholds, Source-Diversity Matrix, R1-Defect Fold-Ins). Remove the top-of-file deferred-additions warning callout. Target line count 150–180 per `projects/nordic-pe-macro-landscape-H1-2026/plans/finish-fix-phase-plan-v1.md` Step 3 and `projects/nordic-pe-macro-landscape-H1-2026/audits/workflow-audit/05-template-fitness.md` §3.1.

Source material: chassis lifted from the project-deployed 302-line `projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md` (Bundle 2b additions S-02, S-03, S-06, S-07, S-13, S-19). Project-specific content (Nordic country names, Sweden/Norway/Finland columns in worked examples, named aggregators like KPMG/EY/Argentum, evidence-threshold rows like "Sector is hot") stripped to placeholders or moved to project-fillable surfaces (FX-B5 `claim-permission.template.md`, to be authored next).

Posture: plan-time gate. End-time gate fires before commit. Concurrent WU4a session is in-flight editing Stage 5 commands + `research-prompt-creator` skill + creating `language-search-blocks.template.md` in the same canonical reference directory — no file-level overlap with FX-B4.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md` — exists (80 lines, verified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/source-class-hierarchy.template.md` — exists (FX-B3 landed; verified zero project-token leakage on the surfaced section)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/known-limits.template.md` — exists (FX-B3 landed)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/claim-permission.template.md` — not yet present (FX-B5, to be authored after FX-B4)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/jargon-gloss-config.template.md` — not yet present (FX-B6)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/language-search-blocks.template.md` — not yet present (concurrent WU4a session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/quality-standards.md` — exists (302-line source-material file, verified)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is structurally sound and aligns the canonical chassis with what downstream consumers already expect, but blast radius is High (12+ skill/command consumers across the workflow) and hidden coupling is Medium (a parser surface — `## Claim-Permission Classes` and `## Source-Diversity Matrix` exact section headings — is load-bearing to `claim-permission-gate` and `/run-sufficiency`). Paired mitigations below.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The file is not always-loaded. `workflows/research-workflow/CLAUDE.md` line 57 names it explicitly as load-on-demand: "Only load these when actively working on the relevant stage or task." Same disposition for the canonical chassis once landed.
- The file does not declare `@import` in any always-loaded surface. Grep for `@import` against `workflows/research-workflow/CLAUDE.md` and the `.claude/commands/*.md` returns no canonical import of `quality-standards.md`.
- Token expansion from ~80 → ~150–180 lines (~6–10 KB) is paid only by consumers that already read this file (Stage 3 `cluster-memo-refiner`, Stage 2 `research-prompt-creator`, Stage 4 `evidence-to-report-writer`, etc.). Each of these consumers is a Read-on-task subagent, not an always-loaded surface, so the additional tokens are scoped to the sessions where the file is already required.
- No new hooks, no new auto-loaded skills, no broad-trigger skill-description widening.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change is a single-file edit to a markdown reference doc inside an already-tracked directory. No `.claude/settings.json` or `.claude/settings.local.json` change.
- No new tool invocation pattern (Bash command, Write path, external API). Write target is inside `ai-resources/` which is the canonical author location for this file.
- No `allow` / `ask` / `deny` rule touched. No scope escalation (project → user → workspace).

### Dimension 3: Blast Radius
**Risk:** High

Enumeration of canonical consumers (grep `reference/quality-standards` across `ai-resources/`):

**Workflow commands (5 files):**
- `workflows/research-workflow/.claude/commands/run-cluster.md` — 2 references (lines 27, 31). Reads file's Country Coverage Table, Minimum Evidence Thresholds, Source-Diversity Matrix, Claim-Permission Classes, Source-Conflict Resolution Procedure.
- `workflows/research-workflow/.claude/commands/run-sufficiency.md` — 5 references (lines 27, 28, 32, 87, 120). Treats `## Claim-Permission Classes` and `## Source-Diversity Matrix` as **required parseable sections** — Phase F refuses to run if either is "absent or malformed" (line 27–28). Also reads NOT-SUPPORTED ratio thresholds (line 32).
- `workflows/research-workflow/.claude/commands/run-execution.md` — 4 references (lines 41, 43, 107, 109). Reads Evidence-First preamble, Country Coverage Table, No-Source-Substitution Rule, Research Stop Conditions.
- `workflows/research-workflow/.claude/commands/run-report.md` — 4 references (lines 22, 56, 59, 62). Per-chapter triplet (writer/reviewer/QC) reads `quality-standards.md` by path at runtime — Uncertainty Disclosure rule and Claim-Permission Classes consumed across all three subagent calls per chapter.
- `workflows/research-workflow/CLAUDE.md` — 1 reference (line 57). Names the file in the on-demand-load instruction list.

**Skills (8 SKILL.md files):**
- `skills/cluster-memo-refiner/SKILL.md` — 4 references (lines 197, 222, 228, 234, 252). Check 8 reads `§ Country Coverage Table`; Check 9 reads `§ Claim-Permission Classes` (permission-class assignment, minimum-evidence thresholds, Source-Diversity Matrix, triangulation-packets rule, blocking-gate 30%/40% semantics); Check 10 reads `§ Source-Conflict Resolution Procedure`. This is the densest downstream consumer.
- `skills/evidence-to-report-writer/SKILL.md` — 3 references (lines 262, 279, 370). Reads Uncertainty Disclosure rule (load-bearing test) and Claim ID Invariant.
- `skills/chapter-prose-reviewer/SKILL.md` — 1 reference (line 94). Reads Uncertainty Disclosure rule for caveat-density check.
- `skills/research-extract-creator/SKILL.md` — 2 references (lines 81, 147). Reads No-Source-Substitution Rule tag vocabulary + Source-Conflict Resolution Procedure routing.
- `skills/research-prompt-creator/SKILL.md` — 3 references (lines 92, 137, 167, 263). Reads Evidence-First preamble, No-Source-Substitution Rule three-outcome contract, Research Stop Conditions 4-condition list.
- `skills/claim-permission-gate/SKILL.md` — 8 references (lines 17, 18, 42, 49, 50, 57, 70, 145, 146, 148, 157, 158, 191). **Hardest dependency.** The skill explicitly says "Do NOT hard-code the four permission classes' thresholds inside this skill — they live in the project's `reference/quality-standards.md`" (line 42). The skill fails-closed if `## Claim-Permission Classes` or `## Source-Diversity Matrix` are absent or malformed.
- `skills/section-directive-drafter/SKILL.md` — 1 reference (grep hit). Reads Claim-Permission Classes for directive emission.
- Other skill SKILL.md files (`ai-prose-decontamination`, `cluster-analysis-pass`, `document-integration-qc`, `report-compliance-qc`, `prose-refinement-writer`, `research-extract-verifier`) appear in grep hits as path references but with smaller surfaces.

**Contract assessment.** The chassis sections being added (`## Claim-Permission Classes`, `## Source-Diversity Matrix`, `## No-Source-Substitution Rule`, `## Research Stop Conditions`, `## Source-Conflict Resolution Procedure`, `## Country Coverage Table`) are **already named by consumers as required parseable section headings** (e.g., `run-sufficiency.md` line 27, `claim-permission-gate/SKILL.md` lines 17–18, 49–50). The canonical file currently lacks them — the canonical file's own deferred-additions callout (lines 1–3) acknowledges this. The change is *closing* the contract gap that already exists between consumers and the canonical chassis, not *opening* a new one. This is a forward-compatible addition for all enumerated consumers: each consumer currently runs against the *project copy* (302 lines) and will find the same sections in the canonical chassis once landed.

**However:** 12+ consumers each take a hard dependency on the exact section-heading strings. Any deviation in section heading (e.g., `## Claim Permission Classes` without the hyphen, `## Source Diversity Matrix` without the hyphen, `## No Source Substitution` instead of `## No-Source-Substitution Rule`) breaks all downstream parsers. Three skills (`claim-permission-gate`, `cluster-memo-refiner` Check 9, `run-sufficiency` Phase F) fail-closed on heading mismatch — this is documented behavior, not speculative. The verb-list inside `## Claim-Permission Classes` is normative for `chapter-prose-reviewer` and `evidence-to-report-writer` per skill line 191.

### Dimension 4: Reversibility
**Risk:** Low

- Direct edit of an existing tracked file (`workflows/research-workflow/reference/quality-standards.md`). Single-file edit. No sibling files created.
- `git revert` restores the prior 80-line state cleanly. Verified the file is tracked in the `ai-resources/` git repo (deferred-additions callout names "the source-pipeline workflow fix" — same workflow remediation set that lives in the project).
- No data file mutation (no log append, no decisions.md write). No external write. No automation that could fire between commit and a hypothetical revert.
- No operator muscle-memory implication — operators don't invoke `quality-standards.md` directly; consumers read it.
- The concurrent WU4a session is editing different files (`produce-prose-draft.md`, `produce-formatting.md`, `produce-jargon-gloss.md`, `research-prompt-creator/SKILL.md`, `language-search-blocks.template.md`) per CHANGE_DESCRIPTION — no merge conflict surface on `quality-standards.md` specifically. Concurrent-session staging discipline per `ai-resources/docs/commit-discipline.md` applies (each session stages its files by name).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Parser-surface coupling (documented, not hidden).** The exact section-heading strings `## Claim-Permission Classes` and `## Source-Diversity Matrix` are documented contracts: `workflows/research-workflow/.claude/commands/run-sufficiency.md` lines 27–28 names them as parseable preconditions; `skills/claim-permission-gate/SKILL.md` lines 17–18, 49–50, 57, 70 names them as parseable input contracts. This is Medium (documented), not High (silent).
- **Verb-list normative coupling.** `skills/cluster-memo-refiner/SKILL.md` line 222 + `chapter-prose-reviewer` enforce the verb lists inside `## Claim-Permission Classes` (permitted prose verbs per class). Any change to verb-list wording during the chassis migration would silently degrade Stage 4 prose review. Documented at the consumer side but not at the chassis side — chassis must mirror the project-file verb-list verbatim for the four classes.
- **Threshold values (30% cluster / 40% section blocking gates).** `cluster-memo-refiner` Check 9 (line 234) and the Pass 3 gate-clearance emitter (`run-sufficiency.md` line 87) read these as numeric thresholds. The change description says "30%/40% calibratable thresholds" land in chassis — the project file (line 244) notes the 30%/40% values are "locked starting values" with "calibration after the first production run is permitted." If the canonical chassis hard-codes 30%/40% as fixed values, projects forking the chassis inherit Nordic-PE-tuned numbers. Recommendation in mitigations.
- **Forward-contract on FX-B5 sibling.** The chassis adds Claim-Permission-Class chassis structure that FX-B5 `claim-permission.template.md` (not yet present) is expected to extend. The split between "chassis in `quality-standards.md`" and "fillable threshold tables in `claim-permission.template.md`" needs explicit documentation in the chassis itself (e.g., "fillable per-claim-type thresholds live in `claim-permission.template.md`") so a project running FX-B4 without FX-B5 yet present doesn't read the chassis as complete.
- **Concurrent-session reference-directory coupling.** WU4a is creating `language-search-blocks.template.md` in `workflows/research-workflow/reference/` in parallel. No file-level overlap with `quality-standards.md`, but if WU4a's session-end commit and FX-B4's session-end commit fire near-simultaneously, the operator must follow the concurrent-staging discipline (each session stages its own files by name, no `git add -A`). The change description acknowledges this.
- **Removed deferred-additions callout.** Lines 1–3 of the current chassis explicitly warn future editors to "read the current state first — do not author against a pre-existing baseline assumed to be canonical." Removing the callout removes a forward-warning for any project that already pulled the slimmed chassis. Low-impact (the warning's purpose is fulfilled the moment the additions land), but worth noting that any project that holds a copy of the pre-FX-B4 chassis with the callout intact will not be auto-migrated.

## Mitigations

- **Dimension 3 (Blast Radius — High).** Pre-write a heading-string allowlist before the edit: confirm the canonical chassis uses exactly `## Claim-Permission Classes`, `## Source-Diversity Matrix`, `## No-Source-Substitution Rule`, `## Country Coverage Table`, `## Research Stop Conditions`, `## Source-Conflict Resolution Procedure` (matching project file line 124, 150, 176, 206, 257, 272 verbatim). After the edit, grep the canonical file for each heading-string and confirm exact match; grep the 12 downstream consumers for the same strings and confirm no consumer references a heading the chassis omits. Defer commit until this two-way grep passes.
- **Dimension 3 (Blast Radius — High).** Mirror the four permission-class verb lists (line 184–189 of the project file) verbatim into the chassis. Do NOT rephrase, reorder, or summarize the verbs. `evidence-to-report-writer` and `chapter-prose-reviewer` consume these as exact-match enforcement targets per project line 191.
- **Dimension 5 (Hidden Coupling — Medium).** In the canonical chassis, mark the 30%/40% blocking-gate thresholds as **project-tunable defaults** (chassis-level note: "Default thresholds are 30%/40%; projects may calibrate after first production run. Calibration must be logged to `logs/decisions.md`."). Do not present them as canonical immutable values. This mirrors project file line 244 and prevents downstream projects from inheriting Nordic-PE-tuned numbers as canonical.
- **Dimension 5 (Hidden Coupling — Medium).** Add an inline forward-reference note in the chassis's Claim-Permission Classes section pointing to `claim-permission.template.md` (FX-B5) for fillable per-claim-type evidence thresholds. Phrase it as a deferred-content marker so projects running FX-B4 without FX-B5 in place don't misread the chassis as complete. Mirror the pattern used in `source-class-hierarchy.template.md` (which references its sibling `known-limits.template.md` at line 11 of the template).
- **Dimension 5 (Hidden Coupling — Medium).** End-time gate must verify zero project-token leakage in the chassis: grep the resulting file for `Sweden`, `Norway`, `Finland`, `Nordic`, `KPMG`, `EY`, `Argentum`, `PitchBook`, `Mergermarket`, `Preqin`, `€2–25M`, `H1 2025`, and any other Nordic-specific tokens that appear in the project source file. Same standard FX-B3 satisfied per CHANGE_DESCRIPTION's "zero project-token leakage verified."

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). No training-data fallback was used on fetch/read failures. Canonical chassis read in full (80 lines). Project source file read in full (302 lines). Downstream consumer grep enumerated across `ai-resources/workflows/research-workflow/` and `ai-resources/skills/` with line-level counts per consumer.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

Verified. The fail-closed dependency on exact heading strings (`## Claim-Permission Classes`, `## Source-Diversity Matrix`, `§ Country Coverage Table`, `§ Source-Conflict Resolution Procedure`) is real, and `claim-permission-gate` checks for parseability and exits with a named-missing-section prompt. This is a true two-end contract per `risk-topology.md § 5` ("change modifies a string literal matched by another component (two-end contract)"). I now have everything needed.

---

# Pre-change advisory — FX-B4 (extend canonical `quality-standards.md`)

## Position

We concur with the PROCEED-WITH-CAUTION verdict and with the five mitigations as the minimum bar. The change is structurally legitimate and necessary — the canonical file's own top-of-file callout already declares the deferred-additions debt the chassis closes — but the dimension review under-weights two risks the operator named (parser-surface fragility, chassis-vs-fillable split duplication) and misses one (writer ergonomics on the canonical template).

The right answer is: land the change with the five mitigations as specified, plus the four additions named below. Do not land it without them.

## Routing position

The file is at its canonical home and the change keeps it there. Canonical workflow reference docs belong in `ai-resources/workflows/<name>/reference/` (`repo-architecture.md` § Canonical homes — Workflow methodology row; DR-3). FX-B4 edits in place. No routing question.

The change is a structural class per `audit-discipline` and `risk-topology.md § 3` — "automation with shared-state effects" because canonical reference doc updates change what every downstream consumer sees on its next read. DR-8 applies; the two-gate firing model applies; the operator's plan-time gate has already fired (the risk-check report is on disk at `ai-resources/audits/risk-checks/2026-05-27-fx-b4-extend-canonical-quality-standards.md`). The end-time gate still owes a re-fire before commit.

## Architectural commentary

### (1) We concur with PROCEED-WITH-CAUTION — for the reason the verdict gives, not a softer one

The verdict is correct because this is a documented contract-gap closure on a load-bearing reference doc with a wide parser surface. Three observations re-weighted:

**Blast radius is High in the right way, not the catastrophic way.** The verdict says the change closes a documented gap rather than opens a new one. That framing is correct (the canonical file's own deferred-additions warning announces the intent). The blast radius is High because *every project that deploys research-workflow* sees the new chassis on its next read — but each project then re-templates the chassis through its own `{{PROJECT_TITLE}}` and per-claim-type thresholds, so the canonical change is a structural broadcast, not a behavioural one. (`risk-topology.md § 1 — High tier`; `system-doc.md § 4.4 — auto-sync symlink topology`.)

**Reversibility is Low for the right reason.** Once consumer SKILL.md files normalize to chassis heading strings, rolling back the chassis means coordinated rollback of N skill files. That is what makes the mitigation-1 pre/post-write grep load-bearing — not "checking for typos," but "preventing an asymmetric-rollback liability." (`risk-topology.md § 1 — Critical/High two-end contracts`.)

**Hidden coupling is Medium and we agree it is not High** — but only because the consumers cite section headings explicitly, not because the coupling is weak. The verbatim heading citations in `cluster-memo-refiner` Check 9 (`§ Claim-Permission Classes`, `§ Source-Diversity Matrix`, `§ Country Coverage Table`, `§ Source-Conflict Resolution Procedure`) and the fail-closed parser check in `claim-permission-gate` SKILL.md and `/run-sufficiency` Phase F make the contract visible. Visible contracts are recoverable when broken; hidden ones are not. (`risk-topology.md § 5 — "change modifies a string literal matched by another component (two-end contract)"`.)

### (2) The mitigation set is the right path. Four additions.

The five named mitigations cover the parser-grep two-end contract, the verb-list verbatim copy, the threshold tunability, the forward reference to FX-B5, and the project-leakage scan. That is the right shape. Four items the dimension review did not enumerate but the chassis edit needs:

**Addition M-6 — End-time grep must include the heading strings AS A LIST, not as ad-hoc tokens.** Mitigation 1 names "the 6 canonical section-heading strings." Land that list verbatim in the risk-check end-time gate text — six heading strings explicitly enumerated. Otherwise the end-time gate inherits the same fragility the chassis is trying to formalize: a parser surface that depends on the operator remembering all six headings at gate-fire time. Anchor the list in the risk-check end-time-gate report file itself, not in a transient session note. (`principles.md AP-1 — silent conflict resolution` applied to gate operation; `risk-topology.md § 5 — two-end contract enumeration must be explicit`.)

**Addition M-7 — Mark "deferred-additions warning removal" as a separate audit step.** The change removes the top-of-file callout that currently documents the chassis gap. Once removed, any future reader of the canonical file loses the signal that this file went through a controlled expansion. We recommend: replace the deferred-additions warning with a one-line "Source-pipeline chassis landed FX-B4 (2026-05-27); deferred items S-08/S-09/S-14/S-15/S-17/S-18 still pending — see project's v6 Post-R2 Review Trigger" pointer. Removing the callout entirely loses traceability. (`principles.md OP-3 — loud failure over silent continuation`: the callout is the load-bearing signal that this file is in a controlled-debt state.)

**Addition M-8 — Lock the "Generic chassis vs project-tunable" boundary in the chassis itself.** Mitigation 3 marks the 30%/40% thresholds as project-tunable. That is correct, but the chassis must encode where the project-tunable boundary is — otherwise the next consumer skill assumes any number in the chassis is canonical. The right form: a frontmatter block or top-of-file declaration enumerating which fields are tunable (`{{30_PERCENT_CLUSTER_THRESHOLD}}`, `{{40_PERCENT_SECTION_THRESHOLD}}`, etc.) and which are not (verb lists, section headings, structural rule statements). This is the same discipline the workflow template applies to `{{PROJECT_TITLE}}`. (`principles.md DR-7 — generalize only when a second confirmed consumer requires it`: making the tunability surface explicit is the cheapest insurance against speculative future divergence.)

**Addition M-9 — Defer the commit until WU4a concurrent-session interaction is resolved.** The operator names WU4a as editing the consumer skill files. The risk is `principles.md DR-10` directly: when concurrent sessions touch shared state, directory wildcards in `git add` are prohibited, and load-bearing files should not be edited in parallel without an explicit sequencing decision. The chassis change in `quality-standards.md` and the skill edits in WU4a both write inside `ai-resources/`. If WU4a runs concurrently, the post-write grep in mitigation 1 will produce a stale view (it greps consumer skills on disk, but the consumer set is being rewritten). Sequencing: land FX-B4 first, gate-fire end-time, commit; then start WU4a in a separate session against the new chassis. Do not run them in parallel. (`risk-topology.md § 1 — High tier` + `principles.md DR-10 — concurrent-session staging discipline`.)

### (3) On the operator's named risks

**(a) Parser-surface fragility from exact section-heading-string dependencies.** This is real and the verdict captures it. The architecturally cleaner solution would be a structured contract (frontmatter-declared section anchors that consumers query by ID, not by heading text). That refactor is correctly NOT in FX-B4's scope — it is a different change-class with its own risk profile. For FX-B4, the right path is what the verdict prescribes: explicit two-way grep against the enumerated heading list. The structured-contract refactor belongs in a separate `/risk-check` cycle when the verb lists stabilize across two or more projects. (`principles.md DR-7 — generalize when a second consumer confirms`: today there is exactly one project consumer set, so the structured-contract abstraction is premature.)

**(b) Should 12 consumers depend on heading strings rather than a structured/parseable contract?** Long-term, no. Short-term (FX-B4 horizon), yes — because changing the consumer-side contract is out of FX-B4 scope and would invalidate the mitigation set. The right answer is: heading-string dependence is technical debt acknowledged, not silently accepted. We recommend adding a `principles.md`-shaped item to the project's deferred-items log (`maintenance-observations.md` or the project's `improvement-log.md`) noting that the chassis-consumer contract surface is heading-string-typed and should be re-evaluated when the next workflow consumer (beyond research-workflow) needs the same rules. (`principles.md OP-11 — surfacing tacit principles is a recurring obligation`; AP-7 — speculative abstraction risk if refactored now without a second consumer.)

**(c) Chassis-vs-fillable split — duplication of contract surface across `quality-standards.md` and `claim-permission.template.md`.** This is the most under-weighted risk in the verdict. The operator's read is correct: putting permission-class semantics partly in the chassis (verb lists, gate thresholds, structural rules) and partly in a separate fillable template (per-claim-type evidence thresholds) creates two files where one contract used to live. The downstream risk is that a future edit to one diverges from the other — the verb lists drift, or the per-claim-type thresholds reference a permission class that no longer exists in the chassis.

The mitigation 4 forward-reference marker helps but is not sufficient. We recommend: the chassis declare a **canonical-ordering rule** — chassis is the source of truth for *class names* and *verb lists* and *gate semantics*; the template is the source of truth for *per-claim-type evidence thresholds only*. If a future change crosses that boundary in either direction, it requires `/risk-check` re-fire. Encode this rule in the chassis itself (one-line declaration near the Claim-Permission Classes section) and in the FX-B5 template. This makes the split safe by making the boundary visible. (`risk-topology.md § 5 — two-end contracts must be visible`; `principles.md AP-1 — silent conflict resolution` applied to cross-file rule drift.)

**(d) Concurrent-session interaction with WU4a.** Covered in Addition M-9 above. The verdict does not surface this; it should.

## Downstream impact

- **All projects deploying research-workflow** will inherit the new chassis on their next deployment. Active projects already using their own project-local `quality-standards.md` (e.g., nordic-pe-macro-landscape-H1-2026 at 302 lines) are unaffected at the file level but the canonical-template-vs-project-deployed delta widens. This is fine for now; the delta is a deliberate templating boundary, not drift. (`risk-topology.md § 2 — research-workflow consumers`.)
- **`claim-permission-gate`, `cluster-memo-refiner` Check 9, `/run-sufficiency` Phase F** continue to fail-closed on heading mismatch. Mitigation 1's two-way grep is the test that catches a regression before it surfaces in a downstream session. (`risk-topology.md § 1 — High tier two-end contracts`.)
- **Future workflow consumers (none today)** would adopt the same chassis. The chassis-vs-fillable split needs the canonical-ordering rule (Addition M-8 + the boundary declaration in operator-named risk (c)) before a second consumer arrives. (`principles.md DR-7`.)

## Clear position

The change is the right change. Land it with the five named mitigations plus the four additions:

- **M-6:** Risk-check end-time-gate text enumerates all six heading strings verbatim (not "the 6 canonical headings" as ad-hoc reference).
- **M-7:** Replace the deferred-additions warning with a one-line "chassis landed FX-B4; remaining S-XX items deferred" pointer — do not remove silently.
- **M-8:** Chassis declares which fields are project-tunable (`{{...}}` placeholders) vs. canonical-immutable (verb lists, headings, structural rule statements).
- **M-9:** Sequence FX-B4 before WU4a; do not run them concurrently. (`principles.md DR-10`.)

Plus the canonical-ordering rule named in operator-risk (c): chassis owns class names + verb lists + gate semantics; template owns per-claim-type evidence thresholds. Boundary declared in both files.

End-time `/risk-check` re-fires before commit. The two-gate model is the safety here — do not collapse it.

---

Files referenced:
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md` (canonical chassis target — 81 lines, current state)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-27-fx-b4-extend-canonical-quality-standards.md` (risk-check report on disk)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md` (fail-closed parser consumer — verified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md` (Check 9 heading-string consumer — verified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md` (Phase F heading-string consumer — verified)
