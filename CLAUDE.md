@AGENTS.md

## Claude Code specifics

Everything in `AGENTS.md` applies. This section covers only what is specific to Claude Code.

**Skills** (in `.claude/skills/`, invoke with `/name`):

| Skill | When |
|---|---|
| `/kickoff` | Once, on a new project: interviews the owner and fills every placeholder |
| `/start` | At the start of a session: runs the session start ritual and picks a deliverable |
| `/next` | Runs one micro-loop on the next deliverable, from definition of done to commit |
| `/spike` | Tests one risky platform assumption with the smallest possible experiment |
| `/queue` | Adds an item for the owner (SETUP, TEST, FEEL, DECIDE, MEASURE, PUBLISH) |
| `/iteration-plan` | Writes the end-of-iteration hand-off document (iteration mode) |
| `/lesson` | Records a lesson as a rule |
| `/handoff` | At the end of a session: updates STATE, lessons, log; verifies; commits |
| `/security-check` | Before any push |

**Subagents** (in `.claude/agents/`):
- `reviewer`: a skeptical check of a "done" claim against its definition of done and the verifier output. Use it before closing a milestone, and after any long autonomous run.
- Use the built-in Explore or general-purpose agents for broad searches and research, so the main context stays clean. They return conclusions, not file dumps.

**Hooks** (in `.claude/settings.json`):
- `SessionStart` prints the **Resume here** block, the number of open owner items, and the last lines of `log.md`. On a fresh template, it tells you to run `/kickoff`.
- `PreToolUse` blocks force-push, `git reset --hard`, `git stash`, recursive deletes of broad paths, and reading `.env`. If the hook blocks you, don't look for a way around it: the rule is deliberate. Queue the action for the owner if it is really needed.

**Working habits**
- Run independent reads and searches in parallel. Never run calls in parallel that depend on each other: an edit and the build that should compile it, or two calls to a tool that processes requests one at a time.
- Long-running servers go in a background terminal with their port named in the command, not a preview server that may silently reuse another agent's server.
- Durable knowledge goes in repository files, not in Claude's auto-memory. Memory is per machine and per folder, and is lost when the owner moves machines. If you keep memory notes, copy them to `docs/claude-memory/` before a machine move.
- When the session runs in the cloud, push before the session ends. The container is ephemeral.
