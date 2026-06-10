# Concurrent-Session Fix — Coverage Audit + Residual-Gap Fix Plan

**Date:** 2026-06-10 (Session S3)
**Type:** Micro-audit — advisory only, no infrastructure changed this session.
**Operator question:** *Is the concurrent-session problem now permanently fixed so I won't keep hitting it? If not, do we at least have proper guardrails — so I can keep running concurrent sessions, just smartly?*
**Method:** Evidence-traced (not guessed). Sources read this session are cited inline. Both collision classes the operator runs are in scope: **same repo checkout** and **different projects**.

---

## 1. Verdict in one line

**PARTLY FIXED.** The *mechanism* that makes concurrent sessions safe is built and works — but it is wired into **only 1 of ~17 checkouts** (`ai-resources`). The operator runs concurrent sessions across projects too, and every project is its own git repo where the dangerous collision can still happen **unguarded**. The fix quality is good; the fix **coverage** is the hole.

| Collision class | Severity | Status | Why |
|---|---|---|---|
| **A — Same checkout** (2 sessions, one `.git`) | **Critical** (silent contamination) | **Partly fixed** | Commit-time block exists and works, but wired only in `ai-resources` |
| **B — Cross-clone shared logs** (Daniel pushes) | Low (data-safe; git pauses) | **Substantially fixed** | `wrap-owns-logs` discipline landed; residual is rare + git-detected |
| **Cross-project** (different repos, same machine) | Low | **Inherently safe** | Separate repos = no shared staging index; only risky when a project session reaches into `ai-resources` (which is Class A on `ai-resources`) |

---

## 2. What was actually built (the solution inventory)

The fix is not one change — it is a multi-part campaign across three audit docs
(`audits/2026-05-08…`, `…2026-06-05…`, `…2026-06-09-concurrent-session-isolation-fix-plan.md`).
Build status, verified against the live files this session:

| Fix | What it does | Built? | Evidence |
|---|---|---|---|
| **Fix 1** — same-checkout SessionStart nudge, liveness-tightened | Sharp "isolate now" warning when an un-wrapped foreign session shares this checkout | ✅ Built | `detect-concurrent-session.sh` L106–156 (per-id-marker oracle); depends on wrap Step 13 teardown |
| **Fix 2** — staging-index commit block | **Blocks** (`exit 2`) a `git commit`/`add -A` that would stage a file outside this session's footprint | ✅ Built | `check-foreign-staging.sh`; wired `ai-resources/.claude/settings.json:58` (PreToolUse) |
| **Fix 3** — default worktree launch | One-command isolated-session launcher | ⚠️ Built but **inert** | `cc-worktree.sh` is a *terminal* launcher; operator uses VS Code extension (auto-memory `feedback_vscode_launch.md`) |
| **Fix 4(a)** — wrap-owns-logs discipline | Work sessions only *append* to shared logs (git unions safely); in-place mutation confined to dedicated sessions | ✅ Built | `docs/commit-discipline.md` § Concurrent-session staging discipline (L9–58) |
| **Fix 4(b)** — per-session log namespacing | Each session writes its own log file | ❌ **Declined** (2026-06-05 S8) | Mode B never actually occurred; reintroduces a race-prone merge-back |
| **Block at SessionStart** (original Fix 1 idea) | Refuse a same-checkout session at start | ❌ **Un-buildable** | SessionStart hooks cannot block (verified vs CC hooks docs); `detect-…sh` header L56–65 |
| Supporting: `/concurrent-session-check` | Pre-flight file-ownership collision check | ✅ Built | `.claude/commands/concurrent-session-check.md` |
| Supporting: `/new-worktree-session` | In-session physical isolation (works from VS Code) | ✅ Built | referenced throughout; the real isolation path for this operator |

**The genuine backstop is Fix 2** — it is the only defense that *actually stops* the silent
clobber (everything else is a warning the operator can walk past, or an opt-in path he must
remember). So Fix 2's coverage = the audit's central question.

---

## 3. Incident → fix coverage matrix (does the solution stack to the recorded issues?)

Every recorded concurrent-session incident, traced to whether a built fix now covers it:

| Date | Incident | Covered by | Closed? |
|---|---|---|---|
| 2026-05-25 14:10 | `/session-plan` shared-file collision prompt | auto-detect MISMATCH → pass2 (commit `8ab5685`) | ✅ |
| 2026-05-28 10:05 | TOCTOU race on `session-notes`/`session-plan` | marker-scoped headers (id-31 Phase 2) | ✅ |
| 2026-05-28 14:20 | wrap guard false-positive on chained auto-mode | marker-aware own-subtraction (wrap Step 3.5) | ✅ |
| 2026-06-04 S4 | `/prime` Step 1a blind to sibling *project* repo commits | routed to improvement-log; partial | ◐ |
| 2026-06-05 S6 | guards blind to foreign edits on shared **command/doc** files | Fix 2 catches whole foreign *files* at commit; does **not** stop live mid-edit races | ◐ |
| 2026-06-09 S3 | `--amend` swept a foreign session's staged file | **Fix 2** (`check-foreign-staging.sh`) — direct remedy | ✅ *in `ai-resources` only* |
| 2026-06-09 S1 | mid-session commit staged sibling's `session-notes` header | Fix 2 exempts shared logs as benign (append-safe); content files are the guarded case | ✅ *in `ai-resources` only* |

The two incidents Fix 2 was built to kill (06-09 S3, S1) are genuinely killed — **but only inside the
`ai-resources` checkout**, because that is the only place the hook is wired (see §4).

---

## 4. The coverage gap (headline finding)

**Live wiring map, verified this session:**

| Checkout | `check-foreign-staging` (commit block) | `detect-concurrent-session` (nudge) | wrap Step 13 marker teardown |
|---|---|---|---|
| `ai-resources` | ✅ wired (`settings.json:58`) | ✅ wired (`settings.json:144`) | ✅ present (`wrap-session.md:464`) |
| workspace root | ❌ no PreToolUse block at all | ❌ not wired (SessionStart runs `check-archive` only) | ❌ absent (improvement-log id 2026-06-10/477) |
| 15 project repos | ❌ **0 of 15** | ⚠️ **1 of 15** (positioning-research only) | n/a |
| user level (`~/.claude`) | ❌ neither hook | ❌ neither hook | n/a |

*(The user-level cell means neither concurrent-session hook is registered there. `~/.claude/settings.json`
does contain other hooks — e.g. `detect-innovation.sh` runs by absolute path — which is exactly why
P1 below is feasible: user-level + absolute-path registration already works in this repo.)*

**Consequence:** every project is its own `.git`. A same-checkout collision (Class A — the
silent-contamination one) inside, say, `nordic-pe-screening-project` or `axcion-brand-book`
(both have prior recorded collisions) gets **no commit-time block** — exactly the failure that
Fix 2 was built to stop, left unguarded everywhere except `ai-resources`. The protection is
concentrated in the one checkout, while the operator's concurrency spans all of them.

*The gap follows from the **registration fact**, not from any assumption about how `--add-dir`
merges settings: because neither hook is registered at user **or** project level, it cannot fire in
a project-primary session no matter how Claude Code resolves hooks across added directories. (The
precise cross-`--add-dir` hook-merge behaviour was not separately confirmed and is not load-bearing
here.)*

### Secondary gaps (already logged, still open)

- **G2 — Fix 2 fails open with no footprint.** When a session has no concrete `- Files in scope:`
  (primed-but-not-planned, `/clarify`-first, `/fix-repo-issues` no-marker), the guard warns but
  **allows** the commit (`check-foreign-staging.sh` L157–169). This is the *highest-risk* shape
  (no footprint = the contamination case) getting *no* protection. (improvement-log 2026-06-10 id ≈467, 501.)
- **G3 — workspace-root wrap missing Step 13.** Without the per-id marker teardown, a wrapped
  workspace-root session leaves a stale per-id marker → `detect-concurrent-session` false sharp-nudge
  on the next solo re-open. Nuisance only. (improvement-log 2026-06-10 id ≈477.)
- **G4 — wrap-lite strand (deferred).** A no-own-marker CONCURRENT session whose work is already
  committed cannot finish its wrap rituals without staging the contended `session-notes.md`.
  Ergonomics, not data loss. (improvement-log 2026-06-04 id ≈216, DEFER.)

---

## 5. Can it be "permanently fixed" so the operator never deals with it again?

**Yes — for the dangerous class — if coverage is extended.** The honest breakdown:

- **Cross-project concurrency is already safe** (separate repos, no shared index). The operator can
  run different-project sessions freely *today* with no collision risk, as long as a project session
  doesn't reach into `ai-resources` (which is Class A on `ai-resources`, and that one *is* guarded).
- **Same-checkout becomes effectively collision-proof** once the commit-time block (Fix 2) covers
  every repo (P1 below) and the no-footprint blind spot is closed (P3). The block is a *hard* guard
  at the exact moment of damage — it does not depend on the operator remembering anything, which
  matches the operator's automation-over-discipline preference.
- **The one irreducible bit** is mid-*edit* live races (two sessions editing the same file in the
  same checkout before either commits). No hook can see an in-memory edit. This is contained by
  *isolation* (`/new-worktree-session`) + the SessionStart nudge, not by the commit block — so the
  residual rule the operator does still internalize is the single bright line: **never two sessions
  in the same checkout; spin a worktree.** Everything else is automated.

So the goal ("do concurrent sessions smartly, stop hand-resolving collisions") is reachable with the
fix plan below — it does **not** require "one session at a time."

---

## 6. Residual-gap fix plan (sequenced; each is a structural change → own `/risk-check` at build)

Tiered to the operator's stated guardrail preference: **hard block** for the silent-data-loss moments,
**soft nudge** for nuisances.

### P1 — CRITICAL — Extend the commit-time block to every repo *(hard block)*
Close the headline gap. **Recommended route: register `check-foreign-staging.sh` at USER level**
(`~/.claude/settings.json`, PreToolUse(Bash)) with an **absolute path** to the canonical
`ai-resources/.claude/hooks/check-foreign-staging.sh`. The hook already resolves `repo_root` from
`git rev-parse` and degrades open outside a repo — it is repo-agnostic, so one user-level
registration guards **all ~17 checkouts** with zero per-project drift.
- *Why user-level not 17 copies:* a copy in each project's `settings.json` is the drift-prone
  anti-pattern (the campaign already fights copy-drift between the two `wrap-session.md` files).
  One source = one truth.
- *Already proven feasible in this repo:* `~/.claude/settings.json` already runs an `ai-resources`
  hook (`detect-innovation.sh`) by absolute path, and `check-foreign-staging.sh` resolves `repo_root`
  from `git rev-parse` (L102–104) and degrades open outside a repo — so "repo-agnostic, one
  registration guards every checkout" is verified, not speculative.
- *Build wrinkle to resolve:* user-level hooks can't use `$CLAUDE_PROJECT_DIR` to find the script
  (that points at each session's own project). Use the absolute canonical path; per-machine
  `~/.claude` is the correct place for a per-machine absolute path (Daniel's machine points at his
  own clone). Confirm the hook stays reachable when no session has `ai-resources` open.
- *Risk-check class:* PreToolUse + commit-path change at user scope → `/risk-check` required.

### P2 — HIGH — Extend the SessionStart nudge the same way *(soft nudge)*
Register `detect-concurrent-session.sh` at user level too, so all 15 projects + workspace-root get
the concurrency heads-up — not just `ai-resources` + positioning-research. Same absolute-path
pattern as P1; pairs with it (the nudge tells you to isolate, the block catches you if you didn't).
- *Risk-check class:* SessionStart hook at user scope → `/risk-check` (lighter — non-blocking).

### P3 — MEDIUM — Close the fail-open blind spot *(soft block / confirm)*
When a gated git verb runs with **no concrete footprint AND a live foreign session is present**,
escalate `check-foreign-staging.sh` from "warn + allow" to a stop-and-confirm. This protects the
highest-risk shape (no footprint) that is currently unguarded even in `ai-resources`. Folds in the
already-logged minimum-guard proposal (improvement-log 467) and the `/clarify`-first case (501).
- *Risk-check class:* edit to a live blocking hook → `/risk-check`.

### P4 — LOW — Port wrap Step 13 to workspace-root *(nuisance fix)*
Add the per-id marker teardown (`rm -f logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`) to
`/.claude/commands/wrap-session.md` so workspace-root sessions stop leaving stale markers that
false-fire the sharp nudge. (improvement-log 477.) Light — paired-copy edit.

### P5 — OPTIONAL — wrap-lite remediation *(keep deferred)*
The no-own-marker CONCURRENT wrap strand (improvement-log 216). Ergonomics only; leave deferred
unless it recurs.

**Recommended build order:** P1 → P2 → P3 → P4. P1+P2 are the coverage fix (one user-level
registration each) and deliver ~all the marginal safety. P3 closes the last data-loss blind spot.
P4 is cleanup. Do **not** revive Fix 4(b) (namespacing, declined) or the SessionStart *block*
(un-buildable) — both were correctly ruled out.

---

## 7. What the operator does in the meantime (no build required)

Until P1 lands, concurrent sessions are safe under one discipline the operator already has the tools for:

1. **Different projects = free.** Separate repos can't collide on a staging index. Run them.
2. **Same checkout = spin a worktree.** Before a second session in the *same* folder, run
   `/new-worktree-session` (works from inside a VS Code session). This is the single rule that
   removes Class A by hand until P1 automates the catch.
3. **Before starting a second task in a live repo**, `/concurrent-session-check <task>` tells you if
   the footprints overlap.
4. **`ai-resources` sessions are already fully guarded** — both hooks fire there today.

---

## Related
- `audits/2026-06-09-concurrent-session-isolation-fix-plan.md` — the campaign this audit grades.
- `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` — Mode-A/Mode-B design home.
- `.claude/hooks/check-foreign-staging.sh`, `.claude/hooks/detect-concurrent-session.sh` — the live guards.
- `docs/parallel-sessions-playbook.md` — the manual discipline the hooks automate.
- `docs/commit-discipline.md` § Concurrent-session staging discipline — Fix 4(a) home.
- improvement-log.md ids ~467 / ~477 / ~501 (2026-06-10), ~216 (2026-06-04) — the open residuals P3/P4/P5 close.
