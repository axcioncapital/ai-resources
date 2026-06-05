#!/usr/bin/env bash
# Normalize UTF-8 encoding in a file — fixes mojibake from Research Execution GPT / Perplexity output.
# Usage: fix-mojibake.sh <file>
#
# Applies Unicode NFC normalization and strips invalid UTF-8 byte sequences.
# Safe to run on any text file; no-ops cleanly if the file is already valid UTF-8.
# Requires python3 (standard on macOS/Linux) or iconv.

set -euo pipefail

if [ $# -eq 0 ] || [ -z "${1:-}" ]; then
  echo "Usage: fix-mojibake.sh <file>" >&2
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "fix-mojibake.sh: file not found: $FILE" >&2
  exit 1
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - "$FILE" <<'PYEOF'
import sys
import unicodedata

path = sys.argv[1]
with open(path, 'rb') as f:
    raw = f.read()

# Decode — replace invalid sequences rather than crash
text = raw.decode('utf-8', errors='replace')

# NFC normalization: canonical decomposition followed by canonical composition
# Handles combining characters and variant forms from GPT/Perplexity output
text = unicodedata.normalize('NFC', text)

with open(path, 'w', encoding='utf-8') as f:
    f.write(text)

print(f"fix-mojibake.sh: normalized {path}")
PYEOF

elif command -v iconv >/dev/null 2>&1; then
  TMP=$(mktemp)
  # -c drops invalid UTF-8 byte sequences
  iconv -f UTF-8 -t UTF-8 -c "$FILE" > "$TMP" && mv "$TMP" "$FILE" || rm -f "$TMP"
  echo "fix-mojibake.sh: normalized $FILE (iconv)"

else
  echo "fix-mojibake.sh: neither python3 nor iconv found — skipping normalization" >&2
  exit 0
fi
