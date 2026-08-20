---
task: canonical-rw-l4-integrated-pilot
status: active
turn: codex
---

## Objective and scope

Complete and prove L4, the approved lean plan's terminal outcome: deliberately install and reconcile
the combined accepted L2 House View capability and accepted L3 lightweight Research Workflow by hand
into exactly one bound Sector Intelligence consumer, then run one genuine integrated case through
routing, evidence, independent judgment challenge, founder revision and explicit approval or rejection,
an approved House View, downstream analysis and prose, and independent content QC. Acceptance also
requires pre/post inventories, deliberate reconciliation of every instantiated project reference,
green canonical and project regressions, representative Light/Standard/Deep handoff and escalation
evidence, and an honest burden comparison against L1.

Scope is the integration checkout
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-rw-l4-integration` and exactly one
consumer checkout,
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence-l1-trial`,
on the accepted L1 branch `trial/l1-repeat-precision-components`. Excluded: a second consumer, new
evidence retrieval, generic rollout, push, merge, deployment, and automatic founder approval.

## Lane and unit

Standard. Implementation mode. Unit 20 — establish the precision-components successor slot.

Named reason for the loop: the task spans a manual cross-repository integration, a genuine operating
case and an operator-owned founder gate; its scope must stay bounded, and the result must be assessed
independently of the executor before it counts as the plan's terminal proof.

## Latest result

Inspected (2026-08-20):

- Claim (1): HOLDS — integration `git log -1` returns `98df3e36277321df161e6b6d4b1f372024d96338`
  ("Unit 19 resolved the precision-components successor path"), the accepted Unit 19 commit. Consumer
  `git rev-parse --abbrev-ref HEAD` returns `trial/l1-repeat-precision-components` at
  `5a8482c959ceaf286fa5601c13d44d25d04a2753`; `git status --porcelain` in the consumer returned empty
  before editing — no pre-existing edits.
- Claim (2): HOLDS — `find analysis/judgment/precision-components` returned exactly the five expected
  files at the active base and no other file or directory; the destination
  `superseded/2026-08-18/` did not exist, so no collision was possible. Pre-move SHA-256:
  `-proposed.md` 759b0d39…2eddf3, `-review.md` 4699a891…dada01, `-review-round-1.md` 4120ccde…f869fe,
  `-review-round-2.md` 8ed99028…adcd7da, `-approved.md` fbca709c…5af38d.
- Claim (3): HOLDS — searched the whole of `logs/decisions.md` (871 lines) for the exact pattern
  `**Decision 35 `; no match. Global numbering ran to Decision 33 at line 265, after which entries use
  the `B3-` prefix. `logs/decisions.md` is the consumer's only decision log (`find … -name
  'decisions*.md'` returned one path). Decision 22 (line 186) retains "pilot 1 **idled** mid-Stage-4"
  and Decision 26 (line 212) retains "pilot-1 frozen at Stage 4" — the freeze Unit 19 quoted.
- Claim (4): HOLDS by construction — Unit 19's accepted before-state was treated as the failing case
  and was **not** rerun before editing.

Result: the authorized transition is committed atomically in the bound consumer at
`a880495ba98cc76c61d4b69b340e520b11fce7f9`, and this handback is the integration commit. Decision 35
was appended to `logs/decisions.md` (now line 877, in a new dated `## 2026-08-20` block, additions
only — 0 removed lines in the diff), and all five legacy lifecycle files were relocated with `git mv`
into `analysis/judgment/precision-components/superseded/2026-08-18/`. The active base now holds no
lifecycle file, only the `superseded/` subtree. No successor was authored.

Decision 35's material clauses, as written: the current-contract successor at the active base
supersedes the 2026-08-18 legacy `section:` authority; the five-file set is preserved byte-for-byte at
`superseded/2026-08-18/` and its old active paths stop governing with the relocation commit; Decisions
22 and 26 otherwise stand, their Stage-4 freeze lifted only for L4's downstream analysis, prose and
independent content-QC proof, with pilot 1 not otherwise resuming; founder revise/approve/reject stays
operator-owned and no successor proposal is pre-approved; accepted exposure — nothing marks the
preserved files superseded in-band, so a consumer manually pointed at the preserved path could still
validate them individually; rejected alternative — the distinct-base deep-route repoint, because the
shared commands would return exit 3 MISSING for `custom-dev-data-ai` or need an unauthorized selection
mechanism.

Evidence:

- **Byte preservation.** Post-move SHA-256 at the destination matches every pre-move source hash
  exactly: `-proposed.md` 759b0d39…2eddf3, `-review.md` 4699a891…dada01, `-review-round-1.md`
  4120ccde…f869fe, `-review-round-2.md` 8ed99028…adcd7da, `-approved.md` fbca709c…5af38d. `git diff
  --cached --find-renames --stat` reports all five as renames with **0 insertions, 0 deletions**.
- **Targeted post-state, against Unit 19's accepted before-state.** Deep-route gate
  `check-judgment-contract.sh …precision-components-unit-judgment-brief-approved.md` was **exit 0
  `verdict: VALID`** before, and is now **exit 3 `verdict: MISSING`** — "downstream steps that require
  an approved brief must not proceed". Promotion `promote-judgment-brief.sh …-proposed.md --approval
  … --approved-by …` was **exit 6 `ALREADY-APPROVED`** before, and is now **exit 3 `NO-PROPOSAL`** —
  it no longer returns `ALREADY-APPROVED`. The Standard adapter
  `research-route-judgment-authority.sh --unit precision-components --base …` remains fail-closed at
  **exit 1 `authority: UNAVAILABLE`**, but its `contract-exit:` moved 0 → 3, so it is now unavailable
  because nothing is there rather than because the identity mismatched.
- **No approved successor exists.** Confirmed explicitly: the active base contains no
  `-approved.md` (and no lifecycle file at all), and both probes above fail closed on its absence.
- **The exposure is real, and the probe could have failed.** The preserved `-approved.md` run at its
  new path returns **exit 0 `verdict: VALID`**, "approved Unit Judgment Brief for section
  'precision-components', 5 theses, 60 distinct claim IDs" — proving both that the bytes survived and
  that Decision 35's accepted exposure is stated accurately. Three of the four probes returned
  refusals (exits 3, 3, 1), so the set is capable of failing.
- **Scope.** Consumer `git status --porcelain` before commit showed exactly five `R ` renames plus
  ` M logs/decisions.md`, and is empty after. A filter for `logs/scripts/`, `.claude/`, `reference/`
  and `template` paths returned nothing — no script, command, template, other decision history,
  analytical prose, legacy frontmatter or `custom-dev-data-ai` file was touched. The unrelated
  working-tree change in the integration checkout's `logs/innovation-registry.md` was left
  uncommitted and unmodified.

Carried deferrals: (a) the missing `Decision 34` entry remains an unrelated decision-history gap, not
repaired here; (b) Unit 17's Light note said the consumer contains no local record of the suite run —
that must not be read as saying the suites did not execute there; Unit 16 records 238/0 consumer-root
and 213/0 integration-root assertions.

Noticed and not done: the `superseded/2026-08-18/` directory is now the first instance of a
preservation convention in this consumer — no repository-wide convention exists for it, and
`run-report.md:155` uses `.archive/` for approval markers. Codex chose this path in Unit 19; the
inconsistency is recorded, not resolved.

## Brief

The approved L4 proof now has both the operator authority and the mechanically supported transition
contract needed to free the `precision-components` canonical slot. This unit makes that transition
durable and atomic before any new judgment content is authored, preserving the old evidence while
ensuring no proposed successor can be mistaken for authority.

**Required outcome.** In the bound consumer, record the operator's 2026-08-20 supersession and bounded
Stage-4 thaw as Decision 35, and in the same consumer commit relocate the complete five-file legacy
judgment set from the active base into
`analysis/judgment/precision-components/superseded/2026-08-18/`. Preserve each filename and byte
content exactly. The existing active base must end empty of every legacy lifecycle file so the
installed producer can later create a current-contract successor there; do not create that successor
in this unit.

**Governing authority and settled decisions.** The operator's accepted option 1 in Unit 18 authorizes
the successor, the preservation-with-supersession transition and the narrow L4 downstream thaw; it
does not pre-approve judgment content. The approved plan at material commit
`8bf9d0d96ca7796621035e3f83b50c9dfc8055ec` governs the one-consumer manual proof and keeps founder
revise/approve/reject operator-owned. Unit 19's accepted contract at integration commit
`98df3e36277321df161e6b6d4b1f372024d96338` settles the unchanged-base relocation mechanism. Consumer
Decisions 22 and 26 remain governing except for the exact bounded thaw the new Decision 35 records.

**Decision 35 must say, in the consumer's established decision-record convention:**

- the current-contract successor at the existing `precision-components` base supersedes the
  operator-approved 2026-08-18 legacy `section:` authority;
- the legacy five-file set is preserved byte-for-byte at the selected `superseded/2026-08-18/` path,
  and its old active paths stop governing with this relocation commit;
- Decisions 22 and 26 otherwise stand, while their Stage-4 freeze is lifted only for L4's downstream
  analysis, prose and independent content-QC proof; pilot 1 does not otherwise resume;
- founder revise/approve/reject remains operator-owned and no successor proposal is pre-approved;
- accepted exposure: nothing marks the preserved legacy files superseded in-band, so a consumer
  manually pointed at their preserved path could still validate them individually;
- rejected alternative: a distinct-base deep-route repoint, because the shared commands would return
  MISSING for `custom-dev-data-ai` or require an unauthorized selection mechanism.

**Verify before editing:**

1. Confirm the integration task still carries accepted Unit 19 commit `98df3e36277321df161e6b6d4b1f372024d96338`,
   and the consumer is still on `trial/l1-repeat-precision-components` with no pre-existing edits. A
   mismatch is a handback, not something to repair.
2. Confirm exactly these five source files exist at the active base and the destination directory has
   no colliding file: `-proposed.md`, `-review.md`, `-review-round-1.md`, `-review-round-2.md` and
   `-approved.md`. Record their pre-move byte checksums. If the set differs, stop with the exact
   inventory.
3. Confirm `logs/decisions.md` still has no global Decision 35 and that Decisions 22 and 26 retain the
   freeze Unit 19 quoted. Search the whole decision log for the exact `**Decision 35 ` pattern; do not
   infer absence from nearby numbering.
4. Treat Unit 19's accepted targeted before-state as the failing case; do not rerun it before editing:
   the approved file at the active base validated with exit 0, the Standard adapter refused its
   missing `unit:` identity with exit 1, and promotion stopped at exit 6 `ALREADY-APPROVED`.

**Implement only the atomic transition.** Add Decision 35 and relocate the five files without editing
their contents. Do not change scripts, commands, templates, other decision history, analytical prose,
the legacy frontmatter, or `custom-dev-data-ai`. Commit only these consumer changes together. Then
update and commit only this task-state handback in the integration checkout, preserving the unrelated
working-tree change in `logs/innovation-registry.md`.

Dominant deliverable: one durable, atomic single-authority transition that frees the installed
`precision-components` successor base while preserving the full legacy set.
Evidence required in this hop: consumer and integration commit hashes; the exact before/after
inventories; matching pre-source and post-destination byte checksums for all five files; the targeted
post-state showing the active approved path now returns exit 3 MISSING, the promotion path no longer
returns `ALREADY-APPROVED`, and the Standard adapter remains fail-closed with no approved successor;
Decision 35's placement and material clauses; scoped diffs/status proving no scripts, content or
unrelated files changed; and explicit confirmation that no approved successor now exists.
Evidence explicitly deferred: successor production, independent challenge, founder content decision,
promotion, downstream analysis/prose, independent content QC, full regression suites, representative
route proof and burden comparison. The unrelated missing Decision 34 record remains a closure deferral.
Primary edit begins after: Unit 19's accepted fail-capable before-state at commit
`98df3e36277321df161e6b6d4b1f372024d96338`; revalidate only the four repository premises above, not
the already-accepted mechanics.

Capability subset: baseline only — read, search, history inspection, targeted local checks, edits only
to the consumer's five judgment paths and `logs/decisions.md`, edits to this task state, and local
commits in the two bound repositories. Pass the full baseline deny set if carried. Nothing is selected
from the empty pre-authorizable set. No network, push, merge, deployment, credentials, destructive
shared-state operation or other operator-reserved capability is needed.

**Completion and stop.** On success, write the exact implementation and evidence into `## Latest
result`, set `status: active` and `turn: codex`, and commit the handback. Stop and hand back without
improvising if a verify-first claim fails, relocation changes any byte, the active base cannot be made
unambiguously empty without touching another unit, Decision 35 conflicts with newer authority, a
script or command change becomes necessary, or either commit would include an unrelated path.

## Blocker

None.

## Next action

Codex: assess Unit 20. The authorized transition is committed atomically in the consumer at
`a880495ba98cc76c61d4b69b340e520b11fce7f9` — Decision 35 recorded, five files relocated byte-for-byte,
active base emptied, both routes fail-closed, no successor authored. Decide whether that satisfies the
unit, and open the next unit — producing the current-contract successor proposal at the freed base is
the expected next step, and it needs the founder gate kept operator-owned.
