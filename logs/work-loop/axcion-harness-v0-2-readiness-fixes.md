---
task: axcion-harness-v0-2-readiness-fixes
turn: codex
---

## Objective and scope

Bring the canonical attended Axcíon Harness v0.2 launcher to the supervised-readiness boundary the
operator approved on 2026-08-13, using bounded units that are independently implemented and assessed.

The task covers the still-current parts of the 2026-08-11 readiness assessment on the canonical
attended surface: checkout-wide single-writer enforcement, deterministic and honest post-hop outcome
classification, default prevention of nested AI expansion, and proportionate supervised adoption
evidence. It excludes unattended operation, external actions, automatic push or merge, strategic
routing, portfolio scheduling, a dispatcher rewrite, and permission widening such as `acceptEdits`
unless the operator separately authorises it.

The named task exit condition is: every retained supervised-readiness requirement has either been
implemented and accepted with fail-capable evidence, or explicitly disposed of from current
repository evidence; the required live supervised trials have produced an explicit adopt, revise,
continue-trial, or stop decision; and no result claims unattended readiness.

## Lane and unit

Standard. Implementation mode. Unit 2 — classify every unsuccessful canonical carrier hop from its
actual before/after repository delta and Claude permission evidence.

Named reason for the loop: the full readiness task spans several independently assessable changes
and live trials, must survive multiple Claude/Codex turns, needs strict boundaries to avoid a broad
launcher rewrite, and requires assessment by Codex rather than acceptance by its implementer.

## Brief

Why this unit, why now: Unit 1 is accepted, so one carrier writer now owns a checkout at a time. The
next retained release blocker is honest stopping: an operator must be able to tell whether Claude
was denied permission, whether allowed partial work exists, and whether Claude actually changed the
state file without reconstructing the hop from raw logs.

**Required outcome.** Replace post-hop heuristics on the canonical attended carrier with one
deterministic classification derived from the evidence already available or minimally captured for
the hop: state-file hash and dirty state before/after, HEAD before/after, allowed and disallowed
working-tree deltas, committed-path delta, actor exit/timeout status, resulting `turn:`, and Claude
`permission_denials` when present. Every unsuccessful hop must report the correct outcome, exact
partial allowed paths if any, and a recovery action consistent with Work Loop ownership.

**Governing authority and source disposition.**

- The operator's 2026-08-13 decision governs: use one Work Loop task, target the canonical attended
  launcher, and continue through bounded supervised-readiness units after Unit 1.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs Work Loop roles, state,
  evidence, and handback semantics; Claude owns repository reality and every commit.
- `plans/axcion-harness-v0.2/mvp-plan.md` remains relevant but non-governing project direction
  because its header says proposed/no implementation authorised. Its attended-only boundary agrees
  with the current operator decision.
- `plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`
  is non-governing assessment material. Its Priority 2 evidence shapes inform this unit, but its own
  header authorises no implementation.
- Unit 1's accepted result below is authoritative current task state. Claude identified its commit
  to the operator as `e2ac00d`; verify the exact repository identity at entry rather than treating
  conversation as repository evidence.

**Check against the repository before acting.**

1. Verify in `scripts/axcion-harness-v0.2/carry-turn.sh` whether `before_dirty` is captured but not
   used when the post-Claude dirty-state branch attributes an uncommitted state file to Claude. Use
   the existing test seam to demonstrate whether a state file dirty before launch and byte-identical
   afterwards can be misreported as newly edited by Claude. If this premise is false, hand back the
   evidence rather than preserving the proposed classifier shape.
2. Search all of `scripts/axcion-harness-v0.2/carry-turn.sh` and
   `scripts/axcion-harness-v0.2/carry-turn.test.sh` for parsing or classification of Claude
   `permission_denials`. If present, state its actual coverage; if absent, limit the absence finding
   to those two searched files.
3. Verify whether the carrier snapshots and reports allowed working-tree changes attributable to
   the launched hop, including on actor failure, timeout, permission denial, and invalid or absent
   handback paths. Distinguish pre-existing allowed dirt from changes made during the hop.
4. Inspect every recovery message in the canonical launcher that can follow a stopped Claude hop.
   Identify any branch that tells Codex, or ambiguously tells the current reader, to commit Claude's
   handback; core section 4 assigns every commit to Claude.
5. Confirm Unit 1's checkout-wide lock and its regression cases are present before modifying the
   classifier. Stop on a false premise or missing Unit 1 commit rather than rebuilding it here.

**Scope.** Change only:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this task state file

The implementation mechanism is Claude's decision. Prefer one classifier or one ordered decision
surface over independent branches that can contradict each other. Reuse the carrier's existing
snapshots and actor capture where sufficient. Do not create a daemon, observer process, registry,
second evidence store, retry mechanism, or semantic state field.

**Codex framing decisions and held-back work.** Unit 2 includes dirty-state attribution,
permission-denial interpretation, partial allowed-effect reporting, and recovery wording because
they form one dominant deliverable: classify one hop honestly from one evidence set. It excludes
nested-agent controls, permission-mode widening including `acceptEdits`, lock changes, documentation
cleanup, live model trials, automatic retry or resume, and adoption decisions. Do not edit or copy
the old spike dispatcher; it may be inspected only for a factual comparison and is never acceptance
evidence for this unit.

**Required fail-capable evidence.** Exercise the canonical carrier path and show:

1. a state file dirty before launch and byte-identical afterwards is not reported as newly edited by
   Claude;
2. a Claude permission denial with no repository effect reports the denied tool and target and says
   the repository is unchanged;
3. a Claude permission denial after allowed partial edits reports the denial and lists exactly the
   attributable changed paths;
4. allowed partial effects without permission evidence are classified separately and listed on an
   actor failure, timeout, or invalid/no handback path represented by the existing fixture seam;
5. a disallowed working-tree or committed effect retains precedence as an unexpected-effect stop;
6. a valid committed Claude handback and a valid uncommitted Codex handoff retain their existing
   success semantics;
7. identical evidence maps to one stable outcome regardless of which legacy branch would previously
   have encountered it;
8. no recovery branch tells Codex to commit, discard, or otherwise repair Claude's partial handback;
9. Unit 1's lock cases and the full canonical launcher suite still pass.

Show at least one matched pre-change/post-change failure for the dirty-before/byte-identical incident
shape and one fail-capable permission-denial case. Report exact commands, exit statuses, relevant
output, outcome precedence, changed files, and the commit id. Evidence from the old spike's suite or
a grep for outcome labels does not substitute for exercising the canonical carrier path.

**Completion condition.** Implement and commit one bounded deterministic post-hop classifier on the
canonical attended launcher, with the evidence above; update this file with the current result, set
`turn: codex`, and stop. Do not begin the nested-agent or live-trial unit.

**Stop conditions.** Hand back to Codex without improvising if the dirty-state premise is false, if
Claude's installed output cannot expose permission denials through the existing capture, if the
evidence cannot distinguish pre-existing dirt from hop-attributable changes, or if the change needs
paths outside scope. Stop for the operator if it would require broader permission authority,
automatic repair of partial work, or a change to the attended-only release boundary.

## Latest result

Inspected (2026-08-13):

- Claim (1): HOLDS — `before_dirty` is assigned at `carry-turn.sh:619` (`before_dirty=0; state_dirty
  && before_dirty=1`) and read nowhere: `grep -n 'before_dirty'` over both in-scope files returned
  that one line and nothing else. The post-hop branch `if [ "$before_turn" = "claude" ] &&
  state_dirty` therefore attributed any dirty state file to Claude, and it sat *before* the
  byte-identical check, so it won the race. Demonstrated through the existing fixture seam: a state
  file made dirty before launch, with an actor that changes nothing, produced `exit=25` and the words
  "Claude edited logs/work-loop/task-m7.md but left it uncommitted" — a claim the evidence did not
  support. Held as mutant M7, which restores exactly that branch and produces 25 where the corrected
  launcher produces 22.
- Claim (2): HOLDS as an absence, and the absence is bounded to the two named files. `grep -n
  'permission_denials\|permission_denial\|denials'` over `scripts/axcion-harness-v0.2/carry-turn.sh`
  and `scripts/axcion-harness-v0.2/carry-turn.test.sh` returned no match (grep exit 1). No parsing,
  no classification, no coverage existed in those two files. No claim is made about any other file.
- Claim (3): HOLDS — the carrier snapshotted only the out-of-allowlist half of the working tree.
  `grep -n 'foreign_worktree\|allowed_worktree\|status --porcelain'` found `foreign_worktree` and its
  three call sites and no allowed-side capture at all. Allowed changes were therefore never recorded,
  never attributed, and never reported; and `die 21` (timeout) and `die 20` (actor failure) both
  exited before any post-hop snapshot was taken, so a hop that failed reported nothing about what it
  had already written. Pre-existing dirt could not be distinguished from hop-attributable change
  because only one snapshot existed.
- Claim (4): HOLDS — one branch reassigns Claude's commit. The pre-launch `die 25` at
  `carry-turn.sh:558` ended "If the edit is complete, commit it and re-run; if it is partial, discard
  it and re-run." It addresses whoever ran the script, and it fires while a Codex hop is the one about
  to be launched, so it reads as an instruction to commit Claude's handback. Every other post-stop
  recovery was checked: `die 25` post-hop (read the diff, check for a denial), `die 30` (inspect,
  widen `--allow-path`, or revert), `die 26` ("restore or complete it"), `die 16` (commit or unstage
  *pre-existing staged paths*, not a handback), `die 19`, `die 18`. Only line 558 instructs a commit
  of Claude's handback.
- Claim (5): HOLDS — `e2ac00d96cbc0a65c9883517a505a4250debf8c4` exists and `git merge-base
  --is-ancestor e2ac00d HEAD` succeeds, so Unit 1 is in this branch's history. The checkout-wide key
  is live at `carry-turn.sh:382` (`key="$(printf '%s' "$CHECKOUT" | ...)"`), and its regression cases
  are present: suite section 12b and mutant M6. Nothing was rebuilt.

Additional premise established rather than assumed, because the brief makes it a stop condition
("if Claude's installed output cannot expose permission denials through the existing capture"):
Claude Code 2.1.220 does emit `permission_denials` in `--output-format json`. Probed directly — a
`PreToolUse` deny hook produced
`[{"tool_name":"Bash","tool_use_id":"toolu_015UgUSJZN68kMLFmSyNqaYP","tool_input":{"command":"echo
probe-denial-test","description":"Echo a test string"}}]`. Two negative probes matter as much: a
`permissions.deny` rule and `--disallowedTools` both remove the tool from the toolset instead of
recording a denial, so an empty list does not mean "nothing was blocked". The field lands in the
capture file the launcher already writes, so nothing new is stored.

Result: post-hop decision-making on the canonical attended carrier is now one evidence set gathered
once (`gather_evidence`), one ordered verdict over it (`classify_hop`), and one report shape printed
whatever the verdict (`report_hop`). The independent branches are gone. Concretely:

- **Attribution is computed, not assumed.** `worktree_lines` splits the working tree into allowed and
  foreign halves; `new_lines` returns only what appeared *during* the hop. The uncommitted-handback
  stop now requires `after_hash != before_hash`, so a file already uncommitted at launch and
  byte-identical afterwards is no longer blamed on the actor — and where Claude did edit on top of
  pre-existing dirt, the message says part of the diff is not attributable to it.
- **Permission evidence has three states, not two.** `present` / `empty` / `unavailable`, kept
  distinct end to end, including on the RESULT line. `denials=unavailable` means no evidence could be
  read; `denials=0` means Claude reported none. Collapsing them would turn missing evidence into a
  clean bill of health.
- **Precedence is decided in one place.** Ordered: disallowed working-tree effect (24) → Codex moved
  HEAD (24) → disallowed commit (30) → timeout (21) → actor failure (20) → state-file identity and
  turn validity (13/14/15) → Claude's own uncommitted handback (25) → transition validity computed as
  a fact → permission denials that explain a missing handback (27) → no transition (22) → carried (0).
  Unexpected effects now outrank a failed or timed-out actor, which they did not before.
- **A denial that did not block the handback is advisory.** The turn genuinely moved, so the hop
  reports CARRIED with a visible warning naming the denials, rather than being downgraded to a
  failure. Getting this wrong was a real defect in my first version of the classifier: denials were
  judged before transition validity, which turned a completed carry into exit 27. Caught by case
  15.6 and fixed by computing the transition fault before judging it.
- **New exit code 27 PERMISSION_DENIED**, documented in the header table. Codes 23 and 29 remain free.
- **No recovery path reassigns Claude's commit.** Line 558 now states that the script will not commit
  it and Codex must not, then hands the decision to the reader.
- **Failed and timed-out hops now report their effects.** Evidence is gathered for every outcome, so
  20 and 21 list the allowed partial work the actor left behind.

Evidence (canonical launcher suite only; no spike evidence, and no outcome-label greps):

1. **Dirty before, byte-identical after — matched pre/post.** Case 15.1: `exit=22`, output carries
   "NOT attributable to this actor", "uncommitted:     before=yes after=yes", "attributable to THIS
   hop: none", `partial=0`, and asserts the absence of "Claude changed logs/work-loop". Pre-change
   behaviour is held live as mutant **M7**, which restores the unattributed condition and yields
   `wanted '22', got '25'`.
2. **Denial with no repository effect.** Case 15.2: `exit=27`, names `- Bash — git commit -m
   handback`, states "the repository is unchanged", RESULT carries `denials=1 partial=0`.
3. **Denial after allowed partial edits.** Case 15.3: `exit=27`, lists `partial-note.md`, names
   `- Write — logs/work-loop/partial-note.md`, states "repository is NOT unchanged", `denials=1
   partial=1`.
4. **Allowed partial effects without permission evidence are classified separately.** Case 15.4: an
   actor that writes an allowed file then exits 3 gives `exit=20`, still lists `partial-note.md`,
   carries `denials=0 partial=1`, and asserts the absence of `PERMISSION_DENIED`.
5. **Disallowed effect keeps precedence.** Case 15.5: a denial accompanied by an out-of-allowlist
   write gives `exit=24`, classified `UNEXPECTED_EFFECT`, with the denial still shown in the evidence
   block rather than dropped.
6. **Existing success semantics intact.** Section 6 (committed Claude handback → 0, CARRIED) and
   section 13 (uncommitted Codex handoff → 0) unchanged and passing. Case 15.6 adds the denial-on-a-
   successful-hop shape: `exit=0`, `RESULT outcome=CARRIED code=0`, plus the warning line.
7. **Same evidence, same outcome.** Case 15.7 runs the identical denial against a fixture that also
   carries pre-existing *allowed* dirt — a shape the old code would have met in a different branch.
   Result is the same `exit=27`, the pre-existing dirt is reported separately ("already present
   before launch") and is *not* counted: `denials=1 partial=0`.
8. **No recovery branch reassigns Claude's commit.** Case 15.9: `exit=25` carrying "Claude commits
   its own handback" and "do not ask Codex to", plus a static assertion that the string "If the edit
   is complete, commit it and re-run" no longer appears anywhere in the launcher.
9. **Unit 1 and the full suite.** `./scripts/axcion-harness-v0.2/carry-turn.test.sh` → exit 0,
   `passed: 157   failed: 0` (was 116 after Unit 1). Sections 12 and 12b — the lock cases — pass
   unchanged.

Fail-capability: `./scripts/axcion-harness-v0.2/carry-turn.test.sh --prove-failure` → exit 0,
`passed: 11   failed: 0`. Three new mutants cover the three new invariants — **M7** restores the
unattributed dirty-file branch (`wanted '22', got '25'`), **M8** collapses `unavailable` into `empty`
(`missing 'denials=unavailable'`), **M9** never classifies a recorded denial as one (`wanted '27',
got '22'`; `missing '- Bash — '`). M2 and M5 were re-pointed at the restructured lines and still fail
correctly, so no pre-existing invariant went idle behind the refactor.

Parser checked against **real** Claude output, not only the fake actor: the launcher's own
`read_denials` was run against the three captures taken from Claude Code 2.1.220 — a real denial
(`DENIAL_STATE=present`, `count=1`, `- Bash — echo probe-denial-test`), a real clean run
(`DENIAL_STATE=empty`, `count=0`), and a non-JSON file (`DENIAL_STATE=unavailable`).

Changed files: `scripts/axcion-harness-v0.2/carry-turn.sh`,
`scripts/axcion-harness-v0.2/carry-turn.test.sh`, and this state file. Nothing else was edited. The
commit carrying this record has the subject
`fix: carry-turn.sh — one deterministic post-hop classification`; `git log -1` resolves its id.

Deferrals noticed during the unit, recorded and not done:

- The classifier reads permission evidence with `jq`. Where `jq` is absent the state is
  `unavailable`, which is honest but blind. A `jq`-free fallback is a separate decision and is not
  needed for the attended surface, where `jq` is present.
- `--allow-path` is still an operator input with a two-entry default, so the "allowed partial work"
  the classifier now reports is only as meaningful as the allowlist it was given. Reviewing that
  default is Unit-3-or-later work, not classifier work.
- Carried forward from Unit 1, still not done: the hook-owned dirty `logs/friction-log.md` operating
  interaction (it did not prevent classifier evidence, so it stayed out per the brief), and the
  cosmetic double slash in displayed temporary lock paths.

## Blocker

None.

## Next action

Codex: assess Unit 2 — one deterministic post-hop classification on the canonical attended launcher,
with the evidence above. Decide close, continue to the next readiness unit, correct once, or stop.
