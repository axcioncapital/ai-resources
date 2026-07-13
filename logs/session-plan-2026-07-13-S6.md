# Session Plan — 2026-07-13

## Intent
Merge `session/2026-07-13-lean-repo` (carrying the completed `/lean-repo` audit) into `main`, reconciling the expected `logs/session-notes.md` conflict, then tear down the `ai-resources-lean-repo` worktree via `/close-worktree-session`.

## Model
sonnet — → `/model sonnet` (advisory only; the conflict reconciliation carries a judgment element — "no session entry may be lost" — so staying on the active opus is defensible and not worth a mid-chain switch)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/close-worktree-session.md` — the teardown command; read in full. Steps 4–6 are load-bearing for this plan.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — marker contract; Step 3 of the command reads today-dated markers inside the worktree.
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-lean-repo/audits/lean-repo-2026-07-13.md` — the artifact being landed (229 lines, on the branch only).
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md` — the conflict site.

## Findings / Items to Address

1. **The branches have diverged — this is a real merge, not a fast-forward.** `main` carries `5eeeea4` (the new `/close-worktree-session` command); the branch carries 3 commits (`f6d2c63` the lean-repo run, `fb8d72c` the inflow rule, `0eec3b9` the S5 wrap). `git merge-base --is-ancestor` returns false. A merge commit will be created.

2. **A conflict in `logs/session-notes.md` is near-certain.** The branch's S5 wrap ran an **archive sweep**: it deleted 122 lines from `session-notes.md` and moved them into a new `logs/session-notes-archive-2026-07.md`. Meanwhile `main` gained the S4 entry and (this session) the S6 header + mandate. Both sides edited the same file, and both appended near EOF. The archive-deletion region should auto-merge; the EOF append region likely will not.

3. **The working tree is dirty on the exact file being merged.** This session's S6 header + mandate are uncommitted in `logs/session-notes.md`. `git merge` will refuse to start ("local changes would be overwritten"). The stub must be committed first — this is a prerequisite, not an optional tidy-up.

4. **`/close-worktree-session` refuses to auto-resolve conflicts, by design** (command § "What this command refuses to do", and Step 4). On conflict it stops, reports the paths, and leaves the worktree and branch intact. This is the single most dangerous path in the command — proceeding to Steps 5–6 on a conflict is the one sequence that could destroy the work being merged. It has never been executed against a real conflict.

5. **The command is `disable-model-invocation: true`** (frontmatter line 4) — same as `/new-worktree-session`. I cannot invoke it via the Skill tool. **The operator must type `/close-worktree-session` on its own line.** This is a hard constraint on the execution sequence, not a preference.

6. **Marker collision, already averted — worth recording.** The branch's `session-notes.md` carries a `## 2026-07-13 — Session S5` header. This checkout's `logs/.session-marker` only knew about `S4`, so the standard marker-resolution rule (`marker + 1`) would have handed this session **S5** — a duplicate header the moment the branch merges. I took **S6** instead. The marker oracle does not account for session headers living on un-merged worktree branches; log this to `friction-log.md`.

## Execution Sequence

**Stage 1 — Commit the S6 stub (prerequisite).**
Commit `logs/session-notes.md` (S6 header + mandate) and `logs/runs/2026-07-13-S6.json` (the run-manifest start stub).
*Verify:* `git status --short` is clean, so the merge can start.

**Stage 2 — Operator invokes `/close-worktree-session` (first run).**
The command runs its guards (Step 1 resolve target, Step 2 worktree-clean, Step 3 no-live-session), then attempts the merge at Step 4.
*Expected outcome:* **conflict in `logs/session-notes.md`; command stops.**
*Verify:* the command reports the conflicting path and does NOT proceed to worktree removal or branch deletion. The worktree and branch both still exist. **This is the real test of the guard** — if it proceeds past a conflict, that is a critical defect and the session stops there.
*If the merge instead comes out clean:* good — the command runs to completion and Stages 3–4 collapse into it. Skip to Stage 5.

**Stage 3 — I reconcile the conflict by hand.**
Reconstruct `logs/session-notes.md` as the union of both sides: the branch's archive sweep (old entries removed, now living in `logs/session-notes-archive-2026-07.md`) **plus** every retained session entry from both sides — S5 (from the branch) and S6 (from main) must both survive.
*Verify (the mandate's exit condition):* grep the merged file plus the archive file and confirm **every** session entry S1–S6 is present in exactly one of the two. No entry dropped, none duplicated. Commit the merge.

**Stage 4 — Operator invokes `/close-worktree-session` (second run).**
Step 4's `git merge` now reports "Already up to date"; the command proceeds through Step 5 (`worktree remove`, never `--force`) and Step 6 (`branch -d`, never `-D`).
*Verify:* `git worktree list` shows only the main checkout; `git branch --list session/2026-07-13-lean-repo` is empty.

**Stage 5 — Verify the landing and log the marker defect.**
*Verify:* `audits/lean-repo-2026-07-13.md` exists on `main`; `docs/ai-resource-creation.md` carries the inflow rule; the S5 run-manifest (`logs/runs/2026-07-13-S5.json`) is present.
Then append the Finding-6 marker-collision defect to `logs/friction-log.md`.

## Scope Alternatives

- **Min** — merge by hand (`git merge` + resolve + commit), then remove the worktree and delete the branch with three raw git commands. Lands the work; leaves `/close-worktree-session` still never executed.
- **Recommended** — the sequence above: let the command drive the merge and prove its conflict guard on a real conflict, resolve by hand, then let it drive the teardown. Costs one extra operator invocation. **Chosen** because this repo's standing failure mode is commands that ship inert and are only proven by execution (RR-04 found exactly this: `code` was not on PATH, and only running the command revealed it). A conflict guard that has never met a conflict is an untested guard, and this is a free, real, low-stakes conflict to test it against.
- **Max** — additionally act on the `/lean-repo` report's findings. **Explicitly out of scope** per the mandate; that is a separate session.

## Autonomy Posture
**Gated** — not by choice but by construction: `/close-worktree-session` is `disable-model-invocation: true`, so the operator must type it. Everything between the invocations runs under full autonomy.

**Stop points:**
- Before each `/close-worktree-session` invocation — the operator types it; I cannot.
- **If the command proceeds past a merge conflict to worktree removal or branch deletion** — stop the session immediately and report. That is a critical defect in a brand-new command guarding against irreversible loss.
- **If the `session-notes.md` conflict cannot be reconciled without dropping a session entry** — surface it, do not force a resolution (mandate `Stop if`).
- Branch deletion is a named destructive git op (workspace `CLAUDE.md` Autonomy Rules #1). Mitigated: the branch is local-only and unpushed, the command uses `-d` (which refuses unless fully merged) and never `-D`, and the operator invokes the deletion step themselves. No separate confirmation prompt is added on top.

## Risk
No structural change classes apparent — this session merges an existing branch and removes a worktree; it creates no command, hook, skill, symlink, or always-loaded content, and edits no CLAUDE.md. `/risk-check` not required. Run it if scope changes (e.g. if acting on the lean-repo findings is pulled in).

**The one real risk is irreversibility on the teardown path**, and it is structurally contained: `worktree remove` (not `--force`) refuses on a dirty tree; `branch -d` (not `-D`) refuses on unmerged commits; and the merge is committed before either runs. If both refusals fire as designed, no work can be lost. The plan's job is to make sure they are allowed to fire — hence the hard stop if the command ever walks past a conflict.
