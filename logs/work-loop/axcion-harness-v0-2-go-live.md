---
task: axcion-harness-v0-2-go-live
turn: codex
---

## Objective and scope

Make Axcíon Harness v0.2 the normal, usable attended Work Loop courier as quickly as safely possible,
then collect only the real-use evidence needed for an explicit adopt, revise, continue-trial or stop
decision. Scope is the canonical `ai-resources` operating surface and the minimum attended adoption
trial. Unattended execution, automatic multi-hop operation, worktree automation, May-harness archival
cleanup, unrelated Phase 0 cleanup, remote publication, and new orchestration machinery are excluded.

## Lane and unit

Named reason for the loop: changing the live cross-actor routing instructions is a semantic operating
change that must be verified by someone other than its implementer before it becomes normal practice,
and the subsequent adoption decision requires evidence from more than one real use.

Standard. Implementation mode. Unit 1 — make the proven canonical attended carrier the live attended
courier route without changing or promoting the separate unattended path.

## Latest result

Inspected (2026-08-13):
- Claim (1): HOLDS — read `.agents/skills/work-loop-v2/SKILL.md` § *Courier mode* at HEAD `e0e1416`;
  the attended command block invoked `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
  with `--carry-one`, and a grep of the whole file for `carry-turn\.sh` returned no match, so no live
  instruction named the canonical carrier.
- Claim (2): HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.sh` and exercised it. Its header
  states one hop per invocation and no unattended mode; `--checkout` and `--task` are required
  (usage_die at lines 193–194); `--allow-path` is repeatable and replaces both built-in defaults when
  supplied (lines 198–200). Live probes against this checkout: `--carry-one` → `STOP [10] unknown
  argument`, `--unattended` → `STOP [10] '--unattended' is refused: this is the attended surface`,
  `--max-hops 4` → `STOP [10] ... carries exactly ONE hop per invocation`. A `--dry-run` with only
  `^logs/work-loop/` reported `logs/friction-log.md` and `logs/harness-runs/` as out-of-allowlist
  changes that a live carry would stop on; the same dry-run with the four-line allow-path set reported
  none.
- Claim (3): HOLDS — the skill's *Unattended runs* subsection depends on `--deadline`, `--max-hops`,
  `--unattended` and `--status`. Searched `scripts/axcion-harness-v0.2/carry-turn.sh` for `deadline`
  and for exit codes `23|29|31|33|34|35|36|37`: no match for any. All four flags are present in
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (arg parser lines 413–425). So
  replacing the unattended route wholesale would have been false.

Result: `.agents/skills/work-loop-v2/SKILL.md` § *Courier mode* now routes the attended carry through
`scripts/axcion-harness-v0.2/carry-turn.sh` with exact `--checkout`/`--task` inputs and a four-line
allow-path policy whose fourth line is derived per task; the shapes table names one program per shape;
a new paragraph states that the two are different programs and lists the flags the carrier refuses;
the *Unattended runs* subsection is unchanged in destination and now opens by naming the spike
dispatcher explicitly. The carrier is nowhere presented as unattended or multi-hop. Net +2 lines.

Evidence: a route check over the file's courier section (9 assertions: which program the attended
fenced command invokes, that it invokes no refused flag, that it passes exact checkout/task inputs and
a per-task allow-path beyond the three fixed ones, and that unattended running still names the spike
in a separate subsection). Against `git show HEAD:.agents/skills/work-loop-v2/SKILL.md` it reports
**3 passed, 6 failed**; against the working tree **9 passed, 0 failed**. The two preservation
assertions pass in both directions, so the unattended route was not collateral damage. Existing
regression checks that bind to this file: `logs/scripts/work-loop-v2-core-resolver.test.sh` 4/0 before
and after; `logs/scripts/work-loop-v2-slice-1.test.sh` **292 passed / 3 failed before and after — the
same three failures**, all pre-existing and none touched by this change (two are fixture-inventory
drift from live task files, one is the skill's 340-line ceiling, already breached at 608 lines before
this unit). `git diff --stat HEAD` over the executable core, the carrier, the carrier suite, the spike
directory, `logs/scripts/` and `.claude/commands/work-loop-v2.md` is empty — all byte-unchanged.
Committed paths: `.agents/skills/work-loop-v2/SKILL.md` and this state file, and nothing else.
`logs/friction-log.md` was already modified by the `PostToolUse` hook at session start and is left
uncommitted; `logs/harness-runs/` holds the two dry-run logs and is untracked.

Deferrals — recorded, not done:
1. `logs/harness-runs/` is not gitignored, so the attended carrier's own run evidence accumulates as
   untracked repository noise and must be named in every allow-path set. Not done: it changes a
   tracked ignore file outside this unit's route-selection outcome.
2. The carrier runs no ownership check — `logs/scripts/work-loop-owner.sh` appears 5 times in the
   spike dispatcher and 0 times in `carry-turn.sh`. The skill's ownership passage still attributes
   exit-code-borne enforcement to "the dispatcher at admission", which stays literally true but now
   covers only the unattended shape. Not done: narrowing that contract is a bigger question than
   route selection.
3. No permanent regression check protects the attended route. The one suite that binds to this file,
   `work-loop-v2-slice-1.test.sh`, declares its subject as Slice 1–3 MVP behaviours, so adding harness
   routing assertions there would stretch its stated scope. The route check used here was a one-off.

## Blocker

None.

## Next action

Codex: assess Unit 1 against its completion condition — does the live Work Loop skill now give one
correct, copyable attended invocation of the canonical carrier, clearly distinguished from unattended
operation, with all Work Loop role and state-file rules preserved? Then decide close, continue,
correct once, or stop, and rule on the three recorded deferrals.

---

Brief for Unit 1 (superseded by the result above; kept for the assessment):

Why this unit, why now: the carrier itself is already built and proven, but normal Work Loop operation
still routes attended use to the spike, so further architecture or cleanup would not make v0.2 more
live. This unit changes only that operating seam and preserves the plan's attended-only MVP boundary.

**Required outcome.** Make the live Work Loop v2 Codex instruction route an operator-approved attended
one-hop carry through `scripts/axcion-harness-v0.2/carry-turn.sh`, with exact task and checkout inputs
and a task-derived allow-path policy. Preserve a separately and unmistakably labelled route to the
spike dispatcher only where the current instructions genuinely support post-MVP unattended running;
do not imply that the canonical attended carrier supports unattended or multi-hop operation.

**Authority and source dispositions.** The operator's current request to get Harness v0.2 live ASAP
authorizes this minimum attended release wiring. The accepted live-trial closing record at
`logs/work-loop/axcion-harness-v0-2-live-trial.md` is authoritative current-state evidence for the
carrier and Phase 2 exit. `plans/axcion-harness-v0.2/mvp-plan.md` governs the product boundary and
keeps unattended work after the attended cut line, but its old no-implementation header is superseded
for this attended release by the operator decisions recorded in the live-trial and attended-release
task records. The Work Loop executable core continues to govern semantics and must not be edited.

**Claims to verify before acting.** Check `.agents/skills/work-loop-v2/SKILL.md` and its directly owned
test surface for: (1) the attended courier command currently names the spike dispatcher rather than
the canonical carrier; (2) the canonical carrier's own usage and refusal behavior require one hop,
explicit checkout/task inputs, repeatable task-derived allow paths, and no unattended flag; (3) the
skill's unattended section depends on capabilities present only in the spike dispatcher, so replacing
that route wholesale would be false. A false claim is a valid handback: report it rather than silently
changing the boundary.

**Scope and Codex framing.** Edit the live Codex Work Loop skill and only an existing directly owned
regression check if one is needed to protect the route. This narrow boundary is Codex's framing choice
because making the carrier discoverable in normal operation is the release blocker; plan-status prose,
the root P0-D record, the parallel-sessions playbook, the old spike implementation, the carrier itself,
Claude's Work Loop command, and remote push are held outside this unit because none is required to
select the attended courier correctly.

**Evidence required.** Produce a fail-capable before/after check showing that attended instructions
select `scripts/axcion-harness-v0.2/carry-turn.sh` and do not supply any refused unattended or multi-hop
flag; show that the unattended instructions still name the spike and are visibly separate; run the
smallest relevant existing regression checks for any edited instruction/test surface; confirm the
executable core, canonical carrier, carrier suite, spike, and unrelated paths are byte-unchanged; and
show the exact committed path list. Do not rerun the carrier's 98-case suite merely to prove an
instruction-string edit unless the implementation actually changes a carrier-owned surface.

**Completion condition.** The live Work Loop skill gives one correct, copyable attended invocation of
the canonical carrier, distinguishes it from unattended operation, preserves all Work Loop role and
state-file rules, and the change is committed with fail-capable evidence in this state file at
`turn: codex`.

**Stop conditions.** Stop and hand back if the claimed route is already canonical, the smallest
correct change requires editing Work Loop semantics or the carrier implementation, the attended and
unattended routes cannot be separated without redesign, or any required evidence cannot be made
fail-capable. Do not expand into status-document reconciliation, adoption trials, archival cleanup,
publishing, or unattended promotion.
