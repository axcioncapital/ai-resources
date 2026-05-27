# Repo Deep Review — 2026-05-27
Workspace: Axcion AI
Scope: projects/nordic-pe-screening-project
Based on: repo-dd audit 2026-05-27 (same scope)

**Reading note.** This project is a Layer-1 program scaffold with a single initial commit (`277ae25`, 2026-05-27). It has accumulated no operational history yet — no friction log, no improvement log, no session notes. The deep review is therefore structural: it audits the design as built, not the design as run. Findings about long-term context efficiency, hook utilization, and friction patterns will gain signal once the W0 → W4 execution arc begins.

---

## Section 1: Feature Criticality

### 1.1 Load-Bearing Features

Classification of the top-10 downstream-reference ranking. Definitions: **Load-bearing** = failure breaks multiple commands or stops the pipeline; **Supporting** = failure degrades but does not block; **Peripheral** = failure affects only itself.

| Feature | Reference Count | Blast Radius | Risk Notes |
|---|---|---|---|
| `pipeline/project-plan.md` | 9 | **Load-bearing.** Single source of truth for W0–W4 sequencing, confidence rules, and the bottom-up principle. | Failure mode: silent drift between this plan and the work that actually happens. No commit hook checks plan consistency. |
| `pipeline/context-pack.md` | 4 | **Load-bearing for analytical work.** Authoritative grounding for W1/W2/W3 judgment calls. | Currently the v3-approved version. Future revisions need explicit re-approval — no versioning convention enforced. |
| `ai-resources/docs/cross-model-rules.md` (external) | 4 | **Load-bearing for cross-model phases.** Governs tool-per-step assignment across Claude/GPT-5/Perplexity. | External; risk is upstream change in `ai-resources` without this project being re-audited. |
| `ai-resources/docs/analytical-output-principles.md` (external) | 4 | **Load-bearing for W2/W3.** Provides evidence/interpretation separation and uncertainty conventions. | Same external-change risk as above. |
| `inputs/README.md` | 4 | **Load-bearing for W0 start.** Documents the binding precondition (the raw Excel) and where to drop it. | Without this file, the operator does not know what to supply, where, or under what filename. |
| `.claude/settings.json` | 3 | **Load-bearing.** Permissions posture, two SessionStart hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`). | Healthy: defaultMode bypassPermissions, push denied, only ai-resources added as cross-dir. |
| `.claude/shared-manifest.json` | 2 | **Load-bearing for symlink integrity.** Drives `auto-sync-shared.sh`; if it drifts, the 86 inbound symlinks could mismatch ai-resources contents. | Sync hook runs SessionStart-time; mtime-based detection means out-of-band ai-resources changes are caught next session. |
| `pipeline/architecture.md` | 4 | **Supporting.** Structural blueprint; not consumed at session execution time. | The audit found one stale claim here (described `.claude/settings.local.json` as existing) — now resolved by F-1 fix. |
| `pipeline/implementation-spec.md` | 2 | **Supporting.** Records the as-built decisions of Stage 3c. | Stable — unlikely to be re-edited after Stage 4 completion. |
| `pipeline/repo-snapshot.md` | 2 | **Peripheral.** Stage 3a output, point-in-time. | Will stale; not consumed at session time, so staleness has no operational cost. |

### 1.2 Operational Dependency Chains

For each pipeline, the single point of failure is the component whose breakage has the widest blast radius.

- **W-unit execution pipeline:** `raw Excel → W0 → W1 → W2 → W3 → W4`. Strictly linear, each unit's output is the next unit's substrate. **Single point of failure: W0.** If the stable-ID master is wrong (wrong dedupe, wrong vehicle→firm rollup, or wrong SE filter), every downstream W-unit cascades the error. Recovery requires re-running W0 and re-doing every downstream judgment.
- **Layer-2 child-cycle pipeline:** `projects/project-planning/` → `/context-builder` → `/plan-draft` → `/plan-refine` → `/plan-evaluate` → child plan → executes here. **Single point of failure: the W1 child plan** — Phase 1 screening criteria are locked there; locking them wrong forces a costly W2/W3 redo.
- **Session lifecycle:** `/prime` → [work] → `/wrap-session`. Workspace-owned, well-tested. Project does not own a custom variant. No project-specific single point of failure.
- **Cross-model wiring:** Claude (orchestrator) + GPT-5 (research execution) + Perplexity (factual retrieval). **Single point of failure: tool-per-step assignment in each child plan.** CLAUDE.md and cross-model-rules.md state Claude must not substitute its own work for the tool assigned to a task; silent substitution would invalidate provenance for every W2 fund profile.
- **Symlink-sync chain:** `auto-sync-shared.sh` (SessionStart hook) reads `.claude/shared-manifest.json` and mirrors canonical resources into this project's `.claude/commands/` and `.claude/agents/`. **Single point of failure: shared-manifest.json drift.** All 86 symlinks currently resolve; an undetected manifest drift would silently mismatch ai-resources state.

### 1.3 Untracked Dependencies

Behavioral or convention-level rules that govern execution but are not file references — therefore not visible to any structural audit.

| Dependency | Type | Why It Matters |
|---|---|---|
| Bottom-up taxonomy principle (CLAUDE.md §"Bottom-up Principle") | Behavioral constraint | Industry taxonomy is an output of W3, not an input. Forgetting this would cause pre-decided categories to leak into W1 criteria and bias the screen. |
| Confidence-tier protocol (CLAUDE.md §"Confidence and Sourcing") | Sourcing rule | Three states — low-confidence / no-data / fails-criterion — shape every per-fund judgment in W2 and W3. Conflation would corrupt the qualified-target list. |
| Layer-1 / Layer-2 separation (CLAUDE.md §"Layer 2 Child Cycles") | Architectural rule | This program is Layer-1; child cycles MUST NOT be scaffolded speculatively. Premature scaffolding inverts the two-layer model and pre-commits per-phase decisions the plan deliberately defers. |
| Strict W-unit ordering (CLAUDE.md §"Program Shape") | Sequencing rule | W0 → W1 → W2 → W3 → W4 is non-negotiable. Skipping or reordering destroys substrates downstream. |
| Adaptive thinking override (CLAUDE.md §"Adaptive Thinking Override") | Reasoning posture | The project requires `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1` because W1–W3 are analytical-density work; without it, Claude may compress reasoning at points where depth is load-bearing. **Now active post-F-1 fix.** |

### 1.4 Findings — Section 1

- **High — Architecture-spec drift detection unhooked.** `pipeline/architecture.md` previously described `.claude/settings.local.json` as existing while `pipeline/implementation-spec.md` deferred its creation to enrichment that never happened. The contradiction was caught only by this audit. *Evidence:* DD report §2.4, §4.5. *Recommendation:* add a thin one-shot script — or a step in `/wrap-session` — that re-validates the as-built claims in architecture.md against filesystem reality whenever architecture.md, implementation-spec.md, or settings.json change. Effort: <1 session.
- **Medium — Raw-Excel precondition unenforced.** `inputs/nordic-pe-funds-raw.xlsx` is the binding W0 precondition (documented in CLAUDE.md and inputs/README.md), but there is no programmatic check that fails fast when W0 begins without it. *Evidence:* inputs/README.md; CLAUDE.md §Upstream Inputs. *Recommendation:* before W0 opens its child cycle, the operator (or a thin guard hook) should verify the file's presence and reject the start otherwise. Effort: quick fix.
- **Low — `pipeline/repo-snapshot.md` will stale silently.** Point-in-time Stage 3a output; not consumed at session time. *Evidence:* DD §3.4. *Recommendation:* accept as inherent — its peripheral character means staleness has no operational cost.

---

## Section 2: Context Management

### 2.1 Context Load Summary

| Entry Point | CLAUDE.md Lines | Hook Load | Total | Efficiency Ratio |
|---|---|---|---|---|
| Workspace CLAUDE.md (always loaded) | 189 | — | 189 | not measured in this scope; out-of-scope for project audit |
| Project CLAUDE.md (always loaded) | 117 | — | 117 | **~70% project-unique / ~30% verbatim canonical duplication** |
| SessionStart hooks (both entry points) | — | `auto-sync-shared.sh` (10 s timeout) + `check-permission-sanity.sh` (5 s timeout) | 2 hooks, 15 s cumulative | healthy — both serve clear purposes |
| **Combined at session start** | **306 lines** | **2 hooks / 15 s** | **306 lines + ~15 s startup** | — |

No `@import` or `@file` directives. No additional files auto-loaded.

The 30% duplication in project CLAUDE.md is the four sections (Input File Handling, Commit Rules, Compaction, Session Boundaries) — totaling 35 lines — that are verbatim copies of canonical workspace rules. The operator decided to keep them: each section carries a footer note declaring the duplication intentional ("repeated here because projects are sometimes opened without the parent workspace context loaded").

This is a real trade-off, not a bug. The duplication costs ~35 lines of context every session and creates a maintenance burden if the canonical wording ever changes. It buys robustness against the failure mode of a project opened in isolation. Below the 60% efficiency floor would be alarming; ~70% project-unique is acceptable.

### 2.2 Migration Candidates

| Section | File | Lines | Recommendation | Reasoning |
|---|---|---|---|---|
| (none) | — | — | No migrations recommended in this scope. | The four duplicated sections (F-2..F-5) were the natural candidates; operator explicitly chose to keep them. Workspace-level resolution belongs to a workspace-scoped audit, not a project audit. |

### 2.3 Hook Density Assessment

| Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict |
|---|---|---|---|---|
| `.claude/settings.json` (project) | SessionStart | 2 | 15 s | Healthy. Below the 3-hook flag threshold; both hooks have visible operational value (sync shared resources, validate permission posture). |
| `.claude/settings.json` (project) | PostToolUse | 0 | — | None. No per-write hook chaining. |
| `.claude/settings.json` (project) | PreToolUse | 0 | — | None. |
| `.claude/settings.json` (project) | Stop | 0 | — | None. |
| `.claude/settings.json` (project) | UserPromptSubmit | 0 | — | None. |

### 2.4 Dead or Low-Value Context

No issues identified. Checked: every section of the project CLAUDE.md against documented purpose (DD extract §5.2); both SessionStart hook scripts against their declared functions (visible mechanism for shared-resource sync and permission-sanity check). Cannot assess "context that loads but is rarely used" — the project has no session-notes history to mine for non-invocation patterns.

### 2.5 Findings — Section 2

- **Medium — Verbatim canonical duplications add ~35 lines of permanent context cost.** Operator-accepted trade-off (intentional safety net). *Evidence:* DD §2.6; CLAUDE.md lines 83–117. *Recommendation:* revisit at workspace-scope level — the workspace `CLAUDE.md Scoping` rule and the project's safety-net argument cannot both be right. A workspace-side resolution (e.g., a sanctioned "duplicate-on-purpose" marker for project CLAUDE.mds) would close the rule conflict without sacrificing the safety net. Effort: workspace-scope audit, deferred. Not actionable from inside this project.

---

## Section 3: Friction and Improvement Synthesis

### 3.1 Recurring Friction Patterns

No issues identified. Checked: 7 conventional log files in `logs/` and `pipeline/`; 6 of 7 absent (friction-log, improvement-log, session-notes, coaching-log, workflow-observations, innovation-registry) — expected for a project on its initial commit; the seventh (`logs/decisions.md`) is an empty template. See `audits/working/log-sweep.md` for the full sweep.

### 3.2 Improvement Pipeline Health

| Metric | Value |
|---|---|
| Friction entries logged | 0 (file absent) |
| Improvements logged | 0 (file absent) |
| Improvements applied | 0 |
| Improvements verified | 0 |
| Stalled improvements (>14 days) | 0 |

The improvement pipeline has no observations yet because no execution has happened. Re-audit when W0 has completed and a session-notes / friction-log history exists.

### 3.3 Specific Recommendations

1. **(High, quick fix)** Add a one-shot architecture-vs-filesystem consistency check, runnable from `/wrap-session` or as a thin script in `pipeline/`. Trigger: any commit that modifies `pipeline/architecture.md`, `pipeline/implementation-spec.md`, or `.claude/settings*.json`. This would have caught F-1 at write-time instead of at the first repo-dd audit. *Action:* design a check that parses architecture §2 "as-built" claims and verifies each against the filesystem.
2. **(Medium, quick fix)** Add a W0 precondition guard — before the W0 child cycle opens, verify `inputs/nordic-pe-funds-raw.xlsx` exists, is readable, and is non-empty. *Action:* a single-line guard in the W0 README, or a tiny hook script triggered when a `work/w0-setup/` write is attempted without the input present.
3. **(Low, deferred)** Re-audit after W0 completes so friction-log, improvement-log, and session-notes patterns become observable. *Action:* schedule a re-run of `/repo-dd deep` (no `full`) after W0 ships its `master-register` + `se-subset` + `country-validation-log` outputs.

---

## Section 4: Pipeline Testing

### 4.1 Test 1 — Symlink Resolution

Walked all 86 symlinks under `.claude/` (62 commands + 24 agents). All resolve to readable, non-empty targets in `ai-resources/.claude/`.

| Result | Count |
|---|---|
| Pass | 86 |
| Fail | 0 |

### 4.2 Test 2 — Template Sync (deployed copies vs canonical)

No regular-file copies exist in this project. Every entry under `.claude/commands/` and `.claude/agents/` is a symlink into `ai-resources/`. The project owns no diverged copies; nothing to compare.

| Category | Count |
|---|---|
| Regular-file copies in `.claude/commands/` | 0 |
| Regular-file copies in `.claude/agents/` | 0 |
| Project-local skill copies under `skills/` | n/a (no project skills/ dir) |

### 4.3 Test 3 — `/deploy-workflow` Preconditions

| Precondition | Path Tested | Status |
|---|---|---|
| Template directory exists | `ai-resources/workflows/research-workflow/` | Pass |
| `SETUP.md` exists at workflow root | `ai-resources/workflows/research-workflow/SETUP.md` | Pass |
| Placeholder definitions in `SETUP.md` | 24 `{{...}}` mentions | Pass |
| Placeholder patterns present in template files | 10 files contain `{{...}}` | Pass |
| Skill symlink source non-empty | `ai-resources/skills/` (79 entries) | Pass |

**Drift note:** the skill's Step 64 documents the template path as `workflows/research-workflow/` (workspace-root). The actual canonical path is `ai-resources/workflows/research-workflow/`. A first-pass run of the test against the documented path returned spurious failures. Recorded as a Section 4 finding below.

### 4.4 Test 4 — `/new-project` Preconditions

| Agent | Path | Status |
|---|---|---|
| `pipeline-stage-3a` | `ai-resources/.claude/agents/pipeline-stage-3a.md` | Pass |
| `pipeline-stage-3b` | `ai-resources/.claude/agents/pipeline-stage-3b.md` | Pass |
| `pipeline-stage-3c` | `ai-resources/.claude/agents/pipeline-stage-3c.md` | Pass |
| `pipeline-stage-4` | `ai-resources/.claude/agents/pipeline-stage-4.md` | Pass |
| `pipeline-stage-5` | `ai-resources/.claude/agents/pipeline-stage-5.md` | Pass |
| `session-guide-generator` | `ai-resources/.claude/agents/session-guide-generator.md` | Pass |

### 4.5 Test 5 — `/sync-workflow` Preconditions

| Precondition | Value | Status |
|---|---|---|
| Deployed projects under `projects/` | 14 | Pass |
| Workflow `.claude/` directory exists | `ai-resources/workflows/research-workflow/.claude/` | Pass |
| `.claude/commands/` populated | 31 entries | Pass |
| `.claude/agents/` populated | 4 entries | Pass |
| `.claude/hooks/` populated | 4 entries | Pass |

### 4.6 Findings — Section 4

- **Medium — `/repo-dd` pipeline-test path is stale.** Steps 64 and 66 of the skill reference `workflows/research-workflow/` (workspace-root), but the actual canonical location is `ai-resources/workflows/research-workflow/`. The first pass of Tests 3 and 5 in this audit returned false failures until the path was corrected manually. *Evidence:* `ai-resources/.claude/commands/repo-dd.md` Steps 64 and 66; filesystem check confirms `workflows/` at workspace root is empty. *Recommendation:* update the skill to use `ai-resources/workflows/research-workflow/` — or, more durably, introduce a `WORKFLOW_TEMPLATE_DIR` variable resolved once at Step 1 and used throughout Tests 3 and 5. Effort: quick fix. **Cross-repo finding** — fix lives in `ai-resources`, outside the audited project's scope; addressable from any session.

---

## Summary

- **Critical findings:** 0
- **High findings:** 1 — architecture-spec drift detection is unhooked (F-1 caught only by this audit; same class of drift could recur).
- **Medium findings:** 3 — raw-Excel W0 precondition is documented but unenforced; project CLAUDE.md duplications add ~35 lines of permanent context cost (operator-accepted trade-off; resolution belongs to workspace scope); `/repo-dd` skill pipeline-test path is stale (false failures until manually corrected).
- **Low findings:** 1 — `pipeline/repo-snapshot.md` will stale silently (peripheral; accept as inherent).
- **Pipeline tests:** 5/5 pass (all 86 symlinks resolve, no diverged copies to compare, all `/deploy-workflow`/`/new-project`/`/sync-workflow` preconditions met against the actual canonical path).
- **Top 3 recommendations by impact:**
  1. Build an architecture-vs-filesystem consistency check that runs at commit time on touched architecture/spec/settings files. Prevents the next F-1-class drift.
  2. Add a W0 precondition guard so the program cannot start the first execution unit without the raw Excel present.
  3. Update `/repo-dd` skill (`ai-resources/.claude/commands/repo-dd.md`) Steps 64 and 66 to point at `ai-resources/workflows/research-workflow/`. Quick fix; prevents false-failure noise in future audits.
