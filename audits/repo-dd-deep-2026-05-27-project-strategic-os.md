# Repo Deep Review — 2026-05-27
Workspace: Axcion AI
Scope: projects/strategic-os
Based on: repo-dd audit 2026-05-27 (same scope)

---

## Section 1: Feature Criticality

### 1.1 Load-Bearing Features

| Feature | Reference Count | Blast Radius | Risk Notes |
|---|---|---|---|
| `.claude/agents/state-retrieval-agent.md` | 6 commands | Read path for state view, decisions, self-review, refresh | Single point of failure. No fallback. Embeds the Cross-Project Read Protocol contract — drift between this and `CLAUDE.md` § Cross-Project Read Protocol would silently break confidentiality. |
| `.claude/commands/promote-to-live.md` | 6 commands | Sole canonical write path to `state/live/**` | Permissions layer denies all Write/Edit on `state/live/**`. Per `logs/decisions.md` W1, /promote-to-live writes via Bash heredoc (`cat > file <<'EOF'`). If that bypass turns out to be blocked at first run, the OS is stuck until fallback Option B is implemented. |
| `docs/os-conventions.md` | 5 (4 commands + CLAUDE.md) | File naming, citation, label conventions across all artifacts | Failure mode is silent drift — written artifacts diverge from convention without blocking. |
| `state/live/<element>.md` (collective) | 7 commands read/write | Source of truth for strategic state | Currently empty stubs by design. v1-vessel state. Failure to populate is not a failure — failure to gate against sparse-state at consumer-side IS. |
| `docs/decision-query-output-standard.md` | 3 (/decide + CLAUDE.md) | /decide's 5-field response contract | Breakage would degrade /decide output structure but not block. |

### 1.2 Operational Dependency Chains

**Chain: Decision Query**
- `/decide` → ▶ `state-retrieval-agent` → `state/live/*` OR sparse-fallback → `/kb-query` (future, with documented stub fallback) → 5-field response → `responses/{YYYY-MM-DD-HHMM-slug}.md`
- **Single point of failure:** `state-retrieval-agent`. If it crashes or returns malformed snapshot, /decide cannot ground reasoning. Sparse-state fallback handles missing data; it does NOT handle agent-call failure.

**Chain: State View**
- `/strategic-state` → ▶ `state-retrieval-agent` + `conflict-detector-agent` → 6-element view + conflict entries + freshness footer
- **Single point of failure:** `state-retrieval-agent`. `conflict-detector-agent` failure degrades the view (no conflicts surfaced) but does not block — the W2.3 elements still render.

**Chain: Promotion (write path)**
- `/sandbox-new` → operator edits sandbox → `/promote-sandbox` → ▶ `/promote-to-live` → `state/live/<element>.md` (Bash-heredoc write) + `state/live/decisions-log.md` (append)
- **Single point of failure:** `/promote-to-live`. The permissions layer denies all other write paths. If its Bash-heredoc bypass turns out to be blocked at first run (W1 deferred validation), the OS becomes stuck — operator cannot edit live state by any path.

**Chain: Self-Review**
- `/os-self-review` → `self-review-agent` → `state-retrieval-agent` → `reviews/self-review/{date}.md`
- **Single point of failure:** `state-retrieval-agent` (transitive). `self-review-agent` itself is single-use (only /os-self-review consumes it), so its failure has narrow blast radius.

**Chain: Strategic Review (formal)**
- `/strategic-review` → walk 6 W2.3 elements (uses `state-retrieval-agent` indirectly) → checklist artifact in `reviews/`
- **Single point of failure:** `state-retrieval-agent` (transitive).

### 1.3 Untracked Dependencies

| Dependency | Type | Why It Matters |
|---|---|---|
| **Cross-Project Read Protocol** | Behavioral rule, duplicated in `CLAUDE.md` § Cross-Project Read Protocol AND `.claude/agents/state-retrieval-agent.md` | Confidentiality boundary across project workspaces. Duplication risk: if one source drifts and the other doesn't, the OS may read forbidden paths (other projects' `inputs/`, `output/`, `*deal-*`, `*client-*`, `*confidential*`). `logs/decisions.md` W6 already warns that future v2+ cross-project agents must re-apply this exclusion list — but does not enforce one canonical source. |
| **Labelling Rule** | Behavioral rule applied by every command writing to `responses/`, `reviews/`, `sandbox/` | Compliance is behavioral, not enforced by code. A command that forgets the proposal/draft label produces output that *looks* live but isn't governed. |
| **Build-Complete ≠ Operational** | Acceptance-test semantics | Sets the meaning of "v1 ships". W6.1 acceptance test verifies structural completeness only; OS is functionally inert until `state/live/` is populated. Without this rule explicit in CLAUDE.md, an outside reviewer could mistake an empty-state OS for a broken one. |
| **W1 deferred validation (Bash heredoc bypass)** | Architecture assumption pending first-run confirmation | The entire write path for state/live depends on the assumption that `Bash(cat *)` is not scoped by destination path. If that assumption fails at first /promote-to-live invocation, the entire promotion chain is blocked until fallback Option B is implemented. |

---

## Section 2: Context Management

### 2.1 Context Load Summary

| Entry Point | CLAUDE.md Lines | Hook Load | Total | Efficiency Ratio |
|---|---|---|---|---|
| `projects/strategic-os/CLAUDE.md` | 93 | 0 (2 SessionStart hooks emit status messages only, no context injection) | 93 | ~32% (≈29 lines directly grep'd by commands; ~64 lines behavioral) |

The 32% efficiency ratio falls below the 60% flag threshold, but unpacking it shows the ratio is misleading — most "unreferenced" lines are intentional behavioral guidance or documented workspace-rule duplication. See §2.2.

### 2.2 Migration Candidates

| Section | File | Lines | Recommendation | Reasoning |
|---|---|---|---|---|
| Input File Handling | `projects/strategic-os/CLAUDE.md` | 12 | **Keep** | Explicit in-text comment: "This rule mirrors the canonical Input File Handling section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded." Deliberate redundancy by design. |
| Commit Rules | `projects/strategic-os/CLAUDE.md` | 7 | **Keep** | Same explicit comment as above — deliberate workspace-rule duplication for sessions opened without workspace context. |
| Compaction | `projects/strategic-os/CLAUDE.md` | 10 | **Keep** | Project-specific content (preserve pipeline/stage ID, subagent-output paths, pending operator gates). Not pure workspace-duplicate. |
| All sub-5-line behavioral sections (Purpose, Authority Model, Labelling Rule, Strategic-vs-Operational Boundary, Build-Complete ≠ Operational, Model Selection, File Discipline, QC Independence, Session Boundaries) | `projects/strategic-os/CLAUDE.md` | 3–5 each | **Keep** | Each section is a pointer to a docs/ file plus 1–3 lines of behavioral rule. The pointer pattern is correct; collapsing would lose per-session orientation. |

**Net:** No migrations recommended. The low efficiency ratio reflects design choices, not waste.

### 2.3 Hook Density Assessment

| Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict |
|---|---|---|---|---|
| `projects/strategic-os/.claude/settings.json` | SessionStart | 2 (`auto-sync-shared.sh`, `check-permission-sanity.sh`) | 15s | Healthy. Both hooks invoke ai-resources scripts via upward-walk; status-only output, no context injection. |
| `projects/strategic-os/.claude/settings.json` | PostToolUse[Write] | 0 | 0s | Healthy. No per-write fan-out — appropriate for a strategic-interpretation project (output cadence is low, governance gates are explicit commands not implicit hooks). |

### 2.4 Dead or Low-Value Context

| Item | Type | Evidence of Non-Use |
|---|---|---|
| **None identified** | — | All 15 H2 sections in CLAUDE.md serve a present purpose (behavioral rule, command pointer, or workspace-rule duplication for context-isolation). Both SessionStart hooks produced visible output this session (auto-sync ran; permission-sanity flagged). |

**Recurring-usage check:** N/A — `logs/session-notes.md` is absent (first session ever). Cannot pattern-match for sections about features not mentioned in prior session notes. Re-evaluate at next /repo-dd run.

---

## Section 3: Friction and Improvement Synthesis

### 3.1 Recurring Friction Patterns

| Pattern | Frequency | Repos Affected | Root Cause | Recommendation |
|---|---|---|---|---|
| **None identified** | — | — | — | Project is at initial-commit state; `logs/friction-log.md`, `logs/improvement-log.md`, `logs/session-notes.md`, `logs/coaching-log.md`, `logs/workflow-observations.md` are all absent. No usage history to mine. Re-evaluate after first 5 operational sessions. |

### 3.2 Improvement Pipeline Health

| Metric | Value |
|---|---|
| Improvement entries logged | 0 |
| Improvement entries applied | 0 |
| Improvement entries verified | 0 |
| Improvement entries stalled | 0 |

`logs/improvement-log.md` does not exist. Expected for a vessel project at initial commit. Pipeline becomes meaningful after operational use.

### 3.3 Specific Recommendations

Recommendations are drawn from the deferred-validation entries in `logs/decisions.md`, the criticality analysis in §1, and the pipeline-testing findings in §4.

1. **[HIGH] Resolve the `/decide` name collision** (surfaced by Section 4 Test 2).
   - Effort: quick (<1 session). Two viable paths: (a) rename the strategic-os command to something non-colliding (e.g., `/os-decide`, `/strategic-decide`, `/strategy-q`) and update CLAUDE.md + docs/ + decisions-log references; (b) extend `auto-sync-shared.sh`'s drift-detection to recognise a project-local override marker (e.g., a `# AUTOSYNC: project-local-override` line in YAML frontmatter) and silence the false positive.
   - Why HIGH: today the recurring drift warning at SessionStart is signal-noise that will train the operator to ignore real auto-sync drift. Path (a) is the cleaner long-term fix; path (b) preserves the project's chosen surface but requires editing the auto-sync mechanism in ai-resources.

2. **[HIGH] Validate W1 (Bash-heredoc write bypass) on first /promote-to-live invocation.**
   - Effort: quick (<1 session). Watch the first invocation; if Bash heredoc is blocked by destination-path scoping, implement fallback Option B (operator approves once per session) before continuing strategic-state work.
   - Why HIGH: the entire write path for `state/live/**` depends on this assumption holding. If it fails silently or with a permission prompt loop, the OS is stuck.

2. **[MEDIUM] Decide HANDOFF.md treatment before first /os-self-review run against live state.**
   - Effort: quick. Either create the file (stub or real content) or remove the references from `/os-self-review` and `self-review-agent.md`.
   - Why MEDIUM: today the references are dormant (no live state to review). They become a failure mode the first time /os-self-review runs against populated `state/live/*` — currently deferred per the audit triage, but the deferral has a clear trigger event.

3. **[MEDIUM] Strengthen W7 (/decide's KB check) when `knowledge-bases/strategic-frameworks/` deploys.**
   - Effort: quick. Per W7 resolution: replace `test -d` with `test -d && test -f .claude/commands/kb-query.md`. Already documented in `logs/decisions.md`; just needs to be executed at trigger event.

4. **[LOW] Designate one canonical source for the Cross-Project Read Protocol exclusion list.**
   - Effort: moderate (~half session). The list lives in both `CLAUDE.md` and `state-retrieval-agent.md`. Pick one as canonical, make the other a pointer.
   - Why LOW: today the two copies are in sync. The risk is drift over time as one or the other is edited in isolation. W6 already flags this risk but doesn't fix it.

5. **[LOW] Document the `pipeline/` directory or relocate it.**
   - Effort: moderate. 12 files / 5,253 lines outside the spec § 1 tree. Either add a section to the spec (or a README) explaining its purpose, or move under `output/` or archive.
   - Why LOW: no operational dependency on it; pure documentation/tidiness concern.

6. **[LOW] Add a section to CLAUDE.md acknowledging W1's deferred-validation status until it's resolved.**
   - Effort: quick. Today only `logs/decisions.md` notes this; CLAUDE.md doesn't mention that the write path is conditionally validated. A reader of CLAUDE.md alone would not see the load-bearing assumption.

---

## Section 4: Pipeline Testing

Tests applicable to a scoped (single-project) audit are run below. Workspace-level pipeline preconditions (Tests 3, 4, 5 in the canonical spec — /deploy-workflow, /new-project, /sync-workflow readiness) are N/A at this scope.

### Test 1 — Symlink resolution

| Result | Detail |
|---|---|
| **PASS** | 76/76 symlinks under `.claude/agents/` (19) + `.claude/commands/` (57) resolve cleanly. Target file exists, readable, non-empty in every case. |

### Test 2 — Template sync (regular-file copies vs canonical counterparts)

| Result | Detail |
|---|---|
| **FAIL** | 1 of 1 non-symlink command file diverges from its canonical counterpart. **The other ~76 are symlinks (not regular files) and so not subject to this test.** |

**Divergence detail — `/decide` command file:**

- **Local:** `projects/strategic-os/.claude/commands/decide.md` (109 lines, regular file)
- **Canonical:** `ai-resources/.claude/commands/decide.md` (164 lines)
- **Nature of divergence:** these are **two semantically different commands sharing one name**, not "the same command with edits."
  - Strategic-os `/decide`: takes a free-form decision query argument; runs state retrieval → framework selection → 5-field response (Core recommendation, Alternatives, Reasoning, Risks, Next action); writes to `responses/`.
  - Canonical `/decide`: takes a list of pending operator-decision questions (auto-detected from recent `/qc-pass`/`/scope`/`/clarify` output); attempts evidence-grounded resolution; outputs a three-bucket structured result.
- **Intent:** strategic-os `/decide` is a **project-local override by design** — it implements the strategic-OS decision-query surface (W3.1/W3.2/W3.3 of the OS spec).
- **Why this fired today:** the `auto-sync-shared.sh` hook compared the local file to the canonical and reported "drift." Its detection logic does not distinguish "intentional project-local override" from "stale auto-synced copy." Result: a persistent false-positive at every session start.

This is a HIGH finding because:

1. The collision creates a documentation/training-data hazard — searching `/decide` across the workspace returns two different semantics; future Claude sessions reading the canonical command outside a strategic-os session will load the canonical meaning.
2. The recurring drift warning at SessionStart is signal-noise — operators will eventually start ignoring real auto-sync drift because this one always fires.

### Test 3, 4, 5 — workspace-level pipeline preconditions

N/A — out of scope for `projects/strategic-os`. These tests check whether workspace-level pipelines (`/deploy-workflow`, `/new-project`, `/sync-workflow`) have their canonical inputs in place. Strategic-os does not deploy or sync workflows.

### Test 6 — strategic-os-specific: permission-deny structural check

| Result | Detail |
|---|---|
| **PASS (structural only)** | `Write(projects/strategic-os/state/live/**)` and `Edit(projects/strategic-os/state/live/**)` are both present in the deny list. Runtime validation (does the Bash-heredoc bypass per W1 actually work?) requires a real `/promote-to-live` invocation and was not exercised. W1 deferred-validation status unchanged. |

---

## Summary

- **Critical findings:** 0
- **High findings:** 2
  - `/decide` name collision between project-local strategic-os version and ai-resources canonical (different commands, same name). Creates a persistent SessionStart drift warning that desensitises the operator to real drift signals.
  - W1 deferred validation (Bash-heredoc bypass for `state/live/**` writes) — must be validated at first /promote-to-live invocation, before the OS becomes operational.
- **Medium findings:** 2
  - HANDOFF.md treatment must be decided before first /os-self-review against live state.
  - /decide's KB check should upgrade from directory-only to file-level when `knowledge-bases/strategic-frameworks/` is deployed.
- **Low findings:** 3
  - Cross-Project Read Protocol exclusion list lives in two sources (drift risk).
  - `pipeline/` directory undocumented relative to spec § 1.
  - CLAUDE.md does not surface W1's deferred-validation status.

### Top 3 Recommendations by Impact

1. **Resolve the /decide name collision.** Highest-impact for daily operator experience: the recurring auto-sync drift warning at SessionStart erodes signal value of all future drift warnings. A 30-minute rename (or a one-line YAML marker support in `auto-sync-shared.sh`) eliminates a recurring false positive.

2. **Validate W1 at first /promote-to-live run.** Highest-impact for OS correctness: the entire promotion chain depends on a single architectural assumption (Bash-heredoc write bypasses Write/Edit deny). A single hour's attention at first operational use resolves the largest correctness risk in the OS.

3. **Designate canonical source for Cross-Project Read Protocol exclusion list.** Medium effort, prevents a silent confidentiality regression. Compounds in value as new cross-project agents are added (W6 already anticipates this).

The OS is structurally complete and ready for v1 acceptance testing. No critical defects. The two HIGH findings are both addressable in a single follow-up session: the /decide collision is a one-decision rename, and W1 validation is a single Bash-heredoc test at first /promote-to-live use.
