# Research Notes

Outside practice that shaped this seed, gathered 2026-11-01, alongside the lessons from the five earlier projects. Re-check these when the seed is revised; tools change quickly.

## 1. AGENTS.md As the Cross-Tool Entry Point

- AGENTS.md is the de facto cross-tool instructions file. Codex, Cursor, Copilot and others read it; Claude Code reads `CLAUDE.md`, which can import it with `@AGENTS.md`. Sources report tens of thousands of public repos using it.
- Repeated advice: give **specific commands** ("Use pnpm, not npm" beats "we prefer pnpm"), and skip generic advice like "write clean code", because it changes nothing. Keep it **short**: guides cite under 150–200 lines, and adherence drops beyond that. Keep it **accurate**, describing actual practice rather than aspiration. In a repository with several projects, use **nested files** (the nearest file wins), and **test it** by asking an agent to follow it.
- Keep one source of truth and point other tools' files at it.
- **Applied here:** `AGENTS.md` is canonical and kept under about 200 lines; `CLAUDE.md` is an import plus Claude-only notes; detail moved into skills and the playbook.

## 2. Use the Right Surface for Each Job (Claude Code)

- **Hooks and permissions enforce; prose only suggests.** A rule that can be a hook or a permission deny should be one, rather than a "never do X" line the model may miss.
- **Skills hold knowledge that loads on demand.** They live at `.claude/skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`, `argument-hint`, `disable-model-invocation`, `allowed-tools`, …). The description decides when Claude loads a skill, so put the use case first. Keep each `SKILL.md` under 500 lines, with reference material in sibling files. Skill bodies cost context only when used, unlike `CLAUDE.md`, which is always loaded.
- **Subagents isolate context:** broad searches and reviews run in a clean window and return conclusions.
- Hooks are configured in `settings.json`: event → matcher group → handlers. A `PreToolUse` command hook receives JSON on stdin (`tool_input.command`, `tool_input.file_path`) and blocks a call by exiting with code 2 (stderr becomes the reason). `SessionStart` (matchers `startup`, `resume`, `clear`, `compact`) can print context for the session. `${CLAUDE_PROJECT_DIR}` points at the project root.
- **Applied here:** `.claude/settings.json` (permissions + hooks), `.claude/hooks/` (session context, a destructive-command guard), nine skills, a reviewer subagent.

## 3. Harnesses for Long-Running Agents

Anthropic's "Effective harnesses for long-running agents" (Justin Young, 2025-11-26), via secondary write-ups:
- Agents work in discrete sessions with **no memory** between them; the harness must carry state.
- The common failure is the **one-shot trap**: trying to do too much at once, running out of context mid-change, and leaving undocumented broken code.
- The fix is an **initializer** session that sets up the environment, writes a feature list, a progress file and an init script, and makes the first commit. **Incremental** coding sessions follow, and each one makes progress, commits, and updates the progress file.
- The feature list was kept as **JSON** because models are less likely to casually corrupt it than Markdown. Agents could only flip the pass/fail field, never delete or rewrite tests.
- **Applied here:** `/kickoff` is the initializer, `/next` is one increment, `STATE.md` + `log.md` are the progress file, and `scripts/verify.sh` is the init-and-test script. The hard stop on weakening tests and the optional `docs/acceptance.json` (`VERIFICATION.md`) mirror the feature-list rule.

## 4. Context Engineering

- Context is finite working memory, and quality degrades as it fills. Externalize state, read narrowly, isolate sub-tasks, keep always-loaded instructions short. (Consistent across the sources above, and the main reason `STATE.md` must stay navigable.)

## Sources

- [AGENTS.md guide (Tembo)](https://www.tembo.io/blog/agents-md)
- [AGENTS.md complete guide for engineering teams in 2026 (BuildBetter)](https://blog.buildbetter.ai/agents-md-complete-guide-for-engineering-teams-in-2026/)
- [How to write a good AGENTS.md (Plannotator)](https://docs.plannotator.ai/learn/ai-development/how-to-write-a-good-agents-md)
- [CLAUDE.md and AGENTS.md best practices (mac.install.guide)](https://mac.install.guide/ai/agent-instructions/best-practices)
- [AGENTS.md standard research notes (Ry Walker)](https://rywalker.com/research/agents-md-standard)
- [Claude Code docs: skills](https://code.claude.com/docs/en/skills)
- [Claude Code docs: hooks](https://code.claude.com/docs/en/hooks)
- [Claude Code advanced best practices (SmartScope)](https://smartscope.blog/en/generative-ai/claude/claude-code-best-practices-advanced-2026/)
- [The ultimate guide to configuring Claude Code (Developer in the Loop)](https://developerintheloop.substack.com/p/the-ultimate-guide-to-configuring)
- [Effective harnesses for long-running agents (mirror)](https://ericfode.github.io/agent-harness-wiki/raw/articles/anthropic-effective-harnesses)
- [Anthropic harness design for reliable AI agents (Creole Studios)](https://www.creolestudios.com/anthropic-harness-design-for-reliable-ai-agents/)
