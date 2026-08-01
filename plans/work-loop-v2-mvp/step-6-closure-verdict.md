## Closure verdict

**Not resolved yet** — A, B and C are structurally resolved and the 149-assertion harness is green,
but both runtime prompts changed without a fresh live invocation, so the closure check cannot yet
answer “did the correction break something?” strongly enough for a stable pilot candidate.

## A — resolved?

**Yes.** The Codex skill still places the operator outside the Codex↔Claude file interface and says
that a request arrives directly before a state file exists (`SKILL.md:16–18`). It retains the
three-case Next-routing table keyed to the actor whose turn was written (`:23–29`), the fixed
`logs/work-loop/` destination (`:33`), and the no-Git boundary (`:20`). The correction did not
reintroduce the circular intake path or the unconditional hand-off to Claude.

## B — resolved?

**Yes.** The harness still uses the closed known-file set and `unexpected_worklog_files` predicate
(`work-loop-v2-slice-1.test.sh:430–449`). It asks whether any unrecognised state file exists, not
whether a filename happens to contain `direct`. The two Direct Work assertions remain conjoined
with the positive target edits, so absence alone cannot make them pass.

## C — resolved?

**Yes in structure.** Shared rules are now linked to their owning core sections while the runtime
files retain actor-specific mechanics. Admission decisions defer to core § 2; identity validation,
de-escalation and correction defer to their core owners; the exact correction hand-off token is
named once in core § 3 (`work-loop-v2-executable-core-v0.1.md:103–112`) and only referenced by the
producer and consumer. The remaining overlap is operational: state-file discovery, on-stop writes,
turn changes, output shapes, routing and commits. That matches the practical boundary between
policy and mechanics rather than creating a new abstraction.

The correction also adds no lane, lifecycle step, approval gate, reviewer, state system or operator
ritual. Both runtime artifacts are shorter. The core-owned token is a small shared interface, not a
framework. On ceremony, governance and overengineering, the runtime correction is proportionate.

## Did the correction break anything?

The four supplied blob hashes matched exactly. I ran
`bash logs/scripts/work-loop-v2-slice-1.test.sh`: **149 passed, 0 failed, exit 0**. Static link,
no-copy, retained-mechanic and historical behaviour checks all pass; A and B remain protected.

One blocking regression question remains unanswered. Most behavioural assertions read outcomes
created by the pre-correction prompts from repository history. They prove those behaviours happened,
but cannot prove that a fresh model still performs them after the prompts were changed. The supplied
red runs prove the rewritten assertions are falsifiable as text/interface checks; they are not live
smoke tests of the corrected runtime instructions. Accepting now would move that uncertainty into
the pilot despite this closure check being specifically responsible for correction-caused blocking
regressions.

The non-runtime surface did grow: core +11 lines and harness +53 while the two runtime artifacts
shrank by five combined. That is not a blocking governance regression because it adds no operating
stage and the new assertions protect the single-owner boundary. It is, however, the limit: further
test or policy machinery is not justified for this correction.

## If not resolved

**Permit one final tightly bounded fix**, used first as a verification step:

1. In a fresh Claude session, invoke the corrected command on the existing foreign-state failing
   case. It must read the core, reject the mismatch before mutation, and leave the file byte-identical.
2. In a fresh Codex session, give the corrected skill a non-qualifying admission request directly in
   conversation. It must apply core § 2, open no state file, and route the Next instruction to the
   operator or Direct Work rather than Claude.
3. Re-run the same 149-assertion harness.

If both live checks pass, no code change is needed and the closure may clear on that evidence. If
one fails, the only permitted edit is the minimum missing actor-specific mechanic exposed by that
failure, followed by the same live check and harness. No new behaviour, document, assertion family,
review pass or policy redesign may enter. This choice has high value because it tests the exact
regression mode created by the correction, and low process risk because it adds no permanent
governance.

## Deferrals

- The C-specific harness commentary and assertion split may be compressed later only if the pilot
  shows real maintenance friction. Do not schedule a cleanup merely because the harness is longer.

## Accepted limitations to carry into the pilot

1. Folder creation from a genuinely absent `logs/work-loop/` remains untested.
2. Most opening briefs in the slice evidence were hand-written fixtures; real Codex opening was
   demonstrated in Slice 1 and the Step 6 admission run.
3. Slice 2's menu task first pass and assessment block are fixture material; its correction hand-back
   and closure were real.
4. The writing standard's “never restate the core” rule and its requirement to name on-stop behaviour
   remain in tension. The accepted practical boundary is: link the shared trigger and rule; retain
   only actor-specific on-stop mechanics. Reopen only if pilot use shows that boundary is unclear or
   causes drift.
