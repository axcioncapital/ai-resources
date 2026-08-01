## Verdict

**Option 1 — correct finding C fully now.** The remaining restatement is executable policy inside
the two prompts that run the loop, not merely documentation debt; it has already produced one live
drift failure, and accepting it would leave the structural cause in place while overruling both the
binding writing standard and the independent review.

## Reasoning

The pilot-quality bar permits disclosed limitations, but this is the wrong kind of limitation to
carry into the pilot. A fixture gap or an unexercised folder-creation path is a bounded uncertainty.
Duplicated policy in the runtime instructions is a known ownership defect: the core says one thing,
the artifacts copy it, and the harness rewards the copies. Finding A demonstrated the consequence
already. Correcting A removed the observed contradiction; it did not remove the mechanism that
allowed the contradiction.

Full correction is also less operationally risky than its line count suggests. Both artifacts
already require the core to be read before work begins. The correction should therefore be mostly
subtraction and replacement with precise section links, while retaining surface-specific mechanics:
how Claude resolves a task id, which fields each actor writes, the exact turn routing, the
inspection/result shapes, and who commits. The harness already contains extensive history- and
outcome-based checks proving the behaviours. Those checks can remain the behavioural protection
after wording locks are removed.

Option 2 is worse because its reopening trigger waits for the known defect to harm a real pilot
unit before honoring a binding standard and a material independent finding. That makes the pilot
test whether a known source-of-truth violation finally breaks, rather than test whether the Work
Loop helps deliver useful work. Option 3 is worse still: it removes even that trigger and turns a
material finding into permanent, unowned debt.

## On the reviewer's bar

Overruling the reviewer's “must be corrected before acceptance” bar is not justified. The
post-correction menu permits accepting a limitation, but it does not make every material finding a
good candidate for that exit. There is no new evidence that C was misclassified; the evidence since
the review instead confirms that the harness and both prompts are coupled to the duplicated policy.

The freeze timing does create risk, but not more risk than leaving C open. The candidate has already
moved for A and B, and the protocol expressly provides a narrow closure check for the correction.
Option 1 should reduce prompt surface and authority ambiguity without changing the core's policy or
the accepted behaviours. If it expands into redesign, the correction has exceeded this verdict's
scope and must stop.

## On selective application (conflict 2)

The remaining state is **inconsistent application, not a justified trade-off**.

The Slice 3 decision correctly assigned actions asymmetrically by actor: Codex owns opening and
assessment; Claude owns repository-side execution, de-escalation discovered during work, and
mid-unit deferral. That is a sound ownership decision. It does not require each artifact to repeat
the universal rule it is applying. Yet the command repeats admission policy at lines 19–27, and the
skill repeats the same policy at lines 38–44. The command then repeats core rules for identity,
premise checking, false-premise refusal, scope, deferral, de-escalation, evidence and correction
through lines 29–110. The skill likewise repeats the seam, admission, state shape, evidence,
assessment, correction, closure and role limits through lines 14–114.

The build record shows the team understood the rule well enough to reject symmetric duplication,
but then treated actor-specific application as permission to restate the policy assigned to that
actor. The valid trade-off is to keep actor-specific **mechanics** near the actor while linking the
shared **rule** to the core. The current artifacts do not consistently make that distinction.

## On Claude's measurement

The ten-assertion count is correct only for the brief's narrow grep after removing its two negative
obsolete-disclaimer checks. It is an undercount of the actual correction surface.

- The supplied query returns 12 rows: ten positive wording checks and the two negative checks at
  lines 373 and 379.
- Line 213 is an eleventh positive wording check: it requires the command's Step 1 to contain
  `belongs to a different task`, but the supplied filter misses the `step1_of` helper.
- Lines 365, 375 and 457 add three positive artifact-form locks. They require policy-specific
  Admission and De-escalating sections to exist even though they do not match a particular policy
  sentence.

The practical count is therefore **11 positive policy-wording locks, or 14 positive artifact-text
and structure locks when the three section-presence checks are included**, plus two negative checks
that finding C need not disturb. This slightly increases the harness edit, but it strengthens C's
central point: the test instrument is coupled to duplicated policy instead of relying on the
behavioural evidence it already contains.

## Bounded scope for option 1

The correction is limited to finding C and preservation of the already-landed A and B corrections.
It must not introduce new behaviour, alter the core's settled policy, revisit the lane design, or
add another review mechanism.

1. **`.claude/commands/work-loop-v2.md`** — replace restated universal policy with links to the
   owning core sections in Admission, Step 1's policy explanation, premise checking, false-premise
   handling, scope/deferral, de-escalation, evidence and correction. Retain only Claude-specific
   execution mechanics, exact output/mutation shapes, stop-result mechanics required by the writing
   standard, state-file discovery, turn changes and commit steps.
2. **`.agents/skills/work-loop-v2/SKILL.md`** — replace restated policy in the seam, Admission,
   brief rules, assessment/correction, closing and role-limit sections with core links. Preserve the
   A correction: direct operator intake before a file exists, the three-case Next-routing table,
   the correct `logs/work-loop/` path, Codex's no-Git boundary, and the actor-specific mechanics for
   writing a brief or closing record.
3. **`logs/scripts/work-loop-v2-slice-1.test.sh`** — rewrite the positive artifact wording/form
   assertions currently at lines 213, 246, 248, 365, 367, 369, 371, 375, 377, 449, 457, 459, 461
   and 488. Test that both runtime artifacts load and defer policy to the core, then rely on the
   existing run-history and end-state assertions for admission, identity rejection, bounded
   correction, de-escalation and deferral. Do not make the harness green merely by deleting checks;
   replace any unique protection with a failing-capable link, interface or behaviour check. The
   negative obsolete-disclaimer checks at 373 and 379 may remain.
4. **`work-loop-v2-executable-core-v0.1.md`** — no policy redesign. Edit it only if one exact shared
   protocol token currently duplicated by producer and consumer must be named once to avoid an
   orphaned interface; otherwise leave it unchanged.

The one closure check after Claude's correction asks only: are A, B and C resolved, and did these
edits cause a blocking regression? For C, “resolved” means the artifacts link shared rules rather
than copy them, surface-specific mechanics remain usable, the harness no longer requires policy
duplication, and the behavioural regression set passes.

## Deferrals

- After the pilot, clarify the writing standard's relationship between “never restate the core”
  and its requirement that command stop conditions name their on-stop behaviour. For this
  correction, the practical boundary is sufficient: link the trigger/rule to the core and retain
  only the actor-specific on-stop mechanics. Do not edit the standard during Step 6.

## Confidence

**High.** I would change this verdict if a bounded link-only prototype showed that, despite the
mandatory core read, removing the policy copies makes either model miss an acceptance behaviour;
or if the operator explicitly amends the binding writing standard to permit actor-scoped policy
duplication. Neither evidence exists now. The current evidence is the opposite: behaviour is
already proven independently, while duplicated instructions have already drifted once.
