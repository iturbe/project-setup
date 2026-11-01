#!/usr/bin/env bash
# PreToolUse hook (Read|Edit|Write): blocks file tools on secret files.
# .env.example is allowed; .env, .env.local, .env.production etc. are not.

source "$(dirname "$0")/_json.sh"
input=$(cat)
path=$(json_field "$input" tool_input.file_path)
[ -z "$path" ] && exit 0

name="${path##*/}"
name="${name##*\\}"
case "$name" in
  .env.example|.env.sample|.env.template) exit 0 ;;
  .env|.env.*)
    echo "Blocked by .claude/hooks/guard-files.sh: $name holds secrets. Never read, print or write a key (AGENTS.md → Rules that never bend). Edit .env.example for names; the owner fills in .env." >&2
    exit 2 ;;
esac
exit 0
