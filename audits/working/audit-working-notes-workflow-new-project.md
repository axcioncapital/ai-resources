# Workflow Token Efficiency — /new-project Pipeline

**Workflow entry point:** `.claude/commands/new-project.md` (698 lines, 6,883 words ≈ 8,948 tokens)
**Workflow shape:** 5-stage subagent pipeline (3a → 3b → 3c → 4 → 5), optional Stage 6, plus 3b→3c Architecture Gate.
**Telemetry note:** No session telemetry observed for `/new-project` runs in the operator-supplied inputs. All "typical" estimates below are **structural inferences** derived from workflow instructions and file-loading patterns, not observed data.

---

## Context Loading Chain

### Workflow start (orchestrator session)

1. Workspace `CLAUDE.md` — 174 lines, ~1,431 words → ~1,860 tokens (loaded every session).
2. `ai-resources/CLAUDE.md` — 90 lines, ~722 words → ~939 tokens (loaded every session when CWD is ai-resources or workspace root).
3. Slash dispatch `/new-project` loads `.claude/commands/new-project.md` — **698 lines, 6,883 words → ~8,948 tokens** into the orchestrator turn.

**Orchestrator-session start subtotal:** ~11,747 tokens before any user input or subagent spawn (CLAUDE.md ×2 + orchestrator command file). The command file alone is the largest single contributor.

### Per-stage subagent context (each stage spawns fresh)

Each stage agent loads its own definition + the skill(s) declared in `skills:` frontmatter + workspace-level CLAUDE.md.

| Stage | Agent file | Agent lines/words | Bound skill(s) | Skill lines/words | Per-spawn ~tokens (agent + skill + workspace CLAUDE.md) |
|-------|-----------|-------------------|----------------|--------------------|---------------------------------------------------------|
| 3a Repo Snapshot | `pipeline-stage-3a.md` 139 / 775 | — (no skill) | n/a | ~1,007 + 1,860 = **~2,867** |
| 3b Architecture | `pipeline-stage-3b.md` 50 / 260 | `architecture-designer` | 241 / 2,104 | 338 + 2,735 + 1,860 = **~4,933** |
| 3c Impl Spec | `pipeline-stage-3c.md` 48 / 261 | `implementation-spec-writer` | 296 / 1,717 | 339 + 2,232 + 1,860 = **~4,431** |
| 4 Implementation | `pipeline-stage-4.md` 68 / 417 | `project-implementer` | 187 / 1,096 | 542 + 1,425 + 1,860 = **~3,827** |
| 5 Testing | `pipeline-stage-5.md` 45 / 255 | `project-tester` | 222 / 1,358 | 332 + 1,765 + 1,860 = **~3,957** |
| 6 Session Guide | `session-guide-generator.md` 57 / 400 | `session-guide-generator` | 247 / 2,022 | 520 + 2,629 + 1,860 = **~5,009** |

Architecture Gate (3b→3c) additionally invokes `/implementation-triage` (65 lines / ~110 line context cost) which uses the `system-owner` agent (151 lines, ~250 line context cost) — an extra short-lived spawn inserted between Stage 3b and Stage 3c.

### Inputs read by subagents (from pipeline directory)

| Read by | File | Source | Notes |
|---------|------|--------|-------|
| 3a | repo content (all skills + .claude/ + workflows + tree) | live repo | Mechanical scan, files are summarized — not loaded full into context (per agent rule "full file contents are NOT included") |
| 3b | `project-plan.md`, `repo-snapshot.md`, `technical-spec.md` (optional), `decisions.md` | pipeline dir | All four files read full into subagent context |
| 3c | `architecture.md`, `repo-snapshot.md`, `technical-spec.md` (optional), `decisions.md`, `project-plan.md` | pipeline dir | **5 files** read full into subagent context |
| 4 | `implementation-spec.md`, `decisions.md` | pipeline dir | Plus repeated filesystem verification reads per operation (per `project-implementer` skill: "verify each operation by reading the filesystem") |
| 5 | `implementation-spec.md`, `implementation-log.md` | pipeline dir | Both full reads |
| 6 | `project-plan.md`, `pipeline-state.md` (plus state-detection cascade) | pipeline dir | Lean by skill design |

---

## Subagent Pattern (Return Volumes)

All 6 stage agents declare an explicit **Return Contract** capping main-session return at **≤30 lines** and writing the full artifact to disk. The return contract pattern is consistently applied across the pipeline.

| Subagent | Disk artifact | Return cap | Compliance with subagent-contract rule |
|----------|--------------|------------|----------------------------------------|
| pipeline-stage-3a | `repo-snapshot.md` | ≤30 lines | Compliant; explicit "Do not return the full snapshot content" |
| pipeline-stage-3b | `architecture.md` | ≤30 lines | Compliant; "Do not return architecture content" |
| pipeline-stage-3c | `implementation-spec.md` | ≤30 lines | Compliant; "Do not return spec content" |
| pipeline-stage-4 | `implementation-log.md` | ≤30 lines | Compliant; "Do not return file contents or per-operation details" |
| pipeline-stage-5 | `test-results.md` | ≤30 lines | Compliant; "Do not return full test details" |
| session-guide-generator | `session-guide.md` | <30 lines | Compliant; "Do not echo the full guide in your summary" |

**Finding:** Subagent return volume across the pipeline is **disciplined** — no agent returns full artifact content to the orchestrator. No HIGH-severity finding under §4 rule "Subagent returning >200 lines to main session."

---

## File-Read Mapping (Main Session vs. Subagent)

| File | Approx size | Read in main session (orchestrator)? | Read in subagent? | Necessary / Delegable |
|------|-------------|--------------------------------------|-------------------|----------------------|
| `pipeline-state.md` | small (~30 lines) | Yes — every operator-gate transition (read before NEXT/SKIP/ABORT decision) | Yes (some stages) | Necessary in main session (state machine) |
| `context-pack.md` | varies (typically 200–600 lines) | No — copied via `cp`, not read | No (passed forward) | n/a |
| `project-plan-v*.md` | varies (typically 200–800 lines) | No — copied via `cp` | Yes (3b, 3c) | Delegable |
| `tech-spec-v*.md` | varies (typically 200–600 lines) | No — copied via `cp` | Yes (3b, 3c) | Delegable |
| `repo-snapshot.md` | typically 300–700 lines | No (orchestrator only consumes return summary) | Yes (3b, 3c) | Delegable |
| `architecture.md` | typically 300–500 lines | Only path is read at Architecture Gate (line 194); content passed by reference to `/implementation-triage` | Yes (3c) | Path-only main-session reference is correct |
| `implementation-spec.md` | typically 400–800 lines | No | Yes (4, 5) | Delegable |
| `implementation-log.md` | typically 100–400 lines | No | Yes (5) | Delegable |
| `projects/buy-side-service-plan/CLAUDE.md` | small (~100 lines, precedent reference) | Yes — Step 11a (line 153) does precedent verification read for Opus 4.7 model-ID string | n/a | Delegable to subagent OR replaceable with `grep` for the exact string OR with an inline constant in the command file |
| Agent files (`pipeline-stage-*.md`) | 45–139 lines each | No (loaded by subagent at spawn) | Yes (spawn) | Necessary |
| Pipeline-invoked skill files | 187–296 lines each | No (loaded by subagent skill resolver) | Yes | Necessary |

**Main-session file reads are minimal by design.** The orchestrator primarily reads `pipeline-state.md` (small, necessary) and writes state updates. Heavy reads happen inside subagents. The Step 11a precedent read (line 153) is the one main-session read of a non-state file.

---

## File-Write Mapping (Main Session)

The orchestrator (main session) performs these direct writes during First Run:

| Operation | Lines | Notes |
|-----------|-------|-------|
| `cp` of context-pack, project-plan, tech-spec | n/a | Filesystem copy, no content loads into orchestrator context |
| Write `pipeline/sources.md` | ~10 lines | Small |
| Write `pipeline/decisions.md` | ~3 lines template | Small |
| Write `pipeline/pipeline-state.md` | ~12 lines | Small |
| Append "Model Selection" block to project CLAUDE.md | ~3 lines | Small |
| Write/append project `CLAUDE.md` (Input File Handling, Commit Rules, Compaction, Session Boundaries) | ~70 lines total | Verbatim heredoc — content not loaded into orchestrator context beyond the command file itself |
| `jq` merge into `.claude/settings.json` (permissions, hooks, additionalDirectories) | embedded JSON | Mechanical jq calls |
| Write `logs/decisions.md` scaffold | ~25 lines | Small |
| Various `git` commits | n/a | Mechanical |

**No large outputs are written into orchestrator-session context.** All large content is either copied via `cp` or written via heredoc inside bash blocks (filesystem only).

---

## Subagent-Call Count

- **First Run minimum (Stages 3a–5):** 5 subagent spawns.
- **First Run with Stage 6:** 6 subagent spawns.
- **First Run with 3b→3c Architecture Gate:** +1 spawn for `/implementation-triage` (which itself wraps `system-owner` agent) = up to **7 subagent spawns** across a single end-to-end run.
- **Each spawn is sequenced** (gated by operator `NEXT`), not parallel — so the orchestrator context grows linearly across the run.

The `[COST]` guardrail threshold is "≥4 subagents." A complete /new-project run **exceeds the [COST] threshold by design** (5–7 subagent spawns).

---

## /compact Opportunities

Compact suggestions present in the orchestrator (line 184, 199):

> "If context has grown from the prior stage, suggest `▸ /compact` before spawning."

This is wired at two transitions: NEXT after any stage (line 184) and inside the Architecture Gate WORTH-DOING branch (line 199).

**Coverage:** 2 explicit compact-suggestion points, but conditional on subjective "context has grown" judgment by the orchestrator — no quantitative threshold (e.g., "after Stage 3a always," or "if context > 50%").

**Gaps (no enforced breakpoint):**
- The line 184 suggestion is generic across all NEXT transitions but qualified by "if context has grown" — operator-discretion-dependent at every stage transition.
- No explicit /compact suggestion at the Stage 5 → Stage 6 transition (post-Stage 5 prompt at line 210 does not mention /compact).
- No suggestion of `/clear + restart from pipeline-state.md` as an alternative for long runs (which would be a stronger reset than /compact).
- Post-Pipeline Enrichment block (lines 226–689 ≈ 460 lines) executes **inside the same orchestrator session** as Stage 5 (or Stage 6) completion. By the time enrichment runs, the orchestrator has accumulated context from every prior stage's return summary + the full 698-line command file + every state-machine read. No /compact breakpoint is inserted before the enrichment block executes.

**Severity per protocol §4:** "No compaction instructions or breakpoints defined → MEDIUM." Two soft suggestions exist; quantitative breakpoints do not. Classify as **MEDIUM-PARTIAL** — compact is mentioned but operator-discretion-only, no enforced cut points at the highest-cost transitions.

---

## Refinement Multiplier

Per §4 assessment question 4: "How many total sessions (main + QC + refinement subagents) a typical run requires."

The /new-project pipeline does not invoke `/qc-pass` or refinement loops automatically. Quality gates are:

- Operator `NEXT`/`SKIP`/`ABORT` between stages (operator-driven, not subagent).
- Architecture Gate at 3b→3c (one extra subagent call: `/implementation-triage`).
- Stage 4 partial-failure / fundamental-failure branches (re-run logic, may loop back to 3b or 3c — but operator-gated).

**Typical-run subagent count for a successful first-pass:** 5 (Stages 3a–5) + 1 (Architecture Gate) = **6 subagents**, optionally +1 for Stage 6.

**If Stage 3b architecture is rejected (MARGINAL/NOT-WORTH-DOING verdict):** add a full Stage 3b re-run = 7+ subagent invocations.
**If Stage 4 fundamental failure:** add a return to Stage 3b or 3c re-spawn = 7+ subagents.

**Worst-case (one round of rework at architecture + one operation-level fix):** ~9 subagent spawns across the workflow. Still bounded by operator gating.

**Severity per protocol §4:** "Consistent need for >3 refinement cycles → MEDIUM." Even worst-case scenarios stay within ≤2 rework loops. No MEDIUM finding here from refinement-multiplier; the pipeline is gate-driven, not refinement-loop-driven.

---

## Findings Table

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---------|----------|-----------------|----------|
| 1 | Orchestrator command file is 698 lines / 6,883 words (~8,948 tokens), the largest command in the repo. Loads in full at every `/new-project` turn, including continuation runs that only need the Gate Protocol or a single stage spawn. | HIGH | Every-turn full load of an orchestrator file that contains large embedded heredocs (canonical Commit Rules block, Input File Handling block, Compaction block, Session Boundaries block, bash-quoted printf chains lines 501–522) duplicated from workspace CLAUDE.md and from in-file `cat > $CLAUDE_MD <<EOF` block at lines 452–492. The 4 canonical blocks appear **twice** inside the orchestrator (once in heredoc, once in idempotent `printf` append fallbacks). | `.claude/commands/new-project.md` lines 396–525 (canonical block heredocs); line counts: 698 lines / 6,883 words verified by `wc -l/-w` |
| 2 | No quantitative /compact breakpoint enforcement — compaction suggestion is operator-discretion-only at 2 transition points (line 184, 199); no suggestion at 5→6 or before the ~460-line Post-Pipeline Enrichment block executes. | MEDIUM | Operator may decline to /compact between Stage 4 (which can run long inside a worktree with per-operation filesystem verification) and Stage 5, then proceed into Enrichment block in the same session, accumulating subagent return summaries across 5+ stages before reset. | `.claude/commands/new-project.md` lines 184, 199 (only compact mentions inside Gate Protocol); lines 207–215 (post-Stage 5 prompt has no /compact suggestion); lines 226–689 (enrichment block, no compact prelude) |
| 3 | Canonical Commit Rules / Input File Handling / Compaction / Session Boundaries blocks are embedded **twice** in the orchestrator: once in the `cat > $CLAUDE_MD <<'EOF'` block (lines 452–492) and once in the four `if grep -q ... else printf` fallbacks (lines 497–523). Roughly 100 lines of duplicated canonical content inside one command file. | MEDIUM | Inflates the per-turn orchestrator load; the duplication has no execution-path benefit (only one path runs per invocation). Refactor candidate: emit canonical blocks from external template files. | `.claude/commands/new-project.md` lines 452–492 vs lines 497–523 |
| 4 | Orchestrator-session start cost ~11,747 tokens (workspace CLAUDE.md + ai-resources CLAUDE.md + 698-line command file) before any subagent spawn. Compared to lighter dispatch commands, this is a high baseline for a command whose runtime job is mostly orchestration (operator-gated state transitions). | MEDIUM | Continuation-mode invocations (resuming an existing pipeline) load the full 8,948-token command file just to read pipeline-state.md and spawn one subagent. The First Run setup logic (lines 42–172, ~130 lines / ~1,300 tokens) is dead weight on every continuation. | `.claude/commands/new-project.md` First Run vs Continuation branches (lines 42–177); see also Finding #1 |
| 5 | Step 11a (line 153) performs a main-session `Read` of `projects/buy-side-service-plan/CLAUDE.md` for Opus 4.7 model-ID precedent verification. Pulls an external project file into the orchestrator context just to confirm a literal string. | MEDIUM | Delegable to a subagent OR replaceable with a single `grep -c "claude-opus-4-7"` bash check OR by hardcoding the canonical identifier as an inline constant in the command file (with a comment pointing to the precedent). The full-file `Read` is unnecessary for the verification job (looking up one string). | `.claude/commands/new-project.md` line 153 |
| 6 | Stage 3c reads 5 input files from pipeline directory (`architecture.md`, `repo-snapshot.md`, `technical-spec.md`, `decisions.md`, `project-plan.md`) — exceeds the "more than 3–4 large files" threshold from Execution Notes (Section 8 best practice #4). All reads happen inside the subagent (correct), but multiple of these inputs are likely 200+ lines each. | LOW | Subagent context bloat (not main-session). Since the agent is dedicated and its return is capped at 30 lines, blast radius is contained — but the per-spawn token cost of Stage 3c is the highest of the stage agents on input size. | `.claude/agents/pipeline-stage-3c.md` lines 17–22 |
| 7 | Workflow exceeds `[COST]` guardrail threshold (≥4 subagents) by design — typical successful run is 5–7 spawns, worst-case rework run ~9. Per workspace session-guardrails doc, `[COST]` is advisory ("emit and continue"), not blocking. | LOW (boundary) | None — this is a structural property of a 5-stage pipeline, not a waste mechanism. Flag is informational so the operator knows /new-project is always a "heavy" command. | Stage spawn count derived from command-file flow (5 mandatory stages + optional Stage 6 + Architecture Gate spawn of /implementation-triage) |
| 8 | All 6 stage agents follow the subagent-return contract (≤30 lines, write-to-disk). Pattern is consistently applied — no return-volume waste. | (affirmative observation — no finding) | n/a | `.claude/agents/pipeline-stage-3a.md` line 137; pipeline-stage-3b.md line 49; pipeline-stage-3c.md line 47; pipeline-stage-4.md line 66; pipeline-stage-5.md line 43; session-guide-generator.md line 48 |

---

## Severity Summary

- HIGH: 1 (Finding #1 — orchestrator file size)
- MEDIUM: 4 (Findings #2, #3, #4, #5)
- LOW: 2 (Findings #6, #7 — #7 boundary)
- Affirmative (no finding): 1 (Finding #8 — subagent return discipline)

---

## Protocol gaps

- §4 measurement step "What gets loaded at workflow start?" does not specify whether to include parent-workspace CLAUDE.md, ai-resources CLAUDE.md, or both. Interpreted as: include every CLAUDE.md that loads when the orchestrator session opens. If the orchestrator session is opened from workspace root (as documented in the CWD guard), both workspace and ai-resources CLAUDE.md may load — counted both above.
- §4 does not define how to count token cost for embedded skill loads (the `skills:` frontmatter in agent files). Interpreted as: each subagent spawn loads its agent file + each listed skill file's full SKILL.md.
- §4 boundary-confidence handling for the "Subagent returning >200 lines" threshold — all stage agents are well below threshold (≤30 line cap), so no boundary calls required for return volume.
- Finding #1 (orchestrator file at 698 lines / 6,883 words → ~8,948 tokens) is squarely above any reasonable command-file threshold and not within ±15% of an ambiguous boundary; classified HIGH with confidence. (not boundary)
- Finding #7 ([COST] guardrail) is classified LOW because it is a structural workflow property, not a waste mechanism — flagged with (boundary) because severity classification rules in §4 are silent on "by-design heavy workflows" and a different reading could justify MEDIUM.
- The §4 "necessary vs. delegable" classification for main-session reads — only `pipeline-state.md` (state machine, necessary) and `projects/buy-side-service-plan/CLAUDE.md` (Step 11a precedent verification, delegable) are read in main session. Findings #5 covers the delegable one.
