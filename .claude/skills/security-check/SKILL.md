---
name: security-check
description: Run the pre-push security check (scripts/security_check.sh), which looks for secret patterns in tracked and staged files, tracked .env files and non-noreply commit emails. Interpret any findings, and stop the push until the owner fixes or explicitly accepts each one. Use before every git push, before making a repository public, or when the user asks to "check for secrets" or "is it safe to push".
allowed-tools: Bash(scripts/security_check.sh*)
---

# Security Check

1. Run `scripts/security_check.sh`. Exit 0 means clean; anything else is a finding.
2. **For each finding:**
   - **A real secret in a tracked file:** remove it from the file, move it to `.env`, and tell the owner to **revoke** it. A secret that reached a pushed commit is compromised even after deletion; rewriting history is the owner's call, never yours.
   - **A fake secret in a test:** build it at runtime instead (`"sk-ant-" + "x" * 24`), so it is never one literal.
   - **A tracked `.env`:** `git rm --cached .env`, and make sure `.gitignore` covers `.env` and `.env.*` (but not `.env.example`).
   - **A personal commit email:** set `git config user.email` to the GitHub no-reply address for future commits. Old commits cannot change without a history rewrite; ask the owner whether to accept the finding, and record their answer in `STATE.md`.
3. **Re-run** until it is clean or every remaining finding is explicitly accepted by the owner.
4. **Never** bypass the check, disable a pattern to make it pass, or push with an open finding.

Never print a secret's value in chat or logs while investigating: refer to it by file, line and type.
