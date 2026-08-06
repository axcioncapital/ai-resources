---
task: work-loop-v2-production-readiness-policy
turn: codex
---

## Objective and scope

Establish the smallest safe production operating policy for unattended multi-Work-Loop operation in
this repository, using the proven task-scoped dispatcher and one linked worktree per concurrent task.
Return an evidence-backed recommendation that the operator can approve or reject; do not implement,
install or deploy it in this unit.

Codex framing decision: this is a discovery unit because three load-bearing production questions are
not settled by the spike: the ambient `logs/friction-log.md` writer, dispatcher-launched sessions'
relationship to session footprints and the staging tripwire, and the exact worktree start/landing/
teardown policy. Repository writes are limited to this state file. Excluded: edits to hooks,
settings, commands, skills, dispatcher code, Work Loop core/schema, logs other than this state file,
worktrees or branches; live model launches; installations; permission changes; pushes; and production
activation.

## Lane and unit

Standard. Unit 1 — production-readiness policy discovery and operator decision preparation.

Named reason for the loop: the result will set cross-session operating policy and bound later
high-consequence hook/command work; the evidence needs independent Codex assessment before any
operator decision or implementation begins.

Plan justification: the single-checkout safety gates and two-worktree proof now support the transport
architecture, but the investigation's implementation boundary still requires operator approval of
the worktree/landing policy. This unit resolves the evidence needed for that approval and identifies
the smallest later implementation unit; it does not treat a successful sandbox as production
authorization.

## Brief

The transport and two-worktree composition have been demonstrated; the remaining uncertainty is how
to operate them safely in this repository without reintroducing shared-file collisions or relying on
guards that headless sessions do not initialize correctly. This unit converts those uncertainties
into one operator-ready policy recommendation before any production surface changes.

### Required outcome

Produce one concise recommendation, inside this state file, that specifies:

1. The minimum production shape: how an exact task is admitted, how its linked worktree and branch are
   created, how one dispatcher is started and supervised there, how `turn: operator` is surfaced, and
   how landing and teardown happen after all child processes exit.
2. A safe disposition for every shared writable path the actors or repository hooks can touch,
   especially `logs/friction-log.md`. The policy must preserve useful telemetry or explicitly state
   the value being traded away; simply allowlisting a co-edited tracked file is not a solution.
3. A session-identity and commit-safety policy for dispatcher-launched Claude processes that may not
   have run `/prime` or `/session-start`. It must address both stale-footprint false positives and the
   stage-and-commit-in-one-call timing blind spot without normalizing guard bypasses.
4. The concurrency and integration boundary: one task per worktree, file-ownership prerequisites,
   maximum supported fan-out claim, clean integration target, serial landing, content-conflict
   operator gate, integration QC and liveness-aware teardown.
5. The exact operator decisions still required, the recommended choice for each, the strongest
   alternative, and the value/risk tradeoff. Distinguish reduced operator attention—the stated
   objective—from wall-clock speed and token/compute cost.
6. The smallest ordered implementation units that would follow approval, with their owned paths,
   acceptance evidence, risk-aware review requirements and rollback boundary. Do not execute them.

Prefer the lowest-complexity policy that meets the objective. Reciprocal product Stop hooks and a
persistent daemon remain rejected unless verified evidence has materially overturned the existing
investigation; a filename, convenience or architectural taste is not such evidence.

### Governing and supporting sources

- **Current operator decision — governing:** “prepare next task,” continuing the original objective
  that routine Codex/Claude handoffs should not require babysitting, including when several Work
  Loops are active.
- **Authoritative current state — verify before relying on it:**
  `logs/work-loop/work-loop-v2-parallel-worktree-proof.md` must be a valid closed record at
  `turn: operator`. Its measured result, decisions, evidence and accepted limitations define what the
  policy may claim.
- **Applicable operating authority:** `docs/parallel-sessions-playbook.md`, especially the file-map,
  clean-target, serial-landing, integration-QC and teardown rules; `docs/autonomy-rules.md`, especially
  the structural-change class; `docs/commit-discipline.md`; and `docs/session-marker.md`.
- **Prepared, non-governing architecture:**
  `plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md`, especially the rejected
  reciprocal-hook/daemon options and implementation decision boundary. Carry it as a proposal unless
  a later operator-approved source grants it authority.
- **Verified-reality candidates, not authority:** the spike README and dispatcher; `.claude/settings.json`;
  `.claude/hooks/log-write-activity.sh`; `.claude/hooks/check-foreign-staging.sh` and its tests;
  `.claude/commands/new-worktree-session.md`; the corresponding close/cleanup commands; and the hook
  and command surfaces they reference.

Material items held outside this unit: approval of the recommended policy, every structural change,
and production activation. Material reclassification: the sandbox proof establishes that isolated
dispatcher instances compose; it does not establish that this repository's ambient writers and
session guards are compatible with that composition unchanged.

### Check against the repository before acting

1. **Verify-first claim:** `logs/work-loop/work-loop-v2-parallel-worktree-proof.md` has been reduced to
   the core § 4 closing record at `turn: operator` and records the final `pass=82 fail=0`, the live
   two-worktree evidence, the operator-authorized staging-tripwire override, and the production
   limitations. If it is still active or uncommitted, stop rather than treating chat as closure.
2. **Verify-first claim:** `.claude/hooks/log-write-activity.sh`, as registered in
   `.claude/settings.json`, mutates the checkout-local tracked `logs/friction-log.md` after Write/Edit
   operations, and the dispatcher currently treats that path as foreign unless explicitly
   allowlisted. Inspect the hook, settings, dispatcher/README and relevant tests; record the exact
   mutation and whether linked worktrees share the file content, the filesystem path, or only later
   merge conflict risk.
3. **Verify-first claim and surfaced conflict:** the parallel proof reports that
   `.claude/hooks/check-foreign-staging.sh` fell back to a stale 2026-08-03 footprint and that staging
   plus committing inside one tool call bypasses its candidate inspection. Inspect the complete hook,
   its registered tests, `docs/commit-discipline.md`, `docs/session-marker.md`, and the proof record.
   Establish which parts reproduce from current code and which are inference or fixture-specific;
   do not promote the report into policy without tracing the actual decision path.
4. **Verify-first claim:** `.claude/commands/new-worktree-session.md` and the close/cleanup commands
   implement an operator-driven interactive worktree lifecycle, while the dispatcher is still a
   throwaway script under `plans/` and is not installed as a command, hook or service. Search the
   command, hook and settings registries for `dispatch.sh`, `handoff-automation-spike`, `codex exec`
   and task-scoped dispatcher launch; bound any absence claim to those surfaces and patterns.
5. **Verify-first claim:** the parallel-session authority requires non-overlapping file ownership
   before spawning, serial landing, both-sides-present integration QC and liveness-aware teardown;
   content-shaped conflicts and destructive cleanup remain operator gates. Record any proposed policy
   departure rather than silently weakening those rules.
6. **Unknown to establish:** whether headless dispatcher children need the full `/prime` and
   `/session-start` lifecycle, a smaller explicit footprint/identity initialization, or no session
   harness at all. Compare the side effects and contracts of each option; do not assume an interactive
   workflow can be invoked headlessly without cost or drift.
7. **Unknown to establish:** the smallest way to remove `logs/friction-log.md` as a shared tracked
   write surface while keeping telemetry useful. Compare at least: no-op/suppression for dispatched
   actors, checkout-local untracked telemetry with reconciliation, and namespaced tracked telemetry.
   Include history fragmentation, merge behavior, consumer updates and risk-aware review cost.

### Required evidence

- For each verify-first claim, name the exact files and patterns inspected and report false premises
  explicitly. For absence claims, state both searched surfaces and search terms.
- Trace the current start-to-close path as a small sequence: task id → file-ownership decision →
  worktree/branch → dispatcher/actors → operator stop → serial landing/QC → teardown. Mark every
  step that is proven, proposed, operator-owned or currently blocked.
- Produce an option table for the shared-writer and session-footprint/tripwire problems. For each
  option give: paths changed later, safety property, residual risk, operator attention, telemetry
  impact, reversibility, test surface and whether autonomy rule 9 requires risk-aware review.
- Recommend one minimal production policy and one fallback. Explain why the recommendation reduces
  babysitting without claiming unsupported fan-out, reliability or cost savings.
- Give falsifiable acceptance checks for each proposed implementation unit. At least one check per
  unit must fail against current behavior; “the new file exists” or grepping this brief does not
  count.
- Confirm this discovery changed no repository path except this state file, launched no model,
  created no worktree/branch, changed no hook/settings/permissions and made no external write. Claude
  commits only this state file by explicit pathspec.

### Completion and stop conditions

Completion: the repository facts are established, one recommended policy and strongest fallback are
stated with value/risk grounds, all remaining operator decisions are explicit, the later work is
split into the smallest ordered implementation units with falsifiable evidence, this state file is
at `turn: codex`, and Claude commits only this state file.

This is discovery only: do not edit or test-fix the hooks, settings, commands, dispatcher or docs.
Hand back to Codex if a load-bearing claim is false or the evidence cannot distinguish the options.
Stop for the operator only if the investigation itself would require external writes, permission or
settings changes, destructive Git work, production activation, or accepting risk. Challenge stale
directions explicitly; do not implement around them.

## Latest result

Inspected (2026-08-06):

- **Claim (1): HOLDS.** Opened `logs/work-loop/work-loop-v2-parallel-worktree-proof.md`. It carries
  exactly the core § 4 closing headings in order (`## Outcome` 6, `## Decisions that matter` 18,
  `## Evidence` 54, `## Accepted limitations` 85) at `turn: operator`, records `pass=82 fail=0`
  (line 16), the live two-worktree evidence, the operator-authorized staging-tripwire override
  (lines 28–35) and the production limitations (lines 85–99). `git status --porcelain` on the path
  is empty and `git log -1` gives `11e077a`, so it is committed, not merely written. Not a stop.
- **Claim (2): HOLDS, with the sharing question answered precisely.** `.claude/hooks/log-write-activity.sh`
  is registered PostToolUse at `.claude/settings.json:67`. It resolves `$CLAUDE_PROJECT_DIR/logs/friction-log.md`,
  guards against recursion on `friction-log.md`/`improvement-log.md` (lines 18–20), and appends
  `- HH:MM — <relpath>` via `sed -i ''` after the **last** `#### Write Activity` heading (lines 26–32).
  `git ls-files --error-unmatch logs/friction-log.md` returns the path, so it is **tracked**. The
  spike README (lines 217–225) confirms the dispatcher treats it as foreign unless given
  `--allow-path '^logs/friction-log\.md$'`.
  **What linked worktrees share:** not the filesystem path and not the content. `git worktree list`
  shows 7 live worktrees, each with its own working tree; `CLAUDE_PROJECT_DIR` resolves to whichever
  worktree the session runs in, so each loop appends to **its own copy**. The collision is therefore
  **merge-time content conflict only** — both branches append under the same heading in the same
  tracked path. That is exactly the co-edited-shared-file shape `docs/parallel-sessions-playbook.md`
  § 2 calls the whole conflict surface, and the proof's own run record (line 335) says the same.
- **Claim (3): PARTIALLY reproduces — the report's mechanism is wrong, its effect is right, and the
  second half reproduces exactly.** Traced the decision path in the hook's own code rather than
  accepting the record.
  - *The "stale 2026-08-03 footprint" — effect real, mechanism misdescribed.* The closed proof record
    (lines 30–32) says the guard "fell back to the newest entry in `logs/session-notes.md`". No such
    scan exists. The header match is anchored to **both** the marker's date and its S-number
    (lines 508–509), and the whole footprint read is gated on `sess and sess_date` (line 492). What
    actually produces the stale read is the **shared-marker fallback at lines 393–399**: a session
    that ran no `/prime` writes no per-id marker, so the guard falls back to `logs/.session-marker` —
    a checkout-level file holding the *last* allocating session's `YYYY-MM-DD S{N}-{id}` — and then
    reads **that** session's footprint as its own. It is a stale-*marker* fallback, not a
    newest-entry scan. The distinction matters for policy: writing a correct shared marker in the
    worktree fixes it, whereas nothing about `session-notes.md` ordering would.
  - *The stage-and-commit-in-one-call blind spot — reproduces exactly.* The hook is `PreToolUse(Bash)`
    and computes candidates from `git diff --cached --name-only` (line 690), i.e. the index **as it
    stands before the command runs**. A single call of the shape `git add … && git commit …` presents
    an empty candidate set, and line 699 exits 0 with no inspection. Independently, `git add` with an
    explicit pathspec is **not gated at all** (documented at line 36; `_add_is_wide`, lines 139–154,
    gates only `-A/--all/-u/--update/.`). So for any actor that stages explicitly, the tripwire's
    only live arm is the `git commit` arm, and only when staging happened in an earlier call.
  - *Live control, this session:* my own two commits took the guarded path (separate `git add`, then
    `git commit`) and passed legitimately — marker `2026-08-06 S3-92e` resolved a concrete
    `- Files in scope:` bullet, and `- Required outputs:` widened it over `logs/work-loop/` and
    `plans/work-loop-v2-mvp/`. So the guard is armed and correct for interactive sessions; the
    failure is specific to headless entry.
- **Claim (4): HOLDS.** Searched `.claude/` (commands, hooks, settings) for `dispatch\.sh`,
  `handoff-automation-spike` and `codex exec`: **zero matches on all three patterns**. The dispatcher
  and its four supporting scripts are tracked files under
  `plans/work-loop-v2-v0.2/handoff-automation-spike/`, executable, installed nowhere. The interactive
  lifecycle exists as three commands: `.claude/commands/new-worktree-session.md`,
  `close-worktree-session.md`, `cleanup-worktree.md`.
- **Claim (5): HOLDS.** `docs/parallel-sessions-playbook.md` requires the file-ownership map as the
  hard pre-spawn gate (§ 1 gate 1, § 2, restated § 6 line 178 and § 9 line 224), serial landing into
  a clean target with only content conflicts gated (§ 5, § 9 line 228), both-sides-present
  integration QC (§ 5 line 145), and liveness-aware teardown as a named phase (§ 5 line 154). § 4
  line 122 names the entry path as an interactive VS Code window running `/prime` — which the
  dispatched shape does not use, and which the proof record already books as a by-design divergence.
- **Unknown (6): established.** A headless child does **not** need the full `/prime` + `/session-start`
  lifecycle. `logs/scripts/prime-session-entry.sh` is a standalone allocator, invoked by absolute path
  with cwd deciding which repo it writes into (lines 25–36), and it writes the atomic claim, both
  markers and the `## {date} — Session {MARKER}` header plus a work line (lines 38–43). But the
  `- Files in scope:` bullet the guard actually reads is written only by `/session-start` Step 3 — the
  hook names it the sole writer since 2026-07-29 (line 615). So the allocator **alone** leaves
  `no_concrete_footprint` true (lines 551–557) and drops into the warn-or-P3-block branch. The
  smallest sufficient initialization is therefore **two writes, not a lifecycle**: allocate the
  marker, then write one concrete `- Files in scope:` bullet under the allocated header.
- **Unknown (7): established, with a consumer count that decides it.** `logs/friction-log.md` is read
  by **20+ commands** (`fix-repo-issues`, `friday-checkup`, `monday-prep`, `improve`, `open-items`,
  `note`, `resolve-repo-problem`, `log-sweep`, `wrap-session`, `cleanup-worktree`, `leverage-idea`,
  `resolve-incident`, `pipeline-review`, `lean-repo`, `post-project-review`, `repo-dd`,
  `close-worktree-session`, `project-next-steps`, `reconcile-backlog`, `friction-log`). Any option
  that moves or renames the tracked path pays a 20-file consumer update. Options compared in § 2 below.

---

### 1. The start-to-close path, marked by status

`proven` = demonstrated by the closed proof; `proposed` = designed, not demonstrated;
`operator` = a human gate by policy; `blocked` = cannot run correctly today.

| # | Step | Status | Ground |
|---|---|---|---|
| 1 | Operator names an exact task id with an existing state file | **operator** | Proof: one exact task per dispatcher instance is retained |
| 2 | File-ownership map drawn, non-overlapping | **operator** | Playbook § 1 gate 1 — the map is the go/no-go test |
| 3 | Worktree + branch created | **proven** (interactive) | `/new-worktree-session`; proof created them by hand in a sandbox |
| 4 | Session identity initialised in the worktree | **blocked** | No caller writes a marker headlessly → shared-marker fallback reads a stranger's footprint (claim 3) |
| 5 | One dispatcher started, one task, one checkout | **proven** | Proof gate 12, `pass=82 fail=0`, 182s measured overlap |
| 6 | Actors write; ambient hook appends to `friction-log.md` | **blocked** | Tracked co-edited file → guaranteed landing conflict (claim 2); sandbox deleted the file rather than solving it |
| 7 | Actor commits | **proven, but unguarded** | Dispatcher allowlist checks after the actor; tripwire is blind to stage+commit in one call (claim 3) |
| 8 | `turn: operator` surfaced and automation stops | **proven** | Exit `26 MALFORMED_TERMINAL` + ordered closing-heading classification |
| 9 | Serial landing into a clean target | **proven (sandbox, additive-only)** | Two serial merges, B1–B9 passed; co-edited content untested |
| 10 | Both-sides-present integration QC | **proven (sandbox)** | Playbook § 5 line 145; proof ran it |
| 11 | Liveness-aware teardown | **proven (sandbox)** | Teardown sweep left nothing behind |

Two steps are blocked, and they are the two the operator's decision must clear: **(4) session identity**
and **(6) the ambient shared writer**. Everything else is either proven or an operator gate by design.

### 2. Option tables

**Problem A — the ambient shared writer (`logs/friction-log.md`).**

| | A1 Suppress for dispatched actors | A2 Checkout-local untracked + reconcile | A3 Namespaced tracked per session |
|---|---|---|---|
| Paths changed later | `.claude/hooks/log-write-activity.sh` | hook + `.gitignore` + a landing step | hook + **20+ consumer commands** |
| Safety property | No co-edit exists → no conflict possible | No tracked co-edit; conflict impossible | Additive-only new file per session — playbook § 5 line 150 zero-conflict shape |
| Residual risk | Dispatched writes leave no breadcrumb outside git | Reconciliation is a manual step that will be skipped | 20-file edit is a wide blast radius; history fragments |
| Operator attention | None added | **One step added per landing** — fights the objective | None added after the migration |
| Telemetry impact | Traded away for dispatched runs only; interactive unchanged | Fully preserved | Preserved but relocated |
| Reversibility | Delete one early-exit clause | Revert hook + ignore rule | Hard — consumers rewritten |
| Test surface | One hook fixture: env set → file byte-identical; unset → line appended | Same + a reconciliation test | Hook fixture + 20 consumer regressions |
| Risk-aware review? | **Yes** — hook edit is a structural class (`audit-discipline.md` § Structural change classes, bullet 1) | Yes — hook + shared-state automation | Yes — hook + new commands/consumers |

**Problem B — session identity and the staging tripwire for headless children.**

| | B1 Full `/prime` + `/session-start` in each child | B2 Minimal explicit init (marker + one footprint bullet) | B3 No session harness |
|---|---|---|---|
| Paths changed later | Dispatcher only, but invokes two interactive commands | Dispatcher only | None |
| Safety property | Guard armed with a validated footprint | Guard armed with a concrete footprint | **Guard actively misinformed** — reads a stranger's footprint |
| Residual risk | Both commands are interactive-shaped and unverified headlessly; heavy side effects (telemetry nudges, context packs) | Footprint is dispatcher-derived, not `/session-start`-validated | Unacceptable: worse than off — a stale footprint can *pass* a foreign file |
| Operator attention | None, if it works headlessly — unproven | None | None, until contamination |
| Telemetry impact | Full session telemetry written per child | None | None |
| Reversibility | High | High | n/a |
| Test surface | Large — two full command paths headlessly | One fixture: after init, `no_concrete_footprint` is false | n/a |
| Risk-aware review? | No (dispatcher is under `plans/`, not installed) | No (same) | n/a |

### 3. Recommended minimal production policy

**"Operator-gated worktree, minimally-identified headless entry, telemetry quarantined, allowlist as
the real containment."** Five rules:

1. **Admission stays with the operator.** The operator names one exact task id that already has a
   state file, and draws the file-ownership map before any worktree exists. The dispatcher never
   selects work and never creates a worktree. Rationale: playbook § 1 gate 1 is the decisive test and
   it is a judgment, not a check.
2. **One task, one worktree, one dispatcher.** Carried unchanged from the proof, which explicitly
   declines to authorise same-checkout concurrency or one dispatcher over several tasks.
3. **Identity before actors (option B2).** Before hop 1 the dispatcher runs
   `logs/scripts/prime-session-entry.sh` by absolute path with cwd set to the worktree, then writes one
   concrete `- Files in scope:` bullet under the allocated header, derived from the run's own
   `--allow-path` set. Two writes, no interactive command.
4. **Telemetry quarantined (option A1).** `log-write-activity.sh` exits 0 for dispatched actors.
   **The value traded away, stated plainly:** dispatched runs lose the `- HH:MM — path` breadcrumb.
   That is a small trade *for this shape specifically*, because every dispatched write ends in a
   commit by protocol, and the dispatcher's per-hop run log already records run id, task, checkout,
   state-file `sha256` before→after, `turn`, `HEAD`, actor exit status and duration — strictly richer
   than "a file was written at 14:32". Interactive sessions keep the breadcrumb unchanged. This is
   **not** allowlisting a co-edited tracked file; it removes the co-edit.
5. **The allowlist is the containment boundary, not the tripwire.** For dispatched runs the staging
   tripwire cannot be the safety mechanism — it is blind to stage-and-commit in one call and ungated
   on explicit-pathspec adds. The dispatcher's own `--allow-path` check is what actually constrains a
   headless actor. Rule 3 exists so the tripwire is *correctly armed rather than misinformed*, not so
   it can be relied on.

Landing is unchanged from the playbook: clean target, serial merges, content conflicts are an
operator gate, both-sides-present integration QC, liveness-aware teardown.

**Why this reduces babysitting, and what it does not claim.** It removes the two things that today
require a human mid-run: a guard that blocks on a false positive (rule 3) and a merge conflict
manufactured by telemetry rather than by work (rule 4). It makes **no** claim about wall-clock
speedup — playbook § 0 line 26 forbids quoting an unmeasured multiple — and none about token or
compute cost, which parallelism raises rather than lowers. **Maximum supported fan-out is 2**, because
two is the only number ever demonstrated, once.

**Fallback:** if the operator wants the breadcrumb preserved, swap rule 4 for **A2** (checkout-local
untracked telemetry reconciled at landing) and accept one added manual step per landing. Everything
else stands. A2 is the fallback rather than the recommendation precisely because that added step is
operator attention, which is the cost the whole objective exists to reduce.

### 4. Operator decisions still required

| # | Decision | Recommended | Strongest alternative | Value / risk |
|---|---|---|---|---|
| D1 | Shared-writer disposition | **A1 suppress for dispatched runs** | A2 untracked + reconcile | A1 buys zero added attention for a breadcrumb git already covers; A2 buys the breadcrumb for one manual step that will eventually be skipped |
| D2 | Fan-out ceiling | **Cap at 2** | Allow 3+ | 2 is the only measured number; a higher cap is an unevidenced claim, and the playbook's own limit note forbids quoting unmeasured speedup |
| D3 | Does the dispatcher graduate out of `plans/`? | **No — keep under `plans/`, invoke by explicit path** | Install as a command | Installing creates a new-command structural class and a maintained surface, on one live run of demand evidence. Keeping it under `plans/` costs a longer invocation and nothing else |
| D4 | May a dispatched run create its own worktree? | **No — operator creates it** | Dispatcher creates it | Worktree creation is where the file-ownership gate lives; automating it moves the playbook's hard gate inside the automation it gates |
| D5 | Is the proof record's claim-3 mechanism corrected? | **Yes — one line, it currently misdescribes live code** | Leave as history | A closed record is evidence; leaving a wrong mechanism in it invites the next reader to design against a scan that does not exist |

### 5. Ordered implementation units (not executed)

**U1 — headless session identity in the dispatcher.** Owned path:
`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` only. Not a structural class (under
`plans/`, uninstalled) → ordinary review. *Falsifiable check:* in a throwaway worktree with no marker,
run the dispatcher's init step, then assert `logs/.session-marker` exists **and** `session-notes.md`
contains a `- Files in scope:` bullet under the allocated header. **Fails today** — no caller writes
either, which is why the shared-marker fallback fires. Rollback: revert one function.

**U2 — quarantine write-activity telemetry for dispatched actors.** Owned path:
`.claude/hooks/log-write-activity.sh`. **Structural class (hook edit) → one risk-aware Codex review
before implementation**, per `docs/audit-discipline.md` § Structural change classes. *Falsifiable
check:* two fixture runs — with the dispatcher's env marker set, a Write leaves `friction-log.md`
byte-identical (`git diff --quiet`); without it, exactly one line is appended. **Fails today** — the
hook has no env-conditional path, so both runs append. Rollback: delete the early-exit clause.

**U3 — document the dispatched entry path in the playbook.** Owned path:
`docs/parallel-sessions-playbook.md` (not always-loaded → not a structural class). *Falsifiable check:*
§ 4 names two entry paths and the dispatched one does not route through an interactive `/prime`.
**Fails today** — § 4 line 122 names only the VS Code + `/prime` entry, which is why the proof had to
book its own entry as a divergence. Rollback: revert one section.

**U4 — correct the deferred `dispatch.sh` documentation defects.** Owned path: `dispatch.sh` header
only. *Falsifiable check:* `bash dispatch.sh --help | grep -c '^ *25'` returns 1, and the header no
longer reads "NOT multi-loop". **Fails today** — `--help` prints `sed -n '2,45p'`, truncating exit code
25 at line 46. Rollback: revert the header.

**U5 — correct claim 3's mechanism in the closed proof record.** Owned path:
`logs/work-loop/work-loop-v2-parallel-worktree-proof.md`, one bullet. Contingent on D5. *Falsifiable
check:* the record names the shared-marker fallback rather than a newest-entry scan. **Fails today.**

Order: U1 → U2 → U3 → U4/U5. U1 and U2 are both prerequisites to any real parallel run; U1 first
because it needs no gate, U2 second because it needs a risk-aware review first.

### 6. Scope confirmation — and one honest exception

**Deliberately changed: one path, this state file.** Every other command this unit ran was a read
(`Read`, `/usr/bin/grep`, `git status`/`log`/`ls-files`/`worktree list`, `sed -n` on a run record). No
model was launched, no worktree or branch created, no hook, settings, permission, command, skill, doc
or dispatcher file edited, no external write, no push. Claude commits this state file alone, by
explicit pathspec.

**Exception, disclosed rather than claimed away: `logs/friction-log.md` is modified.** Not by a
deliberate edit — by `log-write-activity.sh` firing on this unit's own Writes to the state file. The
file was already modified before the unit began (it carries earlier sessions' unstaged breadcrumbs),
so this unit did not dirty a clean path, but it did append to it. **This is the ambient shared writer
of claim 2 demonstrating itself inside a discovery unit whose brief forbade repository writes** — the
strongest available evidence that it cannot be left in place for parallel operation, since not even a
read-only unit can avoid triggering it. It is left unstaged and uncommitted.

**Also observed, untouched:** `logs/work-loop/project-progression-candidate-review-correction.md`
appeared in the working tree during this unit, untracked and not created by Claude. It is outside this
unit's scope and was neither read as authority, modified, nor staged.

## Blocker

None.

## Next action

Codex: assess this discovery. The recommendation is § 3 with § 3's fallback; the five operator
decisions are § 4; the ordered units are § 5. Three things warrant your judgment specifically.
First, **claim 3 came back partly false** — the closed proof record misdescribes the tripwire's
mechanism, and I have proposed correcting a *closed* record (D5/U5) rather than silently designing
around it; decide whether that is right. Second, I have recommended that the staging tripwire is
**not** the containment boundary for headless runs (§ 3 rule 5) — that is a downgrade of a guard the
repository treats as important, and it should be assessed as such rather than accepted from me.
Third, § 3 rule 4 trades away telemetry; judge whether the dispatcher run log genuinely replaces it
or whether the fallback should be promoted. Then reframe or stop.
