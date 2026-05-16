# Risk Check — 2026-05-16

## Change

End-time risk-check for the session's executed change set:

**Change 1 — ai-resources/.claude/commands/prime.md (committed):** Added a new Step 0 to /prime that runs `GIT_TERMINAL_PROMPT=0 git pull` on the cwd's git root, and additionally on ai-resources when cwd is in a different repo. Reports results in the Prime brief via a `**Pulled:** {repo}: {result}[ — N unpushed]` line. Includes a result table for `up to date` / `updated` / `skip (no upstream configured)` / `failed`, an unpushed-commits check using `git log @{u}..HEAD --oneline | wc -l`, and graceful skip when cwd isn't in a git repo.

**Change 2 — projects/nordic-pe-landscape-mapping-4-26/.claude/commands/prime.md (committed):** Replaced a 30-line standalone prime.md (legacy custom version) with a symlink pointing to ai-resources/.claude/commands/prime.md, aligning this project with the other 9 projects that already symlink.

**Effects:** Every /prime invocation across all 10 projects + ai-resources + workspace root now runs git pull at session start. Adds 2–4 bash calls per /prime. No permission changes (bash already allowed). No destructive operations. Reversible via Edit.

**Context:** Plan was QC'd (REVISE verdict, 4 findings addressed: workspace-root assumption, do-not-renumber, result-table specifics, GIT_TERMINAL_PROMPT=0 for credential safety). Operator-prompted refinement added the unpushed-commits visibility check. Three commits shipped (two in ai-resources, one in nordic-pe-landscape-mapping-4-26).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-landscape-mapping-4-26/.claude/commands/prime.md — exists

## Verdict

GO

**Summary:** Pay-as-invoked Step 0 with no always-loaded cost, no permission widening, well-defined fallbacks for every failure mode, and clean revertability — single residual concern is implicit dependency on the hardcoded `AI_RESOURCES` path, which is documented at the change site.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- /prime is pay-as-used, not auto-loaded — frontmatter shows `model: sonnet` and the file is a slash-command, not registered in any always-loaded CLAUDE.md or hook (verified by reading both copies of prime.md lines 1–3).
- Step 0 adds ~18 lines of instructions (prime.md L7–L24) to a command file that is read only on `/prime` invocation; no token cost on sessions where `/prime` is not invoked.
- Per-invocation bash overhead is 2–4 calls (rev-parse + 1–2 pulls + 0–2 unpushed-count checks), bounded and small relative to a typical /prime session footprint.
- No `@import` chain added; no skill description added; no SessionStart / PreToolUse hook registered.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`, `ask`, or `deny` entries added — change is in a command body, not in any settings.json.
- User-level settings already grant `Bash(*)` with the operator's accepted risk note ("Allow all bash commands without prompting, including git operations…") — `git pull`, `git rev-parse`, `git log` all fall inside the already-authorized surface.
- `GIT_TERMINAL_PROMPT=0` is a credential-safety narrowing, not a widening: it prevents `git pull` from hanging on a credential prompt and surfaces auth failures as fast non-zero exits handled by the result table (prime.md L17).

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 2 (ai-resources/.claude/commands/prime.md, projects/nordic-pe-landscape-mapping-4-26/.claude/commands/prime.md).
- Symlink enumeration confirms 10 project copies of prime.md now resolve to the same ai-resources file (`ls -la projects/*/.claude/commands/prime.md` → all 10 are symlinks to the canonical file). Behavior change is intentional and uniform across all consumers.
- Callers of `/prime` grep'd across `.claude/commands/` and `skills/`: 6 hits — `session-plan.md`, `save-session.md`, `session-start.md`, `repo-dd.md`, `skills/workflow-system-critic/SKILL.md`, `skills/worktree-cleanup-investigator/references/decision-taxonomy.md`. All are textual references ("run /prime", "after /prime") — none parse /prime's output format programmatically.
- Prime brief schema gained one new optional line (`**Pulled:** …` on prime.md L66). The existing brief consumers read by humans, not by structured parsers, so the added line is backwards-compatible.
- No shared infra mutated (logs, hooks, scripts untouched).

### Dimension 4: Reversibility
**Risk:** Low

- `git revert` of the two ai-resources commits restores Step 0 absence cleanly; the third commit (nordic-pe-landscape-mapping-4-26 symlink) reverts to a regular file — `git revert` reconstructs the prior 30-line standalone prime.md from the diff.
- No state mutation outside source control: the change only adds bash-execution instructions consumed at /prime time. No logs appended, no archives modified, no external system write.
- No hook auto-fires between landing and a potential revert — /prime is operator-invoked, not event-triggered.
- Side effect of having /prime'd a session under the new Step 0 (a single `git pull`) is itself reversible by `git reset --hard ORIG_HEAD` on the affected repo if the pulled commits are unwanted — but in practice "pull" against the operator's own remote is desired behavior.

### Dimension 5: Hidden Coupling
**Risk:** Low

- One explicit dependency: hardcoded `AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"` (prime.md L10). Coupling is documented at the change site (literal path written in the command body), so a host migration would surface the dependency immediately on first failure rather than silently drifting. Acceptable for a single-operator workspace.
- One implicit dependency on `git log @{u}..HEAD` requiring an upstream — explicitly handled at L22 with silent omission when the check fails (detached HEAD, no upstream), so no caller-visible breakage.
- No functional overlap with existing mechanisms: `monday-prep.md` L55–61 runs `git pull` on the workspace, but it operates on a different scope (workspace dir) and runs on a different cadence (weekly, operator-invoked) — the two do not race or double-pull the same repo within a session.
- No new contract that downstream callers must honor — Prime brief output is consumed by humans; the new `**Pulled:**` line is purely informational.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from prime.md, ls output enumerating 10 project symlinks, grep counts for /prime and git pull references, verbatim quote from user settings.json `Bash(*)` allow entry). No training-data fallback was used.
