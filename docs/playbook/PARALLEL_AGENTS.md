# Parallel agents: one worktree each

From Timeline Writer, after two agents in one checkout overwrote each other's uncommitted work (2026-10-31).

More than one agent can build at once. Each works in its own **git worktree**: a second checkout of the same repository, on its own branch, with its own files. Edits in one never touch another's uncommitted work.

| Where | What runs there |
|---|---|
| The main checkout (`main`) | The owner's running app and real data. Merges land here. No agent edits code here |
| `../worktrees/<branch>/` (one per slice) | One agent's slice: code, tests, docs, and a test app on a throwaway copy of the data |

## Start a slice

```bash
git worktree list                                   # who else is working, and on what
git worktree add -b <branch> ../worktrees/<branch> HEAD
cd ../worktrees/<branch>                            # then install dependencies
```

- The branch starts from the last commit. Another agent's uncommitted edits are not in it, by design.
- Branch names are short kebab-case after the slice (`canon-actions`).

## While working

- **No real data in a worktree.** Run the test app on a throwaway copy (`rsync -a --exclude .git <main>/data/ <tmp>/data-copy/`, then `git init` and a first commit), on its own port.
- **Ports:** if your test port is taken, another agent is testing. Use the next free one, and check the page shows *your* copy, not the real app.
- **Never `git stash`.** The stash stack is shared by every worktree, so a pop can take another agent's changes. Set work aside with a temporary commit on your branch.
- Commit on your branch, with the docs and the `log.md` line. Don't push it.

## Merge, on the owner's word only

1. Wait for the main checkout to be clean (`git -C <main> status --short` shows nothing). If another agent has uncommitted work there, it commits first.
2. `git -C <main> merge --no-ff <branch>`. Conflicts usually land in `log.md` and the planning docs: keep both sides' lines, in date order.
3. Run `scripts/verify.sh` in the main checkout after the merge.
4. Clean up: `git worktree remove ../worktrees/<branch>`, then `git branch -d <branch>`.
5. Restart the owner's app if it runs from the main checkout, so they see the merged code.
6. Push only after `scripts/security_check.sh`.

## Cloud sessions and subagents

- A cloud session has its own container and clone, so it is already isolated. It pushes to its own branch; merging is still the owner's call.
- Claude Code subagents can run with `isolation: "worktree"` to get the same protection automatically.
- Two sessions sharing one simulator, device or port will fail at launch, not in the tests (Tesseract). Rerun alone before debugging.
