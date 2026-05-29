# Pipeline Review — /contract-check — 2026-05-29

## Summary

`/contract-check` is the artifact-content drift complement to `/drift-check` — a fresh-context independent comparison of an in-progress artifact against the frozen contract that started the work. Its design center is QC-independence at the artifact layer: a single Opus subagent receives only the contract text and the artifact text, applies a hard/soft rubric, and returns a 25-line verdict (ALIGNED / MINOR-DRIFT / MAJOR-DRIFT). The pipeline is structurally clean — no agent files to drift against, no working-notes file to brittle on, and the auto-detect cascade (frozen-contracts dir → session-plan → mandate block → project briefs → workflow intake → inbox) is well-ordered. Shape risk today is concentrated in two places: (a) the auto-detect cascade depends on session-notes mandate-block conventions that are operator-discipline rather than schema-enforced, and (b) the command shares conceptual surface with `/drift-check` and the QC → Triage loop without an explicit composition contract. No Brokenness blockers; the currency check against the unified Anthropic skills/commands doc surfaced one Substantive Brokenness item (the `argument-hint` frontmatter field is now canonical and absent here) and one advisory note on the merged skills+commands convention.

## Innovations proposed

- **Add an explicit "deferred" return path when both contract and artifact are unresolvable** — Step 2 item 5g already prints an abort message, but Step 3 item 7 sub-case "Zero candidates" only asks for the path and blocks waiting. The asymmetry means contract-side failures are explanatory while artifact-side failures are interrogative. Aligning both to the explanatory shape (with one concrete suggested `/contract-check {path}` re-invocation) keeps the command's advisory-only posture intact (principles.md § OP-3 — loud failure over silent continuation). Affects: `.claude/commands/contract-check.md` Step 3 item 7. Risk class: minor.

- **Surface the contract+artifact-source pair at verdict time, not just contract** — Step 5 item 10 echoes `Contract: {CONTRACT_SOURCE}` and `Artifact: {ARTIFACT_PATH}`, which is the right shape; consider also echoing the contract-type classification the subagent returned (`hard` / `soft`) on the verdict header line. This makes the verdict self-documenting when pasted into session-notes — the rubric calibration is the first thing the operator wants to re-check when a verdict looks wrong. Affects: Step 5 item 10. Risk class: minor.

- **Pre-emit a one-line `[HEAVY]` notice when the artifact crosses the 800-line truncation threshold** — Step 3 item 8 silently truncates and "notes this in the brief"; making the truncation visible to the operator at verdict-presentation time matches OP-3 (loud over silent) and gives the operator the option to re-invoke against a narrower contract slice rather than relying on a partial subagent read. Affects: Step 3 item 8 + Step 5 item 10. Risk class: minor.

## Leanness fixes

- **Compress Step 2 item 4 "Looks-like-a-path heuristic" enumeration** — the five-item list is over-specified for a fall-back-on-failure path: items 1–3 (absolute, `./`, `/` + extension) cover the deliberate cases, and item 4 (single token under 200 chars) plus item 5 (existence test) duplicate each other and the deliberate-cases fall-through. Three items would do — absolute/relative explicit prefix, then "contains a path separator AND ends with a known extension," then existence test as the final tiebreaker. Estimated token reduction: small (~80 tokens). Risk class: minor.

- **Tighten the Step 2 item 5 cascade prose** — items 5a–5g each carry a short prose lead-in that repeats the "If X exists AND was modified Y, set CONTRACT_SOURCE = Z" pattern. A six-row table with columns `Source` / `Existence test` / `Recency test` / `CONTRACT_SOURCE form` would compress the cascade by ~40% and make the priority order legible at a glance. Estimated token reduction: small to moderate (~250 tokens). Risk class: minor.

- **Move the Step 4 verbatim subagent brief to a single-source-of-truth fragment** — the brief is 60 lines of prompt scaffolding that would benefit from sitting in `ai-resources/docs/contract-check-subagent-brief.md` (or the equivalent), with the command body delegating to it via path reference. This matches the pattern principles.md § DR-5 endorses (CLAUDE.md holds cross-session rules; methodology lives elsewhere) — the subagent prompt is methodology. Estimated token reduction: command body shrinks by ~600 tokens; aggregate stays the same but the command becomes scannable. Risk class: structural (`/risk-check` plan-time required per DR-8 — new doc file + revised command body).

## Brokenness / drift noted

- **`argument-hint` frontmatter field is missing** — currency-check Substantive. Per the pinned doc (`https://code.claude.com/docs/en/skills`, frontmatter reference table), `argument-hint` is a recognized optional field that "is shown during autocomplete to indicate expected arguments." `/contract-check` accepts `$ARGUMENTS` (contract path or pasted text) — a hint like `[contract-path-or-inline-text]` would make the autocomplete surface match the command's actual contract. Evidence: `contract-check.md:1–4` (frontmatter has `description` + `model` only). Severity: Substantive (degrades discoverability of a documented field).

- **No declared `allowed-tools`** — currency-check Minor. Per the pinned doc, `allowed-tools` is the standard mechanism for granting Bash / Read / Task without per-use approval. `/contract-check` invokes `git rev-parse`, `git status --short`, `git log --since`, and spawns a `Task` subagent — under workspace bypassPermissions these proceed without prompt, but the field's absence diverges from the documented convention. Evidence: `contract-check.md:1–4`. Severity: Minor (cosmetic under current permission posture).

- **Pinned-doc note: slash-commands and skills are now unified, and the auditor's currency-check URL is correct** — the doc explicitly states "Custom commands have been merged into skills. A file at `.claude/commands/deploy.md` and a skill at `.claude/skills/deploy/SKILL.md` both create `/deploy` and work the same way. Your existing `.claude/commands/` files keep working." No brokenness here; recording for completeness so the next reviewer doesn't re-flag the `.claude/commands/` layout as drift.

- **`logs/contracts/` directory referenced in Step 2 item 5a but absent in this repo** — the "Notes for future extension" section already names this as deferred ("Freeze-baseline at /scope time (deferred)"), so this is documented debt, not silent drift. Evidence: `contract-check.md:48` (Step 2 item 5a) + `contract-check.md:192` (Notes). Severity: clean (already declared).

## Cross-resource interactions

- **`/drift-check` — composition gap** — `/contract-check` is positioned as "the artifact-content drift complement to `/drift-check`" (line 8) and `/drift-check` recommends `/contract-check` indirectly (the workspace `CLAUDE.md` § Contract-Conformance Check names the "Session feels off — `/drift-check` returns ALIGNED" trigger). Neither command hands the other a structured handoff; the operator is expected to invoke both manually based on a verbal heuristic. The two commands share a near-identical Step 4 subagent-brief shape, return verdict, and presentation pattern — but their implementations are independent text. This is the right scope for v1; flag for an eventual consolidation review (shared rubric fragment, shared verdict-presentation block). Risk: advisory.

- **QC → Triage Auto-Loop (`qc-independence.md` § QC → Triage Auto-Loop) — trigger composition** — the workspace `CLAUDE.md` Contract-Conformance Check section names "Two or more rounds of `/qc-pass` → `/resolve` → re-QC have completed on the same artifact" as a `/contract-check` trigger, and `contract-check.md:193` ("Notes for future extension — Two-pass cap interaction") declares the same intent: "Future work may auto-invoke this command at the cap; today it is operator-triggered." The composition is correctly named and correctly deferred. Risk: none today; revisit when the auto-invocation lands.

- **`/scope` / `/session-start` / `/create-skill` Step 4 — upstream write contract** — Step 2 item 5a depends on `logs/contracts/{YYYY-MM-DD}-{slug}.md` files that no upstream command currently writes. The "Freeze-baseline at /scope time" note (line 192) acknowledges this; until that upstream write lands, item 5a is a dormant cascade entry. No drift today, but the gap should be tracked as a known incomplete contract (principle DR-8 two-end-contract risk per `risk-topology.md § 1` — once `/scope` starts writing, both ends must move together). Risk: advisory.

- **`/pipeline-review` registry — friction-flag state** — `/contract-check` sits in the weekly tier with `Friction flag: N` and `Last reviewed: never`. The friction-log grep returned one prose mention (line 208, naming a prior "contract-check deferral" item that was resolved). No friction-driven promotion needed this cycle. Risk: none.

## Recommended next session

- **For this command-shaped pipeline:** open a fresh session, edit `.claude/commands/contract-check.md` to (i) add `argument-hint: "[contract-path-or-inline-text]"` and `allowed-tools: Bash(git *) Read Task` to frontmatter, (ii) add the contract-type echo on the verdict header line per Innovations bullet 2, (iii) surface the 800-line truncation when it fires per Innovations bullet 3, then `/qc-pass` to validate before commit. Leanness bullet 3 (subagent-brief externalization) is a structural change — defer to a separate session with plan-time `/risk-check` per DR-8.

## Applied / Deferred — 2026-05-29 session

**Applied this session (commits `51b69dc` Wave 1 + `7ec05e6` Wave 2):**
- CC-1: frontmatter `argument-hint: "[contract-path-or-inline-text]"`
- CC-2: frontmatter `allowed-tools: Bash(git *), Read, Task`
- CC-3: contract-type echo on Step 5 verdict header (parsed from subagent line 2)
- CC-4: `[HEAVY]` truncation notice when artifact exceeds 800-line read window
- CC-5: aligned Step 3 item 7 "Zero candidates" abort to explanatory shape (revised post-QC to drop an impossible re-invocation suggestion — `$ARGUMENTS` reserved for the contract; the kept "commit/modify and re-invoke" line is the actual recoverable path)

**Deferred to dedicated session:**
- **CC-6** (Leanness Minor — compress Step 2 item 4 path heuristic enumeration to 3 items): not named in the memo's Recommended-next-session line. Defer to a follow-up leanness pass.
- **CC-7** (Leanness Minor-Moderate — tighten Step 2 item 5 cascade prose into 6-row table): not named in the memo's Recommended-next-session line. Defer; couples conceptually with CC-6.
- **CC-8** (Leanness structural — subagent-brief externalization to `docs/contract-check-subagent-brief.md`): structural change class per `/risk-check` DR-8 (new doc file + revised command body). Defer per memo's own Recommended-next-session framing.
