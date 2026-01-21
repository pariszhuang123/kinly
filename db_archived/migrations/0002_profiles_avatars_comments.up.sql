begin;

-- Comments for existing tables (homes, members, invites, profiles)

comment on table public.homes is 'Homes: top-level container. Exactly one owner; becomes inactive when last member leaves.';
comment on column public.homes.id is 'Primary key (UUID).';
comment on column public.homes.name is 'Human-readable home name.';
comment on column public.homes.owner_user_id is 'Current owner (FK -> profiles.id, same as auth.users.id). Single source of truth for ownership.';
comment on column public.homes.created_by is 'User who created the home (FK -> profiles.id).';
comment on column public.homes.created_at is 'Creation timestamp (UTC).';
comment on column public.homes.is_active is 'Active flag. False when last active member leaves.';
comment on column public.homes.deactivated_at is 'When home became inactive (UTC).';

comment on table public.members is 'Memberships: one row per user in a home; leaving sets left_at (soft delete).';
comment on column public.members.id is 'Primary key (UUID).';
comment on column public.members.user_id is 'Member user id (FK -> profiles.id / auth.users.id).';
comment on column public.members.home_id is 'Home id (FK -> homes.id).';
comment on column public.members.role is 'Role label: owner|member. Prefer deriving owner via homes.owner_user_id to avoid drift.';
comment on column public.members.created_at is 'When the membership was created (UTC).';

comment on table public.invites is 'Invite codes: permanent codes per home; exactly one active (revoked_at IS NULL).';
comment on column public.invites.id is 'Primary key (UUID).';
comment on column public.invites.home_id is 'Home id (FK -> homes.id).';
comment on column public.invites.code is 'Unique invite code presented to joiners.';
comment on column public.invites.revoked_at is 'Timestamp when invite was revoked (NULL = active).';
comment on column public.invites.created_at is 'Creation timestamp (UTC).';
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema='public' and table_name='invites' and column_name='created_by'
  ) then
    comment on column public.invites.created_by is 'User who issued the invite (FK -> profiles.id).';
  end if;
end $$;

comment on table public.profiles is 'Application user profiles, 1:1 with auth.users via id.';
comment on column public.profiles.id is 'Primary key (UUID), equals auth.users.id.';
comment on column public.profiles.username is 'Unique handle (optional).';
comment on column public.profiles.full_name is 'Display name (optional).';
comment on column public.profiles.avatar_url is 'Deprecated: direct URL for avatar. Prefer profiles.avatar_id -> avatars.';
comment on column public.profiles.created_at is 'Creation timestamp (UTC).';

-- Avatars table for user images referenced from profiles
create table if not exists public.avatars (
  id uuid primary key default gen_random_uuid(),
  storage_path text not null,
  public_url  text,
  is_public boolean not null default true,
  created_by uuid not null,
  created_at timestamptz not null default now()
);

comment on table public.avatars is 'Avatars: image metadata for user profile pictures.';
comment on column public.avatars.id is 'Primary key (UUID).';
comment on column public.avatars.storage_path is 'Storage bucket/path or object key for the avatar.';
comment on column public.avatars.public_url is 'Optional public URL for direct access (if exposed).';
comment on column public.avatars.is_public is 'If true, any authenticated user may view; otherwise only owner may view.';
comment on column public.avatars.created_by is 'Uploader/owner user id (FK -> profiles.id).';
comment on column public.avatars.created_at is 'Creation timestamp (UTC).';

alter table public.avatars enable row level security;
revoke insert, update, delete on public.avatars from anon, authenticated;

-- Minimal SELECT policy: allow viewing public avatars or own avatars
create policy avatars_select_authenticated on public.avatars
for select using (
  auth.uid() is not null and (is_public or created_by = auth.uid())
);

-- Link profiles -> avatars via avatar_id (nullable), keep avatar_url for now
alter table public.profiles add column if not exists avatar_id uuid;
alter table public.profiles
  add constraint fk_profiles_avatar foreign key (avatar_id)
  references public.avatars(id) on delete set null;

comment on column public.profiles.avatar_id is 'FK to avatars.id; preferred way to reference profile image.';

-- Basic SELECT policy for profiles so clients can read names/avatars
create policy if not exists profiles_select_authenticated on public.profiles
for select using (auth.uid() is not null);

-- User profile view: convenient unified shape for clients
create or replace view public.user_profile as
select p.id,
       p.username,
       p.full_name,
       p.avatar_id,
       coalesce(a.public_url, p.avatar_url) as avatar_url,
       p.created_at
from public.profiles p
left join public.avatars a on a.id = p.avatar_id;

comment on view public.user_profile is 'Convenience view combining profiles with avatar URL.';

commit;

