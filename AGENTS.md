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

- Member {
    id,
    userId,
    homeId,
    role (owner|member),
    createdAt,
    updatedAt,
    leftAt              // NULL = active membership; timestamp = user left this home
  }

- Invite {
    id,
    homeId,
    code,               // UNIQUE
    createdBy,
    createdAt,
    updatedAt,
    revokedAt           // NULL = active; set if owner rotates/revokes
    // Valid iff: home.isActive = true AND revokedAt IS NULL
  }

- homes.create()
  → Creates a home; caller becomes owner & active member. Returns `{ home: { id } }`.

- invites.getOrCreate(homeId)
  → Returns the current active invite for the home, or creates one if none exists.
  (No ttl/maxUses; permanent until revoked or home deactivated.)

- invites.revoke(homeId)
  → Revokes the current invite (for manual rotation). Optional but useful.

- homes.join(code)
  → Joins the home for the caller using invite code.
  Guards:
    - home.isActive = true
    - invite.revokedAt IS NULL
    - user has no other active membership (unique index enforces)

- homes.transferOwner(homeId, newOwnerId)
  → Transfers ownership (both users must be active members).

- homes.leave(homeId)
  → Sets member.leftAt = now() for caller.
  If that was the last active member:
    - home.isActive = false
    - home.deactivatedAt = now()

- members.listActiveByHome(homeId)
  → Lists active members only (leftAt IS NULL).

- members.listByHome(homeId)
  → Lists all historical memberships (active + past).

Client access: via repositories only (no direct Supabase in UI/BLoC). Offline: none (read‑through). Performance: TTI ≤ 1.5s; join p95 ≤ 400 ms.

## Workflow
- Work verticals per feature: Data model/contract → Repository → BLoC → UI → Tests → DoD artifacts.
- Backlog hierarchy: Epic → Feature → Story → Task.
- Acceptance criteria: Given / When / Then + DoD checklist.
- Unknowns: PR must contain Assumptions; mark Blocking if delivery halted.
- Merge/trunk checklist (applies to trunk and PRs):
  - `dart run tool/check_design_system.dart` (see Design System section)
  - `dart format` + `dart analyze`
  - `flutter test` (add widget/RTL/golden tests when relevant)
  - `dart run tool/check_i18n.dart`
  - `dart run tool/check_directionality.dart`
  - `dart run tool/check_enums.dart`
  - `dart run tool/check_copy_contract.dart` (see `docs/contracts/copy_taste_v1_1.md`)
  - `dart run tool/check_shared_understanding_copy.dart` (see `docs/contracts/shared_understanding_copy_v1.md`)
  - Screenshots/GIFs for happy paths when UI changes
- No raw Material buttons/loaders; use Kinly primitives; strings via `S.of(context)`; keep padding/alignments directionality-safe
- If adding or changing a core UI primitive, update `docs/ui/core_ui_primitives.md` and get Planner + Docs review
- Theme tokens: do not use raw alphas or null-aware on required theme extensions. Use `KinlyOpacity`, `Spacing`, `Corners`, `KinlyTypography`, and color/tokens via theme extensions; use the closest token rather than literals.


## Guardrails (Prohibited)
- No direct Supabase/HTTP in UI/BLoC.
- No schema change without migration + RLS policies + reviews.
- No hard-coded UI strings (use i18n). Run `dart run tool/check_i18n.dart`
  before submitting a PR; reviewers (Codex) will block if this check fails.
- Copy: follow `docs/contracts/copy_taste_v1_1.md` for voice, surfaces, and metadata, and `docs/contracts/shared_understanding_copy_v1.md` for framing; CI enforces objective rules via `dart run tool/check_copy_contract.dart` and `dart run tool/check_shared_understanding_copy.dart`.
- Accessibility baseline must be honored: use Kinly primitives with built-in semantics/min 48dp touch targets; respect reduced motion; run contrast/i18n/directionality checks. Changes to the accessibility contract require Planner approval and Design System review.
- All UI must be directionality-safe. Use directional APIs
  (`EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`,
  `TabBar` that mirrors), and add an RTL widget/golden test for new screens.
  Run `dart run tool/check_directionality.dart` before PR to block LTR-only
  paddings/alignments.
- No ad-hoc logging (no `print`/`debugPrint`/console writes); all logs go through `core/logging/logger.dart` via DI so Release can route them.
- No public endpoints for invites or joins.
- No writes outside approved RPCs.
- No raw `CircularProgressIndicator` usage; UI/BLoC agents must use `lib/core/ui/kinly_loader.dart` for loaders to keep branding consistent.
- No raw Material buttons/FABs for CTAs. Use Kinly primitives so light/dark colors and spacing stay consistent:
  - Filled CTAs: `lib/core/ui/buttons/kinly_filled_button.dart` (`text/icon`, `destructive*`, `fullWidth` as needed)
  - Outlined CTAs: `lib/core/ui/buttons/kinly_outlined_button.dart` (`text/icon`, `compact/fullWidth`)
  - FABs: `lib/core/ui/buttons/kinly_fab.dart` (inherits add-tile palette; supports hero/mini/tooltip)
  - Add tile: `lib/core/ui/buttons/kinly_add_tile_button.dart`
- UI must use Kinly primitives under `lib/core/ui/**`; new or changed primitives require Planner + Docs review; update `docs/ui/core_ui_primitives.md`.
- Dark/light handling must be palette-driven: primitives and feature UI must not branch on `Brightness.dark`; use theme extensions (`KinlyControlColors`, `KinlyColorTokens`, `KinlySections`) instead.
- Design System: use theme extensions for spacing/radius/elevation/motion/color/typography; no hard-coded colors/paddings/text styles; no raw `SnackBar`/`AlertDialog`/`BottomSheet`—use `KinlySnackBar`/`KinlyAlertDialog`/`KinlyBottomSheet`; inputs via Kinly wrappers.

## Shared Enums
- Domain-owned/shared enums live in `lib/core/<domain>/enums/` (e.g., `lib/core/homes/enums/leave_outcome.dart`).
- Keep BLoC/UI-only enums next to the widget/state files that own them; only promote to `lib/core/.../enums` if they are part of a cross-agent contract.
- Repositories and Supabase/DB co-own the enums under `lib/core/**/enums`; update both sides when contract values change.
- Run `dart run tool/check_enums.dart` locally and in CI; it fails if a `lib/core/**` file defines an enum outside an `enums/` folder.

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
