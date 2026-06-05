---
title: "Repo-Maintenance Problem Sweep — 2026-06-04 → 2026-06-05"
date: 2026-06-05
author: prime → clarify → diagnosis session (post-S8)
status: review-only diagnosis; one safe fix applied (fix-symlinks status flip)
scope: all repo machinery (session-harness + git + logs + permissions + cadence)
question answered: "Beyond the concurrent-session problem, what else needs fixing?"
---

# Repo-Maintenance Problem Sweep — 2026-06-04 → 2026-06-05

## 0. How to read this

The operator asked: *identify every repo-maintenance problem from the last two days,
propose solutions, and say whether anything beyond the known concurrent-session
problem still needs fixing.*

**Short answer: yes — but most of it is already logged, and the concurrent-session
problem itself is ~80% closed as of today (session S8).** The genuinely un-addressed
root cause beyond concurrent-sessions is the **consumer-inventory under-count class**
(it caused real rework twice this week). Everything else is either already shipped,
already logged-and-deferred behind a `/risk-check` gate (correct), or simple log
hygiene.

This doc has three layers, matching the agreed scope:
- **§1 — full inventory** of every problem in the window, each tagged `SHIPPED` /
  `CAPTURED-DEFERRED` / `UN-CAPTURED`, so nothing is hidden.
- **§2–§4 — deep diagnosis** of the un-captured / unactioned items only.
- **§5 — the answer** to "anything else?" in plain terms, plus what I fixed inline.

---

## 1. Full inventory (everything in the window)

### 1a. Concurrent / parallel session collisions — the known problem

| # | Problem | Status |
|---|---------|--------|
| 1 | Mode-A: two sessions in the **same checkout** overwrite each other's uncommitted files (today's S6/S7 collision, ~5th recurrence in 11 days) | **SHIPPED (S8)** — `/new-worktree-session` command + same-checkout auto-nudge in `detect-concurrent-session.sh` |
| 2 | Collisions are **invisible** — guards only watch `session-notes.md`, blind to `.claude/commands/` + `docs/` | **SHIPPED (S8)** — read-only shared-dir advisory added to `/prime` + `/session-start` when a concurrent session is detected |
| 3 | Partial marker setup → `NO_OWN_MARKER` guard would mis-flag own work as foreign (writer side) | **SHIPPED (S8)** — both-or-neither marker invariant documented (BLOCKING) in `session-marker.md` |
| 4 | Mode-B: shared bookkeeping logs still collide even under worktrees | **CAPTURED — DECLINED (S8)** — per-session log namespacing declined on evidence (Mode B has never actually occurred; cost > benefit). Reopen only on a confirmed Mode-B collision. |
| 5 | Reader-side `NO_OWN_MARKER` hardening in `wrap-session.md` Step 3.5 (cross-check an authored header before claiming zero-contribution) | **CAPTURED-DEFERRED** — needs its own `/risk-check` (touches both paired `wrap-session.md` copies) |
| 6 | `.gitignore` the transient markers (`.prime-mtime`, `.session-marker`) workspace-wide | **CAPTURED-DEFERRED** — `/risk-check`-gated hygiene sweep (Option B.2) |
| 7 | Retire now-redundant `session-notes.md`-scoped guards once worktrees proven | **CAPTURED-DEFERRED** — Phase 3, only after validation; correctly not bundled |
| 8 | Full `lsof` same-checkout detection for the nudge | **CAPTURED-DEFERRED** — shipped a safe heuristic instead; full detection brittle (process args carry no cwd) |

**Live signal at the time of writing:** during *this* session's `/prime`, an S8 session
was committing and pushing on the same repo (origin/main advanced from ~26-unpushed to
1-unpushed mid-prime; S8 commit times 12:40–13:24). So the collision class is still
*live in practice* even though the prevention now exists — the new `/new-worktree-session`
discipline has not yet replaced the ad-hoc same-checkout habit. **Adoption, not code, is
the remaining gap on items 1–3.**

### 1b. Consumer-inventory under-count — the real "anything else"

| # | Problem | Status |
|---|---------|--------|
| 9 | Structural renames keep shipping with **incomplete consumer lists** → half-finished changes. The date-qualify rename shipped a filename change (`fa2b3f2`) while `wrap-session.md` still read the old path; caught only by a lucky cross-read → rework commit `35fb409`. THREE independent passes missed the same consumer. | **CAPTURED — UNAPPLIED** — id-40 (pre-spec consumer-inventory grep checklist) + the S7 strengthening entry, both `logged (pending)` |

This is the single highest-ROI un-shipped fix outside the concurrent-session class.
Deep-diagnosed in §2.

### 1c. Log / registry hygiene

| # | Problem | Status |
|---|---------|--------|
| 10 | `/fix-symlinks` improvement-log entry still reads `logged (pending) — DEFER`, but the work **shipped in S7** (`e18fd29`). Stale status. | **UN-CAPTURED → FIXED THIS SESSION** (§4) |
| 11 | Resolved/decided improvement-log entries accumulating (id-41 applied, concurrent entries applied/declined, archive-dedup applied…) | **CAPTURED-DEFERRED** — S8 next-steps flagged `/resolve-improvement-log`; recommend running it |
| 12 | `session-marker.md` two-end registry was stale (missed `wrap-session.md`; misclassified `backup-session-plan.sh`) — the root that let #9 through | **SHIPPED (S7)** — registry now lists `wrap-session.md` + a new "Runtime non-command consumers" class |

### 1d. Standing / resurfaced items (older, lower priority, all captured)

| # | Problem | Status |
|---|---------|--------|
| 13 | `/risk-check` 5-dimension shape doesn't catch design-internal **principle drift** (2026-05-29) | **CAPTURED-DEFERRED** |
| 14 | §8 grounding-absence **self-resolved (proceed-degraded) instead of escalated** — the System Owner agent ran ungrounded (2026-06-02) | **CAPTURED-DEFERRED** — flagged in §3 as a correctness (not hygiene) risk |
| 15 | Graduation verdicts recorded at wrap **without the second-consumer test** — stale GRADUATE propagates (2026-06-04) | **CAPTURED-DEFERRED** |
| 16 | `.claude/` shared-resource git-hygiene: gitignore synced symlinks + regenerate (2026-06-04) | **CAPTURED-DEFERRED** — overlaps #6 (both are `.gitignore` hygiene for shared/synced files; consider bundling) |
| 17 | `session-notes.md` tail re-read at `/prime` then again at wrap (R4 token lever) — flagged 8+ consecutive sessions, no structural fix | **CAPTURED-DEFERRED** — standing debt; escalate if not shipped in ~2 sessions |
| 18 | Read of `improvement-log.md` mid-rewrite returned a transient truncated state; a blind append would have destroyed ~23 entries (S7 near-miss) | **CAPTURED-DEFERRED** — same family as the concurrent-session class; mitigated by the append-discipline + worktree fixes |

---

## 2. Deep diagnosis — consumer-inventory under-count (#9, the headline answer)

**What happened.** Twice this week a structural change shipped against an incomplete list
of the files that consume it:
- The date-qualify session-plan rename (`fa2b3f2`) changed the plan filename but left
  `wrap-session.md`'s exact-path reader pointing at the old name. A reader that
  *tolerates* a missing plan would have silently resolved to "plan not found" — a quiet
  degradation, not a loud crash. Caught only because someone happened to re-read the
  `id-41` entry, whose hand-built inventory had flagged it. Fix shipped as a follow-up
  commit (`35fb409`) — i.e. one logical change took two commits because the first was
  half-finished.

**Two compounding root causes** (from the S7 friction analysis):
1. **Grep on the templated form misses variant spellings.** The same placeholder is
   written at least four ways across the codebase — `${MARKER}`, `{MARKER}`, `{marker}`,
   `$MARKER`. A consumer grep keyed to one spelling silently skips the others. A grep for
   `session-plan-${MARKER}` does not match `wrap-session.md`, which writes the literal
   `session-plan-{MARKER}.md`.
2. **The authoritative registry was itself incomplete.** `session-marker.md`'s two-end
   registry — whose whole job is "every consumer points back here" — didn't list
   `wrap-session.md` and misfiled a load-bearing hook as a "narrative reference." So the
   one source of truth that should have caught all three passes was stale.

Root cause #2 is **already fixed** (S7 rebuilt the registry). Root cause #1 is **not** —
it's logged as id-40 and the S7 strengthening entry, both still `logged (pending)`.

**Proposed fix (this is a plan, not a safe inline edit).** Make the pre-spec
consumer-inventory step mandatory and spelling-proof for any path/filename rename:
- **(a) Grep the invariant stem, never the templated form.** Inventory by `session-plan`
  (the part that never changes), not `session-plan-${MARKER}`. Placeholder-spelling
  variance then cannot hide a consumer.
- **(b) Reconcile grep ↔ registry before the spec is written.** Any consumer the grep
  found but the registry lacked (or vice-versa) gets added to *both* before the rename
  spec is frozen.

**Where it lands:** `skills/ai-resource-builder/SKILL.md` (a pre-spec checklist
subsection) **or** a new `docs/spec-authoring-checklist.md` referenced from
`audit-discipline.md`. Placement decision belongs to the implementation session.
**Effort:** small (doc/checklist). **Risk:** low (advisory checklist, no shared-state
mutation). **Recommended route:** a focused `/improve-skill` session — it is the
highest-ROI unshipped lever outside the concurrent-session class because it prevents the
*rework* class, not just one instance.

---

## 3. Deep diagnosis — System Owner agent ran ungrounded (#14, a correctness risk)

Worth separating from the hygiene items because it can degrade *advice the operator
acts on*. On 2026-06-02 a `§8 grounding-absence` was **self-resolved as
"proceed-degraded" instead of escalated** — the System Owner agent produced output
without its grounding reference docs loaded. The risk: an advisory agent that silently
runs ungrounded gives plausible-but-unanchored recommendations, and the
"proceed-degraded" path makes that invisible.

**Status:** logged (pending), un-actioned. **Proposed fix:** the grounding-absence branch
should **escalate (stop + flag) rather than self-resolve** for advisory agents whose
value depends on the reference corpus (System Owner, project-manager, expert-check).
This is a small command-text change to the agent's preamble but it is a *judgment-class*
change (it alters when the agent halts) — route through a focused session, not a quick
tweak. Lower frequency than #9 but higher per-instance consequence.

---

## 4. Safe fix applied this session

**#10 — `/fix-symlinks` improvement-log status drift.** The entry read
`logged (pending) — DEFER`, but the change shipped in S7 (`e18fd29`,
`.claude/commands/fix-symlinks.md` +63/−6). Left as-is, the next `/prime` or
`/open-items` scan would re-surface finished work as still-open (the same stale-menu
class this very session hit on its own `/prime`).

**Verified the diff before flipping** (the entry described a destructive `/risk-check`-class
Option A, so a bare "applied" would have been wrong): `e18fd29` shipped the
**non-destructive variant** (≈Option B) — a Step 2b *detection* pass over
`shared-manifest.json` that flags regular-file-where-symlink-expected drift and reports a
manual `ln -sf` remedy, with auto-restore **deliberately omitted** ("these never auto-fix…
overwriting with a symlink could destroy local changes"). So the logged 2026-06-02 gap is
closed, the destructive auto-restore was never built (and needs no `/risk-check`), and the
DEFER verdict is moot. Status updated to record exactly that distinction, not a bare
"applied." Edited by explicit path with a fresh read immediately before the write
(live-concurrency precaution).

No other inline fixes were applied — every remaining item is either already shipped, a
`/risk-check`-gated structural change (not a "safe quick fix"), or best handled by a
systematic `/resolve-improvement-log` pass rather than hand-editing many log entries
while another session may be live in the same repo.

---

## 5. The answer, in plain terms

**Is there anything else besides the concurrent-session problem? Yes — but less than the
log volume suggests, because S8 already closed most of the concurrent-session work today.**

Ranked by what's worth doing next:

1. **Consumer-inventory checklist (#9) — do this.** It is the one un-shipped root cause
   that has *already cost rework twice this week*. Small, low-risk, high-ROI. Route:
   `/improve-skill` on `ai-resource-builder` (or a new `spec-authoring-checklist.md`).
2. **Finish the concurrent-session tail (#5–#7) — already correctly queued.** Reader-side
   `NO_OWN_MARKER` hardening, the `.gitignore` marker quarantine (bundle with #16), and
   guard retirement — each is `/risk-check`-gated and should stay sequenced, never
   bundled. No new diagnosis needed; the S8 diagnostics report already plans them.
3. **System Owner ungrounded-escalation (#14) — worth a focused pass.** Correctness, not
   hygiene: an advisory agent shouldn't silently run without its grounding.
4. **Log hygiene — cheap cleanup.** Run `/resolve-improvement-log` to archive the
   resolved/decided entries (#11); the one stale status (#10) is already fixed above.
5. **Standing R4 token lever (#17) — escalate if it slips two more sessions.**

**What does NOT need action:** Mode-B namespacing (#4) was correctly declined on
evidence; the registry root cause (#12) is already fixed; the visibility + worktree
prevention (#1–#3) already shipped. The biggest *practical* residual is **adoption** —
actually using `/new-worktree-session` instead of opening a second window in the same
checkout. That's a habit change, not a code fix.
