# Work Loop v2 MVP — Step 4: the slice plan

**Playbook step:** 4 — slice the build. **Status:** draft for the operator to glance at.

**What this is.** Three slices, each a complete observable behaviour, each built in its own fresh
implementation session. This note plus [`work-loop-v2-executable-core-v0.1.md`](work-loop-v2-executable-core-v0.1.md)
are the **only** planning documents a Step 5 session loads (Playbook `:129`). Anything a Step 5
session needs to know and cannot find in those two files is missing from this note.

**No rule from the core is restated here.** Behaviours link to it.

---

## How to read a behaviour

Each row gives three things, and needs all three:

| Column | Why it is there |
|---|---|
| **Behaviour** | The observable outcome. Not a description of the code. |
| **Failing case** | The case constructed **first**, which must fail before the work and pass after. A behaviour with no constructible failing case is not an acceptance behaviour and does not belong here. |
| **Traces to** | The destination behaviour or core section it comes from. A row with no trace is scope creep and gets cut. |

Destination behaviours are Proposal § 4 (`:52-58`). Core sections are the executable core.

---

## Slice 1 — the core round trip

One integration seam, deliberately kept as one slice (Proposal `:83`).

| # | Behaviour | Failing case to construct | Traces to |
|---|---|---|---|
| **1.1** | Codex, invoked explicitly as `$<name>`, writes a brief for one bounded unit into `logs/work-loop/{task-id}.md` with `turn: claude`. Claude commits the file. | Run it in a checkout where `logs/work-loop/` does not exist. **Pass:** the folder is created and used. **Fail:** it falls back to `logs/loop/`. Also assert `git log -- logs/loop/` gains nothing — v1 still scans that folder. | Destination 1 **as amended** (README § "Decisions taken after v0.4"); core § 4 *Where it lives* |
| **1.2** | Claude checks each claim in the brief against the live repository and writes down what it inspected. If a claim is false: the finding goes into the state file, `turn: codex`, commit, stop. | Two runs off one brief. **(a)** all claims true → the inspection record must still appear (an absence claim must say what was searched). **(b)** one claim deliberately false — a field the brief says exists and does not → `git diff` over **every** file the brief named must be empty. | Destination 2; core § 6 rules 1 and 3; § 7 *Hand back to Codex*; standard § 8 |
| **1.3** | Claude implements the unit, then writes the latest material result and an evidence pointer into the state file, sets `turn: codex`, commits. | Build the evidence's own failing case first and show it failing, then passing. **Fail:** an evidence line that would read the same whether or not the work happened. | Destination 3; core § 6 rule 5 |
| **1.4** | Codex reads the result, assesses it, and closes. The state file is then reduced to the four closing fields. | Inspect the closed file. **Fail:** any of the five active fields — brief, blocker, next action — survives closure. | Destination 4; core § 4 *When the task closes* |

### The predefined split point

If Slice 1 does not fit one clean implementation session, split it at the **Codex side / Claude
side** boundary (Proposal `:83`, Playbook `:115`). The session boundary decides, not ideology.

- **Claude side = 1.2 and 1.3. Build this half first.** It can be exercised against a hand-written
  state file used as a fixture, so it does not wait on the Codex resource. The reverse is not true:
  the Codex side has nothing to hand off to until Claude's side reads. 1.2(b) is also the behaviour
  Proposal `:91` names in Phase 2's exit condition, so it should not be the half that gets deferred.
- **Codex side = 1.1 and 1.4.** Second session.
- **Trigger to split:** the Claude side is green and committed, and the Codex side has not started.
  Stop there and take the Codex side as its own session. Do not carry a half-built second half.

---

## Slice 2 — continuity and correction

| # | Behaviour | Failing case to construct | Traces to |
|---|---|---|---|
| **2.1** | A brand-new Claude session with no conversational memory reads the state file and produces the correct next action. | Give the fresh session the command and the repository and nothing else. **Fail:** it needs any fact that exists only in the previous chat. | Destination 5; core § 3 step 1; standard § 8 |
| **2.2** | A stale or foreign state file is rejected read-only, before anything is changed. | A state file whose `task` does not match the task being run. **Pass:** reported, nothing mutated. **Fail:** any write happens before the rejection. | Core § 6 rule 2; § 4 (`task` is what rule 2 checks identity against); standard § 8 |
| **2.3** | Exactly one bounded correction. The assessment names findings A and B; the correction touches A and B only; the closure check asks only whether A and B are resolved and whether the correction broke something. | Seed the closure check with a newly noticed problem C. **Pass:** C is recorded as a deferral in the closing record. **Fail:** C opens a second correction round. | Core § 3 *Correcting once*; destination 4; mission non-negotiable 3 |
| **2.4** | When the correction was not enough, one option off the § 3 menu is chosen **once**, on value and risk. A choice that is really about accepting risk goes to the operator. | A correction that leaves a finding partly unresolved. **Fail:** a third round starts, or the choice is made on a round counter rather than on value and risk. | Core § 3 *If the correction was not enough*; § 7 *Stop for the operator* |

**2.2 is the first real exercise of the file-identity field.** The Step 2 prototype could not test it
— a stale leftover cannot arise in a single clean round trip (`step-2-transport-seam-conclusions.md`
§ 5). Treat the field as unproven until this behaviour passes.

---

## Slice 3 — admission discipline

| # | Behaviour | Failing case to construct | Traces to |
|---|---|---|---|
| **3.1** | The admission test routes correctly: a small reversible fix is done as Direct Work, said out loud, with no state file; entering the loop needs a named reason, written into the state file when the task opens. | **(a)** a two-file reversible fix request → assert `logs/work-loop/` gains no file. **(b)** a request to open a task whose only reason is "this feels significant" → must be refused. | Destination 6; core § 2; standard § 8 |
| **3.2** | Work already in the loop that turns out smaller than assumed de-escalates: said out loud, what was learned recorded, task closed, work finished directly. | A task whose first unit discovers the problem is a one-file fix. **Fail:** the task stays open in the loop because it started there. | Core § 2 *De-escalating*; Proposal § 5 Phase 4 regression set (`:107`) |
| **3.3** | A tempting adjacent improvement noticed **mid-unit** is recorded as a deferral and not implemented. | Place a genuinely attractive adjacent improvement inside the unit's working area. **Fail:** it is implemented, or it silently disappears with no record. | Core § 5 (*deferral*), § 6 rule 4; standard § 8 |
| **3.4** | At assessment, a pilot-quality result with its limitations written down is **closed**, not corrected. | A result that is good enough and carries two named limitations. **Fail:** assessment opens a correction to improve it. | Core § 3 *good enough, proceed*; Proposal `:85` |

**3.3 and 2.3 are different moments and both are needed.** 3.3 is scope discipline *during* a unit;
2.3 is the closure check refusing to become a second round. Building one does not cover the other.

---

## Two obligations that are not behaviours

Neither is an acceptance behaviour, and both will be invisible to a Step 5 session unless they are
written here.

1. **The Codex resource's folder needs its own `.gitignore` re-include — exactly one line,
   `!.agents/skills/<name>/`.** Without it the resource works on this machine and does not exist in
   a fresh clone. The three-rule ladder above it already exists, so one line is enough; this was
   proven by before/after with a sibling control (`step-2-transport-seam-conclusions.md` § 3, and
   `step-1-codex-packaging-findings.md` § 1). This is the same failure class as unversioned hook
   wiring already logged in this repo.
2. **Slice 1 assumes explicit `$name` invocation, and must.** Implicit description-matching cannot
   be relied on: Codex caps the always-present skills list at 8,000 characters and the runtime
   already carries 12,963, so a description may be shortened or dropped before it is ever matched
   (`step-1-codex-packaging-findings.md` § 2). Whether `$name` itself is reliable under that
   over-cap budget is **still untested** (`step-2-transport-seam-conclusions.md` § 4, premise 3). If
   1.1 fails at invocation, check that first — and it is a finding for the operator, not something
   to design around inside the slice.

---

## The Phase 4 regression set, reconciled

Proposal `:107` names eight behaviours to demonstrate once each in Phase 4. Six are built by a
slice. Two are not built by anything, and that is correct.

| Regression item | Built by |
|---|---|
| A small fix stays Direct Work | 3.1 |
| A Standard task survives full session replacement on the state file alone | 2.1 |
| A false premise gets caught | 1.2 |
| A disclosed limitation closes a task without another cycle | 3.4, with 2.4's *accept it as a written limitation* |
| A task de-escalates when discovery shows the problem is smaller than assumed | 3.2 |
| A stale or foreign task-state file is rejected before any mutation | 2.2 |
| A full successful task produces less process text than implementation and evidence | **Nothing builds it.** It is measured over a finished task in Phase 4, and it is a standing off-mission signal throughout. |
| A change to the reviewed candidate after its review renders that review stale | **Nothing builds it.** A property of the review protocol (Proposal Decision 9, frozen findings), not of the artifacts. Step 6 owns it. |

Phase 4's conditional check — that a specialist workflow owned its own method without the loop
layering a second review or state system over it — stays conditional. Do not manufacture a pilot
unit to test it (Proposal `:107`; core § 1, fourth limit).

---

## What this note does not cover

- **Destination behaviour 7** — two real CRM / Email OS units completed and judged useful. That is
  the Phase 3 pilot, not a slice.
- **Test fixtures and state-file material.** Built inside each Step 5 session against the live
  repository, where inspecting current conventions costs nothing (Playbook `:129`). Drafting them
  here would be planning work paid for twice.
- **Which files each slice creates.** Step 5 inspects the repository and decides; local decisions
  stay local (Playbook `:131`).
