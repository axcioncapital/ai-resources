# Risk Check — 2026-06-01

## Change

END-TIME gate. New command `/list-critical-resources` — EXECUTED change set. Created one file: `ai-resources/.claude/commands/list-critical-resources.md` (model: sonnet; identify-only; no agent, no hook, no settings change). It scans the ~69 command files, computes invoke-density (PCRE ripgrep with self-exclusion), git first-commit date, blast-radius evidence (risk-topology.md §1 + §2 reverse map), and lifecycle/choke-point role (system-doc.md §4.5 + session-rituals.md); filters to a backbone set; assigns a two-axis Critical/High tier; splits New vs Established by git date (default cutoff 30 days — changed from the planned 60 after a dry-run showed 60 lumped the early-April founding build in with genuinely recent additions); emits a mandatory staleness caveat when commands postdate risk-topology's last_updated; and writes ONE output file `ai-resources/audits/backbone-manifest.md` (overwrite each run) plus a chat echo. The command is read-only against all inputs; its only write is its own manifest. As part of this session the first manifest was also produced at `ai-resources/audits/backbone-manifest.md`. No other resource was edited. Two QC tweaks were applied post-write (named the invoke-density floor constant; lifted conditional-caveat guidance out of the fenced output template). The command auto-symlinks into all 7 projects at SessionStart via auto-sync-shared.sh like every shared command, but the symlink is inert (on-demand only, zero inbound callers).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/list-critical-resources.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/backbone-manifest.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/system-doc.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-rituals.md — exists

## Verdict

GO

**Summary:** A pay-as-used, read-only identify-only command with zero inbound callers, no hook/agent/settings change, and a single self-owned overwrite-each-run output — every dimension is Low.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added — the change is a single slash-command file under `.claude/commands/`, loaded only when invoked, not on every turn. Frontmatter declares `model: sonnet` (file line 2), no auto-load trigger.
- No hook registered — change description states "no agent, no hook, no settings change"; confirmed by grep: only inbound reference to `list-critical-resources` is the manifest's own output line (`./audits/backbone-manifest.md`), no hook file references it.
- No `@import` and no subagent spawned — file body uses `Read`/`Grep`/read-only `git` inline (file line 45), no `Task`/subagent invocation.
- Symlink propagation to 7 projects is inert: `auto-sync-shared.sh` symlinks every command file generically (hook lines 82–94), so this adds one more on-demand symlink with no per-session token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file touched — description states "no settings change"; the change set is one command `.md` plus its manifest.
- No new tool family — command body restricts itself to `Read`, `Grep`/ripgrep, and read-only `git` (file line 45: "Use `Read`, `Grep`/ripgrep, and read-only `git` only. Do not write or edit any source file."). These are already-established read patterns in the repo.
- Single write target is the command's own manifest under `ai-resources/audits/` (file lines 97, 133) — an already-established audit-output location, not a new or shared-state write surface.
- No external API, MCP, or cross-repo write introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 2 (the command file + the generated manifest). No other resource edited (description: "No other resource was edited").
- Inbound callers enumerated via grep across `ai-resources/` for `list-critical-resources`: 0 callers. The only hit (`./audits/backbone-manifest.md`) is the command's own generated output, not a caller.
- Inbound references to `backbone-manifest` (excluding the manifest itself and the command): 0. Nothing reads the manifest yet — the command file itself flags the `/pipeline-review` consumer as "Downstream opportunity (not built)" and "Deferred until that consumer is wired" (file line 10).
- No contract change to any existing caller — the command introduces a new output schema (the manifest), but no existing component depends on it.
- Reads cross-workspace vault docs (`risk-topology.md`, `system-doc.md`) read-only with an explicit degradation path if unreachable (file lines 30–33, 85) — reading shared docs, not mutating them.

### Dimension 4: Reversibility
**Risk:** Low

- The command file is a single new file — `git revert` / `git rm` removes it cleanly within the working tree.
- The manifest is overwrite-each-run (file line 97: "Overwrite `{AI_RESOURCES}/audits/backbone-manifest.md`"), not append-only — no accumulating log state that a revert would leave stale. Removing the file fully clears it.
- No settings/permission/cached state to clean up beyond git — no settings file changed.
- No state pushed beyond the local repo (no push, no external write, no Notion/API POST in the command body).
- The symlinks in 7 projects would dangle after the canonical file is deleted, but `auto-sync-shared.sh` and `/fix-symlinks` already handle broken-symlink cleanup as routine maintenance — this is the standard one-step cleanup for any shared-command removal, not a change-specific manual burden. Caps the dimension at the boundary of Low.

### Dimension 5: Hidden Coupling
**Risk:** Low

- New contract (the manifest format) is documented at the change site — the output template is specified inline in the command file (lines 101–123), and no caller is required to honor it yet (0 inbound callers).
- Dependencies on vault docs are explicit and named, not implicit: the command names `risk-topology.md §1/§2`, `system-doc.md §4.5`, and `session-rituals.md` sections directly (file lines 59–64) and ships a `VAULT_DEGRADED` fallback (file lines 33, 85) plus a mandatory staleness caveat when commands postdate `risk-topology`'s `last_updated` (file lines 93–95). The executed manifest demonstrates the caveat firing correctly (manifest line 3: "6 command(s) postdate it").
- No silent auto-firing — the command is on-demand only; it does not hook into any session event.
- No functional overlap that double-handles a concern — the command file explicitly distinguishes its blast-radius lens from `pipeline-review-registry.md`'s audit-cost lens and states the registry "is **not** read or reused" (file line 20).
- The named-constant `DENSITY_FLOOR = 4` (file line 71) is defined and reused internally (Steps 11 + 5), no external dependency.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from the executed command and manifest, grep counts for inbound callers across `ai-resources/`, the `auto-sync-shared.sh` symlink mechanism, and verbatim quotes from CHANGE_DESCRIPTION). No training-data fallback was used on fetch/read failures.
