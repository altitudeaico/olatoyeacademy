-- Olatoye Academy Corpus — Supabase schema
-- For when the corpus graduates from a Claude Project to a standalone, multi-user app.
-- Design: frontmatter -> columns, file body -> `content` (embedded for semantic search).
--
-- NOTE ON EMBEDDING DIMENSION:
--   vector(768) matches Google's text-embedding-004/005 and Gemini embedding (the cheap/free
--   recommended embedder). If you switch embedder, change 768 to match its output dimension.

-- 1. Enable vector search
create extension if not exists vector;

-- 2. Scholars / lenses
create table if not exists scholars (
  id                text primary key,          -- e.g. 'dweck-growth-mindset'
  name              text not null,
  domain            text not null,
  type              text not null,             -- empirical | philosophy | framework | resource
  evidence_strength text not null,             -- strong | moderate | contested | weak | mythical | n/a
  era               text,
  frameworks        text[] default '{}',
  key_works         text[] default '{}',
  applies_to        text[] default '{}',       -- {'elsie','emma'}
  tags              text[] default '{}',
  content           text not null,             -- the full markdown body (what gets embedded)
  embedding         vector(768),
  updated_at        timestamptz default now()
);

create index if not exists scholars_domain_idx   on scholars (domain);
create index if not exists scholars_strength_idx  on scholars (evidence_strength);
create index if not exists scholars_tags_idx      on scholars using gin (tags);
-- Approximate-nearest-neighbour index for semantic search:
create index if not exists scholars_embedding_idx on scholars
  using ivfflat (embedding vector_cosine_ops) with (lists = 100);

-- 3. Decision log (the governance record)
create table if not exists decisions (
  id                 text primary key,         -- 'YYYY-MM-slug'
  decision_date      date not null,
  decision           text not null,            -- one-line summary
  status             text not null default 'proposed',
  pillars            text[] default '{}',
  children           text[] default '{}',
  scholars_consulted text[] default '{}',
  body               text,                     -- the full pressure-test write-up
  embedding          vector(768),
  review_date        date,
  created_at         timestamptz default now()
);

create index if not exists decisions_status_idx    on decisions (status);
create index if not exists decisions_embedding_idx on decisions
  using ivfflat (embedding vector_cosine_ops) with (lists = 100);

-- 4. Semantic search over scholars.
--    Pass a query embedding (same 768-dim model) and get the closest lenses back.
create or replace function match_scholars (
  query_embedding vector(768),
  match_count int default 5,
  filter_strength text default null            -- optional: only 'strong', etc.
)
returns table (
  id text, name text, domain text, evidence_strength text,
  content text, similarity float
)
language sql stable as $$
  select s.id, s.name, s.domain, s.evidence_strength, s.content,
         1 - (s.embedding <=> query_embedding) as similarity
  from scholars s
  where filter_strength is null or s.evidence_strength = filter_strength
  order by s.embedding <=> query_embedding
  limit match_count;
$$;

-- 5. Row-level security (enable before exposing publicly; add policies for your users/tutors).
-- alter table scholars  enable row level security;
-- alter table decisions enable row level security;

-- --- Ingestion sketch (run outside SQL, in your app/script) ---
-- for each scholars/*.md:
--   parse YAML frontmatter -> columns; take body -> content
--   embedding = embed(content)  [Google text-embedding-005 ~ $0.006 / 1M tokens]
--   upsert into scholars
-- Query flow:
--   q_emb = embed(user_question)
--   rows  = match_scholars(q_emb, 4)
--   answer = LLM(system="you are the Olatoye control...", context=rows, question=user_question)
