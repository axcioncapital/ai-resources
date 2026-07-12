# Session Plan — 2026-07-12

## Intent
Wire both paired copies of `wrap-session.md` to call `run-manifest.sh update --decision-ref` at the manifest-close step, so `decisions_refs` is populated whenever a session records decisions — the blocking prerequisite for W3.2 R3 Pass 2.

## Model
opus — match (deciding: the ref-format convention and the Pass-2 sufficiency question are judgment calls, not a mechanical flag insertion)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` (Step 5 decisions append; Step 12d manifest close)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (workspace-root mirror; Step 4.7 manifest close — PAIRED CONTRACT)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh` (`--decision-ref` at L88; append+dedupe at L247–249, L302–304)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/spine-schemas.md` § 1 (manifest schema)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md` (anchor-shape ground truth)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/runs/2026-07-12-S1.json` (the one prior `decisions_refs` datapoint)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/remediation-register.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural change classes)

## Findings / Items to Address

1. **`wrap-session` never calls `--decision-ref`** — `improvement-log.md` 2026-07-12. The script supports the append (`run-manifest.sh` L88, L247–249); the wrap flow simply never invokes it. `decisions_refs` is therefore `[]` on every ordinary session — S2 recorded 5 decisions and S3 recorded 2, both `[]`. This is the item the mandate closes.

2. **No derivable anchor convention exists** (found this session, not in any prior log). S1's manifest carries `logs/decisions.md#2026-07-12-r3-pass1`, but **no header in `decisions.md` slugifies to that string** — S1 hand-authored it. Headers are also structurally inconsistent: `## 2026-07-12 (S4) — …` (most) vs `### 2026-07-12 — …` (L219). A ref format that cannot be mechanically derived from the header will drift the moment a second session writes one. **Decision (pick-and-proceed): ref = `logs/decisions.md#<YYYY-MM-DD>-<S{N}>`** — date + session marker, which the wrap already knows and which most headers already carry verbatim as `(S4)`. Rejected alternative: GitHub-style title slugs — they break on em-dashes/parens, and re-titling an entry would silently invalidate an already-written manifest.

3. **Wiring the flag alone does NOT make Pass 2 safe** (second-order finding, this session). Wrap **Step 5** instructs: append to `decisions.md` only when decisions carry "analytical or scoping judgment" — *"skip if all decisions were routine."* Routine decisions therefore live **only** in the wrap note's `### Decisions Made` block. R3 Pass 2 **deletes that block**. So even with `--decision-ref` wired, a routine-decision session would still lose its decision record at Pass 2 — the exact both-surfaces data loss the two-pass split exists to prevent. This is a **second Pass-2 sub-prerequisite**, and it is *recorded*, not built, this session (out of scope per the mandate).

4. **Ref stability vs. monthly archival** — `improvement-log.md` 2026-06-27 (stale `decisions.md` citation class-defect). Once `decisions.md` rotates to `decisions-archive-2026-07.md`, every `logs/decisions.md#…` ref in a closed manifest points at a file that no longer holds the entry. Accepted for now: the manifest is a point-in-time record and nothing resolves these refs yet (R4/M-D2 unbuilt, PJ dropped). Recorded as a known limit in the packet — not solved here, and explicitly not a reason to delay the wiring.

## Execution Sequence

1. **Plan-time `/risk-check`** on the paired `wrap-session.md` edit (structural class: shared-state automation + Critical component + paired copies).
   *Verify:* verdict recorded. GO → proceed. PROCEED-WITH-CAUTION → apply mitigations. RECONSIDER/NO-GO → **stop and redesign** (mandate `stop_if`).

2. **Wire canonical `ai-resources/.claude/commands/wrap-session.md` Step 12d.** Add a `--decision-ref` pass to the existing `close` block (one flag per decision recorded this session), plus the ref-format contract from Finding 2 and an explicit "omit the flag when the session recorded no decisions" clause.
   *Verify:* `grep -c 'decision-ref' wrap-session.md` ≥ 1; the ADVISORY RULE paragraph is unmodified (this must not become a gate).

3. **Mirror to workspace-root `.claude/commands/wrap-session.md` Step 4.7** — verbatim port per the PAIRED CONTRACT.
   *Verify:* `diff` the two close blocks; only the documented path-prefix differences remain.

4. **Prove it on this session's own wrap** — first payload datapoint.
   *Verify:* `logs/runs/2026-07-12-S5.json` → `decisions_refs` is **non-empty** and each ref resolves to a real header in `decisions.md`. A falsifiable check, not a "did it close?" proxy — the exact proxy error that closed the Pass-2 gate at S4.

5. **Record the wiring and the newly-found sub-prerequisite** — `improvement-log.md` entry → applied; mission thread `w32-migration-execution`; R3 row in `remediation-register.md`; `packets/R3-run-manifest.md` (Findings 2, 3, 4 as known limits + the Pass-2 reopen criteria, now **two** conditions, not one).
   *Verify:* Pass-2 reopen criteria in the mission file explicitly name BOTH prerequisites.

6. **Independent `/qc-pass`**, then end-time `/risk-check`, then commit.
   *Verify:* QC verdict is GO (or findings resolved) before staging.

## Scope Alternatives

- **Min:** Steps 2–4 only — wire both copies, prove the payload. Leaves Findings 3 & 4 unrecorded, so the next session re-derives them. Not recommended: Finding 3 is exactly the kind of silent gap that let the Pass-2 gate pass on a proxy.
- **Recommended (this plan):** Steps 1–6. Wire, prove on a live wrap, record the second sub-prerequisite, gate it properly.
- **Max:** additionally fix Step 5's "skip if routine" rule so *all* decisions land in `decisions.md` (closing Finding 3). **Rejected** — that changes the decision-recording contract itself, a separate structural change with its own blast radius, and the mandate puts Pass 2 and its dependencies out of scope. Record it; do not build it.

## Autonomy Posture
Gated

**Stop points:**
- `/risk-check` verdict is RECONSIDER or NO-GO → stop, redesign, do not override (mandate `stop_if`; `principles.md § DR-8`).
- Step 4's payload check fails (`decisions_refs` empty or refs unresolvable) → stop and report; do NOT mark the prerequisite met on a close-based proxy.
- `/qc-pass` returns findings on the paired edit → resolve before commit.

## Risk

Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

**Why it fires:** the edit touches `wrap-session.md` — a Critical component — in **two paired copies**, and modifies automation with shared-state effects (the wrap-time manifest write). Per `docs/audit-discipline.md`, both the paired-copy edit and the shared-state automation change are risk-check classes. The tripwire also applies: "existing-command refactor" is not an exemption.

**Specific risks to put to the reviewer:**
- The manifest close is governed by an explicit **ADVISORY RULE** ("do not harden this into a gate"). Adding a write must not make the wrap block on a missing/unwritable manifest. The new flag must degrade silently, exactly as `--file` does.
- **Paired-copy drift** is the standing failure mode of this file (the PAIRED CONTRACT exists because of it). Both copies must land in the same commit.
- A wrong ref format is written *durably* into every future manifest — cheap to change now, expensive after N sessions have written refs in the old shape.

**Environment-fit:** not applicable — the work product is a command-body edit, not a launcher or executable.
