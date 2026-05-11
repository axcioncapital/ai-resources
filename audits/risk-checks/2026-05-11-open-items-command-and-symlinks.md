# Risk Check — 2026-05-11

## Change

End-of-session change set bundled for one risk-check call:

(1) New shared command file `ai-resources/.claude/commands/open-items.md` — a strictly read-only scanner. When invoked it reads `logs/friction-log.md`, `logs/next-up.md`, `logs/improvement-log.md`, `logs/decisions.md`, `logs/session-notes.md`, `logs/session-plan.md`, and `inbox/*.md` in the operator's current working directory and prints an inline tiered backlog report. Tiers: T1 (likely needs action — friction unresolved, inbox briefs, next-up checkboxes, applied-but-unverified improvements), T2 (awaiting trigger — deferred decisions with stated trigger, recent open session questions), T3 (counts only for low-signal backlog). Universal `[BLOCKING]`/`[HIGH]`/`[CRITICAL]`/`[URGENT]` override. Hard exclusions for archives, `[LOW]`, `someday`, `nice-to-have`, `deferred indefinitely`. Two-mode: default and `full`. Model: sonnet. No Write, no Edit, no Bash, no external side effects — pure read-and-print.

(2) Eight project-level symlinks `projects/<name>/.claude/commands/open-items.md` → `../../../../ai-resources/.claude/commands/open-items.md`. Projects: axcion-ai-system-owner, buy-side-service-plan, corporate-identity, global-macro-analysis, nordic-pe-landscape-mapping-4-26, obsidian-pe-kb, project-planning, repo-documentation. Matches the established pattern used for shared commands like friction-log.md, prime.md, wrap-session.md.

(3) Edit to `ai-resources/.claude/commands/prime.md` — appended one new line to the printed status-block template:
   `**Backlog check:** Run \`/open-items\` to surface unresolved work in this folder.`
The edit is strictly additive (no removals, no logic change). The /prime flow itself is unchanged — just an extra advisory line at the end of the output.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/corporate-identity/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/.claude/commands/open-items.md — exists (symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/commands/open-items.md — exists (symlink)

## Verdict

GO

**Summary:** Three additive, opt-in changes — new on-demand command, project symlinks following the established pattern, and one advisory line appended to `/prime` output — with no token cost to always-loaded context, no permission surface change, and clean `git revert` reversibility.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New `open-items.md` command is invoked on demand (`/open-items`), not auto-loaded — slash-command files are lazy-read when called, not on every session start. Evidence: file declares only `model: sonnet` frontmatter (open-items.md:1-3) with no SessionStart/PreToolUse/Stop hook registration.
- The change does not touch any always-loaded file: no edits to workspace `CLAUDE.md`, repo `CLAUDE.md`, or `@import` chains. Verified by enumerating referenced paths — only `prime.md` and `open-items.md` are touched in `ai-resources/`.
- The added line in `prime.md` (line 54: `**Backlog check:** Run \`/open-items\` to surface unresolved work in this folder.`) is part of the printed output template, not part of the always-loaded prompt. It costs ~20 tokens only on `/prime` invocations, which the operator runs at session start — not per-turn.
- Symlinks themselves carry no token cost; they are filesystem pointers, not loaded content.

### Dimension 2: Permissions Surface
**Risk:** Low

- The command body explicitly states "No Write, no Edit, no Bash, no external side effects — pure read-and-print" (CHANGE_DESCRIPTION) and the command instructions confirm: "Use `Read` (and `Grep` where helpful) — do not write or edit any source file" (open-items.md:31).
- No new entry to `allow`, `ask`, or `deny` rules in any settings file is implied by the change. Read and Grep on repo files are already permitted by baseline settings — verified by inspecting the command's tool surface.
- Symlinks point inside the same repo tree (`ai-resources/.claude/commands/open-items.md`); no cross-repo or external capability is introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct file count: 1 new shared command, 8 symlinks, 1 edit to `prime.md` = 10 paths touched, but only 2 are non-symlink content files.
- Grep across `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` for `open-items` references: only 3 hits, all from this change set (the command file itself, the appended line in `prime.md`, and the session-notes entry that records the change). Zero pre-existing callers depend on `/open-items` — adding it cannot break anything that already references it.
- The `prime.md` status block is not machine-parsed by any downstream consumer. Grep for `"Backlog check"` returns only the line just added. Grep for the existing block fields (`**Last session:**`, `**Inbox:**`, `**Innovations:**`, `**Recent decisions:**`, `**Working tree:**`, `**Model:**`) shows they appear only in `prime.md` and historical logs — no parser, hook, or subagent reads this output. The status block is human-facing advisory text; appending one line cannot break a contract that doesn't exist.
- The 8 symlinks all use the same relative target `../../../../ai-resources/.claude/commands/open-items.md`. Verified all 8 resolve correctly via `ls -la` and `readlink`. Note: this diverges from the absolute-path convention used by older symlinks like `prime.md`/`friction-log.md`/`wrap-session.md` in the same project dirs — but relative form is already used by `so-monthly.md`, `system-owner.md`, and `implementation-triage.md` in `nordic-pe-landscape-mapping-4-26`, so the divergence is within established precedent and does not break anything.

### Dimension 4: Reversibility
**Risk:** Low

- All three change components are tracked by git and revertible cleanly:
  - `open-items.md` is a new file — `git revert` removes it.
  - The `prime.md` edit is a single appended line — `git revert` removes it.
  - The 8 symlinks are tracked filesystem entries — `git revert` removes them.
- No state propagates beyond the local repo (no `git push` step in this change set, no Notion write, no external API call, no log mutation).
- No hook, cron, or auto-firing automation is added — `open-items` only runs when the operator explicitly invokes it, so there is no window between landing and revert in which the command could mutate state. The command also writes nothing, so even repeated invocations between land and revert cannot dirty disk.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The command's parsing contract for each source file is explicitly named at the change site (open-items.md:33-41 — table mapping each source to tier and extract rule). No silent dependency on undocumented conventions.
- The command reads existing log files in **read-only** mode; it does not introduce a new contract that those files must honor. If `friction-log.md`, `decisions.md`, etc. change shape, `/open-items` may silently surface less but cannot break callers — there are none.
- No functional overlap with existing mechanisms. Verified by checking `friday-checkup.md`, `log-sweep.md`, `monday-prep.md` — these are heavier audits or weekly rituals, distinct in cadence and output from a per-session inline backlog scan.
- The `prime.md` advisory line is documented in the change site (CHANGE_DESCRIPTION explicitly notes "The /prime flow itself is unchanged — just an extra advisory line at the end of the output").
- Minor implicit coupling: the new command assumes the operator's cwd is a project folder containing `logs/` or `inbox/`. The command handles this explicitly — "If none of `logs/` or `inbox/` exists, print `No backlog sources found in this folder.` and stop" (open-items.md:29). The graceful-degradation path is named at the change site.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and referenced files). No training-data fallback was used on fetch/read failures.
