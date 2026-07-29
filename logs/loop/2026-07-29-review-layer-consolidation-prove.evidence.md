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

---

# ADDENDUM — adjudication of Codex Prove review-1

Review on disk: `logs/loop/2026-07-29-review-layer-consolidation-prove.review-1.md` (verdict
**REVISE** — 2 material, 2 minor). Adjudicated below; repairs applied in the same unit and reported
here, per this unit's brief ("only defects the verification itself surfaces may be repaired, and
every repair is reported").

## 9. M1 — incomplete consumer migration — **ACCEPTED IN PART**

The finding is right and it is the same defect class as § 6, one level deeper: the retired behaviour
survives in *operational instructions*, not just in pointers. Every cited site was re-read before
disposition; a reviewer's line reference is a claim, not a fact, and seven of them did not survive
checking.

**The test applied.** This stream removed the **automatic** firings; `/risk-check` and `/qc-pass`
survive as operator-invoked commands, and `audit-discipline.md` § Risk-check change classes is a
live heading. So a site is a defect when it makes a review **fire as a standing step** or names a
**field or verdict no producer emits**. A site that names the live change-class taxonomy, or
describes an operator choosing to run a surviving command, is **not** a defect. Codex did not draw
this line and over-called on it.

**Repaired — 19 sites, 12 files:**

| File | Sites | What was wrong |
|---|---|---|
| `friday-act.md` | 7, 175, 177, 320, 343, 470 | "the gate runs at execution time" (twice, one of them explicitly "do not prompt the operator"); the internal field `risk_check_required` diverging from the emitted `High-consequence:` label; three "own plan + `/risk-check`" mandates, one of them contradicting `:489` in the same file |
| `lean-repo.md` | 11, 92, 118 | "gated by `/risk-check`" ×2, and at `:118` the explicit **"each gated by `/risk-check` plan-time + end-time"** — the exact double gate this stream removed, prescribed as standing procedure |
| `incident-log-template.md` | 19 | Required a `/risk-check` verdict field (`GO \| PROCEED-WITH-CAUTION \| RECONSIDER`) that its only producer, `/resolve-incident`, **no longer emits** — that command now records `REVIEW_FINDINGS`. Same producer/consumer break as `friday-act.md:272` in § 6. |
| `resolve-incident.md` | 217, 243 | **Found by this adjudication, not by the review.** Two escalation triggers still keyed on "RECONSIDER verdict" — a verdict the command no longer produces. `:220` already said "unresolved material review finding", so the file contradicted itself. |
| `technical-solution-consultant/SKILL.md` | 120, 138 | Elevated-stakes memos routed through `/qc-pass` → `triage-reviewer` as standing procedure — the specialist-stacking S3 removed elsewhere |
| `fix-repo-issues.md` | 232 | Generated plan schema field "QC needed: run /qc-pass after applying" |
| `leverage-idea.md` | 138 | A standing three-gate stack (`/risk-check` + `/qc-pass` + `/blindspot-scan`) on every produced artifact |
| `pipeline-review-auditor.md` | 128 | "then `/qc-pass` to validate before commit" as a standing step |
| `resolve-repo-problem.md` | 147 | "run that gate before landing it" |
| `defect-to-fix-loop.md` | 20 | "is a `/risk-check` change class — gate it" |
| `parallel-sessions-playbook.md` | 94, 162, 227 | Initially declined as playbook prose, then **reversed**: the deterministic sweep flagged `:227`'s "`/risk-check`-gated" as the identical phrase repaired in `lean-repo.md:92`. Treating the same phrase differently by file type is not a defensible line. Repaired for consistency; the reversal is recorded rather than hidden. |

**Declined — 7 sites, 4 files, with reason:**

- `implementation-triage.md:63` — "The operator runs `/risk-check` for risk-class changes." This is
  **accurate after the change**, not before it. `/risk-check` survives operator-invoked.
- `lean-repo.md:77`, `lean-repo.md:117`, `lean-repo-auditor.md:77` — each names the item's
  "`/risk-check` change class". That is the live taxonomy heading in `audit-discipline.md`, used as a
  classification label, not a gate mandate. Renaming it would break a valid pointer to create the
  appearance of migration.

Declining these is not a residual defect. Rekeying them would make the docs *less* accurate.

## 10. M2 — omitted excluded caller — **ACCEPTED IN FULL**

Verified at `.claude/commands/work-loop.md:105`:

> "`/risk-check` fires at its own two gates on its own schedule … If the unit touches a structural
> class, the route escalates to challenged *and* `/risk-check` still runs at its own gates."

Codex is right that this is the most load-bearing omission in the package. The command that runs this
very stream still instructs Claude to stack two `/risk-check` gates on top of the challenged route's
single Codex review — the precise arrangement the stream exists to end. The file is correctly
excluded from this stream (a stream may not rewrite the contract it is being run under), but its
absence from the follow-up list understated what remains. **Not edited here. Recorded as follow-up
item 4** in § 12, and it is the highest-priority of the four.

## 11. m1 and m2 — **BOTH ACCEPTED**

**m1 — corrected nine-falsifier table.** Build-4 § 3 reported falsifiers 1 and 4 as bare "Clear"
while disclosing an exception in the same cell. The verdict token should carry the exception:

| # | Falsifier | Corrected verdict |
|---|---|---|
| 1 | Broken consumer | **Occurred — pre-existing, bounded exception.** 7 broken symlinks pre-date the stream. Re-keyed at Build-1 to *no new breakage vs BASE*; that predicate holds. |
| 2 | Count regression | **Did not occur.** Verified structurally rather than by re-counting: across `2cb245e..HEAD` plus the working tree there is **no added or deleted file under any `commands/` path and no symlink mode change** — so no consumer count can have moved. See § 12 LIMITATIONS on why this replaced a re-count. |
| 3 | Overclaim | **Did not occur.** |
| 4 | Replacement machinery | **Occurred — bounded exception, disclosed.** One risk-check report was added outside `logs/loop/`. It is evidence, not machinery, but the literal predicate fired. |
| 5 | Protected safeguard weakened | **Did not occur.** Re-verified after the M1 repairs: six hooks unchanged, permission-surface diff 0, `materiality-bar.md` unchanged. |
| 6 | Excluded file touched | **Did not occur.** `work-loop.md` was read but not edited (§ 10). |
| 7 | Deferred deletion | **Did not occur.** Only the two nudge hooks were deleted. |
| 8 | Dangling reference | **Occurred — repaired in two rounds.** Five sites in § 6, nineteen in § 9. The surviving hit is `prime.md:168`, an excluded file already on the follow-up list. |
| 9 | Transition gate skipped | **Did not occur.** Ran once, returned RECONSIDER, adjudicated by the operator (§ 0). |

**m2 — LIMITATIONS section.** Contract requires it (`docs/work-loop.md:183`). Added as § 12.

## 12. LIMITATIONS

1. **Two falsifiers fired literally and are carried as disclosed exceptions**, not as clean passes —
   falsifier 1 (pre-existing broken symlinks) and falsifier 4 (one evidence file outside
   `logs/loop/`). Neither was caused by this stream; both are stated rather than reported as clear.
2. **Falsifier 2 was not verified by re-deriving the twelve consumer counts.** plan-v3 § 8's counting
   scope could not be reproduced from the artifacts on disk — three attempts under different
   exclusion sets gave three different totals, none matching § 8. Rather than guess a scope until the
   numbers agreed, or assert the reviewer's figures as my own, the falsifier was closed on a stronger
   structural argument: content-only edits cannot change consumer counts, and the diff confirms no
   file was added or deleted under any `commands/` path and no symlink changed. **The original
   counting scope remains undocumented** — a real gap for any future unit that needs to re-derive it.
3. **This unit repaired what it reviewed.** Twenty-four sites were changed by the same session that
   judged them. The repairs are deterministic rekeyings verified by sweep, but no independent party
   has read them. G2 is adjudicating self-verified repair work.
4. **The brief is retrospective** (see the notice in `…-prove.brief.md`), so this unit was not bounded
   by a scope agreed before it started.
5. **The end state is not reached.** Four sequenced follow-ups remain (§ 13). Until items 1, 2 and 4
   land, the operating model this stream describes is not what a session actually runs.
6. **`/qc-pass` and `/risk-check` survive as operator-invoked commands.** Nothing here removes them,
   and any claim that the repo "no longer uses `/risk-check`" would be false.

## 13. Sequenced follow-ups — now four

| # | Owner | What |
|---|---|---|
| 1 | `prime.md` (`:816`, `:168–174`, `:322`), `session-plan.md` (`:157,159,211`) | Excluded prime-owned files: plan-time gate, two-gate pointer, and the one surviving invalid section pointer |
| 2 | Workspace-root `CLAUDE.md` (`:57, 61, 65, 69, 121, 129`) | The unconditional QC mandate. **Until this lands, workspace-rooted session behaviour is unchanged.** |
| 3 | `projects/positioning-research` | Live wiring of both deleted nudge hooks (§ 7) — operator decision, outside repo scope |
| 4 | `.claude/commands/work-loop.md:105` | **Highest priority.** The two stacked `/risk-check` gates on the challenged route. Must land *after* this self-referential stream closes. Make the single Codex review risk-aware; retain `/qc-pass` only as the existing Codex-unavailable fallback. |

## 14. Disposition

Codex's own closing condition: *"If M1 is repaired by bounded semantic rekeying and M2 is recorded as
the excluded follow-up — without architectural redesign — deterministic verification and G2 are
sufficient. Return to Codex only if adjudication changes the architecture."*

Both conditions are met. No architectural change was made: no command, agent, hook, gate or registry
was added, removed or rewired by this adjudication — only instruction text was rekeyed onto the
existing three-row rule, and one template field onto the value its producer already emits. **No
further Codex round. Ready for G2.**

## 15. Cross-session re-verification before G2 — appended by the session that took the stream over

§ 12 limitation 3 says this unit repaired what it reviewed and that no party outside the authoring
session had read the repairs. The operator transferred the stream to a second session, which
re-derived the load-bearing claims from the live files with no reliance on the text above. **This is
a second Claude session, not an independent model** — it does not discharge the Codex-independence
requirement and is not offered as doing so. It is a fresh-context re-derivation, and it is a weaker
check than the Codex review that already passed.

| Claim re-derived | Command run | Observed |
|---|---|---|
| The four **declined** M1 sites read as claimed | `sed -n` on each cited line | Confirmed. `implementation-triage.md:63` reads *"The operator runs `/risk-check` for risk-class changes"* — accurate after the change. `lean-repo.md:77,117` and `lean-repo-auditor.md:77` each use *"`/risk-check` change class"* as a classification label against a live `audit-discipline.md` heading. Declining all four is correct; rekeying them would break valid pointers. |
| No standing-step prescription survives | `grep -rnE '(gated by\|gate it\|then run\|must run\|gate before\|auto-run\|automatically (run\|fire\|invoke))[^.]{0,60}/(qc-pass\|risk-check\|contract-check\|blindspot-scan)'` over `.claude/ docs/ skills/ templates/`, excluding the three excluded files | **Zero hits.** |
| Templates carry no dead gate field | `grep -rnE '/(qc-pass\|risk-check)' templates/` | One hit, `mission-contract.md:31`, listing `/qc-pass` among optional fresh-context checks an operator *may* run. Descriptive, not a standing step — not a defect under § 9's test. |
| Excluded files untouched by the whole stream | `git diff --name-only 267c4c2..HEAD -- work-loop.md prime.md session-plan.md` | **Empty.** Falsifier 6 holds. `work-loop.md:105` still carries the two-gate text, exactly as follow-up 4 records. |
| Six protected hooks unchanged | per-path `git diff --name-only 0bf726d..HEAD` | All six **UNCHANGED**. |
| Permission surface unchanged | `git diff 0bf726d..HEAD -- .claude/settings.json` filtered for `allow\|ask\|deny\|Bash(\|Read(\|Write(\|Edit(` | **0 lines.** `settings.json` parses as valid JSON. |
| `materiality-bar.md` unchanged | `git diff --name-only 0bf726d..HEAD` | **Empty.** |
| The M1 repair commit touched no protected path | `git show --name-only e24ba61` filtered for `hooks/\|settings.json\|materiality-bar` | **Empty.** |
| `cleanup-worktree` hard gates survive | `grep -c` for gate/confirmation markers | **9** occurrences present. |

**Baseline note.** `0bf726d` is used above rather than the `2cb245e` recorded in this file's header: it
is the last commit before any object edit in this stream, so it is the correct pre-change baseline for
a protected-safeguard diff. `2cb245e` is a Shape plan-revision commit two commits earlier and includes
no object edits either, so the two give the same answer here; the tighter one is stated for precision.

**One addition to § 13 follow-up 4.** `work-loop.md:105` cites `docs/audit-discipline.md:73-81` for the
two-gate rule. S1 **deleted** § When to fire at those lines, so the citation is a dangling line-range
pointer as well as a stale mandate. Follow-up 4 must repair both, not just the mandate.

**Verdict of this re-verification: the adjudication holds.** Nothing was found that changes the G2
package. No repair was made by this session.
