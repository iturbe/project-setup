# Example: Timeline Writer

*A local studio app (Python, uv, a web UI and an MCP server) for alternate-history worlds kept as Markdown records. The author decides canon in the app; models and agents propose. Aztlan is its first world (see [aztlan.md](aztlan.md)).*

**What it contributed:** `AGENTS.md` as the cross-tool entry point (with `CLAUDE.md` as `@AGENTS.md`), `log.md`, three interlocking loops, and a definition of done per slice. Also parallel agents in git worktrees, rules that never bend (keys, real data), a security check before every push, cost estimates with a monthly cap, and principles with ids.

## The Entry Point

> # For any agent picking up this repository
> […] This file is the entry point: read it, and you can continue the work with no chat history.
>
> ## Read first, in this order
> 1. **log.md:** the last ten lines show what was done most recently and what is still missing.
> 2. **ROADMAP.md and MILESTONES.md:** where this is going and which milestone is current.
> […]
> 6. **OPEN_QUESTIONS.md:** the author's answers so far; do not ask them again.

## Rules That Never Bend

> - **Only the author makes canon.** Stage drafts; never commit a record, edit canon or apply decisions in the real vault without the author's go.
> - **Never read, print or write a key.** Keys live in `.env` (ignored by git). Check whether one is set by name only. If the author pastes a key in chat, do not use it: tell them to revoke it.
> - **Never test against the real vault.** Use a throwaway copy: `rsync -a --exclude .git vault/ <tmp>/` then `git init`, and run the app with `TIMELINE_VAULT=<tmp> TIMELINE_PORT=8788 TIMELINE_OFFLINE_PROVIDER=1`.
> - **Build in your own git worktree, never in the main checkout.**
> - **Code names no world.** World specifics live in the vault's `world.yml`.
> - **Before any push,** run the security check, and stop on a finding.

## log.md: One Line Per Update

> - 2026-10-31 · dd3c130 · GEN-09/GEN-10: prices, per-run cost, monthly cap ($80), estimate in Generate, spending in Status; interrupted runs recovered with Run again · real costs unverified until a real run

Date · what changed · **what is still missing**. The last part is what makes it useful to the next session.

## Definition of Done (Every Slice)

> - [ ] Acceptance criteria met and demonstrated.
> - [ ] Tests added; the full suite passes; nothing is flaky across 3 runs.
> - [ ] UI checked on a throwaway vault, at desktop and phone widths; no console errors.
> - [ ] No change to the real vault, except where the slice is about it, and then shown to the author first.
> - [ ] Docs updated: README if the behaviour changed, ARCHITECTURE if the structure changed, REQUIREMENTS status.
> - [ ] A line appended to `log.md` […] all in the same commit.
> - [ ] Lessons learned updated if anything surprised us.

## Principles with Ids

> - **P1 Only the author makes canon.** Models and agents stage and propose; commits come from a person […].
> - **P2 The app stands alone.** Everything is doable without a Claude session; Claude is a faster way, not the only way.
> - **P3 Plain files, versioned.** […]
> - **P4 Provenance everywhere.** Every generated text, image, voice or clip records who or what made it […].
> - **P5 Keys never leave their place.**
> - **P6 Swappable providers.** No vendor SDK outside `server/providers/`.
> - **P7 World-agnostic code.**

Requirements then carry ids (`CAN-08`, `GEN-09`), a priority (Must/Should/Could) and a status (✅ 🟡 ⬜), so the log and the plan can refer to them.

## Open Questions That Say What They Change

> **Q4. What monthly budget for model and media APIs?**
> For example under $20, $20–100, or more. This sets the default models and efforts, the paid-render gate, the monthly cap, and whether batch generation (half price) comes early.

Template: `docs/OPEN_QUESTIONS.md`.

## Lessons As a Table

> | 2026-10-31 | A commit went in with a failing test | The commit was chained after `pytest \| tail`, and `tail` always succeeds | Gate commits on pytest's own exit code (`uv run pytest -q && git commit ...`), never on a pipe |

And process lessons:

> **A goal that needs the author cannot be finished by an agent.** A stop condition that included "run a real model" and "push" looped while the agent waited on a key and an approval. Write goals the agent can reach on its own, and list the author's steps separately.

## "Manual Steps Still Left (Make This List Shorter)"

> - Answering decisions given in words still needs the records edited by hand or by Claude (→ DEC-06).
> - Backing up the vault (→ OPS-01).

Each milestone retires a manual step. Generalized in `docs/playbook/LOOP_ENGINEERING.md` §7.
