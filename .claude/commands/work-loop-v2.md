---
model: opus
effort: high
argument-hint: "[the task id whose state file to act on, or nothing to use the only open one]"
---

Run Claude's half of one Work Loop v2 unit: read the task-state file, check the brief's premises against the live repository, then either hand back a false premise or implement the unit and hand back evidence. Codex frames and assesses; Claude owns repository reality and makes every commit. Not for small reversible fixes — those are Direct Work and open no state file (core § 2).

Input: `$ARGUMENTS` — a task id, or empty to use the only state file whose `turn:` is `claude`.

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
wl2_git_top() {
  local wl2_top
  wl2_top="$(git -C "$1" rev-parse --show-toplevel 2>/dev/null)" || return 1
  (cd "$wl2_top" && pwd -P)
}
wl2_is_workspace() {
  local wl2_w="$1"
  [ -d "$wl2_w/projects" ] && [ -d "$wl2_w/ai-resources" ] || return 1
  [ "$(wl2_git_top "$wl2_w")" = "$wl2_w" ] || return 1
  [ "$(wl2_git_top "$wl2_w/ai-resources")" = "$wl2_w/ai-resources" ]
}
wl2_git_common() {
  local wl2_c
  wl2_c="$(git -C "$1" rev-parse --git-common-dir 2>/dev/null)" || return 1
  case "$wl2_c" in /*) ;; *) wl2_c="$1/$wl2_c" ;; esac
  [ -d "$wl2_c" ] || return 1
  (cd "$wl2_c" && pwd -P)
}
wl2_is_trusted_repo() {
  local wl2_common wl2_canon wl2_canon_top
  wl2_common="$(wl2_git_common "$1")" || return 1
  case "$wl2_common" in */.git) ;; *) return 1 ;; esac
  wl2_canon="${wl2_common%/.git}"
  # Load-bearing: the shared store proves same-repo, the name proves which repo. Do not drop.
  [ "$(basename "$wl2_canon")" = 'ai-resources' ] || return 1
  wl2_canon_top="$(wl2_git_top "$wl2_canon")" || return 1
  [ "$wl2_canon_top" = "$wl2_canon" ] || return 1
  [ "$(wl2_git_common "$wl2_canon")" = "$wl2_common" ]
}
wl2_repo_root="$(wl2_git_top "$(pwd -P)")" ||
  { echo 'ERROR: Work Loop v2 cannot resolve its repository boundary.' >&2; exit 1; }
wl2_workspace_root=''
if wl2_is_workspace "$wl2_repo_root"; then
  wl2_workspace_root="$wl2_repo_root"
else
  wl2_projects_dir="$(dirname "$wl2_repo_root")"
  wl2_workspace_candidate="$(dirname "$wl2_projects_dir")"
  if [ "$(basename "$wl2_projects_dir")" = 'projects' ] &&
     wl2_is_workspace "$wl2_workspace_candidate"; then
    wl2_workspace_root="$wl2_workspace_candidate"
  fi
fi
wl2_semantic_path=''
wl2_attempted=''
wl2_try_semantic() {
  local wl2_candidate="$1" wl2_source_root="$2" wl2_dir
  wl2_attempted="${wl2_attempted}${wl2_attempted:+; }$wl2_candidate"
  [ -f "$wl2_candidate" ] && [ -r "$wl2_candidate" ] && [ ! -L "$wl2_candidate" ] || return 1
  wl2_dir="$(cd "$(dirname "$wl2_candidate")" && pwd -P)" || return 1
  case "$wl2_dir/" in "$wl2_source_root/"*) ;; *) return 1 ;; esac
  wl2_semantic_path="$wl2_dir/$(basename "$wl2_candidate")"
}
wl2_workspace_path=''
if [ -n "$wl2_workspace_root" ]; then
  wl2_workspace_path="$wl2_workspace_root/ai-resources/$wl2_semantic_rel"
  wl2_try_semantic "$wl2_workspace_path" "$wl2_workspace_root/ai-resources" || true
fi
wl2_direct_path="$wl2_repo_root/$wl2_semantic_rel"
wl2_direct_reason=''
if [ -z "$wl2_semantic_path" ] && [ "$wl2_direct_path" != "$wl2_workspace_path" ]; then
  if wl2_is_trusted_repo "$wl2_repo_root"; then
    wl2_try_semantic "$wl2_direct_path" "$wl2_repo_root" || true
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

**Scope of this version — Slices 1–3, Claude side.** Behaviours 1.2, 1.3, the fresh-session pickup (2.1), file-identity rejection (2.2), Claude's half of the bounded correction (2.3, 2.4 — the Correction rounds section below), and admission discipline: the admission test (Admission below), de-escalation (De-escalating below), and mid-unit deferrals (Step 4). Plus the unit's mode (2026-08-06 — The unit's mode below), which Codex classifies and you execute against.

Context Engineering is live on the Codex side. This command **consumes** the engineered brief — checking its claims against the repository and acting on it — and never performs Codex's preparation, authority or selection judgments itself.

---

## Admission — Direct Work or the loop

Runs when the work arrives without a state file — the operator brings a request rather than a task id.

**Core § 2 owns this test.** Read it there and apply it. What this command does with each outcome:

- **Not admitted** — name the part of core § 2 that excluded it, do the work directly if that is the answer, and **open no state file**. `logs/work-loop/` is left untouched; the absent file is the evidence that admission was refused.
- **Admitted** — the named reason core § 2 requires is already written in the state file. If it is missing, the brief is malformed: hand back under Step 3 rather than supplying a reason on Codex's behalf.

When invoked on an existing state file that carries its reason, admission was decided at open — go to Step 1.

## Step 1 — Orient

Read the state file at `logs/work-loop/{task-id}.md`. Resolve `{task-id}` from `$ARGUMENTS`, or — if empty — from the single file under `logs/work-loop/` whose frontmatter `turn:` is `claude`. If more than one qualifies, list them and ask which. Never guess.

Read the repository, not the conversation (core § 3 step 1).

**Validate the file's identity read-only, before anything else is done with it** — core § 6 rule 2 states the conditions; this is what Claude does when one is met. If the frontmatter `task:` does not match the resolved `{task-id}`, report the mismatch — both values, in plain words — and **change nothing**. No inspection record, no turn flip, no commit; the rejection leaves no trace in the file, and that is the point. If it is not obvious which side is correct, the report ends with the question for the operator (core § 7). Then stop. The same applies to a file that is missing or has no readable `task:` / `turn:` frontmatter — report, change nothing, stop.

If `turn:` is not `claude`, stop and say whose move it is. Change nothing.

If `## Next action` opens with core § 3's hand-off token, this invocation is the one bounded correction, not a new unit — go to **Correction rounds** below and skip Steps 2–5.

If `## Next action` opens with core § 3's close token, Codex has decided closure and this invocation writes the closing record — go to **Closing the task** below and skip Steps 2–5.

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
3. Set `turn: codex` in the frontmatter.
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

## De-escalating — when the work turns out smaller

Core § 2 *De-escalating* decides when this applies — inspection or implementation is where Claude notices it. When it does apply:

1. Say so, in plain words.
2. Reduce the state file to the closing record (core § 4), recording under `## Decisions that matter` that the task de-escalated and what was learned. Set `turn: operator`.
3. Finish the work directly, as Direct Work.
4. `git add` the state file and the changed files by explicit pathspec, commit once, stop.

## Step 5 — Write the result and the evidence

Into `## Latest result`, below the inspection record:

```
Result: <what actually happened — the latest material result, not a history>
Evidence: <the check, what it returns now, and what it returned before>
```

**The evidence must be able to fail** — core § 6 rule 5, including how to prove it.

The state file is current truth, not a diary (core § 4): replace the previous result rather than appending to it.

Then set `turn: codex`, set `## Next action` to what Codex assesses, `git add` by explicit pathspec — the state file and the files the unit changed — and commit.

## Correction rounds

Core § 3 *Correcting once* governs this round, including what may and may not enter it. The frozen findings are in `## Next action`.

1. Reproduce each frozen finding by inspection first, the same way Step 2 checks claims. A finding that does not reproduce is handed back as exactly that — not silently dropped.
2. Correct exactly the frozen findings. Anything newly noticed goes into the hand-back in plain words as a candidate deferral, and is not implemented.
3. A finding you can only partly resolve is handed back as exactly that: what was resolved, what was not, and why. Do not stretch the evidence to cover the gap (core § 6 rule 5).
4. Write the result and evidence into `## Latest result` per Step 5's shape. Set `turn: codex`. Set `## Next action` to the closure check on the frozen findings only. `git add` the state file and the corrected files by explicit pathspec, commit, stop.

## Closing the task

Core § 3's close token in `## Next action` is Codex's close verdict; core § 4 owns what a closed file holds. Claude writes and commits the record — the verdict is not re-judged here. The general turn guard and the identity check in Step 1 apply to this invocation like any other.

1. Reduce the state file to core § 4's closing record — its exact four headings, nothing else surviving — carrying what the verdict names: the outcome, the decisions that matter (including any deferral the verdict records, with its reason), the final commit or evidence pointer, and the accepted limitations (or `None.`). Set `turn: operator`.
2. `git add` the state file by explicit pathspec, commit, stop. A closing invocation changes no other file.

## Step 6 — Report in one line

Say what happened, in plain words: which task, whether a premise failed, what was committed. Then stop. Assessment is Codex's move, not yours.
