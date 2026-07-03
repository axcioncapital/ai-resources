# Risk Check — 2026-07-02

## Change

Introduce a wireframe-first stage into the Axcíon Design Studio pipeline. Full plan: pipeline/wireframe-stage-plan.md. It splits the current single creator pass into two gated stages. Stage A (Wireframe): the layout-architect creator runs in a new "wireframe mode" to produce structure only (section order, content placement, hierarchy, audience/user flow, component-slot assignment) deferring all colour/type/imagery/styling; a 2-critic structural pass (visual-red-team + implementation-bridge, NOT brand-guardian) reviews it; mechanical consolidate into wireframe-qc-report.md; operator approval gate; on approval the skill mechanically produces a locked structural-summary.md. Stage B (Visual): layout-architect runs in "visual mode", reads the locked structural-summary.md (does NOT re-derive structure), adds the visual layer into the VDS; full 3-critic pass as today; consolidate; operator approval; handoff to figma-build-brief.md (unchanged). Anti-duplication rule: structural-summary.md is the single source of truth for structure after Stage A; the VDS §2 is reframed from "decide layout" to "visual treatment per section, structure locked in structural-summary.md". Files edited (all CP-1 tier-C, operator-approval-only): 00_mandate/design-studio-mandate.md §4 (and a one-line §3 note); .claude/skills/visual-design-spec/SKILL.md (chain grows 4→9 steps, two new halt gates, updated validation + dispatch contract); .claude/agents/layout-architect.md (adds wireframe|visual mode); .claude/agents/visual-red-team.md and .claude/agents/implementation-bridge.md (stage-aware notes); .claude/skills/visual-design-spec/references/vds-template.md (reframe §2); project CLAUDE.md (non-negotiable-sequence lines). New files: .claude/skills/visual-design-spec/references/wireframe-spec-template.md and .claude/skills/visual-design-spec/references/structural-summary-schema.md. brand-guardian.md unchanged. New per-surface artifacts under work/{surface}/wireframe/ plus work/{surface}/structural-summary.md. Out of scope: re-running homepage through the new chain; brand book; website design system; strategy/copy. Existing work/homepage/ proof-run artifacts retained as-is.

## Referenced files

| File | Status |
|------|--------|
| projects/axcion-design-studio/pipeline/wireframe-stage-plan.md | read |
| projects/axcion-design-studio/00_mandate/design-studio-mandate.md | read |
| projects/axcion-design-studio/CLAUDE.md | read |
| projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md | read |
| projects/axcion-design-studio/.claude/agents/layout-architect.md | read |
| projects/axcion-design-studio/.claude/agents/visual-red-team.md | read |
| projects/axcion-design-studio/.claude/agents/implementation-bridge.md | read |
| projects/axcion-design-studio/.claude/agents/brand-guardian.md | read |
| projects/axcion-design-studio/.claude/skills/visual-design-spec/references/vds-template.md | read |
| .../references/wireframe-spec-template.md | not yet present (not read) |
| .../references/structural-summary-schema.md | not yet present (not read) |

Context also read: workspace `CLAUDE.md`, `ai-resources/CLAUDE.md`, `projects/strategic-os/ai-strategy/principles-base.md`, project `.claude/settings.json`, and the discovered Codex mirror set (`.agents/skills/`, `.codex/agents/*.toml`, `AGENTS.md`).

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** A well-governed, operator-directed, per-file CP-1-gated restructure that stays inside the Studio's owned doctrine layer and reverts cleanly — but two Medium dimensions push it past GO: (Blast Radius) the change rewrites a core dispatch contract consumed by the skill + 3 agents + mandate + project CLAUDE.md and leaves ~7 in-project docs describing the old 5-step chain stale; (Hidden Coupling) a byte-identical Codex mirror (`.codex/`, `.agents/`, `AGENTS.md`) sits outside the plan and will silently drift, plus the new `structural-summary.md` single-source-of-truth introduces a Stage-A→Stage-B contract with structure now touched in three places. Both are fully mitigable with two plan additions and one doc sweep.

## Consumer Inventory

Search terms go through: `visual-design-spec`, `layout-architect`, `visual-red-team`, `implementation-bridge`, `brand-guardian`, `figma-build-brief`, `structural-summary`, `wireframe`, `non-negotiable sequence`, `vds-template`. Grepped across the design-studio project and the workspace (incl. `ai-resources/`). `structural-summary` and `wireframe-spec` return only the plan itself — the new contracts have no existing consumer (they are consumed by the pipeline on its next run).

**In-boundary (Claude Code) load-bearing consumers**

| Consumer | Reference type | Must-change? | In plan? |
|----------|----------------|--------------|----------|
| `00_mandate/design-studio-mandate.md` | co-edits (defines chain §4) | yes | yes |
| `.claude/skills/visual-design-spec/SKILL.md` | invokes (orchestrator; 4→9 steps) | yes | yes |
| `.claude/agents/layout-architect.md` | invokes (creator; gains `mode`) | yes | yes |
| `.claude/agents/visual-red-team.md` | invokes (critic; stage-aware) | yes | yes |
| `.claude/agents/implementation-bridge.md` | invokes (critic; stage-aware) | yes | yes |
| `.claude/skills/.../references/vds-template.md` | parses (VDS §2 reframe) | yes | yes |
| `CLAUDE.md` (project, always-loaded) | documents (non-negotiable sequence) | yes | yes |
| `.claude/agents/brand-guardian.md` | invokes (critic; Stage-B only now) | no | yes (listed unchanged) |
| `.claude/skills/.../references/figma-build-brief-schema.md` | parses (terminal handoff) | no (unchanged) | n/a |

**Codex mirror — out-of-boundary by OP-10, byte-identical today, plan-silent**

| Consumer | Reference type | Must-change? | In plan? |
|----------|----------------|--------------|----------|
| `.agents/skills/visual-design-spec/SKILL.md` | invokes (Codex runtime; IDENTICAL to .claude) | co-edits *if* parity intended | NO |
| `.agents/skills/.../references/vds-template.md` | parses (IDENTICAL) | co-edits *if* parity intended | NO |
| `.codex/agents/layout-architect.toml` | invokes (Codex port) | co-edits *if* parity intended | NO |
| `.codex/agents/visual-red-team.toml` | invokes | co-edits *if* parity intended | NO |
| `.codex/agents/implementation-bridge.toml` | invokes | co-edits *if* parity intended | NO |
| `AGENTS.md` (project, Codex mirror of CLAUDE.md) | documents (non-negotiable sequence) | co-edits *if* parity intended | NO |
| `.codex/agents/brand-guardian.toml` | invokes | no (unchanged anyway) | NO |

**In-project docs describing the current 5-step chain — go stale on change, plan-silent**

| Consumer | Reference type | Must-change? | In plan? |
|----------|----------------|--------------|----------|
| `pipeline/architecture.md` | documents | should update/annotate | NO |
| `pipeline/technical-spec.md` | documents | should update/annotate | NO |
| `pipeline/project-plan.md` | documents | should update/annotate | NO |
| `pipeline/implementation-spec.md` | documents (build record) | annotate as superseded | NO |
| `pipeline/claude-design-setup.md` | documents | should update/annotate | NO |
| `pipeline/context-pack.md` | documents | should update/annotate | NO |
| `10_brand-system/README.md` | documents (roles) | minor/annotate | NO |

**Historical / no-action (documents, must-change = no):** `logs/**` (session-notes, decisions, qc/*, scratchpads, session-plans, usage-log, innovation-registry, improvement-log, coaching-data), `work/homepage/**` (VDS, critiques, qc-report, figma-build-brief, exploration-record), `pipeline/{implementation-log,test-results,create-skill-brief}.md`. All retained-as-is per plan §8. Cross-project: `ai-resources/audits/**` + `ai-resources/logs/friction-log.md` mention the Studio only as historical audit records — **no shared-library runtime consumer** (the skill is project-local, never graduated to `ai-resources/skills/`), so there is no cross-project runtime blast radius.

## Dimensions

### Dimension 1: Usage Cost

**Risk:** Low

- The only *always-loaded* file the change touches is project `CLAUDE.md` (workspace/repo CLAUDE.md unchanged). The edit is a few lines rewriting the "non-negotiable sequence" / "No design output without a VDS" lines to the two-stage form — negligible standing token delta.
- The mandate (`00_mandate/design-studio-mandate.md`) is read on dispatch, not always-loaded (SKILL.md Step 1 passes it to the creator). `SKILL.md` grows 4→9 steps and each agent brief gains a mode branch — but these load only when the design chain runs, not every session.
- Real cost is *per-design-pass runtime fan-out*, not standing overhead: the creator now runs **twice** (wireframe mode + visual mode), plus a 2-critic wireframe pass, a wireframe consolidation, and a mechanical structural-summary step — roughly +3–4 subagent dispatches and +2 file consolidations per surface vs. the current 4-subagent pass. This is the intended function (deliberate structure-first review), opt-in per pass, not a session tax. Rated Low on the dimension's own framing (always-loaded files / hooks / oversized briefs), with the runtime increase noted explicitly.

### Dimension 2: Permissions Surface

**Risk:** Low

- `projects/axcion-design-studio/.claude/settings.json` runs `"defaultMode": "bypassPermissions"` and allows `Edit`, `Write`, `Edit(**/.claude/**)`, `Write(**/.claude/**)`. All in-plan edit targets (`.claude/skills/**`, `.claude/agents/**`, `00_mandate/**`, project `CLAUDE.md`) fall under allow; the two new template files are `Write` under `.claude/skills/.../references/` (allowed).
- `deny` covers only `Bash(rm -rf *)`, `Bash(sudo *)`, `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`, and `Edit/Write(../axcion-brand-book/**)`. None of the edit targets is under any deny rule (the mandate's "PROTECTED" status is a *procedural* CP-1 gate, not a settings deny).
- The change adds **no** allow/ask/deny entries, **no** new tool or capability surface, and touches no hook. Permissions surface is unchanged.

### Dimension 3: Blast Radius

**Risk:** Medium

- Consumes the Step 1.5 inventory. In-boundary must-change count = **7** (mandate, SKILL.md, layout-architect, visual-red-team, implementation-bridge, vds-template, project CLAUDE.md) + **2** new files — all in the plan. `brand-guardian.md` correctly stays no-change; the skill must nonetheless be edited so `brand-guardian` is dispatched only in Stage B (a dispatch-contract change that touches the critic indirectly).
- Contract changes are real and central: the skill's **dispatch contract** changes (creator dispatched twice in two modes; a 2-critic wireframe pass; two new halt gates); the `layout-architect` gains a **`mode` input** (new required parameter — SKILL.md, the mandate, and the agent must all agree on its values); the VDS §2 **semantics** change from "decide layout" to "annotate locked structure." A mismatch on any of these across the skill/mandate/agents produces a broken pass.
- The plan's file list under-counts the true consumer set: **~7 in-project docs** (`pipeline/architecture.md`, `technical-spec.md`, `project-plan.md`, `implementation-spec.md`, `claude-design-setup.md`, `context-pack.md`, `10_brand-system/README.md`) describe the current 5-step chain and become stale/inaccurate; the plan does not schedule updating them.
- Bounding factors keep it Medium, not High: the change is contained to **one project** with its own git repo; there are **no cross-project runtime consumers** (skill is project-local); and every in-boundary edit is per-file CP-1-gated. The Codex mirror (6 files) is out-of-boundary by OP-10 (see Dimension 5) rather than a required co-edit.

### Dimension 4: Reversibility

**Risk:** Low

- All edits are to version-controlled markdown in the design-studio project's own git repo (`projects/axcion-design-studio/.git` confirmed present). New files (2 templates) and new per-surface artifacts (`work/{surface}/wireframe/**`, `structural-summary.md`) are purely additive.
- A single `git revert` (or restoring the pre-change files) cleanly returns the 5-step chain — no schema migration of existing data, no external state, no data rewrite. The existing `work/homepage/**` proof-run is explicitly retained as-is (plan §8), so no in-place mutation to undo.
- Only wrinkle: if a surface were run through the new chain before a revert, its `wireframe/` + `structural-summary.md` artifacts would be orphaned — but the first run is explicitly out of scope (plan §8), so no such artifacts exist. Session-log appends (`session-notes.md`/`decisions.md`) are additive records, not part of the reversible change surface.

### Dimension 5: Hidden Coupling

**Risk:** Medium

- **Codex mirror silent-drift (headline).** `.claude/skills/visual-design-spec/SKILL.md` is **byte-identical** to `.agents/skills/visual-design-spec/SKILL.md` (`diff -q` = identical), and `vds-template.md` / `figma-build-brief-schema.md` are identical across the two trees; `.codex/agents/*.toml` are TOML ports of the four agents (e.g. layout-architect: 138 lines `.md` vs 134 lines `.toml`); `AGENTS.md` mirrors project `CLAUDE.md` with "Codex" substituted and carries the same "non-negotiable sequence." **No sync mechanism covers these** — the SessionStart `auto-sync-shared.sh` hook syncs shared *commands* from `ai-resources` (`.claude/commands` is a symlink), but the skill/agents/AGENTS.md are independent local copies. Editing only the `.claude/` set will silently diverge the Codex runtime, which would then run the *old* 5-step pipeline. (OP-10 makes this defensible if de-scoped explicitly — see Dimension 6 — but the coupling exists on disk today and the plan is silent on it.)
- **New source-of-truth contract.** `structural-summary.md` becomes the single authority for structure; `layout-architect` visual-mode must "read, not re-derive" it, and VDS §2 must not re-open structure. This is a new implicit Stage-A→Stage-B contract; if the summary's shape drifts from what visual-mode expects, the failure is silent (a re-derived or contradictory structure). The plan mitigates by shipping `structural-summary-schema.md`, but the read-don't-re-derive rule is behavioural, not mechanically enforced.
- **Structure now lives in three places** — `wireframe-spec.md` (authored), `structural-summary.md` (locked SoT), and VDS §2 (annotated). The anti-duplication rule (plan §4) is the only thing preventing these from drifting; it is doctrine, not enforcement.
- No silent auto-fire is introduced — both new stages are operator-approval-gated, not automatic.

### Dimension 6: Principle Alignment

**Risk:** Low

- **OP-10 (system boundary = Claude Code only).** Directly on point. The Codex mirror (`.codex/`, `.agents/`, `AGENTS.md`) is a *cross-tool* surface — "invoked by" but "not part of" the Claude Code system. So omitting it from a Claude-side change is **principle-aligned by default**; co-editing it would itself be a scope expansion needing an explicit decision. The gap is only that the plan is *silent* — it should say so (converting silent drift into a recorded de-scope; see Mitigations).
- **OP-9 / AP-7 / DR-7 (no speculative abstraction; generalize only on a second consumer).** *Not triggered.* This is a concrete restructure of the one existing pipeline, directly operator-directed (directive quoted in plan §1), for the same web surfaces; the new templates/schema have an immediate consumer (the pipeline's next run). Caveat, not a violation: the pipeline ships **unproven** — the homepage re-run is explicitly deferred (plan §8), so the two-stage chain has zero exercised runs at landing. Worth noting; not speculative building.
- **OP-12 (closure before detection).** The two new halt gates (no Stage B until `structural-summary.md` exists; no `figma-build-brief.md` until Stage B `qc-report.md` exists) each ship *with* a closure channel (operator approval → the gating artifact). No orphan detection. Aligned.
- **OP-5 / OP-2 (advisory vs enforcement; automate execution, gate judgment).** The new gates enforce-and-stop for operator judgment; the mechanical consolidate and mechanical structural-summary steps automate execution only. Correct split. Aligned.
- **OP-11 / OP-3 (loud revision, not silent drift).** Editing PROTECTED doctrine here is loud and recorded — a written plan, this risk-check, a blindspot scan, per-file CP-1 sign-off, post-edit QC, and contract-check. This is the legitimate revision mechanism, not drift. The single silent-drift exposure is the Codex mirror (Dimension 5), closed by the OP-10 de-scope line.
- **DR-1 / DR-3 (placement).** New reference files sit as siblings of existing templates under `.claude/skills/visual-design-spec/references/` (established folder); new artifacts under a self-contained `work/{surface}/wireframe/`; the plan is a sibling of `claude-design-setup.md` under `pipeline/`. Aligned.
- **DR-8 (risk-check on gated structural classes).** This review satisfies the plan-time gate; procedurally correct.

## Mitigations

Two Medium dimensions; no High. Actionable pairings (do these before/with landing):

- **[Hidden Coupling] Add one explicit de-scope line to the plan (§8).** State that the Codex mirror — `.codex/agents/*.toml`, `.agents/skills/visual-design-spec/**`, and `AGENTS.md` — is **out of scope under OP-10** (Codex is invoked-by, not part-of, the Claude Code system) and will be re-synced only as a separate explicit cross-tool-parity decision. This converts the silent divergence into a loud, recorded de-scoping (OP-11/OP-3). If parity *is* wanted now, instead add the 6 mirror files to the CP-1 batch — do not leave them unaddressed either way.
- **[Hidden Coupling] Lock the structural contract before wiring Stage B.** Ship `structural-summary-schema.md` as the single named authority and make the VDS §2 reframe reference it *by filename*, so the "read, don't re-derive" rule and the three-places-touch-structure boundary are explicit and greppable rather than behavioural-only.
- **[Blast Radius] Add a documentation-sweep step.** After the doctrine/skill/agent edits land, update or annotate the in-project docs that describe the 5-step chain (`pipeline/architecture.md`, `technical-spec.md`, `project-plan.md`, `implementation-spec.md`, `claude-design-setup.md`, `context-pack.md`, `10_brand-system/README.md`) to the two-stage form — or mark each "describes pre-wireframe chain (superseded 2026-07-02)." Prevents a fleet of stale in-project references.
- **[Blast Radius] Land the in-boundary set atomically.** Apply the 7 must-change files + 2 new files in one operator-approved batch so the skill's dispatch contract, the mandate, project CLAUDE.md, and the three agents never disagree on the `mode` parameter or the stage sequence mid-edit.
- **[Process, change-class]** Because this edits PROTECTED doctrine (a `/risk-check` structural class), honour the workspace QC-independence rule: if independent QC is unreachable in the implementing session (>200k-token context + subagent gate), defer via `/handoff` (QC-PENDING) rather than self-QC-and-commit — the plan's "run implementation in a fresh dedicated session" recommendation (§7) already points this way.

## Recommended redesign

N/A — verdict is PROCEED-WITH-CAUTION, not RECONSIDER. No dimension scored High and none contradicts stated intent; the change is a viable structural restructure that lands cleanly once the paired mitigations above are applied.

## Evidence-Grounding Note

Every dimension is grounded in read files or grep/`diff`/`ls` output from this session: the plan and all eight `exists` referenced files were read in full; `.claude/settings.json` was read for the permissions dimension; the Codex mirror was confirmed by directory listings and `diff -q` (SKILL.md, vds-template, figma-build-brief-schema all reported IDENTICAL); `principles-base.md` was read for the principle IDs cited (OP-2/5/9/10/11/12, OP-3, DR-1/3/7/8, AP-7). The two `not yet present` template files were **not** read per contract. No dimension was left INCOMPLETE. One factual note: a repo-root `grep -r .` under-reported project matches (returned only workspace-root `logs/session-notes.md`); all consumer findings were re-derived with project- and `ai-resources`-scoped absolute-path greps, which resolved correctly.
