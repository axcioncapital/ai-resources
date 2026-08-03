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
Standard. S4 Slice B, one bounded correction to the pre-revision observation. The clean run remains valid;
only the CE-4 D editorial verdict and the resulting revision-width conclusion are frozen for correction.

Named reason for the implementation loop: the work spans multiple sessions, its scope must remain bounded
across S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
The valid-root filesystem result and its operator-held launch fact are both established. Claude now observes
the pre-revision output without executing the synthetic task or changing the candidate.

**Claude's observation after that confirmation:** inspect, do not execute, the primary output at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/a3267cbf-8171-49b9-bfd2-690530e9142a/scratchpad/qm-4b19/logs/work-loop/shared-output-timestamp-format.md`.
Score CE-4 A, B and C separately; CE-4 D editorial and material separately; each of CE-5's four semantic
roles separately; and CE-6 A, B and C separately against the constructed cases recorded below. Label every
condition baseline green or red; do not collapse them to one verdict per behaviour.

**Evidence and exclusions:** recheck output hash
`66f9ef114e052461cc6dd0201c1bd03f3834ad36dae5eec1558f14bb0162a2ab`, candidate hash
`5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679`, the 18-file root count, and direct
byte equality of `request.md` plus `workspace/` with the restored R-2 fixture. The root output must be the
only difference. Do not run the synthetic task, edit the candidate, create Slice B evidence, score the void
output, or touch either root. Report the per-condition result in this state, set `turn: codex`, commit only
the canonical state update, and stop.

## Latest material result

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

**Codex — closure check on the one correction.** Both frozen findings are resolved and the correction is
complete.

- **Finding 1 — resolved.** CE-4 D editorial reads **green**, with the pass condition cited from spec `:611`,
  spec `:617` and plan `:793`. The aggregate reads 10 baseline green / 2 red at every occurrence; the two
  reds are CE-4 C and CE-4 D material. A grep for the superseded figures returns no stale statement.
- **Finding 2 — resolved.** The narrowing suggestion is withdrawn in terms and replaced by the approved
  progression rule, cited to plan `:781` for the full-Family-2 candidate change and plan §4.4 `:238–251` for
  baseline-green retention without causal overclaim.
- **Did the correction break another condition line?** No. The other eleven verdict cells and their
  reasoning are unedited; the table still carries twelve conditions and now reads 10 green / 2 red, which
  matches the corrected aggregate. Nothing outside the observation was touched: the candidate is still
  `5b3f591…`, both roots are unchanged, `trials/slice-b-evidence.md` is still absent, and this state file is
  the only file in the commit.

**Deferral, recorded and not acted on** (core § 3 — noticed during the closure check, so it does not become a
second correction round). Plan `:812` states S4's exit as "all three behaviours demonstrated red-then-green".
With CE-5 and CE-6 both baseline green across all seven of their conditions, that exit cannot be met as
written, and plan §4.4 `:238–251` forbids the only routes that would meet it — relabelling a baseline green
as red, or re-running against a tuned scenario. So S4's exit condition and §4.4 now point in opposite
directions on the same result. This needs a decision from Codex or the operator before S4 can be declared
complete; it is stated here rather than resolved, and it changes nothing in the observation above.

Carried items, unchanged: the void preservation copy stays excluded pending operator-authorised cleanup;
the green comparison uses direct byte comparison against committed R-2 fixtures, not the unreproducible
historical aggregate digest; and the implementation deferrals listed above.
