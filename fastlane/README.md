# Fastlane

Android lanes live here. The `deploy_closed` lane uploads the prod bundle to Google Play closed testing (beta track).

## Usage

```bash
# From repo root
flutter build appbundle --release --flavor prod -t lib/main.dart --dart-define-from-file=env/prod.json
fastlane android deploy_closed
```

### Environment

- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`: Path to the Play service account JSON (CI writes `config/google_play_key.json`).
- `AAB_PATH` (optional): Override bundle path; default is `build/app/outputs/bundle/prodRelease/app-prod-release.aab`.
- `PLAY_TRACK` (optional): Defaults to `beta` (closed testing). Override for another track.
- `PLAY_RELEASE_STATUS` (optional): Defaults to `completed`; set to `draft`/`inProgress` as needed.
- `PLAY_VALIDATE_ONLY` (optional): Set to `true` to run validation without uploading.
