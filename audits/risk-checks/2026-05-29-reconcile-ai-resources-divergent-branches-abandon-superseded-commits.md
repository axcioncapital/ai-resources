# Risk Check — 2026-05-29

## Change

Reconcile ai-resources divergent branches (3 local commits vs 125 incoming). The 3 local commits (0e3b1a1 session-plan STALE-detector; bc61d0b + 38008b1 wrap-session FOREIGN-guard count→delta) are SUPERSEDED by upstream marker-based work (e893a45 marker-aware own-contribution counter; 9f91b2f TOCTOU Phase 2+3 which deleted the session-plan Step 0 routing our STALE-detector patched and replaced logs/session-plan.md with marker-scoped files; 150f145 same-session short-circuit; a95a0b0 FOREIGN<0 discriminator; 2836dfa CONCURRENT/REMNANT/MIXED classifier). Our commits patch deleted/rewritten code — rebasing would produce heavy conflicts and re-inject inferior heuristics competing with the upstream marker system.

Proposed reconciliation steps:
1. Create a `pre-reconcile-backup` branch at current HEAD to preserve the 3 local commits for recovery.
2. Stash the uncommitted trivial prime.md one-line change (removes a hardcoded operator name "(Patrik)" from one prose line; upstream still has it, so the change is not superseded).
3. `git reset --hard origin/main` to discard the 3 superseded local commits and fast-forward local main to match upstream.
4. Re-apply the prime.md "(Patrik)" removal and commit it as a standalone fix on top of upstream.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists

## Verdict

GO

**Summary:** A local-only, fully-recoverable working-state reconciliation: a `reset --hard` over 3 never-pushed superseded commits, gated behind a pre-cut backup branch and a stash, with no push and no contract changes.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content is added to any always-loaded file. The reset adopts upstream's already-authored `session-plan.md` / `wrap-session.md` and the final step re-commits a one-line prose **deletion** in `prime.md` — net token change is negative (removes "(Patrik)" from line 9). Confirmed by the uncommitted diff: `-**Output discipline:** The operator (Patrik) is a non-developer.` → `+**Output discipline:** The operator is a non-developer.`
- No hook is registered, no `@import` chain added, no subagent brief or skill description introduced — the change is purely a git working-state operation plus one prose edit.
- Net effect is to *remove* the 3 local commits' heuristics from the operating set (they are superseded by the marker system already present in the 125 incoming commits), which lowers, not raises, ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` change is described. No `allow`/`ask` entry added, no `deny` rule removed or narrowed, no scope escalation (project → user).
- The operation uses only git plumbing already in routine use in this repo (`/prime` Step 0 runs `git pull`; commits are routine). No new tool family, external API, MCP server, or cross-repo write is introduced.
- `git reset --hard` on **unpushed** commits is not gated by workspace CLAUDE.md Autonomy Rule #1, which scopes the pause to "`reset --hard` on **pushed** commits" (CLAUDE.md § Autonomy Rules, item 1). The `git rev-list` check confirms all 3 commits are unpushed (`@{u}..HEAD` lists exactly 0e3b1a1, bc61d0b, 38008b1).

### Dimension 3: Blast Radius
**Risk:** Low

- Direct artifacts touched: working tree adopts upstream versions of `session-plan.md`, `wrap-session.md`, and `logs/session-plan.md` (replaced by marker-scoped files per 9f91b2f); the local-only audit `audits/risk-checks/2026-05-27-session-plan-stale-committed-detector.md` is discarded from `main` (preserved on backup); `prime.md` gets a one-line prose edit. This is the standard footprint of a fast-forward-by-reset to an already-shared tip.
- Reference counts (total textual mentions across `ai-resources`, `--include="*.md"`): `session-plan` → 134, `wrap-session` → 152, `/prime|prime.md` → 109. These are **mentions, not contract-dependent callers**: the reset does not alter any command's invocation syntax, frontmatter schema, or output shape — it replaces the local versions of these files with upstream's own already-authored versions. No caller requires modification.
- No contract change is introduced by the reconciliation itself. The supersession is the *upstream's* doing (already landed in origin/main and pulled by other machines); this change merely stops the local branch from diverging against it. `grep` for `STALE-detector|FOREIGN-guard|stale-committed` in `ai-resources/logs` returned no log entries that would carry a dangling reference forward.
- origin/main is the shared/authoritative tip other machines already track; bringing local main into line with it *reduces* divergence-induced blast radius rather than widening it.

### Dimension 4: Reversibility
**Risk:** Low

- The 3 discarded commits are fully recoverable by design: Step 1 cuts `pre-reconcile-backup` at current HEAD **before** the reset. Verified no such branch exists yet (`git branch --list pre-reconcile-backup` → empty), so the cut will not collide with a stale ref. Recovery is `git reset --hard pre-reconcile-backup` or cherry-pick.
- The discarded audit file rides on the backup branch, so it too is recoverable; its loss from `main` is intentional and matches the superseded-work rationale.
- The `prime.md` edit is stashed (Step 2) and re-applied (Step 4); `git stash list` is currently empty, so the stash push/pop pair is unambiguous. Even reflog (`HEAD@{n}`) provides a second recovery path independent of the backup branch.
- **No state propagates beyond the local repo.** The change description states "No `git push` occurs this session." Nothing is pushed, no external write (Notion/API/PR) occurs, so rollback never has to chase propagated state. This is the textbook Low-reversibility profile: every step is undoable within the local working tree.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The reconciliation introduces no new contract, parse marker, filename convention, or output format that downstream callers must honor. It is a one-shot git operation, not a mechanism that auto-fires later.
- The one implicit dependency — that the upstream commits genuinely deleted/replaced the exact code the 3 local commits patched — is grounded in upstream commit messages quoted in the change description (9f91b2f: "session-plan Step 0: drops intent-comparison + wrap-state check + auto-pass2 routing"; e893a45: "Replace the binary PRIME_RAN subtractor with a marker-aware ... pair"). This is a single, evidence-backed dependency on an established and already-landed upstream state — within the Low band.
- No functional overlap is *created*; the change *removes* an overlap (the 3 local heuristics competing with the upstream marker system). The marker system is already the live mechanism on origin/main that other machines run, so adopting it removes a divergence, not adds a coupling.
- Ordering note: the sequence is self-protecting — backup branch first, stash second, reset third, re-apply last. No step silently depends on a convention that could shift between now and execution (the backup branch and empty stash were both verified present/absent at review time).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: git state verified live (`git rev-list --left-right --count HEAD...origin/main` → `3 125`; `git log @{u}..HEAD` lists the 3 named commits as unpushed; `git status --short` shows the single `M .claude/commands/prime.md`; `git branch --list pre-reconcile-backup` empty; `git stash list` empty; audit file present via `ls`), the prime.md edit verified via `git diff` (one-line "(Patrik)" removal), reference counts via `grep -rl ... | wc -l`, and supersession claims via verbatim upstream commit-message quotes in CHANGE_DESCRIPTION. No training-data fallback was used on any read.
