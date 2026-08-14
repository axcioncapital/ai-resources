---
task: eval-v0-3-restart
turn: codex
---

## Objective and scope
Restart the Work Loop v2 behavioural-eval effort from the clean current `main` baseline and carry it to an honest, repeatable eval capability whose first live act is EV-3/CE-9. The operator has approved this `eval-v0-3` restart; adoption remains a later operator decision based on recorded operating evidence.

This task may use the abandoned `session/2026-08-09-eval` branch and its dirty worktree as read-only evidence, but it must not edit, clean, commit, merge, cherry-pick, or otherwise change that checkout. Excluded from the whole task unless the operator later expands scope: an eval platform, dashboard, database, new scoring system, new durable fixture family, unattended eval execution, Work Loop core/skill/command changes, dispatcher changes, and automatic landing or cleanup of another checkout.

## Lane and unit
Standard. Implementation mode. Unit 7 — narrowly correct the EV-3/CE-9 Run A procedure so its stated capability boundary matches the effective Codex 0.147.0 runtime.

Named reason for the loop: the work must survive several sessions, its abandoned predecessor left substantial uncommitted partial effects in another checkout, and independent assessment is needed before any recovered design or implementation counts as the new baseline.

## Brief
Unit 6 established that the stopped Run A was blind: no connector existed, no external resource or Harbourview content was returned, every filesystem read was denied, and no approval prompt appeared. It also falsified two instrument claims: the generic client-side `list_mcp_*` primitives are not MCP-server access, while `-c 'mcp_servers={}'` failed to remove the copied `config.toml`'s real `node_repl` MCP server. This unit corrects only that mismatch before a genuinely new paired trial; the stopped Run A remains instrument evidence and is not scored retroactively.

### Required outcome

Update only `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md` so that:

1. a fresh Run A control home carries only what Codex actually needs to authenticate and start, and cannot inherit a configured MCP server from the operator's normal `config.toml`;
2. the procedure no longer claims that `-c 'mcp_servers={}'` clears MCP declarations when Codex 0.147.0 demonstrably merged the copied `node_repl` block instead;
3. the after-run confirmation distinguishes inert client-side resource-registry enumeration from an exposed or invoked server-backed `mcp__*` tool, connector/app access, successful external retrieval, or successful out-of-bound file read;
4. a fail-capable check prevents launch when the control home or effective setup can carry a configured MCP server, without requiring the operator to interpret a model prompt or inspect credential contents; and
5. all other accepted trial contracts remain unchanged: the outer filesystem boundary, fresh-home rule, approval policy `never`, apps disabled, exact Run A and Run B inputs, preflight and mutant rule, PASS/PARTIAL/FAIL scoring, nine result items, result destination, and lifecycle boundary.

Choose the smallest safe mechanism supported by local Codex 0.147.0 evidence. Do not prescribe independence between boundaries if the runtime only supports a jointly sufficient boundary; state accurately what each control proves. Do not add a per-trial diagnostic model turn or a new artifact.

### Claims and required evidence

- Verify against the saved Unit 5 transcript `/Users/patrik.lindeberg/ce-9-control-20260814T065609Z/.codex-home/sessions/2026/08/14/rollout-2026-08-14T10-00-48-019fff12-c849-73f3-a963-91261bb0295f.jsonl` that the copied config exposed `mcp__node_repl__js`, while the generic `list_mcp_resources` and `list_mcp_resource_templates` calls returned empty arrays and no connector/app tool existed.
- Establish from local CLI/help/config behaviour, without launching a model, the minimum fresh-home contents and a mechanical way to reject inherited MCP declarations. If startup without copying the normal config cannot be established without a model turn, stop and hand back rather than assume.
- Demonstrate the old procedure's failing case and the corrected procedure's passing case on temporary non-secret fixtures: a control home shaped like the old one must expose or retain an MCP declaration to the mechanical check; the corrected clean shape must pass; adding a synthetic MCP declaration must make it fail. Do not read, print, or copy real credential contents for evidence.
- Re-run only the structural checks needed to show the exact Run A prompt, six-line Run B input with the same three paths, three verdicts, nine result items, preflight/mutant rule, and the outer read-boundary commands remain unchanged.
- Report final changed paths. The allowlist is the run sheet, this state file, and hook-incidental `logs/friction-log.md` only.

### Scope and stop conditions

Do not execute Run A or Run B, launch any model turn, create a result artifact, alter real credentials or configuration, or edit any fixture, scenario, plan, carrier, dispatcher, Work Loop resource, or result schema. Do not broaden the trial or redesign the eval. Stop and hand back if a clean fresh home cannot start without persistent config, if effective MCP absence cannot be checked mechanically without a diagnostic model, or if the correction would depend on the operator judging access availability correctly. Challenge any stale premise rather than preserving a false guarantee.

## Latest result

Inspected (2026-08-14):
- Claim (1) the saved transcript shows the copied config exposed `mcp__node_repl__js` while the generic `list_mcp_*` calls returned empty arrays and no connector/app tool existed: HOLDS — re-read `rollout-2026-08-14T10-00-48-019fff12-...jsonl`; record 26's registry filter returns `exec_command, mcp__node_repl__js, mcp__node_repl__js_add_node_module_dir, mcp__node_repl__js_reset, view_image`, record 39's returns no Drive or Google entry, record 61's returns `[]`, and record 47 returns `{"resources":[]}` / `{"resourceTemplates":[]}`.
- Claim (2) `-c 'mcp_servers={}'` failed to remove the copied `node_repl` block: HOLDS, and is now reproducible without any model turn — see the failing case below.
- Claim (3) a clean fresh home can start without copying the normal `config.toml`, establishable from local CLI behaviour: HOLDS — `codex doctor --json` on a home with no `config.toml` reports `config.load: ok`, `mcp servers: 0`, and fails only on `auth.credentials`, which copying `auth.json` satisfies. No model turn was launched at any point in this unit.
- Claim (4) the run sheet is the only file that needs changing: HOLDS — searched the trials directory; the false flag claim, the no-MCP-call confirmation and the boundary checks all live in `ev-3-ce-9-run-sheet.md`. `ce-9-recovery-scenario.md` states neither.
- Claim (5) the protected contracts exist in the sheet and are still there after the edit: HOLDS — verified after the change, listed under Evidence.
- Not a claim, but recorded: the brief calls the transcript the "Unit 5 transcript". It is Run A's own transcript and was Unit 6's evidence. Same path, nothing load-bearing turns on it.

Result: `ev-3-ce-9-run-sheet.md` is corrected — 136 insertions, 30 deletions, no other file touched. The five required outcomes are met as follows.

1. **The control home no longer carries an MCP declaration.** § 1 now copies `auth.json` only and generates `config.toml` from the two top-level model keys (`awk '/^\[/{exit} /^model[a-z_]* *=/{print}'`), so the operator's declarations never enter the home. The model keys are carried deliberately: Codex starts fine with no `config.toml`, but then reports `model: <default>` while Run B runs `gpt-5.6-sol`, and a pair whose halves ran different models measures the model rather than recovery. Neither key is a credential and `auth.json` is never opened.
2. **The false claim is gone.** § 1's flag table now says `-c 'mcp_servers={}'` closes an override-supplied server "and nothing else", with the mechanical disproof stated inline; the launch paragraph's matching sentence is corrected too. The flag stays on the command line, so § 5's "all three capability flags" clause is untouched.
3. **The after-run confirmation now distinguishes reach from tool names.** A four-row table separates an empty `list_mcp_*` enumeration (not a breach — nothing reached) from a server-backed `mcp__*` tool being available or called, from connector/app access, and from a successful out-of-bound read or off-machine retrieval. The paragraph names the 2026-08-14 stop as what the old wording caused. "Successfully opened" replaces "opened", so a refused read stays what the sheet already calls it: the boundary working.
4. **The launch-blocking check exists and is fail-capable.** New § 3a check 5: `CODEX_HOME=... codex mcp list --json` must print exactly `[]`, carrying its own mutant demonstration in the same style as § 2a. It reads configuration only — no model turn, no credential, no operator judgement about a prompt.
5. **Everything else is unchanged**, verified mechanically after the edit.

Evidence — the failing case first, all four runs made against throwaway homes with no real credentials:

| Home shape | `codex mcp list --json` | `doctor` mcp servers | `doctor` model |
|---|---|---|---|
| old — a copy of the normal `config.toml` | reports `node_repl` | 1 | `gpt-5.6-sol` |
| old **plus `-c 'mcp_servers={}'`** | **still reports `node_repl`** | **1** | — |
| corrected — the two model keys only | `[]`, `exit=0` | 0 | `gpt-5.6-sol` |
| corrected plus a synthetic `[mcp_servers.synthetic_probe]` | reports `synthetic_probe` | 1 | `gpt-5.6-sol` |

Row 2 is the old procedure failing: the flag the sheet relied on demonstrably does not clear a declaration already in the file. Row 3 is the corrected shape passing, with model parity intact. Row 4 is the check refusing a home it must refuse. The operator's real home reports 2 MCP servers, which is what the old copy step was carrying in. Both new commands were then run verbatim as written in the sheet and produced the stated output.

The check cannot pass vacuously: its embedded demonstration prints a `probe` server, so a check 5 that returned `[]` for both would be caught at the trial that ran it, not later.

Regression protection: the sheet's own mutant test is the protection, because the artifact is a procedure a human executes — no automated test can observe an operator following it, and a grep for wording the brief already supplied would pass whatever the sheet said. What *can* fail is the runtime claim underneath, and check 5 re-proves that at every trial.

Structural re-checks after the edit — Run A prompt still the same two lines; Run B input still the same three fixture paths, unchanged in the diff; three verdicts (PASS/PARTIAL/FAIL); nine numbered result items; preflight's five steps, its stop rule and § 2a's mutant rule intact; and `git diff` shows no change to any `sandbox-exec`, `CE9_PROFILE`, `deny file-read`, `allow file-read` or `mdfind` line. Check numbering reads 0–5 against the "Six checks" heading.

One judgement call beyond the five numbered outcomes, flagged rather than assumed: the "What is not a result" section now records the stopped 2026-08-14 Run A as a third non-result that the correction does not revive. `## Latest result` already carried that decision; the sheet is where a future operator would otherwise look and find a usable-looking half-trial.

Two deferrals, recorded and not done:
- **The control home still repopulates itself from the account at launch** (Unit 6 Finding 1 — the plugin catalogue and connector packages arrive within a second of start). Not corrected here: `--disable apps` withholds the connector *tools*, and § 3a already rules that a listed Drive *skill* is not a breach, so nothing in the measurement turns on it. It belongs to whatever decides how much of "fresh" the client is allowed to undo.
- **`model_reasoning_effort` is carried but not checkable.** `codex doctor` reports the model and not the effort, so parity on that key rests on the `awk` copying it rather than on a check. Worth closing only if a later trial shows effort moving the result.

Changed paths: `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md` and this state file. `logs/friction-log.md` is modified by a hook and left unstaged.

## Blocker
None.

## Next action
Codex: assess Unit 7. The frozen questions are whether check 5 is the right place to stop a launch, whether carrying the two model keys is the correct reading of "only what Codex needs" or an over-reach, whether the added "What is not a result" sentence stays, and whether the two deferrals are accepted. If the sheet is accepted, the next unit opens a genuinely new paired trial under it.
