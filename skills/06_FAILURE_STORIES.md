# 06 — Failure Stories

**Purpose:** Reconstruct incidents behind the guardrails only after evidence exists.

**Confidence note:** no commits or incident records exist in the workspace. The following are failure modes implied by the database design, not confirmed incidents.

## 1. Silent sync loss — plausible reconstruction, low confidence

**What happened:** a local mutation changes data but leaves `updated_at` or `synchronized_at` inconsistent.
**Why:** sync cleanliness depends on the exact distinction documented in `db-design-choices.md` §6.
**How found:** row remains dirty or clean despite server mismatch; requires runtime logs to confirm.
**Fix:** bump `updated_at` on every local mutation and let sync exclusively maintain `synchronized_at`; add a dirty-versus-server diagnostic.
**Lesson:** see 04 #2 and 05 “Row never syncs.”

## 2. Delete resurrection — plausible reconstruction, low confidence

**What happened:** a tombstoned row may reappear if deletion is physical or conflict precedence is wrong.
**Why:** sync has no queue; tombstones are the only durable delete signal.
**Fix:** set and push `archived_at`, gate live reads, and let deletes win same-second ties.
**Lesson:** see 04 #4 and 05 “Deleted row reappears.”

## 3. Wrong attribution — plausible reconstruction, low confidence

**What happened:** a client supplies `created_by` or an actor column and claims another account's action.
**Why:** actor fields are security decisions, not ordinary editable data.
**Fix:** server stamps actors from the authenticated session and excludes them from push payload allowlists.
**Lesson:** see 09 authorization checklist.
