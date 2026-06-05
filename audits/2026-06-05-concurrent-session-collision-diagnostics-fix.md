---
title: "Diagnostics & Fix Report — Concurrent-Session Collision Class"
date: 2026-06-05
author: S6 (friday-act session) + /resolve-repo-problem
status: report — for implementation next session
severity: HIGH (recurring; ~5 distinct collision instances in 11 days)
scope: ai-resources workspace; affects every project repo with parallel sessions
implement: enforce existing worktree discipline + land playbook's already-named gated structural items
revised: 2026-06-05 post-QC (REVISE → corrected the "worktrees are new" framing error)
---

# Diagnostics & Fix Report — Concurrent-Session Collision Class

## 1. Executive summary

Parallel Claude Code sessions running on the **same repository** keep stepping on
each other's shared files — about **five distinct collision instances in eleven days**
(2026-05-25 → 2026-06-05), each given a **narrow one-off guard patch** that never
addresses the root.

**The key correction (post-QC):** the workspace **already documents the right model.**
`docs/parallel-sessions-playbook.md` makes **git worktrees the standard parallel
pattern** (one worktree + branch per unit, off a serial planning session that writes a
file-ownership map), and it **already names the residual problem** — "per-branch
isolation for the work + a single shared file for the bookkeeping … every parallel run
collides there" (playbook line 76) — and **already proposes the gated structural fix**
(per-session log namespacing, playbook line 93).

So the root cause is **not** "we lack a model." It is:

1. **The documented discipline was bypassed.** Today's collision (S6, 2026-06-05) was
   two sessions in the **same working checkout** — the foreign session's *uncommitted*
   edits showed up in S6's own `git status`, which only happens when two sessions share
   one working tree. No file-ownership map was drawn; no worktree was used. The playbook's
   entire discipline (map → worktree-per-unit → quarantine bookkeeping → integration QC)
   was skipped because the sessions were started **ad-hoc**, not as a planned parallel run.
2. **The already-named gated structural items haven't landed** — per-session log
   namespacing and the `.gitignore` marker quarantine remain proposed-but-unbuilt.
3. **A new surface appeared** that even a worktree run can hit: foreign edits to shared
   **command/doc files** (`.claude/commands/`, `docs/`) — watched by **no guard**.

**The fix is therefore "enforce and finish what's already designed," not "design worktrees."**
See §6–§8.

---

## 2. Problem statement

**Class:** Two or more Claude Code sessions, open at the same time on the same repo,
mutate shared state and one silently overwrites (or is wrongly flagged against) the
other.

**Shared state involved:**
- Append-only logs: `logs/session-notes.md`, `logs/improvement-log.md`, `logs/decisions.md`
- Session-identity markers: `logs/.session-marker`, `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, `logs/.prime-mtime`
- Canonical shared resources: `.claude/commands/*.md`, `.claude/agents/*.md`, `docs/*.md`
- Session-plan files: `logs/session-plan-*.md`

**Two distinct failure modes (do not conflate them):**
- **Mode A — same-checkout concurrency (today's incident).** Two sessions share one
  working tree. Uncommitted edits collide directly; one silently overwrites the other.
  This is what the worktree discipline exists to prevent — and it was simply not used.
- **Mode B — shared-bookkeeping under worktrees (the playbook's named residual).** Even
  when each session has its own worktree, the bookkeeping logs are single shared files
  every session writes, so they still collide at the repo level. This is the residual
  the playbook already calls out (line 76) and proposes to fix via per-session log
  namespacing (line 93).

**Why it matters:** silent lost-updates, false guard fires, and a fresh diagnosis each
recurrence.

---

## 3. Recurrence history (evidence)

| Date | Instance | Mode | Surface | One-off fix applied |
|------|----------|------|---------|---------------------|
| 2026-05-25 14:10 | TOCTOU race on session-notes.md | A/B | `session-notes.md` | (first sighting) |
| 2026-05-28 10:05 | Foreign write during Mandate Confirmation wait; mandate block overwritten | A | `session-notes.md`, `session-plan.md` | marker-scoped headers (TOCTOU Phase 2+3) |
| 2026-05-28 14:20 | Auto-mode header miscount → guard false-positive | (self) | `session-notes.md` | chain-aware counting (deferred) |
| 2026-05-29 | `.session-marker` clobbered by concurrent `/prime` | A | `.session-marker` | per-id markers (Option 2′) |
| 2026-06-04 S8 | no-own-marker session mis-attributed | A | `session-notes.md` | NO_OWN_MARKER rule |
| **2026-06-05 S6** | **Foreign writes to shared command/doc files (same checkout); NO_OWN_MARKER false-positive on partial marker setup** | **A** | **`.claude/commands/`, `docs/`, `prime.md`** | **(this report)** |

(Severity count "~5 distinct instances": the table's rows include one self-inflicted
guard miscount and the NO_OWN_MARKER variant; the distinct *collision* instances are
~5 across the 11-day span 05-25 → 06-05.)

Pattern: **distinct collisions, each given a narrow patch, the class intact** — because
every patch hardens one guard while the *discipline that would prevent the collision
entirely* (worktrees + ownership map) keeps getting skipped for ad-hoc parallel starts.

---

## 4. Root-cause diagnosis

**Primary root cause — the documented discipline is advisory and gets bypassed.**
`docs/parallel-sessions-playbook.md` already prescribes the correct model: a serial
planning session writes a **file-ownership map** (no two units share a path, *including*
logs and indexes — the "hard gate", playbook §2), then **one worktree + branch per unit**
(line 109). When followed, Mode-A collisions cannot occur (separate working trees) and
Mode-B collisions are bounded (the ownership map assigns every shared file an owner).
**Today neither happened** — the two sessions ran ad-hoc in the same checkout with no
map. The discipline exists; nothing makes it *trigger* when parallel work starts, and
starting a worktree session is enough manual friction that the default (same checkout)
wins.

**Secondary root cause — guards are narrow, reactive, and `session-notes.md`-scoped.**
Every concurrent-session guard was built for the *previous* incident and watches
`logs/session-notes.md` only (mtime delta, header count, mandate count). Nothing watches
`.claude/commands/` or `docs/`. They are point-in-time, and they infer ownership from
markers — so any divergence in marker writing breaks the inference. This patchwork is a
*reactive detector over shared-mutable state*: a posture the workspace has itself flagged
as one where the **structural fix tends to be the only durable path** (validate-before-
invest triage heuristic; see §10 references).

**Tertiary contributor (today, self-inflicted) — partial marker setup.** S6's marker
setup wrote only the shared `logs/.session-marker`, not the per-id
`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`. The canonical `/prime` writer writes
**both** together; an alternate hand-rolled setup wrote one. The `NO_OWN_MARKER` guard
reads "per-id marker absent" as "this session authored nothing" — correct for a genuine
no-marker session, wrong for one whose setup was merely incomplete. It would have flagged
S6's own header as foreign (caught by manual verification — a near-miss). Lesson: marker
setup must never diverge from the canonical both-or-neither writer.

**Why patches don't converge:** they harden guards while leaving the *prevention*
(worktrees + map) optional. Closing guard surface N reveals surface N+1 (today: command/doc
files), and each guard adds its own failure modes (the NO_OWN_MARKER rule — itself a fix —
produced today's false-positive).

---

## 5. Guard coverage gap (the table that explains today)

| Guard | Fires on | Watches | Detects foreign write to command/doc files? |
|-------|----------|---------|---------------------------------------------|
| `/session-start` Step 0.5 mtime guard | command entry | `session-notes.md` | **No** |
| `/wrap-session` Step 3.5 pre-write guard | pre-write at wrap | `session-notes.md` (header + mandate counts) | **No** |
| `detect-concurrent-session.sh` | SessionStart | process list (a session *exists*) | **No — names no files** |
| `auto-sync-shared.sh` | SessionStart (downstream projects) | symlink topology | **No — does not run inside ai-resources** |

Every guard is `session-notes.md`-scoped or existence-only. The shared command/doc file
surface — where today's genuine collision (`prime.md`) happened — is watched by **nothing**.
Confirmed by `/resolve-repo-problem` 2026-06-05 (full notes:
`audits/working/2026-06-05-resolve-concurrent-session-guard-blind-to-foreign-shared-file-writes.md`).

---

## 6. Fix options (ranked)

### Option A — Enforce the existing worktree discipline + lower its friction  ★ RECOMMENDED (Mode-A killer)

Worktrees are already the documented standard (`parallel-sessions-playbook.md` line 109);
the gap is that ad-hoc parallel starts bypass them. Close that gap:

1. **Make starting an isolated session one step.** A `/new-worktree-session` helper (or a
   documented one-liner) that does `git worktree add` + branch + `cd` so the worktree path
   is the path of least resistance, not extra friction.
2. **Detect-and-nudge for same-checkout concurrency.** Extend `detect-concurrent-session.sh`
   (or a SessionStart check) so that when a second session is detected **in the same
   working tree**, it warns: "another session is live in this checkout — start a worktree
   (`/new-worktree-session`) or coordinate via a file-ownership map per the playbook."
   This is the missing *trigger* that turns the advisory discipline into a prompt at the
   moment it matters.
3. **Require the file-ownership map for planned parallel work** (playbook §2) — reinforce
   that a parallel run starts with the serial planning session, not by opening a second
   terminal.

**What it fixes:** Mode-A collisions (today's class) — separate working trees mean sessions
physically cannot overwrite each other's uncommitted files; co-edits become git merges
(surfaced, not silent).

**What it does NOT fix:** Mode-B (shared bookkeeping under worktrees) — that needs Option B.

**Effort:** low-medium (a helper + one hook nudge + a doc reinforcement). **Blast radius:**
low (additive; no guard removed). **Needs:** `/risk-check` only for the hook edit.

### Option B — Land the playbook's already-named gated structural items  ★ RECOMMENDED (Mode-B killer)

The playbook already proposes these; they are designed-but-unbuilt:

1. **Per-session log namespacing** (playbook line 93) — give each session its own log
   files so the bookkeeping-conflict surface disappears. The playbook flags this as **not
   a free win**: it trades merge-conflicts for history fragmentation + a reconciliation
   step, and changes the marker contract's file-naming/tracking. **Route through
   `/risk-check`; update the `docs/session-marker.md` two-end registry.**
2. **`.gitignore` the transient markers** (playbook line 149) —
   `git rm --cached logs/.prime-mtime logs/.session-marker` + add both to `.gitignore`
   (the `--cached` keeps local files so the harness still works). The playbook notes this
   likely belongs in **every** project's `.gitignore` — a workspace-wide `/risk-check`-scoped
   hygiene sweep.

**What it fixes:** Mode-B (shared bookkeeping collisions even under worktrees).

**Effort:** medium (namespacing is the bigger one). **Needs:** `/risk-check` + marker-registry update.

### Option C — Cheap partial mitigations (do these NOW, regardless)

Already logged this session; close today's two specific surfaces at near-zero risk:

1. **Both-or-neither marker invariant (writer-side).** Every marker-setup path writes the
   shared **and** per-id marker together — never one alone. Kills the NO_OWN_MARKER
   false-positive surface. (Logged: improvement-log 2026-06-05 guardrail-candidate, med.)
2. **Concurrent-detected shared-dir advisory.** When a concurrent session is detected,
   `/prime` (or `/session-start` Step 0.5) runs a **read-only** `git status` over
   `.claude/commands` + `docs` and names any foreign-dirty shared files in the brief.
   Makes the currently-invisible command/doc surface visible. (Logged: improvement-log
   2026-06-05 "Concurrent-session guards blind to foreign writes…", Option A — note this
   matches the triage's own recommended option; see §9.)

### Option D — Behavioral interim (free)

Until A+B land: run parallel sessions **in different project repos**, or follow the full
playbook discipline (ownership map + worktrees) for any same-repo parallel work. Do **not**
open a second ad-hoc session in a checkout another session is already using.

### Rejected — Session-registry / lock primitive

A shared registry that sessions check before writing **adds more shared-mutable state**
(the registry itself races — the exact anti-pattern that produced this mess). OS-level
locks are brittle (stale locks on crash). Keep only as a last resort.

---

## 7. Recommended solution & implementation plan

Land **C now** (cheap, already logged), adopt **D as the interim rule**, then implement
**A** (enforce worktree discipline) and **B** (the gated structural items) in dedicated
sessions.

### Now (this/next session — cheap, low risk)
1. Land **C.1** (both-or-neither marker invariant) and **C.2** (shared-dir advisory).
2. Adopt **D**: no ad-hoc second session in a live checkout until A is in place.

### Phase 1 — Enforce worktree discipline (Option A)
3. Build `/new-worktree-session` (or document the one-liner): `git worktree add` +
   `session/{YYYY-MM-DD}-{marker}` branch + `cd`.
4. Extend `detect-concurrent-session.sh` to distinguish **same-checkout** concurrency
   (the dangerous case) from separate-worktree concurrency (safe) and nudge to a worktree
   when same-checkout is detected. `/risk-check` the hook edit.
5. Reinforce in `parallel-sessions-playbook.md` that ad-hoc same-checkout parallelism is
   the failure mode (cite today's incident) and the map+worktree path is mandatory for
   planned parallel work. (The playbook does **not** need worktrees *added* — it already
   has them; it needs the *trigger* and the anti-pattern named.)

### Phase 2 — Land the gated structural items (Option B)
6. `/risk-check` + System Owner second opinion on **per-session log namespacing**; update
   `docs/session-marker.md` two-end registry; implement and validate.
7. `/risk-check` the workspace-wide `.gitignore` marker quarantine; apply across projects.

### Phase 3 — Retire now-redundant guards (carefully, separate pass)
8. Once worktrees + namespacing are proven, the `session-notes.md` mtime/header/mandate
   guards and per-id marker machinery are largely redundant. Retire them in a **separate**
   `/risk-check`-gated pass — never in the same change that lands A/B. Keep belt-and-braces
   until validated (§3 of the playbook's integration-QC discipline applies).
9. Keep the **push gate** — the shared remote is still shared; "divergence on push is a
   standing condition, not a closeable bug" (playbook line 136). Keep `pull --rebase`
   before every push.

### Phase 4 — Validate
10. Run two parallel worktree sessions deliberately editing the same canonical command;
    confirm git surfaces a merge (not a silent stomp). Confirm namespaced logs need no
    merge. Confirm the same-checkout nudge fires when you (deliberately) start a second
    session in one checkout.

---

## 8. Risks & gates

- **Structural change classes** (hook edit in A; log namespacing + marker `.gitignore` in
  B; guard retirement in Phase 3) → Autonomy Rule #9: **`/risk-check` mandatory** for each.
- **Sequence, don't bundle.** Never retire guards (Phase 3) in the same change that lands
  A/B. Keep guards until worktrees+namespacing are validated (Phase 4).
- **Hook path assumptions** are the top hidden-coupling risk under worktrees — audit every
  hook for fixed-root paths (`detect-concurrent-session.sh`, `auto-sync-shared.sh`,
  `backup-session-plan.sh`, `check-permission-sanity.sh`). The playbook (line 122) already
  notes auto-sync produces untracked `.claude/` noise in worktrees — factor into "is this
  branch clean?" checks.
- **Per-session log namespacing is not a free win** (playbook line 93): history
  fragmentation + reconciliation step. Present as a tradeoff at `/risk-check`, never adopt
  silently.
- **New failure mode is loud, not silent.** Under worktrees, co-edit conflicts surface as
  git merge conflicts — strictly better than today's silent loss. Net safety gain.

---

## 9. Decisions needed before implementing

1. **A vs B first?** Rec: C now → A (enforce discipline, low risk, kills today's Mode-A) →
   B (the harder Mode-B structural items).
2. **Per-session log namespacing** — adopt, or rely on the file-ownership-map discipline
   instead (playbook §2 says the map alone records "who owns what" without mutating shared
   files; line 101 "go marker-free" alternative)? This is the central B decision.
3. **Same-checkout nudge: warn or block?** Rec: warn + offer `/new-worktree-session`; do not
   hard-block (the operator may have a legitimate reason).
4. **Guard-retirement scope** (Phase 3) — which §5 guards retire, in what order? Rec: none
   until Phase 4 passes.
5. **Rollout scope** — ai-resources pilot first, then project repos? Rec: yes.

**Note on divergence from the triage:** the `/resolve-repo-problem` triage (sibling doc)
recommended the *quick patch* (Option C here) and **deferred** the structural fix behind a
recurrence signal, per "offer the minimal infra subset." This report escalates to the
structural path (A+B) as primary **because the recurrence signal has now fired ~5×** and
because the structural model is **already designed** (the playbook) — so "invest" is mostly
"finish and enforce," not "build from scratch." C still lands first as interim. The operator
chooses the posture.

---

## 10. References

- `docs/parallel-sessions-playbook.md` — **the already-documented model**: worktree-per-unit
  (line 109), file-ownership-map hard gate (§2 / lines 40, 54–70), shared-bookkeeping
  residual named (line 76), per-session log namespacing proposed-gated (line 93), marker
  `.gitignore` quarantine (line 149), divergence-as-standing-condition (line 136), teardown
  checklist (lines 141–143).
- `/resolve-repo-problem` triage (full notes):
  `audits/working/2026-06-05-resolve-concurrent-session-guard-blind-to-foreign-shared-file-writes.md`
- `logs/friction-log.md` — 2026-05-25, 2026-05-28 (×2), 2026-06-04, **2026-06-05 (S6)** entries
- `logs/improvement-log.md` — 2026-06-05 "Concurrent-session guards blind to foreign writes…" (Option A);
  2026-06-05 "NO_OWN_MARKER guard mis-attributes … partial marker setup" (guardrail-candidate, med)
- `docs/session-marker.md` — marker contract (TOCTOU Phase 2+3, per-id markers); two-end registry to update under Option B
- The "validate-before-invest / reactive-detector-over-shared-mutable-state → structural fix
  may be the only durable path" triage heuristic (recorded in the workspace telemetry/decision
  trail, 2026-06-01) — the principle behind escalating from guard-patching to the structural model.
