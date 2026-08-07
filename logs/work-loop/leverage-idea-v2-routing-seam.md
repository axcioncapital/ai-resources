---
task: leverage-idea-v2-routing-seam
turn: operator
---

## Outcome

`.claude/commands/leverage-idea.md` now routes both of its Work Loop classes to the live owner. Seven
live bare `/work-loop` destinations became seven `/work-loop-v2` destinations, and zero bare route
remains. The six surfaces that repeat the routing — the route list, the Step 2 duplicate gate, the
"cap survives the route" example, the two Step 7 payload rules and the two Step 10 owner-table rows —
agree with one another after the change.

Work Loop v2 is the one first owner for an unresolved operating capability. Where that work later
turns out to need a durable AI artifact that does not exist, Work Loop v2 routes that question to
`/develop-ai-resource` when it actually arises; the two are never returned simultaneously.

Unit 2 changed only `.claude/commands/leverage-idea.md`. Units 3–4 remain unstarted.

## Decisions that matter

- **The router names the correction-sizing boundary; it does not reproduce Work Loop v2's admission
  method.** A settled correction is handed over sized as a correction, and Work Loop v2 admits it —
  small and reversible becomes Direct Work with no state file, and only a correction meeting its
  named-reason bar opens a Standard unit.
- **"Meeting its named-reason bar" was accepted as the wording.** It identifies where the boundary
  sits without copying the qualifying reasons, applying the admission test inside `/leverage-idea`,
  or pre-deciding Direct versus Standard. An earlier draft enumerated core § 2's three qualifying
  reasons and was cut before hand-back, because paraphrasing the test is a way of copying it.
- **The complexity-budget cap and the adjacent AI-resource route were required to stay behaviourally
  unchanged, and did.** The cap keys on whether the recommended option introduces a new component,
  not on which command receives it, so renaming a destination inside its example list cannot create
  an exemption.
- **No historical mention of the deleted command was kept here.** Unlike Unit 1, `/leverage-idea` is
  a live router with no reason to name a deleted command, so zero was reachable and was reached.

## Evidence

Implementation commit `346004e` — "update: leverage-idea — route operating capability and settled
corrections to Work Loop v2". Seven insertions, seven deletions, one per occurrence found.

Five fail-capable evidence groups were recorded and assessed before this closure: the dead-route
regression (7 bare `` `/work-loop` `` before and 0 after, with the `-v2` form returning 7, so a
substitution that clobbered a legitimate mention would have shown as a count mismatch); an
operating-capability case returning exactly one owner at both sites; two settled-correction sizing
cases that diverge at Work Loop v2 rather than at `/leverage-idea`; a region-by-region `shasum`
against `HEAD` showing the cap definition, the triviality gate, the `/develop-ai-resource` route with
its reserved-label prohibition, and the untouched Step 7 routes and table rows all byte-identical;
and a boundary proof that no file outside the target and this state file was staged.

## Accepted limitations

None.
