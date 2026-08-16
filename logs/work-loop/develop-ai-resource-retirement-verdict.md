---
task: develop-ai-resource-retirement-verdict
status: closed
turn: operator
---

## Outcome

`/develop-ai-resource` is now the owner for retiring a durable AI artifact already in service.
Retirement is a § 1.6 verdict, and **qualification is the only entry** — naming an in-service artifact
at invocation does not select the branch, so an ordinary improvement cannot be captured by it.

The branch requires, in order: an explicit **operator decision before anything is removed**; a
dependency inventory of every reference, consumer, invocation path, deployment, symlink, automatic
trigger and routing document, **established by search rather than recall**, each with its replacement
or accepted loss; **same-search proof that no dangling route remains** as the completion standard; and
a record of what was removed in the ordinary task and commit evidence. A dependency that cannot yet be
removed or safely dispositioned stops the retirement into Revise or Defer rather than a false
completion. No register, tracker or status file was added — the commit is the record.

`Delete candidate` remains distinct and unchanged: it disposes of an unadopted candidate produced in
the current run, where nothing depended on it. Create, improve, reuse, no-build, defer and
upstream-artifact disposition behaviour from Unit 1 were preserved.

## Decisions that matter

- **The two neighbouring object classes were left unassigned, deliberately.** Operating-capability
  retirement remains defined but unreachable, pending Unit 4; non-AI repository-feature retirement
  remains without a candidate owner. This unit assigns neither and names no substitute route — the
  command states the class and that its ownership is unresolved. An earlier draft did assign both,
  and the correction round removed that.
- **An inbox-originated retirement closes under the existing archive convention.** `Retire`, `Keep`
  and `Defer` are terminal and archive the brief with the one-line disposition note (`Defer` naming
  its reopening trigger); `Revise` is not terminal and leaves the brief queued. The pre-existing
  disposition list was not altered.
- **The `0516bf6` replay now fails until every dependent surface is named and cleared or
  dispositioned.** That retirement deleted the v1 `/work-loop` command file while 13 files went on
  naming it; a "remove the machinery" test would have passed it. The inventory-plus-re-search pair is
  what catches it.
- **Deferred to the Unit 4 v1-doctrine cleanup:** `docs/ai-resource-creation.md:17` still describes
  the deleted v1 `/work-loop` handoff as live, and
  `docs/ai-resource-development-playbook/RESOURCES.md:13` still links to
  `../../.claude/commands/work-loop.md`, a file that no longer exists. Neither was fixed here — the
  brief permits a documentation edit only for retirement discoverability or a policy contradiction
  with this change, and both are `0516bf6` residue belonging to the Unit 4 boundary rather than to
  this retirement-owner unit.

## Evidence

Implementation commit `3c84c70` — "update: develop-ai-resource — give durable AI artifacts a real
retirement path" (26 lines changed in the command). Correction commit `32d29e7` — "update:
develop-ai-resource — bounded correction on the three frozen findings" (6 lines). Both identified from
`git log -- .claude/commands/develop-ai-resource.md`.

The implementation round returned five fail-capable evidence groups: the `0516bf6` replay against a
13-file live search; a live-dependency stopping case; candidate-deletion and ordinary-flow
non-interference; the object-class boundary; and a boundary-and-simplification proof.

The correction round recorded three checks, all reproduced by inspection before any edit and all
corrected: (1) two direct invocations — one improvement, one retirement — demonstrated taking
different branches once entry was bound to the § 1.6 verdict; (2) the two excluded-object cases re-run
against the approved plan's own lines 274 and 276, each now yielding a named class and unresolved
ownership rather than a route; (3) `Retire`, `Keep`, `Defer` and `Revise` demonstrated for an
inbox-originated retirement. A content-anchored comparison against `3c84c70` reported UNCHANGED for
every item the hand-back required preserved, so the correction broke nothing.

## Accepted limitations

- `docs/ai-resource-creation.md:17` and `docs/ai-resource-development-playbook/RESOURCES.md:13` still
  reference the deleted v1 `/work-loop` command, the second as a broken file link. Both are deferred
  to the Unit 4 v1-doctrine cleanup.
- No limitation in the durable-AI-artifact retirement path itself.
