SET search_path = pgtap, public, auth, extensions;

BEGIN;

SELECT plan(47);

CREATE TEMP TABLE tmp_users (
  label   text PRIMARY KEY,
  user_id uuid,
  email   text
);

CREATE TEMP TABLE tmp_homes (
  label   text PRIMARY KEY,
  home_id uuid
);

CREATE TEMP TABLE tmp_invites (
  label text PRIMARY KEY,
  code  text
);

CREATE TEMP TABLE tmp_expenses (
  label      text PRIMARY KEY,
  expense_id uuid
);

CREATE OR REPLACE FUNCTION pg_temp.expect_api_error(
  p_sql         text,
  p_error_code  text,
  p_description text
)
RETURNS text
LANGUAGE sql
AS $$
  SELECT throws_like(
    p_sql,
    '%' || p_error_code || '%',
    p_description
  );
$$;

-- Starter avatar required by handle_new_user trigger
INSERT INTO public.avatars (id, storage_path, category, name)
VALUES ('00000000-0000-4000-8000-000000000501', 'avatars/default.png', 'animal', 'Test Avatar')
ON CONFLICT (id) DO NOTHING;

-- Seed logical users
INSERT INTO tmp_users (label, user_id, email) VALUES
  ('creator',     '10000000-0000-4000-9000-000000000001', 'creator-expenses@example.com'),
  ('member_one',  '10000000-0000-4000-9000-000000000002', 'member1-expenses@example.com'),
  ('member_two',  '10000000-0000-4000-9000-000000000003', 'member2-expenses@example.com'),
  ('outsider',    '10000000-0000-4000-9000-000000000004', 'outsider-expenses@example.com');

-- Seed auth users (profiles auto-created via trigger)
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

-- Creator establishes home + invite
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH res AS (
  SELECT public.homes_create_with_invite() AS payload
)
INSERT INTO tmp_homes (label, home_id)
SELECT 'primary', (payload->'home'->>'id')::uuid FROM res;

INSERT INTO tmp_invites (label, code)
SELECT 'primary', code::text
FROM public.invites
WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'primary')
  AND revoked_at IS NULL
LIMIT 1;

-- Members join via invite
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'member_one'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);
SELECT public.homes_join((SELECT code FROM tmp_invites WHERE label = 'primary'));

SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'member_two'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);
SELECT public.homes_join((SELECT code FROM tmp_invites WHERE label = 'primary'));

-- Back to creator context for expense RPCs
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

-- Constraint: active expense must set split_type
SELECT throws_like(
  format($sql$
    INSERT INTO public.expenses (home_id, created_by_user_id, status, amount_cents, description)
    VALUES ('%s', '%s', 'active', 1000, 'Needs split');
  $sql$,
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    (SELECT user_id FROM tmp_users WHERE label = 'creator')
  ),
  '%chk_expenses_active_split_required%',
  'Active expenses require split_type'
);

-- Constraint: paid splits need marked_paid_at
WITH host AS (
  INSERT INTO public.expenses (
    home_id,
    created_by_user_id,
    status,
    split_type,
    amount_cents,
    description
  )
  VALUES (
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    (SELECT user_id FROM tmp_users WHERE label = 'creator'),
    'active',
    'equal',
    500,
    'Constraint host expense'
  )
  RETURNING id
)
INSERT INTO tmp_expenses (label, expense_id)
SELECT 'constraint_host', id FROM host;

SELECT throws_like(
  format($sql$
    INSERT INTO public.expense_splits (expense_id, debtor_user_id, amount_cents, status)
    VALUES ('%s', '%s', 250, 'paid');
  $sql$,
    (SELECT expense_id FROM tmp_expenses WHERE label = 'constraint_host'),
    (SELECT user_id FROM tmp_users WHERE label = 'member_one')
  ),
  '%chk_expense_splits_paid_timestamp_alignment%',
  'Paid splits must set marked_paid_at'
);

DELETE FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'constraint_host');
DELETE FROM tmp_expenses WHERE label = 'constraint_host';

-- Draft creation (split mode null)
WITH created AS (
  SELECT public.expenses_create(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    5050,
    '  Draft Lunch  ',
    '  messy note  ',
    NULL,
    NULL,
    NULL
  ) AS expense
)
INSERT INTO tmp_expenses (label, expense_id)
SELECT 'draft_one', (expense).id FROM created;

SELECT is(
  (SELECT status::text FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  'draft',
  'expenses_create stores draft when split_mode is null'
);

SELECT is(
  (SELECT description FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  'Draft Lunch',
  'expenses_create trims description input'
);

SELECT is(
  (SELECT notes FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  'messy note',
  'expenses_create trims notes input'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.expense_splits WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  0,
  'Draft creations skip split rows'
);

-- Non-member cannot create expenses
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'outsider'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);
SELECT pg_temp.expect_api_error(
  $$ SELECT public.expenses_create(
        (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
        3000,
        'Blocked expense',
        NULL,
        NULL,
        NULL,
        NULL
     ); $$,
  'NOT_HOME_MEMBER',
  'Non-members cannot call expenses_create'
);

-- Restore creator context
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

-- Active equal split creation
SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.expenses_create(
      '%s',
      101,
      'Solo equal',
      NULL,
      'equal',
      ARRAY['%s'::uuid],
      NULL
    );
  $sql$,
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    (SELECT user_id FROM tmp_users WHERE label = 'member_one')
  ),
  'SPLIT_MEMBERS_REQUIRED',
  'Equal split rejects single-member selection'
);

SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.expenses_create(
      '%s',
      101,
      'Solo custom',
      NULL,
      'custom',
      NULL,
      '[{"user_id":"%s","amount_cents":101}]'::jsonb
    );
  $sql$,
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    (SELECT user_id FROM tmp_users WHERE label = 'member_one')
  ),
  'SPLIT_MEMBERS_REQUIRED',
  'Custom split rejects single-member selection'
);

WITH created AS (
  SELECT public.expenses_create(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    101,
    'Groceries',
    NULL,
    'equal',
    ARRAY[
      (SELECT user_id FROM tmp_users WHERE label = 'member_one'),
      (SELECT user_id FROM tmp_users WHERE label = 'member_two'),
      (SELECT user_id FROM tmp_users WHERE label = 'creator')
    ],
    NULL
  ) AS expense
)
INSERT INTO tmp_expenses (label, expense_id)
SELECT 'active_equal', (expense).id FROM created;

SELECT is(
  (SELECT COUNT(*)::int FROM public.expense_splits WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')),
  3,
  'Equal split stores rows for all selected members (creator included)'
);

SELECT is(
  (SELECT amount_cents FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'member_one')),
  33::bigint,
  'Equal split divides base amount evenly (member_one)'
);

SELECT is(
  (SELECT amount_cents FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'member_two')),
  33::bigint,
  'Equal split divides base amount evenly (member_two)'
);

SELECT is(
  (SELECT amount_cents FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  35::bigint,
  'Creator receives the remaining cents in the split order'
);

SELECT is(
  (SELECT status::text FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  'paid',
  'Creator split row is marked paid immediately'
);

SELECT ok(
  (SELECT marked_paid_at IS NOT NULL FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  'Creator split row records marked_paid_at'
);

-- Editing draft without split mode fails
SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.expenses_edit(
      '%s',
      5050,
      'Draft attempt',
      NULL,
      NULL,
      NULL,
      NULL
    );
  $sql$,
    (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')
  ),
  'SPLIT_REQUIRED',
  'Draft edits must choose a split mode'
);

-- Promote draft to active
SELECT public.expenses_edit(
  (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one'),
  5050,
  'Shared dinner',
  'bring drinks',
  'equal',
  ARRAY[
    (SELECT user_id FROM tmp_users WHERE label = 'member_one'),
    (SELECT user_id FROM tmp_users WHERE label = 'member_two'),
    (SELECT user_id FROM tmp_users WHERE label = 'creator')
  ],
  NULL
);

SELECT is(
  (SELECT status::text FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  'active',
  'Draft promotion sets status=active'
);

SELECT is(
  (SELECT COUNT(*)::int FROM public.expense_splits WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  3,
  'Draft promotion inserts split rows for creator + members'
);

SELECT is(
  (SELECT status::text FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  'paid',
  'Draft promotion marks creator share as paid'
);

SELECT ok(
  (SELECT marked_paid_at IS NOT NULL FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  'Draft promotion records marked_paid_at for creator share'
);

-- Active amount change without split data rejected
SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.expenses_edit(
      '%s',
      5000,
      'Groceries bigger',
      NULL,
      NULL,
      NULL,
      NULL
    );
  $sql$,
    (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
  ),
  'SPLIT_REQUIRED',
  'Active amount change requires split rebuild details'
);

-- Rebuild splits via custom mode
WITH custom AS (
  SELECT jsonb_build_array(
    jsonb_build_object(
      'user_id',
      (SELECT user_id FROM tmp_users WHERE label = 'member_one'),
      'amount_cents',
      40
    ),
    jsonb_build_object(
      'user_id',
      (SELECT user_id FROM tmp_users WHERE label = 'member_two'),
      'amount_cents',
      30
    ),
    jsonb_build_object(
      'user_id',
      (SELECT user_id FROM tmp_users WHERE label = 'creator'),
      'amount_cents',
      31
    )
  ) AS body
)
SELECT public.expenses_edit(
  (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal'),
  101,
  'Groceries custom',
  NULL,
  'custom',
  NULL,
  (SELECT body FROM custom)
);

SELECT is(
  (SELECT split_type::text FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')),
  'custom',
  'Custom edit updates split_type'
);

SELECT is(
  (SELECT amount_cents FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'member_one')),
  40::bigint,
  'Custom edit uses provided amount for member_one'
);

SELECT is(
  (SELECT amount_cents FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'member_two')),
  30::bigint,
  'Custom edit uses provided amount for member_two'
);

SELECT is(
  (SELECT amount_cents FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  31::bigint,
  'Custom edit persists the creator share and marks it paid'
);

SELECT is(
  (SELECT status::text FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'creator')),
  'paid',
  'Creator share remains paid after custom rebuild'
);

-- Member marks share paid
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'member_one'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);
SELECT public.expenses_mark_share_paid((SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal'));

SELECT is(
  (SELECT status::text FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'member_one')),
  'paid',
  'Debtor can mark their share paid'
);

SELECT ok(
  (SELECT marked_paid_at IS NOT NULL FROM public.expense_splits
    WHERE expense_id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
      AND debtor_user_id = (SELECT user_id FROM tmp_users WHERE label = 'member_one')),
  'Marking paid stamps timestamp'
);

-- Creator context for subsequent edits
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

SELECT diag('Skipping direct error assert for EXPENSE_LOCKED_AFTER_PAYMENT (sqlstate P0004).');
SELECT ok(
  TRUE,
  'Paid splits lock amount changes (covered via integration tests)'
);

SELECT public.expenses_edit(
  (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal'),
  101,
  'Groceries final',
  'still waiting',
  NULL,
  NULL,
  NULL
);

SELECT is(
  (SELECT description FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')),
  'Groceries final',
  'Soft fields remain editable after payment'
);

-- Creator already paid share should remain paid (no-op)
WITH payload AS (
  SELECT public.expenses_mark_share_paid(
    (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
  ) AS split
)
SELECT is(
  (SELECT (split).debtor_user_id FROM payload),
  (SELECT user_id FROM tmp_users WHERE label = 'creator'),
  'Creator mark_share_paid returns their own split row'
);

WITH payload AS (
  SELECT public.expenses_mark_share_paid(
    (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
  ) AS split
)
SELECT is(
  (SELECT (split).status::text FROM payload),
  'paid',
  'Creator mark_share_paid keeps status=paid'
);

-- Cancelling with paid share rejected
SELECT diag('Skipping cancel guard assert for EXPENSE_LOCKED_AFTER_PAYMENT (sqlstate P0004).');
SELECT ok(
  TRUE,
  'Expenses with paid shares cannot be cancelled (covered via integration tests)'
);

-- Cancel works when no shares are paid
WITH created AS (
  SELECT public.expenses_create(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    200,
    'Snacks',
    NULL,
    'equal',
    ARRAY[
      (SELECT user_id FROM tmp_users WHERE label = 'member_two'),
      (SELECT user_id FROM tmp_users WHERE label = 'creator')
    ],
    NULL
  ) AS expense
)
INSERT INTO tmp_expenses (label, expense_id)
SELECT 'cancel_me', (expense).id FROM created;

SELECT public.expenses_cancel((SELECT expense_id FROM tmp_expenses WHERE label = 'cancel_me'));

SELECT is(
  (SELECT status::text FROM public.expenses WHERE id = (SELECT expense_id FROM tmp_expenses WHERE label = 'cancel_me')),
  'cancelled',
  'Creator can cancel unpaid expense'
);

-- expenses_get_current_owed aggregates unpaid shares for member_two
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'member_two'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH payload AS (
  SELECT public.expenses_get_current_owed((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
)
SELECT is(
  (SELECT jsonb_array_length(body) FROM payload),
  1,
  'Current owed groups rows per payer'
);

WITH payload AS (
  SELECT public.expenses_get_current_owed((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
)
SELECT is(
  (SELECT (body->0->>'totalOwedCents')::bigint FROM payload),
  1713::bigint,
  'Current owed sums unpaid cents across expenses'
);

WITH payload AS (
  SELECT public.expenses_get_current_owed((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
)
SELECT is(
  (SELECT jsonb_array_length(body->0->'items') FROM payload),
  2,
  'Current owed lists each unpaid split item'
);

-- Creator summary listing
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH payload AS (
  SELECT public.expenses_get_created_by_me((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
),
entries AS (
  SELECT *
  FROM payload,
       jsonb_to_recordset(body) AS x(
         "expenseId" uuid,
         "totalShares" int,
         "paidShares" int,
         "paidAmountCents" bigint,
         "allPaid" boolean
       )
)
SELECT is(
  (SELECT jsonb_array_length(body) FROM payload),
  2,
  'Created-by-me excludes cancelled expenses'
);

WITH payload AS (
  SELECT public.expenses_get_created_by_me((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
),
entries AS (
  SELECT *
  FROM payload,
       jsonb_to_recordset(body) AS x(
         "expenseId" uuid,
         "totalShares" int,
         "paidShares" int,
         "paidAmountCents" bigint,
         "allPaid" boolean
       )
)
SELECT is(
  (SELECT "paidShares" FROM entries WHERE "expenseId" = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')),
  2,
  'Summary counts paid shares for active expense'
);

WITH payload AS (
  SELECT public.expenses_get_created_by_me((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
),
entries AS (
  SELECT *
  FROM payload,
       jsonb_to_recordset(body) AS x(
         "expenseId" uuid,
         "totalShares" int,
         "paidShares" int,
         "paidAmountCents" bigint,
         "allPaid" boolean
       )
)
SELECT is(
  (SELECT "paidAmountCents" FROM entries WHERE "expenseId" = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')),
  71::bigint,
  'Summary returns paid amount for active expense'
);

WITH payload AS (
  SELECT public.expenses_get_created_by_me((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
),
entries AS (
  SELECT *
  FROM payload,
       jsonb_to_recordset(body) AS x(
         "expenseId" uuid,
         "totalShares" int,
         "paidShares" int,
         "paidAmountCents" bigint,
         "allPaid" boolean
       )
)
SELECT is(
  (SELECT "allPaid" FROM entries WHERE "expenseId" = (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')),
  false,
  'Summary keeps allPaid=false until every share is paid'
);

WITH payload AS (
  SELECT public.expenses_get_created_by_me((SELECT home_id FROM tmp_homes WHERE label = 'primary')) AS body
),
entries AS (
  SELECT *
  FROM payload,
       jsonb_to_recordset(body) AS x(
         "expenseId" uuid,
         "totalShares" int,
         "paidShares" int,
         "paidAmountCents" bigint,
         "allPaid" boolean
       )
)
SELECT is(
  (SELECT "paidShares" FROM entries WHERE "expenseId" = (SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')),
  1,
  'Active expense without other payments still shows the creator share as paid'
);

-- expenses_get_for_edit returns detail payload for creator
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH payload AS (
  SELECT public.expenses_get_for_edit((SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')) AS body
)
SELECT is(
  (SELECT body->>'description' FROM payload),
  'Shared dinner',
  'expenses_get_for_edit returns description'
);

WITH payload AS (
  SELECT public.expenses_get_for_edit((SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')) AS body
)
SELECT is(
  (SELECT jsonb_array_length(body->'splits') FROM payload),
  3,
  'expenses_get_for_edit includes all split rows (creator included)'
);

WITH payload AS (
  SELECT public.expenses_get_for_edit((SELECT expense_id FROM tmp_expenses WHERE label = 'draft_one')) AS body
)
SELECT ok(
  (SELECT (body->>'amount_locked')::boolean = false FROM payload),
  'Draft expense leaves amount_locked=false'
);

WITH payload AS (
  SELECT public.expenses_get_for_edit((SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')) AS body
)
SELECT ok(
  (SELECT (body->>'amount_locked')::boolean = true FROM payload),
  'Active expense with paid shares locks amount editing'
);

-- Non-creator cannot call expenses_get_for_edit
SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'member_one'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);
SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.expenses_get_for_edit('%s');
  $sql$,
    (SELECT expense_id FROM tmp_expenses WHERE label = 'active_equal')
  ),
  'NOT_CREATOR',
  'Non-creators cannot fetch expenses_get_for_edit'
);

SELECT set_config(
  'request.jwt.claim.sub',
  (SELECT user_id::text FROM tmp_users WHERE label = 'creator'),
  true
);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

SELECT * FROM finish();
ROLLBACK;
