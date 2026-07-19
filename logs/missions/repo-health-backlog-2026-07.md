---
mission_id: repo-health-backlog-2026-07
mission_name: ai-resources repo-health backlog — 10 verified items (2026-07-18)
status: active            # active | paused | completed
started: 2026-07-18
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded per `/mission create` (Step 2), drafted from session context on operator request.
  Frozen at creation: Goal / In-Out scope / Validation contract are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` change.

  PROVENANCE — this mission's threads are NOT copied from the backlog logs. Every thread below
  survived an independent five-agent verification pass on 2026-07-18 that re-checked each
  candidate against the LIVE FILES, discarding anything already fixed, mis-attributed, or
  lacking a named consequence. 22 candidates in, 10 out. Verification notes:
    audits/working/verify-cluster-A-2026-07-18.md   (markers, hooks, liveness)
    audits/working/verify-cluster-B-2026-07-18.md   (commands and scripts)
    audits/working/verify-cluster-C-2026-07-18.md   (log formats, parsers, bloat)
    audits/working/verify-cluster-D-2026-07-18.md   (permissions and settings)
    audits/working/verify-cluster-E-2026-07-18.md   (improvement opportunities)

  DELIBERATELY NOT INCLUDED — verified and dropped, do not re-raise without new evidence:
    · marker-allocator collisions (session-id suffix in the marker NAME made them impossible;
      the 4 logged collisions all predate that fix)
    · /prime allocator glob crash (code removed 2026-07-18)
    · /risk-check wrong-checkout (fixed 2026-07-15, commit 3179771)
    · /prime pull --rebase conflict (behind-check + mid-rebase handling both present)
    · run-manifest.sh dropping decision refs (traced through all 5 stages; works)
    · committed conflict markers (cleaned 2026-07-17; entry blamed the wrong command)
    · ai-resources permission drift "causing prompts" (bypassPermissions on line 9 of the
      same file; zero prompts — this was a FALSE HIGH in the 2026-07-17 friday-checkup)
    · check-foreign-staging.sh fail-open (fixed 2026-07-18, commit 979ed01)
    · session-notes.md over threshold (resolved by the 2026-07-18 archival)
    · id-46 void closure (already closed 2026-07-13)
    · ~/.claude/settings.json "model" field — operator-DECLINED 2026-07-13, do not re-raise
-->

## Goal

The ten verified repo-health defects and improvement gaps listed under `## Open threads` are each either fixed and verified by execution, or explicitly closed with a recorded reason — so that (a) `/prime`'s orientation scan surfaces the real backlog at a bounded cost, (b) the concurrency-safety layer survives a fresh clone, and (c) the audit tooling that feeds this backlog stops emitting findings that are false, stale, or mis-attributed.

## In scope / Out of scope

- **In:** `ai-resources` — its `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `docs/`, `logs/`, `logs/scripts/`, `audits/working/`, and the hook-wiring surface in `~/.claude/settings.json` insofar as it governs ai-resources sessions.
- **Out:** the workspace root and the 24 project repos under `projects/` (except where a thread names a specific file there); research and advisory content; the research-workflow deploy mission (`research-workflow-deploy-fitness`) — a separate active mission; any item on the DELIBERATELY-NOT-INCLUDED list above.

## Validation contract

> Written at mission creation, before any implementation session, so a fresh-context check can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — must ALL be true when the mission is complete:
- [ ] The `/prime` Step 3 improvement-log scan returns under 40 lines, and no hit in its output sits on an entry whose status is applied / resolved / declined.
- [ ] Every entry in `logs/improvement-log.md` is reachable by the Step 3 scan, or is provably out of its intended scope by a stated rule — verified by a count, not an assertion.
- [ ] A fresh clone of this workspace onto a new machine has every hook that fires today, firing — demonstrated by execution on a real second checkout, not by reading the settings file.
- [ ] `git checkout` runs without a permission block in a normal session.
- [ ] A mission thread can be ticked off through a sanctioned path that does not require a hand-edit the mission contract forbids.
- [ ] Each of the ten threads is closed with either an execution-verified fix or a recorded decline reason. No thread is closed by assertion alone.

**Non-negotiables** — boundaries no session may cross:
- **Verify by execution, not by reading.** Every claim that a thread is fixed must cite a command and its output, or a file:line re-read. This mission exists partly *because* logged claims went stale unnoticed; it must not add more.
- **No new gate to solve a discipline problem.** Threads 7 and 9 are about verification behaviour; the countermeasure that has worked here is an adversary told to distrust the author, not another checklist.
- **Do not widen scope into the projects.** A thread that turns out to live in another repo is surfaced and routed, never reached into.
- **Structural fix as default style; ROI decides scope.** A thread that does not earn a structural fix is parked with a reason, not patched.
- **Close the log entry when the fix lands.** Several threads here exist only because a shipped fix never had its log entry flipped. Flipping the entry is part of the fix, not follow-up.

**Off-mission signals** — what drift looks like for THIS mission:
- Editing research-workflow or project content.
- Building a new command, agent, or hook where an existing one needed a fix.
- Re-opening anything on the DELIBERATELY-NOT-INCLUDED list without new execution evidence.
- Reporting a thread complete without a cited command or file:line.

## Open threads

> **TRUTH-PASS 2026-07-19 (S6-e72) — the list was cut from 11 open to 5, and the tick deadlock that caused the circling is removed.**
>
> The operator reported "going in circles." The measurement confirmed it: this mission consumed **12 sessions in 2 days**, and a fresh-context verification pass over all 11 open threads found **5 already finished** — four of which *said so in their own text* and were left unticked anyway.
>
> **The cause was this file's own standing instruction**, which forbade ticking until `/mission check` was fixed (thread 12). But `/prime` Step 1d (`prime.md:188`, `:249`) builds its task menu from **unchecked `- [ ]` lines only** — so an un-ticked finished thread is re-offered at every session start, gets picked, and burns a slot before someone notices it is done. That happened in three consecutive sessions (threads 5, 11, 14). The filter was never broken; the contract was jamming it.
>
> **Closed threads are compressed to one line plus their closure evidence.** Full detail lives in `logs/improvement-log.md` and git history — it is not lost, and this file is meant to be read at every orientation.

### Completion rule — REPLACES the former "the tick is not mine to make" note

A thread is ticked when its closure cites **evidence of execution** — a commit hash, a live file:line, or a test result. The tick records *what was verified*, and the citation is the deliverable.

`/mission check` remains defective (thread 12: it flips the checkbox without ever opening the `## Validation contract`) and is **not** the required path. A tick delivered through `/mission update` **with cited evidence is better-evidenced than a `check` tick**, not worse — `check`'s defect is precisely that it ticks *without* evidence. Waiting for `check` to be fixed before recording finished work is what produced the circling, and it cost more than an unverified tick ever would.

**Two standing requirements for any thread on this list:**

1. **State what breaks if it is never fixed** — one concrete sentence. A thread that cannot name a consequence is not a backlog item; close it. (Repo materiality bar: annoyance is not a consequence.)
2. **Do not trust a line citation without re-deriving it.** The truth-pass found **four threads citing lines that no longer resolve.** On thread 15 the named prose at `:221` is gone and `:224` now holds load-bearing rationale that a literal edit *would have destroyed*. Re-derive every citation against the live file before acting on it.

---

### Open — actionable now

- [ ] **3. [BROKEN] Hook wiring is unversioned — a fresh clone silently loses the concurrency-safety layer.** `~/.claude` is not a git repo; 7 hook registrations and `cleanup-session-marker.sh`'s body exist only there. **What breaks:** a new machine gets the scripts sitting in `.claude/hooks/` looking installed, with nothing firing them and no error — silently un-shipping this mission's own landed fixes. **Prior art:** an installer design scored High/High on `/risk-check` twice; it needs a timestamped backup of `~/.claude/settings.json` and a **deep merge** preserving unrelated registrations *inside* the `hooks` object (the two `afplay` entries), not merely unrelated top-level keys. Test against a fixture `$HOME`, then prove firing from a second checkout.

- [ ] **7. [IMPROVE] The two reviewer agents that actually decide things lack the premise-check antibody.** Verified live: `triage-reviewer:51` carries the *verbatim inverse* ("note it as an assumption rather than launching a search") and decides what leaves the queue; `scope-qc-evaluator` returns **zero** hits for verify/re-derive/filesystem language while issuing five-way build/park verdicts. **What breaks:** a fabricated count leaves the triage queue or earns a build verdict with nobody re-deriving it — the failure already logged at higher authority when `system-owner` invented a count indistinguishable in tone from its true findings. **Scope:** require re-derivation of load-bearing current-state, count, path, and absence claims. `refinement-reviewer` and `expert-check-reviewer` are explicitly **out** — narrower jobs where blanket investigation duplicates QC. Closes thread 9 by construction.

- [ ] **10. [BROKEN] Repo-mutating commands read the repo at rest instead of checking liveness.** Verified: `/permission-sweep` mutates settings workspace-wide and has **zero** liveness references; 10 of 12 mutating commands are the same. **What breaks:** a repo-wide sweep overwrites a concurrent session's uncommitted settings edits — unstaged, and therefore unrecoverable. **Shape:** ONE shared pre-flight called by the few commands that write repo-wide, `/permission-sweep` first — *not* a liveness gate in ten commands. Verify the 9 unconfirmed candidates before building anything.

### Open — GATE-HELD (do not pick up without a new design; both refused today)

- [ ] **12. [BROKEN] `/mission check` ticks a thread without ever reading the validation contract — and it is the generator of this mission's circling.** `mission.md:19-21`: it substring-matches against `## Open threads`, flips `- [ ]` to `- [x]`, and changes nothing else. **What breaks:** any thread can be closed against a contract it does not satisfy — and, as this truth-pass showed, the *fear* of that produced the opposite failure, freezing five finished threads in the open list for days. **Status: 2nd consecutive `/risk-check` RECONSIDER (2026-07-19).** Do not re-attempt from the thread text; the gate's redesign is recorded in `logs/improvement-log.md`. The sibling `update`-verb defect is **closed** — the verb shipped 2026-07-19 (`38fdffb`) and delivered this revision.

- [ ] **15. [BROKEN] `/prime`'s Step 3 scan is the largest recurring token cost in the repo, and it is still growing.** Re-measured 2026-07-19: **359 lines / 73.9k chars**, against a 40-line budget — up from the 222 filed on 2026-07-18 and from 343 measured earlier the same day. **What breaks:** every session in every symlinked project pays it at orientation, and it grows with each log entry — including the entries written to record this mission's own work. **Status: `/risk-check` RECONSIDER (2026-07-19)** — 24 consumers, 23 auto-propagating symlinks, plus a new unhardened parsing surface = two Highs. **Gate's redesign:** split into (1) a pure reformatting pass over the unchanged, already-verified `-B6` output and (2) separately-hardened parsing with its own falsification test. ⚠ **Its "delete the stale '30 of 87' prose at `prime.md:221`" sub-task is MIS-CITED — that prose is not in `prime.md` at all** (explicit-path grep, zero matches); `:224` now holds load-bearing rationale instead. Do not execute it. Correct citations: `-B6` prohibition `:219`, backtick exclusion `:223`.

### Closed — retained as the record, compressed

- [x] **1.** Improvement-log backlog drained; the Step 3 re-bloat it caused is now tracked as thread 15.
- [x] **2.** Severity anchor widened to reach the un-dashed and bolded variants — `prime.md:217`, `:223`.
- [x] **4.** `git checkout` deny rule retired 2026-07-18; it denied by verb, not effect, and stalled 5 sessions. Rule now lives in `docs/commit-discipline.md`.
- [x] **5.** `/permission-sweep` now computes the EFFECTIVE merged permission view before Rules 1/5/6 fire — `permission-sweep-auditor.md:67`, `:76-77`, `:88-89`. Commit `b7b6911`. *(Verified ALREADY-DONE by truth-pass; had been left unticked.)*
- [x] **6.** `/mission check` exists as a sanctioned tick path. Its correctness defect is thread 12.
- [x] **8.** `run-manifest.sh` midnight rollover fixed.
- [x] **9.** **Folded into thread 7 and closed as NOT-WORTH-DOING independently.** The residual surface after 7 lands — facts in plans, free-text subagent prompts, chat to the operator — is discipline, not mechanism, and this mission's non-negotiables forbid building another checker for it.
- [x] **11.** Search-instrument blindness: `logs/scripts/search-canary.sh` + `docs/audit-discipline.md § Absence-claims` shipped in `028c15a`. Execution narrowed the impact ~an order of magnitude: **zero committed sites use the vulnerable dot-rooted form**, so zero site edits were correct. *(Verified ALREADY-DONE by truth-pass; had been left unticked.)*
- [x] **13.** All five already-fixed backlog entries flipped to RESOLVED with per-entry citations. *(Verified ALREADY-DONE by truth-pass.)*
- [x] **14.** All three orphan-hook sub-defects addressed 2026-07-19 (`c3d5fe7`); `warn-settings-change.sh` deleted rather than repaired. Remaining copies live in **other repos** and are out of this mission's scope by its own non-negotiable. *(Verified ALREADY-DONE by truth-pass; had been left unticked.)*
- [x] **16.** Destructive-op override now binds to the verb and is matched on the quote-blanked `scan`; audit record relabelled to assert only what is true at PreToolUse. Commit `56304a7`. Its blocking test harness was made hermetic the same day, with a falsification gate — 23 PASS / 0 FAIL, 20 falsified / 0 INERT.
