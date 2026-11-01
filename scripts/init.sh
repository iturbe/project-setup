#!/usr/bin/env bash
# One-time setup for a new project made from the project-setup seed.
# Mechanical steps only; the interview and the real content come from /kickoff.
#
# Usage: scripts/init.sh "<Project Name>" [--prefix XX] [--strip-examples]

set -euo pipefail
cd "$(dirname "$0")/.."

name=""; prefix=""; strip=0
while [ $# -gt 0 ]; do
  case "$1" in
    --prefix) prefix="$2"; shift 2 ;;
    --strip-examples) strip=1; shift ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) name="$1"; shift ;;
  esac
done

if [ -z "$name" ] && [ "$strip" = 0 ]; then
  echo "usage: scripts/init.sh \"<Project Name>\" [--prefix XX] [--strip-examples]" >&2; exit 2
fi

today=$(date +%Y-%m-%d)

# Portable in-place sed (GNU and BSD/macOS).
sedi() { if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi; }

if [ -n "$name" ]; then
  [ -z "$prefix" ] && prefix=$(echo "$name" | tr -cd '[:alpha:] ' | awk '{for(i=1;i<=NF;i++) printf toupper(substr($i,1,1))}' | cut -c1-3)
  esc_name=$(printf '%s' "$name" | sed 's/[&|]/\\&/g')
  files=$(grep -rl -e '{{PROJECT_NAME}}' -e '{{DATE}}' -e '{{PREFIX}}' --include='*.md' . | grep -v -e '^./docs/examples/' -e '^./.git/' -e '^./README.md$' || true)
  for f in $files; do
    sedi -e "s|{{PROJECT_NAME}}|$esc_name|g" -e "s|{{DATE}}|$today|g" -e "s|{{PREFIX}}|$prefix|g" "$f"
  done
  echo "init: set project name \"$name\", prefix ${prefix}_, date $today"
fi

if [ "$strip" = 1 ]; then
  rm -rf docs/examples
  sedi '/docs\/examples/d' docs/playbook/README.md 2>/dev/null || true
  echo "init: removed docs/examples/"
fi

chmod +x scripts/*.sh .claude/hooks/*.sh 2>/dev/null || true

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "init: created .env from .env.example (fill in keys yourself; agents never read it)"
fi

email=$(git config user.email 2>/dev/null || true)
case "$email" in
  *noreply*|*no-reply*) echo "init: git email OK (no-reply)" ;;
  *) echo "init: WARNING: set a GitHub no-reply email before the first commit:"
     echo "      git config user.email <id>+<username>@users.noreply.github.com" ;;
esac

echo "init: next, open Claude Code here and run /kickoff"
