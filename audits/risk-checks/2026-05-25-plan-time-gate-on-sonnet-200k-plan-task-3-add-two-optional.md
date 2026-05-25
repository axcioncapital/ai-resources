# Risk Check — 2026-05-25

## Change

Plan-time gate on Sonnet 200k plan Task 3 — add two optional mandate fields (`allowed_inputs:` and `required_outputs:`) to `/session-start` and extend `/wrap-session` Step 7a to recognise them.

**Proposed change (two-file edit):**

File 1: `ai-resources/.claude/commands/session-start.md`
- Step 2 (Parse and confirm): add `allowed_inputs` and `required_outputs` to the extracted-fields list as OPTIONAL fields (no `(none stated)` default — absent means absent).
- Step 2 echo: add two corresponding sections to the chat-echo template that omit entirely when absent (mirrors current treatment of "Out of scope" / "Stop if" when not stated).
- Step 3 (Write the mandate line): extend the disk-write format with two new optional bullets, written ONLY when populated:
  ```
  - Allowed inputs: {value}
  - Required outputs: {value}
  ```
  No `(none stated)` placeholder when absent — bullets simply don't appear.
- Step 3 parse-contract note: update to name the two new bullet labels alongside the existing three.

File 2: `ai-resources/.claude/commands/wrap-session.md`
- Step 7a: extend bullet-recognition to include `- Allowed inputs:` and `- Required outputs:` alongside the existing three. Classification: any present bullet → **specified**; absent bullet → **omitted**. No `(inferred)` state for these (no inference path defined).

**Blast radius:** Every `/session-start` invocation (writes mandate to `logs/session-notes.md` in every project), every `/wrap-session` invocation (parses the mandate block and writes coaching-data.md entry). Both commands are auto-symlinked to every project.

**Why this change:** From the Sonnet 200k efficiency plan (Task 3, reshape of recs #2+#3 per system-owner advisory 2026-05-25). Operator-supplied scoping helps Sonnet-tier sessions stay bounded.

**Additive properties claimed (to verify):**
- Existing sessions with no new fields → mandate line and coaching entry unchanged.
- Existing mandate blocks in historical `logs/session-notes.md` → Step 7a treats them as not having the new fields (correct: those sessions didn't have the fields).
- No existing bullet label renamed; no existing parse path removed.
- No (inferred) state for the new fields; absence is the explicit signal.

**Tripwire check:** Does this *reorder* operations against shared state? No — it adds optional bullets at end of the existing Mandate block. Existing bullet labels and order preserved.

**Risk gates of concern:** (1) parse-contract drift between session-start writer and wrap-session reader, (2) coaching-data.md schema expansion (auto-expanding `specified`/`omitted` lists — confirmed intentional per plan §121), (3) operator discoverability of the new fields (how does operator know to use them — handled via documentation in command body).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/coaching-data.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Additive bullet contract is genuinely backwards-compatible at the writer/reader pair (session-start ↔ wrap-session); one third-party reader (`drift-check`) and one second-derivative consumer (coaching-data schema) require explicit acknowledgement, and the discoverability concern flagged in the description is not fully resolved by command-body documentation alone.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is modified — `session-start.md` and `wrap-session.md` are pay-as-used slash commands, loaded only on invocation (verified: both have `model: sonnet` frontmatter, no `@import` chain into workspace or repo CLAUDE.md).
- Step 2 echo gets two more optional sections that render only when populated (`session-start.md:95–106` shows the current pattern — "omit this section entirely" when `(none stated)`). Token cost is bounded to ~10–20 tokens per invocation when fields ARE used; zero token cost when omitted.
- Step 3 disk-write adds two optional bullets to `logs/session-notes.md` — append-only, no impact on subsequent session token loads (mandate blocks are not auto-loaded).
- Step 7a parse logic extension adds ~3 lines to `wrap-session.md` body; loaded once per `/wrap-session` invocation.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` modifications described.
- No new tool families invoked (still `Read`, `Edit`, `Write`, `Bash` — same as current command surface).
- No `allow` / `deny` / `ask` changes; no new Bash patterns, no new Write paths beyond the existing `logs/session-notes.md` and `logs/coaching-data.md` writes.

### Dimension 3: Blast Radius
**Risk:** Medium

Files directly touched: 2 (`session-start.md`, `wrap-session.md`).

Grep'd callers and downstream readers of the mandate-block contract:

- `drift-check.md:26` — explicitly parses the mandate block: *"capture its mandate content as `MANDATE` — the `**Mandate:**` line plus any `In scope` / `Out of scope` / `Stop if` / `Class:` lines that follow it"*. This is a **third reader of the same shared state** the change is touching. The drift-check parser is bullet-name-aware but only enumerates four labels (`In scope`, `Out of scope`, `Stop if`, `Class:`). Two new bullets (`Allowed inputs`, `Required outputs`) will be **silently dropped from drift-check's MANDATE capture** unless drift-check is also updated. The plan describes a two-file edit; this is a **third file requiring modification** for full coverage.
- `monday-prep.md:252,258` — uses `**Out of scope:**` and `**Files in scope:**` as Markdown section headers (not as `- ` bullet labels) in its own template output. These are template emissions, not parse points on the mandate block — no impact. False positive on grep.
- `wrap-session.md:50–64` — writer/reader pair on the same file as the change, fully covered by the two-file edit.

Coaching-data.md schema impact (`coaching-data.md:6,37,53,62,78`): the `Mandate fields:` line will start enumerating `Allowed inputs` and `Required outputs` in `specified` / `omitted` lists once Step 7a is updated. Plan §121 confirms this is intentional. Historical entries (no new bullets) classify correctly as `omitted` for both — verified against `coaching-data.md:6` ("specified: work_scope, exit_condition, stop_if | omitted: out_of_scope, files_in_scope") which already shows omitted-list expansion is the normal pattern. **No retroactive damage** to historical coaching entries.

Historical session-notes.md mandate blocks: parsed by drift-check (if invoked) and wrap-session Step 7a. Both default to "bullet absent → omitted" or "not enumerated → not extracted" — additive change is genuinely non-breaking at the reader contract.

Total callers identified: 3 (session-start writer + wrap-session reader + drift-check reader). Of these, 2 are in scope for the described edit; **1 (drift-check) is silently uncovered** and would degrade in functionality (mandate-content capture incomplete) without modification, though it wouldn't crash.

### Dimension 4: Reversibility
**Risk:** Medium

- The two command-file edits revert cleanly via `git revert` — single-file edits on `session-start.md` and `wrap-session.md`, no sibling files created.
- **State propagation:** every `/session-start` invocation after the change lands writes the new bullet labels to `logs/session-notes.md` (in any project where the symlinked command runs). After a revert, those bullets remain in historical session notes. Wrap-session Step 7a parsing reverts too, so the bullets would become unparsed — **silent stale data**, not a crash.
- **Coaching-data.md state propagation:** new entries written between change-land and revert contain expanded `Mandate fields:` lists naming `Allowed inputs` / `Required outputs`. After revert, those entries become semantically stale (reference labels the parser no longer recognises), but `coaching-data.md` is append-only and the stale entries don't break new appends.
- Operator-side cleanup: `git revert` does not undo any session-notes.md / coaching-data.md entries already written. The operator would need to know not to act on `Allowed inputs:` / `Required outputs:` in historical entries.
- No external state propagation (no `git push`, no Notion write, no MCP server interaction).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Coupling to drift-check parser (Dimension 3 cross-reference).** The change implicitly assumes only `wrap-session.md` Step 7a reads the mandate block. `drift-check.md:26` is a second reader and is not enumerated in the change description. This is the same class of bug the `session-start.md:138` parse-contract note was designed to prevent: *"Do not rename these labels or marker strings without updating Step 7a."* That note names Step 7a but not drift-check. The contract is documented but **incompletely enumerates its consumers**.
- **Operator discoverability.** The change description flags this concern and says it's "handled via documentation in command body." That handling is necessary but not sufficient: a non-developer operator stating a mandate verbally does not naturally enumerate `allowed_inputs` or `required_outputs` unless prompted. The Step 1 prompt (`session-start.md:32`) is a single open prompt: *"State the session mandate."* Without a prompt update or example, the new fields will rarely be populated, and the Sonnet 200k efficiency benefit (the stated rationale) won't materialise. The plan does not specify a Step 1 prompt-text update.
- **Step 2 correction-syntax letter assignment.** The current parse contract (`session-start.md:122–123`) uses `<letter>: <replacement text>` for corrections. Existing fields claim letters by convention from echo order (work_scope → w, files → f, etc.). Two new fields need letter assignments and need to not collide with `b:` (the system's generic free-text amendment fallback). Not addressed in the change description.
- **No functional overlap** with existing mechanisms; the two fields are new semantic territory.

## Mitigations

- **Dimension 3 (Blast Radius):** Before committing the two-file edit, extend `drift-check.md:26` to enumerate `Allowed inputs` and `Required outputs` alongside the existing four labels. One-line addition. This converts the two-file edit into a three-file edit and closes the silent-consumer gap.
- **Dimension 4 (Reversibility):** Add a one-line note in each command body's instructions stating the new bullets are append-only-additive and a revert leaves historical bullets unparsed-but-harmless. The operator then knows not to act on stale labels post-revert. Cost: ~30 tokens per command, applies only when revert path is taken.
- **Dimension 5 (Hidden Coupling — discoverability):** Update `session-start.md:32` Step 1 prompt to mention the two new optional fields explicitly — for example, *"State the session mandate. Optionally include `allowed_inputs:` and `required_outputs:` to bound Sonnet-tier sessions."* Without this, the fields won't be populated in practice and the change's rationale (Sonnet 200k efficiency) won't realise.
- **Dimension 5 (Hidden Coupling — correction-syntax letter collision):** Assign explicit correction-syntax letters for the two new fields in Step 2 (e.g., `a:` for `allowed_inputs`, `r:` for `required_outputs`), and confirm they don't collide with reserved letters (`b:` is the free-text fallback; `y`, `f`, `w` are already in use by convention).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to `session-start.md` (lines 32, 95–106, 122–123, 132–135, 138, 150–153), `wrap-session.md` (lines 50–64), `drift-check.md` (line 26), `monday-prep.md` (lines 252, 258), `plans/sonnet-200k-efficiency-implementation.md` (lines 100–124), `coaching-data.md` (lines 6, 37, 53, 62, 78). Grep counts on parse-contract labels (`Out of scope` / `Files in scope` / `Stop if`) and on `Allowed inputs` / `Required outputs` (zero current uses across the repo — confirmed via `grep -rn`) were used to enumerate consumers and confirm the labels are new. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

### Routing position

The change touches `ai-resources/.claude/commands/session-start.md` and `ai-resources/.claude/commands/wrap-session.md` — both canonical commands auto-symlinked to every project (`repo-architecture.md` § Canonical homes by artifact type; § Symlink topology). Placement is correct: this is the right home and the right edit pattern. Q5 routing correctly fires `/risk-check`, since the change is "automation with shared-state effects" (the mandate block is read across multiple downstream consumers). No restructuring needed.

### Architectural commentary — do we concur with PROCEED-WITH-CAUTION?

**We concur.** The verdict is correct, but the recommended four-mitigation path is incomplete on two counts and the framing of mitigation #1 is wrong. Detail below.

**Concurrence rationale:**
- The additive-bullet contract is genuinely backwards-compatible at the writer/reader pair the change touches (`principles.md § DR-7 / AP-7` — the change does not generalize, it appends; this is the right shape).
- The dimension review correctly identified the parse-contract two-end coupling (`session-start.md:138` explicitly names Step 7a but not other consumers — this is `risk-topology.md § 5 Signals that elevate a change to structural risk`: "Change modifies a string literal matched by another component (two-end contract)").
- Discoverability concern is real: `principles.md § OP-6` (mental-model transfer): the change adds capability the operator must discover; the single open Step 1 prompt does not transfer the new affordance.

### Risks the dimension review missed

**Missed reader #1 — the workspace-root `/wrap-session` (Phase 3 variant).** The risk-check identifies `drift-check.md:26` as the third reader and treats this as a three-file edit. There is a **fourth reader** the review did not flag:

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` Step 2b, lines 33–34 — a workspace-root copy of `/wrap-session` that runs only in workspace-level sessions (per its own scope guard at line 17). Step 2b's Phase 3 session report parses `- Out of scope:` (line 33) and `- Files in scope:` (line 34) from the mandate block. Both new bullets (`Allowed inputs`, `Required outputs`) would be silently dropped from the Phase 3 session report's `files_in_scope` comparison logic — specifically the line: `"Files modified vs. files_in_scope: {match | divergence noted | n/a}"` (line 52).

This is the same defect class as the drift-check gap, against the same shared-state contract (`risk-topology.md § 5`). Converting the change to a **four-file edit** is the correct scope.

**Missed defect #2 — mitigation #1's enumeration is wrong relative to ground truth.** Mitigation #1 says: "extend `drift-check.md:26` to enumerate `Allowed inputs` and `Required outputs` alongside the existing four labels (`In scope` / `Out of scope` / `Stop if` / `Class:`)." But `/session-start` Step 3 actually writes `Out of scope` / `Files in scope` / `Stop if` — there is no `In scope` and no `Class:` written today. `drift-check.md:26` already enumerates labels that `/session-start` does not write, and omits `Files in scope` that it does write. This is a pre-existing drift bug between drift-check and session-start, separate from this change. Mitigation #1 should:
- **Correct the existing drift** in `drift-check.md:26` to match the labels `/session-start` actually writes (`Out of scope`, `Files in scope`, `Stop if`).
- **Then add** the two new labels (`Allowed inputs`, `Required outputs`).

Otherwise mitigation #1 lands the same pre-existing defect forward, in a slightly different shape (`principles.md § OP-11` — surfacing tacit drift is a recurring obligation; AP-1 silent-conflict resolution).

**Missed wording change inside `wrap-session.md:51`.** The canonical Step 7a says "extract the three sub-bullets" — hardcoded count in prose. Extending the parser to five labels requires either changing "three" to "five" or rewording to "the sub-bullets named in the parse contract" (the latter is more resilient; `principles.md § AP-3` — constraints over procedures). The risk-check report's mitigations list does not call this out.

**Missed acknowledgement on coaching-data.md schema-expansion semantics.** `coaching-data.md`'s `Mandate fields:` line is append-only across history. Once the new labels start appearing in `specified`/`omitted` lists, any downstream analytic over `coaching-data.md` (e.g., a future Friday cadence report or coaching-data summarizer) that counts category sizes will see a discontinuity at the cutover date. The risk-check report notes the schema expansion is intentional per plan §121 but does not flag the analytic-discontinuity for any downstream consumer that aggregates over the file. This is a low-severity `risk-topology.md § 3 Risk Classification`-style point (`coaching-data.md` is append-only documentation and no current consumer aggregates it), but it deserves a one-line acknowledgement in the change body so a future consumer doesn't trip over it.

### Mitigation set — corrected

We concur with mitigations 2, 3, and 4 from the risk-check as stated. The set we'd land is:

1. **Mitigation #1 — corrected and expanded into two mitigations:**
   - **1a.** Fix the pre-existing drift in `drift-check.md:26`: replace `In scope` / `Class:` with the labels `/session-start` actually writes (`Out of scope`, `Files in scope`, `Stop if`). This is a defect-fix, not part of the new change, but it's blocking — otherwise mitigation 1b lands forward-drift.
   - **1b.** Then extend `drift-check.md:26` to add `Allowed inputs`, `Required outputs`.
   - **1c.** Extend workspace-root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` Step 2b (lines 33–34) to enumerate `- Allowed inputs:` and `- Required outputs:` alongside the existing two. **This converts the change to a four-file edit, not three.**

2. **Mitigation #2 (Step 1 prompt update)** — concur as stated.

3. **Mitigation #3 (correction-syntax letters)** — concur. `a:` for `allowed_inputs` and `r:` for `required_outputs` are both unreserved per the current letter conventions (`session-start.md:122–123` — `b:` is the free-text fallback; conventional letters in use: `w`, `f`, plus `y`/`yes`/`confirm` for confirmation). Verify no collision in the live command before commit.

4. **Mitigation #4 (revert-note)** — concur. Add the one-line note in `session-start.md` Step 3 and `wrap-session.md` Step 7a. Also: change `wrap-session.md:51`'s hardcoded "three sub-bullets" to "the sub-bullets named in the parse contract" — robust against future additive extensions.

5. **New mitigation #5** — one-line acknowledgement in `coaching-data.md`'s consuming code or, failing that, in `wrap-session.md` Step 7b's body, that the `Mandate fields:` schema is monotonically expanding and any aggregator across history must handle pre/post-cutover label sets. Low-severity; defer if operator prefers minimal infra subset.

### Clear position

The right answer is: **proceed under PROCEED-WITH-CAUTION, but execute the corrected four-file edit (not three-file), fixing the pre-existing drift-check ↔ session-start label drift as a precondition to mitigation 1b.**

The framing here is `principles.md § OP-3` (loud failure over silent continuation) applied to the parse contract itself: the contract is already silently inconsistent with two of its consumers (drift-check enumerates wrong labels; workspace-root wrap-session.md Step 2b is an unenumerated reader). Landing the additive extension without surfacing those gaps repeats `principles.md § OP-11` — tacit drift continuing forward unfixed.

If the operator prefers the **minimal infra subset** (per `feedback_minimal_infra_subset.md` posture): drop mitigations #4 (revert note) and #5 (coaching-data acknowledgement). They are low marginal value at this stage. **Do not drop the four-file edit scope or the pre-existing drift correction** — both close real silent-consumer gaps.
