# Section 4 — Workflow Token Efficiency Audit: /cleanup-worktree

**Audit date:** 2026-05-02
**Audit root:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
**Workflow scope:** /cleanup-worktree command + worktree-cleanup-investigator skill (+ 2 references) + qc-reviewer + triage-reviewer agents
**Token estimation method:** word count × 1.3 (per protocol header). See header caveat: ±30% drift vs. actual tokenizer. Findings within ±15% of a threshold boundary tagged `(boundary)`.
**Re-evaluation note:** Prior 2026-04-18 audit run flagged main-session SKILL.md load as HIGH. Operator brief asks: re-evaluate whether design rationale (mandatory plan mode, named confirmation phrases, operator-visible execution) actually requires main-session loading or could be split.

---

## Workflow: /cleanup-worktree

### Context loading chain (workflow start → plan complete)

The command file (`ai-resources/.claude/commands/cleanup-worktree.md`) Step 3.6 is explicit: **"Read `ai-resources/skills/worktree-cleanup-investigator/SKILL.md` in full"** in the main session. Step 3.7 leaves the two reference files (`decision-taxonomy.md`, `execution-protocol.md`) to on-demand reads at later trigger points.

| # | Load event | Trigger | File path | Lines | Words | Est. tokens (w × 1.3) |
|---|------------|---------|-----------|-------|-------|----------------------|
| 1 | Workspace CLAUDE.md (always loaded every session) | Session start | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md | 219 | 3202 | ~4,163 |
| 2 | ai-resources CLAUDE.md (always when ai-resources mounted via --add-dir) | Session start | ai-resources/CLAUDE.md | 92 | 950 | ~1,235 |
| 3 | Command file invoked (full body loaded into main session at /cleanup-worktree) | Step 0 | ai-resources/.claude/commands/cleanup-worktree.md | 165 | 2814 | ~3,658 |
| 4 | Step 3.6 — read SKILL.md in full (main session) | Step 3 | ai-resources/skills/worktree-cleanup-investigator/SKILL.md | 247 | 3618 | ~4,703 |
| 5 | Step 3.7 — execution-protocol.md § 1 + Plan-file schema (Step 5 trigger) | Step 5 | ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md | 337 | 4548 | ~5,912 (full file if read in full; on-demand sections are smaller) |
| 6 | Step 4 — decision-taxonomy.md (loaded at first per-path classification) | Step 4 | ai-resources/skills/worktree-cleanup-investigator/references/decision-taxonomy.md | 230 | 2027 | ~2,635 |

**Subtotal — files mandatorily loaded into main session BEFORE first subagent spawn:**
- Items #1–#4 always: ~13,759 tokens / 723 lines / 10,584 words.
- Item #5 (execution-protocol.md): designed for on-demand section reads, but practically the whole file is consulted across Steps 5/6/7/9/11. Realistic main-session cumulative load ≈ 70–100% of full body ≈ 4,100–5,900 tokens.
- Item #6 (decision-taxonomy.md): loaded once at first path classification. Full body ≈ 2,635 tokens.

**Total mandatory pre-plan main-session context (when all on-demand reads have fired by mid-workflow):** ~20,500–22,300 tokens across 6 files / 1,290 lines / 17,159 words.

**Per-dirty-path additional load (Step 4.10):**
- `Read` every dirty path file (cannot be skipped — bias counter 1: "never fabricate file details" requires actual file open). For deletions, `git show HEAD:<path>` recovers content.
- For 10–14 dirty paths × average ~40 lines each ≈ 400–560 lines ≈ 4,000–7,500 tokens of file-content reads into main session.
- `find-template.sh` output for `.claude/*` paths: short (1 line per call), negligible.

**Total estimated start-of-workflow main-session context (before first subagent):** ~24,500–30,000 tokens for a 10–14 dirty-path session.

**Plus plan-file content** (Section 5.12 — eight-section schema, drafted via Edit/Write to plan file):
- Plan file size at write time: 8 sections × N rows in classification table + hard-gate blocks + commit split. For a 10–14 dirty-path session, plan file ≈ 200–400 lines ≈ 2,000–4,000 tokens. The plan persists in main-session context as the agent edits it across Steps 5–9.

**Running main-session total at end of plan write (Step 5):** ~26,500–34,000 tokens. This is comfortably below the 200k context window but represents the dominant fixed cost of the workflow.

### Subagent invocations (per workflow run)

Per command file Steps 6, 7, 9 (and reinforced by SKILL.md "Workflow" steps 4/5/7 and execution-protocol.md sections 3/4/6):

| # | Subagent | Mandatory? | Step | Inputs (per current command spec) | Return contract |
|---|----------|-----------|------|------------------------------------|-----------------|
| 1 | qc-reviewer (or qc-gate alias) — first QC | Yes (always) | 6.14 | `PLAN_PATH` (path, not content) + operator request quoted inline + git-status snapshot quoted inline + evaluation criteria | Writes full QC report to `<PLAN_PATH>.qc-pass-1.md`. Returns ≤20-line structured summary + absolute path. (Step 6.17) |
| 2 | triage-reviewer — triage | Yes (always) | 7.18 | `QC_REPORT_PATH` + `PLAN_PATH` (paths, not content) + main agent's proposed responses inline | Writes full triage report to `<PLAN_PATH>.triage.md`. Returns ≤20-line summary categorizing must-fix/should-fix/history-only + first-class alternatives. (Step 7.21) |
| 3 | qc-reviewer — second QC | Conditional — required UNLESS quick-tier skip applies (Step 9.25): zero hard gates AND zero new file-content claims in revision | 9.26 | `PLAN_PATH` + `FIRST_QC_REPORT_PATH` + operator request + git-status snapshot quoted inline | Writes full 2nd QC report to `<PLAN_PATH>.qc-pass-2.md`. Returns ≤20-line summary + path. (Step 9.26) |

**Quick-tier skip (Step 9.25):** Permitted when (a) Section-4 hard-gate count = 0 AND (b) revision Section-8 annotations show zero new file-content claims. Saves one subagent pass for low-risk plans (e.g., commit-only plans). Logged in plan Section 8 + operator-visible verbatim notification before ExitPlanMode.

**Failure-loop ceiling:** Step 9.27 — max 2 full revision cycles. On cycle 3, STOP and surface to operator. Implies maximum subagent fleet per session = 1st QC + triage + 2nd QC + (revise) + 2nd QC + (revise) + 2nd QC = up to 5 mandatory + 2 optional triage re-runs. Practical worst case ≈ 5 subagent passes; nominal case = 3 (or 2 with quick-tier skip).

### Subagent input/output volumes — STRUCTURAL CHANGE FROM PRIOR AUDIT

**This is the most important update vs. the 2026-04-18 audit notes.** The prior audit flagged HIGH severity for two patterns:
- Plan content pasted **verbatim** into each subagent brief (3× duplication)
- Subagent reports returned **verbatim** to main session ("Do not summarize it")

**Current state (2026-05-02):** Both patterns have been structurally resolved.

**Plan content passing — RESOLVED.** Step 6.15 now reads: *"`PLAN_PATH` — absolute path to the plan file written in Step 5. The subagent reads the plan at invocation time. Do NOT paste the plan content into the subagent brief. Path-passing satisfies the workspace `CLAUDE.md → Input File Handling` rule and preserves context isolation."* The same path-passing contract applies in Step 7.19 (triage receives `QC_REPORT_PATH` + `PLAN_PATH`, both as paths) and Step 9.26 (2nd QC receives `PLAN_PATH` + `FIRST_QC_REPORT_PATH`). Each subagent loads the plan into its OWN context (not the main session's), and main-session brief size for each subagent is small (operator request + git-status snapshot + criteria, no plan body).

**Subagent return contract — RESOLVED.** Step 6.17, Step 7.21, Step 9.26 all now mandate: write full report to disk + return ≤20-line summary + path. Same contract as `repo-dd-auditor` and `token-audit-auditor`. Main session reads full report only if a summary item requires deeper context (Step 6.17 explicit).

**Estimated current subagent-return cost into main session:** 3 subagents × ~20-line summary ≈ 3 × ~250 tokens ≈ ~750 tokens total. Plus 3 paths captured. This is dramatically lower than the prior audit's "3,000–6,000 tokens of full-report return" estimate.

### Subagent-side context cost (NOT returned to main, but real spend)

Each QC and triage subagent runs in its own ~200k context window. Per qc-reviewer.md Output Format and Context Gathering rules:

- Each subagent loads its own agent-spec definition: qc-reviewer.md (138 lines / 1188 words ≈ ~1,545 tokens) or triage-reviewer.md (88 lines / 707 words ≈ ~919 tokens).
- Each subagent reads the plan file (Path-passed): for a 10–14 dirty-path plan ≈ 200–400 lines ≈ 2,000–4,000 tokens.
- qc-reviewer additionally reads CLAUDE.md and any referenced files for verification (per "Context Gathering" block: "Read CLAUDE.md files to check convention compliance, Read referenced files to verify paths and imports exist"). Realistic: 5,000–10,000 tokens of verification reads.
- Triage subagent reads QC report (~30–100 lines ≈ 500–1,500 tokens) + plan file (~2,000–4,000 tokens) + operator's proposed responses inline.

**Per-subagent context spend (estimate):** 8,000–16,000 tokens for QC; 4,000–7,000 tokens for triage.

**3 mandatory passes × per-subagent spend:** ~20,000–40,000 tokens of subagent-side context (does NOT enter main session, but is real billable consumption).

**Operator 2026-04-17 telemetry (from prior context pack):** "three subagent passes at ~220k tokens combined" ≈ ~73k tokens per subagent. That figure is much higher than the structural minimum here, suggesting either (a) the prior session involved a larger plan than the 10–14 path baseline, or (b) verification reads in qc-reviewer were broader than the structural minimum, or (c) the prior session predated some of the path-passing optimizations now in effect. This 2026-05-02 audit cannot reproduce or refute the figure without fresh telemetry.

### File reads during execution (post-ExitPlanMode, Steps 11–12)

Per command Step 11.30 and SKILL.md Validation Loop:

| Read event | Where | Necessary / Delegable | Rationale |
|------------|-------|------------------------|-----------|
| Step 11.30a — execution-time re-verification guards (`diff`, `ls -la`, `git ls-files --error-unmatch`, re-read migration destination) immediately before each destructive op | Main session | Necessary | Guards must fire on the exact tip of the working tree at the moment of execution; cannot be delegated to a subagent (race condition, isolation breaks the guard's purpose) |
| Step 11.30b — hard-gate display: read content being destroyed, present to operator for named-phrase confirmation | Main session | Necessary | Operator-visible display IS the load-bearing safety property; cannot be delegated |
| Step 11.31 — post-commit verification: read each committed file from filesystem, `readlink` symlinks, confirm deletions, re-read .gitignore | Main session | Necessary but cheap | Per project CLAUDE.md "verify via filesystem not git" rule. Reads are scoped to just-committed paths. ≤200–400 tokens per commit × 3–5 commits ≈ 1,000–2,000 tokens total. |

### Files written

Per command + skill spec:

| File written | Where | When | Size estimate |
|--------------|-------|------|---------------|
| Plan file: `~/.claude/plans/cleanup-worktree-<YYYY-MM-DD-HHMM>.md` | Disk (not repo) | Step 5.12 | 200–400 lines |
| `<PLAN_PATH>.qc-pass-1.md` (first QC report) | Disk | Step 6 (subagent writes) | 30–100 lines |
| `<PLAN_PATH>.triage.md` (triage report) | Disk | Step 7 (subagent writes) | 20–60 lines |
| `<PLAN_PATH>.qc-pass-2.md` (2nd QC report, if not skipped) | Disk | Step 9 (subagent writes) | 30–100 lines |
| 3–5 git commits | Repo working tree | Step 11.30c-e | Plan-defined |
| Pre-compact scratchpads (conditional) | Working dir | Step 4 / Step 7 breakpoints | 20–80 lines each |

All non-commit outputs go to disk. None of the QC/triage reports re-enter main-session context wholesale — only via the ≤20-line summaries. This satisfies the "output-to-disk pattern for subagents" best practice (protocol Section 8 item 10).

### Compact breakpoints

Two breakpoints are explicitly defined:

1. **Step 4.48 — pre-plan compact breakpoint.** "If context usage is above ~50%, write a short scratchpad naming: every dirty path with its assigned decision, all `find-template.sh` verdicts, any canonical-destination candidates already identified, and the path to this command's arguments. Then prefer `/clear` + restart over `/compact`."
2. **Step 7.85 — post-triage compact breakpoint.** "If context usage is above ~50%, write a scratchpad naming: every must-fix finding with its resolution sketch, every should-fix finding the operator has confirmed, any first-class alternatives adopted, and the paths to the plan, the first QC report, and the triage report."

These are conditional (fire only if context >50%). Both follow workspace CLAUDE.md "pre-compact checkpoint" pattern. **Status:** present and well-specified.

### Refinement multiplier

Per Step 9.27: maximum 2 full revision cycles after the first 2nd-QC verdict. Beyond that, surface as structural failure. Nominal case = 0 revisions after 2nd QC (clean), or 1 revision (MINOR). Worst permitted case = 2 revisions ⇒ 3 × 2nd-QC passes total.

Total subagent count (nominal): 3 (1st QC + triage + 2nd QC).
Total subagent count (max permitted): 5 (1st QC + triage + 2nd QC + revise + 2nd QC + revise + 2nd QC).
Total subagent count (with quick-tier skip): 2 (1st QC + triage), no 2nd QC.

This is **at** the protocol Section 4 "Refinement multiplier" MEDIUM threshold (>3 cycles). Nominal is fine; max is 5; quick-tier is 2.

---

## Findings

| # | Finding | Severity | Lines / files affected | Waste mechanism | Evidence |
|---|---------|----------|------------------------|-----------------|----------|
| 1 | Main-session SKILL.md load: 247 lines / ~4,703 tokens loaded into main session at Step 3.6 by command-level mandate ("Read SKILL.md in full"). The skill content (When to Use, When NOT to Use, Invocation Contract, Workflow overview, Bias Counters, Known Pitfalls, Failure Behavior, Runtime Recommendations, Validation Loop, Example, Cross-References) is consulted procedurally during Steps 4–11 of the workflow. Re-evaluation: of the 247 lines, ~80–110 lines (Bias Counters, Invocation Contract, Failure Behavior) are load-bearing for main-session decisions during plan mode (named confirmation phrases, refusal of operator skip-QC requests, mandatory plan-mode entry) and DO need to be in main session at the moment of operator interaction. The remaining ~130–160 lines (Workflow overview duplicating command Steps 1–12, Example, Validation Loop, When to Use / When NOT to Use trigger phrases, Cross-References) are reference/onboarding material that the command file already restates or supersedes. The Workflow overview block (lines 60–84) re-states command Steps 1–12 in different numbering (workflow-ordinal vs command-Steps); double-loaded. The "When to Use" / "When NOT to Use" tables (lines 21–44) are decision artifacts for skill-discovery, not for runtime — by the time `/cleanup-worktree` is invoked, the operator has already chosen to use it. **Re-evaluation verdict on operator's question:** Yes, the SKILL.md load could be split. Approximately 130–160 lines (~2,500–3,000 tokens) are runtime-redundant and could move to a SKILL-internal reference loaded only if needed (e.g., a Cross-References / Onboarding section that reads on demand) or be deleted from SKILL.md as overlap with the command file. The ~80–110 load-bearing lines (named-phrase enforcement, plan-mode mandate, bias counters, failure-behavior table) genuinely need main-session presence. | HIGH | ai-resources/skills/worktree-cleanup-investigator/SKILL.md (247 lines / 3,618 words / ~4,703 tokens) | Always-loaded via command Step 3.6. ~50–60% of load is procedurally redundant with command file or is skill-discovery (not runtime) content. | Command file Step 3.6 mandates "Read … in full"; SKILL.md sections 21–44 ("When to Use" / "When NOT to Use") and 60–84 ("Workflow") and 220–248 ("Example", "Cross-References") overlap with command file body. |
| 2 | Reference files double-loaded (sections cumulative, not on-demand in practice). Step 3.7 of the command file says references load "on demand" at specific trigger points, BUT the trigger points span Steps 5/6/7/9/11 — i.e., across the entire plan-mode arc. By Step 9, both reference files are realistically fully resident in main-session context. execution-protocol.md = 337 lines / ~5,912 tokens (boundary: at 337 lines, sits within ±15% of the 300-line MEDIUM→HIGH threshold for a single file — flag as `(boundary)` per protocol §4 token-estimation caveat). decision-taxonomy.md = 230 lines / ~2,635 tokens. Combined ~8,547 tokens across both reference files. Once both have been section-grepped multiple times, the practical net cost approaches reading them in full. The "on-demand" optimization is real for SHORT sessions (1–3 dirty paths, no migrate-then-delete, no symlink conversion) but degrades for the typical 10–14 path session. | HIGH (boundary on execution-protocol.md size) | ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md (337 lines / 4,548 words); ai-resources/skills/worktree-cleanup-investigator/references/decision-taxonomy.md (230 lines / 2,027 words) | Cumulative load across multi-step reads ≈ full file. On-demand loading instruction may not be honored in practice. | execution-protocol.md trigger points span Steps 5/6/7/9/11 (command file Step 3.7); decision-taxonomy.md is loaded "Immediately before beginning per-path classification" (SKILL.md Reference Files row). |
| 3 | Subagent input contract — RESOLVED in current state vs. prior audit. Path-passing now used consistently (Step 6.15: "Do NOT paste the plan content into the subagent brief"; Step 7.19; Step 9.26). Plan-file body is loaded into each subagent's OWN context, not duplicated × 3 in main session brief. **No current finding** — protocol §4 #1 ("Subagent return volume") is satisfied for the input direction. | RESOLVED (no finding) | n/a | n/a | Step 6.15, Step 7.19, Step 9.26 explicit path-passing language. |
| 4 | Subagent return contract — RESOLVED in current state vs. prior audit. All three subagents now write full reports to disk and return ≤20-line summaries (Step 6.17, Step 7.21, Step 9.26). Mirrors `repo-dd-auditor` / `token-audit-auditor` pattern. **No current finding** — protocol §4 #1 ("Subagent return volume") is satisfied for the return direction. | RESOLVED (no finding) | n/a | n/a | Step 6.17 ("writes its full QC report to `<PLAN_PATH>.qc-pass-1.md`, and returns a ≤20-line structured summary"); Step 7.21 same pattern for triage; Step 9.26 same pattern for 2nd QC. |
| 5 | execution-protocol.md size at 337 lines is over the 300-line threshold for HIGH severity in protocol §2 (skill census thresholds; reference files inherit the same load profile as skills). However the operator has spread it across 13 sections with a ToC and grep-able section headers, and command file Step 3.7 explicitly instructs section-level reads. **Boundary call** at 337 vs 300 (12% over threshold, within the ±15% boundary band). | HIGH (boundary) | ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md (337 lines / 4,548 words / ~5,912 tokens) | Per-load token cost. Mitigated structurally by ToC + on-demand section reads. | wc -l on file. Prior 2026-04-18 audit had this at 310 lines; growth of ~27 lines (8.7%) since then. |
| 6 | SKILL.md section "Workflow" (lines 60–84) re-states the command file's Steps 1–12 in different numbering (workflow-ordinal). Operator already loads BOTH files in main session per Step 3. Either copy is sufficient for the agent to follow the sequence. The skill's Workflow block is structured as `1–11` with cross-mapping to command Steps; command file is structured as `Step 1–Step 12` with internal numbering. The two-axis numbering scheme (workflow ordinals 1–11 + command Steps 1–12) is mentioned in SKILL.md line 62 ("the corresponding `references/execution-protocol.md` sections are cited in the text where a 1:1 mapping exists. The `/cleanup-worktree` command re-numbers these as Steps 1–11"). The dual numbering itself is small but the workflow block duplicates the command's runtime sequence. | MEDIUM | SKILL.md lines 60–84 (~25 lines / ~250 words / ~325 tokens of duplication) | Duplicate content double-loaded into main session. | SKILL.md "Workflow" block lines 60–84 vs command file Steps 1–12. |
| 7 | SKILL.md "When to Use" / "When NOT to Use" / "Cross-References" sections (lines 21–44 + 242–248, ~30 lines / ~350 words / ~455 tokens) are skill-discovery content — useful for the model deciding whether to invoke the skill, NOT for runtime guidance once invocation has happened via `/cleanup-worktree`. By the time the command runs, the trigger phrases ("clean up the working tree", etc.) are no longer relevant; the operator has already chosen to invoke. These could be in the YAML `description:` field (which is what the model sees during skill matching) rather than in the body that loads at Step 3.6. | MEDIUM | SKILL.md lines 21–44, 242–248 (~30 lines / ~455 tokens) | Always-loaded skill-discovery content costs main-session tokens after the discovery decision is already made. | `disable-model-invocation: true` in frontmatter (line 14) explicitly turns off model-driven invocation, making the trigger-phrase list in body even less load-bearing. |
| 8 | SKILL.md "Example" section (lines 220–240, ~21 lines / ~520 words / ~675 tokens) is a worked example of a 14-path cleanup session. Few-shot examples are useful (protocol §8 item 15) but this one is loaded EVERY invocation regardless of need. The example overlaps significantly with the workflow it documents — once an experienced operator (or model that has run the workflow before) is invoking, the example adds little. | LOW | SKILL.md lines 220–240 (~675 tokens) | Always-loaded example doubles as workflow restatement. Real cost is small per session but adds up across many invocations. | Lines 220–240 narrate steps 1–16 of an example session that mirror command Steps 1–12 + post-commit verification. |
| 9 | Compact breakpoints: present and conditional (~50% threshold). Two breakpoints (Step 4.48 pre-plan, Step 7.85 post-triage). Aligns with workspace CLAUDE.md "pre-compact checkpoint" pattern. **No finding** — present and well-specified. | RESOLVED (no finding) | n/a | n/a | Command file lines 48 and 85 explicit. |
| 10 | Refinement multiplier: nominal 3 subagents (1st QC + triage + 2nd QC); max permitted 5 with revision loops; quick-tier skip drops to 2. Below MEDIUM threshold (>3 cycles consistent need) for nominal case. | LOW | n/a | Worst-case refinement at upper bound of MEDIUM threshold; nominal is fine. | Step 9.27 "max 2 full revision cycles" caps loop depth. |
| 11 | Workspace + ai-resources CLAUDE.md combined: 311 lines / 4,152 words / ~5,398 tokens loaded EVERY session, including every cleanup-worktree session. This is a workspace-wide cost (not workflow-specific) but represents ~20% of the cleanup-worktree main-session pre-plan context. Out of section §4 scope per protocol (CLAUDE.md is §1's job), so noted but not classified here. | OUT OF SCOPE for §4 | n/a | Cross-cutting cost; defer to §1. | n/a |

### Findings summary by severity (Section 4 scope only)

- **HIGH:** 2 (#1 SKILL.md main-session load; #2 reference files cumulative load — boundary on execution-protocol.md size)
- **HIGH (boundary):** 1 (#5 execution-protocol.md at 337 lines, 12% over 300-line threshold; flagged per token-estimation caveat)
- **MEDIUM:** 2 (#6 Workflow block duplication; #7 skill-discovery content always-loaded)
- **LOW:** 2 (#8 always-loaded example; #10 refinement multiplier near upper bound)
- **RESOLVED (no finding):** 3 (#3 subagent input verbatim — fixed; #4 subagent return verbatim — fixed; #9 compact breakpoints — present)
- **OUT OF SCOPE:** 1 (#11 CLAUDE.md cost, defer to §1)

**Total Section-4 findings (HIGH/MEDIUM/LOW only):** 6 (2 HIGH + 1 HIGH-boundary + 2 MEDIUM + 2 LOW = 7 if counting boundary separately; the protocol counts boundary as HIGH but flags confidence). Total open findings: 6.

---

## Re-evaluation — Operator's specific question

**Operator brief:** "Verify and re-evaluate whether the design rationale (mandatory plan mode, named confirmation phrases, operator-visible execution) actually requires main-session loading or whether it could be split."

**Verdict:** Partially. The skill's main-session load is **partly** load-bearing and **partly** redundant.

**Load-bearing portions (must remain in main session at Step 3.6):**

| SKILL.md lines | Content | Why main-session-resident is required |
|----------------|---------|----------------------------------------|
| 46–58 | Invocation Contract (MUST enter plan mode; MUST produce written plan; MUST run independent QC; MUST gate every irreversible op; MUST NOT push) | These are runtime gating rules the main agent enforces against itself during the workflow. The command file restates them at Step-level but the SKILL "MUST" framing is the load-bearing constraint cited by the failure-escalation table when refusing operator skip-QC requests. |
| 116–152 | Bias Counters (Never fabricate file details; Check ALL ai-resources subdirectories; Second QC required; Hard gates require named confirmation phrases) | Runtime checklist applied at Steps 4 (counter 1, 2), 8 (counter 1 on revision), 9 (counter 3), 11 (counter 4). Bias counter 4 specifically — "Hard gates require named confirmation phrases" — is enforced at the moment of operator interaction; the rule needs to be in main-session context when displaying gates. |
| 176–186 | Failure Behavior table (especially "Operator says 'skip QC, just run it' → Do not comply") | Runtime refusal logic. When operator pressures for skip, the agent reads from this table to formulate the refusal. Cannot delegate to subagent (operator interaction is main-session). |

Estimated load-bearing total: ~50–60 lines / ~600–800 words / ~780–1,040 tokens.

**Non-load-bearing portions (could be split, deferred, or moved):**

| SKILL.md lines | Content | Where it could go |
|----------------|---------|-------------------|
| 21–44 | "When to Use" / "When NOT to Use" trigger-phrase tables | YAML `description:` field already does the matching; body content is informational only. With `disable-model-invocation: true`, the trigger phrases in body are doubly redundant. |
| 60–84 | Workflow overview (steps 1–11 with cross-mapping to command Steps) | Pure restatement of command file body. Delete or condense to a one-line "See `/cleanup-worktree` Steps 1–12 in the command file." |
| 87–94 | Reference Files table | Useful but small (~7 lines). Could stay or move to command file Step 3 (which already has the same trigger-point info inline). |
| 96–114 | Bundled Scripts (find-template.sh) — the EXECUTE-not-read directive is load-bearing, but the usage example and exit-code table could be in `scripts/find-template.sh`'s own header. | Move usage example to script header. Keep the EXECUTE directive in SKILL. |
| 154–174 | Known Pitfalls (4 traps: script-vs-text, obvious-deletion, revision-introduces-bugs, working-tree-drift, ambitious-commit-split) | Useful runtime reminders BUT all five are restated as bias counters or in execution-protocol.md guards. Could be condensed or referenced rather than restated. |
| 188–202 | Runtime Recommendations + Invocation Control Configuration | Configuration metadata, not runtime. Could move to a `meta:` block in frontmatter or to a separate `META.md`. |
| 204–218 | Validation Loop checklist | Useful, but the checks fire at Step 12 (post-execution) — could load on-demand at that step. |
| 220–240 | Example | Few-shot example value is real but not every-session value. Could move to a `references/example.md` loaded on demand, or be removed entirely. |
| 242–248 | Cross-References | Discoverability, not runtime. Move to frontmatter or delete. |

Estimated non-load-bearing total: ~130–160 lines / ~1,800–2,400 words / ~2,340–3,120 tokens. **This is the main quantum of available savings.**

**Net estimated savings if SKILL.md is split:** Reduce main-session load from 247 lines / ~4,703 tokens to ~80–110 lines / ~1,500–2,000 tokens. Savings ≈ ~2,500–3,000 tokens per cleanup-worktree invocation.

**Risk of splitting:**
- The on-demand-load pattern is already used for the two reference files. Adding a third on-demand layer (a SKILL.md split) increases complexity without changing the architecture pattern.
- Bias Counters (lines 116–152) MUST stay main-session — they fire across multiple steps. If a split moves them to on-demand, the agent may not retrieve them at the right time.
- The Failure Behavior table is most likely to fire when the operator is under time pressure. Reading from on-demand reference under time pressure is exactly when an agent skips reads. Keeping it main-session resident is a safety property.

**Operator's design-rationale assertion is partially correct:**
- "mandatory plan mode" → enforced by command file Step 2.4–2.5 + SKILL.md lines 50–52 (Invocation Contract). Main-session-resident is correct.
- "named confirmation phrases" → enforced by bias counter 4 (SKILL.md lines 146–152) + command file Step 11.30b. Main-session-resident is correct.
- "operator-visible execution" → enforced by command file Step 11.30b (display content being destroyed) + SKILL.md Failure Behavior. Main-session-resident is correct.

The design rationale justifies main-session loading of the **load-bearing 80–110 lines**. It does NOT justify main-session loading of the **non-load-bearing 130–160 lines** (Workflow overview duplicate, skill-discovery, example, cross-references, runtime recommendations, validation loop). Those are candidates for split.

---

## Protocol gaps

- Section 4 of the protocol does not specify how to attribute always-loaded CLAUDE.md cost to specific workflows. CLAUDE.md cost is workspace-wide; counting it as a workflow finding double-counts across workflows. Treated as out-of-scope for Section 4 (Finding #11).
- Protocol Section 4 #1 ("Subagent return volume >200 lines = HIGH") is binary — does not clearly handle the case where the contract has been changed since prior audit (verbatim-return → ≤20-line summary). Treated as RESOLVED status (Finding #3, #4) with explicit narrative about the change.
- Protocol does not specify how to weight on-demand reference loads when the trigger points span the entire workflow arc (i.e., the reference is effectively fully loaded by mid-workflow). Treated as a single MEDIUM/HIGH finding with narrative caveat (Finding #2, #5).

---

## Confidence

- **HIGH** confidence on file-size measurements (direct wc -l / wc -w).
- **MEDIUM** confidence on per-dirty-path estimates (10–14 paths × ~40 lines is structural inference, not observed; reference is the SKILL.md Example which uses 14 paths).
- **MEDIUM** confidence on subagent-side context cost (4,000–10,000 tokens per subagent estimate is structural inference; operator 2026-04-17 telemetry of ~73k/subagent is much higher and can't be reproduced without fresh telemetry).
- **HIGH** confidence on the structural change since 2026-04-18 (Step 6.15/Step 6.17 etc. directly compared against current command file body — the text changes are unambiguous).
- **HIGH** confidence on the operator-question re-evaluation (line-by-line categorization of SKILL.md content into load-bearing vs non-load-bearing follows directly from Workflow steps and runtime trigger points).
