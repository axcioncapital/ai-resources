UNIT: 2026-07-29-review-layer-consolidation-build-2
STREAM: 2026-07-29-review-layer-consolidation
PHASE: build
SLICE: S2 — Automatic hooks and embedded general-review removals
REPO: ai-resources
BASE: ff000a4
NEXT: Claude

BRIEF
Implement slice S2 of the G1-approved package (`…-shape.plan-v3.md` § 3 S2).
Plan-v3 is immutable and is not edited by this unit.

CARRIED FROM BUILD-1 (evidence § 6) — one addition to S2's file set:
`.claude/commands/improve-skill.md:108, 120` runs an automatic independent
post-edit QC pass with a loop-back to Step 5b. Plan-v3's inventory missed it.
Added to S2 as an inventory correction, not a scope change: plan-v3 § 4's
approved claim is that no general Claude QC fires automatically from any
reachable file. `create-skill.md` and `migrate-skill.md` were checked in the
same pass and carry no independent review pass — no S2 edit needed there.

CARRIED FROM BUILD-1 (evidence § 3) — one site left to this unit by design:
`.claude/commands/resolve-incident.md:83` references `audit-discipline.md
§ Verdict semantics`, which S1 deleted. S2 owns the file; removing the `:78`
invocation removes the verdict capture that `:83` documents. Close both together.

SCOPE — no policy doc is edited in this unit; S1 owns those.
Delete: `.claude/hooks/auto-qc-nudge.sh`, `.claude/hooks/auto-resolve-nudge.sh`.
Edit `.claude/settings.json`: the two hook entries at :73 and :122 ONLY.
Edit: `wrap-session.md` (:225 12b, :227 12c) · `qc-pass.md` (:26) ·
`promote-workflow.md` (P1 :181-194, P5.1, P5.2 :248, :282-283) ·
`skills/handoff/SKILL.md` (:75, :78, :177-194) · `pm.md` (:88, :94, :130-150,
:162, :167) · `cleanup-worktree.md` + `skills/worktree-cleanup-investigator/
references/execution-protocol.md` §§ 3,4,6 · `resolve-incident.md` (:78, :83,
:114-119) · `friday-journal.md` (Step 5.5 :155-176, :323; risk-class flagging
:167, :184, :248) · `friday-act.md` (:279, 16k :284-290, :488) ·
`fix-project-issues.md` (:141) · `reconcile.md` (Step 3 :56-61) ·
`improve-skill.md` (:108, :120).

PROTECTED — must be byte-identical after this unit:
Six protected hooks incl. `check-destructive-liveness.sh` · `cleanup-worktree.md`
Section 4 hard gates + named confirmation phrases, Section 7 bias counters 1/2/4,
Steps 13 and 13b · `execution-protocol.md` §§ 7-10 · `friday-journal.md` Steps
5.4, 5.6, 5.7 · `promote-workflow.md` P4 anti-clobber, P6, P5.4 push gate ·
`fix-project-issues.md` Step 1, Step 2, :93-115 · `reconcile.md` :65
reconcile-reviewer · every `allow`/`ask`/`deny` entry in settings.json.

EVIDENCE REQUIRED
- Both hooks gone; the two settings.json hook entries gone; settings.json still
  valid JSON; zero `allow`/`ask`/`deny` diff.
- Per-file before/after for each edited command.
- Protected-set proof: `git diff` over each protected path is empty.
- Falsifier 8 at full scope (`docs/ skills/ .claude/`), dispositioning every hit.
- Consumer counts unchanged (12 commands, `find -L`).
- No new file outside `logs/loop/…`.

FALSIFIED IF
Any plan-v3 § 9 falsifier fires; or a protected item above differs; or a policy
doc S1 owns is edited here; or a canonical command/agent is deleted (only the two
hook scripts may be deleted); or an excluded file is touched.
