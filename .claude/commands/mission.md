---
model: sonnet
description: Mission contract lifecycle — designate, list, read, and close multi-session missions. A mission is a goal that spans many sessions; sessions bind to it at /prime and are measured against its validation contract by /drift-check. Advisory infrastructure only.
argument-hint: "[create <id> \"<name>\" | list | read <id> | close <id>]"
allowed-tools: Bash, Read, Write
---

A **mission** is a multi-session goal — e.g. "make the regime-shift project the canonical research-workflow template." Individual sessions (the fixes) serve the mission. The mission contract is a frozen file that `/prime` surfaces and folds into the session mandate, and whose **validation contract** `/drift-check` measures the session's trajectory against. This command is the mission's lifecycle: create / list / read / close.

**Design contract (load-bearing — do not violate):**
- A mission file lives at `<repo>/logs/missions/<id>.md`, where `<repo>` is the git-root of the repo whose work the mission primarily mutates (a mission about the shared library lives in `ai-resources/logs/missions/`).
- The file is **frozen at creation** like a `/contract-check` contract. Only `status` (frontmatter) and `## Open threads` change over its life, and **only via this command** — never hand-written from inside a working session, and never written to by `/session-start`. The Goal / scope / Validation contract are the north star and must not drift session-to-session.
- **"Sessions served" is never stored in the file.** It is computed at read time by scanning `logs/session-notes.md` for the `Mission: <id>` mandate bullet. This is deliberate — it removes any concurrent-write to the mission file from the session hot path (see `audits/risk-checks/2026-06-09-plan-time-gate-for-the-mission-contracts-subsystem-build.md`).
- This whole subsystem is **advisory**. Nothing here blocks a session.

---

### Step 0 — Resolve paths

1. `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel`. If the cwd is not a git repo, set `REPO_ROOT` = cwd.
2. `MISSIONS_DIR` = `REPO_ROOT/logs/missions`. `ARCHIVE_DIR` = `MISSIONS_DIR/archive`.
3. `AI_RESOURCES` = `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. `TEMPLATE` = `AI_RESOURCES/templates/mission-contract.md`.
4. `WORKSPACE_ROOT` = parent of `AI_RESOURCES`.

### Step 1 — Parse action

5. Read the first token of `$ARGUMENTS` as `ACTION` (`create` | `list` | `read` | `close`). If `$ARGUMENTS` is empty, default `ACTION` = `list`.
6. If `ACTION` is none of the four, abort with a one-line usage reminder:
   ```
   Usage: /mission [create <id> "<name>" | list | read <id> | close <id>]
   ```

---

### Step 2 — `create <id> "<name>"`

7. Parse `<id>` (second token; must be kebab-case — lowercase, digits, hyphens) and `<name>` (the quoted remainder). If `<id>` is missing or not kebab-case, abort and show the expected form. If `<name>` is missing, abort asking for a quoted name.
8. If `MISSIONS_DIR/<id>.md` already exists, abort: `Mission <id> already exists at {path}. Use /mission read <id>.` Do not overwrite.
9. `mkdir -p MISSIONS_DIR`. Read `TEMPLATE`. Substitute the frontmatter placeholders: `mission_id` = `<id>`, `mission_name` = `<name>`, `status` = `active`, `started` = today (`YYYY-MM-DD`, from `date +%F`). Leave the body section placeholders (`## Goal`, `## In scope / Out of scope`, `## Validation contract`, `## Open threads`) as authoring prompts.
10. Write to `MISSIONS_DIR/<id>.md`. Confirm in one line with the path. Then drive the operator to fill in the contract **before any implementation session** — this is the point of the command:
    - Goal must name a concrete deliverable, not a vague activity.
    - The **Validation contract** (acceptance assertions, non-negotiables, off-mission signals) should be written now, while the mission is fresh — it is what `/drift-check` will judge sessions against.
    - Offer to draft all of these from the current session context if any exists; otherwise ask the operator for them.

### Step 3 — `list`

11. Enumerate the same repo set `/prime` Step 1a uses: `REPO_ROOT`, `AI_RESOURCES`, and each git repo one level under `WORKSPACE_ROOT/projects/*/`. De-dupe by `git -C <dir> rev-parse --show-toplevel`. For each, look at `<repo>/logs/missions/*.md` — **active dir only, never `archive/`**.
12. For each mission file with `status: active`, count served sessions: `grep -c "Mission: <id>" <repo>/logs/session-notes.md` (0 if the file is absent). Treat the count as advisory — it reflects sessions that recorded the bullet.
13. Print one line per active mission: `<id> — <name>  [<repo-name>]  · <n> session(s)`. If no active missions exist anywhere, say so in one line and stop (this is the common case — keep it quiet).

### Step 4 — `read <id>`

14. Locate `<id>.md` — first under `MISSIONS_DIR`, then across the enumerated repos (Step 11), then `archive/`. If not found, abort naming where you looked.
15. Print the file's `## Goal`, `## In scope / Out of scope`, `## Validation contract`, `## Open threads`, and the frontmatter `status`.
16. Render **Sessions served live**: scan each enumerated repo's `logs/session-notes.md` for blocks whose mandate carries `Mission: <id>`; for each, print the session header (`## YYYY-MM-DD — Session S{N}`) and the one-line `**Mandate:**` summary. This list is computed here, not stored.

### Step 5 — `close <id>`

17. Locate `MISSIONS_DIR/<id>.md`. If absent, abort.
18. Set frontmatter `status: completed`. `mkdir -p ARCHIVE_DIR` and move the file to `ARCHIVE_DIR/<id>.md` (so `/prime` and `/mission list` active-scans stay bounded). Confirm in one line.
19. Do not delete session-notes history; the `Mission: <id>` bullets remain as the permanent record of what served the mission.

---

### Step 6 — No commit

20. `/mission` writes the mission file but does not commit it. The operator commits mission files alongside the work, or via `/wrap-session`. This command performs no git push.
