# Risk Check — 2026-05-28

## Change

add new command ai-resources/.claude/commands/resolve-incident.md — an 8-step incident resolver that classifies fault risk, invokes /risk-check via Skill tool on High-risk faults, invokes /consult Function B on High-risk resolution, applies a bounded fix, produces a 4-field verification receipt, writes a full record to audits/incidents/{DATE}-{SLUG}.md, appends a one-line entry to logs/incident-log.md, and conditionally appends to logs/improvement-log.md. Also adds docs/protected-zones.md (process doc listing protected repo paths), templates/incident-log-template.md (canonical fillable incident-record shape), logs/incident-log.md (new append-only operational log), and audits/incidents/ (new directory for per-incident full records). Adds a deprecation note to existing .claude/commands/resolve-repo-problem.md — no logic change, note only.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-incident.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/incident-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/protected-zones.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/incident-log-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Five additive artifacts (command, process doc, template, log, directory) plus a one-line deprecation note — no existing-consumer breakage detected, but the command introduces two implicit two-end contracts (incident-log schema and improvement-log Step 8c append shape) and a per-invocation cost that lights up High-tier subagents on High-risk paths; targeted mitigations close the gap.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Command is pay-as-used — invoked on demand by operator (`/resolve-incident`), not loaded into every session. No always-loaded CLAUDE.md content added; `resolve-incident.md` lives under `.claude/commands/` (frontmatter `model: opus` at line 3 binds tier per-invocation, not as a default).
- No hook registration. The change description names no SessionStart / PreToolUse / Stop hook; the command body confirms — no `.claude/hooks/*.sh` written or wired.
- No `@import` chain added to any always-loaded file. Workspace `CLAUDE.md` and `ai-resources/CLAUDE.md` are not edited by this change.
- Per-invocation cost can be substantial on High-risk paths — Step 2 invokes `/risk-check` (Opus) and Step 4.18 invokes `/consult` Function B (Opus) when `RISK ≥ High`. Both are conditional, not unconditional, so this is per-invocation amortization rather than per-session always-on cost.
- Templates and logs added (`templates/incident-log-template.md`, 73 lines; `logs/incident-log.md`, 32 lines) are read only at command invocation time (Step 5.19 and Step 8.29 respectively), not at session start.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edits described or required. Command uses Read, Write, Edit, Skill (for `/risk-check` and `/consult` invocations), and standard Bash for `git`, `mkdir -p`, `stat`. All already in the established repo allow-pattern.
- No new tool family. Skill-tool invocation of slash commands is the existing pattern used by `/friday-act`, `/resolve-repo-problem`, etc.
- No deny rule removed. No scope escalation (project → user) introduced.
- New write paths (`audits/incidents/{DATE}-{SLUG}.md`, `logs/incident-log.md`) fall under already-permitted `Write(audits/**)` / `Write(logs/**)` patterns used by `/friday-checkup`, `/resolve-repo-problem`, etc.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file additions: 5 (1 command + 1 doc + 1 template + 1 log + 1 directory) plus 1 one-line note edit to `resolve-repo-problem.md`. The note is non-behavioral — `resolve-repo-problem.md:6` adds an advisory pointer ("For mid-session faults where you want a fix applied in-session — not just a plan — use `/resolve-incident`"), no logic change.
- Caller / reference enumeration (grep across `ai-resources/`):
  - `resolve-incident` referenced: 1 file outside the change set — `templates/README.md:13` (already documents the consumer contract for `incident-log-template.md`).
  - `incident-log` referenced: 0 files outside `logs/incident-log.md` itself and the new command body.
  - `protected-zones` referenced: 0 files outside `docs/protected-zones.md` and the new command body.
  - `audits/incidents` referenced: 0 files outside the new command body.
  - `resolve-repo-problem` referenced: 4 existing references (this change adds 1 deprecation note pointing the other direction; no broken links).
- Contract dependencies introduced — these expand blast radius modestly because they create new two-end contracts even though no caller exists yet:
  - **Incident-log schema** (`logs/incident-log.md:15-26`) — the command's Step 8.29 must emit fields in this exact shape. Schema lives in the same file the command writes to; co-location reduces drift risk, but no consumer reads it yet so the contract is technically one-ended at landing.
  - **Improvement-log append shape on Step 8c** — `resolve-incident.md:192` cites `resolve-repo-problem.md:98–114` as the canonical schema. Two append sites now follow the same shape; if `resolve-repo-problem.md` schema block changes, both append sites must update in lockstep.
  - **`audit-discipline.md § Risk-check change classes`** — `resolve-incident.md:64` reads "lines ~17–26" of that file at Step 2.10. Verified against current file (lines 17–26 contain the class list). Approximate-line citation will drift if the file is reformatted.
- Shared infra touched: `logs/improvement-log.md` (conditional Step 8c append). The improvement-log already has 18 active entries and a documented schema; conditional append at the same shape as `/resolve-repo-problem` adds a second writer to the same file but with the same contract.

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert` cleanly removes all five additive artifacts: the command file, the doc, the template, the new log header file, and the deprecation-note edit. The empty `audits/incidents/` directory was not yet created on disk and only materializes when the command first runs (Step 1.7 `mkdir -p`).
- Reversibility complication 1 — **append-only log mutations from prior runs.** Once `/resolve-incident` has been invoked even once, `logs/incident-log.md` and (conditionally) `logs/improvement-log.md` carry appended entries. A `git revert` of the *introduction* commit does NOT undo entries appended by later runs — those are separate commits and would need to be unwound individually or curated by hand. This is the same reversibility profile `/resolve-repo-problem` already carries, so the marginal cost is bounded.
- Reversibility complication 2 — **per-incident records under `audits/incidents/`** are full standalone files. Each is a new file from a separate run; revert of the introduction commit does not remove them. Cleanup requires either `rm` of the directory or selective deletion, plus removing the matching index entries from `logs/incident-log.md`.
- No external writes (push, Notion, third-party API) triggered by the command itself. Step 9.33 explicitly states "No commit. The fix is applied but not committed." — commit is operator-discretionary, so state stays inside the working tree until the operator stages.
- Operator muscle memory: introducing a new command name (`/resolve-incident`) creates a small "trained workflow" cost — once the operator starts reaching for it, reverting the introduction commit silently removes the command and the next `/resolve-incident` invocation fails. The paired deprecation note in `/resolve-repo-problem` mitigates this by keeping the older command available as the fallback.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Implicit dependency 1 — `/consult` Function B selector.** `resolve-incident.md:113` says "Invoke `/consult` (Function B — pre-change advisory) via Skill tool." This assumes `/consult` exposes a Function-B mode that is named exactly that and that future `/consult` redesigns preserve the Function-B branch. The command body does not pin a `/consult` version or quote the function-selector signature, so this is a name-level contract that can silently break.
- **Implicit dependency 2 — `/consult` Step 0 read-first gate.** `resolve-incident.md:112` calls out the gate explicitly ("/consult Step 0 requires a prior Read before its read-first gate will pass") and instructs the command to satisfy it. Verified — `consult.md:20` contains the gate. This is named at the change site so coupling is documented, not silent.
- **Implicit dependency 3 — `/risk-check` invocation interface.** `resolve-incident.md:78` invokes `/risk-check $ISSUE` via Skill tool and parses the verdict ("GO" / "PROCEED-WITH-CAUTION" / "RECONSIDER"). The verdict tokens are an implicit string contract — if `/risk-check` ever changes its verdict shape, Step 2.12 silently misclassifies. Same coupling pattern flagged in improvement-log entry 2026-05-28 against `/pm` Step 5 / `qc-reviewer` — the operator has prior awareness of this contract class.
- **Implicit dependency 4 — `docs/audit-discipline.md` line range.** `resolve-incident.md:64` reads "lines ~17–26" — verified correct against current file, but approximate-range citations drift if the file is reformatted. Minor.
- **Implicit dependency 5 — `improvement-log.md` append schema referenced by line range.** `resolve-incident.md:192` cites "see `resolve-repo-problem.md:98–114` for the exact shape." Verified — that range contains the schema block. Same approximate-line-range drift concern as #4.
- **Functional overlap.** `/resolve-incident` and `/resolve-repo-problem` now both append `logged (pending)` entries to `logs/improvement-log.md` under the same schema. The change explicitly distinguishes them ("This command implements the fix" vs "triage only"). The deprecation note on `resolve-repo-problem.md:6` documents the split. This is documented overlap, not silent overlap, so the coupling is bounded.
- **`logs/.session-marker` (TOCTOU-race work) interaction — not touched.** Verified: `resolve-incident.md` does not read or write the session-marker file. The append-only nature of `logs/incident-log.md` is robust to concurrent-session writes (worst case: two entries appended out of order under the same `## Entries` block — recoverable by hand). No coupling to the in-flight per-session-marker design.

## Mitigations

- **Mitigation for D3 (Blast Radius):** Before landing, replace approximate-line citations with stable anchors. Change `resolve-incident.md:64` from "lines ~17–26" to a content anchor (e.g., "the `## Risk-check change classes` heading and the class list below it"). Change `resolve-incident.md:192` from "lines 98–114" to "the `### Improvement-log entry schema` block." This prevents silent drift when the cited files are reformatted.
- **Mitigation for D4 (Reversibility):** Add a one-line note to the new `logs/incident-log.md` header block stating the rollback procedure for incident entries — e.g., "To unwind a specific incident's records: remove the matching `audits/incidents/{DATE}-{SLUG}.md` file AND the one-line entry in this log AND (if present) the paired `improvement-log.md` entry." This makes the multi-file rollback explicit at the write site rather than implicit in the operator's memory.
- **Mitigation for D5 (Hidden Coupling):** Add a "Verbatim-shape contract" note inside `resolve-incident.md` Step 2.12 explicitly naming the three `/risk-check` verdict tokens (`GO`, `PROCEED-WITH-CAUTION`, `RECONSIDER`) and Step 4.18 explicitly naming the `/consult` Function-B selector signature. This mirrors the verbatim-shape-contract pattern already documented in `improvement-log.md` 2026-05-28 entry against `/pm` Step 5 — future audits will catch drift if either downstream command's tokens change. Optionally: add a defensive fallback ("if the verdict token is unrecognized, treat as RECONSIDER" — fail-safe direction).

## Evidence-Grounding Note

All risk levels grounded in direct evidence — file paths + line references to `resolve-incident.md` (lines 3, 6, 64, 78, 112, 113, 192), `audit-discipline.md` (lines 17–26), `consult.md` (line 20), `templates/README.md` (lines 13, 23), `protected-zones.md` (entire 44-line file), `incident-log.md` (lines 15–26 schema), and grep counts of references across `ai-resources/`. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concurs with PROCEED-WITH-CAUTION verdict.** Five-artifact additive shape is structurally sound; no existing-consumer breakage; three required mitigations are correct.

**Key additions beyond the dimension review:**

1. **Routing concern raised + resolved inline.** System Owner flagged possible deprecation-note path error (workspace-root vs ai-resources). Verified: workspace-root `.claude/commands/resolve-repo-problem.md` is a symlink → `../../ai-resources/.claude/commands/resolve-repo-problem.md`. Edit was applied to the canonical source. No routing defect.

2. **Fourth implicit contract missed by dimension review.** Mitigation #3 should expand to also pin the improvement-log append shape (not just `/risk-check` verdict tokens and `/consult` Function B selector). Write side: `/resolve-incident` Step 8c. Read side: `/friday-act`, `/resolve-improvement-log`. Matches the risk-topology §5 two-end-contract classification.

3. **Protected-zones.md scope: active, not speculative.** System Owner flagged AP-7 risk (speculative abstraction) for `protected-zones.md`. Confirmed: `/resolve-incident` Step 2 actively reads `docs/protected-zones.md` at v1. Not deferred.

4. **[PHASE-2-FILL] marker recommended for incident-log.md.** When W2.2 enforcement automation ships in Phase 2, `incident-log.md` will need a scope-or-skip decision (event-log, not principle-log). Add a marker now so the decision is visible at Phase 2 design time.

5. **Mitigation floor → GO path.** All four mitigations applied before commit bring this to a clean GO at end-time.
