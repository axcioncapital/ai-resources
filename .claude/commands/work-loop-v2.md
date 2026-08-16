---
model: opus
effort: high
argument-hint: "[the task id whose state file to act on — required; this command selects no task for you]"
---

Run Claude's half of one Work Loop v2 unit: read the task-state file, check the brief's premises against the live repository, then either hand back a false premise or implement the unit and hand back evidence. Codex frames and assesses; Claude owns repository reality and makes every commit. Not for small reversible fixes — those are Direct Work and open no state file (core § 2).

Input: `$ARGUMENTS` — **exactly one task id, and it is required.** An empty invocation selects nothing: this command does not scan `logs/work-loop/` for a candidate and does not pick a task on your behalf. If `$ARGUMENTS` is empty, say so, name that a task id is required, and stop without reading or changing any state file. The operator shorthands `y` and `ur turn` (core § 4) are not task ids and do not select one: they carry the turn the operator already holds, so an invocation that arrives with one of them and nothing else is an empty invocation and stops here.

This command requires the executable core on every invocation. Apply the resolver contract below,
then read the one absolute path it prints **before any other Work Loop action**.

<!-- work-loop-v2-core-resolution:start -->
### Resolve the executable core

Resolve the complete semantic-file path, never an `ai-resources/` directory. Two layouts are valid in
order: the canonical repository inside the verified workspace, then direct use from any checkout —
including a linked worktree — that shares a Git object store with a main checkout named
`ai-resources`. That is a shared-store plus name test, not a cryptographic repository identity: both
halves are load-bearing and neither may be dropped as redundant. The boundary is the current Git
repository plus, only at `WORKSPACE/projects/<one-child>`, that verified workspace Git repository.
Never walk higher. Run this exact Bash resolver in one call:

```bash
wl2_semantic_rel='plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md'
# No Bash positional parameters in this block — the slash-command expander owns those tokens
# and rewrites them at invocation. Each function reads its input from the wl2_*_in variable
# its caller sets on the line before the call.
wl2_git_top() {
  local wl2_top
  wl2_top="$(git -C "$wl2_top_in" rev-parse --show-toplevel 2>/dev/null)" || return 1
  (cd "$wl2_top" && pwd -P)
}
wl2_is_workspace() {
  [ -d "$wl2_ws_in/projects" ] && [ -d "$wl2_ws_in/ai-resources" ] || return 1
  wl2_top_in="$wl2_ws_in"
  [ "$(wl2_git_top)" = "$wl2_ws_in" ] || return 1
  wl2_top_in="$wl2_ws_in/ai-resources"
  [ "$(wl2_git_top)" = "$wl2_ws_in/ai-resources" ]
}
wl2_git_common() {
  local wl2_c
  wl2_c="$(git -C "$wl2_common_in" rev-parse --git-common-dir 2>/dev/null)" || return 1
  case "$wl2_c" in /*) ;; *) wl2_c="$wl2_common_in/$wl2_c" ;; esac
  [ -d "$wl2_c" ] || return 1
  (cd "$wl2_c" && pwd -P)
}
wl2_is_trusted_repo() {
  local wl2_common wl2_canon wl2_canon_top
  wl2_common_in="$wl2_trust_in"
  wl2_common="$(wl2_git_common)" || return 1
  case "$wl2_common" in */.git) ;; *) return 1 ;; esac
  wl2_canon="${wl2_common%/.git}"
  # Load-bearing: the shared store proves same-repo, the name proves which repo. Do not drop.
  [ "$(basename "$wl2_canon")" = 'ai-resources' ] || return 1
  wl2_top_in="$wl2_canon"
  wl2_canon_top="$(wl2_git_top)" || return 1
  [ "$wl2_canon_top" = "$wl2_canon" ] || return 1
  wl2_common_in="$wl2_canon"
  [ "$(wl2_git_common)" = "$wl2_common" ]
}
wl2_top_in="$(pwd -P)"
wl2_repo_root="$(wl2_git_top)" ||
  { echo 'ERROR: Work Loop v2 cannot resolve its repository boundary.' >&2; exit 1; }
wl2_workspace_root=''
wl2_ws_in="$wl2_repo_root"
if wl2_is_workspace; then
  wl2_workspace_root="$wl2_repo_root"
else
  wl2_projects_dir="$(dirname "$wl2_repo_root")"
  wl2_workspace_candidate="$(dirname "$wl2_projects_dir")"
  wl2_ws_in="$wl2_workspace_candidate"
  if [ "$(basename "$wl2_projects_dir")" = 'projects' ] &&
     wl2_is_workspace; then
    wl2_workspace_root="$wl2_workspace_candidate"
  fi
fi
wl2_semantic_path=''
wl2_attempted=''
wl2_try_semantic() {
  local wl2_dir
  wl2_attempted="${wl2_attempted}${wl2_attempted:+; }$wl2_cand_in"
  [ -f "$wl2_cand_in" ] && [ -r "$wl2_cand_in" ] && [ ! -L "$wl2_cand_in" ] || return 1
  wl2_dir="$(cd "$(dirname "$wl2_cand_in")" && pwd -P)" || return 1
  case "$wl2_dir/" in "$wl2_root_in/"*) ;; *) return 1 ;; esac
  wl2_semantic_path="$wl2_dir/$(basename "$wl2_cand_in")"
}
wl2_workspace_path=''
if [ -n "$wl2_workspace_root" ]; then
  wl2_workspace_path="$wl2_workspace_root/ai-resources/$wl2_semantic_rel"
  wl2_cand_in="$wl2_workspace_path"
  wl2_root_in="$wl2_workspace_root/ai-resources"
  wl2_try_semantic || true
fi
wl2_direct_path="$wl2_repo_root/$wl2_semantic_rel"
wl2_direct_reason=''
if [ -z "$wl2_semantic_path" ] && [ "$wl2_direct_path" != "$wl2_workspace_path" ]; then
  wl2_trust_in="$wl2_repo_root"
  if wl2_is_trusted_repo; then
    wl2_cand_in="$wl2_direct_path"
    wl2_root_in="$wl2_repo_root"
    wl2_try_semantic || true
  else
    wl2_direct_reason='direct_identity=untrusted'
  fi
fi
if [ -z "$wl2_semantic_path" ]; then
  printf 'ERROR: Work Loop v2 semantic source not found within permitted boundary. repo=%s workspace=%s attempted=%s%s\n' \
    "$wl2_repo_root" "${wl2_workspace_root:-none}" "${wl2_attempted:-none}" \
    "${wl2_direct_reason:+ $wl2_direct_reason}" >&2
  exit 1
fi
printf '%s\n' "$wl2_semantic_path"
```

Read exactly the printed file. A nonzero exit is terminal: report it and stop without a relative-path
fallback. The file is the contract for roles, unit cycle, state, vocabulary, safety, and stopping.
Where this resource and the core disagree, the core wins; report the disagreement as a defect.
<!-- work-loop-v2-core-resolution:end -->

This command is not a session lifecycle command. It does not invoke `/prime`, `/session-start` or `/session-plan`.

**Scope of this version — Slices 1–3, Claude side.** Behaviours 1.2, 1.3, the fresh-session pickup (2.1), file-identity rejection (2.2), Claude's half of the bounded correction (2.3, 2.4 — the Correction rounds section below), and admission discipline: the admission test (Admission below), de-escalation (De-escalating below), and mid-unit deferrals (Step 4). Plus the unit's mode (2026-08-06 — The unit's mode below), which Codex classifies and you execute against. Plus the hop-termination contract (2026-08-14 — Ending the hop below) and the `Dominant deliverable` check, which answer a hop that ended on a progress note and a unit packaged too large for one hop.

Context Engineering is live on the Codex side. This command **consumes** the engineered brief — checking its claims against the repository and acting on it — and never performs Codex's preparation, authority or selection judgments itself. The governing autonomy rule over that consumption is core § 8; read it there rather than restating it here.

---

## Step 0 — Is Work Loop actually deployed here?

Runs before anything else in this checkout — before admission, before the state file is opened, before the validator. Nothing below this line happens until it passes.

Running one unit needs five separate things present in the same checkout, and they arrive by four different routes. A checkout can hold this command and be missing any of them: the command is symlinked into projects by the generic SessionStart sweep, while the two helpers are template-deployed copies, the Reorient skill is a manifest opt-in, and the compact hook needs a registration to fire at all. Discovering that halfway through a unit is the failure this step exists to prevent — by then the state file has been read, the turn is in play, and the missing piece is whichever seam happened to be reached first.

```bash
bash logs/scripts/work-loop-capability.sh check --checkout "$(git rev-parse --show-toplevel)"
```

It prints `verdict:` followed by exactly one of these, and acts on nothing else:

- **`READY`** (exit 0) — all five components are present. Continue to Admission or Step 1.
- **`INCOMPLETE`** (exit 3) — one or more are missing or drifted. Each is named on its own `missing:` or `drifted:` line. **Stop.** Report those lines to the operator in plain words, change nothing, open no state file, and make no commit. The fix is `/sync-workflow` in that checkout, not a workaround here: a partial checkout cannot finish the unit it would be starting, and beginning one leaves a task open in a checkout that cannot carry it.
- **`NOT_APPLICABLE`** (exit 2) — the checkout does not carry `.claude/commands/work-loop-v2.md`. That cannot happen while this command is running, so treat it as a contradiction, report it, and stop.

**If the check cannot run, stop.** A missing, unreadable or failing `logs/scripts/work-loop-capability.sh` means deployment completeness is unestablished, and there is no second reading to fall back on — exactly as with the validator in Step 1 and the ownership helper in Step 1.5. Report that it could not run, name its path in this checkout, change nothing, and stop.

**This step checks deployment, not lifecycle and not ownership.** It never opens a task record and never reads `task:`, `status:` or `turn:`. Passing it says the tools are here; it says nothing whatever about whose move it is, which Step 1 settles, or whether this task belongs here, which Step 1.5 settles. Neither of those is skipped because this one passed.

## Admission — Direct Work or the loop

Runs when the work arrives without a state file — the operator brings a request rather than a task id.

**Core § 2 owns this test.** Read it there and apply it. What this command does with each outcome:

- **Not admitted** — name the part of core § 2 that excluded it, do the work directly if that is the answer, and **open no state file**. `logs/work-loop/` is left untouched; the absent file is the evidence that admission was refused.
- **Admitted** — the named reason core § 2 requires is already written in the state file. If it is missing, the brief is malformed: hand back under Step 3 rather than supplying a reason on Codex's behalf.

When invoked on an existing state file that carries its reason, admission was decided at open — go to Step 1.

## Step 1 — Orient

`{task-id}` comes from `$ARGUMENTS` and from nowhere else. **There is no candidate scan.** This step used to fall back to "the single file under `logs/work-loop/` whose `turn:` is `claude`", and that fallback is removed: selecting a task by reading turns is a lifecycle inference, it silently picks up a record the operator never named, and it made an empty invocation act on whatever happened to be open. An empty `$ARGUMENTS` stops here.

Read the repository, not the conversation (core § 3 step 1).

**Classify the state file with the validator, read-only, before anything else is done with it.** This is the one lifecycle authority (core § 4); do not read `task:`, `status:`, `turn:` or the body shape to work it out yourself:

```bash
bash logs/scripts/work-loop-state.sh validate --checkout "$(git rev-parse --show-toplevel)" --task {task-id}
```

It prints exactly one of `ACTIVE_CLAUDE`, `ACTIVE_CODEX`, `BLOCKED_OPERATOR`, `CLOSED` and exits `0`, or it exits non-zero naming the invariant the record violates. Act on that and nothing else:

- **`ACTIVE_CLAUDE`** — your move. Continue.
- **`ACTIVE_CODEX`** — Codex's move. Say so and change nothing.
- **`BLOCKED_OPERATOR`** — the task waits on the operator. Report the condition recorded under `## Blocker` and change nothing. It is **not** finished, and it does not become your move because it is stopped.
- **`CLOSED`** — terminal. Say so and change nothing.
- **Non-zero** — the record is malformed, contradictory, or its identity disagrees with `{task-id}`. This is core § 6 rule 2's read-only rejection: report the validator's diagnostic in plain words and **change nothing**. No inspection record, no turn flip, no commit; the rejection leaves no trace in the file, and that is the point. If it is not obvious which side is correct, the report ends with the question for the operator (core § 7). Then stop.

**If the validator cannot run, stop.** A missing, unreadable or failing validator does not mean "carry on and read the frontmatter yourself" — it means the lifecycle is unestablished, and there is no second reading to fall back on. Report that it could not run, name its path in this checkout, change nothing, and stop.

If `## Next action` opens with core § 3's hand-off token, this invocation is the one bounded correction, not a new unit — go to **Correction rounds** below and skip Steps 2–5.

If `## Next action` opens with core § 3's close token, Codex has decided closure and this invocation writes the closing record — go to **Closing the task** below and skip Steps 2–5.

### Step 1.5 — Check ownership before executing or committing

Resolving the file under the checkout you are running in establishes *where the file is*. It does not establish *whether this task belongs here* — a state file replicates across worktrees on merge, so its presence is not evidence of ownership. Run the shared check before any execution and before any commit:

```bash
bash logs/scripts/work-loop-owner.sh check --checkout "$(git rev-parse --show-toplevel)" --task {task-id} --depth repo
```

`--depth repo` is Claude's depth, and it is the whole reason this step sits on Claude's side: it enumerates the registered worktrees, which needs git, which Codex may not run. Interactive Codex checks only whether *its own* checkout is claimed by another task. The two halves together are the mechanism; neither is it alone.

Act on the verdict, and do not work around it:

- **PROCEED** — continue to Step 2. Where the task has no declaration yet and this checkout holds its only state file, claim it (`claim` in place of `check`, same arguments) so later handoffs return here.
- **REFUSE** — the output names the conflicting task or checkout. Stop, report it in plain words, and change nothing. This is not a premise failure and not a hand-back: it is a routing error, and the fix is to continue the task in the checkout named, not to edit anything here.
- **AMBIGUOUS** — ownership cannot be established, normally because the state file is replicated across checkouts with none of them declaring it. **Never resolve this by claiming.** Report it and stop for the operator (core § 7) — deciding which copy is authoritative is theirs.

**If the check cannot run, stop.** A missing, unreadable or failing helper is not permission to continue — it means ownership is unestablished, which is exactly the state this step exists to refuse. Report in plain words that the check could not run and what would fix it (the helper's path in this checkout), change nothing, make no commit, and stop for the operator. Continuing on an absent check would leave older or incomplete checkouts on the very path this step closes.

## Step 2 — Check the premises before acting

Core § 6 rule 1 governs this step. The claims are the brief's load-bearing repository assertions. Core § 3 owns their placement: a brief may mark each claim in place where it states it, or gather them under one collecting heading — both are valid, and each claim names the surface and the pattern or evidence that settles it. So read the whole brief for them, and do not conclude there are none because any particular heading is absent. Check each **by inspection** — open the file, run the grep, read the line. Not by recall.

Write an inspection record into `## Latest result`, in this shape. The shape is the command's output contract; the acceptance harness binds to it. If that harness must be read, rerun § Resolve the executable core with `wl2_semantic_rel='logs/scripts/work-loop-v2-slice-1.test.sh'` and use only the complete path it returns.

```
Inspected (YYYY-MM-DD):
- Claim (1): HOLDS — searched `<path>` for `<what>`; found `<what was found>`.
- Claim (2): HOLDS — searched `<path>` for `<pattern>`; no match.
```

Two rules govern that record:

- **Every claim gets a line, including the ones that hold.** A run that found no problem must still show what it looked at, or a later reader cannot tell inspection from assumption.
- **An absence claim names the surface *and* the pattern** (core § 6 rule 3). In this record that is the `searched <path> for <pattern>` clause, not a bare "there is no `Status:` line".

**Premise checking is not proportional; the record is.** Wherever being wrong about a claim could change the work, check it by inspection before acting and write down what you looked at — core § 6 rules 1 and 3 are untouched. Two cases legitimately produce no record at all:

- **Direct Work** — no state file exists, so no record arises.
- **A simple prose or documentation change with no load-bearing premise to test.** Omit the `Inspected (YYYY-MM-DD):` block and write one line saying there was no load-bearing premise to check. That line is cheaper than a fabricated claim and more honest than a record listing claims invented to fill it.

**The deciding question is not "is this unit small?" but "would being wrong about a premise here change the work?"** A one-line prose fix that rests on a file existing where the brief says it does still has a premise worth checking. A rewrite whose only premise is the current text — visible in the change itself — does not.

**Nothing replaces the absent record.** No proportionality statement, no tier label, no justification field, no checklist. The absence *is* the lighter path; anything new to fill in on every run would trade one ceremony for another and cost more than the record it replaced.

## Step 3 — If a claim is false, hand back and stop

Core § 1 and core § 7 *Hand back to Codex* govern this step. Do all of this and nothing else:

1. Mark the claim in the inspection record: `- Claim (N): FALSE — searched <path> for <what>; not present.`
2. Write the finding into `## Blocker`, replacing `None.`, naming the claim that failed and what was actually found.
3. Set `turn: codex` in the frontmatter and leave `status: active`. A hand-back is Codex's move on a task that is still running; it is not a stop for the operator, so it is neither `blocked` nor `closed`.
4. Set `## Next action` to what Codex must decide.
5. `git add` the state file **by explicit pathspec**, then commit.
6. **Stop.**

**Change no other file.** Not the file the brief named, not a "small fix while I'm here". A false premise means the unit does not begin — `git diff` across every file the brief named must be empty. Building the missing thing so the claim becomes true is the specific failure this behaviour exists to prevent.

## Step 4 — If every claim holds, implement the unit

Stay inside `## Objective and scope`. A change that would touch anything the scope excludes is a hand-back under Step 3's rules, not a judgement call (core § 6 rule 4).

**How much work, and how much evidence, is core § 3's *good enough, proceed* judgment.** Read it there; it is not restated here.

**An adjacent improvement noticed mid-unit is a deferral, not work** (core § 5). Record it in the hand-back in plain words — what it is, and why it is not being done now — and leave it unimplemented. A deferral that is neither recorded nor implemented has silently disappeared, which is the failure.

**A discovery unit is inspected, not implemented** (core § 3 step 4). When the brief's completion condition is to establish and return evidence about a named unknown rather than to change the repository, the unit's work is the inspection itself: examine the named surfaces, and write what was found into `## Latest result` with evidence that could have read differently (core § 6 rules 3 and 5). The inspection record still appears even when such a brief pre-states few or no claims — the discovery's own findings are the record. Then hand back under Step 5 for Codex to reframe or stop. Do not implement the eventual target, and do not treat the returned evidence as permission to proceed with it.

## The unit's mode

Core § 3 *The unit's mode* owns the three modes and what each requires. `## Lane and unit` records which one is open. This is what each changes for you:

- **Discovery** — inspect, do not implement. Step 4's discovery-unit rule already describes the work; the mode is what tells you in advance that it applies.
- **Implementation** — build it, and return the failing case, the implemented result, and the regression protection relevant to the change. Where no meaningful regression check exists, say so and say why, rather than inventing one that cannot fail (core § 6 rule 5). **A prose, documentation or instruction-file change is the ordinary instance of that case, not an exception to argue for.** Its evidence is the changed text quoted against what it replaced, plus one line on why no automated check would distinguish success from failure. A check that greps for a word the brief already supplied is not evidence — the Codex skill names that as the commonest way a unit looks done and is not. **Where the artifact is executable** — a script, a hook, a test harness — the failing case is still required, unchanged.
- **Adoption** — the capability already exists. Return evidence about how it behaves in operation — reliability, operator burden, failure conditions, usefulness — and end with the lifecycle decision the brief asks for. Do not build the eventual target, and do not read operating evidence as permission to proceed with it.

**A mode that disagrees with the brief's own completion condition is a false premise** — hand back under Step 3. A unit recorded as Implementation whose completion condition asks only for evidence and a hand-back has not been classified; it has been mislabelled, and building from it is the error the check exists to prevent.

### The brief's packaging lines

Every brief carries packaging lines, which the Codex skill's § *Size the unit against the clock* owns and writes. **How many depends on the mode recorded in `## Lane and unit`.**

Three lines on every unit, in every mode:

```
Dominant deliverable:
Evidence required in this hop:
Evidence explicitly deferred:
```

One more in **Implementation** mode only:

```
Primary edit begins after:
```

A unit in Discovery or Adoption mode makes no primary edit — it inspects and hands back (core § 3 *The unit's mode*) — so that line does not apply to it and its absence is correct, not missing.

Two values satisfy that line. A **targeted failing case** is the ordinary one. A **quoted before-state** is valid where no meaningful failing test exists — the prose, documentation and instruction-file case § The unit's mode already names, where the evidence is the changed text quoted against what it replaced. Where the artifact is executable, only the failing case will do.

`Evidence explicitly deferred:` carries `None.` when nothing was held back. `None.` is a completed line, not an empty one — treat it as satisfied.

Check them at Step 2, alongside the brief's claims. **Three shapes are a false premise — hand back under Step 3:**

- **A line its mode requires is missing or empty.** Name which. The packaging decision was not made, and a unit whose size nobody decided is the one that spends the hop and returns nothing.
- **`Dominant deliverable:` names more than one deliverable.** Name both. That line admits exactly one entry, and two is how an oversized unit announces itself before the clock finds it.
- **`Primary edit begins after:` appears on a unit in Discovery or Adoption mode.** It names an edit the recorded mode forbids, so either the line or the mode is wrong — which is the misclassification § The unit's mode already hands back.

**Hand the brief back; do not fill the lines in yourself.** Sizing the unit is Codex's judgment, and supplying it here is the silent-repair failure Step 3 already forbids. Repackaging is one cheap Codex move — far cheaper than the 902-second timeout that produced this rule.

A brief written before this contract existed carries none of the four lines and is handed back on its next invocation. That is the intended behaviour, not a regression: it is one bounce, and it converts the backlog to the new shape at the moment each unit is next touched.

## De-escalating — when the work turns out smaller

Core § 2 *De-escalating* decides when this applies — inspection or implementation is where Claude notices it. When it does apply:

1. Say so, in plain words.
2. Reduce the state file to the closing record (core § 4), recording under `## Decisions that matter` that the task de-escalated and what was learned. Set `status: closed` and `turn: operator`.
3. Finish the work directly, as Direct Work.
4. `git add` the state file and the changed files by explicit pathspec, commit once, stop.
5. **Only after that commit exists, clear the checkout's declaration** — exactly as **Closing the task** step 3 below, and in that order for the same reason. A de-escalated task ends its lease like any other, but it ends it after the closed state is committed, never before.

## Step 5 — Write the result and the evidence

Into `## Latest result`, below the inspection record:

```
Result: <what actually happened — the latest material result, not a history>
Evidence: <the check, what it returns now, and what it returned before>
```

**The evidence must be able to fail** — core § 6 rule 5, including how to prove it.

The state file is current truth, not a diary (core § 4): replace the previous result rather than appending to it.

Then set `turn: codex` and leave `status: active`, set `## Next action` to what Codex assesses, `git add` by explicit pathspec — the state file and the files the unit changed — and commit.

## Ending the hop

**Every invocation ends in an explicit outcome. Once an invocation passes the refusal gates, that outcome is written into the state file and committed before you stop.**

The refusal gates are Admission, Step 1's turn and identity checks, and Step 1.5's ownership check. They come first and they decide whether a written outcome is owed at all — a refusal is *required* to leave the file untouched, so a rule demanding a write from every invocation would break exactly the paths that work.

- **Whichever step you are in, it names the write.** Step 5 writes the result and evidence; Step 3 writes the failed premise; Correction rounds writes the corrected result; De-escalating and Closing the task each write the closing record; core § 7 writes a blocker or an operator question. This is deliberately not an exhaustive list to match against — the step you are in owns its own write, and the invariant is that one of them happened.
- **An invocation stopped at a refusal gate writes nothing and commits nothing** — a turn that is not yours, a file-identity mismatch, an ownership REFUSE or AMBIGUOUS. You will have *read* the file to establish those; the invariant is no state-file **write**, not no read. Say which refusal applied. That silence in the file is the recorded outcome, not a missing one.
- **Work that admission sent to Direct Work opens no state file at all.** It is done and committed in the ordinary way — the absent file is the evidence admission was refused, and says nothing about whether the repository changed.

**A hop that announces what it is waiting for has produced none of these.** "Waiting for the baseline run to finish before editing" is a progress note; the state file is unchanged, the dispatcher reads exit `22` — no transition — and the hop is spent. Where you are waiting on something, finish waiting inside the hop and act on the answer, or stop waiting and record the blocker.

**Own every command you start.** A command you launched in the background is awaited to completion or terminated within this same hop, and its result — or the fact that you stopped it — reaches the state file before you stop. Leaving one running hands the next hop a process it did not start and cannot account for.

**Evidence the brief requires cannot be deferred by you.** Where a required check will not finish inside the hop, that is a **blocker** — record it in `## Blocker` and hand back. Only what the brief already lists under `Evidence explicitly deferred:` stays deferred, because Codex decided that when it sized the unit. Downgrading required evidence to a deferral because the clock ran out is how a hop reports success it did not earn, and core § 6 rule 5 is what it breaks.

Running the focused case the brief's `Primary edit begins after:` line names is the right move when a broad run will not fit — it is what that line is for. It does not discharge the required evidence; an unfinished broad run evidences nothing, and the hand-back says so.

## Correction rounds

Core § 3 *Correcting once* governs this round, including what may and may not enter it. The frozen findings are in `## Next action`.

1. Reproduce each frozen finding by inspection first, the same way Step 2 checks claims. A finding that does not reproduce is handed back as exactly that — not silently dropped.
2. Correct exactly the frozen findings. Anything newly noticed goes into the hand-back in plain words as a candidate deferral, and is not implemented.
3. A finding you can only partly resolve is handed back as exactly that: what was resolved, what was not, and why. Do not stretch the evidence to cover the gap (core § 6 rule 5).
4. Write the result and evidence into `## Latest result` per Step 5's shape. Set `turn: codex` and leave `status: active`. Set `## Next action` to the closure check on the frozen findings only. `git add` the state file and the corrected files by explicit pathspec, commit, stop.

## Closing the task

Core § 3's close token in `## Next action` is Codex's close verdict; core § 4 owns what a closed file holds. Claude writes and commits the record — the verdict is not re-judged here. The general turn guard and the identity check in Step 1 apply to this invocation like any other.

**The order of these three steps is the contract, not a suggestion.** Valid closed state is committed *before* the declaration is cleared, and the two are separate moves. Clearing first — which is what this section used to say — puts the checkout in the one state that cannot be recovered from: the lease is gone while the closure is still uncommitted, so a crash in between leaves a checkout that looks free and a task that is not closed, and the next task claims straight over it. The reverse order fails safe. A crash after the commit leaves valid `CLOSED` state plus a declaration the validator classifies stale, which the next task start in this checkout clears by itself.

1. Reduce the state file to core § 4's closing record — its exact four headings, nothing else surviving — carrying what the verdict names: the outcome, the decisions that matter (including any deferral the verdict records, with its reason), the final commit or evidence pointer, and the accepted limitations (or `None.`). Set `status: closed` and `turn: operator` in that same write: a `closed` status over a surviving active body is malformed, and the validator rejects it.
2. **Confirm the record is valid, then commit it.** `git add` the state file by explicit pathspec and commit. A closing invocation changes no other file.

   ```bash
   bash logs/scripts/work-loop-state.sh validate --checkout "$(git rev-parse --show-toplevel)" --task {task-id}   # must print CLOSED
   ```

   If it does not print `CLOSED`, the reduction is wrong. Fix the record and do not commit — and do not clear the declaration, which still correctly says this checkout is held by an unfinished task.
3. **Only once that commit exists, clear the checkout's declaration.** An open task leases its checkout until closure, and the committed closing record is what ends the lease:

   ```bash
   bash logs/scripts/work-loop-owner.sh clear --checkout "$(git rev-parse --show-toplevel)" --task {task-id}
   ```

   Leaving it in place is the failure this step exists to prevent: the next task in that checkout would be refused by a task that has already finished. `clear` refuses to remove another task's declaration, and a checkout that has none is a no-op, so running it is always safe. `logs/work-loop/.owner` is gitignored, so this changes nothing that gets committed — which is also why it cannot be part of the commit in step 2. Then report the final repository state under Step 6 and stop.

## Step 6 — Report clearly

For an ordinary hand-back, say in one plain-language line which brief and task ran, whether a premise
failed, and what was committed. Then stop. Assessment is Codex's move, not yours.

For a closing invocation, report the whole-task result after the closing commit in exactly these
terms: `Implementation: COMPLETE`, followed by one merge state —
`READY FOR OPERATOR-AUTHORIZED MERGE INTO MAIN` with the branch and closing commit;
`ALREADY ON MAIN — NO MERGE REQUIRED` with the closing commit; or `NOT READY` with the specific
repository blocker. Do not describe a completed unit or an uncommitted close verdict as a completed
implementation, and do not merge or authorize the merge yourself.
