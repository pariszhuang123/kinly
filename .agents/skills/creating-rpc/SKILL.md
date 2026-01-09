---
name: creating-rpc
description: Creates Supabase RPCs with migrations, RLS, repository integration, and pgTAP tests. Use when asked to create an RPC, add a database function, or implement a new backend endpoint.
---

# Creating RPCs

Step-by-step workflow for creating Supabase RPCs in Kinly.

## Prerequisites

Before starting, read:
- `AGENTS.md` § Contracts — understand entity schemas
- `docs/architecture/di_graph.md` — dependency direction

## Workflow Overview

```
1. Contract → 2. Migration → 3. RLS (if new table) → 4. Repository → 5. Tests → 6. Verify
```

---

## Step 1: Define the Contract

Add or update the RPC signature in `AGENTS.md` § Contracts:

```markdown
- <domain>.<action>(params) -> Returns description. Guards:
  - guard 1
  - guard 2
```

**Naming convention:** `<domain>_<action>` in SQL, e.g., `homes_join`, `chores_create`, `expenses_edit`

---

## Step 2: Create Migration

Create file: `supabase/migrations/<timestamp>_<descriptive_name>.sql`

### RPC Template

```sql
----------------------------------------------------------------------
-- RPC: <domain>_<action>
----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.<domain>_<action>(
  p_param_one   uuid,
  p_param_two   text DEFAULT NULL
)
RETURNS <return_type>
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_row     public.<table_name>;
BEGIN
  -- 1. Authentication check
  PERFORM public._assert_authenticated();

  -- 2. Membership/authorization check
  PERFORM public._assert_home_member(p_home_id);

  -- 3. Input validation
  IF COALESCE(btrim(p_param_two), '') = '' THEN
    PERFORM public.api_error(
      'INVALID_INPUT',
      'Field is required.',
      '22023',
      jsonb_build_object('field', 'param_two')
    );
  END IF;

  -- 4. Business logic guards (use api_assert for boolean checks)
  PERFORM public.api_assert(
    EXISTS (SELECT 1 FROM ... WHERE ...),
    'ERROR_CODE',
    'Human-readable message.',
    '42501',
    jsonb_build_object('key', 'value')
  );

  -- 5. Paywall/quota check (if applicable)
  PERFORM public._home_assert_quota(
    p_home_id,
    jsonb_build_object('active_items', 1)
  );

  -- 6. DML operation
  INSERT INTO public.<table> (...)
  VALUES (...)
  RETURNING * INTO v_row;

  -- 7. Usage tracking (if applicable)
  PERFORM public._home_usage_apply_delta(
    p_home_id,
    jsonb_build_object('active_items', 1)
  );

  RETURN v_row;
END;
$$;
```

### Key Patterns

| Pattern | Helper | When to Use |
|---------|--------|-------------|
| Auth required | `_assert_authenticated()` | Every authenticated RPC |
| Member check | `_assert_home_member(home_id)` | Any home-scoped operation |
| Input validation | `api_error(code, msg, sqlstate, details)` | Invalid input |
| Boolean guard | `api_assert(condition, code, msg, sqlstate, details)` | Authorization checks |
| Quota check | `_home_assert_quota(home_id, deltas)` | Creating countable items |
| Usage tracking | `_home_usage_apply_delta(home_id, deltas)` | After successful create/delete |

### Error Codes

Use consistent error codes:
- `INVALID_INPUT` — validation failures
- `NOT_HOME_MEMBER` — membership check failed
- `HOME_INACTIVE` — home is deactivated
- `UNAUTHORIZED` — permission denied
- `QUOTA_EXCEEDED` — paywall limit hit
- `NOT_FOUND` — resource doesn't exist

---

## Step 3: Add RLS Policies (if new table)

In the same or separate migration:

```sql
ALTER TABLE public.<table> ENABLE ROW LEVEL SECURITY;

-- SELECT: members can read their home's data
CREATE POLICY "<table>_select_member"
ON public.<table>
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM public.memberships m
    WHERE m.home_id = <table>.home_id
      AND m.user_id = auth.uid()
      AND m.is_current = TRUE
  )
);

-- INSERT/UPDATE/DELETE: typically via RPC only (SECURITY DEFINER)
-- Add policies only if direct access is needed
```

---

## Step 4: Create Repository Interface + Implementation

### 4a. Contract Interface (`lib/contracts/<domain>/ports/<domain>_repository.dart`)

```dart
abstract class <Domain>Repository {
  Future<<ReturnType>> <action>({
    required String paramOne,
    String? paramTwo,
  });
}
```

### 4b. Supabase Implementation (`lib/features/<domain>/data/supabase/supabase_<domain>_repository.dart`)

```dart
import 'package:kinly/contracts/<domain>/models.dart';
import 'package:kinly/core/supabase/supabase_error_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Supabase<Domain>Repository implements <Domain>Repository {
  Supabase<Domain>Repository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<<ReturnType>> <action>({
    required String paramOne,
    String? paramTwo,
  }) async {
    try {
      final response = await _client.rpc(
        '<domain>_<action>',
        params: {
          'p_param_one': paramOne,
          if (paramTwo != null) 'p_param_two': paramTwo,
        },
      );
      return <ReturnType>.fromJson(
        (response as Map).cast<String, dynamic>(),
      );
    } catch (error) {
      throw SupabaseErrorMapper.map<Action>(error);
    }
  }
}
```

### 4c. Error Mapper (`lib/core/supabase/supabase_error_mapper.dart`)

Add a mapping method for the new RPC's error codes:

```dart
static Exception map<Action>(Object error) {
  final code = _extractCode(error);
  return switch (code) {
    'INVALID_INPUT' => InvalidInputException(_extractMessage(error)),
    'NOT_HOME_MEMBER' => NotMemberException(),
    _ => UnknownException(error.toString()),
  };
}
```

---

## Step 5: Write pgTAP Tests

Create file: `supabase/tests/<domain>_<feature>.sql`

### Test Template

```sql
SET search_path = pgtap, public, auth, extensions;

BEGIN;

SELECT no_plan();

-- ============================================================
-- FIXTURES
-- ============================================================

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

-- Error assertion helper
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

-- Seed starter avatars (required by handle_new_user trigger)
INSERT INTO public.avatars (id, storage_path, category, name)
VALUES ('00000000-0000-4000-8000-000000000001', 'avatars/default.png', 'animal', 'Test Avatar')
ON CONFLICT (id) DO NOTHING;

-- Seed test users
INSERT INTO tmp_users (label, user_id, email) VALUES
  ('owner',    '10000000-0000-4000-9000-000000000001', 'owner@test.com'),
  ('member',   '10000000-0000-4000-9000-000000000002', 'member@test.com'),
  ('outsider', '10000000-0000-4000-9000-000000000003', 'outsider@test.com');

INSERT INTO auth.users (id, instance_id, email, raw_user_meta_data, raw_app_meta_data, aud, role, encrypted_password)
SELECT user_id, '00000000-0000-0000-0000-000000000000'::uuid, email,
       '{}'::jsonb, '{"provider":"email"}'::jsonb, 'authenticated', 'authenticated', 'secret'
FROM tmp_users
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- SETUP: Create home + members
-- ============================================================

SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'owner'), true);
SELECT set_config('request.jwt.claim.role', 'authenticated', true);

WITH res AS (SELECT public.homes_create_with_invite() AS payload)
INSERT INTO tmp_homes (label, home_id)
SELECT 'primary', (payload->'home'->>'id')::uuid FROM res;

INSERT INTO tmp_invites (label, code)
SELECT 'primary', code::text
FROM public.invites
WHERE home_id = (SELECT home_id FROM tmp_homes WHERE label = 'primary')
  AND revoked_at IS NULL
LIMIT 1;

-- Member joins
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'member'), true);
SELECT public.homes_join((SELECT code FROM tmp_invites WHERE label = 'primary'));

-- ============================================================
-- TESTS
-- ============================================================

-- Test: Happy path
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'owner'), true);
SELECT is(
  (SELECT public.<domain>_<action>(
    (SELECT home_id FROM tmp_homes WHERE label = 'primary'),
    'test value'
  )).id IS NOT NULL,
  true,
  'Owner can call <action> successfully'
);

-- Test: Non-member denied
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'outsider'), true);
SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.<domain>_<action>('%s', 'test');
  $sql$, (SELECT home_id FROM tmp_homes WHERE label = 'primary')),
  'NOT_HOME_MEMBER',
  'Non-member cannot call <action>'
);

-- Test: Invalid input
SELECT set_config('request.jwt.claim.sub', (SELECT user_id::text FROM tmp_users WHERE label = 'owner'), true);
SELECT pg_temp.expect_api_error(
  format($sql$
    SELECT public.<domain>_<action>('%s', '');
  $sql$, (SELECT home_id FROM tmp_homes WHERE label = 'primary')),
  'INVALID_INPUT',
  'Empty input rejected'
);

-- ============================================================
-- CLEANUP
-- ============================================================

SELECT * FROM finish();

ROLLBACK;
```

---

## Step 6: Verify

```bash
# Run all checks
dart run tool/check_all.dart

# Run specific test
supabase test db --linked -- supabase/tests/<domain>_<feature>.sql

# Or run all DB tests
supabase test db --linked
```

---

## Checklist

- [ ] Contract added to AGENTS.md § Contracts
- [ ] Migration created with `CREATE OR REPLACE FUNCTION`
- [ ] Uses `SECURITY DEFINER` + `SET search_path = ''`
- [ ] Calls `_assert_authenticated()` first
- [ ] Calls `_assert_home_member()` for home-scoped RPCs
- [ ] Uses `api_error()` / `api_assert()` for validation
- [ ] Uses `_home_assert_quota()` before creating countable items
- [ ] Uses `_home_usage_apply_delta()` after successful mutations
- [ ] Repository interface defined in `lib/contracts/`
- [ ] Supabase implementation uses `SupabaseErrorMapper`
- [ ] pgTAP test covers: happy path, non-member denied, invalid input
- [ ] `dart run tool/check_all.dart` passes
- [ ] `supabase test db --linked` passes
