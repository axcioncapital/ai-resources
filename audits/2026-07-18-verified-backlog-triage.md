# Verified Backlog Triage — 2026-07-18 (S10-163)

**Method:** five parallel verification agents, one per cluster, each instructed to distrust the log entry and check the live files. Verdicts are grounded in file:line citations, executed commands, or sandbox reproduction — not in what the backlog says.

**Scope:** all HIGH / medium-high unresolved entries in `logs/improvement-log.md`, both active mission files' open threads, plus the "Also noted" items.

**Full notes:** `audits/working/verify-2026-07-18-cluster{A,B,C,D,E}-*.md`

---

## Headline: about a third of the backlog is wrong

Of ~30 claims checked:

| Verdict | Count | Meaning |
|---|---|---|
| REAL-AND-OPEN | ~16 | Defect exists in live files now |
| ALREADY-FIXED | 5 | Shipped; log entry never flipped |
| FALSE-PREMISE | ~6 | Stated cause wrong, or numbers wrong |
| PARTIALLY-OPEN | ~4 | Some shipped, remainder named |

**Two distinct failure modes, and the second is more expensive:**

1. **Staleness** — the fix shipped, nobody flipped the entry. Cheap to detect, cheap to fix.
2. **Mis-attribution** — the problem is real but the entry names the wrong file, wrong command, or wrong cause. Acting on the entry produces *nothing*, and the wasted work is invisible until someone re-derives the diagnosis.

A reusable triage rule emerged from the research-workflow cluster and generalises:

> **Premises that assert what a file *lacks* survive verification. Premises that predict what the *runtime does* fail it.**
> Absence-claims are grep-settleable and reliable. Behaviour-claims need execution before they are sized.

---

## Top 10, ranked by consequence

Ranking is by **consequence if left unfixed**, not by the severity labels in the logs — several of those labels are stale by the same mechanism this pass was built to catch.

### 1. The staging guard blocks sessions that followed the schema correctly

- **Verdict:** REAL-AND-OPEN — reproduced in a scratch repo, not inferred.
- **Evidence:** `grep "Required outputs"` across all 589 lines of `.claude/hooks/check-foreign-staging.sh` → **zero matches**. It reads only `- Files in scope:` (`:354`). A schema-correct mandate — outputs declared under `Required outputs`, then created — produced `BLOCKED … 2 file(s) OUTSIDE this session's declared footprint`, exit 2.
- **Why it ranks first:** it fires on **every artifact-producing session**, at **wrap**, after all work is done. It fired with no concurrent session present, so this is the default path, not an edge case. It is fail-**closed on correct behaviour**, and the only workaround — declaring not-yet-created files in `Files in scope` — is exactly what `session-start.md:280-284` hard-rejects. The session is pushed to route around a correct rule to satisfy an incomplete one.
- **Fixability:** clean / one session.

### 2. `/prime`'s backlog scan costs ~12k tokens every session, in every project

- **Verdict:** PARTIALLY-OPEN — and the regression was caused by two *correct* fixes composing.
- **Evidence:** Step 3 measured at **~226 lines / 47,754 chars (~12k tokens)** against its stated **<40-line budget** — a 5.6× breach. Log health itself is now clean: 104 entries, **0 unclassified**, **0 resolved-unarchived** (mission threads 1 and 2 held). Cause: the Severity backfill created 21 `medium-high` entries; 28 severity hits × `-B6` context = 223 lines.
- **Note:** `prime.md:221` still claims "30 of 87" — stale by its own fix.
- **Why it ranks here:** the only item on this board that is **actively worsening**, and it bills every session in every project.
- **Fixability:** one session, but **risk-check class** — `prime.md` is symlinked into every project.
- **Do not** revert the prior fixes. Both were right; the composition is what broke.

### 3. `grep` is a blind instrument, and every audit has been running on it

- **Verdict:** REAL-AND-OPEN, and worse than logged.
- **Evidence:** `type grep` → a **shell function dispatching to `ugrep --ignore-files`**. From the workspace root: **8 hits vs 720** for `command grep` — **98.9% blind**. The log entry says this is workspace-root-only; that is wrong. From *inside* ai-resources it is still **435 vs 564 (23% invisible)**, because `--ignore-files` also honours `ai-resources/.gitignore`.
- **Why it matters beyond itself:** a zero-hit scan is indistinguishable from a blind instrument. This silently weakens **absence-claims in every past audit and every future one** — including parts of this report (see Confidence caveat below).
- **Fixability:** messy / one session — doc fix plus ~6 scanning agents, and it needs a known-positive canary check so blindness announces itself.

### 4. Backlog truth-keeping: 5 entries say "broken" and are already fixed

- **Verdict:** ALREADY-FIXED ×5, verifiable in the live files in seconds.

| Entry | Claim | Reality |
|---|---|---|
| L800 | *"the highest-value structural item in this log"* | It is the **spec of the fix that shipped**. Its own recommendation — suffix the marker (`S3-a4f`) — is live: today's headers read `S1-dec` … `S9-f53`. The site it called load-bearing is migrated at `check-foreign-staging.sh:259`. |
| L753 | Blocked on a stale worktree being rebased | `git worktree list` → **one checkout**. The blocker does not exist; this would have sat "blocked" forever. |
| L733 | Allocator gap fired for real | Closed by the session-id-in-name change, `prime.md:413-426`. |
| L838 | *"operator-directed: fix this week"* | Fixed in commit `3179771`; `risk-check.md:50-67` resolves via git-common-dir. |
| L926 | `/prime` rebase halts orientation | Fixed; `prime.md:21-27` behind-check, `:47-56` mid-rebase abort. Confirmed live this session. |

- **Why it ranks here:** cheap, and it **feeds item 2** — flipping and archiving these mechanically shrinks the scan before its logic is touched.
- **The uncomfortable part:** three of the five sit in the marker cluster, superseded by a fix that **L800 itself specified**. The mission convened to cure stale log entries is carrying stale log entries about its own work.

### 5. Reviewer agents cannot check their own premises — one is told not to

- **Verdict:** REAL-AND-OPEN, counts exact.
- **Present:** `system-owner:99-101`, `risk-check-reviewer:186-375` (Dimension 7), `qc-reviewer:87-106`.
- **Missing:** `refinement-reviewer:45` (a permission under "Context Gathering", not an obligation); `reconcile-reviewer:61` (artifact-scoped, not its own counts); `expert-check-reviewer:38` (KB-presence only).
- **Two that are worse than "missing":**
  - `triage-reviewer:51` carries the **verbatim inverse**: *"If you can't verify a claim from the suggestion text alone, note it as an assumption rather than launching a search."* This agent decides what leaves your queue.
  - `scope-qc-evaluator` — `grep -c "verify|re-derive|filesystem"` → **0**. It issues five-way build/park verdicts with the least verification language of any of the eight agents.
- **Closes two mission threads:** landing this **is** the fix for thread 9 (assert-from-recall, 8 logged instances against a trigger of 6). The residual — plans, subagent prompts, chat — is discipline-only, and the mission's own non-negotiable forbids another checker.
- **Fixability:** clean / one session.

### 6. Two live research projects hold known-wrong analysis tables

- **Verdict:** REAL-AND-OPEN. **Trigger not currently armed** — but a documented instruction would arm it.
- **Evidence:** neither `research-pe-regime-shift-advisory-gap` nor `positioning-research` has the back-ported chassis — both lack the `2026-07-14` marker, `Evidenced Negatives`, and `Stop Condition 5`; mtimes Jun 8 / Jun 11. Both §1.1 sentinels are present, so nothing re-runs today.
- **The measured consequence:** `claim-permission-gate:101` records a real re-adjudication of `research-pe 1.1-cluster-03` — **2 of 6 claims moved down a class**. Both projects hold §1.1 permission tables that are known-wrong, frozen in place by their own completion sentinels.
- **What arms it:** any new section, or any sentinel deletion — and `positioning-research`'s own `decisions.md:136` **instructs a deletion**.
- **Mercy:** failure is a loud hard-exit, not silent corruption.

### 7. The destructive-command override logs successes that never happened

- **Verdict:** REAL-AND-OPEN, two independent defects.
- **Evidence:** `check-destructive-liveness.sh:207` matches `\bAXCION_LIVENESS_OVERRIDE=1\b` **anywhere in the command string**, never checking the variable binds to the destructive verb — so an inert override is accepted. `:215-224` writes the audit line and exits 0 at **PreToolUse**, *before execution*, with no `outcome` / `exit_code` field in the schema.
- **Consequence:** the audit trail records "proceeded" for commands that never ran. The guard's own evidence base is unreliable.
- **Fixability:** regex anchor is clean / one session. Post-execution logging is messy / a second session.

### 8. Hook wiring is unversioned — a fresh clone silently loses the safety layer

- **Verdict:** REAL-AND-OPEN. The parked plan at `logs/session-plan-2026-07-18-S9-f53-thread3-parked.md` was independently re-verified: **all nine findings hold, none stale, directly resumable.**
- **Evidence:** `~/.claude` is not a git repo (`fatal: not a git repository`). 9 registrations, 2 are `afplay` → **7 repo scripts**. **6 hardcode `/Users/patrik.lindeberg/`**; the 7th uses `$HOME`. `cleanup-session-marker.sh`'s **body** exists only at `~/.claude/hooks/` (6785 bytes) — versioned nowhere. `install-hooks.sh` and `check-hook-wiring.sh` both absent.
- **Constraint:** `model: 'opus[1m]'` sits among 10 top-level keys, so any installer must do a **key-scoped merge** and preserve it (operator-DECLINED 2026-07-13).
- **Consequence:** a new machine gets scripts that *look* installed, with nothing firing them and no error.
- **Fixability:** messy / multi-session. Its "Min" variant (Stages 1–3) is a credible one-session subset.

### 9. `/permission-sweep` emitted a false CRITICAL that reached a checkup as actionable

- **Verdict:** REAL-AND-OPEN, exactly as stated.
- **Evidence:** `permission-sweep-auditor.md:67` — *"For each file, apply the detection rulebook."* `defaultMode` appears **once** (`:147`) and only as a report-format token, never as a suppression check. Rules 5/6 (`permission-template.md:388,392`) are pure allow-array predicates.
- **Double falsity:** `ai-resources/.claude/settings.json:4` carries `Bash(*)` **and** line 9 sets `bypassPermissions`. The emitted CRITICAL was false twice over, and it reached the 2026-07-17 friday-checkup as an actionable HIGH.
- **Consequence:** audit tooling that produces false HIGHs spends operator attention and erodes trust in every finding it makes — including its true ones.

### 10. `warn-settings-change.sh` fails open, and is queued to be copied as a template

- **Verdict:** REAL-AND-OPEN, both halves confirmed by execution.
- **Evidence:** `:6` reads `d.get('file_path')` where the PreToolUse payload nests it under `tool_input`. Real payload → **exit 0 (allows)**; legacy top-level shape → exit 2. Swept all **68** `settings*.json` layers → **0 registrations**.
- **Why it still ranks:** nothing is unprotected today *because* it is unwired — but `audits/risk-checks/2026-07-14-repo-repair-pilot-v1…:13` already proposes copying it as **"proof the exit 2 pattern works."** A broken guard about to be cloned as the reference implementation.
- **Fixability:** clean / one session.

---

## Below the top 10 (real, lower consequence)

- **friction-log unreachable regions** — 3, not the 5 claimed (2 H2 blocks at `:554`, `:565`; 1 drifted H3 at `:629`). **Coupled defect:** `/friday-checkup`'s dormancy regex matches *only* the 2 drifted headers and **none** of the 20 canonical blocks — so fixing the drift **breaks the checkup**. These must move together.
- **No conflict-marker scan gate** exists anywhere. Markers themselves are clean (`git grep` → empty, cleaned in `856d7b3`).
- **`permission-template.md:226`** names a dead path. Correct target is `knowledge-bases/pe-kb-vault/` (relocated in `83669d5`) — **not** `strategic-os`, which the doc never mentions and which `retirement-backlog.md` has queued for dissolution.
- **`check-claim-ids.sh`** — 2 live registrations exist; the **template** ships it unwired, so 4 of 6 locations never fire it.
- **Lease-based session identity** (id→pid map) — no `~/.claude/session-leases`, zero lease references anywhere. Messy / multi-session.
- **Mission thread 10** — 10 of 12 mutating commands carry zero liveness references. **Recommended shape: one shared pre-flight called by the few write-wide commands, `/permission-sweep` first — not a liveness gate in ten commands**, which would violate the mission's own "no new gate to solve a discipline problem."
- **Research-workflow threads 3, 4, 6, 8** — all real, all verified. Deployment is **confirmed unblocked** (`decisions.md:191-201`, no drift from mission `:216`).
- **Three project repos have no git remote** — 603 commits, ~32 MB, including both live research projects. **Operator-deprioritised 2026-07-18**; recorded here so it is not silently lost.

---

## Close these — do not spend a session on them

| Item | Why |
|---|---|
| **Stacked gate questions** (L1252) | The rule is already written **three times** (CLAUDE.md § Do not stack gates, § Decision-Point Posture, user memory). Conformance, not mechanism. The ≥2-prompt tripwire is in-session state **no hook can observe**. |
| **Partial conflict enumeration** (L1242) | The step it describes **does not exist** in `prime.md`. And `prime.md:88` reads `decisions.md` via `tail -n 10` — structurally incapable of enumerating implicated decisions. Fixing what the entry describes produces nothing. |
| **`rm`-in-`for`-loop** (L935) | FALSE-PREMISE on code — the construct exists **nowhere** in `logs/scripts/` or `.claude/hooks/`. Every `rm` takes a quoted literal path. Survives only in log prose. |
| **`audits/working/` bloat** | Every number false: **397** files (not 328), **4.4 MB** (not 4.1), **88** >60d (not 53). And the framing inverts — `/log-sweep` **already self-excludes** its own notes at three layers, which is *why* 31.6% can never be swept. |
| **friction-log PostToolUse branch** (F-11b) | FALSE-PREMISE — registered and **proven live by execution**. Dead only in the template. |

---

## Needs an operator decision, not a fix

**Research-workflow thread 7's acceptance test is unsatisfiable.** The frozen validation contract requires `Verification posture` to control `required` / `optional-sampled` / `skippable`. The **real enum** (`CLAUDE.md:31`) is `per-claim-cited` / `lighter-than-formal` / `interpretive-only`. **Zero overlap.** The thread cannot be closed as written, and mission rules freeze the validation contract — so amending it is an operator call.

**Related, same cluster:** thread 8's stated consequence is wrong twice. `PAN-LEAKAGE` is evaluated first (`:140`), so "every cluster" overstates it; and `CLEARED-WITH-CAVEATS` is not in that skill at all — it is `run-sufficiency.md:118`, fired unconditionally by `disconfirmation_tested: false`. **Fixing thread 8 will not remove the caveat**, and an acceptance test asserting it would fail for an unrelated reason.

---

## Confidence caveat

Item 3 (blind `grep`) partially undercuts this report, and the honest bound is worth stating.

A blind instrument produces **false negatives, not false positives**. So:

- **Every "found at file:line" finding stands.** Positive hits are unaffected.
- **"Zero hits" claims carry residual risk** — but most targeted *tracked* files (agent definitions, command files, hooks), which `ugrep` still searches.
- **The exposure is absence-claims over untracked paths** — notably `audits/working/`, where **384 of 397 files are untracked**.

The cluster B agent hit this defect mid-run and deliberately re-ran its sweep with `command grep`. The other four agents did not know to. Their positive findings are unaffected; any absence-claim over an untracked path should be re-checked with `command grep` before being acted on.
