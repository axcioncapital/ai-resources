---
task: axcion-harness-v0-2-readiness-fixes
turn: codex
---

## Objective and scope

Bring the canonical attended Axcíon Harness v0.2 launcher to the supervised-readiness boundary the
operator approved on 2026-08-13, using bounded units that are independently implemented and assessed.

The task covers the still-current parts of the 2026-08-11 readiness assessment on the canonical
attended surface: checkout-wide single-writer enforcement, deterministic and honest post-hop outcome
classification, default prevention of nested AI expansion, and proportionate supervised adoption
evidence. It excludes unattended operation, external actions, automatic push or merge, strategic
routing, portfolio scheduling, a dispatcher rewrite, and permission widening such as `acceptEdits`
unless the operator separately authorises it.

The named task exit condition is: every retained supervised-readiness requirement has either been
implemented and accepted with fail-capable evidence, or explicitly disposed of from current
repository evidence; the required live supervised trials have produced an explicit adopt, revise,
continue-trial, or stop decision; and no result claims unattended readiness.

## Lane and unit

Standard. Implementation mode. Unit 1 — enforce one live carrier writer per checkout on the
canonical attended launcher, regardless of task identity.

Named reason for the loop: the full readiness task spans several independently assessable changes
and live trials, must survive multiple Claude/Codex turns, needs strict boundaries to avoid a broad
launcher rewrite, and requires assessment by Codex rather than acceptance by its implementer.

## Brief

Why this unit, why now: the operator has approved the canonical attended launcher as the target and
authorised beginning with checkout-wide writer isolation. This is the first retained release blocker
because the current product surface must prevent two different tasks from concurrently writing one
checkout before later recovery and adoption work is meaningful.

**Required outcome.** A live invocation of the canonical attended carrier holds write authority for
its checkout as a whole. While it is live, another invocation for a different task in the same
checkout must stop before actor launch; an invocation in a separate linked worktree must remain
independently admissible. Preserve exact task/state identity checks as a separate invariant.

**Governing authority and source disposition.**

- The operator's 2026-08-13 decision governs: use one Work Loop task, target the canonical attended
  launcher, and begin with checkout-wide single-writer isolation.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs Work Loop roles, state,
  evidence, and handback semantics; Claude owns repository reality and every commit.
- `plans/axcion-harness-v0.2/mvp-plan.md` is relevant project direction but retains a proposed/no-
  implementation header. Use its attended-only boundary as background consistent with the current
  operator decision; do not promote the whole mutable document to approved authority.
- `plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`
  is non-governing assessment material: its Priority 1 outcome and acceptance shapes inform this
  unit, but its own header says it authorises no implementation.
- `logs/work-loop/work-loop-v2-concurrent-task-isolation.md` is authoritative current evidence for
  the repository-level checkout declaration mechanism already landed. It does not by itself prove
  that the canonical carrier's live lock is checkout-wide.

**Check against the repository before acting.**

1. Verify in `scripts/axcion-harness-v0.2/carry-turn.sh` that the live lock identity currently
   includes both canonical checkout and task, and demonstrate through the existing test seam that
   two different task ids can therefore be admitted concurrently in the same checkout. If either
   claim is false, hand back the evidence without implementing the presumed fix.
2. Inspect `scripts/axcion-harness-v0.2/carry-turn.test.sh` and the launcher code to identify the
   existing lock, exact-task identity, stale-lock, and separate-checkout coverage. State which
   existing fixtures can be extended; do not construct a second harness when the existing one is
   sufficient.
3. Inspect `logs/scripts/work-loop-owner.sh` only as needed to preserve the distinction between the
   durable checkout declaration and the carrier's live-process lock. Do not merge those two
   responsibilities or create a registry.

**Scope.** Change only:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this task state file

The implementation mechanism is Claude's decision. Prefer the least-complex change that makes the
live ownership key checkout-wide while retaining task identity in validation and evidence. Do not
add a daemon, queue, registry, hook, session marker, second state system, automatic worktree
creation, or destructive lock cleanup.

**Codex framing decisions and held-back work.** Unit 1 deliberately excludes post-hop outcome
classification, parsing `permission_denials`, partial-effect reporting, nested-agent controls,
permission-mode changes, documentation cleanup, and live adoption trials. They remain adjacent task
work but are held back because combining them would create several dominant deliverables and weaken
failure attribution. Do not edit the old spike dispatcher; this unit protects the canonical
attended product surface the operator chose.

**Required fail-capable evidence.** Show the failing case before the change and the result after it,
using the real carrier lock path through the existing test harness:

1. task A live in checkout X causes task B in the same checkout X to stop before actor launch;
2. task A in checkout X and task B in a separate linked worktree Y can both acquire their respective
   checkout locks;
3. the existing same-task live-lock refusal still passes;
4. an uninspectable lock fails safely without automatic deletion or destructive cleanup advice;
5. a positively established stale lock remains recoverable under the launcher's intended policy;
6. the full canonical launcher test suite passes.

Report the exact commands, exit statuses, relevant output, and the pre-change failure that would
have caught this defect. Report changed files and the commit id. Evidence from the old spike's suite
does not substitute for the canonical launcher suite.

**Completion condition.** Implement and commit one bounded checkout-wide live-writer correction on
the canonical attended launcher, with the evidence above; update this file with the result, set
`turn: codex`, and stop. Do not begin Unit 2.

**Stop conditions.** Hand back to Codex without improvising if the live-lock premise is false, if a
separate linked-worktree proof cannot be produced with the existing test surface, or if the change
requires paths outside scope. Stop for the operator if it would reopen a settled permission policy,
change the attended-only release boundary, or require destructive treatment of ambiguous lock state.

## Latest result

Inspected (2026-08-13):

- Claim (1): HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.sh` `acquire_lock`; the pre-change
  key was `key="$(printf '%s|%s' "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"`, so both the
  canonical checkout and the task id were in the live lock identity. Demonstrated the consequence
  through the real carrier lock path, no lock planted: a genuine carry for `task-a` was launched with
  a slow fake actor and, while its actor was provably running, a second carry for `task-b` in the
  **same** checkout returned `exit=0`, `RESULT outcome=CARRIED`, `task-b actor invocations: 1`. Two
  different task ids were admitted concurrently in one checkout.
- Claim (2): HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.test.sh` end to end. Existing
  coverage found: section 12 (live-holder refusal, provably stale lock cleared, uninspectable lock
  treated as held), sections 2–3 (task-id safety, `task:`-frontmatter identity mismatch, exit 14),
  section 11 (repository ambiguity). Separate-checkout coverage: searched the whole suite for
  `worktree` — the only matches are the `--worktree` entry in the section 7 refusal list, so no
  linked-worktree fixture existed. Section 12's fixture and `mkfix` were sufficient to extend; no
  second harness was built.
- Claim (3): HOLDS — read `logs/scripts/work-loop-owner.sh`; its declaration is the committed
  in-checkout file `logs/work-loop/.owner` (`OWNER_REL`, line 61) guarded by a short mkdir mutation
  lock at `logs/work-loop/.owner.lock` (line 337). The carrier's lock is an ephemeral `$TMPDIR`
  directory keyed by a hash. Different lifetime, different location, different purpose; kept separate,
  and no registry was created.

Result: the canonical attended launcher now takes its live write authority per **checkout**, not per
checkout+task. `acquire_lock` keys the lock on the canonical checkout path alone and records the
holding task id inside the lock directory (`$LOCK_DIR/task`) instead of in the key, so a refusal names
which task holds the checkout while task identity leaves the ownership decision. Exact task/state
identity is untouched and still enforced separately by `validate_state` (exit 14). A separate linked
worktree canonicalizes to a different path, takes a different lock, and stays independently
admissible. Also corrected in the same refusal message: the pre-change text interpolated `$LOCK_DIR`
after it had been cleared to `""`, so the exit-17 message never printed the lock path it named.

Evidence (all commands run from the repository root; the canonical launcher suite only — no spike):

1. **Different task, same checkout, stops before actor launch.** Live end-to-end through the real
   lock path, no planted lock. Before the change: `task-b exit=0`, `RESULT outcome=CARRIED code=0
   task=task-b`, `task-b actor invocations: 1`. After the change: `task-b exit=17`, `RESULT
   outcome=STOPPED code=17 task=task-b ... actor=none`, `task-b actor invocations: 0`, message
   `another carry is in flight for this CHECKOUT (pid 56788, task 'task-a', holds
   /var/folders/.../axcion-harness-v0.2.8256ed701ca9c072.lock)`. Held as suite cases
   `a DIFFERENT task in the same checkout is refused (17)` and `and stopped BEFORE actor launch`.
2. **Separate linked worktree stays admissible.** New suite section 12b creates a real worktree with
   `git worktree add -b wt-lane`. While checkout X's lock is held, the carry inside worktree Y returns
   `exit=0` / `RESULT outcome=CARRIED code=0` and its actor runs once, and X's lock is still held and
   still refusing afterwards (`checkout X is still refused after the worktree carry (17)`).
3. **Same-task live-lock refusal still passes.** Section 12 `a live lock holder blocks the carry (17)`
   — still 17, nothing launched, lock survives, and it now also names the holding task.
4. **Uninspectable lock fails safely, with no automatic deletion.** Section 12 `an uninspectable lock
   is treated as held (17)`, plus new assertions `and is NOT deleted` and `and says nothing was
   deleted`. The message advises hand inspection and never advises destructive cleanup.
5. **Positively established stale lock stays recoverable.** Section 12 `a provably stale lock is
   cleared and the carry runs` — exit 0, `removing a stale lock`. Policy unchanged.
6. **Full canonical launcher suite passes.** `./scripts/axcion-harness-v0.2/carry-turn.test.sh` →
   exit 0, `passed: 116   failed: 0` (was 100 assertions before this unit).

Fail-capability: `./scripts/axcion-harness-v0.2/carry-turn.test.sh --prove-failure` → exit 0,
`passed: 7   failed: 0`. New mutant **M6** restores the pre-change key `checkout|task` on a copy of
the launcher and re-runs only the two new checkout-wide assertions, which must fail — they do:
`wanted '17', got '0'` and `wanted '0', got '1'` (the actor launched). M6 is the pre-change failure
that would have caught this defect. M1–M5 still fail correctly, so no existing invariant went idle.

Changed files: `scripts/axcion-harness-v0.2/carry-turn.sh`,
`scripts/axcion-harness-v0.2/carry-turn.test.sh`, and this state file. Nothing else was edited. The
commit carrying this record has the subject
`fix: carry-turn.sh — live writer lock is checkout-wide, not per task`; `git log -1` resolves its id.

Deferrals noticed during the unit, recorded and not done:

- The repository's write-activity hook appends to `logs/friction-log.md` on every file edit. That path
  is outside the launcher's default `--allow-path` set (`^logs/work-loop/`, `^logs/harness-runs/`), so
  a live attended hop that edits any file will leave an out-of-allowlist working-tree change and be
  reported as exit 24 unless the operator widens `--allow-path`. Not touched here: it is launcher
  operating configuration, not the lock, and changing the default allowlist is a separate decision.
  Left uncommitted in the working tree for the same reason — the brief's scope names three files.
- `${TMPDIR:-/tmp}/...` yields a double slash in the printed lock path when `TMPDIR` ends in `/`
  (visible above). Cosmetic only, pre-existing, and the path still resolves.

## Blocker

None.

## Next action

Codex: assess Unit 1 — checkout-wide live-writer enforcement on the canonical attended launcher, with
the evidence above. Decide close, continue to the next readiness unit, correct once, or stop.
