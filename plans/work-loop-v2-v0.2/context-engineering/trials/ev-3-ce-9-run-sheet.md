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

**What is not a result.** Two earlier Codex turns exist in this task's record and **neither is an EV-3
result**. The Run A attempt of 2026-08-13 reached the Harbourview sources through the account's Google
Drive connector; it is recorded **FAIL — blindness breach**, its output was discarded rather than
scored, and it does not become a trial by being re-read. The operator-approved diagnostic turn of
2026-08-14 was run to find out whether the connector could be closed at all; it answered a question
about the instrument, not about recovery, and its answer is discarded. Both are evidence about the
instrument. Neither may be counted, quoted or scored as Run A.

**Lifecycle boundary.** This sheet prepares **one trial**. One trial is one observation, not a
reliability claim. It authorises nothing else: not the six-scenario eval pack, not adoption of any eval
capability, not unattended execution, and no change to any carrier, dispatcher, Work Loop skill, command
or core. Those remain operator decisions and are outside this sheet entirely.

---

## 1. What you need before you start

- This repository checkout, on any branch, with a clean `fixtures/ce-9/` directory.
- The ability to open **two separate fresh Codex threads**. "Fresh" is load-bearing — see § 3.
- **A read boundary for Run A**, so the control cannot reach the Harbourview sources even if it goes
  looking for them. It is three things together — an empty working directory, a Codex home with no
  session history, and a sandbox profile that denies reads. Build all three now.

  **A fresh control home per trial, never a reused one.** Give each trial its own directory, named so
  it cannot collide with an earlier one:

  ```
  CE9_CONTROL="$HOME/ce-9-control-$(date -u +%Y%m%dT%H%M%SZ)"
  mkdir -p "$CE9_CONTROL/.codex-home"
  cp ~/.codex/auth.json ~/.codex/config.toml "$CE9_CONTROL/.codex-home/"
  ls -A "$CE9_CONTROL"
  ls -A "$CE9_CONTROL/.codex-home"
  ```

  The first listing must show **`.codex-home` and nothing else**. The second must show **`auth.json`
  and `config.toml` and nothing else**. Those two files are all Codex needs to start; everything else a
  Codex home accumulates is history, and history is what a control must not have.

  **Never delete or empty an earlier control home to make a fresh one.** An earlier home holds the
  transcript of an earlier run, and that transcript is the evidence for whatever that run was recorded
  as. A new directory costs nothing; a deleted one cannot be got back. Leave old homes where they are —
  the boundary below denies them anyway.

  **Freshness is checked, not assumed.** Expect **no output**. Any hit means the home is carrying state
  from a previous run and this is not a control.

  ```
  ls -A "$CE9_CONTROL/.codex-home" | grep -vxE 'auth\.json|config\.toml'
  ```

  Named plainly, the things that must not be there: `sessions/` (past transcripts, including any earlier
  Run A), `history.jsonl` and `thread_history_*.sqlite` (past prompts and threads), and `cache/` —
  which in this account holds `codex_apps_tools` and `codex_app_directory`, the synced record of which
  connectors the account has. A home carrying those starts a run that already knows things.

  ```
  CE9_PROFILE=$(cat <<PROFILE
  (version 1)
  (allow default)
  (deny file-read* (subpath "$HOME"))
  (allow file-read-metadata (subpath "$HOME"))
  (allow file-read* (subpath "$CE9_CONTROL"))
  (allow file-read* (subpath "$HOME/.local"))
  (allow file-read* (subpath "$HOME/.codex/packages"))
  PROFILE
  )
  ```

  The profile denies every file read under your home directory, then allows back only three things: the
  control directory, the launcher on your `PATH`, and the Codex program files. The metadata line lets
  paths resolve; it exposes no file content and no directory listing. Denying `$HOME` rather than the
  checkout is deliberate — the fixtures exist in more than one checkout, and the boundary has to cover
  copies you have forgotten about as well as the one you are standing in. Because the allowance names
  **this trial's** control directory only, every earlier control home falls under the denial with
  everything else.

  The separate Codex home matters for the same reason. `~/.codex` holds past session transcripts, and
  earlier Harbourview work is in them; a control that reads those has read the answer.
- **A capability boundary for Run A**, so the control cannot reach the sources through a connector
  either. The read boundary covers the filesystem and nothing else. It does not cover the account: on
  2026-08-13 a Run A launched inside a correctly closed read boundary searched and fetched the
  Harbourview material out of the account's Google Drive, and the trial was recorded **FAIL — blindness
  breach**. A boundary that stops one route and not the other is not a boundary.

  Three flags close the account-side routes, and they go on the launch itself (§ 3a) rather than into
  configuration, so that what was in force is visible in the command you ran:

  | Flag | Closes |
  |---|---|
  | `--disable apps` | the account's connectors — Google Drive and anything else synced to the login |
  | `-c 'mcp_servers={}'` | every MCP server declared in the copied `config.toml` |
  | `--ask-for-approval never` | escalation — the run cannot ask you to widen what it may reach |

  Verified against `codex-cli 0.147.0` on 2026-08-14: launched together on this account, with a fresh
  control home, the model's own tool registry contained no Drive or Google entry at all.
- About the length of two ordinary briefing exchanges.

**Where each thing runs.** Every command in § 2 runs from the repository root. **Run B** also runs from
the repository root, because it must be able to open the three paths it is given. **Run A runs from
`$CE9_CONTROL` and under both boundaries above** — never from the checkout, and never without them.

`CE9_CONTROL` and `CE9_PROFILE` are set in the shell you will launch Run A from, and they must still be
set when you launch it. If that shell is closed and reopened, set them again — with the **same**
`CE9_CONTROL` value, not a new timestamp.

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

Six rules. The first four are the instrument's § 4; the fifth and sixth are what make the control's
blindness a property of what it can reach rather than a promise about what you typed:

1. **Each run is a fresh Codex thread with no prior-session note loaded.** A thread already oriented by a
   summary is not a control, and its run is discarded rather than scored.
2. **Never run both in the same thread.** The second would inherit the first.
3. **Neither run receives `ce-9-recovery-scenario.md`, and neither receives this sheet.** Both state the
   answer.
4. **Neither run receives any summary, session note or transcript context** — including your own account
   of what Harbourview is.
5. **Run A is launched under the § 1 read boundary**, which denies it the Harbourview sources rather
   than merely not mentioning them. Withholding the paths is not enough on its own: a thread can search
   for "Harbourview" and find the fixtures without being told where they are, and copies of them exist
   in more than one checkout. A working directory outside the repository is not enough either — it
   changes where a thread starts, not what it is able to open. A control that reads the sources is not
   a memory-only control, so the boundary is **proved before the thread is launched** (§ 3a) rather
   than assumed.
6. **Run A is launched with the § 1 capability boundary and a fresh control home**, because the
   filesystem is not the only way to the sources. The account's connectors reach the same material from
   outside the sandbox, and a reused control home carries the previous run's transcript and the
   account's synced connector list. Both are closed at launch, and neither is closed by promising not
   to use it.

### 3a. Run A — the memory-only control

**Prove the boundary before you launch it.** Five checks. Set the checkout path once first — run
`git rev-parse --show-toplevel` from the repository root and use what it prints:

```
CO="/absolute/path/to/this/checkout"
F="$CO/plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9"
```

**Check 0 — the profile actually loaded.** Do this one first. A file the boundary is supposed to
*allow* must still be readable. Expect `exit=0`.

```
echo probe > "$CE9_CONTROL/.probe"
sandbox-exec -p "$CE9_PROFILE" /bin/cat "$CE9_CONTROL/.probe" >/dev/null 2>&1; echo "exit=$?"
rm -f "$CE9_CONTROL/.probe"
```

Anything else means `CE9_PROFILE` is empty or malformed and `sandbox-exec` refused to start. That
matters more than it looks: a boundary that never loads denies *everything*, so checks 1 and 2 would
report a clean result for the wrong reason. Fix the profile before reading any check below.

**Check 1 — no Harbourview file on this machine is readable inside the boundary.** This is the check
that covers the copies you do not know about, in other checkouts and in past Codex sessions.

```
CHECKED=0; DENIED=0; OTHER=0
while IFS= read -r p; do
  [ -f "$p" ] || continue
  CHECKED=$((CHECKED+1))
  sandbox-exec -p "$CE9_PROFILE" /bin/cat "$p" >/dev/null 2>&1
  case $? in 0) ;; 1) DENIED=$((DENIED+1)) ;; *) OTHER=$((OTHER+1)) ;; esac
done < <( { mdfind "Harbourview"
            grep -rlI "Harbourview" ~/.codex 2>/dev/null
            grep -rlI "Harbourview" ~/ce-9-control* 2>/dev/null; } | sort -u )
echo "checked=$CHECKED denied=$DENIED other=$OTHER"
```

The third source is there because an earlier Run A wrote its transcript into an earlier control home,
and that transcript quotes the Harbourview sources it reached. It is now one of the files this check
must find readable-by-nobody.

Expect `checked` well above zero, `denied` equal to it, and `other=0`. **If any file was readable, the
boundary is not closed — stop, and do not launch Run A.** `other` above zero means some reads failed
for a reason that is not a denial; treat those as unproved, not as denied.

**Check 2 — the three sources Run B is given are denied by exact path.** Expect `exit=1` three times.

```
for f in project-plan.md task-state.md operator-source-note.md; do
  sandbox-exec -p "$CE9_PROFILE" /bin/cat "$F/$f" >/dev/null 2>&1; echo "$f exit=$?"
done
```

**Check 3 — the same read with the boundary removed.** Expect `exit=0`.

```
sandbox-exec -p '(version 1)(allow default)' /bin/cat "$F/task-state.md" >/dev/null 2>&1; echo "exit=$?"
```

This is what makes checks 1 and 2 mean something. If this also fails, they were failing for some other
reason — a wrong path, a missing file — and they have proved nothing about the boundary. Stop.

**Check 4 — the control home is still fresh at launch time.** Expect **no output** from the first
command and `denied=` equal to `checked=` from the second. The first repeats § 1's freshness check
immediately before launch, because anything that started Codex in this home since — including an
abandoned attempt — has written history into it. The second confirms that every *earlier* control home
is outside the boundary.

```
ls -A "$CE9_CONTROL/.codex-home" | grep -vxE 'auth\.json|config\.toml'
```

```
CHECKED=0; DENIED=0
for p in $(ls -d ~/ce-9-control* 2>/dev/null); do
  [ "$p" = "$CE9_CONTROL" ] && continue
  [ -f "$p/.codex-home/config.toml" ] || continue
  CHECKED=$((CHECKED+1))
  sandbox-exec -p "$CE9_PROFILE" /bin/cat "$p/.codex-home/config.toml" >/dev/null 2>&1 || DENIED=$((DENIED+1))
done
echo "checked=$CHECKED denied=$DENIED"
```

`checked=0 denied=0` is a valid result on the first trial and only on the first trial: it means no
earlier control home exists. On any later trial it means the loop found nothing it should have found —
treat that as unproved and stop.

**Launch it under both boundaries, from the control directory.**

```
cd "$CE9_CONTROL"
CODEX_HOME="$CE9_CONTROL/.codex-home" sandbox-exec -p "$CE9_PROFILE" \
  codex --disable apps -c 'mcp_servers={}' --ask-for-approval never
```

**All three flags are required and none is optional.** `--disable apps` closes the account's
connectors, `-c 'mcp_servers={}'` clears any MCP server the copied `config.toml` declares, and
`--ask-for-approval never` means the run cannot ask you to widen what it may reach. Dropping any one of
them re-opens a route to the sources that the read boundary does not cover, and the trial it produces
is not a control. Record the launch command verbatim (§ 4).

If Codex will not start inside the boundaries, or will not start in a control home with no history,
**stop and record that** (§ 7). Do not drop a boundary or reuse an old home to get the trial finished:
a control that could reach the sources is not a control, whatever it then says.

Codex may report that a shell command of its own was refused while it runs. **That is the boundary
working, not a fault.** Run A needs to read nothing to answer from memory, and a refusal is the outcome
the control exists to produce — record what was refused (§ 4) and let the run continue.

**Approve nothing, and supply nothing.** For the whole of Run A you paste the prompt below and then
answer nothing else. Do not approve a command, do not grant an access request, do not name a directory,
do not confirm what Harbourview is. The three flags are what make that a property of the run rather
than a discipline you have to keep, and this rule is the backstop for anything they miss.

> **A permission prompt, an access-expansion request, or any sign that a connector or external
> retrieval is available is a blindness breach, not an invitation.** The run is stopped, its output is
> discarded rather than scored, and the trial is recorded **FAIL — blindness breach** naming what
> appeared (§ 5, § 7). Answering "no" and continuing is not the repair: a run that was *able* to ask
> was able to reach, and what it did with the offer is not the measurement.

One thing that is **not** a breach on its own: Codex listing a Google Drive *skill* in its catalogue, or
announcing that it will use one. Skills are documentation shipped with the client; the flags remove the
connector *tools* underneath them. This was observed on 2026-08-14 — the model said it was using the
Drive skill, found its tool registry held no Drive entry at all, and answered that the material was
unavailable. Judge the breach on what the run could reach, not on what it said it would try.

Then paste **exactly this and nothing else**. No paths, no directory, no file.

```
Can we pick Harbourview back up? I've got an hour this afternoon.
What's the next unit — go ahead and brief it.
```

**Before you score it, confirm the isolation held.** The boundaries are the enforcement; this is the
check that they were in force for this run. Read back what Run A actually did and check five things: it
worked in `$CE9_CONTROL`; it opened, listed or searched no file under this repository; it made no
connector, app or MCP call; it was asked to approve nothing and you approved nothing; and it reached no
Harbourview source by any other route. Record that confirmation — § 4 requires it.

> **If Run A reached any Harbourview source, or any part of this checkout, or reached outside the
> machine through a connector, the trial is FAIL** — a blindness breach, with the route it took written
> down. Its output is not scored on its merits, and the pair is not re-run to obtain a cleaner answer.

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
- **the directory it ran in.** For Run A, also the § 3a boundary evidence — check 0's exit status, the
  `checked=`/`denied=`/`other=` counts from check 1, the three exit statuses from check 2, check 3's
  exit status, and check 4's two results — plus **the launch command verbatim, showing all three
  capability flags**, and the after-the-run isolation confirmation: that it worked in `$CE9_CONTROL`,
  made no connector, app or MCP call, was asked to approve nothing, and reached no file in this checkout
  and no Harbourview source by any route. These are recorded observations, not assumptions: a trial
  whose control boundary was never proved has not established that the control was blind.

  **Record the control home by path, not by contents.** `$CE9_CONTROL` holds a copy of your Codex
  credentials. The path and the freshness-check output are the evidence; the contents of `auth.json`
  and `config.toml` never go into a result, a transcript quote or a commit.

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
| **FAIL** | Any of: the discriminator does not reach Run B; Run A reaches the corrective unit; the two outputs are indistinguishable; **preflight step 4 exited `0`** — an invalid instrument; **either thread was not fresh, or received more than § 3 allows, or Run A reached this checkout or any Harbourview source, or Run A ran without all three capability flags or in a reused control home, or a permission or access-expansion prompt appeared in Run A** — a blindness breach. |

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
3. Run A: thread identifier, freshness confirmed, what it received, the launch command verbatim with
   all three capability flags, and the § 3a boundary evidence — the check 0, 2 and 3 exit statuses, the
   check 1 counts, check 4's two results, the control-home path and the directory it ran in, and that
   it reached no file in this checkout, no Harbourview source and no connector, and was asked to
   approve nothing.
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
  this checkout or any Harbourview source, or Run A reached a connector, or a permission or
  access-expansion prompt appeared in Run A — that run's output is discarded rather than scored, and the
  trial is recorded **FAIL**, blindness breach, naming the rule that broke;
- the § 3a boundary checks do not come out as stated — check 0 does not exit `0`, a Harbourview file is
  readable inside the boundary, `other` is above zero, a named source does not exit `1`, check 3 does
  not exit `0`, check 4 finds history in the control home or leaves an earlier control home readable,
  or Codex will not start inside the boundaries. Run A is **not launched** and **no trial is
  recorded**: this is a hand-back about the boundary, not a verdict about recovery. Weakening the
  boundary to proceed is the one repair not available here;
- Codex will not start in a control home that has no history, or the three capability flags cannot be
  used together with the read boundary on this machine. Run A is **not launched** and **no trial is
  recorded** — this is a hand-back about the instrument. Reusing an old control home, or dropping a
  flag, is not the repair;
- following this sheet would require you to judge a prompt that offers wider access. It should not: the
  flags remove the offer. If one appears anyway, the answer is § 3a's breach rule, not your judgement
  about whether that particular access would have mattered;
- you cannot run a thread without giving it something § 3 forbids;
- the pair comes out indistinguishable — that is **FAIL**, and re-running for a better result would be
  choosing the answer;
- finishing would require creating a second durable artifact, or a decision about adoption or the wider
  eval pack. Both are the operator's, and neither is inside this sheet.
