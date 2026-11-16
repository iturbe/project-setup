# Project-Setup

A seed repository for starting any new project with an AI coding agent doing most of the building. Clone it, run `/kickoff`, and the agent interviews you, fills in the templates, and starts the first milestone. From then on, any session can pick up where the last one stopped, without the chat history.

It distils what worked (and what went wrong) across five projects: two Fortnite islands built in UEFN, a Python studio app, a SwiftUI iOS game, and a content vault. Outside research on agent instruction files, Claude Code skills and hooks, and long-running agent harnesses filled the gaps.

## Start a New Project

```bash
gh repo create my-idea --private --template iturbe/project-setup --clone
```

```bash
cd my-idea && scripts/init.sh "My Idea"
```

Then open Claude Code in the folder and run:

```
/kickoff a one-line description of the idea
```

`gh repo create --template` needs this repository marked as a template (Settings → General → Template repository). Without that, clone it and push it to a new repo instead.

## What Is Inside

| Path | What it is |
|---|---|
| `AGENTS.md` | **The rules for any agent** (Claude Code, Codex, Cursor…): session ritual, loop protocol, verifier ladder, autonomy policy, hard stops, rules that never bend. Kept under ~200 lines |
| `CLAUDE.md` | Imports `AGENTS.md`, plus Claude Code specifics: skills, hooks, subagents |
| `STATE.md` | The running log: **Resume Here**, the current milestone, one entry per deliverable, decisions, dead ends |
| `ROADMAP.md` | Milestones with deliverables, exit criteria, and automated + human verification. M0 (toolchain and walking skeleton) and M1 (spikes) are prewritten |
| `LESSONS_LEARNED.md` | Mistakes as rules. Comes with about 40 inherited lessons from the earlier projects |
| `log.md` | One line per major update: date · what changed · what is still missing |
| `docs/` | Project spec, owner profile, human queue or iteration plan, open questions, platform constraints, automation matrix, environment, ideas |
| `docs/playbook/` | How the work is done: loops, verification, the human loop, architecture patterns, docs discipline, parallel agents, security, model costs, research notes |
| `docs/examples/` | Attributed excerpts from Battle Drill, Shockwave Playground, Timeline Writer, Tesseract and Aztlan |
| `.claude/skills/` | `/kickoff`, `/start`, `/next`, `/spike`, `/queue`, `/iteration-plan`, `/lesson`, `/handoff`, `/security-check`, `/style-review`, `/add-elevenlabs` |
| `.agent-style/` | The 21 writing rules from [agent-style](https://github.com/yzhao062/agent-style) v0.9.0 (CC BY 4.0), loaded through the block at the end of `AGENTS.md`, and the `/style-review` references |
| `.claude/agents/reviewer.md` | A skeptical subagent that checks "done" claims against evidence |
| `.claude/settings.json` + `hooks/` | Pre-approved safe commands; a session-start hook that prints **Resume Here**; guards that block force-push, `reset --hard`, `stash`, broad `rm -rf`, and reading `.env` |
| `scripts/` | `verify.sh` (the one verifier), `check_docs.sh`, `check_style.sh`, `security_check.sh`, `init.sh` |

## The Ideas in One Screen

1. **The repository is the memory.** Agents forget between sessions; files do not. A fresh session reads **Resume Here**, the lessons and the active milestone, and continues. If a hand-off would need the chat, it is not done.
2. **Loops with exits.** A milestone is a macro-loop, and a deliverable is a micro-loop: define done → research → smallest change → verify → record. Each deliverable gets 5 attempts, and work stops after the same failure 3 times in a row.
3. **Only the verifier says "done".** `scripts/verify.sh` (lint → build → tests) is the source of truth. Without it, the best status is "done, pending human check". Weakening a test to pass is a hard stop.
4. **A pure core makes it testable.** Logic lives in plain code with no UI or platform dependency, so tests run without a human. For targets the agent cannot drive, an in-situ harness prints `AUTOTEST: PASS/FAIL` lines it can read.
5. **The owner's time is the scarcest resource.** Everything that needs them is batched, with exact steps, a matching checklist, the build number, and a recommended answer first. Two modes: an async **queue** (never wait) or **iterations** (one hand-off document per batch).
6. **Mistakes are made once.** Every non-obvious failure becomes a dated rule in `LESSONS_LEARNED.md`, read every session.
7. **Enforce with hooks, not prose.** Destructive commands and secret files are blocked mechanically; the docs explain why.
8. **Write for a reader who was not there.** Every document follows the agent-style rules: title-case headings, no dashes as punctuation, no contractions, short sentences, plain words, evidence for claims. `scripts/check_style.sh` counts what a machine can detect, and `/style-review` covers the rest.

## Feeding Lessons Back

When a project learns something that would help any project, copy it here:
- a lesson → `LESSONS_LEARNED.md` → **Inherited** (with the project and date);
- a better template or rule → the template file or `AGENTS.md`;
- a good excerpt → `docs/examples/<project>.md`;
- a new outside source → `docs/playbook/RESEARCH_NOTES.md`.

Keep `AGENTS.md` short. Detail belongs in the playbook and the skills, which load only when needed.

## Checking the Seed Itself

```bash
VERIFY_ALLOW_EMPTY=1 scripts/verify.sh   # docs present; placeholders are expected here
```

```bash
scripts/security_check.sh
scripts/check_style.sh                   # writing rules (warn only; needs npx and network)
```
