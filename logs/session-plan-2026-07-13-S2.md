# Session Plan — 2026-07-13

## Intent
Ship W3.2 R3 Pass 2 (the narrowed 2-section wrap-note cut, both paired `wrap-session.md` copies), run the discriminator diagnostic on the P1 `decisions_refs` failure (diagnose and log only), and clear two leftovers.

## Model
opus — match (active: `claude-opus-4-8[1m]`). The mechanical part (the cut) is `sonnet`-shaped, but two items are genuinely *deciding*: the F1 design correction below, and the P1 diagnosis of a third, so-far-unexplained failure mechanism.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — canonical copy (Step 4 note schema L123–133; Step 12d manifest close L225–264)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` — workspace-root mirror (Step 2 note schema L90–91; Step 4.7 manifest close L209–248)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md` — L33, the note-grep input signals
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh` — `start`/`update`/`close` (L248–364); `--file` → `files_changed` (L275–280, L331–335). **Read-only.**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/decision_ref_slug.py` — **read-only**, for the P1 diagnostic
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/implementation-prep/packets/R3-run-manifest.md` § "🟢 Pass 2 — READY TO SHIP" (L169–193)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` L519–534 — the P1 entry + its falsification note
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/w32-migration-execution.md` — mission thread
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes (paired Critical component)

## Findings / Items to Address

1. **F1 — 🔴 BLOCKER, found this session; the packet does not contain it. The cut destroys its own data source.**
   `files_changed` is populated **only** at wrap-close, from `--file` flags. Canonical `wrap-session.md` L227 sources those flags from *"the `### Files Created` / `### Files Modified` lists you just wrote in Step 4"* — **the two sections Pass 2 deletes.** `run-manifest.sh` advertises running accumulation (header L27–28, `update --file`), but **no command calls `update`**: the only callers are `/prime` Step 8c.7.5 (`start`), `/session-start` Step 3.5 (`start`), and both wrap copies (`close`). Population is 100% wrap-only and 100% note-derived.
   **If the cut ships as the packet specifies:** note loses the file lists → wrap has nothing to pass as `--file` → `files_changed: []` on every session → the file record is lost from **both** surfaces. This is exactly the both-surfaces loss P2 was created to prevent, recurring on the *file lists* instead of the *decisions*.
   **Why the gate missed it:** the gate's evidence (`files_changed` = 15 / 16 / 9 on three ordinary sessions) was **produced by the sections being cut**. It proves `files_changed` works *because of* the middleman, not *without* it. Fifth instance of this chain's signature error — and the first where the evidence was measured on a data path the change itself destroys.
   **Fix (must land in the SAME commit as the cut):** repoint `--file` derivation from *"the note's Files Created / Modified lists"* to **"the file set you changed this session, auto-derived from conversation context"** — the identical source Step 4 already uses to write those lists (L126–127: *"list from conversation context"*). The note sections are a middleman, not the source. Cut the middleman, keep the source.
   Source anchors: canonical L227; root mirror L211; `run-manifest.sh` L27–28, L248–364.

2. **F2 — pre-existing latent bug in the root mirror, fix in the same pass.** Root mirror Step 4.7 (L211) says *"Pass one `--file` per path from the `### Files Created` / `### Files Modified` lists written in Step 2"* — but that copy's Step 2 (L90) writes a **single `### Files Changed` block**, grouped Created/Modified. The mirror's manifest close already points at section names **that do not exist in its own copy** — verbatim-port drift from the canonical. F1's fix (derive from conversation context) dissolves F2 as a side effect: neither copy will reference note-section names any more.
   Source anchors: root mirror L90 vs L211.

3. **R3 Pass 2 — the cut itself.** `### Files Created` + `### Files Modified` → `files_changed`. Canonical **8 → 6**; root mirror **7 → 6** (it has one `### Files Changed` block, never two). **`### Decisions Made` is RETAINED** — that is the whole P2 resolution; do not cut it.
   Source: `packets/R3-run-manifest.md` L169–193.

4. **Collector repoint.** `session-feedback-collector.md` L33 greps the note for `### Files Created` / `### Files Modified` / `### Files Changed`, **and** `### Decisions Made`. Repoint the **file** signals at the manifest with graceful absent-manifest fallback. The **decision** signal needs **no** rewiring — `### Decisions Made` still exists.
   Source: `packets/R3-run-manifest.md` L187; collector L33.

5. **Residual risk the packet DID name — still check it.** A session whose manifest is **absent** (or that dies before wrap) closes with an empty `files_changed` → thin file record. Bounded (the note's other 6 blocks survive). Under F1's fix this becomes strictly smaller (the wrap derives files from context regardless), but confirm the absent-manifest path explicitly before landing.
   Source: `packets/R3-run-manifest.md` L185.

6. **P1 diagnostic — diagnose and log ONLY.** `decisions_refs: []` on a `project-planning` wrap that passed three `--decision-ref-from-header` flags. The filed diagnosis ("refs never reach the tempfile") was **falsified** by S1 (dump L189 + read-back L337 both work; the flag populates correctly from `ai-resources`). The only reproducible drop path is slug-derivation failure, which prints a **loud** `ref DROPPED (advisory)` line — and the filing session reports **no advisory fired**. That makes it a third, unexplained mechanism.
   **Discriminator:** re-run that wrap's exact `close` from the **`project-planning` cwd**, capturing full stdout/stderr. Advisory fires → cause is module resolution from a non-`ai-resources` cwd. Advisory does not fire → genuinely new mechanism; the tempfile hypothesis gets a second look.
   ⚠ **Do NOT edit `run-manifest.sh`** — 4+ wrap paths call it; it needs its own risk-checked session.
   Source: `logs/improvement-log.md` L519–534.

7. **Leftover A — stale mission headline.** `logs/missions/w32-migration-execution.md` open-thread bullet still reads *"still not shipped, now waiting only on P1 evidence"* — which **contradicts the corrected `🟢 GATE OPEN` text directly beneath it**. Same leftover-blocker error class the mission's own method lesson names.

8. **Leftover B — swept scratchpad.** A prior session's scratchpad was swept into `project-planning` commit `2eb9e91` by a directory-level `git add -A`. Untrack it (keep the file on disk).

## Execution Sequence

1. **Re-verify F1 against the live files** (do not trust this plan's line numbers alone). Confirm: (a) no caller invokes `run-manifest.sh update`; (b) canonical L227 and root L211 both source `--file` from note sections. **Verify:** both facts restated from a fresh read before any edit. If F1 is wrong, stop and re-plan — the cut is safe as the packet wrote it.
2. **Write the F1 finding into the R3 packet** as a Pass-2 correction (the packet is the durable design record; the next session must not re-derive this). **Verify:** the packet's "READY TO SHIP" section carries the blocker and the repoint fix.
3. **Apply the combined change to BOTH paired copies in lockstep** — the F1 `--file` repoint **and** the 2-section cut, in one edit per copy. Canonical 8→6, root mirror 7→6. `### Decisions Made` retained in both. F2 dissolves here. **Verify:** grep each copy for `### Files Created` / `### Files Modified` / `### Files Changed` → zero hits in the note schema; `### Decisions Made` → present in both; `--file` derivation → says "conversation context", names no note section.
4. **Repoint the collector's file signals** at the manifest, with absent-manifest fallback. Leave its decision signal alone. **Verify:** collector L33 no longer greps the three file-section names; still greps `### Decisions Made`.
5. **Check the absent-manifest path** (Finding 5). **Verify:** a stated, tested answer to "what does the note look like when the manifest is missing?" — not an assumption.
6. **`/risk-check`** on the combined change (paired Critical component; plan-time gate per mission non-negotiable). **Verify:** verdict recorded. ⚠ **RECONSIDER / NO-GO → redesign, do not override.**
7. **Verify + close R3** — mission thread + remediation-register row. **Verify:** register row flips to `verified`; packet status flips off `pass-1-verified`.
8. **P1 discriminator** (Finding 6) — run from `project-planning` cwd, capture full output, append the verdict to `improvement-log.md`. **Verify:** the entry states whether the advisory fired, and names the mechanism (or names it as still-unexplained). No script edit.
9. **Leftovers** (Findings 7, 8). **Verify:** mission headline no longer contradicts its own body; `git ls-files` no longer lists the scratchpad; the file still exists on disk.
10. **`/qc-pass`** on the combined change before commit.

## Scope Alternatives

- **Min** — F1 fix + the 2-section cut + collector repoint + `/risk-check` + close R3 (items 1–7). Drops the P1 diagnostic and the leftovers. Use if `/risk-check` forces a redesign and eats the session.
- **Recommended** — all 10 steps. The P1 diagnostic is cheap (one command run + a log append) and the leftovers are minutes.
- **Max** — Recommended + fix P1 itself. **Explicitly rejected and out of mandate:** `run-manifest.sh` is called by 4+ wrap paths and needs its own `/risk-check`. Diagnose, log, stop.

## Autonomy Posture
Gated.

**Stop points:**
- ⚠ **Before step 3's edit** — if step 1 *disconfirms* F1, the whole plan's shape is wrong. Stop and re-plan.
- ⚠ **`/risk-check` RECONSIDER or NO-GO** (step 6) — redesign, do not override. Mission non-negotiable: risk-check-class items pass the gate *before* execution, not retroactively.
- ⚠ **Absent-manifest check (step 5) reveals a real data-loss path** — hold the cut; reconsider retaining the file lists when `files_changed` is empty.
- ⚠ **P1 diagnostic tempts a script fix** — it is out of scope. Log and stop.

## Risk
**Structural change class — run `/risk-check` after this plan is approved (plan-time gate), and again before commit (end-time gate).**

Triggers: a **paired Critical component** (`wrap-session.md` × 2) plus an **agent** (`session-feedback-collector`); the edit **reorders operations against shared state** (the wrap's file-record write path), which the Step-6 tripwire names explicitly — the "existing-command refactor" framing does **not** exempt it.

Scope of the change grew at plan time: F1 means this is no longer a pure deletion but a **source-rewiring plus deletion**. That raises blast radius (the manifest's population path changes for every future session) and is exactly what `/risk-check` should score.

Environment-fit check: **N/A** — no executable or launcher is produced; the work is command/agent/doc edits only.
