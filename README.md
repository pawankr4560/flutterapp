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

The API base URL is configured using a Dart define flag.

- Default local and production value: `https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api`
- Override it at build or run time using:

```bash
flutter run --dart-define=API_BASE_URL=https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api
flutter build apk --dart-define=API_BASE_URL=https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api
```

This value is read from `AppConfig.baseUrl` in `lib/core/config/app_config.dart`.
