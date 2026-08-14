---
task: eval-v0-3-restart
turn: codex
---

## Objective and scope
Restart the Work Loop v2 behavioural-eval effort from the clean current `main` baseline and carry it to an honest, repeatable eval capability whose first live act is EV-3/CE-9. The operator has approved this `eval-v0-3` restart; adoption remains a later operator decision based on recorded operating evidence.

This task may use the abandoned `session/2026-08-09-eval` branch and its dirty worktree as read-only evidence, but it must not edit, clean, commit, merge, cherry-pick, or otherwise change that checkout. Excluded from the whole task unless the operator later expands scope: an eval platform, dashboard, database, new scoring system, new durable fixture family, unattended eval execution, Work Loop core/skill/command changes, dispatcher changes, and automatic landing or cleanup of another checkout.

## Lane and unit
Standard. Discovery mode. Unit 6 — classify the generic resource-listing calls observed in Run A and determine whether the control boundary failed or the run sheet's no-MCP-call rule is overbroad.

Named reason for the loop: the work must survive several sessions, its abandoned predecessor left substantial uncommitted partial effects in another checkout, and independent assessment is needed before any recovered design or implementation counts as the new baseline.

## Brief
The first Run A under the accepted Unit 4 procedure reached no Harbourview source and received empty MCP resource lists, but it invoked `codex.list_mcp_resources` and `codex.list_mcp_resource_templates`. The run sheet requires an after-run confirmation that no MCP call occurred, so Run B was correctly withheld. Before calling this a blindness breach or changing the instrument, establish what those generic calls actually did and whether they represented any external retrieval capability.

### Required outcome

Inspect the saved Run A transcript and the installed runtime evidence needed to answer these questions:

1. What exact tools were exposed and invoked, including the failed `node_repl` attempt and both `codex.list_mcp_*` calls?
2. Did either resource-listing call contact an MCP server, connector, network service, or other external source, or did it only enumerate an empty local registry after `mcp_servers={}`?
3. Did any call successfully read a file outside the fresh control directory or retrieve any Harbourview information?
4. Against the run sheet's exact wording, is this Run A a blindness breach, an instrument stop caused by an overbroad no-MCP-call assertion, or a clean control whose inert registry enumeration should not count as access? State the classification and the evidence that makes alternatives false.
5. What is the smallest justified next move: preserve the sheet unchanged, narrowly correct its boundary wording/check, or establish a missing runtime control? Return the recommendation only; do not implement it in this discovery unit.

### Claims and required evidence

- Primary evidence: `/Users/patrik.lindeberg/ce-9-control-20260814T065609Z/.codex-home/sessions/2026/08/14/rollout-2026-08-14T10-00-48-019fff12-c849-73f3-a963-91261bb0295f.jsonl`.
- Compare the transcript's resolved tool roster, tool-call arguments and tool outputs with the launch command recorded by the operator: `CODEX_HOME="$CE9_CONTROL/.codex-home" sandbox-exec -p "$CE9_PROFILE" codex --disable apps -c 'mcp_servers={}' --ask-for-approval never`.
- Quote the exact run-sheet clauses that control classification, including the after-run isolation confirmation and § 7 stop conditions. Distinguish an available orchestration primitive from a configured server or successful external retrieval if the runtime evidence supports that distinction.
- Confirm from the transcript whether any permission prompt appeared, whether any connector/app tool was called, whether any resource was returned, and whether the assistant recovered the corrective Harbourview unit.
- Report the transcript thread id and the final changed paths. The allowlist is this state file and hook-incidental `logs/friction-log.md` only.

### Scope and stop conditions

Discovery only. Do not execute Run A or Run B, launch another model turn, edit the run sheet, create a result artifact, or change any Codex/OpenAI configuration, credentials, fixture, scenario, plan, carrier, dispatcher, Work Loop resource, or result schema. Do not read or print credential contents. Stop and hand back if the saved transcript cannot establish what the calls reached or if classification depends on an operator-owned risk decision rather than technical evidence. Challenge the premise explicitly if `codex.list_mcp_resources` is not an MCP-server call despite its name.

## Latest result

Inspected (2026-08-14):
- Claim (1) the saved Run A transcript is at the named path: HOLDS — the file exists, 70 JSONL records, 120,240 bytes; session/thread id `019fff12-c849-73f3-a963-91261bb0295f`; it is the only session in that control home.
- Claim (2) Run A invoked `codex.list_mcp_resources` and `codex.list_mcp_resource_templates`: FALSE as named, true in substance — searched every `custom_tool_call` in the transcript; the tools are `list_mcp_resources` and `list_mcp_resource_templates`, with no `codex.` prefix, and they were called once, together, inside a single `exec` script (record 44).
- Claim (3) those calls returned empty lists: HOLDS — record 47 returns `{"resources":"{\"resources\":[]}","templates":"{\"resourceTemplates\":[]}"}`, wall time 0.0 s.
- Claim (4) a `node_repl` attempt occurred and failed: HOLDS, and it is materially different from what the brief assumed — record 31 calls `tools.mcp__node_repl__js`, which is an **MCP-server tool**, not a generic primitive. Record 33 returns `node_repl kernel exited unexpectedly`, `kernel_pid 43445`, `kernel_status exited(code=1)`, stderr `Failed to read config file /Users/patrik.lindeberg/.codex/config.toml: Operation not permitted (os error 1)`.
- Claim (5) the run sheet requires an after-run confirmation that no MCP call occurred: HOLDS — `ev-3-ce-9-run-sheet.md` § 3a ("it made no connector, app or MCP call") and § 4 (same words) both require it.
- Claim (6) Run A ran under the recorded launch command with all three capability flags: HOLDS on the command line, FAILS in effect for one flag — see Finding 2 below.
- Claim (7) Run A reached no Harbourview source: HOLDS — searched all nine tool calls and their outputs; every `exec_command` returned `sandbox-exec: sandbox_apply: Operation not permitted`, the node_repl kernel died at startup, and no output in the transcript contains Harbourview content.

**Classification: instrument stop caused by an overbroad no-MCP-call assertion. Not a blindness breach.**

Answers to the unit's five questions:

1. **Tools exposed and invoked.** The model's registry (`ALL_TOOLS`, queried by the run itself at records 26, 39, 61) held `exec_command`, `view_image`, `list_mcp_resources`, `list_mcp_resource_templates`, `mcp__node_repl__js`, `mcp__node_repl__js_add_node_module_dir`, `mcp__node_repl__js_reset`, and `get_goal`. A filter for `github|repository|pull request|commit` returned `[]`; a filter for `google|drive|docs|file search` returned only the two `list_mcp_*` primitives and `mcp__node_repl__js`. **No connector or app tool was present.** Nine tool calls were made: four `exec_command` shell attempts (all refused by the sandbox), three in-process registry filters, one `mcp__node_repl__js` (failed), one paired `list_mcp_*` call, and one `get_goal` (returned nulls).
2. **What the resource-listing calls reached: nothing external.** They are built-in client-side primitives in the `exec` `tools.*` namespace, not tools served by an MCP server. They enumerate whatever MCP servers the client has configured and returned two empty arrays in 0.0 s — no network round-trip, no connector, no external source. **The brief's premise is challenged and confirmed challenged:** the calls whose names look like MCP access are the inert ones, while the call the brief treated as an ordinary failed attempt — `mcp__node_repl__js` — is the one genuine MCP-server invocation in the run.
3. **No file read succeeded anywhere, inside or outside the control directory.** All four shell attempts failed before executing, because the nested `sandbox-exec` could not apply a second profile. No Harbourview information was retrieved by any route.
4. **Against the sheet's exact wording.** The verdict-bearing clauses (§ 5 FAIL row, § 7 stop conditions) make a breach out of six things only: the thread was not fresh; it received more than § 3 allows; Run A reached this checkout; Run A reached a Harbourview source; Run A reached a connector; a permission or access-expansion prompt appeared; or a flag or fresh home was missing. **None of the six holds.** Freshness: `history.jsonl` holds this session's sanctioned prompt and nothing else. Approvals: `approved_command_prefixes` is empty, `approval_policy` is `never`, and no approval or permission event appears in the transcript. Reach: every read was denied. Connectors: none in the registry, none called. "Made no MCP call" appears **only** in § 3a's and § 4's after-run confirmation, never in a verdict clause — so the confirmation asserts strictly more than the rules it is meant to confirm, and that surplus is what stopped Run B. Run A's own output escalated for context, which § 5 Layer A names a legitimate control outcome.
5. **Recommended smallest next move (recommendation only — not implemented).** Narrowly correct the sheet's boundary wording *and* add one pre-launch registry assertion. Preserving it unchanged is not available: the confirmation clause stops a control that was in fact blind, and § 1's flag table now states something false. Wording alone is also not enough, because Finding 2 shows a required flag is not self-enforcing, so the boundary would rest on an unverified claim.

Two findings the unit produced that the brief did not anticipate:

- **Finding 1 — the "fresh" control home does not stay fresh.** The client repopulated it from the account during the run: the Google Drive plugin package was installed at 10:00:49, the developer message listing five `google-drive` and four `github` skills was composed at 10:00:51 from that freshly-installed cache, and an 11.5 MB remote plugin catalogue was cached at 10:01:01. `--disable apps` withheld the connector *tools*, and § 3a already rules that a listed Drive *skill* is not a breach — so this is not a breach, but "fresh at launch" cannot be a claim about the run.
- **Finding 2 — `-c 'mcp_servers={}'` did not take effect (codex-cli 0.147.0).** The copied `config.toml` declares an MCP server named `node_repl`; its tools were present in the registry, and the kernel that started was the binary that block names, with the environment that block sets — its `CODEX_HOME` pointed at the operator's real Codex home. No installed plugin declares `node_repl`, so the config block is the only source. That home holds 126 files mentioning Harbourview. The route was closed by the **read boundary**, not by the flag: the kernel died reading a denied path. The two boundaries are therefore not independent, and § 1's claim that this flag "clears every MCP server declared in the copied `config.toml`" is false as written.

Result: Unit 6 is complete as a discovery unit. Run A is classified as a clean control stopped by an overbroad confirmation clause, not as a blindness breach; the withheld Run B remains withheld pending Codex's decision on the sheet.
Evidence: the classification rests on the transcript's nine tool calls and their outputs, quoted above with record numbers, plus the run sheet's § 3a/§ 4 and § 5/§ 7 wording. It could have read the other way and did not: a connector tool in the registry, a non-empty resource list, a successful file read, an approval event, or a missing flag would each have made this a breach, and each was checked and found absent. Finding 2 is falsifiable the same way — a plugin-declared `node_repl` would have refuted it, and none exists. Control-home contents are reported by path and structure only; no credential or configuration content is quoted (§ 4).

## Blocker
None.

## Next action
Codex: assess Unit 6. Decide whether the classification stands, then decide the smallest correction to `ev-3-ce-9-run-sheet.md` — its § 3a/§ 4 confirmation wording, its § 1 claim for `-c 'mcp_servers={}'`, and whether a pre-launch tool-registry assertion replaces the flag's broken guarantee. Also decide whether the saved Run A is scoreable as the control of this trial or whether the trial restarts once the sheet is corrected.
