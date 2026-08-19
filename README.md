# Olatoye Academy — Knowledge Corpus & Control

*A queryable "board of advisors" for running Olatoye Academy. Reference the scholars we trust, ask what their approach would be, and pressure-test our decisions against the evidence — so we build on principle, not on whoever is loudest online.*

**Christ at the Centre.**

---

## What this is

A small, curated knowledge base of the thinkers and evidence behind our home education programme. Each file is one **lens** you can query. It exists to do two jobs:

1. **Ask-the-expert** — "How would Montessori set up Emma's environment for X?"
2. **Pressure-test (the control)** — "We're planning X. Run it past Dweck, Self-Determination Theory and the hothousing research and flag where they'd push back."

The whole point is governance: a defensible, versioned record of *how our thinking is formed and tested*, not just what we decided.

---

## How it's organised

```
olatoye-corpus/
├── README.md            ← you are here
├── INDEX.md             ← every lens, grouped by domain, with evidence strength
├── scholars/            ← one markdown file per scholar/lens (the core asset)
├── evidence/            ← the condensed evidence baseline (the synthesis)
├── decisions/           ← the decision log: where pressure-tests get recorded
├── resources/           ← practical resource lists (e.g. Yoruba/Nigerian)
└── schema/              ← Supabase SQL, for when this becomes an app
```

## The file schema (why it's built this way)

Every scholar file has **YAML frontmatter** (machine-readable — this maps straight to database columns for an app) followed by a **structured body** (human- and RAG-readable). The same file therefore works, unchanged, as:

- **Claude Project knowledge** (drop the folder in; retrieval is automatic and doesn't count against usage limits), and
- **rows in a Supabase table** (frontmatter → columns, body → the embedded/searchable content).

Frontmatter fields: `id`, `name`, `domain`, `type`, `evidence_strength`, `era`, `frameworks`, `key_works`, `applies_to`, `tags`.

Body sections: Core idea · What they teach · What they'd endorse · What they'd caution against · Evidence strength (read honestly) · For Elsie · For Emma · Pressure-test prompts · Key works.

## The evidence-strength key (the control mechanism)

This is what stops us leaning on a shaky idea as if it were a pillar. Every lens is graded:

| Grade | Meaning | Use it as… |
|---|---|---|
| **STRONG** | Well-replicated | A load-bearing pillar |
| **MODERATE** | Good but qualified | A solid input, with caveats |
| **CONTESTED** | Real but oversold / debated | Light framing only — never a pillar |
| **WEAK** | Thin or confounded evidence | Hold very loosely |
| **MYTH** | Popular but unsupported | Do not build on it |
| **FRAMEWORK / PHILOSOPHY** | Not an empirical claim | A lens for thinking, not proof |

The honest headline of the whole corpus: the biggest evidenced risk in this programme is not *too little academics* but *too much pressure*. Protect warmth, play and the girls' own motivation above all.

---

## How to use it

### As a Claude Project (recommended first, ~zero cost)
1. Create a Project, add this whole folder to its knowledge.
2. Put a short instruction in the Project: *"You are the Olatoye Academy control. Answer using the scholar lenses. Always state each lens's evidence strength, and flag where a shaky idea is being treated as a pillar."*
3. Query it: ask-the-expert, or paste a plan and say "pressure-test this."

### As a standalone app (later, if Funmi/tutors need access)
Use `schema/supabase.sql` to stand up the tables, embed each file's body, and query by vector similarity. Keep GitHub as the source of truth; sync to Supabase on change.

---

## Maintaining it (it's a living control)

- **GitHub is the source of truth.** Every change to our thinking is a tracked, diffable commit — that history *is* the governance record.
- When we pressure-test a real decision, save it in `decisions/` using the template. Over time this becomes the story of how the Academy reasons.
- Add or revise a lens whenever we adopt a new thinker or the evidence moves.

*Companion documents: the full Olatoye Academy Prospectus and the full Evidence Baseline (Word documents) sit alongside this corpus.*
