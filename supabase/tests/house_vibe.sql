SET search_path = pgtap, public, auth, extensions;

BEGIN;

SELECT plan(7);

CREATE TEMP TABLE tmp_users (
  label   text PRIMARY KEY,
  user_id uuid,
  email   text
);

CREATE TEMP TABLE tmp_homes (
  label   text PRIMARY KEY,
  home_id uuid
);

CREATE TEMP TABLE invite_codes (
  label text PRIMARY KEY,
  code  text
);

-- Ensure avatars exist for profile creation hooks
INSERT INTO public.avatars (id, storage_path, category, name)
VALUES
  ('00000000-0000-4000-8000-000000000701', 'avatars/default.png', 'animal', 'House Vibe Avatar 1'),
  ('00000000-0000-4000-8000-000000000702', 'avatars/default2.png', 'animal', 'House Vibe Avatar 2')
ON CONFLICT (id) DO NOTHING;

-- Seed auth users
INSERT INTO tmp_users (label, user_id, email) VALUES
  ('owner',  '00000000-0000-4000-8000-000000000811', 'owner-house-vibe@example.com'),
  ('member', '00000000-0000-4000-8000-000000000812', 'member-house-vibe@example.com');

INSERT INTO auth.users (id, instance_id, email, raw_user_meta_data, raw_app_meta_data, aud, role, encrypted_password)
SELECT
  user_id,
  '00000000-0000-0000-0000-000000000000'::uuid,
  email,
  '{}'::jsonb,
  '{"provider":"email"}'::jsonb,
  'authenticated',
  'authenticated',
  'secret'
FROM tmp_users
ON CONFLICT (id) DO NOTHING;

-- Owner creates home
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'owner'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH res AS (
  SELECT public.homes_create_with_invite() AS payload
)
INSERT INTO tmp_homes (label, home_id)
SELECT 'home', (payload->'home'->>'id')::uuid FROM res;

INSERT INTO invite_codes (label, code)
SELECT 'home', (SELECT code::text FROM public.invites WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'home') AND revoked_at IS NULL LIMIT 1);

-- Member joins home
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'member'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);
SELECT public.homes_join((SELECT code FROM invite_codes WHERE label = 'home'));

-- Switch to service_role for direct table checks (tables are service-role only)
SET LOCAL ROLE service_role;

-- Seed checks
SELECT cmp_ok(
  (SELECT count(*) FROM public.house_vibe_labels WHERE mapping_version = 'v1'),
  '>=',
  8::bigint,
  'house_vibe_labels v1 seeded'
);

SELECT is(
  (SELECT count(*) FROM public.house_vibe_mapping_effects WHERE mapping_version = 'v1'),
  39::bigint,
  'house_vibe_mapping_effects v1 seeded with 39 rows'
);

-- share_events allows feature = house_vibe
INSERT INTO public.share_events (user_id, home_id, feature, channel)
VALUES (
  (SELECT user_id FROM tmp_users WHERE label = 'owner'),
  (SELECT home_id FROM tmp_homes WHERE label = 'home'),
  'house_vibe',
  'system_share'
);

SELECT ok(true, 'share_events accepts feature=house_vibe with system_share channel');

-- Invalidation from memberships (owner created home, member joined)
WITH hv AS (
  SELECT *
  FROM public.house_vibes
  WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'home')
)
SELECT ok(
  EXISTS (SELECT 1 FROM hv WHERE out_of_date = true AND invalidated_at IS NOT NULL AND coverage_total = 2),
  'house_vibes row exists with out_of_date=true, invalidated_at set, coverage_total=2 after memberships'
);

-- Capture invalidated_at after member join
CREATE TEMP TABLE hv_snapshot AS
SELECT invalidated_at
FROM public.house_vibes
WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'home');

-- Preference update triggers invalidation bump
INSERT INTO public.preference_responses (user_id, preference_id, option_index, captured_at)
VALUES (
  (SELECT user_id FROM tmp_users WHERE label = 'owner'),
  'environment_noise_tolerance',
  0,
  now()
);

WITH prev AS (
  SELECT invalidated_at AS prev_inv FROM hv_snapshot
),
curr AS (
  SELECT invalidated_at AS curr_inv
  FROM public.house_vibes
  WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'home')
)
SELECT ok(
  (SELECT curr_inv FROM curr) > (SELECT prev_inv FROM prev),
  'preference_responses change bumps invalidated_at on house_vibes'
);

-- out_of_date stays true until compute clears it
SELECT ok(
  (SELECT out_of_date FROM public.house_vibes WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'home')),
  'house_vibes remains out_of_date after preference change'
);

RESET ROLE;

SELECT * FROM finish();

ROLLBACK;
