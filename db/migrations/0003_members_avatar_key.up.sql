begin;

-- Catalog of allowed avatar keys (optional metadata for client lookup)
create table if not exists public.avatar_catalog (
  key text primary key,
  display_name text,
  asset_uri text
);

comment on table public.avatar_catalog is 'Allowed avatar keys palette; joinable to members.avatar_key for metadata.';
comment on column public.avatar_catalog.key is 'Stable avatar identifier (e.g., fox_blue, cat_orange).';
comment on column public.avatar_catalog.display_name is 'Human-readable name.';
comment on column public.avatar_catalog.asset_uri is 'Path/URL for the asset (if served from CDN or storage).';

-- Optional seed (example palette); adjust or remove in production
insert into public.avatar_catalog(key, display_name)
values
  ('fox_blue','Fox Blue'),
  ('fox_red','Fox Red'),
  ('cat_orange','Cat Orange'),
  ('cat_gray','Cat Gray'),
  ('dog_brown','Dog Brown'),
  ('dog_black','Dog Black'),
  ('owl_green','Owl Green'),
  ('owl_purple','Owl Purple')
on conflict (key) do nothing;

-- Members per-home avatar assignment
alter table public.members add column if not exists left_at timestamptz;
alter table public.members add column if not exists avatar_key text;

comment on column public.members.left_at is 'When the member left this home (NULL = active).';
comment on column public.members.avatar_key is 'Per-home avatar key; must be unique among active members of the same home.';

-- Enforce uniqueness among active members per home (ignore NULL keys)
create unique index if not exists ux_members_home_avatar_active
  on public.members(home_id, avatar_key)
  where left_at is null and avatar_key is not null;

-- Helper: set avatar explicitly (self only)
create or replace function public.members_set_avatar(p_home_id uuid, p_avatar_key text)
returns text
language plpgsql
security definer
as $$
declare
  v_exists boolean;
begin
  -- Must be active member of the home
  perform 1 from public.members m
   join public.homes h on h.id = m.home_id and h.is_active = true
  where m.home_id = p_home_id and m.user_id = auth.uid() and m.left_at is null;
  if not found then
    raise exception 'not an active member or home inactive';
  end if;

  -- Avatar must be in catalog
  select exists(select 1 from public.avatar_catalog c where c.key = p_avatar_key) into v_exists;
  if not v_exists then
    raise exception 'invalid avatar key';
  end if;

  -- Ensure not used by another active member in this home
  select exists(
    select 1 from public.members m
    where m.home_id = p_home_id and m.left_at is null and m.avatar_key = p_avatar_key and m.user_id <> auth.uid()
  ) into v_exists;
  if v_exists then
    raise exception 'avatar already in use in this home';
  end if;

  update public.members
     set avatar_key = p_avatar_key
   where home_id = p_home_id and user_id = auth.uid() and left_at is null;

  return p_avatar_key;
end;
$$;

comment on function public.members_set_avatar(uuid, text) is 'Set caller''s avatar for a home; enforces per-home uniqueness and valid palette.';

-- Helper: assign first available avatar from catalog (deterministic order)
create or replace function public.members_assign_available_avatar(p_home_id uuid)
returns text
language plpgsql
security definer
as $$
declare
  v_key text;
begin
  -- Must be active member of the home
  perform 1 from public.members m
   join public.homes h on h.id = m.home_id and h.is_active = true
  where m.home_id = p_home_id and m.user_id = auth.uid() and m.left_at is null;
  if not found then
    raise exception 'not an active member or home inactive';
  end if;

  -- Find first palette key not used by any active member in this home
  select c.key into v_key
  from public.avatar_catalog c
  where not exists (
    select 1 from public.members m
    where m.home_id = p_home_id and m.left_at is null and m.avatar_key = c.key
  )
  order by c.key
  limit 1;

  if v_key is null then
    raise exception 'no available avatars in catalog for this home';
  end if;

  update public.members
     set avatar_key = v_key
   where home_id = p_home_id and user_id = auth.uid() and left_at is null;

  return v_key;
end;
$$;

comment on function public.members_assign_available_avatar(uuid) is 'Assigns the first available avatar key from catalog for the caller in the given home.';

commit;

