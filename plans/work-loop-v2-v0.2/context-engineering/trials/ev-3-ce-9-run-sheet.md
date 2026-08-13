# EV-3 / CE-9 — run sheet for one paired trial

**What this is.** The operator-facing procedure for running **one** EV-3 trial against the CE-9
measurement instrument: one memory-only control run and one source-opened run, scored as a pair.

**What this is not.** It is not the instrument — that is
[`ce-9-recovery-scenario.md`](ce-9-recovery-scenario.md), which defines the seeded situation, the
discriminator, the blindness rules, the two mechanical checks and the scoring rule. This sheet
operationalises that file and changes nothing in it. Where the two disagree, the instrument wins and the
disagreement is a finding, not something to resolve by editing either file.

> **⚠ This sheet is answer-key material. It goes to neither run.**
> Like the instrument, it states the discriminator verbatim (§ 2, § 5). A thread that reads this file
> passes by reading the answer. Keep it open on your side only.

**Lifecycle boundary.** This sheet prepares **one trial**. One trial is one observation, not a
reliability claim. It authorises nothing else: not the six-scenario eval pack, not adoption of any eval
capability, not unattended execution, and no change to any carrier, dispatcher, Work Loop skill, command
or core. Those remain operator decisions and are outside this sheet entirely.

---

## 1. What you need before you start

- This repository checkout, on any branch, with a clean `fixtures/ce-9/` directory.
- The ability to open **two separate fresh Codex threads**. "Fresh" is load-bearing — see § 3.
- **An empty directory outside this repository**, for Run A to work in. Create it now:

  ```
  mkdir -p ~/ce-9-control && ls -A ~/ce-9-control
  ```

  Expect **no output** — an empty directory. Run A is launched from there and never from the checkout,
  for the reason in § 3a.
- About the length of two ordinary briefing exchanges.

**Where each thing runs.** Every command in § 2 runs from the repository root. **Run B** also runs from
the repository root, because it must be able to open the three paths it is given. **Run A runs from the
empty directory above** and must never be launched from the checkout.

---

## 2. Preflight — five steps, in order

Do not launch either thread until all five pass.

**Step 1 — record where you are.** Both values go into the result later.

```
git rev-parse --abbrev-ref HEAD
git rev-parse HEAD
```

**Step 2 — confirm the fixtures are unmodified.** Expect **no output**.

```
git status --short plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/
```

Any output means the seeded material has been edited. Stop and find out why before going further — a
modified fixture set measures something other than CE-9.

**Step 3 — presence check.** The discriminator must be in the seeded sources. Expect **exit `0`** and
**exactly one hit**, in `task-state.md`.

```
grep -rnF "the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour" plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/
```

**Step 4 — absence check.** The discriminator must **not** be inside the operator's request. Expect **no
output** and **exit `1`**.

```
awk '/^<<<REQUEST-BEGIN>>>$/{f=1;next} /^<<<REQUEST-END>>>$/{f=0} f' plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-request.md | grep -F "the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour"
```

**Both commands are the instrument's own, quoted from `ce-9-recovery-scenario.md` § 5.** Read the exit
status, not just the screen: `grep` prints nothing whether it found nothing or was pointed at the wrong
file, and only the exit status separates those two.

**Step 5 — the stop rule that makes step 4 mean something.**

> **If step 4 exits `0`, the discriminator has leaked into the request. The instrument is broken, and any
> trial that used it has *failed* — it has not succeeded.** Do not work around it, and do not re-run to
> get a better number. Fix the leak, then start the preflight again from step 1.

### 2a. Optional — prove to yourself that step 4 can fail

Step 4 is only worth trusting if it is capable of failing. This shows it is. It runs on a **copy outside
the repository**; the committed fixtures are never touched.

```
S=$(mktemp -d)
D="the berth-availability API returns local time with no UTC offset, so every confirmation sent since 2026-06-14 states the wrong arrival hour"
cp -R plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9 "$S/"
awk -v d="$D" '/^<<<REQUEST-END>>>$/{print d} {print}' "$S/ce-9/operator-request.md" > "$S/req" && cp "$S/req" "$S/ce-9/operator-request.md"
awk '/^<<<REQUEST-BEGIN>>>$/{f=1;next} /^<<<REQUEST-END>>>$/{f=0} f' "$S/ce-9/operator-request.md" | grep -F "$D"; echo "exit=$?"
```

Expect the discriminator line to print and **`exit=0`** — the mutant state step 5 refuses. Then confirm
your real fixtures are still clean with step 2, and delete `$S`.

---

## 3. Launch — two fresh threads, never one

Run the **control first**. Once you have seen the source-opened answer it becomes hard to read the
control fairly, and this order removes that bias.

Five rules. The first four are the instrument's § 4; the fifth is what makes the control's blindness a
property of where it runs rather than a promise about what you typed:

1. **Each run is a fresh Codex thread with no prior-session note loaded.** A thread already oriented by a
   summary is not a control, and its run is discarded rather than scored.
2. **Never run both in the same thread.** The second would inherit the first.
3. **Neither run receives `ce-9-recovery-scenario.md`, and neither receives this sheet.** Both state the
   answer.
4. **Neither run receives any summary, session note or transcript context** — including your own account
   of what Harbourview is.
5. **Run A is launched from the empty directory in § 1, never from this checkout**, so the durable
   Harbourview sources are not reachable from where it is working. Withholding the paths is not enough
   on its own: a thread started inside the checkout can search for "Harbourview" and find the fixtures
   without being told where they are, and a control that reads the sources is not a memory-only control.

### 3a. Run A — the memory-only control

**Launch it from the empty directory, not the checkout.**

```
cd ~/ce-9-control
```

Then paste **exactly this and nothing else**. No paths, no directory, no file.

```
Can we pick Harbourview back up? I've got an hour this afternoon.
What's the next unit — go ahead and brief it.
```

**Before you score it, confirm the isolation held.** Read back what Run A actually did and check three
things: it worked in `~/ce-9-control`; it opened, listed or searched no file under this repository; and
it reached no Harbourview source by any other route. Record that confirmation — § 4 requires it.

> **If Run A reached any Harbourview source, or any part of this checkout, the trial is FAIL** — a
> blindness breach, with the route it took written down. Its output is not scored on its merits, and the
> pair is not re-run to obtain a cleaner answer.

### 3b. Run B — the source-opened run

**Launch it from the repository root**, so the three paths resolve.

Paste **exactly this and nothing else** — the same request, plus the three source paths and nothing more.
No introducing sentence, no summary of them, and no hint about the blocker.

```
Can we pick Harbourview back up? I've got an hour this afternoon.
What's the next unit — go ahead and brief it.

plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/project-plan.md
plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/task-state.md
plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-source-note.md
```

### 3c. If a thread asks you a question

**Answer no substantive question in either thread, and write down what was asked.** The question is
data. A control that asks for context is a legitimate control outcome (instrument § 6), and a
source-opened run that asks you for the blocker instead of opening the paths it was given is a finding
worth recording. Supplying the answer to either would end the trial, not rescue it.

---

## 4. Capture

For **each** run, keep:

- the thread identifier and the date;
- the produced brief — verbatim if short, otherwise the passages that decide § 5 quoted verbatim, plus an
  exact pointer to the rest;
- anything the thread asked you (§ 3c);
- whether the thread was fresh and what, if anything, was already in its context;
- **the directory it ran in.** For Run A, also the isolation confirmation from § 3a — that it worked in
  `~/ce-9-control` and reached no file in this checkout and no Harbourview source by any route. This is a
  recorded observation, not an assumption: a trial whose control isolation was never checked has not
  established that the control was blind.

**Do not create a transcript file, a results log or a runner record in this repository.** The result
destination is § 6.

---

## 5. Scoring — two layers

> **Answer key below.** Score after both runs are captured.

### Layer A — discriminator recovery

The instrument's own rule (`ce-9-recovery-scenario.md` § 6): what matters is whether the discriminator's
**substance** reaches the brief, not whether the sentence is quoted.

| | Required |
|---|---|
| **Run B (source-opened)** | The brief names **the offset defect** and **the confirmations sent since 2026-06-14**, and its unit is **the corrective one** — fix the offset handling *and* identify the affected confirmations — **not** the booking-confirmation email template. |
| **Run A (control)** | Must **not** reach the corrective unit. Two outcomes are both legitimate and both recorded as given: it drafts a brief that cannot contain the discriminator (typically the email template, the plan's static next item), or it escalates for context because it has none. |

**Why the email template is the wrong answer.** The plan's Phase 2 lists it first. Settled decision
**SD-3** overrides that static order once a defect has produced operator-visible output — which is
exactly what the discriminator establishes. The discriminator does not add colour to the brief; it
changes which unit the brief is for.

### Layer B — continuation integrity

Layer A alone shows one fact travelled. Layer B asks whether the recovered brief is *correct*. Its ground
is the CE-9 clause in the approved specification (`../../context-engineering-spec-v0.1.md` § 6, CE-9 —
*fresh-session recovery*), which requires a fresh thread to recover the operator request, the governing
plan, applicable approved workflows, authoritative current state, material settled decisions, unresolved
blockers and the next justified unit. Three of the seven are seeded here, so check Run B's brief against
these five, each verifiable in the fixtures:

| # | What the brief must get right | Where it is |
|---|---|---|
| 1 | **Objective** — Harbourview takes berth bookings online and confirms them by email, without staff re-keying. | `project-plan.md` § Objective |
| 2 | **Current state** — Phase 2, confirmation and change handling; Unit 4 closed 2026-06-21; no unit open. | `task-state.md` §§ Current phase and unit, Latest material result |
| 3 | **Settled decision** — SD-3, and that it governs the ordering here. (SD-4, local time never UTC, is supporting.) | `project-plan.md` § Settled decisions |
| 4 | **Live blocker** — the wrong arrival hour is unfixed; no count of affected bookings taken; no guest contacted. | `task-state.md` § Unresolved blocker |
| 5 | **Next justified unit** — the corrective unit, including identifying the affected records, because SD-3 requires a fix that leaves bad output standing to be treated as incomplete. | derived: `task-state.md` blocker read against `project-plan.md` SD-3 |

Item 5 is deliberately *not* written down anywhere in the fixtures — `task-state.md` records its next
action as undecided on purpose. It exists only when the blocker is read against the plan, which is the
recovery being measured.

### The verdict

**There are three verdicts and no fourth.** Every trial ends PASS, PARTIAL or FAIL.

| Verdict | When |
|---|---|
| **PASS** | Layer A holds for both runs **and** Layer B holds for Run B. |
| **PARTIAL** | Layer A holds, Layer B does not — the fact travelled, the brief is wrong or thin. |
| **FAIL** | Any of: the discriminator does not reach Run B; Run A reaches the corrective unit; the two outputs are indistinguishable; **preflight step 4 exited `0`** — an invalid instrument; **either thread was not fresh, or received more than § 3 allows, or Run A reached this checkout or any Harbourview source** — a blindness breach. |

**A contaminated run is discarded; the trial is still recorded FAIL.** These two are separate acts and
both are required. The affected run's *output* is not scored on its merits — a brief produced by a thread
that had the answer tells you nothing, and reading it anyway would launder a broken run into a
measurement. But the *paired trial* is not thereby unrecorded: it goes down as FAIL, naming the precise
reason — which check failed, or which blindness rule broke and how. Silence is not a verdict, and neither
is "not a trial".

**Never re-run a FAIL to obtain a better number.** Fix the cause first — the leak, the freshness, the
isolation — and only then start a new trial, recorded as its own.

**Indistinguishable outputs are a real result, and they are reported, not repaired.** Two briefs that
cannot be told apart prove nothing about recovery — only that conversational memory happened to be
enough. Record it as FAIL with that reason.

**One known weakness of this control, inherited from the instrument (§ 6).** A control given only the
request may simply ask for context. That discriminates, but weakly: it shows the sources were *needed*,
not that they were *used well*. The stronger control — one holding a plausible summary with the
discriminator removed — is not constructible without breaking the blindness rule. Note it in the result
rather than treating a context-escalating control as a strong pass.

---

## 6. Where the result goes

**Into this task's existing Work Loop state file**, `logs/work-loop/eval-v0-3-restart.md`, under
`## Latest result` — and eventually into that task's closing record. That is the whole destination.

**No new durable artifact is created for this trial**: no results database, no runner log, no
append-only eval schema, no second state file. If a later decision adopts a standing eval, that decision
brings its own home with it; this trial does not pre-empt it.

Record exactly these nine things, and nothing more:

1. Date, and the HEAD from preflight step 1.
2. Preflight outcomes — step 3 exit status and hit location, step 4 exit status.
3. Run A: thread identifier, freshness confirmed, what it received, and the § 3a isolation confirmation —
   the directory it ran in, and that it reached no file in this checkout and no Harbourview source.
4. Run B: thread identifier, freshness confirmed, what it received.
5. The captured outputs, or exact pointers to them (§ 4).
6. Layer A outcome for both runs.
7. Layer B outcome for Run B, item by item against § 5's five rows.
8. The verdict — PASS, PARTIAL or FAIL.
9. For any non-pass, the reason, in one or two plain sentences. Where the cause was an invalid instrument
   or a blindness breach, name which check failed or which rule broke, and say that the affected run's
   output was discarded rather than scored.

---

## 7. When to stop rather than continue

Stop, record what happened, and hand back rather than pressing on if:

- preflight step 4 exits `0` — the instrument is broken (§ 2 step 5). Record the trial **FAIL**, invalid
  instrument;
- either thread turns out not to have been fresh, or received more than § 3 permits, or Run A reached
  this checkout or any Harbourview source — that run's output is discarded rather than scored, and the
  trial is recorded **FAIL**, blindness breach, naming the rule that broke;
- you cannot run a thread without giving it something § 3 forbids;
- the pair comes out indistinguishable — that is **FAIL**, and re-running for a better result would be
  choosing the answer;
- finishing would require creating a second durable artifact, or a decision about adoption or the wider
  eval pack. Both are the operator's, and neither is inside this sheet.
