# Flow — Logout

Contract: v1 (see `docs/contracts/users_v1.md`)
Diagram: `docs/diagrams/user/logout.md`

## Preconditions
- User is authenticated.

## Postconditions
- Local session cleared; user navigated to Welcome.

## Flow (Given/When/Then)
Given an authenticated user
When they tap Logout
Then the app calls `auth.signOut`, clears local session/cache, and returns to Welcome

## Steps
1. Invoke Supabase `auth.signOut()`.
2. Clear local caches/session.
3. Navigate to Welcome.

## Error Cases
- Sign-out call fails transiently: show error and allow retry.

## Test Plan Map
- Successful logout clears session and navigates to Welcome.
- Error during sign-out handled gracefully, no stale session remains.

