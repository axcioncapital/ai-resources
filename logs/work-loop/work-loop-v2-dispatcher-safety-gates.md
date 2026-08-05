---
task: work-loop-v2-dispatcher-safety-gates
turn: codex
---

## Objective and scope

Close the remaining single-task, single-checkout safety proof gates for the throwaway Work Loop handoff dispatcher before any parallel-worktree or production design begins. Prove that unattended transport stops safely on permission denial, crash/partial state, hazardous repository state, and a genuine operator-owned decision; correct only dispatcher defects that these proofs expose.

Codex framing decision: scope is limited to the existing spike under `plans/work-loop-v2-v0.2/handoff-automation-spike/`, controlled fixture state files under `logs/work-loop/` when the live entrypoints require that canonical location, this task-state file, and unavoidable existing hook telemetry explicitly identified in evidence. Excluded: edits to live Work Loop skills/commands/core/proposal, the investigation report, `.claude` or `.codex` hooks/settings, state-schema changes, product installation or authentication, permission widening, reciprocal Stop hooks, daemon/service work, multi-task or multi-worktree operation, production deployment, merge/landing work, push, and destructive recovery.

## Lane and unit

Standard. Unit 1 — prove and, only where the proof exposes a defect, harden the remaining single-checkout safety gates.

Named reason for the loop: the work exercises process termination, permissions, partial repository state, and operator-stop boundaries; its scope must be contained, and the builder's evidence needs independent Codex assessment before it can unlock the parallel spike.

Plan justification: the closed `work-loop-v2-handoff-dispatcher` task proved the basic transport seam but explicitly retained partial crash recovery, unproven unattended risk stops, and no production authorization. The investigation's implementation boundary requires the single-task proof gates before a worktree-parallel experiment. The operator's “ok” authorizes this next task and continues the previously stated narrow override allowing Work Loop v2 to govern its automation build; all other role and safety constraints remain in force.

## Brief

The first spike proved that routine turns can move without babysitting; this unit determines whether the same controller fails safely when the happy path breaks. It is the smallest justified next task because parallelizing an incompletely bounded failure mode would multiply risk across worktrees. Success authorizes only the separate worktree spike, not production installation.

### Required outcome

Extend the focused proof surface, and minimally correct the throwaway dispatcher only where needed, so evidence establishes all four clusters below for one exact task and checkout:

1. **Permission and approval stop:** an unattended actor encountering a tool or approval it is not authorized to perform must terminate or hand back visibly within a bounded time; it must not hang indefinitely, inherit an accidental silent approval as proof, or cause the dispatcher to widen permissions. The evidence must distinguish the repository's pre-existing Claude `defaultMode: bypassPermissions` from the controller's own behavior and include a controlled denial path without authoring or using a dangerous bypass.
2. **Crash and restart safety:** a crash before edits can be retried once from repository truth; a crash after an expected uncommitted Codex handoff remains distinguishable from a Claude partial handback; a malformed/partial state or an uncommitted `turn: codex|operator` stops for inspection; restart derives the next action from the state file and Git rather than stale controller memory; duplicate completion does not relaunch.
3. **Repository-state safety:** foreign staged or unstaged work, Git lock contention, and an in-progress merge or rebase are detected before an actor can compound them, while the expected uncommitted Codex state-file handoff remains allowed. Any condition that cannot be classified safely must stop with the exact task, condition, and recoverable next action.
4. **Operator boundary:** a controlled Work Loop fixture reaches `turn: operator` because of a core § 7-style operator-owned question—not merely normal closure—and the dispatcher performs zero further actor launches. The output must preserve the question and make clear that neither model nor controller answered it.

Mechanism choices remain Claude's within the isolated spike. Do not turn a test helper, transcript parse, product session id, or additional repository file into a second semantic state system.

### Governing and supporting sources

- **Current operator decision — governing:** “ok,” in response to opening this safety-gates task.
- **Authoritative current state:** `logs/work-loop/work-loop-v2-handoff-dispatcher.md`, closed at `turn: operator`; its outcome, decisions, evidence, and accepted limitations define what is proven and what remains.
- **Prepared non-governing architecture and proof checklist:** `plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md`, especially proof gates 7, 9, 10, and 11 plus the implementation decision boundary.
- **Current spike behavior and disclosed limitations:** `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`, `dispatch.sh`, `dispatch.test.sh`, and the prior run records. These are repository reality to verify, not authority to preserve a defect.
- **Applicable deployed contract:** `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, especially § 6 and § 7. Its draft header caveat remains; both live entrypoints nevertheless designate it as their runtime contract.
- **Concurrency authority:** `docs/parallel-sessions-playbook.md`. This task stays serial and in one checkout.

Material item held outside the unit: the worktree-per-task proof is deliberately deferred until these single-checkout failures stop safely. Material reclassification: the prior spike's accepted limitations are now verification targets, not governing requirements or permission to redesign the workflow.

### Check against the repository before acting

1. **Verify-first claim:** `logs/work-loop/work-loop-v2-handoff-dispatcher.md` is a valid closed record at `turn: operator` and names partial crash recovery, no genuine risk-stop exercise, and no production or parallel authorization. Inspect that file and each cited limitation.
2. **Verify-first claim:** commit/evidence pointer `edbfbd2` and the existing spike directory contain the controller, harness, process sampler, and run records described by the closing record. Inspect the paths and re-derive the current harness result before changing them.
3. **Verify-first claim:** the current dispatcher already distinguishes the expected uncommitted `turn: claude` Codex handoff from an uncommitted Claude `turn: codex|operator` handback. Inspect `dispatch.sh` and the focused cases in `dispatch.test.sh`; do not rely on the README statement alone.
4. **Verify-first absence claim:** the existing harness has not already demonstrated all required permission-denial, pre-edit crash/retry, malformed partial-state restart, foreign unstaged work, Git lock, merge/rebase, duplicate completion, and genuine core § 7 operator-stop cases. Search `dispatch.test.sh` and `runs/` for each named behavior and record exactly which surfaces/patterns were searched and which cases exist.
5. **Verify-first claim:** `.claude/settings.json` currently supplies `defaultMode: bypassPermissions`, while `dispatch.sh` adds no dangerous permission flag. Inspect both exact settings/launch surfaces and separate inherited environment policy from dispatcher policy in the result.
6. **Verify-first absence claim:** current `.claude`/`.codex` Stop hooks contain no dispatcher enrolment or child-agent launch. Re-check the configured Stop handlers and their referenced scripts for `work-loop`, `dispatch`, `codex exec`, and `claude -p`; bound the claim to those files and patterns.
7. **Unknown to establish:** the remaining scenarios can be exercised without editing settings, widening permissions, installing/authenticating a product, destructive cleanup, or touching an excluded live resource. If not, stop with the exact blocked proof rather than manufacturing a simulated green substitute.

### Required evidence

- For each behavior added or corrected, show a constructed failing case against the pre-change dispatcher or harness and the corresponding passing result after the minimal change. A test that passes with the relevant guard disabled is not evidence.
- Report the complete focused harness command, exit status, and pass/fail count, plus per-case evidence for the four clusters. Separate simulated controller tests from live product evidence.
- Permission evidence must show the exact actor invocation/policy, the denied or unavailable action, elapsed time, process result, dispatcher result, and that no settings or permission surface changed.
- Crash evidence must cover before-edit retry, expected uncommitted Codex handoff, partial Claude handback, malformed/partial state, restart from disk/Git, and duplicate-event idempotency; name before/after hashes, turns, HEAD, and launch count.
- Repository-state evidence must construct foreign unstaged and staged work, a Git lock, and merge/rebase markers in isolated fixtures; prove zero actor launches in every unsafe case and prove the expected Codex handoff still launches.
- Operator-boundary evidence must use a controlled core § 7-style question, show `turn: operator`, preserve the question in the state file, and show zero subsequent launches.
- Identify every changed path and show the excluded live resources, hooks/settings, core/proposal, investigation report, and closed prior task remained unchanged. Claude commits only in-scope paths by explicit pathspec.

### Completion and stop conditions

Completion: the four safety clusters are demonstrated with falsifiable evidence, any exposed dispatcher defect is minimally corrected and regression-covered, the existing basic transport behavior still passes, this state file carries the latest inspection/result/evidence, `turn:` is `codex`, and Claude commits every in-scope artifact by explicit pathspec.

Stop and hand back to Codex if a verify-first claim is false, if an essential scenario cannot be demonstrated safely, if the required evidence cannot fail, or if the change would touch an excluded live resource. Stop for the operator if proof requires changing authentication, settings, installed products, permission policy, accepting risk, destructive cleanup, parallel execution, or a scope/architecture decision beyond this brief. Challenge false premises explicitly; do not improvise around them.

## Latest result

Inspected (2026-08-05):

- Claim (1): HOLDS — read `logs/work-loop/work-loop-v2-handoff-dispatcher.md` in full; frontmatter is
  `task: work-loop-v2-handoff-dispatcher` / `turn: operator` and the body carries exactly § 4's four
  closing headings. Its `## Accepted limitations` names "Crash recovery is only partially proven",
  "No unattended genuine core § 7 risk decision was exercised … `turn: operator` was reached by a
  normal close, never by a risk stop", "Single task and single checkout only", and "No hook-driven,
  daemon-driven, or production deployment behaviour exists".
- Claim (2): HOLDS — `git show --stat edbfbd2` lists `dispatch.sh`, `dispatch.test.sh`,
  `ps-sampler.sh` and 13 `runs/` records; all four paths exist on disk now. Harness re-derived:
  `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` → exit 0,
  `pass=34 fail=0`.
- Claim (3): HOLDS — read `dispatch.sh:236-246` (`state_dirty()` and its asymmetry comment),
  `:348-355` (startup branch: `turn: claude` uncommitted → note and proceed; `turn: codex|operator`
  uncommitted → exit 25) and `:425-427` (post-Claude-hop uncommitted → exit 25). Exercised by
  `dispatch.test.sh` cases 13, 13b — both sides, not the README's word alone.
- Claim (4): HOLDS (absence) — searched `dispatch.test.sh` case-insensitively for `permission`,
  `denial`, `retry`, `index.lock`, `MERGE_HEAD`, `rebase`, `unstaged`, `duplicate`, `idempot`,
  `operator-owned`, `question`: **0 matches each**. Searched `runs/` for `denied`, `index.lock`,
  `MERGE_HEAD`, `rebase`, `unstaged`, `duplicate`: no files. (`permission` and `operator-owned` hit
  `runs/` only inside transcript prose, not as exercised behaviour.) What the harness *does* already
  cover, by reading every case: 4 (missing state, out-of-domain `turn:`), 5 (`turn: operator`
  terminal, zero launches), 9 (foreign **staged** work, pre-launch), 10 (out-of-allowlist write and
  Codex moving HEAD, **during** a hop), 12 (dispatcher's own lock dir — not a Git lock), 13/13b
  (uncommitted handback, partial-state restart, expected Codex handoff).
- Claim (5): HOLDS — `.claude/settings.json:30` is `"defaultMode": "bypassPermissions"`. Searched
  `dispatch.sh` for `dangerously|skip-permissions|--sandbox|bypassPermissions|--permission-mode|
  --allowedTools`: the only hits are the Claude comment at `:329-331` and the Codex launch's
  `--sandbox workspace-write` (`:318-320`), which **restricts** rather than widens. The Claude launch
  (`:333-334`) passes no permission flag at all.
- Claim (6): HOLDS (absence) — enumerated every registered `Stop`/`SubagentStop` handler by parsing
  `.claude/settings.json`, `.claude/settings.local.json`, workspace `../.claude/settings.json`,
  `~/.claude/settings.json` and `.codex/hooks.json`. Six referenced scripts exist
  (`check-stop-reminders.sh`, `coach-reminder.sh`, `improve-reminder.sh` under both `.claude/hooks/`
  and `.codex/hooks/`); the user-level `Stop` is `afplay` only; workspace has `SubagentStop` →
  `subagent-stop.sh`. Searched all of those script bodies for `work-loop`, `dispatch`, `codex exec`,
  `claude -p`: **0 matches**. No dispatcher enrolment and no child-agent launch.
- Claim (7) — unknown to establish: RESOLVED IN THE AFFIRMATIVE for all four clusters. Nothing had to
  be blocked and nothing was simulated as a green substitute. No settings file was edited, no
  permission was widened, no product was installed or authenticated, no destructive cleanup ran, and
  no excluded live resource was touched. The one boundary that had to be split is cluster 1: the
  product's own denial behaviour cannot be established by a controller test, so it was measured live
  in throwaway sandboxes **outside** this repository (see Evidence).

Reproduced (correction round, 2026-08-05):

- Frozen finding (1): REPRODUCES — searched `runs/live-permission-denial-2026-08-05.md` for the
  composition claim; line 106 of the pre-correction file said in its own words that "Neither run went
  through `dispatch.sh`". Searched `runs/*.log` for `mode=live`: two live runs existed, both from the
  prior transport task, neither a denial proof. Parsed every `runs/*.claude.out` for
  `permission_denials`: two prior hops did carry incidental denials, but they were unrecorded
  side-effects of ordinary work, not a controlled denial path. The finding was correct as stated.

Result: All four safety clusters are demonstrated, the proofs exposed **four real dispatcher
defects** — each minimally corrected and regression-covered — and the correction round closed the one
composition gap Codex named.

- **Cluster 1 — permission and approval stop: PROVEN end-to-end, including through the dispatcher.**
  The correction round ran a live Claude actor **launched by `dispatch.sh`** in a throwaway sandbox
  checkout whose own narrowing policy denied `Bash(git:*)` — the exact authority core § 4 depends on.
  The child attempted `git add … && git commit …`, was denied at runtime, **refused to retry the
  command in another form**, and exited on its own in 28 s. The dispatcher stopped at
  `25 UNCOMMITTED_HANDBACK` with one actor launch and zero subsequent launches, `HEAD` unmoved, and
  both the sandbox policy file and this repository's `.claude/settings.json` byte-identical
  afterwards. Two runs, identical post-run state hash. Product-alone behaviour (Runs A and B) still
  stands: a refused actor does **not** hang, terminating in 10 s and 14 s.
  **Named finding, corrected by measurement:** a denied actor exits **0**, so a denial never arrives
  as `20 ACTOR_FAILED`. My pre-correction draft said it arrives as `22 NO_TRANSITION`; the live run
  showed that is only the case when the actor changed nothing. When it edits the state file and is
  then refused the commit, it arrives as **`25`**. Both codes are now documented, and neither *names*
  denial — so the `25` message was corrected to say a refused git permission looks exactly like this
  and to point at the hop capture, where `permission_denials` records it precisely. **No new exit
  code was added**, per the finding's instruction not to add one for taxonomy.
- **Cluster 2 — crash and restart safety: PROVEN, one defect corrected.** Defect: no retry existed at
  all, so a crash that changed nothing still ended the run. Correction: exactly one retry, gated on
  the repository being *provably* unchanged — state-file `sha256`, `HEAD`, foreign working tree and
  the state file's committed-ness all identical. Any doubt is treated as a partial effect and stops
  (case 15b). The first attempt's output is preserved as a separate `.hop1r.` capture rather than
  truncated by the retry. The pre-existing halves — expected uncommitted Codex handoff vs. Claude
  partial handback, malformed state, restart from disk, duplicate completion — were re-derived, not
  assumed (cases 4, 5, 13, 13b, 19).
- **Cluster 3 — repository-state safety: PROVEN, three defects corrected.** Defect A: pre-existing
  foreign **unstaged** work passed straight through, because the only allowlist check was a
  before/after *delta* and both snapshots contained it. Defect B: a held Git `index.lock` was not
  detected. Defect C: an in-progress merge, rebase, cherry-pick or revert was not detected. All three
  are now pre-hop gates (`18`, `19`) checked before *every* hop, so a restart re-enters them; each
  stop names the exact task, the condition and a recoverable next action. The expected uncommitted
  Codex handoff still launches (case 16, third block) — the state file is inside the allowlist and is
  therefore never foreign work.
- **Cluster 4 — operator boundary: PROVEN, one defect corrected.** Defect: `turn: operator` printed a
  one-line stop and swallowed the question entirely. Correction: the dispatcher now prints the
  `## Blocker` and `## Next action` sections read-only, under an explicit statement that the question
  is UNANSWERED and that neither model nor the controller answered it. Case 20 reaches `turn:
  operator` by a genuine core § 7 question rather than a normal close, and asserts the question
  survives in the file, appears in the output, and is followed by zero further launches.

A fifth, smaller correction was forced by the work rather than chosen: `--help` printed a fixed line
window (`sed -n '2,45p'`) and would have silently truncated the two new exit codes. It now prints the
whole leading comment block whatever length it grows to. This closes one of the two defects the prior
task deferred as cosmetic; the other (the line-31 wording contradiction) is untouched and still open.

One correction was needed to keep the new gate honest rather than merely quiet: the dispatcher's own
`--log-dir`, when it sits inside the checkout, is now added to the allowlist. Without it the
controller would have flagged its own run log as foreign work — a guard failing on itself.

Evidence:

- **Red-to-green, same harness, both directions.** Against the pre-change controller extracted from
  `HEAD` (`git show HEAD:…/dispatch.sh`): `DISPATCH_BIN=<pre> bash dispatch.test.sh` → **exit 1,
  `pass=49 fail=20`**. Against the corrected controller: `bash dispatch.test.sh` → **exit 0,
  `pass=69 fail=0`** (was `pass=34 fail=0`). The 20 named failures are listed in the run capture and
  map one-to-one onto the four corrections. Case 0 still points the suite at an absent dispatcher and
  asserts it fails, so a green run means something.
- **Nothing previously green went red.** The harness was re-run after the correction round's message
  change: `bash dispatch.test.sh` → **exit 0, `pass=69 fail=0`**, unchanged. The basic-transport
  cases (1, 11, 13b's Codex-handoff block) are inside that count. The correction touched one `die`
  message string and no control flow.
- **The evidence can fail, and 20 assertions were observed failing.** Two of the new assertions
  (case 14's timeout bound, case 19's duplicate-completion check) passed against the *pre-change*
  controller too. That is stated rather than hidden: those two document behaviour that already
  existed and were added for coverage, not as proof of a correction.
- **Live product evidence, kept separate from the simulated suite:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/live-permission-denial-2026-08-05.md` —
  binary `claude 2.1.220`, exact invocations, the denied action, elapsed time, process exit,
  `permission_denials`, the dispatcher-visible consequence, and `sha256` before/after for both the
  sandbox policy file and this repository's `.claude/settings.json`. All runs ran in `TMPDIR`
  sandboxes outside this repository, under narrowing `deny` rules only. No
  `--dangerously-skip-permissions` was authored or used.
- **The correction round's denial-through-dispatcher run — every field the finding asked for**, in
  that file's Run C table: checkout, task, policy, binary and version, denied action, elapsed
  (child 27.6 s / wall 30 s), child result (`exit 0`, `subtype: success`, 5 turns), dispatcher exit
  (`25`), state `sha256` `d8863584…` → `83958616…`, `turn:` `claude` → `codex`, `HEAD` unmoved,
  **1 actor launch and zero subsequent**, and byte-identical settings on both surfaces. The run was
  driven by a scripted fixture kept out of the repository
  (session scratchpad, `live-denial-through-dispatcher.sh`), so no fixture code entered `plans/`.
  It used `--max-hops 1`, so no Codex actor could launch even in the branch where the child commits.
- **The correction changed one message and nothing else in behaviour.** The exit-`25` stop now names
  a recoverable next action (read the diff, check the hop capture for a denial, commit-and-re-run or
  discard-and-re-run) instead of saying only "stopping for inspection". Run C-1 and C-2 straddle that
  change and are both recorded, so the correction's effect is visible rather than asserted.
- **Simulated vs. live is marked at the source.** Every harness case runs through `--actor-cmd`,
  which forces `mode=simulated` into all run evidence; the suite's own summary line says so. The live
  file above is the only live evidence and says so in its first paragraph.
- **`--dry-run` against this real checkout** (read-only, log written outside the repo) reported the
  new gate working and surfaced a real operational consequence: `logs/friction-log.md` is modified
  continuously by a PostToolUse hook, so gate `18` will stop any live run here unless the allowlist
  covers it — and because supplying any `--allow-path` replaces both defaults, a live run needs all
  three patterns. Documented in the README with the exact invocation.
- **Changed paths — the complete set, all in scope:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `…/dispatch.test.sh`,
  `…/README.md`, `…/runs/live-permission-denial-2026-08-05.md`, and this state file.
- **Excluded resources verified unchanged** by `git status --short` over the whole repo: the core
  (`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`), the proposal, the investigation
  report, `.claude/` and `.codex/` hooks and settings, and the closed prior task record
  (`logs/work-loop/work-loop-v2-handoff-dispatcher.md`) are all absent from the modified list. No
  state-schema change, no installation, no authentication, no permission widening, no push.
- **`logs/friction-log.md` is modified and is deliberately NOT committed by this unit.** It is
  pre-existing hook telemetry, not this unit's work product. Identifying it here is the disclosure
  the brief's scope note requires.

Deferrals — recorded, not done:

- **The line-31 header contradiction in `dispatch.sh`** ("0 is the ONLY success") still disagrees with
  the lines-48/49 note. Not corrected: no proof in this unit exposed it, and the README already
  documents it. Correcting it was not needed to add the new codes.
- **Codex-side denial behaviour was not measured.** Only the Claude actor was exercised live. The
  correction's scope note excluded it explicitly.
- **Run C used a fixture `/work-loop-v2` command, not the real one.** A four-step stand-in, so the
  sandbox never became a partial copy of this repository. It proves the transport and the denial, not
  that the real command behaves identically under denial. Newly noticed during the correction and
  recorded rather than acted on.
- **Only one denied authority was exercised through the dispatcher** — `git` via Bash. A denied file
  write, or a denied `Read` of the state file itself, would land on different codes and were not
  measured. Newly noticed during the correction and recorded rather than acted on.
- **Retry breadth.** Exactly one retry, and only for a provably-unchanged repository. No backoff, no
  retry on timeout (a timeout is not a pre-edit crash and a retry would just burn a second deadline).
- **The worktree-per-task proof** remains held outside the unit, as the brief states.

## Blocker

None.

## Next action

Codex: run the closure check on frozen finding 1 only.

1. **Resolved.** A controlled live Claude permission denial was carried through `dispatch.sh` itself,
   twice, and every field the finding listed is recorded in Run C of
   `…/runs/live-permission-denial-2026-08-05.md`. The denial stayed visible (the child's own
   `permission_denials` entry names the exact refused command) and the dispatcher stopped with a
   recoverable next action. No distinct exit code was added.

Two things you should weigh rather than take as given:

- The finding anticipated exit `22`; the measured code was **`25`**, because the denial bit *after*
  the actor edited the state file. I treated the acceptance condition as being about visibility and
  recoverability rather than about the specific number, and corrected the `25` message to carry a
  recoverable next action instead of "stopping for inspection". If you intended the `22` path
  specifically, that one is still only covered simulated, by case 6.
- That message correction is the **only** behaviour change in this round. It was not in the finding's
  literal text; I judged it inside the finding's own acceptance condition ("stops with a recoverable
  next action"). Say so if you read that as broadening.

Nothing previously green went red: `bash dispatch.test.sh` → exit 0, `pass=69 fail=0`, unchanged
before and after the correction. Two candidate deferrals were newly noticed and recorded, not
implemented: Run C used a fixture command rather than the real one, and only one denied authority
(`git` via Bash) was exercised end-to-end.

Do not begin the worktree or production task.
