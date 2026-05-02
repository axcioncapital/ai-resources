# Section 4 — Workflow Token Efficiency Audit
## Workflow: new-project

**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow scope:** `/new-project` orchestrator + spawned subagents
**Telemetry available:** No session-usage-analyzer log was inspected for this section. All "typical" estimates below are **structural inferences** derived from workflow instructions and file-loading patterns, not observed run data.

---

### File Inventory (workflow surface)

| File | Lines | Words | Est. tokens (×1.3) |
|------|-------|-------|--------------------|
| `.claude/commands/new-project.md` (orchestrator) | 527 | 5279 | ~6863 |
| `.claude/agents/pipeline-stage-3a.md` | 135 | 743 | ~966 |
| `.claude/agents/pipeline-stage-3b.md` | 46 | 234 | ~304 |
| `.claude/agents/pipeline-stage-3c.md` | 44 | 235 | ~306 |
| `.claude/agents/pipeline-stage-4.md` | 64 | 386 | ~502 |
| `.claude/agents/pipeline-stage-5.md` | 41 | 227 | ~295 |
| `.claude/agents/session-guide-generator.md` | 57 | 400 | ~520 |
| **Sum (orchestrator + 6 agents)** | **914** | **7504** | **~9755** |

Skills loaded by subagents (each in its own subagent context, not main session):

| Skill | Lines | Words | Est. tokens |
|-------|-------|-------|-------------|
| `skills/architecture-designer/SKILL.md` | 241 | 2104 | ~2735 |
| `skills/implementation-spec-writer/SKILL.md` | 296 | 1717 | ~2232 |
| `skills/project-implementer/SKILL.md` | 187 | 1096 | ~1425 |
| `skills/project-tester/SKILL.md` | 222 | 1358 | ~1765 |
| `skills/session-guide-generator/SKILL.md` | 247 | 2022 | ~2629 |

Workspace baseline (loaded every turn — not workflow-specific but in-scope for "what gets loaded at workflow start"):

| File | Lines | Words | Est. tokens |
|------|-------|-------|-------------|
| Workspace `CLAUDE.md` | 219 | 3202 | ~4163 |
| Project `CLAUDE.md` (`ai-resources/CLAUDE.md`) | 92 | 950 | ~1235 |

---

### Step 4.2 — Token Flow Map

#### 1. What gets loaded at workflow start

Main-session orchestrator context at `/new-project` invocation:

1. Workspace `CLAUDE.md` — 219 lines, ~4163 tokens (every turn, not just workflow start)
2. Project `CLAUDE.md` (`ai-resources/CLAUDE.md`) — 92 lines, ~1235 tokens (every turn)
3. `.claude/commands/new-project.md` orchestrator body — 527 lines, ~6863 tokens (loaded on slash-command invocation)
4. **Total estimated start-of-workflow main-session context: ~12,261 tokens** (CLAUDE.md ×2 + orchestrator)

The orchestrator body (~6863 tokens) is the workflow's dominant per-invocation load. It includes verbatim canonical blocks (Input File Handling, Commit Rules, Compaction, Session Boundaries) duplicated multiple times — once as `**Canonical block** (copy verbatim)` reference text inside the procedure description (lines ~382–428), once inside the `cat > "$CLAUDE_MD" <<'EOF' ... EOF` heredoc (lines ~432–472), and again inside the `printf` idempotent-append fallback (lines ~478–503). Net effect: each canonical block appears 2–3× inside the orchestrator file.

#### 2. Subagent calls per workflow run

Six subagent invocations along the canonical First-Run full-pipeline path (including optional Stage 6):

| Stage | Subagent | Model | Skill loaded inside subagent |
|-------|----------|-------|------------------------------|
| 3a | `pipeline-stage-3a` | sonnet | (none — mechanical scan) |
| 3b | `pipeline-stage-3b` | opus | `architecture-designer` (241 lines) |
| 3c | `pipeline-stage-3c` | opus | `implementation-spec-writer` (296 lines) |
| 4 | `pipeline-stage-4` | sonnet | `project-implementer` (187 lines) |
| 5 | `pipeline-stage-5` | sonnet | `project-tester` (222 lines) |
| 6 (optional) | `session-guide-generator` | sonnet | `session-guide-generator` skill (247 lines) |

Each subagent runs in its own context; only the subagent's *return* re-enters the main session.

#### 3. Estimated subagent return volume

Each subagent file specifies what to **announce** to the main session. Five of the six lack an explicit ≤N-line cap on the return value. Concretely:

| Subagent | Return-shape spec in agent file | Cap declared? |
|----------|---------------------------------|---------------|
| `pipeline-stage-3a` | "Repo snapshot complete — {X} skills, {Y} subdirectories, {W} workflows. Saved to {path}." (line 129) — single sentence | **No explicit line cap** |
| `pipeline-stage-3b` | "Stage 3b complete. Architecture saved to {path}. {N} design decisions recorded." (line 46) | **No explicit line cap** |
| `pipeline-stage-3c` | "Stage 3c complete. Implementation spec saved to {path}. {N} operations defined." (line 45) | **No explicit line cap** |
| `pipeline-stage-4` | "Stage 4 complete. {N} operations executed... Implementation log saved to {path}." (line 62) | **No explicit line cap** |
| `pipeline-stage-5` | "Stage 5 complete. Test results saved to {path}. {passed}/{failed}/{warnings}..." (line 41) | **No explicit line cap** |
| `session-guide-generator` | "Keep the returned summary under 30 lines... Do not echo the full guide" (lines 50–57) | **Yes — 30-line cap** |

Each agent does **save full output to disk** (canonical paths under `{pipeline}/`), satisfying the output-to-disk pattern. The announce templates are short single-sentence strings, so structurally the return *should* be small. However, no agent file enforces a hard line-cap or "summary contract" comparable to `token-audit-auditor` / `repo-dd-auditor` (`ai-resources/CLAUDE.md` § Subagent Contracts). In practice subagents may append diagnostic content beyond the announce template; without a stated cap the bound is the model's discretion.

Stage 3a is the most exposed: the announce template names {X}/{Y}/{W} counts but the agent's body explicitly enumerates "Skill Inventory ({count} skills)" and "{One section per subdirectory discovered under .claude/}" tables in its **output document** (lines 82–116). If an operator asks "summarize what you found," the inventory tables are large (current `ai-resources` has ~95 skills × 1 row each). Risk of accidental full-table echo into main session is structural.

#### 4. QC / refinement cycles designed into the workflow

The `/new-project` orchestrator does not invoke `qc-reviewer` / `triage-reviewer` / `refinement-reviewer` subagents at any stage. QC is implicit — the operator reviews each stage's saved artifact and gates the next stage with `NEXT` / `ABORT`. Each stage is therefore one-pass per attempt; refinement cycles materialize only if a stage is re-run after operator-driven correction (e.g., 3c warns of architecture gaps → return to 3b → re-run 3c).

Refinement multiplier baseline: **1.0× per stage** under normal flow, with stage-3b/3c rework as the modeled exception. Under "happy path" the workflow executes 6 subagent invocations. Under "one architecture-gap rework" it executes ~8. No structural mechanism designs for >3 cycles.

#### 5. File reads — main session vs delegable

| Read site | File(s) | Size | Where | Necessary / Delegable |
|-----------|---------|------|-------|----------------------|
| First Run step 4 (orchestrator) | `$SRC/context-pack.md` (existence check via `[ -f ]`) | n/a — no Read tool call | main | Necessary (existence test) |
| First Run step 4 (orchestrator) | `$SRC/plan-qc-verdict.md`, `$SRC/spec-qc-verdict.md` (grep -q only) | small | main | Necessary (small + advisory) |
| First Run step 7 (orchestrator) | `cp` of `context-pack.md`, `project-plan.md`, optional `tech-spec.md` | varies; planning artifacts can be 200–800+ lines | main (shell copy, not Read tool) | Necessary if `cp` only — no context cost. **Note**: orchestrator does not specify whether main session also `Read`s these to populate `{project-description}` for CLAUDE.md scaffolding (step 11a / Post-Pipeline-Enrichment step 4 references "one-line description from the pipeline's context pack, or a generic placeholder if absent"). If main session Reads context-pack.md to extract description, that's a potentially-200+-line read into main context. **Delegable** — placeholder is allowed. |
| Pre-flight identifier verification (step 11a) | `projects/buy-side-service-plan/CLAUDE.md` | ~50–150 lines | main | Necessary (small file, single-purpose check) |
| Stage 3a subagent | full repo CLAUDE.md, every SKILL.md, every `.claude/{commands,agents,hooks}/*` file frontmatter, top-level dir listings | LARGE (~95 skills + ~75 commands + ~30 agents + workflows). Conservative aggregate ≥15,000 lines | **subagent** | Necessary; correctly delegated |
| Stage 3b subagent | `project-plan.md`, `repo-snapshot.md`, optional `technical-spec.md`, `decisions.md` | repo-snapshot.md from 3a can be 1000–3000 lines; project-plan.md often 200–600 lines | **subagent** | Necessary; correctly delegated |
| Stage 3c subagent | `architecture.md`, `repo-snapshot.md`, optional `technical-spec.md`, `decisions.md`, `project-plan.md` | similar large reads | **subagent** | Necessary; correctly delegated. **Note**: re-reads `repo-snapshot.md` already read by 3b — duplicate read across two opus-tier subagents. |
| Stage 4 subagent | `implementation-spec.md`, `decisions.md` | implementation-spec.md typically 300–800 lines | **subagent** | Necessary; correctly delegated |
| Stage 5 subagent | `implementation-spec.md`, `implementation-log.md` | both can be large | **subagent** | Necessary; correctly delegated |
| Stage 6 subagent | `pipeline/project-plan.md`, optional `pipeline-state.md`, optional session notes | per skill cascade | **subagent** | Necessary; correctly delegated |

All large reads are delegated. The orchestrator main session itself does not perform any large-file Read in canonical flow. This is structurally healthy.

#### 6. File writes — disk vs context

| Write site | File | Where written |
|------------|------|---------------|
| First Run step 7 | `pipeline/{context-pack,project-plan,technical-spec}.md` | disk (cp) |
| First Run step 8 | `pipeline/sources.md` | disk |
| First Run step 9 | `pipeline/decisions.md` | disk |
| First Run step 10 | `pipeline/pipeline-state.md` | disk |
| First Run step 11a | append `## Model Selection` to `projects/{name}/CLAUDE.md` | disk |
| Post-Pipeline Enrichment 1 | `.claude/shared-manifest.json` | disk |
| Post-Pipeline Enrichment 2 | `.claude/settings.json` | disk (jq merge) |
| Post-Pipeline Enrichment 4 | `projects/{name}/CLAUDE.md` (4 canonical blocks) | disk |
| Stage 3a | `pipeline/repo-snapshot.md` | disk |
| Stage 3b | `pipeline/architecture.md`, append to `pipeline/decisions.md` | disk |
| Stage 3c | `pipeline/implementation-spec.md`, append to `pipeline/decisions.md` | disk |
| Stage 4 | `pipeline/implementation-log.md`, files in worktree | disk |
| Stage 5 | `pipeline/test-results.md` | disk |
| Stage 6 | `pipeline/session-guide.md` | disk |

All artifacts go to disk. No "write to context" pattern observed.

---

### Assessment Findings

#### Finding 1 — No explicit return-size cap on Stages 3a/3b/3c/4/5

**Severity classification:** MEDIUM (per §4 severity rules: "Subagent returning >200 lines to main session → HIGH"; but here the agents only specify a 1-line announce template, not >200-line returns. The risk is *unbounded* not *quantified-large*. Documenting as MEDIUM "missing safeguard" since the 30-line cap pattern from `ai-resources/CLAUDE.md § Subagent Contracts` and the precedent in `session-guide-generator.md` (line 50: "under 30 lines") is not propagated to the five pipeline-stage agents.)
**Evidence:** `pipeline-stage-3a.md` lines 127–129; `pipeline-stage-3b.md` lines 44–46; `pipeline-stage-3c.md` lines 43–45; `pipeline-stage-4.md` lines 60–62; `pipeline-stage-5.md` lines 39–41. None contain "under N lines" or "summary cap" wording.
**Waste mechanism:** Without a hard cap, subagent returns are bounded only by the announce template plus model discretion. If a stage subagent appends diagnostic explanation, full tables, or a "what I did" recap to the announce string, the main session pays for it on every spawn and on every subsequent main-session turn until /compact.

#### Finding 2 — Stage 3a inventory output structurally enables large-table echo into return

**Severity classification:** MEDIUM (boundary — would be HIGH if the agent literally returned the inventory; current text returns a count summary. Rated MEDIUM because the body of the agent file describes producing "Skill Inventory ({count} skills)" and per-subdirectory tables, and the operator pattern of saying "show me what you found" can prompt the agent to echo the full snapshot. Tagging boundary because actual return depends on operator behavior.)
**Evidence:** `pipeline-stage-3a.md` lines 82–116 (output template), line 129 (announce template). The two are in tension: the body makes the inventory document feel like the "deliverable," but the announce template is a 1-line summary.
**Waste mechanism:** If echoed, current `ai-resources` skill count alone is ~95 skills × ~80–100 chars/row ≈ 7600–9500 chars (~2000–2500 tokens) just for the skill inventory table — and that's before commands/agents/workflows tables.

#### Finding 3 — Orchestrator file is 527 lines / ~6863 tokens — over Section 1's >300-line HIGH threshold for instruction files

**Severity classification:** MEDIUM (the protocol's >300-line HIGH rule in §1 explicitly targets CLAUDE.md, not command files; §3 does not set a hard line threshold for command files. Reporting as MEDIUM by analogy: a command file that loads on slash invocation costs ~6863 tokens once, plus stays in context for the orchestration session. Comparable to a "high-cost command" in §3. Boundary tagged because the §3 threshold is "loading >500 tokens of external context" and this file does not load external content into the main session — its own body is the cost.)
**Evidence:** `wc -l .claude/commands/new-project.md` = 527; `wc -w` = 5279 → ~6863 tokens.
**Waste mechanism:** Every `/new-project` session loads ~6863 tokens of orchestrator instructions, of which an estimated 30–40% is verbatim canonical block content (Input File Handling, Commit Rules, Compaction, Session Boundaries) appearing 2–3× — once as "copy verbatim" reference, once inside the heredoc, and again inside the `printf` idempotent-append fallback. Cf. lines ~382–504.

#### Finding 4 — No `/compact` breakpoint declared between stages

**Severity classification:** MEDIUM (per §4: "No compaction instructions or breakpoints defined → MEDIUM").
**Evidence:** `grep -i "compact"` against `new-project.md` and all six agent files returns hits only on (a) the verbatim Compaction canonical block being scaffolded into the *project's* CLAUDE.md (orchestrator lines ~410–418, 460–467), and (b) `printf` idempotent-append fallback. **No instruction tells the orchestrator session to /compact between Stages 3a→3b, 3b→3c, etc.** The pipeline can run 6 sequential subagent spawns, each adding return tokens, plus operator NEXT/ABORT gates between them, without a structural compaction breakpoint.
**Waste mechanism:** A long-running `/new-project` session accumulates: 6 subagent returns + 6 operator-gate exchanges + orchestrator pipeline-state.md updates after each stage (small but additive). For full pipeline runs this is a multi-hour, multi-turn session; absence of a /compact prompt at, e.g., post-Stage 3a or post-Stage 4 is a structural omission.

#### Finding 5 — Verbatim canonical-block duplication inside orchestrator (3 surfaces × 4 blocks)

**Severity classification:** MEDIUM (boundary — overlaps with Finding 3 above; this is the specific mechanism behind orchestrator file size).
**Evidence:** `.claude/commands/new-project.md` lines 382–428 (canonical block reference text for Commit Rules, Input File Handling, Compaction, Session Boundaries — each shown as "copy verbatim" markdown), lines 432–472 (same blocks inside `cat > <<'EOF' ... EOF` heredoc), lines 478–503 (same blocks inside `printf` fallback statements with shell-escaped quoting). Each of the four canonical blocks (~3–10 lines each) appears ~3 times. Estimated 60–90 lines of duplicated content out of 527 total lines (~11–17% of file).
**Waste mechanism:** Loaded on every `/new-project` invocation. The duplication is functional (the heredoc and printf paths both need the literal text since `<<'EOF'` doesn't expand variables and printf is the append-mode counterpart), but a `cat $CANONICAL_FILE` pattern reading from a single canonical-blocks file would compress this. Reporting as fact only.

#### Finding 6 — Model selection (sonnet for orchestrator, opus for 3b/3c) is configured correctly

**Severity classification:** PASS (out-of-scope for §4 severity rules; recording for completeness).
**Evidence:** `.claude/commands/new-project.md` line 2: `model: sonnet`. Subagent models: 3a/4/5/6 = sonnet; 3b/3c = opus.

#### Finding 7 — Stage 3c re-reads `repo-snapshot.md` already consumed by Stage 3b

**Severity classification:** LOW (per §4: "Large file reads in main session that could be delegated → HIGH" applies to *main-session* reads. This is subagent→subagent duplication. The cost is real but each subagent's context is independent, so this affects subagent cost not main-session cost.)
**Evidence:** `pipeline-stage-3b.md` lines 17–20 (reads `repo-snapshot.md`); `pipeline-stage-3c.md` lines 17–20 (also reads `repo-snapshot.md`).
**Waste mechanism:** repo-snapshot.md is large (per Stage 3a output spec — full inventory across skills/commands/agents/workflows/dirs). Reading it twice across two opus-tier subagents (3b and 3c are both `model: opus`) adds opus-tier per-token cost. A digest pattern (3b extracts the architecture-relevant slice into architecture.md; 3c reads architecture.md not repo-snapshot.md) could remove the duplicate. Reporting as fact only.

#### Finding 8 — Refinement multiplier ≤1; no QC subagents wired into pipeline

**Severity classification:** LOW (per §4: ">3 refinement cycles → MEDIUM". Pipeline does not exceed 3.)
**Evidence:** No invocations of `qc-reviewer`, `triage-reviewer`, `refinement-reviewer`, `qc-gate`, or `/qc-pass` anywhere in `new-project.md` or the six pipeline agent files. Operator gating substitutes for QC subagents.
**Waste mechanism:** N/A as token-waste; flagged for completeness because the workspace `## QC Independence Rule` mandates fresh-context QC subagents for evaluation work, and pipeline-generated artifacts (architecture.md, implementation-spec.md, test-results.md) are evaluation-class outputs. Whether this is an audit gap or a deliberate design (operator IS the QC) is out of scope for §4.

---

### Report-Format Block (per protocol §4 template)

#### Workflow: new-project

**Context loading chain:**
1. Workspace `CLAUDE.md` loads (~4163 tokens) — every turn, not workflow-specific
2. `ai-resources/CLAUDE.md` loads (~1235 tokens) — every turn in this project
3. Slash command `/new-project` invoked → loads `.claude/commands/new-project.md` body (~6863 tokens)
4. Subagent spawns each carry their own context (not main-session cost) but each loads its agent file (~300–960 tokens) plus a skill (3b/3c/4/5/6 only — 1425–2735 tokens each)

**Total estimated start-of-workflow main-session context:** ~12,261 tokens (CLAUDE.md ×2 + orchestrator body)

**File reads during execution (main session):**

| File | Size | Read in main/subagent | Necessary / Delegable |
|------|------|-----------------------|------------------------|
| `$SRC/plan-qc-verdict.md` (grep -q) | small | main | Necessary |
| `$SRC/spec-qc-verdict.md` (grep -q) | small | main | Necessary |
| `projects/buy-side-service-plan/CLAUDE.md` (precedent verification) | ~50–150 lines | main | Necessary |
| `projects/{name}/pipeline/pipeline-state.md` (after each stage) | <30 lines | main | Necessary |
| (Possibly) `pipeline/context-pack.md` for `{project-description}` | 200–800 lines | main if performed | Delegable / can be skipped (placeholder allowed) |

**Subagent pattern:**

| Subagent purpose | Returns to main? | Return size cap | Disk write |
|-----------------|------------------|-----------------|-----------|
| Stage 3a — repo snapshot | Yes (announce template) | None declared | `pipeline/repo-snapshot.md` |
| Stage 3b — architecture | Yes (announce template) | None declared | `pipeline/architecture.md` |
| Stage 3c — impl spec | Yes (announce template) | None declared | `pipeline/implementation-spec.md` |
| Stage 4 — implementation | Yes (announce template) | None declared | `pipeline/implementation-log.md` + worktree files |
| Stage 5 — testing | Yes (announce template) | None declared | `pipeline/test-results.md` |
| Stage 6 — session guide | Yes | "under 30 lines" (line 50) | `pipeline/session-guide.md` |

**Findings:**

| # | Finding | Severity | Waste mechanism |
|---|---------|----------|----------------|
| 1 | Five pipeline-stage agents lack an explicit return-size cap | MEDIUM | Unbounded subagent returns to main session |
| 2 | Stage 3a structurally exposes a large inventory document; risk of full-table echo if operator prompts | MEDIUM (boundary) | Inventory tables (~95 skills + commands + agents) returnable as text |
| 3 | Orchestrator file ~6863 tokens loaded on every invocation | MEDIUM (boundary) | Per-invocation overhead in main session |
| 4 | No `/compact` breakpoint between pipeline stages | MEDIUM | Multi-hour 6-subagent sessions accumulate context without compaction prompt |
| 5 | Canonical blocks duplicated 3× inside orchestrator (~60–90 lines redundancy) | MEDIUM (boundary) | Inflates orchestrator load size |
| 6 | Model selection configured correctly | PASS | n/a |
| 7 | Stages 3b and 3c both Read `repo-snapshot.md` (subagent-side duplication) | LOW | Duplicate large-file read in opus-tier subagents |
| 8 | No QC/refinement subagents wired into pipeline; operator-gate substitutes | LOW | Refinement multiplier ≤1; not a token waste in §4 framing |

---

### Severity Counts

- HIGH: 0
- MEDIUM: 4 (Findings 1, 4) + 2 boundary-tagged (Findings 2, 3, 5 — three MEDIUM-boundary)
  - Net MEDIUM count: **5** (Findings 1, 2, 3, 4, 5; with 2/3/5 boundary-tagged)
- LOW: 2 (Findings 7, 8)
- PASS: 1 (Finding 6)
- Total flagged findings: **7** (excluding the PASS)

### Boundary-tagged findings (per token-estimation caveat)

- Finding 2 (boundary) — severity depends on operator behavior, not file content
- Finding 3 (boundary) — protocol §3/§4 do not specify a command-file line/word threshold; classified by analogy
- Finding 5 (boundary) — duplication count of "3×" treats `cat <<'EOF'` heredoc and `printf` fallback as separate instances; under stricter counting this could be 2× not 3×

### Protocol gaps

- §4 severity rules target main-session reads, subagent returns, compaction, and refinement cycles. They do not directly classify (a) orchestrator file size (Finding 3) or (b) within-orchestrator content duplication (Finding 5). Both findings are reported as MEDIUM by analogy to §1 and §3 thresholds; main session may want to reclassify in §9.
- The "subagent return volume" check in §4 step 1 asks whether subagents return full output vs summary; current pipeline-stage agents declare a *short announce template* but not a *cap*. This intermediate state is not directly addressed by the HIGH/MEDIUM rule list. Reported as MEDIUM "missing safeguard."
- No live telemetry consulted for §4; estimates are structural per protocol guidance.
