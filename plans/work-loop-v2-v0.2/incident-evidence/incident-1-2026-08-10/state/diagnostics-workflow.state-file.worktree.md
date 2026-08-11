---
task: diagnostics-workflow
turn: claude
---

## Objective and scope
Develop and verify the smallest coherent, standardized repository Diagnose & Fix capability reached as a specialist through Work Loop v2's router. The operator-approved seam is specialist-owned method outside the Work Loop core; the unresolved mechanism question is whether the existing two-command path should be improved, consolidated, or otherwise simplified.

Scope: the canonical fault-handling resources in this checkout, their Work Loop v2 routing entries, directly coupled tests, templates, logs, documentation, and canonical consumer definitions. Project symlinks that resolve to the canonical main checkout are downstream deployment surfaces to account for, not separate repositories to edit. Excluded by Codex framing: the Work Loop executable core; `/fix-repo-issues` and `/fix-project-issues` beyond confirming their boundary; unrelated cleanup; edits inside project repositories; push, merge, or adoption.

## Lane and unit
Standard. Implementation mode. Unit 4 — final tightly-bounded fix after the correction round.

Named reason for the loop: the work spans several coupled command and consumer surfaces, its scope must stay bounded, and the result needs assessment by Codex before it counts as complete.

## Brief
Correction round, scope frozen to the three findings Codex named in the previous `## Next action`: remove the local Direct Work taxonomy, make Defer queueing unambiguous, and stop naming an inapplicable transfer owner. Preserve all accepted Unit 4 behavior and the `b2950d6` files. The Unit 4 brief's boundary is otherwise unchanged: only `.claude/commands/resolve-incident.md` and `.claude/commands/resolve-repo-problem.md` may change, with `templates/incident-log-template.md`, `logs/incident-log.md` and `docs/repo-architecture.md` as read-only verification inputs.

## Latest result

**Findings 1 and 3 are resolved. Finding 2 is partly resolved and I cannot finish it: `.claude/commands/` is not writable in this run.** This hop is a headless `claude -p` launched by the handoff-automation spike with `--permission-mode default`, so it did not inherit the checkout's `bypassPermissions`. The first `Edit` against `.claude/commands/resolve-repo-problem.md` was refused. This is Unit 3's environment blocker returning under the spike harness, not a new fault in the commands.

**The corrections were already applied in the working tree when this hop started; I did not author them.** The spike run log records `head=ea77d66` with the state file uncommitted at `turn: claude`, and `git status` at hop start already showed both command files modified. An earlier correction attempt applied the edits and was cut off before writing a result or committing. I verified every applied edit against the frozen findings by inspection rather than assuming it, and this commit is what makes that work durable — it was one interruption away from being lost twice.

### Reproducing the frozen findings (2026-08-10)

Each was reproduced at `HEAD` (`ea77d66`) before its correction was accepted, per the correction round's first rule.

- **Finding 1 — REPRODUCES at HEAD.** `git grep -c 'more than a couple of lines' HEAD` returned `1` in **both** command files: `resolve-incident.md` Step 2a and `resolve-repo-problem.md` Step 0b each carried "anything touching behavior, a protected zone, shared state, or more than a couple of lines is not" — a local taxonomy defined one sentence after the text promised not to define one. **Now RESOLVED:** the same grep over the working tree returns no match in either file. Both now state that the named instances illustrate the core § 2 test and "do not define it, bound it, or exclude anything", and both keep the protected-zone rule as an explicitly *external* constraint rather than a Direct Work criterion. The manifestly-small/genuinely-unclear branch is retained, so the negative control still holds.
- **Finding 2 — REPRODUCES at HEAD.** MANUAL Step 4 item 11 read "Queue only an actionable, confirmed repository fix … (Quick patch or Structural fix)" while the table directly beneath it queued Defer **Yes**, and AUTO step D separately called a defer-shaped recommendation actionable. **PARTLY RESOLVED — see the blocker.**
- **Finding 3 — REPRODUCES at HEAD.** `/fix-symlinks` was named as a transfer owner at `resolve-incident.md:168` and `resolve-repo-problem.md:86`. **Now RESOLVED:** `grep -n 'fix-symlinks'` over both working-tree files returns no match. The example is gone from both, and both now carry applicability validation as a stated precondition — open the candidate's body, read its scope and entry conditions, confirm it neither excludes this repository shape nor exits before reaching the fault, and (in `/resolve-repo-problem`) quote the line checked. Both add the no-candidate-survives branch: do not transfer, take the applicable ladder rung or terminate `no action justified` with the ownership gap stated.

### Finding 2 — what is resolved and what is not

**Resolved.** One contract is now chosen and stated: a queue entry is written when the failure is confirmed **and** triage ended in one of the three ranked options — Quick patch, Structural fix, **or Defer**. The three no-fix outcomes queue nothing. This is the reading the Unit 4 brief's required behaviour 7 supports: its exclusion list names exactly `not confirmed`, `no action justified` and `transferred`, and Defer is not among them. MANUAL Step 4 item 11 and its table now agree, AUTO step D applies the same test in the same words, and a new note separates the **queue test** ("does this confirmed fault still need a decision from the Friday cadence?" — Defer passes) from the narrower **bridge test** ("is there a fix to hand to `/resolve-incident` right now?" — Defer fails). A Defer therefore queues but does not bridge, identically in both modes.

**Not resolved — two sites still carry the old narrow wording**, and finding 2 requires that no contradictory condition survive anywhere in the command:

1. `.claude/commands/resolve-repo-problem.md:13` (header summary) — "when the failure was confirmed and triage produced **an actionable repository fix**".
2. `.claude/commands/resolve-repo-problem.md:206` (§ Triage only — no fix, no commit) — "written by either mode when the failure is confirmed and **an actionable repository fix is recommended**".

A Defer is not "a fix", so a reader applying either line literally would suppress the queue entry MANUAL Step 4 requires. Line 13 is partly self-correcting (its next sentence names only the three no-fix outcomes as queueing nothing); line 206 is not, and it is the closing statement of the file. The edit I attempted on line 13 was refused for permissions, so I stopped rather than routing around the denial with a shell write. The intended replacement text, for whoever can write it:

- Line 13: "… — **when the failure was confirmed and triage ended in one of the three ranked options: Quick patch, Structural fix or Defer.**"
- Line 206: "The `logged (pending)` entry — written by either mode when the failure is confirmed and triage ended in one of the three ranked options, Defer included — is resolved through …"

### Closure checks — did the corrections break the verified contracts?

All deterministic; each was run against the working tree and compared to `HEAD`.

- **`b2950d6` schema files preserved: PASSES.** `git diff --stat HEAD` over `templates/incident-log-template.md`, `logs/incident-log.md` and `docs/repo-architecture.md` is empty.
- **Preservation: PASSES.** Frontmatter of both command files (`description`, `model: opus`) is byte-identical to `HEAD`, compared programmatically with `diff`, not by eye. `git diff --stat HEAD` over `logs/scripts/work-loop-v2-slice-1.test.sh` and `.agents/skills/work-loop-v2/SKILL.md` is empty; `AX_PRIMARY` at `work-loop-v2-slice-1.test.sh:982` is untouched.
- **Status lockstep: PASSES.** All five enumerating sites carry all three new statuses — `resolve-incident.md` 9/10/9, `resolve-repo-problem.md` 14/14/12, template 5/4/4, `incident-log.md` 3/3/3, `repo-architecture.md` 1/1/1. Every surviving `{resolved | escalated | deferred | …}` enumeration is the **wide** six-status form; no narrow three-status enumeration remains outside archives.
- **Same-search residue: PASSES.** 21 files across `.claude/`, `.agents/`, `docs/`, `templates/`, `logs/scripts/` reference either command name — identical to the Unit 4 baseline of 21.
- **Scope: PASSES.** The working tree carries only the two command files and this state file. `logs/friction-log.md` and `logs/session-notes.md` are dirty from the write-activity and session-notes hooks, not from this correction, and are excluded from the commit.

**No behavioural re-run was performed, and I am not claiming one.** Unit 4's six-case matrix was run as real headless invocations; this correction round re-ran none of them. Two reasons, both environmental: `.claude/commands/` is unwritable in this hop, so the corrected bodies cannot be finished before being exercised; and the hop runs under a 600-second timeout that a fixture matrix would not fit. Under the Unit 4 brief's required behaviour 8 the corrections are logic-bearing, so inspection alone is below the verification floor that unit set for itself. I am reporting that gap rather than substituting the grep evidence above for it — the greps prove the text changed, not that the behaviour did.

Result: findings 1 and 3 are fully corrected in both command bodies and verified by inspection against `HEAD`; finding 2's governing contract is corrected and consistent across MANUAL and AUTO, but two restatements of the old narrow condition survive at `resolve-repo-problem.md:13` and `:206` and could not be edited in this run. No accepted Unit 4 behaviour was broken by the corrections that did land.

Evidence: the frozen findings reproduce at `HEAD` — `git grep -c 'more than a couple of lines' HEAD` returns 1 in each command file and `git grep -n 'fix-symlinks' HEAD` returns `resolve-incident.md:168` and `resolve-repo-problem.md:86`; the same searches over the working tree return no match, so the corrections are visible as a state change and not as an assertion. The unresolved half is equally checkable: `grep -n 'actionable repository fix'` still returns lines 13 and 206. The permission refusal is the recorded tool error on the first `Edit` against `.claude/commands/resolve-repo-problem.md`, and the spike run log records the cause at `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/20260810T151601-8db95197-34454-diagnostics-workflow.log` — `permission mode: default — asked for explicitly, so the child does NOT inherit this checkout's bypassPermissions`.

**Deferrals — noticed, recorded, not implemented.** The three from Unit 4 stand unchanged (stale `/resolve-repo-problem` description; the weak transfer-owner illustration, now partly overtaken by finding 3's fix; the bridge not writing back to a stale triage note). One new item, recorded as a deferral and not as a fourth finding:

4. **The spike harness cannot run a Work Loop unit that edits `.claude/commands/`.** A hop launched with `--permission-mode default` cannot write the very files this task's units exist to change, so any unit of this task routed through the spike stalls at the same point regardless of its content. That is a property of the harness, not of this task, and it is what turned an applied correction into an uncommitted working tree once already.

## Blocker

None for an attended Claude run in this checkout using the operator-approved `acceptEdits` permission for the two command files. The dispatcher cannot carry this hop because it hardcodes `--permission-mode default`.

## Next action

Final tightly-bounded fix permitted under Work Loop core § 3, “If the correction was not enough”:

1. In `.claude/commands/resolve-repo-problem.md:13`, replace the surviving “actionable repository fix” queue condition with: “when the failure was confirmed and triage ended in one of the three ranked options: Quick patch, Structural fix or Defer.”
2. In the same file's closing section (currently around line 206), replace the surviving “actionable repository fix is recommended” condition with: “when the failure is confirmed and triage ended in one of the three ranked options, Defer included”.

Change exactly those two sites and no other command text. Do not run the behavioral matrix or launch nested Claude sessions. Verify only that both stale conditions are gone, both replacements agree with the already-correct MANUAL/AUTO contract, and the final diff from correction commit `9a8399c` contains those two wording edits plus this state-file handback. Commit the bounded final fix, set `turn: codex`, and stop. Newly noticed issues remain deferrals.
