class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://localhost:7002/api',
  );

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
