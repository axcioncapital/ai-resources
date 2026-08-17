---
task: generated-symlink-remediation
status: active
turn: codex
---

## Objective and scope

Make manifest-managed shared-resource symlinks checkout-local generated products: canonical manifests and project-owned resources remain tracked, while generated destinations are ignored locally, later guarded from staging, and verifiably regenerable at different checkout depths.

This task is limited to the canonical mechanism and regression protection owned by `ai-resources`. The legacy-branch untracking rollout, branch merges or rebases, conflict resolution, pushes, and unrelated symlink systems are excluded; they require a later task in the repository that actually holds the named branches.

Task exit condition: the canonical generated-path calculation is shared by synchronization, local exclusion, staging prevention, and health validation; representative normal and nested-checkout behavior is proven. This unit advances only the synchronization and local-exclusion part.

## Lane and unit

Standard. Discovery mode. Unit 2 — staging-control integration boundary.

Named reason for the loop: this load-bearing SessionStart mechanism spans multiple bounded units, and its implementation must be independently assessed before it counts as complete.

## Brief

Unit 1 is accepted: the generator now owns an exact local-exclude block and its regression suite proves the intended behavior. The task still requires staging prevention, but the repository currently exposes several possible control surfaces with materially different deployment reach; this discovery unit resolves that boundary before any guard is built.

Named unknown: what single versioned enforcement surface can prevent a manifest-managed generated destination from re-entering Git in downstream project checkouts, while consuming the generator's exact path interpretation rather than recreating it?

Authority and source disposition:

- Governing: the task objective and accepted Unit 1 repository state at commit `2aedc455`.
- Applicable repository contracts: `.claude/hooks/auto-sync-shared.sh`, `.claude/hooks/pre-commit`, `.claude/hooks/check-foreign-staging.sh`, `templates/project-settings.json.template`, `docs/commit-discipline.md`, and their directly named deployment consumers.
- Non-governing background: the remediation report's suggestion to use a pre-commit or pre-tool guard; it does not settle which surface is actually deployed.
- Codex framing decision: this unit is read-only discovery. It excludes guard implementation and health validation because the enforcement/deployment boundary is still load-bearing and uncertain.

Inspect and return evidence for these questions:

1. Which versioned hook or guard bodies can observe explicit-path staging, force-adds, wide adds, and commits in a downstream manifest-managed project? For each candidate, trace its repository-owned wiring and deployment route rather than assuming a file fires because it exists.
2. Establish from repository sources whether `.claude/hooks/pre-commit` is installed into downstream repositories, whether Claude Code executes it merely because it exists, and whether that behavior is portable beyond this machine. Treat user-level wiring described in `docs/commit-discipline.md` as machine-local unless a versioned consumer proves otherwise; do not read user credentials or settings outside the repository.
3. Establish what `.claude/hooks/check-foreign-staging.sh` deliberately does and does not gate, especially explicit-path `git add`, combined add-and-commit commands, and already-staged paths. Do not propose weakening its existing concurrent-session contract.
4. Determine how a guard can consume the exact generated-destination set produced by Unit 1 without duplicating manifest/exclusion logic and without triggering synchronization or local-exclude mutation as a side effect. If the current hook exposes no safe read-only query surface, state that precisely and identify the smallest interface an implementation unit would need.
5. Distinguish the minimum required guarantee—generated managed destinations cannot be committed—from stronger staging-time guarantees that the available versioned surfaces may not be able to enforce. Identify the narrowest failure case that must go red before the later implementation and green afterward.
6. Recommend exactly one next implementation unit, naming its files, deployment reach, evidence, known limits, and why it is preferable to the nearest alternative. If no versioned cross-project control can enforce the guarantee safely, return that capability gap instead of choosing an ungrounded architecture.

Boundary: read/search/inspect only, plus updating and committing this state file for the hand-back. Do not edit hook bodies, settings, templates, docs, tests, Git configuration, branches, or project files. Do not merge, rebase, push, force-add, or alter the existing Unit 1 commit.

Capability subset: baseline read/search/history inspection and Claude-owned commit of this state-file hand-back only. Nothing is selected from the pre-authorizable set, which is empty today. No network, external settings inspection, credential access, branch mutation, deployment, or other operator-reserved capability is authorized.

Evidence required: a concise candidate/control table grounded in repository paths and call sites; the current generated-path reuse seam or proven absence from a named searched surface; one recommended implementation boundary with a falsifiable regression case; and the state-file-only commit id. Separate verified repository facts from design recommendations.

Completion condition: resolve the named unknown with repository evidence, recommend one bounded implementation unit or report the capability gap, set `turn: codex`, commit only the state-file hand-back, and stop. Do not implement the guard.

Stop and hand back if the authoritative deployment route depends on inaccessible machine-local state, if repository sources materially conflict, or if the recommended control would require expanding the task's capability envelope or weakening an existing guard.

## Latest result

Unit 2 discovery — staging-control integration boundary. All findings by inspection (2026-08-17); verified repository facts first, design recommendation last.

Inspected (2026-08-17) — candidate/control table (Q1–Q3):

| Surface | What it can observe | Versioned wiring found | Reach today |
|---|---|---|---|
| `.claude/hooks/pre-commit` (git-hook body, tracked) | the final staged index on every `git commit`, regardless of staging route — explicit add, `add -f`, wide add, combined `add && commit` — from any terminal or tool | none: no installer in `.claude/commands/`, `templates/`, or `docs/` (searched `hooks/pre-commit`, `core.hooksPath`, `.git/hooks`); install is the header's manual "copy to `.git/hooks/`" | machine-local: installed in `ai-resources/.git/hooks/` and workspace-root `.git/hooks/` (both verified by `ls`); downstream projects unestablished, no versioned route |
| `.claude/hooks/check-foreign-staging.sh` (PreToolUse Bash body, tracked) | Claude-session Bash commands only: `git commit` (incl. `--amend`, `-a`) and wide adds (`-A/--all/-u/.`) | **registered in no settings layer** — searched `ai-resources/.claude/settings.json` (PreToolUse runs only `check-heavy-tool.sh`), workspace-root `.claude/settings.json`, `templates/project-settings.json.template`: absent from all; `docs/compaction-protocol.md:25` states the same ("registered in no settings layer and guards nothing") | none — dormant body |
| `templates/project-settings.json.template` (deployed by `/new-project`, `/deploy-workflow` per `templates/README.md`) | whatever hooks it declares, in Claude sessions of consuming projects | SessionStart only (auto-sync + permission sanity); no PreToolUse entry | the only versioned settings route into downstream projects, currently carrying no staging control |

Q2 — `.claude/hooks/pre-commit` deployment truth: git executes `.git/hooks/pre-commit`; nothing versioned installs it. The header's claim "Or: create `.claude/hooks/pre-commit` and Claude Code picks it up" has **no versioned consumer** — searched settings layers and docs; `docs/harness-and-permission-troubleshooting.md:199-205` documents only the `.git/hooks/` route and warns the hook's success message is not evidence the skill check ran. User-level wiring described in `docs/commit-discipline.md` treated as machine-local per brief; not read.

Q3 — `check-foreign-staging.sh` contract (from its body + `docs/commit-discipline.md:39-57`): gates commits and wide adds against the session footprint; **deliberately does not gate explicit-path `git add`** (body line 36, "explicit, low-risk"); the commit arm sees the **pre-command index**, so combined `git add <path> && git commit` passes ungated (verified by execution 2026-08-01 per commit-discipline.md:57) — and this repo's own single-step commit convention prescribes exactly that shape; already-staged paths are judged against the session footprint, not generated-ness. Its monotonic fail-open/P3 concurrent-session contract is orthogonal to this task; not proposed for weakening.

Q4 — generated-path reuse seam (verified): the generator exposes its exact set in precisely one durable place — the marked block between `EXCL_BEGIN`/`EXCL_END` in the file `git rev-parse --git-path info/exclude`, rewritten each SessionStart in lockstep with link creation. The hook has no argument/query interface (no positional-parameter handling in the body). Reading the block is side-effect-free and duplicates no manifest/exclusion logic; both marker strings are static single-line literal assignments in the hook, so a consumer can sed-extract them exactly as `/fix-symlinks` re-reads `EXCLUDE_COMMANDS` (same format contract). If block-reading were rejected, the smallest needed interface would be a read-only `--list-generated` query mode added to the hook; not required by the recommendation below.

Q5 — guarantee split (grounded by scratchpad experiment in a throwaway fixture, 2026-08-17): with a block-covered symlink, plain `git add <path>` is already **refused by git** (exit 1, "paths are ignored", nothing staged) and wide adds skip it — Unit 1 closed the ordinary routes. `git add -f <path>` stages it and `git commit` **succeeds today** (exit 0, symlink in the commit). Staging-time enforcement is not achievable by any versioned git surface (git has no pre-add hook; PreToolUse covers only Claude-issued commands and is unregistered). The minimum guarantee — block-covered destinations cannot be **committed** — is enforceable at pre-commit. **Narrowest failure case: `git add -f <block-covered path> && git commit` exits 0 today; after implementation the commit must fail naming the path.**

Recommendation (design, not fact) — Unit 3, Implementation mode: extend the tracked `.claude/hooks/pre-commit` integrity-guards section with Guard 3 — reject any staged path listed in the managed block of `git rev-parse --git-path info/exclude`, marker strings sed-extracted from the canonical `auto-sync-shared.sh` (no duplicated literals or path logic). Files: `.claude/hooks/pre-commit`, new `logs/scripts/pre-commit-generated-guard.test.sh` (reuse the Unit-1 fixture family), plus re-install of the local `.git/hooks/pre-commit` copy in this checkout. Evidence: the red/green case above plus normal-commit non-interference and `bash -n`. Deployment reach: enforced wherever the body is installed — today ai-resources and workspace root on this machine; downstream distribution needs an install/refresh route that does not exist versioned (candidate owners: `auto-sync-shared.sh` SessionStart install step or `/sync-workflow`) — that is a separate decision for a later unit, named as a known limit, not smuggled in. Known limits: `git commit --no-verify` bypasses (consistent with every existing guard, OP-5 advisory-enforcement posture); tracked legacy symlinks unaffected (excludes never affect tracked files — the excluded later rollout). Preferable to the nearest alternative — registering/extending `check-foreign-staging.sh` — because that surface enforces nothing today (wiring it is a harness-config change, an operator-gated class), covers only Claude-issued commands, deliberately exempts explicit-path adds, and is structurally blind to the narrowest failure case (combined add-and-commit); extending it would also strain the monotonic contract the brief protects.

Deferral candidates recorded, not acted on: (a) `docs/commit-discipline.md` § Foreign-staging tripwire and the hook's own header present the tripwire as a registered, live control while it is wired nowhere — stale-doc correction worth one line in a later unit; (b) the pre-commit header's unsupported "Claude Code picks it up" install claim, same class.

Evidence: the table rows, seam, and guarantee split above each name the file, line, or search that settles them; the searches that establish absence name surface and pattern; the failure-case experiment output could have read differently (a guard firing today would have failed the commit). State-file-only commit id: in the commit carrying this hand-back (no other file changed; `git diff` across brief-named surfaces is empty).

## Blocker

None.

## Next action

Codex: assess the Unit 2 discovery — confirm the boundary resolution and either open Unit 3 (pre-commit generated-destination guard as recommended), reframe, or stop.
