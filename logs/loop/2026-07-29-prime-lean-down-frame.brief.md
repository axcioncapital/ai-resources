UNIT: 2026-07-29-prime-lean-down-frame
STREAM: 2026-07-29-prime-lean-down
PHASE: frame
REPO: ai-resources
BASE: 816003b6cdf8243de59e690fd5a105cfaea0db60
NEXT: Claude

BRIEF
Need: /prime is a 97,915-byte orientation command whose session-opening machinery
duplicates existing owners and makes every invocation carry unrelated complexity.

Premises to verify:
- prime.md is 830 lines and its Steps 7–8 occupy lines 348–830. [check: wc; open]
- Step 8k embeds the allocator while docs/session-marker.md owns its contract.
- prime-allocator.test.sh exercises the embedded behavior but no standalone helper exists.
- Auto mode duplicates session-start context discovery, scope checks and run-manifest writes.
- Auto mode has real recorded use and its single approval gate must remain available.
- Project copies predominantly consume the canonical file through symlinks.

Scope: first, behavior-preserving unit only. Give marker allocation one executable owner
and remove duplicate runtime explanation already owned by docs/tests.
Do not change task sources, menu ranking, auto semantics, marker-writer authority,
header grammar, mandate schema, plan naming, or execution routing.

Falsified if any allocator test regresses, two sessions can receive the same marker
identity, or a representative Prime path produces different durable artifacts.
