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

Ranked by real consequence at verification time (2026-07-18). `[BROKEN]` = defective now; `[IMPROVE]` = not broken, real gain available.

- [x] **1. [BROKEN] Drain the improvement-log backlog — the `/prime` scan has re-bloated ~9x in five days.** The Step 3 scan returns 223 lines / ~45,800 chars (~11–12k tokens) every session, against 25 lines when the fix shipped 2026-07-13. 29 resolved-class entries are still unarchived and 30 open entries are 30–57 days old. 15 of 28 severity hits sit on already-applied/resolved/declined entries. *Cost: ~11–12k tokens every session, and over half the task menu is completed work.* (`/resolve-improvement-log` is the drain; the Friday report's counts of 7 and 19 were both wrong.)
- [ ] **2. [BROKEN] A third of the improvement backlog is structurally invisible to `/prime`.** `prime.md:206` anchors on `^- **Severity:**`. Of 102 live entries, 69 carry that anchor, 2 use an un-dashed variant, and 31 have no Severity line at all — 33/102 (32%) unreachable. Three entry formats are live, not the two the log entry claims. *Cost: a third of the backlog can never reach the task menu — the one channel that demonstrably converts findings into shipped work. Two invisible entries carry ~40–70k/session and ~150k/occurrence savings.*
- [ ] **3. [BROKEN] Hook wiring is unversioned — a fresh clone silently loses the concurrency-safety layer.** `~/.claude` is not a git repo (`git rev-parse` → fatal). Seven hook registrations exist only there — `check-foreign-staging.sh`, `check-destructive-liveness.sh`, `detect-concurrent-session.sh`, `warn-fable-model.sh`, `detect-innovation.sh` (Write+Edit), `cleanup-session-marker.sh` — and `cleanup-session-marker.sh`'s *body* is unversioned too. *Cost: a new machine gets the scripts sitting in `.claude/hooks/` looking installed, with nothing firing them, and no error. This also silently un-ships the fixes that closed the marker-collision and staging-guard items.* Note: a prior installer design scored High/High on `/risk-check` twice — requires timestamped backup of `~/.claude/settings.json`, an idempotent merge preserving all unrelated keys (including the operator-declined `model` field), and its own risk-check.
- [ ] **4. [BROKEN] `git checkout` is hard-blocked, and the queued fix targets the wrong rule.** Denied by name at `~/.claude/settings.json:47` and workspace-root `.claude/settings.json:27` — `"Bash(git checkout *)"`. *Cost: a hard block that `bypassPermissions` cannot waive; 5 logged occurrences, near-certain during any merge.* The logged diagnosis blames archive `Read()` deny patterns — falsified by the log's own data (`git add <archive>` and `git show ":N:<archive>"` both name the denied path and both ran fine). The `/friday-act` fix already queued targets those Read patterns and would ship without unblocking git. The entry's own escape hatch (`git checkout --ours .`) matches the same Bash deny.
- [ ] **5. [IMPROVE] `/permission-sweep` judges settings files individually, not by merged effective permissions.** Rules 5/6 read one file's allow array without evaluating the merged layer stack or `defaultMode`. *Cost: it emitted a CRITICAL/HIGH "ai-resources permission drift causing prompts" that reached the 2026-07-17 friday-checkup as an actionable HIGH and was entirely false — the same file sets `bypassPermissions` on line 9. Audit tooling that produces false HIGHs spends operator attention and erodes trust in every finding it makes.*
- [x] **6. [BROKEN] `/mission` has no sanctioned way to tick off a thread.** `mission.md:4,27` expose exactly `create | list | read | close`; `:28` aborts on anything else; `close` touches `status` only. The contract at `mission.md:12` states threads change *"only via this command — never hand-written from inside a working session."* *Cost: `prime.md:236` builds task-menu candidates from unchecked thread items, so a bound mission re-surfaces completed work at every session start — unless the operator hand-edits, which the contract forbids. This mission file hits the defect immediately.*
- [ ] **7. [IMPROVE] Five reviewer-class agents lack the premise-check antibody the other three carry.** Missing in `refinement-reviewer.md:45` (a permission to verify, not an obligation), `triage-reviewer.md:51` (the *inverse* — explicitly licenses proceeding on an unverified claim if labelled "assumption"), `reconcile-reviewer.md:102` (covers the artifact under review, not its own counts), `expert-check-reviewer.md:38` (one-fact scope), and `scope-qc-evaluator` (zero verification language). Present in `system-owner.md:99-101`, `risk-check-reviewer.md:194`, `qc-reviewer.md:87-106`. *Cost: `scope-qc-evaluator` issues five-way build/park verdicts with the least verification language of any of the eight agents; `triage-reviewer` decides what leaves the queue. `improvement-log.md:1105` records this exact failure at higher authority — `system-owner` fabricated a count that was indistinguishable in tone from its true findings.*
- [ ] **8. [BROKEN] `run-manifest.sh` cannot close a manifest across midnight.** `:156` re-derives `DATE` per invocation; `:166-168` trusts the marker file only if dated today; `:171` dies otherwise. `wrap-session.md:253` documents omitting both flags on purpose. Reproduced in sandbox: start-stub `2026-07-17-S9.json`, close on 07-18 → `exit=2`, stub never finalized. With `--marker` pinned but not `--date`, two manifests are written for one session. No midnight case exists in `run-manifest.test.sh`. *Cost: any session wrapping after midnight leaves a permanently null-outcome record — rare, non-blocking, but it silently corrupts the durable substrate crash-detection is built to read.*
- [ ] **9. [IMPROVE] The assert-from-recall pattern passed its escalation trigger and still has no standing rule.** 8 logged instances 2026-07-13→07-14 (friction-log L346, L516, L536, L584, L642; improvement-log L651, L857, L1105) against a trigger of 6. Zero hits for a standing rule in workspace CLAUDE.md, ai-resources CLAUDE.md, or repo-wide. Covered today: mandate `Files in scope` (mechanical hard-reject), gate *inputs* for two gates, reviewer *outputs* for three agents. Not covered: facts stated in plans, free-text subagent prompts, the five agents in thread 7, and chat to the operator. *Cost: a plan carrying five false factual claims authorized ~360k tokens of review that missed the two that mattered.* Note the entry's own warning — do not build another checker; thread 7 is the coherent countermeasure.
- [ ] **10. [BROKEN] Repo-mutating commands stand in for a liveness fact by reading the repo at rest.** Verified instance: `/permission-sweep` mutates settings workspace-wide (`:5`, `:19`) and its only concurrency mention (`:324`) defers to commit time rather than checking whether another session is live. A scan of 11 mutating commands found 10 with zero liveness references; only `/wrap-session` has any. *Cost: with concurrent sessions now routine in this workspace, a sweep can overwrite a live session's uncommitted settings edits.* Honest scoping: 1 confirmed, 9 unverified candidates — the logged figure of "seven more gates" was not reproducible. First step is to verify the 9, not to fix 10.

### Also noted, below the top ten (park or fold into a thread)

- `audits/working/` has grown to 328 files / 4.1 MB, 53 files older than 60 days, and no non-dry `/log-sweep` has run since May. 122 files (1.4 MB, 40%) are `/log-sweep`'s own working notes, which the sweep must special-case-exclude to function. Housekeeping — one non-dry `/log-sweep` away.
- 3 friction-log entries remain unreachable by all four of its parsers (2 blocks missing the `### Friction Events` heading at L468/L479, 1 drifted header at L616) — including the operator-caught `/risk-check`-waiver failure. The 2026-07-14 repair fixed the rest; the log's `logged (pending)` status is stale.
- `.claude/hooks/warn-settings-change.sh:6` reads a top-level `file_path` where the payload nests it under `tool_input` — proven by execution to exit 0 (allow) on a real payload. It is wired into no settings file, so nothing is unprotected; the harm is that it looks like a working guard to anyone auditing.
- `docs/permission-template.md:224` names a path that no longer exists (`projects/obsidian-pe-kb/vault/`); the file actually showing the pattern is `projects/strategic-os/`. Detection is a live content heuristic, so nothing misbehaves. Two-line doc fix.
- No control exists to prevent reference-file surplus on a pipeline hot path (no template, no size or read-frequency rule in `ai-resource-creation.md` or `ai-resource-builder`). The specific file named in the 2026-07-16 entry no longer exists and its surplus could not be confirmed — but `workflows/research-workflow/docs/required-reference-files.md:89` still requires it with no template shape, so every future deployment invents it. Route the file-existence half to `axcion-sector-intelligence`.
