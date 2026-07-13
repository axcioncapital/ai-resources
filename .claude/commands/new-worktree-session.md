---
description: Create and prepare an isolated git worktree for a parallel session — the structural cure for same-checkout collisions. Operator-invoked.
model: sonnet
disable-model-invocation: true
argument-hint: "[short-unit-name]"
---

Create an isolated git worktree so a parallel session runs in its **own working
directory** and cannot collide with another session sharing the same checkout. This is
the structural remedy referenced by the SessionStart concurrency nudge and by
`docs/parallel-sessions-playbook.md`.

**What this fixes:** same-checkout concurrency (Mode A) — two Claude Code sessions in one
working tree silently overwrite each other's uncommitted edits. Separate worktrees make
that physically impossible; co-edits surface as git merges, not silent losses.

**Hard limit — read this first.** This command **cannot move your current session into the
worktree.** A session's working directory is fixed when its VS Code window (or terminal) opens,
before any command runs. So the flow is: this command *creates and prepares* the worktree — and
opens it in a new VS Code window for you (Step 3) — then **you start a session in that new window**
and do the parallel work there. If you are already the second session in a shared checkout, the
safe move is to stop work here, create the worktree with this command, and continue in a fresh
session opened on the new directory.

---

## Step 1 — Resolve names

```bash
REPO_ROOT=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)
[ -z "$REPO_ROOT" ] && { echo "[/new-worktree-session] Not inside a git repo — cd into the target repo first."; exit 0; }
REPO_NAME=$(basename "$REPO_ROOT")
TODAY=$(date '+%Y-%m-%d')
```

Determine `UNIT` — a short, filesystem-safe label for this unit of work:
- If `$ARGUMENTS` is non-empty, use it (lowercase it; replace spaces/non-alphanumerics with `-`).
- If empty, ask the operator for a one-word unit name, then sanitize the same way.

Compose:
- `BRANCH="session/${TODAY}-${UNIT}"`
- `WORKTREE_PATH="${REPO_ROOT}/../${REPO_NAME}-${UNIT}"` (a sibling directory of the repo).

If `WORKTREE_PATH` already exists, append `-2`, `-3`, … until unique (do not clobber an
existing worktree).

## Step 2 — Confirm the base, then create the worktree

Default base is the repo's default branch tip (`main`) — a known-good base, not whatever
is checked out. Surface the base in one line; proceed with `main` unless the operator named
another.

```bash
git -C "$REPO_ROOT" worktree add "$WORKTREE_PATH" -b "$BRANCH" main
```

If the command errors (dirty index lock, branch name taken, base missing), surface the exact
stderr and stop — do not retry blindly. A branch-name collision usually means a worktree for
this unit already exists today; pick a different `UNIT` or reuse the existing worktree.

## Step 3 — Open the worktree in a new VS Code window, then tell the operator how to enter it

The command cannot move *this* session into the worktree, but it **can open the worktree folder
in a new VS Code window** for you. Try that first (the operator launches via VS Code, not a
terminal), then print the next step.

```bash
open_in_vscode() {   # opens $1 in a NEW VS Code window; returns 0 on success
  local dir="$1"
  # 1. `code` on PATH (Linux, or macOS with the "Shell Command: Install code" done)
  command -v code >/dev/null 2>&1 && { code -n "$dir" && return 0; }
  # 2. macOS: VS Code installed but `code` not on PATH — use the app's bundled binary
  local mac_code="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  [ -x "$mac_code" ] && { "$mac_code" -n "$dir" && return 0; }
  # 3. macOS fallback: `open` is always present
  command -v open >/dev/null 2>&1 && { open -a "Visual Studio Code" "$dir" && return 0; }
  return 1
}
open_in_vscode "$WORKTREE_PATH" && OPENED=1 || OPENED=0
```

Opening the folder does **not** auto-start a Claude session — the operator still opens the Claude
Code panel in the new window and runs `/prime`. Print the message that matches `OPENED`:

> Worktree ready: `{WORKTREE_PATH}` on branch `{BRANCH}`.
>
> **A new VS Code window just opened on that folder** *(if `OPENED=1`)*. In it: open the Claude
> Code panel (sidebar icon, or `Cmd+Shift+P → Claude Code`), run `/prime`, and do this unit's
> work there.
>
> **If no window opened** *(fallback, `OPENED=0`)*: open it by hand — VS Code → **File ▸ New
> Window**, then **Open Folder…** → choose `{WORKTREE_PATH}` — then open the Claude Code panel
> and run `/prime`. (Terminal users can instead `cd "{WORKTREE_PATH}"` and run `claude` there.)
>
> Keep this session in its own lane — do not edit files this unit owns from the original checkout.

## Step 4 — Surface the worktree gotchas (cite, don't re-document)

State these briefly; `docs/parallel-sessions-playbook.md` is the authority:

- **Auto-synced `.claude/` is untracked noise, not your work.** The SessionStart auto-sync
  hook symlinks shared commands/agents into every worktree's `.claude/`; they show up as
  untracked in `git status` and must never be committed (playbook § 5, "`git status`
  hygiene"). Don't let them inflate the apparent dirty state.
- **Session markers and scratchpads are gitignored** (`logs/.session-marker*`,
  `logs/.prime-mtime`, `logs/scratchpads/`) — per-worktree, never shared through git.
- **File-ownership first.** For planned multi-unit parallel work, the serial planning session
  + file-ownership map (playbook §§ 2–3) comes *before* spawning worktrees — no two units
  should own the same path, logs included.

## Step 5 — Teardown is a tracked phase

When the unit lands, **run `/close-worktree-session`** from the main checkout. It is the teardown
half of this command: merge the branch → remove the worktree → delete the branch, with the guards
this prose cannot enforce (refuses on a dirty worktree, on a live session still in it, and on a
merge conflict; never uses `--force` or `-D`).

Equivalent by hand, if you prefer — but you lose the guards:

```bash
git -C "$REPO_ROOT" merge "{BRANCH}"                     # land the work first
git -C "$REPO_ROOT" worktree remove "{WORKTREE_PATH}"   # add --force only if intentionally discarding
git -C "$REPO_ROOT" branch -d "{BRANCH}"                 # -d's merged-check is a safety net
```

**Never remove a worktree a live session still occupies**, and remove the
integration-driving session's own worktree last (playbook § 5 teardown checklist). For a
full investigate-and-clean pass across all worktrees, use `/cleanup-worktree`; to inventory
active worktrees, `/monday-prep` runs `git worktree list`.

---

**This command orchestrates; it does not own the parallel-session discipline.**
`docs/parallel-sessions-playbook.md` is the single source of truth for decomposition,
file-ownership maps, landing/merge, and teardown. Do not invent competing coordination
machinery here.
