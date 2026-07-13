# Research Workflow — Pre-Deployment Fitness Audit for the Sector Intelligence Programme

**Date:** 2026-07-13 (Session S8) · **Auditor:** Claude (read-only; five area subagents + main-session adjudication)
**Audit subject:** `workflows/research-workflow/` + `.claude/commands/deploy-workflow.md`, at worktree baseline `9992b06` (verified workflow-file-equal to `main` at `849ff8a`; the delta touches only `prime.md` and logs)
**Programme source:** operator-supplied context pack `axcion-sector-intelligence-programme-v3.md` (v3, 13 July 2026)
**Trace target:** `audits/working/research-workflow-fitness/00-programme-operational-contract.md` (15 hard requirements HR-1…HR-15, 4 soft SR-1…SR-4)
**Working notes:** `audits/working/research-workflow-fitness/01…05-*.md` (full per-area evidence with file:line citations)
**Model boundary:** the audit ran on Fable; every fitness judgment below is against the commands' declared Opus/Sonnet routing. No inspected component declares a Fable/Haiku tier or a `[1m]` suffix; no finding depends on Fable-specific behavior.
**Repo `AGENTS.md`:** absent at this baseline (exists only as uncommitted work in the sibling main checkout — reported as a path fact, not a workflow defect).

---

## 1. Verdict

**`FIX CANONICAL WORKFLOW BEFORE DEPLOYMENT`**

Four canonical fixes and three deployment-command fixes are required first (§4). One of the required canonical fixes (C-1) is an unconditional runtime deadlock that would stop the very first research unit at Stage 3 in **any** deployed project — this alone forces the verdict. Alongside the fixes, one operator decision (F-5, execution model) must be made before deployment because it determines the per-unit workload and whether one further canonical build joins the list. Everything else is ordinary project configuration (§5) or visible-but-non-blocking (§6).

---

## 2. Supported requirements

The following programme requirements are supported by the workflow as it stands, verified against the executing files (not summary docs):

- **§8.5 / HR-12 — no claim-level evidence labelling — COMPATIBLE, no canonical conflict.** The evidence machinery (Claim IDs, four permission classes, per-type thresholds, sufficiency gates, source-diversity matrix) runs as an invisible internal control: Claim IDs are written by subagents (never the operator), the "must be labeled in prose" rule resolves to hedged prose wording and inline caveats — not tier tags — and `cluster-synthesis-drafter` (§15 two-field rule, SKILL line ~128) explicitly **forbids** surfacing permission labels in operator-facing output. On the output side, `citation-converter` strips Claim IDs, `chapter-revision-applier` strips working markers, and Stage 5 "decontamination" targets AI-prose patterns, not labels. The final deliverable carries citations and per-module `## Sources` (which §8 of the pack wants) and no tier labels (which §8.5 dropped). One deployment-time confirmation: `reference/quality-standards.md:36–43` still declares a dormant four-tier "Evidence Calibration" scheme no Stage-3 writer consumes — leave it inert (see §5).
- **HR-9 — human completion authority.** No pipeline step self-declares completion. Every stage ends at an operator gate; Stage 4 chapter approval is a signed marker file (`-OPERATOR-APPROVED.md`, written only on the operator's literal `approved`); Stage 5 ends at a final operator review. The missing piece is a *report-level* completion artifact, which is a project convention, not a defect (§6).
- **HR-11 — source standards.** `source-class-hierarchy.template.md` expresses the pack's three tiers as per-evidence-need ladders (strongest class + fallbacks); caution-class sources are gated at prompt design (`research-prompt-creator` bans advisory-as-primary) and by ladder-depth downgrades; Stage 2 halts loudly if the hierarchy file is absent. Instantiating the template is sufficient project configuration.
- **HR-1 — intake.** The programme context pack enters as the source the operator (with Claude, in-session) drafts each per-unit task plan from; `research-plan-creator` then consumes the approved Task Plan at the existing operator gate. No dedicated pack-consumer component exists or is needed — the F-15 project-side scoping preamble (§5 item 1) is what makes the hand-off checkable.
- **HR-4 — optional-bank pruning (report-validity side).** Nothing marks a report deficient for omitting optional questions. The plan-creator's consolidation log is an internal record inside the plan artifact, not operator labelling work and not a report gate — no conflict with "omission requires no justification."
- **HR-6 — one buyer lens** is expressible as project configuration (task-plan + section directive content); nothing in the pipeline demands dual-lens coverage.
- **HR-15 — cross-unit comparability** follows from fixed project config + a declared outline once C-2 lands.
- **Pipeline integrity generally:** all 30 skills the template references exist in `skills/`; the four-pass separation (finder ≠ judge ≠ writer) is implemented as described; stage-entry reference gates fail loud (hard) or disclosed (soft), never silent; `settings.json` is valid JSON with a permissions block and no `model` field; all 30 template-local commands declare explicit Opus/Sonnet `model:` frontmatter; the shared-manifest's `shared` entries all resolve to real files.

---

## 3. Findings

Ordered most severe first. Classes: **CD** canonical workflow defect · **MC** missing reusable canonical capability · **DD** deployment-command defect · **PC** ordinary project configuration · **PR** project-only requirement · **OD** operator decision.

**F-1 · HIGH · CD — Pass 3 deadlocks on a broken path contract (verified by direct read).**
`run-cluster.md:36` writes refined memos to `/analysis/cluster-memos/{section}/…-memo-refined.md`. But `claim-permission-gate/SKILL.md:49,151` and `country-parity-checker/SKILL.md:39,130` declare their required input as `analysis/{section}/cluster-memos-refined/` — a directory nothing creates — and both **pre-flight-verify it and exit** with "run `/run-cluster` first" if absent. Failure mode: first `/run-sufficiency` of the first research unit exits at Phase A even though `/run-cluster` completed; re-running as prompted loops forever. Affects every deploying project. Smallest remedy: align the two SKILL input contracts to the path `run-cluster` actually writes (2 files, ~4 lines).

**F-2 · HIGH · MC — the seven-section mandatory core (HR-3) cannot be imposed or checked anywhere.**
`research-structure-creator/SKILL.md` (Document Function Declaration) *derives* structure from the evidence — a 4–6 reader-question inventory, hard-capped at 6, with instructions to **split the document** when more emerge — and accepts no input for a declared outline. The defect is derive-not-impose: the programme needs a fixed 7-section outline imposed up front, and nothing can receive it. `report-compliance-qc/SKILL.md:32–41` checks chapters only against the pipeline's own derived `architecture.md`; `document-integration-qc` checks glosses/markers. Net: no component can verify "all seven core sections present," so HR-9's only hard gate has no mechanical anchor. Smallest remedy (canonical): give `research-structure-creator` a declared-outline mode — accept an operator-declared architecture (from project config or a reference file) and validate instead of derive; `report-compliance-qc`'s existing Cat-1 architecture-conformance check then becomes the HR-3 completeness check for free. (HR-8's verdict enum then lives in the declared outline's Section-7 directive — see §5.)

**F-3 · HIGH · CD — structural bias against valid negative findings (HR-5).**
There is no supported-negative path: absence-of-interest evidence is tagged NO-EVIDENCE → NOT-SUPPORTED; a genuinely negative unit therefore accumulates NOT-SUPPORTED ratios that make `run-sufficiency` Phase F **BLOCK** the section, routing the operator toward Stage-2 loops hunting evidence that doesn't exist, with `OPERATOR-OVERRIDE` the only clean exit. The pack's §5.5 makes "no credible buyer interest" a first-class outcome. Smallest remedy: let `claim-permission-gate` classify an evidenced negative (exhausted source ladder + scarcity-register support) as SUPPORTED-NEGATIVE (or SUPPORTED with negative polarity), and exclude such claims from Phase F's NOT-SUPPORTED ratios. Full trace: working note 03, HR-5 section.

**F-4 · HIGH · DD — fresh deploy commits the operator's machine-specific path (verified: `.gitignore` is one line, `.DS_Store`).**
`deploy-workflow.md` Step 4 writes an absolute workspace path into `{PROJECT_DIR}/.claude/settings.local.json` and asserts the file must be gitignored; the template's `.gitignore` doesn't cover it and nothing adds the entry; Step 9 then runs `git init && git add -A`. Every fresh deploy ships a file that breaks the project on any other machine — the exact defect the command's own rationale paragraph (line ~209) exists to prevent. Smallest remedy: add `.claude/settings.local.json` (and `logs/scratchpads/`) to the template `.gitignore`.

**F-5 · HIGH · OD — execution model: the pack's §6 does not match the workflow (silent policy conflict, now surfaced).**
Pack §6: "Research is performed by Claude… Claude then executes the research." Canonical Stage 2: the **operator manually runs** Research Execution GPT and Perplexity sessions (`stage-instructions.md:51` Step 2.2 `[Operator]`; ~2 heavyweight external-session steps per unit plus reviews), and the template's cross-model rules bar Claude from producing evidence itself. An API relay (`execution-agent`) exists but is deliberately unwired for Stage 2 (only `verify-chapter` uses it). Decision required before deployment: **(a)** accept the manual model for the pilots and correct the pack's §6 wording (recommended — proven path, no build); **(b)** commission canonical wiring of `execution-agent` into Stage 2 (a real build — becomes fix C-5); **(c)** revise the programme's role table. Not decidable by the audit.

**F-6 · MED-HIGH · CD — no fact/citation verification is wired into the pipeline.**
`verify-chapter` exists (GPT-5 relay via `execution-agent`) but `run-report` never invokes it — stage-instructions' Stage 4 sequence (Steps 4.1–4.7) omits it entirely, so the template CLAUDE.md's own cross-model rule ("Research Execution GPT verifies Claude's prose — Claude does not fact-check its own writing") is a promise with no mechanical trigger. It also ignores the `Verification posture` config field the schema names it a consumer of (phantom-consumer #2), and its confidentiality gate is a model-performed scan, not deterministic. Context that raises materiality: the long-deferred R1 citation-fidelity-audit subagent (deferred 2026-04-24) is confirmed absent, so an unwired `verify-chapter` leaves **zero** wired post-drafting citation/fact control — for a programme feeding external thought-leadership content, that is the wrong place to be thin. Smallest remedy: add a verify-chapter step (operator-gated) to `run-report`'s per-chapter sequence; either implement its `Verification posture` read or correct schema row 8. R1 itself stays deferred (mission thread, not a deployment gate).

**F-7 · MED-HIGH · MC — §8.4 internal-research reuse has detection but no ingestion.**
`run-preparation` Step 3c classifies internal-import RQs and diverts them to a "firm-held intake" that does not exist anywhere in the repo (grep-confirmed) — no mechanism carries a prior Axcíon report into extracts/memos. Nothing forces re-validation only because internal sources never enter at all. Bites from research unit 2 onward (pilot unit 1 has nothing to import), so it is **not** a deployment blocker, but it is the programme's cumulative-KB premise. Remedy: build the internal-import ingestion path (mission thread; canonical — any multi-unit or KB-fed project needs it).

**F-8 · MED · MC — disconfirmation search is deferred, weakening HR-7.**
Phase B (`counter-search-runner`) is deferred canonical-wide; what remains is a loud `disconfirmation_tested:false` disclosure plus contradiction-processing of tensions already in the evidence. A unit whose gathered evidence happens to contain no tensions yields no counterarguments and still clears. §5.8 says "a report that finds no counterarguments has not looked." Project-side mitigation exists (mandate §5.8 content in the Section-6 directive — see §5); completing Phase B is the structural fix (mission thread).

**F-9 · MED · DD — deploy deletes SETUP.md without carrying its unfinished obligations.**
Step 10 deletes SETUP.md after placeholder replacement, but SETUP §5d/§8b obligations (instantiate `known-limits.md`, `source-class-hierarchy.md`, `stage-5-paths.md`, `claim-permission.md`; fill the fact-verification prompt; provide `source-map.md`) are not restated in Step 11's "Next steps." Runtime gates catch `stage-5-paths` (hard) and `claim-permission` (disclosed soft); `known-limits.md`'s documented failure mode is **silent** drift. Smallest remedy: extend Step 11's next-steps block with the six-item instantiation checklist (or defer SETUP.md deletion until they're done).

**F-10 · MED · DD — placeholder discovery misses half the placeholders; python3 unchecked.**
Step 5's pattern `{{[A-Z_]*}}` misses 65 of 128 actual placeholders (any with digits/lowercase, e.g. `{{CLAIM_TYPE_3}}`) — self-healing only if the agent runs Step 7's broader leftover check; and Step 4 uses `python3` for symlink-path computation with no existence check (unlike `jq`, checked twice), so a python3-less machine gets silently broken symlinks. Smallest remedy: widen the Step 5 pattern to `{{[A-Za-z0-9_]+}}`; add a `command -v python3` guard.

**F-11 · MED · CD — two dead guards ship with every deploy.**
`check-claim-ids.sh` is fully built but registered in no settings.json event — it never fires anywhere. `friction-log-auto.sh`'s documented PostToolUse branch ("C6 repair", header says fixed 2026-06-12) is dead code — the script is registered only on PreToolUse/Skill. Neither blocks a deploy (silent no-ops); both are wiring lies that future sessions will trust. Remedy: register or remove (mission thread).

**F-12 · MED · PC — country-parity produces structural noise on single-country projects.**
`country-parity-checker` has no single-country bypass; with Country set `[FI]`, every cluster reports `FINLAND-DOMINANT` (share = 1.0) and every section is spuriously CLEARED-WITH-CAVEATS. Configuration suppresses it — see §5 proposed values (dominance threshold > 1.0, thinness 0, keeping PAN-NORDIC leakage detection live). A canonical presence-gate (`len(country_set)==1` → skip dominance/thinness) would be cleaner but is not required when config solves it.

**F-13 · LOW-MED · CD — documentation/wiring drift bundle (schema rows and stale references).**
(a) `project-config-schema.md` row 12 names `produce-knowledge-file` as the `Delivery vault` consumer — the command never reads it (hard-codes `output/knowledge-files/` + manual Chat upload); row 8's `verify-chapter` consumption is also unimplemented (see F-6). (b) `known-limits.md` is treated hard-class by `run-cluster` but soft-class by `run-sufficiency`. (c) `qc-gate.md`'s routing table references a non-existent `/run-final`. (d) `shared-manifest.json` omits three real template-local commands (`consult`, `run-sufficiency`, `session-plan`) from both `local` and `shared`, so `auto-sync-shared.sh` can't restore them if deleted. (e) canonical vs template-local `knowledge-file-producer` diverge only by stripped `model:`/`effort:` frontmatter — the template-local copy dispatches QC unpinned. Individually small; bundle into one fix session (mission threads).

**F-14 · LOW · PC→watch — the 12-question hard ceiling may under-fit a 7-section core plus optional bank.**
`research-plan-creator/SKILL.md` Step 7 hard-caps plans at 12 questions (verified). For a unit that must cover seven mandatory sections, that is ~1.7 questions per section before any optional-bank selection. Not provably broken — the programme prizes compactness (§4.3) — so: run pilot 1 against the cap and make the ceiling configurable only if it demonstrably binds (three-project test would pass, but "demonstrated runtime gap" is not yet demonstrated).

**F-15 · MED · PC — the scoping step (HR-2) has no canonical home and must be installed project-side.**
No component proposes a research unit or applies the §4.2 similarity test (grep-confirmed across workflow + skills); the pipeline assumes the unit is already chosen when the operator writes the task-plan draft. Config solves it: make the project's Stage-1 entry (project `stage-instructions.md` + a task-plan-draft template) require a scoping preamble — proposed unit, similarity-test reasoning, lens choice (HR-6), pruning record (HR-4 selection) — reviewed at the existing Task Plan gate. Kept project-local deliberately: scoping judgment is programme content; a canonical scoping stage fails the "named downstream consumer" test today.

---

## 4. Canonical and deployment-command fixes required before deployment

Only these seven. Each canonical fix passes the three-project test (multi-country PE market study / single-country technical-sector report / non-M&A policy study) — noted per fix.

**C-1 (F-1) — align Pass-3 input paths.** Config insufficient: paths are hardcoded in two SKILL bodies. Three-project test: all three run Pass 3; all three deadlock. Acceptance test: in a scratch project, run `/run-cluster` then `/run-sufficiency`; Phase A and Phase C pre-flights pass and produce permission/parity tables.

**C-2 (F-2) — declared-outline mode for `research-structure-creator` (+ compliance-qc reuse).** Config insufficient: the derive logic and 6-cap are in the skill; no input accepts a fixed outline. Three-project test: client-mandated TOC (PE study), regulator-mandated sections (technical report), commissioning-body outline (policy study) — all need impose-not-derive. Acceptance test: with a declared 7-section outline in project reference, `architecture.md` reproduces exactly those sections, and deleting one chapter makes `report-compliance-qc` fail Cat-1 naming the missing section.

**C-3 (F-3) — supported-negative claim path + Phase F exclusion.** Config insufficient: permission classes and the NOT-SUPPORTED ratio formula are canonical logic; no threshold value converts an evidenced negative into a supported finding. Three-project test: "is there a viable market" (PE), "does the capability exist domestically" (technical), "did the policy have an effect" (policy) — all can be evidenced negatives. Acceptance test: a synthetic unit whose extracts document an exhausted source ladder and absence findings yields a SUPPORTED negative claim and a Phase F verdict of CLEARED without `OPERATOR-OVERRIDE`.

**C-4 (F-6) — wire `verify-chapter` into `run-report`; reconcile `Verification posture`.** Config insufficient: the stage sequence is canonical, and the template CLAUDE.md's cross-model rule promises verification that nothing triggers — a silent policy conflict in every deployed project. Three-project test: all three carry the same cross-model rule. Acceptance test: `run-report`'s per-chapter sequence includes a verify-chapter step (operator-gated), and either the posture field observably changes its behavior or schema row 8 is corrected to remove the phantom consumer.

**D-1 (F-4) — template `.gitignore` covers `.claude/settings.local.json` + `logs/scratchpads/`.** Acceptance test: fresh deploy → `git ls-files` in the new project shows neither.

**D-2 (F-9) — carry SETUP.md's post-deploy obligations into deploy Step 11.** Acceptance test: fresh deploy output names all six instantiation items with template paths.

**D-3 (F-10) — widen Step 5's placeholder pattern; guard python3.** Acceptance test: placeholder census after Step 7 returns zero on a fresh deploy; deploy on a PATH without python3 fails loudly before creating symlinks.

Conditional: **C-5** — if F-5 resolves to option (b), wiring `execution-agent` into Stage 2 becomes a required canonical build with its own design pass ( `/risk-check` class). Not costed here.

---

## 5. Keep project-local

These must NOT be generalized into the canonical workflow. Proper home in parentheses; all values below are **proposals for the operator's decision, not settled configuration**.

1. **Scoping preamble + similarity test + lens choice + pruning record** (project `stage-instructions.md` Stage-1 entry + task-plan-draft template) — F-15/HR-2/HR-6/HR-4.
2. **The seven-section core as the declared outline**, with Section 6 directive mandating §5.8 counterargument content and Section 7 directive mandating the Core/Adjacent/Selective/Avoid verdict + recommended use + open items (project reference file consumed via C-2; directives per section) — HR-3/HR-7/HR-8. A policy study would declare a different outline; the enum is programme content.
3. **Proposed pilot Project Config block** (project CLAUDE.md `## Project Config`): Report set `[r1]`; Section IDs `[1.1]` (one pipeline section per research unit, growing per unit); Country set `[FI]`; Country superset `[FI, SE, NO, DK]`; Languages `[fi, sv]` (both language blocks must be authored or S-04 halts); Deal-size lens — operator supplies; Domain `"private equity"`; Verification posture `"lighter-than-formal"`; Source-availability `"public-only"`; Research-area-phrase e.g. `"Finnish industrial and technology subsectors relevant to Nordic private-equity and strategic buyers"`; Current period `"2025-2026"`; Delivery vault — omit; Document model `"section"` (one compiled document per unit — validate this mapping in pilot 1; `"report"` mode is the fallback shape).
4. **Country-parity calibration** (project `claim-permission.md`/parity config): dominance threshold > 1.0, thinness 0 — suppresses single-country noise while keeping PAN-NORDIC leakage detection (F-12).
5. **`claim-permission.md` per-claim-type rows** — author pilot values, or knowingly run the disclosed GENERIC-BAR regime for pilot 1; Phase F ratios: pilot defaults 30% cluster / 40% section are acceptable.
6. **Evidence-calibration block stays inert** — do not re-activate `quality-standards.md`'s dormant four-tier scheme when instantiating; set `{{EVIDENCE_CALIBRATION}}` to a §8.5-consistent note (no claim-level labelling).
7. **Daniel's KB approval + completion convention** (project CLAUDE.md process section): completion = operator's declaration at the Stage-5 final gate, recorded in the project log; Daniel's approval is a manual step before anything enters the knowledge base; knowledge-file step deferred until §13.2 is confirmed — HR-9/HR-10. No canonical second-approver machinery is justified (no named downstream component).
8. **Themes-as-hypotheses note** (project CLAUDE.md, one line: the twelve §3.3 themes are hypotheses; reports may confirm/qualify/reject) — SR-1.
9. **Confidentiality boundaries** — likely "No confidentiality constraints for this project." (public-sector research), operator confirms; fill `fact-verification-prompt.md` per SETUP §8b.
10. **External-tool setup facts** (project SETUP note): Research Execution GPT + evidence-pack-compressor CustomGPTs, Perplexity access, GPT-5 API key for `verify-chapter` — required regardless of the F-5 decision; currently documented nowhere at the template surface.

## 6. Unresolved but non-blocking — preserve visibly for the pilot

- **F-5 decision output** — if (a), correct pack §6 wording so the record matches the runtime (operator runs research sessions; Claude plans, extracts, adjudicates, drafts).
- **Pack §13.1** — what an Avoid verdict does downstream (report content unaffected).
- **Pack §13.2** — KB location confirmation; gates the knowledge-file/vault step only (F-13a makes the current field a no-op anyway).
- **Pack §13.3–13.5** — effort/timeline, "differentiated content" bar, kill criteria: no workflow dependency found.
- **F-7 (§8.4 ingestion)** — must exist before research unit 2; not before pilot 1.
- **F-8 (Phase B)** — Section-6 directive mitigation carries pilot 1; canonical counter-search remains the structural answer.
- **F-11 (dead guards)** — `check-claim-ids.sh` and the friction-log PostToolUse branch never fire; silent no-ops, fix in the follow-up mission.
- **F-13 (doc/wiring drift bundle)** — phantom schema consumers, class conflict, stale references, manifest omissions; one bundled fix session in the follow-up mission.
- **F-14 (12-question cap)** — collect the pilot-1 signal before making the ceiling configurable.
- **Report-level completion marker** — pilot with the log-entry convention (item 7 above); revisit a canonical marker only if the convention fails.

---

*Method note: five read-only subagents traced the programme contract through the executing files (commands, skills, agents, hooks, settings — not summary docs); the main session independently spot-verified the verdict-driving claims (F-1 paths, F-2/F-14 caps, F-4 gitignore) by direct read. Full evidence: `audits/working/research-workflow-fitness/00–05`.*

---

## 7. Post-audit triage addendum (2026-07-13, same session)

The operator submitted an external critical review; every checkable claim in it was verified against the files and the triage below is now the **governing state**. Sections 1–6 above stand unchanged as the original record.

**Verified corrections to the original findings:**
- **F-2/C-2 overstated.** `research-structure-creator/SKILL.md:121–134` admits sections owning zero reader questions (Support / Future-State), so a 7-section architecture is reachable without a canonical build; `run-report.md` Step 4.1.6 gates the architecture at the operator. C-2 becomes **conditional** — build declared-outline mode only if pilots show repeated architecture drift.
- **F-3/C-3 conflated two things.** An evidenced negative ("subsector unattractive") already builds from SUPPORTED claims about weak activity/economics; genuine absence-of-evidence should stay cautious, which matches §5.5's actual wording. A new permission class would touch several downstream skills — not the "smallest remedy" claimed. Downgraded to a **trigger-gated watch**: if Phase F BLOCKs an honest negative in a pilot, log it; second occurrence reopens the thread. The documented `OPERATOR-OVERRIDE` (run-sufficiency.md §Operator-override) is the interim path.
- **F-4/D-1 false for this environment.** `~/.config/git/ignore` line 1 (`**/.claude/settings.local.json`) covers every repo on this machine — verified via `git check-ignore -v`. The generic portability defect stands; the "every fresh deploy commits it" claim does not hold here. Deferred to the first fix batch (one-line fix; `logs/scratchpads/` ride-along dropped).
- **F-10/D-3 was more serious AND the audit's remedy was wrong.** All 65 broad-only placeholders are template-internal (7 template/config files) and must NOT be filled at deploy; widening the Step-5 regex would demand them prematurely and Step 6/7 could sed-corrupt the `.template.md` shapes. Step 7's existing leftover check (`grep -r '{{'`) already hits 6 template files today. Corrected remedy: **explicit deploy-time placeholder list + exclude `*.template.md` and later-stage files from replacement and zero-leftover validation** (this also captures `{{CONFIDENTIAL_IDENTIFIER_N}}` in CLAUDE.md, a genuine deploy-time placeholder the narrow pattern misses).
- **C-4 deferred with a written-trigger condition.** Manual `/verify-chapter` before KB approval / external reuse is acceptable for the pilot **only as a written step** in the pilot project's gate checklist — not a remembered one (memory-dependent gates are this workspace's most-documented failure mode). Canonical wiring stays a mission thread.
- **F-5 resolved: option (a).** Manual Stage-2 execution model confirmed for pilot 1; programme pack §6 wording to be corrected to match the runtime. C-5 (Stage-2 automation) is not built.
- **F-12:** accept the harmless CLEARED-WITH-CAVEATS noise for the pilot; no >1.0 threshold hack as standing config; presence-gate stays a low-priority thread.

**Revised required-before-deployment list (supersedes §4):**
1. **C-1 — align the two Pass-3 skill input paths** to `analysis/cluster-memos/{section}/` (canonical; 2 files; acceptance test unchanged).
2. **D-3′ — deployment placeholder scoping** per the corrected remedy above (deployment-command; acceptance: fresh deploy fills only deploy-time placeholders, `.template.md` shapes survive byte-identical, leftover check passes).

**Before research begins (project-local, written into the pilot project):** scoping preamble + §4.2 similarity test in the task plan; 7-section checklist enforced at the architecture gate; ≥1 explicit disconfirmation question per unit; manual `/verify-chapter` step in the pre-KB gate checklist; §8.5-consistent evidence-calibration note; manual research operating model recorded (Claude plans/extracts/adjudicates/writes; operator runs external research sessions).

**Everything else** moves to the follow-up mission as deferred threads with named triggers (F-7 before research unit 2; C-2/C-3/F-14 evidence-gated on pilot signals; D-1, D-2, python3 guard, C-4 wiring, F-11, F-13, F-12 as batched cleanups).
