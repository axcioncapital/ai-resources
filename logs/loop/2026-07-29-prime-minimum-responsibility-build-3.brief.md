BRIEF
UNIT: 2026-07-29-prime-minimum-responsibility-build-3
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: build
REPO: ai-resources
BASE: a771877
NEXT: Claude — implement Slice 3

**Claude-authored** from the G1-approved plan-v3 § 3, as with `-build-1`. Build units carry no
review (`docs/work-loop.md:96`). Unit id names the **slice**, not the execution position — this is
Slice 3, executed second, per the approved order `1 → 3 → 2 → 4 → measure → 5`.

Need: implement **Slice 3** — the marker → marker-bearing-header → mtime sequence is written three
times in `prime.md` (8a.3.a, 8b.3.a, and the sub-step Slice 1 renumbered from 8c.3 to **8c.5**). Each
copy calls the shared Step 8k allocator and then re-states the same header-existence check, header
append and `logs/.prime-mtime` write. Write that sequence **once, as Step 8h**, and have all three
branches call it. This is the third de-duplication of this surface: the *allocation* block itself was
already consolidated into 8k on 2026-07-17 (`docs/session-marker.md:229`); what remains triplicated
is the sequence wrapped around it.

Scope: Slice 3 only. **One file** — `.claude/commands/prime.md`. Depends on Slice 1 only (landed at
`1b96aa6`); it does not wait on Slice 2, because 8h calls whatever allocator exists, inline or
extracted, so consolidation is independent of extraction (review-1 F5, confirmed by review-2).

Premises to verify:
- The sequence really is written three times, and the three copies are behaviourally equivalent —
  re-derive by reading all three, not by trusting the plan's count.
- 8c.5 after Slice 1 is the same sequence 8c.3 was before it.
- No external file cites `8a.3.a` or `8b.3.a` by number (P-CITE, re-specified at build-1 § R1).
- `prime-allocator.test.sh` extracts the allocator from `prime.md` by awk and hard-exits 2 if its
  anchors move — 19/0 must still pass after consolidation.

Falsified if: the three copies are **not** equivalent and consolidating them would change any
branch's behaviour; any `/prime` step must be renumbered to make 8h fit; the allocator tripwire drops
below 19/0; or `prime.md` does not shrink.
