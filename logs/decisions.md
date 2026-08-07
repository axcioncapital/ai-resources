# Decision Journal

> Archive: [decisions-archive-2026-08.md](decisions-archive-2026-08.md)

## 2026-08-07 — Multi-hop unattended loop mode is an approved courier under core § 4; no amendment needed

**Context:** `unattended-operation-plan-v0.2.md` schedules a walk-away run in which `dispatch.sh`
alternates Claude and Codex without the operator present. A multi-hop courier *looks* like a larger
thing than the one-hop `--carry-one` courier the core § 4 clause was written beside, so whether it is
still covered had to be settled before the safety work was built on top of it.

**Decision:** Loop mode is an approved courier under core § 4 as written. **The core is not amended**
and `turn: operator` stays terminal for all automation.

**Rationale:** Core § 4
(`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:194-215`) forbids a courier from four
things, and loop mode does none of them: it never changes state-file content (the dispatcher writes
that file at no point); it never chooses which actor moves next (it launches whoever `turn:` already
names); it never continues past `turn: operator` (`dispatch.sh` stops dead there); and its exit code
is explicitly not authoritative over the file. The clause's own test — *does removing the courier
change any decision?* — is passed: remove it and the operator pastes the same turns by hand, and the
same decisions get made by the same parties. Hop count is not one of the clause's dimensions, so
carrying twelve hops is the same act as carrying one, twelve times.

**What this does NOT license.** Choosing the next *task* once the current one's exit condition is met
is judgment, not transport, and core § 4 does not cover it. That is the deferred supervisor, and it
needs its own qualification through `/develop-ai-resource` — including the outcome *no build*. Note
that this gap is narrower than it first appears: a task spans many units and Codex already opens the
next unit itself (`SKILL.md` § Assessing the result, core § 3 *Continuing*), so a single task can
fill a 40-minute absence with no supervisor involved.

**Alternatives considered:**
1. **Amend core § 4 to name multi-hop couriers explicitly.** Rejected: the clause is written in terms
   of what a courier may not *do*, not how many times it may act. Adding a hop dimension would make
   the clause longer without making it stricter, and would invite the reading that some hop count
   requires re-approval.
2. **Treat loop mode as outside the clause and gate it behind a new approval.** Rejected: it would
   create a second courier doctrine for what is mechanically the same act, and the existing clause
   already carries the test that settles it.

**Related:** `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` § Scope;
`runs/probe-interruption-2026-08-07.md` (the stop control this decision assumes);
the 2026-08-06 entry above (courier drives the dispatcher, not Claude's UI).

## 2026-08-07 — Contained-profile Git access: allow the minimum config paths (option A)

**Context.** Work Loop v2 item 1d's operator-ratified contained profile (`denyRead: ["~/"]`) was
wired into the dispatcher as `--unattended` and measured from inside a live dispatcher-launched
child. The measurement found the profile also broke Git: Git reads `~/.gitconfig` on every
invocation, the sandbox refused the read, and Git exited 128 **before touching the repository**. A
follow-up check (6b) established the repository itself was reachable all along — `allowRead` was
working, and Git's config discovery was the only obstacle.

**Decision.** Allow the minimum Git configuration paths and broaden home access no further. Chosen
option: **A** — add `~/.gitconfig` alone to `sandbox.filesystem.allowRead`. `~/.config/git/config`
was considered and not added; the live probe confirmed Git needed no further help once the one file
was readable.

**Alternatives considered and rejected:**
- **B — supply Git identity at launch instead of reading it.** Neutralise config discovery
  (`GIT_CONFIG_GLOBAL=/dev/null`) and pass identity via `GIT_AUTHOR_*`/`GIT_COMMITTER_*` environment
  variables. Grants no new filesystem read at all. Rejected on evidence, not preference: this
  repository's Git identity (`user.name`/`user.email`) is set **only** in the global config —
  `git config --local --get user.email` is empty — so a child launched this way would have no Git
  identity, and Work Loop core § 4 has Claude commit every hop. Every hop's commit would fail.
- **C — decide the profile is right and the loop is wrong.** An unattended child should not commit
  at all; the dispatcher should carry commits itself. Named as an option, not recommended: it is a
  materially larger change and would reopen core § 4's "Claude commits" assignment, which is settled
  authority outside this unit's scope.

**Rationale.** A is the smallest change, keeps commit authorship truthful (the child that did the
work is the child whose identity signs the commit), and re-opens one named file rather than a
directory tree. The exception was guarded at both ends rather than merely implemented: live checks
confirm `~/.gitconfig` is readable **and** `~/.config` remains refused; the simulated suite asserts
no widening pattern appears in `allowRead` and the entry count stays at exactly three. A dedicated
harness case (32m) was added specifically because the ordinary red/green regression pair does not
exercise these guards — they sit inside a branch the pre-change dispatcher never enters — so a
mutated-profile check was needed to prove the guards can actually fail.

**Residual risk, accepted with a standing condition.** `~/.gitconfig` also names credential-helper
commands (`gh auth git-credential`). The live child could read that a GitHub credential path is
configured but could not obtain a token — `gh`'s own credentials live under the still-denied
`~/.config/gh/`, confirmed by direct measurement inside the child, not by inference. **If a real
secret is ever placed in `~/.gitconfig`, this exception stops being safe and must be revisited** —
recorded at the exception in `dispatch.sh` itself, not only here, so the condition travels with the
code.

**Related:** `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` § 1d;
`plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-unattended-integration-2026-08-07.md`;
`logs/work-loop/work-loop-v2-contained-unattended-profile.md` (the closed Work Loop task).

## 2026-08-07 — Codex thread handoff is a tracked skill using a fresh task

**Context.** The operator requested a Codex command that hands the current work
to a new Codex thread. This need already appears in two durable surfaces:
Claude's `/handoff` command handles session transfer on the Claude side, and
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`
§ 4.7c requires a clean handoff when a new Codex task deliberately takes over.
Codex custom prompts are deprecated and local `source-command-*` mirrors are
deliberately ignored in this repository, so neither is a durable shared home.

**Decision.** Adopt `.agents/skills/handoff-thread/` as a tracked Codex skill.
It creates one fresh task through `create_thread` and supplies a concise,
self-contained five-field Brief. The Brief preserves the governing project,
workflow position, ordered authority paths, settled state and exact next
action. The receiving task verifies its working directory and re-reads the
original plans, specifications and implementation sources before acting; the
Brief navigates to authority rather than replacing it. The skill does not use
`fork_thread`, which copies conversation history, or `handoff_thread`, which
moves an existing task between execution locations.

**Complexity-budget answers.**

1. **Failure prevented:** a fresh Codex task starts without the active
   instruction, settled constraints, key paths, or exact next action.
2. **Likelihood:** the need exists in both the established Claude handoff
   workflow and the Codex fresh-task contract, and the operator requested the
   missing Codex action directly.
3. **Cost:** one small skill in trigger metadata and, per invocation, one
   project lookup, bounded read-only authority resolution, and one
   task-creation call. It writes no handoff artifact.
4. **Conditionality:** it fires only on an explicit new-task request or an
   explicit `$handoff-thread` invocation.
5. **Existing coverage:** Claude `/handoff` cannot create a Codex task; ignored
   source-command mirrors are unmaintained; the Codex thread tools provide the
   action but not the reusable context-transfer contract.

**Invocation path.** Natural-language requests such as "hand this task off to
a new Codex thread" trigger the skill, and `$handoff-thread` remains the
explicit route. It is therefore not dependent on remembering an unwired slash
command.

**Reversibility and blast radius.** Removal is one skill subtree plus its
single `.gitignore` re-include. Runtime authority is limited to creating the
user-requested task; it changes no files, Git refs, permissions, models, or
existing threads. The Brief stays within a five-field ceiling. Repository state
remains event-driven under its governing workflow; the handoff creates no
snapshot, checkpoint, progress log, or diary.
