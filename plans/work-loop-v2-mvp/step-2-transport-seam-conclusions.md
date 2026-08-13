# Work Loop v2 MVP — Step 2: transport-seam conclusions

**Session:** 2026-08-01, S2-af1. **Mission:** `work-loop-v2-mvp`.
**Playbook step:** 2 — prototype the transport seam (throwaway).
**Status of the prototype:** run once, end to end, then discarded. Only this note is kept.

Source tags follow the Step 1 note's convention: **[local]** = observed by Claude in this
checkout; **[codex]** = reported by Codex inside the Codex app; **[operator]** = supplied by the
operator. Nothing below is inferred without being marked as such.

---

## 1. Did the round trip work?

**Yes — once, end to end. But not by the mechanism the Proposal describes.**

The three hops all completed:

| Hop | Actor | Action | Outcome |
|---|---|---|---|
| 1 | Codex | wrote `logs/loop/wl2-state.md` with a brief | **succeeded** **[codex]** |
| 2 | Claude | read the brief, answered it, wrote the result, committed | **succeeded** **[local]** |
| 3 | Codex | read the result, acted on the `turn:` field | **succeeded** **[codex]** |

**The correction that matters: Git carried none of the hand-off.**

The state file's complete history is **one commit** — Claude's. **[local]**, `git log --oneline --
logs/loop/wl2-state.md`, count 1. Codex was asked for the last *two* commits and received one,
because only one exists. **[codex]**

- Hop 1 reached Claude because both processes share **one working tree**. It was never committed.
- Hop 3 read the same working-tree bytes it would have read with or without Claude's commit.

So in the observed round trip, the **transport was the filesystem**. The commit was a durability
and audit step layered on top of it — valuable, but not the thing that moved the data.

This is an observation, not a proposed redesign. Changing the Proposal's stated transport is a
Proposal-level decision and is explicitly **not** made here (`README.md` authority order;
`step-1-codex-packaging-findings.md:111-113`).

---

## 2. Premise 1 — can Codex commit? **No, in two independent sessions. But it is not fixed policy.**

**Established.** `git add` failed under Codex with:

```
fatal: Unable to create '.../.git/index.lock': Operation not permitted
```

**[codex]** — reproducing Step 1's observation of 2026-08-01 exactly, in a separate session. Two
independent observations, same error. `git commit` was not attempted: the instruction set told
Codex to stop at a block rather than escalate, and it did. **[codex]**

**The block is not a property of the repository.** Proven by positive control: Claude ran the
**identical `git add`, on the identical file, in the same checkout**, and it succeeded. **[local]**
Supporting checks: `.git` is owned by the operator, mode `drwxr-xr-x`; no stale `index.lock`; no
immutable file flags. **[local]**

**The fence is on `.git` writes specifically — not on Git as a whole.** Three data points from
inside Codex: `git status --short` succeeded **[codex]**, `git log --oneline` succeeded
**[codex]**, `git add` failed **[codex]**. Read commands pass; the write is refused.

**It is configurable in principle.** The Codex binary at
`/Applications/ChatGPT.app/Contents/Resources/codex` documents its own controls **[local]**:

| Control | Values |
|---|---|
| `-s, --sandbox` | `read-only`, `workspace-write`, `danger-full-access` |
| `-a, --ask-for-approval` | `untrusted`, `on-failure`, `on-request`, `never` |
| `--add-dir` | additional writable directories |
| `--dangerously-bypass-approvals-and-sandbox` | (self-describing) |

`~/.codex/config.toml` (123 lines) sets **neither** `sandbox_mode` **nor** `approval_policy`
**[local]** — confirming Step 1 § 3 — so the effective profile comes from the desktop runtime's
defaults.

**What is therefore settled, stated precisely:**

- **Settled:** the block is a sandbox restriction on the Codex process, not a repository fault, and
  the runtime exposes documented levers that could change it.
- **Not settled:** whether any setting *short of* `danger-full-access` un-blocks `.git`. Step 1
  established the session was already running as `workspace-write` and `.git` was still blocked,
  so **enabling `workspace-write` is not the fix.** `--add-dir` adds directories *outside* the
  workspace, and `.git` is *inside* it, so it is very likely the wrong instrument — **unverified.**

No sandbox setting was changed and no escalation was attempted. Doing so is an operator decision
about their own machine, and `danger-full-access` removes the fence for everything, not only Git.

---

## 3. Premise 2 — does a new skill in `.agents/skills/` reach Git? **Only with its own re-include line.**

Answered by execution, with a before/after and a sibling control **[local]**:

| State | `git check-ignore` | `git status` |
|---|---|---|
| New folder, no re-include | ignored by `.gitignore:76` (`.agents/skills/*`) | invisible |
| After adding **one** line | not ignored | `?? .agents/skills/wl2-probe/` |
| Sibling with no re-include | still ignored by `:76` | invisible |

**Refinement over what Step 1 handed forward.** Step 1 recorded that four rules were needed to
adopt `work-loop`. A *new* skill added afterwards needs **exactly one** line —
`!.agents/skills/<name>/` — because the three-rule ladder above it (`.agents/*`,
`!.agents/skills/`, `.agents/skills/*`) already exists and only the final re-include is missing.

Baseline confirmed unchanged: 5 pre-existing skill folders on disk, **1** tracked (`work-loop`).
**[local]**

The probe line was reverted immediately after the test; `.gitignore` is unmodified. **[local]**

---

## 4. Premises 3 and 4 — not tested

Both were optional depth in this session's plan and were dropped when premise 1 consumed the
available Codex hops. They remain open exactly as Step 1 left them:

3. Whether explicit `$name` invocation is reliable given the over-cap description budget.
4. Whether `codex exec` works as a non-interactive entry point.

Not tested is not the same as not working. Neither was attempted.

---

## 5. The minimal viable schema

The file was designed deliberately **below** the Proposal's § 3 decision 10 content ceiling, to
find out what was genuinely needed. What was used:

```markdown
---
unit: wl2-probe-01
turn: codex          # claude | codex
---

## Brief
<what the other side should do>

## Result
<what was done>
```

Per-field verdict:

| Field | Verdict | Evidence |
|---|---|---|
| `turn` | **Earned its place.** The field that told each side whether to act. | Codex used it unprompted to determine it was its turn **[codex]** |
| `## Brief` | **Earned.** Consumed by Claude at hop 2. | **[local]** |
| `## Result` | **Earned.** Consumed by Codex at hop 3. | **[codex]** |
| `unit` | **Not exercised.** Neither side referenced it. | Its purpose — catching a stale leftover file — cannot arise in a single clean round trip. Retain provisionally; do not claim it proven. |

**Asked directly whether anything was missing or unnecessary, Codex answered no to both**
**[codex]**. That is a genuine result for a file this small, but it is one trip on a toy task —
it is evidence of sufficiency at this size, not at production size.

### The finding Step 3 should not miss

**`turn` is a *protocol* field, and the Proposal's § 10 ceiling lists only *content* fields**
(objective and scope, lane and unit, latest result, blocker, next action). The one field that
demonstrably did work in this prototype is not on that list.

This is a **gap in the ceiling, not a violation of it** — the ceiling caps content and is
explicitly a maximum, not a mandatory minimum. Step 3 writes the task-state interface and should
decide consciously whether hand-off state (whose turn it is) belongs in the same file as task
state, or is a separate concern. Flagged, not decided.

---

## 6. Open gaps

1. Whether any sandbox setting short of `danger-full-access` un-blocks `.git` writes for Codex
   (§ 2). Operator-checkable in the Codex app's own settings.
2. Whether the observed block is per-session or per-install — two sessions is not a trend.
3. Premises 3 and 4 (§ 4), carried forward untested.
4. Whether `unit` is necessary (§ 5) — untestable in a single-trip prototype.
5. Whether the schema holds at production size. One toy task is not a load test.

---

## 7. What Step 3 inherits

1. **A working round trip** — but one whose transport is the shared working tree, not Git.
2. **A three-field schema** with evidence for each: `turn`, `## Brief`, `## Result`.
3. **An open design question** the Proposal's ceiling does not answer: where hand-off state lives.
4. **A constraint to design around, not to fight:** Codex writes files freely and reads Git freely;
   it cannot write `.git` under the current profile. The Proposal's own role statement — *"Claude
   owns repository reality"* (`pocock-lifecycle-work-loop-mvp-v0.4.md:91`) — is compatible with
   that constraint, but whether to formalise it is a Proposal-level call and remains the
   operator's.
