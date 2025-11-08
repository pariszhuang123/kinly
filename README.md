# kinly
[![CI Trunk](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/ci.yml)

<!-- TODO: replace OWNER/REPO with your GitHub org/repo -->

Kinly is a shared-household coordination app that helps people manage chores, repairs, expenses, and gratitude together. Built with Flutter and Supabase, it focuses on creating household harmony through shared visibility, gentle reminders, and collaborative tools for everyday living.

## Run with flavors and dart-define

Recommended: use Flutter flavors and compile-time defines (no .env files).

- Dev run
  - Create `env/dev.json` from sample: copy `env/dev.sample.json` -> `env/dev.json` and fill values.
  - Run: `flutter run --flavor dev -t lib/main.dart --dart-define-from-file=env/dev.json`

- Prod build (CI/local)
  - Provide `env/prod.json` at build time (do not commit real secrets).
  - Build: `flutter build apk --flavor prod --dart-define-from-file=env/prod.json`

- Access in code
  - Use `AppConfig` (see `lib/core/config/app_config.dart`). Call `AppConfig.validate()` early in `main()`.

Notes
- Keep prod secrets out of git. Supabase anon key is safe to ship; never embed service-role keys.
- Ensure Android/iOS flavors/schemes are configured (bundle id suffix for dev).

## CI overview

- Lint/Test/Coverage gate (95%): runs on PRs and main.
- Android Dev APK: flavor `dev`, uses `env/dev.json` synthesized from secrets.
- Supabase migrations: Dev first, then Prod (gated by environment).
- Android Prod AAB: flavor `prod`, uses `env/prod.json`, uploads to Play (internal).
- iOS builds: performed manually via Xcode (no CI job).
