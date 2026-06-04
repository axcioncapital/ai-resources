# Pipeline Review — systems-review — 2026-06-04

## Summary

`/systems-review` is a thin orchestrator command: it gates on scope, verifies one reference file exists, then delegates the entire analytical load to the `system-owner` agent under Function E (systems-dynamics diagnosis via the Meadows lens). Its design center is correct — the command carries no judgment, the agent carries all of it, and the grounding contract lives in `references/grounding.md` § 2 Function E. The command is currently sound in shape and lean in body; its risk is almost entirely contract risk against three external files (the systems-thinking reference path, the grounding read-map function letter, and the agent's Function E output shape), not internal logic. It sits in the quarterly tier per the registry, which is the right cadence: single-delegation utility, slow-changing, low per-cycle yield on innovation. The one genuine drift is a currency gap against the now-unified Anthropic skills/commands convention (Minor). No Blocking issues.

## Innovations proposed

- **Pass the Function-E read-map letter explicitly in the brief** — the command brief says "Follow the Function E read map" in prose, but `grounding.md § 2` warns the function→command binding (E = `/systems-review`) is the exact defect class behind the W21 function-letter collision (Decision D-5/D-6). The brief should state `function: systems-review` as a structured key the way Functions F/G do (`function: friday-advisory`, `function: monthly-review`), so the agent's Phase 2 detection does not rely on prose parsing. Affects: `ai-resources/.claude/commands/systems-review.md` (Step 3 brief). Risk class: minor (command-body edit, `/risk-check` gated per risk-topology.md § 3 "Canonical command/agent edit").
- **Echo SCOPE back in the scope-gate confirmation** — Step 1 sets `SCOPE = $ARGUMENTS` silently. Given the read-scope-floor friction incident attached to this very command (see Brokenness), a one-line "Analysing scope: {SCOPE}" echo before delegation closes a known loud-over-silent gap (`principles.md § OP-3`). Affects: same file, Step 3. Risk class: minor.

## Leanness fixes

- **Collapse the two "When to use" comparison blocks** — the command body carries two prose blocks (vs. `/architecture-review`, vs. `/consult`) totalling ~12 lines. This is disambiguation prose that belongs once, in a routing doc, not duplicated at the head of each sibling command (the same comparison is the inverse of what `/consult` and `/architecture-review` must carry). Estimated token reduction: small (~150–200 tokens per command, multiplied across the three siblings if centralised). Risk class: minor. Note this is a cross-command consolidation, not a `/systems-review`-only trim — flag it, do not apply unilaterally.

## Brokenness / drift noted

- **`disable-model-invocation` not declared — currency gap.** Evidence: `systems-review.md` frontmatter (lines 1–4) declares only `description` and `model: opus`. Per current Anthropic docs (`https://code.claude.com/docs/en/skills`, "Control who invokes a skill"), commands with side effects that the operator wants to control timing on — this command writes a report to disk and spawns a heavy Opus subagent — are the documented case for `disable-model-invocation: true`. Files in `.claude/commands/` keep working without it, so this is cosmetic-to-functional but non-breaking. Severity: Minor. (Note: this is a convention-divergence flag only; whether to adopt the unified `.claude/skills/` structure is an operator/architecture decision outside this memo's scope.)
- **`$ARGUMENTS` usage is current — no drift.** Evidence: Step 1 reads `$ARGUMENTS`; the unified docs confirm `$ARGUMENTS` is the current full-argument placeholder (fetched docs, arguments table). No action.
- **Systems-thinking reference path resolves and is canonical.** Evidence: `projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md` exists (36KB, `status: canonical`, last_updated 2026-05-05) and matches the path in both the command Step 2 and `grounding.md § 1` supplemental table. The two-end path contract is intact. Severity: clean.
- **Agent Function-E output contract matches the command brief.** Evidence: `system-owner.md` Phase 5 Function E (lines 109–119) defines the exact sections and the "echo Binding Constraint + Leverage Point Assessment to chat" instruction the command Step 3 brief asks for. Contract intact. Severity: clean.

**Currency check** (subsumed from deprecated `/audit-critical-resources`, 2026-05-29): WebFetch of `https://code.claude.com/docs/en/skills` succeeded. Pipeline frontmatter (`description`, `model`) and `$ARGUMENTS` usage are current. One divergence flagged above (`disable-model-invocation`, Minor). Currency status: verified.

## Cross-resource interactions

- **`/consult` and `/architecture-review` — trigger overlap** — all three are System Owner agent fronts (Functions A/B, C, E respectively). The command body already disambiguates them in prose, so the overlap is documented, not silent. Risk: advisory. The Leanness fix above proposes centralising that disambiguation rather than carrying it three times.
- **`system-owner` agent — composition gap (none detected)** — the command hands off to the agent and the agent's Function E shape, write-scope (`output/systems-reviews/`), and echo contract all match the brief. The OUTPUT_PATH the command builds (`projects/axcion-ai-system-owner/output/systems-reviews/...`) lands inside the agent's permitted write scope (`system-owner.md` line 21). Contracts match. Risk: none.
- **`grounding.md § 2` function-letter binding — contract drift (latent)** — the command relies on the agent resolving "Function E" correctly from prose. `grounding.md § 2` explicitly names this as the W21 collision defect class. Not currently broken (the letter is right), but structurally fragile. Risk: advisory — addressed by the first Innovation.

## Recommended next session

- **For command-shaped pipelines:** open a fresh session, edit `systems-review.md` inline — add `function: systems-review` as a structured key in the Step 3 brief (top pick), add a one-line SCOPE echo in Step 1, and decide whether to adopt `disable-model-invocation: true` — then `/qc-pass` to validate before commit. The cross-command "When to use" consolidation is a separate, larger decision; do not bundle it into this edit.
