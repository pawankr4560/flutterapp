class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api',
  );
}
