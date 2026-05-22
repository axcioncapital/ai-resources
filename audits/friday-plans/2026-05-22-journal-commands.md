# Friday Act Plan — 2026-05-22 — journal-commands

**Source report:** friday-checkup-2026-05-22.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-22.md
**Generated:** 2026-05-22
**Items:** 5

All 5 items are journal-derived — authored by the operator in the AI journal, processed by /friday-journal into this report. They represent operator-directed improvements to the Claude Code infrastructure.

## Items

### 1. [high] Add between-gate executive summary rule to workspace CLAUDE.md for multi-phase complex work
- **Source:** journal-derived
- **Risk-check required:** yes — change class: always-loaded workspace CLAUDE.md
- **W2.4 auto-draft:** no
- **Recommended approach (from journal):** Add a new rule under `## Working Principles` in workspace CLAUDE.md. Rule text (draft): "When work involves two or more approved plan phases (e.g., `/new-project` pipeline, multi-wave `/friday-act`, any session with a phased plan file), generate a brief human-readable gate summary at each phase boundary before starting the next phase. The summary must cover: (1) what was done in this phase (2–4 bullets), (2) what the next phase will do (2–4 bullets), (3) any deviation from the session mandate detected. Output this summary in chat as a visible block — not buried in tool output." Rule should reference the `[AMBIGUOUS]` guardrail and the decision-point posture (Claude picks and proceeds; the summary is visibility, not a blocking approval).
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (workspace)

### 2. [high] Wire system-owner QC step into /new-project Stage 3b→3c gate to review architecture before spec-writing begins
- **Source:** journal-derived
- **Risk-check required:** yes — change class: canonical pipeline command edit
- **W2.4 auto-draft:** no
- **Recommended approach (from journal):** Locate the Stage 3b → Stage 3c transition in `/new-project`. After Stage 3b (architecture design) produces its output artifact and before Stage 3c (line-level implementation spec) is delegated, add a gate step that invokes `/implementation-triage` (Function D of the system-owner agent) with the Stage 3b architecture document path as input. If verdict is `NOT-WORTH-DOING` or `MARGINAL`, surface rationale and pause. If `WORTH-DOING`, proceed automatically.
- **Design note from journal:** This item interprets "technical spec qc" as gating the architecture (3b output) before spec-writing begins, not QC'ing the spec after it's written. If intent is to QC Stage 3c output instead, revise before executing.
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md`

### 3. [med] Update /risk-check to add system-owner second-opinion step on PROCEED-WITH-CAUTION and RECONSIDER verdicts
- **Source:** journal-derived
- **Risk-check required:** yes — change class: canonical command edit
- **W2.4 auto-draft:** no
- **Recommended approach (from journal):** After Step 4 (Structural Validation) and verdict is determined, add a new Step 4a: if VERDICT is `PROCEED-WITH-CAUTION` or `RECONSIDER`, invoke `/consult` (Function B of the system-owner agent — pre-change advisory) with the change description and the risk-check report's Dimensions section as context. Append the system-owner commentary as a new `## Architectural Commentary` section in the report file and chat output. Skip for GO verdicts.
- **Target files:**
  - `ai-resources/.claude/commands/risk-check.md`

### 4. [med] Create /drift-check command that compares current session trajectory against session mandate and approved plan
- **Source:** journal-derived
- **Risk-check required:** yes — change class: new command path
- **W2.4 auto-draft:** no
- **Recommended approach (from journal):** New command invokable mid-session. Reads: (1) session mandate from `logs/session-plan.md`, (2) today's entries in `logs/session-notes.md` and any in-progress plan file. Spawns a lightweight subagent (qc-reviewer pattern) that compares work done + planned against the original mandate. Returns: `ALIGNED` / `MINOR-DRIFT` / `MAJOR-DRIFT` plus bulleted deviations. Advisory only — no file modifications. Consider using `/consult` (Function A) internally to anchor judgment. Complements item 1's between-gate summary rule.
- **Target files:**
  - `ai-resources/.claude/commands/drift-check.md` (new)
  - Consider: `inbox/` brief via `/request-skill` pipeline if complexity warrants a full skill

### 5. [med] Create /resolve-repo-problem command that spawns a subagent to investigate a repo error and produce a fix plan
- **Source:** journal-derived
- **Risk-check required:** yes — change class: new command path
- **W2.4 auto-draft:** no
- **Recommended approach (from journal):** New command invoked when Claude or operator encounters an unexpected repo error, broken state, or structural inconsistency. Operator passes a brief problem description. Command spawns an investigator subagent (Read, Glob, Grep) that: (1) locates relevant files, (2) reads CLAUDE.md and recent decisions.md for context, (3) produces a short root-cause diagnosis, (4) writes a 3-option fix plan (quick patch / structural fix / defer) ranked by risk and effort. Returns summary to main session; full notes written to `audits/working/`. Advisory/triage only — does NOT apply any fix.
- **Target files:**
  - `ai-resources/.claude/commands/resolve-repo-problem.md` (new)

## Execution notes
- Execute in order: item 1 (CLAUDE.md rule) → item 2 (new-project gate) → item 3 (risk-check update) → items 4+5 (new commands). Items 4 and 5 may be parallelized.
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item. All 5 items require a /risk-check gate.
- Commit each fix separately (workspace commit-behavior rules).
- Run `/wrap-session` when all items in this plan are done.
