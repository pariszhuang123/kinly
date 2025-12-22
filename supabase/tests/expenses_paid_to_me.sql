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

CREATE TEMP TABLE tmp_expenses (
  label      text PRIMARY KEY,
  expense_id uuid
);

-- Seed avatar for profiles
INSERT INTO public.avatars (id, storage_path, category, name)
VALUES
  ('00000000-0000-4000-8000-000000000777', 'avatars/paid-to-me.png', 'animal', 'Paid To Me Avatar'),
  ('00000000-0000-4000-8000-000000000778', 'avatars/paid-to-me-2.png', 'animal', 'Paid To Me Avatar 2'),
  ('00000000-0000-4000-8000-000000000779', 'avatars/paid-to-me-3.png', 'animal', 'Paid To Me Avatar 3')
ON CONFLICT (id) DO NOTHING;

INSERT INTO tmp_users (label, user_id, email) VALUES
  ('creator', '20000000-0000-4000-8000-000000000001', 'creator-paid@example.com'),
  ('debtor',  '20000000-0000-4000-8000-000000000002', 'debtor-paid@example.com');

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

-- Creator creates home + invite
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'creator'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH res AS (
  SELECT public.homes_create_with_invite() AS payload
)
INSERT INTO tmp_homes (label, home_id)
SELECT 'primary', (payload->'home'->>'id')::uuid FROM res;

-- Debtor joins
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'debtor'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

SELECT public.homes_join(
  (SELECT code
   FROM public.invites
   WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'primary')
     AND revoked_at IS NULL
   LIMIT 1)
);

-- Creator creates expense with self + debtor; creator split auto-paid
-- Expense A
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'creator'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH created AS (
  SELECT public.expenses_create(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    'Dinner',
    2500,
    NULL,
    'custom',
    NULL,
    jsonb_build_array(
      jsonb_build_object(
        'user_id', (SELECT user_id FROM tmp_users WHERE label = 'creator'),
        'amount_cents', 100
      ),
      jsonb_build_object(
        'user_id', (SELECT user_id FROM tmp_users WHERE label = 'debtor'),
        'amount_cents', 2400
      )
    )
  ) AS expense
)
INSERT INTO tmp_expenses (label, expense_id)
SELECT 'dinner', (expense).id FROM created;

-- Expense B (second paid item from same debtor)
WITH created AS (
  SELECT public.expenses_create(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    'Snacks',
    1000,
    NULL,
    'custom',
    NULL,
    jsonb_build_array(
      jsonb_build_object(
        'user_id', (SELECT user_id FROM tmp_users WHERE label = 'creator'),
        'amount_cents', 100
      ),
      jsonb_build_object(
        'user_id', (SELECT user_id FROM tmp_users WHERE label = 'debtor'),
        'amount_cents', 900
      )
    )
  ) AS expense
)
INSERT INTO tmp_expenses (label, expense_id)
SELECT 'snacks', (expense).id FROM created;

-- Debtor marks paid (JSON response)
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'debtor'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH payload AS (
  SELECT public.expenses_mark_share_paid(
    (SELECT expense_id FROM tmp_expenses WHERE label = 'dinner')
  ) AS body
)
SELECT is(
  (SELECT (body->>'deduped')::boolean FROM payload),
  FALSE,
  'First mark_share_paid is not deduped'
);

-- Debtor marks second expense paid
SELECT public.expenses_mark_share_paid(
  (SELECT expense_id FROM tmp_expenses WHERE label = 'snacks')
);

-- Creator sees only debtor share (creator auto-paid split filtered out)
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'creator'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH list AS (
  SELECT public.expenses_get_current_paid_to_me_debtors(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary')
  ) AS body
)
SELECT is(
  (SELECT jsonb_array_length(body) FROM list),
  1,
  'Paid-to-me list has one debtor'
);

WITH list AS (
  SELECT public.expenses_get_current_paid_to_me_debtors(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary')
  ) AS body
)
SELECT is(
  (SELECT (body->0->>'totalPaidCents')::int FROM list),
  3300,
  'Paid-to-me total aggregates multiple paid items and excludes creator auto-paid split'
);

-- Detail excludes creator split
WITH details AS (
  SELECT public.expenses_get_current_paid_to_me_by_debtor_details(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    (SELECT user_id FROM tmp_users WHERE label = 'debtor')
  ) AS body
)
SELECT is(
  (SELECT jsonb_array_length(body) FROM details),
  2,
  'Debtor detail includes both debtor-paid items only'
);

-- Mark viewed clears unseen
WITH viewed AS (
  SELECT public.expenses_mark_paid_received_viewed_for_debtor(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    (SELECT user_id FROM tmp_users WHERE label = 'debtor')
  ) AS body
)
SELECT is(
  (SELECT (body->>'updated')::int FROM viewed),
  2,
  'Mark paid received returns count of updated rows'
);

WITH list AS (
  SELECT public.expenses_get_current_paid_to_me_debtors(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary')
  ) AS body
)
SELECT is(
  (SELECT (body->0->>'unseenCount')::int FROM list),
  0,
  'Unseen count cleared after marking viewed'
);

-- Calling mark_share_paid again is deduped
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'debtor'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH payload AS (
  SELECT public.expenses_mark_share_paid(
    (SELECT expense_id FROM tmp_expenses WHERE label = 'dinner')
  ) AS body
)
SELECT is(
  (SELECT (body->>'deduped')::boolean FROM payload),
  TRUE,
  'Second mark_share_paid is deduped'
);

SELECT * FROM finish();

ROLLBACK;
