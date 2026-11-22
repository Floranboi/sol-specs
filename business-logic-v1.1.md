# Business Logic v1.1

> SOL is a compliance operations platform that helps an organization keep accountable records of regulatory requirements, assessments, evidence, reviews, and corrective actions across web and Android, including when a network is unavailable.

- **Allowed platforms:** Web, Android
- **Positioning:** A focused, offline-capable compliance workspace for small teams.
- **Primary outcome:** A team can know what is required, who owns it, what evidence exists, and what remains overdue or unreviewed.
- **Time-to-market constraint:** Build only the minimum workflow needed to create, review, track, and report compliance records. Defer dashboards, automations, integrations, payments, and advanced analytics.

## 1. Project Details

- **Company/Startup/Team Name:** SOL team
- **Project Code Name:** SOL
- **Project Short Code:** SOL
- **Short Description:** Offline-capable regulatory compliance tracking for distributed teams.
- **Long Description:** SOL gives authorized staff a shared, auditable workspace for compliance obligations, evidence, assessments, reviews, and corrective actions. The web and Android clients support field or remote work and synchronize through a centralized API without exposing server-side identities.

## 2. MVP Positioning

### Problem

Compliance work is often distributed across documents, spreadsheets, messages, and disconnected checklists. This makes ownership, evidence freshness, review status, and overdue actions difficult to establish.

### Target user

Small compliance teams that:

- manage repeatable regulatory obligations;
- collect evidence from distributed contributors;
- need administrator or reviewer approval; and
- need records available where connectivity is unreliable.

### Product promise

SOL provides one shared record of the obligation and its current evidence, status, owner, review decision, and due date.

### Value proposition

- **For team members:** clear assigned work and simple evidence submission.
- **For reviewers:** one place to approve, reject, or request correction.
- **For administrators:** current compliance coverage and overdue-action visibility.
- **For auditors:** traceable records with timestamps and actors.

## 3. User Levels

| Level | Role | MVP responsibility |
|---|---|---|
| A. System Administrator | System management | Manage system configuration, integrations, retention settings, and platform backups. |
| B. Administrator | Compliance owner | Manage users, requirements, control settings, periodic reports, and assignments. |
| C. Reviewer | Independent approver | Review submissions and approve, reject, or request corrections. |
| D. Contributor | Operational assignee | Complete assigned work, add evidence, and respond to review findings. |
| E. Guest | Read-only stakeholder | View only explicitly shared, non-sensitive summaries. |

## 4. MVP System Requirements

1. A user shall authenticate with Google Sign-In and receive only the role and scope assigned by an administrator.
2. An authorized user shall create, edit, archive, and restore compliance requirements.
3. An authorized user shall assign a requirement or corrective action to one or more responsible contributors.
4. A contributor shall attach evidence links or files and record a status and due date.
5. A reviewer shall approve an assessment, reject it, or request correction with a required comment.
6. A user shall view current and overdue work filtered by owner, status, requirement, and due date.
7. An administrator shall generate a concise compliance summary for periodic review.
8. A signed-in client shall create and edit assigned work offline and synchronize changes when connectivity returns.
9. A synchronized record shall preserve soft-delete tombstones, UUID identity, timestamps, and server-stamped actors.
10. The system shall enforce role-based access, retention limits, audit visibility, and privacy controls described in the security section.

## 5. Required Solution Layers

1. **Security and privacy by design:** enforce role access, Data Privacy Act controls, location protection, retention limits, no unnecessary per-user trails, aggregation thresholds, and explicit consent before any resale or secondary use.
2. **Web application:** the primary administration and review experience.
3. **Android application:** the field or mobile contribution experience.
4. **API:** authentication, authorization, scoped push/pull, validation, and server-stamped actors.
5. **Database:** Supabase/Postgres server storage and UUID-native SQLite client storage with offline sync.
6. **Operational reporting:** export or in-app summaries limited to current status, ownership, evidence coverage, and overdue items.
7. **Auditability:** preserve action actor, action time, review decision, and soft-delete state without creating per-edit surveillance.

## 6. MVP Features and Access

| # | MVP feature | Access | Completion test |
|---|---|---|---|
| 1 | Sign in and role-based session | A,B,C,D,E | A guest or unauthorized role cannot access restricted records. |
| 2 | Requirement register | A,B,C,D | Create/edit requirements and show their current status. |
| 3 | Assignments and due dates | A,B,C,D | Contributor sees only assigned work and overdue status. |
| 4 | Evidence submission | B,C,D | Contributor adds evidence and reviewer sees it in context. |
| 5 | Review workflow | A,B,C | Reviewer can approve, reject, or request correction with a comment. |
| 6 | Corrective-action tracking | A,B,C,D | Rejected or overdue work remains visible until resolved. |
| 7 | Compliance summary and export | A,B | Administrators obtain counts by status, owner, and due date. |
| 8 | Offline create/edit/sync | B,C,D | Two local changes converge; deleted records remain deleted. |

Guest access is limited to explicitly shared compliance summaries. It must not expose contributor details, internal evidence, locations, or private comments.

## 7. Core Domain Model

The MVP should use only these concepts:

- **Account:** authenticated identity and assigned role.
- **Requirement:** a regulatory obligation or internal control.
- **Assignment:** responsibility for satisfying or reviewing a requirement.
- **Evidence:** a link or file reference supporting a requirement or action.
- **Assessment:** the contributor's current status and explanation.
- **Review:** approve, reject, or request-correction decision.
- **Corrective Action:** work required to resolve a finding.
- **Attachment or evidence file:** the minimum file/link reference needed for proof.

No separate workflow builder, custom approval engine, policy marketplace, document suite, or configurable form designer is required for the MVP.

## 8. MVP User Journeys

1. An administrator creates a requirement and assigns contributors.
2. A contributor opens the assignment, adds evidence, and submits it for review.
3. A reviewer approves the assessment or requests correction with a reason.
4. The contributor resolves corrections and resubmits.
5. An administrator views overdue and unresolved items and exports the summary.
6. A mobile contributor works without connectivity, then the client pushes changes and pulls updates.

## 9. Acceptance Criteria

- Every mutation has a server-authoritative actor or session identity.
- Deleted records use soft deletion and do not reappear after synchronization.
- Dirty local changes are not overwritten by pulls.
- Every requirement has an owner, status, and due date.
- Administrators can distinguish complete, pending, overdue, and rejected work.
- Reviewer decisions are retained with actor and timestamp.
- User scope is enforced by the API for every push and pull.
- Web and Android contain no conflicting copies of the domain schema or enum vocabulary.

## 10. Success Measures

Use these until live baselines exist:

- Median time from requirement assignment to evidence submission.
- Median time from submission to review decision.
- Percentage of assignments complete by due date.
- Percentage of overdue assignments.
- Percentage of offline edits successfully synchronized without manual intervention.
- Number of review corrections per submission.

Do not add engagement, advertising, predictive, or AI metrics to the MVP.

## 11. Explicitly Deferred or Excluded

- Automated regulatory change tracking and external legal feeds.
- AI classification, recommendations, or generated compliance reports.
- Custom workflow builders and arbitrary approval graphs.
- Cross-organization templates, marketplace, or content sharing.
- Native document editing or a full document-management system.
- Real-time chat and team collaboration feeds.
- Calendar systems, video calls, payments, and billing portals.
- Advanced BI, forecasting, heat maps, and configurable dashboards.
- Public guest accounts or broad anonymous discovery.
- Third-party integrations beyond Google Sign-In and essential file storage.

These items should remain out of scope unless a validated MVP customer explicitly blocks adoption without one.

## 12. Open Decisions Before Implementation

1. **Confirm domain:** Is the product specifically regulatory compliance, or was the inherited game-server text in v1.0 a placeholder? The approved scope assumes regulatory compliance because `sol-web/AGENTS.md` describes compliance software.
2. **Define code name and short code:** replace `SOL` with the approved ecosystem name and acronym.
3. **Name the compliance user:** regulator type, company size, geography, and documentation requirements.
4. **Choose retention periods:** specify evidence, review, and audit retention rather than only saying “limited.”
5. **Approve guest visibility:** identify exactly which summaries may be public or organization-shared.
6. **Select evidence storage:** classify allowed file types and define scanning, limits, encryption, and download rules.
7. **Confirm offline scope:** specify which synchronized records are allowed in each role's local dataset.
8. **Approve privacy thresholds:** define aggregation thresholds and prohibited per-user trails.

## 13. Implementation Priority

### First release

1. Authentication and role scope.
2. Requirements and assignments.
3. Evidence submission.
4. Review decisions and corrective actions.
5. Basic summaries and exports.
6. Offline synchronization.

### Not in the first release

- Integrations.
- Advanced reporting.
- Public guest discovery.
- AI and automation.
- Custom workflow configuration.

## Notes

- v1.0 contained placeholders and conflicting positioning: one section proposed a Node.js game-server management portal, while `sol-web/AGENTS.md` describes regulatory compliance. v1.1 resolves that conflict in favor of the repository's stated compliance direction.
- The MVP is intentionally narrow: a minimum closed-loop compliance workflow, not a generalized GRC platform.
- Add validated findings, changed assumptions, and implementation surprises to `INBOX.md` during implementation.
