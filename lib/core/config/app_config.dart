class AppConfig {
  const AppConfig._();

  static const String baseUrl =
      'https://testwbapp-ecg6d9grbnguf0b2.centralindia-01.azurewebsites.net/api';

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
