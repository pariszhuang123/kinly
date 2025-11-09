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
      "email": "text|null",
      "displayName": "text|null",
      "avatarId": "uuid",
      "deactivatedAt": "timestamptz|null"
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
        "user_profile: email=NULL, displayName=NULL, avatarId=keep, deactivatedAt=now()"
      ],
      "calls": ["homes.transferOwner"]
    }
  },
  "rls": [
    {"table": "user_profile", "rule": "deny when deactivatedAt IS NOT NULL"}
  ]
}
```

## Entities

UserProfile
- id (uuid, PK; equals Supabase Auth user id)
- email (text, nullable)
- displayName (text, nullable)
- avatarId (uuid, FK -> avatars.id)
- createdAt (timestamp)
- updatedAt (timestamp)
- deactivatedAt (timestamp, NULL if active)

Avatar
- id (uuid, PK)
- key (text, UNIQUE)  // optional human-friendly slug
- image (text)
- createdAt (timestamp)
- updatedAt (timestamp)

## Invariants
- Active user iff `deactivatedAt IS NULL`.
- If `deactivatedAt IS NOT NULL`, RLS denies all reads/writes for this user.
- `UserProfile.id` must always match the Auth user id.
- `UserProfile.avatarId` references `avatars.id`.
- Default: on user creation, `avatarId` is set to a seeded default avatar UUID; all users begin linked to the same default avatar until they change it.
- Member avatar uniqueness is enforced per home (see avatar uniqueness flow); `UserProfile.avatarId` is a preference and may differ from the final per-home assignment when conflicts exist.

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
  - Anonymize `user_profile`: set `email` and `displayName` to NULL per policy; set `deactivatedAt=now()`; keep `avatarId` unchanged.
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
- `user_profile`: users may read/update their own row only when `deactivatedAt IS NULL`.
- Edge Function uses service role; RLS still applies to client paths; function enforces self-only semantics.

## Test Plan Map
- Active vs. deactivated user access is enforced by RLS.
- Owned homes with other active members: ownership auto-transfers to the earliest active member; function proceeds.
- Owned homes with no other active members are deactivated during deletion; membership closed.
- Non-owned memberships closed during deletion.
- On creation, `avatarId` is set to the default avatar UUID.
