---
incident-id: 2026-07-07-strategic-os-main-diverged-from-origin
status: resolved
severity: S2-degraded
risk: Medium
protected-zone-touched: no
---

# Incident — strategic-os `main` diverged from origin (local 3 / origin 20)

## Intake

At `/prime` on 2026-07-07, the auto-pull of `projects/strategic-os` failed: `git pull --rebase --autostash` applied the autostash back cleanly but aborted the rebase at the checkout step ("untracked working tree files would be overwritten by checkout"). Investigation showed local `main` (HEAD `f1b2e0a`) and `origin/main` (`ea7bf1e`) had diverged off common base `b9f42d7` (2026-06-09) — local 3 commits ahead, origin 20 ahead — and never merged. This machine was running the Strategic OS on a pre-operationalization base (missing the 2026-06-15→27 "operationalize OS" line: all 6 live-state elements, founder decisions D1–D7, frameworks KB, settings-portability fixes). Operator selected the reconciliation task at `/prime` and approved the Structural (Option 2) fix.

## Classification

- **Risk:** Medium — reversible, project-scoped git-state recovery. Not in any `audit-discipline.md` structural class (no hook / settings / CLAUDE.md / new-command / new-symlink / shared-state-automation change). The plan avoids every Autonomy-Rule-#1 destructive trigger: `rebase --onto` (not `reset --hard`), dropped commits were never pushed, no branch deletion, move-aside (not `git clean -f`), fast-forward push (no `--force`).
- **Protected zones touched:** none — the fix rewrites local `strategic-os` history and moves 7 **project-local untracked symlinks** aside; it does not edit any shared `ai-resources/` command/agent/doc/hook/settings/CLAUDE.md. The canonical files the symlinks point to are untouched.
- **`/risk-check` verdict:** N/A — risk below High and no protected zone. (Prior `/resolve-repo-problem` triage independently concluded no `/risk-check` needed — git recovery, not infra rewiring. Running it here would stack gates against the CLAUDE.md § Subagent-Proportionality "do not stack gates" rule.)
- **`/consult` second opinion:** N/A — not required (risk < High).

## Diagnosis

**Root cause:** Two divergent lines off one base. `origin/main`'s 20 commits (2026-06-15→06-27) were produced and pushed from a different checkout that operationalized the OS from finalized `inputs/`. **This machine never pulled after `b9f42d7`** and kept committing on the stale base — two 2026-06-09 first-promotions (sourced from an untracked local draft) plus one 2026-07-04 park. The untracked-file collision is a second-order effect of the same gap: origin committed the auto-synced `.claude` symlinks (2026-06-15 `c4a73c2`), while this machine still had them only as untracked working-tree symlinks. Symptom = pull/checkout abort; cause = unpulled divergence + untracked-symlink collision.

**Evidence:**
- `audits/working/2026-07-07-resolve-strategic-os-main-diverged-from-remote.md:75` (root-cause diagnosis, full triage).
- `git merge-base HEAD origin/main` → `b9f42d7`; `git rev-list --left-right --count HEAD...origin/main` → `3  20`.
- `state/live/strategy.md` (origin version): heading `## What Axcíon is` — "an AI-native Nordic M&A intelligence and matchmaking firm … **not a traditional advisory firm**" — a founder-decision-grounded superset that explicitly reframes the local `72bb174` "buy-side advisory firm" wording. Confirms both promote commits are superseded, not unique.
- `ai-strategy/implementation-tracker.md` (park commit): `As-of: 2026-07-04`, Slot 3 "Parked — OVERTAKEN 2026-07-04" — the park's content, verified present in the post-rebase tree; `git log b9f42d7..origin/main -- ai-strategy/{candidate-backlog,implementation-tracker}.md` empty (origin never touched these → zero-conflict replay).

**Alternative causes considered:**
- *Local commits carry unique strategy content (would forbid dropping them)* — rejected: origin's `state/live/strategy.md` and `workstreams.md` are re-authored supersets from finalized `inputs/`; nothing in the local promotes is absent from origin. The only local-unique layer (workstreams project-portfolio status snapshot) is ~1 month stale and sits over the OS's own disowned Strategic-vs-Operational boundary.
- *Force-push / history damage on the shared remote* — rejected: `origin/main` is an ancestor of the reconciled HEAD (`git merge-base --is-ancestor origin/main HEAD` → true), so the pending push is a fast-forward, not a force-push.
- *The 7 untracked files carry local edits that would be lost* — rejected: each local symlink's `readlink` target is byte-identical to origin's committed symlink target (verified per-file), so restoring origin's versions is content-neutral.

## Resolution

**Smallest safe fix:** Reconcile via rebase-drop of the two superseded promotes, keeping only the unique park. (1) `git tag backup/pre-reconcile-2026-07-07 HEAD` — non-destructive safety net preserving all 3 original commits. (2) Verify all 7 collision symlinks byte-identical to origin, then move them to `.backup-untracked/` (clears the checkout block content-neutrally). (3) `git stash push -- logs/session-notes.md` (tracked dirty edit — an uncommitted June-9 S3 mandate block documenting the dropped work, plus this session's S1 header). (4) `git rebase --onto origin/main c4ceec4 main` — replays only `f1b2e0a` (→ `adf0485`) onto origin's tip, dropping `72bb174` + `c4ceec4`; zero conflict. (5) Discard the stash (its S3 block is bookkeeping for the dropped promote work; full content preserved in this record + the triage diff) and re-append a clean 2026-07-07 S1 block to origin's `session-notes.md`. Result: `main` = `origin/main` + park; one commit ahead; fast-forward-eligible. **What does not change:** `state/live/**` (origin's operationalized versions stand), any `ai-resources/` canonical file, the 6 local-only untracked symlinks, other untracked working files.

**Files changed:**
- `projects/strategic-os` git history (`main`): rebased `f1b2e0a` → `adf0485` onto `ea7bf1e`; dropped `72bb174`, `c4ceec4`.
- 7 collision symlinks under `.claude/commands/` + `.claude/agents/`: origin's committed versions restored by the rebase checkout (moved-aside copies retained in `.backup-untracked/`).
- `logs/session-notes.md`: uncommitted June-9 S3 block discarded; clean 2026-07-07 S1 reconciliation note appended.
- New tag `backup/pre-reconcile-2026-07-07`.

**Files NOT changed (but considered):**
- `state/live/**` — origin's versions are the authoritative superset; no edit needed.
- `ai-resources/.claude/**` canonical files — the symlink targets; untouched by design.
- The 6 local-only untracked symlinks (`reconcile`, `reconcile-activate`, `explore-section`, `leverage-idea`, `lean-repo-auditor`, `reconcile-reviewer`) — absent on origin, don't collide, survive as untracked for later commit/auto-sync.

## Verification receipt

- **What was tested:** (a) reconciled history shape; (b) fast-forward eligibility; (c) superseded commits dropped; (d) park content survived; (e) state/live is origin's operationalized version; (f) the 7 symlinks restored and tracked; (g) backup tag preserves all 3 originals; (h) session markers gitignored under origin's `.gitignore`.
- **What passed:** (a) `git log --oneline origin/main..HEAD` → exactly one commit `adf0485` (the park). (b) `git merge-base --is-ancestor origin/main HEAD` → true (fast-forward, no `--force`). (c) `git log b9f42d7..HEAD | grep -E '72bb174|c4ceec4'` → empty (dropped). (d) `grep As-of ai-strategy/implementation-tracker.md` → `As-of: 2026-07-04` + Slot 3 "Parked — OVERTAKEN". (e) `state/live/strategy.md` → `## What Axcíon is` / "AI-native … matchmaking firm". (f) `readlink` of restored symlinks → origin targets, `git ls-files` → tracked. (g) `git log b9f42d7..backup/pre-reconcile-2026-07-07` → all 3 originals. (h) `git check-ignore logs/.session-marker logs/.prime-mtime` → both ignored.
- **What was NOT tested + why:** The push itself is deferred — pushes are batched and operator-gated at `/wrap-session` per workspace commit rules; fast-forward eligibility was verified but the push is not yet executed. Origin's newly-visible active mission (`settings-path-portability`, Group 3 threads referenced in origin's `session-notes.md`) was not acted on — out of scope for this incident; flagged to operator for a future session.
- **Residual risk:** Low. If the operator later wants the dropped workstreams project-portfolio NOW/NEXT/LATER snapshot, it is recoverable from `backup/pre-reconcile-2026-07-07` (commit `c4ceec4`). Root recurrence risk (multi-machine work without pulling) is workflow-discipline, not a repo defect.
- **Rollback path:** `git reset --hard backup/pre-reconcile-2026-07-07` restores the pre-reconciliation HEAD with all 3 original local commits; the moved symlinks remain in `.backup-untracked/`.

## Recurrence prevention

- **Local note** — documented in this incident record (baseline). The structural recurrence trigger is operator workflow (committing on a stale base across machines without a `/prime` pull between sessions), which the existing `/prime` Step 0 auto-pull already surfaces — it caught this one. No shared-command contract weakness identified; no ADR warranted. A pending triage entry already sits in `projects/strategic-os/logs/improvement-log.md` (2026-07-07) from the `/resolve-repo-problem` pass for the Friday cadence to review.

## Follow-up

Linked `projects/strategic-os/logs/improvement-log.md` entry: "2026-07-07 — strategic-os `main` diverged from remote (local 3 / origin 20, pull blocked)" — status now effectively applied (fix landed this session); Friday cadence to confirm/close. No new `ai-resources/logs/improvement-log.md` entry (no shared-asset structural fix).

---

## Pattern-tracking fields

- **Affected component:** project asset (git state — `projects/strategic-os` branch history + untracked auto-sync symlinks)
- **Failure category:** brittle workflow handoff (multi-machine divergence — commits on a stale base without an intervening pull)
- **Related incidents:** none (first entry in `logs/incident-log.md`)
- **Recurrence count for this failure category:** 1 — first occurrence
