#!/usr/bin/env bash
# The verifier: the only source of truth for "it works" (AGENTS.md → Loop protocol).
# Runs L0 (static) → L1 (build) → L2 (tests) in order and stops at the first failure.
# Exit 0 = green. Anything else = not done.
#
# Rules (docs/playbook/VERIFICATION.md):
# - pin versions and destinations explicitly;
# - print what was built (path, version) so you can tell it read YOUR files;
# - never pipe a step through tail/grep in a way that hides its exit code.

set -euo pipefail
cd "$(dirname "$0")/.."

step() { printf '\n== %s ==\n' "$1"; }

step "Docs"
scripts/check_docs.sh

# >>> PROJECT VERIFIER (kickoff replaces this block) >>>
# Examples:
#   Python (uv):   uv run ruff check . && uv run pytest -q
#   Node:          npm run lint && npm run typecheck && npm test -- --run
#   iOS:           xcodebuild test -project App.xcodeproj -scheme App \
#                    -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6'
#   Editor/MCP:    python tools/lint.py && python tools/build.py && python tools/run_session.py --until "AUTOTEST: END"
PROJECT_VERIFIER_CONFIGURED=0
# <<< PROJECT VERIFIER <<<

if [ "$PROJECT_VERIFIER_CONFIGURED" != "1" ]; then
  if [ "${VERIFY_ALLOW_EMPTY:-0}" = "1" ]; then
    echo
    echo "verify: docs OK; no project verifier configured yet (VERIFY_ALLOW_EMPTY=1)."
    exit 0
  fi
  echo
  echo "verify: FAIL: no project verifier configured. Run /kickoff, or fill in the PROJECT VERIFIER block in scripts/verify.sh." >&2
  echo "        (A verifier that checks nothing can't say 'done'. Set VERIFY_ALLOW_EMPTY=1 only for the seed repo itself.)" >&2
  exit 3
fi

echo
echo "verify: OK"
