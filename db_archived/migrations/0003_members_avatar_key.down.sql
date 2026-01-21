begin;

drop function if exists public.members_assign_available_avatar(uuid);
drop function if exists public.members_set_avatar(uuid, text);

drop index if exists ux_members_home_avatar_active;

alter table public.members drop column if exists avatar_key;
alter table public.members drop column if exists left_at;

drop table if exists public.avatar_catalog;

commit;

