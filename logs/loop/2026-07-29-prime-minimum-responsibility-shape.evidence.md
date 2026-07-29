EVIDENCE
UNIT: 2026-07-29-prime-minimum-responsibility-shape
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: shape
REPO: ai-resources
BASE: 1dc38b3
NEXT: Claude — open Build unit for Slice 1

Status: complete

---

## What this unit produced

The Shape phase's deliverable is the plan, not a change to the object under work. Three plan
revisions and two Codex review rounds were produced; `.claude/commands/prime.md` was verified
untouched by `git status --porcelain` before every commit in this unit, which is the challenged
route's defining property for Shape.

| Artifact | Commit |
|---|---|
| `…-shape.brief.md` (Codex, transcribed) | `aa0e266` |
| `…-shape.plan.md` (v1, immutable) | `9be8bb0` |
| `…-shape.review-1.md` (Codex, 8 findings) | `4c54344` |
| `…-shape.plan-v2.md` (immutable) | `aa7a56d` |
| `…-shape.review-2.md` (Codex, 7 findings) | `1dc38b3` |
| `…-shape.plan-v3.md` (current — what Build executes) | `1dc38b3` |

`review-2` is justified under `docs/work-loop.md` § The challenged route: review-1's verdict rested
on the auto-mode gate architecture, and the corrections replaced that architecture, so the second
round tested something the first round's verdict had not seen.

## Premise verification (step 4)

The brief asserted seven premises. All were verified against live files during the unit; the four
that carried into the plan's design were **re-verified in this closing session** rather than
recalled, because `docs/work-loop.md` step 4 requires re-derivation against the live file and a copy
read earlier in a session may already be stale.

| Claim | What was run | What was observed |
|---|---|---|
| `prime.md` is 830 lines and untouched | `wc -l .claude/commands/prime.md`; `git status --porcelain` on the three in-scope command files | `830`; empty status — no working-tree change to `prime.md`, `session-start.md` or `session-plan.md` |
| `files_inferred` is **set** at Step 2, not Step 2.4 | `sed -n '106p' session-start.md` | `…flag internally as **inferred** (\`files_inferred = true\`)` — confirmed, set at Step 2 |
| `files_inferred` is **cleared** at Step 2.4, which substitutes engine paths | `sed -n '243p' session-start.md` | `…REPLACE the \`(inferred)\` marker with the engine's concrete list and set \`files_inferred = false\`` — confirmed |
| Two of four engine outcomes produce **no** re-emit | `sed -n '253p' session-start.md` | `For \`engine-skipped\` / \`engine-error\`: do NOT re-emit` — confirmed. This is the silent-approval hole review-2 F1 found |
| Engine skip condition 3 is a missing root `CLAUDE.md` | `sed -n '215p' session-start.md` | Confirmed — gives P-PACK4 a deterministic `skipped` injection |
| `/session-plan` Step 8's default branch tells the operator to begin execution | `sed -n '239p' session-plan.md` | `> Plan written to \`{OUTPUT_TARGET}\` ({autonomy posture}). Begin execution.` — confirmed; this is the control-flow hazard review-2 F2 found |
| `/session-start` hard-fails without a `/prime` marker | `sed -n '330p' session-start.md` | Confirmed — constrains any delegation design that moves marker allocation |

**Positive control on the citation-drift check:** the same `sed` invocations were run against the
line numbers plan-v3 cites. Had any file drifted since the plan was written, the printed line would
not have matched the plan's quoted text. All seven matched exactly, so the plan's line-level
citations are live, not stale.

## Adjudication

Fifteen material findings across two review rounds. Every one was independently re-verified against
live files before disposition — none accepted on the reviewer's word, none rejected without a cited
disproof. All fifteen were confirmed correct: **fourteen `fixed`, one `operator`.** Per-finding
dispositions for round 2 are tabulated at plan-v3 § 6; round 1's are at plan-v2 § 6.

The single `operator` disposition is F5 — no compliant return path exists for an artifact
disposition on a **non-capability** stream, because `docs/work-loop.md:48` routes it "through the
capability record" and `:123` states non-capability streams have none. That is a genuine contract
gap, not a judgement call, so it went to G1 rather than being papered over.

## G1 — scope and package

Presented to the operator: the plan (v3), both reviews, the adjudication, and the slice list. Three
decisions returned:

1. **§ 7.1 allocator qualification — Option A: open a capability record.**
   `projects/axcion-ai-system-owner/development/prime-marker-allocator.md`, handed to
   `/develop-ai-resource` in **upstream mode** with the `**Capability:**` and `**Settled upstream:**`
   labels, so the artifact disposition has a defined return address. This unblocks Slice 2, which is
   worth 135 of the projected line reduction; without it the target fails by roughly that margin.
2. **§ 7.2 operator-experience delta — accepted.** Model tier and autonomy posture move from before
   the auto-mode approval gate to after it (disclosed by `/session-plan` once the plan is written).
   Structural risk stays before the gate, because it decides whether `/risk-check` fires and `/prime`
   owns that call. This removes review-2 F2's duplicate-derivation bug by giving each field exactly
   one owner rather than by adding synchronisation code.
3. **Verdict — approve; open Slice 1.**

**G1 produces no artifact of its own.** `docs/work-loop.md` § The challenged route defines three
stops and the packages they hold, but no gate-record file; § Artifacts lists exactly four artifact
types and none is a gate record. The disposition is therefore recorded here, in the Shape unit's
evidence, and the unit closes. Nothing was improvised into a new file shape.

LIMITATIONS:
- **This evidence file was written in the session *after* the one that produced the plan.** The
  original session was interrupted immediately after the operator answered G1 and before any of it
  reached disk. The G1 answers above are transcribed from that session's handoff scratchpad
  (`logs/scratchpads/2026-07-29-13-04-scratchpad.md`), not from a contemporaneous on-disk record.
  Everything else here is either a commit SHA verifiable in git history or a check re-run against
  live files in this session.
- **Plan-v3 has been reviewed zero times.** Review-2 instructed that adjudication proceed to G1
  without a third round, and that instruction was followed — but the F1/F2 corrections changed the
  architecture again after review-2 read it. The gate re-siting has been reviewed twice; *this*
  version of it has not been reviewed at all. Carried into Build as a known exposure, and it is the
  most likely source of a Prove finding.
- **Every review finding was adjudicated by the hand that wrote the plan.** Each was verified against
  live files first, but the judgement that all fifteen were correct is the author's.
- **`{gate:auto}` has never been exercised.** Its effects are reasoned from reading `session-start.md`,
  not from a run. Inserting an unconditional gate between Steps 2.5 and 3 of a 405-line command with
  six readers is the largest unproven assumption carried into Build.
- **Fourteen of nineteen per-step line budgets are apportioned from reading prose,** not measured.
  Slice 5 and its falsification exit exist because of that.
- **Not checked:** whether the two 33-line `prime` variants remain compatible with the leaned
  canonical dispatch contract. Plan-v3 does not depend on them, and they are inert until Slice 1
  lands, so this is acceptable to defer to Prove — but it is deferred, not cleared.

## CLOSE

**Outcome:** `close` — the unit's deliverable (the Shape plan, reviewed twice and adjudicated) landed.
No edit was made to the object under work, which is correct for Shape and not a partial result.

**Commits:** `aa0e266` · `9be8bb0` · `4c54344` · `aa7a56d` · `1dc38b3`, plus the commit carrying this
evidence file.

**What closed:** the Shape unit `2026-07-29-prime-minimum-responsibility-shape`.

**Stream:** **stays open.** Shape is not the stream's last unit — G1 approved the slice list, so Build
opens next, one unit per slice, beginning with Slice 1. `logs/loop/2026-07-29-prime-minimum-
responsibility-*` artifacts are retained until the stream closes, per § Artifacts' per-stream
retention rule.
