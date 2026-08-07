---
task: v1-capability-gap-analysis
turn: operator
---

## Outcome

The evidence package for the Work Loop v1 capability layer is complete. It establishes, by inspection
rather than resemblance, what the surviving layer still does that v2 does not — and hands the
keep/fold/retire choice to the operator without selecting one.

**Method coverage.** All seventeen method sections were compared by job, not vocabulary. **Zero of the
seven load-bearing sections are fully covered.** Not covered at all: ownership and seams, trial design
with its build-stopping condition, slice standards, data handling. Partly covered: the intervention
ladder for non-artifact capabilities, the five-phase arc, evidence-to-claim, lifecycle decisions, and
the capability route triggers with their escalation/de-escalation protocol — nine gaps in total. The
vocabulary trap was real: v2's "seam" is the transport seam between models and v2's "slices" are its
own build slices.

**Durable state.** Three of five long-lived fields have no v2 home after a task closes — retirement
condition, lifecycle status, and the operating owner/seam. Real-use result and cross-task decisions
are partly represented. The plan's reopening test for creating a new v2 durable address is **not
met**: it requires loss at closure *and* a second live capability record, and exactly one exists.

**Blast radius.** One live executable dependency: `develop-ai-resource.md:57` matches on the status
vocabulary defined in `templates/capability-record.md`. Three of the five files are blocked by live
references; `docs/work-loop-spec.md` and `.agents/skills/work-loop/SKILL.md` are not. Two unmerged
branches — 62 commits — still carry the deleted `/work-loop` command.

The unit changed nothing outside this state file. No disposition was selected, no recommendation made.

## Decisions that matter

- **Closure was operator-directed, not a Codex close verdict.** The operator instructed the closing
  record be written during the final tightly-bounded fix, before Codex's closure check on that fix had
  run. The evidence package itself was assessed across one full correction round; only the final fix
  is unassessed. See Accepted limitations.
- **Two exclusions in the first pass were wrong, and both were corrected rather than defended.** The
  sibling worktrees were excluded by assertion and turned out to hold the most consequential finding;
  route triggers were called "covered" on a clause that picks owners rather than depth.
- **A broken search nearly became a fabricated finding.** The first v2 comparator pass returned zero
  for every term because zsh does not word-split a plain variable, so `grep` received one non-existent
  path. Caught by the `No such file or directory` warning beside a too-perfect zero, and re-run with an
  array plus a v1 positive control for every pattern.
- **The August 1 "archive v1 immediately" decision is carried as history, not reconciled.** Units 1–3
  materially changed some of its premises; other premises are unchanged; and the two unmerged branches
  are new evidence that was not weighed then. Reconciling it is the operator's move.
- **Six operator choices are recorded**, the fifth being what happens to the 62 unmerged commits — a
  choice independent of the other five and not resolved by any of them.

## Evidence

Discovery commit `3d88f83` — the five-part package. Correction commit `4eb7b78` — three frozen
findings. Final fix commit `8071b68` — two residual count and classification inconsistencies.

Every claim rests on a bounded search with a stated positive control. Verifiable spot-checks: the
five-file inventory returns 40 / 27 / 13 / 65 / 31 files by pattern, each classified into four
classes; `git branch --merged main` returns neither branch and `git rev-list --count` gives 37 and 25;
`find -type l` finds no symlink pointing at any of the five files; and the live record's sixteen
headings match the template's, in order.

Read-only was verified at each hand-back: `git diff --stat` over the five v1 files and the capability
record returns zero lines, and both worktrees show zero dirty files.

## Accepted limitations

- **The final fix (`8071b68`) is `unassessed`.** Its closure check did not run because closure was
  directed before Codex assessed it. The fix is two count corrections and one heading split, and no
  evidence, option or disposition was touched — but it has had no independent review, and the
  workspace rule is that a change whose review could not run is recorded `unassessed` for the operator
  to decide on.
- **Three dangling `/work-loop` references remain live**, unfixed by design: `docs/qc-independence.md:25/:27`
  (a canonical review-policy doc cited from workspace `CLAUDE.md`), `docs/ai-resource-creation.md:17`,
  and `docs/ai-resource-development-playbook/RESOURCES.md:13` (a broken file link). The last two were
  already deferred at Unit 3; the first was found here.
- **The live capability record contradicts itself in four places** and is unresumable, its stated
  resume mechanism being the deleted command. Left exactly as found.
