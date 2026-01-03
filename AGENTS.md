# Kinly — Multi‑Agent Development Guide

Scope: Entire repository

This document defines roles, boundaries, workflows, guardrails, and the Definition of Done (DoD) for the Home‑only MVP of Kinly.

## Roles
- Planner: Owns backlog, scope, and cross‑agent sequencing. Approves high‑impact changes.
- Flutter UI: Screens, widgets, navigation, i18n. Consumes BLoC only.
- Flutter BLoC: Business logic and state. Consumes repositories only.
- Supabase/DB: Schema, RLS, RPCs, indexes, migrations. Co‑owns DTOs/contracts.
- Deep Linking: Universal links/QR flows and navigation mapping.
- Test: Test strategy, fixtures, coverage gates, RLS and RPC tests.
- Docs: Maintains AGENTS.md, ADRs, PR templates, and developer docs.
- Release: CI/CD, build artifacts, signing, lanes, and environment configs.

## Boundaries & Ownership
- UI → BLoC only.
- BLoC → Repositories only.
- Repositories → Supabase (RPC/PostgREST) + deep-link adapter.
- Schemas & migrations → Supabase/DB (review by Planner + Test).
- Contracts/DTOs → Supabase/DB + Repositories co-own (versioned).
- CI/infra → Release (Planner approves changes).
- Accessibility → Design System + UI co-own implementation; Planner approves contract changes.
- Foundation surfaces (Today/Explore/Hub/Profile) live under `lib/foundation/surfaces/**` and must not import `lib/features/**`.
- Router composition root lives in `lib/app/router/**`; only router may import feature UI screens for navigation composition.
- Cross-feature imports are forbidden; use registries + `lib/contracts/**` for shared types.

## MVP Scope (Home‑only)
- Auth (Supabase OAuth: Google/Apple)
- Homes: Create a home, join via code or deep link, transfer ownership, and leave (home is soft-deleted when the last member leaves).
- Invites: Permanent invite codes or links that remain valid as long as the home is active. When all members leave and the home is deactivated, the invite automatically becomes invalid.
- Navigation: Welcome → Create/Join → Enter Code → Today (placeholder)
- i18n: Flutter intl scaffold; English + placeholder second locale
- Platforms: Android + iOS (parity; no platform‑specific logic)

## Definition of Done (DoD)
- Tests: BLoC + repository unit tests for Auth and Home flows
- Widget: ≥1 per screen (Welcome, Create, Join, Today)
- RLS tests: member allowed, non‑member denied, inactive home denied
- Edge Function / RPC tests: invite create, join, transfer, leave
- Artifacts: Screenshots/GIFs for happy paths
- CI green: format, lint, tests, build
- i18n: All UI strings via `S.of(context)`

## Contracts (Frozen when merged)
Entities:

- Home {
    id,
    name,
    ownerUserId,
    createdBy,
    createdAt,
    updatedAt,
    isActive,           // true until last member leaves
    deactivatedAt       // set when last active member leaves
  }

- Membership {
    id,                 // unique stint id
    userId,
    homeId,
    role (owner|member),
    validFrom,          // inclusive start
    validTo,            // exclusive end; NULL = current
    isCurrent,          // derived in DB; exposed to clients
    createdAt,
    updatedAt
  }

- Invite {
    id,
    homeId,
    code,               // UNIQUE (CITEXT; Crockford Base32, 6 chars)
    revokedAt           // NULL = active; set if owner rotates/revokes
    usedCount,          // total times used (analytics)
    createdAt,
    // Valid iff: home.isActive = true AND revokedAt IS NULL
  }

- homes.create()
  -> Creates a home; caller becomes owner & current member. Returns `{ home: { id } }`.

- invites.get_active(homeId)
  -> Returns the current active invite for the home.
  (No ttl/maxUses; permanent until revoked or home deactivated.)

- invites.revoke(homeId)
  -> Revokes the current invite (for manual rotation). Optional but useful.

- homes.join(code)
  -> Joins the home for the caller using invite code.
  Guards:
    - home.isActive = true
    - invite.revokedAt IS NULL
    - user has no other current membership (unique index enforces)

- homes.transferOwner(homeId, newOwnerId)
  -> Transfers ownership (both users must be current members).

- homes.leave(homeId)
  -> Closes caller's current membership stint (validTo = now()).
  If that was the last current member:
    - home.isActive = false
    - home.deactivatedAt = now()

- members.listActiveByHome(homeId)
  -> Lists current members only (isCurrent = true).


Client access: via repositories only (no direct Supabase in UI/BLoC). Offline: none (read-through). Performance: TTI <= 1.5s; join p95 <= 400 ms.


## Workflow
- Work verticals per feature: Data model/contract → Repository → BLoC → UI → Tests → DoD artifacts.
- Backlog hierarchy: Epic → Feature → Story → Task.
- Acceptance criteria: Given / When / Then + DoD checklist.
- Unknowns: PR must contain Assumptions; mark Blocking if delivery halted.
- Merge/trunk checklist (applies to trunk and PRs):
  - `dart run tool/check_all.dart` (single source of truth for guardrails)
  - `dart format` + `dart analyze`
  - `flutter test` (add widget/RTL/golden tests when relevant)
  - Screenshots/GIFs for happy paths when UI changes
- If you add a new guardrail, add it to `check_all.dart` (and only that).
- If adding or changing a core UI primitive, update `docs/ui/core_ui_primitives.md` and get Planner + Docs review


## Guardrails (Prohibited)
- Keep CC within `docs/engineering/complexity_budget_v1.md`; allowed exceptions require `CC_BUDGET_EXCEPTION` with expiry; hard caps are non-negotiable.
- No schema change without migration + RLS policies + reviews.
- Accessibility baseline must be honored: use Kinly primitives with built-in semantics/min 48dp touch targets; respect reduced motion. Changes to the accessibility contract require Planner approval and Design System review.
- Registry ordering must use the shared comparator in `lib/foundation/registry/**`.
- Dark/light handling must be palette-driven: primitives and feature UI must not branch on `Brightness.dark`; use theme extensions (`KinlyControlColors`, `KinlyColorTokens`, `KinlySections`) instead.
- BLoC event handlers: register events with `on<Event>(_onEvent);` and implement `_on<Event>` methods (no inline closures); keep branching in small helpers to stay within the complexity budget.

## Shared Enums
- Domain-owned/shared enums live in `lib/core/<domain>/enums/` (e.g., `lib/core/homes/enums/leave_outcome.dart`).
- Keep BLoC/UI-only enums next to the widget/state files that own them; only promote to `lib/core/.../enums` if they are part of a cross-agent contract.
- Repositories and Supabase/DB co-own the enums under `lib/core/**/enums`; update both sides when contract values change.
- It fails if a `lib/core/**` file defines an enum outside an `enums/` folder.

## Logging Standard
- Ownership: Planner defines taxonomy + severity expectations, Docs maintains this section, Release verifies sinks in CI.
- Implementation: UI/BLoC/Repositories resolve `Logger` from `get_it` (or inject it) and call `debug/info/warn/error`.
- Tests: provide a fake `Logger` or rely on the default `DebugLogger`; never reintroduce `print`/`debugPrint`.
- Tech debt: if a new sink or structured schema is needed, raise a Planner ticket + ADR before modifying the contract.

## Governance & Review
- Approvals: Schema/Migration/RLS → DB + Planner; Deep‑link logic → Deep Linking + Planner; CI/Infra → Release + Planner.
- PR artifacts: Test plan, screenshots, migration scripts, ADR if architecture impacted.
- ADRs: `docs/adr/ADR-XXXX-title.md`.

## CI/CD Notes
- CI runs `flutter format`, `dart analyze`, `flutter test`, and builds APK/IPA.
- APK growth budget: warn if >5% vs. main (non‑blocking step for now).
- Secrets: GitHub OIDC → Supabase. No long‑lived keys.

## Deep Linking
- Join flow: `/join/:code` → OAuth if needed → `homes.join(code)` → Hub.
- Host/prefix TBD (e.g., `https://makinglifeeasie.com/kinly/join/:code`) — captured as TODO until assigned.
