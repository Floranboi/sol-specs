# 05 — Debugging Playbook

**Purpose:** Start investigations with the synchronization and release symptoms most likely to recur.

**Confidence note:** reconstruction from database and process rules on 2026-11-23. Runtime logs do not exist yet.

## Log locations

Unknown until implementations are created. As soon as deployables exist, document API request logs, sync diagnostics, Android SQLite state, web network state, and Supabase/Postgres logs. No secrets or payload values belong in logs.

## Symptom: Row never syncs

Likely causes:
1. Local edit did not bump `updated_at`.
2. `synchronized_at` was written outside sync code.
3. Timestamp format differs and `<>`/dirty gate is wrong.
4. Server push filtered out a required but unknown client column.

Shortcut: compare UUID, `updated_at`, `synchronized_at`, and archived state on client and server. If equal, verify acknowledged server insert; if dirty differs, inspect push gate.

## Symptom: Deleted row reappears

Likely causes:
1. UI used physical delete instead of tombstone.
2. Pull overwrote dirty tombstone.
3. Push tie logic did not give delete precedence.
4. Normal read leaks archived rows.

Shortcut: inspect the row's `updated_at` and `archived_at` on both sides before testing any UI action.

## Symptom: Pull overwrites newer local edit

Likely causes:
1. Pull lacks dirty-row gating.
2. Dirty check uses `>` instead of `<>`.

Shortcut: show the dirty predicate and server row version side by side.

## Symptom: Migration upgrade fails

Likely causes:
1. Migration is not re-entrant.
2. Client migration rebuilded a table instead of adding columns.
3. Migration ran after code first read the new column.
4. Backfill touched every row instead of only `NULL` values.

Useful check: test from the previous release database plus a fresh install; see `db-design-choices.md` §9.
