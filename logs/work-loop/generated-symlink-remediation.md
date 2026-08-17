---
task: generated-symlink-remediation
status: active
turn: codex
---

## Objective and scope

Make manifest-managed shared-resource symlinks checkout-local generated products: canonical manifests and project-owned resources remain tracked, while generated destinations are ignored locally, later guarded from staging, and verifiably regenerable at different checkout depths.

This task is limited to the canonical mechanism and regression protection owned by `ai-resources`. The legacy-branch untracking rollout, branch merges or rebases, conflict resolution, pushes, and unrelated symlink systems are excluded; they require a later task in the repository that actually holds the named branches.

Task exit condition: the canonical generated-path calculation is shared by synchronization, local exclusion, staging prevention, and health validation; representative normal and nested-checkout behavior is proven. Units 1–3 have established synchronization, checkout-local exclusion, and the canonical commit-boundary guard. Versioned installation/refresh and health validation remain.

## Lane and unit

Standard. Discovery mode. Unit 4 — downstream pre-commit installation ownership.

Named reason for the loop: this load-bearing SessionStart mechanism spans multiple bounded units, and its implementation must be independently assessed before it counts as complete.

## Brief

Unit 3 is accepted. The canonical guard now blocks the force-add escape wherever the tracked pre-commit body is installed, but Unit 2 established that no versioned installation route currently carries that body to downstream checkouts. This unit resolves which existing repository-owned flow should install or refresh it before any deployment surface is changed.

Required outcome: determine the smallest safe, versioned ownership boundary for installing and refreshing the canonical `.claude/hooks/pre-commit` body in every in-scope Git checkout that receives manifest-managed generated links. Return one recommendation precise enough to frame the next implementation unit, including how it preserves an existing project-owned pre-commit hook or stops rather than overwriting it.

Authority and source disposition:

- Governing: the task objective and accepted commits `2aedc455`, `125cfc39`, and `638ab8cc`.
- Verified repository reality from Unit 2: `.git/hooks/pre-commit` is the executing surface; no versioned installer was found in `.claude/commands/`, `templates/`, or `docs/`; the tracked hook was machine-local in reach. Unit 3 refreshed only this checkout and did not claim deployment.
- Verify-first candidates, not requirements: `.claude/hooks/auto-sync-shared.sh` is already a SessionStart route into manifest-bearing projects; `.claude/commands/sync-workflow.md` and `.claude/commands/deploy-workflow.md` already own explicit synchronization/deployment behavior; `.claude/commands/new-project.md` and `templates/project-settings.json.template` participate in new-project setup. Their exact contracts and Git-checkout reach must be established before choosing.
- Codex framing decision: make this a discovery unit because installation ownership, checkout topology, and collision behavior remain load-bearing unknowns. Health validation, implementation of the chosen installer, legacy tracked-link cleanup, and documentation corrections stay outside this unit.

Inspect only the surfaces needed to settle the ownership boundary:

1. Establish the actual Git topology of representative manifest-bearing projects and the workspace/`ai-resources` repositories: which paths have their own Git directory or shared Git common directory, and therefore which `.git/hooks/pre-commit` actually executes for commits made from those paths. Name the representative paths checked; do not infer topology from directory nesting.
2. Read the relevant installation/synchronization contracts in `.claude/hooks/auto-sync-shared.sh`, `.claude/commands/sync-workflow.md`, `.claude/commands/deploy-workflow.md`, `.claude/commands/new-project.md`, `templates/project-settings.json.template`, and `templates/README.md`. Search those same bounded surfaces for `.git/hooks`, `pre-commit`, hook copying, executable-mode handling, and collision/overwrite policy; report absence only within that named set.
3. Compare the candidate owners by invocation timing, coverage of existing versus new checkouts, ability to locate the correct Git hook path (including worktrees), idempotency, and behavior when an installed pre-commit hook is absent, byte-identical, stale from this canonical body, or genuinely project-owned.
4. Determine whether one existing route can own both initial installation and refresh without duplicating policy. If not, identify the minimum split and why one owner cannot safely cover both. Do not invent a general hook manager unless the evidence makes that unavoidable.
5. Return one recommended owner/boundary, the exact next implementation scope, the failing case that would prove the current gap, the regression evidence the implementation should require, and any collision that must stop for the operator rather than overwrite local work.

Scope and exclusions:

- In scope: read-only repository inspection, read-only Git topology/history inspection, bounded throwaway experiments if needed to establish `git rev-parse --git-path hooks/pre-commit` behavior, and this state file.
- Excluded: edits to hooks, commands, templates, docs, settings, or downstream projects; installing or refreshing any live hook; branch operations; legacy symlink cleanup; health-check implementation.
- Do not treat the unsupported `.claude/hooks/pre-commit` header claim as authority. Do not expand `check-foreign-staging.sh`; Unit 2 established that it is a different, dormant control with the wrong observation boundary.

Capability subset: baseline only — repository read/search, read-only Git inspection, bounded throwaway local fixtures, this state-file update, and Claude-owned state-only commit. Nothing is selected from the pre-authorizable set, which is empty today. No network, live hook installation, push, merge, rebase, downstream write, credential access, destructive shared-state action, or operator-reserved capability is authorized.

Evidence required:

1. A path-to-Git-hook topology table grounded in commands and representative paths, including normal and linked-worktree behavior where relevant.
2. A candidate-owner comparison grounded in the named files and bounded searches, including explicit collision handling for absent, identical, stale-canonical, and project-owned installed hooks.
3. One recommendation with rejected alternatives and the exact evidence-based reason each is less safe or less complete.
4. A smallest-next-unit implementation boundary and a regression plan whose checks could fail.
5. The state-only commit id and exact changed-file list; report branch divergence separately and do not reconcile it.

Completion condition: resolve the installation/refresh ownership boundary by inspection, commit only this updated state file, set `turn: codex`, and hand back for reframing. Do not implement the recommendation.

Stop and hand back if the representative Git topology cannot be established locally; if every viable route would overwrite an unclassified project-owned hook; if the recommendation requires a new authority policy or materially broader scope; or if evidence leaves two owners genuinely tied.

## Latest result

Unit 3 accepted by Codex (2026-08-17). Commit `638ab8cc` adds Guard 3 to the tracked pre-commit body plus `logs/scripts/pre-commit-generated-guard.test.sh`. Claude's failing-before/passing-after evidence showed force-added generated destinations changed from commit success to a blocked commit with unchanged HEAD and an actionable path-specific message; ordinary commits, the existing A–F suite, and shell syntax checks passed. The implementation consumes the Unit 1 managed block without reinterpreting the manifest, and this checkout's installed copy was refreshed byte-identically. The follow-up repair commit `e17b0645` removed duplicated state headings only; it changed no implementation file.

Accepted limitation for this point in the task: the guard protects only checkouts where the canonical pre-commit body is installed. Unit 4 resolves the versioned installation/refresh owner; health validation and the previously identified stale documentation claims remain deferred.

### Unit 4 discovery (2026-08-17) — read-only; no hook, command, template or downstream file changed

Method note, load-bearing: `grep` on this machine is **ugrep 7.5.0**, and recursive search rooted at the workspace directory silently under-reports (`grep -Rl "auto-sync-shared" --include=settings.json .` returned 2; `find … | xargs grep -l` returned 41 for the same corpus). Every count below is from traversal-independent `find | xargs grep` or from explicit per-path checks. An earlier draft of finding (2) was wrong for this reason and was re-derived.

**1. Path-to-Git-hook topology.** Established with `git -C <path> rev-parse --git-dir --git-common-dir --git-path hooks/pre-commit`, never from directory nesting. 43 manifest-bearing checkouts (`find` for `.claude/shared-manifest.json`) resolve to **30 distinct executing `pre-commit` surfaces**; 13 collapse.

| Class | Representative paths | Executing hook path | Note |
|---|---|---|---|
| Own repo | `projects/axcion-copy-factory`, `projects/management-os`, +24 more | `<checkout>/.git/hooks/pre-commit` | one surface each |
| Linked worktree → common dir | `ai-resources/.claude/worktrees/concurrency-fix` (git-dir `…/.git/worktrees/concurrency-fix`) | `ai-resources/.git/hooks/pre-commit` | **worktrees share the main checkout's hooks** |
| Sibling worktrees of one repo | `projects/axcion-systems-builder-{dashboard,methodology-r-d,strategyos}` | `projects/axcion-systems-builder/.git/hooks/pre-commit` | 3 checkouts → 1 surface |
| Nested, not its own repo | `projects/personal`, `projects/contacting-operations`, `artifacts/merged-os-context/*` | workspace-root `.git/hooks/pre-commit` | inherit the root repo |
| Workflow deployments | the 9 `*/workflows/research-workflow` manifests | `ai-resources/.git/hooks/pre-commit` | all 9 → the one ai-resources surface |

Decisive consequence: `git rev-parse --git-path hooks/pre-commit` returns the **common** directory for a linked worktree, so one install per repo covers every worktree of it. The 18 ai-resources worktrees need exactly one install.

**2. Installed-state / collision census** across the 30 surfaces, `cmp` against the canonical 10217-byte body. All four collision classes exist in the wild:

| State | Count | Evidence |
|---|---|---|
| ABSENT | 26 | no file at the resolved hook path |
| IDENTICAL | 1 | `ai-resources/.git/hooks/pre-commit` — the copy Unit 3 refreshed |
| STALE-CANONICAL | 1 | workspace-root `.git/hooks/pre-commit`, 6243 bytes, mtime 2026-07-25; `diff` of its first 8 lines against the canonical body is **empty** — same lineage, older body, carrying the unsupported "Claude Code picks it up" header line |
| PROJECT-OWNED | 2 | `projects/axcion-website/.git/hooks/pre-commit` → symlink `../../.claude/hooks/boundary-leakage-check.sh`; `projects/axcion-pitch-engine/.git/hooks/pre-commit` → symlink `../../.claude/hooks/check-case-boundary.sh` — both real confidentiality/boundary guards with their own architecture references |

**3. No installer exists.** `find` over `.claude/`, `templates/`, `docs/`, `logs/scripts/`, `workflows/` (worktrees excluded) for `.git/hooks` returns three files: the two pre-commit test suites (which install into throwaway fixtures) and `docs/harness-and-permission-troubleshooting.md` (prose). Filtering for install verbs (`cp`/`ln -s`/`install` targeting `.git/hooks`) leaves **only the two test suites**. Absence is claimed for these named trees.

**4. Candidate owners, compared.**

| Candidate | Fires | Reach over the 30 surfaces | Verdict |
|---|---|---|---|
| `.claude/hooks/auto-sync-shared.sh` | SessionStart, automatically | all manifest-bearing checkouts; **41 settings.json files register it** (verified `find｜xargs`) | **recommended** |
| `/deploy-workflow` | operator, at template deploy | zero existing surfaces; and it **explicitly excludes `pre-commit`** (`deploy-workflow.md:124`) while copying to `.claude/hooks/`, not the executing `.git/hooks/` | rejected |
| `/sync-workflow` | operator, per workflow template | scoped to `TEMPLATE_DIR = workflows/<name>`; its 9 in-scope checkouts all resolve to the single ai-resources surface already covered; operator-invoked, so no refresh guarantee | rejected |
| `/new-project` | once, at creation | zero existing surfaces. Has the right precedent (`cp … && chmod +x`, `new-project.md:753`) but is redundant — the new project's first session fires the SessionStart hook anyway | rejected as owner |
| new general hook manager | — | nothing in the evidence requires a second policy surface | rejected |

`auto-sync-shared.sh` wins on four grounds beyond reach: it already writes checkout-local Git state of exactly this class (`write_exclude_block` → `git rev-parse --git-path info/exclude`), it already resolves `ai-resources` by upward walk, it already **owns the managed block the guard consumes** — so install and block stay in lockstep with no second interpretation — and it is already fail-open throughout, which is the mandatory posture for anything running at SessionStart.

**5. New finding that strengthens the choice.** The managed exclude block is currently present in **zero** repos (checked directly across all 43 checkouts, and re-verified per-path in `ai-resources`, `axcion-copy-factory`, `management-os`, `axcion-website` — each has an `info/exclude` file, none has the block, while each project already holds 80+ generated symlinks). Unit 1 landed today; no session has started in those checkouts since. **Guard 3 therefore fail-opens everywhere right now.** Whichever run first creates the block should also install the guard that reads it — which only Owner A can do.

**6. Recommendation — one owner, no split.** `auto-sync-shared.sh` owns both initial installation and refresh, in a new fail-open step that runs alongside `write_exclude_block`. Collision policy, keyed to the census above: ABSENT → install + `chmod +x`; byte-IDENTICAL → no-op; **provenance-marked** and differing → refresh; **marker-less or symlink** → never touch, report through the existing `additionalContext` channel. Because today's stale workspace-root copy predates any marker, a marker-less body must classify as project-owned on first run — so the workspace root gets **reported, not overwritten**, and its adoption is one explicit operator decision rather than a silent replacement. This requires adding a stable provenance marker line to the canonical body, which is the only change the recommendation asks of `pre-commit` itself.

Two constraints the implementation must carry: `.git/hooks/` is untracked, so `git revert` cannot restore an overwrite (`audits/risk-checks/2026-07-12-m-a-wave2-…md`) — snapshot before any write; and the historical `$(dirname "$0")` companion-resolution bug that would have silently disabled `check-skill-size.sh` at the installed location is **already fixed** in the canonical body (lines 198–214 resolve via `git rev-parse --show-toplevel`), so this precondition is satisfied rather than outstanding.

**7. Smallest next unit.** In scope: `.claude/hooks/auto-sync-shared.sh` (install/refresh step), `.claude/hooks/pre-commit` (provenance marker line only), one new suite under `logs/scripts/`, this state file. Excluded: adopting the workspace-root stale hook, touching either project-owned hook, health validation, legacy tracked-link cleanup, docs, downstream repos, branch operations.

Failing case that proves the gap: in a manifest-bearing fixture with no installed hook, run the real generator (creates links + block), `git add -f` a block-covered generated symlink, commit — it succeeds today; after the change the same sequence must fail with the Guard 3 message. Regression checks that can fail: install-when-absent; no-op-when-identical (bytes and mtime unchanged); refuse-and-report on a symlink hook; refuse-and-report on a marker-less body; refresh on a marker-bearing stale body; **worktree case** — install from the main checkout, commit from a linked worktree, guard fires; fail-open on a non-repo project dir and on an unwritable hooks dir (exit 0, session unaffected); idempotency across two consecutive runs; existing A–F suite and the generated-guard suite still pass; `bash -n` on every changed shell file.

## Blocker

None.

## Next action

Codex: reframe Unit 5 from this recommendation — `auto-sync-shared.sh` as sole install/refresh owner, provenance-marker gating, report-don't-overwrite for the marker-less workspace-root copy and the two project-owned symlink hooks.

Current task position: Units 1–3 accepted; Unit 4 discovery complete and implements nothing. Remaining adjacent scope: the installer implementation above, then health validation, the workspace-root stale-hook adoption decision, legacy tracked-link cleanup, and the two stale documentation claims. Branch state reported separately and not reconciled: local `main` is ahead of `origin/main` by 13 and behind 1 (`3e7789cd`, another author) before the commit carrying this hand-back.
