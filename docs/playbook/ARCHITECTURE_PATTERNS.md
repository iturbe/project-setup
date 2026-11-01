# Architecture patterns

Patterns that made the earlier projects testable by an agent and safe to change. Each one says where it came from.

## 1. Pure core, thin adapters (all five projects)

All core logic lives in plain code with no dependency on the UI, devices, network or world. Plain values in (ids, times, positions, booleans, amounts), plain values out. Adapters translate real events into core calls, and core outputs into effects, and contain no rules.

- **Tesseract:** all game logic in Swift value types under `Models/` with no SwiftUI imports; observation only at the view-model layer.
- **Battle Drill, Shockwave:** maneuver detection, scoring, round state and timers in plain Verse classes; devices are adapters. AutoTest feeds the core synthetic events, because no input can be sent to the game client.
- **Timeline Writer:** `store.py` handles records and decisions, with no MCP or web code; the MCP server and web app are both adapters over it.

Why: it is the only way to test without a human in the loop. New logic goes in the core.

## 2. One place for every tunable (BD, SP)

Every number that shapes behavior (timers, distances, thresholds, prices) is a named constant in one file (`tunables.verse`) or a configurable field. No magic numbers inside logic. Tuning from measurements then means editing one file.

## 3. One table for user-facing text (BD)

Text players read and text a voice speaks come from one table (`instructor_lines.csv`), generated into code. Code refers to lines by id, never by string, so a missing line is a build error, not a silent typo. Regenerate after every edit; never hand-edit the generated file.

## 4. Visible build version (BD, SP, TS)

A `BuildVersion` printed at start and shown where the owner tests. Bump the patch on every change that reaches a device or session. Tesseract kept it on the home screen, always visible, during two-device bug hunting. Keep it separate from the marketing or store version.

## 5. Theme tokens, never hard-coded styles (TS)

Views read a token struct (colors, line widths, fonts, decoration) from a theme engine. A new look means a new token set, not edits across views.

## 6. In-world choices, not menus, where immersion matters (BD)

Battle Drill's invariant: after launch, every choice is made by acting in the world (standing on a pad, shooting a target). Built as a rectangle in a layout file plus a position check in the pure core: testable, and needs no hand-wired references. Generalized: prefer mechanisms that live in the testable core over ones that live in editor wiring.

## 7. Idempotent placement and setup scripts (BD, SP)

Level layouts and environment setup live in scripts (`tools/level/`) that can be re-run safely, keyed by a project prefix (`BD_`, `SP_`). Reviewable in git, reproducible on a new machine, and cleanable because everything the agent made carries the prefix.

## 8. Discover by tag, not by hand-wiring (BD, SP)

Connecting components by references a human has to set in an editor creates a human step for every change. Battle Drill moved to tags assigned by script and found at runtime. Generalized: configuration the agent can write and read back beats configuration only a human can click.

## 9. Plain files as the source of truth (TW, AZ)

Timeline Writer's vault is Markdown with YAML frontmatter, one file per record, versioned with git. A database, if ever added, is an index, not the source of truth. Readable by humans, diffable, survives any tool.

## 10. Stage → commit for anything generated (TW, AZ)

Models and agents **propose**; a person **commits**.
- Generated material lands in `drafts/` with a draft status; committing moves it to `canon/` in its own git commit (`git commit --only <path>`, never the whole index).
- Inside each record, keep **Established** (what the owner stated) apart from **Proposed** (what a model made up). It made every later step safe: rounds, generation context, auto-apply.
- Contradictions become **Open questions** in the record, then **decisions**, then **rulings** that every later step respects.

## 11. Provenance everywhere (TW, AZ)

Every generated text, image, voice or clip records who or what made it: provider, model, effort, system prompt, brief, context ids, cost, timestamps (`generations/gen-0001.md` in Aztlan). Any run can be reproduced from its file.

## 12. Swappable providers (TW)

No vendor SDK outside `providers/`. Each provider is one module behind a common interface, with an offline provider for tests. Swapping a model or vendor touches one file.

## 13. Generic code, specific data (TW)

Code names no world. Aztlan's name, premise, eras, naming rules and style live in the vault's `world.yml`; presets use `{world.name}` and `{world.premise}`. Generalized: the second project should not require code changes, only a new data folder.

## 14. Stable ids that are never reused (TW, AZ, BD, SP)

Records (`evt-0001`, `char-0012`), decisions (`dec-0100`), tests (`MM03-round-timeout`), queue items (`Q06`). Retired ids still count; a test guards it.

## 15. Atomic writes and a release guard

- Every file write is atomic: a temp file, then a rename (TW, after a half-written read).
- Debug flags (AutoTest, robot mode, dev panels) are off in anything published, and a release-guard check enforces it (SP: `tools/release_mode.py`, test `RG01`).
