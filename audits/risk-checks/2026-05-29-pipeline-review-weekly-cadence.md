# Risk Check — 2026-05-29

## Change

Add a new `/pipeline-review` weekly cadence to the Axcíon AI `ai-resources/` repo.

New files:
- `.claude/commands/pipeline-review.md` — Sonnet orchestrator command. Operator-invoked. Reads a registry, presents a shortlist of 5 candidates (oldest-reviewed first; friction-flagged rows promoted), operator picks 1–3, spawns per-pipeline review subagents, writes memos, bumps the registry. No auto-fix; no commit.
- `.claude/agents/pipeline-review-auditor.md` — Opus deep-review subagent. For each picked pipeline, reads the pipeline file, the agents it spawns (parsed one level deep), the docs it explicitly references, last 5 commits touching the pipeline, recent friction-log entries naming the pipeline, and usage telemetry if present. Produces a structured memo (Summary / Innovations / Leanness fixes / Brokenness / Cross-resource interactions / Recommended next session). Returns ≤30-line summary to main session per the Subagent Contracts rule in ai-resources/CLAUDE.md.
- `audits/pipeline-review-registry.md` — table-form registry. ~14 seed rows. Columns: Pipeline · Type · Last reviewed · Last memo · Friction flag.

Modified files:
- `.claude/hooks/auto-sync-shared.sh` — add `pipeline-review` to `EXCLUDE_COMMANDS` (currently lists `new-project deploy-workflow run-sufficiency`). Must land in the same commit as the command file.
- `docs/operator-maintenance-cadence.md` — add a "Weekly pipeline review" section between Tue–Thu and Friday Session 1.
- `CLAUDE.md` (ai-resources) — add one short pointer line under `## Maintenance Cadence`.

Memo output directory `audits/pipeline-reviews/` created on first run via `mkdir -p`.

Cross-resource interactions:
- Parallels existing `/friday-checkup` and `/audit-critical-resources`. System Owner flagged second skipped-cycle recovery surface as a known design risk; mitigation is the >10-day warning in Step 0 and a fold-into-checkup revisit if skipped twice per quarter.
- Reuses the System Owner agent as the grounding model for the new auditor (same reference docs).
- Auditor is Opus; orchestrator is Sonnet (per `docs/agent-tier-table.md`).

Full plan: `/Users/patrik.lindeberg/.claude/plans/proceed-create-a-plan-compressed-nebula.md`.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/pipeline-review.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/pipeline-review-auditor.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-review-registry.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/operator-maintenance-cadence.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/.claude/plans/proceed-create-a-plan-compressed-nebula.md` — exists (full plan)

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** Pay-as-used new command with limited blast radius and clean reversibility, but two Medium-risk dimensions (hidden coupling around the parallel-cadence recovery gate, and a contract surface — registry columns + memo schema + tiebreak rule — that must be honored to keep the system coherent) push the verdict off pure GO.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New command and new agent are pay-as-used — invoked only when the operator types `/pipeline-review`. Neither is auto-loaded by a hook nor `@import`ed into an always-loaded file. Evidence: plan line 27 "operator-invoked"; line 11 "Cadence home → stand-alone weekly command, operator-invoked."
- CLAUDE.md pointer addition is one short line under `## Maintenance Cadence` (plan line 87 — verbatim: "Run `/pipeline-review` once a week to give a few critical pipelines deep System-Owner-grounded review. Registry: `audits/pipeline-review-registry.md`."). Well under the 50-token Medium threshold.
- `operator-maintenance-cadence.md` is not always-loaded — it is referenced from session-time docs (the Tue–Thu / Friday cadence file), not pulled into every turn. Adding a section here carries no per-session cost.
- Subagent `pipeline-review-auditor` honors the Subagent Contracts rule: ≤30-line summary returned, full notes to disk (plan line 75). Spawned at most 1–3 times per weekly invocation. No proliferation pattern.
- No SessionStart / PreToolUse / Stop hook is added or modified. The one hook touched (`auto-sync-shared.sh`) only gains an entry to the EXCLUDE list — that's a cost reduction, not a cost addition.

### Dimension 2: Permissions Surface
**Risk:** Low

- The proposed change introduces no new `allow`/`ask`/`deny` entries. The ai-resources settings (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json`) already grants `Bash(*)`, `Read`, `Edit(**/.claude/**)`, `Write(**/.claude/**)`, and `Edit`/`Write` over the workspace tree — every file the new command touches sits inside that authorized envelope.
- The auditor reads `git log --oneline -5 -- {path}` (plan line 42). `Bash(*)` is already allowed; no narrower wiring needed.
- No external/MCP/cross-repo capability is introduced. No scope escalation (project → user). No deny rule is loosened.

### Dimension 3: Blast Radius
**Risk:** Low

- Directly touched: 6 files (3 new, 3 modified). Plan §"Critical files to be modified or added" enumerates exactly this set.
- Grep across `ai-resources/.claude/` and `ai-resources/docs/` for `pipeline-review` returns zero pre-existing references — no callers to migrate. (Grep result above showed only project-side files in `projects/ai-development-lab/` unrelated to this change; those are independent project artifacts, not consumers of the new command.)
- `auto-sync-shared.sh` modification is a one-token append to the `EXCLUDE_COMMANDS` string on line 46. Same shape as existing entries `new-project deploy-workflow run-sufficiency`. The script's loop logic (lines 82–96) reads the variable identically for the new entry — no logic change.
- `operator-maintenance-cadence.md` insertion is additive (new section between existing sections). Existing sections unchanged.
- `CLAUDE.md` addition is a one-line pointer under an existing section. No restructure.
- System Owner agent is referenced as the *grounding model* for the new auditor body — not modified. Evidence: plan line 96 "kept as-is."
- No contract change to any existing component. The new contracts (registry columns, memo headings, subagent summary cap) live entirely inside the new files. Captured under Dimension 5.

### Dimension 4: Reversibility
**Risk:** Low

- All six file changes (3 new + 3 modified) are tracked by git. `git revert` of the landing commit cleanly removes the three new files and restores the three modified files to prior state.
- Memo directory `audits/pipeline-reviews/` is created at first invocation via `mkdir -p` (plan line 32). Until the command is actually run, the directory does not exist — pure-edit revert leaves no orphan directory.
- If the command has been run before revert: the `audits/pipeline-reviews/{slug}-{DATE}.md` memos and the registry-row mutations (Last reviewed / Last memo / Friction flag = N writes) survive the revert. These are append-only audit artifacts of the same class as `audits/friday-checkup-*.md` (which already accumulate under the same directory) — the residue is informational, not load-bearing, and does not break a re-land. Classifies as Low (clean revert) on the assumption no auto-fix or commit fires from the command itself (plan line 34 confirms "No auto-fix. No commit").
- No external writes (no `git push` is part of the command, no Notion write, no third-party API call). Evidence: plan line 34 "operator commits at session wrap."
- No hook registration. The one hook change (`EXCLUDE_COMMANDS` edit) is a subtraction in semantics — reverting it just re-includes the command in the auto-sync set, which is the *less safe* state. Note this asymmetry under Dimension 5 / Mitigations.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Cadence-recovery coupling (acknowledged design risk).** Plan lines 101–105 explicitly call it out: two operator-invoked cadences (`/friday-checkup` and `/pipeline-review`) with independent recovery gates can stall together silently. Mitigation in the plan is the >10-day warning in Step 0 plus a quarterly revisit. This is documented at the change site, but the System Owner's preferred resolution (fold into `/friday-checkup` as a new tier) was overridden — the residual risk lives on.
- **Implicit dependency on System Owner agent reference docs.** The new auditor grounds in `principles.md`, `system-doc.md`, `blueprint.md`, `risk-topology.md`, `repo-architecture.md` via the System Owner pattern (CHANGE_DESCRIPTION § "Cross-resource interactions"). If any of those reference docs is renamed or restructured later, the auditor breaks silently. The dependency is not contract-protected — it is a parallel-load convention.
- **Registry contract is load-bearing across runs.** Five columns (Pipeline, Type, Last reviewed, Last memo, Friction flag) plus a date-keyed `Last memo` reference shape (plan line 22: "date-keyed, not path-keyed, per System Owner's `risk-topology.md § 1` warning"). The command writes; the next-week invocation reads. If a column is renamed or the date-key shape drifts, future runs misread their own state. Contract is documented inside the command body (plan line 22), which lifts the risk from High to Medium — but the contract is novel, not borrowed from an existing pattern.
- **Tiebreak rule is novel and silent.** Plan line 30: "Tiebreak among rows sharing a `Last reviewed` value — including the cold-start case where every row is `never` — is alphabetical by pipeline path. Promote any row with `Friction flag = Y` to the top regardless of date." This is the entire selection contract. Operator behavior in week 1 (all rows `never`) depends on alphabetical-by-path ordering; surprise risk if undocumented inside the command body. Plan calls for it to be specified there — verify at execution.
- **Auto-sync EXCLUDE asymmetry.** If the EXCLUDE edit is reverted but the command file remains (e.g., partial revert, manual re-add), every project's next SessionStart hook would symlink `pipeline-review.md` into `.claude/commands/`. The command would then appear available in projects where it has no use case. Risk is low day-to-day (only fires on revert), but the asymmetry is silent.
- **Functional adjacency to `/audit-critical-resources`.** Both audit the same pipelines. Distinct concerns ("what could be better?" vs. "what's broken?"), but operators may run them too close together and double-spend attention. Plan acknowledges the orthogonality (line 97). Risk is operator-discipline, not technical, but counts as one overlap.

### Multi-dimension note

The plan itself notes (line 91) that `/risk-check` at plan-time is a must-fix gate per `principles.md § DR-8`, and the verdict gates execution. This risk check is being run at the gate that the plan itself names — the meta-loop is intact.

## Mitigations

Verdict is **PROCEED-WITH-CAUTION** with one Medium dimension carrying multiple paired risks. Apply the following before or during landing:

- **Mitigation for Dimension 5 (cadence-recovery coupling):** In `/pipeline-review` Step 0, the >10-day warning must be loud and unmissable — emit it as a top-line `[CADENCE-LATE]` chat marker (not buried below the shortlist). Same shape `/friday-checkup` Step 0 uses. Operator must see it before the shortlist renders.
- **Mitigation for Dimension 5 (System Owner reference-doc dependency):** In the `pipeline-review-auditor.md` body, list each reference doc by absolute path with a one-line description of what it grounds. If any read returns missing, the agent must abort with a named error rather than proceed with partial grounding. Do not silently degrade.
- **Mitigation for Dimension 5 (registry contract):** Inside `/pipeline-review` body, include a one-paragraph "Registry contract" block that names the five columns, the date-key shape for `Last memo`, and the sort/tiebreak rule verbatim. This is the canonical reference; future improvements must update this block, not infer from row patterns.
- **Mitigation for Dimension 5 (tiebreak surprise):** First-run output must explicitly print "all rows are `never` — falling back to alphabetical-by-pipeline-path." Surface the tiebreak inline so the operator can audit it.
- **Mitigation for Dimension 5 (auto-sync asymmetry):** Land the `auto-sync-shared.sh` EXCLUDE edit in the *same commit* as the command file (already in the plan, line 92). Do not split into a follow-up commit even if it would simplify the diff.
- **Mitigation for Dimension 4 / cleanliness:** Note in the command body that registry mutations and memo writes are not revertable by `git revert` alone — operator should treat them as audit-trail-grade artifacts. Avoid spurious "test runs" against the registry.

## Recommended redesign

Not applicable — verdict is PROCEED-WITH-CAUTION, not RECONSIDER. The System Owner's preferred fold-into-`/friday-checkup` redesign is captured as a quarterly-revisit gate in the plan and does not need to fire pre-execution.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: plan line citations (lines 11, 27, 30, 32, 34, 42, 75, 87, 91–105), file content (`auto-sync-shared.sh` line 46 `EXCLUDE_COMMANDS`; ai-resources `settings.json` allow-list; `CLAUDE.md` § Maintenance Cadence and § Subagent Contracts), and a grep that returned no pre-existing `pipeline-review` references inside `ai-resources/.claude/` or `ai-resources/docs/`. No training-data fallback was used.
