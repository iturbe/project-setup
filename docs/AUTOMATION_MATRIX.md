# Automation matrix

For each kind of task: does the agent do it alone, alone with a read-back or human check, or does the owner do it from a checklist? Written in M0, approved by the owner, and kept current.

**Rules**
- A tool call that fails twice with the same error marks that tool **unreliable** for that task. Record it here and route around it.
- Re-list a beta tool's capabilities at the start of each session. Tool names change between releases; if they did, update this file before relying on it.
- Every "agent + check" row names the check (read-back, screenshot, test id, owner glance).

**Verdicts:** `agent` alone · `agent + check` · `owner` from a checklist · `unknown` (spike it).

| Task | Verdict | Tool or route | Check | Notes |
|---|---|---|---|---|
| Edit source code | agent | file tools | L0–L2 | |
| Build or compile | agent | `scripts/verify.sh` | exit code | |
| Run unit tests | agent | `scripts/verify.sh` | exit code | |
| Run on the target device or session | {{…}} | {{…}} | {{…}} | |
| Read logs | {{…}} | {{…}} | | |
| Change project or editor settings | owner | checklist | read back after | |
| Place or configure content in an editor | {{…}} | {{…}} | read back + screenshot | |
| Deploy to staging or a private build | {{…}} | {{…}} | {{…}} | |
| Publish, release, submit | owner | checklist | | Always the owner's |
| Paid API calls | agent + check | {{…}} | cost estimate shown first | within the monthly cap |
| Judge feel, look, fun | owner | queue item | | |

## Tool inventory

{{List the tools the agent actually has on this project (CLIs, MCP servers, connectors), with versions and the date listed.}}
