UNIT: 2026-07-29-leverage-idea-lifecycle-frame    STREAM: 2026-07-29-leverage-idea-lifecycle    PHASE: frame
REPO: ai-resources                                BASE: 44062e4bb811bd06cdb83263686fe436521cfc27    NEXT: Codex

EVIDENCE
Status: complete
Route: reviewed (non-capability)
Object under work: NOT EDITED — Frame closes need/owner/scope only.

---

## 0. BASE deviation (stated, not silently absorbed)

The brief declares `BASE: 2b8b350`. This worktree is at `44062e4`, which is `2b8b350`'s **parent**
(`git merge-base main HEAD` → `44062e4` = HEAD; `git log HEAD..main` → exactly one commit, `2b8b350`).
So this unit is one commit behind the declared base, not diverged from it.

`2b8b350` is `loop: open 2026-07-29-prime-minimum-responsibility-build-2` — an unrelated stream worked
by a concurrent worktree session. Overlap check against this stream's targets:
`git log --name-only 44062e4~6..main | grep -E "leverage-idea|agent-tier-table|develop-ai-resource"`
→ **empty**. Files that stream touches: `prime.md`, `session-start.md`, `docs/session-marker.md`,
`logs/decisions.md`, `logs/improvement-log.md`, `logs/runs/*.json`, `logs/session-notes.md`.
No collision. Working from `44062e4` is safe for this stream.

---

## 1. Premise verification

| # | Premise | Verdict | What was run → what was observed |
|---|---|---|---|
| P1 | leverage-idea stops at an implementation plan; only the new-skill bridge routes through `/develop-ai-resource` | **confirmed** | `Read leverage-idea.md:1-220`; `grep -n "develop-ai-resource" leverage-idea.md` → exactly one hit, `:209` (the "New skill" bridge row). Stop-at-plan asserted twice: `:9` "Advisory only: it stops at the implementation plan and applies no change", `:144` "Stop here — no execution." Steps 7/9/10 read in full. |
| P2 | `/develop-ai-resource` is the standard qualification path for every new durable AI resource | **confirmed** (one wording imprecision) | `develop-ai-resource.md:13` verbatim: "Creating a new durable resource — this is the standard qualification path." `:9` enumerates "skill, reusable prompt, persistent instruction, reference file, command, script or hook". **"Agent" is not in that enumeration**; agent coverage rests on `:73` (1.3 search scope explicitly includes `.claude/agents/`) and workspace `CLAUDE.md` § AI Resource Creation ("skills, commands, agent definitions, workflow templates"). The premise holds; the command's own list is one word short of it. |
| P3 | A raw direct brief omits Mechanism/Evidence; Capability/Settled upstream are reserved for corroborated `/work-loop` capability handoffs | **confirmed** | `create-skill.md:9`: "A **qualified brief** carries `**Mechanism:**` and `**Evidence:**` fields… Anything else is a raw need." `request-skill.md:65` states the same from the producer side. `develop-ai-resource.md:121-122` is where both fields are produced. `:32-67` (Step 1.0) gates `**Capability:**`/`**Settled upstream:**` behind four checks against a real record on disk; `docs/work-loop.md:189-194` makes either-label-alone a malformed handoff. |
| P4 | `audits/working/` is gitignored, so its analysis cannot be the sole durable next action | **confirmed** | `.gitignore:28` → `audits/working/`. `git check-ignore -v audits/working/test.md` → exit 0, matched by `.gitignore:28`. **Positive control:** `git check-ignore -v docs/work-loop.md` → exit 1 (not ignored) — the check discriminates rather than always reporting "ignored". **Refinement:** `git ls-files audits/working/` → 13 tracked files, all `audit-summary-*` / `audit-working-notes-*` force-added before the rule; `ls audits/working/ \| grep -i idea` → none. No `/leverage-idea` output is tracked, and any new write there is ignored. |
| P5 | leverage-idea hardcodes AI_RESOURCES and dispatches general-purpose unpinned | **confirmed** | `leverage-idea.md:51` → `AI_RESOURCES = "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"` (absolute). `:57`/`:59` dispatch a `general-purpose` subagent via `Task` with no model pin (`grep -n "model:" leverage-idea.md` → only `:3`, the command's own frontmatter). `docs/agent-tier-table.md:129` lists `leverage-idea` **by name** in the row "Spawns `general-purpose` unpinned, not yet retrofitted (≥6)". |
| P6 | Shared through project symlinks — the applicable route trigger must be tested, not assumed local | **confirmed** | `find projects -name "leverage-idea.md" -type l` → **14** symlinks (`buy-side-service-plan`, `axcion-pitch-engine`, `axcion-sector-intelligence`, `strategic-os`, `project-planning`, `axcion-website`, `management-os`, `axcion-linkedin-os`, `repo-documentation`, `axcion-copy-factory`, `axcion-communication-system`, `axcion-ai-system-redesign`, `axcion-content-programme`, `axcion-systems-builder`). Each resolves to `../../../../ai-resources/.claude/commands/leverage-idea.md`. `find projects -name "leverage-idea.md" \| wc -l` → 14 (all are symlinks; none is a local fork). |

**No load-bearing premise was rejected. The unit proceeds.**

---

## 2. Route classification

```
ROUTE: reviewed — "changes a shared ai-resources resource symlinked into projects"
```

**Reviewed trigger that fired** (`docs/work-loop.md:60`): the object is a shared `ai-resources`
resource symlinked into projects — 14 symlinks verified at P6.

**Challenged disproved, per trigger** (`docs/work-loop.md:59`):

- *`/risk-check` structural class* — the classes are owned by `docs/audit-discipline.md:60-65`: hook
  edits, permission changes, cross-cutting CLAUDE.md, **new** commands or skills, new symlinks,
  shared-state automation. This stream edits an **existing** command and the brief forbids adding any
  new durable component. No class matches.
- *Deletes or retires an active resource* — no; `/leverage-idea` survives and stays reachable.
- *Changes git, branch or worktree behaviour* — no.
- *Touches three or more repositories* — no; brief scope is `ai-resources` only, and the 14 consumers
  are symlinks to the canonical file, so no sibling write is needed to propagate.
- *Has already failed to converge twice* — no; this is the stream's first unit.

**Non-capability.** The object is a shared command's routing rule, not an operating outcome inside a
project (`docs/work-loop.md:13`, § Boundary sentences). Therefore: **no capability record, no
`projects/{p}/development/{slug}.md`, no `active_unit` pointer.** Confirmed there is no `projects/`
directory in this repository at all and `grep -rn "^stream:"` finds only the template placeholder at
`templates/capability-record.md:9`.

**Escalation tripwire recorded for Shape.** If the fix requires editing `ai-resources/CLAUDE.md`, that
is cross-cutting always-loaded content (`docs/audit-discipline.md:62`) and the route escalates to
**challenged**, arming G1 immediately (`docs/work-loop.md:67`, `:87`). The brief's named scope —
`leverage-idea.md` plus boundary documents / the tier roster — stays inside **reviewed**.

---

## 3. The need — five evidenced defects

### D1 — The bridge matrix routes every non-skill new resource around the qualification owner

`leverage-idea.md:207-214` is the Step 10 handoff matrix. Row `:209` ("New skill") is the **only** row
naming `/develop-ai-resource`. The adjacent row `:210` covers "New command / agent / hook / other
structural class" and its entire bridge is *"Plan's Gates name the `/risk-check` class; the bridge
repeats it."* — a risk gate, not a qualification path.

That contradicts `develop-ai-resource.md:13` ("Creating a new durable resource — this is the standard
qualification path") read against `:9`, which names **command, script or hook** among durable
resources. So the shipped command routes a proposed new command, hook or script straight to
implementation gating with the qualification step skipped.

**This is the brief's falsification condition #1 — "any proposed new durable AI resource bypasses
`/develop-ai-resource`" — and the current command already satisfies it.** It is a defect in the
existing artifact, not a feature request.

### D2 — For most outcomes the only next-action address is a gitignored file

Step 9 (`:167-197`) writes `{ANALYSIS_PATH}` = `{AI_RESOURCES}/audits/working/{DATE}-idea-{SLUG}.md`
(`:54`) and calls it "the one operator-facing deliverable" (`:169`). Step 10 prints
`Analysis: {ANALYSIS_PATH}` (`:204`). That path is gitignored (P4).

Only two outcomes leave a tracked trace:

- **PARK** → Step 8 appends to `logs/improvement-log.md` (`git ls-files logs/improvement-log.md` →
  tracked). This path is sound and has a machine consumer (`/prime` Step 3 anchors on `Severity:`,
  `:163`).
- **New skill** → Step 7 embeds an inbox brief *verbatim inside the analysis file*, but `:142` states
  "The command itself never writes to `inbox/`." It becomes durable only once the operator copies it.

Every other WORTH-DOING outcome — extend-existing, new command, new hook, new doc, cross-model — ends
with its plan living in an ignored file plus chat scrollback.

**Brief's falsification condition #4 — "an ignored analysis file is the only next-action address" —
is the current behaviour** for the majority of outcomes.

### D3 — The lever menu is AI-resource-only, so a non-AI idea has nowhere to go

Step 5's menu (`:103-107`) is exactly five levers: extend an existing resource · new command + agent ·
new CLAUDE.md rule or doc · new hook · park. The cross-model check (`:116`) redirects an idea whose
home is GPT / Perplexity / Notion / NotebookLM, but still assumes an *AI-resource build*.

Absent from the command entirely (`grep` over the file): `/scope-project`, `/tech-consult`,
`/work-loop`, `/improve-skill` as a first-class route, and any notion of a named project or domain
owner. Yet those boundaries are already asserted **from the other side**:

- `develop-ai-resource.md:22` — "`/leverage-idea` starts from an idea dump and stops at a plan".
- `develop-ai-resource.md:24` — `/work-loop` "owns the operating outcome; this command owns the
  artifact", i.e. an operating-capability idea belongs to `/work-loop`, which `leverage-idea.md`
  never mentions.
- `leverage-idea.md:11` names `/tech-consult` only as a *boundary to stay away from*, never as a
  destination an idea can be routed to.

**Brief's falsification condition #3 — "a non-AI idea is forced through an AI-resource lever menu" —
is the current behaviour.** The menu has no exit that is not a Claude Code artifact or a park.

### D4 — Hardcoded absolute `AI_RESOURCES` is wrong under the live worktree layout

`:51` pins `AI_RESOURCES` to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources` — the
**main** worktree. `git worktree list` shows four live worktrees of this repository
(`ai-resources` @ main, `ai-resources-2`, `ai-resources-leverage-idea`, `ai-resources-work-loop`).
A `/leverage-idea` run from any non-main worktree reads and writes the main worktree's tree while the
session's own branch state sits elsewhere. Low severity for reads; for the PARK write
(`logs/improvement-log.md`, `:148`) it means an append lands on whatever branch main happens to hold.

### D5 — Unpinned `general-purpose` dispatch

`:57`/`:59` spawn `general-purpose` with no tier pin. Per `docs/agent-tier-table.md:122`, an unpinned
spawn silently inherits the session model, so a judgment dispatch can run at Haiku with no signal;
per-dispatch pinning is "permitted **per-dispatch, never blanket**, and is the target state".
`leverage-idea` is named in the not-yet-retrofitted roster row at `:129`. `:139` requires that fixing
this **moves the command between roster rows in the same commit** — so `docs/agent-tier-table.md` is
a mandatory co-edit if D5 is taken, and is inside the brief's stated scope ("tier roster").

---

## 4. Who owns it

**Repository:** `ai-resources` (`git remote -v` → `axcioncapital/ai-resources`). Single repo; no
sibling write required.

**Primary object:** `.claude/commands/leverage-idea.md` (220 lines).

**Consumer contracts that must stay accurate if the object changes:**

| Consumer | Line | What it asserts about `/leverage-idea` |
|---|---|---|
| `.claude/commands/develop-ai-resource.md` | `:22` | "starts from an idea dump and stops at a plan" — a boundary sentence that becomes stale if the stop point moves |
| `.claude/commands/develop-ai-resource.md` | `:24` | gives `/work-loop` the operating outcome — the boundary D3 must route to |
| `docs/agent-tier-table.md` | `:129`, `:139` | roster row; mandatory same-commit move if D5 is fixed |
| `.claude/commands/create-skill.md` | `:9` | defines what makes a brief qualified vs. raw — constrains what D1's handoff may carry |
| `.claude/commands/request-skill.md` | `:65` | the sibling raw-brief producer; its wording is the precedent for `:209` |

**Distribution:** 14 per-file symlinks under `projects/*/.claude/commands/leverage-idea.md`, each
resolving to the canonical file. One edit propagates to all 14 with no per-project action — which is
exactly why the route is `reviewed` rather than `solo`.

**Not a target:** `plans/2026-06-12-leverage-idea-build-plan.md` is the historical build record
(status banner: "IMPLEMENTED & COMMITTED"). Read-only history. Its `:77` names a post-landing row in
the System Owner's `toolkit-relationship.md`, which lives **outside this repository** — see
LIMITATIONS.

---

## 5. Is it in scope at all?

**Yes — `/work-loop` implements; this does not route out.**

`docs/work-loop.md:44` (§ Execution boundary) admits "decision rules, processes … and settled
corrections to existing commands, skills, scripts and hooks". D1–D5 are corrections to a decision rule
inside an existing command. The brief additionally forbids adding "a command, agent, mandatory gate,
tracker or other durable component", so no new artifact is authored.

The route-out test at `:48` is "a **new** durable AI artifact must be authored, **or an existing one
materially expanded**". The part of this need that comes closest to *material expansion* is the change
to the command's own purpose statement at `:9` ("it stops at the implementation plan").

**Frame's judgment: not a material expansion, so no hand-off to `/develop-ai-resource`.** The reasoning,
stated so the review can attack it: the command's *output shape* is unchanged — still advisory, still
executes nothing, still terminates at a routing decision plus a payload. What changes is the
**correctness and completeness of the destination set**, and the **durability of the address** each
destination is given. Correcting where a router points is a settled correction; giving the router a
new engine would not be. **This judgment is the single most contestable call in this unit and is the
thing Shape must hold to.**

**Not `/scope-project`.** A legitimate owner exists (`ai-resources`, the command itself), and this is
not a new enduring programme — so `docs/work-loop.md:49`'s terminal exit does not apply.

---

## 6. What Shape must close (handed forward, not decided here)

1. **The D1 correction's exact shape.** Which bridge rows exist, and what each hands over. Constraint
   from the brief: every non-terminal route names *an exact existing command* plus a self-contained
   payload or a durable inbox address.
2. **The D2 address.** Where a non-PARK, non-skill outcome becomes durable. `inbox/` is tracked
   (`git ls-files inbox/` → `.gitkeep` + archived briefs), so it is a candidate — but `:142`
   currently forbids the command writing there, and reversing that is a behaviour change the review
   should see argued, not assumed.
3. **Whether D4 and D5 are in this stream or deferred.** Both are real and both are cheap, but neither
   is named in the "Required result". D5 drags `docs/agent-tier-table.md` in as a mandatory co-edit
   (`:139`).
4. **The safeguards that must survive** (brief's falsification condition #5): the Step 2 duplicate
   gate (`:44`) and triviality gate (`:45`); the PARK path's mandatory `Severity:` (`:163`) and
   concrete `Review-cycle:` trigger (`:165`); the settled-improvement fast path to `/improve-skill`
   (`:44`, `:214`), which is independently correct per `develop-ai-resource.md:14`.
5. **The complexity-budget cap** at `:128` — an enforcement gate, not advisory. Any new route must not
   silently become a way around it.

---

## LIMITATIONS

- **Frame made no edit to the object under work.** The design of the fix is Shape's; nothing here is
  an approved change. Section 5's "not a material expansion" call is a *judgment*, argued but not
  proved, and is the intended target of this unit's review.
- **`/leverage-idea` was not executed end-to-end.** D2's claim rests on reading Steps 8–10, not on
  observing a run. No output from this command exists anywhere in this tree to inspect
  (`ls audits/working/ | grep -i idea` → none), so there is no empirical instance of the ignored-file
  failure — only the code path that produces it.
- **Consumer scan was repository-scoped to this worktree.** `grep -rn "leverage-idea" --include="*.md" .`
  covered `ai-resources` only. One consumer is known to exist **outside** it and was **not** checked:
  `plans/2026-06-12-leverage-idea-build-plan.md:77` records a `/leverage-idea` row appended to the
  System Owner's `toolkit-relationship.md` in `projects/axcion-ai-system-owner/`. The brief forbids
  sibling-repo *edits*; it does not make a sibling reference cease to exist. If the command's purpose
  statement changes, that row may go stale and this stream cannot fix it.
- **P2 carries a wording imprecision, accepted not resolved.** `develop-ai-resource.md:9` does not
  contain the word "agent". Agent coverage is inferred from `:73` and workspace `CLAUDE.md`. If Shape
  writes a bridge row routing a proposed **agent** to `/develop-ai-resource`, it rests on that
  inference rather than on the command's own enumeration.
- **Working from `44062e4`, one commit behind the declared `BASE: 2b8b350`.** Overlap with the
  intervening commit's stream was checked and is empty (§ 0), but the two streams are live
  concurrently in separate worktrees and nothing prevents a later collision in `logs/decisions.md` or
  `logs/improvement-log.md`, which both streams may append to.
- **The `2026-07-29-prime-minimum-responsibility` stream is open in shared history** and unreachable
  from this unit's authority. It was deliberately not resumed. If it lands changes to `/prime`'s task
  menu, and this stream later touches `improvement-log.md` severity semantics (`:163`), the
  interaction is unexamined.
- **Not checked:** whether any of the 14 consuming projects documents `/leverage-idea` behaviour in
  its own project `CLAUDE.md` or docs. Only the symlink targets were resolved, not the projects'
  prose.

---

# APPENDED 2026-07-29 — ADJUDICATION of review-1, and the unit's outcome

Review-1 transcribed at `8edd216`. Four findings, four dispositions. **Section 5 of this evidence
("Is it in scope at all?") is superseded by MATERIAL 2's disposition below** — the original text is
retained unedited above, because this file is append-only and a superseded judgment that is quietly
deleted cannot be audited.

---

## MATERIAL 1 — "premise P2 was not fully confirmed" → **rejected**

**The finding's observation is correct; its conclusion is not.** Codex is right that
`develop-ai-resource.md:9` omits agent definitions and that `:73`'s `.claude/agents/` search
establishes duplicate-search coverage rather than lifecycle ownership. This evidence had already
recorded that narrower point (P2 row, and the LIMITATIONS bullet above).

What is rejected is the conclusion that this leaves an **authority gap** requiring resolution before
an agent handoff is compliant. The authority exists; it is simply not in the file Codex inspected.
Codex's stated object list names `develop-ai-resource.md`, `docs/work-loop.md` and
`.claude/commands/work-loop.md` — **not** `docs/ai-resource-creation.md`, which is the governing
rules document that workspace `CLAUDE.md` § AI Resource Creation designates as "Full rules".

Evidence that disproves the gap — `grep -n "agent" docs/ai-resource-creation.md`:

- `:3` — "When a session identifies the need for a new or modified AI resource (skill, command,
  **agent definition**, workflow template)…" — agents are in the governed set.
- `:7` — rule 1: "Reusable skills, commands, and **agent definitions** … belong in `ai-resources/`."
- `:15` — rule 4: "**`/develop-ai-resource` is the standard qualification path for creating a new
  durable resource**" — the unqualified noun, governing the set `:3` and `:7` define.
- `:27` — rule 7, the complexity budget: "No new command, **agent**, mandatory stage/gate, or
  permanent always-loaded document may be introduced unless…" — agents are explicitly a gated
  component class.

Plus workspace `CLAUDE.md` § AI Resource Creation: "Shared AI resources (skills, commands, **agent
definitions**, workflow templates) belong in `ai-resources/`. Qualify a **new** durable resource
through `/develop-ai-resource`."

So a new-agent route to `/develop-ai-resource` rests on **four cited lines in the governing rules
document plus an always-loaded workspace rule**, not on inference from a duplicate-search scope.
P2 stands as confirmed.

**Residual true observation, carried forward (not a gap, a documentation inconsistency):**
`develop-ai-resource.md:9`'s own enumeration is narrower than the rule it implements. That is worth
correcting in the command's text, and it is **inside the receiving command's own scope**, so it is
carried in the handoff below rather than parked separately.

---

## MATERIAL 2 — "Frame's execution-boundary judgment conflicts with the contract" → **fixed**

**Accepted in full. Frame's § 5 conclusion was wrong and is corrected here. This is the finding that
changes the unit's outcome.**

Frame argued the output *shape* was unchanged, so the change was a settled correction. That test was
too narrow, and Codex's three-axis test is the correct one. Checking each axis against the live file:

| Axis | Today | Under the Required result | Changed? |
|---|---|---|---|
| **Authority** | "Advisory only: it stops at the implementation plan and applies no change" (`:9`); "Stop here — no execution" (`:144`) | "It must become an evidence-grounded **routing and handoff** command" (brief, Need) | **Yes** |
| **Input domain** | "an idea dump about adding or improving an **Axcíon AI resource**" (`:9`); `/tech-consult` named only as a boundary to stay *away* from (`:11`) | must also accept operating capabilities, project scoping, broad technical needs, and named project/domain decisions | **Yes** |
| **Output contract** | terminal plan; "The command itself never writes to `inbox/`" (`:142`) | lifecycle handoffs, each with "a self-contained payload or **durable inbox address**" | **Yes** |

All three move. `docs/work-loop.md:48` routes out when an existing durable AI artifact is "materially
expanded", and a change to a command's authority, input domain and output contract simultaneously is
that, whatever the file-count. Frame's counter-argument — that only the destination set's correctness
changed — survives for **D1 alone** (row `:210` contradicting `develop-ai-resource.md:13`) and does
not survive for the Required result as a whole. I do not get to substitute the smaller need I could
implement for the larger one the brief actually states.

**Two independent authorities confirm the receiver**, neither cited in Frame's original § 5:

- `develop-ai-resource.md:15` — "**Qualify the improvement here first** when the underlying need,
  scope, mechanism or system fit is materially uncertain or contested, **or when the improvement may
  justify a different or a materially expanded resource**."
- `docs/ai-resource-creation.md:21` — the same rule in the governing document: "Qualify through
  `/develop-ai-resource` first when … the improvement may justify a different or **materially
  expanded** resource."

There is also no competing receiver: `/improve-skill` is skill-only and `/leverage-idea` is a command;
`/tweak` is for ≤1-file cosmetic changes (`leverage-idea.md:45`). No third path exists.

**Whole need, not a component.** `docs/work-loop.md:48` makes the `/develop-ai-resource` hand-off
non-terminal only "when the artifact is a component of a live stream" — i.e. when a capability's
operating outcome and adoption decision stay in the loop. This is a non-capability stream (§ 2); there
is no capability record and no operating outcome held here. The artifact change **is** the whole need.
Therefore the close is **`routed-out`** and the stream closes with it.

**Noted for the record, because it is the same rule biting its author:** this stream's own brief
declares it falsified if "any proposed new durable AI resource bypasses `/develop-ai-resource`". The
expansion of `/leverage-idea` is itself a materially expanded durable AI resource. Implementing it
here would have satisfied the brief's own falsification condition.

---

## MATERIAL 3 — "review requested at the wrong reviewed-route phase" → **out-of-scope**

**Confirmed as a real defect, and it is not this unit's to fix. Owner: `/work-loop` itself —
`.claude/commands/work-loop.md` Step 7 and `docs/work-loop.md:74`.**

The disagreement is verbatim:

- `docs/work-loop.md:74` — reviewed route independent review is "**One Codex review of the result.**"
- `.claude/commands/work-loop.md` Step 7 — "**Reviewed route:** emit the evidence as a chat block for
  Codex" with **no phase carve-out**, while the same step explicitly states that on the challenged
  route "Frame, Build and Land carry none."

A Frame unit produces no result — this unit's own § 5 header says the object was not edited — so the
command routed to Codex an object the contract's reviewed-route definition does not cover. The
command's own preamble governs the outcome: "Where this file and the contract disagree, the contract
wins and the disagreement is a defect to report."

**Accepted without reservation:** this review does **not** count as the reviewed route's result
review. Nothing is left dangling by that, because the stream closes `routed-out` under MATERIAL 2 and
no result will exist for this stream to review.

The object under work here is `leverage-idea.md`; editing `/work-loop`'s own command or contract is
outside the brief's stated scope and would be exactly the incidental edit that scope discipline
forbids. **Durably recorded** at `logs/improvement-log.md` (2026-07-29 entry, Severity `medium`) so
it reaches the Friday cadence rather than dying with this stream's deleted artifacts.

**Judgment stated plainly rather than hidden:** the finding is materially useful, and the Frame review
it questions is what produced MATERIAL 2 — the finding that corrected this unit's conclusion. That is
an argument about the *value* of a Frame review, not about what the contract currently says. The
contract says what it says; changing it is a separate brief.

---

## MINOR 1 — "negative result lacked a positive control" → **fixed**

Correct, and the contract's own standard (`docs/work-loop.md:204`, and `/work-loop` Step 4's
"Negative results need a positive control"). The control is supplied now.

**Control.** The same grep pattern, run over a range known to contain a matching path — the commit
that added `leverage-idea.md`:

```
LI=$(git log --diff-filter=A --format=%H -- .claude/commands/leverage-idea.md | tail -1)   # a142721
git log --name-only --pretty=format:"" ${LI}~1..${LI} \
  | grep -E "leverage-idea|agent-tier-table|develop-ai-resource" | sort -u
```
→ **fired, two paths**: `.claude/commands/leverage-idea.md`,
`audits/risk-checks/2026-07-04-leverage-idea-new-command.md`. The check can detect a match.

**Negative re-run.** `git log --name-only --pretty=format:"" 44062e4..2b8b350 | grep -v "^$" | sort -u`
→ exactly one path, `logs/loop/2026-07-29-prime-minimum-responsibility-build-2.brief.md`. Filtered
through the same pattern → empty. **This matches Codex's independent inspection of the same range
exactly.** The no-overlap conclusion in § 0 now meets the negative-result standard.

---

## OUTCOME

`routed-out` — the unit's whole need is a **material expansion** of an existing durable AI artifact
(`/leverage-idea`), which `docs/work-loop.md:48` § Execution boundary assigns to
`/develop-ai-resource`, corroborated by `develop-ai-resource.md:15` and
`docs/ai-resource-creation.md:21`.

**Owner:** `/develop-ai-resource`.
**Brief handed over:** `inbox/leverage-idea-lifecycle-routing.md` — a **raw** brief by construction. It
carries no `**Mechanism:**` and no `**Evidence:**` (so `/create-skill` would correctly bounce it, per
`create-skill.md:9`), and no `**Capability:**` / `**Settled upstream:**` (this is not a capability
handoff; there is no capability record, and `docs/work-loop.md:194` reserves those labels). Section
headings avoid the bold-label form entirely so that Step 1.0's field-presence routing
(`develop-ai-resource.md:36-40`) cannot misread a heading as a single reserved field and report a
malformed upstream handoff. `/develop-ai-resource` will therefore run Steps 1.1–1.6 in full, which is
correct — the need has had no independent qualification.

**Zero edits were made to the object under work.** `.claude/commands/leverage-idea.md` is byte-identical
to the version Frame inspected and to the version Codex verified by hash.

**What the receiving command inherits** (all five defects stand as findings; the diagnosis is not
discarded with the routing): D1 the bridge matrix bypass, D2 the gitignored-only address, D3 the
AI-resource-only lever menu, D4 the hardcoded `AI_RESOURCES` path, D5 the unpinned `general-purpose`
dispatch (with `docs/agent-tier-table.md:139`'s same-commit roster-move obligation), plus MATERIAL 1's
residual — `develop-ai-resource.md:9`'s enumeration being narrower than the rule it implements.

## LIMITATIONS (appended)

- **The route-out decision rests on a judgment about "materially expanded", which the contract does
  not define operationally.** Codex's three-axis test (authority / input domain / output contract) is
  a reasonable reading and I have adopted it, but it is the reviewer's construction, not the
  contract's text. A different reading could keep D1 alone inside `/work-loop`.
- **D1 in isolation is very likely a settled correction** that `/work-loop` could have implemented —
  `leverage-idea.md:210` factually contradicts `develop-ai-resource.md:13`. It leaves with the rest
  because the brief's need is the whole expansion, not because D1 was judged out of reach. If the
  operator wants only D1 fixed, that is a **new, narrower brief** and a new stream, not a resumption
  of this one.
- **The receiving command has not been run.** Nothing here establishes that `/develop-ai-resource`
  will accept, qualify or build this; it may return "no build", which is a valid outcome of that
  command and not a failure of this routing.
- **`/leverage-idea` was still never executed end-to-end** (carried from the original LIMITATIONS).
  D1–D3 are read from the command text, not observed in a run.
- **The System Owner `toolkit-relationship.md` row remains stale and unfixable from here.** Codex
  inspected it and reports it still describes `/leverage-idea` as producing build proposals and
  feeding `/request-skill`. It lives outside this repository; the brief forbids sibling edits. It is
  named in the handoff brief so the receiving command inherits it rather than rediscovering it.
- **This review is recorded as a Frame review, not as the reviewed route's result review**
  (MATERIAL 3). No result review was ever owed by this stream, since the stream closes without a
  result.

