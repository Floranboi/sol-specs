-- SOL MVP schema snapshot v1.0.0
-- Idempotent full schema for Supabase/Postgres.
-- Server `id` values are private indexes. Relationships use UUID columns only.

begin;

create extension if not exists pgcrypto;

DO $$ BEGIN
  create type public.account_role as enum ('system_admin', 'administrator', 'reviewer', 'contributor', 'guest');
EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  create type public.requirement_status as enum ('draft', 'active', 'archived');
EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  create type public.assignment_status as enum ('pending', 'in_progress', 'submitted', 'approved', 'rejected', 'corrected');
EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  create type public.assessment_status as enum ('draft', 'submitted', 'approved', 'rejected', 'correction_requested');
EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  create type public.review_decision as enum ('approved', 'rejected', 'correction_requested');
EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  create type public.corrective_action_status as enum ('open', 'in_progress', 'resolved', 'closed');
EXCEPTION WHEN duplicate_object THEN null;
END $$;
DO $$ BEGIN
  create type public.evidence_kind as enum ('link', 'file');
EXCEPTION WHEN duplicate_object THEN null;
END $$;

create table if not exists public.account (
  id bigint generated always as identity,
  uuid uuid not null,
  role public.account_role not null default 'contributor',
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint account_pkey primary key (id),
  constraint account_uuid_key unique (uuid)
);

create table if not exists public.requirement (
  id bigint generated always as identity,
  uuid uuid not null,
  title text not null,
  description text,
  status public.requirement_status not null default 'draft',
  due_at timestamptz,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint requirement_pkey primary key (id),
  constraint requirement_uuid_key unique (uuid)
);

create table if not exists public.assignment (
  id bigint generated always as identity,
  uuid uuid not null,
  requirement_uuid uuid not null,
  assignee_uuid uuid not null,
  status public.assignment_status not null default 'pending',
  due_at timestamptz,
  submitted_at timestamptz,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint assignment_pkey primary key (id),
  constraint assignment_uuid_key unique (uuid)
);

create table if not exists public.evidence (
  id bigint generated always as identity,
  uuid uuid not null,
  assignment_uuid uuid not null,
  kind public.evidence_kind not null,
  name text,
  reference text not null,
  submitted_at timestamptz,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint evidence_pkey primary key (id),
  constraint evidence_uuid_key unique (uuid)
);

create table if not exists public.assessment (
  id bigint generated always as identity,
  uuid uuid not null,
  assignment_uuid uuid not null,
  status public.assessment_status not null default 'draft',
  explanation text,
  submitted_at timestamptz,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint assessment_pkey primary key (id),
  constraint assessment_uuid_key unique (uuid)
);

create table if not exists public.review (
  id bigint generated always as identity,
  uuid uuid not null,
  assessment_uuid uuid not null,
  decision public.review_decision not null,
  comment text,
  reviewed_by uuid not null default auth.uid(),
  reviewed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint review_pkey primary key (id),
  constraint review_uuid_key unique (uuid)
);

create table if not exists public.corrective_action (
  id bigint generated always as identity,
  uuid uuid not null,
  assignment_uuid uuid,
  review_uuid uuid,
  title text not null,
  description text,
  assignee_uuid uuid,
  status public.corrective_action_status not null default 'open',
  due_at timestamptz,
  resolved_at timestamptz,
  created_by uuid not null default auth.uid(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  archived_at timestamptz,
  constraint corrective_action_pkey primary key (id),
  constraint corrective_action_uuid_key unique (uuid)
);

-- UUID relationship indexes. All local/server relationships remain *_uuid columns.
create index if not exists idx_requirement_status_live on public.requirement (status, due_at) where archived_at is null;
create index if not exists idx_assignment_requirement on public.assignment (requirement_uuid);
create index if not exists idx_assignment_assignee_live on public.assignment (assignee_uuid, status, due_at) where archived_at is null;
create index if not exists idx_evidence_assignment on public.evidence (assignment_uuid) where archived_at is null;
create index if not exists idx_assessment_assignment on public.assessment (assignment_uuid) where archived_at is null;
create index if not exists idx_review_assessment on public.review (assessment_uuid) where archived_at is null;
create index if not exists idx_corrective_assignment on public.corrective_action (assignment_uuid) where archived_at is null;
create index if not exists idx_corrective_review on public.corrective_action (review_uuid) where archived_at is null;
create index if not exists idx_corrective_assignee on public.corrective_action (assignee_uuid) where archived_at is null;

-- Each live assignment belongs to one assignee per requirement.
create unique index if not exists idx_assignment_live_requirement_assignee
  on public.assignment (requirement_uuid, assignee_uuid)
  where archived_at is null;

-- A live assessment has one active contributor submission per assignment.
create unique index if not exists idx_assessment_live_assignment
  on public.assessment (assignment_uuid)
  where archived_at is null;

-- Prevent one live review decision from being duplicated for a single assessment.
create unique index if not exists idx_review_live_assessment
  on public.review (assessment_uuid)
  where archived_at is null;

alter table public.account enable row level security;
alter table public.requirement enable row level security;
alter table public.assignment enable row level security;
alter table public.evidence enable row level security;
alter table public.assessment enable row level security;
alter table public.review enable row level security;
alter table public.corrective_action enable row level security;

-- Profiles are visible only to the signed-in user until an administrative policy is added.
drop policy if exists "account_select_own" on public.account;
create policy "account_select_own" on public.account
  for select to authenticated using (uuid = auth.uid() and archived_at is null);

drop policy if exists "requirement_select_assigned" on public.requirement;
create policy "requirement_select_assigned" on public.requirement
  for select to authenticated using (
    archived_at is null and exists (
      select 1 from public.assignment a
      where a.requirement_uuid = requirement.uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  );

drop policy if exists "requirement_write_own_role" on public.requirement;
create policy "requirement_write_own_role" on public.requirement
  for all to authenticated using (
    exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator')
        and c.archived_at is null
    )
  ) with check (
    exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator')
        and c.archived_at is null
    )
  );

drop policy if exists "assignment_select_assignee" on public.assignment;
create policy "assignment_select_assignee" on public.assignment
  for select to authenticated using (
    assignee_uuid = auth.uid()
    and archived_at is null
  );

drop policy if exists "assignment_write_administrator" on public.assignment;
create policy "assignment_write_administrator" on public.assignment
  for all to authenticated using (
    exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator')
        and c.archived_at is null
    )
  ) with check (
    exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator')
        and c.archived_at is null
    )
  );

drop policy if exists "evidence_select_assigned" on public.evidence;
create policy "evidence_select_assigned" on public.evidence
  for select to authenticated using (
    archived_at is null and exists (
      select 1 from public.assignment a
      where a.uuid = evidence.assignment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  );

drop policy if exists "evidence_write_assignee" on public.evidence;
create policy "evidence_write_assignee" on public.evidence
  for all to authenticated using (
    exists (
      select 1 from public.assignment a
      where a.uuid = evidence.assignment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  ) with check (
    exists (
      select 1 from public.assignment a
      where a.uuid = evidence.assignment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  );

drop policy if exists "assessment_select_assigned" on public.assessment;
create policy "assessment_select_assigned" on public.assessment
  for select to authenticated using (
    archived_at is null and exists (
      select 1 from public.assignment a
      where a.uuid = assessment.assignment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  );

drop policy if exists "assessment_write_assignee" on public.assessment;
create policy "assessment_write_assignee" on public.assessment
  for all to authenticated using (
    exists (
      select 1 from public.assignment a
      where a.uuid = assessment.assignment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  ) with check (
    exists (
      select 1 from public.assignment a
      where a.uuid = assessment.assignment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  );

drop policy if exists "review_select_assigned" on public.review;
create policy "review_select_assigned" on public.review
  for select to authenticated using (
    archived_at is null and exists (
      select 1 from public.assessment s
      join public.assignment a on a.uuid = s.assignment_uuid
      where s.uuid = review.assessment_uuid
        and a.assignee_uuid = auth.uid()
        and a.archived_at is null
    )
  );

drop policy if exists "review_write_reviewer" on public.review;
create policy "review_write_reviewer" on public.review
  for all to authenticated using (
    exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator', 'reviewer')
        and c.archived_at is null
    )
  ) with check (
    exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator', 'reviewer')
        and c.archived_at is null
    )
  );

drop policy if exists "corrective_select_assigned" on public.corrective_action;
create policy "corrective_select_assigned" on public.corrective_action
  for select to authenticated using (
    archived_at is null
    and (assignee_uuid = auth.uid() or exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator', 'reviewer')
        and c.archived_at is null
    ))
  );

drop policy if exists "corrective_write_assigned" on public.corrective_action;
create policy "corrective_write_assigned" on public.corrective_action
  for all to authenticated using (
    assignee_uuid = auth.uid() or exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator')
        and c.archived_at is null
    )
  ) with check (
    assignee_uuid = auth.uid() or exists (
      select 1 from public.account c
      where c.uuid = auth.uid()
        and c.role in ('system_admin', 'administrator')
        and c.archived_at is null
    )
  );

commit;
