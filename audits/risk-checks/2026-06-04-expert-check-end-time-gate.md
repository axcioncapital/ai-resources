# Risk Check — 2026-06-04

## Change

END-TIME GATE (executed change set, batched, pre-commit):
End-time risk-check for the built "Expert Check" advisory function. The plan-time gate returned PROCEED-WITH-CAUTION with 7 conditions; all were applied during the build and an independent /qc-pass returned GO verifying each. Executed change set (all in ai-resources, unstaged working tree):
(1) NEW command ai-resources/.claude/commands/expert-check.md (model: sonnet) — operator-invoked; collects artifact + step subject + REQUIRED KB target + intent; spawns the reviewer agent; presents findings verbatim; names a closure path (route to /decide or /resolve, or disposition inline). States the boundary vs /qc-pass (internal criteria) and /refinement-pass (prose). Advisory, never blocking.
(2) NEW agent ai-resources/.claude/agents/expert-check-reviewer.md (model: opus; tools Read, Glob, Grep — NO Write, read-only) — resolves a REQUIRED target KB under knowledge-bases/ via a documented read contract (standard /deploy-kb vault: read _master-index.md → research/ notes; non-standard vault: bounded *.md glob excluding templates/.obsidian/.claude/_index files), topic-matches summaries to the step subject, returns divergence → cited principle → suggested reconciliation (max 10), or NO APPLICABLE REFERENCE; advisory voice only; read cap 10 files; no all-KB default (returns INPUT ERROR if no KB target).
(3) EDIT ai-resources/docs/repo-architecture.md — added one row to the Cross-repo coupling points table documenting the command/agent ↔ knowledge-bases read-only coupling.
Distribution: the auto-sync hook will symlink the new command + agent into the 13 projects that have a shared-manifest.json on next session start (neither matches a baked-in exclusion glob). Reversibility note for commit: revert requires removing the two files + the architecture row, and cleaning up the agent/command symlinks across those project dirs.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/expert-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/expert-check-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists

## Verdict

GO

**Summary:** The executed change set matches the approved plan-time design with all 7 plan-time conditions landed in the files and the central plan-time drift (skill → command) correctly resolved; the only residual is a non-blocking count mismatch in the operator-facing distribution/reversibility note, which costs nothing structurally and is corrected in the commit note.

## Consumer Inventory

Search terms: `expert-check`, `expert-check-reviewer`, `knowledge-bases`, `_master-index.md`. Greps run across `ai-resources/` and the workspace root (`..`). The change is net-new namespace — grep for `expert-check` returns only the change's own files plus its own plan-time gate report and the system-owner consultation. No pre-existing component references it.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/expert-check.md | invokes (spawns `expert-check-reviewer`) | no — landed this change |
| ai-resources/.claude/agents/expert-check-reviewer.md | co-edits (the spawned reviewer; paired with the command) | no — landed this change |
| ai-resources/docs/repo-architecture.md | documents (coupling-points row, line 154) | no — landed this change |
| knowledge-bases/marketing-communication/ (live vault) | parses (read-contract STANDARD branch: root `_master-index.md` + `research/`) | no — layout already matches contract |
| knowledge-bases/pe-kb-vault/ (live vault) | parses (read-contract NON-STANDARD branch: no root `_master-index.md`, bounded glob) | no — layout already matches contract |
| ai-resources/.claude/commands/{decide,resolve}.md | documents (named as closure paths in Step 5) | no — both exist; named, not modified |
| ai-resources/.claude/commands/{qc-pass,refinement-pass}.md | documents (named in the boundary section) | no — both exist; named, not modified |
| 13 project `.claude/{commands,agents}/` + 4 non-project manifest holders (KB vaults, workflow) | imports (auto-sync symlink target on next SessionStart) | no — additive symlink; existing files never overwritten |

Total: 8 in-repo consumer rows + 17 symlink-distribution targets, **0 must-change**. The change is additive: the two new files are the only things that reference the new namespace, and the two contract-parsing consumers (the live KB vaults) already conform to the documented read contract — verified, not assumed. The plan-time inventory anticipated the KB-vault parse coupling; the end-time inventory confirms both live vaults exercise *both* branches of the read contract (one standard, one non-standard), which is the strongest possible validation of condition (2).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The command is operator-invoked and pay-as-used — `commands/expert-check.md` is not auto-loaded; it costs tokens only when `/expert-check` runs (command file states "Run an independent Expert Check on the work you just drafted", line 7; no SessionStart/PreToolUse/Stop hook registered).
- The agent is spawned only by the command, on demand, and is read-only — no per-session or per-tool-call cost (agent frontmatter `tools: Read, Glob, Grep`, no auto-trigger; spawn is Step 3 of the command).
- No content was added to any always-loaded CLAUDE.md and no `@import` was added. The only edit to a load-on-demand file is one table row in `repo-architecture.md` (line 154), which loads only when an operator/`/placement` consults it — not every turn.
- The agent enforces a hard read cap of 10 files (agent line 35: "Hard read cap: 10 files total"), bounding per-invocation cost even on a large KB.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` allow/ask/deny entry was added, removed, or widened — the change set is two markdown component files plus one doc-table row; no settings layer is touched.
- The agent is strictly read-only: `tools: Read, Glob, Grep` (agent lines 5-8), explicitly NO Write/Edit. Agent body reinforces this (line 36: "Read-only. Never write or edit any file."). This is *narrower* than the default tool surface, not wider.
- The KB read coupling is read-only by design (repo-architecture.md:154 "Read-only; advisory output only") and reads vaults already visible to project sessions via the existing `--add-dir` topology — it introduces no new cross-repo *write* capability.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Consumer Inventory above: **0 must-change consumers.** Grep for `expert-check` across `ai-resources/` and the workspace root returns only the change's own files, its plan-time gate report, and the system-owner consultation — no pre-existing component invokes or parses the new namespace (additive, net-new).
- The only contract the change *depends on* (not introduces) is the KB read contract against `knowledge-bases/` vaults. Both live vaults were inspected: `marketing-communication/` has root `_master-index.md` + `research/_index.md` + a positioning summary (STANDARD branch); `pe-kb-vault/` has no root `_master-index.md` (NON-STANDARD glob branch). Both branches of the documented contract are exercised by real data — the contract is validated, not speculative.
- Auto-sync distribution is additive-only: rule 1 of the hook ("Existing files at the target are never overwritten" — repo-architecture.md:130) means symlinking the new command/agent into all manifest holders cannot break any existing project file.
- **Distribution-count discrepancy (minor blast-radius finding, not anticipated by the change description):** the description says the hook will symlink into "the 13 projects that have a shared-manifest.json." `find` confirms **13 manifests under `projects/`**, but **17 total workspace-wide** — the extra 4 are `knowledge-bases/pe-kb-vault/`, `archive/nordic-pe-macro-landscape-H1-2026/`, `projects/repo-documentation/vault/`, and `ai-resources/workflows/research-workflow/`. The hook walks every manifest holder, so the real distribution surface is ~16-17 targets, not 13. This widens the *reversibility* cleanup surface (Dimension 4) but does not change the additive-only safety — it is a count-accuracy issue in the operator-facing note, addressed in the commit-note correction, not a structural risk.

### Dimension 4: Reversibility
**Risk:** Low

- Core revert is clean: the change is two new tracked files (`commands/expert-check.md`, `agents/expert-check-reviewer.md`) plus one tracked doc-table row (`repo-architecture.md:154`). `git revert` of the commit removes all three with no orphaned data — no log mutation, no append-only registry write, no external/pushed state.
- The one extra cleanup step is the symlinks: reverting the source files in ai-resources leaves dangling symlinks in each manifest holder's `.claude/{commands,agents}/` until the next auto-sync (or a manual sweep). This is a known, well-trodden pattern in this repo (`audits/symlink-cleanup-2026-05-29.md` documents prior symlink cleanups), and the description correctly flags it as a reversibility note for the commit.
- The reversibility note should be count-corrected: cleanup spans the ~16-17 manifest holders found by `find`, not "13 projects" — see Dimension 3. This is a one-line edit to the commit note, not a new rollback step.
- No state propagates beyond git: the agent is read-only (no writes anywhere), the command produces only in-chat advisory output, and nothing is pushed mid-session (workspace push is gated to wrap-session). Nothing fires automatically between landing and a potential revert except the additive symlink sync, which is non-destructive.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The single real dependency — the KB read contract — is **documented at the change site** (agent lines 24-38 "KB Read Contract", and repo-architecture.md:154 records the coupling as a first-class cross-repo coupling point). A documented contract at the change site is the Low bar, not the Medium one.
- The contract is also *validated against live data*: both live vaults match a documented branch (verified this gate), so the agent will not silently fail on either current vault. The non-standard branch's exclusion list (agent line 29: excludes `templates/`, `.obsidian/`, `.claude/`, `_index.md`/`_master-index.md`/`_integrity-report-*`) correctly matches the noise files actually present in `pe-kb-vault/` (`_integrity-report-2026-04-29.md`, `_setup-notes.md`, `templates/`).
- The overlap risk flagged at plan-time (Expert-Check vs `/qc-pass` vs `/refinement-pass` contending for the same "review the drafted step" trigger) is closed: the boundary is stated in BOTH the command (lines 17-23, "Boundary — what this is NOT") and the agent (line 50, "You do NOT QC the artifact against its own criteria … you do NOT polish prose"). No silent contention — the three reviewers have explicitly disjoint jobs.
- No silent auto-firing: the agent has no auto-trigger (it is spawned only by the command), and the command is operator-invoked. There is no hook-ordering or cross-session side-effect surface.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active principles).

- **OP-12 (closure before detection) — SATISFIED.** Expert-Check is a detection component; OP-12 requires it ship behind a working closure channel. The command names the closure path explicitly (Step 5, lines 39-44: route divergences through `/decide` or `/resolve`, disposition inline, or note-and-proceed). Both named closure commands exist on disk (`commands/decide.md`, `commands/resolve.md` — verified). This was plan-time condition (7), the gap the dimension review missed; it is now closed in the file. OP-12 counts *for* this change.
- **OP-5 (advisory ≠ enforcement) — SATISFIED.** The change stays firmly advisory: command line 9 "Advisory only — never blocking"; agent line 13 "You are advisory. You never block"; agent rule line 84 "Advisory voice only: 'diverges from / consider / could.' Never 'must / fail / blocked.'" No enforcement upgrade — it advises and stops.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction) — SATISFIED.** The KB read coupling is built against **confirmed consumers**: two live vaults exist (`marketing-communication/`, `pe-kb-vault/`), each matching a documented read-contract branch. The change is not "a hook for an absent Phase-2 KB" — the consumer data is on disk now. The repo-architecture row correctly calls this "First shared consumer of `knowledge-bases/` vault content as command input."
- **DR-1 / DR-3 (placement) — SATISFIED.** Command in `ai-resources/.claude/commands/`, agent in `ai-resources/.claude/agents/` — both canonical homes per repo-architecture.md:99-100. The plan-time drift (skill → command) actually *improves* placement: it routes the front door to a slash command (which the auto-sync hook distributes) instead of a skill (which the hook does not touch) — resolving the plan-time artifact-type mismatch.
- **OP-10 (system boundary) — not touched.** The change reads `knowledge-bases/` vaults inside the Claude Code workspace; it does not govern GPT/Perplexity/NotebookLM/Notion behavior. No boundary expansion.
- **DR-8 (gated structural change requires plan-time + end-time risk-check) — SATISFIED.** This end-time gate is itself the second firing of the two-gate model for a new-command + new-agent + new-symlink change class.

### Drift / scope-creep meta-check (end-time specific)

- **Resolved drift (good):** plan-time design was a *skill* + agent; executed is a *command* + agent. This is plan-time mitigation (1) ("build as a command, not a skill — blocking") applied as intended — the skill at `skills/expert-check/SKILL.md` was correctly NOT created (grep: 0 skill hits). This is *convergent* drift toward the approved mitigation, not divergence.
- **No scope creep:** the executed set is exactly the three artifacts the plan approved (one command, one agent, one doc row). No extra files, no new hooks, no settings edits, no log writes appeared during the build.
- **All 7 plan-time conditions verified landed:** (1) command not skill — ✓ file present, skill absent; (2) KB read contract documented + validated against both live KBs — ✓ agent lines 24-38, both vaults inspected; (3) repo-architecture coupling row — ✓ line 154; (4) reviewer boundary stated — ✓ command lines 17-23 + agent line 50; (5) REQUIRED KB target, no all-KB default — ✓ command line 32, agent line 21 INPUT ERROR; (6) commit symlink-cleanup note + count reconciled — partial: note present in description but count says "13" vs ~16-17 actual (corrected here); (7) closure path named (OP-12) — ✓ command lines 39-44, both targets exist.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (expert-check.md:7,9,17-23,32,39-44; expert-check-reviewer.md:5-8,13,21,24-38,50,84; repo-architecture.md:130,154,99-100), grep counts (0 pre-existing `expert-check` consumers; 13 project manifests vs 17 workspace-wide), live filesystem inspection of both KB vaults (`marketing-communication/` standard branch, `pe-kb-vault/` non-standard branch), existence checks for the four named closure/boundary commands, auto-sync exclusion lists (`auto-sync-shared.sh:46-47`), and the frozen-ID `principles-base.md` (OP-5, OP-9, OP-10, OP-12, DR-1/3/7/8, AP-7). No training-data fallback was used on any read.
