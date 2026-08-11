---
task: work-loop-v2-concurrent-task-isolation
turn: codex
---

## Objective and scope

Make concurrent Claude and Codex work a safe, supported Work Loop v2 operating model: when another useful task starts, the system should handle routine isolation mechanics, preserve task-to-checkout continuity across handoffs, make ownership visible, and refuse duplicate ownership of either a logical task or a writable checkout.

The target operator experience is automatic creation or reuse of a dedicated task worktree when concurrent writing requires isolation, without requiring the operator to reason through Git mechanics. Human control remains mandatory for whether tasks genuinely belong together, merge and final landing decisions, conflict resolution, and destructive cleanup. Excluded are automatic push, merge, branch deletion, worktree deletion, conflict resolution, universal one-worktree-per-session behavior, a general scheduler, a persistent task registry, and any second semantic state system.

Task exit condition: the repository contains an implemented and evidenced minimum mechanism, integrated with Work Loop v2's existing entry and handoff surfaces, that safely supports two concurrent tasks in one repository on separate worktrees, rejects the same logical task in two worktrees, rejects two dispatched writers in one physical checkout, reuses the bound task worktree on later handoffs, and presents understandable ownership/status information.

Governing task method: apply the structural route in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md` inside the Work Loop v2 unit cycle: failure proof; blind fresh-context evidence review; causal model and structural options; Codex complexity challenge and operator scope lock; controlled Claude implementation; independent clean-environment verification; operator-controlled integration and representative fan-out-2 validation. Preserve this sequence through compaction and future unit rewrites without adding a second case document or state system.

## Lane and unit

Standard. Implementation mode. Unit 7 — prepare one clean, immutable verification checkout at the accepted candidate commit, without changing or testing the candidate.

Named reason for the loop: the work spans investigation, planning, implementation, and independent assessment; its scope crosses existing concurrency and transport controls and must remain bounded before changes begin.

## Brief

The bounded correction has passed its closure check, so the immutable candidate can now enter SOP Step B8. Codex must run that verification independently from a clean environment and cannot create or pin the environment with Git itself. Prepare only the clean verification checkout and hand its coordinates back; do not run the verification on Codex's behalf.

### Governing sources and fixed identity

- The repository-problem-resolution SOP Step B8 requires Codex to verify from a clean checkout or separate worktree without relying on Claude's test output.
- The accepted implementation candidate is exactly base `381559f` through tip `94807fde27ed05abd7b239328ee89fd8320dfc25`; the verification range is `381559f..94807fd`.
- The current task state remains authoritative in this bound checkout. The verification checkout is a read-only test target, not a second task binding or state interface.

### Required outcome

Create one clean, isolated local checkout at exact commit `94807fde27ed05abd7b239328ee89fd8320dfc25` that the current Codex session can use for independent execution. It must not share this repository's registered worktree set in a way that makes the active task state file appear replicated; a separate temporary local clone is acceptable. Leave it present for Codex and report its absolute path.

### Boundary and exclusions

- Do not modify the candidate, create a correction, run the candidate's verification suites, or interpret their results.
- Do not merge, push, integrate, land, clean up existing worktrees, or alter another task.
- Do not create or edit a task state file or `.owner` declaration in the verification checkout. This original state file remains the only Claude/Codex interface.
- Do not include the later state-only handback commits in the candidate under review; the checked-out source bytes must resolve to `94807fde27ed05abd7b239328ee89fd8320dfc25`.
- Ambient hook-written files in this bound checkout remain unrelated and uncommitted.

### Required evidence

Report the exact commands and output establishing:

1. the verification checkout's absolute path;
2. its checked-out commit is exactly `94807fde27ed05abd7b239328ee89fd8320dfc25`;
3. its working tree is clean before verification;
4. it is isolated from this repository's registered worktree/common-directory ownership surface;
5. no candidate verification test was run and no source file was changed;
6. this state-file handback is the only commit made for this preparation.

There is no meaningful regression suite for creating a disposable verifier environment. The falsifiable check is whether the environment exists, is clean, is isolated from the active repository's ownership enumeration, and contains the exact candidate bytes; failure of any one is a stop.

Completion condition: leave the clean environment available, record its exact path and the evidence above in `## Latest result`, set `turn: codex`, commit only this state-file handback in the bound implementation checkout, and stop. If the exact candidate cannot be prepared without changing it or replicating the active task into this repository's registered worktrees, hand back the obstacle instead of improvising.

## Latest result

Inspected (2026-08-11):

- Claim (1) the candidate is exactly base `381559f` through tip `94807fde27ed05abd7b239328ee89fd8320dfc25`, range `381559f..94807fd`: **HOLDS** — `git rev-parse 94807fd…^{commit}` resolves; `git log --oneline 381559f..94807fd` returns exactly two commits (`94807fd`, `8a24480`); `git merge-base --is-ancestor 94807fd HEAD` succeeds.
- Claim (2) the commits after the candidate are state-file-only: **HOLDS** — `git rev-list 94807fd..HEAD` returns one commit, `9cb25c7`, whose `--name-only` is the single path `logs/work-loop/work-loop-v2-concurrent-task-isolation.md`. Conversely `git show --name-only 94807fd` matched `logs/work-loop/` **0** times, so the candidate tip carries no state file.
- Claim (3) SOP Step B8 requires Codex to work from a clean checkout or separate worktree and not rely on Claude's output: **HOLDS** — read `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md:768-779`: "Gate 4 — Technical verification. Codex works from a clean checkout or separate worktree and does not rely on output pasted by Claude", and the B8 prompt's "run the commands yourself. Do not modify any files and do not merge anything."
- Claim (4) the task state remains authoritative and unique in this bound checkout: **HOLDS** — `work-loop-owner.sh check --depth repo` returns PROCEED, "exactly one state file and it is in this checkout", across the 15 registered worktrees.
- Claim (5) a separate local clone does not enter this repository's registered worktree set: **HOLDS, and measured after creation** — see evidence item 4 below, with a positive control.

Result: **the clean verification checkout exists, is pinned to the exact candidate, is clean, and is invisible to this repository's ownership enumeration. No verification was run and no candidate byte was changed.** This unit prepared an environment; it makes no claim about whether the candidate is correct.

### The verification checkout

```
/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd
```

It is a standalone `git clone --no-hardlinks --no-tags` of the bound checkout, detached at the candidate, with every local branch deleted and the `origin` remote removed. It sits outside the `Axcíon AI Repo` workspace directory, which is itself a Git repository — placing it inside would have made it untracked content of the workspace repo.

### Evidence

**(1) Absolute path** — `cd … && pwd -P` → `/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd`.

**(2) The checked-out commit is exactly the candidate.**

```
$ git -C <DEST> rev-parse HEAD
94807fde27ed05abd7b239328ee89fd8320dfc25
```

`git -C <DEST> status -sb` reports `## HEAD (no branch)` — detached, as intended. (Quoted inline rather than in a code block on purpose: at line start that output is indistinguishable from a Markdown heading, and this file's field count is read by grepping for one.)

**(2b) No ref reaches the state-only handback.** `git for-each-ref` returns **nothing** — there is no branch, no tag and no remote-tracking ref — so the single reachable tip is `94807fd`:

```
$ git -C <DEST> log --all --oneline -1
94807fd work-loop: concurrent-task-isolation unit 6 correction — …
$ git -C <DEST> merge-base --is-ancestor 9cb25c7 HEAD
  -> non-zero: the handback is NOT in HEAD history
```

`9cb25c7`'s object still exists in the cloned store but is unreachable from any ref. Stated rather than hidden: unreachable is not absent, and a deliberate `git cat-file` could still read it. What the requirement asks — that the candidate under review not *include* the handback — holds, because nothing reaches it.

**(3) The working tree is clean before verification.**

```
$ git -C <DEST> status --porcelain -uall | wc -l
0
$ git -C <DEST> diff --stat HEAD | wc -l
0
```

**(4) It is isolated from this repository's worktree/common-directory ownership surface.**

```
bound checkout common dir : …/Axcion AI Repo/ai-resources/.git
verification common dir   : .git            (its own, not shared)
$ git -C <SRC> worktree list | grep -c wl2-b8-verification
0
$ git -C <DEST> worktree list
  …/wl2-b8-verification-94807fd  94807fd (detached HEAD)     <- itself only
```

The check that could have failed, run in the bound checkout **after** the clone existed:

```
$ work-loop-owner.sh check --checkout <SRC> --task work-loop-v2-concurrent-task-isolation --depth repo
verdict: PROCEED   exit=0
reason: … task … has exactly one state file and it is in this checkout
```

**Positive control — the same command, same repo, on a task that genuinely is replicated:**

```
$ work-loop-owner.sh check --checkout <SRC> --task work-loop-v2-intake-router --depth repo
verdict: AMBIGUOUS   exit=4
reason: task 'work-loop-v2-intake-router' has a state file in more than one checkout and no
checkout declares it: …/ai-resources …/.codex/worktrees/02e6/ai-resources … (9 checkouts)
```

That control is what makes item 4 evidence rather than an assertion: the enumeration demonstrably *does* detect replication across the 15 registered worktrees, and it does not see the clone. The clone does carry a copy of this task's state file — at its `8a24480` bytes, `turn: codex`, verified byte-identical to `git show 8a24480:…` — but a separate repository is outside the enumeration, so it cannot make the live task look replicated.

**(5) No verification test was run and no source file was changed.** Items (3) and the `diff --stat HEAD` above are the measurement: a run of either suite could not leave the tree at zero tracked diff and zero untracked files. No `.owner` and no `.owner.lock` was created in the verification checkout. `logs/runs/` exists there and is **candidate content, not an artifact** — 90 files tracked at `94807fd` (`git ls-tree -r --name-only HEAD -- logs/runs`).

**(6) Only the state-file handback was committed.** `git log --oneline 9cb25c7..HEAD` was **0** commits before this handback; this handback is the first and only commit of Unit 7, and it touches one path. The verification checkout received no commit at all.

### Regression protection

There is none, and inventing one would be ceremony (core § 6 rule 5). The artifact is a disposable environment, not a repository change; the falsifiable checks *are* items (2)–(5), each of which could have read differently, and item (4) carries an explicit positive control. Item (2) would have failed had the clone landed on the branch tip rather than the candidate; item (4) would have failed had a linked worktree been used instead of a clone — which is precisely why a clone was chosen.

### Deviations and choices made

- **A clone, not a linked worktree.** `git worktree add` would have registered the new checkout in this repository's worktree set, which is the one thing the brief's required outcome forbids: the active task's state file would then have appeared in two enumerated checkouts and read `AMBIGUOUS` everywhere, breaking the live task. The brief allows a temporary local clone; that is why.
- **`--no-hardlinks`.** A default local clone hardlinks object files. Harmless in practice, but a true copy makes the isolation claim unconditional.
- **Branches deleted and `origin` removed.** So that no ref reaches past the candidate and there is no push path back to the bound repository.
- **Left writable, not `chmod`-ed read-only.** "Read-only test target" is read as *not a task binding, do not modify it* — not as filesystem permissions. Making it unwritable could break a harness that legitimately writes into its own sandbox, and choosing how Codex may run the suites is not this unit's call.
- **This checkout was not claimed.** Step 1.5 offers to write `.owner` on PROCEED. Unit 6's operator-approved brief explicitly excluded creating `.owner` for this live task, that exclusion was never lifted, and B8 is about to verify ownership behaviour — changing the live ownership state now would alter the environment under test.

### Advisory for Step B8 — worth knowing before starting

**Both regression suites run Git heavily.** `work-loop-owner.test.sh` and `dispatch.test.sh` create real repositories and real linked worktrees (`git init`, `git worktree add`, `git commit`) inside throwaway sandboxes — that is what makes them real rather than mocked. The Work Loop resources state that Codex never runs git. If that constraint extends to *executing a harness that shells out to git*, B8 cannot run the suites as written and the operator will need to run them, or run them alongside Codex. Flagged now rather than discovered mid-verification. This is an observation, not a recommendation to change anything.

### Deferrals — recorded, not implemented

Carried forward, all still open:

1. SKILL.md is 564 lines against slice-1's 340-line ceiling.
2. slice-1's `3.1a` allowlist is stale — 25 names against 56 files.
3. `.claude/hooks/detect-concurrent-session.sh` detects only `native-binary/claude`, so interactive Codex has no observable liveness signal.
4. **`work-loop-v2-intake-router` is replicated across 9 checkouts** and reads AMBIGUOUS today — measured again above as this unit's positive control. It is a live example of the state the mechanism refuses, and it will need the operator to name an owner at integration.
5. Sibling checkouts hold older `dispatch.sh` copies; with admission now failing closed, propagating the helper is part of integration rather than optional.
6. `logs/innovation-registry.md` and `logs/friction-log.md` are hook-written and dirty in the bound working tree; not authorised, so not staged.
7. A malformed declaration in another checkout names nobody and is skipped by the cross-checkout half — deliberate, commented at the call site.
8. The mutation lock has a one-minute stale takeover.

New this unit:

9. **The verification checkout is disposable and nothing will clean it up.** It is 127 MB of Git objects plus a working tree at `/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd`. Deleting it is destructive cleanup and therefore the operator's call, not mine — recorded so it is not forgotten after B9.

## Blocker

None.

## Next action

Codex: execute SOP Step B8 independently in `/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd`, which is pinned to candidate `94807fde27ed05abd7b239328ee89fd8320dfc25` and clean. Do not rely on the Unit 6 report's numbers — run the commands there yourself.

Read the advisory above first: both suites create real Git repositories and worktrees, so if Codex cannot execute git-invoking harnesses, that is a stop for the operator rather than something to work around.

Assess the five B8 questions against the candidate: does the original failure still occur; does the implementation match the approved R2 design; were unrelated changes introduced or committed; does the regression coverage genuinely represent the original failures rather than being written around the implementation; and does it exercise the real invocation path. Note for the fourth: F1–F3 and dispatcher case 12d were written to fail against the pre-correction scripts and were reported red against them, so the pre-correction scripts — reachable at `8a24480` in the verification checkout's history — are available for an independent red/green re-run.

Verification is technical evidence for the operator's Step B9 decision, not authorisation to integrate.
