---
model: sonnet
---

Do NOT start working on the user's request yet.

**0. Session-marker check (advisory — nudge only, never create).** `/clarify` is often a session's first command. If a session skips `/prime`, later commands that write to `logs/` (`/wrap-session`, `/session-start`) hit a missing marker and either hard-fail or risk a markerless `session-notes.md` entry. Surface that early:

- Only run this check when the project uses session-notes logging: `logs/session-notes.md` exists in the cwd's git-root. If it does not exist, skip silently — `/clarify` stays minimal in projects without the marker convention.
- A today-marker is present when `logs/.session-marker` exists and its contents begin with today's date (`YYYY-MM-DD`). If present, skip silently.
- If `logs/session-notes.md` exists but no today-marker is present, emit exactly one line and continue:
  > Note: no session marker for today. `/clarify` does not start session tracking — per `docs/session-marker.md`, `/prime` is the only command that creates the marker. If this session will write to `logs/` later (`/wrap-session`, `/session-start`), run `/prime` first so those writes are attributed.

  Do NOT create, write, or modify any marker file (`logs/.session-marker`, `logs/.session-marker-*`, `logs/.prime-mtime`) or append a header to `logs/session-notes.md`. This step is detect-and-nudge only; creating a marker here would violate the single-source-creator contract in `docs/session-marker.md`.

Then do the following:

1. **Restate** — In one short paragraph, restate what you think the user is asking for in your own words.
2. **Assumptions** — List every assumption you would need to make if you started working right now.
3. **Clarifying questions** — Ask the questions that would most change your approach depending on the answer. Maximum 5 questions, ranked by impact.

Do not proceed until the user responds. After they answer, restate the updated understanding. Then remind the user to run `/scope` to lock the deliverables before execution — do not start work until `/scope` has been approved.

If the user wants Claude to pre-research each clarifying question against project files before answering, they may invoke `/decide` on the §3 list.
