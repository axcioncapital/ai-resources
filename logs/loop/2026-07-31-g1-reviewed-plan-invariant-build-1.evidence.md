UNIT: 2026-07-31-g1-reviewed-plan-invariant-build-1   STREAM: 2026-07-31-g1-reviewed-plan-invariant   PHASE: build
REPO: ai-resources                                    BASE: 6050a5b83f976583154f79ecfd5335691ba3d156    NEXT: Claude writer (Prove unit, a later invocation)

# Build evidence — Slice 1 / S1, G1 reviewed-plan integrity

Status: **complete.** Append-only (`docs/work-loop.md` § Artifacts).

Governing authority: `docs/work-loop-repair-workflow.md` § Stage 7.
Role: Claude repository engineer — sole writer, ownership acquired this session.
Working directory for every command below: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-g1-reviewed-plan`.

**S1 implementation commit: `8762fc7fc413d1149eb3dec531d235bc368d1108`.** One commit, four files —
`git revert` of it restores the approved base state of every object under repair (plan-v4 §12).

---

## 1. Ownership acquisition and binding verification

Verified against Git **before any write**, per `…repair-workflow.md` §6.1 and §7. The previous writer
released ownership in the handoff commit `833762c2a0570287f0e9ec31743bdeffbac59a2e`; this session
**explicitly acquires** sole-writer ownership of this worktree. Acquisition is not inferred from a new
chat (§7).

| Field | Asserted by handoff-2 | Verified | Method |
|---|---|---|---|
| Repository | `ai-resources` | match | worktree toplevel |
| Worktree | `…/Axcion AI Repo/ai-resources-g1-reviewed-plan` | match | command cwd |
| Branch | `codex/2026-07-31-g1-reviewed-plan-invariant` | match | `git rev-parse --abbrev-ref HEAD` |
| HEAD at acquisition | handoff commit is branch tip | `833762c2…` | `git rev-parse HEAD` |
| Approved base | `6050a5b83f976583154f79ecfd5335691ba3d156` | ancestor | `git merge-base --is-ancestor …` → true |
| Worktree state | clean | clean | `git status --porcelain` → empty |

**The G1-approved object still holds its approved identity.** This is the check that matters most:
any mutation of plan-v4 would have voided G1 (`…repair-workflow.md` §9.2, §11).

| Object | Command | Observed |
|---|---|---|
| Plan-v4 at its declared commit | `git rev-parse df45a2b1…:{plan-v4}` | `9ae4839afc8ccb23c4bd50a2644f32213273ed90` |
| Plan-v4 at HEAD | `git rev-parse HEAD:{plan-v4}` | `9ae4839afc8ccb23c4bd50a2644f32213273ed90` — **byte-identical, G1 intact** |
| Review-2 at its declared commit | `git rev-parse 12b22dd9…:{review-2}` | `848ee9f940c562f421c6ef727e358d21c73a299f` |
| Review-2 at HEAD | `git rev-parse HEAD:{review-2}` | `848ee9f940c562f421c6ef727e358d21c73a299f` — binding relation holds |

**The four objects under repair were byte-identical to the approved base at acquisition**, so plan-v4
§13.8's line numbers resolved as written and no re-derivation was needed:

| Path | Blob at base and at acquisition |
|---|---|
| `docs/work-loop.md` | `88f555e630a4ae898d0eb6d1827d908faf1bf81a` |
| `.agents/skills/work-loop/SKILL.md` | `33986fb80e15fd26600a619793cef37e79c5650a` |
| `.claude/commands/work-loop.md` | `0e575aa5dab40a07927bd6cc3cf9af07940401f0` |
| `templates/capability-record.md` | `f0580c9e98f45232d83d1cf6d707b39c9e186acf` |

`git diff --stat 6050a5b HEAD -- <the four paths>` → **empty** at acquisition. Every premise the Build
brief states was confirmed; none was rejected.

---

## 2. What was implemented

Plan-v4 §7's single atomic slice, ordered steps 1–4, step 4 last.

| Step | File | Landed as |
|---|---|---|
| 1 | `docs/work-loop.md` | New section **§ Reviewed-object identity and the G1 precondition** at `:100–247`, plus seven targeted amendments (below) |
| 2 | `.agents/skills/work-loop/SKILL.md` | New section **§ Reviewing a Shape plan** at `:68`; `:42` corrected |
| 3 | `.claude/commands/work-loop.md` | Shape-unit steps 3–7 rewritten at `:128–145`; header-repair block `:149–157`; blocker stop `:159–166`; `hold-reframe` close `:168`; record transition `:215–227`; `:272` and Step 8 corrected |
| 4 | `templates/capability-record.md` | Line 98 only |

**Contract amendments, each keyed to the line it corrected in blob `88f555e6…`:**

| Was | Now | Why |
|---|---|---|
| `:83` G1 held package named "the plan, the pre-implementation review…" | identities, never names | §6.6 |
| `:94` `review-2` bar | cites § Correction lifecycle for the full sequence | §6.9 |
| `:102` "at most one review round" | "one review lifecycle — …no `review-3`" | §6.13, A18 |
| `:109` stream "carried forward unchanged" | plus the single `hold-reframe` allocation exception | §6.10, A15 |
| `:144` `-{n}` ordinal | `n ∈ {1,2}`; `n ≥ 3` does not exist | §6.12, A16 |
| `:184` `REVIEW` block row | Shape reviews additionally carry the three-line plan identity | §6.3, A2 |
| `:196`/`:198` "Four outcomes" | **Five**, adding `hold-reframe` | §6.9, A13 |
| `:210` "Three outcomes close a unit that never altered the object" | **Four**, and `hold-reframe`'s evidence carries both identities | §6.9 |

---

## 3. Acceptance criteria — A1 to A20

Every row states the command or inspection, the expected observation, what was actually observed, and
the verdict. Working directory as declared above; scope is the four in-scope files unless stated.

| ID | Check | Expected | Observed | Verdict |
|---|---|---|---|---|
| **A1** | Plan identity = path + commit + blob, binding relation, full-40-hex | defined | `docs/work-loop.md:106–116`; binding relation at `:116`, abbreviated SHAs rejected explicitly | **PASS** |
| **A2** | Contract **and** `SKILL.md` require the three-field Shape header | both | `grep -n 'PLAN-COMMIT: {40-hex}'` → `docs/work-loop.md:138` **and** `SKILL.md:74` | **PASS** |
| **A3** | Command validates header **before** transcription | ordering present | `.claude/commands/work-loop.md:131` (validate) precedes `:132` (transcribe); `:131` states "Validate first, transcribe second" | **PASS** |
| **A4** | Comparison after adjudication, before G1, hard-stopping on mismatch/missing/malformed/inconsistent/uncommitted | present with all five stop conditions | `:133`, sitting between adjudication (`:132`) and G1 (`:134`); all five enumerated | **PASS** |
| **A5** | Review identity defined, computed after transcription+commit, verified before G1 | defined | contract `:118–130`; computation rule at `:130`; command `:132` computes, `:133` verifies | **PASS** |
| **A6** | G1 package displays plan **and** review identities, not names | identities | contract `:163–175`; command `:134–143` table; both state a bare-name package fails | **PASS** |
| **A7** | `unassessed` cannot satisfy challenged-Shape G1; unreachable reviewer stops, unit stays open, blocker handoff, no gate, no CLOSE outcome | denial + open unit | contract `:176–187`; command `:159–166`. `grep -n 'unassessed'` shows the old G1 path at former `:134` is **gone**; surviving uses are the denial itself, the template's evidence axis, and the reviewed/Prove fallback | **PASS** |
| **A8** | `HEADER-REPAIR` receipt records date · consumed allowance · named plan identity · verdict, finding IDs, material/minor counts — **before** any re-emission request | four fields, receipt first | contract `:193`; command `:151`, whose step 1 is "before requesting anything" and precedes the request at `:153` | **PASS** |
| **A9** | Re-emission header-only; verdict/ID/count mismatch stops before G1 | both | contract `:195`; command `:153` (header-only), `:155` (mismatch → stop) | **PASS** |
| **A10** | Cap of one, **provable from the repository after restart**; not `review-2`; no budget; no `hold-reframe` | resume rule + disclaimers | contract `:197` resume rule + `:201` disclaimer; command `:155` + `:157` | **PASS** |
| **A11** | Materiality defined; ambiguity resolves material; non-material note provably cannot mutate the plan | both halves | contract `:241–247`: nine-item list, "Ambiguity resolves as material", "annotated, never mutated in… cannot change the plan's blob" | **PASS** |
| **A12** | Lifecycle: 1 initial · ≤1 material correction · ≤1 `review-2` · no `review-3` | stated | contract `:205–217`, restated at `:94`, `:251`, `:293`; command `:272` | **PASS** |
| **A13** | `hold-reframe` terminal Shape-side outcome for unresolved material `review-2` only, complete close path with durable pointer, creates no gate | all four | contract `:219–225` + `:357–366`; "terminal for the stream and it is not a gate" at `:223`; Shape-only reservation at `:225` | **PASS** |
| **A14** | Capability transition complete — `## Units` · `active_unit: none` · `status: paused` + `reopen_trigger:` · `## Pointers` before deletion · `## Current phase and next action` | five steps | contract `:227–235`; command `:215–223`. Per-token counts in the command: `## Units` 5, `active_unit` 11, `status: paused` 2, `reopen_trigger` 3, `## Pointers` 4, `## Current phase and next action` 2 — all non-zero | **PASS** |
| **A15** | Continuation **allocates** and updates `stream:`, held stream preserved in `## Pointers`; exception for `hold-reframe` only; ordinary carry unchanged | exception scoped | contract `:237–239`, command `:225–227`, each stating "for `hold-reframe` and for nothing else". Control: ordinary carry survives at contract `:258` and command `:209` | **PASS** |
| **A16** | `review-{n}` path defined, `n ∈ {1,2}` (closes OF-2) | defined | contract `:293`; command `:132` generalises the previously hard-coded `review-1.md` | **PASS** |
| **A17** | Template `:98` includes `hold-reframe`; line 7 status axis unchanged | one line, `:7` intact | `git diff` vs base → **1 insertion, 1 deletion**, the `## Units` row; `:6–7` byte-identical to base | **PASS** |
| **A18** | No "at most one review round" in contract or `SKILL.md` | **zero** | `grep -nE 'at most one review round'` on both → **zero matches**. **Positive control:** same regex against `git show d44a4fc:docs/work-loop.md` → fires at `:102`, so the regex can detect the string | **PASS** |
| **A19** | Exactly G1, G2, G3 — no fourth gate in any of the four files | zero bar existing prose | `grep -nEi 'G4\|fourth gate\|four gates'` → one hit, the **pre-existing** `docs/work-loop.md:96` "not a fourth gate", which the criterion's control tolerates. No new occurrence added. **Control:** `grep -c 'G1'` → 22 (contract), 12 (command) — non-zero, so the corpus is searchable | **PASS** |
| **A20** | base→HEAD diff touches only the four files plus this stream's `logs/loop/` artifacts | bounded | `git status --porcelain` before commit → exactly the four `M` entries, nothing else. `git diff --name-only 6050a5b HEAD` → `docs/work-loop-repair-workflow.md` + this stream's `logs/loop/` artifacts + the four files. **Control:** `git diff --name-only 6050a5b HEAD -- docs/work-loop.md` → non-empty after S1 | **PASS** |

---

## 4. Verification fixtures — plan-v4 §11

### 4.1 Plan-identity fixture (V-M1, V-M2, V-M5) — the real failure, on real objects

Zero mutation, no branch switch. Blobs re-derived this session and matching plan-v4 §11.1's declared
values exactly.

| ID | Case | Command | Expected | Observed | Verdict |
|---|---|---|---|---|---|
| **V-M1** | What `review-2` inspected (v2) vs what G1 received (v3), 2026-07-29 stream | `git rev-parse 1dc38b3:{…plan-v2.md}` vs `…plan-v3.md` | differ → blocks | `4e97dc9b7aed5c8a46868c9c68b4bcf2cfbac825` vs `ca274137f9e99460a29e3607f7e2d36079eba1a7` → **DIFFER, blocks** | **PASS — the historical failure is caught** |
| **V-M2** | v3's identity against itself | same command twice | equal → passes | `ca274137…` = `ca274137…` → **EQUAL, passes** | **PASS — positive control** |
| **V-M5a** | Truncate a SHA to 7 hex | string compare | blocks | `ca27413` ≠ `ca274137…` → blocks | **PASS** |
| **V-M5b** | v2's path stated with v3's blob | `git rev-parse` on the v2 path | blocks | path resolves `4e97dc9b…`, header claims `ca274137…` → blocks | **PASS** |
| **V-M5c** | Drop a field | presence test on empty `PLAN-BLOB` | blocks | absent → blocks | **PASS** |

**V-M2 is the positive control for the whole comparison**, and it is why V-M1 alone would not have been
evidence: a check that blocked everything would also "pass" V-M1 while being useless (F2). Both
directions ran; both behaved as specified.

### 4.2 Review-identity fixture (V-R1, V-R2, V-R3)

Run against a real artifact this stream produced, not a constructed one.

| ID | Case | Command | Expected | Observed | Verdict |
|---|---|---|---|---|---|
| **V-R1** | Binding relation holds | `git rev-parse "${RC}:${RP}"`, RC=`96b27e53…`, RP=review-1 | `eb827a67…` | `eb827a6715355ed10a82fce3fede46b128864bd9` | **PASS — positive control** |
| **V-R2** | Stated blob wrong | same commit+path vs `848ee9f9…` | differs → blocks | differs → blocks | **PASS** |
| **V-R3** | Abbreviated `REVIEW-COMMIT` | 7-hex field vs required 40-hex | malformed → blocks | length 7 ≠ 40 → blocks | **PASS** |

### 4.3 Header-repair receipt (V-H1 to V-H4)

| ID | Check | Expected | Observed | Control | Verdict |
|---|---|---|---|---|---|
| **V-H1** | Receipt written and committed **before** the re-emission request | ordering present | command `:151` step 1 ("before requesting anything") precedes step 2's request at `:153`; heading `:149` states "the receipt is written first" | Block read in sequence | **PASS** |
| **V-H2** | Contract names the four recorded fields and the header-only rule | ≥1 `HEADER-REPAIR` | `grep -c 'HEADER-REPAIR' docs/work-loop.md` → **2**; four fields enumerated at `:193`; header-only at `:195` | `grep -c 'PLAN-BLOB' docs/work-loop.md` → **6**, non-zero | **PASS** |
| **V-H3** | Contract states the resume rule keyed on the committed receipt | ≥1 `allowance` in resume text | `grep -n 'allowance'` → `:193`, `:195`, `:197`; `:197` is the resume rule | as V-H2 | **PASS** |
| **V-H4** | M8 and M9 are expressible — both reach a stop | traceable | **M8** (different verdict/IDs/counts): contract `:195` → "the allowance does not cover it: stop before G1"; command `:155`. **M9** (post-restart re-offer): contract `:197` → "no further re-emission is permitted"; command `:155` requires reading the evidence *before* requesting | Both paths traced through the written steps | **PASS** |

### 4.4 Capability transition (V-C1, V-C2, V-C3)

| ID | Check | Expected | Observed | Control | Verdict |
|---|---|---|---|---|---|
| **V-C1** | Five close steps keyed to existing fields/sections | ≥1 each | all six tokens non-zero in the command (§3 A14 row) | `grep -c 'active_unit' .claude/commands/work-loop.md` → **11**, non-zero | **PASS** |
| **V-C2** | Allocation exception scoped to `hold-reframe` only | exactly one, named | one statement per surface — contract `:237`/`:239`, command `:225`/`:227` — each naming `hold-reframe` | `grep -n 'carried forward unchanged\|carried unchanged'` → contract `:258`, command `:209` — the ordinary carry rule still present | **PASS** |
| **V-C3** | Template `:98` carries `hold-reframe`; `:7` unchanged | one line | `git diff … -- templates/capability-record.md` → `1 file changed, 1 insertion(+), 1 deletion(-)`, the `## Units` row | `:6–7` compared to base output — byte-identical | **PASS** |

### 4.5 Falsifiers F1 to F12

None fired. F1/F5 are prevented by the fail-closed precondition (A4, V-M1, V-M5); F2 by the V-M2
positive control passing; F3 by § Materiality's no-mutation rule (A11); F4/F7 by the lifecycle and the
one-shot cap (A12, A10); F6 by the blocker stop leaving the unit open (A7); F8 by the receipt
comparison (A9); F9 by the identities-not-names package (A6); F10 by the five-step record transition
(A14); F11 by A19's zero new occurrences; F12 by A20's bounded diff.

---

## 5. Discoveries recorded and deferred — not implemented here

Work worth doing but outside the G1-approved slice is a deferred finding, never a quiet extra edit
(`…repair-workflow.md` § Stage 7).

- **BF-1 — `.agents/skills/work-loop/SKILL.md:98` cites `/qc-pass`, which is retired.** Workspace
  `CLAUDE.md` records `/qc-pass` as retired 2026-07-30. The line is a stale citation in the
  "when you cannot reach the object" fallback. **Deferred** — it sits in a section plan-v4 §7 step 2
  does not touch, and the slice authorises only the header carrier and the `:42` correction.
  Reopening trigger: any slice that touches the skill's fallback text, or a repo-wide retired-command
  sweep.
- **BF-2 — the Prove unit's review path is still hard-coded `review-1.md`** at
  `.claude/commands/work-loop.md:178`. Plan-v4 §6.12 closed OF-2 by naming `:131` (the Shape path)
  specifically, and that is what was generalised. The same generalisation is arguably right for Prove,
  but it was not in the approved step list. **Deferred** — Prove-side review mechanics belong to
  Slice 3. Reopening trigger: Slice 3, or a Prove unit that actually needs `review-2`.

---

## 6. Implementation judgments, declared

Two places where the approved design had to be *rendered* into the durable files, and the rendering was
a judgment. Both are recorded so a reviewer can overturn either without re-reading the diff.

1. **The blocker handoff is specified by its required content, not by citing the repair workflow.**
   Plan-v4 §6.7 describes it as "the `…repair-workflow.md` §6.2 envelope shape, naming the plan
   identity, why it is blocked, and what unblocks it". `docs/work-loop.md` is a durable contract and
   `docs/work-loop-repair-workflow.md` is by its own §1 a *temporary* authority that ends when the
   operator closes the repair program — so a citation from the contract to it would dangle. The
   contract therefore requires the six-field block header it already owns, plus exactly the three
   content items §6.7 names. **The required content is identical; only the reference is different.**
2. **Step 7's general `unassessed` fallback was given a one-clause pointer to the challenged-Shape
   denial** (`.claude/commands/work-loop.md:266`). A7 requires that the command have *no* G1 path
   reachable from `unassessed`. Step 5a's blocker stop establishes that, but a reader arriving at
   Step 7's fallback first could still have read it as permitting one. The clause states the same rule
   §6.7 already sets and adds no new behaviour; without it A7 would rest on reading order.

Neither changes scope, and neither required mutating plan-v4 — which remains at blob `9ae4839a…`.

---

## 7. Budget and gates

Build carries **no review and no gate** (`.claude/commands/work-loop.md` § Build units;
`…repair-workflow.md` § Stage 7). The next independent review is Prove's, before G2. Nothing in this
unit opened a gate, and G2 has not been reached.

| Item | Status |
|---|---|
| Shape unit's correction budget | Fully spent in that unit — review-1, one correction pass, review-2. Not touched here |
| This unit's review | **None by design** — Build holds no review |
| Gates passed this unit | **None.** G1 was passed by the operator in the Shape unit; G2 and G3 remain closed |

**`Status: complete` here, and no `CLOSE` block — both deliberate.** The marker is accurate: Build's
work is finished and no session should resume it. No `CLOSE` block is written because `/work-loop`'s
own close-and-resume machinery does not govern this repair (`…repair-workflow.md` §1, §13.1) — the
handoff is the resume mechanism (§14). This mirrors the Shape unit's stance, which withheld the marker
for the same reason and in the opposite direction: that unit is genuinely still open, this one is
genuinely done.

---

LIMITATIONS: These are documentation and instruction changes. Every criterion above was verified by
text inspection, git identity arithmetic against real historical blobs, and diff bounds — **none of it
demonstrates that a future session will obey the instructions**, which is behavioural and needs a live
challenged Shape-to-G1 run. Scenarios **M8** (a re-emission with changed verdict/IDs/counts), **M9** (a
post-restart re-offer) and **M10** (a capability `hold-reframe` and its continuation) are expressible
in the written steps and were traced there, but **were not executed** — they cannot be staged before
the slice exists, and belong to Stage 9 (Use), exactly as plan-v4 §11.6 declared. The residual
declared at plan-v4 §13.4 is unchanged and was implemented as approved: matching verdict, finding IDs
and counts detects a substituted or renumbered review, **not** one whose reasoning changed beneath an
unchanged ID set. §13.5's "no validator is introduced" and §13.6's "the §6.10 allocation exception is
stated, not enforced" both hold — nothing here mechanises any check; Slice 5 owns enforcement. Every
identity in this file was computed against Git in this worktree; none is asserted. Line numbers are as
of the S1 commit `8762fc7f…` and will move if any of the four files changes.

Status: complete.

---

## 8. Entry 2 — 2026-07-31 — three verdicts in §3 superseded as incorrect

Appended after this unit closed. **Nothing above is rewritten** — evidence is append-only, not
immutable (`docs/work-loop.md` § Artifacts), and §3's table stands unedited as the record of what was
claimed at the time. The precedent is the Shape unit's Entry 3 → Entry 4 supersession.

Independent Prove `review-1` (commit `34563750a3fa80c0e3a8c112616a8a58d57026f6`, blob
`1144ef835547864e43bcbe5fcda8baa25a237527`) returned **REVISE BEFORE G2** with two material findings.
Three verdicts in §3 above were wrong, and all three were mine:

| Criterion | §3 claimed | Correct verdict for the S1 candidate | Why §3 was wrong |
|---|---|---|---|
| **A13** | PASS | **FAIL** | I cited the contract's Shape-only reservation at `:225` and never checked the general Step 7 sentence I had written in the same commit, which stated the `hold-reframe` branch with no phase qualifier |
| **A16** | PASS | **FAIL in consumer coherence** | Contract-side was correct; I did not test it against the Prove branch that the unqualified rule reached |
| **A20** | PASS | **FAIL as A20 was written** | The row's own observation listed `docs/work-loop-repair-workflow.md`, a path outside the expected set, and I recorded PASS against it. A claim contradicted by the evidence in the same row |

**Current status of each**, after the Prove correction pass (commit `e384d8c383c226f00176abe6956bf5f5c29acab8`)
and the operator's Slice-1 scope binding — measured in `…-prove.evidence.md` §4:

| Criterion | Now |
|---|---|
| A13 | **PASS** — the terminal branch is confined to a challenged Shape review point at five sites |
| A16 | **PASS** — no rendering routes a Prove unit to `hold-reframe`; BF-2 returns to a genuine deferral |
| A20 | **PASS** under the operator's explicit Slice-1 binding, with the blob condition met and a positive control |

**One further correction to this file's reasoning.** §5's BF-2 entry, and my later adjudication of it,
accepted that the generic Step 7 rule made a Prove `review-2` newly operational. **Verified and
false:** the approved base already permitted it — `git show 6050a5b:.claude/commands/work-loop.md`
line 224 reads "A second review round is `review-2` and is justified only when…", inside the same
Step 7, and the base Prove branch at line 144 already hard-coded `review-1.md`. `hold-reframe` appeared
**zero** times in either file at base. So S1 introduced the `hold-reframe` leak and **not** the Prove
`review-2` path; BF-2's imprecision is pre-existing and unchanged by S1. The deferral was correct; the
reason given for questioning it was not.

Status: complete (unchanged — this unit remains closed. This entry corrects its record, not its state).
