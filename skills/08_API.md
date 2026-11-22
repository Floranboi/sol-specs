# 08 — API

**Purpose:** Define the API knowledge available before routes are implemented.

**Confidence note:** low. `sol-api/AGENTS.md` only states that the API bridges Supabase/Postgres and web/Android; no routes or source exist.

## Existing response envelope

Not implemented or documented in the workspace; do not assume JSON shape or status conventions until route code exists.

## Route inventory

No routes can be verified. Google Sign-In is a stated requirement in `sol-specs/business-logic-v1.0.md`, but provider setup and callback endpoints are unspecified.

## Adding an endpoint

1. Record auth and permission requirements before implementation.
2. Define the UUID-native payload and strip server-private `id` fields.
3. Remove all client-supplied attribution actors; obtain them from the session.
4. Apply soft-delete and scoped-read rules.
5. Add lockstep table, migration, validator, test, and API inventories; see 04.
6. Document the response envelope and exact errors once the implementation establishes it.

## Existing validators

Unknown; no implementation or schema exists.

## Versioning and common mistakes

- Do not add sync fields in URLs; sync by UUID and timestamps.
- Do not return the server surrogate `id` for relationship identity.
- Do not require a parent foreign-key row in the response when partial clients may lack it.
- Do not let a missing schema migration make old clients or pulled rows fail silently.
