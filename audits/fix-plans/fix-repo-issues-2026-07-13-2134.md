# Fix plan — 2026-07-13 21:34

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources
**Scanner notes (per scope):**
- ai-resources: [audits/working/fix-repo-issues-2026-07-13-2134-ai-resources.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/audits/working/fix-repo-issues-2026-07-13-2134-ai-resources.md)

**System Owner advisory (`/consult`, 2026-07-13):** [projects/axcion-ai-system-owner/output/consultations/consult-2026-07-13-fix-plan-materiality.md](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-07-13-fix-plan-materiality.md)
**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 3

> **This plan was cut from 6 items to 3 by an SO consult + live-state verification.** The scanner surfaced 55 backlog items; 6 looked actionable; 3 survived. Two of the six were already done (git-reconciled), one was already done *and its log entry lied about it*, and two were parked as grooming with named unpark triggers. The SO's verdict: *"most of this is grooming — and the batch is still worth a session, at ~40% of its scope."* Items 1 and 2 are **control-integrity defects** — broken machinery whose job is catching defects. That is what justifies the session.

## How to execute

Open a fresh Claude Code session in `ai-resources`. Instruct fresh-session Claude:

> Execute the fix plan at `ai-resources/audits/fix-plans/fix-repo-issues-2026-07-13-2134.md`.

Each item below is self-contained. Apply in order.

**Gate discipline (SO-directed — read before starting).** Items 1 and 2 are both `/risk-check` structural change classes (command/agent control-flow edit; hook edit). Run **ONE plan-time `/risk-check` covering both**, and **one at end-time before commit**. Do **not** fire the gate per item. Stacking gates on a three-item session reproduces the very over-gating this repo is already flagged for (`/lean-repo` RR-05; workspace `CLAUDE.md` § Subagent Proportionality — "Do not stack gates").

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-55] `/lean-repo`'s orphan-detection lens cannot observe the signal it claims to measure

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [logs/improvement-log.md:646](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md) — status OPEN, severity **high**
- **Why it matters (named consequence):** the lens tested for command usage by grepping `ai-resources/` only — but commands are invoked from *project* sessions, which log to their *own* `logs/`. It therefore returns "zero use" for heavily-used commands **by construction**. On 2026-07-13 it produced a confident, operator-approved instruction to delete six commands, **four of which are in live use** — including `/explore-section`, the primary command of the live `axcion-design-studio` project, whose `.claude/commands` is a symlink to the whole canonical directory (so the canonical file *is* the file that project runs). Only a batched `/risk-check` + direct verification stopped it. Leaving this unfixed leaves a live tool that fabricates deletion authority.
- **Fix — two parts. Part B is the one that actually closes it; do not stop at Part A.**

  **Part A — widen the search scope.** In `.claude/commands/lean-repo.md` (the Q3 "orphan/adoption grep" definition) and `.claude/agents/lean-repo-auditor.md`, make any orphan/adoption check over commands scan `projects/*/logs/` and `projects/*/CLAUDE.md` in addition to `ai-resources/`. Read the current Q3 text first — do not assume its shape.

  **Part B — downgrade the verdict, not just the search (SO-directed).** Widening the grep makes the lens *less wrong, not right*: "zero hits" still will not mean "unused" (usage also lives in scratchpads, operator habit, and un-logged invocations; `ai-resources/logs/usage-log.md` has been opt-in since 2026-07-04, so absence of a log line is not absence of use). Change the emitted verdict language from an actionable **"orphan → remove"** to **"no evidence of use in scanned scope → CONFIRM BEFORE DELETE"**, and state the scanned scope explicitly in the report so a future reader can see what the instrument could and could not see. The report must never again hand the operator a delete instruction it has no standing to make.
- **Blocking relationship — do not invert it.** M-1 (a pending `/lean-repo` plan item) folds this same Q3 lens into `/architecture-review`. **This item must land before M-1.** If M-1 lands first, the defect propagates into `/architecture-review`, where — per the SO — the operator is *more* likely to act on the verdict and *less* likely to re-verify it. After this lands: M-1 → R-3, in that strict order.
- **Method check before you call it done (this is the defect's own lesson).** The audit asked *"is there evidence of use?"* and found none. The right question is *"would my method see the evidence if it existed?"* — a falsifiability check on the instrument, run **before** the measurement is trusted. Validate the fix the way the S7 `/prime` Step 3 fix was validated: **plant a known-positive** (a command you *know* is used only from a project — `/explore-section` is the ground truth here, 89 invocation mentions in `axcion-design-studio`) and confirm the corrected lens *finds* it. A fix that cannot be falsified has not been tested.
- **Target files:** `.claude/commands/lean-repo.md`, `.claude/agents/lean-repo-auditor.md`. Cross-ref (do not edit yet): `.claude/commands/architecture-review.md`.
- **Post-fix log update:** flip the `logs/improvement-log.md` 2026-07-13 entry to `**Status:** applied YYYY-MM-DD` + a `**Verified:**` line naming the planted-positive test and its result. Also un-annotate or correct the FALSE block in `audits/lean-repo-2026-07-13.md` § INVESTIGATE to record that the instrument is now fixed (the I-1…I-7 question becomes re-askable, but **only** with the corrected method — see "Parked" below).
- **QC needed:** yes — `/risk-check` (batched with item 2, plan-time + end-time). This edits command/agent control flow on a tool that issues deletion recommendations.

### [ai-resources/id-53] `/wrap-session` instructs an action that `check-foreign-staging.sh` blocks

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [logs/improvement-log.md:608](/Users/patrik.lindeberg/Claude%20Code/Axcion%20AI%20Repo/ai-resources/logs/improvement-log.md) — status logged (pending), severity medium
- **Why it matters (named consequence):** `wrap-session.md` Step 12d explicitly instructs staging `logs/runs/{date}-{marker}.json`. `check-foreign-staging.sh`'s shared-artifact allowlist covers `session-notes.md`, `decisions.md`, `usage-log.md` and friends — but **not** `logs/runs/*.json`. So one command instructs the stage and another guard blocks it. It fires on **every wrap whose mandate did not enumerate `logs/runs/`** — i.e. every session whose mandate was written at `/prime` time, before the wrap artifacts existed, which is the normal case. The file it flags as possible foreign contamination is marker-scoped, and therefore the one file in the wrap that is *structurally incapable* of being foreign. **The dangerous failure mode is not the block — it is the workaround.** An agent that hits this reaches for a bypass, and learns to route around the exact tripwire that stops concurrent-session contamination. Per the SO, this guard is a High-classified hard-block (`risk-topology.md § 1`); teaching sessions to defeat it is far more expensive than the block.
- **Fix:** add `logs/runs/*.json` to `check-foreign-staging.sh`'s shared-artifact allowlist. **One line**, at the guard end — where the marker-scoping invariant actually lives. Read the existing allowlist's exact pattern syntax first; match it (the hook matches literally — brace-expansion shorthand does **not** work, a contract break already logged twice this week).
  - *Alternative already considered and rejected:* have `/prime` pre-declare `logs/runs/` in every mandate's `Files in scope`. Rejected — it papers over the guard's model with boilerplate in every mandate, and still breaks for any session that skips `/prime`.
- **Verify:** after the edit, confirm the guard still blocks a genuinely foreign path (plant one) *and* now passes `logs/runs/<today>-<marker>.json`. A one-line allowlist edit that accidentally widens the pattern would silently disable the tripwire — test both directions.
- **Target files:** `.claude/hooks/check-foreign-staging.sh` (allowlist only). **No change to `wrap-session.md`** — Step 12d is correct as written.
- **Post-fix log update:** flip the `logs/improvement-log.md` 2026-07-13 entry to `**Status:** applied YYYY-MM-DD` + `**Verified:**` naming the both-directions test.
- **QC needed:** yes — hook edit is a `/risk-check` change class. **Batched with item 1** under one plan-time gate and one end-time gate. Do not fire a separate gate for this item.

### [ai-resources/id-hygiene] Four stale records that misinform every future scan

- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` (plus one file in `projects/axcion-ai-system-owner/`)
- **Why it matters (named consequence):** this is not cosmetic — **it is the disease this plan just caught itself suffering from.** Of the six items originally proposed for this batch, **three were already done** and only their log entries said otherwise. Every backlog scan re-reads them, re-ranks them, and re-spends triage on them; the 2026-06-05 precedent had 6 of 7 SO-vetted items dissolve on reconciliation. Per the SO: *"closure before detection"* (`principles.md § OP-12`) — detection has outrun closure, and stale-open records are the mechanism.
- **Fix — flip four records to reflect live state. Verify each before flipping (do not trust this plan's commit hashes blindly — open the artifact).**

  1. **`/tech-consult` built but unwired** — `logs/friction-log.md`, 2026-07-02 entry. **Already resolved** by commit `0535bde` ("batch: /tech-consult wiring + evaluator model-tier fix"). Annotate the entry `— **Resolved:** 2026-07-03 (commit 0535bde)`.
  2. **Two dead `detect-concurrent-session.sh` project copies** — `logs/improvement-log.md`, 2026-07-13 entry, status still `logged (pending) — deletion needs operator approval`. **The deletions already landed**: commits `b3f97ff` (`positioning-research`) and `bfff0c8` (`research-pe-regime-shift-advisory-gap`). Flip to `applied` + `**Verified:**` naming both commits.
  3. **Three dead workspace-root symlinks** — `logs/improvement-log.md`, 2026-07-13 `/fix-symlinks` entry. Its **Proposal part (1)** claims `<workspace-root>/.claude/commands/` carries 3 broken symlinks (`audit-critical-resources.md`, `diagnostics-plan.md`, `route-change.md`). **This is false against live state — verified 2026-07-13:** all three files are absent (removed by commits `6bd3d8c` and `319207c`), and `find .claude -type l ! -exec test -e {} \;` at the workspace root returns **zero** dangling symlinks. Correct part (1) in place — mark it already-resolved. **Leave part (2) (widen `/fix-symlinks` scan scope) OPEN — it is parked, see below.** Do not delete the entry; the coverage gap it names is still real.
  4. **`/route-change` is named as a live command in the System Owner's own grounding doc** (SO side finding). `projects/axcion-ai-system-owner/references/toolkit-relationship.md` lines **13** and **27** both reference `/route-change`. That command was renamed to **`/placement`** (commit `319207c`). The SO grounds its architectural advice on this doc, so a dead command name in it is a live correctness risk to every future consult. Update both lines to `/placement`.
- **Method:** for the two `improvement-log.md` flips, use **`/resolve-improvement-log`** rather than hand-editing — the command exists and owns the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema (SO-directed). Read `.claude/commands/resolve-improvement-log.md` first to confirm the schema before touching the file.
- **Target files:** `logs/friction-log.md`, `logs/improvement-log.md`, `projects/axcion-ai-system-owner/references/toolkit-relationship.md`.
- **Post-fix log update:** n/a — this item *is* the log update.
- **QC needed:** no — log/reference hygiene only, no runtime surface. **Do not** attach a `/qc-pass` or a `/risk-check` to this item; that is exactly the gate-stacking the SO warned against.

## Parked items (not this plan) — each with a named unpark trigger

Per the SO: *"A parked item that never recurs was never a defect — it was a preference."* These are parked with triggers, not forgotten.

- **[ai-resources/id-48b] Widen `/fix-symlinks` scan scope to the workspace root** — reason: `needs-dedicated-session` (**design hazard — do not execute as originally written**). The SO's catch: the workspace-root exception landed 2026-07-13, making `lean-repo`, `new-project`, `deploy-workflow`, `pipeline-review`, and `scope-project` **legitimate** at the root. `/fix-symlinks` re-reads `EXCLUDE_COMMANDS` from `auto-sync-shared.sh` with `sed`. **If the widened scan applies `EXCLUDE_COMMANDS` as a validity test at the root, it deletes exactly those five commands** — the same class of near-miss as item 1. *Unpark when:* a plan states explicitly how the root scan handles the workspace-root exception. Not before.
- **[ai-resources/id-49] `run-manifest.sh` marker oracle breaks across midnight** — reason: `low-roi` this cycle. Fails **loudly**, and the documented `--date`/`--marker` escape hatch works. *Unpark on:* the first live hit that costs real time, or when `run-manifest.sh`'s marker resolution is being touched for any other reason (fix the class then — the sibling `check-decision-refs.sh` already has the correct implementation to mirror; better still, extract one shared helper, since DR-7's two-consumer trigger is met).
- **[ai-resources/id-47] Six commands spawn `general-purpose` unpinned** — reason: `low-roi` this cycle. The entry's own severity note says *"no defect in effect today"* — the six inherit the session model, which today is Opus. `CLAUDE.md` § Model Tier already binds **new** commands to pin from creation, and already records this gap explicitly, so it is tracked-not-ignored. *Unpark on:* Haiku or Sonnet sessions entering routine use (at which point an unpinned judgment dispatch silently runs at the wrong tier — the actual failure this rule exists to prevent).
- **[ai-resources/id-09] `check-foreign-staging.sh` fails open for footprint-less sessions** — reason: `decision-needed`. Severity **low**, `Review-cycle: monthly`, and its own proposal is only *"consider a complementary minimum guard"* — no defined fix exists to execute. *Unpark on:* the monthly review cycle, or a live incident where a footprint-less session stages foreign work.
- **[ai-resources/id-05, id-08, id-10, id-11] Concurrent-session staging entanglement; async-subagent stall heuristic; two concurrent sessions producing opposite approved decisions** — reason: `needs-dedicated-session`. Real, but each is a design problem, not a fix.
- **[ai-resources/id-12, id-13, id-14] Open questions — incl. "retire `/lean-repo`?" and MC-1 (risk-tiering the six `/risk-check` change classes)** — reason: `decision-needed`, operator arbitration required. **MC-1 note:** its proposed *"lightweight inline check … escalating on any non-trivial answer"* is a **self-graded materiality call**, which the No-self-waivers clause in `docs/audit-discipline.md` forbids. It is landable only if made bright-line/mechanical. Route to `/friday-act` or a dedicated gated session.
- **[ai-resources/id-46] `axcion-design-studio`'s 89 commands are COPIES, not symlinks** — reason: `risk-check-class` (89-file distribution change; they will drift silently from canonical).
- **[~34 remaining T3 watch items]** — reason: `low-roi`. Parked entries with named triggers that have not yet fired. They fail the named-consequence test *this cycle* (`docs/materiality-bar.md`).

## Skipped items — already resolved (git-reconciled, `docs/backlog-reconciliation.md`)

- **[ai-resources/id-07]** `/tech-consult` built but unwired — **already-resolved (commit `0535bde`)**, 2026-07-03. Status flip folded into item 3.
- **[ai-resources/id-52]** Two dead `detect-concurrent-session.sh` project copies — **already-resolved (commits `b3f97ff`, `bfff0c8`)**. Status flip folded into item 3.
- **[ai-resources/id-48a]** Three dead workspace-root command symlinks — **already-resolved (commits `6bd3d8c`, `319207c`)**; verified absent on disk 2026-07-13 (zero dangling symlinks under the workspace-root `.claude/`). The improvement-log entry asserting they are still present is **stale and factually wrong**; correction folded into item 3.

## Open thread the SO raised, which this plan does not close

The `axcion-ai-system-owner` project's `systems-building-principles.md` is still an empty `TBD` slot. The SO ran this advisory on the vault base alone and flagged that *"a question this squarely about 'when is maintenance worth it' is exactly where that gap costs the most."* Not actionable as a fix — recorded here so it is not lost. Candidate for `/friday-act` or a dedicated session.

**And the line worth keeping:** five consecutive harness-maintenance sessions is the symptom of a system whose *detection* has outrun its *closure* (`principles.md § OP-12`). The remedy is not more scans. It is finishing, parking honestly, and letting un-recurring items stay parked.
