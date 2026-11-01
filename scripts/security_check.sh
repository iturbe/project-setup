#!/usr/bin/env bash
# Pre-push security check (docs/playbook/SECURITY.md). Exit 0 = clean; 1 = findings.
# Never prints a secret's value: only the file, line number and pattern name.
#
# Usage: scripts/security_check.sh [--all-history-authors]
#   Checks tracked + staged files for secret patterns, tracked .env files,
#   and the author emails of the last 50 commits (or all, with the flag).

set -uo pipefail
cd "$(dirname "$0")/.."

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "security_check: not a git repository"; exit 1
fi

findings=0
report() { echo "security_check: FINDING: $1"; findings=$((findings+1)); }

# Patterns are split so this file never contains a full literal key shape.
names=(
  "Anthropic key"   "OpenAI-style key"   "AWS access key"   "GitHub token"
  "GitHub fine-grained token" "Slack token" "Google API key" "Stripe live key"
  "ElevenLabs-style key" "Private key block" "Credentialed URL"
  "Generic secret assignment"
)
patterns=(
  'sk-''ant-[A-Za-z0-9_-]{20,}'
  'sk-''(proj-)?[A-Za-z0-9]{32,}'
  'AK''IA[0-9A-Z]{16}'
  'gh''[pousr]_[A-Za-z0-9]{36,}'
  'github''_pat_[A-Za-z0-9_]{40,}'
  'xox''[abprs]-[A-Za-z0-9-]{10,}'
  'AI''za[0-9A-Za-z_-]{35}'
  'sk_''live_[0-9A-Za-z]{24,}'
  'xi-api-key[" :=]+[A-Za-z0-9]{32,}'
  '-----BEGIN ''([A-Z]+ )?PRIVATE KEY-----'
  '[a-z]+://[^/[:space:]:@]+:[^/[:space:]@]{6,}@[^[:space:]]+'
  '(api[_-]?key|secret|token|password)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][A-Za-z0-9/+_-]{24,}["'"'"']'
)

# Files: tracked, plus staged-but-new. Skip binaries via grep -I.
files=$( { git ls-files; git diff --cached --name-only --diff-filter=A; } | sort -u )

for i in "${!patterns[@]}"; do
  hits=$(printf '%s\n' "$files" | while IFS= read -r f; do
    [ -f "$f" ] || continue
    case "$f" in scripts/security_check.sh) continue ;; esac
    grep -IEn -- "${patterns[$i]}" "$f" 2>/dev/null | cut -d: -f1 | sed "s|^|$f:|"
  done)
  if [ -n "$hits" ]; then
    while IFS= read -r h; do report "${names[$i]} at $h"; done <<< "$hits"
  fi
done

# Tracked .env files (examples are fine).
while IFS= read -r f; do
  base="${f##*/}"
  case "$base" in
    .env.example|.env.sample|.env.template) ;;
    .env|.env.*) report "tracked secrets file: $f (git rm --cached \"$f\")" ;;
  esac
done <<< "$files"

# .gitignore must cover .env
if ! git check-ignore -q .env 2>/dev/null; then
  report ".env is not ignored by .gitignore"
fi

# Commit author emails should be no-reply addresses.
range="-50"; [ "${1:-}" = "--all-history-authors" ] && range=""
if git rev-parse HEAD >/dev/null 2>&1; then
  emails=$(git log $range --format='%ae%n%ce' 2>/dev/null | sort -u)
  while IFS= read -r e; do
    [ -z "$e" ] && continue
    case "$e" in
      *noreply*|*no-reply*) ;;
      *) report "commit email is not a no-reply address: ${e%%@*}@… (set git config user.email to your GitHub no-reply address)" ;;
    esac
  done <<< "$emails"
fi
cur=$(git config user.email || true)
case "$cur" in
  ""|*noreply*|*no-reply*) ;;
  *) report "git config user.email is not a no-reply address (${cur%%@*}@…); future commits will carry it" ;;
esac

if [ "$findings" -gt 0 ]; then
  echo "security_check: $findings finding(s). Stop: fix each one, or get the owner's explicit acceptance recorded in STATE.md."
  exit 1
fi
echo "security_check: OK"
