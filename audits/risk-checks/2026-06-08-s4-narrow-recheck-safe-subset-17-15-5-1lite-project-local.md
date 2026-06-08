# Risk Check — 2026-06-08

## Change

S4 NARROW re-check — SAFE SUBSET ONLY, project-local. Implement #17+#15 risk-tier model + #5+#1-lite paywall fast-lane, PROJECT-LOCAL ONLY (reference/quality-standards.md gets a new § Risk-Tier Model; research-plan-creator gets a risk-tier: field; cluster-memo-refiner + claim-permission-gate read tier for control depth + permission ceiling; execution-manifest-creator gets the #5 four-way classification + #1-lite source-plan table; #15 hides tier/lens fields outside extracts+sufficiency tables). EXCLUDED/DEFERRED from this re-check: #4 Tier-A counter-search (deferred — #22 schema field verified absent), the Pass-3 Phase-B routing decision (deferred — only #4 needs it), and Option-B canonical promotion of the cross-class triangulation rule (deferred — keystone must prove out in one live run before any canonical promotion). L-SCALE COLLISION RESOLVED: a formal L1–L3 Depth Calibration Framework IS live in research-plan-creator/SKILL.md (lines 52–81, 260–266) — it is a knowledge-depth axis, orthogonal to the new Tier A–D control-effort axis. Resolution baked into this scope: the two axes COEXIST as separate fields; NO aliasing (L3 is NOT Tier A); NO retirement of the L-scale; an explicit orthogonality guard is added to research-plan-creator. Mitigations from the prior RECONSIDER report carried in: enforcer-parsed region of quality-standards.md (4 permission-class names, verb lists, 6 § headings, triangulation-packets rule shape) frozen byte-identical; permission-ceiling is a cap not a re-grade and lands as an explicit OP-5 decision (hard cap for Tier D, advisory for Tier C); un-tiered → Tier B backward-compatible default; #5 fast-lane operator-overridable; #1-lite stays a table embedded in the manifest, never a standalone artifact; execution-manifest-creator edit routed via /improve-skill.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-plan-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-17-15-risk-tiering-model.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-5-1lite-paywall-fast-lane.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The narrowing genuinely retires the three findings that drove the prior RECONSIDER, but the change's framing premise is false — four of the five edit targets are canonical skills consumed via `reference/skills/*` symlinks into `ai-resources/`, so "project-local" is impossible for them and they carry full cross-project blast radius; with the symlink reality acknowledged and the skill edits routed through the canonical gate (`/improve-skill` + chassis `/risk-check`), the subset clears at caution rather than reconsider.

## Consumer Inventory

The "edit four skills project-locally" premise is the load-bearing item the brief asked me to verify. Verified: the four skills are **regular files** in `ai-resources/skills/` (`ls -la`: all `-rw-r--r--`, no `l` flag), and the project reaches them through symlinks at `projects/research-pe-regime-shift-advisory-gap/reference/skills/<skill> -> ../../../../ai-resources/skills/<skill>` (verified via `ls -la` on each symlink). Editing any of them writes the canonical file. The only genuinely project-local target is `reference/quality-standards.md` (a real file in the project tree).

Runtime consumers below are restricted to commands/skills/workflow files (logs, audits, scratchpads, archives excluded as non-runtime).

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md | parses (enforcers read § Claim-Permission Classes / thresholds) | yes (the one in-project edit) |
| ai-resources/skills/research-plan-creator/SKILL.md | co-edits (gains `risk-tier:` field + orthogonality guard) | yes (canonical) |
| ai-resources/skills/cluster-memo-refiner/SKILL.md | co-edits (reads tier → control depth + ceiling) | yes (canonical) |
| ai-resources/skills/claim-permission-gate/SKILL.md | co-edits (reads tier → permission ceiling) | yes (canonical) |
| ai-resources/skills/execution-manifest-creator/SKILL.md | co-edits (#5 four-way class + #1-lite table) | yes (canonical) |
| ai-resources/workflows/research-workflow/.claude/commands/run-preparation.md | invokes research-plan-creator | no (additive field) |
| ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md | invokes cluster-memo-refiner | no (tier read is gated by presence) |
| ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md | invokes claim-permission-gate | no (ceiling is additive cap) |
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md | invokes execution-manifest-creator | no (manifest output gains columns) |
| ai-resources/skills/research-prompt-creator/SKILL.md | invokes/documents 3 of the 4 skills | no |
| ai-resources/skills/research-extract-creator/SKILL.md, research-extract-verifier/SKILL.md | parses (lens/`independence basis` axis the tier model coexists with) | no |
| ai-resources/skills/section-directive-drafter/SKILL.md, evidence-to-report-writer/SKILL.md, cluster-analysis-pass/SKILL.md | invokes cluster-memo-refiner chain | no |
| ai-resources/skills/source-class-mapper/SKILL.md, country-parity-checker/SKILL.md | invokes claim-permission-gate | no |
| ai-resources/workflows/research-workflow/reference/stage-instructions.md, SETUP.md, project-config-schema.md | documents the four skills' pipeline positions | no |
| ai-resources/skills/CATALOG.md | documents (skill registry) | no |
| projects/* other than this one (≥1 each: cluster-memo-refiner ×2, research-plan-creator ×2, claim-permission-gate ×1, execution-manifest-creator ×1) | imports (symlink into the canonical skills) | no (inherit edits automatically) |

Total: 30+ distinct consumers; 5 must-change (4 of which are canonical, not project-local). The other consuming projects inherit the canonical skill edits automatically via their own `reference/skills/*` symlinks — this is the cross-project propagation the "project-local" framing denies.

`risk-tier`/`lens` field-parser grep (the #15 hide-risk check): `grep -rniIl "risk-tier"` across `ai-resources` + the project returned hits ONLY in design notes, fix-spec, prior risk-check reports, logs, scratchpads, and one context-pack — **zero runtime parsers**. No live skill or command currently parses a `risk-tier:` or `lens:` field from a non-extract artifact. The `lens`-outside-extracts grep returned nothing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. `quality-standards.md` is explicitly load-on-demand — "When to read this file. When running QC checks ... Not needed for every turn" (quality-standards.md:11). The new § Risk-Tier Model rides that same conditional load.
- No hook, no `@import`, no auto-loading skill description is added — the change is pay-as-used inside an already-loaded workflow.
- Skill briefs (research-plan-creator etc.) grow by a field + a control matrix; they are invoked on-demand by `run-*` commands, not spawned per session.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`, allow/ask/deny, or new tool-invocation pattern is introduced. The change is content edits to markdown skill/reference files.
- The "permission ceiling" in the change is an *evidence-permission class cap* (SUPPORTED/PROXY-SUPPORTED/…), not a Claude Code tool permission — unrelated to the permissions surface.

### Dimension 3: Blast Radius
**Risk:** High

- The change names five edit targets and frames all five as "project-local." Verified false for four: `research-plan-creator`, `cluster-memo-refiner`, `claim-permission-gate`, `execution-manifest-creator` are canonical files in `ai-resources/skills/` (`ls -la` shows regular files), reached only via `reference/skills/*` symlinks into ai-resources. Editing them is a **canonical edit with cross-project reach** — not project-local. This is the load-bearing blast-radius finding the brief asked for.
- Consumer inventory: 30+ consumers, 5 must-change. Runtime invokers in the canonical workflow alone: `run-preparation`, `run-cluster`, `run-sufficiency`, `run-execution`, plus `research-prompt-creator`, `section-directive-drafter`, `evidence-to-report-writer`, `cluster-analysis-pass`, `source-class-mapper`, `country-parity-checker` — all reference the touched skills.
- Other projects symlink the same skills (cluster-memo-refiner ×2, research-plan-creator ×2, etc.) and inherit the edits silently. The "project-local" framing hides this propagation entirely — itself a blast-radius finding.
- Mitigating the severity: every must-change consumer stays compatible. The tier model is additive (un-tiered → Tier B = current uniform behavior, design-note-17 line 62); the permission ceiling is a cap not a re-grade (design-note-17 line 53); the enforcer-parsed region of quality-standards.md is frozen byte-identical (quality-standards.md:7 lists the canonical-immutable set the change pledges not to touch). So blast radius is wide but backward-compatible — High because of count + the canonical-not-local correction, not because callers break.

### Dimension 4: Reversibility
**Risk:** Medium

- `quality-standards.md` is a single in-project file edit — clean `git revert`.
- The four skill edits live in the **ai-resources repo**, a separate git tree from the project. Revert is clean per-file but requires a coordinated revert across two repos; a partial revert (project reverted, ai-resources not) leaves the skills tiered while the chassis is un-tiered — a stale split. One extra cross-repo cleanup step → Medium.
- No external write, no log mutation, no automation fires between landing and revert. No push-beyond-git state.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The L-scale collision is the prior coupling hazard, now resolved and verified: a formal L1–L3 Depth Calibration Framework **is** live in research-plan-creator/SKILL.md (lines 52–81 "Depth Calibration Framework"; lines 260–266 depth-specific completion table). It is a knowledge-depth axis. The change adds the orthogonal Tier A–D control-effort axis as a separate field with an explicit orthogonality guard, no aliasing, no retirement. This correctly supersedes design-note-17 §3.1's recommendation (b) "Tier A–D *is* the canonical scale and L3 is retired" — which was based on the note's claim that "no formally-defined L1–L3 scale exists" (design-note-17 line 38). The narrowed scope reverses that recommendation to coexistence, matching the verified reality. Good. Residual coupling: two depth-ish axes now sit in one skill; the orthogonality guard is the only thing preventing future drift toward aliasing — documented at the change site, so Medium not High.
- #15 field-hiding contract: the hide is safe — grep found zero runtime parsers reading `tier`/`lens` from non-extract artifacts. The hidden coupling risk #15 *could* have created (a downstream template silently reading a now-hidden field) does not exist today.
- New tier contract: `cluster-memo-refiner` and `claim-permission-gate` will read a `risk-tier:` field that `research-plan-creator` writes. That contract is documented in the design note's control matrix (design-note-17 §3.2) but must be written into the SKILL.md files at the change site, not left implicit — flagged as a mitigation.

### Dimension 6: Principle Alignment
**Risk:** Medium

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** the change adds a `risk-tier:` field whose runtime consumers are added *in the same change* (cluster-memo-refiner + claim-permission-gate read it). So the contract does not ship ahead of its consumer — it is not "hooks for later." The narrowing's deferral of #4, the Pass-3 Phase-B routing decision, and Option-B canonical promotion ("keystone must prove out in one live run before any canonical promotion") is itself OP-9/DR-7-aligned: it refuses to generalize before a confirmed second consumer / live proof. Tension, not violation: the tier model lands across the *canonical* skills while the brief asserts project-local — generalizing a project need into the shared library is exactly the DR-7 boundary, and the symlink reality forces that generalization whether intended or not. Named as a Medium tension because the consumers are real and present, not absent.
- **OP-5 (advisory vs enforcement):** the permission-ceiling moves the gate toward enforcement (hard cap for Tier D). The change handles this correctly per OP-5's requirement — it lands "as an explicit OP-5 decision (hard cap for Tier D, advisory for Tier C)," a per-component recorded call rather than a silent upgrade. Aligned.
- **OP-11 / OP-3 (loud revision):** the change reverses design-note-17's L-scale recommendation (b → coexistence) explicitly and on the record. Loud, not drift. Aligned.
- **DR-1 / DR-3 (placement):** the new § Risk-Tier Model correctly lands in `quality-standards.md` (the project's permission home, per S1 ruling, design-note-17 line 8) rather than the un-instantiated `claim-permission.md`. Correct home.
- **OP-12 (closure before detection):** #5 fast-lane is a closure mechanism (it *stops* expensive false effort and records the classification), not a new un-closed detector. Aligned.
- Net: no clear violation; one real DR-7/OP-9 tension (a project need landing canonically) that the symlink correction in Dimension 3 already surfaces. Medium.

## Mitigations

- **Dimension 3 (High → Medium):** Drop the "project-local" framing for the four skills. Acknowledge in the implementation plan and the chassis decision log that these are **canonical edits** propagating to all consuming projects, and route each skill edit through the canonical gate it requires: `execution-manifest-creator` via `/improve-skill` (output-contract change, design-note-5 line 59) and the chassis `quality-standards.md` edit via a `/risk-check` re-fire (design-note-17 line 65). The other three skill edits (research-plan-creator, cluster-memo-refiner, claim-permission-gate) are additive reads of a presence-gated field — land them with the same chassis re-fire, not as hand-edits framed as project-local.
- **Dimension 3 / cross-project compatibility:** Before landing, confirm the un-tiered → Tier B default (design-note-17 line 62) is implemented in cluster-memo-refiner and claim-permission-gate so the ≥4 other projects that symlink these skills run unchanged when their plans carry no `risk-tier:` field. This is the guarantee that makes the wide blast radius non-breaking.
- **Dimension 4 (Medium):** Land the project edit (`quality-standards.md`) and the ai-resources skill edits as a coordinated pair across both repos, and note the dependency in both commit messages so a future revert reverts both — never one repo alone.
- **Dimension 5 (Medium):** Write the new `risk-tier:` read contract explicitly into the consuming SKILL.md files (cluster-memo-refiner, claim-permission-gate), and write the L-scale orthogonality guard into research-plan-creator/SKILL.md adjacent to the existing § Depth Calibration Framework (lines 52–81), so both contracts are documented at the change site, not left in the design note.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `ls -la` on the four skills and their `reference/skills/*` symlinks (canonical-not-local finding), file-line references in quality-standards.md and research-plan-creator/SKILL.md (L-scale verification, load-on-demand status), `grep -rniIl "risk-tier"` and `lens`-outside-extracts greps (zero runtime parsers → #15 hide is safe), runtime-consumer grep across commands/skills/workflows, and principle IDs read from `projects/strategic-os/ai-strategy/principles-base.md`. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-17-canonical-symlink-finding-project-local-first.md

**The canonical-symlink finding retires "project-local first."** Four targets are canonical skill files edited through `reference/skills/*` symlinks — a Canonical command/agent edit (risk-topology.md § 3), not project-local. Relabeling it "project-local" to preserve the old advice would be the silent-conflict anti-pattern (AP-1). Live choice is A vs C; B (land only the quality-standards.md definition) is rejected as a definition-before-consumer inversion (DR-7/AP-7/OP-12).

**A vs C — the gate is QC-reachability, not the backward-compatible default.** The Tier-B default is a sufficient *backward-compatibility* control (un-tiered → Tier B; ≥4 other projects run unchanged) but backward-compat is not the gate. The gate is DR-8 + QS-1/QS-9: a canonical High-blast-radius edit is commit-blocked unless its independent QC is reachable this session.
- QC reachable this session → **A**, with the four mitigations as hard preconditions.
- QC unreachable/uncertain → **C** forced (defer via `/handoff` QC-PENDING; self-QC-and-commit on a canonical change is prohibited).

**Risk in A being underweighted:** the Tier-B default protects *non-adopters*, not *this project* — the first adopter concentrates all adoption risk with no fallback. Three edges: (1) cross-repo revert is not atomic — stage canonical (ai-resources) edits to land + verify BEFORE the dependent project edit; (2) DR-9 top-3 runtime impact analysis has NOT been run ("30+ consumers" is a static grep) — run it on the 3 highest-traffic consumers before commit; (3) mitigation 4 (L-scale orthogonality guard written into the canonical SKILL.md at the change site) is load-bearing, not optional — skipping it lets a later editor in any of the ≥4 projects silently re-couple tier and lens.

**Position:** route the four canonical edits through `/improve-skill` + chassis `/risk-check` (DR-2 — never hand-edit through the symlink), stage canonical-before-project, treat mitigations 3 and 4 as preconditions. Then A if QC is reachable this session; C if not.
