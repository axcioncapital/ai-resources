UNIT: 2026-07-29-review-layer-consolidation-prove
STREAM: 2026-07-29-review-layer-consolidation
PHASE: prove
REPO: ai-resources
BASE: 2cb245e
HEAD-AT-START: 8840672
NEXT: Codex Prove review → G2

EVIDENCE

## 0. Standing on the transition gate — operator adjudication, not a Claude self-waiver

The legacy end-time `/risk-check` ran once in Build-1 under the G1 ordering condition and returned
**RECONSIDER**. It was **not** re-run after the repairs.

**This is recorded as an explicit operator adjudication.** The operator directed, at the opening of
this Prove phase: proceed to Prove without rerunning `/risk-check`; the gate was not waived — it ran,
returned RECONSIDER, and its findings were narrow pointer repairs, not a design rejection or a
weakened safeguard. Build-1 § 3 had recorded the same disposition as *Claude's own stated
non-waiver*; that self-assessment is now superseded by an operator decision. The distinction matters
for the audit trail: an agent declining to re-run its own gate and an operator adjudicating that the
gate is discharged are different acts, and only the second is what happened here.

The operator additionally directed that no further general `/risk-check` round run in this stream.

## 1. What Prove was told to verify

Four checks, specified by the operator:

| Check | Result |
|---|---|
| **P1** — the six repaired references | **VERIFIED** |
| **P2** — no live refs to deleted policy sections across `docs/ skills/ .claude/` | **VERIFIED** |
| **P3** — the `improve-skill` automatic-QC removal | **VERIFIED** |
| **P4** — all protected safeguards unchanged | **VERIFIED — and it found five surviving defects** |

## 2. P1 — six repaired references

Every target anchor exists and every citing site resolves: `qc-independence.md` § The rule (:9) and
§ Findings (:57); `audit-discipline.md` § Risk-check change classes (:56); `ai-resource-creation.md`
rule 6 (:25). Sites confirmed at `placement.md:79`, `risk-check.md:14`, `create-skill.md:58`,
`contract-check.md:11,206`, `graduate-resource.md:99,126`.

## 3. P2 — dangling section pointers, re-derived independently

Not re-run as a string search this time. Every `§` pointer into the two rewritten policy docs was
extracted repo-wide and validated against the actual heading list:

- `qc-independence.md` headings: The rule · Codex is the reviewer · Risk-aware review · Context
  isolation · When the reviewer cannot be reached · Findings.
- Pointers found: **The rule ×30, Findings ×7, When the reviewer cannot be reached ×3, Risk-aware
  review ×2** — all valid — plus **one invalid: `§ Subagent-unavailable fallback`**.
- The single invalid pointer is `prime.md:168` — the excluded prime-owned file, already named as
  sequenced follow-up item 1. **No new hit.**
- `audit-discipline.md`: Risk-check change classes ×12, Absence-claims ×3 — both valid headings.

This reproduces P2's earlier result by a different method, which is why it is reported as
independent confirmation rather than a re-run.

## 4. P3 — `improve-skill` automatic QC

| Sub-check | Expected | Actual |
|---|---|---|
| `spawn` inside Step 5e | 0 | **0** |
| Step 5e heading survives, re-scoped | present | **`### 5e: Deterministic fix verification` (:106)** |
| `loop back into Step 5b` | 0 | **0** |
| `re-run 5e once` | 0 | **0** |
| Step 4 `evaluation-framework` engine intact | 1 | **1** |

The removal is the right shape: 5e was not deleted, it was demoted from an independent post-edit QC
subagent with a loop-back to a deterministic ledger check, and the retirement is narrated in place
(`improve-skill.md:112`). Step 4's evaluation pass — the pipeline's own engine — is untouched.

## 5. P4 — protected safeguards

**All protected safeguards are unchanged.** Verified against `2cb245e..HEAD`:

| Safeguard | Result |
|---|---|
| Six protected hooks | `check-destructive-liveness.sh`, `log-write-activity.sh`, `friction-log-auto.sh`, `check-stop-reminders.sh`, `coach-reminder.sh`, `improve-reminder.sh` — **all six UNCHANGED** (per-path `git diff --name-only` empty) |
| Permission surface | `settings.json` diff filtered for `allow|ask|deny|Bash(|Read(|Write(|Edit(` → **0 lines**. The only changed lines are the two deleted hook entries. |
| `cleanup-worktree` Section 4 hard gates, Section 7 counters 1/2/4, Steps 13/13b | **Mechanics intact.** Counter 3 rekeyed onto the surviving single review, as the brief required. |
| `execution-protocol.md` §§ 7–13 | **Byte-identical** — 140 lines, `diff` clean, and still deliberately un-renumbered after §§ 5–6 were removed. |
| `friday-journal` Steps 5.4 / 5.6 / 5.7 | **Mechanics unchanged.** Only the flag wording changed. |
| `promote-workflow` P4 / P6 | **Unchanged.** P5 restructured as designed (three gates → one review). |
| `docs/materiality-bar.md` | **UNCHANGED** — the finding floor survives intact. |

## 6. What P4 found — five defects the Build sweeps missed

Build-4 § 3 falsifier 8 claimed *"no live reference to removed machinery survives in any file this
stream may edit."* **That claim was wrong.** Five sites survived. Prove is what caught them.

| # | Site | Defect | Severity | Disposition |
|---|---|---|---|---|
| 1 | `friday-act.md:272` | Plan-file schema still **emitted** `- **Risk-check required:**` while three downstream sites (`:279` execution note, `:284` review instruction, `:488` note) had been renamed to key on `High-consequence:`. A generated plan file carried a field name no consumer reads. | **Material** — a high-consequence item would be written to the plan and then silently skip its risk-aware review at execution time, because the note that routes it never matches. | **Repaired** → `- **High-consequence:** {yes — change class: {class} | no}` |
| 2 | `cleanup-worktree.md:61` | *"fix before the first QC pass, not after"* — pointed at a step deleted in S2. | Minor, but in a destructive-operation command: the deadline for fixing an ungated irreversible operation became undefined. | **Repaired** → "fix before the Step 6 review" |
| 3 | `cleanup-worktree.md:62` | *"Section 7 is the audit artifact the QC subagents verify against"* — plural, referring to the removed two-pass structure. | Minor | **Repaired** → "the Step 6 review verifies against" |
| 4 | `promote-workflow.md:179` | *"Re-surface only on … a P5 risk-check non-GO"* — P5 no longer runs `/risk-check` and no longer produces a GO verdict, so the re-surface condition was unsatisfiable. | Minor-material: the phase's only escalation trigger keyed on a verdict token that can no longer be produced. | **Repaired** → "a material finding from the P5 review that cannot be resolved" |
| 5 | `permission-template.md:318,327` | The canonical `PostToolUse[Write]` wiring taxonomy still installed `auto-qc-nudge.sh` — a hook **this stream deleted** — into every project scaffolded from it, with a role bullet describing it as nudging toward `/qc-pass`. | **Material** — the canonical template would have re-propagated the exact automatic review layer this stream removed, into each new project, indefinitely. | **Repaired** — hook line and role bullet removed; a dated retirement note added in their place saying not to re-add it or wire a replacement nudge. |

**Why the Build sweeps missed all five.** Build-1's miss was *directory scope* (`docs/ skills/` with
no `.claude/`), and that was fixed. These five are a different axis: **pattern scope**. The sweeps
searched for command-shaped references (`/qc-pass`, `/risk-check`). None of these five is command-
shaped — they are a **field name** in a schema template (1), **step names** in prose (2, 3), a
**verdict token** (4), and a **hook filename** inside a JSON example (5). A grep tuned to one shape
of reference is blind to every other shape the same concept takes. The deterministic check that
caught them was structural, not lexical: enumerate every pointer into the changed docs and validate
each against the real heading list, and diff each protected file rather than searching it.

**None of the five weakened a protected safeguard.** All five were pointer/label residue. The
protected set in § 5 is independently verified clean, and the four repairs touched no hook, no
permission entry, and no gate mechanic (`allow|ask|deny` diff on the repairs → 0 lines).

## 7. Out-of-scope residue found, recorded not fixed

`projects/positioning-research/.claude/settings.json` **actively wires** `auto-qc-nudge.sh` and
`auto-resolve-nudge.sh`, and carries its own local copies of both scripts — so the hooks still fire
there and will keep firing. It is not broken; it is the retired review layer, still live, in one
project.

Two other projects (`axcion-sector-intelligence`, `research-pe-regime-shift-advisory-gap`) hold
orphan copies of both scripts that **no settings file wires** — harmless.

`projects/` is outside this stream's declared scope, and a live project's hook wiring is an operator
decision, not a Prove repair. **Recorded as sequenced follow-up item 3**, joining the two already
named. Not fixed here, and no artifact claims otherwise.

## 8. State at end of Prove

**Verified delivered:** no general Claude review and no risk-reviewer subagent fires automatically
from any file this stream may edit — now true at pointer level as well as at command level, which
was not the case when Build closed. Protected safeguards independently confirmed unchanged.

**Not delivered, named, unchanged from Build-4:**

1. `prime.md:816`, `:168–174`, `:322` and `session-plan.md:157,159,211` — excluded prime-owned files.
   Still hold the plan-time gate, the two-gate pointer, and the one invalid section pointer.
2. Workspace-root `CLAUDE.md` (`:57, 61, 65, 69, 121, 129`) — still carries the unconditional QC
   mandate. **Until this lands, behavior in workspace-rooted sessions is unchanged.**
3. **New:** `projects/positioning-research` — live wiring of both deleted nudge hooks (§ 7).

**The end state is not reached, and this file does not claim it is.**
