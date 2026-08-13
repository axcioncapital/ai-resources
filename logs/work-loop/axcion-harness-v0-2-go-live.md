---
task: axcion-harness-v0-2-go-live
turn: codex
---

## Objective and scope

Make Axcíon Harness v0.2 the normal, usable attended Work Loop courier as quickly as safely possible,
then collect only the real-use evidence needed for an explicit adopt, revise, continue-trial or stop
decision. Scope is the canonical `ai-resources` operating surface and the minimum attended adoption
trial. Unattended execution, automatic multi-hop operation, worktree automation, May-harness archival
cleanup, unrelated Phase 0 cleanup, remote publication, and new orchestration machinery are excluded.

## Lane and unit

Named reason for the loop: changing the live cross-actor routing instructions is a semantic operating
change that must be verified by someone other than its implementer before it becomes normal practice,
and the adoption decision must distinguish a usable attended pilot from a final Phase 3 claim.

Standard. Adoption mode. Unit 2 — decide whether the canonical carrier should enter normal attended
pilot use now, with its limitations explicit and the wider Phase 3 trial still open.

## Latest result

Unit 1 was accepted by Codex and its route change is committed at `828a73d`. What follows is Unit 2 —
an Adoption-mode discovery unit. Nothing outside this state file was changed or committed.

Inspected (2026-08-13). The brief pre-stated no separate claims block, so the inspection record is
this unit's own findings, each with the surface it was read from.

- **Real fresh-process operation — one carry, and it was clean.** `logs/work-loop/axcion-harness-v0-2-live-trial.md`
  (closed, `turn: operator`) records the canonical carrier launching one fresh authenticated Claude
  process, that process reconstructing its unit from the state file and durable sources with no
  transcript ferried in, a state-file-only change under `--permission-mode default`, one valid
  `claude -> codex` handback, and the carrier accepting the transition, exiting **`code=0`** and
  emitting one terminal result. Read at the source commit as well: `git show 3c7e3a2:logs/work-loop/axcion-harness-v0-2-live-trial.md`
  carries the six-claim record, including the child's own `ps -ww` argv
  (`claude -p /work-loop-v2 … --output-format json --permission-mode default`) with
  `dangerously-skip-permissions`, `bypassPermissions`, `acceptEdits`, `--unattended`, `--headless`
  and `--no-interactive` all scanned for and absent. All three cited commits resolve: `a232971`,
  `bdfe91f`, `3c7e3a2`.
- **Operator burden in that carry: one action.** Claim (6) of the Unit 5 record reads "the operator
  performed exactly one action — the single foreground launch. No further intervention, prompt,
  warning, ambiguity, timeout or actor failure." That is the strongest single datum for usefulness,
  and it is a direct observation from inside the child, not a summary.
- **Deterministic reliability — cited, not rerun, as the brief directs.** `logs/work-loop/axcion-harness-v0-2-attended-release.md`
  line 98 records **98/0 green with five fail-capability mutants**, explicit default permission mode,
  exact binding and transition guards, and mechanical refusal of unattended and multi-hop requests.
  The suite header at `scripts/axcion-harness-v0.2/carry-turn.test.sh:1-20` confirms the property that
  makes the number worth citing: every case is hermetic under `$TMPDIR`, there is no simulated-actor
  seam, so the launcher builds and executes its **real** argv on every case, and `--prove-failure`
  mutates a copy one invariant at a time and requires the matching assertions to fail.
- **Known failure behavior is enumerated and fail-closed.** `scripts/axcion-harness-v0.2/carry-turn.sh:48-82`
  lists 13 named stop codes; the guards at `:574-587` run before launch, so `19` (git hazard),
  `16` (foreign staged) and `18` (out-of-allowlist dirt) refuse **before any actor starts**. There is
  no retry (`:74-77`), every terminal path prints one `RESULT` line, and the header states that
  neither that line nor the exit code is authoritative over the state file.
- **The gap that matters, and it is a configuration gap rather than a defect.** The one successful
  live carry ran in an operator-prepared isolated checkout
  (`/Users/patrik.lindeberg/Claude Code/axcion-harness-v0.2-live-trial`, branch
  `harness-v0.2-live-trial`) with `--log-dir /private/tmp/axcion-harness-v0.2-isolated-trial` — the run
  log outside the repository. The proposed pilot is the canonical `ai-resources` checkout with the
  in-repo default log dir. The one attempt in **this** checkout stopped at `18` on unrelated dirty
  paths and never launched (`logs/work-loop/axcion-harness-v0-2-attended-release.md:107-113`). So the
  pilot configuration is proven by design and by dry run, not yet by a live carry.
- **That gap was dry-run tested here today.** `--dry-run` in this checkout with only
  `^logs/work-loop/` reported `logs/friction-log.md` and `logs/harness-runs/` as changes a live carry
  would stop on; the same dry-run with Unit 1's four-line allow-path reported none. Being wrong about
  this costs one refused launch — nothing starts and nothing changes — which is the cheapest failure
  the carrier has.
- **One new finding, not in Unit 1's deferrals.** A second ambient writer will reproduce that stop on
  a common unit class. `~/.claude/settings.json:103,114` registers `.claude/hooks/detect-innovation.sh`
  as a user-level `PostToolUse` hook; the hook appends to the tracked file `logs/innovation-registry.md`
  when the edited path matches `.claude/commands/<file>`, `.claude/agents/<file>` or
  `.claude/hooks/<file>` (`detect-innovation.sh:11,19-23`). `^logs/innovation-registry\.md$` is **not**
  in the allow-path set Unit 1 documented, so the first pilot unit that edits a command, agent or hook
  file will stop at `18`. Already logged as pending, severity medium-high, at
  `logs/improvement-log.md:3364-3392`. The fix is one documented allow-path line and no code change.
- **A second burden source, intermittent.** `logs/friction-log.md:3829` records
  `check-foreign-staging.sh` blocking a direct-route `/work-loop-v2` commit three times in one session
  against stale session markers. Two stale markers sit in `logs/` right now (`.session-marker` dated
  Aug 11, `.session-marker-609569ff…` dated Aug 9), yet Unit 1's commit today passed the guard
  untouched — so the block is intermittent, not certain. Under the carrier a refused child commit
  surfaces as exit `25` (uncommitted handback): visible, safe, and costing one re-run.
- **Open carrier items: two, neither corrupting.** `logs/improvement-log.md:3395-3420` — the SIGINT
  path exits before logging a post-stop hash (severity low; costs forensic effort, recoverable from
  other evidence). Plus the innovation-registry item above. Searched `logs/improvement-log.md` and
  `logs/defect-log.md` for `carry-turn` and `harness v0.2`: no entry describes a path that can corrupt
  a normal single-checkout attended task.

**Lifecycle recommendation: ADOPT FOR NORMAL ATTENDED PILOT USE.**

*Value and risk ground.* The capability is implemented, hermetically tested with mutants that prove
the suite can fail, proven once end-to-end in a real fresh-process carry that cost the operator one
action and produced zero prompts, and — since `828a73d` — actually selected by the live instructions.
The single untested element of the pilot configuration is the allow-path policy in this checkout, and
its failure mode is a pre-launch refusal that changes nothing. Withholding release to remove that one
uncertainty would buy a cheap, self-diagnosing failure at the cost of the operator's stated priority.
The alternative recommendations were rejected on the evidence: *revise before pilot use* would hold
the release for a one-line allow-path addition whose absence produces a stop message that names its
own remedy; *continue the pre-pilot trial* would gather the remaining evidence without the harness
being usable, when the remaining evidence is precisely what normal use produces; *stop* is
contradicted by every reliability and operation datum above.

*This is a release decision, not the adoption decision.* `plans/axcion-harness-v0.2/mvp-plan.md:373-379`
and its Phase 3 exit at `:441-454` set the final bar: three to five representative tasks — a Direct
bypass, a bounded documentation or policy change, a small code change with tests, a false-or-stale-premise
task, and an interrupted or operator-stopped task — showing correct work sooner, with less manual
transport and no loss of control, before an adopt/shrink/stop verdict. One task of that set exists.
The Phase 3 deliverable "promotion of only the proven minimum out of the spike location into a
canonical `ai-resources` home" is already met by `scripts/axcion-harness-v0.2/`.

*Operational boundary — what this recommendation does not authorize.* Not unattended execution
(the carrier refuses `--unattended` outright; unattended remains the spike dispatcher's separate,
un-released path and Phase 4's separate gate). Not concurrent or multi-writer use. Not cross-worktree
task claims. Not automatic worktree creation, automatic landing or merge, and not `git push`. Not
multi-hop or automatic hop chaining — one invocation carries one hop, and the operator reads the file
between hops. Not final Phase 3 adopted status. None of these may inherit this acceptance.

**Disposition of Unit 1's three deferrals.**

1. *Untracked `logs/harness-runs/` accumulation* — **accepted pilot limitation, does not block.** It
   is inside the documented allow-path, so it causes no stop; it grows one log per carry as untracked
   noise. Revisit before final adoption: either gitignore it, or adopt the live trial's own pattern of
   pointing `--log-dir` outside the repository.
2. *No carrier-level cross-worktree ownership check* — **accepted pilot limitation, as the operator
   ruled, and it binds the boundary.** Verified by inspection: `work-loop-owner` appears 0 times in
   `carry-turn.sh` and 5 times in the spike dispatcher. Enforcement in the pilot rests on interactive
   Codex claiming the local checkout and Claude's `--depth repo` check at Step 1.5. **Must be closed
   before any concurrent, multi-worktree or unattended use** — this acceptance covers single-checkout,
   single-writer attended operation and nothing wider.
3. *No permanent route-selection regression check* — **accepted pilot limitation, does not block.**
   The route is one instruction string; a regression sends an attended carry to the spike dispatcher,
   which is visible in the command the operator runs and non-corrupting. Revisit before final adoption,
   or sooner if the courier section is edited again.

**Smallest next action.** Add `^logs/innovation-registry\.md$` as a fourth fixed `--allow-path` in the
attended command documented in `.agents/skills/work-loop-v2/SKILL.md` § *Courier mode* — one line, no
code change, closing a known and already-logged stop on the common unit class that edits
`.claude/commands`, `.claude/agents` or `.claude/hooks`. Not done in this unit: the brief scopes it to
inspection and permits no edit outside this state file.

## Blocker

None.

## Next action

Codex: assess Unit 2 against its completion condition. The unit returns one lifecycle recommendation
— **adopt for normal attended pilot use** — with its value/risk ground, the operational boundary, a
disposition for all three of Unit 1's deferrals, and the smallest next action. Rule on the
recommendation, on the one new finding (the `logs/innovation-registry.md` ambient writer, which the
unit did not fix because its scope forbade any edit outside this state file), and on whether the
smallest next action belongs to this task as Unit 3 or is handed to the operator. Then close,
continue, correct once, or stop.

---

Brief for Unit 2 (superseded by the result above; kept for the assessment):

Why this unit, why now: the attended carrier is implemented, deterministically tested, proven once in
a real fresh-process handoff, and now selected by the live Work Loop instructions. The remaining
question for getting it live today is a lifecycle decision about normal attended pilot use, not more
implementation; final Phase 3 adoption still requires the broader real-task set in the governing
plan.

**Named unknown.** Does the existing repository evidence support putting Harness v0.2 into normal
attended pilot operation now, while explicitly withholding final Phase 3 adoption and every
unattended/concurrent claim?

**Required outcome.** Inspect the authoritative current evidence and return exactly one lifecycle
recommendation: **adopt for normal attended pilot use**, **revise before pilot use**, **continue the
pre-pilot trial**, or **stop**. The result must distinguish today's operational release decision from
the later Phase 3 adopt/shrink/stop decision after three to five representative tasks.

**Authority and evidence boundary.** The operator's current priority is to get the harness live ASAP
and their explicit operating choice is one checkout without a separate worktree. The product boundary
comes from `plans/axcion-harness-v0.2/mvp-plan.md`; its three-to-five-task condition remains the bar for
final Phase 3 adoption, not a reason to keep a proven attended carrier unavailable during the trial.
Use `logs/work-loop/axcion-harness-v0-2-live-trial.md`, the accepted Unit 1 result preserved above,
the current carrier header/usage contract, and only directly relevant incident or friction evidence.
Do not treat the stale planning headers as current implementation state.

**What to assess.** Cover actual fresh-process operation, deterministic reliability evidence,
operator burden, known failure behavior, and usefulness. Explicitly rule on Unit 1's three deferrals:
untracked `logs/harness-runs/` accumulation, absence of carrier-level cross-worktree ownership checks,
and absence of a permanent route-selection regression check. State which block attended pilot use,
which are accepted pilot limitations, and which must be revisited before final adoption or concurrent
use.

**Scope.** This is an Adoption-mode discovery unit: inspect and decide; change nothing except this
state file. Do not edit the carrier, skill, tests, plan, ignore rules, old harness, or remote state.
Do not run another model or manufacture a new trial. Codex's framing decision is to permit a
time-bounded operational pilot decision from the one accepted live trial plus deterministic evidence,
while preserving the governing plan's larger evidence bar for final adoption.

**Evidence required.** Cite the accepted live handoff result and its observed terminal outcome; cite
the deterministic and fail-capability results already recorded rather than rerunning them; identify
every manual/operator intervention in the live trial that bears on burden; and show that the proposed
lifecycle recommendation does not authorize unattended, concurrent, auto-worktree, auto-land, push,
or final Phase 3 status.

**Completion condition.** Return the explicit lifecycle recommendation with its value/risk ground,
the operational boundary, the disposition of all three deferrals, and the smallest next action. Set
`turn: codex`, commit only this state file, and stop for assessment.

**Stop conditions.** Stop if repository evidence contradicts the accepted live-trial outcome, if a
known defect can corrupt a normal single-checkout attended task, or if the evidence cannot support any
honest distinction between pilot release and final adoption. Challenge a false premise rather than
silently lowering the release boundary.
