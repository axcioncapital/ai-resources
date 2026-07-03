# Risk Check — 2026-07-03

## Change

Hook edit: .claude/hooks/check-foreign-staging.sh — added a narrow warn-only branch inside the existing `if not foreign:` early-exit path (the branch that runs when no genuinely foreign, non-exempt files are staged, i.e. the guard would otherwise silently allow the commit). The new branch additionally checks whether (a) any staged candidate files are exempt-but-outside-this-session's-declared-footprint, AND (b) a live foreign per-id session marker is present in this checkout, AND (c) the invocation is a `git commit` (not `git add`). If all three hold, it calls the existing, unmodified `warn_open()` helper with an advisory message recommending a pathspec-scoped commit (`git commit -- <path>`) instead of a bare one, naming the exempt files at risk. No existing block path, warn path, or computation (`foreign`, `is_exempt`, `in_footprint`, `_live_foreign_session`, exit codes) was touched — this is a pure addition inside a previously-silent `sys.exit(0)` branch; when the new condition is false, execution falls through to the same unconditional `sys.exit(0)` as before (verified by direct code trace). This closes a documented gap: 2026-07-03 incident (commit `9660bf2`, logged in `logs/friction-log.md` under "/open-items backlog scan → field-match fix" and reiterated in the same day's Session S7 Next Steps) where a bare `git commit` silently swept a concurrent session's in-flight exempt (log-rotation archive) files into the wrong commit message, with zero signal to the operator — because the exempt-list correctly suppresses the hard BLOCK for these files (co-staging them is normally benign), but gave no separate signal for the narrower "a live foreign session might actually be using one of them right now" case.

Verification already performed by the requesting session: `bash -n` and `python3 -m py_compile` both pass on the modified file (no syntax errors); manual trace of the new block confirms unchanged fall-through behavior in every case except the one new narrow case.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists (modified, uncommitted)

## Verdict

GO

**Summary:** A self-contained, advisory-only addition inside a previously-silent branch of an existing hook — reuses every existing helper and output contract unchanged, closes a documented incident (9660bf2), and touches no caller; all six dimensions Low.

## Consumer Inventory

Search terms: `check-foreign-staging` / `check-foreign-staging.sh` (basename + component), `staging-tripwire` (output contract marker), plus the marker-liveness convention (`.session-marker-<id>`) and the `- Files in scope:` footprint contract the hook parses. Grepped across `ai-resources/` and the workspace root one level up. Log/session-notes/prior-risk-check hits were excluded as non-structural noise; the rows below are the structural consumers.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/.claude/settings.json | invokes | no |
| ai-resources/docs/commit-discipline.md | documents | no |
| ai-resources/.claude/hooks/detect-concurrent-session.sh | documents | no |
| ai-resources/.claude/commands/wrap-session.md | co-edits | no |
| ai-resources/docs/session-marker.md | documents | no |
| ai-resources/docs/parallel-sessions-playbook.md | documents | no |
| ai-resources/docs/daniel-concurrent-session-hooks-setup.md | documents | no |

Total: 7 consumers, 0 must-change.

- The hook is wired as a `PreToolUse(Bash)` hook in the **user-level** settings (`/Users/patrik.lindeberg/.claude/settings.json:62`, matcher `"Bash"`, timeout 5) — NOT in the repo `ai-resources/.claude/settings.json` (whose PreToolUse block lists other hooks). The registration line is unchanged by this edit, so `invokes` / must-change = no. (Incidental: `docs/commit-discipline.md:29` says the hook is "wired in `.claude/settings.json`" — a pre-existing minor doc inaccuracy about the settings layer, not caused by this change.)
- `wrap-session.md` is tagged `co-edits` because it owns the per-id marker teardown (Step 7 / "final wrap action") that produces the liveness signal `_live_foreign_session()` reads. The new branch reuses that helper unchanged, so no lockstep edit is required — the co-dependency is inherited, not introduced.
- The one consumer whose *documentation* diverges from the new behavior is `docs/commit-discipline.md` (see Dimensions 3 and 6): its § Exempt describes exempt files as unconditionally "benign (no lost update)". The change is backwards-compatible (must-change = no), but the doc does not yet describe the new narrow warn — a recommended, non-blocking follow-up.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook is `PreToolUse(Bash)` — fires on every Bash call — but the change adds **no per-call cost on the common path**: ordinary Bash calls still hit the gated-verb early exit (`if not is_commit and not is_add_wide: sys.exit(0)`, line 140–141) before the new branch is ever reached. Evidence: the new branch is at lines 414–435, well past that exit.
- The new work runs only for a genuine `git commit`/`git add`-wide invocation that reaches `if not foreign:` (line 414): one list comprehension over already-computed `candidates` (`exempt_foreign`, line 424) plus one `os.listdir(logs_dir)` scan inside `_live_foreign_session()` (line 213). This is a rare, commit-time path, not a per-turn cost.
- No always-loaded content added: no workspace/project CLAUDE.md edit, no new `@import`, no new hook registration, no subagent/skill. The `warn_open()` output is emitted only in the new narrow case (commit + exempt-foreign + live concurrent session), so ongoing token cost to future sessions is effectively nil.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings-file change of any kind — no `allow`/`ask`/`deny` edit, no matcher change, no timeout change. The user-level registration (`/Users/patrik.lindeberg/.claude/settings.json:62`) is untouched.
- No new tool-invocation pattern. The new branch's operations (`os.listdir`, `open()`, list comprehension) are already used elsewhere in the same file (`_live_foreign_session()` lines 213–224; footprint reads lines 232–248). The hook remains read-only (writes nothing; header CONTRACT line 54).

### Dimension 3: Blast Radius
**Risk:** Low

- Directly touches **1 file** (the hook). Consumer inventory: **7 consumers, 0 must-change** (see table above).
- No output-contract change: the new branch calls the **unmodified** `warn_open()` (line 159–165), emitting the same `hookSpecificOutput.additionalContext` shape with the same `[staging-tripwire]` prefix. No consumer `parses` the warn output by machine — it is agent-facing `additionalContext`, so no parser is affected.
- No exit-code contract change: the new path exits 0 (via `warn_open` line 165, or the unconditional `sys.exit(0)` at line 435). The block path (exit 2, lines 437–455) is only reachable when `foreign` is non-empty and is unreachable from the new branch — confirmed by direct read.
- Backwards-compatibility check: the only observable behavior change is that a previously-silent `sys.exit(0)` path now *sometimes* emits an advisory warn. This is additive and advisory; no caller must change to keep working.
- Blast-radius finding (doc-completeness, not a break): `docs/commit-discipline.md` § Exempt (line 35) frames exempt files as unconditionally "benign (no lost update)"; the new branch adds a narrow live-concurrent-session exception the doc does not yet describe. Backwards-compatible, so must-change = no — but recommended as a follow-up so the two-end contract doc (which the hook header line 54 names as the contract registry) stays current.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to a tracked shell script. If uncommitted, `git checkout -- .claude/hooks/check-foreign-staging.sh` fully restores prior state; if committed, `git revert` is a clean single-file undo. No sibling files or directories created.
- No data/log mutation (the hook writes nothing — header CONTRACT line 54), no settings.json change, so no cached-permission or registration cleanup beyond git. No state propagated outside the repo (no push, no external write, no marker/file write by the hook).
- No new automation surface (no new hook, cron, or symlink registered) that could fire between landing and a potential revert — the registration is unchanged.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new branch introduces **no new machine contract**: no new parse marker, filename convention, YAML key, or output schema. The recommendation to use `git commit -- <path>` is advisory prose inside `additionalContext`, not a contract callers must honor.
- It reuses three existing helpers unchanged — `is_exempt()` (line 371), `in_footprint()` (line 395), `_live_foreign_session()` (line 197), and `warn_open()` (line 159) — so the only dependency it leans on (per-id marker liveness) is the **same pre-existing convention** the P3 no-footprint block path already uses (line 270). No new implicit dependency is added; it is inherited.
- Failure-mode check on the inherited dependency: a crashed/un-wrapped session leaves a stale per-id marker → `_live_foreign_session()` returns True → a false-positive warn. This is strictly milder than the pre-existing false-*block* (exit 2) the P3 path already produces from the same stale-marker condition; the new path only ever warns (exit 0). No new silent state mutation and no auto-firing in an unexpected context — the trigger is narrowly gated (`is_commit` excludes `git add`, line 425).
- No functional overlap that double-handles a concern: the new warn targets a case (concrete-footprint session + exempt-foreign file + live concurrent session) that neither the existing P3 warn/block (no-footprint case) nor the `git diff --cached` shared-file review (foreign *hunks* in owned files) covers.
- The rationale is documented **at the change site** — the inline comment (lines 415–423) explains the narrow exception and cites the 9660bf2 incident — so the one framing tension with `commit-discipline.md` § Exempt is not silent (see Dimension 6). Recommended follow-up: mirror it into the contract doc.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read successfully (`projects/strategic-os/ai-strategy/principles-base.md`); principle IDs below are cited from it.
- **OP-12 (closure before detection) — served, not violated.** The change does not add an orphan finding-generator; it closes a *documented* gap (incident 9660bf2, recorded in `logs/friction-log.md` and `docs/commit-discipline.md:17`) and names the exact remedy inline (`git commit -- <path>`). New signal ships *behind* a working closure recommendation — the aligned direction of OP-12.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — no violation.** The consumer is confirmed and specific (a real 2026-07-03 incident), not an absent Phase-2 consumer. No generalization, no "hooks for later" — a single narrow branch for a recorded failure. Consumer-inventory check: the change introduces no new contract with zero consumers.
- **OP-5 (advisory vs. enforcement) — aligned.** The change stays firmly advisory: it calls `warn_open()` (non-blocking, exit 0), deliberately NOT the block (exit 2). It is the lower-authority response for a softer risk than the existing block — no silent enforcement upgrade. The hook's own header cites OP-5 as its authority model (line 14).
- **DR-1 / DR-3 (placement) — aligned.** Edits an existing hook in its canonical home (`.claude/hooks/`); no new file, no tier question. **DR-8** (risk-check-gated hook class) is being honored — this review is the gate.
- **OP-11 / OP-3 (loud revision, no silent drift) — mild tension, not a violation.** `commit-discipline.md` § Exempt (line 35) frames exempt files as unconditionally benign; the new warn adds a narrow exception. The rationale is recorded loudly at the change site (inline comment lines 415–423) and the incident is logged, so it is not silent drift. Updating the contract doc would fully close the tension (recommended, non-blocking).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references into the modified hook and the user-level settings registration, grep counts for the consumer inventory, verbatim quotes from `docs/commit-discipline.md` and `principles-base.md`, and a direct code trace of the new branch's exit paths). No training-data fallback was used on any read.
