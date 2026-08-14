---
task: eval-v0-3-restart
turn: codex
---

## Objective and scope
Restart the Work Loop v2 behavioural-eval effort from the clean current `main` baseline and carry it to an honest, repeatable eval capability whose first live act is EV-3/CE-9. The operator has approved this `eval-v0-3` restart; adoption remains a later operator decision based on recorded operating evidence.

This task may use the abandoned `session/2026-08-09-eval` branch and its dirty worktree as read-only evidence, but it must not edit, clean, commit, merge, cherry-pick, or otherwise change that checkout. Excluded from the whole task unless the operator later expands scope: an eval platform, dashboard, database, new scoring system, new durable fixture family, unattended eval execution, Work Loop core/skill/command changes, dispatcher changes, and automatic landing or cleanup of another checkout.

## Lane and unit
Standard. Implementation mode. Unit 4 — update the EV-3/CE-9 run sheet with the now-observed connector and permission boundary, plus a fresh control home for every Run A.

Named reason for the loop: the work must survive several sessions, its abandoned predecessor left substantial uncommitted partial effects in another checkout, and independent assessment is needed before any recovered design or implementation counts as the new baseline.

## Brief
Unit 3 and the operator-approved diagnostic established that the installed Codex runtime can launch under the existing filesystem boundary with account-side apps disabled, local MCP declarations cleared, and approvals refused. This unit incorporates that observed minimum into the one run sheet so the next EV-3 attempt is genuinely memory-only and does not rely on the operator evaluating prompts correctly. It changes the measurement procedure only; the next live trial remains a later operator action.

### Required outcome

Update only `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md` so Run A:

1. launches under the existing outer filesystem boundary with account-side apps disabled, local MCP declarations cleared, and approval policy fixed to `never`;
2. uses a genuinely fresh isolated `CODEX_HOME` for each trial, containing no previous Run A transcript, session history, or account-synced connector cache;
3. tells the operator never to approve or supply follow-up context, and treats any permission prompt or connector/external-retrieval availability as a blindness breach rather than an invitation to continue;
4. retains the existing exact two-line Run A prompt, exact six-line Run B input, PASS/PARTIAL/FAIL contract, result destination, filesystem checks, and lifecycle boundary; and
5. makes clear that the prior failed Run A and the diagnostic turn are evidence about the instrument and cannot count as EV-3 results.

Choose the smallest safe procedure for creating the fresh control home and carrying only the authentication/configuration needed to start Codex. Do not expose credential contents in evidence. Do not weaken the outer read boundary to accommodate Codex's non-nestable inner seatbelt; Run A needs no repository or shell access.

### Claims and required evidence

- Verify the current run sheet's launch command lacks `--disable apps`, `mcp_servers={}`, and `--ask-for-approval never`, and that its fixed `.codex-home` can retain the failed Run A transcript and connector cache. Name the exact searched surface and matches.
- Use the existing transcripts as the failing and passing cases; do not launch another model. Failing case: `~/ce-9-control/.codex-home/sessions/2026/08/13/rollout-2026-08-13T20-04-13-019ffc14-dbb8-7dc1-87fc-baa6d8251463.jsonl` contains direct Google Drive connector calls. Passing diagnostic: `~/ce-9-control/.codex-home/sessions/2026/08/14/rollout-2026-08-14T09-26-46-019ffef3-9d36-7611-992d-44ad881b5308.jsonl` records approval policy `never`; its one orchestration call searched `ALL_TOOLS` for Drive/Google and returned `[]`; it contains no Google Drive/`codex_apps` tool call and the assistant returned `UNAVAILABLE`.
- Prove the completed run sheet's Run A launch carries all three controls and its setup cannot reuse either transcript above. Demonstrate fail-capability with a temporary copy or mechanical comparison that fails when one control is removed or when a stale control home is substituted; do not alter real credentials or configuration.
- Re-run the existing prompt-fidelity and structural checks from Unit 2 only where needed to show this edit did not break them: Run A byte-identical, Run B six lines with the same three paths, three verdicts, nine result items, and the existing preflight/mutant rule unchanged.
- Report final changed paths. The allowlist is the run sheet, this state file, and hook-incidental `logs/friction-log.md` only.

### Scope and stop conditions

Do not execute Run A or Run B, launch another model turn, create a result artifact, change Codex/OpenAI configuration or credentials, or edit any fixture, scenario, plan, carrier, dispatcher, Work Loop file, or result schema. Stop and hand back if a fresh control home cannot start Codex without persistent history, if the three capability controls cannot coexist with the outer boundary, or if the sheet would require the operator to judge an access-expansion prompt correctly.

## Latest result
Inspected (2026-08-14):
- Claim (1a): HOLDS — searched `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md` for `--disable`, `mcp_servers` and `--ask-for-approval`; each grep exited `1`, no match. The only launch line was `CODEX_HOME=~/ce-9-control/.codex-home sandbox-exec -p "$CE9_PROFILE" codex`, carrying none of the three controls.
- Claim (1b): HOLDS — the sheet's setup was `mkdir -p ~/ce-9-control/.codex-home` at a fixed path, and its only emptiness check listed `~/ce-9-control` (one level up), never inside `.codex-home`. Listing the live `~/ce-9-control/.codex-home` returned 29 entries, 27 of them beyond `auth.json`/`config.toml` — including `sessions/` with both 2026-08-13 and 2026-08-14 rollouts, `history.jsonl`, `thread_history_1.sqlite`, and `cache/codex_apps_tools` plus `cache/codex_app_directory`, the account-synced connector record.
- Claim (2): HOLDS — parsed `~/ce-9-control/.codex-home/sessions/2026/08/13/rollout-2026-08-13T20-04-13-019ffc14-dbb8-7dc1-87fc-baa6d8251463.jsonl`; five completed `exec` calls invoke `tools.mcp__codex_apps__google_drive_search` and `tools.mcp__codex_apps__google_drive_fetch` directly (lines 83, 89, 102, 116, 121), and `approval_policy` is `on-request` in all three occurrences.
- Claim (3): HOLDS — parsed `~/ce-9-control/.codex-home/sessions/2026/08/14/rollout-2026-08-14T09-26-46-019ffef3-9d36-7611-992d-44ad881b5308.jsonl`; `approval_policy` is `never` (one occurrence, no other value); exactly one tool call exists, an `exec` filtering `ALL_TOOLS` on `/drive|google/i`, whose output is `[]`; no `codex_apps` or `google_drive` tool call appears anywhere; the assistant's final message is `UNAVAILABLE`. The 28 `google-drive` strings in that transcript are all plugin **skill** catalogue paths, not tool calls.
- Claim (4, checked because the edit depends on it): HOLDS — `codex --version` is `codex-cli 0.147.0`, and `codex --help` lists `--disable <FEATURE>`, `-c, --config <key=value>` and `-a, --ask-for-approval <APPROVAL_POLICY>`.

Result: `ev-3-ce-9-run-sheet.md` now specifies a Run A that is closed on both routes. § 1 adds a per-trial `CE9_CONTROL="$HOME/ce-9-control-$(date -u +%Y%m%dT%H%M%SZ)"` carrying only `auth.json` and `config.toml`, a freshness check (`ls -A "$CE9_CONTROL/.codex-home" | grep -vxE 'auth\.json|config\.toml'`, expect no output), an explicit rule never to delete an earlier control home, and a capability-boundary bullet with the three flags and what each closes. `CE9_PROFILE` now allows `$CE9_CONTROL` instead of the fixed `$HOME/ce-9-control`, so every earlier home falls under the `$HOME` denial. § 3 gains rule 6 (capability boundary and fresh home). § 3a's launch is `CODEX_HOME="$CE9_CONTROL/.codex-home" sandbox-exec -p "$CE9_PROFILE" codex --disable apps -c 'mcp_servers={}' --ask-for-approval never`, preceded by a new check 4 (freshness at launch time; earlier homes denied) and followed by an approve-nothing rule stating that any permission prompt, access-expansion request or available connector is a blindness breach — plus the observed carve-out that a Drive *skill* in the catalogue is not, because the flags remove the tools underneath it. § 4, § 5's FAIL row, § 6 item 3 and § 7 carry the same conditions; a new note under the answer-key warning records that the failed Run A and the diagnostic turn are instrument evidence and can never be counted as EV-3 results.

Evidence, all fail-capable:
- Controls present: a mechanical check of the sheet's launch block reports `controls_exit=0` on the real file. Three mutants made from temporary copies outside the repository — one flag stripped in each — report `controls_exit=1` and name the missing flag. Before this unit the same check would have reported all three missing.
- Stale home refused: the sheet's own freshness command run against the real stale `~/ce-9-control/.codex-home` prints 27 unexpected entries; run against a home built by the sheet's recipe it prints nothing; dropping a single `sessions/` directory into that fresh home makes it print `sessions` again.
- Earlier homes outside the boundary: with `CE9_PROFILE` allowing only a probe `$CE9_CONTROL`, reading `~/ce-9-control/.codex-home/config.toml` and the 2026-08-13 Run A transcript both exit `1`, the probe directory's own file exits `0`, and both denied reads exit `0` with the boundary removed.
- Unit 2's checks unchanged: Run A prompt sha256 `d7aa25ea…f86f5` (unchanged), Run B input sha256 `c6ba9780…f5a1` over 6 lines with the same three fixture paths (unchanged), 3 verdict rows, 9 result items, and §§ 2 + 2a sha256 `0886dbcd…cbd279` (unchanged).
- No credential contents were read, copied, printed or committed. Changed paths: the run sheet, this state file, and hook-incidental `logs/friction-log.md` — nothing else.

No trial was run, no model turn was launched, and no result artifact was created.

Deferrals, recorded and not done:
- § 3a check 1 relies on `mdfind`, which returns nothing when Spotlight indexing is off for a volume, and nothing in the sheet detects that. The check would then report a clean `denied=checked` for the wrong reason. Out of this unit's required outcome; it is a weakness in an existing check, not in the connector boundary this unit closed.
- `~/ce-9-control/.codex-home` still holds a copy of the operator's Codex credentials alongside the two transcripts. This unit was told not to alter real credentials or configuration, and the boundary now denies that directory, so it was left as it is. It is the operator's call whether that copy should stay on disk.

## Blocker
None.

## Next action
Codex: assess Unit 4. The changed procedure is in `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md`; the evidence and the two deferrals are above. Nothing was executed.
