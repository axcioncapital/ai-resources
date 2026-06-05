---
model: sonnet
---

Capture a lightweight session mandate for Phase 3 harness-style sessions. The operator's mandate context (if any) follows this prompt: $ARGUMENTS

---

**Boundary note — three session-start mechanisms exist:**
- `session-start.sh` script — run by the `mandate-parser` skill at harness entry (its Step 1); writes `harness/session/startup-state.json`; detects crashes. Not a `SessionStart` hook, not operator-invoked.
- `/session-start` (this command) — operator-invoked; captures a Phase 3 lightweight mandate; writes a single `**Mandate:**` line to `logs/session-notes.md`. Run after `/prime`.
- `mandate-parser` skill — full harness mandate capture; produces `harness/session/mandate.json`; used in Phase 5+ harness sessions. Not for Phase 3.

**Revert note:** If this command is removed, any `**Mandate:**` lines and `### Session Report` subsections already written to `logs/session-notes.md` remain and must be cleaned manually.

---

## Instructions

### Step 0 — Precondition check

Read `logs/session-notes.md` (last 10 lines). Check for a today-dated header matching `## YYYY-MM-DD` (today's date).

If no today-dated header is found: emit one warning line — `Note: /prime may not have run yet today. Proceeding.` — then continue. Do NOT block.

### Step 0.5 — Concurrent-session mtime guard

After Step 0's `session-notes.md` read, run a foreign-write check before reading the mandate. Catches the case where another active session wrote to `logs/session-notes.md` between this session's `/prime` and this `/session-start` invocation.

**Path assumption:** all paths in Step 0.5 are cwd-relative — the check assumes the cwd has not changed since `/prime` ran. The marker file (`logs/.prime-mtime`) is co-located with `logs/session-notes.md` in the cwd's git-root.

**Capture file state:**

```bash
SESSION_NOTES_MTIME=$(stat -f %m logs/session-notes.md 2>/dev/null \
                     || stat -c %Y logs/session-notes.md 2>/dev/null)
```

**Absent-file guard:** if `SESSION_NOTES_MTIME` is empty (the file truly does not exist — fresh repo, or `/session-start` invoked at a path with no `logs/` tree), there is nothing to detect a foreign write against. Skip Step 0.5 entirely and proceed to Step 1. Do NOT run the heuristic fallback (it would misclassify on empty input).

Otherwise, continue:

```bash
NOW=$(date +%s)
TODAY_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$(date '+%Y-%m-%d') 00:00:00" "+%s" 2>/dev/null \
              || date -d "$(date '+%Y-%m-%d') 00:00:00" "+%s")
```

(macOS `date -j -f` and Linux `date -d` both need an explicit `00:00:00` time component — without it, BSD `date` fills in the current hour/min/sec instead of midnight, breaking the freshness check.)

**Primary check (marker file).** If `logs/.prime-mtime` exists, read it (the mtime `/prime` wrote after its today's-header append in Step 8a.3.a, 8b.3.a, or 8c.3):

- **Freshness window:** if the marker mtime is older than today's start-of-day (`PRIME_MTIME < TODAY_EPOCH`), treat the marker as absent and fall through to the heuristic. Emit one loud line: `[Step 0.5] Note: logs/.prime-mtime is stale (older than today) — using 120s heuristic fallback.` Protects against stale markers from abandoned `/prime` chains.
- **Fresh marker:** compute `DELTA = SESSION_NOTES_MTIME - PRIME_MTIME`. If `DELTA > 0`, a foreign session wrote to `session-notes.md` after this session's `/prime` finished → set `FOREIGN_WRITE=1`. If `DELTA = 0`, the file mtime matches `/prime`'s marker → no foreign write → proceed silently to Step 1.

**Fallback (marker absent).** If `logs/.prime-mtime` is missing entirely, the operator may have invoked `/session-start` without `/prime`. Emit one loud line: `[Step 0.5] Note: logs/.prime-mtime absent — using 120s heuristic fallback.` Then compute `DELTA = NOW - SESSION_NOTES_MTIME`. If `DELTA < 120`, set `FOREIGN_WRITE=1`. Otherwise proceed silently.

**Shared-dir advisory (C.2, 2026-06-05).** When `FOREIGN_WRITE=1`, also run one **read-only** check for foreign uncommitted edits to shared command/doc files — a surface no guard watches (see `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` § 5):

```bash
FOREIGN_SHARED=$(git status --short -- .claude/commands docs 2>/dev/null)
```

Read-only (no `git add`, no write). If non-empty, append the dirty paths to the warning block as the `Shared files possibly mid-edit:` line below. If empty, omit that line.

**Warning shape (emit when `FOREIGN_WRITE=1`):**

> ⚠ Concurrent session likely. `logs/session-notes.md` was modified {DELTA}s ago — possibly by another active session writing a mandate. Re-read the file and confirm before proceeding.
>
> {Shared files possibly mid-edit (a concurrent session has uncommitted edits here — editing them risks a lost-update collision): {foreign-dirty paths under .claude/commands / docs} — only if FOREIGN_SHARED is non-empty}
>
> Options:
> 1. Proceed with the new mandate anyway (your mandate will stack below the other session's)
> 2. Stop and resolve manually (recommended)
>
> Default (no response within the turn): option 2 — stop.

**Tuning notes:**
- The 120s threshold matches the typical `/prime` → operator-response → `/session-start` window. Tune if false positives accumulate.
- The loud-fallback `[Step 0.5] Note:` lines make heuristic-fallback paths visible — silent degradation becomes loud.
- The freshness window is conservative (older-than-today) and accepts a small false-positive risk at midnight-rollover in exchange for blocking stale-marker false negatives from abandoned chains.

### Step 1 — Read the mandate

If `$ARGUMENTS` is non-empty, use it verbatim as `MANDATE_TEXT`.

Otherwise, ask the operator **one prompt** (wait for one answer):

> "State the session mandate. Optionally include `allowed_inputs:` (files/paths the session may read) and `required_outputs:` (files/artifacts the session must produce) to scope reads and writes explicitly."

### Step 2 — Parse and confirm

Extract from `MANDATE_TEXT`:

- `work_scope` — what work will be done, including explicit scope boundaries
- `out_of_scope` — what is explicitly excluded; default `"(none stated)"` if not mentioned
- `exit_condition` — what "done" looks like; must be observable or countable
- `files_in_scope` — which files may be edited; if not stated by the operator, infer from `work_scope` for the **echo only** so the operator can verify or correct it; flag internally as **inferred** (`files_inferred = true`). If the operator provides a correction via the confirmation step → set `files_inferred = false` and use the correction.
- `stop_if` — conditions that should halt the session; default `"(none stated)"` if not mentioned
- `allowed_inputs` — OPTIONAL. Explicit list of files/directories the session is authorized to read. No default — **absent means absent** (no `(none stated)` placeholder; the bullet does not appear in the echo or disk-write). Extract from `MANDATE_TEXT` if present via an `allowed_inputs:` prefix line, or via the correction syntax `a:` letter in Step 2's confirmation step.
- `required_outputs` — OPTIONAL. Explicit list of files/artifacts the session is expected to produce. No default — **absent means absent**. Extract from `MANDATE_TEXT` if present via a `required_outputs:` prefix line, or via the correction syntax `r:` letter in Step 2's confirmation step.

Echo the following confirmation block to the operator. Render it as Markdown — do NOT emit a raw pre-formatted code block, and do NOT emit the ``` fences shown below; those fences only delimit the template structure for this instruction. Follow these rendering rules exactly:

<!-- TODO: extract to shared rendering convention -->
<!-- Style applies to chat echo only. Step 3 disk-write contract is plain bullet labels; see Step 3 comment. -->

**Semantic marker set** (icons inside content only — never on section labels):
- `⚠` — warning / risk / attention-needed
- `↩` — resumable / continuation point
- `→` — forward action / to be done
- `✓` — done / verified / already in place
- `✗` — blocked / failed
- `·` — deferred / informational / out of scope

**Rendering rules:**
- Section labels: **bold inline** on their own line, content on the next line.
- Multi-item content: Markdown bulleted list, one item per line. Never inline `•` separators.
- File-to-change mappings: Markdown table when ≥3 files. Collapse to one row per file with all changes comma-separated. Use `inline code` for all paths, filenames, env vars, and command names.
- `---` horizontal rules separate the body zone (Work through Stop if) from the reply prompt.
- No paragraph exceeds ~3 lines — break into bullets if it would.
- One icon per list item maximum.
- The only `##` header is `## Mandate Confirmation`.

**Derivation constraints for synthesized fields:**
- `**Summary:**` — one sentence, ≤20 words. Capture the structural shape of the work: counts, file types, affected scopes. Append a brief deferred-scope clause only if out_of_scope is stated. Do not restate work_scope literally.
- `**{Section label}**` — present only when work_scope contains discrete deliverables (numbered steps, named items, or bullet-style tasks). Derive the label from the nature of the items: "Quick wins" for QW-framed batches, "Steps" for sequential work, "Tasks" for general items. Enumerate verbatim from work_scope. No re-ordering, no invention, no paraphrase.

**Output shape:**

```
## Mandate Confirmation

**Summary:** {one sentence, ≤20 words — structural shape of the work}  <!-- chat-echo only — NOT a parse field -->

**Work:** {work_scope — one sentence}

---

**{Section label}**  <!-- chat-echo only — NOT a parse field; label derived from work type -->
{for each discrete item in work_scope — if work_scope contains enumerable items:}
- → **{item label}** — {item description}
{if work_scope is a single undivided statement, omit this section entirely}

**Files**
{if ≥3 files:}
| Path | Changes |
|---|---|
| `{file}` | {what changes} |
{else: one bullet per file:}
- `{file}` — {what changes}
{if files_inferred = true, append "(inferred — correct with f: <paths> if wrong)" after the table/list}

**Allowed inputs**
{if allowed_inputs is set:}
- → {allowed_inputs — one bullet per path if multiple, comma-separated if single value}
{else: omit this section entirely}

**Required outputs**
{if required_outputs is set:}
- → {required_outputs — one bullet per path if multiple, comma-separated if single value}
{else: omit this section entirely}

**Out of scope**
{if out_of_scope is not "(none stated)":}
- · {out_of_scope — one bullet per item if multiple}
{else: omit this section entirely}

**Done when**
- ✓ {exit_condition — split into separate bullets if multiple observable conditions are stated}

**Stop if**
{if stop_if is not "(none stated)":}
- ⚠ {stop_if — one bullet per condition}
{else: omit this section entirely}

---

Reply `confirm` / `y` to accept, or correct fields with `b: <new text>` syntax.
```

`(none stated)` fields will be recorded as omitted — only correct if actively wrong.

Ask:

> "Reply `confirm` (or `y`) to accept, or list field corrections in the form `b: <new text>`. Bare single letters other than `y` are treated as ambiguous and re-asked."

Wait for one response. Apply these parser rules:
- **Confirmation:** response is exactly `confirm`, `y`, or `yes` (case-insensitive, trimmed) → proceed to Step 3.
- **Ambiguous single letter:** response matches `^[a-z]\.?(\s|$)` and is NOT exactly `y` → re-ask once:
  `"Reply 'confirm' or 'y' to accept, or use 'b: new text' syntax for corrections. Single letters other than 'y' are ambiguous."` Accept the re-response and proceed regardless.
- **Correction:** correction syntax is `<letter>: <replacement text>` (colon required, not period). Multiple corrections may appear on separate lines. Parse and apply each; unrecognised syntax is treated as free-text amendment to `work_scope`. **Reserved correction letters:** `a:` → `allowed_inputs`; `r:` → `required_outputs`; `f:` → `files_in_scope`. Other letters fall through to free-text amendment.

### Step 2.4 — Context discovery (engine pre-step)

After Step 2's parse and operator confirmation, BEFORE Step 2.5's self-check, optionally invoke the **`context-discovery` agent** to pre-populate `files_in_scope` / `allowed_inputs` / `required_outputs` from the active project's CLAUDE.md routing map. This step is the auto-fire entry point for the Context Engine; the manual entry is `/build-context`.

**Skip silently if any of these conditions hold** — no warning, no agent invocation, proceed directly to Step 2.5:

1. `work_scope` is fewer than 5 whitespace-separated tokens — too short to classify meaningfully.
2. `work_scope` matches a known meta-command literal: `/prime`, `/open-items`, `/wrap-session`, `/handoff`, `/clear` — these are session-management, not task work.
3. No `CLAUDE.md` exists at the project root: `! [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/CLAUDE.md" ]`. Workspace-root sessions and fresh repos without project CLAUDE.md are not engine targets — the engine has no routing map without one.

**Otherwise, invoke the agent** via the Agent tool with `subagent_type: context-discovery` and pass three fields:

- `TASK_DESCRIPTION = {work_scope}` (the parsed sentence from Step 2, verbatim)
- `CWD_PROJECT = $(git rev-parse --show-toplevel)`
- `INVOCATION_MODE = auto-session-start`

The agent returns a fixed-template summary per `ai-resources/docs/context-pack-schema.md § 5b`. Parse its first line for outcome class:

| First line shape | Outcome class | Action |
|---|---|---|
| `**Pack:** {abs path} \| tracked` or `\| untracked` | `success-enriched` or `success-insufficient` (distinguish by reading the readiness booleans in lines 5–6 of the summary) | Read pack frontmatter (below) |
| `**Pack:** (skipped — {reason})` | `engine-skipped` | No pack; proceed to Step 2.5 with the original parsed mandate, no re-emit |
| `**Pack:** (none — engine failed){...optional cause...}` | `engine-error` | Log one chat line: `Note: context engine failed — {cause from summary, or "no cause given"}. Proceeding with parsed mandate.` Then proceed to Step 2.5 with the original parsed mandate |

**No timeout enforcement.** The Agent tool runs to completion; the engine is best-effort and may take 30–90 seconds for substantive tasks. If the engine never returns, the calling chain stalls — the operator can interrupt and re-invoke without the engine pre-step.

**For `success-enriched` and `success-insufficient` outcomes**, Read the pack file at the path from line 1 of the summary. Parse its YAML frontmatter for the structured fields the summary's parse contract (schema § 5b) defers to disk:

- `files_in_scope` (array)
- `allowed_inputs` (array, may be absent)
- `required_outputs` (array, may be absent)
- `sufficient_to_plan` (boolean)
- `sufficient_to_implement` (boolean)

Apply to the parsed mandate state:

1. **`files_in_scope`** — if `files_inferred = true` (operator did not explicitly state or correct this field in Step 2), REPLACE the `(inferred)` marker with the engine's concrete list and set `files_inferred = false`. If the operator stated or corrected `files_in_scope` in Step 2, keep the operator's value and leave the engine's list unused — operator intent wins.
2. **`allowed_inputs`** — if currently unset, SET to the engine's value. If the operator already set it in Step 2, keep the operator's value.
3. **`required_outputs`** — same precedence rule as `allowed_inputs`.
4. **`pack_path`** — capture as `PACK_PATH` for Step 3's mandate-line write.
5. **`pack_tracked`** — capture the `tracked|untracked` token from line 1 as `PACK_TRACKED`; carry to the re-emit block.

**Re-emit the Step 2 confirmation block** with outcome class visible. Use one of three header lines depending on outcome — operator must SEE the readiness state, not have it silently absorbed:

- `success-enriched`: `## Mandate Confirmation — Engine pack: enriched ({pack_tracked})`
- `success-insufficient`: `## Mandate Confirmation — Engine pack: insufficient — {readiness gap, e.g., "sufficient_to_implement=false (3 missing-context items)"} ({pack_tracked})`
- For `engine-skipped` / `engine-error`: do NOT re-emit; the original Step 2 confirmation already showed.

Add a `**Context pack**` section between `**Required outputs**` and `**Out of scope**` in the re-emit:

```
**Context pack**
- → `{PACK_PATH}` ({PACK_TRACKED}) — {N} files in scope, {N} allowed inputs, {N} required outputs, {N} missing-context items
```

Apply the original Step 2 echo rendering rules (sections only when populated, etc.) and the original correction syntax — the operator can still override engine-derived fields via `b:` / `a:` / `r:` / `f:`. Wait for one response per Step 2's parser rules, then proceed to Step 2.5.

If the operator's response is a free-text amendment that contradicts the engine's discovery (e.g., they add a file the engine missed), trust the operator. The engine is advisory.

### Step 2.5 — Self-check before writing

Before proceeding to Step 3's disk write, validate the parsed mandate against the following floor — if any check fails, fix the field in place (silently if straightforwardly derivable, or by re-asking the operator with one targeted question if not). Mirrors `/session-plan` Step 7 self-check pattern. Inline check; no subagent.

1. **`work_scope` is one substantive sentence**, not a bare topic word and not multiple sentences. A topic word (e.g., "permissions") fails because it doesn't name what the session will produce; re-derive a single sentence from `MANDATE_TEXT` or re-ask the operator with: `work_scope reads as a topic, not a deliverable — restate it as "{action} {subject} {scope/exit}".`
2. **`exit_condition` is observable or countable.** Phrases like "done", "complete", "finished" without an observable signal fail. Acceptable shapes: file written, item checked off, finding addressed, commit landed, count reached. Re-derive from `MANDATE_TEXT` context if not stated; if still ambiguous, re-ask: `exit_condition is not observable — state what "done" looks like on disk or in git.`
3. **`files_in_scope` either lists ≥1 concrete path OR is explicitly `(inferred)`.** Empty / bare placeholder fails. If `files_inferred = true`, the `(inferred)` marker carries forward to Step 3; this is the only acceptable non-listed shape.
4. **`stop_if` is either `(none stated)` OR names a concrete halt condition** (a verdict, a counter, a state). Vague stops like "if things go wrong" fail; re-derive or strip to `(none stated)`.

Re-asks happen at most once per failed field. If a re-ask response is still non-conformant, accept it and proceed — `/qc-pass` and `/drift-check` are the downstream catchers per workspace `Decision-Point Posture`. Self-check failures that auto-fixed silently must be logged in a one-line note appended to the Step 4 "Mandate written" confirmation: `Self-check auto-fixed: {field}: {old} → {new}`. Re-ask-resolved failures get no log.

### Step 3 — Write the mandate line

<!-- LOAD-BEARING: bullet labels below are parsed verbatim by /wrap-session Step 7a. Do not stylize. If Step 2 echo styling changes, do NOT propagate here. -->

**Mandate line format (exact):**

```
**Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
- Out of scope: {out_of_scope}
- Files in scope: {files_in_scope_written}
- Stop if: {stop_if}
- Allowed inputs: {allowed_inputs}      ← write only if allowed_inputs is set; omit the bullet entirely if absent (no placeholder)
- Required outputs: {required_outputs}  ← write only if required_outputs is set; omit the bullet entirely if absent (no placeholder)
- Context pack: {pack_path}             ← write only if Step 2.4 produced a pack (PACK_PATH is set); omit entirely if Step 2.4 was skipped, errored, or never invoked. Informational bullet — see parse-contract note below.
```

**Parse contract:** Six readers (verified pre-flight, 2026-05-29; sixth added 2026-06-05) depend on the exact bullet labels (`- Out of scope:`, `- Files in scope:`, `- Stop if:`, `- Allowed inputs:`, `- Required outputs:`), the `(inferred)` marker, and the `(none stated)` marker written here:
1. Canonical `wrap-session.md` Step 7a (coaching-data classification).
2. Workspace-root `wrap-session.md` Step 2b (Phase 3 session report).
3. `drift-check.md` Step 5 (mandate auto-detection for drift judgment).
4. `contract-check.md` Step 2.5c (session-notes mandate-block contract-source detection).
5. `monday-prep.md` writes a separate week-mandate (bold-header format, not bullet) — does not consume this bullet schema.
6. `concurrent-session-check.md` Step 3 (reads `- Files in scope:` to gather each live session's declared footprint for the pre-flight collision check). Read-only consumer.

Do not rename these labels or marker strings without updating all readers. The `Allowed inputs` and `Required outputs` bullets are optional — when absent, the bullets do not appear (no `(none stated)` placeholder).

The `- Context pack:` bullet (added 2026-05-29 for the Context Engine Phase 2) is **informational, not part of the parse contract.** All five readers above use fixed-list extraction or labeled-bullet pass-through; they silently ignore `- Context pack:`. The bullet exists for the operator to see which pack contributed to the mandate when reviewing session-notes later, and for future Phase 2 consumers (pre-edit check, drift-relative-to-pack) to locate the pack.

Where `files_in_scope_written` is:
- `(inferred)` — if `files_inferred = true` (operator did not state or correct this field)
- the operator's stated/corrected value — if `files_inferred = false`

Resolve this session's marker (see `docs/session-marker.md` § Marker resolution — per-session-id oracle first, loud fallback to the shared file). If `MARKER` is empty, hard-fail per the uniform writer contract: `[/session-start Step 3] HARD-FAIL: session marker unresolved (logs/.session-marker-${CLAUDE_CODE_SESSION_ID} and shared logs/.session-marker both absent or stale). Run /prime to populate the marker for this session, then retry.`

Using the `logs/session-notes.md` content already read in Step 0 (re-read the last 10 lines if Step 2 took >30s — the marker-scoped header still requires a fresh read since Step 0's snapshot may be stale), locate this session's marker-bearing header.

- If a header matching `^## YYYY-MM-DD — Session ${MARKER}` exists: append the mandate line immediately after that header, before any existing body content.
- If the marker-bearing header is absent: append to the file:
  ```
  ## YYYY-MM-DD — Session ${MARKER}
  **Mandate:** {one-sentence summary of work_scope} — done when: {exit_condition}
  - Out of scope: {out_of_scope}
  - Files in scope: {files_in_scope_written}
  - Stop if: {stop_if}
  - Allowed inputs: {allowed_inputs}      ← write only if set; omit if absent
  - Required outputs: {required_outputs}  ← write only if set; omit if absent
  - Context pack: {pack_path}             ← write only if Step 2.4 produced a pack; omit if absent
  ```

### Step 4 — Confirm and chain to `/session-plan`

Output exactly:

```
Mandate written → logs/session-notes.md
Proceeding to /session-plan.
```

Then **chain-invoke `/session-plan`** immediately, passing `work_scope` verbatim as `$ARGUMENTS`. Use the Skill tool: `skill = "session-plan"`, `args = "{work_scope}"` (the exact `work_scope` string parsed in Step 2). Do not pause for operator confirmation before invoking — the chain is the default path.

**Chained-mode contract:** `/session-plan` Step 0 retains all of its existing pause points (same-session 3-option prompt; concurrent-session collision; missing `/prime` header; `(none derived)` sentinels). Those are the only legitimate gates. Everything else runs through to the plan write and the session begins under the declared autonomy posture without further confirmation.

**If Step 2.5 self-check auto-fixed a field silently:** still chain — the self-check's one-line note already surfaced the fix. Do not add a second confirmation prompt.

**Skip the chain only if:** Step 0 emitted the concurrent-session warning AND the operator chose option 2 (stop and resolve manually); or Step 2's confirmation parser returned an ambiguous response after the one re-ask. In either skip case, emit the original handoff line `**Next:** Run \`/session-plan\` to plan model tier, source material, autonomy posture, and structural risk for the session.` and stop.
