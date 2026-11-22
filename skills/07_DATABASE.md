# 07 — Database

**Purpose:** Apply the offline-first, UUID-native persistence rules.

**Confidence note:** verified against `db-design-choices.md` on 2026-11-23. Supabase migrations and live schema are absent.

## Identity

- Server: surrogate `id bigint GENERATED ALWAYS AS IDENTITY`; never sync or expose as relationship identity.
- Client/server: `uuid` is the global identity minted by the creating client.
- Relationships: `<parent>_uuid`, normally no server foreign-key constraint.
- Client: local integer `id` is private and never serialized.

## Deletes and tombstones

Set `archived_at`, bump `updated_at`, and exclude archived rows from normal reads and aggregates. Pull tombstones and uniqueness partial indexes with `WHERE archived_at IS NULL`.

## Integrity invariants

- Every local mutation bumps `updated_at`.
- Pull never overwrites a dirty row.
- Push writes only strictly newer rows unless a delete wins a same-second tie.
- Server stamps attribution actors and excludes client values.
- Unknown parents are tolerable on pulls and require an orphan guard/retry.
- Natural-key adoption repairs duplicate UUID creation where specified.

## Table and index rules

- Mirror table/column names across server and SQLite except for private `id` and `synchronized_at`.
- Index every `*_uuid` path used in scoped pulls and every parent lookup.
- Declare real foreign keys only for online-only, ordered data, not offline sync graphs.

## Migration strategy

Server migrations run before client code. Use additive, idempotent, gated migrations and separate column removal from addition. Client migrations run on fresh installs and upgrades; they are re-entrant and additive. Backfill new change columns from `created_at`.

## Dangerous operations

- Physical deletion of live or tombstone rows.
- Mass unarchive.
- Table rebuild before a tested real-data upgrade.
- Editing snapshots or denormalized fields without finding every copy.
- Editing applied migrations instead of creating a new migration.
