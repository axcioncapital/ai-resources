# Risk Check — 2026-05-25

## Change

Bundle of 3 canonical-command edits — R3 + R4 + R6 from token-audit-2026-05-25-ai-resources.md §9.2. Plan-time gate before implementation.

**R3 / SF3 — `/create-skill` Step 3 output-to-disk fix** (file: `ai-resources/.claude/commands/create-skill.md`, lines ~33–46):
- (a) Remove main-session Read of `references/evaluation-framework.md` (307 lines) at Step 3; pass file path to evaluator subagent directly.
- (b) Update the inline evaluator subagent brief inside `create-skill.md` Step 3 (lines 33–46) to write findings to `audits/working/evaluation-{skill-name}.md` and return only file path + 1-line verdict (currently returns full 80–200 line report inline).
- Brings `/create-skill` into compliance with Subagent Contracts (CLAUDE.md → 30-line cap). Tripwire applies: reorders the subagent's output target from main-session to disk → automation-with-shared-state-effects on `audits/working/`.

**R4 — `/prime` pre-fetch log-trio** (file: `ai-resources/.claude/commands/prime.md`, Step 1):
- Extend Step 1 (which already reads `logs/session-notes.md`) to also tail-read `logs/decisions.md` (last 10 lines) and `logs/usage-log.md` (last 30 lines).
- Purely additive read at /prime entry. Eliminates recurring Edit-before-Read failure on session-notes.md (3 of last 4 sessions per usage-log).

**R6 — `/wrap-session` `coaching-data.md` tail-read** (file: `ai-resources/.claude/commands/wrap-session.md`, Step 7b around line 52):
- Replace full Read of `logs/coaching-data.md` (489 lines) with `Bash(tail -n 80 logs/coaching-data.md)`.
- Preserve a documented fall-back to full Read when structural lookup is needed (e.g., schema check, last similar-class entry).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/ — exists (directory)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/usage-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/coaching-data.md — exists

## Verdict

GO

**Summary:** Three isolated, single-file canonical-command edits that net-reduce per-invocation token cost, introduce no new permissions, follow established `audits/working/` and tail-read patterns already widely used elsewhere in the repo, and are reversible via `git revert` alone.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- R3 is net-negative on usage cost: removes a 307-line main-session Read (`evaluation-framework.md`, confirmed `wc -l = 307`) plus an 80–200-line inline subagent return, replaced by a path + 1-line summary per Subagent Contracts (ai-resources/CLAUDE.md lines 36–37 — "Summary cap: 30 lines … full findings go to a working-notes file"). `/create-skill` is pay-as-used (only fires on skill creation), so the savings accrue per skill-creation session.
- R4 adds two tail-reads at `/prime` entry: `decisions.md` last 10 lines (file is 50 lines total) and `usage-log.md` last 30 lines (file is 702 lines total). Cost is bounded at ~40 lines (~300–400 tokens) per `/prime` invocation. `/prime` runs once per session, not per-tool-call. The change is purely additive at a session-start entry point, well below the 50–150-token Medium heuristic when amortised across the session it primes.
- R6 is net-negative: replaces a full Read of `coaching-data.md` (confirmed 504 lines today, brief cites 489) with `Bash(tail -n 80 …)`. `/wrap-session` runs once per session. Roughly 80% reduction in that step's Read cost.
- No change to always-loaded files (workspace CLAUDE.md, ai-resources CLAUDE.md unchanged; no `@import` added). No new hooks, no new auto-loaded skills.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`, `ask`, or `deny` entries modified. The ai-resources settings already include `"Bash(*)"` and `"Write(**/.claude/**)"` plus broad workspace Edit/Write (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` lines 4–22), so `Bash(tail -n 80 …)` for R6 and Write-to-`audits/working/` for R3 are both already authorized.
- R3's subagent write target (`audits/working/evaluation-{skill-name}.md`) is the same directory already used by `log-sweep-auditor.md` (line 20), `friday-journal.md` (line 169), `audit-critical-resources.md`, and the documented Subagent Contracts pattern in `ai-resources/CLAUDE.md` line 37. Not a new permission surface; it is the established one.
- No scope escalation (project → user), no new tool family, no cross-repo or external API capability.

### Dimension 3: Blast Radius
**Risk:** Low

- Three discrete files, edited independently: `create-skill.md`, `prime.md`, `wrap-session.md`. No shared section, no cross-command coupling within the bundle.
- R3 callers: `grep -rl create-skill .claude/` returns 8 hits across `.claude/`; spot-checks show these are conventional cross-references (`/create-skill` mentioned in `request-skill.md`, `route-change.md`, `repo-dd.md`, etc.) — none parse Step 3's output shape or depend on a specific evaluator-return contract. The contract change (subagent return shape) is internal to `/create-skill` Step 3 → Step 4 within the same command, so no external caller is affected.
- R4 callers: `/prime` is invoked by the operator; downstream commands (`/session-start`, `/session-plan`) read `session-notes.md` independently. Additive reads of `decisions.md` and `usage-log.md` do not change `/prime`'s output contract (the brief format in Steps 5–6 is unchanged). Zero affected callers.
- R6 callers: `/wrap-session` Step 7b writes to `coaching-data.md`; nothing downstream depends on whether that step Read the file fully or tail-read it. The append shape (entry schema in Step 7b lines 52–61) is preserved. Zero affected callers.
- No shared infrastructure touched (no hooks, no scripts, no always-loaded CLAUDE.md). Single-file edits, ≤2 callers affected per change, no contract breaks.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are within-file modifications to canonical command files under version control. `git revert` on the bundled commit cleanly restores prior behavior with no residual state.
- R3's subagent write target (`audits/working/evaluation-{skill-name}.md`) is gitignored-or-tracked-only-when-committed working notes; even if a `/create-skill` run lands between the change and a hypothetical revert, the only residue is one extra file under `audits/working/` (an established staging directory with 140+ existing entries — `ls audits/working/ | wc` confirms). No log-mutation, no append-only state, no external write, no push side-effect.
- R4 and R6 are pure command-spec edits — no runtime artifacts created on first invocation that survive a revert.
- No automation (hooks, cron, symlinks) introduced.
- Operator muscle memory: command invocation syntax (`/create-skill`, `/prime`, `/wrap-session`) is unchanged — operator does not need to learn a new flag or argument.

### Dimension 5: Hidden Coupling
**Risk:** Low

- R3 explicitly aligns with the documented Subagent Contracts in `ai-resources/CLAUDE.md` (lines 32–40) and follows the same pattern as `token-audit-auditor`, `token-audit-auditor-mechanical`, `repo-dd-auditor`, `log-sweep-auditor`, and the `friday-journal.md` QC subagent (line 169). The contract is established, documented at the relevant location, and identical to existing implementations — no novel hidden dependency introduced.
- R4 reads `decisions.md` and `usage-log.md` by relative path under the cwd's logs directory. `/prime`'s existing Step 1 already uses the same convention (`logs/session-notes.md`), so the assumption that those log files exist at those paths is the same as the existing baseline. R4's brief is explicit about handling absence ("If the file doesn't exist…" pattern is the existing Step 1 idiom and should be carried into R4).
- R6 tail-reads `coaching-data.md`. The schema (per inspection of lines 1–30 and 410–499) is per-entry-uniform (~5–12 lines each), so tail-80 covers ~8–14 most-recent entries — sufficient for any "did I already log a similar class this session" check at wrap-time. The R6 brief documents a fall-back to full Read for structural lookups, which keeps the rare schema-introspection case covered.
- No silent auto-firing in unexpected contexts. No functional overlap with another mechanism. No undocumented new contract.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line citations from `create-skill.md`, `prime.md`, `wrap-session.md`, `ai-resources/CLAUDE.md`, and `.claude/settings.json`; `wc -l` line counts on the four log files and `evaluation-framework.md`; `grep -rl` reference counts across `.claude/`; directory listing of `audits/working/`; schema inspection of `coaching-data.md` (lines 1–30, 410–499). No training-data fallback was used.
