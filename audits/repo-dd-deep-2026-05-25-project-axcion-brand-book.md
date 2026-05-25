# Repo Deep Review — 2026-05-25
Workspace: Axcion AI
Scope: projects/axcion-brand-book
Based on: repo-dd audit 2026-05-25 (projects/axcion-brand-book scope)

This deep review interprets the factual repo-dd findings through three lenses: feature criticality (what breaks if it fails), context management (what's costing every session), and friction synthesis (what hurts repeatedly). All facts and inventory counts originate from the factual audit; this report adds judgment, prioritization, and recommendation.

Project phase context: axcion-brand-book is at Phase 0 — the scaffold is built but no module work has begun. Phase 0.1 (brand strategist long-form persona) and Phase 0.2 (corporate identity source map population) are the gating prerequisites before `/scope-module 00_foundation` can run. This phase shape shifts the deep-review emphasis: most "load-bearing" features are about to become load-bearing, but have not yet been exercised under real workload. The review therefore prioritizes things that will fail under workload (single points of failure, weakly-tested pipeline state) over things actively failing today.

---

## Section 1 — Feature Criticality

### 1.1 Load-Bearing Features

The top of the downstream-reference ranking from the factual audit § 3.4 mapped to operational blast radius:

| Feature | Reference Count | Blast Radius | Verdict | Risk Notes |
|---------|-----------------|--------------|---------|------------|
| `pipeline/module-status.md` | 5 | Cross-pipeline state — every phase command reads + 3 of 4 write to it | **Load-bearing** | Single point of failure for the entire 4-phase pipeline. Currently unparseable header on line 4 (literal `{YYYY-MM-DD …}` placeholder). Protected by `Edit(./pipeline/**)` deny rule so external edits are blocked — but the deny rule also blocks corrective edits without a deny-rule bypass. |
| `source_map.md` | 3 | Phase 0 gate + every scope-module run for module-source resolution | **Load-bearing** | Currently 0/13 populated. Blocks `/scope-module 00_foundation` until Phase 0.2 completes. No upstream artifacts have been provided yet (no `_inputs/corporate-identity/` directory exists). |
| `.claude/agents/brand-strategist.md` | implicit (single consumer = `/scope-module`) | Quality of all 8 module scoping notes | **Load-bearing** | Project-local agent, runtime persona only. The validated long-form companion (`_consultants/brand_strategist.md`) is a scaffold stub. If the persona drifts or is mis-calibrated, all 8 modules inherit the miscalibration. No verification loop exists between agent and companion. |
| `references/module-template.md` | 2 | Every module's structural layout | **Load-bearing** | Defines the 10-section structure each module must follow; consumed by `/draft-module`, `/qc-module`, `/lock-module`. Static reference, low change risk. |
| `references/tagging-conventions.md` | 2 | [LOCKED]/[INFERRED]/[OPEN] semantics across all modules | **Load-bearing** | If tagging conventions change after some modules lock at v1, those v1 modules become inconsistent with later modules. Static reference today. |
| `references/module-sequence.md` | 2 | Module build order + upstream-blocker tracking | Supporting | Order is fixed and validated; reference is consulted but rarely changes. |
| `references/mockup-conventions.md` | 2 | Visual modules only (4 of 9 modules use mockups) | Supporting | Failure scope limited to visual modules. |
| `pipeline/context-pack.md` | 2 | Per-module context for `/draft-module` | Supporting | Cross-module data carrier — not yet exercised. |
| `references/scoping-note-rubric.md` | 1 | Every `/scope-module` invocation (8-field structure) | Supporting | Single consumer; if it changes mid-project, prior scoping notes become inconsistent. |
| `references/phase-workflow.md` | 1 | Operator/Claude orientation | Supporting | Read-only reference. |

**Headline:** Two single points of failure (`pipeline/module-status.md`, `source_map.md`) and one quality-multiplier dependency (`brand-strategist.md` persona + its unvalidated companion doc). The first two are visible; the third is invisible until module scoping starts producing miscalibrated output.

### 1.2 Operational Dependency Chains

**Chain 1 — The four-phase module pipeline (per-module, executed 9 times):**

```
/scope-module {id}      ── reads: source_map.md, references/*, pipeline/module-status.md
                            writes: pipeline/scoping-notes/{id}.md, pipeline/module-status.md (phase 0→1)
                            invokes: brand-strategist agent

       ↓ (operator approves scoping note)

/draft-module {id}      ── reads: scoping note, references/*, source_map.md
                            writes: brand-book/{id}.md (v0.1), mockups/{id}/*, pipeline/module-status.md (v0.1 date)

       ↓ (v0.1 ready)

/qc-module brand-book/{id}.md
                         ── reads: module template, tagging conventions, mockup conventions, the draft
                            writes: logs/qc-reports/{id}.md, pipeline/module-status.md (phase 1→2)

       ↓ (QC PASS + zero [OPEN] tags + operator approval)

/lock-module {id}       ── reads: QC report, the draft
                            writes: pipeline/module-status.md (phase 2→3-locked, v1 lock date)
```

**Single point of failure for this chain:** `pipeline/module-status.md`. Every command reads it for state; three of four write to it. If it becomes corrupted, malformed, or out-of-sync with actual module state, every command silently misinterprets phase progress. The `Edit(./pipeline/**)` deny rule protects it from accidental external edits but also from corrective ones — which means recovery from corruption is a privileged operation.

**Chain 2 — Phase 0 prerequisites (one-time, currently blocked):**

```
Phase 0.1 (manual): operator builds _consultants/brand_strategist.md
Phase 0.2 (manual): operator drops 13 artifacts into _inputs/corporate-identity/
                  → operator fills source_map.md
                  → source_map.md marked approved

       ↓ (both Phase 0.1 and 0.2 complete)

/scope-module 00_foundation       ← currently blocked
```

**Single point of failure for this chain:** the operator. Both Phase 0 steps are manual and have no auto-validation. If either is shipped underbuilt, all 9 downstream modules inherit the deficit. The `SESSION-GUIDE.md` provides the build procedure but there is no automated check that the scaffold has graduated from stub to validated reference.

### 1.3 Untracked Dependencies

| Dependency | Type | Why It Matters |
|------------|------|----------------|
| Workspace `CLAUDE.md` (174 lines, auto-loaded) | Behavioral convention | Every session inherits autonomy rules, decision-point posture, QC discipline, commit behavior. Behavioral, not file-referenceable. |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | Resource-availability infrastructure | Symlinks all shared commands/agents into the project at SessionStart. If the hook fails or produces malformed symlinks, the project loses access to shared resources mid-session. (See § 1.4 below — this just happened.) |
| `.claude/shared-manifest.json` | Local-vs-shared declaration | Tells the auto-sync hook which files are project-owned. If it's malformed or missing, the hook either skips sync entirely (`exit 0`) or could overwrite project-local files. |
| Brand-strategist persona consistency between `.claude/agents/brand-strategist.md` (runtime) and `_consultants/brand_strategist.md` (companion) | Quality contract | The agent summarizes what the companion develops in full. If the two drift, scoping output becomes incoherent with the documented strategy. There is no automated drift check between these two files. |
| 13 corporate identity artifacts (not yet provided) | Phase 0.2 input | The most important input the project will ever receive — and no validation exists for what counts as "the 13 artifacts." If the operator provides fewer or mis-categorized artifacts, `source_map.md` cannot reach 13/13. |

### 1.4 Live infrastructure concern (surfaced by this audit)

The factual audit's FINDING-7 (six absolute-path symlinks) was caused by `auto-sync-shared.sh` writing `ln -s "$src" "$target"` where `$src` is the absolute path to ai-resources. Every project on this workspace receives absolute-path symlinks on each new sync. The 76 pre-existing relative-path symlinks in axcion-brand-book were created by some other mechanism (likely `/new-project` or manual setup), but every future auto-synced file will be absolute. **This is a slow drift toward an entire workspace of relocation-unsafe symlinks.** Priority: Medium — does not block today, but compounds over time and across all projects.

### 1.5 Findings — Section 1

| # | Priority | Finding | Recommendation |
|---|----------|---------|----------------|
| C1.1 | Medium | `pipeline/module-status.md` is the single state document for the four-phase pipeline and is protected by a deny rule that also blocks corrective edits | Document a recovery procedure (e.g., temporarily lifting the deny rule, restoring from git, or scripting the fix) before the first module reaches Phase 2. Without a procedure, recovery from corruption requires improvisation under pressure. |
| C1.2 | Medium | The brand-strategist agent persona and its long-form companion `_consultants/brand_strategist.md` have no automated drift check between them | When Phase 0.1 ships, add a brief checklist or a `/qc-pass` style check that confirms agent ↔ companion coverage across the seven domains. Currently the only signal will be downstream module quality. |
| C1.3 | Medium | The auto-sync hook produces absolute-path symlinks (audit FINDING-7) for every newly synced file in every project | Patch `auto-sync-shared.sh` to compute and use relative paths. The fix touches a shared resource — run `/risk-check` first. Until fixed, this is a periodic-cleanup item on every project. |
| C1.4 | Low | No validation exists for "the 13 corporate identity artifacts" — Phase 0.2 can complete with fewer or mis-categorized artifacts | Add an explicit checklist in `SESSION-GUIDE.md` or `references/source-map-format.md` enumerating what each of the 13 artifacts is expected to be (positioning doc, voice guide, etc.) and a verification step before marking `source_map.md` approved. |
| C1.5 | Low | `pipeline/context-pack.md` and `pipeline/project-plan.md` appear in the reference ranking but have not been exercised | First module run will reveal whether either is over-specified or under-specified. Defer judgment until 00_foundation's first phase pipeline runs. |

---

## Section 2 — Context Management

### 2.1 Context Load Summary

Per factual audit § 5.1:

| Entry Point | Lines | Hook Load | Total | Efficiency |
|-------------|-------|-----------|-------|------------|
| Workspace `CLAUDE.md` (auto-loaded) | 174 | — | 174 | ~95% — almost every section is operationally consumed by some command or hook |
| Project `CLAUDE.md` (auto-loaded) | 70 → 71 after this audit's O8 edit | — | 71 | ~80% — three sections ("Model Selection", "Compaction", "Session Boundaries") are behavioral orientation, not command-referenced |
| SessionStart hooks | n/a (shell scripts produce terminal output only — 0 lines into context) | 0 | 0 | n/a |
| **Total auto-loaded per session** | — | — | **245 lines** | High efficiency for an active project — but this project has not yet had an active session, so "operationally consumed" is a forward projection. |

**Headline:** Auto-load context is lean. Workspace + project CLAUDE.md totals 245 lines. There is no `@`-include chain inflating the load. No SessionStart hook adds file content to context. This is a healthy posture.

### 2.2 Migration Candidates

The factual audit identified three sections of project `CLAUDE.md` not referenced by any command or hook:

| Section | Lines | Current File | Recommendation | Reasoning |
|---------|-------|--------------|----------------|-----------|
| `## Model Selection` | ~9 | `CLAUDE.md` | **Keep** | Operator/Claude orientation at session start. Functions as a recommendation, not a behavior — but having it auto-load means a fresh Claude reaches for Opus 4.7 for identity drafting without being prompted. Move cost > value. |
| `## Compaction` | ~9 | `CLAUDE.md` | **Keep** | Activated only at `/compact` time, but the behavior it triggers (scratchpad before compact, trust the summary on resume) must be primed before `/compact` is invoked. Migrating to on-demand would require `/compact` to load this guidance — adds a load step where the current cost is 9 lines per session. Keep. |
| `## Session Boundaries` | ~2 | `CLAUDE.md` | **Keep** | Two lines. Not worth migrating. |

**Headline:** No migration candidates worth pursuing for this project. The project CLAUDE.md is short and tight.

### 2.3 Hook Density Assessment

| Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict |
|-------------|---------|------------|---------------------|---------|
| Project root | SessionStart | 2 (auto-sync-shared.sh + check-permission-sanity.sh) | 15s | Healthy. Both hooks produce only terminal status output; neither loads file content into context. |
| Project root | PreToolUse / PostToolUse / Stop | 0 | 0 | None. Each tool call has zero hook overhead. |

**Headline:** Hook overhead is minimal. No write-amplification risk.

### 2.4 Dead or Low-Value Context

| Item | Type | Evidence of Non-Use |
|------|------|---------------------|
| (none identified) | — | The factual audit found no unreferenced files in the project tree beyond `SESSION-GUIDE.md`, which was unreferenced by `CLAUDE.md` but useful. This audit's O8 fix added that reference — `SESSION-GUIDE.md` is now discoverable. |

### 2.5 Findings — Section 2

| # | Priority | Finding | Recommendation |
|---|----------|---------|----------------|
| C2.1 | Low | Project's three behavioral-orientation `CLAUDE.md` sections (Model Selection, Compaction, Session Boundaries) total ~20 lines of unreferenced load | Accept. The lines pay for themselves the first time a fresh Claude reaches for the right model or correctly preserves state before `/compact`. |
| C2.2 | Info | Total auto-load context is 245 lines (workspace + project CLAUDE.md), well below any threshold of concern | No action. Baseline metric for future audits. |

---

## Section 3 — Friction and Improvement Synthesis

### 3.1 Recurring Friction Patterns

Per log-sweep summary (working file: `audits/working/log-sweep-axcion-brand-book-2026-05-25.md`):

| Pattern | Frequency | Repos Affected | Root Cause | Recommendation |
|---------|-----------|----------------|------------|----------------|
| (none recorded) | 0 | — | — | — |

The project has not yet run any module work. The only log content is today's session mandate header. There is no friction history yet to analyze.

### 3.2 Improvement Pipeline Health

| Metric | Value |
|--------|-------|
| Improvements logged | 0 |
| Improvements applied | 0 |
| Improvements verified | 0 |
| Improvements stalled | 0 |
| Log files active | 2 of 7 expected (session-notes.md, decisions.md) |

The 5 absent log files (friction-log, improvement-log, coaching-log, workflow-observations, innovation-registry) are expected absences for a Phase 0 project. They will materialize when the project runs its first module session.

### 3.3 Specific Recommendations — Section 3

| # | Priority | Recommendation | Action | Effort |
|---|----------|---------------|--------|--------|
| C3.1 | Low | Establish a friction-logging discipline before the first module session | When `/scope-module 00_foundation` is run, the operator should run `/friction-log` at the end of the session if anything notable came up — this seeds the friction-log so the next deep-tier audit has data to synthesize. Without this seeding behavior, friction stays invisible. | Quick |
| C3.2 | Info | The brand-book project has no recurring patterns, no unresolved improvements, no friction-vs-improvement asymmetry — by virtue of having done no work | No action. Re-run this section after 3–5 module sessions. | — |

---

## Section 4 — Pipeline Testing

### 4.1 Test Results

| Test | Result | Notes |
|------|--------|-------|
| **Test 1 — Symlink resolution** | **PASS** | All 82 symlinks in `projects/axcion-brand-book` resolve, 0 broken. (Verified after O7 fix converted 6 absolute symlinks to relative.) |
| **Test 2 — Template sync (project-local files)** | **PASS** | The 4 project-local commands (`scope-module`, `draft-module`, `qc-module`, `lock-module`) and 1 project-local agent (`brand-strategist`) are declared as `local` in `shared-manifest.json`. No canonical version exists in `ai-resources/.claude/commands/`, so there is nothing to drift from. |
| **Test 3 — /deploy-workflow preconditions** | OUT-OF-SCOPE for project audit | Tests workspace-level template directories (`workflows/research-workflow/SETUP.md`). These do not exist in the workspace today, but that is a workspace-level finding, not a brand-book finding. Brand-book does not consume `/deploy-workflow`. |
| **Test 4 — /new-project preconditions** | **PASS** | All `pipeline-stage-*.md` agents exist; `session-guide-generator` exists. The brand-book project is downstream of `/new-project`. |
| **Test 5 — /sync-workflow preconditions** | OUT-OF-SCOPE for project audit | Tests `workflows/research-workflow/.claude/` template. Brand-book does not consume `/sync-workflow`. |

### 4.2 Findings — Section 4

| # | Priority | Finding | Recommendation |
|---|----------|---------|----------------|
| C4.1 | Info | Tests 3 and 5 are out-of-scope for a single-project audit — they belong to a workspace audit | When running `/repo-dd full` workspace-scoped, Tests 3 and 5 will execute as designed. The missing `workflows/research-workflow/` directory will surface at that scope. |

---

## Summary

**Findings by priority:**

- **Critical:** 0
- **High:** 0
- **Medium:** 3 (C1.1 module-status.md recovery procedure; C1.2 strategist-companion drift check; C1.3 auto-sync hook absolute paths)
- **Low:** 5 (C1.4 artifact validation, C1.5 deferred pipeline judgments, C2.1 accept behavioral context cost, C3.1 friction-logging discipline, C3.2 re-run after work)
- **Info:** 3 (C2.2 context-load baseline, C3.2 no-friction-yet observation, C4.1 out-of-scope pipeline tests)

**Top 3 recommendations by impact:**

1. **C1.3 — Patch `auto-sync-shared.sh` to produce relative-path symlinks** (Medium). This is the highest-leverage fix because it affects every project in the workspace, every time a new shared resource is added, indefinitely. Run `/risk-check` first because the hook is shared infrastructure. Until fixed, every workspace-wide audit will rediscover the same drift.

2. **C1.1 — Document a `pipeline/module-status.md` recovery procedure** (Medium). The single state document for the entire pipeline is protected from external edits by design. That protection becomes a liability if the file is ever corrupted — currently the recovery path is improvised. Write the procedure once now (e.g., `references/module-status-recovery.md`), not under pressure later.

3. **C1.2 — Add an agent ↔ companion drift check when Phase 0.1 ships** (Medium). The brand-strategist persona will calibrate all 8 module scoping notes. There is no signal today that the agent and its long-form companion are coherent — the only feedback loop is downstream module quality. A brief `/qc-pass`-style coverage check on Phase 0.1 completion costs little and de-risks all subsequent module work.

**Phase 0 context note:** This is a deep review of a project that has not yet done its primary work. Most findings are forward-looking. After 3–5 module sessions complete, re-run `/repo-dd deep projects/axcion-brand-book` — the friction synthesis and operational dependency chains will produce meaningfully different output once there's real workload to analyze.
