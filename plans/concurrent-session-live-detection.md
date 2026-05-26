# Live Concurrent-Session Detection — /prime → /session-start mtime Guard Plan

**Date:** 2026-05-26
**Primary source entry:** `projects/axcion-brand-book/logs/improvement-log.md` § "2026-05-26 — /prime Step 1a sibling-entry sweep not mechanically enforced; missed live parallel-session signal" — **deeper structural gap noted** ("/prime has no live concurrent-session detection (only retrospective signals via sibling-entry sweep and scratchpad mtime). A separate /resolve-repo-problem MANUAL investigation should consider whether to add an mtime-based 'session-notes.md was modified between /prime and /session-start' guard.")
**Secondary source:** `ai-resources/logs/friction-log.md` § "Session — 2026-05-25 14:10 — `/session-plan` uses a single shared file" — **verification only**: the friction-log entry's narrow concern is already addressed by Wave C (2026-05-26 commit `8ab5685`). This plan handles the orchestration-level gap the original entry did not cover.
**Status:** Plan draft (no code edits this session)
**Intended execution:** Separate session

---

## Source citation

- **Primary (open):** brand-book improvement-log 2026-05-26 — the entry's Proposal section adds the discrete bash check for Step 1a (covered in plan `prime-step-1a-sibling-sweep.md`), then explicitly notes that the deeper gap (live concurrent-session detection between `/prime` and `/session-start`) warrants "a separate /resolve-repo-problem MANUAL investigation". This plan **is** that separate investigation.
- **Secondary (already shipped, included for evidence chain):** ai-resources friction-log 2026-05-25 14:10 — `/session-plan` collision on shared file path. Wave C (commit `8ab5685`) added Step 0 intent-comparison auto-routing to `session-plan-pass2.md` on mismatch. This plan covers the orchestration layer above that fix.
- **Operator's stated priority:** "concurrent sessions running into conflicting session mandates and session plan notes" (2026-05-26 session). "Mandates" plural = the `/session-start`-written field, not the `/session-plan` Intent line. Wave C does not protect mandates.

## Diagnosis

### What's covered today

`/session-plan` Step 0 (lines 11–52 of `session-plan.md`) implements intent-comparison concurrent-session detection: when `logs/session-plan.md` exists, modified within 6 hours, and the upcoming intent does NOT substring-match the existing intent, Step 0 auto-routes the new plan to `session-plan-pass2.md`. This protects the **plan file** from being clobbered by a concurrent session.

### What's not covered

The `/prime` → `/session-start` chain has no equivalent guard. The failure mode (live, 2026-05-26 brand-book session):

1. Session A runs `/prime` at 10:24. `/prime` reads `logs/session-notes.md` (tail-60), surfaces a menu, waits for the operator.
2. Session B (a still-active parallel session) commits at 10:23, then writes a new mandate header into `logs/session-notes.md` at 10:27:46.
3. Session A's operator picks task-1 at 10:28. Session A's `/prime` Step 8a creates today's header (if it didn't already perceive Session B's write) and invokes `/session-start`. `/session-start` Step 0 reads the file again — but it has been modified since Session A's `/prime` read.
4. Two mandates are now stacked in `session-notes.md` for the same day, with no warning at the orchestration layer. The sibling-entry sweep (Step 1a) only fires at the next `/prime`, retroactively.

The missing signal: the **mtime delta on `session-notes.md` between the moment `/prime` read it and the moment `/session-start` writes to it**. If that delta is non-zero (and not Session A's own write), a third process has touched the file.

### Why this matters

The operator's stated concern names "conflicting session mandates" — the file written by `/session-start`. The Wave C fix protects `session-plan.md`. The mandate write happens in `/session-start` Step 3 (the disk-write step that appends `**Mandate:**` to today's header). Nothing today detects that today's header was newly written by a different session 4 minutes ago.

## Implementation plan

**Targets:**
- `ai-resources/.claude/commands/prime.md` — Step 8a (today's-header append) and the handoff to `/session-start`.
- `ai-resources/.claude/commands/session-start.md` — Step 0 (precondition check) or new Step 0.5 (mtime-delta check).

**Recommended design — single mtime check in `/session-start`:**

Place the guard in `/session-start` because that command is where the durable mandate write happens. `/prime` does not need to cache state; `/session-start` re-reads `session-notes.md` already (its Step 0 last-10-lines read), so the mtime check piggybacks on existing IO.

**Add a new Step 0.5 to `session-start.md` between current Step 0 (precondition check) and Step 1 (read the mandate):**

```
### Step 0.5 — Concurrent-session mtime guard

After Step 0's session-notes.md read, capture the file's mtime:

  SESSION_NOTES_MTIME=$(stat -f %m logs/session-notes.md 2>/dev/null \
                       || stat -c %Y logs/session-notes.md 2>/dev/null)

Capture the current epoch:

  NOW=$(date +%s)

Compute the delta:

  DELTA=$((NOW - SESSION_NOTES_MTIME))

If DELTA < 120 (file modified within last 2 minutes — fresh write from another
process), emit this warning and pause:

> ⚠ Concurrent session likely. `logs/session-notes.md` was modified
> {DELTA}s ago — possibly by another active session writing a mandate.
> Re-read the file and confirm before proceeding.
>
> Options:
> 1. Proceed with the new mandate anyway (your mandate will stack below the
>    other session's)
> 2. Stop and resolve manually (recommended)
>
> Default (no response within the turn): option 2 — stop.

If DELTA ≥ 120, proceed silently to Step 1.

The 120-second threshold matches the typical `/prime` → operator response →
`/session-start` window. Tune if false positives accumulate.
```

**Coordinated edit to `/prime` Step 8a (advisory note only):**

Add a one-line note in `/prime` Step 8a immediately after the today's-header append: "/session-start will run a concurrent-session mtime check; if it fires, address the conflict before continuing the chain."

## Risk-check brief

**Pre-filled brief for the implementation session's `/risk-check` call:**

- **Change class:** Edits to two universally-loaded commands (`/prime` advisory note + `/session-start` new Step 0.5).
- **Blast radius:** Every session — `/session-start` runs whenever the chain reaches it. False-positive rate matters here: if a single session legitimately runs `/prime` → operator picks task within 30s → `/session-start`, the mtime delta might be small (because `/prime` itself wrote the today's-header in Step 8a). **Critical mitigation:** the mtime check must distinguish "this session just wrote the header" from "another session wrote the file." Options: (a) check if `session-notes.md` content matches what `/prime` last wrote (read-back); (b) use a marker file (`logs/.prime-mtime`) that `/prime` writes at handoff; (c) check tail content for the today's-header line authored by this session's `/prime`.
- **Reversibility:** Full — Step 0.5 is a single inserted block.
- **Hidden coupling risk:** Medium. The interaction with `/prime` Step 8a (which itself writes to `session-notes.md`) needs explicit handling so the guard does not fire on the chain's own normal flow.
- **Permissions surface:** No change — `stat` and `date` standard tools.
- **Usage cost:** Negligible (one `stat` per `/session-start`).
- **False-positive concern:** HIGH-IMPORTANCE. The mitigation above must be designed into the plan-time implementation, not the after-fact.

Expected verdict: PROCEED-WITH-CAUTION; mitigation list will include the "distinguish own-session write from foreign write" requirement.

**Run `/risk-check` at plan-time before execution.** This is a structural change to two universally-loaded commands; see workspace `CLAUDE.md` Autonomy Rule #9.

## Acceptance criteria

1. `/session-start` Step 0.5 exists with the mtime-delta check and the 2-option pause prompt.
2. The check distinguishes "this session's own `/prime` write" from "foreign session write" using one of: read-back content match, marker file, or tail-content authorship check. (The implementation session picks one and documents the choice.)
3. `/prime` Step 8a has a one-line advisory note pointing to the new `/session-start` Step 0.5.
4. Test fixture: simulate Session B touching `session-notes.md` 60 seconds before `/session-start` runs in Session A — the warning fires.
5. Test fixture: normal `/prime` → operator-picks-task-in-30s → `/session-start` chain in a single session — the warning does NOT fire (own-write distinction works).
6. Implementation session runs `/risk-check` at plan-time; verdict at minimum PROCEED-WITH-CAUTION with the false-positive mitigation applied.
7. Implementation session runs `/qc-pass` after the edit; no REVISE findings.
8. Brand-book improvement-log entry is updated with a back-reference to this plan's commit (the entry's "deeper structural gap" note is now addressed).

## Out of scope for this plan

- Any change to `/session-plan` Step 0 — Wave C already handles `session-plan.md` collisions correctly.
- Changes to `session-notes.md` schema or format.
- Cross-repo concurrent-session detection (this plan is single-repo only).
