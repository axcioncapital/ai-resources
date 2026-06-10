# Session Plan — 2026-06-10 S3

## Intent
Make worktree-isolated launch the default, low-friction path for a second concurrent session, so isolation happens by default rather than by remembered discipline. Build Fix 3 (option b) of the concurrent-session isolation fix-plan.

## Model
opus — the session opens with a real design fork (option a vs b, and a /placement call for a new artifact category) plus a hook edit whose nudge wording is load-bearing. Deciding-tier work. Matches active model (claude-opus-4-8[1m]).

## Source Material
- `audits/2026-06-09-concurrent-session-isolation-fix-plan.md` — Fix 3 definition (two sub-options; build order #4; "nice-to-have once 1+2 backstop").
- `.claude/commands/new-worktree-session.md` — the existing opt-in worktree command; its Step 1–2 `git worktree add` logic is what the launcher reuses. Hard-limit note: a command cannot move the current session's cwd.
- `.claude/hooks/detect-concurrent-session.sh` — the SessionStart nudge; already names `/new-worktree-session`. Header documents that SessionStart hooks cannot block or redirect cwd.
- `docs/parallel-sessions-playbook.md` — the manual playbook these fixes automate (cite, do not duplicate).
- `docs/commit-discipline.md` / `docs/session-marker.md` — adjacent contracts (read-only context).

## Findings / Items to Address
- **Platform constraint is the design driver.** Claude (a slash command or hook) cannot change its own shell cwd or open a new terminal. So the only way to truly remove the "remember to run `/new-worktree-session` in a fresh session" surface is a shell-level launcher the operator runs *to open* the isolated session. This rules option (a) down to "already mostly shipped via Fix 1's sharp nudge."
- **Reuse, don't reinvent.** The launcher must reuse the exact worktree-creation contract from `new-worktree-session.md` (branch naming `session/<date>-<unit>`, sibling `WORKTREE_PATH`, base = `main`, uniqueness suffixing). The script is a thin shell wrapper around `git worktree add` + `cd` + `claude`, not new coordination machinery (playbook stays the single source of truth).
- **Placement is an open call.** A shell launcher script is a new artifact category/location for this repo → `/placement` fires before the file is created. Candidate homes: a `scripts/` dir, or a docs-embedded snippet the operator pastes into `.zshrc`. Decide via /placement.
- **Deployment surface = operator's shell.** The script's value depends on the operator installing it once (`.zshrc` source line) and adopting `cc-worktree <unit>` as the launch habit. The in-repo artifact + install snippet is what we ship; adoption is the operator's.
- **Nudge tightening is small.** The hook's sharp-nudge message should name the one-command launcher as the recovery path (a wording edit only — no logic change, no new block, which the platform can't do anyway).
- **Fix-plan bookkeeping.** Mark Fix 3 addressed in the fix-plan once shipped.

## Execution Sequence
1. `/placement` on the new launcher script → decide its home (scripts/ vs docs snippet). Use the recommendation as default.
2. Write the launcher: a zsh function/script (`cc-worktree <unit>`) — resolve repo root, derive `UNIT`/`BRANCH`/`WORKTREE_PATH` identically to new-worktree-session.md Step 1, `git worktree add ... -b ... main`, `cd` into it, exec `claude`. Fail loud on worktree-add error; never clobber an existing worktree.
3. Add a one-line install snippet (source line for `.zshrc`) wherever placement lands it.
4. Tighten `.claude/hooks/detect-concurrent-session.sh` sharp-nudge wording to name the launcher as the one-command recovery (wording only).
5. Mark Fix 3 addressed in `audits/2026-06-09-concurrent-session-isolation-fix-plan.md`.
6. `/risk-check` (already gated as Step 8c.9) — verdict GO required before/around the structural writes.
7. `/qc-pass` on the launcher script + nudge edit before declaring complete.
8. Commit (do not push; batched to wrap).

## Scope Alternatives
- **Leaner (drop):** Close Fix 3 as "backstopped by shipped Fixes 1+2," ship nothing. Defensible — the fix-plan itself ranks Fix 3 lowest and 1+2 are live. Rejected at the gate (operator said `go` for option b).
- **Option (a)-only:** Tighten the hook nudge wording, no launcher. Low value — Fix 1's nudge already names the command; adds almost nothing.
- **Recommended (option b):** Shell launcher + nudge tightening + fix-plan close-out. Picked.
- **Heavier (Fix 4b territory):** Per-session log namespacing — out of scope, separate fix.

## Autonomy Posture
Gated — new launch-automation artifact + hook edit = structural change class. Plan-time `/risk-check` runs before the structural writes land (auto-mode Step 8c.9). Commit directly on GO; push batched to wrap.

## Risk
Structural class present (new automation script that launches sessions; SessionStart-adjacent hook edit). Primary risks to watch in /risk-check: (1) a launcher that creates worktrees the operator forgets to tear down (cruft — mitigated by citing `/cleanup-worktree` + new-worktree-session Step 5 teardown); (2) launcher shipped in-repo but executed from the operator's shell — a code-in-repo / run-in-environment split (mitigated: ship script + explicit install snippet, no auto-install); (3) wording drift between the launcher and `new-worktree-session.md` worktree contract (mitigated: reuse identical naming logic, cite not duplicate).
