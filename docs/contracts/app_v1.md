# App Contracts v1 — Versioning and Update Policy

Status: Draft for MVP (home-only)

Scope: Client app version checks at startup to determine hard block or soft update recommendation.

```contracts-json
{
  "domain": "app",
  "version": "v1",
  "entities": {
    "AppVersion": {
      "id": "uuid",
      "versionNumber": "text",
      "minSupportedVersion": "text",
      "isCurrent": "boolean",
      "releaseDate": "timestamptz",
      "notes": "text|null"
    }
  },
  "functions": {
    "app.checkVersion": {
      "type": "rpc",
      "auth": "anonymous",
      "impl": "public.check_app_version",
      "args": {"client_version": "text"},
      "returns": "jsonb",
      "semantics": [
        "hardBlocked: client < minSupportedVersion",
        "updateRecommended: client < currentVersion and not hardBlocked"
      ]
    }
  },
  "db": {
    "extensions": ["pgcrypto"],
    "tables": {
      "public.app_version": {
        "indexes": [
          "uq_app_version(version_number)",
          "uq_app_version_is_current_true((true)) WHERE is_current"
        ],
        "constraints": [
          "chk_version_number",
          "chk_min_supported"
        ]
      }
    },
    "functions": {
      "public.check_app_version": {
        "type": "rpc",
        "args": {"client_version": "text"},
        "returns": "jsonb",
        "security": "definer",
        "owner": "postgres",
        "volatility": "stable",
        "nullInput": "returns null on null input",
        "grants": {
          "schemaUsage": ["anon", "authenticated"],
          "execute": ["anon", "authenticated"]
        }
      }
    }
  },
  "rls": [
    {"table": "public.app_version", "rule": "no client access; function-only (RLS enabled; anon/auth revoked)"}
  ]
}
```

## Entities

AppVersion
- id (uuid, PK)
- versionNumber (text, unique; semver x.y.z numeric-only)
- minSupportedVersion (text; semver x.y.z)
- isCurrent (boolean; only one row allowed via partial unique index)
- releaseDate (timestamptz)
- notes (text|null)

## RPCs

app.checkVersion(client_version: text) -> jsonb
- Caller: anonymous or authenticated (public check at startup).
- Returns JSON with keys: clientVersion, currentVersion, minSupportedVersion, hardBlocked, updateRecommended, notes, releasedAt.

## RLS
- public.app_version: no direct client reads/writes; managed by admins and read via RPC only.
