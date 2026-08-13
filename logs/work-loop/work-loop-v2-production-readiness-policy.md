---
task: work-loop-v2-production-readiness-policy
turn: operator
---

## Outcome

The production operating policy for unattended multi-Work-Loop operation is settled, and the three
implementation units it still required are built. Unattended runs are contained by launch profile
rather than by a hook edit; a dispatched run now initializes its own session identity before hop 1,
so the staging tripwire is armed with that run's own footprint instead of a stranger's; both entry
paths into a worktree are documented; and the closed parallel-worktree proof no longer misdescribes
the guard mechanism it recorded.

The discovery's own recommendation was amended before execution. Its § 3 rule 4 proposed editing
`.claude/hooks/log-write-activity.sh` to suppress write-activity telemetry for dispatched actors —
the plan's only structural change class and its only risk-aware-review gate. That edit was dropped:
commit `9c66f26` (2026-08-07, one day after the discovery was written) gave the dispatcher
`--unattended`, which launches the Claude child with `"disableAllHooks": true`. The ambient shared
writer cannot fire inside a contained hop, so the hook edit would have bought nothing and cost a
structural-class review. The rule became a launch precondition instead.

## Decisions that matter

- **D1 — shared writer (`logs/friction-log.md`): AMENDED, not as recommended.** The discovery
  recommended option A1 (suppress the hook for dispatched actors). Replaced by a launch precondition:
  **dispatched runs use `--unattended`**, whose contained profile disables the child's hooks
  entirely. No hook file is edited, no structural change class is entered, and interactive sessions
  keep the breadcrumb unchanged. The A2 fallback (untracked telemetry reconciled at landing) is not
  needed and is not adopted.
- **D2 — fan-out ceiling: cap at 2, as recommended.** Two is the only fan-out ever demonstrated, once
  (`logs/work-loop/work-loop-v2-parallel-worktree-proof.md`). A higher cap would be an unevidenced
  claim.
- **D3 — the dispatcher does not graduate out of `plans/`, as recommended.** It stays a tracked
  script invoked by explicit path. Installing it as a command would create a new-command structural
  class and a maintained surface on one live run of demand evidence.
- **D4 — a dispatched run may not create its own worktree, as recommended.** The operator creates the
  worktree, because worktree creation is where the file-ownership gate lives
  (`docs/parallel-sessions-playbook.md` § 1 gate 1). Automating it would move the playbook's hard gate
  inside the automation it gates.
- **D5 — the closed proof record is corrected, as recommended.** A closed record is evidence; leaving
  a wrong mechanism inside it invites the next reader to design against a code path that does not
  exist.
- **Implementation units: U1, U3, U4 and U5 executed; U2 dropped.** U2 was the `log-write-activity.sh`
  edit, superseded by D1's amendment. With it went the plan's only risk-aware-review requirement.
- **U1's failure mode was corrected during implementation.** The first version of the identity init
  exited 32 when `logs/scripts/prime-session-entry.sh` was absent. Every fixture checkout in the
  spike's own harness lacks that script, so the harness fell from `pass=368 fail=0` to
  `pass=177 fail=138` — caused entirely by the edit, not by the environment. A checkout without the
  allocator carries no `/prime` guard infrastructure to arm, so it now skips the init with a visible
  line. Exit 32 is reserved for a checkout that **has** the allocator and cannot finish the init,
  which is the genuinely dangerous half-state.
- **Deferral — no live dispatched run was made.** Every check here is simulated (`--actor-cmd`) or
  run against a throwaway clone. A live `--unattended` run against a real worktree remains separately
  authorized work, and this task does not authorize it. Reason: the brief excluded live model
  launches, and the amendment does not widen that.
- **Deferral — the identity init writes to a tracked shared log.** The init appends this run's header
  and footprint bullet to `logs/session-notes.md`, which is added to the run's allowlist so the
  dispatcher does not stop on its own write. Two concurrent dispatched runs therefore both append to
  that tracked file — the same merge-time content-conflict shape D1 removed for `friction-log.md`,
  at much lower frequency (two lines per run, not one per Write). Reason: the marker sequence and the
  header are what keep a headless run visible to every other session's guards, so suppressing them
  would trade a small merge cost for invisibility.

## Evidence

- **U1 — headless session identity** (`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`,
  `init_session_identity()`, called once before hop 1). Red/green on one fresh clone of this repo:
  the dispatcher at `HEAD` left `logs/.session-marker` **absent**; the edited dispatcher wrote
  `2026-08-09 S1-82a` and one `- Files in scope:` bullet under that run's own header in
  `logs/session-notes.md`, verified by a block-scoped read that mirrors the guard's own anchor. A
  second invocation reported `identity: reusing marker …` and allocated no second marker.
- **U1 regression protection.** The spike's own harness, same machine and shell:
  control (dispatcher at `HEAD`) `pass=368 fail=0`; edited dispatcher `pass=368 fail=0`. The delta is
  zero. The intermediate `pass=177 fail=138` run is retained above as the failing case, because it
  was produced by the first version of this change rather than by the environment.
- **U3 — both entry paths documented** (`docs/parallel-sessions-playbook.md` § 4 step 3). Before, the
  step named only the interactive VS Code + `/prime` entry, which is why the parallel proof had to
  book its own entry as a by-design divergence. It now names two, and states that the dispatched one
  does not route through `/prime` and initializes identity itself.
- **U4 — dispatcher header** (`dispatch.sh` line 13). Before: "Scope: single task, single checkout,
  serial. NOT multi-loop." Now: "serial PER INSTANCE", with multi-loop described as one instance per
  task per linked worktree, proven once at fan-out 2. `--help` prints exit codes 25 and 32; the
  truncation this unit inherited as a defect was already fixed on 2026-08-05, so only the header line
  remained.
- **U5 — proof-record correction**
  (`logs/work-loop/work-loop-v2-parallel-worktree-proof.md`, § Decisions that matter). The record
  said the guard "fell back to the newest entry in `logs/session-notes.md`". No such scan exists in
  `.claude/hooks/check-foreign-staging.sh`: the header match is anchored to both the marker's date and
  its S-number (lines 508–509) and gated on `sess and sess_date` (line 492). The real mechanism is the
  shared-marker fallback (lines 393–399). The bullet now names it, with a dated correction note.
- **Independent verification of the discovery's own findings:**
  `audits/working/research-work-loop-v2-readiness-verdict-2026-08-09.md` — all eight checked items
  re-opened against live files, seven HOLD, one CHANGED (`--help`, already fixed upstream), plus the
  `9c66f26` finding that superseded D1.

## Accepted limitations

- **This task did not close through the Work Loop's normal assessment path.** Core § 3 step 5 assigns
  the close verdict to Codex; the state file was at `turn: codex` awaiting exactly that. The operator
  directed that Codex not be used, and an independent research pass replaced the assessment. That is
  the operator exercising their own authority over priorities, not a Codex verdict — nothing in this
  record should be read as one, and the protocol itself is unchanged.
- The policy rests on one live two-worktree observation. Fan-out above 2, landing of co-edited
  content, and Codex-side permission denial under parallel operation remain untested.
- `--unattended` applies and logs the **requested** policy. Array-valued settings keys merge across
  scopes, so another settings scope on a given machine can widen what a child may read; only a live
  check from inside the child establishes the effective policy.
- The identity init has been exercised only with a simulated actor. It has never run ahead of a live
  Claude or Codex child.
