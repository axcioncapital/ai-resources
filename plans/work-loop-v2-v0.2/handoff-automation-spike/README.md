# Work Loop v2 — handoff dispatcher spike

**Throwaway spike. Not production, not installed anywhere.** Everything in this directory exists to
answer one question: can two products carry a Work Loop v2 turn between them, in one checkout,
without the operator moving the file by hand?

The controller is `dispatch.sh`. It carries **one exact task** through routine Codex ↔ Claude turns:
it launches at most one actor at a time, re-reads the authoritative state file from disk after every
process exit, and stops visibly rather than guessing. It creates no queue and no shadow state —
`logs/work-loop/{task-id}.md` stays the only semantic interface, and the controller's entire memory
is the task id it was given at launch.

Files here:

| File | What it is |
|---|---|
| `dispatch.sh` | The controller. |
| `dispatch.test.sh` | Failing-case harness for the controller. Entirely simulated. |
| `ps-sampler.sh` | Helper that samples running processes during a live run. |
| `runs/` | Per-run evidence: one `.log` per run plus one `.out` per hop, and any written-up **live** product evidence. |

---

## Running the dispatcher

```
dispatch.sh --checkout <abs-path> --task <task-id> [options]
```

Both `--checkout` and `--task` are required. `--checkout` must be a directory that is a Git
checkout; `--task` must match `^[A-Za-z0-9][A-Za-z0-9._-]*$` and is rejected before any path is
built from it.

| Option | Default |
|---|---|
| `--carry-one` | off — carry exactly one hop, then exit `0` (see below) |
| `--max-hops N` | `4` — absolute hop limit; forced to `1` by `--carry-one` |
| `--timeout S` | `900` — per-actor wall-clock seconds |
| `--deadline S` | none — whole-run wall-clock budget (see below) |
| `--codex-bin PATH` | `/Applications/ChatGPT.app/Contents/Resources/codex` |
| `--claude-bin PATH` | `claude` resolved from `PATH` |
| `--allow-path RE` | `^logs/work-loop/` and `^plans/work-loop-v2-v0\.2/handoff-automation-spike/` (repeatable; supplying any replaces both defaults) |
| `--claude-deny RULE` | none — repeatable; passed to the Claude child as `--disallowedTools RULE` |
| *(no flag)* | every attended Claude hop is launched with `--permission-mode default` — always on, cannot be turned off (see below) |
| `--log-dir DIR` | `<checkout>/plans/work-loop-v2-v0.2/handoff-automation-spike/runs` — the spike's `runs/` **inside the checkout being driven**, not inside whichever checkout this script lives in. Driving this checkout resolves to the same directory as before, so nothing moved. |
| `--dry-run` | off |
| `--status` | off — read-only report; takes no lock, writes nothing; answers IN FLIGHT / STALE LOCK / UNKNOWN — CANNOT INSPECT |
| `--actor-cmd CMD` | none |

### The two locks, and the declaration they do not replace

The dispatcher takes **two** locks, both under the repository's **Git common directory**
(`<common>/work-loop-dispatch-locks/`) — one keyed by task, one keyed by checkout. A second
dispatcher is refused (exit 17) if **either** is held, and the message names the conflicting task or
checkout rather than printing a hash.

This replaced a single composite `sha256("$CHECKOUT|$TASK")` key under `${TMPDIR:-/tmp}`, which
failed in two independent ways:

- **`${TMPDIR}` is caller-controlled.** Two dispatchers launched with different `TMPDIR` roots
  computed the same key beneath different parents and never contended at all. On macOS, per-session
  `TMPDIR` values are ordinary, not exotic.
- **A composite key enforces neither resource alone.** Two *different* tasks in *one* checkout hash
  to two different keys, so both were admitted — and once they share a working tree and index,
  either can sweep the other's paths into a commit.

The locks govern **live process** exclusivity only. Open-task exclusivity is a different question
with a different lifetime, and it belongs to `logs/work-loop/.owner` (see
`logs/scripts/work-loop-owner.sh`): a lock cannot outlive its process, and continuity between
handoffs must. The dispatcher reads that declaration at admission via the shared helper, at `repo`
depth, and refuses with **exit 33** (this task belongs to another checkout, or this checkout is held
by another task) or **exit 34** (ownership is ambiguous — typically a state file replicated across
checkouts with none declaring it). Nothing is launched in either case, so nothing is committed.

**The check fails closed.** A checkout that does not carry the helper — or carries one that cannot be
read or exits with anything other than `0`/`3`/`4` — gets **exit 35** and launches nothing. It does
*not* skip with a visible line, which is what it did until 2026-08-11. The distinction the exit code
has to preserve is between *a check ran and found nothing wrong* and *no check ran*: only the first
is evidence, and the checkouts least likely to carry the helper — older siblings, partial copies —
are exactly the ones most likely to hold a conflicting writer. This is deliberately unlike the
session-identity init, which does skip when its allocator is absent: that one arms a tripwire, while
this one is the only thing standing between two writers and one checkout.

`--status` reports both: the checkout's declaration and whether the checkout lock is held, alongside
the existing three-valued task-lock verdict. It still takes no lock and writes nothing.

### The four modes

- **`--help`** — prints the header block and exits. Validates nothing, launches nothing.
- **`--status`** (`mode=status`) — reports whether a run is in flight for this checkout + task, what
  the state file says, which branch `HEAD` is on, and where the run log is. It takes **no lock**,
  creates **no log directory**, and writes nothing at all, so it is safe to run against a live run —
  which is the whole point of it. Returns `0` even while another dispatcher holds the lock.
  It answers about the lock in **three states, never two** — see below.

#### The three lock states

`--status` reads the lock's pid and reports one of three things. The third exists because a failed
`kill -0` is not proof of death: it fails both when the process is gone (`ESRCH`) and when the
caller is merely not allowed to look (`EPERM`).

| `run:` line | What it means | What the operator should do |
|---|---|---|
| `IN FLIGHT — dispatcher pid N` | The pid is visibly alive and signallable | Leave the state file alone. `kill -TERM N` to stop it |
| `STALE LOCK` | The pid is **positively** absent — `kill -0` said *no such process* | Clear it: the command prints the exact `rm -rf` |
| `UNKNOWN — CANNOT INSPECT` | The pid could **not be inspected** — permission denied, no pid file, an unrecognised error, or a pid that is not a usable process id (see below) | **Nothing destructive.** Assume the run may be live. Re-run `--status` from somewhere permitted to inspect processes |

**A valid lock pid matches `[1-9][0-9]*`, and "numeric" is not that test.** `0` and `00` are numeric
but must never reach `kill(2)`: pid `0` means *every process in the caller's own process group*, so
`kill -0 0` **succeeds**. Until 2026-08-07 a lock holding `0` therefore reported
`IN FLIGHT — dispatcher pid 0` and instructed `kill -TERM 0` — which would have signalled the
operator's own shell and everything in it. A zero-*prefixed* value is the quieter form of the same
bug: `007` reaches `kill(2)` as pid 7, so the verdict was a true statement about an unrelated
process, printed as a statement about this lock. All of these are a corrupt lock, which is something
`--status` cannot inspect — so they report `UNKNOWN`, and the output contains no `IN FLIGHT`, no
`STALE LOCK`, no `kill -TERM` and no `rm -rf`. Case `30f` pins each one.

Only the first two are conclusions. `UNKNOWN` prints the evidence for its own verdict on a `why:`
line, still reports the pid, lock path, state file and latest run log, and **never** recommends
removing the lock. All three exit `0` — the exit code answers "did status run?", not "is the run
alive?", so read the `run:` line and never the exit status.

> **Why the third state exists.** Phase 0 § 0b item 3 ran `--status` against a genuinely live
> dispatcher (pid 79266) from inside the ordinary Codex command sandbox. Sandbox policy refused
> `kill -0`, the old two-state check read that refusal as death, and the output reported `STALE LOCK`
> and told the operator to `rm -rf` a lock that was doing its job. Acting on that answer means
> hand-editing a state file mid-hop — the exact corruption the skill's rule exists to prevent. The
> bias is deliberate and one-directional: a false `UNKNOWN` costs one more look, a false `STALE LOCK`
> costs a live run. Cases 30d/30f cover the uninspectable pid; **case 30e is the positive control**
> that keeps a genuinely absent pid reporting `STALE LOCK` rather than everything collapsing to
> `UNKNOWN`.
>
> **Independently accepted, 2026-08-07 — 1g is complete and not a Phase 2 blocker.** The Codex
> sandbox that found the defect re-ran the check against the **corrected** dispatcher (three states
> plus PID validation) and confirmed every state live:
>
> | Checked | Result |
> |---|---|
> | Live dispatcher PID hidden by sandbox policy | `UNKNOWN — CANNOT INSPECT` |
> | The **same** live PID inspected from outside the sandbox | `IN FLIGHT` |
> | Terminated PID | `STALE LOCK` |
> | Invalid-PID checks (`0`, `00`, zero-prefixed, non-numeric, empty) | passed |
> | Full dispatcher suite | **198 pass, 0 fail** |
>
> The temporary review lock and process were removed; no repository files were changed by the check.
- **`--dry-run`** (`mode=dry-run`) — validates the checkout, the task id, the state file and the
  restart condition, then names the actor it *would* launch and stops. Launches nothing and writes
  nothing to the state file. Unlike `--status`, it **does** take the lock.
- **loop mode** (`mode=live`, or `mode=simulated` when `--actor-cmd` is given) — actually runs the
  turns until the state file reaches `turn: operator`, or until something stops it.

`--status` and `--dry-run` answer different questions and are refused together (`10`) rather than one
silently winning.

### `--deadline` — a wall-clock budget for the whole run

Without it, the real upper bound is `--max-hops × --timeout`; the defaults make that **one hour**, and
a walk-away invocation of `--max-hops 12 --timeout 900` makes it **three hours**. That is not a bound
for someone expecting to be back in forty minutes, so the dispatcher now prints the bound it is
actually running under at startup either way.

`--deadline` is a deadline, not a start gate. The clock starts at the **first statement of the
script**, before argument parsing or any setup. Before every launch — including a retry — the actor's
effective timeout is clamped to `min(--timeout, time remaining)`, and an actor still running when the
clock expires is terminated through the same path as an interruption. The run then exits `29`.

**The honest worst case**, because a deadline is worth what its bound is:

```
overrun <= 1s (poll interval) + 5s (TERM→KILL grace) + reaping  ≈ 6s
```

So `--deadline 2400` ends at roughly 2406s. It never ends at exactly 2400s, and — the point of the
clamp — it never ends at `2400 + --timeout`. Test case 28 asserts this arithmetic rather than a round
number.

**`29` is not completion.** The state file and Git are untouched by the stop, so the work is
resumable: re-run the dispatcher and it continues from the file. But a killed actor carries the same
partial-effect risk as an interruption, so it is **never** retried automatically — inspect first.

### `--claude-deny` — narrowing the unattended child's authority

Plumbing, not a policy. It carries the **operator's** deny rules, and `claude_deny=none` in the run
log means only that no operator rule was supplied.

**It does not mean nothing is denied.** Every attended launch already denies the four nested-actor
rules (see *The default nested-actor deny set*), and `--unattended` already carries the contained
profile's own base denies. `--claude-deny` appends to whichever of those applies; it cannot remove an
entry from either.

Beyond those sets the child's own policy applies. That policy is **not** this checkout's
`bypassPermissions` on an attended hop — the dispatcher states `--permission-mode default` at launch
(see *The attended child's permission mode*) — and `--claude-deny` composes on top of it rather than
replacing it.

What it is for: a run nobody is watching may warrant less authority than an attended one. A rule
passed here reaches the child as `--disallowedTools`, applies to **that child only**, and does not
touch any `settings.json` or the operator's interactive sessions.

**Two facts about it are measured, not assumed** (`runs/probe-unattended-authority-2026-08-07.md`):

- A deny passed this way **beats `bypassPermissions`**. `--claude-deny 'Bash(git push:*)'` stops the
  child pushing, moving that guarantee off a model-side CLAUDE.md rule and onto the permission layer.
- It **cannot** buy network isolation. Denying `WebFetch`/`WebSearch` just sends the child to `curl`
  via Bash — observed, twice, unprompted. Denying `Bash` outright works but stops the child doing the
  work it was launched for. Network containment needs an OS-level sandbox, not a permission rule.

  **That last sentence is true, and Claude Code provides the sandbox** (corrected 2026-08-07,
  `runs/probe-contained-authority-2026-08-07.md`). A macOS Seatbelt sandbox covers Bash and every
  child process, and `strictAllowlist` with an empty `allowedDomains` refuses non-allowlisted hosts
  outright — `curl` was measured being refused. So network isolation *is* available; it simply is not
  available through `--claude-deny`, which remains a permission-layer flag only.

  **`--claude-deny` is therefore not the operator's chosen unattended profile, and must not be
  described as it.** The operator settled on the contained profile (sandbox settings + a restricted
  tool set + push denial together). **The dispatcher now implements it, as `--unattended`** — see the
  next section. `--claude-deny` on its own still leaves the network open, and is now best understood
  as the *narrowing* flag that composes with `--unattended` rather than as an alternative to it.

### `--unattended` — the contained profile (item 1d)

One flag that applies the operator-settled contained profile to **every Claude hop**. The policy and
the mechanism were settled and proven first, in `runs/probe-contained-authority-2026-08-07.md`; this
flag is the part that ships them.

```
dispatch.sh --checkout <abs-path> --task <task-id> --unattended
```

What the child gets:

| Layer | Delivered by |
|---|---|
| OS sandbox on, fail closed if unavailable, no `dangerouslyDisableSandbox` escape | profile JSON |
| Empty network allowlist, `strictAllowlist: true` — no Bash network, no approval prompt | profile JSON |
| `denyRead: ["~/"]`, with `allowRead` re-opening the checkout and its Git common dir | profile JSON |
| Hooks, connectors, remote control, agent view, artifacts and auto-memory off | profile JSON |
| `--tools Bash,Skill` — no built-in `Read`/`Edit`/`Write`, so file access goes through the sandbox | CLI |
| `--strict-mcp-config` with no config — no MCP tools | CLI |
| `--disallowedTools` for push (both rule spellings), `WebFetch`, `WebSearch`, `mcp__*` | CLI |
| `--no-session-persistence` | CLI |
| `--output-format stream-json --verbose` — so the hop capture opens with the product's `system/init` event, stating the **effective** tool roster and MCP servers | CLI |
| `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` — credentials stripped from subprocesses | environment |

**Why the output format differs from an attended hop.** Everything else in that table is a request:
the run log can only say what was *asked for*. `system/init` is the runtime's answer, and it is the
one place a silently-dropped `--tools` or `--strict-mcp-config` would show. The stream's final
`result` event is identical to what `--output-format json` produces, so this capture is a superset of
the attended one, not a different thing. Attended and courier hops keep `json` (case 32j). Added
2026-08-07, after a Codex assessment found the live probe scoring the child's own account of its
tools as though it were a measurement.

**Delivered by CLI `--settings` on every hop, never by a repository settings file.** That is a
correctness requirement, not a preference: `sandbox.network.strictAllowlist` has **no effect** from
`.claude/settings.json`, so writing the profile there would drop the network containment silently —
and would still *look* contained on a machine whose user settings already carry the key. Case 32d
asserts the negative directly: no repo settings file is created, and the delivered path is not inside
the checkout's `.claude/`.

**It fails closed, exit `31`, before anything launches.** The installed `claude` must be **≥ 2.1.219**
(the release that added `strictAllowlist`), the version string must be *readable*, and the platform
must be Darwin. An unreadable version is refused with different words from an old one — "cannot tell"
and "too old" want the same refusal but are not the same fact. `sandbox.failIfUnavailable` makes the
child fail closed at its end too.

**`--claude-deny` composes and is additive.** Operator rules append to the profile's base denies; they
can narrow it further, never widen it (case 32i).

**It refuses to combine with `--actor-cmd`** (exit `10`). A simulated actor cannot be contained, so
the pair would produce a run log reading "unattended" for a run in which no profile reached anything.

**`--dry-run --unattended` is a real preflight.** The version gate, the platform check and the profile
write all run, so reaching exit `0` means the profile is deliverable on this host — and the written
profile is there to read. It refuses an under-version host just as a live run would (case 32l).

Every run logs the active restrictions **and the scope they arrived through**, plus two limits stated
at every launch rather than in a document nobody opens mid-incident:

- Array settings keys such as `allowRead` **merge across every scope**, so another scope on the host
  can widen what the child may read. Closing that needs managed settings
  (`allowManagedReadPathsOnly` / `allowManagedDomainsOnly`), which a dispatcher cannot set for itself.
- The log records the **requested** policy. Only a check from inside a live child establishes the
  **effective** one.

**What the harness proves, and what it does not.** Cases 32–32l prove the dispatcher *requests* the
profile: correct argv, correct JSON, correct delivery scope, a gate that fails closed, and none of it
reaching an attended or courier launch. (Case 32j also asserts what those launches *do* carry — the
`--permission-mode default` pair — and case 32 asserts the contained profile carries no permission
mode of its own, so the two policies cannot silently merge.) They cannot prove the effective policy, because
they contain no real child. That is `runs/probes/unattended-effective-policy.sh`, which builds the
profile *by asking the dispatcher for it* and then observes containment from inside a live child. It
costs a real model call and is deliberately not part of `dispatch.test.sh`.

**Codex hops are not covered by this profile.** Their containment is Codex's own
`--sandbox workspace-write`. The run log says so, so no reader has to infer it.

> ### Measured from inside a live child — 2026-08-07
>
> Containment was measured from inside a child that **the dispatcher launched**, not from a profile
> assembled around it. Every check holds: network refused, write outside the checkout refused, home
> read refused, `git push` denied before execution, credentials scrubbed from subprocesses, and a
> repository-declared `SessionStart` hook that never fired. The **effective** tool roster reads
> `Bash,Skill` and **no MCP server loaded** — taken from the hop's own `system/init` event, with a
> control on the same host reading 27 tools and a loaded server once the flags are removed, so the
> two are measurements rather than the child's account of itself. Git works. Final run
> **21 pass, 0 fail**. Record: `runs/probe-unattended-integration-2026-08-07.md`.
>
> **One named exception exists inside the denied home tree, and it is one file.** `denyRead: ["~/"]`
> also blocks `~/.gitconfig`, which Git reads on every invocation — the child's Git exited 128
> *before touching the repository*. The repository itself was always reachable; the obstacle was
> Git's config discovery alone. Operator decision, 2026-08-07: allow the minimum Git configuration
> paths and broaden home no further. So `allowRead` carries `~/.gitconfig` and **nothing else** —
> `~/.config/git/config` is not included, because the probe recorded that Git needed no further help.
>
> The zero-read alternative was rejected on evidence, not preference: `GIT_CONFIG_GLOBAL=/dev/null`
> grants no new read but works only where the identity is set inside the repository, and in
> `ai-resources` it lives only in the global config — so that child would have no Git identity and
> every hop's commit would fail.
>
> **The exception is guarded at both ends**, because "Git works now" is also true of a profile that
> re-opened all of home. Live: `~/.gitconfig` readable **and** `~/.config` still refused. Simulated:
> no `~/`, `~`, `~/.config`, `~/*`, `~/.*` or `$HOME` entry in `allowRead`, the broad `denyRead` still
> present, and exactly three `allowRead` entries.
>
> **Residual risk, measured not assumed.** `~/.gitconfig` names credential helpers, so the child can
> read that a GitHub credential path is configured. It cannot get a token — `gh` keeps its own
> credentials under the still-denied `~/.config/gh/`, and the probe asserts that rather than reasoning
> it. **If a real secret is ever put in `~/.gitconfig`, this exception stops being safe.**

`--carry-one` is a **terminal condition on loop mode**, not a fourth mode: it launches exactly the
actor the current `turn:` names, applies every validation and post-hop check unchanged, and then
exits `0` once the turn has moved in an allowed direction instead of continuing to the next actor.

It exists because a one-hop carry otherwise ends at `23 HOP_LIMIT` — a failure code for the expected
outcome, which no caller can use as a success signal. `--carry-one` pins `--max-hops` to 1, so the
loop guard and the terminal condition cannot drift apart.

This is the mode a **courier** uses (core § 4, *An approved courier may carry the turn*). It keeps
the framing and assessing model in the conversation: the courier carries one turn, then reads the
state file and assesses, rather than handing the whole task to a chain of headless processes.
`dispatch.test.sh` cases 23–26 assert both halves — that a carry exits `0`, and that the same single
hop *without* `--carry-one` still exits `23`.

`--actor-cmd` is the **test seam**. It replaces the live product launch with an arbitrary command
and marks the run `mode=simulated` in all evidence, so a simulated pass can never be read as live
transport.

In live mode the launches are:

```
codex exec --sandbox workspace-write -C <checkout> --json <prompt>
claude -p "/work-loop-v2 <task-id>" --output-format json --permission-mode default   (cwd = <checkout>)
```

With `--claude-deny` the Claude line gains `--disallowedTools <rule>…` after the permission mode;
nothing else about it changes. Under `--unattended` the Claude line is a different one entirely — see
that section.

### The attended child's permission mode

**Every attended Claude hop is launched with `--permission-mode default`.** It is not an option, and
there is no flag that turns it off.

Before 2026-08-09 the dispatcher passed no permission flag at all, so the child **inherited this
checkout's `defaultMode: bypassPermissions`** — measured, not assumed: the discovery run read
`permissionMode: bypassPermissions` off the runtime's own `system/init` event. That handed a launched
actor bypass authority nobody had asked for, which the v0.2 plan forbids for an actor launch. The
same discovery's fail-capable green control launched with `--permission-mode default` and read
`default` back off the same event, with no settings file in any layer changed.

Two things follow, and they are easy to run together by mistake:

- **This is a permission policy, not containment.** It makes the child *ask* before an action its
  policy gates. It sandboxes nothing, isolates no network, and restricts no filesystem. A run under
  it is still an uncontained run.
- **`--unattended` is the containment**, and it is separate. It carries **no permission mode of its
  own** and this change did not give it one: its authority answer is the OS sandbox plus the deny
  set. `dispatch.test.sh` asserts the separation in both directions — the attended argv must carry
  the pair, the unattended argv must not.

`--dangerously-skip-permissions` is passed on **no** path, ever. The suite asserts its absence.

Because `default` means the child stops and asks, an attended hop can block on a prompt nobody is
there to answer. That is the intended failure: the actor is killed on the clock and the capture shows
it stopped *on* the prompt, rather than the dispatcher quietly widening authority to get past it
(exit-code table, `14`).

**`acceptEdits` is not offered, and that is a deferral rather than a rejection.** A
`--claude-permission-mode` option carrying `acceptEdits` was proposed and is **deliberately excluded**
here. It would widen what a launched child may do without asking, and it reopens the settled
attended-policy decision recorded in `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md`.
Without it a permission dead end now stops *honestly* as exit `37` instead of dead-ending silently,
which is a safe outcome rather than a blocked one. If it is wanted later it is an operator decision,
taken on its own evidence.

### The default nested-actor deny set

**Every ATTENDED Claude launch this dispatcher makes passes `--disallowedTools` carrying
`Bash(claude:*)`, `Bash(claude *)`, `Bash(codex:*)` and `Bash(codex *)`.** There is no flag to switch
it off. `--claude-deny` appends to the set and cannot remove an entry.

This exists because on 2026-08-10 a single Work Loop unit spawned at least eight further `claude -p`
processes, and nothing in the launch path denied it.

**The `--unattended` contained profile does NOT carry these rules, and that is a scope boundary rather
than an oversight.** The profile is a separately settled artifact, and the unit that added the deny set
excluded it by name and required its argv to stay byte-unchanged — case 32z freezes exactly that. So
on the unattended path nesting is still blocked only *incidentally*, by the sandbox's network refusal.
Incidental protection cannot be reasoned about, and naming it there is a live open question — but it is
one to reopen as its own unit with its own evidence, not to settle as a side effect of an attended fix.

**Read this before quoting it as a safety property. It is not containment.**

- **What it does.** The *default direct route* — a child running `claude …` or `codex …` through Bash
  — is refused by the child's own permission layer, and the refusal is visible in the launch argv and
  in the run log.
- **What it does not do.** Remove the capability. A child with shell access can construct paths these
  rules do not name: a wrapper script, an absolute path, an env-var indirection, a shell function. A
  tool-name deny cannot enumerate its way out of that.
- **What the suite proves.** That the requested policy reaches the child (literal argv capture). It
  does **not** prove a child cannot evade it, and therefore does not prove nested work is impossible.

Materially reduced, not contained. The only measured containment in this repository remains the
`--unattended` sandbox's network refusal.

There is deliberately **no** `--allow-nested-actors` override. The whole evidence set contains exactly
one instance of nested AI invocation and it is the failure this denies. A case that genuinely needs it
goes to the operator as a capability question, at which point a verified use case would exist.

### Example

```bash
bash dispatch.sh \
  --checkout "/Users/you/Claude Code/Axcion AI Repo/ai-resources" \
  --task spike-live-transport \
  --dry-run
```

### The walk-away invocation, as a worked example

> # ⛔ DO NOT RUN — 2026-08-07
>
> **This is a worked example of a shape that is not cleared for use.** **Two** Phase 2 blockers stand
> between it and a real walk-away run (full list: `unattended-operation-plan-v0.2.md`, status block):
>
> 1. **A fully detached descendant survives the stop** — narrowed on 2026-08-07, not closed.
> 2. **Branch/isolation unproven** — what step 1 below is *supposed* to guarantee, never demonstrated
>    in a live run.
>
> **On blocker 1, what changed and what did not.** Until 2026-08-07 the stop reached a process group
> and not a tree, so a descendant that called `setsid` survived `kill` after you believed the run was
> stopped. Teardown now clears the union of the process group, a recursive ancestry walk and the
> holders of a **private per-hop marker descriptor**, and **verifies** that before releasing the lock;
> a sweep that cannot see says `UNVERIFIED`, and a stop that cannot account for the tree pins the lock
> rather than admitting a second dispatcher. **But a conventional detached daemon — double fork,
> `setsid`, then close every descriptor — still survives, observed alive after the dispatcher exited**
> (`runs/probe-escaped-descendants-2026-08-07.md`). The only handle that reaches it is the inherited
> working directory, and that also reaches unrelated processes in the same directory, so it cannot be
> used as a kill list. This is a measured limit, and closing it needs a supervisor that tracks
> descendants at creation time — a new subsystem, and an operator decision.
>
> **The contained profile is no longer among them either.** It was the first blocker here until 2026-08-07;
> `--unattended` is built, and its effective policy was measured from inside a child this dispatcher
> launched (`runs/probe-unattended-integration-2026-08-07.md`). It is in the command below because a
> walk-away run without it is the shape nobody approved. What it does **not** cover: it contains what
> Claude *runs*, not the Claude process itself, and another settings scope on the host can widen it.
>
> **The launch shape below has been corrected and is no longer a blocker.** Phase 0 proved the
> supervised terminal under `caffeinate -i`; it disproved the detached `… &` form, which a Codex
> command reaps before the dispatcher starts. The example now shows the proven shape.
>
> **`--status` (step 4) is no longer a blocker either — cleared 2026-08-07.** It was the fourth item
> here. The false `STALE LOCK` is fixed and **independently accepted against the corrected build** by
> the Codex sandbox that found it: hidden live PID → `UNKNOWN`, the same PID unsandboxed →
> `IN FLIGHT`, terminated PID → `STALE LOCK`, invalid-PID checks passed, suite 198/0. Step 4 can be
> trusted to tell you which of the three it is.
>
> Keep this example for its structure — the four surrounding steps are right. Do not execute it
> until the blockers are cleared and this notice is removed.

Four things around the command matter as much as the command. Copying the middle line alone is not
the invocation.

**Run this in a supervised terminal that stays open** — a real terminal window you leave running,
not a background process launched from a Codex command. Phase 0 measured the detached `… &` form
being reaped before the dispatcher even starts (empty console, no lock, no run log). The supervised
session is the shape with evidence behind it, and it is what § 0b named as the fallback.

```bash
# 1. Clean tree, own branch. Unattended hops commit; this keeps them off main and
#    makes the whole run droppable with one command.
git -C "$REPO" status --porcelain          # must be empty
git -C "$REPO" checkout -b "work-loop/$TASK"

# 2. Prevent sleep, and stay in the foreground. Without caffeinate the Mac sleeps
#    and the run dies mid-hop; caffeinate -i lifts as soon as the command exits.
#    Do NOT append '&' — the detached form does not survive a Codex-command launch,
#    and in a supervised terminal the foreground run is what you want anyway:
#    the console output is right there, and Ctrl-C signals the whole group.
caffeinate -i bash dispatch.sh \
  --checkout "$REPO" \
  --task "$TASK" \
  --unattended \
  --max-hops 12 \
  --timeout 900 \
  --deadline 2400 \
  --allow-path '^logs/work-loop/' \
  --allow-path '<what THIS unit may legitimately touch>' \
  2>&1 | tee "$REPO/plans/work-loop-v2-v0.2/handoff-automation-spike/runs/walkaway-$TASK.console"

# 3. How you stop it: Ctrl-C in this terminal, or from another one:
#    dispatch.sh --status prints the pid and the exact kill command.
#    Either way the dispatcher exits 28 and retries nothing.

# 4. On return — or at any point, from a SECOND terminal:
bash dispatch.sh --checkout "$REPO" --task "$TASK" --status
```

Two cautions on step 4, both measured rather than assumed. First: from inside a Codex command sandbox
`--status` cannot inspect the PID. It no longer calls that `STALE LOCK` — it answers
`UNKNOWN — CANNOT INSPECT` and tells you the lock may still be live, confirmed live cross-sandbox on
2026-08-07 — but `UNKNOWN` is still not an answer to *"is it still going?"*, so run step 4 from an
ordinary terminal when you need a real one. Second: a `28` stop clears every descendant it can reach
and says exactly which handles it checked — read the `teardown verified:` line, and note that its
wording is scoped on purpose. If it instead prints a `WARNING:` naming survivors, or
`teardown UNVERIFIED` with a reason, those processes may still be running and are yours to terminate
by hand; the lock stays **pinned** until you do, and the next dispatcher is refused with exit `17`.

- **`--unattended` is not optional in this shape.** It is what gives the child less authority than an
  attended one: OS sandbox, empty network allowlist, `Bash` and `Skill` only, no MCP, no hooks, no
  push, credentials stripped from subprocesses. It fails closed (exit `31`) rather than running
  uncontained. Run `--dry-run --unattended` first — it is a real preflight and writes the profile the
  live run would use. Note that unattended hops capture `--output-format stream-json`, so each hop's
  `.out` opens with the product's own `system/init` event: that is where the **effective** tool
  roster and MCP list are, as opposed to the requested ones in the run log.
- **`--deadline 2400`** is the forty minutes. `--max-hops 12` is the secondary bound.
- **`--allow-path` is a per-task input, not boilerplate.** `1c` checks what the actor *committed*
  against it, so it has to describe what this unit may legitimately change. Too narrow gives false
  stops; too wide and the check means nothing. Whoever writes the unit brief derives it.
- **To stop the run:** `kill -TERM $(cat /tmp/walkaway.pid)`. The dispatcher tears down the actor's
  descendants across three handles, verifies the result, and exits `28`. If it cannot confirm the
  tree is gone it pins the lock and says so. `--status` prints this same command back at you.
- **Nobody opens the checkout while the run is live.** A branch shares the working directory and index
  with any other session in that checkout — see *Isolation* under Safety boundaries.

---

## Exit codes

The source declares this set. Read the middle column as *which modes can return it*, because that is
where the code's meaning actually differs.

| Code | Name | Modes | Meaning |
|---|---|---|---|
| `0` | — | all three | See the note below — it does **not** mean one thing. |
| `10` | `BAD_USAGE` | all after `--help` | Unknown argument, missing `--checkout`/`--task`, non-integer or `< 1` `--max-hops`, non-integer `--timeout`, or the log directory could not be created. |
| `11` | `BAD_CHECKOUT` | dry-run, loop | `--checkout` is not a directory, cannot be canonicalized, or is not a Git checkout. |
| `12` | `BAD_TASK_ID` | dry-run, loop | Task id contains a path separator, traversal or illegal characters; or the resolved state file does not sit directly inside `logs/work-loop/`. |
| `13` | `STATE_MISSING` | dry-run, loop | The state file is absent or unreadable. |
| `14` | `IDENTITY_MISMATCH` | dry-run, loop | No readable `task:` frontmatter, or the filename stem differs from `task:`. |
| `15` | `BAD_TURN` | dry-run, loop | `turn:` is absent or is not one of `codex`, `claude`, `operator`. (The same code guards an unlaunchable actor inside the loop — a defensive branch `validate_state` should already have excluded.) |
| `16` | `FOREIGN_STAGED` | loop only | Something was already staged before a hop. The spike stops rather than sweeping it into a commit. |
| `17` | `LOCK_HELD` | dry-run, loop | Another dispatcher already holds this **task**, or is already running in this **checkout**. Two locks are checked, both under the repository's Git common directory; either one being held refuses the run, and the message names the conflicting task or checkout. |
| `18` | `FOREIGN_UNSTAGED` | loop only | Out-of-allowlist working-tree changes were **already present** before a hop. The before/after delta cannot see these — both snapshots contain them — so they used to pass straight through. `--dry-run` reports them instead of failing. |
| `19` | `GIT_HAZARD` | loop only | The checkout holds a Git `index.lock`, or a merge, rebase, cherry-pick or revert is in progress. A second writer would compound it. `--dry-run` reports instead of failing. |
| `20` | `ACTOR_FAILED` | loop only | The actor exited non-zero, or the Codex/Claude binary was not executable or not resolvable. A failure that left the repository **provably unchanged** (state `sha256`, `HEAD`, foreign working tree and the state file's committed-ness all identical) is retried **once** first; a failure after any change is never retried. |
| `21` | `ACTOR_TIMEOUT` | loop only | The actor exceeded `--timeout` and was killed (`TERM`, then `KILL`). |
| `22` | `NO_TRANSITION` | loop only | The actor exited cleanly but left the state file byte-identical, left `turn:` unchanged, or moved it in a direction that is not allowed. |
| `23` | `HOP_LIMIT` | loop only | `--max-hops` was reached with `turn:` still on an actor. |
| `24` | `UNEXPECTED_EFFECT` | loop only | An actor changed paths outside the allowlist, or the Codex actor moved `HEAD`. |
| `25` | `UNCOMMITTED_HANDBACK` | dry-run, loop | The state file is uncommitted where Claude should have committed it — either found that way at startup with `turn: codex`/`operator`, or left that way after a Claude hop **that actually changed its bytes**. The byte-identical case is now `36`, not this. |
| `26` | `MALFORMED_TERMINAL` | loop only | `turn: operator`, but the file is neither a core § 7 question (it has no `## Blocker` and no `## Next action`) nor a core § 4 closing record (its four headings, and nothing else, are not what survived). No actor is launched; the stop names a recoverable next action. |
| `28` | `INTERRUPTED` | loop only | `SIGINT`/`SIGTERM`. Every descendant reachable by the three handles is terminated and **verified gone** before the lock is released and the run stops — the success line names those handles rather than claiming the tree is empty (see Safety boundaries for the shape that still escapes, which is a live Phase 2 blocker). A descendant that could not be confirmed dead is named in a `WARNING:` line; a sweep that could not run at all prints `teardown UNVERIFIED` with the reason. In both cases the lock is **pinned**, not released. Read that before treating the halt as clean. **Never retried** — the signal may have landed after an effect nobody observed, so the state file and `git status` are where the operator has to look. |
| `29` | `BUDGET_EXHAUSTED` | loop only | `--deadline` expired: either the loop refused to launch the next hop, or a running actor was terminated at the clock. **Not completion.** Resumable — the state file and Git are untouched by the stop — but never retried automatically. Worst-case overrun is `1s poll + 5s TERM→KILL grace + 2s KILL settle + verification census + reaping`, roughly 9s — not exact-to-the-second. It was ~6s before 2026-08-07; whole-tree teardown added the settle window and the census that confirms the tree is actually gone. |
| `30` | `UNEXPECTED_COMMIT` | loop only | An actor **committed** paths outside the allowlist. Detection, not prevention: the commit already exists, and the value is stopping rather than compounding it over the rest of an unattended run. Distinct from `24`, which is the working-tree case, because the recovery differs — `24` is reverted from the working tree, `30` from history. |
| `31` | `UNATTENDED_UNAVAILABLE` | loop only | `--unattended` was requested and the contained profile cannot be delivered. Nothing launches. |
| `32` | `IDENTITY_INIT_FAILED` | loop only | The headless session-identity init started in a checkout that carries the allocator and could not complete. Nothing launches. |
| `33` | `OWNERSHIP_REFUSED` | dry-run, loop | `logs/scripts/work-loop-owner.sh` refused this task in this checkout: the checkout is claimed by a different open task, or this task is claimed by a different checkout. Distinct from `17` because the remedy differs — `17` means *wait*, `33` means *you are in the wrong checkout*. Nothing launches, so nothing is committed. A checkout without the helper is `35`, not this. |
| `34` | `OWNERSHIP_AMBIGUOUS` | dry-run, loop | Ownership cannot be established — typically the task's state file is replicated across checkouts with no declaration, or a declaration is unreadable or holds more than one id. Deliberately **not** resolved by guessing: the checkout contacted first must never claim a replicated open task. The operator names the owner. Nothing launches. |
| `35` | `OWNERSHIP_UNAVAILABLE` | dry-run, loop | The ownership check could not be run at all: `logs/scripts/work-loop-owner.sh` is missing, unreadable, or exited with something other than `0`/`3`/`4`. **Fails closed** — nothing launches. Distinct from `33`/`34`, which mean a check *did* run: the remedy here is to install or repair the helper, not to move checkout. |
| `36` | `STATE_UNCHANGED_HANDBACK` | loop only | The state file was **already** uncommitted before the hop launched **and** is byte-identical after — so Claude never touched it. Split out of `25`, which used to fire on bare dirtiness and therefore told the operator "Claude edited it" about a file Claude had not written to. |
| `37` | `PERMISSION_DENIED` | loop only | The Claude hop's own result JSON reported one or more `permission_denials`. The stop carries the denied tool, its **exact, untruncated** target, and the decision required. Parsed by `jq`, or by `python3` where jq is unusable; on a host with neither, the stop still fires but says plainly that it cannot name the tool and target, and the preflight `denial_parser=` line warns of this before the run starts. **Not a transport failure** — re-running, rewording or raising the timeout will not change it. Before this code existed the denial was invisible: the child exits `0`, so it surfaced as `25` or `22` with no cause named. |

> **Why `28`–`30` exist.** `27` is deliberately unused: it was reserved in plan v0.1 for
> `--expect-turn`, which v0.2 dropped (unattended loop mode makes the repeating-courier shape it
> guarded unnecessary, and the lock already refuses a second dispatcher). Leaving the gap is cheaper
> than renumbering if it is ever built.

> **Why `36`–`37` skip `33`–`35`.** Those three numbers are claimed by the concurrent branch
> `session/2026-08-11-work-loop-ceremony` (`OWNERSHIP_REFUSED`, `OWNERSHIP_AMBIGUOUS`,
> `OWNERSHIP_UNAVAILABLE`). This work was implemented alongside that branch and stepped over the
> block rather than colliding with it — a silent collision, where each branch's suite passes alone
> and the merged dispatcher gives one number two meanings, is the more expensive failure.
>
> **It happened anyway, and was caught at the merge (2026-08-11).** This branch originally skipped
> only `33`–`34` and took `35` for `PERMISSION_DENIED`; the ceremony branch then also took `35`, for
> `OWNERSHIP_UNAVAILABLE`. Both suites passed alone. `PERMISSION_DENIED` moved `35` → `37` here,
> because the ownership codes landed on `main` first and more already references them. **Run evidence
> recorded before 2026-08-11 names `35` for a permission stop — read those as `37`.** The lesson is
> that reserving numbers against a branch you cannot see the end of only narrows the window; the
> merge is what proves the set, so re-check the whole block there.

### Every post-launch stop reports partial file effects

Any stop **after an actor has launched** now appends a `PARTIAL FILE EFFECTS` section listing the
in-allowlist paths the hop left modified and uncommitted. That covers `20`, `21`, `22`, `24`, `25`,
`29`, `30`, `36`, `37` and the `28` interruption path.

The gap this closes: every existing check was scoped to *violations*, so a hop that edited three
permitted files and was then killed reported nothing at all. On 2026-08-11 a timeout reported three
individually-true facts — the state file did not change, the branch did not move, no foreign path was
touched — while real work sat uncommitted on disk, unmentioned.

**The listed paths are not a violation.** They are inside `--allow-path`; they are what the actor was
sent to do. The section is reporting only, and nothing exits nonzero *because* it is non-empty. A
clean tree prints no section at all.

**Exit `0` means five different things depending on how you invoked the dispatcher:**

- `--help` returns `0` after printing the header. Nothing was validated.
- `--status` returns `0` after reporting what it could read. Nothing was validated beyond
  readability, nothing was launched, nothing was written — including when a run is in flight.
  `0` does **not** mean the report was conclusive: an `UNKNOWN — CANNOT INSPECT` lock verdict exits
  `0` too. Read the `run:` line, never the exit code.
- A completed `--dry-run` returns `0` after validation. **No turn was taken.**
- A `--carry-one` run returns `0` when the turn moved exactly once in an allowed direction — **or**
  when `turn:` was already `operator` and nothing was carried. Read `turn:` from the state file to
  tell those apart; the file is authoritative over the exit code either way (core § 4).
- A loop-mode run returns `0` **only** after the state file reached `turn: operator` — automation is
  terminal there (core § 7). This is the only invocation for which `0` carries the whole-loop meaning.

> **The line-31 contradiction recorded here is now fixed** (2026-08-06). The header's opening line
> read *"0 is the ONLY success, and it means the loop reached turn: operator"* — true of loop mode
> alone, and left standing as a deferral when `--help` and `--dry-run` were documented beneath it.
> Adding `--carry-one` gave `0` a fourth meaning and made that wording actively wrong rather than
> merely incomplete, so it was corrected rather than deferred again. The header now states all four
> meanings in one block.
> The `--help` truncation recorded here was fixed earlier (2026-08-05): it printed a fixed line
> window (`sed -n '2,45p'`) and so under-reported the exit-code set. It now prints the whole leading
> comment block whatever length it grows to, which is what let codes `18` and `19` — and this
> block — be added without silently re-truncating.
> This table is generated from the source header, not from `--help`.

### Allowed turn transitions

`codex → claude`, `codex → operator`, `claude → codex`, `claude → operator`. Anything else is `22`.

---

## Running the tests

```bash
bash dispatch.test.sh
DISPATCH_BIN=/path/to/dispatch.sh bash dispatch.test.sh
```

The concurrency and ownership behaviour has a second, separate harness — the R2 acceptance matrix
`T1..T13`, plus `F1..F3` for the 2026-08-11 correction round (an ownership check that cannot run must
refuse rather than pass; a malformed declaration is ambiguous and survives; a contested claim on one
free checkout is indivisible). It exercises the real helper, real linked worktrees, real lock
directories and this dispatcher:

```bash
bash logs/scripts/work-loop-owner.test.sh
```

The suite builds throwaway sandbox checkouts under `TMPDIR` and removes them on exit. It touches no
real repository. It ends with a summary line and exits `1` if any case failed:

```
pass=454 fail=0  (all cases SIMULATED — no live product transport)
```

> **This count drifts, twice over now.** It read `pass=69` until 2026-08-06, when the suite actually
> stood at 82 — cases had been added without updating the line. Re-measured that day: the
> pre-`--carry-one` suite from `HEAD` returns **82**, and cases 23–26 brought it to **99**. The line
> then sat at `99` while Phase 1 took the suite to **149** (commit `c8b2172`), the `--status`
> three-state fix on 2026-08-07 added 22 to reach **171**, the pid-validation correction that
> followed it added 27 more to reach **198**, the 1d contained-profile integration the same day added
> 75 to reach **273**, the 1d correction later that day added 11 to reach **284**, the 1a teardown
> work took it to **368**, P0-F's attended permission-mode assertions added 7 to reach **375**, the
> R2 lock relocation added 6 to reach **381**, and case 12d's fail-closed ownership admission added 8
> to reach **389** on the ceremony branch. Alongside it the bounded-execution cases 40–47 took the
> same **375** baseline to **415**; merging the two on 2026-08-11 gives **454**. A
> hand-maintained count drifts silently every time; treat the number as documentation and the run as
> the evidence. **The correction was itself an instance of the drift:** the red-pair figure recorded
> alongside this one read `212/22` when the current test file actually returns `216/24` against the
> pre-1d dispatcher — a stale count carried forward from an earlier version of the file.

**Case 0 is the harness's own falsifiability proof:** it points the suite at an *absent* dispatcher
and asserts that the suite fails. A harness that stays green with the thing under test removed is not
evidence. Cases 1–13b cover exact-task routing against decoy state files, identity-mismatch
rejection, path traversal, missing and malformed state, `turn: operator` as terminal, no-op actors,
actor failure and timeout, the hop limit, foreign staged state, out-of-allowlist writes and Codex
moving `HEAD`, an unattended simulated round trip, the lock, and the uncommitted-handback seam.

Cases 14–20 are the safety gates added on 2026-08-05:

| Case | What it pins |
|---|---|
| `14` | An actor blocked on an approval nobody will give is killed on the clock, the capture shows it stopped *on* the prompt, and no permission surface was touched to get past it. |
| `15` | A crash **before** any repository change is retried exactly once, and the first attempt's output is kept as separate evidence (`.hop1r.` capture). |
| `15b` | A crash **after** a repository change is never retried — a retry would run over a partial effect. |
| `16` | Foreign **unstaged** work (tracked-modified and untracked) stops the run before any launch; the expected uncommitted Codex handoff still launches. |
| `17` | A held Git `index.lock` stops the run before any launch. |
| `18` | `MERGE_HEAD`, `CHERRY_PICK_HEAD`, `REVERT_HEAD`, `rebase-merge/` and `rebase-apply/` each stop the run before any launch. |
| `19` | A duplicate completion event relaunches nothing. |
| `20` | A core § 7 operator question reaches `turn: operator`, is preserved in the file, is surfaced in the output, and is marked unanswered. |
| `21` | `turn: operator` reached by a core § 4 **close** is announced as a close — not as an unanswered question above an empty block. |
| `22` | A `turn: operator` file that is **neither** shape stops `26` for inspection instead of being labelled closed — a partial record, an active field surviving the reduction, the four headings **out of core § 4 order**, or one of them written **twice**. |

Red-to-green for those seven, against the pre-change controller from `HEAD`:

```
DISPATCH_BIN=<pre-change dispatch.sh> bash dispatch.test.sh   →  pass=49 fail=20  (exit 1)
bash dispatch.test.sh                                         →  pass=69 fail=0   (exit 0)
```

Cases `21` and `22` were added later, by the parallel proof below, and `22` took three passes — each
with its own red-to-green against the controller that immediately preceded it:

```
21           pass=71 fail=2  →  pass=73 fail=0
22           pass=74 fail=4  →  pass=78 fail=0
22 (order)   pass=80 fail=2  →  pass=82 fail=0
```

The chain is the point. `21` said "no `## Blocker` and no `## Next action` means closed" — necessary,
not sufficient, so a hop that died mid-reduction was announced as a clean close. `22` required the
four headings and nothing else — but compared them through `sort -u`, so the same four shuffled, or
one of them written twice, still passed. The classifier now compares the literal heading sequence.

Cases `30d`/`30e`/`30f` were added on 2026-08-07 for the `--status` three-state fix, with the same
red-to-green against the controller that preceded them (`c8b2172`):

```
30d/30e/30f          pass=162 fail=9   →  pass=171 fail=0
30f (pid validation) pass=186 fail=12  →  pass=198 fail=0
```

The second line is the follow-up correction: the first cut of the three-state fix validated the lock
pid as *numeric*, which admits `0`, `00` and `007`. Review caught it, and the red-to-green ran
against the three-state commit (`e1ebb2f`) rather than against the pre-fix controller — each fix is
measured against the thing it actually changed.

They are a **matched pair plus a control**, and only mean something together. `30d` forces a real
permission denial — the lock's pid is `1` (launchd: always alive, always `EPERM` for a non-root
caller), which is a genuine uninspectable live process rather than a simulated one — and asserts
`UNKNOWN`, no `STALE LOCK`, and no `rm -rf`. `30f` does the same for an unreadable pid, a non-numeric
pid, and the invalid-but-*numeric* pids `0`, `00`, `007` and `0000000` — and it also pins `1` and `10`
as **valid**, so the zero rule cannot quietly widen into rejecting legitimate pids.
`30e` is the **positive control**: a reaped pid must still report `STALE LOCK`. Without `30e`, a
"fix" that answered `UNKNOWN` to every failed check would pass `30d` and `30f` while quietly
destroying the stale-lock report — and indeed `30e` passes against the *pre-fix* dispatcher too,
which is exactly what makes it a control rather than another regression test. `30d` skips itself
loudly (as a failure, not a silent pass) if the suite is ever run as root, since `kill -0 1` would
then succeed and the permission-denied state could not be forced at all.

**P0-F — the attended permission mode**, 2026-08-09. Seven assertions across cases `31`, `31b` and
`32j`, with the same red-to-green against the dispatcher that immediately preceded them (`b13b3f9`):

```
P0-F attended mode   pass=370 fail=5   →  pass=375 fail=0
```

The five reds are the two attended argv shapes (plain and `--claude-deny`), their two logged command
lines, and the courier hop in `32j`. The other two assertions are **controls and stay green in the
red half**: no `--dangerously-skip-permissions` on any path, and no `--permission-mode` under
`--unattended`. They are there to catch a fix that overshoots — a bypass flag, or the attended policy
leaking into the contained profile — which a red-to-green pair on its own cannot detect. The argv
check requires **exactly one** `--permission-mode` token with `default` on the next line, so a flag
passed twice with different values fails rather than matching by coincidence.

### Cases 40–46 — the bounded-execution outcomes (2026-08-11)

Added for the O1–O5 outcomes of `../bounded-execution-fix-plan-v0.2.md`, after two bounded-execution
failures one day apart. Both incidents cost real model time — 25 minutes and 900 seconds — and both
shapes are reproduced here in seconds by a scripted actor. **No live model, no nested AI, no pilot.**

| Case | What it pins |
|---|---|
| `40` | The four nested-actor deny rules reach the child verbatim on the plain attended path, `--permission-mode default` survives alongside them, and the run log states plainly that this is **not containment** |
| `40b` | `--claude-deny` **appends** to the nested set rather than replacing it |
| `41` | A **timeout with partial edits** — the incident-2 shape. The actor edits an allowed file, never touches the state file, never commits, and is killed on the clock. Exit `21`, and the modified path is named. Controls that the state file really is untouched |
| `42` | The **false exit 25** — a state file already dirty before launch and byte-identical after now exits `36`, and the stop no longer claims Claude edited it. Controls the sha256 across the hop |
| `42b` | The pairing control: a **real** uncommitted Claude edit still exits `25`, so `36` did not swallow the shape it was split from |
| `43` | A **permission denial** parsed out of the hop capture into exit `37`, carrying the exact denied command and a second denial of a different tool |
| `43c` | The exact-target control: a denied target **longer than 200 characters** is carried whole, not cut |
| `43d` | The same target survives when **jq is unusable**, via the python3 tier, with the run log confirming the fallthrough actually happened |
| `43b` | The control: an **empty** `permission_denials` array produces no permission stop |
| `44` | An **out-of-scope edit** still exits `24`, and now also names the in-scope work the hop did |
| `45` | An **out-of-scope commit** still exits `30`, and now also names the uncommitted in-scope work |
| `46` | The other O2 control: a clean hop prints **no** partial-effects section |

Case `31b` was **inverted, not relaxed**. It asserted "no `--disallowedTools` is passed when none was
asked for", which was correct until the nested-actor set became a default. It now asserts the
opposite, which is the claim the dispatcher actually makes.

Measured on 2026-08-11, three passes against frozen copies of both files:

```
baseline  pristine dispatch + pristine tests   pass=375 fail=0
red       pristine dispatch + NEW tests        pass=392 fail=23
green     NEW dispatch      + NEW tests        pass=415 fail=0
```

The baseline was **re-derived by execution**, not inherited from the record — it happens to confirm
the recorded `375/0`, but the plan required running it rather than quoting it.

All 23 reds are distributed across the five outcomes; none of them is a control. The controls —
case `42b` (a real uncommitted Claude edit still exits `25`), `43b` (an empty `permission_denials`
array raises no stop), `46` (a clean hop prints no partial-effects section), and case `41`'s
state-file check — stay **green in both halves** on purpose. They are there to catch a fix that
overshoots, which a red-to-green pair alone cannot detect.

> **One of these assertions was wrong first, and the red half is what caught it.** Cases 41, 44 and
> 45 originally grepped the *whole* run output for the modified path, and passed against the
> pre-change dispatcher — the run log echoes `--actor-cmd` verbatim, and that command string contains
> the path. Three assertions were therefore matching text the dispatcher had always printed. They now
> search only inside the `PARTIAL FILE EFFECTS` block, via the `partial_section` helper, and fail in
> the red half as they should. Red count went 20 → 23 on that correction.

**Live product evidence lives in `runs/`, never in this suite.** `runs/live-permission-denial-2026-08-05.md`
records what the real binary does when it is refused permission — the half of safety cluster 1 no
controller test can establish — including one denial carried **through `dispatch.sh` itself**, with
the dispatcher's own exit, launch count and before/after state hashes.
`runs/parallel-worktree-proof-2026-08-05.md` records the two-worktree parallel run (§ below).

## The parallel instruments

Three scripts exist for the two-worktree proof and are not used by the single-checkout suite:

| Script | What it does |
|---|---|
| `parallel-sampler.sh` | Samples the process table every 2 s, recording each dispatcher/actor's pid, ppid, routing argument and **kernel `cwd`** (via `lsof -a -d cwd`). Answers "did the runs genuinely overlap?" and "did each child live in the worktree it was routed to?" |
| `parallel-isolation-check.sh` | Reads a finished run back and asserts nine isolation properties (A1–A9). Expectations are overridable so the checker can be made to fail on purpose — a checker nobody has seen fail is an untested instrument. |
| `parallel-landing-qc.sh` | Both-sides-present integration QC after a serial landing (B1–B9): presence of each result and closing record first, conflict/`[IN FLIGHT]` sweeps second. |

---

## Safety boundaries

- **One task, one checkout, serial — per dispatcher instance.** A single instance is never
  multi-loop. Two *instances* in two linked worktrees were proven to overlap safely on 2026-08-05;
  same-checkout concurrency is still unsafe — see `docs/parallel-sessions-playbook.md` § 4.
- **The dispatcher never writes the state file.** Only the actors do. It reads, hashes and compares.
- **A lock** keyed on `checkout|task` (a directory under `TMPDIR`) refuses a second dispatcher on the
  same pair.
- **An allowlist** bounds which repo-relative paths an actor may change; anything else stops the run.
  It is checked in three directions: as a *delta* across each hop's working tree (`24`), as a
  **pre-hop gate** on work that was already there (`18`), and against what the actor **committed**
  between the hop's before- and after-`HEAD` (`30`). The dispatcher's own log directory is added to
  the allowlist when it sits inside the checkout, so a run does not flag its own evidence as foreign
  work. Since the default log directory now sits inside the driven checkout, that allowlisting is on
  the ordinary path rather than only on an explicit `--log-dir`.
  > **One measured limit.** The allowlist entry is the run directory's exact repo-relative path, and
  > `git status --porcelain` collapses an untracked *directory* to its shortest path. In a checkout
  > where an ancestor such as `plans/` is itself untracked, the dispatcher's own new evidence is
  > reported as `?? plans/`, which that entry does not match, and the pre-hop gate stops the run at
  > `18` before any actor is launched. Every real checkout of this repository tracks `plans/`, so this
  > is reached only by a checkout that does not carry the spike tree. It fails closed and prints a
  > recoverable next action; it is recorded rather than fixed, because widening the allowlist to an
  > ancestor would let genuinely foreign changes under that ancestor pass unseen.
  > **The committed-path check (`30`) closed a real gap, and it is not free.** `18`/`24` read
  > `git status --porcelain`. Claude commits its work each hop, so a clean tree passed them no matter
  > what went into the commit — only stray *uncommitted* files ever tripped the guard. `30` compares
  > `before_head..after_head`, which means the allowlist now has to describe what **this unit** may
  > legitimately touch rather than what the spike touches in general. That makes it a per-task input
  > derived when the unit brief is written. Too narrow gives false stops; too wide and the check is
  > decoration.
  > **Consequence for live runs in *this* repository — read before launching one.** A PostToolUse
  > hook appends to `logs/friction-log.md` continuously, so that file is almost always modified. Gate
  > `18` therefore stops a live run here unless the allowlist covers it. A `--dry-run` on 2026-08-05
  > reported exactly that. And because **supplying any `--allow-path` replaces both defaults**, a
  > live run needs all three:
  >
  > ```
  > --allow-path '^logs/work-loop/' \
  > --allow-path '^plans/work-loop-v2-v0\.2/handoff-automation-spike/' \
  > --allow-path '^logs/friction-log\.md$'
  > ```
  >
  > Run `--dry-run` first. It reports what gate `18` would stop on instead of failing.

- **Hazardous Git states stop the run before any launch** (`19`) — a held `index.lock`, or a merge,
  rebase, cherry-pick or revert in progress. Checked before *every* hop, not once at startup, so a
  restart re-enters the same gate.
- **One retry, and only from proven repository truth.** A failed actor is relaunched once when the
  state file, `HEAD`, the foreign working tree and the state file's committed-ness are all exactly
  where they were. Any doubt is treated as a partial side effect and stops.
- **Asymmetric restart safety.** An uncommitted state file with `turn: claude` is the *expected*
  Codex handoff, because Codex writes the file and never runs Git. An uncommitted file with
  `turn: codex` or `turn: operator` means a Claude hop died between editing and committing, and the
  run stops for inspection instead of relaunching over a partial edit.
- **The run can be stopped, and the stop clears most of the actor's descendants — not all of them.**
  `SIGINT`/`SIGTERM` terminates what the dispatcher can reach, **verifies** the result, releases the
  lock once, and exits `28`. The lock part was not true before 2026-08-07: the old handler released
  the lock without exiting, so a stop attempt left the run going *and* admitted a second dispatcher
  onto the same state file. Both that defect and its fix are OBSERVED —
  `runs/probe-interruption-2026-08-07.md`, with the probe script and a before/after raw capture under
  `runs/probes/`.
  > **Three handles, because no single one reaches every escape** — measured, not assumed
  > (`runs/probe-escaped-descendants-2026-08-07.md`): the actor's **process group**, a **recursive
  > ancestry walk**, and the holders of a **private per-hop marker descriptor**. The group alone
  > misses anything that calls `setsid(2)`; ancestry alone misses a double-forked orphan, whose parent
  > link the kernel destroys before any stop happens. The marker reaches both. Teardown TERMs, then
  > KILLs, then **re-censuses to confirm** — it does not assume the signal worked.
  >
  > **Why a private marker rather than the hop log.** Both have the same reach, but the hop log is
  > public: an operator may `tail -f` it while a run is in flight, and an earlier version of this
  > teardown killed exactly that process. The marker `${hop}.tree` is opened just before the actor is
  > backgrounded and closed in the dispatcher immediately after, so only the actor's tree holds it.
  >
  > **A sweep that cannot see says so.** Six distinct ways discovery can break — `lsof` absent,
  > `lsof` failing at runtime, `pgrep` absent, `pgrep` failing at runtime, `ps -ax` failing, the
  > marker missing, and the actor sharing the dispatcher's own process group — all yield
  > `teardown UNVERIFIED` with the reason, never a silent `teardown verified` on an empty census.
  > Each has its own case (27j, 27m–27q), because the two that were only reasoned about turned out to
  > be wrong: a *failing* `pgrep` read as "no children", and a *failing* `lsof` read as "nobody holds
  > the marker". `lsof -t` exits 1 both when it found nothing and when it broke, so only its stderr
  > separates them.
  >
  > **Survivors, or an unverifiable sweep, PIN THE LOCK.** The lock is deliberately not released, a
  > `survivors` file inside it records what was left, the next dispatcher is refused with exit `17`,
  > and `--status` reports `PINNED LOCK` rather than calling it stale. Clear it by hand once the pids
  > are confirmed gone. `--status` re-checks each recorded pid through the same three-valued test the
  > lock uses: **alive**, **gone**, or **could not inspect — treat as running**. A bare `kill -0`
  > would collapse the last two, and a survivor left by a stopped actor is quite likely to be a
  > process this account may not signal; case 27L is the one that caught `--status` calling such a
  > lock safe to remove.
  >
  > **The residual, and it is still a Phase 2 blocker.** A descendant that double-forks, leaves the
  > session **and** drops every inherited descriptor — a conventional daemon — escapes all three
  > handles and survives, observed alive after the dispatcher exited. The only handle that reaches it
  > is the inherited working directory, which also lists unrelated processes in the same directory, so
  > it cannot be used to kill. `dispatch.test.sh` case 27h builds that shape, asserts it survives, and
  > fails if the success wording is ever widened. Narrower than what it replaced — one line of
  > `setsid` used to be enough to escape — but **not closed**.
  >
  > **Cost:** worst-case teardown ~6s → ~13s, and the `--deadline` overrun bound ~6s → ~9s.
- **Isolation is a branch, and a branch is not a worktree.** The pilot runs on
  `work-loop/<task-id>` off a clean tree. This keeps unattended commits off `main` and makes the run
  droppable, but a branch **shares the working directory and index** with anything else open in that
  checkout, and switching it switches what the operator sees. The containment is therefore *"nobody
  opens the checkout while the run is live"*, which walking away satisfies by definition.
  > **Temporary limitation, with a named reason — and the reason expired on 2026-08-09.** A dedicated
  > worktree is the right answer. It was blocked because the ambient `friction-log.md` writer appends
  > to a tracked file, which two parallel worktrees then land in conflict. `--unattended` disables the
  > child's hooks, so a **contained** run never triggers that writer and the block does not apply to
  > it; the hook fix this note was waiting for was dropped as unnecessary rather than built. An
  > **attended** worktree session is still exposed, because its hooks are live. See the closing record
  > of `logs/work-loop/work-loop-v2-production-readiness-policy.md`. The pilot stays on a branch
  > regardless — that choice never depended on this block — and no dispatched run has launched live
  > yet, so a first worktree run is separately authorized work.

### The honest risk envelope for an unattended run

What actually contains a walk-away run, stated plainly because the operator reads this before
leaving rather than after:

**Read this table as describing a run launched with `--unattended`.** Without that flag the whole
right-hand column is larger: the child has an open network and ordinary file authority, and the first
three "prevented" rows drop back to detection. The table changed on 2026-08-07, when the contained
profile was built and measured.

An attended run is not contained, but since 2026-08-09 it is no longer running on inherited bypass
authority either — it is launched with `--permission-mode default`. That is a smaller guarantee than
this table's left column and must not be read into it.

| Contains it | Does **not** contain it |
|---|---|
| One task, one checkout, serial (the lock) | Anything outside the checkout — the filesystem at large is **denied by the sandbox**, but the *Claude process itself* runs outside that sandbox |
| Local commits on a branch off a clean tree | `main` is protected. The **child's** network is closed by an empty strict allowlist; the model connection is not, and cannot be |
| A hard `--deadline`, plus `--max-hops` | Nothing bounds what a single hop *does* within its allowlist and its sandbox |
| Stop control that clears what it can reach and **verifies** it (`28`) — group, ancestry and a private per-hop descriptor; an unverifiable sweep says `UNVERIFIED` and **pins the lock** (`17`) rather than admitting a second dispatcher | **A fully detached daemon survives** — double fork, `setsid`, then every descriptor closed. Reachable by none of the three handles, and the one handle that would reach it also reaches unrelated processes. Asserted, not assumed: case 27h, which also fails if the success wording is widened. **Still a Phase 2 blocker.** Also: an effect that landed before the signal — never retried, always inspected |
| Allowlist on working tree (`18`/`24`) **and** commits (`30`) | Both are **detection, not prevention**. The change has happened; the run stops rather than compounding |
| **Prevented, not detected, under `--unattended`:** non-allowlisted network, writes outside the checkout, reads under `~/`, `git push`, MCP, hooks, built-in file tools, credentials reaching subprocesses | **The profile can be widened from another settings scope.** Array keys such as `allowRead` merge across scopes, and `strictAllowlist` is ignored entirely from a *repository* settings file — which is why the dispatcher delivers the profile by CLI `--settings`. Closing this needs managed settings, which no dispatcher can set for itself |
| The version gate: below `2.1.219` there is no strict allowlist, so the run **refuses to start** (exit `31`) rather than running uncontained | **One named exception inside the denied home tree:** `~/.gitconfig`, because Git exits 128 before touching the repository without it. It names credential helpers; the child obtained no token, but **if a real secret is ever put in that file the exception stops being safe** |

`git push` is held at the permission layer under `--unattended`, by an explicit deny rule, and
`--claude-deny` composes on top to narrow further. Without `--unattended` there is **no `git push`
deny rule** — the only deny rules an attended launch carries are the four nested-actor ones, which do
not name push. The attended child is launched under `--permission-mode default`, so a gated action
reaches an approval prompt rather than running on inherited bypass authority — but *which* actions
that mode gates has not been measured here, and a CLAUDE.md rule is still doing part of the work.
Treat the attended posture as "asks", not as "cannot".

**What the left column rests on.** The simulated suite proves the dispatcher *requests* the profile
(**284/0** as the suite stood at 1d's close, **368/0** after the 1a teardown work, **375/0** since
P0-F added the attended permission-mode assertions; matched red pair **216/24** against the pre-1d
dispatcher `22fedf8`, and **370/5** for the P0-F pair against the pre-P0-F dispatcher). The effective policy
was measured **once, on one host**, from inside a child this dispatcher launched
(`runs/probe-unattended-integration-2026-08-07.md`, **21/0**). That is a Phase 1 safety check, not a
reliability claim and not the Phase 2 walk-away pilot — which has still never happened.

---

## What this spike does **not** establish

A run records: run id, mode, task, checkout, state path, hop and timeout settings, the allowlist,
and per hop the before/after `sha256`, `turn:`, `HEAD`, actor exit status, duration and transition
verdict — plus one stdout capture per hop. That is the whole evidence base. Nothing in it speaks to:

- **Live product transport, from the test suite.** Every case in `dispatch.test.sh` runs through
  `--actor-cmd`. The suite proves controller logic only. A green suite is not a live run.
- **Production readiness.** This is a throwaway spike in a `plans/` directory, deliberately not
  installed as a hook, command or service.
- **Concurrency safety beyond two isolated worktrees.** The lock is exercised for one checkout +
  task pair. Two dispatchers in two *linked worktrees* were proven to overlap safely on 2026-08-05
  (`runs/parallel-worktree-proof-2026-08-05.md`) — two tasks, one observation, fixture-sized units,
  and both tasks created only new files. Same-checkout concurrency remains untested and unsafe, and
  nothing here speaks to three or more loops.
- **Repeat reliability.** One successful run is one observation. The run log records that run and
  nothing about the distribution of outcomes across runs.
- **Unattended handling of operator decisions.** Reaching `turn: operator` is where the automation
  *stops*. The dispatcher now prints the question and states that nobody answered it (case 20), but
  what happens to the decision after that is outside the dispatcher entirely.
- **Which exit code a refused actor produces — CORRECTED.** A denied actor still exits `0`, so a real
  permission denial never reaches the dispatcher as `20 ACTOR_FAILED`. It used to arrive as
  `22 NO_TRANSITION` or `25 UNCOMMITTED_HANDBACK`, neither of which *named* denial as the cause. That
  is what exit `37` now fixes: the dispatcher reads the `permission_denials` field it had been writing
  to the hop capture and never opening. **Verified in simulation only** — the parse is driven by a
  fixture modelled on the recorded live shape, not by a fresh live denial. The original live
  measurement stands: `runs/live-permission-denial-2026-08-05.md`.
- **Anything about the quality of the work the models did.** The dispatcher checks that the file
  moved in an allowed direction and that no unexpected repository effect occurred. It does not read
  the content.

Where this README describes behaviour that was reproduced (exit statuses, the test summary), it says
so. Anything beyond the list of recorded fields above is inference, not evidence.
