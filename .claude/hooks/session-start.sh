#!/usr/bin/env bash
# SessionStart hook: prints the context a fresh session needs first.
# Its stdout is added to the session's context. It never blocks; it always exits 0.

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

if grep -qE '\{\{[^}]+\}\}' AGENTS.md 2>/dev/null; then
  echo "This repository is a fresh copy of the project-setup seed: AGENTS.md still contains unfilled placeholders."
  echo "Run /kickoff before any other work (or follow .claude/skills/kickoff/SKILL.md)."
  exit 0
fi

if [ -f STATE.md ]; then
  echo "=== STATE.md → Resume Here ==="
  awk 'tolower($0) ~ /^## resume here/{f=1; print; next} f && /^## /{exit} f' STATE.md | head -40
fi

if [ -f docs/HUMAN_QUEUE.md ]; then
  open=$(awk 'tolower($0) ~ /^## open items/{f=1; next} f && /^## /{exit} f && /^### Q/{n++} END{print n+0}' docs/HUMAN_QUEUE.md)
  echo "=== Owner queue: ${open} open item(s) in docs/HUMAN_QUEUE.md ==="
elif [ -f docs/ITERATION_PLAN.md ]; then
  open=$(grep -cE 'Decision:[[:space:]]*$' docs/ITERATION_PLAN.md)
  echo "=== Iteration plan: ${open} unanswered Decision line(s) in docs/ITERATION_PLAN.md ==="
fi

if [ -f log.md ]; then
  echo "=== log.md (last 5) ==="
  grep -E '^- ' log.md | tail -5
fi

dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
[ "${dirty:-0}" != "0" ] && echo "=== git: ${dirty} uncommitted change(s); check they are explained by STATE.md ==="

echo "Follow AGENTS.md → Session start ritual (or run /start)."
exit 0
