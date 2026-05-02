# Section 4 — Workflow Token Efficiency: repo-dd

**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow:** `repo-dd` (3 depth tiers: standard / deep / full)
**Protocol:** token-audit-protocol.md v1.3, Section 4
**Token estimation:** word count × 1.3 (±30% caveat per protocol header)

---

## Workflow file inventory

| Component | Path | Lines | Words | Est. tokens |
|-----------|------|-------|-------|-------------|
| Command | `ai-resources/.claude/commands/repo-dd.md` | 314 | 2,680 | ~3,484 |
| Subagent: factual auditor | `ai-resources/.claude/agents/repo-dd-auditor.md` | 75 | 762 | ~991 |
| Subagent: extract | `ai-resources/.claude/agents/dd-extract-agent.md` | 67 | 480 | ~624 |
| Subagent: log sweep | `ai-resources/.claude/agents/dd-log-sweep-agent.md` | 109 | 600 | ~780 |
| Loaded by auditor | `ai-resources/audits/questionnaire.md` | 146 | 1,580 | ~2,054 |

**Total command + agent surface:** 565 lines / 4,522 words / ~5,879 tokens (excludes questionnaire and CLAUDE.md, which are loaded by the auditor subagent context, not the main command body).

Subagent declared models (verified from frontmatter):
- `repo-dd-auditor` → **sonnet** (executes the full questionnaire across the audit root; potentially heavy reads).
- `dd-extract-agent` → **haiku** (mechanical restatement; correct tier).
- `dd-log-sweep-agent` → **haiku** (mechanical pattern extraction; correct tier).

`/repo-dd` command frontmatter: `model: opus`. Main session runs Opus throughout the workflow including Steps 4–6 (triage and apply fixes), Steps 8–11 (deep assessment synthesis), and Steps 12–13 (deep report drafting / pipeline tests).

---

## Step 4.2 — Token-flow map

### Question 1: What gets loaded at workflow start?

When `/repo-dd` is invoked from a session anchored in `ai-resources/`:

1. Workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`) — 219 lines / 3,202 words / ~4,163 tokens (loaded every turn already; not workflow-attributable but lives in main-session context for the duration).
2. ai-resources CLAUDE.md (`ai-resources/CLAUDE.md`) — 92 lines / 950 words / ~1,235 tokens (always loaded for sessions inside ai-resources).
3. `/repo-dd` command body — 314 lines / 2,680 words / ~3,484 tokens (loaded into main-session context at invocation).

**Estimated start-of-workflow context (workflow-attributable, excluding always-loaded CLAUDE.md):** ~3,484 tokens for the command body itself.

**Estimated total context inside the main session at the moment the command runs (CLAUDE.md + command):** ~3,484 + ~5,398 (CLAUDE.md stack) = ~8,882 tokens before any subagent call.

Subagent contexts (not in main session):
- `repo-dd-auditor` brief loads its own agent body (~991 tokens) plus questionnaire.md (~2,054 tokens) = ~3,045 tokens of its starting context, plus whatever main-session CLAUDE.md inheritance applies to subagents in this harness.
- `dd-extract-agent` loads ~624 tokens of agent body plus the full DD_REPORT (~7,000–9,000 tokens for a workspace audit; ~5,000–7,000 for scoped).
- `dd-log-sweep-agent` loads ~780 tokens of agent body plus discovered logs (variable, can be large).

### Question 2: How many subagent calls does the workflow design involve?

| Tier | Subagent calls | Identity |
|------|---------------:|----------|
| standard | 2 | `repo-dd-auditor` (Step 9), `dd-extract-agent` (Step 11) |
| deep | 3 | above + `dd-log-sweep-agent` (Step 34) |
| full | 3 | same as deep (no additional subagent for pipeline tests; main session runs them inline at Steps 62–66) |

Each subagent has its own context. Main-session-attributable token cost is the **return payload** plus any file the main session subsequently reads from disk.

### Question 3: Estimated output volume (subagent returns to main session)

| Subagent | Designed return shape | Source citation |
|----------|----------------------|-----------------|
| `repo-dd-auditor` | "Total findings count, breakdown by type (discrepancy, missing item, violation, clean check), the report file path." | `repo-dd-auditor.md` lines 63–69 |
| `dd-extract-agent` | "EXTRACT_PATH, total findings count, breakdown by inferred severity." | `dd-extract-agent.md` lines 57–61 |
| `dd-log-sweep-agent` | "SWEEP_PATH, counts: friction patterns, unresolved improvements, friction-without-improvement, improvement-without-verification." | `dd-log-sweep-agent.md` lines 99–102 |

All three subagents return a path + counts only. The **full audit report**, the **structured extract**, and the **log-sweep summary** are written to disk and not returned in the assistant message.

**Disk-output sizes (measured from the most recent samples in `ai-resources/audits/`):**
- DD_REPORT: 669 lines / 5,412 words (workflow-scoped 2026-04-27) up to 824 lines / 6,883 words (workspace 2026-04-12) → ~7,000–9,000 tokens.
- `audits/working/dd-extract.md` (current): 102 lines / 1,047 words → ~1,361 tokens.
- `audits/working/log-sweep.md` (current): 83 lines / 636 words → ~827 tokens.

**Main-session reads of subagent outputs (per command body):**
- Step 14: main session reads `EXTRACT_PATH` (the extract, not the full report). At ~1,361 tokens, this is well under the 200-line / "HIGH" threshold cited in the protocol.
- Step 33 (deep tier): main session reads `EXTRACT_PATH` again for deep-tier sections (1.2, 2, 3.4, 5.1, 5.2). Same file, same ~1,361 tokens.
- Step 48 (deep tier): main session reads `SWEEP_PATH` (~827 tokens). Under threshold.
- Step 67 (full tier, pipeline testing): main session reads `DEEP_REPORT_PATH` to update Section 4. The deep report is **drafted by the main session itself** in Step 56, so this is a re-read of newly-authored content, not a fresh load.

**Step 10 explicitly forbids re-reading DD_REPORT after the auditor returns** (`repo-dd.md` line 64: "Do not read the full report into main-session context — the dd-extract-agent (next step) will do that"). This is correctly enforced.

**Step 33 also explicitly forbids re-reading DD_REPORT** in the deep tier (`repo-dd.md` line 157: "Do not re-read DD_REPORT").

**Step 48 explicitly forbids re-reading raw logs** (`repo-dd.md` line 215: "Do not re-read the raw logs — the sweep agent already extracted the patterns").

The output-to-disk pattern is implemented across all three subagents and enforced in the command body. Per protocol Section 8 best practice #10, this is a **structural pass** — no HIGH "subagent returning >200 lines to main session" finding.

### Question 4: How many QC / refinement cycles does the workflow design for?

`/repo-dd` does not invoke QC subagents. It is itself a QC instrument (the audit *is* an independent fresh-context review of the repo). Triage (Step 4) is performed by the main agent on the structured extract, then operator-gated (Step 5). Refinement is replaced by an operator approval loop, not a multi-pass QC subagent loop.

**Refinement multiplier:** 1 main pass + 0 QC subagents per audit run. No refinement cycles in the protocol's sense.

The deep tier (Steps 8–11) is sequential synthesis by the main session over the structured extract and log sweep. No QC subagent on the deep report itself.

### Question 5: Where do files get read?

Operations with file-reading semantics in `/repo-dd`:

**Main session direct reads (from command body):**

| Step | File | Size | Necessary? | Delegable? | Notes |
|------|------|------|------------|------------|-------|
| 14 | `EXTRACT_PATH` (`audits/working/dd-extract.md`) | ~102 lines / ~1,361 tokens | Yes — triage requires the findings list inline | Already delegated (extract is the subagent's output) | Under 200-line threshold. PASS. |
| 23 | Each modified file (post-fix verify) | Varies | Yes — workspace CLAUDE.md "verify by reading the modified file" rule | Not delegable; verification must be in the writing context | Per-file. Typically <200 lines. |
| 33 | `EXTRACT_PATH` (deep tier re-read for §1.2, §2, §3.4, §5.1, §5.2) | Same file | Yes — deep assessment uses extracted sections | N/A — same extract reused | PASS. |
| 48 | `SWEEP_PATH` (`audits/working/log-sweep.md`) | ~83 lines / ~827 tokens | Yes — friction synthesis is main-session interpretation | Already delegated (sweep is the subagent's output) | Under threshold. PASS. |
| 62 (full) | Symlinks recorded in `EXTRACT_PATH §1.7` | Path metadata only | Yes | N/A | Pipeline test, not content read. |
| 63 (full) | Compare canonical vs. deployed copies | Each file pair | Yes — content diff required | Could be delegated to a subagent (potential refinement) | See finding F3 below. |
| 64–66 (full) | Existence + structure checks on template files, agent files, settings | File presence/structure only | Yes | Lightweight — no content reads required | PASS. |
| 67 (full) | `DEEP_REPORT_PATH` re-read | Just-written report (~6,000–8,000 tokens) | Yes — must edit Section 4 placeholder | Self-write context, not external read | PASS. |

**Subagent-delegated reads (NOT in main session):**

| Subagent | Reads |
|----------|-------|
| `repo-dd-auditor` | `audits/questionnaire.md` + walks AUDIT_ROOT (potentially hundreds of files: CLAUDE.md files, all skill/command/agent/hook files, settings, symlinks, deployed copies). This is the heavy-read step and is correctly delegated. |
| `dd-extract-agent` | `DD_REPORT` (single file, 669–824 lines / ~7–9k tokens) and writes a structured digest. |
| `dd-log-sweep-agent` | All `logs/*.md` files inside `AUDIT_ROOT` (logs/friction-log, improvement-log, session-notes, coaching-log, workflow-observations, decisions, innovation-registry — up to 7 files per repo, multi-repo at workspace scope). |

**Files >100 lines being read in the main session that are delegable:** None identified. The two main-session reads (`dd-extract.md` ~102 lines, `log-sweep.md` ~83 lines) are themselves the digest outputs of subagents and must be read by the main session to produce the triage list, deep findings, and friction synthesis. Re-delegating them would be circular.

### Question 6: Where do files get written?

Main-session writes:

| Step | File | Approx. size | Notes |
|------|------|--------------|-------|
| 22 | Each fix file (per AUTO-FIX or approved OPERATOR fix) | Varies | Writes-to-disk, not context. |
| 56 | `DEEP_REPORT_PATH` | ~600–900 lines / ~6,000–9,000 tokens (estimated by structure: Sections 1–4 + Summary, comparable to past `repo-dd-deep` artifacts) | Drafted by main session from extract + sweep. Cannot be delegated to a subagent without splitting the synthesis logic. |
| 67 (full) | `DEEP_REPORT_PATH` (re-write Section 4 placeholder) | Edits a single section | Edit, not full rewrite. |

Subagent writes (output-to-disk pattern):

| Subagent | Writes |
|----------|--------|
| `repo-dd-auditor` | `REPORT_PATH` (the full audit report, ~669–824 lines per recent samples). |
| `dd-extract-agent` | `EXTRACT_PATH` (~102 lines per current sample). |
| `dd-log-sweep-agent` | `SWEEP_PATH` (~83 lines per current sample). |

All large outputs are written to disk. No "large output written to context" pattern detected.

---

## Assessment per protocol checklist

### A1. Subagent return volume

**PASS.** All three subagents are designed to return a path + counts only. The output-to-disk pattern is correctly implemented and enforced by the command body (Steps 10, 33, 48 all explicitly forbid re-reading the full DD_REPORT or raw logs in the main session).

No HIGH severity finding for "subagent returning >200 lines to main session."

### A2. Unnecessary reads in main session

**PASS for standard and deep tiers.** No file >100 lines is read in the main session that could be delegated to a subagent. The two main-session reads of subagent digests (`dd-extract.md`, `log-sweep.md`) are themselves intentionally compact summaries (~102 and ~83 lines respectively, under the 200-line MEDIUM/HIGH threshold).

**Potential MEDIUM for full tier (Step 63 — Test 2: Template sync).** Step 63 (`/repo-dd full` only) instructs the main session to compare each file that exists as both a canonical version (in `ai-resources/skills/` or `ai-resources/workflows/`) and a deployed copy (in `projects/`), recording diff counts. At workspace scope, this can require reading dozens of file pairs in the main session. The protocol provides no delegation pattern for this. Severity tag: MEDIUM (boundary — depends on how many template/deployed file pairs exist; if the count is small, this is a non-issue).

### A3. Missing `/compact` opportunities

**MEDIUM.** No `/compact` instruction or guidance appears in `/repo-dd` at any breakpoint. Search results for "compact" in `repo-dd.md` returned zero hits.

Natural compaction breakpoints that exist but are not instrumented:
- After Step 7 (commit of the factual audit, end of standard tier) — if the operator continues into deep, the main session still holds the full triage state from Steps 4–6, the audit-report-existence-check from Step 10, and the dd-extract content read in Step 14. None of this is needed for Steps 8–11.
- After Step 12 (deep report saved, end of deep tier) — if the operator runs `full`, Steps 13–14 only need the deep report and the symlink/template lists; the friction synthesis state from Step 11 and the extract content from Step 33 are no longer needed.
- After Step 14 (deep report committed, end of full tier) — workflow ends; should hand off to `/clear` rather than dirty context. No such guidance in command body.

The command body acknowledges context pressure twice (Step 25 line 127 "If context usage is high, inform the operator"; Step 55 line 236 same language) but offers only a fall-back of "save and continue in a fresh session" — there is no proactive `/compact` or `/clear` instruction at deterministic breakpoints. The workspace CLAUDE.md `Pre-compact checkpoint` rule is present but not workflow-specific.

Severity: MEDIUM — multi-tier workflow with three sequential subagent calls, accumulated state across Steps 4–14, and explicit "context pressure may force a stop" language but no defined breakpoints.

### A4. Refinement multiplier

**N/A → PASS.** The workflow designs for 0 QC subagents and 0 refinement cycles. The audit *is* the QC. Triage is a single main-session pass over the extract, gated by operator approval.

This is appropriate for an audit instrument: the extract is the structured restatement of the auditor's findings, and the main session's role is to triage + apply, not to second-guess the auditor.

No HIGH severity finding for ">3 refinement cycles."

---

## Findings

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---------|----------|-----------------|----------|
| F1 | No `/compact` or `/clear` instruction at any of the three natural tier-boundary breakpoints (end of standard at Step 7; end of deep at Step 12; end of full at Step 14). Command body only reactively says "if context usage is high, inform operator" at Steps 25 and 55. | MEDIUM | Accumulated main-session state from triage (Steps 4–6), extract reads (Steps 14, 33), and deep-report drafting (Step 56) carries forward into subsequent tiers. At workspace scope with full tier, main session can hold ~25k+ tokens of accumulated workflow state by Step 14 with no defined release point. | `repo-dd.md` lines 127, 236 (reactive only); zero hits for "compact" / "/clear" / "breakpoint" in command body |
| F2 | `/repo-dd` runs Opus throughout (frontmatter line 2: `model: opus`), including mechanical Steps 22–24 (apply approved fixes + read-to-verify) and Steps 62–66 (pipeline tests: existence checks, symlink resolves, file-pair diffs). | MEDIUM | Per workspace CLAUDE.md Model Tier rule, mechanical work belongs on Sonnet/Haiku. Opus on apply-fix and pipeline-existence-checks is over-tiered. The workflow already correctly tiers its subagents (auditor=sonnet, extract=haiku, log-sweep=haiku) but the main-session model is uniform Opus for the entire ~14-step pipeline. | `repo-dd.md` line 2 (`model: opus`); workspace CLAUDE.md "Model Tier" section |
| F3 | Step 63 (`/repo-dd full` only — Test 2: Template sync) instructs the main session to compare each canonical-vs-deployed file pair and record diff counts. No subagent delegation pattern is provided. At workspace scope, multiple skills + workflow files may have deployed copies under `projects/`, which can require dozens of file-pair reads in the main session. | MEDIUM (boundary — actual count depends on deployed-project state; if low, finding drops to LOW) | Main-session file content reads where a subagent could perform the diff and return only the diverged-pair list. Per-file size is small (skills <300 lines), but cumulative cost across pairs can be significant. | `repo-dd.md` line 287 (Step 63) |
| F4 | Subagent return contracts are short and path-only: `repo-dd-auditor` returns count + breakdown + path; `dd-extract-agent` returns path + counts; `dd-log-sweep-agent` returns path + counts. No "subagent returning full output to main session" pattern. | PASS (positive observation) | — | `repo-dd-auditor.md` lines 63–69; `dd-extract-agent.md` lines 57–61; `dd-log-sweep-agent.md` lines 99–102 |
| F5 | Output-to-disk pattern is implemented and enforced. Steps 10, 33, 48 explicitly block content re-loading in the main session. | PASS (positive observation) | — | `repo-dd.md` lines 64, 157, 215 |
| F6 | Questionnaire (`audits/questionnaire.md`, 146 lines / ~2,054 tokens) is loaded only inside the `repo-dd-auditor` subagent context, never in the main session. | PASS (positive observation) | — | `repo-dd-auditor.md` line 31 reads `{AUDIT_DIR}/questionnaire.md`; `repo-dd.md` Step 9 passes `AUDIT_DIR` to the subagent and does not pre-load the questionnaire in the main session |
| F7 | Three subagent calls per deep/full run; agent files (auditor 75 lines, extract 67 lines, log-sweep 109 lines) are themselves compact and well-scoped. Subagent model tiers are correctly assigned (sonnet / haiku / haiku). | PASS (positive observation) | — | `wc -l` totals above; agent frontmatter |
| F8 | Workflow has no explicit `[COST]` reset or session-boundary instruction at tier transitions. Workspace CLAUDE.md Session Guardrails declares `/repo-dd` as **exempted from `[COST]`**, so the operator gets no automated cost signal during long workflow runs. | LOW | At workspace full tier, the three subagent calls + main-session synthesis can exceed the normal `[COST]` threshold (≥4 subagents, ~20 turns, ≥8 artifacts). The exemption is intentional but combined with F1 (no compaction breakpoints) means there is no built-in feedback loop on context pressure beyond the two reactive "inform the operator" lines. | Workspace CLAUDE.md Session Guardrails section ("Exempted commands … `/repo-dd`"); `repo-dd.md` lines 127, 236 |

---

## Severity tally

| Severity | Count | Findings |
|----------|------:|----------|
| HIGH | 0 | — |
| MEDIUM | 3 | F1, F2, F3 (F3 is boundary — depends on deployed-pair count) |
| LOW | 1 | F8 |
| PASS | 4 | F4, F5, F6, F7 |

---

## Token-flow summary (workflow-attributable, main session)

| Stage | Estimated main-session token cost |
|-------|----------------------------------:|
| Workflow load (command body) | ~3,484 |
| Step 14 read of `dd-extract.md` | ~1,361 |
| Step 33 (deep) re-read of `dd-extract.md` | 0 (already in context if no compact between Steps 14 and 33) or ~1,361 (if reloaded after a compact) |
| Step 48 (deep) read of `log-sweep.md` | ~827 |
| Step 56 (deep) draft of DEEP_REPORT (output) | ~6,000–9,000 written to disk; tokens generated, not loaded |
| Step 67 (full) re-read of DEEP_REPORT | ~6,000–9,000 (just-written, edited) |
| Subagent return payloads (3 × ~50 tokens) | ~150 |

**Standard tier main-session workflow-attributable load:** ~3,484 + ~1,361 + ~150 ≈ ~5,000 tokens (excludes triage/fix work which is operator-gated and varies).

**Deep tier additional load:** + ~827 ≈ +1,000 tokens.

**Full tier additional load:** + DEEP_REPORT re-read (~6,000–9,000) + Step 63 file-pair reads (variable). At workspace scope full tier this can push to ~12,000–18,000 main-session tokens of workflow-attributable load before triage/synthesis output generation.

---

## Protocol gaps

1. Section 4 protocol asks "estimated output volume" but does not distinguish between (a) tokens **returned in the assistant message** to main session vs. (b) tokens **written to a disk file the main session subsequently reads**. Both have main-session cost but the latter is opt-in (depends on whether the command body Reads the file). This audit treats both as findings worth recording but classifies (a) as the strict "subagent return volume" check from §A1.
2. Section 4 protocol does not specify how to score `/compact` opportunities in workflows where context-pressure handling is partially present (e.g., `/repo-dd` has reactive "inform operator if high" language but no proactive breakpoints). Marked as MEDIUM per "No compaction instructions or breakpoints defined" but the workflow is between "fully missing" and "fully implemented."
3. Step 63 file-pair diff is a borderline case for "large file reads in main session that could be delegated." Per-file size is small (skills typically <300 lines), but cumulative cost is real. Protocol's HIGH threshold ("Large file reads in main session that could be delegated") is binary; the cumulative case is not addressed. Recorded as MEDIUM (boundary).

## Threshold-boundary findings (per token-estimation caveat)

- **F3 (Step 63 template sync):** boundary — severity depends on the actual number of template/deployed file pairs at audit time. If <5 pairs, drops to LOW. If 10+ pairs of large files, escalates toward HIGH. Tagged `(boundary)`.
- The two main-session reads (`dd-extract.md` 102 lines, `log-sweep.md` 83 lines) sit ~50% below the 200-line MEDIUM threshold — well clear, not boundary.
- Command body at 314 lines is above any per-section threshold for skills/CLAUDE.md, but Section 4 of the protocol does not impose a line-count threshold on workflow command bodies themselves; this is noted only as context for F1/F2.

---

## Confidence

- F1, F2, F4, F5, F6, F7: **HIGH** — direct file evidence, line/word counts measured.
- F3: **MEDIUM** — depends on deployed-project state which was not enumerated.
- F8: **MEDIUM** — depends on operator behavior and session-length norms which aren't measured here.
