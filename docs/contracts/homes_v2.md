# Kinly Contracts v2 — Home MVP (membership stints)

Status: Draft for alignment with new SQL

Scope: Align contracts with the new homes/memberships/invites migration introducing append‑only membership stints and invite code details.

## Entities

Home
- id
- ownerUserId
- createdAt
- updatedAt
- isActive            // true until last member leaves
- deactivatedAt       // set when last active member leaves

Membership
- id                  // unique stint id
- userId
- homeId
- role (owner|member)
- validFrom           // inclusive start
- validTo             // exclusive end; NULL = current
- isCurrent           // derived in DB; exposed to clients
- createdAt
- updatedAt

Invite
- id
- homeId
- code                // CITEXT; Crockford Base32 (6 chars)
- revokedAt           // NULL = active; set if owner rotates/revokes
- usedCount           // total times used (analytics)
- createdAt

```contracts-json
{
  "domain": "homes",
  "version": "v2",
  "entities": {
    "Home": {
      "id": "uuid",
      "ownerUserId": "uuid",
      "createdAt": "timestamptz",
      "updatedAt": "timestamptz",
      "isActive": "boolean",
      "deactivatedAt": "timestamptz|null"
    },
    "Membership": {
      "id": "uuid",
      "userId": "uuid",
      "homeId": "uuid",
      "role": "text",
      "validFrom": "timestamptz",
      "validTo": "timestamptz|null",
      "isCurrent": "boolean",
      "createdAt": "timestamptz",
      "updatedAt": "timestamptz"
    },
    "Invite": {
      "id": "uuid",
      "homeId": "uuid",
      "code": "citext",
      "revokedAt": "timestamptz|null",
      "usedCount": "int4",
      "createdAt": "timestamptz"
    }
  },
  "functions": {
    "homes.create": {"type": "rpc", "caller": "authenticated"},
    "homes.join": {"type": "rpc", "caller": "authenticated"},
    "homes.transferOwner": {"type": "rpc", "caller": "owner-only"},
    "homes.leave": {"type": "rpc", "caller": "member"},
    "invites.getOrCreate": {"type": "rpc", "caller": "owner-only"},
    "invites.revoke": {"type": "rpc", "caller": "owner-only"},
    "invites.rotate": {"type": "rpc", "caller": "owner-only"},
    "members.listActiveByHome": {"type": "rpc", "caller": "member"},
    "members.listByHome": {"type": "rpc", "caller": "member"}
  },
  "rls": [
    {"table": "homes", "rule": "inactive home denied"},
    {"table": "memberships", "rule": "member allowed; non-member denied"},
    {"table": "invites", "rule": "no client access; RPC-only"}
  ]
}
```

## RPCs / Endpoints

homes.create()
- Creates a home; caller becomes owner and a current membership stint (role=owner).
 - DB Impl: `public.homes_create`

invites.getOrCreate(homeId)
- Returns the current active invite for the home, or creates one if none exists.
- No ttl/maxUses; permanent until revoked or home deactivated.
- Caller: owner-only. Idempotent.
- Behavior:
  - If an active invite exists (revokedAt IS NULL and home.isActive = true), returns it unchanged.
  - If none exists and the home is active, inserts a new invite row (revokedAt = NULL) and returns it.
  - If the home is inactive, returns an error (forbidden/inactive).
 - DB Impl: `public.invites_get_or_create`

invites.revoke(homeId)
- Revokes the current active invite (disable without replacement).
 - DB Impl: `public.invites_revoke`

invites.rotate(homeId)
- Atomically revokes the current active invite (if any) and issues a new invite with a fresh unique code.
- Returns the new active invite for immediate sharing.
 - DB Impl: `public.invites_rotate`

homes.join(code)
- Joins the home for the caller using invite code.
- Guards:
  - home.isActive = true
  - invite.revokedAt IS NULL
  - user has no other current membership (unique partial index enforces)
 - DB Impl: `public.homes_join`

homes.transferOwner(homeId, newOwnerId)
- Transfers ownership (both users must be current members).
 - DB Impl: `public.homes_transfer_owner`

homes.leave(homeId)
- Closes caller’s current membership stint (sets validTo = now()).
- If that was the last current member:
  - home.isActive = false
  - home.deactivatedAt = now()
 - DB Impl: `public.homes_leave`

members.listActiveByHome(homeId)
- Lists current members only (isCurrent = true).
 - DB Impl: `public.members_list_active_by_home`

members.listByHome(homeId)
- Lists all historical membership stints (current + past).
 - DB Impl: `public.members_list_by_home`

## Errors
- Format: exceptions include JSON message `{ code, message, details }` and SQLSTATE maps to HTTP.
- Codes:
  - UNAUTHORIZED → 401 (28000): Authentication required.
  - FORBIDDEN_OWNER_ONLY → 403 (42501): Owner-only operation (or home inactive where noted).
  - HOMES_NOT_MEMBER → 403 (42501): Caller is not a current member of the home.
  - OWNER_TRANSFER_REQUIRED → 403 (42501): Owner must transfer before leaving.
  - INVITE_INVALID → 400 (22023): Invite not found, revoked, or home inactive.
  - MEMBERSHIP_ALREADY_ACTIVE → 409 (23505): User already has a current membership.
  - INVALID_NEW_OWNER → 400 (22023): New owner id invalid (null/self).
  - NEW_OWNER_NOT_MEMBER → 400 (22023): New owner is not a current member of the home.
- Client handling: parse error.message as JSON; route UX by `code` with HTTP as fallback.

## Invariants & Constraints
- A user has at most one current membership across all homes (partial unique index on memberships where is_current = true).
- Only one current owner per home (partial unique index on (home_id) where is_current AND role = 'owner').
- No overlapping stints for the same (user, home) via GiST exclusion on (user_id, home_id, validity &&).
- Invite code is unique; six characters Crockford Base32 (no I/O/0/1); stored as CITEXT.
- An invite is valid only if its home is active and the invite is not revoked.
- No direct client reads/writes on invites; access via RPCs.

## Versioning
- v2 supersedes v1 for memberships and invites. Breaking due to replacing Member with Membership and changing Invite fields.
- Repositories and BLoC should pin to v2.

## Related
- Migration: `supabase/migrations/20251111225015_home_membership_invites_table.sql`

