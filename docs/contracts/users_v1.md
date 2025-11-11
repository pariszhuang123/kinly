# Users Contracts v1 — Auth and Lifecycle

Status: Draft for MVP (home-only)

Scope: User authentication via Supabase OAuth (Google, Apple), logout, and account deletion (self-service Edge Function, soft-delete/anonymize PII).

```contracts-json
{
  "domain": "users",
  "version": "v1",
  "entities": {
    "UserProfile": {
      "id": "uuid",
      "email": "text",
      "fullName": "text|null",
      "username": "citext",
      "avatarId": "uuid",
      "createdAt": "timestamptz",
      "updatedAt": "timestamptz",
      "deactivatedAt": "timestamptz|null"
    },
    "Avatar": {
      "id": "uuid",
      "storagePath": "text",
      "category": "text",
      "name": "text",
      "createdAt": "timestamptz"
    },
    "ReservedUsername": {
      "name": "citext"
    }
  },
  "functions": {
    "users.selfDelete": {
      "type": "edge",
      "auth": "service-role (self-only)",
      "order": ["db-first", "anonymize", "auth-delete"],
      "effects": [
        "auto-transfer-owned-homes-or-deactivate",
        "close-nonowner-memberships",
        "user_profile: email=NULL, fullName=NULL, avatarId=keep, username=keep"
      ],
      "calls": ["homes.transferOwner"]
    }
  },
  "rls": [
    {"table": "public.profiles", "rule": "SELECT own row only; client writes revoked (triggers/RPC only)"},
    {"table": "public.avatars", "rule": "SELECT allowed for authenticated users"},
    {"table": "public.reserved_usernames", "rule": "no client access; RLS enabled; anon/auth revoked"}
  ]
}
```

## Entities

UserProfile
- id (uuid, PK; equals Supabase Auth user id)
- email (text, not null)
- fullName (text, nullable)
- username (citext, globally unique, case-insensitive; 3–30 chars, start/end alphanumeric, dots/underscores allowed between)
- avatarId (uuid, FK -> avatars.id)
- createdAt (timestamptz)
- updatedAt (timestamptz)
- deactivatedAt (timestamptz, NULL if active)

Avatar
- id (uuid, PK)
- storagePath (text)
- category (text; allowed: 'animal' | 'plant')
- name (text)
- createdAt (timestamptz)

ReservedUsername
- name (citext, PK). Case-insensitive reserved handles that cannot be claimed by users.

## Naming Conventions
- Database uses snake_case; contracts/DTOs use camelCase.
- Repositories map DB → domain model so BLoC/UI only see camelCase.
- Field mapping examples:
  - createdAt ↔ created_at
  - updatedAt ↔ updated_at
  - fullName ↔ full_name
  - avatarId ↔ avatar_id
  - storagePath ↔ storage_path
  - username ↔ username (1:1)

## Invariants
- `UserProfile.id` must always match the Auth user id.
- `UserProfile.avatarId` references `avatars.id`.
- On user creation, `avatarId` defaults to a seeded/first avatar.
- Member avatar uniqueness may be enforced per home (see avatar uniqueness flow); `UserProfile.avatarId` is a preference and may differ from per-home assignment if conflicts exist.
- `UserProfile.username` is globally unique (case-insensitive CITEXT), validated by regex `^[a-z0-9](?:[a-z0-9._]{1,28})[a-z0-9]$`; values in `public.reserved_usernames` cannot be claimed.
- On self delete, `username` is kept (not anonymized) so it can be displayed in gratitude/history views.

## RPCs / Edge Functions

users.selfDelete()
- Caller: authenticated user (must delete self only). Runs as service role inside Edge Function.
- Ordering: perform DB updates first, then Auth deletion (idempotent; safe to retry Auth deletion step).
- Automatic owner transfer:
  - For each home the caller owns and that has other active members, automatically transfer ownership to a deterministic active member:
    - Selection: the active member (leftAt IS NULL) with the earliest `members.createdAt` (ties broken by lowest `userId`, UUID lexical order).
    - Implementation: call `homes.transferOwner(homeId, newOwnerId)`.
- DB changes:
  - Owned homes with no other active members: set `home.isActive=false`, set `home.deactivatedAt=now()`, set owner membership `leftAt=now()`.
  - Non-owned active memberships: set `leftAt=now()`.
  - Anonymize `user_profile`: set `email` and `full_name` to NULL; set `deactivated_at=now()`; keep `avatar_id` and `username` unchanged.
- Finally, delete the Auth user.
- Audit: write an audit row with `userId`, timestamp, homes affected, and action result; rate-limit to prevent abuse.

## Guards
- Self-only: function deletes only the caller's account (`auth.user().id`).
- Ownership and membership resolution is enforced automatically before deletion:
  - If the user owns a home and other active members exist, the function transfers ownership to the selected active member (based on who had joined the app the earliest) and proceeds.
  - If the user owns a home and no other active members exist, deletion deactivates the home (sets `home.isActive=false`, `deactivatedAt=now()`), and closes the owner membership (`leftAt=now()`).
  - For homes where the user is a non-owner active member, deletion closes the membership (`leftAt=now()`).
- Deactivated users cannot authenticate or access data.

## RLS (Overview)
- `public.profiles`: authenticated users may SELECT their own row only; client writes revoked (triggers/RPCs handle writes).
- `public.avatars`: authenticated users may SELECT.
- `public.reserved_usernames`: no client access; RLS enabled; anon/auth revoked.
- Edge Function uses service role; RLS still applies to client paths; function enforces self-only semantics.

## Test Plan Map
- Active vs. deactivated user access is enforced by RLS.
- Owned homes with other active members: ownership auto-transfers to the earliest active member; function proceeds.
- Owned homes with no other active members are deactivated during deletion; membership closed.
- Non-owned memberships closed during deletion.
- On creation, `avatarId` is set to the default avatar UUID.
- Username:
  - Auto-generated, unique, lowercase, matches format; reserved names blocked.
  - On self delete, username remains visible in downstream views (e.g., gratitude table).

