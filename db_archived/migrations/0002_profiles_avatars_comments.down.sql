begin;

drop view if exists public.user_profile;

-- Drop policies added in up
drop policy if exists profiles_select_authenticated on public.profiles;
drop policy if exists avatars_select_authenticated on public.avatars;

-- Remove FK from profiles to avatars and column
alter table public.profiles drop constraint if exists fk_profiles_avatar;
alter table public.profiles drop column if exists avatar_id;

-- Drop avatars table
drop table if exists public.avatars;

commit;

