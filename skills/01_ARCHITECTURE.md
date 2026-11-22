# 01 — Architecture

**Purpose:** Read this first to understand the intended ecosystem model and boundaries.

**Confidence note:** verified against `AGENTS.md`, component instructions, specifications, and `db-design-choices.md` on 2026-11-23. No implementation source was present.

## Model

SOL is a four-repository ecosystem: a web front end, an Android app, a Supabase/Postgres-facing API, and specifications. The web and Android clients are expected to share an offline-first data model; the API is the central communication and synchronization boundary.

## Components

| Component | Owns | Evidence |
|---|---|---|
| `sol-web/` | Regulatory-compliance front end | `sol-web/AGENTS.md` |
| `sol-android/` | Android client | `sol-android/AGENTS.md` |
| `sol-api/` | Communication between Supabase/Postgres and clients | `sol-api/AGENTS.md` |
| `sol-specs/` | Product logic and cross-repository process rules | `sol-specs/AGENTS.md`, `business-logic-v1.0.md`, `git-guidelines.md` |

## Data flow

1. A client creates a UUID-native row locally.
2. The client records edits in `updated_at` and tracks cleanliness with `synchronized_at`.
3. The API pushes or pulls scoped rows. Attribution actors are server-stamped.
4. The server applies last-write-wins, tombstones deletions, and returns scoped data.
5. Both clients tolerate out-of-order sync and partial parent datasets.

## Hard boundaries

- Clients never own or send server surrogate `id` values: see `db-design-choices.md` §2.
- Clients send actor and ownership fields only through the server session allowlist: §4.
- Normal reads exclude `archived_at IS NOT NULL` rows; pull must include tombstones: §5.
- Dirty client rows are not overwritten by pull: §6.
- Schema migrations are server-first, additive, idempotent, and backfilled: §9.

## Decision records

### Decision: UUID-native offline-first model (2026-11-23, repository authors)
**Status:** accepted
**Context:** clients create rows offline and sync in arbitrary order. Choice: UUID identity and `*_uuid` relationships. Alternatives: server numeric ids or declared foreign keys. Consequences: client-side conflicts and server orphans require explicit sync gates and indexes.

### Decision: Separate development gates (2026-11-23, repository authors)
**Status:** accepted
**Context:** independent testing requires a controlled release chain. Choice: `main` → `beta` → `release` → production. Alternatives: direct deployment or ungoverned tags. Consequences: an exact approved candidate must be deployed and corrections must be carried upstream.

## Debt register

1. Product code name, short code, team, platform, stack, and userbase remain placeholders.
2. Repository implementations and tests are absent.
3. Supabase route and schema inventories cannot yet be verified.
