---
task: eval-v0-3-restart
turn: codex
---

## Objective and scope
Restart the Work Loop v2 behavioural-eval effort from the clean current `main` baseline and carry it to an honest, repeatable eval capability whose first live act is EV-3/CE-9. The operator has approved this `eval-v0-3` restart; adoption remains a later operator decision based on recorded operating evidence.

This task may use the abandoned `session/2026-08-09-eval` branch and its dirty worktree as read-only evidence, but it must not edit, clean, commit, merge, cherry-pick, or otherwise change that checkout. Excluded from the whole task unless the operator later expands scope: an eval platform, dashboard, database, new scoring system, new durable fixture family, unattended eval execution, Work Loop core/skill/command changes, dispatcher changes, and automatic landing or cleanup of another checkout.

## Lane and unit
Standard. Discovery mode. Unit 3 — establish a verifiable source-blind Codex launch boundary after the first live Run A exposed connector access.

Named reason for the loop: the work must survive several sessions, its abandoned predecessor left substantial uncommitted partial effects in another checkout, and independent assessment is needed before any recovered design or implementation counts as the new baseline.

## Brief
The first live act of EV-3/CE-9 stopped before Run B because Run A used connected Google Drive despite the filesystem boundary. The useful next move is not another trial or an assumed flag: establish whether the installed Codex runtime can create a genuinely memory-only control whose effective capabilities exclude connectors, external retrieval, prior-session history, repository sources, and operator-granted expansion. This discovery advances the approved Phase 1 fresh-context proof by resolving the measurement boundary before the run sheet is changed or the trial is repeated.

### Required outcome

Inspect the current local Codex CLI/configuration surfaces and the existing run sheet, then return one of two evidence-backed results:

1. an exact, operator-runnable launch configuration for Run A whose effective runtime has no MCP servers/connectors or other external retrieval, no prior Codex session history, no access to the checkout or known Harbourview files, and no permission path by which an operator can widen those capabilities during the run; or
2. a precise capability gap explaining which part cannot be enforced with the currently installed Codex runtime inside this task's scope.

This is a discovery unit. Do not edit the run sheet or implement the candidate configuration. Do not launch a model turn, repeat Run A, start Run B, or score another trial. Hand back so Codex can reframe or stop.

### Evidence and claims to check

- Reproduce the failure premise from the operator evidence recorded below: the filesystem profile allowed the isolated Run A process to call connected Google Drive and fetch documents. Distinguish commands that required operator approval from connector calls that executed without one.
- Inspect only the relevant local Codex CLI help/configuration and installed runtime surfaces needed to establish how MCP/connectors, web/network access, approval policy, sandboxing, and `CODEX_HOME` are resolved. Do not expose authentication material or read unrelated session content.
- For any proposed launch configuration, provide fail-capable evidence of the **effective** capability set, not only the requested flags: show that the ordinary configuration exposes the retrieval route while the candidate does not, and show how attempts to expand access are refused rather than delegated to an operator prompt. If the effective state cannot be verified without invoking a model, state that limitation and stop rather than claiming the boundary.
- Check whether the outer `sandbox-exec` boundary and an inner Codex sandbox can coexist on this host; Unit 2 reported `sandbox_apply: Operation not permitted` for nested seatbelt. Do not silently drop either source isolation or capability isolation to make the launch work.
- Keep the exact Run A prompt, the accepted PASS/PARTIAL/FAIL contract, Run B input, and the existing result destination unchanged.

### Scope and stop conditions

Read-only discovery plus this state-file hand-back only. Do not change `ev-3-ce-9-run-sheet.md`, any Codex/OpenAI configuration, credentials, carrier, dispatcher, Work Loop file, scenario, fixture, plan, or result schema. Do not create another artifact. Stop if enforcing the boundary needs a product/configuration change, a carrier/dispatcher change, a nested model invocation, or an operator decision about expanded scope.

## Latest result

Inspected (2026-08-13):

- Claim (1) — the run sheet's filesystem profile allowed Run A to reach connected Google Drive, and those calls were not operator-gated: **HOLDS.** Read the Run A transcript at `~/ce-9-control/.codex-home/sessions/2026/08/13/rollout-2026-08-13T20-04-13-019ffc14-dbb8-7dc1-87fc-baa6d8251463.jsonl` (146 records; 17 `custom_tool_call`, 2 `function_call`). The two routes separate cleanly. Local shell calls via `tools.exec_command` (calls 2–8 and 19) each carry `sandbox_permissions:"require_escalated"` plus a `justification` string — those are the ones that reached the operator as prompts. The Google Drive calls carry **neither field**: `mcp__codex_apps__google_drive_search` (calls 10, 11, 13), `mcp__codex_apps__google_drive_recent_documents` (call 14) and `mcp__codex_apps__google_drive_fetch` (calls 15–16) executed directly, returning real results in 2.2–2.8 s wall time, including a multi-document fetch truncated at 55,526 tokens. The session's own `turn_context` records `approval_policy: "on-request"` and `sandbox_policy: {type: "workspace-write", network_access: false}`.
- Claim (4) — Unit 2's report that nested seatbelt fails on this host: **HOLDS, reproduced.** `codex sandbox -- /bin/echo nested-ok` prints `nested-ok` standalone; the same command inside `sandbox-exec -p "$CE9_PROFILE"` fails with `Error: Operation not permitted (os error 1)`.
- Scope constraint — the run sheet, fixtures, Codex configuration and credentials unchanged: **HOLDS.** This unit changed only this state file. `git status --short` over `plans/.../fixtures/ce-9/` and `ev-3-ce-9-run-sheet.md` returns no output.

Result: the discovery returns **outcome 2 of the brief — a precise capability gap.** No launch configuration can be certified from this unit, and the candidate found is offered as a candidate rather than a proven boundary.

The gap has three parts, each separately established.

**(a) Connector access is account-side, not local, so no local configuration audit can predict it.** Local `config.toml` declares only two MCP servers — `node_repl` (enabled) and `computer-use` (`enabled = false`); there is no Google Drive entry. `codex plugin list` reports `google-drive@openai-curated` as **not installed**. Yet the isolated control home — seeded with nothing but a copy of `auth.json` and `config.toml` — populated `plugins/cache/openai-curated-remote/` with `google-drive`, `github` and two `app-*` connectors at first launch, and the model reached Drive. `codex features list` shows `apps` as **stable, true** and `remote_plugin` as **stable, true**. The rendered prompt carries an `<apps_instructions>` block stating that an app "is equivalent to a set of MCP tools within the `codex_apps` MCP" and that apps "can also be implicitly triggered". Connector capability therefore arrives with the account at session start, and copying only `CODEX_HOME` does not leave it behind.

**(b) `network_access: false` does not cover connectors.** The one setting whose name suggests it closes external retrieval governs model-generated shell commands only. It was in force for the whole of Run A while six Drive calls succeeded.

**(c) Source isolation and capability isolation cannot both be enforced by seatbelt on this host.** Codex's own sandbox will not start inside the outer `sandbox-exec` (claim 4). The run sheet's outer boundary and a Codex-side `--sandbox read-only` are therefore mutually exclusive here, and the brief forbids dropping either.

The candidate configuration, **unverified**: `CODEX_HOME=<isolated> codex --disable apps -c 'mcp_servers={}' --sandbox read-only --ask-for-approval never`. `--ask-for-approval never` is the part that answers the brief's "no permission path to widen access" requirement — it refuses rather than prompting, so operator attentiveness stops being load-bearing. It cannot be certified for two reasons: it cannot run inside the outer boundary (c), and its effect on the tool registry is unproven (below).

Evidence: the capability probe is `codex debug prompt-input`, which renders the model-visible input as JSON without a model turn. Marker counts, baseline → `--disable apps` → full candidate: `apps_instructions` 2 → 0 → 0; `codex_apps` 1 → 0 → 0; `tool_search` 2 → 0 → 0; the sandbox `writable roots` line 1 → 1 → 0. **The check is fail-capable and did fail once for the wrong reason**: an earlier candidate run passed `--sandbox`, which `prompt-input` rejects with exit `2` and a zero-byte file, producing the same all-zero counts. That run was discarded and re-run with `-c` overrides (exit `0`, 17,656 bytes). Reading the exit status, not the counts, is what separated the two.

**The limitation that decides the unit.** `prompt-input` renders the *message list*, not the tool registry, and the probe homes it created never synced `plugins/cache/openai-curated-remote/` — so it does not exercise session start, which is exactly when the control home acquired its connectors. The evidence therefore establishes that `--disable apps` removes the connector *instructions*, and does **not** establish that it unregisters the `mcp__codex_apps__*` *tools*. Per the brief, the effective capability set cannot be verified without invoking a model, so this hand-back states the limit rather than claiming the boundary.

Two corrections to the recorded failure, both narrowing it rather than excusing it. The Run A thread identifier, previously recorded as unavailable, is `019ffc14-dbb8-7dc1-87fc-baa6d8251463`. And the Harbourview Drive searches returned `results: []` — the discriminator was not obtained from Drive. The FAIL stands unchanged: the control held a live external retrieval route and used it, which is what disqualifies it, not whether that route happened to hit the answer.

Deferrals, recorded and not done: the control home now holds a real Run A transcript and account-synced connector caches, so whether a future trial must reset it is a run-sheet question this unit may not touch; and settling (a) needs one throwaway observed model turn, which is a new unit or an operator decision, not this one.

## Blocker
None.

## Next action
Codex: assess the capability gap above and decide whether to reframe or stop. The open question is whether one observed throwaway model turn may be spent to test whether `--disable apps` unregisters the `codex_apps` tools, and how EV-3/CE-9 should proceed given that the outer filesystem boundary and a Codex-side sandbox cannot coexist on this host.
