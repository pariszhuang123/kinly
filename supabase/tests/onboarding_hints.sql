SET search_path = pgtap, public, auth, extensions;

BEGIN;

SELECT plan(9);

CREATE TEMP TABLE tmp_ids (
  label   text PRIMARY KEY,
  user_id uuid,
  home_id uuid
);

-- Starter avatar required by handle_new_user trigger
INSERT INTO public.avatars (id, storage_path, category, name)
VALUES ('00000000-0000-4000-8000-000000000901', 'avatars/default.png', 'animal', 'Test Avatar')
ON CONFLICT (id) DO NOTHING;

-- User without membership
INSERT INTO auth.users (id, instance_id, email, raw_user_meta_data, raw_app_meta_data, aud, role, encrypted_password)
VALUES (
  '00000000-0000-4000-8000-000000000701',
  '00000000-0000-0000-0000-000000000000',
  'onboarding-nomem@example.com',
  '{}'::jsonb,
  '{"provider":"email"}'::jsonb,
  'authenticated',
  'authenticated',
  'secret'
)
ON CONFLICT (id) DO NOTHING;

-- Owner user
INSERT INTO auth.users (id, instance_id, email, raw_user_meta_data, raw_app_meta_data, aud, role, encrypted_password)
VALUES (
  '00000000-0000-4000-8000-000000000702',
  '00000000-0000-0000-0000-000000000000',
  'onboarding-owner@example.com',
  '{}'::jsonb,
  '{"provider":"email"}'::jsonb,
  'authenticated',
  'authenticated',
  'secret'
)
ON CONFLICT (id) DO NOTHING;

-- Owner context to create a home
SELECT set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000702', true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH res AS (
  SELECT public.homes_create_with_invite() AS payload
)
INSERT INTO tmp_ids (label, user_id, home_id)
SELECT
  'owner',
  '00000000-0000-4000-8000-000000000702',
  (payload->'home'->>'id')::uuid
FROM res;

-- 1) No membership -> all prompts false
SELECT set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000701', true);
SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptNotifications')::boolean,
  false,
  'No membership returns shouldPromptNotifications=false'
);

-- Switch to owner context for the rest
SELECT set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-000000000702', true);

-- 2) Zero active chores -> no prompts
SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptNotifications')::boolean,
  false,
  'Zero active chores does not prompt notifications'
);

-- 3) 1 active chore, no prefs -> prompt notifications
UPDATE public.home_usage_counters cuc
SET active_chores = active_chores + 1
WHERE cuc.home_id = (SELECT home_id FROM tmp_ids WHERE label = 'owner');

SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptNotifications')::boolean,
  true,
  'Active chores >=1 without prefs prompts notifications'
);

-- 4) With prefs, notifications prompt suppressed
SELECT public.notifications_update_preferences(true, 9);
SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptNotifications')::boolean,
  false,
  'Existing prefs suppress notification prompt'
);

-- 5) 2 active chores -> flatmate invite prompt when not shared
UPDATE public.home_usage_counters cuc
SET active_chores = active_chores + 1
WHERE cuc.home_id = (SELECT home_id FROM tmp_ids WHERE label = 'owner');

SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptFlatmateInviteShare')::boolean,
  true,
  'Active chores >=2 with no share triggers flatmate invite prompt'
);

-- Log flatmate invite share
SELECT public.share_log_event(
  p_home_id := (SELECT home_id FROM tmp_ids WHERE label = 'owner'),
  p_feature := 'invite_housemate',
  p_channel := 'copy_link'
);

-- 6) After flatmate share, next ladder prompt only when count high enough
SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptFlatmateInviteShare')::boolean,
  false,
  'Flatmate invite already shared disables that prompt'
);

-- 7) Increase to 5 chores -> generic invite prompt
UPDATE public.home_usage_counters cuc
SET active_chores = active_chores + 3
WHERE cuc.home_id = (SELECT home_id FROM tmp_ids WHERE label = 'owner');

SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptInviteShare')::boolean,
  true,
  'Active chores >=5 prompts generic invite when earlier steps satisfied'
);

-- Log generic invite share to suppress prompt
SELECT public.share_log_event(
  p_home_id := (SELECT home_id FROM tmp_ids WHERE label = 'owner'),
  p_feature := 'invite_button',
  p_channel := 'system_share'
);

-- 8) Once shared, generic invite prompt clears
SELECT is(
  ((public.today_onboarding_hints())->>'shouldPromptInviteShare')::boolean,
  false,
  'Generic invite share suppresses future prompt'
);

-- 9) Active chore count surface
SELECT is(
  ((public.today_onboarding_hints())->>'activeChoreCount')::int,
  5,
  'Active chore count reflects cached counters'
);

SELECT finish();
ROLLBACK;
