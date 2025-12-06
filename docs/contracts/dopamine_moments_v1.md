# Dopamine Moments — Unified Contract (v1)

Scope: Flow, Share, Pulse/Gratitude, Reflection (Kinly Home-only MVP)

## Purpose
- Gentle, harmony-first completion feedback; no gamification/confetti/streak pressure.
- Reinforce “Together feels lighter” and keep dopamine subtle, brief, and accessible.

## Palette & Tokens (reuse theme tokens)
- Primary warmth: `tealBrand`, `honeyAccent`.
- Section alignment:
  - Flow: tealBrand + honeyAccent (matches `sections.flow`).
  - Share: tealBrand accent; honey icon allowed (matches `sections.share`).
  - Pulse/Gratitude/Reflection: honey-forward for icon/accent (matches `sections.pulse` update).
  - Reflection: honey glow + teal base; dark-mode glow with lower opacity/radius.
- Dark mode: reduce bloom/glow opacity to avoid halos; maintain contrast.

## Strength & Motion (express via dp/scale/opacity)
- Flow: medium 6–10dp travel, scale 1.05–1.08, opacity 0.65–0.8; high 10–14dp, 1.08–1.12, 0.8–0.9.
- Share: low–medium 4–8dp, 1.03–1.06, 0.55–0.7.
- Pulse/Gratitude: medium 6–10dp, 1.05–1.08, 0.65–0.8.
- Reflection: medium–high 8–14dp, 1.08–1.12, 0.75–0.9 with soft bloom.
- Timing per milestone (total 320–560ms, never >650ms):
  - Flow: 120ms draw + 180–260ms ripple/sparkle fade (~320–380ms).
  - Share: 180–220ms check draw + 180ms lift/settle (~360–420ms).
  - Pulse/Gratitude: 180–220ms shimmer + 180–240ms glow (~360–460ms).
  - Reflection: 220–280ms bloom + 260–320ms glow fade (~480–560ms).
- Easing: `easeOut` (0.25, 0.1, 0.25, 1); no bounce.

## Reduce Motion Alternate
- Replace motion with 180–220ms opacity fade; scale capped at 1.02; static icon (sparkle/check/bloom/shimmer ring); no haptics.

## Copy & Typography
- Affirmation: Body/Lg semibold token; <12 words.
- Echo (optional): Body/Sm regular; max 80 chars; only if provided.

## Haptics (mobile)
- Flow: light impact.
- Share: light or none (money-sensitive).
- Pulse/Gratitude: light.
- Reflection: medium single impact.
- Off when Reduce Motion or system haptics disabled.

## Trigger, Placement, Dismiss
- Trigger only after confirmed success from BLoC (no optimistic show).
- Anchor to action origin (CTA tap point). Affirmation card hovers near origin respecting safe areas; avoid screen-center overlays by default.
- Auto-dismiss after 2s; if user navigates away, finish or cancel silently.

## Queue & Cooldown
- One at a time. If a new event fires within 1s, drop the older and show the latest.
- Global cooldown 3–5s between dopamine events; optional per-day cap (e.g., 10) to avoid fatigue.

## Echo Source of Truth
- BLoC success payload supplies `optionalEcho` (pre-validated). UI only renders; never infers/scrapes.

## Accessibility
- Respect Reduce Motion; no strobe/flash; duration ≤650ms.
- High contrast; readable at large fonts; RTL mirrored animations/placement.

## QA Acceptance Criteria
- Light/dark snapshots per milestone; contrast OK.
- RTL verified; animations/glows mirror.
- Reduce Motion path shows static/fade; haptics off.
- Cooldown/queue verified: rapid taps yield one dopamine.
- Telemetry fires once per success.

## Telemetry (non-gamified)
- Event: `dopamine_shown`.
- Properties: `milestone` (flow/share/pulse/reflection), `strength` (low/med/high), `echo_present` (bool), `reduce_motion` (bool), `haptic_used` (bool), `theme` (light/dark).
