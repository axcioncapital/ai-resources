# Concurrent-Session Isolation — Fix Plan (design only; build later)

**Date:** 2026-06-09 (Session S3)
**Status:** PLAN ONLY — no infrastructure built this session. Each proposed fix is a structural change class and runs its own `/risk-check` at build time.
**Operator goal:** Run more than one Claude Code session on the same repos at the same time with **total isolation** — zero hand-resolved conflicts, zero cross-session contamination.
**Operator preference (load-bearing):** automation over manual discipline. The fixes below are chosen to remove the need to *remember* a rule, not to add another rule.

---

## 1. What actually went wrong today (two distinct failures)

| # | Failure | Mechanism | Damage |
|---|---------|-----------|--------|
| **A** | Two sessions ran in the **same folder / one `.git`** (the promotion session + this one) | Shared working tree → shared staging index + shared branch | A `git commit --amend` here swept the *other* session's staged file (`claim-permission.template.md`) into this commit; a foreign commit (`da72d7a`) landed in this branch's unpushed history |
| **B** | A **separate clone/machine** (Daniel) pushed to GitHub | Two clones edited the same shared log, reconciled only at pull | The pull-time merge conflict in `improvement-log.md` at `/prime` |

Failure A is the dangerous one (silent contamination, recoverable only by noticing). Failure B is annoying but data-safe (git pauses and asks).

## 2. Root cause — adherence gap, NOT a knowledge gap

The repo **already documents and tools both cases.** None of this is missing:

- `docs/parallel-sessions-playbook.md` §4 names **"ad-hoc same-checkout parallelism" the #1 failure mode** and says never to start a second session in the same checkout — exactly failure A.
- `/new-worktree-session <unit>` — creates an isolated worktree + branch so two sessions physically cannot share a working tree.
- `/concurrent-session-check <task>` — pre-flight collision check before adding a session.
- `.claude/hooks/detect-concurrent-session.sh` — a **live SessionStart hook** that already emits a *sharp same-checkout nudge* pointing at `/new-worktree-session` when it detects another session primed in this folder today.

Today's collisions happened **anyway** because every one of these is **advisory / opt-in**:
1. The same-checkout hook **warns but does not block** — a session can proceed past the nudge.
2. The worktree path is **opt-in** — the operator must remember to run `/new-worktree-session` *before* starting work; nothing forces it.
3. The **mid-session shared-index contamination** (a `git add -A` / `git commit --amend` capturing another session's staged files) is guarded by **nothing** — no hook inspects the staging index for foreign files.

For an operator who prefers automation, "remember to run the right command" is itself the failure surface. The fix is to make isolation the **default path** and to **block** (not just warn) the two genuinely-dangerous moves.

## 3. Proposed fixes (each gated by its own `/risk-check` at build time)

### Fix 1 — Block (not just warn) on same-checkout concurrency  *(closes Failure A at the door)*
- **What:** Upgrade `detect-concurrent-session.sh` so that when it detects the **same-checkout** condition (machine has ≥2 sessions AND a today-marker already exists in *this* folder), it returns a **blocking** SessionStart decision for the *new* session — not a soft nudge. The block message tells the operator to run `/new-worktree-session` and re-launch there. The softer machine-wide warning (a session in an *unrelated* project) stays non-blocking.
- **Why this is safe to make blocking:** the same-checkout case has **no legitimate use** — the playbook already says never do it. A block here removes a foot-gun, it does not restrict valid work. Cross-project concurrency (the common, valid case) is untouched.
- **Effort:** small (one hook edit + the SessionStart block-decision wiring). **Guarantee:** prevents two sessions sharing a checkout from *starting*, which is the only way Failure A occurs.
- **Risk-check class:** hook edit + SessionStart behavior change → `/risk-check` required. Watch: a wrapped prior session also leaves a today-marker, so the block must distinguish "live other session" from "my own earlier wrapped session" (the hook's existing heuristic note already flags this — tighten it so the block does not false-fire on a solo re-launch).

### Fix 2 — Guard the shared staging index against cross-session contamination  *(closes the `--amend` damage)*
- **What:** A `PreToolUse(Bash)` guard that, before a `git commit` / `git commit --amend` / `git add -A`, checks whether the staging index (or working-tree-wide add) contains files **outside this session's declared footprint** (the mandate's `Files in scope`, or the session-plan's owned files). If foreign files are staged, **pause** and show them rather than committing blind.
- **Why:** today's contamination was invisible until I read the post-commit `--stat`. A pre-commit index inspection makes it impossible to silently ship another session's file.
- **Effort:** medium (needs a session-footprint source to compare against — the mandate `Files in scope` line is the natural one; `--amend` and `-A` are the high-risk verbs to gate first). **Guarantee:** blocks the specific contamination that happened today; partial against a session with no declared footprint.
- **Risk-check class:** PreToolUse hook + commit-path change → `/risk-check` required. This is the highest-value fix because it is the only one of the three with *zero* existing guard.

### Fix 3 — Make worktree-launch the default for a second session  *(removes the "remember to" surface)*

> **✅ ADDRESSED — 2026-06-10 (Session S3), option (b).** Shipped `ai-resources/scripts/cc-worktree.sh` — a thin shell launcher (operator installs a one-line `.zshrc` function) that creates the worktree (mirroring `/new-worktree-session` Step 1), cd's in, and execs `claude` there; plus a wording-only tightening of all three nudges in `detect-concurrent-session.sh` to name `cc-worktree <unit>` as the fast path alongside `/new-worktree-session`. Re-synced both project hook copies in the same commit (positioning-research WIRED + research-pe orphan). `/risk-check`: PROCEED-WITH-CAUTION (both mitigations applied; SO concurred) — report `audits/risk-checks/2026-06-10-build-fix-3-option-b-of-the-concurrent-session-isolation-fix.md`.
> **Logged patch (per SO adjustment b):** the launcher *duplicates* `/new-worktree-session` Step 1 name/branch derivation, kept in sync by a header note rather than a shared helper. The structural single-source form — factor Step 1 into one helper under `scripts/` that both the command and the launcher call — is **parked as follow-up** (deferred deliberately: shipped Fixes 1+2 backstop the collision danger, so the sync-drift risk is low-frequency; revisit if the two drift in practice).
> **⚠ Fit caveat (2026-06-10, post-build):** `cc-worktree.sh` is a **terminal** launcher, but the operator starts sessions via the **VS Code extension** (open folder/window), not a terminal — so this launcher is **inert / unused** in practice (see auto-memory `feedback_vscode_launch.md`). Left in place rather than rolled back (zero functional harm: nothing auto-invokes it; rollback churn across 3 repos is its own risk). **The actual working solution for this operator = Fixes 1+2 (damage prevention) + the in-session `/new-worktree-session` command (works from inside a VS Code session).** If a VS Code-native one-click trigger is ever wanted, build it only on evidence that concurrent same-repo sessions are frequent.

- **What:** Make `/new-worktree-session` the path of least resistance instead of an opt-in. Options to weigh at build time (pick one):
  - (a) Have the same-checkout block in Fix 1 *offer to run* `/new-worktree-session` inline, so the operator's recovery is one keystroke, not a remembered command.
  - (b) A short operator-facing launch ritual (a single alias/script) that always opens a session in a fresh worktree.
- **Why:** Fixes 1+2 are *defensive*; this is the *positive* path so the operator naturally lands in an isolated folder.
- **Effort:** small–medium. **Guarantee:** depends on the operator using the launch path; pairs with Fix 1's block as the backstop.
- **Risk-check class:** if it only wraps existing commands, light; if it touches settings/launch config, `/risk-check`.

### Fix 4 — Structurally de-conflict the shared edit-in-place logs  *(closes Failure B's root)*
- **What:** Remove the conflict surface on the non-append shared logs (`improvement-log.md`, `decisions.md`) — the files that conflict at pull when two clones edit them. Two routes, already framed in the playbook §3:
  - (a) **Wrap-owns discipline + sequencing** — these logs are only edited at wrap, never mid-session, so two sessions serialize on them. Lightest; documentation + one commit-discipline rule.
  - (b) **Per-session log namespacing** — each session writes its own log file, reconciled at landing. Removes the surface entirely but adds history fragmentation + a reconcile step; changes the marker contract's file-naming.
- **Why:** Failure B is data-safe but recurring; today's autostash-conflict detection (shipped this session, commit `8691388`) makes the *symptom* visible but does not remove the *cause*.
- **Effort:** (a) small; (b) large. **Recommended default:** (a) first — it is cheap and removes most of the surface; escalate to (b) only if conflicts persist.
- **Risk-check class:** (a) commit-discipline doc + rule → light; (b) marker-contract change → `/risk-check` + `docs/session-marker.md` two-end registry update.

## 4. Recommended build order (biggest friction drop first)

1. **Fix 2 (staging-index guard)** — the only failure with *no* existing guard, and the one that did real damage today (silent contamination). Highest marginal value.
2. **Fix 1 (block same-checkout)** — cheap, closes Failure A at the door, complements Fix 2.
3. **Fix 4(a) (wrap-owns logs discipline)** — cheap, removes most of Failure B's surface.
4. **Fix 3 (default worktree launch)** — the positive path; nice-to-have once 1+2 backstop the danger. ✅ **Done 2026-06-10 (option b — `cc-worktree.sh` launcher).**
5. **Fix 4(b) (per-session log namespacing)** — only if 4(a) proves insufficient; largest and most invasive.

## 5. What this plan does NOT change

- It does **not** rewrite or duplicate `docs/parallel-sessions-playbook.md` — that playbook is correct; the fixes here *enforce* it rather than restate it. At build time, link each fix back to the playbook section it automates.
- It does **not** touch the concurrent session's in-flight work (`da72d7a`, the unstaged `claim-permission.template.md`, the untracked promotion risk-check file).
- It does **not** resolve the separate promotion-vs-rollback question (still the operator's call).
- It builds nothing now — each fix is a structural change that gets its own `/risk-check` in a dedicated build session.

## Related
- `docs/parallel-sessions-playbook.md` — the manual playbook these fixes automate (esp. §3 shared-state, §4 anti-pattern + `/new-worktree-session`).
- `docs/session-marker.md` — marker contract (Fix 4(b) would amend its file-naming).
- `docs/commit-discipline.md` — home for Fix 4(a)'s wrap-owns rule.
- `.claude/hooks/detect-concurrent-session.sh` — target of Fix 1.
- `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` — prior collision diagnosis (Mode A = same-checkout).
