# Risk Check — 2026-07-04

## Change

Proposed structural change (2 files): (1) NEW command ai-resources/.claude/commands/reconcile-activate.md — `/reconcile-activate [project-path]`. Scaffolds STARTER-DRAFT versions of the two files /reconcile requires in a target project: context/mandate-rubric.md and context/resource-activation-map.md. It derives content from the project's logs/session-notes.md `**Mandate:**` line, the project CLAUDE.md, project-brief.md if present, and a listing of context/ files (for the resource inventory). Output carries a prominent top-of-file `> **⚠ DRAFT — NOT RATIFIED**` banner and placeholder dimensions with author-prompts. Hard rule: NEVER overwrite an existing context/mandate-rubric.md or context/resource-activation-map.md — if either exists, skip it and report. (2) MODIFY ai-resources/.claude/commands/reconcile.md Step 2 — after confirming both files exist, detect the un-ratified DRAFT banner; if present, abort with ratification instructions instead of judging. Also update the Step-2 abort message + the command's prose (line 9/39) to point operators to /reconcile-activate as the scaffolder. PURPOSE: /reconcile is fully built but dormant in ~20 of 21 projects because both reference files are hand-authored and only projects/buy-side-service-plan/ has them; the scaffolder lowers activation cost while the DRAFT-gate preserves the operator-ratification guarantee (prevents an auto-drafted rubric silently becoming a pass-everything rubber-stamp). CONSUMERS: /reconcile currently has files in only buy-side-service-plan; the Step-2 change affects all future /reconcile runs across all projects. The new command has no existing consumers. Context: SO consult already verdicted this BUILD priority-1; see audits/working/reconciliation-layer-coverage-2026-07-04.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/reconcile-activate.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/reconcile.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/reconcile-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/context/mandate-rubric.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/context/resource-activation-map.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped activation-cost fix that stays advisory and preserves the operator-ratification guarantee; two Medium dimensions (a shared-command contract change touched by every future `/reconcile` run, and a new un-documented banner-string contract split across two files) drive the caution, both closable with concrete pre-land mitigations.

## Consumer Inventory

Search terms: `reconcile-activate`, `/reconcile-activate`, `reconcile` (word), `reconcile-reviewer`, `mandate-rubric.md`, `resource-activation-map.md`, `NOT RATIFIED` (banner marker). Grepped across `ai-resources/` and the workspace root one level up.

Key grep results:
- `reconcile-activate` — **0 hits** anywhere (new command has no existing consumers; new banner contract has no existing consumers except the Step-2 gate added in the same change).
- `NOT RATIFIED` — 0 hits in any structural file (commands/agents/hooks/docs); the 4 hits found are unrelated project decision-log prose about "ratified" outcomes. The banner convention is genuinely new.
- `mandate-rubric.md` / `resource-activation-map.md` as actual instances — exist in **only** `projects/buy-side-service-plan/context/` (confirmed via `find` across `projects/`).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/reconcile-reviewer.md | invokes (spawned by `/reconcile` Step 4) + parses (reads both contract files) | no — gate sits at Step 2, upstream of the subagent spawn; the reviewer never receives a DRAFT-banner file |
| ai-resources/.claude/commands/graduate-resource.md (line 148) | documents (origin note: `/reconcile` "shipped present-but-inert" in ~20 projects lacking the two runtime inputs) | no — optional consistency update to note the scaffolder now exists |
| ai-resources/docs/reconcile-report-template.md | documents/parses (defines what both contract files must contain — the natural canonical home for the banner string) | no (hard) / **should** — best single home to define the banner contract once |
| ai-resources/docs/reconcile-failure-taxonomy.md | documents (references both contract files + fix-closure channels) | no |
| ai-resources/docs/reconcile-verdict-definitions.md | documents (references mandate-rubric.md) | no |
| ai-resources/docs/reconcile-genericness-heuristics.md | documents (loaded by reconcile-reviewer) | no |
| ai-resources/docs/agent-tier-table.md (lines 38, 88) | documents (reconcile-reviewer tier entries) | no |
| projects/buy-side-service-plan/context/mandate-rubric.md | co-edits / live-instance (the one running instance; must NOT regress under the new gate) | no — carries a `> **What this file is:**` blockquote, NOT a DRAFT banner; must stay runnable |
| projects/buy-side-service-plan/context/resource-activation-map.md | co-edits / live-instance | no — same; no DRAFT banner, must stay runnable |
| All future `/reconcile` runs across all ~21 projects | invokes (Step-2 gate is on the execution path of every run) | no — backwards-compatible; only aborts when the new banner is present |

Total: **9 distinct consumers, 0 hard must-change, 2 should-change** (reconcile.md prose — already inside the change scope; reconcile-report-template.md as the banner-contract home — a mitigation recommendation). The new command `reconcile-activate.md` has no consumers yet; the inventory above covers the contract (the DRAFT banner + the two scaffolded files) it will introduce.

Blast-radius note surfaced by the inventory (not fully anticipated by CHANGE_DESCRIPTION): the two **live buy-side instances open with a `> **What this file is:**` blockquote** (mandate-rubric.md line 3, resource-activation-map.md line 3). The Step-2 gate greps inside exactly these files — a loose match (`> **` or bare `DRAFT`) would false-positive on that existing blockquote and strand the one working project. Carried into Dimensions 3 and 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The new command is pay-as-used, invoked on demand only — no always-loaded content. `/reconcile-activate` is a slash command in `.claude/commands/`, not a hook, not an `@import`, not registered in any always-loaded CLAUDE.md. Grep for `reconcile-activate` returned 0 hits, confirming nothing auto-loads it.
- The Step-2 modification to `reconcile.md` adds a banner-detection grep + abort branch that runs **only when `/reconcile` runs** (on demand). `reconcile.md` frontmatter is `model: opus` with `allowed-tools: Bash(git *), Read, Task, Skill(contract-check)` (lines 2–4) — an on-demand analytical command, not a per-session/per-tool-call path.
- Neither file adds a SessionStart/Stop/PreToolUse/UserPromptSubmit hook and neither is `@import`ed into a per-turn file. No ongoing token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- `CHANGE_DESCRIPTION` describes no settings.json / deny-rule / scope changes. No `allow`/`ask`/`deny` mutation is in scope.
- The new command introduces a **Write** capability (it scaffolds two files into a target project's `context/`) that the existing `reconcile.md` does not hold (its `allowed-tools` is read/git/Task only, line 4). This Write is declared in the *new command's own frontmatter*, not a global settings widening, and writing scaffold files into `context/` is within the repo's established command-scaffolding patterns. The `[project-path]` argument makes the write target parameterized, but the hard NEVER-overwrite rule (skip-if-exists) bounds it to net-new files.
- No shell escalation, no cross-repo/external capability, no deny-rule removal, no project→user scope escalation. Within-pattern addition → Low.

### Dimension 3: Blast Radius
**Risk:** Medium

Grounded in the Step 1.5 inventory: **9 consumers, 0 hard must-change, 2 should-change.**

- Direct files touched: **2** — new `reconcile-activate.md`; modify `reconcile.md` Step 2 + prose (lines 9, 39).
- The Step-2 change is a **contract change on a shared command that is on the execution path of every future `/reconcile` run across all ~21 projects** — the highest-fan-out point in the change. It is, however, **backwards-compatible**: the gate only aborts when the new DRAFT banner is present, and the one live instance (buy-side-service-plan) carries no such banner (confirmed by reading both files — they open with `> **What this file is:**`, not `> **⚠ DRAFT — NOT RATIFIED**`). So 0 consumers require modification to keep working.
- `parses`-row cross-check (inventory): `reconcile-reviewer` reads both contract files but is spawned at Step 4, *after* the Step-2 gate — it never receives a DRAFT-banner file, so the subagent input schema is unaffected. No must-change there.
- **Regression hazard the inventory surfaced:** the Step-2 grep runs against files whose live instances already contain a `> **`-bold blockquote (buy-side line 3). If the gate matches loosely rather than on the unique full banner, it false-aborts the one working project (task concerns (a) + (b)). This is why the dimension is Medium, not Low — the fan-out is total and the correctness of every future run hinges on grep specificity. Mitigation paired below.
- One `should-change` for contract consistency: `reconcile-report-template.md` (the doc that already defines what both files must contain) is the natural canonical home for the new banner string, and `graduate-resource.md` line 148's origin note could gain a pointer to the scaffolder — neither blocks function.

### Dimension 4: Reversibility
**Risk:** Low

- The structural change itself is **2 tracked files** — `git revert` of the commit removes the new `reconcile-activate.md` and restores `reconcile.md` Step 2 + prose cleanly. No settings cache, no push, no external write, no log mutation in the change itself.
- Caveat (operational, post-use): once operators *run* `/reconcile-activate`, it writes DRAFT files into up to ~20 project `context/` directories. Those are sibling artifacts a revert of the *command* commit does not remove. Impact is bounded and cleanup is trivial: every draft carries the `NOT RATIFIED` marker, so `grep -rl "NOT RATIFIED" projects/*/context/` enumerates them for deletion, and each is inert (DRAFT-gated — `/reconcile` refuses to judge against it). At land-time (before any run), reversal is fully clean; hence Low with the caveat noted rather than Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **The banner-string contract is the core coupling (task concern (c)).** The scaffolder *writes* `> **⚠ DRAFT — NOT RATIFIED**` and the Step-2 gate *greps* for it; the two must match byte-for-byte, but they live in two separate files and `CHANGE_DESCRIPTION` does not name a single canonical definition site. Grep confirms `NOT RATIFIED` appears in 0 structural files today, so this is a brand-new cross-file contract with no documented home — the High-trigger shape ("an undocumented new contract that callers must honor"). It scores Medium rather than High only because both parties are built in the same change, so drift is a future-maintenance risk, not an at-land one.
- **Encoding hazard:** the banner contains a non-ASCII `⚠`. If the writer emits the emoji but the grep target omits it or normalizes it differently, the gate silently fails-open (an un-ratified rubric passes) or fails-closed (a false abort). The safe design is to key the gate on the plain-ASCII substring `NOT RATIFIED`, never the emoji or a bare `DRAFT`.
- **False-positive coupling to an existing convention:** buy-side's two live files open with `> **What this file is:**` (both line 3). A gate that matches `> **`-anything or bare `DRAFT` would strand the one working project. The contract must be the *unique* banner substring.
- **Convention dependency on session-notes:** the scaffolder derives content from `logs/session-notes.md`'s `**Mandate:**` line, project CLAUDE.md, and `project-brief.md`. These are assumed conventions; a project missing the `**Mandate:**` line or the brief needs graceful degradation to an author-prompt placeholder, or the scaffolder produces a malformed/empty draft.
- Multiple implicit dependencies (exact-string match + encoding + no-false-positive-on-blockquote + session-notes format) concentrated on one new undocumented contract → Medium, and the top concern of this review.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index; canonical full text at `vault/principles/principles.md`).

- **OP-2 (automate execution; gate judgment) — aligned.** The change automates the *mechanical* part (assembling a file skeleton from session-notes/CLAUDE.md/brief) and keeps the *judgment* (ratifying what "good output" means) operator-owned via the DRAFT-gate. Textbook OP-2 fit.
- **OP-5 (advisory ≠ enforcement) / AP-4 (rubber-stamp) — aligned, and protective.** `/reconcile` stays advisory ("It does not rewrite the output," reconcile.md line 7; "diagnostic gate … does not commit," line 91). The DRAFT-gate *adds a guardrail against* rubber-stamping — it blocks an un-ratified auto-draft from ever being used to judge, which is the anti-pattern `CHANGE_DESCRIPTION` explicitly names ("prevents an auto-drafted rubric silently becoming a pass-everything rubber-stamp"). This is the opposite of enforcement creep.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction — generalize only on a second confirmed consumer) — aligned.** The scaffolder is not built for an absent consumer: `graduate-resource.md` line 148 documents that `/reconcile` "was graduated and broadcast to ~20 projects … it shipped present-but-inert in the rest," and `CHANGE_DESCRIPTION` states an SO consult verdicted this BUILD priority-1. One proven consumer (buy-side) plus ~20 documented dormant consumers = a real, present activation gap, not "hooks for later."
- **OP-12 (closure before detection) — aligned.** The DRAFT-gate adds a check, but it ships *with* its closure channel (the abort emits ratification instructions the operator acts on), and it gates an existing capability rather than emitting accumulating findings.
- **DR-1 / DR-3 (placement) — aligned.** A new operator-invoked scaffolder correctly lands as a command in canonical `ai-resources/.claude/commands/` — right tier, right component type.
- **"Operator-authored, not generated" intent + OP-11 (loud revision, never silent drift) — the one tension, and it is handled loudly (task concern (d)).** reconcile.md line 39 currently asserts these are "operator-authored reference docs — /reconcile reads them, it does not generate them," echoed in both live files (mandate-rubric.md line 3, resource-activation-map.md line 3). The scaffolder relaxes the literal "does not generate them." But (a) the underlying guarantee — that `/reconcile` never judges against a machine-invented standard — is *preserved* by the DRAFT-gate, and (b) `CHANGE_DESCRIPTION` explicitly updates lines 9/39 to name the scaffolder, making this a **loud, recorded revision (OP-11-compliant), not silent drift.** This also matches the workspace's Requirements-Doc Default ("Build the empty form; the operator supplies the facts"). Scored Low on this basis. It would become Medium/High only if the prose revision at line 39 were omitted, leaving the "does not generate" claim contradicted silently — so that prose edit is load-bearing for the principle score, not cosmetic.

## Mitigations

- **Dimension 5 + Dimension 3 (banner contract, the top concern):** Define the exact banner string **once** as a named contract in `ai-resources/docs/reconcile-report-template.md` (which already governs what these two files must contain), and have both the scaffolder and the Step-2 gate reference that single definition. Key the Step-2 detection on the **plain-ASCII substring `NOT RATIFIED`** — never the `⚠` emoji and never a bare `DRAFT` — so encoding and blockquote-collision drift cannot fail the gate open or closed.
- **Dimension 3 (no regression on the one live project):** Before landing, dry-run the exact Step-2 grep against both live buy-side files (`context/mandate-rubric.md`, `context/resource-activation-map.md`) and confirm it returns **no match** (they carry `> **What this file is:**`, not the banner). Add this as a one-line assertion / test note in the change so the "buy-side must keep running" guarantee is verified, not assumed.
- **Dimension 5 (input-convention degradation):** Specify in the scaffolder that a missing `logs/session-notes.md` `**Mandate:**` line, CLAUDE.md, or `project-brief.md` degrades to an explicit author-prompt placeholder (never a silent empty or fabricated dimension) — so a sparse project still gets a well-formed, obviously-incomplete DRAFT rather than a malformed one.
- **Dimension 4 (post-use cleanup, optional):** Note in the command doc that generated drafts are enumerable via `grep -rl "NOT RATIFIED"` for clean removal, so a later decision to back the feature out has a one-command cleanup path.

## Recommended redesign

- Not required (verdict is PROCEED-WITH-CAUTION, not RECONSIDER). The design is sound; apply the paired mitigations above before landing.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: reconcile.md (lines 4, 7, 9, 33–39, 91), reconcile-reviewer.md (lines 3, 17, 31), both live buy-side files (line 3 blockquotes), graduate-resource.md line 148, agent-tier-table.md lines 38/88, principles-base.md (OP-2/OP-5/OP-9/OP-11/OP-12/DR-1/DR-3/DR-7/AP-4/AP-7), and grep counts (`reconcile-activate` = 0, `NOT RATIFIED` = 0 in structural files, contract-file instances found only in buy-side-service-plan). No training-data fallback was used; `reconcile-activate.md` was not read (tagged not-yet-present) and its risk was evaluated from described intent, noted where relevant.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Delivered via a continued session-owner agent that already held the full build context._

**(a) Concurs** with PROCEED-WITH-CAUTION and that the three mitigations are the correct closure. The two Medium dimensions are both the banner-string two-end contract (risk-topology.md §5); mitigations 1–2 target hidden-coupling directly, and #3 is the AP-2 / OP-3 fabrication guard.

**(b) Two risks the six-dimension pass under-weighted:**

1. **Ratify-without-reading defeats "operator-authored" (AP-4).** Mitigation #3 stops silent-empty, but not the path where the operator flips/deletes the banner without editing a single dimension — a generated rubric then masquerades as authored. Close it fail-closed: leave each dimension as an author-prompt placeholder that *cannot* pass `/reconcile` until replaced, so ratification requires real edits, not just banner removal. **DISPOSITION: ADOPTED** — the Step-2 gate keys on the `{{AUTHOR:}}` placeholder token (present anywhere → un-ratified), not on banner removal alone.

2. **Hard abort preserves the dormancy it is meant to cure.** Aborting until ratified protects the one live project but keeps `/reconcile` unrunnable behind authoring work for the 20 dormant ones. Alternative: a flagged indicative mode (`UNRATIFIED — indicative only`) that runs and shows value before authoring (OP-12). SO framed this as the operator's design choice. **DISPOSITION: DEFERRED** — shipping hard-abort now (matches the risk-checked design; the scaffolder already cures the blank-page authoring cost that is the true dormancy driver). Indicative-mode logged as a follow-on enhancement that would need its own risk-check (touches reconcile-reviewer + verdict-definitions).
