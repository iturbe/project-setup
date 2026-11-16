# {{PROJECT_NAME}}: Project Spec

The authoritative description of what this is and how it is built. **Update it in the same micro-loop as any change to behavior or architecture.** If the code and this file disagree, one of them is a bug.

## 1. What it is

{{Two or three paragraphs: the product, the user, the core loop or core job, and what the current version must prove.}}

**Out of scope for now:** {{what this deliberately does not do yet, so nobody builds it by accident}}.

## 2. Design Invariants

Rules that hold for every feature. Each one says why. Changing one is the owner's decision, logged in `STATE.md`. Mirror the short form in `AGENTS.md` → Project-specific rules.

| Invariant | Why |
|---|---|
| {{e.g. "Failing costs seconds, not minutes"}} | {{e.g. "short retry loops keep players learning"}} |

## 3. Architecture

```
            ┌────────────── adapters (thin) ──────────────┐
 world  ──► │ UI · devices · network · files · providers  │ ──► effects
 events     └──────────────┬───────────────▲──────────────┘
                           │ plain values  │ plain values
                    ┌──────▼───────────────┴──────┐
                    │ core logic (pure, tested)    │
                    └──────────────────────────────┘
```

- **Core:** {{module or folder}}. It takes plain values in and returns plain values, with no imports from the UI or platform.
- **Adapters:** {{modules}}. Translate only. No rules in here.
- **Providers:** {{external services}}, each behind one interface in {{folder}}. No vendor SDK outside that folder.
- **Persistence:** {{where state lives; whether plain files are the source of truth}}.
- **Tunables:** {{file}}. Every number that shapes behavior lives here.
- **User-facing text:** {{file or table}}, referenced by id.
- **Build version:** `BuildVersion` in {{file}}, shown {{where}}.

## 4. Layout

| Path | What |
|---|---|
| {{path}} | {{what}} |

## 5. Commands

```bash
scripts/verify.sh          # the verifier: build + tests (L0–L2)
{{run command}}            # run locally
{{single test command}}    # one test
```

## 6. Test IDs

Stable, unique, prefixed by area (`CORE01-…`, `UI03-…`). The list lives here or in the test files; `STATE.md` entries name the IDs that define done.

| Prefix | Area |
|---|---|
| {{CORE}} | {{core rules}} |

## 7. Known Gaps

{{What is missing or wrong today, with the deliverable that fixes it.}}
