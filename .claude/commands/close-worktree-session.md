---
description: Land a finished worktree session — merge its branch back to main, remove the worktree, delete the branch. The teardown half of /new-worktree-session. Operator-invoked.
model: sonnet
disable-model-invocation: true
argument-hint: "[unit-name | branch | worktree-path]  (omit to auto-detect)"
---

Land a finished worktree session: **merge → remove worktree → delete branch.** This is the
teardown half of `/new-worktree-session`, which creates worktrees but only *documents* the
teardown in prose (its Step 5). This command executes it, with the guards that prose cannot enforce.

**Do not confuse this with `/cleanup-worktree`.** That command — despite its name — has nothing
to do with git worktrees: it investigates and cleans a dirty *working tree* (uncommitted files).
It never merges, never removes a worktree, never deletes a branch. If you want to tidy
uncommitted files, that is `/cleanup-worktree`. If you want to *land a finished parallel session*,
you are in the right place.

---

## What this command refuses to do

State these to the operator if any guard trips. They are the point of the command — a bare
three-command shell paste has none of them.

- **Never `git worktree remove --force`.** Plain `remove` refuses when the worktree is dirty.
  That refusal is a feature; forcing it discards uncommitted work with no recovery.
- **Never `git branch -D`.** Plain `-d` refuses to delete a branch whose commits are not merged.
  That refusal is the last thing standing between the operator and lost work.
- **Never auto-resolve a merge conflict.** Stop, show the conflicting paths, hand back control.
- **Never remove a worktree a live session still occupies.**
- **Never push.** Push stays gated and batched to session wrap (workspace `CLAUDE.md`).

If a guard trips, **surface it and stop.** Do not work around it, and do not offer the `--force`
/ `-D` variant as a convenience — if the operator genuinely wants to discard work, they can type
it themselves, deliberately.

---

## Step 1 — Resolve the target worktree

```bash
REPO_ROOT=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)
[ -z "$REPO_ROOT" ] && { echo "[/close-worktree-session] Not inside a git repo."; exit 0; }
git -C "$REPO_ROOT" worktree list
```

**Guard — you must not be standing inside the worktree you are about to remove.** Git refuses
this, but the error is cryptic. Check first: if `$REPO_ROOT` is itself a linked worktree (i.e. it
is not the main checkout), stop and tell the operator:

> You are running this **from inside** the worktree. A session cannot remove the directory it is
> living in. Switch to the main checkout window (`ai-resources`) and run this there.

Determine `TARGET`:
- If `$ARGUMENTS` is non-empty, match it against the worktree list as a unit name, a branch name,
  or a path (any of the three — be liberal in what you accept).
- If `$ARGUMENTS` is empty, auto-detect the linked worktrees whose branch matches `session/*`.
  **Exactly one → use it.** **More than one → list them and ask which.** **None → say "No session
  worktrees to close." and stop.**

**⚠ Paths in this workspace contain SPACES** (`.../Claude Code/Axcion AI Repo/...`). Parse
`--porcelain` output by **stripping the line prefix**, never by whitespace field-splitting — an
`awk '{print $2}'` truncates the path at the first space and silently resolves the WRONG worktree.
This bug was written, caught by execution, and fixed here on 2026-07-13; do not reintroduce it.
(Same lesson class as the `zsh` tied-parameter rule: validate shell by running it, not by reading it.)

```bash
git -C "$REPO_ROOT" worktree list --porcelain | while IFS= read -r line; do
  case "$line" in
    "worktree "*) wt="${line#worktree }" ;;
    "branch "*)   br="${line#branch refs/heads/}"
                  case "$br" in session/*) printf '%s\t%s\n' "$wt" "$br" ;; esac ;;
  esac
done
```

Set `WT_PATH` and `BRANCH` from the resolved entry, and **quote both everywhere downstream.**
Echo them before doing anything.

## Step 2 — Guard: is the worktree clean?

```bash
git -C "$WT_PATH" status --short
```

Non-empty → **stop.** Show the paths and say:

> The worktree has uncommitted changes. Landing it now would either lose them or drag them into
> `main` unreviewed. Go back to that window, commit or discard them, then re-run this.

An untracked auto-synced `.claude/` is the **known exception** — the SessionStart auto-sync hook
symlinks shared commands into every worktree and they must never be committed (see
`docs/parallel-sessions-playbook.md` § 5). Untracked entries **confined to `.claude/`** may be
ignored; say so in one line rather than silently passing them.

## Step 3 — Guard: is a session still live in there?

A worktree has its own `logs/` tree, so it carries its own per-session markers. A
`logs/.session-marker-*` inside `$WT_PATH` means a session primed there and has not ended.

**Scan ANY date — not just today.** *(Fixed 2026-07-14. This block previously filtered on
`"${TODAY} "*`, which silently passed a session that primed **yesterday** and is still open
overnight — the guard reported clear on an occupied worktree. The marker is pruned by session
teardown, not by date, so a marker's date says when the session **started**, never whether it
has **ended**. Dating the filter to today was a category error.)*

```bash
for f in "$WT_PATH"/logs/.session-marker-*; do
  [ -f "$f" ] || continue
  echo "LIVE: $(basename "$f")  →  $(cat "$f" 2>/dev/null)"
done
```

**Third probe — recent writes.** Steps 2–3 ask "is there work?" and "did someone prime?".
Neither catches a session that primed long ago and is *editing right now* with nothing yet
saved to a git-visible change. Check whether the target was written to recently:

```bash
find "$WT_PATH" -type f -not -path "*/.git/*" -newermt "-120 minutes" 2>/dev/null | head -5
```

Any hit → **stop:**

> A session still appears to be live in that worktree. Close it (or `/clear` it) before landing —
> removing a worktree out from under a running session is how work gets lost.

**This guard is a LIVENESS oracle — NOT a "has-wrapped" oracle. Know the difference before you
trust it, or you will reach for `rm`.** *(Corrected 2026-07-14 S8. The previous text asserted the
guard "is trustworthy as of 2026-07-13" **because** a `SessionEnd` hook removes the marker "rather
than a model remembering the last step of `/wrap-session`". That framing is what produced the S5
incident: it implies a wrapped session leaves no marker, so a marker on a wrapped session reads as
a guard malfunction — and the operator "fixes" the guard by deleting its evidence.)*

The marker is removed by `~/.claude/hooks/cleanup-session-marker.sh` on **`SessionEnd`**, which
fires when the **CLI process ends** — normal exit, `/clear`, `/quit` (`docs/session-marker.md:227`).
It does **not** fire when `/wrap-session` finishes. Therefore:

> **A session that has wrapped but whose window is still open is STILL LIVE, its marker is
> CORRECTLY present, and this guard is RIGHT to block it.**

That is not a false positive. The guard and the operator are asserting different things and both
are true: you mean *"that session has finished its work"*; the marker means *"that process is still
running"*. Only the second is observable from here.

**Verified 2026-07-14 (S8) by execution, not by reading:** fed a payload naming a real marker, the
hook removes the per-id file and correctly leaves the shared one, logging `REMOVED`. It works. The
`NOOP marker-absent` lines filling its log are sessions that never ran `/prime` and so had no marker
to remove — correct behaviour, not silent failure.

**If the operator confirms the target is genuinely idle,** re-run the same command with the override.
It proceeds and writes an audit line to `logs/destructive-override.log`:

```bash
AXCION_LIVENESS_OVERRIDE=1 git worktree remove "<absolute path>"
```

**Never delete the marker files to get past this guard.** That was the sanctioned workaround until
2026-07-14 and it is now closed. It defeats the guard by erasing the evidence the guard reads, leaves
no record, and trains the habit of deleting a signal that will one day be true. Contract:
`docs/session-marker.md` § Per-id marker teardown.

**These guards are sound — and they are not the only thing standing between you and a destroyed
worktree, because they only run if you invoke THIS command.** On 2026-07-14 a session assembled
`git worktree remove` directly in a session plan, never ran `/close-worktree-session`, and came
within one operator remark of destroying a live session's 173+ lines of uncommitted work. These
Steps 2–3 were correct and were simply never in the path. That is why the probes are now ALSO
enforced by `.claude/hooks/check-destructive-liveness.sh`, a `PreToolUse(Bash)` hook that fires on
the destructive verb itself regardless of which command (or no command) is running. Doctrine and
rationale: `docs/commit-discipline.md` § Destructive-op pre-flight.

**Known gap, state it if the guard fires and the operator insists the session is closed:** the hook
does not fire on a hard crash, so a crashed session can leave a stale marker. If the operator
confirms the worktree is genuinely idle, proceed — but make them say so; do not decide it for them.

## Step 4 — Merge the branch into the main checkout

Confirm the merge target is the repo's default branch and that the operator is on it:

```bash
git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD     # expect: main
git -C "$REPO_ROOT" merge "$BRANCH"
```

- **Clean merge (fast-forward or merge commit)** → report which, and the files it brought in
  (`git -C "$REPO_ROOT" diff --stat ORIG_HEAD..HEAD`). Continue to Step 5.
- **Conflict** → **STOP. Do not attempt to resolve it.** Report the conflicting paths verbatim and:

  > The merge conflicts. I have not touched the conflict, and nothing has been removed — the
  > worktree and branch are both intact. Resolve the conflict (or `git merge --abort` to back
  > out), then re-run this command.

  The worktree and branch **must survive a failed merge.** Never proceed to Steps 5–6 on a
  conflict; that is the one sequence that could destroy the work being merged.

## Step 5 — Remove the worktree

```bash
git -C "$REPO_ROOT" worktree remove "$WT_PATH"
```

Plain `remove` — never `--force`. If it refuses, the tree is dirty in a way Step 2 missed:
surface the exact stderr and stop.

## Step 6 — Delete the branch

```bash
git -C "$REPO_ROOT" branch -d "$BRANCH"
```

Plain `-d` — never `-D`. `-d` refuses unless the branch is fully merged, which after Step 4 it is.
**If `-d` refuses here, something is genuinely wrong** (the merge did not include everything, or
the branch moved). Do not reach for `-D`. Stop, report, and leave the branch alone — the worktree
is already gone, but the branch still holds every commit, so nothing is lost.

## Step 7 — Report

```
Landed: {BRANCH} → main
  merged:   {N} files, {+X/-Y} lines   ({fast-forward | merge commit})
  worktree: {WT_PATH} removed
  branch:   {BRANCH} deleted

{N} commits now unpushed on main. Push is batched to session wrap — run /wrap-session when done.
```

If the worktree directory sat inside another git repo's tree (e.g. a sibling of `ai-resources/`,
which lives inside the workspace-root repo), note in one line that removing it also clears the
untracked entry it was showing there.

---

**This command orchestrates; it does not own worktree discipline.**
`docs/parallel-sessions-playbook.md` is the source of truth for decomposition, file-ownership maps,
landing, and teardown. Pairs with `/new-worktree-session` (create) — this is the close.
Do not invent competing coordination machinery here.
