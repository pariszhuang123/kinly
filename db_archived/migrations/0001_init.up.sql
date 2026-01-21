begin;

-- Enable required extensions
create extension if not exists pgcrypto;

-- 1) Profiles table mapped to auth.users
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username   text unique,
  full_name  text,
  avatar_url text,
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;

-- Only write via triggers/definer code
revoke insert, update, delete on public.profiles from anon, authenticated;

-- Auto-create profiles from auth.users
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id,
          coalesce(new.raw_user_meta_data->>'full_name', null),
          coalesce(new.raw_user_meta_data->>'avatar_url', null))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- Backfill profiles for users already referenced and present in auth.users
insert into public.profiles (id)
select u.id
from auth.users u
join (
  select owner_user_id as id from public.homes
  union
  select created_by      as id from public.homes
  union
  select user_id         as id from public.members
) r on r.id = u.id
on conflict (id) do nothing;

-- 2) Add FKs to profiles with ON DELETE CASCADE
alter table public.homes
  add constraint fk_homes_owner_user foreign key (owner_user_id) references public.profiles(id) on delete cascade,
  add constraint fk_homes_created_by  foreign key (created_by)    references public.profiles(id) on delete cascade;

alter table public.members
  add constraint fk_members_user foreign key (user_id) references public.profiles(id) on delete cascade;

-- 3) Convert invites to permanent-code model (one active per home)
-- 3a) Add created_by; backfill; set NOT NULL + FK
alter table public.invites add column if not exists created_by uuid;

update public.invites i
set created_by = coalesce(i.created_by, h.owner_user_id)
from public.homes h
where i.home_id = h.id
  and i.created_by is null;

alter table public.invites
  alter column created_by set not null;

alter table public.invites
  add constraint fk_invites_created_by foreign key (created_by) references public.profiles(id) on delete cascade;

-- 3b) Drop legacy TTL/usage columns if they exist
do $$
begin
  if exists (select 1 from information_schema.columns where table_schema='public' and table_name='invites' and column_name='expires_at') then
    alter table public.invites drop column expires_at;
  end if;
  if exists (select 1 from information_schema.columns where table_schema='public' and table_name='invites' and column_name='used_count') then
    alter table public.invites drop column used_count;
  end if;
  if exists (select 1 from information_schema.columns where table_schema='public' and table_name='invites' and column_name='max_uses') then
    alter table public.invites drop column max_uses;
  end if;
end $$;

-- 3c) Ensure only one active invite per home: revoke duplicates then enforce with unique partial index
with dups as (
  select id,
         row_number() over (partition by home_id order by created_at desc) as rn
  from public.invites
  where revoked_at is null
)
update public.invites i
set revoked_at = now()
from dups d
where i.id = d.id and d.rn > 1;

create unique index if not exists ux_invites_home_active
  on public.invites(home_id)
  where revoked_at is null;

-- 4) RPCs: replace legacy create with get_or_create + rotate + rotate_and_get; update join

-- Drop legacy function if present
drop function if exists public.invites_create(uuid, int, int);

-- invites.get_or_create(home_id)
create or replace function public.invites_get_or_create(p_home_id uuid)
returns public.invites
language plpgsql
security definer
as $$
declare
  v_home public.homes;
  v_inv  public.invites;
  v_code text;
begin
  select * into v_home from public.homes where id = p_home_id and is_active = true;
  if not found then
    raise exception 'home not found or inactive';
  end if;
  if v_home.owner_user_id <> auth.uid() then
    raise exception 'only owner can get/create invite';
  end if;

  -- Serialize on home to avoid duplicate actives
  perform 1 from public.homes where id = p_home_id for update;

  select * into v_inv
  from public.invites
  where home_id = p_home_id and revoked_at is null
  limit 1;

  if found then
    return v_inv;
  end if;

  v_code := lower(encode(gen_random_bytes(6), 'hex')); -- 12-char code
  insert into public.invites(home_id, code, created_by)
  values (p_home_id, v_code, auth.uid())
  returning * into v_inv;

  return v_inv;
end;
$$;

-- invites.rotate(home_id)
create or replace function public.invites_rotate(p_home_id uuid)
returns void
language plpgsql
security definer
as $$
declare
  v_home public.homes;
begin
  select * into v_home from public.homes where id = p_home_id and is_active = true;
  if not found then raise exception 'home not found or inactive'; end if;
  if v_home.owner_user_id <> auth.uid() then raise exception 'only owner can rotate'; end if;

  perform 1 from public.homes where id = p_home_id for update;

  update public.invites
     set revoked_at = now()
   where home_id = p_home_id
     and revoked_at is null;
end;
$$;

-- invites.rotate_and_get(home_id)
create or replace function public.invites_rotate_and_get(p_home_id uuid)
returns public.invites
language plpgsql
security definer
as $$
declare
  v_home public.homes;
  v_new  public.invites;
  v_code text;
begin
  select * into v_home from public.homes where id = p_home_id and is_active = true;
  if not found then raise exception 'home not found or inactive'; end if;
  if v_home.owner_user_id <> auth.uid() then raise exception 'only owner can rotate'; end if;

  perform 1 from public.homes where id = p_home_id for update;

  update public.invites
     set revoked_at = now()
   where home_id = p_home_id
     and revoked_at is null;

  v_code := lower(encode(gen_random_bytes(6), 'hex'));
  insert into public.invites(home_id, code, created_by)
  values (p_home_id, v_code, auth.uid())
  returning * into v_new;

  return v_new;
end;
$$;

-- homes.join(code): validate active invite only; no TTL/usage logic
create or replace function public.homes_join(p_code text)
returns public.homes
language plpgsql
security definer
as $$
declare
  v_inv  public.invites;
  v_home public.homes;
  v_exists boolean;
begin
  select * into v_inv
  from public.invites
  where code = p_code and revoked_at is null;
  if not found then
    raise exception 'invalid or revoked code';
  end if;

  select * into v_home from public.homes where id = v_inv.home_id and is_active = true;
  if not found then
    raise exception 'home inactive';
  end if;

  select exists (
    select 1 from public.members m
    where m.home_id = v_home.id and m.user_id = auth.uid()
  ) into v_exists;

  if not v_exists then
    insert into public.members(user_id, home_id, role) values (auth.uid(), v_home.id, 'member');
  end if;

  return v_home;
end;
$$;

-- Tables
create table if not exists public.homes (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  owner_user_id uuid not null,
  created_by uuid not null,
  created_at timestamptz not null default now(),
  is_active boolean not null default true,
  deactivated_at timestamptz
);

create table if not exists public.members (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null,
  home_id uuid not null references public.homes(id) on delete cascade,
  role text not null check (role in ('owner','member')),
  created_at timestamptz not null default now()
);
create index if not exists idx_members_home_id on public.members(home_id);
create index if not exists idx_members_user_id on public.members(user_id);

create table if not exists public.invites (
  id uuid primary key default gen_random_uuid(),
  home_id uuid not null references public.homes(id) on delete cascade,
  code text not null unique,
  expires_at timestamptz not null,
  revoked_at timestamptz,
  used_count int not null default 0,
  max_uses int not null default 1,
  created_at timestamptz not null default now()
);
create index if not exists idx_invites_home_id on public.invites(home_id);
create index if not exists idx_invites_code on public.invites(code);
create index if not exists idx_homes_created_at on public.homes(created_at);

-- RLS
alter table public.homes enable row level security;
alter table public.members enable row level security;
alter table public.invites enable row level security;

-- Helper: check if auth uid is member of a home
create or replace function public.is_member_of(p_home_id uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1 from public.members m
    where m.home_id = p_home_id and m.user_id = auth.uid()
  );
$$;

-- Policies: SELECT only; direct writes are intentionally not permitted
create policy homes_select_member_active on public.homes
for select using (
  is_active = true and exists (
    select 1 from public.members m
    where m.home_id = homes.id and m.user_id = auth.uid()
  )
);

create policy members_select_same_home_active on public.members
for select using (
  exists (
    select 1 from public.homes h
    where h.id = members.home_id and h.is_active = true
  ) and exists (
    select 1 from public.members m2
    where m2.home_id = members.home_id and m2.user_id = auth.uid()
  )
);

create policy invites_select_member_active on public.invites
for select using (
  exists (
    select 1 from public.homes h
    where h.id = invites.home_id and h.is_active = true
  ) and exists (
    select 1 from public.members m
    where m.home_id = invites.home_id and m.user_id = auth.uid()
  )
);

-- Revoke direct DML from anon/auth, keep via RPCs (security definer)
revoke insert, update, delete on public.homes from anon, authenticated;
revoke insert, update, delete on public.members from anon, authenticated;
revoke insert, update, delete on public.invites from anon, authenticated;

-- RPCs
-- homes.create(name)
create or replace function public.homes_create(p_name text)
returns public.homes
language plpgsql
security definer
as $$
declare
  v_home public.homes;
begin
  insert into public.homes (name, owner_user_id, created_by)
  values (p_name, auth.uid(), auth.uid())
  returning * into v_home;

  insert into public.members (user_id, home_id, role)
  values (auth.uid(), v_home.id, 'owner');

  return v_home;
end;
$$;

-- invites.create(homeId, ttlHours, maxUses)
create or replace function public.invites_create(p_home_id uuid, p_ttl_hours int, p_max_uses int)
returns public.invites
language plpgsql
security definer
as $$
declare
  v_home_owner uuid;
  v_inv public.invites;
  v_code text := encode(gen_random_bytes(6), 'hex');
begin
  select owner_user_id into v_home_owner from public.homes where id = p_home_id and is_active = true;
  if v_home_owner is null then
    raise exception 'home not found or inactive';
  end if;
  if v_home_owner <> auth.uid() then
    raise exception 'only owner can create invites';
  end if;

  insert into public.invites(home_id, code, expires_at, max_uses)
  values (p_home_id, v_code, now() + make_interval(hours => p_ttl_hours), greatest(1, p_max_uses))
  returning * into v_inv;
  return v_inv;
end;
$$;

-- homes.join(code)
create or replace function public.homes_join(p_code text)
returns public.homes
language plpgsql
security definer
as $$
declare
  v_inv public.invites;
  v_home public.homes;
  v_exists boolean;
begin
  select * into v_inv from public.invites
  where code = p_code and revoked_at is null and expires_at > now();
  if not found then
    raise exception 'invalid or expired code';
  end if;

  select * into v_home from public.homes where id = v_inv.home_id and is_active = true;
  if not found then
    raise exception 'home inactive';
  end if;

  -- already a member?
  select exists (
    select 1 from public.members m where m.home_id = v_home.id and m.user_id = auth.uid()
  ) into v_exists;
  if not v_exists then
    insert into public.members(user_id, home_id, role) values (auth.uid(), v_home.id, 'member');
  end if;

  update public.invites set used_count = used_count + 1 where id = v_inv.id;
  update public.invites set revoked_at = now() where id = v_inv.id and used_count >= max_uses;

  return v_home;
end;
$$;

-- homes.transferOwner(homeId, newOwnerId)
create or replace function public.homes_transfer_owner(p_home_id uuid, p_new_owner uuid)
returns public.homes
language plpgsql
security definer
as $$
declare
  v_home public.homes;
  v_is_member boolean;
begin
  select * into v_home from public.homes where id = p_home_id and is_active = true;
  if not found then raise exception 'home not found or inactive'; end if;
  if v_home.owner_user_id <> auth.uid() then raise exception 'only owner can transfer'; end if;

  select exists(select 1 from public.members where home_id = p_home_id and user_id = p_new_owner) into v_is_member;
  if not v_is_member then raise exception 'new owner must be a member'; end if;

  update public.homes set owner_user_id = p_new_owner where id = p_home_id;
  update public.members set role = case when user_id = p_new_owner then 'owner' else 'member' end
  where home_id = p_home_id;

  return (select * from public.homes where id = p_home_id);
end;
$$;

-- homes.leave(homeId)
create or replace function public.homes_leave(p_home_id uuid)
returns void
language plpgsql
security definer
as $$
declare
  v_remaining int;
begin
  delete from public.members where home_id = p_home_id and user_id = auth.uid();

  select count(*) into v_remaining from public.members where home_id = p_home_id;
  if v_remaining = 0 then
    update public.homes set is_active = false, deactivated_at = now() where id = p_home_id;
    update public.invites set revoked_at = now() where home_id = p_home_id and revoked_at is null;
  end if;
end;
$$;

-- members.listByHome(homeId)
create or replace function public.members_list_by_home(p_home_id uuid)
returns setof public.members
language sql
stable
security definer
as $$
  select m.* from public.members m
  join public.homes h on h.id = m.home_id
  where m.home_id = p_home_id
    and h.is_active = true
    and exists (
      select 1 from public.members self
      where self.home_id = p_home_id and self.user_id = auth.uid()
    );
$$;

commit;

