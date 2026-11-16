# Example: the Aztlan Vault

*The content repository behind Timeline Writer: an alternate history in which Japanese explorers, not the Spanish, reach the Aztec Empire in the 1550s. It is data, not code: hundreds of Markdown records with YAML frontmatter, plus decisions, generation runs and voice-casting tests, all versioned with git and backed up to a private repo.*

**What it contributed:** the shape of an agent-friendly content store. It has one file per atomic record, stable ids, a stage → commit flow, and Established vs Proposed. Decisions are files that become rulings, world specifics live in a manifest, and every generation records where it came from.

## Layout

```
canon/          committed records (only the author commits)
drafts/         staged records, canon_status: draft
retired/        records taken out of the story; ids never reused
decisions/      dec-NNNN: questions with options, answers, rulings
generations/    gen-NNNN: one file per model run, with every setting and its cost
casting/        ct-NNNN: voice tests with the author's feedback, word for word
world.yml       name, premise, naming rules, style: what code must not hard-code
eras.yml        the eras, with date ranges
naming.yml      retired and replaced names, checked by a lint
world_bible.md  a short summary rebuilt from the vault, loaded by every session
```

## A Canon Record

> ```yaml
> canon_status: canon
> era: Contact
> id: char-0006
> in_universe_date: c. 1557
> related: [evt-0001]
> source: chatgpt_export
> title: Oda Nobukata
> type: character
> voice: {provider: elevenlabs, name: "Charlie - Deep, Confident, Energetic", voice_id: …}
> ```
> **Established**
> - The divergence turns on him: instead of killing him, Oda Nobunaga sends Nobukata abroad to search the world for better war technology.
> - It is dated **c. 1557** […] (dec-0002).

**Established** holds what the author stated; **Proposed** holds what a model made up. That separation made every later step safe.

## A Decision

> ```yaml
> id: dec-0100
> status: open
> group: I
> title: Who is kidnapped, who loves whom, who dies (Gemini)
> options:
> - {key: keep-ruling, label: Keep my ruling, detail: Nothing changes in the records.}
> - {key: change, label: Change it, detail: Say in your answer what to change; the records are edited to match.}
> records: [char-0007, char-0008, char-0009]
> source: {kind: ruling-review, record: con-0757, ruling: dec-0020}
> ```

Answered and applied decisions become **standing rulings**, listed in the world bible and respected by every later generation: "dec-0002 Date of first contact: First contact anchored at c. 1557 […]".

## The World Manifest

> ```yaml
> # The world this vault holds. Code and shipped presets never name a world:
> # they read it from here, so other alternate histories can live in vaults of
> # their own.
> name: Aztlan
> premise: >-
>   In the 1550s Japanese explorers, not the Spanish, reach the Aztec Empire […]
> naming: >-
>   Names follow the world's naming rules: Nahuatl and other Native American
>   names, Japanese where the fusion calls for it, never Spanish. […]
> ```

## Recording Where a Generation Run Came From

> ```yaml
> id: gen-0001
> kind: character
> brief: A scholar at a temple-university in Tenochtitlán in the 1620s who catalogues Japanese and Nahuatl books side by side
> provider: anthropic
> model: claude-haiku-5-5
> effort: low
> preset: worldbuilder
> context_scope: canon+drafts
> estimate_usd: 0.003788
> cost_usd: 0.005458
> served_by: claude-haiku-5-5
> stop_reason: end_turn
> ```

Estimate and real cost side by side: the first real run is how estimates get calibrated.

## Feedback Recorded Verbatim

> ```yaml
> - label: George · multilingual v2 · respelled
>   feedback: terrible. good pronounciation but the pace is dramatically slowed down for each native word, so it feels off
> - label: George · v3 · names as spelled
>   feedback: step change improvement. only a few words sound like being spoken with a thick accent
> ```

The owner's own words, kept next to each clip, drove the next decision (respellings off by default).

## Its .gitignore

> ```
> # Keys never belong in a vault.
> .env
> .env.*
> ```

Added after the security check caught the vault had none, before its first push.
