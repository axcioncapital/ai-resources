---
task: work-loop-v2-dispatcher-reliable-supervised-use
status: active
turn: codex
---

## Objective and scope

Implement `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete Gate SA acceptance contract and independent adoption review, while preserving the plan's fixed supervised-use boundary.

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, live trials, and the synchronous regression gate named by the plan. Excluded throughout: Gate ST, Gate U, unattended or walk-away release claims, dispatcher rewrite or language migration, merge, push, deployment, destructive cleanup, and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 7 — bind results to the expected run identity.

Named reason for the loop: the objective spans multiple bounded implementation and proof units, must survive session boundaries, and requires independent Codex assessment before it can count as complete.

## Brief

Change set A remains the active plan phase. Unit 6 is accepted at `850f38174ea929cabed6e04d6135d2e2c0d37a3d`: the dispatcher now has one bounded read-only structural validator for its exact v1 terminal result, while no dispatcher route consumes it. Bind that structurally valid artifact to dispatcher-owned expected identity now; result waiting and transition consumption remain later units.

Dominant deliverable: one read-only identity-validation boundary that proves a structurally valid v1 artifact is the exact result promised for the expected task, checkout, and run.
Evidence required in this hop: a targeted red/green case shows a real result validates for its dispatcher-owned expected identity while a structurally valid copy presented as another run is rejected; focused controls reject a task or checkout mismatch and a symlinked result path.
Evidence explicitly deferred: outcome/code and other semantic cross-field validation; integration into a dispatcher transition, status, wait loop, or any first consumer; finite producer-consumer waiting; missing-result blocking; terminal families A–C, M, and N; moving run identity earlier; durable crash-boundary injection and the full write-order/recovery contract; the remaining hostile value/encoding matrix; Change sets B–D; the full dispatcher and Gate SA regression matrices; live trials; adoption review; adjacent routing defects; merge, push, deployment, and destructive cleanup.
Primary edit begins after: add and run one focused case that copies an otherwise valid real v1 artifact to a plausible different-run path and presents different dispatcher-owned expected identity; quote the red showing the current structural validator accepts it because identity is not checked.

Required outcome: after structural validation, one production identity boundary compares the artifact only with caller-supplied dispatcher-owned expectations and returns an unambiguous accept/reject result with one bounded reason token. It must bind the exact expected task id, canonical checkout, run id, and promised artifact path derived from the admitted evidence root and run id; reject mismatched fields or paths; and refuse symlinks, traversal, control characters, leading-option ambiguity, or a path outside the admitted evidence root rather than following or normalizing them into trust.

This remains a validator dependency, not the first dispatcher consumer. Do not scan a directory for a candidate, choose a path from actor prose, wait for an artifact, advance canonical state, classify an outcome, or infer that any non-identity field is semantically true. Validation must not mutate the artifact, task state, Git, ownership, leases, logs, captures, or runtime evidence.

Governing authority and settled evidence:

- The content-bound-approved implementation plan governs, specifically Change set A required behavior items 5–7, trusted field ownership, the hostile-input path boundary, and § 8's one-production-owner rule. Gate SA and every fixed exclusion remain unchanged.
- Unit 6's structural validator and its exact-v1 `unknown-field` rejection are accepted evidence. Rejecting an unrecognized key is within the exact versioned structural contract, not a scope expansion. Do not redesign or re-prove that validator before the primary edit; run only its focused affected block after the identity work.
- Unit 6's symlink observation was a correct deferral, not an accepted safety limitation. This unit owns it because artifact-path integrity is part of proving which run the record belongs to.
- Codex's framing decision: outcome/code and wider semantic consistency stay held back because identity binding is independently observable and is one dominant deliverable. The split preserves the full plan contract.

Check against the repository before editing:

1. Verify the producer still promises `$LOG_DIR/$RUN_ID.result` and writes `task`, canonical `checkout`, and `run` from dispatcher-owned variables, and that Unit 6's validator is still unused by production routes.
2. Verify no other production helper already binds a terminal result to expected task/checkout/run/path. If one exists, hand back the overlap rather than creating a second owner.
3. Verify this identity boundary can extend the accepted validator region in `dispatch.sh` and its focused test without adding a CLI, consumer, helper file, or third implementation/test path. If not, hand back with the plan § 8 narrow-helper evidence instead of widening.

Required fail-capable evidence:

- quote the targeted identity red before the primary edit and focused green after it;
- show a real producer result at its promised path is accepted only when expected task, canonical checkout, run, and path all match;
- show separate bounded rejections for a structurally valid copied result presented as another run, a task mismatch, a checkout mismatch, and a symlinked promised path;
- include at least one mutation or negative control that would accept the fake/mismatched result if the identity comparison were removed, proving the primary assertion can fail;
- show the identity validator uses caller-supplied dispatcher values, does not scan for a result or trust actor-authored framing, and remains read-only;
- rerun only Unit 6's focused case 51 as the directly affected regression block; do not run the full dispatcher suite or re-prove the Unit 5 producer block;
- report pre-unit and handback commits and exact committed paths; and
- prove only `dispatch.sh`, `dispatch.test.sh`, and this task state changed. `logs/friction-log.md` remains outside the unit and must stay untouched and uncommitted.

Capability subset: baseline only — read/search the approved plan and accepted Unit 6 validator, inspect local history only where a seam claim requires it, edit only `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, and this task state, run focused local checks, and make the local handback commit. The baseline deny set is required in full. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed.

Completion condition: one local commit implements the standalone expected-identity boundary, the focused fail-capable proof is green, no dispatcher consumer or deferred semantic/wait/terminal-family behavior is integrated, no broad regression matrix is run, only the three permitted paths change, and the task hands back with `turn: codex`.

Stop and hand back without widening if an existing production identity owner is found, the producer's run-bound path premise is false, safe path identity cannot be isolated from consumer integration, a narrow helper or third implementation/test path is materially required, or any deferred consumer, semantic, terminal-family, plan, or repository path becomes necessary. Challenge a false premise rather than building around it.

## Latest result

Final tightly-bounded fix on the two residuals from the Unit 7 correction closure check. Both reproduced by inspection before any edit, both corrected, nothing else implemented.

Reproduced (2026-08-17):

- Residual 1: REPRODUCES — read `validate_terminal_result()` at `dispatch.sh:903-935` (commit `63654009`): it copied `TR_PATH_CLEARED` into `TR_PARSE_GATED` and then ran `[ -f "$f" ]` (which follows a link), `wc -c`, the digest and the whole `read` loop with no refusal of its own. Codex is right that this is the original late-refusal defect one function over: nothing stops a caller invoking the parser directly, and Unit 6's standalone structural contract positively allows it.
- Residual 2: REPRODUCES — only `TR_SHA` was captured. A byte-identical replacement has an equal digest by construction, and a regular file swapped for a symlink to byte-identical content is followed by both digests. The frozen requirement is content **or** file identity; only content was bound.

Fix 1 — the reader defends its own read. `validate_terminal_result()` now refuses before anything opens the artifact: an lstat-only `-L` test returns `symlinked-path`, placed ahead of `-f`, which follows links and is therefore already a decision to trust one. A gate clearance naming a *different* artifact is refused as `path-unchecked`. **A plain ungated artifact is still parsed** — that is deliberate and asserted: case 51 calls the parser with no gate on a dozen fixtures, and requiring a gate would break Unit 6's accepted standalone structural validator, which this fix's boundary preserves. So the property enforced at the reader is path safety and non-stale clearance, not gate-coupling. Codex should confirm that reading of "ungated ... fail closed", since it is the one place I resolved the residual narrower than its literal wording, and for a stated reason.

Fix 2 — acceptance is bound to which file, not only which bytes. `wl2_tr_fid()` returns device:inode, GNU `stat -c` probed before BSD `stat -f` because BSD's `-f` takes a format string while GNU's `-f` reports the filesystem — probing BSD-first would make GNU emit confident nonsense instead of failing. Neither form dereferences, so a symlink reports its own identity. The parser brackets its read with file identity as well as digest (`artifact-replaced`, `unidentifiable`), and identity re-establishes path topology before either digest: `-L` → `symlinked-path`, then file identity → `artifact-replaced`, then content → `artifact-changed`. Each names its own event rather than reporting a changed path as a changed byte.

Final-fix evidence: focused red `65/6` against the pre-final-fix dispatcher at commit `63654009`, green `73/0` after. Per-case: 51 `27/0`, 52 `22/0`, 53 `14/0`, 54 `10/0`.

- The four decisive red lines, all accepting the bad artifact: the parser followed the planted link and published a snapshot (`expected 'symlinked-path|', got 'ok|<symlink path>'`); a stale gate clearance covered a different artifact (`expected '1 path-unchecked', got '0 ok'`); a byte-identical substitute was accepted (`expected '1 artifact-replaced', got '0 ok'`); and a promised path that became a symlink after the gate was accepted (`expected '1 symlinked-path', got '0 ok'`).
- Two new mutation controls: M16 removes the file-identity comparison and the byte-identical swap is accepted `0 ok`; M17 removes **only** the reader's own pre-open refusal — addressed by a trailing marker comment, because the gate carries an identical `symlinked-path` line and deleting by token would remove both and prove nothing about which one does the work — and the parser follows the link again.
- Two positive controls guard against fixing by over-refusing: an ungated regular artifact is still parsed (`ok`), and the untouched original result is still accepted after both swap fixtures restore it.
- A defect in my own controls, found and fixed: I first wrote the parser's stale-gate refusal as a multi-line `if`, which made M14's token deletion produce `then fi` — a syntax error. That mutant could not run, so the control proved nothing while appearing to fail for a behavioural reason. Every refusal in this region is now single-line, and I verified all eight mutants (seven token-deleted plus the marker-deleted one) parse as valid bash before trusting any of them.
- Directly affected regression: case 51's 27 accepted assertions are green and unchanged. Still no dispatcher consumer — zero call sites to any of the three validator functions. Only `dispatch.sh`, `dispatch.test.sh` and this state file changed; `logs/friction-log.md` was already dirty beforehand, was not touched, and is not committed.

Deferrals unchanged, including the composed single-entry wrapper recorded in the previous round. Nothing new was noticed that needs recording.

---

Previous round — correction on Unit 7's two frozen findings, retained for the closure check.

Correction round on Unit 7's two frozen findings. Both reproduced by inspection before any edit, both corrected, nothing else implemented.

Reproduced (2026-08-17):

- Finding 1: REPRODUCES — read the pre-correction `validate_terminal_result()` at `dispatch.sh:810-833` (commit `2a6444d5`): `[ -f "$f" ]` follows a symlink, `wc -c <"$f"` opens it, and the `read` loop consumes it to the end. The symlink and resolved-root refusals sat only in `validate_terminal_result_identity()`, which the caller runs afterwards. The artifact was therefore fully read through the hostile path before the correct token was returned.
- Finding 2: REPRODUCES — `TR_SOURCE="$f"` recorded a pathname and nothing re-checked the bytes, so `validate_terminal_result_identity()` answered from `TR_TASK`/`TR_CHECKOUT`/`TR_RUN` captured from an earlier parse regardless of what was at that path by then.

Correction 1 — path integrity now precedes any read. The promised-path derivation, the symlink refusal and the admitted-root resolution moved out of the identity boundary into a new `validate_terminal_result_path()` that opens nothing: `-L` is an lstat on the name and `cd`+`pwd -P` resolves directories. Ordering is enforced rather than assumed. `validate_terminal_result()` captures `TR_PARSE_GATED` from the gate's decision at its first instruction, and identity requires that to name this exact artifact — so gating *after* parsing fails closed with `path-unchecked` instead of retroactively blessing bytes already read. Tokens `path-unchecked` and (from the gate) `no-path`, `no-expectation`, `unsafe-path`, `path-not-promised`, `symlinked-path`, `outside-evidence-root`; the last four are the accepted Unit 7 tokens, relocated rather than changed.

Correction 2 — acceptance is bound to the validated bytes. `validate_terminal_result()` now takes a sha256 before and after the parse and refuses `artifact-changed` if they differ, which also closes the mid-parse window where a record rewritten between its first and last line would have been read as a mixture of two artifacts. It publishes `TR_SHA` only on acceptance, and identity re-hashes and compares before any field comparison, refusing `artifact-changed`. It fails closed: an artifact that cannot be hashed is `unhashable`, never accepted unbound. The digest helper is defined inside the marker region because the harness sources that region standalone, so `file_hash()` further down the file would be undefined exactly where the region is under test.

Correction evidence: focused red `38/23` against the pre-correction dispatcher at commit `2a6444d5`, green `63/0` after (cases 51–53). The red was taken by extracting that commit's dispatcher with `git show` and running the new correction cases against it, which is a reproducible artifact rather than a transient working state.

- The two decisive red lines, quoted: `FAIL 53b — a record replaced at the promised path after validation is rejected / expected '1 artifact-changed', got '0 ok'` and `FAIL 53a — parsing first and gating afterwards is refused, not retroactively blessed / expected '1 path-unchecked', got '0 ok'`. Both findings accepted the bad artifact before the correction.
- "Refused before read" is distinguished from "read and rejected afterwards" by direct observation, not by the token: the parse is the only thing that publishes `TR_SOURCE` and `TR_SHA`, so 53a asserts a symlinked promised path and a symlinked evidence root are each refused with **both still empty**. A positive control asserts a safe path clears the gate and the parse then publishes both, so the assertion cannot pass by never parsing anything.
- The swapped-record fixture carries the *same* task, checkout and run as the original and differs only in `next_action`, so no field comparison can explain the rejection and only the snapshot binding can. A follow-on assertion shows the restored original is still accepted, so 53b is not passing because the checkout was left broken.
- Three new mutation controls, each removing one line from `dispatch.sh` and re-extracting the validator from the mutant: M13 (snapshot comparison) → the swapped record is accepted `0 ok`; M14 (ordering precondition) → a late gate is accepted `0 ok`; M15 (gate's symlink refusal) → the link is followed and parsed, flipping 53a's "nothing was parsed" evidence.
- One assertion of mine was wrong and is corrected: 52b's `unvalidated` case assumed a gated-but-unparsed artifact returns `unvalidated`. It returns `path-unchecked`, because `TR_PARSE_GATED` is set by the parse. `unvalidated` names a different real state — a parse ran on this gated path but read a different file — and the assertion now exercises that, with the `path-unchecked` case kept alongside it so neither token stands in for the other.
- Directly affected regression: case 51's 27 assertions and case 52's assertions are green in the same run. Unit 6 structural behaviour is unchanged; `validate_terminal_result()` gained the digest bracket and the two new bounded tokens only.
- Still no dispatcher consumer: `dispatch.sh` contains three validator definitions and no call site. No CLI, no waiting, no transition, no state advance. Only `dispatch.sh`, `dispatch.test.sh` and this state file changed; `logs/friction-log.md` was already dirty beforehand, was not touched, and is not committed.

Newly noticed during the correction, recorded as a candidate deferral and NOT implemented: a composed single-entry wrapper over the three checks would remove the caller's ability to get the order wrong at all. I drafted one and removed it — composing them with `$( )` runs each in a subshell and silently discards the globals they hand each other, and the shapes that avoid that either re-plumb every refusal site or rely on process substitution's output ordering. The `path-unchecked` precondition already makes a wrong order fail closed, so the wrapper is a convenience, not a safety gap. It belongs with the first-consumer unit, which is where a caller actually appears.

---

Unit 7's original hand-back evidence follows, unchanged.

Inspected (2026-08-17):

- Claim (1): HOLDS — read `dispatch.sh:632` (`local final="$LOG_DIR/$RUN_ID.result"`) and the record block at `dispatch.sh:693-695`, which writes `task` from `$TASK`, `checkout` from `$CHECKOUT`, and `run` from `$RUN_ID`; `$CHECKOUT` is canonicalized at `dispatch.sh:955` (`cd "$CHECKOUT" && pwd -P`). Searched `dispatch.sh` for `validate_terminal_result` — one hit, its definition at line 792, and no call site; the only caller anywhere is the harness at `dispatch.test.sh:5248`. Still unused by production routes.
- Claim (2): HOLDS — searched `dispatch.sh` for `RESULT_FILE` and `.result`; every hit is the producer writing (632-634, 739, 741) or `die()` printing the path (863-865). No reader beyond Unit 6's structural validator. Searched for `expected_`, `_expected`, `expect_task`, `expect_run`, `identity`; the only identity comparison is `dispatch.sh:2352`, which is the STATE file's task-vs-filename check inside `validate_state()`, not a terminal-result binding. No second production owner exists to overlap with.
- Claim (3): HOLDS — the accepted region is marker-delimited at `dispatch.sh:777`/`846`, and `dispatch.test.sh:5236-5240` lifts exactly that region out of the dispatcher under test and sources it. Appending the identity function inside the same markers and a case 52 beside case 51 needed no CLI, no consumer, no helper file, and no third implementation or test path.

Result: `dispatch.sh` now carries one production expected-identity boundary, `validate_terminal_result_identity()`, inside the existing marker-delimited region. It compares a structurally validated artifact only against five caller-supplied dispatcher-owned values (artifact path, expected task, canonical checkout, run id, admitted evidence root) and returns `ok` or exactly one bounded token from `no-path`, `no-expectation`, `unsafe-path`, `unvalidated`, `path-not-promised`, `symlinked-path`, `outside-evidence-root`, `task-mismatch`, `checkout-mismatch`, `run-mismatch`. The promised path is derived as `<evidence-root>/<expected-run>.result` and must match literally, which is also what bounds the artifact to the admitted root; a symlink at that path is refused rather than followed, and a root that resolves elsewhere is rejected rather than normalized. To keep one parse and one owner, `validate_terminal_result()` now publishes `TR_SOURCE`/`TR_TASK`/`TR_CHECKOUT`/`TR_RUN` on acceptance only, and the identity boundary refuses with `unvalidated` when those did not come from this exact artifact. No dispatcher route calls either function — this remains a validator dependency, not the first consumer.

Evidence: focused red `31/15` before the primary edit, green `48/0` after (cases 51 and 52; case 51's 27 assertions are the directly affected regression block and stay green). Pre-unit commit `850f38174ea929cabed6e04d6135d2e2c0d37a3d`.

- The red that motivated the edit, quoted: `PASS 52c — the copied result is structurally valid, so only identity can reject it` alongside `FAIL 52b — a valid result copied to another run's promised path is rejected as that run / expected '1 run-mismatch', got '127 '`. The structural validator accepted the forgery because identity was not checked, and no function existed to reject it.
- A real producer result at its promised path is accepted only when task, canonical checkout, run and path all match (52a). Separate bounded rejections: a byte-identical copy at another run's promised path → `run-mismatch`; the same copy under the original run's expectations → `path-not-promised`; a task mismatch → `task-mismatch`; a checkout mismatch → `checkout-mismatch`; a symlink at the promised path → `symlinked-path` (52b).
- Two mutation controls prove the primary assertions can fail. M11 deletes the run comparison from `dispatch.sh`, extracts the validator from the mutant, and the copied result is then accepted `0 ok`. M12 deletes the symlink refusal and the planted link is then followed to `0 ok`.
- M12 also corrected this unit's own control. The first symlink fixture pointed at a *different* run's result, so the mutant still rejected on `run-mismatch` and the assertion was not evidence about the symlink refusal at all. The fixture now links to the genuine result for the expected run, so every field comparison passes and only the symlink refusal can explain the rejection.
- Read-only and no-scan controls: a whole-checkout `tree_manifest` before and after identity validation is unchanged (artifact, state file, leases, ownership, logs, captures), and the boundary's own executable text, comments stripped, contains no `ls`, `find`, `glob`, `shopt`, `*.result` glob or command substitution over a directory — it cannot pick its own candidate (52c).
- Hostile-input rejections: traversal segment, leading-dash evidence root, and an expected value carrying a control character are each refused as `unsafe-path` rather than resolved; an empty expected value is `no-expectation`, never a wildcard (52b).
- Only `dispatch.sh`, `dispatch.test.sh` and this state file changed. `logs/friction-log.md` was already dirty before this unit, was not touched, and is not committed.

Carried forward from Unit 6's acceptance: Codex accepts `unknown-field` rejection as part of the exact version-1 structural contract. The symlink behaviour it deferred is now resolved here.

Accepted deferrals remain: semantic outcome/code and wider cross-field validation; first-consumer integration, result waiting, missing-result behavior; terminal families A–C, M, N; earlier run identity; durable crash-order and recovery; Change sets B–D; full regressions, live trials, and adoption review. Unit 5's requested-permission reconstruction and loose `changed_paths_since_launch` name also remain deferred unchanged.

Noticed and deferred, not implemented: the sandbox run ids observed during this unit render as `20260817T110046--45355-identity-task` — an empty `${LOCK_KEY:0:8}` segment leaving a double dash. It is cosmetic in the harness and outside this unit's identity-binding scope, so it was left alone rather than fixed here.

## Blocker

None.

## Next action

Codex: the closure check on this final fix and nothing else — are the two residuals resolved, and did the fix break the already accepted Unit 6/7 boundary? Cases 51–54 are green at `73/0` with case 51's 27 accepted assertions unchanged and no dispatcher consumer. One point needs an explicit verdict rather than a nod: residual 1 said "an ungated **or** no-longer-safely-gated artifact" must fail closed, and I enforced path safety and non-stale clearance at the reader while continuing to allow a plain ungated artifact to parse — because requiring a gate would break Unit 6's standalone structural validator, which this fix's own boundary tells me to preserve. If that reading is wrong the two constraints conflict and it is Codex's call which gives way.

---

Superseded — the final-fix instruction this round implemented.

Final tightly-bounded fix — menu choice after the Unit 7 correction closure check. The correction improved both boundaries, but the same two frozen findings remain partly unresolved; this is not a second correction round and opens no new review surface.

1. Enforce the pre-read gate at the reader, not only at eventual identity acceptance. `validate_terminal_result()` currently copies `TR_PATH_CLEARED` into `TR_PARSE_GATED` and then proceeds through `-f`, `wc -c`, hashing, and the full `read` loop even when the gate never cleared this artifact. Only `validate_terminal_result_identity()` later returns `path-unchecked`, after the bytes were already opened. That is the original late-refusal defect in another shape. Make an ungated or no-longer-safely-gated artifact fail closed before the parser's first artifact open/read. Required focused proof: the current code parses a valid artifact through a symlink when the parser is invoked without a successful pre-read gate; after the fix the parser refuses before publishing any parsed snapshot, and a mutation/negative control restores the unsafe read.

2. Bind acceptance to file identity as well as bytes, and preserve path integrity through identity acceptance. `TR_SHA` detects the submitted different-byte replacement, but a byte-identical replacement at the same pathname has the same digest and is accepted even though the frozen requirement says content **or file identity** change must fail closed. The same gap permits a pathname cleared as a regular file to be replaced after the gate by a symlink to byte-identical valid bytes; the parser/identity hashes follow it and no later check rejects the changed path topology. Make the validated snapshot fail closed when the artifact's file identity or safe-path identity changes between the pre-read gate, structural validation, and identity acceptance. Required focused proof: after validating the genuine result, atomically replace the promised path with a byte-identical regular file and separately with a symlink to byte-identical valid bytes; quote current red acceptance, then corrected bounded rejection. Include a mutation/negative control showing acceptance returns when the file/path identity binding is removed.

Final-fix boundary: change only `dispatch.sh`, `dispatch.test.sh`, and this task state. Preserve the accepted Unit 6 structure checks, Unit 7 task/checkout/run/path comparisons, bounded tokens, no-scan/read-only behavior, and all recorded deferrals. Keep one parser and no production consumer; do not add a CLI, wait/transition integration, semantic validation, terminal-family work, crash-order work, Change sets B–D, live trials, review, or release work. Run only focused cases 51–53 plus the new final-fix controls; no broad dispatcher suite or Unit 5 producer block. Commit the final fix, set `turn: codex`, and hand back for a closure check limited to these two residuals and whether the fix broke the already accepted Unit 6/7 boundary.
