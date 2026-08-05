---
task: work-loop-v2-handoff-dispatcher
turn: codex
---

## Objective and scope

Build and prove a throwaway, task-scoped dispatcher spike that can carry one exact Work Loop task through routine Codex and Claude turns without operator transport. This unit is limited to a single task in a single checkout and to the smallest live tracer bullet that demonstrates explicit routing, sequential actor launch, validated transitions, and a safe stop; it does not install production automation.

Codex framing decision: keep all new spike code, fixtures, and focused tests isolated under `plans/work-loop-v2-v0.2/handoff-automation-spike/`, unless repository inspection proves that location violates an existing convention. Excluded from this unit: edits to `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, the executable core, the approved proposal, the investigation report, any `.claude` or `.codex` hook/settings file, the active task-state schema, daemon/service installation, reciprocal Stop hooks, session-resume architecture, multi-worktree execution, production deployment, push, merge, and destructive recovery.

## Lane and unit

Standard. Unit 1 — construct and execute the single-task process-exit dispatcher tracer bullet.

Named reason for the loop: the work crosses product runtimes and permission boundaries, needs scope containment so a spike does not become production orchestration, and its live evidence must be assessed by Codex rather than accepted from the builder alone.

Plan justification: the approved MVP proposal places automatic triggering and hooks in post-MVP work once real operation supplies a trigger; the operator has now supplied that trigger (routine babysitting across concurrent Work Loops) and has explicitly directed this build to start in Work Loop v2. This current operator decision narrowly supersedes the proposal's no-self-hosting rule for this task; every other applicable role, safety, evidence, and operator-stop boundary remains governing. The v0.2 pilot decision to shed state-file and turn-flag ceremony means this unit may use the current `turn:` field as a temporary spike seam but must not promote it to permanent architecture.

## Brief

This unit answers the riskiest question before any hook system is installed: can one external, task-aware controller safely alternate the installed Codex and Claude headless entrypoints and stop on the existing authoritative state? It is justified now by the operator's observed babysitting cost and implements only the tracer bullet recommended by the completed investigation. Success gives the next unit real transport evidence; failure leaves the live Work Loop unchanged and reports the exact boundary.

### Required outcome

Produce a runnable throwaway dispatcher spike plus focused failing-case checks which, for one exact task id and one exact checkout:

1. canonicalize and validate the checkout and `logs/work-loop/{task-id}.md`, reject traversal, require filename/frontmatter identity, and accept only `turn: codex | claude | operator`;
2. launch at most one actor at a time, using the installed Codex and Claude non-interactive entrypoints with the exact task id rather than scanning for a candidate;
3. impose an external timeout and a small absolute hop limit, record machine-detectable process completion, and re-read the same state file after every exit;
4. continue only after an allowed, observable state transition; stop visibly on `turn: operator`, unchanged or malformed state, wrong identity, actor failure, timeout, unexpected repository effects, or dirty-tree ambiguity;
5. demonstrate one controlled real Codex-to-Claude-to-Codex transport sequence, or stop with falsifiable evidence at the first live product boundary that prevents it;
6. keep routine transport outside product-to-product reciprocal Stop hooks and create no semantic queue or shadow state.

Mechanism choice inside the isolated spike directory belongs to Claude. The investigation's shell/process-exit dispatcher is prepared guidance, not permission to weaken any outcome or stop condition.

### Governing and supporting sources

- **Current operator decision — governing:** “Let's build this in Claude. Start work-loop-v2.” This authorizes the task, Claude execution, and the narrow self-hosting deviation stated above.
- **Approved governing direction:** `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`, especially § 3 decision 6, § 6 role/interface rules, and § 7 Post-MVP.
- **Applicable deployed workflow contract:** `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. Its header still says draft; do not silently promote its approval status, but its safety and role rules govern this invocation because both live entrypoints designate it as their contract.
- **Authoritative v0.2 direction:** `plans/work-loop-v2-mvp/step-7-pilot-log.md`, “The decision — 2026-08-01,” especially the decision to keep adversarial review and shed most bookkeeping.
- **Prepared non-governing architecture recommendation:** `plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md`. Use it for product-source links, rejected options, proof gates, and the recommended pilot; challenge any stale or false claim rather than implementing around it.
- **Applicable concurrency authority:** `docs/parallel-sessions-playbook.md`. This unit stays in one checkout and runs serially; it must not claim multi-loop support.

Material reclassification disclosed: the investigation's “no self-hosting” boundary governed the investigation, but the operator's newer explicit instruction overrides it only for this build task. Material item deliberately held outside the unit: the report's parallel worktree spike and production hook/daemon options remain deferred because the single-checkout transport seam has not yet passed.

### Check against the repository before acting

1. **Verify-first claim:** the active state file is `logs/work-loop/work-loop-v2-handoff-dispatcher.md`, its filename matches `task: work-loop-v2-handoff-dispatcher`, and it says `turn: claude`. Inspect that exact file and frontmatter.
2. **Verify-first claim:** the explicit Codex app binary exists at `/Applications/ChatGPT.app/Contents/Resources/codex`, and the Claude CLI resolves from the environment. Inspect both paths and obtain read-only version/help output before constructing a live launch.
3. **Verify-first claim:** no existing task-scoped Work Loop handoff dispatcher already implements this outcome. Search `.claude/hooks/`, `.codex/hooks/`, `.Codex/hooks/`, `logs/scripts/`, `scripts/`, and `plans/work-loop-v2-v0.2/` for `handoff dispatcher`, `work-loop.*dispatcher`, and code that combines `codex exec` with `claude -p`; bound the absence claim to those surfaces and patterns.
4. **Verify-first claim:** current product Stop hooks must not recursively enrol the spike. Inspect `.claude/settings.json` and `.Codex/hooks.json` plus their referenced Stop scripts for any Work Loop dispatch or child-agent launch behavior. If present, hand back rather than guessing about recursion.
5. **Verify-first claim:** repository authority still warns that same-checkout concurrency is unsafe and the v0.2 decision still says turn flags/bookkeeping are to be shed. Check `docs/parallel-sessions-playbook.md` § 4 and `plans/work-loop-v2-mvp/step-7-pilot-log.md` under “The decision — 2026-08-01.”
6. **Unknown to establish by execution:** the installed Codex binary can run the explicit `$work-loop-v2` skill non-interactively in a controlled spike fixture, and `claude -p` can run `/work-loop-v2 {task-id}` non-interactively without dangerous permission bypass. Treat either failure as valid evidence and stop; do not install, upgrade, authenticate, or broaden permissions to force green.

### Required evidence

Evidence must be capable of failing and must distinguish simulated controller logic from live product transport.

- A focused harness first fails with the dispatcher absent or deliberately disabled, then passes for exact-task routing, mismatch rejection, `turn: operator` stop, unchanged-transition stop, actor failure/timeout stop, and hop-limit enforcement.
- Readable command evidence names the exact Codex and Claude executable, version, invocation shape, exit status or terminal structured event, and each before/after state-file hash and `turn:` value for the controlled live sequence.
- A negative routing case proves that misleading files already present under `logs/work-loop/` are not selected; success cannot be inferred merely because some task ran.
- A recursion check proves that existing product Stop hooks do not start an extra dispatcher or child actor during the controlled run.
- Repository evidence identifies every path the unit created or changed and shows the excluded live Work Loop resources, hook/settings files, proposal/core, and investigation report were unchanged.
- Git evidence shows Codex did not change HEAD and Claude made only commits required by the controlled fixture and this unit, using explicit pathspecs; any foreign staged or dirty state stops the spike rather than being swept in.

If a fully live round trip cannot be completed safely, return the furthest proven transition, the exact failing command/event, what remained unchanged, and the smallest next decision. Do not substitute a mocked green result for live evidence.

### Completion and stop conditions

Completion: the isolated spike and its focused checks exist, the controlled live sequence has either completed through the required Codex-to-Claude-to-Codex transitions or stopped at a precisely evidenced product boundary, `## Latest result` contains the inspection record plus result/evidence, `turn:` is `codex`, and Claude has committed the state file and every in-scope artifact by explicit pathspec.

Stop and hand back to Codex if any verify-first claim is false, if exact task routing cannot be preserved, if required evidence cannot be produced, or if implementation would touch an excluded live resource. Stop for the operator if the spike would require authentication changes, dangerous permission bypass, installation or upgrade, a hard-to-reverse choice, destructive cleanup, scope expansion, same-checkout concurrency, or reopening any decision beyond the narrow self-hosting override already supplied. Claude is explicitly permitted to challenge a false premise or stale direction; it must not improvise past one.

## Latest result

Inspected (2026-08-05):

- Claim (1): HOLDS — read `logs/work-loop/work-loop-v2-handoff-dispatcher.md`; frontmatter `task:`
  is `work-loop-v2-handoff-dispatcher`, matching the filename stem, and `turn:` was `claude`.
- Claim (2): HOLDS — `ls -la /Applications/ChatGPT.app/Contents/Resources/codex` returns an
  executable (270,605,984 bytes); `--version` reports `codex-cli 0.146.0-alpha.9.2`. `which claude`
  resolves `/Users/patrik.lindeberg/.local/bin/claude`; `--version` reports `2.1.220 (Claude Code)`.
  `codex exec --help` and `claude --help` were read before any live launch was constructed.
- Claim (3): HOLDS — searched `.claude/hooks/`, `.codex/hooks/`, `.Codex/hooks/`, `logs/scripts/`,
  `scripts/` and `plans/work-loop-v2-v0.2/` for `handoff.dispatcher`, `work.loop.*dispatcher`,
  `codex[[:space:]]+exec` and `claude[[:space:]]+-p`. The only file matching any pattern is
  `plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md` — the prepared
  recommendation, not an implementation. No dispatcher existed. (Incidental: `.codex` and `.Codex`
  are one directory, inode 9708167 — a case-insensitive filesystem, not two hook surfaces.)
- Claim (4): HOLDS — `.claude/settings.json` declares three Stop handlers
  (`check-stop-reminders.sh`, `coach-reminder.sh`, `improve-reminder.sh`) and `.codex/hooks.json`
  declares the same three. Read all three scripts: each emits a `systemMessage` JSON reminder and
  exits 0. Searched them for `claude|codex|work-loop|Task|agent|exec|subagent` — the only matches
  are `/tmp/claude-*` marker filenames and a comment. No Work Loop dispatch, no child-agent launch,
  so no recursive enrolment.
- Claim (5): HOLDS — `docs/parallel-sessions-playbook.md` § 4 opens with the anti-pattern block
  naming ad-hoc same-checkout parallelism "the #1 failure mode" and citing the 2026-06-05 collision.
  `plans/work-loop-v2-mvp/step-7-pilot-log.md` § "The decision — 2026-08-01, S14-198" item 3 reads
  "Most of the bookkeeping goes in v0.2 — the state-file ceremony, turn flags, unit numbering".
  Both premises are current.
- Claim (6) — the unknown to establish by execution: **both entrypoints run non-interactively, and
  the seam holds.** Established by the live run below, not by inspection.

Result: the spike exists, its controller checks pass, and **live cross-product transport is
proven**. Seven live actor launches produced six completed allowed transitions with no operator
carrying a turn, ending at `turn: operator`.

The live sequence, from
`plans/work-loop-v2-v0.2/handoff-automation-spike/runs/live-console.txt` and `live-console-2.txt`:

| hop | actor | exit | duration | turn | HEAD |
|---|---|---|---|---|---|
| 1 | codex  | 0 | 118s | codex → claude    | unchanged `94b440b` |
| 2 | claude | 0 | 275s | claude → codex    | `94b440b` → `fc252ef` |
| 3 | codex  | 0 | 107s | codex → claude    | unchanged `fc252ef` |
| 4 | claude | — | 100s | — | killed by the operator-side tool timeout, see below |
| 5 | claude | 0 | 420s | claude → codex    | `fc252ef` → `8ad98c4` |
| 6 | codex  | 0 | 113s | codex → claude    | unchanged `8ad98c4` |
| 7 | claude | 0 |  38s | claude → operator | `8ad98c4` → `47ebab8` |

Hops 1–4 ran under `run=20260805T152939`; hops 5–7 under `run=20260805T154555`, restarted from the
state file and Git with no in-memory carry-over.

Four things that could have read differently, and did not:

- **Codex never moved HEAD** on any of its three hops; Claude moved it on all three of its completed
  hops. That is core § 4's commit rule observed, not assumed.
- **The loop's own safety rule fired live.** At hop 2 the child Claude found Codex's brief rested on
  a false claim about `dispatch.sh`'s exit-`0` contract, refused to build on it, and handed back
  (commit `fc252ef`). Codex reframed at hop 3. Behaviours 1.2/1.3 were exercised by two separate
  processes, unprompted.
- **The close token crossed the seam.** Codex wrote core § 3's `Close the task:` line at hop 6;
  Claude reduced the file to the § 4 closing record at hop 7 and set `turn: operator`; the
  dispatcher stopped with **zero further launches**. Investigation proof item 3, live.
- **The fixture produced a real artifact**, not a marker: `handoff-automation-spike/README.md`
  (10.2 KB, commit `6de0bd2`) was written entirely through the transported loop.

**Hop 4 was killed by my own 10-minute foreground tool timeout, not by a product boundary.** The
SIGTERM reached the child Claude at 100s; the dispatcher reported `STOP [20] actor 'claude' exited
143` correctly. It is reported as an operator-harness artifact and nothing about product behaviour
is claimed from it. The retry from disk succeeded.

Evidence: `bash dispatch.test.sh` → exit 0, `pass=34 fail=0`. It is capable of failing —

- **Case 0 removes the subject.** It points the suite at an absent dispatcher and asserts the suite
  fails (exit 127). A green run with `dispatch.sh` deleted would be caught here.
- Seven cases were **observed failing and then passing** during this unit: five when the simulated
  actors wrote a trace file into the checkout, which the dispatcher correctly rejected as an
  out-of-allowlist change (exit 24) — the harness was wrong, the controller was right — and two more
  when a ping-pong actor restored the file byte-for-byte, leaving its commit nothing to stage.
- Cases 13/13b were **written from the live run's failure** and fail against the pre-fix dispatcher.
- The timeout case now asserts wall-clock elapsed, and fails against the pre-fix counter.

Every stop condition the brief required is asserted against a real exit code: exact-task routing
with three decoys present (case 1), identity mismatch rejected read-only and byte-identical
afterwards (2), traversal (3), missing/malformed state (4), `turn: operator` with zero launches (5),
unchanged-transition stopping once (6), actor failure and timeout (7), hop limit (8), foreign staged
state (9), Codex moving HEAD and out-of-allowlist writes (10), unattended round trip (11), second
dispatcher refused (12), uncommitted hand-back (13).

Negative routing, live: `logs/work-loop/` held 24 files during the run, including
`fixture-slice2-foreign.md` (a deliberate filename/`task:` mismatch) and three fixtures advertising
`turn: codex`. Only `spike-live-transport.md` was touched — `git diff --name-only 029fa7c..HEAD`
returns exactly four paths, and no decoy is among them. Success cannot be inferred from "some task
ran".

Recursion and concurrency: 750 `ps` samples across both runs (`runs/live-ps-samples.txt`,
`live-ps-samples-2.txt`). **Zero samples show two actors of the same kind, and zero show a Codex and
a Claude actor at once.** The product Stop hooks did fire during the child runs — their only
observable effect is appended telemetry lines in `logs/friction-log.md` from the
`log-write-activity` PostToolUse hook. No hook started a dispatcher or an actor.

One measurement correction, because the raw counts read worse than the truth: samples show
`dispatchers=2` and `dispatchers=3`. Recording PIDs and PPIDs shows why. `76073/76071` is the real
dispatcher; `76183/76073` is its own forked subshell with an identical command line; the transient
third entries have parents outside that tree and are the sandboxed dispatcher runs the *child*
Claude launched deliberately when it ran `dispatch.test.sh` as its own evidence. No second
dispatcher ran against the live checkout and task — the OS lock makes that impossible, and case 12
proves a second instance is refused with exit 17.

Repository effects: `git diff --name-only 029fa7c..HEAD` returns exactly
`logs/work-loop/spike-live-transport.md`,
`plans/work-loop-v2-v0.2/handoff-automation-spike/{README.md,dispatch.sh,dispatch.test.sh}`.
Verified unchanged across the whole unit: `.agents/skills/work-loop-v2/SKILL.md`,
`.claude/commands/work-loop-v2.md`, everything under `plans/work-loop-v2-mvp/` (proposal and
executable core), the investigation report, `.claude/settings.json`, `.claude/settings.local.json`,
`.claude/hooks/` and `.codex/`. No hook, settings or production file was installed or edited.
Permissions were not widened: no `--dangerously-skip-permissions`, no
`--dangerously-bypass-approvals-and-sandbox`; the child inherited the project's existing
`defaultMode: bypassPermissions` from `.claude/settings.json`, which this unit did not author.

Two things I did that depart from the brief as written, stated rather than absorbed:

1. **The live fixture's state file had to live at `logs/work-loop/spike-live-transport.md`, outside
   the isolated spike directory.** Codex's framing decision allowed this "unless repository
   inspection proves that location violates an existing convention", and it does: both live
   entrypoints resolve `logs/work-loop/{task-id}.md` from the checkout root
   (`.claude/commands/work-loop-v2.md` Step 1; core § 4), and every existing fixture already lives
   there. A fixture inside the spike directory is unreachable by the products under test. Nothing
   else left the spike directory.
2. **`logs/friction-log.md` was added to the dispatcher's allowlist for the live run only**, by
   explicit `--allow-path`, because the `log-write-activity` PostToolUse hook appends to it on every
   Write/Edit. Treating known hook telemetry as an unexpected repository effect would have produced
   a false stop that masks real ones. It is a launch argument, not a default: `dispatch.sh`'s
   built-in allowlist is unchanged and still excludes it.

Three deferrals — noticed during the unit, deliberately not done:

- **A worktree-per-task spike (investigation item 12).** Not started. This unit proves one task in
  one checkout, serially, and claims nothing about parallel loops.
- **The `--help` window in `dispatch.sh` is truncated** (`sed -n '2,45p'`), so it omits exit code 25
  and the exit-`0` qualifier. Found by the child Claude at hop 5 and left in place; it is cosmetic
  and the full set stays inspectable in the source and in the README.
- **`dispatch.sh` line 31's original single meaning for exit `0`** — corrected in this unit by
  qualifying it, since the file is my own deliverable rather than an excluded file. Recorded because
  the closed fixture task still records it as a deferral against its own narrower scope.

Two defects the live run found in my own dispatcher, both fixed and regression-tested rather than
noted:

- **A Claude hop killed between editing and committing left a partial state file, and nothing
  stopped.** The guard is asymmetric because the seam is: uncommitted with `turn: claude` is the
  expected Codex handoff (Codex never runs git), while uncommitted with `turn: codex` means a Claude
  hop died mid-write. New exit 25; cases 13 and 13b.
- **The actor timeout counted poll iterations, not wall clock**, so each pass cost `sleep 1` plus the
  polling work and `--timeout` silently became a lower bound. Hop 5 logged `duration=420s` against a
  420s deadline and still exited 0. Now measured against `date '+%s'`; the timeout case asserts real
  elapsed time.

Not established, and not claimed: production readiness; concurrency safety; repeat reliability
beyond these two runs; unattended handling of a genuine operator decision (`turn: operator` was
reached by a normal close, never by a § 7 risk stop); crash recovery beyond the one restart above;
and any hook-driven or daemon-driven triggering, which was never built.

## Blocker

None.

## Next action

Codex: assess Unit 1. The transport seam is proven for one task in one checkout, serially, and the
investigation's implementation boundary asks for items 1–11 before a real implementation — items 1–8
and 11 are covered above, item 9 (crash recovery) only partially, and item 12 (parallel worktrees)
not at all. Decide whether that is good enough to close this unit, and whether the next unit is the
worktree spike, a wider crash-recovery proof, or stopping here with the spike as a throwaway result.
Do not treat this unit as authorising production installation.
