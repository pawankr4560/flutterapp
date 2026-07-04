class AppConfig {
  const AppConfig._();

  static const String appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String _defaultBaseUrl =
      'https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api';

  static const String _baseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const String _devBaseUrl = String.fromEnvironment(
    'DEV_API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static const String _stagingBaseUrl = String.fromEnvironment(
    'STAGING_API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static const String _prodBaseUrl = String.fromEnvironment(
    'PROD_API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride;
    }

    return switch (appEnvironment.toLowerCase()) {
      'prod' || 'production' => _prodBaseUrl,
      'stage' || 'staging' => _stagingBaseUrl,
      _ => _devBaseUrl,
    };
  }

  static const String cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'lawxbyrf',
  );

  static const String cloudinaryUploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'upload_image',
  );

  static const String cloudinaryFolder = String.fromEnvironment(
    'CLOUDINARY_FOLDER',
    defaultValue: 'loan-tracker/documents',
  );
}


