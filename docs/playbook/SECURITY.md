# Security and secrets

## Keys

- Secrets live in `.env` (git-ignored) or a platform secret store. `.env.example` lists the names with empty values.
- **Never read, print or write a key.** Check whether one is set by name only: `[ -n "$ANTHROPIC_API_KEY" ] && echo set`. The seed's `PreToolUse` hook blocks reading `.env`.
- If the owner pastes a key into chat, don't use it. Tell them to revoke it and put a new one in `.env`.
- Keys never reach the repository, a log, a generated file, or a data vault. Timeline Writer's principle P5: "Keys never leave their place."
- In tests, build fake keys at runtime (`"sk-ant-" + "x" * 24`). A literal fake key looks real to a scanner and stops the push.

## Before every push

Run `scripts/security_check.sh` and stop on a finding. It checks:
- tracked and staged files for secret patterns (API keys, private keys, tokens, credentialed URLs);
- that no `.env` file is tracked;
- that recent commit author emails are no-reply addresses.

A finding is a hard stop even when it looks harmless. Fix it, or get the owner to accept it explicitly and record the acceptance in `STATE.md` (Timeline Writer accepted old commits carrying a personal email, because only a history rewrite would remove them, and that is the owner's call).

## Identity

Set the commit email to a GitHub no-reply address **before the first commit** of any new repository: `git config user.email <id>+<user>@users.noreply.github.com`. Old commits can't be fixed without rewriting history.

## Destructive actions

The seed's hooks and permissions block, and the agent never works around:
- `git push --force` (use a new commit instead; `--force-with-lease` only on the agent's own unshared branch, if the owner allows it);
- `git reset --hard` and `git clean -fd` on work you didn't create;
- `git stash` (shared across worktrees);
- `rm -rf` on broad paths;
- deleting content the agent didn't create.

## Accounts and anti-abuse systems

Never send synthetic keyboard, mouse or controller input to a system with anti-cheat or fraud detection. It risks the owner's account (Battle Drill, Shockwave). Test through code paths, in-situ harnesses and robots instead.

## Paid services

- No paid call without the owner starting it, or within a budget they set.
- Show the estimated cost before a paid call; record the real cost after.
- Enforce a monthly cap in code, server-side, not just in the UI (Timeline Writer: `TIMELINE_MONTHLY_CAP_USD`, default $80).
