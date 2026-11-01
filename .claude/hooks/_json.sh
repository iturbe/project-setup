#!/usr/bin/env bash
# Shared helper for hooks: read one field from the hook's JSON input.
# Usage: json_field "<json>" tool_input.command
# Tries jq, then python3, then python. Prints nothing if none is available
# or the field is missing. Works in Git Bash on Windows too.

json_field() {
  local json="$1" path="$2"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$json" | jq -r ".${path} // empty" 2>/dev/null
    return
  fi
  local py=""
  if command -v python3 >/dev/null 2>&1; then py=python3
  elif command -v python >/dev/null 2>&1; then py=python
  fi
  if [ -n "$py" ]; then
    printf '%s' "$json" | "$py" -c '
import json, sys
d = json.load(sys.stdin)
for k in sys.argv[1].split("."):
    d = d.get(k) if isinstance(d, dict) else None
print("" if d is None else d)
' "$path" 2>/dev/null
  fi
}
