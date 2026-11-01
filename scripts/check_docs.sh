#!/usr/bin/env bash
# Checks the project's docs are present, filled in, and small enough to read every session.
# Usage: scripts/check_docs.sh [--strict]
#   default:  missing files fail; placeholders and sizes warn
#   --strict: placeholders fail too (used at the end of /kickoff)

set -uo pipefail
cd "$(dirname "$0")/.."

strict=0
[ "${1:-}" = "--strict" ] && strict=1
fail=0
warn=0

required=(AGENTS.md CLAUDE.md STATE.md ROADMAP.md LESSONS_LEARNED.md log.md docs/PROJECT_SPEC.md docs/OWNER.md scripts/verify.sh)
for f in "${required[@]}"; do
  if [ ! -f "$f" ]; then echo "check_docs: MISSING $f"; fail=1; fi
done

if [ ! -f docs/HUMAN_QUEUE.md ] && [ ! -f docs/ITERATION_PLAN.md ]; then
  echo "check_docs: MISSING a human channel (docs/HUMAN_QUEUE.md or docs/ITERATION_PLAN.md)"; fail=1
fi

# Leftover {{placeholders}} (examples and the seed README are exempt).
placeholders=$(grep -rlE '\{\{[^}]+\}\}' --include='*.md' . 2>/dev/null \
  | grep -v -e '^./docs/examples/' -e '^./.git/' -e '^./.claude/' -e '^./README.md$' || true)
if [ -n "$placeholders" ]; then
  n=$(echo "$placeholders" | wc -l | tr -d ' ')
  if [ "$strict" = 1 ]; then
    echo "check_docs: FAIL $n file(s) still contain {{placeholders}}:"; echo "$placeholders" | sed 's/^/  /'; fail=1
  else
    echo "check_docs: note: $n file(s) still contain {{placeholders}} (run /kickoff)"; warn=1
  fi
fi

# Size budgets: these files are read every session.
size_warn() { # file max_bytes reason
  [ -f "$1" ] || return 0
  local s; s=$(wc -c < "$1" | tr -d ' ')
  if [ "$s" -gt "$2" ]; then
    echo "check_docs: warn: $1 is $((s/1024)) KB (budget $(($2/1024)) KB). $3"; warn=1
  fi
}
size_warn STATE.md 61440 "Collapse closed milestones into Milestone history; move narratives to docs/runs/."
size_warn LESSONS_LEARNED.md 40960 "Keep rules only; move stories to docs/."

if [ -f AGENTS.md ]; then
  lines=$(wc -l < AGENTS.md | tr -d ' ')
  if [ "$lines" -gt 220 ]; then
    echo "check_docs: warn: AGENTS.md has $lines lines (budget ~200). Move detail to docs/ or skills."; warn=1
  fi
fi

# log.md lines should look like "- YYYY-MM-DD · ..."
if [ -f log.md ]; then
  bad=$(grep -E '^- ' log.md | grep -vcE '^- (\{\{DATE\}\}|[0-9]{4}-[0-9]{2}-[0-9]{2}) · ' || true)
  if [ "${bad:-0}" != "0" ]; then echo "check_docs: warn: $bad log.md line(s) don't start with '- YYYY-MM-DD · '"; warn=1; fi
fi

if [ "$fail" = 1 ]; then echo "check_docs: FAIL"; exit 1; fi
if [ "$warn" = 1 ]; then echo "check_docs: OK (with notes)"; else echo "check_docs: OK"; fi
exit 0
