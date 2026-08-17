# Courier operation — carrying the turn yourself

**Read this only when the operator has approved courier operation, or when a run is in flight
or being assessed.** Courier mode is optional and off by default; if it has not been approved
for this session, end your reply with the Next line and stop.

**Contents**
- Attended carry versus unattended run — the two approved shapes and their programs
- The attended command in full, and the six hard rules
- Unattended runs — the clock, containment, the per-task allowlist and the Next line
- Three outcomes, the exit-code table, and what a stop authorizes

## Courier mode — carrying the turn yourself

Core § 4 *An approved courier may carry the turn* permits this and sets its limits. Read them there. This section is the approved courier and how you operate it. **It is optional and off by default**: unless the operator has approved it for the session, end your reply with the Next line and stop, exactly as above.

**There are two approved shapes, and the operator's presence picks which.**

| Shape | Program | Use it when |
|---|---|---|
| **Attended carry** | `scripts/axcion-harness-v0.2/carry-turn.sh` — Axcíon Harness v0.2 | The operator is at the machine. You carry **one** hop, then read the file and assess. The loop does not run on without you. |
| **Unattended run** | `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, loop mode | The operator is leaving. You frame the unit, launch, and get out of the way. The loop alternates Claude ↔ Codex until the validator classifies the record `BLOCKED_OPERATOR` or `CLOSED`, or until the deadline or a guard. |

**These are two different programs, and neither does the other's job.** The attended carrier carries exactly one hop per invocation and has no loop mode, no unattended mode, no worktree automation and no flag to ask for one: `--carry-one`, `--unattended`, `--max-hops` and `--status` are all refused with exit `10` before anything launches. It reports no out-of-band status either — the state file is its status, and a carry already in flight exits `17` naming the holding pid. So do not carry an attended hop with the spike dispatcher, and never reach for the carrier when the operator is leaving.

Everything below applies to both unless it names one. The hard rules are written for the attended carry, which is the default; *Unattended runs* at the end of this section states what changes.

**What you drive is a terminal command, not Claude.** You never type into a Claude window, never read Claude's interface for progress, and never click through its prompts. You run one command and read its exit code. The courier program launches the actor, validates the state file before and after, and stops on anything unexpected — that instrumentation is the reason this is the approved courier and screen-driving Claude directly is not.

**Neither shape is context-bounded, and it is worth being clear why.** Every hop is a **fresh process** (`claude -p`, `codex exec`). Nothing accumulates across hops; `logs/work-loop/{task-id}.md` is the entire shared memory. A run ends when the record classifies `BLOCKED_OPERATOR` or `CLOSED`, at its hop limit, at its deadline, or at a guard — never because a context window filled. Do not plan around a context budget that does not exist.

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
6. **`BLOCKED_OPERATOR`, `CLOSED`, a state file the validator refuses, and a permission prompt are all terminal.** Stop and tell the operator. You do not approve prompts and you do not work around them. A record the validator cannot classify is terminal in the same way as the other three: it is not an invitation to read the frontmatter yourself and carry on.

**An unchanged `turn: claude` does not mean the command failed to land.** Claude leaves the file *completely untouched* when it rejects one — an identity mismatch or unreadable frontmatter is a correct read-only refusal (core § 6 rule 2), not a lost message. There are three causes and both programs already separate them, under the same three codes: `14` identity mismatch (Claude was never launched), `22` no transition (Claude ran and changed nothing), `21` timeout (Claude was still working). Read the code. Do not infer the cause from the turn, and never treat an unchanged turn as permission to send again.

**Operating defaults — preferences, not protocol.** Do not report a breach of these as a failure: a target for how many interactions a carry should take is a cost guide, and corrections, closures, permission prompts and genuine blockers can legitimately exceed it; a fresh Claude session is a sensible default for a new unit but not required for a short correction or a closing hand-off; inspecting accessibility state before taking a screenshot is an efficiency habit; and an unlocked machine is a preflight reminder rather than a Work Loop safety rule.

**This does not loosen the mutation boundary.** Launching the dispatcher is not mutating Git state. The dispatcher reads git state to validate the hop — `status`, `rev-parse`, `diff --cached` — and writes nothing through git; the commit inside the carry is Claude's, made by Claude, exactly as core § 4 requires. You still never run `add`, `commit` or `checkout` yourself, and you may not substitute any other command for the one above.

### Unattended runs — when the operator is leaving

**A different program: the spike dispatcher in loop mode**, not the attended carrier — the carrier refuses `--unattended` and every multi-hop flag before it launches anything. Same guards, `--carry-one` dropped. What changes:

**Add a clock, and isolate the run.** `--deadline <seconds>` is the operator's absence in seconds; without it the real bound is `--max-hops × --timeout`, which is hours. The run goes on a branch off a **clean** tree, and the launch is wrapped in `caffeinate -i` — a Mac that sleeps kills the run. The worked invocation is in the spike `README.md`; use it rather than assembling one.

**Contain the child: pass `--unattended`.** An unattended Claude hop runs with less authority than an attended one, and this is the flag that applies it — not `--claude-deny`, which is a permission-layer narrowing that leaves the network wide open. `--unattended` gives the child an OS-backed sandbox with an empty network allowlist, shell and Skill tools only, no MCP, hooks, connectors, remote control, subagents, built-in file tools or push, and credentials stripped from subprocesses. It fails closed (exit `31`) rather than running uncontained, and refuses to combine with `--actor-cmd`. `--claude-deny` still composes and can only narrow further.

Three things to know rather than discover mid-incident. **The run log records the *requested* policy, not the effective one** — array settings keys merge across scopes, so another scope on the host can widen what the child reads; the effective policy was measured once, on one host (`runs/probe-unattended-integration-2026-08-07.md`). **Where the effective policy *is* readable:** an unattended hop is captured as `--output-format stream-json`, so the hop's `.out` opens with the product's own `system/init` event, and that states the tool roster and MCP servers the runtime actually resolved. Read that, not the argv and not the child's account of itself. And **`~/.gitconfig` is one deliberate exception** inside an otherwise denied home directory, because Git exits before touching the repository without it; if a real secret is ever put in that file, the exception stops being safe.

**The allowlist becomes a per-task input.** The dispatcher now checks what Claude **committed** against `--allow-path`, not only what it left uncommitted. So the allowlist has to describe what *this unit* may legitimately touch. Derive it when you write the brief. Too narrow stops correct work; too wide and the check means nothing.

**The Next line changes shape.** The rule that every reply ends with an explicit next instruction (§ The seam, in the main skill) assumes the operator carries the turn. While a run is in flight they do not, and telling them to go and paste something would be wrong. **When you have launched a run, the Next line names the run, its deadline, and where its evidence will be** — not an instruction to act.

**Once you have launched, the state file is not yours until the run exits.** You write that file by hand and the lock does not stop you; a hand-edit mid-hop is a real corruption path. Check before touching it:

```
dispatch.sh --checkout <path> --task <task-id> --status
```

`--status` is read-only — no lock, no log, no write — and safe against a live run. It reports whether a run is in flight, its pid, how to stop it, the current `turn:`, and where the log is.

**Do not mix the shapes.** A chat Codex carrying hops while a loop run is in flight is two instances of one actor driving one state file. `--status` is how you tell.

**Three outcomes, never blurred.** When the operator returns, the run ended in exactly one of these, and saying which is the first thing you owe them:

| Outcome | Looks like |
|---|---|
| **Finished** | `0` — and `logs/scripts/work-loop-state.sh` classifies the record `CLOSED` |
| **A decision is theirs** | `0` — and the validator classifies the record `BLOCKED_OPERATOR` |
| **Stopped** | any other code — a guard (`18`,`19`,`24`,`25`,`30`,`36`), a failure (`20`,`21`,`22`), a permission dead end (`37`), an ownership stop (`33`,`34`,`35`), the hop limit (`23`), an interruption (`28`), or the budget (`29`) |

**The first two are told apart by the validator, not by reading the file.** Both stop at `turn: operator`, and the difference between "finished" and "waiting on you" is the whole of what the operator needs to hear. Deciding it from whether `## Blocker` happens to have survived is how a closed task got announced as an open question and an unanswered question got announced as done — the run classifies, and you report what it classified.

**`29` is not completion.** A run that ran out of clock is unfinished and resumable. Never report it as done.

**What a stop authorizes — five clauses, and they are one rule.** A nonzero exit is a statement about one bounded hop. Read all five before deciding anything; the first two without the last three produce a dead end, and the last three without the first two reopen the bypass.

1. **A stop is never a licence to leave the dispatcher.** It authorizes fixing the cause and re-running, or stopping for the operator. It never authorizes an interactive Claude session, a hand-carried hop, or a hand-edit of the state file. A dispatcher capability gap is a capability gap — report it as one and ask. It is not permission to do the work another way.
2. **Never repeat a completed hop blindly.** Where the run log proves the actor launched and ran, that hop is not re-run as if it had not happened.
3. **A timeout means the transport stopped. It does not mean the repository task is impossible.** Exit `21` bounds one hop; it says nothing about whether the underlying work can be done. Reading `21` as "this task cannot be completed" is a specific recorded error, not a hypothetical one — it happened on 2026-08-11 and cost a day. The same holds for `29`.
4. **Partial effects are preserved and inspected before anything else is decided.** A stopped hop may have changed allowed files without committing them. The stop now lists those paths under `PARTIAL FILE EFFECTS`. Read them. Do not discard them, and do not assume they are absent because the state file did not move and the branch ref did not advance — those two facts are compatible with real work sitting uncommitted on disk.
5. **A newly narrowed recovery unit is available, with operator approval.** Not a re-run of the same brief and not abandonment: a *fresh, smaller* unit that inherits the preserved partial work and carries one dominant deliverable (§ Size the unit against the clock, in `references/unit-framing.md`). **Operator approval is the gate.** Ask for it; do not resolve it yourself.

**`37` is a capability question, not a transport failure.** A permission dead end means the child was refused something it needed. Raising the timeout, re-running, or rewording the brief will not change it. Report what was denied and ask the operator whether to grant the capability or narrow the unit so it is not needed. **`35` is a different stop and takes a different remedy** — the ownership check could not be run at all (`logs/scripts/work-loop-owner.sh` missing, unreadable or failing), so nothing launched; install or repair the helper rather than treating it as a denial. Any record written before 2026-08-11 that names `35` for a permission stop predates the renumbering — read it as `37`.

**The ownership stops `33`, `34` and `35` are cross-transport.** They carry the same meaning and stop before anything launches whichever program was run: the attended carrier checks repository-depth ownership before it launches an actor, exactly as the unattended dispatcher does at admission, and refuses with these same three codes. They are listed in this table because this is where exit codes are enumerated, not because they belong to the dispatcher alone. Nothing else is shared by this — the two programs' remaining surfaces stay distinct, and no new code exists.

**`36` means Claude did not touch the already-uncommitted state file; it does not prove the hop changed nothing else.** It is most often a Codex handoff that was never committed. Do not read it as a partial edit by Claude — that is exactly the misreport `36` was split out of `25` to stop — and read any `PARTIAL FILE EFFECTS` block for other allowed work the hop left behind.

**Separate repository facts from model claims.** Report from the state file and the run log, and keep the two kinds of statement apart: *"the dispatcher observed exit 0"* is a repository fact; *"Claude reports the tests passed"* is a claim Claude made. Neither means you accepted the evidence — that is still your assessment to make (§ Assessing the result, in the main skill), and an unattended run does not do it for you.
