# Session Plan — 2026-06-09 S2

## Intent
Verify the `/prime` Step 0 autostash-over-rebase behavior on a dirty working tree in an isolated sandbox repo, covering both a clean stash-pop and a conflicting stash-pop. This closes the "Unverified-at-merge" carryover from the 2026-06-09 `/prime` hardening (Change 1).

## Model
sonnet — mechanical verification work (run git scenarios, observe, record). Active session is opus; `/model sonnet` optional, not required.

## Source Material
- `.claude/commands/prime.md` Step 0 — the exact command under test: `GIT_TERMINAL_PROMPT=0 git -C "$REPO" pull --rebase --autostash`, with the documented intent "a dirty working tree from a prior same-day session is stashed, rebased over, and popped back in one command."
- `logs/session-notes.md` 2026-06-09 `/prime hardening` entry, Next Steps — the carryover that scoped this test.

## Findings / Items to Address
The hardening's claim has two distinct sub-claims, only one of which the original note flagged:
1. **Clean-pop path** — dirty tree + remote-ahead commits touching *different* files. Expectation: autostash stashes the local change, rebases local commits over the remote ones, pops the stash with no conflict. Working change survives, tree is rebased.
2. **Conflict-pop path** — dirty tree where the uncommitted change touches the *same* lines a remote-ahead commit changed. Expectation: autostash stashes, rebases, then the pop hits a conflict. Key question: does `git` leave the repo in a recoverable state (stash preserved in `stash list`, conflict markers in the file), or is the local change lost? The note says "No action unless a future /prime reports a pop conflict" — so the real deliverable is documenting *what a pop conflict looks like* so a future operator can recover.

## Execution Sequence
1. Create a temp dir; init a bare "remote" repo + a "local" clone (all under the temp dir — never touches the live repo).
2. Seed a base commit, push to remote.
3. **Clean-pop scenario:** add a remote-ahead commit on file A; in local, make an uncommitted edit to file B + a local commit on file C; run the exact Step 0 command; record stash/rebase/pop outcome and final file state.
4. **Conflict-pop scenario:** add a remote-ahead commit editing line X of file A; in local, leave an uncommitted edit to the same line X; run the Step 0 command; record whether the pop conflicts, whether the stash is preserved, and the recovery path.
5. Write a short findings note (verdict per path) and report inline. Clean up the temp dir.

## Scope Alternatives
- **As scoped (both paths):** ~10–15 git commands in a sandbox. Right size — the conflict path is the one the carryover actually cares about.
- **Narrower (clean-pop only):** would leave the conflict-recovery behavior — the stated future-risk — unverified. Rejected.
- **Wider (patch prime.md with a recovery note if the conflict path is ugly):** out of this mandate's scope; if the conflict path is genuinely hazardous I surface it as a follow-up, not an in-session edit.

## Autonomy Posture
Full autonomy. Sandboxed test in a temp dir; no structural change classes; no edits to live repo state or prime.md.

## Risk
Negligible. All git operations run in a throwaway temp repo. No write to the live ai-resources tree, no network push, no `prime.md` edit. Worst case is a malformed test, re-runnable at zero cost.
