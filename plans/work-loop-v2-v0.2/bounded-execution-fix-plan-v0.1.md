# Work Loop v2 — bounded-execution fix plan, v0.1

**Written 2026-08-11 by Claude, under Work Loop v2 task `work-loop-v2-bounded-execution-fix-plan`,
Unit 1.** Planning artifact only. Nothing here is authorized or implemented; every unit below is a
proposal for Codex to assess and the operator to approve.

**What this fixes.** On 2026-08-10 a Work Loop v2 task escaped its bounded courier path. The
dispatcher hit a permission dead end, misreported the resulting state, and Codex responded by driving
an interactive Claude session by hand — which removed the timeout, the one-hop bound, the run log,
the allowlist check and the process-tree teardown all at once. Inside that session Claude spawned at
least eight further `claude -p` processes to test Markdown instruction files. The task consumed ≥13
Claude processes; the four *recorded* dispatcher launches alone were 25m13s, 92 turns, 108,908 output
tokens and $11.34.

**What this plan is not.** It is not a larger control system. Every accepted unit below is small,
reversible, and verifiable without a single nested AI invocation. The one candidate that needs a live
model run is the one candidate that is an operator decision rather than a fix.

---

## 1. Inspection — what the repository actually says today

Seven claims were checked by inspection before this plan was written. All paths are relative to the
`ai-resources` checkout at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; the
dispatcher lives at `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and is referred to
below as `dispatch.sh`.

| # | Claim | Verdict | Evidence |
|---|---|---|---|
| 1 | Attended Claude launch hardcoded to `--permission-mode default`, no operator-carried option | **HOLDS** | Parser `dispatch.sh:282-303` has 15 options and no permission-mode flag; unknown args exit 10 (`:302`). Both attended shapes pass the literal pair: `:1689` (with denies) and `:1694` (plain). Tests pin it: `dispatch.test.sh:1945,1974,2324`. README states it is "not an option, and cannot be turned off" (`README.md:316`) |
| 2a | Exit `25` classifies state-file dirtiness without proving Claude changed the file this hop | **HOLDS** | `dispatch.sh:2007` tests `[ "$before_turn" = "claude" ] && state_dirty` only. `state_dirty()` (`:1416-1418`) is a bare `git status --porcelain` on the state file. `before_dirty` **is** computed (`:1917`) but is used only by the crash-retry guard (`:1946`). The hash comparison that would settle it (`:2014`) runs *after* the die |
| 2b | Recovery text tells the reader to commit/discard "in language incompatible with Codex's role" | **DOES NOT HOLD AS STATED** | Both exit-25 messages name the right owner: `:1793` says "the expected Codex handoff (Codex never runs git)" and `:1795` says "Claude commits". The instruction "commit it and re-run" addresses the human reader, who may commit. The narrower real defect is that neither message *names its addressee*, so a Codex reader carrying the turn can read it as an instruction to itself. Retained in narrowed form (Unit 2) |
| 3 | Run evidence records hashes and hop `.out` captures, no byte-for-byte pre-hop state snapshot | **HOLDS** | Every write into the evidence directory: `$RUN_ID.log` (`:1123-1124`), `$RUN_ID.unattended-settings.json` (`:1294`), `$RUN_ID.hop<n>.<actor>.out` (`:1596-1597`), `$RUN_ID.hop<n>.<actor>.tree` (`:1502-1503`). Searched `dispatch.sh` for `LOG_DIR`, `cp`, and all `>`/`>>` redirections: no copy of the state file exists. Identity is carried as sha256 only — `file_hash()` `:419`, used `:1786, :1894, :1978` |
| 4 | Dispatcher does not parse Claude JSON `permission_denials` into a permission-specific stop | **HOLDS** | Searched `dispatch.sh` for `permission_denials`, `jq`, `is_error`, `subtype`: no match. The hop capture is written and never parsed (`:1596-1597`, `:1507`). The exit taxonomy (`:121-166`, codes 0 and 10–32) contains no permission code. `permission_denials` appears once in the spike, as README prose: `README.md:837` |
| 5 | Attended actors can still start nested `claude` or `codex` processes | **HOLDS** | Searched the attended launch path for any deny of `Bash(claude`, `Bash(codex`, or `Task`: no match. `--claude-deny` defaults empty and the run log says so — `claude_deny=none` (`:1152`). The dispatcher states the posture itself: "unattended=off — Claude hops are NOT contained: open network, open filesystem, full tool set" (`:1325`). Supervision (`actor_tree_census`, `:643-670`; teardown `:848-855`) terminates a tree on a stop; it does not prevent one from being created. Under `--unattended` the base deny set (`:236-242`) also carries no `claude`/`codex` rule and `--tools Bash,Skill` still exposes Bash — nesting is blocked there only *incidentally*, by the sandbox's network refusal |
| 6 | `--status` exists and reports some state; a dispatcher `--stop` may not exist | **HOLDS** | `--status` parsed at `:296`, branch at `:1020-1092`: lock state in three answers, `turn`/`task`/sha256/uncommitted, HEAD and branch, last run log with last hop line and last stop line, and `kill -TERM <pid>` as the stop instruction (`:1038`). It does **not** report elapsed runtime, the actor's pid, descendant count, deadline remaining, or output growth. Searched `dispatch.sh`, `dispatch.test.sh` and `README.md` for `--stop`: no match |
| 7 | The supplied `runs/` disposition concern describes **this checkout** today | **FALSE for this checkout; TRUE one worktree over** | This checkout: 48 files on disk, 48 tracked, 0 untracked, 0 ignored; `git check-ignore` returns non-zero on the directory and `.gitignore` carries no matching pattern. The incident checkout `../ai-resources-diagnostics-workflow` has three untracked run files from the 2026-08-10 run (`…20260810T151601-…diagnostics-workflow.{log,hop1.claude.out,hop1.claude.tree}`). The concern is real but is a **per-checkout evidence-lifecycle gap that surfaces in linked worktrees**, not a repo-wide untracked state |

**Two source facts are also stale and are corrected here.** The postmortem's *Current repository
state* says "No correction commit or closing record was created" and "The two command files contain
uncommitted correction edits". In `../ai-resources-diagnostics-workflow` the correction **is**
committed as `9a8399c` ("correction round — findings 1 and 3 resolved, finding 2 partial"), on top of
`ea77d66`, and no `.claude/commands/` path is dirty. What remains uncommitted there is the state file
itself plus `logs/friction-log.md`, `logs/session-notes.md` and the three run files. The task is still
`turn: claude`. Nothing in this plan depends on the stale reading.

---

## 2. Candidate classification

Every candidate supplied by the operator and the postmortem, classified. Categories are the six the
brief names: **verified current defect**, **already implemented / partly implemented**, **policy
decision requiring the operator**, **valid later improvement**, **duplicate**, **rejected (conflicts
with the Work Loop contract)**.

### Operator's own dispatcher recommendations

| Candidate | Classification | Reasoning |
|---|---|---|
| **A. Preserve the state file's full content before each hop, not only its SHA-256** | **Verified current defect** (claim 3) — priority **P1** | The loss path is real and non-recoverable: Codex writes the brief and does not commit, so the brief text exists only in the working tree until Claude's hop commits it. A Claude hop that rewrites the file wholesale erases a verdict Git never saw. The fix is one `cp` per hop. It is P1 rather than P0 because losing forensics does not endanger the next run — it endangers the assessment of it |
| **B. Decide whether `runs/` is tracked or ignored** | **Policy decision requiring the operator**, correctly raised but **mis-scoped** (claim 7) | Not a defect in this checkout, where evidence is fully tracked. The exposure is that the dispatcher's default log directory sits *inside the checkout being driven* (`dispatch.sh:385`) and inside its own `--allow-path` default (`:317`), so run files are written, pass every guard, and then wait for a human to commit them. In a short-lived worktree that human never arrives. **This unit does not make the decision** (brief boundary); Unit 7 frames it |

### Postmortem P0 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Attended permission-mode option (`--claude-permission-mode …`, incl. `acceptEdits`)** | **Policy decision requiring the operator** — capability gap is verified (claim 1), the change is not Claude's to make | This reopens a **closed** operator decision: `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` (`turn: operator`, 2026-08-09) records launch-time `--permission-mode default` as *the settled attended mechanism*, chosen precisely so a child never inherits this checkout's `bypassPermissions`. Framed as a decision in § 5 |
| **2. Parse Claude's `permission_denials` into a permission-specific stop** | **Verified current defect** (claim 4) — **P0** | The incident's dead end was invisible to the dispatcher. It is also the candidate with the strongest indirect effect: a precise stop is what removes the *reason* to reach for an interactive session |
| **3. Correct dirty-state classification** | **Verified current defect** (claim 2a) — **P0** | `UNCOMMITTED_HANDBACK` must require evidence that Claude changed the file this hop |
| **4. Report partial allowed-path effects honestly** | **Verified current defect** — **P0**, and the same code region as candidate 3 | `foreign_worktree()` (`:1364-1375`) reports only paths *outside* the allowlist, so in-allowlist implementation edits are structurally invisible; the `die 22` "no observable transition" text (`:2015`) mentions the state file only. Merged with candidate 3 into one unit rather than two, because they are one misreport with two faces |
| **5. Prohibit nested AI actors by default** | **Verified current defect** (claim 5) — **P0** | Directly blocks the mechanism that turned one unit into ≥13 Claude processes. Must be stated as a **permission-layer default deny, not containment** — the same distinction P0-F already draws for `--permission-mode` |
| **6. Absolute prohibition on interactive fallback after dispatcher failure** | **Partly implemented** — the rule exists, the placement does not — **P0** | `.agents/skills/work-loop-v2/SKILL.md:195` already says: "You never type into a Claude window, never read Claude's interface for progress, and never click through its prompts." The postmortem records that rule being violated. What is missing is the rule *at the point of failure*: the § *Three outcomes* table's **Stopped** row (`SKILL.md:256`) lists the codes and says nothing about what may not follow one. Instruction-only fix |

### Postmortem P1 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Stricter correction profile** | **Verified gap** — **P1** | Core § 3 *Correcting once* freezes **what** may change; nothing anywhere bounds **how much verification** a correction may spend. The incident's closure check became a second test suite inside a frozen scope, which is legal under the current text |
| **2. Explicit verification budget for nested AI work** | **Verified gap** — **P1**, paired with P0 Unit 1 | The flag that authorizes nesting and the brief rule that budgets it are two halves of one control. Neither is useful alone |
| **3. Brief proportionality preflight** | **Duplicate in substance; rejected as a stage** | Core § 3 *The "good enough, proceed" judgment* already owns all four constraints (85–90% target, minimum necessary work, evidence scaled to consequence, no perfection pass), and `SKILL.md:450` already requires fail-capable evidence. Core § 3 step 3 also forbids the remedy's shape outright: "no new field, artifact or stage is created." **Rejected as a preflight stage.** At most, the trigger list (many scenarios plus negative controls; full behavioural matrices for Markdown files; multiple AI-backed fixtures; "all"/exhaustive without a consequence justification) is folded into P1 Unit 6 as examples inside the *existing* brief-writing step |
| **4. Keep the task state compact** | **Already specified** — compliance failure, not a specification gap | Core § 4 already says the state file is "current truth, not a diary", caps it at five fields, and gives a worked *Not this* example of exactly the accumulation the incident produced. A new rule would restate an existing one. **Parked**, with one exception folded into P1 Unit 6: briefs should name where bulk evidence lives (the run log, a working-notes path) so "point, don't absorb" has a concrete destination |

### Postmortem P2 candidates

| Candidate | Classification | Reasoning |
|---|---|---|
| **1. Richer `--status`** (elapsed, actor pid, descendant count, deadline remaining, output growth) | **Valid later improvement** — **P2** | Genuinely absent (claim 6). Descendant count should **reuse** `actor_tree_census` (`:643+`) rather than grow a second census. Constraint: `unattended-operation-plan-v0.2.md` § *Deferred* rejects "a structured JSON outcome event plus observer process" — enriching a read-only command is fine; growing an observer process is the rejected thing |
| **2. Dispatcher `--stop`** | **Valid later improvement, low marginal value** — **P2** | Verified absent, but the capability underneath already exists: the SIGTERM handler terminates the tree, *verifies* the result, pins the lock when it cannot account for the tree, and exits 28; `--status` already prints `kill -TERM <pid>` (`:1038`). `--stop` is a wrapper over that. It also inherits 1a's open gap — a doubly-forked detached daemon still escapes (`unattended-operation-plan-v0.2.md`, 1a "NARROWED, NOT CLOSED"). **It must not be described as closing 1a** |
| **3. Task-scoped session counts** | **Valid later improvement, mostly dissolved by P0** — **P2** | The count became untrustworthy *because* the dispatcher was bypassed and nesting was unbounded. With Unit 1 and Unit 4 in place, the run log's hop lines are already a task-scoped count. What survives is the reporting rule — never answer "how many sessions has this task used?" with workspace-wide telemetry — which is one sentence in the skill and can ride with P1 Unit 6 |

---

## 3. The P0 boundary

**P0 = the smallest coherent set required before another attended live dispatcher run.** Four units.

| Unit | What it makes true |
|---|---|
| **U1** Nested-actor default deny (attended) | A dispatcher-launched Claude cannot start `claude` or `codex` without an explicit, logged authorization |
| **U2** Honest post-hop classification | A stop names what actually happened: which files changed, and whether Claude touched the state file at all |
| **U3** Permission-denial stop | A permission dead end becomes a named stop with the denied tool, the target, and the decision required — not a mystery |
| **U4** No interactive fallback after a stop | A nonzero dispatcher exit is never authorization to continue by hand |

**Why these four and not more.** The incident's cost had two mechanisms: unbounded nesting (U1) and
the interactive bypass (U4). The bypass had one *cause*: the dispatcher reported the wrong thing and
the right thing was unavailable (U2, U3). Fixing the mechanisms without the cause leaves the same
temptation in place under a new prohibition, which is how the existing `SKILL.md:195` rule already
failed once.

**Why the permission-mode option is not in P0.** Without it, a permission dead end now *stops
honestly* instead of dead-ending silently. That is a safe outcome, not a blocked one. Adding attended
`acceptEdits` widens what a child may do without asking; it belongs in § 5 as an operator decision,
not in a safety floor Claude sets for itself.

**If the operator wants less than four:** the irreducible pair is **U1 + U4** — one deny array plus
two instruction sentences. That bounds the cost and forbids the bypass. It leaves the misdiagnosis
that caused the bypass in place, and this plan does not recommend stopping there.

**Not in P0, and why:** state snapshots (U5, forensics not safety) · correction profile and nested-AI
budget (U6, P1 — they govern the *next* brief, not the next run) · `runs/` disposition (U7, an
operator decision) · richer `--status`, `--stop`, session counts (P2 — observability, not a boundary).

---

## 4. Implementation units

Every unit is independently assessable: it can be briefed, built, evidenced and closed without any
other unit being done first, except where a dependency is named.

### Verification budget — applies to every unit below

- **Default method:** static inspection plus the existing simulated harness
  (`dispatch.test.sh`, currently 375 pass / 0 fail per the P0-F record). The harness already captures
  literal argv through a fake `claude` binary (`WL_ARGV_FILE`, `argv_pair`, `argv_has` —
  `dispatch.test.sh:1945, 1974, 2075, 2324`) and already drives full hop shapes through `--actor-cmd`.
- **Zero nested Claude or Codex invocations.** Not one, in any unit, including closure checks.
- **No exhaustive scenario matrix.** Each unit's evidence is one matched red/green pair plus the
  controls named in its own row. A red half that passes is not evidence.
- **No live model-backed run** unless a later unit states why cheaper evidence cannot settle a
  consequential claim, and obtains operator approval carrying a **maximum invocation count** and a
  **wall-clock deadline**. Exactly one unit below reaches that bar, and it is gated on a decision.
- **Correction budget for any of these units:** the frozen findings only, static inspection plus the
  harness, zero nested AI, 10 minutes wall-clock. A correction that cannot finish inside that is
  handed back, not extended.

### P0 units

#### U1 — Nested-actor default deny on the attended path

- **Observable outcome:** every attended Claude launch carries deny rules for `claude` and `codex`
  invocation, and the logged command line says so. `--allow-nested-actors N` (default 0) is the only
  way to lift them, and using it writes the authorization into the run log.
- **Allowed surfaces:** `dispatch.sh` (deny array, parser, launch construction, run-log lines),
  `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the `--unattended` contained profile (its deny set is a separate settled artifact);
  any settings.json in any layer; the executable core; the Claude command; the skill.
- **Dependencies:** none.
- **Stop conditions:** if closing the gap requires editing a settings file rather than adding launch
  flags — that reopens P0-F's settled mechanism, so stop and escalate. If a deny rule would also
  block the child's ordinary work (the child's own `git`, for instance), stop and hand back rather
  than widening.
- **Minimum evidence that can fail:** matched red/green argv capture — against the pre-change
  dispatcher the new assertions must **fail**, and the existing 375 must still pass; against the
  changed one all pass. Plus two controls: `--allow-nested-actors 1` produces argv *without* the deny
  pair and a run-log authorization line; the `--unattended` argv is byte-unchanged.
- **Verification budget:** static + harness. Zero AI invocations.
- **Stated limitation, not a defect:** this is the **requested** policy. A permission-layer deny is
  not containment — a determined child can evade a tool-name deny from a shell. Say so in the README
  in the same breath, exactly as P0-F does for `--permission-mode`. Measuring the *effective* policy
  would need a live child and is explicitly out of budget here.

#### U2 — Honest post-hop classification

- **Observable outcome:** three separate, correct outcomes replace one wrong one.
  1. `UNCOMMITTED_HANDBACK` (25) fires only when Claude actually changed the state file this hop —
     `after_hash != before_hash`, or the file was clean before and is dirty now.
  2. A state file that was already dirty before launch and is byte-identical after produces a
     **different** outcome that says exactly that, and never says "Claude edited it".
  3. Any hop that leaves **in-allowlist** files modified lists them by path in the run log and in the
     stop message, whatever the exit code.
- **Allowed surfaces:** `dispatch.sh` (`:1917`, `:2007-2019`, `foreign_worktree` region `:1364-1375`,
  the exit taxonomy comment `:121-166`), `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the retry/partial-effect logic at `:1935-1973` (correct as written, different
  question); the Codex-HEAD guard `:1990`; the committed-path check `:1997-2005`.
- **Dependencies:** none.
- **Stop conditions:** if a new exit code is needed and the taxonomy has no free number in range,
  hand back rather than reusing an occupied one. If listing in-allowlist changes would require a
  second `git status` pass per hop with measurable cost, say so and hand back the cost.
- **Minimum evidence that can fail:** simulated hops via `--actor-cmd` producing each shape exactly —
  (a) pre-dirty state file + actor that changes nothing → must **not** report exit 25 with "Claude
  edited"; (b) clean state file + actor that edits and does not commit → must still report 25;
  (c) actor that modifies an allowed implementation file and leaves the state file alone → the file
  is named in the output. Red half run against the pre-change dispatcher: (a) must fail there.
- **Verification budget:** static + harness. Zero AI invocations.
- **Carried in, narrowed:** claim 2b. Add one clause to both exit-25 messages naming the addressee —
  the operator does this, not Codex — so a Codex reader cannot take it as an instruction to itself.
  This is a wording fix inside a unit that is already touching those two strings; it is not a
  separate unit and does not deserve one.

#### U3 — Permission-denial parsed into a specific stop

- **Observable outcome:** when a Claude hop's JSON capture contains `permission_denials`, the
  dispatcher exits with a permission-specific code whose message carries the denied tool, the exact
  target path or command, the files changed before the denial, and the operator decision required.
- **Allowed surfaces:** `dispatch.sh` (a parse step over the hop capture, plus one exit code and its
  taxonomy entry), `dispatch.test.sh`, spike `README.md`.
- **Exclusions:** the `--unattended` stream-json path's `system/init` handling; the launch
  construction; anything that would make the dispatcher *decide* what to do about a denial — it
  reports and stops (§ 6).
- **Dependencies:** none for the parse. A recorded real capture is needed as a fixture; the spike
  already documents one at `runs/live-permission-denial-2026-08-05.md` (`README.md:837`). If that
  record does not contain a usable raw JSON body, hand back rather than generating a fresh one with a
  live run.
- **Minimum evidence that can fail:** replay a fixture JSON body carrying two `Edit` denials through
  the parse and assert the exact denied tool and target appear in the stop message; plus a control —
  a clean capture with no denials must produce the ordinary path and **no** permission stop. Against
  the pre-change dispatcher the first must fail.
- **Verification budget:** static + harness + one recorded fixture. Zero AI invocations. The fixture
  is a *replay* of evidence already paid for; regenerating it live is explicitly out of budget.

#### U4 — A dispatcher stop is never authorization to continue by hand

- **Observable outcome:** the Codex skill states, at the point where a stop is read, that a nonzero
  exit authorizes exactly two things — fix the cause and re-run the dispatcher, or stop for the
  operator — and never an interactive Claude session, a hand-carried hop, or a hand-edit of the state
  file. A dispatcher capability gap is a capability gap, not a licence.
- **Allowed surfaces:** `.agents/skills/work-loop-v2/SKILL.md` — § *Three outcomes* (the **Stopped**
  row, `:250-256`) and § *What you never do* (`:517-527`).
- **Exclusions:** the executable core (§ 7 already reserves consequential situations for the
  operator; nothing there needs changing); `.claude/commands/work-loop-v2.md` (Claude never chooses
  the transport, so the rule has no addressee there); the dispatcher.
- **Dependencies:** none.
- **Stop conditions:** if stating the rule requires contradicting core § 7 or the existing `:195`
  text, stop — the rule is meant to place an existing prohibition, not add a competing one.
- **Minimum evidence that can fail:** the changed text quoted against what it replaced, plus the
  demonstration that the current text does *not* say it — the **Stopped** row today lists codes only.
  One line on why no automated check distinguishes success from failure here: the artifact is an
  instruction to a model, and any grep would search for words this very brief supplied.
- **Verification budget:** inspection only. Zero AI invocations, zero harness runs. Per the Claude
  command (`.claude/commands/work-loop-v2.md:209`), a prose change's evidence is the changed text —
  a behavioural test farm for a Markdown edit is the exact failure this plan exists to prevent.

### P1 units

#### U5 — Preserve the state file before each hop

- **Observable outcome:** each hop writes a byte-for-byte copy of the state file into the run
  evidence directory before the actor launches (`$RUN_ID.hop<n>.<actor>.state.md`), alongside the
  existing `.out` and `.tree`. The sha256 lines stay as they are.
- **Allowed surfaces:** `dispatch.sh` (`:1894` region), `dispatch.test.sh`, spike `README.md` § run
  evidence table (`:20`).
- **Exclusions:** the state file itself; retention or pruning policy for the evidence directory (that
  is U7's question); anything that reads the snapshot back and acts on it — this unit preserves, it
  does not compare.
- **Dependencies:** none. Interacts with U7 (a snapshot per hop makes the untracked-evidence question
  slightly larger, and should be mentioned in that decision).
- **Stop conditions:** if the snapshot would land anywhere the dispatcher's own allowlist does not
  cover, stop — a guard tripping on its own evidence is worse than no snapshot.
- **Minimum evidence that can fail:** run a simulated two-hop sequence; assert a snapshot exists per
  hop and that its bytes equal the pre-hop file, then mutate the file between hops and assert the two
  snapshots differ. Against the pre-change dispatcher, no snapshot exists at all.
- **Verification budget:** static + harness. Zero AI invocations.

#### U6 — Correction profile, nested-AI budget, and evidence pointers in the brief

Three small instruction changes that share one surface and one review, and are wrong to split.

- **Observable outcome:**
  1. A correction round carries an execution profile: only checks tied to the frozen findings, zero
     nested AI actors, a stated wall-clock ceiling, and — for instruction-file corrections —
     inspection unless one targeted behavioural check is materially necessary and said to be.
  2. A brief that proposes any nested Claude or Codex invocation must state a maximum invocation
     count, a wall-clock deadline, why non-AI fixtures cannot settle it, and that the operator
     approved it. Absent all four, the brief may not propose nesting.
  3. A brief names where bulk evidence lives (run log, working-notes path) rather than letting the
     state file absorb it, and the session-count reporting rule from P2-3 is stated: a task-scoped
     question gets a task-scoped answer.
- **Allowed surfaces:** `.agents/skills/work-loop-v2/SKILL.md` — § *Opening a unit and writing the
  brief* and § *Assessing the result* (*Correcting once*). Possibly one sentence in
  `.claude/commands/work-loop-v2.md` § *Correction rounds*, if the ceiling must bind Claude's own
  closure work too.
- **Exclusions:** the executable core — **this unit must not add a field, artifact or stage**, which
  core § 3 step 3 and core § 4's five-field ceiling both forbid. The budget is text inside the brief,
  not a new heading. No proportionality "preflight" stage is created (§ 2, P1-3).
- **Dependencies:** item 2 is only meaningful once U1 exists, because `--allow-nested-actors` is what
  the operator's approval would authorize. Brief it after U1.
- **Stop conditions:** if the change cannot be made without a new field or stage, stop and escalate —
  that is a core change, and core changes are not this task's to make.
- **Minimum evidence that can fail:** the changed text quoted against what it replaced, plus a
  demonstration that the current text does not bound correction cost (core § 3 *Correcting once*
  freezes scope only; `SKILL.md:505` restates that and adds no ceiling). One line on why automation
  would not distinguish success from failure.
- **Verification budget:** inspection only. Zero AI invocations.

#### U7 — Frame the `runs/` disposition as an operator decision

- **Observable outcome:** a short decision brief — not a decision — stating the three options
  (track and commit run evidence per run; ignore it and treat the checkout as ephemeral; keep it
  tracked in the canonical checkout and ignored in linked worktrees), each with what is lost, and the
  narrowest reversible boundary for each.
- **Allowed surfaces:** one new file under `plans/work-loop-v2-v0.2/`. **No `.gitignore` change and
  no `git add` of run evidence in this unit.**
- **Exclusions:** making the decision; any change to `dispatch.sh:385` (the default log directory);
  cleanup of existing run evidence in any checkout.
- **Dependencies:** none. Mention U5 if U5 has landed.
- **Stop conditions:** none expected; if the framing turns out to require deciding, hand back.
- **Minimum evidence that can fail:** the per-checkout state quoted for both checkouts, with the
  commands that produced it — this checkout 48/48 tracked, the incident worktree three untracked run
  files. A framing whose facts could not have come out differently is not a framing.
- **Verification budget:** inspection only. Zero AI invocations.

### P2 units

Not briefed here. Recorded so they are not lost, and so no one rebuilds them by accident.

- **U8 — richer `--status`:** elapsed runtime, actor pid, descendant count (reusing
  `actor_tree_census`), current hop, deadline remaining, output-file growth. Must stay read-only and
  must not become an observer process (rejected in `unattended-operation-plan-v0.2.md` § *Deferred*).
- **U9 — `--stop`:** a wrapper over the existing verified teardown. Must not be described as closing
  Phase 1 item 1a — the detached-daemon escape is still open.
- **U10 — task-scoped session counts:** largely dissolved by U1 and U4; the reporting sentence rides
  with U6.

---

## 5. Settled decisions a proposed fix would reopen

Six. Each is named so no unit reopens one silently.

1. **Attended `--permission-mode default` is the settled attended mechanism.**
   Closed record: `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md`, `turn: operator`,
   2026-08-09. Adding `--claude-permission-mode acceptEdits` reopens it. **Operator decision, framed
   below.**
2. **Claude makes every commit** (core § 4). No recovery text, and no unit, may imply Codex commits.
   U2 carries the narrowing clause.
3. **The brief creates no new field, artifact or stage** (core § 3 step 3), and the state file holds
   at most five fields (core § 4). This is what rejects the proportionality preflight and constrains
   U6 to prose inside existing sections.
4. **The dispatcher is transport** (core § 4 *An approved courier may carry the turn*). § 6 below.
5. **"A structured JSON outcome event plus observer process" is rejected**
   (`unattended-operation-plan-v0.2.md` § *Deferred*). Constrains U8.
6. **Phase 1 item 1a is narrowed, not closed** — a doubly-forked detached daemon still escapes the
   teardown. Constrains U9, and is a stated limitation of U1: a denied tool name is not a sandbox.

### The operator decision — attended `acceptEdits`

Stated with value, risk and the narrowest reversible boundary, as the brief requires. **Not decided
here.**

- **What it would allow.** A dispatcher flag carrying an operator-approved permission mode into an
  attended Claude hop, so a run blocked on a permission gate can resume *inside the dispatcher*
  rather than by hand.
- **Value.** It closes the exact capability gap that produced the bypass. On 2026-08-10 the operator
  had already approved the edits; the dispatcher had no way to represent that approval, and the
  approval was then executed by driving Claude directly — which cost every safeguard at once.
- **Risk.** `acceptEdits` applies file edits without asking. Combined with the allowlist it is
  bounded by path, but the allowlist is a per-task input written by Codex, and the plan v0.2 already
  records the honest cost: "too wide and this check means nothing" (`dispatch.sh:1390-1392`). It also
  moves attended runs away from a posture chosen *because* a child had silently inherited
  `bypassPermissions`.
- **Narrowest reversible boundary, if approved.** Opt-in per run, never a default. Accept only
  `default` and `acceptEdits`; reject `bypassPermissions` on every attended path, as now. Require the
  approval to be written into the run log at launch, naming the paths it covers. Refuse to combine
  with `--unattended`. Reversible by removing one flag from one invocation — no settings file in any
  layer is touched, which is the property P0-F chose and this preserves.
- **Verification, if approved.** This is the one candidate where the postmortem's regression scenario
  2 ("the same task can resume under operator-approved `acceptEdits` without interactive control")
  cannot be settled by argv capture alone — argv proves the request, not the effect, and P0-F already
  accepted exactly that limitation once. If the operator wants effect proven, that is **one** live
  attended hop, with a stated maximum of **1 invocation** and a **10-minute** wall-clock deadline,
  approved separately. Not authorized here.

---

## 6. Preserving the dispatcher as courier

Core § 4 permits a courier to carry a turn the state file already states, and forbids it to change
content, choose which actor moves next, decide that a turn exists, continue past `turn: operator`, or
stand in as evidence. Every candidate was checked against that.

**Compatible — reporting or bounding, not deciding:**

- U2 and U3 make the dispatcher *report* more accurately. Reporting what a hop did is transport.
- U1's `--allow-nested-actors N` is a numeric bound, not a judgment. The **authorization** is the
  operator's and is recorded; the dispatcher enforces a count.
- U5 preserves bytes. It compares nothing and concludes nothing.
- U8 and U10 report. U9 terminates on an instruction it is given.

**Rejected or constrained on this ground:**

- **A proportionality preflight inside the dispatcher would be a semantic decision** — judging whether
  a brief's verification demand is proportionate is Codex's assessment, not a courier's. Already
  rejected as a stage (§ 2); rejected a second time as a *location*. If any part of it lands, it
  lands in the Codex skill.
- **A correction "profile" enforced by the dispatcher** must be limited to the existing `--deadline`.
  The dispatcher may hold a clock; it may not decide what counts as a correction or which checks
  belong to a frozen finding.
- **Nothing may make a stop advisory.** A guard that reports and continues would let the dispatcher
  decide that a turn exists. Every unit above stops.
- **No unit may create a second state system.** U5 writes evidence, not state; U7 decides where
  evidence lives, not what is true. The state file stays the single interface.

---

## 7. Why the plan's soundness is not testable by execution

Required by the brief, and it is the same rule this plan applies to its own units.

This artifact is a set of classifications and boundaries. Its failure modes are *misclassification* —
calling an already-built thing a defect, calling a policy decision a fix, or missing a settled
decision a unit would reopen — and every one of those is settled by reading the repository, which is
what § 1 and § 2 do and cite. Running the dispatcher would exercise the current code; it would not
tell anyone whether "U1 before U3" is the right order, whether `acceptEdits` is the operator's to
decide, or whether the proportionality preflight duplicates core § 3. An AI-backed behavioural check
would be worse than useless here: it would consume the exact resource this plan exists to bound,
while grepping for words this plan supplied.

**What makes it fail-capable instead.** Each classification is traceable to a named file and line and
could have resolved differently — and three did. Claim 2b was **not** confirmed and its candidate was
narrowed rather than adopted. Claim 7 came out **false for this checkout** and its candidate was
re-scoped from "runs/ is untracked" to "linked worktrees strand evidence". The postmortem's own
"current repository state" was found **stale** — the correction commit `9a8399c` exists. A plan that
had agreed with every input would be evidence of nothing.

---

## 8. Source-to-plan coverage

| Source | Where used |
|---|---|
| Postmortem, `~/.codex/attachments/c97f82c6-…/pasted-text.txt` (290 lines, read in full) | § 2 all three candidate tables; § 3; incident summary above |
| `dispatch.sh:282-303` (parser) | Claim 1, claim 6; U1 |
| `dispatch.sh:1687-1694` (attended launch) | Claim 1; § 5 decision; U1 |
| `dispatch.sh:1148-1152, 1325-1330` (attended posture, `claude_deny=none`) | Claim 5; U1 |
| `dispatch.sh:236-242` (`UNATTENDED_BASE_DENY`) | Claim 5; U1 exclusions |
| `dispatch.sh:1416-1418` (`state_dirty`), `:1917`, `:2007-2019` | Claim 2a; U2 |
| `dispatch.sh:1793-1795` (pre-flight exit 25) | Claim 2b; U2 narrowing |
| `dispatch.sh:1364-1375` (`foreign_worktree`), `:1390-1392` | P0-4; U2; § 5 decision risk |
| `dispatch.sh:419, 1123-1124, 1294, 1502-1503, 1596-1597, 1786, 1894, 1978` | Claim 3; U5 |
| `dispatch.sh:121-166` (exit taxonomy) | Claim 4; U2, U3 |
| `dispatch.sh:1020-1092` (`--status`), `:1038` | Claim 6; U8, U9 |
| `dispatch.sh:385, 317` (default log dir, default allowlist) | Candidate B; U7 |
| `dispatch.sh:643-670, 848-855` (census, teardown) | Claim 5; U8, U9 |
| `dispatch.test.sh:1945, 1974, 2075, 2324` (argv capture) | Verification budget; U1 evidence |
| `README.md:44, 307, 316, 837` | Claims 1, 4; U3 fixture |
| `.agents/skills/work-loop-v2/SKILL.md:195, 250-256, 450, 505, 517-527` | P0-6; U4; U6; P1-3 duplicate finding |
| `.claude/commands/work-loop-v2.md:209` | U4 verification budget; the prose-evidence rule |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` §§ 3, 4, 6, 7 | § 5 items 2–4; § 6; P1-3 and P1-4 rejections |
| `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md` | § 5 item 1; § 5 decision |
| `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` (status table; 1a; 1g; § Deferred) | § 5 items 5–6; U8, U9 |
| `../ai-resources-diagnostics-workflow` (git state, `9a8399c`, `ea77d66`, untracked run files) | Claim 7; stale-source correction; U7 evidence |

---

## 9. Recommended first implementation unit

**U1 — nested-actor default deny on the attended path.**

**Why it has the highest safety value per unit of change.** It is the smallest change on the list —
two deny rules, one integer flag, two run-log lines — and it is the only one that acts on the
mechanism that produced the cost. One unit became ≥13 Claude processes because a dispatcher-launched
child could freely launch more; nothing in this repository currently prevents that, on any attended
path. U2, U3 and U4 make the loop *honest*, which removes the temptation to bypass it; U1 makes the
runaway *impossible to reach* even if someone is tempted anyway.

It also carries the least friction of any P0 unit: it reopens no settled decision, needs no operator
approval to proceed, and its evidence is a matched red/green argv capture against the harness that
already exists — fail-capable, and zero AI invocations. Its one honest limitation is stated in the
unit and mirrors a limitation this repository has already accepted once: it is a permission-layer
policy, not containment.

**This plan does not authorize U1 and does not perform it.**
