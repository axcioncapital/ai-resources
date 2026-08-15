# Work Loop v2 — cross-transport concurrency and task-aware worktrees

**Implementation proposal.** Dated 2026-08-13 by the deliverable name in the commissioning brief;
written and evidenced on 2026-08-14 against the repository at that date.

**Status:** proposal. It recommends; it authorizes nothing and implements nothing. Every repository
claim below carries a file and line reference and was checked by inspection before this document was
written. Where a section states a recommendation rather than a repository fact, it says so in the
sentence.

**Reading order.** § 1 is the decision. § 2 and § 3 are the evidence it rests on. §§ 4–7 are the
design and the sequence. §§ 8–10 are what could go wrong, what is deliberately not being done, and
what the operator must decide.

---

## 1. Executive decision

**Build one shared live-lease contract, used by both transport programs, and put fail-closed
ownership admission in front of both actor launches. Do that first, alone, before anything else.
Treat task-aware automatic worktrees as a separate, conditional Phase 2 that needs an explicit
operator decision to replace policy D4.**

The recommendation in one paragraph: the unattended dispatcher already enforces the right
structure — two independent leases, rooted in the Git common directory, plus a repository-depth
ownership check that fails closed. The attended carrier enforces a weaker one — a single
checkout-keyed lock under a caller-controlled temporary directory, and no ownership check at all.
The two lock roots do not overlap, so neither program can see the other's lease. The repair is to
extract what the dispatcher already proved into one helper, have the carrier call it, and give the
carrier the same ownership admission. That is a consolidation of an existing mechanism, not a new
subsystem.

**Why the fix belongs in the harness and transport layer.** The failure being closed is two writers
in one working tree, or two runs on one logical task. Both are properties of *processes and
checkouts*, not of the Work Loop's semantics. The transports are the only components that launch an
actor, and launching is the moment where refusal is still cheap and nothing has been written. The
executable core needs no change at all for Phase 1: one task, one state file, the state file's
location as the binding, and Claude commits — all unchanged.

**What must change in Work Loop instructions, and no more.** Two things:

1. The carrier's new ownership stop needs its exit codes documented in the same taxonomy that
   already carries the dispatcher's — `.agents/skills/work-loop-v2/SKILL.md` lines 290 and 302
   already assign `33`, `34` and `35` to ownership stops, so this is an extension of an existing
   list rather than a new one.
2. The Codex skill's statement of what is *not* prevented
   (`.agents/skills/work-loop-v2/SKILL.md` lines 197–201) becomes narrower once the carrier is
   covered, and must be edited to stay true. An honest limit that has silently gone stale is worse
   than one that was never written.

Nothing else in the skill, the Claude command or the core is touched by Phase 1.

**Why not do worktrees at the same time.** Automatic worktree creation places tasks into checkouts.
Placing tasks automatically while two transports still cannot see each other's leases would multiply
the number of places the invisible race can happen, and it would do it faster than an operator can
observe. The safety boundary comes first. This ordering is a recommendation, and § 10 records it as
an operator decision rather than a settled fact.

---

## 2. Current-state matrix

Four surfaces, three verdicts: **Fixed** (structurally enforced, an exit code refuses), **Partial**
(enforced for some shapes and not others), **Unfixed** (nothing structural refuses it).

### 2.1 Unattended dispatcher — `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`

| Guarantee | Verdict | Evidence |
|---|---|---|
| Lock root is discovered from the repository, not the environment | **Fixed** | Lines 639–644: `git rev-parse --git-common-dir`, canonicalized with `pwd -P`, then `/work-loop-dispatch-locks`. The comment at 614–620 records why `${TMPDIR}` was abandoned — it is caller-controlled, so two dispatchers with different `TMPDIR` values never contended. |
| One live dispatcher per logical task, repository-wide | **Fixed** | Line 649: task lock `task-<sha256(task)>.lock`. Refusal at 672–674 names the holding checkout. |
| One live dispatcher per physical checkout, whatever the task | **Fixed** | Line 650: checkout lock `checkout-<sha256(checkout-path)>.lock`. Refusal at 693–697 names the holding task and says why two dispatchers in one checkout are unsafe. |
| Two-lease acquisition rolls back cleanly | **Fixed** | Lines 677–687: task lock first, checkout lock second; if the second is refused the first is removed and `LOCK_OWNED` reset before exit 17. |
| A run that cannot prove its actor tree stopped leaves both leases pinned | **Fixed** | Lines 706–732: `pin_lock` writes `survivors` into the task lock and copies it to the checkout lock; `release_lock` returns early when pinned (738). |
| Durable ownership admission before an actor launches | **Fixed, fail-closed** | Lines 2336–2348: `work-loop-owner.sh check --depth repo`; exits `33` REFUSE, `34` AMBIGUOUS, `35` unavailable-or-failed. The comment at 2325–2335 states the fail-closed choice and why absence cannot mean proceed. |
| Read-only status that reports lease and ownership separately | **Fixed** | Lines 1191–1192 (`--status` takes no lock) and the status branch that prints the `.owner` declaration, the checkout lock, and pinned-task-lock state. |

**One ordering fact, stated because it matters to Phase 1 and is easy to misread.** The dispatcher
takes both leases at line 1192, and performs ownership admission at line 2336 — leases first,
ownership second. Both happen before any actor launches, so no unsafe window exists inside a single
run. It does mean a refused-by-ownership run briefly held both leases. This is not a defect and this
proposal does not recommend changing it; it is recorded so the shared helper's contract is written
against what the dispatcher actually does.

### 2.2 Attended carrier — `scripts/axcion-harness-v0.2/carry-turn.sh`

| Guarantee | Verdict | Evidence |
|---|---|---|
| One live carry per physical checkout, whatever the task | **Fixed** | Lines 636–659: key is `sha256(canonical checkout path)` alone; refusal at 647 is explicit that it applies "whether or not it is the same task". Exit `17`, documented at lines 126–128. |
| Lock root is discovered from the repository | **Unfixed** | Line 639: `${TMPDIR:-/tmp}/axcion-harness-v0.2.<key>.lock`. This is the exact caller-controlled root the dispatcher moved away from, still in use here. |
| One live carry per logical task, repository-wide | **Unfixed, and deliberately so today** | Lines 622–624 state that a linked worktree canonicalizes to a different path, takes a different lock and "stays independently admissible". Test-proven: `scripts/axcion-harness-v0.2/carry-turn.test.sh` § 12b, line 811 — "the same task in a separate linked worktree IS admitted". |
| Durable ownership admission before an actor launches | **Unfixed** | Searched `scripts/axcion-harness-v0.2/carry-turn.sh` for `work-loop-owner.sh check` and for `--depth repo`: zero matches. The only occurrence of `work-loop-owner` is a comment at lines 626–630 explaining that the durable declaration is a *different* mechanism from this ephemeral lock. Compare `dispatch.sh` 2336–2348, which runs the check. |
| Stale-lock handling is three-valued, not two | **Fixed** | Lines 642–655: a live holder refuses (17), an unreadable-pid lock refuses without deleting anything (17), and only a provably dead pid is cleared. |
| No worktree creation on this surface | **Fixed, by refusal** | Lines 310–311: `--worktree`, `--create-worktree`, `--isolate` are refused with an actionable message. |
| No out-of-band status | **Fixed, by refusal** | Lines 318–319: `--status` refused; the state file is the status. |
| No simulated-actor seam | **Fixed, by refusal** | Lines 316–317: `--actor-cmd`, `--simulate`, `--fake-actor` refused; the sanctioned test route is `--claude-bin` / `--codex-bin` pointed at a stub binary, which is how `carry-turn.test.sh` runs (its header note at line 8, and the `--claude-bin "$FAKEBIN"` calls throughout). |

### 2.3 Cross-transport — carrier versus dispatcher

| Guarantee | Verdict | Evidence |
|---|---|---|
| A carrier and a dispatcher in one checkout refuse each other | **Unfixed** | Their lock roots do not intersect. `dispatch.sh` contains zero occurrences of `axcion-harness-v0.2.`; `carry-turn.sh` contains zero occurrences of `work-loop-dispatch-locks`. Each program's lease is invisible to the other, so both can hold "their" lock in the same working tree at the same time. |
| A carrier and a dispatcher on one task in different worktrees refuse each other | **Unfixed** | Same root cause, plus the carrier has no task-scoped lease at all (§ 2.2). |

**This is the central gap, and it is an inference from two absences, not from the presence of two
locks.** The claim is not "each program has its own lock, therefore they cannot see each other" — it
is that neither program's source contains any read of the other's lock path, checked by pattern, and
their roots are computed from different sources (Git common directory versus `$TMPDIR`).

### 2.4 Interactive Work Loop — skill, command, owner helper

| Shape | How it is handled | Evidence |
|---|---|---|
| A second **task** entering a checkout an open task holds | **Structurally refused** by the declaration | `logs/scripts/work-loop-owner.sh` 211–212: REFUSE, exit 3. |
| A task claimed by a **different checkout** | **Structurally refused** at repo depth | `work-loop-owner.sh` 262–271. |
| A state file **replicated** across checkouts with no declaration | **AMBIGUOUS**, refuses everywhere, exit 4 | `work-loop-owner.sh` 278–282. It never guesses an authoritative copy. |
| A declaration that is unreadable or holds more than one id | **AMBIGUOUS and preserved** — never deleted | `work-loop-owner.sh` 128–151, and `clear` at 404–406. |
| Two `claim`/`clear` callers racing on one free checkout | **Structurally refused** by a mkdir mutation lock | `work-loop-owner.sh` 319–362; the comment records the measured pre-fix result: 10 contested pairs, 10 double claims, 0 refusals. |
| Claude's entry check | **Instruction-borne**, repo depth | `.claude/commands/work-loop-v2.md` 155–171 — the model is told to run the check and to stop on REFUSE/AMBIGUOUS/unavailable. |
| Codex's entry check | **Instruction-borne**, local depth, no git | `.agents/skills/work-loop-v2/SKILL.md` 189–197; `work-loop-owner.sh` 18–28. |
| Two interactive sessions on one checkout for the **same** task | **Expressly unprevented** | `work-loop-owner.sh` 36–39, stated as a limit rather than covered by claim; the same sentence appears in `SKILL.md` 199. |
| An operator who proceeds past a refusal | **Expressly unprevented** | Same two places. "Interactive enforcement is instruction-borne; only the dispatcher's is exit-code-borne." |

### 2.5 Worktree entry — `.claude/commands/new-worktree-session.md`

| Property | Current behaviour | Evidence |
|---|---|---|
| Who invokes it | The operator only — the model may not | Frontmatter line 4: `disable-model-invocation: true`. |
| Naming | Unit label from `$ARGUMENTS`, or the operator is asked for one; branch `session/{today}-{unit}`; path is a sibling directory `{repo}-{unit}` | Lines 36–42. |
| Existing-worktree behaviour | Never clobbers: appends `-2`, `-3`, … until the path is unique | Lines 44–45. |
| Creation | `git worktree add "$WORKTREE_PATH" -b "$BRANCH" main` — base defaults to `main`, surfaced in one line; errors stop rather than retry | Lines 47–59. |
| Session attachment | **Cannot move the current session.** It opens a new VS Code window on the folder; the operator then opens the Claude Code panel and runs `/prime` themselves | Lines 17–23 and 61–95, and explicitly at 82–83: opening the folder "does **not** auto-start a Claude session". |
| Task-awareness | **None.** No task id is an input, no state file is created, no `.owner` declaration is written | Searched the whole file, case-insensitively, for `task`, `.owner` and `work-loop`: zero matches. Its unit of work is a free-text label, not a Work Loop task. |
| Teardown | A separate tracked command, `/close-worktree-session`, with guards; the by-hand snippet was deliberately removed after a 2026-07-14 near-miss | Lines 111–130. |

**So worktree creation is scripted but not automatic, and entry is manual.** The Codex skill says
the same thing in one sentence — `SKILL.md` line 187: naming `/new-worktree-session` is
"**the one residual manual step, and only on the isolated path**".

### 2.6 The two current-state records

`logs/work-loop/work-loop-v2-concurrent-task-isolation.md` — `turn: operator`, still open:

- Unit 10 accepted; the case is "**Integrated, awaiting operational validation**" (line 14).
- The mechanism is live on canonical `main` at `0d9e335`; from canonical main the owner suite passed
  92/0 and the dispatcher suite 389/0; nothing was pushed (line 20).
- Blocker (line 32): "Representative ordinary use has not happened yet, so the
  repository-problem-resolution SOP does not permit the case to be called **Resolved**."
- Next action (line 36): use the mechanism on the next genuine pair of concurrent Work Loop tasks;
  do not manufacture a conflict, because the automated suites already cover the refusals.

`logs/work-loop/work-loop-v2-production-readiness-policy.md` — closed record, `turn: operator`:

- **D4 is the boundary this proposal's Phase 2 would move.** Quoted exactly, lines 37–40:

  > **D4 — a dispatched run may not create its own worktree, as recommended.** The operator creates the
  > worktree, because worktree creation is where the file-ownership gate lives
  > (`docs/parallel-sessions-playbook.md` § 1 gate 1). Automating it would move the playbook's hard gate
  > inside the automation it gates.

- D2 caps fan-out at 2, because two is the only fan-out ever demonstrated (lines 31–33).
- D3 keeps the dispatcher in `plans/`, invoked by explicit path (lines 34–36).
- Recorded deferral, lines 53–56: **no live dispatched run was ever made** — every check is simulated
  or against a throwaway clone.
- Accepted limitations, lines 104–110: the policy rests on one live two-worktree observation;
  fan-out above 2, landing of co-edited content and Codex-side permission denial under parallel
  operation are untested; the identity init has only run with a simulated actor.

**D4 is settled policy and this document does not change it.** § 6 describes a possible replacement
and § 10 puts approving it to the operator. Until they approve it, D4 governs.

### 2.7 One correction to the background material

`plans/axcion-harness-v0.2/task-scoped-concurrency-investigation-2026-08-08.md` is non-governing
background, and two of its statements have been overtaken by the implementation that followed it:

- Its line 37 records the dispatcher lock as `sha256(CHECKOUT|TASK)` under a temporary directory.
  That composite key no longer exists; `dispatch.sh` 649–650 has two independent keys.
- Its Step 2 (line 169) recommended keeping the locks "under the runtime temp directory". The
  implementation deliberately did the opposite and rooted them in the Git common directory, for the
  reason recorded at `dispatch.sh` 614–620.

Recorded so a later reader does not design against the older description. The investigation's
*analysis* of the two missing cases is still accurate and still useful.

---

## 3. Failure model

Five cases. Each names what is refused today and what is not.

**F1 — the same logical task, in two checkouts.**
Dispatcher against dispatcher: refused, exit 17, by the task lock (`dispatch.sh` 649, 672–674).
Carrier against carrier: **admitted**, by design as written today (`carry-turn.sh` 622–624;
`carry-turn.test.sh` line 811). Carrier against dispatcher: **admitted**, because neither sees the
other's lease. Consequence: two actors editing one task's state file in two working trees, each
committing to its own branch. The state file stops being the single interface, which is the one
property core § 4 exists to hold.

**F2 — two different tasks, in one checkout.**
Dispatcher against dispatcher: refused, exit 17, by the checkout lock (`dispatch.sh` 650, 693–697).
Carrier against carrier: refused, exit 17 (`carry-turn.sh` 647, which says so explicitly).
Carrier against dispatcher: **admitted**. Consequence: two actors sharing one working tree and one
index — either can sweep the other's paths into a commit, which is the failure `dispatch.sh` 621–624
names in prose.

**F3 — carrier versus dispatcher contention, generally.**
Unfixed in every combination (§ 2.3). This is the case that makes F1 and F2 worse rather than a
separate hazard of its own: each program is internally correct and jointly blind. It is also the
case least likely to be noticed, because both programs report a clean single-writer run.

**F4 — durable ownership versus live-process leasing.**
These answer different questions and neither substitutes for the other. A lease dies with its
process; a task outlives many processes. The declaration (`logs/work-loop/.owner`) is what carries
ownership between handoffs, and `dispatch.sh` 2313–2323 states the split precisely. The carrier
today has the lease half and not the declaration half, so an attended hop can launch an actor into a
checkout whose declaration would have refused it — including the two shapes only repo depth can see:
the task claimed in another checkout, and a state file replicated with no declaration deciding which
copy is authoritative.

**F5 — the bounded interactive limitation.**
Two interactive sessions on one checkout for the same task, and an operator who proceeds past a
refusal, are not prevented by anything and are not proposed for fixing here
(`work-loop-owner.sh` 36–39). The mitigating structure is that Claude makes every commit (core § 4),
so every unit crosses one repo-depth check before anything is committed. This proposal keeps that
limit stated rather than closed, because closing it would require enforcing instructions on a live
model session — a different problem with a different shape.

---

## 4. Phase 1 implementation design

### 4.1 Behavioural contract

One shared live-lease mechanism. Two resources, exactly as the dispatcher already defines them:

- **Task lease** — one live actor-launching run per logical task, anywhere in the repository,
  including in another linked worktree.
- **Checkout lease** — one live actor-launching run per physical checkout, whatever task it carries.

Four properties the contract must hold, all of which the dispatcher's current implementation already
demonstrates and which the shared version must not lose:

1. **The root is derived from the repository**, never from the caller's environment:
   `git rev-parse --git-common-dir`, canonicalized, plus a fixed subdirectory name.
2. **Acquisition is ordered and rolls back** — task lease first, checkout lease second; a refused
   second lease releases the first before exiting.
3. **A lease that cannot be shown free is treated as held.** Three pid states, not two; an
   unreadable holder refuses and deletes nothing.
4. **Pinning survives the process.** When a run cannot prove its actor tree stopped, both leases are
   pinned, and no ordinary exit path releases a pinned lease.

Plus one property that is new because the mechanism becomes shared:

5. **A lease records which program holds it.** Today's lock directories record pid, task and
   checkout (`dispatch.sh` 663–665, 682–684). A shared lease adds the program name, so a refusal can
   say "an attended carry holds this checkout" rather than naming a pid the operator cannot place.

### 4.2 Candidate file-level change map

This is a candidate map. The final code shape belongs to the implementation unit, and the ordering
constraint in § 4.5 is the only part of it this proposal asks to be treated as binding.

| File | Change |
|---|---|
| `logs/scripts/work-loop-lease.sh` (new) | The shared lease. Subcommands `acquire`, `release`, `pin`, `status`, taking `--checkout`, `--task` and a program label. Lives beside `work-loop-owner.sh` because it is the same kind of thing: a small shared helper both transports call, no git mutation, no semantic state. |
| `logs/scripts/work-loop-lease.test.sh` (new) | The lease's own suite, including the two-resource race cases in § 5.4. |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` | Replace the inline lock section (roughly 610–743) with calls to the helper. Behaviour, exit codes and `--status` output must not change — the dispatcher's existing suite is the regression proof. |
| `scripts/axcion-harness-v0.2/carry-turn.sh` | Replace `acquire_lock`/`release_lock` (636–665) with calls to the helper. Add the repo-depth ownership admission before actor launch, mirroring `dispatch.sh` 2336–2348. |
| `scripts/axcion-harness-v0.2/carry-turn.test.sh` | Update § 12b, which currently *asserts* the behaviour Phase 1 removes (line 811: same task in a separate worktree is admitted). This assertion becomes its inverse. |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` | Add the cross-transport cases; keep every existing case passing. |
| `.agents/skills/work-loop-v2/SKILL.md` | Narrow the "not prevented" statement at 197–201 to what remains true; add the carrier's ownership exit codes to the taxonomy at 290/302. |

**Prefer extraction over reimplementation.** The dispatcher's lock section is proven code with a
389-case suite behind it (`work-loop-v2-concurrent-task-isolation.md` line 20). Writing a second
lease for the carrier would produce two implementations of one invariant, which is the shape that
made the original composite key wrong in two programs at once.

### 4.3 Acquire, release, pin, status

- **Acquire.** `mkdir` as the atomic primitive, unchanged. Task lease then checkout lease. On
  refusal of either, release anything already taken and exit with the program's lock-held code.
- **Release.** Pinned beats owned, checked inside the helper so no caller can skip it — the reason
  `dispatch.sh` 735–738 puts the check in `release_lock` rather than at each call site.
- **Pin.** Both leases, because a survivor holds both resources (`dispatch.sh` 722–728).
- **Status.** Read-only, takes no lease. The dispatcher's `--status` must keep printing what it
  prints today, including the `.owner` declaration and the checkout lease reported separately from
  the task lease. The carrier keeps refusing `--status` (`carry-turn.sh` 318–319) — that refusal is
  a deliberate attended-surface boundary and Phase 1 does not touch it.

### 4.4 Exit-code compatibility

- **Dispatcher:** unchanged. `17` for a held or pinned lease; `33`/`34`/`35` for ownership.
- **Carrier:** `17` keeps its current meaning and widens to cover the task lease as well as the
  checkout lease — the message must say which resource was refused, since the operator's remedy
  differs. Ownership stops take `33`, `34`, `35`. Checked: the carrier's documented codes today are
  `0`, `10`–`22`, `24`–`26`, `28`, `30`, `37` (`carry-turn.sh` 116–153) — `33`, `34` and `35` are
  free, and `SKILL.md` 290 and 302 already bind those three numbers to ownership stops across the
  Work Loop. Reusing them is conforming to an existing taxonomy, not inventing a local one.

### 4.5 Migration constraints

Three, and the first is the one that can actually bite:

1. **The carrier's lease root moves from `$TMPDIR` to the Git common directory.** A carry already in
   flight when the change lands holds a lock the new code does not look at. **Recommendation:** for
   one release, the new carrier also reads the legacy `${TMPDIR:-/tmp}/axcion-harness-v0.2.<key>.lock`
   path read-only and refuses if it is held. It costs a few lines and it removes the only window in
   which the change itself could admit two writers.
2. **Older checkouts may not carry the helper.** Fail closed, exactly as the ownership check already
   does (`dispatch.sh` 2325–2335 and 2346–2347): a missing lease helper means the lease is
   unestablished, so nothing launches. This is deliberately unlike the session-identity init, which
   skips with a visible line when its allocator is absent — that one arms a tripwire, this one is
   the last thing between two writers and one working tree.
3. **Open tasks must survive the change.** Leases are per-run and per-process, so no open task holds
   one across the change. Declarations in `logs/work-loop/.owner` are untouched by Phase 1.

### 4.6 Explicit non-goals for Phase 1

No worktree creation. No scheduler, registry or lease database. No repository-wide session lock. No
serialized state writer or compare-and-swap state API. No semantic content in a lease — pid, task,
checkout, program and pin evidence only. No change to the executable core. No automatic landing,
merging or cleanup. No attempt to prevent a human editing a state file by hand during a run; the
carrier and dispatcher both state that boundary today and it stays stated.

---

## 5. Failing-first acceptance matrix

Every case is written **failing first**: it must fail against the code as it stands today, then pass
after the change. A case that passes before the change proves nothing about the change.

**Evidence classes, and why they are separated.** A case marked *controller* is proven by lease
state, exit code and message with no real actor involved. A case marked *actor* needs something
launched. The two transports differ here and the difference is load-bearing: `dispatch.sh` has a
simulated-actor seam (`--actor-cmd`, line 120), while `carry-turn.sh` **refuses** every simulated
seam (lines 316–317) and directs testing through `--claude-bin` / `--codex-bin` pointed at a stub
binary — which is how `carry-turn.test.sh` already works (its line 8 header note). So a carrier
acceptance case is never "simulated" in the dispatcher's sense; it is a stub binary or a live model.
**No case in this matrix is satisfied by a live-model run in place of the controller evidence, and
no controller case may be reported as live-actor evidence.**

### 5.1 Same task, same checkout

| # | Combination | Expected | Class | Fails today? |
|---|---|---|---|---|
| 1 | dispatcher + dispatcher | second refused, 17 | controller | no — already passes; kept as a regression guard |
| 2 | carrier + carrier | second refused, 17 | controller | no — already passes; regression guard |
| 3 | carrier holds, dispatcher starts | dispatcher refused, 17, naming the attended holder | controller | **yes** |
| 4 | dispatcher holds, carrier starts | carrier refused, 17, naming the dispatched holder | controller | **yes** |

### 5.2 Same task, different linked worktrees

| # | Combination | Expected | Class | Fails today? |
|---|---|---|---|---|
| 5 | dispatcher + dispatcher | second refused, 17 (task lease) | controller | no — regression guard |
| 6 | carrier + carrier | second refused, 17 (task lease) | controller | **yes** — and it inverts `carry-turn.test.sh` line 811 |
| 7 | carrier holds, dispatcher starts | dispatcher refused, 17 | controller | **yes** |
| 8 | dispatcher holds, carrier starts | carrier refused, 17 | controller | **yes** |

### 5.3 Different tasks

| # | Combination | Expected | Class | Fails today? |
|---|---|---|---|---|
| 9 | two dispatchers, one checkout | second refused, 17 (checkout lease) | controller | no — regression guard |
| 10 | two carriers, one checkout | second refused, 17 (checkout lease) | controller | no — regression guard |
| 11 | carrier + dispatcher, one checkout | second refused, 17, naming the other program | controller | **yes** |
| 12 | any pair, different worktrees, different tasks | **both admitted** | controller | no — this is legitimate concurrency and the matrix must prove the change did not over-refuse |

### 5.4 Two-resource acquisition races

| # | Case | Expected | Class | Fails today? |
|---|---|---|---|---|
| 13 | N contenders start simultaneously on one free (task, checkout) pair | exactly one proceeds; the rest refuse; no double acquisition | controller | **yes** for any pair involving the carrier |
| 14 | task lease acquired, checkout lease refused | task lease released before exit; no orphan | controller | partially — proven for the dispatcher (`dispatch.sh` 687), unproven for the shared helper |
| 15 | rollback under contention | after case 14, a third run acquires both cleanly | controller | **yes** |
| 16 | pin when only one lease was acquired | pin does not claim a lease the run never held; `--status` reports exactly what is pinned | controller | **yes** — `pin_lock` guards on `LOCK_OWNED` (709) and `CHECKOUT_LOCK_OWNED` (728), and the shared helper must keep that guard |

### 5.5 Release, pin, ownership, status

| # | Case | Expected | Class | Fails today? |
|---|---|---|---|---|
| 17 | ordinary exit releases both leases | both gone; the next run is admitted | controller | no — regression guard |
| 18 | pinned lease refuses the next run of either program | 17, with the survivor evidence printed | controller | **yes** for the carrier |
| 19 | ownership helper missing in the checkout | carrier exits 35, launches nothing | controller | **yes** |
| 20 | ownership REFUSE / AMBIGUOUS | carrier exits 33 / 34, launches nothing | controller | **yes** |
| 21 | lease helper missing in the checkout | both programs exit fail-closed, launch nothing | controller | **yes** |
| 22 | `--status` during a carrier-held lease | dispatcher `--status` reports the checkout lease as held by the attended program, takes no lease, writes nothing | controller | **yes** |
| 23 | one genuine cross-transport run | a real carrier hop and a real dispatched run contend on one repository; the loser refuses before launching | **actor** | **yes** |
| 24 | one genuine fan-out-two pair | two real Work Loop tasks, two worktrees, both admitted, both complete a later handoff in their bound checkout | **actor** | this is the validation D2 and the open isolation task both ask for |

**Cases 23 and 24 are the only ones that may be described as live evidence.** Everything else is
controller evidence and must be reported as such. The production-readiness record already carries the
deferral that no live dispatched run has ever been made (lines 53–56); Phase 1 is where that stops
being true, and the distinction must not blur at the moment it changes.

---

## 6. Phase 2 — task-aware worktrees (proposed, not approved)

**This section proposes replacing D4. It is not approved and must not be implemented on the strength
of this document.** D4 currently reads that a dispatched run may not create its own worktree, because
worktree creation is where the file-ownership gate lives
(`work-loop-v2-production-readiness-policy.md` 37–40, quoted in full in § 2.6). The conflict is
direct: any automatic creation moves that gate inside the automation it gates. § 10 puts the choice
to the operator.

### 6.1 What the replacement policy would say

A narrow one: **for a task that is opening and has no state file yet, the transport may create or
select its worktree deterministically, provided the file-ownership decision has already been made by
the operator and is present in the task's own scope.** D4's gate is not deleted; it moves from "the
operator performs the creation" to "the operator's ownership decision is a precondition of the
creation, checked before it happens". If that precondition cannot be checked mechanically, the
replacement fails and D4 should stand.

### 6.2 The ordering rule, which is not negotiable

**Worktree selection or creation for a new task must finish before that task's state file and its
`.owner` declaration are created.** The reason is structural: the state file's location *is* the
semantic binding (`SKILL.md` 164), so creating the file first and choosing the checkout afterwards
would mean choosing a binding that already exists. Three consequences, all of which follow from the
same rule:

- **An open task may resume only in the checkout its existing state file already binds.** Never
  elsewhere, and never in a newly created one.
- **Automation must never copy a state file between checkouts.** That produces two files claiming one
  task's truth — the failure core § 4's single interface exists to prevent, and the one
  `SKILL.md` 168 names explicitly.
- **Automation must never infer a replacement binding, or create a second one.** A replicated copy
  authorizes nobody; `work-loop-owner.sh` 278–282 already refuses on exactly this and returns
  AMBIGUOUS for the operator to settle. Automation must reach the same answer, not a cleverer one.

### 6.3 Deterministic create-versus-reuse rules

| Observed state | Action |
|---|---|
| Task has a state file in exactly one checkout | **Reuse** that checkout. Nothing is created. |
| Task has a state file in more than one checkout | **Stop.** AMBIGUOUS; the operator names the authoritative copy. |
| Task has no state file, and a declaration names it somewhere | **Stop.** A declaration without a state file is a contradiction, and `work-loop-owner.sh` 191–195 already refuses on it. |
| Task has no state file and no declaration; the target checkout is free | **Create** a worktree, then declare, then write the state file — in that order. |
| Task has no state file; the target checkout is claimed by another open task | **Create** a new worktree for this task, or stop if creation is refused for any reason below. |

### 6.4 Stops — what must refuse rather than decide

- **Dirty base.** If the base branch tip is not the known-good base the creation would use, stop.
  `new-worktree-session.md` 47–59 already defaults to `main` and stops on error rather than retrying;
  automation must be at least as conservative.
- **Ambiguity of any kind.** Every AMBIGUOUS verdict from the ownership helper is a stop, never a
  resolution. This is the same rule Claude's Step 1.5 already carries
  (`.claude/commands/work-loop-v2.md` 169).
- **Name collision.** `new-worktree-session.md` 44–45 appends `-2`, `-3`, … rather than clobbering.
  Automation keeps that, and treats a collision as worth reporting rather than silently numbering
  past.
- **Any judgment.** File-ownership decisions, whether two tasks may safely overlap, and whether
  parallelism pays are not automatable and are not proposed for automation.

### 6.5 What can be automated without hidden judgment

Only the mechanical half: computing the path and branch name from the task id, running
`git worktree add` against a verified base, writing the `.owner` declaration, and reporting what it
did. Everything in § 6.4 stops instead.

### 6.6 The session-attachment limit stays

Automation can create and prepare a worktree. It **cannot** move a session into one, and it cannot
start a session there. `new-worktree-session.md` 17–23 states the reason — a session's working
directory is fixed when its window opens — and 82–83 confirms that opening the folder does not start
a Claude session. So even a fully automatic Phase 2 leaves the operator opening the panel and running
`/prime`. **Any claim that Phase 2 makes worktree entry automatic would be false**, and the residual
manual step named at `SKILL.md` 187 would remain.

### 6.7 Extend, do not build a platform

Phase 2 should extend `/new-worktree-session` and the existing lease/declaration helpers. It should
not introduce a scheduler, a worktree registry, a manager service or a second placement authority.

---

## 7. Rollout and validation sequence

Seven steps, in order. Each one is a gate: it either produces its evidence or the sequence stops.

1. **Freeze the failure cases as failing tests** (§ 5). Nothing is implemented until the matrix runs
   red for the right reasons — a case that passes before the change is removed or rewritten.
2. **Extract the shared lease** and point the dispatcher at it. Success is the dispatcher's existing
   suite unchanged at its current count, plus § 5.4 green.
3. **Point the carrier at the shared lease** and add its ownership admission. Success is
   `carry-turn.test.sh` green with § 12b inverted, plus §§ 5.1–5.3 green.
4. **Re-run every existing suite** from a clean checkout: dispatcher, carrier, owner helper. Report
   the counts against the last recorded baselines — owner 92/0 and dispatcher 389/0, from
   `work-loop-v2-concurrent-task-isolation.md` line 20.
5. **One genuine cross-transport proof** (§ 5 case 23) — a real carrier hop and a real dispatched run
   contending on one repository, with the refusal captured.
6. **One genuine fan-out-two Work Loop pair** (§ 5 case 24) — two real tasks, two worktrees, each
   completing a later handoff in its bound checkout. This is the evidence
   `work-loop-v2-concurrent-task-isolation.md` line 36 is waiting for, and producing it would let
   that task move from "Integrated, awaiting operational validation" toward resolved. It is a
   by-product of this sequence, not a separate errand.
7. **Only then, and only with operator approval, the Phase 2 experiment** — bounded to one task, with
   every § 6.4 stop live.

**Adopt / revise / stop.**

- **Adopt Phase 1** when: every § 5 case behaves as specified; no existing suite regressed; the
  cross-transport proof refused correctly before launching; and the fan-out-two pair completed with
  no mixed edits and no mixed state.
- **Revise** when: the cases pass but the shared helper measurably complicates either transport's
  failure reporting, or an operator cannot tell from a refusal which program holds what. The remedy
  is the message, not the mechanism.
- **Stop** when: the extraction cannot preserve the dispatcher's suite, or the carrier's attended
  boundary (no worktree creation, no status, no simulated actor) cannot be kept intact. Either would
  mean the shared contract is buying safety with a boundary that was load-bearing.
- **Phase 2 adopt** only when three to five real trials show worktree setup — not task judgment and
  not landing — is the remaining operator burden. Otherwise stop, and D4 stands unchanged.

---

## 8. Risks, rollback and compatibility

| Risk | Why it is real | Mitigation |
|---|---|---|
| An open task is disrupted by the change | Open tasks hold declarations, not leases | Declarations are untouched; leases are per-run. No migration of open state is needed. |
| A checkout without the lease helper | Older worktrees and incomplete copies are exactly the ones most likely to be wrong | Fail closed, as the ownership check already does (`dispatch.sh` 2325–2335). Never skip with a visible line. |
| A stale or pinned lease blocks legitimate recovery | Pinning is deliberate and manual to clear | Keep the three-state liveness rule and the printed survivor evidence (`dispatch.sh` 706–732); never infer "stale" from a failed signal. |
| Two lock roots during the changeover | The carrier's root moves; an in-flight carry is invisible to the new code | § 4.5 constraint 1: read the legacy path read-only for one release and refuse if held. |
| An interrupted actor leaves both leases pinned | Already the designed behaviour | `--status` names what is pinned and why; clearing stays manual and evidence-based. |
| A replicated state file | Committed state files replicate across worktrees on merge | Already refused as AMBIGUOUS (`work-loop-owner.sh` 278–282). Phase 2 must not resolve it; § 6.2. |
| A human edits a state file mid-run | No lease prevents it, and none is proposed to | State the boundary, as both transports do today. `--status` before hand-editing remains the rule. |
| Exit-code collision in the carrier | New codes could shadow existing ones | Checked: `33`/`34`/`35` are unused by `carry-turn.sh` (116–158) and are already the Work Loop's ownership codes (`SKILL.md` 290, 302). |
| Phase 2 places a task wrongly | Placement is where a wrong decision is most expensive | Every ambiguity is a stop (§ 6.4); the ordering rule (§ 6.2) means a wrong placement cannot be inherited by an existing binding. |

**Rollback.** Phase 1 is one or two ordinary commits and reverts as such — the same shape recorded
for the concurrency landing (`work-loop-v2-concurrent-task-isolation.md` 22–26). Reverting restores
the carrier's `$TMPDIR` lock and removes its ownership admission, which returns the repository to
today's known state rather than to an unknown one. Phase 2, if ever approved, must be revertible
without touching any task's binding — it creates checkouts, and a revert must leave every created
worktree and every state file exactly where it is.

---

## 9. Deferred and rejected

**Deferred** — good, not now, with the trigger that would reopen each:

| Item | Trigger |
|---|---|
| Serialized state writer / compare-and-swap state API | One reproduced lost update that both leases plus the existing hash and turn validation could not stop. |
| Structural-file lease (per-path ownership) | Repeated same-path conflicts after two-lease enforcement and per-task path scopes are in real use. |
| Fan-out above 2 | D2 caps at 2 on one demonstration. Raising it needs demonstrations, not an argument. |
| Repo-wide log namespacing | Only one ambient writer is proven; a broad migration costs more than the measured problem. |

**Rejected for this work** — not deferred, out of scope by design:

- A general session manager or concurrency scheduler.
- A repository-wide lease database, task registry or persistent lock store.
- Automatic priority or scope decisions of any kind.
- Automatic merge, landing or conflict resolution.
- Automatic destructive cleanup — worktree removal, branch deletion, push.
- **The workspace-wide concurrency problem for sessions not using Work Loop v2.** Adjacent, real, and
  a different problem. Work Loop task ownership must not quietly become the workspace's session
  manager; that is what would happen if this proposal tried to cover it.

---

## 10. Operator decisions

Only the genuine authority and risk choices. Everything else in this document is design, and the
implementation unit can settle it.

1. **Approve Phase 1 as scoped?** One shared lease used by both transports, plus fail-closed
   ownership admission in the attended carrier, with the two Work Loop instruction edits in § 1.
   *Recommendation: yes.* It consolidates a proven mechanism and closes the one gap neither program
   can see.

2. **Retain D4, or approve the narrow Phase 2 replacement?** D4 currently forbids a dispatched run
   creating its own worktree because that is where the file-ownership gate lives. Phase 2 as
   described in § 6 would replace it with a precondition-checked automatic creation, bounded by the
   ordering rule and the stops. *Recommendation: retain D4 for now, and revisit only after step 6 of
   § 7 produces real evidence about where operator burden actually sits.* This is the only settled
   decision this document would reopen, and reopening it is not required for Phase 1.

3. **Authorize the live runs in steps 5 and 6?** Both need real actors on a real repository. The
   production-readiness record carries a standing deferral that no live dispatched run has ever been
   made, and it explicitly does not authorize one (lines 53–56). *Recommendation: yes, bounded to the
   two named runs*, because controller evidence cannot establish what those two steps exist to
   establish.

4. **Accept the changeover window, or require a quiet repository?** § 4.5 constraint 1 proposes
   reading the legacy carrier lock path for one release. The alternative is a rule that no carry may
   be in flight when the change lands. *Recommendation: take the legacy read.* It is a few lines and
   it does not depend on anyone remembering a rule.

5. **Accept that the interactive same-task limitation stays open?** Two interactive sessions on one
   checkout for the same task, and an operator proceeding past a refusal, remain unprevented
   (§ 3 F5). *Recommendation: accept and keep it stated.* Closing it means enforcing instructions on
   a live session, which is a different problem and a larger one.
