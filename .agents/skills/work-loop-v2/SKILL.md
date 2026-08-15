---
name: "work-loop-v2"
description: "Use only when the request (1) names the Work Loop, (2) points at an existing logs/work-loop/{task-id}.md task, hand-off or assessment to act on, (3) says 'continue this project' or 'what is next on this project', or (4) asks Codex to frame a bounded unit for another actor to execute. Then route it to the one capability that owns it — the operator, an Axcíon command, a Matt skill, or the Work Loop itself — and, where the Work Loop owns it, frame and assess one bounded unit: write the brief that opens it, and judge the evidence that comes back. Do not use for an ordinary repository or project change described in natural language without naming a capability (that is Direct Work), a request naming a command, skill or agent to run, a question answered by reading or explaining with no repository change, a small reversible fix, or work already inside another skill's flow. Claude executes and makes every commit; you do neither."
---

# work-loop-v2 — Codex side

> **Run `pwd` now, on its own, before you read anything else in this repository.** Not bundled with a
> search or a listing — one command, one answer. The directory you are *actually* in decides which
> tasks exist and which checkout a state file would be written into, and § *The checkout a task lives
> in* owns why that matters. Verifying costs one command. Discovering it late costs a task file
> written into the wrong checkout, which no later step can undo cleanly.

You frame the work and judge the result. **Claude owns repository reality: it checks claims, implements, produces evidence, and makes every commit.** You never both frame a unit and approve its implementation without evidence in front of you.

This file does not restate the executable core resolved below; where they disagree, the core wins and
the difference is a defect. Its read point is Routing step 3 because most routes do not need it.

**Compaction gate — reorient before you act.** If this task has been through a context compaction, or
the conversation may otherwise be incomplete, invoke `$reorient` before routing, preparing, assessing,
continuing, correcting or closing any unit. Continue only once it has established the authoritative
task, its bound checkout and the next action; if it cannot, **stop without changing state** and say so.
The `reorient` skill owns that procedure and it is deliberately not restated here — a second copy would
be free to drift from the one that governs.

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
---

## The seam

Core § 4 defines the interface between you and Claude, and places the operator outside it. Four consequences for how you work:

- **Do not wait for a state file before engaging with a request.** The operator reaches you directly, in conversation, before any file exists — core § 4 says why it cannot be otherwise. There is nothing to wait for.
- You **write** the state file, at the path core § 4 fixes. You have repository write access; use it.
- You **never mutate Git state.** Not `add`, not `commit`, not `checkout`, and not `reset`, `merge`, `rebase` or `push`. Claude commits — including the file you just wrote. Read-only inspection is a different thing and is not forbidden; the paragraph below says what it is for.
- The operator carries the turn. So **every reply you give ends with an explicit next instruction to them**, in plain words.

**Read-only Git is yours; writing is not.** The restriction is on `.git` writes, not on Git as a whole — the MVP's transport step established it by observation, with `git status --short` and `git log --oneline` succeeding from inside Codex while `git add` was refused (`plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` § 2). So you may run a read-only Git command where your own judgment needs a repository fact. Two limits hold that in place, and both matter more than the permission does. It never becomes a routine duty: where the Work Loop assigns implementation, test, diff or status evidence to Claude, that evidence still comes from Claude through the state file, and reading it yourself does not replace it or license you to skip asking. And it never extends to mutation: repository reality is Claude's to own and Claude's to change (core § 1).

**Name the actor whose turn it actually is** — the one you just wrote into `turn:`. The three cases:

| `turn:` you set | The Next line says |
|---|---|
| `claude` | **Next:** run `/work-loop-v2` in Claude. |
| `operator` | **Next:** {the decision or information you need from them}. |
| — (Direct Work, no file) | **Next:** have Claude do this directly — no loop task. |
| — (a specialist owner, no file) | **Next:** run {the owner} — naming it, and saying `in Claude` where it is Claude-side only. |
| `claude`, **with an unattended run in flight** | **Next:** nothing to do — the run is carrying it. Name the deadline and where the evidence will be. See *Unattended runs*. |

**The carve-out in the last row matters.** "The operator carries the turn" is why every reply ends with an instruction to them. While an unattended run is in flight, the dispatcher carries the turn instead, and an instruction to go and paste something would be wrong. The Next line then reports rather than directs.

Sending the operator to Claude when the turn is theirs stalls the loop as surely as saying nothing: Claude opens the file, finds nothing owed by it, and hands straight back. Omitting the line altogether is the most likely way this loop silently stops — the operator is left holding a turn with no stated destination. Treat it as part of the output, not as courtesy.

**The folder is core § 4's, not a choice.** Create `logs/work-loop/` if it does not exist. There is no fallback path — if you cannot write there, say so and stop.

### The checkout a task lives in, and starting a new one

**The task file's location is the binding.** The checkout holding `logs/work-loop/{task-id}.md` is the checkout that task lives in. Nothing records this in the file — a state field would be a second copy, free to drift from the path it duplicates.

- **Verify before you create.** Before writing a new state file, confirm the working directory you are *actually* in — not the one you meant to be in — and that it is the checkout the work belongs to.
- **Both actors verify at every handoff.** Claude's Step 1 already resolves the file under the checkout it is running in.
- **A mismatch stops and goes to the operator** (core § 7). **Never copy the task file to another checkout as a repair.** That produces two files claiming one task's truth, which is the failure core § 4's single interface exists to prevent.

**Isolation — the whole policy, applied where a new task or run starts:**

| Situation | Default |
|---|---|
| Concurrent work in **different repositories** | Each uses its own local checkout. **No worktree.** |
| Ordinary work in one repository, one writer | Local checkout. |
| **Concurrent writers in one repository** | Deliberate isolation — a worktree or a branch. |
| **Unattended run** | Isolation, on a branch off a clean tree (§ *Unattended runs*). |
| **Genuinely large implementation** | Isolation. |

A worktree is a cost, not a default. The table is the policy — do not build a decision procedure on top of it.

**The checkout declares its writer, and you write the declaration.** One gitignored file per checkout, `logs/work-loop/.owner`, holds one task id and the date it was claimed. **Whoever creates the task's state file writes the declaration immediately before it** — in the ordinary case that is you. It sits inside `logs/work-loop/`, the directory you already create and own, so this needs no git, no new command and no authority you do not have. It mutates no Git state either, which is the boundary that actually binds you.

**One sequence, both lanes:**

1. The operator brings the request to you (core § 4).
2. Apply the isolation table above. Where it says **Local**, go straight to step 4 in the current checkout. Where it says isolate, end your reply with the Next line you already write, naming `/new-worktree-session` in Claude — that command creates the worktree and opens the window. The operator then opens you on that checkout. **This is the one residual manual step, and only on the isolated path.**
3. Verify the working directory you are actually in, as always.
4. Read `logs/work-loop/.owner`:
   - **absent, or it already names this task** — write it (`{task-id} {YYYY-MM-DD}`, one line), then write the first brief into `logs/work-loop/{task-id}.md`.
   - **it names a different open task** — **refuse and write nothing.** Say which task holds the checkout, and give the operator both remedies: close that task, or use another checkout.
   - **it names a task whose state file in this checkout is closed (`turn: operator`)** — stale. Say so and replace it.
   - **unreadable, or holding more than one id** — refuse and report. Do not guess.

Where a checkout carries `logs/scripts/work-loop-owner.sh`, `check --depth local` and `claim --depth local` apply exactly these rules for you and run no git.

**What this guarantee does and does not cover — read this as a limit, not as coverage.** Your local read answers one question: *is this checkout claimed by a different task?* That is the half that matches your own failure mode, because the only thing you write is a brief into the checkout you are standing in. You **cannot** establish that your task is claimed in another checkout, or that its state file is replicated — both need `git worktree list` across the registered worktrees, and this loop assigns repository-depth checks to Claude at Step 1 and to the dispatcher at admission, not to you. Those are the actors that establish it, and a read-only look of your own does not stand in for their check. Because Claude makes every commit (core § 4), every unit crosses a Claude entry before anything is committed, so the exposure is one uncommitted brief in a checkout your local read had already cleared.

**Not prevented by any of this, and said plainly rather than covered by claim:** two interactive sessions opened on one checkout for the **same** task, and an operator who proceeds past a refusal. Your enforcement is instruction-borne; only the dispatcher's is exit-code-borne.

**An open task leases its checkout until it closes.** That is the price of continuity between handoffs, and it is deliberate: a session-scoped lease cannot survive a session ending, and surviving one is the whole point. The cost is bounded and visible — starting a *different* task in that checkout is refused until this one closes. Ordinary serial reuse is unaffected, because closure clears the declaration.

**When a new Codex task starts at all.** Only where the thread has ended or must end: a fresh session, or a deliberate hand-off. **Ordinary Claude ↔ Codex turns carried by the state file do not open a new task** — the state file is the interface, and multiplying visible tasks for a routine turn is the ceremony this rule excludes.

**A compaction is not one of those cases.** Routine compaction is recovered *in the current task*, in this order: invoke `$reorient`; continue in that same task once it re-establishes authoritative state; stop without changing state where it cannot. A new task — or `handoff-thread` — is for a deliberate move between threads, never the routine recovery path. Turning every compaction into a hand-off is how completed work gets done twice.

- **Prefer a genuinely fresh task over a transcript-preserving fork.** A fork carries conversational memory, and conversational memory cannot establish authority or current state. A fresh task is forced to read the durable sources, which is the property wanted.
- **Choose Local or Worktree explicitly**, per the table above, when the chat is created.
- **Verify the working directory as the first action**, before anything is read or written. Do not infer it.
- **Then read the durable sources, in this order:** the state file `logs/work-loop/{task-id}.md`; the governing plan; the applicable approved workflow; authoritative current state. Re-establish the seven fresh-thread recovery items inside that same preparation pass — § *Mark what must be verified* owns them — never as a stage of its own.

**The existing-worktree fallback.** Where the work must continue in a permanent, user-created worktree: open that directory as a **Local** checkout for the new task, and verify the working directory first. Do **not** use "create a worktree" on a fresh task expecting it to attach to the existing one — that silently creates a *different* worktree, which is the failure this fallback exists to avoid. Codex-managed worktrees are disposable and are not a continuity surface.

### Courier mode — carrying the turn yourself

Core § 4 *An approved courier may carry the turn* permits this and sets its limits. Read them there. This section is the approved courier and how you operate it. **It is optional and off by default**: unless the operator has approved it for the session, end your reply with the Next line and stop, exactly as above.

**There are two approved shapes, and the operator's presence picks which.**

| Shape | Program | Use it when |
|---|---|---|
| **Attended carry** | `scripts/axcion-harness-v0.2/carry-turn.sh` — Axcíon Harness v0.2 | The operator is at the machine. You carry **one** hop, then read the file and assess. The loop does not run on without you. |
| **Unattended run** | `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, loop mode | The operator is leaving. You frame the unit, launch, and get out of the way. The loop alternates Claude ↔ Codex until `turn: operator`, the deadline, or a guard. |

**These are two different programs, and neither does the other's job.** The attended carrier carries exactly one hop per invocation and has no loop mode, no unattended mode, no worktree automation and no flag to ask for one: `--carry-one`, `--unattended`, `--max-hops` and `--status` are all refused with exit `10` before anything launches. It reports no out-of-band status either — the state file is its status, and a carry already in flight exits `17` naming the holding pid. So do not carry an attended hop with the spike dispatcher, and never reach for the carrier when the operator is leaving.

Everything below applies to both unless it names one. The hard rules are written for the attended carry, which is the default; *Unattended runs* at the end of this section states what changes.

**What you drive is a terminal command, not Claude.** You never type into a Claude window, never read Claude's interface for progress, and never click through its prompts. You run one command and read its exit code. The courier program launches the actor, validates the state file before and after, and stops on anything unexpected — that instrumentation is the reason this is the approved courier and screen-driving Claude directly is not.

**Neither shape is context-bounded, and it is worth being clear why.** Every hop is a **fresh process** (`claude -p`, `codex exec`). Nothing accumulates across hops; `logs/work-loop/{task-id}.md` is the entire shared memory. A run ends at `turn: operator`, at its hop limit, at its deadline, or at a guard — never because a context window filled. Do not plan around a context budget that does not exist.

**The attended command, in full.** There is no hop flag — one hop is the surface, so adding `--carry-one` is an unknown argument and stops at exit `10`. All four `--allow-path` values are required, because supplying any one **replaces both built-in defaults** (`^logs/work-loop/` and `^logs/harness-runs/`): the carrier writes its own run log under `logs/harness-runs/`, which is not gitignored, and a `PostToolUse` hook keeps `logs/friction-log.md` modified in this repository — omit either and the carry stops at `18` on the courier's own output. The fourth line is **per-task**: derive it from what this unit may legitimately change when you write the brief. Too narrow gives a false stop; too wide makes the check mean nothing.

```
scripts/axcion-harness-v0.2/carry-turn.sh \
  --checkout <absolute checkout path> \
  --task <task-id> \
  --allow-path '^logs/work-loop/' \
  --allow-path '^logs/harness-runs/' \
  --allow-path '^logs/friction-log\.md$' \
  --allow-path '<regex for what this unit may change>'
```

**The hard rules.** Each is a stop, not a preference:

1. **Read the state file first.** Confirm the exact task id and that `turn:` is `claude`, by opening the file. Not from what you remember writing.
2. **Run the command once for this carried turn.** In the **attended carry**, the carrier carries exactly one hop per invocation, so Claude moves and you assess — the loop does not run on without you. To carry the next turn you read the state file, confirm the turn moved, and invoke the carrier again. *This is a property of the attended shape, not of one program:* an unattended run is defined by the loop running on without you, and is governed by the deadline and hop limit instead. Either way you run this carried turn **once** and never repeat the same hop to try again (rule 5).
3. **The exit code is the result.** `0` means the carry completed. Anything else stops this carry: report the code and its meaning to the operator, and do not repeat the same hop. A later operator-approved narrowed recovery unit is governed by § *Three outcomes*; it is a new unit, not a retry of this one.
4. **Read the file before assessing.** Exit `0` has two causes — the turn moved, or `turn:` was already `operator` and nothing was carried. Only the file distinguishes them, and the file is authoritative over the exit code either way (core § 4).
5. **Never re-run the same hop to "try again".** A second launch of that hop is only ever justified when the courier's own run log shows the first launch never started. A completed hop that did not produce what you expected is something to inspect, not to repeat. After its partial effects are inspected, the operator may instead approve the fresh, smaller recovery unit defined in § *Three outcomes*; that is explicitly not the same brief or hop.
6. **`turn: operator`, a malformed state file, and a permission prompt are terminal.** Stop and tell the operator. You do not approve prompts and you do not work around them.

**An unchanged `turn: claude` does not mean the command failed to land.** Claude leaves the file *completely untouched* when it rejects one — an identity mismatch or unreadable frontmatter is a correct read-only refusal (core § 6 rule 2), not a lost message. There are three causes and both programs already separate them, under the same three codes: `14` identity mismatch (Claude was never launched), `22` no transition (Claude ran and changed nothing), `21` timeout (Claude was still working). Read the code. Do not infer the cause from the turn, and never treat an unchanged turn as permission to send again.

**Operating defaults — preferences, not protocol.** Do not report a breach of these as a failure: a target for how many interactions a carry should take is a cost guide, and corrections, closures, permission prompts and genuine blockers can legitimately exceed it; a fresh Claude session is a sensible default for a new unit but not required for a short correction or a closing hand-off; inspecting accessibility state before taking a screenshot is an efficiency habit; and an unlocked machine is a preflight reminder rather than a Work Loop safety rule.

**This does not loosen the mutation boundary.** Launching the dispatcher is not mutating Git state. The dispatcher reads git state to validate the hop — `status`, `rev-parse`, `diff --cached` — and writes nothing through git; the commit inside the carry is Claude's, made by Claude, exactly as core § 4 requires. You still never run `add`, `commit` or `checkout` yourself, and you may not substitute any other command for the one above.

#### Unattended runs — when the operator is leaving

**A different program: the spike dispatcher in loop mode**, not the attended carrier — the carrier refuses `--unattended` and every multi-hop flag before it launches anything. Same guards, `--carry-one` dropped. What changes:

**Add a clock, and isolate the run.** `--deadline <seconds>` is the operator's absence in seconds; without it the real bound is `--max-hops × --timeout`, which is hours. The run goes on a branch off a **clean** tree, and the launch is wrapped in `caffeinate -i` — a Mac that sleeps kills the run. The worked invocation is in the spike `README.md`; use it rather than assembling one.

**Contain the child: pass `--unattended`.** An unattended Claude hop runs with less authority than an attended one, and this is the flag that applies it — not `--claude-deny`, which is a permission-layer narrowing that leaves the network wide open. `--unattended` gives the child an OS-backed sandbox with an empty network allowlist, shell and Skill tools only, no MCP, hooks, connectors, remote control, subagents, built-in file tools or push, and credentials stripped from subprocesses. It fails closed (exit `31`) rather than running uncontained, and refuses to combine with `--actor-cmd`. `--claude-deny` still composes and can only narrow further.

Three things to know rather than discover mid-incident. **The run log records the *requested* policy, not the effective one** — array settings keys merge across scopes, so another scope on the host can widen what the child reads; the effective policy was measured once, on one host (`runs/probe-unattended-integration-2026-08-07.md`). **Where the effective policy *is* readable:** an unattended hop is captured as `--output-format stream-json`, so the hop's `.out` opens with the product's own `system/init` event, and that states the tool roster and MCP servers the runtime actually resolved. Read that, not the argv and not the child's account of itself. And **`~/.gitconfig` is one deliberate exception** inside an otherwise denied home directory, because Git exits before touching the repository without it; if a real secret is ever put in that file, the exception stops being safe.

**The allowlist becomes a per-task input.** The dispatcher now checks what Claude **committed** against `--allow-path`, not only what it left uncommitted. So the allowlist has to describe what *this unit* may legitimately touch. Derive it when you write the brief. Too narrow stops correct work; too wide and the check means nothing.

**The Next line changes shape.** The rule that every reply ends with an explicit next instruction (§ The seam) assumes the operator carries the turn. While a run is in flight they do not, and telling them to go and paste something would be wrong. **When you have launched a run, the Next line names the run, its deadline, and where its evidence will be** — not an instruction to act.

**Once you have launched, the state file is not yours until the run exits.** You write that file by hand and the lock does not stop you; a hand-edit mid-hop is a real corruption path. Check before touching it:

```
dispatch.sh --checkout <path> --task <task-id> --status
```

`--status` is read-only — no lock, no log, no write — and safe against a live run. It reports whether a run is in flight, its pid, how to stop it, the current `turn:`, and where the log is.

**Do not mix the shapes.** A chat Codex carrying hops while a loop run is in flight is two instances of one actor driving one state file. `--status` is how you tell.

**Three outcomes, never blurred.** When the operator returns, the run ended in exactly one of these, and saying which is the first thing you owe them:

| Outcome | Looks like |
|---|---|
| **Finished** | `0` — and `turn: operator` with a core § 4 closing record |
| **A decision is theirs** | `0` — and `turn: operator` with `## Blocker` / `## Next action` still present |
| **Stopped** | any other code — a guard (`18`,`19`,`24`,`25`,`30`,`36`), a failure (`20`,`21`,`22`), a permission dead end (`37`), an ownership stop (`33`,`34`,`35`), the hop limit (`23`), an interruption (`28`), or the budget (`29`) |

**`29` is not completion.** A run that ran out of clock is unfinished and resumable. Never report it as done.

**What a stop authorizes — five clauses, and they are one rule.** A nonzero exit is a statement about one bounded hop. Read all five before deciding anything; the first two without the last three produce a dead end, and the last three without the first two reopen the bypass.

1. **A stop is never a licence to leave the dispatcher.** It authorizes fixing the cause and re-running, or stopping for the operator. It never authorizes an interactive Claude session, a hand-carried hop, or a hand-edit of the state file. A dispatcher capability gap is a capability gap — report it as one and ask. It is not permission to do the work another way.
2. **Never repeat a completed hop blindly.** Where the run log proves the actor launched and ran, that hop is not re-run as if it had not happened.
3. **A timeout means the transport stopped. It does not mean the repository task is impossible.** Exit `21` bounds one hop; it says nothing about whether the underlying work can be done. Reading `21` as "this task cannot be completed" is a specific recorded error, not a hypothetical one — it happened on 2026-08-11 and cost a day. The same holds for `29`.
4. **Partial effects are preserved and inspected before anything else is decided.** A stopped hop may have changed allowed files without committing them. The stop now lists those paths under `PARTIAL FILE EFFECTS`. Read them. Do not discard them, and do not assume they are absent because the state file did not move and the branch ref did not advance — those two facts are compatible with real work sitting uncommitted on disk.
5. **A newly narrowed recovery unit is available, with operator approval.** Not a re-run of the same brief and not abandonment: a *fresh, smaller* unit that inherits the preserved partial work and carries one dominant deliverable (§ Size the unit against the clock). **Operator approval is the gate.** Ask for it; do not resolve it yourself.

**`37` is a capability question, not a transport failure.** A permission dead end means the child was refused something it needed. Raising the timeout, re-running, or rewording the brief will not change it. Report what was denied and ask the operator whether to grant the capability or narrow the unit so it is not needed. **`35` is a different stop and takes a different remedy** — the ownership check could not be run at all (`logs/scripts/work-loop-owner.sh` missing, unreadable or failing), so nothing launched; install or repair the helper rather than treating it as a denial. Any record written before 2026-08-11 that names `35` for a permission stop predates the renumbering — read it as `37`.

**`36` means Claude did not touch the already-uncommitted state file; it does not prove the hop changed nothing else.** It is most often a Codex handoff that was never committed. Do not read it as a partial edit by Claude — that is exactly the misreport `36` was split out of `25` to stop — and read any `PARTIAL FILE EFFECTS` block for other allowed work the hop left behind.

**Separate repository facts from model claims.** Report from the state file and the run log, and keep the two kinds of statement apart: *"the dispatcher observed exit 0"* is a repository fact; *"Claude reports the tests passed"* is a claim Claude made. Neither means you accepted the evidence — that is still your assessment to make (§ Assessing the result), and an unattended run does not do it for you.

---

## Routing a request — who owns the next move

The operator describes what they want in ordinary language and rarely names a capability. Route it before anything else, in this order:

1. **Interpret the desired outcome and its object** — what should be different afterwards, and to what. Not the remedy they proposed; the outcome behind it.
2. **Choose one owner** — the single capability whose purpose covers that outcome. Read
   [Routing index](references/routing-index.md) complete before you name it; the inventories are
   there and this file carries no copy of them (§ The routing index below).
3. **If the Work Loop is the owner** — and only then — **run § Resolve the executable core and read
   exactly the absolute file it returns now, before your first Work-Loop-owned move.** Then apply the
   Direct-versus-Standard admission test (Admission below). Where any other capability owns it,
   admission does not arise and the core is not resolved or read.
4. **Classify the mode** — Discovery, Implementation or Adoption — **only once admission has succeeded**, and record it inside `## Lane and unit`. Core § 3 *The unit's mode* defines the three and what each requires of the evidence.
5. **Choose the bounded unit** and write the brief.

Mode belongs to an admitted Work Loop unit and to nothing else: a request routed to the operator, to a specialist owner, or to Direct Work never acquires one. It is also not the **courier** mode of core § 4, which is transport.

**Who owns the next move** has three kinds of answer:

- **The operator** — the next move is a decision only they can make: intent, priority, authority, or risk. Open nothing. End with the Next line naming the decision you need.
- **A specialist owner** — an Axcíon command or Matt skill from the index, or a stage of the project's own workflow. Its method, reviews and gates are its own (core § 1); **do not wrap** its work in a unit and add nothing on top. Say which one owns the move, and end with the Next line sending the operator there.
- **The Work Loop** — bounded repository work no specialist owns. Take it through Admission below as one unit, and classify it in the core's own terms (core § 3 step 4): an **execution brief** when what advances the project is a change, a **discovery unit** when it is evidence about a named unknown. Operating evidence from real use is a discovery unit whose named unknown is how the capability behaves in use — never a new unit type.

**"Continue this project" is one intake case, not a second router.** Its object is the project's own next move, so read the project's governing workflow and authoritative current state, find the nearest unmet exit condition in the project's own terms, and route that. Map the project's position using its own phase model and vocabulary. Never rename its phases, and never create a document, list or state entry to hold the mapping — the routing is a judgment made fresh from the durable sources each time. Only where a project has no phase model at all, orient with this fallback spine, as a diagnostic and nothing more: frame the need → resolve blocking uncertainty → choose the intervention → shape the pilot → deliver → test in real use → adopt, revise or stop. It creates no states to traverse, no artifacts, and no exit conditions of its own. Orientation is that judgment made explicit, inside the same single preparation pass and from durable sources only. It establishes nine things: the owning project; its approved outcome and current priority; the authoritative current-state source; the governing specialist workflow; the active phase; the completed phases and accepted decisions; the blockers and operator gates; the work ready now; and the work that is premature or unauthorised. Reach them the way `/project-next-steps` Step 2 reaches its own position — plan spine first, then the authoritative position source, then only what bears on the next step, stopping as soon as position is certain. Borrow that read cascade *approach* and nothing else: `/project-next-steps` remains a separate Claude-side operator-facing briefing with its own report, and neither capability calls or merges into the other. Return one line to the operator, in exactly this shape — `Current position → governing workflow and phase → what is ready → what is blocked → recommended next unit → why it matters.` — written in the project's own phase vocabulary, never renamed. **Establishing the nine is not carrying them.** The approved outcome and the current-state position must also reach the brief itself — the position at the precision its authoritative source supports, naming the active phase together with the last completed unit and any open unit, and its date where that date identifies the position, never collapsed to a phase label alone. The operator line above stays exactly as it is: this adds no stage, no second artifact, no repeated context block and nothing further the operator reads. Orient at four boundaries and no others: a Continue acceptance opening the next unit (core § 3 *Continuing*); a fresh task picking up existing work (§ The seam); a post-compaction reorientation; and a material context change — a new operator decision, an operator approval, or verified evidence that has changed the durable understanding of the project. A routine invocation is precisely one where none of those changed, and a routine invocation does not re-orient. Orientation writes nothing: it is not a stage, a gate or a checklist the operator sees, and it creates no orientation file, no phase copy and no state entry — the prohibition above covers the nine determinations too.

### Repository-problem reference

When intake concerns a repository problem, read
[Repository Problem Resolution SOP](references/repository-problem-resolution-sop.md) before
choosing the owner. Use it to qualify the observed problem, distinguish normal repair from
structural resolution, select proportionate evidence, and understand the closure vocabulary.
It is context rather than routing authority: this section still chooses the owner, and the
executable core still governs any admitted Work Loop unit. Unless an approval record binds the
SOP's exact content, carry it as non-governing operator source material.

### Classifying the mode

Core § 3 owns the definitions. What decides it in practice is **what is still uncertain**, not the size of the work or how far the project has got. Three worked cases, calibrated by the operator:

| Case | Mode | Because |
|---|---|---|
| Email OS — the shape of the thing is not settled yet | **Discovery** | the requirement and the ownership boundary are the unknowns; evidence has to resolve them before anything is built |
| A CRM correction — a known defect in a known place | **Implementation** | objective, authority and boundary are settled; what remains is to build it and show it works |
| The CRM operating trial — it exists, is it good enough to keep | **Adoption** | the capability is already there; the unknown is whether it enters normal operations, and the answer is a lifecycle decision |

The trap the middle row sets: a large or important change is still **Implementation** where nothing about it is uncertain, and a small one is still **Discovery** where something load-bearing is. Read the uncertainty, not the size.

Write the mode into `## Lane and unit` and make the brief's completion condition agree with it. A brief recorded as Implementation whose completion condition asks only for evidence and a hand-back is misclassified, and Claude is entitled to hand it back as a false premise.

### What an intake result contains

Exactly four parts:

1. **The interpreted outcome** — what you understood them to want, in one sentence.
2. **One owner** — exactly one owner, named. Not a shortlist and not a sequence.
3. **One short reason** — why that owner rather than the nearest alternative.
4. **One actionable next instruction** — the Next line, naming the actor whose turn it is.

Name an excluded tempting route only where saying so prevents a likely mistake. **Never a default supporting stack**: a flow's later phases are reached by its owner at its own boundaries, so returning them alongside the owner would hand back several simultaneous owners and lose the one-owner rule. Concretely, a request to build from a ticket returns `implement` alone — not `implement` + `tdd` + `code-review`, which is the flow `implement` already runs for itself.

The index names triggers, boundaries and hand-offs — never a capability's method. **It is a menu to select one entry from, not a list of things to do**: an entry appearing here says only that a request of that shape has somewhere to land. Read the owner's own definition when you need its method.

### The routing index

The route inventories are one file: [Routing index](references/routing-index.md). **Read that file
complete at step 2 above, before you name an owner** — the five route classes, the names that are not
routes, the collision table and the Claude-side-only rule live there and nowhere else. Do not route
from memory of it, and do not copy an entry back into this file: one route entry, one owner.

## Admission — Direct Work or the loop

**Core § 2 owns this test.** Read it there and apply it before opening anything. What you do with each outcome:

- **Not admitted** — open no state file. Say which part of core § 2 excluded it, and end with the Next instruction: have Claude do it directly, or come back with a reason that qualifies.
- **Admitted** — write the reason core § 2 requires into the state file when the task opens, in the Lane and unit field: `Named reason for the loop: …`.

## Opening a unit and writing the brief

One task, one file (core § 4), named for the task id. Set `turn: claude` when the brief is ready for Claude.

Before writing anything:

1. **Find the real need, not the stated fix.** "Add a check to X" is usually a proposed remedy for an unstated problem. Ask what goes wrong today — one round, not an interrogation, and none at all if the answer is already in what they said.
2. **Read the object.** Open the file, run the grep, check the line the request cites. A brief written from the operator's description alone inherits every error in that description.
3. **State premises as checkable claims.** Each is something Claude will open, run or re-derive. "The hook fires at SessionStart" is a premise. "The hook is important" is not — it cannot be checked, so it cannot be a premise. Write absence claims to core § 6 rule 3: name the surface.
4. **Choose the smallest justified unit** (core § 3 step 2).

The file's shape, its five-field ceiling and what sits outside that ceiling are core § 4 — including the **exact heading strings** for the active fields, which Claude reads literally. Write those headings as core § 4 gives them; a file under different headings is malformed and Claude cannot act on it. What the brief itself must carry is core § 3 step 3, and where the brief places its claims to check — marked in place, or gathered under one collecting heading — is core § 3 step 3's choice, with both shapes valid.

**Required evidence must be able to fail** (core § 6 rule 5). Ask for a check that reads differently depending on whether the work happened. A check that greps a word your own brief already contains is not evidence — it is the commonest way a unit looks done and is not.

### Size the unit against the clock

**A unit that will run under a timer carries one dominant deliverable and one proportionate evidence set.** Judge that on the **reasoning and validation load**, not on the file list.

**An allowlist bounds files, not reasoning workload.** This is the load-bearing sentence. The dispatcher can prove a hop stayed inside its paths; nothing proves it stayed inside its thinking. A brief that reads as bounded because its `--allow-path` list is short is exactly the misreading this rule exists to prevent — a single-file unit can carry an unbounded amount of work.

Split the unit before you dispatch it when the brief has any of these shapes:

- It combines building something with remediating something else — a scenario redesign *and* a standards cleanup.
- It asks for a historical or negative control to be constructed alongside the primary edit.
- It demands a full behavioural matrix for instruction files, rather than one targeted check.
- It says "all", "every" or "exhaustive" without a stated consequence that requires exhaustiveness.
- Its evidence set needs more than one fixture built from scratch before the primary work can start.

Split by deliverable, not by file count. Two oversized halves are not a fix.

**A longer timeout is not the remedy for an oversized unit.** The actor timeout is a safety boundary, and on 2026-08-11 it was the one control that worked. Raising it buys a larger oversized unit whose failure arrives later, costs more, and — if it now finishes inside the new limit — produces no stop and no evidence at all. Do not propose it as a fix for sizing, and do not treat a hop that timed out as a reason to relax the clock.

### Prepare once; write one brief for two audiences

Prepare the unit in **one pass**. The operator supplies the objective and any optional raw material once; locate, derive and reconcile repository-resolvable context yourself. Do not open an iterative context interview, a separate QC pass or a preparation loop for information the pass can derive, and do not ask the operator to assemble, reconcile or restate context carried by durable sources. End the pass with exactly one execution brief, one discovery brief or one genuine escalation. Only a genuine operator-owned decision about intent, priority, authority or risk returns to the operator; evidence or a result after Claude begins work is normal subsequent Work Loop work, not another preparation pass.

When a load-bearing unknown is resolvable by repository inspection, make the open unit a **discovery unit** rather than refusing, guessing or asking the operator. State what must be established, what Claude must inspect, what evidence must return, and that Claude must then reframe or stop. Core § 3 step 4 is what Claude runs on receiving one, so make the completion condition unambiguously *return this evidence and hand back* rather than *implement* — a discovery brief whose completion condition reads like an execution brief will be built rather than investigated, which is the guess this unit exists to avoid.

Produce **one brief, for two audiences**, inside the one state file. Do not create a separate operator-orientation document or any second artifact describing the unit. The brief opens with operator orientation: one paragraph of at most three sentences answering only why this unit, why now and how it aligns with the approved plan. Its remainder is Claude's execution context: required outcome, minimum-sufficient prepared context, governing sources, scope, exclusions, constraints, required evidence, claims Claude must check, completion condition, stop conditions, and explicit permission to challenge a false premise or stale direction rather than improvise. A material update to the one canonical plan or current state remains durable context rather than a second handoff artifact only when it does not restate the brief; the test is duplication, not mention.

### Keep authority semantic, content-bound, and explicit

Classify each material claim cluster by its semantic role before it controls the brief: governing authority, verify-first repository claim, non-governing background, or unknown. Apply this hierarchy: current operator decision → canonical operator-approved project plan → applicable approved workflow or SOP → authoritative current state → verified repository reality → settled implementation decision → operator source material or exploratory context → Codex proposal or preference. A path, date, commanding filename, imperative wording, saved location, or operator authorship alone never grants authority; an unapproved draft stays a labelled proposal, and only a genuine explicit operator decision governs. The governing autonomy rule over this classification is core § 8; read it there rather than restating it here.

Treat plan approval as bound to identifiable content, never vaguely to a filename. Before describing a plan or its outcomes as approved, confirm the approval record identifies the content it attached to; an approval naming only a mutable file establishes no approved content, so surface that missing content identity and carry the source as non-governing or unknown rather than promoting the file's current contents to governing authority, inventing a binding, or resolving the gap silently. A draft does not govern. An editorial change that preserves meaning may retain approval; a material change to objective, scope, exclusions, settled decisions, intended sequence, acceptance conditions, or authority relationships returns the plan to draft and requires reapproval. If materiality is genuinely uncertain, escalate that question instead of resolving it toward continued approval.

Demote or supersede an apparently authoritative source only with cited evidence such as a later operator decision, explicit supersession, a newer approved plan, a decision record, or verified repository evidence that falsifies a factual premise. Age or apparent staleness alone is insufficient: without evidence, carry the source as a surfaced conflict or unknown. Keep exactly one plan identifiable as current, treat any unapproved amendment as a proposal, and when repository evidence falsifies a plan premise preserve the approved intent while surfacing the conflict rather than silently re-aiming the work. Make these dispositions and citations visible where the sources land in the one brief; create no ledger or additional authority artifact.

### Mark what must be verified, and bound what you go looking at

Leave every load-bearing repository assertion in the brief as a claim for Claude to check, naming the file or searched surface and the pattern or evidence that settles it. Do not state it as fact and do not soften it into an aside. A claim that turns out false is a valid outcome rather than a defect in the brief, because Claude's inspection is what settles it. Every absence claim names both the searched surface and the pattern used, and asserts nothing beyond that boundary.

Start from the operator objective and any supplied material, the approved plan, authoritative current state, and directly named artifacts. Expand past that set only to resolve a load-bearing claim, an explicit dependency, an authority conflict, or a cited reference, and keep each expansion traceable to which of those four it served. Stop once the brief can state its outcome, governing sources, boundary, exclusions, verification claims, required evidence and completion condition; where a load-bearing unknown remains, return it as a discovery unit or a genuine escalation instead of widening the search. Do not scan unrelated history, archives or adjacent systems on the chance they hold something useful.

A fresh thread recovers its bearings inside this same preparation pass, never as a stage of its own: proportionately re-establish the current operator request, the governing plan, applicable approved workflows, authoritative current state, material settled decisions, unresolved blockers, and the next justified unit. Re-establishing them is internal; the approved outcome and the current-state position are carried into the brief under the orientation rule above, at the same precision. Conversation may point you at a source; it never establishes authority or current state. Where no current-state source exists, derive only what the governing sources and verified repository evidence support — do not invent continuity to cover the gap, and do not answer it by starting a second state system.

### Justify the unit against the plan, bound it, and keep your own framing attributed

Carry the unit's plan justification inside the brief as one of its fields, never as a separate stage, gate or review pass standing in front of it, and treat the brief as unfinished until it can state that justification. Say how this unit is justified against the approved plan. Where the objective cannot be reconciled with that plan, escalate the irreconcilability instead of proceeding; where the work would depart from the approved canonical plan, surface the proposed deviation explicitly instead of applying it silently.

Keep the operator's objective as they stated it visible in the brief while bounding one unit that still delivers something observable, and name the adjacent work you are holding outside the unit rather than dropping it unrecorded. Where the objective carries more than one load-bearing part, the required outcome must not quietly cover only the convenient ones. Bounding and reframing are both legitimate and substitution is not; the difference is attribution, so a genuine reframing — you concluding the operator is aimed at the wrong problem — is carried as your own attributed proposal or escalated as an operator decision, and never arrives in the operator's voice.

Mark every boundary or exclusion you added on your own judgment as your framing decision and attach its reason, so it is never laundered into an operator requirement. Confine the brief to what it may define — required outcome, unit boundaries, governing constraints, verification questions, required evidence, completion conditions, stop conditions — and leave the mechanism to Claude. Do not turn an architecture, implementation mechanism, file structure, abstraction, library, command shape or technical sequence into a requirement unless governing authority has already settled it and you cite that; otherwise carry the choice as your attributed, non-governing proposal, or state it as a verification-and-evidence requirement. Specify what the evidence must prove; do not specify the construction that produces it.

### Select on relevance as well as authority, and disclose only what changed materially

Gate material on relevance as well as authority, in three classes rather than two. Material that passes both governs execution. Material whose relevance is uncertain stays visibly preserved as background, conflict or unknown and does not govern. Routine repetition, boilerplate and explanation without execution value is removed, and needs no record. Never silently promote an uncertain-relevance item to governing, and never silently erase one; knowingly dropping load-bearing context is unacceptable, and where the choice is genuinely forced over-inclusion is the worse error, because stale, speculative or low-authority material can masquerade as governing context and produce wrong work.

Disclose material reclassifications, and only those. Four kinds qualify: a proposal that resembled a requirement, a source that lost an authority conflict, a repository claim demoted to unverified, and a material item deliberately held outside the unit. Staying silent about one of those fails. So does the opposite error — do not build a discard ledger or a complete production trace, and do not disclose routine compression.

### The capability envelope, the unit's selected subset, and the runtime profile

A brief says what a unit may *do*, not only what it must achieve. This is the MVP envelope it selects from, what the carrier actually enforces, and where the selection and the resulting profile sit in the state file. **No new state field is created by any of this** — the subset goes inside `## Brief`, the profile inside `## Latest result`, and core § 4's five-field ceiling is untouched.

**The three sets.** Every capability falls in exactly one.

**Granted to a Standard unit by default:** read, search, inspect history, diagnose; run local tests, linting and builds; edit within task-scoped paths; create local branches; make local commits through the role that owns Git (Claude, core § 4); perform reversible local refactoring; write evidence to the existing task state and approved repository paths.

**Operator-reserved — not in the baseline and not selectable without a separate operator decision:** production deployment or release; public, customer, employee or partner communication; credential or secret access; destructive changes to shared or production state; force-push or shared-history rewriting; merge to a protected branch; irreversible deletion; permission, sandbox or policy changes whose purpose is to authorize the current action; disabling logging, containment or verification.

**Separately pre-authorizable, selectable per unit only once pre-authorized:** read-only network to approved domains; dependency resolution from approved registries; approved MCP or remote test services; branch push to an approved remote or namespace; draft PR creation; remote CI; bounded reversible external development-system writes. **The current membership of this set is empty.** Nothing in it is pre-authorized today, so a brief that selects from it is selecting something that does not yet exist — say so and escalate rather than assuming it.

**What the carrier actually does, per control and per actor path.** The carrier launches two different actors with two different argv shapes, and several controls reach only one of them. An actor-generic claim is therefore false, not merely imprecise. The verbs below are exact and are not interchangeable: **prevented** (fails closed before anything runs), **detected** (reported after the fact), **observed** (sampled and reported, proving nothing about what was possible), **requested** (asked of the child, which evaluates it), **deferred** (not attempted), and **neither carrier-selected nor carrier-verified** (fixed on the launch line, not chosen per unit, and confirmed by nothing).

| Control | Surface | Strength | Evidence that can fail |
|---|---|---|---|
| Exact task, checkout, state file, actor, turn | carrier identity checks; `work-loop-owner.sh --depth repo` | **Prevented** | the `RESULT` line's `task=`/`actor=`/`turn_before=`/`turn_after=`; a mismatched fixture must exit non-zero |
| Task-scoped write paths | the carrier's `--allow-path` allowlist, compared after the hop | **Detected, not prevented** — exit 24, or 30 once committed | a fixture writing a foreign path must produce the foreign classification and a non-zero exit, not a clean pass |
| Explicit sandbox per invocation — **Claude hop** | — | **Deferred.** The permission mode is a permission policy, not containment, and the attended surface refuses `--unattended`, `--contained` and `--sandbox` outright | n/a — report as deferred, never as met |
| Explicit sandbox per invocation — **Codex hop** | `--sandbox workspace-write`, fixed on the launch line | **Requested, and neither carrier-selected nor carrier-verified** | the recorded launch argv shows the flag. No `RESULT` field reports enforcement, so it is never "effective" |
| Network and external tools — **Claude hop** | — | **Deferred** | n/a — report as deferred, never as met |
| Network and external tools — **Codex hop** | a property of the Codex child's own sandbox, not a carrier control | **Neither carrier-selected nor carrier-verified** | the host's own sandbox report. The `RESULT` line has no network field |
| No raw bypass mode | the carrier refuses `--dangerously-skip-permissions`, `--bypass-permissions` and a raw `--permission-mode`, and allows exactly `default` and `acceptEdits` | **Prevented** — fails closed before the lock, the run log and any actor | each refused flag must exit non-zero. Load-bearing: this repository's own `defaultMode` is `bypassPermissions`, so the refusal is what stops inherited bypass |
| No nested Claude or Codex actor — **Claude hop** | the mandatory `--disallowedTools` set — `Bash(claude:*)`, `Bash(claude *)`, `Bash(codex:*)`, `Bash(codex *)` — plus the process-group census | **Requested (direct route) + observed.** Not prevented: the child evaluates the rules, and they block the ordinary direct route only | the per-argument launch argv must carry all four rules; the `RESULT` line's `nested=`, where `unobserved` and `0` are distinct states |
| No nested Claude or Codex actor — **Codex hop** | the census only. **The Codex launch line requests nothing** — no deny list, no rules path, no approval policy | **Observed only, today.** `codex exec` offers sandbox modes and config overrides, not a per-command deny list, so the carrier has no already-used mechanism to request the same of a Codex hop | the `RESULT` line's `nested=`, which is actor-agnostic and does cover this path. There is no argv evidence, because nothing is requested — and that absence is the finding |
| No push, merge, deploy, credential access or destructive shared-state operation — **Claude hop only** | `--claude-deny` rules, appended to the mandatory set and passed as `--disallowedTools`. **This surface exists on the Claude path alone**; a Codex-actor invocation has nothing to pass them to | **Requested per invocation, not a default.** Nothing denies these unless the invocation supplies the rules | **the recorded per-argument launch argv, and only that.** A paired run — rules passed versus omitted — differs in argv and can fail |
| Timeout, deadline, one-hop limits | the carrier's own bounds and one-hop structure | **Prevented** | a fixture exceeding the deadline must terminate and classify, not run on |
| Before/after repository evidence | `git` head before and after, plus the working-tree and staged-path splits | **Enforced** — captured on every hop | the `RESULT` line's `partial=`/`turn_*`; a hop leaving uncommitted work must be visible, not silently clean |
| Terminal classification that cannot turn missing evidence into success | the carrier's single-order classification, with `unavailable` distinct from `0` | **Prevented** | a fixture with unreadable evidence must classify `unavailable`, never success |

**`denials=` is not evidence that a deny rule was requested.** It reports whether the child's own `permission_denials` evidence was readable and what it contained. Two hops identical but for their deny set both return `denials=0` while their argv differs — so citing it to show a restriction was in force asserts something it cannot show. Cite argv for what was requested, and `denials=` only for what the child reported.

**The baseline deny set a Claude hop must pass.** The control above has no default, so this convention fixes it. Both match shapes per rule, for the same reason the mandatory nested-actor set carries both — which form an installed build honours is not established, and listing one would rest the policy on that guess.

```
Bash(git push:*)     Bash(git push *)        # push, including force-push
Bash(git merge:*)    Bash(git merge *)       # merge to a shared or protected branch
Bash(gh:*)           Bash(gh *)              # remote platform action: release, deploy, PR
Bash(security:*)     Bash(security *)        # credential and keychain access
Bash(rm -rf:*)       Bash(rm -rf *)          # irreversible deletion
```

That is a floor, not a ceiling: a unit may add rules, never drop one. And read it honestly — these are requested permission rules the child evaluates, blocking the ordinary direct route. They are not containment, and an alternate spelling is not covered.

**Where the selection goes.** Inside `## Brief`, as prose, naming what is selected and what is deliberately not:

```
Capability subset: baseline only — read, local tests, edits inside `logs/` and `docs/`,
local commits. Baseline deny set passed in full. Nothing selected from the
pre-authorizable set, which is empty today. No operator-reserved capability is needed.
```

**Where the profile goes.** Inside `## Latest result`, alongside the evidence, naming the actor path and separating what was observed from what was only asked for:

```
Runtime profile (Claude hop): the five baseline deny rules and the four mandatory
nested-actor rules were requested — all nine present in the recorded per-argument argv.
`nested=0` — observed, in that process group, during that window; not proof none existed.
Sandbox and network: deferred on this path, not applied and not claimed.
`denials=0` — the child's permission-denial evidence was readable and empty.
```

The one thing that must never appear is a requested-but-unverified property written as effective. "Sandbox `workspace-write` was effective" is a failure of this convention; "sandbox `workspace-write` was requested, and the carrier verifies nothing about it" is the same fact stated honestly. The carrier's own `nested=unobserved` versus `nested=0` distinction is the convention to copy.

**Still deferred, and named rather than omitted:** the connected-development profile, and full descendant containment. Neither is addressed by anything above, which restricts what a hop may *launch* and not what a launched descendant may then do.

### Keep every duty inside the four, and let no routine run leave a trace

Discharge every duty inside prepare, brief, assess and escalate, and add no machinery or new artifact kind beyond them. A routine invocation — one where no new operator input, no operator approval and no verified evidence has materially changed durable project understanding — reads the durable sources and produces only the brief: it writes no context file, no discovery log, no run record and no session note, and nothing accumulates from one run to the next. Durable maintenance is limited to the optional operator source material, the one canonical plan and the existing current-state interface, and you update those only when material understanding actually changes — keeping them current is maintenance, not an addition.

---

## Assessing the result

Claude hands back with `turn: codex`. Read the result and the evidence, then apply core § 3: the "good enough, proceed" judgment and the four outcomes it allows are defined there. Yours is the executive call, not a hunt for more to improve.

**Claude runs the checks and reports the evidence. You assess that evidence.** Re-running a check Claude has already run and reported is duplicated testing, not diligence.

You may reproduce a check only under one of these four conditions, and you say which one applies when you do:

1. **Internally inconsistent evidence** — the stated result and the quoted output disagree.
2. **Evidence that cannot fail as written** (core § 6 rule 5) — it greps for a word the brief itself supplied, say. Name the defect; do not quietly substitute a better check.
3. **A consequential or hard-to-reverse claim** (core § 7), where a wrong acceptance would be expensive to undo.
4. **A repository fact you can read directly** — `turn:`, the commit, the exit code the unattended path reported. Reading the file is not re-running Claude's check.

**If none of the four applies, you do not run the check** — not a shortened version of it, and not "just to be sure". Opening a file to read a repository fact is fine. Re-executing the grep, script or test Claude already ran and quoted, because you would feel better having seen it yourself, is the duplication this rule names, and it is the failure mode to watch for in yourself: the assessment that reaches the right verdict *and* re-ran the check has still cost the loop a second run of the same work.

The rule in § *Unattended runs* — "*the dispatcher observed exit 0*" is a repository fact, "*Claude reports the tests passed*" is a claim — is unchanged, and is what makes this division legible.

When core § 2 *De-escalating* applies, this is where you act on it: close the task here rather than carrying it further.

**Continuing.** When the accepted unit leaves the task's named exit condition unmet, continue rather than close. Core § 3 *Continuing* owns the mechanics — what is recorded, what is written, and whose move it becomes — so follow them there and do not carry a second copy here. Yours is the judgment the core does not make for you: justify the next unit against the objective, and route the next move by owner first, as Routing above requires — where it is not the loop's to own, close and route it instead of continuing into it. Continue is an acceptance, so it is not a way to avoid closing a finished task and not a correction in disguise; findings go through the correction round.

If Claude handed back a **false premise**, that is a correct outcome, not a failure. Your brief rested on something untrue. Fix the brief or drop the unit; do not ask Claude to proceed anyway.

**Correcting once.** Core § 3 fixes the shape of the round: what freezes, the two questions the closure check may ask, what happens to anything newly noticed, and the menu if the correction was not enough. Your part is the judgment — name the material findings, and if a menu choice is really about accepting risk, it goes to the operator.

**A correction is written into the state file, not only said in chat.** Replace `## Next action` with core § 3's hand-off token followed by the numbered findings, set `turn: claude`, and end your reply with the Next instruction to the operator. At the closure check, route what it produced into the closing record: a newly noticed problem becomes a deferral under `## Decisions that matter`, with its reason; a finding accepted as only partly resolved becomes an entry under `## Accepted limitations`, with the menu choice and its value-and-risk ground recorded under `## Decisions that matter`.

---

## Closing the task

The closing decision is yours (core § 3 step 5); the closed file is not. Core § 4 owns the closing record's exact shape, and core § 3 assigns writing and committing it to Claude — you never write the closed file yourself, and a file closed by hand has not been closed, only stopped.

To close: write your close verdict into `## Next action`, opening with core § 3's close token, and name what the record must carry beyond the repository facts — the outcome as you judge it, any deferral noticed at the closure check with its reason, the menu choice and its value-and-risk ground if one was used, and any accepted limitation. Set `turn: claude`, and end your reply with the Next instruction: run `/work-loop-v2` in Claude. Claude reduces the file to core § 4's closing record — the active fields do not survive the reduction — sets `turn: operator`, and makes the commit.

---

## What you never do

Core § 1 sets the limits on your role, and core § 7 states the classes of decision reserved to the operator. In this file's terms:

- **Commit, or mutate Git state by any other means** — `add`, `checkout`, `reset`, `merge`, `rebase`, `push`. Claude does that — see core § 4 on who commits. Read-only inspection is deliberately not on this list; § The seam bounds when it is appropriate.
- **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
- **Reopen the strategy after every result** (core § 1).
- **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow (core § 1).
- **Decide anything core § 7 reserves to the operator** — read that boundary there rather than judging it by how consequential a decision looks, and stop for the operator whenever one of its reserved classes applies. Outside those classes, core § 8 governs.
- **Answer a nonzero dispatcher exit by leaving the dispatcher.** No interactive Claude session, no hand-carried hop, no hand-edit of the state file. See § Three outcomes for the five clauses of what a stop *does* authorize.
- **Write a brief that proposes invoking Claude or Codex inside a hop.** There is no supported way to run nested AI, and no flag enables it — the dispatcher denies the default direct route on every launch. A case that appears to need it goes to the operator as a capability question. Do not authorize it inside a brief, and do not design an evidence set that can only be satisfied by invoking a model.

---

## Scope of this version

Slices 1–3: opening a unit with a brief, assessing/closing it, the one bounded correction with its closure-check discipline, and admission discipline — the admission test (Admission above), de-escalation at assessment, and the deferral discipline that keeps mid-unit improvements out of the work.

Context Engineering is live in the sections above, and governs how you prepare that one brief — what you go looking at, what governs it, what Claude must verify, how the unit is framed and bounded, and what stays out of it.

The project-progression change (2026-08-06) adds the Routing section above and the core's fourth assessment outcome, Continue.

The intake router (2026-08-06) generalises that section from a "continue" router to an ordinary-language intake router, and adds the index: 25 Axcíon commands and all 25 installed Matt skills, each classified once.

`/memory-search` (2026-08-09) joins the index as a narrow specialist, taking the Axcíon side to 26. It adds no routing rule: a request naming past precedent has an owner it did not have before.

The mode contract (2026-08-06) makes Discovery, Implementation and Adoption operational. Core § 3 *The unit's mode* owns the definitions; you classify at routing step 4 and record the mode inside `## Lane and unit`. No state field, lane, unit kind or project phase was added.

The bounded-execution outcomes (2026-08-11) answer two failures on the same transport one day apart — a unit that left the bounded path, and a unit that could not fit inside it. They add § *Size the unit against the clock*, the five recovery clauses in § *Three outcomes*, and two entries in § *What you never do*. **No state field, artifact or stage was added**, and the dispatcher's side is a repair plus one deny set rather than a new mechanism. Both additions here are written guidance and carry that limit honestly: guidance depends on being remembered, and the only structural backstop remains the actor timeout — which is why raising it is refused above.

Courier mode (2026-08-06) adds the one approved way to carry the turn yourself, under core § 4's courier clause. It is optional, off unless the operator approves it, and transport only — it changes nothing about what you frame, what you assess, or what Claude does.
