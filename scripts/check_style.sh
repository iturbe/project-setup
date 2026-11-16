#!/usr/bin/env bash
# Counts machine-detectable writing-rule violations (agent-style, .agent-style/RULES.md) in tracked
# Markdown files. Warn only: semantic rules need /style-review, and verbatim quotes may break rules.
# Usage: scripts/check_style.sh [file.md ...]     (default: every tracked .md file)
# Needs npx and network the first time (the pinned package is then cached).
set -uo pipefail
cd "$(dirname "$0")/.."
VERSION="0.9.0"
if ! command -v npx >/dev/null 2>&1; then echo "check_style: skip: npx not found"; exit 0; fi
if [ $# -gt 0 ]; then files=("$@"); else
  mapfile -t files < <(git ls-files '*.md' | grep -vE '^\.agent-style/|^\.claude/skills/style-review/')
fi
total=0
for f in "${files[@]}"; do
  # The block that agent-style appends to AGENTS.md quotes the patterns it bans; check the rest.
  src="$f"
  if grep -q '<!-- BEGIN agent-style' "$f"; then
    src=$(mktemp --suffix=.md); sed '/<!-- BEGIN agent-style/,/<!-- END agent-style -->/d' "$f" > "$src"
  fi
  out=$(npx --yes "agent-style@$VERSION" review "$src" --audit-only 2>/dev/null) || { echo "check_style: skip: agent-style unavailable"; exit 0; }
  n=$(printf '%s' "$out" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const j=JSON.parse(s);const c={};for(const r of j.rule_results)if(r.count)c[r.rule]=r.count;const n=j.total_violations;if(n)console.log(n+"\t"+Object.entries(c).map(([k,v])=>k+"="+v).join(" "));else console.log(0)})')
  count=${n%%$'\t'*}
  if [ "$count" != "0" ]; then echo "check_style: $f: ${n#*$'\t'}"; total=$((total + count)); fi
done
echo "check_style: $total machine-detectable violations in ${#files[@]} files (warn only)"
exit 0
