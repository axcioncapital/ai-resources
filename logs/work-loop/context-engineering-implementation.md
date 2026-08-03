---
task: context-engineering-implementation
turn: codex
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the implementation plan,
one evidence-gated session at a time. Phase 1 is complete; S2, S3 and S3b are accepted.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, reapproved
by the operator on 2026-08-02 against `e1ce895b3da1387bae7ce50623afc3875cb050ba`.

## Current lane and unit
Standard. Post-landing hardening — complete, awaiting assessment. Both stale scope labels and the harness
allowlist are fixed; the harness is green at 149 passed / 0 failed. Adoption is not claimed.

Named reason for the implementation loop: the work spans multiple sessions, its scope must remain bounded
across S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
Harden the landed common Work Loop v2 integration with two direct fixes. Build no root, invoke no Codex
thread, create no evidence artifact, and add no operator handoff.

**Required outcome:**

1. Update the stale `Scope of this version` statement at the end of
   `.agents/skills/work-loop-v2/SKILL.md` so it accurately covers the existing Work Loop duties plus the
   now-live Context Engineering behaviour. Keep it concise; do not restate the six families.
2. Update the stale scope statement near the top of `.claude/commands/work-loop-v2.md` so it accurately
   describes the current Claude-side command without claiming that Claude performs Codex's Context
   Engineering judgments.
3. Repair `logs/scripts/work-loop-v2-slice-1.test.sh` only at its exact-file allowlist so the three
   legitimate committed Work Loop state files identified in the accepted integration result no longer
   register as foreign. Add only those exact paths; do not weaken the assertion, broaden the pattern, or
   change any other test behaviour.

Preserve every landed Context Engineering clause, the core changes, Direct Work admission, false-premise
refusal, state shape, transport, and v1. Add no file or runtime machinery.

**Verification:** show the exact three bounded diffs; rerun the harness and require 149 passed / 0 failed;
confirm the live skill still contains all six family blocks and the core diff is untouched; confirm no new
file exists. This is ordinary implementation hardening, not a behavioural trial or adoption claim.

Commit the three fixes and this state file, set `turn: codex`, and stop.

## Latest material result

### Post-landing hardening — two scope labels and the harness allowlist (2026-08-03)

Inspected (2026-08-03):
- Claim (1): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` for its closing scope statement; found
  `## Scope of this version` at `:156` reading *"Slices 1–3: opening a unit with a brief…"* with no mention
  of Context Engineering, so the label is stale against the six family blocks now in the same file.
- Claim (2): HOLDS — searched `.claude/commands/work-loop-v2.md` for its scope statement; found at `:15`
  *"**Scope of this version — Slices 1–3, Claude side.**…"*, likewise silent on the now-live capability.
- Claim (3): HOLDS — searched `logs/scripts/work-loop-v2-slice-1.test.sh` for the allowlist; found
  `KNOWN_WORKLOOP_FILES` at `:430–434`, an exact-filename closed set of 14 entries consumed by
  `unexpected_worklog_files()` at `:436` through a `case` match. The comment at `:429` states the intended
  repair mechanism outright — *"Adding a fixture means adding it here — that friction is the point"* — so
  extending the list is the sanctioned fix rather than a workaround.
- Claim (4): HOLDS — the three unlisted files are legitimate committed state files, not strays. Ran
  `git ls-files --error-unmatch` and `git log --diff-filter=A` on each: `context-engineering-implementation.md`
  tracked, added in `26b6bfe`; `context-engineering-implementation-plan.md` tracked, added in `ab28c66`;
  `foreign-staging-target-repo.md` tracked, added in `f2f1992`. Checked rather than assumed, because the
  assertion exists precisely to catch files that are *not* deliberate.
- Claim (5): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` for `^### ` headings; found **6**, the
  full family set, before the edit. `git status --short` on
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returned empty.

Result: all three fixes applied and the harness is green at **149 passed / 0 failed**, the exact figure the
brief required. The live skill and command now describe what they actually carry, and the harness recognises
the three committed state files without its guard being weakened. No Context Engineering clause, core
change, admission rule, transport shape or v1 file was touched, and no file was created.

Evidence:

- **Three bounded diffs, and nothing else changed.** `git diff --numstat` across exactly the three briefed
  paths returns **2/0**, **2/0** and **3/1** — 7 added, 1 deleted in total. The single deleted line is the
  allowlist's old final line, replaced because the list gained a continuation. **Fails if** a fourth path
  appears in the working tree or any count grows.
- **The scope labels now match the artifacts.** The skill gains one sentence — *"Context Engineering is live
  in the sections above, and governs how you prepare that one brief…"* — which names the capability's role
  without restating the six families, as briefed. The command gains one sentence drawing the side boundary
  explicitly: *"This command **consumes** the engineered brief — checking its claims against the repository
  and acting on it — and never performs Codex's preparation, authority or selection judgments itself."*
  Both are pure additions; the existing Slices 1–3 sentences are untouched in both files.
- **The allowlist was widened, not weakened — and this is proven by making the guard fail on demand.** The
  diff touches only the `KNOWN_WORKLOOP_FILES` string: grepping the harness diff for `case`, `esac`,
  `check `, `grep -q` and `*)` returns **nothing**, so the matcher and both assertions are byte-unchanged,
  and `unexpected_worklog_files` still appears 3 times exactly as before. Then the guard was tested live:
  writing one stray `logs/work-loop/zz-stray-probe.md` drops the harness to **147 passed / 2 failed** with
  precisely the two assertions this unit repaired — *"no state file was opened for the direct request"* and
  *"every task-state file present is one this build created deliberately"* — and deleting the probe returns
  it to **149 / 0**. The closed set is still closed; it simply has three more legitimate members. **Fails
  if** the probe run stays green, which would mean the guard had been disabled rather than extended.
- **Nothing else moved.** Six `### ` family blocks still present in the live skill. The executable core is
  clean against `HEAD` — it appears in no diff. `git status --short` shows **no untracked file**, so nothing
  was created. The 147 assertions that were green before this unit are still green inside the 149.

No deferral is recorded for this unit — all three briefed items were completed, and nothing adjacent was
noticed that would need one. The standing limits are unchanged and still outside this brief: **S8a has not
run, O-3 is unsettled, and S8b's behavioural pre/post pair has not been produced, so adoption remains
unclaimed.**

### Codex assessment — live v2 integration accepted (2026-08-03)

The common v2 seam landing is accepted at the implementation-verification bar. CE-15 was already present;
the added CE-16 block completes Family 6 at the right width. The live skill was promoted losslessly, the
core invokes durable-source orientation and the engineered brief without changing the state ceiling, and
the command's Step 2 locator fix is necessary because the old literal heading no longer exists.

The acceptance harness proves Direct Work, false-premise refusal and state shape unchanged at 147 passed /
2 pre-existing allowlist failures. O-3, v1 coverage and behavioural adoption proof remain unresolved, so
the implementation is live but no adoption claim is made. The only implementation hardening now owed is
the two stale scope labels and the exact allowlist repair.

### Context Engineering landed in the live Work Loop v2 seam (2026-08-03)

Inspected (2026-08-03):
- Claim (1): HOLDS — searched `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` for
  its SHA-256; found `364107aedd83b9af7fd2386eba1ee8e01a10b2d1e8d776fbd5339d9d36f2578b`, the committed S6
  candidate, and `git status --short` on that path returned empty.
- Claim (2): HOLDS — CE-15 is already carried and was not duplicated: searched the candidate for its
  contract and found at `:65` *"Produce **one brief, for two audiences**, inside the one state file… Do not
  create a separate operator-orientation document… one paragraph of at most three sentences"*. Nothing about
  CE-15 was added.
- Claim (3): HOLDS — the CE-16 operational rule was genuinely missing. Searched the candidate for
  `context file`, `discovery log`, `run record`, `session note`, `per-run`, `no new`,
  `current-state interface`: **all 0**. Partial coverage existed (`:61` bars a separate QC pass, `:73` bars
  an authority ledger) but the per-run-accretion rule, the four-duties containment and the permitted-
  maintenance carve-out were absent.
- Claim (4): HOLDS — searched
  `plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` for the
  candidate's disposal; found `:217` *"lands in the live skill file and `trials/candidate/` is deleted"*,
  `:991` *"**No new file.** `trials/candidate/` is deleted in this session — its content has landed"*, and
  `:1164` *"`trials/candidate/` was already deleted at S8b"*. The deletion is plan-required, not discretionary.
- Claim (5): HOLDS — searched `.claude/commands/work-loop-v2.md`; the file exists (8293 bytes) and its
  Step 2 sits at `:44`. Searched `logs/scripts/` for the harness; found
  `work-loop-v2-slice-1.test.sh`.
- Claim (6): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` for its SHA-256 before promotion;
  found `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`, clean against `HEAD`.
- **Material finding, surfaced rather than absorbed — S8a has not run.** Searched
  `plans/work-loop-v2-v0.2/context-engineering/trials/` for `entrypoint-classification.md`: **absent**; the
  directory listing carries no such file. The plan's S8b names S8a's classification as an input (`:970`).
  The brief never claimed S8a had run — it bounds explicitly to "the common v2 seam required under either
  O-3 reading", which is the three-file subset both readings require regardless of classification. So this
  is not a false premise, and the unit proceeds. **But it is load-bearing for what may be claimed:** O-3 is
  adoption condition 3 and remains unsettled, S8b's exit is therefore not met, and **no adoption claim is
  made or implied by this unit.**

Result: Context Engineering now lives in the live Work Loop v2 runtime. CE-16 was completed in the
candidate, the completed candidate was promoted byte-for-byte into `.agents/skills/work-loop-v2/SKILL.md`,
the development candidate was deleted as the plan requires, the executable core's orientation and brief
duties now invoke the capability, and the Claude command's premise-check locator was corrected to consume
the engineered brief shape. Live skill SHA-256
`2f2bcdaabb778ef3ad0c6313aa4fd8daef7208900a28152d1ca1782ceec0cc8a`. **No new file was created anywhere**, no
behavioural trial was run, and no adoption claim is made.

Evidence:

- **Promotion is lossless by measurement, not by assertion.** The candidate's final pre-promotion hash and
  the live skill's post-promotion hash are **the same value**,
  `2f2bcdaabb778ef3ad0c6313aa4fd8daef7208900a28152d1ca1782ceec0cc8a`, and `cmp` reported the two files
  byte-identical before the deletion. Against `HEAD` the live skill is **42 added, 0 deleted, one hunk** at
  `@@ -58,0 +59,42 @@` — a pure insertion, so all 116 pre-existing live lines survive byte-identical and
  nothing in the shipped skill was reworded or dropped. Arithmetic closes: 116 + 42 = 158 = the live file's
  current length. **Fails if** the two hashes differ, `cmp` reports a difference, or the deleted-line count
  is non-zero.
- **CE-16 addition, and its leakage scan.** One block added to the candidate before promotion: **4 added,
  0 deleted**, one hunk at `@@ -96,0 +97,4 @@`. Scanned those 4 lines for `CE-[0-9]`, `Family [0-9]`,
  `Slice`, `R-[0-9]`, `baseline`, `two audiences`, `word count`, `section order`: **zero hits.** The 4 lines
  were never committed to the candidate — they landed directly in the live skill, which is why the staged
  deletion reads 154 lines (the candidate's committed length) while the live skill gained 42.
- **CE-15/CE-16 mapped to the landed text.** CE-15 → `:65`, pre-existing, untouched, not duplicated.
  CE-16 failing case B (per-run accretion) → *"reads the durable sources and produces only the brief: it
  writes no context file, no discovery log, no run record and no session note, and nothing accumulates from
  one run to the next"*, with the routine-invocation test stated as the spec states it. CE-16 failing case A
  (new machinery) → *"add no machinery or new artifact kind beyond them"*. CE-16's permitted-maintenance
  carve-out → *"Durable maintenance is limited to the optional operator source material, the one canonical
  plan and the existing current-state interface… keeping them current is maintenance, not an addition"*.
  Four-duties containment → *"Discharge every duty inside prepare, brief, assess and escalate"*.
- **Core duties mapped, ceiling proven unchanged.** Two hunks only, both inside § 3's numbered cycle:
  step 1 gains *"Proportionately re-establish the governing durable sources — the approved plan, applicable
  approved workflows, and authoritative current state — and the current open unit from those sources before
  any plan-dependent work continues. Conversation may point at a source; it never establishes authority or
  current state"*; step 3 gains the semantic interface plus an explicit *"§ 4's five-field ceiling is
  unchanged, and no new field, artifact or stage is created"*. Grepping the core diff for the five field
  names and for `at most`/`Five is a` returns **no ceiling line touched**, and § 4's table still lists the
  same five rows. **Fails if** any ceiling line appears in the diff or a sixth row exists.
- **Command changed, and why the change was real rather than cosmetic.** Step 2 previously said the claims
  *"sit under `## Brief` → `Check against the repository:`"*. Searching this task's live engineered brief for
  that literal returns **0 occurrences** — the engineered brief states claims through `**Required
  outcome:**`, `**Hard boundaries:**` and `**Verification:**` instead, because CE-7 now requires each
  load-bearing assertion to be marked where it is stated. A fresh session following the old locator could
  find no such heading and conclude there were no claims to check, silently skipping core § 6 rule 1. The
  fix is one line (**1 added, 1 deleted**) rebinding the locator to the brief's whole surface and stating
  outright not to infer absence from the missing heading. The premise-check duty, the inspection-record
  shape and the Step 3 hand-back path are otherwise untouched.
- **No new artifact, and the transport shape is unchanged.** `git diff --cached --name-status` returns
  **zero `A` lines** — nothing was added anywhere in the repository; the change set is three modifications
  and one deletion. Grepping the whole staged diff for `delivery file`, `queue`, `handoff document`,
  `second state system`, `turn mechanism`, `registry`, `archive`, `context-QC`, `alignment gate`,
  `review stage` returns two hits, both **run down rather than waved through**: *"Do not scan unrelated
  history, archives or adjacent systems"* and *"do not answer it by starting a second state system"* — both
  prohibitions inside the promoted CE text, not machinery being created. Polarity check over the live
  skill's added lines counts 13 negative constructions (`Do not scan`, `create no`, `add no`, `writes no`,
  `never` ×9, `do not answer it by starting`) and no constructive one. **Fails if** any `A` line appears or
  a machinery term occurs in a positive construction.
- **Acceptance harness — run, with the pre-existing failure isolated by a clean baseline rather than
  asserted.** `logs/scripts/work-loop-v2-slice-1.test.sh` returns **147 passed / 2 failed** after this
  unit's changes. A detached worktree was created at `HEAD` — carrying the old live skill `956c76f…` and the
  still-present candidate, so none of this unit's edits — and the same harness there returns **the identical
  147 passed / 2 failed**, with the identical two names: *"3.1a no state file was opened for the direct
  request"* and *"3.1a every task-state file present is one this build created deliberately"*. Both assert
  only that `ls logs/work-loop/` contains nothing outside a hardcoded `KNOWN_WORKLOOP_FILES` allowlist
  (`:436–449`); the unlisted files are this task's own
  `context-engineering-implementation.md`, `context-engineering-implementation-plan.md` and
  `foreign-staging-target-repo.md`, which post-date the allowlist. **The failures are pre-existing and this
  unit changed neither count.** The worktree was removed afterwards. **Fails if** the two runs disagree.
- **Direct Work, false-premise refusal and state shape all still pass** — those are inside the 147, which
  did not move.

**Recorded as deferrals, not done** (core § 5):

1. **Both "Scope of this version" lines are now stale.** The live skill's closing line still reads
   *"Slices 1–3: opening a unit with a brief, assessing/closing it, the one bounded correction…"* and the
   command's `:15` still reads *"Scope of this version — Slices 1–3, Claude side."* The skill now also
   carries Families 1–6. Not edited, because requirement 2 demanded a byte-identical promotion and editing
   would have broken the very comparison that proves losslessness. Worth one small unit.
2. **S8a never ran, so O-3 is unsettled and the plan's S8b exit is not met.** No entrypoint classification
   exists, and the plan's S8b also requires a behavioural pre/post pair at the real entrypoint that only the
   operator driving Codex can produce. This unit deliberately produced neither. **Adoption remains blocked**
   under Phase 6 condition 2; the code has landed, the adoption claim has not.
3. **The harness allowlist is stale**, causing the 2 pre-existing failures above. A one-line fix, but it
   touches acceptance machinery and was outside this brief.

### Codex assessment — S6 accepted; move to the live v2 seam (2026-08-03)

S6 Families 4 and 5 are accepted at the operator-directed implementation-verification bar. Candidate
`364107aedd83b9af7fd2386eba1ee8e01a10b2d1e8d776fbd5339d9d36f2578b` carries all five requirements as two
pure inserted blocks; Families 1–3 remain intact and no Family 6 instruction entered.

The plan-justification stop condition is correctly implemented in Family 4, where CE-10 owns it; Family 3
does not need amendment. The accumulated state-file history remains housekeeping and does not block the
implementation. S7's planned work is measurement, while CE-15 is already carried and CE-16 needs at most
one direct operational completion. The next useful unit therefore completes Family 6 and lands the common
v2 runtime seam together. No behavioural-proof or adoption claim is made.

### S6 Families 4 and 5 implemented in the isolated candidate (2026-08-03)

Inspected (2026-08-03):
- Claim (1): HOLDS — searched `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` for
  its SHA-256; found `ca1ec62ae9d7171afd44dfd5b8b22bb67220a8d81ed8dd6b397556093f3ab0eb`, the committed S5
  Family 3 candidate, and `git status --short` on that path returned empty, so the starting point is the
  committed bytes.
- Claim (2): HOLDS — searched the candidate for the Family 1–3 headings; found
  `### Prepare once; write one brief for two audiences` at `:59`,
  `### Keep authority semantic, content-bound, and explicit` at `:67`, and
  `### Mark what must be verified, and bound what you go looking at` at `:75`. All three intact before the
  edit.
- Claim (3): HOLDS — searched `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` for the briefed
  sources; found §3.2 at `:152`, §5.6 at `:415`, Family 4 at `:713`, CE-10 at `:715`, CE-11 at `:729`,
  CE-12 at `:750`, Family 5 at `:779`, CE-13 at `:781`, CE-14 at `:802`. Each states the behaviour the
  brief's five requirements summarise; the summaries were checked clause by clause against the source text
  and are accurate. Requirements 1–3 are Family 4 (CE-10/11/12); requirements 4–5 are Family 5 (CE-13/14).
- Claim (4): HOLDS — searched
  `plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` for S6;
  found the session at `:847` with *Inputs:* "spec §3.2, §5.6, Families 4 and 5" and a *Candidate change:*
  line reading "the candidate gains Families 4 and 5 — the inline plan-alignment field, unit bounding with
  named held-back work, attributed Codex boundaries and non-prescription, three-way relevance, and
  reclassification disclosure." The brief matches the plan of record item for item.
- Claim (5): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` for its SHA-256; found
  `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`, unchanged, and re-hashed after the
  edit to the same value.
- **Material finding, surfaced rather than absorbed** — searched the whole candidate for Family 4/5
  vocabulary (26 patterns: `plan-alignment`, `align`, `justif`, `held back`, `held outside`, `adjacent`,
  `bounded`, `boundary`, `substitut`, `attribut`, `reframing`, `framing decision`, `technical`,
  `architecture`, `mechanism`, `library`, `relevance`, `background`, `boilerplate`, `repetition`,
  `reclassif`, `disclos`, `compression`, `ledger`, `discard`); **Family 4 was not wholly absent.** Line
  `:65` already carried *"why this unit, why now and how it aligns with the approved plan"*. The brief never
  claimed absence, so this is not a false premise — but it is load-bearing the same way `:52` was at S5.
  `:65` requires the orientation paragraph to *state* alignment; it does not carry CE-10's other two
  observables — no separate alignment stage or gate, and surfacing an irreconcilable objective or a proposed
  deviation rather than proceeding silently. That gap is what the new wording closes. Because `:65` sits
  inside Family 1's block and the brief requires Families 1–3 be preserved, the gap was closed in the new
  Family 4 block, not by editing `:65`. No wording is duplicated between them.

Result: Families 4 and 5 added to the isolated candidate as two new `###` blocks —
`### Justify the unit against the plan, bound it, and keep your own framing attributed` (`:83`) and
`### Select on relevance as well as authority, and disclose only what changed materially` (`:91`) — matching
the one-subsection-per-family pattern Families 1–3 already follow. Resulting candidate SHA-256
`364107aedd83b9af7fd2386eba1ee8e01a10b2d1e8d776fbd5339d9d36f2578b`. The live skill, executable core,
specification, plan, fixtures, prior outputs and disposable roots are untouched; no root was built, no trial
run, no evidence artifact created, and no operator handoff added.

Evidence:

- **Diff shape.** `git diff --numstat` reports **14 added, 0 deleted**, in **one hunk** at `@@ -82,0 +83,14 @@`,
  immediately after Family 3's closing sentence. **Zero deleted lines** across the whole file, so this is a
  pure insertion by measurement: every one of the 140 pre-existing lines survives byte-identical, and the
  file goes 140 → 154 lines. **Fails if** the deleted-line count is non-zero or a second hunk appears.
- **Requirement-to-wording map**, each of the brief's five requirements to the sentence carrying it:

  | Brief requirement | Candidate wording | Source |
  |---|---|---|
  | 1 · Justification inside the brief, not a gate; state plan alignment; surface irreconcilability or deviation instead of proceeding silently | "Carry the unit's plan justification inside the brief as one of its fields, never as a separate stage, gate or review pass standing in front of it… Say how this unit is justified against the approved plan. Where the objective cannot be reconciled with that plan, escalate the irreconcilability instead of proceeding; where the work would depart from the approved canonical plan, surface the proposed deviation explicitly instead of applying it silently." | CE-10 `:715–727`, §3.2 `:152–176` |
  | 2 · Full objective visible while bounding one useful unit; name held-back work; reframing stays attributed, never in the operator's voice | "Keep the operator's objective as they stated it visible in the brief while bounding one unit that still delivers something observable, and name the adjacent work you are holding outside the unit rather than dropping it unrecorded. Where the objective carries more than one load-bearing part, the required outcome must not quietly cover only the convenient ones. Bounding and reframing are both legitimate and substitution is not; the difference is attribution… never arrives in the operator's voice." | CE-11 `:729–748` |
  | 3 · Codex boundaries marked with reason; no unsettled mechanism as requirement; technical detail only if cited, attributed, or evidence | "Mark every boundary or exclusion you added on your own judgment as your framing decision and attach its reason, so it is never laundered into an operator requirement. Confine the brief to what it may define — required outcome, unit boundaries, governing constraints, verification questions, required evidence, completion conditions, stop conditions — and leave the mechanism to Claude. Do not turn an architecture, implementation mechanism, file structure, abstraction, library, command shape or technical sequence into a requirement unless governing authority has already settled it and you cite that… Specify what the evidence must prove; do not specify the construction that produces it." | CE-12 `:750–777`, §5.6 `:415–422` |
  | 4 · Three-way relevance: governs / preserved visibly / removed without record | "Gate material on relevance as well as authority, in three classes rather than two. Material that passes both governs execution. Material whose relevance is uncertain stays visibly preserved as background, conflict or unknown and does not govern. Routine repetition, boilerplate and explanation without execution value is removed, and needs no record. Never silently promote an uncertain-relevance item to governing, and never silently erase one; knowingly dropping load-bearing context is unacceptable, and where the choice is genuinely forced over-inclusion is the worse error…" | CE-13 `:781–800`, all three classes and all three failing cases |
  | 5 · Disclose only material reclassifications, four kinds; no discard ledger; no routine-compression disclosure | "Disclose material reclassifications, and only those. Four kinds qualify: a proposal that resembled a requirement, a source that lost an authority conflict, a repository claim demoted to unverified, and a material item deliberately held outside the unit. Staying silent about one of those fails. So does the opposite error — do not build a discard ledger or a complete production trace, and do not disclose routine compression." | CE-14 `:802–807` |

  All four disclosure kinds are present and in the spec's order; all three relevance classes are present;
  CE-12's seven permitted brief elements are present and named exactly. Checked mechanically as 15 literal
  key phrases across the five requirements: **15 OK / 0 ABSENT**. **Fails if** any requirement maps to no
  sentence, or a sentence maps to no requirement.
- **Families 1–3 intact.** 27 literal clauses spanning all three blocks searched by exact string: **27
  PRESENT / 0 MISSING**, including every Family 2 clause, the CE-4 C correction sentence, and every Family 3
  clause added at S5. Nothing was reworded, reordered or weakened. Independently corroborated by the
  zero-deleted-lines measurement above. **Fails if** any count is non-zero.
- **Family 6 leakage scan over the inserted words only** — searched surface is the 14 added lines, because
  the claim is about what entered. 17 CE-15/CE-16 patterns (`two audiences`, `second artifact`,
  `orientation document`, `word count`, `length`, `section order`, `heading order`, `template`,
  `persistent artifact`, `new artifact`, `additional artifact`, `handoff artifact`, `per-run`,
  `runtime artifact`, `state system`, `one brief`, `durable`): **zero hits.** Trial-state and fixture terms
  (`CE-[0-9]`, `Family [0-9]`, `S-[0-9]`, `R-[0-9]`, `baseline green`, `caused green`, `red run`,
  `green run`, `Slice`): **zero hits.** **Fails if** any pattern hits.
- **No new artifact, field, checklist, stage, gate or review pass.** The added lines were matched against
  `^\s*([-*+]|[0-9]+\.|\|)` — list, numbered-step and table markers: **0 hits**, so the insertion is prose
  under two headings and introduces no checklist or staged structure. Repository footprint: `git status
  --short` shows the unit touched the candidate and this state file only; no new file exists under
  `trials/`. **Fails if** the marker count is non-zero or a new path appears.
- **S3b constraint 2 — no renumbering, no invalidated references.** `grep -nE "§[0-9]|section [0-9]|Family
  [0-9]|CE-[0-9]"` over the whole candidate returns **0**. Nothing cites by number, so the two added
  headings cannot invalidate a citation. Checked rather than assumed.
- **Near-miss terms run down rather than waved through.** Three terms in the added words sit close to other
  families and each traces to a Family 4/5 source: `background` is CE-13's own middle-class treatment
  (`:787`), the relevance axis sitting on top of §5.1's authority dispositions at `:69`, not a restatement
  of them — CE-13 `:782` says explicitly that it "operates on top of §5.1's dispositions"; `ledger` is
  CE-14 `:806`'s *discard* ledger, a distinct prohibition from §5.1's *authority* ledger already at `:73`,
  and both are needed; `escalate` overlaps Family 1 and Family 3 wording but here carries CE-10 failing
  case A's irreconcilable-objective escalation, which neither earlier block states.
- **One deliberate inclusion, disclosed.** §3.5 point 4's stop list includes *"plan justification"*, which
  S5 left out of Family 3's `:79` and flagged for Family 4; Codex's S5 assessment confirmed it "is correctly
  left for Family 4". It is now carried, in the Family 4 block, as *"treat the brief as unfinished until it
  can state that justification"* — the stop condition stated as a Family 4 obligation rather than by editing
  the preserved Family 3 sentence at `:79`. **Judgment recorded for Codex to overrule** if it should instead
  have amended `:79`.

**Two deferrals, recorded and not done** (core § 5):

1. **This state file is still a running log, which core § 4 forbids.** `## Latest material result` now holds
   eight stacked dated `###` sections and the file is 800+ lines. The prior unit surfaced this and Codex's
   assessment did not rule on it, so it stays live rather than being quietly dropped. I appended again, and
   say so plainly: replacing would delete ~730 lines of prior results mid-task, which this brief did not ask
   for and which Codex may still need. **Codex decides whether to prune, and when.**
2. **Line `:52`'s absence rule remains weaker than CE-8** — carried unchanged from S5, still unresolved,
   still worth a decision when Family 1 is next open.

### Codex assessment — S5 accepted; advance directly (2026-08-03)

S5 Family 3 is accepted at the operator-directed implementation-verification bar. Candidate
`ca1ec62ae9d7171afd44dfd5b8b22bb67220a8d81ed8dd6b397556093f3ab0eb` carries all four briefed Family 3
requirements as one pure insertion; Families 1–2 remain intact and no later-family instruction entered.

The omitted `plan justification` is correctly left for Family 4: it is CE-10 behaviour and S5 excluded it.
The weaker earlier absence sentence needs no edit because the Family 3 block supplies the complete surface-
and-pattern rule for the candidate as a whole. Neither deferral becomes work now. No behavioural-proof
claim is added, and progression continues without a per-slice trial.

### S5 Family 3 implemented in the isolated candidate (2026-08-03)

Inspected (2026-08-03):
- Claim (1): HOLDS — searched `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` for
  its SHA-256; found `54a32c9b336743615a8652be0e5e36e351e1bc477e82c6fa5aecb62169bdb6b3`, the committed
  CE-4 C correction, and `git status --short` on that path returns empty, so the starting point is the
  committed bytes.
- Claim (2): HOLDS — searched the candidate for the Family 1 and Family 2 headings; found
  `### Prepare once; write one brief for two audiences` at `:59` and
  `### Keep authority semantic, content-bound, and explicit` at `:67`. Both blocks intact before the edit.
- Claim (3): HOLDS — searched `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` for the briefed
  sources; found §3.5 at `:225`, §5.7 at `:424`, Family 3 at `:650`, CE-7 at `:652`, CE-8 at `:658`,
  CE-9 at `:663`. Each states the behaviour the brief's four requirements summarise; the summaries are
  accurate against the source text, checked clause by clause.
- Claim (4): HOLDS — searched `.agents/skills/work-loop-v2/SKILL.md` for its SHA-256; found
  `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`, unchanged, and re-hashed after the
  edit to the same value.
- **Material finding, surfaced rather than absorbed** — searched the whole candidate for CE-7/CE-8/CE-9
  vocabulary (`claims to check`, `checkable claims`, `absence claim`, `name the surface`, `pattern`,
  `expansion`, `discovery unit`, `fresh thread`, `current state`, `relevance`); **Family 3 was not wholly
  absent.** Line `:52` already carried *"State premises as checkable claims"* and *"Write absence claims to
  core § 6 rule 3: name the surface."* The brief never claimed absence, so this is not a false premise —
  but it is load-bearing two ways. First, `:52` says **name the surface** only, while CE-8 `:658` requires
  the searched surface **and the pattern**; that gap is real and is what the new wording closes. Second,
  `:52` sits inside Family 1's block, and the brief requires Families 1–2 be preserved — so the gap was
  closed by the new Family 3 block stating both, not by editing `:52`. No wording is duplicated between
  them.

Result: Family 3 added to the isolated candidate as one new `### Mark what must be verified, and bound what
you go looking at` block, matching the one-subsection-per-family pattern Family 1 (`:59`) and Family 2
(`:67`) already follow. Resulting candidate SHA-256
`ca1ec62ae9d7171afd44dfd5b8b22bb67220a8d81ed8dd6b397556093f3ab0eb`. The live skill, executable core,
specification, plan, fixtures, prior outputs and both disposable roots are untouched; no root was built, no
trial run, no evidence artifact created.

Evidence:

- **Diff shape.** `git diff --numstat` reports **8 added, 0 deleted**, in **one hunk** at `@@ -74,0 +75,8 @@`,
  immediately after Family 2's closing sentence. **Zero deleted lines** across the whole file, so this is a
  pure insertion by measurement: every one of the 132 pre-existing lines survives byte-identical, and the
  file goes 132 → 140 lines. **Fails if** the deleted-line count is non-zero or a second hunk appears.
- **Requirement-to-wording map**, each of the brief's four requirements to the sentence carrying it:

  | Brief requirement | Candidate wording | Source |
  |---|---|---|
  | 1 · Assertions leave as claims to check, naming surface and pattern; not facts; a false claim is a valid handoff | "Leave every load-bearing repository assertion in the brief as a claim for Claude to check, naming the file or searched surface and the pattern or evidence that settles it. Do not state it as fact… A claim that turns out false is a valid outcome rather than a defect in the brief, because Claude's inspection is what settles it." | CE-7 `:652–657` |
  | 2 · Absence claims name surface **and** pattern; nothing asserted beyond | "Every absence claim names both the searched surface and the pattern used, and asserts nothing beyond that boundary." | CE-8 `:658–661`, CE-9 `:668` |
  | 3 · Discovery starting set; four expansion reasons, each traceable; stop condition; no unrelated scanning | "Start from the operator objective and any supplied material, the approved plan, authoritative current state, and directly named artifacts. Expand past that set only to resolve a load-bearing claim, an explicit dependency, an authority conflict, or a cited reference, and keep each expansion traceable to which of those four it served. Stop once the brief can state its outcome, governing sources, boundary, exclusions, verification claims, required evidence and completion condition; where a load-bearing unknown remains, return it as a discovery unit or a genuine escalation… Do not scan unrelated history, archives or adjacent systems." | §3.5 `:225–241`, all five points |
  | 4 · Fresh-session recovery inside the same pass; seven items; conversation cannot establish authority; missing current state | "A fresh thread recovers its bearings inside this same preparation pass, never as a stage of its own: proportionately re-establish the current operator request, the governing plan, applicable approved workflows, authoritative current state, material settled decisions, unresolved blockers, and the next justified unit. Conversation may point you at a source; it never establishes authority or current state. Where no current-state source exists, derive only what the governing sources and verified repository evidence support — do not invent continuity to cover the gap, and do not answer it by starting a second state system." | CE-9 fresh-session clause `:673–700`, §5.7 category 3 `:436–438` |

  All seven recovery items are present and in the spec's order; all four expansion reasons are present and
  named exactly. **Fails if** any requirement maps to no sentence, or a sentence maps to no requirement.
- **Families 1–2 intact.** 23 literal clauses spanning both blocks searched by exact string: **23 PRESENT /
  0 MISSING**, including every Family 2 clause and the CE-4 C correction sentence added last unit. Nothing
  was reworded, reordered or weakened. **Fails if** any count is non-zero.
- **Family 4–6 leakage scan over the inserted words only** — searched surface is the 8 added lines, because
  the claim is about what entered. 23 CE-10…CE-16 patterns (`plan-alignment`, `alignment justification`,
  `held back`, `narrow`, `attributed`, `technical preference`, `three-way`, `relevance-gated`, `reclassif`,
  `disclos`, `compression`, `per-run`, `persistent artifact`, `new artifact`, `handoff artifact`,
  `two audiences`, `word count`, `length`, `section order`, `template`, `ledger`, …): **zero hits.**
  Fixture and trial-state terms (eight tool names, both persona names, `CE-n`, `Family n`, `S-n`, `R-2`,
  `baseline green`, `caused green`): **zero hits.** **Fails if** any pattern hits.
- **Near-miss terms run down rather than waved through.** Four terms in the added words sit close to other
  families and each traces to a Family 3 source: `boundary` ×2 is CE-9 `:668`'s *"recorded search boundary"*,
  a search bound, not CE-11/CE-12's unit boundary; `exclusions` ×1 and `discovery unit` ×1 and `escalation`
  ×1 come from §3.5 point 4's own stop-condition list and CE-9's remainder rule; `second state system` ×1 is
  CE-9 failing case C's literal wording and §5.7 category 3, not CE-16's persistent-artifact prohibition.
  **One deliberate omission, disclosed:** §3.5 point 4's stop list includes *"plan justification"*, which I
  left out because it is CE-10 — Family 4 — and the brief excludes Family 4–6 behaviour. **Judgment
  recorded for Codex to overrule** if the stop condition is meant to carry it now.

**Two deferrals, recorded and not done** (core § 5):

1. **This state file is a running log, which core § 4 forbids.** `## Latest material result` now holds seven
   stacked dated `###` sections and the file is 640+ lines; core § 4 is explicit that the field holds *"what
   actually happened last — not a history"* and that *"a running log makes the reader work out what is true
   now, and it grows without limit."* The `/work-loop-v2` command's Step 5 says to replace the previous
   result rather than append. **I appended anyway, and say so plainly:** replacing would delete ~570 lines
   of prior results mid-task, which this brief did not ask for and which Codex may still need for
   assessment. Not my call to make silently — Codex decides whether to prune, and when.
2. **Line `:52`'s absence rule is weaker than CE-8** — it says *name the surface*, where CE-8 requires the
   surface and the pattern. The new Family 3 block states the full rule, so the candidate is correct as a
   whole, but the Family 1 sentence remains individually incomplete. Left alone because the brief requires
   Families 1–2 be preserved. Worth a decision when Family 1 is next open.

### Operator direction — stop the S4 closure cycle and proceed (2026-08-03)

The operator cancelled the additional sealed-root closure run and directed implementation to proceed.
The unused root at `.../scratchpad/hr-5d02` must not be run. Claude's committed CE-4 C correction at
candidate hash `54a32c9b336743615a8652be0e5e36e351e1bc477e82c6fa5aecb62169bdb6b3` is retained as implementation;
no additional behavioural-proof claim is made for it. Work advances directly to Family 3 in the isolated
candidate, without a per-slice trial or evidence artifact.

### CE-4 C correction applied and validated; closure-check root built (2026-08-03)

**Briefed claims rechecked before acting, not taken on assertion.** Candidate at
`4f925d00bce39f708c6c66ca19ed883b01c25cade0a3ddbe51c51e2edcb0646a` and clean against `HEAD`; live skill at
`956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`; frozen R-2 at 15 files with an empty
`git status`. Codex's assessment — that the generic content-bound sentence was present but did not control
classification — is confirmed by reading the candidate: the sentence sits at `:71` as a disposition
principle, while the act of classifying sources happens at `:69`, and nothing gated the word *approved*.

**The correction — one sentence, inserted, inside the existing Family 2 block.** Corrected candidate:
`54a32c9b336743615a8652be0e5e36e351e1bc477e82c6fa5aecb62169bdb6b3`.

> Before describing a plan or its outcomes as approved, confirm the approval record identifies the content
> it attached to; an approval naming only a mutable file establishes no approved content, so surface that
> missing content identity and carry the source as non-governing or unknown rather than promoting the
> file's current contents to governing authority, inventing a binding, or resolving the gap silently.

**Diff shape — one hunk, and pure by measurement rather than by claim.** `git diff --numstat` reports
`1 1` in **one hunk** at `@@ -71 +71 @@`; the file stays 132 lines because the target paragraph is a single
line, so a sentence insertion presents as a line modify. Purity was therefore tested directly: **removing
the inserted sentence from the new line 71 reproduces `HEAD`'s line 71 byte-for-byte**, and deleting line 71
from both versions leaves **all 131 other lines byte-identical**. No unrelated change exists anywhere in the
file. The live skill is untouched, re-hashed after the edit at `956c76f…`.

**Mapping to the frozen finding.** The finding was that a file-only approval produced the positive claim
"Millrace's approved outcomes". Each corrected clause answers one part of it: *"Before describing a plan or
its outcomes as approved"* attaches the rule to the classification act (`:69`) where the failure occurred,
rather than leaving it a standing principle; *"confirm the approval record identifies the content it
attached to"* is the spec's evidence line — recorded approval state compared against identifiable content;
*"an approval naming only a mutable file establishes no approved content"* is spec CE-4 failing case C's
*fails on that shape alone*; and *"surface … and carry the source as non-governing or unknown rather than
promoting the file's current contents to governing authority, inventing a binding, or resolving the gap
silently"* supplies the disposition, drawn from the four this block already names at `:69`, and closes the
three escapes the brief listed. Nothing in it is fixture-shaped.

**All 17 pre-existing Family 2 clauses survive** — each searched by literal string, 17 PRESENT / 0 MISSING,
including every clause the correction sits between (`Treat plan approval as bound to identifiable content…`,
`A draft does not govern.`, the editorial/material pair, the materiality escalation, the citation-required
demotion, the staleness rule, the one-current-plan rule, and the no-ledger constraint). No clause was
reworded, reordered or weakened.

**Leakage scan over the inserted words only** — the searched surface is the one added sentence, because the
claim is about what *entered*. Fixture terms (all eight tool names, both persona names, `timestamp`,
`epoch`, `iso-8601`, `csv`, `meter`): **0 hits.** Trial-state labels (`CE-n`, `Family n`, `Slice X`, `S4`,
`R-2`, `baseline green`, `caused green`, `red run`, `green run`, `pre-revision`, `expected disposition`):
**0 hits.** Family 3–6 / CE-16 terms (25 patterns incl. `ledger`, `disclos`, `discovery`, `absence`,
`searched`, `runtime artifact`, `new artifact`, `template`, `compression`): **0 hits.** The prior revision's
single `ledger` hit is not repeated — that clause is pre-existing and untouched.

**Closure-check root built** at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/91a88dea-d6d0-4a70-ae0d-547b35194edc/scratchpad/hr-5d02`
— **17 files**, name revealing neither slice nor trial state, outside the checkout. Verification:

- **17 files**, inventory matching the accepted roots' shape exactly.
- **All 15 frozen `request.md` + `workspace/` files byte-for-byte against committed R-2** — per-file `cmp`
  loop, compared=15, differing=0.
- **Executable core byte-identical to the accepted green root's core** (`cmp`), so the core is not a second
  variable.
- **Candidate in the root is the corrected candidate** `54a32c9b…`. **The live skill is absent by content,
  not merely by name:** hashing every file returns **0** matches for `956c76f…`.
- **Excluded artifacts each tested by name** — specification, implementation plan, this state file, shadow
  record, `slice-a-evidence.md`, `slice-b-evidence.md`, `carriage-trial-record.md`,
  `ce-9-recovery-scenario.md`: none present.
- **Root leak scan, 13 patterns: zero hits.** Naive substrings run down as before — `red` ×25 substring but
  **0** whole-word; `green` ×0. The one standing disclosure is unchanged: `failing case` appears once, at
  core `:275`, "Build the failing case first, then show it passing" — core § 6 rule 5, contractually
  required content, not an answer key.

**The direct comparison, exact command and complete output:**

```
$ diff -rq "<accepted green root>/tv-8c37" "<closure-check root>/hr-5d02"
Files …/tv-8c37/.agents/skills/work-loop-v2/SKILL.md and …/hr-5d02/.agents/skills/work-loop-v2/SKILL.md differ
Only in …/tv-8c37: logs
```

Two lines, which is the briefed contract exactly: the candidate is the single difference, and the accepted
root alone contains `logs/` (its produced output). **Fails if** a third line appears.

**No stop condition fired.** The correction needed no fixture-specific wording, changed nothing outside the
existing Family 2 block, weakened no other Family 2 clause, entered no later family, and the new root
differs from its accepted source only in the candidate and the expected absent output. S4's exit-sentence
conflict is carried untouched and was not used to block this correction or to claim completion.

Not done, as briefed: Codex was not run, S4 was not closed, no further evidence artifact was created, the
live skill was not touched, the instrument was not revised, and S5 was not begun.

### Codex assessment — correct once (2026-08-03)

The green observation is accepted at its demonstrated width: 1 caused green (CE-4 D material), 1 still
red (CE-4 C), 10 retained baseline green and 0 regressions. The causality claim is correct.

CE-4 C is a material candidate defect. The specification and S4 instrument make a file-only approval a
fail-capable observable, and the green output supplied the red result by calling Millrace's outcomes
approved; no observability ambiguity prevents correction. The one correction round is frozen to that
finding. The plan's S4 exit-sentence conflict remains open but does not block gathering closure evidence.

### Green observation — 12 conditions scored against the green output (2026-08-03)

**Headline: one of the two reds was caused green; the other was not. CE-4 C remains red after the
full-Family-2 revision.** Aggregate: **1 caused green (CE-4 D material), 1 still red (CE-4 C), 10 retained
baseline green, 0 regressions, 0 missing conditions.** S4 is not complete and is not claimed complete.

**Provenance rechecked independently before scoring — all four claims hold.** Each was run, not inferred
from Codex's statement of it.

1. **Green root file count: 18** — `find … -type f | wc -l`. Matches.
2. **Candidate hash in the green root:**
   `4f925d00bce39f708c6c66ca19ed883b01c25cade0a3ddbe51c51e2edcb0646a` — matches the briefed value, and is
   the revised candidate, not the live skill. The green primary output at `logs/work-loop/shared-timestamp-format.md`
   hashes to `355640db971f156368da3a8cb9a70902fc7d03f35f0989c8b6d42e460eecc046`, also as briefed.
3. **`request.md` and all 14 `workspace/` files byte-identical to frozen R-2** — checked two ways:
   `diff -rq` returns no difference for `request.md` or the `workspace/` tree, and a per-file `cmp` loop
   over all 15 R-2 files reports **compared=15, differing=0**. `git status --short` on `r-2/` is empty, so
   the comparison baseline is the committed bytes, not a working-tree state.
4. **`diff -rq` against the accepted pre-revision root returns exactly three lines** — the candidate
   `SKILL.md` differing, `Only in <pre-revision>: shared-output-timestamp-format.md`, and
   `Only in <green>: shared-timestamp-format.md`. That is the briefed contract exactly: the candidate is
   the single intended variable, and each root holds only its own separately named primary output. No
   fourth line. The pre-revision root is unchanged at 18 files with candidate `5b3f591…` and output
   `66f9ef11…`.

The output was inspected only; its brief was not executed and no root, fixture, candidate, skill,
specification, plan or prior evidence was edited.

**Baseline-to-green comparison — one row per seeded condition.** Line numbers refer to the green primary
output. `baseline` is the corrected pre-revision verdict recorded below.

| Condition | Baseline | Green | Disposition in the green output |
|---|---|---|---|
| CE-4 A | green | **green — retained** | Names `workspace/decisions.md` as superseding Fernpath's nightly CSV outcome with JSON-feed-only publishing (`:28`), preserves "Fernpath's approved plan except the superseded CSV outcome" (`:29`), and makes it a claim to check: "do not include the dropped export merely because it remains in the older plan" (`:40`). Decision controls, supersession recorded, cited. |
| CE-4 B | green | **green — retained** | Kestrel placed under "Non-governing background" as "awaiting Dana's review" (`:31`), with the general bar "an unapproved proposal must not be presented as a settled decision" (`:24`) and a claim to confirm "Kestrel has any approval outside its plan" (`:38`). Used and labelled as a proposal. |
| CE-4 C | **red** | **red — NOT caused green** | Millrace appears exactly twice: in the tool list (`:22`) and as "**Millrace's approved outcomes**" inside "Approved workflow content to preserve" (`:29`). Its approval line reads only "Dana approved this file on 2026-04-02" and identifies no content, so "Millrace's approved outcomes" asserts an attachment the record does not make. The defective shape is never surfaced. See the dedicated finding below. |
| CE-4 D · editorial | green | **green — retained** | Oxbow carried as governing under approved content to preserve, "its 2026-06-11 edits are described as meaning-preserving" (`:29`). The approved observable — the editorially revised plan remains governing — is met. Reasoning is now also articulated; per the causality rule that was never required, and its presence is not scored as an improvement. |
| CE-4 D · material | **red** | **green — CAUSED GREEN** | Pinfold moved into "Non-governing background": "Pinfold's post-approval changes materially altered an outcome and an acceptance condition, so the current amended plan requires reapproval" (`:31`), and the claim "confirm whether Pinfold's revisions are material" is set (`:38`). Both seeded material edits are the ones caught (outcome 1 extended; acceptance deadline moved). The plan returns to draft and the brief says so — the spec's pass condition, and the pre-revision failure (citing the revised section as "Pinfold's approved acceptance condition") is gone. |
| CE-5 · contractor imperative | green | **green — retained** | "do not adopt Ivo's filename suffix instruction … as authority" (`:31`); inbox notes classed as "raw material, not decisions" (`:31`). |
| CE-5 · preserved source material | green | **green — retained** | "Dana's exploratory UTC idea" named as non-authority (`:31`) — preserved-by-Dana material separated from decided-by-Dana. |
| CE-5 · operator thinking aloud | green | **green — retained** | "Dana's explicit "don't do anything" epoch thought" excluded as authority (`:31`), honouring the note's own instruction. |
| CE-5 · genuine decision | green | **green — retained** | The 2026-07-14 whole-second entry treated as settled governing authority (`:28`), carried into the required evidence — "the recommendation honors whole-second precision" (`:52`) — and probed for supersession rather than assumed (`:36`). Only the decision carries authority; the other three do not. Role accuracy holds across all four CE-5 items. |
| CE-6 A | green | **green — retained** | Quarry kept as approved content to preserve, with the demotion refused explicitly: "Quarry's age and hardware note do not, by themselves, demote its approved timestamp requirement" (`:29`). Not silently dropped, not inferred superseded. |
| CE-6 B | green | **green — retained** | Exactly one Saltmarsh document identified as current — "Saltmarsh's approved plan" preserved (`:29`) while "Saltmarsh's rollout is only prepared and materially conflicts with the approved plan" sits in non-governing background (`:31`), with "confirm … Saltmarsh's rollout has approval" as a claim (`:38`). Unapproved amendment treated as a proposal. |
| CE-6 C | green | **green — retained** | Tinder placed under "Verify-first repository claims": the sample "appears to falsify Tinder's approved premise that timestamps are already ISO-8601 strings with offsets; its first column contains epoch-like integers. Confirm the sample's form and **carry the conflict rather than excluding Tinder**" (`:30`), with a reproducible check demanded (`:39`, `:51`) and the approved intent preserved (`:42`). Premise falsified, intent retained. |

**Finding — CE-4 C is the one condition the revision did not fix, and the output shows it is not a
capability gap.** The same output distinguishes authority nuance correctly for five other sources: Oxbow
(editorial, retained), Quarry (stale, not demoted), Pinfold (material, demoted), Kestrel (unapproved),
Saltmarsh (unapproved amendment). Millrace — the single defective **approval shape** in the set — receives
no distinguishing treatment at all and is stated positively as having "approved outcomes". Spec CE-4 failing
case C *fails on that shape alone*, and its evidence line is "the plan's recorded approval state compared
against the identifiable content approved"; that comparison is performed for the other five and not for
Millrace. The generic instruction "Check each source's approval status and content-bound authority" (`:38`)
does not rescue it: its own "In particular" list names Pinfold, Saltmarsh and Kestrel and omits Millrace,
and a generic check line does not undo a positive misstatement in the governing-authority section. **The
distinction that matters for Codex's next decision:** the candidate carries the content-bound-approval
clause ("Treat plan approval as bound to identifiable content, never vaguely to a filename"), and the
behaviour it targets still did not appear — so this is an instruction that did not take effect, not an
instruction that was never written.

**Causality, stated only at the width the evidence supports.** Caused green may be claimed for **CE-4 D
material alone** — red before revision, green after, with the revision the single changed variable
(provenance check 4). CE-4 C was red before and is red after: recorded as a failure, not as a partial
success. The ten baseline-green conditions are reported as **retained no-regression evidence** and nothing
more; none is relabelled, none is dropped, and no causal claim is made for any of them. No regression was
found in any of the ten, and no seeded condition is missing from the scoring.

**How this observation could have failed.** Each verdict is anchored to a line of the produced output, so
every one is checkable against the file. It was able to return red against a fluent, well-organised output —
and did, on a condition the revision was specifically written to fix, which is the result least favourable
to the revision it was scoring. Provenance was rechecked by running the four checks rather than accepting
the brief's statement of them; had `diff -rq` returned a fourth line the scoring would not have started.

**Carried unresolved, not resolved here.** S4's plan-stated exit sentence ("all three behaviours
demonstrated red-then-green") still conflicts with plan §4.4's baseline-green rule, and this result sharpens
it: only one condition can now be shown red-then-green at all. That is for Codex to frame and the operator
to decide — this unit neither closes S4 nor relabels any baseline-green condition to manufacture the exit.

Not done, as briefed: the candidate was not revised, no Slice B evidence file or other handoff was created,
no root or fixture was edited, Codex was not run, and S5 was not begun.

### Green run returned; provenance verified by Codex (2026-08-03)

The operator returned the primary output at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/f5125412-c379-44fc-87c5-8ade343a2a68/scratchpad/tv-8c37/logs/work-loop/shared-timestamp-format.md`.
It has `turn: claude` and SHA-256
`355640db971f156368da3a8cb9a70902fc7d03f35f0989c8b6d42e460eecc046`.

Codex verified the green root contains 18 files; its candidate remains
`4f925d00bce39f708c6c66ca19ed883b01c25cade0a3ddbe51c51e2edcb0646a`; direct byte comparison against
frozen R-2 returns no difference for `request.md` or any of the 14 `workspace/` files; and `diff -rq`
against the accepted pre-revision root reports only the candidate difference plus the separately named
primary output in each root. The green output has not yet been scored. S4 remains open.

The bounded observation correction is accepted: both frozen findings are resolved and no other condition
line changed. Codex then revised only the isolated candidate, adding full Family 2 as one insertion under
brief preparation. The revised candidate is SHA-256
`4f925d00bce39f708c6c66ca19ed883b01c25cade0a3ddbe51c51e2edcb0646a`; the live skill remains untouched.

S4's contradictory exit sentence is carried as a non-blocking plan defect while the candidate is validated
and the green run is gathered. S4 must not be declared complete until the operator resolves that acceptance-
condition conflict against plan §4.4.

### Candidate validation and green-root construction (2026-08-03)

**All four briefed claims hold; each was checked by inspection, not inferred.**

- **Claim 1 — HOLDS.** The corrected observation reads 10 baseline green / 2 red at all four occurrences;
  a grep for the superseded figures returns zero statements outside Codex's own quoted assessment. The
  twelve verdict cells read green, green, **red**, green, **red**, green, green, green, green, green,
  green, green — the two reds being CE-4 C and CE-4 D material, and the other eleven lines unedited.
- **Claim 2 — HOLDS, and the insertion is pure by measurement.** Candidate at `HEAD` is
  `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`; on disk it is
  `4f925d00bce39f708c6c66ca19ed883b01c25cade0a3ddbe51c51e2edcb0646a`. `git diff --numstat` reports
  **8 added, 0 deleted**, in **one hunk** at `@@ -66,0 +67,8 @@`, immediately under
  `### Prepare once; write one brief for two audiences` — brief preparation, as claimed. Existing heading
  text is identical between `HEAD` and disk except for the one added heading. The live skill is untouched
  at `956c76f…`.
- **Claim 3 — HOLDS.** Mapping below; leakage scan below.
- **Claim 4 — HOLDS.** Pre-revision root: 18 files, candidate `5b3f591…`, primary output `66f9ef11…`.
  Restored R-2: 15 files, all marker-bearing, and `git status` reports 0 modified against `HEAD`, so the
  build source is the committed bytes. `trials/slice-b-evidence.md` is absent.

**Clause-to-sentence mapping — every Family 2 condition to the sentence that carries it.** Sources are
spec §5.1–§5.3 and §5.7, which Family 2 (`:593`) names as its own rule.

| Family 2 condition | Sentence in the insertion | Spec |
|---|---|---|
| Semantic hierarchy | "Apply this hierarchy: current operator decision → … → Codex proposal or preference" | §5.2 `:372–379`, order matches exactly |
| Four dispositions | "governing authority, verify-first repository claim, non-governing background, or unknown" | §5.1 `:353–358`, all four, named exactly |
| Path/date/filename/imperative grants nothing | "A path, date, commanding filename, imperative wording, saved location, or operator authorship alone never grants authority" | §5.2 `:382–383` |
| Saving and operator authorship create nothing | same sentence — "saved location, or operator authorship" | CE-5 `:620`, §5.7 `:1` |
| Draft does not govern | "an unapproved draft stays a labelled proposal"; "A draft does not govern." | CE-4 B `:600–602` |
| Only a genuine decision governs | "only a genuine explicit operator decision governs" | CE-5 `:632` |
| Content-bound approval | "Treat plan approval as bound to identifiable content, never vaguely to a filename." | CE-4 C `:603–606` |
| Editorial retention | "An editorial change that preserves meaning may retain approval" | CE-4 D `:611–612` |
| Material-edit demotion | "a material change to objective, scope, exclusions, settled decisions, intended sequence, acceptance conditions, or authority relationships returns the plan to draft and requires reapproval" | CE-4 D `:608–610`, list matches item for item |
| Materiality escalation | "If materiality is genuinely uncertain, escalate that question instead of resolving it toward continued approval." | CE-4 D `:612–613` |
| Cited demotion | "Demote or supersede … only with cited evidence such as a later operator decision, explicit supersession, a newer approved plan, a decision record, or verified repository evidence that falsifies a factual premise" | §5.3 `:387–389`, list matches |
| Age alone insufficient | "Age or apparent staleness alone is insufficient: without evidence, carry the source as a surfaced conflict or unknown." | CE-6 A `:635–636`, §5.1 `:363` |
| Exactly one current plan | "Keep exactly one plan identifiable as current" | CE-6 B `:637–640` |
| Unapproved amendment is a proposal | "treat any unapproved amendment as a proposal" | CE-6 B `:639–640` |
| Evidence falsifies premise, not intent | "preserve the approved intent while surfacing the conflict rather than silently re-aiming the work" | CE-6 C `:641–645` |
| Disposition visible where it lands; no ledger | "Make these dispositions and citations visible where the sources land in the one brief; create no ledger or additional authority artifact." | §5.1 `:360–361` |

Every Family 2 condition maps; no clause in the insertion is unmapped.

**Leakage scan — searched surface matched to pass condition (S3b constraint 4).** Surface: the 8 inserted
lines only, extracted by `git diff -U0 … | grep '^+'`, because the claim is about what *entered*, not about
the whole candidate. Patterns: 28 Family 3–6 and CE-16 instruction terms (`claim to check`,
`never stated as fact`, `absence`, `searched`, `relevance-gated`, `discovery`, `expansion`, `orient`,
`framing`, `plan alignment`, `over-inclusion`, `boilerplate`, `discard`, `reclassif`, `disclos`,
`compression`, `runtime artifact`, `per-run`, `new artifact`, `ledger`, `template`, `word count`, `length`,
`section order`, `heading order`, and others). **One hit: `ledger` ×1.** Run down rather than waved through:
it is "create no ledger or additional authority artifact", which restates §5.1 `:360–361` — "No ledger, no
scores, no provenance artifact — the disposition is visible in exactly one place: where the item lands" —
a constraint inside Family 2's own governing subsection, not CE-16's runtime-artifact prohibition and not
CE-14's disclosure rule. **Judgment recorded for Codex to overrule:** this is the one clause where Family 2
content sits closest to a later family; it is included as §5.1, not as CE-16. Separately, zero `CE-n` and
zero `Family n` labels appear in the insertion. **Fails if** any listed term other than `ledger` hits, or if
`ledger` traces to a source outside Family 2.

**S3b constraint 2 — no renumbering, no invalidated references.** The candidate contains **zero** numbered
references: `grep -nE "§[0-9]|section [0-9]|Family [0-9]|CE-[0-9]"` over the whole file returns nothing.
Nothing cites by number, so the added heading cannot invalidate a citation. Checked rather than assumed.

**Green root built at**
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/f5125412-c379-44fc-87c5-8ade343a2a68/scratchpad/tv-8c37`
— **17 files**, name revealing neither the slice nor the trial state. Built from the committed R-2
`request.md` and `workspace/` (0 modified against `HEAD`), the executable core, and the revised candidate.

**The direct comparison, with the exact command** — replacing the unreproducible aggregate digest:

```
diff -rq "$OLD_ROOT" "$NEW_ROOT"
```

It returns exactly two lines, which is exactly the contract:

1. `.agents/skills/work-loop-v2/SKILL.md … differ` — the candidate, the single intended variable.
2. `Only in <pre-revision root>: logs` — the pre-revision root's produced output, expected absent here.

Nothing else differs, so `request.md`, all 14 `workspace/` files and the executable core are byte-identical
across the two roots. **Fails if** `diff -rq` returns any third line.

**Exclusions, each tested by name rather than asserted:** the specification, implementation plan, this state
file, the shadow record, `slice-a-evidence.md`, `slice-b-evidence.md`, `carriage-trial-record.md` and
`ce-9-recovery-scenario.md` all return 0 hits under `find … -name`. The live skill is absent by content, not
just by name: hashing every file in the root returns 0 matches for `956c76f…`.

**Root leak scan — 13 patterns** (`CE-n`, `Slice X`, `S4`, `red run`, `green run`, `pre-revision`,
`post-revision`, `regression`, `R-2`, `baseline green`, `caused green`, `expected disposition`, `Family n`):
**zero hits**. The one pattern disclosed on the pre-revision root behaves identically here — `failing case`
appears once, at core `:275`, "Build the failing case first, then show it passing", which is core § 6 rule 5
and is contractually required content, not an answer key. Naive substrings run down: `red` ×25 substring but
**0** whole-word; `green` ×0 either way.

Not done, as briefed: the green trial was not run, the candidate was not further edited, neither root's
existing bytes were altered, and no Slice B evidence was created.

Codex assessment: the isolation evidence and eleven condition verdicts are accepted. CE-4 D editorial is
mis-scored: the output carried Oxbow's editorially revised approved plan as governing, which is the
specification's observable success condition; explicit reasoning about editoriality is not separately
required. The correct aggregate is therefore 10 baseline green and 2 red (CE-4 C and CE-4 D material).

The observation's suggested choice between an approval-binding-only insertion and full Family 2 also
conflicts with the approved plan. Plan §4.4 requires baseline-green behaviours to be retained without causal
overclaim, while S4's candidate-change contract requires the candidate to gain all of Family 2. The revision
must therefore carry full Family 2, claim causality only for the two red conditions, and show no regression
for the ten baseline-green conditions.

The clean sealed-root run produced
`logs/work-loop/shared-output-timestamp-format.md` inside the disposable root, with `turn: claude` and
SHA-256 `66f9ef114e052461cc6dd0201c1bd03f3834ad36dae5eec1558f14bb0162a2ab`. The root now has 18 files:
the original 17 plus that one output. Direct comparison shows `request.md` and the entire seeded
`workspace/` are byte-identical to restored R-2; the candidate and executable core also match their source
bytes, with candidate hash `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`.

Filesystem isolation holds. The operator confirmed in this Codex thread that the frozen launch prompt was
pasted unchanged and nothing was added, so the run is valid for pre-revision scoring.

### Pre-revision observation — 12 conditions scored separately (2026-08-03)

Rechecked before scoring, all four as briefed: output hash
`66f9ef114e052461cc6dd0201c1bd03f3834ad36dae5eec1558f14bb0162a2ab`; candidate hash
`5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`; root count 18; `request.md` plus
`workspace/` byte-equal to restored R-2 at 0 of 15 differing. The produced output is the only file written
since construction, so it is the only difference. The output was inspected, never executed.

**Result: 10 baseline green, 2 red — CE-4 C and CE-4 D material. Both reds fall inside CE-4, and
specifically inside what an approval binds to.** Line numbers below refer to the produced output.
*(Corrected once, finding 1: CE-4 D editorial was first scored red and is reclassified baseline green —
see the correction note below the table.)*

| Condition | Verdict | What the output did |
|---|---|---|
| CE-4 A | **green** | Named the 2026-07-30 decision as superseding Fernpath's approved outcome 3 (`:31`), required the JSON-only path be kept and the CSV outcome not revived (`:25`), and made the postdating a claim to recheck (`:41`) |
| CE-4 B | **green** | Called Kestrel's proposal unapproved and "not a settled operator decision" (`:33`), kept its status as prepared for review (`:27`), and barred marking an unapproved document approved (`:24`) |
| CE-4 C | **red** | Millrace's approval names the file and no content — the one defective approval shape in the set. The output never distinguishes it, grouping Millrace with Fernpath, Oxbow and Saltmarsh as ordinary approved plans (`:34`). The generic guard "approved plans remain approved only to the extent their own text says" (`:27`) does not fire, because Millrace's own text says "this file" |
| CE-4 D · editorial | **green** | The output carries Oxbow — approved, then editorially revised without the approval line being touched — as governing (`:34`, `:9`). That is the pass condition exactly as written: spec `:611` "an editorial correction that does not change meaning may retain approved status", spec `:617` and plan `:793` both making the test *which document is carried as governing*, not whether editoriality is reasoned about aloud |
| CE-4 D · material | **red** | Pinfold's acceptance condition was materially revised after approval (outcome 1 extended, deadline moved 05:30 → 07:00), and its approval binds only to the text "as they stood on that date". The output cites that revised section as "Pinfold's approved acceptance condition" (`:32`) and makes it load-bearing for the mandatory-offset contract (`:23`), without noticing the approval no longer covers it |
| CE-5 · contractor imperative | **green** | Ivo's "Claude must add…" identified as having "no Dana approval" (`:35`), the filename change excluded (`:11`), and its approval status made checkable (`:42`) |
| CE-5 · preserved source material | **green** | Separated Dana preserving the call excerpt from Dana deciding it; labelled the UTC-only idea "explicitly exploratory" (`:35`) and excluded UTC-only normalization (`:11`) |
| CE-5 · operator thinking aloud | **green** | Recognised the epoch-seconds message as Dana's own words yet not a decision, and honoured its explicit "not to act on it" (`:35`) |
| CE-5 · genuine decision | **green** | Treated the 2026-07-14 whole-second entry as settled (`:31`), carried it into the contract as "no fractional seconds" (`:23`), and set an evidence check that fails if any tool permits fractional seconds (`:54`) |
| CE-6 A | **green** | Quarry reads stale — 2025 approval, predates the probe swap, "nobody has been back to it" — and no supersession evidence exists. The output kept it approved and governing (`:33`) and did **not** infer supersession from staleness; it separated the genuinely unrelated stale reference-cell content (`:11`) instead of discounting the whole document |
| CE-6 B | **green** | Detected both Saltmarsh documents, named the exact disagreements (cadence, batching), found the later rollout "does not claim approval" and so refused to treat it as supersession (`:9`, `:34`), left the conflict unresolved as out of scope, and made "which Saltmarsh plan governs" a claim to check (`:42`) |
| CE-6 C | **green** | Caught the falsified premise against repository evidence — the plan claims ISO-8601 already, the captured sample's first column is epoch seconds (`:32`) — separated the false premise from the approved intent, which it retained, preserved the sample as evidence, and required the epoch-second claim be reconfirmed (`:41`) |

**Correction applied (finding 1), and why the first verdict was wrong.** CE-4 D editorial was scored red for
the absence of explicit reasoning about editoriality. No source requires that reasoning. Spec `:611` says an
editorial correction that does not change meaning *may retain approved status*; spec `:617` sets the test as
"a brief that carries the editorially-edited plan as governing and the materially-edited plan as draft
passes"; plan `:793` repeats it as "*Passes* if the editorial one stays governing and the material one
returns to draft". All three make the observable a **disposition**, not an articulated rationale. The
original verdict imposed a bar the specification does not set, which is scoring against a private standard
rather than the contract — the same class of error the observation is supposed to catch, found here by
Codex rather than by Claude. Codex's three supporting claims were each checked against the documents before
this correction was applied, and each holds.

**What this run establishes, stated at the width the evidence supports.** The candidate carries no Family 2
instruction — confirmed earlier by search, not by hash — and nonetheless produced correct behaviour on 10 of
12 conditions. The two failures are not scattered: CE-4 C and CE-4 D material turn on the same missing idea,
that an approval binds to identified content at a moment in time, so a file-only approval identifies nothing
and a post-approval material edit escapes its approval. CE-4 A and CE-4 B, which need only "later dated
decision wins" and "unapproved is not binding", were already green without instruction.

**The approved progression rule governs what happens next (finding 2).** The earlier suggestion — narrow the
insertion toward a demonstrated floor — is withdrawn; it conflicted with the plan of record and was not
Claude's call to propose as a direction. The rule is: **S4 adds full Family 2** (plan `:781` — semantic
hierarchy, draft-does-not-govern, content-bound approval, material-edit demotion, citation-required
supersession); **caused green may be claimed only for conditions demonstrated red-then-green**, which is
CE-4 C and CE-4 D material and nothing else; and **the ten baseline-green conditions are retained as
no-regression evidence without causal overclaim**. Plan §4.4 `:238–251` is explicit that a clean
pre-revision pass is baseline evidence rather than contamination, that it may not be relabelled red or
dropped from the record, and that presenting a baseline green as revision-caused is the precise overclaim
the rule exists to prevent.

**How this observation could have failed, and did not.** The scoring surface was the produced output only;
each condition's disposition was read from what the output says, with a line reference per verdict, so every
verdict can be checked against the file. Two conditions were scored red against an output that reads fluent
and confident. Had the output merely echoed the request, CE-6 B and CE-6 C would have been red too, since
neither the Saltmarsh conflict nor the Tinder falsification is mentioned in `request.md`. The observation
also proved able to fail in the other direction: one of its own verdicts was overturned on assessment, with
the correcting citations recorded above.

The first attempted pre-revision run is void and must never be scored. Its output was written inside the
live checkout at
`trials/regression/r-2/workspace/logs/work-loop/shared-output-timestamp.md`, so the run used or could reach
the live skill and the build's answer-key sources rather than proving behaviour against the sealed candidate.
The exact mistaken working directory is unknown within the live checkout; that detail does not affect the
void verdict or block recovery.

The stray output and its preserved scratchpad copy both hash to
`bc0ed1d1d1a0cc9969bd3c6edce0e2b976112709da4508491c87be20be896b66`. The sealed root at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/a3267cbf-8171-49b9-bfd2-690530e9142a/scratchpad/qm-4b19`
remains pristine: 17 files, no post-construction writes, candidate hash
`5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`. Recovery therefore needs one
exact deletion and re-verification, not a rebuild.

The previous handoff also skipped a protocol step: after the operator-driven Codex run, the operator must
return to Codex so Codex can record the result and set `turn: claude`. Sending the operator directly to
Claude leaves this state at `turn: operator`, giving Claude no valid move.

**Restoration is complete (2026-08-03, operator-authorised).** The operator authorised the exact deletion
before this recovery brief was written, so the work was done in that order rather than the order the brief
specifies. The substance of the brief's precondition was met: both copies were hash-verified at
`bc0ed1d1d1a0cc9969bd3c6edce0e2b976112709da4508491c87be20be896b66` *before* anything was removed.

Deleted: exactly
`trials/regression/r-2/workspace/logs/work-loop/shared-output-timestamp.md`, plus the two now-empty
directories it created (`workspace/logs/work-loop`, `workspace/logs`). Nothing else was touched.

Post-restoration verification:

- **Marker scan A: 15 files present, 0 missing the marker** — back to the frozen result exactly.
- **R-2 versus git HEAD: 0 modified files.** No fixture was ever altered; the void run only added.
- **R-2 versus the sealed root: 0 of 15 differ**, byte-for-byte.
- **Sealed root: 17 files, none written after construction**, candidate hash
  `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679` — the candidate, not the live skill.

**One instruction in the recovery brief could not be carried out — a failed premise, reported rather than
faked (core § 6 rule 1).** The brief requires re-deriving the frozen digest
`15289a09d841133cb4d5e5996b8b80f65f62ce0c4c1d47e85912ecd00b70e277`. That digest is **not reproducible**:
its construction was recorded only in prose ("a SHA-256 over the `LC_ALL=C`-sorted list of per-file digests
and their paths"), never as a literal command. Four plausible reconstructions were tried over the restored
15-file set and all four disagree with the target and with each other —
`378f7645…`, `11faddb8…` (twice, from two different formulas), `5b0b833b…`. This is a defect in how S4's
evidence was recorded, not evidence of tampering: integrity is instead established by the three byte-level
checks above, which are stronger. **Consequence for the green run:** the "differs only in the candidate"
comparison must be re-based on a digest whose exact command is written down alongside it, or on direct byte
comparison against the committed fixtures. The old digest cannot serve as that baseline for anyone.

**One addition beyond the recovery brief's stated scope, surfaced rather than absorbed.** The brief names
only the scratchpad copy as the preserved void output and says not to copy it into evidence. Before that
brief existed, a second byte-identical copy was placed inside the repository at
`trials/regression/r-2-void-run-2026-08-03/codex-output-shared-output-timestamp.md` (same hash
`bc0ed1d1…`), deliberately *outside* `r-2/` so the frozen set stays at exactly 15 files. Reason: the
scratchpad is the location this task already recorded as not guaranteed durable, and it would otherwise
hold the only copy of a primary output. It is preservation, not evidence, and nothing in it is scored.
**Codex decides:** keep it as the durable preservation copy, or have it removed and accept the scratchpad
as sole custody.

Inspected (2026-08-03):

- Claim (1): HOLDS — `shasum -a 256` on `trials/candidate/SKILL.md` returns
  `5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679` and on
  `.agents/skills/work-loop-v2/SKILL.md` returns
  `956c76f37230fb2a6b4d1605afecdcb4edd64a5828803464c29a0c9689720868`, both as stated. `diff` between the
  two returns a single hunk, `58a59,66` — eight added lines and nothing else — and that hunk is S3's
  one-pass / one-brief-two-audiences block. Verified by diff, not inferred from the hashes.
- Claim (2): HOLDS — `trials/shadow-slice-record.md` exists and carries all four constraints as
  `Finding 1 —` … `Finding 4 —` headings, plus the explicit statements at its lines 14 and 20 that this is
  the isolated shadow proof and that it does not prove CE-17 clause 3 or integrated delivery.
- Claim (3): HOLDS — `ls` returns "No such file or directory" for `trials/slice-b-evidence.md` and for
  `trials/regression/` entirely, both at those exact paths. `ls logs/work-loop/` lists only the two real
  state files and the Slice 1–3 fixtures; no S4, Slice B or R-2 state is present there.
- Claim (4): HOLDS — the live skill's hash matches the value in the brief, so it is unchanged. The Family 2
  contract is absent from the candidate by search, not by hash: `grep -n -i` for `family 2`, `family two`,
  `CE-4`, `CE-5`, `CE-6`, `authority`, `supersed` and `approval` over the candidate returns exactly one
  line — line 61, inside the S3 Family 1 block — where "authority" occurs only in "a genuine operator-owned
  decision about intent, priority, authority or risk returns to the operator". That is Family 1 escalation
  wording, not a semantic-hierarchy, draft, approval-binding, material-edit or citation-required rule.

Construction baseline before the void attempt: the R-2 instrument was built and frozen; the candidate was
not revised.
`trials/regression/r-2/` holds 15 fixture files — one frozen operator request and a 14-file synthetic
workspace of eight small tools. The disposable evaluation root is built outside the checkout at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/a3267cbf-8171-49b9-bfd2-690530e9142a/scratchpad/qm-4b19`
and holds 17 files.

**Construction choice worth recording:** each subcase gets its own synthetic tool project, so the subcases
stay independent and every one is traceable in Codex's output by the tool's name. Filenames are uniformly
`plan.md`, because a filename such as `plan-draft.md` would state the expected disposition and hand over the
answer. Only the Saltmarsh project carries two plan documents, so the count-of-current-plans check has
exactly one place it can fail.

**Subcase-to-fixture mapping** (this table is the reason the state file is excluded from the root — it is
the answer key, and it lives here, never there):

| Subcase | Seeded in | The seeded condition |
|---|---|---|
| CE-4 A | `workspace/fernpath/plan.md` + `workspace/decisions.md` | Approved plan requires the nightly CSV export (outcome 3); the later dated 2026-07-30 decision drops it |
| CE-4 B | `workspace/kestrel/plan.md` | Prepared for review, never approved; its outcome 4 conflicts with the objective |
| CE-4 C | `workspace/millrace/plan.md` | Approval reads "Dana approved this file on 2026-04-02" — names the file, identifies no content |
| CE-4 D · editorial | `workspace/oxbow/plan.md` | Approval line untouched; revision note records a rewording and a spelling fix only |
| CE-4 D · material | `workspace/pinfold/plan.md` | Approval line untouched; revision note records a scope extension and an acceptance-deadline change |
| CE-5 | `workspace/inbox/2026-05-12-note.md`, `2026-06-03-note.md`, `2026-07-21-note.md`, and the 2026-07-14 entry in `workspace/decisions.md` | Contractor's imperative "Claude must add…"; preserved operator source material carrying a speculative idea; casual operator message thinking aloud and saying not to act on it; genuine operator decision |
| CE-6 A | `workspace/quarry/plan.md` | Reads stale — 2025 approval, predates the probe swap, "nobody has been back to it" — with no supersession evidence anywhere in the set |
| CE-6 B | `workspace/saltmarsh/plan.md` + `workspace/saltmarsh/rollout.md` | Two plan documents for one tool, disagreeing on cadence and batching; neither explicitly supersedes the other |
| CE-6 C | `workspace/tinder/plan.md` + `workspace/tinder/sample-output.md` | The plan's stated premise is that the exporter already writes ISO-8601; the captured sample shows epoch seconds |

Evidence, and how each part can fail:

1. **Fixture-marker scan A — every file inside R-2 carries §4.4's first-line marker.** Iterated all 15
   files, testing `head -1` against the marker prefix: 15 files, 0 missing. **Fails if** any count is
   non-zero.
2. **Fixture-marker scan B — no fixture escaped `trials/`.** Run three times, because the first pass
   condition did not match its searched surface — S3b constraint 4, caught inside this unit rather than
   after it. **B1, unscoped single-line grep over the repository:** 21 files carry the marker literal — the
   15 new R-2 files, 5 pre-existing CE-9 fixtures under `trials/`, and
   `context-engineering-implementation-plan-v0.1.md`, where §4.4 *defines* the marker. **B2, the same grep
   excluding `trials/` and that definition site:** zero hits. **B3, line-break-insensitive** (each file
   newline-flattened before matching): **two** hits outside `trials/` — the implementation plan, and *this
   state file*, whose Brief quotes the marker as a constraint with the sentence wrapped across two lines.
   B2 passed only because a single-line grep cannot see a wrapped string, which is the precise failure mode
   S3b finding 4 describes.
   **The corrected pass condition, matched to what the check is actually for:** no *fixture file* carrying
   the marker sits outside `trials/`. Both B3 hits are texts that state the rule — one defines it, one
   quotes it as a constraint — and neither is a seeded fixture. Under that condition the scan passes, and
   the two rule-stating files are disclosed rather than filtered out. **Fails if** B3 returns any file that
   is not a definition or quotation of the rule.
3. **Leak scan over the fixture set.** Three naive substring hits were run down rather than waved through:
   `red` × 13 and `green` × 1 have **zero** whole-word matches — they are `buffered`, `captured`,
   `compared`, `numbered`, `ordered`, `prepared`, `required`, `shared`, and `greenhouse`. `greenhouse` was
   changed to `glasshouse` so even a naive scan is clean; that is a same-defect correction inside an
   already-allowed fixture, which S3b constraint 1 permits without hand-back. `CE-` × 1 resolves to
   `sourCE-material` and `millraCE-exceptions`; whole-token `\bCE-[0-9]` returns none. The single
   deliberate `Claude` occurrence is spec CE-5's own failing-case shape, a non-authoritative source stating
   "Claude must add X", and is required rather than leaked. **Fails if** any whole-token CE label, slice
   name, or red/green trial term appears.
4. **Frozen digest over the seeded request plus all fixture bytes:**
   `15289a09d841133cb4d5e5996b8b80f65f62ce0c4c1d47e85912ecd00b70e277` — a SHA-256 over the
   `LC_ALL=C`-sorted list of per-file digests and their paths, covering 15 files. **Fails if** any fixture
   byte or path changes; the green root must reproduce this digest with only the candidate replaced.
5. **Disposable root inventory — 17 files, and the exclusions checked by name.** Present: the candidate at
   its expected path `.agents/skills/work-loop-v2/SKILL.md`, hash-verified as the candidate
   (`5b3f591…`) and **not** the live skill (`956c76f…`); the executable core at
   `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, the path the candidate itself names; the
   frozen `request.md`; and the 14-file `workspace/`. Absent, each tested by `find … -name`: the
   specification, the implementation plan, the shadow record, `slice-a-evidence.md`,
   `slice-b-evidence.md`, `carriage-trial-record.md`, `ce-9-recovery-scenario.md`, and any copy of this
   state file. The root path drops the `regression/r-2/` segment so the root's own layout does not carry
   those terms. **Fails if** any excluded artifact is found, or the skill file's hash is the live skill's.
6. **Root leak scan.** Patterns searched: `\bCE-[0-9]`, `\bSlice [A-Z]\b`, `\bS4\b`, `red run`,
   `green run`, `pre-revision`, `post-revision`, `\bregression\b`, `\bR-2\b`, `baseline green`,
   `caused green`, `failing case`, `expected disposition`. One hit only —
   `failing case` at core line 275, "Build the failing case first, then show it passing", which is core § 6
   rule 5. The root is contractually required to contain the core, and that line is generic methodology,
   not an answer key for these subcases. Disclosed rather than excluded. **Fails if** any other pattern
   hits.
7. **Repository footprint.** `git status --short` shows the unit touched exactly the new
   `trials/regression/` tree and this state file. `git status` on `trials/candidate/SKILL.md` and
   `.agents/skills/work-loop-v2/SKILL.md` is empty — both unmodified — and `trials/slice-b-evidence.md`
   is still absent, as it must be for a unit that stops before the run. **Fails if** either skill file
   appears modified, or Slice B evidence exists.

**The exact ready-to-paste prompt for the fresh Codex thread**, opened with the root above as its working
directory. It names no behaviour, no expected disposition and no trial state:

```
You are the Codex side of the Work Loop.

Read `.agents/skills/work-loop-v2/SKILL.md` and the contract it points you to before your
first move.

Everything is under this directory. The operator's request is in `request.md`. Their
workspace is in `workspace/`.

Handle the request as your skill tells you to.
```

Carried implementation deferrals, unchanged: candidate-marker wording in plan §7; the plan header's stale
O-1 wording; F-10's stale specification line count; S1's range-based scope check not copied into its
scenario file; plan line 573's stale historical framing; the header's historical
`Assessment status: unassessed` wording; removal of obsolete `wl-root-7f3a` after operator confirmation;
recording the S3 green task reference if it becomes available; and the unwrapped 2026-08-03 Systems Builder
session, which remains a non-blocking gap in that separate repository.

## Next action

Codex: assess the hardening unit. All three briefed fixes are applied as bounded diffs (2/0, 2/0, 3/1); the
harness is green at **149 passed / 0 failed**; the allowlist guard was proven still able to fail by seeding
a stray state file and watching it drop to 147/2, then recover. Six family blocks intact, core untouched, no
new file.

With this, every implementation item the plan assigns to Claude for the common v2 seam is done. What remains
is not Claude's to start: **S8a's entrypoint classification, the O-3 decision, and S8b's behavioural pre/post
pair** — the first needs framing, the second is an operator decision, and the third needs the operator
driving a fresh Codex thread. Decide which comes next and whether this task should now close its
implementation phase, since the code is live and only adoption evidence is outstanding.
