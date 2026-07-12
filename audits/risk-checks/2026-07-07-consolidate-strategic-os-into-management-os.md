# Risk Check — 2026-07-07

## Change

Structural change: consolidate two projects — dissolve `projects/strategic-os/` into `projects/management-os/` as ONE project with two subfolders, `strategyos/` (durable strategy + governance; today's strategic-os) and `operationsos/` (near-term operating horizon; today's management-os + a new `playbook/` layer). Boundary rule is a time horizon (near-term defaults to operationsos; durable residue lifts up to strategyos; strategyos runs a consistency check). Plus a standing intake pipeline (`/ingest-initiative`, project-local, built later) to decompose incoming mixed initiatives and route items.

Full plan (SO-reviewed, verdict PROCEED-to-risk-check with 5 conditions): `projects/strategic-os/audits/working/2026-07-07-management-os-consolidation-migration-plan.md`.

SO-flagged conditions weighted heavily in this check: (1) HIGHEST — authority wall becomes a folder-scoped write-deny + promote gate, defense-in-depth, replacing the repo boundary; (2) reference sweep incl. `state-retrieval-agent` / `refresh-project-state` confidentiality re-scope, vault name decision; (3) dissolving the strategic-os git repo (start-fresh + archive); (4) merging `shared-manifest.json` + `.claude/` union; (5) reversibility of the whole migration.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/audits/working/2026-07-07-management-os-consolidation-migration-plan.md — exists

## Verdict

**RECONSIDER**

**Summary:** Four of six dimensions score High — Permissions Surface, Blast Radius, Reversibility, and Hidden Coupling all compound at once, which by this check's own aggregation rule ("two or more High → RECONSIDER") means the risk profile is too concentrated for a single dedicated-session execution, independent of how well-reasoned the underlying design is (and this plan is unusually well-reasoned and self-aware — SO-reviewed with 5 named conditions).

## Consumer Inventory

Search terms derived from the change: `strategic-os`, `management-os`, `strategyos`, `operationsos`, `ingest-initiative`, `state-retrieval-agent`, `refresh-project-state`, `shared-manifest`, `additionalDirectories`, `knowledge-bases/strategic-os`. Grepped across `ai-resources/`, `projects/` (both project trees + `repo-documentation` vault), `knowledge-bases/`, and workspace-root files. (Note: a single top-level recursive grep from the workspace root silently failed to descend into nested project git repos — each project tree was grepped directly to compensate; this is recorded so the same blind spot doesn't recur in a future check.)

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/refresh-project-state.md` | parses | yes |
| `ai-resources/.claude/agents/project-state-scrub-verifier.md` | parses | yes |
| `ai-resources/.claude/agents/project-state-snapshot-agent.md` | parses | yes |
| `ai-resources/.claude/agents/risk-check-reviewer.md` (this reviewer's own definition) | imports | yes |
| `ai-resources/.claude/commands/consult.md` | documents | no |
| `ai-resources/.claude/commands/prime.md` | documents | no |
| `ai-resources/docs/agent-tier-table.md` | documents | yes |
| `ai-resources/docs/settings-local-recovery.md` | documents | no |
| `projects/management-os/CLAUDE.md` | parses | yes |
| `projects/management-os/.claude/commands/monday-brief.md` | invokes | yes |
| `projects/management-os/.claude/settings.local.json` | co-edits | yes |
| `projects/management-os/.claude/shared-manifest.json` | co-edits | yes |
| `projects/management-os/pipeline/*.md` (8 files: context-pack, architecture, project-plan, implementation-log, implementation-spec, session-guide, test-results, repo-snapshot) | documents | no |
| `projects/management-os/` git repo (own origin: `github.com/axcioncapital/management-os.git`) | co-edits | yes |
| `projects/strategic-os/.claude/agents/state-retrieval-agent.md` | parses | yes |
| `projects/strategic-os/.claude/agents/conflict-detector-agent.md` | parses | yes |
| `projects/strategic-os/.claude/commands/*.md` (prioritize, promote-to-live, strategic-decision, strategic-state) | invokes | yes |
| `projects/strategic-os/.claude/settings.json` | co-edits | yes |
| `projects/strategic-os/.claude/shared-manifest.json` | co-edits | yes |
| `knowledge-bases/strategic-os/CLAUDE.md` | documents | yes |
| `knowledge-bases/strategic-os/_master-index.md` | documents | yes |
| `knowledge-bases/strategic-os/project-state/_index.md` | documents | yes |
| `knowledge-bases/strategic-os/project-state/strategic-os.md` | documents | yes |
| `knowledge-bases/strategic-os/` own git repo (origin: `github.com/axcioncapital/kb-strategic-os.git`, currently 1 ahead of origin) | co-edits | yes |
| `projects/repo-documentation/vault/architecture/repo-state.md` | documents | no |
| `projects/repo-documentation/vault/projects/projects.md` | documents | no |
| `projects/repo-documentation/vault/components/projects.md` | documents | no |
| `.gitignore` (workspace root — orphaned `projects/strategic-os/` line once the path disappears) | co-edits | no |

**Total: 28 consumers, 20 must-change.** For the not-yet-present `/ingest-initiative` contract: zero current consumers found anywhere in the repo (`grep -rn "ingest-initiative"` returns no hits) — expected, since the plan explicitly defers the build until a second real initiative validates routing; noted under Dimension 6 as a DR-7-satisfying deferral, not a gap.

**Unanticipated consumer surfaced by this inventory:** `ai-resources/.claude/agents/risk-check-reviewer.md` — this reviewer's own agent definition — hardcodes `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` as its Dimension-6 principles-base source. This was not named in the operator's list of known coupling points or the SO's 5 conditions. It fails soft (falls back to inline checks per its own instructions) rather than hard-erroring, but every future `/risk-check` invocation silently loses the richer principles-base grounding until this path is updated. Flagged as a genuine blast-radius gap the change description did not anticipate.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The merge folds two project `CLAUDE.md` files into one (plan §7 step 4) — this is a project-level file, loaded only inside that project's own sessions, not a workspace-wide always-loaded file; no evidence of new content added to workspace-root or `ai-resources/CLAUDE.md`.
- No new hook is introduced — `projects/strategic-os/.claude/settings.json` and `projects/management-os/.claude/settings.json` both already run the same two `SessionStart` hooks (`auto-sync-shared.sh`, `check-permission-sanity.sh`); the merge doesn't add a third.
- `/ingest-initiative` is explicitly deferred: plan §5 — "specify the pipeline now, but build `/ingest-initiative` only after a second real initiative validates the routing" — and is project-local, on-demand (pay-as-used), not auto-loaded or broadly pattern-matched.
- Net effect is a dedup (one harness instead of two: plan §7 step 7 "consolidate the session harness to the project level... retire the second set"), which if anything reduces maintained-file count rather than adding always-loaded tokens.

### Dimension 2: Permissions Surface
**Risk:** High

- `projects/management-os/.claude/settings.json` (committed) currently grants unscoped `"Bash(*)"`, `"Read"`, `"Edit"`, `"Write"`, `"MultiEdit"` with `"defaultMode": "bypassPermissions"` — no path scoping on Write/Edit at all. `projects/strategic-os/.claude/settings.json` by contrast is narrowly scoped (explicit per-path `allow` list) with an explicit `deny` on `Write/Edit projects/strategic-os/state/live/**` and `inputs/**`. Merging these into one settings.json (plan §7 step 4) means the strategy-state protection becomes a single path-scoped deny line sitting inside an otherwise blanket-permissive file — the SO's own framing: "the merge deletes one of today's two protections (the repo boundary)" (plan §0 Condition 1).
- Evidence this may already be weaker than the plan assumes: `projects/management-os/.claude/settings.local.json` today grants `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` — the entire workspace root, not scoped to `strategic-os` alone — combined with management-os's unscoped `Write`/`Edit`/`Bash(*)` allow, a management-os session may already be technically able to reach `projects/strategic-os/state/live/` today; the only backstop is whichever settings.json Claude Code's permission resolver applies to a cross-directory write (untested here). This is a pre-existing gap the migration's proposed folder-scoped deny would likely fix if transcribed correctly — but it means the "repo boundary was the protection" premise in plan §0 Condition 1 deserves an explicit verification step, not an assumption.
- Deny-over-allow precedence is an established convention in this repo (`ai-resources/docs/permission-template.md` line 391: "Deny-shadows-allow ... sometimes intentional") — so the proposed single-line deny mechanism is not a novel assumption, but its correctness depends entirely on an exact-path transcription during a manual JSON merge (plan §7 step 5), which is exactly the kind of step that silently fails if the glob is off by one path segment.
- Mitigating factor already in the plan: defense-in-depth (deny rule + promote gate, each independently sufficient per plan §0) and an explicit DR-9 top-3 failure-mode analysis gate before execution (plan §7 step 5) — appropriate design, but the underlying widening (a previously separately-scoped, narrowly-permissioned tree now living inside a blanket-permissive file) is real and warrants High here regardless of the paired mitigation quality.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Step 1.5 Consumer Inventory: **28 consumers found, 20 must-change.** This exceeds the ">5 dependent callers, OR any caller requires modification" High threshold by a wide margin.
- Shared/canonical infrastructure is directly touched, not just the two merging projects: `ai-resources/.claude/commands/refresh-project-state.md` and its two agents (`project-state-scrub-verifier.md`, `project-state-snapshot-agent.md`) are canonical, used across **all** Axcíon projects (not just strategic-os/management-os) for the `/refresh-project-state` fan-out workflow — their hardcoded contract path `projects/strategic-os/docs/project-state-workflow-spec.md` breaks the moment the file moves, which is a cross-cutting break, not a two-project break.
- The inventory surfaced an unanticipated consumer not named in `CHANGE_DESCRIPTION` or the SO's 5 conditions: `ai-resources/.claude/agents/risk-check-reviewer.md` itself (see Consumer Inventory note above) — a gap the change description did not anticipate.
- Three separate git repositories are structurally involved: `projects/strategic-os` (dissolved), `projects/management-os` (destination, own origin `github.com/axcioncapital/management-os.git`), and `knowledge-bases/strategic-os` (own origin `github.com/axcioncapital/kb-strategic-os.git`, itself a candidate for rename per SO Concern 2c) — this is wider than the two-project framing in `CHANGE_DESCRIPTION` suggests.
- Contract change: the migration plan's own `state-retrieval-agent.md` re-scope (SO Concern 2) and the `project-state-snapshot-agent.md` per-project git-HEAD granularity logic (see Dimension 5) are non-backwards-compatible contract changes once `strategyos/` stops being its own git repo.

### Dimension 4: Reversibility
**Risk:** High

- The plan's own Risks section (§9) states plainly: "The git-history decision (§8.1) is one-way once executed" — `strategic-os` folds in as plain files and the dissolved repo is archived (§8.1), which is not undone by `git revert` inside `management-os`.
- State has propagated beyond a single git tree: `projects/management-os` has its own GitHub remote (`github.com/axcioncapital/management-os.git`, confirmed via `git remote -v`, currently 1 commit "init" tracking `main`), `projects/strategic-os` has its own remote (`github.com/axcioncapital/strategic-os.git`, confirmed in the migration plan §0), and `knowledge-bases/strategic-os` has its own remote (`github.com/axcioncapital/kb-strategic-os.git`, confirmed via `git remote -v`, currently 1 commit **ahead of origin**, unpushed). A rollback that only reverts local commits in one of these three repos does not restore the other two to their pre-migration state.
- Multi-step manual rollback required even before considering pushes: restoring the archived strategic-os repo, re-splitting files back out of management-os's now-merged history, re-creating the dropped `additionalDirectories` grant, reverting the merged `settings.json`/`shared-manifest.json` back into two files, and (if renamed) reverting the vault name — none of these are a single `git revert`.
- Workspace-root `.gitignore` currently has two separate entries (`projects/strategic-os/`, line 25; `projects/management-os/`, line 52); post-merge the first becomes an orphaned/stale entry pointing at a path that no longer exists — a low-cost but real manual cleanup step layered on top of the above.

### Dimension 5: Hidden Coupling
**Risk:** High

- `projects/strategic-os/.claude/agents/state-retrieval-agent.md` (line 58, 63) hardcodes an exclusion rule keyed on a one-level `projects/*/` glob depth: "Any file under `projects/*/inputs/` for projects OTHER than `strategic-os`" with an explicit exception carve-out for `projects/strategic-os/inputs/`. Once `operationsos/` and `strategyos/` become sibling subfolders of `projects/management-os/` (two levels deep), this glob pattern stops matching either folder's `inputs/` correctly — it needs re-deriving, not just a path rename. This mechanism is not named at this level of detail anywhere in the migration plan (plan §7 step 6 says "re-scope... confidentiality" generically); the specific glob-depth break is invisible from the change description alone.
- `projects/strategic-os/.claude/agents/project-state-snapshot-agent.md` (line 41) explicitly documents a behavior fork: "a project that is its own git repo (e.g., `strategic-os`) yields its own HEAD; a project that is a plain subdirectory of the workspace repo yields the *workspace* HEAD, so its §6.2 staleness check is workspace-level (coarser — it reads stale whenever any project commits)." Post-merge, `strategyos/` moves from the first case to the second — its Strategic Context Snapshot staleness check silently becomes coarser (any commit anywhere in the merged `management-os` repo, including routine `operationsos/` weekly-loop edits, will now mark the `strategyos` snapshot "stale"). This is a real, silent behavior change not mentioned in the plan's 8-item migration steps or its 5 open decisions.
- The merged `settings.json` (Dimension 2) creates a functional overlap the repo's own audit tooling is built to flag as a pattern ("Deny-shadows-allow... sometimes intentional," `ai-resources/docs/permission-template.md` line 391) rather than something novel — but it is still a second system (the deny rule) now doing the work the repo boundary used to do implicitly, which is the textbook two-systems-one-concern pattern this dimension checks for.
- `ai-resources/.claude/commands/consult.md` (lines 77–84) already documents a **prior real defect** from this exact basename collision: "2026-06-29 — the SO graded `knowledge-bases/strategic-os/` when the plan's named corpus was `projects/strategic-os/` (basename collision) and returned two BLOCKING findings grounded in the wrong corpus" — direct evidence that this specific coupling (two same-named-but-different resources) has already caused a live failure once, and the migration's vault-naming open decision (plan §8.2) has not yet resolved whether that collision risk persists or is removed.

### Dimension 6: Principle Alignment
**Risk:** Medium

Ground: `projects/strategic-os/ai-strategy/principles-base.md` (read directly) plus workspace/repo `CLAUDE.md` (already loaded).

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — satisfied, not violated.** The plan explicitly defers building `/ingest-initiative` until "a second real initiative validates the routing" (plan §5) and the Consumer Inventory confirms zero current consumers of that contract — this is DR-7 applied correctly (generalize only on a second confirmed consumer), not a violation. The consolidation itself is also not speculative: it is triggered by a concrete, already-received artifact (the rollout roadmap, ~30% strategic / ~70% operational per plan §3) that exposed a real boundary problem today, not a hypothetical future one.
- **OP-11 / OP-3 (loud revision, never silent drift) — satisfied.** The authority-wall mechanism changes from a physical repo boundary to a folder-scoped convention (Dimension 2/5 finding) — a real shift in *how* governance is enforced. This is being done loudly: SO-reviewed (`consult-2026-07-07-strategic-os-management-os-consolidation.md`), 5 named conditions, routed explicitly through `/risk-check` before execution (this document), per plan §10. Per this check's own instructions, a principle-adjacent shift that is loudly acknowledged and recorded is scored Medium/Low with a note, not High.
- **OP-2 (automate execution, gate judgment) — satisfied.** Genuine judgment calls (git-history disposition, vault naming, the authority-wall redesign itself) stay operator/SO-gated; only mechanical steps (file moves, reference sweep) are proposed for automation.
- **OP-5 (advisory vs. enforcement) — not implicated.** The promote-gate stays advisory-then-gated; nothing here silently upgrades an advisory mechanism to auto-enforcement.
- **DR-1 / DR-3 (placement) — satisfied.** `/ingest-initiative` is correctly placed project-local (plan §5: "It is project-local... not a canonical ai-resources command") — applies DR-1's test ("could this serve more than one project?") correctly; single-project intake logic has no second consumer.
- **The tension (why Medium, not Low):** the change replaces a *structural* guarantee (two separate git repos — physically impossible to cross-write without an explicit grant) with a *convention-based* one (one repo, a path-scoped deny line inside an otherwise blanket-permissive settings.json). That is a real philosophical downgrade in the enforcement mechanism's inherent robustness, even though the plan's defense-in-depth response (deny + promote gate, DR-9 analysis) is a reasonable, loudly-recorded attempt to compensate. This tension is best read as a Dimension 2/5 technical finding wearing a principle-shaped hat — it does not clearly violate a named principle ID outright, so Medium with this note, not High.

## Recommended redesign

The verdict is not driven by a single unmitigable High or an unacknowledged principle violation — it is driven by four High-scoring technical dimensions compounding at once in a single "execute in a dedicated session" pass (plan §10 step 4). Recommend decomposing execution into independently-verifiable stages, each small enough to re-run its own lightweight check, rather than one atomic move:

- **Stage first, move second.** Land and empirically verify the permission re-key (Dimension 2/6: the folder-scoped deny on `strategyos/state/live/**` + promote gate, plus the DR-9 top-3 analysis the plan already calls for) and the confidentiality re-scope (Dimension 5: `state-retrieval-agent.md`'s glob-depth fix, `project-state-snapshot-agent.md`'s per-project-repo assumption) — both *before* any physical file move, tested against a scratch copy of the target path shape. Only proceed to the git-repo dissolution + file move (plan §7 steps 1–2) once both are confirmed working against the *new* paths.
- **Empirically resolve the cross-directory permission-resolution question before finalizing the authority-wall design** (Dimension 2 finding): confirm whether Claude Code applies the *active session's* settings.json or the *target path's own* settings.json when writing to a directory reached via `additionalDirectories` — this determines whether the "repo boundary was the protection" premise in SO Condition 1 is accurate, and whether the proposed folder-scoped deny is a like-for-like replacement or a net-new protection layer being added for the first time.
- Sequence the canonical `ai-resources/` reference sweep (Dimension 3: `refresh-project-state.md` + its two agents + `risk-check-reviewer.md` + `agent-tier-table.md`) as its own change, verified independently, since these are shared infrastructure used by every Axcíon project, not just the two being merged — bundling this into the same session as the git-repo dissolution multiplies the blast radius of any single mistake.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from `CHANGE_DESCRIPTION` or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
