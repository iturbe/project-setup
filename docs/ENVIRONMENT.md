# Environment

The machines this project runs on, the tools on them, and what a new machine must redo. Git is the only source of truth; anything needed to continue lives in the repository.

## Machines

| Name | What it is | Runs | Doesn't run | Repo path |
|---|---|---|---|---|
| {{e.g. MacBook Air}} | {{OS, CPU, RAM}} | {{build, tests, simulator}} | {{e.g. the game client}} | {{path}} |

## Tools

| Tool | Version | Checked | Notes |
|---|---|---|---|
| git | | | commit email is a no-reply address |
| {{language/runtime}} | | | |
| {{SDK/editor}} | | | |
| Claude Code | | | |

## Pre-flight (every session)

The checks in `AGENTS.md` → Session start ritual, step 5, spelled out:

```bash
git status --short                 # clean, or explained by STATE.md
{{toolchain check, e.g. xcode-select -p, uv --version, node --version}}
```

## New machine checklist

1. Clone with `git clone` (and `git lfs install` first if the repo uses LFS). Never copy a project through a vendor tool's own sync.
2. Set the git identity: `git config user.email <github-no-reply-address>`.
3. Install the tools in the table above; record the versions here.
4. Copy `.env.example` to `.env`, and ask the owner to fill in the keys. Check them by name only.
5. Run `scripts/verify.sh`. Expect: {{the current green result, e.g. "47 tests passed"}}.
6. {{Any project-specific step: editor settings, MCP servers, signing}}.
7. If Claude memory notes were exported to `docs/claude-memory/`, copy them into Claude Code's memory folder for this project on the new machine.

## Switching machines

Before leaving: commit, push, and update `STATE.md` → Resume here with the machine you are leaving. On arrival: pull, run the pre-flight, run `scripts/verify.sh`.
