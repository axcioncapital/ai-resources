# Session Plan — 2026-07-13

## Intent
Run `/new-worktree-session lean-repo` for the first time to create an isolated git worktree for the upcoming `/lean-repo` assessment, and verify the command works end-to-end in the real VS Code environment.

## Model
`sonnet` — the run itself is *doing* (execute a defined command, observe, log). → `/model sonnet` is available, but the session is short and the defect-diagnosis step (Step 4 below) is judgment work that benefits from the current `opus` tier. Staying on `opus` is a defensible cost for a ~15-minute session; switching is optional, not required.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-worktree-session.md` — the command under test (read in full)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md` — the authority the command defers to for worktree discipline
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/repo-redesign-authoritative-implementation-report.md` — RR-04's definition and rationale
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — defect destination if the run surfaces one

## Findings / Items to Address

Source: the RR-04 item in `plans/repo-redesign-authoritative-implementation-report.md`, plus two defects found during this session's `/prime`.

1. **RR-04 is a *run*, not a build.** `/new-worktree-session` was written 2026-07-04 and has never been executed. `git worktree list` confirms zero worktrees exist. Its correctness is therefore entirely unverified — it has passed no test but reading.
2. **The motivating incident is real and recent.** On 2026-07-13, two sessions in one checkout put overlapping questions to the operator and got *opposite answers approved*, because neither could see the other (source: `logs/scratchpads/2026-07-13-S2-repo-redesign-scratchpad.md` § "Concurrent-session signal"). File-watching guards structurally cannot catch a collision at the level of *decisions*. Separate worktrees can.
3. **The command cannot be model-invoked.** Its frontmatter carries `disable-model-invocation: true`, so I cannot fire it as a tool. The operator must type it. This is correct for the pilot — it tests the real command, not my transcription of it.
4. **Defect found during `/prime` (to be logged): the live-session oracle counts wrapped sessions as live.** `/prime` Step 1a treats any today-dated `logs/.session-marker-<id>` other than its own as a live foreign session. But wrapping does not delete the marker — markers are date-pruned, not liveness-pruned. This session's `/prime` therefore reported two live concurrent sessions when both (S1, S3) had demonstrably wrapped, with their notes and commits in HEAD. The warning is a false positive by construction, and it fires on *every* second-or-later session of any day. Owner artifact: `.claude/commands/prime.md` Step 1a.
5. **The pilot needs a payload.** An empty worktree is not a test. Payload chosen: the `/lean-repo` assessment (menu item 2), which last session's own note said "deserves its own assessment session." That session runs *in the worktree*, not here.

## Execution Sequence

1. **Operator invokes `/new-worktree-session lean-repo`.**
   *Verification:* the command's Step 1 resolves `BRANCH=session/2026-07-13-lean-repo` and `WORKTREE_PATH=<repo>/../ai-resources-lean-repo`.
   *Note:* `WORKTREE_PATH` lands as a sibling of `ai-resources/`, i.e. directly inside the workspace root — worth watching, since the workspace root is itself a git repo.

2. **Worktree creation.**
   *Verification:* `git worktree list` shows two entries; `git branch` shows the new session branch.
   *Halt condition:* if `git worktree add` errors, surface the exact stderr and stop. Do not retry blindly (the command's own Step 2 rule).

3. **VS Code window opens on the worktree.**
   *Verification:* a new window appears on `ai-resources-lean-repo`. If it does not, the command's `open_in_vscode` fallback chain (three tiers: `code` on PATH → bundled binary → `open -a`) failed at every tier — that is a defect worth recording, since the operator launches exclusively via VS Code.

4. **Diagnose the gap between claim and behaviour.**
   Compare what the command's Steps 3–4 *say* will happen against what did. Specific things to watch:
   - Does the SessionStart auto-sync hook fire in the new worktree and symlink `.claude/`? The command claims it does (Step 4).
   - Are `logs/.session-marker*`, `logs/.prime-mtime`, `logs/scratchpads/` genuinely gitignored, so they stay per-worktree? The command claims they are.
   - Does the new worktree's `logs/` tree exist at all, or does the worktree start from `main` without the untracked local logs the guards depend on?
   *Verification:* each claim is confirmed or contradicted with a concrete command output.

5. **Record defects.**
   Item 4 in Findings is already known and gets logged regardless. Any further defect from steps 2–4 joins it.
   *Verification:* an entry exists in `logs/friction-log.md` (or `improvement-log.md` for a proposed fix) naming the failure mode, root cause, prevention, and owner artifact per that log's schema.

6. **Hand off.** Tell the operator to run `/prime` in the new window and start `/lean-repo` there. This session ends; it does not follow them in.

## Scope Alternatives

- **Min** — create the worktree, confirm it exists, stop. Leaves the VS Code-window claim and the four Step-4 claims untested. Not recommended: it verifies only the one line of the command least likely to be wrong (`git worktree add`).
- **Recommended** — steps 1–6 above. Runs the command, tests its environmental claims, records defects, hands off.
- **Max** — additionally run `/lean-repo` inside the worktree this session, then tear the worktree down. Rejected: the command explicitly cannot move this session into the worktree, so the assessment cannot happen here. It belongs to the new window's session.

## Autonomy Posture
**Gated** — one unavoidable stop point, and it is structural rather than a matter of caution.

**Stop points:**
- **Before step 1.** I cannot invoke `/new-worktree-session` — it is flagged `disable-model-invocation: true`. The operator must type it. This is not a confirmation gate I chose; it is a hard capability boundary.
- **On any `git worktree add` error** (step 2) — surface stderr, do not retry.

## Risk
No structural change classes apparent — this session *runs* an existing command, it does not build or rewire one. The worktree and branch it creates are additive and fully reversible (`git worktree remove` + `git branch -d`). No hook, permission, CLAUDE.md, symlink, or new-resource change is in scope. Run `/risk-check` if scope changes.

**Environment-fit check — PASSES, and the check is load-bearing here.** `/new-worktree-session` is exactly the class of tooling this check exists to catch: a launcher whose value depends on how the operator triggers it. The known baseline is that the operator launches via the **VS Code extension**, not a terminal — and the 2026-06-10 S3 incident was a *terminal-only worktree launcher* (`cc-worktree.sh`) that shipped inert through a full gate chain. This command was written after that incident and is VS Code-native by design: its Step 3 opens a new VS Code window via a three-tier fallback (`code` on PATH → the app's bundled binary → `open -a "Visual Studio Code"`). The shape is right. Whether the fallback chain actually fires on this machine is precisely what step 3 of the Execution Sequence tests — and is the single most likely place for this pilot to find a real defect.
