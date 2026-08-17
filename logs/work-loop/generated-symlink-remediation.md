---
task: generated-symlink-remediation
status: active
turn: codex
---

## Objective and scope

Make manifest-managed shared-resource symlinks checkout-local generated products: canonical manifests and project-owned resources remain tracked, while generated destinations are ignored locally, later guarded from staging, and verifiably regenerable at different checkout depths.

This task is limited to the canonical mechanism and regression protection owned by `ai-resources`. The legacy-branch untracking rollout, branch merges or rebases, conflict resolution, pushes, and unrelated symlink systems are excluded; they require a later task in the repository that actually holds the named branches.

Task exit condition: the canonical generated-path calculation is shared by synchronization, local exclusion, staging prevention, and health validation; representative normal and nested-checkout behavior is proven. Units 1–4 have established synchronization, checkout-local exclusion, the canonical commit-boundary guard, and the installation/refresh ownership boundary. Versioned installation/refresh and health validation remain.

## Lane and unit

Standard. Implementation mode. Unit 5 — generated-guard installation and refresh.

Named reason for the loop: this load-bearing SessionStart mechanism spans multiple bounded units, and its implementation must be independently assessed before it counts as complete.

## Brief

Unit 4 is accepted: `auto-sync-shared.sh` is the single safe owner for installing the generated-path pre-commit guard wherever that SessionStart hook actually runs. This unit implements that accepted boundary without claiming workspace-wide rollout; health validation remains the next task-level gap.

Required outcome: extend the canonical SessionStart synchronization path so a manifest-bearing checkout gets the canonical `.claude/hooks/pre-commit` body at its actual executing Git hook path, and receives safe idempotent refreshes of known canonical copies, while symlink hooks and unclassified regular hooks remain byte-untouched and visibly reported.

Authority and source disposition:

- Governing: the task objective; accepted commits `2aedc455`, `125cfc39`, and `638ab8cc`; and the accepted Unit 4 discovery/correction in state commit `22c0079d`.
- Settled implementation decision from Unit 4: `.claude/hooks/auto-sync-shared.sh` owns installation and refresh beside its managed-exclude write; `.claude/hooks/pre-commit` gains one stable provenance marker; the first-marker transition recognizes only the full SHA-256 of the exact pre-marker canonical body at `638ab8cc`; symlinks are classified before regular files.
- Verify-first repository claims: (1) `auto-sync-shared.sh` still finds the canonical `ai-resources` tree, resolves the current checkout's Git-local exclude path, and aggregates warnings through `hookSpecificOutput.additionalContext`; (2) the tracked pre-commit body at `638ab8cc` yields the exact full digest intended for the one-entry ancestor allowlist—the abbreviated digest in Unit 4 is not sufficient for implementation; (3) `git rev-parse --git-path hooks/pre-commit` identifies the executing common hook surface for both ordinary repositories and linked worktrees; and (4) the current tracked hook still lacks the proposed provenance marker. Check the named files and bounded fixture behavior before editing; a false claim is a valid hand-back.
- Codex framing decision: keep one dominant deliverable—safe installer/refresh behavior plus its focused regression suite. The `projects/strategy-os` registration drift cannot be observed by a hook that never runs and remains a separate `/permission-sweep`-owned repair; this unit must scope any success message to the current checkout and must not claim 30/30 workspace coverage.

Required behavior, preserving the accepted collision boundary:

1. Resolve the current checkout's executing pre-commit path through Git, including the shared common hook directory used by linked worktrees. Do not construct `.git/hooks` from directory nesting.
2. Classify a symlink before any regular-file test and never follow, replace, or chmod it. Report the preserved collision through the existing SessionStart additional-context output.
3. Install when absent and make the installed copy executable. If the installed bytes are identical to canonical, leave both bytes and mtime unchanged.
4. Refresh a differing regular body only when it carries the stable canonical provenance marker or its full SHA-256 exactly matches the single known pre-marker ancestor from `638ab8cc`. Keep that ancestor set explicitly bounded to one entry.
5. Treat every other marker-less regular body as project-owned: leave bytes and mode untouched and report it. The known workspace-root stale body must remain in this class.
6. Make refresh failure-safe: an unsuccessful write must preserve or recover the prior installed body. The SessionStart hook remains fail-open for lookup, permission, or write failures and must not prevent a session from starting.
7. Keep installation policy beside the managed-exclude owner; do not create a general hook manager or re-interpret the manifest-generated destination set.

Scope and exclusions:

- In scope: `.claude/hooks/auto-sync-shared.sh`, a provenance-marker-only change to `.claude/hooks/pre-commit`, one focused installer regression suite under `logs/scripts/`, and this state file.
- Tests must operate in disposable fixtures. Do not install or refresh a live `.git/hooks/pre-commit` in this checkout, the workspace root, or any downstream project as part of this unit.
- Excluded by Codex framing: the `projects/strategy-os` settings repair; adoption of the marker-less workspace-root hook; composition or replacement of the two project-owned symlink hooks; health-check implementation; documentation corrections; legacy tracked-link cleanup; downstream writes; and branch, merge, rebase, or push operations.

Capability subset: baseline only—repository reads and history inspection, disposable local fixtures, local tests, edits within the four scoped tracked paths, and Claude-owned local commits. Nothing is selected from the pre-authorizable set, which is empty today. No network, live hook installation, downstream write, push, merge, rebase, credential access, destructive shared-state action, or operator-reserved capability is authorized.

Evidence required:

1. Failing-before/passing-after integration: in a disposable manifest-bearing repository with no installed hook, the real generator creates its links and managed exclude block; before the installer change a force-added generated destination can commit, while after the change the installed guard blocks it, names the path, and leaves HEAD unchanged.
2. One focused collision suite whose assertions can fail: absent installs executable; identical is a byte-and-mtime no-op; marker-bearing stale refreshes; the exact full pre-marker `638ab8cc` body refreshes to the new marker-bearing body; the measured workspace-root stale body fixture remains byte-unchanged and is reported; and a symlink to a working project guard remains unchanged with its target guard still executable.
3. Path and failure behavior: a linked-worktree fixture resolves to and uses the common hook surface; a non-repository project and an unwritable or forced-write-failure fixture exit successfully without corrupting an existing hook; two successful runs are idempotent.
4. Regression protection: `logs/scripts/auto-sync-shared-excludes.test.sh`, `logs/scripts/pre-commit-generated-guard.test.sh`, the existing pre-commit A–F suite, the new focused suite, and `bash -n` for the changed shell files all pass. Do not rerun unrelated suites.
5. Report the exact changed-file list and commit id. Report branch divergence separately and do not reconcile it.

Completion condition: implement the accepted installer/refresh boundary, prove the failing case and relevant regression behavior in disposable fixtures, commit the scoped changes plus this state record, set `turn: codex`, and hand back for assessment.

Stop and hand back if a verify-first claim is false; if the exact full ancestor digest cannot be established from `638ab8cc`; if safe classification would require a heuristic broader than exact marker or exact digest; if required evidence would need a live hook or downstream write; if any project-owned hook would be overwritten; or if the change requires a new deployment owner, broader authority, or scope outside this brief.

## Latest result

Inspected (2026-08-17):

- Claim (1): HOLDS — read `.claude/hooks/auto-sync-shared.sh` end to end. The canonical-tree walk is at lines 48–58 (`$d/ai-resources/.claude/commands`); the Git-local exclude path is resolved at line 123 via `git rev-parse --git-path info/exclude`, with relative answers re-anchored to `$PROJECT_DIR` at lines 124–128; warnings are aggregated into one `hookSpecificOutput.additionalContext` payload at lines 329–353.
- Claim (2): HOLDS — `git show 638ab8cc:.claude/hooks/pre-commit | shasum -a 256` returns the full digest `6c75cb196970bf1d4867167b93dc82cf39ae6d85191a8b20f7f51681f5f5c3f5`. `git log --oneline 638ab8cc..HEAD -- .claude/hooks/pre-commit` is empty, and the HEAD blob plus the pre-edit worktree copy both carry that same digest, so the pinned ancestor is unambiguous.
- Claim (3): HOLDS, without qualification. `git rev-parse --git-path hooks/pre-commit` returned `.git/hooks/pre-commit` at an ordinary repo root, `../../.git/hooks/pre-commit` from a subdirectory (relative to the git invocation's cwd, matching the existing exclude-path handling), and the main checkout's `.git/hooks/pre-commit` from a linked worktree — the shared common surface, as claimed. **My first pass recorded a `core.hooksPath` qualification here; that qualification was false and Codex was right to reject it — see the correction below.**
- Claim (4): HOLDS — searched the tracked `.claude/hooks/pre-commit` for a provenance marker with `grep -niE 'auto-sync-shared|canonical|provenance|managed'`. Every hit was functional Guard 3 code or comment prose (lines 49, 66–83, 103, 105); no stable single-line provenance marker existed.

Correction round (2026-08-17) — frozen finding 1, reproduced then resolved:

- Finding 1: CONFIRMED by inspection in a disposable repository, in all three parts. (a) `git rev-parse --git-path hooks/pre-commit` already honours `core.hooksPath`: with `core.hooksPath=custom-hooks` it returned `custom-hooks/pre-commit` from the root and `../custom-hooks/pre-commit` from a subdirectory, and with an absolute override it returned that absolute path. My manual branch was therefore not merely redundant but the only thing that could get it wrong. (b) With `core.hooksPath='~/guard-hooks'` and `HOME` redirected into the fixture, Git resolved `<fixture-home>/guard-hooks/pre-commit` while the manual branch constructed `<repo-top>/~/guard-hooks/pre-commit` — a literal `~` directory. (c) I then put an executable hook at *both* candidate paths and committed: only `TILDE-EXPANDED HOOK RAN` printed, and HEAD stayed at `none`. So the manual branch would have installed the guard where Git never executes it, and silently created a stray `~` directory in the repository. The claim-(3) qualification I recorded was wrong, and the gap in my own inspection was measuring `--git-path` only in fixtures where `core.hooksPath` was unset.

Resolution: the manual `core.hooksPath` branch is deleted. The resolver is now the single `git rev-parse --git-path hooks/pre-commit` call the brief originally required, keeping the existing relative-answer anchoring to `$PROJECT_DIR` — which covers a relative `core.hooksPath` as well as the default, since Git returns a relative answer for both. The comment records the measured tilde divergence so the branch is not reinstated. Nothing else changed: collision policy, provenance rules, atomic write, fail-open, worktree and idempotency behavior are untouched, and no message wording changed beyond removing the dead branch.

New regression (frozen finding's second half): case C5 covers a relative and an absolute `core.hooksPath`, asserting the guard installs into that directory and **not** at the default `.git/hooks`. Case C6 covers the tilde form with `HOME` redirected inside the fixture — it asserts Git's own expansion is the install target, that no literal `~` directory is created, that nothing lands at the default path, and that the installed guard actually **executes**, refusing a force-added generated destination with HEAD unmoved.

The new cases are shown able to fail: reinstating the buggy manual branch as mutation 6 produces 5 failures, including `nothing was written under a literal '~' directory` and `the tilde-path guard actually executes and blocks the commit`. Clean tree returns `pass=59 fail=0 skip=0`.

Correction breakage check: the frozen finding's required set all passes — `auto-sync-shared-excludes` (16), `pre-commit-generated-guard` (8), `pre-commit-hook` (ALL ARMS PASS, A–F), the Unit 5 suite (59), and `bash -n` on all three changed shell files. No unrelated suites were rerun. Live surfaces re-verified byte-identical afterwards: this checkout's installed hook still `6c75cb19…`, the workspace root's still `6fd8b544…`, and no literal `~` directory exists in the checkout.

Result: Unit 5 is implemented, with frozen finding 1 corrected. `auto-sync-shared.sh` installs and refreshes the canonical pre-commit body at the executing hook path Git itself reports, beside its managed-exclude write, and `.claude/hooks/pre-commit` carries one stable provenance marker. Classification is symlink-first and never follows, replaces or chmods a link; a differing regular body is refreshed only on the exact marker or the single pinned pre-marker digest; every other marker-less body is left byte-and-mtime untouched and reported under a `GENERATED-GUARD:` prefix scoped to "this checkout only". Writes are staged in a sibling temp file and renamed, so a failed write cannot corrupt an installed hook, and every failure path exits 0. No live hook, downstream project or setting was written: the four changed paths are `.claude/hooks/auto-sync-shared.sh`, `.claude/hooks/pre-commit`, the new `logs/scripts/auto-sync-shared-guard-install.test.sh`, and this state file.

Evidence:

1. Failing-before / passing-after, in disposable manifest-bearing fixtures driven by the real generator. Before: the pinned pre-installer generator at `638ab8cc` installs nothing at the executing path, and a force-added generated destination **commits**. After: the guard is installed and executable, byte-identical to canonical, an ordinary commit still succeeds, and the same force-add is **blocked** with `.claude/commands/sharedcmd.md` named and HEAD unmoved. Both legs are assertions in the new suite, so the gap stays measured rather than remembered.
2. `logs/scripts/auto-sync-shared-guard-install.test.sh` — 49 assertions, `pass=49 fail=0 skip=0`. Covers absent-installs-executable; identical is a byte-**and**-mtime no-op (mtime backdated first, so a rewrite is visible); marker-bearing stale refreshes; the exact `638ab8cc` body refreshes to the marker-bearing body, with fixture-sanity assertions that it is marker-less, that its digest is the one the installer pins, and that the allowlist holds exactly one entry; a symlink to an unrelated project guard survives with its target unchanged and still executable; and a canonical body stripped of its marker installs nothing.
3. The measured workspace-root stale body is used as a real fixture, not an imitation: that body is the tracked pre-commit at `3878b4de` (digest `6fd8b544…`, 6243 bytes) — this repository's own older canonical lineage, marker-less and **not** the pinned ancestor. It stays byte-and-mtime unchanged and is reported as project-owned. A header-similarity heuristic would have overwritten it, which is why the ancestor set is one exact digest.
4. Path and failure behavior: a linked-worktree fixture installs to the shared common hook surface, does **not** write the worktree's private gitdir, and the worktree's own force-add is blocked with HEAD unmoved; a non-repository project exits 0 and fabricates no hook; a `chmod 555` hook directory (a real forced write failure, not a test-only switch in the hook) exits 0, leaves the existing body byte-identical, leaves no temp file behind, and reports; two successful runs are byte- and mtime-idempotent.
5. The evidence is shown able to fail. Five mutations of the installer were each run against the suite: disabling symlink-first classification, widening refresh to any marker-less body, dropping the atomic temp-file staging, removing the canonical-marker precondition, and forcing the identical case to rewrite. Two initially went undetected and the suite was strengthened rather than the claim softened — B6's report assertion had matched the word "symlink" inside unrelated guard wording, and no fixture made a symlink bypass destructive, so a tightened collision-wording assertion plus case B7 (a symlink over a marker-bearing target, where only the ordering saves the link) and case B8 (marker-less canonical) were added. All five mutations are now caught: 4, 3, 11, 2 and 2 failures respectively; the clean tree returns 49/49.
6. Regression set, all passing: `auto-sync-shared-excludes.test.sh` (16), `pre-commit-generated-guard.test.sh` (8), `pre-commit-hook.test.sh` (ALL ARMS PASS, A–F), the new suite (49), and `bash -n` on all three changed shell files. No unrelated suites were rerun.
7. Live surfaces re-verified byte-identical to the pre-work survey after all testing: this checkout's installed hook still `6c75cb19…`, the workspace-root's still `6fd8b544…`, and both project-owned symlinks (`axcion-pitch-engine`, `axcion-website`) still symlinks to their original targets.

Commits: `cd959ac2` and `e0cf0ef0` (implementation), `{CORRECTION}` (this correction). Changed by the correction: `.claude/hooks/auto-sync-shared.sh`, `logs/scripts/auto-sync-shared-guard-install.test.sh`, and this state file — `.claude/hooks/pre-commit` was not touched. Branch divergence is reported, not reconciled: `main` is ahead 17 / behind 1 against `origin/main`.

Observation Codex should carry into the closure check, not a deferral: because canonical now carries the marker while this checkout's installed copy is still the pinned ancestor, the next SessionStart in `ai-resources` will refresh that installed copy through the one-entry transition. That is the designed first-marker path and its fixture is case B4; this unit deliberately did not perform it live.

Noticed during the correction and recorded as a deferral, not implemented: the five earlier installer mutations (symlink-first ordering, widened refresh, non-atomic write, missing canonical-marker precondition, rewritten identical case) were verified caught before the correction, and were not re-verified after it, because the frozen scope limited the rerun to the Unit 5 suite and its required regression set. Those legs of the suite were not edited by this correction.

Deferrals noticed during this unit and not done:

- The aggregated `additionalContext` payload is assembled by string interpolation into JSON, so a path containing a double quote or backslash would produce malformed JSON. Pre-existing in every message this hook already emits; my new messages embed paths on the same path. Not fixed here because it is a change to the reporting seam shared by all five message kinds, outside this brief's scope.
- `auto-sync-shared-excludes.test.sh` and `pre-commit-generated-guard.test.sh` are mode 644 while most sibling scripts in `logs/scripts/` are 755. Harmless — all are invoked as `bash <path>` — and the new suite is left 644 for consistency with its two siblings rather than fixed here.

Deferrals carried from Unit 4 remain outside Unit 5 and unchanged: the `projects/strategy-os` registration repair, workspace-root stale-hook adoption, project-owned hook composition, legacy cleanup, and the two stale documentation claims. Health validation remains inside the overall task and is the next task-level gap.

## Blocker

None.

## Next action

Codex: run the closure check on frozen finding 1 only — is the resolver now Git's own `--git-path` answer with the non-default-path regression in place, and did the correction break anything? The rerun was limited to the Unit 5 suite and its required regression set, all passing.

Superseded — the frozen findings this round corrected:

1. Replace the manual `core.hooksPath` branch with Git's own resolved hook-path result, and add the missing non-default-path regression. The implementation's claim-(3) qualification is false: a disposable repository showed `git -C <root> rev-parse --git-path hooks/pre-commit` returning `custom-hooks/pre-commit`, the same call from a subdirectory returning `../custom-hooks/pre-commit`, and an absolute override returning the absolute hook path. More importantly, with `core.hooksPath='~/guard-hooks'`, Git expanded the executing path to `/Users/patrik.lindeberg/guard-hooks/pre-commit`, while the current manual branch constructs `<repo-top>/~/guard-hooks/pre-commit`. That can install the guard somewhere Git will never execute it. Resolve through `git rev-parse --git-path hooks/pre-commit` as the brief originally required, retain the existing relative-answer anchoring, and add a disposable fixture with `HOME` redirected inside the fixture proving a non-default `~/...` hooks path installs exactly at Git's reported path and never under a literal `~` directory. Preserve the accepted collision, atomic-write, fail-open, worktree, and idempotency behavior; rerun only the Unit 5 suite and its already-required regression set.

Correction scope is frozen to this resolver and its regression. Do not change collision policy, provenance rules, messaging beyond what the test requires, live hooks, downstream settings, health validation, documentation, legacy cleanup, or branch state. Commit the correction and this state record, set `turn: codex`, and return for the closure check of this finding only.
