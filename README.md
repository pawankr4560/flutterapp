# loan_tracker_application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuration

The API base URL is configured in `lib/core/constants/app_config.dart`.

- Default API URL: `https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api`
- Direct override: `--dart-define=API_BASE_URL=https://example.com/api`
- Environment selection: `--dart-define=APP_ENV=dev|staging|prod`
- Per-environment overrides:
  - `--dart-define=DEV_API_BASE_URL=https://dev.example.com/api`
  - `--dart-define=STAGING_API_BASE_URL=https://staging.example.com/api`
  - `--dart-define=PROD_API_BASE_URL=https://api.example.com`

Cloudinary defaults are intentionally left unchanged for this environment:

- `CLOUDINARY_CLOUD_NAME=lawxbyrf`
- `CLOUDINARY_UPLOAD_PRESET=upload_image`
 
These values are unsigned-upload identifiers, not application secrets.
