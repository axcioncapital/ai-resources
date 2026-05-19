# Repo Deep Review — 2026-05-19
Workspace: Axcion AI
Scope: projects/ai-development-lab
Based on: repo-dd audit 2026-05-19 (same scope)
Depth: full (factual + deep assessment + pipeline tests)

---

## Section 1: Feature Criticality

### 1.1 Load-Bearing Features

| Feature | Ref Count | Blast Radius | Risk Notes |
|---------|-----------|--------------|------------|
| `pipeline/ref-grilling.md` | 3 | Blocks stage 3 of every pipeline run | Sequential position; absence prevents interrogation step |
| `pipeline/ref-extraction.md` | 2 | Blocks stage 2 | Sequential; no extraction = no downstream stages |
| `pipeline/ref-memo-template.md` | 2 | Blocks stage 5 memo compilation | Defines required memo fields; absence breaks output schema |
| `pipeline/ref-step7-brief.md` | 2 | Blocks system-owner dispatch | Mirror-source for Step 7d brief; stale copy breaks repo-fit assessment |
| `logs/pipeline-log.md` | 3 | Required by both `/analyze-transcript` and `/produce-handoff` | Absent at time of audit; created lazily on first run |
| `.claude/agents/system-owner.md` | 2 | Sole source of Axcíon repo-fit assessment | Relative symlink; breaks if directory structure changes |
| `.claude/agents/ai-engineer.md` | 2 | Sole source of AI engineering merit assessment | Project-local regular file; not subject to auto-sync |

Supporting (1–2 refs, degraded but not blocked if missing):

| Feature | Ref Count | Notes |
|---------|-----------|-------|
| `ai-resources/docs/repo-architecture.md` | 2 | Context source for system-owner brief; stale copy degrades quality |
| `output/memos/{run}/memo.md` | 2 | Pipeline output; absence means no produce-handoff input |
| `.claude/shared-manifest.json` | 2 | Sync control only; auto-sync hook reads it |

### 1.2 Operational Dependency Chains

**Idea triage pipeline (only chain in this project):**
```
/analyze-transcript
  → Stage 2: pipeline/ref-extraction.md
  → Stage 3: pipeline/ref-grilling.md [ambiguity gate — may pause]
  → Stage 4a: .claude/agents/ai-engineer.md
  → Stage 4b: .claude/agents/system-owner.md (via Task tool)
        ↳ reads: ai-resources/docs/repo-architecture.md
        ↳ brief template: pipeline/ref-step7-brief.md
  → Stage 5: pipeline/ref-memo-template.md
        ↳ writes: output/memos/{date}-{slug}/memo.md
        ↳ appends: logs/pipeline-log.md
  → [Patrik reviews]
  → /produce-handoff
        ↳ reads: output/memos/{date}-{slug}/memo.md
        ↳ appends: logs/pipeline-log.md
```

**Single point of failure:** `/analyze-transcript` — orchestrates all 5 stages. No fallback or partial-run mechanism. Its breakage halts all idea triage. Priority: **Medium** (blast radius: entire pipeline; likelihood: low, command is straightforward).

**Secondary SPOF:** `logs/pipeline-log.md` — required by both terminal commands. Currently absent; both commands will create it lazily, but if the create fails (e.g., permissions), both commands fail at their log step.

**Session lifecycle:** `/prime` → [work] → `/wrap-session` — standard workspace chain, no project-specific modifications.

### 1.3 Untracked Dependencies

| Dependency | Type | Why It Matters |
|-----------|------|----------------|
| `consult.md` Step 4 structure | Temporal coupling | `pipeline/ref-step7-brief.md` is declared as a verbatim mirror of `/consult` Step 4. Any `/improve-skill` on `consult.md` that changes Step 4 silently invalidates `ref-step7-brief.md`. CLAUDE.md acknowledges this risk with "re-verify when consult.md changes" — but the check is manual with no trigger. |
| Relative depth of `projects/ai-development-lab/` in workspace | Structural assumption | `system-owner.md` symlink uses `../../../../ai-resources/.claude/agents/system-owner.md`. This resolves correctly at 4 levels up. If the project is ever nested deeper (e.g., moved under a sub-directory), the symlink breaks silently. |
| `ai-resources/docs/repo-architecture.md` freshness | Content currency | The system-owner agent reads this file for Axcíon architecture context. If the architecture doc becomes stale, repo-fit assessments drift without a visible signal. |

**Priority of untracked dependencies:**
- `consult.md` temporal coupling: **Medium** (active development on consult.md is plausible; divergence produces silent quality degradation, not a hard failure)
- Relative symlink depth: **Low** (stable directory structure; would only matter on project restructuring)
- Architecture doc currency: **Low** (doc updated as part of audit cadence; drift is gradual)

---

## Section 2: Context Management

### 2.1 Context Load Summary

| Entry Point | CLAUDE.md Lines | Hook Load | Total Lines | Efficiency Ratio |
|------------|-----------------|-----------|-------------|------------------|
| Session (workspace root CLAUDE.md) | 164 | 0 (hooks emit status only) | 164 | ~100% (all sections are behavioral rules) |
| Session (project CLAUDE.md) | 101 | 0 | 101 | ~100% (all 9 sections are behavioral constraints or session orientation) |
| **Combined** | **265** | **0** | **265** | **~100%** |

Estimated token cost at session start: ~1,800–2,200 tokens. Well within operational range; no efficiency flag triggered.

Both SessionStart hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`) emit status messages but inject no content into context.

### 2.2 Migration Candidates

No issues identified. Checked: all 9 project CLAUDE.md sections. Each section is either a behavioral modifier active in every session (Purpose, Pipeline, Agent scope boundary, Memo discipline, Out of scope) or operator-facing orientation content (How to invoke, Reference docs, Cross-project coupling notes, Model selection). None exceed the migration threshold (unreferenced by commands AND not a behavioral modifier AND >5 lines).

### 2.3 Hook Density Assessment

| Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict |
|------------|---------|------------|-------------------|---------|
| Session start | SessionStart | 2 | 15s | Acceptable — below 3-hook threshold |

No PostToolUse hooks registered. No Write-triggered hook chains. No density concern.

### 2.4 Dead or Low-Value Context

| Item | Type | Evidence of Non-Use |
|------|------|---------------------|
| `check-permission-sanity.sh` | SessionStart hook | Project has `defaultMode: "bypassPermissions"` set — this hook's only action is to emit a nudge when `defaultMode` is absent. For this project it will always pass silently. Adds 5s to every session start with no observable output. **Priority: Low.** The hook does no harm and may be useful if settings.json is ever modified to remove defaultMode. |

---

## Section 3: Friction and Improvement Synthesis

### 3.1 Recurring Friction Patterns

No issues identified. Checked: `logs/friction-log.md` (absent), `logs/improvement-log.md` (absent), `logs/session-notes.md` (2 entries, day-1 project). Project has no operational history. No friction patterns to analyze.

### 3.2 Improvement Pipeline Health

| Metric | Value |
|--------|-------|
| Friction events logged | 0 (no friction-log) |
| Improvements logged | 0 (no improvement-log) |
| Improvements applied | 0 |
| Improvements verified | 0 |
| Stalled improvements | 0 |
| Open action items in session notes | 3 |

Open action items from `logs/session-notes.md` (not yet formalized):
1. Start new Claude session to pick up updated permissions (from permission sweep)
2. Clean up `~/.claude/settings.json` model declaration violation
3. Begin first pipeline run: drop a transcript and invoke `/analyze-transcript`

### 3.3 Specific Recommendations

**1. [Medium / Quick fix]** Clean up `~/.claude/settings.json` model declaration violation.
- Evidence: `logs/session-notes.md` entry 1 explicitly flags "`~/.claude/settings.json` contains `"model": "sonnet[1m]"` at top level — violates workspace CLAUDE.md model-declaration prohibition."
- Root cause: User-level settings carry a stale model declaration from before the prohibition rule was established.
- Action: Remove the `"model"` key from `~/.claude/settings.json`. One-line edit. No downstream impact (workspace CLAUDE.md prohibits this field at all levels).

**2. [Medium / Moderate]** Execute the first pipeline run before auditing further.
- Evidence: No pipeline runs in `logs/pipeline-log.md` (file absent); `transcripts/` is empty. All Section 1 findings are theoretical — no operational evidence that the pipeline works end-to-end.
- Root cause: Project was set up in the same session it was audited; no real transcripts have been processed.
- Action: Drop a transcript into `transcripts/` and invoke `/analyze-transcript`. This will surface real friction, create pipeline-log.md, and validate all 4 ref docs in practice.

**3. [Medium / Moderate]** Add a verification step for ref-step7-brief.md when consult.md changes.
- Evidence: CLAUDE.md line 53 explicitly warns "re-verify when consult.md changes." No automated mechanism exists.
- Root cause: Temporal coupling acknowledged in design but left as a manual obligation.
- Action: Add a note to `ai-resources/skills/consult.md` (or its improvement workflow) that `/improve-skill consult` must be followed by re-verifying `projects/ai-development-lab/pipeline/ref-step7-brief.md`. Alternatively, include a diff check in the consult improvement checklist.

---

## Section 4: Pipeline Testing

### Test 1: Symlink Resolution

All 77 symlinks checked: 22 agent symlinks + 55 command symlinks.
- 76 use absolute paths; all resolve. ✓
- 1 uses relative path (`system-owner.md` → `../../../../ai-resources/.claude/agents/system-owner.md`); resolves correctly. ✓
- All targets exist and are non-empty. ✓

**Result: PASS**

### Test 2: Template Sync

No deployed copies to compare. `ai-engineer.md` is a project-local regular file (not a copy of any canonical agent). All other agents are symlinks — there is no deployed copy to diverge from.

**Result: N/A**

### Test 3: /analyze-transcript Preconditions

| Precondition | Status |
|-------------|--------|
| `pipeline/ref-extraction.md` exists | ✓ |
| `pipeline/ref-grilling.md` exists | ✓ |
| `pipeline/ref-memo-template.md` exists | ✓ |
| `pipeline/ref-step7-brief.md` exists | ✓ |
| `.claude/commands/analyze-transcript.md` symlink resolves | ✓ |
| `.claude/agents/ai-engineer.md` exists | ✓ |
| `.claude/agents/system-owner.md` symlink resolves | ✓ |
| `transcripts/` directory exists | ✓ |
| `output/memos/` directory exists | ✓ |
| `logs/pipeline-log.md` exists | ✗ (created lazily on first run — expected) |

**Result: PASS** (pipeline-log.md absence is expected and documented)

### Test 4: /new-project Preconditions (workspace-level, informational)

| Precondition | Status |
|-------------|--------|
| `pipeline-stage-3a.md` in ai-resources agents | ✓ |
| `pipeline-stage-3b.md` in ai-resources agents | ✓ |
| `pipeline-stage-3c.md` in ai-resources agents | ✓ |
| `pipeline-stage-4.md` in ai-resources agents | ✓ |
| `pipeline-stage-5.md` in ai-resources agents | ✓ |
| `session-guide-generator.md` in ai-resources agents | ✓ |

**Result: PASS**

### Test 5: /deploy-workflow and /sync-workflow Preconditions (workspace-level, informational)

| Precondition | Status |
|-------------|--------|
| `workflows/research-workflow/` directory exists | ✗ ABSENT |

**Result: FAIL** — workspace-level issue outside ai-development-lab scope. `workflows/research-workflow/` does not exist; `/deploy-workflow` and `/sync-workflow` would fail if invoked. This project does not use these commands, so no impact on ai-development-lab operations. Flagged for workspace-level awareness only.

---

## Summary

**Critical findings: 0**

**High findings: 0**

**Medium findings: 3**
- M-1: `/analyze-transcript` is the sole orchestrator of the 5-stage pipeline with no fallback — single point of failure
- M-2: `consult.md` / `ref-step7-brief.md` temporal coupling — manual re-verification required after any consult.md improvement with no automated trigger
- M-3: `~/.claude/settings.json` contains prohibited `"model"` top-level field — violates workspace CLAUDE.md rule; flagged in session notes but not yet addressed

**Low findings: 2**
- L-1: `logs/pipeline-log.md` absent at audit time — no operational audit trail yet; created lazily on first run
- L-2: `check-permission-sanity.sh` SessionStart hook is a no-op for this project (defaultMode is set) — adds 5s per session start with no output

**Top 3 recommendations by impact:**
1. **Run the first pipeline end-to-end** (`/analyze-transcript transcripts/<file>`) — all Section 1 findings are theoretical until the pipeline has been exercised; one run will validate or invalidate most assumptions
2. **Fix `~/.claude/settings.json` model declaration** — one-line removal; closes a known CLAUDE.md rule violation
3. **Add consult.md improvement checklist note** — low-effort, prevents silent ref-step7-brief.md drift over time
