# Probe — contained authority for an unattended Claude child

**Date:** 2026-08-07
**Claude Code:** 2.1.220
**Checkout:** isolated Codex worktree, not Claude's active checkout
**Author:** Codex. Verification addendum by Claude — see the last section.
**Operator decision:** use the narrow unattended profile: no push and no tool-side network.

This record corrects the conclusion in
`probe-unattended-authority-2026-08-07.md`. That record correctly proved that denying
`WebFetch` and `WebSearch` alone does not remove network access, because Claude can use
`curl`. It incorrectly concluded that Claude Code had no OS-level network-isolation
mechanism. Claude Code 2.1.220 has a native macOS Seatbelt sandbox for Bash and its
children, including a strict network allowlist added in 2.1.219.

Official references:

- <https://code.claude.com/docs/en/sandboxing>
- <https://code.claude.com/docs/en/settings#sandbox-settings>
- <https://code.claude.com/docs/en/cli-reference>

---

## Safe profile tested

The contained child used these layers together:

1. `sandbox.enabled: true`
2. `sandbox.failIfUnavailable: true` — fail closed instead of silently running Bash
   without the sandbox.
3. `sandbox.allowUnsandboxedCommands: false` — disable the
   `dangerouslyDisableSandbox` escape hatch.
4. `sandbox.network.allowedDomains: []` and `strictAllowlist: true` — no network from
   Bash or any child process, with no approval prompt.
5. `--tools 'Bash,Skill'` — do not expose built-in `Read`, `Edit`, or `Write`, which do
   not run inside the Bash sandbox.
6. `--strict-mcp-config` with no MCP config — load no MCP tools.
7. `--disallowedTools 'Bash(git push *)' WebFetch WebSearch 'mcp__*'` — block push at
   the permission layer and remove in-process web and MCP tools.
8. `disableAllHooks`, `disableClaudeAiConnectors`, `disableRemoteControl`,
   `disableAgentView`, `disableArtifact`, and `autoMemoryEnabled: false`.
9. `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` — strip Anthropic and cloud-provider
   credentials from subprocesses and keep filesystem isolation enabled.
10. `sandbox.filesystem.denyRead: ["~/"]`, with narrow `allowRead` entries for the
    selected checkout and its shared Git metadata.
11. `--no-session-persistence`.

`Skill` remains available, and `/work-loop-v2` remained listed in the child's available
commands. With `Edit` and `Write` absent, Claude must perform repository reads and writes
through sandboxed Bash.

---

## Observed results

### Local execution works

Claude ran:

```text
printf "LOCAL_OK\n"
```

Result:

```text
LOCAL_OK
```

### Bash network is blocked by the OS-backed sandbox

Claude attempted:

```text
curl --silent --show-error --connect-timeout 5 https://example.com >/dev/null
```

Result:

```text
curl: (56) CONNECT tunnel failed, response 403
```

The request was refused by Claude Code's sandbox proxy with an empty strict allowlist.
The model connection itself continued because the Claude process stays outside the Bash
sandbox.

### Push is blocked before execution

Claude attempted the harmless local command:

```text
git push --help
```

Result:

```text
Permission to use Bash with command git push --help has been denied.
```

The denial happened before Bash executed the command. The rule matched the `git push`
prefix even though this particular probe would only have displayed help.

### MCP and web tools are absent

The verbose startup record reported:

```text
tools: [Bash, Skill]
mcp_servers: []
```

`WebFetch`, `WebSearch`, built-in file tools, subagent tools, computer-use tools, and MCP
tools were not present.

### Hooks are disabled

An earlier probe without `disableAllHooks` visibly ran three `SessionStart` hooks. The
same verbose startup probe with `disableAllHooks: true` emitted no hook events, while
`/work-loop-v2` remained available.

### Writes outside the checkout are blocked

From the isolated checkout, sandboxed Bash attempted to write a marker into a separate
Codex visualization directory. Result:

```text
operation not permitted
```

The marker was not created. This is OS enforcement on the shell redirect, not a model
claim.

### Built-in file tools must not be exposed

A separate negative-control probe used `dontAsk` plus an allow rule for one temporary
directory, but inherited repository permission rules include bare `Edit` and `Write`
allows. Built-in `Write` successfully created a file elsewhere under `/tmp`.

That proves the contained profile cannot safely include built-in `Edit` or `Write` while
the repository's broad permission rules are loaded. Restricting the child to
`Bash,Skill` makes file writes pass through Seatbelt instead.

### Home reads can be blocked while Git remains usable

With the home directory denied and the checkout plus its linked-worktree Git metadata
re-allowed:

```text
CHECKOUT_GIT_OK
head: /Users/.../.claude/settings.json: Operation not permitted
```

`git status --short` returned zero. It also printed warnings for repository paths already
covered by the project's `Read(archive/**)` deny rules and for the blocked global ignore
file. The dispatcher runs its own Git safety checks outside the Claude child, so these
warnings do not weaken the dispatcher's allowlist guard, but the selected pilot task must
not require a denied archive path.

---

## Decision and remaining work

The operator's Phase 1d decision is now settled:

> An unattended Claude child may run only with the contained profile above: shell and
> Work Loop skill only; strict empty Bash network allowlist; no MCP, web, hooks,
> connectors, remote control, subagents, built-in file tools, or push; credential
> scrubbing; no unsandboxed-command escape.

This proves the mechanism and the policy. It does **not** prove dispatcher integration.
Before Phase 2, the dispatcher must expose one explicit unattended mode that applies this
profile on every Claude hop, logs the active restrictions, fails closed if the installed
Claude version is below 2.1.219 or the sandbox is unavailable, and has an end-to-end live
test. Ordinary attended and courier launches must keep their current behavior.

Phase 2 also remains blocked by the known read-only-status false `STALE LOCK` result under
PID-visibility denial, the supervised `caffeinate -i` launch requirement, and clean
branch/isolation proof.

---

## Verification addendum — Claude, 2026-08-07

Codex's record is the correcting authority here; this section only states what was
independently checked and what the check added. Method: `claude --version` and
`claude --help` locally, plus the official sandboxing and settings pages fetched fresh.

**Confirmed, every load-bearing claim.** Installed version is `2.1.220`. The macOS
sandbox is Seatbelt ("On macOS, there is nothing to install: sandboxing uses the built-in
Seatbelt framework"). The boundary covers "every Bash command and its child processes",
which is why `curl` is contained where a `WebFetch` deny rule is not. `strictAllowlist`
is real and is documented as requiring **v2.1.219 or later**, matching Codex's account
exactly. `enabled`, `failIfUnavailable`, `allowUnsandboxedCommands`,
`network.allowedDomains`, `filesystem.denyRead` and `filesystem.allowRead` are all real
settings keys with the stated meanings. `--tools`, `--strict-mcp-config` and
`--no-session-persistence` are all present in `--help`. `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB`
is documented, and additionally forces filesystem isolation on by making Claude Code
ignore `filesystem.disabled` from every source, including managed settings.

The docs also confirm the reason the profile must drop built-in file tools, in the
sandboxing page's own words: strict allowlisting is enforced "for sandboxed commands only;
in-process tools such as `WebFetch` still follow their permission rules." Codex reached
that boundary by negative control; the documentation states it directly.

**Two constraints the profile depends on that the record above does not state.** Both are
silent-failure paths, so they belong with the profile rather than in a later review.

1. **`strictAllowlist` is scope-restricted, and a repo-level settings file cannot set it.**
   The doc: it takes effect only "in user, managed, or CLI `--settings` settings", and
   "Setting it in a repository's `.claude/settings.json` or `.claude/settings.local.json`
   has no effect." The dispatcher must therefore deliver the profile by CLI `--settings`
   on every hop. If it ever writes the profile into a repository settings file instead,
   the network containment silently does not apply — and the failure is invisible on a
   machine whose *user* settings already carry the key, which is the worst version of this
   bug: it passes for the tester and fails for everyone else. This makes "logs the active
   restrictions" (above) load-bearing rather than a nicety, and the log must record the
   scope the profile arrived through, not merely that it was requested.

2. **Array-valued keys merge across every settings scope and can widen the policy.** The
   doc: "For array keys such as `excludedCommands` and `allowRead`, Claude Code merges
   entries from every scope, so a developer can append entries that widen the policy."
   Boolean keys do not have this problem — a managed value wins. So `denyRead: ["~/"]` can
   be re-opened by an `allowRead` entry sitting in any other scope, and the allowlist can
   be widened by an `excludedCommands` entry. Closing this requires
   `allowManagedReadPathsOnly` and `allowManagedDomainsOnly` in **managed** settings —
   an MDM-layer control the dispatcher cannot set for itself.

   The practical consequence: the containment Codex observed was observed on Codex's
   machine with whatever scopes were live there. It is not automatically the containment a
   different checkout gets. The end-to-end live test named above should assert the
   *effective* policy in the child — a denied read and a refused connection observed from
   inside the run — rather than assert that the profile was passed.

Neither point disputes the record. Both are conditions on carrying it from a probe into
the dispatcher, and both are checkable.
