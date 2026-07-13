# Session Plan — 2026-07-13

## Intent

Execute the 3-item fix plan at `audits/fix-plans/fix-repo-issues-2026-07-13-2134.md` — repair two control-integrity defects (`/lean-repo`'s orphan lens; `check-foreign-staging.sh`'s allowlist) and flip four stale records to live state.

## Model

**opus** — match (active session model is `claude-opus-4-8[1m]`).

The plan is written, so the *sequence* is spec-following (doing → sonnet). But item 1 Part B is not mechanical: it rewrites the verdict language of a tool that issues deletion recommendations, and it requires designing a falsifiability test (the planted known-positive). Judging whether the corrected lens is *honest about what it cannot see* is a deciding task. Opus is the right tier for that, and item 3's stale-record flips ride along cheaply.

## Source Material

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-07-13-2134.md` — the plan of record (already read this session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/lean-repo.md` — item 1 target (Q3 orphan/adoption lens + verdict language)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/lean-repo-auditor.md` — item 1 target (agent-side twin of the same lens)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` — item 2 target (shared-artifact allowlist)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` — item 3 method (read first; owns the canonical `**Status:** applied` + `**Verified:**` schema)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — item 3 target (three entries)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` — item 3 target (`/tech-consult` entry)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/lean-repo-2026-07-13.md` — item 1 post-fix (§ INVESTIGATE FALSE-block annotation)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/toolkit-relationship.md` — item 3 target (`/route-change` → `/placement`, lines 13 and 27)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes (both items 1 and 2 are in-class)

## Findings / Items to Address

1. **id-55 — `/lean-repo`'s orphan-detection lens cannot observe the signal it claims to measure.** *(`logs/improvement-log.md:646`, status OPEN, severity high.)* The Q3 orphan/adoption check greps `ai-resources/` only — but commands are invoked from *project* sessions, which log to their own `logs/`. It therefore returns "zero use" for heavily-used commands **by construction**. On 2026-07-13 it produced a confident, operator-approved instruction to delete six commands, four of which are in live use, including `/explore-section` (the primary command of the live `axcion-design-studio` project). Only a batched `/risk-check` plus direct verification stopped it.

2. **id-53 — `/wrap-session` instructs an action that `check-foreign-staging.sh` blocks.** *(`logs/improvement-log.md:608`, status logged (pending), severity medium.)* `wrap-session.md` Step 12d instructs staging `logs/runs/{date}-{marker}.json`; the hook's shared-artifact allowlist covers `session-notes.md`, `decisions.md`, `usage-log.md` and friends but **not** `logs/runs/*.json`. One command instructs the stage; another guard blocks it. It fires on every wrap whose mandate was written at `/prime` time — the normal case. The real hazard is not the block: it is that an agent hitting it reaches for a bypass, and so learns to route around the exact tripwire that stops concurrent-session contamination.

3. **id-hygiene — four stale records that misinform every future scan.** *(Named in the plan, § item 3.)* Each is verified-stale against live state:
   - a. `/tech-consult` built-but-unwired — `logs/friction-log.md`, 2026-07-02 entry. Resolved by commit `0535bde`; entry never annotated.
   - b. Two dead `detect-concurrent-session.sh` project copies — `logs/improvement-log.md`, 2026-07-13 entry, still `logged (pending) — deletion needs operator approval`. The deletions already landed (`b3f97ff`, `bfff0c8`).
   - c. Three "dead workspace-root symlinks" — `logs/improvement-log.md`, 2026-07-13 `/fix-symlinks` entry, part (1). **Factually false against live state:** all three files are absent (`6bd3d8c`, `319207c`) and the workspace root returns zero dangling symlinks. Part (2) (widen the scan scope) stays OPEN — it is parked as a design hazard.
   - d. `/route-change` named as a live command in `projects/axcion-ai-system-owner/references/toolkit-relationship.md` lines 13 and 27. Renamed to `/placement` in commit `319207c`. The System Owner grounds architectural advice on this doc, so a dead command name in it is a live correctness risk to every consult.

## Execution Sequence

**Stage 0 — Plan-time `/risk-check` (batched, items 1 + 2 together).**
Both are structural change classes (command/agent control-flow edit; hook edit). One gate covers both, per the plan's explicit gate discipline. *Verify:* verdict is GO. On RECONSIDER/NO-GO → stop, per the mandate's Stop-if.

**Stage 1 — id-55, Part A: widen the scan scope.**
Read the current Q3 text in `lean-repo.md` and `lean-repo-auditor.md` first — do not assume its shape. Extend any orphan/adoption check over commands to scan `projects/*/logs/` and `projects/*/CLAUDE.md` in addition to `ai-resources/`. *Verify:* re-read both files; the widened scope is present in both, and the two copies agree.

**Stage 2 — id-55, Part B: downgrade the verdict.**
Change the emitted verdict from an actionable `orphan → remove` to `no evidence of use in scanned scope → CONFIRM BEFORE DELETE`, and require the report to state its scanned scope explicitly. This is the part that actually closes the defect — widening the grep alone makes the lens *less wrong, not right*, because "zero hits" still would not mean "unused" (usage also lives in scratchpads, operator habit, and un-logged invocations; `usage-log.md` has been opt-in since 2026-07-04). *Verify:* grep both files for any surviving language that asserts deletion authority; zero hits.

**Stage 3 — id-55: the falsifiability test (planted known-positive).**
This is the defect's own lesson applied to its fix. The audit asked *"is there evidence of use?"* and found none; the right question is *"would my method see the evidence if it existed?"* Plant a known-positive — `/explore-section`, which is used only from a project (89 invocation mentions in `axcion-design-studio`) — and run the corrected lens against it. *Verify:* the corrected lens **finds** `/explore-section`. If it does not, the fix is not tested and the mandate's Stop-if fires.

**Stage 4 — id-53: the allowlist edit.**
Read the existing allowlist's exact pattern syntax first and match it literally — the hook matches literally, and brace-expansion shorthand does **not** work (a contract break already logged twice this week). Add `logs/runs/*.json`. No change to `wrap-session.md` — Step 12d is correct as written. *Verify — both directions, because a one-line edit that accidentally widens the pattern would silently disable the tripwire:* (a) the guard still **blocks** a planted genuinely-foreign path; (b) it now **passes** `logs/runs/2026-07-13-S11.json`.

**Stage 5 — id-hygiene: the four flips.**
Use `/resolve-improvement-log` for the two `improvement-log.md` flips rather than hand-editing — it owns the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema. Verify each record against live state before flipping; do not trust the plan's commit hashes blindly. Correct the false symlink claim in place (part 1), leave part 2 OPEN. Update `toolkit-relationship.md` lines 13 and 27. *Verify:* re-grep each file for the old state; zero hits. *No gate on this item* — log/reference hygiene, no runtime surface.

**Stage 6 — post-fix log updates for items 1 and 2.**
Flip both `improvement-log.md` entries to `applied` with a `**Verified:**` line naming the actual test and its result (planted-positive for id-55; both-directions for id-53). Un-annotate the FALSE block in `audits/lean-repo-2026-07-13.md` § INVESTIGATE to record that the instrument is fixed — the I-1…I-7 question becomes re-askable, but **only with the corrected method**.

**Stage 7 — End-time `/risk-check`, then commit.**
*Verify:* verdict is GO. On RECONSIDER/NO-GO → stop, do not commit.

## Scope Alternatives

**Single scope — no alternatives.** The plan was already cut 6 → 3 by an SO consult and live-state verification; the three survivors were each justified against the named-consequence bar, and items 1 and 2 are strictly coupled by the shared gate. There are no degrees of freedom left to trade. Cutting further would leave a live tool that fabricates deletion authority; adding back is exactly the grooming the plan parked.

## Autonomy Posture

**Gated.** The work is bounded and the plan is explicit, but two structural change classes are touched and one of them edits a tool that issues deletion recommendations. The gates are the plan's, not new ceremony.

**Stop points:**
- Plan-time `/risk-check` (Stage 0) returns RECONSIDER or NO-GO
- The id-55 planted-positive test (Stage 3) fails — the corrected lens does not find `/explore-section`
- The id-53 both-directions test (Stage 4) fails in *either* direction — especially a widened pattern that stops blocking foreign paths
- End-time `/risk-check` (Stage 7) returns RECONSIDER or NO-GO

## Risk

**Structural change classes present — items 1 and 2 both qualify.** Item 1 is a command/agent control-flow edit; item 2 is a hook edit. Run `/risk-check` **once, batched across both**, after this plan is approved (plan-time gate), and **once again** before commit (end-time gate). Do **not** fire the gate per item — stacking gates on a three-item session reproduces the over-gating this repo is already flagged for (`/lean-repo` RR-05; workspace `CLAUDE.md` § Subagent Proportionality, "Do not stack gates").

Item 3 gets **no gate** — log/reference hygiene with no runtime surface. Attaching one would be the exact ceremony the plan was cut to avoid.

**Environment-fit check:** not applicable — no launcher, script entrypoint, or terminal-triggered artifact is produced. All three items edit existing in-session infrastructure (a command, an agent, a hook already registered in settings) plus markdown records.

**The specific risk worth naming:** item 2's allowlist edit is one line, and a one-line pattern edit that is slightly too broad would silently disable a High-classified hard-block (`risk-topology.md § 1`) — the tripwire that stops concurrent-session contamination. It fails *open* and quiet. That is why Stage 4's verification is explicitly bidirectional rather than a single happy-path check.
