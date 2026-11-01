#!/usr/bin/env bash
# PreToolUse hook (Bash): blocks commands the seed's rules forbid.
# Exit 2 blocks the call; stderr is shown to the agent as the reason.
# Exit 0 lets the normal permission flow decide.

source "$(dirname "$0")/_json.sh"
input=$(cat)
cmd=$(json_field "$input" tool_input.command)
[ -z "$cmd" ] && exit 0

block() {
  echo "Blocked by .claude/hooks/guard-bash.sh: $1" >&2
  echo "This rule is deliberate (AGENTS.md → Hard stops / Rules that never bend). Don't work around it; queue it for the owner if it is really needed." >&2
  exit 2
}

# Split on ; && || | so each simple command is checked on its own.
while IFS= read -r part; do
  part="${part#"${part%%[![:space:]]*}"}"   # trim leading space
  [ -z "$part" ] && continue

  # git push --force / -f (but allow --force-with-lease only when not combined with --force)
  if [[ "$part" =~ ^git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$) ]]; then
    if [[ "$part" =~ [[:space:]](--force|-f)([[:space:]]|$) ]] || [[ "$part" =~ [[:space:]]\+[^[:space:]]+ ]]; then
      block "force-push rewrites shared history. Make a new commit instead."
    fi
  fi

  # git reset --hard
  if [[ "$part" =~ ^git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+reset([[:space:]].*)?[[:space:]]--hard ]]; then
    block "git reset --hard discards work that may not be yours. Commit or branch instead."
  fi

  # git stash (shared across worktrees); allow 'git stash list'
  if [[ "$part" =~ ^git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+stash([[:space:]]|$) ]] && ! [[ "$part" =~ stash[[:space:]]+list ]]; then
    block "git stash is shared by every worktree, so a pop can take another agent's changes. Use a temporary commit on your branch."
  fi

  # git clean -f (deletes untracked files)
  if [[ "$part" =~ ^git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+clean([[:space:]]+-[a-zA-Z]*f) ]]; then
    block "git clean -f deletes untracked files that may not be yours."
  fi

  # rm -r on broad targets: / ~ $HOME . .. * or a bare drive root
  if [[ "$part" =~ ^(sudo[[:space:]]+)?rm[[:space:]] ]] && [[ "$part" =~ [[:space:]](-[a-zA-Z]*[rR][a-zA-Z]*|--recursive)([[:space:]]|$) ]]; then
    read -ra words <<< "$part"          # read does no glob expansion
    for target in "${words[@]}"; do
      target="${target%\"}"; target="${target#\"}"; target="${target%\'}"; target="${target#\'}"
      case "$target" in
        '/'|'/*'|'~'|'~/'|'~/*'|'$HOME'|'$HOME/'|'$HOME/*'|'${HOME}'|'.'|'./'|'..'|'../'|'*'|'./*'|'/c'|'/c/'|'C:/'|'C:\')
          block "recursive delete of a broad path ($target). Delete specific files you created." ;;
      esac
    done
  fi

  # Reading secrets: cat/less/head/tail/source/grep/bat on .env (not .env.example)
  if [[ "$part" =~ ^(cat|less|more|head|tail|bat|source|\.|grep|rg|awk|sed|strings|xxd|od)[[:space:]] ]] && [[ "$part" =~ (^|[[:space:]/])\.env([.][a-zA-Z0-9_-]+)?([[:space:]]|$) ]] && ! [[ "$part" =~ \.env\.example ]] \
     && ! [[ "$part" =~ ^(grep|rg)[[:space:]]+(-[a-zA-Z]*[cqlL][a-zA-Z]*[[:space:]]+)+ ]]; then
    # grep -c / -q / -l print counts or names, never values, so they are allowed.
    block "reading .env would expose secrets. Check whether a key is set by name only, e.g. grep -c '^NAME=' .env."
  fi
done < <(printf '%s\n' "$cmd" | sed -E 's/(\|\||&&|;|\|)/\n/g')

exit 0
