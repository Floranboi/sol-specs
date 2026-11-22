# 11 — Testing

**Purpose:** Record the confidence strategy that should cover offline sync and stage gates.

**Confidence note:** low for executable coverage: no test files or runners exist on 2026-11-23.

## Required tests

- Fresh install and upgrade from every supported SQLite schema version.
- Push, pull, dirty, clean, tombstone, orphan, and same-second timestamp cases.
- Concurrent edits with strict newer-wins and delete tie precedence.
- Client-supplied actor/`id` fields rejected or stripped.
- Partial-dataset pulls and unknown parent rows.
- Enum and check drift across Postgres, SQLite, and UI.
- Soft-delete uniqueness and live-row reads.
- Migration backfills and legacy-column compatibility.
- Authentication and scoped authorization, once endpoints exist.

## Dimensions that break sync

- Clock skew.
- Intermittent network.
- Child-before-parent pull.
- Partial user scope.
- Old client and new server versions running together.
- Real-data table rebuilds.

## Manual drills

Test on two offline clients, edit the same row, push in different orders, delete with a same-second edit, archive/reopen, then verify the server and both clients converge.

## Mocking

Mock network and clock boundaries only; do not mock away the actual UUID, timestamp, dirty, and tombstone invariants. Record actual SQLite and Postgres behavior in integration tests.
