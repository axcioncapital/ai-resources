---
mission_id: repo-integrity-repairs-2026-07
mission_name: ai-resources silent-failure and gate-repair bundle — 16 verified items (2026-07-24)
status: active            # active | paused | completed
started: 2026-07-24
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded per `/mission create` (Step 2), drafted from session context on operator request.
  Frozen at creation: Goal / In-Out scope / Validation contract are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` change,
  and only via `/mission` — never hand-edited from inside a working session.

  PROVENANCE — these threads are NOT copied from the backlog logs. On 2026-07-24 (S1-7fe cont.)
  the 30 open high/medium-high entries in logs/improvement-log.md were put through three
  independent Opus verification agents that re-checked each claim against the LIVE FILES.
  Result: 23 confirmed real, 2 already fixed, 0 fabricated. Verification notes:
    audits/working/priority-repo-problems-2026-07-24-batch-A.md  (markers, hooks, lifecycle)
    audits/working/priority-repo-problems-2026-07-24-batch-B.md  (guard scripts, git, reachability)
    audits/working/priority-repo-problems-2026-07-24-batch-C.md  (commands, gates, parsers)

  This pass ran AFTER the same day's triage commits (fc977a2, 2dbd599), so it reflects
  post-triage state. That triage caught two of its own false closes before commit — which is
  why an independent pass was run rather than trusting the log's own status lines.

  THREE CORRECTIONS established by this verification — do not re-derive them from entry text:
    · `:1663` and `:1787` are the SAME defect logged twice. Merge; do not close either alone.
    · `:54` (marker teardown) is NOT gate-held. The RECONSIDER at
      audits/risk-checks/2026-07-19-harness-hermeticity-marker-teardown-prime-step3-emit.md:32
      belongs to a different change; :31 scored this one PROCEED-WITH-CAUTION.
    · `:1430`'s named target (`prime.md`) has NO conflict-surfacing step. Executing that entry
      as written would misdirect the session. The real surface is workspace CLAUDE.md:52.

  DELIBERATELY NOT INCLUDED — verified and dropped, do not re-raise without new evidence:
    · `:848` marker-allocator collisions and `:1154` two-entry-formats — both verified
      ALREADY FIXED. They appear once below, as a closing thread, not as work.
    · `:22`, `:965`, `:1052`, `:1215` — process-shape entries. Three of them explicitly say
      "do not build a checker for this." They are discipline, not buildable work.
    · `:35`, `:93`, `:164` — mission threads 15 and 12, gate-held under
      repo-health-backlog-2026-07. Parked deliberately; not this mission's to pick up.
-->

## Goal

The sixteen verified defects listed under `## Open threads` are each either fixed and verified by execution, or explicitly closed with a recorded reason — so that (a) no shared script writes into a repo other than the one the calling session is working in, (b) every append-ordered log carries the same append-direction guard at every write site, and (c) the review gates that decide whether work ships stop passing evidence they never actually checked.

## In scope / Out of scope

- **In:** `ai-resources` — `logs/scripts/`, `.claude/commands/`, `.claude/agents/`, `.claude/settings.json`, `docs/`, and the workspace-root mirror of `wrap-session.md`. Also in: the `logs/scripts/` provisioning gap across the 13 project repos named in thread 2, and `.claude/commands/new-project.md` as its upstream cause.
- **Out:** threads **3, 7, 10, 12, 15** of `repo-health-backlog-2026-07` — that mission owns hook-wiring versioning (`:1014`), the reviewer premise-check antibody, repo-at-rest liveness (`:1024`), `/mission check`, and the `/prime` Step 3 scan redesign. **Do not touch them here**; two competing contracts over one backlog is the failure that mission's own 2026-07-19 truth-pass diagnosed. Also out: `:1524` (guard-script cwd resolution), `:54` (marker teardown), `:1289` (session leases), `:1305` (`/clarify`-first marker) — each needs a dedicated session with its own falsification harness, per workspace `CLAUDE.md` § Working Principles.

## Validation contract

> Written at mission creation, before any implementation session, so a fresh-context check can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — must ALL be true when the mission is complete:
- [ ] `logs/scripts/check-archive.sh` run from a project with no local `logs/scripts/` either archives that project's logs or refuses — demonstrated by execution from a real second checkout, never by reading the script.
- [ ] No project under `projects/` can reach a wrap-time script that resolves its target from `$0` and lands outside that project.
- [ ] Every append-to-end log written by `wrap-session.md` carries the append-direction warning at its own write site, in **both** the canonical file and the workspace-root mirror — verified by a count across both copies, not by reading one.
- [ ] A read-only session can read `logs/improvement-log-archive.md` without a permission denial.
- [ ] Each of the sixteen threads is closed with either an execution-verified fix or a recorded decline reason. No thread is closed by assertion alone.
- [ ] No thread is closed on a partial check of a multi-clause claim — each clause has its own confirmed check, per `:22`'s lesson.

**Non-negotiables** — boundaries no session may cross, even if locally convenient:
- Do not edit `.claude/commands/prime.md`. It is twice `/risk-check` RECONSIDER'd and belongs to the sibling mission's thread 15.
- Do not hand-delete stale session markers or archive files that a thread cites as evidence. Removing the evidence a guard reads is the logged guard-defeat anti-pattern.
- Do not add a `"model"` field to any `settings.json`, in any layer. Non-negotiable workspace rule; operator-DECLINED 2026-07-13.
- Fix thread 1's resolution guard before or with thread 2. Provisioning alone leaves the wrong-repo write live.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):
- Editing `prime.md`, or picking up any thread named on the Out-of-scope list.
- Building a checker for a process-shape entry the entry itself says not to build for.
- A session that closes threads faster than it verifies them — the backlog's measured failure rate is 2 false closes per 30 entries.
- Widening from "repair the named defect" into "redesign the subsystem the defect sits in."

## Open threads

### Wave 1 — silent failures and cheap gate repairs (ungated, ~1 session)

- [ ] **1. [BROKEN] `check-archive.sh` archives the wrong repo's logs.** `logs/scripts/check-archive.sh:12` derives `PROJECT_DIR` from `dirname "$0"`, never from the caller; `CLAUDE_PROJECT_DIR` is unread in the 62-line body. **Breaks:** it already archived `ai-resources/logs/decisions.md` from an `axcion-communication-system` wrap on 2026-07-19 — silently, into the wrong repo. Merge `:1663` and `:1787`; same defect, logged twice.
- [ ] **2. [BROKEN] 13 of 27 projects have no `logs/scripts/`, which is what forces thread 1's walk-up.** Census 2026-07-24: `axcion-website`, `axcion-copy-factory`, `axcion-design-studio`, `axcion-pitch-engine`, `axcion-linkedin-os`, `axcion-systems-builder`, `axcion-ai-system-owner`, `axcion-ai-system-redesign`, `axcion-communication-system`, `corporate-identity`, `management-os`, `repo-documentation`, `strategic-os`. `new-project.md` has zero `logs/scripts` matches. **Breaks:** every wrap in those 13 repos takes the path that lands in the wrong repo.
- [ ] **3. [BROKEN] The archive is deny-read.** `.claude/settings.json:30` carries `Read(logs/*archive*.md)`; it denied a read-only call from a verification agent this session. **Breaks:** a session cannot check whether an item was already archived — which is precisely why 2026-07-24's two false closes would have been effectively permanent had they shipped. (`:1172` second half; the `git checkout` half is genuinely closed.)
- [ ] **4. [BROKEN] The append-direction warning exists at one write site out of four.** `wrap-session.md:123` warns for `session-notes.md`; `:132` writes `decisions.md` with no warning, and `check-archive.sh:20` confirms `decisions.md` is bottom-ordered identically. The workspace-root mirror has no guard for **either** file. **Breaks:** a prepended entry is read as oldest and archived — already caused one mis-ordered commit.
- [ ] **5. [BROKEN] `grep` is a gitignore-aware wrapper and 3 of 4 audit agents lack the antibody.** Measured live from the workspace root: wrapper returns 0 hits where `command grep` returns 6. Only `lean-repo-auditor.md:64` carries the guard. **Breaks:** an audit run from the root sees an empty `ai-resources` and reports clean. (`:1195` clause C; the `docs/audit-discipline.md` half shipped.)
- [ ] **6. [BROKEN] `/risk-check` Step 2.6 verifies structure but never evidence quality.** `risk-check.md:87-89` lists three checks; none asks whether a cited source measures the thing claimed. **Breaks:** cost a full second re-gate cycle on 2026-07-23.
- [ ] **7. [BROKEN] A `/risk-check` RECONSIDER that changes the deliverable never routes to `/contract-check`.** `contract-check.md:10-14` has four triggers, none gate-related; `risk-check.md:173`/`:180` emit no nudge; workspace `CLAUDE.md:77-84` likewise. **Breaks:** the exact drift `/contract-check` exists to catch is the one drift nothing routes to it.
- [ ] **8. [BROKEN] `/close-worktree-session` has zero stash handling.** `command grep -ci stash` → 0; the guards at `:29` and `:200-207` are merge-only. **Breaks:** it committed unresolved conflict markers into a tracked log, and the mechanism it needs to guard does not exist in the command.
- [ ] **9. [BROKEN] An override prompt names only the triggering conflict.** Workspace `CLAUDE.md:52` says "list the conflict" — singular, with no enumeration-completeness requirement. **Breaks:** the operator overrides one thing and unknowingly overrides several. *Correct the entry's target on pickup: `prime.md` has no conflict-surfacing step.*
- [ ] **10. [CLOSE] Two entries verified already fixed are still surfaced as urgent at every orientation.** `:848` — its status line reads `OPEN … no fix applied` while **its own body at `:862` reads `✅ FIXED 2026-07-13 (S13)`**; mutex live at `prime.md:430-489`. `:1154` — both clauses closed (`prime.md:245`, `wrap-session.md:304`, `session-feedback-collector.md:116`). Close both with citations.

### Wave 2 — verified real, moderate effort

- [ ] **11. [BROKEN] 33 canonical commands are unreachable from a workspace-root session.** `comm -23` gives exactly 33 missing (90 canonical vs 63 at root); root `prime.md` is a symlink to canonical, so `:539`/`:542` instruct invoking `/session-start` and `/session-plan`, both absent there. **Breaks:** a documented, instructed flow fails silently at the root.
- [ ] **12. [BROKEN] `/prime`'s urgent scan returns zero in 12 of 20 project logs.** 11 of those have non-empty backlogs; no project log carries the Severity schema, which lives only at `logs/improvement-log.md:13`. **Breaks:** findings in 12 projects are unreachable by the one channel that converts them into work.
- [ ] **13. [BROKEN] `warn-settings-change.sh` was deleted; 9 live dependents still assert it exists.** `find` → 0 hits workspace-wide, while `technical-design.md:34` labels wiring it a **Fact** and `execution-roadmap.md:30` sequences it into stage S2; `per-unit-plan.md:37` is an executable build order. **Breaks:** a build plan will attempt to wire a file that is gone.
- [ ] **14. [BROKEN] `/prime` cross-checks Next Steps against git but not mission threads.** `prime.md:95`/`:122` cover Next Steps only; Step 1d (`:215-232`) builds threads from unchecked `- [ ]` with no git pass and `:288` feeds them straight to the menu. **Breaks:** a shipped thread is re-offered as open work at every orientation.
- [ ] **15. [BROKEN] 2 of 5 friction-log blocks remain invisible to all four parsers; a third has an inverted header.** `friction-log.md:736` and `:747` lack `### Friction Events`; `:884` is inverted and matches none of the four date anchors. **Breaks:** those sessions' friction is invisible to `/open-items`, `/reconcile-backlog`, `fix-repo-issues-scanner`, and `diagnostics-scanner`. *The entry's own `HH:MM` citation at `friction-log.md:25` is FALSE — the real spec is `session-feedback-collector.md:148`.*
- [ ] **16. [BROKEN] The deploy-fitness mission's threads are still written as fixes to implement.** Clause (a) is done — `logs/missions/research-workflow-deploy-fitness.md:216` records "GATE RE-DECIDED — 2026-07-18". Clause (b) is not: threads 3/4/6/7/8 (`:155`, `:160`, `:192`, `:194`, `:196`) still read as implementable, with no "verify premise by execution first" downgrade. **Breaks:** a session picking one up builds against a premise that failed 3 for 3.
