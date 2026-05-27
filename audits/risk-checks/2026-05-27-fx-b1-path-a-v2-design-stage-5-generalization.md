# Risk Check — 2026-05-27

## Change

Evaluate the FX-B1 Path A v2 design contract at `projects/nordic-pe-macro-landscape-H1-2026/plans/fx-b1-path-a-design-v2.md` against the five risk dimensions.

**What is being proposed:** Generalize three canonical Stage 5 commands (`produce-prose-draft`, `produce-formatting`, `produce-jargon-gloss`) at `ai-resources/workflows/research-workflow/.claude/commands/` to support both report-based (R1/R2/R3 — nordic-pe project model) and section/part-based (2.4 / 3.1 — buy-side-service-plan model) document architectures from a single canonical file per command. Driven by FX-B7's `## Project Config` schema (landed 2026-05-27) plus a new schema field #13 `Document model:` and a new workflow-reference doc `reference/stage-5-common-phases.md` for shared phase definitions. Project-side `reference/stage-5-paths.md` declares path templates per project.

**Concrete artifacts that will be created/modified at implementation time (next session):**
- `ai-resources/workflows/research-workflow/docs/project-config-schema.md` — add field #13 + consumer-fan-out entries
- `ai-resources/workflows/research-workflow/CLAUDE.md` — add `Document model:` placeholder to `## Project Config` block
- `ai-resources/workflows/research-workflow/reference/stage-5-common-phases.md` — NEW canonical reference doc (Decontamination, Jargon Gloss, Handoff phase definitions)
- `ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md` — NEW canonical template (path-config template for projects to instantiate)
- `ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md` — Path A structural edit (smallest delta)
- `ai-resources/workflows/research-workflow/.claude/commands/produce-formatting.md` — Path A structural edit
- `ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md` — Path A structural edit (largest delta)
- `projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md` — add `Document model: "report"` to `## Project Config`
- `projects/nordic-pe-macro-landscape-H1-2026/reference/stage-5-paths.md` — NEW project-side instantiation (report-mode)
- `projects/nordic-pe-macro-landscape-H1-2026/plans/finish-fix-phase-plan-v1.md` — append one-line phase-spec-staleness note to § Step 2

**Critical context for risk evaluation:**
- The System Owner already reviewed v1 and surfaced 2 blocking + 3 note concerns. v2 applies all 5.
- Currently the canonical commands are consumed by 2 projects (nordic-pe via project copies; buy-side-service-plan via project copies). FX-D1 will swap project copies to symlinks AFTER each project completes its per-project migration sub-step.
- Both projects continue to invoke their project-copy versions during Path A landing (no immediate symlink swap).
- Per FX-B7 contract-inheritance rule, FX-B1 must run plan-time `/risk-check` PER PARSER-BATCH before consumer wiring.
- This `/risk-check` covers the Stage 5 commands batch.
- The design v2 is the deliverable of THIS session. Implementation is the next session.
- The risk-check is on the DESIGN, not on raw edits.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fx-b1-path-a-design-v2.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fx-b1-path-a-design-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/finish-fix-phase-plan-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/fix-phase-plan-v1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/project-config-schema.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-jargon-gloss.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-formatting.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-5-common-phases.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-5-paths.template.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/reference/stage-5-paths.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** v2 substantially de-risks v1 (silent-failure path eliminated, mode discriminator hardened, shared-phase duplication factored out) but the change still touches canonical workflow commands consumed by two projects, with a multi-step cross-repo landing sequence that has known reversibility friction; the principal residual risk is implementation-time drift between the canonical command files and the new `stage-5-common-phases.md` reference doc.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The three Stage 5 commands are operator-invoked, not auto-loaded — they pay tokens only when used (`produce-prose-draft.md` line 1–9 frontmatter declares `friction-log: true, model: opus`; no auto-load hook). Generalization grows each file by ~10–20% (v2 design § Risk register row 1: shared-phase extraction caps growth at "~10–20%, not 30–50%") — a pay-as-used delta, not an always-loaded delta.
- The new canonical `reference/stage-5-common-phases.md` is load-on-demand (cited by command files as "See reference/stage-5-common-phases.md § <Phase Name>", v2 design line 110) — it is read only when a Stage 5 command runs, not on session start.
- The canonical workflow `CLAUDE.md` `## Project Config` block adds **one** new field (`Document model:`) — v2 design lines 49–51. Net always-loaded delta in canonical CLAUDE.md is one line (~80 chars). Project nordic-pe CLAUDE.md gets the same single-line addition. Net always-loaded token cost across both is roughly ~20–40 tokens. Below the Medium threshold (~50–150 tokens).
- No new auto-load hook, no new `@import` chain, no new frequently-spawned subagent brief. The plan-time `/risk-check` cadence is operator-discretionary per `audit-discipline.md` § When to fire, not a per-tool-call hook.
- The new `reference/stage-5-paths.md` (project-side) is read only by the three Stage 5 commands at invocation (v2 design § Phase 0 step 3) — load-on-demand, not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `settings.json` allow/ask/deny lists are proposed in the design or in the artifact list. v2 design § Implementation order (lines 244–256) names schema doc, common-phases doc, path-config template, project-side CLAUDE.md, project-side path-config — none touch permission files.
- No new tool family is introduced. The canonical commands continue to invoke the same skills (`/ai-resources/skills/decision-to-prose-writer/SKILL.md`, `prose-formatter/SKILL.md`, `jargon-gloss/SKILL.md`, etc. — verified via grep matches in existing canonical command files) and continue to write to the same kinds of paths (now interpolated from `reference/stage-5-paths.md` rather than hard-coded).
- No scope-escalation (project → user, etc.).

### Dimension 3: Blast Radius
**Risk:** High

- **Direct file touch count: 10** (v2 design lines 244–254; matches the artifact list in CHANGE_DESCRIPTION). Three canonical Stage 5 command edits + one canonical CLAUDE.md edit + one canonical schema-doc edit + two new canonical docs + one project CLAUDE.md edit + one new project ref doc + one parent-plan one-line append.
- **Direct active consumer count for canonical Stage 5 commands: 2 projects with 5 active project-copy command files** (verified by `find . -name "produce-{prose-draft,formatting,jargon-gloss}.md"`):
  - `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/{produce-prose-draft,produce-formatting,produce-jargon-gloss}.md` (3 files)
  - `projects/buy-side-service-plan/.claude/commands/{produce-prose-draft,produce-formatting}.md` (2 files)
- **Active consumers (non-log/non-audit/non-plan) referencing the three command names: 30 files** (grep `find -name "*.md" | xargs grep -l "produce-prose-draft|produce-formatting|produce-jargon-gloss"` filtered to exclude logs/audits/reports/plans/archives/bak). Most are project pipeline-snapshot or repo-documentation files that name the commands referentially, not as callers. But the 5 project-copy command files ARE callers and embed the document-model-specific pipeline shape today.
- **Contract changes**:
  - **Schema contract** (`docs/project-config-schema.md`) gets field #13 `Document model:` added and consumer-fan-out for `Verification posture` adds `produce-prose-draft` as a third reader (v2 design lines 186–187). Both are additive; existing consumers are unaffected. Backwards-compatible.
  - **Command invocation contract** (Phase 0): v2 design § Phase 0 contract halts loudly if `Document model:` is missing or if `reference/stage-5-paths.md` is missing or if the modes mismatch (lines 59–63). For the nordic-pe project, the project copies remain in use until FX-D1 — so the canonical contract change does not propagate to nordic-pe at Path A landing. For buy-side, same: project copies remain in use. **However, anyone who invokes the canonical command directly (e.g., a dry-run during pre-FX-D1 verification, or a new project that gets the canonical via symlink topology) will halt without the project-side `reference/stage-5-paths.md` and `Document model:` field in place.** The design's pre-merge dry-run mitigation (v2 design § Risk register rows 4–5) covers nordic-pe + buy-side specifically, but the workspace auto-sync hook (`ai-resources/.claude/hooks/auto-sync-shared.sh` per `repo-architecture.md` § Symlink topology) does symlink-distribute canonical commands to every project's `.claude/commands/` on SessionStart — except where the project has its own non-symlink copy at the target (rule 1: "Existing files at the target are never overwritten"). So projects with existing copies are protected; projects without copies (any future project) get the canonical and now require `Document model:` + `reference/stage-5-paths.md` to invoke any Stage 5 command. New-project workflow gains an implicit setup prerequisite.
  - **New contract: common-phases reference** (`reference/stage-5-common-phases.md`) — three commands cite phase sections by name. Drift between command-file references and the common-phases doc is a silent-failure surface. This is explicitly acknowledged in v2 design § Risk register row 10 ("Common-phases doc drift from command-file references") as a Medium new risk, with discipline-only mitigation ("any edit to a common-phase definition surfaces the consumer commands in the diff scope"). Discipline mitigation on a foreseeable drift surface is weaker than the structural alternative (e.g., a checker or a test).
- **Cross-repo nature**: The change spans `ai-resources/` (canonical edits) AND project `nordic-pe-macro-landscape-H1-2026/` (project-side instantiation + parent plan note). The dual-commit pattern is already established for this project (see Bundle 2a/2b in `nordic-pe/CLAUDE.md` line 17) but each commit pair is its own reversibility surface (see Dimension 4).
- **Wider radius on full graph**: `produce-prose-draft` referenced in 108 markdown files total across the repo (find+grep count); `produce-formatting` 100; `produce-jargon-gloss` 42. Most are log/audit/plan artifacts (read-only history). The 30-file active-consumer set above is the load-bearing slice.

Net: >5 active dependent files with one new contract (common-phases drift) whose only mitigation is discipline. Blast radius is High.

### Dimension 4: Reversibility
**Risk:** Medium

- The canonical command edits, schema additions, and new ref docs are all clean `git revert` targets within `ai-resources/`. The project-side CLAUDE.md edit and `reference/stage-5-paths.md` are clean revert targets within the nordic-pe project repo. Two-commit revert across two repos, but each is mechanical.
- **Friction point 1**: The new `reference/stage-5-common-phases.md` and `reference/stage-5-paths.template.md` are NEW files in the canonical repo. Revert removes them. But once nordic-pe's `reference/stage-5-paths.md` exists and other projects have started adopting the pattern, reverting the canonical template doesn't clean up the project-side files — they become orphans whose contract no longer has a canonical reference. Manual cleanup per affected project.
- **Friction point 2**: The `Document model:` field in nordic-pe `CLAUDE.md` is a single-line addition — clean revert. But the parent plan one-line append at `finish-fix-phase-plan-v1.md` § Step 2 is an append to a planning artifact; revert is mechanical but the operator's mental model ("phase-spec staleness was recorded") may not roll back as cleanly — they may still remember the framing change. Low-risk.
- **Friction point 3**: If FX-D1 runs after Path A and any project symlinks its `.claude/commands/produce-*.md` to canonical, reverting Path A on canonical breaks every symlinked project until they're re-pointed. v2 design § Implementation order step 12 sequences FX-D1 as a separate session AFTER Path A lands, which is correct, but the design does not propose a freeze window between Path A landing and FX-D1 starting where Path A could be revoked cleanly.
- No external push, no Notion write, no API POST. No always-firing hook installed.
- Net: clean within-repo revert per commit, but multi-step (two repos), with one structural orphan-file cleanup if reverting after instantiations have propagated. Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Coupling 1 (acknowledged, partly structured)**: command file → `reference/stage-5-common-phases.md` cited by section name. v2 design line 110 names the contract ("See reference/stage-5-common-phases.md § <Phase Name>") and v2 design § Mode-specific variation points (lines 122–124) names `{MODE-VAR-NAME}` placeholders. The contract is documented at the change site (the common-phases doc itself). However, drift detection is discipline-only (v2 design § Risk register row 10 — "Implementation-time discipline: any edit to a common-phase definition surfaces the consumer commands in the diff scope"). One Medium-coupling site whose mitigation is non-structural.
- **Coupling 2 (acknowledged, structured)**: schema field `Document model:` → three Stage 5 commands. Phase 0 reads it and halts loudly on missing/malformed (v2 design § Phase 0 contract step 1). Explicit, documented, fail-loud. Low.
- **Coupling 3 (acknowledged, structured)**: project-side `reference/stage-5-paths.md` Mode line MUST match CLAUDE.md `Document model:` value. Phase 0 step 3 halts on mismatch (v2 design § Phase 0 contract step 3). Single explicit contract, fail-loud. Low.
- **Coupling 4 (NEW, not fully named)**: workspace auto-sync hook + Path A canonical change. Per `repo-architecture.md` § Symlink topology, the auto-sync hook symlinks every `ai-resources/.claude/commands/*.md` into every project that has a `shared-manifest.json` and lacks an existing file at the target. For projects WITHOUT existing project-copy Stage 5 commands (any project beyond nordic-pe/buy-side), the auto-sync hook will distribute the new canonical Stage 5 commands on next SessionStart. Those projects will halt on first Stage 5 invocation unless their CLAUDE.md has `Document model:` and they have `reference/stage-5-paths.md`. The design does not enumerate which projects this affects today. Loud halt is the right semantics (better than silent fallback), but the implicit consumer-set widening is not surfaced. Medium-coupling site.
- **Coupling 5 (intentional, structured)**: `Verification posture` field gains a new consumer (`produce-prose-draft`). Schema-doc same-commit update is named (v2 design lines 186–187). Low.
- **No silent auto-firing in unexpected contexts**: all Stage 5 commands remain operator-invoked. The phase-spec-staleness note to the parent plan is a one-time write, not a recurring side effect.
- **No functional overlap with existing mechanisms**: `reference/stage-5-paths.md` is a new path-config artifact; no existing mechanism resolves Stage 5 paths.

Net: one fully-explicit-and-loud-halt contract chain, one discipline-only drift surface (common-phases doc), one implicit consumer-set widening via auto-sync. Medium.

## Mitigations

- **Dimension 3 (Blast Radius — High)**: Before landing the Stage 5 batch, verify the pre-merge dry-run protocol named in v2 design § Risk register rows 4–5 actually executes against BOTH nordic-pe and buy-side project copies (not just one). Concretely: in the implementation session, after the canonical `produce-jargon-gloss.md` edit lands but before `produce-formatting.md`/`produce-prose-draft.md` are touched, run a smoke-test invocation against (a) the canonical `produce-jargon-gloss.md` with nordic-pe's about-to-be-created `reference/stage-5-paths.md` (report-mode), and (b) the canonical `produce-jargon-gloss.md` with a constructed buy-side `reference/stage-5-paths.md` mock (section-mode). Confirm both halt cleanly on missing inputs and dispatch correctly on present inputs. If either dry-run surfaces a mismatch, halt the implementation session and re-plan.
- **Dimension 3 (Blast Radius — High)**: Add an explicit "implicit consumer-set widening" guard to the implementation order. Before Path A canonical commands are committed, enumerate (via `find projects -name "shared-manifest.json"`) every project that would receive the new canonical commands via auto-sync. For each project NOT already in scope (nordic-pe and buy-side are in scope), either (a) add `.claude/commands/produce-prose-draft.md` etc. to the project's `commands.local[]` opt-out list before canonical lands, or (b) accept that the project's Stage 5 commands will halt on first invocation until the project completes its own per-project migration sub-step. Document the choice in the commit message.
- **Dimension 5 (Hidden Coupling — Medium, drift surface)**: Strengthen the v2 risk-register row 10 mitigation from "discipline" to "checklist + grep at edit time". Concretely: add a one-line check to the common-phases doc header itself ("When editing this file, run `grep -l 'stage-5-common-phases.md § <Phase Name>' ai-resources/workflows/research-workflow/.claude/commands/` and re-read each match before commit"). Same-commit edit rule mirrors the `Country set` mirror rule already established in the schema doc.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION; mitigations listed above are sufficient to land safely.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line citations to `fx-b1-path-a-design-v2.md` (Phase 0 contract lines 59–63; Implementation order lines 244–256; Risk register table lines 193–204; Schema field reads lines 180–187; Common-phases content schema lines 107–120), `repo-architecture.md` § Symlink topology (auto-sync hook rules), `audit-discipline.md` § Risk-check change classes + § When to fire, `project-config-schema.md` (12-field table + consumer fan-out + canonical parse format), the three canonical Stage 5 command files (frontmatter and skill-read patterns), the nordic-pe and buy-side project `CLAUDE.md` + `.claude/commands/` directory listings (verified `produce-*.md` files exist as real files, not symlinks), and grep counts across 108/100/42 markdown files for the three command names (active-consumer subset = 30 files after excluding logs/audits/reports/plans/archives/bak). No training-data fallback used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — FX-B1 Stage 5 Generalization (Function B)

## 1. Routing position (per repo-architecture.md)

The three files being edited (`produce-prose-draft`, `produce-formatting`, `produce-jargon-gloss`) and the new `reference/stage-5-common-phases.md` doc live in the **workflow-canonical subtree** at `ai-resources/workflows/research-workflow/`. Per `repo-architecture.md` § Symlink topology, the SessionStart auto-sync hook walks **only** `ai-resources/.claude/{commands,agents}/`. It does **not** walk `ai-resources/workflows/<name>/.claude/`. Distribution to projects happens via `/deploy-workflow`, not auto-sync.

**This is load-bearing for evaluating Mitigation 2.** See § 4 below.

## 2. Concurrence on the verdict

We concur with PROCEED-WITH-CAUTION. The dimension profile (Blast High, Reversibility Medium, Coupling Medium) maps cleanly onto the change-class table in `risk-topology.md` § 3: "Canonical command/agent edit → All projects invoking it → /risk-check." Three canonical edits + a new contract (command ↔ common-phases doc) + a new schema field in every project CLAUDE.md is a structural change on `risk-topology.md` § 1 (High) infrastructure. Verdict shape is right.

## 3. The three mitigations — concurrence with one structural strengthening

**Mitigation 1 (dry-run after first canonical edit, before touching the other two) — Right.** This is the only loud-failure mechanism between plan-approval and broad blast. It operationalizes OP-3 (loud failure over silent continuation) (`principles.md § OP-3`) at exactly the moment when the assumption "v2 design works in practice" gets its first real test. Keep as proposed.

**Mitigation 2 (enumerate auto-sync consumers, opt-out via commands.local[]) — Wrong target.** See § 4 — there is no auto-sync consumer-set to enumerate for these files. The mitigation as written diagnoses a problem the topology doesn't have, and misses the actual one.

**Mitigation 3 (drift mitigation embedded in common-phases doc header) — Insufficient.** "Discipline-mirroring-discipline" is still discipline. See § 5 for the structural strengthening we recommend.

## 4. The "auto-sync widening" concern named in the report is misdiagnosed

The risk-check report says: *"an implicit consumer-set widening via the workspace auto-sync hook that the design does not enumerate."* This claim does not hold against `repo-architecture.md` § Symlink topology.

- `auto-sync-shared.sh` walks `ai-resources/.claude/{commands,agents}/`. The Stage 5 commands live in `ai-resources/workflows/research-workflow/.claude/commands/`. They are **not** in the hook's walk path.
- New projects that hold a `shared-manifest.json` will receive auto-synced canonical commands at SessionStart, but the three Stage 5 commands are not among them — they are only present in a project that ran `/deploy-workflow research-workflow` (`repo-architecture.md` § Distribution).
- Therefore the consumer set is exactly the projects that have explicitly deployed `research-workflow`. Per `risk-topology.md` § 2, those are the two named in the change brief (nordic-pe, buy-side).

**The operator's specific concern — "should new-project bootstrapping itself install `reference/stage-5-paths.md` + `Document model:`" — does not apply at v1.** That would be speculative generalization (`principles.md § DR-7 / § AP-7`): no third confirmed consumer exists. The right answer is the simpler one — at the moment `/deploy-workflow` runs for a future third project, the template arrives with the new schema field and the new ref doc as part of the template itself. No bootstrap change required.

**Drop Mitigation 2 as written.** Replace it with:

> **Mitigation 2 (revised) — Confirm exactly two consumers before merge.** Verify by direct filesystem check (`ls projects/*/.claude/commands/produce-prose-draft.md`) that the canonical Stage 5 commands are only present in `nordic-pe-macro-landscape-H1-2026` and `buy-side-service-plan`. Document the verified consumer set in the commit message. The auto-sync hook is not in the consumer path for these files.

This is the substantive correction the dimension review missed.

## 5. Mitigation 3 should be strengthened to a mechanical control

The risk the report flags — drift between canonical command files and the new `stage-5-common-phases.md` reference doc — is a **two-end contract** in `risk-topology.md § 5` terms: "Change modifies a string literal matched by another component (two-end contract)" is named as a signal that elevates a change to structural risk. The doc itself names `friday-checkup.md` source-label strings as the existing precedent.

A header note in the common-phases doc is the friction-log-style mitigation. It will not survive six months of QC-fix-driven canonical-command edits unless it is mechanically enforced. We recommend strengthening:

- **Add an anchor-format contract to the common-phases doc** (e.g., each shared phase has an `<!-- anchor: phase-X.Y -->` line that the canonical commands must reference verbatim). This makes drift detectable via a one-line grep in `/friday-checkup` weekly.
- **Add a Friday-checkup line that runs that grep** across both canonical commands and the common-phases doc, surfacing any phase ID referenced in a command but missing from the ref doc (or vice versa). One line in `friday-checkup.md` G/H/I scope.

This converts "discipline" (`principles.md § AP-1` failure mode — silent drift) into loud failure (`principles.md § OP-3`). It is the same pattern the Country-set same-commit mirror rule already uses; the report invokes that precedent and then under-applies it.

The alternative — a hook-driven check — is rejected for v1 on `DR-7` grounds (no second consumer for the hook). One grep in the Friday cadence is sufficient.

## 6. Reversibility-Medium → High after FX-D1

The operator's specific concern is correct. The risk-check-reviewer noted the FX-D1 symlink cascade in passing but kept the dimension at Medium. Once FX-D1 lands (which the change brief presumes), a revert of these three canonical commands becomes a multi-project breaking change rather than a single-repo file restore. That is the literal definition of High reversibility cost in `risk-topology.md § 3`'s implicit gradient (single-repo edit vs. cross-repo coordinated revert).

**Bump Reversibility to High.** This does not change the overall verdict (PROCEED-WITH-CAUTION already accommodates one High dimension and one upgrade); it changes the rollback playbook. Specifically:

- The "rollback recipe" item already on `repo-state.md § Pending Manual Steps` (#8, "Document rollback recipe for Phase 2 implementation," open since 2026-04-30) should be expanded to cover the Stage 5 generalization revert specifically, **before this change merges**, not after. A High-reversibility change without a tested rollback recipe is the failure mode `risk-topology.md § 4` "Change process" hard-constraints exist to prevent.

## 7. Risks the dimension review missed

1. **Symlink-target staleness in nordic-pe and buy-side after the canonical edit.** The two consumer projects already hold copies (per the change brief, `produce-{prose-draft,formatting}-v1-template.md.bak` archives exist in nordic-pe). The risk-check report does not enumerate whether nordic-pe's existing `produce-prose-draft.md` is a symlink, a copy, or a project-local fork. Symlink-vs-copy state determines whether the canonical edit propagates automatically (symlink) or requires a manual re-deploy step (copy). This must be verified pre-merge — same hard-constraint as `DR-9` top-3 analysis.

2. **CLAUDE.md schema field #13 (`Document model:`) is a cross-cutting CLAUDE.md edit by class.** Per `risk-topology.md § 3`, "Cross-cutting CLAUDE.md edit → /risk-check." The change brief frames this as a schema addition; in implementation it is N CLAUDE.md edits (one per project running the workflow). The change is small per-file but loads on every turn in every consumer project (`principles.md § DR-5`). Default value semantics for projects that don't set it must be specified explicitly — silent default selection on a load-bearing field is `AP-1` (silent conflict resolution).

3. **Implementation-session scope discipline.** The design landed in this session has clean boundaries; the follow-on implementation session is where scope creep typically lands during multi-step structural work. `principles.md § OP-9` (agentic-era ambition does not license speculation) and `AP-7` (speculative abstraction) apply specifically: the implementation session should not also ship `reference/stage-5-paths.md` bootstrapping into `/new-project` (the operator's question 1) unless a third deployment is approved in the same session.

## 8. Bottom line

The right answer is: **proceed with the revised mitigation set below.**

1. **Mitigation 1** as proposed (dry-run after first canonical edit, before the other two).
2. **Mitigation 2 (revised)** — confirm exactly the two known consumers via direct filesystem check; drop the auto-sync enumeration framing (the hook is not in the consumer path).
3. **Mitigation 3 (strengthened)** — anchor-format contract in `stage-5-common-phases.md` + one-line Friday-checkup grep across canonical commands and the ref doc.
4. **New: Mitigation 4** — verify symlink-vs-copy state of `produce-{prose-draft,formatting,jargon-gloss}.md` in nordic-pe and buy-side before the canonical edit. Document the propagation path per project in the commit message.
5. **New: Mitigation 5** — expand the standing rollback-recipe item (`repo-state.md § Pending Manual Steps #8`) to cover this change specifically, before merge.
6. **Reversibility** bumped Medium → High; verdict shape unchanged.

The implementation-time drift risk the report names as principal is real and is what Mitigation 3 (strengthened) targets. The auto-sync widening risk the report names is not real for this file location and should be replaced. The FX-D1 reversibility cascade the operator flagged is correctly identified and changes the rollback playbook, not the verdict.

---

**Citation summary:**
- Routing fact: `ai-resources/docs/repo-architecture.md` § Symlink topology + § Distribution
- Verdict shape concurrence: `risk-topology.md § 3` (Canonical command/agent edit blast radius)
- Mitigation 2 redirection: `principles.md § DR-7`, `principles.md § AP-7`
- Mitigation 3 structural strengthening: `risk-topology.md § 5` (two-end contract elevation signal), `principles.md § OP-3`, `principles.md § AP-1`
- Reversibility bump: `risk-topology.md § 3` (implicit blast/reversibility coupling)
- Missed risk 1: `principles.md § DR-9` (top-3 analysis before structural change)
- Missed risk 2: `risk-topology.md § 3` (CLAUDE.md cross-cutting edit class), `principles.md § DR-5`, `principles.md § AP-1`
- Missed risk 3: `principles.md § OP-9`, `principles.md § AP-7`
