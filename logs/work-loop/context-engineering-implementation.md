---
task: context-engineering-implementation
turn: operator
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the implementation plan,
one evidence-gated session at a time. Phase 1 is complete; S2, S3 and S3b are accepted.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, reapproved
by the operator on 2026-08-02 against `e1ce895b3da1387bae7ce50623afc3875cb050ba`.

## Current lane and unit
Standard. S4 Slice B, pre-revision-run recovery. The first attempted run is void because it executed inside
the live checkout against the live skill with answer-key material reachable. The candidate is unchanged;
no subcase is scored and no Slice B evidence exists.

Named reason for the implementation loop: the work spans multiple sessions, its scope must remain bounded
across S1–S12, and each result needs assessment by someone other than its builder before progression.

## Brief
The sealed evaluation root is still pristine, so S4 needs restoration and one clean rerun rather than a
rebuild. Deleting the single trial-generated file inside R-2 is destructive and therefore remains stopped
until the operator explicitly authorises that exact deletion.

**Recovery after authorization:** Claude must first verify that both the stray file and the preserved copy
have SHA-256 `bc0ed1d1d1a0cc9969bd3c6edce0e2b976112709da4508491c87be20be896b66`, then delete only
`plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-2/workspace/logs/work-loop/shared-output-timestamp.md`.
It must re-derive the original 15-file frozen digest
`15289a09d841133cb4d5e5996b8b80f65f62ce0c4c1d47e85912ecd00b70e277`, restore the marker result to
15 present / 0 missing, and confirm the disposable root still has 17 files with candidate hash
`5b3f591b9525bc2046494184e9968bf6f46735ad78f0c01c2c78cb4cb6896679` and no produced output.

**Scope and exclusions:** the preserved void output remains at
`/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/f5125412-c379-44fc-87c5-8ade343a2a68/scratchpad/r-2-run-preserved/shared-output-timestamp.md`.
Do not score it, copy it into evidence, rebuild fixtures, revise the candidate, create Slice B evidence or
touch any other R-2 file. If any verification fails, stop without deleting.

**Corrected handoff:** after restoration Claude sets `turn: operator` and repeats the exact disposable-root
path and frozen prompt. The operator opens the fresh Codex thread with that absolute path as its actual
working directory; after the run, the operator returns to Codex first so Codex can record the result and set
`turn: claude` for observation. Do not send the operator directly to Claude while this canonical state still
says `turn: operator`.

## Latest material result

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

Restoration and re-verification are **already done** — see Latest material result. The recovery brief's
remaining asks are therefore reduced to the two facts it wanted for the record, plus the clean rerun.

**Operator — two things.**

1. **State two facts for the void-run record** (neither blocks the rerun): whether the frozen prompt was
   pasted unchanged, and the mistaken working directory, or `unknown within the live checkout` if not known.
2. **Drive the clean rerun.** Open a fresh Codex thread whose actual working directory is the absolute path
   below — this is the single thing that went wrong last time — and paste the frozen prompt recorded above,
   unchanged. Change nothing in the root before or during the run.

```
/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/a3267cbf-8171-49b9-bfd2-690530e9142a/scratchpad/qm-4b19
```

Confirm before pasting that the thread's working directory really is that path and not the `ai-resources`
checkout. If the run's output lands anywhere under `plans/work-loop-v2-v0.2/`, the rerun is void for the
same reason as the first and must be stopped rather than scored.

**Then return to Codex first, not to Claude.** Codex records the result and sets `turn: claude`; only then
does Claude observe the eight seeded subcases. This state stays `turn: operator` until Codex changes it.

**Two Codex decisions are pending** (both in Latest material result, neither blocking the rerun): whether to
keep the in-repository preservation copy of the void output, and how to re-base the green run's
"differs only in the candidate" comparison now that the frozen digest is known to be unreproducible.

Carried recovery deferral: the sealed root is in a scratchpad path and should be rerun promptly. Note that
rebuilding it "from the frozen digest" is **no longer available** as a fallback — the digest cannot be
reproduced. The available fallback is rebuilding from the committed R-2 fixtures, which are clean at HEAD.
