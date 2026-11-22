# 09 — Security

**Purpose:** Protect identity, attribution, privacy, and sync boundaries.

**Confidence note:** verified only for explicitly stated requirements and database actor rules on 2026-11-23.

## Threat model

- Forged ownership or attribution.
- Offline clients creating conflicting or unauthorized rows.
- Exposed server IDs enabling enumeration.
- Data leakage through sync outside a user's scope.
- Location/profiling, resale, or excessive per-user trails.
- SQL/schema drift across old and new clients.

## Authentication

Google Sign-In is required by `sol-specs/business-logic-v1.0.md`. Provider configuration, session format, and refresh behavior are unimplemented and must not be assumed.

## Authorization layers

1. User/client scope is enforced on pull and push.
2. Server stamps `created_by` and action actors from the authenticated session.
3. Client payload allowlists exclude server-stamped actor fields and server `id` values.
4. UI access levels are specified only as placeholders; concrete role matrices are missing.

## Secrets and privacy

No secret values or environment variables are documented. Add names only, never values. Privacy requirements include Data Privacy Act compliance, location protection, retention limits, no per-user trails, aggregation thresholds, and consent for resale.

## Change checklist

- Does the endpoint enforce session identity rather than trusting the payload?
- Can the caller retrieve or mutate only scoped rows?
- Are actor fields excluded from client writes?
- Is no sensitive payload or secret written to logs?
- Are soft-delete and pull scopes preserved?
- Are old clients compatible with additive schema changes?
