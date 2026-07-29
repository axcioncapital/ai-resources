# Session Plan — 2026-07-14 S3

## Intent

Ship the two queued safety fixes produced by S2's near-miss: (1) a **destructive-op liveness pre-flight** that binds the *executor* immediately before any `worktree remove` / `branch -D` / `reset --hard` / `clean -f`, and (2) **prevention (b)** for assert-from-recall — a mechanical `Files in scope` path check that rejects prose.

## Model

**opus** — matches active session model. Deciding work: designing a doctrine contract, judging an existing guard's soundness, and adjudicating a live over-gating counter-argument. Not mechanical.

## Source Material

- `logs/improvement-log.md` — 2026-07-14 entry "Destructive git ops have NO liveness check" (HIGH, OPEN) → **Item 2**
- `logs/improvement-log.md` — 2026-07-14 entry "I state repo facts from recall instead of checking them — now 4-for-4" (MED-HIGH, OPEN) → **Item 3**
- `logs/session-notes.md` § 2026-07-14 S2 → Risky actions, Next Steps
- Read this session: `docs/commit-discipline.md` (83 L), `.claude/commands/close-worktree-session.md` (184 L), `.claude/commands/new-worktree-session.md` Step 5, `.claude/commands/session-start.md` Steps 2.5–3

## Findings / Items to Address

### Item 2 — Destructive-op liveness pre-flight

**F2.1 — `/close-worktree-session`'s guard is SOUND. The backlog entry's suspicion is falsified.**
The entry said its scope was "unverified". It is now verified by direct read: Step 2 runs `git -C "$WT_PATH" status --short` and Step 3 scans `"$WT_PATH"/logs/.session-marker-*`. **Both probe the TARGET checkout**, not the current one. No fix is needed there for the stated reason. *(This finding was produced by reading the file — the exact discipline Item 3 exists to enforce.)*

**F2.2 — The real hole is that the guard was never in the road taken.** S2 did not invoke `/close-worktree-session`; it ran `git worktree remove` directly from a session plan. Protection that lives inside one command protects nothing when the destructive verb is invoked outside it. **The doctrine must bind the executor, not a command.**

**F2.3 — `new-worktree-session.md:118–124` actively hands out the unguarded commands.** Under the heading *"Equivalent by hand, if you prefer — but you lose the guards"* it prints `git worktree remove` + `git branch -d`, protected only by prose ("Never remove a worktree a live session still occupies"). This is the documented on-ramp to the exact failure. **`new-worktree-session.md` is NOT in the declared Files in scope → scope expansion, see Scope Alternatives.**

**F2.4 — `/close-worktree-session` Step 3's marker check is TODAY-dated only** (`case "$(cat "$f")" in "${TODAY} "*)`). A session primed yesterday and still open overnight leaves a marker that does **not** match, so the guard silently passes. Real correctness bug, found by read.

**F2.5 — Probe 3 (dirty-file mtimes) is absent everywhere.** The backlog entry specifies three probes; `close-worktree-session` implements two (status, marker). The mtime probe is the only one that catches a session whose work is *in the editor but not yet on disk as a git change* — weakest of the three, but it is the cheap tiebreak when status is clean and the marker is stale.

### Item 3 — Prevention (b): mechanical `Files in scope` check

**F3.1 — The check ALREADY EXISTS and is too weak. This is a strengthening, not a new gate.**
`session-start.md` Step 2.5 check 3 reads: *"`files_in_scope` either lists ≥1 concrete path OR is explicitly `(inferred)`. Empty / bare placeholder fails."* It tests **non-emptiness only**. S2's footprint — `"the 18 files carried by the branch"` — is non-empty, so it **passes this check today**. The defect is a weak predicate, not a missing one.
**This materially defuses the over-gating counter-argument** the backlog entry itself raised (`/lean-repo` RR-05, "a new mechanical check on a system flagged for over-gating"): no new gate is added; an existing gate's predicate is tightened from `non-empty` to `is-a-path AND exists-on-disk`.

**F3.2 — Auto mode has NO self-check at all.** `prime.md` Step 8c.4 derives `files_in_scope` and 8c.7 writes it, with no Step-2.5 equivalent anywhere in between. Auto mode is the *less* guarded path, and it is the one that writes mandates without an operator seeing the field. Both attach points are needed.

**F3.3 — `check-foreign-staging.sh` already pays for this failure, loudly and late.** Per `commit-discipline.md` § Footprint source and fail-open: a footprint that is prose (no concrete path) makes the hook **fail open** — no protection at all — and in S2 it instead blocked the merge commit. Moving the check to mandate-write time is strictly cheaper than a blocked commit after the work is done.

## Execution Sequence

### Stage 1 — Item 2: doctrine (`docs/commit-discipline.md`)
1. Add § **Destructive-op pre-flight (liveness probe)**: before any `worktree remove` / `branch -D` / `branch -d` / `reset --hard` / `clean -f`, the **executor** probes the **TARGET** checkout — (a) `git -C <target> status --short`, (b) `ls <target>/logs/.session-marker-*` (any date, not just today — per F2.4), (c) mtimes of dirty files. Any hit → **STOP and ask the operator.**
2. State the load-bearing rationale explicitly: *a clean worktree is not an idle worktree; "clean" is a reading of a moving system.* Cite S2.
3. State the **anti-pattern**: do NOT implement this inside `/risk-check` — a plan-time gate reads a stale snapshot and relocates the bug one layer up.
4. Point at `/close-worktree-session` Steps 2–3 as the **reference implementation** (it is correct — F2.1).

### Stage 2 — Item 2: close the two real gaps in the commands
5. `close-worktree-session.md` Step 3 — remove the TODAY-only date filter so an overnight marker still fires (F2.4). Add the mtime probe as a third check (F2.5).
6. `new-worktree-session.md` Step 5 — the by-hand block (F2.3): either delete the unguarded snippet or bind it to the pre-flight. **Requires scope expansion — surface first.**

### Stage 3 — Item 3: strengthen the existing check
7. `session-start.md` Step 2.5 check 3 — tighten the predicate: every entry in `files_in_scope` must be a **literal path** (contains `/` or a known extension; no prose) **and exist on disk** (`test -e`); a value that fails is rejected with a re-ask, and prose is never written. Preserve `(inferred)` as the one legal non-listed shape.
8. `session-start.md` Step 3 — add the **companion rule**: the field carries the paths themselves, pasted from a command's output; a *reference to* a command is not a footprint, because its consumer is a parser, not a reader.
9. `prime.md` Step 8c.7 — mirror the same mechanical check into the auto-mode mandate write (F3.2).

### Stage 4 — Close out
10. Flip both `improvement-log.md` entries OPEN → applied, each with a **verification line** (what was checked, and the result — not "looks right").
11. `/qc-pass` on the doctrine section + the two command edits.
12. Commit. **No push** (batched to wrap).

## Scope Alternatives

- **[SCOPE] `new-worktree-session.md` is not in the declared Files in scope.** It is, however, the *documented on-ramp* to the exact failure Item 2 exists to prevent (F2.3), so shipping the doctrine while leaving a command that prints the unguarded commands verbatim would leave the fix decorative. **Recommendation: expand scope by one file and amend the mandate's `Files in scope` bullet on disk** (which is also required for `check-foreign-staging.sh` to arm — it blocks staging any file outside the footprint). *Alternative rejected:* edit it silently — that is precisely the footprint dishonesty Item 3 is about.
- **Narrower fallback if the risk-check objects:** ship Stage 1 (doctrine) + Stage 3 (Item 3) only, and log Stages 2/6 as a follow-up. The doctrine alone is advisory-but-real; the command edits are what make it bite.
- **Deliberately NOT in scope:** the `/risk-check` implementation route (explicitly rejected by the backlog entry); the worktree rebase (menu item 1); the `Read` deny-rule narrowing (menu item 6).

## Autonomy Posture

**Gated.** Structural classes touched: a doctrine doc governing destructive ops, three live commands (24 + 21 + 1 symlinked consumers inherit), and a tightened mechanical check on the mandate-write path. `/risk-check` runs before execution per workspace Autonomy Rules #9.

## Risk

- **Blast radius is wide by symlink:** `prime.md` (24 symlinks), `session-start.md` (21 symlinks), `close-worktree-session.md` (1). Canonical edit propagates everywhere; that is intended, and it raises the cost of getting the predicate wrong.
- **A too-strict path predicate could false-reject a legitimate footprint** (a glob, a to-be-created file). The check must permit not-yet-existing *outputs* — a mandate legitimately names files it will create. **Mitigation:** the existence test applies to inputs; a path that does not exist is a *warn-and-confirm*, not a hard reject. This is the single most likely way to ship a net-negative gate, and `/risk-check` should be pointed at it specifically.
- **In-place status flips on `improvement-log.md`** are, per `commit-discipline.md` § Maintenance-owned in-place mutations, reserved for dedicated single-purpose sessions. This session **is** single-purpose (two queued backlog items, no ordinary work alongside) and no concurrent session is live in this checkout (worktree wrapped at 10:46; its tree is clean). Conflict surfaced, resolved, proceeding — noted rather than silently assumed.
- **Over-gating counter-argument (real, and weakened by F3.1):** Item 3 adds no new gate; it tightens an existing predicate from `non-empty` to `is-a-path`. The `/lean-repo` RR-05 objection is on the record and should still be put to the risk-check.
