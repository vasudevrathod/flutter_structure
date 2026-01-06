class EnvConfig {
  static const apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://dev-api.com',
  );
  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'My App (Local)',
  );

  static const bool isProduction = bool.fromEnvironment('IS_PRODUCTION');
}
