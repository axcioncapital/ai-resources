# Resource Brief: leverage-idea — lifecycle routing and handoff

Requested: 2026-07-29
Origin: `/work-loop` unit `2026-07-29-leverage-idea-lifecycle-frame`, closed `routed-out`.
Receiving command: `/develop-ai-resource`.

> **This is a raw brief.** It carries no `Mechanism` or `Evidence` field, so `/create-skill` would
> correctly bounce it (`create-skill.md:9`). It is **not** a capability handoff — there is no
> capability record, and it deliberately carries neither of the two reserved upstream labels
> (`docs/work-loop.md:194`). Run Steps 1.1–1.6 in full; the need has had no independent qualification.
> Note the object is a **command**, not a skill, so `/improve-skill` is not an available build engine.

## Why this arrived here rather than being implemented

`/work-loop` opened this as a settled correction to an existing command. Independent review
(Codex, `review-1`) established that the requested change moves three axes of the artifact at once —
its **authority** (advisory plan-producer → routing-and-handoff command), its **input domain**
(workspace-AI-resource ideas only → also operating capabilities, projects, business needs, domain
decisions), and its **output contract** (terminal plan → lifecycle handoffs with durable addresses).
Under `docs/work-loop.md:48` that is a **material expansion of an existing durable AI artifact**, which
belongs here. Corroborated by `develop-ai-resource.md:15` and `docs/ai-resource-creation.md:21`
("Qualify through `/develop-ai-resource` first when … the improvement may justify a different or
materially expanded resource").

## What it must do

`/leverage-idea` turns rough notes into an authoritative implementation plan but does not reliably
route the resulting need to the lifecycle owner. It should become an evidence-grounded routing and
handoff command, where rough notes can resolve to any of: reuse of an existing resource · a bounded
correction · a settled skill improvement · new or materially-expanded AI-resource qualification ·
operating-capability work · project scoping · technical consultation · a named project or domain
owner · PARK.

Every non-terminal route should name **the exact existing command** plus a self-contained payload or a
durable address. Analysis written to an ignored path should be supporting evidence only, never the
sole next-action address.

## Verified defects in the current command

All line numbers are `.claude/commands/leverage-idea.md` at commit `44062e4` (220 lines), verified
against the live file.

- **D1 — the Step 10 bridge matrix routes every non-skill new resource around the qualification
  owner.** `:207-214`. Only `:209` ("New skill") names `/develop-ai-resource`. Row `:210` covers
  "New command / agent / hook / other structural class" and its entire bridge is *"Plan's Gates name
  the `/risk-check` class; the bridge repeats it"* — a risk gate, not qualification. This contradicts
  `develop-ai-resource.md:13` read with `:9`. **This defect alone is arguably a settled correction**
  that `/work-loop` could have taken; it travels with the rest because the stated need is the whole
  expansion.
- **D2 — for most outcomes the only next-action address is gitignored.** Step 9 (`:167-197`) writes
  `audits/working/{DATE}-idea-{SLUG}.md` (`:54`) and calls it "the one operator-facing deliverable"
  (`:169`). `.gitignore:28` ignores that directory (`git check-ignore` exit 0; positive control on
  `docs/work-loop.md` exit 1). Only PARK (`:148` → `logs/improvement-log.md`, tracked) and the
  new-skill path leave any tracked trace, and the latter only once the operator hand-copies the
  embedded brief, since `:142` states "The command itself never writes to `inbox/`."
- **D3 — the lever menu is AI-resource-only.** Step 5 (`:103-107`) offers exactly: extend existing ·
  new command + agent · new CLAUDE.md rule or doc · new hook · park. `/scope-project`,
  `/tech-consult`, `/work-loop` and `/improve-skill`-as-a-route appear nowhere in the file.
  `:11` names `/tech-consult` only as a boundary to stay away from. Meanwhile
  `develop-ai-resource.md:24` already assigns the operating outcome to `/work-loop`, a command
  `leverage-idea.md` never mentions.
- **D4 — hardcoded absolute path.** `:51` pins `AI_RESOURCES` to the main worktree. Four worktrees of
  this repository are live (`git worktree list`), so a run from any other reads and writes main's tree
  — including the PARK append at `:148`.
- **D5 — unpinned `general-purpose` dispatch.** `:57`/`:59` spawn with no tier pin;
  `docs/agent-tier-table.md:122` explains the silent-Haiku failure mode and `:129` names
  `leverage-idea` in the not-yet-retrofitted roster. **`:139` requires that fixing this moves the
  command between roster rows in the same commit** — `docs/agent-tier-table.md` is a mandatory
  co-edit.
- **Residual from review — `develop-ai-resource.md:9`'s own enumeration is narrower than the rule it
  implements.** It lists "skill, reusable prompt, persistent instruction, reference file, command,
  script or hook" and omits **agent definitions**, which `docs/ai-resource-creation.md:3`, `:7`, `:15`,
  `:27` and workspace `CLAUDE.md` § AI Resource Creation all place under this command's authority.
  Worth correcting in this command's own text while it is open.

## Exclusions — constraints carried from the originating brief

- Scope is `leverage-idea.md` plus only the `ai-resources` boundary documents or tier roster whose
  consumer contracts must stay accurate. **No sibling-repo edits.**
- **Do not add a command, agent, mandatory gate, tracker or other durable component.** Note this
  interacts with `docs/ai-resource-creation.md:27` (complexity budget, rule 7) — the expansion must
  clear the budget without introducing a new component.
- **Safeguards that must survive:** the Step 2 duplicate gate (`:44`) and triviality gate (`:45`); the
  PARK path's mandatory `Severity:` (`:163`, machine-consumed by `/prime` Step 3) and its concrete
  `Review-cycle:` trigger (`:165`); the settled-improvement fast path to `/improve-skill` (`:44`,
  `:214`), which is independently correct per `develop-ai-resource.md:14`; and the complexity-budget
  cap at `:128`, which is an enforcement gate, not advisory — no new route may become a way around it.
- The originating brief's falsification conditions, carried forward as acceptance criteria: no
  proposed new durable AI resource may bypass `/develop-ai-resource`; a raw handoff may not carry a
  reserved field; a non-AI idea may not be forced through an AI-resource lever menu; an ignored
  analysis file may not be the only next-action address; and the duplicate, PARK and
  settled-improvement fast paths may not lose their current safeguards.

## Blast radius

`.claude/commands/leverage-idea.md` is symlinked into **14 projects**
(`find projects -name leverage-idea.md -type l` → 14, each resolving to the canonical file). One edit
propagates to all 14 with no per-project action. Consumer contracts that go stale if the command's
authority or stop point changes: `develop-ai-resource.md:22` and `:24`, `create-skill.md:9`,
`request-skill.md:65`, `docs/agent-tier-table.md:129`.

**Known stale reference outside this repository, not fixable from the originating stream:**
`projects/axcion-ai-system-owner/.../toolkit-relationship.md` still describes `/leverage-idea` as
producing build proposals and feeding `/request-skill` (inspected by the reviewer). It will need
updating wherever this work lands.

## Prior art reviewed

- `plans/2026-06-12-leverage-idea-build-plan.md` — the original build plan, status "IMPLEMENTED &
  COMMITTED", including the `/risk-check` GO at `audits/risk-checks/2026-07-04-leverage-idea-new-command.md`.
- `.claude/commands/develop-ai-resource.md`, `create-skill.md`, `improve-skill.md`, `request-skill.md`,
  `tweak.md` — no existing command covers a materially expanded `/leverage-idea`; `/improve-skill` is
  skill-only and `/tweak` is capped at ≤1-file cosmetic changes.

## Provenance

Full Frame diagnosis, premise verification (six premises, all confirmed, with positive controls),
route classification and the review that redirected this work are recoverable from git — see the
`logs/decisions.md` entry dated 2026-07-29 for the commit SHA. Artifacts were deleted at stream close
per `docs/work-loop.md` § Artifacts.
