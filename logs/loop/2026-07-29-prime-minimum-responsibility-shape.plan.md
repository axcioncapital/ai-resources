UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape
REPO: ai-resources
BASE: ff42ce50e2ec670d861b55268b7816ea74a80236
NEXT: Codex — pre-implementation review of this PLAN, then G1

PLAN

Immutable. A revision is `-v2`. Nothing in this unit edits any object under work.

---

## 0 · What premise verification changed

Three findings from Step 4 alter the Frame's design and are load-bearing here.

**C1 — the delegation is not free: it needs a reciprocal edit to `/session-start`, and without one
the target's own success criterion breaks.** The Frame assumed auto mode could be absorbed through
the existing `{gate:post-plan}` chain. Reading the chain end-to-end shows the opposite. Auto mode's
contract is **one** operator stop (`prime.md:595`, "single combined approval gate and no per-stage
prompts"). The chain `/prime` → `/session-start` → `/session-plan` contains up to **four**:

| Stop | Site | Fires |
|---|---|---|
| 1 | `session-start.md:197-204` Step 2 confirmation | always |
| 2 | `session-start.md:262` Step 2.4 re-emit | whenever the context engine returns a pack |
| 3 | `session-plan.md:30-39` Step 0 three-option prompt | on same-session re-invocation |
| 4 | `session-plan.md:231-235` Step 8 | only when `{gate:post-plan}` is set |

Stop 4 is already avoidable (auto mode simply does not pass the token — `POST_PLAN_GATE` unset is
the auto-proceed default, `session-plan.md:237`). Stops 1 and 2 are **not** avoidable with anything
that exists today. A naive delegation therefore converts auto mode's one stop into three. That is a
change to the operator experience the brief forbids, and it is the single largest risk in the stream.

The fix is one new leading token, in the same shape as the two already in the chain. See § 2, Slice 1.

**C2 — step identifiers are a published interface. Renumbering is prohibited, not merely risky.**
Fourteen files outside `prime.md` cite its step numbers, including three shell scripts that are not
prose readers:

```
docs/context-pack-schema.md        4 × Step 8c.4.5
docs/backlog-reconciliation.md     4 × Step 1a          (:65 reference-implementation, :111)
docs/session-marker.md             3 × Step 8k · 2 × Step 8m · 2 × Step 8c.7 · 1 × Step 1a
.claude/agents/context-discovery.md 2 × Step 8c.4.5
.claude/commands/session-start.md  2 × Step 8m · 1 × Step 8c.7 · 1 × Step 8a
.claude/commands/mission.md        2 × Step 1d · 1 × Step 1a
logs/scripts/run-manifest.sh       1 × Step 8k · 1 × Step 8c.7
logs/scripts/foreign-session-guard.sh 1 × Step 8a
logs/scripts/check-usage-log-format.sh 1 × Step 1
docs/{repo-architecture,heavy-read-discipline,commit-discipline}.md  1 each
.claude/commands/{wrap-session,usage-analysis,resolve-*,new-project,session-plan}.md
```

**Constraint:** every retained step keeps its current identifier. A step whose content is delegated
has its citations repointed to the new owner **in the same commit**. No step is renumbered.

This also **de-risks premise P5**: because Step 1a's git half is *retained* (the Frame's own P5b
correction), `docs/backlog-reconciliation.md`'s four citations stay valid and no atomic authority
update is needed. The premise is confirmed; the risk it names does not arise under this design.

**C3 — the ~280 figure does not survive contact with C1. The honest projection is ~297, and the
target is met with ~3 lines of slack, not ~20.** Re-budgeted in § 1. Stated plainly because a target
met only on optimistic assumptions is not met, and because this is the number G2 will be judged on.

---

## 1 · Line budget — every retained section, and the owner of everything delegated

Current spans re-derived live from step anchors; all 18 sum to exactly 830.

| Step | Now | Target | Disposition | Authoritative owner of what leaves |
|---|---:|---:|---|---|
| preamble | 12 | 10 | retain | — |
| 0 Pull latest | 58 | 14 | retain, slimmed | rationale → `docs/commit-discipline.md` (already owns git behaviour; already cites Step 1a) |
| 1 Session notes | 24 | 16 | retain, slimmed | — |
| 1a Cross-check + concurrency | 69 | 20 | **split** | git half **retained** (it is `docs/backlog-reconciliation.md`'s reference implementation). Concurrency half → `detect-concurrent-session.sh` + `/concurrent-session-check` |
| 1b Scratchpad | 12 | 10 | retain | — |
| 1c Plan position | 39 | 12 | retain, cite-only | `/project-next-steps` Step 2 (the step already says it reuses that cascade) |
| 1d Mission scan | 19 | 10 | retain, slimmed | `/mission` (contract mechanics) |
| 2 next-up | 4 | 4 | retain | — |
| 3 Urgent scan | 39 | 20 | retain, slimmed | anti-regression rationale → `docs/heavy-read-discipline.md`. **The `medium-high` tier stays** — narrowing it is a policy change (`prime.md:270-275`) and is out of scope |
| 4 Exception checks | 12 | 10 | retain + **remove F2** | — |
| 5 Build menu | 20 | 18 | retain | — |
| 6 Output brief | 39 | 24 | retain, compressed | — |
| 7 Classify reply | 9 | 9 | **retain untouched** | — (named unloseable) |
| 8m Mission binding | 9 | 8 | retain | — |
| **8k Marker allocation** | **147** | **12** | **delegate** | new `logs/scripts/prime-marker.sh` + `docs/session-marker.md` § Marker allocation |
| 8a Numbered dispatch | 50 | 15 | retain, consolidated | — |
| 8b Free-text dispatch | 32 | 11 | retain, consolidated | — |
| **8c Auto mode** | **236** | **64** | **delegate** | `/session-start` Steps 2 / 2.4 / 2.5 / 3 / 3.5 · `/session-plan` Step 7 |
| **8h** marker→header→mtime *(new, shared)* | 0 | 10 | **consolidate** | — (written once instead of three times) |
| **Total** | **830** | **297** | | |

**8k's 12-line target is credible and measured**, not apportioned: of its 147 lines, **88 are
comment-only, 5 blank, 54 executable** (`grep -cE '^\s*#'` over lines 366–512). The 88 comment lines
are anti-regression rationale that `docs/session-marker.md` already has sections for (§ Marker
allocation :65, § Why (d) exists :82, § Known gap :103). Delegating them is consolidation into an
existing owner, not invention.

**8c's 64-line target is a correction upward from the Frame's 45.** Itemised so Prove can check each:
item resolution 8 · done-condition check 10 · plan-mode guard 2 · cross-repo mission guard 4 ·
mission auto-bind 2 · compose `MANDATE_TEXT` 4 · three disclosure fields 6 · gate block + parser 16 ·
dispatch 4 · risk-check 4 · execute 4.

**Every other step's budget is apportioned from reading its prose, not derived by rewriting it.**
That is a real weakness and is repeated in § 6.

---

## 2 · Required slices

Vertical: each leaves the repository working and independently revertible. Executed in order; each is
one Build unit, one commit, pathspec-staged.

### Slice 1 — Delegate auto mode · 236 → 64

The slice that carries the verdict. Do this first: if it fails, the target is unreachable and the
stream should stop rather than spend three further slices.

**The mechanism — one new leading token, `{gate:pre-approved}`.** Same shape as `{mission:<id>}` and
`{gate:post-plan}`, captured by the same Step 1 loop. It states: *the caller has already taken a
single combined approval covering mandate and plan; do not stop again.*

- `/session-start` Step 1 captures it → `PRE_APPROVED = true` (absent → unset → today's behaviour
  exactly, on every other caller).
- Step 2: when `PRE_APPROVED`, render the confirmation block **as a non-blocking echo** and proceed —
  no "Reply `confirm`" ask, no wait.
- Step 2.4: when `PRE_APPROVED`, suppress the **re-emit** only. The pack is still discovered, still
  applied, still recorded on the mandate line and still disclosed — it is folded into `/prime`'s own
  gate block instead of prompting a second time.
- Step 2.5's self-check, Step 3's write and Step 3.5's manifest are **unchanged** — they never prompt.
- `/session-plan` needs **no edit**: auto mode passes no `{gate:post-plan}`, so Step 8 auto-proceeds,
  which is already the default.

**Order of operations preserved exactly** — nothing is written before the operator approves:

```
8c.1  resolve PICKED_ITEMS          8c.5  derive 3 disclosure fields (cited heuristics, not schemas)
8c.1.5 done-condition check         8c.6  ── SINGLE GATE ── go / edit / abort
8c.2  plan-mode guard               8c.7  invoke /session-start "{gate:pre-approved} {mission:id} …"
8c.2.5 cross-repo mission guard             → Step 2 echo (no stop) → 2.4 → 2.5 → 3 → 3.5
8c.3  marker + header + mtime (→ 8h)        → Step 4 chains /session-plan → Step 7 writes plan
8c.3.5 mission auto-bind            8c.8  /risk-check if STRUCTURAL_RISK
8c.4  compose MANDATE_TEXT          8c.9  execute
```

`abort` still writes nothing: the only pre-gate write is the marker/header/mtime at 8c.3, which is
already the case today (`prime.md:8c.3` precedes `8c.6`) and is what the cross-repo guard at 8c.2.5
exists to protect.

**The three disclosure fields stay inline and this is deliberate.** `RECOMMENDED_MODEL`,
`AUTONOMY_POSTURE` and `STRUCTURAL_RISK` must appear *in* the gate block, so they must exist before
`/session-plan` runs. They are ~6 lines applying three heuristics **by citation**
(`session-plan.md:86-93`, `:128-147`, `:153-165`), not copies of a schema. Falsification criterion 2
targets copied *schemas* — auto, mandate, context, plan, manifest — and none of those remains.

*Rejected alternative — make `/session-start` Step 2's confirmation serve as auto mode's gate.*
Smaller (no new token), but the gate would then fire before model/autonomy/risk are known, so those
three fields would move to an after-the-fact note. That changes what the operator sees before
approving, which the brief forbids.

*Rejected alternative — give `/session-start` and `/session-plan` a dry-run mode.* Preserves the gate
content exactly but adds a second execution path to two commands and would grow both files. Larger
mechanism, larger blast radius, and it inverts the stream's purpose.

**Files (6):**
| Path | Change |
|---|---|
| `.claude/commands/prime.md` | 8c rewritten to the sequence above |
| `.claude/commands/session-start.md` | Step 1 token capture; Step 2 + 2.4 suppression clauses (**~+8 lines** — this slice makes one file slightly larger; disclosed, not hidden) |
| `docs/context-pack-schema.md` | repoint 4 × `Step 8c.4.5` → `/session-start` Step 2.4; retire `INVOCATION_MODE: auto-prime` |
| `.claude/agents/context-discovery.md` | repoint 2 × `Step 8c.4.5`; drop `auto-prime` from the accepted mode set |
| `docs/session-marker.md` | repoint 2 × `Step 8c.7` → `/session-start` Step 3 (§ Mandate-line bullet contract) |
| `logs/scripts/run-manifest.sh` | repoint 1 × `Step 8c.7` header comment |

**Sub-decision, flagged for G1:** `INVOCATION_MODE = auto-prime` becomes unreachable once 8c stops
invoking the agent directly. Recommendation: retire it, `/session-start` passes `auto-session-start`
for both callers. The alternative — keep it and have `/session-start` forward it — preserves a
telemetry distinction nothing currently reads.

**Rollback:** `git revert <sha>`. All 28 symlinked consumers follow instantly (they are symlinks;
there is no redistribution step). The `session-start.md` addition is inert without the token.

### Slice 2 — Delegate marker allocation · 147 → 12

**Blocked on qualification. See § 4. Do not start this slice before the artifact exists.**

Replace the 147-line embedded block with a call to `logs/scripts/prime-marker.sh`, and relocate its
88 comment lines into `docs/session-marker.md`'s existing sections.

**The tripwire is already built and it fails loudly, not silently.** `prime-allocator.test.sh:17-37`
extracts the allocator **out of `prime.md`** by awk, anchored on the code fence and the
`Allocate N = 1` string, and hard-exits `2` with `FATAL: allocator extraction from prime.md failed`
if the anchors move. So the moment the block leaves the file, the suite fails visibly. Repointing it
from extraction to direct invocation is **part of this slice, not a follow-up.**

**Files (4):** new `logs/scripts/prime-marker.sh` · `.claude/commands/prime.md` (8k → call) ·
`logs/scripts/prime-allocator.test.sh` (extraction → invocation) · `docs/session-marker.md`
(absorb rationale; repoint 3 × `Step 8k`) · `logs/scripts/run-manifest.sh` (repoint 1 × `Step 8k`).

**Rollback:** revert the commit and delete the script. Nothing else calls it, so deletion is safe.
**Fail-safe invariant to preserve verbatim** (`prime.md:400-407`): `HIGH` is seeded from the marker
file *before* any scan and every scan only ever *raises* it. Any implementation that scans first and
consults the marker file second is a destructive regression. This must be a named test case.

### Slice 3 — Consolidate marker → header → mtime · 82 → 26 + 10

The sequence is written three times (8a.3.a, 8b.3.a, 8c.3). Write it once as **8h** and have all
three call it. New identifier, so no existing citation moves; `foreign-session-guard.sh` and
`wrap-session.md` cite `Step 8a`, which survives.

**Files (1):** `.claude/commands/prime.md`. **Depends on:** Slices 1 and 2 (all three call sites must
already be in final shape). **Rollback:** revert.

### Slice 4 — Slim the orientation steps by citing their owners · 224 → 96

Steps 0, 1, 1a (concurrency half), 1c, 1d, 3, 6. Rationale moves to two **existing** docs — no new
artifact: Step 0's pull-strategy incident narrative → `docs/commit-discipline.md`; Step 3's
bounded-scan anti-regression rationale → `docs/heavy-read-discipline.md`.

Includes **F2**: delete `prime.md:281`, which calls the wrong branch "normal" and cites
`/new-project` step 11a, deleted 2026-07-27 (`new-project.md:694` states the opposite).

**Two things must not be touched here.** Step 1a's git cross-check (the reference implementation) and
Step 3's `medium-high` tier — narrowing the latter is a policy change requiring reciprocal edits to
`wrap-session.md` Step 12e and `session-feedback-collector.md`, plus a `logs/decisions.md` record.

**Files (3):** `.claude/commands/prime.md` · `docs/commit-discipline.md` · `docs/heavy-read-discipline.md`.
**Rollback:** revert.

---

## 3 · Optional slice — editorial compression

**Not required to hit ≤300. Droppable in full without affecting the verdict.** Its purpose is
headroom: § 1 lands at 297 with ~3 lines of slack, which is thin.

Step 1b → cite-only (10 → 6) · Step 1c → pure citation of `/project-next-steps` (12 → 4) · Step 6
exception-line block, several single-condition advisories → cited (24 → 20). **Buys ~12 lines →
projected ~285.**

**Files (1):** `.claude/commands/prime.md`. **Rollback:** revert.

---

## 4 · The new durable artifact, and how it is qualified before use

`logs/scripts/prime-marker.sh` is a **new durable AI artifact**. Workspace `CLAUDE.md` § AI Resource
Creation and `docs/work-loop.md` § Execution boundary both require `/develop-ai-resource`. `/work-loop`
may not author it.

Verified this unit: **no capability record exists anywhere in the workspace**
(`find -type d -name development` → empty). So the handoff cannot yet carry the `**Capability:**` /
`**Settled upstream:**` pair, and `/develop-ai-resource` Step 1.0 rejects an unbacked pair as a
**provenance** error — harder to diagnose than a format one.

**Sequence, and it is a hard dependency of Slice 2:**

1. Open the capability record at `projects/{p}/development/{slug}.md` from
   `templates/capability-record.md`, with `owner_project:` equal to its own path segment and
   `capability:` equal to its slug. **Owner project is a G1 decision** — recommendation:
   `axcion-ai-system-owner`, which owns workspace harness infrastructure.
2. Hand out with **both** labels; `**Capability:**` carries the bare slug or path and nothing else.
3. `/develop-ai-resource` authors and qualifies the script.
4. Its disposition returns to the record's `## Pointers` / `## Verification evidence` — **not** to
   the operator, and **not** through this unit, which will be closed by then.
5. This stream stays **open**; the unit closes on its ordinary outcome, **never `routed-out`** — that
   token is for a whole need leaving, and mis-closing here would delete the stream's artifacts while
   the work is live (`docs/work-loop.md:198`).

**If the operator declines the qualification route, Slice 2 is unbuildable and the projection becomes
297 + 135 = 432. The target fails.** Stated now so G1 decides with that consequence visible.

---

## 5 · Dependencies, sequencing, rollback

```
Slice 1 ──► Slice 3 ──► Slice 4 ──► (optional Slice 5)
              ▲
qualification ─► Slice 2 ──┘
```

Slice 1 is independent and first. Slice 2 is blocked on § 4 and can proceed in parallel once
qualified. Slice 3 needs 1 and 2 landed. Slice 4 is independent of 2 but sequenced after 3 to avoid
two commits touching the same regions.

**Rollback, whole stream:** every slice is one commit over a bounded pathspec; `git revert` of the
slice commits in reverse order restores `prime.md` byte-for-byte, and all 28 symlinked consumers
follow with no redistribution. The only artifact outliving a revert is
`logs/scripts/prime-marker.sh`, which is inert once its caller is gone and is deleted in the same
revert commit.

**Pre-Build check, mandatory.** A live git worktree `ai-resources-2` exists on branch
`session/2026-07-29-2` (created 12:24 today, clean, at `aa0e266`). A concurrent session editing
`prime.md` there would produce a merge conflict on a 28-consumer file. Before each Build slice:
`git -C ai-resources worktree list` and `git status` in every listed checkout; if any shows
uncommitted `prime.md` changes, **stop and report** rather than proceed.

---

## 6 · Falsification criteria — what Prove measures

Behavioural, not diff-reading. Each names what will be run.

| # | Criterion | Method | Falsified if |
|---|---|---|---|
| F-LINES | ≤300 lines | `wc -l .claude/commands/prime.md`, re-derived live at close | > 300 |
| F-DUP | No copied schemas | grep the 8 duplication declarations (`Mirrors /session-start`, `verbatim`, `keep the two in sync`, …); **positive control: same grep on the pre-change file must return 8** | any hit, or control does not fire |
| F-MENU | Menu renders | real `/prime` in a scratch checkout | no menu |
| F-NUM · F-FREE · F-AUTO | All three inputs dispatch | one real dispatch each | any path fails to dispatch |
| F-1GATE | Auto mode stops **exactly once** | count operator stops across a real `auto 1,3` run | 0 or ≥2 stops |
| F-8AGATE | 8a still stops post-plan | real numbered dispatch; assert execution did not begin | executes without `go` |
| F-8BNOGATE | 8b still auto-executes | real free-text dispatch | introduces a stop |
| F-ARTIFACTS | Marker grammar and artefacts unchanged | after each dispatch assert `logs/.session-marker`, per-id marker, `## {date} — Session {MARKER}` header, `logs/.prime-mtime`, `logs/runs/{date}-{MARKER}.json` | any absent or misnamed |
| F-DIRECT · F-ENG | Both routes correct | dispatch in a `**Execution route:** direct` project and an engineered one | direct writes a plan file, or engineered does not |
| F-MISSION | Binding survives | dispatch a `[mission:*]` item; assert `- Mission:` on the mandate line | bullet absent |
| F-FAIL | Guards still fire | **negative control** — `/session-start` with no marker must hard-fail | fails open |
| F-ALLOC | Allocator unregressed | `prime-allocator.test.sh` against the **running** implementation | not 19/0 |
| F-SEED | Fail-safe invariant intact | dedicated case: marker file consulted before any scan | scan-first ordering |
| F-CITE | No dangling step citations | re-run the § 0 C2 grep across all 14 files | any citation points at a removed step |
| F-NOIMPORT | No prose moved to an always-loaded prompt | grep `@`-imports in workspace + project `CLAUDE.md`; diff both | either grew, or anything landed in `harness-rules.md` |
| F-QUAL | No unqualified artifact | `prime-marker.sh` traceable to a `/develop-ai-resource` record | script exists without one |

**The plan is falsified as a whole if** the projection exceeds 300; any of auto / mandate / context /
plan / manifest schemas remains copied in `/prime`; state moves to another prompt without a single
owner; an unqualified artifact is required; or any dispatch path lacks a behavioural proof and a
rollback.

---

## 7 · Open items for G1

1. **F1 — the scope conflict.** `work-loop.md:247` forbids editing `/prime`; `docs/work-loop.md:44`
   permits settled corrections to existing commands. The command file's own rule resolves it in the
   contract's favour, but under the other reading **every Build slice here is prohibited and the
   stream is unbuildable.** Too load-bearing to settle by citation. Disposition `operator`.
   Two Codex review rounds on the closed allocator stream did not catch it.
2. **Owner project for the capability record** (§ 4). Recommendation: `axcion-ai-system-owner`.
3. **Retire `INVOCATION_MODE: auto-prime`?** (Slice 1). Recommendation: retire.
4. **Accept ~297 with ~3 lines of slack, or take the optional slice for ~285?**

LIMITATIONS:
- **Every per-step budget except 8k's and 8c's is apportioned from reading prose, not derived by
  rewriting it.** 8k's rests on a measured 88/54 comment-to-executable split; 8c's on an itemised
  eleven-part breakdown. The other fifteen are estimates and are the most likely source of a miss.
- **~297 is a projection, not a measurement.** Nothing was edited. Treat the target as *reachable*,
  never as *met*, until F-LINES runs against the built file.
- **The `{gate:pre-approved}` token is designed but not exercised.** Its effect on Steps 2 and 2.4 is
  reasoned from reading them; no run has demonstrated that suppressing the confirmation leaves the
  rest of `/session-start` intact.
- **No independent review has run on this plan.** That is the next step, and it is why G1 follows it.
  Findings C1–C3 are ones I identified and then judged myself.
- **The two 33-line variants were read and found to share no dispatch surface** — no marker, no menu,
  no `/session-start` call. Their *own* behaviour under a leaned canonical was not tested, because
  there is no interface through which it could change. If that reasoning is wrong, the check is absent.
- **Slice 4's relocation targets were chosen by topical fit**, not by confirming those two docs have
  a section that naturally receives the material.
- **The concurrent-worktree risk is stated as a pre-Build check, not resolved.** Whether a session is
  live in `ai-resources-2` was not determined; its marker directory is empty, which is suggestive,
  not conclusive.
