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

### Unit 4 correction (2026-08-17) — the two frozen findings; still read-only, nothing implemented

**Finding 1 — per-surface coverage, reconciled. One surface of 30 has no route; the sole-owner recommendation survives, with a stated precondition.**

The 43-vs-41 gap was never a surface gap in itself: registration is per *checkout*, coverage is per *surface*, and several surfaces are reached by more than one checkout. Mapping every checkout to its executing surface and testing its own `.claude/settings.json` and `.claude/settings.local.json` for the `auto-sync-shared` entry gives 41 registered / 2 not. The two unregistered checkouts resolve differently:

| Unregistered checkout | Executing surface | Also reached by | Verdict |
|---|---|---|---|
| `projects/repo-documentation/vault` | `projects/repo-documentation/.git/hooks` | `projects/repo-documentation` (registered) | **covered** — the surface has a route |
| `projects/strategy-os` | `projects/strategy-os/.git/hooks` | nothing else | **uncovered** — sole checkout, no route |

So **29 of 30 surfaces have at least one real SessionStart route; one does not.** The user-level `~/.claude/settings.json` carries no `auto-sync-shared` entry (grep count 0), so nothing supplies the missing route from above.

`projects/strategy-os` is a settings-drift defect, not a design gap. Its `.claude/settings.json` *does* carry a `SessionStart` array, but with only the `check-permission-sanity.sh` walk-up entry; the second entry that `templates/project-settings.json.template:38` defines — the identical walk-up to `auto-sync-shared.sh` — is absent. It is an active project (last commit 2026-08-16) that already holds a `shared-manifest.json` and 9 generated command symlinks, so it is genuinely in the population this task protects.

This does not revise the owner, because **no candidate reaches it either**: `/new-project` fires only at creation, which is already past; `/sync-workflow` is `TEMPLATE_DIR`-scoped and strategy-os is not a workflow deployment; `/deploy-workflow` excludes `pre-commit` outright. A second owner would add policy surface and still leave this checkout uncovered. The honest statement of reach is therefore narrower than the original claim: **`auto-sync-shared.sh` reaches every surface where it is registered, and registration is today complete for 29 of 30.** Restoring the missing entry is a one-line settings repair in a downstream project — outside this unit's scope, and the existing `/permission-sweep` + `check-permission-sanity.sh` machinery is the standing owner of exactly this drift class.

Two consequences carried into the next unit: the installer must not claim or log workspace-wide coverage it cannot have (it installs only where it runs), and the unit should emit the uncovered-checkout signal rather than assume it away — a manifest-bearing checkout whose settings lack the registration is invisible to the installer by construction.

**Finding 2 — first-marker transition for the installed `ai-resources` copy: an exact-digest ancestor allowlist with one entry.**

The problem is real as stated: adding a provenance marker to the tracked body makes the currently installed copy simultaneously marker-less and different, which rule (e) refuses to touch — the very copy Unit 3 installed would freeze at the pre-marker body.

Measured digests (SHA-256, first 16 hex):

| File | Digest | Bytes |
|---|---|---|
| tracked `.claude/hooks/pre-commit` (current, = `638ab8cc`) | `6c75cb196970bf1d` | 10217 |
| installed `ai-resources/.git/hooks/pre-commit` | `6c75cb196970bf1d` | 10217 |
| installed workspace-root `.git/hooks/pre-commit` | `6fd8b544feaf150a` | 6243 |

Transition: the classifier gains one bounded rule — refresh when the installed body's SHA-256 is an exact member of an explicitly enumerated set of known pre-marker canonical digests. At introduction that set has **exactly one member, `6c75cb19…`**, the digest of the tracked body at `638ab8cc`, which is bit-for-bit the copy Unit 3 installed.

Why exact digest rather than any marker-adjacent heuristic — and this is the evidence that forces it: the workspace-root installed body's **first 8 lines are byte-identical to the canonical body** (`diff` of the two heads is empty). Any header test, provenance-substring test, or "looks like our hook" heuristic classifies that 6243-byte body as canonical and overwrites it. Exact digest equality cannot: `6fd8b544…` is not the allowlisted value, so rule (e) catches it and it is reported, not touched.

Ordering is load-bearing and must be specified, not left to the implementation: **test `[ -L ]` before `[ -f ]`.** Both project-owned hooks are symlinks pointing at existing regular files, so `[ -f ]` follows the link and returns true for them; a `-f`-first classifier would read `boundary-leakage-check.sh` and `check-case-boundary.sh` as ordinary bodies and fall through to the digest comparison. Symlink → report and stop, always first.

The rule is self-limiting rather than an ongoing heuristic: it matches exactly one dead byte-sequence. Once the first run refreshes that copy, no live file matches it again — the entry can be frozen in place or dropped in a later unit, and it can never match a future body. Blast radius at introduction is at most one surface, `ai-resources/.git/hooks/pre-commit`, which this task installed itself. Snapshot-before-overwrite applies to this path as it does to every write.

Added to the smallest-next-unit scope, with failing regression cases: a fixture carrying the pre-marker body (`git show 638ab8cc:.claude/hooks/pre-commit`) must end the run holding the new marker-bearing body and still commit normally; a fixture carrying the workspace-root body must end the run **byte-unchanged** with a report line emitted; a fixture whose hook is a symlink to a working guard must end byte-unchanged with the guard still executing. All three can fail.

## Blocker

None.

## Next action

Codex: closure check on the two frozen findings only — (1) per-surface coverage reconciled at 29/30 with `projects/strategy-os` named as an uncovered settings-drift surface and the owner recommendation unrevised, (2) first-marker transition specified as a one-entry exact-digest ancestor allowlist with symlink-first ordering, both folded into the smallest-next-unit scope and regression plan.

Current task position: Units 1–3 accepted; Unit 4 discovery corrected once and still implements nothing. Remaining adjacent scope: the installer implementation, the `projects/strategy-os` registration repair, health validation, the workspace-root stale-hook adoption decision, legacy tracked-link cleanup, and the two stale documentation claims. Branch state reported separately and not reconciled: local `main` is ahead of `origin/main` by 14 and behind 1 (`3e7789cd`, another author) before the commit carrying this correction.

1. Reconcile the coverage evidence behind the sole-owner recommendation. The result identifies 43 manifest-bearing checkouts and 30 distinct executing hook surfaces, but only 41 `settings.json` registrations while claiming `auto-sync-shared.sh` reaches every surface. Map the two unregistered checkouts to their executing surfaces and prove that each of the 30 surfaces has at least one real SessionStart route that runs this hook; if any surface lacks one, revise the recommendation and smallest next unit accordingly.
2. Resolve the first-marker transition for the currently installed `ai-resources/.git/hooks/pre-commit`. Unit 3 established that it is byte-identical to commit `638ab8cc`, but adding a provenance marker to the tracked body would immediately make that installed copy marker-less and different, which the proposed policy refuses to refresh. Specify a bounded, evidence-backed transition that updates this known canonical copy without creating a heuristic that could overwrite the marker-less workspace-root body or either project-owned symlink hook. Carry the resulting transition and its failing regression case into the smallest-next-unit scope.

Correction scope is state-file-only discovery. Do not implement, install, refresh, or edit any hook, command, template, setting, documentation, or downstream project. Commit the corrected hand-back, set `turn: codex`, and return for the closure check of these two findings only.
