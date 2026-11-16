# Platform Constraints

What the platform, SDKs and external APIs can and cannot do, **as proven on this project**. Read it before touching platform code. Move items from *Unverified* to *Verified* or *Dead ends* as you test them, with the date and the evidence.

Why this file exists: documentation and memory are often wrong for fast-moving platforms. In Battle Drill, "verse tags cannot be assigned through the editor tools" was believed for two days until a spike proved otherwise. In Shockwave Playground, "physics is on" was true in the settings UI and false in the level. Only an experiment on this machine settles a question.

## Verified Here

| ID | Fact | How it was verified | Date | Version |
|---|---|---|---|---|
| V01 | {{fact}} | {{the experiment or test id}} | {{date}} | {{platform version}} |

## Unverified (Hypotheses Until a Spike Proves Them)

| ID | Claim | Source | Spike that would settle it |
|---|---|---|---|
| U01 | {{claim}} | {{docs, forum, memory}} | {{S-number in ROADMAP}} |

## Dead ends (do not retry)

| ID | What was tried | Result | Nearest alternative | Date |
|---|---|---|---|---|
| D01 | {{approach}} | {{exact error or behavior}} | {{workaround}} | {{date}} |

## Limits and Numbers

Quotas, rate limits, sizes, prices, timing. Each with a date checked and a source.

| What | Value | Source | Checked |
|---|---|---|---|
| {{e.g. API rate limit}} | {{value}} | {{link}} | {{date}} |
