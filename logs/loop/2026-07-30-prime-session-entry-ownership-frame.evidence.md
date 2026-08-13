EVIDENCE
UNIT: 2026-07-30-prime-session-entry-ownership-frame
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: frame
REPO: ai-resources
BASE: 8c573af
NEXT: Claude — open Shape

**Capability:** prime-runtime-delegation

**Object:** `prime.md` at HEAD (`8c573af`), **411 lines**. Every line number below was re-derived live
against HEAD, not carried from the brief or from the predecessor stream.

## Premise verification

```
PREMISE: confirmed — every removal target still exists, at re-derived positions
  · ran: six targeted greps over .claude/commands/prime.md at HEAD, reporting line numbers only
  · observed:
      STRUCTURAL_RISK      :399 :401 :407      (brief said :399 :407 — :401 is a third site)
      legacy QC            :131                (matches)
      model alignment      :198 :200           (brief said :198–202 — the region is :198–202, hits at :198 :200)
      multi-item auto      :261 :371           (brief said :373 — moved by 2; :261 is a second site)
      log-trio prefetch    :61 :62             (matches)
      urgent-log triage    :172                (Step 3 header; brief's :172–194 is the region)
  · NOTE: two targets have MORE sites than the brief recorded — STRUCTURAL_RISK at :401 and multi-item
    auto at :261. Carrying the brief's numbers would have missed both. Recorded as the reason the
    read-scope floor is a floor.

PREMISE: confirmed — the session-entry seam is one-third moved
  · ran: grep -c 'session-notes.md' on prime.md; grep -c 'does NOT touch .session-notes.md';
    grep -n 'session-notes' and a write-site scan on logs/scripts/prime-marker.sh
  · observed: prime.md carries 17 session-notes.md references. Step 8k states twice that the script
    "does NOT touch session-notes.md". The script's only write is
    `echo "${TODAY} ${MARKER}" > logs/.session-marker` (:154) plus the per-id marker. It does not
    write session-notes.md and does not write logs/.prime-mtime.

PREMISE: confirmed — 31 of 32 roots carrying the call lack the script
  · ran: the corrected `-e`-based census over every candidate root
  · observed: 32 roots contain the call; 31 lack the script. Unchanged from the Prove unit's
    corrected figure.

PREMISE: confirmed — the dangling citation is still live
  · ran: grep -n "8c\.2" docs/session-marker.md
  · observed: :339 "Cited by `/prime` Step 8c.2, which holds the mechanism". Step 8c.2 does not exist.
```

**No load-bearing premise rejected.**

---

## Frame finding — completing the owner is smaller than it looks

The script already **reads** `logs/session-notes.md`. Lines `:83` and `:86` scan it for
`^## ${TODAY} — Session S[0-9]+` headers — both the worktree's own and, via a git ref scan, headers a
worktree session allocated and committed. The file is already in the owner's mental model and its
same-day increment logic already depends on it.

What the owner does **not** do is write: it never appends the marker-bearing header and never stamps
`logs/.prime-mtime`. Those two writes, plus the ordering rule that binds them (marker → header → mtime),
are what remain in the prompt across 17 references.

**Consequence for Shape.** Completing the session-entry owner is an *extension of an existing reader
into a writer*, not a new component. The ordering rule the prompt currently states in prose — marker
before header so the header can embed `${MARKER}`; mtime after the append so `/session-start` Step 0.5
sees this session's own write — becomes three sequential lines inside one script, where it can be tested
rather than read. This is the cheapest of the move-outs and it is the one that closes the release
blocker, which argues for it being Slice 1.

---

## Need, ownership and scope

**Need — confirmed, and it is two needs, not one.** (1) The session-entry seam is defective: the
extraction executes in 1 of 32 roots. (2) `/prime` at 411 lines is 111 above a frozen target, still
holding six categories of retired machinery and five move-outs. The first blocks release; the second is
the mission. They share an object and a root cause — a half-completed ownership move — so they are one
stream, not two.

**Ownership — unchanged.** `axcion-ai-system-owner` owns the capability; the record is
`development/prime-runtime-delegation.md` at `status: revise`. No new record: `revise` means more work
is expected on *this* capability, and the seam correction is this capability's own defect. The wider
responsibility reduction is scoped here as continued work on the same operating outcome — `/prime`'s
deterministic work performed by things that execute — not as a new capability.

**In scope.** The six-responsibility architecture; the removal list; the move-out list; the
retain-and-compress list; the dangling citation; the C2 renumbering reconciliation.

**Out of scope.** Anything that renegotiates the ≤300 target, closes the mission, or reinstates retired
machinery. Editing `/prime` in this unit — Frame decides need and scope only.

**Route: challenged.** Confirmed against `docs/work-loop.md` § Route triggers — the object is a shared
`ai-resources` resource resolving live into 31 consumers, the change alters session-initialisation
behaviour, and the stream has already failed to converge once. Ambiguity resolves upward; nothing here
argues down.

---

LIMITATIONS:

- **This brief is Claude-authored** from operator direction, with no independent framing. The removal
  and move-out lists are transcribed decisions, not analysis this unit performed — so a target that is
  wrong *as a decision* would not be caught here. Verification confirmed the targets **exist**, not that
  removing each is correct.
- **No line budget was derived.** Whether the six removals plus five move-outs actually reach ≤300 is
  unmeasured and is Shape's arithmetic. The predecessor stream's central failure was a budget that
  rested on estimates for fifteen of seventeen regions; that must not be repeated by assertion here.
- **The C2 renumbering reconciliation has no stated method yet.** Whether retained identifiers are
  restored to their pre-change values or the citing files are repointed is a Shape decision with
  different blast radii, and this unit does not pre-empt it.
- **Only one dangling citation was checked** — the one the Prove unit found. A full citation sweep
  across all 14 files against HEAD was not re-run here; the Prove unit ran it against `8b49da2`, and
  `38981e5` has landed since.
- **The "32 roots" figure counts roots carrying the call**, not distinct git repositories or distinct
  operators. Two of those roots are archives (`archive/nordic-pe-macro-landscape-H1-2026`) or vaults
  (`knowledge-bases/pe-kb-vault`) where `/prime` may never be invoked; the census does not weight by use.

Status: complete

---

## CLOSE

```
CLOSE
UNIT: 2026-07-30-prime-session-entry-ownership-frame
OUTCOME: close
COMMITS: 8c573af (unit opened) · this commit
```

**What closed.** The Frame phase: need confirmed as two coupled needs with one root cause, ownership
kept on the existing record, scope bounded, route confirmed challenged.

**The stream does NOT close.** Shape is next, and owns the line budget, the slice list and the
falsification criteria. **G1 gates it** — no Build unit opens before the operator approves scope and
package.
