# Risk Check — 2026-07-26

## Change

Stand up a live, credentialed, billed Perplexity API path for executing article two's research (source retrieval). Mechanism: a Perplexity API key stored in the gitignored project .env (PERPLEXITY_API_KEY), read at call time; calls made via curl (Bash) or the existing execution-agent (.claude/agents/execution-agent.md, Read+Bash, designed for exactly this) to https://api.perplexity.ai/chat/completions with the `sonar` model. Each call sends the query text to Perplexity's servers and incurs pay-as-you-go cost. This replaces the previously-recorded operator-in-the-loop handoff mechanism (logs/decisions.md 2026-07-19 S7-3fb explicitly noted "no in-repo API path and no /risk-check" for the prior mechanism, because no credential existed). Scope is bounded to article two's approved research brief (articles/drafts/how-private-capital-firms-screen.research-brief.md — a tracing brief: retrieve/verify named public sources). The Codex/ChatGPT half (source adjudication, Q3/Q4) stays operator-run and is out of scope for this change. Project mandate is research-only for articles one and two (logs/decisions.md 2026-07-26 S5-586). Assess before any billed research run.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/axcion-content-engine/.env — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/axcion-content-engine/.claude/agents/execution-agent.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/axcion-content-engine/articles/drafts/how-private-capital-firms-screen.research-brief.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/projects/axcion-content-engine/logs/decisions.md — exists

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The change is a legitimate, narrowly-scoped capability add (not a defect fix) that mechanically requires no permission-file change, but it activates real billed external egress under a `Bash(*)` / `bypassPermissions` grant that has no technical stop-gate, relies on an undocumented credential-sourcing contract in a canonical, multi-project-shared agent definition, and — verified directly on disk — a sibling project has already built and approved a *different*, incompatible credential convention for the same nominal capability within the last 24 hours.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-content-engine/.claude/agents/execution-agent.md` | imports (symlink → `ai-resources/.claude/agents/execution-agent.md`) | no |
| `projects/axcion-content-engine/.claude/commands/verify-chapter.md:40` | invokes (delegates to execution-agent, but for an unrelated Stage-4/5 chapter-verification call, unexercised per `known-limits.md:109`) | no |
| `projects/axcion-content-engine/articles/drafts/how-private-capital-firms-screen.research-brief.md:143` | documents (asserts, as settled operational fact governing step 5, that "there is **no live API path**") | **yes** — becomes factually stale the moment a credential exists |
| `projects/axcion-content-engine/logs/decisions.md:62` (row 2026-07-19, S7-3fb) | documents (records the "no live API path" finding this change supersedes) | no — historical row is kept; a new row is an addition, not an edit (this project's own established convention, e.g. the S5-8e9 and S6-623 rows) |
| `projects/axcion-content-engine/logs/decisions.md:67` (row 2026-07-25, S1-9b2) | documents (records a related but distinct ruling, for article one, misattributed by CHANGE_DESCRIPTION to the S7-3fb row — see Dimension 7) | no |
| `projects/axcion-content-engine/.gitignore:39,74` | co-edits (comment at line 39 already reserves `execution-agent` as a canonical symlink; line 74 already excludes `.env`) | no — already correctly configured |
| `ai-resources/.claude/agents/execution-agent.md` (canonical, symlink target, byte-identical to the project copy — verified via `diff`) | imports/parses (defines the contract this change relies on) | no *for this change to function*, but see Dimension 5 — the contract is silent on credential sourcing |

**Total: 5 in-scope consumers, 1 must-change.**

**Out-of-inventory but load-bearing finding.** The search also surfaced `~/.config/axcion/perplexity.env` (verified present on disk: `ls -la`, dated 2026-07-25 13:25, mode 600, 73 bytes) and a **forked, non-symlinked** `execution-agent.md` at `projects/axcion-si-worktrees/industrial-software/.claude/agents/execution-agent.md` (byte content identical in substance to the canonical file, silent on credentials the same way). `roadmap/parallelisation-plan-v2.md:72` in that project documents the convention explicitly: Perplexity via `execution-agent`, "sourcing `~/.config/axcion/perplexity.env`." That project is a **different, read-only seam** per this project's own `CLAUDE.md` ("axcion-sector-intelligence... consume, never rebuild, never write into"), so it is not a `must-change` consumer of *this* change — but it is direct, dated, on-disk evidence that a **second, incompatible credential-storage convention for the identical nominal capability already exists and was already built in this workspace within the last 24 hours**, independently of this change. Recorded under Dimension 5, not as a formal inventory row, because it references no file this change touches.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded `CLAUDE.md` edit is part of this change (workspace and project `CLAUDE.md` read in full; nothing in either requires updating for a `.env`-scoped credential).
- No new hook, no new `@import` chain.
- `execution-agent.md` (`ai-resources/.claude/agents/execution-agent.md`, 29 lines) is unmodified by this change and is invoked only on demand, bounded to the approved brief's five named figures — not a frequently-spawned or broadened subagent.
- The real ongoing cost here is monetary (pay-as-you-go Perplexity billing), which this dimension does not measure — it is captured instead under Dimension 2 (Permissions Surface) and Dimension 6 (Principle Alignment, OP-2).

### Dimension 2: Permissions Surface
**Risk:** Medium

- `projects/axcion-content-engine/.claude/settings.json` already grants `"defaultMode": "bypassPermissions"` and `"Bash(*)"` in `allow` — confirmed by direct read. Mechanically, **no settings.json edit is required** for curl-via-Bash to reach `api.perplexity.ai`; the grant already covers it.
- Because of that, this change adds **zero permission-file diff** — narrowly, that is a Low signal.
- But it activates, for the first time in this project, a **new class of consequential action reachable through that pre-existing blanket grant**: billed, third-party network egress that sends query text off-repo and spends real money, with **no technical checkpoint** between "the session decides to call" and "the call executes" (`bypassPermissions` means no prompt, no deny-list catch — `Bash(rm -rf *)`/`Bash(sudo *)` are denied, but no `curl`/network deny rule exists anywhere in the file).
- Net: Medium — the permission surface is not widened by this change, but this change is the first thing in this project to actually **exercise** the broadest, least-gated corner of an already-broad grant for a billed, externally-visible action.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory (Step 1.5): **5 in-scope consumers, 1 must-change** — see table above.
- The one must-change consumer (`how-private-capital-firms-screen.research-brief.md:143`) is not cosmetic: it is the article's own operational governing text for step 5, and it currently states as fact the exact condition ("no live API path... execution is manual today") that this change reverses. Leaving it unedited after landing would leave a live, approved brief actively misinforming the next reader/session about how step 5 actually runs.
- No shared/canonical infrastructure is touched directly (`ai-resources/.claude/agents/execution-agent.md` is read, not edited), so cross-project blast radius from *this specific change* is contained to `axcion-content-engine`. Checked explicitly: `nordic-pe-screening-project` and `axcion-si-worktrees/industrial-software` both reference `execution-agent` (grepped), but only as a generated snapshot doc (`repo-snapshot.md`, documents-only) or their own forked copy (unaffected, since this change touches no shared file).
- Medium rather than Low because of the must-change count against a small but non-trivial total, and because the change's *practical* footprint (a live, billed, external side effect) is larger than its *file-diff* footprint — the two disagree, which is itself worth naming per Dimension 3's guidance to flag unanticipated-consumer gaps.

### Dimension 4: Reversibility
**Risk:** Medium

- The credential/config itself is trivially reversible: `.env` is untracked and gitignored (confirmed: `.gitignore:74`, `git check-ignore -v .env` → matched), so deleting it or rotating the key leaves no git-history trace and no revert step.
- But the **act** this change enables — a billed API call — is not something `git revert` touches at all: money is spent and query text leaves the repo boundary the moment a call executes, and neither can be undone. This matches the Dimension-4 High-heuristic bullet "pushes state beyond the local repo... that cannot be rolled back by git alone," scaled down by two mitigating facts: (a) the brief bounds scope tightly to five named figures plus two adjudication questions, so the maximum accidental spend/exposure per session is small and known in advance; (b) `sonar`-tier Perplexity pricing is pay-as-you-go at low per-call cost, not a large one-shot commitment.
- Net Medium: the underlying mechanism (credential + code path) is cleanly reversible; each individual live call is not, but the blast radius of a single mistaken call is small and bounded by the approved brief.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented credential contract in a shared, canonical resource.** `ai-resources/.claude/agents/execution-agent.md` (verified `diff` byte-identical to the project's symlinked copy) describes its job only as "construct and send the API call" — it names no environment variable, no config path, no tool permission for reading a credential. `grep -niI "env\|credential\|key"` against the file returns **zero hits**. The change's own mechanism ("read at call time" from `.env`) is therefore an *invented* convention layered on top of a contract that says nothing about it — exactly the "undocumented new contract that callers must honor" bullet this dimension flags as High.
- **A second, incompatible convention for the identical capability already exists in the same workspace, built in the last 24 hours.** `~/.config/axcion/perplexity.env` exists on disk (verified: `ls -la`, 2026-07-25 13:25, mode 600) and is the credential source explicitly documented for the `axcion-si-worktrees/industrial-software` project's own (forked, non-symlinked) `execution-agent` usage (`roadmap/parallelisation-plan-v2.md:72`: "sourcing `~/.config/axcion/perplexity.env`"). That project's Perplexity infrastructure was itself gated through `/risk-check` on 2026-07-26 (`logs/decisions.md` Decisions 22–24, 28, in that project). Two sessions, days apart, in the same workspace, independently solved "where does the canonical `execution-agent` get its Perplexity credential" two different ways — a home-directory config vs. a project-local `.env` — with neither referencing the other and the canonical agent definition silent on both. This is precisely the "functional overlap with existing mechanisms... two systems will both try to handle the same concern" failure mode this dimension exists to catch, and it is directly observed, not inferred.
- **The dispatch mechanism itself is left ambiguous.** CHANGE_DESCRIPTION states calls will be made "via curl (Bash) **or** the existing execution-agent" — these are not equivalent paths. `execution-agent.md` carries explicit safety contract clauses ("enforce confidentiality boundaries," "return it verbatim," log call metadata to `execution-log.md`) that a raw `Bash` curl invoked directly by the main session would silently bypass. Leaving this an "or" means the safety properties the agent was designed to provide are optional, not guaranteed, under the change as currently specified.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base not present at the expected path (`projects/strategic-os/ai-strategy/principles-base.md` not checked to exist under this repo layout — `AI_RESOURCES/..` here resolves to the workspace root); graded against the inline checks in `risk-check-reviewer.md` Step 6.5 plus the always-loaded workspace `CLAUDE.md § Design Judgment Principles` (read in full above).

- **System boundary (OP-10) — tension, not a clear violation.** The change deepens Claude Code's direct reach into an external tool (Perplexity) from a manual, operator-mediated hand-off to a live, credentialed, automatic API path. `ai-resources/docs/cross-model-rules.md` frames this territory as one where the operator's explicit choice governs tool assignment, and the CHANGE_DESCRIPTION does name and explicitly propose superseding the specific prior decision (S7-3fb) that established the manual mechanism — which is the "explicit, recorded call" OP-10 asks for, *provided* it is actually recorded as a new `logs/decisions.md` row when landed (not yet present as of this check — see Dimension 3's must-change finding and the mitigations below).
- **Placement / duplicate-mechanism (DR-1/DR-3) — tension.** The Dimension-5 finding above (a sibling project already built and risk-checked a different, home-directory-level credential convention for the same shared canonical agent) means this change is choosing a placement (project-local `.env`) without checking whether a workspace-level convention is already emerging elsewhere. Neither is "wrong" in isolation, but landing this without at least naming the divergence risks the canonical `execution-agent.md` acquiring two silently-incompatible dependents.
- **Automate execution, gate judgment (OP-2) — mild tension.** CHANGE_DESCRIPTION states "Assess before any billed research run" as an intention, but nothing in the design creates a structural stop between "session decides to call" and "call executes and money is spent" (see Dimension 2: `bypassPermissions` + `Bash(*)`, no deny rule). This project's own `logs/decisions.md` records this exact failure class — a stated intention not backed by a mechanism — recurring repeatedly (S6-623: "a plausible recollection of having checked is indistinguishable, from the inside, from having checked," logged after four prior instances). The stated safeguard here is the same species.
- Not High: no dimension here is a *clear, unacknowledged* violation — the CHANGE_DESCRIPTION already names the decision it supersedes and the scope it stays within, which is the loud-acknowledgment path OP-11 asks for; it just isn't yet landed as a recorded decision.

### Dimension 7: Problem Reality
**Risk:** Low

- **Not defect-justified — this is a capability add, not a fix.** CHANGE_DESCRIPTION frames the change as replacing a prior mechanism "because no credential existed," not as fixing something broken. Per the governing rubric, this scores Low with the note below, rather than requiring a traced defect/consequence pair.
- **Defect — observed or inferred?** N/A (not defect-justified) — but the *premise* fact it leans on ("no live API path existed") is independently true: `how-private-capital-firms-screen.research-brief.md:143` and `logs/decisions.md:62` (S7-3fb, 2026-07-19) both state directly, in their own text, that no `PERPLEXITY_API`/`OPENAI_API` credential, MCP server, or environment variable existed at the time. Confirmed by direct read of both files.
- **Consequence — traced or assumed?** N/A (not defect-justified).
- **Re-derivation vs. the change description — one confirmed discrepancy.** CHANGE_DESCRIPTION quotes: *"logs/decisions.md 2026-07-19 S7-3fb explicitly noted 'no in-repo API path and no /risk-check' for the prior mechanism."* Re-reading `logs/decisions.md:62` (the actual S7-3fb row, 2026-07-19) in full: it says no live API path existed and describes the operator-in-the-loop hand-off — it does **not** contain the phrase "no in-repo API path and no /risk-check," and does not mention `/risk-check` at all. That exact phrase is instead found at `logs/decisions.md:67`, a **different row** — 2026-07-25, session S1-9b2, about **article one's** Codex-based (not Perplexity-based) tool assignment: *"Mechanism is operator-run (results pasted/saved back), so no in-repo API path and no /risk-check."* CHANGE_DESCRIPTION has attributed a quote from a different decision, about a different article and a different tool, to S7-3fb. This does not change the change's underlying justification (S7-3fb independently and correctly establishes that no live Perplexity path existed), but it is a citation error the operator should see named rather than silently absorbed.

## Mitigations

- **Dimension 5 (High):** Before the first live call, write an explicit, documented credential-sourcing contract — either add a short paragraph to `execution-agent.md`'s invocation instructions for this call (naming exactly how `PERPLEXITY_API_KEY` reaches the process: main-session `Bash` reads `.env` and passes the resolved value as an explicit API parameter, vs. the subagent being told to read a named path itself) or record it as a one-line addendum in the research brief. Do not leave it as an unstated convention.
- **Dimension 5 (High):** Route the actual calls through `execution-agent` (not raw ad-hoc `Bash` curl in the main session), so its confidentiality-boundary enforcement, verbatim-return rule, and `execution-log.md` metadata logging are actually exercised rather than optional. If raw curl is used for a specific reason, state that reason and confirm the same three guarantees are met another way.
- **Dimension 5 (High):** Record, in `logs/decisions.md`, an explicit acknowledgment of the `~/.config/axcion/perplexity.env` convention already live in the sibling `axcion-sector-intelligence`/`industrial-software` project — either converge on it or state why this project deliberately uses a different, project-local `.env` instead. This closes the "two systems solving the same problem silently" gap rather than leaving it to be discovered later.
- **Dimension 2/6 (Medium):** Since no technical stop-gate exists between decision and spend (`bypassPermissions` + `Bash(*)`, confirmed), treat "assess before any billed research run" as an operator-visible checkpoint the session states out loud immediately before the first `curl`/`execution-agent` dispatch — not as a design property already built in.
- **Dimension 3 (Medium):** Update `how-private-capital-firms-screen.research-brief.md:143`'s "Operational consequence" paragraph once the live path lands, so the brief stops asserting a condition ("no live API path") that is no longer true.
- **Dimension 6 (Medium):** Add a new `logs/decisions.md` row recording this mechanism change as a loud, explicit supersession of the S7-3fb (2026-07-19) ruling — not an edit to that row, consistent with this project's own established pointer-based-supersession convention (e.g., the S5-8e9 rows).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, `diff`/`ls -la` output, or explicit reasoning where a dimension's mechanical trigger was absent but its underlying concern was present). No training-data fallback was used on fetch/read failures. The search instrument was verified via `logs/scripts/search-canary.sh` (sourced from `ai-resources/`) before the consumer-inventory greps; it reported `blind` for dot-rooted scans, so all absence-relevant greps in this report were re-run either against absolute/named-subdirectory paths or with `command grep -r`, per the canary's own remediation instructions.
