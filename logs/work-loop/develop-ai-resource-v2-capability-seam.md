---
task: develop-ai-resource-v2-capability-seam
turn: codex
---

## Objective and scope

Make `.claude/commands/develop-ai-resource.md` describe a truthful, live boundary between Work Loop
v2's ownership of operating outcomes and `/develop-ai-resource`'s ownership of durable AI artifacts,
without claiming that Work Loop v2 emits the legacy upstream fields or changing the existing four
provenance checks.

Scope is exactly `.claude/commands/develop-ai-resource.md` plus this task-state file. Excluded:
`.claude/commands/leverage-idea.md` (approved plan Unit 2); retirement ownership (Unit 3); the v1
capability method, capability record and doctrine (Unit 4); the Work Loop v2 core, Codex skill,
Claude command and tests; templates; the approved plan; any new command, skill, state system or
producer for `**Capability:**` / `**Settled upstream:**`.

## Lane and unit

Standard. Implementation mode. Unit 1 — repair `/develop-ai-resource`'s dangling Work Loop v1 seam
and demonstrate the resulting ownership/provenance behaviour.

Named reason for the loop: this is a shared, load-bearing command used across projects. A superficially
small wording change could silently create circular ownership, trust an unproved handoff or claim a
producer that does not exist, so the implemented result needs fail-capable seam evidence and an
independent Codex assessment before it counts as complete.

Plan justification: the operator approved the exact corrected plan content committed at `6af280e`
and has now explicitly started Unit 1. That current operator decision authorizes this unit only and
supersedes the plan file's stale “Draft — not approved” label for this bounded execution. Governing
unit: `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7, Unit 1. This brief
does not authorize Units 2–4 or a material departure from Unit 1.

## Brief

Why this unit, why now: Work Loop v1's command was deleted, but `/develop-ai-resource` still names it
throughout the boundary and upstream-handoff clauses. The approved plan makes this the first
implementation slice because the command owns AI-artifact qualification and its current prose points
at an executor that no longer exists. The desired result is the smallest truthful reconciliation of
that seam, not a migration of the v1 capability system.

### Governing and applicable sources

- Current operator approval recorded above — governing for authorization and unit boundary.
- `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` § 7 Unit 1 — governing
  content at commit `6af280e`; use the outcome, exclusions and evidence standard, not its proposed
  wording as an implementation prescription.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and
  `.agents/skills/work-loop-v2/SKILL.md` — applicable authority for current owner selection,
  Direct/Standard admission and the rule that Work Loop routes without wrapping a specialist.
- `.claude/commands/develop-ai-resource.md` — implementation target and authority for durable
  AI-artifact qualification.
- `templates/capability-record.md` — read-only authority for the ACTIVE/TERMINAL status sets used by
  the four provenance checks.
- `skills/capability-development/SKILL.md` and `docs/work-loop.md` — read-only v1 context needed to
  understand the old seam. Their keep/fold/retire disposition is explicitly not this unit.

Material reclassification: the plan's content is approved at `6af280e`, but its header was not
updated after approval. Treat that label as stale metadata for authorization of this unit only; do
not edit the plan or infer approval for adjacent units.

### Verify before mutation

Check every claim below against the live repository. If a load-bearing claim is false, record the
evidence, set `turn: codex`, commit only this state file if appropriate, and stop rather than
improvising a different unit.

1. `.claude/commands/work-loop.md` is absent from both the working tree and tracked command paths.
   Settle this by inspecting that exact path and the tracked `.claude/commands/` surface.
2. In `.claude/commands/develop-ai-resource.md`, the dead v1 command is still named on seven lines
   with eight occurrences when `/work-loop-v2` forms are excluded. Report the exact search and
   observed count; do not rely on the plan's count.
3. The current Work Loop v2 Codex skill still routes an unresolved operating capability or
   repository feature to Work Loop v2, while routing a need for a durable AI artifact to
   `/develop-ai-resource`. Cite the current clauses. If it no longer establishes this one-owner
   boundary, stop.
4. No executable producer currently emits a qualified handoff carrying both reserved fields
   `**Capability:**` and `**Settled upstream:**`. Bound this absence claim to the current Work Loop
   v2 command/skill, capability-development skill, relevant command surfaces and repository-wide
   literal-field search. A manually authored brief or a consumer mentioning the fields is not a
   producer.
5. `templates/capability-record.md` still defines the ACTIVE and TERMINAL status sets consumed by
   Step 1.0, and exactly one live capability record still exists at the workspace project surface
   searched by the current contract. Report the bounded search; do not edit either.
6. The existing four Step 1.0 provenance checks remain internally valid even though their original
   producer is gone. If one is invalid independently of the producer, stop: fixing the checks is
   outside this unit.

### Required outcome

Revise only `.claude/commands/develop-ai-resource.md` so that:

- it names the live Work Loop v2 owner for operating-outcome work without presenting Work Loop v2
  and `/develop-ai-resource` as simultaneous owners;
- it preserves the outcome-versus-artifact boundary: Work Loop v2 owns progression and operational
  adoption; `/develop-ai-resource` owns whether and how the AI artifact should exist;
- it states the upstream-field reality honestly. If claim 4 holds, the four-check clause is dormant
  producer-side but still defensive consumer behaviour; the text must not imply Work Loop v2 emits
  those fields today;
- it removes every dangling reference to the deleted `/work-loop` command from this file, excluding
  legitimate `/work-loop-v2` text;
- it leaves the four provenance checks, status vocabulary, ordinary direct-invocation path and
  artifact-only Step 4 disposition semantics behaviourally unchanged.

Choose the smallest wording that achieves this. Do not create a producer, rewrite the capability
method, delete the dormant defensive checks, or solve Unit 2 while here.

### Fail-capable acceptance evidence

Return all of the following in `## Latest result`:

1. **Dead-route regression:** the exact pre-change search and count, followed by the same search
   after the edit returning zero deleted-command references while still distinguishing
   `/work-loop-v2`.
2. **One-owner routing cases:** walk two representative requests through the current written
   boundary:
   - an existing project's operating outcome is unresolved and may eventually need an AI artifact;
   - the operating need is settled and the specific question is whether a durable AI artifact
     should exist.
   Each case must name one first owner and the condition that ends that owner's responsibility. The
   evidence fails if both owners are returned simultaneously or if the handoff loops back.
3. **Provenance cases:** demonstrate from the amended text what happens for no reserved fields,
   exactly one field, and both fields with a corroborating active record. Also state who, if anyone,
   currently produces the both-field form. The evidence fails if a label is trusted without the
   four checks or if Work Loop v2 is claimed as a producer without repository evidence.
4. **Non-interference:** show that the four checks, ACTIVE/TERMINAL vocabulary, direct invocation,
   and Step 4's artifact-only disposition remain unchanged. Use a meaningful diff/read-through or
   an existing applicable check; do not invent a ceremonial test.
5. **Boundary proof:** confirm no file outside `.claude/commands/develop-ai-resource.md` and this
   state file changed for this unit. Existing unrelated working-tree changes are not this unit's
   work and must not be staged, reverted or committed.

Completion: the target command carries the truthful v2 boundary, all five evidence groups are
recorded, and no excluded surface changed. Set `turn: codex`; commit only
`.claude/commands/develop-ai-resource.md` and this state file by explicit pathspec; stop for
assessment.

Stop and hand back to Codex if a verify-first claim is false, the truthful fix requires another
owned path, or the evidence cannot distinguish a real boundary repair from a textual substitution.
Stop for the operator if implementation would reopen the approved scope, decide the v1 capability
system's disposition, or make a hard-to-reverse change.

## Latest result

Inspected (2026-08-07):

- Claim (1): HOLDS — `ls .claude/commands/work-loop.md` → "No such file or directory";
  `git ls-files .claude/commands/ | grep -i work.loop` → only `.claude/commands/work-loop-v2.md`
  (88 tracked command files). The v1 command is absent from both working tree and tracked paths.
- Claim (2): HOLDS exactly — `grep -n "/work-loop" .claude/commands/develop-ai-resource.md` → seven
  lines (24, 34, 64, 67, 159, 163, 164); `grep -o "/work-loop[a-z0-9.-]*" | sort | uniq -c` → 8
  matches (7 × `/work-loop`, 1 × `/work-loop.md`), zero `/work-loop-v2` forms. Seven lines, eight
  occurrences, as stated. **One qualification the plan's count does not carry:** the eighth match is
  `docs/work-loop.md` on line 163 — a path to a file that exists (`ls` → 30397 bytes, `Execution
  boundary` at line 42), not a reference to the deleted command. The removal target is therefore the
  seven backticked `` `/work-loop` `` command references across six lines (24, 34, 64, 67×2, 159, 164);
  line 163 needed no change.
- Claim (3): HOLDS — `.agents/skills/work-loop-v2/SKILL.md` line 166 routes `/work-loop-v2` for
  "bounded repository work no specialist owner covers"; line 167 routes `/develop-ai-resource` for
  "a durable skill, command or agent may need to exist". Routing step 2 (line 122) requires "exactly
  one owner"; line 156 forbids "a shortlist and not a sequence"; line 160 forbids returning a
  supporting stack alongside the owner. The one-owner boundary is intact.
- Claim (4): HOLDS — no producer. `grep -rn 'Settled upstream' .claude/ skills/ .agents/` → only
  `.claude/commands/develop-ai-resource.md` lines 24 and 34 (this consumer's own prose).
  `grep -rn '\*\*Capability:\*\*'` over the same surfaces → the same file plus
  `.claude/commands/leverage-idea.md:190`, which explicitly instructs *against* writing that label
  ("never as a `**Capability:**` bold label"). A repo-wide search also hits
  `plans/2026-07-28-*.md` (documentation) and `ai-resources-active-unit-routing/` — the latter
  confirmed by `git worktree list` to be a separate worktree on branch
  `codex/2026-07-31-active-unit-routing`, not the live surface. No command, skill, agent, hook or
  script emits the pair.
- Claim (5): HOLDS — `templates/capability-record.md` lines 6–7 define
  `ACTIVE: in-development | continue-trial | revise | paused` and
  `TERMINAL: adopted | keep-local | closed | retired | rejected`, with the `STATUS IS A SET` block at
  lines 33–36. `ls projects/*/development/*.md` from the workspace root → exactly 1 file:
  `projects/axcion-ai-system-owner/development/prime-runtime-delegation.md`. Neither file edited.
- Claim (6): HOLDS — read through lines 44–57. Each check settles against a surface that exists
  independently of any producer: check 1 against the `projects/*/development/{slug}.md` glob
  (1 match today), check 2 against the path shape plus a `capability:` frontmatter key, check 3
  against `capability:` and `owner_project:`, check 4 against the template's ACTIVE set. The live
  record satisfies all four. No check depends on a producer existing, so none is invalid on that
  ground.

Result: `.claude/commands/develop-ai-resource.md` now names `/work-loop-v2` as the live owner of
operating outcomes, states the ownership boundary as sequential rather than simultaneous, and records
the reserved-field reality as verified absence of any producer. Six lines changed (24, 34, 64, 67,
159, 164); the four provenance checks, the status vocabulary, the field-presence routing, the
direct-invocation path and Step 4's artifact-only disposition are byte-identical to `HEAD`.

Evidence:

**1 — Dead-route regression.** Before: `grep -o "/work-loop[a-z0-9.-]*" | sort | uniq -c` →
`7 /work-loop`, `1 /work-loop.md`; `grep -c '`/work-loop`'` → **7**. After: `1 /work-loop-v2`,
`2 /work-loop`, `2 /work-loop.md`; `grep -c '`/work-loop`'` → **2**. The search still distinguishes
`/work-loop-v2` (now present, 1 occurrence, line 24) from the bare form. **The two survivors are
deliberate and are flagged for assessment, not hidden:** line 24 "The v1 `/work-loop` command that
once held this seam has been deleted" and line 67 "the v1 `/work-loop` capability route; that command
has been deleted". Each names the command only to state that it is gone, so neither is a dangling
route — but zero was the literal target, and whether a historical mention counts as removed is
Codex's call, not mine. Zero live routes to the deleted command remain: no line presents `/work-loop`
as something to invoke. `docs/work-loop.md` rose from 1 to 2 occurrences because line 24 now cites
that live file as surviving v1 method documentation.

**2 — One-owner routing cases**, walked through the amended line 24 plus the v2 skill index:

- *An existing project's operating outcome is unresolved and may eventually need an AI artifact.*
  First owner: **`/work-loop-v2`**, alone. Ground: skill line 166 (bounded work no specialist covers)
  and amended line 24, "while the operating outcome is unresolved Work Loop v2 owns it". The artifact
  trigger at skill line 167 has not fired, because whether an artifact should exist is not yet the
  open question. Ownership ends at a named condition: "once the open question is whether a *durable
  AI artifact* should exist, that question is this command's and Work Loop v2 routes it here."
- *The operating need is settled and the specific question is whether a durable AI artifact should
  exist.* First owner: **`/develop-ai-resource`**, alone. Ground: skill line 167, plus the same
  sequential clause read from the other side. Ownership ends when Step 4 returns the artifact's
  disposition — the operator's Ship/Revise/Defer/Delete choice on direct invocation (line 157), or the
  disposition recorded against the record in upstream mode (line 159).

  **How this could have failed and did not:** it fails if both owners come back at once, or if the
  handoff loops. Line 24 states the boundary is "sequential, never simultaneous" and that this command
  "returns a disposition on the artifact and never takes the operating outcome back"; line 159
  (unchanged) sends the adoption decision to the upstream owner and its operator gate, "not here". The
  superseded line 24 was the failing case: it asserted `/work-loop` "owns the operating outcome; this
  command owns the artifact" with no ordering, and named a command that no longer exists — so case 1
  had no reachable first owner at all.

**3 — Provenance cases**, read off the amended file:

- *No reserved fields* → line 38, unchanged: ordinary direct invocation, 1.0 ignored entirely,
  Step 1 runs from 1.1. Produces no output. This is the path every real brief takes today.
- *Exactly one field* → line 39, unchanged: **malformed upstream handoff** — report it and run
  1.1–1.6 in full. `.claude/commands/leverage-idea.md:190` is written specifically to avoid landing
  here.
- *Both fields with a corroborating active record* → line 40 plus the four checks. Run against the
  one live record: check 1 glob → exactly 1 match; check 2 path `projects/axcion-ai-system-owner/
  development/prime-runtime-delegation.md` matches `projects/{p}/development/{slug}.md` and the file
  opens with a `capability:` key; check 3 `capability: prime-runtime-delegation` equals the filename
  stem and `owner_project: axcion-ai-system-owner` equals the path's `{p}`; check 4
  `status: in-development` is in the ACTIVE set. All four pass → upstream mode; 1.1–1.2 satisfied by
  the record, 1.3–1.6 still run on the artifact.
- *Who produces the both-field form today* → **nobody.** Amended line 67 states this and carries the
  dated search that establishes it, and explicitly says Work Loop v2 does not emit these fields. The
  clause is recorded as dormant producer-side and live consumer-side.

  **How this could have failed and did not:** check 4 discriminates — a record at
  `status: rejected` would fail it while passing 1–3, and the live record passes only because its
  status is genuinely `in-development`. Check 1 discriminates — zero or two-or-more matches both
  fail, and the glob returns exactly 1. The producer claim would have failed had the search returned
  any command, skill or script emitting the pair; it returned this consumer and one file that
  prohibits the label.

**4 — Non-interference.** `git diff --stat` → 1 file, 6 insertions, 6 deletions;
`git diff -U0 | grep '^@@'` → single-line hunks at 24, 34, 64, 67, 159, 164 only. Region-by-region
`shasum` of `git show HEAD:<file>` against the working file returns **UNCHANGED** for: lines 36–42
(field-presence routing), 44–57 (the four checks, including the ACTIVE/TERMINAL sets and check 4's
rationale), 38–40 (the three-way route), 61–63 (the do-not-skip-1.1–1.2 prohibition), 65
(do-not-infer-from-the-brief), and 166–172 (Step 4's no-candidate branch and the `inbox/` closing
rule). The ACTIVE and TERMINAL enumerations are present verbatim (`grep -c` → 1 each). This is an
existing-check read-through against `HEAD`, not an invented test.

Of the six changed lines, four (34, 64, 159, 164) replace the dead command name with "the upstream
capability owner" and change attribution only — the prohibition at 64 still forbids auto-repair and
creation, and 159/164 still place adoption and accept/reject outside this command.

**5 — Boundary proof.** `git status --porcelain` → ` M .claude/commands/develop-ai-resource.md`,
` M logs/friction-log.md`, `?? logs/work-loop/develop-ai-resource-v2-capability-seam.md`.
`logs/friction-log.md` was already modified before this unit began and is not this unit's work: it
was not staged, not reverted and not committed. Only the two authorized paths were staged, by
explicit pathspec.

Deferral noticed mid-unit, recorded and not done: line 163 rests its "contradiction is resolved"
claim on `docs/work-loop.md` § Execution boundary. That file is live today, so the citation is sound
now — but it is v1 doctrine whose keep/fold/retire disposition is Unit 4. If Unit 4 retires it, line
163 becomes a dangling citation. Not fixed here because touching it would decide the v1 doctrine's
fate, which this unit's scope excludes; it belongs in Unit 4's own scope as a downstream dependency.

## Blocker

None.

## Next action

Codex: assess Unit 1. The five evidence groups are recorded above. Two points want an explicit
verdict — whether the two surviving historical `/work-loop` mentions (each stating the command is
deleted) satisfy "removes every dangling reference", and whether the Unit 4 dependency recorded as a
deferral is accepted as a deferral rather than folded into this unit.
