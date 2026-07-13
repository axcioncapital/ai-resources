# Repository Redesign — Authoritative Implementation Report

> **This document is the sole current authority for the remaining repository-redesign work.**
>
> **It supersedes:**
> - `projects/axcion-ai-system-redesign/window-outputs/W3.2-migration-roadmap.md` (the 46-item, 90-day programme)
> - `projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md` (the tracker)
> - `ai-resources/logs/missions/w32-migration-execution.md` (the execution mission)
> - the work-packet structure (`output/implementation-prep/packets/`), the phase sequencing (Phases 0–4), and the packet-gate approval process
>
> Those files are **preserved as historical records** and carry superseded banners. They are available for audit. **They no longer control implementation.** Do not execute from them, do not open new packets against them, and do not treat their `not-started` rows as a queue.
>
> **Basis:** the verified state of the repositories as of **2026-07-13**, established by an independent five-agent verification sweep reading files, scripts and commits directly — not tracker status. Where the old tracker and the filesystem disagreed, the filesystem won (six cells were wrong).
>
> **Effect:** the original 46-item programme is replaced by an evidence-based implementation queue of **five items**.
>
> **Authority chain:** operator decision, 2026-07-13, on a verified status report + System Owner advisory. Recorded in `ai-resources/logs/decisions.md` § 2026-07-13 (S2).

---

## Executive decision

The redesign programme became disproportionate to the problems it was built to solve.

W3.2 was designed over nine sessions and produced a 46-item, five-phase, 90-day plan, wrapped in a governance layer — one work packet per item, a remediation register, a mission contract, and a gate before each execution. Four days into execution, the accounting was: **11 commits that built something, 29 commits that argued about what to build.** That is 27.5% doing and 72.5% deciding. Four of seven sessions produced no roadmap item at all. One item, R3, consumed four to five sessions and had still not shipped a change whose entire payoff is deleting two blocks from a session-note template.

Three of the plan's load-bearing premises turned out to be false on disk:

- **Phase 2 assumed 84 commands collapsing toward 10.** There are now **89 — five added, none removed** since the plan was written.
- **Phase 3 federation assumed cross-project retrieval friction.** There is **not one logged instance**, and the single cross-project surface that was built (the project-state vault) went cold after one use in June.
- **Phase 3 evaluation assumed a defect stream worth measuring.** The defect log holds **one real entry in three months**.

Meanwhile the item that maps to the *most*-logged real pain — concurrent sessions overwriting each other's work, roughly six recorded collisions **with actual data loss** — sat at position 43 of 46, behind 42 items with no supporting evidence at all.

Most of the remaining programme is therefore retired: it lacks evidence of practical need, has been overtaken by later changes, or would add more operational overhead than value. A plan is a model of the system; when the model and the system disagree, the model is what is wrong. A falsified model is closed, not trimmed.

What survives is five items, each pointing at a specific observed problem.

**The gates are not the villain, and this is not a licence to skip them.** The 14 `/risk-check` runs during execution returned 8 RECONSIDER and zero clean passes, and they caught real errors — a packet whose central justification was a phantom, a reference format that collided with data already on disk. But a 100% rework rate is a verdict on the *plan*, not a compliment to the gates: the items had been written without anyone checking reality first. The fix is better items, not fewer checks.

---

## Verified completed work

Established by reading the repositories, not the tracker. Where the old register disagreed, it was corrected in place.

| Item | What actually landed | Evidence |
|---|---|---|
| **M-A1** — push contradiction | Fixed, and the real scope was worse than planned: `/tweak` was **executing** `git push` at two sites, so every `/tweak` run pushed mid-session. Zero `git push` execution anywhere now. Also fixed: the guardrail wait-vs-continue fork, the stale `/compact` section, and a fourth contradiction the roadmap row had missed. | commit `e66ab38` |
| **M-A2** — model tiers | `model-classifier.sh` deleted (orphan, zero consumers). `model: opus` pinned at 6 inline spawn sites. | commits `0642846`, `69b4bde` |
| **M-A3** — startup/hook defects | Pre-commit hook synced and now byte-identical to source (the companion-lookup was re-anchored **before** copying — a plain copy would have left the restored check silently inert). `/new-project` and `/prime` fixes landed. The duplicate startup-context sub-item was deferred as not reproducible from static state — correctly. | `logs/scripts/pre-commit-hook.test.sh`; `new-project.md:156`; `prime.md:175` |
| **M-A4** — registries | Agent tier-table and skill catalogue reconciled to ground truth: **42 agents = 42 rows, 80 skills = 80 rows, 0 tier mismatches.** Re-verified still accurate on 2026-07-13. | commit `960b104` |
| **R1** — spine schemas | `ai-resources/docs/spine-schemas.md` written; all 7 promised components present (run-manifest, defect-entry, escalation packet, verification levels, 11-value failure taxonomy, caller-side 4-check, O6 profile). | commit `98c7466` |
| **R3 Pass 1** — durable run manifest | **The programme's one substantial win.** `logs/scripts/run-manifest.sh` is live; its regression suite passes **35/35**; seven real session manifests exist; `files_changed` populates on every closed session. Wired at `/session-start` 3.5, `/prime` 8c.7.5, `/wrap` 12d + root mirror 4.7. | `logs/runs/*.json`; `logs/scripts/run-manifest.test.sh` |
| **W1.4-H1/2/3** — banned model fields | **Done, though the register said `not-started`.** Zero `"model"` fields remain across all 59 settings files at every layer. The *lint scan* that would prevent regression was never built — see the watchlist. | commits `1e92a2b`, `e66ab38` |
| **PSR** — permissions | **Done, though the register said `not-started`** — it had been tracking the audit report rather than the filesystem. The 9-project `additionalDirectories` gap is closed; 3 of 5 criticals fixed, 2 neutralised by `defaultMode: bypassPermissions`. | per-project `settings.local.json` |
| **R4** (partial) | The incident wrap-gate **already ships inside R3**: `run-manifest.sh:412-414` enforces `failure_class != null` ⇒ incident ref or explicit waiver. What is missing is anything that *classifies* a failure — the flag is opt-in, so arming it still depends on model memory. See the watchlist. | `logs/scripts/run-manifest.sh:412-414` |

**Killed during execution:** F1 and PJ, dropped 2026-07-09 by operator directive. Note that **PJ was one of the three "pay first" MVP items** and RT1 is another (still a stub) — two of the plan's three highest-value items died or froze before delivering.

---

## Active implementation queue

Only work that solves a demonstrated problem. New identifiers: this is a new programme, not a reduced W3.2.

**No packets. No register. No mission contract. No approval gates.** This report is sufficient. Each item is small enough to execute, verify and commit in one pass.

---

### RR-01 — Fix `check-decision-refs.sh` repo-blindness

- **Problem.** The script resolves its repository root from **its own location on disk**, not from where it was called. There is one copy (in `ai-resources`), and every repo's wrap invokes that same copy — so it always inspects `ai-resources`, whatever the caller is. It also prints relative paths, which makes the wrong file indistinguishable from the right one.
- **Evidence the problem is real.** On 2026-07-13 a `project-planning` wrap ran while an `ai-resources` session was open. The checker read the *ai-resources* session's still-open stub (same `2026-07-13 S1` marker, empty until 10:39), printed a relative path, and reported the caller's decision refs as missing. **They were not missing.** The `project-planning` manifest (`logs/runs/2026-07-13-S1.json`, git blob `4efb79e`, never edited) contains all three correctly-slugged refs. That false report was written up as bug "P1", propagated into the mission file, the register, a packet and the improvement log, and **consumed roughly two sessions** before anyone opened the file.
- **Smallest sufficient change.** Resolve the repo root from `$PWD` (walk up to the nearest ancestor containing `logs/decisions.md`), keeping the script's own directory only for the `decision_ref_slug` module import. Print the **absolute path** of the manifest and of every decisions file indexed.
- **Affected files.** `ai-resources/logs/scripts/check-decision-refs.sh`
- **Dependencies.** None.
- **Completion condition.** Run from **two different repositories**; each run reads that repo's own manifest and its own `decisions.md`, and says so with an absolute path. A ref valid in repo A must not be reported as an orphan when checked from repo B.
- **Status.** See the Results table.
- **Commit.** See the Results table.

---

### RR-02 — Remove private firm names from shared skill files

- **Problem.** Real private-equity, advisory and sponsor names sit inside skill files that are automatically distributed to every project.
- **Evidence the problem is real.** A live scan found identifiable firms in five shared skill files: **Vaaka Partners Fund III**, **Investor AB**, **Adelis**, **Argentum**, **Visby Software**, **Sampford Advisors**, Affärsvärlden. The target companies in those examples look fabricated; the **sponsors, buyers and sources are real**. These skills sync to every project via `auto-sync-shared.sh` — a critical-tier, all-projects blast radius. This is the concrete instance of red-team finding D1, which the old plan classed CRITICAL and then scheduled behind 40 other items.
- **Smallest sufficient change.** Replace the real names with neutral fictional equivalents where an example is still pedagogically needed; delete them where they add nothing.
- **Affected files.** `skills/transaction-table-builder/SKILL.md`, `skills/chapter-revision-applier/SKILL.md`, `skills/cluster-memo-refiner/SKILL.md`, `skills/citation-converter/references/instruction-a.md`, `skills/ai-prose-decontamination/SKILL.md`
- **Dependencies.** None.
- **Completion condition.** A grep for the identified names across the whole synchronised `skills/` library returns **zero hits**, and the affected skills still read as coherent instructions.
- **Status.** See the Results table.
- **Commit.** See the Results table.

---

### RR-03 — Complete R3 Pass 2 (the wrap-note cut)

- **Problem.** Every session note repeats, by hand, a list of created and modified files that the run manifest already records better — with real paths, machine-readable, and durable on disk.
- **Evidence the problem is real.** Measured on the last three session notes: the two file-list blocks take **14, 17 and 14 lines out of 52, 53 and 58** — a quarter to a third of every note. `/prime` reads those notes at the start of every future session, so the duplication is paid repeatedly, forever. Meanwhile `files_changed` has populated correctly on **every** closed manifest (7/7).
- **Smallest sufficient change.** Delete `### Files Created` and `### Files Modified` from the canonical wrap note (8 blocks → 6) and `### Files Changed` from the workspace-root mirror (7 → 6). **Retain `### Decisions Made`** — that block is the only durable home a *routine* decision has, and cutting it was the mistake that generated the whole P1/P2 argument. Repoint the manifest's `--file` derivation, the staging enumeration, and the downstream readers at conversation context and the manifest instead of at the deleted note sections.
- **Affected files.** `ai-resources/.claude/commands/wrap-session.md` (canonical), `.claude/commands/wrap-session.md` (workspace-root mirror — a paired copy, must move in lockstep), `.claude/agents/session-feedback-collector.md`, `.claude/agents/collaboration-coach.md`, `docs/session-value-audit-rubric.md`, `docs/commit-discipline.md`
- **Dependencies.** None. R3 Pass 1 is shipped and proven. **The "P1" blocker does not exist** (see RR-01) — this was established on 2026-07-13 and is not to be re-litigated.
- **Completion condition.** Neither wrap copy references the deleted headings anywhere; `### Decisions Made` survives in both; no command, agent or doc still requires the removed blocks; a wrap still records the session's file set (in the manifest) and still stages by explicit paths.
- **Explicit scope limit.** This is a **small implementation change, not another investigation.** It has already consumed four sessions of gate archaeology over a blocker that was imaginary. Ship it in one pass. Do not re-derive its gate.
- **Status.** See the Results table.
- **Commit.** See the Results table.

---

### RR-04 — Worktree operating pilot

- **Problem.** Running two Claude sessions at once causes them to overwrite each other's work.
- **Evidence the problem is real.** The most-logged failure in the repository, with **actual data loss**, not near-misses. From `logs/friction-log.md`: *"the parallel session also overwrote the entire `## 2026-05-28` mandate block… my session's mandate vanished from the file of record"* (:107); *"two real cross-session commit-entanglement events (not pure near-misses — the index clobbers actually occurred)"* (:195); *"recurrence ~5th of the same class… NO guard fired"* (:141); *"The class remains open."* (:110). Operator's own attribution: *"It is because I start concurrent sessions."* Roughly six recurrences. Seven concurrency guard mechanisms exist and the collisions still happen — they mitigate, they do not solve.
- **Smallest sufficient change.** **Use the tooling that already exists.** `/new-worktree-session` was built 2026-07-04, is VS Code-aware (it opens a new window rather than trying to move the current session), and **has never been run** — `git worktree list` shows the main checkout only. This item is a *run*, not a build.
- **Affected systems.** One active project where concurrent sessions are genuinely useful; `.claude/commands/new-worktree-session.md`.
- **Dependencies.** None. **Do not build new worktree tooling** unless the existing implementation actually fails in use.
- **Completion condition.** No fixed duration. The pilot is complete when it has been used across enough normal work for a founder judgment on four questions: (1) can two sessions work at once without overwriting each other; (2) does it work with the actual VS Code setup; (3) is the process understandable enough for routine use; (4) is merging or closing a worktree worth the overhead it adds. A "no" on any of these is a valid, informative outcome — this is a test, not a rollout.
- **Status.** ⏳ Not started — requires normal operational use.
- **Commit.** —

---

### RR-05 — Run `/lean-repo` once and assess command inflow

- **Problem.** The repository is growing, not shrinking, and nothing observes the growth. Five commands were added and none removed since 2026-07-03. Workspace `CLAUDE.md` is 242 lines against a 170-line target — and it is read on every single turn of every session.
- **Evidence the problem is real.** `audits/friday-checkup-2026-07-03.md:152` already named it: *"new commands ship faster than they are wired into pipelines or retired"* (+12 since 2026-06-05). Command count is now **89**; agents **42**. And `/lean-repo` — the command built specifically to diagnose exactly this — **has never been run once.** It is an orphan of precisely the kind it exists to find.
- **Smallest sufficient change.** Run the existing command against the current repository. Sort its findings into four buckets: (a) remove now; (b) candidates for consolidation; (c) justified, keep; (d) **weak or irrelevant findings from the tool itself** — that fourth bucket is a real possible outcome and must be reported honestly, not quietly dropped.
- **Affected systems.** `ai-resources/` command and agent library; the always-loaded `CLAUDE.md` files.
- **Dependencies.** None. **Do not start the nine old roadmap merges automatically.** They are rejected as a method (see Dropped work). Any consolidation must come out of `/lean-repo`'s actual findings, not the old plan's prescription.
- **Completion condition.** A written assessment with the four buckets populated, and the inflow design rule adopted in writing: *a proposed new command states which existing command it replaces, or why a separate command is genuinely necessary.* **A written design principle — not an automated blocking mechanism.** Build no checker for it.
- **Status.** ⏳ Not started — requires a broader assessment pass.
- **Commit.** —

---

## Dropped work

Three different reasons, kept distinct — the distinction matters, because a dropped *method* is not a dropped *objective*.

### (a) Dropped — the underlying problem is not evidenced

| Dropped | Why |
|---|---|
| **Federation stack — F2, F3, F4, F5, F6** (~5 items: `federation.yaml` seeding for 10 owner projects + 11 consumers, catalogue generation, federation mode in the context engine, notify wiring, the 48-question eval run) | **Zero logged friction.** Not one entry anywhere about "couldn't find it", "wrong project", or "missing cross-project context". The one cross-project surface that *was* built — the project-state vault — went cold after a single use: all 13 snapshots are 34 days old. Meanwhile the single-project context engine is warm and used across 11 projects. The operator's retrieval need is **inside** one project, and it is already served. The cold vault is a **falsification**, not a gap to close. |
| **Evaluation stack — GT-C, R6, R7** (commercial golden tasks, a 25-task seeded-defect evaluator, an O6 profile pilot) | Entirely notional — no evaluator, no scorecard, no task spec exists anywhere. It proposes a 25-task measurement rig for a system whose defect log has **one entry in three months**. New detection that closes no findings is cost, not safety. The roadmap's own §9 says these gate *external integration* — which is not imminent. Moved to the watchlist, where they belong. |
| **M-C4 — forced agent-count reduction (~25 → ~10)** | **Zero logged pain, ever.** A grep across the friction, improvement and maintenance logs for agent sprawl or proliferation returns nothing. The count has grown to 42 and not one complaint exists. This is the Phase-2 fallacy in miniature: a number someone disliked, not a problem someone had. |
| **RT3 and RT4** (denies regenerated from manifest confidentiality classes; unmanifested files inherit a confidentiality ceiling) | Both depend on **F2**, which is dropped — and they were **never executable anyway**: F2 is a *Phase 3* item and these sit in *Phase 1*, a straight ordering error in the plan. Zero `federation.yaml` and zero `confidentiality_class` occurrences exist outside design documents. Their safety objective is retained on the watchlist. |

### (b) Dropped — made obsolete by later changes

| Dropped | Why |
|---|---|
| **M-C7 — credit-gate empirical test matrix** | The 1M-credit-gate pain it targets was **resolved on 2026-07-03** (`f5f1448` + the `/qc-pass` Step 3a dispatch fallback). There is nothing left to test. |
| **M-D2 — lane telemetry → gate-pruning** | **Already built.** `logs/gate-calibration.md` plus the `fading-gate-scanner` agent implement the identical ≥90%-first-pass / 30-day pruning rule, live since **2026-05-18**, with two real suppression decisions already logged. Building M-D2 would duplicate a working system. |
| **M-D3 — post-migration cost re-run (benchmarks B1–B5)** | **Cannot execute.** The plan's §7 required a *pre*-migration live baseline, and the design window never captured it — `usage-log.md` holds rich telemetry but not one of the five frozen benchmarks. There is nothing to compare an "after" against except the plan's own paper estimates, which makes the check self-referential and unfalsifiable by construction. |
| **The packet / register / mission / phase-gate machinery itself** | An artifact of the phantom item count. A five-item queue does not need a work-packet schema, a 46-row tracker, a mission contract, or a per-item approval gate. This report replaces all four. |

### (c) Objective valid — implementation method rejected

| Objective (kept) | Method (rejected) |
|---|---|
| **Repository leanness** — genuinely valid, and the pressure is real: 89 commands, 42 agents, a 242-line always-loaded workspace `CLAUDE.md` against a 170-line target. Context cost is a real binding constraint. | **The nine prescribed command merges (M-B1 … M-B9) are rejected as the method.** Nine hand-merges at R3's demonstrated cost is years of Fridays, and they aim at the *stock* while the *flow* keeps running: +5 commands per quarter, 0 removed. Merging nine while five arrive is bailing a boat that is still taking water. Replaced by **RR-05**: run the diagnostic that already exists, act on its actual findings, and put one line of brake on the inflow. The CLAUDE.md trim (old M-B1) folds into that pass — it is a symptom of the same inflow, not a separate opus-tier project. |
| **Confidentiality of buyer/deal data** — the objective behind RT1 and the RT-series is real and serious. | **RT1 as specified is dropped from the active queue.** It has been a `stub` since 2026-07-09, blocked on an ownership question ("who builds the user-layer deny — this programme or SO v2?") that nobody has answered in five days. **A stub that nobody owns is not work; it is a placeholder for a decision.** Its most concrete, evidenced instance — real firm names in shared skill files — is **RR-02, and is being fixed now.** The broader user-layer deny goes to the watchlist with an explicit trigger: it re-enters the queue when either a named owner exists or a real disclosure incident is logged. Do not keep a stub alive in a queue. |
| **Incident capture** (old R4) — valid; and half of it already shipped inside R3. | The remaining half (something that *classifies* a failure, rather than relying on the model to remember an opt-in flag) has no logged failure to point at yet. Watchlist. |

---

## Deferred watchlist

**A watchlist item creates no implementation obligation.** It is a named problem with a named trigger. If the trigger does not fire, the item never becomes work. Do not schedule these; do not open packets for them; do not let them drift back into the queue by inertia.

| Item | Trigger that would make it real |
|---|---|
| **Settings-lint scan** (the unbuilt half of W1.4) — nothing detects a re-introduced banned `"model"` field. The 2026-06-18 purge already missed the pe-kb vault once. | A `"model"` field reappears in any settings file. (Cheap enough to do opportunistically if a settings pass happens anyway.) |
| **User-layer buyer-data deny + grant ledger** (old RT1) | A named owner is established (this programme vs SO v2), **or** a real disclosure incident is logged. Until then it is a decision, not a task. |
| **Failure classification** (the unshipped half of R4) | A session failure is missed because the opt-in `--failure-class` flag was never armed. |
| **Evaluation / golden tasks** (GT-C, R6, R7) | An external integration becomes imminent (CRM write, publishing, outreach), **or** the defect log starts producing a recurring class. One entry per quarter is not a signal. |
| **Federation V1** (F2–F6) | A second, *confirmed* consumer of cross-project context appears — evidenced by logged friction, not anticipated in design. The cold project-state vault is the current evidence, and it points the other way. |
| **Concurrency guard retirement** (old M-C2) | RR-04's pilot validates. Guards stay live until something proven replaces them. |
| **Physical single-repo merge** (old M-C6) | Deliberately left undecided. No trigger set; revisit only if the repo boundary starts causing real friction. |

---

## Implementation sequence

1. **RR-01** — fix `check-decision-refs.sh`. First, because it is actively lying at every project wrap and already manufactured one two-session phantom bug.
2. **RR-02** — scrub the firm names. Second, because it is the only confidentiality exposure that is real, present, and distributed to every project — and it costs minutes.
3. **RR-03** — ship the wrap-note cut. Third, because it is unblocked, cheap, and pays back on every future session.
4. **RR-04** — worktree pilot. Fourth, because it needs *normal operational use*, not a work session. Start it and let it run.
5. **RR-05** — `/lean-repo` run + inflow rule. Last, because it is an assessment pass that deserves its own session, and its findings replace the nine rejected merges.

RR-01 → RR-03 are immediate defect fixes and land in one working session. RR-04 and RR-05 follow, because they require operational use or a broader assessment rather than a correction.

---

## Operating rule for future redesign work

> **A repository-infrastructure item should not enter the active implementation queue unless it can point to a specific observed problem, explain its practical impact, and define the smallest sufficient fix.**

An item that cannot cite a dated observation — in the friction log, the defect log, the improvement log, the maintenance observations, or the session notes — is **not a scheduled item**. It is a watchlist entry, or it is nothing.

**This is an editorial standard, not a new automated gate.** Do not build a checker for it. Do not create a register, a review process, or an approval step around it. It is a sentence to apply while writing the item — and if it had been applied to W3.2 on the day that plan was written, the plan would have contained four items instead of forty-six, and none of the governance machinery this report retires would ever have been built.

---

## Results — execution record

Updated as items complete. Evidence lives in the files; this table is the index.

| Item | Status | Verified by | Commit |
|---|---|---|---|
| **RR-01** — `check-decision-refs.sh` repo-blindness | ✅ Complete | Run from **two** repos (2026-07-13 S3). From `project-planning` it reads *that* repo's manifest and *that* repo's `decisions.md` — **3/3 refs resolve**, absolute paths printed. From `ai-resources` it reads ai-resources'. A ref valid in one repo is no longer reported as an orphan from the other. Completion condition met. | `df53459` |
| **RR-02** — private firm names in shared skills | ✅ Complete | Grep for all seven named firms (Vaaka, Investor AB, Adelis, Argentum, Visby Software, Sampford, Affärsvärlden) across the **whole synchronised** `skills/` library and every synced project copy workspace-wide → **zero hits** (2026-07-13 S3). Completion condition met. | `6dc926e` |
| **RR-03** — wrap-note cut (R3 Pass 2) | ✅ Complete | Shipped 2026-07-13 S3. Both wrap copies cut in lockstep; `### Decisions Made` retained in both; no live component still requires the removed blocks; wrap still records the file set (manifest) and still stages by explicit paths. `/risk-check` → **PROCEED-WITH-CAUTION**, all mitigations applied (see notes below). | see wrap commit |
| **RR-04** — worktree pilot | ⏳ Not started | Requires normal operational use. **Now the highest-value remaining item** — a second concurrent-session collision occurred on 2026-07-13, this one corrupting the *decision record* (two opposite approved decisions on one question, 30 min apart). | — |
| **RR-05** — `/lean-repo` + inflow rule | ⏳ Not started | Requires an assessment pass. | — |

### Notes from execution

**RR-03 — the gate caught a real defect the executing session had missed (2026-07-13 S3).**

The session initially reasoned that this report's *"No approval gates"* and RR-03's *"ship it in one pass"* waived `/risk-check`. **That reading was wrong** — line 39 of this report says explicitly that the gates are *not* the villain and this is *not* a licence to skip them. What this report retires is the bespoke packet/register/per-item-approval machinery; standing workspace rules (Autonomy Rule 9) are untouched. The operator caught the omission and the gate was run. It returned **PROCEED-WITH-CAUTION** and found a defect the session's own sweep had missed. Logged: `logs/friction-log.md` 2026-07-13 (S3), failure mode **Authority**.

**The defect: the cut silently broke un-migrated forked wraps.** `collaboration-coach.md` (symlinked into **21** projects) and `session-feedback-collector.md` (**14**) were repointed to read the run manifest as the file record. But **`positioning-research` runs a forked `wrap-session.md`** — a real file, not a symlink, 3.6 KB vs canonical's 48 KB — which still writes the old note blocks, has no manifest wiring, and has **no `logs/runs/` directory at all**. Reading only the manifest would have silently zeroed the file signal there.

**It is not a one-off.** `ai-resources/workflows/research-workflow/.claude/shared-manifest.json` lists `wrap-session` under **`"local"`**, so *every* project deployed from that template gets its own forked wrap. The gap is reproduced by design for all future template-deployed research projects. A one-off sync of `positioning-research` (the reviewer's first-choice mitigation) would therefore have left the next such project broken.

**Mitigation applied — structural, not a patch.** All four repointed readers now resolve the file record in priority order: (1) the run manifest, (2) **fallback** to the note's `### Files Created` / `### Files Modified` / `### Files Changed` blocks, which still exist in un-migrated forks, (3) declare the signal *unavailable* rather than infer it from `git status`. This works in every project regardless of migration state, present and future.

**Manifest-close reliability — measured, not assumed.** The reviewer asked for 1–2 weeks of tracking before trusting the manifest as sole record. Measured instead: of the 9 marker-bearing sessions in `ai-resources`, **8 have manifests, and all 7 closed since R3 Pass 1 wired it (2026-07-12) carry a populated `files_changed`** (15, 16, 9, 15, 18, 14, 19 files). The one header with no manifest (`2026-07-09-S2`) predates the wiring. Close rate since wiring: **7/7.**

**Residual exposure, accepted and documented in-file.** A session that dies before wrap has no manifest, so under the cut it now has no file record on *either* surface (previously the note carried one). Bounded: the note's other 6 blocks survive and `git log` still holds the truth. The alternative — hand-copying a file list on every session forever to cover a rare crash — is precisely the duplication the cut exists to remove.

**Note the shape of this.** Two of RR-03's five sessions of "gate archaeology" chased a blocker (`P1`) that did not exist. The one gate that *was* nearly skipped is the one that found a real bug. The lesson is not "fewer gates" or "more gates" — it is the report's own operating rule: gate on the *evidence*, not on the ceremony.
