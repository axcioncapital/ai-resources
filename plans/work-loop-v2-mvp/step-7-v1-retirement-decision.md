# Step 7 — the Work Loop v1 retirement decision

**Date:** 2026-08-01
**Session:** S11-cf1
**Mission:** `work-loop-v2-mvp`
**Authority:** `work-loop-v2-mvp-proposal-v0.4.md` Decision 4 (`:38`) — *"v1 retirement: decided at
pilot start, no later. The choice (archive immediately versus after pilot success) can wait until
then, but pilot start is a hard decision boundary. Two active Work Loop systems must not drift
indefinitely."*

---

## 1. The decision

**Option A — archive v1 immediately.** Taken by the operator, 2026-08-01, at pilot start.

The hard boundary in Decision 4 is met: the choice is made at pilot start, not later.

## 2. What was put to the operator

Three options, with the inspection below in hand:

| | Option | Outcome |
|---|---|---|
| **A** | Archive v1 immediately | **CHOSEN** |
| B | Archive v1 after pilot success | Not taken |
| C | Scoped retirement — retire only the half v2 replaces, decide the rest on its own evidence | Not taken (Claude's recommendation) |

Claude recommended C and stated the reason (§ 3). The operator chose A. **That is the decision; it is
not reopened here.** What this record does instead is make A's full blast radius explicit, so the
session that executes it does not have to rediscover it.

## 3. The inspection — what v1 actually is

Verified by execution on 2026-08-01, not recalled.

### 3.1 The artifacts

| File | Lines |
|---|---|
| `docs/work-loop.md` | 260 |
| `docs/work-loop-spec.md` | 360 |
| `.claude/commands/work-loop.md` | 251 |
| `.agents/skills/work-loop/SKILL.md` | 119 |
| **Total** | **990** |

### 3.2 v2 does not cover all of v1

v1's routes are **solo / reviewed / challenged**, plus a separate **capability unit** kind carrying
G1–G3 gates, streams, phases and capability records (`.claude/commands/work-loop.md` Steps 5, 5a, 5b).

The string `capability` appears **zero times** in all three v2 artifacts — checked by count against
`.claude/commands/work-loop-v2.md`, `.agents/skills/work-loop-v2/SKILL.md`, and
`work-loop-v2-executable-core-v0.1.md`.

This is by design, not by omission: Proposal Decision 1 (`:35`) scopes the MVP to the Direct and
Standard lanes and places Consequential-lane machinery "fully post-MVP."

**So v2 replaces v1's solo and reviewed routes. It does not replace the challenged route or the
capability-development subsystem.** Decision 4's binary framing assumed v2 was a whole-for-whole
replacement; that assumption does not hold. This was surfaced to the operator before the choice.

### 3.3 What A strands — the full list

Everything below currently depends on v1 and has no v2 successor.

**Live consumers**

1. **`skills/capability-development/SKILL.md`** — sets `disable-model-invocation: true`, so it is
   reachable *only* through `/work-loop` (`SKILL.md:24`). Archiving v1 makes it unreachable by any
   path.
2. **`templates/capability-record.md`** — `/work-loop` is its sole writer (`templates/README.md:11`,
   `:31`).
3. **`/develop-ai-resource`** — carries an upstream-mode contract with `/work-loop`: briefs bearing
   `**Capability:**` + `**Settled upstream:**`, verified against a named capability record
   (`develop-ai-resource.md:24`, `:34`, `:64`, `:67`, `:159`, `:163`).
4. **`/leverage-idea`** — routes to `/work-loop` in its decision table and five other places
   (`leverage-idea.md:16`, `:63`, `:166`, `:191`, `:195`, `:270`).
5. **`docs/qc-independence.md:25-27`** — the Independent Review Rule that workspace `CLAUDE.md`
   points at is *phrased* in terms of "`/work-loop`-routed work." Its wording is orphaned by A.
6. **`docs/ai-resource-creation.md:17`**, **`docs/ai-resource-development-playbook/RESOURCES.md`**,
   **`docs/emailos-mvp-learning/{RESOURCES,NOTES}.md`** — documentation naming `/work-loop` as a live
   sibling or authority.

**In-flight work**

7. **One live capability record**: `projects/axcion-ai-system-owner/development/prime-runtime-delegation.md`
   — `status: in-development`, `phase: build`, `stream: 2026-07-30-prime-session-entry-ownership`,
   updated 2026-07-31. It is the only capability record on disk anywhere.
8. **64 commits not in `main`**, across three v1 branches held in git worktrees:

   | Worktree | Branch | Commits ahead of `main` | State |
   |---|---|---|---|
   | `ai-resources-active-unit-routing` | `codex/2026-07-31-active-unit-routing` | 37 | stream **open** (last commit: preflight-shape, plan frozen) |
   | `ai-resources-g1-reviewed-plan` | `codex/2026-07-31-g1-reviewed-plan-invariant` | 25 | stream **closed** (Slice 1 adopted) |
   | `ai-resources-work-loop` | `session/2026-07-29-work-loop` | 2 | marked `prunable` |

9. **Mission `lean-prime-2026-07`** — two open threads (Prove, Land), both run on v1, with
   `logs/loop/` state in this checkout and in both live worktrees.

## 4. What executing A requires

**Execution does not happen in this session.** Two reasons, both stated rather than assumed:

- It is outside this session's declared mandate (`logs/session-notes.md`, S11-cf1 — "Out of scope:
  Step 8 entirely … executing the retirement").
- Retiring a command wired into two live commands, one doctrine document and 64 unmerged commits is a
  **structural change class**. It gets one **risk-aware** independent Codex review before
  implementation (`docs/qc-independence.md` § Risk-aware review; workspace `CLAUDE.md` § Independent
  Review Rule). No such review has been sized or run.

The executing session must, in this order:

1. **Resolve the 64 unmerged commits.** Merge, or explicitly abandon with the reason recorded. Do not
   archive v1 while a branch that only v1 can drive is unmerged — the work becomes unreachable by any
   live command.
2. **Close or migrate the `prime-runtime-delegation` capability record**, and settle
   `lean-prime-2026-07`'s two open threads. Both currently depend on a command that would no longer
   exist.
3. **Decide the fate of the capability-development subsystem** — `capability-development/SKILL.md`,
   `templates/capability-record.md`, the record format, the G1–G3 gates. A has no successor for it.
   Retire it alongside v1, or give it a new executor. Leaving it in place with no reachable caller is
   the one outcome to avoid: a built subsystem nothing can invoke reads as available and is not.
4. **Repair the six documentation and routing consumers** in § 3.3 items 3–6, including the
   `qc-independence.md` wording, so the Independent Review Rule still names a real route.
5. **Prune the `session/2026-07-29-work-loop` worktree** (already `prunable`) once its 2 commits are
   dispositioned.
6. **Then archive** the four v1 artifacts.

## 5. Basis and alternatives

**Basis for A, as the operator holds it:** Decision 4's stated concern is that two active Work Loop
systems must not drift indefinitely. A is the only option that removes the second system outright,
and it removes it at the earliest permitted moment. B defers the same work without changing it. C
keeps two systems alive on a promise to decide later, which is the shape Decision 4 was written
against.

**Alternative not taken — C (Claude's recommendation).** Retire only v1's Direct/Standard half, which
v2 demonstrably replaces; give the capability route its own decision, on its own evidence, at the
Step 8 post-pilot assessment. Rejected by the operator. Its weakness, stated at the time: it concedes
part of Decision 4's anti-drift purpose and only holds if the second decision carries a hard trigger.

**Alternative not taken — B.** Archive after pilot success. Same stranding as A, later.

## 6. Status

- **Decision:** made and recorded. Decision 4's hard boundary is satisfied.
- **Execution:** not started. Owned by Step 8 (Proposal `:111`), gated on one risk-aware Codex review.
- **Review of this record:** none. This document records a decision; it changes no runtime artifact.
