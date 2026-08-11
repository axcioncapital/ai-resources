---
task: axcion-harness-v0-2-attended-release
turn: codex
---

## Objective and scope

Ship Axcíon Harness v0.2 as a usable attended-only release today: one thin canonical launch surface
around Work Loop v2 that carries an already-explicit turn through fresh actor processes, validates
the handback, and stops visibly without creating another semantic state system.

This task lives only in the `ai-resources` checkout. Scope is the minimum attended production
surface and its fail-capable tests under a new, narrowly named `scripts/axcion-harness-v0.2/`
boundary, plus this one state file. The existing handoff spike is read-only source material.
Excluded: Work Loop semantics; Proposal/core revision; new task artifacts or schemas; hidden session
resume; hooks or daemons; unattended execution; worktree automation; automatic push, merge, landing,
or cleanup; the retired Monday-prep task; the May harness; unrelated dirty files; and general docs.

## Lane and unit

Standard. Implementation mode. Unit 1 — create the smallest attended production launcher and protect
its transport boundary with tests.

Named reason for the loop: this promotes a runtime boundary from a throwaway spike, must survive a
fresh-session handoff, and needs assessment by someone other than its implementer before it counts
as deployed.

## Brief

Why this unit, why now: the semantic operating model already exists in Work Loop v2 and the spike
already proves exact-task fresh-process transport. The remaining useful step for today's release is
to expose only the attended subset as a small canonical surface, while leaving unattended autonomy
and the spike's experimental breadth out.

**Required outcome.** Implement the smallest standalone attended launcher under
`scripts/axcion-harness-v0.2/` that lets an operator provide an exact checkout and task id, carries
one explicit Work Loop turn, and reports the terminal result. Reuse proven behavior where useful,
but the new surface must not depend at runtime on files under `plans/` and must not acquire semantic
decisions of its own. Include proportionate deterministic tests in the same boundary.

**Governing authority and current operator decisions.**

- Current operator decision, 2026-08-11: proceed to deploy Harness v0.2 today, stop further
  contract ceremony, absorb Claude's `MINOR-DRIFT` contract-check result for present operation, and
  preserve the boundary that Work Loop v2 owns semantics while Harness v0.2 owns transport and
  structural validation. This authorizes this attended release unit, not unattended operation.
- Canonical project direction: `plans/axcion-harness-v0.2/mvp-plan.md`, especially the target
  architecture, Phase 2 attended vertical slice, attended MVP cut line, and acceptance criteria.
  Its header still says proposed/no implementation authorized; the current operator decision above
  supersedes that sentence for this bounded unit only. Do not edit the plan in this unit.
- Semantic contract: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` as currently
  deployed. Claude's 2026-08-11 contract check found all Proposal commitments present and only
  additive/minor drift. The operator accepted proceeding on those exact semantics. Do not revise
  the Proposal, core, command, or skill here.
- Verified implementation evidence to re-check before relying on it:
  `plans/work-loop-v2-v0.2/handoff-automation-spike/{dispatch.sh,dispatch.test.sh,README.md}` and the
  closed records `logs/work-loop/work-loop-v2-handoff-dispatcher.md`,
  `logs/work-loop/work-loop-v2-dispatcher-safety-gates.md`, and
  `logs/work-loop/axcion-harness-v0-2-p0-f-attended-policy.md`.

**Behavioral boundary.** The launcher transports only a turn already named by the exact state file.
It must preserve exact task/check-out binding, fresh actor processes, one actor at a time, structural
transition validation, repository/path ambiguity stops, attended Claude `--permission-mode default`,
bounded execution, operator-terminal stopping, and a concise terminal result. It must not decide
what the task means, create or rewrite briefs, assess implementation, choose the next actor, or
continue past `turn: operator`. Direct Work remains outside it.

**Attended-only release boundary.** The canonical surface must carry one hop per invocation. It must
not expose, forward, or silently default into the spike's loop/unattended behavior. Requests for
unattended operation, automatic multi-hop execution, worktree creation, hooks, daemons, or
permission bypass must fail closed with actionable output. Keep the interface smaller than the
spike; do not copy experimental capabilities merely because they exist.

**Claims to check against the repository before implementation.**

1. Inspect the current spike and establish which exact behaviors are necessary for a one-hop
   attended release and which belong only to simulation, unattended operation, parallel worktrees,
   or investigation. Record the decisive anchors.
2. Verify the current attended Claude argv actually includes `--permission-mode default` for both
   ordinary and deny-narrowed launches, and that no attended path invokes
   `--dangerously-skip-permissions`.
3. Verify the current state-file location, frontmatter identity, allowed turn values, transition
   expectations, dirty/path checks, timeout behavior, and terminal codes from executable code and
   fail-capable tests rather than README prose alone.
4. Search active `ai-resources` scripts and commands for an existing canonical attended launcher
   before creating one. If one already satisfies the required outcome, stop and hand back the false
   premise rather than duplicate it. Bound the absence claim to the searched paths and patterns.
5. Verify that `scripts/axcion-harness-v0.2/` does not collide with a tracked or untracked user
   surface. If it does, stop; do not overwrite or relocate it.

**Implementation freedom and framing.** The new directory is Codex's framing choice, made to give
the dispatcher a canonical non-`plans/` home and a narrow launch allowlist; challenge it if repository
conventions show it is wrong. Choose the internal mechanism. Prefer the least code that preserves
the proven attended behavior. A wrapper that still executes the throwaway spike at runtime does not
satisfy the outcome; neither does a broad copy that preserves unused experimental modes.

**Required evidence.** Provide a fail-capable red/green account for the new surface, including at
least: exact task/checkout rejection; malformed or mismatched state rejection; wrong or absent turn;
one-hop enforcement; operator-terminal stop; invalid/no transition; timeout or actor failure;
dirty/out-of-bound ambiguity; attended permission-mode argv; absence of bypass/unattended/multi-hop
paths; and a structured or otherwise unambiguous terminal result. Run syntax/static checks relevant
to the implementation and the new deterministic suite. Also run the existing spike suite only if
the implementation changes the spike (it should normally remain read-only). Evidence must quote
commands and outcome counts or exact failures, and must distinguish simulated proof from live proof.

The current dispatcher invocation carrying this unit is live evidence for the old spike's attended
transport, not proof that the new surface works. Do not launch a nested live model run from inside
this Claude hop. The next unit will exercise the accepted canonical launcher on a representative
task.

**Repository and commit boundary.** Preserve all pre-existing dirty or untracked paths byte-for-byte.
Only `scripts/axcion-harness-v0.2/**` and this exact state file may be changed or committed. Do not
modify the spike, friction log, another task file, `scripts/recall-search.py`, plans, skills,
commands, settings, or root-repository files. Make one intentional commit after the required checks.

**Completion condition.** The attended-only launcher and its tests are implemented within the exact
boundary; the required checks pass; `## Latest result` reports verified claims, changed paths,
fail-capable evidence, commit identity, and any limitation; `turn:` is `codex`; then stop. If the
smallest safe implementation cannot fit this boundary, hand back a concrete blocker rather than
widening it.

**Stop conditions.** Stop before changing Work Loop semantics or another durable AI resource,
weakening permissions or guards, enabling unattended/multi-hop behavior, touching an unrelated
dirty path, choosing a hard-to-reverse installation mechanism, or proceeding on a false premise.
Challenge stale direction instead of improvising.

## Latest result

Inspected (2026-08-11):

- Claim (1): HOLDS — read `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (2053 lines;
  function index, header exit-code table L119-196, arguments L280-355, `validate_state` L1339,
  `git_hazards` L1427, `closing_record_ok` L1456, `run_bounded` L1492, `launch_actor` L1594, the loop
  L1783-2053). Decisive anchors kept for one attended hop: task/checkout binding and traversal
  rejection (L356-396); read-only `validate_state` identity and turn check (L1339-1356); pre-launch
  hazard, staged and foreign-worktree stops (L1874-1893); `set -m` process-group launch with a
  wall-clock bound (L1492-1538); the post-hop allowlist delta, Codex-HEAD guard, committed-path
  check, uncommitted-handback guard and transition table (L1984-2026); the `turn: operator` terminal
  branch with its question/closing-record split (L1831-1859). Dropped as belonging only to
  simulation, unattended running, parallel worktrees or investigation: `--actor-cmd` (L1599-1605),
  `--unattended` and `write_unattended_profile` (L1155-1332), `--deadline`/`remaining_seconds`/
  `effective_timeout` (L1557-1592), the multi-hop loop and `--max-hops`/`--carry-one` (L1783, L2043),
  `--status` (L979-1093), the 3-handle descendant census and `report_teardown` (L538-978),
  `init_session_identity` (L1704-1782), and the retry-once branch (L1935-1969).
- Claim (2): HOLDS — searched `dispatch.sh` for `--permission-mode` and
  `--dangerously-skip-permissions`: `--permission-mode default` is present on BOTH attended launch
  branches, the deny-narrowed one (L1687-1690) and the ordinary one (L1692-1694). The string
  `--dangerously-skip-permissions` occurs once, at L1623, inside a comment; no launch line carries
  it. The mode is load-bearing here: `.claude/settings.json` and `.claude/settings.local.json` in
  this checkout both declare `permissions.defaultMode: bypassPermissions`, so an unstated mode is
  inherited bypass.
- Claim (3): HOLDS — taken from executable code, not README prose. State location
  `$CHECKOUT/logs/work-loop/$TASK.md` (L387-388); frontmatter identity and allowed turns
  `codex|claude|operator` (L1344-1355); transitions `codex:claude|codex:operator|claude:codex|
  claude:operator` (L2021-2026); dirty/path checks (L1364-1437); timeout via poll + TERM/KILL
  (L1516-1532); terminal codes (L119-177). Cross-checked against the fail-capable suite
  `dispatch.test.sh` (2494 lines) rather than README.md alone.
- Claim (4): HOLDS (absence confirmed) — no existing canonical attended launcher. Searched
  `scripts/`, `.claude/`, `.agents/` and `logs/scripts/` for `--permission-mode`,
  `--dangerously-skip-permissions` and `claude .*(-p|--print)`: the only hit is
  `.agents/skills/work-loop-v2/SKILL.md`, which is documentation, not a launcher. `scripts/` holds
  only `cc-worktree.sh`, `fix-mojibake.sh`, `recall-search.py`, `repo-audit.sh`,
  `skill-inventory.sh`; none carries a Work Loop turn. Nothing to duplicate, so no false premise.
- Claim (5): HOLDS (absence confirmed) — searched for `scripts/axcion-harness-v0.2`: absent from
  `git ls-files scripts/` (4 tracked files, none under it) and from `git status --short scripts/`
  (one untracked entry, `scripts/recall-search.py`). No collision; nothing overwritten or relocated.

Result: implemented the attended-only surface as two files inside the authorised boundary.

- `scripts/axcion-harness-v0.2/carry-turn.sh` (680 lines, comments included) — carries exactly ONE already-explicit
  turn for one exact task in one exact checkout, then stops. Depends on nothing under `plans/` at
  runtime. Makes no semantic decision: it never writes the state file, never authors a brief, never
  assesses, never picks the next actor, and treats `turn: operator` as terminal. Interface is
  strictly smaller than the spike's: `--checkout --task --timeout --claude-bin --codex-bin
  --allow-path --claude-deny --log-dir --dry-run --help`. Unattended, multi-hop, worktree, hook,
  daemon, permission-bypass and simulated-actor requests each fail closed at exit 10 with their own
  actionable message before anything launches. Every terminal path, including usage errors, ends in
  one `RESULT outcome=… code=…` line, so exit 0 is never ambiguous between a carry and an
  operator-terminal stop.
- `scripts/axcion-harness-v0.2/carry-turn.test.sh` (532 lines) — hermetic deterministic suite plus
  a `--prove-failure` mutation mode.

Changed paths: `scripts/axcion-harness-v0.2/carry-turn.sh`,
`scripts/axcion-harness-v0.2/carry-turn.test.sh`, and this state file. Nothing else was created,
modified or deleted; the spike, friction log, other task files, `scripts/recall-search.py`, plans,
skills, commands and settings are untouched.

Evidence (commands quoted, counts exact; simulated and live proof kept apart):

- `bash -n carry-turn.sh` → exit 0. `bash -n carry-turn.test.sh` → exit 0. `shellcheck` is NOT
  installed on this machine, so no lint beyond the parser ran — stated rather than implied.
- `./carry-turn.test.sh` → **98 passed, 0 failed**, across 14 sections: task/checkout binding (12,
  11), malformed and mismatched state (13, 14), wrong and absent turn (15), attended argv, one-hop
  enforcement, 16 boundary refusals, operator-terminal (question / closing record / malformed 26),
  transition validation (22), actor failure and timeout (20, 21), repository ambiguity (16, 18, 19,
  24, 25, 30), the lock's three pid states (17), dry run, the Codex direction, and a check that the
  launcher never writes the state file.
- `./carry-turn.test.sh --prove-failure` → **5 passed, 0 failed**, where passing means the assertion
  FAILED against a mutant. M1 strips `--permission-mode default` → the argv assertion fails. M2
  disables both transition guards → `claude → claude` carries at exit 0 instead of 22. M3 removes
  the refusal table → `--unattended` is accepted. M4 removes the pre-launch foreign-worktree stop →
  a dirty checkout carries at 0 instead of 18. M5 removes the uncommitted-handback guard → an
  uncommitted Claude handback carries at 0 instead of 25. Red then green, both recorded.
- Attended permission argv is proved LIVE, not by grep: there is no simulated-actor seam, so the
  launcher builds and execs its real argv, and `--claude-bin` points at a recorder binary that logs
  what it received. Recorded on both branches — `-p /work-loop-v2 <task> --output-format json
  --permission-mode default`, and the same plus `--disallowedTools Bash(git push:*)`. Neither argv
  contains `--dangerously-skip-permissions`.
- Live against this repository, read-only: `carry-turn.sh --checkout <this checkout> --task
  axcion-harness-v0-2-attended-release --dry-run --log-dir <outside the repo>` → exit 0,
  `RESULT outcome=VALIDATED code=0 … actor=claude turn_before=claude`. It read the real state file,
  reported the expected uncommitted-Codex-handoff note, and listed the pre-existing out-of-allowlist
  paths a live carry would stop on. No live model run was launched from inside this hop.
- Three suite failures were genuine and the launcher was right in all three: an operator-turn fixture
  left uncommitted correctly returned 25 rather than 0; a Codex fixture that committed correctly
  returned 24 (`Codex never runs git`); and a lock fixture keyed on a non-canonical `$TMPDIR` path
  had been passing against a lock that did not exist. The fixtures were corrected, not the guards.
- The spike suite was NOT run: the spike is unchanged and read-only in this unit.

Commit: `a232971` on `main`, subject `new: axcion-harness v0.2 — attended one-hop turn carrier`,
parent `027b1fe`. Only the three paths above are in it, staged and committed by explicit pathspec.

**Two commits, not one — disclosed.** The brief asks for one intentional commit. The first record
written into `a232971` misstated two facts about itself: it named the parent as `e0fb010` (the head
my dry-run had read minutes earlier — the concurrent session committed `027b1fe` in between) and gave
the file sizes as roughly 430 and 470 lines against actual counts of 680 and 532. A state file that
misreports its own commit identity is the failure this loop exists to catch, so the record was
corrected in a second commit rather than left standing. The correction changes this section and the
two line counts above; no script byte changed between the two commits. Amending `a232971` would have
kept the single-commit shape, and was rejected: another session is committing into this same checkout,
so rewriting the tip risked rewriting their work.

Limitations, disclosed:

1. No live end-to-end carry through a real Claude process. The brief forbids a nested live model run
   from inside this hop, so live transport for the NEW surface is unproven. The recorder-binary argv
   proof is not a substitute for it.
2. No headless session-identity init (the spike's `init_session_identity` / exit 32). Not needed
   here — `.claude/settings.json` in this checkout registers no staging-tripwire hook — but a
   checkout that does register one would need it before an actor is launched.
3. Teardown terminates the actor's process group (TERM, grace, KILL, settle) and warns if the group
   cannot be confirmed gone. It does not run the spike's three-handle descendant census, which is
   unattended-grade machinery.
4. No retry-once on actor failure, no whole-run `--deadline`, no `--status`. Deliberate: one
   invocation is one hop, watched by the operator.
5. The transition table's reject branch is unreachable while `turn:` is constrained to three values
   and the unchanged-turn guard runs first. Kept as defence in depth and documented as such in the
   code; the mutation proof has to disable both guards to move a bad transition.

Deferrals recorded, not done: (a) no README for the new surface — `--help` prints the full header
including the exit-code table, so a second document could only drift from it; (b) `shellcheck` is
absent on this machine, so adding it to the check set is a separate question.

Repository observation, outside this unit's scope: a second Claude session
(`5b741fa7-84bd-4bac-ab47-2ec56d16184f`) was writing into this same checkout during this unit. It
committed `e0fb010` at 11:41 and its hook appended to `logs/friction-log.md` at 11:41 and 11:50.
This unit's own boundary held, and the commit below uses an explicit pathspec so nothing of that
session's can be swept in — but two writers in one checkout is the concurrency hazard the loop
assumes away, and it is Codex's to weigh.

## Blocker

None.

## Next action

Codex: assess the attended-only surface against the required outcome and the attended release
boundary. In particular — is the interface small enough, is the one-hop fail-closed behaviour
sufficient, and is limitation 1 (no live end-to-end carry of the new surface) acceptable for today's
release, or does it need its own unit before Harness v0.2 counts as deployed?
