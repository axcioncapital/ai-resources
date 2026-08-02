FIXTURE — not a project artifact; seeded for CE-9. Carries no authority.

# CE-9 fresh-session recovery — the measurement instrument

**Built by:** Claude, 2026-08-02, Session S1 of the Context Engineering implementation plan
(`../context-engineering-implementation-plan-v0.1.md`, Phase 1). **Observer:** the operator, who re-runs
the two greps in §5 before authorising S2.

**What this file is.** The seeded scenario that makes CE-9's fresh-session recovery claim falsifiable. It
is not a proof of CE-9 — no behaviour is exercised here. S1 builds the ruler; S5 does the measuring, and
the same scenario becomes regression case R-3 (plan §7.1, §7.5).

---

## 1. What CE-9 asks, and why an instrument is needed first

CE-9's fresh-session clause requires that a fresh Codex thread recover seven things from durable sources
rather than from conversational memory — among them **the next justified unit**. The specification then
adds the requirement that makes it measurable, and that is the whole reason this file exists:

> *"paired with a memory-only control: the same request answered without opening the durable sources. If
> the two briefs are indistinguishable, the trial has proved nothing about recovery — it has only shown
> that conversational memory happened to be sufficient. The case must therefore be constructed so the
> durable sources contain at least one **material fact the conversation does not carry**, and the
> distinguishing evidence is whether that fact reaches the brief."*
> — spec §6, CE-9, *Evidence — and it must be able to fail*

The pilot showed this is the hard part: Unit 3's fresh-session continuation scored *"yes, qualified"*
only because `/prime` had already loaded the prior session note before the state file was opened, so a
clean proof *"is not available through the normal orientation path"* (FP-11). An instrument that does not
control for preloaded context inherits that ambiguity, and a trial run on it proves nothing.

## 2. The seeded situation

A fictional project, **Harbourview** — a marina booking system. Fictional so that no reader can confuse
the seeded material for Axcíon work, and so that no thread can recover any of it from general knowledge.

Three seeded durable sources, one per permitted category in spec §5.7, all under
`fixtures/ce-9/`:

| Spec §5.7 category | File | What it holds |
|---|---|---|
| 2 · One canonical project plan | `fixtures/ce-9/project-plan.md` | Approved plan of record. Phase 2's build items in settled order, and settled decision **SD-3** |
| 3 · The existing current-state interface | `fixtures/ce-9/task-state.md` | Phase, latest material result, the live blocker, and a deliberately undecided next action |
| 1 · Operator source material (optional) | `fixtures/ce-9/operator-source-note.md` | Raw operator notes. No decisions, no requirements, and **no discriminator** |

The operator's continuation request lives in `fixtures/ce-9/operator-request.md`, between the markers
`<<<REQUEST-BEGIN>>>` and `<<<REQUEST-END>>>`. It is short and natural:

> Can we pick Harbourview back up? I've got an hour this afternoon.
> What's the next unit — go ahead and brief it.

## 3. The discriminator

**The discriminator is this sentence, seeded verbatim in `fixtures/ce-9/task-state.md` and nowhere else
in the seeded sources:**

> the berth-availability API returns local time with no UTC offset, so every confirmation sent since
> 2026-06-14 states the wrong arrival hour

**Why it is material to the next justified unit — not merely interesting.** The plan's Phase 2 lists the
booking-confirmation email template as the next build item. The plan also carries **SD-3**: *a defect
that has already produced incorrect operator-visible output takes priority over the next build item in
the phase, and the corrective unit must also identify the records already affected.* The discriminator is
the fact that turns SD-3 from dormant into decisive. Recover it, and the next justified unit is the
corrective one — fix the offset handling **and** identify the confirmations sent since 2026-06-14. Miss
it, and the next justified unit is the email template, which is the plan's static order and the wrong
answer.

So the discriminator does not just add detail to a brief. It changes which unit the brief is for. That is
the level at which CE-9's recovery claim is worth measuring, and it is why `task-state.md` records its
next action as undecided on purpose: the answer exists only when the blocker is read against the plan,
which is exactly the recovery CE-9 describes.

**Why a real operator would naturally omit it.** The whole premise of durable state is that the operator
does not restate what the state file already holds. "What's the next unit" is how a continuation request
is actually written. Nothing about the omission is contrived — the request is short because the operator
expects the sources to carry the rest.

## 4. What each run receives, and how the control is kept blind

| | Memory-only control | Source-opened run |
|---|---|---|
| The request text between the markers | **Yes** | Yes |
| `fixtures/ce-9/project-plan.md` | **No** | Yes — path given, thread opens it |
| `fixtures/ce-9/task-state.md` | **No** | Yes — path given, thread opens it |
| `fixtures/ce-9/operator-source-note.md` | **No** | Yes — path given, thread opens it |
| This scenario file | **No** | **No** |
| Any summary, session note, or prior-thread context | **No** | **No** |

Four rules make the blindness real rather than asserted:

1. **The control is a fresh thread with no prior-session note loaded.** This is the FP-11 control. A
   thread that has been oriented by any preloaded summary is not a control and its run is discarded.
2. **The control is handed the request text only** — the block between the markers, pasted. Not the file
   path, not the fixtures directory, not this file.
3. **This scenario file is given to neither run.** It states the discriminator in §3, so a thread that
   read it would pass by reading the answer key. The operator holds it; the threads do not see it.
4. **The source-opened run receives exactly three additional things**: the three fixture paths in the
   table above. Nothing else — no summary of them, and no hint about the blocker.

## 5. The two greps — the evidence, and how it can fail

Both commands are run from the repository root, `ai-resources/`. Both are mechanical; the operator
re-runs them before authorising S2.

**Grep 1 — the discriminator is present in the seeded durable sources.** Must find it.

```
grep -rnF "the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour" plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/
```

Expected: exactly one hit, in `task-state.md`. Exit status `0`.

**Grep 2 — the discriminator is absent from the request.** Must find nothing.

```
awk '/^<<<REQUEST-BEGIN>>>$/{f=1;next} /^<<<REQUEST-END>>>$/{f=0} f' plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-request.md | grep -F "the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour"
```

Expected: no output. Exit status `1`.

**Why grep 2 is capable of failing, and not merely capable of passing.** The `awk` extracts only the
lines between the two markers and pipes that alone to `grep`. It therefore searches the request and
nothing else — not this file's prose, not the fixture notice, not the marker lines, not the surrounding
explanation in `operator-request.md`. Paste the discriminator sentence between the markers and grep 2
returns the line and exits `0`. That is the failing case, and it is the failing case that matters: if the
discriminator ever leaks into the request, the instrument is broken and the session that used it has
failed rather than succeeded (plan §7, S1 · *Evidence capable of failing*).

## 6. How a run is scored

The distinguishing evidence is **whether the discriminator's substance reaches the brief** — not whether
the sentence is quoted.

- **Source-opened run passes** if its brief names the offset defect and the confirmations sent since
  2026-06-14, and its unit is the corrective one rather than the email template.
- **Control run** has two legitimate outcomes, and both are recorded as given: it drafts a brief that
  cannot contain the discriminator, or it escalates for context because it has none. Either way it must
  not reach the corrective unit.
- **The trial proves nothing** if the two are indistinguishable — spec §6, CE-9. That is a real possible
  outcome and is reported as such, not worked around.

**A stated weakness of this control, recorded rather than hidden.** A control given only the request is
blind enough that it may simply ask for context, which discriminates but weakly — it shows the sources
were *needed*, not that they were *used well*. The stronger control, one holding a plausible but
discriminator-free summary, is not constructible here: S1's own blindness requirement forbids handing the
control any preloaded summary. The limitation belongs to the instrument and is inherited by S5.

## 7. What this scenario deliberately does not seed

S1's one job is the material fact and the blind control. Regression case R-3 also carries a false
repository claim, an absence claim, and one irrelevant repository area (plan §7.1). **Those three are
not seeded here** — they belong to Slice C at S5, which extends this scenario in place. A later reader
must not treat this file as a complete R-3.

No candidate file is built by S1. `trials/candidate/SKILL.md` is S2's, and creating it here would have
contaminated Phase 2's red runs (plan §4.4).

## 8. File-layout note

Fixtures sit in `fixtures/ce-9/` rather than in `regression/`, which plan §7.5 names as the surviving
home. The relocation is S12's, at the point the regression set is assembled; splitting the instrument
across two trees now would separate the scenario from its own fixtures for no gain. A locally-decided
reversible detail, noted rather than assumed (plan §10).

Every file in this instrument opens with the `FIXTURE —` notice required by plan §4.4, and all of them
sit under `trials/`, which no project discovery path reaches — not `plans/` root, not any
`logs/work-loop/` directory, and nowhere spec §5.7's three durable categories are looked for.
