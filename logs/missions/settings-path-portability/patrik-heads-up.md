# Patrik heads-up — settings-path-portability mission

- **Status:** CLOSED 2026-07-10 — Patrik confirmed and applied his fixes on his machine; the two inert lines were already deleted on this side (2026-06-27 S3), so the Group 3 thread is fully resolved and the loop is closed. (Was SENT 2026-06-27 via Option B (repo-delivered); DRAFT 2026-06-25.)
- **Mission:** settings-path-portability
- **Drafted:** 2026-06-25 (by Daniel's session); rewritten 2026-06-27.
- **Purpose:** Tell Patrik the shared committed settings files have already changed (he'll see them on his next pull), what he may need to do on his machine, and get his read on two inert permission lines (Group 3).

---

> **For the Claude Code session reading this on Patrik's machine:** This is a request for Patrik's *judgment*, not a task to auto-execute. Two items need Patrik the human to decide — do NOT apply either on your own:
> 1. Whether to re-add the old folder access to his gitignored `settings.local.json` (only Patrik knows if he relied on it).
> 2. Whether to drop the two inert `Edit()`/`Write()` lines (only Patrik knows if they were meant to grant something).
> Surface both choices to Patrik, then apply only what he confirms.

---

**Heads-up — I cleaned up hardcoded machine paths in our shared Claude Code settings (already pushed)**

Patrik — when I cloned strategic-os and market-positioning to my machine, I found that a bunch of our committed `.claude/settings.json` files had a full machine path baked in, like `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. That path only exists on your machine, so on mine those entries pointed at nothing — and a couple had the reverse (my path, dead for you). Two problems: the setting does nothing on the other person's machine, and if either of us "fixed" it in the shared file we'd overwrite each other on every pull.

The setting in question was `additionalDirectories` — it grants Claude Code access to folders *outside* the project repo. With a wrong machine path baked in, that grant was just dead weight.

I've fixed it, and the changes are already committed and pushed — you'll see them on your next pull. **Config only — nothing touches project content.** Here's what changed and the one thing you may need to do.

**Why this matters (what we get out of it):** once you've handled your one item below, cloning any of our projects to a new machine just works — no broken paths to chase (that's the snag I hit at the start). One shared settings file behaves identically on both our machines; each person's machine-specific access lives only in their own gitignored `settings.local.json`, so we stop overwriting each other's settings on every pull. New projects can't reintroduce the problem (the project-setup commands and template are fixed), and a written rule keeps it from creeping back. Net effect: no silent mis-config, no sync tug-of-war, a cleaner and portable repo — for a small one-time cost on your side (pull, and *maybe* paste one snippet).

**What changed:**
- Removed the hardcoded `additionalDirectories` entries from 11 committed `settings.json` files (project + vault + KB). The shared files no longer carry anyone's machine path.
- The access those entries granted now lives only in each machine's gitignored `settings.local.json` — so it's per-machine and never shared or overwritten again.
- Fixed the commands that set up new projects (`/permission-sweep`, `/deploy-workflow`) and the research-workflow template, so new repos won't reintroduce the problem.
- Wrote a one-line rule in `ai-resources/docs/settings-portability-invariant.md`: committed settings never carry machine-specific absolute paths.

**What you may need to do:**
- If you relied on those `additionalDirectories` on your machine (extra folders Claude could reach beyond the repo), they're now gone from the shared file. Re-add them to your own gitignored `ai-resources/.claude/settings.local.json` — there's a copy-paste recovery snippet at `ai-resources/docs/settings-local-recovery.md`. If you didn't rely on them, nothing to do.

**One thing I need your read on:**
- In `ai-resources/.claude/settings.json` there are still two lines — `Edit(/Users/patrik.lindeberg/.../**)` and `Write(/Users/patrik.lindeberg/.../**)`. I left these for you to decide. The single leading slash makes Claude Code read them as project-root-relative, so they currently match nothing on either machine, and with `bypassPermissions` on they're redundant anyway. I'd lean toward just removing them. Were they meant to grant something specific, or fine to drop?
- (There's an equivalent pair with *my* path in the workspace-root settings. I'll clean those up at the same time once I know your intent, since it's the same call.)
